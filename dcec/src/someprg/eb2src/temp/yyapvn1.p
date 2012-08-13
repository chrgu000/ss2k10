DEF INPUT PARAMETER vend LIKE ap_vend .
DEF OUTPUT PARAMETER startdt AS DATE .
DEF OUTPUT PARAMETER enddt AS DATE .
DEF OUTPUT PARAMETER startamt AS DEC .
DEF OUTPUT PARAMETER endamt AS DEC .

{mfdeclre.i}
{yyapvdef.i}

DEF VAR peramt AS DEC .
DEF VAR amt6 AS DEC .

FIND FIRST ap_mstr NO-LOCK WHERE ap_batch >= bh AND ap_batch <=bh1
    AND ap_date >= dt AND ap_date <= dt1
    AND ap_vend = vend
    AND ap_effdate >= efdt AND ap_effdate <= efdt1
    AND (ap_curr = base_rpt OR base_rpt = "") NO-ERROR .

IF AVAILABLE ap_mstr THEN startdt = ap_effdate .

FIND LAST ap_mstr NO-LOCK WHERE ap_batch >= bh AND ap_batch <=bh1
    AND ap_date >= dt AND ap_date <= dt1
    AND ap_vend = vend
    AND ap_effdate >= efdt AND ap_effdate <= efdt1
    AND (ap_curr = base_rpt OR base_rpt = "") NO-ERROR .

IF AVAILABLE ap_mstr THEN enddt = ap_effdate .

peramt = 0 .
FOR EACH ap_mstr NO-LOCK WHERE ap_batch >= bh AND ap_batch <=bh1
    AND ap_date >= dt AND ap_date <= dt1
    AND ap_vend = vend
    AND ap_effdate >= efdt AND ap_effdate <= efdt1
    AND (ap_curr = base_rpt OR base_rpt = "") :

    IF ap_type = "RV" THEN NEXT .

    IF ap_type = "VO" THEN DO :
        FIND vo_mstr WHERE vo_ref = ap_ref NO-LOCK .
        IF NOT vo_confirmed THEN NEXT .
    END.

    amt6 = 0 .
    IF ap_type = "CK" THEN DO :
        FIND FIRST ckd_det NO-LOCK WHERE ckd_ref = ap_ref AND (ckd_acct = "6666666" OR ckd_acct = "9999999") NO-ERROR .
        IF AVAILABLE ckd_det THEN DO :
            IF ap_curr <> "rmb" THEN amt6 = ckd_amt * ap_ex_rate2 .
            ELSE amt6 = ckd_amt .
        END.
    END.

    peramt = peramt + ap_base_amt + amt6 .

END. 

endamt = 0 .
FOR EACH ap_mstr NO-LOCK WHERE ap_batch <=bh1
    AND ap_date <= dt1
    AND ap_vend = vend
    AND ap_effdate <= efdt1
    AND (ap_curr = base_rpt OR base_rpt = "") :

    IF ap_type = "RV" THEN NEXT .

    IF ap_type = "VO" THEN DO :
        FIND vo_mstr WHERE vo_ref = ap_ref NO-LOCK .
        IF NOT vo_confirmed THEN NEXT .
    END.

    amt6 = 0 .
    IF ap_type = "CK" THEN DO :
        FIND FIRST ckd_det NO-LOCK WHERE ckd_ref = ap_ref AND (ckd_acct = "6666666" OR ckd_acct = "9999999") NO-ERROR .
        IF AVAILABLE ckd_det THEN DO :
            IF ap_curr <> "rmb" THEN amt6 = ckd_amt * ap_ex_rate2 .
            ELSE amt6 = ckd_amt .
        END.
    END.

    endamt = endamt + ap_base_amt + amt6 .

END. 

startamt = endamt - peramt .






