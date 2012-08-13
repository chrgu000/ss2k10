/* popomtr.p  - PURCHASE ORDER MAINTENANCE SUBROUTINE - GET REQ. NUMBER       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.4.12 $                                                               */
/*V8:ConvertMode=NoConvert                                                    */
/*                                                                            */
/* This is a subprogram to handle the assignment of default information for a */
/* new PO Line when a requisition has been referenced.                        */
/*                                                                            */
/* REVISION: 8.5     LAST MODIFIED: 02/13/97      BY: B. Gates *J1YW*         */
/* REVISION: 8.6E    LAST MODIFIED: 05/09/98      BY: *L00Y* Jeff Wootton     */
/* REVISION: 8.6E    LAST MODIFIED: 05/28/99      BY: *L0DW* Ranjit Jain      */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99      BY: *N014* PATTI GAULTNEY   */
/* REVISION: 9.1     LAST MODIFIED: 12/21/99      BY: *J3N4* Kedar Deherkar   */
/* Revision: 1.5.4.4   BY: Bill Pedersen         DATE: 04/25/00  ECO: *N059*  */
/* Revision: 1.5.4.5   BY: Julie Milligan        DATE: 08/07/00  ECO: *N0J1*  */
/* Revision: 1.5.4.6   BY: myb                   DATE: 08/13/00  ECO: *N0KQ*  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.4.9   BY: Nikita Joshi          DATE: 08/14/01  ECO: *M1H2*  */
/* Revision: 1.5.4.11  BY: K Paneesh             DATE: 07/11/02  ECO: *N1NN*  */
/* $Revision: 1.5.4.12 $        BY: Rajaneesh S.          DATE: 08/29/02  ECO: *M1BY*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*                                                                            */
/*!GET REQUISITION NUMBER/LINE                                                */
/*============================================================================*/
/* ****************************  Definitions  ******************************* */
/*============================================================================*/

{mfdeclre.i}
{pxmaint.i}

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
define output parameter p_pod_req_line like pod_req_line no-undo.
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
define output parameter p_continue        like mfc_logical no-undo.
define output parameter p_ReqCommentIndex as   integer     no-undo.
define output parameter p_pod_type        like pod_type    no-undo.

define shared variable due_date like pod_due_date.
define variable old_db as character no-undo.
define variable siteDB as character no-undo.
define variable err-flag as integer no-undo.
define variable using_grs like mfc_logical no-undo.

using_grs = can-find(mfc_ctrl
               where mfc_field   = "grs_installed"
                 and mfc_logical = yes).

/*============================================================================*/
/* ****************************  Main Block  ******************************** */
/*============================================================================*/

if p_first_call
then do:
   /*FIRST TIME IN, WE SWITCH DB'S IF WE HAVE TO THEN
   CALL OURSELVES AGAIN, WHICH WILL EXECUTE THE ELSE BLOCK*/

   {pxrun.i &PROC='getSiteDataBase' &PROGRAM='icsixr.p'
      &PARAM="(input p_pod_site,
        output siteDB)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   old_db = global_db.
   if siteDB <> global_db
   then do:

      {gprun.i ""gpalias3.p"" "(siteDB, output err-flag)"}
   end.

   /* ADDED OUTPUT PARAMETER p_pod_type BELOW */
   /* ADDED p_po_type AS TENTH INPUT PARAMETER */

  /*tfq*/ {gprun.i ""yypopomtr.p""
      "(input  no,
        input  p_frame_row,
        input  p_po_curr,
        input  p_po_vend,
        input  p_pod_site,
        input  p_po_taxable,
        input  p_po_ex_rate,
        input  p_po_ex_rate2,
        input  p_po_taxc,
        input  p_po_type,
        output p_pod_req_nbr,
        output p_pod_req_line,
        output p_pod_part,
        output p_pod_pur_cost,
        output p_pod_disc_pct,
        output p_pod_qty_ord,
        output p_pod_need,
        output p_pod_due_date,
        output p_pod_um,
        output p_pod_um_conv,
        output p_pod_project,
        output p_pod_acct,
        output p_pod_sub,
        output p_pod_cc,
        output p_pod_request,
        output p_pod_approve,
        output p_pod_apr_code,
        output p_pod_desc,
        output p_pod_taxc,
        output p_pod_taxable,
        output p_pod_vpart,
        output p_pod_cmtindx,
        output p_pod_lot_rcpt,
        output p_pod_rev,
        output p_pod_loc,
        output p_pod_insp_rqd,
        output p_mfgr,
        output p_mfgr_part,
        output p_desc1,
        output p_desc2,
        output p_continue,
        output p_ReqCommentIndex,
        output p_pod_type)"}

   /*SWITCH BACK TO CENTRAL PO DB IF WE HAVE TO*/

   if old_db <> global_db
   then do:
      {gprun.i ""gpalias3.p"" "(old_db, output err-flag)"}
   end.

   /*CHANGE DUE DATE TO PO HEADER DUE DATE WHEN ENTERED ON HEADER*/
   /** DUE DATE COMES FROM REQ. ONLY WHEN HEADER DATE = "?" **/
   if due_date <> ?
   then
      p_pod_due_date = due_date.

   if siteDB <> old_db
   then do:
      /* COPY THE TRANSACTION COMMENTS FROM REQUISITION */
      {pxrun.i &PROC='copyCommentsFromDb' &PROGRAM='gpcmxr.p'
         &PARAM="(input sitedb,
           input old_Db,
           input p_ReqCommentIndex,
           output p_pod_cmtindx)"
         &NOAPPERROR=true &CATCHERROR=true}

   end.
   else do:
      /*COPY REQ COMMENTS TO PO LINE*/
      {pxrun.i &PROC='copyComments' &PROGRAM='gpcmxr.p'
         &PARAM="(input p_ReqCommentIndex, output p_pod_cmtindx)"
         &NOAPPERROR=true &CATCHERROR=true}
   end.

