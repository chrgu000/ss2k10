/* popomtd.p - PURCHASE ORDER MAINTENANCE SINGLE LINE ITEMS                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14.4.15.1.2 $                                                     */
/*                                                                            */
/* This program allows updating of purchase order line details like location, */
/* revision, due date and so on in single line entry mode.                    */
/*F0PN*/
/* REVISION: 1.0     DATE:04/29/86    BY:PML                                  */
/* REVISION: 1.0     DATE:10/29/86    BY:EMB ECO: *39*                        */
/* REVISION: 2.0     DATE:11/19/86    BY:PML ECO: *A3*                        */
/* REVISION: 2.0     DATE:03/12/87    BY:EMB ECO: *A41*                       */
/* REVISION: 2.1     DATE:06/17/87    BY:WUG ECO: *A69*                       */
/* REVISION: 2.1     DATE:06/17/87    BY:WUG ECO: *A70*                       */
/* REVISION: 2.1     DATE:08/12/87    BY:PML ECO: *A83*                       */
/* REVISION: 2.1     DATE:09/09/87    BY:PML ECO: *A92*                       */
/* REVISION: 2.1     DATE:09/09/87    BY:WUG ECO: *A94*                       */
/* REVISION: 2.1     DATE:10/02/87    BY:PML ECO: *A95*                       */
/* REVISION: 4.0     DATE:03/10/88    BY:FLM ECO: *A108*                      */
/* REVISION: 4.0     DATE:12/27/87    BY:PML ECO: *A119*                      */
/* REVISION: 4.0     DATE:03/14/88    BY:FLM ECO: *A184*                      */
/* REVISION: 4.0     DATE:04/18/88    BY:FLM ECO: *A189*                      */
/* REVISION: 4.0     DATE:06/15/88    BY:FLM ECO: *A268*                      */
/* REVISION: 4.0     DATE:09/02/88    BY:FLM ECO: *A419*                      */
/* REVISION: 4.0     DATE:09/20/88    BY:FLM ECO: *A445*                      */
/* REVISION: 4.0     DATE:09/26/88    BY:RL  ECO: *C0028                      */
/* REVISION: 4.0     DATE:03/24/89    BY:FLM ECO: *A685*                      */
/* REVISION: 5.0     DATE:04/06/89    BY:MLB ECO: *B088*                      */
/* REVISION: 5.0     DATE:12/21/89    BY:FTB ECO: *B466*                      */
/* REVISION: 6.0     DATE:05/15/90    BY:WUG ECO: *D002*                      */
/* REVISION: 6.0     DATE:08/14/90    BY:SVG ECO: *D058*                      */
/* REVISION: 6.0     DATE:08/31/90    BY:RAM ECO: *D030*                      */
/* REVISION: 6.0     DATE:10/19/90    BY:RAM ECO: *D124*                      */
/* REVISION: 6.0     DATE:12/18/90    BY:RAM ECO: *D275*                      */
/* REVISION: 6.0     DATE:03/08/91    BY:RAM ECO: *D410*                      */
/* REVISION: 6.0     DATE:04/08/91    BY:RAM ECO: *D502*                      */
/* REVISION: 6.0     DATE:04/11/91    BY:RAM ECO: *D518*                      */
/* REVISION: 6.0     DATE:05/07/91    BY:RAM ECO: *D621*                      */
/* REVISION: 6.0     DATE:05/09/91    BY:RAM ECO: *D634*                      */
/* REVISION: 6.0     DATE:08/15/91    BY:PMA ECO: *D829*                      */
/* REVISION: 7.0     DATE:09/12/91    BY:RAM ECO: *F033*                      */
/* REVISION: 6.0     DATE:09/24/91    BY:RAM ECO: *D872*                      */
/* REVISION: 6.0     DATE:11/11/91    BY:RAM ECO: *D921*                      */
/* REVISION: 6.0     DATE:11/15/91    BY:RAM ECO: *D952*                      */
/* REVISION: 7.0     DATE:03/03/92    BY:PMA ECO: *F085*                      */
/* REVISION: 7.0     DATE:06/18/92    BY:JJS ECO: *F672*                      */
/* REVISION: 7.3     DATE:08/19/92    BY:MPP ECO: *G012*                      */
/* REVISION: 7.3     DATE:10/01/92    BY:tjs ECO: *G117*                      */
/* REVISION: 7.3     DATE:10/12/92    BY:tjs ECO: *G164*                      */
/* REVISION: 7.3     DATE:10/26/92    BY:afs ECO: *G232*                      */
/* REVISION: 7.3     DATE:12/31/92    BY:afs ECO: *G489*                      */
/* REVISION: 7.3     DATE:01/20/93    BY:bcm ECO: *G417*                      */
/* REVISION: 7.3     DATE:02/17/93    BY:tjs ECO: *G684*                      */
/* REVISION: 7.3     DATE:04/19/93    BY:tjs ECO: *G964*                      */
/* REVISION: 7.3     DATE:05/27/93    BY:kgs ECO: *GB37*                      */
/* REVISION: 7.4     DATE:06/09/93    BY:jjs ECO: *H006*                      */
/* REVISION: 7.4     DATE:07/02/93    BY:dpm ECO: *H015*                      */
/* REVISION: 7.4     DATE:09/29/93    BY:wug ECO: *H144*                      */
/* REVISION: 7.4     DATE:09/07/93    BY:tjs ECO: *H082*                      */
/* REVISION: 7.4     DATE:10/23/93    BY:cdt ECO: *H184*                      */
/* REVISION: 7.4     DATE:11/14/93    BY:afs ECO: *H221*                      */
/* REVISION: 7.4     DATE:03/22/94    BY:bcm ECO: *H299*                      */
/* REVISION: 7.4     DATE:05/21/94    BY:qzl ECO: *H374*                      */
/* REVISION: 7.4     DATE:07/05/94    BY:qzl ECO: *H417*                      */
/* REVISION: 7.4     DATE:11/21/94    BY:afs ECO: *H605*                      */
/* REVISION: 8.5     DATE:12/01/94    BY:taf ECO: *J038*                      */
/* REVISION: 8.5     DATE:02/14/95    BY:ktn ECO: *J041*                      */
/* REVISION: 8.5     DATE:06/06/95    BY:sxb ECO: *J04D*                      */
/* REVISION: 7.4     DATE:02/13/95    BY:dxk ECO: *F0J0*                      */
/* REVISION: 7.4     DATE:02/23/95    BY:jzw ECO: *H0BM*                      */
/* REVISION: 7.4     DATE:03/06/95    BY:wjk ECO: *H0BT*                      */
/* REVISION: 7.4     DATE:04/02/95    BY:dxk ECO: *F0PY*                      */
/* REVISION: 7.4     DATE:08/25/95    BY:ais ECO: *H0FQ*                      */
/* REVISION: 7.4     DATE:09/19/95    BY:ais ECO: *G0X6*                      */
/* REVISION: 7.4     DATE:10/20/95    BY:ais ECO: *G19L*                      */
/* REVISION: 8.5     DATE:10/03/95    BY:taf ECO: *J053*                      */
/* REVISION: 7.4     BY:ais                         DATE:01/04/96 ECO: *G1J1* */
/* REVISION: 8.5     BY:Robert Wachowicz            DATE:03/19/96 ECO: *J0CV* */
/* REVISION: 8.5     BY:ais                         DATE:03/25/96 ECO: *G1QK* */
/* REVISION: 8.5     BY:rpw                         DATE:04/23/96 ECO: *J0K2* */
/* REVISION: 8.5     BY:rxm                         DATE:05/20/96 ECO: *G1NZ* */
/* REVISION: 8.5     BY:ajw                         DATE:06/07/96 ECO: *J0S6* */
/* REVISION: 8.5     BY:Aruna P. Patil              DATE:08/21/96 ECO: *G2CV* */
/* REVISION: 8.5     BY:Suresh Nayak                DATE:11/19/96 ECO: *H0PG* */
/* REVISION: 8.5     BY:Robin McCarthy              DATE:01/09/97 ECO: *J1B1* */
/* REVISION: 8.5     BY:Molly Balan                 DATE:05/22/97 ECO: *J1RZ* */
/* REVISION: 8.5     BY:B. Gates                    DATE:02/11/97 ECO: *J1YW* */
/* REVISION: 8.5     BY:Aruna Patil                 DATE:08/29/97 ECO: *J204* */
/* REVISION: 8.5     BY:Jim Josey                   DATE:01/07/98 ECO: *J29D* */
/* REVISION: 8.6E    BY:A. Rahane                   DATE:02/23/98 ECO: *L007* */
/* REVISION: 8.6E    BY:Alfred Tan                  DATE:05/20/98 ECO: *K1Q4* */
/* REVISION: 8.6E    BY:Charles Yen                 DATE:06/09/98 ECO: *L020* */
/* REVISION: 8.6E    BY:Steve Nugent                DATE:08/17/98 ECO: *L062* */
/* REVISION: 9.1     BY:Robin McCarthy              DATE:08/02/99 ECO: *N014* */
/* REVISION: 9.1     BY:Reetu Kapoor                DATE:09/09/99 ECO: *J39R* */
/* REVISION: 9.1     BY:Abhijeet Thakur             DATE:12/27/99 ECO: *J3NB* */
/* REVISION: 9.1     BY:Thelma Stronge              DATE:03/06/00 ECO: *N05Q* */
/* REVISION: 9.1     BY:Annasaheb Rahane            DATE:03/24/00 ECO: *N08T* */
/* REVISION: 9.1     BY:Kedar Deherkar              DATE:04/26/00 ECO: *L0WT* */
/* REVISION: 9.1     BY:MAYSE LAI                   DATE:06/30/00 ECO: *N009* */
/* Revision: 1.14.4.13 BY:Anup Pereira              DATE:07/10/00 ECO: *N059* */
/* Revision: 1.14.4.14 BY:Mark Brown                DATE:08/17/00 ECO: *N0LJ* */
/* Revision: 1.14.4.15 BY: Mudit Mehta              DATE:09/22/00 ECO: *N0W9* */
/* Revision: 1.14.4.15.1.1    BY: Rajesh Kini       DATE:10/02/01 ECO: *N13B* */
/* $Revision: 1.14.4.15.1.2 $  BY:Adeline Kinehan    DATE:10/19/01 ECO: *N13P* */
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/*                     by *ADM*  ShiyuHe    DATE: 09/22/04  -Check pod_qty_ord */ 
/*                     by *sdm*  Carflat    DATE: 06/28/07  -Check pod_pur_cost */

