/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/16/12  ECO: *SS-20120817.1*   */


{mfdtitle.i "120817.1"}
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



 /* *SS-20120817.1*       IF SEARCH("\\qadtemp\appeb2\template\packingnotes.xlt") = ? THEN DO:  */ 
    IF SEARCH("D:\packingnotes.xlt") = ? THEN DO: 

      MESSAGE "报表模板不存在!" VIEW-AS ALERT-BOX ERROR.
      UNDO,RETRY.
    END.

    i = 5.

    CREATE "Excel.Application" chExcelApplication.
 /* *SS-20120817.1*       chExcelWorkbook = chExcelApplication:Workbooks:ADD("\\qadtemp\appeb2\template\packingnotes.xlt"). */ 
    chExcelWorkbook = chExcelApplication:Workbooks:ADD("D:\packingnotes.xlt").


   MESSAGE "开始计算，并写入EXCEL表格中" VIEW-AS ALERT-BOX. 
  IF v_log = YES THEN DO:
   FOR EACH dsd_det WHERE  /* *SS-20120817.1*   */ dsd_det.dsd_domain = global_domain and dsd_part >=part1 AND dsd_part <= part2 AND dsd_per_date >= date1 AND dsd_per_date <= date2 
    AND dsd_site >= shiptosite1 AND dsd_site <=shiptosite2 AND dsd_shipsite >=shipfrmsite1 AND dsd_shipsite <=shipfrmsite2 
    AND dsd_transit <> 0  BY dsd_part.
     
    i = i + 1.

    chExcelWorkbook:worksheets(1):cells(i,1):VALUE = i - 5.
    chExcelWorkbook:worksheets(1):cells(i,2):VALUE = STRING(TODAY) + "-1".
    chExcelWorkbook:worksheets(1):cells(i,3):VALUE = dsd_part.
    FIND FIRST pt_mstr WHERE /* *SS-20120817.1*   */ pt_mstr.pt_domain = global_domain and pt_part = dsd_part NO-LOCK NO-ERROR.
    IF AVAIL pt_mstr THEN
        chExcelWorkbook:worksheets(1):cells(i,4):VALUE = pt_desc2.
    chExcelWorkbook:worksheets(1):cells(i,5):VALUE = dsd_shipsite.

    v_loc_qty = 0.

    FOR EACH IN_mstr WHERE /* *SS-20120817.1*   */ IN_mstr.in_domain = global_domain and IN_part = dsd_par AND IN_site = dsd_shipsite AND (in_qty_oh <> 0 OR in_qty_nonet <> 0) NO-LOCK.
         v_loc_qty = v_loc_qty +  IN_qty_oh + IN_qty_nonet.
    END.
    
    chExcelWorkbook:worksheets(1):cells(i,6):VALUE = v_loc_qty.

    chExcelWorkbook:worksheets(1):cells(i,7):VALUE = dsd_site.
    chExcelWorkbook:worksheets(1):cells(i,8):VALUE = dsd_nbr.
    chExcelWorkbook:worksheets(1):cells(i,9):VALUE = dsd_qty_con.

    FIND FIRST ptp_det WHERE /* *SS-20120817.1*   */ ptp_det.ptp_domain = global_domain and ptp_part = dsd_part AND ptp_site = dsd_site NO-LOCK NO-ERROR.
    IF AVAIL ptp_det THEN chExcelWorkbook:worksheets(1):cells(i,10):VALUE = ptp_ord_mult.
    ELSE chExcelWorkbook:worksheets(1):cells(i,10):VALUE = 0.

    chExcelWorkbook:worksheets(1):cells(i,11):VALUE = dsd_transit.
    chExcelWorkbook:worksheets(1):cells(i,12):VALUE = dsd_qty_con - dsd_qty_rcvd.




    /*
    FIND LAST pod_det WHERE pod_site = dsd_shipsite AND pod_part = dsd_part AND (pod_due_date= ? OR pod_due_date > TODAY) AND pod_status <> "C"  NO-LOCK NO-ERROR.
    IF AVAILABLE pod_det THEN DO:
        chExcelWorkbook:worksheets(1):cells(i,1):VALUE = dsd_nbr.
        chExcelWorkbook:worksheets(1):cells(i,2):VALUE = dsd_req.
        chExcelWorkbook:worksheets(1):cells(i,3):VALUE = dsd_site.
        chExcelWorkbook:worksheets(1):cells(i,4):VALUE = dsd_shipsite.
        chExcelWorkbook:worksheets(1):cells(i,5):VALUE = dsd_per_date.
        chExcelWorkbook:worksheets(1):cells(i,6):VALUE = dsd_shipdate.
        chExcelWorkbook:worksheets(1):cells(i,7):VALUE = dsd_due_date.
        chExcelWorkbook:worksheets(1):cells(i,8):VALUE = dsd_part.
        chExcelWorkbook:worksheets(1):cells(i,9):VALUE = dsd_qty_con.
        chExcelWorkbook:worksheets(1):cells(i,10):VALUE = dsd_qty_ship.
        chExcelWorkbook:worksheets(1):cells(i,11):VALUE = dsd_qty_rcvd.
        chExcelWorkbook:worksheets(1):cells(i,12):VALUE = dsd_transit.
        chExcelWorkbook:worksheets(1):cells(i,13):VALUE = dsd_qty_con - dsd_qty_rcvd.
        chExcelWorkbook:worksheets(1):cells(i,14):VALUE = pod_nbr.
        chExcelWorkbook:worksheets(1):cells(i,15):VALUE = pod_line.
        /*chExcelWorkbook:worksheets(1):cells(i,16):VALUE = dsd_nbr.
        chExcelWorkbook:worksheets(1):cells(i,17):VALUE = dsd_nbr.*/
    END.
    ELSE DO:
        chExcelWorkbook:worksheets(1):cells(i,1):VALUE = dsd_nbr.
        chExcelWorkbook:worksheets(1):cells(i,2):VALUE = dsd_req.
        chExcelWorkbook:worksheets(1):cells(i,3):VALUE = dsd_site.
        chExcelWorkbook:worksheets(1):cells(i,4):VALUE = dsd_shipsite.
        chExcelWorkbook:worksheets(1):cells(i,5):VALUE = dsd_per_date.
        chExcelWorkbook:worksheets(1):cells(i,6):VALUE = dsd_shipdate.
        chExcelWorkbook:worksheets(1):cells(i,7):VALUE = dsd_due_date.
        chExcelWorkbook:worksheets(1):cells(i,8):VALUE = dsd_part.
        chExcelWorkbook:worksheets(1):cells(i,9):VALUE = dsd_qty_con.
        chExcelWorkbook:worksheets(1):cells(i,10):VALUE = dsd_qty_ship.
        chExcelWorkbook:worksheets(1):cells(i,11):VALUE = dsd_qty_rcvd.
        chExcelWorkbook:worksheets(1):cells(i,12):VALUE = dsd_transit.
        chExcelWorkbook:worksheets(1):cells(i,13):VALUE = dsd_qty_con - dsd_qty_rcvd.
        chExcelWorkbook:worksheets(1):cells(i,14):VALUE = "".
        chExcelWorkbook:worksheets(1):cells(i,15):VALUE = "".
        /*chExcelWorkbook:worksheets(1):cells(i,16):VALUE = dsd_nbr.
        chExcelWorkbook:worksheets(1):cells(i,17):VALUE = dsd_nbr.*/

    END.
   */

  END.

 END.

 IF v_log = NO THEN DO:
  FOR EACH dsd_det WHERE /* *SS-20120817.1*   */ dsd_det.dsd_domain = global_domain and dsd_part >=part1 AND dsd_part <= part2 AND dsd_per_date >= date1 AND dsd_per_date <= date2 
   AND dsd_site >= shiptosite1 AND dsd_site <=shiptosite2 AND dsd_shipsite >=shipfrmsite1 AND dsd_shipsite <=shipfrmsite2  BY dsd_part.

   i = i + 1.

   chExcelWorkbook:worksheets(1):cells(i,1):VALUE = i - 5.
   chExcelWorkbook:worksheets(1):cells(i,2):VALUE = STRING(TODAY) + "-1".
   chExcelWorkbook:worksheets(1):cells(i,3):VALUE = dsd_part.
   FIND FIRST pt_mstr WHERE /* *SS-20120817.1*   */ pt_mstr.pt_domain = global_domain and pt_part = dsd_part NO-LOCK NO-ERROR.
   IF AVAIL pt_mstr THEN
       chExcelWorkbook:worksheets(1):cells(i,4):VALUE = pt_desc2.
   chExcelWorkbook:worksheets(1):cells(i,5):VALUE = dsd_shipsite.

   v_loc_qty = 0.

   FOR EACH IN_mstr WHERE /* *SS-20120817.1*   */ IN_mstr.in_domain = global_domain and IN_part = dsd_par AND IN_site = dsd_shipsite AND (in_qty_oh <> 0 OR in_qty_nonet <> 0) NO-LOCK.
        v_loc_qty = v_loc_qty +  IN_qty_oh + IN_qty_nonet.
   END.

   chExcelWorkbook:worksheets(1):cells(i,6):VALUE = v_loc_qty.

   chExcelWorkbook:worksheets(1):cells(i,7):VALUE = dsd_site.
   chExcelWorkbook:worksheets(1):cells(i,8):VALUE = dsd_nbr.
   chExcelWorkbook:worksheets(1):cells(i,9):VALUE = dsd_qty_con.

   FIND FIRST ptp_det WHERE /* *SS-20120817.1*   */ ptp_det.ptp_domain = global_domain and ptp_part = dsd_part AND ptp_site = dsd_site NO-LOCK NO-ERROR.
   IF AVAIL ptp_det THEN chExcelWorkbook:worksheets(1):cells(i,10):VALUE = ptp_ord_mult.
   ELSE chExcelWorkbook:worksheets(1):cells(i,10):VALUE = 0.

   chExcelWorkbook:worksheets(1):cells(i,11):VALUE = dsd_transit.
   chExcelWorkbook:worksheets(1):cells(i,12):VALUE = dsd_qty_con - dsd_qty_rcvd.




   /*
   FIND LAST pod_det WHERE pod_site = dsd_shipsite AND pod_part = dsd_part AND (pod_due_date= ? OR pod_due_date > TODAY) AND pod_status <> "C"  NO-LOCK NO-ERROR.
   IF AVAILABLE pod_det THEN DO:
       chExcelWorkbook:worksheets(1):cells(i,1):VALUE = dsd_nbr.
       chExcelWorkbook:worksheets(1):cells(i,2):VALUE = dsd_req.
       chExcelWorkbook:worksheets(1):cells(i,3):VALUE = dsd_site.
       chExcelWorkbook:worksheets(1):cells(i,4):VALUE = dsd_shipsite.
       chExcelWorkbook:worksheets(1):cells(i,5):VALUE = dsd_per_date.
       chExcelWorkbook:worksheets(1):cells(i,6):VALUE = dsd_shipdate.
       chExcelWorkbook:worksheets(1):cells(i,7):VALUE = dsd_due_date.
       chExcelWorkbook:worksheets(1):cells(i,8):VALUE = dsd_part.
       chExcelWorkbook:worksheets(1):cells(i,9):VALUE = dsd_qty_con.
       chExcelWorkbook:worksheets(1):cells(i,10):VALUE = dsd_qty_ship.
       chExcelWorkbook:worksheets(1):cells(i,11):VALUE = dsd_qty_rcvd.
       chExcelWorkbook:worksheets(1):cells(i,12):VALUE = dsd_transit.
       chExcelWorkbook:worksheets(1):cells(i,13):VALUE = dsd_qty_con - dsd_qty_rcvd.
       chExcelWorkbook:worksheets(1):cells(i,14):VALUE = pod_nbr.
       chExcelWorkbook:worksheets(1):cells(i,15):VALUE = pod_line.
       /*chExcelWorkbook:worksheets(1):cells(i,16):VALUE = dsd_nbr.
       chExcelWorkbook:worksheets(1):cells(i,17):VALUE = dsd_nbr.*/
   END.
   ELSE DO:
       chExcelWorkbook:worksheets(1):cells(i,1):VALUE = dsd_nbr.
       chExcelWorkbook:worksheets(1):cells(i,2):VALUE = dsd_req.
       chExcelWorkbook:worksheets(1):cells(i,3):VALUE = dsd_site.
       chExcelWorkbook:worksheets(1):cells(i,4):VALUE = dsd_shipsite.
       chExcelWorkbook:worksheets(1):cells(i,5):VALUE = dsd_per_date.
       chExcelWorkbook:worksheets(1):cells(i,6):VALUE = dsd_shipdate.
       chExcelWorkbook:worksheets(1):cells(i,7):VALUE = dsd_due_date.
       chExcelWorkbook:worksheets(1):cells(i,8):VALUE = dsd_part.
       chExcelWorkbook:worksheets(1):cells(i,9):VALUE = dsd_qty_con.
       chExcelWorkbook:worksheets(1):cells(i,10):VALUE = dsd_qty_ship.
       chExcelWorkbook:worksheets(1):cells(i,11):VALUE = dsd_qty_rcvd.
       chExcelWorkbook:worksheets(1):cells(i,12):VALUE = dsd_transit.
       chExcelWorkbook:worksheets(1):cells(i,13):VALUE = dsd_qty_con - dsd_qty_rcvd.
       chExcelWorkbook:worksheets(1):cells(i,14):VALUE = "".
       chExcelWorkbook:worksheets(1):cells(i,15):VALUE = "".
       /*chExcelWorkbook:worksheets(1):cells(i,16):VALUE = dsd_nbr.
       chExcelWorkbook:worksheets(1):cells(i,17):VALUE = dsd_nbr.*/

   END.
  */

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

