/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/16/12  ECO: *SS-20120816.1*   */

{mfdtitle.i "120816.1"}
DEFINE VAR part1 LIKE pt_part.
DEFINE VAR part2 LIKE pt_part.
DEFINE VAR date1 LIKE dsd_per_date.
DEFINE VAR date2 LIKE dsd_per_date.
DEFINE VAR shipfrmsite1 LIKE pt_site.
DEFINE VAR shipfrmsite2 LIKE pt_site.
DEFINE VAR shiptosite1 LIKE pt_site.
DEFINE VAR shiptosite2 LIKE pt_site.
DEFINE VAR i AS INTEGER.
DEFINE VAR v_desc1 LIKE pt_desc1.
DEFINE VAR v_desc2 LIKE pt_desc2.
DEFINE VAR v_prod_line LIKE pt_prod_line.
DEFINE VAR v_buyer LIKE ptp_buyer.

DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.


FORM
    part1        LABEL "零件号" COLON 20 part2        LABEL "To" COLON 55
    date1        LABEL "需求日期" COLON 20  date2     LABEL "To" COLON 55
    shipfrmsite1 LABEL "发运地" COLON 20 shipfrmsite2 LABEL "To" COLON 55
    shiptosite1  LABEL "发送到" COLON 20 shiptosite2  LABEL "To" COLON 55

    WITH FRAME  a SIDE-LABELS WIDTH 80 ATTR-SPACE NO-BOX THREE-D.


