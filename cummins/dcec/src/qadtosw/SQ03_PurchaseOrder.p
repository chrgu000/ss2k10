{mfdeclre.i}
DEFINE VAR mfile  AS CHAR.
DEFINE VAR mfile1 AS CHAR.
DEFINE VAR v_warehouse LIKE CODE_cmmt INITIAL "B01".
DEFINE VAR v_date_string AS CHAR.




FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = 'srmpath1' NO-LOCK NO-ERROR.
mfile  = "SQ03\SQ03_" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME,"999999") + ".txt".


OUTPUT TO VALUE(CODE_value + mfile) CONVERT TARGET "UTF-8" SOURCE 'GB2312'.


FOR EACH pod_det NO-LOCK WHERE pod_domain = global_domain and (pod_site >= "DCEC-B" AND pod_site <= "DCEC-C" OR pod_site = "DCEC-SV") AND pod_status <> "C" ,
    EACH po_mstr NO-LOCK WHERE po_domain = global_domain and po_nbr = pod_nbr AND po_sched = NO,
    EACH pt_mstr NO-LOCK WHERE pt_domain = global_domain and pt_part = pod_part,
    EACH IN_mstr NO-LOCK WHERE in_domain = global_domain and IN_site = pod_site AND IN_part = pod_part: 

    FIND FIRST  CODE_mstr WHERE code_domain = global_domain and CODE_fldname = "Keeper-Warehouse" AND CODE_value = IN__qadc01 NO-LOCK NO-ERROR.
    IF AVAIL CODE_mstr THEN v_warehouse = CODE_cmmt.
    ELSE DO:
        IF pod_site = "DCEC-B" THEN v_warehouse = "B01".
        IF pod_site = "DCEC-C" THEN v_warehouse = "C01".
    END.
    IF pod_site = "DCEC-SV" THEN v_warehouse = "V01".

   v_date_string = STRING(YEAR(pod_due_date),"9999") + "-" + STRING(MONTH(pod_due_date),"99") + "-" +  STRING(DAY(pod_due_date),"99").

    PUT UNFORMATTED UPPER(pod_nbr) "|".
    PUT UNFORMATTED pod_line "|".
    PUT UNFORMATTED UPPER(pod_site) "|".
    PUT UNFORMATTED UPPER(v_warehouse) "|".
    PUT UNFORMATTED UPPER(pod__chr01) "|".
    PUT UNFORMATTED UPPER(po_vend) "|".
    PUT UNFORMATTED v_date_string "|".
    PUT UNFORMATTED UPPER(pod_part) "|".
    PUT UNFORMATTED UPPER(pt_desc2) "|".
    PUT UNFORMATTED UPPER(pt_desc1) "|".
    PUT UNFORMATTED pod_qty_ord  "|" .
    PUT UNFORMATTED UPPER(pod_status) SKIP.
END.
QUIT.