/* **************************** Definitions ********************************* */

/* STANDARD INCLUDE FILES */
{mfdeclre.i} /* INCLUDE FILE SHARED VARIABLES */
{cxcustom.i "POPOMTD.P"}
{gplabel.i}  /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}  /* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */

/* NEW SHARED VARIABLES */
define new shared variable subtype  as character format "x(12)" no-undo.
define new shared variable workord  like wo_nbr.
define new shared variable worklot  like wo_lot.
define new shared variable routeop  like wr_op.
define new shared variable workpart like wo_part.
define new shared variable workproj like wo_project.
/*ADM*/ define new shared variable poqty  like pod_qty_ord.
/*ADM*/ define shared variable new_pod        like mfc_logical.

/* SHARED VARIABLES */
define shared variable rndmthd like rnd_rnd_mthd.
define shared variable desc1   like pt_desc1.
define shared variable desc2   like pt_desc2.
define shared variable line    like sod_line.
define shared variable po_recno as recid.
define shared variable vd_recno as recid.
define shared variable ext_cost like pod_pur_cost.
define shared variable line_opened    as logical.
define shared variable using_grs      like mfc_logical no-undo.
define shared variable old_pod_status like pod_status.
define shared variable old_type like pod_type.
define shared variable pod_recno as recid.
define shared variable podcmmts       like mfc_logical.
define shared variable st_qty like pod_qty_ord.
define shared variable st_um like pod_um.
define shared variable clines as integer.
define shared variable blanket as logical.
define shared variable sngl_ln like poc_ln_fmt.
define shared variable old_pod_site like pod_site.
define shared variable continue as logical.

