/* popomtea.p - PURCHASE ORDER MAINTENANCE UPDATE PART                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15.4.2 $                                                      */
/*                                                                            */
/* This program allows updating line item number and does validations and     */
/* defaults data from supplier and item master.                               */
/*                                                                            */
/* Revision: 8.5     BY:B. Gates                    DATE:06/12/97 ECO: *J1YW* */
/* Revision: 8.6E    BY:A. Rahane                   DATE:02/23/98 ECO: *L007* */
/* Revision: 8.6E    BY:Jeff Wootton                DATE:05/09/98 ECO: *L00Y* */
/* Revision: 8.6E    BY:Charles Yen                 DATE:06/09/98 ECO: *L020* */
/* Revision: 8.6E    BY:Irine D'mello               DATE:09/18/98 ECO: *J307* */
/* Revision: 8.6E    BY:Joseph Fernando             DATE:10/20/98 ECO: *J32M* */
/* Revision: 8.6E    BY:Steve Nugent                DATE:02/04/99 ECO: *J39G* */
/* Revision: 9.1     BY:Patti Gaultney              DATE:10/01/99 ECO: *N014* */
/* Revision: 9.1     BY:Reetu Kapoor                DATE:01/12/00 ECO: *L0PJ* */
/* Revision: 9.1     BY:Sandeep Rao                 DATE:01/28/00 ECO: *K253* */
/* Revision: 9.1     BY:Annasaheb Rahane            DATE:03/24/00 ECO: *N08T* */
/* $Revision: 1.15.4.2 $      BY:John Corda         DATE:03/18/00 ECO: *N059* */
/* REVISION: 9.1     BY:Mudit Mehta                 DATE:08/17/00 ECO: *N0KM* */
/* REVISION: 9.1     BY:Anitha Gopal                DATE:02/15/02 ECO: *N18Y* */
/* REVISION: 9.1     BY:Adeline Kinehan             DATE:03/06/02 ECO: *N13P* */
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

/* THIS IS A REPLACEMENT FOR POPOMTE.P */

/*============================================================================*/
/* **************************** Definitions ********************************* */
/*============================================================================*/
/* REVISION: 9.1     BY:Ricky Ho                 DATE:13/Apr/05 ECO: *ricky* */

/* STANDARD INCLUDE FILES */
{mfdeclre.i}
{pxmaint.i}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE popomtea_p_1 "Comments"
/* MaxLen: Comment: */

/*N0KM*
 * &SCOPED-DEFINE popomtea_p_2 "ITEM NOT IN INVENTORY"
 * /* MaxLen: Comment: */
 *N0KM*/

/* ********** End Translatable Strings Definitions ********* */

/* SHARED FRAMES */
define shared frame c.
define shared frame d.

/* SHARED VARIABLES */
define shared variable clines    as integer.
define shared variable continue  like mfc_logical.
define shared variable desc1     like pt_desc1.
define shared variable desc2     like pt_desc2.
define shared variable disc      like pod_disc_pct.
define shared variable ext_cost  like pod_pur_cost.
define shared variable line      like sod_line.
define shared variable po_recno  as recid.
define shared variable pod_recno as recid.
define shared variable podcmmts  like mfc_logical label {&popomtea_p_1}.
define shared variable rndmthd   like rnd_rnd_mthd.
define shared variable sngl_ln   like poc_ln_fmt.
define shared variable so_job    like pod_so_job.
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
define variable display_um               like pod_um no-undo.
define variable pur_cost                 like pod_pur_cost no-undo.
define variable qty_ord                  like pod_qty_ord no-undo.
define variable req_part_has_vendor_part as logical no-undo.
define variable reqpart                  like req_part no-undo.
define variable vpart                    like pod_vpart no-undo.
define variable vpumconv                 like um_conv no-undo.
define variable l_pod_type               like pod_type no-undo.
define variable mc-error-number          like msg_nbr no-undo.
define variable verrmsg as character format "x(60)".

/* DEFINES FORMS c & d */
{mfpomtb.i}

if c-application-mode = "API" then do on error undo,return:

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

    /* GET LOCAL PO DETAIL TEMP-TABLE */
   create ttPurchaseOrderDet.
   run getPurchaseOrderDetRecord in ApiMethodHandle
              (buffer ttPurchaseOrderDet).


end.  /* If c-application-mode = "API" */

/*============================================================================*/
/* ****************************** Main Block ******************************** */
/*============================================================================*/

