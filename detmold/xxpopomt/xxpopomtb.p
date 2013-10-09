/* popomtb.p - PURCHASE ORDER MAINTENANCE -- ORDER HEADER SUBPROGRAM          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15.3.12 $                                                               */
/*F0PN*/
/* Purchase Order Maintenance, order header subprogram.                       */
/*                                                                            */
/* Revision: 7.0     BY:ram                 DATE: 09/12/91  ECO: *F033*       */
/* Revision: 7.0     BY:mlv                 DATE: 11/08/91  ECO: *F029*       */
/* Revision: 7.0     BY:afs                 DATE: 07/01/92  ECO: *F727*       */
/* Revision: 7.3     BY:tjs                 DATE: 08/06/92  ECO: *G027*       */
/* Revision: 7.3     BY:tjs                 DATE: 09/29/92  ECO: *G028*       */
/* Revision: 7.3     BY:tjs                 DATE: 10/02/92  ECO: *G117*       */
/* Revision: 7.3     BY:wug                 DATE: 10/09/92  ECO: *G153*       */
/* Revision: 7.3     BY:mpp                 DATE: 10/22/92  ECO: *G481*       */
/* Revision: 7.3     BY:bcm                 DATE: 02/22/93  ECO: *G717*       */
/* Revision: 7.3     BY:tjs                 DATE: 02/23/93  ECO: *G735*       */
/* Revision: 7.3     BY:tjs                 DATE: 03/19/93  ECO: *G815*       */
/* Revision: 7.3     BY:afs                 DATE: 04/29/93  ECO: *G972*       */
/* Revision: 7.4     BY:jjs                 DATE: 06/08/93  ECO: *H006*       */
/* Revision: 7.4     BY:bcm                 DATE: 08/09/93  ECO: *H062*       */
/* Revision: 7.4     BY:tjs                 DATE: 11/22/93  ECO: *H082*       */
/* Revision: 7.4     BY:cdt                 DATE: 09/28/93  ECO: *H086*       */
/* Revision: 7.4     BY:cdt                 DATE: 10/23/93  ECO: *H184*       */
/* Revision: 7.4     BY:bcm                 DATE: 12/28/93  ECO: *H269*       */
/* Revision: 7.4     BY:cdt                 DATE: 03/03/94  ECO: *H288*       */
/* Revision: 7.4     BY:bcm                 DATE: 03/22/94  ECO: *H299*       */
/* Revision: 7.4     BY:bcm                 DATE: 07/29/94  ECO: *H465*       */
/* Revision: 7.4     BY:bcm                 DATE: 09/13/94  ECO: *H516*       */
/* Revision: 7.4     BY:bcm                 DATE: 09/29/94  ECO: *H541*       */
/* Revision: 8.5     BY:mwd                 DATE: 10/18/94  ECO: *J034*       */
/* Revision: 7.4     BY:mmp                 DATE: 10/31/94  ECO: *H582*       */
/* Revision: 7.5     BY:dpm                 DATE: 02/21/95  ECO: *J044*       */
/* Revision: 7.4     BY:jzw                 DATE: 02/23/95  ECO: *H0BM*       */
/* Revision: 7.4     BY:wjk                 DATE: 03/06/95  ECO: *H0BT*       */
/* Revision: 7.4     BY:srk                 DATE: 03/20/95  ECO: *H0C4*       */
/* Revision: 7.4     BY:ais                 DATE: 09/19/95  ECO: *G0X6*       */
/* Revision: 8.5     BY:dpm                 DATE: 10/27/95  ECO: *J08Y*       */
/* Revision: 8.5     BY:taf                 DATE: 09/27/95  ECO: *J053*       */
/* Revision: 8.5     BY:rxm                 DATE: 02/16/96  ECO: *H0JR*       */
/* Revision: 8.5     BY:rxm                 DATE: 03/04/96  ECO: *F0X2*       */
/* Revision: 8.5     BY:taf                 DATE: 07/18/96  ECO: *J0ZS*       */
/* Revision: 8.5     BY:Aruna P.Patil       DATE: 09/18/96  ECO: *H0MV*       */
/* Revision: 8.5     BY:Aruna P.Patil       DATE: 10/20/96  ECO: *H0ND*       */
/* Revision: 8.5     BY:Jim Josey           DATE: 01/07/98  ECO: *J29D*       */
/* Revision: 8.6E    BY:A. Rahane           DATE: 02/23/98  ECO: *L007*       */
/* Revision: 8.6E    BY:D. Tunstall         DATE: 03/23/98  ECO: *J2GF*       */
/* Revision: 8.6E    BY:Alfred Tan          DATE: 05/20/98  ECO: *K1Q4*       */
/* Revision: 8.6E    BY:Charles Yen         DATE: 06/02/98  ECO: *L020*       */
/* Revision: 8.6E    BY:Dana Tunstall       DATE: 08/07/98  ECO: *K1QS*       */
/* Revision: 8.6E    BY:Dana Tunstall       DATE: 08/07/98  ECO: *K1RJ*       */
/* Revision: 9.1     BY:Patti Gaultney      DATE: 10/01/99  ECO: *N014*       */
/* Revision: 9.1     BY:Satish Chavan       DATE: 08/16/99  ECO: *K226*       */
/* Revision: 9.1     BY:Thelma Stronge      DATE: 03/06/00  ECO: *N05Q*       */
/* Revision: 9.1     BY:Annasaheb Rahane    DATE: 03/24/00  ECO: *N08T*       */
/* Revision: 1.15.3.5  BY:Niranjan R.       DATE: 05/24/00  ECO: *N0C7*       */
/* Revision: 1.15.3.6  BY:Mudit Mehta       DATE: 07/03/00  ECO: *N0F3*       */
/* Revision: 1.15.3.7  BY:Niranjan R.       DATE: 07/13/00  ECO: *N0DS*       */
/* Revision: 1.15.3.8  BY:Pat Pigatti       DATE: 07/14/00  ECO: *N0G2*       */
/* Revision: 1.15.3.9  BY:Mark B. Smith     DATE: 04/17/00  ECO: *N059*       */
/* Revision: 1.15.3.10 BY: Mudit Mehta      DATE: 09/29/00  ECO: *N0W9*       */
/* $Revision: 1.15.3.12 $ BY:Adeline Kinehan  DATE: 10/19/01  ECO: *N13P*     */
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/*                                                                            */

