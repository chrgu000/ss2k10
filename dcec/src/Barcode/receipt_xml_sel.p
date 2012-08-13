 {mfdtitle.i}
     {gplabel.i}
 DEF VAR hdoc AS HANDLE.
DEF VAR hroot AS HANDLE.
DEF VAR hcurr AS HANDLE.
DEF VAR htemp AS HANDLE.
DEF VAR path AS CHAR FORMAT "x(40)" LABEL "Output".
DEF VAR rcvr LIKE prh_receiver.
DEF VAR rcvr1 LIKE prh_receiver.
DEF FRAME a
    
    SKIP(0.5)
    rcvr COLON 15
    rcvr1 COLON 45
    WITH WIDTH 80 SIDE-LABELS THREE-D.
REPEAT:
setframelabels(FRAME a:HANDLE).
PROMPT-FOR  rcvr rcvr1 WITH FRAME a.
IF INPUT rcvr1 = '' THEN rcvr1 = hi_char.

CREATE X-DOCUMENT hdoc.

hdoc:ENCODING = "UTF-8".

CREATE X-NODEREF hroot.
CREATE X-NODEREF hcurr.
hdoc:INITIALIZE-DOCUMENT-TYPE("","SuppluWeb_Data","","").
hdoc:GET-DOCUMENT-ELEMENT(hroot).
hcurr = hroot.
FOR EACH prh_hist /*WHERE prh_vend = '002'*/ WHERE Prh_receiver >= INPUT rcvr AND prh_receiver <=  rcvr1 EXCLUSIVE-LOCK:
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
htemp:SET-ATTRIBUTE("value",prh_receiver).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"facility_id","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ship_to_id","element").
htemp:SET-ATTRIBUTE("value",prh_ship).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"shipper_no","element").
htemp:SET-ATTRIBUTE("value","").
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
hdoc:CREATE-NODE(htemp,"flex","element").
htemp:SET-ATTRIBUTE("name","").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ship_date_time","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"receipt_date_time","element").
htemp:SET-ATTRIBUTE("value",string(prh_rcp_date)).
hcurr:APPEND-CHILD(htemp).


hcurr:GET-PARENT(hcurr).


CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"Receipt_Detail","element").

hcurr:APPEND-CHILD(htemp).

hcurr = htemp.
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"cust_part_no","element").
htemp:SET-ATTRIBUTE("value",prh_part).
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
htemp:SET-ATTRIBUTE("value",prh_nbr).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_line_no","element").
htemp:SET-ATTRIBUTE("value",string(prh_line)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ship_quantity","element").
htemp:SET-ATTRIBUTE("value","").
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
hdoc:CREATE-NODE(htemp,"pull_singal","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).


CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"flex","element").
htemp:SET-ATTRIBUTE("name","").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).
hcurr:GET-PARENT(hcurr).
hcurr:GET-PARENT(hcurr).
substr(prh__chr10,8,1) = 'y'.
END.
hdoc:SAVE("file","c:\receipt.xml").
MESSAGE "The receipt XNL file has been created!" VIEW-AS ALERT-BOX.
END.
