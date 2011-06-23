/* soistrl2.p - SALES ORDER SHIPMENT TRAILER                                  */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.41.1.5 $                               */
/*! Calculate taxes for Sales Order Shipments                                 */
/* REVISION: 7.3            CREATED: 02/09/93   BY: bcm *G424*                */
/* REVISION: 7.4      LAST MODIFIED: 06/30/93   BY: jjs *H019*                */
/* REVISION: 7.4      LAST MODIFIED: 07/03/93   BY: bcm *H002*                */
/* REVISION: 7.4      LAST MODIFIED: 09/08/94   BY: bcm *H509*                */
/* REVISION: 7.4      LAST MODIFIED: 11/30/94   BY: bcm *H606*                */
/* REVISION: 7.4      LAST MODIFIED: 12/01/94   BY: bcm *H601*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 04/25/95   BY: jpm *H0D9*                */
/* REVISION: 7.4      LAST MODIFIED: 06/12/95   BY: tvo *H0BJ*                */
/* REVISION: 7.4      LAST MODIFIED: 07/06/95   BY: jym *H0F7*                */
/* REVISION: 8.5      LAST MODIFIED: 07/18/95   BY: taf *J053*                */
/* REVISION: 7.4      LAST MODIFIED: 11/21/95   BY: rxm *H0GY*                */
/* REVISION: 8.5      LAST MODIFIED: 03/08/96   BY: jzw *H0K0*                */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Tom Vogten         */
/* REVISION: 8.5      LAST MODIFIED: 09/10/96   BY: *H0MP* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: *K01X* Jeff Wootton       */
/* REVISION: 8.6      LAST MODIFIED: 09/19/97   BY: *H1FH* Molly Balan        */
/* REVISION: 8.6      LAST MODIFIED: 09/26/97   BY: *J21S* Niranjan Ranka     */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: *K0JV* Surendra Kumar     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 01/22/99   BY: *J38T* Poonam Bahl        */
/* REVISION: 8.6E     LAST MODIFIED: 05/07/99   BY: *J3DQ* Niranjan Ranka     */
/* REVISION: 9.1      LAST MODIFIED: 07/13/99   BY: *J2MD* Alexander Philips  */
/* REVISION: 9.1      LAST MODIFIED: 02/24/00   BY: *M0K0* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *N0F4* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/06/00   BY: *N0D0* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 10/13/00   BY: *N0W8* Mudit Mehta        */
/* Revision: 1.28       BY: Katie Hilbert         DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.29       BY: Ellen Borden          DATE: 07/09/01  ECO: *P007* */
/* Revision: 1.31       BY: Ellen Borden          DATE: 06/07/01  ECO: *P00G* */
/* Revision: 1.32       BY: Deepak Rao            DATE: 08/26/02  ECO: *M20D* */
/* Revision: 1.33       BY: Vandna Rohira         DATE: 04/28/03  ECO: *N1YL* */
/* Revision: 1.35       BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.36       BY: Vivek Gogte           DATE: 08/02/03  ECO: *N2GZ* */
/* Revision: 1.37       BY: Rajaneesh Sarangi     DATE: 01/08/04  ECO: *P1GK* */
/* Revision: 1.38       BY: Robin McCarthy        DATE: 04/19/04  ECO: *P15V* */
/* Revision: 1.39       BY: Ajay Nair             DATE: 05/17/04  ECO: *P21V* */
/* Revision: 1.41       BY: Vinod Kumar           DATE: 12/10/04  ECO: *P2TK* */
/* Revision: 1.41.1.1   BY: Vinod Kumar           DATE: 06/24/05  ECO: *Q0K1* */
/* Revision: 1.41.1.2   BY: Bharath Kumar      DATE: 08/30/05  ECO: *P3ZG* */
/* $Revision: 1.41.1.5 $  BY: Dinesh Dubey       DATE: 01/09/06 ECO: *P3HZ* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
 *  NOTE : In the initial release (7.4) we will be using transaction
 *         code "13" for both shipments and pending invoice maint.
 *         Since multiple shippers are not yet truly supported (trailers).
*/

