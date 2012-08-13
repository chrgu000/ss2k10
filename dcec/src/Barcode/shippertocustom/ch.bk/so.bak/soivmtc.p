/* GUI CONVERTED from soivmtc.p (converter v1.75) Mon Nov  6 02:52:49 2000 */
/* soivmtc.p - INVOICE MAINTENANCE TRAILER                              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 5.0      LAST MODIFIED: 01/28/89   BY: MLB *B024**/
/* REVISION: 5.0      LAST MODIFIED: 06/29/89   BY: MLB *B163**/
/* REVISION: 5.0      LAST MODIFIED: 10/11/89   BY: MLB *B324**/
/* REVISION: 5.0      LAST MODIFIED: 03/15/90   BY: ftb *B619**/
/* REVISION: 6.0      LAST MODIFIED: 08/16/90   BY: MLB *D055**/
/* REVISION: 5.0      LAST MODIFIED: 08/18/90   BY: MLB *B755**/
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: MLB *D148**/
/* REVISION: 6.0      LAST MODIFIED: 12/11/90   BY: MLB *D238**/
/* REVISION: 6.0      LAST MODIFIED: 04/05/91   BY: bjb *D507**/
/* REVISION: 6.0      LAST MODIFIED: 04/26/91   BY: MLV *D559**/
/* REVISION: 6.0      LAST MODIFIED: 07/07/91   BY: afs *D747**/
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015**/
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 6.0      LAST MODIFIED: 10/14/91   BY: dgh *D892**/
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: tjs *F273**/
/* REVISION: 7.0      LAST MODIFIED: 03/25/92   BY: tmd *F263**/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358**/
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: tjs *F421**/
/* REVISION: 7.0      LAST MODIFIED: 05/28/92   By: jcd *F402**/
/* REVISION: 7.0      LAST MODIFIED: 06/24/92   By: jjs *F681**/
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F676**/
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458**/
/* REVISION: 7.3      LAST MODIFIED: 09/16/92   BY: tjs *G035**/
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: afs *G219**/
/* REVISION: 7.3      LAST MODIFIED: 03/19/93   BY: tjs *G588**/
/* REVISION: 7.3      LAST MODIFIED: 02/10/93   BY: bcm *G416**/
/* REVISION: 7.3      LAST MODIFIED: 03/23/93   BY: tjs *G858**/
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009**/
/* REVISION: 7.4      LAST MODIFIED: 07/01/93   BY: bcm *H002**/
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049**/
/* REVISION: 7.4      LAST MODIFIED: 11/03/93   BY: bcm *H208**/
/* REVISION: 7.4      LAST MODIFIED: 06/17/94   BY: qzl *H394**/
/* REVISION: 7.2      LAST MODIFIED: 09/10/94   BY: dpm *FQ97**/
/* REVISION: 7.2      LAST MODIFIED: 09/21/94   BY: ljm *GM77**/
/* REVISION: 8.5      LAST MODIFIED: 07/14/95   BY: taf *J053**/
/* REVISION: 7.4      LAST MODIFIED: 12/27/95   BY: ais *G1HG**/
/* REVISION: 7.3      LAST MODIFIED: 06/01/96   BY: tzp *G1WZ**/
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: ajw *J12Q**/
/* REVISION: 8.5      LAST MODIFIED: 12/30/97   BY: *J281* Manish K. */

/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan  */
/* REVISION: 8.6E     LAST MODIFIED: 07/20/98   BY: *J2RS* Niranjan R. */
/* REVISION: 8.6E     LAST MODIFIED: 11/03/00   BY: *L15F* Kaustubh K  */

/*F402*/ {mfdeclre.i}

/*J053** INDENTED ENTIRE PROGRAM TO BRING UP TO STANDARDS */

