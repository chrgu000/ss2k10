/* GUI CONVERTED from sosomtc.p (converter v1.75) Sat May  5 08:31:13 2001 */
/* sosomtc.p - SALES ORDER MAINTENANCE TRAILER SECTION                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 6.0      LAST MODIFIED: 08/08/90   BY: MLB *D055**/
/* REVISION: 6.0      LAST MODIFIED: 08/29/90   BY: pml *D063**/
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: MLB *D148**/
/* REVISION: 6.0      LAST MODIFIED: 11/14/90   BY: MLB *D208**/
/* REVISION: 6.0      LAST MODIFIED: 12/11/90   BY: MLB *D238**/
/* REVISION: 6.0      LAST MODIFIED: 04/09/91   BY: bjb *D625**/
/* REVISION: 6.0      LAST MODIFIED: 04/26/91   BY: MLV *D559**/
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015**/
/* REVISION: 7.0      LAST MODIFIED: 10/14/91   BY: dgh *D892**/
/* REVISION: 7.0      LAST MODIFIED: 11/14/91   BY: pma *F003**/
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: tjs *F273**/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358**/
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: tjs *F421**/
/* REVISION: 7.0      LAST MODIFIED: 05/28/92   By: jcd *F402**/
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F676**/
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458**/
/* REVISION: 7.0      LAST MODIFIED: 08/04/92   BY: tjs *F765**/
/* REVISION: 7.3      LAST MODIFIED: 09/16/92   BY: tjs *G035**/
/* REVISION: 7.3      LAST MODIFIED: 10/06/92   BY: mpp *G013**/
/* REVISION: 7.3      LAST MODIFIED: 02/04/92   BY: bcm *G415**/
/* REVISION: 7.3      LAST MODIFIED: 03/18/93   BY: tjs *G588**/
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692**/
/* REVISION: 7.3      LAST MODIFIED: 03/22/93   BY: tjs *G858**/
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: pcd *H008**/
/* REVISION: 7.4      LAST MODIFIED: 07/01/93   BY: bcm *H002**/
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049**/
/* REVISION: 7.4      LAST MODIFIED: 10/26/93   BY: tjs *H188**/
/* REVISION: 7.4      LAST MODIFIED: 02/16/94   BY: afs *H281**/
/* REVISION: 7.4      LAST MODIFIED: 06/17/94   BY: qzl *H391**/
/* REVISION: 7.4      LAST MODIFIED: 06/20/94   BY: afs *GK32**/
/* REVISION: 7.4      LAST MODIFIED: 08/25/94   BY: dpm *FQ25**/
/* REVISION: 7.4      LAST MODIFIED: 10/21/94   BY: rmh *FQ08**/
/* REVISION: 7.3      LAST MODIFIED: 03/16/95   BY: WUG *G0CW**/
/* REVISION: 8.5      LAST MODIFIED: 03/15/95   BY: DAH *J042**/
/* REVISION: 7.4      LAST MODIFIED: 10/12/95   BY: jym *G0YX**/
/* REVISION: 7.4      LAST MODIFIED: 10/20/95   BY: jym *G0XY**/
/* REVISION: 8.5      LAST MODIFIED: 07/12/95   BY: TAF *J053**/
/* REVISION: 8.5      LAST MODIFIED: 02/27/96   BY: *J04C* Markus Barone */
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: *J0RX* Sue Poland    */
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: *J12Q Andy Wasilczuk */
/* REVISION: 8.5      LAST MODIFIED: 08/06/96   BY: *G1ZR suresh Nayak   */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Elke Van Maele*/
/* REVISION: 8.6      LAST MODIFIED: 05/07/97   BY: *J1P5* Ajit Deodhar  */
/* REVISION: 8.6      LAST MODIFIED: 11/14/97   BY: *H1GN* Seema Varma   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L024* Sami Kureishy */
/* REVISION: 8.6E     LAST MODIFIED: 02/16/99   BY: *J3B4* Madhavi Pradhan*/
/* REVISION: 9.0      LAST MODIFIED: 04/21/01   BY: *M11Z* Jean Miller      */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosomtc_p_1 "** ³å Ïú **"
         /* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/* PASSED PARAMTERS
     this-is-ssm      -   SPECIFIES WHETHER ORDER IS SO OR SSM ORDER
 */

