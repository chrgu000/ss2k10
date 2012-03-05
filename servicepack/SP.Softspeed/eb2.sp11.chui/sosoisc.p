/* sosoisc.p - SALES ORDER SHIPMENT TRAILER                                   */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 6.0      LAST MODIFIED: 08/22/90   BY: MLB *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 12/21/90   BY: MLB *D238*                */
/* REVISION: 6.0      LAST MODIFIED: 04/11/91   BY: MLV *D517*                */
/* REVISION: 6.0      LAST MODIFIED: 05/31/91   BY: MLV *D667*                */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040*                */
/* REVISION: 6.0      LAST MODIFIED: 12/26/91   BY: MLV *D850*                */
/* REVISION: 7.0      LAST MODIFIED: 03/05/92   BY: tjs *F247*                */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: tjs *F405*                */
/* REVISION: 7.0      LAST MODIFIED: 04/23/92   BY: sas *F379*                */
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458*                */
/* REVISION: 7.0      LAST MODIFIED: 07/16/92   BY: tjs *F805*                */
/* REVISION: 7.3      LAST MODIFIED: 09/25/92   BY: tjs *G087*                */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: afs *G219*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 01/12/93   BY: tjs *G536*                */
/* REVISION: 7.3      LAST MODIFIED: 02/10/93   BY: bcm *G424*                */
/* REVISION: 7.3      LAST MODIFIED: 03/12/93   BY: tjs *G451*                */
/* REVISION: 7.4      LAST MODIFIED: 07/03/93   BY: bcm *H002*                */
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009*                */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*                */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: bcm *H127*                */
/* REVISION: 7.4      LAST MODIFIED: 10/14/93   BY: dpm *H067*                */
/* REVISION: 7.4      LAST MODIFIED: 03/18/94   BY: dpm *H297*                */
/* REVISION: 7.4      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*                */
/* REVISION: 7.4      LAST MODIFIED: 11/06/94   BY: ljm *GO15*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 05/31/95   BY: jym *G0ND*                */
/* REVISION: 8.5      LAST MODIFIED: 07/18/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 06/01/96   BY: tzp *G1WX*                */
/* REVISION: 8.5      LAST MODIFIED: 09/26/97   BY: *J21S* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/15/98   BY: *L00L* Darius Sidel       */
/* REVISION: 8.6E     LAST MODIFIED: 05/06/98   BY: *H1JB* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 07/10/98   BY: *L024* Sami Kureishy      */
/* REVISION: 9.1      LAST MODIFIED: 07/01/99   BY: *N00T* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 07/13/99   BY: *J2MD* Alexander Philips  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/16/00   BY: *N0BC* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* Revision: 1.16.1.6     BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.16.1.7     BY: Ellen Borden        DATE: 07/09/01  ECO: *P007* */
/* Revision: 1.16.1.8     BY: Katie Hilbert       DATE: 12/05/01  ECO: *P03C* */
/* Revision: 1.16.1.8.3.1 BY: Ed van de Gevel     DATE: 12/02/03  ECO: *P0SV* */
/* Revision: 1.16.1.8.3.2 BY: Ed van de Gevel     DATE: 12/16/03  ECO: *P1G0* */
/* Revision: 1.16.1.8.3.4 BY: Robin McCarthy      DATE: 02/26/04  ECO: *P15V* */
/* Revision: 1.16.1.8.3.5 BY: Shivganesh Hegde    DATE: 09/22/04  ECO: *P2LM* */
/* Revision: 1.16.1.8.3.7 BY: Abhishek Jha        DATE: 24/01/05  ECO: *P353* */
/* Revision: 1.16.1.8.3.8 BY: Vinod Kumar         DATE: 05/05/05  ECO: *P2TK* */
/* $Revision: 1.16.1.8.3.9 $ BY: Robin McCarthy   DATE: 12/01/05  ECO: *P470* */
/* $Revision: 1.16.1.8.3.9 $ BY: Bill Jiang   DATE: 07/28/06  ECO: *SS - 20060728.1* */
/* $Revision: 1.16.1.8.3.9 $ BY: Bill Jiang   DATE: 07/31/06  ECO: *SS - 20060731.1* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 20060731.1 - B */
/*
1. 更正了"合计"为零时不能输出"待开发票登记簿"的BUG
2. 更正了同时处理的BUG,之前只是解决了分别处理的BUG
*/
/* SS - 20060731.1 - E */

