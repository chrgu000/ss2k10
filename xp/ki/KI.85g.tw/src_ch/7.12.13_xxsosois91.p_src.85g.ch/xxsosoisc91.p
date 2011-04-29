/* sosoisc.p - SALES ORDER SHIPMENT TRAILER                             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 08/22/90   BY: MLB *D055**/
/* REVISION: 6.0      LAST MODIFIED: 12/21/90   BY: MLB *D238**/
/* REVISION: 6.0      LAST MODIFIED: 04/11/91   BY: MLV *D517**/
/* REVISION: 6.0      LAST MODIFIED: 05/31/91   BY: MLV *D667**/
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 6.0      LAST MODIFIED: 12/26/91   BY: MLV *D850**/
/* REVISION: 7.0      LAST MODIFIED: 03/05/92   BY: tjs *F247**/
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: tjs *F405**/
/* REVISION: 7.0      LAST MODIFIED: 04/23/92   BY: sas *F379**/
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458**/
/* REVISION: 7.0      LAST MODIFIED: 07/16/92   BY: tjs *F805**/
/* REVISION: 7.3      LAST MODIFIED: 09/25/92   BY: tjs *G087**/
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: afs *G219**/
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247**/
/* REVISION: 7.3      LAST MODIFIED: 01/12/93   BY: tjs *G536**/
/* REVISION: 7.3      LAST MODIFIED: 02/10/93   BY: bcm *G424**/
/* REVISION: 7.3      LAST MODIFIED: 03/12/93   BY: tjs *G451**/
/* REVISION: 7.4      LAST MODIFIED: 07/03/93   BY: bcm *H002**/
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009**/
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049**/
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: bcm *H127**/
/* REVISION: 7.4      LAST MODIFIED: 10/14/93   BY: dpm *H067**/
/* REVISION: 7.4      LAST MODIFIED: 03/18/94   BY: dpm *H297**/
/* REVISION: 7.4      LAST MODIFIED: 10/21/94   BY: rmh *FQ08**/
/* REVISION: 7.4      LAST MODIFIED: 11/06/94   BY: ljm *GO15**/
/* REVISION: 7.4      LAST MODIFIED: 05/31/95   BY: jym *G0ND**/
/* REVISION: 8.5      LAST MODIFIED: 07/18/95   BY: taf *J053**/
/* REVISION: 8.5      LAST MODIFIED: 06/01/96   BY: tzp *G1WX**/
/* REVISION: 8.5      LAST MODIFIED: 09/26/97   BY: *J21S* Niranjan Ranka */
/* REVISION: 8.5      LAST MODIFIED: 03/17/98   BY: *H1JB* Seema Varma    */


/* SS - 090707.1 By: Roger Xiao */


/*G0ND*/  {mfdeclre.i}

/*H1JB*/ /*OUTPUT PARAMETER */
/*H1JB*/ define output parameter l_recalc like mfc_logical no-undo.

/*J053*/ define shared variable rndmthd like rnd_rnd_mthd.
/*G247** define shared variable mfguser as character. **/
define shared variable so_mstr_recid as recid.
/*G451*  define shared variable undo-all like mfc_logical.*/
/*G451*/ define shared variable undo-all like mfc_logical no-undo.
define shared variable eff_date like glt_effdate.
define new shared variable so_recno as recid.
define variable   shiplbl  as character   format "x(13)".   /*F379*/
/*H127*/ define buffer somstr for so_mstr.
/*G424*/ define new shared frame f.
/*G424*/ define new shared frame sotot.
/*J053*  VARIABLES BELOW MOVED TO MFSOTRLA.I */
/*J053* /*H002*/ define new shared variable tax_edit like mfc_logical initial false. */
/*J053* /*H002*/ define new shared variable tax_edit_lbl like mfc_char format "x(28)" */
/*J053* /*H002*/ initial "       View/Edit Tax Detail:". */
/*G424*/ define new shared variable undo_trl2 like mfc_logical.
/*H127*/ define new shared variable undo_isc1 like mfc_logical.
/*G0ND*/ define variable    w-so_shipvia   like so_mstr.so_shipvia no-undo.
/*G0ND*/ define variable    w-so_bol       like so_mstr.so_bol no-undo.
/*G0ND*/ define variable    w-so_rmks      like so_mstr.so_rmks no-undo.
/*J053*/ define variable tmp_amt as decimal.

{sosois1.i}             /*F379*/
/*J053   {mfsotrla.i "NEW"}      /*H009*/ */
/*J053*/ {mfsotrla.i }
/*J053* /*G424*/    {sototfrm.i} /* Define trailer form for Tax Management */ */

