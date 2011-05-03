/* GUI CONVERTED from repkup.p (converter v1.76) Wed Dec 18 20:55:26 2002 */
/* repkup.p - REPETITIVE PICKLIST CALCULATION                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.9 $                                                 */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: emb  *G071*         */
/* REVISION: 7.3      LAST MODIFIED: 10/13/92   BY: emb  *G071*         */
/* REVISION: 7.3      LAST MODIFIED: 10/26/92   BY: emb  *G071*         */
/* REVISION: 7.3      LAST MODIFIED: 02/22/93   BY: emb  *G722*         */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: ram  *GF97*         */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   by: ame  *GN86*         */
/* REVISION: 7.3      LAST MODIFIED: 11/07/94   by: pxd  *GO32*         */
/* REVISION: 8.5      LAST MODIFIED: 01/03/95   BY: mwd  *J034*         */
/* REVISION: 7.3      LAST MODIFIED: 01/04/95   by: srk  *G0B8*         */
/* REVISION: 7.3      LAST MODIFIED: 01/30/95   BY: qzl  *G0DD*         */
/* REVISION: 7.3      LAST MODIFIED: 03/09/95   BY: pxe  *G0GW*         */
/* REVISION: 7.3      LAST MODIFIED: 03/14/95   BY: ais  *G0HC*         */
/* REVISION: 7.3      LAST MODIFIED: 06/09/95   BY: qzl  *G0PT*         */
/* REVISION: 7.3      LAST MODIFIED: 06/20/95   BY: str  *G0N9*         */
/* REVISION: 8.5      LAST MODIFIED: 09/05/95   BY: srk  *J07G*         */
/* REVISION: 7.3      LAST MODIFIED: 01/29/96   BY: jym  *G1LC*         */
/* REVISION: 8.5      LAST MODIFIED: 06/20/96   BY: taf  *J0VG*         */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 11/19/99   BY: *J3MK* Prashanth Narayan  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/25/00   BY: *N0GD* Peggy Ng           */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *GOGW*                    */
/* Revision: 1.6.1.8      BY: Katie Hilbert      DATE: 05/15/02  ECO: *P06H*  */
/* $Revision: 1.6.1.9 $           BY: Nishit V           DATE: 12/10/02  ECO: *N21K*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* BY: Micho Yang         DATE: 09/15/06  ECO: *SS - 20060915.1*  */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

/******************** SS - 20060915.1 - B ********************/
{xxbmpkiq.i "new"}
DEF VAR v_xsqhr_bg LIKE xxpk_bg.
DEF VAR v_xsqhr_ed LIKE xxpk_ed .
DEF VAR v_qty AS DECIMAL.
DEF VAR v_qty1 AS DECIMAL.
DEF VAR v_ord_qty AS DECIMAL.
DEF VAR v_qty_var AS DECIMAL.
/* */
DEF VAR v_qty_iss AS DECIMAL.
DEF VAR v_qty_iss_bal AS DECIMAL.
DEF VAR v_qty_iss_tot AS DECIMAL.
DEF VAR v_qty_sum AS DECIMAL.
DEF VAR v_qty_req AS DECIMAL.

DEFINE TEMP-TABLE tt 
   FIELD tt_lot LIKE xxpk_lot
   FIELD tt_site LIKE xxpk_site
   FIELD tt_par LIKE xxpk_par
   FIELD tt_part LIKE xxpk_part
   FIELD tt_part_desc LIKE xxpk_part_desc
   FIELD tt_article AS CHAR
   FIELD tt_date LIKE xxpk_date
   FIELD tt_line LIKE xxpk_line
   FIELD tt_bg LIKE xxpk_bg
   FIELD tt_ed LIKE xxpk_ed
   FIELD tt_ord_qty LIKE xxpk_ord_qty
   FIELD tt_qty LIKE xxpk_qty
   INDEX lot_qty tt_lot tt_site tt_line tt_date tt_bg tt_ed tt_par tt_part
   .

define temp-table tt1
   field tt1_lot like xxpk_lot
   field tt1_site like xxpk_site
   field tt1_line like xxpk_line
   field tt1_part like xxpk_part
   field tt1_bg   like xxpk_bg
   field tt1_ed   like xxpk_ed
   FIELD tt1_ord_qty LIKE xxpk_ord_qty
   FIELD tt1_part_desc LIKE xxpk_part_desc
   FIELD tt1_article AS CHAR
   field tt1_qty  like xxpk_qty 
   index index1 tt1_lot tt1_site tt1_line tt1_part tt1_bg tt1_ed 
   .

