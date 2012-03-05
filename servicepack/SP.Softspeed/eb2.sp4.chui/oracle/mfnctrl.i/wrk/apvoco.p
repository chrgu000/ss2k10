/* apvoco.p - AP VOUCHER CONFIRMATION SINGLE VOUCHER                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.17.1.18 $                                                 */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST MODIFIED: 08/15/91   by: mlv *F002*                */
/*                                   10/11/91   by: dgh *D892*                */
/*                                   01/21/92   by: mlv *F083*                */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   by: mlv *G042*                */
/*                                   09/04/92   by: mlv *G046*                */
/*                                   11/24/92   by: bcm *G353*                */
/*                                   05/06/93   by: bcm *GA58*                */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   by: pcd *H039*                */
/*                                   10/15/93   by: jjs *H181*                */
/*                                   04/05/94   by: pcd *H323*                */
/*                                   09/21/94   by: srk *FR22*                */
/*                                   10/13/94   by: bcm *H564*                */
/*                                   02/03/95   by: str *F0GY*                */
/*                                   03/29/95   by: dzn *F0PN*                */
/*                                   04/24/95   by: wjk *H0CS*                */
/*                                   08/31/95   by: jzw *H0FR*                */
/* REVISION: 8.5      LAST MODIFIED: 11/01/95   by: mwd *J053*                */
/* REVISION: 8.6      LAST MODIFIED: 06/17/96   BY: bjl *K001*                */
/*                                   07/27/96   by: *J12H* M. Deleeuw         */
/*                                   11/19/96   by: jpm *K020*                */
/*                                   04/23/97   by: rxm *J1PH*                */
/* REVISION: 8.6      LAST MODIFIED: 07/24/97   BY: *H0ZY* Samir Bavkar       */
/* REVISION: 8.6      LAST MODIFIED: 09/18/97   BY: *H1FJ* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.16              */
/* REVISION: 9.0      LAST MODIFIED: 03/15/99   BY: *M0BG* Jeff Wootton       */
/* REVISION: 9.0      LAST MODIFIED: 05/08/99   BY: *J39W* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/12/00   BY: *L0XR* Falguni D.         */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N009* David Morris       */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 09/29/00   BY: *M0T8* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 08/04/00   BY: *N0W0* BalbeerS Rajput    */
/* Revision: 1.17.1.10     BY: Alok Thacker        DATE: 06/06/01 ECO: *M192* */
/* Revision: 1.17.1.11     BY: Seema Tyagi         DATE: 12/07/01 ECO: *M1R3* */
/* Revision: 1.17.1.12     BY: Patrick Rowan       DATE: 04/17/02 ECO: *P043* */
/* Revision: 1.17.1.15     BY: Samir Bavkar        DATE: 02/14/02 ECO: *P04G* */
/* Revision: 1.17.1.16     BY: Robin McCarthy      DATE: 07/15/02 ECO: *P0BJ* */
/* Revision: 1.17.1.17     BY: Manjusha Inglay     DATE: 07/29/02 ECO: *N1P4* */
/* $Revision: 1.17.1.18 $  BY: Mercy Chittilapilly DATE: 08/19/02 ECO: *N1RM* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*! --------------------------------------------------------------------------*
 * Version 8.6F Program Structure (of significant programs only):-
 *
 *  apvoco.p           Voucher Confirmation (Manual), menu 28.7
 *    apapgl.p         Control GL creation for AP vouchers
 *                     (also run by aprvvo.p, apvoco01.p, apvomt.p, apvomtk.p)
 *      apglpl.p       procedure apgl-create-all-glt
 *        gpglpl.p     procedure gpgl-convert-to-account-currency
 *        gpglpl.p     procedure gpgl-create-one-glt
 *      gpglvtst.i     Post to VAT Statistics account
 *    apvocsu1.p       Update Item Cost, create tr_hist and trgl_det
 *                     (also run from apvomtk3.p and apvoco01.p)
 *      apvotax.i      Inventory cost tax calculation
 *I     apvocsua.p     Update Item Cost, create tr_hist and trgl_det
 *
 *I = runs connected to inventory site database
 *----------------------------------------------------------------------------*
*/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "APVOCO.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvoco_p_1 "Amount Open"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* COMMON EURO VARIABLES */
{etvar.i &new = "new"}