for first poc_ctrl
   fields(poc_insp_loc)
   no-lock: end.

for first po_mstr
   fields(po_nbr po_vend po_curr po_due_date po_ex_rate
          po_ex_rate2 po_ord_date po_taxable)
   where recid(po_mstr) = po_recno no-lock: end.

find pod_det exclusive-lock
   where recid(pod_det) = pod_recno no-error.

for first si_mstr
   fields (si_site)
   where si_site = pod_site no-lock: end.

continue = no.

do on endkey undo, leave on error undo, retry:
   if retry and c-application-mode = "API" then
      return error.

   if pod_req_nbr > "" then do:
      reqpart = pod_part.

      {pxrun.i &PROC='processRead' &PROGRAM='ppsuxr.p'
               &PARAM="(input pod_part,
                        input po_vend,
                        input '',
                        buffer vp_mstr,
                        input false,
                        input false)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value = {&SUCCESS-RESULT} then
         req_part_has_vendor_part = yes.

   end.

   if c-application-mode <> "API" then do:
      prompt-for pod_det.pod_part with frame c
      editing:
         if req_part_has_vendor_part = false then do:
            {mfnp.i pt_mstr pod_part pt_part pod_part pt_part pt_part}

            if recno <> ? then do:
               display_um = pod_um.

               if display_um = "" then
                  display_um = pt_um.

               run costItemInfo(buffer vp_mstr,
                                buffer pod_det,
                                buffer po_mstr,
                                buffer pt_mstr,
                                buffer si_mstr,
                                input display_um).

               display
                  pt_part    @ pod_part
                  display_um @ pod_um
                  pur_cost   @ pod_pur_cost
                  with frame c.

               if sngl_ln then do:

                  {pxrun.i &PROC='getRemoteItemData' &PROGRAM='popoxr1.p'
                           &PARAM="(input po_ord_date,
                                    input pt_part,
                                    input si_site,
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

                  display
                     l_pt_rev  @ pod_rev
                     vpart     @ pod_vpart
                     mfgr
                     mfgr_part
                     st_qty
                     st_um
                     desc1
                     desc2
                     with frame d.
               end.
            end.
         end.
         else if req_part_has_vendor_part = true then do:
            {mfnp05.i vp_mstr vp_partvend
               "vp_part = reqpart and vp_vend = po_vend"
               vp_vend_part "input pod_part"}

            if recno <> ? then do:
               pur_cost = ?.

               run vpMstrAvailable (buffer vp_mstr,
                                    buffer pod_det,
                                    buffer po_mstr,
                                    buffer si_mstr).

               display
                  vp_vend_part @ pod_part
                  pod_um
                  pod_qty_ord
                  pur_cost     @ pod_pur_cost
                  with frame c.

               if sngl_ln then do:
                  if ((pod__qad02 = 0 or pod__qad02 = ?) and
                  (pod__qad09 = 0 or pod__qad09 = ?))
                  then
                     ext_cost = qty_ord * pur_cost * (1 - (pod_disc_pct / 100)).
                  else
                     ext_cost = pod_qty_ord *
                             (pod__qad09 + pod__qad02 / 100000).

               /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
                  {pxrun.i &PROC='roundAmount' &PROGRAM='mcexxr.p'
                           &PARAM="(input-output ext_cost,
                                    input rndmthd,
                                    output mc-error-number)"
                           &NOAPPERROR=true
                           &CATCHERROR=true}

                  display ext_cost with frame d.
               end.
            end.
         end.
      end.  /* PROMPT-FOR pod_part */
   end.  /*if c-application-mode <> "API" */
   else if c-application-mode = "API" then do:
      assign
         {mfaiset.i pod_part ttPurchaseOrderDet.part}.

      if req_part_has_vendor_part = false then do:
         /*
         * if we are not processing a MEMO item,
         * i.e. we can find a pt_mstr record in the database
         * for the part specified on the BOD.
         * Perform the following processing.
         */
         for first pt_mstr where pt_part = pod_part no-lock:

            display_um = pod_um.

            if display_um = "" then display_um = pt_um.

            run costItemInfo(buffer vp_mstr,
                             buffer pod_det,
                             buffer po_mstr,
                             buffer pt_mstr,
                             buffer si_mstr,
                             input display_um).

            if sngl_ln then do:

               {pxrun.i &PROC='getRemoteItemData'
                        &PROGRAM='popoxr1.p'
                        &PARAM="(input po_ord_date,
                                 input pt_part,
                                 input si_site,
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
            end. /* sngl_ln */
         end. /* first pt_mstr */
      end. /* req_part_has_vendor_part = false */

      else if req_part_has_vendor_part = true then do:

         run vpMstrAvailable(buffer vp_mstr,
                             buffer pod_det,
                             buffer po_mstr,
                             buffer si_mstr).


         if sngl_ln then do:
            if ((pod__qad02 = 0 or pod__qad02 = ?) and
            (pod__qad09 = 0 or pod__qad09 = ?))
            then
               ext_cost = qty_ord * pur_cost * (1 - (pod_disc_pct / 100)).
            else
               ext_cost = pod_qty_ord *
                          (pod__qad09 + pod__qad02 / 100000).

            /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
            {pxrun.i &PROC='roundAmount' &PROGRAM='mcexxr.p'
                     &PARAM="(input-output ext_cost,
                              input rndmthd,
                              output mc-error-number)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
         end. /* sngl_ln */
      end. /* req_part_has_vendor_part = true */
   end.  /*if c-application-mode = "API" */

/*ricky add begin    prohibit to create PO Line when the Item has no cost*/ 
        find pt_mstr where pt_part = input pod_part no-lock no-error.
        if available pt_mstr then do:
            find sct_det where sct_sim = "Standard" and sct_site = pod_site and sct_part = input pod_part no-lock no-error.
            if (available sct_det and sct_cst_tot = 0) or (not available sct_det) then do:
                verrmsg = "���������Site��" + po_site + " û�гɱ������������ϵ��" .
                {pxmsg.i &MSGTEXT=verrmsg &ERRORLEVEL=3}
                undo, retry.
            end.
        end.
/*ricky add end*/ 

   /*SET VARIOUS FIELDS*/
   assign
      pod_part
      pod_disc_pct = disc
      pod_so_job   = so_job.

   if not ({pxfunct.i &FUNCTION='isGRSInUse' &PROGRAM='rqgrsxr.p'}) and
   pod_acct = "" then do:

      {pxrun.i &PROC='getPurchaseAccountData' &PROGRAM='adsuxr.p'
               &PARAM="(input po_vend,
                        output pod_acct,
                        output pod_sub,
                        output pod_cc)"
               &NOAPPERROR=true
               &CATCHERROR=true}
   end.


   /* IF THE USER REFERENCED A REQUISITION BUT CHANGED THE ITEM */
   /* NUMBER, SET SOME FIELDS TO NON-REQUISITION DEFAULTS       */

   {pxrun.i &PROC='validateRequisitionItem' &PROGRAM='rqrqxr.p'
            &PARAM="(input pod_part,
                     input pod_req_nbr,
                     input reqpart)"
            &NOAPPERROR=True
            &CATCHERROR=True}

   if return-value <> {&SUCCESS-RESULT} then do:
      assign
         pod_due_date = po_due_date
         pod_need     = ?
         pod_vpart    = "".
   end.


   /* CHECK VENDOR PART IN THE EVENT IT IS */
   /* IDENTICAL TO AN ITEM MASTER PART     */

   {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
            &PARAM="(input pod_part,
                     buffer pt_mstr,
                     input false,
                     input false)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if not ({pxfunct.i &FUNCTION='isGRSInUse' &PROGRAM='rqgrsxr.p'}) and
      available pt_mstr and
      not ({pxfunct.i &FUNCTION='isSuppItemAvailable' &PROGRAM='popoxr1.p'
                      &PARAM="input pod_part,
                              input po_vend,
                              input reqpart,
                              input pod_req_nbr"})
   then do:

      assign
         pod_vpart = ""
         st_um     = pt_um.

      {pxrun.i &PROC='getItemAndPriceOfLastQuote' &PROGRAM='popoxr1.p'
               &PARAM="(input pod_part,
                        input pod_qty_ord,
                        input pod_um,
                        input po_vend,
                        input po_curr,
                        input glxcst * po_ex_rate,
                        output pod_vpart,
                        output pod_pur_cost)"
               &NOAPPERROR=True
               &CATCHERROR=True}

   end. /* IF NOT USING_GRS */


   /* NO PT_MSTR OR THERE IS A VENDOR PART, REPLACE POD_PART ETC */
   if not available pt_mstr or
      ({pxfunct.i &FUNCTION='isSuppItemAvailable' &PROGRAM='popoxr1.p'
                  &PARAM="input pod_part,
                          input po_vend,
                          input reqpart,
                          input pod_req_nbr"})
   then do:

      {pxrun.i &PROC='replaceItemWithSupplierItem' &PROGRAM='popoxr1.p'
               &PARAM="(input-output pod_part,
                        input po_vend,
                        output pod_vpart,
                        output st_um)"
               &NOAPPERROR=True
               &CATCHERROR=True}

      if return-value <> {&SUCCESS-RESULT} then
         display pod_part with frame c.

   end. /*  IF not available pt_mstr */

   {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
            &PARAM="(input pod_part,
                     buffer pt_mstr,
                     input false,
                      input false)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if return-value = {&SUCCESS-RESULT} then do:
      {pxrun.i &PROC='validateRestrictedStatus' &PROGRAM='ppitxr.p'
               &PARAM="(input pt_status,
                        input 'ADD-PO')"
               &NOAPPERROR=True
               &CATCHERROR=True}

      if return-value <> {&SUCCESS-RESULT} then
         if c-application-mode <> "API" then
            undo, retry.
         else
            undo, return error.
   end.

   /* GET STANDARD COST */

   if available pt_mstr then do:

      {pxrun.i &PROC='getRemoteItemData' &PROGRAM='popoxr1.p'
               &PARAM="(input po_ord_date,
                        input pt_part,
                        input si_site,
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


   /* SET PURCHASE PRICE */
   assign
      st_um      = ""
      display_um = pod_um.

   if available pt_mstr then do:
      st_um = pt_um.

      if display_um = "" then
         display_um = pt_um.
   end.

   if pod_pur_cost = 0 then do:

      {pxrun.i &PROC='getPurchaseCost' &PROGRAM='popoxr1.p'
               &PARAM="(input pod_part,
                        input po_vend,
                        input si_site,
                        input po_curr,
                        input display_um,
                        input pod_qty_ord,
                        input po_ex_rate,
                        input po_ex_rate2,
                        input po_ord_date,
                        output pur_cost)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if pur_cost = ? or pur_cost = 0 then
         pur_cost = pod_pur_cost.

      pod_pur_cost = pur_cost.

   end.

   /* GET VENDOR ITEM */

   if available pt_mstr then do:

      {pxrun.i &PROC='getManufacturerItemDataOfLastQuote' &PROGRAM='ppsuxr.p'
               &PARAM="(input pod_part,
                        input po_vend,
                        input-output pod_vpart,
                        output mfgr,
                        output mfgr_part)"
               &NOAPPERROR=true
               &CATCHERROR=true}

   end.

   if not available pt_mstr and pod_req_nbr = "" then do:
      assign
/*N0KM*/ desc1        = caps(getTermLabel("ITEM_NOT_IN_INVENTORY",24))
         pod_qty_ord  = 0
         pod_um       = ""
         pod_pur_cost = 0
         ext_cost     = 0
         pod_vpart    = ""
         mfgr         = ""
         mfgr_part    = ""
/*N0KM*  desc1        = {&popomtea_p_2} */
         desc2        = ""
         pod_um_conv  = 1
         st_qty       = 0
         st_um        = "" .
   end.

/*N18Y*/ if not available pt_mstr
/*N18Y*/    and pod_req_nbr <> ""
/*N18Y*/ then do:

/*N18Y*/    {pxrun.i &PROC='getTaxableData' &PROGRAM='popoxr1.p'
                     &PARAM="(input po_taxc,
                              input po_taxable,
                              input po_taxable,
                              output pod_taxc,
                              output pod_taxable)"
                     &NOAPPERROR=True
                     &CATCHERROR=True}
