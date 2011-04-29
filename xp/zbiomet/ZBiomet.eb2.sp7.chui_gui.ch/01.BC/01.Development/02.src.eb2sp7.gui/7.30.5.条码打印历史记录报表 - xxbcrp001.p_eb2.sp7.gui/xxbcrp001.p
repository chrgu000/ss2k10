/*xxbcrp001.p  条码打印历史记录查询报表                                    */
/* REVISION: 1.0         Last Modified: 2008/08/08   By: Roger             */
/* 20081106 客户tommy 要求保留到客制的table,所以:usrw_wkfl  ---> xprn_hist    */
/*-Revision end------------------------------------------------------------*/




{mfdtitle.i "1.0"}


define var date as date .
define var date1 as date .
define var part as char format "x(18)" .
define var part1 as char format "x(18)" .
define var lot as  char format "x(18)" .
define var lot1 as  char format "x(18)" .
define var v_user as  char format "x(18)" .
define var v_user1 as  char format "x(18)" .


define variable xapplication as com-handle.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.
define variable x_row as integer init 1. /*行*/
define variable x_col as integer init 1. /*列*/

form
    skip(.2)  /*GUI*/
	
	date             colon 18 label "打印日期"
    date1            colon 50 label "至"
    part             colon 18 label "零件编号"
    part1            colon 50 label "至"
    lot              colon 18 label "批号"
    lot1             colon 50 label "至"
    v_user             colon 18 label "用户ID"
    v_user1            colon 50 label "至"
	
skip(2) 
with frame a  side-labels width 80 attr-space
NO-BOX THREE-D  /*GUI*/ .
/*setFrameLabels(frame a:handle).*/

{wbrp01.i}
repeat:

if part1 = hi_char       then part1 = "".
if lot1 = hi_char       then lot1 = "".
if v_user1 = hi_char       then v_user1 = "". 
if date1 = hi_date    then date1 = ? .
if date  = low_date   then date  = ? .

update  
    date  
    date1 
    part  
    part1 
    lot   
    lot1  
    v_user  
    v_user1 
with frame a.



if part1 = "" then part1 = hi_char .
if lot1  = "" then lot1 = hi_char .
if v_user1 = "" then v_user1 = hi_char .
if date1 = ?  then date1 = hi_date .
if date  = ?  then date  = low_date .

/* PRINTER SELECTION */
/* OUTPUT DESTINATION SELECTION 
{gpselout.i &printType = "printer"
            &printWidth = 132
            &pagedFlag = " "
            &stream = " "
            &appendToFile = " "
            &streamedOutputToTerminal = " "
            &withBatchOption = "yes"
            &displayStatementType = 1
            &withCancelMessage = "yes"
            &pageBottomMargin = 6
            &withEmail = "yes"
            &withWinprint = "yes"
            &defineVariables = "yes"}*/
mainloop: 
do on error undo, return error on endkey undo, return error:                    




create "excel.application" xapplication.
xworkbook = xapplication:workbooks:add().
xworksheet = xapplication:sheets:item(1).  
x_row = 1.
x_col = 1.
xworksheet:range("a1:k1"):select.
xworksheet:range("a1:k1"):merge.
xworksheet:range("a1"):value = "条码打印历史记录". 
xworksheet:Cells(1, 1):HorizontalAlignment = 3 .
xworksheet:range("a1"):Font:Bold = True .
xworksheet:range("a1"):font:size=20 .
xworksheet:Rows("1:1"):EntireRow:AutoFit .  


x_row = 2.
x_col = 1.
xworksheet:cells(x_row,x_col) = "日期".
x_col = x_col + 1.
xworksheet:cells(x_row,x_col) = "时间".
x_col = x_col + 1.
xworksheet:cells(x_row,x_col) = "用户".
x_col = x_col + 1.
xworksheet:cells(x_row,x_col) = "打印程式".
x_col = x_col + 1.
xworksheet:cells(x_row,x_col) = "零件编号".
x_col = x_col + 1.
xworksheet:cells(x_row,x_col) = "批号".
x_col = x_col + 1.
xworksheet:cells(x_row,x_col) = "条码上数量".
x_col = x_col + 1.
xworksheet:cells(x_row,x_col) = "条码张数".
x_col = x_col + 1.
xworksheet:cells(x_row,x_col) = "条码模板".
x_col = x_col + 1.
xworksheet:cells(x_row,x_col) = "条码文件".
x_col = x_col + 1.
xworksheet:cells(x_row,x_col) = "条码内容".


for each xprn_hist 
    where xprn_key1 = "bcprint" 
    and xprn_key2 >= string(year(date),"9999") + string(month(date),"99") + string(day(date),"99") + "0000"
    and xprn_key2 <= string(year(date1),"9999") + string(month(date1),"99") + string(day(date1),"99") + "9999"
    and xprn_part >= part and xprn_part <= part1
    and xprn_lot >= lot and xprn_lot <= lot1 
    and xprn_user >= v_user and xprn_user <= v_user1
    no-lock
    with frame x width 300 :


        x_row = x_row + 1.
        x_col = 1.
        xworksheet:cells(x_row,x_col) = "'" + substring(xprn_key2,1,8).
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + string(xprn_time,"hh:mm:ss").
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + xprn_user.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + xprn_execname.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + xprn_part.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + xprn_lot.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = xprn_qty.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = xprn_nums.
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + xprn_lbl_model .
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + xprn_filename .
        x_col = x_col + 1.
        xworksheet:cells(x_row,x_col) = "'" + xprn_fileword.
       

end.

xworksheet:Columns:EntireColumn:AutoFit . 
xworksheet:Columns(x_col - 1 ):Hidden = True .
xworksheet:Columns(x_col):Hidden = True .

/*xworksheet:pagesetup:Zoom = 70 . 缩放比*/
xworksheet:pagesetup:CenterFooter = "第 &P 页，共 &N 页" . /*页脚*/
xworksheet:pagesetup:Orientation = 2 .  /*横向*/
xworksheet:pagesetup:PrintTitleRows = "$1:$2" . /*页面标题行*/
xworksheet:pagesetup:PrintTitleColumns = "" .  /*页面标题列*/
xworksheet:pagesetup:LeftMargin   = xapplication:InchesToPoints(0.551181102362205) .  /*左边距*/
xworksheet:pagesetup:RightMargin  = xapplication:InchesToPoints(0.354330708661417) .  /*右边距*/
xworksheet:pagesetup:TopMargin    = xapplication:InchesToPoints(0.590551181102362) .  /*上边距*/
xworksheet:pagesetup:BottomMargin = xapplication:InchesToPoints(0.393700787401575) .  /*下边距*/
xworksheet:pagesetup:HeaderMargin = xapplication:InchesToPoints(0.511811023622047) .  /*页眉*/
xworksheet:pagesetup:FooterMargin = xapplication:InchesToPoints(0.196850393700787) .  /*页脚*/

xapplication:visible = true.   
release object xworkbook.
release object xapplication.
release object xworksheet.


end. /* mainloop: */
/*{mfrtrail.i}   REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}



