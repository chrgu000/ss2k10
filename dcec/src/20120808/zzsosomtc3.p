/* GUI CONVERTED from sosomtc3.p (converter v1.69) Mon Aug 12 14:35:31 1996 */
/* sosomtc3.p - SALES ORDER MAINTENANCE TRAILER UPDATES TO TAX                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/* REVISION: 7.4      LAST MODIFIED: 09/22/93   BY: pcd *H008**/
/* REVISION: 7.4      LAST MODIFIED: 07/01/93   BY: bcm *H002**/
/* REVISION: 7.4      LAST MODIFIED: 09/29/93   BY: tjs *H082**/
/* REVISION: 7.4      LAST MODIFIED: 10/14/93   BY: dpm *H067**/
/* REVISION: 7.4      LAST MODIFIED: 06/20/94   BY: afs *GK32**/
/* REVISION: 7.4      LAST MODIFIED: 11/29/94   BY: jxz *GO63**/
/* REVISION: 8.5      LAST MODIFIED: 03/15/95   BY: DAH *J042**/
/* REVISION: 7.4      LAST MODIFIED: 06/23/95   BY: kjm *G0ML**/
/* REVISION: 7.4      LAST MODIFIED: 10/02/95   BY: jym *G0YX**/
/* REVISION: 7.4      LAST MODIFIED: 10/20/95   BY: jym *G0XY**/
/* REVISION: 8.5      LAST MODIFIED: 07/12/95   BY: taf *J053**/
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: *J0RX* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: *J12Q* Andy Wasilczuk     */
/* REVISION: 8.5      LAST MODIFIED: 08/05/96   BY: *J13Q* Jean Miller        */
/* REVISION: 8.5      LAST MODIFIED: 08/06/96   BY: *G1ZR* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 11/17/03   BY: *LB01* Long Bo         */

         {mfdeclre.i}

/*G0XY*/ define new shared variable convertmode as character no-undo
                                initial "MAINT".
/*J053*/ define shared variable rndmthd like rnd_rnd_mthd.
/*J12Q*/ define shared variable cr_terms_changed like mfc_logical no-undo.
/*G0YX*/ define            variable totalorder as decimal no-undo.
/*H008*/ define shared variable so_recno as recid.
/*H008*/ define shared variable cm_recno as recid.
/*H008*/ define shared variable base_amt like ar_amt.
/*H008*/ define shared frame d.
/*H008*/ define shared frame sotot.
/*J053 /*H002*/ define shared variable tax_edit      like mfc_logical. */
/*J053 /*H002*/ define shared variable tax_edit_lbl  like mfc_char format "x(28)".*/
/*H008*/ define shared variable undo_trl2     like mfc_logical.
/*H008*/ define shared variable undo_mtc3     like mfc_logical.
/*H082*/ define shared variable display_trail like mfc_logical.
/*H067*/ define        variable ship_amt      like ar_amt.
/*GK32*/ define shared variable credit_hold_applied
/*GK32*/                                      like mfc_logical no-undo.
/*J053*/ define shared variable balance_fmt as character.
/*J053*/ define shared variable limit_fmt as character.
/*J053*/ define variable tmp_amt as decimal no-undo.
/*J053*/ define variable retval as integer no-undo.
/*LB01*/ define variable other_so_amt like cm_cr_limit.
/*G1ZR*/ define new shared variable sotax_update like mfc_logical  no-undo.
/*G1ZR*/ define shared variable undo_mainblk like mfc_logical no-undo.
/*LB01*/ define shared variable sotrcust    like so_cust.
/*LB01*/ define shared variable sotrnbr     like so_nbr.

/*H008*/ {mfsotrla.i} /* Define common variable for sales order trailer */
/*GO63 /*H008*/ {sototfrm.i} /* Define txnew frame sotot (middle frame) */ */
/*H008*/ {sosomt01.i} /* Define trailer frame d     (lower frame) */

