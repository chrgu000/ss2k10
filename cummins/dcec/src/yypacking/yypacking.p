{mfdtitle.i "d+ "}
DEFINE VAR part1 LIKE pt_part.
DEFINE VAR part2 LIKE pt_part.
DEFINE VAR date1 LIKE dsd_per_date.
DEFINE VAR date2 LIKE dsd_per_date.
DEFINE VAR shipfrmsite1 LIKE pt_site.
DEFINE VAR shipfrmsite2 LIKE pt_site.
DEFINE VAR shiptosite1 LIKE pt_site.
DEFINE VAR shiptosite2 LIKE pt_site.
DEFINE VAR v_loc_qty LIKE in_qty_oh.
DEFINE VAR v_log AS LOG INITIAL YES.
DEFINE VAR v_qty LIKE schd_discr_qty.
DEFINE VAR v_3pl LIKE pod__chr01.

DEFINE VAR i AS INTEGER.

DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.


FORM
    part1        LABEL "零件号" COLON 20 part2        LABEL "To" COLON 55
    date1        LABEL "需求日期" COLON 20  date2     LABEL "To" COLON 55
    shipfrmsite1 LABEL "发运地" COLON 20 shipfrmsite2 LABEL "To" COLON 55
    shiptosite1  LABEL "发送到" COLON 20 shiptosite2  LABEL "To" COLON 55
    v_log LABEL "只显示需要包装数量"   COLON 40

    WITH FRAME  a SIDE-LABELS WIDTH 80 ATTR-SPACE NO-BOX THREE-D.

