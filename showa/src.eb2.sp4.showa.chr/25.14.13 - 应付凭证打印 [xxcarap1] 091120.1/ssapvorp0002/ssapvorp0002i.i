/* apvorp.i - AP VOUCHER REGISTER INCLUDE FILE                                */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.36.1.1 $                                                          */
/* REVISION: 7.0      LAST MODIFIED: 03/02/92   BY: MLV *F461*                */
/* REVISION: 7.3      LAST MODIFIED: 08/03/92   by: jms *G024*                */
/*                                   10/09/92   by: jms *G161*                */
/*                                   04/20/93   by: jms *G985*                */
/*                                   07/26/93   by: wep *GD59*                */
/*                                   08/05/93   by: wep *H054*                */
/*                                   09/29/93   by: bcm *H143*                */
/* Revision: 7.4          Last edit: 04/04/94   By: pcd *H318*                */
/* REVISION: 7.4      LAST MODIFIED: 09/12/94   by: slm *GM17*                */
/*                                   02/23/95   by: pxe *F0K5*                */
/*                                   10/30/95   by: mys *G1BL*                */
/* REVISION: 8.5      LAST MODIFIED: 01/29/96  by: mwd  *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 02/28/96   BY: *J0CV* Brandy J Ewing     */
/*                                   04/05/96   BY: jzw *G1T9*                */
/*                                   07/31/96   by: M. Deleeuw *J12H*         */
/*                                   09/12/96   by: jzw *H0MS*                */
/*                                   10/01/96   by: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 06/09/97   BY: *G2N8* Samir Bavkar       */
/* REVISION: 8.6      LAST MODIFIED: 01/23/98   BY: *J2B6* Prashanth Narayan  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* RVSL               */
/* REVISION: 8.6E     LAST MODIFIED: 05/14/98   BY: *J2LY* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.14              */
/* REVISION: 8.6E    LAST MODIFIED: 10/06/98   BY: *L09C* Santhosh Nair       */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala       */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1     LAST MODIFIED: 06/28/00   BY: *L0ZX* Falguni Dalal       */
/* REVISION: 9.1     LAST MODIFIED: 06/30/00   BY: *N0C9* Inna Lyubarsky      */
/* REVISION: 9.1     LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                 */
/* REVISION: 9.1     LAST MODIFIED: 09/21/00   BY: *N0W0* Mudit Mehta         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.25     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.26     BY: Ed van de Gevel       DATE: 11/09/01  ECO: *N15M*  */
/* Revision: 1.29     BY: Mercy C.              DATE: 03/18/02  ECO: *M1WF*  */
/* Revision: 1.31     BY: Patrick Rowan         DATE: 04/17/02  ECO: *P043*  */
/* Revision: 1.33     BY: Paul Donnelly         DATE: 12/10/01  ECO: *N16J*  */
/* Revision: 1.34     BY: Hareesh V.            DATE: 06/14/02  ECO: *N1HY*  */
/* Revision: 1.35     BY: Dorota Hohol          DATE: 03/17/03  ECO: *P0NR*  */
/* Revision: 1.36     BY: Orawan S.             DATE: 04/23/03  ECO: *P0QC*  */
/* $Revision: 1.36.1.1 $     BY: Manish Dani           DATE: 06/24/03  ECO: *P0VZ*  */

/*V8:ConvertMode=Report                                                       */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 091120.1 By: Bill Jiang */

/* SS - 091120.1 - B */
{ssapvorp0002.i}
/* SS - 091120.1 - E */

/*!  &sort1 = ap_batch or ap_vend */
{cxcustom.i "APVORP.I"}
{apconsdf.i}

/* DEFINE VARIABLES USED IN CALLED PGM TXDETRP.P */
define shared variable rndmthd like rnd_rnd_mthd.
define shared variable oldsession as   character no-undo.
define        variable old_curr like ap_curr.
{txcurvar.i}

{pxpgmmgr.i}

