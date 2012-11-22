{mfdeclre.i}
DEFINE TEMP-TABLE xxwk
    FIELD vend LIKE prh_vend
    FIELD reqnbr AS CHAR FORMAT "X(20)"
    FIELD rec_id LIKE prh_receiver
    FIELD rec_ln LIKE prh_line
    FIELD part LIKE pt_part
    FIELD desc1 LIKE pt_desc1
    FIELD desc2 LIKE pt_desc2
    FIELD v_date LIKE vph_inv_date
    FIELD v_pay_date LIKE vph_inv_date
    FIELD v_status AS CHAR.

DEFINE VAR v_inv_date_str AS CHAR.
DEFINE VAR v_date_per_str AS CHAR.


DEFINE VAR mfile  AS CHAR.
FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = 'srmpath1' NO-LOCK NO-ERROR.
mfile  = "SQ10\SQ10_" + STRING(YEAR(TODAY),"9999") + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99") + STRING(TIME,"999999") + ".txt".

OUTPUT TO VALUE(CODE_value + mfile) CONVERT TARGET "UTF-8" SOURCE 'GB2312'.




/*
FOR EACH prh_hist WHERE prh_domain = global_domain and prh_rcp_date >= TODAY - 1  AND prh_rcp_date <= TODAY - 1.
    FIND FIRST pvo_mstr WHERE pvo_domain = global_domain and pvo_internal_ref = prh_receiver AND pvo_line = prh_line AND pvo_internal_ref_type="07" NO-LOCK NO-ERROR.
    FIND FIRST vph_hist WHERE vph_domain = global_domain and vph_pvo_id = pvo_id NO-LOCK NO-ERROR.
    FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = prh_part NO-LOCK NO-ERROR.
    IF AVAIL pvo_mstr AND AVAIL vph_hist AND AVAIL pt_mstr THEN DO:
        IF vph_inv_date = ? THEN v_inv_date_str = "".
        ELSE v_inv_date_str = STRING(YEAR(vph_inv_date),"9999") + "-" + STRING(MONTH(vph_inv_date),"99") + "-" +  STRING(DAY(vph_inv_date),"99").

        IF prh_per_date = ? THEN v_date_per_str = "".
        ELSE v_date_per_str = STRING(YEAR(prh_per_date),"9999") + "-" + STRING(MONTH(prh_per_date),"99") + "-" +  STRING(DAY(prh_per_date),"99").

        PUT UNFORMATTED UPPER(prh_vend) "|".
        PUT UNFORMATTED UPPER (prh_nbr)"|".
        PUT UNFORMATTED UPPER(prh_receiver) "|".
        PUT UNFORMATTED prh_line "|".
        PUT UNFORMATTED UPPER(pt_part) "|".
        PUT UNFORMATTED UPPER(pt_desc2) "|".
        PUT UNFORMATTED UPPER(pt_desc1) "|".
        PUT UNFORMATTED  v_inv_date_str "|".
        PUT UNFORMATTED v_date_per_str "|".
        PUT UNFORMATTED "1" SKIP.


    END.

END.
QUIT.*/




FOR EACH pvo_mstr NO-LOCK WHERE pvo_domain = global_domain and pvo_trans_date >= TODAY - 1 AND pvo_trans_date <= TODAY - 1.
    FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = pvo_part NO-LOCK NO-ERROR.
    IF pvo_eff_date = ? THEN v_inv_date_str = "".
    ELSE v_inv_date_str = STRING(YEAR(pvo_eff_date),"9999") + "-" + STRING(MONTH(pvo_eff_date),"99") + "-" +  STRING(DAY(pvo_eff_date),"99").

    IF pvo_trans_date = ? THEN  v_date_per_str = "".
    ELSE v_date_per_str = STRING(YEAR(pvo_trans_date),"9999") + "-" + STRING(MONTH(pvo_trans_date),"99") + "-" +  STRING(DAY(pvo_trans_date),"99").


    IF AVAIL pt_mstr THEN DO:
        PUT UNFORMATTED UPPER(pvo_supplier) "|".
        PUT UNFORMATTED UPPER (pvo_order)"|".
        PUT UNFORMATTED UPPER(pvo_internal_ref) "|".
        PUT UNFORMATTED pvo_line "|".
        PUT UNFORMATTED UPPER(pvo_part) "|".
        PUT UNFORMATTED UPPER(pt_desc2) "|".
        PUT UNFORMATTED UPPER(pt_desc1) "|".
        PUT UNFORMATTED v_inv_date_str "|".
        PUT UNFORMATTED  v_date_per_str "|".
        PUT UNFORMATTED "1" SKIP.
    END.
    
   

END.
QUIT.



