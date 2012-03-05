/* spmrpexa.p - OPERATIONS PLANNING MRP EXPLOSION                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.18 $                                                              */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 8.5      LAST MODIFIED: 09/22/95   BY:  amw   *J078*            */
/* REVISION: 8.5      LAST MODIFIED: 06/19/96   BY:  rvw   *G1XY*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/08/98   BY: *J31K* Jean Miller       */
/* REVISION: 9.0      LAST MODIFIED: 01/21/99   BY: *M066* Patti Gaultney    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 06/01/99   BY: *J3GL* G.Latha           */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/29/00   BY: *N0PN* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 09/30/00   BY: *L0Y1* Kirti Desai       */
/* Revision: 1.17     BY: Irine D'Mello   DATE: 09/10/01 ECO: *M164*         */
/* $Revision: 1.18 $    BY: Rajesh Thomas   DATE: 10/12/01 ECO: *M1JL*      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{pxmaint.i}

{pxphdef.i wocmnrtn}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE spmrpexa_p_2 "Database"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter dbase     like global_db no-undo.
define input parameter ptrecno   as recid       no-undo.
define input parameter st        like si_site   no-undo.
define input parameter pt        like pt_part   no-undo.
define input parameter prod_fcst as decimal     no-undo.

define new shared variable know_date     as   date no-undo.
define new shared variable find_date     as   date no-undo.
define new shared variable interval      as   integer no-undo.
define new shared variable comp          like ps_comp .
define new shared variable qty           like wo_qty_ord .
define new shared variable eff_date      as   date.
define new shared variable wo_recno      as   recid.
define new shared variable leadtime      like pt_mfg_lead.
define new shared variable prev_status   like wo_status.
define new shared variable prev_release  like wo_rel_date.
define new shared variable prev_due      like wo_due_date.
define new shared variable prev_qty      like wo_qty_ord.
define new shared variable any_issued    like mfc_logical.
define new shared variable any_feedbk    like mfc_logical.
define new shared variable undo_all      like mfc_logical no-undo.
define new shared variable critical-part like wod_part no-undo.
define new shared variable prev_site     like wo_site.
define new shared variable joint_type    like wo_joint_type.
define new shared variable del-yn        like mfc_logical.
define new shared variable deliv         like wod_deliver.
define new shared variable due_date      like wo_due_date.
define new shared variable del-joint     like mfc_logical.

define shared variable fp3_recno    as   recid no-undo.
define shared variable dates        like mfc_date extent 52 no-undo.
define shared variable approve_flag as   character no-undo.
define shared variable wolot        like wo_lot no-undo.
define shared variable regen_wo     like mfc_logical.
define shared variable i            as   integer no-undo.

define variable frwrd      as   integer     no-undo.
define variable old_db     like global_db   no-undo.
define variable switch     like mfc_logical no-undo.
define variable glx_mthd   like cs_method   no-undo.
define variable glx_set    like cs_set      no-undo.
define variable cur_mthd   like cs_method   no-undo.
define variable cur_set    like cs_set      no-undo.
define variable prev_mthd  like cs_method   no-undo.
define variable m          as   integer     no-undo.
define variable del_wo     as   logical     no-undo.
define variable new_wo     as   logical     no-undo.
define variable joint_prod as   logical     no-undo.
define variable l_errorno  as   integer     no-undo.
define variable l_pmcode   like pt_pm_code  no-undo.

define shared frame c.
form
   dbase column-label {&spmrpexa_p_2}
   wo_site
   wo_nbr
   wo_lot
   wo_part
   pt_desc1
   wo_qty_ord
   wo_due_date
   wo_rel_date
   wo_status
with frame c down width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/* IF WORK ORDER ALREADY EXISTS, FIND IT. */
if wolot <> ""
then
   find wo_mstr
      where wo_lot = wolot
      exclusive-lock no-error.

find pt_mstr where pt_part = pt no-lock no-error.
if not available pt_mstr
then do:
   /* ITEM DOES NOT EXIST IN ITEM MASTER */
   {pxmsg.i &MSGNUM=7179 &ERRORLEVEL=4}
   return.
end. /* NOT AVAILABLE pt_mstr */

assign
   approve_flag = "0"
   new_wo       = no
   del_wo       = no.

if available wo_mstr
then do:
   /* DO NOTHING TO NON-FIRMED ORDERS AND FLIP APPROVE FLAG FOR THAT PERIOD */
   if (wo_status <> "F" and
       wo_status <> "B")
   then
      return.

   wo_recno = recid(wo_mstr).

   /* DELETE FIRMED WORK ORDER IF QTY IS CHANGED TO ZERO */
   if prod_fcst = 0
   then do:
      {gprun.i ""wowomte.p""}
      del_wo = yes.
   end.
   else do:
      display
         dbase
         wo_site
         wo_lot
         wo_nbr
         wo_part
         pt_desc1
         wo_qty_ord
         wo_due_date
         wo_rel_date
         wo_status
      with frame c.
      down 1 with frame c.
   end.
end.  /* IF AVAILBLE wo_mstr */

/* CREATE WORK ORDER IF IT DOES NOT EXIST AND THERE IS A NEED FOR  *
* IT, OR THE QUANTITY CHANGED TO A VALUE GREATER THAN ZERO.       */

if not available wo_mstr and
   prod_fcst <> 0
