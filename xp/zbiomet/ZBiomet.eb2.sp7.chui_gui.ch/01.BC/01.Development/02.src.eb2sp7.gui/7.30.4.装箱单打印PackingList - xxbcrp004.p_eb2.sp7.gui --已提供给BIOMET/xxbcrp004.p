/* xxbcrp004.p Packing List(出货后)                                                */
/* REVISION: 1.0         Last Modified: 2008/10/27   By: Roger   NO ECO    */ 
/*-Revision end------------------------------------------------------------*/


{mfdtitle.i "2+ "}


define variable xapplication as com-handle. /*for excel*/  
define variable xworkbook as com-handle.    /*for excel*/  
define variable xworksheet as com-handle.   /*for excel*/  
define variable x_row as integer init 1.    /*for excel*/  
define variable x_col as integer init 1.    /*for excel*/  

define var v_new as logical .
define var v_yn as logical  .

define var v_nbr as char .
define var nbr  as char format "x(8)" .
define var nbr1  as char format "x(8)" .
define var ship_to as char format "x(8)"  .
define var ship_num as char format "x(18)" .

define var v_ii as integer .
define var ship_to2 like ad_name .

define var v_invoice as char format "x(30)" .

define temp-table temp1 /*每个装箱单的项次 : by sonbr by soline by part by lot by box */
    field t1_shipto   like so_ship 
    field t1_sonbr    like so_nbr
    field t1_soline   like sod_line
    field t1_part     like sod_part 
    field t1_lot      like ld_lot 
    field t1_box      as integer 
    field t1_category like sod_order_category
    field t1_qty_shp  like sod_qty_ord 
    .

define temp-table temp2 /*每个箱*/
    field t2_box as integer .

define temp-table temp3 /*每个计划单*/
    field t3_nbr like sod_nbr 
    field t3_date as date . 

define temp-table temp4 /*每个销售订单*/
    field t4_sonbr     like  so_nbr 
    field t4_invoice   like  so_inv_nbr.

/*GUI preprocessor Frame A define A*/
&SCOPED-DEFINE PP_FRAME_NAME 

FORM  
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  
    v_nbr       colon 18 label "装箱单"
    skip(.5)
    ship_to     colon 18 label "交运地"
    ship_num    colon 45 label "运单号"
    nbr         colon 18 label "计划单号"
    nbr1        colon 45 label "至"
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

find last xpkd_det use-index xpkd_shipnbr no-lock no-error .
v_nbr  = if avail xpkd_det then xpkd_shipnbr else "" .

