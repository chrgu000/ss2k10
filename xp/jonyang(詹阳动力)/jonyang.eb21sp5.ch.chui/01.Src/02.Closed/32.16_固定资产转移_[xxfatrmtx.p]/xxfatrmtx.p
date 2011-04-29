/* fatrmt.p Fixed Asset Transfer                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.19.1.15 $                                                         */
/*V8:ConvertMode=Report                                                  */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti    */
/* REVISION: 9.1     LAST MODIFIED: 01/20/00   BY: *N077* Vijaya Pakala  */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* REVISION: 9.1     LAST MODIFIED: 08/28/00   BY: *N0NV* BalbeerS Rajput  */
/* REVISION: 9.1     LAST MODIFIED: 10/25/00   BY: *M0VK* Jose Alex        */
/* Revision: 1.19.1.13  BY: Raghuvir Goradia DATE: 02/26/02 ECO: *N1B1* */
/* $Revision: 1.19.1.15 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00C* */


/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100521.1  By: Roger Xiao */ /**/

/*-Revision end---------------------------------------------------------------*/

/*----rev description---------------------------------------------------------------------------------*/

/* SS - 100521.1 - RNB
1.新的明细账户,默认自原fa_mstr,资产,费用等账户都是如此逻辑; 
2.新的成本中心,取自新库位.
3.以上逻辑不涉及到"资产冻结"账户,依然留原值
SS - 100521.1 - RNE */








/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "100521.1"}

/* ********** Begin Translatable Strings Definition ********* */

&SCOPED-DEFINE fatrmt_p_1 "Acquisition Cost"
/* MaxLen: 24 Comment: Fixed Asset Acquisition Cost */

&SCOPED-DEFINE fatrmt_p_2 "Transfer Date"
/* MaxLen: 34 Comment: Fixed Asset Transfer Date */

&SCOPED-DEFINE fatrmt_p_3 "New Location"
/* MaxLen: 34 Comment: New Location for Asset */

&SCOPED-DEFINE fatrmt_p_4 "Basis Amount"
/* MaxLen: 16 Comment: Fixed Asset Basis Amount */

&SCOPED-DEFINE fatrmt_p_5 "Net Book Value"
/* MaxLen: 16 Comment: Fixed Asset Net Book Value */

&SCOPED-DEFINE fatrmt_p_6 "Sel"
/* MaxLen: 3 Comment: Select yes/no for scrolling window */

&SCOPED-DEFINE fatrmt_p_8 "New Sub-Account"
/* MaxLen: 34 Comment: New Sub-Account for Asset */

&SCOPED-DEFINE fatrmt_p_9 "New Cost Center"
/* MaxLen: 34 Comment: New Cost Center for Asset */

&SCOPED-DEFINE fatrmt_p_10 "Old!Location"
/* MaxLen: 17 Comment: Old Location Asset */

&SCOPED-DEFINE fatrmt_p_11 "New!Location"
/* MaxLen: 8 Comment: New Location Asset */

&SCOPED-DEFINE fatrmt_p_12 "Select All"
/* MaxLen: 34 Comment: Select All assets? */

&SCOPED-DEFINE fatrmt_p_13 "Reason"
/* MaxLen: 40 Comment: Reason asset was not transferred */

/* ********** End Translatable Strings Definition ********* */

