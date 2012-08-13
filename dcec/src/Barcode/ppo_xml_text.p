{mfdtitle.i}
DEF VAR hdoc AS HANDLE.
DEF VAR hroot AS HANDLE.

DEF VAR hcurr AS HANDLE.
DEF VAR htemp AS HANDLE.
DEF VAR mqty LIKE pod_qty_ord.
DEF VAR mamt LIKE pod_pur_cost.
DEF VAR meffdt as CHAR FORMAT "x(8)".

DEF VAR path AS CHAR FORMAT "x(40)" LABEL "Output".
DEF FRAME a
    
    SKIP(0.5)
    path COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.
REPEAT:

UPDATE  path WITH FRAME a.
IF path = '' THEN DO: MESSAGE "The path is empty!" VIEW-AS ALERT-BOX.
    UNDO,RETRY.
END.




CREATE X-DOCUMENT hdoc.

hdoc:ENCODING = "UTF-8".

CREATE X-NODEREF hroot.
CREATE X-NODEREF hcurr.
hdoc:INITIALIZE-DOCUMENT-TYPE("","SuppluWeb_Data","","").
hdoc:GET-DOCUMENT-ELEMENT(hroot).
hcurr = hroot.
FOR EACH po_mstr WHERE /*po_vend = '5017000' OR po_vend = '002'*/ po_nbr = 'po-27' NO-LOCK:
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ProposedPO","element").
hcurr:APPEND-CHILD(htemp).
hcurr = htemp.


    
    
    
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"PO_Header","element").
hcurr:APPEND-CHILD(htemp).
hcurr = htemp.



CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"purpose_code","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"facility_id","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"facility_description","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ship_to_id","element").
htemp:SET-ATTRIBUTE("value",po_ship).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ship_to_description","element").
FIND FIRST ad_mstr WHERE ad_addr = po_ship NO-LOCK NO-ERROR.
IF AVAILABLE ad_mstr THEN htemp:SET-ATTRIBUTE("value",ad_sort).
ELSE htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"supplier_id","element").
htemp:SET-ATTRIBUTE("value",po_vend).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"supplier_description","element").
FIND FIRST ad_mstr WHERE ad_addr = po_vend NO-LOCK NO-ERROR.
IF AVAILABLE ad_mstr THEN htemp:SET-ATTRIBUTE("value",ad_sort).
ELSE htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_number","element").

mqty = 0.
FOR EACH pod_det WHERE pod_nbr = po_nbr:
mqty = mqty + pod_qty_ord.
    END.
    RELEASE pod_det.
htemp:SET-ATTRIBUTE("value",string(mqty)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_type","element").
htemp:SET-ATTRIBUTE("value",po_type).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_date","element").
htemp:SET-ATTRIBUTE("value",string(po_ord_date)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"generation_date","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"order_no","element").
htemp:SET-ATTRIBUTE("value",po_nbr).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"totocost","element").
mamt = 0.
FOR EACH pod_det WHERE pod_nbr = po_nbr:
mamt = mamt + pod_pur_cost * pod_disc_pct * pod_qty_ord .
    END.
    RELEASE pod_det.
htemp:SET-ATTRIBUTE("value",string(mamt)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"test_yn","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"currency","element").
htemp:SET-ATTRIBUTE("value",po_curr).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"payment_method","element").
htemp:SET-ATTRIBUTE("value",po_cr_terms).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"discout_rate","element").
htemp:SET-ATTRIBUTE("value",string(po_disc_pct)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"discount_days","element").
FIND FIRST ct_mstr WHERE ct_code = po_cr_terms NO-LOCK NO-ERROR.
IF AVAILABLE ct_mstr THEN htemp:SET-ATTRIBUTE("value",string(ct_disc_days)).
ELSE htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"net_days","element").
IF AVAILABLE ct_mstr THEN htemp:SET-ATTRIBUTE("value",string(ct_due_days - ct_disc_days)).
ELSE htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"tax_exempt_flag","element").
htemp:SET-ATTRIBUTE("value",string(po_taxable)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"tax_id","element").
FIND FIRST ad_mstr WHERE po_vend = ad_addr NO-LOCK NO-ERROR.
IF AVAILABLE ad_mstr THEN htemp:SET-ATTRIBUTE("value",ad_gst_id).
ELSE htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"tax_exempt_id","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"country_tax","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"state_tax","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"city_tax","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"contact_id","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"contact_name","element").

