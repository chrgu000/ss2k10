/* GUI CONVERTED from rqpoblde.p (converter v1.76) Thu Sep 19 11:09:40 2002 */
/* rqpoblde.p - Requisition Retrieval Sub-Program                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.4.1.4 $                                                         */
/*V8:ConvertMode=ReportAndMaintenance                                       */
/* REVISION 8.5       LAST MODIFIED: 04/15/97  BY: *J1Q2* Patrick Rowan     */
/* REVISION 8.6       LAST MODIFIED: 05/20/98  BY: *K1Q4* Alfred Tan        */
/* REVISION 8.6       LAST MODIFIED: 09/09/99  BY: *J39R* Reetu Kapoor      */
/* REVISION 9.0       LAST MODIFIED: 03/02/00  BY: *M0KC* Reetu Kapoor      */
/* REVISION 9.1       LAST MODIFIED: 08/12/00  BY: *N0KP* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.4.1.4 $    BY: Katie Hilbert       DATE: 09/19/02  ECO: *N1VC*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: Copy requisitions from a supplied site to a work-file.
              Supports the GRS Purchase Requisition Module of MFG/PRO.

 Notes:

============================================================================
!*/
{mfdeclre.i " "}

/* PARAMETERS */
define input parameter p_first_call   like mfc_logical no-undo.
define input parameter p_req_nbr      like rqm_mstr.rqm_nbr no-undo.
define input parameter p_req_nbr1     like rqm_mstr.rqm_nbr no-undo.
define input parameter p_supplier     like rqm_vend no-undo.
define input parameter p_supplier1    like rqm_vend no-undo.
define input parameter p_part         like rqd_part no-undo.
define input parameter p_part1        like rqd_part no-undo.
define input parameter p_need_date    like rqd_need_date no-undo.
define input parameter p_need_date1   like rqd_need_date no-undo.
define input parameter p_buyer_id     like rqm_buyer no-undo.
define input parameter p_site         like rqd_site no-undo.
define input parameter p_requester    like rqm_rqby_userid no-undo.
define input parameter p_job_name     like rqm_job no-undo.
define input parameter p_ship         like rqd_ship no-undo.
define input parameter p_currency     like rqm_curr no-undo.
define input parameter p_blank_suppliers
   like mfc_logical no-undo.
define input parameter p_include_mrp_type
   like mfc_logical no-undo.
define input parameter p_include_mro_type
   like mfc_logical no-undo.
define input parameter p_default_copy like mfc_logical no-undo.
define output parameter p_rqpo_wrk_cntr as integer no-undo.

/* VARIABLES */
define variable open_qty              like rqd_req_qty no-undo.
define variable qty_um                like rqd_um no-undo.
define variable old_db                as character no-undo.
define variable err-flag              as integer no-undo.

/* CONSTANTS */
{rqconst.i}

/* SHARED VARIABLES*/
{rqpovars.i }

/*ZH002 ADD****************************************************/

define shared temp-table rqpo2_wrk no-undo
   field rqpo2_nbr                     like rqm_mstr.rqm_nbr
   field rqpo2_line                    like rqd_line
   field rqpo2_site                    like rqd_site
   field rqpo2_item                    like rqd_part
   field rqpo2_net_qty                 like rqd_req_qty
   field rqpo2_need_date               like rqd_need_date
   field rqpo2_supplier                like rqd_vend
   field rqpo2_ship                    like rqd_ship
   field rqpo2_buyer_id                like rqm_buyer
   field rqpo2_copy_to_po              like mfc_logical  label "Copy"
   field rqpo2_finish                  like mfc_logical
   index rqpo2_index1                  is unique primary
   rqpo2_nbr ascending
   rqpo2_line ascending.

define shared temp-table rqpo3_wrk no-undo
   field rqpo3_nbr                     like rqm_mstr.rqm_nbr
   field rqpo3_line                    like rqd_line
   field rqpo3_site                    like rqd_site
   field rqpo3_item                    like rqd_part
   field rqpo3_net_qty                 like rqd_req_qty
   field rqpo3_need_date               like rqd_need_date
   field rqpo3_supplier                like rqd_vend
   field rqpo3_ship                    like rqd_ship
   field rqpo3_buyer_id                like rqm_buyer
   field rqpo3_copy_to_po              like mfc_logical  label "Copy"
   field rqpo3_finish                  like mfc_logical
   field rqpo3_um                      like rqd_um
   index rqpo3_index1                  is unique primary
   rqpo3_nbr ascending
   rqpo3_line ascending.

