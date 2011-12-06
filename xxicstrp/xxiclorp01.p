/* xxiclorp01.p - LOCATION MASTER REPORT                                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                          */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 7.0      LAST MODIFIED: 01/30/92    BY: emb      *F114*          */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92    BY: emb      *F372*          */
/* REVISION: 8.5      LAST MODIFIED: 07/28/95    BY: bholmes  *J0FY*          */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96    BY: gym      *K02C*          */
/* REVISION: 8.6      LAST MODIFIED: 10/07/97    BY: mzv      *K0M8*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00    BY: *N0RF* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00    BY: *N0K2* Phil DeRogatis    */
/* Revision: 110705.1                      BY: ZY DATE: 07/05/11  ECO: *Y175* */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.14     BY: Jean Miller          DATE: 04/06/02  ECO: *P056*    */
/* $Revision: 1.15 $ BY: Patrick Rowan DATE: 05/24/02  ECO: *P018* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* Environment: Progress:9.1D   QAD:eb2sp12    Interface:Character            */
/*Y175  - 110705.1    ZY      *Y175*
  Purpose:做库位分组,以便统计库存状态报表,及确定备料库位
  Parameters:<none>
  Notes:借用loc_user1,loc_user2
  Change List:
        xxiclomt.p
        xxicstrp.p
*/
/* DISPLAY TITLE */
{mfdtitle.i "111205.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable site like ld_site.
define variable site1 like ld_site.
define variable loc like ld_loc.
define variable loc1 like ld_loc.
define variable w-ext-whl  like whl_mstr.whl_src_dest_id .
define variable w-ext-whl1 like whl_mstr.whl_src_dest_id.
define variable w-loc-site like loc_mstr.loc_site.
define variable disp-export-comment as character no-undo format "x(16)".
define variable disp-export-data    as character no-undo format "x(12)".

assign
   disp-export-comment = getTermLabel("EXPORT_COMMENTS",15) + ":"
   disp-export-data = getTermLabel("EXPORT_DATA",11) + ":".

/* SELECT FORM */
form
   site           colon 19
   site1          label "To" colon 49 skip
   loc            colon 19
   loc1           label "To" colon 49 skip
   w-ext-whl      label "External Warehouse" colon 19
   w-ext-whl1     label "To" colon 49 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

/* REPORT BLOCK */
{wbrp01.i}

repeat:

   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".
   if w-ext-whl1 = hi_char then w-ext-whl1 = "".

   if c-application-mode <> 'web' then
   update site site1 loc loc1
      w-ext-whl w-ext-whl1
   with frame a.

   {wbrp06.i &command = update &fields = "site site1 loc loc1 w-ext-whl
        w-ext-whl1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i site      }
      {mfquoter.i site1     }
      {mfquoter.i loc       }
      {mfquoter.i loc1      }
      {mfquoter.i w-ext-whl }
      {mfquoter.i w-ext-whl1}

      if site1 = "" then site1 = hi_char.
      if loc1 = "" then loc1 = hi_char.
      if w-ext-whl1 = "" then w-ext-whl1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 162
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

   {mfphead.i}

   form
      loc_site
      loc_loc
      loc_desc
      loc_type
/*Y175*/ loc_user1 column-label "GROUPS"
			loc_user2 column-label "ALLOCATION_LOCATION"
      loc_perm
      loc_single
      loc__qad01 column-label "Single!Lot"
      loc_cap
      loc_cap_um column-label "UM"
      loc_date
      loc_status
      is_avail
      is_nettable
      is_overissue
      loc_xfer_ownership column-label "Xfer"
   with frame b width 162 no-attr-space down.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame b:handle).

   form
      disp-export-data no-label at 1
      whl_mstr.whl_cust_exp at 19
      whl_mstr.whl_sup_exp            at 28
      whl_mstr.whl_rps_exp            at 37
      whl_mstr.whl_pt_exp             at 48
      whl_mstr.whl_um_exp             at 53
      whl_mstr.whl_cust_item_nbr_exp  at 57
      whl_mstr.whl_sup_item_nbr_exp   at 66 column-label "Supplier!Number"
      whl_mstr.whl_so_exp             at 75
      whl_mstr.whl_wo_exp             at 81
      whl_mstr.whl_po_exp             at 87
      whl_mstr.whl_do_exp             at 96
      whl_mstr.whl_do_req_exp         at 109 skip
   with frame c width 132 down no-attr-space no-box.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).

   form
      disp-export-comment no-label at 1
      whl_mstr.whl_so_cmt_exp no-label      at 75
      whl_mstr.whl_wo_cmt_exp no-label      at 81
      whl_mstr.whl_po_cmt_exp no-label      at 87
      whl_mstr.whl_do_cmt_exp no-label      at 96
      whl_mstr.whl_do_req_cmt_exp no-label  at 109
   with frame c2  width 132 no-attr-space overlay no-box.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c2:handle).

   form
      skip(1)
      whl_mstr.whl_src_dest_id   colon 20
      whl_mstr.whl_act           colon 20 skip
   with frame c3  side-labels no-attr-space overlay no-box.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c3:handle).

   w-loc-site = "".

   for each loc_mstr no-lock
      where loc_site >= site
      and loc_site <= site1
      and (loc_loc >= loc and loc_loc <= loc1),
      each si_mstr no-lock where si_site = loc_site,
      each is_mstr no-lock where is_status = loc_status
   break by loc_site by loc_loc
   with frame b width 162:

      find first whl_mstr where whl_site = loc_site
                            and whl_loc  = loc_loc
      no-lock no-error.

      if not available whl_mstr and w-ext-whl > "" then next.
      if not available whl_mstr and w-ext-whl1 <> hi_char then next.

      if available whl_mstr
      then do:
         if whl_src_dest_id < w-ext-whl
         or whl_src_dest_id > w-ext-whl1
         then
            next.
      end.

      if page-size - line-counter < 2 then page.

      if loc_site <> w-loc-site
      then do with frame b:

         w-loc-site = loc_site.

         display
            loc_site
            si_desc @ loc_desc.

         down 1.

         display
            loc_loc
            loc_desc
            loc_type
