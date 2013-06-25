/* popomtr1.p  - PURCHASE ORDER MAINTENANCE SUBROUTINE - ASSIGN GRS INFO.     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.26 $                                                  */
/* This is a subprogram to handle the assignment of default information for a */
/* new PO Line when a Global requisition has been referenced.                 */
/*                                                                            */
/* REVISION: 8.5      LAST MODIFIED: 02/13/97     BY: B. Gates *J1Q2*         */
/* REVISION  8.5      LAST MODIFIED: 10/27/97     BY: *J243* Patrick Rowan    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98     BY: *L00Y* Jeff Wootton     */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98     BY: *L040* Charles Yen      */
/* REVISION: 8.6E     LAST MODIFIED: 01/12/99     BY: *K1YT* Seema Varma      */
/* REVISION: 8.6E     LAST MODIFIED: 02/08/99     BY: *J39L* Steve Nugent     */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99     BY: *N014* PATTI GAULTNEY   */
/* REVISION: 9.1      LAST MODIFIED: 05/28/99     BY: *L0DW* Ranjit Jain      */
/* REVISION: 9.1      LAST MODIFIED: 09/09/99     BY: *J39R* Reetu Kapoor     */
/* REVISION: 9.1      LAST MODIFIED: 01/28/00     BY: *K253* Sandeep Rao      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16       BY: Bill Pedersen         DATE: 04/25/00  ECO: *N059* */
/* Revision: 1.17       BY: Mark Brown            DATE: 08/17/00  ECO: *N0LJ* */
/* Revision: 1.19       BY: Niranjan R.           DATE: 07/12/01  ECO: *P00L* */
/* Revision: 1.22       BY: Nikita Joshi          DATE: 08/14/01  ECO: *M1H2* */
/* Revision: 1.23       BY: Jean Miller           DATE: 03/04/02  ECO: *N1BS* */
/* Revision: 1.25       BY: K Paneesh             DATE: 07/11/02  ECO: *N1NN* */
/* $Revision: 1.26 $     BY: Laurene Sheridan      DATE: 10/17/02  ECO: *N13P* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
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
/* Creation: eB21SP3 Chui Last Modified: 20080624 By: Davild Xu *ss-20080624.1*/
/*---Add Begin by davild 20080624.1*/
/*
xxpopom1t.p（popomt.p）
	xxrpomt.p(pomt.p)
		xxpopom1a.p(popomta.p)
			xxpopom1r.p(popomtr.p)
				xxpopom1r1.p(popomtr1.p)				
			xxpopomtea.p(popomtea.p)

a)首先判断5.2.1.24是否启动CER检验，若没有启动，处理逻辑与修改前一样；
b)在5.2.1.24启动后，若1.4.3中零件不需要CER，处理逻辑与修改前一样；
c)若在CER检查到生效日期小于采购单到期日期（pod_due_date）的非"不合格"CER，用户可以进行采购订单维护，否则提示用不能维护采购订单；
d)对于"M"类型采购，不需要进行CER检验，处理逻辑与修改前一样；
e)将查询到的CER代码，记录到采购订单明细资料中pod__chr08，若是限量采购类型，将已经订购数量记录在pod__dec01和xxcer_ord_qty中，若采购订单数量有修改，也必须修改pod__dec01内容(必须注意，当退换货时，订购数量 - 退货数量 <= 限购数量)。
f)将采购订单单头需求日期强制置空，以保证用户手工输入采购申请单时申请单需求日期和到期日期自动转为采购订单需求日期和到期日期；{****Davild0623****取申请单号的需求日期和到期日期}
g)采购订单明细中的税用途(pod_tax_usage)和纳税类型(pod_taxc)默认取值采购订单单头对应值(po_taxc/po_tax_usage)，用户可以修改；{****Davild0623****强制与表头一样}
h)若零件净重(pt_net_wt)小于零，则提示用户，该零件不能采购。
*/
/*---Add End   by davild 20080624.1*/

