/* rspomt.p - Release Management Supplier Schedules                           */
/* Copyright 1986 QAD Inc. All rights reserved.                               */
/* $Id:: rspomt.p 28833 2013-02-19 20:21:18Z kbh                           $: */
/*                                                                            */
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
/* Revision: 1.11.2.20     BY: Niall Shanahan     DATE: 01/27/03  ECO: *M226* */
/* Revision: 1.11.2.22     BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.11.2.23     BY: Rajinder Kamra     DATE: 05/02/03  ECO: *Q003* */
/* Revision: 1.11.2.24     BY: Ed van de Gevel    DATE: 03/07/05  ECO: *R00K* */
/* Revision: 1.11.2.25     BY: Robin McCarthy     DATE: 09/07/05  ECO: *P2PJ* */
/* Revision: 1.11.2.26     BY: Andrew Dedman      DATE: 10/13/05  ECO: *R01P* */
/* Revision: 1.11.2.27     BY: Ellen Borden       DATE: 01/17/06  ECO: *R008* */
/* Revision: 1.11.2.30     BY: Steve Nugent       DATE: 03/15/06  ECO: *R001* */
/* Revision: 1.11.2.31     BY: Robin McCarthy     DATE: 05/11/06  ECO: *P4JX* */
/* Revision: 1.11.2.32     BY: Changlin Zeng      DATE: 05/17/06  ECO: *R045* */
/* Revision: 1.11.2.33     BY: Robin McCarthy     DATE: 05/31/06  ECO: *R02F* */
/* Revision: 1.11.2.35     BY: Katie Hilbert      DATE: 07/19/06  ECO: *R07D* */
/* Revision: 1.11.2.36     BY: Suyash Keny        DATE: 08/23/06  ECO: *P530* */
/* Revision: 1.11.2.37     BY: Rafiq S.           DATE: 11/09/06  ECO: *P5DQ* */
/* Revision: 1.11.2.38     BY: Deirdre O'Brien    DATE: 07/13/07  ECO: *R0C6* */
/* Revision: 1.11.2.39     BY: Anju Dubey         DATE: 12/12/07  ECO: *P6GV* */
/* Revision: 1.11.2.40     BY: Neil Curzon        DATE: 05/08/09  ECO: *R1HB* */
/* Revision: 1.11.2.42     BY: Avishek Chakraborty  DATE: 05/13/10  ECO: *R20F* */
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
 
/* SCHEDULED ORDER MAINT */
 
{us/mf/mfdtitle.i}
{us/px/pxphdef.i gpcodxr}
 
/* Clear anything displayed by mftitle if api mode*/
{us/mf/mfaititl.i}
{us/px/pxmaint.i}
{us/px/pxphdef.i mcpl}
{us/tx/txusgdef.i}   /*PRE-PROCESSOR CONSTANTS FOR I19 */
 
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
define variable l_posite      like po_site no-undo.
 
define variable hBlockedTransactionlibrary as handle no-undo.
define variable w-orig-eff-strt like po_eff_strt no-undo.
define variable w-orig-eff-to   like po_eff_to   no-undo.
define variable poad_found      as logical       no-undo.
define variable la-okay         like mfc_logical no-undo.
define variable old_rev                  as   integer            no-undo.
define variable rev_change               like mfc_logical        no-undo.
define variable edi_po                   as   logical            no-undo.
define variable cErrorArgs               as   character          no-undo.
define buffer scxref for scx_ref.
define variable is-valid                 as   logical            no-undo.
 
{us/po/pocnvars.i} /* Consignment variables */
{us/po/pocnpo.i}  /* consignment procedures and frames */
 
{us/gp/gptxcdec.i}  /* DECLARATIONS FOR us/gp/gptxcval.i */
 
/*COMMON API CONSTANTS AND VARIABLES*/
{us/mf/mfaimfg.i}
 
/*PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "api" PREFIX*/
{us/po/popoit01.i}
 
/*Import  Export API TEMP-TABLE, NAMED USING THE "api" PREFIX*/
{us/ic/icieit01.i}
{us/mf/mfctit01.i}
{us/mc/mctrit01.i}
 
define variable daybookSetBySiteInstalled like mfc_logical no-undo.
define variable hDaybooksetValidation as handle    no-undo.
define variable iErrorNumber          as integer   no-undo.
define variable daybookDate           as date       no-undo.
 
/* DAYBOOKSET VALIDATION LIBRARY PROTOTYPES */
{us/dy/dybvalpl.i hDaybooksetValidation}
 
/* INITIALIZE PERSISTENT PROCEDURES */
run mfairunh.p
   (input "dybvalpl.p",
    input ?,
    output hDaybooksetValidation).
 
run setvalidMode in hDaybooksetValidation
               (input  true).
 
 
if c-application-mode = "API" then
   do on error undo, return error:
 
   /*GET HANDLE OF API CONTROLLER*/
   {us/bbi/gprun.i ""gpaigh.p""
      "(output ApiMethodHandle,
        output ApiProgramName,
        output ApiMethodName,
        output apiContextString)"}
 
   /* GET LOCAL PO MASTER TEMP-TABLE */
   create ttPurchaseOrder.
   run getPurchaseOrderRecord in ApiMethodHandle
      (buffer ttPurchaseOrder).
 
   run getPurchaseOrderCmt in ApiMethodHandle
      (output table ttPurchaseOrderCmt).
 
   run getpoTrans in ApiMethodHandle (output poTrans).
 
   if ttPurchaseOrder.impexp = yes
   then do:
      create ttImportExport.
      run setImportExportRow in ApiMethodHandle
          (ttImportExport.apiSequence).
      run getImportExportRecord in ApiMethodHandle
          (buffer ttImportExport).
   end. /* IF ttPurchaseOrder.impexp = yes */
 
end.  /* If c-application-mode = "API" */
 
/* TAX MANAGEMENT FORM */
form
   po_tax_usage colon 25
   po_tax_env  colon 25
   space(2)
with frame set_tax row 8 centered overlay side-labels.
 
/* SET EXTERNAL LABELS */
setFrameLabels(frame set_tax:handle).
 
