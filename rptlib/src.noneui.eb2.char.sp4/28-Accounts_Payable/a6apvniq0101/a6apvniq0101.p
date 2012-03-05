/* apvniq01.p - VENDOR PREPAYMENT INQUIRY                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10.1.9 $                                                  */
/*K0ST         */
/*V8:ConvertMode=Report                                        */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92    BY: MLV *F238*         */
/* REVISION: 7.0      LAST MODIFIED: 03/16/92    BY: TMD *F260*         */
/* REVISION: 7.3      LAST MODIFIED: 11/19/92    By: jcd *G339*         */
/*                    LAST MODIFIED: 07/08/93    By: wep *GD30*         */
/* REVISION: 7.4      LAST MODIFIED: 04/07/94    By: pcd *H326*         */
/* REVISION: 8.5      LAST MODIFIED: 12/24/95    by: mwd *J053*         */
/* REVISION: 8.5      LAST MODIFIED: 04/05/96    by: jzw *G1LD*         */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97    BY: ckm *K0ST*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/21/98    BY: *H1JY* A. Licha    */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98    BY: *L03K* Jeff Wootton */
/* Pre-86E commented code removed, view in archive revision 1.8          */
/* REVISION: 8.6E     LAST MODIFIED: 09/22/98    BY: *L09K* Jeff Wootton      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99    BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99    BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00    BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00    BY: *N0W0* BalbeerS Rajput   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.1.7  BY: Ed van de Gevel  DATE: 11/09/01  ECO: *N15M* */
/* Revision: 1.10.1.8       BY: Hareesh V.  DATE: 06/21/02  ECO: *N1HY* */
/* $Revision: 1.10.1.9 $  BY: Ed van de Gevel  DATE: 09/05/02 ECO: *P0HQ* */
/* $Revision: 1.10.1.9 $  BY: Bill Jiang  DATE: 01/07/06 ECO: *SS - 20050107* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
/* SS - 20060107 - B */
define input parameter i_vend          like ap_vend.
define input parameter i_vend1          like ap_vend.
define input parameter i_prepay_only   like mfc_logical.
define input parameter i_base_rpt      like ap_curr.