/* SHARED FRAME(S) */
define shared frame d.

/* LOCAL VARIABLES */
define variable err-flag        as integer.
define variable mfgr            like vp_mfgr.
define variable mfgr_part       like vp_mfgr_part.
define variable old_um_conv     like pod_um_conv.
define variable old_pur_cost    like pod_pur_cost.
define variable old_vpart       like pod_vpart.
define variable old_db          like si_db.
define variable yn              like mfc_logical initial no.
define variable dummy_um        like pt_um no-undo.
define variable pod-project     like pod_project no-undo.
define variable prm-project     like mfc_logical no-undo.
define variable pod-type        like pod_type    no-undo.
define variable prm-enabled     like mfc_logical initial yes no-undo.
define variable old_fix_pr      like pod_fix_pr  no-undo.
define variable old_ers_opt     like pod_ers_opt no-undo.

 /*COMMON API CONSTANTS AND VARIABLES*/
{mfaimfg.i}

 /*PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "api" PREFIX*/
{popoit01.i}

if c-application-mode = "API" then do on error undo, return:

    /*GET HANDLE OF API CONTROLLER*/
   {gprun.i ""gpaigh.p"" "(output ApiMethodHandle,
                           output ApiProgramName,
                           output ApiMethodName,
                           output apiContextString)"}


    /*GET LOCAL PURCHASE ORDER DET TEMP-TABLE*/
   create ttPurchaseOrderDet.
   run getPurchaseOrderDetRecord in ApiMethodHandle
              (buffer ttPurchaseOrderDet).

end.  /* If c-application-mode = "API" */

/* TAX ENVIRONMENT FORM */
form
   pod_tax_usage colon 25
   pod_tax_env   colon 25  space(2)
   pod_taxc      colon 25
   pod_taxable   colon 25
   pod_tax_in    colon 25
   with frame set_tax row 13 overlay
   centered side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame set_tax:handle).

/* Defines frames c and d */
{mfpomtb.i}
{&POPOMTD-P-TAG1}

/* ****************************** Main Block ******************************** */

/* CHECK IF PRM IS INSTALLED */
prm-enabled = {pxfunct.i &FUNCTION='isPrmEnabled' &PROGRAM='pjprmxr.p'}.

/* GENERAL SETUP */
/* GET P.O. CONTROL FILE */
for first poc_ctrl
   fields(poc_insp_loc poc_ers_proc)
   no-lock:
end.

/* GET P.O. HEADER RECORD */
for first po_mstr
   where recid(po_mstr) = po_recno:
end.

for first vd_mstr
   fields(vd_addr)
   where recid(vd_mstr) = vd_recno
   no-lock:
end.

/* GET P.O. LINE RECORD */
for first pod_det
   where recid(pod_det) = pod_recno:
end.

/* READS SITE MASTER */
{pxrun.i &PROC='processRead' &PROGRAM='icsixr.p'
         &PARAM="(input  pod_site,
                  buffer si_mstr,
                  input  false,
                  input  false)"
         &NOERROR=true
         &CATCHERROR=true}

/* UPDATES PO LINE LOT RECEIPT FLAG */
if pod_lot_rcpt = no
then do:
   {pxrun.i &PROC='getSingleLotReceipt' &PROGRAM='popoxr1.p'
            &PARAM="(input pod_part,
                     output pod_lot_rcpt)"
            &NOAPPERROR=true
            &CATCHERROR=true}
end. /* IF pod_lot_rcpt = no */

/* SET THE FLAG TO NO */
continue = no.

