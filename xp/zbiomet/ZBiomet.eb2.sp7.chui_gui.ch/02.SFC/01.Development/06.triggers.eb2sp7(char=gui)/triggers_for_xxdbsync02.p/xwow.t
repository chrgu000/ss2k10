/* wow.t   WORK ORDER WRITE TRIGGER                                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                         */
/* All rights reserved worldwide.  This is an unpublished work.                */
/* $Revision: 1.22 $                                                          */
/*V8:ConvertMode=NoConvert                                                    */
/******************************************************************************/
/* Description : wo_mstr WRITE trigger program                                */
/*             : In order to enhance this trigger to support additional       */
/*             : interfaces, add a DO-END block similar to the one used       */
/*             : for the Warehousing Interface to (1) check for the need to   */
/*             : continue processing; (2) move the relevant fields to an      */
/*             : appropriate work area; and (3) call one or more subprograms  */
/*             : to continue processing. This .t program should remain short, */
/*             : relying on subprograms to perform most of the work.          */
/******************************************************************************/
/*                                MODIFY LOG                                  */
/******************************************************************************/
/*Revision 8.5          Last Modified:  12/04/95   BY: BHolmes *J0FY*         */
/*Revision 8.5          Last Modified:  07/27/96   BY: fwy     *J12B*         */
/*Revision 8.5          Last Modified:  01/07/97   BY: jpm     *J1DM*         */
/*Revision 9.1          Last Modified:  08/12/00   BY: *N0KC* Mark Brown      */
/* Revision: 1.4         BY: Inna Fox            DATE: 06/13/02  ECO: *P04Z*  */
/* Revision: 1.10        BY: Jean Miller         DATE: 06/14/02  ECO: *P082*  */
/* Revision: 1.12        BY: Inna Fox            DATE: 06/27/02  ECO: *P08S*  */
/* Revision: 1.14        BY: Niranjan R.         DATE: 07/11/02  ECO: *P0B9*  */
/* Revision: 1.15        BY: Jean Miller         DATE: 08/01/02  ECO: *P0CL*  */
/* Revision: 1.18        BY: Jean Miller         DATE: 08/17/02  ECO: *P0FN*  */
/* $Revision: 1.22 $    BY: Deirdre O'Brien       DATE: 10/16/02  ECO: *N14F*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

TRIGGER PROCEDURE for write of WO_MSTR old buffer OLD_WO_MSTR.


/*ss - 20090401.1 - B*/
do:
    find first xwo_mstr 
	where xwo_lot = wo_mstr.wo_lot
    no-error .
    if not avail xwo_mstr then do:
	{xwo_mstr.i}
    end.
    else /*if 
	 xwo_nbr <> wo_mstr.wo_nbr
      or xwo_status <> wo_mstr.wo_status
      or xwo_lot_next <> wo_mstr.wo_lot_next 
    then*/ do:
	delete xwo_mstr .
	{xwo_mstr.i}
    end. 

end.
/*ss - 20090401.1 - E*/


{mfdeclre.i}

define new shared work-table wf_old_wo_mstr like wo_mstr.
define new shared variable w-recid as recid.
define new shared variable w-site-loc-id like whl_mstr.whl_src_dest_id.

define variable w-file      as character format "x(24)".
define variable l-qualifier as character format "x(2)" no-undo.

define variable docId            as integer   no-undo.
define variable groupId          as integer   no-undo.
define variable ctlTot1          as integer   no-undo.
define variable ctlTot2          as decimal   no-undo.
define variable ctlTot3          as decimal   no-undo.

