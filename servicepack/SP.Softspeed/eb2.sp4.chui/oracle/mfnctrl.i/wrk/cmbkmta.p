/* cmbkmta.p - ENTER CASH BOOK TRANSACTION LINES                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.18.1.24 $                                                */
/*V8:ConvertMode=Maintenance                                              */
/* THIS PROGRAM WAS SPLIT OUT FROM CMBKMT.P BECAUSE OF COMPILE LIMITS     */
/* REVISION: 8.5      LAST MODIFIED: 02/25/96   BY: sxb *J053*            */
/* REVISION: 8.6      LAST MODIFIED: 02/17/97   BY: *K01R*  E. Hughart    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 03/30/98   BY: *J2FT* Samir Bavkar   */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton   */
/* REVISION: 8.6E     LAST MODIFIED: 07/25/98   BY: *L04N* Jim Josey      */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/98   BY: *H1L8* Jim Josey      */
/* REVISION: 8.6E     LAST MODIFIED: 09/14/98   BY: *L07G* Joanne Kurtzer */
/* REVISION: 9.1      LAST MODIFIED: 06/08/99   BY: *N00G* Jean Miller    */
/* REVISION: 9.1      LAST MODIFIED: 06/23/99   BY: *L0F9* Ranjit Jain    */
/* REVISION: 9.1      LAST MODIFIED: 07/12/99   BY: *N00D* Adam Harris    */
/* REVISION: 9.1      LAST MODIFIED: 12/27/99   BY: *L0MT* Jose Alex      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/11/00   BY: *L0V6* Rajesh Lokre   */
/* REVISION: 9.1      LAST MODIFIED: 06/20/00   BY: *N0DB* Mudit Mehta    */
/* REVISION: 9.1      LAST MODIFIED: 08/09/00   BY: *N0J7* Veena Lad      */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *L127* Shilpa Athalye */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn            */
/* REVISION: 9.1      LAST MODIFIED: 01/03/01   BY: *M0Y4* Jose Alex      */
/* REVISION: 9.1      LAST MODIFIED: 10/21/00   BY: *N0VY* BalbeerS Rajput*/
/* REVISION: 9.0 LAST MODIFIED: 20 FEB 2001 BY: *N0X7* Ed van de Gevel    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* Revision: 1.18.1.2.3.6  BY: Alok Thacker    DATE: 06/12/01 ECO: *M18Y* */
/* Revision: 1.18.1.17.2.2 BY: Ed van de Gevel DATE: 06/29/01 ECO: *N0ZX* */
/* Revision: 1.18.1.20     BY: Geeta Kotian    DATE: 08/29/01 ECO: *L19K* */
/* Revision: 1.18.1.21     BY: Ed van de Gevel DATE: 11/09/01 ECO: *N15L* */
/* Revision: 1.18.1.22     BY: Saurabh C.      DATE: 02/14/02 ECO: *M1VP* */
/* Revision: 1.18.1.23     BY: Ed van de Gevel DATE: 04/17/02 ECO: *N1GR* */
/* $Revision: 1.18.1.24 $  BY: Hareesh V.     DATE: 06/11/02 ECO: *M1Z9* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "CMBKMTA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE cmbkmta_p_1 "Year"
/* MaxLen: Comment: */

&SCOPED-DEFINE cmbkmta_p_2 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE cmbkmta_p_3 "Statement"
/* MaxLen: Comment: */

&SCOPED-DEFINE cmbkmta_p_5 "Book Balance"
/* MaxLen: Comment: */

&SCOPED-DEFINE cmbkmta_p_6 "Bank Balance"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define shared variable corr-flag like glt_correction.

define input parameter bkcurr     like bk_curr.
define input parameter batch_ctrl like ba_ctrl.
define input parameter bkcurr_rndmthd like rnd_rnd_mthd.

define variable cbamt_fmt         as character no-undo.
define variable cbamt_old         as character no-undo.
define variable cb_curramt_fmt    as character no-undo.
define variable cb_curramt_old    as character no-undo.
define variable cb_curramt_bkfmt  as character no-undo.
define variable del-yn            like mfc_logical initial no.
define variable yn                like mfc_logical.
define variable line              like cb_line.
define variable last_line         like cb_line.
define variable type              like cb_type.
define variable cb_rndmthd        like rnd_rnd_mthd no-undo.
define variable old_cbcurr        like cb_curr no-undo.
define variable end_bal           like ba_ctrl.
define variable batch             as integer format "9999".
define variable year1             as integer format "9999".
define variable retval            as integer.
define variable jlnbr             as integer             no-undo.
define variable glt_recno         as recid               no-undo.
define variable l_flag            like mfc_logical       no-undo.
define variable ctr_no            as integer             no-undo.

