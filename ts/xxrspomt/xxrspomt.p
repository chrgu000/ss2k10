/* GUI CONVERTED from rspomt.p (converter v1.78) Fri Oct 29 14:37:56 2004 */
/* rspomt.p - Release Management Supplier Schedules                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11.2.23 $                                                     */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3      LAST MODIFIED: 12/08/92   BY: WUG *G462*                */
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   BY: WUG *G817*                */
/* REVISION: 7.3      LAST MODIFIED: 06/10/93   BY: WUG *GB74*                */
/* REVISION: 7.3      LAST MODIFIED: 06/24/93   BY: WUG *GC68*                */
/* REVISION: 7.3      LAST MODIFIED: 07/14/93   BY: WUG *GD43*                */
/* REVISION: 7.4      LAST MODIFIED: 08/05/93   BY: bcm *H057*                */
/* REVISION: 7.4      LAST MODIFIED: 11/01/93   BY: WUG *H204*                */
/* REVISION: 7.3      LAST MODIFIED: 04/21/94   BY: WUG *GJ48*                */
/* REVISION: 7.3      LAST MODIFIED: 05/16/94   BY: WUG *GJ59*                */
/* REVISION: 7.3      LAST MODIFIED: 08/11/94   BY: dpm *GL23*                */
/* REVISION: 8.5      LAST MODIFIED: 10/18/94   BY: mwd *J034*                */
/* REVISION: 7.4      LAST MODIFIED: 02/06/95   BY: rxm *G0DH*                */
/* REVISION: 8.5      LAST MODIFIED: 02/21/95   BY: dpm *J044*                */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM*                */
/* REVISION: 7.4      LAST MODIFIED: 03/23/95   BY: bcm *G0J1*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 04/10/95   BY: jpm *H0CH*                */
/* REVISION: 8.5      LAST MODIFIED: 10/27/95   BY: dpm *J08Y*                */
/* REVISION: 7.4      LAST MODIFIED: 10/05/95   BY: ais *H0G9*                */
/* REVISION: 8.5      LAST MODIFIED: 02/22/96   BY: *J0CV* Brandy J Ewing     */
/* REVISION: 8.5      LAST MODIFIED: 09/18/96   BY: *G2FN* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 01/09/97   BY: *J1B1* Robin McCarthy     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 03/23/98   BY: *J2GF* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/16/98   BY: *L040* Charles Yen        */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 07/29/99   BY: *J3K0* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 10/13/99   BY: *L0K6* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00   BY: *N0RT* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0WD* BalbeerS Rajput    */
/* Revision: 1.11.2.9      BY: Katie Hilbert      DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.11.2.10     BY: Manisha Sawant     DATE: 07/30/01  ECO: *M1FV* */
/* Revision: 1.11.2.11     BY: Ellen Borden       DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.11.2.12     BY: Tiziana Giustozzi  DATE: 05/24/02  ECO: *P03Z* */
/* Revision: 1.11.2.13     BY: Jean Miller        DATE: 06/07/02  ECO: *P080* */
/* Revision: 1.11.2.14     BY: Robin McCarthy     DATE: 07/15/02  ECO: *P0BJ* */
/* Revision: 1.11.2.19     BY: Laurene Sheridan   DATE: 10/15/02  ECO: *N13P* */
/* Revision: 1.11.2.20  BY: Niall Shanahan DATE: 01/27/03 ECO: *M226* */
/* Revision: 1.11.2.22  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.11.2.23 $ BY: Rajinder Kamra DATE: 05/02/03 ECO: *Q003* */
/* BY KEN SS - 111014.1 */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/*****************************************************************************/
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */

/* SCHEDULED ORDER MAINT */

/*
{mfdtitle.i "2+ "}
*/

{mfdtitle.i "111014.1"}

/* SS - 111014.1
增加交货时间，设置
*/


/* Clear anything displayed by mftitle if api mode*/
{mfaititl.i}
{cxcustom.i "RSPOMT.P"}
{pxmaint.i}
{pxphdef.i mcpl}

define new shared variable cmtindx like cmt_indx.
define new shared variable tax_recno as recid.
define new shared variable impexp   like mfc_logical no-undo.
define new shared variable tax_in like ad_tax_in.

define new shared frame po.
define new shared frame po1.
define new shared frame pod.
define new shared frame pod1.
define new shared frame pod2.
define variable poTrans as character no-undo.
define variable vend as character no-undo.

define variable del-yn like mfc_logical.
define variable yn like mfc_logical.
define variable line as integer.
define variable scx_recid as recid.
define variable po_recid as recid.
define variable ponbr as character.
define variable tax_date like tax_effdate.
define variable valid_acct like mfc_logical.
define variable zone_to like txe_zone_to.
define variable zone_from like txe_zone_from.
define variable new_po like mfc_logical.
define variable imp-okay like mfc_logical no-undo.
define variable impexp_edit     like mfc_logical no-undo.
define variable upd_okay        like mfc_logical no-undo.
define variable impexp_order    like po_nbr no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable subtype         as character format "x(12)"
   label "Subcontract Type" no-undo.
define variable use-log-acctg as logical no-undo.

define buffer scxref for scx_ref.

{pocnvars.i} /* Consignment variables */
{pocnpo.i}  /* consignment procedures and frames */

{gptxcdec.i}  /* DECLARATIONS FOR gptxcval.i */

