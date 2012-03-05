/* aprvvo.p - RELEASE RECURRING VOUCHERS TO VOUCHERS                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.35 $                                          */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.3      LAST MODIFIED: 10/14/92   BY: mlv *G042*          */
/*                                   10/21/92   BY: mpp *G475*          */
/*                                   01/12/93   BY: mpp *G540*          */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H051*          */
/*                                   08/06/93   BY: wep *H061*          */
/*                                   08/12/93   BY: bcm *H066*          */
/*                                   10/14/93   BY: wep *H176*          */
/*                                   01/14/94   BY: wep *GI48*          */
/*                                   02/08/94   BY: srk *GI33*          */
/*                                   02/25/94   BY: jjs *H262*          */
/*                                   04/05/94   BY: pcd *H322*          */
/*                                   05/04/94   BY: srk *GJ70*          */
/*                                   06/14/94   by: bcm *H383*          */
/*                                   09/21/94   by: bcm *H531*          */
/*                                   04/24/95   by: wjk *H0CS*          */
/* REVISION: 8.5      LAST MODIFIED: 11/01/95   by: mwd *J053*          */
/* REVISION: 8.6      LAST MODIFIED: 06/17/96   BY: bjl *K001*          */
/*                                   07/31/96   *J12H*  M. Deleeuw      */
/*                                   10/10/96   *K00Z*  B. Lass         */
/*                                   02/17/97   *K01R*  E. Hughart      */
/*                                   03/10/97   *K084*  Jeff Wootton    */
/* REVISION: 8.6      LAST MODIFIED: 10/07/97   BY: *J22H* Samir Bavkar */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *J34F* Vijaya Pakala*/
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* Pre-86E commented code removed, view in archive revision 1.10              */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* Old ECO marker removed, but no ECO header exists *H211*                    */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N009* David Morris       */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *N0C9* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MH* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 11/02/00   BY: *N0S9* Katie Hilbert      */
/* REVISION: 9.1      LAST MODIFIED: 08/05/00   BY: *N0W0* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.29       BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002*   */
/* Revision: 1.30       BY: Ed van de Gevel     DATE: 06/29/01  ECO: *N0ZX*   */
/* Revision: 1.31       BY: Ed van de Gevel     DATE: 11/09/01  ECO: *N15N*   */
/* Revision: 1.33       BY: Jean Miller         DATE: 04/08/02  ECO: *P056*   */
/* Revision: 1.34       BY: Manjusha Inglay     DATE: 07/29/02  ECO: *N1P4*   */
/* $Revision: 1.35 $    BY: Mercy Chittilapilly DATE: 08/19/02  ECO: *N1RM*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

{cxcustom.i "APRVVO.P"}

{gldydef.i new}
{gldynrm.i new}

define new shared variable vod_recno    as recid.
define new shared variable vo_recno     as recid.
define new shared variable ap_recno     as recid.
define new shared variable jrnl         like glt_ref.
define new shared variable curr_amt     like glt_curr_amt.
define new shared variable undo_all     like mfc_logical.
define new shared variable base_det_amt like glt_amt.
define new shared variable base_amt     like ap_amt.
define new shared variable undo_txdetrp like mfc_logical.
define new shared variable rndmthd      like rnd_rnd_mthd.
define new shared variable old_curr     like ap_curr.
/* SHARED VARIABLE DEL-YN NEEDED FOR PRM ROUTINE PJAPUPDT.P */
define new shared variable del-yn       like mfc_logical initial no.

/* THE FOLLOWING WORK VARIABLES ARE USED IN TXDETRP.P */
{txcurvar.i "new"}