/*! N1YL HAS CHANGED THE WAY TAXABLE/NON-TAXABLE AMOUNT IS CALCULATED.
 *  THE ORDER DISCOUNT IS APPLIED FOR EACH LINE TOTAL AND THEN IT IS
 *  SUMMED UP TO CALCULATE THE TAXABLE/NON-TAXABLE AMOUNT BASED ON THE
 *  TAXABLE STATUS OF EACH LINE. PREVIOUSLY, TAXABLE/NON-TAXABLE AMOUNT
 *  WAS OBTAINED FROM THE GTM TABLES. THIS CAUSED PROBLEMS WHEN
 *  MULTIPLE TAXABLE BASES ARE USED TO CALCULATE TAX.
 *
 *  TAXABLE/NON-TAXABLE AMOUNT WILL NOW BE DISPLAYED IN THE TRAILER
 *  FRAME BASED ON THE VALUE OF THE FLAG "DISPLAY TAXABLE/NON-TAXABLE
 *  AMOUNT ON TRAILER" IN THE GLOBAL TAX MANAGEMENT CTRL FILE
 */

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "SOISTRL2.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{socnis.i}     /* CUSTOMER CONSIGNMENT SHIPMENT TEMP-TABLE DEFINITION */

define input-output parameter table for tt_consign_shipment_detail.

{sosois1.i}
{sotxidef.i}

/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/* ASN API TEMP-TABLE */
{soshxt01.i}

/* l_txchg IS SET TO TRUE IN TXEDIT.P WHEN TAXES ARE BEING EDITED  */
/* AND NOT JUST VIEWED IN DR/CR MEMO MAINTENANCE                   */
define new shared variable l_txchg     like mfc_logical initial no.

define shared variable rndmthd         like rnd_rnd_mthd.
define shared variable so_recno        as recid.
define shared variable maint           as logical.
define shared variable taxable_amt     as decimal label "Taxable"
   format "->>>>,>>>,>>9.99".
define shared variable line_taxable_amt like taxable_amt.
define shared variable nontaxable_amt  like taxable_amt
   label "Non-Taxable".
define shared variable line_total      as decimal label "Line Total"
   format "-zzzz,zzz,zz9.99".
define shared variable disc_amt        like line_total label "Discount"
   format "(zzzz,zzz,zz9.99)".
define shared variable tax_amt         like line_total
   label "Total Tax".
define shared variable ord_amt         like line_total
   label "Total".
define shared variable tot_line_comm   as decimal extent 4
   format "->>>>,>>>,>>9.99<<<<".
define shared variable invcrdt         as character format "x(15)".
define shared variable user_desc       like trl_desc extent 3.
define shared variable eff_date        like glt_effdate.
define shared variable tax_date        like so_tax_date.
define shared variable ship_site       like sod_site.
define shared variable tax_edit        like mfc_logical initial false.
define shared variable tax_edit_lbl    like mfc_char format "x(28)".
define shared variable undo_trl2       like mfc_logical.
define shared variable container_charge_total as decimal
   format "->>>>>>>>9.99" label "Containers"        no-undo.
define shared variable line_charge_total as decimal
   format "->>>>>>>>9.99" label "Line Charges"      no-undo.
define shared variable l_nontaxable_lbl  as character format "x(12)" no-undo.
define shared variable l_taxable_lbl     as character format "x(12)" no-undo.

define variable ext_actual      like sod_price no-undo.
define variable tax_tr_type     like tx2d_tr_type initial "13" no-undo.
define variable sodfsmtype      like sod_fsm_type no-undo.
define variable org_tr_type     like tx2d_tr_type initial "11" no-undo.
define variable tax_nbr         like tx2d_nbr initial "" no-undo.
define variable tax_lines       like tx2d_line initial 0 no-undo.
define variable no_date         like mfc_logical initial false no-undo.
define variable recalc          like mfc_logical initial true no-undo.
define variable tax-edited      like mfc_logical initial false no-undo.
define variable tmp_amt         as   decimal no-undo.
define variable retval          as   integer no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable l_tax_in        like tax_amt no-undo.
define variable l_consigned_line_item like mfc_logical no-undo.

/* l_ext_actual IS THE EXTENDED AMOUNT EXCLUDING DISCOUNT. IT WILL */
/* BE USED FOR THE CALCULATION OF taxable_amt AND nontaxable_amt   */
define variable l_ext_actual          like sod_price   no-undo.

define buffer buf_sod_det for sod_det.

define temp-table tt_consign_rec no-undo
   field tt_consign_order like so_nbr
   field tt_consign_line like sod_line
   field tt_consign_qty_chg like sod_qty_chg
   index tt_consign_rec_idx tt_consign_order tt_consign_line.

/* CONSIGNMENT VARIABLES */
{socnvars.i}
{pxsevcon.i}
{&SOISTRL2-P-TAG1}

define buffer   tx2d_pend      for tx2d_det.

define shared frame    sotot.
define shared frame    f.

{txcurvar.i "NEW"}
{txcalvar.i}

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

