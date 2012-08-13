/* GUI CONVERTED from glrccpy.p (converter v1.76) Tue May 13 02:36:18 2003 */
/* glrccpy.p - GENERAL LEDGER COPY RECURRING TRANSACTIONS                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.26 $                                                    */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 4.0          LAST MODIFIED:  10/17/88   By:  JMS   *A487*        */
/*                                        12/12/88   By:  RL    *C0028*       */
/* REVISION: 5.0          LAST MODIFIED:  06/13/89   BY:  JMS   *B066*        */
/*                                        07/19/89   by:  jms   *B154*        */
/*                                        12/14/89   BY:  MLB   *B452*        */
/*                                        04/26/90   BY:  emb   *B677*        */
/*                                        04/27/90   by:  jms   *B678*        */
/* REVISION: 6.0          LAST MODIFIED:  08/16/90   by:  jms   *D034*        */
/*                                        03/18/91   by:  jms   *D442*        */
/*                                        04/04/91   by:  jms   *D495*        */
/*                        LAST MODIFIED:  10/10/91   by:  dgh   *D892*        */
/* REVISION: 7.0          LAST MODIFIED:  11/06/90   by:  jms   *F058*        */
/*                                        02/11/92   by:  jms   *F193*        */
/*                                        03/24/92   by:  jms   *F313*        */
/* REVISION: 7.3          LAST MODIFIED:  12/18/92   by:  mpp   *G464*        */
/*                                        02/22/93   by:  mpp   *GD12*        */
/*                                        02/28/94   by:  jms   *FM48*        */
/*                                        04/04/94   by:  srk   *FN22*        */
/*                                        04/28/94   by:  srk   *FN77*        */
/*                                        09/03/94   by:  srk   *FQ80*        */
/* Oracle changes (share-locks)           09/11/94   BY:  rwl   *FR18*        */
/*                                        10/12/94   by:  str   *FS30*        */
/*                                        19/12/95   by:  mys   *G1GK*        */
/*                                        01/16/96   by:  mys   *G1K3*        */
/* REVISION: 8.6          LAST MODIFIED:  07/18/96   BY:  bjl   *K001*        */
/*       ORACLE PERFORMANCE FIX           11/21/96   BY:  rxm   *H0PS*        */
/*                                        01/06/97   BY:  jzw   *K04J*        */
/*                                        01/07/97   BY:  bjl   *K01S*        */
/*                                        01/27/97   by:  bkm   *J1G1*        */
/*                                        02/17/97   by: *K01R* E.Hughart     */
/*                                        03/04/97   by:  bkm   *K06R*        */
/*                                        03/11/97   by: *K076* M. Madison    */
/* REVISION: 8.6        LAST MODIFIED: 10/16/97   BY: *H1G1* Irine D'mello    */
/* REVISION: 8.6E       LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E       LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E       LAST MODIFIED: 06/30/98   BY: *L01J* Mansour Kazemi   */
/* REVISION: 9.1        LAST MODIFIED: 08/04/99   BY: *N014* Patti Gaultney   */
/* REVISION: 9.1        LAST MODIFIED: 10/26/99   BY: *J3M9* Atul Dhatrak     */
/* REVISION: 9.1        LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1        LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.23      BY: Jean Miller          DATE: 05/15/02   ECO: *P05V*  */
/* Revision: 1.24     BY: Manjusha Inglay     DATE: 08/16/02  ECO: *N1QP*  */
/* Revision: 1.25     BY: Ed van de Gevel  DATE: 02/12/03 ECO: *N26L*      */
/* $Revision: 1.26 $    BY: Narathip W.      DATE: 04/30/03 ECO: *P0QX*      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}
{cxcustom.i "GLRCCPY.P"}

{gldydef.i new}
{gldynrm.i new}

{&GLRCCPY-P-TAG1}

define variable dyentity  like gltr_entity no-undo.
define variable glname    like en_name.
define variable newref    like glt_ref label "New GL Reference".
define variable ref       like gltr_ref label "GL Reference to Copy".
define variable eff_dt    like gltr_eff_dt initial today
   label "New Effective Date".
define variable per_yr    as character format "x(7)" label "Period".
define variable xamt      like glt_amt.
define variable account   as character format "x(22)" label "Account".
define variable desc1     like glt_desc format "x(12)".
define variable entity_ok like mfc_logical.
define variable rev_dt    like gltr_eff_dt label " New Reversal Date".
define variable per1      like glc_per.
define variable yr1       like glc_year.
define variable per_yr1   as character format "x(7)" label "Period".
define variable save_type like gltr_tr_type.
define variable encurr    like en_curr.
define variable jlnbr     as integer.
define variable corr-flag    like gltr_correction no-undo.
define variable co_daily_seq like mfc_logical.
define variable l_ref        like glt_ref no-undo.

/* GET MFC_CTRL FIELD co_daily_seq, ADD IF NECESSARY */
{glmfcctl.i}

