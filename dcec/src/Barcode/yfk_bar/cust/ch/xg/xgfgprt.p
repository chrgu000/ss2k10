/* xgfgcom.p                  产品下线扫描条码打印           */
/* Created by    hou                           2006.02.14    */

{mfdtitle.i "ao"}

define variable filetmp as char format "x(50)".

define variable lnr     like xgpl_lnr.
define variable shft    as char format "x(8)" label "班次".
define variable batchno like xwo_lot.
define variable part    like pt_part label "零件号".
define variable ptdesc  like pt_desc1.
define variable cname   like ad_name.
define variable cpart   like pt_part.

define variable chexcelapplication  as com-handle.
define variable chexcelworkbook     as com-handle.
define variable chexcelworksheet    as com-handle.


FORM
   skip(.1)
   lnr          colon 20
   xgpl_desc    at    36 no-labels format "x(40)"
/*   shft         colon 20
   part         colon 20  */
   batchno      colon 20
   skip(.4)
WITH FRAME a WIDTH 80 SIDE-LABELS NO-BOX THREE-D.


filetmp = search("finbox.xls").
if filetmp = ? then do:
     message "打印模板finbox.xls不存在".
     pause.
     leave.
end.          


repeat with frame a:
   update lnr /*shft part*/ batchno.
   
   find first xgpl_ctrl where xgpl_lnr = lnr no-lock no-error.
   if not avail xgpl_ctrl then do:
      {mfmsg.i 8524 3}
      undo , retry.
   end.
   
   disp xgpl_desc.
   
   find first xpal_ctrl where xpal_line = lnr no-lock no-error.
   if not avail xpal_ctrl then do:
      message "错误:托盘控制程序未定义,请重新输入" view-as alert-box error.
      undo , retry.
   end.
   
/*   find first code_mstr where code_fldname = "shft" and code_value = shft
   no-lock no-error.
   if not avail code_mstr then do:
      message "错误:非法的班次,请重新输入" view-as alert-box error.
      undo, retry.
   end.
*/


   find first xwo_srt where xwo_lnr = lnr /*and xwo_shift = shft
   and xwo_part = part*/ and xwo_lot = batchno no-lock no-error.
   if not avail xwo_srt then do:
      message "错误:无此批号,请重新输入" view-as alert-box error.
      undo, retry.
   end.

   find first pt_mstr where pt_part = xwo_part no-lock no-error.
   if not avail pt_mstr then do:
      message "错误:无此零件,请重新输入" view-as alert-box error.
      undo, retry.
   end.
   ptdesc = pt_desc1.

   find first ad_mstr where ad_addr = xwo_cust no-lock no-error.
   if avail ad_mstr then cname = ad_name.
   else cname = "".

   find first cp_mstr where cp_cust = xwo_cust and cp_part = xwo_part no-lock no-error.
   if not avail cp_mstr then do:
      find first cp_mstr where cp_part = xwo_part no-lock no-error.        
   end.
   if avail cp_mstr then cpart = cp_cust_part.
   else cpart = "".


   /* Create a New chExcel Application object */
   CREATE "Excel.Application" chExcelApplication.          
   chExcelWorkbook = chExcelApplication:Workbooks:Open(filetmp).                         
   chExcelWorksheet = chExcelWorkbook:ActiveSheet(). 

   chExcelWorksheet:Cells(1, 2) = "*" + trim(xwo_part) +  "*".
   chExcelWorksheet:Cells(1, 4) = ptdesc.
   chExcelWorksheet:Cells(3, 2) = "*" + string(xwo_qty_lot) +  "*".
   chExcelWorksheet:Cells(3, 4) = "*" + trim(batchno) + "*".
   chExcelWorksheet:Cells(5, 2) = cname.
   chExcelWorksheet:Cells(5, 4) = "*" + trim(cpart) + "*".

   chExcelApplication:Visible = false.
   chExcelWorksheet:printout(,,,,xgpl_chr2,,).
   
   chExcelWorkbook:CLOSE(FALSE).
   chExcelApplication:QUIT.


    /* Release com - handles */
   RELEASE OBJECT chExcelWorksheet. 
   RELEASE OBJECT chExcelWorkbook.
   RELEASE OBJECT chExcelApplication.
   
end.

