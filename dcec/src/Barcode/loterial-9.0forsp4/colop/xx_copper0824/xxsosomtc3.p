/* xxsosomtc3.p - SALES ORDER MAINTENANCE TRAILER UPDATES TO TAX                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.26 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
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
/* REVISION: 8.5      LAST MODIFIED: 02/12/98   BY: *J2F4* Manish K.          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel           */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/12/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 02/16/99   BY: *J3B4* Madhavi Pradhan    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *N0F4* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/13/00   BY: *N0WB* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *F458*                    */
/* Old ECO marker removed, but no ECO header exists *F765*                    */
/* Old ECO marker removed, but no ECO header exists *G415*                    */
/* Old ECO marker removed, but no ECO header exists *G692*                    */
/* Revision: 1.24         BY: Katie Hilbert      DATE: 04/01/01  ECO: *P002*  */
/* Revision: 1.25         BY: Jean Miller        DATE: 04/10/02  ECO: *P058*  */
/* $Revision: 1.26 $        BY: Laurene Sheridan   DATE:12/10/02   ECO: *M219*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{mfdeclre.i}
{cxcustom.i "SOSOMTC3.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable convertmode as character no-undo initial "MAINT".
define new shared variable sotax_update like mfc_logical  no-undo.

define shared variable rndmthd like rnd_rnd_mthd.
define shared variable cr_terms_changed like mfc_logical no-undo.
define shared variable so_recno as recid.
define shared variable cm_recno as recid.
define shared variable base_amt like ar_amt.
define shared variable undo_trl2     like mfc_logical.
define shared variable undo_mtc3     like mfc_logical.
define shared variable display_trail like mfc_logical.
define shared variable credit_hold_applied like mfc_logical no-undo.
define shared variable balance_fmt as character.
define shared variable limit_fmt as character.
define shared variable undo_mainblk like mfc_logical no-undo.

define shared frame d.
define shared frame sotot.

define variable totalorder as decimal no-undo.
define variable ship_amt      like ar_amt.
define variable mc-error-number like msg_nbr no-undo.
define variable msg-arg  as character format "x(20)" no-undo.

define variable ccOrder         as logical                      no-undo.
{&SOSOMTC3-P-TAG1}

{etdcrvar.i "new"}
{etsotrla.i} /* Define common variables for SO trailer */

{xxsosomt01.i} /* Define trailer frame d     (lower frame) */

find so_mstr where recid(so_mstr) = so_recno.

for first cm_mstr
fields(cm_balance cm_cr_limit)
   where recid(cm_mstr) = cm_recno
no-lock: end.

for first soc_ctrl
fields(soc_cr_hold)
no-lock: end.

maint = yes.

/* Warn user now if order had been put on credit hold  */
if credit_hold_applied then do:
   msg-arg = string((cm_balance + base_amt),balance_fmt).
   /* Customer Balance plus this Order */
   {pxmsg.i &MSGNUM=616 &ERRORLEVEL=2 &MSGARG1=msg-arg}
   msg-arg = string(cm_cr_limit,limit_fmt).
   /* Credit Limit */
   {pxmsg.i &MSGNUM=617 &ERRORLEVEL=1 &MSGARG1=msg-arg}
   /* Sales Order placed on credit hold */
   {pxmsg.i &MSGNUM=690 &ERRORLEVEL=1 &MSGARG1=getTermLabel(""SALES_ORDER"",20)}
    credit_hold_applied = false.
end.

/* WARN USER IF CREDIT TERMS WAS CHANGED DURING */
/* PRICING AND THE TERMS INTEREST WAS NOT USED TO RECALCULATE  */
/* PRICES. */
if cr_terms_changed then do:

   for first ct_mstr
   fields(ct_code ct_terms_int)
       where ct_code = so_cr_terms
   no-lock: end.

   if available ct_mstr and ct_terms_int <> 0 then do:
      /* TERMS CODE CHANGED FOR THIS ORDER BY A CREDIT TERMS PRICELIST. */
      {pxmsg.i &MSGNUM=6222 &ERRORLEVEL=2}
      /* TERMS INTEREST OF # PERCENT NOT APPLIED TO THIS ORDER. */
      {pxmsg.i &MSGNUM=6223 &ERRORLEVEL=2 &MSGARG1=ct_terms_int}
   end.

end.

