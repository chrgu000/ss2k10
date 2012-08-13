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

{mfdtitle.i "2+ "}
{cxcustom.i "YYAPVNIQ.P"}

{yyapvdef.i NEW}
DEF VAR startdt LIKE ap_date .
DEF VAR enddt LIKE ap_date .
DEF VAR startamt LIKE ap_base_amt .
DEF VAR endamt LIKE ap_base_amt .
DEF VAR amt6 LIKE ap_base_amt .
DEF VAR amt0 LIKE ap_base_amt .
DEF VAR note AS CHAR FORMAT "x(30)" .
DEF VAR baseamt LIKE ckd_amt .
DEF VAR amt1 LIKE ap_base_amt .
DEF VAR due_date LIKE vo_due_date.
DEF VAR invoice LIKE vo_invoice.

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
        base_rpt VALIDATE(CAN-FIND(cu_mstr WHERE cu_curr = base_rpt) OR base_rpt = "","货币不存在!")
        WITH FRAME a .

    IF bh1 = "" THEN bh1 = hi_char .
    IF dt = ? THEN dt = low_date .
    IF dt1 = ? THEN dt1 = hi_date .
    IF vd1 = "" THEN vd1 = hi_char .
    IF efdt = ? THEN efdt = low_date .
    IF efdt1 = ? THEN efdt1 = hi_date .

    {mfselprt.i "printer" 132}  

    FOR EACH vd_mstr NO-LOCK WHERE vd_addr >= vd AND vd_addr <= vd1 :

        FOR EACH ap_mstr NO-LOCK WHERE ap_batch >= bh AND ap_batch <=bh1
            AND ap_date >= dt AND ap_date <= dt1
            AND ap_vend = vd_addr
            AND ap_effdate >= efdt AND ap_effdate <= efdt1
            AND (ap_curr = base_rpt OR base_rpt = "")
            BREAK BY ap_vend BY ap_effdate DESCENDING :

    /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

            IF FIRST-OF(ap_vend) THEN DO :
               {gprun.i ""yyapvn1.p"" "(input ap_vend,
                   OUTPUT startdt,
                   OUTPUT enddt,
                   OUTPUT startamt,
                   OUTPUT endamt)"
                }   

                PUT "供应商"AT 2 "名称" AT 12 "开始日期" AT 42 "结束日期" AT 52 "期初金额" TO 82 "期末金额" TO 102 SKIP .

                FIND ad_mstr NO-LOCK WHERE ad_addr = ap_vend NO-ERROR .

                PUT ap_vend AT 2 ad_name AT 12 startdt AT 42 enddt AT 52 startamt TO 82 endamt TO 102 SKIP .     

              PUT "发票日期" AT 2 "生效日期" AT 12 "到期日期" at 22 "凭证号" at 31 "发票号" AT 41
		              "类型" AT 62  "货币金额" TO 80  "货币" AT 82 "人民币金额" TO 105  "余额" TO 125 
                       "三包" TO 145  "备注" AT 150  SKIP .
                  
                amt0 = endamt .

            END.

            IF ap_type = "RV" THEN NEXT .

            amt1 = 0 .
            invoice = "".
            due_date = ?.
            IF ap_type = "VO" THEN DO :
                FIND vo_mstr WHERE vo_ref = ap_ref NO-LOCK .
                IF NOT vo_confirmed THEN NEXT .
                amt1 = ap_base_amt .
                due_date = vo_due_date.
                invoice = vo_invoice.
            END.

            amt6 = 0 .
            note = "" .
            IF ap_type = "CK" THEN DO :
                FIND ck_mstr NO-LOCK WHERE ck_ref = ap_ref AND ck_status <> "void" NO-ERROR .
                IF NOT AVAILABLE ck_mstr THEN NEXT .
                FOR EACH ckd_det NO-LOCK WHERE ckd_ref = ap_ref :
                    FIND vo_mstr NO-LOCK WHERE vo_ref = ckd_voucher NO-ERROR .
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
                amt1 TO 105
                amt0 TO 125 .

            IF amt6 <> 0 THEN PUT amt6 TO 145 
                                  note AT 150 SKIP .
            ELSE PUT SKIP .

            amt0 = amt0 - amt1 - amt6 .

            IF ap_type = "VO" THEN DO :
                FIND CODE_mstr NO-LOCK WHERE CODE_fldname = ("ap_adjust" + ap_vend) AND CODE_value = ap_ref NO-ERROR .
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