/**** FORMS ****/
form
   so_shipvia     colon 15
   so_inv_nbr     colon 55 skip
   so_ship_date   colon 15
   so_to_inv      colon 55 skip
   so_bol         colon 15
   so_invoiced    colon 55
   so_rmks        colon 15
with frame f side-labels width 80.

if c-application-mode <> "API" then
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame f:handle).

/*DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED*/
{cclc.i}

/* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_CUSTOMER_CONSIGNMENT,
           input 10,
           input ADG,
           input CUST_CONSIGN_CTRL_TABLE,
           output using_cust_consignment)"}

find so_mstr where recid(so_mstr) = so_recno exclusive-lock.

if c-application-mode = "API" then do:

   /*
   * GET HANDLE OF API CONTROLLER
   */
   {gprun.i ""gpaigh.p""
      "( output apiMethodHandle,
         output apiProgramName,
         output apiMethodName,
         output apiContextString)"}

   /*
   * GET SO SHIPMENT HDR TEMP-TABLE
   */
   run getSoShipHdrRecord in apiMethodHandle
      (buffer ttSoShipHdr).

end. /* IF c-application-mode = "API" */

/* WHEN DEALING WITH AN RMA WE USE TRANSACTION TYPE 36 FOR GTM.   */
/* IF IT IS AN RMA-RECEIPT WE MUST ONLY CREATE TAX-DETAIL FOR     */
/* THE SOD_DET RECORDS WITH SOD_FSM_TYPE SET TO "RMA-RCT". IF     */
/* IT IS AN ISSUE, THEN ONLY CALCULATE FOR THE "RMA-ISS" RECORDS. */
if so_fsm_type = 'RMA' then
   assign
      sodfsmtype  = (if sorec = fsrmarec then "RMA-RCT"
                     else "RMA-ISS")
      org_tr_type = '36'.

{socurvar.i}
{sototfrm.i}

for first txc_ctrl
   fields (txc_domain txc__qad03)
   where  txc_domain = global_domain
no-lock: end.

