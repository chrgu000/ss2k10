/* GUI CONVERTED from sosorp04.p (converter v1.78) Thu Mar 22 02:33:03 2012 */
/* sosorp04.p - SALES SHIPPING REPORT BY ITEM                                 */
/* Copyright 1986-2012 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: pml *D001*                */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: ftb *D002* added site*/
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb **/
/* REVISION: 6.0      LAST MODIFIED: 03/08/91   BY: afs *D408**/
/* REVISION: 6.0      LAST MODIFIED: 06/13/91   BY: afs *D696**/
/* REVISION: 6.0      LAST MODIFIED: 07/13/91   BY: afs *D769**/
/* REVISION: 6.0      LAST MODIFIED: 10/21/91   BY: afs *D903**/
/* REVISION: 7.0      LAST MODIFIED: 07/16/92   BY: afs *F774**/
/* REVISION: 7.2      LAST MODIFIED: 03/09/93   BY: tjs *G791**/
/* REVISION: 7.3      LAST MODIFIED: 01/20/94   BY: dpm *FL44**/
/* REVISION: 7.3      LAST MODIFIED: 12/12/94   BY: afs *FU52**/
/* REVISION: 7.3      LAST MODIFIED: 05/11/95   BY: jym *F0RM**/
/* REVISION: 7.3      LAST MODIFIED: 04/10/96   BY: jzw *G1P6**/
/* REVISION: 7.3      LAST MODIFIED: 09/17/96   BY: *G2FC* Ajit Deodhar */
/* REVISION: 7.4      LAST MODIFIED: 11/18/96   BY: *H0PF* Suresh Nayak */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0L4**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/05/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/99   BY: *L0FB* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/29/00   BY: *N0DX* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0WC* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *B388*                    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.1.6   BY: Jean Miller          DATE: 09/17/01  ECO: *N12P*  */
/* Revision: 1.10.1.8   BY: Patrick Rowan        DATE: 03/14/02  ECO: *P00G*  */
/* Revision: 1.10.1.9   BY: Hareesh V.           DATE: 06/21/02  ECO: *N1HY*  */
/* Revision: 1.10.1.11  BY: Paul Donnelly (SB)   DATE: 06/28/03  ECO: *Q00L*  */
/* Revision: 1.10.1.12  BY: Anitha Gopal         DATE: 11/27/03  ECO: *P1CC*  */
/* Revision: 1.10.1.13  BY: Tejasvi Kulkarni     DATE: 12/09/04  ECO: *P2VL*  */
/* Revision: 1.10.1.13.1.1  BY: Ankit Shah       DATE: 12/19/04  ECO: *P4CB*  */
/* Revision: 1.10.1.13.1.4  BY: Anju Dubey       DATE: 09/11/07  ECO: *P67C*  */
/* Revision: 1.10.1.13.1.5  BY: Prabu M          DATE: 06/09/09  ECO: *Q2TF*  */
/* Revision: 1.10.1.13.1.6            BY: Prabu M        DATE: 10/01/09  ECO: *Q3GJ*  */
/* $Revision: 1.10.1.13.1.7 $  BY: Lyn Zhao      DATE: 02/09/12      ECO: *Q57G* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=FullGUIReport*/
/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}

