/* popomteb.p - PO MAINTENANCE - UPDATE PO LINE DETAILS WHEN SITE IS CHANGED  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5 $                                                  */
/* This program updates the purchase order line details when the site is      */
/* changed.                                                                   */
/* Revision: 1.3      BY:Samir Bavkar          DATE:12/12/01 ECO: *P013* */
/* $Revision: 1.5 $    BY: Andrea Suchankova    DATE: 11/08/02  ECO: *N13P*   */
/*                                                                            */
/* $Revision: eB2SP4    BY: Apple Tam        DATE: 09/26/11  ECO: *SS - 20110926.1*   */
/*V8:ConvertMode=Maintenance                                                  */
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */

/*============================================================================*/
/* **************************** Definitions ********************************* */
/*============================================================================*/

/* STANDARD INCLUDE FILES */
{mfdeclre.i}
{pxmaint.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE popomtea_p_1 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* SHARED FRAMES */
define shared frame c.
define shared frame d.

/* SHARED VARIABLES */
define shared variable clines    as integer.
define shared variable desc1     like pt_desc1.
define shared variable desc2     like pt_desc2.
define shared variable ext_cost  like pod_pur_cost.
define shared variable line      like sod_line.
define shared variable po_recno  as recid.
define shared variable pod_recno as recid.
define shared variable podcmmts  like mfc_logical label {&popomtea_p_1}.
define shared variable sngl_ln   like poc_ln_fmt.
define shared variable st_qty    like pod_qty_ord.
define shared variable st_um     like pod_um.

/* LOCAL VARIABLES */
define variable conversion_factor        as decimal no-undo.
define variable l_pl_acc                 like pl_pur_acct  no-undo.
define variable l_pl_sub                 like pl_pur_sub no-undo.
define variable l_pl_cc                  like pl_pur_cc  no-undo.
define variable l_pt_ins                 like pt_insp_rqd no-undo.
define variable l_pt_loc                 like pt_loc no-undo.
define variable l_pt_rev                 like pt_rev no-undo.
define variable mfgr                     like vp_mfgr no-undo.
define variable mfgr_part                like vp_mfgr_part no-undo.
define variable req_part_has_vendor_part as logical no-undo.
define variable reqpart                  like req_part no-undo.
define variable l_pod_type               like pod_type no-undo.
define variable mc-error-number          like msg_nbr no-undo.
define variable l_dummy_parameter        like pod_loc no-undo.
define variable inventory_item         like mfc_logical no-undo.

/* DEFINES FORMS c & d */
/*SS - 110926.1 -B*/
/*
{mfpomtb.i}
*/
/*SS - 110926.1 -E*/

/*SS - 110926.1 -B*/
{xxmfpomtb2.i}
/*SS - 110926.1 -E*/

/*============================================================================*/
/* ****************************** Main Block ******************************** */
/*============================================================================*/

for first poc_ctrl
      fields(poc_insp_loc)
      no-lock:
end.

for first po_mstr
      fields(po_nbr po_vend po_curr po_due_date po_ex_rate
      po_ex_rate2 po_ord_date po_taxable)
      where recid(po_mstr) = po_recno no-lock:
end.

find pod_det exclusive-lock
   where recid(pod_det) = pod_recno no-error.

for first si_mstr
      fields (si_site)
      where si_site = pod_site no-lock:
end.

if pod_req_nbr > "" then do:
   assign
      reqpart = pod_part
      req_part_has_vendor_part = can-find(first vp_mstr where vp_part = pod_part
                                                       and vp_vend = po_vend).
end.

if req_part_has_vendor_part = false then do:
   {pxrun.i &PROC='getPurchaseCost' &PROGRAM='popoxr1.p'
            &PARAM="(input pod_part,
                     input po_vend,
                     input si_site,
                     input po_curr,
                     input pod_um,
                     input pod_qty_ord,
                     input po_ex_rate,
                     input po_ex_rate2,
                     input po_ord_date,
                     output pod_pur_cost)"
            &NOAPPERROR=true
            &CATCHERROR=true}
   if  c-application-mode <> "API"
   then do:
      display pod_pur_cost with frame c.
   end. /*  c-application-mode <> "API" */

   assign
      pod__qad09 = pod_pur_cost * (1 - (pod_disc_pct / 100))
      pod__qad02 = (pod_pur_cost * (1 - (pod_disc_pct / 100))
                     - pod__qad09) * 100000.

   if sngl_ln then do:

      {pxrun.i &PROC='getRemoteItemData' &PROGRAM='popoxr1.p'
               &PARAM="(input po_ord_date,
                        input pod_part,
                        input si_site,
                        input """",
                        output glxcst,
                        output l_pt_rev,
                        output l_pt_loc,
                        output l_pt_ins,
                        output l_pl_acc,
                        output l_pl_sub,
                        output l_pl_cc,
                        output l_pod_type)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if  c-application-mode <> "API"
      then do:
         display l_pt_rev  @ pod_rev with frame d.
      end. /*  c-application-mode <> "API" */
   end. /* IF SNGL_LN */

end. /* IF REQ_PART_HAS_VENDOR_PART = FALSE */

{pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
   &PARAM="(input pod_part,
                  buffer pt_mstr,
                  input false,
                   input false)"
   &NOAPPERROR=true
   &CATCHERROR=true}

inventory_item = can-find(first pt_mstr where pt_part = pod_part).

/* GET STANDARD COST */

if inventory_item then do:

   {pxrun.i &PROC='getRemoteItemData' &PROGRAM='popoxr1.p'
            &PARAM="(input po_ord_date,
                     input pod_part,
                     input si_site,
                     input """",
                     output glxcst,
                     output l_pt_rev,
                     output l_pt_loc,
                     output l_pt_ins,
                     output l_pl_acc,
                     output l_pl_sub,
                     output l_pl_cc,
                     output l_pod_type)"
            &NOAPPERROR=true
            &CATCHERROR=true}