/* SS - 110223.1  By: Roger Xiao */ /*just xxpopom1a.p: pod_taxable = po_taxable ;xxpopom1r1.p : cancel p_pod_disc_pct */


{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}
{rqconst.i} /*REQUISITION CONSTANTS*/

/* PARAMETERS */
define input parameter p_first_call  as logical.
define input parameter p_frame_row   as integer.
define input parameter p_po_curr     like po_curr.
define input parameter p_po_vend     like po_vend.
define input parameter p_pod_site    like pod_site.
define input parameter p_po_taxable  like po_taxable.
define input parameter p_po_ex_rate  like po_ex_rate.
define input parameter p_po_ex_rate2 like po_ex_rate2.
define input parameter p_po_taxc     like po_taxc.
define input parameter p_po_type     like po_type.
define output parameter p_pod_req_nbr like pod_req_nbr no-undo.
define output parameter p_pod_req_line like pod_req_line no-undo
   column-label "Ln".
define output parameter p_pod_part like pod_part no-undo.
define output parameter p_pod_pur_cost like pod_pur_cost no-undo.
define output parameter p_pod_disc_pct like pod_disc_pct no-undo.
define output parameter p_pod_qty_ord like pod_qty_ord no-undo.
define output parameter p_pod_need like pod_need no-undo.
define output parameter p_pod_due_date like pod_due_date no-undo.
define output parameter p_pod_um like pod_um no-undo.
define output parameter p_pod_um_conv like pod_um_conv no-undo.
define output parameter p_pod_project like pod_project no-undo.
define output parameter p_pod_acct like pod_acct no-undo.
define output parameter p_pod_sub like pod_sub no-undo.
define output parameter p_pod_cc like pod_cc no-undo.
define output parameter p_pod_request like pod_request no-undo.
define output parameter p_pod_approve like pod_approve no-undo.
define output parameter p_pod_apr_code like pod_apr_code no-undo.
define output parameter p_pod_desc like pod_desc no-undo.
define output parameter p_pod_taxc like pod_taxc no-undo.
define output parameter p_pod_taxable like pod_taxable no-undo.
define output parameter p_pod_vpart like pod_vpart no-undo.
define output parameter p_pod_cmtindx like pod_cmtindx no-undo.
define output parameter p_pod_lot_rcpt like pod_lot_rcpt no-undo.
define output parameter p_pod_rev like pod_rev no-undo.
define output parameter p_pod_loc like pod_loc no-undo.
define output parameter p_pod_insp_rqd like pod_insp_rqd no-undo.
define output parameter p_mfgr as character no-undo.
define output parameter p_mfgr_part as character no-undo.
define output parameter p_desc1 as character no-undo.
define output parameter p_desc2 as character no-undo.
define output parameter p_continue     like mfc_logical no-undo.
define output parameter p_commentIndex as   integer     no-undo.
define output parameter p_pod_type     like pod_type    no-undo.

/* SHARED VARIABLES */
define new shared variable rqm_recno  as recid.
define new shared variable sw_rqd_nbr like rqd_nbr no-undo.

/* LOCAL VARIABLES */
define variable dummy_acct        as character     no-undo.
define variable dummy_sub         as character     no-undo.
define variable l_dummy_type      as character     no-undo.
define variable dummy_cc          as character     no-undo.
define variable dummyCharacter    as character     no-undo.
define variable p_dummy           as decimal       no-undo.
define variable exchg_rate        as decimal       no-undo.
define variable exchg_rate2       as decimal       no-undo.
define variable taxableItem       as logical       no-undo.
define variable qty_open          like rqd_req_qty no-undo.
define variable requm             like rqd_um      no-undo.
define variable exch-error-number like msg_nbr     no-undo.
define variable mc-error-number   like msg_nbr     no-undo.
define variable l_error           like mfc_logical no-undo.

/*COMMON API CONSTANTS AND VARIABLES*/
{mfaimfg.i}