taxloop:
do on endkey undo, leave:

   if c-application-mode = "API" and retry
      then return error return-value.

   /*** GET TOTALS FOR LINES ***/
   assign
      line_total = 0
      taxable_amt = 0
      container_charge_total = 0
      line_charge_total = 0
      nontaxable_amt = 0
      l_ord_contains_tax_in_lines = can-find (first sod_det
                                       where sod_domain = global_domain
                                       and   sod_nbr    = so_nbr
                                       and   sod_taxable
                                       and   sod_tax_in).

   empty temp-table t_store_ext_actual no-error.

   for each sod_det
      fields (sod_domain     sod_fsm_type     sod_line     sod_nbr
              sod_price      sod_due_date     sod_ord_mult sod_pkg_code
              sod_qty_ord    sod_qty_ship     sod_dock     sod_ship
              sod_qty_chg    sod_qty_inv      sod_taxable  sod_tax_in)
      where   sod_domain = global_domain
      and     sod_nbr = so_nbr
   exclusive-lock:

      /* IF CONSIGNMENT RECORDS EXIST FOR THE ORDER LINE */
      /* THEN DON'T CREATE TAX DETAIL BECAUSE THE LINE   */
      /* ACTUALLY HASN'T BEEN SHIPPED YET.               */
      if using_cust_consignment then do:
         l_consigned_line_item = no.

         {gprunmo.i &program = "socnsod1.p" &module = "ACN"
                    &param   = """(input so_nbr,
                                   input sod_line,
                                   output l_consigned_line_item,
                                   output consign_loc,
                                   output intrans_loc,
                                   output max_aging_days,
                                   output auto_replenish)"""}

         if l_consigned_line_item then do:

            create tt_consign_rec.
            assign
               tt_consign_order = sod_nbr
               tt_consign_line  = sod_line
               tt_consign_qty_chg = sod_qty_chg
               sod_qty_chg = 0.

            /* CHECK FOR ANY CONSIGNMENT RETURNED FOR CREDIT */
            /* NOTE: sod_qty_inv HASN'T BEEN UPDATED YET FOR */
            /* THIS SHIPMENT; DONE IN sosoisu3.p / mfivtr.i. */
            for each tt_consign_shipment_detail
               where tt_consign_shipment_detail.sales_order = sod_nbr
               and   tt_consign_shipment_detail.order_line  = sod_line
            no-lock:

               if tt_consign_shipment_detail.ship_qty < 0
                  and not tt_consign_shipment_detail.consigned_return_material
               then
                  sod_qty_chg = sod_qty_chg
                              + tt_consign_shipment_detail.ship_qty.
            end.

         end. /* IF l_consigned_line_item */
      end. /* IF using_cust_consignment */

      assign
         ext_actual   = sod_price * (sod_qty_chg + sod_qty_inv)
         l_ext_actual = (sod_price * (sod_qty_chg + sod_qty_inv)
                      * (1 - so_disc_pct / 100)).

      if using_line_charges and
         ((sod_qty_chg + sod_qty_inv) <> 0)
      then do:
         /* Get the totals for the additional line charges. */
         run getLineChargeTotal
                        (input sod_nbr,
                         input sod_line,
                         input rndmthd,
                         input-output line_total,
                         input-output line_charge_total,
                         input-output taxable_amt,
                         input-output nontaxable_amt).
      end. /*IF USING_LINE_CHARGES*/

      /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output ext_actual,
                  input        rndmthd,
                  output       mc-error-number)"}
      /* SS - 20081205.1 - B */
         /*
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
           */
      /* SS - 20081205.1 - E */

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output l_ext_actual,
                  input        rndmthd,
                  output       mc-error-number)"}

      /* SS - 20081205.1 - B */
         /*
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */
           */
      /* SS - 20081205.1 - E */

      for first t_store_ext_actual
         where t_line = sod_line
      no-lock: end.

      if not available t_store_ext_actual
      then do:
         create t_store_ext_actual.
         assign
            t_line       = sod_line
            t_ext_actual = ext_actual.
      end. /* IF NOT AVAILABLE t_store_ext_actual ... */

      /* USE THE EXISTING LOGIC TO CALCULATE ORDER TOTAL ONLY */
      /* WHEN SALES ORDER DOES NOT HAVE TAX INCLUDED LINES    */
      if l_ord_contains_tax_in_lines = no
      then
         line_total = line_total + ext_actual.

      if sod_taxable then
         assign
            taxable_amt      = taxable_amt + l_ext_actual
            line_taxable_amt = taxable_amt.
      else
         nontaxable_amt = nontaxable_amt + l_ext_actual.
   end.

   /* USE THE EXISTING LOGIC TO CALCULATE DISCOUNT ONLY WHEN */
   /* SALES ORDER DOES NOT HAVE TAX INCLUDED LINES           */
   if l_ord_contains_tax_in_lines = no
   then
      disc_amt = (- line_total * (so_disc_pct / 100)).

   /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
             "(input-output disc_amt,
               input        rndmthd,
               output       mc-error-number)"}
   /* SS - 20081205.1 - B */
      /*
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
        */
   /* SS - 20081205.1 - E */

   /* ADD TRAILER AMOUNTS */
   {txtrltrl.i so_trl1_cd so_trl1_amt user_desc[1]}
   {txtrltrl.i so_trl2_cd so_trl2_amt user_desc[2]}
   {txtrltrl.i so_trl3_cd so_trl3_amt user_desc[3]}

   /****** CALCULATE TAXES ************/

   /* THIS IS DONE TO PASS THE LOCAL VARIABLE TO txcalc.p */
   if so_tax_date = ? then
      assign
         no_date = true
         so_tax_date = eff_date.

   tax-edited = no.

   /* When we are dealing with RMA's, we only need to create
    * tax-detail for the issues, NOT for receipts and
    * labor-costs. The txedtchk.p below checks ALL lines
    * (includes labor and issues) for edited taxes.  Maybe this
    * needs to be changed to check only the issues */

   {gprun.i ""txedtchk.p""
            "(input  org_tr_type,       /* SOURCE TR  */
              input  so_nbr,            /* SOURCE REF */
              input  tax_nbr,           /* SOURCE NBR */
              input  0,                 /* ALL LINES  */
              output tax-edited)"}      /* RETURN VAL */

   if tax-edited then do:
      {pxmsg.i
         &MSGNUM=935 &ERRORLEVEL=2
         &CONFIRM=tax-edited &CONFIRM-TYPE='LOGICAL'}
   end. /* IF tax-edited */

   if recalc then do:

      /* THE POST FLAG IS SET TO 'NO' BECAUSE WE ARE NOT
       * CREATING QUANTUM REGISTER RECORDS FROM THIS CALL
       * TO TXCALC.P */
      {gprun.i ""txcalc.p""
               "(input  tax_tr_type,
                 input  so_nbr,
                 input  tax_nbr,
                 input  tax_lines,
                 input  no,
                 output result-status)"}

      if tax-edited
      then do:
      {gprun.i ""txabsrb.p""
               "(input so_nbr,
                 input tax_nbr,
                 input org_tr_type,
                 input-output line_total,
                 input-output taxable_amt)"}
      end. /* IF tax-edited */
      else do:
         {gprun.i ""txabsrb.p""
            "(input        so_nbr,
              input        tax_nbr,
              input        tax_tr_type,
              input-output line_total,
              input-output taxable_amt)"}
      end. /* else do */

   end.  /* IF RECALC */

   /* COPY EDITED RECORDS IF SPECIFIED BY USER */
   if tax-edited then do:

      if org_tr_type = '36' then do:

         for each sod_det
           fields (sod_domain     sod_fsm_type     sod_line     sod_nbr
              sod_price      sod_due_date     sod_ord_mult sod_pkg_code
              sod_qty_ord    sod_qty_ship     sod_dock     sod_ship
              sod_qty_chg    sod_qty_inv      sod_taxable  sod_tax_in)
            where   sod_domain = global_domain
            and     sod_nbr = so_nbr
            and     sod_fsm_type = "RMA-ISS"
         no-lock:
            {gprun.i ""txedtcpy.p""
                     "(input org_tr_type,    /* SOURCE TR  */
                       input so_nbr,         /* SOURCE REF */
                       input tax_nbr,        /* SOURCE NBR */
                       input  '13',          /* TARGET TR  */
                       input  so_nbr,        /* TARGET REF */
                       input  tax_nbr,       /* TARGET NBR */
                       input  sod_line)"}    /* SINGLE LINE*/
         end.

      end.
      else do:
         {gprun.i ""txedtcpy.p""
                  "(input  org_tr_type,       /* SOURCE TR  */
                    input  so_nbr,            /* SOURCE REF */
                    input  tax_nbr,           /* SOURCE NBR */
                    input  '13',              /* TARGET TR  */
                    input  so_nbr,            /* TARGET REF */
                    input  tax_nbr,           /* TARGET NBR */
                    input  0)"}               /* ALL LINES  */
      end.

   end.  /* IF TAX-EDITED */

   if no_date then so_tax_date = ?.

   /* GET TAX TOTALS */
   {gprun.i ""txtotal.p""
            "(input  tax_tr_type,
              input  so_nbr,
              input  tax_nbr,
              input  tax_lines,  /* ALL LINES */
              output tax_amt)"}

   /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
   {gprun.i ""txtotal1.p""
            "(input  tax_tr_type,
              input  so_nbr,
              input  tax_nbr,
              input  tax_lines,       /* ALL LINES */
              output l_tax_in)"}

   /* WHEN TAX DETAIL RECORDS ARE NOT AVAILABLE AND SO IS TAXABLE  */
   /* THEN USE THE PROCEDURE TO CALCULATE ORDER TOTAL AND DISCOUNT */

   /* WHEN TAX INCLUDED IS YES, ORDER DISCOUNT SHOULD BE   */
   /* CALCULATED ON THE LINE TOTAL AFTER REDUCING THE LINE */
   /* TOTAL BY THE INCLUDED TAX                            */
   if l_tax_in <> 0
      or (l_ord_contains_tax_in_lines
      and (not can-find (tx2d_det
      where tx2d_domain = global_domain
      and   tx2d_ref    = so_nbr
      and   tx2d_nbr    = so_inv_nbr)))
   then do:
      {gprunp.i "sopl" "p" "calDiscAmountAfterSubtractingTax"
                "(input table  t_store_ext_actual,
                  input        rndmthd,
                  input        so_disc_pct,
                  input        so_nbr,
                  input        so_inv_nbr,
                  input        tax_tr_type,
                  output       line_total,
                  output       disc_amt)"}

   end. /* IF l_tax_in <> 0 ... */

   /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
   assign
      taxable_amt      = taxable_amt - l_tax_in
      line_taxable_amt = taxable_amt
      tax_amt          = tax_amt + l_tax_in.

   if so_tax_date <> ? then
      tax_date = so_tax_date.
   else if so_ship_date <> ? then
      tax_date = so_ship_date.
   else
      tax_date = so_due_date.

   if l_tax_in <> 0
   then
      assign
         line_total     = (taxable_amt + nontaxable_amt
                          - (so_trl1_amt + so_trl2_amt + so_trl3_amt))
                          * (100 / (100 - so_disc_pct))
         disc_amt       = ( - line_total * (so_disc_pct / 100)).

   ord_amt =  line_total + disc_amt + so_trl1_amt
           + so_trl2_amt + so_trl3_amt + tax_amt.

   if ord_amt < 0 then
      invcrdt = "**" + getTermLabel("C_R_E_D_I_T",11) + "**".
   else
      invcrdt = "".

   if maint then do:

      if c-application-mode <> "API" then do:
         if txc__qad03 then
            display
               l_nontaxable_lbl
               nontaxable_amt
               l_taxable_lbl
               taxable_amt
            with frame sotot.
         else
            display
               "" @ l_nontaxable_lbl
               "" @ nontaxable_amt
               "" @ l_taxable_lbl
               "" @ taxable_amt
            with frame sotot.

         display
            so_curr
            line_total
            so_disc_pct
            disc_amt
            tax_date
            user_desc[1]  so_trl1_cd  so_trl1_amt
            user_desc[2]  so_trl2_cd  so_trl2_amt
            user_desc[3]  so_trl3_cd  so_trl3_amt
            tax_amt
            ord_amt
            tax_edit
            container_charge_total
            line_charge_total
         with frame sotot.
      end. /* IF C-APPLICATION-MODE <> "API" THEN */

      trlloop:
      do on error undo, retry
         on endkey undo taxloop, leave:
         if c-application-mode = "API" and retry
                    then return error return-value.

         {&SOISTRL2-P-TAG2}
         if c-application-mode <> "API"then
            set
               so_trl1_cd  so_trl1_amt
               so_trl2_cd  so_trl2_amt
               so_trl3_cd  so_trl3_amt
               tax_edit
            with frame sotot.
         else
            assign
               {mfaiset.i so_trl1_cd ttSoShipHdr.ed_trl1_cd}
               {mfaiset.i so_trl1_amt ttSoShipHdr.ed_trl1_amt}
               {mfaiset.i so_trl2_cd ttSoShipHdr.ed_trl2_cd}
               {mfaiset.i so_trl2_amt ttSoShipHdr.ed_trl2_amt}
               {mfaiset.i so_trl3_cd ttSoShipHdr.ed_trl3_cd}
               {mfaiset.i so_trl3_amt ttSoShipHdr.ed_trl3_amt}
               {mfaiset.i tax_edit    ttSoShipHdr.ed_tax_edit}.
         {&SOISTRL2-P-TAG3}

         {txedttrl.i &code  = "so_trl1_cd"
                     &amt   = "so_trl1_amt"
                     &desc  = "user_desc[1]"
                     &frame = "sotot"
                     &loop  = "trlloop"}

         /* VALIDATE TRAILER AMOUNT BASE ON ROUNDING METHOD */
         if (so_trl1_amt <> 0) then do:
            {gprun.i ""gpcurval.p""
                     "(input so_trl1_amt,
                       input rndmthd,
                       output retval)"}

            if (retval <> 0) then do:
               next-prompt so_trl1_amt with frame sotot.
               undo trlloop, retry.
            end.
         end.

         {txedttrl.i &code  = "so_trl2_cd"
                     &amt   = "so_trl2_amt"
                     &desc  = "user_desc[2]"
                     &frame = "sotot"
                     &loop  = "trlloop"}

         /* VALIDATE TRAILER AMOUNT BASE ON ROUNDING METHOD */
         if (so_trl2_amt <> 0) then do:
            {gprun.i ""gpcurval.p""
                     "(input so_trl2_amt,
                       input rndmthd,
                       output retval)"}

            if (retval <> 0) then do:
               next-prompt so_trl2_amt with frame sotot.
               undo trlloop, retry.
            end.
         end.

         {txedttrl.i &code  = "so_trl3_cd"
                     &amt   = "so_trl3_amt"
                     &desc  = "user_desc[3]"
                     &frame = "sotot"
                     &loop  = "trlloop"}

         /* VALIDATE TRAILER AMOUNT BASE ON ROUNDING METHOD */
         if (so_trl3_amt <> 0) then do:
            {gprun.i ""gpcurval.p""
                     "(input so_trl3_amt,
                       input rndmthd,
                       output retval)"}

            if (retval <> 0) then do:
               next-prompt so_trl3_amt with frame sotot.
               undo trlloop, retry.
            end.
         end.
      end. /* DO ON ERROR UNDO, RETRY */

      disc_amt = (- line_total * (so_disc_pct / 100)).
      /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output disc_amt,
                  input        rndmthd,
                  output       mc-error-number)"}
      /* SS - 20081205.1 - B */
         /*
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
           */
      /* SS - 20081205.1 - E */

      /*** GET TOTALS FOR LINES ***/
      assign
         line_total = 0
         taxable_amt = 0
         container_charge_total = 0
         line_charge_total = 0
         nontaxable_amt = 0.

      for each sod_det
        fields (sod_domain     sod_fsm_type     sod_line     sod_nbr
              sod_price      sod_due_date     sod_ord_mult sod_pkg_code
              sod_qty_ord    sod_qty_ship     sod_dock     sod_ship
              sod_qty_chg    sod_qty_inv      sod_taxable  sod_tax_in)
         where   sod_domain = global_domain
         and     sod_nbr = so_nbr
      no-lock:

         assign
            ext_actual   = sod_price * (sod_qty_chg + sod_qty_inv)
            l_ext_actual = (sod_price * (sod_qty_chg + sod_qty_inv)
                         * (1 - so_disc_pct / 100)).

         if using_line_charges and
            ((sod_qty_chg + sod_qty_inv) <> 0)
         then do:
            /* Get the totals for the additional line charges. */
            run getLineChargeTotal
               (input sod_nbr,
                input sod_line,
                input rndmthd,
                input-output line_total,
                input-output line_charge_total,
                input-output taxable_amt,
                input-output nontaxable_amt).
         end. /*IF USING_LINE_CHARGES*/

         /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output ext_actual,
                     input        rndmthd,
                     output       mc-error-number)"}
         /* SS - 20081205.1 - B */
            /*
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
              */
         /* SS - 20081205.1 - E */

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output l_ext_actual,
                     input        rndmthd,
                     output       mc-error-number)"}
         /* SS - 20081205.1 - B */
            /*
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */
              */
         /* SS - 20081205.1 - E */

         /* CALL THE PROCEDURE TO GET LINE TOTAL ONLY WHEN TAX IS INCLUDED */
         if sod_tax_in
         then do:
            {gprunp.i "sopl" "p" "getExtendedAmount"
                      "(input        rndmthd,
                        input        sod_line,
                        input        so_nbr,
                        input        so_inv_nbr,
                        input        tax_tr_type,
                        input-output ext_actual)"}
         end. /* IF sod_tax_in ... */

         line_total = line_total + ext_actual.
         if sod_taxable then
            taxable_amt = taxable_amt + l_ext_actual.
         else
            nontaxable_amt = nontaxable_amt + l_ext_actual.
      end.

      disc_amt = (- line_total * (so_disc_pct / 100)).
      /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output disc_amt,
                  input        rndmthd,
                  output       mc-error-number)"}
      /* SS - 20081205.1 - B */
         /*
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
           */
      /* SS - 20081205.1 - E */

      /* ADD TRAILER AMOUNTS */
      {txtrltrl.i so_trl1_cd so_trl1_amt user_desc[1]}
      {txtrltrl.i so_trl2_cd so_trl2_amt user_desc[2]}
      {txtrltrl.i so_trl3_cd so_trl3_amt user_desc[3]}

      /****** CALCULATE TAXES ************/

      /* THIS IS DONE TO PASS THE LOCAL VARIABLE TO txcalc.p */
      if so_tax_date = ? then
         assign
            no_date = true
            so_tax_date = eff_date.

      if recalc and not tax-edited then do:

         /* THE POST FLAG IS SET TO 'NO' BECAUSE WE ARE NOT
          * CREATING QUANTUM REGISTER RECORDS FROM THIS CALL
          * TO TXCALC.P */
         {gprun.i ""txcalc.p""
                  "(input  tax_tr_type,
                    input  so_nbr,
                    input  tax_nbr,
                    input  tax_lines,
                    input  no,
                    output result-status)"}

      end.

      /* DO TAX DETAIL DISPLAY / EDIT HERE */
      if tax_edit then do:
         if c-application-mode <> "API" then do:
            hide frame sotot no-pause.
            hide frame f no-pause.
         end.
         {gprun.i ""txedit.p""
                  "(input  tax_tr_type,
                    input  so_nbr,
                    input  tax_nbr,
                    input  tax_lines, /* ALL LINES  */
                    input  so_tax_env,
                    input  so_curr,
                    input  so_ex_ratetype,
                    input  so_ex_rate,
                    input  so_ex_rate2,
                    input  tax_date,
                    output tax_amt)"}
         if c-application-mode <> "API" then do:
            view frame sotot.
            view frame f.
         end.
      end.

      {gprun.i ""txabsrb.p""
         "(input        so_nbr,
           input        tax_nbr,
           input        tax_tr_type,
           input-output line_total,
           input-output taxable_amt)"}

      /* CALCULATE TOTALS */
      {gprun.i ""txtotal.p""
               "(input  tax_tr_type,
                 input  so_nbr,
                 input  tax_nbr,
                 input  tax_lines,    /* ALL LINES */
                 output tax_amt)"}

      /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
      {gprun.i ""txtotal1.p""
               "(input  tax_tr_type,
                 input  so_nbr,
                 input  tax_nbr,
                 input  tax_lines,       /* ALL LINES */
                 output l_tax_in)"}

      /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
      assign
         taxable_amt = taxable_amt - l_tax_in
         tax_amt     = tax_amt     + l_tax_in.

      if l_tax_in <> 0
      then
         assign
            line_total     = (taxable_amt + nontaxable_amt
                             - (so_trl1_amt + so_trl2_amt + so_trl3_amt))
                             * (100 / (100 - so_disc_pct))
            disc_amt       = ( - line_total * (so_disc_pct / 100)).

      if no_date then so_tax_date = ?.

      ord_amt =  line_total + disc_amt + so_trl1_amt
              + so_trl2_amt + so_trl3_amt + tax_amt.

      if ord_amt < 0 then
         invcrdt = "**" + getTermLabel("C_R_E_D_I_T",11) + "**".
      else
         invcrdt = "".
   end.  /* IF MAINT */

   if c-application-mode <> "API" then do:
      if txc__qad03 then
         display
            l_nontaxable_lbl
            nontaxable_amt
            l_taxable_lbl
            taxable_amt
         with frame sotot.
      else
         display
            "" @ l_nontaxable_lbl
            "" @ nontaxable_amt
            "" @ l_taxable_lbl
            "" @ taxable_amt
         with frame sotot.

      display
         so_curr
         line_total
         so_disc_pct
         disc_amt
         tax_date
         user_desc[1]  so_trl1_cd  so_trl1_amt
         user_desc[2]  so_trl2_cd  so_trl2_amt
         user_desc[3]  so_trl3_cd  so_trl3_amt
         tax_amt
         ord_amt
      with frame sotot.
   end. /* IF C-APPLICATION-MODE <> "API" THEN */
   undo_trl2 = false.

   /* RESET SOD_QTY_CHG BACK TO CONSIGNED QTY*/
   if using_cust_consignment then do:
      for each tt_consign_rec exclusive-lock:
         find first buf_sod_det
            where sod_domain = global_domain
            and   sod_nbr = tt_consign_order
            and   sod_line = tt_consign_line
         exclusive-lock.

         buf_sod_det.sod_qty_chg = tt_consign_qty_chg.
         delete tt_consign_rec.
      end.
   end. /* IF using_cust_consignment */

