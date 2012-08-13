/**
 @File: yyinvagerp.p
 @Description: ������䱨��
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-11
 @BusinessLogic: ������䱨��
 @Todo: 
 @History: 
**/

{mfdtitle.i}

DEFINE VARIABLE pl LIKE pt_prod_line .
DEFINE VARIABLE pl1 LIKE pt_prod_line .
DEFINE VARIABLE pt LIKE pt_part .
DEFINE VARIABLE pt1 LIKE pt_part .
DEF VAR age AS INT FORMAT ">>>>>9" EXTENT 4 LABEL "��Ŀ����" .
DEF VAR tempqty AS DEC .
DEF VAR tempqty1 AS DEC .

DEF TEMP-TABLE xx
    FIELD xx_part LIKE pt_part
    FIELD xx_um LIKE pt_um
    FIELD xx_desc AS CHAR FORMAT "x(28)" LABEL "����"
    FIELD xx_qty LIKE IN_qty_oh FORMAT ">,>>>,>>>,>>9.99"
    FIELD xx_c1 LIKE IN_qty_oh FORMAT ">,>>>,>>>,>>9.99"
    FIELD xx_c2 LIKE IN_qty_oh FORMAT ">,>>>,>>>,>>9.99"
    FIELD xx_c3 LIKE IN_qty_oh FORMAT ">,>>>,>>>,>>9.99"
    FIELD xx_c4 LIKE IN_qty_oh FORMAT ">,>>>,>>>,>>9.99"
    FIELD xx_c5 LIKE IN_qty_oh FORMAT ">,>>>,>>>,>>9.99" .

FORM
    pl colon 20 pl1 colon 45 label {t001.i} SKIP
    pt COLON 20 pt1 COLON 45 LABEL {t001.i} SKIP(1)
    age[1] COLON 16 age[2] COLON 30 LABEL "[2]" age[3] COLON 44 LABEL "[3]" age[4] COLON 58 LABEL "[4]" SKIP
SKIP(1)
with frame a width 80 THREE-D side-labels attr-space .
setFrameLabels(frame a:handle).

mainloop:
repeat:

IF pl1 = hi_char THEN pl1 = "" .
IF pt1 = hi_char THEN pt1 = "" .
IF age[1] = 0 AND age[2] = 0 AND age[3] = 0 AND age[4] = 0 THEN DO :
    age[1] = 30 .
    age[2] = 60 .
    age[3] = 90 .
    age[4] = 120 .
END.

UPDATE
pl pl1 pt pt1 age[1] age[2] age[3] age[4]
with frame a .

bcdparm = "".
{mfquoter.i pl}
{mfquoter.i pl1}
{mfquoter.i pt}
{mfquoter.i pt1}
{mfquoter.i age[1]}
{mfquoter.i age[2]}
{mfquoter.i age[3]}
{mfquoter.i age[4]}

{mfselbpr.i "printer" 132}

{mfphead.i}

IF pl1 = "" THEN pl1 = hi_char .
IF pt1 = "" THEN pt1 = hi_char .

FOR EACH xx :
    DELETE xx .
END.

FOR EACH pt_mstr NO-LOCK WHERE pt_part >= pt AND pt_part <= pt1
    AND pt_prod_line >= pl AND pt_prod_line <= pl1 ,
    EACH IN_mstr NO-LOCK WHERE IN_part = pt_part:

    FIND xx WHERE xx_part = in_part NO-ERROR .
    IF NOT AVAILABLE xx THEN DO :
        CREATE xx .
        xx_part = IN_part .
        xx_desc = pt_desc1 + pt_desc2 .
        xx_um = pt_um .
    END.
    xx_qty = xx_qty + IN_qty_oh + IN_qty_nonet .

END.

FOR EACH xx WHERE xx_qty > 0 :

    tempqty = xx_qty .

    FOR EACH tr_hist NO-LOCK WHERE (tr_type = "rct-po" OR tr_type = "rct-wo") 
        AND tr_part = xx_part
        USE-INDEX tr_part_eff BY tr_date DESCENDING :
        IF tr_type = "rct-po" THEN DO :
            FIND pod_det NO-LOCK WHERE pod_nbr = tr_nbr AND pod_line = tr_line NO-ERROR .
            IF AVAILABLE pod_det AND pod_type = "s" THEN NEXT .
        END.

        tempqty1 = MIN(tempqty, tr_qty_loc) .

        /*tr_price*/

        IF (TODAY - tr_date) < age[1] THEN xx_c1 = xx_c1 + tempqty1 .
        IF (TODAY - tr_date) >= age[1] AND (TODAY - tr_date) < age[2] THEN xx_c2 = xx_c2 + tempqty1 .
        IF (TODAY - tr_date) >= age[2] AND (TODAY - tr_date) < age[3] THEN xx_c3 = xx_c3 + tempqty1 .
        IF (TODAY - tr_date) >= age[3] AND (TODAY - tr_date) < age[4] THEN xx_c4 = xx_c4 + tempqty1 .
        IF (TODAY - tr_date) >= age[4] THEN xx_c5 = xx_c5 + tempqty1 .

        tempqty = tempqty - tempqty1 .
        IF tempqty <= 0 THEN LEAVE .

    END. /*for each tr_hist*/

END. /*for each xx*/

PUT "���" AT 2 
    "UM" AT 22
    "����" AT 26
    "�������" TO 76
    "< " + STRING(age[1]) + "��" TO 96 
    STRING(age[1]) + " - " + STRING(age[2]) + "��" TO 116
    STRING(age[2]) + " - " + STRING(age[3]) + "��" TO 136
    STRING(age[3]) + " - " + STRING(age[4]) + "��" TO 156
    ">= " + STRING(age[4]) + "��" TO 176 SKIP .

FOR EACH xx NO-LOCK WHERE xx_qty > 0 :
    tempqty = xx_qty - xx_c1 - xx_c2 - xx_c3 - xx_c4 - xx_c5 .
    IF tempqty <> 0 THEN DO :
        IF xx_c5 <> 0 THEN xx_c5 = xx_c5 + tempqty .
        ELSE IF xx_c4 <> 0 THEN xx_c4 = xx_c4 + tempqty .
        ELSE IF xx_c3 <> 0 THEN xx_c3 = xx_c3 + tempqty .
        ELSE IF xx_c2 <> 0 THEN xx_c2 = xx_c2 + tempqty .
        ELSE xx_c1 = xx_c1 + tempqty .
    END.
    PUT xx_part AT 2 xx_um AT 22 xx_desc AT 26 xx_qty TO 76 xx_c1 TO 96 xx_c2 TO 116 xx_c3 TO 136 xx_c4 TO 156 xx_c5 TO 176 SKIP .
END.

{mfrtrail.i}

end . /*repeat*/
                   
