/* GUI CONVERTED from resqrp.p (converter v1.78) Fri Oct 29 14:37:53 2004 */
/* resqrp.p - PRODUCTION LINE SEQUENCE REPORT                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.7.1.7 $                                                           */
/* REVISION: 7.0    LAST MODIFIED: 10/18/91     BY: smm *F230*            */
/* REVISION: 7.0    LAST MODIFIED: 03/30/92     BY: emb *F331*            */
/* Revision: 7.3        Last edit: 11/19/92     By: jcd *G348*            */
/* REVISION: 7.3    LAST MODIFIED: 05/26/92     BY: emb *G468*            */
/* REVISION: 7.3    LAST MODIFIED: 08/27/94     BY: bcm *GL62*            */
/* REVISION: 7.3    LAST MODIFIED: 01/30/96     by: jym *G1LJ*            */
/* REVISION: 8.6    LAST MODIFIED: 10/15/97     by: bvm *K0ZP*            */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown       */
/* REVISION: 9.1    LAST MODIFIED: 09/11/00   BY: *N0RS* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* Revision: 1.7.1.4   BY: Annasaheb Rahane   DATE: 09/12/01 ECO:  *N129* */
/* Revision: 1.7.1.6   BY: Paul Donnelly (SB) DATE: 06/28/03 ECO:  *Q00K* */
/* $Revision: 1.7.1.7 $        BY: Sushant Pradhan    DATE: 02/09/04 ECO:  *P1MT* */
/* $Revision: 1.7.1.7 $        BY: Mage Chen    DATE: 08/06/06 ECO:  *ts* */
/* $Revision: by ken SS - 111011.1 */ 
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=FullGUIReport                                            */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*SS - 111011.1 B*/

/*
{mfdtitle.i "1+ "} /*G468*/
*/

{mfdtitle.i "111011.1"} /*G468*/                           

/*SS - 111011.1 E*/
                   
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE resqrp_p_1 "Seq No"
/* MaxLen: Comment: */

&SCOPED-DEFINE resqrp_p_3 "Item Cum"
/* MaxLen: Comment: */

&SCOPED-DEFINE resqrp_p_5 "Hours"
/* MaxLen: Comment: */

&SCOPED-DEFINE resqrp_p_7 "Daily Total"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable site like rps_site.
define variable site1 like rps_site.
define variable line  like rps_line.
define variable line1 like rps_line.
define variable part  like rps_part.
define variable part1 like rps_part.
define variable due   like rps_due_date.
define variable due1  like rps_due_date.
define variable result like rps_qty_req.
define variable item_total like rps_qty_req column-label {&resqrp_p_3}.
define variable pline_total like rps_qty_req.
define variable daily_total like rps_qty_req column-label {&resqrp_p_7}.
define variable old_part like seq_part.
define variable hours as decimal label {&resqrp_p_5} format "->>>,>>>,>>9.99".
define variable hours_total as decimal label {&resqrp_p_7}.
define variable changetime like chg_time.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
site  colon 20
   site1 colon 46 label {t001.i}
   line  colon 20
   line1 colon 46 label {t001.i}
   part  colon 20
   part1 colon 46 label {t001.i}
   due   colon 20
   due1  colon 46 label {t001.i}
   skip(1)
 SKIP(.4)  /*GUI*/
with frame a side-labels          width 80 NO-BOX THREE-D /*GUI*/.

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

FORM /*GUI*/ 
   seq_site column-label "Site!Line"
   /*SS - 111011.1 B*/
   seq__chr01 COLUMN-LABEL "°à´Î"
   /*SS - 111011.1 E*/
   seq_priority column-label {&resqrp_p_1} format ">>>9.9<"
   seq_due_date
   rps_part
   rps_qty_req
   lnd_prod_um
   daily_total
/*ts   item_total*/
   ln_rate
   hours
with STREAM-IO /*GUI*/  frame b down width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

