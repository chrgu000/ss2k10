/* xsfbreworklb.p 返修条码打印                                             */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */

/*  
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
{xsglefchk001.i &module =""IC""  &entity =""""  &date =today } /*会计期间检查*/
*/



/*检查是否后处理工序的机器v_tail_wc*/
{xstimetail01.i}

/*检查是否被暂停的用户,机器,工单,*/
/*之前需有v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}


define var v_qty         like xwo_qty_ord .
define var v_num         as integer  format ">>>9".    
define var v_printer     as char . 
define var v_part        like xpt_part .
define var v_inv_lot     as char format "x(18)" .
define var v_qty_ord2    like xwo_qty_ord .
define var v_qty_comp    like xwo_qty_ord .
define var v_qty_rjct    like xwo_qty_ord .
define var v_qty_rework  like xwo_qty_ord .
define var v_qty_return  like xwo_qty_ord .


define var v_fld_prn as char label "SFC返工条码默认打印机,通用代码控制字段名" .   v_fld_prn = v_fldname + "-printer" .

define var wsection      as char . /*for barcode print*/
define var ts9130        as char . /*for barcode print*/
define var av9130        as char . /*for barcode print*/
define var vv_part2      as char . /*for xsprinthist.i */ 
define var vv_lot2       as char . /*for xsprinthist.i */ 
define var vv_qtyp2      as char . /*for xsprinthist.i */ 
define var vv_filename2  as char . /*for xsprinthist.i */
define var vv_oneword2   as char . /*for xsprinthist.i */  
define var vv_label2     as char . /*for xsprinthist.i */
define var wtm_num       as char . /*for xsprinthist.i */
wtm_num = "1" .                    /*for xsprinthist.i */


form
    skip(1)
    v_wolot       colon 18 label "工单标志"
    v_op          colon 45 label "工序" 
    v_part        colon 18 label "完成品"  
    xpt_desc1      colon 45 label "品名"
    xpt_um         colon 18 label "单位"
    xpt_desc2      colon 45 label "规格"
    skip(1)       
    v_qty_ord2    colon 18 label "订购量"
    v_inv_lot     colon 45 label "批号"
    v_qty_comp    colon 18 label "已合格数"
    v_qty_rjct    colon 18 label "已报废数"
    v_qty_rework  colon 18 label "累计返工(件次)"
    v_qty_return  colon 18 label "返工完成(件次)"
    skip(1)
    v_qty         colon 18 label  "标签上数量"
    v_num         colon 45 label  "打印张数"
    v_printer     colon 18 label  "条码打印机"
    skip(5)
with frame a 
title color normal "返工标签打印"
side-labels width 80 .   

v_qty_ord2   = 0 .
v_qty_comp   = 0 .
v_qty_rjct   = 0 .
v_qty_rework = 0 .
v_qty_return = 0 .

v_num        = 1 .
v_qty        = 1 .
v_inv_lot    = "" .

/*
find first upd_det where upd_nbr = v_fldname and upd_select = integer(v_line) no-lock no-error.
v_printer = if available upd_det then upd_dev else  "" .
*/

find first xcode_mstr where xcode_fldname = v_fld_prn  and xcode_value = v_user no-lock no-error.
if available xcode_mstr then v_printer = xcode_cmmt .
else do:
    find first xcode_mstr where xcode_fldname = v_fld_prn  and xcode_value = "*" no-lock no-error.
    v_printer = if available xcode_mstr then xcode_cmmt else  "" .
end.



hide all no-pause .
view frame a . 



if v_wolot = "" then do:
    message "指令无法执行:当前工单为空."  view-as alert-box title ""  .
    undo,leave .
end.

find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
if not avail xwo_mstr then do:
    message "指令无法执行:当前工单不存在"  view-as alert-box title ""  .
    undo,leave .
end.
else do:
    /*if index("R",xwo_status ) = 0 then do:
        message "指令无法执行:当前工单状态有误" xwo_status  view-as alert-box title ""  .
        undo,leave .
    end.   *//*xp-wo-stat*/
end. /*else do:*/

find first xxwrd_det where xxwrd_wonbr = v_wonbr no-lock no-error .
if not avail xxwrd_det then do:
    message "指令无法执行:SFC工单工艺流程不存在,," .
    undo,leave .
end. /*if not avail xxwrd_det*/

find first xxwrd_det 
    where xxwrd_wolot = v_wolot 
    and xxwrd_op    = v_op 
no-lock no-error .
if not avail xxwrd_Det then do:
    message "指令无法执行:SFC工单工艺流程不存在.." .
    undo,leave .
end.
else do: 
    v_wrnbr    = xxwrd_Wrnbr .
    v_wonbr    = xxwrd_wonbr .
    
    if (xxwrd_status  <> "" and xxwrd_status <> "N") or xxwrd_close = yes then do:
        message "指令无法执行:SFC工单工艺流程已结或已删除." .
        undo,leave .
    end .
