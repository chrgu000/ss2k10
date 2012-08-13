{mfdtitle.i}
DEF VAR hdoc AS HANDLE.
DEF VAR hroot AS HANDLE.

DEF VAR hcurr AS HANDLE.
DEF VAR htemp AS HANDLE.
DEF VAR mqty LIKE pod_qty_ord.
DEF VAR mamt LIKE pod_pur_cost.
DEF VAR meffdt as CHAR FORMAT "x(8)".
DEF VAR mcount AS INT.
DEF VAR path AS CHAR FORMAT "x(40)" LABEL "Output".
DEF FRAME a
    
    SKIP(0.5)
    "The PO is exporting......" COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.


VIEW FRAME a.




CREATE X-DOCUMENT hdoc.

hdoc:ENCODING = "UTF-8".

CREATE X-NODEREF hroot.
CREATE X-NODEREF hcurr.
hdoc:INITIALIZE-DOCUMENT-TYPE("","SupplyWeb_Data","","").
hdoc:GET-DOCUMENT-ELEMENT(hroot).
hcurr = hroot.
FOR EACH scx_ref WHERE scx_type = 2  /*po_vend = '5017000' OR po_vend = '002'*/  NO-LOCK:
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"Materialrelease","element").
hcurr:APPEND-CHILD(htemp).
hcurr = htemp.


    
   
    FOR EACH sch_mstr WHERE sch_type = 4 AND sch_nbr = scx_po AND sch_line = scx_line AND  substr(sch__chr01,8,1) = '' EXCLUSIVE-LOCK:
   
    
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"Materialrelease_Header","element").
hcurr:APPEND-CHILD(htemp).
hcurr = htemp.

 
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"release_no","element").
htemp:SET-ATTRIBUTE("value",replace(sch_rlse_id,'-','')).
hcurr:APPEND-CHILD(htemp).
/*
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"purpose_code","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).*/

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"release_date","element").
htemp:SET-ATTRIBUTE("value",string(year(sch_cr_date)) + '-' + STRING(MONTH(sch_cr_date )) + '-' + STRING(DAY(sch_cr_date))).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"purpose_code","element").
htemp:SET-ATTRIBUTE("value","00").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"facility_id","element").
htemp:SET-ATTRIBUTE("value","DCEC-B").
hcurr:APPEND-CHILD(htemp).
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ship_to_id","element").
htemp:SET-ATTRIBUTE("value","DCEC-B").
hcurr:APPEND-CHILD(htemp).



CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"supplier_id","element").
htemp:SET-ATTRIBUTE("value",scx_shipfrom).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ship_delivery_code","element").
htemp:SET-ATTRIBUTE("value",scx_shipfrom).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"test_yn","element").
htemp:SET-ATTRIBUTE("value","N").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_number","element").
htemp:SET-ATTRIBUTE("value",sch_nbr).
hcurr:APPEND-CHILD(htemp).
hcurr:GET-PARENT(hcurr).

FIND FIRST pod_det WHERE pod_nbr = sch_nbr AND pod_line = sch_line NO-LOCK NO-ERROR.

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"Part_Detail","element").
hcurr:APPEND-CHILD(htemp).
hcurr= htemp.

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"buyer_part_no","element").
htemp:SET-ATTRIBUTE("value",pod_part).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_number","element").
htemp:SET-ATTRIBUTE("value",sch_nbr).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_line_num","element").
htemp:SET-ATTRIBUTE("value",string(pod_line)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"unit_of_measure","element").
htemp:SET-ATTRIBUTE("value",pod_um).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"cum_received_prior_qty","element").
htemp:SET-ATTRIBUTE("value","0").
hcurr:APPEND-CHILD(htemp).
mcount = 0.
FOR EACH schd_det WHERE schd_rlse_id = sch_rlse_id  AND schd_nbr = sch_nbr AND schd_line = sch_line NO-LOCK BREAK BY (string(schd_date) + STRING(schd_time)):
IF LAST-OF(STRING(schd_date) + STRING(schd_time)) THEN mcount = mcount + 1.

    END.
    IF mcount = 1 THEN DO:
    CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"flex","element").
htemp:SET-ATTRIBUTE("name",scx_shipfrom).
FIND FIRST ad_mstr WHERE ad_addr = scx_shipfrom NO-LOCK NO-ERROR.
IF ad_name <> '' THEN
htemp:SET-ATTRIBUTE("value", ad_name).
ELSE htemp:SET-ATTRIBUTE("value", ad_sort).
hcurr:APPEND-CHILD(htemp).

    END.





FOR EACH schd_det WHERE schd_rlse_id = sch_rlse_id  AND schd_nbr = sch_nbr AND schd_line = sch_line NO-LOCK:

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"Requirement_Detail","element").
hcurr:APPEND-CHILD(htemp).
hcurr= htemp.

    CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"requirement_date","element").
htemp:SET-ATTRIBUTE("value",string(year(schd_date)) + '-' + string(MONTH(schd_date)) + '-' + STRING(DAY(schd_date))).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"requirement_time","element").
htemp:SET-ATTRIBUTE("value",string(schd_time)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"requirement_qty","element").
htemp:SET-ATTRIBUTE("value",STRING(schd_discr_qty)).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"requirement_type","element").
IF mcount = 1 THEN
htemp:SET-ATTRIBUTE("value","C").
ELSE IF mcount > 1 THEN htemp:SET-ATTRIBUTE("value","D").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"requirement_freq","element").
 htemp:SET-ATTRIBUTE("value","D").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"requirement_end_date","element").
 htemp:SET-ATTRIBUTE("value",string(year(schd_date + 30)) + '-' + STRING(MONTH(schd_date + 30)) + '-' + STRING(DAY(schd_date + 30))).
hcurr:APPEND-CHILD(htemp).
hcurr:GET-PARENT(hcurr).
END. /*schd*/


/*pod*/
hcurr:GET-PARENT(hcurr).
SUBSTR(sch__chr01,8,1) = 'y'.
hcurr:GET-PARENT(hcurr).
END. /* sch_mstr*/

END. /*scx_ref*/
hdoc:SAVE("file","c:\ppo.xml").
MESSAGE "The PO XML file has been created!" VIEW-AS ALERT-BOX.