/*COMMON API CONSTANTS AND VARIABLES*/
{mfaimfg.i}

/*PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "api" PREFIX*/
{popoit01.i}

/*Import  Export API TEMP-TABLE, NAMED USING THE "api" PREFIX*/
{icieit01.i}
{mfctit01.i}
{mctrit01.i}

if c-application-mode = "API"
then do on error undo, return error:

   /*GET HANDLE OF API CONTROLLER*/
   {gprun.i ""gpaigh.p"" "(output ApiMethodHandle,
                                   output ApiProgramName,
                                   output ApiMethodName,
                                   output apiContextString)"}
/*GUI*/ if global-beam-me-up then undo, leave.



   /* GET LOCAL PO MASTER TEMP-TABLE */
   create ttPurchaseOrder.
   run getPurchaseOrderRecord in ApiMethodHandle
              (buffer ttPurchaseOrder).

   run getPurchaseOrderCmt in ApiMethodHandle
               (output table ttPurchaseOrderCmt).

   run getpoTrans in ApiMethodHandle (output poTrans).

end.  /* If c-application-mode = "API" */

/* TAX MANAGEMENT FORM */
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
po_tax_usage colon 25
   po_tax_env  colon 25
   space(2)
 SKIP(.4)  /*GUI*/
with frame set_tax row 8 centered overlay side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-set_tax-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame set_tax = F-set_tax-title.
 RECT-FRAME-LABEL:HIDDEN in frame set_tax = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame set_tax =
  FRAME set_tax:HEIGHT-PIXELS - RECT-FRAME:Y in frame set_tax - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME set_tax = FRAME set_tax:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame set_tax:handle).

if no then
   for first pod_det  where pod_det.pod_domain = global_domain no-lock:
end.

{rsordfrm.i}

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}
/*GUI*/ if global-beam-me-up then undo, leave.