/*J1P5*/ define input parameter this-is-ssm as logical no-undo.

/*G0XY*/ define new shared variable convertmode as character no-undo
                                    initial "MAINT".
/*J053*/ define shared variable rndmthd like rnd_rnd_mthd.
/*J12Q*/ define shared variable cr_terms_changed like mfc_logical no-undo.
/*G0YX*/ define            variable totalorder as decimal no-undo.
/*H188*/ define new shared variable due_date_range like mfc_logical initial no.
/*H188*/ define new shared variable date_range     like sod_due_date.
/*H188*/ define new shared variable date_range1    like sod_due_date.
         define shared variable so_recno as recid.
         define shared variable cm_recno as recid.
         define shared variable new_order like mfc_logical.
         define shared variable sotax_trl like tax_trl.
         define shared variable base_amt like ar_amt.
/*G692** define variable old_rev like so_rev. **/
/*G013*/ define variable valid_acct like mfc_logical.

/*J1P5** MOVED THE SCOPE OF TRAILER FRAMES TO sosomt1.p/fscaimta.p **
 * /*G415*/ define new shared frame d.
 * /*G415*/ define new shared frame sotot.
 *J1P5**/

/*J1P5*/ define shared frame d.
/*J1P5*/ define shared frame sotot.

/*J053*/ /* MOVED THE FOLLOWING VARIABLES TO MFSOTRLA.I */
/*J053 /*H002*/ define new shared variable tax_edit like mfc_logical initial false. */
/*J053* /*H002*/ define new shared variable tax_edit_lbl like mfc_char format "x(28)" */
/*J053*  /*H002*/ initial "       View/Edit Tax Detail:". */
/*G588*/ define variable disc_pct like so_disc_pct.
/*G692*/ define new shared variable undo_mtc2 like mfc_logical.
/*H008*/ define new shared variable undo_mtc3 like mfc_logical.
/*H008*/ define new shared variable undo_trl2 like mfc_logical.

/*L00L*/ {etdcrvar.i "new"}

/*J053* /*H008*/ {mfsotrla.i "NEW"}  /* Define common variables for trailer*/ */
/*L00L* /*J053*/ {mfsotrla.i}  /* Define common variables for trailer */ */
/*L00L*/         {etsotrla.i}
/*J053* /*G415*/ {sototfrm.i} /* Define tralier form for Tax Management */  */

/*J053*/ define shared variable balance_fmt as character.
/*J053*/ define shared variable limit_fmt as character.
/*J053*/ define shared variable prepaid_fmt as character no-undo.
/*H049*/ define     shared variable calc_fr    like mfc_logical.
/*H049*/ define     shared variable disp_fr    like mfc_logical.
/*H049*/ define     shared variable freight_ok like mfc_logical.
/*GK32*/ define new shared variable credit_hold_applied
/*GK32*/                                       like mfc_logical no-undo.
/*G1ZR*/ define new shared variable undo_mainblk like mfc_logical no-undo.

         /* EMT SPECIFIC VARIABLES */
/*M11Z* /*K004*/ define shared variable s-prev-so-stat like so_stat no-undo.*/

/*L024*/ define variable mc-error-number like msg_nbr no-undo.

/*K004*/ {sobtbvar.i}   /* BACK TO BACK SHARED WORKFILES AND VARIABLES */

         find so_mstr where recid(so_mstr) = so_recno.
         find cm_mstr where recid(cm_mstr) = cm_recno no-lock.
         find first soc_ctrl no-lock.
         find first gl_ctrl no-lock.

/*J053*/ {sosomt01.i}  /* Define shared frame d */


         maint = yes.
         do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


           status input.

/*H1GN*/   /* INITIALIZE TRAILER VARIABLES */
/*H1GN*/   assign nontaxable_amt = 0
/*H1GN*/          taxable_amt    = 0
/*H1GN*/          line_total     = 0
/*H1GN*/          disc_amt       = 0
/*H1GN*/          tax_amt        = 0
/*H1GN*/          base_amt       = 0
/*H1GN*/          ord_amt        = 0
/*H1GN*/          line_pst       = 0
/*H1GN*/          total_pst      = 0
/*H1GN*/          amt            = 0
/*H1GN*/          tax            = 0
/*H1GN*/          user_desc      = ""
/*H1GN*/          vtclass        = ""
/*H1GN*/          tax_date       = ?.