/* po_confirm status get from code_mstr fldname = "#PO-Confirm#"     ECO:13A8 */
{mfdeclre.i}
{cxcustom.i "POPOMTB.P"}
{gplabel.i &ClearReg=yes} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE popomtb_p_1 "Ln Disc"
/* MaxLen: Comment: */

&SCOPED-DEFINE popomtb_p_2 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE popomtb_p_3 "ERS Price List Option"
/* MaxLen: Comment: */

&SCOPED-DEFINE popomtb_p_4 "ERS Option"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*============================================================================*/
/* ****************************** Definitions ******************************* */
/*============================================================================*/

/* NEW SHARED VARIABLES */
define new shared variable tax_nbr     like tx2d_nbr initial "".
define new shared variable tax_tr_type like tx2d_tr_type initial "20".
define new shared variable undo_all    like mfc_logical.

/* SHARED VARIABLES */
define shared variable blanket     as logical.
define shared variable using_grs   as logical no-undo.
define shared variable line_opened as logical.
define shared variable po_recno    as recid.
define shared variable rndmthd     like rnd_rnd_mthd.
define shared variable line        like pod_line.
define shared variable due_date    like pod_due_date.
define shared variable del-yn      like mfc_logical.
define shared variable qty_ord     like pod_qty_ord.
define shared variable so_job      like pod_so_job.
define shared variable disc        like pod_disc label {&popomtb_p_1}.
define shared variable ponbr       like po_nbr.
define shared variable old_po_stat like po_stat.
define shared variable old_rev     like po_rev.
define shared variable pocmmts     like mfc_logical label {&popomtb_p_2}.
define shared variable new_po      like mfc_logical.
define shared variable new_db      like si_db.
define shared variable old_db      like si_db.
define shared variable new_site    like si_site.
define shared variable old_site    like si_site.
define shared variable continue    like mfc_logical no-undo.
define shared variable tax_in      like ad_tax_in.
define shared variable impexp      like mfc_logical no-undo.

/* SHARED FRAMES */
define shared frame a.
define shared frame b.
define shared frame vend.
define shared frame ship_to.

