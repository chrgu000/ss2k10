/* apvoglu1.p - AP VOUCHER MAINTENANCE - UPDATE GL FOR COST ADJUSTMENT      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.4 $                             */
/* REVISION: 9.0         CREATED: 03/15/99   *M0BG*  Jeff Wootton           */
/* REVISION: 9.1         CREATED: 10/01/99   *N014*  Jeff Wootton           */
/* REVISION: 9.1   LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                 */
/* $Revision: 1.4 $ BY: Paul Donnelly DATE: 12/10/01  ECO: *N16J*  */

/*V8:ConvertMode=Maintenance                                                */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/****************************************************************************/

/****************************************************************************/
/* This program is run from the following programs:                         */
/*  Apvocsu1.p  AP Voucher Maintenance, Cost Updates (AP database)          */
/*              (p_database = "AP",  p_action = "ADD")                      */
/*  Apvocsua.p  AP Voucher Maintenance, Cost Updates (Inventory database)   */
/*              (p_database = "INV", p_action = "ADD")                      */
/*  Apvomtk1.p  AP Voucher Maintenance, Reverse Cost (AP database)          */
/*              (p_database = "AP",  p_action = "DEL")                      */
/*  Apvomtka.p  AP Voucher Maintenance, Reverse Cost (Inventory database)   */
/*              (p_database = "INV", p_action = "DEL")                      */
/****************************************************************************/

{mfdeclre.i}

{pxpgmmgr.i}

define input parameter p_database          as character.
define input parameter p_action            as character.
define input parameter p_ap_database       as character.
define input parameter p_ap_site           as character.
define input parameter p_inv_wip_site      as character.
define input parameter p_inv_wip_acct      as character.
define input parameter p_inv_wip_sub       as character.
define input parameter p_inv_wip_cc        as character.
define input parameter p_discr_acct        as character.
define input parameter p_discr_sub         as character.
define input parameter p_discr_cc          as character.
define input parameter p_project           as character.
define input parameter p_po_nbr            as character.
define input parameter p_vo_adj_amt        as decimal.
define input parameter p_vo_discr_amt      as decimal.
define input parameter p_conf_vo_adj_amt   as decimal.
define input parameter p_conf_vo_discr_amt as decimal.
define output parameter p_gl_ref           as character.

define variable l_ap_site_entity      like si_entity no-undo.
define variable l_inv_wip_site_db     like si_db     no-undo.
define variable l_inv_wip_site_entity like si_entity no-undo.
define variable l_gl_amt              like glt_amt no-undo.
define variable l_gl_ref              like glt_ref no-undo.
define variable l_eff_date            like glt_effdate no-undo
   initial today.

define variable ico_acct as character no-undo.
define variable ico_sub as character no-undo.
define variable ico_cc as character no-undo.

for first icc_ctrl
   fields(icc_gl_tran
   icc_gl_sum
   icc_mirror)
no-lock:
end.
if not available icc_ctrl
   or not icc_gl_tran
   /* IC GL TRANSACTIONS ARE NOT NEEDED ON THIS DATABASE */
   then return.

/* GET AP SITE MASTER */
for first si_mstr
   fields(si_entity)
   where si_site = p_ap_site
no-lock:
end.
if not available si_mstr
   then return.
assign
   l_ap_site_entity = si_entity.

/* GET INVENTORY/WIP SITE MASTER */
for first si_mstr
   fields(si_db
   si_entity)
   where si_site = p_inv_wip_site
no-lock:
end.
if not available si_mstr
   then return.
assign
   l_inv_wip_site_db = si_db
   l_inv_wip_site_entity = si_entity.

/* IF CONFIRMED ADJUSTMENT NOT SAME AS VOUCHER ADJUSTMENT      */
/* OR CONFIRMED DISCREPANCY NOT SAME AS VOUCHER DISCREPANCY    */
/* OR INVENTORY/WIP SITE ENTITY NOT SAME AS AP SITE ENTITY     */
/* OR INVENTORY/WIP SITE DATABASE NOT SAME AS AP DATABASE      */
/*    RUN GPICGL.P TO TRANSFER AMOUNTS FROM AP SITE ENTITY     */
/*    TO INVENTORY/WIP ENTITY.                                 */
/*    THIS OCCURS IN 2 SEPARATE EXECUTIONS:                    */
/*      1. ON INVENTORY DATABASE                               */
/*      2. ON PO/AP DATABASE                                   */

if p_conf_vo_adj_amt = p_vo_adj_amt
   and p_conf_vo_discr_amt = p_vo_discr_amt
   and l_inv_wip_site_entity = l_ap_site_entity
   and l_inv_wip_site_db = p_ap_database
   then return.

if p_database = "INV"
   /* RUNNING ON INVENTORY DATABASE */