/* GET NAME OF PRIMARY ENTITY */
find en_mstr where en_entity = current_entity no-lock no-error.
if not available en_mstr then do:
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
   pause.
   leave.
end.
else do:
   assign
      glname = en_name
      encurr = en_curr.
   release en_mstr.
end.

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

/* DEFINE FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
space(1)
   ref
         view-as fill-in size 14 by 1   
   newref
         view-as fill-in size 14 by 1   
   skip
   space(1)
   dft-daybook
   nrm-seq-num
   skip
   space(1)
   eff_dt
   per_yr
   corr-flag
   skip
   space(1)
   rev_dt
   per_yr1
with side-labels frame a width 80 attr-space
 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = glname.
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

mainloop:
repeat:

   /* DISPLAY FORM */
   view frame a.
   status input.

   /* INPUT TRANSACTION REFERENCE TO BE COPIED */
   prompt-for ref with frame a
   editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i gltr_hist ref gltr_ref ref gltr_ref gltr_ref}
      if recno <> ? then do:
         ref = gltr_ref.
         find last gltr_hist where gltr_ref = ref no-lock no-error.
         assign dft-daybook = gltr_dy_code
            nrm-seq-num = gltr_dy_num
            corr-flag   = gltr_correction.
         display ref
            dft-daybook nrm-seq-num corr-flag
         with frame a.
         recno = ?.
      end.

   end.

   assign ref.

   /* FIND TRANSACTION TO BE COPIED */
   find last gltr_hist where gltr_ref = ref no-lock no-error.
   if not available gltr_hist then do:
      /* Transaction reference not found */
      {pxmsg.i &MSGNUM=3054 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.

   /* Set up suitable defaults. */
   assign
      dft-daybook = gltr_dy_code
      nrm-seq-num = ""
      corr-flag   = gltr_correction.

   /* VALIDATE TYPE OF TRANSACTION */
   if gltr_tr_type <> "JL" and gltr_tr_type <> "RV" then do:
      /* CAN ONLY COPY JL AND RV TRANSACTIONS */
      {pxmsg.i &MSGNUM=3148 &ERRORLEVEL=3}
      undo mainloop, retry.
   end.

   save_type = gltr_tr_type.

   do transaction on error undo mainloop, retry
                  on endkey undo mainloop, retry:

      run ip-get-reference.

      repeat:

         if not can-find(first glt_det where glt_ref = newref) and
            not can-find(first gltr_hist where gltr_ref = newref)
         then do:

            create glt_det.
            assign
               glt_ref = newref
               glt_rflag   = false
               {&GLRCCPY-P-TAG3}
               glt_userid = global_userid
               glt_tr_type = "**".

            if recid(glt_det) = -1 then .

            release glt_det.
            leave.

         end.

         else
         if co_daily_seq then
            newref = substring(newref,1,8) +
                     string(integer(substring(newref,9,6)) + 1, "999999").
         else
            newref = substring(newref,1,5) +
                     string(integer(substring(newref,6,9)) + 1, "999999999").

      end. /* REPEAT */

      /* VALIDATE ACCOUNTS TO BE COPIED */
      for each gltr_hist where gltr_ref = ref no-lock:
         find ac_mstr where ac_code = gltr_acc no-lock no-error.
         if available ac_mstr then do:
            if not ac_active then do:
               /* Inactive account */
               {pxmsg.i &MSGNUM=3136 &ERRORLEVEL=3 &MSGARG1=gltr_acc}
               undo mainloop, retry.
            end.
            find sb_mstr where sb_sub = gltr_sub no-lock.
            if not sb_active then do:
               /* Inactive sub-account */
               {pxmsg.i &MSGNUM=3137 &ERRORLEVEL=3 &MSGARG1=gltr_sub}
               undo mainloop, retry.
            end.
            find cc_mstr where cc_ctr = gltr_ctr no-lock.
            if not cc_active then do:
               /* Inactive cost cneter */
               {pxmsg.i &MSGNUM=3138 &ERRORLEVEL=3 &MSGARG1=gltr_ctr}
               undo mainloop, retry.
            end.
         end.

         /* CHECK ENTITY SECURITY */
         {glenchk.i &entity=gltr_entity &entity_ok=entity_ok}
         if not entity_ok then undo mainloop, retry.

         dyentity = gltr_entity.

      end.

      /* SAVE SYSTEM GENERATED GL REFERENCE INTO L_REF TO DELETE */
      /* THE HOLD RECORD IF NEW GL REFERENCE IS ENTERED BY USER  */
      assign
         l_ref = newref.

      /* INPUT VARIABLES */
      display
         newref
         eff_dt
         dft-daybook
         nrm-seq-num
         corr-flag
      with frame a.

      seta:
      do on error undo, retry:

         set
            newref when (co_daily_seq)
            dft-daybook when (daybooks-in-use)
            eff_dt
         with frame a.

         if substring(newref, 1, 2) <> save_type then do:
            {pxmsg.i &MSGNUM=3534 &ERRORLEVEL=3}
            /* SOURCE AND DESTINATION TRANSACTION TYPES MUST MATCH */
            undo, retry seta.
         end.

         if substring(newref, 1, 2) <> "JL" and
            substring(newref, 1, 2) <> "RV"
         then do:
            {pxmsg.i &MSGNUM=3148 &ERRORLEVEL=3}
            /* CAN ONLY ADD JL TRANSACTIONS */
            undo, retry seta.
         end.

         /* CHECK POSTED TRANSACTIONS FOR SAME REFERENCE */
         if can-find(first gltr_hist where gltr_ref = newref) then do:
            {pxmsg.i &MSGNUM=3066 &ERRORLEVEL=3}
            /* REFERENCE ALREADY IN USE BY A POSTED TRANSACTION */
            undo, retry seta.
         end.

         find first glt_det where glt_ref = newref and
                                  glt_tr_type <> "**"
         no-lock no-error.
         if available glt_det then do:
            {pxmsg.i &MSGNUM=3066 &ERRORLEVEL=3}
            /* REFERENCE ALREADY IN USE BY A POSTED TRANSACTION */
            undo, retry seta.
         end.

         if eff_dt = ? then eff_dt = today.

         display eff_dt with frame a.

         /* VALIDATE PERIOD AND YEAR */
         {glper1.i eff_dt per_yr} /* GET PERIOD/YEAR */

         if per_yr = "" then do:
            /* Invalid Period/Year */
            {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3}
            next-prompt eff_dt with frame a.
            undo seta, retry.
         end.

         assign
            per1 = glc_per + 1
            yr1 = glc_year.

         display per_yr with frame a.

         /* Verify that the daybook is valid. */
         if daybooks-in-use and dft-daybook > "" then do:

            if not can-find(dy_mstr where dy_dy_code = dft-daybook)
            then do:
               /* Invalid Daybook */
               {pxmsg.i &MSGNUM=1299 &ERRORLEVEL=3}
               next-prompt dft-daybook with frame a.
               undo seta, retry.
            end.

            else do:

               /* Added doc trans and entity parameters */
               {gprun.i ""gldyver.p""
                  "(input substring(newref,1,2),
                    input """",
                    input dft-daybook,
                    input dyentity,
                    output daybook-error)"}

               if daybook-error then do:
                  {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
                  /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
                  pause.
               end. /* if daybook-error */

               {gprunp.i "nrm" "p" "nr_can_dispense"
                  "(input dft-daybook,
                    input eff_dt)"}

               {gprunp.i "nrm" "p" "nr_check_error"
                  "(output daybook-error,
                    output return_int)"}

               if daybook-error then do:
                  {pxmsg.i &MSGNUM=return_int &ERRORLEVEL=3}
                  next-prompt dft-daybook with frame a.
                  undo seta, retry.
               end.

            end. /* ELSE DO */

         end. /* IF DAYBOOKS IN USE */

         for each gltr_hist where gltr_ref = ref no-lock:

            /* Check for closed period */
            {glper.i eff_dt per_yr gltr_entity}

            if glcd_yr_clsd = yes then do:
               /* Year has been closed */
               {pxmsg.i &MSGNUM=3022 &ERRORLEVEL=3}
               next-prompt eff_dt with frame a.
               undo seta, retry.
            end.

            if glcd_gl_clsd = yes then do:
               /* Period has been closed */
               {pxmsg.i &MSGNUM=3023 &ERRORLEVEL=3}
               next-prompt eff_dt with frame a.
               undo seta, retry.
            end.

         end.

         if substring(newref, 1, 2) = "RV" then do:

            /* CALCULATE PERIOD AND YEAR FOR REVERSAL DATE */
            find first glc_cal where glc_per = per1 and glc_year = yr1
            no-lock no-error.

            if not available glc_cal then do:
               per1 = 1.
               yr1 = yr1 + 1.
               find first glc_cal where glc_per = per1 and
                  glc_year = yr1 no-lock no-error.
               if not available glc_cal then do:
                  {pxmsg.i &MSGNUM=3050 &ERRORLEVEL=3}
                  /* NO VALID PERIOD/YEAR FOR REVERSAL ENTRY */
                  next-prompt eff_dt with frame a.
                  undo seta, retry.
               end.
            end.

            rev_dt = glc_start.
            display rev_dt with frame a.

            for each gltr_hist where gltr_ref = ref no-lock:

               /* Check for closed period */
               {glper.i rev_dt per_yr1 gltr_entity}

               if glcd_yr_clsd = yes then do:
                  {pxmsg.i &MSGNUM=3022 &ERRORLEVEL=3}
                  /* YEAR HAS BEEN CLOSED */
                  next-prompt eff_dt with frame a.
                  undo seta, retry.
               end.

               if glcd_gl_clsd = yes then do:
                  {pxmsg.i &MSGNUM=3023 &ERRORLEVEL=3}
                  /* PERIOD HAS BEEN CLOSED */
                  next-prompt eff_dt with frame a.
                  undo seta, retry.
               end.

            end.

            display per_yr1 with frame a.

         end.

         else display "" @ rev_dt "" @ per_yr1 with frame a.

      end.

      /* OUTPUT DESTINATION SELECTION */
      {gpselout.i &printType = "terminal"
                  &printWidth = 80
                  &pagedFlag = " "
                  &stream = " "
                  &appendToFile = " "
                  &streamedOutputToTerminal = " "
                  &withBatchOption = "no"
                  &displayStatementType = 1
                  &withCancelMessage = "yes"
                  &pageBottomMargin = 6
                  &withEmail = "yes"
                  &withWinprint = "yes"
                  &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


      /* DISPENSE DAYBOOK ENTRY NUMBER */
      if daybooks-in-use then do:

         {gprunp.i "nrm" "p" "nr_dispense"
            "(input dft-daybook,
              input eff_dt,
              output nrm-seq-num)"}

         /* IF THERE'S SOMETHING TO COPY,    */
         /* DISPLAY NEW DAYBOOK ENTRY NUMBER */
         if can-find (first gltr_hist where gltr_ref = ref) then
            display
               nrm-seq-num
            with frame a.

      end.

      /* CREATE TRANSACTION */
      for each gltr_hist where gltr_ref = ref no-lock
      break by gltr_ref
      on endkey undo mainloop, retry
      on error undo mainloop, retry
      with down frame b width 80:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         create glt_det.
         assign
            glt_ref = newref
            glt_line = gltr_line
            glt_entity = gltr_entity
            glt_effdate = eff_dt
            glt_tr_type = gltr_tr_type
            glt_date = today
            {&GLRCCPY-P-TAG4}
            glt_ex_rate = gltr_ex_rate
            glt_ex_rate2 = gltr_ex_rate2
            glt_ex_ratetype = gltr_ex_ratetype
            glt_acc = gltr_acc
            glt_sub = gltr_sub
            glt_cc = gltr_ctr
            glt_project = gltr_project
            glt_amt = gltr_amt * ( - 1) /*james*/
            glt_batch = gltr_batch
            glt_desc = gltr_desc
            glt_unb = no
            glt_userid = global_userid
            glt_doc = newref
            glt_curr_amt = gltr_curramt * ( - 1) /*james*/
            glt_rflag   = gltr_rflag
            glt_user1 = gltr_user1
            glt_user2 = gltr_user2
            glt_correction = gltr_correction
            glt_dy_code = dft-daybook
            glt_dy_num = nrm-seq-num
            glt_curr = gltr_curr.

         {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
            "(input gltr_exru_seq,
              output glt_exru_seq)"}

         if gltr_exru_seq <> gltr_en_exru_seq then do:
            {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
               "(input gltr_exru_seq,
                 output glt_en_exru_seq)"}
         end.

         else
            glt_en_exru_seq = glt_exru_seq.

         if glt_rflag then glt_effdate = rev_dt.

         if base_curr = encurr then do:
            assign
               glt_ecur_amt = glt_amt
               glt_en_exrate = glt_ex_rate
               glt_en_exrate2 = glt_ex_rate2
               glt_en_exru_seq = glt_exru_seq.
         end.

         else if encurr = gltr_curr then do:
            assign
               glt_ecur_amt = glt_curr_amt
               glt_en_exrate = 1
               glt_en_exrate2 = 1
               glt_en_exru_seq = 0.
         end.

         {&GLRCCPY-P-TAG2}

         /* DISPLAY TRANSACTION */
         if glt_curr <> base_curr then
            xamt = glt_curr_amt.
         else
            xamt = glt_amt.

         {glacct.i &acc=glt_acc &sub=glt_sub &cc=glt_cc &acct=account}
         desc1 = glt_desc.

         display
            glt_line
            account
            glt_project
            glt_entity
            desc1
            xamt
            glt_curr with frame b STREAM-IO /*GUI*/ .

         accumulate gltr_amt (total).

         /* DISPLAY TOTAL */
         if last-of(gltr_ref) then do:
            underline xamt with frame b.
            display (accum total gltr_amt) @ xamt base_curr @ glt_curr
            with frame b STREAM-IO /*GUI*/ .
         end.

      end. /* FOR EACH GLTR_HIST */

      /* END OF LIST MESSAGE */
      {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

      {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

      /* DELETE HOLD RECORD */
      find glt_det where glt_ref     = l_ref and
                         glt_tr_type = "**"
      exclusive-lock no-error.
      if available glt_det then delete glt_det.

   end. /* DO TRANSACTION */

end.  /* MAINLOOP REPEAT */

status input.

PROCEDURE ip-get-reference:
   /*  GET NEXT REFERENCE NUMBER */
   if co_daily_seq then
      newref = gltr_hist.gltr_tr_type +
               substring(string(year(today),"9999"),3,2) +
                         string(month(today),"99") +
                         string(day(today),"99").
   else
      newref = gltr_hist.gltr_tr_type.

   find last glt_det where glt_ref >= newref and
                           glt_ref <= newref + fill(hi_char,14)
   no-lock no-error.

   find last gltr_hist no-lock
      where gltr_ref >= newref
        and gltr_ref <= newref + fill(hi_char,14)
   no-error.

   if co_daily_seq then do: /* IF DAILY */

      assign
         newref = max(newref + string(0, "999999"),
                  max(if available glt_det then glt_ref else "",
                      if available gltr_hist then gltr_ref else ""))
         jlnbr = 0.

      do on error undo, leave:
         jlnbr = integer(substring(newref, 9, 6)).
      end.

      hide message no-pause.

      newref = save_type                                 +
               substring(string(year(today),"9999"),3,2) +
                         string(month(today),"99")       +
                         string(day(today),"99")         +
                         string((jlnbr + 1),"999999").

   end. /* IF CO_DAILY_SEQ */

   else do: /* IF CONTINUOUS */
      assign
         newref = max(newref + string(0,"999999999999"),
                  max(if available glt_det then glt_ref else "",
                      if available gltr_hist then gltr_ref else ""))
         jlnbr = 0.

      do on error undo, leave:
         jlnbr = integer(substring(newref,6,9)).
      end.

      hide message no-pause.

      /* DUE TO INTEGER LIMITATIONS, CAN ONLY INCREMENT THE */
      /* LAST 9 DIGITS OF THE REFERENCE NUMBER              */
      newref = save_type +
               substring(newref,3,3) + string(integer(jlnbr  + 1),"999999999").

   end. /* IF CONTINUOUS */

END PROCEDURE.
