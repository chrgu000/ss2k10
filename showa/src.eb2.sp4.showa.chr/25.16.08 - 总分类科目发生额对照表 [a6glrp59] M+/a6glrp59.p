/* a6glrp59.p - 类别维护总分类科目发生额对照表                      */
/* BY: Micho Yang          DATE: 04/23/08  ECO: *SS - 20080423.1* */

/* DISPLAY TITLE */
{mfdtitle.i "M+ "}

define variable acc like ac_code NO-UNDO  .
define variable acc1 like ac_code NO-UNDO .
DEFINE VARIABLE effdate LIKE glt_effdate NO-UNDO.
DEFINE VARIABLE effdate1 LIKE glt_effdate NO-UNDO.
define variable vlevel AS INTEGER INIT 1 NO-UNDO.
DEFINE VARIABLE inclpost AS LOGICAL INIT NO NO-UNDO.

DEF BUFFER acmstr FOR ac_mstr.
DEF VAR v_dispdate AS CHAR .

DEF VAR v_beg_amt LIKE gltr_amt.
DEF VAR v_beg_curramt LIKE gltr_amt.
DEF VAR v_dr_amt LIKE gltr_amt.
DEF VAR v_cr_amt LIKE gltr_amt.
DEF VAR v_dr_curramt LIKE gltr_amt.
DEF VAR v_cr_curramt LIKE gltr_amt.
DEF VAR v_y_dr_amt LIKE gltr_amt.
DEF VAR v_y_cr_amt LIKE gltr_amt.
DEF VAR v_y_dr_curramt LIKE gltr_amt.
DEF VAR v_y_cr_curramt LIKE gltr_amt.

DEF VAR v1_beg_amt LIKE gltr_amt.
DEF VAR v1_beg_curramt LIKE gltr_amt.
DEF VAR v1_dr_amt LIKE gltr_amt.
DEF VAR v1_cr_amt LIKE gltr_amt.
DEF VAR v1_dr_curramt LIKE gltr_amt.
DEF VAR v1_cr_curramt LIKE gltr_amt.
DEF VAR v1_y_dr_amt LIKE gltr_amt.
DEF VAR v1_y_cr_amt LIKE gltr_amt.
DEF VAR v1_y_dr_curramt LIKE gltr_amt.
DEF VAR v1_y_cr_curramt LIKE gltr_amt.

DEF VAR v2_beg_amt LIKE gltr_amt.
DEF VAR v2_beg_curramt LIKE gltr_amt.
DEF VAR v2_dr_amt LIKE gltr_amt.
DEF VAR v2_cr_amt LIKE gltr_amt.
DEF VAR v2_dr_curramt LIKE gltr_amt.
DEF VAR v2_cr_curramt LIKE gltr_amt.
DEF VAR v2_y_dr_amt LIKE gltr_amt.
DEF VAR v2_y_cr_amt LIKE gltr_amt.
DEF VAR v2_y_dr_curramt LIKE gltr_amt.
DEF VAR v2_y_cr_curramt LIKE gltr_amt.

DEF VAR v3_beg_amt LIKE gltr_amt.
DEF VAR v3_beg_curramt LIKE gltr_amt.
DEF VAR v3_dr_amt LIKE gltr_amt.
DEF VAR v3_cr_amt LIKE gltr_amt.
DEF VAR v3_dr_curramt LIKE gltr_amt.
DEF VAR v3_cr_curramt LIKE gltr_amt.
DEF VAR v3_y_dr_amt LIKE gltr_amt.
DEF VAR v3_y_cr_amt LIKE gltr_amt.
DEF VAR v3_y_dr_curramt LIKE gltr_amt.
DEF VAR v3_y_cr_curramt LIKE gltr_amt.

DEF VAR v_ac_desc LIKE ac_desc .
DEF VAR v_effdate LIKE gltr_eff_dt .

FORM
    acc     COLON 25 acc1 COLON 50 LABEL {t001.i}
    effdate COLON 25 effdate1 COLON 50 LABEL {t001.i}
    vlevel COLON 25 LABEL "层次" 
    SKIP(1)
    inclpost COLON 25 LABEL "模拟帐簿输出"
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* 取上月数据 */
IF MONTH(TODAY) = 1 THEN DO:
    effdate = DATE(12,1,YEAR(TODAY) - 1).
END.
ELSE DO:
    effdate = DATE(MONTH(TODAY) - 1,1,YEAR(TODAY)).
END.
effdate1 = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1.

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:

    /* INPUT OPTIONS */
    if acc1 = hi_char then assign acc1 = "".

    if c-application-mode <> 'web' then
    update 
        acc acc1
        effdate effdate1
        vlevel
        inclpost
       with frame a.

    {wbrp06.i &command = update &fields = " 
        acc acc1
        effdate effdate1
        vlevel
        inclpost 
    " &frm = "a"}

    if (c-application-mode <> 'web') or
    (c-application-mode = 'web' and
    (c-web-request begins 'data')) then do:
        /* CREATE BATCH INPUT STRING */
        assign bcdparm = "".
        {mfquoter.i acc       }
        {mfquoter.i acc1      }
        {mfquoter.i effdate       }
        {mfquoter.i effdate1      }
        {mfquoter.i vlevel          }
        {mfquoter.i inclpost          }

        if acc1     = ""    then assign acc1 = hi_char.
        IF effdate1 = ?     THEN ASSIGN effdate1 = TODAY .
    end.  /* if (c-application-mode <> 'web') ... */

    IF NOT (vlevel = 1 OR vlevel = 2 OR vlevel = 3) THEN DO:
        MESSAGE "错误: 只允许输入1,2,3层" .
        NEXT-PROMPT vlevel WITH FRAME a.
        UNDO,RETRY .
    END.

    /* SELECT PRINTER */
    {mfselbpr.i "printer" 132}

    /* main programmer */
    {a6glrp59.i}

    {a6mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