define new shared variable co_daily_seq like mfc_logical no-undo.
define new shared variable ref          like glt_ref     no-undo.
define new shared variable new_glt      like mfc_logical no-undo.
define new shared variable cash_book    like mfc_logical initial yes.
define new shared variable l_ar_base_amt like ar_base_amt no-undo.
define     shared variable bank_bank    like bk_code.
define     shared variable bank_ctrl    like ap_amt.
define     shared variable bank_b_ctrl  like ap_amt.
define     shared variable bank_batch   like cb_batch.
define     shared variable bank_ex_rate like cb_ex_rate.
define     shared variable bank_ex_rate2 like cb_ex_rate2.
define     shared variable bank_ex_ratetype like cb_ex_ratetype.
define     shared variable bank_exru_seq    like cb_exru_seq.
define     shared variable bank_curr    like bkcurr.
define     shared variable bank_date    like ba_date.
define     shared variable jrnl         like glt_ref.
define     shared variable arjrnl       like glt_ref.
define     shared variable arbatch      like ar_batch.
define     shared variable b_batch      like cb_batch.
define     shared variable b_line       like cb_line.
define     shared variable arnbr        like ar_nbr.
define     shared variable barecid      as recid.
define     shared variable new_line     like mfc_logical.
define     shared variable del_cb       like mfc_logical.
define     shared variable undo_all     like mfc_logical.
define     shared variable h-arpamtpl   as handle no-undo.
define     shared variable l_batch_err  like mfc_logical no-undo.

define variable mc-error-number         like msg_nbr no-undo.
define variable dummy_fixed_rate        as logical   no-undo.
define variable valid_curr              as logical   no-undo.
define variable disp_char1              as character format "x(45)" no-undo.
define variable l_ctrl_pip              like apc_pip no-undo.
define     shared frame a.

disp_char1 = getTermLabel("NU_NOT_USED_UB_UNBALANCED_C_CLOSED",45).

form
   bank_bank    colon 14
   year1        colon 24 label {&cmbkmta_p_1}
   batch        colon 41 label {&cmbkmta_p_3}
   bk_desc      no-label at 10
   bk_bk_acct1  no-label format "x(24)"
   bkcurr       no-label
   ba_status    colon 14
   disp_char1   no-label
   ba_date      colon 14
   ba_beg_bal   colon 14 label {&cmbkmta_p_5}
   end_bal      colon 54 label {&cmbkmta_p_6}
   batch_ctrl   colon 14
   ba_total     colon 54 label {&cmbkmta_p_2}
with side-labels frame a width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&CMBKMTA-P-TAG1}

form
   line format ">>9" space(3)
   type
   cb_amt
   cb_curr
   cb_curr_amt