/*Y175*/    loc_user1
					  loc_user2
            loc_perm
            loc_single
            loc__qad01
            loc_cap
            loc_cap_um
            loc_date
            loc_status
            is_avail
            is_nettable
            is_overissue
            loc_xfer_ownership when (using_supplier_consignment).
      end.

      else do with frame b:
         display
            loc_loc
            loc_desc
            loc_type
/*Y175*/    loc_user1
					  loc_user2
            loc_perm
            loc_single
            loc__qad01
            loc_cap
            loc_cap_um
            loc_date
            loc_status
            is_avail
            is_nettable
            is_overissue
            loc_xfer_ownership when (using_supplier_consignment).
      end.

      if available whl_mstr
      then do:
         display
            whl_mstr.whl_act
            whl_mstr.whl_src_dest_id
         with frame c3.

         display
            disp-export-data
            whl_mstr.whl_cust_exp
            whl_mstr.whl_sup_exp
            whl_mstr.whl_rps_exp
            whl_mstr.whl_so_exp
            whl_mstr.whl_pt_exp
            whl_mstr.whl_um_exp
            whl_mstr.whl_cust_item_nbr_exp
            whl_mstr.whl_sup_item_nbr_exp
            whl_mstr.whl_wo_exp
            whl_mstr.whl_po_exp
            whl_mstr.whl_do_exp
            whl_mstr.whl_do_req_exp
         with frame c.

         display
            disp-export-comment
            whl_mstr.whl_so_cmt_exp
            whl_mstr.whl_wo_cmt_exp
            whl_mstr.whl_po_cmt_exp
            whl_mstr.whl_do_cmt_exp
            whl_mstr.whl_do_req_cmt_exp
         with frame c2.

      end.

      down 1.

      if last-of (loc_site) and page-size - line-counter > 1
         then down 1.

      {mfrpchk.i}

   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
