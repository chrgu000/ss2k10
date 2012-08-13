/*Po Tracking List*/

&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
{mfdtitle.i "b+ "}
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF  VAR chWorksheetRange     AS COM-HANDLE.
DEF  VAR iColumn              AS INT INIT 1.
DEF  VAR Rowstart             AS INT INIT 1.
DEF  VAR Rowsecstart          AS INT INIT 1.
DEF  VAR Rowend               AS INT INIT 1.
DEF  VAR key1                 AS INT INIT 1.
DEF  VAR cColumn              AS CHAR.
DEF  VAR cRange               AS CHAR.
DEF  VAR ctr2                 AS INT.
DEFINE VAR sumday AS DATE.
DEFINE VAR pagesum AS INT INITIAL 0.
DEF VAR oktocomt AS LOGICAL.
DEFINE VAR rowjs AS INT.        
DEFINE VAR monthjs AS INT.
DEFINE   NEW  SHARED  VARIABLE  vend LIKE  po_vend.
DEFINE   NEW  SHARED  VARIABLE  vend1 LIKE  po_vend.
DEFINE   NEW  SHARED  VARIABLE  date1 LIKE  po_ord_date.
DEFINE   NEW  SHARED  VARIABLE  date2 LIKE  po_ord_date.
DEFINE VAR qty_pur LIKE pod_qty_ord EXTENT 39.
DEFINE VAR qty_trans LIKE pod_qty_ord EXTENT 39.
DEFINE VAR qtynow LIKE pod_qty_ord.
{gprunpdf.i "mcpl" "p"}
&SCOPED-DEFINE PP_FRAME_NAME A

FORM  
             
 SKIP(1.1) 
            vend           COLON  20
            vend1          LABEL  {t001.i} COLON  49 SKIP 
            date1           COLON  20
            date2          LABEL  {t001.i} COLON  49 SKIP 
 
          SKIP(.4)  
WITH  FRAME  a SIDE-LABELS  WIDTH  80 ATTR-SPACE  NO-BOX THREE-D .
 