/*PURCHASE ORDER API TEMP-TABLE, NAMED USING THE "api" PREFIX*/
{popoit01.i}

if c-application-mode = "API"
   then do on error undo, return:

   /*GET HANDLE OF API CONTROLLER*/
   {gprun.i ""gpaigh.p"" "(output ApiMethodHandle,
                           output ApiProgramName,
                           output ApiMethodName,
                           output apiContextString)"}

   create ttPurchaseOrderDet.
   run getPurchaseOrderDetRecord in ApiMethodHandle
      (buffer ttPurchaseOrderDet).

end.  /* If c-application-mode = "API" */

form
   p_pod_site
   /*V8!space(.5) */
   p_pod_req_nbr
   /*V8!space(.5) */
   p_pod_req_line
   /*V8!space(.5) */
   p_pod_part
   /*V8!space(.5) */
   p_pod_qty_ord
   /*V8!space(.5) */
   p_pod_um
   /*V8!space(.5) */
   p_pod_pur_cost   label "Unit Cost" format "->>>>>>>>9.99<<<"
   /*V8!space(.5) */
   p_pod_disc_pct
with frame grs-c overlay row p_frame_row width 80 no-attr-space.

/*============================================================================*/
/* ****************************  Main Block  ******************************** */
/*============================================================================*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame grs-c:handle).

/*POSITION THE OVERLAY FRAME BELOW FRAME D UNTIL ROW 12.*/
/*WHEN GREATER THAN ROW 12 POSITION THE FRAME ABOVE FRAME D.*/
if p_frame_row < 12
then
   p_frame_row = p_frame_row + 4.
else
   p_frame_row = p_frame_row - 2.
   if c-application-mode <> "API" then
      display
      p_pod_site
      0 @ p_pod_qty_ord
      0 @ p_pod_pur_cost
      0 @ p_pod_disc_pct
      with frame grs-c.

