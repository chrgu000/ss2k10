/* popomtb.p - PURCHASE ORDER MAINTENANCE -- ORDER HEADER SUBPROGRAM          */
/* Copyright 1986 QAD Inc. All rights reserved.                               */
/* $Id:: popomtb.p 27571 2013-01-15 07:42:15Z j2x                          $: */
/*                                                                            */
/* Revision: 7.0           BY: ram                DATE: 09/12/91  ECO: *F033* */
/* Revision: 7.0           BY: mlv                DATE: 11/08/91  ECO: *F029* */
/* Revision: 7.0           BY: afs                DATE: 07/01/92  ECO: *F727* */
/* Revision: 7.3           BY: tjs                DATE: 08/06/92  ECO: *G027* */
/* Revision: 7.3           BY: tjs                DATE: 09/29/92  ECO: *G028* */
/* Revision: 7.3           BY: tjs                DATE: 10/02/92  ECO: *G117* */
/* Revision: 7.3           BY: wug                DATE: 10/09/92  ECO: *G153* */
/* Revision: 7.3           BY: mpp                DATE: 10/22/92  ECO: *G481* */
/* Revision: 7.3           BY: bcm                DATE: 02/22/93  ECO: *G717* */
/* Revision: 7.3           BY: tjs                DATE: 02/23/93  ECO: *G735* */
/* Revision: 7.3           BY: tjs                DATE: 03/19/93  ECO: *G815* */
/* Revision: 7.3           BY: afs                DATE: 04/29/93  ECO: *G972* */
/* Revision: 7.4           BY: jjs                DATE: 06/08/93  ECO: *H006* */
/* Revision: 7.4           BY: bcm                DATE: 08/09/93  ECO: *H062* */
/* Revision: 7.4           BY: tjs                DATE: 11/22/93  ECO: *H082* */
/* Revision: 7.4           BY: cdt                DATE: 09/28/93  ECO: *H086* */
/* Revision: 7.4           BY: cdt                DATE: 10/23/93  ECO: *H184* */
/* Revision: 7.4           BY: bcm                DATE: 12/28/93  ECO: *H269* */
/* Revision: 7.4           BY: cdt                DATE: 03/03/94  ECO: *H288* */
/* Revision: 7.4           BY: bcm                DATE: 03/22/94  ECO: *H299* */
/* Revision: 7.4           BY: bcm                DATE: 07/29/94  ECO: *H465* */
/* Revision: 7.4           BY: bcm                DATE: 09/13/94  ECO: *H516* */
/* Revision: 7.4           BY: bcm                DATE: 09/29/94  ECO: *H541* */
/* Revision: 8.5           BY: mwd                DATE: 10/18/94  ECO: *J034* */
/* Revision: 7.4           BY: mmp                DATE: 10/31/94  ECO: *H582* */
/* Revision: 7.5           BY: dpm                DATE: 02/21/95  ECO: *J044* */
/* Revision: 7.4           BY: jzw                DATE: 02/23/95  ECO: *H0BM* */
/* Revision: 7.4           BY: wjk                DATE: 03/06/95  ECO: *H0BT* */
/* Revision: 7.4           BY: srk                DATE: 03/20/95  ECO: *H0C4* */
/* Revision: 7.4           BY: dzn                DATE: 03/29/95  ECO: *F0PN* */
/* Revision: 7.4           BY: ais                DATE: 09/19/95  ECO: *G0X6* */
/* Revision: 8.5           BY: dpm                DATE: 10/27/95  ECO: *J08Y* */
/* Revision: 8.5           BY: taf                DATE: 09/27/95  ECO: *J053* */
/* Revision: 8.5           BY: rxm                DATE: 02/16/96  ECO: *H0JR* */
/* Revision: 8.5           BY: rxm                DATE: 03/04/96  ECO: *F0X2* */
/* Revision: 8.5           BY: taf                DATE: 07/18/96  ECO: *J0ZS* */
/* Revision: 8.5           BY: Aruna P.Patil      DATE: 09/18/96  ECO: *H0MV* */
/* Revision: 8.5           BY: Aruna P.Patil      DATE: 10/20/96  ECO: *H0ND* */
/* Revision: 8.5           BY: Jim Josey          DATE: 01/07/98  ECO: *J29D* */
/* Revision: 8.6E          BY: Annasaheb Rahane   DATE: 02/23/98  ECO: *L007* */
/* Revision: 8.6E          BY: Dana Tunstall      DATE: 03/23/98  ECO: *J2GF* */
/* Revision: 8.6E          BY: Alfred Tan         DATE: 05/20/98  ECO: *K1Q4* */
/* Revision: 8.6E          BY: Charles Yen        DATE: 06/02/98  ECO: *L020* */
/* Revision: 8.6E          BY: Dana Tunstall      DATE: 08/07/98  ECO: *K1QS* */
/* Revision: 8.6E          BY: Dana Tunstall      DATE: 08/07/98  ECO: *K1RJ* */
/* Revision: 9.1           BY: Patti Gaultney     DATE: 10/01/99  ECO: *N014* */
/* Revision: 9.1           BY: Satish Chavan      DATE: 08/16/99  ECO: *K226* */
/* Revision: 9.1           BY: Thelma Stronge     DATE: 03/06/00  ECO: *N05Q* */
/* Revision: 9.1           BY: Annasaheb Rahane   DATE: 03/24/00  ECO: *N08T* */
/* Revision: 1.15.3.5      BY: Niranjan Ranka     DATE: 05/24/00  ECO: *N0C7* */
/* Revision: 1.15.3.6      BY: Mudit Mehta        DATE: 07/03/00  ECO: *N0F3* */
/* Revision: 1.15.3.7      BY: Niranjan Ranka     DATE: 07/13/00  ECO: *N0DS* */
/* Revision: 1.15.3.8      BY: Pat Pigatti        DATE: 07/14/00  ECO: *N0G2* */
/* Revision: 1.15.3.9      BY: Mark B. Smith      DATE: 04/17/00  ECO: *N059* */
/* Revision: 1.15.3.13     BY: Mudit Mehta        DATE: 09/29/00  ECO: *N0W9* */
/* Revision: 1.15.3.14     BY: Steven Nugent      DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.15.3.15     BY: Tiziana Giustozzi  DATE: 05/24/02  ECO: *P03Z* */
/* Revision: 1.15.3.16     BY: Jean Miller        DATE: 06/06/02  ECO: *P080* */
/* Revision: 1.15.3.17     BY: Rajaneesh Sarangi  DATE: 06/19/02  ECO: *N1H7* */
/* Revision: 1.15.3.18     BY: Robin McCarthy     DATE: 07/15/02  ECO: *P0BJ* */
/* Revision: 1.15.3.19     BY: Rajaneesh S.       DATE: 08/29/02  ECO: *M1BY* */
/* Revision: 1.15.3.23     BY: Laurene Sheridan   DATE: 10/17/02  ECO: *N13P* */
/* Revision: 1.15.3.25     BY: Deepali KotavadekarDATE: 03/31/03  ECO: *P0PK* */
/* Revision: 1.15.3.27     BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00J* */
/* Revision: 1.15.3.29     BY: Nishit V           DATE: 08/02/03  ECO: *P0Y8* */
/* Revision: 1.15.3.30     BY: Nishit V           DATE: 08/02/03  ECO: *Q01Z* */
/* Revision: 1.15.3.31     BY: Ed van de Gevel    DATE: 12/24/03  ECO: *Q04S* */
/* Revision: 1.15.3.33     BY: Preeti Sattur      DATE: 01/27/04  ECO: *P1LG* */
/* Revision: 1.15.3.34     BY: Ed van de Gevel    DATE: 03/07/05  ECO: *R00K* */
/* Revision: 1.15.3.35     BY: Robin McCarthy     DATE: 09/07/05  ECO: *P2PJ* */
/* Revision: 1.15.3.36     BY: Sushant Pradhan    DATE: 02/08/06  ECO: *P3XF* */
/* Revision: 1.15.3.37     BY: Robin McCarthy     DATE: 05/11/06  ECO: *P4JX* */
/* Revision: 1.15.3.38     BY: Changlin Zeng      DATE: 05/17/06  ECO: *R045* */
/* Revision: 1.15.3.39     BY: Robin McCarthy     DATE: 05/31/06  ECO: *R02F* */
/* Revision: 1.15.3.40     BY: Rafiq S.           DATE: 11/09/06  ECO: *P5DQ* */
/* Revision: 1.15.3.41     BY: Russ Witt          DATE: 03/19/07  ECO: *P5RF* */
/* Revision: 1.15.3.44     BY: Jean Miller        DATE: 03/21/07  ECO: *R0C5* */
/* Revision: 1.15.3.45     BY: Anju Dubey         DATE: 12/12/07  ECO: *P6GV* */
/* Revision: 1.15.3.46     BY: Robin McCarthy     DATE: 01/11/08  ECO: *R08C* */
/* Revision: 1.15.3.47     BY: Neil Curzon        DATE: 05/01/09  ECO: *R1HB* */
/* Revision: 1.15.3.48     BY: Shridhar Mangalore DATE: 08/08/09  ECO: *R1P8* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */

