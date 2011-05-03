/* a6gllim1.p - 类别维护                      */
/* BY: Micho Yang          DATE: 04/23/08  ECO: *SS - 20080423.1* */

/* DISPLAY TITLE */
{mfdtitle.i "M1 "}

define variable acc like ac_code NO-UNDO  .
define variable acc1 like ac_code NO-UNDO .
define variable sub like sb_sub no-undo.
define variable sub1 like sb_sub no-undo.
define variable ctr like cc_ctr no-undo.
define variable ctr1 like cc_ctr no-undo.
DEFINE VARIABLE effdate LIKE glt_effdate NO-UNDO.
DEFINE VARIABLE effdate1 LIKE glt_effdate NO-UNDO.
define variable ctrflag AS LOGICAL INIT NO NO-UNDO .
DEFINE VARIABLE subflag AS logical INIT NO NO-UNDO .
DEFINE VARIABLE vcurr AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE inclflag AS LOGICAL INIT YES NO-UNDO.
DEFINE VARIABLE inclpost AS LOGICAL INIT NO NO-UNDO.

FORM
    acc     COLON 25 acc1 COLON 50 LABEL {t001.i}
    sub     COLON 25 sub1 COLON 50 LABEL {t001.i}
    ctr     COLON 25 ctr1 COLON 50 LABEL {t001.i}
    effdate COLON 25 effdate1 COLON 50 LABEL {t001.i}
    subflag COLON 25 LABEL "汇总分帐户"
    ctrflag COLON 25 LABEL "汇总成本中心"
    vcurr   COLON 25 LABEL "原币(Y)/本位币(N)"
    inclflag COLON 25 LABEL "只输出有发生额的科目" 
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
    if sub1 = hi_char then assign sub1 = "".
    if ctr1 = hi_char then assign ctr1 = "".

    if c-application-mode <> 'web' then
    update 
        acc acc1
        sub sub1 
        ctr ctr1
        effdate effdate1
        subflag
        ctrflag
        vcurr
        inclflag
        inclpost
       with frame a.

    {wbrp06.i &command = update &fields = " 
        acc acc1
        sub sub1 
        ctr ctr1
        effdate effdate1
        subflag
        ctrflag
        vcurr
        inclflag
        inclpost 
    " &frm = "a"}

    if (c-application-mode <> 'web') or
    (c-application-mode = 'web' and
    (c-web-request begins 'data')) then do:
        /* CREATE BATCH INPUT STRING */
        assign bcdparm = "".
        {mfquoter.i acc       }
        {mfquoter.i acc1      }
        {mfquoter.i sub      }
        {mfquoter.i sub1     }
        {mfquoter.i ctr          }
        {mfquoter.i ctr1          }
        {mfquoter.i effdate       }
        {mfquoter.i effdate1      }
        {mfquoter.i subflag      }
        {mfquoter.i ctrflag     }
        {mfquoter.i vcurr          }
        {mfquoter.i inclflag          }
        {mfquoter.i inclpost          }

        if acc1     = ""    then assign acc1 = hi_char.
        if sub1     = ""    then assign sub1 = hi_char.
        if ctr1     = ""    then assign ctr1 = hi_char.
        IF effdate1 = ?     THEN ASSIGN effdate1 = TODAY .
    end.  /* if (c-application-mode <> 'web') ... */

    IF NOT ((subflag = NO AND ctrflag = NO ) OR 
        (subflag = NO AND ctrflag = YES ) OR
        (subflag = YES AND ctrflag = YES )) THEN DO:
        MESSAGE "错误: 汇总组合无效" .
        NEXT-PROMPT subflag WITH FRAME a.
        UNDO,RETRY .
    END.

    /* SELECT PRINTER */
    {mfselbpr.i "printer" 132}

    /* main programmer */
    {a6glrp58.i}

    {a6mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