end.  /* TAXLOOP */

if undo_trl2 and c-application-mode <> "API" then do:
   hide frame sotot no-pause.
   hide frame f no-pause.
end.

/* WE MAY ADD CODE HERE TO PRINT THE TAX DATA IN A CERTAIN WAY */
/* FOR SALES ORDER PRINTING */

PROCEDURE getLineChargeTotal:
   /*Purpose: Total any additional charges for the sales order line. */

   define input parameter ipOrderNumber as character no-undo.
   define input parameter ipOrderLine as integer no-undo.
   define input parameter ipRndMthd like rnd_rnd_mthd no-undo.
   define input-output parameter iopLineTotal as decimal no-undo.
   define input-output parameter iopLineChargeTotal as decimal no-undo.
   define input-output parameter iopTaxableAmt as decimal no-undo.
   define input-output parameter iopNonTaxableAmt as decimal no-undo.

   define variable vLineCharge as decimal no-undo.
   define variable vMsgNbr as integer no-undo.

   for each sodlc_det
      fields (sodlc_domain     sodlc_order     sodlc_ord_line
              sodlc_ext_price  sodlc_one_time  sodlc_times_charged
              sodlc_trl_code)
      where   sodlc_domain = global_domain
      and     sodlc_order = ipOrderNumber
      and     sodlc_ord_line = ipOrderLine
   no-lock:

      if sodlc_one_time
         and sodlc_times_charged > 0
      then
         next.

      vLineCharge = sodlc_ext_price.

      /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output vLineCharge,
                  input ipRndMthd,
                  output vMsgNbr)"}
      /* SS - 20081205.1 - B */
         /*
      if vMsgNbr <> 0 then do:
         {pxmsg.i &MSGNUM = vMsgNbr &ERRORLEVEL = 2}
      end.
           */
      /* SS - 20081205.1 - E */

      assign
         iopLineChargeTotal = iopLineChargeTotal + vLineCharge
         iopLineTotal = iopLineTotal + vLineCharge.

      for first trl_mstr
         fields (trl_domain trl_code trl_taxable trl_desc)
         where   trl_domain = global_domain
         and     trl_code = sodlc_trl_code
      no-lock:

         if trl_taxable then
            iopTaxableAmt = iopTaxableAmt + vLineCharge.
         else
            iopNonTaxableAmt = iopNonTaxableAmt + vLinecharge.
      end.
   end. /* FOR EACH SODLC_DET*/

END PROCEDURE. /* GETLINECHARGETOTAL */