DEF BUFFER buftt1 FOR tt1 .
/******************** SS - 20060915.1 - E ********************/

define new shared variable site           like si_site.
define new shared variable site1          like si_site.
define new shared variable wkctr          like op_wkctr.
define new shared variable wkctr1         like op_wkctr.
define new shared variable part           like ps_par.
define new shared variable part1          like ps_par.
define new shared variable comp1          like ps_comp.
define new shared variable comp2          like ps_comp.
define new shared variable desc1          like pt_desc1.
define new shared variable desc2          like pt_desc1.
define new shared variable issue          like wo_rel_date
                                          label "Production Date".
define new shared variable issue1         like wo_rel_date.
define new shared variable reldate        like wo_rel_date
                                          label "Release Date".
define new shared variable reldate1       like wo_rel_date.
define new shared variable nbr            as character format "x(10)"
                                          label "Picklist Number".
define new shared variable delete_pklst   like mfc_logical initial no
                                          label "Delete When Done".
define new shared variable nbr_replace    as character format "x(10)".
define new shared variable qtyneed        like wod_qty_chg
                                          label "Qty Required".
define new shared variable netgr          like mfc_logical initial yes
                                          label "Use Work Center Inventory".
define new shared variable detail_display like mfc_logical
                                          label "Detail Requirements".
define new shared variable um             like pt_um.
define new shared variable wc_qoh         like ld_qty_oh.
define new shared variable temp_qty       like wod_qty_chg.
define new shared variable temp_nbr       like lad_nbr.
define new shared variable ord_max        like pt_ord_max.
define new shared variable comp_max       like wod_qty_chg.
define new shared variable pick-used      like mfc_logical.
define new shared variable isspol         like pt_iss_pol.

nbr_replace = getTermLabel("TEMPORARY",10).


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
site           colon 22
   site1          label {t001.i} colon 49 skip
   part           colon 22
   part1          label {t001.i} colon 49 skip
   comp1          colon 22
   comp2          label {t001.i} colon 49 skip
   wkctr          colon 22
   wkctr1         label {t001.i} colon 49 skip
   issue          colon 22
   issue1         label {t001.i} colon 49
   reldate        colon 22
   reldate1       label {t001.i} colon 49 skip(1)
   netgr          colon 30
   detail_display colon 30
   nbr            colon 30
   delete_pklst   colon 30
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

if not can-find(first rpc_ctrl) then do transaction:
   create rpc_ctrl.
   release rpc_ctrl.
end.

assign
   site  = global_site
   site1 = global_site.

