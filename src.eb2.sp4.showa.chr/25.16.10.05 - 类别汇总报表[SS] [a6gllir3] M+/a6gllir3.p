/* a6gllir3.p 项目发生额情况表                                    */
/* BY: Micho Yang          DATE: 04/23/08  ECO: *SS - 20080423.1* */

/* DISPLAY TITLE */
{mfdtitle.i "M+ "}

DEFINE VARIABLE scheme AS LOGICAL INIT YES .
define variable vlevel AS INTEGER INIT 1 NO-UNDO.
DEFINE VARIABLE key3_from LIKE usrw_key3.
DEFINE VARIABLE key3_to LIKE usrw_key3 .
DEFINE VARIABLE key31 AS CHAR FORMAT "x(50)" .
DEFINE VARIABLE key32 AS CHAR FORMAT "x(50)" .
define variable acc like ac_code NO-UNDO  .
define variable acc1 like ac_code NO-UNDO .
define variable sub like sb_sub NO-UNDO  .
define variable sub1 like sb_sub NO-UNDO .
define variable ctr like cc_ctr NO-UNDO  .
define variable ctr1 like cc_ctr NO-UNDO .
DEFINE VARIABLE effdate LIKE glt_effdate NO-UNDO.
DEFINE VARIABLE effdate1 LIKE glt_effdate NO-UNDO.

DEFINE VARIABLE inclpost AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE i AS INTEGER .

DEF TEMP-TABLE tt 
    FIELD tt_code LIKE usrw_key3 
    INDEX index1 tt_code
    .

FORM
    scheme  COLON 30 LABEL "方案(Yes[连续]/No[不连续])"
    SKIP
    vlevel  COLON 25 LABEL "层次"
    key31   COLON 25 LABEL "项目(请以逗号分割项目)"
    key32   COLON 25 NO-LABEL 
    SKIP(1)
    key3_from   COLON 25 LABEL "项目" key3_to    COLON 50 LABEL {t001.i}
    acc     COLON 25 acc1 COLON 50 LABEL {t001.i}
    sub     COLON 25 sub1 COLON 50 LABEL {t001.i}
    ctr     COLON 25 ctr1 COLON 50 LABEL {t001.i}
    effdate COLON 25 effdate1 COLON 50 LABEL {t001.i}
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

    CLEAR FRAME a .

    /* INPUT OPTIONS */
    if key3_from = hi_char then assign key3_to = "".
    if acc1 = hi_char then assign acc1 = "".
    if sub1 = hi_char then assign sub1 = "".
    if ctr1 = hi_char then assign ctr1 = "".

    UPDATE scheme WITH FRAME a.
    DO ON ERROR UNDO,RETRY :
        IF scheme = YES THEN DO:
            update
                vlevel 
                key3_from 
                key3_to   
                acc acc1
                sub sub1
                ctr ctr1
                effdate effdate1
                inclpost
               with frame a.
        END.
        ELSE DO:
            update
                vlevel 
                key31 
                key32 
                acc acc1
                sub sub1
                ctr ctr1
                effdate effdate1
                inclpost
               with frame a.
        END.

        IF vlevel > 8 THEN DO:
            MESSAGE "错误: 层次最大不允许超过8.请重新输入" .
            NEXT-PROMPT vlevel WITH FRAME a .
            UNDO,RETRY .
        END.
    
        IF scheme = YES THEN DO:
            IF LENGTH(key3_from) <> vlevel THEN DO:
                MESSAGE "错误: 只能输入本层次的项目.请重新输入" .
                NEXT-PROMPT key3_from WITH FRAME a.
                UNDO,RETRY .
            END.
            IF LENGTH(key3_to) <> vlevel THEN DO:
                MESSAGE "错误: 只能输入本层次的项目.请重新输入" .
                NEXT-PROMPT key3_to WITH FRAME a.
                UNDO,RETRY .
            END.
        END.
        ELSE DO:
            EMPTY TEMP-TABLE tt .
            IF key31 <> "" THEN DO:
                DO i = 1 TO NUM-ENTRIES(key31):
                    CREATE tt .
                    ASSIGN
                        tt_code = ENTRY(i ,key31,",") 
                        .
                END.
            END.

            IF key32 <> "" THEN DO:
                DO i = 1 TO NUM-ENTRIES(key32) :
                    FIND FIRST tt WHERE tt_code = ENTRY(i,key32,",") NO-LOCK NO-ERROR.
                    IF NOT AVAIL tt THEN DO:
                        CREATE tt.
                        ASSIGN
                            tt_code = ENTRY(i,key32,",")
                            .
                    END.
                END.
            END.

            FOR EACH tt WHERE tt_code = "":
                DELETE tt.
            END.
            FOR EACH tt :
                IF LENGTH(tt_code) <> vlevel THEN DO:
                    MESSAGE "错误: 只能输入本层次的项目.请重新输入" .
                    NEXT-PROMPT key31 WITH FRAME a.
                    UNDO,RETRY .
                END.
            END.
        END.
    END.

    if key3_from     = ""    then assign key3_to = hi_char.
    if acc1     = ""    then assign acc1 = hi_char.
    if sub1     = ""    then assign sub1 = hi_char.
    if ctr1     = ""    then assign ctr1 = hi_char.
    IF effdate1 = ?     THEN ASSIGN effdate1 = TODAY .
    
    /* SELECT PRINTER */
    {mfselbpr.i "printer" 132}

    /* main programmer */
    {a6gllir3.i}

/* 输出到BI */
PUT UNFORMATTED "#def REPORTPATH=$/BI报表/a6gllir3" SKIP.
PUT UNFORMATTED "#def :end" SKIP.

    FOR EACH tt :
        EXPORT DELIMITER ";" tt .
    END.

    {a6mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
