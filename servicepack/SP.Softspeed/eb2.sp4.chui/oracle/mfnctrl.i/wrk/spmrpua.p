/* spmrpua.p - OPERATIONS PLANNING APPROVAL (Firm Planned Orers)              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.8 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      LAST MODIFIED: 09/29/95   BY: amw   *J078*              */
/* REVISION: 8.5      LAST MODIFIED: 06/19/96   BY: rvw   *G1XY*              */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.5      LAST MODIFIED: 08/13/98   BY: *J2V2* Patrick Rowan      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 08/29/00   BY: *N0PN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/29/00   BY: *L0Y1* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 11/13/00   BY: *N0TN* Jean Miller        */
/* Revision: 1.7.1.7     BY: Irine D'Mello   DATE: 09/10/01 ECO: *M164*       */
/* $Revision: 1.7.1.8 $    BY: Vivek Gogte     DATE: 02/25/02 ECO: *N18N*        */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* INCLUDE FILE DEFINING SHARED VARIABLES */
{mfdeclre.i}

/* INCLUDE FILE FOR TRANSLATION GPLABEL FUNCTION */
{gplabel.i}

/* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{pxmaint.i}

/* PROGRAM CONTAINING COMMON ROUTINES USED IN WO MODULE */
{pxphdef.i wocmnrtn}

define new shared variable know_date     as   date.
define new shared variable find_date     as   date.
define new shared variable interval      as   integer.
define new shared variable comp          like ps_comp.
define new shared variable qty           like wo_qty_ord.
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
define new shared variable critical-part like wod_part    no-undo.
define new shared variable prev_site     like wo_site.
define new shared variable joint_type    like wo_joint_type.
define new shared variable del-yn        like mfc_logical.
define new shared variable deliv         like wod_deliver.
define new shared variable due_date      like wo_due_date.
define new shared variable del-joint     like mfc_logical.

define shared variable a_recid    as recid no-undo.

define variable del_wo    like mfc_logical.
define variable glx_mthd  like cs_method.
define variable glx_set   like cs_set.
define variable cur_mthd  like cs_method.
define variable cur_set   like cs_set.
define variable prev_mthd like cs_method.
define variable frwrd     as   integer.
define variable l_errorno as   integer no-undo.

define shared workfile a no-undo
   field a_part     like fp1_part
   field a_site     like fp1_site
   field a_line     like flp_line
   field a_date     like mfc_date
   field a_qty      like mrp_qty
   field a_id       like wo_lot
   field a_ok       like mfc_logical
   field a_req      like req_nbr
   field a_req_line like pod_line
   field a_recno    as   recid
   field a_bucket   like mfc_integer.

/* NOW WE HAVE TO CREATE FIRM PLANNED ORDERS */
find a
   where recid(a)     = a_recid
   exclusive-lock no-error.

/* wo_status CONDITION PREVENTS DELETION OF ORDERS */
/* WITH STATUS OTHER THAN "F" OR "B"               */
find wo_mstr
   where (wo_lot = a_id)
     and (   wo_status = "F"
          or wo_status = "B")
   exclusive-lock no-error.

if available wo_mstr
then do:
   assign
      wo_recno = recid(wo_mstr)
      wo_rmks  = getTermLabel("OPSPLAN_APPROVED",24).

   /* DELETE WORK ORDER WITH STATUS "B" OR WHEN QUANTITY IS CHANGED */
   if (wo_qty_ord <> a_qty
      or a_qty     = 0)
      or wo_status <> "F"
   then do:
      {gprun.i ""wowomte.p""}
      del_wo = yes.
   end. /* IF wo_qty_ord <> a_qty ... */
end. /* IF AVAILABLE wo_mstr ... */

if (not available wo_mstr
       and a_qty <> 0)
   or (del_wo
          and a_qty <> 0)
