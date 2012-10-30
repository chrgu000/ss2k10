/* {mfdtitle.i}*/
     
 DEF VAR hdoc AS HANDLE.
DEF VAR hroot AS HANDLE.
DEF VAR hcurr AS HANDLE.
DEF VAR htemp AS HANDLE.
DEF VAR path AS CHAR FORMAT "x(40)" LABEL "Output".
DEF VAR rcvr LIKE prh_receiver.
DEF VAR rcvr1 LIKE prh_receiver.
DEF VAR isheader AS LOGICAL .
DEF VAR grp AS INT .
DEF VAR mcount AS INT.
DEF VAR totcnt AS INT.
DEF VAR iscr AS LOGICAL.
DEF VAR isfirst AS LOGICAL.
DEF VAR mfile  AS CHAR.
DEF VAR mfile1 AS CHAR.
DEF VAR ishave AS LOGICAL.
DEF VAR logistic AS CHAR FORMAT 'x(8)' LABEL '物流公司'.
isheader = NO.
DEF VAR ISEND AS LOGICAL.
define  variable rdate           like prh_rcp_date.
define  variable rdate1          like prh_rcp_date.
DEF VAR po_nbr LIKE po_nbr.
DEF VAR nbr1 LIKE po_nbr.
DEF VAR isstart AS LOGICAL.
DEF VAR ishead AS LOGICAL.
DEF VAR v_pur_price LIKE prh_pur_cost.

    rdate = TODAY - 1.
    rdate1 = TODAY - 1.
  
grp = 0.

FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.
mfile  = string(YEAR(TODAY)) + STRING(MONTH(TODAY)) + STRING(DAY(TODAY)) + STRING(TIME) + 'receipt.txt'.
mfile1 = string(YEAR(TODAY)) + STRING(MONTH(TODAY)) + STRING(DAY(TODAY)) + STRING(TIME) + 'receipt.xml'.

isfirst = YES.
totcnt = 0.
mcount = 0.
   isstart = YES.
  ishead = NO.
    
FOR EACH prh_hist  USE-INDEX PRH_RECEIVER where (prh_rcp_date >= rdate and prh_rcp_date <= rdate1)
    /*AND prh__chr10 <> 'c'*/ 
    /*,FIRST ptp_det WHERE ptp_site = prh_site AND ptp_part = prh_part */
    ,FIRST pod_det WHERE pod_nbr = prh_nbr AND pod_line = prh_line AND (IF logistic <> '' THEN pod__chr01 = logistic ELSE YES)
    break by PRH_RECEIVER :
IF isstart THEN DO:
OUTPUT TO VALUE(CODE_value + mfile) CONVERT TARGET 'utf-8' SOURCE 'gb2312'.


PUT '<?xml version="1.0" encoding="UTF-8" ?>' SKIP.
PUT '<SupplyWeb_Data>' SKIP.
isstart = NO.
ishead = YES.
END.
IF FIRST-OF(PRH_RECEIVER) THEN DO:
   PUT '<Receipt>' SKIP.
   PUT '<Receipt_Header>' SKIP.
   PUT '<transaction_type value="original"/>' SKIP.
   PUT UNFORMAT '<receipt_id value="' IF prh_rcvd < 0 THEN '-' + upper(PRH_RECEIVER) ELSE upper(PRH_RECEIVER) '"/>' SKIP.
   PUT UNFORMAT '<facility_id value="' upper(prh_site) '"/>' SKIP.
   PUT UNFORMAT '<supplier_id value="' IF AVAILABLE pod_det AND pod__chr01 <> '' AND pod__chr01 <> 'LS' THEN upper(pod__chr01) ELSE  upper(PRH_VEND) '"/>' SKIP.
   FIND FIRST IN_mstr WHERE IN_site = prh_site AND IN_part = prh_part NO-LOCK NO-ERROR.
   PUT UNFORMAT '<ship_to_id value="' IF AVAILABLE IN_mstr AND SUBSTR(IN__qadc01,1,2) <> '' THEN upper(SUBSTR(IN__qadc01,1,2)) ELSE SUBSTR(prh_nbr,LENGTH(prh_nbr),1) + '0' '"/>' SKIP.
   PUT UNFORMAT '<shipper_no value="' upper(PRH_VEND) '"/>' SKIP.
   PUT '<bill_of_lading_id value=""/>' SKIP.
   PUT '<dock_code value=""/>' SKIP.
   PUT '<adjustment_reason_text value="Original"/>' SKIP.
   PUT UNFORMAT '<receipt_date_time value="' STRING(YEAR(prh_rcp_date),'9999') + '-' + string(MONTH(prh_rcp_date),'99') + '-' + STRING(DAY(prh_rcp_date),'99') '"/>' SKIP.
   PUT '</Receipt_Header>' SKIP.
END.


PUT '<Receipt_Detail>' SKIP.
  PUT UNFORMAT '<cust_part_no value="' (IF  pod__chr01 <> '' AND pod__chr01 <> 'LS' THEN upper(prh_vend) + '#' ELSE '') upper(PRH_PART) '"/>' SKIP.
  

  FIND LAST pc_mstr WHERE pc_part = prh_part AND pc_list = prh_vend AND pc_start <> 01/01/01 AND (pc_expire >= prh_rcp_date  OR pc_expire = ?) NO-LOCK NO-ERROR.
  IF AVAIL pc_mstr  THEN v_pur_price = prh_pur_cost.
  ELSE v_pur_price = 0.
   /*prh_pur_cost*/

  PUT '<model_id value="' v_pur_price '"/>' SKIP.
  PUT '<engineering_level value=""/>' SKIP.
  PUT UNFORMAT '<po_number value="' upper(PRH_NBR) '"/>' SKIP.
  PUT UNFORMAT '<po_line_no value="'  PRH_LINE '"/>' SKIP.
  PUT UNFORMAT '<ship_quantity value="' ABS(prh_rcvd) '"/>' SKIP.
  PUT UNFORMAT '<received_quantity value="' ABS(prh_rcvd) '"/>' SKIP.
  PUT UNFORMAT '<cum_received_qty value="' ABS(prh_rcvd) '"/>' SKIP.
  PUT '<pull_signal value=""/>' SKIP.
  PUT '</Receipt_Detail>' SKIP.
 ISEND = YES.
 /*prh__chr10 = 'c'.*/


    IF LAST-OF(PRH_receiver) THEN PUT '</Receipt>' SKIP.
      
END. 
IF ishead THEN DO:
   PUT '</SupplyWeb_Data>' SKIP.
   OUTPUT CLOSE.

  OS-RENAME VALUE(CODE_value + mfile) VALUE(CODE_value + mfile1).
  /* MESSAGE "The receipt XML file has been created!" VIEW-AS ALERT-BOX.  */
END.
QUIT.


 