end. 



mainloop:
repeat:

        find first xxwrd_det 
            where xxwrd_wolot = v_wolot 
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
        no-lock no-error .
        if avail xxwrd_Det then do: /*x1*/
                v_qty_rework  = xxwrd_qty_rework .
                v_qty_return  = xxwrd_qty_return .
                v_qty_ord2    = xxwrd_qty_ord  .
                v_qty_comp    = xxwrd_qty_comp .
                v_qty_rjct    = xxwrd_qty_rejct .
                v_part        = xxwrd_part .
                v_inv_lot     = xxwrd_inv_lot .

        end.  /*x1*/

        disp v_qty_ord2 v_qty_comp v_qty_rjct v_qty_rework v_qty_return v_inv_lot v_part v_wolot v_op with frame a .
        find first xpt_mstr where xpt_part = v_part no-lock no-error .
        if avail xpt_mstr then disp xpt_um xpt_desc1 xpt_desc2 with frame a .
        disp v_qty v_num v_printer  with frame a .

    printloop:
    do on error undo,retry :
        do  :
            update v_qty v_num v_printer  with frame a editing:
                    if frame-field = "v_printer" then do:
                        {xstimeout02.i " quit "    } 
                        {xsmfnp01.i xprd_Det v_printer xprd_dev ""barcode"" xprd_type xprd_dev}
                        /*{xsmfnp01.i xprd_Det v_printer xprd_dev """" xprd_type xprd_dev}*找所有打印机*/
                        if recno <> ? then do:
                            display xprd_dev @ v_printer with frame a.
                        end. /* if recno <> ? */
                    end. /* if frame-field = "v_printer" */ 
                    else do:
                        status input.
                        readkey.
                        apply lastkey.                
                    end. /* else do */
            end . /*update...editing*/
            assign v_qty v_num v_printer .

            {xserr001.i "v_qty" } /*检查数量栏位是否输入了问号*/
            {xserr001.i "v_num" } /*检查数量栏位是否输入了问号*/

            if v_num = 0 then do:
                message "打印张数不可为零,请重新输入." .
                next-prompt v_num .
                undo,retry .
            end.

            if v_qty = 0 then do:
                message "标签上的数量不可为零,请重新输入." .
                next-prompt v_qty .
                undo,retry .
            end.
        
            find first xprd_det where xprd_dev = trim(v_printer) no-lock no-error.
            if not available xprd_det then do:
                message "无效打印机,请重新输入." .
                next-prompt v_printer .
                undo,retry .
            end.

            
        

            run print
               (input v_part, input xpt_desc1, input xpt_desc2, input v_inv_lot, input v_qty , 
                output vv_label2, output vv_filename2, output vv_oneword2 
               ).        /*执行打印*/
            
            wtm_num      = string(v_num) .
            vv_part2     = v_part . 
            vv_lot2      = v_inv_lot .
            vv_qtyp2     = string(v_qty) .
            run xsprinthist .  /*打印历史记录*/

        end. /*do  */

        v_date   = today.
        v_time   = time - (time mod 60) . /*保证时间点一致*/
        v_msgtxt = "" .   /*提示信息*/

        /*更新:  前笔指令操作历史记录*/
        /*
        do  :  
            {xslnprev01.i}  
        end.  
        */


        /*更新:本次指令操作历史记录*/
        do  :  /*xxfb*/

            find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
            find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.

            v_trnbr = 0 .
            v_nbrtype =  "bctrnbr" . /*xxfb_hist,交易流水号*/
            run getnbr(input v_nbrtype ,output v_trnbr) .

            create  xxfb_hist .
            assign  xxfb_trnbr       = integer(v_trnbr) 
                    xxfb_date        = today  
                    xxfb_date_end    = v_date  
                    xxfb_date_start  = v_date  
                    xxfb_time        = time - (time mod 60)  
                    xxfb_time_end    = v_time  
                    xxfb_time_start  = v_time   
                    xxfb_nbr         = ""  
                    xxfb_program     = execname
                    xxfb_wotype      = ""  
                    xxfb_qty_fb      = v_qty   
                    xxfb_rmks        = "打印张数:" + wtm_num   
                    xxfb_rsn_code    = ""  
                    xxfb_user        = v_user  
                    xxfb_op          = v_op  
                    xxfb_wc          = v_wc  
                    xxfb_wolot       = v_wolot  
                    xxfb_wonbr       = v_wonbr 
                    xxfb_part        = if avail xwo_mstr then xwo_part else ""   
                    xxfb_type        = v_line  
                    xxfb_type2       = if avail xcode_mstr and xcode_cmmt <> ""  then entry(1,xcode_cmmt,"@") else "" 
                    xxfb_update      = no  
                    .
            v_msgtxt = v_msgtxt + xxfb_type2 + ":指令完成" .
            message v_msgtxt .
        end.  /*xxfb*/

    end. /*printloop*/
