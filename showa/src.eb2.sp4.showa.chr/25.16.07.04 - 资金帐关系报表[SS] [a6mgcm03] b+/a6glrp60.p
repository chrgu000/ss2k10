/* a6glrp59.p - 类别维护总分类科目发生额对照表                      */
/* BY: Micho Yang          DATE: 04/23/08  ECO: *SS - 20080423.1* */

/* DISPLAY TITLE */
{mfdtitle.i "M+ "}

define variable vacct1 like ac_code NO-UNDO  .
define variable vacct2 like ac_code NO-UNDO .
define variable ctr like ac_code NO-UNDO  .
define variable ctr1 like ac_code NO-UNDO .
DEFINE VARIABLE effdate LIKE glt_effdate NO-UNDO.
DEFINE VARIABLE effdate1 LIKE glt_effdate NO-UNDO.
DEFINE VARIABLE inclpost AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE entity LIKE en_entity .

FORM
    entity  COLON 25 LABEL "会计单位"
    SKIP(1)
    vacct1     COLON 25 LABEL "资金帐" vacct2 COLON 50 LABEL {t001.i}
    ctr     COLON 25 LABEL "成本中心" ctr1 COLON 50 LABEL {t001.i}
    effdate COLON 25 effdate1 COLON 50 LABEL {t001.i}
    SKIP(1)
    inclpost COLON 25 LABEL "模拟帐簿输出"
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

for first en_mstr fields (en_name en_entity)
    no-lock where en_entity = current_entity: end.
if not available en_mstr then do:
{mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
if c-application-mode <> 'web' then
    pause.
    leave.
end.
else do:
    release en_mstr.
end.
entity = CURRENT_entity .

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
    if vacct2 = hi_char then assign vacct2 = "".
    if ctr1 = hi_char then assign ctr1 = "".

    if c-application-mode <> 'web' then
    update 
        entity
        vacct1 vacct2
        ctr ctr1
        effdate effdate1
        inclpost
       with frame a.

    {wbrp06.i &command = update &fields = " 
        entity
        vacct1 vacct2
        ctr ctr1
        effdate effdate1
        inclpost
            " &frm = "a"}

    if (c-application-mode <> 'web') or
    (c-application-mode = 'web' and
    (c-web-request begins 'data')) then do:
        /* CREATE BATCH INPUT STRING */
        assign bcdparm = "".
        {mfquoter.i entity       }
        {mfquoter.i vacct1       }
        {mfquoter.i vacct2      }
        {mfquoter.i ctr       }
        {mfquoter.i ctr1      }
        {mfquoter.i effdate       }
        {mfquoter.i effdate1      }
        {mfquoter.i inclpost          }

        if vacct2     = ""    then assign vacct2 = hi_char.
        if ctr1     = ""    then assign ctr1 = hi_char.
        IF effdate1 = ?     THEN ASSIGN effdate1 = TODAY .
    end.  /* if (c-application-mode <> 'web') ... */

    /* SELECT PRINTER */
    {mfselbpr.i "printer" 132}

    /* main programmer */
    {a6glrp60.i}

    {a6mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
