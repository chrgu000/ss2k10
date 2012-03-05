/* rsporp.p - Release Management Supplier Schedules                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.14 $                                                   */
/*V8:ConvertMode=FullGUIReport                                            */
/* REVISION: 7.3      LAST MODIFIED: 12/10/92           BY: WUG *G462*    */
/* REVISION: 7.3      LAST MODIFIED: 01/16/95           by: srk *G0C1*    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 09/02/98   BY: *L08H* A. Shobha      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00 BY: *N0RT* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12  BY: Dan Herman DATE: 05/24/02 ECO: *P018* */
/* $Revision: 1.14 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SCHEDULED ORDER REPORT */

/* SS - 090115.1 By: Bill Jiang */

/*
{mfdtitle.i "2+ "}
*/
{xxmfdtitle.i "090115.1"}

/* SS - 090115.1 - B */
{xxrsporp0001.i}

define input parameter i_po_from like po_nbr.
define input parameter i_po_to like po_nbr.
define input parameter i_part_from like pod_part.
define input parameter i_part_to like pod_part.
define input parameter i_supplier_from like po_vend.
define input parameter i_supplier_to like po_vend.
define input parameter i_shipto_from like po_ship.
define input parameter i_shipto_to like po_ship.
define input parameter i_buyer_from like po_buyer.
define input parameter i_buyer_to like po_buyer.
/* SS - 090115.1 - E */

define new shared variable supplier_from like po_vend.
define new shared variable supplier_to like po_vend.
define new shared variable shipto_from like po_ship.
define new shared variable shipto_to like po_ship.
define new shared variable part_from like pod_part.
define new shared variable part_to like pod_part.
define new shared variable po_from like po_nbr.
define new shared variable po_to like po_nbr.
define new shared variable buyer_from like po_buyer.
define new shared variable buyer_to like po_buyer.
define new shared variable sortoption as integer
   label "Sort Option" format "9" initial 1.

define new shared variable sortextoption as character extent 3
   format "x(51)".

{pocnvars.i} /* Consignment variables */

sortextoption[1] = "1 - " + getTermLabel("BY",4) + " " +
                     getTermLabel("SHIP-TO",12) + ", " +
                     getTermLabel("SUPPLIER",12) + ", " +
                     getTermLabel("ITEM",8) + ", " +
                     getTermLabel("PURCHASE_ORDER",4).
sortextoption[2] = "2 - " + getTermLabel("BY",4) + " " +
                     getTermLabel("ITEM",8) + ", " +
                     getTermLabel("SHIP-TO",12) + ", " +
                     getTermLabel("SUPPLIER",12) + ", " +
                     getTermLabel("PURCHASE_ORDER",4).
sortextoption[3] = "3 - " + getTermLabel("BY",4) + " " +
                     getTermLabel("PURCHASE_ORDER",4) + ", " +
                     getTermLabel("ITEM",8).

form
   po_from          colon 16
   po_to            colon 46 label {t001.i}
   part_from        colon 16
   part_to          colon 46 label {t001.i}
   supplier_from    colon 16
   supplier_to      colon 46 label {t001.i}
   shipto_from      colon 16
   shipto_to        colon 46 label {t001.i}
   buyer_from       colon 16
   buyer_to     colon 46 label {t001.i}
   skip(1)
   sortoption           colon 16
   sortextoption[1]     at 26 no-label
   sortextoption[2]     at 26 no-label
   sortextoption[3]     at 26 no-label
   skip(1)
with frame a side-labels width 80 attr-space.

/* SS - 090115.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
ASSIGN
   po_from = i_po_from
   po_to = i_po_to
   part_from = i_part_from
   part_to = i_part_to
   supplier_from = i_supplier_from
   supplier_to = i_supplier_to
   shipto_from = i_shipto_from
   shipto_to = i_shipto_to
   buyer_from = i_buyer_from
   buyer_to = i_buyer_to
   .
/* SS - 090115.1 - E */

{wbrp01.i}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}