setFrameLabels(FRAME a:HANDLE). 
REPEAT:
    IF MONTH(TODAY) =  12 THEN DO:
       ASSIGN sumday = DATE("01/01/" + STRING(YEAR(TODAY) + 1)).
    END.
    ELSE DO:
       ASSIGN sumday = DATE(STRING(MONTH(TODAY) + 1) + "/01/" + STRING(YEAR(TODAY))).
    END.
   
    ASSIGN qty_pur = 0.
    ASSIGN qty_trans = 0.
    PROMPT-FOR vend vend1 date1 date2 WITH FRAME a.
    ASSIGN vend vend1 date1 date2.
    IF vend1 = "" THEN  vend1 = hi_char.
    if date1 = ? then date1 = low_date.
    if date2 = ? then date2 = hi_date.
    MESSAGE "确认将报表导出吗" SKIP(1)
        "继续?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.
 
    IF oktocomt THEN
    DO:
       hide message no-pause.
       iColumn = 1.
       create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = true.
       chWorkbook = chExcelApplication:Workbooks:Add().
       chWorkSheet = chExcelApplication:Sheets:Item(1).
       chExcelApplication:Sheets:Item(1):SELECT().
       chExcelApplication:Sheets:Item(1):NAME = "Po Packing List".
       chWorkSheet:Rows("1"):RowHeight = 29.25.
       chWorkSheet:Rows("2:20"):RowHeight = 12.25.
       chWorkSheet:Columns("A"):ColumnWidth = 10.
       chWorkSheet:Columns("B"):ColumnWidth = 8.25.
       chWorkSheet:Columns("C"):ColumnWidth = 10.
       chWorkSheet:Columns("D"):ColumnWidth = 15.
       chWorkSheet:Columns("E"):ColumnWidth = 27.
       chWorkSheet:Columns("F"):ColumnWidth = 10.
       chWorkSheet:Columns("G"):ColumnWidth = 8.25.
       chWorkSheet:Columns("H"):ColumnWidth = 10.
       chWorkSheet:Columns("I"):ColumnWidth = 8.25.
       chWorkSheet:Columns("J"):ColumnWidth = 10.
       chWorkSheet:Columns("K"):ColumnWidth = 8.25.
       chWorkSheet:Columns("L"):ColumnWidth = 15.
       chWorkSheet:Columns("M"):ColumnWidth = 10.
       chWorkSheet:Columns("N"):ColumnWidth = 10.
       chWorkSheet:Columns("O"):ColumnWidth = 8.25.
       chWorkSheet:Range("A4"):Select().
       chExcelApplication:ActiveWindow:FreezePanes = True.
       chExcelApplication:ActiveWindow:Zoom = 85.
       cColumn = string(iColumn).
       cRange = "A1:O3".
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 3.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       cRange = "A4:A500".
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 1.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       cRange = "B4:B500".
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 1.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       chExcelApplication:selection:NumberFormat = "MM/DD/YYYY".
       cRange = "C3:C500".
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 1.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       cRange = "D3:E500".
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 1.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       cRange = "J1:K1".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  TODAY.
       cRange = "A2:A3".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Supplier NO".
       cRange = "B2:B3".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Iss Date".
       cRange = "C2:C3".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "PO No.".
       cRange = "D2:D3".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Part No.".
       cRange = "E2:E3".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Description".
       cRange = "F2:G2".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Asked as PO".
       chWorkSheet:Range("F3"):value =  "Quantity".
       chWorkSheet:Range("G3"):value =  "Date".
       cRange = "H2:I2".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Promised by Supplier".
       chWorkSheet:Range("H3"):value =  "Quantity".
       chWorkSheet:Range("I3"):value =  "Date".
       cRange = "J2:K2".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Actual Received @ ZJGP".
       chWorkSheet:Range("J3"):value =  "Quantity".
       chWorkSheet:Range("K3"):value =  "Date".
       cRange = "L2:L3".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Remark".
       cRange = "M2:M3".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Shortage".
       cRange = "N2:O2".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Replacement @ ZJGP".
       chWorkSheet:Range("N3"):value =  "Quantity".
       chWorkSheet:Range("O3"):value =  "Date".
       chWorkSheet:Range("P3"):value =  "Iss Date".
       ASSIGN Rowstart = 3.
       ASSIGN Rowsecstart = 3.
       ASSIGN Rowend = 3.
       FOR EACH ad_mstr USE-INDEX ad_addr NO-LOCK WHERE ad_addr >= vend AND ad_addr <= vend1:
           FIND FIRST po_mstr USE-INDEX po_vend NO-LOCK WHERE po_vend = ad_addr AND po_stat <> "x" AND po_type <> "B" AND po_ord_date >= date1 AND po_ord_date <= date2 NO-ERROR.
           IF AVAILABLE po_mstr THEN DO:
              ASSIGN key1 = 0.
           END.
           ELSE DO:
              ASSIGN key1 = 2.
           END.
           FOR EACH po_mstr USE-INDEX po_vend NO-LOCK WHERE po_vend = ad_addr AND po_stat <> "x" AND po_type <> "B" AND po_ord_date >= date1 AND po_ord_date <= date2 BY po_ord_date:
               FIND FIRST pod_det USE-INDEX pod_nbrln NO-LOCK WHERE pod_nbr = po_nbr /*AND pod_status <> "C" */ AND pod_status <> "x" NO-ERROR.
               IF AVAILABLE pod_det THEN DO:
                  IF key1 = 0 THEN DO:
                     ASSIGN key1 = 1.
                     ASSIGN Rowstart = Rowend + 1.
                  END.
                  ASSIGN Rowsecstart = Rowend + 1.
               END.
               FOR EACH pod_det USE-INDEX pod_nbrln NO-LOCK WHERE pod_nbr = po_nbr /*AND pod_status <> "C" */ AND pod_status <> "x":
                  ASSIGN Rowend = Rowend + 1.
                  cRange = "D" + STRING(Rowend) + ":D" + STRING(Rowend).
                  chWorkSheet:Range(cRange):value =  pod_part.
                  FIND FIRST pt_mstr NO-LOCK WHERE pt_part = pod_part NO-ERROR.
                  IF AVAILABLE pt_mstr THEN DO:
                     cRange = "E" + STRING(Rowend) + ":E" + STRING(Rowend).
                     chWorkSheet:Range(cRange):value =  pt_desc1.
                  END.
                  cRange = "F" + STRING(Rowend) + ":F" + STRING(Rowend).
                  chWorkSheet:Range(cRange):value =  pod_qty_ord.
                  chWorkSheet:Range(cRange):Select().
                  chexcelApplication:Selection:Font:Size = 10. 
                  chExcelApplication:selection:HorizontalAlignment = 1.
                  chExcelApplication:selection:VerticalAlignment = 2.
                  chExcelApplication:selection:Font:Name = "Arial".
                  chExcelApplication:selection:Font:Bold = True.
                  chExcelApplication:selection:NumberFormat = "0.00_ ".
                  cRange = "G" + STRING(Rowend) + ":G" + STRING(Rowend).
                  chWorkSheet:Range(cRange):value =  pod_need.
                  chWorkSheet:Range(cRange):Select().
                  chexcelApplication:Selection:Font:Size = 10. 
                  chExcelApplication:selection:HorizontalAlignment = 3.
                  chExcelApplication:selection:VerticalAlignment = 2.
                  chExcelApplication:selection:Font:Name = "Arial".
                  chExcelApplication:selection:Font:Bold = True.
                  chExcelApplication:selection:NumberFormat = "MM/DD/YYYY".
                  cRange = "J" + STRING(Rowend) + ":J" + STRING(Rowend).
                  chWorkSheet:Range(cRange):value =  pod_qty_rcvd.
                  chWorkSheet:Range(cRange):Select().
                  chexcelApplication:Selection:Font:Size = 10. 
                  chExcelApplication:selection:HorizontalAlignment = 1.
                  chExcelApplication:selection:VerticalAlignment = 2.
                  chExcelApplication:selection:Font:Name = "Arial".
                  chExcelApplication:selection:Font:Bold = True.
                  chExcelApplication:selection:NumberFormat = "0.00_ ".
                  FIND LAST prh_hist USE-INDEX prh_rcp_date NO-LOCK WHERE prh_nbr = po_nbr AND prh_line = pod_line NO-ERROR.
                  IF AVAILABLE prh_hist THEN  DO:
                     cRange = "K" + STRING(Rowend) + ":K" + STRING(Rowend).
                     chWorkSheet:Range(cRange):value =  prh_rcp_date.
                     chWorkSheet:Range(cRange):Select().
                     chexcelApplication:Selection:Font:Size = 10. 
                     chExcelApplication:selection:HorizontalAlignment = 3.
                     chExcelApplication:selection:VerticalAlignment = 2.
                     chExcelApplication:selection:Font:Name = "Arial".
                     chExcelApplication:selection:Font:Bold = True.
                     chExcelApplication:selection:NumberFormat = "MM/DD/YYYY".
                  END.
                  cRange = "M" + STRING(Rowend) + ":M" + STRING(Rowend).
                  chWorkSheet:Range(cRange):value =  pod_qty_ord - pod_qty_rcvd.
                  chWorkSheet:Range(cRange):Select().
                  chexcelApplication:Selection:Font:Size = 10. 
                  chExcelApplication:selection:HorizontalAlignment = 1.
                  chExcelApplication:selection:VerticalAlignment = 2.
                  chExcelApplication:selection:Font:Name = "Arial".
                  chExcelApplication:selection:Font:Bold = True.
                  chExcelApplication:selection:NumberFormat = "0.00_ ".


                  FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = po_nbr AND qad_key2 = pod_part NO-ERROR.
                  IF AVAILABLE qad_wkfl THEN DO:
                     cRange = "H" + STRING(Rowend) + ":H" + STRING(Rowend).
                     chWorkSheet:Range(cRange):value =  qad_decfld[1].
                     chWorkSheet:Range(cRange):Select().
                     chexcelApplication:Selection:Font:Size = 10. 
                     chExcelApplication:selection:HorizontalAlignment = 1.
                     chExcelApplication:selection:VerticalAlignment = 2.
                     chExcelApplication:selection:Font:Name = "Arial".
                     chExcelApplication:selection:Font:Bold = True.
                     chExcelApplication:selection:NumberFormat = "0.00_ ".
                     cRange = "I" + STRING(Rowend) + ":I" + STRING(Rowend).
                     chWorkSheet:Range(cRange):value =  qad_datefld[1].
                     chWorkSheet:Range(cRange):Select().
                     chexcelApplication:Selection:Font:Size = 10. 
                     chExcelApplication:selection:HorizontalAlignment = 3.
                     chExcelApplication:selection:VerticalAlignment = 2.
                     chExcelApplication:selection:Font:Name = "Arial".
                     chExcelApplication:selection:Font:Bold = True.
                     chExcelApplication:selection:NumberFormat = "MM/DD/YYYY".
                     cRange = "M" + STRING(Rowend) + ":M" + STRING(Rowend).
                     chWorkSheet:Range(cRange):value =  qad_decfld[2].
                     chWorkSheet:Range(cRange):Select().
                     chexcelApplication:Selection:Font:Size = 10. 
                     chExcelApplication:selection:HorizontalAlignment = 1.
                     chExcelApplication:selection:VerticalAlignment = 2.
                     chExcelApplication:selection:Font:Name = "Arial".
                     chExcelApplication:selection:Font:Bold = True.
                     chExcelApplication:selection:NumberFormat = "0.00_ ".
                     cRange = "O" + STRING(Rowend) + ":O" + STRING(Rowend).
                     chWorkSheet:Range(cRange):value =  qad_datefld[2].
                     chWorkSheet:Range(cRange):Select().
                     chexcelApplication:Selection:Font:Size = 10. 
                     chExcelApplication:selection:HorizontalAlignment = 3.
                     chExcelApplication:selection:VerticalAlignment = 2.
                     chExcelApplication:selection:Font:Name = "Arial".
                     chExcelApplication:selection:Font:Bold = True.
                     chExcelApplication:selection:NumberFormat = "MM/DD/YYYY".
                     cRange = "L" + STRING(Rowend) + ":L" + STRING(Rowend).
                     chWorkSheet:Range(cRange):value =  qad_charfld[1].
                     chWorkSheet:Range(cRange):Select().
                     chexcelApplication:Selection:Font:Size = 10. 
                     chExcelApplication:selection:HorizontalAlignment = 1.
                     chExcelApplication:selection:VerticalAlignment = 2.
                     chExcelApplication:selection:Font:Name = "Arial".
                     chExcelApplication:selection:Font:Bold = True.
                  END.




               END.
               FIND FIRST pod_det USE-INDEX pod_nbrln NO-LOCK WHERE pod_nbr = po_nbr /*AND pod_status <> "C" */ AND pod_status <> "x" NO-ERROR.
               IF AVAILABLE pod_det THEN DO:
                  cColumn = string(Rowsecstart).
                  cRange = "C" + cColumn + ":C" + STRING(Rowend).
                  chWorkSheet:Range(cRange):Select().
                  chExcelApplication:selection:Merge.
                  chWorkSheet:Range(cRange):value =  po_nbr.
                  cRange = "B" + STRING(Rowsecstart) + ":B" + STRING(Rowend).
                  chWorkSheet:Range(cRange):Select().
                  chExcelApplication:selection:Merge.
                  chWorkSheet:Range(cRange):value =  po_ord_date.
               END.
           END.
           IF key1 = 1 THEN DO:
              cRange = "A" + STRING(Rowstart) + ":A" + STRING(Rowend).
              chWorkSheet:Range(cRange):Select().
              chExcelApplication:selection:Merge.
              chWorkSheet:Range(cRange):value =  "'" + ad_addr.
              ASSIGN key1 = 0.
           END.
       END.
       cRange = "A1:O3".
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 3.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       cRange = "A4:A" + STRING(Rowend).
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 1.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       cRange = "B4:B" + STRING(Rowend).
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 1.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       chExcelApplication:selection:NumberFormat = "MM/DD/YYYY".
       cRange = "C3:C" + STRING(Rowend).
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 1.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       cRange = "D3:E" + STRING(Rowend).
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 1.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       chWorkSheet:Range("A2:O2"):Select().
       chExcelApplication:selection:Borders(8):Weight = 2.
       chWorkSheet:Range("A2:O" + string(Rowend)):Select().
       chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
       chWorkSheet:Range("O2:O" + string(Rowend)):Select().
       chExcelApplication:selection:Borders(10):Weight = 2.
       cRange = "A1:I1".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Outstanding PO List".
       chExcelApplication:selection:Font:SIZE = 18.
       RELEASE OBJECT chWorksheet.
       RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.
    END.
END.
