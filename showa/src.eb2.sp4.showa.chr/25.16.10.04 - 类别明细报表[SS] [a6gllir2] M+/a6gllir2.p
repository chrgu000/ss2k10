/* a6glrp59.p - 类别维护总分类科目发生额对照表                      */
/* BY: Micho Yang          DATE: 04/23/08  ECO: *SS - 20080423.1* */

/* DISPLAY TITLE */
{mfdtitle.i "M+ "}

define variable key3_from like usrw_key3 NO-UNDO  .
define variable key3_to like usrw_key3 NO-UNDO  .
define variable key2_from like usrw_key3 NO-UNDO  .
define variable key2_to like usrw_key3 NO-UNDO  .
define variable key1_from like usrw_key3 NO-UNDO  .
define variable key1_to like usrw_key3 NO-UNDO  .
define variable ctr like cc_ctr NO-UNDO .
define variable ctr1 like cc_ctr NO-UNDO .
DEFINE VARIABLE effdate LIKE glt_effdate NO-UNDO.
DEFINE VARIABLE effdate1 LIKE glt_effdate NO-UNDO.
define variable vdesc AS CHAR FORMAT "x(48)" .
DEFINE VARIABLE inclpost AS LOGICAL INIT NO NO-UNDO.

FORM
    key3_from COLON 25 LABEL "项目" key3_to COLON 50 LABEL {t001.i}
    key2_from COLON 25 LABEL "项目" key2_to COLON 50 LABEL {t001.i}
    key1_from COLON 25 LABEL "项目" key1_to COLON 50 LABEL {t001.i}
    ctr     COLON 25 ctr1 COLON 50 LABEL {t001.i}
    effdate COLON 25 effdate1 COLON 50 LABEL {t001.i}
    vdesc   COLON 25 LABEL "摘要(模糊查询"
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
    IF key3_to = hi_char THEN ASSIGN key3_to = "" .
    IF key2_to = hi_char THEN ASSIGN key2_to = "" .
    IF key1_to = hi_char THEN ASSIGN key1_to = "" .
    if ctr1 = hi_char then assign ctr1 = "".

    if c-application-mode <> 'web' then
    update
        key3_from key3_to
        key2_from key2_to
        key1_from key1_to
        ctr ctr1
        effdate effdate1
        vdesc
        inclpost
       with frame a.

    {wbrp06.i &command = update &fields = " 
        key3_from key3_to
        key2_from key2_to
        key1_from key1_to
        ctr ctr1
        effdate effdate1
        vdesc
        inclpost 
    " &frm = "a"}

    if (c-application-mode <> 'web') or
    (c-application-mode = 'web' and
    (c-web-request begins 'data')) then do:
        /* CREATE BATCH INPUT STRING */
        assign bcdparm = "".
        {mfquoter.i key3_from       }
        {mfquoter.i key3_to      }
        {mfquoter.i key2_from       }
        {mfquoter.i key2_to      }
        {mfquoter.i key1_from       }
        {mfquoter.i key1_to      }
        {mfquoter.i ctr       }
        {mfquoter.i ctr1      }
        {mfquoter.i effdate       }
        {mfquoter.i effdate1      }
        {mfquoter.i vdesc          }
        {mfquoter.i inclpost          }

        IF key3_to = "" THEN ASSIGN key3_to = hi_char.
        IF key2_to = "" THEN ASSIGN key2_to = hi_char.
        IF key1_to = "" THEN ASSIGN key1_to = hi_char.
        if ctr1     = ""    then assign ctr1 = hi_char.
        IF effdate1 = ?     THEN ASSIGN effdate1 = TODAY .
    end.  /* if (c-application-mode <> 'web') ... */

    /* SELECT PRINTER */
    {mfselbpr.i "printer" 132}

    /* main programmer */
    {a6gllir2.i}

    {a6mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
