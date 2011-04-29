/* xxbcrp008.p 打开已结出货计划单,以冲账                                   */
/* REVISION: 1.0         Last Modified: 2008/10/27   By: Roger   NO ECO    */ 
/*-Revision end------------------------------------------------------------*/

/*所有table&逻辑未考虑参考号*/



{mfdtitle.i "2+ "}



define var nbr  as char format "x(8)" .
define var ship_to as char format "x(8)"  .

define var v_file as char format "x(30)" .
define var v_line as integer .
define var v_qty_lad like ld_qty_oh .
define var v_trnbr   like tr_trnbr .

define var v_update  like mfc_logical no-undo.               /*for updateall */
define var yn        like mfc_logical no-undo.               /*for dispall */
define var yn2       like mfc_logical no-undo.               /*for dispall */
define var aa_from_recno as recid format "->>>>>>9".   /*for dispall */       
define var first_sw_call as logical initial true.     /*for dispall */ 

define variable xapplication as com-handle. /*for excel*/  
define variable xworkbook as com-handle.    /*for excel*/  
define variable xworksheet as com-handle.   /*for excel*/  
define variable x_row as integer init 1.    /*for excel*/  
define variable x_col as integer init 1.    /*for excel*/  

define temp-table temp1 /*出货需求明细*/
    field t1_sonbr    like so_nbr
    field t1_soline   like sod_line
    field t1_part     like sod_part 
    field t1_lot      like ld_lot 
    field t1_loc      like ld_loc 
    field t1_qty_pk   like sod_qty_ord 
    field t1_select    as char format "x(1)"
    field t1_line      as integer 
    .


/*GUI preprocessor Frame A define A*/
&SCOPED-DEFINE PP_FRAME_NAME 

FORM  
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  

    nbr         colon 18 label "计划单号" 
    ship_to     colon 18 label "交运地"

    /*
    skip(2)
    "说明: 1.选中的备料项次做改变,其他项次不变 "     colon 15 
    "      2.选中的备料项次状态:由已结改为备料中"    colon 15
    "      3.选中的备料项次备料数:清零"              colon 15
    */
    SKIP(4)  
with frame a side-labels width 80 NO-BOX THREE-D .

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = "".
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a =
FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. 

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


/*setFrameLabels(frame a:handle).*/

find last xpk_mstr no-lock no-error .
nbr = if avail xpk_mstr then xpk_nbr else "" .

{wbrp01.i}
mainloop:
repeat: 
    for each temp1 : delete temp1 .  end.

    clear frame a no-pause .
    disp nbr ship_to with frame a  .

    update nbr with frame a editing:
        {mfnp11.i xpk_mstr xpk_nbr2 xpk_nbr "input nbr" }
        IF recno <> ?  THEN DO:
            DISP xpk_nbr @ nbr xpk_shipto @ ship_to
            with frame a.
        END.  /*if recno<> ?*/
    end. 
    assign nbr .

    if nbr = "" then do:
        message "请输入计划单号" .
        undo,retry .
    end.
    else do: /*检查单号是否存在,且已经关闭 */
        find first xpk_mstr where xpk_nbr = nbr no-lock no-error .
        if not avail xpk_mstr then do:
            message "无效计划单号" view-as alert-box.
            undo,retry .
        end.
        else do:
            find first xpk_mstr where xpk_nbr = nbr and xpk_stat = "C" no-lock no-error .
            if not avail xpk_mstr then do:
                message "计划单未关闭,不需再打开" view-as alert-box.
                undo,retry .
            end.
        end.
        assign nbr = xpk_nbr ship_to = xpk_shipto .

        run selectall  .   /*寻找未结记录*/

        reopenloop:  /*excel预览后,不更新的话,还可以再修改*/
        do on error undo, return error on endkey undo, return error:
            run dispall.    /*清单筛选*/
                hide message no-pause.
                if yn2 then yn = no.
                if yn = no then undo mainloop ,retry.   
            run updateall . /*更新*/
                if v_update = no then undo reopenloop,retry reopenloop . 
        end. /*reopenloop*/
    end. /*if nbr <> "" */