repeat:

   find first rpc_ctrl no-lock no-error.
   nbr = rpc_nbr_pre + string(rpc_nbr).

   if site1    = hi_char  then site1    = "".
   if part1    = hi_char  then part1    = "".
   if comp2    = hi_char  then comp2    = "".
   if issue    = low_date then issue    = ?.
   if wkctr1   = hi_char  then wkctr1   = "".
   if issue1   = hi_date  then issue1   = ?.
   if reldate  = low_date then reldate  = ?.
   if reldate1 = hi_date  then reldate1 = ?.

   display nbr with frame a.

   update
      site  site1
      part  part1
      comp1 comp2
      wkctr wkctr1
      issue issue1
      reldate reldate1
      netgr
      detail_display
      nbr
      delete_pklst
   with frame a.

   if delete_pklst then nbr = mfguser.

   bcdparm = "".

   {gprun.i ""gpquote.p"" "(input-output bcdparm,16,
        site,site1,part,part1,comp1,comp2,wkctr,wkctr1,
        string(issue),string(issue1),string(reldate),string(reldate1),
        string(netgr),string(detail_display),nbr,string(delete_pklst),
        null_char,null_char,null_char,null_char)"}

   if site1    = "" then site1    = hi_char.
   if part1    = "" then part1    = hi_char.
   if comp2    = "" then comp2    = hi_char.
   if wkctr1   = "" then wkctr1   = hi_char.
   if issue    = ?  then issue    = low_date.
   if issue1   = ?  then issue1   = hi_date.
   if reldate  = ?  then reldate  = low_date.
   if reldate1 = ?  then reldate1 = hi_date.

   if not batchrun then do:
      {gprun.i ""gpsirvr.p""
         "(input site, input site1, output return_int)"}
      if return_int = 0 then do:
         next-prompt site with frame a.
         undo , retry.
      end.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

   {mfphead.i}

   /* REPKUPA.P ATTEMPS TO APPLY PHANTOM USE-UP LOGIC WHICH DOES NOT    */
   /* APPLY TO THE REPETITVE MODULE.  THEREFORE, DO NOT CALL REPKUPA.P  */

   {gprun.i ""repkupd.p""}

   /* ADDED SECTION TO DELETE 'FLAG' lad_det, AS WELL AS PICKLISTS
      THAT WERE CREATED THIS SESSION BUT SHOULD BE DELETED         */

   {gprun.i ""repkupc.p""}


   /******************** SS - 20060915.1 - B ********************/
   FOR EACH tt :
       DELETE tt.
   END.
   FOR EACH tt1 :
       DELETE tt1 .
   END.

   FOR EACH xsqhr_det EXCLUSIVE-LOCK WHERE xsqhr_site >= site 
                                AND xsqhr_site <= site1 
                                AND xsqhr_part >= part 
                                AND xsqhr_part <= part1 
                                AND xsqhr_line >= wkctr
                                AND xsqhr_line <= wkctr1
                                AND xsqhr_date >= issue
                                AND xsqhr_date <= issue1
                                BREAK BY xsqhr_part :
       IF FIRST-OF(xsqhr_part) THEN DO:
           FOR EACH tta6bmpkiq:
               DELETE tta6bmpkiq .
           END.
         
           /* CALL TO SECOND HALF OF PROGRAM */
           /* 展开BOM，以及取得BOM用量 */
           {gprun.i ""xxbmpkiq.p"" "(
                       INPUT xsqhr_part,
                       INPUT TODAY,
                       INPUT xsqhr_site,
                       INPUT 1 ,
                       INPUT 0 
                       )"  } 
       END. /* IF FIRST-OF(xsqhr_part) THEN DO: */

       IF xsqhr_bg >= 24 THEN DO:
           ASSIGN
               xsqhr_date = xsqhr_date + 1
               xsqhr_bg = xsqhr_bg - 24 
               xsqhr_ed = xsqhr_ed - 24
               .
       END.

       IF TRUNCATE(xsqhr_bg,0) = TRUNCATE(xsqhr_ed,0) THEN DO:
           /*
           IF truncate(xsqhr_bg,0) = 23 THEN DO:
               ASSIGN
                   xsqhr_bg = 23 
                   xsqhr_ed = INT( TRUNCATE(xsqhr_bg,0) ) 
                   .
           END.
           ELSE DO:
               ASSIGN
                   xsqhr_bg = INT( TRUNCATE(xsqhr_bg,0) ) 
                   xsqhr_ed = INT( TRUNCATE(xsqhr_bg,0) ) 
                   .
           END.
           */
           ASSIGN
               xsqhr_ed = INT( TRUNCATE(xsqhr_bg,0) ) + 1
               .
       END.

       FOR EACH tta6bmpkiq NO-LOCK ,
           EACH pt_mstr NO-LOCK WHERE pt_part = tta6bmpkiq_part :
            /*                                                  
            if index(string(xsqhr_bg),".") > 0 then do:
                         v_xsqhr_bg = string(int(entry(1,string(xsqhr_bg),"." )),"99") + ":" + string(int(round(decimal("0." + entry(2,string(xsqhr_bg),".")) * 60,0)))  .
            end.
            else do:
                v_xsqhr_bg = string(xsqhr_bg,"99") + ":" + "00" .
            end.
            if index(string(xsqhr_ed),".") > 0 then do:
                v_xsqhr_ed = string(int(entry(1,string(xsqhr_ed),"." )),"99") + ":" + string(int(round(decimal("0." + entry(2,string(xsqhr_ed),".")) * 60,0)))  .
            end.
            else do:
                v_xsqhr_ed = string(xsqhr_ed,"99") + ":" + "00" .
            end.
              */

            v_xsqhr_bg = string(xsqhr_bg,"99") + ":" + "00" .
            v_xsqhr_ed = string(xsqhr_ed,"99") + ":" + "00" .
            CREATE tt .
            ASSIGN
               tt_lot = string(xsqhr_site,"x(8)") + string(nbr,"x(10)")
               tt_site = xsqhr_site 
               tt_par = xsqhr_part
               tt_part = pt_part
               tt_part_desc = pt_desc1 + pt_desc2 
               tt_article = SUBSTRING(pt_article,1,2)
               tt_date = xsqhr_date
               tt_line = xsqhr_line
               tt_bg = v_xsqhr_bg
               tt_ed = v_xsqhr_ed
               tt_ord_qty = pt_ord_qty
               tt_qty = xsqhr_qty * tta6bmpkiq_qty
               .
       END.  /* FOR EACH tta6bmpkiq NO-LOCK , */
   END.

   /*
   PUT "xsqhr_det: " SKIP.
   FOR EACH xsqhr_det NO-LOCK :
       EXPORT DELIMITER ";" xsqhr_det .
   END.
     */

   FOR EACH tt WHERE tt_part < comp1 OR tt_part > comp2 :
       DELETE tt .
   END.

   /*
   PUT "tt:" SKIP.
   FOR EACH tt NO-LOCK:
       EXPORT DELIMITER ";" tt .
   END.
     */

   /* 按照“领料单” “地点” “工作中心” “料号” “开始时间” “结束时间” 汇总 */
   FOR EACH tt NO-LOCK BREAK BY tt_lot BY tt_site BY tt_line 
                             BY tt_article BY tt_ord_qty  BY tt_part BY tt_part_desc BY tt_bg BY tt_ed  :
       ACCUMULATE tt_qty (TOTAL BY tt_lot BY tt_site BY tt_line 
                                BY tt_article BY tt_ord_qty  BY tt_part BY tt_part_desc BY tt_bg BY tt_ed  ) .
       IF LAST-OF(tt_ed) THEN DO:
          CREATE tt1 .
          ASSIGN
             tt1_lot = tt_lot 
             tt1_site = tt_site
             tt1_line = tt_line
             tt1_part = tt_part
             tt1_part_desc = tt_part_desc 
             tt1_article = tt_article
             tt1_bg = tt_bg
             tt1_ed = tt_ed
             tt1_ord_qty = tt_ord_qty 
             tt1_qty = ( ACCUMULATE TOTAL BY tt_ed tt_qty ) 
             .
       END.
       IF LAST-OF(tt_part) THEN DO:
          CREATE tt1 .
          ASSIGN
             tt1_lot = tt_lot 
             tt1_site = tt_site
             tt1_line = tt_line
             tt1_part = tt_part
             tt1_part_desc = tt_part_desc 
             tt1_article = ""
             tt1_bg = "合"
             tt1_ed = "计"
             tt1_ord_qty = 0
             tt1_qty = ( ACCUMULATE TOTAL BY tt_part tt_qty ) 
             .
       END.
   END.

   /*
   PUT "tt1: " SKIP.
   FOR EACH tt1 NO-LOCK :
       EXPORT DELIMITER ";" tt1 .
   END.
    */

   v_qty = 0 .
   /*
   PUT "xxpk_det: " SKIP.
   PUT UNFORMATTED "Lot" ";" "Site" ";" "Part" ";" "Desc" ";" "Article" ";" "Date" ";" "Line" ";"  "Begin" ";" "End" ";" "Ord_Qty" ";" "Qty" ";" "Qty Iss" skip .
   */
   PUT UNFORMATTED "发料单号" ";" "地点" ";" "子零件" ";" "说明" ";" "分组" ";" "生效日期" ";" "生产线" ";" "开始时间" ";" "结束时间" ";" "包装数量" ";" "需求数量" ";" "发料数量" SKIP.
   FOR EACH tt1 WHERE tt1.tt1_bg = "合" AND tt1.tt1_ed = "计" AND DELETE_pklst = NO :
       v_qty = 0.
       FOR EACH lad_det WHERE SUBSTRING(lad_nbr,1,18) = tt1.tt1_lot 
                            AND substring(lad_nbr,1,8) = tt1.tt1_site
                            AND lad_line = tt1.tt1_line
                            AND lad_part = tt1.tt1_part 
                            NO-LOCK :
          v_qty = v_qty + lad_qty_all + lad_qty_pick .
       END.

       IF v_qty = tt1.tt1_qty THEN DO:
          /* define temp var */
          ASSIGN 
              v_qty_iss = 0
              v_qty_iss_bal = 0
              v_qty_iss_tot = 0
              v_qty_sum = tt1.tt1_qty 
              v_qty_req = 0
               .
          FOR EACH buftt1 WHERE buftt1.tt1_lot =  tt1.tt1_lot                                    
                                    AND buftt1.tt1_site = tt1.tt1_site
                                    AND buftt1.tt1_line = tt1.tt1_line
                                    AND buftt1.tt1_part = tt1.tt1_part
                                    AND buftt1.tt1_bg <> "合" 
                                    BREAK BY buftt1.tt1_bg :  
              CREATE xxpk_det .
              ASSIGN
                  xxpk_lot = buftt1.tt1_lot
                  xxpk_site = buftt1.tt1_site 
                  xxpk_part = buftt1.tt1_part
                  xxpk_part_desc = buftt1.tt1_part_desc
                  xxpk_article   = buftt1.tt1_article
                  xxpk_date = TODAY
                  xxpk_line = buftt1.tt1_line
                  xxpk_bg = buftt1.tt1_bg
                  xxpk_ed = buftt1.tt1_ed
                  xxpk_ord_qty = buftt1.tt1_ord_qty
                  xxpk_qty = buftt1.tt1_qty 
                  xxpk__dec01 = 0
                  .

              IF buftt1.tt1_ord_qty = 0 THEN do:
                  ASSIGN xxpk__dec01 = buftt1.tt1_qty .
                  NEXT.
              END.

              IF v_qty_sum - v_qty_iss_tot = 0  THEN NEXT .  /**/

              IF v_qty_iss_bal = 0 THEN DO:
                v_qty_req = buftt1.tt1_qty .
              END.
              ELSE DO:
                  IF buftt1.tt1_qty - v_qty_iss_bal > 0 THEN
                    ASSIGN v_qty_req = buftt1.tt1_qty - v_qty_iss_bal .
                  ELSE DO:
                    ASSIGN v_qty_iss_bal = v_qty_iss_bal - buftt1.tt1_qty .
                    NEXT .     /*如果余数够用的话*/
                  END.
              END.

              v_qty_iss = IF ( int(v_qty_req / buftt1.tt1_ord_qty) - (v_qty_req / buftt1.tt1_ord_qty) ) >= 0 
                    THEN int(v_qty_req / buftt1.tt1_ord_qty) * buftt1.tt1_ord_qty 
                    ELSE ( int(v_qty_req / buftt1.tt1_ord_qty) + 1)  * buftt1.tt1_ord_qty  .

              IF v_qty_sum - v_qty_iss_tot < v_qty_iss THEN DO:
                  ASSIGN v_qty_iss = v_qty_sum - v_qty_iss_tot 
                         v_qty_iss_tot = v_qty_iss_tot + v_qty_iss .
                  /*save v_qty_iss then next .*/
                  ASSIGN xxpk__dec01 = v_qty_iss .
                  NEXT .
              END.
              ELSE DO:
                  ASSIGN xxpk__dec01 = v_qty_iss .
                  ASSIGN v_qty_iss_bal = v_qty_iss - v_qty_req 
                         v_qty_iss_tot = v_qty_iss_tot + v_qty_iss .
              END.
          END.

          
          FOR EACH xxpk_det NO-LOCK WHERE xxpk_lot = tt1.tt1_lot AND xxpk_site = tt1.tt1_site AND xxpk_line = tt1.tt1_line AND xxpk_part = tt1.tt1_part BY xxpk_bg: 
           
              EXPORT DELIMITER ";" xxpk_lot xxpk_site xxpk_part xxpk_part_desc xxpk_article xxpk_date xxpk_line xxpk_bg xxpk_ed xxpk_ord_qty xxpk_qty xxpk__dec01 .
          END.
          v_qty = 0.
       END. /* IF v_qty = tt1_qty THEN DO: */
       ELSE IF v_qty > tt1.tt1_qty THEN DO:
          /* define temp var */
          ASSIGN 
              v_qty_iss = 0
              v_qty_iss_bal = 0
              v_qty_iss_tot = 0
              v_qty_req = 0
              v_qty_var = 0 - ( tt1.tt1_qty - v_qty  )
              v_qty_sum = tt1.tt1_qty
               .
          FOR EACH buftt1 WHERE buftt1.tt1_lot =  tt1.tt1_lot                                    
                                    AND buftt1.tt1_site = tt1.tt1_site
                                    AND buftt1.tt1_line = tt1.tt1_line
                                    AND buftt1.tt1_part = tt1.tt1_part
                                    AND buftt1.tt1_bg <> "合" 
                                    BREAK BY buftt1.tt1_bg :  
              CREATE xxpk_det .
              ASSIGN
                  xxpk_lot = buftt1.tt1_lot
                  xxpk_site = buftt1.tt1_site 
                  xxpk_part = buftt1.tt1_part
                  xxpk_part_desc = buftt1.tt1_part_desc
                  xxpk_article   = buftt1.tt1_article
                  xxpk_date = TODAY
                  xxpk_line = buftt1.tt1_line
                  xxpk_bg = buftt1.tt1_bg
                  xxpk_ed = buftt1.tt1_ed
                  xxpk_ord_qty = buftt1.tt1_ord_qty
                  xxpk_qty = buftt1.tt1_qty 
                  xxpk__dec01 = 0
                  .

              IF buftt1.tt1_ord_qty = 0 THEN do:
                  ASSIGN xxpk__dec01 = buftt1.tt1_qty .
                  NEXT.
              END.
              
              IF v_qty_sum - v_qty_iss_tot = 0 -  v_qty_var THEN NEXT .  /**/

              IF v_qty_iss_bal = 0 THEN DO:
                v_qty_req = buftt1.tt1_qty .
              END.
              ELSE DO:
                  IF buftt1.tt1_qty - v_qty_iss_bal > 0 THEN
                    ASSIGN v_qty_req = buftt1.tt1_qty - v_qty_iss_bal .
                  ELSE DO:
                    ASSIGN v_qty_iss_bal = v_qty_iss_bal - buftt1.tt1_qty .
                    NEXT .     /*如果余数够用的话*/
                  END.
              END.

              v_qty_iss = IF ( int(v_qty_req / buftt1.tt1_ord_qty) - (v_qty_req / buftt1.tt1_ord_qty) ) >= 0 
                    THEN int(v_qty_req / buftt1.tt1_ord_qty) * buftt1.tt1_ord_qty 
                    ELSE ( int(v_qty_req / buftt1.tt1_ord_qty) + 1)  * buftt1.tt1_ord_qty  .

              IF v_qty_sum - v_qty_iss_tot < v_qty_iss THEN DO:
                  
                  ASSIGN v_qty_iss = v_qty_sum - v_qty_iss_tot + v_qty_var
                         v_qty_iss_tot = v_qty_iss_tot + v_qty_iss .
                  /*save v_qty_iss then next .*/
                  ASSIGN xxpk__dec01 = v_qty_iss  .
                  NEXT .
              END.
              ELSE DO:
                  ASSIGN xxpk__dec01 = v_qty_iss .
                  ASSIGN v_qty_iss_bal = v_qty_iss - v_qty_req 
                         v_qty_iss_tot = v_qty_iss_tot + v_qty_iss .
              END.
          END.

          
          FOR EACH xxpk_det NO-LOCK WHERE xxpk_lot = tt1.tt1_lot AND xxpk_site = tt1.tt1_site AND xxpk_line = tt1.tt1_line AND xxpk_part = tt1.tt1_part BY xxpk_bg: 
           
              EXPORT DELIMITER ";" xxpk_lot xxpk_site xxpk_part xxpk_part_desc xxpk_article xxpk_date xxpk_line xxpk_bg xxpk_ed xxpk_ord_qty xxpk_qty xxpk__dec01 .
          END.
          
          v_qty = 0.
       END. /* ELSE IF v_qty > tt1.tt1_qty THEN DO: */
       ELSE DO:
          /* define temp var */
          ASSIGN 
              v_qty_iss = 0
              v_qty_iss_bal = 0
              v_qty_iss_tot = 0
              v_qty_req = 0
              v_qty_var = tt1.tt1_qty - v_qty  
              v_qty_sum = v_qty
               .
          FOR EACH buftt1 WHERE buftt1.tt1_lot =  tt1.tt1_lot                                    
                                    AND buftt1.tt1_site = tt1.tt1_site
                                    AND buftt1.tt1_line = tt1.tt1_line
                                    AND buftt1.tt1_part = tt1.tt1_part
                                    AND buftt1.tt1_bg <> "合" 
                                    BREAK BY buftt1.tt1_bg :  
              CREATE xxpk_det .
              ASSIGN
                  xxpk_lot = buftt1.tt1_lot
                  xxpk_site = buftt1.tt1_site 
                  xxpk_part = buftt1.tt1_part
                  xxpk_part_desc = buftt1.tt1_part_desc
                  xxpk_article   = buftt1.tt1_article
                  xxpk_date = TODAY
                  xxpk_line = buftt1.tt1_line
                  xxpk_bg = buftt1.tt1_bg
                  xxpk_ed = buftt1.tt1_ed
                  xxpk_ord_qty = buftt1.tt1_ord_qty
                  xxpk_qty = buftt1.tt1_qty 
                  xxpk__dec01 = 0
                  .
              IF buftt1.tt1_qty < v_qty_var THEN  DO:
                  ASSIGN xxpk__dec01 = 0 .
                  ASSIGN v_qty_var = v_qty_var - buftt1.tt1_qty .
                  NEXT .
              END.
              ELSE DO:
                 ASSIGN buftt1.tt1_qty = buftt1.tt1_qty - v_qty_var .
              END.

              IF buftt1.tt1_ord_qty = 0 THEN do:
                  ASSIGN xxpk__dec01 = buftt1.tt1_qty .
                  NEXT.
              END.
              
              IF v_qty_sum - v_qty_iss_tot = 0  THEN NEXT .  /**/

              IF v_qty_iss_bal = 0 THEN DO:
                v_qty_req = buftt1.tt1_qty .
              END.
              ELSE DO:
                  IF buftt1.tt1_qty - v_qty_iss_bal > 0 THEN
                    ASSIGN v_qty_req = buftt1.tt1_qty - v_qty_iss_bal .
                  ELSE DO:
                    ASSIGN v_qty_iss_bal = v_qty_iss_bal - buftt1.tt1_qty .
                    NEXT .     /*如果余数够用的话*/
                  END.
              END.

              v_qty_iss = IF ( int(v_qty_req / buftt1.tt1_ord_qty) - (v_qty_req / buftt1.tt1_ord_qty) ) >= 0 
                    THEN int(v_qty_req / buftt1.tt1_ord_qty) * buftt1.tt1_ord_qty 
                    ELSE ( int(v_qty_req / buftt1.tt1_ord_qty) + 1)  * buftt1.tt1_ord_qty  .

              IF v_qty_sum - v_qty_iss_tot < v_qty_iss THEN DO:
                  ASSIGN v_qty_iss = v_qty_sum - v_qty_iss_tot 
                         v_qty_iss_tot = v_qty_iss_tot + v_qty_iss .
                  /*save v_qty_iss then next .*/
                  ASSIGN xxpk__dec01 = v_qty_iss .
                  NEXT .
              END.
              ELSE DO:
                  ASSIGN xxpk__dec01 = v_qty_iss .
                  ASSIGN v_qty_iss_bal = v_qty_iss - v_qty_req 
                         v_qty_iss_tot = v_qty_iss_tot + v_qty_iss .
              END.
          END.

          
          FOR EACH xxpk_det NO-LOCK WHERE xxpk_lot = tt1.tt1_lot AND xxpk_site = tt1.tt1_site AND xxpk_line = tt1.tt1_line AND xxpk_part = tt1.tt1_part BY xxpk_bg: 
           
              EXPORT DELIMITER ";" xxpk_lot xxpk_site xxpk_part xxpk_part_desc xxpk_article xxpk_date xxpk_line xxpk_bg xxpk_ed xxpk_ord_qty xxpk_qty xxpk__dec01 .
          END.
          
          v_qty = 0.
       END. /* ELSE DO: */
   END. /* FOR EACH tt1 NO-LOCK WHERE tt1.tt1_bg = "合" AND tt1.tt1_ed = "计" AND DELETE_pklst = NO : */          
   /******************** SS - 20060915.1 - E ********************/


   /* REPORT TRAILER  */
   {mfrtrail.i}
   if temp_nbr = rpc_nbr_pre + string(rpc_nbr)
      and pick-used
      and not delete_pklst
   then do transaction:

      {gprun.i ""gpnbr.p"" "(16,input-output nbr)"}
      find first rpc_ctrl exclusive-lock.
      rpc_nbr = integer(substring(nbr,length(rpc_nbr_pre) + 1)).
      release rpc_ctrl.
   end.

end.  /* REPEAT */