/* LOCAL VARIABLES */
define variable con-yn       like mfc_logical.
define variable poc_pt_req   like mfc_logical.
define variable imp-okay     like mfc_logical no-undo.
define variable old_ord_date like po_ord_date no-undo.
define variable old_pr_list2 like po_pr_list2 no-undo.
define variable old_curr     like po_curr     no-undo.
define variable old_fix_pr   like po_fix_pr   no-undo.
define variable l_pocrt_int  like po_crt_int  no-undo.

{gptxcdec.i}  /* DECLARATIONS FOR gptxcval.i */

/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/* Purchase Order API TEMP-TABLE, NAMED USING THE "Api" PREFIX */
{popoit01.i}

/*Import Export api temp table*/
{icieit01.i}

if c-application-mode = "API" then do on error undo, return:

   /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
                     "(output ApiMethodHandle,
                       output ApiProgramName,
                       output ApiMethodName,
                       output apiContextString)"}

   /* GET LOCAL PO MASTER TEMP-TABLE */
   create ttPurchaseOrder.
   run getPurchaseOrderRecord in ApiMethodHandle
              (buffer ttPurchaseOrder).
end.  /* If c-application-mode = "API" */
/* FRAMES AND FORMS */
{popomt02.i}  /* Shared frames a and b */

/* TAX MANAGEMENT FORM */
form
   po_tax_usage colon 25
   po_tax_env   colon 25
   space(1)
   po_taxc      colon 25
   po_taxable   colon 25
   tax_in       colon 25
   with frame set_tax row 8 centered overlay side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame set_tax:handle).

{mfadform.i "vend" 1 SUPPLIER}
{mfadform.i "ship_to" 41 SHIP_TO}

/*============================================================================*/
/* ****************************** Main Block ******************************** */
/*============================================================================*/

/* SETUP */
for first po_mstr exclusive-lock
   where recid(po_mstr) = po_recno:
end.
for first vd_mstr no-lock
   where vd_addr = po_vend:
end.

/* GET CONTROL RECORDS */
for first poc_ctrl no-lock:
end.
for first gl_ctrl  no-lock:
end.
for first iec_ctrl no-lock:
end.