{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

{gldydef.i new}
{gldynrm.i new}

define variable amt_open        like ap_amt label {&apvoco_p_1}.
define variable old_confirm     like mfc_logical no-undo.
define variable vopo            like vo_po.
define variable                 old_effdate like ap_effdate no-undo.

define new shared variable base_amt like vod_amt.
define new shared variable base_det_amt like vod_amt.
define new shared variable curr_amt like vod_amt.
define new shared variable vod_recno as recid.
define new shared variable ap_recno as recid.
define new shared variable vo_recno as recid.
define new shared variable vph_recno as recid.
define new shared variable prh_recno as recid.
define new shared variable undo_all like mfc_logical.
define new shared variable jrnl like glt_ref.
define new shared variable totinvdiff like ap_amt.
define new shared variable rcvd_open  like prh_rcvd.
define new shared variable rndmthd  like rnd_rnd_mthd.
define new shared variable old_curr like ap_curr.

/* SHARED VARIABLE DEL-YN NEEDED FOR PRM ROUTINE PJAPUPDT.P */
define new shared variable del-yn   like mfc_logical initial no.

define variable amt_open_fmt   as character no-undo.
define variable vo_holdamt_fmt as character no-undo.
define variable amt_open_old   as character no-undo.
define variable vo_holdamt_old as character no-undo.
define variable retval         as integer.

define variable old_hold_amt        like vo_hold_amt no-undo.
define variable fixed_rate_not_used like mfc_logical no-undo.
define variable l_entity_ok         like mfc_logical no-undo.
define variable l_batch             like ap_batch no-undo.
define variable use-log-acctg       as logical no-undo.
define variable log_charge_voucher like mfc_logical no-undo.

define buffer voddet for vod_det.

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

form
   vo_ref         colon 15 skip(1)
   ap_vend        colon 15 ad_name no-label
   ad_line1       at 17    no-label format "x(26)"
   ad_city        at 17    no-label
   ad_state                no-label skip(1)
   vopo           colon 15
   vo_recur       colon 60
   vo_invoice     colon 15
   vo_curr        colon 60
   ap_date        colon 15
   amt_open       colon 60          skip(2)
   vo_hold_amt    colon 15
   vo_confirmed   colon 15
   ap_effdate     colon 15
with frame b width 80 side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

assign
   amt_open_old   = amt_open:format in frame b
   vo_holdamt_old = vo_hold_amt:format in frame b.

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

find first gl_ctrl no-lock.
{&APVOCO-P-TAG1}

{&APVOCO-P-TAG2}

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

mainloop:
repeat:

   status input.
   do with frame b on error undo, retry:

      prompt-for vo_ref with frame b
      editing:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i vo_mstr vo_ref vo_ref vo_ref vo_ref vo_ref}
         if recno <> ? then do:
            find ap_mstr
               where ap_ref = vo_ref
               and ap_type = "VO"
               no-lock
               no-error.
            if not available ap_mstr then
               find ap_mstr
               where ap_ref = vo_ref
               and ap_type = "RV" no-lock.
            find ad_mstr where ad_addr = ap_vend no-lock no-error.

            find vd_mstr where vd_addr = ap_mstr.ap_vend
               no-lock no-error.
            if (available vd_mstr and vd_misc_cr) and
               ap_mstr.ap_remit <> ""
            then
               find first ad_mstr where ad_addr = ap_mstr.ap_remit
               no-lock no-error.

            if available ad_mstr then
            display
               ad_name
               ad_line1
               ad_city
               ad_state
            with frame b.

            if vo_recur then
               vopo = vo_po.
            else do:
               find first vpo_det where vpo_ref = vo_ref
                  no-lock no-error.
               vopo = if available vpo_det then vpo_po else "".
            end.

            if vo_curr <> old_curr or old_curr = "" then do:

               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input vo_curr,
                    output rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  pause 0.
                  undo mainloop, retry mainloop.
               end.

               /* GET CURRENCY-DEPENDENT FORMAT STRINGS */
               assign
                  amt_open_fmt = amt_open_old
                  vo_holdamt_fmt = vo_holdamt_old.
               {gprun.i ""gpcurfmt.p"" "(input-output amt_open_fmt,
                                         input rndmthd)"}
               {gprun.i ""gpcurfmt.p"" "(input-output vo_holdamt_fmt,
                                         input rndmthd)"}

               old_curr = vo_curr.
            end.

            assign
               amt_open:format    in frame b = amt_open_fmt
               vo_hold_amt:format in frame b = vo_holdamt_fmt.

            display
               vo_ref
               ap_vend
               vo_invoice
               vopo
               vo_recur
               ap_date
               (ap_amt - vo_applied) @  amt_open
               ap_effdate
               vo_curr
               vo_hold_amt
               vo_confirmed
            with frame b.
         end.
      end. /*PROMPT-FOR...EDITING */

      find vo_mstr where vo_ref = input vo_ref no-error.
      if not available vo_mstr then do:
         {pxmsg.i &MSGNUM=135 &ERRORLEVEL=3}
         undo.
      end.
      {&APVOCO-P-TAG3}
      find ap_mstr where ap_ref = vo_ref and ap_type = "VO"
         exclusive-lock
         no-error.

      if not available ap_mstr then
         find ap_mstr where ap_ref = vo_ref
         and ap_type = "RV" exclusive-lock.
      find ad_mstr where ad_addr = ap_vend no-lock no-error.

      assign
         vo_recno = recid(vo_mstr)
         ap_recno = recid(ap_mstr).

      find vd_mstr where vd_addr = ap_mstr.ap_vend no-lock no-error.
      if (available vd_mstr and vd_misc_cr) and
         ap_mstr.ap_remit <> ""
      then
         find first ad_mstr where ad_addr = ap_mstr.ap_remit
         no-lock no-error.

      if available ad_mstr then
      display
         ad_name
         ad_line1
         ad_city
         ad_state
      with frame b.
      find vd_mstr where vd_addr = ap_vend no-lock no-error.
      if available vd_mstr and vd_hold then do:
         {pxmsg.i &MSGNUM=162 &ERRORLEVEL=2}
         /*SUPPLIER ON PAYMENT HOLD*/
      end.

      if vo_recur then
         vopo = vo_po.
      else do:
         find first vpo_det where vpo_ref = vo_ref no-lock no-error.
         vopo = if available vpo_det then vpo_po else "".
      end.

      /* DETERMINE IF THIS IS A LOGISTICS CHARGE VOUCHER */
      log_charge_voucher = false.
      if use-log-acctg and available vo_mstr then do:
         for first vph_hist
         fields(vph_pvo_id)
         where vph_ref = vo_ref
         and can-find(first pvo_mstr where pvo_id = vph_pvo_id
                                      and pvo_lc_charge <> "")
         no-lock:
            log_charge_voucher = true.
         end.
      end. /* IF USE LOGISTICS ACCTNG AND AVAILABLE VO_MSTR */

      if vo_curr <> old_curr or old_curr = "" then do:

         /* GET ROUNDING METHOD FROM CURRENCY MASTER */
         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input vo_curr,
              output rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            pause 0.
            undo mainloop, retry mainloop.
         end.

         /* GET CURRENCY-DEPENDENT FORMAT STRINGS */
         assign
            amt_open_fmt   = amt_open_old
            vo_holdamt_fmt = vo_holdamt_old.
         {gprun.i ""gpcurfmt.p"" "(input-output amt_open_fmt,
                                   input rndmthd)"}
         {gprun.i ""gpcurfmt.p"" "(input-output vo_holdamt_fmt,
                                   input rndmthd)"}

         old_curr = vo_curr.
      end.

      assign
         amt_open:format    in frame b = amt_open_fmt
         vo_hold_amt:format in frame b = vo_holdamt_fmt.

      display
         vo_ref
         ap_vend
         vo_invoice
         vopo
         vo_recur
         (ap_amt - vo_applied) @ amt_open
         ap_date
         ap_effdate
         vo_curr
         vo_hold_amt
         vo_confirmed
      with frame b.

      old_confirm  = vo_confirmed.
      old_hold_amt = vo_hold_amt.

      {glenchk.i &entity=ap_mstr.ap_entity &entity_ok=l_entity_ok}
      if not l_entity_ok
      then do:
         next-prompt vo_ref with frame b.
         undo mainloop, retry mainloop.
      end. /* IF NOT l_entity_ok */

      setloop:
      do on error undo, retry:
         set
            vo_hold_amt
            vo_confirmed
         with frame b.

         if vo_confirmed = no and old_confirm then do:
            {pxmsg.i &MSGNUM=165 &ERRORLEVEL=3}
            /*CANNOT UNCONFIRM A PREVIOUSLY CONFIRMED VOUCHER*/
            next-prompt vo_confirmed.
            undo setloop, retry.
         end.

         if vo_hold_amt <> 0 then do:

            if (old_hold_amt <> vo_hold_amt) and
               (vo_amt_chg <> 0 or vo_disc_chg <> 0) then do:
               /* VOUCHER SELECTED FOR PAYMENT, MOD. NOT ALLOWED */
               {pxmsg.i &MSGNUM=2209 &ERRORLEVEL=3}
               next-prompt vo_hold_amt.
               undo setloop, retry.
            end. /* IF old_hold_amt <> vo_hold_amt */

            {gprun.i ""gpcurval.p"" "(input vo_hold_amt,
                                      input rndmthd, output retval)"}
            if retval <> 0 then do:
               next-prompt vo_hold_amt with frame b.
               undo setloop, retry setloop.
            end.
         end.

         if vo_hold_amt < 0 and ap_amt > 0 then do:
            /* HOLD AMOUNT CANNOT BE NEGATIVE FOR POSITIVE VOUCHER. */
            {pxmsg.i &MSGNUM=1244 &ERRORLEVEL=3}
            next-prompt vo_hold_amt.
            undo setloop, retry.
         end. /* IF vo_hold_amt < 0 AND ap_amt > 0 */

         if vo_hold_amt > 0 and ap_amt < 0 then do:
            /* HOLD AMOUNT CANNOT BE POSITIVE FOR NEGATIVE VOUCHER. */
            {pxmsg.i &MSGNUM=1245 &ERRORLEVEL=3}
            next-prompt vo_hold_amt.
            undo setloop, retry.
         end. /* IF vo_hold_amt > 0 AND ap_amt < 0 */

         if ap_amt > 0 then do:
            if vo_hold_amt > (ap_amt - vo_applied) then do:
               {pxmsg.i &MSGNUM=1243 &ERRORLEVEL=3}
               /*VOUCHER HOLD AMT MUST NOT EXCEED VOUCHER OPEN AMT*/
               next-prompt vo_hold_amt.
               undo setloop, retry.
            end.
         end.

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input vo_curr,
              input base_curr,
              input vo_ex_rate,
              input vo_ex_rate2,
              input vo_hold_amt,
              input true, /* ROUND */
              output vo_base_hold_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         if vo_recur = no then do:
            if old_confirm = no and vo_confirmed = yes then
            do on error undo, retry:

               /* CHECK THAT INVENTORY DATABASES ARE CONNECTED */
               if global_db <> "" then do:
                  for each vph_hist
                     fields /* (none) */
                     where vph_ref = vo_ref
                     no-lock,
                     each pvo_mstr
                     fields(pvo_internal_ref pvo_line)
                     where pvo_id = vph_pvo_id  and
                           pvo_lc_charge   = "" and
                           pvo_internal_ref_type = {&TYPE_POReceiver}
                     no-lock,
                     each prh_hist
                         fields(prh_site)
                        where prh_receiver = pvo_internal_ref
                          and prh_line = pvo_line
                     no-lock,
                     first si_mstr
                        fields(si_db)
                        where si_site = prh_site
                     no-lock
                     break by si_db:
                     if first-of(si_db)
                        and not connected(si_db) then do:
                        /* DATABASE si_db NOT AVAILABLE */
                        {pxmsg.i &MSGNUM=2510 &ERRORLEVEL=3
                                 &MSGARG1=si_db}
                        pause.
                        undo setloop, retry.
                     end.
                  end.
               end.

               old_effdate = ap_effdate.
               set
                  ap_effdate
               with frame b.

               /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
               {gpglef02.i &module = ""AP""
                  &entity = ap_entity
                  &date   = ap_effdate
                  &prompt = "ap_effdate"
                  &frame  = "b"}

               if base_curr <> vo_curr and ap_effdate <> old_effdate
               then do:
                  /*VALIDATE EXCHANGE RATE */

                  /* GET EXCHANGE RATE TO VALIDATE */
                  {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                     "(input vo_curr,
                       input base_curr,
                       input ap_ex_ratetype,
                       input ap_effdate,
                       output ap_ex_rate,
                       output ap_ex_rate2,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     next-prompt ap_effdate.
                     undo setloop, retry.
                  end.
                  /* DELETE RATE USAGE */
                  {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                     "(input ap_exru_seq)"}
                  /* GET EXCHANGE RATE, CREATE USAGE */
                  {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                     "(input vo_curr,
                       input base_curr,
                       input ap_ex_ratetype,
                       input ap_effdate,
                       output ap_ex_rate,
                       output ap_ex_rate2,
                       output ap_exru_seq,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     next-prompt ap_effdate.
                     undo setloop, retry.
                  end.

                  /* SPOT EXCHANGE RATE */

                  {gprunp.i "mcui" "p" "mc-ex-rate-input"
                     "(input vo_curr,
                       input base_curr,
                       input ap_effdate,
                       input ap_exru_seq,
                       input false,
                       input frame-row(b) + 10,
                       input-output ap_ex_rate,
                       input-output ap_ex_rate2,
                       input-output fixed_rate_not_used)"}

                  if keyfunction(lastkey) = "END-ERROR"
                  then
                     undo, retry.

                  if ap_ex_rate <> vo_ex_rate
                     or ap_ex_rate2 <> vo_ex_rate2
                  then do:
                     /* EXCHANGE RATE HAS CHANGED */
                     assign
                        vo_ex_rate = ap_ex_rate
                        vo_ex_rate2 = ap_ex_rate2.
                     /* DELETE VO RATE USAGE AND RE-COPY */
                     {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                        "(input vo_exru_seq)"}
                     {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                        "(input ap_exru_seq,
                          output vo_exru_seq)"}

                     /* RECALCULATE THE MASTER BASE AMOUNTS */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input vo_curr,
                          input base_curr,
                          input vo_ex_rate,
                          input vo_ex_rate2,
                          input ap_amt,
                          input true, /* ROUND */
                          output ap_base_amt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input vo_curr,
                          input base_curr,
                          input vo_ex_rate,
                          input vo_ex_rate2,
                          input vo_ndisc_amt,
                          input true, /* ROUND */
                          output vo_base_ndisc,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input vo_curr,
                          input base_curr,
                          input vo_ex_rate,
                          input vo_ex_rate2,
                          input vo_hold_amt,
                          input true, /* ROUND */
                          output vo_base_hold_amt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                     /* RECALCULATE THE DETAIL BASE AMOUNTS */
                     for each vod_det
                        where vod_ref = vo_ref
                        {&APVOCO-P-TAG4}
                        exclusive-lock:
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input vo_curr,
                             input base_curr,
                             input vo_ex_rate,
                             input vo_ex_rate2,
                             input vod_amt,
                             input true, /* ROUND */
                             output vod_base_amt,
                             output mc-error-number)"}.
                        if mc-error-number <> 0 then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                        end.
                     end. /* FOR EACH VOD_DET */

                  end. /* IF AP_EX_RATE <> VO_EX_RATE */
               end. /* IF BASE_CURR <> VO_CURR */
            end. /* IF OLD_CONFIRM = NO */
         end. /* IF VO_RECUR = NO */
      end. /* SETLOOP */

      /* CREATE GL TRANSACTIONS AND UPDATE 'CONFIRMED BY' FIELD */
      /* AND RUN APVOCSU1 TO UPDATE COSTS ON EACH INVENTORY ITEM */
      if old_confirm = no and vo_confirmed = yes
         and vo_recur = no
      then do:
         vo_conf_by = global_userid.

         /* UPDATE VOUCHER DETAIL RECORDS   */
         if not log_charge_voucher then do:
            {gprun.i ""apvomta4.p""}.
         end.
         else do:
            {gprunmo.i &module = "LA" &program = "apvolaa4.p"}
         end.

         for each vod_det where vod_ref = vo_ref no-lock:

            assign
               base_amt = vod_base_amt
               curr_amt = vod_amt.

            assign
               vod_recno = recid(vod_det)
               vo_recno = recid(vo_mstr)
               ap_recno = recid(ap_mstr)
               undo_all = yes
               base_det_amt = base_amt.

            if ap_batch <> l_batch then
            do:
               /* GET NEXT JOURNAL REFERENCE NUMBER  */
               {mfnctrl.i apc_ctrl apc_jrnl glt_det glt_ref jrnl}
               l_batch = ap_batch.
            end.

            {gprun.i ""apapgl.p""}

            do for voddet:

               find first voddet
                  where recid(voddet) = vod_recno
                  exclusive-lock no-error.
               if available voddet
               then
                  voddet.vod_dy_num = nrm-seq-num.

               release voddet.

            end. /* DO FOR voddet */

            if undo_all then undo mainloop, leave.
         end.

         /* UPDATE VENDOR BALANCES */
         find vd_mstr where vd_addr = ap_vend exclusive-lock
            no-error.

         base_amt = ap_base_amt - vo_base_applied.

         vd_balance = vd_balance + base_amt.

         if not log_charge_voucher then
            /* UPDATE COSTS ON EACH INVENTORY ITEM */
            for each vph_hist
               where vph_ref = vo_ref
                 and vph_pvod_id_line = 0
               exclusive-lock,
               each pvo_mstr
               where pvo_id = vph_pvo_id  and
                     pvo_lc_charge   = "" and
                     pvo_internal_ref_type = {&TYPE_POReceiver}
                     no-lock,
               each prh_hist
                  where prh_receiver = pvo_internal_ref
                   and prh_line = pvo_line
               no-lock:

                  vph_inv_date = ap_effdate.

               if prh_curr <> base_curr
               then do:
                  /* RECALCULATE VPH_INV_COST */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input vo_curr,
                       input base_curr,
                       input vo_ex_rate,
                       input vo_ex_rate2,
                       input vph_curr_amt,
                       input false,
                       output vph_inv_cost,
                       output mc-error-number)"}.
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF MC-ERROR-NUMBER <> 0  */
               end.    /* IF PRH_CURR <> BASE_CURR */

               assign
                  vo_recno = recid(vo_mstr)
                  ap_recno = recid(ap_mstr)
                  vph_recno = recid(vph_hist)
                  prh_recno = recid(prh_hist).

               /* APVOCSU1.P IS RUN FROM APVOMTK3.P, */
               /* APVOCO.P AND APVOCO01.P            */
               /* AND UPDATES COSTS FOR ONE ITEM.    */

               {gprun.i ""apvocsu1.p""}        /* COST UPDATE */

            end. /* FOR EACH VPH_HIST */
         else do:
            {gprunmo.i &module = "LA" &program = "apvocola.p"
                       &param  = """(buffer ap_mstr,
                                     buffer vo_mstr)"""}.
         end. /* IF LOGISTICS CHARGE VOUCHER */

      end. /* IF OLD_CONFIRM = NO AND VO_CONFIRMED = YES */
      clear frame b.
   end.
end. /*MAINLOOP*/