/*N18Y*/ end. /* IF NOT AVAILABLE pt_mstr ... */

   if available pt_mstr and
      (not ({pxfunct.i &FUNCTION='isGRSInUse' &PROGRAM='rqgrsxr.p'}) or
      pod_req_nbr = "" or
      pod_part <> reqpart)
   then do:


      {pxrun.i &PROC='getTaxableData' &PROGRAM='popoxr1.p'
               &PARAM="(input pt_taxc,
                        input po_taxable,
                        input pt_taxable,
                        output pod_taxc,
                        output pod_taxable)"
               &NOAPPERROR=True
               &CATCHERROR=True}


      {pxrun.i &PROC='getAccountFieldsForLine' &PROGRAM='popoxr1.p'
               &PARAM="(input po_ord_date,
                        input pod_part,
                        input si_site,
                        input poc_insp_loc,
                        output glxcst,
                        output pod_rev,
                        output pod_loc,
                        output pod_insp_rqd,
                        output pod_acct,
                        output pod_sub,
                        output pod_cc,
                        output l_pod_type)"
               &NOAPPERROR=True
               &CATCHERROR=True}
   end. /* If available pt_mstr */
   /*SET TYPE*/
   {pxrun.i &PROC='getPOLineTypeAndTaxFlag' &PROGRAM='popoxr1.p'
            &PARAM="(input pod_part,
                     input l_pod_type,
                     input po_taxable,
                     input-output pod_type,
                     input-output pod_taxable)"
            &NOAPPERROR=True
            &CATCHERROR=True}
   continue = yes.