define shared temp-table rqpo4_wrk no-undo
   field rqpo4_nbr                     like rqm_mstr.rqm_nbr
   field rqpo4_line                    like rqd_line
   field rqpo4_site                    like rqd_site
   field rqpo4_item                    like rqd_part
   field rqpo4_net_qty                 like rqd_req_qty
   field rqpo4_need_date               like rqd_need_date
   field rqpo4_supplier                like rqd_vend
   field rqpo4_ship                    like rqd_ship
   field rqpo4_buyer_id                like rqm_buyer
   field rqpo4_copy_to_po              like mfc_logical  label "Copy"
   field rqpo4_finish                  like mfc_logical
   field rqpo4_um                      like rqd_um
   index rqpo4_index1                  is unique primary
   rqpo4_nbr ascending
   rqpo4_line ascending.

define variable l_um     like um_conv      no-undo.

/*ZH002 END****************************************************/


/*  INITIALIZE  */
p_rqpo_wrk_cntr = 0.

/*  CLEAR TEMP TABLE  */
for each rqpo_wrk exclusive-lock:
   delete rqpo_wrk.
end.

/*ZH002 END****************************************************/

for each rqpo2_wrk exclusive-lock:
   delete rqpo2_wrk.
end.

for each rqpo3_wrk exclusive-lock:
   delete rqpo3_wrk.
end.

for each rqpo4_wrk exclusive-lock:
   delete rqpo4_wrk.
end.

/*ZH002 END****************************************************/