{wbrp01.i}
mainloop:
repeat: 
    for each temp1 : delete temp1 .  end.
    for each temp2 : delete temp2 .  end.
    for each temp3 : delete temp3 .  end.
    for each temp4 : delete temp4 .  end.

    clear frame a no-pause .
    v_invoice = "" .
    v_new = no .
    update v_nbr with frame a editing:
        {mfnp11.i xpkd_det xpkd_shipnbr  xpkd_shipnbr "input v_nbr" }
        IF recno <> ?  THEN DO:
            DISP xpkd_shipnbr @ v_nbr xpkd_shipto @ ship_to xpkd_airnbr @ ship_num 
            with frame a.
        END.  /*if recno<> ?*/
    end.
    assign v_nbr  .
    if v_nbr <> "" then do:
            v_new = no .
            find first xpkd_det use-index  xpkd_shipnbr where xpkd_shipnbr = v_nbr no-lock no-error .
            if not avail xpkd_det then do:
                message "无效装箱单号,请重新输入" view-as alert-box.
                undo,retry.
            end.
            else do:
                DISP xpkd_shipnbr @ v_nbr xpkd_shipto @ ship_to xpkd_airnbr @ ship_num with frame a.
                ship_num = xpkd_airnbr .
                ship_to = xpkd_shipto .
            end.

            for each xpkd_det no-lock 
                use-index  xpkd_shipnbr
                where xpkd_shipnbr = v_nbr
                and xpkd_qty_pk  <> 0  
                break by xpkd_shipto by xpkd_part by xpkd_nbr by xpkd_sonbr by xpkd_soline  :
                    if first-of(xpkd_shipto) then do:
                        find first ad_mstr where ad_addr = xpkd_shipto no-lock no-error.
                        ship_to2 = if avail ad_mstr then ad_name else ship_to .
                    end.

                    find first temp1 
                        where t1_sonbr = xpkd_sonbr 
                        and t1_soline = xpkd_soline 
                        and t1_box    = xpkd_box
                        and t1_part   = xpkd_part
                        and t1_lot    = xpkd_lot
                    no-error.
                    if not avail temp1 then do:
                        find first temp2 where t2_box = xpkd_box no-error .
                        if not avail temp2 then do:
                            create temp2 . t2_box = xpkd_box .
                        end.
                        create temp1.
                        assign  t1_shipto = ship_to2
                                t1_sonbr  = xpkd_sonbr
                                t1_soline = xpkd_soline
                                t1_part   = xpkd_part
                                t1_lot    = xpkd_lot 
                                t1_box    = xpkd_box 
                                t1_category = xpkd_category
                                t1_qty_shp  = xpkd_qty_pk .
                    end.
                    else do:
                        t1_qty_shp = t1_qty_shp + xpkd_qty_pk .
                    end.
            end. /*for each xpkd_det*/
    end. /*if v_nbr <> "" */
    else do:   /*if v_nbr = "" */
            v_new = yes .
            if nbr1        = hi_char  then nbr1      = "".

            update ship_to ship_num nbr nbr1 with frame a editing:
                if frame-field = "nbr" then do:
                    {mfnp11.i xpk_mstr xpk_nbr2 xpk_nbr "input nbr" }
                    if recno <> ?  then do:
                        disp xpk_nbr @ nbr 
                        with frame a.
                    end.             
                end.
                else if frame-field = "nbr1" then do:
                    {mfnp11.i xpk_mstr xpk_nbr2 xpk_nbr "input nbr1" }
                    if recno <> ?  then do:
                        disp xpk_nbr @ nbr1 
                        with frame a.
                    end. 
                end.
                else if frame-field = "ship_to" then do:
                    {mfnp.i ad_mstr ship_to ad_addr ship_to ad_addr ad_addr}
                    if recno <> ?  then do:
                        disp ad_addr @ ship_to 
                        with frame a.
                    end. 
                end.
                else do:
                           status input ststatus.
                           readkey.
                           apply lastkey.
                end.
            end. /*update nbr*/
            assign nbr nbr1 ship_to ship_num = caps(ship_num).

            if nbr1      = "" then nbr1      = hi_char .

            if ship_to = "" or (ship_to <> "" and not can-find(first ad_mstr where ad_addr = ship_to no-lock)) then do:
                message "无效交运地" view-as alert-box .
                undo,retry.
            end.

            for each xpkd_det no-lock 
                where xpkd_shipto = ship_to /*本交运地的*/
                and xpkd_nbr >= nbr and xpkd_nbr <= nbr1  /*计划单号范围内的*/
                and xpkd_shipnbr  = "" /*未产生装箱单的*/
                and xpkd_qty_pk  <> 0 /*装箱数量不为零*/
                and can-find(first xpk_mstr where xpk_nbr = xpkd_nbr and xpk_stat     = "C" no-lock)  /*已出货的*/
                break by xpkd_shipto by xpkd_part by xpkd_nbr by xpkd_sonbr by xpkd_soline  :
                    if first-of(xpkd_shipto) then do:
                        find first ad_mstr where ad_addr = xpkd_shipto no-lock no-error.
                        ship_to2 = if avail ad_mstr then ad_name else ship_to .
                    end.

                    find first temp3 where t3_nbr = xpkd_nbr no-lock no-error .
                    if not avail temp3 then do:
                        create temp3 .
                        assign t3_nbr = xpkd_nbr t3_date = xpkd_ship_date .
                    end.

                    find first temp4 where t4_sonbr = xpkd_sonbr no-lock no-error.
                    if not avail temp4 then do:
                        find first so_mstr where so_nbr = xpkd_sonbr no-lock no-error .
                        if avail so_mstr then do:
                            create temp4 .
                            assign t4_sonbr = xpkd_sonbr t4_invoice = so_inv_nbr .
                        end.
                    end.

                    find first temp1 
                        where t1_sonbr = xpkd_sonbr 
                        and t1_soline = xpkd_soline 
                        and t1_box    = xpkd_box 
                        and t1_part   = xpkd_part
                        and t1_lot    = xpkd_lot
                    no-error.
                    if not avail temp1 then do:
                        find first temp2 where t2_box = xpkd_box no-error .
                        if not avail temp2 then do:
                            create temp2 . t2_box = xpkd_box .
                        end.
                        create temp1.
                        assign  t1_shipto = ship_to2
                                t1_sonbr  = xpkd_sonbr
                                t1_soline = xpkd_soline
                                t1_part   = xpkd_part
                                t1_lot    = xpkd_lot 
                                t1_box    = xpkd_box 
                                t1_category = xpkd_category
                                t1_qty_shp  = xpkd_qty_pk .
                    end.
                    else do:
                        t1_qty_shp = t1_qty_shp + xpkd_qty_pk .
                    end.
            end. /*for each xpkd_det*/


    end.  /*if v_nbr = "" */

    v_invoice = "" .
    for each temp4 break by t4_invoice :
        if first(t4_invoice) then v_invoice = t4_invoice .
        if last(t4_invoice)  then v_invoice = v_invoice + "-" + t4_invoice .
    end. /*默认的发票范围,只显示在excel,未保存进DB */

    create "excel.application" xapplication.
    xworkbook = xapplication:workbooks:add().
    xworksheet = xapplication:sheets:item(1).  
    x_row = 1.
    x_col = 1.
    xworksheet:range("A":u + string(x_row) + ":I":u + STRING(X_row)):select.
    xworksheet:range("A":u + string(x_row) + ":I":u + STRING(X_row)):merge.
    xworksheet:range("A":u + string(x_row)):value = "PACKING LIST". 
    xworksheet:range("A":u + string(x_row)):HorizontalAlignment = 3 .
    xworksheet:range("a1"):Font:Bold = True .
    xworksheet:range("a1"):font:size=20 .
    xworksheet:Rows(x_row):EntireRow:AutoFit . 
 
    xworksheet:range("a2:b2"):select.
    xworksheet:range("a2:b2"):merge.
    xworksheet:range("a2") = "Date:" .
    xworksheet:range("c2") = "'" + string(year(today),"9999") + "-" + string(month(today),'99') + "-" + string(day(today),'99') .   
    xworksheet:range("e2") = "Invoice No.:".
    xworksheet:range("f2:I2"):select.
    xworksheet:range("f2:I2"):merge.
    xworksheet:range("f2") = "'" + v_invoice .
    xworksheet:range("a3:b3"):select.
    xworksheet:range("a3:b3"):merge.
    xworksheet:range("a3") = "Packing List No.:" .
    xworksheet:range("c3") = if v_nbr <> "" then "'" + v_nbr else ""  .   
    xworksheet:range("e3") = "Ship Air No.:".
    xworksheet:range("f3:I3"):select.
    xworksheet:range("f3:I3"):merge.
    xworksheet:range("f3") = "'" + ship_num  .
    xworksheet:range("a4:b4"):select.
    xworksheet:range("a4:b4"):merge.
    xworksheet:range("a4") = "Harmonized Code:"  .

    x_row = 6.
    x_col = 1.
    xworksheet:cells(x_row,x_col) = "Ship-To".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "Customer-PO".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "Remarks".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "Line".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "Part No.".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "Lot No.".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "Qty-Ship".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "Box No.".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "Comment".
    xworksheet:Rows("2:5"):Font:Bold = True .