do on error undo, retry on endkey undo, leave:
 /* DO NOT RETRY WHEN PROCESSING API REQUEST */
   if retry and c-application-mode = "API" then
      undo, return.
   p_continue = no.

   if c-application-mode <> "API"
   then do:
      set p_pod_req_nbr p_pod_req_line with frame grs-c
      editing:

         if frame-field = "p_pod_req_nbr"
         then do:
            {mfnp05.i
               rqm_mstr
               rqm_open
               "rqm_open and rqm_rtdto_purch and rqm_status = """""
               rqm_nbr
               "input p_pod_req_nbr"}

            if recno <> ?
            then do:
               for first rqd_det where
                  rqd_nbr = rqm_nbr no-lock:
               end.

               /* DETERMINE REQUISITION LINE OPEN QUANTITY */
               {pxrun.i &PROC='getRequisitionLineOpenQuantity' &PROGRAM='rqgrsxr1.p'
                        &PARAM="(input rqd_nbr,
                                 input rqd_line,
                                 input rqd_site,
                                 output qty_open,
                                 output requm)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               display
                  p_pod_site
                  rqm_nbr @ p_pod_req_nbr
                  rqd_line @ p_pod_req_line
                  rqd_part @ p_pod_part
                  qty_open @ p_pod_qty_ord
                  rqd_um @ p_pod_um
                  rqd_pur_cost  @ p_pod_pur_cost
                  rqd_disc_pct @ p_pod_disc_pct
               with frame grs-c.
            end.  /* IF RECNO <> ? */
         end.  /* IF FRAME-FIELD = "p_pod_req_nbr" */
         else do:
            sw_rqd_nbr = input frame grs-c p_pod_req_nbr.
            {gpbrparm.i &browse=rqlu014.p &parm=c-brparm1 &val=sw_rqd_nbr}
            {mfnp05.i
               rqd_det
               rqd_nbr
               "rqd_nbr = input frame grs-c p_pod_req_nbr
                 and rqd_open and rqd_status = """""
               rqd_line
               "input frame grs-c p_pod_req_line"}

            if recno <> ?
            then do:
               /* DETERMINE REQUISITION LINE OPEN QUANTITY */
               {pxrun.i &PROC='getRequisitionLineOpenQuantity' &PROGRAM='rqgrsxr1.p'
                        &PARAM="(input rqd_nbr,
                                 input rqd_line,
                                 input rqd_site,
                                 output qty_open,
                                output requm)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               display
                  p_pod_site
                  rqd_nbr @ p_pod_req_nbr
                  rqd_line @ p_pod_req_line
                  rqd_part @ p_pod_part
                  qty_open @ p_pod_qty_ord
                  rqd_um @ p_pod_um
                  rqd_pur_cost  @ p_pod_pur_cost
                  rqd_disc_pct @ p_pod_disc_pct
               with frame grs-c.
            end.  /* OF RECNO <> ? */
         end. /* ELSE DO: */
      end. /* editing */
   end. /* c-application-mode <> "API" */
   else if c-application-mode = "API"
   then do:
      assign {mfaiset.i p_pod_req_nbr ttPurchaseOrderDet.reqNbr}
             {mfaiset.i p_pod_req_line ttPurchaseOrderDet.reqLine}.
   end. /*end if c-application-mode = API */

   l_error = no.

   if p_pod_req_nbr > ''
   then do:
      /*READ THE REQUISITION HEADER RECORD*/

      {pxrun.i &PROC='processRead' &PROGRAM='rqgrsxr.p'
               &PARAM="(input p_pod_req_nbr, buffer rqm_mstr, input no, input no)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         l_error = yes.

         /*REQUISITION DOES NOT EXIST*/
         {pxmsg.i &MSGNUM=193 &ERRORLEVEL={&APP-ERROR-RESULT}}

         if c-application-mode <> "API"
         then do:
            next-prompt p_pod_req_nbr with frame grs-c.
            undo, retry.
         end. /* c-application-mode <> "API" */
         else /* c-application-mode = "API" */
           undo, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT} */

      /*ENSURE REQUISITION STATUS IS OPEN*/
      {pxrun.i &PROC='validateReqIsOpen' &PROGRAM='rqgrsxr.p'
               &PARAM="(input rqm_nbr)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         l_error = yes.

         if c-application-mode <> "API"
         then do:
            next-prompt p_pod_req_nbr with frame grs-c.
            undo,retry.
         end. /* c-application-mode <> "API" */
         else /* c-application-mode = "API" */
            undo, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT}*/

      /*ENSURE REQUISITION ROUTED TO PURCHASING*/
      {pxrun.i &PROC='validateReqRoutedToPurchasing' &PROGRAM='rqgrsxr.p'
               &PARAM="(input rqm_nbr)"
               &NOAPPERROR=true
               &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT}
      then do:
         l_error = yes.
         if c-application-mode <> "API"
         then do:
            next-prompt p_pod_req_nbr with frame grs-c.
            undo, retry.
         end. /* c-application-mode <> "API" */
         else /* c-application-mode = "API" */
            undo, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT} */

      /*ENSURE EXRATE FOR REQ TO PO CURRENCY*/
      {gprun.i 'rqexrt.p'
               "(input rqm_curr,
                 input p_po_curr,
                 input rqm_ex_ratetype,
                 output exchg_rate,
                 output exchg_rate2,
                 output exch-error-number)"}

      if exch-error-number <> 0
      then do:
         l_error = yes.
         /*NO EXCHANGE RATE FOR REQUISITION TO PO CURRENCY*/
         {pxmsg.i &MSGNUM=2120 &ERRORLEVEL={&APP-ERROR-RESULT}}
         if c-application-mode <> "API"
         then do:
            next-prompt p_pod_req_nbr with frame grs-c.
            undo, retry.
         end. /* c-application-mode <> "API" */
         else /* c-application-mode = "API" */
            undo, return error.
      end.  /* if exch-error-number <> 0 */

      /*ENSURE REQ LINE ITEM EXISTS*/
      {pxrun.i &PROC='processRead'  &PROGRAM='rqgrsxr1.p'
               &PARAM="(input p_pod_req_nbr,
                        input p_pod_req_line,
                        buffer rqd_det,
                        input no,
                        input no)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         l_error = yes.

         /*LINE ITEM DOES NOT EXIST*/
         {pxmsg.i &MSGNUM=45 &ERRORLEVEL={&APP-ERROR-RESULT}}
         if c-application-mode <> "API"
         then do:
            next-prompt p_pod_req_line with frame grs-c.
            undo, retry.
         end. /* c-application-mode <> "API" */
         else /* c-application-mode = "API" */
            undo, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT} */

      /*ENSURE REQ LINE IS OPEN*/
      {pxrun.i  &PROC='validateReqLineIsOpen'  &PROGRAM='rqgrsxr1.p'
                &PARAM="(input rqd_nbr, input rqd_line)"
                &NOAPPERROR=true
                &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT}
      then do:
         l_error = yes.
         if c-application-mode <> "API"
         then do:
            next-prompt p_pod_req_line with frame grs-c.
            undo, retry.
         end. /* c-application-mode <> "API" */
         else /* c-application-mode = "API" */
            undo, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT} */

      /*ENSURE REQ LINE IS APPROVED*/
      {pxrun.i  &PROC='validateReqLineIsApproved' &PROGRAM='rqgrsxr1.p'
                &PARAM="(input rqd_nbr, input rqd_line)"
                &NOAPPERROR=true
                &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT}
      then do:
         l_error = yes.
         if c-application-mode <> "API"
         then do:
            next-prompt p_pod_req_line with frame grs-c.
            undo, retry.
         end. /* c-application-mode <> "API" */
         else /* c-application-mode = "API" */
            undo, return error.
      end.  /* if return-value <> {&SUCCESS-RESULT} */

      /*ENSURE AN OPEN QTY ON REQ LINE*/
      {pxrun.i &PROC='getRequisitionLineOpenQuantity' &PROGRAM='rqgrsxr1.p'
               &PARAM="(input rqd_nbr,
                        input rqd_line,
                        input rqd_site,
                        output qty_open,
                        output requm)"
               &NOAPPERROR=true
               &CATCHERROR=true}
      if qty_open <= 0
      then do:
         l_error = yes.

         /*NO REMAINING QUANTITY OPEN ON REQUISITION LINE*/
         {pxmsg.i &MSGNUM=2089 &ERRORLEVEL={&APP-ERROR-RESULT}}
         if c-application-mode <> "API"
         then do:
            next-prompt p_pod_req_line with frame grs-c.
            undo, retry.
         end.
         else /* c-application-mode = "API" */
            undo, return error.
      end.

      /*WARN IF REQ LINE SUPPLIER AND PO SUPPLIER ARE DIFFERENT*/
      {pxrun.i  &PROC='validateRequisitionLineSupplier' &PROGRAM='rqgrsxr1.p'
                &PARAM="(input rqd_vend, input p_po_vend)"
                &NOAPPERROR=true
                &CATCHERROR=true}

      /*WARN IF REQ SITE AND PO DETAIL SITE ARE DIFFERENT*/
      {pxrun.i  &PROC='validateReqLineSite'  &PROGRAM='rqgrsxr1.p'
                 &PARAM="(input rqd_site, input p_pod_site)"
                &NOAPPERROR=true
                &CATCHERROR=true}

      /*RETURN VARIOUS PARAMETER VALUES*/
      assign
         p_pod_part     = rqd_part
         p_pod_qty_ord  = qty_open
         p_pod_need     = rqd_need_date
         /*p_pod_due_date = rqd_need_date*/	/*---Remark by davild 20080624.1*/
         p_pod_due_date = rqd_due_date		/*---Add by davild 20080624.1*/
         p_pod_um       = rqd_um
         p_pod_acct     = rqd_acct
         p_pod_sub      = rqm_sub
         p_pod_cc       = rqm_cc
         p_pod_um_conv  = 1
         p_pod_project  = rqd_project