if no then
   for first pod_det where pod_domain = global_domain no-lock: end.
 
{us/rs/rsordfrm.i}
 
/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{us/bbi/gprun.i ""lactrl.p"" "(output use-log-acctg)"}
 
/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{us/bbi/gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}
 
{us/mg/mgbltrpl.i "hBlockedTransactionlibrary"}
 
/* start blocked transaction library to run persistently */
run mfairunh.p
   (input "mgbltrpl.p",
    input  ?,
    output hBlockedTransactionlibrary).
 
mainloop:
repeat:
   /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API" then
      undo mainloop, return.
 
   for first poc_ctrl where poc_domain = global_domain no-lock: end.
   for first iec_ctrl where iec_domain = global_domain no-lock: end.
 
   assign 
      daybookSetBySiteInstalled = poc_dybkset_by_site
      pocmmts = poc_hcmmts.
 
   if c-application-mode <> "API" then do:
      hide frame pod2.
      hide frame pod1.
      hide frame pod.
      hide frame po1.
   end.
 
   block_1:
   do with frame po:
      if c-application-mode <> "API" then do:
         prompt-for po_nbr po_vend
         editing:
            if frame-field = "po_nbr" then do:
               {us/mf/mfnp05.i po_mstr po_nbr " po_domain = global_domain and
                    po_sched"  po_nbr "input po_nbr"}
 
               if recno <> ? then do:
                  for first ad_mstr where ad_domain = global_domain
                     and  ad_addr = po_vend
                  no-lock:  end.
 
                  display
                     po_nbr
                     po_vend
                     ad_name.
               end.
            end.
            else if frame-field = "po_vend" then do:
               {us/mf/mfnp05.i vd_mstr vd_addr  " vd_domain = global_domain
                    and yes "  vd_addr "input po_vend"}
 
               if recno <> ? then do:
                  for first ad_mstr where ad_domain = global_domain
                     and  ad_addr = vd_addr no-lock: end.
 
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
 
      /* Check to see if Supplier has any blocked transactions */
      if blockedSupplier(input (input po_vend),
                         input {&PO006},
                         input true,
                         input "Supplier")
      then do:
         undo mainloop, retry mainloop.
      end.
 
      /* SET THE DEFAULT VALUE BASED ON IEC_CTRL FILE */
      if available iec_ctrl then
         impexp = iec_impexp.
 
      if c-application-mode <> "API" then
         for first po_mstr
            where po_domain = global_domain
            and   po_nbr = input po_nbr
         no-lock: end.
      else
         for first po_mstr
            where po_domain = global_domain
            and   po_nbr = ttPurchaseOrder.nbr
         no-lock: end.
 
      assign
         old_rev    = 0
         edi_po     = no
         rev_change = yes.
 
      if available po_mstr then do:
         old_rev     = po_rev.
 
         if not po_sched then do:
            {us/bbi/pxmsg.i &MSGNUM = 8181 &ERRORLEVEL = 3}
            if c-application-mode <> "API" then do:
               bell.
               undo, retry.
            end.
            else
               undo mainloop, return error.
         end.  /* if not po_sched then do: */
 
         if po_trade_sale
         then do:
            del-yn = no.
            for first rsc_ctrl
               where rsc_ctrl.rsc_domain = global_domain
            no-lock:
            end. /* FOR FIRST rsc_ctrl */
        if available rsc_ctrl
        then do:
               if not rsc__qadl02
               then do:
                  /* TRADE SALE PO, MODIFICATION NOT ALLOWED */
                  {us/bbi/pxmsg.i &MSGNUM=8844 &ERRORLEVEL=3}
                  if c-application-mode <> "API"
                  then do:
                     bell.
                     undo, retry.
                  end. /*IF c-application-mode <> "API"*/
                  else do:
                     undo mainloop, return error.
                  end.
               end. /* IF NOT rsc__qadl02 */
               else do:
                  /* TRADE SALES PURCHASE ORDER, DO YOU WISH TO CONTINUE */
                  {us/bbi/pxmsg.i &MSGNUM=11110 &ERRORLEVEL=1 &CONFIRM=del-yn}
                  if not del-yn
                  then do:
                     if c-application-mode <> "API"
                     then do:
                        bell.
                        undo, retry.
                     end. /*IF c-application-mode <> "API"*/
                     else do:
                        undo mainloop, return error.
                     end. /* ELSE DO */
                  end. /* IF NOT del-yn */
               end. /* ELSE DO */
        end. /* IF AVAILABLE rsc_ctrl */
         end. /*IF po_trade_sale*/
 
         assign
            w-orig-eff-strt = po_eff_strt
            w-orig-eff-to   = po_eff_to
            new_po = no
            recno = recid(po_mstr).
 
         if c-application-mode <> "API" then
            for first ad_mstr
               where ad_domain = global_domain
               and   ad_addr = po_vend
            no-lock: end.
         else do:
            vend = po_vend.
            assign {us/mf/mfaiset.i vend ttPurchaseOrder.vend}.
 
            for first ad_mstr
               where ad_domain = global_domain
               and   ad_addr = vend
            no-lock: end.
         end.
 
         if c-application-mode <> "API" then
            display
               po_nbr
               po_vend
               ad_name.
 
         assign
            pocmmts        = (po_cmtindx <> 0)
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
               po_eff_strt
               po_eff_to
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
               po_fix_pr
               po_rev
               po_rev_date
               po_print
               po_daybookset
               pocmmts
               impexp
               po_consignment
               po_zero_sched
            with frame po1.
 
         {us/bbi/gprun.i ""gpsiver.p""
                  "(input po_site,
                    input ?, output return_int)"}
 
 
         if return_int = 0 then do:
            /* USER DOES NOT HAVE ACCESS TO SITE */
            {us/bbi/pxmsg.i &MSGNUM = 725 &ERRORLEVEL = 3}
            if c-application-mode <> "API" then
               undo mainloop, retry mainloop.
            else
               undo mainloop, return error.
         end.
 
         l_posite = po_site.
 
      end.  /* IF AVAILABLE PO_MSTR */
 
      if c-application-mode <> "API" then
         for first vd_mstr
            where vd_domain = global_domain
            and   vd_addr = input po_vend
         no-lock: end.
      else do:
         if available po_mstr then
            vend = po_vend.
         else
            vend = "".
 
         assign {us/mf/mfaiset.i vend ttPurchaseOrder.vend}.
 
         for first vd_mstr
            where vd_domain = global_domain
            and   vd_addr = vend
         no-lock: end.
      end.  /* else [if c-application-mode <> "API" then] */
 
      if not available vd_mstr then do:
         /* Not a valid supplier   */
         {us/bbi/pxmsg.i &MSGNUM = 2 &ERRORLEVEL = 3}
         if c-application-mode <> "API" then do:
            next-prompt po_vend.
            undo, retry.
         end.
         else
            undo mainloop, return error.
      end. /* if not available vd_mstr then do: */
 
      /* Check to see if Supplier has any blocked transactions */
      if blockedSupplier(input (input po_vend),
                         input {&PO006},
                         input true,
                         input "Supplier")
      then do:
         undo mainloop, retry mainloop.
      end.
 
      if c-application-mode <> "API" then
         for first pod_det
            where pod_domain = global_domain
            and   pod_nbr = input po_nbr
         no-lock: end.
      else
         for first pod_det
            where pod_domain = global_domain
            and   pod_nbr = ttPurchaseOrder.nbr
         no-lock: end.
 
      if available pod_det
         and pod_po_db <> global_db
      then do:
 
         {us/bbi/pxmsg.i &MSGNUM=6145 &ERRORLEVEL=3
                  &MSGARG1=getTermLabel(""PURCHASE_ORDER"",35)
                  &MSGARG2=pod_po_db}
 
         if c-application-mode <> "API" then
            undo, retry.
         else
            undo mainloop, return.
      end.  /* if available pod_det and pod_po_db <> global_db then do:*/
 
      for first ad_mstr
         where ad_domain = global_domain
         and   ad_addr = vd_addr
      no-lock: end.
 
      if c-application-mode <> "API" then
         display
            ad_name.
 
      if not available po_mstr then do:
         new_po = yes.
 
         if (c-application-mode <> "API" and input po_nbr = "") or
            (c-application-mode = "API" and ttPurchaseOrder.nbr = ? and
            poTrans = "GETPONUM")
         then do transaction:
            {us/mf/mfnctrlc.i "poc_domain = global_domain"
               "poc_domain" "po_domain = global_domain" poc_ctrl
               poc_po_pre poc_po_nbr po_mstr po_nbr ponbr}
 
            for first poc_ctrl where poc_domain = global_domain
            no-lock: end.
 
            if c-application-mode <> "API" then
               display
                  ponbr @ po_nbr.
            else do:
               ttPurchaseOrder.nbr = ponbr.
 
               run setPurchaseOrderRecord in ApiMethodHandle
                  (buffer ttPurchaseOrder).
               return.
            end.
         end.
         else if (c-application-mode = "API" and poTrans <> "GETPONUM") then
            ponbr = ttPurchaseOrder.nbr.
         else if (c-application-mode = "API" and poTrans = "GETPONUM") then
            return.
      end. /*if not available po_mstr                     */
      else if (c-application-mode = "API" and poTrans = "GETPONUM") then
         return.
   end. /* end of block_1                                 */
 
   block_2:
   do transaction:
 
      for first poc_ctrl where poc_domain = global_domain no-lock: end.
      if not new_po then do:
         for first po_mstr where recid(po_mstr) = recno exclusive-lock: end.
         tax_in = ad_tax_in.
      end.
      else do:
         /* Creating new record */
         {us/bbi/pxmsg.i &MSGNUM = 1 &ERRORLEVEL = 1}
 
         create po_mstr.
         po_domain = global_domain.
 
         /* FOR ORACLE ENVIRONMENT, COMMITING THE RECORD CREATION */
         /* AFTER ALL THE INDEX FIELDS HAVE BEEN ASSIGNED.        */
         if recid(po_mstr) = -1 then.
 
         if c-application-mode <> "API" then
            po_nbr = input po_nbr.
         else
            assign
               {us/mf/mfaiset.i po_nbr ttPurchaseOrder.nbr}.
 
         if c-application-mode = "API" then do:
            {us/bbi/gprun.i ""gpxrcrln.p""
                     "(input po_nbr,
                       input 0,
                       input ttPurchaseOrder.extRef,
                       input 0,
                       input 'po',
                       input '',
                       input '',
                       input '',
                       input '')"}
         end.
 
         assign
            po_site       = vd_site
            po_ord_date   = today
            po_due_date   = today
            po_ship       = poc_ship
            po_bill       = poc_bill
            po_confirm    = yes
            po_user_id    = global_userid
            po_fst_id     = poc_fst_id
            po_pst_id     = poc_pst_id
            po_vend       = vd_addr
            po_sched      = yes
            po_ers_opt    = "1"
            po_cr_terms   = vd_cr_terms
            po_buyer      = vd_buyer
            po_disc_pct   = vd_disc_pct
            po_shipvia    = vd_shipvia
            po_taxable    = vd_taxable
            po_contact    = vd_pur_cntct
            po_rmks       = vd_rmks
            po_curr       = vd_curr
            po_lang       = vd_lang
            po_sch_mthd   = ad_sch_mthd
            po_inv_mthd   = ad_po_mthd
            po_eff_strt   = today
            po_zero_sched = poc_zero_sched
            po_fix_pr     = vd_fix_pr
            po_print      = yes.
 
         {us/px/pxrun.i &PROC='getEdiPo' &PROGRAM='popoxr.p'
                  &PARAM="(input  po_inv_mthd,
                           output edi_po)"
                  &NOAPPERROR=TRUE &CATCHERROR=TRUE}
 
         if edi_po then
            po_print = no.
 
         assign
            recno        = recid(po_mstr)
            tax_date     = today
            po_taxable   = vd_taxable
            po_tax_usage = vd_tax_usage
            po_taxc      = vd_taxc
            tax_in       = vd_tax_in.
 
         /* IF USING SUPPLIER CONSIGNMENT THEN INITIALIZE */
         /* CONSIGNMENT FIELDS.   */
         if using_supplier_consignment then do:
            {us/px/pxrun.i &PROC = 'initializeSuppConsignFields'
                     &PARAM="(input  po_vend,
                              output po_consignment,
                              output po_max_aging_days,
                              output po_consign_cost_point)"}
            if return-value <> {&SUCCESS-RESULT} then do:
               if return-value = "3388" then do:
                  {us/bbi/pxmsg.i &MSGNUM=return-value &ERRORLEVEL=3
                           &MSGARG1= getTermLabel(""SUPPLIER_CONSIGNMENT"",30)}
               end.
               else do:
                  {us/bbi/pxmsg.i &MSGNUM=return-value &ERRORLEVEL=2}
               end.
 
               if c-application-mode <> "API" then do:
                  next-prompt po_vend with frame po.
                  undo, retry.
               end.
               else
                  undo mainloop, return error.
            end. /* if return-value <> */
 
            if c-application-mode <> "API" then
               display po_consignment with frame po1.
         end. /* If using_supplier_consignment */
      end.  /* end of create po_mstr                  */
 
      if c-application-mode = "API" then
         assign {us/mf/mfaiset.i po_app_owner ttPurchaseOrder.appOwner}.
 
      po_recid = recid(po_mstr).
 
      /* HEADER DATA ITEMS */
      pocmmts = (po_cmtindx <> 0 or (new po_mstr and poc_hcmmts)).
 
      print_sch = (po_sch_mthd = ""
         or
         substring(po_sch_mthd,1,1) = "p"
         or
         substring(po_sch_mthd,1,1) = "b"
         or
         substring(po_sch_mthd,1,1) = "y").
 
      edi_sch = (substring(po_sch_mthd,1,1) = "e"
         or
         substring(po_sch_mthd,1,1) = "b"
         or
         substring(po_sch_mthd,2,1) = "y").
 
      fax_sch = substring(po_sch_mthd,3,1) = "y".
 
      if po_daybookset = ""
      then do:
         if daybookSetBySiteInstalled then do:
            for first dybs_mstr 
               where dybs_domain = global_domain
                 and dybs_type = '2'
                 and dybs_site = po_site
            no-lock:
               po_daybookset = dybs_code.
            end.
            if po_daybookset = "" then do:
               for first dybs_mstr 
                  where dybs_domain = global_domain
                    and dybs_type = '2'
                    and dybs_site = ''
               no-lock:
                  po_daybookset = dybs_code.
               end.
            end.
            if po_daybookset = "" then
               po_daybookset = getDefaultDaybookSetBySite( input po_vend).
         end.
         else
            po_daybookset = getDefaultDaybookSetBySite( input po_vend).
      end.
 
      if c-application-mode <> "API" then
         display
            po_eff_strt
            po_eff_to
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
            po_fix_pr
            po_rev
            po_rev_date
            po_print
            po_daybookset
            pocmmts
            impexp
            po_consignment
            po_zero_sched
         with frame po1.
 
      /*WARNING IF ORDER IS INACTIVE*/
      if po_eff_to <> ? and po_eff_to < today then do:
         /*ORDER IS INACTIVE*/
         {us/bbi/pxmsg.i &MSGNUM = 6721 &ERRORLEVEL = 2}.
      end.
 
      setb:
      do with frame po1 on error undo, retry:
         /* DO NOT RETRY WHEN PROCESSING API REQUEST */
         if retry and c-application-mode = "API" then
            undo setb, return error.
 
         if c-application-mode <> "API" then do:
            set
               po_eff_strt
               po_eff_to
               po_taxable
               po_taxc
               po_cr_terms
               po_bill
               po_ship
               print_sch
               edi_sch
               fax_sch
               po_site
               po_consignment when (using_supplier_consignment)
               po_zero_sched
               po_shipvia
               po_fob
               po_buyer
               po_contact
               po_contract
               po_curr when (new_po)
               po_fix_pr
               po_rev
               po_rev_date
               po_print
               po_daybookset
               pocmmts.
 
            for first iec_ctrl where iec_domain = global_domain no-lock: end.
            impexp = (available iec_ctrl and iec_impexp).
            if impexp then do:
               impexp = can-find (first ie_mstr
                           where ie_domain = global_domain
                           and   ie_type = "2"
                           and   ie_nbr = po_nbr).
               if new_po then do:
                  {us/bbi/gprun.i ""ieckcty2.p""
                           "(input  po_vend,
                             input  po_ship,
                             input  '2',
                             output impexp)"}
               end.
            end.
            update impexp.
         end.
         else do:
            assign
               {us/mf/mfaiset.i po_eff_strt   ttPurchaseOrder.effStrt}
               {us/mf/mfaiset.i po_eff_to     ttPurchaseOrder.effTo}
               {us/mf/mfaiset.i po_taxable    ttPurchaseOrder.taxable}
               {us/mf/mfaiset.i po_cr_terms   ttPurchaseOrder.crTerms}
               {us/mf/mfaiset.i po_bill       ttPurchaseOrder.bill}
               {us/mf/mfaiset.i po_ship       ttPurchaseOrder.ship}
               {us/mf/mfaiset.i print_sch     ttPurchaseOrder.print_sch}
               {us/mf/mfaiset.i edi_sch       ttPurchaseOrder.edi_sch}
               {us/mf/mfaiset.i fax_sch       ttPurchaseOrder.fax_sch}
               {us/mf/mfaiset.i po_site       ttPurchaseOrder.site}
               {us/mf/mfaiset.i po_shipvia    ttPurchaseOrder.shipvia}
               {us/mf/mfaiset.i po_fob        ttPurchaseOrder.fob}
               {us/mf/mfaiset.i po_buyer      ttPurchaseOrder.buyer}
               {us/mf/mfaiset.i po_contact    ttPurchaseOrder.contact}
               {us/mf/mfaiset.i po_contract   ttPurchaseOrder.contract}
               {us/mf/mfaiset.i impexp        ttPurchaseOrder.impexp}
               {us/mf/mfaiset.i po_zero_sched ttPurchaseOrder.zeroSched}
               {us/mf/mfaiset.i po_fix_pr     ttPurchaseOrder.fixPr}
               {us/mf/mfaiset.i po_rev        ttPurchaseOrder.rev}
               {us/mf/mfaiset.i po_rev_date   ttPurchaseOrder.revDate}
               {us/mf/mfaiset.i po_print      ttPurchaseOrder.print}
               pocmmts = yes.
 
            if (new_po) then
               assign {us/mf/mfaiset.i po_curr ttPurchaseOrder.curr}.
 
            if not({gpsite.v &field=po_site &blank_ok=yes}) then do:
               {us/bbi/pxmsg.i &MSGNUM = 2797 &ERRORLEVEL=3 &MSGARG1=po_site }
               undo, return error.
            end.
 
            {us/px/pxrun.i &PROC  = 'validateGeneralizedCodes' &PROGRAM = 'gpcodxr.p'
                           &HANDLE=ph_gpcodxr
                           &PARAM="(input 'po_buyer',
                                   input '',
                                   input po_buyer,
                                   input {&SUPPRESS-MSG})"
                           &NOAPPERROR=True
                           &CATCHERROR=True}
            if return-value <> {&SUCCESS-RESULT} then do:
               {us/bbi/pxmsg.i &MSGNUM = 716 &ERRORLEVEL = 4
                        &MSGARG1 = po_nbr &MSGARG2 = po_buyer }
               undo, return error.
            end.
         end.
 
         /* Validate daybook set code */
 
         daybookDate = today.
         if po_eff_strt <> ? and po_eff_strt > today then
            daybookDate = po_eff_strt.
 
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
               next-prompt po_daybookset with frame po1.
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
               next-prompt po_daybookset with frame po1.
               undo, retry.
            end.
         end.
 
 
 
         /* IF NOT A CONSIGNED PO, THEN RESET COST POINT TO BLANK */
         /* (DEFAULTING OF CONSIGNMENT FIELDS OCCURS BEFORE USER  */
         /* HAS UPDATED THE CONSIGNMENT FLAG.)                    */
 
         if not po_consignment
            and (not can-find(first pod_det no-lock
                                 where pod_domain      = global_domain
                                 and   pod_nbr         = po_nbr
                                 and   pod_consignment = yes          ))
         then
            po_consign_cost_point = "".
 
         if c-application-mode <> "API" then do:
            /* CURRENCY VALIDATION */
            {us/gp/gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                      "(input  input po_curr,
                        output mc-error-number)"}
         end.
         else do:
            /* CURRENCY VALIDATION */
            {us/gp/gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                      "(input  po_curr,
                        output mc-error-number)"}
         end.
 
         if mc-error-number <> 0 then do:
            {us/bbi/pxmsg.i &MSGNUM = mc-error-number &ERRORLEVEL = 3}
            if c-application-mode <> "API" then do:
               next-prompt po_curr.
            end.
            else
               undo setb, return error.
         end.
 
         /*VALIDATE EFFECTIVE START AND END DATES*/
         if po_eff_strt = ? then do:
            /* START DATE CANNOT BE BLANK */
            {us/bbi/pxmsg.i &MSGNUM=482 &ERRORLEVEL=3}
 
            if c-application-mode <> "API" then do:
               next-prompt po_eff_strt with frame po1.
               undo, retry.
            end.
            else
               undo setb, return error.
         end.
         else do:
            if po_eff_to <> ? and po_eff_to < po_eff_strt then do:
               /* END DATE CANNOT BE BEFORE START DATE */
               {us/bbi/pxmsg.i &MSGNUM=123 &ERRORLEVEL=3}
 
               if c-application-mode <> "API" then do:
                  next-prompt po_eff_to with frame po1.
                  undo, retry.
               end.
               else
                  undo setb, return error.
            end.
         end.
 
         /*IF THE ORDER EXISTS ON AN MRP EFFECTIVE RECORD, CHECK*/
         /*WHETHER THE ORDER START DATE IS ON OR BEFORE THE MRP */
         /*EFFECTIVE DATE. DISPLAY AN ERROR MSG IF THE START    */
         /*DATE IS AFTER THE MRP EFFECTIVE DATE. THIS WILL PREV-*/
         /*ENT PROBLEMS FROM POSSIBLY OCCURRING DURING THE      */
         /*SCHEDULE UPDATE FROM MRP RUN IF A REQUIREMENT DATE   */
         /*SHOULD FALL BETWEEN A GAP IN THE ORDER START AND MRP */
         /*EFFECTIVE DATE.*/
 
         /*ERROR IF ORDER START DATE IS GREATER THAN THE EFFECTIVE*/
         /*DATE ON THE FIRST MRP% ALLOCATION RECORD WHICH THE ORDER/ITEM IS*/
         /*ON. NO ERROR IS GIVEN IF AN MRP% ALLOCATION RECORD IS NOT FOUND.*/
         poad_found = no.
         for each poad_det no-lock
            where poad_domain = global_domain
            and   poad_po_nbr = po_nbr
            and   poad_percent <> 0,
          each poa_mstr
            where poa_domain = global_domain
            and   poa_mstr.oid_poa_mstr =  poad_det.oid_poa_mstr
          no-lock:
             poad_found = yes.
             leave.
         end.
 
         if poad_found and po_eff_strt > poa_eff_date then do:
            /*START DATE IS LATER THAN ORDER/LINE MRP% DATE*/
            {us/bbi/pxmsg.i &MSGNUM=6735 &ERRORLEVEL=3}
            if c-application-mode <> "API" then do:
               next-prompt po_eff_strt with frame po1.
               undo, retry.
            end.
            else
               undo setb, return error.
         end.
 
         /*IF THE HDR START EFF DATE OR END EFF DATE HAVE BEEN MODIFIED */
         /*CHECK TO SEE THAT THE LINE EFF DATES ARE STILL WITHIN    */
         /*THE NEW HDR EFF DATE RANGE. IF THEY ARE NOT WITHIN THE NEW   */
         /*DATE RANGE, THEN DISPLAY A WARNING MESSAGE.          */
         if w-orig-eff-strt <> po_eff_strt
            and can-find (first pod_det
            where pod_domain = global_domain
            and   pod_nbr = po_nbr
            and   pod_start_eff[1] < po_eff_strt)
         then do:
            /* START DATE INVALID FOR ONE OR MORE LINES*/
            {us/bbi/pxmsg.i &MSGNUM=6725 &ERRORLEVEL=2}
         end.
 
         if w-orig-eff-to <> po_eff_to
            and can-find (first pod_det
            where pod_domain = global_domain
            and   pod_nbr = po_nbr
            and   pod_end_eff[1] > po_eff_to)
         then do:
            /* END DATE INVALID FOR ONE OR MORE LINES*/
            {us/bbi/pxmsg.i &MSGNUM=6726 &ERRORLEVEL=2}
         end.
 
         /* MAKE SURE USER UPDATES REVISION # WHEN APPLICABLE */
         if old_rev = po_rev
            and not new po_mstr
         then do:
            /* IS THIS AN ORDER REVISION CHANGE */
            {us/bbi/pxmsg.i &MSGNUM=6874 &ERRORLEVEL=1 &CONFIRM=rev_change}
 
            if rev_change then
               if c-application-mode <> "API" then do:
                  next-prompt po_rev with frame po1.
                  undo, retry.
               end.
               else
                  undo setb, return error.
         end.
 
         /* INITIALIZE SETTINGS */
         {us/gp/gprunp.i "gpglvpl" "p" "initialize"}
         /* SET PROJECT VERIFICATION TO NO */
         {us/gp/gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
 
         /*CHECK FOR VALID BILL-TO ADDRESS */
         if not can-find(ad_mstr where ad_domain = global_domain and
            ad_addr = po_bill)
         then do:
            /* Bill-To address does not exist */
            {us/bbi/pxmsg.i &MSGNUM=2577 &ERRORLEVEL=3}
 
            if c-application-mode <> "API" then do:
               next-prompt po_bill.
               undo, retry.
            end.
            else
               undo setb, return error.
         end.
 
         if not can-find(ad_mstr where ad_domain = global_domain and
            ad_addr = po_ship)
         then do:
            /* Not a valid choice */
            {us/bbi/pxmsg.i &MSGNUM = 13 &ERRORLEVEL = 3}
            if c-application-mode <> "API" then do:
               next-prompt po_ship.
               undo, retry.
            end.
            else
               undo setb, return error.
         end.
 
         po_sch_mthd = "nnn".
 
         if print_sch then substring(po_sch_mthd,1,1) = "y".
         if edi_sch   then substring(po_sch_mthd,2,1) = "y".
         if fax_sch   then substring(po_sch_mthd,3,1) = "y".
 
         /* RESET PO PRINT FLAG WHEN REVISION CHANGED */
         if not new_po
            and rev_change
         then do:
            {us/px/pxrun.i &PROC='getEdiPo' &PROGRAM='popoxr.p'
                     &PARAM="(input  po_inv_mthd,
                              output edi_po)"
                     &NOAPPERROR=TRUE
                     &CATCHERROR=TRUE}
 
            /* UPDATING PO_INV_MTHD TO STORE ITS VALUE WHEN A NEW */
            /* ORDER IS CREATED OR AN EXISTING ONE IS ACCESSED    */
            {us/px/pxrun.i &PROC='getInvoiceMethod' &PROGRAM='popoxr.p'
                     &PARAM="(input po_print,
                              input edi_po,
                              output po_inv_mthd)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
 
 
            {us/px/pxrun.i &PROC='setPOPrint' &PROGRAM='popoxr.p'
                     &PARAM="(input old_rev,
                              input po_rev,
                              input-output po_print)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
         end.   /* IF NOT new_po */
 
         {us/bbi/gprun.i ""gpsiver.p""
                  "(input  po_site,
                    input  ?,
                    output return_int)"}
 
         if return_int = 0 then do:
            /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
            {us/bbi/pxmsg.i &MSGNUM = 725 &ERRORLEVEL = 3}
 
            if c-application-mode <> "API" then do:
               next-prompt po_site.
               undo, retry.
            end.
            else
               undo setb, return error.
         end.  /* if return_int = 0 then do: */
 
         /* UPDATE THE PO LINES PO Site WITH THE CHANGED HEADER Site FOR */
         /* EXISTING PO                                                  */
         if l_posite <> po_site
            and not new_po
         then do:
            for each pod_det
               where pod_domain = global_domain
               and   pod_nbr    = po_nbr
            exclusive-lock:
               {us/px/pxrun.i &PROC='getPurchaseOrderLinePOSite'
                        &PROGRAM='popoxr1.p'
                        &PARAM="(input po_site,
                                 input pod_site,
                                 output pod_po_site)"
                        &NOAPPERROR=True &CATCHERROR=True}
            end. /* FOR EACH pod_det */
         end. /* IF l_posite <> po_site */
 
         /* ALLOW CHG TO EXRATE ON ADD AND MODIFY */
         /* AS LONG AS NO PRH_HIST EXISTS */
         if not can-find(first prh_hist where prh_domain =
            global_domain and  prh_nbr = po_nbr)
            and po_curr <> base_curr
         then
         setb_sub:
         do on error undo, retry:
 
            /* DO NOT RETRY WHEN PROCESSING API REQUEST */
            if retry and c-application-mode = "API" then
               undo setb, return error.
 
            /* DEFAULT EXRATE IF NEW PO FROM EXCHANGE RATE TABLE */
            if new_po then do:
 
               /* CREATE EXCHANGE RATE USAGE RECORDS */
               {us/gp/gprunp.i "mcpl" "p" "mc-get-ex-rate"
                         "(input  po_curr,
                           input  base_curr,
                           input  po_ex_ratetype,
                           input  po_ord_date,
                           output po_ex_rate,
                           output po_ex_rate2,
                           output mc-error-number)"}
 
               if mc-error-number <> 0 then do:
                  {us/bbi/pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  if c-application-mode <> "API" then
                     undo setb, retry.
                  else
                     undo setb,return error.
               end.
            end. /* if new_po then do: */
 
            if c-application-mode  = "API" and
               ttPurchaseOrder.exRate <> ? and
               ttPurchaseOrder.baseCurr <> base_curr
            then  do:
               /* API message base currency # <> MFG/PRO base currency.*/
               {us/bbi/pxmsg.i &MSGNUM = 5079 &ERRORLEVEL = 3
                        &MSGARG1 = ttPurchaseOrder.baseCurr}
               undo setb, return error.
            end.
 
            if c-application-mode = "API" and
               ttPurchaseOrder.exRate <> ?
            then
               po_fix_rate = yes.
 
            /* Copy the exchange rate details from the ttPurchaseOrder Temp*/
            /* Table into the Exchange Rate temp table for use in mcui.p  */
            if c-application-mode = "API" then do:
               {us/gp/gpttcp.i ttPurchaseOrder
                         ttTransExchangeRates}
               run setTransExchangeRates in ApiMethodHandle
                  (input table ttTransExchangeRates).
            end.
 
            {us/gp/gprunp.i "xxmcui" "p" "mc-ex-rate-input"
                      "(input po_curr,
                        input base_curr,
                        input po_ord_date,
                        input po_exru_seq,
                        input true,
                        input 12,
                        input-output po_ex_rate,
                        input-output po_ex_rate2,
                        input-output po_fix_rate)"}
 
         end.  /*setb_sub*/
 
         /* VALIDATE TAX CODE  */
         {us/gp/gptxcval.i &code=po_taxc &frame="b"}
 
         set_tax:
         do on error undo, retry:
            /* DO NOT RETRY WHEN PROCESSING API REQUEST */
            if retry and c-application-mode = "API" then
               undo set_tax, return error.
 
            if po_tax_env = "" then do:
 
               /* GET SHIP-TO TAX ZONE FROM PO_SHIP ADDRESS */
               for first ad_mstr
                  where ad_domain = global_domain
                  and   ad_addr = po_ship
               no-lock:
                  zone_to = ad_tax_zone.
               end.
 
               if not available(ad_mstr) then do:
                  /* SITE ADDRESS DOES NOT EXIST */
                  {us/bbi/pxmsg.i &MSGNUM = 864 &ERRORLEVEL = 2}
                  zone_to = "".
               end.
 
               /* GET VENDOR SHIP-FROM TAX ZONE FROM ADDRESS */
               for first vd_mstr
                  where vd_domain = global_domain
                    and vd_addr   = po_vend
               no-lock: end.
 
               if available(vd_mstr) then
                  zone_from = vd_tax_zone.
 
               /* SUGGEST A TAX ENVIRONMENT */
               {us/bbi/gprun.i ""txtxeget.p""
                        "(input  zone_to,
                          input  zone_from,
                          input  po_taxc,
                          output po_tax_env)"}
 
            end.   /* IF po_tax_env = "" */
 
            if c-application-mode <> "API" then
               update po_tax_usage po_tax_env with frame set_tax.
            else
               assign
                  {us/mf/mfaiset.i po_tax_usage  ttPurchaseOrder.taxUsage}
                  {us/mf/mfaiset.i po_tax_env    ttPurchaseOrder.taxEnv}.
 
             /* VALIDATE TAX USAGE */
            {us/px/pxrun.i  &PROC       = 'validateTaxUsage'
                      &PROGRAM    = 'txenvxr.p'
                      &PARAM      = "(input po_tax_usage)"
                      &NOAPPERROR = true
                      &CATCHERROR = true}
            if return-value <> {&SUCCESS-RESULT}
            then do:
               if c-application-mode <> "API"
               then do:
                  next-prompt po_tax_usage with frame set_tax no-validate.
                  undo set_tax, retry set_tax.
               end.
               else
                  undo, return error.
            end. /*if return-value <> {&SUCCESS-RESULT}*/
 
            /* VALIDATE TAX ENVIRONMENT */
            if po_tax_env = "" then do:
               /* Blank tax environment not allowed */
               {us/bbi/pxmsg.i &MSGNUM = 944 &ERRORLEVEL = 3}
 
               if c-application-mode <> "API" then do:
                  next-prompt po_tax_env with frame set_tax.
                  undo, retry set_tax.
               end.
               else
                  undo set_tax, return error.
            end.
 
            if not {gptxe.v po_tax_env ""no""} then do:
               /* Tax environment does not exist */
               {us/bbi/pxmsg.i &MSGNUM = 869 &ERRORLEVEL = 3}
 
               if c-application-mode <> "API" then do:
                  next-prompt po_tax_env with frame set_tax.
                  undo, retry set_tax.
               end.
               else
                  undo set_tax, return error.
            end.
 
            /*I19 TAX USAGE VALIDATION */     
            {us/bbi/gprun.i ""txusgval.p""
               "(input "{&TU_PO_MSTR}",
                 input oid_po_mstr,
            	 input po_tax_usage,
            	 output is-valid)"}
 
            if not is-valid then do:
               next-prompt po_tax_usage with frame set_tax.
               undo, retry set_tax. 
            end.
 
         end.  /* SET_TAX */
 
         if c-application-mode <> "API" then
            hide frame set_tax.
 
         if use-log-acctg and c-application-mode <> "API"
         then do:
 
            la-okay = no.
            /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
            {us/gp/gprunmo.i &module = "LA" &program = "lapomt.p"
                       &param  = """(input po_recid,
                                     input no,
                                     input-output la-okay)"""}
            if la-okay = no then do:
               view frame  po1 .
               undo , retry.
            end.
 
         end.
 
         /* IF IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT*/
         /* CREATE ROUTINE TO CREATE ie_mstr ied_det AND UPDATE ie_mstr */
         if impexp then do:
            imp-okay = no.
 
            if c-application-mode = "API" then do:
               for first ttImportExport
                  where  ttImportExport.apiExternalKey
                         = ttPurchaseOrder.apiExternalKey:
               end.
 
               if not available ttImportExport then do:
                  /* Required Data not Received From the API Interface. */
                  {us/bbi/pxmsg.i &MSGNUM = 4698 &ERRORLEVEL = 4
                           &MSGARG1 = ""IntrastatData""}
                  undo setb, return error.
               end.
 
               run setImportExportRow in ApiMethodHandle
                  (ttImportExport.apiSequence).
 
            end. /*if c-application-mode = "API" */
 
            {us/bbi/gprun.i ""iemstrcr.p""
                     "(input ""2"",
                       input po_nbr,
                       input recid(po_mstr),
                       input-output imp-okay )"}
 
            if imp-okay = no then do:
               if c-application-mode <> "API" then do:
                  view frame po1.
                  undo, retry.
               end.
               else
                  undo, return error.
            end.
         end.
 
         for first poc_ctrl where poc_domain = global_domain no-lock: end.
 
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
               /* DO NOT RETRY WHEN PROCESSING API REQUEST */
               if retry and c-application-mode = "API" then
                  undo ers-loop, return error.
 
               if c-application-mode <> "API" then
                  set po_ers_opt po_pr_lst_tp with frame po-ers.
               else
                  assign
                     {us/mf/mfaiset.i po_ers_opt  ttPurchaseOrder.ersOpt}
                     {us/mf/mfaiset.i po_pr_lst_tp  ttPurchaseOrder.prLstTp}.
 
               /* VALIDATE ERS OPTION */
               if not({gppoers.v po_ers_opt}) then do:
                  /*  Invalid ERS option */
                  {us/bbi/pxmsg.i &MSGNUM = 2303 &ERRORLEVEL = 3}
 
                  if c-application-mode <>  "API" 
                  then do:
                     next-prompt po_ers_opt.
                     undo, retry ers-loop.
                  end.  /* IF c-application-mode <> "API"*/
                  else
                     undo ers-loop,return error.
               end.
            end.   /* ERS-LOOP */
 
            if c-application-mode <> "API" then
               hide frame po-ers.
         end.  /* IF AVAIL POC_CTRL */
 
         if using_supplier_consignment
            and (po_consignment
                    or (not po_consignment
                           and can-find(first pod_det no-lock
                                           where pod_domain      = global_domain
                                           and   pod_nbr         = po_nbr
                                           and   pod_consignment = yes          )))
            and c-application-mode <> "API"
         then do:
            /* COST POINT MAY BE UPDATED PROVIDED NO CONSIGNED */
            /* RECEIPTS HAVE OCCURRED FOR THE PO.              */
            {us/px/pxrun.i &PROC='setAgingDays'
                     &PARAM="(input-output po_max_aging_days,
                              input-output po_consign_cost_point,
                              input (if new_po then yes
                                     else if not can-find(first cnsix_mstr
                                        where cnsix_domain = global_domain
                                        and cnsix_po_nbr = po_nbr) then yes
                                     else no))"}
 
            if keyfunction(lastkey) = "END-ERROR" then
               undo, retry.
 
            hide frame aging.
         end.
 
         if c-application-mode <> "API" then
            hide frame po1.
 
      end.   /* IF using_supplier_consignment */
 
      /* HEADER COMMENTS */
      assign
         global_lang = po_lang
         global_type = "".
 
      if pocmmts = yes then
      do on error undo mainloop, retry:
 
         if c-application-mode = "API" then do:
            {us/gp/gpttcp.i ttPurchaseOrderCmt
                      ttTransComment
                     "ttPurchaseOrderCmt.apiExternalKey =
                      ttPurchaseOrder.apiExternalKey"}
 
            run setTransComment in ApiMethodHandle
               (input table ttTransComment).
 
         end.
 
         assign
            cmtindx = po_cmtindx
            global_ref = po_vend.
 
         {us/bbi/gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
 
         po_mstr.po_cmtindx = cmtindx.
 
         if c-application-mode <> "API" then
            view frame po.
      end.
   end. /* end of block_2  */
 
   impexp_order = po_nbr.
 
   release po_mstr.
 
   {us/bbi/gprun.i ""rsrsoup.p"" "(input po_recid)"}
 
   /* DO DETAIL MAINTENANCE */
   {us/bbi/gprun.i ""rspomtb.p""
            "(input po_recid,
              input using_supplier_consignment)"}
 
   /* IMPORT EXPORT FLAG IS SET TO YES CALL THE IMPORT EXPORT DETAIL */
   /* LINE MAINTENANCE PROGRAM FOR USER TO UPDATE ied_det            */
   if not batchrun and impexp then do:
      impexp_edit = no.
 
      if c-application-mode <> "API" then do:
         /* View/Edit import/export data */
         {us/bbi/pxmsg.i &MSGNUM = 271 &ERRORLEVEL = 1 &CONFIRM=impexp_edit}
      end.
 
      if impexp_edit then do:
         upd_okay = no.
 
         if c-application-mode = "API" then do:
            for first ttImportExport
               where  ttImportExport.apiExternalKey
                      = ttPurchaseOrder.apiExternalKey:
 
               run setImportExportRow in ApiMethodHandle
                  (ttImportExport.apiSequence).
            end.
         end.
 
         {us/bbi/gprun.i ""iedmta.p""
                  "(input ""2"",
                    input impexp_order,
                    input-output upd_okay)"}
 
      end.   /* IF impexp_edit */
   end.   /* IF NOT batchrun */
 
   if c-application-mode = "API" then
      leave mainloop.
end.
 
/* RETURN SUCCESS STATUS TO API CALLER */
if c-application-mode = "API" then
   return {&SUCCESS-RESULT}.
 
/* Reset the validation mode to AR in case the procedure library */
/* is still in memory when another user runs a program requiring */
/* AR validation.                                                */
run setvalidMode in hDaybooksetValidation
               (input  false).
 
delete procedure hDaybooksetValidation no-error.
 
delete procedure hBlockedTransactionlibrary no-error.