then do:

   if l_inv_wip_site_entity = l_ap_site_entity
      and l_inv_wip_site_db = p_ap_database
      /* TRANSACTION IS ALL WITHIN A SINGLE DATABASE */
   then do:
      l_gl_amt = (if p_action = "DEL"
         then
      - (p_vo_adj_amt - p_conf_vo_adj_amt)
      else   (p_vo_adj_amt - p_conf_vo_adj_amt)).
      /* DR DISCREPANCY, CR INVENTORY/WIP */

      {gprun.i ""gpicgl.p""
         "(input l_gl_amt,
           input ""CST-ADJ"",
           input p_po_nbr,
           input p_discr_acct,
           input p_discr_sub,
           input p_discr_cc,
           input p_project,
           input p_inv_wip_acct,
           input p_inv_wip_sub,
           input p_inv_wip_cc,
           input p_project,
           input l_inv_wip_site_entity,
           input l_eff_date,
           input icc_gl_sum,
           input icc_mirror,
           input-output l_gl_ref,
           input ?,
           input ?
           )"}
      p_gl_ref = l_gl_ref.
   end. /* SINGLE DATABASE */

   else do: /* MULTI-DATABASE */

      if p_conf_vo_adj_amt <> 0
         /* MOVE CONFIRMED VOUCHER COST ADJUSTMENT FROM PO/AP DATABASE */
      then do:
         l_gl_amt = (if p_action = "DEL"
            then
         - p_conf_vo_adj_amt
         else   p_conf_vo_adj_amt).
         /* DR INVENTORY/WIP, CR INTERCOMPANY */
         {glenacex.i &entity=l_inv_wip_site_entity
                     &type='"CR"'
                     &module='"IC"'
                     &acct=ico_acct
                     &sub=ico_sub
                     &cc=ico_cc }

         {gprun.i ""gpicgl.p""
            "(input l_gl_amt,
              input ""CST-ADJ"",
              input p_po_nbr,
              input p_inv_wip_acct,
              input p_inv_wip_sub,
              input p_inv_wip_cc,
              input p_project,
              input ico_acct,
              input ico_sub,
              input ico_cc,
              input p_project,
              input l_inv_wip_site_entity,
              input l_eff_date,
              input icc_gl_sum,
              input icc_mirror,
              input-output l_gl_ref,
              input ?,
              input ?
              )"}
         p_gl_ref = l_gl_ref.
      end.

      if p_conf_vo_discr_amt <> 0
         /* MOVE CONFIRMED VOUCHER DISCREPANCY FROM PO/AP DATABASE */
      then do:
         l_gl_amt = (if p_action = "DEL"
            then
         - p_conf_vo_discr_amt
         else   p_conf_vo_discr_amt).
         /* DR DISCREPANCY, CR INTERCOMPANY */

         {gprun.i ""gpicgl.p""
            "(input l_gl_amt,
              input ""CST-ADJ"",
              input p_po_nbr,
              input p_discr_acct,
              input p_discr_sub,
              input p_discr_cc,
              input p_project,
              input ico_acct,
              input ico_sub,
              input ico_cc,
              input p_project,
              input l_inv_wip_site_entity,
              input l_eff_date,
              input icc_gl_sum,
              input icc_mirror,
              input-output l_gl_ref,
              input ?,
              input ?
              )"}
      end.

   end. /* MULTI-DATABASE */

end. /* RUNNING ON INVENTORY DATABASE */

else
if p_database = "AP"
   /* RUNNING ON PO/AP DATABASE */
then do:

   if l_inv_wip_site_entity = l_ap_site_entity
      and l_inv_wip_site_db = p_ap_database
      /* TRANSACTION IS ALL WITHIN A SINGLE DATABASE */
   then do:
   end. /* SINGLE DATABASE */

   else do: /* MULTI-DATABASE */

      if p_vo_adj_amt <> 0
         /* MOVE VOUCHER COST ADJUSTMENT TO INVENTORY DATABASE */
      then do:
         l_gl_amt = (if p_action = "DEL"
            then
         - p_vo_adj_amt
         else   p_vo_adj_amt).
         /* DR INTERCOMPANY, CR INVENTORY/WIP */
         {glenacex.i &entity=l_ap_site_entity
                     &type='"DR"'
                     &module='"IC"'
                     &acct=ico_acct
                     &sub=ico_sub
                     &cc=ico_cc }
         {gprun.i ""gpicgl.p""
            "(input l_gl_amt,
              input ""CST-ADJ"",
              input p_po_nbr,
              input ico_acct,
              input ico_sub,
              input ico_cc,
              input p_project,
              input p_inv_wip_acct,
              input p_inv_wip_sub,
              input p_inv_wip_cc,
              input p_project,
              input l_ap_site_entity,
              input l_eff_date,
              input icc_gl_sum,
              input icc_mirror,
              input-output l_gl_ref,
              input ?,
              input ?
              )"}
         p_gl_ref = l_gl_ref.
      end.

      if p_vo_discr_amt <> 0
         /* MOVE VOUCHER DISCREPANCY TO INVENTORY DATABASE */
      then do:
         l_gl_amt = (if p_action = "DEL"
            then
         - p_vo_discr_amt
         else   p_vo_discr_amt).
         /* DR INTERCOMPANY, CR DISCREPANCY */

         {gprun.i ""gpicgl.p""
            "(input l_gl_amt,
              input ""CST-ADJ"",
              input p_po_nbr,
              input ico_acct,
              input ico_sub,
              input ico_cc,
              input p_project,
              input p_discr_acct,
              input p_discr_sub,
              input p_discr_cc,
              input p_project,
              input l_ap_site_entity,
              input l_eff_date,
              input icc_gl_sum,
              input icc_mirror,
              input-output l_gl_ref,
              input ?,
              input ?
              )"}
      end.

   end. /* MULTI-DATABASE */

end. /* RUNNING ON PO/AP DATABASE */