end. /* mainloop */
{wbrp04.i &frame-spec = a}




/*-----------------------------------------------------------------------------------------------------------------------------------*/
procedure selectall : 
do on error undo, return error on endkey undo, return error:
    for each xpkd_det 
        where xpkd_nbr = nbr 
        and xpkd_qty_pk <> 0 
        no-lock 
        break by xpkd_sonbr by xpkd_soline by xpkd_lot by xpkd_loc :
        if first-of(xpkd_loc) then do:
            v_qty_lad = 0 .
        end. /*if first-of(*/
        
        v_qty_lad = v_qty_lad + xpkd_qty_pk .

        if last-of(xpkd_loc) then do:
            find first temp1 where t1_sonbr = xpkd_sonbr and t1_soline = xpkd_soline and t1_part = xpkd_part and t1_lot = xpkd_lot and t1_loc = xpkd_loc no-error.
            if not avail temp1 then do:
                v_line = 0 .
                find first xpk_mstr 
                    where xpk_sonbr = xpkd_sonbr 
                    and xpk_soline  = xpkd_soline 
                    and xpk_part    = xpkd_part 
                    and xpk_lot     = xpkd_lot 
                    and xpk_loc     = xpkd_loc 
                no-lock no-error .
                if avail xpk_mstr then assign v_line = xpk__int01.
                else do:
                    find first xpk_mstr 
                        where xpk_sonbr = xpkd_sonbr 
                        and xpk_soline  = xpkd_soline 
                        and xpk_part    = xpkd_part  
                        and xpk_loc     = "**无可用库存**"
                    no-lock no-error .
                    if avail xpk_mstr then assign v_line = xpk__int01.
                end.
                create  temp1.
                assign  t1_sonbr    = xpkd_sonbr 
                        t1_soline   = xpkd_soline 
                        t1_part     = xpkd_part 
                        t1_lot      = xpkd_lot
                        t1_loc      = xpkd_loc
                        t1_qty_pk   = v_qty_lad
                        t1_line     = v_line
                        .
            end.
        end. /*if last-of(*/
    end.
end. 
end procedure. /*selectall*/





/*-----------------------------------------------------------------------------------------------------------------------------------*/

