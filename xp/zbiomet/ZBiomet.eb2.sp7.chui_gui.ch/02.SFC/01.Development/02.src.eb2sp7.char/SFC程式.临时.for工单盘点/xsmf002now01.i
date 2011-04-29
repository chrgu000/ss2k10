/*xsmf002now01.p 刷新显示frame top1  当前最新时间,操作员,机器(工作中心)*/
/* REVISION: 1.0      Last Modified: 2008/11/28   By: Roger   ECO:         */
/*-Revision end------------------------------------------------------------*/

/***********
1.called by mainloop:  xsmf002.p
2.最好是每个动作之后都call, 


**********/ 





/*显示操作员/机器/时间*/
v_now = string(string(year(today),"9999") + "/" 
        + string(month(today),"99") + "/" 
        + string(day(today),"99") + " " 
        + string(time,"HH:MM:SS") ) .
disp v_now with frame top1.

find first xemp_mstr where xemp_addr = v_user2 no-lock no-error .
if avail xemp_mstr then disp caps(xemp_addr + " -" + xemp_lname) @ v_user2 with frame top1 .

find first xemp_mstr where xemp_addr = v_user no-lock no-error .
if avail xemp_mstr then disp xemp_lname @ v_user_name xemp_addr with frame main2 .

find first xwc_mstr where xwc_wkctr = v_wc no-lock no-error .
if avail xwc_mstr then disp xwc_wkctr @ v_wc  entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/") @ xwc_desc  with frame top1 .
if avail xwc_mstr then disp xwc_wkctr @ v_wc  entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/") @ xwc_desc  with frame main2 .







/*显示最近的历史记录(procedure disphist :defined in xsmf002frm.i)*/
run disphist .  









/*显示下方的工单相关反馈信息*/
if v_sn1 <> "" then do:
    if index(v_sn1, "+") <> 0 then do:
        v_op    = integer(entry(2,trim(v_sn1),"+")) .
        v_wolot = entry(1,trim(v_sn1),"+") .
    end.
end.

v_qty_open = 0 .
find first xxwrd_Det 
    where xxwrd_wolot = v_wolot
    and   xxwrd_op    = v_op 
no-lock no-error .
if avail xxwrd_Det then do:
    v_wonbr = xxwrd_wonbr .
    disp    
            v_wonbr 
            v_sn1 
            entry(max(1,num-entries(xxwrd_opname, "/")),xxwrd_opname,"/") @ xwr_desc 
            xxwrd_close
            xxwrd_qty_ord 
            xxwrd_qty_comp 
            xxwrd_qty_rejct
            xxwrd_qty_rework
            xxwrd_qty_return 
            max(0,xxwrd_qty_ord - xxwrd_qty_comp - xxwrd_qty_rejct) @ v_qty_open
            xxwrd_time_setup / 60  @ xxwrd_time_setup
            xxwrd_time_run   / 60  @ xxwrd_time_run
    with frame main2 .
end. /*if avail xxwrd_Det*/
else do:
    find first xwr_route 
        use-index xwr_lot
        where xwr_lot = v_wolot 
        and   xwr_op  = v_op 
    no-lock no-error .
    if avail xwr_route then do:
        v_wonbr = xwr_nbr .
        disp v_wonbr v_sn1 entry(max(1,num-entries(xwr_desc, "/")),xwr_desc,"/") @ xwr_desc with frame main2 .
    end.
    else do:
        disp v_wonbr v_sn1 "" @ xwr_desc with frame main2 .
    end.

    find first xwo_mstr where xwo_lot = v_wolot no-lock no-error .
    if avail xwo_mstr then do:
        v_wonbr = v_wonbr .
        disp 
            xwo_qty_ord  @ xxwrd_qty_ord  
            0 @ xxwrd_qty_comp  
            0 @ xxwrd_qty_rejct 
            0 @ xxwrd_qty_rework
            0 @ xxwrd_qty_return 
            xwo_qty_ord @ v_qty_open
            0 @ xxwrd_time_setup
            0 @ xxwrd_time_run 
        with frame main2.
    end.
    else do:
        disp 
            "" @ xxwrd_close
            "" @ xxwrd_qty_ord  
            "" @ xxwrd_qty_comp  
            "" @ xxwrd_qty_rejct 
            "" @ xxwrd_qty_rework
            "" @ xxwrd_qty_return 
            "" @ v_qty_open
            "" @ xxwrd_time_setup
            "" @ xxwrd_time_run 
        with frame main2.
    end.

end.  /*if not avail xxwrd_Det*/


if v_line = "" then do:
/*  
    find last xxfb_hist where xxfb_wolot = v_wolot and xxfb_op = v_op and xxfb_user = v_user no-lock no-error.
    if avail xxfb_hist then do:
        v_line = xxfb_type . 
        disp v_line xxfb_type2 @ xcode_cmmt with frame main2.
    end.
*/
disp  v_line "" @ xcode_cmmt with frame main2.
end.
else do:
    find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.
    if avail xcode_mstr then 
         disp v_line entry(1,xcode_cmmt,"@") @ xcode_cmmt with frame main2.
    else disp v_line "" @ xcode_cmmt with frame main2.
end.