REPEAT:
    
    /*{mfselprt.i "printer" 132}*/
    IF part1 = hi_char THEN part1 = "".
    IF part2 = "" THEN part2 = hi_char.

    IF date1 = hi_date THEN date1 = low_date.
    IF date2 = low_date THEN date2 = hi_date.

    IF shipfrmsite1 = hi_char THEN shipfrmsite1 = "".
    IF shipfrmsite2 = "" THEN shipfrmsite2 = hi_char.
    IF shiptosite1 = hi_char  THEN shiptosite1 = "".
    IF shiptosite2 = "" THEN shiptosite2 = hi_char.

    UPDATE part1 part2 date1 date2 shipfrmsite1 shipfrmsite2 shiptosite1 shiptosite2 WITH FRAME a.

    IF SEARCH("\\qadtemp\appeb2\template\DRPship.xlt") = ? THEN DO: 
 /* *SS-20120816.1*    IF SEARCH("d:\DRPship11.xltx") = ? THEN DO: */
      MESSAGE "报表模板不存在!" VIEW-AS ALERT-BOX ERROR.
      UNDO,RETRY.
    END.

    i = 2.

    CREATE "Excel.Application" chExcelApplication.
    chExcelWorkbook = chExcelApplication:Workbooks:ADD("\\qadtemp\appeb2\template\DRPship.xlt"). 
 /* *SS-20120816.1*     chExcelWorkbook = chExcelApplication:Workbooks:ADD("d:\DRPship11.xltx"). */


   MESSAGE "开始计算，并写入EXCEL表格中" VIEW-AS ALERT-BOX. 

   FOR EACH dsd_det WHERE /* *SS-20120816.1*   */ dsd_det.dsd_domain = global_domain and  dsd_part >= part1 AND dsd_part <= part2 AND dsd_per_date >= date1 AND dsd_per_date <= date2 
    AND dsd_site >= shiptosite1 AND dsd_site <=shiptosite2 AND dsd_shipsite >=shipfrmsite1 AND  dsd_shipsite <=shipfrmsite2 NO-LOCK.

       FIND FIRST ptp_det WHERE /* *SS-20120816.1*   */ ptp_det.ptp_domain = global_domain and ptp_site = dsd_shipsite AND ptp_part = dsd_part NO-LOCK NO-ERROR.
       IF AVAIL ptp_det THEN v_buyer = ptp_buyer. ELSE v_buyer = "".
       
       FIND FIRST pt_mstr WHERE pt_part = dsd_part NO-LOCK NO-ERROR.
       IF AVAIL pt_mstr THEN DO: 
           v_desc1 = pt_desc1.
           v_desc2 = pt_desc2.
           v_prod_line = pt_prod_line.
       END.
       ELSE DO:
           v_desc1 = "".
           v_desc2 = "".
           v_prod_line = "".
       END.




     
    i = i + 1.
    FIND LAST pod_det WHERE /* *SS-20120816.1*   */ pod_det.pod_domain = global_domain and pod_site = dsd_shipsite AND pod_part = dsd_part AND (pod_due_date= ? OR pod_due_date > TODAY) AND pod_status <> "C"  NO-LOCK NO-ERROR.
    IF AVAILABLE pod_det THEN DO:
        chExcelWorkbook:worksheets(1):cells(i,1):VALUE = dsd_nbr.
        chExcelWorkbook:worksheets(1):cells(i,2):VALUE = dsd_req.
        chExcelWorkbook:worksheets(1):cells(i,3):VALUE = dsd_site.
        chExcelWorkbook:worksheets(1):cells(i,4):VALUE = dsd_shipsite.
        chExcelWorkbook:worksheets(1):cells(i,5):VALUE = dsd_per_date.
        chExcelWorkbook:worksheets(1):cells(i,6):VALUE = dsd_shipdate.
        chExcelWorkbook:worksheets(1):cells(i,7):VALUE = dsd_due_date.
        chExcelWorkbook:worksheets(1):cells(i,8):VALUE = dsd_part.


        chExcelWorkbook:worksheets(1):cells(i,9):VALUE = v_desc1.
        chExcelWorkbook:worksheets(1):cells(i,10):VALUE = v_desc2.
        chExcelWorkbook:worksheets(1):cells(i,11):VALUE = v_buyer.
        chExcelWorkbook:worksheets(1):cells(i,12):VALUE = v_prod_line.
        chExcelWorkbook:worksheets(1):cells(i,13):VALUE = dsd_qty_con.
        chExcelWorkbook:worksheets(1):cells(i,14):VALUE = dsd_qty_ship.
        chExcelWorkbook:worksheets(1):cells(i,15):VALUE = dsd_qty_rcvd.
        chExcelWorkbook:worksheets(1):cells(i,16):VALUE = dsd_transit.
        chExcelWorkbook:worksheets(1):cells(i,17):VALUE = dsd_qty_con - dsd_qty_rcvd.
        chExcelWorkbook:worksheets(1):cells(i,18):VALUE = pod_nbr.
        chExcelWorkbook:worksheets(1):cells(i,19):VALUE = pod_line.
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
        chExcelWorkbook:worksheets(1):cells(i,9):VALUE = v_desc1.
        chExcelWorkbook:worksheets(1):cells(i,10):VALUE = v_desc2.
        chExcelWorkbook:worksheets(1):cells(i,11):VALUE = v_buyer.
        chExcelWorkbook:worksheets(1):cells(i,12):VALUE = v_prod_line.
        chExcelWorkbook:worksheets(1):cells(i,13):VALUE = dsd_qty_con.
        chExcelWorkbook:worksheets(1):cells(i,14):VALUE = dsd_qty_ship.
        chExcelWorkbook:worksheets(1):cells(i,15):VALUE = dsd_qty_rcvd.
        chExcelWorkbook:worksheets(1):cells(i,16):VALUE = dsd_transit.
        chExcelWorkbook:worksheets(1):cells(i,17):VALUE = dsd_qty_con - dsd_qty_rcvd.
        chExcelWorkbook:worksheets(1):cells(i,18):VALUE = "".
        chExcelWorkbook:worksheets(1):cells(i,19):VALUE = "".
        /*chExcelWorkbook:worksheets(1):cells(i,16):VALUE = dsd_nbr.
        chExcelWorkbook:worksheets(1):cells(i,17):VALUE = dsd_nbr.*/

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