then do:

   /* CHECKING FOR JOIN PRODUCT ITEM */
   joint_prod = no.
   find ptp_det
      where ptp_part = pt
      and   ptp_site = st
      no-lock no-error.

   if available ptp_det
   then do:

      if ((ptp_pm_code    = "" or
           ptp_pm_code    = "M" or
           ptp_pm_code    = "L") and
          (ptp_joint_type = "1" or
           ptp_joint_type = "5"))
      then
         joint_prod = yes.
   end.
   else do:

      if ((pt_pm_code    = "" or
           pt_pm_code    = "M" or
           pt_pm_code    = "L") and
         ( pt_joint_type = "1" or
           pt_joint_type = "5"))
      then
         joint_prod = yes.
   end.

   create wo_mstr.
   assign
      new_wo        = yes
      wo_rmks       = getTermLabel("OPERATIONS_PLANNING",40)
      wo_part       = pt
      wo_ord_date   = today
      wo_site       = st
      wo_qty_ord    = prod_fcst
      wo_status     = (if joint_prod then "B" else "F")
      wo_joint_type = (if available ptp_det
                       then
                          ptp_joint_type
                       else
                          pt_joint_type)
      wo_due_date   = dates[i].

   /* GET NEXT LOT NUMBER */
   {mfnxtsq.i wo_mstr wo_lot woc_sq01 wo_lot}
   {mfnctrl.i woc_ctrl woc_nbr wo_mstr wo_nbr wo_nbr}

   if recid(wo_mstr) = -1 then .

   assign
      wolot    = wo_lot
      wo_recno = recid(wo_mstr).

   /*DETERMINE COSTING METHOD*/
   {gprun.i ""csavg01.p"" "(wo_part,
                            wo_site,
                            output glx_set,
                            output glx_mthd,
                            output cur_set,
                            output cur_mthd)"
   }

   /* IF AVERAGE COSTING THEN NO VARIANCE ALLOWED */
   if glx_mthd = "AVG"
   then
      wo_var = no.

   /* SETUP DEFAULT ACCOUNTS */

   /* ASSIGN DEFAULT RECEIPT STATUS AND ACTIVE FLAG */
   {pxrun.i &PROC    = 'get_default_wo_rctstat'
            &PROGRAM = 'wocmnrtn.p'
            &HANDLE  = ph_wocmnrtn
            &PARAM   = "( input  wo_part,
                          input  wo_site,
                          output wo_rctstat,
                          output wo_rctstat_active,
                          output l_errorno )" }

   /* ASSIGN DEFAULT VARIANCE ACCOUNT CODE AND COST CENTER. */
   run assign_default_wo_acct(buffer wo_mstr,
                              input  pt_prod_line).

end. /* IF NOT AVAILABLE WO_MSTR */

/* ONLY MODIFY IF NEW WORK ORDER, THE PRODUCTION QTY CHANGED, OR *
* REGENERATE PLANNED ORDER FLAG IS SET TO "YES"                 */
if available wo_mstr and
   (new_wo or
    regen_wo or
   (prod_fcst <> wo_qty_ord))
then do:
   if prod_fcst <> wo_qty_ord
   then
      assign
         wo_ord_date = today
         wo_qty_ord  = prod_fcst
         wo_due_date = dates[i].

   leadtime = pt_mfg_lead.

   /* FOR PURCHASED ITEMS CONSIDER PURCHASE LT WHILE CREATING WO */

   if pt_pm_code = "P"
   then
      assign
         leadtime = pt_pur_lead
         l_pmcode = "P".

   if new_wo or
      regen_wo
   then
      assign
         wo_bom_code = pt_bom_code
         wo_routing  = pt_routing.

   /* ASSIGN DEFAULT ROUTING CODES AND BOM CODES */
   find ptp_det
      where ptp_part = pt
      and   ptp_site = st
      no-lock no-error.

   if available ptp_det
   then do:
      leadtime = ptp_mfg_lead.

      if ptp_pm_code = "P"
      then
         assign
            leadtime = ptp_pur_lead
            l_pmcode = "P".

      if new_wo  or
         regen_wo
      then
         assign
            wo_bom_code = ptp_bom_code
            wo_routing  = ptp_routing.

   end. /* AVAILABLE ptp_det */

   /* CALCULATE WO RELEASE DATE */

   if l_pmcode <> "P"
   then do:
      wo_rel_date = ?.
      {mfdate.i wo_rel_date wo_due_date leadtime wo_site}
   end. /* IF l_pmcode ... */
   else do:
       wo_rel_date = wo_due_date - leadtime.
       {mfhdate.i wo_rel_date -1 wo_site}
   end. /* ELSE DO ... */

   {mfmrw.i "wo_mstr"
             wo_part
             wo_nbr
             wo_lot """"
             wo_rel_date
             wo_due_date
             wo_qty_ord
            "SUPPLYF"
             WORK_ORDER
             wo_site}

   /* EXPLODE BILL AND CREATE MRP COMPONENT REQUIREMENT */
   wo_recno = recid(wo_mstr).
   {gprun.i ""wowomta.p""}

   display
      dbase
      wo_site
      wo_lot
      wo_nbr
      wo_part
      pt_desc1
      wo_qty_ord
      wo_due_date
      wo_rel_date
      wo_status
   with frame c.

   down 1 with frame c.
end. /* IF new_wo OR regen_wo OR prod_fcst <> wo_qty_ord */

/* INCLUDE FILE WHICH CONTAINS PROCEDURE assign_default_wo_acct */
{woacct.i}