/* SS - 090115.1 - B */
/*
repeat:

   display sortextoption
   with frame a.
*/
/* SS - 090115.1 - E */

   if po_to = hi_char then po_to = "".
   if part_to = hi_char then part_to = "".
   if supplier_to = hi_char then supplier_to = "".
   if shipto_to = hi_char then shipto_to = "".
   if buyer_to = hi_char then buyer_to = "".
   /* SS - 090115.1 - B */
   /*
   if c-application-mode <> 'WEB' then
   update
      po_from
      po_to
      part_from
      part_to
      supplier_from
      supplier_to
      shipto_from
      shipto_to
      buyer_from
      buyer_to
      sortoption
   with frame a.
   {wbrp06.i &command = update
      &fields = " po_from po_to part_from part_to supplier_from
        supplier_to shipto_from shipto_to buyer_from
        buyer_to sortoption "
      &frm = "a"}
   */
   /* SS - 090115.1 - E */
   if c-application-mode <> 'WEB' or
      ( c-application-mode = 'WEB' and
      c-web-request begins 'DATA') then do:
      bcdparm = "".
      {mfquoter.i po_from     }
      {mfquoter.i po_to       }
      {mfquoter.i part_from   }
      {mfquoter.i part_to     }
      {mfquoter.i supplier_from}
      {mfquoter.i supplier_to }
      {mfquoter.i shipto_from }
      {mfquoter.i shipto_to   }
      {mfquoter.i buyer_from  }
      {mfquoter.i buyer_to    }
      {mfquoter.i sortoption  }

      if po_to = "" then po_to = hi_char.
      if part_to = "" then part_to = hi_char.
      if supplier_to = "" then supplier_to = hi_char.
      if shipto_to = "" then shipto_to = hi_char.
      if buyer_to = "" then buyer_to = hi_char.
   end.

   /* SS - 090115.1 - B */
   /*
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
      &printWidth = 80
      &pagedFlag = " "
      &stream = " "
      &appendToFile = " "
      &streamedOutputToTerminal = " "
      &withBatchOption = "yes"
      &displayStatementType = 1
      &withCancelMessage = "yes"
      &pageBottomMargin = 6
      &withEmail = "yes"
      &withWinprint = "yes"
      &defineVariables = "yes"}
   {mfphead2.i}
   */
   /* SS - 090115.1 - E */

   if sortoption = 1 then do:
      for each scx_ref no-lock
             where scx_ref.scx_domain = global_domain and  scx_type = 2
            and scx_shipfrom >= supplier_from and scx_shipfrom <= supplier_to
            and scx_shipto >= shipto_from and scx_shipto <= shipto_to
            and scx_part >= part_from and scx_part <= part_to
            and scx_po >= po_from and scx_po <= po_to,
            each pod_det no-lock
             where pod_det.pod_domain = global_domain and  pod_nbr = scx_order
             and pod_line = scx_line,
            each po_mstr no-lock
             where po_mstr.po_domain = global_domain and  po_nbr = pod_nbr
            and po_buyer >= buyer_from and po_buyer <= buyer_to
            break by scx_shipto by scx_shipfrom by scx_part by scx_po:

         /* SS - 090115.1 - B */
         /*
         {gprun.i ""rsporpa.p""
            "(input recid(scx_ref),
              input using_supplier_consignment)"}
         */
         {gprun.i ""xxrsporp0001a.p""
            "(input recid(scx_ref),
              input using_supplier_consignment)"}
         /* SS - 090115.1 - E */

         {mfrpchk.i}
      end.
   end.
   else
      if sortoption = 2 then do:
      for each scx_ref no-lock
             where scx_ref.scx_domain = global_domain and  scx_type = 2
            and scx_shipfrom >= supplier_from and scx_shipfrom <= supplier_to
            and scx_shipto >= shipto_from and scx_shipto <= shipto_to
            and scx_part >= part_from and scx_part <= part_to
            and scx_po >= po_from and scx_po <= po_to,
            each pod_det no-lock
             where pod_det.pod_domain = global_domain and  pod_nbr = scx_order
             and pod_line = scx_line,
            each po_mstr no-lock
             where po_mstr.po_domain = global_domain and  po_nbr = pod_nbr
            and po_buyer >= buyer_from and po_buyer <= buyer_to
            break by scx_part by scx_shipto by scx_shipfrom by scx_po:

         /* SS - 090115.1 - B */
         /*
         {gprun.i ""rsporpa.p""
            "(input recid(scx_ref),
              input using_supplier_consignment)"}
         */
         {gprun.i ""xxrsporp0001a.p""
            "(input recid(scx_ref),
              input using_supplier_consignment)"}
         /* SS - 090115.1 - E */

         {mfrpchk.i}
      end.
   end.
   else
      if sortoption = 3 then do:
      for each scx_ref no-lock
             where scx_ref.scx_domain = global_domain and  scx_type = 2
            and scx_shipfrom >= supplier_from and scx_shipfrom <= supplier_to
            and scx_shipto >= shipto_from and scx_shipto <= shipto_to
            and scx_part >= part_from and scx_part <= part_to
            and scx_po >= po_from and scx_po <= po_to,
            each pod_det no-lock
             where pod_det.pod_domain = global_domain and  pod_nbr = scx_order
             and pod_line = scx_line,
            each po_mstr no-lock
             where po_mstr.po_domain = global_domain and  po_nbr = pod_nbr
            and po_buyer >= buyer_from and po_buyer <= buyer_to
            break by scx_po by scx_part:

         /* SS - 090115.1 - B */
         /*
         {gprun.i ""rsporpa.p""
            "(input recid(scx_ref),
              input using_supplier_consignment)"}
         */
         {gprun.i ""xxrsporp0001a.p""
            "(input recid(scx_ref),
              input using_supplier_consignment)"}
         /* SS - 090115.1 - E */

         {mfrpchk.i}
      end.
   end.

   /* SS - 090115.1 - B */
   /*
   /* REPORT TRAILER */
   {mfrtrail.i}
end.
   */
   /* SS - 090115.1 - E */
{wbrp04.i &frame-spec=a}
