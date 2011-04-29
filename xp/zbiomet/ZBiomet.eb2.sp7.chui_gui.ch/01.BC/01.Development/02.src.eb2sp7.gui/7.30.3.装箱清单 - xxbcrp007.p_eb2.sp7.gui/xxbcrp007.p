/* xxbcrp007.p 装箱清单打印(出货前)PackingList                             */
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

define var nbr  as char format "x(8)" .
define var ship_to as char format "x(8)"  .
define var ship_to2 like ad_name .
define var part      like pt_part.
define var part1     like pt_part.

define var v_ii as integer .


/*GUI preprocessor Frame A define A*/
&SCOPED-DEFINE PP_FRAME_NAME 

FORM  
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  


    nbr         colon 20 label "计划单号"
    part        colon 20 label "料号"
    part1       colon 49 label {t001.i}
    


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

find last xpkd_det use-index xpkd_nbr2 no-lock no-error .
nbr  = if avail xpkd_det then xpkd_nbr else "" .

{wbrp01.i}
mainloop:
repeat: 

    clear frame a no-pause .
    if part1 = hi_char then part1  = "".

    update nbr part part1  with frame a editing:
        if frame-field = "nbr" then do:
            {mfnp11.i xpk_mstr xpk_nbr2 xpk_nbr "input nbr" }
            if recno <> ?  then do:
                disp xpk_nbr @ nbr 
                with frame a.
            end.             
        end. 
        else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
        end.
    end. /*update nbr*/
    assign nbr .

    if part1 = "" then part1 = hi_char.


    find first xpkd_det where xpkd_nbr = nbr  no-lock no-error.
    if not avail xpkd_det then do:  
        message "无效出货计划单号或已出货" view-as alert-box .
        undo,retry .
    end.
    ship_to = xpkd_shipto .



    create "excel.application" xapplication.
    xworkbook = xapplication:workbooks:add().
    xworksheet = xapplication:sheets:item(1).  
    x_row = 1.
    x_col = 1.
    xworksheet:range("A":u + string(x_row) + ":I":u + STRING(X_row)):select.
    xworksheet:range("A":u + string(x_row) + ":I":u + STRING(X_row)):merge.
    xworksheet:range("A":u + string(x_row)):value = "装箱清单" + " (计划单:" + nbr + "/交运地:" + ship_to + ")". 
    xworksheet:range("A":u + string(x_row)):HorizontalAlignment = 3 .
    xworksheet:range("a1"):Font:Bold = True .
    xworksheet:range("a1"):font:size = 16 .
    xworksheet:Rows(x_row):EntireRow:AutoFit . 
 
    x_row = 2.
    x_col = 1.
    xworksheet:cells(x_row,x_col) = "箱号".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "项".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "项目号".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "批号".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "库位".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "数量".
    x_col = x_col + 1.
    xworksheet:cells(x_row,x_col) = "销售订单/项".
    x_col = x_col + 1.    
    xworksheet:cells(x_row,x_col) = "备注" .
    x_col = x_col + 1.    
    xworksheet:cells(x_row,x_col) = "采购单" .
    xworksheet:Rows("2:2"):Font:Bold = True .


    v_ii = x_row .
    for each xpkd_det no-lock 
            where xpkd_nbr = nbr  /*本计划单号的*/
            /* and xpkd_shipnbr  = "" 未产生装箱单的*/
            and xpkd_part >= part  and xpkd_part <= part1 
            break by xpkd_nbr by xpkd_box by xpkd_part 
            by xpkd_lot by xpkd_loc by xpkd_sonbr by xpkd_soline  :

            find first so_mstr where so_nbr = xpkd_sonbr no-lock no-error.
            find first xpk_mstr where xpk_nbr = xpkd_nbr and xpk_sonbr = xpkd_sonbr  and xpk_soline = xpkd_soline no-lock no-error .


            x_row = x_row + 1.
            x_col = 1.
            xworksheet:cells(x_row,x_col) = xpkd_box.
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = if avail xpk_mstr then string(xpk__int01) else "" .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "'" + xpkd_part .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "'" + xpkd_lot  .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "'" + xpkd_loc .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = xpkd_qty_pk  .
            x_col = x_col + 1.
            xworksheet:cells(x_row,x_col) = "'" + xpkd_sonbr + "/" + string(xpkd_soline) .
            x_col = x_col + 1.  
            xworksheet:cells(x_row,x_col) = "'" + if avail so_mstr then so_rmks else ""  .
            x_col = x_col + 1.  
            xworksheet:cells(x_row,x_col) = "'" + if avail so_mstr then so_PO else ""  .

    end. /*for each temp1*/

    /*设定前几行表格边框*/
    xworksheet:range("A":u + string(v_ii) + ":I":u + STRING(X_row)):borders:linestyle = 7 .
    xworksheet:range("A":u + string(v_ii) + ":I":u + STRING(X_row)):borders:colorindex = 1 .


    xworksheet:Columns:EntireColumn:AutoFit .
        /*xworksheet:Columns("H"):hidden = true .
        xworksheet:Columns("H"):ColumnWidth = 24 .*/ 
    xworksheet:pagesetup:Zoom = 80 . /*缩放比*/
    xworksheet:pagesetup:CenterFooter = "第 &P 页，共 &N 页" . /*页脚*/
    xworksheet:pagesetup:Orientation = 1 .  /*纵向*/
    xworksheet:pagesetup:PrintTitleRows = "$1:$2" . /*页面标题行*/
    xworksheet:pagesetup:PrintTitleColumns = "" .  /*页面标题列*/
    xworksheet:pagesetup:LeftMargin   = xapplication:InchesToPoints(0.551181102362205) .  /*左边距*/
    xworksheet:pagesetup:RightMargin  = xapplication:InchesToPoints(0.354330708661417) .  /*右边距*/
    xworksheet:pagesetup:TopMargin    = xapplication:InchesToPoints(0.590551181102362) .  /*上边距*/
    xworksheet:pagesetup:BottomMargin = xapplication:InchesToPoints(0.393700787401575) .  /*下边距*/
    xworksheet:pagesetup:HeaderMargin = xapplication:InchesToPoints(0.511811023622047) .  /*页眉*/
    xworksheet:pagesetup:FooterMargin = xapplication:InchesToPoints(0.196850393700787) .  /*页脚*/



    xworksheet:cells(1,1):select.
    xapplication:visible = true. 
    /*xworkbook:printpreview. */

    release object xworksheet.
    release object xworkbook.
    release object xapplication.



end. /* mainloop */
{wbrp04.i &frame-spec = a}