mainblk:
do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


   undo_trl2 = true.
   {gprun.i ""xxsosotrle.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

   if undo_trl2 then return.

/*      THE ROUTINE MFSOTRL.I TAKES SOD_QTY_ORD - SOD_QTY_CHG AND USES THAT
 *      QUANTITY * THE PRICE TO GET THE ORDER TOTAL (THIS WAY YOU SEE THE
 *      DOLLAR AMOUNT FOR THE QUANTITY OPEN ONLY.)  IF THAT CALCULATION IS
 *      NEGATIVE, THEN THE VARIABLE invcrdt = "**C R E D I T**".  THE WORD
 *      CREDIT CAN BE MISLEADING IN THE CASE WHERE A SALES ORDER WAS OVER
 *      SHIPPED.  THIS CODE INSURES THAT THE WORD CREDIT WILL ONLY APEAR IF
 *      THE SALES ORDER WAS ORIGINALLY A CREDIT.                    */
   if invcrdt = "**" + getTermLabel("C_R_E_D_I_T",11) + "**" then do:
      totalorder = 0.
      for each sod_det where sod_nbr = so_nbr no-lock:
         assign totalorder = totalorder + (sod_qty_ord * sod_price).
      end. /* for each sod_det */
      if totalorder >= 0 then assign invcrdt = "".
   end. /* invcrdt = "**C R E D I T**" */

   /*DISPLAY TRAILER*/
   {sototdsp.i}

   /*CHECK FOR MINIMUM NET ORDER AMOUNT DUE TO REQUIREMENT OF
     QUALIFYING PRICE LIST.  IF VIOLATION FOUND, DISPLAY WARNING
     MESSAGE*/

   for each pih_hist where pih_doc_type = 1 and
         pih_nbr      = so_nbr
         no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

      if pih_min_net <> 0 and pih_min_net > line_total then do:
         /*Price list requires min net order amt, price list:*/
         {pxmsg.i &MSGNUM=6925 &ERRORLEVEL=2
                  &MSGARG1=pih_list
                  &MSGARG2=pih_min_net}
         if not batchrun then
            pause.
      end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   /* CHECK FOR MINIMUM SHIP AMOUNT */
   for first mfc_ctrl
   fields(mfc_decimal mfc_field)
      where mfc_field = "soc_min_shpamt"
   no-lock: end.
/*GUI*/ if global-beam-me-up then undo, leave.


   if available mfc_ctrl then do:
      ship_amt = mfc_decimal.
      if so_curr <> base_curr then
         {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input so_curr,
                    input so_ex_rate2,
                    input so_ex_rate,
                    input ship_amt,
                    input false,
                    output ship_amt,
                    output mc-error-number)"}.
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      if ord_amt > 0 and  ord_amt < ship_amt then do:
         /* Ord amount is lt Minmum Shipment  Amount. */
         {pxmsg.i &MSGNUM=6211 &ERRORLEVEL=2
                  &MSGARG1=ord_amt
                  &MSGARG2=ship_amt}
      end.
   end.

   /* FIND OUT IF THIS IS A CREDITCARD SO */
   ccOrder = can-find(first qad_wkfl
                      where qad_key1
                      begins string(so_nbr, "x(8)")
                      and qad_key2 = "creditcard").

   /* CHECK CREDIT LIMIT */
   /* Don't bother checking if order is already on hold. */
   if so_stat = "" then do:
     base_amt = ord_amt.
      if so_curr <> base_curr then
      do:

         {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input so_curr,
                       input base_curr,
                       input so_ex_rate,
                       input so_ex_rate2,
                       input base_amt,
                       input true,
                       output base_amt,
                       output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

      end.
      /* NOTE: DO NOT PUT CALL REPAIR ORDERS (FSM-RO) ON HOLD - BECAUSE */
      /*    THESE ORDERS WILL NOT BE SHIPPING ANYTHING, ONLY INVOICING  */
      /*    FOR WORK ALREADY DONE.                                      */

      /* NOTE: ALSO DO NOT PUT RMA ORDERS (RMA) ON HOLD - BECAUSE THESE */
      /*    ORDERS WILL BE CHECKED FOR CREDIT LIMIT AND PUT ON HOLD IN  */
      /*    THE PROGRAM FSRMAMTU.P DEPENDING ON THE SERVICE LEVEL FLAG  */

      if cm_cr_limit < (cm_balance + base_amt)
         and so_fsm_type <> "FSM-RO"
         and so_fsm_type <> "RMA"
         and not(ccOrder)
      then do:

         msg-arg = string((cm_balance + base_amt),balance_fmt).
         /* Customer Balance plus this Order */
         {pxmsg.i &MSGNUM=616 &ERRORLEVEL=2 &MSGARG1=msg-arg}
         msg-arg = string(cm_cr_limit,limit_fmt).
         /* Credit Limit */
         {pxmsg.i &MSGNUM=617 &ERRORLEVEL=1 &MSGARG1=msg-arg}

         if soc_cr_hold then do:
            so_stat = "HD".
            /* Sales Order placed on credit hold */
            {pxmsg.i &MSGNUM=690 &ERRORLEVEL=1
                     &MSGARG1=getTermLabel(""SALES_ORDER"",20)}
            display so_stat with frame d.
         end.
      end.

      /* MUST TREAT ccOrder's SEPERATELY WHEN CREDIT CHECKING */
      if ccOrder then do:
         if so_prepaid < base_amt
         then do:
            if soc_cr_hold then do:
               so_stat = "HD".
               /* Sales Order placed on credit hold */
               {pxmsg.i &MSGNUM=690 &ERRORLEVEL=1
                        &MSGARG1=getTermLabel(""SALES_ORDER"",20)}
               display so_stat with frame d.
            end.
         end.
      end.

   end.

   undo_mtc3 = false.
end. /*transaction*/
