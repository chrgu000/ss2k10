/**
 @File: yyapadj.p
 @Description: 应付计算方式差额调整
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 应付计算方式差额调整
 @Todo: 
 @History: 
**/
{mfdtitle.i "121001.1"}

DEF VAR baseamt LIKE ckd_amt .
DEF VAR amt1 LIKE vo_base_applied LABEL "支付金额".
DEF VAR vend LIKE ap_vend .
DEF VAR yn AS LOG .

DEF TEMP-TABLE xx 
    FIELD xx_ref LIKE vo_ref 
    FIELD xx_amt LIKE vo_base_applied .


UPDATE vend WITH FRAME a SIDE-LABELS THREE-D .

{mfselprt.i "printer" 132}  

FOR EACH xx :
    DELETE xx .
END.

FOR EACH ap_mstr NO-LOCK WHERE ap_domain = global_domain and ap_mstr.ap_vend = vend AND ap_mstr.ap_type = "vo" :

    FIND vo_mstr NO-LOCK WHERE vo_domain = global_domain and vo_ref = ap_ref AND vo_confirmed NO-ERROR .
    IF NOT AVAILABLE vo_mstr THEN NEXT .
  
    amt1 = 0 .
    FOR EACH ckd_det NO-LOCK WHERE ckd_domain = global_domain and ckd_voucher = vo_ref USE-INDEX ckd_voucher :
        FIND ck_mstr NO-LOCK WHERE ck_domain = global_domain and ck_ref = ckd_ref AND ck_status <> "void" NO-ERROR .
        IF NOT AVAILABLE ck_mstr THEN NEXT .

        IF ckd_amt = 0 THEN baseamt = 0 .
        ELSE DO :
            IF vo_curr <> ck_curr THEN baseamt = ckd_cur_amt .
            ELSE baseamt = ckd_amt .
        END.

        amt1 = amt1 + (baseamt * vo_ex_rate2 / vo_ex_rate) .        

    END.

    IF vo_base_applied <> ROUND(amt1,2) THEN DO :
        CREATE xx .
        xx_ref = vo_ref .
        xx_amt = amt1 - vo_base_applied .
        DISPLAY vo_ref  vo_base_applied amt1 (amt1 - vo_base_applied ) LABEL "差异" FORMAT "->,>>>,>>>,>>9.99" WITH WIDTH 80 STREAM-IO FRAME b .
        setframelabels(FRAME b:HANDLE) .
    END.

    
END.

{mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

MESSAGE "现在标记差异吗？" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE yn .
IF yn THEN DO TRANSACTION ON ERROR UNDO, LEAVE :
    FOR EACH CODE_mstr WHERE code_domain = global_domain and CODE_fldname = "ap_adjust" + vend :
        DELETE CODE_mstr .
    END.
    FOR EACH xx :
        CREATE CODE_mstr . code_domain = global_domain.
        CODE_fldname = "ap_adjust" + vend .
        CODE_value = xx_ref .
        CODE_cmmt = STRING(xx_amt) .
    END.
END.
