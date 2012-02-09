/* recrms.p - Repetitive create Master Schedule from Sequence File      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7.1.8 $                                                 */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.0   LAST MODIFIED 12/02/91    BY: SMM       *F230        */
/* REVISION: 7.0   LAST MODIFIED 04/07/92    BY: smm       *F366*       */
/* REVISION: 7.0   LAST MODIFIED 04/08/92    BY: smm       *F368        */
/* REVISION: 7.3   LAST MODIFIED 12/18/92    BY: emb       *G467*       */
/* REVISION: 7.3   LAST MODIFIED 08/09/93    BY: emb       *GE01*       */
/*                               10/12/93    BY: jzs       *GG27*       */
/* REVISION: 7.3   LAST MODIFIED 03/24/94    BY: pma       *GJ20*       */
/*                               08/27/94    BY: bcm       *GL62*       */
/* REVISION: 7.5   LAST MODIFIED 01/03/95    BY: mwd       *J034*       */
/*                               05/01/96    BY: jzs       *H0KR*       */
/* REVISION: 8.5      LAST MODIFIED: 10/24/96   BY: *J16V* Murli Shastri   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/* REVISION: 9.1      LAST MODIFIED: 08/19/99   BY: *N01B* John Corda      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/25/00   BY: *N0GD* Ganga Subramanian  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.1.5     BY: Katie Hilbert      DATE: 05/15/02  ECO: *P06H*  */
/* Revision: 1.7.1.6  BY: Seema Tyagi DATE: 01/28/03 ECO: *N24L* */
/* $Revision: 1.7.1.8 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.7.1.8 $ BY: Mage Chen     (SB) DATE: 09/12/06 ECO: *minth* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/************************************************************************/

{mfdtitle.i "2+ "}

/* PREPROCESSOR USED FOR REPORTS WITH SIMULATION OPTION */
&SCOPED-DEFINE simulation true

define variable site       like rps_site no-undo.
define variable site1      like rps_site no-undo.
define variable line       like rps_line no-undo.
define variable line1      like rps_line no-undo.
define variable part       like rps_part no-undo.
define variable part1      like rps_part no-undo.
define variable due        like rps_due_date no-undo.
define variable due1       like rps_due_date no-undo.
/*mage*/ define variable ptplan       like pt_buyer no-undo.

define variable msg1       as character format "x(12)" no-undo.
define variable update_yn  like mfc_logical initial yes
                           label "Update" no-undo.
define variable update-seq like mfc_logical
                           label "Delete Line Schedule" no-undo.
define variable um         like pt_um.
define variable desc2      like pt_desc2.
define variable rpsqtyreq  like rps_qty_req.

define variable l_desc1      like pt_desc1 no-undo.

define new shared workfile rp like rps_mstr.