{a6apvniq0101.i}
/*
{mfdtitle.i "2+ "}
*/
{a6mfdtitle.i "2+ "}
/* SS - 20060107 - E */
{cxcustom.i "APVNIQ01.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvniq01_p_1 "Prepay Amt"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq01_p_2 "Applied Amt"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq01_p_3 "Exch Rate"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq01_p_4 "Prepay Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq01_p_7 "Sort Name"
/* MaxLen: Comment: Windows version only */

/* ********** End Translatable Strings Definitions ********* */

define variable vend          like ap_vend.
/* SS - 20060107 - B */
define variable vend1          like ap_vend.
/* SS - 20060107 - E */
define variable base_hold_amt like vo_hold_amt.
define variable base_disc     like ckd_disc.
define variable base_camt     like ckd_amt.
define variable base_damt     like vod_amt.
define variable base_rpt      like ap_curr.
define variable base_amt      like ap_amt.
define variable base_prepay   like vo_prepay label {&apvniq01_p_1}.
define variable base_applied  like vo_applied label {&apvniq01_p_2}.
define variable disp_curr     as character format "x(1)" label "C".
define variable prepay_only   like mfc_logical label {&apvniq01_p_4}.
define variable vend_space    as character format "x(1)" initial "".
define variable vopo          like vpo_po.
define variable view-pos      like mfc_logical.
define variable mc-error-number like msg_nbr no-undo.

define buffer apmstr for ap_mstr.

find first gl_ctrl no-lock.

form
   vend
   prepay_only

   vd_sort format "x(24)" /*V8-*/ no-label /*V8+*/

   /*V8! label {&apvniq01_p_7} */
   vd_prepay
   base_rpt
with frame a width 80 no-underline no-attr-space.

/* SET EXTERNAL LABELS */
/* SS - 20060107 - B */
/*
setFrameLabels(frame a:handle).
*/
vend = i_vend.
vend1 = i_vend1.
prepay_only = i_prepay_only.
base_rpt = i_base_rpt.

if vend1 = hi_char then vend1 = "".
{mfquoter.i vend           }
{mfquoter.i vend1          }
if vend1     = "" then vend1     = hi_char.
/* SS - 20060107 - B */

{wbrp01.i}
/* SS - 20060107 - B */
/*
repeat:
*/
/* SS - 20060107 - E */

   /* SS - 20060107 - B */
   /*
   if c-application-mode <> 'web' then
   update
      vend
      prepay_only
      base_rpt
   with frame a
   editing:

      if frame-field = "vend" then do for ap_mstr:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01a.i ap_mstr vend ap_vend vend_space
               ap_vend ap_vend_date}

         if recno <> ? then do:
            vend = ap_vend.
            find vd_mstr where vd_addr = vend no-lock.
            display vend vd_sort vd_prepay with frame a.
            recno = ?.
         end.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.

   end.

   {wbrp06.i &command = update
      &fields = "  vend prepay_only base_rpt" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      status input "".
      display "" @ vd_sort with frame a.

      find vd_mstr where vd_addr = vend no-lock no-error.
      if available vd_mstr then
         display vd_sort vd_prepay with frame a.

      hide frame b.
      hide frame c.
      hide frame d.

   end.
   */
   /* SS - 20060107 - E */

   /* SS - 20060107 - B */
   /*
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
   */   
   define variable l_textfile        as character no-undo.
   /* SS - 20060107 - E */

   for each ap_mstr 
      /* SS - 20060107 - E */
      /*
      where ap_vend = vend
      */
      where ap_vend >= vend
      AND ap_vend <= vend1
      /* SS - 20060107 - B */
      and ((ap_curr = base_rpt) or (base_rpt = ""))
      and ap_type = "VO"
      no-lock use-index ap_vend,
      each vo_mstr where vo_ref = ap_ref and vo_prepay <> 0
         and (vo_prepay <> 0 or prepay_only = no)
   no-lock by ap_effdate descending:

      {mfrpchk.i}

      assign
         base_amt = ap_amt
         base_prepay = vo_prepay
         base_hold_amt = vo_hold_amt
         base_applied = vo_applied
         disp_curr = "".

      if base_rpt = ""
         and ap_curr <> base_curr
      then do:

         assign
            base_amt = ap_base_amt
            base_hold_amt = vo_base_hold_amt
            base_applied = vo_base_applied
            disp_curr     = getTermLabel("YES",1).

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ap_curr,
              input base_curr,
              input ap_ex_rate,
              input ap_ex_rate2,
              input base_prepay,
              input true, /* ROUND */
              output base_prepay,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

      end.

      find first vpo_det where vpo_ref = vo_ref no-lock no-error.
      vopo = if available vpo_det then vpo_po else "".


      /* SS - 20060107 - B */
      /*
      {&APVNIQ01-P-TAG1}
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      {&APVNIQ01-P-TAG2}

      display
         ap_ref          colon 11 format "x(8)"
         vo_invoice      colon 35
         base_prepay     colon 59
         ap_date         colon 11
         vo_cr_terms     colon 35
         base_amt        colon 59
         ap_effdate      colon 11
         ap_entity       colon 35
         base_applied    colon 59
         (ap_ex_rate / ap_ex_rate2) @ ap_ex_rate
         colon 11 label {&apvniq01_p_3}
         ap_curr         colon 60
         disp_curr                no-label
         ap_acct         colon 11
         ap_sub                   no-label
         ap_cc                    no-label
         ap_vend         colon 11
         vopo            colon 35
         ap_batch        colon 59
         vo_confirmed    colon 11
         vo_conf_by      colon 35
         vo_type         colon 59
         ap_ckfrm        colon 11
         {&APVNIQ01-P-TAG3} format "x(1)" {&APVNIQ01-P-TAG4}
         base_hold_amt   colon 35
      with frame b side-labels width 80.
      */
      CREATE tta6apvniq0101.
      ASSIGN
         tta6apvniq0101_ap_ref = ap_ref
         tta6apvniq0101_vo_invoice = vo_invoice
         tta6apvniq0101_base_prepay = base_prepay
         tta6apvniq0101_ap_date = ap_date
         tta6apvniq0101_vo_cr_terms = vo_cr_terms
         tta6apvniq0101_base_amt = base_amt
         tta6apvniq0101_ap_effdate = ap_effdate
         tta6apvniq0101_ap_entity = ap_entity
         tta6apvniq0101_base_applied = base_applied
         tta6apvniq0101_ap_ex_rate = ap_ex_rate
         tta6apvniq0101_ap_ex_rate2 = ap_ex_rate2
         tta6apvniq0101_ap_curr = ap_curr
         tta6apvniq0101_disp_curr = DISP_curr
         tta6apvniq0101_ap_acct = ap_acct
         tta6apvniq0101_ap_sub = ap_sub
         tta6apvniq0101_ap_cc = ap_cc
         tta6apvniq0101_ap_vend = ap_vend
         tta6apvniq0101_vopo = vopo
         tta6apvniq0101_ap_batch = ap_batch
         tta6apvniq0101_vo_confirmed = vo_confirmed
         tta6apvniq0101_vo_conf_by = vo_conf_by
         tta6apvniq0101_vo_type = vo_type
         tta6apvniq0101_ap_ckfrm = ap_ckfrm
         tta6apvniq0101_base_hold_amt = base_hold_amt
         .
      /* SS - 20060107 - E */

      /* SS - 20060107 - B */
      /*
      for each vod_det where vod_ref = ap_ref
      no-lock with frame c width 80
      on endkey undo, leave:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).

         {mfrpchk.i}

         base_damt = vod_amt.

         if base_rpt = ""
            and base_curr <> ap_curr
         then do:
            base_damt = vod_base_amt.
         end.

         display
            vod_ln
            vod_acct
            vod_sub no-label
            vod_cc no-label
            vod_project
            vod_entity
            space(10)
            base_damt
            skip
            space(4)
            vod_desc
         with title color normal (getFrameTitle("DISTRIBUTION",19)).

      end.

      for each ckd_det where ckd_voucher = ap_ref no-lock,
         each ck_mstr where ck_ref = ckd_ref and ck_status <> "Void"
      no-lock with frame d width 80
      on endkey undo, leave:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame d:handle).

         {mfrpchk.i}

         find apmstr where apmstr.ap_ref = ckd_ref
            and apmstr.ap_type = "CK" no-lock.

         assign
            disp_curr = ""
            base_camt = ckd_amt
            base_disc = ckd_disc.

         if base_rpt = ""
            and apmstr.ap_curr <> base_curr
         then do:

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ap_curr,
                 input base_curr,
                 input ap_ex_rate,
                 input ap_ex_rate2,
                 input base_camt,
                 input true, /* ROUND */
                 output base_camt,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ap_curr,
                 input base_curr,
                 input ap_ex_rate,
                 input ap_ex_rate2,
                 input base_disc,
                 input true, /* ROUND */
                 output base_disc,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
            disp_curr = getTermLabel("YES",1).

         end.

         display
            apmstr.ap_date
            ckd_ref
            {&APVNIQ01-P-TAG5} format "x(8)" {&APVNIQ01-P-TAG6}
            base_camt
            base_disc
            apmstr.ap_curr
            disp_curr no-label
         with title color normal (getFrameTitle("PAYMENTS",13)).

         release apmstr.

      end.

      /* MULTIPLE PO'S BEGIN */
      find vpo_det where vpo_ref = vo_ref no-lock no-error.
      if ambiguous vpo_det then do:
         view-pos = no.
         {pxmsg.i &MSGNUM=2220 &ERRORLEVEL=1
            &CONFIRM=view-pos
            &CONFIRM-TYPE='LOGICAL'}
         if view-pos then do:
            for each vpo_det where vpo_ref = vo_ref no-lock
            with frame polist 6 down overlay centered row 8:
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame polist:handle).
               display vpo_po.
            end.
            if c-application-mode <> 'web' then
               pause.
            hide frame polist.
         end.
      end.
      */
      /* SS - 20060107 - E */
   end. /* FOR EACH AP_MSTR */

   /* SS - 20060107 - B */
   /*
   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end. /* REPEAT */
*/
/* SS - 20060107 - E */

{wbrp04.i &frame-spec = a}