end.
else do:
   if using_grs
   then do:
      /*GET REQUISITION NUMBER FROM THE USER*/
      /*GRS-STYLE REQUISITIONS*/

      /* ADDED OUTPUT PARAMETER p_pod_type BELOW */
      /* ADDED p_po_type AS TENTH INPUT PARAMETER */

      {gprunmo.i &program="popomtr1.p"
         &module="GRS"
         &param="""(input no,
           input  p_frame_row,
           input  p_po_curr,
           input  p_po_vend,
           input  p_pod_site,
           input  p_po_taxable,
           input  p_po_ex_rate,
           input  p_po_ex_rate2,
           input  p_po_taxc,
           input  p_po_type,
           output p_pod_req_nbr,
           output p_pod_req_line,
           output p_pod_part,
           output p_pod_pur_cost,
           output p_pod_disc_pct,
           output p_pod_qty_ord,
           output p_pod_need,
           output p_pod_due_date,
           output p_pod_um,
           output p_pod_um_conv,
           output p_pod_project,
           output p_pod_acct,
           output p_pod_sub,
           output p_pod_cc,
           output p_pod_request,
           output p_pod_approve,
           output p_pod_apr_code,
           output p_pod_desc,
           output p_pod_taxc,
           output p_pod_taxable,
           output p_pod_vpart,
           output p_pod_cmtindx,
           output p_pod_lot_rcpt,
           output p_pod_rev,
           output p_pod_loc,
           output p_pod_insp_rqd,
           output p_mfgr,
           output p_mfgr_part,
           output p_desc1,
           output p_desc2,
           output p_continue,
           output p_ReqCommentIndex,
           output p_pod_type)"""}
   end.
   else do:
      /*GET REQUISITION NUMBER FROM THE USER*/
      /*ORIGINAL-STYLE REQUISITIONS*/

      /* ADDED p_pod_type AS THIRTY THIRD OUTPUT PARAMETER*/
      /* ADDED p_po_type  AS TENTH INPUT PARAMETER */

   /*tfq*/   {gprun.i ""yypopomtr2.p""
         "(input no,
           input p_frame_row,
           input p_po_curr,
           input p_po_vend,
           input p_pod_site,
           input p_po_taxable,
           input p_po_ex_rate,
           input p_po_ex_rate2,
           input p_po_taxc,
           input p_po_type,
           output p_pod_req_nbr,
           output p_pod_req_line,
           output p_pod_part,
           output p_pod_pur_cost,
           output p_pod_disc_pct,
           output p_pod_qty_ord,
           output p_pod_need,
           output p_pod_due_date,
           output p_pod_um,
           output p_pod_um_conv,
           output p_pod_project,
           output p_pod_acct,
           output p_pod_sub,
           output p_pod_cc,
           output p_pod_request,
           output p_pod_approve,
           output p_pod_apr_code,
           output p_pod_desc,
           output p_pod_taxc,
           output p_pod_taxable,
           output p_pod_vpart,
           output p_pod_cmtindx,
           output p_pod_lot_rcpt,
           output p_pod_rev,
           output p_pod_loc,
           output p_pod_insp_rqd,
           output p_mfgr,
           output p_mfgr_part,
           output p_desc1,
           output p_desc2,
           output p_continue,
           output p_ReqCommentIndex,
           output p_pod_type)"}
   end.

end.
