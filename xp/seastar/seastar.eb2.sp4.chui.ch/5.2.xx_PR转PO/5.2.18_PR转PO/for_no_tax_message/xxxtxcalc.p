/* txcalc.p - CALCULATE TAX FOR A TRANSACTION                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.7 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 7.3      CREATED:       12/07/92   By: bcm *G413*                */
/* Revision: 7.4      LAST MODIFIED: 06/22/93   By: wep *H010*                */
/*                                   09/27/93   By: bcm *H138*                */
/*                                   12/29/93   By: bcm *H270*                */
/*                                   12/09/93   By: dpm *H074*                */
/*                                   06/14/94   By: bcm *H383*                */
/*                                   09/08/94   By: bcm *H509*                */
/*                                   09/15/94   by: slm *GM62*                */
/*                                   09/20/94   by: bcm *H531*                */
/*                                   11/17/94   by: bcm *GO37*                */
/*                                   11/22/94   by: bcm *H606*                */
/*                                   03/29/95   by: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 12/01/95   BY: *J04C* Tom Vogten         */
/*                                   12/12/95   BY: *H0BJ* Sue Poland         */
/*                                   06/24/96   BY: *J0WF* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: *K01X* Jeff Wootton       */
/*                                   08/19/97   BY: *K0HJ* Jeff Wootton       */
/*                                   10/20/97   BY: *K0JV* Surendra Kumar     */
/* REVISION: 8.6      LAST MODIFIED: 04/22/98   BY: *J2D9* Sachin Shah        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Revision: 1.8.1.2      BY: Jean Miller         DATE: 04/10/02  ECO: *P058* */
/* Revision: 1.8.1.3      BY: Luke Pokic          DATE: 05/24/02  ECO: *P03Z* */
/* Revision: 1.8.1.4.1.1  BY: Samir Bavkar        DATE: 07/07/02  ECO: *P0B0* */
/* Revision: 1.8.1.5      BY: Tiziana Giustozzi   DATE: 07/24/02  ECO: *P09N* */
/* Revision: 1.8.1.6      BY: Robin McCarthy      DATE: 11/08/02  ECO: *P0JS* */
/* $Revision: 1.8.1.7 $   BY: Mercy Chittilapilly DATE: 12/23/02  ECO: *N212* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/***************************************************************************/
/*!
 *  txcalc.p    qad Calculate Tax For a Transaction
 *              receives the following parameters
 *  I/O     Name          Like            Description
 *  -----   -----------   --------------- ------------------------------
 *  input   tr_type       tx2d_tr_type    Transaction Type Code
 *  input   ref           tx2d_ref        Document Reference
 *  input   nbr           tx2d_nbr        Number (Related Document)
 *  input   line          tx2d_line       Line Number /* 0 = ALL */
 *
 *  input   vq-post       logical         Register Post flag
 *  output  result-status integer         Result Status
 *
 *  Each transaction type (SO,VO,...) will have its own control loop.  This is
 *  unfortunate, but necessary since the files are not standard, i.e., some
 *  contain trailers, some do not, names aren't always the same, etc.
 *
 *  Transaction types supported are:
 *  10  Sales Quote
 *  11  Sales Order
 *  12  Not being used
 *  13  Sales Order Shipment / Pending Invoice
 *  14  SO Shipper Maintenance
 *  15  Not being used
 *  16  AR Invoice
 *  18  AR Debit/Credit Memo
 *  19  AR Payment (Discount at Payment)
 *
 *  20  Purchase Order
 *  21  Purchase Order Receipt
 *  22  AP Voucher
 *  23  PO Receipts Relief (makes sure that sum 21, 22, 23 represents
 *              total taxes on purchases through vouchering )
 *  24  PO Shipper Maintenance
 *  25  PO Return to Supplier
 *  26  Logistics Accounting - PO Fiscal Receipts
 *  27  Logistics Accounting - PO Receipts Activities
 *  28  Logistics Accounting - PO Receipts Relief
 *  29  AP Payment Check (Discount at Payment)
 *  32  Recurring Voucher
 *
 *  33  Service Quote
 *  34  Service Contract
 *  35  Not being used
 *  36  Field Service RMA Issue & Receipt
 *  37  Return To Shipper Issue & Receipt
 *  38  Call Invoice
 *
 *  40  Logistics Accounting - Sales Quote Maintenance
 *  41  Logistics Accounting - Sales Order Maintenance
 *  42  Logistics Accounting - Distribution Order Maintenance
 *  43  Logistics Accounting - SO Shipment activities (Discrete, Pending Inv.
 *                                Shippers,RMA shipments)
 *  44  Not being used
 *  45  Logistics Accounting - Distribution Order Shipment
 *  46  Logistics Accounting - RMA Maintenance
 *  47  Not being used
 *  48  Logistics Accounting - Purchase Order Maintenance
 *
 */

{mfdeclre.i}

define input parameter tr_type   like tx2d_tr_type no-undo.
define input parameter ref       like tx2d_ref no-undo.
define input parameter nbr       like tx2d_nbr no-undo.
define input parameter line      like tx2d_line no-undo.