REPEAT:

    IF part1 = hi_char THEN part1 = "".
    IF part2 = "" THEN part2 = hi_char.
    IF date1 = hi_date THEN date1 = low_date.
    IF date2 = low_date THEN date2 = hi_date.
    IF shipfrmsite1 = hi_char THEN shipfrmsite1 = "".
    IF shipfrmsite2 = "" THEN shipfrmsite2 = hi_char.
    IF shiptosite1 = hi_char  THEN shiptosite1 = "".
    IF shiptosite2 = "" THEN shiptosite2 = hi_char.
    UPDATE part1 part2 date1 date2 shipfrmsite1 shipfrmsite2 shiptosite1 shiptosite2  v_log WITH FRAME a.
    /*{mfselprt.i "printer" 132}*/
    IF part1 = hi_char THEN part1 = "".
    IF part2 = "" THEN part2 = hi_char.
    IF date1 = hi_date THEN date1 = low_date.
    IF date2 = low_date THEN date2 = hi_date.
    IF shipfrmsite1 = hi_char THEN shipfrmsite1 = "".
    IF shipfrmsite2 = "" THEN shipfrmsite2 = hi_char.
    IF shiptosite1 = hi_char  THEN shiptosite1 = "".
    IF shiptosite2 = "" THEN shiptosite2 = hi_char.

    IF SEARCH("\\qadtemp\appeb2\template\packingnotes.xlt") = ? THEN DO:
      MESSAGE "报表模板不存在!" VIEW-AS ALERT-BOX ERROR.
      UNDO,RETRY.
    END.
    i = 5.

    CREATE "Excel.Application" chExcelApplication.
    chExcelWorkbook = chExcelApplication:Workbooks:ADD("\\qadtemp\appeb2\template\packingnotes.xlt").

   MESSAGE "开始计算，并写入EXCEL表格中" VIEW-AS ALERT-BOX.
  IF v_log = YES THEN DO:
   FOR EACH dsd_det WHERE dsd_domain = global_domain  AND dsd_part >=part1 AND dsd_part <= part2 AND dsd_per_date >= date1 AND dsd_per_date <= date2
    AND dsd_site >= shiptosite1 AND dsd_site <=shiptosite2 AND dsd_shipsite >=shipfrmsite1 AND dsd_shipsite <=shipfrmsite2
    AND (dsd_qty_con - (dsd_transit + dsd_qty_rcvd) > 0)  BY dsd_part BY dsd_site.

    v_loc_qty = 0.

    FOR EACH IN_mstr WHERE in_domain = global_domain AND IN_part = dsd_par AND IN_site = dsd_shipsite AND (in_qty_oh <> 0 OR in_qty_nonet <> 0) NO-LOCK.
         v_loc_qty = v_loc_qty +  IN_qty_oh + IN_qty_nonet.
    END.

   IF v_loc_qty <> 0  THEN DO:


    i = i + 1.

    chExcelWorkbook:worksheets(1):cells(i,1):VALUE = i - 5.
    chExcelWorkbook:worksheets(1):cells(i,2):VALUE = STRING(TODAY) + "-1".
    chExcelWorkbook:worksheets(1):cells(i,3):VALUE = dsd_part.
    FIND FIRST pt_mstr WHERE pt_domain = global_domain AND pt_part = dsd_part NO-LOCK NO-ERROR.
    IF AVAIL pt_mstr THEN
    chExcelWorkbook:worksheets(1):cells(i,4):VALUE = pt_desc2.
    chExcelWorkbook:worksheets(1):cells(i,5):VALUE = dsd_shipsite.



    chExcelWorkbook:worksheets(1):cells(i,6):VALUE = v_loc_qty.

    chExcelWorkbook:worksheets(1):cells(i,7):VALUE = dsd_site.
    chExcelWorkbook:worksheets(1):cells(i,8):VALUE = dsd_nbr.
    chExcelWorkbook:worksheets(1):cells(i,9):VALUE = dsd_qty_con.

    FIND FIRST ptp_det WHERE ptp_domain = global_domain  AND ptp_part = dsd_part AND ptp_site = dsd_site NO-LOCK NO-ERROR.
    IF AVAIL ptp_det THEN chExcelWorkbook:worksheets(1):cells(i,10):VALUE = ptp_ord_mult.
    ELSE chExcelWorkbook:worksheets(1):cells(i,10):VALUE = 0.

    chExcelWorkbook:worksheets(1):cells(i,11):VALUE = dsd_qty_con - (dsd_transit + dsd_qty_rcvd).
    /*chExcelWorkbook:worksheets(1):cells(i,12):VALUE =  - dsd_qty_rcvd.*/

    v_qty = 0.
    v_3pl = "".
    FOR EACH pod_det WHERE pod_domain = global_domain  AND  pod_site = dsd_shipsite AND pod_part = dsd_part NO-LOCK,
        EACH schd_det WHERE schd_domain = global_domain  AND schd_type = 4 AND schd_rlse_id = pod_curr_rlse_id[1] AND schd_nbr = pod_nbr AND schd_line = pod_line
        AND schd_discr_qty > 0 AND schd_date >= TODAY AND schd_date <= TODAY NO-LOCK:
        v_qty = v_qty + schd_discr_qty.
        v_3pl = pod__chr01.

    END.
    chExcelWorkbook:worksheets(1):cells(i,13):VALUE = v_qty.
    chExcelWorkbook:worksheets(1):cells(i,14):VALUE = v_3pl.
   END. /*end if */

  END.

 END.

 IF v_log = NO THEN DO:
  FOR EACH dsd_det WHERE dsd_domain = global_domain  AND dsd_part >=part1 AND dsd_part <= part2 AND dsd_per_date >= date1 AND dsd_per_date <= date2
   AND dsd_site >= shiptosite1 AND dsd_site <=shiptosite2 AND dsd_shipsite >=shipfrmsite1 AND dsd_shipsite <=shipfrmsite2  BY dsd_part BY dsd_site.

   i = i + 1.

   chExcelWorkbook:worksheets(1):cells(i,1):VALUE = i - 5.
   chExcelWorkbook:worksheets(1):cells(i,2):VALUE = STRING(TODAY) + "-1".
   chExcelWorkbook:worksheets(1):cells(i,3):VALUE = dsd_part.
   FIND FIRST pt_mstr WHERE pt_part = dsd_part NO-LOCK NO-ERROR.
   IF AVAIL pt_mstr THEN
       chExcelWorkbook:worksheets(1):cells(i,4):VALUE = pt_desc2.
   chExcelWorkbook:worksheets(1):cells(i,5):VALUE = dsd_shipsite.

   v_loc_qty = 0.

   FOR EACH IN_mstr WHERE in_domain = global_domain  AND IN_part = dsd_par AND IN_site = dsd_shipsite AND (in_qty_oh <> 0 OR in_qty_nonet <> 0) NO-LOCK.
        v_loc_qty = v_loc_qty +  IN_qty_oh + IN_qty_nonet.
   END.

   chExcelWorkbook:worksheets(1):cells(i,6):VALUE = v_loc_qty.

   chExcelWorkbook:worksheets(1):cells(i,7):VALUE = dsd_site.
   chExcelWorkbook:worksheets(1):cells(i,8):VALUE = dsd_nbr.
   chExcelWorkbook:worksheets(1):cells(i,9):VALUE = dsd_qty_con.

   FIND FIRST ptp_det WHERE ptp_domain = global_domain  AND  ptp_part = dsd_part AND ptp_site = dsd_site NO-LOCK NO-ERROR.
   IF AVAIL ptp_det THEN chExcelWorkbook:worksheets(1):cells(i,10):VALUE = ptp_ord_mult.
   ELSE chExcelWorkbook:worksheets(1):cells(i,10):VALUE = 0.

    chExcelWorkbook:worksheets(1):cells(i,11):VALUE = dsd_qty_con - (dsd_transit + dsd_qty_rcvd).
    /*chExcelWorkbook:worksheets(1):cells(i,12):VALUE =  - dsd_qty_rcvd.*/


    v_qty = 0.
    v_3pl = "".
    FOR EACH pod_det WHERE pod_domain = global_domain  AND  pod_site = dsd_shipsite AND pod_part = dsd_part NO-LOCK,
        EACH schd_det WHERE schd_domain = global_domain  AND  schd_type = 4 AND schd_rlse_id = pod_curr_rlse_id[1] AND schd_nbr = pod_nbr AND schd_line = pod_line
        AND schd_discr_qty > 0 AND schd_date >= TODAY AND schd_date <= TODAY NO-LOCK:
        v_qty = v_qty + schd_discr_qty.
        v_3pl = pod__chr01.
    END.
    chExcelWorkbook:worksheets(1):cells(i,13):VALUE = v_qty.
    chExcelWorkbook:worksheets(1):cells(i,14):VALUE = v_3pl.

 END.

END.



  HIDE MESSAGE NO-PAUSE.
  chExcelApplication:Visible = TRUE.
  /*chExcelApplication:OPEN.*/

    /* release com - handles */
  RELEASE OBJECT chExcelWorkbook.
    /*release object chexcelworkbooktemp .*/
  RELEASE OBJECT chExcelApplication.
/*
{mfreset.i}
{mfgrptrm.i} /*Report-to-Window*/
*/
END.

