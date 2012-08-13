/**
 @File: yyinvagerp.p
 @Description: 库存账龄报表
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 库存账龄报表
 @Todo: 
 @History: 
**/

{mfdtitle.i}

DEFINE VARIABLE pl LIKE pt_prod_line .
DEFINE VARIABLE pl1 LIKE pt_prod_line .
DEFINE VARIABLE pt LIKE pt_part .
DEFINE VARIABLE pt1 LIKE pt_part .
DEF VAR age AS INT FORMAT ">>>>>9" EXTENT 4 LABEL "栏目天数" .
DEF VAR tempqty AS DEC .
DEF VAR tempqty1 AS DEC .
DEF VAR cst LIKE sct_cst_tot .

DEF TEMP-TABLE xx
    FIELD xx_part LIKE pt_part
    FIELD xx_um LIKE pt_um
    FIELD xx_desc AS CHAR FORMAT "x(24)" LABEL "描述"
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

        IF (TODAY - tr_date) < age[1] THEN xx_c1 = xx_c1 + tempqty1 .
        IF (TODAY - tr_date) >= age[1] AND (TODAY - tr_date) < age[2] THEN xx_c2 = xx_c2 + tempqty1 .
        IF (TODAY - tr_date) >= age[2] AND (TODAY - tr_date) < age[3] THEN xx_c3 = xx_c3 + tempqty1 .
        IF (TODAY - tr_date) >= age[3] AND (TODAY - tr_date) < age[4] THEN xx_c4 = xx_c4 + tempqty1 .
        IF (TODAY - tr_date) >= age[4] THEN xx_c5 = xx_c5 + tempqty1 .

        tempqty = tempqty - tempqty1 .
        IF tempqty <= 0 THEN LEAVE .

    END. /*for each tr_hist*/

END. /*for each xx*/

PUT UNFORMATTED "零件" AT 2 
    "UM" AT 22
    "描述" AT 26
    "成本" TO 70
    "库存数量" TO 90
    "库存价值" TO 110
    "< " + STRING(age[1]) + "天(数量)" TO 130 
    "< " + STRING(age[1]) + "天(价值)" TO 150 
    STRING(age[1]) + " - " + STRING(age[2]) + "天(数量)" TO 170
    STRING(age[1]) + " - " + STRING(age[2]) + "天(价值)" TO 190
    STRING(age[2]) + " - " + STRING(age[3]) + "天(数量)" TO 210
    STRING(age[2]) + " - " + STRING(age[3]) + "天(价值)" TO 230
    STRING(age[3]) + " - " + STRING(age[4]) + "天(数量)" TO 250
    STRING(age[3]) + " - " + STRING(age[4]) + "天(价值)" TO 270
    ">= " + STRING(age[4]) + "天(数量)" TO 290 
    ">= " + STRING(age[4]) + "天(价值)" TO 310 
    "其他" TO 330
    "其他价值" TO 350 SKIP .

FOR EACH xx NO-LOCK WHERE xx_qty > 0 :
    tempqty = xx_qty - xx_c1 - xx_c2 - xx_c3 - xx_c4 - xx_c5 .
/*judy 05/10/12*/
def var gl_site like in_gl_cost_site.
DEF VAR l_gl_set LIKE IN_gl_set.
find in_mstr where in_site =  "dcec-c"  and in_part = xx_part no-lock no-error.
if avail in_mstr then do:
     l_gl_set = in_gl_set.
     gl_site = in_gl_cost_site.
 end.
 if l_gl_set = "" then do:
	find  first icc_ctrl no-lock no-error.
	if available icc_ctrl then
		l_gl_set = icc_gl_set.
 end.  
 /*judy 05/10/12*/ 
    FIND si_mstr NO-LOCK WHERE si_site = "dcec-c" NO-ERROR .
    FIND FIRST sct_det NO-LOCK WHERE sct_part = xx_part AND sct_sim = l_gl_set
           and sct_site = "dcec-c" AND sct_cst_tot <> 0 NO-ERROR .
    IF AVAILABLE sct_det THEN cst = sct_cst_tot .
    ELSE cst = 0 .

    PUT xx_part AT 2 xx_um AT 22 xx_desc AT 26 
        cst TO 70 xx_qty TO 90 (xx_qty * cst) TO 110 FORMAT ">,>>>,>>>,>>9.99"
        xx_c1 TO 130 (xx_c1 * cst) TO 150 FORMAT ">,>>>,>>>,>>9.99" 
        xx_c2 TO 170 (xx_c2 * cst) TO 190 FORMAT ">,>>>,>>>,>>9.99" 
        xx_c3 TO 210 (xx_c3 * cst) TO 230 FORMAT ">,>>>,>>>,>>9.99" 
        xx_c4 TO 250 (xx_c4 * cst) TO 270 FORMAT ">,>>>,>>>,>>9.99" 
        xx_c5 TO 290 (xx_c5 * cst) TO 310 FORMAT ">,>>>,>>>,>>9.99" 
        tempqty TO 330 (tempqty * cst) TO 350 FORMAT ">,>>>,>>>,>>9.99"  SKIP .
END.

{mfrtrail.i}

end . /*repeat*/
                   