with frame c width 80 down retain 1.
{&CMBKMTA-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

find ba_mstr where recid(ba_mstr) = barecid no-lock.

/* FIND bk_mstr RECORD FOR CUURENT TRANSACTION */
for first bk_mstr
   fields (bk_bk_acct1 bk_code bk_desc bk_entity)
   where bk_code = bank_bank
   no-lock:
end. /* FOR FIRST bk_mstr */

/* FIND 'USE PAYMENT IN PROCESS ACCT' FLAG VALUE FROM apc_ctrl */
for first apc_ctrl
   fields(apc_jrnl apc_pip)
   no-lock:
end. /* FOR FIRST apc_ctrl */

/* IF apc_ctrl IS NOT AVAILABLE CREATE WITH DEFAULT VALUES */
if not available apc_ctrl
then do transaction:
   create apc_ctrl.
   if recid(apc_ctrl) = -1
   then .
end. /* IF NOT AVAILABLE apc_ctrl */

/* STORING 'USE PAYMENT IN PROCESS' FLAG VALUE INTO LOCAL VARIABLE */
l_ctrl_pip = apc_pip.

release apc_ctrl.

/* INITIALIZE CURRENCY DEPENDENT ROUNDING VARIABLES  */
/* CAPTURE ORIGINAL DATABASE FORMATS INTO _OLD FORMAT FIELDS. */
assign
   cb_curramt_old   = cb_curr_amt:format
   cbamt_old        = cb_amt:format
   cb_curramt_bkfmt = cb_curr_amt:format.

/* DETAIL LINE 'AMOUNT' FIELD REFLECTS THE AMOUNT OF THE CASH  */
/* BOOK LINE IN TERMS OF THE CURRENCY OF THE BANK.  SET        */
/* CURRENCY DEPENDENT FORMAT OF 'CB_AMT' NOW, BASED ON BK_CURR */
cbamt_fmt = cbamt_old.
{gprun.i ""gpcurfmt.p""  "(input-output cbamt_fmt,
     input bkcurr_rndmthd)"}
cb_amt:format = cbamt_fmt.

/* CB_CURR IS INITIALIZED TO BK_CURR.  INITIALIZE BK_CURR_AMT */
/* FORMAT VARIABLE 'CB_CURRAMT_BKFMT' TO REFLECT THE DEFAULT  */
/* BANK CURRENCY FORMAT                                       */
cb_curramt_bkfmt = cb_curramt_old.
{gprun.i ""gpcurfmt.p""  "(input-output cb_curramt_bkfmt,
     input bkcurr_rndmthd)"}

loopc:
repeat:
   view frame dtitle.
   find last cb_mstr where cb_batch = ba_batch no-lock no-error.
   if available cb_mstr then last_line = cb_line.
   else last_line = 0.
   clear frame c all.

   assign
      cb_rndmthd = bkcurr_rndmthd
      old_cbcurr = bkcurr.

   for each cb_mstr where cb_batch = ba_batch no-lock with frame c:
      {&CMBKMTA-P-TAG35}
      /* GET TRANSACTION CURRENCY DISPLAY FORMAT */
      run p-trans-curr-format.
      {&CMBKMTA-P-TAG29}

      assign
         cb_curr_amt:format =
         if cb_curr <> bkcurr then cb_curramt_fmt
         else cb_curramt_bkfmt
         cb_amt:format      = cbamt_fmt.

      display
         cb_line @ line
         cb_type @ type
         cb_curr
         cb_amt
         cb_curr_amt.
      {&CMBKMTA-P-TAG3}

      down.
   end. /* FOR EACH CB_MSTR */

   loopc1:
   repeat with frame c on endkey undo, leave:
      line = last_line + 1.
      type = "".
      update line
         editing:
         {mfnp01.i cb_mstr line cb_line ba_batch cb_batch cb_batch}
         if recno <> ? then do:
            cb_amt:format = cbamt_fmt.

            display
               cb_line @ line
               cb_type @ type
               cb_amt
               cb_curr.
            {&CMBKMTA-P-TAG4}

         end. /* IF RECNO <> ? */
      end. /* UPDATE LINE EDITING */
      if line = 0 or input line = ? then
         undo loopc1 , next loopc1.

      find first cb_mstr where cb_line = line and
         cb_batch = ba_batch no-lock no-error.
      if available cb_mstr then do:

         /* GET TRANSACTION CURRENCY DISPLAY FORMAT */
         run p-trans-curr-format.

         {&CMBKMTA-P-TAG30}
         assign
            cb_curr_amt:format =
            if cb_curr <> bkcurr then cb_curramt_fmt
            else cb_curramt_bkfmt
            cb_amt:format      = cbamt_fmt.

         display
            cb_line @ line
            cb_type @ type
            cb_amt
            cb_curr
            cb_curr_amt.
         {&CMBKMTA-P-TAG5}

         {&CMBKMTA-P-TAG6}
         {pxmsg.i &MSGNUM=171 &ERRORLEVEL=1} /* UPDATE NOT ALLOWED */
         next loopc1.
         {&CMBKMTA-P-TAG7}
      end. /* IF AVAILABLE CB_MSTR */

      else do:
         display type with frame c.

         {pxmsg.i &MSGNUM=169 &ERRORLEVEL=1}
         loopc1a:
         do on error undo, retry:
            set type with frame c.
            if index("PRG",type) = 0 then do:
               {pxmsg.i &MSGNUM=169 &ERRORLEVEL=3}
               /* ONLY ACCOUNT P(AYABLE),
               ACCOUNT R(ECEIVABLE)
               OR G(ENERAL LEDGER) ALLOWED */
               undo loopc1a.
            end. /* IF INDEX("PRG",TYPE) = 0 */

            if input type = "G"
               or (input type = "P" and l_ctrl_pip)
            then do:

               /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY */
               {gpglef1.i
                   &module = ""AP""
                   &entity = bk_entity
                   &date   = ba_date
                   &prompt = "type"
                   &frame  = "c"
                   &loop   = "loopc1a"}

            end. /* IF INPUT type = "G" */

         end. /* LOOPC1A */

      end. /* ELSE IF NOT AVAILABLE CB_MSTR */

      /*GET NECESSARY REFERENCE NUMBERS, ACCORDING TO TYPE */
      if type = "R" then do:
         {gprun.i ""arpamtpl.p"" "persistent set h-arpamtpl"}
         /* GET NEXT JOURNAL REFERENCE NUMBER */

         run get_gl_ref in h-arpamtpl (input-output arjrnl).

         /* DELETE HANDLE TO THE PROCEDURE SO THAT IT DOES NOT STAY */
         /* IN THE MEMORY IF USER PRESSES ESC/F4 FROM THE UI BELOW  */
         delete procedure h-arpamtpl no-error.

         do transaction:
            /* GET NEXT AR CHECK NUMBER */
            {mfnctrl.i arc_ctrl arc_memo ar_mstr ar_check arnbr}
         end.
         l_ar_base_amt = 0.
      end. /* IF TYPE = "R" */

      if type = "P" then do:
         do transaction:
            /* GET NEXT JOURNAL REFERENCE NUMBER  */
            {mfnctrl.i apc_ctrl apc_jrnl glt_det glt_ref jrnl}
         end.
      end. /* IF TYPE = "P" */

      if type = "G" then do:

         if not l_flag then do:
            /* GET MFC_CTRL FIELD CO_DAILY_SEQ, ADD IF NECESSARY */
            {glmfcctl.i}
            l_flag = yes.
         end. /* IF NOT L_FLAG */

         /* DELETE ANY HOLDING TRANSACTIONS LEFT */
         repeat:
            for first glt_det
               fields ( glt_ref glt_tr_type glt_userid )
               where glt_tr_type = "**" and
               glt_userid = mfguser
            no-lock use-index glt_tr_type:
            end. /* FOR FIRST GLT_DET */
            if not available glt_det then leave.

            else do: /* IF AVAILABLE GLT_DET */
               glt_recno = recid(glt_det).
               find glt_det
                  where recid(glt_det) = glt_recno exclusive-lock.
               delete glt_det.
            end. /* IF AVAILABLE GLT_DET */

         end. /* REPEAT */

         do transaction:
            /* GET REFERENCE NUMBER */
            new_glt = false.
            if co_daily_seq then
            ref = "JL" + substring(string(year(today),"9999"),3,2)
               + string(month(today),"99")
               + string(day(today),"99").
            else ref = "JL".

            for last glt_det
               fields ( glt_ref glt_tr_type glt_userid )
               where glt_ref >= ref and
               glt_ref <= ref + fill(hi_char,14) no-lock:
            end. /* FOR LAST GLT_DET */

            for last gltr_hist
               fields ( gltr_ref )
               where gltr_ref >= ref and
               gltr_ref <= ref + fill(hi_char,14) no-lock:
            end. /* FOR LAST GLTR_HIST */

            if co_daily_seq then do: /* IF CO_DAILY_SEQ */

               ref = max(ref + string(0, "999999"),
                  max(if available glt_det then glt_ref else "",
                  if available gltr_hist then gltr_ref else "")).

               jlnbr = 0.
               do on error undo, leave:
                  jlnbr = integer(substring(ref,9,6)).
               end. /* DO ON ERROR */
               hide message no-pause.

               ref = "JL" + substring(string(year(today),"9999"),3,2)
                  + string(month(today),"99")
                  + string(day(today),"99")
                  + string((jlnbr + 1),"999999").

            end. /* IF CO_DAILY_SEQ */

            else do: /* IF CONTINUOUS */

               ref = max(ref + string(0, "999999999999"),
                  max(if available glt_det then glt_ref else "",
                  if available gltr_hist then gltr_ref else "")).

               jlnbr = 0.
               do ctr_no = 6 to 14:
                  if substring(ref,ctr_no,1) >= "0" and
                     substring(ref,ctr_no,1) <= "9" then
                     next.
                  else
                     leave.
               end.

               if ctr_no = 15 then
            do on error undo, leave:
                  jlnbr = integer(substring(ref,6,9)).
               end. /* DO ON ERROR */

               hide message no-pause.
               /* DUE TO INTEGER LIMITATIONS, CAN ONLY INCREMENT THE */
               /* LAST 9 DIGITS OF REFERENCE                         */
               ref = "JL" + substring(ref,3,3) + string(integer
                  (jlnbr + 1), "999999999").

            end. /* IF CONTINUOUS */

            repeat:
               if not can-find(first glt_det where glt_ref = ref) and
                  not can-find(first gltr_hist where gltr_ref = ref)
               then do:

                  /* CREATE THE HOLDING TRANSACTION (GLT_TR_TYPE = "**") */
                  /* WITH GLT_USERID = MFGUSER (SESSION ID)              */

                  create glt_det.
                  assign
                     glt_ref     = ref
                     glt_userid  = mfguser
                     glt_tr_type = "**".
                  if recid(glt_det) = -1 then .
                  new_glt = true.
                  leave.
               end. /* NOT CAN-FIND */

               else
                  if co_daily_seq then
               ref = substring(ref,1,8) + string(integer
                  (substring(ref,9,6)) + 1, "999999").
               else
               ref = substring(ref,1,5) + string(integer
                  (substring(ref,6,9)) + 1, "999999999").
            end. /* REPEAT */
         end. /* DO TRANSACTION */
      end. /* IF TYPE = "G" */

      do transaction:
         find first cb_mstr where cb_line = line and
            cb_batch = ba_batch no-error.
         if not available cb_mstr then do:
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /*ADDING NEW RECORD*/
            create cb_mstr.
            assign
               cb_line  = line
               cb_type  = type
               cb_batch = ba_batch
               cb_curr  = bkcurr.

            /* SET CB_* CURRENCY DEPENDENT VARIABLES TO     */
            /* REFLECT BK_CURR FORMAT FOR NEW CB_CURR_AMT. */
            assign
               cb_rndmthd = bkcurr_rndmthd
               old_cbcurr = bkcurr
               cb_curr_amt:format = cb_curramt_bkfmt.
            new_line = yes.
         end.
         else new_line = no.

         assign
            last_line = cb_line
            recno     = recid(cb_mstr)
            ststatus  = stline[2].
         status input ststatus.
         del-yn = no.

         loopc2:
         repeat with frame c
               on endkey undo loopc1, retry loopc1:

            assign
               cb_amt:format = cbamt_fmt.
            {&CMBKMTA-P-TAG8}

            update
               cb_amt when (new_line)
               go-on (F5 CTRL-D).
            /* DELETE */
            if lastkey = keycode("F5") or
               lastkey = keycode("CTRL-D") then do:
               del-yn = yes.
               /*CONFIRM DELETE*/
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if del-yn then do:

                  /* DELETE EXCHANGE RATE USAGE RECORD */
                  {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                     "(input cb_exru_seq)"}

                  delete cb_mstr.
                  last_line = last_line - 1.
                  clear frame c all.
                  del-yn = no.
                  next loopc1.
               end. /* IF DEL-YN */
            end. /* DELETE */
            {&CMBKMTA-P-TAG9}
            status input.
            if new_line then do:
               if cb_amt > 0 and cb_type = "P" then do:
                  {pxmsg.i &MSGNUM=173 &ERRORLEVEL=3}
                  /* ONLY NEGATIVE AMOUNT ALLOWED FOR P*/
                  next-prompt cb_amt.
                  next loopc2.
               end.
               {&CMBKMTA-P-TAG10}
               if cb_amt < 0 and cb_type = "R" then do:
                  {pxmsg.i &MSGNUM=3701 &ERRORLEVEL=2}
                  /*WARNING: USE NEGATIVE AMOUNTS FOR REVERSING ENTRY ONLY*/
               end.

               /* VALIDATE CB_AMT TO BANK CURRENCY ROUND METHOD */
               if (cb_amt <> 0) then do:
                  {gprun.i ""gpcurval.p"" "(input cb_amt,
                       input bkcurr_rndmthd,
                       output retval)"}
                  if retval <> 0 then do:
                     next-prompt cb_amt.
                     next loopc2.
                  end.   /* IF RETVAL <> 0 */
               end.  /* IF CB_AMT <> 0 */

            end. /* IF NEW_LINE */

            assign
               bank_ctrl   = cb_amt
               bank_b_ctrl = cb_amt.

            if new_line then do
               on error undo, retry:

                  if cb_type <> "G" then
                     update cb_curr with frame c.

                  /* VALIDATE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                     "(input cb_curr,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     next-prompt cb_curr with frame c.
                     undo, retry.
                  end.

                  valid_curr = true.

                  /*FOR AP TYPE, FOLLOWING RULES APPLY:            */
                  /*1. IF BKCURR = BASE THEN ANY CURR IS VALID     */
                  /*2. IF BKCURR <> BASE THEN LINE MUST BE BKCURR  */
                  /*   WITH NO TRANSPARENCY                        */
                  if cb_type = "P" then do:
                     if bkcurr <> base_curr and cb_curr <> bkcurr
                        then valid_curr = false.
                  end.

                  /*FOLLOWING RULES APPLY TO AR ONLY NOW!          */
                  /*FOR AR AND AP TYPES, CHECK FOR THE APPROPRIATE */
                  /*CURRENCY GIVEN THE FOLLOWING RULES:            */
                  /*1. IF BKCURR = BASE THEN ANY CURR IS VALID     */
                  /*2. IF BKCURR AND BASE ARE TRANSPARENT THEN     */
                  /*   ANY CURR IS VALID                           */
                  /*3. IF BKCURR AND BASE ARE NOT TRANSPARENT AND  */
                  /*   BKCURR IS NOT A UNION OR MEMBER CURR THEN   */
                  /*   LINE MUST BE IN BKCURR                      */
                  /*4. IF BKCURR AND BASE ARE NOT TRANSPARENT AND  */
                  /*   BKCURR IS A UNION OR MEMBER CURR THEN LINE  */
                  /*   MUST BE IN BKCURR OR MEMBER CURR            */

                  if cb_type = "R" then do:
                     if bkcurr <> base_curr
                        and bkcurr <> cb_curr
                     then do:
                        run is_euro_transparent
                           (input bkcurr,
                           input cb_curr,
                           input base_curr,
                           input ba_date,
                           output valid_curr).
                     end.
                  end.

                  if not valid_curr then do:
                     {pxmsg.i &MSGNUM=2679 &ERRORLEVEL=3}
                     /* INVALID TRANSACTION CURRENCY */
                     undo, retry.
                  end.

                  if bkcurr <> cb_curr
                  then do:
                     /* GET EXCHANGE RATE AND */
                     /* CREATE USAGE RECORD   */
                     {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                        "(input cb_curr,
                          input bkcurr,
                          input cb_ex_ratetype,
                          input ba_date,
                          output cb_ex_rate,
                          output cb_ex_rate2,
                          output cb_exru_seq,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        undo, retry.
                     end.

                     pause 0.
                     /* EXCHANGE RATE POP-UP */
                     {gprunp.i "mcui" "p" "mc-ex-rate-input"
                        "(input cb_curr,
                          input bkcurr,
                          input ba_date,
                          input cb_exru_seq,
                          input false,
                          /* DO NOT UPDATE FIXED RATES */
                          input frame c:row + 3,
                          input-output cb_ex_rate,
                          input-output cb_ex_rate2,
                          input-output dummy_fixed_rate)"}

                     /* GET ROUNDING METHOD */
                     {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                        "(input cb_curr,
                          output cb_rndmthd,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        undo,retry.
                     end.

                     /* CONVERT TO FOREIGN CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input bkcurr,
                          input cb_curr,
                          input cb_ex_rate2,
                          input cb_ex_rate,
                          input cb_amt,
                          input true, /* ROUND */
                          output cb_curr_amt,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        undo,retry.
                     end.

                     /* GPCURFMT.P FOR NEW CURR, IF NEEDED */
                     if cb_curr <> old_cbcurr then do:
                        cb_curramt_fmt  = cb_curramt_old.
                        {gprun.i ""gpcurfmt.p""
                           "(input-output cb_curramt_fmt,
                             input cb_rndmthd)"}
                        cb_curr_amt:format = cb_curramt_fmt.
                        old_cbcurr = cb_curr.
                     end. /* IF CB_CURR <> OLD_CBCURR */

                     /* The ASSIGNMENT IS NECESSARY IN ORDER    */
                     /* TO PASS THE ENTERED EXCHANGE RATE TO    */
                     /* CALLEd MAINTENANCE FRAME.               */
                     assign
                        bank_ex_rate  = cb_ex_rate
                        bank_ex_rate2 = cb_ex_rate2.

                     display
                        cb_curr_amt
                     with frame c.
                     pause.

                     /* USER WILL NOT HAVE ACCESS TO CB_CURR_AMT */
                     /* OR CB_ENT_EX FIELDS                      */

                  end. /* IF BKCURR <> CB_CURR */

               end. /* IF NEW_LINE */
               {&CMBKMTA-P-TAG11}

               /*GET EXCHANGE RATE AND CREATE USAGE RECORD FOR     */
               /*CB_CURR AND BASE_CURR - TO BE USED IN SUBPROGRAMS */
               /*CHANGED OUTPUT PARAMETERS TO USE bank_ VARIABLES  */
               if base_curr <> cb_curr then do:

                  /* For "P" AND "G" TYPE OF TRANSACTIONS EXCHANGE */
                  /* RATE POPUP SHOULD BE CALLED ONLY FOR FOREIGN  */
                  /* CURRENCY BANK.                                */
                  /* cb_type = "R" IS ADDED TO RETAIN THE EXISTING */
                  /* FUNCTIONALITY FOR "R" TYPE OF TRANSACTIONS.   */

                  {&CMBKMTA-P-TAG12}
                  if (bkcurr  = cb_curr or
                     cb_type = "R")
                  then do:
                     {&CMBKMTA-P-TAG13}

                     {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                        "(input cb_curr,
                          input base_curr,
                          input cb_ex_ratetype,
                          input ba_date,
                          output bank_ex_rate,
                          output bank_ex_rate2,
                          output bank_exru_seq,
                          output mc-error-number)"}

                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        undo, retry.
                     end.

                     {&CMBKMTA-P-TAG14}
                     if cb_type <> "R"
                     then do:
                        {&CMBKMTA-P-TAG15}
                        {gprunp.i "mcui" "p" "mc-ex-rate-input"
                           "(input cb_curr,
                             input base_curr,
                             input ba_date,
                             input bank_exru_seq,
                             input false,
                             /* DO NOT UPDATE FIXED RATES */
                             input frame c:row + 3,
                             input-output bank_ex_rate,
                             input-output bank_ex_rate2,
                             input-output dummy_fixed_rate)"}
                        {&CMBKMTA-P-TAG16}
                     end. /* IF cb_type <> "R" */
                     {&CMBKMTA-P-TAG17}
                  end. /* IF bkcurr = cb_curr OR cb_type = "R" */
               end.
               hide frame a.
               hide frame c no-pause.

               if bkcurr <> cb_curr
                  then bank_ctrl = cb_curr_amt.
               bank_curr = cb_curr.

               if cb_type = "R" then do:
                  b_batch = " ".
                  if not new_line then arnbr = cb_ref.
                  {&CMBKMTA-P-TAG18}
                  del_cb = yes.
                  undo_all = yes.
                  {&CMBKMTA-P-TAG19}
                  /* ENABLE AUTO-APPLY FEATURE     */
                  {gprun.i ""arpamtpl.p"" "Persistent set h-arpamtpl"}
                  {gprun.i ""arpamtm.p""}

                  /* LEAVE THE BLOCK IF USER NOT AUTHORIZED */
                  /* FOR ENTITY                             */
                  if batchrun and l_batch_err
                     then
                     undo loopc, leave loopc.

                  delete PROCEDURE h-arpamtpl no-error.
                  {&CMBKMTA-P-TAG20}
                  if undo_all then do:
                     return_int = 1.
                     return.
                  end.
                  if del_cb then do:
                     if not new_line then
                        ba_total = ba_total - cb_amt.
                     display ba_total with frame a.
                     delete cb_mstr.
                     clear frame c.
                     last_line = last_line - 1.
                     next loopc1.
                  end.
               end. /* IF CB_TYPE = "R" */
               else if cb_type = "P" then do:
                  assign
                     b_batch      = cb_batch
                     b_line       = cb_line
                     del_cb       = yes
                     undo_all     = yes.
                  {gprun.i ""apcrmtm.p""}
                  if undo_all then do:
                     return_int = 1.
                     return.
                  end.
                  if del_cb then do:
                     view frame a.
                     delete cb_mstr.
                     clear frame c.
                     last_line = last_line - 1.
                     next loopc1.
                  end.
               end. /* if cb_type = "P" */
               else if cb_type = "G" then do:
                  hide frame a.
                  hide frame c.
                  assign
                     bank_ctrl = bank_ctrl * -1
                     bank_curr = bkcurr
                     del_cb    = yes
                     undo_all  = yes.

                  {&CMBKMTA-P-TAG21}
                  {gprun.i ""gltrmtm.p"" "(input ""JL"")"}
                  {&CMBKMTA-P-TAG22}
                  if undo_all then do:
                     return_int = 1.
                     return.
                  end.
                  if del_cb then do:
                     view frame a.
                     delete cb_mstr.
                     clear frame c.
                     last_line = last_line - 1.
                     next loopc1.
                  end.

                  /* UPDATE CONTROL AMOUNT AND CURRENCY AMOUNT */
                  /* WITH THE DISTRIBUTION AMOUNT              */

                  assign
                     cb_amt        = bank_ctrl * -1
                     cb_curr_amt   = bank_ctrl * -1
                     ba_total      = ba_total + (bank_ctrl * -1).
               end. /* ELSE IF CB_TYPE = "G" */
               if cb_type <> "G" then do:
                  if bkcurr <> cb_curr and new_line then do:

                     {&CMBKMTA-P-TAG33}

                     cb_curr_amt = bank_ctrl.

                     /* CONVERT AMOUNTS FOR TYPE "P" ONLY */
                     if cb_type = "P"
                     then do:
                        /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input cb_curr,
                             input bkcurr,
                             input cb_ex_rate,
                             input cb_ex_rate2,
                             input bank_ctrl,
                             input true, /* ROUND */
                             output cb_amt,
                             output mc-error-number)"}

                        if mc-error-number <> 0
                        then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                           undo,retry.
                        end. /* IF mc-error-number <> 0 */
                     end. /*  IF cb_type = "P" */

                     {&CMBKMTA-P-TAG34}

                     {&CMBKMTA-P-TAG31}

                     /* STORE THE VALUE OF THE AR BASE AMOUNT*/
                     /* ONLY FOR AR TYPE OF TRANSACTIONS     */
                     if cb_type = "R"
                        then
                           cb_amt   = l_ar_base_amt.

                     {&CMBKMTA-P-TAG32}
                     ba_total = ba_total + cb_amt.
                  end. /* IF BK_CURR <> CB_CURR AND NEW_LINE */
                  else
                  if new_line then
                  do:
                     {&CMBKMTA-P-TAG23}
                     assign
                        cb_curr_amt = bank_ctrl
                        cb_amt      = bank_ctrl
                        ba_total    = ba_total + bank_ctrl.
                     {&CMBKMTA-P-TAG24}
                  end. /* IF NEW_LINE */
               end. /* IF CB_TYPE <> "G" */

               view frame a.

               view frame c.

               if new_line then
               do:
                  assign
                     cb_ref      = b_batch
                     cb_ex_rate  = bank_ex_rate
                     cb_ex_rate2 = bank_ex_rate2.

                  /*COPY USAGE RECORDS*/
                  {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                     "(input bank_exru_seq,
                       output cb_exru_seq)"}.
               end.
               {&CMBKMTA-P-TAG25}

               display
                  cb_amt
                  cb_curr_amt
               with frame c.
               {&CMBKMTA-P-TAG26}

               display
                  ba_total
               with frame a.
               down with frame c.
               leave loopc2.
            end. /*LOOPC2*/
         end. /*TRANSACTION */
         /* DELETE HOLDING TRANSACTION */
         if type = "G" then
         do transaction:
            find glt_det
               where glt_tr_type = "**" and glt_ref = ref
            exclusive-lock no-error.
            if available glt_det then
                  delete glt_det.
         end. /* DO TRANSACTION */

      end. /*LOOPC1*/

      /* DELETE ANY HOLDING TRANSACTIONS LEFT */
      if l_flag then
            repeat:
         for first glt_det
            fields ( glt_ref glt_tr_type glt_userid )
            where glt_tr_type = "**" and
            glt_userid = mfguser
         no-lock use-index glt_tr_type:
         end. /* FOR FIRST GLT_DET */
         if not available glt_det then leave.

         else do: /* IF AVAILABLE GLT_DET */
            glt_recno = recid(glt_det).
            find glt_det where recid(glt_det) = glt_recno
            exclusive-lock.
            delete glt_det.
         end. /* IF AVAILABLE GLT_DET */

      end. /* REPEAT */

      do transaction:
         if ba_total <> batch_ctrl then do:
            {pxmsg.i &MSGNUM=1151 &ERRORLEVEL=4}
            yn = no.
            /* CONTINUE ? */
            {&CMBKMTA-P-TAG36}
            {pxmsg.i &MSGNUM=8500 &ERRORLEVEL=3 &CONFIRM=yn}
            {&CMBKMTA-P-TAG37}
            if yn then do:
               clear frame c all.
               next loopc.
            end.
            else do:
               if ba_total <> 0 then
                  ba_status = "UB". /* UNBALANCED */
               hide frame c.
               clear frame c all.
               return_int = 2.
               return.
            end.
         end.
         else do:
            if ba_total <> 0
               then
               ba_status = "".         /*OPEN, BALANCED*/
            else
               ba_status = "NU".       /*NOT USED*/
            yn = no.
            /* SET STATUS TO CLOSED ? */
            {pxmsg.i &MSGNUM=175 &ERRORLEVEL=1 &CONFIRM=yn}
            if yn then do:
               ba_status = "C".
               {pxmsg.i &MSGNUM=176 &ERRORLEVEL=1} /* STATUS IS CLOSED */
            end.
            hide frame c.
            clear frame c all.
            leave loopc.
         end.
      end. /* TRANSACTION */
   end. /*LOOPC*/
   {&CMBKMTA-P-TAG27}

   /*PROCEDURE DEFINITION FOR is_euro_transparent*/
   {gpacctet.i}

   /* INTERNAL PROCEDURE TO GET TRANSACTION CURRENCY */
   /* DISPLAY FORMAT                                 */
   PROCEDURE p-trans-curr-format:

      if cb_mstr.cb_curr <> old_cbcurr and
         cb_mstr.cb_curr <> bkcurr
      then do:

         /* GET ROUNDING METHOD */
         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input cb_mstr.cb_curr,
              output cb_rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            undo,retry.
         end. /* IF mc-error-number <> 0 */

         cb_curramt_fmt  = cb_curramt_old.
         {gprun.i ""gpcurfmt.p""
            "(input-output cb_curramt_fmt,
              input cb_rndmthd)"}

         old_cbcurr = cb_mstr.cb_curr.

      end. /* IF CB_CURR <> OLD_CBCURR */

   END PROCEDURE. /* P-TRANS-CURR-FORMAT */
   {&CMBKMTA-P-TAG28}
