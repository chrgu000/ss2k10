{mfdeclre.i}
DEFINE VAR v_snp LIKE ptp_ord_mult.
DEFINE VAR mfile  AS CHAR.
FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = 'srmpath1' NO-LOCK NO-ERROR.
mfile  = "SQ11\SQ11_" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME,"999999") + ".txt".

OUTPUT TO VALUE(CODE_value + mfile) CONVERT TARGET "UTF-8" SOURCE 'GB2312'.

FOR EACH pt_mstr NO-LOCK.
    FIND FIRST ptp_det WHERE ptp_domain = global_domain and ptp_part = pt_part AND (ptp_site = "DCEC-B" OR ptp_site = "DCEC-C") NO-LOCK NO-ERROR.
    IF AVAIL ptp_det THEN v_snp = ptp_ord_mult.
    ELSE v_snp = 1.
    IF v_snp = 0 THEN v_snp = 1.
    FOR EACH pod_det WHERE pod_domain = global_domain and pod_part = pt_part AND pod_site = ptp_site /*AND pod_schd = YES*/ NO-LOCK.
        IF pod_ord_mult > 1 THEN v_snp = pod_ord_mult.
        FIND FIRST po_mstr WHERE po_domain = global_domain and po_nbr = pod_nbr NO-LOCK NO-ERROR.
        IF AVAIL po_mstr THEN DO:
            PUT UNFORMATTED UPPER(pt_part) "|".
            PUT UNFORMATTED UPPER (pt_desc2)"|".
            PUT UNFORMATTED UPPER (pt_desc1)"|".
            PUT UNFORMATTED UPPER (po_vend)"|".
            PUT UNFORMATTED v_snp SKIP.
        END.

    END.
END.
QUIT.