/* CALCULATED PO LINE EXTENDED COST */
{pxrun.i &PROC='getPOLineExtendedCost' &PROGRAM='popoxr1.p'
         &PARAM="(input pod_nbr,
                  input pod_line,
                  input rndmthd,
                  output ext_cost)"
         &NOAPPERROR=true
         &CATCHERROR=true}

 if c-application-mode <> "API" then
   display
      pod_lot_rcpt
      pod_loc
      pod_rev
      pod_vpart
      desc1
      desc2
      pod_due_date
      pod_per_date
      pod_need
      pod_so_job
      pod_fix_pr
      pod_crt_int
      pod_status
      pod_acct
      pod_sub
      pod_cc
      pod_project
      pod_type
      pod_taxable
      pod_taxc
      pod_insp_rqd
      pod_um_conv
      pod_cst_up
      st_qty
      st_um
      podcmmts
      ext_cost when (ext_cost <> ?)
      with frame d.

old_um_conv = pod_um_conv.

/* GETS MANUFACTURER AND MANUFACTURER ITEM FOR A SUPPLIER ITEM */
{pxrun.i &PROC='getManufacturerItemData' &PROGRAM='ppsuxr.p'
         &PARAM="(input pod_part,
                  input pod_vpart,
                  input po_vend,
                  output mfgr_part,
                  output mfgr,
                  output dummy_um)"
         &NOAPPERROR=true
         &CATCHERROR=true}

if c-application-mode <> "API" then
   display
     mfgr
     mfgr_part
      with frame d.