end.

/*============================================================================*/
/*******************************Internal Procedures ***************************/
/*============================================================================*/

PROCEDURE costItemInfo:

   define parameter buffer bVpMstr for vp_mstr.
   define parameter buffer bPodDet for pod_det.
   define parameter buffer bPoMstr for po_mstr.
   define parameter buffer bPtMstr for pt_mstr.
   define parameter buffer bSiMstr for si_mstr.


   define input parameter bDisplayUm like bPodDet.pod_um no-undo.
   define variable bMfgr like bVpMstr.vp_mfgr no-undo.
   define variable bMfgrPart like bVpMstr.vp_mfgr_part no-undo.


   {pxrun.i &PROC='getPurchaseCost' &PROGRAM='popoxr1.p'
            &PARAM="(input pt_part,
                     input po_vend,
                     input si_site,
                     input po_curr,
                     input display_um,
                     input pod_qty_ord,
                     input po_ex_rate,
                     input po_ex_rate2,
                     input po_ord_date,
                     output pur_cost)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if pur_cost = ? or pur_cost = 0 then
      pur_cost = pod_pur_cost.

   assign
      desc1      = pt_desc1
      desc2      = pt_desc2
      st_qty     = 0
      st_um      = pt_um
      display_um = pt_um
      vpart      = "".

   {pxrun.i &PROC='getManufacturerItemDataOfLastQuote'
            &PROGRAM='ppsuxr.p'
            &PARAM="(input pt_part,
                     input po_vend,
                     input-output vpart,
                     output mfgr,
                     output mfgr_part)"
            &NOAPPERROR=true
            &CATCHERROR=true}