define variable l-asset      like fa_id                       no-undo.
define variable l-asset1     like fa_id                       no-undo.
define variable l-class      like fa_facls_id                 no-undo.
define variable l-class1     like fa_facls_id                 no-undo.
define variable l-loc        like fa_faloc_id                 no-undo.
define variable l-loc1       like fa_faloc_id                 no-undo.
define variable l-servdate   like fa_startdt                  no-undo.
define variable l-servdate1  like fa_startdt                  no-undo.
define variable l-acqcost    like fa_puramt                   no-undo.
define variable l-acqcost1   like fa_puramt                   no-undo.
define variable l-trndate    like fa_disp_dt    initial today no-undo.
define variable l-trnloc     like fa_faloc_id                 no-undo.
define variable l-trnsub     like faba_sub                    no-undo.
define variable l-trncc      like faba_cc                     no-undo.
define variable l-sel-all    like mfc_logical   initial yes   no-undo.
define variable l-asof-date  like fabd_yrper                  no-undo.
define variable l-basis      like fab_amt                     no-undo.
define variable l-basis-date like fab_date                    no-undo.
define variable l-accdep     like fab_amt                     no-undo.
define variable l-nbv        like fab_amt                     no-undo.
define variable l-ok         like mfc_logical                 no-undo.
define variable l-err-nbr    as   integer                     no-undo.
define variable l-tot-assets as   integer                     no-undo.
define variable l-faba-seq   like faba_glseq                  no-undo.
define variable l-recid      as   recid                       no-undo.
define variable l-period     as   character                   no-undo.
define variable l-cal        like fabk_calendar               no-undo.
define variable l-messages   as   character                   no-undo.
define variable l-msg-lvl    as   character                   no-undo.
define variable result       like mfc_logical                 no-undo.
define variable disp-old-loc like faloc_id                    no-undo.

define workfile sel-table
   field sel-idr as character format "x(1)"
   field sel-asset like fa_id
   field sel-date like fab_date
   field sel-basis like fab_amt
   field sel-nbv like fab_amt
   field sel-old-loc like faloc_id
   field sel-reason as character format "x(40)".

{gpglefv.i}      /* VARIABLES FOR GPGLEF1.P */
{gprunpdf.i "gpglvpl" "p"} /* EAS PROCEDURES */
{gprunpdf.i "fapl" "p"}  /* VARIABLES FOR FA PROCEDURES */

form
   l-asset       colon 25
   l-asset1      colon 50 label {t001.i}
   l-class       colon 25
   l-class1      colon 50 label {t001.i}
   l-loc         colon 25
   l-loc1        colon 50 label {t001.i}
   l-servdate    colon 25
   l-servdate1   colon 50 label {t001.i}
   l-acqcost     colon 25 label {&fatrmt_p_1}
   l-acqcost1    colon 50 label {t001.i}
   skip(1)
   l-trndate     colon 35 label {&fatrmt_p_2}
   l-trnloc      colon 35 label {&fatrmt_p_3}