/* PLEASE DO NOT INTRODUCE ANYTHING HERE. THIS PROGRAM CALLS THE
 * INCLUDE FILE TXCALDEF.I WHICH IN TURN CALLS TXCALCIO.I. THE INPUT
 * PARAMETER VQ-POST AND THE OUTPUT PARAMETER RESULT-STATUS ARE
 * DEFINED IN TXCALCIO.I.
 * IF WE INTRODUCE ANYTHING BETWEEN THESE TWO LINES, THE ORDER IN
 * WHICH THE PARAMETERS ARE DEFINED WILL BE LOST.
 */
{txcaldef.i "NEW"}

define variable actual_tr_type like tx2d_tr_type no-undo.

if tr_type = "a1" /* GTM CONVERSION VARIATION OF "11" */
then
   assign actual_tr_type = "11".

else
if tr_type = "a3" /* GTM CONVERSION VARIATION OF "13" */
then
   assign actual_tr_type = "13".

else
   assign actual_tr_type = tr_type.

assign
   txc_tr_type = tr_type
   txc_ref     = ref
   txc_nbr     = nbr
   txc_line    = line.

/* IF VQ-POST IS YES, DO NOT DELETE THE TAX DETAIL RECORDS */
if not vq-post then do:

   /* DELETE ANY PREVIOUS DETAIL */
   for each tx2d_det exclusive-lock where tx2d_ref = ref and
         (tx2d_nbr = nbr or nbr = "*") and
         (tx2d_line = line or line = 0) and
          tx2d_tr_type = actual_tr_type:
      delete tx2d_det.
   end.
end. /* if not vq-post ... */

/* CALCULATION OF THE TAX LINE ITEMS IS HANDLED IN A SUBPROCEDURE FOR THE   */
/* SPECIFIC TR_TYPE.  ALL SUBPROCEDURES UTILIIZE TXCALCA.I FOR DETAIL CALC. */

/* FOR SALES QUOTE TRAILER PRINT         */
/* WITH SALES QUOTE (9) TRANSACTION TYPE */

if tr_type = "09"
then do transaction:

   /* CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc09.p""
      "(input vq-post,
        output result-status)"}

end. /* IF tr_type = "09" */

/* SALES QUOTE (10) TRANSACTION TYPE */
if (tr_type = "10") then do transaction:
   /* CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc10.p""
      "(input vq-post, output result-status)"}
end.
/* END SALES QUOTE SECTION */

else
/* SALES ORDER (11) OR PENDING INVOICE (13) TRANSACTION TYPE */
if (tr_type = "11" or tr_type = "13"
or (tr_type = "16" and vq-post)
or tr_type = "a1" /* GTM CONVERSION VARIATION OF "11" */
or tr_type = "a3" /* GTM CONVERSION VARIATION OF "13" */
) then do transaction:
   /* CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc11.p""
      "(input vq-post, output result-status)"}
end.
/* END SALES ORDER SECTION */

else
/* SALES ORDER SHIPPER (14) TRANSACTION TYPE */
if (tr_type = "14") then do transaction:
   /* CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc14.p""
      "(input vq-post, output result-status)"}
end.
/* END SALES ORDER SECTION */

else
/* AR INVOICE (16) TRANSACTION TYPE (USING INVOICE HISTORY) */
if (tr_type = "16") then do transaction:
   /* CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc16.p""
      "(input vq-post, output result-status)"}
end.

else
/* AR DR/CR MEMO (18) TRANSACTION TYPE */
if (tr_type = "18") then do transaction:
   /* CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc18.p""
      "(input vq-post, output result-status)"}
end.

else
/* AR PAYMENTS (19) TRANSACTION TYPE */
/**      if (tr_type = "19") then do transaction:
/* CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
{gprun.i ""txcalc19.p""}
end. **/

/* PURCHASE ORDER (20) TRANSACTION TYPE */
if (tr_type = "20") then do transaction:
   /* CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""xxxtxcalc20.p""
      "(input vq-post, output result-status)"}
end.
/* END PURCHASE ORDER SECTION */

else
/* PURCHASE ORDER RECEIPTS (21) AND RETURNS (25) TRANSACTION TYPE */
if (tr_type = "21") or (tr_type = "25") then do transaction:
   /* CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc21.p""
      "(input vq-post, output result-status)"}
end.
/* END PURCHASE ORDER RECEIPTS SECTION */

else
/* VOUCHER (22) TRANSACTION TYPE */
if (tr_type = "22"          or tr_type = "32") then do transaction:
   /* CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc22.p""
      "(input vq-post, output result-status)"}
end.

else
/* FISCAL RECEIVING  (24) TRANSACTION TYPE */
if (tr_type = "24") then do transaction:
   /* CALL PROCEDURE TO LOOP THROUGH FISCAL LINE ITEMS */
   {gprun.i ""txcalc24.p""
      "(input vq-post, output result-status)"}