assign
   pod-project = pod_project
   pod-type    = pod_type
   global_site = pod_site
   global_addr = po_vend
   old_fix_pr  = pod_fix_pr.

   setd:
   do on error undo, retry:
    /* DO NOT RETRY WHEN PROCESSING API REQUEST */
      if retry and c-application-mode = "API" then
         undo setd, return error.
      if c-application-mode <> "API" then
      do:
         set
            pod_qty_chg when (blanket)
            pod_lot_rcpt when (pod_qty_rcvd = 0 and
            can-find(pt_mstr where pt_part = pod_part
            and pt_lot_ser <> "s"))
            pod_loc
            pod_rev
            pod_status when (not pod_sched)
            pod_vpart
            desc1 when (not can-find(pt_mstr where pt_part = pod_part))
            pod_due_date
            pod_per_date
            pod_need
            pod_so_job
            pod_fix_pr
            pod_acct
            pod_sub
            pod_cc
            pod_project
            pod_type when (not blanket)
            pod_taxable
            pod_taxc
            pod_insp_rqd
            podcmmts
            pod_um_conv when (new pod_det)
            pod_cst_up
            with frame d no-validate
            editing:
               if frame-field = "pod_vpart" then do:
                  {mfnp05.i vp_mstr vp_partvend
                      "pod_part = vp_part and po_vend = vp_vend"
                       vp_vend_part "input pod_vpart"}

                  if recno <> ? and po_curr = vp_curr then do:
                     assign
                        pod_vpart = vp_vend_part
                        mfgr      = vp_mfgr
                        mfgr_part = vp_mfgr_part.
                     display
                        pod_vpart
                        mfgr
                        mfgr_part
                       with frame d.
                   end.
               end.
               else do:
                  ststatus = stline[3].
                  status input ststatus.
                  readkey.
                  apply lastkey.
               end.
            end. /* EDITING */
    end.  /* If c-application-mode <> "API" */
    else do: /* c-application-mode = "API" */
      if blanket then
         assign {mfaiset.i pod_qty_chg  ttPurchaseOrderDet.qtyChg}.
      if pod_qty_rcvd = 0 and  can-find(pt_mstr where pt_part = pod_part
               and pt_lot_ser <> "s")then
         assign {mfaiset.i pod_lot_rcpt  ttPurchaseOrderDet.lotRcpt}.

      if not pod_sched then
         assign
            {mfaiset.i pod_status  ttPurchaseOrderDet.stat}
            {mfaiset.i pod_vpart  ttPurchaseOrderDet.vpart}
            .

      if not can-find(pt_mstr where pt_part = pod_part) then
         assign {mfaiset.i desc1  ttPurchaseOrderDet.dsc}.

      assign
         {mfaiset.i pod_due_date  ttPurchaseOrderDet.dueDate}
         {mfaiset.i pod_per_date  ttPurchaseOrderDet.perDate}
         {mfaiset.i pod_need  ttPurchaseOrderDet.need}
         {mfaiset.i pod_so_job  ttPurchaseOrderDet.soJob}
         {mfaiset.i pod_loc  ttPurchaseOrderDet.loc}
         {mfaiset.i pod_rev  ttPurchaseOrderDet.rev}
         {mfaiset.i pod_fix_pr  ttPurchaseOrderDet.fixPr}
         {mfaiset.i pod_acct  ttPurchaseOrderDet.acct}
         {mfaiset.i pod_cc  ttPurchaseOrderDet.cc}
         {mfaiset.i pod_project  ttPurchaseOrderDet.project}
         .
      if not blanket then
         assign {mfaiset.i pod_type  ttPurchaseOrderDet.type}.
      assign {mfaiset.i pod_taxable  ttPurchaseOrderDet.taxable}.
      if {txnew.i} then
         assign {mfaiset.i pod_taxc  ttPurchaseOrderDet.taxc}.

      assign
         {mfaiset.i pod_insp_rqd  ttPurchaseOrderDet.inspRqd}
         {mfaiset.i pod_um_conv  ttPurchaseOrderDet.umConv}
         .
      podcmmts = yes.
      {mfaiset.i pod_cst_up ttPurchaseOrderDet.cstUp}.

      if pod_status <> "" and pod_status <> "c"
      and pod_status <> "x" then
      do:
         {pxmsg.i
            &MSGNUM = 4911
            &ERRORLEVEL = 4
            &MSGARG1 = pod_nbr
            &MSGARG2 = pod_line
         }
         undo setd, return.
      end.

      if not({gpcode.v pod_type}) then
      do:
         {pxmsg.i
            &MSGNUM = 716
            &ERRORLEVEL = 4
            &MSGARG1 = pod_nbr
            &MSGARG2 = pod_line
            &MSGARG3 = 'pod_type'
             &MSGARG4 = pod_type
         }
         undo setd, return.
      end.

      if not ({gpcode.v pod_rev}) then
      do:
         {pxmsg.i
            &MSGNUM = 716
            &ERRORLEVEL = 4
            &MSGARG1 = pod_nbr
            &MSGARG2 = pod_line
            &MSGARG3 = 'pod_rev'
            &MSGARG4 = pod_rev
         }
         undo setd, return.
      end.

   end.  /* c-application-mode = "API" */

   /* VALIDATES PO LINE REVISION */
   {pxrun.i &PROC='validatePOLineRevision' &PROGRAM='popoxr1.p'
            &PARAM="(input pod_rev)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_rev with frame d no-validate.
         undo setd, retry setd.
      end.
      else
         undo setd, return error.

   end.

   /* VALIDATES PO LINE STATUS */
   {pxrun.i &PROC='validatePOLineStatus' &PROGRAM='popoxr1.p'
            &PARAM="(input pod_status)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_status with frame d no-validate.
         undo setd, retry setd.
      end.
      else
         undo setd, return error.
   end.

   /* CHECKS FOR FIELD-LEVEL ACCESS ON PO LINE FIXED PRICE FLAG */
   if pod_fix_pr <> old_fix_pr then do:
      {pxrun.i &PROC='validatePOLineFixedPrice' &PROGRAM='popoxr1.p'
               &PARAM="(input pod_fix_pr)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then
         do:
            next-prompt pod_fix_pr with frame d no-validate.
            undo setd, retry setd.
         end.
         else
            undo setd, return error.
      end.
   end. /* IF pod_fix_pr <> old_fix_pr */

   /* VALIDATES PO LINE TYPE: non Blanket Orders*/
   /* Type is fixed "B" for Blanket Orders */
   if pod_type <> "B" then do:
      {pxrun.i &PROC='validatePOLineType' &PROGRAM='popoxr1.p'
               &PARAM="(input pod_type)"
               &NOAPPERROR=true
               &CATCHERROR=true}
   end.

   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_type with frame d no-validate.
         undo setd, retry setd.
   end.
   else
      undo setd, return error.
   end.

   /* VALIDATES PO LINE UOM CONVERSION */
   {pxrun.i &PROC='validatePOLineUMConv' &PROGRAM='popoxr1.p'
            &PARAM="(input pod_um_conv)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_um_conv with frame d no-validate.
         undo setd, retry setd.
      end.
      else
         undo setd, return error.
   end.

   {pxrun.i &PROC='validateShipperExists' &PROGRAM='popoxr.p'
            &PARAM="(input pod_status,
                     input pod_nbr)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if return-value = {&APP-ERROR-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_status with frame d no-validate.
         undo setd, retry setd.
      end.
      else
        undo setd, return error.
   end.

   /* ENSURE USER CANNOT UPDATE/DELETE POD_PROJECT VALUE WHERE */
   /* PO LINE IS ALREADY LINKED TO A PRM PROJECT LINE          */
   {pxrun.i &PROC='validatePRMProject' &PROGRAM='pjprmxr.p'
            &PARAM="(input pod-project,
                     input input pod_project,
                     input pod_pjs_line)"
            &NOAPPERROR=true
            &CATCHERROR=true}
   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_project with frame d.
         undo setd, retry setd.
      end.
      else
         undo setd, return error.
   end.

   {pxrun.i &PROC='validatePRMType' &PROGRAM='pjprmxr.p'
            &PARAM="(input pod_type,
                     input pod-type,
                     input pod_pjs_line)"
            &NOAPPERROR=true
            &CATCHERROR=true}
   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_type with frame d.
         undo setd, retry setd.
      end.
      else
        undo setd, return error.
   end.

   prm-project = can-find(prj_mstr where prj_nbr = input pod_project).

   if (prm-enabled
      and prm-project
      and sngl_ln
      and pod_det.pod_qty_rcvd = 0
      and pod_det.pod_type <> "S"
      and (not blanket))
      or (prm-enabled
      and sngl_ln
      and (not blanket)
      and pod_det.pod_pjs_line <> 0) then do:
      /* UPDATE PO PROJECT LINE */
      {gprunmo.i
         &program = ""pjpomtd.p""
         &module  = "PRM"
         &param   = """(buffer pod_det)"""}
   end. /*IF PRM-ENABLED AND NOT BLANKET */

   /* VALIDATES PO LINE TAX CLASS */
   {pxrun.i &PROC='validateTaxClass' &PROGRAM='txenvxr.p'
            &PARAM="(input pod_taxc)"
            &NOAPPERROR=TRUE
            &CATCHERROR=TRUE}

   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_taxc with frame d no-validate.
         undo setd, retry setd.
      end.
      else
         undo setd, return error.
   end.

   /* GET TAX MANAGEMENT DATA */
   if pod_taxable then do:
      {pxrun.i &PROC='validateSiteChanged' &PROGRAM='popoxr1.p'
               &PARAM="(input pod_site,
                        input old_pod_site)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then
         pod_tax_env = "".

      taxloop:
      do on error undo, retry:
         if retry and c-application-mode = "API" then
             undo taxloop, return error.
         if pod_tax_env = "" then do:
            /* GETS AND UPDATES PO LINE TAX ENVIRONMENT */
            {pxrun.i &PROC='getTaxEnvironment' &PROGRAM='popoxr.p'
                     &PARAM="(input  vd_addr,
                              input  pod_site,
                              input  '',
                              input po_taxc,
                              output pod_tax_env)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
         end. /* IF pod_tax_env = "" */
         if c-application-mode <> "API" then
            update
               pod_tax_usage
               pod_tax_env
               pod_taxc
               pod_taxable
               pod_tax_in
               with frame set_tax no-validate.
             else
                assign
                   {mfaiset.i pod_tax_usage  ttPurchaseOrderDet.taxUsage}
                   {mfaiset.i pod_tax_env  ttPurchaseOrderDet.taxEnv}
                   {mfaiset.i pod_taxc  ttPurchaseOrderDet.taxc}
                   {mfaiset.i pod_taxable  ttPurchaseOrderDet.taxable}
                   {mfaiset.i pod_tax_in  ttPurchaseOrderDet.taxIn}
                   .

         /* VALIDATES PO LINE TAX USAGE */
         {pxrun.i &PROC='validatePOLineTaxUsage' &PROGRAM='popoxr1.p'
                  &PARAM="(input pod_tax_usage)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
            do:
               next-prompt pod_tax_usage with frame set_tax no-validate.
               undo taxloop, retry taxloop.
            end.  /* If c-application-mode <> "API" */
            else /* c-application-mode = "API" */
               undo taxloop, return error.
         end.

         /* VALIDATES PO LINE TAX ENVIRONMENT */
         {pxrun.i &PROC='validateTaxEnvironment' &PROGRAM='txenvxr.p'
                  &PARAM="(input pod_tax_env)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
            do:
               next-prompt pod_tax_env with frame set_tax no-validate.
               undo taxloop, retry taxloop.
            end.  /* If c-application-mode <> "API" */
            else /* c-application-mode = "API" */
               undo taxloop, return error.
         end.
         if c-application-mode <> "API" then
            hide frame set_tax.
         {&POPOMTD-P-TAG2}
      end. /* TAXLOOP */
   end.

   if pod_per_date = ? then
      pod_per_date = pod_due_date.

   if pod_need = ? then
      pod_need = pod_due_date.

   if can-find (first vp_mstr where vp_mstr.vp_part >= ""
      and   vp_mstr.vp_vend >= ""
      and   vp_mstr.vp_vend_part >= "") then do:
      /* GETS MANUFACTURER AND MANUFACTURER ITEM FOR A SUPPLIER ITEM */
      {pxrun.i &PROC='getManufacturerItemData' &PROGRAM='ppsuxr.p'
               &PARAM="(input pod_part,
                        input pod_vpart,
                        input po_vend,
                        output mfgr_part,
                        output mfgr,
                        output dummy_um)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      /* READS SUPPLIER ITEM MASTER */
      {pxrun.i &PROC='processRead' &PROGRAM='ppsuxr.p'
               &PARAM="(input pod_part,
                        input po_vend,
                        input pod_vpart,
                        buffer vp_mstr,
               {&NO_LOCK_FLAG},
               {&NO_WAIT_FLAG})"
               &NOAPPERROR=true
               &CATCHERROR=true}
      if return-value = {&RECORD-NOT-FOUND} and
         pod_vpart <> "" then do:
         {pxmsg.i
            &MSGNUM=238
            &ERRORLEVEL={&INFORMATION-RESULT}}
         if c-application-mode <> "API" then
            hide message.
      end.
if batchrun = no then do:
/*sdm*********Don't allow change supplier price*******
      if return-value = {&SUCCESS-RESULT} then do:
         if (new pod_det or
         pod_pur_cost <> old_pur_cost or
         pod_vpart    <> old_vpart) then do:
            if vp_q_price  <> pod_pur_cost and
            vp_um        = pod_um and
            po_curr      = vp_curr and
            pod_qty_ord >= vp_q_qty then do:
               yn = no.

               /* MESSAGE #334 - UPDATE SUPPLIER QUOTE COST WITH PURCHASE */
               /*                COST?                                    */
           /*admf1 *admf1*/    {pxmsg.i
                  &MSGNUM=334
                  &ERRORLEVEL={&INFORMATION-RESULT}
                  &CONFIRM=yn}

               if yn = yes then do:

                  /* UPDATE PO LINE UNIT COST WITH SUPPLIER ITEM QUOTE COST */
                  {pxrun.i &PROC='setQuoteCost' &PROGRAM='ppsuxr.p'
                           &PARAM="(input pod_vpart,
                                    input pod_part,
                                    input po_vend,
                                    input pod_pur_cost)"
                           &NOAPPERROR=true
                           &CATCHERROR=true}
               end.
               
            end.
         end.
      end.
*sdm***********Don't allow change supplier price********/
end. /*batchrun = no*/
      if c-application-mode <> "API" then
         display
           mfgr
           mfgr_part
           with frame d.
   end.

   /* VALIDATES CHANGE IN PO LINE STATUS */
   {pxrun.i &PROC='validatePOLineStatusChanged' &PROGRAM='popoxr1.p'
            &PARAM="(input pod_status,
                     input old_pod_status)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if ({pxfunct.i &FUNCTION='isOpenLineOnClosedPO' &PROGRAM='popoxr1.p'
                  &PARAM="input po_stat,
                          input pod_status"}) then do:
      yn = no.

      /* MESSAGE #339 - PO AND/OR PO LINE CLOSED OR CANCELLED - REOPEN? */
      {pxmsg.i
         &MSGNUM=339
         &ERRORLEVEL={&INFORMATION-RESULT}
         &CONFIRM=yn}

      if yn then do: /*allowStatusChange */
         /* RE-OPENS A CLOSED PURCHASE ORDER */
         {pxrun.i &PROC='reOpenPurchaseOrder' &PROGRAM='popoxr.p'
                  &PARAM="(input pod_nbr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         line_opened = true.

         /* RE-OPENS A CLOSED REQUISITON LINE */
         {pxrun.i &PROC='reOpenRequisition' &PROGRAM='rqgrsxr.p'
                  &PARAM="(input pod_req_nbr,
                           input pod_req_line)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
      end. /* IF yn */
      else if yn = no then do:
         pod_status = old_pod_status.
         if c-application-mode <> "API" then
         do:
            display pod_status with frame d.
            next-prompt pod_status with frame d no-validate.
            undo setd, retry setd.
         end.  /* If c-application-mode <> "API" */
         else /* c-application-mode = "API" */
            undo setd, return error.
      end. /* IF yn = NO */
   end.

   /* CLOSES A REQUISITION LINE FOR MANUALLY CLOSED PO LINE */
   {pxrun.i &PROC='closeRequisition' &PROGRAM='rqgrsxr.p'
            &PARAM="(input pod_status,
                     input pod_req_nbr,
                     input pod_req_line,
                     input no)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   /* VALIDATES SUBCONTRACT TYPE PO LINE */
   {pxrun.i &PROC='validateSubcontractItem' &PROGRAM='popoxr1.p'
            &PARAM="(input pod_qty_ord,
                     input pod_part,
                     input pod_type)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_type with frame d no-validate.
         undo setd, retry setd.
      end.  /* If c-application-mode <> "API" */
      else /* c-application-mode = "API" */
         undo setd, return error.
   end.

   /* VALIDATES BLANKET ORDER RELEASE QUANTITY */
   {pxrun.i &PROC='validateBlanketRelQty' &PROGRAM='popoxr1.p'
            &PARAM="(input blanket,
                     buffer pod_det)"
            &NOAPPERROR=True
            &CATCHERROR=True}

   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_qty_chg with frame d no-validate.
         undo setd, retry setd.
      end.  /* If c-application-mode <> "API" */
      else /* c-application-mode = "API" */
         undo setd, return error.
   end.

   /* VALIDATES BLANKET TYPE PO LINE */
   {pxrun.i &PROC='validateForBlanketType' &PROGRAM='popoxr1.p'
            &PARAM="(input blanket,
                     input pod_type)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_type with frame d no-validate.
         undo setd, retry setd.
      end.
      else /* c-application-mode = "API" */
         undo setd, return error.
   end.

   if not using_grs then do:

      /* VALIDATES TYPE FOR PO LINE WITH REQUISITION */
      {pxrun.i &PROC='validatePOLineTypeForRequisition' &PROGRAM='popoxr1.p'
               &PARAM="(input Blanket,
                        input pod_req_nbr,
                        input pod_part,
                        input pod_type)"
               &NOAPPERROR=TRUE
               &CATCHERROR=TRUE}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then
         do:
            next-prompt pod_type with frame d no-validate.
            undo setd, retry setd.
         end.
         else /* c-application-mode = "API" */
            undo setd, return error.
      end.
   end.

   /* VALIDATES PO LINE ACCOUNT/SUB-ACCT/COST CENTER AND PROJECT */
   {pxrun.i &PROC='validateFullAccount' &PROGRAM='glacxr.p'
            &PARAM="(input pod_acct,
                     input  pod_sub,
                     input  pod_cc,
                     input pod_project)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if return-value <> {&SUCCESS-RESULT} then do:
      if c-application-mode <> "API" then
      do:
         next-prompt pod_acct with frame d no-validate.
         undo setd, retry setd.
      end.
      else /* c-application-mode = "API" */
         undo setd, return error.
   end.

   /* UPDATES PO LINE ITEM DESCRIPTION */
   {pxrun.i &PROC='setPOItemDescription' &PROGRAM='popoxr1.p'
            &PARAM="(input pod_part,
                     input-output pod_desc,
                     input desc1)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if pod_um_conv <> old_um_conv then do:

      /* GETS STOCK QUANTITY AFTER APPLY CONVERSION FACTOR ON UNIT COST */
      st_qty = pod_qty_ord.

      {pxrun.i &PROC='convertFromPoToInventoryUm' &PROGRAM='popoxr1.p'
               &PARAM="(input-output st_qty,
                         input pod_um_conv)"
               &NOAPPERROR=true
               &CATCHERROR=true}

   end.
   if c-application-mode <> "API" then
      display st_qty with frame d.

   /* UPDATES PO LINE LOCATION BASED INSPECTION REQUIRED FLAG */
   {pxrun.i &PROC='updatePOLineLocationForInspection' &PROGRAM='popoxr1.p'
            &PARAM="(input pod_insp_rqd,
                     input poc_insp_loc,
                     input-output pod_loc)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   {pxrun.i &PROC='setSubcontractType' &PROGRAM='popoxr1.p'
            &PARAM="(buffer pod_det)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if pod_type = "S" and
      (pod_req_nbr = "" or
       not can-find(first req_det where req_nbr = pod_req_nbr))
       then do:

       old_db = global_db.
       if si_db <> global_db then
          {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }

       assign
          worklot  = pod_wo_lot
          routeop  = pod_op
          workpart = pod_part
          subtype  = pod__qad16
          workproj = pod_project.

      if subtype = ? then
         subtype = "".
         
/*ADM   if new_pod then*/
/*ADM*/       poqty  = pod_qty_ord.  /*else poqty = 0.*/

      /* PO MAINTENANCE VALIDATE REMOTE DB WORK ORDERS */
/*ADM      {gprun.i ""popomtd1.p""}*/
/*ADM*/      {gprun.i ""popomtd1xx.p""}

      assign
         pod_wo_lot = worklot
         pod__qad16 = subtype
         pod_op     = routeop.

      if old_db <> global_db then
         {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
   end.

   /* VALIDATE POD_SITE'S PT_MSTR WHEN PO_LINE HAD BEEN MEMO */
   if (pod_type = "") and (old_type = "M") then do:

      /* CHECKS FOR ITEM ON NON CENTRAL DATABASE */
      {pxrun.i &PROC='validateItemOnRemoteDB' &PROGRAM='popoxr1.p'
               &PARAM="(input pod_part,
                        input pod_site)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         assign
            pod_type = old_type
            err-flag = 0.
         if c-application-mode <> "API" then do:
            display pod_type with frame d.
            next-prompt pod_type with frame d no-validate.
            undo setd, retry setd.
         end.
         else /* c-application-mode = "API" */
           undo setd, return error.
      end.
   end.
end. /* Setd */


if c-application-mode <> "API" then
   pause 0.

/* ERS PROCESSING BLOCK */
if poc_ers_proc = yes then do:

   /* ERS POP UP BOX */
   form
      pod_ers_opt colon 22
      space(2)
      skip
      pod_pr_lst_tp colon 22
      space(2)
      with frame ers side-labels
      centered row 13 overlay.

   /* UPDATE ERS FIELDS */
   looper:
   do on error undo looper, retry looper with frame ers:
      if retry and c-application-mode = "API" then
         undo looper, return error.

      old_ers_opt = pod_ers_opt.

      if c-application-mode <> "API" then
      do:
         display
            pod_ers_opt
            pod_pr_lst_tp
            with frame ers.

         set
            pod_ers_opt
            pod_pr_lst_tp
            with frame ers no-validate.
      end.
      else do:                    /* c-application-mode = "API" */
         assign
            {mfaiset.i pod_ers_opt ttPurchaseOrderDet.ersOpt}
            {mfaiset.i pod_pr_lst_tp ttPurchaseOrderDet.prLstTp}
                .
      end.
      if pod_ers_opt <> old_ers_opt then do:
         /* CHECKS FOR FIELD-LEVEL ACCESS ON PO LINE ERS OPTION */
            {pxrun.i &PROC='validatePOLineERSOptSecurity' &PROGRAM='popoxr1.p'
                     &PARAM="(input pod_ers_opt)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT} then do:
               if c-application-mode <> "API" then
               do:
                  next-prompt pod_ers_opt with frame ers no-validate.
                  undo looper, retry looper.
               end.  /* If c-application-mode <> "API" */
               else /* c-application-mode = "API" */
                  undo looper, return error.
            end.
         end.

      /* VALIDATES PO LINE ERS PRICE LIST OPTION */
         {pxrun.i &PROC='validatePOLineERSPriceListOpt' &PROGRAM='popoxr1.p'
                  &PARAM="(input pod_pr_lst_tp)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
            do:
               next-prompt pod_pr_lst_tp with frame ers no-validate.
               undo looper, retry looper.
            end.  /* If c-application-mode <> "API" */
            else /* c-application-mode = "API" */
               undo looper, return error.
         end.

      /* VALIDATES PO LINE ERS OPTION */
         {pxrun.i &PROC='validatePOLineERSOption' &PROGRAM='popoxr1.p'
                  &PARAM="(input pod_ers_opt)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT} then do:
            if c-application-mode <> "API" then
            do:
               next-prompt pod_ers_opt with frame ers no-validate.
               undo looper, retry looper.
            end.  /* If c-application-mode <> "API" */
            else /* c-application-mode = "API" */
               undo looper, return error.
         end.

         if pod_ers_opt entered then do:
         /* VALIDATE ERS OPT BY FINDING HIGH ERS MASTER MATCH */
            {pxrun.i &PROC='validateSupplierSiteItemERSOption' &PROGRAM='popoxr1.p'
                     &PARAM="(input po_vend,
                              input pod_site,
                              input pod_part,
                              input-output pod_ers_opt)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT} then do:
               if c-application-mode <> "API" then
               do:
                  display pod_ers_opt with frame ers.
                  next-prompt pod_ers_opt with frame ers no-validate.
                  undo looper, retry looper.
               end.
               else /* c-application-mode = "API" */
                  undo looper, return error.
            end.
         end. /*IF POD_ERS_OPT ENTERED*/
   end. /*LOOPER*/
   if c-application-mode <> "API" then
      hide frame ers.

   hide frame ers.
end. /*IF POC_ERS_PROC = YES*/

/* Set the flag to yes for successful completion */
continue = yes.