/* SS - 110223.1 - B 
         p_pod_disc_pct = rqd_disc_pct
   SS - 110223.1 - E */
         p_pod_lot_rcpt = rqd_lot_rcpt
         p_pod_rev      = rqd_rev
         p_commentIndex = rqd_cmtindx
         p_pod_type     = (if p_po_type = "B"
                           then
                              "B"
                           else
                              rqd_type).

      if rqd_type = "M"
      then
         p_pod_desc = rqd_desc.
      /* Re-default purchases account because vendor or site has changed */
      if (rqd_vend <> "" and rqd_vend <> p_po_vend)
         or  rqd_site <> p_pod_site
      then do:
         {pxrun.i &PROC='redefaultPurchaseAccount' &PROGRAM='popoxr1.p'
            &PARAM="(input ""PO_PUR_ACCT"",
              input p_pod_site,
              input p_po_vend,
              input p_pod_part,
              output p_pod_acct,
              output dummy_sub,
              output dummy_cc)"
            &NOAPPERROR=true
            &CATCHERROR=true}
      end.  /* if rqd_vend <> p-po-vend or rqd_site <> p_pod_site */

      {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input rqm_curr,
        input p_po_curr,
        input exchg_rate,
        input exchg_rate2,
        input rqd_pur_cost,
        input false, /* DO NOT ROUND */
        output p_pod_pur_cost,
        output mc-error-number)"}

   end. /*if p_pod_req_nbr > ''*/
   else do:
      /*NO Requisition Entered*/
      p_pod_req_line = 0.
   end.

   /* GET SUPPLIER ITEM INFORMATION */
   {pxrun.i &PROC='getManufacturerItemDataOfLastQuote' &PROGRAM='ppsuxr.p'
            &PARAM="(input p_pod_part,
                     input p_po_vend,
                     input-output p_pod_vpart,
                     output p_mfgr,
                     output p_mfgr_part)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   /* USE SUPPLIER PART FROM REQ LINE IF SUPPLIER MATCHES */
   if  available rqd_det
      and p_po_vend = rqd_vend
   then
      p_pod_vpart = rqd_vpart.

   /*GET TAX INDICATORS*/
   assign
      p_pod_taxc     = p_po_taxc
      p_pod_taxable  = p_po_taxable.

   /*GET ITEM DESCRIPTION*/
   assign
      p_desc1 = ''
      p_desc2 = ''.

   if p_pod_desc <> ""
   then
      assign
         p_desc1 = p_pod_desc
         p_desc2 = "".

   /* Get Defaults from Item*/
   if can-find(first pt_mstr where pt_part = p_pod_part)
   then do:
      {pxrun.i  &PROC='getPOItemDefaults'  &PROGRAM='popoxr1.p'
                &PARAM="(input p_pod_part,
                         input p_pod_site,
                         output p_desc1,
                         output p_desc2,
                         output dummyCharacter,
                         output p_pod_rev,
                         output p_pod_loc,
                         output p_pod_insp_rqd,
                         output taxableItem,
                         output p_pod_taxc)"
                &NOAPPERROR=true
                &CATCHERROR=true}

      p_po_taxable = (p_po_taxable and taxableItem).
   end.

   p_continue = yes.
end. /* DO ON ERROR UNDO, RETRY */

if c-application-mode <> "API" then
   hide frame grs-c no-pause.

if right-trim(p_pod_req_nbr) > '' and not l_error
then do:
   /*REQUISITION FOR THIS LINE IS...*/
   {pxmsg.i &MSGNUM=1655 &ERRORLEVEL={&INFORMATION-RESULT}
            &MSGARG1="p_pod_req_nbr + ' ' + string(p_pod_req_line)"}
end.
else
   p_pod_req_nbr = ''.