if p_first_call and p_site <> "" then do:
   /*FIRST TIME IN, WE SWITCH DB'S IF A SITE HAS BEEN PASSED AND
   CALL OURSELVES AGAIN, WHICH WILL EXECUTE THE ELSE BLOCK*/
   find si_mstr where si_site = p_site no-lock.

   if si_db <> global_db then do:
      old_db = global_db.
      {gprun.i ""gpalias3.p"" "(si_db, output err-flag)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

   end.

/*ZH002		   {gprun.i ""rqpoblde.p""
		      "(input false,
		        input p_req_nbr,
		        input p_req_nbr1,
		        input p_supplier,
		        input p_supplier1,
		        input p_part,
		        input p_part1,
		        input p_need_date,
		        input p_need_date1,
		        input p_buyer_id,
		        input p_site,
		        input p_requester,
		        input p_job_name,
		        input p_ship,
		        input p_currency,
		        input p_blank_suppliers,
		        input p_include_mrp_type,
		        input p_include_mro_type,
		        input p_default_copy,
		        output p_rqpo_wrk_cntr)"}*/
/*ZH002*/	   {gprun.i ""xxrqpoblde.p""
		      "(input false,
		        input p_req_nbr,
		        input p_req_nbr1,
		        input p_supplier,
		        input p_supplier1,
		        input p_part,
		        input p_part1,
		        input p_need_date,
		        input p_need_date1,
		        input p_buyer_id,
		        input p_site,
		        input p_requester,
		        input p_job_name,
		        input p_ship,
		        input p_currency,
		        input p_blank_suppliers,
		        input p_include_mrp_type,
		        input p_include_mro_type,
		        input p_default_copy,
		        output p_rqpo_wrk_cntr)"}		        
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


   /*SWITCH BACK TO CENTRAL PO DB IF WE HAVE TO*/
   if old_db <> global_db then do:
      {gprun.i ""gpalias3.p"" "(old_db, output err-flag)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

   end.

end.
else do:

   /*  RETRIEVE RECORDS AND LOAD TEMP-TABLE */

   /*  NOTES: rqm_rtdto_purch: indicates the req has been routed to
   purchasing.  Reqs can only be routed to purchasing
   after full approval.  Once in OOT, the req. header
   remains routed to purchasing, even though the
   approval status is "unapproved".
   rqm_open: Indicates one or more lines has open quantity.
   Once the req. lines are consumed on POs, then the
   open qty = 0.                */

   for each rqm_mstr where
      rqm_open                      and
      (rqm_rtdto_purch)             and
      (rqm_nbr        >= p_req_nbr  and rqm_nbr <= p_req_nbr1)   and
      (rqm_rqby_userid = p_requester or p_requester = "")        and
      (rqm_buyer       = p_buyer_id  or p_buyer_id = "")         and
      (rqm_curr        = p_currency  or p_currency = "")         and
      (rqm_job         = p_job_name  or p_job_name = "")         and
      rqm_status       = ""                                      and
      (rqm_ship        = p_ship      or  p_ship = "")
   no-lock:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


      /*  NOTES: rqd_aprv_stat:  the approval status on the line.
      Only after the entire requisition has been approved
      does each line status become approved.
      rqd_open: Indicates the line has quantity that has
      not been placed on a PO.          */

      for each rqd_det where
         (rqd_nbr       = rqm_nbr)      and
         (rqd_open)                     and
         (rqd_status    = "")           and
         (rqd_aprv_stat = APPROVAL_STATUS_APPROVED or
          rqd_aprv_stat = APPROVAL_STATUS_OOT)                   and
         (rqd_part      >= p_part      and rqd_part <= p_part1)  and
         (rqd_need_date >= p_need_date and rqd_need_date <= p_need_date1)
         and
         ((p_blank_suppliers            and rqd_vend = "")
          or
          (p_blank_suppliers = no       and
          (rqd_vend >= p_supplier    and rqd_vend <= p_supplier1))) and
         ((p_include_mrp_type           and rqd_type = "")
          or
          (p_include_mro_type           and rqd_type <> ""))   and
         (rqd_site = p_site             or  p_site = "")
      no-lock:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


         /* DETERMINE OPEN QTY: QTY ALREADY PLACED ON PO'S */
         open_qty = 0.
         {gprun.i ""rqoqty.p""
            "(input true,
              input rqd_site,
              input rqm_nbr,
              input rqd_line,
              output open_qty,
              output qty_um)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


         /* MAKE SURE THERE IS OPEN BEFORE SELECTING THE LINE */
         if open_qty > 0 then do:
            create rqpo_wrk.
            assign
               rqpo_nbr        = rqm_nbr
               rqpo_line       = rqd_line
               rqpo_item       = rqd_part
               rqpo_site       = rqd_site
               rqpo_net_qty    = open_qty
               rqpo_need_date  = rqd_need_date
               rqpo_supplier   = rqd_vend
               rqpo_ship       = rqm_ship
               rqpo_buyer_id   = rqm_buyer
               rqpo_copy_to_po = p_default_copy.

            p_rqpo_wrk_cntr = p_rqpo_wrk_cntr + 1.

/*ZH002 ADD****************************************************/

            create rqpo4_wrk.
            assign
               rqpo4_nbr        = rqm_nbr
               rqpo4_line       = rqd_line
               rqpo4_item       = rqd_part
               rqpo4_site       = rqd_site
               rqpo4_net_qty    = open_qty
               rqpo4_need_date  = rqd_need_date
               rqpo4_supplier   = rqd_vend
               rqpo4_ship       = rqm_ship
               rqpo4_buyer_id   = rqm_buyer
               rqpo4_copy_to_po = p_default_copy
	       rqpo4_um         = rqd_um
	       rqpo4_finish     = no.

            find first rqpo2_wrk where rqpo2_supplier = rqd_vend no-error.
              if not avail rqpo2_wrk then do:

	            create rqpo2_wrk.
	            assign
	               rqpo2_nbr        = rqm_nbr
	               rqpo2_line       = rqd_line
	               rqpo2_item       = rqd_part
	               rqpo2_site       = rqd_site
	               rqpo2_net_qty    = open_qty
	               rqpo2_need_date  = rqd_need_date
	               rqpo2_supplier   = rqd_vend
	               rqpo2_ship       = rqm_ship
	               rqpo2_buyer_id   = rqm_buyer
	               rqpo2_copy_to_po = p_default_copy
	               rqpo2_finish     = no.

              end.
            
            find pt_mstr  no-lock where pt_part = rqd_part
                   and pt_prod_line >= "6000" and pt_prod_line <= "6999"  no-error.
              if avail pt_mstr then do:
                 find first rqpo3_wrk where rqpo3_supplier = rqd_vend
	            and rqpo3_item = rqd_part and rqpo3_site = rqd_site no-error.
	           if not avail rqpo3_wrk then do:	            
	             create rqpo3_wrk.
	             assign
	               rqpo3_nbr        = rqm_nbr
	               rqpo3_line       = rqd_line
	               rqpo3_item       = rqd_part
	               rqpo3_site       = rqd_site
	               rqpo3_net_qty    = open_qty
	               rqpo3_need_date  = rqd_need_date
	               rqpo3_supplier   = rqd_vend
	               rqpo3_ship       = rqm_ship
	               rqpo3_buyer_id   = rqm_buyer
	               rqpo3_copy_to_po = p_default_copy
	               rqpo3_um         = rqd_um
	               rqpo3_finish     = no.
	           end.
	           else do:
	                if rqd_need_date < rqpo3_need_date then rqpo3_need_date = rqd_need_date.
	                if rqpo3_um <> rqd_um then do:
	                        {gprun.i ""gpumcnv.p""
	                           "(input  rqd_um,
	                             input  rqpo3_um,
	                             input  rqd_part,
	                             output l_um)"}
	                        if l_um = ?
	                           then l_um = 1.
	                        rqpo3_net_qty = rqpo3_net_qty + open_qty * l_um.	                
	                
	                end.
	                else do:
	                     rqpo3_net_qty = rqpo3_net_qty + open_qty.
	                end.
	           end.
	      end.

/*ZH002 END****************************************************/

         end.  /* if open_qty > 0 */

      end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
  /* for each rqd_det */

   end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
  /* for each rqm_mstr */

end.