/*J053*/ define shared variable rndmthd like rnd_rnd_mthd.
/*J12Q*/ define shared variable cr_terms_changed like mfc_logical no-undo.
         define shared variable so_recno as recid.
         define shared variable cm_recno as recid.
         define buffer somstr for so_mstr.
         define shared variable new_order like mfc_logical.
         define shared variable sotax_trl like tax_trl.
         define variable and_code like so_trl1_cd.
         define variable and_amt like so_trl1_amt.
         define variable jk as integer.
         define shared variable base_amt like ar_amt.
/*G588*/ define variable disc_pct like so_disc_pct.
/*G416*/ define new shared frame d.
/*J053*/ define shared frame sotot.
/*J053* /*G416*/ define new shared frame sotot. */
/*J053* /*H002*/ define new shared variable tax_edit like mfc_logical initial false.*/
/*J053* /*H002*/ define new shared variable tax_edit_lbl like mfc_char format "x(28)"*/
/*J053*       initial "       View/Edit Tax Detail:". */
/*G416*/ define new shared variable undo_trl2 like mfc_logical.
/*H009*/ define new shared variable undo_mtc3 like mfc_logical.
/*F402* end */
/*L00L*/ {etdcrvar.i "new"}
/*H049*/ define shared variable calc_fr    like mfc_logical.
/*H049*/ define shared variable disp_fr    like mfc_logical.
/*H049*/ define shared variable freight_ok like mfc_logical.
/*G1HG*/ define buffer simstr for si_mstr.
/*J053*/ define shared variable prepaid_fmt as character no-undo.
/*J053*/ define variable retval as integer no-undo.
/*G1WZ*/ define variable  valid_acct  like mfc_logical.
/*J281*/ define variable  l_consolidate_ok as logical   no-undo.
/*J281*/ define variable  l_msg_text       as character no-undo.
/*J2RS*/ define variable  l_inv_nbr        like so_inv_nbr no-undo.

/*J053* /*H009*/ {mfsotrla.i "NEW"} /* Define trailer variables and forms */ */
/*L00L* /*J053*/ {mfsotrla.i} /* Define trailer variables and forms */       */
/*L00L*/ {etsotrla.i}

/*J053* /*G416*/    {sototfrm.i} /* Define trailer form for Tax Management */ */
/*J053*/ {soivmt01.i}
/*J053*/ so_prepaid:format = prepaid_fmt.

         find first soc_ctrl no-lock.
         find first gl_ctrl no-lock.

/*L15F** find so_mstr where recid(so_mstr) = so_recno. */
/*L15F*/ for first so_mstr
/*L15F*/    fields(so_ar_acct so_ar_cc so_cr_card so_cr_init
/*L15F*/           so_curr so_disc_pct so_invoiced
/*L15F*/           so_fob so_fst_id so_inv_nbr so_nbr
/*L15F*/           so_prepaid so_print_pl so_to_inv
/*L15F*/           so_print_so so_pst_id so_pst_pct so_rev so_ship_date
/*L15F*/           so_site so_stat so_tax_date so_tax_pct so_tr1_amt
/*L15F*/           so_trl1_cd so_trl2_amt so_trl2_cd so_trl3_amt so_trl3_cd)
/*L15F*/    where recid(so_mstr) = so_recno no-lock:
/*L15F*/ end. /* FOR FIRST so_mstr */

         find cm_mstr where recid(cm_mstr) = cm_recno no-lock.

         maint = yes.

         do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F263*/    if so_ship_date = ? then so_ship_date = today.
/*F263*/    if so_tax_date = ? then tax_date = so_ship_date.
/*F263*/    else tax_date = so_tax_date.

/*G416* DISPLAY THE PROPER TRAILER FRAME ** BEGIN ADD **/
/*J053***** USE THE DISPLAY INCLUDES *******************
**          if {txnew.i} then
**             display with frame sotot.
**          else if gl_can then
** /*G416** END ADD **/
** /*G416**
**          if gl_can then */
**             display with frame cttrail.
**          else
**             display with frame sotrail.
*J053***** USE THE DISPLAY INCLUDES *******************/

