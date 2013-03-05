/* xxTransfer.p Item transfer report                   */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V1   Developped: 22/08/05   BY: fm268 */
/* rev: eb2 + sp7  Developped: 23/08/05   BY: judy liu */

 
/* 反映库存转移量的报表 */

{mfdtitle.i } 
def var flushdate like tr_effdate . /*format "99/99/9999".*/
def var flushdate1 like tr_effdate. /* format "99/99/9999".*/
def var effdate  like tr_effdate.  /* format "99/99/9999".*/
def var effdate1 like tr_effdate.  /*format "99/99/9999".*/
def var site like tr_site .
DEF VAR model LIKE wo_part. 
DEF VAR model1 LIKE wo_part.
def var bktotal as integer .
def var bkall as integer.
DEF VAR plall AS INTEGER.
DEF VAR yn AS LOGICAL INIT YES LABEL "明细Y/汇总N".
DEF TEMP-TABLE xxrps 
    FIELD xxrps_part LIKE pt_part
    FIELD xxrps_qty LIKE tr_qty_loc
    FIELD xxrps_site LIKE pt_site.

    
FORM
    SKIP(.1)
    model               COLON 18 
    model1        LABEL {t001.i} COLON 49 SKIP 
	flushdate           label "回冲操作的时间"colon 18
	flushdate1          label {t001.i} colon 49 skip
	effdate             label "生效日期"colon 18
	effdate1            label {t001.i} colon 49 skip
    site                label "地点"  colon 18 
    yn                  LABEL "明细Y/汇总N" COLON 49
    SKIP (.4)
WITH FRAME a WIDTH 80 SIDE-LABELS NO-ATTR-SPACE THREE-D .
 setFrameLabels(frame a:handle). 

FORM
     tr_part pt_desc2 tr_qty_loc tr_site  tr_loc tr_effdate tr_date 
WITH FRAME b DOWN WIDTH 160 STREAM-IO .
/*setFrameLabels(frame b:handle).*/

FORM
     tr_part label "发动机型号"  pt_desc2 label "发动机描述"  bkall label "回冲总数量"
     tr_site label " 地点" tr_loc label " 库位" 
WITH FRAME c DOWN WIDTH 160 STREAM-IO .
/*setFrameLabels(frame c:handle).*/


