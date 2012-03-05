/* rsrp01.p - Release Management Supplier Schedules                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*V8:ConvertMode=Report                                             */
/* REVISION: 7.0      LAST MODIFIED: 01/29/92         BY: WUG *F110*         */
/* Revision: 7.3      LAST MODIFIED: 11/19/9          By: jcd *G348*         */
/* REVISION: 7.3      LAST MODIFIED: 12/10/92         BY: WUG *G462*         */
/* REVISION: 7.3      LAST MODIFIED: 01/16/95         by: srk *G0C1*         */
/* REVISION: 7.3      LAST MODIFIED: 04/21/97         BY: *G2MD* Aruna Patil */
/* REVISION: 7.3      LAST MODIFIED: 10/08/97         BY: GYK *K0MZ*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 12/01/98   BY: *K1QY* Pat McCormick     */
/* REVISION: 9.0      LAST MODIFIED: 02/06/99   BY: *M06R* Doug Norton       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00   BY: *N0RT* Mudit Mehta       */
/* $Revision: 1.15 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.15 $ BY: Bill Jiang DATE: 08/07/08 ECO: *SS - 20080807.1* */
/*-Revision end---------------------------------------------------------------*/


/* SCHEDULE REPORT */

/* SS - 20080807.1 - B */
/*
{mfdtitle.i "2+ "}
*/
{ssmfdtitle.i "2+ "}

{ssrsrp010001.i}

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
define input parameter i_date_from as date.
define input parameter i_date_to as date.
define input parameter i_current_ind like mfc_logical.
/* SS - 20080807.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

/*N0RT***********BEGIN COMMENTING*************
 * &SCOPED-DEFINE rsrp01_p_1 "3 - By PO, Item"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE rsrp01_p_2 "1 - By Ship-to, Supplier, Item, PO"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE rsrp01_p_3 "2 - By Item, Ship-to, Supplier, PO"
 * /* MaxLen: Comment: */
 *N0RT***********END COMMENTING************* */

&SCOPED-DEFINE rsrp01_p_4 "Active/Hist"
/* MaxLen: Comment: */

&SCOPED-DEFINE rsrp01_p_5 "Created"
/* MaxLen: Comment: */

&SCOPED-DEFINE rsrp01_p_6 "Sort Option"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K0MZ*/ define new shared variable supplier_from like po_vend.
/*K0MZ*/ define new shared variable supplier_to like po_vend.
/*K0MZ*/ define new shared variable shipto_from like po_ship.
/*K0MZ*/ define new shared variable shipto_to like po_ship.
/*K0MZ*/ define new shared variable part_from like pod_part.
/*K0MZ*/ define new shared variable part_to like pod_part.
/*K0MZ*/ define new shared variable po_from like po_nbr.
/*K0MZ*/ define new shared variable po_to like po_nbr.
/*K0MZ*/ define new shared variable buyer_from like po_buyer.
/*K0MZ*/ define new shared variable buyer_to like po_buyer.
/*K0MZ*/ define new shared variable date_from as date label {&rsrp01_p_5}.
/*K0MZ*/ define new shared variable date_to as date.
/*K1QY*/ define variable ship_sch_active like mfc_logical initial no no-undo.
/*K1QY*/ define new shared variable schtype like sch_type initial 4.
/*K1QY*/ define variable sch_type_desc as character format "x(24)" no-undo.
/*K1QY*/ define variable sch_type_numonic as character format "x(8)" no-undo.
/*K0MZ*/ define variable current_ind like mfc_logical label {&rsrp01_p_4}
                                     format {&rsrp01_p_4} initial yes.
/*K0MZ*/ define new shared variable sortoption as integer
                                    label {&rsrp01_p_6} format "9" initial 1.
/*N0RT*
 * /*K0MZ*/ define new shared variable sortextoption as character extent 3
 *                                  format "x(34)"
 *                                  init [
 *                                  {&rsrp01_p_2},
 *                                  {&rsrp01_p_3},
 *                                  {&rsrp01_p_1}].
 *N0RT*/
/*N0RT*/ define new shared variable sortextoption as character extent 3
                                                  format "x(34)".

/*K1QY** /*K0MZ*/ define variable schtype as integer init 1.  */

/*N0RT************* SET INITIAL VALUES ************* */
/*N0RT*/  sortextoption[1] = "1 - " + getTermLabel("BY",2) + " " +
                             getTermLabel("SHIP-TO",7) + ", " +
                             getTermLabel("SUPPLIER",8) + ", " +
                             getTermLabel("ITEM",4) + ", " +
                             getTermLabel("PURCHASE_ORDER",2).
/*N0RT*/  sortextoption[2] = "2 - " + getTermLabel("BY",2) + " " +
                             getTermLabel("ITEM",4) + ", " +
                             getTermLabel("SHIP-TO",7) + ", " +
                             getTermLabel("SUPPLIER",8) + ", " +
                             getTermLabel("PURCHASE_ORDER",2).
