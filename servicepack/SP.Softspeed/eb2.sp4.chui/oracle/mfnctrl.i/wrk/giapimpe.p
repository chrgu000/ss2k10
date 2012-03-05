/* giapimpe.p - PURCHASE REQUISITION UPDATE                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 9.0           CREATED: 08/19/98    BY: *M004* Jim Williams */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan   */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00    BY: *N0L1* Mark Brown   */
/* REVISION: 9.1      LAST MODIFIED: 11/07/00   BY: *N0TN* Jean Miller     */

         /* DISPLAY TITLE */
         {mfdeclre.i}
/*N0TN*/ {gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE giapimpe_p_1 "Extended Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE giapimpe_p_2 "Comments"
/* MaxLen: Comment: */

/*N0TN* &SCOPED-DEFINE giapimpe_p_3 "PURCHASE REQUISITION" */
/* MaxLen: Comment: */

/*N0TN* &SCOPED-DEFINE giapimpe_p_4 "ITEM NOT IN INVENTORY" */
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define input parameter iReqNbr like req_nbr no-undo.
         define input parameter iQty like req_qty no-undo.
         define input parameter iNeedDate like req_need no-undo.
     define input parameter iCancelOrd as integer no-undo.

         define output parameter oOrderUpdated as integer no-undo.

         define new shared variable desc1 like pt_desc1.
         define variable del-yn like mfc_logical initial no no-undo.
         define variable line like req_line no-undo.
         define variable leadtime like pt_pur_lead no-undo.
         define variable i as integer no-undo.
         define variable nonwdays as integer no-undo.
         define variable workdays as integer no-undo.
         define variable overlap as integer no-undo.
         define variable know_date as date no-undo.
         define variable find_date as date no-undo.
         define variable interval as integer no-undo.
         define variable frwrd as integer no-undo.
         define variable temp_date as date no-undo.
         define variable reqnbr like req_nbr no-undo.
         define new shared variable cmt-yn like mfc_logical
            initial no label {&giapimpe_p_2}.
         define new shared variable puramt like req_pur_cost
            label {&giapimpe_p_1}.
         define new shared variable req_recno as recid.

         define shared variable using_grs as logical no-undo.

         define variable valid_acct like mfc_logical no-undo.

         oOrderUpdated = 0.

         /* IF GRS IS ON WE WILL ONLY CREATE ACTION MESSAGES - NO UPDATE */
         /* WILL BE DONE TO GRS REQUISITIONS - THIS COULD BE DONE IN THE */
         /* FUTURE - IT WAS DETERMINED THAT GRS REQ DIRECT UPDATES WOULD */
         /* NOT BE HANDLED IN THE SCOPE OF THE INITIAL PROJECT           */

         if using_grs then do:
            /*GRS enabled*/
            oOrderUpdated = 2.
            leave.
         end.

         find first gl_ctrl no-lock no-error.

         mainloop:
         do on error undo, retry:
            /*GET NEXT REQ NUMBER IF BLANK */
            do transaction with frame a:
               reqnbr = "".
                if iReqNbr <> "" then reqnbr = iReqNbr.
                else do:
                  find first woc_ctrl no-lock no-error.
                  if not available woc_ctrl then create woc_ctrl.
                  {mfnctrl.i woc_ctrl woc_nbr req_det req_nbr reqnbr}
                end.
                if reqnbr = "" then undo, retry.
            end.  /* transaction */

            do transaction:

               /* ADD/MODIFY/DELETE */
               find req_det where req_nbr = reqnbr exclusive-lock no-error.
               if ambiguous req_det then find req_det where req_nbr = reqnbr
               and req_line = line exclusive-lock no-error.

               if not available req_det then do:

                  undo mainloop, return error.

               end. /* IF NOT AVAILABLE REQ_DET */

               del-yn = no.

/*N0TN*        desc1 = {&giapimpe_p_4}. */
/*N0TN*/       desc1 = getTermLabel("ITEM_NOT_IN_INVENTORY",24).
               find pt_mstr where pt_part = req_part no-lock no-error.
               find ptp_det where ptp_part = req_part and ptp_site = req_site
                  no-lock no-error.
               if available pt_mstr then do:
                  desc1 = pt_desc1.
               end.

               /* SET GLOBAL PART VARIABLE */
               global_part = req_part.

               /*CALCULATE AND DISPLAY EXTENDED AMOUNT*/
               if not available pt_mstr then
                  puramt = req_pur_cost * req_qty.
               else do:
                  {gpsct05.i
                     &part=pt_part
                     &site=req_site
                     &cost=sct_mtl_tl}
                  req_pur_cost = glxcst.
                  puramt = req_pur_cost * req_qty.
               end.

               cmt-yn = can-find(first cmt_det where cmt_indx = req_cmtindx).

               seta-2: do on error undo, retry:

                  if iCancelOrd <> 1 then do:

                     if iQty <> req_qty then req_qty = iQty.
                     if iNeedDate <> req_need then req_need = iNeedDate.

                  end.

                  /* DELETE */
                  if iCancelOrd = 1 then del-yn = yes.

                  if del-yn or req_part = "" then do:

                     /* Mrp workfile */
                     {mfmrw.i "req_det" req_part req_nbr string(req_line) """"
                     req_rel_date req_need
                     "0" "SUPPLYF" PURCHASE_REQUISITION req_site}

                     /* DELETE COMMENTS */
                     for each cmt_det exclusive-lock
                     where cmt_indx = req_cmtindx:
                        delete cmt_det.
                     end.

                     delete req_det.
                     del-yn = no.
                     leave mainloop.
                  end.

                  if req_qty = 0 then do:
                     undo seta-2, retry.
                  end.

                  if req_rel_date = ? and req_need = ? then
                     req_rel_date = today.
                  if req_rel_date = ? or req_need = ? then do:
                     leadtime = 0.
                     if available ptp_det then
                        leadtime = ptp_pur_lead.
                     else
                     if available pt_mstr then
                        leadtime = pt_pur_lead.

                     if req_rel_date = ? then
                        req_rel_date = req_need - leadtime.
                     if req_need = ? then
                        req_need = req_rel_date + leadtime.
                  end.
                  {mfhdate.i req_need 1 req_site}
                  {mfhdate.i req_rel_date -1 req_site}

                  /* Update mrp_det purchase requisitions */
                  {mfmrw.i "req_det" req_part req_nbr string(req_line) """"
                  req_rel_date req_need
                  "req_qty" "SUPPLYF" PURCHASE_REQUISITION req_site}

                  puramt = req_pur_cost * req_qty.

               end. /* seta-2 */

            end.  /*transaction*/

         end. /* repeat */
