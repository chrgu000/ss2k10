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

    
FOR EACH prh_hist USE-INDEX prh_receiver  WHERE SUBSTR(prh__chr10,8,1) = '' AND prh_rcp_date = TODAY  EXCLUSIVE-LOCK :

    IF isfirst OR iscr  THEN DO:
 
    isfirst = NO.
   
    ishave = YES.
    CREATE X-DOCUMENT hdoc.

hdoc:ENCODING = "UTF-8".

CREATE X-NODEREF hroot.
CREATE X-NODEREF hcurr.
hdoc:INITIALIZE-DOCUMENT-TYPE("","SupplyWeb_Data","","").
hdoc:GET-DOCUMENT-ELEMENT(hroot).
hcurr = hroot.
 END.
IF pre <> prh_receiver OR iscr THEN DO:
   /* IF NOT iscr THEN 
    IF hcurr <> hroot THEN DO:*/
     hcurr = hroot.
/*  END.*/
      iscr = NO.
     
    CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"Receipt","element").
hcurr:APPEND-CHILD(htemp).
hcurr = htemp.


CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"Receipt_Header","element").
hcurr:APPEND-CHILD(htemp).
hcurr = htemp.



CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"transaction_type","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"receipt_id","element").
htemp:SET-ATTRIBUTE("value",replace(prh_receiver,'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"facility_id","element").
htemp:SET-ATTRIBUTE("value","DCEC-B").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"supplier_id","element").
htemp:SET-ATTRIBUTE("value",replace(prh_vend,'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ship_to_id","element").
htemp:SET-ATTRIBUTE("value","DCEC-B").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"shipper_no","element").
FIND FIRST ad_mstr WHERE ad_addr = prh_vend NO-LOCK NO-ERROR.
htemp:SET-ATTRIBUTE("value",replace(ad_addr,'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"bill_of_lading_id","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"dock_code","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"adjustment_reason_text","element").

htemp:SET-ATTRIBUTE("value","Original").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"receipt_date_time","element").
htemp:SET-ATTRIBUTE("value",STRING(YEAR(prh_rcp_date),'9999') + '-' + string(MONTH(prh_rcp_date),'99') + '-' + STRING(DAY(prh_rcp_date),'99')).
hcurr:APPEND-CHILD(htemp).
isheader = YES.
END.


 
    hcurr:GET-PARENT(hcurr).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"Receipt_Detail","element").

hcurr:APPEND-CHILD(htemp).

hcurr = htemp.
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"cust_part_no","element").
htemp:SET-ATTRIBUTE("value",replace(prh_part,'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"model_id","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"engineering_level","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_number","element").
htemp:SET-ATTRIBUTE("value",replace(prh_nbr,'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_line_no","element").
htemp:SET-ATTRIBUTE("value",string(prh_line)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ship_quantity","element").
htemp:SET-ATTRIBUTE("value",string(prh_rcvd)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"received_quantity","element").
htemp:SET-ATTRIBUTE("value",string(prh_rcvd)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"cum_received_qty","element").
htemp:SET-ATTRIBUTE("value",string(prh_cum_rcvd)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"pull_signal","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).




substr(prh__chr10,8,1) = 'y'.
mcount = mcount  + 1.
pre = prh_receiver.
IF (mcount >= 30 AND mcount MOD 30 = 0)  THEN DO:

hdoc:SAVE("file",CODE_cmmt + '\xml\receipt' + string(grp) + ".xml").

ishave = NO.
iscr = YES.
DELETE OBJECT hdoc.
DELETE OBJECT hcurr.
DELETE OBJECT htemp.
DELETE OBJECT hroot.
mfile = CODE_cmmt + '\xml\receipt'  + string(grp) + ".xml".

RUN srxmlfil.p(INPUT mfile).
grp = grp + 1.
END.
END.

IF ishave THEN DO:

hdoc:SAVE("file",CODE_cmmt + '\xml\receipt'  + string(grp) + ".xml").

DELETE OBJECT hdoc.
DELETE OBJECT hcurr.
DELETE OBJECT htemp.
DELETE OBJECT hroot.
mfile = CODE_cmmt + '\xml\receipt' + string(grp) + ".xml".

RUN srxmlfil.p(INPUT mfile).

END.

MESSAGE "The receipt XNL file has been created!" VIEW-AS ALERT-BOX.