procedure dispall : 
disploop:
repeat :

    form
       t1_select       column-label "*"
       t1_line         column-label "计划单项"
       t1_sonbr        column-label "销售订单"
       t1_soline       column-label "SO项" format ">>>"
       t1_part         column-label "项目号"
       t1_lot          column-label "批号"
       t1_loc          column-label "库位" 
       t1_qty_pk       column-label "备料数"
    with frame y 
    row 4 centered overlay three-d  .

    yn = no.
    yn2 = no. 
    view frame y .
    sw:
    do on endkey undo, leave: /*xp001*/  
        message "请按 'enter'或'space' 键选择 要再次打开的装箱记录 .".         
        {xxswxp002.i
            &detfile      = temp1
            &scroll-field = temp1.t1_select
            &framename    = "y"
            &framesize    = 10
            &framewidth   = 75
            &sel_on       = ""*""
            &sel_off      = """"
            &display1     = temp1.t1_select
            &display2     = t1_line  
            &display3     = t1_sonbr   
            &display4     = t1_soline
            &display5     = t1_part  
            &display6     = t1_lot   
            &display7     = t1_loc   
            &display8     = t1_qty_pk
            &exitlabel    = sw
            &exit-flag    = first_sw_call 
            &record-id    = aa_from_recno

        }
        if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("f4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("ctrl-e") then do:
            yn2 = no.
            {pxmsg.i &msgnum=36 &errorlevel=1 &confirm=yn2 } /* 请确认退出 */
            if yn2  then do:
                undo disploop, leave .
            end.
                
        end.        
        else do:
            yn = no.
            {pxmsg.i &msgnum=12 &errorlevel=1 &confirm=yn } /* 所有信息是否正确 */
            if yn = no then do:
                yn2 = no.
                {pxmsg.i &msgnum=36 &errorlevel=1 &confirm=yn2 } /* 请确认退出 */
                if yn2  then do:
                    undo disploop, leave .
                end.
                else undo sw, retry.
            end.
            if yn = yes then leave disploop.
        end.
    end. /*sw*/

    hide message no-pause.
    hide frame y no-pause.   

end. 
end procedure. /*dispall*/





/*-----------------------------------------------------------------------------------------------------------------------------------*/

procedure updateall : 
do on error undo, return error on endkey undo, return error:
    v_update = no.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=v_update } /* 请确认更新 */
    if v_update then do:
        find first temp1 where t1_select = "*" no-error.
        if not avail temp1 then do:
            message "未选择任何项次." view-as alert-box.
            undo,leave .
        end.
        else do:
            v_file = "C:\so_recall_" + string(year(today),"9999") + string(month(today),"99") + string(day(today),"99") + ".txt" .
            output to value(v_file) append.
                put "/*----------------So_Recall_History_Record ---------------------*/" skip .
                put skip(1).
                put "开始时间:" string(string(year(today),"9999") + "/" + string(month(today),"99") + "/" + string(day(today),"99") + " " + string(time,"HH:MM") ) format "x(50)" skip .

                for each temp1 where t1_select = "*" :

                        /*实际装箱数量更新为零*/
                        for each xpkd_det 
                            where xpkd_sonbr = t1_sonbr 
                            and xpkd_soline  = t1_soline 
                            and xpkd_part    = t1_part 
                            and xpkd_lot     = t1_lot 
                            and xpkd_loc     = t1_loc :

                            assign xpkd_qty_pk = 0 .
                        end. /*for each xpkd_det*/
                        
                        /*计划单主档状态改为A*/
                        find first xpk_mstr 
                            where xpk_sonbr = t1_sonbr 
                            and xpk_soline  = t1_soline 
                            and xpk_part    = t1_part 
                            and xpk_lot     = t1_lot 
                            and xpk_loc     = t1_loc 
                        no-error .
                        if avail xpk_mstr then assign xpk_stat = "A" .
                        else do:
                            find first xpk_mstr 
                                where xpk_sonbr = t1_sonbr 
                                and xpk_soline  = t1_soline 
                                and xpk_part    = t1_part  
                                and xpk_loc     = "**无可用库存**"
                            no-error .
                            if avail xpk_mstr then assign xpk_stat = "A" .
                        end.

                        /*之前做的出货记录,删掉计划单号:tr__chr15 */
                        for each tr_hist 
                            where tr_nbr   = t1_sonbr 
                            and tr_line    = t1_soline 
                            and tr_part    = t1_part 
                            and tr_type    = "ISS-SO" 
                            and tr__chr15  = nbr 
                            and tr_qty_loc = - t1_qty_pk
                            :
                            assign tr__chr15 = "" v_trnbr = tr_trnbr .
                        end.


                        disp nbr         column-label "计划单"
                             t1_line     column-label "计划单项" 
                             t1_sonbr    column-label "销售订单" 
                             t1_soline   column-label "订单项"
                             t1_part     column-label "项目号"
                             t1_lot      column-label "批号"
                             t1_loc      column-label "库位"
                             t1_qty_pk   column-label "出货数"
                             v_trnbr     column-label "原事务号"
                        with stream-io width 200 .



                end. /*for each temp1*/

                put skip(1) .
                put "结束时间:" string(string(year(today),"9999") + "/" + string(month(today),"99") + "/" + string(day(today),"99") + " " + string(time,"HH:MM") )  format "x(50)" skip .
                put skip(3) .
            output close.
            message "选择的计划单项次已打开,详见文件" v_file view-as alert-box title "" .
        end. /*else do:*/
    end.  /*if v_update then*/  
end. 
end procedure. /*updateall*/