/*H049*/ define shared variable calc_fr    like mfc_logical.
/*H049*/ define shared variable disp_fr    like mfc_logical.
/*H049*/ define shared variable freight_ok like mfc_logical.
/*H067*/ define        variable ship_amt   like ar_amt.
/*G1WX*/ define new shared variable ship like mfc_logical no-undo.

/*H1JB*/ define variable l_tax_edited like mfc_logical no-undo.

/* DISPLAY TITLE */
/*F405* {mfdtitle.i "f+ "} */ /*G536*/
/*G0ND*   /*F247*/    {mfdeclre.i} */

find first gl_ctrl no-lock.
/*H127*/ if gl_vat then find first vtc_ctrl no-lock.
maint = yes.

      undo-all = yes.

      find so_mstr where recid(so_mstr) = so_mstr_recid.
      so_recno = recid(so_mstr).

/*G0ND*/ if can-find(mfc_ctrl where mfc_module = "SO" and
/*G0ND*/   mfc_seq = 170) then do:
/*G0ND*/   assign
/*G0ND*/     w-so_shipvia   = so_mstr.so_shipvia
/*G0ND*/     w-so_bol       = so_mstr.so_bol
/*G0ND*/     w-so_rmks      = so_mstr.so_rmks.
/*G0ND*/ end. /* user turned on multiple bol print */

/*G424*/ if {txnew.i} then
/*G424*/  view frame sotot.
/*G424*/ else
      if gl_can then view frame cttrail.
        else view frame sotrail.

/*    view frame f.      *F379*/

      form
     so_shipvia     colon 15
     so_inv_nbr     colon 55 skip
/*J21S** /*GO15*/ shiplbl      /*V8-*/ colon 3 /*V8+*/ /*V8! at 4 */ no-label */
/*J21S** /*F379*/ */
/*J21S** /*GO15*/ so_ship_date /*V8-*/ colon 17 /*V8+*//*V8! at 17*/ no-label */
/*J21S** /*F379*/ */
/*J21S*/ so_ship_date colon 15
     so_to_inv      colon 55 skip
     so_bol         colon 15
     so_invoiced    colon 55
     so_rmks        colon 15
      with frame f side-labels width 80.

/*J21S** BEGIN DELETE **
 *     if  sorec  = fsrmarec  then                  /*F379*/
 *     shiplbl = "Receive Date:".               /*F379*/
 *     else                                         /*F379*/
 *     shiplbl = "   Ship Date:".               /*F379*/
 *
 *     display shiplbl                              /*F379*/
 *    with frame f.                             /*F379*/
 *J21S** END DELETE ** */

/*J21S*/ if sorec = fsrmarec then
/*J21S*/    so_ship_date:label = "收料日期".

         view frame f.     /*F379*/

/*G1WX*/ find first sod_det no-lock where sod_nbr = so_nbr
/*G1WX*/                              and sod_qty_chg <> 0 no-error.
/*G1WX*/ if available sod_det then ship = yes.

/*G1WX*      display so_shipvia eff_date @ so_ship_date so_bol so_rmks */
/*G1WX*/ display so_shipvia eff_date when (ship) @ so_ship_date so_bol so_rmks
/*G1WX*/ so_ship_date when (not ship)
     so_inv_nbr so_to_inv so_invoiced
     with frame f.

/*G424*/ if not {txnew.i} then do:

/*H127*/    undo_isc1 = true.
/*H127*/    {gprun.i ""sosoisc1.p""}
/*H297*     if undo_isc1 then undo, retry. */
/*H297*/    if undo_isc1 then undo, leave.