/*J053*/   if {txnew.i} then do:
/*J053*/      {sototdsp.i}
/*J053*/   end.
/*J053*/   else if gl_can then do:
/*J053*/      {cttrldsp.i}
/*J053*/   end.
/*J053*/   else do:
/*J053*/      {sotrldsp.i}
/*J053*/   end.

/*F263*    if so_ship_date = ? then so_ship_date = today. */

/*J053***************** MOVED FRAME DEFINITION TO SOIVMT01.I *************
**            form
**               so_cr_init     colon 15
**               so_inv_nbr     colon 40
**               so_ar_acct
** /*GM77*/ /*V8-*/ colon 63 /*V8+*/ /*V8!colon 61 */
**               so_ar_cc no-label
**               so_cr_card     colon 15
**               so_to_inv      colon 40
**               so_print_so
** /*GM77*/ /*V8-*/ colon 63 /*V8+*/ /*V8!colon 61 */
**               so_stat        colon 15
**               so_invoiced    colon 40
**               so_print_pl
** /*GM77*/ /*V8-*/ colon 63 /*V8+*/ /*V8!colon 61 */
** /*F358        so_prepaid     colon 15 */
** /*F358*/      so_rev         colon 15
** /*F358*/      so_prepaid     colon 40
** /*G035*/      so_fob         colon 15
**           with frame d side-labels width 80.
**J053************** FRAME DEFINITION MOVED TO SOIVMT01.I ****************/

           display so_cr_init so_cr_card so_stat
/*F358*/      so_rev
              so_inv_nbr so_to_inv so_invoiced so_ar_acct so_ar_cc
              so_print_so so_print_pl so_prepaid
/*G035*/      so_fob
           with frame d.

/*G035** begin block. Now done in soivmt.p
 *         /*GET DEFAULT TRAILER CODES*/
 *         if new_order then do:
 *            so_trl1_cd = soc_trl_ntax[1].
 *            so_trl2_cd = soc_trl_ntax[2].
 *            so_trl3_cd = soc_trl_ntax[3].
 *            if so_taxable and (sotax_trl or gl_vat or gl_can)
 *            then do:
 *               if soc_trl_tax[1] <> "" then so_trl1_cd = soc_trl_tax[1].
 *               if soc_trl_tax[2] <> "" then so_trl2_cd = soc_trl_tax[2].
 *               if soc_trl_tax[3] <> "" then so_trl3_cd = soc_trl_tax[3].
 *            end.
 *         end.
 *G035** end block. */