then do:

   create wo_mstr.
   assign
      wo_rmks     = getTermLabel("OPSPLAN_APPROVED",24)
      wo_part     = a_part
      wo_ord_date = today
      wo_site     = a_site
      wo_qty_ord  = a_qty
      wo_status   = "F"
      wo_due_date = a_date.

   /* GET NEXT LOT NUMBER */
   {mfnxtsq.i wo_mstr wo_lot woc_sq01 wo_lot}
   {mfnctrl.i woc_ctrl woc_nbr wo_mstr wo_nbr wo_nbr}

   if recid(wo_mstr) = -1 then .

   assign
      a_id     = wo_lot
      wo_recno = recid(wo_mstr).

   for first pt_mstr
      fields (pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1 pt_desc2
              pt_insp_lead pt_insp_rqd pt_joint_type pt_loc pt_mfg_lead pt_mrp
              pt_network pt_ord_max pt_ord_min pt_ord_mult pt_ord_per
              pt_ord_pol pt_ord_qty pt_part pt_plan_ord pt_pm_code
              pt_prod_line pt_pur_lead pt_rctpo_active pt_rctpo_status
              pt_rctwo_active pt_rctwo_status pt_routing pt_sfty_time
              pt_timefence pt_um pt_yield_pct)
      where pt_part = wo_part
      no-lock:
   end. /* FOR FIRST pt_mstr ... */

   if available pt_mstr
   then
      leadtime = pt_mfg_lead.

   for first ptp_det
      fields (ptp_bom_code ptp_ins_lead ptp_ins_rqd ptp_joint_type
              ptp_mfg_lead ptp_network ptp_ord_max ptp_ord_min ptp_ord_mult
              ptp_ord_per ptp_ord_pol ptp_ord_qty ptp_part ptp_plan_ord
              ptp_pm_code ptp_pur_lead ptp_routing ptp_sfty_tme ptp_site
              ptp_timefnce ptp_yld_pct)
      where ptp_part = wo_part
        and ptp_site = wo_site
      no-lock:
   end. /* FOR FIRST ptp_det ... */

   /* ASSIGN DEFAULT ROUTING CODES AND BOM CODES */
   if available ptp_det
      and ptp_bom_code <> ""
   then
      wo_bom_code = ptp_bom_code.
   else
      wo_bom_code = pt_bom_code.

   if available ptp_det
      and ptp_routing <> ""
   then
      wo_routing = ptp_routing.
   else
      wo_routing = pt_routing.

   /* CALCULATE WO RELEASE DATE */
   {mfdate.i wo_rel_date wo_due_date leadtime wo_site}

   /*DETERMINE COSTING METHOD*/
   {gprun.i ""csavg01.p"" "(wo_part,
                            wo_site,
                            output glx_set,
                            output glx_mthd,
                            output cur_set,
                            output cur_mthd)"
   }
   if glx_mthd = "AVG"
   then
      wo_var = no.

   /* SETUP DEFAULT ACCOUNTS */
   if available pt_mstr
   then do:

      /*ASSIGN DEFAULT RECEIPT STATUS AND ACTIVE FLAG */
      {pxrun.i &PROC    = 'get_default_wo_rctstat'
               &PROGRAM = 'wocmnrtn.p'
               &HANDLE  = ph_wocmnrtn
               &PARAM   = "(
                            input  wo_part,
                            input  wo_site,
                            output wo_rctstat,
                            output wo_rctstat_active,
                            output l_errorno
                          )"
      }

      /* ASSIGN DEFAULT VARIANCE ACCOUNT SUB_ACCOUNT AND COST CENTER CODE. */
      run assign_default_wo_acct(buffer wo_mstr,
                                 input  pt_prod_line).

   end. /* IF AVAILABLE pt_mstr */

   /* CHANGED PRE-PROCESSOR TO TERM: WORK_ORDER */
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

   /* EXPLODE BILL AND CREATE MRP COMPONET REQUIREMENT */
   wo_recno = recid(wo_mstr).
   {gprun.i ""wowomta.p""}

end. /* IF NOT AVAILABLE wo_mstr */

/*INCLUDE FILE WHICH CONTAINS PROCEDURE assign_default_wo_acct */
{woacct.i}
