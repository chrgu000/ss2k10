 {mfdtitle.i}
     
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
DEF VAR mfile AS CHAR.
DEF VAR pre AS CHAR.
DEF VAR ishave AS LOGICAL.
DEF VAR logistic AS CHAR FORMAT 'x(8)' LABEL '物流公司'.
isheader = NO.
DEF VAR ISEND AS LOGICAL.
define  variable rdate           like prh_rcp_date.
define  variable rdate1          like prh_rcp_date.
define  variable site            like pt_site.
define  variable site1           like pt_site.
define  variable vendor          like po_vend.
define  variable vendor1         like po_vend.
DEF VAR po_nbr LIKE po_nbr.
DEF VAR nbr1 LIKE po_nbr.
DEF FRAME a
    
    SKIP(0.5)
    vendor COLON 15
    vendor1 COLON 45
    site COLON 15
    site1 COLON 45
    po_nbr COLON 15
   nbr1 COLON 45
    rdate COLON 15
    rdate1 COLON 45
    logistic COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.
setFrameLabels(frame a:handle).
REPEAT:
    rdate = TODAY.
    rdate1 = TODAY.
  
UPDATE
    vendor 
    vendor1 
    site 
    site1 
    po_nbr 
   nbr1 
    rdate 
    rdate1 logistic
    WITH FRAME a.
IF  vendor1 = '' THEN vendor1 = hi_char.
IF  site1 = '' THEN site1 = hi_char.
IF  nbr1 = '' THEN nbr1 = hi_char.
IF  rdate = ? THEN rdate = low_date.
IF  rdate1 = ? THEN rdate = hi_date.

grp = 0.

FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.
mfile = string(YEAR(TODAY)) + STRING(MONTH(TODAY)) + STRING(DAY(TODAY)) + STRING(TIME) + 'receipt.xml'.
    OUTPUT TO VALUE(CODE_value + mfile) CONVERT TARGET 'utf-8' SOURCE 'gb2312'.
     

isfirst = YES.
totcnt = 0.
mcount = 0.
pre = ''.

PUT '<?xml version="1.0" encoding="UTF-8" ?>' SKIP.
PUT '<SupplyWeb_Data>' SKIP.

    
FOR EACH prh_hist  USE-INDEX prh_receiver     where (prh_rcp_date >= rdate and prh_rcp_date <= rdate1)
     AND (prh_vend >=  vendor and prh_vend <= vendor1)
      and (prh_site >=  site and prh_site <= site1)
    AND (prh_nbr >=  po_nbr AND prh_nbr <= nbr1) AND prh__chr10 <> 'c'
    ,FIRST pod_det WHERE pod_nbr = prh_nbr AND pod_line = prh_line AND (IF logistic <> '' THEN pod__chr01 = logistic ELSE YES):

    
IF pre <> prh_receiver THEN DO:
    IF ISEND THEN DO:
        PUT '</Receipt>' SKIP.
   ISEND = NO.
    END.
    PUT '<Receipt>' SKIP.
   PUT '<Receipt_Header>' SKIP.
   PUT '<transaction_type value="original"/>' SKIP.
   PUT UNFORMAT '<receipt_id value="' upper(PRH_RECEIVER) '"/>' SKIP.
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
  PUT '<model_id value=""/>' SKIP.
  PUT '<engineering_level value=""/>' SKIP.
  PUT UNFORMAT '<po_number value="' upper(PRH_NBR) '"/>' SKIP.
  PUT UNFORMAT '<po_line_no value="' PRH_LINE '"/>' SKIP.
  PUT UNFORMAT '<ship_quantity value="' PRH_RCVD '"/>' SKIP.
  PUT UNFORMAT '<received_quantity value="' PRH_RCVD '"/>' SKIP.
  PUT UNFORMAT '<cum_received_qty value="' PRH_CUM_RCVD '"/>' SKIP.
  PUT '<pull_signal value=""/>' SKIP.
  PUT '</Receipt_Detail>' SKIP.
 ISEND = YES.
 PRE = PRH_RECEIVER.
 prh__chr10 = 'c'.
END.
  PUT '</Receipt>' SKIP.
PUT '</SupplyWeb_Data>' SKIP.
OUTPUT CLOSE.


MESSAGE "The receipt XNL file has been created!" VIEW-AS ALERT-BOX.
END.