{wbrp01.i}


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if due1   = hi_date then due1 = ?.
   if due    = low_date then due = ?.
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if line1 = hi_char then line1 = "".

   if c-application-mode <> 'web' then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update
      &fields = "  site site1 line line1 part part1 due due1"
      &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i line   }
      {mfquoter.i line1  }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i due    }
      {mfquoter.i due1   }

      if due1  = ?  then due1  = hi_date.
      if due   = ?  then due   = low_date.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if line1 = "" then line1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



   {mfphead.i}

   assign daily_total = 0
          hours_total = 0
          hours       = 0
          item_total  = 0
          pline_total = 0
          old_part    = ?.

   for each seq_mstr no-lock  where seq_mstr.seq_domain = global_domain and
   (seq_site >= site and seq_site <= site1)
         and (seq_line >= line and seq_line <= line1)
         and (seq_part >= part and seq_part <= part1)
         and (seq_due_date >= due and seq_due_date <= due1)
         use-index seq_sequence
         break by seq_site by seq_line by seq_due_date by seq_priority
   with frame b:
      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


      if old_part = ? then old_part = seq_part.

      if old_part <> seq_part then do:

         find chg_mstr no-lock  where chg_mstr.chg_domain = global_domain and
         chg_site = seq_site
            and chg_line = seq_line
            and chg_from = old_part
            and chg_to = seq_part no-error.

         if not available chg_mstr then do:
            find chg_mstr no-lock  where chg_mstr.chg_domain = global_domain
            and  chg_site = seq_site
               and chg_line = seq_line
               and chg_from = ""
               and chg_to = seq_part no-error.
         end.

         changetime = 0.
         if available chg_mstr then changetime = chg_time.

         item_total = 0.
         old_part = seq_part.

      end.

      if page-size - line-counter < 3 then do with frame b:
         page.
         if first-of(seq_line)
         then do:
            display seq_site WITH STREAM-IO /*GUI*/ .
            down 1.
            display seq_line @ seq_site WITH STREAM-IO /*GUI*/ .
         end. /*IF FIRST-OF(seq_line)*/
         else do:
            display seq_site WITH STREAM-IO /*GUI*/ .
            down 1.
            display seq_line @ seq_site
                "(" + getTermLabel("CONTINUED",5) + ".)" @ seq_due_date WITH STREAM-IO /*GUI*/ .
         end. /*IF NOT FIRST-OF(seq_line)*/
         down 1.
      end.
      else if first-of (seq_line) then do with frame b:
         if not first (seq_site) then down 1.
         display seq_site WITH STREAM-IO /*GUI*/ .
         down 1.
         display seq_line @ seq_site WITH STREAM-IO /*GUI*/ .
      end.

      if changetime > 0 then do with frame b:

         display
            "(" + getTermLabel("CHANGEOVER",10) + " " +
        string(changetime,">>9.9<") + ")"  @ rps_part WITH STREAM-IO /*GUI*/ .
         down 1.
         changetime = 0.
      end.

      

      DISPLAY 
         
         /*SS - 111011.1 B*/
         seq__chr01 
         /*SS - 111011.1 E*/

         seq_priority
         seq_part @ rps_part
         seq_due_date
         seq_qty_req @ rps_qty_req
      with frame b STREAM-IO /*GUI*/ .

      

      item_total = item_total + seq_qty_req.
      pline_total = pline_total + seq_qty_req.
      daily_total = daily_total + seq_qty_req.

      find last lnd_det no-lock  where lnd_det.lnd_domain = global_domain and
      lnd_site = seq_site
         and lnd_line = seq_line
         and lnd_part = seq_part
         and lnd_start <= seq_due_date no-error.

      find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
      pt_part = seq_part no-error.

      hours = 0.
      if available lnd_det then do:
         if lnd_rate <> 0 then hours = seq_qty_req / lnd_rate.
         display lnd_rate @ ln_rate
            pt_um when (available pt_mstr) @ lnd_prod_um
         with frame b STREAM-IO /*GUI*/ .
      end.
      if not available lnd_det or lnd_rate = 0 then do:
         find ln_mstr no-lock  where ln_mstr.ln_domain = global_domain and
         ln_line = seq_line
            and ln_site = seq_site no-error.
         if available ln_mstr then
               display ln_rate with frame b STREAM-IO /*GUI*/ .
         if available ln_mstr and ln_rate <> 0 then
        hours = seq_qty_req / ln_rate.
      end.

      hours_total = hours_total + hours.

      display /*ts item_total */ hours with frame b STREAM-IO /*GUI*/ .

      if last-of (seq_due_date) then do with frame b:
         display daily_total hours_total WITH STREAM-IO /*GUI*/ .
         down 1.
         daily_total = 0.
         hours_total = 0.
      end.

      if last-of(seq_line) then do with frame b:
         underline daily_total.
         display
            getTermLabelRtColon("LINE_TOTAL",18) @ rps_part
            pline_total @ daily_total WITH STREAM-IO /*GUI*/ .

         pline_total = 0.
      end.

      down 1 with frame b.

   end. /* for each */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end. /* REPEAT */
{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 due due1 "} /*Drive the Report*/