htemp:SET-ATTRIBUTE("value",po_contact).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"contact_phone","element").
FIND FIRST vd_mstr WHERE po_vend = vd_addr NO-LOCK NO-ERROR.
IF AVAILABLE vd_mstr  THEN
htemp:SET-ATTRIBUTE("value",ad_phone).
ELSE htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"contact_email","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"contact_fax","element").
htemp:SET-ATTRIBUTE("value",ad_fax).
hcurr:APPEND-CHILD(htemp).




CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"adjustment","element").
hcurr:APPEND-CHILD(htemp).
hcurr= htemp.
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"amount","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"code","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"text","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).
hcurr:GET-PARENT(hcurr).
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"note","element").

hcurr:APPEND-CHILD(htemp).
hcurr= htemp.
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"msg_txt","element").
htemp:SET-ATTRIBUTE("value",po_rmks).
hcurr:APPEND-CHILD(htemp).
hcurr:GET-PARENT(hcurr).
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"flex","element").
htemp:SET-ATTRIBUTE("name","").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).
hcurr:GET-PARENT(hcurr).
FOR EACH pod_det WHERE pod_nbr = po_nbr:

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"PO_Detail","element").
hcurr:APPEND-CHILD(htemp).
hcurr= htemp.
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_line_no","element").
htemp:SET-ATTRIBUTE("value",string(pod_line)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"cust_part_no","element").
htemp:SET-ATTRIBUTE("value",pod_part).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"cust_part_desc","element").
FIND FIRST pt_mstr WHERE pt_part = pod_part NO-LOCK NO-ERROR.
IF AVAILABLE pt_mstr THEN htemp:SET-ATTRIBUTE("value",pt_desc1 + pt_desc2).
  ELSE htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"vendor_part_no","element").
htemp:SET-ATTRIBUTE("value",pod_vpart).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"quantity","element").
htemp:SET-ATTRIBUTE("value",string(pod_qty_ord)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"order_uofm","element").
htemp:SET-ATTRIBUTE("value",pod_um).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"unit_price","element").
htemp:SET-ATTRIBUTE("value",string(round(pod_pur_cost / pod_um_conv,2))).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"price_uofm","element").
htemp:SET-ATTRIBUTE("value",string(round(pod_pur_cost * pod_disc_pct,2))).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"extended_price","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"requirement_date","element").
htemp:SET-ATTRIBUTE("value",string(po_due_date)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"price_eff_date","element").
meffdt = ''. 
FIND FIRST pc_mstr WHERE pc_list = IF po_pr_list <> '' THEN po_pr_list ELSE po_pr_list2 NO-LOCK NO-ERROR. 
IF AVAILABLE pc_mstr THEN meffdt  = STRING(pc_start).
 
  htemp:SET-ATTRIBUTE("value", meffdt).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"price_exp_date","element").
meffdt = ''.
IF AVAILABLE pc_mstr THEN meffdt  = STRING(pc_expire).
htemp:SET-ATTRIBUTE("value",meffdt).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"model_year","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"dock_code","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"engineeing_level","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"tax_exempt_flag","element").
htemp:SET-ATTRIBUTE("value",string(pod_taxable)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"adjustment","element").

hcurr:APPEND-CHILD(htemp).
hcurr= htemp.
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"amount","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"code","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"text","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

hcurr:GET-PARENT(hcurr).
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"note","element").
hcurr:APPEND-CHILD(htemp).
hcurr= htemp.

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"msg_txt","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).
hcurr:GET-PARENT(hcurr).
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"schedule","element").
hcurr:APPEND-CHILD(htemp).
hcurr= htemp.

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"release_no","element").
htemp:SET-ATTRIBUTE("value",pod_curr_rlse[1]).
hcurr:APPEND-CHILD(htemp).
FIND FIRST schd_det WHERE schd_rlse_id = pod_curr_rlse[1] NO-LOCK NO-ERROR.
IF AVAILABLE schd_det THEN DO:

FOR EACH schd_det WHERE schd_rlse_id = pod_curr_rlse[1] NO-LOCK:

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"shcedule_quantity","element").

htemp:SET-ATTRIBUTE("value",STRING(schd_discr_qty)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"schedule_date","element").
htemp:SET-ATTRIBUTE("value",string(schd_date)).
hcurr:APPEND-CHILD(htemp).
END.
END.
ELSE DO:
    CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"shcedule_quantity","element").

htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"schedule_date","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).
END.
hcurr:GET-PARENT(hcurr).
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"flex","element").
htemp:SET-ATTRIBUTE("name","").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).
hcurr:GET-PARENT(hcurr).
END.
hcurr:GET-PARENT(hcurr).
END.
hdoc:SAVE("file",path).
MESSAGE "The PO XML file has been created!" VIEW-AS ALERT-BOX.
END.