/* SS - 20060728.1 - B */
/*
1. 更正了"合计"为零时不能输出"待开发票登记簿"的BUG
*/
/* SS - 20060728.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "SOSOISC.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{socnis.i}     /* CUSTOMER CONSIGNMENT SHIPMENT TEMP-TABLE DEFINITION */

/* PARAMETERS */
define output parameter l_recalc like mfc_logical no-undo.
define input-output parameter table for tt_consign_shipment_detail.

define new shared variable ship as logical no-undo.
define new shared variable so_recno as recid.
define new shared variable undo_trl2 like mfc_logical.
define new shared variable undo_isc1 like mfc_logical.
{&SOSOISC-P-TAG1}
{etdcrvar.i "new"}

{sosois1.i}

define shared variable rndmthd like rnd_rnd_mthd.
define shared variable so_mstr_recid as recid.
define shared variable undo-all like mfc_logical no-undo.
define shared variable eff_date like glt_effdate.
define shared variable calc_fr    like mfc_logical.
define shared variable disp_fr    like mfc_logical.
define shared variable freight_ok like mfc_logical.

define variable    w-so_shipvia   like so_mstr.so_shipvia no-undo.
define variable    w-so_bol       like so_mstr.so_bol no-undo.
define variable    w-so_rmks      like so_mstr.so_rmks no-undo.
define variable    ship_amt       like ar_amt no-undo.
define variable    l_tax_edited   like mfc_logical no-undo.
define variable    mc-error-number like msg_nbr no-undo.

define new shared frame f.
define new shared frame sotot.

{etsotrla.i}

form
   so_shipvia     colon 15
   so_inv_nbr     colon 55 skip
   so_ship_date   colon 15
   so_to_inv      colon 55 skip
   so_bol         colon 15
   so_invoiced    colon 55
   so_rmks        colon 15
with frame f side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame f:handle).

if sorec = fsrmarec then
   so_ship_date:label = getTermLabel("RECEIVE_DATE",14).

assign
   maint = yes
   undo-all = yes.

find so_mstr where recid(so_mstr) = so_mstr_recid
exclusive-lock.

so_recno = recid(so_mstr).

if can-find(mfc_ctrl
   where mfc_module = "SO"
   and   mfc_seq = 170)
then do:
   assign
      w-so_shipvia   = so_mstr.so_shipvia
      w-so_bol       = so_mstr.so_bol
      w-so_rmks      = so_mstr.so_rmks.
end. /* user turned on multiple bol print */

if c-application-mode <> "API" then do:
   clear frame sotot no-pause.
   view frame sotot.
   view frame f.
end. /* IF C-APPLICATION-MODE <> "API" THEN */

for first sod_det
   fields (sod_nbr sod_qty_chg)
   where sod_nbr = so_nbr
   and   sod_qty_chg <> 0
no-lock: end.

if available sod_det then
   ship = yes.

if c-application-mode <> "API" then do:
   display
      so_shipvia
      eff_date when (ship) @ so_ship_date
      so_bol
      so_rmks
      so_ship_date when (not ship)
      so_inv_nbr
      so_to_inv
      so_invoiced
   with frame f.

   {sototdsp.i}
end. /* IF C-APPLICATION-MODE <> "API" THEN */

{&SOSOISC-P-TAG2}

/* DISPLAY FREIGHT WEIGHTS */
if calc_fr then do:
   if not freight_ok then do:
      {pxmsg.i &MSGNUM=669 &ERRORLEVEL=2} /* Freight error detected - */
      if c-application-mode <> "API" then do:
         if not batchrun then
            pause.
      end.
   end.
   if disp_fr then do:
      {&SOSOISC-P-TAG3}
      /* Freight Weight = */
      {pxmsg.i &MSGNUM=698 &ERRORLEVEL=1
               &MSGARG1=so_weight &MSGARG2=so_weight_um}
   end.
end.

undo_trl2 = true.
{gprun.i ""soistrl2.p""
         "(input-output table tt_consign_shipment_detail)"}

if undo_trl2 then do:
   if can-find (first lotw_wkfl
      where lotw_mfguser = mfguser)
   then do:
      for each lotw_wkfl
         where lotw_mfguser = mfguser
      exclusive-lock:
         delete lotw_wkfl.
      end. /* FOR EACH lotw_wkfl */
   end. /* IF CAN-FIND lotw_wkfl.. */
   return.   /* UNDO ALL */
end. /* IF undo_trl2..  */

if c-application-mode <> "API" then do:
   {sototdsp.i}
end.