{us/bbi/mfdeclre.i}
{us/bbi/gplabel.i}  /* EXTERNAL LABEL INCLUDE */
{us/px/pxmaint.i}
{us/px/pxphdef.i gpcodxr}
{us/px/pxphdef.i adcrxr}
{us/pp/ppprlst.i}   /* PRICE LIST CONSTANTS */
{us/ed/eddsdef.i}
{us/tx/txusgdef.i}  /* PRE-PROCESSOR CONSTANTS FOR I19 */

/*============================================================================*/
/* ****************************** Definitions ******************************* */
/*============================================================================*/

define input parameter p_consignment like mfc_logical no-undo.

/* NEW SHARED VARIABLES */
define new shared variable tax_nbr     like tx2d_nbr initial "".
define new shared variable tax_tr_type like tx2d_tr_type initial "20".
define new shared variable undo_all    like mfc_logical.

/* SHARED VARIABLES */
define shared variable blanket     as logical.
define shared variable line_opened as logical.
define shared variable po_recno    as recid.
define shared variable rndmthd     like rnd_rnd_mthd.
define shared variable line        like pod_line.
define shared variable due_date    like pod_due_date.
define shared variable del-yn      like mfc_logical.
define shared variable qty_ord     like pod_qty_ord.
define shared variable so_job      like pod_so_job.
define shared variable disc        like pod_disc label "Ln Disc".
define shared variable ponbr       like po_nbr.
define shared variable old_po_stat like po_stat.
define shared variable old_rev     like po_rev.
define shared variable pocmmts     like mfc_logical label "Comments".
define shared variable new_po      like mfc_logical.
define shared variable new_db      like si_db.
define shared variable old_db      like si_db.
define shared variable new_site    like si_site.
define shared variable old_site    like si_site.
define shared variable continue    like mfc_logical no-undo.
define shared variable impexp      like mfc_logical no-undo.

/* SHARED FRAMES */
define shared frame a.
define shared frame b.
define shared frame vend.
define shared frame ship_to.

/* LOCAL VARIABLES */
define variable con-yn            like mfc_logical.
define variable poc_pt_req        like mfc_logical.
define variable imp-okay          like mfc_logical        no-undo.
define variable old_ord_date      like po_ord_date        no-undo.
define variable old_pr_list2      like po_pr_list2        no-undo.
define variable old_curr          like po_curr            no-undo.
define variable old_fix_pr        like po_fix_pr          no-undo.
define variable old_posite        like po_site            no-undo.
define variable l_pocrt_int       like po_crt_int         no-undo.
define variable use-log-acctg     as   logical            no-undo.
define variable la-okay           like mfc_logical        no-undo.
define variable l_doc_name        like edmf_mfd_name      no-undo.
define variable l_doc_version     like edmf_mfd_vers      no-undo.
define variable l_index           as   integer            no-undo.
define variable deleteRequested   as   logical            no-undo.
define variable cErrorArgs        as   character          no-undo.
define variable is-valid          as   logical            no-undo.
define variable l_avail           as   logical initial no no-undo.
define variable cr_terms          like po_cr_terms        no-undo.

/* VARIABLES FOR CONSIGNMENT INVENTORY */
{us/po/pocnvars.i}
{us/po/pocnpo.i} /* Consignment procedures */

using_supplier_consignment = p_consignment.

{us/gp/gptxcdec.i}  /* DECLARATIONS FOR gptxcval.i */

/* COMMON API CONSTANTS AND VARIABLES */
{us/mf/mfaimfg.i}

/* Purchase Order API TEMP-TABLE, NAMED USING THE "Api" PREFIX */
{us/po/popoit01.i}

/*Import Export api temp table*/
{us/ic/icieit01.i}

/* PURCHASE ORDER MAINTENANCE API dataset definition */
{us/po/podsmt.i "reference-only"}

define variable daybookSetBySiteInstalled like mfc_logical no-undo.
define variable hDaybooksetValidation as handle    no-undo.
define variable iErrorNumber          as integer   no-undo.
define variable daybookDate           as date       no-undo.
define variable lLegacyAPI            as logical no-undo.