end.

/* CONVERT FROM BASE TO FOREIGN CURRENCY */
{gprunp.i "mcpl" "p" "mc-curr-conv"
   "(input base_curr,
     input po_curr,
     input po_ex_rate2,
     input po_ex_rate,
     input glxcst,
     input false, /* DO NOT ROUND */
     output pod_std_cost,
     output mc-error-number)"}.

if inventory_item then do:
   {pxrun.i &PROC='processRead' &PROGRAM='adsuxr.p'
            &PARAM="(input po_mstr.po_vend,
                     buffer vd_mstr,
                     input  {&NO_LOCK_FLAG},
                     input  {&NO_WAIT_FLAG})"}

   if (not ({pxfunct.i &FUNCTION='isGRSInUse' &PROGRAM='rqgrsxr.p'}) or
       pod_req_nbr = "" or
       pod_part <> reqpart)
   then do:

      {pxrun.i &PROC='getAccountFieldsForLine' &PROGRAM='popoxr1.p'
               &PARAM="(input po_ord_date,
                        input pod_part,
                        input si_site,
                        input poc_insp_loc,
                        input vd_type,
                        output glxcst,
                        output pod_rev,
                        output pod_loc,
                        output pod_insp_rqd,
                        output pod_acct,
                        output pod_sub,
                        output pod_cc,
                        output l_pod_type)"
               &NOAPPERROR=true
               &CATCHERROR=true}
   end. /* If not pxfunct.i */
   else do:
      {pxrun.i &PROC='getAccountFieldsForLine' &PROGRAM='popoxr1.p'
               &PARAM="(input po_ord_date,
                        input pod_part,
                        input si_site,
                        input poc_insp_loc,
                        input vd_type,
                        output l_dummy_parameter,
                        output l_dummy_parameter,
                        output l_dummy_parameter,
                        output l_dummy_parameter,
                        output pod_acct,
                        output pod_sub,
                        output pod_cc,
                        output l_dummy_parameter)"
               &NOAPPERROR=True
               &CATCHERROR=True}
   end.
end. /* If INVENTORY ITEM */