END PROCEDURE.

PROCEDURE vpMstrAvailable:


   define variable pur_cost like pod_pur_cost no-undo.
   define variable vpumconv like um_conv no-undo.

   define parameter buffer bVpMstr for vp_mstr.
   define parameter buffer bPodDet for pod_det.
   define parameter buffer bSiMstr for si_mstr.
   define parameter buffer bPoMstr for po_mstr.

   pur_cost = ?.

   /* GET VENDOR ITEM COST */
   vpumconv = 1.

   if vp_um <> pod_um then do:
      {gprun.i ""gpumcnv.p""
               "(input vp_um,
                 input pod_um,
                 input vp_part,
                 output vpumconv)"}
   end.

   if vpumconv <> ? then do:
      if pod_qty_ord >= vp_q_qty * vpumconv and
      vp_q_price > 0 and
      vp_curr = po_curr
      then do:
         pur_cost = vp_q_price / vpumconv.
      end.
   end.

   if pur_cost = ? then do:

      /* DIDNT FIND IT, GET STANDARD COST */

      {pxrun.i &PROC='processRead' &PROGRAM='ppitxr.p'
               &PARAM="(input pod_part,
                        buffer pt_mstr,
                        input false,
                        input false)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value = {&SUCCESS-RESULT} then do:

         {pxrun.i &PROC='getRemoteItemData' &PROGRAM='popoxr1.p'
                  &PARAM="(input po_ord_date,
                           input pt_part,
                           input si_site,
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

         conversion_factor = 1.

         if pod_um <> pt_um then do:
            {gprun.i ""gpumcnv.p""
                      "(input pt_um,
                        input pod_um,
                        input pt_part,
                        output conversion_factor)"}
         end.

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
                   "(input base_curr,
                     input po_curr,
                     input po_ex_rate2,
                     input po_ex_rate,
                     input (glxcst / conversion_factor),
                     input false, /* DO NOT ROUND */
                     output pur_cost,
                     output mc-error-number)"}
      end.
   end.

      if pur_cost = ? or pur_cost = 0 then
         pur_cost = pod_pur_cost.

END PROCEDURE.