mainloop:
repeat:
   /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API" then
      undo mainloop, return.
   for first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock:
   end.
   for first iec_ctrl  where iec_ctrl.iec_domain = global_domain no-lock:
   end.

   pocmmts = poc_hcmmts.

   if c-application-mode <> "API"
   then do:
      hide frame pod2.
      hide frame pod1.
      hide frame pod.
      hide frame po1.
   end.  /* If c-application-mode <> "API" */

   block_1:
   do with frame po:
      if c-application-mode <> "API"
      then do:
         prompt-for po_nbr po_vend
         editing:
            if frame-field = "po_nbr"
            then do:
               {mfnp05.i po_mstr po_nbr " po_mstr.po_domain = global_domain and
               po_sched"  po_nbr "input po_nbr"}

               if recno <>  ?
               then do:
                  for first ad_mstr  where ad_mstr.ad_domain = global_domain
                  and  ad_addr = po_vend no-lock:
                  end.

                  display
                     po_nbr
                     po_vend
                     ad_name.
               end.
            end.
            else
               if frame-field = "po_vend"
               then do:
               {mfnp05.i vd_mstr vd_addr  " vd_mstr.vd_domain = global_domain
               and yes "  vd_addr "input po_vend"}

               if recno <> ?
               then do:
                  for first ad_mstr  where ad_mstr.ad_domain = global_domain
                  and  ad_addr = vd_addr no-lock:
                  end.

                  display
                     vd_addr @ po_vend
                     ad_name.
               end.
            end.
            else do:
               status input.
               readkey.
               apply lastkey.
            end.
         end. /* EDITING */
      end.  /* If c-application-mode <> "API" */


      /* SET THE DEFAULT VALUE BASED ON IEC_CTRL FILE */

      if available iec_ctrl then
         impexp = iec_impexp.

      if c-application-mode <> "API" then
         for first po_mstr  where po_mstr.po_domain = global_domain and  po_nbr
         = input po_nbr no-lock:
         end.
      else
         for first po_mstr  where po_mstr.po_domain = global_domain and  po_nbr
         = ttPurchaseOrder.nbr no-lock:
         end.

      if available po_mstr
      then do:
         if not po_sched
         then do:
            {pxmsg.i &MSGNUM = 8181 &ERRORLEVEL = 3}
            if c-application-mode <> "API"
            then do:
               bell.
               undo, retry.
            end.  /* If c-application-mode <> "API" */
            else
                undo mainloop, return error.
         end.  /* if not po_sched then do: */
         new_po = no.
         recno = recid(po_mstr).

         if c-application-mode <> "API" then
            for first ad_mstr  where ad_mstr.ad_domain = global_domain and
            ad_addr = po_vend
               no-lock:
            end.
         else
         do:
            assign vend = po_vend.
            assign {mfaiset.i vend ttPurchaseOrder.vend}.
            for first ad_mstr  where ad_mstr.ad_domain = global_domain and
            ad_addr = vend no-lock:
            end.
         end.
         if c-application-mode <> "API" then
            display
               po_nbr
               po_vend
               ad_name.

         assign
            pocmmts = (po_cmtindx <> 0)
            print_sch      = (po_sch_mthd = "" or
                              substring(po_sch_mthd,1,1) = "p" or
                              substring(po_sch_mthd,1,1) = "b" or
                              substring(po_sch_mthd,1,1) = "y")
            edi_sch        = (substring(po_sch_mthd,1,1) = "e" or
                              substring(po_sch_mthd,1,1) = "b" or
                              substring(po_sch_mthd,2,1) = "y")
            fax_sch        =  substring(po_sch_mthd,3,1) = "y".

         if c-application-mode <> "API" then
            display
               po_ap_acct
               po_ap_sub
               po_ap_cc
               po_taxable
               po_taxc
               po_cr_terms
               po_bill
               po_ship
               print_sch
               edi_sch
               fax_sch
               po_site
               po_shipvia
               po_fob
               po_buyer
               po_contact
               po_contract
               pocmmts
               impexp
               po_consignment
            with frame po1.

         {gprun.i ""gpsiver.p"" "(input po_site,
                                  input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if return_int = 0
         then do:

            {pxmsg.i &MSGNUM = 725 &ERRORLEVEL = 3}
            /* USER DOES NOT HAVE ACCESS TO SITE */
            if c-application-mode <> "API" then
               undo mainloop, retry mainloop.
            else
               undo mainloop, return error.
         end.  /* if return_int = 0 then do: */

      end.  /* IF AVAILABLE PO_MSTR */
      if c-application-mode <> "API" then
         for first vd_mstr  where vd_mstr.vd_domain = global_domain and
         vd_addr = input po_vend no-lock:
         end.
      else
      do:
         if available po_mstr then
            assign vend = po_vend.
         else
            assign vend = "".
         assign {mfaiset.i vend ttPurchaseOrder.vend}.
         for first vd_mstr  where vd_mstr.vd_domain = global_domain and
         vd_addr = vend no-lock:
         end.
      end.  /* else [if c-application-mode <> "API" then] */

      if not available vd_mstr
      then do:
         /* Not a valid supplier   */
         {pxmsg.i &MSGNUM = 2 &ERRORLEVEL = 3}
         if c-application-mode <> "API"
         then do:
            next-prompt po_vend.
            undo, retry.
         end.  /* If c-application-mode <> "API" */
         else /* c-application-mode = "API" */
            undo mainloop, return error.
      end. /* if not available vd_mstr then do: */
      if c-application-mode <> "API" then
         for first pod_det  where pod_det.pod_domain = global_domain and
         pod_nbr = input po_nbr
         no-lock:
         end.
      else
         for first pod_det  where pod_det.pod_domain = global_domain and
         pod_nbr = ttPurchaseOrder.nbr
         no-lock:
         end.
      if available pod_det and pod_po_db <> global_db
      then do:

         {pxmsg.i &MSGNUM=6145 &ERRORLEVEL=3
                  &MSGARG1=getTermLabel(""PURCHASE_ORDER"",35)
                  &MSGARG2=pod_po_db}

         if c-application-mode <> "API" then
            undo, retry.
         else
            undo mainloop, return.
      end.  /* if available pod_det and pod_po_db <> global_db then do:*/

      for first ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
      vd_addr no-lock:
      end.
      if c-application-mode <> "API" then
         display
            ad_name.

      if not available po_mstr
      then do:
         new_po = yes.


         if (c-application-mode <> "API" and input po_nbr = "") or
           (c-application-mode = "API" and ttPurchaseOrder.nbr = ? and
                       poTrans = "GETPONUM")
         then do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

            {mfnctrlc.i "poc_ctrl.poc_domain = global_domain"
            "poc_ctrl.poc_domain" "po_mstr.po_domain = global_domain" poc_ctrl
            poc_po_pre
               poc_po_nbr po_mstr po_nbr ponbr}
            for first poc_ctrl  where poc_ctrl.poc_domain = global_domain
            no-lock:
            end.
/*GUI*/ if global-beam-me-up then undo, leave.

            if c-application-mode <> "API" then
               display
                  ponbr @ po_nbr.
            else
            do:
               assign ttPurchaseOrder.nbr = ponbr.

               run setPurchaseOrderRecord in ApiMethodHandle
                  (buffer ttPurchaseOrder).
               return.
            end.
         end.
         else
            if (c-application-mode = "API" and poTrans <> "GETPONUM")
            then
               assign ponbr = ttPurchaseOrder.nbr.
         else
            if (c-application-mode = "API" and poTrans = "GETPONUM")
            then
               return.
      end. /*if not available po_mstr                     */
      else
         if (c-application-mode = "API" and poTrans = "GETPONUM")
         then
            return.
   end. /* end of block_1                                 */

   block_2:
   do transaction:

      for first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock:
      end.
      if not new_po
      then do:
         for first po_mstr where recid(po_mstr) = recno exclusive-lock:
         end.
      end.
      else
      do:
         /* Creating new record */
         {pxmsg.i &MSGNUM = 1 &ERRORLEVEL = 1}
         create po_mstr. po_mstr.po_domain = global_domain.

         /* FOR ORACLE ENVIRONMENT, COMMITING THE RECORD CREATION */
         /* AFTER ALL THE INDEX FIELDS HAVE BEEN ASSIGNED.        */
         if recid(po_mstr) = -1 then.
         if c-application-mode <> "API" then
            assign po_nbr = input po_nbr.
         else
            assign
              {mfaiset.i po_nbr ttPurchaseOrder.nbr}.

         if c-application-mode = "API"
         then do:
            {gprun.i ""gpxrcrln.p""
             "(input po_nbr,
               input 0,
               input ttPurchaseOrder.extRef,
               input 0,
               input 'po')"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         assign
            po_ord_date = today
            po_due_date = today
            po_ship = poc_ship
            po_bill = poc_bill
            po_confirm = yes
            po_user_id = global_userid
            po_fst_id = poc_fst_id
            po_pst_id = poc_pst_id
            po_vend = vd_addr
            po_sched = yes
            po_ers_opt = "1"
            po_cr_terms = vd_cr_terms
            po_buyer = vd_buyer
            po_disc_pct = vd_disc_pct
            po_shipvia = vd_shipvia
            po_taxable = vd_taxable
            po_contact = vd_pur_cntct
            po_rmks = vd_rmks
            po_ap_acct = vd_ap_acct
            po_ap_sub = vd_ap_sub
            po_ap_cc = vd_ap_cc
            po_curr = vd_curr
            po_lang = vd_lang
            po_sch_mthd = ad_sch_mthd
            po_inv_mthd = ad_po_mthd
            .

         recno = recid(po_mstr).
         tax_date = today.

         assign
            po_taxable   = ad_taxable
            po_tax_usage = ad_tax_usage
            po_taxc      = ad_taxc
            tax_in       = ad_tax_in.

         if po_ap_acct = ""
         then do:
            for first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock:
            end.
            assign
               po_ap_acct = gl_ap_acct
               po_ap_sub  = gl_ap_sub
               po_ap_cc   = gl_ap_cc.
         end.

         /* IF USING SUPPLIER CONSIGNMENT THEN INITIALIZE */
         /* CONSIGNMENT FIELDS.   */
         if using_supplier_consignment then do:
            {pxrun.i &PROC = 'initializeSuppConsignFields'
                     &PARAM="(input po_vend,
                              output po_consignment,
                              output po_max_aging_days)"}
            if return-value <> {&SUCCESS-RESULT}
               then do:
               if return-value = "3388" then do:
                  {pxmsg.i &MSGNUM=return-value &ERRORLEVEL=3
                           &MSGARG1= getTermLabel(""SUPPLIER_CONSIGNMENT"",30)}
               end.
               else do:
                  {pxmsg.i &MSGNUM=return-value &ERRORLEVEL=2}
               end.
               if c-application-mode <> "API"
               then do:
                  next-prompt po_vend with frame po.
                  undo, retry.
               end.  /* If c-application-mode <> "API"*/
               else  /* c-application-mode = "API"*/
                  undo mainloop, return error.
            end. /* if return-value <> */
            if c-application-mode <> "API" then
               display po_consignment with frame po1.
         end. /* If using_supplier_consignment */
      end.  /* end of create po_mstr                  */

      if c-application-mode = "API" then
         assign {mfaiset.i po_app_owner ttPurchaseOrder.appOwner}.

      po_recid = recid(po_mstr).

      /* HEADER DATA ITEMS */

      pocmmts = (po_cmtindx <> 0 or (new po_mstr and poc_hcmmts)).

      print_sch =
        (po_sch_mthd = ""
         or
         substring(po_sch_mthd,1,1) = "p"
         or
         substring(po_sch_mthd,1,1) = "b"
         or
         substring(po_sch_mthd,1,1) = "y").

      edi_sch =
        (substring(po_sch_mthd,1,1) = "e"
         or
         substring(po_sch_mthd,1,1) = "b"
         or
         substring(po_sch_mthd,2,1) = "y").

      fax_sch = substring(po_sch_mthd,3,1) = "y".

      if c-application-mode <> "API" then
         display
            po_ap_acct
            po_ap_sub
            po_ap_cc
            po_taxable
            po_taxc
            po_cr_terms
            po_bill
            po_ship
            print_sch
            edi_sch
            fax_sch
            po_site
            po_shipvia
            po_fob
            po_buyer
            po_contact
            po_contract
            po_curr
            pocmmts
            impexp
            po_consignment
         with frame po1.

      setb:
      do with frame po1 on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         /* DO NOT RETRY WHEN PROCESSING API REQUEST */
         if retry and c-application-mode = "API" then
            undo setb, return error.


         if c-application-mode <> "API"
         then do:
            {&RSPOMT-P-TAG1}
            set
               po_ap_acct
               po_ap_sub
               po_ap_cc
               po_taxable
               po_taxc
               po_cr_terms
               po_bill
               po_ship
               print_sch
               edi_sch
               fax_sch
               po_site
               po_consignment      when (using_supplier_consignment)
               po_shipvia
               po_fob
               po_buyer
               po_contact
               po_contract
               po_curr when (new_po)
               pocmmts
               impexp.
            {&RSPOMT-P-TAG2}
         end.
         else do:
            assign
               {mfaiset.i po_ap_acct  ttPurchaseOrder.apAcct }
               {mfaiset.i po_ap_cc    ttPurchaseOrder.apCc   }
               {mfaiset.i po_taxable  ttPurchaseOrder.taxable}
               {mfaiset.i po_cr_terms ttPurchaseOrder.crTerms}
               {mfaiset.i po_bill     ttPurchaseOrder.bill   }
               {mfaiset.i po_ship     ttPurchaseOrder.ship   }
               {mfaiset.i print_sch   ttPurchaseOrder.print_sch}
               {mfaiset.i edi_sch     ttPurchaseOrder.edi_sch}
               {mfaiset.i fax_sch     ttPurchaseOrder.fax_sch}
               {mfaiset.i po_site     ttPurchaseOrder.site   }
               {mfaiset.i po_shipvia  ttPurchaseOrder.shipvia}
               {mfaiset.i po_fob      ttPurchaseOrder.fob    }
               {mfaiset.i po_buyer    ttPurchaseOrder.buyer  }
               {mfaiset.i po_contact  ttPurchaseOrder.contact}
               {mfaiset.i po_contract ttPurchaseOrder.contract}
               {mfaiset.i impexp      ttPurchaseOrder.impexp}
               pocmmts = yes.

            if (new_po) then
               assign {mfaiset.i po_curr ttPurchaseOrder.curr}.

            if not({gpsite.v &field=po_site &blank_ok=yes})
            then do:
               /* Invalid site */
               {pxmsg.i &MSGNUM = 2797 &ERRORLEVEL=3 &MSGARG1=po_site }
               undo, return error.
            end. /* end of if valid site*/

            if not {gpcode.v po_buyer}
            then do:
               /* Value must exist in Generalized Codes */
               {pxmsg.i &MSGNUM = 716 &ERRORLEVEL = 4
                        &MSGARG1 = po_nbr &MSGARG2 = po_buyer }
               undo, return error.
            end.
         end.  /* else do: assign */

         if c-application-mode <> "API"
         then do:
            /* CURRENCY VALIDATION */
            {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
               "(input input po_curr,
                 output mc-error-number)"}
         end. /* if c-application-mode <> "API" */
         else do:
            /* CURRENCY VALIDATION */
            {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                     "(input po_curr,
                     output mc-error-number)"}
         end. /* else do:*/

         if mc-error-number <> 0
         then do:

            {pxmsg.i &MSGNUM = mc-error-number &ERRORLEVEL = 3}
            if c-application-mode <> "API"
            then do:
               next-prompt po_curr.
            end.  /* If c-application-mode <> "API"*/
            else
               undo setb, return error.
         end.


         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}
         /* SET PROJECT VERIFICATION TO NO */
         {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
         /* ACCT/SUB/CC VALIDATION */
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
            "(input  po_ap_acct,
              input  po_ap_sub,
              input  po_ap_cc,
              input  """",
              output valid_acct)"}

         if valid_acct = no
         then do:
            if c-application-mode <> "API"
            then do:
               next-prompt po_ap_acct with frame po1.
               undo, retry.
            end.
            else
               undo setb, return error.
         end.  /* if valid_acct = no then do: */

         if po_curr <> base_curr
         then do:
            for first ac_mstr  where ac_mstr.ac_domain = global_domain and
               ac_code = po_ap_acct
               no-lock:
            end.

            if available ac_mstr and
               ac_curr <> po_curr and ac_curr <> base_curr
            then do:

               {pxrun.i &PROC='mc-chk-transaction-curr'
                        &PROGRAM='mcpl.p'
                        &HANDLE=ph_mcpl
                        &PARAM="(input ac_curr,
                                 input po_curr,
                                 input po_ord_date,
                                 input true,
                                 output mc-error-number)"}

               if mc-error-number <> 0
               then do:
                  /* ACCT CURRENCY MUST MATCH TRANSACTION OR BASE CURR*/
                  {pxmsg.i &MSGNUM = 134 &ERRORLEVEL = 3}
                  if c-application-mode <> "API" then
                  do:
                     next-prompt po_ap_acct with frame d.
                     undo, retry.
                  end.  /* If c-application-mode <> "API"*/
                  else /* c-application-mode = "API"*/
                     undo setb, return error.
               end. /* IF mc-error-number = 0 */
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.


         /*CHECK FOR VALID BILL-TO ADDRESS */
         if not can-find(ad_mstr  where ad_mstr.ad_domain = global_domain and
         ad_addr = po_bill)
         then do:
            /* Bill-To address does not exist */
            {pxmsg.i &MSGNUM=2577 &ERRORLEVEL=3}

            if c-application-mode <> "API"
            then do:
               next-prompt po_bill.
               undo, retry.
            end.  /* If c-application-mode <> "API"*/
            else  /* c-application-mode = "API"*/
               undo setb, return error.
         end.  /*IF NOT CAN-FIND ... */

         if not can-find(ad_mstr  where ad_mstr.ad_domain = global_domain and
         ad_addr = po_ship)
         then do:
            /* Not a valid choice */
             {pxmsg.i &MSGNUM = 13 &ERRORLEVEL = 3}
             if c-application-mode <> "API"
             then do:
                next-prompt po_ship.
                undo, retry.
             end.  /* If c-application-mode <> "API"*/
             else  /* c-application-mode = "API"*/
                undo setb, return error.
         end.  /* if not can-find(ad_mstr where ad_addr = po_ship */

         po_sch_mthd = "nnn".
         if print_sch then substring(po_sch_mthd,1,1) = "y".
         if edi_sch   then substring(po_sch_mthd,2,1) = "y".
         if fax_sch   then substring(po_sch_mthd,3,1) = "y".

         {gprun.i ""gpsiver.p"" "(input po_site,
                                    input ?,
                                    output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if return_int = 0
         then do:

            {pxmsg.i &MSGNUM = 725 &ERRORLEVEL = 3}
            /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
            if c-application-mode <> "API" then
            do:
               next-prompt po_site.
               undo, retry.
            end.  /* If c-application-mode <> "API"*/
            else  /* c-application-mode = "API"*/
               undo setb, return error.
         end.  /* if return_int = 0 then do: */

         /* ALLOW CHG TO EXRATE ON ADD AND MODIFY */
         /* AS LONG AS NO PRH_HIST EXISTS */
         if not can-find(first prh_hist  where prh_hist.prh_domain =
         global_domain and  prh_nbr = po_nbr)
            and po_curr <> base_curr then
            setb_sub:
         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


             /* DO NOT RETRY WHEN PROCESSING API REQUEST */
            if retry and c-application-mode = "API" then
               undo setb, return error.

            /* DEFAULT EXRATE IF NEW PO FROM EXCHANGE RATE TABLE */
            if new_po
            then do:

               /* CREATE EXCHANGE RATE USAGE RECORDS */
               {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                  "(input po_curr,
                    input base_curr,
                    input po_ex_ratetype,
                    input po_ord_date,
                    output po_ex_rate,
                    output po_ex_rate2,
                    output po_exru_seq,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  if c-application-mode <> "API" then
                     undo setb, retry.
                  else
                     undo setb,return error.
               end.
            end. /* if new_po then do: */

            if c-application-mode  = "API" and
               ttPurchaseOrder.exRate <> ? and
               ttPurchaseOrder.baseCurr <> base_curr then
            do:
               /* API message base currency # does not
                 equal MFG/PRO base currency.*/
               {pxmsg.i
                  &MSGNUM = 5079
                  &ERRORLEVEL = 3
                  &MSGARG1 = ttPurchaseOrder.baseCurr
               }
               undo setb, return error.
            end.

            if c-application-mode = "API" and
               ttPurchaseOrder.exRate <> ? then
               assign po_fix_rate = yes.

            /*
             * Copy the exchange rate details from the ttPurchaseOrder Temp
             * Table into the Exchange Rate temp table for use in mcui.p
            */
            if c-application-mode = "API" then do:
               {gpttcp.i ttPurchaseOrder
                         ttTransExchangeRates}
               run setTransExchangeRates in ApiMethodHandle
                  (input table ttTransExchangeRates).
            end.

            {gprunp.i "mcui" "p" "mc-ex-rate-input"
                  "(input po_curr,
                    input base_curr,
                    input po_ord_date,
                    input po_exru_seq,
                    input true,
                    input 12,
                    input-output po_ex_rate,
                    input-output po_ex_rate2,
                    input-output po_fix_rate)"}

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /*setb_sub*/

         /*SS - 111014.1 B*/
            DEFINE VARIABLE seq_code AS CHARACTER.
            DEFINE VARIABLE seq_time1 AS CHARACTER.
            DEFINE VARIABLE seq_time2 AS CHARACTER.
            DEFINE VARIABLE seq_time3 AS CHARACTER.
            DEFINE VARIABLE seq_time4 AS CHARACTER.
            DEFINE VARIABLE seq_time5 AS CHARACTER.
            DEFINE VARIABLE seq_time6 AS CHARACTER.
            DEFINE VARIABLE seq_time7 AS CHARACTER.
            DEFINE VARIABLE seq_time8 AS CHARACTER.
            DEFINE VARIABLE seq_time9 AS CHARACTER.
            DEFINE VARIABLE seq_time10 AS CHARACTER.
            DEFINE VARIABLE seq_time11 AS CHARACTER.
            DEFINE VARIABLE seq_time12 AS CHARACTER.

            DEFINE VARIABLE v_loop AS INTEGER.


            IF po__chr09 = "" THEN DO:          
                ASSIGN seq_code = ""
                       seq_time1 = ""
                       seq_time2 = ""
                       seq_time3 = ""
                       seq_time4 = ""
                       seq_time5 = ""
                       seq_time6 = ""
                       seq_time7 = ""
                       seq_time8 = ""
                       seq_time9 = ""
                       seq_time10 = ""
                       seq_time11 = ""
                       seq_time12 = "".
            END.
            ELSE DO:
                ASSIGN
                    seq_code = ENTRY(1,po__chr09)
                    seq_time1 = ENTRY(2,po__chr09)
                    seq_time2 = ENTRY(3,po__chr09)
                    seq_time3 = ENTRY(4,po__chr09)
                    seq_time4 = ENTRY(5,po__chr09)
                    seq_time5 = ENTRY(6,po__chr09)
                    seq_time6 = ENTRY(7,po__chr09)
                    seq_time7 = ENTRY(8,po__chr09)
                    seq_time8 = ENTRY(9,po__chr09)
                    seq_time9 = ENTRY(10,po__chr09)
                    seq_time10 = ENTRY(11,po__chr09)
                    seq_time11 = ENTRY(12,po__chr09)
                    seq_time12 = ENTRY(13,po__chr09).
            END.
                 

            form

                 RECT-FRAME       AT ROW 1 COLUMN 1.25
                 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
               seq_code colon 13
               seq_time1 NO-LABEL COLON 13
               seq_time2 NO-LABEL
               seq_time3 NO-LABEL
               seq_time4 NO-LABEL
               seq_time5 NO-LABEL
               seq_time6 NO-LABEL
               seq_time7 NO-LABEL COLON 13
               seq_time8 NO-LABEL
               seq_time9 NO-LABEL
               seq_time10 NO-LABEL
               seq_time11 NO-LABEL
               seq_time12 NO-LABEL
               with frame seq_code_frm side-labels overlay
               row 10 column 5 THREE-D.
            
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame seq_code_frm:handle).



            
             display
                seq_code
                seq_time1
                seq_time2
                seq_time3
                seq_time4
                seq_time5
                seq_time6
                seq_time7
                seq_time8
                seq_time9
                seq_time10
                seq_time11
                seq_time12
             with frame seq_code_frm.
            
             set
                seq_code
             with frame seq_code_frm.

             SET
                seq_time1  WHEN seq_code = "011" OR seq_code = "012" OR seq_code = "01A2" OR seq_code = "014" OR seq_code = "016" OR seq_code = "0112"
                seq_time2  WHEN seq_code = "012" OR seq_code = "01A2" OR seq_code = "014" OR seq_code = "016" OR seq_code = "0112"
                seq_time3  WHEN seq_code = "014" OR seq_code = "016" OR seq_code = "0112"
                seq_time4  WHEN seq_code = "014" OR seq_code = "016" OR seq_code = "0112"
                seq_time5  WHEN seq_code = "016" OR seq_code = "0112"
                seq_time6  WHEN seq_code = "016" OR seq_code = "0112"
                seq_time7  WHEN seq_code = "0112"
                seq_time8  WHEN seq_code = "0112"
                seq_time9  WHEN seq_code = "0112"
                seq_time10 WHEN seq_code = "0112"
                seq_time11 WHEN seq_code = "0112"
                seq_time12 WHEN seq_code = "0112"
             with frame seq_code_frm.
            
             ASSIGN po__chr09 = seq_code + "," 
                                + seq_time1 + ","
                                + seq_time2 + "," 
                                + seq_time3 + ","
                                + seq_time4 + ","
                                + seq_time5 + ","
                                + seq_time6 + ","
                                + seq_time7 + ","
                                + seq_time8 + ","
                                + seq_time9 + ","
                                + seq_time10 + ","
                                + seq_time11 + ","
                                + seq_time12  .

             hide frame seq_code_frm.

         /*SS - 111014.1 E*/



         /* VALIDATE TAX CODE  */
         {gptxcval.i &code=po_taxc &frame="b"}
         {&RSPOMT-P-TAG3}
         set_tax:
         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

             /* DO NOT RETRY WHEN PROCESSING API REQUEST */
             if retry and c-application-mode = "API" then
                undo set_tax, return error.

            if po_tax_env = ""
            then do:

               /* GET SHIP-TO TAX ZONE FROM PO_SHIP ADDRESS */
               for first ad_mstr  where ad_mstr.ad_domain = global_domain and
                  ad_addr = po_ship no-lock:
               end.
               if available(ad_mstr) then zone_to = ad_tax_zone.
               else do:
                  {pxmsg.i &MSGNUM = 864 &ERRORLEVEL = 2}
                  /* SITE ADDRESS DOES NOT EXIST */
                  zone_to = "".
               end.

               /* GET VENDOR SHIP-FROM TAX ZONE FROM ADDRESS */
               for first ad_mstr  where ad_mstr.ad_domain = global_domain and
               ad_addr = po_vend
                  no-lock:
               end.
/*GUI*/ if global-beam-me-up then undo, leave.

               if available(ad_mstr) then zone_from = ad_tax_zone.

               /* SUGGEST A TAX ENVIRONMENT */
               {gprun.i ""txtxeget.p"" "(input  zone_to,
                                         input  zone_from,
                                         input  po_taxc,
                                         output po_tax_env)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            if c-application-mode <> "API" then
               update po_tax_usage po_tax_env with frame set_tax.
            else /* if c-application-mode == "API" then */
                assign
                    {mfaiset.i po_tax_usage  ttPurchaseOrder.taxUsage}
                    {mfaiset.i po_tax_env    ttPurchaseOrder.taxEnv}.

            /* VALIDATE TAX ENVIRONMENT */
            if po_tax_env = ""
            then do:
               /* Blank tax environment not allowed */
               {pxmsg.i &MSGNUM = 944 &ERRORLEVEL = 3}
               /* ALLOWED */
               if c-application-mode <> "API"
               then do:
                  next-prompt po_tax_env with frame set_tax.
                  undo, retry set_tax.
               end.  /* If c-application-mode <> "API"*/
               else  /* c-application-mode = "API"*/
                  undo set_tax, return error.
            end.  /*if po_tax_env = "" then do: */

            if not {gptxe.v po_tax_env ""no""}
            then do:
               /* Tax environment does not exist */
               {pxmsg.i &MSGNUM = 869 &ERRORLEVEL = 3}
               if c-application-mode <> "API"
               then do:
                  next-prompt po_tax_env with frame set_tax.
                  undo, retry set_tax.
               end.  /* If c-application-mode <> "API"*/
               if c-application-mode = "API" then
                  undo set_tax, return error.
            end.
         end.  /* SET_TAX */

         if c-application-mode <> "API" then
            hide frame set_tax.
         {&RSPOMT-P-TAG4}

         if use-log-acctg and c-application-mode <> "API"
         then do:
            /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
            {gprunmo.i &module = "LA" &program = "lapomt.p"
                       &param  = """(input po_recid,
                                     input no)"""}

         end.

         /* IF IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT*/
         /* CREATE ROUTINE TO CREATE ie_mstr ied_det AND UPDATE ie_mstr */
         if impexp
         then do:
            imp-okay = no.
            if c-application-mode = "API"
            then do:
               for first ttImportExport
               where  ttImportExport.apiExternalKey
                    = ttPurchaseOrder.apiExternalKey:
               end.

               if not available ttImportExport
               then do:
                  /* Required Data not Received From the API Interface. */
                  {pxmsg.i
                    &MSGNUM = 4698 &ERRORLEVEL = 4 &MSGARG1 = ""IntrastatData""}
                  undo setb, return error.
               end.

               run setImportExportRow in ApiMethodHandle
               (ttImportExport.apiSequence).

            end. /*if c-application-mode = "API" */
            {gprun.i ""iemstrcr.p"" "(input ""2"",
                                      input po_nbr,
                                      input recid(po_mstr),
                                      input-output imp-okay )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if imp-okay = no
            then do:
               if c-application-mode <> "API"
               then do:
                  view frame  po1 .
                  undo , retry.
               end.  /* If c-application-mode <> "API"*/
               else  /* c-application-mode = "API"*/
                  undo, return error.
            end.
         end.

         for first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock:
         end.

         /* UPDATE ERS FIELDS ONLY IF ERS PROCESSING ENABLED */
         if available poc_ctrl and poc_ers_proc
         then do with frame po-ers:
            if new_po then
               po_ers_opt = poc_ers_opt.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame po-ers:handle).
            if c-application-mode <> "API" then
               display
                  po_ers_opt   colon 23 skip
                  po_pr_lst_tp colon 23 space(1)
               with frame po-ers side-labels overlay centered
                  row (frame-row(po1) + 5).

            ers-loop:
            do with frame po-ers on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               /* DO NOT RETRY WHEN PROCESSING API REQUEST */
               if retry and c-application-mode = "API" then
                  undo ers-loop, return error.

               if c-application-mode <> "API" then
                  set po_ers_opt po_pr_lst_tp with frame po-ers.
               else
                  assign
                     {mfaiset.i po_ers_opt  ttPurchaseOrder.ersOpt}
                     {mfaiset.i po_pr_lst_tp  ttPurchaseOrder.prLstTp}.

               /* VALIDATE ERS OPTION */
               if not({gppoers.v po_ers_opt})
               then do:
                  /*  Invalid ERS option */
                  {pxmsg.i &MSGNUM = 2303 &ERRORLEVEL = 3}
                  if c-application-mode = "API"
                  then do:
                     next-prompt po_ers_opt.
                     undo, retry ers-loop.
                  end.  /* If c-application-mode = "API"*/
                  else  /* c-application-mode <> "API"*/
                     undo ers-loop,return error.
               end. /* if not({gppoers.v po_ers_opt}) then do: */

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* ERS-LOOP */

            if c-application-mode <> "API" then
               hide frame po-ers.
         end.  /* IF AVAIL POC_CTRL */

         if using_supplier_consignment and po_consignment
            and c-application-mode <> "API"
         then do:
            {pxrun.i &PROC='setAgingDays'
                     &PARAM="(input-output po_max_aging_days)"}

            hide frame aging.
         end.

         if c-application-mode <> "API" then
            hide frame po1.

      end.

      /* HEADER COMMENTS */

      global_lang = po_lang.
      global_type = "".

      if pocmmts = yes then do on error undo mainloop, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         if c-application-mode = "API"
         then do:
            {gpttcp.i ttPurchaseOrderCmt
                      ttTransComment
                      "ttPurchaseOrderCmt.apiExternalKey =
                      ttPurchaseOrder.apiExternalKey"}
            run setTransComment in ApiMethodHandle
             (input table ttTransComment).

         end.

         cmtindx = po_cmtindx.
         global_ref = po_vend.
         {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

         po_mstr.po_cmtindx = cmtindx.

         if c-application-mode <> "API" then
            view frame po.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* end of block_2  */

   impexp_order = po_nbr.

   release po_mstr.

   {&RSPOMT-P-TAG5}
   {gprun.i ""rsrsoup.p"" "(input po_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* DO DETAIL MAINTENANCE */
   {gprun.i ""rspomtb.p""
      "(input po_recid,
        input using_supplier_consignment)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT DETAIL */
   /* LINE MAINTENANCE PROGRAM FOR USER TO UPDATE ied_det            */

   if not batchrun and impexp
   then do:
      impexp_edit = no.
      /*  View/Edit import/export data */
      if c-application-mode <> "API" then
         {pxmsg.i &MSGNUM = 271 &ERRORLEVEL = 1 &CONFIRM=impexp_edit}

      if impexp_edit then do:
         upd_okay = no.

         if c-application-mode = "API"
         then do:
             for first ttImportExport
                     where  ttImportExport.apiExternalKey
                         = ttPurchaseOrder.apiExternalKey:
                run setImportExportRow in ApiMethodHandle
                   (ttImportExport.apiSequence).
             end.
         end. /* if c-applicaton-mode = API*/

         {gprun.i ""iedmta.p"" "(input ""2"",
                                 input impexp_order,
                                 input-output upd_okay )" }
/*GUI*/ if global-beam-me-up then undo, leave.

      end.
   end.

   if c-application-mode = "API" then
      leave mainloop.
end.
{&RSPOMT-P-TAG6}
/* RETURN SUCCESS STATUS TO API CALLER */
if c-application-mode = "API" then
   return {&SUCCESS-RESULT}.