define variable new_year      as integer.
define variable new_month     as integer.
define variable barecid       as recid.
define variable vend          like ap_vend.
define variable vend1         like ap_vend.
define variable ref           like ap_ref.
define variable ref1          like ap_ref.
define variable votype        like vo_type.
define variable votype1       like vo_type.
define variable cycle         like vo_rcycle.
define variable curr          like ap_curr.
define variable up_to_date    like vo_rel_date label "Release Up To".
define variable vonbr         like vo_ref      label "Next Voucher Nbr".
define variable vobatch       like ap_batch.
define variable start_date    like ap_date.
define variable next_rel_date like ap_date.
define variable use_rv_rate   like mfc_logical label "Use Recurr Exch Rate".
define variable tax_tr_type   like tx2d_tr_type initial "32".
define variable vo_tr_type    like tx2d_tr_type initial "22".
define variable tax_nbr       like tx2d_nbr initial "".
define variable page_break    as integer initial 0.
define variable col-80        as logical initial false.
define variable inbatch       like ba_batch.
define variable tot_apamt     like ap_amt.
define variable first_time    like mfc_logical.
define variable rv_conf       like apc_rv_conf.
define variable temp_month    as integer.
define variable temp_year     as integer.
define variable temp_date     as date.
define variable vod_amt_old   as character.
define variable vod_amt_fmt   as character.
define variable ap_amt_old    as character.
define variable ap_amt_fmt    as character.
define variable mc-error-number like msg_nbr no-undo.
define variable new_ex_rate    like ap_ex_rate no-undo.
define variable new_ex_rate2   like ap_ex_rate2 no-undo.
define variable l_msg1 as character format "x(78)" no-undo.

define buffer apmstr for ap_mstr.
define buffer vomstr for vo_mstr.
define buffer voddet for vod_det.
{&APRVVO-P-TAG1}

define variable blankall      as character no-undo format "x(17)".
define variable dwmblank      as character no-undo format "x(48)".
define variable disp-voref    like vo_mstr.vo_ref no-undo.

assign
   blankall = getTermLabel("BLANK_FOR_ALL",17)
   dwmblank = getTermLabel("D_W_M_BLANK",48).

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

{&APRVVO-P-TAG12}
form
   ref     colon 22   format "x(8)"
   ref1    label "To" colon 51 format "x(8)"
   vend    colon 22   vend1    label "To" colon 51
   votype  colon 22   votype1  label "To" colon 51 skip(1)
   cycle   colon 22 dwmblank no-label
   up_to_date colon 22
   vonbr   colon 22
   vobatch colon 22
   curr    colon 22 blankall no-label
   use_rv_rate colon 22
with frame a side-labels width 80.
{&APRVVO-P-TAG13}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   vobatch
   disp-voref     label "Recur Vo"
   vomstr.vo_ref
   apmstr.ap_vend
   ad_name
   apmstr.ap_effdate
   apmstr.ap_amt
   apmstr.ap_curr
   vomstr.vo_cr_terms
   vomstr.vo_due_date
with frame b width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   space(5)
   voddet.vod_acct
   voddet.vod_sub
   voddet.vod_cc
   voddet.vod_project
   voddet.vod_desc
   voddet.vod_amt
with frame c down width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

assign ap_amt_old  = apmstr.ap_amt:format
   vod_amt_old = voddet.vod_amt:format.