form
   site       colon 23
   site1      colon 46 label {t001.i}
   line       colon 23
   line1      colon 46 label {t001.i}
   part       colon 23
   part1      colon 46 label {t001.i}
   due        colon 23
   due1       colon 46 label {t001.i}
   ptplan     colon 23 label "¼Æ»®Ô±"  /*minth*/
   skip(1)
   update_yn  colon 23
   update-seq colon 23
   skip(1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign
   msg1  = getTermLabel("CONT",12)
   site  = global_site
   site1 = global_site
   due   = today.

mainloop:
repeat:

   if due1  = hi_date then due1 = ?.
   if due   = low_date then due = ?.
   if part1 = hi_char then part1 = "".
   if site1 = hi_char then site1 = "".
   if line1 = hi_char then line1 = "".

   update
      site
      site1
      line
      line1
      part
      part1
      due
      due1
      ptplan    /*minth*/
      update_yn
      update-seq
   with frame a.

   bcdparm = "".

   {gprun.i ""gpquote.p"" "(input-output bcdparm,11,
        site, site1, line, line1, part, part1, string(due),
        string(due1), ptplan  string(update_yn), string(update-seq),
        null_char, null_char, null_char, null_char, null_char,
        null_char, null_char, null_char, null_char)"}   /*minth*/

   if due1  = ?  then due1  = hi_date.
   if due   = ?  then due   = low_date.
   if part1 = "" then part1 = hi_char.
   if site1 = "" then site1 = hi_char.
   if line1 = "" then line1 = hi_char.

   if not batchrun then do:
      {gprun.i ""gpsirvr.p""
         "(input site, input site1, output return_int)"}
      if return_int = 0 then do:
         next-prompt site with frame a.
         undo mainloop, retry mainloop.
      end.
   end.

   if update-seq and not update_yn
   then do:
      /* Line schedule will be deleted without update to repetitive */
      {pxmsg.i &MSGNUM=270 &ERRORLEVEL=2}
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
   {mfphead.i}

   /* Delete Repetitive Schedules not supported by the Line Schedule */	
/*minth*/   {gprun.i ""recrmsa.p""
      "(site, site1, line, line1, part, part1, due, due1, ptplan, update_yn)"}

/*minth*/   {gprun.i ""recrmsb.p""
      "(site, site1, line, line1, part, part1, due, due1, ptplan, update_yn,
        update-seq)"}

   /* Display Schedule Created */
   do for rp:
      form
         rps_part
         pt_desc1
         rps_rel_date
         rps_due_date
         rps_qty_comp column-label "Previous!Repetitive!Schedule"
         rps_qty_req  column-label "Production Line!Schedule"
         um
         rpsqtyreq    column-label "Resulting!Repetitive!Schedule"
      with frame b width 132 down
         no-attr-space no-box.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      for each rp
         exclusive-lock
             where rp.rps_domain = global_domain and  (rps_site >= site and
             rps_site <= site1)
              and (rps_line >= line and rps_line <= line1)
              and (rps_part >= part and rps_part <= part1)
            break by rps_site
                  by rps_line
                  by rps_part
                  by rps_due_date
         with frame b:

         do with frame c:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame c:handle).

            if first-of(rps_line)
            then do:

               if page-size - line-counter < 9
               then
                  page.

               display
                  rps_site
                  rps_line
               with frame c side-labels.

               find ln_mstr  where ln_mstr.ln_domain = global_domain and
               ln_line = rps_line
                            and   ln_site = rps_site no-error.

               if available ln_mstr
               then
                  display
                     ln_desc no-label
                  with frame c.

            end. /* IF FIRST-OF(rps_line) */

            if first-of(rps_part)
            then do:
               if page-size - line-counter < 9
               and not first-of (rps_line)
               then do:
                  page.
                  display
                     rps_site
                     rps_line
                     msg1 @ ln_desc
                  with frame c.
               end. /* IF page-size - line-counter < 9 */
               else do:
                  if not first-of(rps_line)
                  then
                     display
                        rps_site
                        rps_line
                        msg1 @ ln_desc no-label
                     with frame c .
               end. /* ELSE DO */

               display
                  rps_part.

               assign
                  um    = ""
                  desc2 = "".

               find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain
               and  pt_part = rps_part no-error.
               if available pt_mstr
               then do:
                  display
                     pt_desc1.

                  assign
                     um      = pt_um
                     l_desc1 = pt_desc1
                     desc2   = pt_desc2.
               end. /* IF AVAILABLE pt_mstr */

            end. /* IF FIRST-OF(rps_part) */

            if page-size - line-counter < 1
            then do:
               page.
               display
                  rps_site
                  rps_line
                  msg1 @ ln_desc
                  rps_part
                  l_desc1 @ pt_desc1
               with frame c.
            end. /* IF page-size - line-counter < 1 */

            if first-of(rps_part)
            then
               display
                  rps_part
                  l_desc1 @ pt_desc1
               with frame b.
            else
               display
                  rps_part
                  msg1 @ pt_desc1
               with frame b.

         end. /* DO WITH frame c */

         display
            rps_rel_date
            rps_due_date
            rps_qty_comp
            rps_qty_req um.

         display
            rps_qty_req @ rpsqtyreq.

         down 1.

         if first-of(rps_part)
         and desc2 > ""
         then do:
            if desc2 > ""
            then
               display desc2 @ pt_desc1.
            down 1.

            /*REAPPLY SCHEDULE CUMS COMPLETED*/
            /* IN ORDER TO AVOID STANDARD REPETITIVE USERS TO UPDATE
               REPETITIVE MASTER RECORDS BASED ON ADVANCED REPETITIVE
               LOGIC(CONSUME-EARLIEST-OPEN) THE CHECK FOR INSTALLATION
               OF ADVANCED REPETITIVE MODULE HAS BEEN INTRODUCED */

            if update_yn and can-find(mfc_ctrl  where mfc_ctrl.mfc_domain =
            global_domain and
               mfc_field = "rpc_using_new" and mfc_logical)
            then do:
               {gprun.i ""rerpmtb.p""
                  "(input rps_part, input rps_site, input rps_line)"}
            end. /* IF update_yn ... */

         end. /* IF FIRST-OF(rps_part) */

         delete rp.
      end. /* FOR EACH rp */

      {mfrtrail.i}
   end. /* DO for rp */
end. /* REPEAT */