/*H008*/ find so_mstr where recid(so_mstr) = so_recno.
/*H008*/ find cm_mstr where recid(cm_mstr) = cm_recno no-lock.
/*H008*/ find first soc_ctrl no-lock.
/*H008*/ find first gl_ctrl no-lock.

/*H008*/ maint = yes.

/*GK32*/ /* Warn user now if order had been put on credit hold (now */
/*GK32*/ /* that it's too late for the little sneaks to escape).    */
/*GK32*/ if credit_hold_applied then do:
/*J053* /*GK32*/ {mfmsg02.i 616 2 "cm_balance + base_amt,""->>>>,>>>,>>9.99"" "}*/
/*J053*/    {mfmsg02.i 616 2 "cm_balance + base_amt,"balance_fmt" "}
/*J053* /*GK32*/ {mfmsg02.i 617 1 "cm_cr_limit,""->>>>,>>>,>>9.99"" "}   */
/*J053*/    {mfmsg02.i 617 1 "cm_cr_limit,"limit_fmt" "}
/*GK32*/    {mfmsg03.i 690 1 """客户订单""" """" """" }
/*GK32*/    /* Sales Order placed on credit hold */
/*GK32*/    credit_hold_applied = false.
/*GK32*/ end.
/*J12Q*/ /*ADDED BLOCK TO WARN USER IF CREDIT TERMS WAS CHANGED DURING */
/*J12Q*/ /*PRICING AND THE TERMS INTEREST WAS NOT USED TO RECALCULATE  */
/*J12Q*/ /*PRICES. */
         if cr_terms_changed then do:
            find ct_mstr where ct_code = so_cr_terms no-lock no-error.
            if available ct_mstr and ct_terms_int <> 0 then do:
               {mfmsg.i 6222 2}
               {mfmsg03.i 6223 2 ct_terms_int """" """"}
            end.
         end.
/*J12Q*/ /*END OF J12Q CODE*/

/*G1ZR*/ mainblk:
/*G692*/ do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

   seta:
   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      if gl_vat then
/*J053*/ do:
/*J053*           update */
/*G1ZR*/      sotax_update = no.
/*G1ZR*/      undo_mainblk = yes.
/*G1ZR*/    {gprun.i ""sosomtc4.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1ZR*/     if undo_mainblk then  leave mainblk.
/*G1ZR** FOLLOWING SECTION INCLUDED IN sosomtc4.p
* /*J053*/   set
*             so_disc_pct so_trl1_cd so_trl1_amt so_trl2_cd so_trl2_amt
*             so_trl3_cd so_trl3_amt
*            with frame sotrail.
*G1ZR*/

/*J053*/   /* VALIDATE TRAILER 1 AMOUNT */
/*J053*/   if (so_trl1_amt <> 0) then do:
/*J053*/      {gprun.i ""gpcurval.p"" "(input so_trl1_amt,
                                        input rndmthd,
                                        output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/      if retval <> 0 then do:
/*J053*/         next-prompt so_trl1_amt with frame sotrail.
/*J053*/         undo seta, retry seta.
/*J053*/      end.
/*J053*/   end.
/*J053*/   /* VALIDATE TRAILER 2 AMOUNT */
/*J053*/   if (so_trl2_amt <> 0) then do:
/*J053*/      {gprun.i ""gpcurval.p"" "(input so_trl2_amt,
                                        input rndmthd,
                                        output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/      if retval <> 0 then do:
/*J053*/         next-prompt so_trl2_amt with frame sotrail.
/*J053*/         undo seta, retry seta.
/*J053*/      end.
/*J053*/   end.
/*J053*/   /* VALIDATE TRAILER 3 AMOUNT */
/*J053*/   if (so_trl3_amt <> 0) then do:
/*J053*/      {gprun.i ""gpcurval.p"" "(input so_trl3_amt,
                                        input rndmthd,
                                        output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/      if retval <> 0 then do:
/*J053*/         next-prompt so_trl3_amt with frame sotrail.
/*J053*/         undo seta, retry seta.
/*J053*/      end.
/*J053*/   end.
/*J053*/ end.
         else if gl_can then
/*J053*/ do:
/*J053*            update */
/*J053*/    set
             so_disc_pct so_trl1_cd so_trl1_amt so_trl2_cd so_trl2_amt
             so_trl3_cd so_trl3_amt so_pst_pct
            with frame cttrail.
/*J053*/    /* VALIDATE TRAILER 1 AMOUNT */
/*J053*/    if (so_trl1_amt <> 0) then do:
/*J053*/       {gprun.i ""gpcurval.p"" "(input so_trl1_amt,
                                         input rndmthd,
                                         output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/       if retval <> 0 then do:
/*J053*/          next-prompt so_trl1_amt with frame cttrail.
/*J053*/          undo seta, retry seta.
/*J053*/       end.
/*J053*/    end.
/*J053*/    /* VALIDATE TRAILER 2 AMOUNT */
/*J053*/    if (so_trl2_amt <> 0) then do:
/*J053*/       {gprun.i ""gpcurval.p"" "(input so_trl2_amt,
                                         input rndmthd,
                                         output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/       if retval <> 0 then do:
/*J053*/          next-prompt so_trl2_amt with frame cttrail.
/*J053*/          undo seta, retry seta.
/*J053*/       end.
/*J053*/    end.
/*J053*/    /* VALIDATE TRAILER 3 AMOUNT */
/*J053*/    if (so_trl3_amt <> 0) then do:
/*J053*/       {gprun.i ""gpcurval.p"" "(input so_trl3_amt,
                                         input rndmthd,
                                         output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/       if retval <> 0 then do:
/*J053*/          next-prompt so_trl3_amt with frame cttrail.
/*J053*/          undo seta, retry seta.
/*J053*/       end.
/*J053*/    end.
/*J053*/ end.
/*G415*/ else if not {txnew.i} then
/*J053*/ do:
/*G1ZR*/       sotax_update = yes.
/*G1ZR*/       undo_mainblk = yes.
/*G1ZR*/     {gprun.i ""sosomtc4.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1ZR*/            if undo_mainblk then leave mainblk.
/*J053*            update */
/*G1ZR FOLLOWING SECTION INCLUDED IN sosomtc4.p
* /*J053*/    set
*              so_disc_pct so_trl1_cd so_trl1_amt so_trl2_cd so_trl2_amt
*              so_trl3_cd so_trl3_amt so_tax_pct
*             with frame sotrail.
*G1ZR*/

/*J053*/    /* VALIDATE TRAILER 1 AMOUNT */
/*J053*/    if (so_trl1_amt <> 0) then do:
/*J053*/       {gprun.i ""gpcurval.p"" "(input so_trl1_amt,
                                         input rndmthd,
                                         output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/       if retval <> 0 then do:
/*J053*/          next-prompt so_trl1_amt with frame sotrail.
/*J053*/          undo seta, retry seta.
/*J053*/       end.
/*J053*/    end.
/*J053*/    /* VALIDATE TRAILER 2 AMOUNT */
/*J053*/    if (so_trl2_amt <> 0) then do:
/*J053*/       {gprun.i ""gpcurval.p"" "(input so_trl2_amt,
                                         input rndmthd,
                                         output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/       if retval <> 0 then do:
/*J053*/          next-prompt so_trl2_amt with frame sotrail.
/*J053*/          undo seta, retry seta.
/*J053*/       end.
/*J053*/    end.
/*J053*/    /* VALIDATE TRAILER 3 AMOUNT */
/*J053*/    if (so_trl3_amt <> 0) then do:
/*J053*/       {gprun.i ""gpcurval.p"" "(input so_trl3_amt,
                                         input rndmthd,
                                         output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/       if retval <> 0 then do:
/*J053*/          next-prompt so_trl3_amt with frame sotrail.
/*J053*/          undo seta, retry seta.
/*J053*/       end.
/*J053*/    end.
/*J053*/ end.

/*G415*/ if not {txnew.i} then do:
      /*VALIDATE TRAILER VAT CLASSES AND FILL VAT 1-3 (IF gl_VAT)*/
/*F458* Check for tax rate using tax effective date below*/
/*F765* {gptrltx.i &code=so_trl1_cd &amt=so_trl1_amt
      *  &date="(if so_tax_date <> ? then so_tax_date else so_due_date)"
      *  &taxpct="so_tax_pct"}
      * {gptrltx.i &code=so_trl2_cd &amt=so_trl2_amt
      *  &date="(if so_tax_date <> ? then so_tax_date else so_due_date)"
      *  &taxpct="so_tax_pct"}
      * {gptrltx.i &code=so_trl3_cd &amt=so_trl3_amt
      *  &date="(if so_tax_date <> ? then so_tax_date else so_due_date)"
      *  &taxpct="so_tax_pct"} */
/*F765*/ if so_tax_date <> ? then tax_date = so_tax_date.
/*F765*/ else if so_due_date <> ? then tax_date = so_due_date.
/*F765*/ else tax_date = so_ord_date.
/*F765*  Changed gptrltx.i below to use tax_date */
            {gptrltx.i &code=so_trl1_cd &amt=so_trl1_amt
             &date=tax_date &taxpct="so_tax_pct"}
            {gptrltx.i &code=so_trl2_cd &amt=so_trl2_amt
             &date=tax_date &taxpct="so_tax_pct"}
            {gptrltx.i &code=so_trl3_cd &amt=so_trl3_amt
             &date=tax_date &taxpct="so_tax_pct"}
/*G415*/ end. /* not txnew.i */
   end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*J053* /*GO63*/ {sototfrm.i} /* Define txnew frame sotot (middle frame) */  */
/*G415*/ if {txnew.i} then do:
/*H008*/   undo_trl2 = true.
/*J13Q*/ /* /*G415*/   {gprun.i ""sosotrl2.p""} */
/*J13Q*/ {gprun.i ""sosotrle.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H008*/   if undo_trl2 then return.
/*G415*/ end.
/*G415*/ else do:
   /*NEED TO ADD TAXABLE TRAILER ITEMS TO TAXABLE AMT.*/
/*G0ML**G415* {mfsotot.i} */
/*G0ML*/ {gprun.i ""sosotrl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G415*/ end.

/*G0YX* THE ROUTINE MFSOTRL.I TAKES SOD_QTY_ORD - SOD_QTY_CHG AND USES THAT
 *      QUANTITY * THE PRICE TO GET THE ORDER TOTAL (THIS WAY YOU SEE THE
 *      DOLLAR AMOUNT FOR THE QUANTITY OPEN ONLY.)  IF THAT CALCULATION IS
 *      NEGATIVE, THEN THE VARIABLE invcrdt = "**C R E D I T**".  THE WORD
 *      CREDIT CAN BE MISLEADING IN THE CASE WHERE A SALES ORDER WAS OVER
 *      SHIPPED.  THIS CODE INSURES THAT THE WORD CREDIT WILL ONLY APEAR IF
 *      THE SALES ORDER WAS ORIGINALLY A CREDIT.                    */
/*G0YX*/  if invcrdt = "** 冲 销 **" then do:
/*G0YX*/    totalorder = 0.
/*G0YX*/    for each sod_det where sod_nbr = so_nbr no-lock:
/*G0YX*/      assign totalorder = totalorder + (sod_qty_ord * sod_price).
/*G0YX*/    end. /* for each sod_det */
/*G0YX*/    if totalorder >= 0 then assign invcrdt = "".
/*G0YX*/  end. /* invcrdt = "**C R E D I T**" */

   /*DISPLAY TRAILER*/
/*G415** BEGIN **/
   if {txnew.i} then do:
      {sototdsp.i}
   end.
/*G415** END **/
/*G415** if gl_can then do: **/
/*G415*/ else if gl_can then do:
      {cttrldsp.i}
   end.
   else do:
      {sotrldsp.i}
   end.

/*J042*/ /*CHECK FOR MINIMUM NET ORDER AMOUNT DUE TO REQUIREMENT OF
           QUALIFYING PRICE LIST.  IF VIOLATION FOUND, DISPLAY WARNING
           MESSAGE*/

/*J042*/ if {txnew.i} then do:
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

/*H067*/ /* CHECK FOR MINIMUM SHIP AMOUNT */
/*H067*/ find mfc_ctrl where mfc_field = "soc_min_shpamt"  no-lock no-error.
/*H067*/ if available mfc_ctrl then do:
/*H067*/    ship_amt = mfc_decimal.
/*H067*/    if so_curr <> base_curr then ship_amt = ship_amt * so_ex_rate .
/*H067*/   if ord_amt > 0 and  ord_amt < ship_amt then do:
/*H067*/                 {mfmsg03.i 6211 2 ord_amt ship_amt   """"}
/*H067*/     /* "Ord amount is < Minmum Shipment  Amount". */
/*H067*/   end.
/*H067*/ end.

   /* CHECK CREDIT LIMIT */
/*G692*/ /* (Don't bother checking if order is already on hold.) */
/*G692*/ if so_stat = "" then do:
/*LB01..Calculate other SO amt..*/
/*LB01*/	other_so_amt = 0.
/*LB01*/	for each so_mstr where so_cust = sotrcust and so_fsm_type=" " and so_nbr<>sotrnbr no-lock use-index so_cust,
/*LB01*/	each sod_det where so_nbr = sod_nbr no-lock use-index sod_nbr:
/*LB01*/	    other_so_amt = other_so_amt +
/*LB01*/	                  (sod_qty_ord - sod_qty_ship + sod_qty_inv)
/*LB01*/	                   * sod_price.
/*LB01*/	end.     
/*LB01..end of Calculate other SO amt..*/
/*LB01*/ /*   base_amt = ord_amt.*/
/*LB01*/    base_amt = ord_amt + other_so_amt.
/*LB01*/    find so_mstr where recid(so_mstr) = so_recno.
			if so_curr <> base_curr then
/*J053*/    do:
/*J053*               base_amt = round(base_amt / so_ex_rate,gl_ex_round). */
/*J053*/       /* CONVERT TO BASE CURRENCY */
/*J053*/       base_amt = (base_amt / so_ex_rate).
/*J053*/       /* ROUND PER DOC CURRENCY ROUND METHOD */
/*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output base_amt,
                                         input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/    end.

/*J0RX*/    /* NOTE: DO NOT PUT CALL REPAIR ORDERS (FSM-RO) ON HOLD - BECAUSE */
            /*    THESE ORDERS WILL NOT BE SHIPPING ANYTHING, ONLY INVOICING  */
            /*    FOR WORK ALREADY DONE.                                      */
            if cm_cr_limit < (cm_balance + base_amt)
/*J0RX*/    and so_fsm_type <> "FSM-RO"
            then do:
/*J053*        {mfmsg02.i 616 2 "cm_balance + base_amt,""->>>>,>>>,>>9.99"" "}*/
/*J053*/       {mfmsg02.i 616 2 "cm_balance + base_amt,"balance_fmt" "}
/*J053*        {mfmsg02.i 617 1 "cm_cr_limit,""->>>>,>>>,>>9.99"" "}          */
/*J053*/       {mfmsg02.i 617 1 "cm_cr_limit,"limit_fmt" "}
/*G692*/       if soc_cr_hold then do:
/*G692*/          so_stat = "HD".
/*G692*/          {mfmsg03.i 690 1 """客户订单""" """" """" }
/*G692*/          /* Sales Order placed on credit hold */
/*G692*/          display so_stat with frame d.
/*G692*/       end.
            end.
/*G692*/ end.

/*H008*/ undo_mtc3 = false.
end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*transaction*/