/*********************************************************************/
mainloop:
repeat:

   if ref1 = hi_char then ref1 = "".
   if vend1 = hi_char then vend1 = "".
   if votype1 = hi_char then votype1 = "".
   {&APRVVO-P-TAG2}
   display
      ref ref1
      vend vend1
      votype votype1
      cycle
      dwmblank no-label
      up_to_date
      vonbr
      curr
      use_rv_rate
      blankall no-label
   with frame a.
   {&APRVVO-P-TAG3}

   /*SPLIT SET BETWEEN LOOPA AND LOOPB SO VOUCHER AND BATCH'S WOULD*/
   /*NOT GET GENERATED IMMEDIATELY UPON ENTERING THE SERVICE.  THIS */
   /*HELPS TO PREVENT THE NEEDLESS WASTING OF REFERENCE NUMBERS    */
   loopa:
   do on error undo, retry:
      set ref ref1 vend vend1 votype votype1 with frame a.
   end.

   loopb:
   do on error undo, retry:

      /* ADDED BLOCK TO CONTROL THE RECORD SCOPING OF APC_CTRL*/
      /* TO CURE LOCKING PROBLEM                              */
      ctrl_trans:
      do on error undo, leave:
         /* GET NEXT VOUCHER AND BATCH NUMBER  */
         {mfnctrl.i apc_ctrl apc_voucher vo_mstr vo_ref vonbr}

         /* GET NEXT JOURNAL REFERENCE NUMBER  */
         {mfnctrl.i apc_ctrl apc_jrnl glt_det glt_ref jrnl}
         find first apc_ctrl no-lock.
         find first gl_ctrl no-lock.

         /*ADDED PROCEDURE TO GET THE NEXT BATCH NUMBER AND CREATE */
         /*THE BATCH MASTER (BA_MSTR).  IF THE BA_MSTR ALREADY     */
         /*EXISTS THE RECORD WILL BE UPDATED                       */

         inbatch = "".
         {gprun.i ""gpgetbat.p""
            "(input  inbatch,   /*IN-BATCH #  */
              input  ""AP"",    /*MODULE      */
              input  ""VO"",    /*DOC TYPE    */
              input  "0",       /*CONTROL AMT */
              output barecid,   /*NEW BAT RECID*/
              output vobatch)"} /*NEW BATCH # */

          /* USED LATER */
          rv_conf = apc_rv_conf.
      end.

      first_time = true.
      release apc_ctrl.

      {&APRVVO-P-TAG4}
      display vobatch vonbr with frame a.
      {&APRVVO-P-TAG5}

      set
         cycle
         up_to_date
         curr
         use_rv_rate
      with frame a.

      if lookup(cycle,"D,W,M") = 0 and cycle <> "" then do:
         /*Interval must be (D)ay,(W)eek, or (M)onth*/
         {pxmsg.i &MSGNUM=14 &ERRORLEVEL=3}
         next-prompt cycle with frame a.
         undo loopb, retry.
      end.

      if up_to_date = ? then do:
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         /* BLANK NOT ALLOWED */
         next-prompt up_to_date with frame a.
         undo loopb, retry.
      end.

   end.

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

   if ref1  = "" then ref1 = hi_char.
   if vend1 = "" then vend1 = hi_char.
   if votype1 = "" then votype1 = hi_char.

   /* OBTAIN AN EXCLUSIVE LOCK ON APC_CONTROL WHILE */
   /* VOUCHERS ARE RUNNING.                         */
   find first apc_ctrl exclusive-lock no-error.

   /* CYCLE THROUGH RECURRING VOUCHERS */
   rvloop1:
   for each ap_mstr where ap_mstr.ap_type = "RV" and
      ap_open = yes and
      ap_mstr.ap_ref >= ref and ap_mstr.ap_ref <= ref1
      and ap_mstr.ap_vend >= vend and ap_mstr.ap_vend <= vend1
      and (ap_mstr.ap_curr = curr or curr = ""),
      each vo_mstr where vo_mstr.vo_ref = ap_mstr.ap_ref and
      vo_mstr.vo_type >= votype and vo_mstr.vo_type <= votype1
      and (vo_mstr.vo_rcycle = cycle or cycle = "")
      and vo_mstr.vo_confirmed = yes and
      (vo_mstr.vo_rel_date = ? or
      vo_mstr.vo_rel_date < up_to_date):

      if vo_curr <> old_curr or old_curr = "" then do:

         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input vo_curr,
              output rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &ERRORLEVEL=4 &MSGNUM=4160 &MSGBUFFER=l_msg1}
            put
               skip(1)
               l_msg1 + ": " + string(vo_curr) skip.
            put
               {gplblfmt.i
                  &FUNC=getTermLabel(""CANNOT_RELEASE_REFERENCE"",68)
                  &CONCAT="': '"}
               string(ap_mstr.ap_ref) format "x(78)" skip(2).
            next rvloop1.
         end.

         ap_amt_fmt = ap_amt_old.
         {gprun.i ""gpcurfmt.p"" "(input-output ap_amt_fmt,
           input rndmthd)"}
         vod_amt_fmt = vod_amt_old.
         {gprun.i ""gpcurfmt.p"" "(input-output vod_amt_fmt,
           input rndmthd)"}
         old_curr = vo_curr.

      end. /* IF VO_CURR = "" OR...*/

      rvloop2:  /*need repeat because can have more than one*/
      repeat:   /*release per recurring voucher*/

         find first apc_ctrl no-lock no-error.

         /*FIND NEXT RELEASE DATE*/
         if vo_mstr.vo_rel_date = ? then
            next_rel_date = vo_mstr.vo_rstart.

         else do:

            start_date = vo_mstr.vo_rel_date.

            if vo_rcycle = "D" then
               next_rel_date = start_date + vo_mstr.vo_rnbr_cyc.

            else
            if vo_mstr.vo_rcycle = "W" then
               next_rel_date = start_date + (vo_mstr.vo_rnbr_cyc * 7).

            else if vo_mstr.vo_rcycle = "M" then do:
               assign
                  new_year = year(start_date)
                  new_month = month(start_date) + vo_mstr.vo_rnbr_cyc.
               do while new_month > 12:
                  assign
                  new_month = new_month - 12
                  new_year = new_year + 1.
               end.
               /* IF THE DAY OF VO_RSTART IS GREATER THAN         */
               /* THE LAST DAY OF THE MONTH, THEN THE DAY OF      */
               /* NEXT_REL_DATE WILL BE THE LAST DAY OF THE MONTH */
               assign
                  temp_month = new_month + 1
                  temp_year = new_year.
               if temp_month > 12 then
                  assign
                     temp_month = temp_month - 12
                     temp_year = temp_year + 1.
                     temp_date = date(temp_month,1,temp_year) - 1.
               if day(temp_date) < day(vo_rstart) then
                  next_rel_date = date(new_month,day(temp_date),new_year).
               else
                  next_rel_date = date(new_month,day(vo_rstart),new_year).
            end.

         end.

         /*RELEASE IF LESS THAN OR EQUAL TO UP_TO_DATE*/
         if next_rel_date > vo_mstr.vo_rexpire then do:
            ap_mstr.ap_open = no.
            next rvloop1.
         end.

         if next_rel_date > up_to_date then next rvloop1.

         if (not can-find(ad_mstr where ad_addr = ap_mstr.ap_vend))
         or (not can-find(vd_mstr where vd_addr = ap_mstr.ap_vend))
         then do:
            {pxmsg.i &MSGNUM=4157 &ERRORLEVEL=4 &MSGBUFFER=l_msg1}
            put
               l_msg1 + ":" + string(ap_mstr.ap_ref) format "x(78)".
            next rvloop1.
         end.

         /*IF RELEASING CONFIRMED, VALIDATE GL PERIOD*/
         if gl_verify = yes and rv_conf then do:

            {gpglef01.i ""AP"" ap_mstr.ap_entity next_rel_date}

            if gpglef > 0 then do:

               {pxmsg.i &MSGNUM=4156 &ERRORLEVEL=4
                        &MSGBUFFER = l_msg1
                        &MSGARG1 = string(ap_mstr.ap_entity)
                        &MSGARG2 = string(next_rel_date)}
               put l_msg1 format "x(78)" skip.

               put
                  {gplblfmt.i
                     &FUNC=getTermLabel(""CANNOT_RELEASE_REFERENCE"",68)
                     &CONCAT="': '"}
                  string(ap_mstr.ap_ref) format "x(78)".
               next rvloop1.
            end.

         end.

         /* GET CURRENT EXG RATE IF USE RECUR RATE SELECTION = NO */
         if ap_mstr.ap_curr <> base_curr
            and use_rv_rate = no
         then do:

            /* GET EXCHANGE RATE (TO CHECK THAT IT EXISTS) */
            {gprunp.i "mcpl" "p" "mc-get-ex-rate"
               "(input ap_mstr.ap_curr,
                 input base_curr,
                 input ap_mstr.ap_ex_ratetype,
                 input next_rel_date,
                 output new_ex_rate,
                 output new_ex_rate2,
                 output mc-error-number)"}

            /* MFEXVAL1.I WOULD HAVE PRODUCED AN ERROR MESSAGE */
            /* AND AN UNDO IN THE CASE OF A NON-EXISTING       */
            /* EXCHANGE RATE, SO THE MESSAGES BELOW WOULD NOT  */
            /* APPEAR ON THE REPORT.                           */
            if mc-error-number <> 0 then do:

               {pxmsg.i &MSGNUM=4161 &ERRORLEVEL=4 &MSGBUFFER=l_msg1}

               put
                  l_msg1 + ": " +
                  string(next_rel_date) format "x(78)" skip.
               put
                  {gplblfmt.i
                     &FUNC=getTermLabel(""CANNOT_RELEASE_REFERENCE"",68)
                     &CONCAT="': '"}
                  string(ap_mstr.ap_ref) format "x(78)".
               next rvloop1.

            end.

         end.

         create_block:
         do on error undo,leave:

            /*FIND NEXT VOUCHER NUMBER AND BUMP UP APC_VOUCHER;    */
            /*SKIP ONLY IF THIS IS THE FIRST TIME THROUGH THE LOOP */
            {&APRVVO-P-TAG6}
            if not first_time then do:
               run update-vo (input-output vonbr).
            end.

            assign
               first_time = false
               dft-daybook = "".
            {&APRVVO-P-TAG14}

            /* FIND DEFAULT DAYBOOK */
            if daybooks-in-use and ap_mstr.ap_dy_code > ""  then do:

               find dy_mstr where
                    dy_dy_code = ap_mstr.ap_dy_code
               no-lock no-error.

               if available dy_mstr then
                  dft-daybook = dy_dy_code.
               else do:
                  {gprun.i ""gldydft.p""
                     "(input ""AP"",
                       input ""RV"",
                       input ap_mstr.ap_entity,
                       output dft-daybook,
                       output daybook-desc)"}
               end.

            end. /*if daybooks-in-use */

            /* CREATE AP_MSTR FOR NEW RELEASED VOUCHER */
            create apmstr.
            assign
               apmstr.ap_acct      = ap_mstr.ap_acct
               apmstr.ap_amt       = ap_mstr.ap_amt
               apmstr.ap_base_amt  = ap_mstr.ap_base_amt
               apmstr.ap_bank      = ap_mstr.ap_bank
               apmstr.ap_batch     = vobatch
               apmstr.ap_cc        = ap_mstr.ap_cc
               apmstr.ap_curr      = ap_mstr.ap_curr
               apmstr.ap_ckfrm     = ap_mstr.ap_ckfrm
               apmstr.ap_date      = next_rel_date
               apmstr.ap_disc_acct = ap_mstr.ap_disc_acct
               apmstr.ap_disc_sub  = ap_mstr.ap_disc_sub
               apmstr.ap_disc_cc   = ap_mstr.ap_disc_cc
               apmstr.ap_effdate   = next_rel_date
               apmstr.ap_entity    = ap_mstr.ap_entity
               apmstr.ap_ex_rate   = ap_mstr.ap_ex_rate
               apmstr.ap_ex_rate2  = ap_mstr.ap_ex_rate2
               apmstr.ap_ex_ratetype = ap_mstr.ap_ex_ratetype
               apmstr.ap_open      = yes
               apmstr.ap_ref       = vonbr
               apmstr.ap_rmk       = ap_mstr.ap_rmk
               apmstr.ap_sort      = ap_mstr.ap_sort
               apmstr.ap_sub       = ap_mstr.ap_sub
               apmstr.ap_type      = "VO"
               apmstr.ap_vend      = ap_mstr.ap_vend
               apmstr.ap_dy_code   = dft-daybook.

            /*GET CURRENT EXG RATE IF USE RECUR RATE SELECTION = NO*/
            if apmstr.ap_curr <> base_curr
            and use_rv_rate = no then do:

               /* GET EXCHANGE RATE, CREATE USAGE */
               {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                  "(input apmstr.ap_curr,
                    input base_curr,
                    input apmstr.ap_ex_ratetype,
                    input next_rel_date,
                    output apmstr.ap_ex_rate,
                    output apmstr.ap_ex_rate2,
                    output apmstr.ap_exru_seq,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.

               /* RE-CONVERT AP_BASE_AMT USING NEW RATES */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input apmstr.ap_curr,
                    input base_curr,
                    input apmstr.ap_ex_rate,
                    input apmstr.ap_ex_rate2,
                    input apmstr.ap_amt,
                    input true,  /* ROUND */
                    output apmstr.ap_base_amt,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.

            end.
            else do:
               /* COPY RATE USAGE RECORDS TO A NEW SEQUENCE */
               {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                  "(input ap_mstr.ap_exru_seq,
                    output apmstr.ap_exru_seq)"}
            end.

            /* KEEP A RUNNING TOTAL OF THE AP_AMT SO THAT BA_MSTR */
            /* CAN BE UPDATED                                     */
            tot_apamt = tot_apamt + ap_mstr.ap_amt.

            /*CREATE NEW VOUCHER RECORD*/
            create vomstr.

            run assign-vomstr.

            create vpo_det.
            assign
               vpo_ref = vonbr
               vpo_po  = vo_mstr.vo_po
               /* UPDATE LAST RELEASE DATE ON RECUR VOUCHER */
               vo_mstr.vo_rel_date = next_rel_date
               ap_amt:format in frame b = ap_amt_fmt.

            find ad_mstr where ad_addr = apmstr.ap_vend.

            display
               vobatch
               vo_mstr.vo_ref @ disp-voref
               vomstr.vo_ref
               apmstr.ap_vend
               ad_name
               apmstr.ap_effdate
               apmstr.ap_amt
               apmstr.ap_curr
               vomstr.vo_cr_terms
               vomstr.vo_due_date
            with frame b width 132.

            /* COPY AND DISPLAY VOUCHER DISTRIBUTION */
            for each vod_det where vod_det.vod_ref = vo_mstr.vo_ref:
               create voddet.
               assign
                  voddet.vod_acct      = vod_det.vod_acct
                  voddet.vod_amt       = vod_det.vod_amt
                  voddet.vod_base_amt  = vod_det.vod_base_amt
                  voddet.vod_cc        = vod_det.vod_cc
                  voddet.vod_desc      = vod_det.vod_desc
                  voddet.vod_entity    = vod_det.vod_entity
                  voddet.vod_ln        = vod_det.vod_ln
                  voddet.vod_project   = vod_det.vod_project
                  voddet.vod_ref       = vomstr.vo_ref
                  voddet.vod_sub       = vod_det.vod_sub
                  voddet.vod_tax       = vod_det.vod_tax
                  voddet.vod_tax_at    = vod_det.vod_tax_at
                  voddet.vod_taxable   = vod_det.vod_taxable
                  voddet.vod_tax_env   = vod_det.vod_tax_env
                  voddet.vod_tax_in    = vod_det.vod_tax_in
                  voddet.vod_tax_usage = vod_det.vod_tax_usage
                  voddet.vod_taxc      = vod_det.vod_taxc
                  voddet.vod_type      = vod_det.vod_type
                  voddet.vod_dy_code   = dft-daybook.

               /* RECALCULATE VOD_BASE_AMT BASED ON UPDATED */
               /* VOUCHER EXCHANGE RATES.                   */
               {&APRVVO-P-TAG10}
               if vomstr.vo_curr <> base_curr then do:
                  {&APRVVO-P-TAG11}
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input vomstr.vo_curr,
                       input base_curr,
                       input vomstr.vo_ex_rate,
                       input vomstr.vo_ex_rate2,
                       input voddet.vod_amt,
                       input true,  /* ROUND */
                       output voddet.vod_base_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
               end.

               /* CREATE GL IF CONFIRMED */
               if vomstr.vo_confirmed then do:

                  assign
                     base_amt = voddet.vod_base_amt
                     curr_amt = voddet.vod_amt
                     vod_recno    = recid(voddet)
                     vo_recno     = recid(vomstr)
                     ap_recno     = recid(apmstr).

                  assign
                     undo_all     = yes
                     base_det_amt = base_amt.

                  {gprun.i ""apapgl.p""}

                  voddet.vod_dy_num = nrm-seq-num.

                  if undo_all then undo mainloop, leave.

               end.

               voddet.vod_amt:format in frame c = vod_amt_fmt.

               display
                  space(5)
                  voddet.vod_acct
                  voddet.vod_sub
                  voddet.vod_cc
                  voddet.vod_project
                  voddet.vod_desc
                  voddet.vod_amt
               with frame c down width 132.

               down 1 with frame c.

            end. /*each vod_det*/

            /* UPDATE VENDOR BALANCE */
            /* ONLY DO IF CONFIRMED VOUCHER */
            if vomstr.vo_confirmed then do:
               find vd_mstr where vd_addr = ap_vend exclusive-lock.
               assign
                  base_amt = apmstr.ap_base_amt
                  vd_balance = vd_balance + base_amt.
               release vd_mstr.
            end.

            /* COPY tx2d_dets FROM RECURRING VOUCHER TO VOUCHER */
            {gprun.i ""txdetcpy.p""
               "(input vo_mstr.vo_ref,
                 input '',
                 input tax_tr_type,
                 input vomstr.vo_ref,
                 input '',
                 input vo_tr_type)"}

            undo_txdetrp = true.

            {gprun.i  ""txdetrp.p""
               "(input vo_tr_type,
                 input vomstr.vo_ref,
                 input tax_nbr,
                 input col-80,
                 input page_break)" }

            if undo_txdetrp = true then undo, leave.

         end. /* create_block */

      end. /* rvloop2 repeat */

   end. /* rvloop1 each recur voucher */

   /* REPORT TRAILER */
   {mfrtrail.i}

   ba_trans:
   do for ba_mstr:
      /* UPDATE BATCH WITH AMOUNT */
      find ba_mstr where recid(ba_mstr) = barecid no-error.
      if available ba_mstr then do:
         assign
         ba_ctrl   = tot_apamt
         ba_total  = tot_apamt.

         if tot_apamt = 0 then
            ba_status = "NU".   /* NOT USED */
         else
            ba_status = "".   /* BALANCED */
         tot_apamt = 0.
      end.
   end.

end. /* mainloop */

PROCEDURE assign-vomstr:

   vomstr.vo_confirmed = rv_conf.

   if vomstr.vo_confirmed then
      vomstr.vo_conf_by = global_userid.

   assign
      vomstr.vo_cr_terms = vo_mstr.vo_cr_terms
      vomstr.vo_curr = vo_mstr.vo_curr.

   /*FIND DISC AND DUE DATE FROM CREDIT TERMS*/
   {&APRVVO-P-TAG7}
   {adctrms.i &date = apmstr.ap_date
              &due_date = vomstr.vo_due_date
              &disc_date = vomstr.vo_disc_date
              &cr_terms = vomstr.vo_cr_terms}
   {&APRVVO-P-TAG8}

   assign
      vomstr.vo_ex_rate   = apmstr.ap_ex_rate
      vomstr.vo_ex_rate2  = apmstr.ap_ex_rate2
      vomstr.vo_ex_ratetype = apmstr.ap_ex_ratetype
      vomstr.vo_invoice   = vo_mstr.vo_invoice
      vomstr.vo_ndisc_amt = vo_mstr.vo_ndisc_amt
      vomstr.vo_base_ndisc = vo_mstr.vo_base_ndisc
      vomstr.vo_ref       = apmstr.ap_ref
      vomstr.vo_separate  = vo_mstr.vo_separate
      vomstr.vo_ship      = vo_mstr.vo_ship
      vomstr.vo_tax_date  = vo_mstr.vo_tax_date
      vomstr.vo_tax_env   = vo_mstr.vo_tax_env
      vomstr.vo_taxable   = vo_mstr.vo_taxable
      vomstr.vo_taxc      = vo_mstr.vo_taxc
      vomstr.vo_tax_usage = vo_mstr.vo_tax_usage
      vomstr.vo_type      = vo_mstr.vo_type
      vomstr.vo__qad02    = vo_mstr.vo__qad02

      /*STORE RECURR VOUCHER REFERENCE ON */
      /*RELEASED VOUCHER                  */
      vomstr.vo_rv_nbr    = vo_mstr.vo_ref.

   /* COPY RATE USAGE RECORDS TO A NEW SEQUENCE */
   {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
      "(input apmstr.ap_exru_seq,
        output vomstr.vo_exru_seq)"}

END PROCEDURE.
{&APRVVO-P-TAG9}

PROCEDURE update-vo:
   define input-output parameter vonbr like vo_ref no-undo.
   {mfnctrl.i apc_ctrl apc_voucher vo_mstr vo_mstr.vo_ref vonbr}
END PROCEDURE.