/*
create temp1 . t1_part = "a" .
create temp1 . t1_part = "b" .
*/    
    v_ii = x_row .
    for each temp1 break by t1_shipto  by t1_box by t1_part by t1_lot by t1_sonbr by t1_soline:
            find first so_mstr where so_nbr = t1_sonbr no-lock no-error.


            x_row = x_row + 1.
            x_col = 1.
            xworksheet:cells(x_row,x_col) = "'" + t1_shipto.
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "'" + if avail so_mstr then so_po else "" .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "'" + if avail so_mstr then so_rmks else ""  .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = t1_soline.
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "'" + t1_part .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "'" + t1_lot .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = t1_qty_shp .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = t1_box .
            x_col = x_col + 1.  
            xworksheet:cells(x_row,x_col) = t1_category .

    end. /*for each temp1*/

    /*设定前几行表格边框*/
    xworksheet:range("A":u + string(v_ii) + ":I":u + STRING(X_row)):borders:linestyle = 7 .
    xworksheet:range("A":u + string(v_ii) + ":I":u + STRING(X_row)):borders:colorindex = 1 .


/*
create temp2 .  t2_box = 1 .
create temp2 .  t2_box = 3 .
*/
    if can-find(first temp2 ) then do:
        x_row = x_row + 3 .
        xworksheet:range("A":u + string(x_row) + ":B":u + STRING(X_row)):merge .
        xworksheet:range("C":u + string(x_row) + ":E":u + STRING(X_row)):merge .
        xworksheet:range("F":u + string(x_row) + ":I":u + STRING(X_row)):merge .
        xworksheet:Rows(x_row):Font:Bold = True .
        xworksheet:range("A":u + string(x_row)) = "Box No.".
        xworksheet:range("C":u + string(x_row)) = "Net Weights(KGs)" .
        xworksheet:range("F":u + string(x_row)) = "Gross Weight(KGs)"  .


        v_ii = x_row .
        for each temp2 break by t2_box :
                x_row = x_row + 1 .
                xworksheet:range("A":u + string(x_row) + ":B":u + STRING(X_row)):merge .
                xworksheet:range("C":u + string(x_row) + ":E":u + STRING(X_row)):merge .
                xworksheet:range("F":u + string(x_row) + ":I":u + STRING(X_row)):merge .
                xworksheet:range("A":u + string(x_row)) = t2_box.
        end. /*for each*/
        x_row = x_row + 1 .
        xworksheet:range("A":u + string(x_row) + ":B":u + STRING(X_row)):merge .
        xworksheet:range("C":u + string(x_row) + ":E":u + STRING(X_row)):merge .
        xworksheet:range("F":u + string(x_row) + ":I":u + STRING(X_row)):merge .
        xworksheet:range("A":u + string(x_row)) = "Total:".

        x_row = x_row + 1 .
        xworksheet:range("A":u + string(x_row) + ":B":u + STRING(X_row)):merge .
        xworksheet:range("C":u + string(x_row) + ":E":u + STRING(X_row)):merge .
        xworksheet:range("F":u + string(x_row) + ":I":u + STRING(X_row)):merge .
        xworksheet:range("A":u + string(x_row)) = x_row - 2 - v_ii  .
        xworksheet:range("C":u + string(x_row)):Formula = "=sum(C":u + string(v_ii + 1) + ":C":u + string(x_row - 2) .
        xworksheet:range("F":u + string(x_row)):Formula = "=sum(F":u + string(v_ii + 1) + ":F":u + string(x_row - 2) .

        /*设定前几行表格边框*/
        xworksheet:range("A":u + string(v_ii) + ":I":u + STRING(X_row)):borders:linestyle = 7 .
        xworksheet:range("A":u + string(v_ii) + ":I":u + STRING(X_row)):borders:colorindex = 1 .
    end. /*if can-find(first temp2*/


    xworksheet:Columns:EntireColumn:AutoFit .
    xworksheet:Columns("C"):ColumnWidth = 24 .
    xworksheet:pagesetup:Zoom = 70 . /*缩放比*/
    xworksheet:pagesetup:CenterFooter = "第 &P 页，共 &N 页" . /*页脚*/
    xworksheet:pagesetup:Orientation = 1 .  /*纵向*/
    xworksheet:pagesetup:PrintTitleRows = "$1:$4" . /*页面标题行*/
    xworksheet:pagesetup:PrintTitleColumns = "" .  /*页面标题列*/
    xworksheet:pagesetup:LeftMargin   = xapplication:InchesToPoints(0.551181102362205) .  /*左边距*/
    xworksheet:pagesetup:RightMargin  = xapplication:InchesToPoints(0.354330708661417) .  /*右边距*/
    xworksheet:pagesetup:TopMargin    = xapplication:InchesToPoints(0.590551181102362) .  /*上边距*/
    xworksheet:pagesetup:BottomMargin = xapplication:InchesToPoints(0.393700787401575) .  /*下边距*/
    xworksheet:pagesetup:HeaderMargin = xapplication:InchesToPoints(0.511811023622047) .  /*页眉*/
    xworksheet:pagesetup:FooterMargin = xapplication:InchesToPoints(0.196850393700787) .  /*页脚*/


    xworksheet:cells(1,1):select.
    xapplication:visible = true. 
    /*xworkbook:printpreview.*/

    release object xworksheet.
    release object xworkbook.
    release object xapplication.

    /*先预览,然后如果不是打印旧装箱单,才执行下面内容*/
    if v_new and can-find(first temp1 ) then do:
        v_new = no .
        for each temp3 :
            find first tr_hist 
                    where tr_effdate = t3_date 
                    and tr_type      = "iss-so"
                    and tr__chr15    = t3_nbr 
            no-lock no-error.
            if avail tr_hist then do:
                v_new = yes . /*找得到其中,任何一笔计划单的任何出货记录,就可产生装箱单*/
                leave . 
            end.
        end.

        if v_new = yes then do: /*找的到此计划单的出货记录才产生装箱单*/
            v_yn = no.
            {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=v_yn } /* 请确认更新 */
            if v_yn then do: 
                run getnbr .
                for each temp3 :
                    for each tr_hist 
                        where tr_effdate = t3_date 
                        and tr_type      = "iss-so"
                        and tr__chr15    = t3_nbr :
                        assign tr__chr14 = ship_num .
                    end.

                    for each xpkd_det where xpkd_nbr = t3_nbr :
                        assign  xpkd_shipnbr = v_nbr
                                xpkd_airnbr  = ship_num .
                    end.
                end.
                    message "新产生装箱单号:" v_nbr view-as alert-box.
            end. /*if v_yn */
        end. /*if v_new = yes */
        else do:
            message "没有出货记录,不产生装箱单号" view-as alert-box .
        end.

    end. /*if v_new and can-find(first temp1 )*/



end. /* mainloop */
{wbrp04.i &frame-spec = a}



procedure getnbr : 
do transaction:
    find last usrw_wkfl where usrw_key1 = "bcshipnbr" and usrw_key2 = "bcshipnbr" exclusive-lock no-error .
    if not avail usrw_wkfl then do:

        find last xpkd_det use-index xpkd_shipnbr no-lock no-error . /*防止误删而再重新跳号*/
        v_nbr = if avail xpkd_det then string(integer(xpkd_shipnbr) + 1, "99999999") else "00000001" .

        create usrw_wkfl .
        assign usrw_key1 = "bcshipnbr"
               usrw_key2 = "bcshipnbr" 
               usrw_key3 = v_nbr  
               usrw_key4 = "**流水号:for出货装箱单,不允许删除**!".

        v_nbr = string(integer(usrw_key3) ,"99999999") .
    end.
    else do:
        v_nbr = string(integer(usrw_key3) + 1 ,"99999999") .
        usrw_key3 = v_nbr .
    end.
    release usrw_wkfl .
end.
end procedure. /*getnbr*/