/*N0RT*/  sortextoption[3] = "3 - " + getTermLabel("BY",2) + " " +
                             getTermLabel("PURCHASE_ORDER",2) + ", " +
                             getTermLabel("ITEM",4).

         form
            po_from              colon 20
            po_to                colon 50 label {t001.i}
            part_from            colon 20
            part_to              colon 50 label {t001.i}
            supplier_from        colon 20
            supplier_to          colon 50 label {t001.i}
            shipto_from          colon 20
            shipto_to            colon 50 label {t001.i}
            buyer_from           colon 20
            buyer_to             colon 50 label {t001.i}
            date_from            colon 20
            date_to              colon 50 label {t001.i}
            skip(1)
/*K1QY*/    schtype        colon 20
/*K1QY*/    space (3)
            sch_type_desc no-label
            current_ind          colon 20
            sortoption           colon 20
            sortextoption[1]     at 30 no-label
            sortextoption[2]     at 30 no-label
            sortextoption[3]     at 30 no-label
            skip(1)
         with frame a side-labels width 80 attr-space.

/* SS - 20080807.1 - B */
/*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).
*/
po_from = i_po_from.
po_to = i_po_to.
part_from = i_part_from.
part_to = i_part_to.
supplier_from = i_supplier_from.
supplier_to = i_supplier_to.
shipto_from = i_shipto_from.
shipto_to = i_shipto_to.
buyer_from = i_buyer_from.
buyer_to = i_buyer_to.
date_from = i_date_from.
date_to = i_date_to.
current_ind = i_current_ind.
/* SS - 20080807.1 - E */

/*G0C1*   repeat with frame a: */
/*G0C1*/
/*K0MZ*/ {wbrp01.i}

/* SS - 20080807.1 - B */
/*
repeat:
/*K0MZ*
   disp sortextoption
/*G0C1*/ with frame a.
*/
/*K0MZ*/ display sortextoption with frame a.
*/
/* SS - 20080807.1 - E */
   if po_to = hi_char then po_to = "".
   if part_to = hi_char then part_to = "".
   if supplier_to = hi_char then supplier_to = "".
   if shipto_to = hi_char then shipto_to = "".
   if buyer_to = hi_char then buyer_to = "".

/*G2MD**   if date_from = 01/01/1960 then date_from = ?. */
/*G2MD**   if date_to = 12/31/2100 then date_to = ?.     */

/*G2MD*/ if date_from = low_date then date_from = ?.
/*G2MD*/ if date_to = hi_date then date_to = ?.

/* SS - 20080807.1 - B */
/*
/*K1QY*/    /* CHECK FLAG TO SEE IF MODULE IS TURNED ON */
/*K1QY*/    if can-find (first mfc_ctrl  where mfc_ctrl.mfc_domain =
global_domain and
/*K1QY*/       mfc_field = "enable_shipping_schedules"
/*K1QY*/       and mfc_seq = 4 and mfc_module = "ADG"
/*K1QY*/       and mfc_logical = yes)
/*K1QY*/       then do:
/*K1QY*/                ship_sch_active = yes.
/*K1QY*/                schtype = 5.
/*K1QY*/       end. /* do */
/*K1QY*/     {gplngn2a.i
              &file     = ""sch_mstr""
              &field    = ""sch_type""
              &code     = string(schtype)
              &mnemonic = sch_type_numonic
              &label    = sch_type_desc}
/*K1QY*/      if not available lngd_det then
/*K1QY*/        {mfmsg.i 4211 3} /* Invalid Type */
/*K1QY*/      else
/*K1QY*/        display sch_type_desc
/*K1QY*/                schtype with frame a.
/*K0MZ*/ if c-application-mode <> 'WEB':U then
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
      date_from
      date_to
/*K1QY*/ schtype when (ship_sch_active)
      current_ind
      sortoption
/*G0C1*/ with frame a.

