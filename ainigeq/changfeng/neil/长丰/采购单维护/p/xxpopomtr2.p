/* popomtr2.p  - PURCHASE ORDER MAINTENANCE SUBROUTINE - ASSIGN STD REQ INFO  */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.26.1.1 $                                                          */
/* This is a subprogram to handle the assignment of default information for a */
/* new PO Line when a Standard-style requisition has been referenced.         */
/*                                                                            */
/* REVISION: 8.5   MODIFIED: 02/13/97             BY: *J1YW* B. Gates         */
/* REVISION: 8.5   MODIFIED: 10/09/97             BY: *J231* Patrick Rowan    */
/* REVISION: 8.6E  MODIFIED: 05/09/98             BY: *L00Y* Jeff Wootton     */
/* REVISION: 8.6E  MODIFIED: 06/09/98             BY: *J2NW* A. Licha         */
/* REVISION: 8.6E  MODIFIED: 07/08/98             BY: *L020* Charles Yen      */
/* REVISION: 9.0   MODIFIED: 01/29/99             BY: *J391* Surekha Joshi    */
/* REVISION: 9.0   MODIFIED: 03/13/99             BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1   MODIFIED: 10/01/99             BY: *N014* PATTI GAULTNEY   */
/* REVISION: 9.1   MODIFIED: 05/28/99             BY: *L0DW* Ranjit Jain      */
/* REVISION: 9.1   MODIFIED: 07/07/99             BY: *J3HT* Sanjeev Assudani */
/* REVISION: 9.1   MODIFIED: 01/28/00             BY: *K253* Sandeep Rao      */
/* REVISION: 9.1   MODIFIED: 03/24/00             BY: *N08T* Annasaheb Rahane */
/* Revision: 1.17  BY: Bill Pedersen              DATE: 04/25/00  ECO: *N059* */
/* Revision: 1.18  BY: Mark Brown                 DATE: 08/17/00  ECO: *N0LJ* */
/* Revision: 1.19.1.1 BY: Manisha Sawant          DATE: 12/13/00  ECO: *M0XY* */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.21     BY: Niranjan R.             DATE: 07/12/01  ECO: *P00L* */
/* Revision: 1.22     BY: Anitha Gopal            DATE: 02/06/02  ECO: *N18Y* */
/* Revision: 1.23     BY: K Paneesh               DATE: 07/11/02  ECO: *N1NN* */
/* Revision: 1.25     BY: Laurene Sheridan        DATE: 10/17/02  ECO: *N13P* */
/* Revision: 1.26     BY: Rajiv Ramaiah           DATE: 03/26/03  ECO: *N2BH* */
/* $Revision: 1.26.1.1 $    BY: Kirti Desai             DATE: 10/31/03  ECO: *P188* */
/*By: Neil Gao 08/06/30 ECO: *SS 20080630* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
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
/* ****************************  Definitions  ******************************* */
/*============================================================================*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

/* PARAMETERS */
define input  parameter p_first_call   as logical.
define input  parameter p_frame_row    as integer.
define input  parameter p_po_curr      like po_curr.
define input  parameter p_po_vend      like po_vend.
define input  parameter p_pod_site     like pod_site.
define input  parameter p_po_taxable   like po_taxable.
define input  parameter p_po_ex_rate   like po_ex_rate.
define input  parameter p_po_ex_rate2  like po_ex_rate2.
define input  parameter p_po_taxc      like po_taxc.
define input  parameter p_po_type      like po_type.
define output parameter p_pod_req_nbr  like pod_req_nbr  no-undo.
define output parameter p_pod_req_line like pod_req_line no-undo.
define output parameter p_pod_part     like pod_part     no-undo.
define output parameter p_pod_pur_cost like pod_pur_cost no-undo.
define output parameter p_pod_disc_pct like pod_disc_pct no-undo.
define output parameter p_pod_qty_ord  like pod_qty_ord  no-undo.
define output parameter p_pod_need     like pod_need     no-undo.
define output parameter p_pod_due_date like pod_due_date no-undo.
define output parameter p_pod_um       like pod_um       no-undo.
define output parameter p_pod_um_conv  like pod_um_conv  no-undo.
define output parameter p_pod_project  like pod_project  no-undo.
define output parameter p_pod_acct     like pod_acct     no-undo.
define output parameter p_pod_sub      like pod_sub      no-undo.
define output parameter p_pod_cc       like pod_cc       no-undo.
define output parameter p_pod_request  like pod_request  no-undo.
define output parameter p_pod_approve  like pod_approve  no-undo.
define output parameter p_pod_apr_code like pod_apr_code no-undo.
define output parameter p_pod_desc     like pod_desc     no-undo.
define output parameter p_pod_taxc     like pod_taxc     no-undo.
define output parameter p_pod_taxable  like pod_taxable  no-undo.
define output parameter p_pod_vpart    like pod_vpart    no-undo.
define output parameter p_pod_cmtindx  like pod_cmtindx  no-undo.
define output parameter p_pod_lot_rcpt like pod_lot_rcpt no-undo.
define output parameter p_pod_rev      like pod_rev      no-undo.
define output parameter p_pod_loc      like pod_loc      no-undo.
define output parameter p_pod_insp_rqd like pod_insp_rqd no-undo.
define output parameter p_mfgr         as character      no-undo.
define output parameter p_mfgr_part    as character      no-undo.
define output parameter p_desc1        as character      no-undo.
define output parameter p_desc2        as character      no-undo.
define output parameter p_continue     like mfc_logical  no-undo.
define output parameter p_commentIndex as integer no-undo.
define output parameter p_pod_type     like pod_type     no-undo.