/*H127** MOVED TO SOSOISC1.p **
 *          {gprun.i ""soistrl.p""}
 *
 *          /*DISPLAY TRAILER*/
 *          if gl_can then do:
 *             {cttrldsp.i}
 *          end.
 *          else do:
 *             {sotrldsp.i}
 *          end.
 *
 * /*H049*/ /* DISPLAY FREIGHT WEIGHTS */
 * /*H049*/ if calc_fr then do:
 * /*H049*/    if not freight_ok then do:
 * /*H049*/       {mfmsg.i 669 2} /* Freight error detected - */
 * /*H049*/       if not batchrun then pause.
 * /*H049*/    end.
 * /*H049*/    if disp_fr then do:
 * /*H049*/       /* Freight Weight = */
 * /*H049*/       {mfmsg03.i 698 1 so_weight so_weight_um """"}
 * /*H049*/    end.
 * /*H049*/ end.
 *
 *        /* DEAL WITH TRAILER CODES */
 *        do on error undo, retry:
 *
 *        /*BACK OUT TRAILER ITEMS FROM TAXABLE/NONTAXABLE VARIABLES*/
 * /*F458*/ /* USE THE TAX DATE IF EXISTS, ELSE SHIP DATE TO GET TAX RATES */
 * /*F458*/    if so_tax_date = ? then tax_date = so_ship_date.
 * /*F458*/    else tax_date = so_tax_date.
 * /*F458*  {gptrltx2.i &code=so_trl1_cd &amt="- so_trl1_amt" &charge=1    *
 *  *        &date=so_ord_date &taxpct="so_mstr.so_tax_pct"}               *
 *  *       {gptrltx2.i &code=so_trl2_cd &amt="- so_trl2_amt" &charge=2    *
 *  *        &date=so_ord_date &taxpct="so_mstr.so_tax_pct"}               *
 *  *       {gptrltx2.i &code=so_trl3_cd &amt="- so_trl3_amt" &charge=3    *
 *  *F458*      &date=so_ord_date &taxpct="so_mstr.so_tax_pct"}               */
 *  /*F458*/    {gptrltx2.i &code=so_trl1_cd &amt="- so_trl1_amt" &charge=1
 *              &date=tax_date    &taxpct="so_mstr.so_tax_pct"}
 *  /*F458*/    {gptrltx2.i &code=so_trl2_cd &amt="- so_trl2_amt" &charge=2
 *              &date=tax_date    &taxpct="so_mstr.so_tax_pct"}
 *  /*F458*/    {gptrltx2.i &code=so_trl3_cd &amt="- so_trl3_amt" &charge=3
 *             &date=tax_date    &taxpct="so_mstr.so_tax_pct"}
 *
 *           if gl_can then
 *            set so_trl1_amt so_trl2_amt so_trl3_amt with frame cttrail.
 *           else
 *            set so_trl1_amt so_trl2_amt so_trl3_amt with frame sotrail.
 *
 *           /*DON'T ALLOW TRAILER AMOUNTS ON UNDEFINED TRAILER CODES*/
 *           {gptrlvl2.i &code=so_trl1_cd &amt=so_trl1_amt}
 *           {gptrlvl2.i &code=so_trl2_cd &amt=so_trl2_amt}
 *           {gptrlvl2.i &code=so_trl3_cd &amt=so_trl3_amt}
 *
 * /*D850 BACK OUT DISC% FROM TAXES*/
 * /*D850*/    if gl_vat or gl_can then do i = 1 to 3:
 * /*D850*/       tax[i] = tax[i] / (1 - (so_mstr.so_disc_pct / 100)).
 * /*D850*/       amt[i] = amt[i] / (1 - (so_mstr.so_disc_pct / 100)).
 * /*D850*/    end.

 *             {mfsotot.i}

 *             /*DISPLAY TRAILER*/
 *           if gl_can then do:
 *              {cttrldsp.i}
 *           end.
 *           else do:
 *              {sotrldsp.i}
 *           end.
 *
 *           so_to_inv = yes.
 *           so_invoiced = no.
 *           display so_shipvia eff_date @ so_ship_date so_bol so_rmks
 *            so_inv_nbr so_to_inv so_invoiced
 *           with frame f.
 *        end. *H127** END MOVE **/

/*G424*/ end. /* IF NOT {txnew.i} */
/*G424*/ else do: /* TAX MANAGEMENT LOGIC */
/*G424*/    {sototdsp.i}

/*H049*/    /* DISPLAY FREIGHT WEIGHTS */
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

/*G424*/    undo_trl2 = true.
/*G424*/    {gprun.i ""soistrl2.p""}
/*G424*/    if undo_trl2 then return.   /* UNDO ALL */
/*G424*/    {sototdsp.i}

/*H067*/    /* CHECK FOR MINIMUM SHIP AMOUNT */
/*H067*/    find mfc_ctrl where mfc_field = "soc_min_shpamt"no-lock no-error.
/*H067*/    if available mfc_ctrl then do:
/*H067*/       ship_amt = mfc_decimal.
/*H067*/       if so_curr <> base_curr then ship_amt = ship_amt * so_ex_rate.
/*H067*/       if ord_amt gt 0 and  ord_amt lt ship_amt then do:
/*H067*/                 {mfmsg03.i 6211 2 ord_amt ship_amt   """"}
/*H067*/          /* "Ord amount is lt Minmum Shipment  Amount". */
/*H067*/       end.
/*H067*/    end.

/*G424*/    so_to_inv = yes.
/*G424*/    so_invoiced = no.
/*G1WX*   /*G424*/  display so_shipvia eff_date @ so_ship_date so_bol so_rmks */
/*G1WX*/   display so_shipvia eff_date when (ship) @ so_ship_date so_bol so_rmks
/*G1WX*/    so_ship_date when (not ship)
/*G424*/    so_inv_nbr so_to_inv so_invoiced
/*G424*/    with frame f.
/*G424*/ end.

/*H127** MOVED TO sosoisc1.p ****
 *    settrl:
 *    do on error undo, retry:
 *       set so_shipvia so_ship_date so_bol so_rmks
 *        so_inv_nbr so_to_inv so_invoiced
 *       with frame f.
 *       if so_inv_nbr <> "" then do for somstr:
 *          /* CHECK FOR DUPLICATE INVOICE NUMBERS */
 * /*G219*/    find  first
 * /*G219*/         somstr where somstr.so_inv_nbr = so_mstr.so_inv_nbr
 *                        and somstr.so_nbr <> so_mstr.so_nbr
 *                      no-lock no-error.
 *
 *          find ar_mstr where ar_mstr.ar_nbr = so_mstr.so_inv_nbr
 *           no-lock no-error.
 *
 *          if (available somstr) or (available ar_mstr) then do:
 *             next-prompt so_mstr.so_inv_nbr with frame f.
 *             {mfmsg.i 1165 3} /* Duplicate invoice number */
 *             undo settrl, retry.
 *          end.
 *       end.
 *
 *       if so_mstr.so_inv_nbr = "" and so_mstr.so_invoiced = yes then do:
 *          next-prompt so_mstr.so_inv_nbr with frame f.
 *          {mfmsg.i 40 3} /* Blank not allowed */
 *          undo settrl, retry.
 *       end.
 *
 *       /* SET PICK LIST REQUIRED TO YES */
 * /*G087*  so_print_pl = yes. */
 *        undo-all = no.  **/

/*H127*/    undo_isc1 = true.
/* SS - 090707.1 - B 
/*H127*/    {gprun.i ""sosoisc2.p""}
   SS - 090707.1 - E */
/* SS - 090707.1 - B */
        {gprun.i ""xxsosoisc291.p""}
/* SS - 090707.1 - E */
/*H127*/    if undo_isc1 then undo, retry.

/*H1JB*/    l_recalc = yes.
/*H1JB*/    if {txnew.i} and so_fsm_type = "" then do:

/*H1JB*/       /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */
/*H1JB*/       {gprun.i ""txedtchk.p"" "(input  '11',
                                         input  so_nbr,
                                         input  so_quote,
                                         input  0 ,
                                         output l_tax_edited)" }

/*H1JB*/       if l_tax_edited then do:
/*H1JB*/           /* EDITED PREVIOUS TAX VALUES TYPE #; RECALCULATE? */
/*H1JB*/           {mfmsg07g.i 2579 2 "11" """" """" l_recalc}
/*H1JB*/       end. /* IF L_TAX_EDITED */
/*H1JB*/    end. /* IF TXNEW.I AND SO_FSM_TYPE  = ""  */

/*G0ND*   IF THE USER HAS TURNED ON THE FUNCTIONALITY TO PRINT MULTIPLE   */
/*G0ND*   BILL OF LADING INFORMATION ON AN INVOICE, THEN STORE THE BILL   */
/*G0ND*   OF LADING INFORMATION HERE IN A qad_wkfl RECORD.                */
/*G0ND*   THIS FUNCTIONALITY WAS SPECIFICALLY SET UP FOR G0ND AND IS      */
/*G0ND*   CUSTOMER ENHANCEMENT WHICH RESIDES IN THE STANDARD PRODUCT.     */

/*G0ND*/  if can-find(mfc_ctrl where mfc_module = "SO" and
/*G0ND*/             mfc_seq = 170) then do:
/*G0ND*/    find qad_wkfl where qad_key1 = so_nbr and
/*G0ND*/      qad_key2 = so_bol + "utsoship" exclusive-lock no-error.
/*G0ND*/      if not available qad_wkfl then do:
/*G0ND*/        create qad_wkfl.
/*G0ND*/        assign qad_key1 = so_nbr
/*G0ND*/               qad_key2 = so_bol + "utsoship".
/*G0ND*/      end. /* create a new qad_wkfl record */
/*G0ND*/      find first sr_wkfl no-lock where
/*G0ND*/        sr_userid = mfguser no-error.
/*G0ND*/      assign qad_char[1] = if available sr_wkfl then sr_site else
/*G0ND*/                           so_site
/*G0ND*/             qad_char[2] = so_shipvia
/*G0ND*/             qad_char[3] = so_rmks
/*G0ND*/             so_shipvia  = w-so_shipvia
/*G0ND*/             so_bol       = w-so_bol
/*G0ND*/             so_rmks      = w-so_rmks.
/*G0ND*/  end. /* track all bill of lading information */

/*G424*/ if {txnew.i} then hide frame sotot.
/*G424*/ else
/*F805*/ if gl_can then hide frame cttrail.
/*F805*/           else hide frame sotrail.
/*F805*/ hide frame f.
/*H127**      end. */
