{mfdtitle.i}
DEF VAR hdoc AS HANDLE.
DEF VAR hroot AS HANDLE.
DEF VAR grp AS INT .
DEF VAR mcount AS INT.
DEF VAR totcnt AS INT.
DEF VAR iscr AS LOGICAL.
DEF VAR isfirst AS LOGICAL.
DEF VAR mfile AS CHAR.
DEF VAR hcurr AS HANDLE.
DEF VAR htemp AS HANDLE.
DEF VAR mqty LIKE pod_qty_ord.
DEF VAR mamt LIKE pod_pur_cost.
DEF VAR meffdt as CHAR FORMAT "x(8)".
DEF VAR  pre AS CHAR.
DEF VAR path AS CHAR FORMAT "x(40)" LABEL "Output".
DEF VAR mcnt AS INT.
DEF VAR ishave AS LOGICAL.
DEF VAR pre1 AS CHAR.
DEF BUFFER schddet FOR schd_det.
DEF FRAME a
    
    SKIP(0.5)
    "The PO is exporting......" COLON 15
    WITH WIDTH 80 SIDE-LABELS THREE-D.


VIEW FRAME a.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' NO-LOCK NO-ERROR.

grp = 0.

isfirst = YES.
totcnt = 0.
mcnt = 0.
    /*FOR EACH sch_mstr USE-INDEX sch_cr_date WHERE sch_type = 4  AND sch_cr_date = 02/09/04 AND substr(sch__chr01,8,1) = '' NO-LOCK:
     
        totcnt = totcnt + 1.
    END.*/
    pre = ''.
   
    FOR EACH schd_det  USE-INDEX schd_dtr WHERE   schd_type = 4  AND /*substr(schd_rlse_id,1,8) = string(year(TODAY),'9999') + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99')*/ schd_date = TODAY AND  /*AND schd_nbr = '0000401c'*/  SUBSTR(schd__chr10,8,1) = ''   EXCLUSIVE-LOCK :
     
        
   
       IF pre <> schd_rlse_id OR (mcnt >= 30 AND mcnt MOD 30 = 0 ) THEN DO:
           FIND FIRST scx_ref WHERE scx_po = schd_nbr AND scx_line = schd_line AND scx_type = 2 NO-LOCK NO-ERROR.
        FIND FIRST sch_mstr WHERE sch_rlse_id = schd_rlse_id NO-LOCK NO-ERROR.
           IF pre <> schd_rlse_id THEN DO:
         

         pre1 = ''.
   /*  mcount = 0.
   FOR EACH schddet USE-INDEX schd_dtr WHERE schddet.schd_rlse_id = sch_rlse_id  AND schddet.schd_nbr = sch_nbr AND schddet.schd_line = sch_line NO-LOCK :
IF pre1  <> string(schddet.schd_date) + string(schddet.schd_time) THEN mcount = mcount + 1.
IF mcount > 1 THEN LEAVE.
    END.*/
     END.

        IF NOT isfirst THEN DO:
       
hdoc:SAVE("file",code_cmmt + '\xml\ppo' + string(grp) + ".xml").

ishave = NO.
iscr = YES.
DELETE OBJECT hdoc.
DELETE OBJECT hcurr.
DELETE OBJECT htemp.
DELETE OBJECT hroot.
mfile = code_cmmt + '\xml\ppo' + string(grp) + ".xml".

RUN srxmlfil.p(INPUT mfile).
grp = grp + 1.

 /*supp*/
    END.
        IF isfirst OR iscr  THEN DO:
            
            isfirst = NO.
    iscr = NO.
  ishave = YES.
CREATE X-DOCUMENT hdoc.

hdoc:ENCODING = "UTF-8".

CREATE X-NODEREF hroot.
CREATE X-NODEREF hcurr.
hdoc:INITIALIZE-DOCUMENT-TYPE("","SupplyWeb_Data","","").
hdoc:GET-DOCUMENT-ELEMENT(hroot).

hcurr = hroot.

    END.
    
    CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"MaterialRelease","element").