/*J053*****USE THE DISPLAY INCLUDES ******************************
**         /*H008* Display Tax info */
**         if {txnew.i} then
**            display with frame sotot.
**         else if gl_can then
**            display with frame cttrail.
**         else
**            display with frame sotrail.
**J053*****USE THE DISPLAY INCLUDES ******************************/
/*J053*/ if {txnew.i} then do:
/*J053*/      {sototdsp.i}
/*J053*/ end.
/*J053*/ else if gl_can then do:
/*J053*/      {cttrldsp.i}
/*J053*/ end.
/*J053*/ else do:
/*J053*/      {sotrldsp.i}
/*J053*/ end.

         /*H008*  End. */

/*J053*//* MOVE SOSOMT01.I UP ABOVE TRANSACTION LOOP */
/*J053* /*G692*/ {sosomt01.i}  /* Define shared frame d */  */
/*G692*/ /* (form statement for frame d removed) */
/*J053*/ so_prepaid:format = prepaid_fmt.

/*FT54* THIS CHANGE BELONGED TO GN67 BUT THIS PROGRAM WAS OVERLOOKED, SO
        INCORPORATED WITH FT54
 * /*H391*/ print_ih = (so_inv_mthd = "b" or so_inv_mthd = "p"
 * /*H391*/ or so_inv_mthd = "").
 * /*H391*/ edi_ih = (so_inv_mthd = "b" or so_inv_mthd = "e").
 *FT54*/

/*FT54*/   print_ih =
/*FT54*/   ( substr(so_inv_mthd,1,1) = "b" or
/*FT54*/   substr(so_inv_mthd,1,1) = "p" or substr(so_inv_mthd,1,1) = "").
/*FT54*/  edi_ih = (substr(so_inv_mthd,1,1) = "b" or
/*FT54*/      substr(so_inv_mthd,1,1) = "e").
/*G0CW*/   edi_ack = substr(so_inv_mthd,3,1) = "e".

/*FQ25*/ if new_order  then so_print_pl = yes.

         display
            so_cr_init so_cr_card so_stat so_shipvia so_bol so_fob
/*F358*/    so_rev
            so_print_so so_print_pl so_partial so_prepaid so_ar_acct so_ar_cc
/*H391*/    print_ih edi_ih
                edi_ack                /*G0CW*/
            with frame d.

/*G035** begin block.  Now done in sosomt.p
 * /*GET DEFAULT TRAILER CODES*/
 * if new_order then do:
 *    so_trl1_cd = soc_trl_ntax[1].
 *    so_trl2_cd = soc_trl_ntax[2].
 *    so_trl3_cd = soc_trl_ntax[3].
 *    if so_taxable and (sotax_trl or gl_vat or gl_can)
 *    then do:
 *       if soc_trl_tax[1] <> "" then so_trl1_cd = soc_trl_tax[1].
 *       if soc_trl_tax[2] <> "" then so_trl2_cd = soc_trl_tax[2].
 *       if soc_trl_tax[3] <> "" then so_trl3_cd = soc_trl_tax[3].
 *    end.
 * end.
 *G035** end block. */

/*G692** Extended first transaction block to include other calculations **
 *G692** that shouldn't be undone if user hits "F4" immediately         **
 * /*F676*/ end.
 *
 * /*F676*/ do transaction:
 **G692*/