define variable ico_acct as character no-undo.
define variable ico_sub as character no-undo.
define variable ico_cc as character no-undo.

define variable remit_label as character format "x(17)".
define variable remit_name like ad_name.
define variable l_ref      like gltw_ref no-undo.
define variable multiple as character format "x(9)" no-undo.
define variable remit_to as character format "x(17)" no-undo.
define variable l_base_amt_fmt       as   character                no-undo.
define variable l_curr_amt_fmt       as   character                no-undo.
define variable l_curr_amt_old       as   character                no-undo.
define variable l_doc_numeric_format as   character                no-undo.

{&APVORP-I-TAG8}
assign
   multiple = getTermLabel("MULTIPLE",8) + "*"
   remit_to = getTermLabel("REMIT_TO",16) + ":".

{&APVORP-I-TAG1}
{&APVORP-I-TAG9}
form
   /* Line 1 */
   vo_ref          colon  10
   ap_date         colon  39
   vd_remit        colon  58 label "Remit-To"
   ap_curr         colon  79
   disp_curr       colon  93
   ap_amt          colon 110
   /* Line 2 */
   vopo            colon  10
   ap_effdate      colon  39
   vo_ship         colon  58
   curr_disp_line1 colon  79 label "Exch Rate"
   ap_acct         colon  10
   ap_sub                    no-label
   ap_cc                     no-label
   /* Line 2a if needed */
   curr_disp_line2 at 81     no-label
   /* CURR_DISP_LINE2 LINES-UP WITH CURR_DISP_LINE1 */
   /* Line 3 */
   skip(1)
   ap_vend         colon  10
   vo_due_date     colon  39
   vo_invoice      colon  58
   ap_bank         colon  79
   vo_ndisc_amt    colon 110
   /* Line 4 */
   name            at      1 no-label
   vo_disc_date    colon  39
   ap_entity       colon  58
   vo_type         colon  79
   vo_applied      colon 110
   flag            at    128 no-label
   /* Line 5 */
   ap_rmk          at      1 no-label
   ap_ckfrm        colon  39 format "x(1)"
   vo_confirmed    colon  58
   vo_conf_by      colon  79
   vo_hold_amt     colon 110
   /* Line 6 */
   vo_is_ers       colon  39
   remit_label     at     31 no-label
   remit_name                no-label
   ap_batch        colon 110
with frame {&frame1} side-labels width 132 no-attr-space down.
{&APVORP-I-TAG10}
{&APVORP-I-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame {&frame1}:handle).
{&APVORP-I-TAG3}

/*  Form for Totals.        */
form
   batch_title     to    108 no-label   skip
   ap_amt          colon 110 skip
   vo_ndisc_amt    colon 110 skip
   vo_applied      colon 110 skip
   vo_hold_amt     colon 110
with frame {&frame2} side-labels  width 132 no-attr-space down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame {&frame2}:handle).

/* FORM FOR VOUCHER DETAILS - TO GET THE CORRECT FORMAT */
form
   space(4)
   vod_ln
   vod_acct
   vod_sub
   vod_cc
   vod_project
   vod_entity
   base_damt
   vod_desc
with frame {&frame3} width 132 no-attr-space down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame {&frame3}:handle).

/* FORM FOR PO RECEIPTS DETAILS - TO GET THE CORRECT FORMAT */
form
   space(4)
   prh_receiver
   prh_line
   prh_nbr
   prh_part
   prh_um
   prh_type
   prh_rcvd
   vph_inv_qty
   pur_amt
   prh_curr
   inv_amt
   vo_curr
with frame {&frame4} width 132 no-attr-space down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame {&frame4}:handle).

assign
   l_base_amt_fmt = ap_amt:format in frame {&frame1}
   l_curr_amt_old = ap_amt:format in frame {&frame1}.

/* TO GET BASE CURRENCY FORMAT */
{gprun.i ""gpcurfmt.p""
   "(input-output l_base_amt_fmt,
     input        gl_rnd_mthd)"}