/* Warehousing Interface processing */
WI:
do:

   /* If there is no active external warehouse that is flagged to
   receive work order export transactions, then do not process */
   if not can-find(first whl_mstr no-lock
      where whl_mstr.whl_act and whl_mstr.whl_wo_exp)
      then leave WI.

   /* If work order is not yet released, then do not process */
   if wo_mstr.wo_status <> "R" then leave WI.

   /* If no pertinent fields have been changed, then do not process */
   if (old_wo_mstr.wo_nbr      = wo_mstr.wo_nbr
      and old_wo_mstr.wo_lot      = wo_mstr.wo_lot
      and old_wo_mstr.wo_part     = wo_mstr.wo_part
      and old_wo_mstr.wo_rev      = wo_mstr.wo_rev
      and old_wo_mstr.wo_type     = wo_mstr.wo_type
      and old_wo_mstr.wo_qty_ord  = wo_mstr.wo_qty_ord
      and old_wo_mstr.wo_ord_date = wo_mstr.wo_ord_date
      and old_wo_mstr.wo_due_date = wo_mstr.wo_due_date
      and old_wo_mstr.wo_status   = wo_mstr.wo_status
      and old_wo_mstr.wo_site     = wo_mstr.wo_site
      and old_wo_mstr.wo_rmks     = wo_mstr.wo_rmks
      and old_wo_mstr.wo_user1    = wo_mstr.wo_user1
      and old_wo_mstr.wo_user2    = wo_mstr.wo_user2
      and old_wo_mstr.wo_cmtindx  = wo_mstr.wo_cmtindx)
      then
      leave WI.

   /* Move old wo_mstr fields to work table for subsequent processing */
   assign w-recid = recid(wo_mstr).

   create wf_old_wo_mstr.

   if recid(wf_old_wo_mstr)= -1 then .

   assign
      wf_old_wo_mstr.wo_nbr       = old_wo_mstr.wo_nbr
      wf_old_wo_mstr.wo_lot       = old_wo_mstr.wo_lot
      wf_old_wo_mstr.wo_part      = old_wo_mstr.wo_part
      wf_old_wo_mstr.wo_rev       = old_wo_mstr.wo_rev
      wf_old_wo_mstr.wo_type      = old_wo_mstr.wo_type
      wf_old_wo_mstr.wo_qty_ord   = old_wo_mstr.wo_qty_ord
      wf_old_wo_mstr.wo_ord_date  = old_wo_mstr.wo_ord_date
      wf_old_wo_mstr.wo_due_date  = old_wo_mstr.wo_due_date
      wf_old_wo_mstr.wo_status    = old_wo_mstr.wo_status
      wf_old_wo_mstr.wo_site      = old_wo_mstr.wo_site
      wf_old_wo_mstr.wo_rmks      = old_wo_mstr.wo_rmks
      wf_old_wo_mstr.wo_user1     = old_wo_mstr.wo_user1
      wf_old_wo_mstr.wo_user2     = old_wo_mstr.wo_user2
      wf_old_wo_mstr.wo_cmtindx   = old_wo_mstr.wo_cmtindx.

   /* Call subprogram to create export transactions for warehouses */
   w-file = "wiwow.p".

   {gprunmo.i &module="WI"
      &program="wiwow.p"}

end. /* WI */

/* Work Order on Flow Schedule */
if can-find(first flsd_det where
   flsd_flow_wo_nbr = wo_mstr.wo_nbr
   and flsd_flow_wo_lot = wo_mstr.wo_lot) then do:

   /* If Work Order status, quantity ordered, quantity completed or quantity */
   /* rejected changed, the flow schedule order needs to be updated.         */
   if old_wo_mstr.wo_status <> wo_mstr.wo_status or
      old_wo_mstr.wo_qty_ord <> wo_mstr.wo_qty_ord or
      old_wo_mstr.wo_qty_comp <> wo_mstr.wo_qty_comp or
      old_wo_mstr.wo_qty_rjct <> wo_mstr.wo_qty_rjct
   then do:
      for first flsd_det where
         flsd_flow_wo_nbr = wo_mstr.wo_nbr and
         flsd_flow_wo_lot = wo_mstr.wo_lot
      exclusive-lock:
      end.

      /* Update if Status changed. */
      if old_wo_mstr.wo_status <> wo_mstr.wo_status then do:
         if wo_mstr.wo_status = "C" and flsd_det.flsd_closed = no then
            flsd_det.flsd_closed = yes.
         else
         if wo_mstr.wo_status <> "C" and flsd_det.flsd_closed = yes then
            flsd_det.flsd_closed = no.
      end.

      /* Update if Quantity Ordered changed. */
      if old_wo_mstr.wo_qty_ord <> wo_mstr.wo_qty_ord then
         flsd_qty_ord = wo_mstr.wo_qty_ord.

      /* Update if Quantity Completed changed. */
      /* Update if Quantity Rejected changed. */
      /* Rejected or Scrap quantity will be added in flow quantity completed */
      if (old_wo_mstr.wo_qty_comp <> wo_mstr.wo_qty_comp  or
         old_wo_mstr.wo_qty_rjct <> wo_mstr.wo_qty_rjct) then
         flsd_qty_comp = wo_mstr.wo_qty_comp + wo_mstr.wo_qty_rjct.

   end. /*  status, qty ord, qty comp or qty rejected changed */