/*F273*/ /* new_order = no. */
/*G415*/ if not {txnew.i} then do:
            {gprun.i ""sosotrl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G415*/ end.

/*G858****** now in sosotrl.p's mfsotrl.i ***
/*F273*/*if new_order then do: /* Sales volume discount */
/*G588* *   {sosd.i &ord_date = so_ord_date   */
/*G588* *           &ex_rate  = so_ex_rate    */
/*G588* *           &cust     = so_cust       */
/*G588* *           &disc_pct = "so_disc_pct" */
/*G588* *           &curr     = so_curr}      */
/*G588*/*   {gprun.i ""sosd.p"" "(input so_ord_date,
        *                         input so_ex_rate,
        *                         input so_cust,
        *                         input so_curr,
        *                         input line_total,
        *                         output disc_pct)"}
/*G588*/*   if disc_pct > so_disc_pct then so_disc_pct = disc_pct.
/*G588*/*   disc_amt = round((- line_total * (so_disc_pct / 100)),2).
/*F273*/*   new_order = no.
/*F273*/*end.
 *G858*****/

/*G0YX* THE ROUTINE MFSOTRL.I TAKES SOD_QTY_ORD - SOD_QTY_CHG AND USES THAT
 *      QUANTITY * THE PRICE TO GET THE ORDER TOTAL (THIS WAY YOU SEE THE
 *      DOLLAR AMOUNT FOR THE QUANTITY OPEN ONLY.)  IF THAT CALCULATION IS
 *      NEGATIVE, THEN THE VARIABLE invcrdt = "**C R E D I T**".  THE WORD
 *      CREDIT CAN BE MISLEADING IN THE CASE WHERE A SALES ORDER WAS OVER
 *      SHIPPED.  THIS CODE INSURES THAT THE WORD CREDIT WILL ONLY APEAR IF
 *      THE SALES ORDER WAS ORIGINALLY A CREDIT.                    */
/*G0YX*/  if invcrdt = {&sosomtc_p_1} then do:
/*G0YX*/    totalorder = 0.
/*G0YX*/    for each sod_det where sod_nbr = so_nbr no-lock:
/*G0YX*/      assign totalorder = totalorder + (sod_qty_ord * sod_price).
/*G0YX*/    end. /* for each sod_det */
/*G0YX*/    if totalorder >= 0 then assign invcrdt = "".
/*G0YX*/  end. /* invcrdt = "**C R E D I T**" */

         /*DISPLAY TRAILER*/
/*G415*/ if {txnew.i} then do:
            {sototdsp.i}
         end.
/*G415*/ else if gl_can then do:
            {cttrldsp.i}
         end.
         else do:
            {sotrldsp.i}
         end.

/*J042*/ /* CHECK FOR MINIMUM NET ORDER AMOUNT DUE TO REQUIREMENT OF
            QUALIFYING PRICE LIST.  IF VIOLATION FOUND, DISPLAY WARNING
            MESSAGE.  SINCE USER CAN EXIT WITHOUT COMPLETING TRAILER, IF
            NON TAX MANAGEMENT CUSTOMER THEN PERFORM CHECK NOW.*/

/*J042*/ if not {txnew.i} then do:
/*J042*/    for each pih_hist where pih_doc_type = 1 and
/*J042*/                            pih_nbr      = so_nbr
/*J042*/                      no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/       if pih_min_net <> 0 and pih_min_net > line_total then do:
/*J042*/          {mfmsg03.i 6925 2 pih_list pih_min_net """"}
/*J042*/          /*Price list requires min net order amt, price list:*/
/*J042*/          if not batchrun then
/*J042*/             pause.
/*J042*/       end.
/*J042*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/ end.

/*H049*/ /* DISPLAY FREIGHT WEIGHTS */
/*H049*/ if so_fr_list <> "" then do:
/*H049*/    if calc_fr then do:
/*H049*/       if not freight_ok then do:
/*H049*/          {mfmsg.i 669 2} /* Freight error detected - */
/*FQ08*/          if not batchrun then pause.
/*H049*/       end.
/*H049*/       if disp_fr then do:
/*H049*/          /* Freight Weight = */
/*H049*/          {mfmsg03.i 698 1 so_weight so_weight_um """"}
/*H049*/       end.
/*H049*/    end.
/*H049*/ end.

         /* BACK OUT TRAILER ITEMS FROM TAXABLE/NONTAXABLE VARIABLES */
         {gprun.i ""sotrltx2.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G692*/ /* CHECK CREDIT LIMIT */
/*G692*/ /* If the bill-to customer's outstanding balance is already above   */
/*G692*/ /* his credit limit, then the order will have been put on hold in   */
/*G692*/ /* the header.  We check now because the subtotal of the order may  */
/*G692*/ /* have put the customer over his credit limit and the user might   */
/*G692*/ /* F4 out of the trailer screen, bypassing the check done after     */
/*G692*/ /* the trailer amounts have been entered.  It hardly seems worth    */
/*G692*/ /* mentioning that the customer's balance plus this order might be  */
/*G692*/ /* above his credit limit now, but judicious use of order discounts */
/*G692*/ /* and negative trailer amounts might bring the total back down     */
/*G692*/ /* below the credit limit.  Better safe than sorry, I always say.   */
/*G692*/ /* Note that we don't bother checking if we're not going to put the */
/*G692*/ /* order on hold, since this could just produce a lot of messages   */
/*G692*/ /* that the user is probably ignoring anyway.                       */
/*G692*/ if so_stat = "" and soc_cr_hold then do:
/*G692*/    base_amt = ord_amt.
/*G692*/    if so_curr <> base_curr then
/*J053*/       do:

/*L024*  ** BEGIN DELETE **
**J053*        base_amt = base_amt / so_ex_rate.
**J053*        /* ROUND PER BASE CURRENCY ROUND METHOD */
**J053*        {gprun.i ""gpcurrnd.p"" "(input-output base_amt,
*                 input gl_rnd_mthd)"}
**J053  *G692* base_amt = round(base_amt / so_ex_rate,gl_ex_round).
*L024*   ** END DELETE **/

/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input so_curr,
                    input base_curr,
                    input so_ex_rate,
                    input so_ex_rate2,
                    input base_amt,
                    input true,
                    output base_amt,
                    output mc-error-number)"}.
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end.
/*J053*/    end.

/*J0RX*/ /* NOTE: DO NOT PUT CALL REPAIR ORDERS (FSM-RO) ON HOLD - BECAUSE */
         /*    THESE ORDERS WILL NOT BE SHIPPING ANYTHING, ONLY INVOICING  */
         /*    FOR WORK ALREADY DONE.                                      */

/*J3B4*/ /* NOTE: ALSO DO NOT PUT RMA ORDERS (RMA) ON HOLD - BECAUSE THESE */
/*J3B4*/ /*    ORDERS WILL BE CHECKED FOR CREDIT LIMIT AND PUT ON HOLD IN  */
/*J3B4*/ /*    THE PROGRAM FSRMAMTU.P DEPENDING ON THE SERVICE LEVEL FLAG  */
/*J3B4*/ /*    (SVC_HOLD_CALL)                                             */

/*G692*/    if cm_cr_limit < (cm_balance + base_amt)
/*J0RX*/    and so_fsm_type <> "FSM-RO"
/*J3B4*/    and so_fsm_type <> "RMA"
/*G692*/    then do:
/*GK32*/       /* Some sleezy users actually tried to take advantage of all  */
/*GK32*/       /* the information we were giving them and hit F4 in the      */
/*GK32*/       /* middle of the messages.  Imagine!  Well, we just won't     */
/*GK32*/       /* tell them until it's too late.                             */
/*GK32**       {mfmsg02.i 616 2 "cm_balance + base_amt,""->>>>,>>>,>>9.99""  */
/*GK32**       {mfmsg02.i 617 1 "cm_cr_limit,""->>>>,>>>,>>9.99"" "}         */
/*GK32**       {mfmsg03.i 690 1 """Sales Order""" """" """" }                */
/*GK32**       /* Sales Order placed on credit hold */                       */
/*GK32*/       credit_hold_applied = true.
/*G692*/       so_stat = "HD".
/*G692*/       display so_stat with frame d.
/*G692*/    end.
/*G692*/ end.

/*G692*/ end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*H281** pause 0 before-hide. **/

/*H008*/ /* seta transaction moved to sosomtc3.p */
/*H008*/ undo_mtc3 = true.
/*H008*/ {gprun.i ""sosomtc3.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04C* /*H008*/ if undo_mtc3 then return.  */
/*J04C*/ if not undo_mtc3 then do:
/*G1ZR*/ if undo_mainblk then leave.

/*G692*/    /* Moved update for lower frame (frame d) to subroutine */
/*G692*/    undo_mtc2 = true.

/*G692*/    {gprun.i ""sosomtc2.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G692*/    if undo_mtc2 then undo, retry.

/*J04C*/ end.

/*J1P5*/ /* HIDE THE TRAILER FRAMES ONLY FOR ORDERS OF TYPE "SSM" */
/*J1P5*/ if this-is-ssm then do:
/*J04C*/    hide frame sotot   no-pause.
/*J04C*/    hide frame cttrail no-pause.
/*J04C*/    hide frame sotrail no-pause.
/*J04C*/    hide frame d       no-pause.
/*J1P5*/ end.
