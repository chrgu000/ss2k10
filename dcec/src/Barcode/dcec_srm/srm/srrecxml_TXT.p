 {mfdtitle.i}
     {gplabel.i}
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
isheader = NO.
DEF VAR ISEND AS LOGICAL.
DEF FRAME a
    
    SKIP(0.5)
    "The receipt is exporting......" COLON 15
    
    WITH WIDTH 80 SIDE-LABELS THREE-D.

grp = 0.
VIEW FRAME a.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.

isfirst = YES.
totcnt = 0.
mcount = 0.
pre = ''.
OUTPUT TO VALUE(CODE_CMMT + '\XML\RECEIPT.XML').
PUT '<?xml version="1.0" encoding="UTF-8" ?>' SKIP.
PUT '<SupplyWeb_Data>' SKIP.

    
FOR EACH prh_hist USE-INDEX prh_receiver  WHERE SUBSTR(prh__chr10,8,1) = '' AND prh_rcp_date = TODAY  EXCLUSIVE-LOCK :

    
IF pre <> prh_receiver THEN DO:
    IF ISEND THEN DO:
        PUT '</Receipt>' SKIP.
   ISEND = NO.
    END.
    PUT '<Receipt>' SKIP.
   PUT '<Receipt_Header>' SKIP.
   PUT '<transaction_type value=""/>' SKIP.
   PUT UNFORMAT '<receipt_id value="' PRH_RECEIVER '"/>' SKIP.
   PUT '<facility_id value="DCEC-B"/>' SKIP.
   PUT '<supplier_id value="' PRH_VEND '"/>' SKIP.
   PUT '<ship_to_id value="DCEC-B"/>' SKIP.
   PUT UNFORMAT '<shipper_no value="' PRH_VEND '"/>' SKIP.
   PUT '<bill_of_lading_id value=""/>' SKIP.
   PUT '<dock_code value=""/>' SKIP.
   PUT '<adjustment_reason_text value="Original"/>' SKIP.
   PUT UNFORMAT '<receipt_date_time value="' STRING(YEAR(prh_rcp_date),'9999') + '-' + string(MONTH(prh_rcp_date),'99') + '-' + STRING(DAY(prh_rcp_date),'99') '"/>' SKIP.
   PUT '</Receipt_Header>' SKIP.

END.
  PUT '<Receipt_Detail>' SKIP.
  PUT UNFORMAT '<cust_part_no value="' PRH_PART '"/>' SKIP.
  PUT '<model_id value=""/>' SKIP.
  PUT '<engineering_level value=""/>' SKIP.
  PUT '<po_number value="' PRH_NBR '"/>' SKIP.
  PUT '<po_line_no value="' PRH_LINE '"/>' SKIP.
  PUT UNFORMAT '<ship_quantity value="' PRH_RCVD '"/>' SKIP.
  PUT UNFORMAT '<received_quantity value="' PRH_RCVD '"/>' SKIP.
  PUT UNFORMAT '<cum_received_qty value="' PRH_CUM_RCVD '"/>' SKIP.
  PUT '<pull_signal value=""/>' SKIP.
  PUT '</Receipt_Detail>' SKIP.
 ISEND = YES.
 PRE = PRH_RECEIVER.
 SUBSTR(prh__chr10,8,1) = 'Y'.
END.
  PUT '</Receipt>' SKIP.
PUT '</SupplyWeb_Data>' SKIP.
OUTPUT CLOSE.


MESSAGE "The receipt XNL file has been created!" VIEW-AS ALERT-BOX.

