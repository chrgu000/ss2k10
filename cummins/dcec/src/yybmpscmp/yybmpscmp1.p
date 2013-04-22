/* zzbmpscmp.p - PRODUCT STRUCTURE COMPARE, REPORT EXPORT TO MS EXCEL FILE    */
/* COPYRIGHT AtosOrigin. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.    */
/* REVISION: 8.5  LAST MODIFIED: 11/19/03  BY: *LB01* Long Bo         */
/* $Revision:eb21sp12  $ BY: Jordan Lin DATE: 08/16/12  ECO: *SS-20120816.1*   */

     /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
{mfdtitle.i "120816.1"}
{yybmpscmp.i}
def var parent1 like ps_par initial "".
def var parent2 like ps_par initial "".
define variable iRow as integer.
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc1.
define variable desc11 like pt_desc2.
define variable desc12 like pt_desc2.
define variable showall like mfc_logical initial no.
define new shared var effdate1 like ps_start.
define new shared var effdate2 like ps_start.
def var strdate as char.
define variable vqty like ps_qty_per.
define variable vsite as character.

define new shared work-table mybomcmp
  field bcomp like ps_comp
  field bdesc like pt_desc1
  field bdesc2 like pt_desc2
  field bqty1 like ps_qty_per
  field bqty2 like ps_qty_per
  field bref1 like ps_ref
  field bref2 like ps_ref.

/* define Excel object handle */
DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
/*DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.*/
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.

form
   RECT-FRAME   AT ROW 1 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
   SKIP(1)  /*GUI*/
   parent1 colon 15 label "源产品结构"
   parent2 colon 50 label "比较产品结构"
   desc1 no-label at 15
   desc2 no-label at 50
   desc11 no-label at 15
   desc12 no-label at 50 skip(1)
   effdate1 colon 15 label "生效日期"
   effdate2 colon 50 label "生效日期" skip(1)
   showall colon 20 label "显示所有Y/N"
   skip(.4)
   with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

   DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:HIDDEN in frame a = yes.
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

  display parent1 parent2 today @ effdate1 today @ effdate2 with frame a.