/* SHARED VARIABLES */
define shared variable clines    as integer initial ?.
define shared variable sngl_ln   like poc_ln_fmt.
define shared variable line      like sod_line.
define shared variable podcmmts  like mfc_logical.
define shared variable desc1     like pt_desc1.
define shared variable desc2     like pt_desc2.
define shared variable ext_cost  like pod_pur_cost.
define shared variable mfgr_part like vp_mfgr_part.
define shared variable st_qty    like pod_qty_ord.
define shared variable st_um     like pod_um.
define shared variable mfgr      like vp_mfgr.
define shared variable disc      like pod_disc_pct.

/*SS 20080630 - B*/
define shared variable xxreqnbr like req_nbr.
/*SS 20080630 - E*/

/* SHARED FRAMES */
define shared frame c.
define shared frame d.

/* LOCAL VARIABLES */
define variable dummy_acct      as character     no-undo.
define variable dummy_sub       as character     no-undo.
define variable dummy_cc        as character     no-undo.
define variable dummy_type      as character     no-undo.
define variable taxableItem     as logical       no-undo.
define variable l_continue      like mfc_logical no-undo.
define variable mc-error-number like msg_nbr     no-undo.
define variable conv_factor     as decimal       no-undo.

if c-application-mode = "API"
   then do on error undo,return:

   /* COMMON API CONSTANTS AND VARIABLES */
   {mfaimfg.i}

   /* PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "Api" PREFIX */
   {popoit01.i}



   /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
               "(output ApiMethodHandle,
                 output ApiProgramName,
                 output ApiMethodName,
                 output apiContextString)"}


   /* GET LOCAL PO MASTER TEMP-TABLE */
   create ttPurchaseOrderDet.
   run getPurchaseOrderDetRecord in ApiMethodHandle
              (buffer ttPurchaseOrderDet).

end.  /* If c-application-mode = "API" */

/* FORM STATEMENTS */
/* PURCHASE ORDER MAINTENANCE SINGLE LINE ITEMS */
/* DEFINES FORMS c & d */
{mfpomtb.i}

form
   p_pod_req_nbr
with frame a overlay row p_frame_row column 14.

/*============================================================================*/
/* ****************************  Main Block  ******************************** */
/*============================================================================*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

p_pod_disc_pct = disc.

{pxrun.i &PROC='processRead' &PROGRAM='icsixr.p'
         &PARAM="(input p_pod_site,
                  buffer si_mstr,
                  input {&NO_LOCK_FLAG},
                  input {&NO_WAIT_FLAG})"
         &NOAPPERROR=True
         &CATCHERROR=True}

do on error undo, retry on endkey undo, leave:
   if retry and c-application-mode = "API" then
      undo , return.
   p_continue = no.

   if c-application-mode <> "API"
   then do:
/*SS 20080630 - B*/
/*
      prompt-for pod_req_nbr with frame c
      editing:

         {pxrun.i &PROC='processRead' &PROGRAM='icsixr.p'
                  &PARAM="(input p_pod_site,
                           buffer si_mstr,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if available si_mstr
         then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp01.i
               req_det
               pod_req_nbr
               req_nbr
               p_pod_site
               req_site
               req_nbr}
         end.
         else do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i
               req_det
               pod_req_nbr
               req_nbr
               pod_req_nbr
               req_nbr
               req_nbr}
         end.

         if recno <> ?
         then do:
            display req_nbr @ pod_req_nbr
               req_part @ pod_part
               req_qty @ pod_qty_ord
               req_um  @ pod_um
               req_site @ pod_site
               req_pur_cost @ pod_pur_cost
            with frame c.
         end.
      end.  /* EDITING */
