/* xxsqtymt02.p 全年安全库存由xsqty_mstr转移至fc_det,以实现mrp可查虚拟订单    */
/* REVISION: 090728.1      Create Date: 20090717  BY: Softspeed roger xiao    */
/* REVISION: 090805.1      Create Date: 20090805  BY: Softspeed roger xiao    */ /*转GUI界面，改成固定地点，加宽数量格式*/
/* SS - 090820.1 By: Roger Xiao */

/* SS - 090820.1 - RNB
   roger: fc_det(季节性制造)应该直接存放(其他月安全库存-本月安全库存),而不是虚拟订单
   SS - 090820.1 - RNE */

/* SS - 100906.1  By: Roger Xiao */ /*message时会pause,*/
/*-Revision end---------------------------------------------------------------*/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT


/* DISPLAY TITLE */
{mfdtitle.i "100906.1"}

define variable part  like pt_part no-undo.
define variable part1 like pt_part no-undo.

define variable site  like in_site no-undo.
define variable site1 like in_site no-undo.

define variable line like pt_prod_line no-undo.
define variable line1 like pt_prod_line no-undo.

define variable type like pt_part_type no-undo.
define variable type1 like pt_part_type no-undo.

define variable buyer like pt_buyer no-undo.
define variable buyer1 like pt_buyer no-undo.

define variable vend like pt_vend no-undo.
define variable vend1 like pt_vend no-undo.

define var v_j        as integer .
define var v_lastday  as date .
define var v_i        as integer.
define var v_ok       like mfc_logical initial yes.
define var v_qty      as decimal no-undo.

define var l_mrp_qty1     like mrp_qty         no-undo.
define var l_mrp_recid1   as   recid           no-undo.
define var l_mrp_qty2     like mrp_qty         no-undo.
define var l_mrp_recid2   as   recid           no-undo.
define var l_flag         like mfc_logical     no-undo.



/*GUI preprocessor Frame A define*/ 
&SCOPED-DEFINE PP_FRAME_NAME A

form
    SKIP(1)
    part           colon 15
    part1          label {t001.i} colon 49 skip
    site           colon 15
    site1          label {t001.i} colon 49 skip
    buyer          colon 15
    buyer1         label {t001.i} colon 49 skip
    line           colon 15
    line1          label {t001.i} colon 49 skip
    type           colon 15
    type1          label {t001.i} colon 49 skip
    vend           colon 15
    vend1          label {t001.i} colon 49 skip
    
    skip(1)
    v_ok           colon 28 label "重新产生所有虚拟订单"
    skip(2)
with frame a  side-labels width 80 attr-space.
/*GUI preprocessor Frame A undefine*/ 
&UNDEFINE PP_FRAME_NAME


setFrameLabels(frame a:handle).


/* DISPLAY */
view frame a.


{wbrp01.i}

mainloop:
repeat with frame a:
    clear frame a no-pause .

    ststatus = stline[1].
    status input ststatus.

   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if line1 = hi_char then line1 = "".
   if type1 = hi_char then type1 = "".
   if buyer1 = hi_char then buyer1 = "".
   if vend1 = hi_char then vend1 = "".


    update 
        part    
        part1   
        site    
        site1   
        buyer   
        buyer1  
        line    
        line1   
        type    
        type1   
        vend    
        vend1          
        v_ok 
    with frame a .


   if part1 = ""  then part1  = hi_char.
   if site1 = ""  then site1  = hi_char.
   if line1 = ""  then line1  = hi_char.
   if type1 = ""  then type1  = hi_char.
   if buyer1 = "" then buyer1 = hi_char.
   if vend1 = ""  then vend1  = hi_char.    
    
    if v_ok = no then do :
        message "错误:用户取消操作" .
        undo mainloop, retry mainloop.
    end.

    find first xsqty_mstr 
        where xsqty_part >= part and xsqty_part <= part1 
    no-lock no-error .
    if not avail xsqty_mstr then do :
        message "错误:无安全库存记录" .
        undo mainloop, retry mainloop.
    end.

    deleteloop:
    do on error undo ,retry :

        for each pt_mstr no-lock
               where (pt_part >= part and pt_part <= part1)
               and (pt_prod_line >= line and pt_prod_line <= line1)
               and (pt_part_type >= type and pt_part_type <= type1)
               and (pt_buyer >= buyer and pt_buyer <= buyer1)
               and (pt_vend >= vend and pt_vend <= vend1)
               and (pt_site >= site and pt_site <= site1 ) ,
            each fc_det where fc_part = pt_part :
            fc_qty = 0.
           {gprun.i ""fcsbqty.p""
                    "(buffer fc_det,
                    input  yes,
                    output l_mrp_qty1,
                    output l_mrp_qty2,
                    output l_mrp_recid1,
                    output l_mrp_recid2,
                    output l_flag)"}
            if l_flag = no then do:
                message "虚拟订单无法删除,料号:" fc_part view-as alert-box.
                next.
            end.
            delete fc_Det .
        end. /* for each fc_det */


        createloop:
        do on error undo ,retry :
        
        v_j = 0 .
        for each pt_mstr no-lock
               where (pt_part >= part and pt_part <= part1)
               and (pt_prod_line >= line and pt_prod_line <= line1)
               and (pt_part_type >= type and pt_part_type <= type1)
               and (pt_buyer >= buyer and pt_buyer <= buyer1)
               and (pt_vend >= vend and pt_vend <= vend1)
               and (pt_site >= site and pt_site <= site1 ) ,
           each xsqty_mstr no-lock 
               where xsqty_part = pt_part 
           break by xsqty_part :
                v_j = v_j + 1 .