/* DAYBOOKSET VALIDATION LIBRARY PROTOTYPES */
{us/dy/dybvalpl.i hDaybooksetValidation}

/* INITIALIZE PERSISTENT PROCEDURES */
run mfairunh.p
   (input "dybvalpl.p",
    input ?,
    output hDaybooksetValidation).

run setvalidMode in hDaybooksetValidation
               (input  true).

if c-application-mode = "API"
then do on error undo, return:

   /* Get handle of API Controller */
   {us/bbi/gprun.i ""gpaigach.p"" "(output ApiMethodHandle)"}

   if valid-handle(ApiMethodHandle) then do:
      /* Get the PURCHASE ORDER MAINTENANCE API dataset from the controller */
      run getRequestDataset in ApiMethodHandle (
         output dataset dsPurchaseOrder bind).

      lLegacyAPI = false.
   end.
   else do:
      /* GET HANDLE OF API CONTROLLER */
      {us/bbi/gprun.i ""gpaigh.p""
                        "(output ApiMethodHandle,
                          output ApiProgramName,
                          output ApiMethodName,
                          output apiContextString)"}

      /* GET LOCAL PO MASTER TEMP-TABLE */
      create ttPurchaseOrder.
      run getPurchaseOrderRecord in ApiMethodHandle
         (buffer ttPurchaseOrder).

      if ttPurchaseOrder.impexp = yes
      then do:
         create ttImportExport.
         run setImportExportRow in ApiMethodHandle
             (ttImportExport.apiSequence).
         run getImportExportRecord in ApiMethodHandle
             (buffer ttImportExport).
      end. /* IF ttPurchaseOrder.impexp = yes */
      lLegacyAPI = true.
   end.

end.  /* If c-application-mode = "API" */
/* FRAMES AND FORMS */
{us/po/popomt02.i}  /* Shared frames a and b */

/* TAX MANAGEMENT FORM */
form
   po_tax_usage colon 25
   po_tax_env   colon 25
   space(1)
   po_taxc      colon 25
   po_taxable   colon 25
   po_tax_in    colon 25
with frame set_tax row 8 centered overlay side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame set_tax:handle).

{us/mf/mfadform.i "vend" 1 SUPPLIER}
{us/mf/mfadform.i "ship_to" 41 SHIP_TO}

/*============================================================================*/
/* ****************************** Main Block ******************************** */
/*============================================================================*/

/* SETUP */
for first po_mstr exclusive-lock
   where recid(po_mstr) = po_recno:
end.
for first vd_mstr no-lock
    where vd_mstr.vd_domain = global_domain and  vd_addr = po_vend:
end.

/* GET CONTROL RECORDS */
for first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock:
end.
for first gl_ctrl   where gl_ctrl.gl_domain = global_domain no-lock:
end.
for first iec_ctrl  where iec_ctrl.iec_domain = global_domain no-lock:
end.

assign daybookSetBySiteInstalled = poc_dybkset_by_site.