for each ap_mstr where (ap_batch >= batch)
      and (ap_batch <= batch1)
      and (ap_ref >= ref)
      and (ap_ref <= ref1)
      and (ap_vend >= vend)
      and (ap_vend <= vend1)
      and (ap_date >= apdate)
      and (ap_date <= apdate1)
      and (ap_effdate >= effdate)
      and (ap_effdate <= effdate1)
      and (ap_entity >= entity)
      and (ap_entity <= entity1)
      and (ap_type = "VO")
      and (ap_open = yes or open_only = no)
      and ((ap_curr = base_rpt)
      or (base_rpt = "")) no-lock,
      each vo_mstr where vo_ref = ap_ref
      and (vo_confirmed = yes or show_unconf = yes)
      and (vo_type >= votype and vo_type <= votype1)
      and (vo_is_ers = yes or only_ers = no)
      and (vo_confirmed = no  or show_conf = yes) no-lock,
      each vd_mstr where vd_addr = ap_vend and
      (vd_type >= vdtype and vd_type <= vdtype1)
      no-lock break by {&sort1} by ap_ref
   with frame {&frame1} width 132 down:

   /* SS - 091120.1 - B
   {&APVORP-I-TAG11}
   clear frame {&frame1} all.
   clear frame {&frame2} all.

   /* RESET SESSION TO BASE NUMERIC FORMAT */
   SESSION:numeric-format = oldsession.
   SS - 091120.1 - E */

   /* NOTE GET THE ROUNDING METHOD FOR USE IN THE CALLED */
   /* PROGRAM TXDETRP.P */
   if ap_curr <> old_curr or old_curr = "" then do:

      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input ap_curr,
           output rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         rndmthd = gl_rnd_mthd.
      end.

      /* TO GET FOREIGN CURRENCY FORMAT */
      l_curr_amt_fmt = l_curr_amt_old.
      {gprun.i ""gpcurfmt.p""
         "(input-output l_curr_amt_fmt,
           input        rndmthd)" }

      /* TO GET PUNCTUATION (DECIMAL FORMAT) OF THE ROUNDING METHOD */
      {gprunp.i "mcpl" "p" "mc-get-curr-decimal-format"
         "(input  rndmthd,
           output l_doc_numeric_format,
           output mc-error-number)"}
      if mc-error-number <> 0
      then
         l_doc_numeric_format = oldsession.

      /* TO SET FORMATS ONLY ONCE FOR SAME CURRENCY VOUCHERS */
      old_curr = ap_curr.

   end.

   if ap_curr = base_curr or ap_curr = base_rpt
   then
      assign
         base_amt = ap_amt
         base_applied = vo_applied
         base_hold_amt = vo_hold_amt
         base_ndamt = vo_ndisc_amt
         disp_curr = " ".
   else
      assign
         base_amt = ap_base_amt
         base_applied = vo_base_applied
         base_hold_amt = vo_base_hold_amt
         base_ndamt = vo_base_ndisc
         disp_curr = getTermLabel("YES",1).

   /* TO SET CORRECT CURRENCY DECIMAL FORMAT FOR EXCHANGE RATES */
   if base_rpt = ""
      and not mixed_rpt
   then
      SESSION:numeric-format = oldsession.
   else
      SESSION:numeric-format = l_doc_numeric_format.

   /* BUILD DISPLAY TEXT FOR EXCHANGE RATE */
   {gprunp.i "mcui" "p" "mc-ex-rate-output"
      "(input ap_curr,
        input base_curr,
        input ap_ex_rate,
        input ap_ex_rate2,
        input ap_exru_seq,
        output curr_disp_line1,
        output curr_disp_line2)"}

   if base_hold_amt = 0 then flag = "".
   else flag = "*".

   /* SS - 091120.1 - B
   accumulate base_amt (total by {&sort1}).
   accumulate base_applied (total by {&sort1}).
   accumulate base_hold_amt (total by {&sort1}).
   accumulate base_ndamt (total by {&sort1}).

   if sort_by_vend and first-of({&sort1}) then
   do with frame {&frame5}:
      name = "".
      find ad_mstr where ad_addr = ap_vend no-lock no-error.
      if available ad_mstr then name = ad_name.
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame {&frame5}:handle).
      display ap_vend name with frame {&frame5} side-labels.
   end.
   else
   if sort_by_vend = no and first-of({&sort1}) then
   do with frame {&frame6}:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame {&frame6}:handle).
      display ap_batch with frame {&frame6} side-labels.
   end.
   put skip(1).
   SS - 091120.1 - E */
   
   name = "".
   find ad_mstr where ad_addr = ap_vend no-lock no-wait no-error.
   if available ad_mstr then name = ad_name.

   assign
      remit_label = ""
      remit_name = "".
   if vd_misc_cr and ap_remit <> "" then do:
      find ad_mstr where ad_addr = ap_remit
         no-lock no-error.
      assign
         remit_label = if available ad_mstr then remit_to
                       else ""
         remit_name = if available ad_mstr then ad_name
                      else "".
   end.

   /* IF MULTIPLE POS ARE ATTACHED TO A VOUCHER, SHOW ALL */
   /* POS BELOW THE HEADER SECTION AND WITHIN THE HEADER, */
   /* IN PLACE OF PO NUMBER, DISPLAY "Multiple*"          */
   find vpo_det where vpo_ref = vo_ref no-lock no-error.
   if ambiguous vpo_det then
      vopo = multiple.
   else
   if not available vpo_det
      then vopo = "".
   else vopo = vpo_po.

   /* SS - 091120.1 - B
   if page-size - line-counter < 4 then page.

   /* TO SET CORRECT CURRENCY FORMAT IN FRAME {&frame1} */
   if base_rpt = ""
      and not mixed_rpt
   then
      assign
         SESSION:numeric-format                 = oldsession
         ap_amt:format       in frame {&frame1} = l_base_amt_fmt
         vo_ndisc_amt:format in frame {&frame1} = l_base_amt_fmt
         vo_applied:format   in frame {&frame1} = l_base_amt_fmt
         vo_hold_amt:format  in frame {&frame1} = l_base_amt_fmt.

   else
      assign
         SESSION:numeric-format                 = l_doc_numeric_format
         ap_amt:format       in frame {&frame1} = l_curr_amt_fmt
         vo_ndisc_amt:format in frame {&frame1} = l_curr_amt_fmt
         vo_applied:format   in frame {&frame1} = l_curr_amt_fmt
         vo_hold_amt:format  in frame {&frame1} = l_curr_amt_fmt.

   /* If all currencies are selected, */
   /* Then these amounts will be display in the currency entered.*/
   if base_rpt = ""
      and mixed_rpt
      and disp_curr = getTermLabel("YES",1)
   then do:
      disp_curr = "".
      display disp_curr ap_amt vo_ndisc_amt vo_applied vo_hold_amt
      with frame {&frame1} width 132 down no-box.
   end.
   /*If base is selected, then amounts shown will be in base. */
   else
   display disp_curr base_amt @ ap_amt base_ndamt @ vo_ndisc_amt
      base_applied @ vo_applied base_hold_amt @ vo_hold_amt
   with frame {&frame1} width 132 down no-box.

   {&APVORP-I-TAG12}
   /* PRINT ap_ent_ex AS EXCHANGE RATE */

   {&APVORP-I-TAG13}
   display
      vo_ref
      ap_date
      vd_remit
      ap_curr
      curr_disp_line1
      curr_disp_line2 when(curr_disp_line2 <> "")
      ap_vend
      ap_effdate
      vo_ship
      ap_bank
      vopo
      vo_due_date
      vo_invoice
      name
      ap_acct
      ap_sub
      ap_cc
      vo_disc_date
      ap_entity
      ap_rmk flag
      vo_confirmed
      vo_conf_by
      vo_is_ers
      remit_label remit_name
      ap_ckfrm
      vo_type
      ap_batch
   with frame {&frame1}.

   {&APVORP-I-TAG14}
   down with frame {&frame1}.

   /* SHOW MULTIPLE PURCHASE ORDER NUMBERS */

   if vopo = multiple then
   for each vpo_det where vpo_ref = vo_ref no-lock
      with frame {&frame7}:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame {&frame7}:handle).
      display vpo_po column-label "*PO Numbers"
      with frame {&frame7} width 132 down no-box.
   end.

   /*  STORE TOTALS, BY CURRENCY, IN WORK FILE.                */
   if base_rpt = ""
      and mixed_rpt
   then do:
      find first ap_wkfl where vo_curr = apwk_curr no-error.
      /* If a record for this currency doesn't exist, create one. */
      if not available ap_wkfl then do:
         create ap_wkfl.
         apwk_curr = ap_curr.
      end.
      /* Accumulate individual currency totals in work file. */
      apwk_for = apwk_for + ap_amt.
      if base_curr <> ap_curr then
         apwk_base = apwk_base + base_amt.
      else
         apwk_base = apwk_for.
   end.

   /* Gltw_ref PREFIXED BY mfguser TO ENSURE UNIQUE gltw_wkfl */
   /* RECORDS FOR EACH MFG/PRO SESSION                        */
   l_ref = mfguser + ap_vend.

   if gltrans then do:
      {gpnextln.i &ref=l_ref &line=return_int}
      create gltw_wkfl.
      assign
         gltw_entity = ap_entity
         gltw_acct = ap_acct
         gltw_sub = ap_sub
         gltw_cc = ap_cc
         gltw_ref = l_ref
         gltw_line = return_int
         gltw_date = ap_date
         gltw_effdate = ap_effdate
         gltw_userid = mfguser
         gltw_desc = ap_batch + " " + ap_type + " " + ap_ref
                     + " " + ap_vend
         gltw_amt = - base_amt
         recno = recid(gltw_wkfl).
         {&APVORP-I-TAG4}
   end.

   /* SHOW PURCHASE RECEIVERS INVOICED BY THIS VOUCHER */
   if show_vph then do:
      for each vph_hist where vph_ref = ap_ref no-lock
               use-index vph_ref,
          each pvo_mstr no-lock where
               pvo_lc_charge   = "" and
               pvo_internal_ref_type = {&TYPE_POReceiver} and
               pvo_id = vph_pvo_id
            with frame {&frame4} width 132:

         find prh_hist where prh_receiver = pvo_internal_ref
            and prh_line = pvo_line no-lock no-error.

         if available prh_hist then do:

            clear frame {&frame4} all.

            if base_rpt = ""
               and not mixed_rpt
            then
               assign
                  SESSION:numeric-format            = oldsession
                  pur_amt:format in frame {&frame4} = l_base_amt_fmt
                  inv_amt:format in frame {&frame4} = l_base_amt_fmt
                  pur_amt                           = prh_pur_cost
                  inv_amt                           = vph_inv_cost.
            else
               assign
                  SESSION:numeric-format            = l_doc_numeric_format
                  pur_amt:format in frame {&frame4} = l_curr_amt_fmt
                  inv_amt:format in frame {&frame4} = l_curr_amt_fmt
                  pur_amt                           = prh_curr_amt
                  inv_amt                           = vph_curr_amt.

            pur_amt = pur_amt * prh_um_conv.

            display space(4)
               prh_receiver
               prh_line
               prh_nbr
               prh_part
               prh_um
               prh_type
               prh_rcvd
               vph_inv_qty
               pur_amt
               prh_curr
               inv_amt
               vo_curr.

            down with frame {&frame4}.

         end.
      end.
   end. /*if show purchase receipts*/
   SS - 091120.1 - E */
   
   /* GET AP DETAIL  */
   for each vod_det where vod_ref = ap_ref no-lock
         by vod_ln
      with frame {&frame3} width 132:

      /* SS - 091120.1 - B
      clear frame {&frame3} all.

      /* ASSIGNMENT OF FORMATS FOR {&frame3} */
      if base_rpt = ""
         and not mixed_rpt
      then
         assign
            SESSION:numeric-format              = oldsession
            base_damt:format in frame {&frame3} = l_base_amt_fmt.

      else
         assign
            SESSION:numeric-format              = l_doc_numeric_format
            base_damt:format in frame {&frame3} = l_curr_amt_fmt.
      SS - 091120.1 - E */
      
      if ap_curr = base_curr or ap_curr = base_rpt then
         base_damt = vod_amt.
      else
         base_damt = vod_base_amt.

      if summary = no then do:
         /* SS - 091120.1 - B
         display space(4)
            vod_ln
            vod_acct
            vod_sub
            vod_cc
            vod_project
            vod_entity
            (if base_rpt = "" and mixed_rpt
            then vod_amt
            else base_damt)
            @ base_damt
            vod_desc.

         down with frame {&frame3}.
         SS - 091120.1 - E */
         /* SS - 091120.1 - B */
         CREATE ttssapvorp0002.
         ASSIGN
            /* Line 1 */
            ttssapvorp0002_vo_ref = vo_ref
            ttssapvorp0002_ap_date = ap_date
            ttssapvorp0002_vd_remit = vd_remit
            ttssapvorp0002_ap_curr = ap_curr
            /* Line 2 */
            ttssapvorp0002_vopo = vopo
            ttssapvorp0002_ap_effdate = ap_effdate
            ttssapvorp0002_vo_ship = vo_ship
            ttssapvorp0002_curr_disp_line1 = curr_disp_line1
            ttssapvorp0002_ap_acct = ap_acct
            ttssapvorp0002_ap_sub = ap_sub
            ttssapvorp0002_ap_cc = ap_cc
            /* Line 2a if needed */
            ttssapvorp0002_curr_disp_line2 = curr_disp_line2
            /* CURR_DISP_LINE2 LINES-UP WITH CURR_DISP_LINE1 */
            /* Line 3 */
            ttssapvorp0002_ap_vend = ap_vend
            ttssapvorp0002_vo_due_date = vo_due_date
            ttssapvorp0002_vo_invoice = vo_invoice
            ttssapvorp0002_ap_bank = ap_bank
            /* Line 4 */
            ttssapvorp0002_name = name
            ttssapvorp0002_vo_disc_date = vo_disc_date
            ttssapvorp0002_ap_entity = ap_entity
            ttssapvorp0002_vo_type = vo_type
            ttssapvorp0002_flag = flag
            /* Line 5 */
            ttssapvorp0002_ap_rmk = ap_rmk 
            ttssapvorp0002_ap_ckfrm = ap_ckfrm
            ttssapvorp0002_vo_confirmed = vo_confirmed
            ttssapvorp0002_vo_conf_by = vo_conf_by
            /* Line 6 */
            ttssapvorp0002_vo_is_ers = vo_is_ers
            ttssapvorp0002_remit_label = remit_label
            ttssapvorp0002_remit_name = remit_name
            ttssapvorp0002_ap_batch = ap_batch
            .

         /* If all currencies are selected, */
         /* Then these amounts will be display in the currency entered.*/
         if base_rpt = ""
            and mixed_rpt
            and disp_curr = getTermLabel("YES",1)
         then do:
            disp_curr = "".
            ASSIGN
               ttssapvorp0002_disp_curr = DISP_curr
               ttssapvorp0002_ap_base_amt = ap_amt
               ttssapvorp0002_vo_ndisc_amt = vo_ndisc_amt
               ttssapvorp0002_vo_applied = vo_applied
               ttssapvorp0002_vo_hold_amt = vo_hold_amt
               .
         end.
         /*If base is selected, then amounts shown will be in base. */
         else DO:
            ASSIGN
               ttssapvorp0002_disp_curr = DISP_curr
               ttssapvorp0002_ap_base_amt = base_amt
               ttssapvorp0002_vo_ndisc_amt = base_ndamt
               ttssapvorp0002_vo_applied = base_applied
               ttssapvorp0002_vo_hold_amt = base_hold_amt
               .
         END.
         ASSIGN
            ttssapvorp0002_ap_amt = ap_amt
            ttssapvorp0002_ap_ex_rate = ap_ex_rate
            ttssapvorp0002_ap_ex_rate2 = ap_ex_rate2
            .

         ASSIGN
            ttssapvorp0002_vod_ln = vod_ln
            ttssapvorp0002_vod_acc = vod_acct
            ttssapvorp0002_vod_sub = vod_sub
            ttssapvorp0002_vod_cc = vod_cc
            ttssapvorp0002_vod_project = vod_project
            ttssapvorp0002_vod_entity = vod_entity
            ttssapvorp0002_vod_desc = vod_desc
            .
         if base_rpt = "" and mixed_rpt then DO:
            ASSIGN 
               ttssapvorp0002_vod_base_amt = vod_amt
               .
         END.
         else DO:
            assign
               ttssapvorp0002_vod_base_amt = base_damt
               .
         END.
         ASSIGN 
            ttssapvorp0002_vod_amt = vod_amt
            .
         /* SS - 091120.1 - E */
      end.
      /* SS - 091120.1 - B
      if gltrans then do:
         {gpnextln.i &ref=l_ref &line=return_int}
         create gltw_wkfl.
         assign
            gltw_entity = vod_entity
            gltw_acct = vod_acct
            gltw_sub = vod_sub
            gltw_cc = vod_cc
            gltw_project = vod_project
            gltw_ref = l_ref
            gltw_line = return_int
            gltw_date = ap_date
            gltw_effdate = ap_effdate
            gltw_userid = mfguser
            gltw_desc = ap_batch + " " + ap_type + " " + ap_ref
                       + " " + ap_vend
            gltw_amt = base_damt
            recno = recid(gltw_wkfl).
            {&APVORP-I-TAG5}
         /*FOLLOWING SECTION FOR INTERCOMPANY TRANSACTION*/
         {glenacex.i &entity=ap_entity
                     &type='"CR"'
                     &module='"AP"'
                     &acct=ico_acct
                     &sub=ico_sub
                     &cc=ico_cc }
         if (ap_entity <> vod_entity)
         then do:
            /*CREDIT DETAIL ENTITY*/
            {gpnextln.i &ref=l_ref &line=return_int}
            create gltw_wkfl.
            assign
               gltw_entity = vod_entity
               gltw_acct = ico_acct
               gltw_sub = ico_sub
               gltw_cc = ico_cc
               gltw_ref = l_ref
               gltw_line = return_int
               gltw_date = ap_date
               gltw_effdate = ap_effdate
               gltw_userid = mfguser
               gltw_desc = ap_batch + " " + ap_type + " " + ap_ref
                          + " " + ap_vend
               gltw_amt = - base_damt
               recno = recid(gltw_wkfl).
               {&APVORP-I-TAG6}
            /*DEBIT HEADER ENTITY*/
            {glenacex.i &entity=vod_entity
                        &type='"DR"'
                        &module='"AP"'
                        &acct=ico_acct
                        &sub=ico_sub
                        &cc=ico_cc }
            {gpnextln.i &ref=l_ref &line=return_int}
            create gltw_wkfl.
            assign
               gltw_entity = ap_entity
               gltw_acct = ico_acct
               gltw_sub = ico_sub
               gltw_cc = ico_cc
               gltw_ref = l_ref
               gltw_line = return_int
               gltw_date = ap_date
               gltw_effdate = ap_effdate
               gltw_userid = mfguser
               gltw_desc = ap_batch + " " + ap_type + " " + ap_ref
                          + " " + ap_vend
               gltw_amt = base_damt
               recno = recid(gltw_wkfl).
               {&APVORP-I-TAG7}
         end.
      end.
      SS - 091120.1 - E */
   end. /* FOR EACH VOD_DET */

   /* SS - 091120.1 - B
   {&APVORP-I-TAG15}
   undo_txdetrp = true.

   /* ADDED SIXTH INPUT PARAMETER base_rpt AND SEVENTH INPUT     */
   /* PARAMETER mixed_rpt TO ACCOMMODATE THE LOGIC INTRODUCED IN */
   /* txdetrpa.i FOR DISPLAYING THE APPROPRIATE CURRENCY AMOUNT. */

   {gprun.i  ""txdetrp.p"" "(input tax_tr_type,
                               input ap_ref,
                               input '*',
                               input col-80,
                               input page_break,
                               input base_rpt,
                               input mixed_rpt)" }
   if undo_txdetrp = true then undo, leave.
   {&APVORP-I-TAG16}

   /* ASSIGNMENT OF FORMATS FOR {&frame2} */
   if base_rpt = ""
   then
      assign
         SESSION:numeric-format                 = oldsession
         ap_amt:format       in frame {&frame2} = l_base_amt_fmt
         vo_ndisc_amt:format in frame {&frame2} = l_base_amt_fmt
         vo_applied:format   in frame {&frame2} = l_base_amt_fmt
         vo_hold_amt:format  in frame {&frame2} = l_base_amt_fmt.
   else
      assign
         SESSION:numeric-format                 = l_doc_numeric_format
         ap_amt:format       in frame {&frame2} = l_curr_amt_fmt
         vo_ndisc_amt:format in frame {&frame2} = l_curr_amt_fmt
         vo_applied:format   in frame {&frame2} = l_curr_amt_fmt
         vo_hold_amt:format  in frame {&frame2} = l_curr_amt_fmt.

   if sort_by_vend = no and
      last-of({&sort1}) then do:
      /*Display Batch Totals. */

      if page-size - line-counter < 4 then page.

      display
         (if base_rpt = "" then getTermLabel("BASE",4)
         else base_rpt)
         + " " + getTermLabel("BATCH",10) + " " + ap_batch + " " +
         getTermLabel("TOTAL",5)
         @ batch_title
         accum total by {&sort1} (base_amt)
         @ ap_amt
         accum total by {&sort1} (base_ndamt)
         @ vo_ndisc_amt
         accum total by {&sort1} (base_applied)
         @ vo_applied
         accum total by {&sort1} (base_hold_amt)
         @ vo_hold_amt
      with frame {&frame2}.
   end.

   if sort_by_vend and last-of({&sort1}) then do:
      /*Display Vendor Totals. */

      if page-size - line-counter < 4 then page.

      display
         (if base_rpt = "" then getTermLabel("BASE",4)
         else base_rpt)
         + " " + getTermLabel("SUPPLIER",10) + " " + ap_vend + " " +
         getTermLabel("TOTAL",5) + " "
         @ batch_title
         accum total by {&sort1} (base_amt)
         @ ap_amt
         accum total by {&sort1} (base_ndamt)
         @ vo_ndisc_amt
         accum total by {&sort1} (base_applied)
         @ vo_applied
         accum total by {&sort1} (base_hold_amt)
         @ vo_hold_amt
      with frame {&frame2}.
   end.

   down with frame {&frame2}.
   SS - 091120.1 - E */
   
   {mfrpchk.i}
end.

/* SS - 091120.1 - B
/*  Display Report Totals. */
if page-size - line-counter < 6 then page.
down with frame {&frame2}.

display
   (if base_rpt = "" then getTermLabel("BASE",8)
   else base_rpt)
   + " " + getTermLabel("REPORT_TOTAL",16) @ batch_title
   accum total (base_amt)
   @ ap_amt
   accum total (base_ndamt)
   @ vo_ndisc_amt
   accum total (base_applied)
   @ vo_applied
   accum total (base_hold_amt)
   @ vo_hold_amt
with  frame {&frame2}.
SS - 091120.1 - E */
