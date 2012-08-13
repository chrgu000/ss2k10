
{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
{bcwin01.i}

DEFINE VARIABLE hExcel      AS COM-HANDLE       NO-UNDO.



DEFINE VARIABLE part1 LIKE tr_part.
DEFINE VARIABLE part2 LIKE tr_part.
DEFINE VARIABLE sd AS LOGICAL FORMAT "SUM/DET".
DEFINE VARIABLE sumqty AS DECIMAL.



/*DEFINE VARIABLE hExcel      AS COM-HANDLE       NO-UNDO.*/

&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
         
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(2)  /*GUI*/
part1 LABEL "料件号" COLON 15
    part2 LABEL "至" COLON 45
    SKIP(1)
    sd LABEL "汇总/明细" COLON 30
SKIP(2)  /*GUI*/
with frame a WIDTH 80  side-labels  attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME




REPEAT :
    IF part2 = hi_char THEN part2 = "".

    UPDATE part1 part2 sd  WITH FRAME a.

    IF part2 = "" THEN part2 =hi_char.

    OUTPUT TO value("c:\trans.csv") NO-CONVERT.

        /*PUT "零件号" "," "INBOM" "," "描述1" "," "描述2" "," "单位" "," "零件类型" "," "产品类" "," "分组" "," "地点" "," "库位"
                     "," "ISS-PRV" "," "ISS-SO" "," "ISS-TR" "," "ISS-UNP" "," "ISS-WO" "," "RCT-PO" "," "RCT-SOR" "," "RCT-TR" "," "RCT-UNP"
                     "," "RCT-WO" "," "RJCT-WO" "," "TAG-CNT" "," "CYC" "," "OTHER".
                PUT SKIP(1).*/

       IF sd = YES THEN DO:
           EXPORT DELIMITER "," 
                 "零件号" "描述1"  "描述2"  "单位"  "条码数量" .
           FOR EACH b_co_mstr,EACH pt_mstr WHERE b_co_part = pt_part 
               AND b_co_part >= part1 AND b_co_part <= part2 BREAK BY b_co_part:
               ACCUMULATE b_co_qty_cur (TOTAL BY b_co_part).
               IF LAST-OF(b_co_part) THEN DO:
                   sumqty = (ACCUMU TOTAL BY b_co_part b_co_qty_cur).
                   EXPORT DELIMITER ","
                   b_co_part pt_desc1 pt_desc2 pt_um sumqty.
               END.
           END.
       END.
       ELSE DO:
           EXPORT DELIMITER "," 
                 "零件号" "描述1"  "描述2"  "单位"  "条码" "单个条码数量" .
           FOR EACH b_co_mstr,EACH pt_mstr WHERE b_co_part = pt_part 
               AND b_co_part >= part1 AND b_co_part <= part2 BREAK BY b_co_part:
               ACCUMULATE b_co_qty_cur (TOTAL BY b_co_part).
               IF FIRST-OF(b_co_part) THEN DO:
                   EXPORT DELIMITER ","
                   b_co_part pt_desc1 pt_desc2 pt_um b_co_code b_co_qty_cur.
               END.
               IF LAST-OF(b_co_part) THEN DO:
                   EXPORT DELIMITER "," 
                         "零件号" "描述1"  "描述2"  "单位"  "条码数量" .
                   sumqty = (ACCUMU TOTAL BY b_co_part b_co_qty_cur).
                   EXPORT DELIMITER ","
                   b_co_part pt_desc1 pt_desc2 pt_um sumqty.
               END.
           END.
       END.

       
    OUTPUT CLOSE.
    CREATE "Excel.Application" hExcel.
    hExcel:VISIBLE = TRUE.                         
    hExcel:WorkBooks:OPEN( "c:\trans.csv"). 
    RELEASE OBJECT hExcel. 

    /*DISP tot_iss_prv 
    tot_iss_so
    tot_iss_tr 
    tot_iss_unp 
    tot_iss_wo 
    tot_rct_po
    tot_rct_sor
    tot_rct_tr
    tot_rct_unp 
    tot_rct_wo
    tot_rjct_wo
    tot_tag_cnt 
    tot_cyc 
    tot_others WITH FRAME c.*/


END.

        DELETE WIDGET current-window.
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN NO-APPLY .  