/* CHECK FOR MINIMUM SHIP AMOUNT */
for first mfc_ctrl
   fields (mfc_decimal mfc_field mfc_module mfc_seq)
   where mfc_field = "soc_min_shpamt"
no-lock: end.

if available mfc_ctrl then do:
   ship_amt = mfc_decimal.

   if so_curr <> base_curr then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input base_curr,
                  input so_curr,
                  input so_ex_rate2,
                  input so_ex_rate,
                  input ship_amt,
                  input false,
                  output ship_amt,
                  output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.

   if ord_amt > 0
      and ord_amt < ship_amt
   then do:
      /* Ord amount is < Minimum Shipment Amount */
      {pxmsg.i &MSGNUM=6211 &ERRORLEVEL=2
               &MSGARG1=ord_amt &MSGARG2=ship_amt}
   end.
end.

/* DETERMINE DEFAULT SETTING FOR "READY TO INVOICE" */
if line_total <> 0            /* NON-CONSIGNED SHIPMENT */
   or (so_trl1_amt <> 0       /* CONSIGNED SHIPMENT WITH TRAILER CHARGES ONLY */
   or  so_trl2_amt <> 0
   or  so_trl3_amt <> 0)
then
   so_to_inv = yes.
else
   so_to_inv = no.

   /* SS - 20060728.1 - B */
   for first sod_det
      fields (sod_nbr sod_qty_chg)
      where sod_nbr = so_nbr
      /* SS - 20060731.1 - B */
      /*
      and   sod_qty_inv <> 0
      */
      and   (sod_qty_inv <> 0 OR sod_qty_chg <> 0)
      /* SS - 20060731.1 - E */
   no-lock: end.

   if available sod_det then
      so_to_inv = yes.
   /* SS - 20060728.1 - E */

so_invoiced = no.

if c-application-mode <> "API" then do:
   display
      so_shipvia
      eff_date when (ship) @ so_ship_date
      so_bol
      so_rmks
      so_ship_date when (not ship)
      so_inv_nbr
      so_to_inv
      so_invoiced
   with frame f.
end. /* IF C-APPLICATION-MODE <> "API" THEN */

undo_isc1 = true.
{gprun.i ""sosoisc2.p""}

if undo_isc1 then undo, retry.

l_recalc = yes.
if so_fsm_type = "" then do:

   /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */
   {gprun.i ""txedtchk.p""
            "(input  '11',
              input  so_nbr,
              input  so_quote,
              input  0,
              output l_tax_edited)"}

   if l_tax_edited then do:
      /* EDITED PREVIOUS TAX VALUES TYPE #; RECALCULATE? */
      {pxmsg.i &MSGNUM=2579 &ERRORLEVEL=2
               &MSGARG1="11"
               &CONFIRM=l_recalc
               &CONFIRM-TYPE='LOGICAL'}
   end. /* IF L_TAX_EDITED */
end. /* IF SO_FSM_TYPE  = ""  */

/* IF THE USER HAS TURNED ON THE FUNCTIONALITY TO PRINT MULTIPLE   */
/* BILL OF LADING INFORMATION ON AN INVOICE, THEN STORE THE BILL   */
/* OF LADING INFORMATION HERE IN A qad_wkfl RECORD.                */
/* THIS FUNCTIONALITY WAS SPECIFICALLY SET UP FOR G0ND AND IS      */
/* CUSTOMER ENHANCEMENT WHICH RESIDES IN THE STANDARD PRODUCT.     */
if can-find(mfc_ctrl
   where mfc_module = "SO"
   and   mfc_seq = 170)
then do:
   find qad_wkfl
      where qad_key1 = so_nbr
      and   qad_key2 = so_bol + "utsoship"
   exclusive-lock no-error.

   if not available qad_wkfl then do:
      create qad_wkfl.
      assign
         qad_key1 = so_nbr
         qad_key2 = so_bol + "utsoship".
   end. /* create a new qad_wkfl record */

   for first sr_wkfl
         fields (sr_site sr_userid)
         where sr_userid = mfguser
   no-lock: end.

   assign
      qad_charfld[1] = if available sr_wkfl then sr_site else so_site
      qad_charfld[2] = so_shipvia
      qad_charfld[3] = so_rmks
      so_shipvia     = w-so_shipvia
      so_bol         = w-so_bol
      so_rmks        = w-so_rmks.
end. /* track all bill of lading information */

if c-application-mode <> "API" then do:
   hide frame sotot.
   hide frame f.
end.
