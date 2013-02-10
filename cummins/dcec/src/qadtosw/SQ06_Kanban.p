{mfdeclre.i "new global"}
{mf1.i "new global"}
session:date-format = 'dmy'.
base_curr = "RMB".
IF global_userid = "" THEN global_userid = "MFG".
mfguser="".
global_user_lang = "ch".
global_user_lang_dir = "ch/".
global_domain = "DCEC".
global_db = "DCEC".
execname = "SQ06_Kanban".

DEFINE VAR mfile  AS CHAR.
DEFINE VAR mfile1 AS CHAR.

DEFINE VAR v_date_string AS CHAR.
DEFINE VAR v_qty LIKE tr_qty_loc.
DEFINE VAR v_3pl LIKE pod__chr01.

DEFINE VAR v_warehouse LIKE CODE_cmmt INITIAL "B01".




FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = 'srmpath1' NO-LOCK NO-ERROR.
mfile  = "SQ06\SQ06_" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME,"999999") + ".txt".


OUTPUT TO VALUE(CODE_value + mfile) CONVERT TARGET "UTF-8" SOURCE 'GB2312'.

FOR EACH ptp_det NO-LOCK WHERE ptp_domain = global_domain and ptp_site >= "DCEC-B" AND ptp_site <= "DCEC-C" AND ptp_run_seq1 = "KANBAN",
    EACH pt_mstr NO-LOCK WHERE pt_domain = global_domain and pt_part = ptp_part,
    EACH IN_mstr NO-LOCK WHERE in_domain = global_domain and IN_site = ptp_site AND IN_part = ptp_part,
    EACH pod_det NO-LOCK WHERE pod_domain = global_domain and pod_part = ptp_part AND pod_site = ptp_site,
    EACH po_mstr NO-LOCK WHERE po_domain = global_domain and po_nbr = pod_nbr AND po_sched,
    EACH tr_hist NO-LOCK WHERE tr_domain = global_domain and tr_part = ptp_part AND tr_site = ptp_site AND tr_type = "ISS-WO" AND tr_effdate >= TODAY - 1 BREAK BY tr_part:

    FIND FIRST  CODE_mstr WHERE code_domain = global_domain and CODE_fldname = "Keeper-Warehouse" AND CODE_value = IN__qadc01 NO-LOCK NO-ERROR.
    IF AVAIL CODE_mstr THEN v_warehouse = CODE_cmmt.
    ELSE DO:
        IF pod_site = "DCEC-B" THEN v_warehouse = "B01".
        IF pod_site = "DCEC-C" THEN v_warehouse = "C01".
    END.
    IF pod_site = "DCEC-SV" THEN v_warehouse = "V01".

    IF FIRST-OF(tr_part) THEN v_qty = 0.
    v_qty = v_qty + tr_qty_loc.
    IF LAST-OF(tr_part) THEN DO:
       IF pod__chr01 = "MH" OR pod__chr01 = "LS" THEN v_3pl = "".
       ELSE v_3pl = pod__chr01.
        PUT UNFORMATTED UPPER(ptp_site) "|".
        PUT UNFORMATTED UPPER(v_warehouse) "|".
        PUT UNFORMATTED UPPER(v_3pl) "|".
        PUT UNFORMATTED UPPER(po_vend) "|".
        PUT UNFORMATTED UPPER(pod_part) "|".
        PUT UNFORMATTED UPPER(pt_desc2) "|".
        PUT UNFORMATTED UPPER(pt_desc1) "|".
        PUT UNFORMATTED v_qty * -1 SKIP.
    END.

END.
QUIT.