order-header:
do on error undo, retry on endkey undo, leave with frame b:
   if retry and c-application-mode = "API" then
      return error.

   ststatus = stline[2].
   status input ststatus.
   assign
      del-yn = no
      disc = po_disc_pct.

   if not new_po then do:
      {pxrun.i &PROC='validateNotPrinted' &PROGRAM='popoxr.p'
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
      old_rev = po_rev
      l_pocrt_int = po_crt_int.
   {&POPOMTB-P-TAG1}

   if c-application-mode <> "API" then
      display
         po_ord_date po_due_date po_buyer po_bill
         so_job po_contract po_contact po_rmks
         po_pr_list2 po_pr_list disc po_site
         po_project po_confirm po_curr po_lang
         po_taxable po_taxc po_tax_date po_fix_pr
         po_cr_terms
         po_crt_int
         po_req_id pocmmts
         impexp
         with frame b.
/*13A8*/ find first code_mstr no-lock where code_fldname = "#PO-Confirm#"
/*13A8*/        and code_value = input po_site no-error.
/*13A8*/ if available code_mstr then do:
/*13A8*/   if substring(upper(trim(code_cmmt)),1,2) = "NO" then do:
/*13A8*/      display NO @ po_confirm.
/*13A8*/   end.
/*13A8*/ end.
/*13A8*/ assign po_confirm.
   setb:
   do on error undo, retry:
      if retry and c-application-mode = "API" then
         return error.

      assign
         old_ord_date = po_ord_date
         old_pr_list2 = po_pr_list2
         old_curr     = po_curr
         old_fix_pr   = po_fix_pr.

      /* Rearranged frame b */
      if c-application-mode <> "API" then do:
         set
            po_ord_date po_due_date po_buyer po_bill
            so_job po_contract po_contact po_rmks
            po_pr_list2 po_pr_list disc po_site
            po_project /* po_confirm */ impexp
            po_curr when (new_po) po_lang when (new_po)
            po_taxable po_taxc po_tax_date po_fix_pr
            po_cr_terms
            po_crt_int
            po_req_id pocmmts

         go-on ("F5" "CTRL-D") with frame b no-validate
         editing:
         readkey.

            if frame-field = "po_cr_terms" then do:
               if new_po
               and (lastkey = keycode("RETURN") or
                 lastkey = keycode("CTRL-X") or
                 lastkey = keycode("F1"))
               then do:
                  {pxrun.i &PROC='getCreditTermsInterest' &PROGRAM='adcrxr.p'
                           &PARAM="(input po_cr_terms:screen-value,
                                    output po_crt_int)"}

                  display po_crt_int.
               end.
            end.
            apply lastkey.
         end. /* Editing */
      end.  /* if c-application-mode <>"API"*/
      else       /* if c-application-mode = "API"*/
      do:
         assign
            {mfaiset.i po_ord_date ttPurchaseOrder.ordDate}
            {mfaiset.i po_due_date ttPurchaseOrder.dueDate}
            {mfaiset.i po_buyer ttPurchaseOrder.buyer}
            {mfaiset.i po_bill ttPurchaseOrder.bill}
            {mfaiset.i so_job ttPurchaseOrder.soJob}
            {mfaiset.i po_contract ttPurchaseOrder.contract}
            {mfaiset.i po_contact ttPurchaseOrder.contact}
            {mfaiset.i po_rmks ttPurchaseOrder.rmks}
            {mfaiset.i po_pr_list2 ttPurchaseOrder.prList2}
            {mfaiset.i po_pr_list ttPurchaseOrder.prList}
            {mfaiset.i disc ttPurchaseOrder.discPct}
            {mfaiset.i po_site ttPurchaseOrder.site}
            {mfaiset.i po_project ttPurchaseOrder.project}
            {mfaiset.i po_confirm ttPurchaseOrder.confirm}
            {mfaiset.i impexp ttPurchaseOrder.impexp}
            {mfaiset.i po_curr ttPurchaseOrder.curr} when (new_po)
            {mfaiset.i po_lang ttPurchaseOrder.lang} when (new_po)
            {mfaiset.i po_taxable ttPurchaseOrder.taxable}
            {mfaiset.i po_taxc ttPurchaseOrder.taxc}
            {mfaiset.i po_tax_date ttPurchaseOrder.taxDate}
            {mfaiset.i po_fix_pr ttPurchaseOrder.fixPr}
            {mfaiset.i po_cr_terms ttPurchaseOrder.crTerms}
            {mfaiset.i po_crt_int ttPurchaseOrder.pocrtInt}
            {mfaiset.i po_req_id ttPurchaseOrder.reqId}
            pocmmts = yes
            .

         if not({gpsite.v &field=po_site &blank_ok=yes}) then
         do:
            {pxmsg.i
               &MSGNUM = 2797
               &ERRORLEVEL = 3
               &MSGARG1 = po_nbr
            }
            undo, return error.
         end. /* end of if valid site*/

         if not {gpcode.v po_buyer} then
         do:
            {pxmsg.i
               &MSGNUM = 716
               &ERRORLEVEL = 4
               &MSGARG1 = po_nbr
               &MSGARG2 = po_buyer
            }
            undo, return error.
         end.
      end. /*end if C-APPLICATION-MODE = API */

      /* CHECKS FOR ACCESS ON PO ORDER DATE */
      if po_ord_date <> old_ord_date then do:
         {pxrun.i &PROC='validatePOOrderDate' &PROGRAM='popoxr.p'
                  &PARAM="(input po_ord_date)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then do:
               next-prompt po_ord_date with frame b no-validate.
               undo setb, retry setb.
            end.  /*if c-application-mode <>"API"*/
            else  /*if c-application-mode = "API"*/
               undo, return error.
         end.
      end. /* IF po_ord_date <> old_ord_date */

      /* VALIDATES ON PO BUYER */
      {pxrun.i &PROC='validatePOBuyer' &PROGRAM='popoxr.p'
               &PARAM="(input po_buyer)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_buyer with frame b no-validate.
            undo setb, retry setb.
         end.   /*if c-application-mode <>"API"*/
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* CHECKS FOR ACCESS ON PO PRICE TABLE */
      if po_pr_list2 <> old_pr_list2 then do:
         {pxrun.i &PROC='validatePOPriceList2' &PROGRAM='popoxr.p'
                  &PARAM="(input po_pr_list2)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then do:
               next-prompt po_pr_list2 with frame b no-validate.
               undo setb, retry setb.
            end.
            else   /*if c-application-mode = "API"*/
             undo, return error.
         end.  /*return-value <> {&SUCCESS-RESULT}*/
      end. /* IF po_pr_list2 <> old_pr_list2 */

      /* VALIDATES ON PO SITE */
      {pxrun.i &PROC='validatePOSite' &PROGRAM='popoxr.p'
               &PARAM="(input po_site)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_site with frame b no-validate.
            undo setb, retry setb.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* VALIDATES ON PO PROJECT */
      {pxrun.i &PROC='validatePOProject' &PROGRAM='popoxr.p'
               &PARAM="(input po_project)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_project with frame b no-validate.
            undo setb, retry setb.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* CHECKS FOR ACCESS ON PO CURRENCY */
      if po_curr <> old_curr then do:
         {pxrun.i &PROC='validatePOCurrency' &PROGRAM='popoxr.p'
                  &PARAM="(input po_curr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then do:
               next-prompt po_curr with frame b no-validate.
               undo setb, retry setb.
            end.
            else   /*if c-application-mode = "API"*/
               undo, return error.
         end.
      end. /* IF po_curr <> old_curr */

      /* VALIDATES ON PO LANGUAGE */
      {pxrun.i &PROC='validatePOLanguage' &PROGRAM='popoxr.p'
               &PARAM="(input po_lang)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_lang with frame b no-validate.
            undo setb, retry setb.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* CHECKS FOR ACCESS ON PO FIXED PRICE */
      if po_fix_pr <> old_fix_pr then do:
         {pxrun.i &PROC='validatePOFixedPrice' &PROGRAM='popoxr.p'
                  &PARAM="(input po_fix_pr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then do:
               next-prompt po_fix_pr with frame b no-validate.
               undo setb, retry setb.
            end.
            else   /*if c-application-mode = "API"*/
               undo, return error.
         end.
      end. /* IF po_fix_pr <> old_fix_pr */

      /* VALIDATES ON PO CREDIT TERMS */
      {pxrun.i &PROC='validatePOCreditTerms' &PROGRAM='popoxr.p'
            &PARAM="(input po_cr_terms)"
            &NOAPPERROR=true
            &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_cr_terms with frame b no-validate.
            undo setb, retry setb.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /*CHECK FOR VALID BILL-TO ADDRESS */
      {pxrun.i &PROC='validateBillToAddress' &PROGRAM='popoxr.p'
               &PARAM="(input po_bill)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_bill with frame b.
            undo, retry.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* DELETE */
      if c-application-mode <> "API" then do:
         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
         then do:

            {pxrun.i &PROC='deletePurchaseOrder' &PROGRAM='popoxr.p'
                     &PARAM="(input po_nbr,
                              input blanket,
                              input no)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT} then do:
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
      end.
         /* Delete */
      else  /* if c-application-mode == "API" */
      do:
         if ttPurchaseOrder.operation = {&REMOVE} then do:
            {pxrun.i &PROC='deletePurchaseOrder' &PROGRAM='popoxr.p'
                     &PARAM="(input po_nbr,
                              input blanket,
                              input no)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT} then do:
               undo, return error.
            end.
            else
               del-yn = yes.

            continue = no.
            leave order-header.
          end.
      end.

      if {pxfunct.i &FUNCTION='isPRMEnabled' &PROGRAM='pjprmxr.p'}
      then do:
         if new_po then do:
            {pxrun.i &PROC='copyPRMProjectComments' &PROGRAM='pjprjxr.p'
                     &PARAM="(input input po_project,
                              input-output po_cmtindx)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
            if can-find(first cmt_det where cmt_indx = po_cmtindx) then
               pocmmts = yes.
         end. /* IF new_po */
         else do:
            {pxrun.i &PROC='validatePRMProjectOpen' &PROGRAM='pjprjxr.p'
                     &PARAM="(input input po_project)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
         end. /* ELSE */
      end.  /* END isPrmEnabled */

      {pxrun.i &PROC='readPOControl' &PROGRAM='popoxr.p'
               &PARAM="(buffer poc_ctrl)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      {pxrun.i &PROC='getPriceListRequired' &PROGRAM='popoxr.p'
               &PARAM="(output poc_pt_req)"
               &NOAPPERROR=true
               &CATCHERROR=true}
      /* MOVED PRICE TABLE VALIDATION TO adprclst.i */
      /* ADDED TWO ARGUMENTS &DISP-MSG AND &WARNING */
      {adprclst.i
         &price-list     = "po_pr_list2"
         &curr           = "po_curr"
         &price-list-req = "poc_pt_req"
         &undo-label     = "setb"
         &with-frame     = "with frame b"
         &disp-msg       = "yes"
         &warning        = "yes"}

      /* MOVED DISCOUNT TABLE VALIDATION TO addsclst.i */
      /* ADDED TWO ARGUMENTS &DISP-MSG AND &WARNING */
      {addsclst.i
         &disc-list      = "po_pr_list"
         &curr           = "po_curr"
         &disc-list-req  = "poc_pl_req"
         &undo-label     = "setb"
         &with-frame     = "with frame b"
         &disp-msg       = "yes"
         &warning        = "yes"}

      /* VALIDATE P.O. Site */
      {pxrun.i &PROC='validatePoSite' &PROGRAM='popoxr.p'
         &PARAM="(input po_site)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_site.
            undo setb, retry.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* VALIDATE PURCHASE ORDER CURRENCY */
      {pxrun.i &PROC='validateCurrency' &PROGRAM='mcexxr.p'
               &PARAM="(input po_curr)"
               &NOAPPERROR=true
               &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_curr.
            undo setb, retry.
         end.
         else   /*if c-application-mode = "API"*/
            undo, return error.
      end.

      /* EXCHANGE RATE VALIDATION */
      assign undo_all = yes
         po_recno = recid(po_mstr).

      {gprun.i ""popomtb1.p""}
      if undo_all then do:
         if c-application-mode <> "API" then do:
            next-prompt po_curr.
            undo, retry.
         end.
         else /*  if c-application-mode = "API" */
            undo, return error.
      end.

      {pxrun.i &PROC='getRoundingMethod' &PROGRAM='mcexxr.p'
               &PARAM="(input po_curr,
                        output rndmthd)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt po_curr with frame b.
            undo setb, retry.
         end.
         else /*  if c-application-mode = "API" */
            undo, return error.
      end.

      /* VALIDATE TAX CODE AND TAXABLE BY TAX DATE OR DUE DATE */
      {pxrun.i &PROC='validateTaxClass' &PROGRAM='txenvxr.p'
               &PARAM="(input po_taxc)"
               &NOAPPERROR=true
               &CATCHERROR=true}

       if return-value <> {&SUCCESS-RESULT} then do:
          if c-application-mode <> "API" then do:
             next-prompt po_taxc with frame b.
             undo, retry.
          end.
          else /*  if c-application-mode = "API" */
            undo, return error.
      end.

      /* Move code up into correct sequence per new frame b. */
      assign
         po_disc_pct = disc
         ststatus = stline[1].
      status input ststatus.

      set_tax:
      do on error undo, retry:
         if retry and c-application-mode = "API" then
            return error.

         {&POPOMTB-P-TAG2}
         if po_tax_env = "" then do:
            {pxrun.i &PROC='getTaxEnvironment' &PROGRAM='popoxr.p'
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
                  tax_in
               with frame set_tax no-validate.
            else /*if c-application-mode = "API"*/
               assign
                  {mfaiset.i po_tax_usage ttPurchaseOrder.taxUsage}
                  {mfaiset.i po_tax_env ttPurchaseOrder.taxEnv}
                  {mfaiset.i po_taxc ttPurchaseOrder.taxc}
                  {mfaiset.i po_taxable ttPurchaseOrder.taxable}
                  {mfaiset.i tax_in ttPurchaseOrder.taxIn}
                  .


            /* VALIDATES ON PO TAX USAGE */
            {pxrun.i &PROC='validatePOTaxUsage' &PROGRAM='popoxr.p'
               &PARAM="(input po_tax_usage)"
               &NOAPPERROR=true
               &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT} then do:
               if c-application-mode <> "API" then do:
                  next-prompt po_tax_usage with frame set_tax no-validate.
                  undo set_tax1, retry set_tax1.
               end.
               else /*  if c-application-mode = "API" */
                 undo, return error.
            end.
         end. /* Set_tax1 */

         {pxrun.i &PROC='validateTaxEnvironment' &PROGRAM='txenvxr.p'
            &PARAM="(input po_tax_env)"
            &NOAPPERROR=true
            &CATCHERROR=true}
         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then do:
               next-prompt po_tax_env with frame set_tax.
               undo, retry set_tax.
            end.
            else /*  if c-application-mode = "API" */
               undo, return error.
         end.

      end.  /* SET_TAX Loop */
      hide frame set_tax.

      /* UPDATE ORDER HEADER TERMS INTEREST PERCENTAGE */
      if po_crt_int <> 0  and po_cr_terms <> "" and
         (new_po or po_crt_int <> l_pocrt_int) then do:

         if po_crt_int <> l_pocrt_int then do:
            {pxrun.i &PROC='validatePOCreditTermsInt' &PROGRAM='popoxr.p'
                     &PARAM="(input po_crt_int)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
            if return-value <> {&SUCCESS-RESULT} then do:
               next-prompt po_crt_int.
               undo, retry.
            end.
         end.

         {pxrun.i &PROC='validateCreditTermsInterest' &PROGRAM='popoxr.p'
                  &PARAM="(input po_cr_terms,
                           input po_crt_int)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT} then do:
            /* Entered terms interest # does not match ct interest # */
            con-yn = yes.
            /* MESSAGE #7734 - DO YOU WISH TO CONTINUE? */
            {pxmsg.i
               &MSGNUM=7734
               &ERRORLEVEL={&WARNING-RESULT}
               &CONFIRM=con-yn}
            if not con-yn then do:
               if c-application-mode <> "API" then do:
                  next-prompt po_crt_int.
                  undo, retry.
               end.
               else /*  if c-application-mode = "API" */
                  undo, return error.
            end.
         end.
      end.
      {&POPOMTB-P-TAG3}

      if impexp then do:
         hide frame b.
         imp-okay = no.
         if c-application-mode = "API" then
         do:
             for first ttImportExport
                where  ttImportExport.apiExternalKey = ttPurchaseOrder.apiExternalKey:
             end.

             if not available ttImportExport then
             do:
                 {pxmsg.i
                         &MSGNUM = 4698  /*Data missing" */
                         &MSGARG1 = ""IntrastatData""
                         &ERRORLEVEL = 4}
                 undo setb, return.
             end.

             run setImportExportRow in ApiMethodHandle
                (ttImportExport.apiSequence).
         end.
         {gprun.i ""iemstrcr.p"" "( input ""2"",
            input po_nbr,
            input recid(po_mstr),
            input-output imp-okay )"}
         if imp-okay = no then do:
            if c-application-mode <> "API" then
               undo setb, retry.
            else
               undo setb, return.
         end.
      end.
      {&POPOMTB-P-TAG4}

      find first poc_ctrl no-lock no-error.
      if available poc_ctrl and poc_ers_proc then do: /* ERS ON */
         form
            po_ers_opt label {&popomtb_p_4} colon 22
            skip
            po_pr_lst_tp label {&popomtb_p_3} colon 22
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
         do with frame ers on error undo,  retry:
            if c-application-mode <> "API" then
               set po_ers_opt po_pr_lst_tp.
            else
               assign
                  {mfaiset.i po_ers_opt ttPurchaseOrder.ersOpt}
                  {mfaiset.i po_pr_lst_tp ttPurchaseOrder.prLstTp}
                .

            {pxrun.i &PROC='validateERSOption' &PROGRAM='popoxr.p'
                     &PARAM="(input po_ers_opt)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT} then do:
               if c-application-mode <> "API" then do:
                  next-prompt po_ers_opt.
                  undo, retry ers-loop.
               end.
               else
                  undo, return error.
            end.
         end. /* DO WITH FRAME ERS */
         hide frame ers.
      end. /* IF AVAILABLE poc_ctrl */
   end.  /* Setb Loop */

   continue = yes.
end.  /* Order-header Loop */
