
DEFINE VAR mfile  AS CHAR.
DEFINE VAR mfile1 AS CHAR.
DEFINE VAR v_warehouse LIKE CODE_cmmt INITIAL "B01".
DEFINE VAR v_date_string AS CHAR.
DEFINE VAR v_3pl LIKE pod__chr01.


DEFINE VAR v_site1 LIKE pod_site INITIAL "DCEC-SV".
DEFINE VAR v_site2 LIKE pod_site INITIAL "DCEC-SV".
DEFINE VAR v_sch_date1 LIKE schd_date INITIAL TODAY.
DEFINE VAR v_sch_date2 LIKE schd_date INITIAL TODAY.



{mfdtitle.i "d+ "}

FORM
    v_site1     LABEL "地点"      COLON 20  v_site2  LABEL "To" COLON 55
    v_sch_date1 LABEL "需求日期"  COLON 20  v_sch_date2 LABEL "To" COLON 55
   WITH FRAME  a SIDE-LABELS WIDTH 80 ATTR-SPACE NO-BOX THREE-D.

REPEAT:

    IF v_site1 = hi_char THEN v_site1 = "".
    IF v_sch_date1 = hi_date THEN v_sch_date1 = low_date.

UPDATE v_site1 v_site2 v_sch_date1 v_sch_date2 WITH FRAME a.

    IF v_site2 = "" THEN v_site2 = hi_char.
    IF v_sch_date2 = low_date THEN v_sch_date2 = hi_date.



FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath1' NO-LOCK NO-ERROR.
mfile  = "SQ02\SQ02_" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME,"999999") + ".txt".


OUTPUT TO VALUE(CODE_value + mfile) CONVERT TARGET "UTF-8" SOURCE 'GB2312'.


FOR EACH pod_det NO-LOCK WHERE pod_domain = "DCEC" and pod_site >= v_site1 AND pod_site <= v_site2,
    EACH po_mstr NO-LOCK WHERE po_domain = "DCEC" and  po_nbr = pod_nbr AND po_sched,
    EACH pt_mstr NO-LOCK WHERE pt_domain = "DCEC" and pt_part = pod_part,
    EACH IN_mstr NO-LOCK WHERE in_domain = "DCEC" and IN_site = pod_site AND IN_part = pod_part,
    EACH schd_det NO-LOCK WHERE schd_domain = "DCEC" and schd_type = 4 AND schd_rlse_id = pod_curr_rlse_id[1] AND schd_nbr = pod_nbr 
         AND schd_line = pod_line AND schd_discr_qty > 0 AND schd_date >= v_sch_date1 AND schd_date <= v_sch_date2:

    FIND FIRST  CODE_mstr WHERE code_domain = "DCEC" and CODE_fldname = "Keeper-Warehouse" AND CODE_value = IN__qadc01 NO-LOCK NO-ERROR.
    IF AVAIL CODE_mstr THEN v_warehouse = CODE_cmmt.
    ELSE DO:
        IF pod_site = "DCEC-B" THEN v_warehouse = "B01".
        IF pod_site = "DCEC-C" THEN v_warehouse = "C01".
    END.
    IF pod_site = "DCEC-SV" THEN v_warehouse = "V01".
    v_date_string = STRING(YEAR(schd_date),"9999") + "-" + STRING(MONTH(schd_date),"99") + "-" +  STRING(DAY(schd_date),"99").
    IF pod__chr01 = "MH" OR pod__chr01 = "LS" THEN v_3pl = "".
    ELSE v_3pl = pod__chr01.

    PUT UNFORMATTED UPPER(pod_site) "|".
    PUT UNFORMATTED UPPER(v_warehouse) "|".
    PUT UNFORMATTED UPPER(pod_nbr) "|".
    PUT UNFORMATTED pod_line "|".
    PUT UNFORMATTED UPPER(v_3pl) "|".
    PUT UNFORMATTED UPPER(po_vend) "|".
    PUT UNFORMATTED v_date_string "|".
    PUT UNFORMATTED UPPER(pod_part) "|".
    PUT UNFORMATTED UPPER(pt_desc2) "|".
    PUT UNFORMATTED UPPER(pt_desc1) "|".
    PUT UNFORMATTED schd_discr_qty SKIP.
END.
 

END.
QUIT.