REPEAT:

    FOR EACH xxrps:
        DELETE xxrps.
    END.
    HIDE MESSAGE NO-PAUSE.
	if site  = hi_char then site = "".
	if effdate = low_date then effdate = ?.
	if effdate1 = hi_date then effdate1 = ?.
    if flushdate = low_date then flushdate = ?.
	if flushdate1 = hi_date then flushdate1 = ?.
    IF model1 = hi_char THEN model1 = "".

    UPDATE model model1
           flushdate flushdate1 effdate effdate1 site yn  WITH FRAME a .


    if  site = "" then site = hi_char.
    if  effdate =? then effdate  = low_date.
    if  effdate1=? then effdate1 = hi_date.
    if  flushdate =? then flushdate  = low_date.
    if  flushdate1=? then flushdate1 = hi_date.
    IF model1 = "" THEN model1 = hi_char.
    
    {mfselprt.i "printer" 132}
          plall = 0.
          FOR EACH rps_mstr WHERE rps_domain = "DCEC" and rps_part >= model AND rps_part <= model1 
               AND (rps_due_date >= effdate AND rps_due_date <= effdate1) AND(rps_due_date >= flushdate AND rps_due_date <=  flushdate1)  NO-LOCK.
              FIND FIRST xxrps WHERE xxrps_part = rps_part NO-LOCK NO-ERROR.
              IF NOT AVAIL xxrps THEN  DO:
                  CREATE xxrps.
                  ASSIGN xxrps_part = rps_part
                         xxrps_qty = rps_qty_req
                         xxrps_site = rps_site.

              END.
              ELSE xxrps_qty = xxrps_qty + rps_qty_req.
          END.
     
    
   IF yn = NO THEN DO:
            bktotal = 0.
            bkall = 0.
            plall = 0.
            PUT "零件号               描述                            回冲总数    计划总数 地点     库位" SKIP.
            PUT "-------------------- ------------------------------- --------    -------- ------   ----" SKIP.
            FOR EACH tr_hist where tr_domain = "DCEC" and (tr_date >= flushdate and tr_date <= flushdate1) 
                and (tr_effdate >= effdate and tr_effdate <= effdate1) 
                AND tr_part >= model  AND tr_part <= model1 and tr_type ="rct-wo" and tr_site = site AND tr_loc ="FG" AND
                (tr_userid ="MRP" OR tr_userid ="Admin" or tr_userid = "mfg" or tr_userid = "qaduser") NO-LOCK break by tr_part.
                bktotal = bktotal + tr_qty_chg.
                bkall = bkall + tr_qty_chg .
                IF LAST-OF(tr_part) THEN DO:
                   FIND FIRST xxrps WHERE xxrps_part = tr_part NO-LOCK  NO-ERROR.
                   FIND FIRST pt_mstr WHERE pt_part = tr_part NO-LOCK NO-ERROR.
                       /*DISPLAY tr_part LABEL "发动机型号"  pt_desc2 WHEN AVAIL pt_mstr LABEL "发动机描述"   bktotal LABEL "回冲总数量" xxrps_qty WHEN AVAIL xxrps LABEL "计划总数量"
                            tr_site LABEL "地点"  tr_loc LABEL "库位"  WITH  WIDTH 180 .*/
                   IF AVAIL xxrps THEN DO:
                        PUT tr_part SPACE(3) pt_desc2 SPACE(3)bktotal SPACE(3) /*xxrps_qty*/ bktotal SPACE(3) tr_site SPACE(3) tr_loc  SKIP.
                        plall = plall + xxrps_qty.
                   END.
                   ELSE PUT tr_part SPACE(3) pt_desc2 SPACE(3)bktotal SPACE(3) 0 SPACE(3) tr_site SPACE(3) tr_loc  SKIP.
                   bktotal=0.
                END.
           END.
           /*DISP SPACE(40) "合计：" bkall  NO-LABEL SPACE(3) plall NO-LABEL WITH WIDTH 180.*/
           PUT SPACE(40) "合计：" bkall  SPACE(3) /*plall*/ bkall  SKIP.

   END.
    
   IF yn = YES THEN DO:
            bktotal = 0.
            bkall = 0.
            plall = 0.
            PUT "零件号             描述                           回冲数量    计划数量 地点     库位 生效日期 操作日期" SKIP.
            PUT "-----------------  ------------------------------ --------    -------- ------   ---- -------- --------" SKIP.
            FOR EACH tr_hist  where tr_domain = "DCEC" and (tr_date >= flushdate and tr_date <= flushdate1) 
                and (tr_effdate >= effdate and tr_effdate <= effdate1) 
                AND tr_part >= model   AND tr_part <= model1 and tr_type ="rct-wo"  and tr_site = site AND tr_loc ="FG" AND
                (tr_userid ="MRP" OR tr_userid ="Admin" or tr_userid = "mfg" or tr_userid = "qaduser") NO-LOCK BY tr_part.
                bkall = bkall + tr_qty_loc.
                FIND FIRST xxrps WHERE xxrps_part = tr_part NO-LOCK NO-ERROR.
                FIND FIRST pt_mstr WHERE pt_part = tr_part NO-LOCK NO-ERROR.
                IF AVAIL xxrps THEN DO:
                    /*DISPLAY tr_part LABEL "发动机型号" pt_desc2 WHEN AVAIL pt_mstr LABEL "发动机描述" tr_qty_loc LABEL "回冲数量"  xxrps_qty WHEN AVAIL xxrps LABEL "本月计划总数量"
                        tr_site LABEL "地点"   tr_loc LABEL "库位" tr_effdate LABEL "生效日期" tr_date LABEL "操作日期"  WITH  WIDTH 180.*/
                   PUT tr_part  pt_desc2  tr_qty_loc xxrps_qty  SPACE(2) tr_site  tr_loc  tr_effdate SPACE(3) tr_date SKIP.
                END.
                ELSE PUT tr_part  pt_desc2  tr_qty_loc  0  SPACE(2) tr_site  tr_loc  tr_effdate SPACE(3) tr_date SKIP.
            END.
            /*DISP SPACE(40) "合计：" bkall  NO-LABEL SPACE(3) plall NO-LABEL WITH WIDTH 180.*/
            PUT SPACE(36) "合计：" bkall SPACE(3)   SKIP.
   END.

    {mfrtrail.i}
   /*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
 

END.