end. /* Work Order on Flow Schedule */

/* Track Capacity Units */
if wo_mstr.wo_status <> "" then do:

   /* Get New Work Orders */
   if (new wo_mstr and
      old_wo_mstr.wo_nbr  <> wo_mstr.wo_nbr) or
      /* Get Previously Planned Work Orders */
      (not new wo_mstr and
      (old_wo_mstr.wo_status <> wo_mstr.wo_status) and
      (old_wo_mstr.wo_status = "P"))
   then do:

      if wo_mstr.wo_fsm_type <> "" then do:
         l-qualifier = wo_mstr.wo_fsm_type.
      end.
      else do:

         l-qualifier = wo_mstr.wo_status + "_".

         if wo_mstr.wo_type <> "" then
            l-qualifier = wo_mstr.wo_status + wo_mstr.wo_type.

      end.

      {lvucap.i &TABLE="wo_mstr" &QUALIFIER="l-qualifier"}

   end.

end.

/***********************************************************************
ECO N14F: Publish an XML message if there is an external application
and an export message specification set up, if the work order was
originally created by the external application, and if the work order
has just been closed.
**********************************************************************/

/* Check that the work order has just been closed by WO Accounting Close
(16.21) */

if wo_mstr.wo_acct_close = yes and
   not (old_wo_mstr.wo_acct_close = yes)
then do:

   /* Check that the WO was created by an existing external application
   and that a Q/Linq export specification exists for work order
   exports and that it has publishing enabled */

   for first apr_mstr no-lock
      where apr_mstr.apr_app_id = wo_mstr.wo_app_owner,
      first esp_mstr no-lock
      where
      esp_mstr.esp_app_id = wo_mstr.wo_app_owner and
      esp_mstr.esp_doc_std = "OAGIS" and
      esp_mstr.esp_doc_typ = "RECEIVE_PRODORDER" and
      esp_mstr.esp_doc_rev = "" and
      esp_publ_flg = yes:

   /* Generate pseudo XML, and export to the raw queue in Q/Linq */

   /* Include the setup for XML generator */
   {gpxmlgen.i}

   /* Clear all temp tables */
   resetProcedure().

   /* Initialize the XML generator settings */
   run initializeParameters in myProcHandle (input "",
      input "",
      input "",
      input 0,
      input "fieldname").

   /* Concatenate the XML into largest possible blocks */
   run setConcatonateXML in myProcHandle (input true).

   /* Generate the wo pseudo XML message */
   if opsys = "unix" then output to /dev/null.
   else if opsys = "win32" then output to nul.

   /* Find the part to out part data */
   find pt_mstr where pt_part = wo_mstr.wo_part
   no-lock no-error no-wait.

   /* Dummy call to enable check-in of generator for
   wowoxml.i */
   if (false) then
      {gprun.i ""gpxmlwo.p""}

      {wowoxml.i}
      {wowoxml1.i}

      /* Get the XML document */
      run getXMLDocument in myProcHandle (output table XMLDocument).

   /* Create a Q/Linq document id */
   {gprunp.i "qqpubfwd" "p" "qqBeginInterfaceDoc"
      "(input esp_mstr.esp_app_id,
        input esp_mstr.esp_doc_std,
        input esp_mstr.esp_doc_typ,
        input esp_mstr.esp_doc_rev,
        input 0,
        input yes,
        output docId,
        output groupId,
        input esp_mstr.esp_tradptr_id,
        input '',
        input '',
        input '',
        input 0,
        input '',
        input '',
        input '',
        input '',
        input '',
        input '',
        input '',
        input no,
        input '',
        input '',
        input '',
        input '')"}

   /* Put the document on the Q/Linq raw queue */

   for each XMLDocument no-lock:

      {gprunp.i "qqpubfwd" "p" "qqBuildDocElement"
         "(input '',
           input '',
           input XMLDocument.docLine,
           input yes,
           input 0,
           input 0,
           input 0)"}
      end.

      /* Publish the document */
      {gprunp.i "qqpubfwd" "p" "qqPublishInterfaceDoc"
         "(input no,
           output ctlTot1,
           output ctlTot2,
           output ctlTot3)"}

   end. /* first apr_mstr, first esp_mstr */
end.