/*F676*/ end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*H009*/ /* Code moved to soivmtc3.p */
/*H009*/ undo_mtc3 = true.
/*H009*/ {gprun.i ""soivmtc3.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H009*/ if undo_mtc3 then return.

/*J2RS*/ l_inv_nbr = so_mstr.so_inv_nbr.

         do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

            display so_cr_init so_cr_card so_prepaid so_inv_nbr
               so_to_inv so_invoiced so_ar_acct so_ar_cc
               so_print_so so_print_pl
/*G035*/       so_fob
            with frame d.

            settrl:
            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


/*L15F*/       find first so_mstr
/*L15F*/          where recid(so_mstr) = so_recno exclusive-lock no-error.

               set so_cr_init so_cr_card
                  so_stat when (so_stat = "")
/*F358            so_prepaid   */
/*F358*/          so_rev
/*G035*/          so_fob
                  so_inv_nbr
                  so_to_inv so_invoiced
/*F358*/          so_prepaid
                  so_ar_acct so_ar_cc
                  so_print_so so_print_pl
               with frame d.

/*G1WZ*/ {gpglver1.i &acc = so_ar_acct
                     &sub = ?
                     &cc  = so_ar_cc
                     &frame = d}

/*J053*/       /* VALIDATE TRAILER AMOUNT */
/*J053*/       if (so_prepaid <> 0) then do:
/*J053*/          {gprun.i ""gpcurval.p"" "(input so_prepaid,
                                            input rndmthd,
                                            output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/          if (retval <> 0) then do:
/*J053*/             next-prompt so_prepaid with frame d.
/*J053*/             undo settrl, retry settrl.
/*J053*/          end.
/*J053*/       end.
               /* ACCOUNT MUST EITHER BE BASE OR EQUAL TO PMT CURRENCY*/
               if so_curr <> base_curr then do:
                  find ac_mstr where
/*F681*/             ac_code = substring(so_ar_acct,1,(8 - global_sub_len))
                     no-lock no-error.
                  if available ac_mstr and
                  ac_curr <> so_curr and ac_curr <> base_curr then do:
                     {mfmsg.i 134 3}
                     /*ACCT CURRENCY MUST MATCH TRANSACTION OR BASE CURR*/
                     next-prompt so_ar_acct with frame d.
                     undo settrl, retry.
                  end.
               end.

               /* CHECK FOR DUPLICATE INVOICE NUMBERS */
               if so_inv_nbr <> "" then do for somstr:
/*G219*/          find first somstr where somstr.so_inv_nbr = so_mstr.so_inv_nbr
                       and somstr.so_nbr <> so_mstr.so_nbr no-lock no-error.
                  find ar_mstr where ar_mstr.ar_nbr = so_mstr.so_inv_nbr
                       no-lock no-error.
/*G1HG***
* /*FQ97*/    if soc_ar = no then find first ih_hist
* /*FQ97*/       where ih_inv_nbr = so_mstr.so_inv_nbr no-lock no-error.
* /*FQ97*     if (available somstr) or (available ar_mstr) */
* /*FQ97*/   if (available somstr) or (available ar_mstr) or (available ih_hist)
*             then do:
*                next-prompt so_mstr.so_inv_nbr with frame d.
* /*H394*        {mfmsg.i 1165 3} */
* /*H394*        undo settrl. */
* /*H394*/       {mfmsg.i 1165 2}
* /*H394*/       hide message.
*             end.
**G1HG**/

/*G1HG*/    find first ih_hist where ih_inv_nbr = so_mstr.so_inv_nbr
/*G1HG*/                         and ih_nbr = so_mstr.so_nbr no-lock no-error.
/*G1HG*/    if available somstr
/*G1HG*/    then do:
/*G1HG*/       find si_mstr where si_mstr.si_site = so_mstr.so_site
/*G1HG*/            no-lock no-error.
/*G1HG*/       find simstr  where simstr.si_site = somstr.so_site
/*G1HG*/            no-lock no-error.
/*G1HG*/    end.

/*G1HG*/    if (available ar_mstr)
/*G1HG*/    then do:
/*G1HG*/       next-prompt so_mstr.so_inv_nbr with frame d.
/*G1HG*/       /* duplicate invoice number */
/*G1HG*/       {mfmsg.i 1165 3}
/*G1HG*/       undo settrl, retry.
/*G1HG*/    end.
/*G1HG*/    else
/*G1HG*/    if (available ih_hist)
/*G1HG*/    then do:
/*G1HG*/       next-prompt so_mstr.so_inv_nbr with frame d.
/*G1HG*/       /* History for Sales Order/Invoice exists */
/*G1HG*/       {mfmsg.i 1045 3}
/*G1HG*/       undo settrl, retry.
/*G1HG*/    end.
/*G1HG*/    else do:
/*G1HG*/       if available somstr then do:

/*J281*/    /* PROCEDURE FOR CONSOLIDATION RULES */
/*J281*/    {gprun.i ""soconso.p"" "(input 1,
                     input somstr.so_nbr ,
                     input so_mstr.so_nbr,
                         output l_consolidate_ok ,
                         output l_msg_text)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J281*/ /* COSOLIDATION RULES NOW MOVED TO soconso.p */

/*J281** BEGIN DELETE **
 * /*G1HG*/       if  (somstr.so_bill     <> so_mstr.so_bill
 * /*G1HG*/       or  somstr.so_cust      <> so_mstr.so_cust
 * /*G1HG*/       or  somstr.so_curr      <> so_mstr.so_curr
 * /*G1HG*/       or  somstr.so_cr_terms  <> so_mstr.so_cr_terms
 * /*G1HG*/       or  somstr.so_trl1_cd   <> so_mstr.so_trl1_cd
 * /*G1HG*/       or  somstr.so_trl2_cd   <> so_mstr.so_trl2_cd
 * /*G1HG*/       or  somstr.so_trl3_cd   <> so_mstr.so_trl3_cd
 * /*G1HG*/       or  somstr.so_slspsn[1] <> so_mstr.so_slspsn[1]
 * /*G1HG*/       or  somstr.so_slspsn[2] <> so_mstr.so_slspsn[2]
 * /*G1HG*/       or  somstr.so_slspsn[3] <> so_mstr.so_slspsn[3]
 * /*G1HG*/       or  somstr.so_slspsn[4] <> so_mstr.so_slspsn[4]
 * /*G1HG*/       or  (available si_mstr and available simstr and
 * /*G1HG*/            simstr.si_entity   <> si_mstr.si_entity))
 * /*G1HG*/ then do:
 *J281** END DELETE ** */

/*J281*/          if not l_consolidate_ok then do:
/*G1HG*/             next-prompt so_mstr.so_inv_nbr with frame d.
/*G1HG*/             /* mismatch with open invoice - can't consolidate */
/*G1HG*/             {mfmsg.i 1046 3}
/*G1HG*/             undo settrl, retry.
/*G1HG*/          end.
/*G1HG*/          else do:
/*G1HG*/             /* Invoice already open.  Consolidation will be done */
/*G1HG*/             {mfmsg.i 1047 2}
/*G1HG*/             hide message.
/*G1HG*/          end.
/*G1HG*/       end.   /* avail somstr */
/*G1HG*/    end.  /* no ih_hist */

         end.

               if so_mstr.so_inv_nbr = "" and so_mstr.so_invoiced = yes then do:
                  next-prompt so_mstr.so_inv_nbr with frame d.
                  {mfmsg.i 13 3} /* Not a valid choice */
                  undo settrl.
               end.
/*J2RS*/       /* DELETE TYPE 16 TRANSACTION IF INVOICE NUMBER IS CHANGED */
/*J2RS*/       if so_mstr.so_inv_nbr <> l_inv_nbr and {txnew.i} then do:
/*J2RS*/          {gprun.i ""txdelete.p"" "(input "16",
                        input l_inv_nbr,
                        input so_mstr.so_nbr )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J2RS*/       end. /* SO_INV_NBR <> L_INV_NBR  AND {TXNEW.I} */

/*H208*/       {txcanid.i &frame="d" &fst_id=so_fst_id &pst_id=so_pst_id}

/*H208* MOVED TO txcanid.i **  /* CANADIAN TAX */
 *             if gl_can then
 *               setd_sub:
 *               do on error undo, retry:
 *                  form
 *                    so_fst_id colon 12 label "GST ID"
 *                    so_pst_id colon 12
 *                  with frame setd_sub attr-space overlay side-labels
 *                    centered row frame-row(d) + 2.
 *
 *                  update so_fst_id so_pst_id with frame setd_sub.
 *
 *                  if not gst_taxed and so_fst_id = "" then do:
 *                     {mfmsg.i 8001 3}
 *                     next-prompt so_fst_id with frame setd_sub.
 *                     undo setd_sub, retry.
 *                  end.
 *                  if not pst_taxed and so_pst_id = "" then do:
 *                     {mfmsg.i 8002 3}
 *                     next-prompt so_pst_id with frame setd_sub.
 *                     undo setd_sub, retry.
 *                  end.
 *               end. /* canadian tax */ ** END MOVED **/

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*settrl*/

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*transaction*/