{cxcustom.i "SOSORP04.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosorp04_p_1 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp04_p_2 "Unit Price"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp04_p_4 "Qty Shipped"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp04_p_10 "%Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp04_p_12 "Ext Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp04_p_13 "Ext Price"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable addr like tr_addr.
define variable addr1 like tr_addr.
define variable so_job like tr_so_job.
define variable so_job1 like tr_so_job.
define variable part like tr_part.
define variable part1 like tr_part.
define variable trdate like tr_effdate.
define variable trdate1 like tr_effdate.
define variable region like cm_region.
define variable region1 like cm_region.
define variable site like tr_site.
define variable site1 like tr_site.
define variable name like ad_name.
define variable ext_price like tr_price label {&sosorp04_p_13}
   format "->,>>>,>>>,>>9.99".
define variable gr_margin like tr_price.
define variable ext_gr_margin like tr_price label {&sosorp04_p_12}
   format "->,>>>,>>>,>>9.99<<<".
define variable summary like mfc_logical format {&sosorp04_p_1}
   label {&sosorp04_p_1}.
define variable base_rpt like so_curr.

define variable base_price like tr_price.
define variable disp_curr as character format "x(1)" label "C".
define variable prod_line like tr_prod_line.
define variable prod_line1 like tr_prod_line.
define variable desc2 like pl_desc.
define variable pct_margin as decimal format "->>9.99" label {&sosorp04_p_10}.
define variable unit_cost like tr_mtl_std.
define variable tmp_margin like pct_margin.
define variable region_chk like mfc_logical.
define variable l_first_prod_line like mfc_logical no-undo.
define variable l_first_part      like mfc_logical no-undo.
define variable l_prod_line_ok    like mfc_logical no-undo.
define variable l_part_ok         like mfc_logical no-undo.
define variable l_report_ok       like mfc_logical no-undo.
define variable mc-error-number like msg_nbr no-undo.

{gprunpdf.i "mcpl" "p"}

/* CONSIGNMENT VARIABLES */
define variable consign_qty_ship like tr_qty_loc.
{socnvars.i}




/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
part           colon 15
   part1          label {t001.i} colon 49 skip
   prod_line      colon 15
   prod_line1     label {t001.i} colon 49 skip
   trdate         colon 15
   trdate1        label {t001.i} colon 49 skip
   addr           colon 15
   addr1          label {t001.i} colon 49 skip
   so_job         colon 15
   so_job1        label {t001.i} colon 49 skip
   region         colon 15
   region1        label {t001.i} colon 49
   site     colon 15
   site1    label {t001.i} colon 49 skip(1)
   summary        colon 15 skip
   base_rpt       colon 15 skip
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if part1 = hi_char then part1 = "".
   if addr1 = hi_char then addr1 = "".
   if so_job1 = hi_char then so_job1 = "".
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.
   if prod_line1 = hi_char then prod_line1 = "".
   if site1 = hi_char then site1 = "".
   if region1 = hi_char then region1 = "".

   if c-application-mode <> 'web' then
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update &fields = "  part part1 prod_line
        prod_line1 trdate trdate1 addr addr1 so_job so_job1 region region1
        site site1 summary base_rpt" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".

      {mfquoter.i part       }
      {mfquoter.i part1      }
      {mfquoter.i prod_line  }
      {mfquoter.i prod_line1 }
      {mfquoter.i trdate     }
      {mfquoter.i trdate1    }
      {mfquoter.i addr       }
      {mfquoter.i addr1      }
      {mfquoter.i so_job     }
      {mfquoter.i so_job1    }
      {mfquoter.i region     }
      {mfquoter.i region1    }
      {mfquoter.i site     }
      {mfquoter.i site1    }
      {mfquoter.i summary    }
      {mfquoter.i base_rpt   }

      if part1 = "" then part1 = hi_char.
      if prod_line1 = "" then prod_line1 = hi_char.
      if addr1 = "" then addr1 = hi_char.
      if trdate = ? then trdate = low_date.
      if trdate1 = ? then trdate1 = hi_date.
      if so_job1 = "" then so_job1 = hi_char.
      if region1 = "" then region1 = hi_char.
      if site1 = "" then site1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

define buffer rcttrans for tr_hist.



   {mfphead.i}

   FORM /*GUI*/  header
      skip(1)
   with STREAM-IO /*GUI*/  frame p1 page-top width 132 attr-space.
   view frame p1.

   /* SELECTION OF REGION OCCURS OUTSIDE THE FOR EACH LOOP(TO USE THE
    * REPORT AT REMOTE DB). THE "OK" FLAG INDICATES IF ANY VALID RECORD
    * HAS BEEN SELECTED FOR THE REPORT, PRODUCT LINE OR PART */
   l_report_ok         = no.

   {&SOSORP04-P-TAG1}
   for each tr_hist
      where tr_domain     = global_domain
      and  (tr_part      >= part
      and   tr_part      <= part1
      and   tr_prod_line >= prod_line
      and   tr_prod_line <= prod_line1
      and   tr_effdate   >= trdate
      and   tr_effdate   <= trdate1
      and   tr_addr      >= addr
      and   tr_addr      <= addr1
      and   tr_site      >= site
      and   tr_site      <= site1
      and   tr_so_job    >= so_job
      and   tr_so_job    <= so_job1
      and ((tr_type       = "ISS-SO"
         and not(can-find(first cncu_mstr
                             where cncu_mstr.cncu_domain = global_domain
                             and   cncu_trnbr            = tr_trnbr))
         and not tr_program begins "socn")
         or tr_type       = "RCT-SOR"
         or tr_type       = "CN-SHIP")
      and  (base_rpt      = ""
      or    tr_curr       = base_rpt)

      {&SOSORP04-P-TAG2})
   use-index tr_eff_trnbr
   no-lock
   break by tr_prod_line
         by tr_part
         by tr_effdate
   with frame b width 132 no-box:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      FORM /*GUI*/ 
         tr_part
         pt_um
         pt_desc1
         tr_qty_loc
         ext_price
         ext_gr_margin
         pct_margin
      with STREAM-IO /*GUI*/  frame c down width 132.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).

      {gprunmo.i
         &program = "socnsod1.p"
         &module = "ACN"
         &param = """(input tr_nbr,
                      input tr_line,
                      output consign_flag,
                      output consign_loc,
                      output intrans_loc,
                      output max_aging_days,
                      output auto_replenish)"""}

      if tr_type = "CN-SHIP"
      then
         consign_flag = yes.
      else
         assign
            consign_flag = no
            consign_qty_ship = 0.

      /* GET THE QTY SHIPPED FROM THE "RCT-TR" RECORD */
      for first rcttrans
         where rcttrans.tr_domain = global_domain
         and   rcttrans.tr_trnbr  = int64(tr_hist.tr_rmks)
         and   rcttrans.tr_type   = "RCT-TR"
         and   rcttrans.tr_nbr    = tr_hist.tr_nbr
      no-lock:
         consign_qty_ship = rcttrans.tr_qty_loc.
      end.  /* for first rcttrans */

      if first-of(tr_part) then
      assign
         l_first_part     = yes
         l_part_ok        = no.
      /* SAVE THE first-of(tr_part) OCCURRENCE FOR REFERRING TO VALID
       * tr_hist RECORDS. AND INITIALIZE O.K. TO PRINT PART TOTALS VARIABLE.*/

      if first-of(tr_prod_line) then
      assign
         l_first_prod_line   = yes
         l_prod_line_ok      = no.

      /* SAVE THE first-of(tr_prod_line) OCCURRENCE FOR REFERRING TO VALID
       * tr_hist RECORDS. INITIALIZE O.K. TO PRINT PRODUCT LINE TOTALS VARIABLE.*/

      /* Check customer region (if customers in this db) */
      if (region > "" or region1 < hi_char) and
         can-find(first cm_mstr  where cm_mstr.cm_domain = global_domain and
         cm_addr >= "")
      then do:
         find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
         tr_addr no-lock no-error.
         region_chk = (available cm_mstr
                       and cm_region >= region and cm_region <= region1).
      end.
      else
         region_chk = true.

      if l_first_prod_line and region_chk then do:

         /* CHECK FOR FIRST VALID RECORD FOR THIS PRDUCT LINE */
         l_first_prod_line  = no.

         find pl_mstr  where pl_mstr.pl_domain = global_domain and
         pl_prod_line = tr_prod_line no-lock no-error.

         if available pl_mstr then do:

            desc2 = pl_desc.

            if page-size - line-counter < 3 then page.

            if not summary then
               display with frame b STREAM-IO /*GUI*/ .
            else
               display with frame c STREAM-IO /*GUI*/ .

            put
               {gplblfmt.i &FUNC=getTermLabel(""PRODUCT_LINE"",15)
                           &CONCAT = "': '"}
               pl_prod_line
               " " pl_desc.
         end.

      end.

      if region_chk then do:

         l_part_ok = yes.

         /* AT-LEAST ONE VALID RECORD FOUND FOR THIS PART BREAK */

         /*Calculate Currency Exchange */
         assign
            base_price = tr_price
            disp_curr = "".

         if base_rpt <> "" and tr_curr <> base_curr
         then do:

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input tr_curr,
                 input tr_ex_rate2,
                 input tr_ex_rate,
                 input base_price,
                 input false,
                 output base_price,
                 output mc-error-number)"}.

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

         end. /*IF BASE_RPT <> "" AND TR_CURR <> BASE_CURR*/

         if base_rpt = "" and tr_curr <> base_curr then
            disp_curr = getTermLabel("YES",1).

         assign
            ext_price =  - tr_qty_loc * base_price
            unit_cost = - tr_gl_amt / tr_qty_loc.

         if consign_flag
            and tr_type <> "ISS-SO"
         then
            assign
               ext_price =  consign_qty_ship * base_price
               unit_cost =  tr_gl_amt / consign_qty_ship.

         if tr_ship_type <> " " then
            assign
               unit_cost = tr_mtl_std + tr_lbr_std + tr_bdn_std +
                           tr_ovh_std + tr_sub_std.

         gr_margin = tr_price - unit_cost.

         if base_rpt <> "" and tr_curr <> base_curr
         then do:

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input tr_curr,
                 input tr_ex_rate2,
                 input tr_ex_rate,
                 input gr_margin,
                 input false,
                 output gr_margin,
                 output mc-error-number)"}.

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

         end. /*IF BASE_RPT <> "" AND TR_CURR <> BASE_CURR*/

         ext_gr_margin = - tr_qty_loc * gr_margin.

         if consign_flag
            and tr_type <> "ISS-SO"
         then
            ext_gr_margin =  consign_qty_ship * gr_margin.

         if unit_cost = 0 then
            pct_margin = 100.
         else if (- tr_qty_loc) = 0 then
            pct_margin = 0.
         else if ext_price = 0 then
            pct_margin = 0.
         else
            pct_margin = (ext_gr_margin / ext_price) * 100.

         if consign_flag
            and tr_type <> "ISS_SO"
         then do:
            if unit_cost = 0 then pct_margin = 100.
            else
              if consign_qty_ship = 0 then pct_margin = 0.
              else
                if ext_price = 0 then pct_margin = 0.
                else
                  pct_margin = (ext_gr_margin / ext_price) * 100.
         end.  /* if consign_flag */

         if pct_margin > 999.99
         then
            pct_margin = 999.99.
         else
            if pct_margin < - 999.99
            then
               pct_margin = - 999.99.

         if (consign_flag
            and tr_type <> "ISS-SO")
            or  not consign_flag
         then do:
            accumulate ext_gr_margin (total by tr_prod_line by tr_part).
            accumulate tr_qty_loc (total by tr_prod_line by tr_part).
            accumulate ext_price (total by tr_prod_line by tr_part).
            accumulate consign_qty_ship (total by tr_prod_line by tr_part).
         end. /* IF (consign_flag AND ... */

      end. /* If region for this line is valid */

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      tr_part no-lock no-wait no-error.

      if not summary then do:

         name = "".

         find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
         tr_addr no-lock no-wait no-error.
         if available ad_mstr then name = ad_name.

         if l_first_part and region_chk  then do:

            /* CHECK FOR FIRST VALID RECORD FOR THIS PART */
            l_first_part = no.

            if page-size - line-counter < 4 then page.

            display WITH STREAM-IO /*GUI*/ .

            put
               {gplblfmt.i &FUNC=getTermLabel(""ITEM"",8) &CONCAT = "': '"}
               tr_part " ".

            if available pt_mstr then put
               pt_desc1 " " pt_desc2.

            put
               {gplblfmt.i &FUNC=getTermLabelRt(""UNIT_OF_MEASURE"",4)
                           &CONCAT = "': '"}
               tr_um
               skip.
         end.

         if page-size - line-counter < 3 then page.

         if region_chk then
            display
               tr_trnbr
               tr_ship_type
               tr_effdate
               tr_so_job label "SO/Job"
               tr_addr
               name format "x(16)"
               (- tr_qty_loc) when (not consign_flag)
                  @ tr_qty_loc label {&sosorp04_p_4}
               consign_qty_ship when (consign_flag)
                  @ tr_qty_loc label {&sosorp04_p_4}
               disp_curr base_price        label {&sosorp04_p_2}
               ext_price
               ext_gr_margin
               pct_margin WITH STREAM-IO /*GUI*/ .

         /* DISPLAY PART TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */

         if last-of(tr_part) and l_part_ok then do:

            /* AT-LEAST ONE VALID RECORD FOUND FOR THIS PRODUCT LINE BREAK */
            l_prod_line_ok = yes.

            /* Calculate the margin separately to avoid division by zero */
            if (accum total by tr_part (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total by tr_part (ext_gr_margin)) /
                   (accum total by tr_part  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if tmp_margin > 999.99
            then
               tmp_margin = 999.99.
            else
               if tmp_margin < - 999.99
               then
                  tmp_margin = - 999.99.

            if page-size - line-counter < 2 then page.

            underline tr_qty_loc ext_price ext_gr_margin pct_margin
            with frame b.

            display
               getTermLabel("ITEM_TOTAL",17) + ":"  @ name
               (- accum total by tr_part (tr_qty_loc) )
                 + accum total by tr_part (consign_qty_ship)
                  @ tr_qty_loc
               accum total by tr_part (ext_price) @ ext_price
               accum total by tr_part (ext_gr_margin) @ ext_gr_margin
               tmp_margin @ pct_margin
            with frame b STREAM-IO /*GUI*/ .

         end.

         /* DISPLAY PRODUCT LINE TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */
         if last-of(tr_prod_line) and l_prod_line_ok then do:

            l_report_ok = yes.

            /* Calculate the margin separately to avoid division by zero */
            if (accum total by tr_prod_line (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total by tr_prod_line (ext_gr_margin)) /
                   (accum total by tr_prod_line  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if tmp_margin > 999.99
            then
               tmp_margin = 999.99.
            else
               if tmp_margin < - 999.99
               then
                  tmp_margin = - 999.99.

            if page-size - line-counter < 2 then page.

            underline tr_qty_loc ext_price ext_gr_margin pct_margin.

            display
               getTermLabel("PRODUCT_LINE_TOTAL",17) + ":" @ name
               (- accum total by tr_prod_line (tr_qty_loc) )
                  + accum total by tr_prod_line (consign_qty_ship)
                  @ tr_qty_loc
               accum total by tr_prod_line (ext_price) @ ext_price
               accum total by tr_prod_line (ext_gr_margin) @ ext_gr_margin
               tmp_margin @ pct_margin WITH STREAM-IO /*GUI*/ .

         end.

         /* DISPLAY REPORT TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */
         if last(tr_prod_line)  and l_report_ok then do:

            /* Calculate the margin separately to avoid division by zero */
            if (accum total (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total (ext_gr_margin)) /
                   (accum total  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if tmp_margin > 999.99
            then
               tmp_margin = 999.99.
            else
               if tmp_margin < - 999.99
               then
                  tmp_margin = - 999.99.

            if page-size - line-counter < 2 then page.

            underline tr_qty_loc ext_price ext_gr_margin pct_margin.

            display
               getTermLabel("REPORT_TOTAL",17) + ":" @ name
               (- accum total (tr_qty_loc) )
                  + accum total (consign_qty_ship)
                    @ tr_qty_loc
               accum total  (ext_price) @ ext_price
               accum total  (ext_gr_margin) @ ext_gr_margin
               tmp_margin @ pct_margin WITH STREAM-IO /*GUI*/ .

         end.

      end.  /* not summary */

      if summary then do:

         /* DISPLAY PART TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */
         if last-of(tr_part) and l_part_ok then do:

            /* AT-LEAST ONE VALID RECORD FOUND FOR THIS PRODUCT LINE BREAK */
            l_prod_line_ok = yes.

            /* Calculate the margin separately to avoid division by zero */
            if (accum total by tr_part (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total by tr_part (ext_gr_margin)) /
                   (accum total by tr_part  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if tmp_margin > 999.99
            then
               tmp_margin = 999.99.
            else
               if tmp_margin < - 999.99
               then
                  tmp_margin = - 999.99.

            if page-size - line-counter < 2 then page.

            display
               tr_part
            with frame c down width 132 STREAM-IO /*GUI*/ .

            if available pt_mstr then
               display
                  pt_um
                  pt_desc1
               with frame c STREAM-IO /*GUI*/ .

            display
              (- accum total by tr_part (tr_qty_loc) )
                 + accum total by tr_part (consign_qty_ship)
                   @ tr_qty_loc
               accum total by tr_part (ext_price) @ ext_price
               accum total by tr_part (ext_gr_margin) @ ext_gr_margin
               tmp_margin @ pct_margin
            with frame c down width 132 STREAM-IO /*GUI*/ .

            if available pt_mstr and pt_desc2 <> "" then do:
               down 1 with frame c.
               display pt_desc2 @ pt_desc1 with frame c STREAM-IO /*GUI*/ .
            end.

         end.

         /* DISPLAY PRODUCT LINE TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */
         if last-of(tr_prod_line)  and l_prod_line_ok then do:

            l_report_ok = yes.

            /* Calculate the margin separately to avoid division by zero */
            if (accum total by tr_prod_line (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total by tr_prod_line (ext_gr_margin)) /
                   (accum total by tr_prod_line  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if tmp_margin > 999.99
            then
               tmp_margin = 999.99.
            else
               if tmp_margin < - 999.99
               then
                  tmp_margin = - 999.99.

            if page-size - line-counter < 2 then page.

            underline tr_qty_loc ext_price ext_gr_margin pct_margin
            with frame c.

            display
               getTermLabel("PRODUCT_LINE_TOTAL",23) + ":" @ pt_desc1
               (- accum total by tr_prod_line (tr_qty_loc) )
                  + accum total by tr_prod_line (consign_qty_ship)
                    @ tr_qty_loc
               accum total by tr_prod_line (ext_price) @ ext_price
               accum total by tr_prod_line (ext_gr_margin) @ ext_gr_margin
               tmp_margin @ pct_margin
            with frame c STREAM-IO /*GUI*/ .

         end.

         /* DISPLAY REPORT TOTALS WHEN AT-LEAST ONE tr_hist RECORD
          * QUALIFIES SELECTION CRITERIA */
         if last(tr_prod_line)  and l_report_ok then do:

            /* Calculate the margin separately to avoid division by zero */
            if (accum total (ext_price)) <> 0 then
               tmp_margin =
                  ((accum total (ext_gr_margin)) /
                   (accum total  (ext_price)) ) * 100.
            else
               tmp_margin = 0.

            if tmp_margin > 999.99
            then
               tmp_margin = 999.99.
            else
               if tmp_margin < - 999.99
               then
                  tmp_margin = - 999.99.

            if page-size - line-counter < 2 then page.

            underline tr_qty_loc ext_price ext_gr_margin pct_margin
            with frame c.

            display
               getTermLabel("REPORT_TOTAL",23) + ":" @ pt_desc1
               (- accum total (tr_qty_loc) )
                  + accum total (consign_qty_ship)
                    @ tr_qty_loc
               accum total  (ext_price) @ ext_price
               accum total  (ext_gr_margin) @ ext_gr_margin
               tmp_margin @ pct_margin
            with frame c STREAM-IO /*GUI*/ .

         end.

      end. /* summary*/

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


   end. /*for each*/

   /* REPORT TRAILER  */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" part part1 prod_line prod_line1 trdate trdate1 addr addr1 so_job so_job1 region region1 site site1 summary base_rpt "} /*Drive the Report*/