end. /*mainloop:*/

hide frame a .
v_msgtxt = "".


/*---------------------------------------------------------------------------------------------------------------------------------------------------*/


procedure print:
    define input parameter v_part  like xpt_part.
    define input parameter v_desc1 like xpt_desc1.
    define input parameter v_desc2 like xpt_desc2.
    define input parameter v_lot   as char format "x(18)".
    define input parameter v_qty   as decimal .

    define output parameter v_label1    as char .
    define output parameter v_filename1 as char .
    define output parameter v_oneword1  as char .

    define var i as integer .
    define variable labelspath as character format "x(100)" .

    find first xcode_mstr where xcode_fldname = "barcode" and xcode_value ="labelspath" no-lock no-error.
    if available(xcode_mstr) then labelspath = trim ( xcode_cmmt ).
    if substring(labelspath, length(labelspath), 1) <> "/" then labelspath = labelspath + "/".
    v_label1    = labelspath + "rwk01" .
    wsection    = trim ( string(year(today)) + string(month(today),'99') + string(day(today),'99'))  + trim(string(time)) + trim(string(random(1,100))) .
    v_filename1 = trim(wsection) + ".l" .
    v_oneword1  = "" .

    input from value(v_label1).
    output to value(v_filename1) .
       repeat:
          import unformatted ts9130.

/***********
变量清单:
$w  工单号(全局变量)
$i  工单ID(全局变量)
$d  op(全局变量)
$p  零件编号
$f  零件说明1
$e  零件说明2
$L  零件批次
$q  条码上数量
************/ 

          if index(ts9130, "$w") <> 0 then do:
             av9130 = trim(v_wonbr) .
             ts9130 = substring(ts9130, 1, index(ts9130 , "$w") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$w") 
                    + length("$w"), length(ts9130) - ( index(ts9130 , "$w") + length("$w") - 1 ) ).
          end.          

          if index(ts9130, "$I") <> 0 then do:
             av9130 = trim(v_wolot) .
             ts9130 = substring(ts9130, 1, index(ts9130 , "$I") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$I") 
                    + length("$I"), length(ts9130) - ( index(ts9130 , "$I") + length("$I") - 1 ) ).
          end.

          if index(ts9130, "$d") <> 0 then do:
             av9130 = string(v_op) .
             ts9130 = substring(ts9130, 1, index(ts9130 , "$d") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$d") 
                    + length("$d"), length(ts9130) - ( index(ts9130 , "$d") + length("$d") - 1 ) ).
          end.

          if index(ts9130, "$p") <> 0 then do:
             av9130 = v_part.
             ts9130 = substring(ts9130, 1, index(ts9130 , "$p") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$p") 
                    + length("$p"), length(ts9130) - ( index(ts9130 , "$p") + length("$p") - 1 ) ).
          end.

          if index(ts9130, "$f") <> 0 then do:
             av9130 = v_desc1.
             ts9130 = substring(ts9130, 1, index(ts9130 , "$f") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$f") 
                    + length("$f"), length(ts9130) - ( index(ts9130 , "$f") + length("$f") - 1 ) ).
          end.

          if index(ts9130, "$e") <> 0 then do:
             av9130 = v_desc2.
             ts9130 = substring(ts9130, 1, index(ts9130 , "$e") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$e") 
                    + length("$e"), length(ts9130) - ( index(ts9130 , "$e") + length("$e") - 1 ) ).
          end.


          if index(ts9130, "$l") <> 0 then do:
             av9130 = v_lot.
             ts9130 = substring(ts9130, 1, index(ts9130 , "$l") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$l") 
                    + length("$l"), length(ts9130) - ( index(ts9130 , "$l") + length("$l") - 1 ) ).
          end.

          if index(ts9130, "$q") <> 0 then do:
             av9130 = string(v_qty).
             ts9130 = substring(ts9130, 1, index(ts9130 , "$q") - 1) + av9130 
                    + substring( ts9130 , index(ts9130 ,"$q") 
                    + length("$q"), length(ts9130) - ( index(ts9130 , "$q") + length("$q") - 1 ) ).
          end.                 

          put unformatted ts9130 skip.
          v_oneword1 = v_oneword1 + ts9130.
       end.

    input close.
    output close.

    unix silent value ("chmod 777  " + v_filename1).

    i = 0 .
    do i = 1 to v_num:
        find first xprd_det where xprd_dev = trim(v_printer) no-lock no-error.
        if available xprd_det then do:
            unix silent value (trim(xprd_path) + " " + v_filename1).
        end.
    end. 
    
    unix silent value ( "rm -f  "  + v_filename1 ).

end. /*procedure*/


procedure  xsprinthist: 
    {xsprinthist.i} 
end procedure. 