hcurr:APPEND-CHILD(htemp).
hcurr = htemp.
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"MaterialRelease_Header","element").
hcurr:APPEND-CHILD(htemp).
hcurr = htemp.

 
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"release_no","element").
htemp:SET-ATTRIBUTE("value",replace(schd_rlse_id,'-','')).
hcurr:APPEND-CHILD(htemp).
/*
CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"purpose_code","element").
htemp:SET-ATTRIBUTE("value","").
hcurr:APPEND-CHILD(htemp).*/

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"release_date","element").
htemp:SET-ATTRIBUTE("value",string(year(sch_cr_date),'9999') + '-' + STRING(MONTH(sch_cr_date ),'99') + '-' + STRING(DAY(sch_cr_date),'99')).
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
htemp:SET-ATTRIBUTE("value",replace(scx_shipfrom,'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"ship_delivery_code","element").
htemp:SET-ATTRIBUTE("value",replace(substr(scx_shipfrom,LENGTH(scx_shipfrom) - 2,3),'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"test_yn","element").
htemp:SET-ATTRIBUTE("value","N").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_number","element").
htemp:SET-ATTRIBUTE("value",replace(sch_nbr,'>','')).
hcurr:APPEND-CHILD(htemp).
hcurr:GET-PARENT(hcurr).

FIND FIRST pod_det WHERE pod_nbr = sch_nbr AND pod_line = sch_line NO-LOCK NO-ERROR.

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"Part_Detail","element").
hcurr:APPEND-CHILD(htemp).
hcurr= htemp.

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"buyer_part_no","element").
htemp:SET-ATTRIBUTE("value",replace(pod_part,'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_number","element").
htemp:SET-ATTRIBUTE("value",replace(sch_nbr,'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"po_line_num","element").
htemp:SET-ATTRIBUTE("value",replace(string(pod_line),'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"unit_of_measure","element").
htemp:SET-ATTRIBUTE("value",replace(pod_um,'>','')).
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"cum_received_prior_qty","element").
htemp:SET-ATTRIBUTE("value","0").
hcurr:APPEND-CHILD(htemp).
    END.
   

   /* IF mcount = 1 THEN DO:*/
    CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"flex","element").
htemp:SET-ATTRIBUTE("name",replace(scx_shipfrom,'>','')).
FIND FIRST ad_mstr WHERE ad_addr = scx_shipfrom NO-LOCK NO-ERROR.
IF ad_name <> '' THEN
htemp:SET-ATTRIBUTE("value", ad_name).
ELSE htemp:SET-ATTRIBUTE("value", replace(ad_sort,'>','')).
hcurr:APPEND-CHILD(htemp).

  /*  END.*/







CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"Requirement_Detail","element").
hcurr:APPEND-CHILD(htemp).
hcurr= htemp.

    CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"requirement_date","element").
htemp:SET-ATTRIBUTE("value",string(year(schd_date),'9999') + '-' + string(MONTH(schd_date),'99') + '-' + STRING(DAY(schd_date),'99')).
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
htemp:SET-ATTRIBUTE("value","C").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"requirement_freq","element").
 htemp:SET-ATTRIBUTE("value","D").
hcurr:APPEND-CHILD(htemp).

CREATE X-NODEREF htemp.
hdoc:CREATE-NODE(htemp,"requirement_end_date","element").
 htemp:SET-ATTRIBUTE("value",string(year(schd_date + 30),'9999') + '-' + STRING(MONTH(schd_date + 30),'99') + '-' + STRING(DAY(schd_date + 30),'99')).
hcurr:APPEND-CHILD(htemp).
hcurr:GET-PARENT(hcurr).
/*schd*/
SUBSTR(schd__chr10,8,1) = 'y'.
pre = schd_RLSE_ID.

mcnt = mcnt + 1.


/* sch_mstr*/
    END.

    IF ishave  THEN DO:

    hdoc:SAVE("file",code_cmmt + '\xml\ppo' + string(grp) + ".xml").


DELETE OBJECT hdoc.
DELETE OBJECT hcurr.
DELETE OBJECT htemp.
DELETE OBJECT hroot.
mfile = code_cmmt + '\xml\ppo' + string(grp) + ".xml".

RUN srxmlfil.p(INPUT mfile).
END.
MESSAGE "The PO XML file has been created!" VIEW-AS ALERT-BOX.

