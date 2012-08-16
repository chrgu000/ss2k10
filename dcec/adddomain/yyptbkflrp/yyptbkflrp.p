/* xxTransfer.p Item transfer report                   */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V1   Developped: 22/08/05   BY: fm268 */
/* rev: eb2 + sp7  Developped: 23/08/05   BY: judy liu */


/* 反映库存转移量的报表 */

{mfdtitle.i "120816.1"}

&SCOPED-DEFINE trdfsirp_p_1 "Summary/Detail"

def var flushdate like tr_effdate . /*format "99/99/9999".*/
def var flushdate1 like tr_effdate. /* format "99/99/9999".*/
def var effdate  like tr_effdate.  /* format "99/99/9999".*/
def var effdate1 like tr_effdate.  /*format "99/99/9999".*/
def var site like tr_site  INIT "dcec-b".
def var site1 like tr_site INIT "dcec-b".
DEF VAR part LIKE wo_part.
DEF VAR part1 LIKE wo_part.
DEF VAR keeper AS CHAR.
DEF VAR keeper1 AS CHAR.
def var bktotal as integer .
def var bkall as integer.
DEF VAR yn AS LOGICAL INIT YES.
DEFINE VARIABLE  summary_only like mfc_logical
   label {&trdfsirp_p_1} format {&trdfsirp_p_1} initial YES.
DEF TEMP-TABLE xxrps
    FIELD xxrps_part LIKE pt_part
    FIELD xxrps_qty LIKE tr_qty_loc.


FORM
     SKIP(.1)
    part               COLON 18
    part1        LABEL {t001.i} COLON 49 SKIP
  effdate             label "生效日期"colon 18
  effdate1            label {t001.i} colon 49 skip
    keeper              COLON 18
    keeper1     LABEL {t001.i}  COLON 49 SKIP
    site                label "地点"  colon 18
    site1        LABEL {t001.i} COLON 49 SKIP
    summary_only  COLON 18 SKIP
    SKIP (.4)
WITH FRAME a WIDTH 80 SIDE-LABELS NO-ATTR-SPACE THREE-D .
 setFrameLabels(frame a:handle).

FORM
     tr_part pt_desc2 tr_qty_loc tr_site  tr_loc tr_effdate tr_date
WITH FRAME b DOWN WIDTH 160 STREAM-IO.
/*setFrameLabels(frame b:handle).*/

FORM
     tr_part label "发动机型号"  pt_desc2 label "发动机描述"  bkall label "回冲总数量"
     tr_site label " 地点" tr_loc label " 库位"
WITH FRAME c DOWN WIDTH 160 STREAM-IO.
/*setFrameLabels(frame c:handle).*/


REPEAT:

    FOR EACH xxrps:
        DELETE xxrps.
    END.
    HIDE MESSAGE NO-PAUSE.
    if site1  = hi_char then site1 = "".
  if effdate = low_date then effdate = ?.
  if effdate1 = hi_date then effdate1 = ?.
    if flushdate = low_date then flushdate = ?.
  if flushdate1 = hi_date then flushdate1 = ?.
    IF keeper1 = hi_char  THEN keeper1 = "".
    IF part1 = hi_char THEN part1 = "".


    UPDATE part part1  effdate effdate1 keeper keeper1
                  site  site1
                 summary_only  WITH FRAME a .


    if  effdate =? then effdate  = low_date.
    if  effdate1=? then effdate1 = hi_date.
    if  flushdate =? then flushdate  = low_date.
    if  flushdate1=? then flushdate1 = hi_date.
    IF part1 = "" THEN part1 = hi_char.
    IF keeper1 = ""  THEN keeper1 = hi_char.
    IF site1 = "" THEN site1 = hi_char.

  {mfselprt.i "printer" 132}


   IF summary_only = YES THEN DO:
            bktotal =0.
            bkall =0.
            FOR EACH tr_hist  WHERE tr_domain = global_domain
                and (tr_effdate >= effdate and tr_effdate <= effdate1)
                AND tr_part >= part   AND tr_part <= part1
                and tr_type = "iss-wo"  and tr_userid ="MRP"
                and tr_site >= site AND tr_site <= site1 NO-LOCK,
                EACH IN_mstr NO-LOCK WHERE in_domain = global_domain
                 and IN_part = tr_part AND IN_site = tr_site
                 AND IN__qadc01 >= keeper AND IN__qadc01 <= keeper1 USE-INDEX IN_part  BREAK BY tr_part:

                bktotal = bktotal + tr_qty_loc.
                IF LAST-OF(tr_part) THEN DO:
                    FIND FIRST pt_mstr WHERE pt_domain = global_domain
                           and pt_part = tr_part NO-LOCK NO-ERROR.

                       DISPLAY tr_part LABEL "零件" pt_desc2 LABEL "描述" WHEN AVAIL pt_mstr
                              tr_site LABEL "地点"
                             IN__qadc01 LABEL "保管员"
                            bktotal LABEL "回冲总数量"
                            WITH  WIDTH 160 STREAM-IO .

                   bktotal=0.

                END.
           END.
   END.

   IF summary_only = NO THEN DO:

           FOR EACH tr_hist  where tr_domain = global_domain
                and (tr_effdate >= effdate and tr_effdate <= effdate1)
                AND tr_part >= part   AND tr_part <= part1
                and tr_type = "iss-wo"   and tr_userid ="MRP"
                and tr_site >= site AND tr_site <= site1 NO-LOCK,
               EACH IN_mstr NO-LOCK WHERE in_domain = global_domain
                and IN_part = tr_part AND IN_site = tr_site
                AND IN__qadc01 >= keeper AND IN__qadc01 <= keeper1:

                FIND FIRST pt_mstr WHERE pt_domain = global_domain
                       and pt_part = tr_part NO-LOCK NO-ERROR.

                    DISPLAY tr_part LABEL "零件"  pt_desc2 LABEL "描述" WHEN AVAIL pt_mstr
                           tr_site LABEL "地点"  IN__qadc01 LABEL "保管员"
                           tr_qty_loc LABEL "回冲数量"
                           tr_loc LABEL "库位" tr_effdate LABEL "生效日期"
                          tr_trnbr   WITH  WIDTH 160 STREAM-IO .

            END.
   END.

    {mfrtrail.i}
   /*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


END.