/* SS - 100906.1 - B 
   SS - 100906.1 - E */
/* SS - 100906.1 - B */
pause 0 .
/* SS - 100906.1 - E */
                message "正在处理第" v_j "个料号:" xsqty_part . 

                v_i = 0.
                do v_i = month(xsqty_date) to 12 : /*本年*/
                    /*run lastday (input date(v_i,01,year(xsqty_date)), output v_lastday) .*/
                    v_lastday = date(v_i,01,year(xsqty_date)) .

                    v_qty = if v_i = month(xsqty_date) then 0 else xsqty_sqty[v_i] - pt_sfty_stk .
                    if v_qty < - pt_sfty_stk then v_qty = - pt_sfty_stk . 


                    if v_qty <> 0 then do:
                        find first fc_det where fc_part = xsqty_part and fc_site = xsqty_site and fc_start = v_lastday no-error.
                        if not avail fc_det then do:
                            create fc_det .
                            assign fc_part  = xsqty_part 
                                   fc_site  = xsqty_site 
                                   fc_start = v_lastday
                                   fc_qty   = v_qty.
                        end.
                        else do:
                            fc_qty = fc_qty + v_qty .
                        end.

                       {gprun.i ""fcsbqty.p""
                                "(buffer fc_det,
                                input  no,
                                output l_mrp_qty1,
                                output l_mrp_qty2,
                                output l_mrp_recid1,
                                output l_mrp_recid2,
                                output l_flag)"}
                        if l_flag = no then do:
                            message "虚拟订单无法删除,料号:" fc_part view-as alert-box.
                            next.
                        end.

                    end. /*if v_qty <> 0*/

                end. /*本年*/

                v_i = 0.
                if month(xsqty_date) > 1 then do v_i = 1 to month(xsqty_date) - 1 : /*次年*/
                    /*run lastday (input date(v_i,01,year(xsqty_date) + 1 ), output v_lastday) .*/
                    v_lastday =  date(v_i,01,year(xsqty_date) + 1 ) .
                            
                    v_qty =  xsqty_sqty[v_i] - pt_sfty_stk .
                    if v_qty < - pt_sfty_stk then v_qty = - pt_sfty_stk .  

                    if v_qty <> 0 then do:
                        find first fc_det where fc_part = xsqty_part and fc_site = xsqty_site and fc_start = v_lastday no-error.
                        if not avail fc_det then do:
                            create fc_det .
                            assign fc_part  = xsqty_part 
                                   fc_site  = xsqty_site 
                                   fc_start = v_lastday
                                   fc_qty   = v_qty.
                        end.
                        else do:
                            fc_qty = fc_qty + v_qty .
                        end.

                        {gprun.i ""fcsbqty.p""
                                "(buffer fc_det,
                                input  no,
                                output l_mrp_qty1,
                                output l_mrp_qty2,
                                output l_mrp_recid1,
                                output l_mrp_recid2,
                                output l_flag)"}
                        if l_flag = no then do:
                            message "虚拟订单无法删除,料号:" fc_part view-as alert-box.
                            next.
                        end.

                    end. /*if v_qty <> 0*/
                end. /*次年*/
            end. /*for each xsqty_mstr*/
        end. /*  createloop: */
    end. /*  deleteloop: */
    message "执行完成,累计处理" v_j "个料号"  view-as alert-box .
end.   /*  mainloop: */

status input.


procedure lastday :
    define input  parameter vv_date1 as date .
    define output parameter vv_date2 as date .


    define var vv_year     as integer.
    define var vv_month    as integer.

    vv_year  = year(vv_date1) .
    vv_month = month(vv_date1) + 1 .
    if vv_month = 13 then 
        assign vv_year  = vv_year + 1 
               vv_month = 1 .
    vv_date2 = date(vv_month ,1,vv_year) - 1 . /*某月的最后一天*/

end procedure.