*/
			disp xxreqnbr @ pod_req_nbr with frame c.
/*SS 20080630 - E*/      
      p_pod_req_nbr = input pod_req_nbr.

   end. /* IF c-application-mode <> "API" */
   else do: /* IF c-application-mode = "API" */

      for first pod_det
         where pod_req_nbr = p_pod_req_nbr
      no-lock:
      end. /* FOR FIRST pod_det ... */

      {pxrun.i &PROC='processRead'
               &PROGRAM='icsixr.p'
               &PARAM="(input p_pod_site,
                        buffer si_mstr,
                        input {&NO_LOCK_FLAG},
                        input {&NO_WAIT_FLAG})"
               &NOAPPERROR=True
               &CATCHERROR=True}

      if available si_mstr
      then do:
         for first req_det where req_nbr = ttPurchaseOrderDet.reqNbr
            and req_site = p_pod_site:
         end.
      end.
      else
      do:
         for first req_det where req_nbr = ttPurchaseOrderDet.reqNbr:
         end.
      end.

      assign {mfaiset.i p_pod_req_nbr ttPurchaseOrderDet.reqNbr}.

      if available req_det
      then do:

         if req_det.req_part <> "" then
            assign {mfaiset.i pod_part req_det.req_part}.

         if req_det.req_qty <> 0 then
            assign {mfaiset.i pod_qty_ord req_det.req_qty}.

         if req_det.req_pur_cost <> 0 then
            assign {mfaiset.i pod_pur_cost req_det.req_pur_cost}.
      end.

   end.  /* IF c-application-mode = "API" */

   if p_pod_req_nbr > ''
   then do:
      {pxrun.i  &PROC='processRead' &PROGRAM='rqstdxr.p'
                &PARAM="(input p_pod_req_nbr,
                         buffer req_det,
                         input FALSE,
                         input FALSE)"
                &NOAPPERROR=true
                &CATCHERROR=true}

      if return-value = {&SUCCESS-RESULT}
      then do:

         /*ENSURE REQ SITE AND PO SITE ARE SAME*/
         {pxrun.i &PROC='validateRequisitionSite' &PROGRAM='rqstdxr.p'
                  &PARAM="(input req_site, input p_pod_site)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               undo, retry.
            else /* c-application-mode = "API" */
               undo, return.
         end.

         /*ENSURE REQUISITION IS APPROVED*/
         {pxrun.i &PROC='validateReqIsApproved' &PROGRAM='rqstdxr.p'
                  &PARAM="(input req_nbr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API" then
               undo, retry.
            else /* c-application-mode = "API" */
               undo, return.
         end.

         /*WARN IF REQ IS BEING USED ON BLANKET PO*/
         {pxrun.i &PROC='validateReqNotOnBlanket' &PROGRAM='rqstdxr.p'
                  &PARAM="(input p_pod_req_nbr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            /*DO YOU WISH TO CONTINUE*/
            {pxmsg.i
               &MSGNUM=2316
               &ERRORLEVEL={&WARNING-RESULT}
               &CONFIRM=l_continue}
            if  c-application-mode <> "API" then
                if not l_continue then undo, retry.
            if c-application-mode = "API" then
                if not l_continue then undo, return.
         end.  /* if return-value <> {&SUCCESS-RESULT} then do: */

         /*RETURN VARIOUS PARAMETER VALUES*/
         assign
            p_pod_part = req_part
            p_pod_qty_ord = req_qty
            p_pod_need = req_need
/*SS 20080630 - B*/
/*
            p_pod_due_date = req_need
*/
						p_pod_due_date = req_rel_date
/*SS 20080630 - E*/
            p_pod_um = req_um
            p_pod_acct = req_acct
            p_pod_sub = req_sub
            p_pod_cc = req_cc
            p_pod_request = req_request
            p_pod_approve = req_apr_by
            p_pod_apr_code = req_apr_code
            p_pod_um_conv = 1
/*SS 20080630 - B*/
/*
            p_pod_project = req_project
*/
						p_pod_project = req_so_job
/*SS 20080630 - E*/
            p_pod_pur_cost = 0
            p_pod_vpart = ""
            p_desc1 = ""
            p_desc2 = ""
            p_mfgr = ""
            st_um = req_um
            st_qty = req_qty
            p_commentIndex = req_cmtindx
            p_pod_type = (if p_po_type = "B"
                          then
                             "B"
                          else
                             p_pod_type).

         /*GET VENDOR ITEM MASTER COST INFO*/
         {pxrun.i &PROC='getItemAndPriceOfLastQuote' &PROGRAM='popoxr1.p'
                  &PARAM="(input p_pod_part,
                           input p_pod_qty_ord,
                           input p_pod_um,
                           input p_po_vend,
                           input p_po_curr,
                           input 0,
                           output p_pod_vpart,
                           output p_pod_pur_cost)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         /*GET VENDOR ITEM MASTER VENDOR INFO*/
         {pxrun.i &PROC='getManufacturerItemDataOfLastQuote' &PROGRAM='ppsuxr.p'
                  &PARAM="(input p_pod_part,
                           input p_po_vend,
                           input-output p_pod_vpart,
                           output p_mfgr,
                           output p_mfgr_part)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if can-find(first pt_mstr where pt_part = p_pod_part)
         then do:

            /* GET PURCHASE COST FROM ITEM */
            {pxrun.i &PROC='getPurchaseCostForRequisitionItem' &PROGRAM='rqstdxr.p'
                     &PARAM="(input p_pod_part,
                              input p_pod_site,
                              input p_pod_um_conv,
                              input p_po_curr,
                              input p_po_ex_rate,
                              input p_po_ex_rate2,
                              output p_pod_pur_cost)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            /* GET DEFAULTS VALUE FROM ITEM */
            {pxrun.i &PROC='getPOItemDefaults' &PROGRAM='popoxr1.p'
                     &PARAM="(input p_pod_part,
                              input p_pod_site,
                              output p_desc1,
                              output p_desc2,
                              output st_um,
                              output p_pod_rev,
                              output p_pod_loc,
                              output p_pod_insp_rqd,
                              output taxableItem,
                              output p_pod_taxc)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            p_po_taxable = (p_po_taxable and taxableItem).

         end.  /* if can-find(first pt_... */
         else do:
            /* ASSIGN OTHER DEFAULTS */

            /* GET PURCHASE COST */
            if  p_pod_pur_cost = 0
            then do:
               assign
                  p_pod_pur_cost = req_pur_cost.

               if p_po_curr <> base_curr
               then do:

                  /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                  {pxrun.i &PROC='convertAmtToTargetCurr' &PROGRAM='mcexxr.p'
                           &PARAM="(input base_curr,
                                  input p_po_curr,
                                  input p_po_ex_rate2,
                                  input p_po_ex_rate,
                                  input p_pod_pur_cost,
                                  input false, /* DO NOT ROUND */
                                  output p_pod_pur_cost)"}
               end. /* IF p_po_curr <> base_curr */

            end. /* IF p_pod_pur_cost = 0 */

            /* GET TAX DATA */
            assign
               p_pod_taxc = p_po_taxc
               p_pod_taxable  = p_po_taxable.

            /*GET DESCRIPTIONS*/
            if p_pod_desc <> "" then
            assign
               p_desc1 = p_pod_desc
               p_desc2 = "".
            /* Added supplier type as third parameter */
            /*GET REV, LOC, INSP RQD*/
            {gprun.i ""popomte1.p""
               "(input  p_pod_part,
                 input  p_pod_site,
                 """",
                 output p_pod_rev,
                 output p_pod_loc,
                 output p_pod_insp_rqd,
                 output dummy_acct,
                 output dummy_sub,
                 output dummy_cc,
                 output dummy_type)"}
         end. /* else do: ASSIGN */
      end.  /* if return-value = {&SUCCESS-RESULT} */
      else
         /* GET TAX DATA WHEN REQUISITION NOT AVALIABLE */
         if p_po_taxable
         then
            p_pod_taxc = p_po_taxc.

   end.  /* if p_pod_req_nbr > '' */

   p_continue = yes.
end.  /* do on error undo, retry on endkey undo, leave: */
if c-application-mode <> "API" then
   hide frame a no-pause.