/* SS - 100521.1 - B 
   l-trnsub      colon 35 label {&fatrmt_p_8}
   l-trncc       colon 35 label {&fatrmt_p_9}
   SS - 100521.1 - E */
   l-sel-all     colon 35 label {&fatrmt_p_12}
   skip(1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   sel-idr     column-label {&fatrmt_p_6}
   sel-asset
   sel-old-loc
   sel-date
   sel-basis   column-label {&fatrmt_p_4}
   sel-nbv     column-label {&fatrmt_p_5}
with frame b overlay width 80
   title color normal (getFrameTitle("SELECT_ASSETS_TO_TRANSFER",36)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   sel-asset
   fa_desc1     format "x(30)"
   disp-old-loc column-label {&fatrmt_p_10}
   fa_faloc_id  column-label {&fatrmt_p_11}
   l-trnsub
   l-trncc
   sel-reason   column-label {&fatrmt_p_13}
with frame c down width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

mainloop:
repeat:

   run ip-reset-fields.

   update
      l-asset
      l-asset1
      l-class
      l-class1
      l-loc
      l-loc1
      l-servdate
      l-servdate1
      l-acqcost
      l-acqcost1
      l-trndate
      l-trnloc
   with frame a.

   /* VALIDATE NEW LOCATION */
   for first faloc_mstr
      fields( faloc_domain faloc_cc faloc_entity faloc_id faloc_sub)
       where faloc_mstr.faloc_domain = global_domain and  faloc_id = l-trnloc
      no-lock:
   end. /* FOR FIRST faloc_mstr */

   if not available faloc_mstr
   then do:

      /* INVALID LOCATION */
      {pxmsg.i &MSGNUM=4220 &ERRORLEVEL=3}
      next-prompt l-trnloc with frame a.
      undo, retry.
   end. /* IF NOT AVAILABLE faloc_mstr */
   else do:

      /* VALIDATE TRANSFER DATE */
      {gprun.i ""gpglef1.p""
         "(input ""FA"",
           input faloc_entity,
           input l-trndate,
           output gpglef_result,
           output gpglef_msg_nbr)"}

      if gpglef_result > 0
      then do:

         /* INVALID/CLOSED PERIOD */
         {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=3}
         next-prompt l-trndate with frame a.
         undo, retry.
      end. /* IF gpglef_results > 0 */

   end.  /* ELSE DO */

   assign
      l-trnsub = faloc_sub
      l-trncc  = faloc_cc.

   update
/* SS - 100521.1 - B 
      l-trnsub
      l-trncc
   SS - 100521.1 - E */

      l-sel-all
   with frame a.

   bcdparm = "".

   run ip-quote.

   do on error undo, retry:

      run ip-build-temp-table.

      sw_block1:
      do on endkey undo, leave:

         run ip-swselect.

         /* TRAP ENDKEY */
         /* IS ALL INFO CORRECT */
         {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=l-ok}

         /* IN GUI, PROCESS TRANSACTIONS FOR AN YES RESPONSE  */
         /* TO THE "Is all information correct?" CONFIRMATION */
         /* PROMPT ON END-ERROR KEY PRESS FROM THE ASSET      */
         /* SELECTION WINDOW.                                 */

         if session:display-type = "GUI"
         then do:

            if not l-ok
            then
               undo sw_block1, next mainloop.
         end. /* IF SESSION:DISPLAY-TYPE = "GUI" */
         else
         if not l-ok
            or keyfunction(lastkey) = "end-error"
            or lastkey              = keycode("F4")
            or lastkey              = keycode("CTRL-E")
         then
            undo sw_block1, next mainloop.
      end.  /* DO ON ENDKEY UNDO, LEAVE */

   end.  /* REPEAT */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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
   {mfphead.i}

   do transaction:

      for each sel-table
         where sel-idr <> ""
         no-lock:

         run ip-create-transfer.

         if l-err-nbr <> 0
         then do:
            {pxmsg.i &MSGNUM=l-err-nbr &ERRORLEVEL=3}
            undo, leave.
         end. /* IF l-err-nbr <> 0 */

      end.  /* FOR EACH sel-table */

   end.  /* DO TRANSACTION */

   run ip-print-report.

   {mfrtrail.i}
end.    /* REPEAT MAINLOOP */

/* -------------------------------------------------------- */

PROCEDURE ip-reset-fields:

   l-tot-assets = 0.

   if l-asset1 = hi_char
   then
      l-asset1 = "".
   if l-class1 = hi_char
   then
      l-class1 = "".
   if l-loc1 = hi_char
   then
      l-loc1 = "".
   if l-servdate = low_date
   then
      l-servdate = ?.
   if l-servdate1 = hi_date
   then
      l-servdate1 = ?.

END PROCEDURE.  /* IP-RESET-FIELDS */

PROCEDURE ip-quote:
   {gprun.i ""gpquote.p""
      "(input-output bcdparm,
        15,
        l-asset,
        l-asset1,
        l-class,
        l-class1,
        l-loc,
        l-loc1,
        string(l-servdate),
        string(l-servdate1),
        string(l-acqcost),
        string(l-acqcost1),
        string(l-trndate),
        l-trnloc,
        l-trnsub,
        l-trncc,
        string(l-sel-all),
        null_char,
        null_char,
        null_char,
        null_char,
        null_char)"}

   if l-asset1 = ""
   then
      l-asset1 = hi_char.
   if l-class1 = ""
   then
      l-class1 = hi_char.
   if l-loc1 = ""
   then
      l-loc1 = hi_char.
   if l-servdate = ?
   then
      l-servdate = low_date.
   if l-servdate1 = ?
   then
      l-servdate1 = hi_date.

END PROCEDURE.  /* ip-quote */

PROCEDURE ip-build-temp-table:

   for each sel-table exclusive-lock:
      delete sel-table.
   end. /* FOR EACH sel-table */

   fa_mstr_loop:
   for each fa_mstr
      fields( fa_domain fa_dep fa_desc1 fa_disp_dt fa_entity fa_facls_id
      fa_faloc_id
             fa_id fa_mod_date fa_mod_userid fa_post fa_puramt fa_startdt)
       where fa_mstr.fa_domain = global_domain and (  fa_id >= l-asset
      and   fa_id <= l-asset1
      and   fa_facls_id >= l-class
      and   fa_facls_id <= l-class1
      and   fa_faloc_id >= l-loc
      and   fa_faloc_id <= l-loc1
      and   fa_startdt >= l-servdate
      and   fa_startdt <= l-servdate1
      and   fa_puramt >= l-acqcost
      and   (fa_puramt <= l-acqcost1 or l-acqcost1 = 0)
      and   fa_post = yes
      and   fa_faloc_id <> l-trnloc
      and   fa_disp_dt = ?
      and   fa_startdt < l-trndate
      ) no-lock
      break by fa_id:

      if fa_dep
      then do:

         for first fabk_mstr
            fields( fabk_domain fabk_id fabk_calendar fabk_post)
             where fabk_mstr.fabk_domain = global_domain and  fabk_post = yes
            no-lock:
         end. /* FOR FIRST fabk_mstr */

         for last fabd_det
            fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_accamt
            fabd_post)
             where fabd_det.fabd_domain = global_domain and  fabd_fa_id = fa_id
            and   fabd_fabk_id = fabk_id
            and   fabd_post = yes
            no-lock:
         end. /* FOR LAST fabd_det */

         if available fabd_det
         then
            l-asof-date = fabd_yrper.
         else
            l-asof-date = "". /* IF AVAILABLE fabd_det */

         for last fab_det
            fields( fab_domain fab_date fab_fabk_id fab_fa_id fab_resrv)
             where fab_det.fab_domain = global_domain and  fab_fa_id   = fa_id
            and   fab_fabk_id = fabk_id
            no-lock:
         end. /* FOR LAST fab_det */

         {gprunp.i "fapl" "p" "fa-get-cost"
            "(input  fa_id,
              input  fabk_id,
              output l-basis)"}

         {gprunp.i "fapl" "p" "fa-get-accdep"
            "(input  fa_id,
              input  fabk_id,
              input  l-asof-date,
              output l-accdep)"}

         assign
            l-nbv        = l-basis - l-accdep
            l-basis-date = fab_date.
      end.  /* IF fa_dep */
      else
         assign
            l-asof-date  = ""
            l-basis      = fa_puramt
            l-basis-date = fa_startdt
            l-accdep     = 0
            l-nbv        = fa_puramt.

      create sel-table.
      assign
         sel-idr     = if l-sel-all
                       then
                          "*"
                       else
                          ""
         sel-asset   = fa_id
         sel-date    = l-basis-date
         sel-basis   = l-basis
         sel-nbv     = l-nbv
         sel-old-loc = fa_faloc_id.

      if first(fa_id)
      then
         l-recid = recid(sel-table).
   end.  /* FOR EACH fa_mstr */

END PROCEDURE.  /* ip-build-temp-table */

PROCEDURE ip-swselect:

   sw_block:
   do on endkey undo, leave:
      view frame b.
      {swselect.i
         &detfile = sel-table
         &scroll-field = sel-table.sel-idr
         &framename = "b"
         &framesize = 12
         &sel_on = ""*""
         &sel_off = """"
         &display1 = sel-table.sel-idr
         &display2 = sel-table.sel-asset
         &display3 = sel-table.sel-old-loc
         &display4 = sel-table.sel-date
         &display5 = sel-table.sel-basis
         &display6 = sel-table.sel-nbv
         &exitlabel = sw_block
         &exit-flag = true
         &record-id = l-recid
         }
   end.  /* sw_block */

END PROCEDURE.  /* ip-swselect */

PROCEDURE ip-create-transfer:

   fa_mstr_loop:
   for first fa_mstr
      fields( fa_domain fa_dep fa_desc1 fa_disp_dt fa_entity fa_facls_id
      fa_faloc_id
             fa_id fa_mod_date fa_mod_userid fa_post fa_puramt fa_startdt)
       where fa_mstr.fa_domain = global_domain and  fa_id = sel-table.sel-asset
      exclusive-lock:

      for first faloc_mstr
         fields( faloc_domain faloc_cc faloc_entity faloc_id faloc_sub)
          where faloc_mstr.faloc_domain = global_domain and  faloc_id = l-trnloc
         no-lock:
      end. /* FOR FIRST faloc_mstr */

      l-faba-seq = 0.

      for last faba_det
         fields( faba_domain faba_acct faba_fa_id faba_glseq)
         no-lock
          where faba_det.faba_domain = global_domain and  faba_fa_id = fa_id
         use-index faba_fa_id:

         l-faba-seq = faba_glseq.

      end. /* FOR LAST faba_det */

      /* VALIDATE ACCT/SUB/CC COMBO FOR EACH ASSET ACCOUNT */
      for each faba_det
         fields( faba_domain faba_acct faba_fa_id faba_glseq)
          where faba_det.faba_domain = global_domain and  faba_fa_id = fa_id
         and   faba_glseq = l-faba-seq
         no-lock:
         assign
            l-messages = ""
            l-msg-lvl  = "".

         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}

         /* SET CONTROL FOR MESSAGE DISPLAY FROM VALIDATION PROCEDURE */
         {gprunp.i "gpglvpl" "p" "set_disp_msgs" "(input false)"}

         /* SET PROJECT VERIFICATION TO NO */
         {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}

         /* ACCT/SUB/CC/PROJ VALIDATION */
/* SS - 100521.1 - B 
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
            "(input faba_acct,
              input l-trnsub,
              input l-trncc,
              input """",
              output result)"}

         /* ONLY GET AND CHECK MSGS IF RESULT IS NOT TRUE */
         if not result
         then do:

            /* GET ERROR MESSAGES */
            {gprunp.i "gpglvpl" "p" "get_msgs"
               "(output l-messages,
                 output l-msg-lvl)"}

            if l-messages <> ""
            then do:

               /* INVALID ACCT */
               sel-table.sel-reason =
                  getTermLabel("INVALID_ACCOUNT_COMBINATION",35).
               next fa_mstr_loop.
            end. /* IF l-messages <> "" */

         end. /* IF NOT result */
   SS - 100521.1 - E */
      end. /* FOR EACH faba_det */

      /* FIND TRANSFER PERIOD IN GL AND CUSTOM CALENDAR */
      for each fab_det
         fields( fab_domain fab_date fab_fabk_id fab_fa_id fab_resrv)
          where fab_det.fab_domain = global_domain and  fab_fa_id = fa_id
         and   fab_resrv = 0
         no-lock:

         for first fabk_mstr
            fields( fabk_domain fabk_id fabk_calendar fabk_post)
             where fabk_mstr.fabk_domain = global_domain and  fabk_id =
             fab_fabk_id
            no-lock:
         end. /* FOR FIRST fabk_mstr */

         l-cal = if available fabk_mstr
                 and not fabk_post
                 then
                    fabk_calendar
                 else "".

         if l-cal = ""
         then do:

            for first glc_cal
               fields( glc_domain glc_end glc_per glc_start glc_year)
               no-lock
                where glc_cal.glc_domain = global_domain and  glc_start <=
                l-trndate
               and   glc_end   >= l-trndate:
            end. /* FOR FIRST glc_cal */

            if available glc_cal
            then
               l-period = string(glc_year,"9999")
                          + string(glc_per,"99").
         end. /* IF l-cal = "" */
         else do:

            for first facld_det
               fields( facld_domain facld_end facld_facl_id facld_per
               facld_start facld_year)
                where facld_det.facld_domain = global_domain and  facld_facl_id
                =  l-cal
               and   facld_start   <= l-trndate
               and   facld_end     >= l-trndate
               no-lock:
            end. /* FOR FIRST facld_det */

            if available facld_det
            then
               l-period = string(facld_year,"9999")
                          + string(facld_per,"99").
         end. /* ELSE DO */

         /* VALIDATE THAT ASSET NOT ALREADY POSTED THIS PERIOD */
         if can-find(first fabd_det
                      where fabd_det.fabd_domain = global_domain and
                      fabd_fa_id   = fa_id
                     and   fabd_fabk_id = fabk_id
                     and   fabd_yrper   = l-period
                     and   fabd_post    = yes)
         then do:

            /* ALREADY POSTED */
            sel-reason = getTermLabel("DEPRECIATION_ALREADY_POSTED",35).
            next fa_mstr_loop.
         end. /* IF CAN-FIND(FIRST fabd_det ... */

         /* VALIDATE DATE IN CUSTOM CALENDAR IF ANY */
         if l-cal <> ""
         then do:

            for first facld_det
               fields( facld_domain facld_facl_id facld_per facld_start
               facld_end)
                where facld_det.facld_domain = global_domain and  facld_facl_id
                = l-cal
               and   facld_per   <> 0
               and   facld_start <= l-trndate
               and   facld_end   >= l-trndate
               no-lock:
            end. /* FOR FIRST facld_det */
            if not available facld_det
            then do:

               /* INVALID DATE */
               sel-reason = getTermLabel("INVALID_DATE_IN_CUSTOM_CALENDAR",35).
               next fa_mstr_loop.
            end. /* IF NOT AVAILABLE facld_det */

         end.  /* IF custom calendar */

      end.  /* FOR EACH fab_det */

/* SS - 100521.1 - B 
      {gprun.i ""fatrbla.p""
         "(input  fa_id,
           input  fa_faloc_id,
           input  l-trnloc,
           input  l-trnsub,
           input  l-trncc,
           input  l-trndate,
           output l-err-nbr)"}
   SS - 100521.1 - E */
/* SS - 100521.1 - B */
l-trnsub = "" .
l-trncc  = faloc_mstr.faloc_cc.
      {gprun.i ""xxfatrbla.p""
         "(input  fa_id,
           input  fa_faloc_id,
           input  l-trnloc,
           input  l-trnsub,
           input  l-trncc,
           input  l-trndate,
           output l-err-nbr)"}
/* SS - 100521.1 - E */

      assign
         fa_faloc_id   = l-trnloc
         fa_entity     = faloc_entity
         fa_mod_date   = today
         fa_mod_userid = global_userid.

   end. /* FOR FIRST fa_mstr */

END PROCEDURE.  /* ip-create-transfer */

PROCEDURE ip-print-report:

   for each sel-table
      where sel-idr <> ""
      no-lock:

      for first fa_mstr
         fields( fa_domain fa_dep fa_desc1 fa_disp_dt fa_entity fa_facls_id
         fa_faloc_id
                fa_id fa_mod_date fa_mod_userid fa_post fa_puramt fa_startdt)
          where fa_mstr.fa_domain = global_domain and  fa_id = sel-asset
         no-lock:
      end. /* FOR FIRST fa_mstr */

      display
         sel-asset
         fa_desc1
         sel-old-loc @ disp-old-loc
         fa_faloc_id when (sel-reason = "")
         l-trnsub    when (sel-reason = "")
         l-trncc     when (sel-reason = "")
         sel-reason
      with frame c.
      down with frame c.
      l-tot-assets   = l-tot-assets  + 1.
   end. /* FOR EACH sel-table */

   underline
      sel-asset
   with frame c.
   down with frame c.

   display
      l-tot-assets @ sel-asset
   with frame c.
   {mfrpchk.i}

END PROCEDURE.  /* ip-print-report */