/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{us/bbi/gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* GET DISCOUNT TABLE SETTING */
{us/po/popcdisc.i}


order-header:
do on error undo, retry on endkey undo, leave with frame b:
   if retry and c-application-mode = "API" then
      return error.

   if c-application-mode = "API" and not lLegacyAPI then do:
      run getNextRecord in ApiMethodHandle (input "ttPurchaseOrderHeader").
      if return-value = {&RECORD-NOT-FOUND} then leave order-header.
   end.

   ststatus = stline[2].
   status input ststatus.
   assign del-yn = no
      disc = po_disc_pct.

   if not new_po
   then do:
      {us/px/pxrun.i &PROC='validateNotPrinted' &PROGRAM='popoxr.p'
         &PARAM="(input po_print)"
         &NOAPPERROR=true
         &CATCHERROR=true}
   end.

   impexp = no.

   /* SET THE DEFAULT VALUE BASED ON IEC_CTRL FILE */
   if available iec_ctrl and iec_impexp = yes then
      impexp = yes.

   assign
      old_po_stat = po_stat
      line_opened = false
      old_rev     = po_rev
      old_posite  = po_site
      l_pocrt_int = po_crt_int.
   if not new_po then do:
      find ie_mstr
         where ie_mstr.ie_domain = global_domain and  ie_type = "2"
         and ie_nbr  = po_nbr
      no-lock no-error.
      impexp = available ie_mstr.
   end.
   else if impexp then do:
      {us/bbi/gprun.i ""ieckcty2.p""
         "(input po_vend, input po_ship, input '2', output impexp)"}
   end.

   if new_po then
      assign po_site = vd_site.

   if po_daybookset = ""
   then do:
      if daybookSetBySiteInstalled then do:
         for first dybs_mstr where dybs_domain = global_domain
                               and dybs_type = '2'
                               and dybs_site = po_site
                               and dybs_code = vd_daybookset
         no-lock:
            assign  po_daybookset = dybs_code.
         end.
         if po_daybookset = "" then do:
           for first dybs_mstr where dybs_domain = global_domain
                                 and dybs_type = '2'
                                 and dybs_site = ''
           no-lock:
            assign  po_daybookset = dybs_code.
           end.
         end.
         if po_daybookset = "" then
            assign
               po_daybookset = getDefaultDaybookSetBySite( input po_vend).
      end.
      else
      assign
         po_daybookset = getDefaultDaybookSetBySite( input po_vend).
   end.


   if c-application-mode <> "API" then
      display
         po_ord_date po_due_date po_buyer po_bill
         so_job po_contract po_contact po_rmks
         po_pr_list2 po_pr_list disc po_site
         po_daybookset
         po_project po_confirm po_curr po_lang
         po_taxable po_taxc po_tax_date po_fix_pr
         po_consignment
         po_cr_terms
         po_crt_int
         po_req_id pocmmts
         impexp
      with frame b.

   setb:
   do on error undo, retry:
      if retry and c-application-mode = "API" then
         return error.

      assign
         old_ord_date     = po_ord_date
         old_pr_list2     = po_pr_list2
         old_curr         = po_curr
         old_fix_pr       = po_fix_pr
         deleteRequested  = no.

      /* Rearranged frame b */
      if c-application-mode <> "API"
      then do:
         set
            po_ord_date po_due_date po_buyer po_bill
            so_job po_contract po_contact po_rmks
            po_pr_list2 po_pr_list disc po_site
            po_daybookset
            po_project po_confirm impexp
            po_curr when (new_po) po_lang when (new_po)
            po_taxable po_taxc po_tax_date po_fix_pr
            po_consignment when (using_supplier_consignment)
            po_cr_terms
            po_crt_int
            po_req_id pocmmts
            go-on ("F5" "CTRL-D") with frame b no-validate
         editing:
            readkey.
            if frame-field = "po_cr_terms"
            then do:
               if new_po
                  and (lastkey = keycode("RETURN") or
                       lastkey = keycode("CTRL-X") or
                       lastkey = keycode("F1"))
               then do:
                  {us/px/pxrun.i &PROC='getCreditTermsInterest' &PROGRAM='adcrxr.p'
                     &HANDLE=ph_adcrxr
                     &PARAM="(input po_cr_terms:screen-value,
                              output po_crt_int)"}

                  display po_crt_int.
               end.
            end. /* if frame-field = "po_cr_terms" */
            apply lastkey.
         end. /* Editing */

         if available iec_ctrl
         and iec_ctrl.iec_use_instat = yes
         then do:
            for each pod_det
               where pod_det.pod_domain = global_domain
               and   pod_det.pod_nbr    = po_nbr
               and   pod_det.pod_line   > 0
            no-lock:
               if pod_um = ""
               then do:
                  assign
                     l_avail = true.
                  leave.
               end.
            end.

            if l_avail and impexp
            then do:
               {us/bbi/pxmsg.i
                &MSGNUM=12791
               &ERRORLEVEL=3
               }
               undo setb.
            end.
         end.
      end.  /* if c-application-mode <>"API"*/
      else       /* if c-application-mode = "API"*/
      do:
         if lLegacyAPI then
         assign
            {us/mf/mfaiset.i po_ord_date ttPurchaseOrder.ordDate}
            {us/mf/mfaiset.i po_due_date ttPurchaseOrder.dueDate}
            {us/mf/mfaiset.i po_buyer ttPurchaseOrder.buyer}
            {us/mf/mfaiset.i po_bill ttPurchaseOrder.bill}
            {us/mf/mfaiset.i so_job ttPurchaseOrder.soJob}
            {us/mf/mfaiset.i po_contract ttPurchaseOrder.contract}
            {us/mf/mfaiset.i po_contact ttPurchaseOrder.contact}
            {us/mf/mfaiset.i po_rmks ttPurchaseOrder.rmks}
            {us/mf/mfaiset.i po_pr_list2 ttPurchaseOrder.prList2}
            {us/mf/mfaiset.i po_pr_list ttPurchaseOrder.prList}
            {us/mf/mfaiset.i disc ttPurchaseOrder.discPct}
            {us/mf/mfaiset.i po_site ttPurchaseOrder.site}
            {us/mf/mfaiset.i po_project ttPurchaseOrder.project}
            {us/mf/mfaiset.i po_confirm ttPurchaseOrder.confirm}
            {us/mf/mfaiset.i impexp ttPurchaseOrder.impexp}
            {us/mf/mfaiset.i po_curr ttPurchaseOrder.curr} when (new_po)
            {us/mf/mfaiset.i po_lang ttPurchaseOrder.lang} when (new_po)
            {us/mf/mfaiset.i po_taxable ttPurchaseOrder.taxable}
            {us/mf/mfaiset.i po_taxc ttPurchaseOrder.taxc}
            {us/mf/mfaiset.i po_tax_date ttPurchaseOrder.taxDate}
            {us/mf/mfaiset.i po_fix_pr ttPurchaseOrder.fixPr}
            {us/mf/mfaiset.i po_cr_terms ttPurchaseOrder.crTerms}
            {us/mf/mfaiset.i po_crt_int ttPurchaseOrder.pocrtInt}
            {us/mf/mfaiset.i po_req_id ttPurchaseOrder.reqId}
            pocmmts = yes
            .
         else
         assign
            {us/mf/mfaiset.i po_ord_date ttPurchaseOrderHeader.poOrdDate}
            {us/mf/mfaiset.i po_due_date ttPurchaseOrderHeader.poDueDate}
            {us/mf/mfaiset.i po_buyer ttPurchaseOrderHeader.poBuyer}
            {us/mf/mfaiset.i po_bill ttPurchaseOrderHeader.poBill}
            {us/mf/mfaiset.i so_job ttPurchaseOrderHeader.soJob}
            {us/mf/mfaiset.i po_contract ttPurchaseOrderHeader.poContract}
            {us/mf/mfaiset.i po_contact ttPurchaseOrderHeader.poContact}
            {us/mf/mfaiset.i po_rmks ttPurchaseOrderHeader.poRmks}
            {us/mf/mfaiset.i po_pr_list2 ttPurchaseOrderHeader.poPrList2}
            {us/mf/mfaiset.i po_pr_list ttPurchaseOrderHeader.poPrList}
            {us/mf/mfaiset.i disc ttPurchaseOrderHeader.disc}
            {us/mf/mfaiset.i po_site ttPurchaseOrderHeader.poSite}
            {us/mf/mfaiset.i po_daybookset ttPurchaseOrderHeader.poDayBookSet}
            {us/mf/mfaiset.i po_project ttPurchaseOrderHeader.poProject}
            {us/mf/mfaiset.i po_confirm ttPurchaseOrderHeader.poConfirm}
            {us/mf/mfaiset.i impexp ttPurchaseOrderHeader.impexp}
            {us/mf/mfaiset.i po_curr ttPurchaseOrderHeader.poCurr} when (new_po)
            {us/mf/mfaiset.i po_lang ttPurchaseOrderHeader.poLang} when (new_po)
            {us/mf/mfaiset.i po_taxable ttPurchaseOrderHeader.poTaxable}
            {us/mf/mfaiset.i po_taxc ttPurchaseOrderHeader.poTaxc}
            {us/mf/mfaiset.i po_tax_date ttPurchaseOrderHeader.poTaxDate}
            {us/mf/mfaiset.i po_fix_pr ttPurchaseOrderHeader.PoFixPr}
            {us/mf/mfaiset.i po_consignment
            ttPurchaseOrderHeader.poConsignment}
            when (using_supplier_consignment)
            {us/mf/mfaiset.i po_cr_terms ttPurchaseOrderHeader.poCrTerms}
            {us/mf/mfaiset.i po_crt_int ttPurchaseOrderHeader.poCrtInt}
            {us/mf/mfaiset.i po_req_id ttPurchaseOrderHeader.poReqId}
            {us/mf/mfaiset.i pocmmts ttPurchaseOrderHeader.pocmmts}
            .

         if not({gpsite.v &field=po_site &blank_ok=yes})
         then do:
            {us/bbi/pxmsg.i &MSGNUM=2797 &ERRORLEVEL=3 &MSGARG1=po_site}
            undo, return error.
         end. /* end of if valid site*/

         {us/px/pxrun.i &PROC  = 'validateGeneralizedCodes' &PROGRAM = 'gpcodxr.p'
                        &HANDLE=ph_gpcodxr
                        &PARAM="(input 'po_buyer',
                                input '',
                                input po_buyer,
                                input {&SUPPRESS-MSG})"
                        &NOAPPERROR=True
                        &CATCHERROR=True}
         if return-value <> {&SUCCESS-RESULT} then do:
            {us/bbi/pxmsg.i &MSGNUM=716 &ERRORLEVEL=4
                     &MSGARG1=po_nbr &MSGARG2=po_buyer}
            undo, return error.
         end.
      end. /*end if C-APPLICATION-MODE = API */

      /* SAVE IF USER REQUESTED TO DELETE PO */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
         then deleteRequested = yes.


      /* IF NOT A CONSIGNED PO, THEN RESET COST POINT TO BLANK */
      /* (DEFAULTING OF CONSIGNMENT FIELDS OCCURS BEFORE USER  */
      /* HAS UPDATED THE CONSIGNMENT FLAG.)                    */
      if not po_consignment
            and (not can-find(first pod_det no-lock
                                 where pod_domain      = global_domain
                                 and   pod_nbr         = po_nbr
                                 and   pod_consignment = yes))
      then
         po_consign_cost_point = "".

      /* CHECKS FOR ACCESS ON PO ORDER DATE */
      if po_ord_date <> old_ord_date
      then do:
         {us/px/pxrun.i &PROC='validatePOOrderDate'
                  &PROGRAM='popoxr.p'
                  &PARAM="(input po_ord_date)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API"
            then do:
               next-prompt po_ord_date with frame b no-validate.
               undo setb, retry setb.
            end.  /*if c-application-mode <>"API"*/
            else  /*if c-application-mode = "API"*/
               undo, return error.
         end.  /* if return-value <> {&SUCCESS-RESULT} then do: */
      end. /* IF po_ord_date <> old_ord_date */

      /* Validate daybook set code */

      daybookDate = today.
      if po_due_date <> ? and po_due_date > today then
         daybookDate = po_due_date.

      if daybookSetBySiteInstalled
      then do:
         /* VALIDATE DAYBOOK SET BY SITE */
         run validateDaybookSet in hDaybookSetValidation
            ( input  po_daybookset,
              input  po_site,
              input  daybookDate,
              output iErrorNumber,
              output cErrorArgs).

         if iErrorNumber > 0
         then do:
            run displayPxMsg in hDaybooksetValidation
               (input iErrorNumber, input 3, input cErrorArgs).
            if c-application-mode <> "API" then
               next-prompt po_daybookset with frame b.
            undo, retry.
         end.
      end.

      else do:
         /* IS IT A ACTIVE DAYBOOKSET CODE? */
         run validateDaybookSet in hDaybooksetValidation
            ( input  po_daybookset,
              input  "",
              input  daybookDate,
              output iErrorNumber,
              output cErrorArgs).

         if iErrorNumber > 0
         then do:
            run displayPxMsg in hDaybooksetValidation
               ( input iErrorNumber, input 3, input cErrorArgs).
            if c-application-mode <> "API" then
               next-prompt po_daybookset with frame b.
            undo, retry.
         end.
      end.

      /* VALIDATES PO CREDIT TERMS */
      {us/px/pxrun.i &PROC='validateCreditTerms' &PROGRAM='adcrxr.p'
                     &HANDLE=ph_adcrxr
                     &PARAM="(input po_cr_terms)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT}
      then do:
         /* INVALID CREDIT TERMS */
         {us/bbi/pxmsg.i &MSGNUM=2341 &ERRORLEVEL=3
         &FIELDNAME=""poCrTerms""}
         if c-application-mode <> "API"
         then do:
            next-prompt po_cr_terms with frame b no-validate.
            undo setb, retry setb.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* VALIDATES ON PO BUYER */
      {us/px/pxrun.i &PROC='validatePOBuyer' &PROGRAM='popoxr.p'
               &PARAM="(input po_buyer)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_buyer with frame b no-validate.
            undo setb, retry setb.
         end.   /*if c-application-mode <>"API"*/
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* CHECKS FOR ACCESS ON PO PRICE TABLE */
      if po_pr_list2 <> old_pr_list2
      then do:
         {us/px/pxrun.i &PROC='validatePOPriceList2' &PROGRAM='popoxr.p'
                  &PARAM="(input po_pr_list2)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API"
            then do:
               next-prompt po_pr_list2 with frame b no-validate.
               undo setb, retry setb.
            end.
            else   /*if c-application-mode = "API"*/
               undo, return error.
         end.  /*return-value <> {&SUCCESS-RESULT}*/
      end. /* IF po_pr_list2 <> old_pr_list2 */

      /* VALIDATES ON PO SITE */
      {us/px/pxrun.i &PROC='validatePOSite' &PROGRAM='popoxr.p'
               &PARAM="(input po_site)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_site with frame b no-validate.
            undo setb, retry setb.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* VALIDATION ON PO SITE FOR EDI PO'S */

      for first edtpparm_mstr
         where edtpparm_domain = ecom_domain
         and   edtpparm_addr   = po_vend
         and   po_site         = ""
      no-lock:

         empty temp-table ttTradingPartnerParameters.
         create ttTradingPartnerParameters.
         assign
            ttTradingPartnerParameters.domain = edtpparm_domain
            ttTradingPartnerParameters.AppSite = edtpparm_site
            ttTradingPartnerParameters.AppAddress = edtpparm_addr
            ttTradingPartnerParameters.Sequence = 1
            ttTradingPartnerParameters.ParameterType = "CHARACTER"
            ttTradingPartnerParameters.ParameterName = "PO Doc Name"
            ttTradingPartnerParameters.ParameterFound = no.

         create ttTradingPartnerParameters.
         assign
            ttTradingPartnerParameters.domain = edtpparm_domain
            ttTradingPartnerParameters.AppSite = edtpparm_site
            ttTradingPartnerParameters.AppAddress = edtpparm_addr
            ttTradingPartnerParameters.Sequence = 2
            ttTradingPartnerParameters.ParameterType = "INTEGER"
            ttTradingPartnerParameters.ParameterName = "PO Doc Vers"
            ttTradingPartnerParameters.ParameterFound = no.

         {us/px/pxrun.i &proc = 'GetParameterValues'
                        &program = 'edparams.p'
                        &handle  = h_edparams
                        &param   = "(input-output dataset TpParam-dset by-reference)"
                        &catcherror = true
                        &noaperror = true}

         for first ttTradingPartnerParameters where
            ttTradingPartnerParameters.Sequence = 1 and
            ttTradingPartnerParameters.ParameterFound = yes:
            l_doc_name = ttTradingPartnerParameters.ParameterValue no-error.
         end.
         for first ttTradingPartnerParameters where
            ttTradingPartnerParameters.Sequence = 2 and
            ttTradingPartnerParameters.ParameterFound = yes:
            l_doc_version = integer(ttTradingPartnerParameters.ParameterValue) no-error.
         end.

         if l_doc_name        <> ""
            and l_doc_version <> 0
         then do:
            {us/bbi/pxmsg.i &MSGNUM=6450 &ERRORLEVEL=2 &PAUSEAFTER=TRUE}
         end.  /* IF l_doc_name */
      end.   /* FOR FIRST edtpparm_mstr */

      /* CHECK IF USER IS AUTHORIZED TO ACCESS */
      /* PURCHASE ORDER HEADER SITE            */
      {us/px/pxrun.i &PROC='validateSiteSecurity' &PROGRAM='icsixr.p'
               &PARAM="(input po_site,
                        input '')"
               &NOAPPERROR=True
               &CATCHERROR=True}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt
               po_site
            with frame b no-validate.
            undo setb, retry setb.
         end. /* IF c-application-mode <> "API" */
         else
         if c-application-mode = "API"
         then
            undo, return error.
      end. /* IF return-value <> {&SUCCESS-RESULT} */

      /* VALIDATES ON PO PROJECT */
      {us/px/pxrun.i &PROC='validatePOProject' &PROGRAM='popoxr.p'
               &PARAM="(input po_project)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_project with frame b no-validate.
            undo setb, retry setb.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* CHECKS FOR ACCESS ON PO CURRENCY */
      if po_curr <> old_curr
      then do:
         {us/px/pxrun.i &PROC='validatePOCurrency' &PROGRAM='popoxr.p'
                  &PARAM="(input po_curr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API"
            then do:
               next-prompt po_curr with frame b no-validate.
               undo setb, retry setb.
            end.
            else   /*if c-application-mode = "API"*/
               undo, return error.
         end.  /* if return-value <> {&SUCCESS-RESULT} then do: */
      end. /* IF po_curr <> old_curr */

      /* VALIDATES ON PO LANGUAGE */
      {us/px/pxrun.i &PROC='validatePOLanguage' &PROGRAM='popoxr.p'
               &PARAM="(input po_lang)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_lang with frame b no-validate.
            undo setb, retry setb.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT} then do: */

      /* CHECKS FOR ACCESS ON PO FIXED PRICE */
      if po_fix_pr <> old_fix_pr then do:
         {us/px/pxrun.i &PROC='validatePOFixedPrice' &PROGRAM='popoxr.p'
                  &PARAM="(input po_fix_pr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API"
            then do:
               next-prompt po_fix_pr with frame b no-validate.
               undo setb, retry setb.
            end.
            else   /*if c-application-mode = "API"*/
               undo, return error.
         end.  /* if return-value <> {&SUCCESS-RESULT} then do: */
      end. /* IF po_fix_pr <> old_fix_pr */

      /*CHECK FOR VALID BILL-TO ADDRESS */
      {us/px/pxrun.i &PROC='validateBillToAddress' &PROGRAM='popoxr.p'
               &PARAM="(input po_bill)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_bill with frame b.
            undo, retry.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT} then do: */

      /* DELETE */
      if c-application-mode <> "API"
      then do:
         if deleteRequested
         then do:

            {us/px/pxrun.i &PROC='deletePurchaseOrder' &PROGRAM='popoxr.p'
                     &PARAM="(input po_nbr,
                              input blanket,
                              input no)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               undo, retry.
            end.
            else
               del-yn = yes.

            clear frame a.
            clear frame vend.
            clear frame ship_to.
            clear frame b.
            /* Leave del-yn set so pomt knows what to do */
            continue = no.
            leave order-header.
         end.
      end.  /* if c-application-mode <> "API" then do: */

   /* Delete */
      else  /* if c-application-mode == "API" */
      do:
         if (lLegacyAPI and (ttPurchaseOrder.operation = {&REMOVE})) or
            (not lLegacyAPI and (ttPurchaseOrderHeader.operation = {&REMOVE}))
         then do:
            {us/px/pxrun.i &PROC='deletePurchaseOrder'
                     &PROGRAM='popoxr.p'
                     &PARAM="(input po_nbr,
                              input blanket,
                              input no)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               undo, return error.
            end.
            else
               del-yn = yes.

            continue = no.
            leave order-header.
         end.  /* if ttPurchaseOrder.operation = {&REMOVE} then do: */
      end.  /*else [if c-application-mode == "API"]  */

/*jpm*/ /*Temporarily remove PRM */
/*
      if {pxfunct.i &FUNCTION='isPRMEnabled' &PROGRAM='pjprmxr.p'}
      then do:
         if new_po
         then do:
            {us/px/pxrun.i &PROC='copyPRMProjectComments' &PROGRAM='pjprjxr.p'
                     &PARAM="(input input po_project,
                              input-output po_cmtindx)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
            if can-find(first cmt_det  where cmt_det.cmt_domain = global_domain
            and  cmt_indx = po_cmtindx) then
               pocmmts = yes.
         end. /* IF new_po */
         else do:
            {us/px/pxrun.i &PROC='validatePRMProjectOpen' &PROGRAM='pjprjxr.p'
                     &PARAM="(input input po_project)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
         end. /* ELSE */
      end.  /* END isPrmEnabled */
*/
      {us/px/pxrun.i &PROC='readPOControl' &PROGRAM='popoxr.p'
               &PARAM="(buffer poc_ctrl)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      {us/px/pxrun.i &PROC='getPriceListRequired' &PROGRAM='popoxr.p'
               &PARAM="(output poc_pt_req)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      /* MOVED PRICE TABLE VALIDATION TO us/ad/adprclst.i */
      /* ADDED TWO ARGUMENTS &DISP-MSG AND &WARNING */
      {us/ad/adprclst.i
         &price-list     = "po_pr_list2"
         &curr           = "po_curr"
         &list-class     = {&SUPPLIER-CLASSIFICATION}
         &price-list-req = "poc_pt_req"
         &undo-label     = "setb"
         &with-frame     = "with frame b"
         &disp-msg       = "yes"
         &warning        = "yes"}

      /* DISCOUNT TABLE VALIDATION */
      {us/ad/addsclst.i
         &disc-list      = "po_pr_list"
         &curr           = "po_curr"
         &list-class     = {&SUPPLIER-CLASSIFICATION}
         &disc-list-req  = "disc_tbl_req"
         &undo-label     = "setb"
         &with-frame     = "with frame b"
         &disp-msg       = "yes"
         &warning        = "yes"}

      /* VALIDATE P.O. Site */
      {us/px/pxrun.i &PROC='validatePoSite' &PROGRAM='popoxr.p'
               &PARAM="(input po_site)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_site.
            undo setb, retry.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT} then do: */

      /* VALIDATE PURCHASE ORDER CURRENCY */
      {us/px/pxrun.i &PROC='validateCurrency' &PROGRAM='mcexxr.p'
               &PARAM="(input po_curr)"
               &NOAPPERROR=true
               &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_curr.
            undo setb, retry.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.  /*   if return-value <> {&SUCCESS-RESULT} then do: */

      /* EXCHANGE RATE VALIDATION */
      assign undo_all = yes
         po_recno = recid(po_mstr).

         {us/bbi/gprun.i ""popomtb1.p""}

      if undo_all
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_curr.
            undo, retry.
         end.
         else /*  if c-application-mode = "API" */
            undo, return error.
      end.  /*  if return-value <> {&SUCCESS-RESULT} then do: */

      {us/px/pxrun.i &PROC='getRoundingMethod' &PROGRAM='mcexxr.p'
               &PARAM="(input po_curr,
                        output rndmthd)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_curr with frame b.
            undo setb, retry.
         end.
         else /*  if c-application-mode = "API" */
            undo, return error.
      end.  /*  if return-value <> {&SUCCESS-RESULT} then do: */

      /* VALIDATE TAX CODE AND TAXABLE BY TAX DATE OR DUE DATE */
      {us/px/pxrun.i &PROC='validateTaxClass' &PROGRAM='txenvxr.p'
               &PARAM="(input po_taxc)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         if c-application-mode <> "API"
         then do:
            next-prompt po_taxc with frame b.
            undo, retry.
         end.
          else /*  if c-application-mode = "API" */
            undo, return error.
      end.  /*  if return-value <> {&SUCCESS-RESULT} then do: */

      /* UPDATE THE PO LINES PO Site WITH THE CHANGED HEADER Site FOR */
      /* EXISTING PO                                                  */
      if old_posite <> po_site
         and not new_po
      then do:
         for each pod_det
            where pod_det.pod_domain = global_domain
            and   pod_nbr            = po_nbr
         exclusive-lock:
            {us/px/pxrun.i &PROC='getPurchaseOrderLinePOSite' &PROGRAM='popoxr1.p'
                     &PARAM="(input po_site,
                              input pod_site,
                              output pod_po_site)"
                     &NOAPPERROR=True &CATCHERROR=True}
         end. /* FOR EACH pod_det */
      end. /* IF old_posite <> po_site */

      /* Move code up into correct sequence per new frame b. */
      assign po_disc_pct = disc
             ststatus = stline[1].

      status input ststatus.

      set_tax:
      do on error undo, retry:
         if retry and c-application-mode = "API" then
            return error.


         if po_tax_env = ""
         then do:
            {us/px/pxrun.i &PROC='getTaxEnvironment' &PROGRAM='popoxr.p'
                     &PARAM="(input po_vend,
                              input po_site,
                              input po_ship,
                              input  po_taxc,
                              output po_tax_env)"}
         end. /* IF po_tax_env = "" */

         set_tax1:
         do on error undo, retry:
            if c-application-mode <> "API" then
               update po_tax_usage
                  po_tax_env
                  po_taxc
                  po_taxable
                  po_tax_in
               with frame set_tax no-validate.
            else /*if c-application-mode = "API"*/
               if lLegacyAPI then
               assign
                  {us/mf/mfaiset.i po_tax_usage ttPurchaseOrder.taxUsage}
                  {us/mf/mfaiset.i po_tax_env ttPurchaseOrder.taxEnv}
                  {us/mf/mfaiset.i po_taxc ttPurchaseOrder.taxc}
                  {us/mf/mfaiset.i po_taxable ttPurchaseOrder.taxable}
                  {us/mf/mfaiset.i po_tax_in ttPurchaseOrder.taxIn}
                  .
               else
               assign
                  {us/mf/mfaistvl.i po_tax_usage ttPurchaseOrderHeader.poTaxUsage}
                  {us/mf/mfaistvl.i po_tax_env ttPurchaseOrderHeader.poTaxEnv}
                  {us/mf/mfaistvl.i po_taxc ttPurchaseOrderHeader.poTaxc1}
                  {us/mf/mfaistvl.i po_taxable ttPurchaseOrderHeader.poTaxable1}
                  {us/mf/mfaistvl.i po_tax_in ttPurchaseOrderHeader.taxIn}
                  .

            /* VALIDATES ON PO TAX USAGE */
            {us/px/pxrun.i &PROC='validateTaxUsage'
                     &PROGRAM='txenvxr.p'
                     &PARAM="(input po_tax_usage)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API"
               then do:
                  next-prompt po_tax_usage with frame set_tax no-validate.
                  undo set_tax1, retry set_tax1.
               end.
               else /*  if c-application-mode = "API" */
                  undo, return error.
            end.  /* if return-value <> {&SUCCESS-RESULT} then do: */
         end. /* set_tax1 */

         {us/px/pxrun.i &PROC='validateTaxEnvironment' &PROGRAM='txenvxr.p'
                  &PARAM="(input po_tax_env)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            if c-application-mode <> "API"
            then do:
               next-prompt po_tax_env with frame set_tax.
               undo, retry set_tax.
            end.
            else /*  if c-application-mode = "API" */
               undo, return error.
         end.  /* if return-value <> {&SUCCESS-RESULT} then do: */

         /*I19 TAX USAGE VALIDATION */
         {us/bbi/gprun.i ""txusgval.p""
            "(input  "{&TU_PO_MSTR}",
              input  oid_po_mstr,
              input  po_tax_usage,
              output is-valid)"}

         if not is-valid then do:
            next-prompt po_tax_usage with frame set_tax.
            undo, retry set_tax.
         end.
      end.  /* SET_TAX Loop */
      hide frame set_tax.

      /* UPDATE ORDER HEADER TERMS INTEREST PERCENTAGE */
      if po_crt_int <> 0  and po_cr_terms <> "" and
         (new_po or po_crt_int <> l_pocrt_int)
      then do:

         if po_crt_int <> l_pocrt_int
         then do:
            {us/px/pxrun.i &PROC='validatePOCreditTermsInt' &PROGRAM='popoxr.p'
                     &PARAM="(input po_crt_int)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API"
               then do:
                  next-prompt po_crt_int.
                  undo, retry.
               end.
               else /*  if c-application-mode = "API" */
                  undo, return error.
             end.
         end.

         {us/px/pxrun.i &PROC='validateCreditTermsInterest' &PROGRAM='popoxr.p'
                  &PARAM="(input po_cr_terms,
                           input po_crt_int)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            /* Entered terms interest # does not match ct interest # */
            con-yn = yes.
            /* MESSAGE #7734 - DO YOU WISH TO CONTINUE? */
            if c-application-mode <> "API" then do:
               {us/bbi/pxmsg.i &MSGNUM=7734 &ERRORLEVEL={&WARNING-RESULT}
                        &CONFIRM=con-yn}
            end.

            if not con-yn
            then do:
               if c-application-mode <> "API"
               then do:
                  next-prompt po_crt_int.
                  undo, retry.
               end.
               else /*  if c-application-mode = "API" */
                  undo, return error.
            end.  /* if not con-yn then do: */
         end.  /* if return-value <> {&SUCCESS-RESULT} then do: */
      end.  /* if po_crt_int <> 0  and po_cr_terms <> "" and */
            /*(new_po or po_crt_int <> l_pocrt_int) then do: */

      if use-log-acctg
      then do:
         if c-application-mode <> "API" then
            hide frame b.
         la-okay = no.

         if c-application-mode = "API" and not lLegacyAPI then do:
            run setCommonDataBuffer in ApiMethodHandle
               (input "ttLogisticsAccountData").
         end.

         /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
         {us/gp/gprunmo.i &module = "LA" &program = "lapomt.p"
            &param  = """(input po_recno,
                          input no,
                          input-output la-okay)"""}
         if c-application-mode = "API" and not lLegacyAPI then do:
            run setCommonDataBuffer in ApiMethodHandle
               (input "").
         end.

         if la-okay = no then
            undo setb, retry.

      end.

      for first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock:
      end.
      if available poc_ctrl and poc_ers_proc
      then do: /* ERS ON */

         form
            po_ers_opt label "ERS Option" colon 22
            skip
            po_pr_lst_tp label "ERS Price List Option" colon 22
            with frame ers overlay side-labels centered
            row(frame-row(a) + 11)
            width 30.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame ers:handle).

         /* PO CONTROL ERS IS ON AND ERS OPTION IS ON */
         if new_po then
            po_ers_opt = poc_ers_opt.

         /* UPDATE ERS FIELDS */
         if c-application-mode <> "API" then
            display po_ers_opt po_pr_lst_tp with frame ers.

         ers-loop:
         do with frame ers on error undo, retry:
            if c-application-mode <> "API" then
               set po_ers_opt po_pr_lst_tp.
            else do:
               if lLegacyAPI then
               assign
                  {us/mf/mfaiset.i po_ers_opt ttPurchaseOrder.ersOpt}
                  {us/mf/mfaiset.i po_pr_lst_tp ttPurchaseOrder.prLstTp}
                .
               else
               assign
                  {us/mf/mfaiset.i po_ers_opt   ttPurchaseOrderHeader.poErsOpt}
                  {us/mf/mfaiset.i po_pr_lst_tp ttPurchaseOrderHeader.poPrLstTp}
                  .
            end.

            {us/px/pxrun.i &PROC='validateERSOption' &PROGRAM='popoxr.p'
                     &PARAM="(input po_ers_opt)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API"
               then do:
                  next-prompt po_ers_opt.
                  undo, retry ers-loop.
               end.
               else
                  undo, return error.
            end. /* if return-value <> {&SUCCESS-RESULT} then do: */
         end. /* DO WITH FRAME ERS */
         hide frame ers.
      end. /* IF AVAILABLE poc_ctrl */

      if using_supplier_consignment
         and (po_consignment or
             (not po_consignment
              and can-find(first pod_det no-lock
                              where pod_domain      = global_domain
                              and   pod_nbr         = po_nbr
                              and   pod_consignment = yes)
             ))
      then do:
         if c-application-mode <> "API" then do:
            /* COST POINT MAY BE UPDATED PROVIDED NO CONSIGNED */
            /* RECEIPTS HAVE OCCURRED FOR THE PO.              */
            {us/px/pxrun.i &PROC='setAgingDays'
                     &PARAM="(input-output po_max_aging_days,
                              input-output po_consign_cost_point,
                              input (if new_po then yes
                                     else if not can-find(first cnsix_mstr
                                        where cnsix_po_nbr = po_nbr) then yes
                                     else no))"}

            if keyfunction(lastkey) = "END-ERROR" then do:
               next-prompt
                  po_ord_date
               with frame b.
               undo setb, retry setb.
            end.

            hide frame aging.
         end. /* c-application-mode <> "API" */
         else do:
            if not lLegacyAPI then do:

            {us/gp/gplngn2a.i
               &file  = ""cns_ctrl""
               &field = "cost_point"
               &code  = po_consign_cost_point
               &mnemonic = cost_point
               &label = cost_point_label}

               aging_days = po_max_aging_days.

               assign
                  {us/mf/mfaiset.i aging_days   ttPurchaseOrderHeader.agingDays}
                  {us/mf/mfaiset.i cost_point   ttPurchaseOrderHeader.poCostPoint}
                                          when (if new_po then yes
                                              else if not can-find(first cnsix_mstr
                                                 where cnsix_po_nbr = po_nbr) then yes
                                              else no)
                  .
               /* Validate the Cost Point field */
               {us/gp/gplngv.i
                  &file     = ""cns_ctrl""
                  &field    = ""cost_point""
                  &mnemonic = cost_point
                  &isvalid  = cost_point_valid}

               if not cost_point_valid then do:
                  /* INVALID ENTRY */
                  {us/bbi/pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3
                  &FIELDNAME=""poCostPoint""}
                  undo, retry.
               end.

               {us/gp/gplnga2n.i
                  &file = ""cns_ctrl""
                  &field = ""cost_point""
                  &code = po_consign_cost_point
                  &mnemonic = cost_point
                  &label    = cost_point_label}

               po_max_aging_days = aging_days.

            end. /* not lLegacyAPI */
         end.
      end.   /* using_supplier_consignment */
   end.  /* Setb Loop */

   continue = yes.
end.  /* Order-header Loop */

/* Reset the validation mode to AR in case the procedure library */
/* is still in memory when another user runs a program requiring */
/* AR validation.                                                */
run setvalidMode in hDaybooksetValidation
               (input  false).

delete procedure hDaybooksetValidation no-error.
if valid-handle(h_edparams) then delete procedure h_edparams no-error.