/*K0MZ*/ {wbrp06.i &command = update &fields = "  po_from po_to part_from
part_to supplier_from supplier_to shipto_from shipto_to buyer_from buyer_to
date_from date_to schtype current_ind sortoption " &frm = "a"}

/*K1QY**  get translation text from code  */
/*K1QY*/     {gplngn2a.i
              &file     = ""sch_mstr""
              &field    = ""sch_type""
              &code     = string(schtype)
              &mnemonic = sch_type_numonic
              &label    = sch_type_desc}
/*K1QY*/      if not available lngd_det then do:
/*K1QY*/        {mfmsg.i 4211 3} /* Invalid Type */
/*K1QY*/      if (c-application-mode = 'WEB':U) then
/*K1QY*/        return.
/*K1QY*/      else
/*K1QY*/        undo, retry.
/*K1QY*/      end. /* do */
/*K1QY*/      else do:
/*K1QY*/        assign sch_type_desc = lngd_translation.
/*K1QY*/        display sch_type_desc with frame a.
/*K1QY*/      end. /* else do */
/*K1QY*/      if can-find (first mfc_ctrl  where mfc_ctrl.mfc_domain =
global_domain and
/*K1QY*/         mfc_field = "enable_shipping_schedules"
/*K1QY*/         and mfc_seq = 4 and mfc_module = "ADG"
/*K1QY*/         and mfc_logical = yes)
/*K1QY*/         then do:
/*K1QY*/         if schtype = 4
/*K1QY*/            then do:
/*K1QY*/               {mfmsg.i 4377 3}. /* PRO/PLUS Supplier Schedules in use */
/*K1QY*/           if (c-application-mode = 'WEB':U) then
/*K1QY*/               return.
/*K1QY*/           else
/*K1QY*/              undo, retry.
/*K1QY*/           end. /* do */
/*K1QY*/         end. /* do */

/*K1QY**
 * /*K0MZ*/ if (c-application-mode <> 'web':u) or
 * /*K0MZ*/ (c-application-mode = 'web':u and
 * /*K0MZ*/ (c-web-request begins 'data':u)) then do:
 *K1QY**/
*/
/* SS - 20080807.1 - E */

/*K1QY*/ if (c-application-mode <> 'WEB':U) or
/*K1QY*/ (c-application-mode = 'WEB':U and
/*K1QY*/ (c-web-request begins 'data':U)) then do:


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
   {mfquoter.i date_from   }
   {mfquoter.i date_to     }
/*K1QY*/ {mfquoter.i schtype }
   {mfquoter.i current_ind}
   {mfquoter.i sortoption  }

   if po_to = "" then po_to = hi_char.
   if part_to = "" then part_to = hi_char.
   if supplier_to = "" then supplier_to = hi_char.
   if shipto_to = "" then shipto_to = hi_char.
   if buyer_to = "" then buyer_to = hi_char.
/*G2MD**   if date_from = ? then date_from = 01/01/1960. */
/*G2MD**   if date_to = ? then date_to = 12/31/2100.     */

/*G2MD*/ if date_from = ? then date_from = low_date.
/*G2MD*/ if date_to = ? then date_to = hi_date.



/*K0MZ*/ end.
/* SS - 20080807.1 - B */
/*
   /* SELECT PRINTER */
   {mfselbpr.i "printer" 80}
   {mfphead2.i}
/*K1QY*/ run run_report_procedure.

   /* REPORT TRAILER */
   {mfrtrail.i}
end.
*/
/*K1QY*/ run run_report_procedure.
/* SS - 20080807.1 - E */

/*K0MZ*/ {wbrp04.i &frame-spec = a}

/*K1QY*/ PROCEDURE run_report_procedure:
   if sortoption = 1 then do:
      for each scx_ref no-lock
       where scx_ref.scx_domain = global_domain and  scx_type = 2
      and scx_shipfrom >= supplier_from and scx_shipfrom <= supplier_to
      and scx_shipto >= shipto_from and scx_shipto <= shipto_to
      and scx_part >= part_from and scx_part <= part_to
      and scx_po >= po_from and scx_po <= po_to,
      each pod_det no-lock
       where pod_det.pod_domain = global_domain and  pod_nbr = scx_order and
       pod_line = scx_line,
      each po_mstr no-lock
       where po_mstr.po_domain = global_domain and  po_nbr = pod_nbr
      and po_buyer >= buyer_from and po_buyer <= buyer_to
      break by scx_shipto by scx_shipfrom by scx_part by scx_po:
         {mfrpchk.i}                     /*G348*/
         /* SS - 20080807.1 - B */
         /*
         {rsrp01.i}
         */
         {ssrsrp010001a.i}
         /* SS - 20080807.1 - E */
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
       where pod_det.pod_domain = global_domain and  pod_nbr = scx_order and
       pod_line = scx_line,
      each po_mstr no-lock
       where po_mstr.po_domain = global_domain and  po_nbr = pod_nbr
      and po_buyer >= buyer_from and po_buyer <= buyer_to
      break by scx_part by scx_shipto by scx_shipfrom by scx_po:
         {mfrpchk.i}                     /*G348*/
         /* SS - 20080807.1 - B */
         /*
         {rsrp01.i}
         */
         {ssrsrp010001a.i}
         /* SS - 20080807.1 - E */
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
       where pod_det.pod_domain = global_domain and  pod_nbr = scx_order and
       pod_line = scx_line,
      each po_mstr no-lock
       where po_mstr.po_domain = global_domain and  po_nbr = pod_nbr
      and po_buyer >= buyer_from and po_buyer <= buyer_to
      break by scx_po by scx_part:
         {mfrpchk.i}                     /*G348*/
         /* SS - 20080807.1 - B */
         /*
         {rsrp01.i}
         */
         {ssrsrp010001a.i}
         /* SS - 20080807.1 - E */
      end.
   end.
/*K1QY*/ END PROCEDURE.