repeat:

  set parent1
    parent2
    effdate1
    effdate2
  with frame a editing:
     message "输入需要比较的两个产品结构，按F2执行，并等待输出到EXCEL表格...".

   if frame-field = "parent1" then do:
     /* FIND NEXT/PREVIOUS RECORD - ALL BOM_MSTR'S ARE
      VALID FOR "SOURCE" */
     {mfnp.i bom_mstr parent1 " bom_domain = global_domain and bom_parent "
             parent1 bom_parent bom_parent}
     if recno <> ? then do:
      assign
      parent1 = bom_parent
      desc1 = bom_desc.

      find pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = bom_parent no-lock no-error.
      if available pt_mstr then
        desc11 = pt_desc2.

      display parent1
          desc1
          desc11
      with frame a.
     end.    /* if recno <> ? */

     recno = ?.
   end. /* if frame-field = "parent1" */
   else if frame-field = "parent2" then do:

     /* FIND NEXT/PREVIOUS RECORD - BOMS TO DISPLAY DEPEND
     IN THE INPUT BOM-TYPE PARAMETER */
     {mfnp.i bom_mstr parent2 "bom_domain = global_domain and bom_parent "
             parent2 bom_parent bom_parent}

     if recno <> ? then do:
      assign
      parent2 = bom_parent
      desc2 = bom_desc.

      find pt_mstr where pt_mstr.pt_domain = global_domain
                     and pt_part = bom_parent no-lock no-error.
      if available pt_mstr then
        desc12 = pt_desc2.

      display parent2
          desc2
          desc12
      with frame a.

     end.    /* if recno <> ? */

   end.  /* if frame-field = "parent2" */
   else do:
     status input.
     readkey.
     apply lastkey.
   end.
  end.  /* editing */

  find first bom_mstr where bom_mstr.bom_domain = global_domain
        and  bom_parent = parent1 no-lock no-error.
  if not available bom_mstr then do:
    message "产品结构不存在，请重新输入! " view-as alert-box.
    next-prompt parent1 with frame a.
    undo, retry.
  end.
  else do:
    desc1 = bom_desc.
  end.

  find first bom_mstr where bom_mstr.bom_domain = global_domain and bom_parent = parent2 no-lock no-error.
  if not available bom_mstr then do:
    message "产品结构不存在，请重新输入! " view-as alert-box.
    next-prompt parent2 with frame a.
    undo, retry.
  end.
  else do:
    desc2 = bom_desc.
  end.
  find pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = parent1 no-lock no-error.
  if available pt_mstr then
    desc11 = pt_desc2.
  find pt_mstr where pt_mstr.pt_domain = global_domain and  pt_part = parent2 no-lock no-error.
  if available pt_mstr then
    desc12 = pt_desc2.


  if parent1 = parent2 and effdate1 = effdate2 then do:
    message "您在源结构和比较结构中输入了同一产品结构，请重新输入! " view-as alert-box.
    next-prompt parent1 with frame a.
    undo, retry.
  end.

  disp desc1 desc2 desc11 desc12 with frame a.

  update showall with frame a.

    for each mybomcmp exclusive-lock:
      delete mybomcmp.
    end.
    empty temp-table tmpbom1 no-error.
    vqty = 1.
    if substring(trim(parent1),length(trim(parent1)) - 1) = "ZZ" then do:
       assign vsite = "dcec-b".
    end.
    else do:
       assign vsite = "dcec-c".
    end.
    message vsite view=as alert-box.
    run process_report (input parent1 ,input parent1 ,input effdate1,input 1).
    for each tmpbom1 exclusive-lock:
       find first ptp_det no-lock where pt_domain = global_domain
       and ptp_part = tb1_comp and ptp_site = vsite no-error.
       if available ptp_det and ptp_pm_code <> "P" or not available ptp_det then do:
          delete tmpbom1.
       end.
    end.
    for each tmpbom1 no-lock:
        find first mybomcmp exclusive-lock where
                   bcomp = tb1_comp no-error.
        if not available mybomcmp then do:
           create mybomcmp.
           assign bcomp = tb1_comp.
        end.
           bqty1 = tb1_qty.
           bref1 = tb1_rmks.
    end.

    empty temp-table tmpbom1 no-error.
    if substring(trim(parent2),length(trim(parent2)) - 1) = "ZZ" then do:
       assign vsite = "dcec-b".
    end.
    else do:
       assign vsite = "dcec-c".
    end.
      message vsite view=as alert-box.
    vqty = 1.
    run process_report
            (input parent2,input parent2, input effdate2,input 1).
    for each tmpbom1 exclusive-lock:
       find first ptp_det no-lock where pt_domain = global_domain
       and ptp_part = tb1_comp and ptp_site = vsite no-error.
       if available ptp_det and ptp_pm_code <> "P" or not available ptp_det then do:
          delete tmpbom1.
       end.
    end.
    for each tmpbom1 no-lock:
        find first mybomcmp exclusive-lock where
                   bcomp = tb1_comp no-error.
        if not available mybomcmp then do:
           create mybomcmp.
           assign bcomp = tb1_comp.
        end.
           bqty2 = tb1_qty.
           bref2 = tb1_rmks.
    end.

    for each mybomcmp exclusive-lock:
        find first pt_mstr no-lock where pt_domain = global_domain and
                   pt_part = bcomp no-error.
        if available pt_mstr then do:
           assign bdesc = pt_desc1
                  bdesc2 = pt_desc2.
        end.
        else do:
             delete mybomcmp.
        end.
    end.

  /* Create a New chExcel Application object */
  CREATE "Excel.Application" chExcelApplication.
  /*Create a new workbook based on the template chExcel file */
  chExcelWorkbook = chExcelApplication:Workbooks:ADD.
  iRow = 1.
  chExcelWorkbook:Worksheets(1):Cells(iRow,1) = "产品结构比较报表".
  iRow = 2.
  chExcelWorkbook:Worksheets(1):Cells(iRow,1) = "序".
  chExcelWorkbook:Worksheets(1):Cells(iRow,2) = "子零件".
  chExcelWorkbook:Worksheets(1):Cells(iRow,3) = "描述一".
  chExcelWorkbook:Worksheets(1):Cells(iRow,4) = "描述二".
  chExcelWorkbook:Worksheets(1):Cells(iRow,5) = "'" + parent1.
  chExcelWorkbook:Worksheets(1):Cells(iRow,6) = "'" + parent2.
  chExcelWorkbook:Worksheets(1):Cells(iRow,7) = "差异数量".
  chExcelWorkbook:Worksheets(1):Cells(iRow,8) = parent1 + " - 随机带走件" .
  chExcelWorkbook:Worksheets(1):Cells(iRow,9) = parent2 + " - 随机带走件" .
  chExcelWorkbook:Worksheets(1):Range("E2"):AddComment.
  if effdate1 = ? then
    strdate = "".
  else
    strdate = string(effdate1).
  chExcelWorkbook:Worksheets(1):Range("E2"):Comment:Text("QAD:" + chr(10) + desc1 + chr(10) + desc11 + chr(10) + "生效日期" + strdate).
  chExcelWorkbook:Worksheets(1):Range("F2"):AddComment.
  if effdate2 = ? then
    strdate = "".
  else
    strdate = string(effdate2).
  chExcelWorkbook:Worksheets(1):Range("F2"):Comment:Text("QAD:" + chr(10) + desc2 + chr(10) + desc12 + chr(10) + "生效日期" + strdate).



  for each mybomcmp by mybomcmp.bcomp:
    if not showall then
      if mybomcmp.bqty2 = mybomcmp.bqty1 then
        next.
    iRow = iRow + 1.
    chExcelWorkbook:Worksheets(1):Cells(iRow,1) = string(iRow - 2).
    chExcelWorkbook:Worksheets(1):Cells(iRow,2) = "'" + mybomcmp.bcomp.
    chExcelWorkbook:Worksheets(1):Cells(iRow,3) = "'" + mybomcmp.bdesc.
    chExcelWorkbook:Worksheets(1):Cells(iRow,4) = "'" + mybomcmp.bdesc2.
    chExcelWorkbook:Worksheets(1):Cells(iRow,5) = string(mybomcmp.bqty1).
    chExcelWorkbook:Worksheets(1):Cells(iRow,6) = string(mybomcmp.bqty2).
    chExcelWorkbook:Worksheets(1):Cells(iRow,7) = string(mybomcmp.bqty2 - mybomcmp.bqty1).
    chExcelWorkbook:Worksheets(1):Cells(iRow,8) = "'" + string(mybomcmp.bref1).
    chExcelWorkbook:Worksheets(1):Cells(iRow,9) = "'" + string(mybomcmp.bref2).
  end.

  chExcelWorkbook:Worksheets(1):Range("A1:G1"):HorizontalAlignment = -4108.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):VerticalAlignment = -4107.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):WrapText = 0.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):Orientation = 0.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):AddIndent = 0.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):ShrinkToFit = 0.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):MergeCells = -1.

  chExcelWorkbook:Worksheets(1):Columns("A:A"):EntireColumn:AutoFit.
  chExcelWorkbook:Worksheets(1):Columns("B:B"):EntireColumn:AutoFit.
  chExcelWorkbook:Worksheets(1):Columns("C:C"):EntireColumn:AutoFit.
  chExcelWorkbook:Worksheets(1):Columns("D:D"):EntireColumn:AutoFit.
  chExcelWorkbook:Worksheets(1):Columns("E:E"):EntireColumn:AutoFit.
  chExcelWorkbook:Worksheets(1):Columns("F:F"):EntireColumn:AutoFit.
  chExcelWorkbook:Worksheets(1):Columns("G:G"):EntireColumn:AutoFit.
  chExcelWorkbook:Worksheets(1):Columns("H:H"):EntireColumn:AutoFit.
  chExcelWorkbook:Worksheets(1):Columns("I:I"):EntireColumn:AutoFit.


  chExcelApplication:Visible = True.
  hide message.
  message "报表运行结束.".

/*   chExcelWorkbook:PrintPreview.*/

   /**The tailer of the program**/
   /* close the Excel file */
/*   chExcelWorkbook:CLOSE.
   chExcelApplication:Workbooks:CLOSE.
   chExcelApplication:QUIT.
*/
   /* release com - handles */
   RELEASE OBJECT chExcelWorkbook.
   /*release object chexcelworkbooktemp .*/
   RELEASE OBJECT chExcelApplication.


end. /*repeat*/


