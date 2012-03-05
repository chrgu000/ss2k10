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
{mfdtitle.i "090115.1"}

/* SS - 090115.1 - B */
{xxrsporp0001.i "new"}
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
   /* SS - 090115.1 - B */
   /*
   sortoption           colon 16
   sortextoption[1]     at 26 no-label
   sortextoption[2]     at 26 no-label
   sortextoption[3]     at 26 no-label
   skip(1)
   */
   /* SS - 090115.1 - E */
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}

repeat:

   /* SS - 090115.1 - B */
   /*
   display sortextoption
   with frame a.
   */
   /* SS - 090115.1 - E */

   if po_to = hi_char then po_to = "".
   if part_to = hi_char then part_to = "".
   if supplier_to = hi_char then supplier_to = "".
   if shipto_to = hi_char then shipto_to = "".
   if buyer_to = hi_char then buyer_to = "".
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
      /* SS - 090115.1 - B */
      /*
      sortoption
      */
      /* SS - 090115.1 - E */
   with frame a.
   {wbrp06.i &command = update
      &fields = " po_from po_to part_from part_to supplier_from
        supplier_to shipto_from shipto_to buyer_from
        buyer_to 
      /* SS - 090115.1 - B */
      /*
      sortoption 
      */
      /* SS - 090115.1 - E */
      "
      &frm = "a"}
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
   /* SS - 090115.1 - B */
   /*
   {mfphead2.i}

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

         {gprun.i ""rsporpa.p""
            "(input recid(scx_ref),
              input using_supplier_consignment)"}

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

         {gprun.i ""rsporpa.p""
            "(input recid(scx_ref),
              input using_supplier_consignment)"}

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

         {gprun.i ""rsporpa.p""
            "(input recid(scx_ref),
              input using_supplier_consignment)"}

         {mfrpchk.i}
      end.
   end.

   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   EMPTY TEMP-TABLE ttxxrsporp0001.

   {gprun.i ""xxrsporp0001.p"" "(
      input po_from,
      input po_to,
      input part_from,
      input part_to,
      input supplier_from,
      input supplier_to,
      input shipto_from,
      input shipto_to,
      input buyer_from,
      input buyer_to
      )"}

   EXPORT DELIMITER ";" "scx_po" "scx_line" "scx_part" 
      /*
      "pod_vpart" "pod_um" 
      */
      "scx_shipfrom" "ad_name" "scx_shipto" "po_ap_acct" "po_ap_sub" "po_ap_cc" "po_shipvia" "po_taxable" "po_fob" "po_cr_terms" "po_buyer" "po_bill" "po_ship" "po_contact" "print_sch" "po_contract" "edi_sch" "fax_sch" "po_curr" "pocmmts" "po_site" "po_consignment" "impexp" "pod_pr_list" "pod_cst_up" "pod_pur_cost" "pod_acct" "pod_sub" "pod_cc" "pod_loc" "pod_taxable" "pod_um" "pod_um_conv" "pod_type" "pod_consignment" "pod_wo_lot" "pod_op" "subtype" "pod_firm_days" "pod_sd_pat" "pod_plan_days" "pod_plan_weeks" 
      "pod_cum_qty[1]" "pod_cum_qty[2]" "pod_cum_qty[3]" "pod_cum_qty[4]" 
      "pod_plan_mths" "pod_ord_mult" "pod_fab_days" 
      "pod_cum_date[1]" "pod_cum_date[2]" "pod_cum_date[3]" "pod_cum_date[4]" 
      "pod_raw_days" "podcmmts" "pod_sftylt_days" "pod_vpart" "pod_translt_days" 
      "pod_start_eff[1]" "pod_start_eff[2]" "pod_start_eff[3]" "pod_start_eff[4]" 
      "pod_end_eff[1]" "pod_end_eff[2]" "pod_end_eff[3]" "pod_end_eff[4]" 
      "pod_pkg_code".
   FOR EACH ttxxrsporp0001:
      EXPORT DELIMITER ";" ttxxrsporp0001.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {xxmfrtrail.i}
   /* SS - 090115.1 - E */
end.
{wbrp04.i &frame-spec=a}
