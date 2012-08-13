/*Spending AP PPV*/

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
DEF  VAR Rowend               AS INT INIT 1.
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
DEFINE VAR qty_pur LIKE pod_qty_ord EXTENT 39.
DEFINE VAR qty_trans LIKE pod_qty_ord EXTENT 39.
DEFINE VAR qtynow LIKE pod_qty_ord.
DEFINE VAR dispcs AS INT.
{gprunpdf.i "mcpl" "p"}
&SCOPED-DEFINE PP_FRAME_NAME A

FORM  
             
 SKIP(1.1) 
            vend           COLON  20
            vend1          LABEL  {t001.i} COLON  49 SKIP 
 
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
    PROMPT-FOR vend vend1 WITH FRAME a.
    ASSIGN vend vend1.
    IF vend1 = "" THEN  vend1 = hi_char.
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
       chExcelApplication:Sheets:Item(1):NAME = "Spending-AP-PPV".
       chWorkSheet:Rows("1:20"):RowHeight = 12.25.
       chWorkSheet:Columns("A"):ColumnWidth = 2.
       chWorkSheet:Columns("B"):ColumnWidth = 2.
       chWorkSheet:Columns("C"):ColumnWidth = 15.
       chWorkSheet:Columns("D"):ColumnWidth = 35.
       chWorkSheet:Columns("E"):ColumnWidth = 35.
       chWorkSheet:Columns("F"):ColumnWidth = 15.
       chWorkSheet:Columns("G:AS"):ColumnWidth = 8.
       cRange = "A1:AS400".
       chWorkSheet:Range(cRange):Select().
       chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 3.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "Arial".
       chExcelApplication:selection:Font:Bold = True.
       chWorkSheet:Range("D3"):Select().
       chExcelApplication:ActiveWindow:FreezePanes = True.
       chExcelApplication:ActiveWindow:Zoom = 85.
       cColumn = string(iColumn).
       cRange = "A1:C2".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Supplier Family".
       cRange = "D1:D2".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge. 
       chWorkSheet:Range(cRange):value =  "Supplier Name-Chinese".
       cRange = "E1:E2".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge. 
       chWorkSheet:Range(cRange):value =  "Supplier Name-English".
       cRange = "F1:F2".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge. 
       chWorkSheet:Range(cRange):value =  "Supplier Code".
       cRange = "G1:S1".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge. 
       chWorkSheet:Range(cRange):value =  STRING(YEAR(TODAY)) + " Spending (RMB)".
       cRange = "T1:AF1".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge. 
       chWorkSheet:Range(cRange):value =  STRING(YEAR(TODAY)) + " PPV ( RMB)".
       cRange = "AG1:AS1".
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge. 
       chWorkSheet:Range(cRange):value =  STRING(YEAR(TODAY)) + " AP ( RMB)".
       cRange = "G2:G2".
       chWorkSheet:Range(cRange):value =  "YTD".
       cRange = "H2:H2".
       chWorkSheet:Range(cRange):value =  "Jan".
       cRange = "I2:I2".
       chWorkSheet:Range(cRange):value =  "Feb".
       cRange = "J2:J2".
       chWorkSheet:Range(cRange):value =  "Mar".
       cRange = "K2:K2".
       chWorkSheet:Range(cRange):value =  "Apr".
       cRange = "L2:L2".
       chWorkSheet:Range(cRange):value =  "May".
       cRange = "M2:M2".
       chWorkSheet:Range(cRange):value =  "Jun".
       cRange = "N2:N2".
       chWorkSheet:Range(cRange):value =  "Jul".
       cRange = "O2:O2".
       chWorkSheet:Range(cRange):value =  "Aug".
       cRange = "P2:P2".
       chWorkSheet:Range(cRange):value =  "Sep".
       cRange = "Q2:Q2".
       chWorkSheet:Range(cRange):value =  "Oct".
       cRange = "R2:R2".
       chWorkSheet:Range(cRange):value =  "Nov".
       cRange = "S2:S2".
       chWorkSheet:Range(cRange):value =  "Dec".
       cRange = "T2:T2".
       chWorkSheet:Range(cRange):value =  "YTD".
       cRange = "U2:U2".
       chWorkSheet:Range(cRange):value =  "Jan".
       cRange = "V2:V2".
       chWorkSheet:Range(cRange):value =  "Feb".
       cRange = "W2:W2".
       chWorkSheet:Range(cRange):value =  "Mar".
       cRange = "X2:X2".
       chWorkSheet:Range(cRange):value =  "Apr".
       cRange = "Y2:Y2".
       chWorkSheet:Range(cRange):value =  "May".
       cRange = "Z2:Z2".
       chWorkSheet:Range(cRange):value =  "Jun".
       cRange = "AA2:AA2".
       chWorkSheet:Range(cRange):value =  "Jul".
       cRange = "AB2:AB2".
       chWorkSheet:Range(cRange):value =  "Aug".
       cRange = "AC2:AC2".
       chWorkSheet:Range(cRange):value =  "Sep".
       cRange = "AD2:AD2".
       chWorkSheet:Range(cRange):value =  "Oct".
       cRange = "AE2:AE2".
       chWorkSheet:Range(cRange):value =  "Nov".
       cRange = "AF2:AF2".
       chWorkSheet:Range(cRange):value =  "Dec".
       cRange = "AG2:AG2".
       chWorkSheet:Range(cRange):value =  "YTD".
       cRange = "AH2:AH2".
       chWorkSheet:Range(cRange):value =  "Jan".
       cRange = "AI2:AI2".
       chWorkSheet:Range(cRange):value =  "Feb".
       cRange = "AJ2:AJ2".
       chWorkSheet:Range(cRange):value =  "Mar".
       cRange = "AK2:AK2".
       chWorkSheet:Range(cRange):value =  "Apr".
       cRange = "AL2:AL2".
       chWorkSheet:Range(cRange):value =  "May".
       cRange = "AM2:AM2".
       chWorkSheet:Range(cRange):value =  "Jun".
       cRange = "AN2:AN2".
       chWorkSheet:Range(cRange):value =  "Jul".
       cRange = "AO2:AO2".
       chWorkSheet:Range(cRange):value =  "Aug".
       cRange = "AP2:AP2".
       chWorkSheet:Range(cRange):value =  "Sep".
       cRange = "AQ2:AQ2".
       chWorkSheet:Range(cRange):value =  "Oct".
       cRange = "AR2:AR2".
       chWorkSheet:Range(cRange):value =  "Nov".
       cRange = "AS2:AS2".
       chWorkSheet:Range(cRange):value =  "Dec".
       ASSIGN Rowstart = 3.
       /*dispcs delete
       ASSIGN Rowend = 2.
       */
       /*dispcs*/
       ASSIGN Rowend = 3.
       DEFINE VAR jsq1 AS INT.
       ASSIGN jsq1 = 0.
       /*DISPCS*/
       FOR EACH vd_mstr WHERE vd_type = "" AND vd_addr <> "Z1013" AND vd_addr <> "Z5306" AND vd_addr <> "Z5043" AND vd_addr <> "Z5262" AND vd_addr <> "Z5055" AND vd_addr <> "Z5118":
          FIND ad_mstr WHERE ad_addr = vd_addr NO-ERROR.
          IF AVAILABLE ad_mstr THEN DO:
             /*dispcs delete
                ASSIGN Rowend = Rowend + 1.
             */
             /*dispcs*/
             dispcs = 0.
             /*DISPCS*/
             cColumn = string(Rowend).
             cRange = "D" + cColumn.
             chWorkSheet:Range(cRange):value =  ad_name.
             chWorkSheet:Range(cRange):Select().
             chExcelApplication:selection:HorizontalAlignment = 2.
             cRange = "E" + cColumn.
             chWorkSheet:Range(cRange):value =  ad_line1.
             chWorkSheet:Range(cRange):Select().
             chExcelApplication:selection:HorizontalAlignment = 2.
             cRange = "F" + cColumn.
             chWorkSheet:Range(cRange):value =  ad_addr.
             ASSIGN monthjs = 1.
             DO WHILE monthjs <= 12:
                ASSIGN qtynow = 0.
                FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = vd_addr AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
                    ASSIGN qtynow = qtynow + prh_pur_cost * prh_rcvd * prh_um_conv * prh_ex_rate.
                END.
                /*DIPSCS*/
                IF qtynow = 0 THEN DO:
                   dispcs = dispcs + 1.
                END.
                /*DISPCS*/
                CASE monthjs: 
                   WHEN 1 THEN DO:
                      cRange = "H" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 2 THEN DO:
                      cRange = "I" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 3 THEN DO:
                      cRange = "J" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 4 THEN DO:
                      cRange = "K" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 5 THEN DO:
                      cRange = "L" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 6 THEN DO:
                      cRange = "M" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 7 THEN DO:
                      cRange = "N" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 8 THEN DO:
                      cRange = "O" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 9 THEN DO:
                      cRange = "P" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 10 THEN DO:
                      cRange = "Q" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 11 THEN DO:
                      cRange = "R" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 12 THEN DO:
                      cRange = "S" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                END CASE.
                ASSIGN qty_pur[(monthjs + 1)] = qty_pur[(monthjs + 1)] + qtynow.
                ASSIGN qty_pur[1] = qty_pur[1] + qtynow.
                ASSIGN monthjs = monthjs + 1.
             END.
             chWorkSheet:Range("G" + cColumn):VALUE = chWorkSheet:Range("H" + cColumn):VALUE + chWorkSheet:Range("I" + cColumn):VALUE + chWorkSheet:Range("J" + cColumn):VALUE + chWorkSheet:Range("K" + cColumn):VALUE + chWorkSheet:Range("L" + cColumn):VALUE + chWorkSheet:Range("M" + cColumn):VALUE + chWorkSheet:Range("N" + cColumn):VALUE + chWorkSheet:Range("O" + cColumn):VALUE + chWorkSheet:Range("P" + cColumn):VALUE + chWorkSheet:Range("Q" + cColumn):VALUE + chWorkSheet:Range("R" + cColumn):VALUE + chWorkSheet:Range("S" + cColumn):VALUE.
             chWorkSheet:Range("G" + cColumn):Select().
             chExcelApplication:selection:HorizontalAlignment = 1.
             ASSIGN monthjs = 1.
             DO WHILE monthjs <= 12:
                ASSIGN qtynow = 0.
                FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = vd_addr AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
                    ASSIGN qtynow = qtynow + (prh_pur_cost - prh_pur_std) * prh_rcvd * prh_um_conv * prh_ex_rate.
                END.
                CASE monthjs: 
                   WHEN 1 THEN DO:
                      cRange = "U" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 2 THEN DO:
                      cRange = "V" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 3 THEN DO:
                      cRange = "W" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 4 THEN DO:
                      cRange = "X" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 5 THEN DO:
                      cRange = "Y" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 6 THEN DO:
                      cRange = "Z" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 7 THEN DO:
                      cRange = "AA" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 8 THEN DO:
                      cRange = "AB" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 9 THEN DO:
                      cRange = "AC" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 10 THEN DO:
                      cRange = "AD" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 11 THEN DO:
                      cRange = "AE" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                   WHEN 12 THEN DO:
                      cRange = "AF" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qtynow.
                   END.
                END CASE.
                ASSIGN qty_pur[(monthjs + 14)] = qty_pur[(monthjs + 14)] + qtynow.
                ASSIGN qty_pur[14] = qty_pur[14] + qtynow.
                ASSIGN monthjs = monthjs + 1.
             END.
             chWorkSheet:Range("T" + cColumn):VALUE = chWorkSheet:Range("U" + cColumn):VALUE + chWorkSheet:Range("V" + cColumn):VALUE + chWorkSheet:Range("W" + cColumn):VALUE + chWorkSheet:Range("X" + cColumn):VALUE + chWorkSheet:Range("Y" + cColumn):VALUE + chWorkSheet:Range("Z" + cColumn):VALUE + chWorkSheet:Range("AA" + cColumn):VALUE + chWorkSheet:Range("AB" + cColumn):VALUE + chWorkSheet:Range("AC" + cColumn):VALUE + chWorkSheet:Range("AD" + cColumn):VALUE + chWorkSheet:Range("AE" + cColumn):VALUE + chWorkSheet:Range("AF" + cColumn):VALUE.
             chWorkSheet:Range("T" + cColumn):Select().
             chExcelApplication:selection:HorizontalAlignment = 1.
             ASSIGN qtynow = 0.
             FOR EACH ap_mstr USE-INDEX ap_open NO-LOCK WHERE ap_vend = vd_addr AND ap_type = "VO" AND ap_open = YES:
                 FIND FIRST vo_mstr NO-LOCK WHERE vo_ref = ap_ref AND vo_confirmed = YES AND (vo_due_date < sumday OR  vo_due_date = ?)NO-ERROR.
                 IF AVAILABLE vo_mstr THEN DO:
                    FOR EACH vod_det NO-LOCK USE-INDEX vod_ref WHERE vod_ref = ap_ref:
                        ASSIGN qtynow = qtynow + vod_base_amt.
                    END.
                 END.
             END.
             FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = vd_addr AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
             IF AVAILABLE qad_wkfl THEN DO:
                ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
             END.
             ELSE DO:
                CREATE qad_wkfl.
                ASSIGN qad_key1 = "SUN-SOFT".
                ASSIGN qad_key2 = vd_addr.
                ASSIGN qad_intfld[1] = YEAR(TODAY).
                ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
             END.

             ASSIGN monthjs = 1.
             DO WHILE monthjs <= 12:
                FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = vd_addr AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
                CASE monthjs: 
                   WHEN 1 THEN DO:
                      cRange = "AH" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 2 THEN DO:
                      cRange = "AI" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 3 THEN DO:
                      cRange = "AJ" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 4 THEN DO:
                      cRange = "AK" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 5 THEN DO:
                      cRange = "AL" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 6 THEN DO:
                      cRange = "AM" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 7 THEN DO:
                      cRange = "AN" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 8 THEN DO:
                      cRange = "AO" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 9 THEN DO:
                      cRange = "AP" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 10 THEN DO:
                      cRange = "AQ" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 11 THEN DO:
                      cRange = "AR" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                   WHEN 12 THEN DO:
                      cRange = "AS" + cColumn.
                      chWorkSheet:Range(cRange):Select().
                      chExcelApplication:selection:HorizontalAlignment = 1.
                      chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                   END.
                END CASE.
                ASSIGN qty_pur[(monthjs + 27)] = qty_pur[(monthjs + 27)] + qad_decfld[monthjs].
                ASSIGN qty_pur[27] = qty_pur[27] + qad_decfld[monthjs].
                ASSIGN monthjs = monthjs + 1.
             END.
             /*dispcs*/
             IF dispcs < 12 THEN DO:
                ASSIGN jsq1 = 1.
                ASSIGN Rowend = Rowend + 1.
             END.
             /*dispcs*/

          END.
       END.
       FIND FIRST vd_mstr NO-LOCK WHERE vd_type = "" AND vd_addr <> "Z1013" AND vd_addr <> "Z5306" AND vd_addr <> "Z5043" AND vd_addr <> "Z5262" AND vd_addr <> "Z5055" AND vd_addr <> "Z5118" NO-ERROR.
       IF AVAILABLE vd_mstr THEN DO:
          IF jsq1 = 1 THEN DO:
             cRange = "C3:C" + string(Rowend).
             chWorkSheet:Range(cRange):Select().
             chExcelApplication:selection:Merge.
             chWorkSheet:Range(cRange):value =  "".
          END.
          ELSE DO:
             ASSIGN Rowend = 2.
          END.
       END.
       ELSE DO:
           ASSIGN Rowend = 2.
       END.
       ASSIGN dispcs = 0.
       ASSIGN  Rowstart = Rowend + 1.
       FOR EACH code_mstr NO-LOCK WHERE code_fldname = "vd_type":
          ASSIGN jsq1 = 0.
          /*dispcs*/
          /*
          FIND FIRST vd_mstr NO-LOCK WHERE vd_type = code_value AND vd_addr <> "Z1013" AND vd_addr <> "Z5306" AND vd_addr <> "Z5043" AND vd_addr <> "Z5262" AND vd_addr <> "Z5055" AND vd_addr <> "Z5118" NO-ERROR.
          IF AVAILABLE vd_mstr THEN DO:
             IF jsq1 = 1 THEN DO:
                ASSIGN  Rowstart = Rowend + 1.
             END.
          END.
          */
          /*dispcs*/
          /*dispcs delete
          ASSIGN  Rowstart = Rowend + 1.
          */
          FOR EACH vd_mstr WHERE vd_type = code_value AND vd_addr <> "Z1013" AND vd_addr <> "Z5306" AND vd_addr <> "Z5043" AND vd_addr <> "Z5262" AND vd_addr <> "Z5055" AND vd_addr <> "Z5118":
             FIND ad_mstr WHERE ad_addr = vd_addr NO-ERROR.
             IF AVAILABLE ad_mstr THEN DO:
                /*dispcs*/
                IF dispcs < 12 THEN DO:
                   ASSIGN Rowend = Rowend + 1.
                END.
                ASSIGN dispcs = 0.
                /*dispcs*/
                /*dispcs delete
                ASSIGN Rowend = Rowend + 1.
                */
                cColumn = string(Rowend).
                cRange = "D" + cColumn.
                chWorkSheet:Range(cRange):value =  ad_name.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 2.
                cRange = "E" + cColumn.
                chWorkSheet:Range(cRange):value =  ad_line1.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 2.
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):value =  ad_addr.
                ASSIGN monthjs = 1.
                DO WHILE monthjs <= 12:
                   ASSIGN qtynow = 0.
                   FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = vd_addr AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
                       ASSIGN qtynow = qtynow + prh_pur_cost * prh_rcvd * prh_um_conv * prh_ex_rate.
                   END.
                   /*DIPSCS*/
                   IF qtynow = 0 THEN DO:
                      dispcs = dispcs + 1.
                   END.
                   /*DISPCS*/
                   CASE monthjs: 
                      WHEN 1 THEN DO:
                         cRange = "H" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 2 THEN DO:
                         cRange = "I" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 3 THEN DO:
                         cRange = "J" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 4 THEN DO:
                         cRange = "K" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 5 THEN DO:
                         cRange = "L" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 6 THEN DO:
                         cRange = "M" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 7 THEN DO:
                         cRange = "N" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 8 THEN DO:
                         cRange = "O" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 9 THEN DO:
                         cRange = "P" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 10 THEN DO:
                         cRange = "Q" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 11 THEN DO:
                         cRange = "R" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 12 THEN DO:
                         cRange = "S" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                   END CASE.
                   ASSIGN qty_pur[(monthjs + 1)] = qty_pur[(monthjs + 1)] + qtynow.
                   ASSIGN qty_pur[1] = qty_pur[1] + qtynow.
                   ASSIGN monthjs = monthjs + 1.
                END.
                IF dispcs < 12 THEN DO:
                   jsq1 = 1.
                END.
                chWorkSheet:Range("G" + cColumn):VALUE = chWorkSheet:Range("H" + cColumn):VALUE + chWorkSheet:Range("I" + cColumn):VALUE + chWorkSheet:Range("J" + cColumn):VALUE + chWorkSheet:Range("K" + cColumn):VALUE + chWorkSheet:Range("L" + cColumn):VALUE + chWorkSheet:Range("M" + cColumn):VALUE + chWorkSheet:Range("N" + cColumn):VALUE + chWorkSheet:Range("O" + cColumn):VALUE + chWorkSheet:Range("P" + cColumn):VALUE + chWorkSheet:Range("Q" + cColumn):VALUE + chWorkSheet:Range("R" + cColumn):VALUE + chWorkSheet:Range("S" + cColumn):VALUE.
                chWorkSheet:Range("G" + cColumn):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                ASSIGN monthjs = 1.
                DO WHILE monthjs <= 12:
                   ASSIGN qtynow = 0.
                   FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = vd_addr AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
                       ASSIGN qtynow = qtynow + (prh_pur_cost - prh_pur_std) * prh_rcvd * prh_um_conv * prh_ex_rate.
                   END.
                   CASE monthjs: 
                      WHEN 1 THEN DO:
                         cRange = "U" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 2 THEN DO:
                         cRange = "V" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 3 THEN DO:
                         cRange = "W" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 4 THEN DO:
                         cRange = "X" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 5 THEN DO:
                         cRange = "Y" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 6 THEN DO:
                         cRange = "Z" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 7 THEN DO:
                         cRange = "AA" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 8 THEN DO:
                         cRange = "AB" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 9 THEN DO:
                         cRange = "AC" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 10 THEN DO:
                         cRange = "AD" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 11 THEN DO:
                         cRange = "AE" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                      WHEN 12 THEN DO:
                         cRange = "AF" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qtynow.
                      END.
                   END CASE.
                   ASSIGN qty_pur[(monthjs + 14)] = qty_pur[(monthjs + 14)] + qtynow.
                   ASSIGN qty_pur[14] = qty_pur[14] + qtynow.
                   ASSIGN monthjs = monthjs + 1.
                END.
                chWorkSheet:Range("T" + cColumn):VALUE = chWorkSheet:Range("U" + cColumn):VALUE + chWorkSheet:Range("V" + cColumn):VALUE + chWorkSheet:Range("W" + cColumn):VALUE + chWorkSheet:Range("X" + cColumn):VALUE + chWorkSheet:Range("Y" + cColumn):VALUE + chWorkSheet:Range("Z" + cColumn):VALUE + chWorkSheet:Range("AA" + cColumn):VALUE + chWorkSheet:Range("AB" + cColumn):VALUE + chWorkSheet:Range("AC" + cColumn):VALUE + chWorkSheet:Range("AD" + cColumn):VALUE + chWorkSheet:Range("AE" + cColumn):VALUE + chWorkSheet:Range("AF" + cColumn):VALUE.
                chWorkSheet:Range("T" + cColumn):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                ASSIGN qtynow = 0.
                FOR EACH ap_mstr USE-INDEX ap_open NO-LOCK WHERE ap_vend = vd_addr AND ap_type = "VO" AND ap_open = YES:
                    FIND FIRST vo_mstr NO-LOCK WHERE vo_ref = ap_ref AND vo_confirmed = YES AND (vo_due_date < sumday OR  vo_due_date = ?)NO-ERROR.
                    IF AVAILABLE vo_mstr THEN DO:
                       FOR EACH vod_det NO-LOCK USE-INDEX vod_ref WHERE vod_ref = ap_ref:
                           ASSIGN qtynow = qtynow + vod_base_amt.
                       END.
                    END.
                END.
                FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = vd_addr AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
                IF AVAILABLE qad_wkfl THEN DO:
                   ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
                END.
                ELSE DO:
                   CREATE qad_wkfl.
                   ASSIGN qad_key1 = "SUN-SOFT".
                   ASSIGN qad_key2 = vd_addr.
                   ASSIGN qad_intfld[1] = YEAR(TODAY).
                   ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
                END.

                ASSIGN monthjs = 1.
                DO WHILE monthjs <= 12:
                   FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = vd_addr AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
                   CASE monthjs: 
                      WHEN 1 THEN DO:
                         cRange = "AH" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 2 THEN DO:
                         cRange = "AI" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 3 THEN DO:
                         cRange = "AJ" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 4 THEN DO:
                         cRange = "AK" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 5 THEN DO:
                         cRange = "AL" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 6 THEN DO:
                         cRange = "AM" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 7 THEN DO:
                         cRange = "AN" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 8 THEN DO:
                         cRange = "AO" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 9 THEN DO:
                         cRange = "AP" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 10 THEN DO:
                         cRange = "AQ" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 11 THEN DO:
                         cRange = "AR" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                      WHEN 12 THEN DO:
                         cRange = "AS" + cColumn.
                         chWorkSheet:Range(cRange):Select().
                         chExcelApplication:selection:HorizontalAlignment = 1.
                         chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
                      END.
                   END CASE.
                   ASSIGN qty_pur[(monthjs + 27)] = qty_pur[(monthjs + 27)] + qad_decfld[monthjs].
                   ASSIGN qty_pur[27] = qty_pur[27] + qad_decfld[monthjs].
                   ASSIGN monthjs = monthjs + 1.
                END.
             END.
          END.
          FIND FIRST vd_mstr NO-LOCK WHERE vd_type = code_value AND vd_addr <> "Z1013" AND vd_addr <> "Z5306" AND vd_addr <> "Z5043" AND vd_addr <> "Z5262" AND vd_addr <> "Z5055" AND vd_addr <> "Z5118" NO-ERROR.
          IF AVAILABLE vd_mstr THEN DO:
             IF jsq1 = 1 THEN DO:
                cRange = "C" + string(Rowstart) + ":C" + string(Rowend). 
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 2.
                chExcelApplication:selection:Merge.
                chWorkSheet:Range(cRange):value =  code_value.
                ASSIGN  Rowstart = Rowend + 1.
                ASSIGN dispcs = 0.
             END.
          END.
       END.
       ASSIGN  Rowstart = Rowend + 1.
       ASSIGN  Rowend = Rowend + 1.
       cRange = "C" + string(Rowstart) + ":C" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Total Domestic".


       cColumn = string(Rowend).
       ASSIGN monthjs = 0.
       DO WHILE monthjs <= 38:
          CASE monthjs: 
             WHEN 0 THEN DO:
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 1 THEN DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 2 THEN DO:
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 3 THEN DO:
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 4 THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 5 THEN DO:
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 6 THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 7 THEN DO:
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 8 THEN DO:
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 9 THEN DO:
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 10 THEN DO:
                cRange = "Q" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 11 THEN DO:
                cRange = "R" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 12 THEN DO:
                cRange = "S" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 13 THEN DO:
                cRange = "T" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 14 THEN DO:
                cRange = "U" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 15 THEN DO:
                cRange = "V" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 16 THEN DO:
                cRange = "W" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 17 THEN DO:
                cRange = "X" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 18 THEN DO:
                cRange = "Y" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 19 THEN DO:
                cRange = "Z" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 20 THEN DO:
                cRange = "AA" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 21 THEN DO:
                cRange = "AB" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 22 THEN DO:
                cRange = "AC" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 23 THEN DO:
                cRange = "AD" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 24 THEN DO:
                cRange = "AE" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 25 THEN DO:
                cRange = "AF" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 27 THEN DO:
                cRange = "AH" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 28 THEN DO:
                cRange = "AI" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 29 THEN DO:
                cRange = "AJ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 30 THEN DO:
                cRange = "AK" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 31 THEN DO:
                cRange = "AL" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 32 THEN DO:
                cRange = "AM" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 33 THEN DO:
                cRange = "AN" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 34 THEN DO:
                cRange = "AO" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 35 THEN DO:
                cRange = "AP" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 36 THEN DO:
                cRange = "AQ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 37 THEN DO:
                cRange = "AR" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 38 THEN DO:
                cRange = "AS" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
          END CASE.
          ASSIGN monthjs = monthjs + 1.
       END.
       cRange = "C" + string(Rowend) + ":AS" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Interior:ColorIndex = 34.
       cRange = "B3:B" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Domestic".
       chExcelApplication:selection:Orientation = -90.
       ASSIGN  Rowstart = Rowend + 1.
       ASSIGN  Rowend = Rowend + 1.
       cRange = "D" + string(Rowstart) + ":D" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Potain SA".
       cRange = "F" + string(Rowstart) + ":F" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Z1013".
       cColumn = string(Rowend).
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z1013" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + prh_pur_cost * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "Q" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "R" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "S" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_pur[(monthjs + 1)] = qty_pur[(monthjs + 1)] + qtynow.
          ASSIGN qty_pur[1] = qty_pur[1] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("G" + cColumn):VALUE = chWorkSheet:Range("H" + cColumn):VALUE + chWorkSheet:Range("I" + cColumn):VALUE + chWorkSheet:Range("J" + cColumn):VALUE + chWorkSheet:Range("K" + cColumn):VALUE + chWorkSheet:Range("L" + cColumn):VALUE + chWorkSheet:Range("M" + cColumn):VALUE + chWorkSheet:Range("N" + cColumn):VALUE + chWorkSheet:Range("O" + cColumn):VALUE + chWorkSheet:Range("P" + cColumn):VALUE + chWorkSheet:Range("Q" + cColumn):VALUE + chWorkSheet:Range("R" + cColumn):VALUE + chWorkSheet:Range("S" + cColumn):VALUE.
       chWorkSheet:Range("G" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z1013" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + (prh_pur_cost - prh_pur_std) * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "U" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "V" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "W" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "X" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "Y" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "Z" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "AA" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "AB" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "AC" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "AD" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "AE" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "AF" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_pur[(monthjs + 14)] = qty_pur[(monthjs + 14)] + qtynow.
          ASSIGN qty_pur[14] = qty_pur[14] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("T" + cColumn):VALUE = chWorkSheet:Range("U" + cColumn):VALUE + chWorkSheet:Range("V" + cColumn):VALUE + chWorkSheet:Range("W" + cColumn):VALUE + chWorkSheet:Range("X" + cColumn):VALUE + chWorkSheet:Range("Y" + cColumn):VALUE + chWorkSheet:Range("Z" + cColumn):VALUE + chWorkSheet:Range("AA" + cColumn):VALUE + chWorkSheet:Range("AB" + cColumn):VALUE + chWorkSheet:Range("AC" + cColumn):VALUE + chWorkSheet:Range("AD" + cColumn):VALUE + chWorkSheet:Range("AE" + cColumn):VALUE + chWorkSheet:Range("AF" + cColumn):VALUE.
       chWorkSheet:Range("T" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN qtynow = 0.
       FOR EACH ap_mstr USE-INDEX ap_open NO-LOCK WHERE ap_vend = "Z1013" AND ap_type = "VO" AND ap_open = YES:
          FIND FIRST vo_mstr NO-LOCK WHERE vo_ref = ap_ref AND vo_confirmed = YES AND (vo_due_date < sumday OR  vo_due_date = ?)NO-ERROR.
          IF AVAILABLE vo_mstr THEN DO:
             FOR EACH vod_det NO-LOCK USE-INDEX vod_ref WHERE vod_ref = ap_ref:
                 ASSIGN qtynow = qtynow + vod_base_amt.
             END.
          END.
       END.
       FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z1013" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
       IF AVAILABLE qad_wkfl THEN DO:
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ELSE DO:
          CREATE qad_wkfl.
          ASSIGN qad_key1 = "SUN-SOFT".
          ASSIGN qad_key2 = "Z1013".
          ASSIGN qad_intfld[1] = YEAR(TODAY).
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z1013" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "AH" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 2 THEN DO:
                cRange = "AI" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 3 THEN DO:
                cRange = "AJ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 4 THEN DO:
                cRange = "AK" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 5 THEN DO:
                cRange = "AL" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 6 THEN DO:
                cRange = "AM" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 7 THEN DO:
                cRange = "AN" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 8 THEN DO:
                cRange = "AO" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 9 THEN DO:
                cRange = "AP" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 10 THEN DO:
                cRange = "AQ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 11 THEN DO:
                cRange = "AR" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 12 THEN DO:
                cRange = "AS" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
          END CASE.
          ASSIGN qty_pur[(monthjs + 27)] = qty_pur[(monthjs + 27)] + qad_decfld[monthjs].
          ASSIGN qty_pur[27] = qty_pur[27] + qad_decfld[monthjs].
          ASSIGN monthjs = monthjs + 1.
       END.
       ASSIGN  Rowend = Rowend + 1.
       cRange = "D" + string(Rowend) + ":D" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chExcelApplication:selection:HorizontalAlignment = 2.
       chWorkSheet:Range(cRange):value =  "Manitowoc  Crane .INC".
       cRange = "F" + string(Rowend) + ":F" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Z5306".
       cColumn = string(Rowend).
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z5306" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + prh_pur_cost * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "Q" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "R" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "S" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_pur[(monthjs + 1)] = qty_pur[(monthjs + 1)] + qtynow.
          ASSIGN qty_pur[1] = qty_pur[1] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("G" + cColumn):VALUE = chWorkSheet:Range("H" + cColumn):VALUE + chWorkSheet:Range("I" + cColumn):VALUE + chWorkSheet:Range("J" + cColumn):VALUE + chWorkSheet:Range("K" + cColumn):VALUE + chWorkSheet:Range("L" + cColumn):VALUE + chWorkSheet:Range("M" + cColumn):VALUE + chWorkSheet:Range("N" + cColumn):VALUE + chWorkSheet:Range("O" + cColumn):VALUE + chWorkSheet:Range("P" + cColumn):VALUE + chWorkSheet:Range("Q" + cColumn):VALUE + chWorkSheet:Range("R" + cColumn):VALUE + chWorkSheet:Range("S" + cColumn):VALUE.
       chWorkSheet:Range("G" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z5306" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + (prh_pur_cost - prh_pur_std) * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "U" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "V" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "W" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "X" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "Y" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "Z" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "AA" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "AB" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "AC" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "AD" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "AE" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "AF" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_pur[(monthjs + 14)] = qty_pur[(monthjs + 14)] + qtynow.
          ASSIGN qty_pur[14] = qty_pur[14] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("T" + cColumn):VALUE = chWorkSheet:Range("U" + cColumn):VALUE + chWorkSheet:Range("V" + cColumn):VALUE + chWorkSheet:Range("W" + cColumn):VALUE + chWorkSheet:Range("X" + cColumn):VALUE + chWorkSheet:Range("Y" + cColumn):VALUE + chWorkSheet:Range("Z" + cColumn):VALUE + chWorkSheet:Range("AA" + cColumn):VALUE + chWorkSheet:Range("AB" + cColumn):VALUE + chWorkSheet:Range("AC" + cColumn):VALUE + chWorkSheet:Range("AD" + cColumn):VALUE + chWorkSheet:Range("AE" + cColumn):VALUE + chWorkSheet:Range("AF" + cColumn):VALUE.
       chWorkSheet:Range("T" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
              ASSIGN qtynow = 0.
       FOR EACH ap_mstr USE-INDEX ap_open NO-LOCK WHERE ap_vend = "Z5063" AND ap_type = "VO" AND ap_open = YES:
          FIND FIRST vo_mstr NO-LOCK WHERE vo_ref = ap_ref AND vo_confirmed = YES AND (vo_due_date < sumday OR  vo_due_date = ?)NO-ERROR.
          IF AVAILABLE vo_mstr THEN DO:
             FOR EACH vod_det NO-LOCK USE-INDEX vod_ref WHERE vod_ref = ap_ref:
                 ASSIGN qtynow = qtynow + vod_base_amt.
             END.
          END.
       END.
       FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z5063" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
       IF AVAILABLE qad_wkfl THEN DO:
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ELSE DO:
          CREATE qad_wkfl.
          ASSIGN qad_key1 = "SUN-SOFT".
          ASSIGN qad_key2 = "Z5063".
          ASSIGN qad_intfld[1] = YEAR(TODAY).
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z5063" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "AH" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 2 THEN DO:
                cRange = "AI" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 3 THEN DO:
                cRange = "AJ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 4 THEN DO:
                cRange = "AK" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 5 THEN DO:
                cRange = "AL" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 6 THEN DO:
                cRange = "AM" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 7 THEN DO:
                cRange = "AN" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 8 THEN DO:
                cRange = "AO" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 9 THEN DO:
                cRange = "AP" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 10 THEN DO:
                cRange = "AQ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 11 THEN DO:
                cRange = "AR" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 12 THEN DO:
                cRange = "AS" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
          END CASE.
          ASSIGN qty_pur[(monthjs + 27)] = qty_pur[(monthjs + 27)] + qad_decfld[monthjs].
          ASSIGN qty_pur[27] = qty_pur[27] + qad_decfld[monthjs].
          ASSIGN monthjs = monthjs + 1.
       END.
       cRange = "B" + string(Rowstart) + ":C" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Import".
       ASSIGN  Rowend = Rowend + 1.
       cRange = "B" + string(Rowend) + ":C" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Total purchasing".
       cColumn = string(Rowend).
       ASSIGN monthjs = 0.
       DO WHILE monthjs <= 38:
          CASE monthjs: 
             WHEN 0 THEN DO:
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 1 THEN DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 2 THEN DO:
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 3 THEN DO:
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 4 THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 5 THEN DO:
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 6 THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 7 THEN DO:
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 8 THEN DO:
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 9 THEN DO:
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 10 THEN DO:
                cRange = "Q" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 11 THEN DO:
                cRange = "R" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 12 THEN DO:
                cRange = "S" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
                          WHEN 13 THEN DO:
                cRange = "T" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 14 THEN DO:
                cRange = "U" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 15 THEN DO:
                cRange = "V" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 16 THEN DO:
                cRange = "W" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 17 THEN DO:
                cRange = "X" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 18 THEN DO:
                cRange = "Y" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 19 THEN DO:
                cRange = "Z" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 20 THEN DO:
                cRange = "AA" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 21 THEN DO:
                cRange = "AB" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 22 THEN DO:
                cRange = "AC" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 23 THEN DO:
                cRange = "AD" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 24 THEN DO:
                cRange = "AE" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 25 THEN DO:
                cRange = "AF" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 27 THEN DO:
                cRange = "AH" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 28 THEN DO:
                cRange = "AI" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 29 THEN DO:
                cRange = "AJ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 30 THEN DO:
                cRange = "AK" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 31 THEN DO:
                cRange = "AL" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 32 THEN DO:
                cRange = "AM" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 33 THEN DO:
                cRange = "AN" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 34 THEN DO:
                cRange = "AO" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 35 THEN DO:
                cRange = "AP" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 36 THEN DO:
                cRange = "AQ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 37 THEN DO:
                cRange = "AR" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.
             WHEN 38 THEN DO:
                cRange = "AS" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_pur[(monthjs + 1)].
             END.

          END CASE.
          ASSIGN monthjs = monthjs + 1.
       END.
       cRange = "B" + string(Rowend) + ":AS" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Interior:ColorIndex = 34.
       cRange = "A3:A" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Purchasing".
       chExcelApplication:selection:Orientation = 90.
       ASSIGN  Rowstart = Rowend + 1.
       ASSIGN  Rowend = Rowend + 1.
       cRange = "D" + string(Rowstart) + ":D" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "张家港市联通公铁联运有限公司".
       cRange = "F" + string(Rowstart) + ":F" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Z5043".
       cColumn = string(Rowend).
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z5043" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + prh_pur_cost * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "Q" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "R" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "S" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 1)] = qty_trans[(monthjs + 1)] + qtynow.
          ASSIGN qty_trans[1] = qty_trans[1] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("G" + cColumn):VALUE = chWorkSheet:Range("H" + cColumn):VALUE + chWorkSheet:Range("I" + cColumn):VALUE + chWorkSheet:Range("J" + cColumn):VALUE + chWorkSheet:Range("K" + cColumn):VALUE + chWorkSheet:Range("L" + cColumn):VALUE + chWorkSheet:Range("M" + cColumn):VALUE + chWorkSheet:Range("N" + cColumn):VALUE + chWorkSheet:Range("O" + cColumn):VALUE + chWorkSheet:Range("P" + cColumn):VALUE + chWorkSheet:Range("Q" + cColumn):VALUE + chWorkSheet:Range("R" + cColumn):VALUE + chWorkSheet:Range("S" + cColumn):VALUE.
       chWorkSheet:Range("G" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z5043" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + (prh_pur_cost - prh_pur_std) * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "U" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "V" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "W" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "X" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "Y" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "Z" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "AA" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "AB" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "AC" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "AD" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "AE" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "AF" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 14)] = qty_trans[(monthjs + 14)] + qtynow.
          ASSIGN qty_trans[14] = qty_trans[14] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("T" + cColumn):VALUE = chWorkSheet:Range("U" + cColumn):VALUE + chWorkSheet:Range("V" + cColumn):VALUE + chWorkSheet:Range("W" + cColumn):VALUE + chWorkSheet:Range("X" + cColumn):VALUE + chWorkSheet:Range("Y" + cColumn):VALUE + chWorkSheet:Range("Z" + cColumn):VALUE + chWorkSheet:Range("AA" + cColumn):VALUE + chWorkSheet:Range("AB" + cColumn):VALUE + chWorkSheet:Range("AC" + cColumn):VALUE + chWorkSheet:Range("AD" + cColumn):VALUE + chWorkSheet:Range("AE" + cColumn):VALUE + chWorkSheet:Range("AF" + cColumn):VALUE.
       chWorkSheet:Range("T" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN qtynow = 0.
       FOR EACH ap_mstr USE-INDEX ap_open NO-LOCK WHERE ap_vend = "Z5043" AND ap_type = "VO" AND ap_open = YES:
          FIND FIRST vo_mstr NO-LOCK WHERE vo_ref = ap_ref AND vo_confirmed = YES AND (vo_due_date < sumday OR  vo_due_date = ?)NO-ERROR.
          IF AVAILABLE vo_mstr THEN DO:
             FOR EACH vod_det NO-LOCK USE-INDEX vod_ref WHERE vod_ref = ap_ref:
                 ASSIGN qtynow = qtynow + vod_base_amt.
             END.
          END.
       END.
       FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z5043" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
       IF AVAILABLE qad_wkfl THEN DO:
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ELSE DO:
          CREATE qad_wkfl.
          ASSIGN qad_key1 = "SUN-SOFT".
          ASSIGN qad_key2 = "Z5043".
          ASSIGN qad_intfld[1] = YEAR(TODAY).
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z5043" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "AH" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 2 THEN DO:
                cRange = "AI" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 3 THEN DO:
                cRange = "AJ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 4 THEN DO:
                cRange = "AK" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 5 THEN DO:
                cRange = "AL" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 6 THEN DO:
                cRange = "AM" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 7 THEN DO:
                cRange = "AN" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 8 THEN DO:
                cRange = "AO" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 9 THEN DO:
                cRange = "AP" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 10 THEN DO:
                cRange = "AQ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 11 THEN DO:
                cRange = "AR" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 12 THEN DO:
                cRange = "AS" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 27)] = qty_trans[(monthjs + 27)] + qad_decfld[monthjs].
          ASSIGN qty_trans[27] = qty_trans[27] + qad_decfld[monthjs].
          ASSIGN monthjs = monthjs + 1.
       END.
       ASSIGN  Rowend = Rowend + 1.
       cRange = "D" + string(Rowend) + ":D" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chExcelApplication:selection:HorizontalAlignment = 2.
       chWorkSheet:Range(cRange):value =  "抚州市永圣运输有限公司".
       cRange = "F" + string(Rowend) + ":F" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Z5262".
       cColumn = string(Rowend).
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z5262" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + prh_pur_cost * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "Q" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "R" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "S" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 1)] = qty_trans[(monthjs + 1)] + qtynow.
          ASSIGN qty_trans[1] = qty_trans[1] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("G" + cColumn):VALUE = chWorkSheet:Range("H" + cColumn):VALUE + chWorkSheet:Range("I" + cColumn):VALUE + chWorkSheet:Range("J" + cColumn):VALUE + chWorkSheet:Range("K" + cColumn):VALUE + chWorkSheet:Range("L" + cColumn):VALUE + chWorkSheet:Range("M" + cColumn):VALUE + chWorkSheet:Range("N" + cColumn):VALUE + chWorkSheet:Range("O" + cColumn):VALUE + chWorkSheet:Range("P" + cColumn):VALUE + chWorkSheet:Range("Q" + cColumn):VALUE + chWorkSheet:Range("R" + cColumn):VALUE + chWorkSheet:Range("S" + cColumn):VALUE.
       chWorkSheet:Range("G" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z5262" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + (prh_pur_cost - prh_pur_std) * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "U" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "V" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "W" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "X" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "Y" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "Z" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "AA" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "AB" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "AC" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "AD" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "AE" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "AF" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 14)] = qty_trans[(monthjs + 14)] + qtynow.
          ASSIGN qty_trans[14] = qty_trans[14] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("T" + cColumn):VALUE = chWorkSheet:Range("U" + cColumn):VALUE + chWorkSheet:Range("V" + cColumn):VALUE + chWorkSheet:Range("W" + cColumn):VALUE + chWorkSheet:Range("X" + cColumn):VALUE + chWorkSheet:Range("Y" + cColumn):VALUE + chWorkSheet:Range("Z" + cColumn):VALUE + chWorkSheet:Range("AA" + cColumn):VALUE + chWorkSheet:Range("AB" + cColumn):VALUE + chWorkSheet:Range("AC" + cColumn):VALUE + chWorkSheet:Range("AD" + cColumn):VALUE + chWorkSheet:Range("AE" + cColumn):VALUE + chWorkSheet:Range("AF" + cColumn):VALUE.
       chWorkSheet:Range("T" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN qtynow = 0.
       FOR EACH ap_mstr USE-INDEX ap_open NO-LOCK WHERE ap_vend = "Z5262" AND ap_type = "VO" AND ap_open = YES:
          FIND FIRST vo_mstr NO-LOCK WHERE vo_ref = ap_ref AND vo_confirmed = YES AND (vo_due_date < sumday OR  vo_due_date = ?)NO-ERROR.
          IF AVAILABLE vo_mstr THEN DO:
             FOR EACH vod_det NO-LOCK USE-INDEX vod_ref WHERE vod_ref = ap_ref:
                 ASSIGN qtynow = qtynow + vod_base_amt.
             END.
          END.
       END.
       FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z5262" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
       IF AVAILABLE qad_wkfl THEN DO:
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ELSE DO:
          CREATE qad_wkfl.
          ASSIGN qad_key1 = "SUN-SOFT".
          ASSIGN qad_key2 = "Z5262".
          ASSIGN qad_intfld[1] = YEAR(TODAY).
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z5262" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "AH" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 2 THEN DO:
                cRange = "AI" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 3 THEN DO:
                cRange = "AJ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 4 THEN DO:
                cRange = "AK" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 5 THEN DO:
                cRange = "AL" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 6 THEN DO:
                cRange = "AM" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 7 THEN DO:
                cRange = "AN" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 8 THEN DO:
                cRange = "AO" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 9 THEN DO:
                cRange = "AP" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 10 THEN DO:
                cRange = "AQ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 11 THEN DO:
                cRange = "AR" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 12 THEN DO:
                cRange = "AS" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 27)] = qty_trans[(monthjs + 27)] + qad_decfld[monthjs].
          ASSIGN qty_trans[27] = qty_trans[27] + qad_decfld[monthjs].
          ASSIGN monthjs = monthjs + 1.
       END.
       cRange = "B" + string(Rowstart) + ":C" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Domestic".
       ASSIGN  Rowstart = Rowend + 1.
       ASSIGN  Rowend = Rowend + 1.
       cRange = "D" + string(Rowstart) + ":D" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "江苏中外运公司张家港分公司".
       cRange = "F" + string(Rowstart) + ":F" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Z5055".
       cColumn = string(Rowend).
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z5055" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + prh_pur_cost * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "Q" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "R" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "S" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 1)] = qty_trans[(monthjs + 1)] + qtynow.
          ASSIGN qty_trans[1] = qty_trans[1] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("G" + cColumn):VALUE = chWorkSheet:Range("H" + cColumn):VALUE + chWorkSheet:Range("I" + cColumn):VALUE + chWorkSheet:Range("J" + cColumn):VALUE + chWorkSheet:Range("K" + cColumn):VALUE + chWorkSheet:Range("L" + cColumn):VALUE + chWorkSheet:Range("M" + cColumn):VALUE + chWorkSheet:Range("N" + cColumn):VALUE + chWorkSheet:Range("O" + cColumn):VALUE + chWorkSheet:Range("P" + cColumn):VALUE + chWorkSheet:Range("Q" + cColumn):VALUE + chWorkSheet:Range("R" + cColumn):VALUE + chWorkSheet:Range("S" + cColumn):VALUE.
       chWorkSheet:Range("G" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z5055" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + (prh_pur_cost - prh_pur_std) * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "U" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "V" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "W" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "X" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "Y" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "Z" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "AA" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "AB" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "AC" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "AD" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "AE" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "AF" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 14)] = qty_trans[(monthjs + 14)] + qtynow.
          ASSIGN qty_trans[14] = qty_trans[14] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("T" + cColumn):VALUE = chWorkSheet:Range("U" + cColumn):VALUE + chWorkSheet:Range("V" + cColumn):VALUE + chWorkSheet:Range("W" + cColumn):VALUE + chWorkSheet:Range("X" + cColumn):VALUE + chWorkSheet:Range("Y" + cColumn):VALUE + chWorkSheet:Range("Z" + cColumn):VALUE + chWorkSheet:Range("AA" + cColumn):VALUE + chWorkSheet:Range("AB" + cColumn):VALUE + chWorkSheet:Range("AC" + cColumn):VALUE + chWorkSheet:Range("AD" + cColumn):VALUE + chWorkSheet:Range("AE" + cColumn):VALUE + chWorkSheet:Range("AF" + cColumn):VALUE.
       chWorkSheet:Range("T" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN qtynow = 0.
       FOR EACH ap_mstr USE-INDEX ap_open NO-LOCK WHERE ap_vend = "Z5055" AND ap_type = "VO" AND ap_open = YES:
          FIND FIRST vo_mstr NO-LOCK WHERE vo_ref = ap_ref AND vo_confirmed = YES AND (vo_due_date < sumday OR  vo_due_date = ?)NO-ERROR.
          IF AVAILABLE vo_mstr THEN DO:
             FOR EACH vod_det NO-LOCK USE-INDEX vod_ref WHERE vod_ref = ap_ref:
                 ASSIGN qtynow = qtynow + vod_base_amt.
             END.
          END.
       END.
       FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z5055" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
       IF AVAILABLE qad_wkfl THEN DO:
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ELSE DO:
          CREATE qad_wkfl.
          ASSIGN qad_key1 = "SUN-SOFT".
          ASSIGN qad_key2 = "Z5055".
          ASSIGN qad_intfld[1] = YEAR(TODAY).
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z5055" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "AH" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 2 THEN DO:
                cRange = "AI" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 3 THEN DO:
                cRange = "AJ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 4 THEN DO:
                cRange = "AK" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 5 THEN DO:
                cRange = "AL" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 6 THEN DO:
                cRange = "AM" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 7 THEN DO:
                cRange = "AN" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 8 THEN DO:
                cRange = "AO" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 9 THEN DO:
                cRange = "AP" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 10 THEN DO:
                cRange = "AQ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 11 THEN DO:
                cRange = "AR" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 12 THEN DO:
                cRange = "AS" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 27)] = qty_trans[(monthjs + 27)] + qad_decfld[monthjs].
          ASSIGN qty_trans[27] = qty_trans[27] + qad_decfld[monthjs].
          ASSIGN monthjs = monthjs + 1.
       END.
       ASSIGN  Rowend = Rowend + 1.
       cRange = "D" + string(Rowend) + ":D" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chExcelApplication:selection:HorizontalAlignment = 2.
       chWorkSheet:Range(cRange):value =  "上海三事运输代理有限公司".
       cRange = "F" + string(Rowend) + ":F" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Z5118".
       cColumn = string(Rowend).
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z5118" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + prh_pur_cost * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "Q" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "R" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "S" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 1)] = qty_trans[(monthjs + 1)] + qtynow.
          ASSIGN qty_trans[1] = qty_trans[1] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("G" + cColumn):VALUE = chWorkSheet:Range("H" + cColumn):VALUE + chWorkSheet:Range("I" + cColumn):VALUE + chWorkSheet:Range("J" + cColumn):VALUE + chWorkSheet:Range("K" + cColumn):VALUE + chWorkSheet:Range("L" + cColumn):VALUE + chWorkSheet:Range("M" + cColumn):VALUE + chWorkSheet:Range("N" + cColumn):VALUE + chWorkSheet:Range("O" + cColumn):VALUE + chWorkSheet:Range("P" + cColumn):VALUE + chWorkSheet:Range("Q" + cColumn):VALUE + chWorkSheet:Range("R" + cColumn):VALUE + chWorkSheet:Range("S" + cColumn):VALUE.
       chWorkSheet:Range("G" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          ASSIGN qtynow = 0.
          FOR EACH prh_hist USE-INDEX prh_vend NO-LOCK WHERE prh_vend = "Z5118" AND MONTH(prh_rcp_date) = monthjs AND YEAR(prh_rcp_date) = YEAR(TODAY):
              ASSIGN qtynow = qtynow + (prh_pur_cost - prh_pur_std) * prh_rcvd * prh_um_conv * prh_ex_rate.
          END.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "U" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 2 THEN DO:
                cRange = "V" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 3 THEN DO:
                cRange = "W" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 4 THEN DO:
                cRange = "X" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 5 THEN DO:
                cRange = "Y" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 6 THEN DO:
                cRange = "Z" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 7 THEN DO:
                cRange = "AA" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 8 THEN DO:
                cRange = "AB" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 9 THEN DO:
                cRange = "AC" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 10 THEN DO:
                cRange = "AD" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 11 THEN DO:
                cRange = "AE" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
             WHEN 12 THEN DO:
                cRange = "AF" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qtynow.
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 14)] = qty_trans[(monthjs + 14)] + qtynow.
          ASSIGN qty_trans[14] = qty_trans[14] + qtynow.
          ASSIGN monthjs = monthjs + 1.
       END.
       chWorkSheet:Range("T" + cColumn):VALUE = chWorkSheet:Range("U" + cColumn):VALUE + chWorkSheet:Range("V" + cColumn):VALUE + chWorkSheet:Range("W" + cColumn):VALUE + chWorkSheet:Range("X" + cColumn):VALUE + chWorkSheet:Range("Y" + cColumn):VALUE + chWorkSheet:Range("Z" + cColumn):VALUE + chWorkSheet:Range("AA" + cColumn):VALUE + chWorkSheet:Range("AB" + cColumn):VALUE + chWorkSheet:Range("AC" + cColumn):VALUE + chWorkSheet:Range("AD" + cColumn):VALUE + chWorkSheet:Range("AE" + cColumn):VALUE + chWorkSheet:Range("AF" + cColumn):VALUE.
       chWorkSheet:Range("T" + cColumn):Select().
       chExcelApplication:selection:HorizontalAlignment = 1.
       ASSIGN qtynow = 0.
       FOR EACH ap_mstr USE-INDEX ap_open NO-LOCK WHERE ap_vend = "Z5118" AND ap_type = "VO" AND ap_open = YES:
          FIND FIRST vo_mstr NO-LOCK WHERE vo_ref = ap_ref AND vo_confirmed = YES AND (vo_due_date < sumday OR  vo_due_date = ?)NO-ERROR.
          IF AVAILABLE vo_mstr THEN DO:
             FOR EACH vod_det NO-LOCK USE-INDEX vod_ref WHERE vod_ref = ap_ref:
                 ASSIGN qtynow = qtynow + vod_base_amt.
             END.
          END.
       END.
       FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z5118" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
       IF AVAILABLE qad_wkfl THEN DO:
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ELSE DO:
          CREATE qad_wkfl.
          ASSIGN qad_key1 = "SUN-SOFT".
          ASSIGN qad_key2 = "Z5118".
          ASSIGN qad_intfld[1] = YEAR(TODAY).
          ASSIGN qad_decfld[MONTH(TODAY)] = qtynow.
       END.
       ASSIGN monthjs = 1.
       DO WHILE monthjs <= 12:
          FIND FIRST qad_wkfl USE-INDEX qad_index1 WHERE qad_key1 = "SUN-SOFT" AND qad_key2 = "Z5118" AND qad_intfld[1] = YEAR(TODAY) NO-ERROR.
          CASE monthjs: 
             WHEN 1 THEN DO:
                cRange = "AH" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 2 THEN DO:
                cRange = "AI" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 3 THEN DO:
                cRange = "AJ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 4 THEN DO:
                cRange = "AK" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 5 THEN DO:
                cRange = "AL" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 6 THEN DO:
                cRange = "AM" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 7 THEN DO:
                cRange = "AN" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 8 THEN DO:
                cRange = "AO" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 9 THEN DO:
                cRange = "AP" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 10 THEN DO:
                cRange = "AQ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 11 THEN DO:
                cRange = "AR" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
             WHEN 12 THEN DO:
                cRange = "AS" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qad_decfld[monthjs].
             END.
          END CASE.
          ASSIGN qty_trans[(monthjs + 27)] = qty_trans[(monthjs + 27)] + qad_decfld[monthjs].
          ASSIGN qty_trans[27] = qty_trans[27] + qad_decfld[monthjs].
          ASSIGN monthjs = monthjs + 1.
       END.
       cRange = "B" + string(Rowstart) + ":C" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Import/Export Handling".

       
       
       
       
       
       
              ASSIGN  Rowend = Rowend + 1.
       cRange = "B" + string(Rowend) + ":C" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Total transport".
       cColumn = string(Rowend).
       ASSIGN monthjs = 0.
       DO WHILE monthjs <= 38:
          CASE monthjs: 
             WHEN 0 THEN DO:
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 1 THEN DO:
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 2 THEN DO:
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 3 THEN DO:
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 4 THEN DO:
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 5 THEN DO:
                cRange = "L" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 6 THEN DO:
                cRange = "M" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 7 THEN DO:
                cRange = "N" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 8 THEN DO:
                cRange = "O" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 9 THEN DO:
                cRange = "P" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 10 THEN DO:
                cRange = "Q" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 11 THEN DO:
                cRange = "R" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 12 THEN DO:
                cRange = "S" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 13 THEN DO:
                cRange = "T" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 14 THEN DO:
                cRange = "U" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 15 THEN DO:
                cRange = "V" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 16 THEN DO:
                cRange = "W" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 17 THEN DO:
                cRange = "X" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 18 THEN DO:
                cRange = "Y" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 19 THEN DO:
                cRange = "Z" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 20 THEN DO:
                cRange = "AA" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 21 THEN DO:
                cRange = "AB" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 22 THEN DO:
                cRange = "AC" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 23 THEN DO:
                cRange = "AD" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 24 THEN DO:
                cRange = "AE" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 25 THEN DO:
                cRange = "AF" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 27 THEN DO:
                cRange = "AH" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 28 THEN DO:
                cRange = "AI" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 29 THEN DO:
                cRange = "AJ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 30 THEN DO:
                cRange = "AK" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 31 THEN DO:
                cRange = "AL" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 32 THEN DO:
                cRange = "AM" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 33 THEN DO:
                cRange = "AN" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 34 THEN DO:
                cRange = "AO" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 35 THEN DO:
                cRange = "AP" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 36 THEN DO:
                cRange = "AQ" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 37 THEN DO:
                cRange = "AR" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.
             WHEN 38 THEN DO:
                cRange = "AS" + cColumn.
                chWorkSheet:Range(cRange):Select().
                chExcelApplication:selection:HorizontalAlignment = 1.
                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)].
             END.

          END CASE.
          ASSIGN monthjs = monthjs + 1.
       END.
       cRange = "B" + string(Rowend) + ":AS" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Interior:ColorIndex = 34.
       ASSIGN  Rowstart = Rowend - 4.
       cRange = "A" + string(Rowstart) + ":A" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Transport".
       chExcelApplication:selection:Orientation = 90.
       ASSIGN  Rowend = Rowend + 1.
       cRange = "A" + string(Rowend) + ":C" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:Merge.
       chWorkSheet:Range(cRange):value =  "Grand Total".
       cColumn = string(Rowend).
       ASSIGN monthjs = 0.
       DO WHILE monthjs <= 38:
          CASE monthjs: 
             WHEN 0 THEN DO:
                cRange = "G" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 1 THEN DO:
                cRange = "H" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 2 THEN DO:
                cRange = "I" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 3 THEN DO:
                cRange = "J" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 4 THEN DO:
                cRange = "K" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 5 THEN DO:
                cRange = "L" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 6 THEN DO:
                cRange = "M" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 7 THEN DO:
                cRange = "N" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 8 THEN DO:
                cRange = "O" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 9 THEN DO:
                cRange = "P" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 10 THEN DO:
                cRange = "Q" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 11 THEN DO:
                cRange = "R" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 12 THEN DO:
                cRange = "S" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 13 THEN DO:
                cRange = "T" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 14 THEN DO:
                cRange = "U" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 15 THEN DO:
                cRange = "V" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 16 THEN DO:
                cRange = "W" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 17 THEN DO:
                cRange = "X" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 18 THEN DO:
                cRange = "Y" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 19 THEN DO:
                cRange = "Z" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 20 THEN DO:
                cRange = "AA" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 21 THEN DO:
                cRange = "AB" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 22 THEN DO:
                cRange = "AC" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 23 THEN DO:
                cRange = "AD" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 24 THEN DO:
                cRange = "AE" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 25 THEN DO:
                cRange = "AF" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
                          WHEN 27 THEN DO:
                cRange = "AH" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 28 THEN DO:
                cRange = "AI" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 29 THEN DO:
                cRange = "AJ" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 30 THEN DO:
                cRange = "AK" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 31 THEN DO:
                cRange = "AL" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 32 THEN DO:
                cRange = "AM" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 33 THEN DO:
                cRange = "AN" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 34 THEN DO:
                cRange = "AO" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 35 THEN DO:
                cRange = "AP" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 36 THEN DO:
                cRange = "AQ" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 37 THEN DO:
                cRange = "AR" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
             WHEN 38 THEN DO:
                cRange = "AS" + cColumn.

                chWorkSheet:Range(cRange):value =  qty_trans[(monthjs + 1)] + qty_pur[(monthjs + 1)].
             END.
          END CASE.
          ASSIGN monthjs = monthjs + 1.
       END.
       cRange = "A" + string(Rowend) + ":AS" + string(Rowend).
       chWorkSheet:Range(cRange):Select().
       chExcelApplication:selection:Interior:ColorIndex = 34.
       chWorkSheet:Range("A1:AS" + string(Rowend)):Select().
       chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
       chWorkSheet:Range("F1:F" + string(Rowend)):Select().
       chExcelApplication:selection:Borders(10):Weight = 3.
       chWorkSheet:Range("S1:S" + string(Rowend)):Select().
       chExcelApplication:selection:Borders(10):Weight = 3.
       chWorkSheet:Range("AF1:AF" + string(Rowend)):Select().
       chExcelApplication:selection:Borders(10):Weight = 3.
       chWorkSheet:Range("AS1:AS" + string(Rowend)):Select().
       chExcelApplication:selection:Borders(10):Weight = 3.
       chWorkSheet:Range("G3:AS" + string(Rowend)):Select().
       chExcelApplication:selection:NumberFormat = "0.00_ ".
       chExcelApplication:selection:HorizontalAlignment = 1.
       chWorkSheet:Range("A1:C2"):Select().

       RELEASE OBJECT chWorksheet.
       RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.
    END.
END.

