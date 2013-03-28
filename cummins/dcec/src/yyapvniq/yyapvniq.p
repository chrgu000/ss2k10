/**
 @File: yyapvniq.p
 @Description: AP对帐单
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: AP对帐单
 @Todo:
 @History:
**/

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121112.1"}
{cxcustom.i "YYAPVNIQ.P"}

{yyapvdef.i NEW}
DEFINE VARIABLE startdt LIKE ap_date .
DEFINE VARIABLE enddt LIKE ap_date .
DEFINE VARIABLE startamt LIKE ap_base_amt .
DEFINE VARIABLE endamt LIKE ap_base_amt .
DEFINE VARIABLE amt6 LIKE ap_base_amt .
DEFINE VARIABLE amt0 LIKE ap_base_amt .
DEFINE VARIABLE note AS CHAR FORMAT "x(30)" .
DEFINE VARIABLE baseamt LIKE ckd_amt .
DEFINE VARIABLE amt1 LIKE ap_base_amt .
DEFINE VARIABLE due_date LIKE vo_due_date.
DEFINE VARIABLE invoice LIKE vo_invoice.
DEFINE VARIABLE vconf as character format "x(8)".

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
    bh COLON 20 bh1 COLON 48 LABEL {t001.i}
    dt COLON 20 dt1 COLON 48 LABEL {t001.i}
    vd COLON 20 vd1 COLON 48 LABEL {t001.i}
    efdt COLON 20 efdt1 COLON 48 LABEL {t001.i} SKIP(1)
    base_rpt COLON 20 SKIP(1)