end.
/* END FISCAL RECEIVING  SECTION */

else

/* LOGISTICS CHARGES FOR PO FISCAL RECEIVING (26) */
if tr_type = "26" then do transaction:
   /*CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   /* ADDED INPUT PARAM VQ-POST, OUTPUT PARAM RESULT-STATUS */
   {gprun.i ""txcalc26.p""
      "(input vq-post, output result-status)"}
end.
/* END LOGISTICS CHARGES FOR PURCHASE ORDERS (26) */

else

/* LOGISTICS CHARGES (27) */
if tr_type = "27" then do transaction:
   /*CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   /* ADDED INPUT PARAM VQ-POST, OUTPUT PARAM RESULT-STATUS */
   {gprunmo.i  &module = "LA" &program = "txcalc27.p"
               &param  = """(input vq-post,
                             output result-status)"""}
end.
/* END LOGISTICS CHARGES (27) */

else
/* SERVICE QUOTES (33) OR CONTRACTS (34) TRANSACTION TYPE */
if (tr_type = "33" or tr_type = "34") then do transaction:
   /*CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc33.p""
      "(input vq-post, output result-status)"}
end.
/* END SERVICE QOUTES (33) */

else
/* SERVICE BILLING (35) */
if (tr_type = "35" ) then do transaction:
   /* FORCE TXCALC35 TO CREATE INVOICE-TAX DETAIL */
   txc_tr_type = "13".
   /*CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc35.p""
      "(input vq-post, output result-status)"}
end.
/* END SERVICE BILLING (35) */

else
/* RMA ISSUES/RECEIPTS (36) *TVO* */
if (tr_type = "36" ) then do transaction:
   /*CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc36.p""
      "(input vq-post, output result-status)"}
end.
/* END RMA ISSUES/RECEIPTS (36) */

else
/* RTS ISSUES/RECEIPTS (37) */
if (tr_type = "37" ) then do transaction:
   /*CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   {gprun.i ""txcalc37.p""
      "(input vq-post, output result-status)"}
end.
/* END RTS ISSUES/RECIPTS (37) */

else
/* CALL INVOICES (38) */
if (tr_type = "38" ) then do transaction:
   /*CALL PROCEDURE TO LOOP THROUGH LINE ITEMS AND SFB_DET */
   /* ADDED INPUT PARAM VQ-POST, OUTPUT PARAM RESULT-STATUS */
   {gprun.i ""txcalc38.p""
      "(input vq-post, output result-status)"}
end.
/* END CALL INVOICES (38) */

else
/* LOGISTICS CHARGES WITH SALES QUOTES(40), SALES ORDER(41),  */
/*  DISTRIBUTION ORDER(42)  AND RMA MAINTENANCE (46)          */
if (tr_type = "40" or tr_type = "41" or tr_type = "42"
   or tr_type = "46") then do transaction:
   /*CALL PROCEDURE TO LOOP THROUGH LINE ITEMS AND SFB_DET */
   /* ADDED INPUT PARAM VQ-POST, OUTPUT PARAM RESULT-STATUS */
   {gprunmo.i  &module = "LA" &program = "txcalc41.p"
               &param  = """(input vq-post,
                             output result-status)"""}
end.
/* END - LOGISTICS CHARGES WITH SALES QUOTES(40), SALES ORDER(41),  */
/*       DISTRIBUTION ORDER(42)  AND RMA MAINTENANCE (46)          */

else
/* LOGISTICS CHARGES WITH SO SHIPMENTS(43) AND DIST ORDER SHIPMENTS(45) */
if (tr_type = "43" or tr_type = "45") then do transaction:
   /*CALL PROCEDURE TO LOOP THROUGH LINE ITEMS AND SFB_DET */
   /* ADDED INPUT PARAM VQ-POST, OUTPUT PARAM RESULT-STATUS */
   {gprunmo.i  &module = "LA" &program = "txcalc43.p"
               &param  = """(input vq-post,
                             output result-status)"""}
end.
/* END - LOGISTICS CHARGES WITH SO SHIPMENTS(43) AND DIST ORDER SHIPMENTS(45) */

else
/* LOGISTICS CHARGES FOR PURCHASE ORDERS (48) */
if tr_type = "48" then do transaction:
   /*CALL PROCEDURE TO LOOP THROUGH LINE ITEMS */
   /* ADDED INPUT PARAM VQ-POST, OUTPUT PARAM RESULT-STATUS */
   {gprun.i ""txcalc48.p""
      "(input vq-post, output result-status)"}
end.
/* END LOGISTICS CHARGES FOR PURCHASE ORDERS (48) */

/*CHECK IF THERE HAS BEEN AN ERROR. IF SO, REPORT TO THE USER */
if result-status <> 0 then do:
   if not vq-post then do:
      {pxmsg.i &MSGNUM=2013 &ERRORLEVEL=2}
      /* QUANTUM STATUS 160. UNEXPECTED RESULT IN TAX CALCULATIONS*/
   end. /* if not vq-post ... */
end. /* if result-status <> 0 ... */
