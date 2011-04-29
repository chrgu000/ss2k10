/* REVISION: 1.0         Last Modified: 2008/11/12   By: Roger   ECO:*xp001*  */
/*-Revision end------------------------------------------------------------*/

/*
xsinv097a.i
1. called by xsinv097.p
2. disp the tr_hist 
3.宽度修改有多处 , eco:  *宽度*
*/

hide all no-pause . 
define var vii as integer .
define var vline as char format "x(35)" /*宽度*/  .

vii = 0 .
vline = "" .

find first ld_det where ld_site = v1002 and ld_loc = v1350  and ld_part = v1300 and ld_lot = v1305 no-lock no-error .
vline = if avail ld_det then "库位:"+ trim(v1350) + "   库存: " + string(ld_qty_oh) else "库位:"+ trim(v1350) + "   库存: 0" .


disp vline with frame x1 no-label no-box .


find first tr_hist
    use-index tr_part_trn
    where tr_part = v1300 
    and tr_site   = v1002
    and tr_loc    = v1350 
    and tr_serial = v1305
    and tr_qty_loc <> 0 
no-lock no-error.
if not avail tr_hist then do:
   vline = "无库存交易记录! " .
   disp  vline  with frame x3 with  no-label no-box.
end.
else do:
    

    for each tr_hist 
        use-index tr_part_trn
        where tr_part = v1300 
        and tr_site   = v1002
        and tr_loc    = v1350 
        and tr_serial = v1305
        and tr_qty_loc <> 0 
        no-lock 
        by tr_trnbr descending 
        with frame x2 
        no-box
        width 35  /*宽度*/ 
        with 5 down :

        vii = vii + 1 .
        vline = trim(string(tr_trnbr)) + " " + trim(string(tr_effdate)) + " " + trim(tr_type) + " " + trim(string(tr_qty_loc)) .
        disp 
            /*trim(string(tr_trnbr)) + " " + trim(string(tr_effdate)) + " " + trim(tr_type) + " " + trim(string(tr_qty_loc)) 
            format "x(28)"    */   
            vline label "交易号  日期    类型   数量" 
        with frame x2 .


        if vii mod 5 = 0 then do:
            readkey .
            apply lastkey .
            if lastkey = keycode("*") then leave . 
            hide frame x2  no-pause .
            clear frame x2  no-pause.
        end.
    end. /*for each tr_hist*/

end. 


pause no-message .
hide all no-pause .