with frame a width 80 side-labels no-underline no-attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    IF bh1 = hi_char THEN bh1 = "" .
    IF dt = low_date THEN dt = ? .
    IF dt1 = hi_date THEN dt1 = ? .
    IF vd1 = hi_char THEN vd1 = "" .
    IF efdt = low_date THEN efdt = ? .
    IF efdt1 = hi_date THEN efdt1 = ? .

    UPDATE bh bh1 dt dt1 vd vd1 efdt efdt1
        base_rpt VALIDATE(CAN-FIND(cu_mstr WHERE
                          cu_curr = base_rpt) OR base_rpt = "","货币不存在!")
        WITH FRAME a .

    IF bh1 = "" THEN bh1 = hi_char .
    IF dt = ? THEN dt = low_date .
    IF dt1 = ? THEN dt1 = hi_date .
    IF vd1 = "" THEN vd1 = hi_char .
    IF efdt = ? THEN efdt = low_date .
    IF efdt1 = ? THEN efdt1 = hi_date .

    {mfselprt.i "printer" 132}

    FOR EACH vd_mstr NO-LOCK WHERE vd_domain = global_domain and
             vd_addr >= vd AND vd_addr <= vd1 :

        FOR EACH ap_mstr NO-LOCK WHERE ap_domain = global_domain and
                 ap_batch >= bh AND ap_batch <=bh1
            AND ap_date >= dt AND ap_date <= dt1
            AND ap_vend = vd_addr
            AND ap_effdate >= efdt AND ap_effdate <= efdt1
            AND (ap_curr = base_rpt OR base_rpt = "")
            BREAK BY ap_vend BY ap_effdate DESCENDING :

    /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
            ASSIGN vconf = "".
            IF FIRST-OF(ap_vend) THEN DO :
               {gprun.i ""yyapvn1.p"" "(input ap_vend,
                   OUTPUT startdt,
                   OUTPUT enddt,
                   OUTPUT startamt,
                   OUTPUT endamt)"
                }

                PUT "供应商"AT 2 "名称" AT 12 "开始日期" AT 42 "结束日期" AT 52 "期初金额" TO 82 "期末金额" TO 102 SKIP .

                FIND ad_mstr NO-LOCK WHERE ad_domain = global_domain
                                       and ad_addr = ap_vend NO-ERROR.
                PUT ap_vend AT 2 ad_name AT 12 startdt AT 42 enddt AT 52 startamt TO 82 endamt TO 102 SKIP.
                PUT "发票日期" AT 2 "生效日期" AT 12 "到期日期" at 22 "凭证号" at 31 "发票号" AT 41
                    "类型" AT 62  "货币金额" TO 80  "货币" AT 82 "确认人" to 105 "人民币金额" TO 124  "余额" TO 144
                    "三包" TO 164  "备注" AT 170  SKIP .

                amt0 = endamt .

            END.

            IF ap_type = "RV" THEN NEXT .

            amt1 = 0 .
            invoice = "".
            due_date = ?.
            IF ap_type = "VO" THEN DO :
                FIND vo_mstr WHERE vo_domain = global_domain
                               and vo_ref = ap_ref NO-LOCK .
                IF NOT vo_confirmed THEN NEXT .
                amt1 = ap_base_amt .
                due_date = vo_due_date.
                invoice = vo_invoice.
                /** vconf = VO__QAD01. */
                vconf = vo_conf_by.
            END.

            amt6 = 0 .
            note = "" .
            IF ap_type = "CK" THEN DO :
                FIND FIRST gltr_hist WHERE gltr_domain = global_domain
                       and gltr_doc_typ = ap_type
                      AND gltr_doc = ap_ref NO-ERROR.
                IF AVAILABLE gltr_hist THEN do:
                        vconf = gltr_user.
                end.
                FIND ck_mstr NO-LOCK WHERE ck_domain = global_domain and
                     ck_ref = ap_ref AND ck_status <> "void" NO-ERROR .
                IF NOT AVAILABLE ck_mstr THEN NEXT .
                FOR EACH ckd_det NO-LOCK WHERE ckd_domain = global_domain
                     and ckd_ref = ap_ref:
                    FIND vo_mstr NO-LOCK WHERE vo_domain = global_domain and
                         vo_ref = ckd_voucher NO-ERROR .
                    IF AVAILABLE vo_mstr THEN DO :
                        IF ckd_amt = 0 THEN baseamt = 0 .
                        ELSE DO :
                            IF vo_curr <> ck_curr THEN baseamt = ckd_cur_amt .
                            ELSE baseamt = ckd_amt .
                        END.
                        amt1 = amt1 - baseamt * vo_ex_rate2 / vo_ex_rate .
                    END.
                    ELSE DO :
                        amt1 = amt1 - ckd_amt * ap_ex_rate2 / ap_ex_rate .
                        amt6 = amt6 + ckd_amt * ap_ex_rate2 / ap_ex_rate .
                        note = ckd_acct + "." + note .
                    END.
                END.
            END.

            PUT ap_date AT 2
                ap_effdate AT 12
                due_date  AT 22
                ap_ref AT 31
                invoice  AT 41
                ap_type AT 62
                ap_amt TO 80
                ap_curr AT 82
                vconf to 105
                amt1 TO 124
                amt0 TO 144 .

            IF amt6 <> 0 THEN PUT amt6 TO 164
                                  note AT 170 SKIP .
            ELSE PUT SKIP .

            amt0 = amt0 - amt1 - amt6 .

            IF ap_type = "VO" THEN DO :
                FIND CODE_mstr NO-LOCK WHERE code_domain = global_domain and
                     CODE_fldname = ("ap_adjust" + ap_vend) AND CODE_value = ap_ref NO-ERROR .
                IF AVAILABLE CODE_mstr THEN DO :
                    PUT ap_ref AT 22
                        "CK" AT 34
                        DEC(CODE_cmmt) FORMAT "->,>>>,>>>,>>9.99" TO 54
                        "RMB" AT 56
                        DEC(CODE_cmmt) FORMAT "->,>>>,>>>,>>9.99" TO 79
                        amt0 TO 99
                        "付款调整" AT 121 SKIP .
                    amt0 = amt0 - DEC(CODE_cmmt) .
                END.
            END.

            IF LAST-OF(ap_vend) THEN PUT SKIP(3) .

       END. /*for each ap_mstr*/

   END. /*for each vd_mstr*/

   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
