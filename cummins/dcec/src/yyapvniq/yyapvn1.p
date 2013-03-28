/**
 @File: yyapvn1.p
 @Description: 计算供应商余额
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 计算供应商余额
 @Todo:
 @History:
**/

DEF INPUT PARAMETER vend LIKE ap_vend .
DEF OUTPUT PARAMETER startdt AS DATE .
DEF OUTPUT PARAMETER enddt AS DATE .
DEF OUTPUT PARAMETER startamt AS DEC .
DEF OUTPUT PARAMETER endamt AS DEC .

{mfdeclre.i}
{yyapvdef.i}

DEF VAR peramt AS DEC .
DEF VAR baseamt LIKE ckd_amt .
DEF VAR amt0 LIKE ckd_amt .

FIND FIRST ap_mstr NO-LOCK WHERE ap_domain = global_domain and
           ap_batch >= bh AND ap_batch <=bh1
    AND ap_date >= dt AND ap_date <= dt1
    AND ap_vend = vend
    AND ap_effdate >= efdt AND ap_effdate <= efdt1
    AND (ap_curr = base_rpt OR base_rpt = "") NO-ERROR .

IF AVAILABLE ap_mstr THEN startdt = ap_effdate .

FIND LAST ap_mstr NO-LOCK WHERE ap_domain = global_domain and
          ap_batch >= bh AND ap_batch <=bh1
    AND ap_date >= dt AND ap_date <= dt1
    AND ap_vend = vend
    AND ap_effdate >= efdt AND ap_effdate <= efdt1
    AND (ap_curr = base_rpt OR base_rpt = "") NO-ERROR .

IF AVAILABLE ap_mstr THEN enddt = ap_effdate .

peramt = 0 .
FOR EACH ap_mstr NO-LOCK WHERE ap_domain = global_domain and
         ap_batch >= bh AND ap_batch <=bh1
    AND ap_date >= dt AND ap_date <= dt1
    AND ap_vend = vend
    AND ap_effdate >= efdt AND ap_effdate <= efdt1
    AND (ap_curr = base_rpt OR base_rpt = "") :

    IF ap_type = "RV" THEN NEXT .

    amt0 = 0 .

    IF ap_type = "VO" THEN DO :
        FIND vo_mstr WHERE vo_domain = global_domain and
             vo_ref = ap_ref NO-LOCK .
        IF NOT vo_confirmed THEN NEXT .
        amt0 = ap_base_amt .
        FIND CODE_mstr NO-LOCK WHERE code_domain = global_domain and
             CODE_fldname = ("ap_adjust" + ap_vend) AND CODE_value = ap_ref NO-ERROR .
        IF AVAILABLE CODE_mstr THEN amt0 = amt0 + DEC(CODE_cmmt) .
    END.

    IF ap_type = "CK" THEN DO :
        FIND ck_mstr NO-LOCK WHERE ck_domain = global_domain and
             ck_ref = ap_ref AND ck_status <> "void" NO-ERROR .
        IF NOT AVAILABLE ck_mstr THEN NEXT .
        FOR EACH ckd_det NO-LOCK WHERE ckd_domain = global_domain and
                 ckd_ref = ap_ref :
            FIND vo_mstr NO-LOCK WHERE vo_domain = global_domain and
                 vo_ref = ckd_voucher NO-ERROR .
            IF AVAILABLE vo_mstr THEN DO :
                IF ckd_amt = 0 THEN baseamt = 0 .
                ELSE DO :
                    IF ck_curr <> vo_curr THEN baseamt = ckd_cur_amt .
                    ELSE baseamt = ckd_amt .
                END.
                amt0 = amt0 - baseamt * vo_ex_rate2 / vo_ex_rate .
            END.
        END.
    END.

    peramt = peramt + amt0 .

END.

endamt = 0 .
FOR EACH ap_mstr NO-LOCK WHERE ap_domain = global_domain and ap_batch <=bh1
    AND ap_date <= dt1
    AND ap_vend = vend
    AND ap_effdate <= efdt1
    AND (ap_curr = base_rpt OR base_rpt = "") :

    IF ap_type = "RV" THEN NEXT .

    amt0 = 0 .

    IF ap_type = "VO" THEN DO :
        FIND vo_mstr WHERE vo_domain = global_domain and
             vo_ref = ap_ref NO-LOCK .
        IF NOT vo_confirmed THEN NEXT .
        amt0 = ap_base_amt .
        FIND CODE_mstr NO-LOCK WHERE code_domain = global_domain and
             CODE_fldname = ("ap_adjust" + ap_vend) AND CODE_value = ap_ref NO-ERROR .
        IF AVAILABLE CODE_mstr THEN amt0 = amt0 + DEC(CODE_cmmt) .
    END.

    IF ap_type = "CK" THEN DO :
        FIND ck_mstr NO-LOCK WHERE ck_domain = global_domain and
             ck_ref = ap_ref AND ck_status <> "void" NO-ERROR .
        IF NOT AVAILABLE ck_mstr THEN NEXT .
        FOR EACH ckd_det NO-LOCK WHERE ckd_domain = global_domain and
                 ckd_ref = ap_ref :
            FIND vo_mstr NO-LOCK WHERE vo_domain = global_domain and
                 vo_ref = ckd_voucher NO-ERROR .
            IF AVAILABLE vo_mstr THEN DO :
                IF ckd_amt = 0 THEN baseamt = 0 .
                ELSE DO :
                    IF ck_curr <> vo_curr THEN baseamt = ckd_cur_amt .
                    ELSE baseamt = ckd_amt .
                END.
                amt0 = amt0 - baseamt * vo_ex_rate2 / vo_ex_rate .
            END.
        END.
    END.

    endamt = endamt + amt0 .

END.

startamt = endamt - peramt .
