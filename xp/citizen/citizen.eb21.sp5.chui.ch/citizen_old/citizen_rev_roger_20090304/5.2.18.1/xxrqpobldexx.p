/* rqpoblde.p - Requisition Retrieval Sub-Program                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.4.1.6 $                                                         */
/*V8:ConvertMode=ReportAndMaintenance                                       */
/* REVISION 8.5       LAST MODIFIED: 04/15/97  BY: *J1Q2* Patrick Rowan     */
/* REVISION 8.6       LAST MODIFIED: 05/20/98  BY: *K1Q4* Alfred Tan        */
/* REVISION 8.6       LAST MODIFIED: 09/09/99  BY: *J39R* Reetu Kapoor      */
/* REVISION 9.0       LAST MODIFIED: 03/02/00  BY: *M0KC* Reetu Kapoor      */
/* REVISION 9.1       LAST MODIFIED: 08/12/00  BY: *N0KP* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.4.1.4  BY: Katie Hilbert DATE: 09/19/02 ECO: *N1VC* */
/* $Revision: 1.4.1.6 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */



/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/03/28  ECO: *xp004*  */ /*添加限制:同地点,同供应商的零件,且交货库位相同的采购申请,才能转化为同一采购单*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/06/13  ECO: *xp005*  */ /*C开头的请购单,默认用1.19库位,不存在则用1.4.16库位;非C开头的请购单,默认用1.4.16库位*/
/*-Revision end---------------------------------------------------------------*/

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
/*define input parameter p_supplier1    like rqm_vend no-undo. */ /*xp004*/
define input parameter p_part         like rqd_part no-undo.
define input parameter p_part1        like rqd_part no-undo.
define input parameter p_need_date    like rqd_need_date no-undo.
define input parameter p_need_date1   like rqd_need_date no-undo.
define input parameter p_buyer_id     like rqm_buyer no-undo.
define input parameter p_site         like rqd_site no-undo.
define input parameter p_loc          like loc_loc  no-undo. /*xp004*/
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

/*  INITIALIZE  */
p_rqpo_wrk_cntr = 0.

/*  CLEAR TEMP TABLE  */
for each rqpo_wrk exclusive-lock:
   delete rqpo_wrk.
end.

if p_first_call and p_site <> "" then do:
   /*FIRST TIME IN, WE SWITCH DB'S IF A SITE HAS BEEN PASSED AND
   CALL OURSELVES AGAIN, WHICH WILL EXECUTE THE ELSE BLOCK*/
   find si_mstr  where si_mstr.si_domain = global_domain and  si_site = p_site
   no-lock.

   if si_db <> global_db then do:
      old_db = global_db.
      {gprun.i ""gpalias3.p"" "(si_db, output err-flag)"}
   end.

   {gprun.i ""xxrqpobldexx.p""
      "(input false,
        input p_req_nbr,
        input p_req_nbr1,
        input p_supplier,
        input p_part,
        input p_part1,
        input p_need_date,
        input p_need_date1,
        input p_buyer_id,
        input p_site,
		input p_loc,
        input p_requester,
        input p_job_name,
        input p_ship,
        input p_currency,
        input p_blank_suppliers,
        input p_include_mrp_type,
        input p_include_mro_type,
        input p_default_copy,
        output p_rqpo_wrk_cntr)"}  /*xp004*/

   /*SWITCH BACK TO CENTRAL PO DB IF WE HAVE TO*/
   if old_db <> global_db then do:
      {gprun.i ""gpalias3.p"" "(old_db, output err-flag)"}
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

   for each rqm_mstr  where rqm_mstr.rqm_domain = global_domain and (
      rqm_open                      and
      (rqm_rtdto_purch)             and
      (rqm_nbr        >= p_req_nbr  and rqm_nbr <= p_req_nbr1)   and
      (rqm_rqby_userid = p_requester or p_requester = "")        and
      (rqm_buyer       = p_buyer_id  or p_buyer_id = "")         and
      (rqm_curr        = p_currency  or p_currency = "")         and
      (rqm_job         = p_job_name  or p_job_name = "")         and
      rqm_status       = ""                                      and
      (rqm_ship        = p_ship      or  p_ship = "")
   ) no-lock:

      /*  NOTES: rqd_aprv_stat:  the approval status on the line.
      Only after the entire requisition has been approved
      does each line status become approved.
      rqd_open: Indicates the line has quantity that has
      not been placed on a PO.          */

      for each rqd_det  where rqd_det.rqd_domain = global_domain and (
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
			  (p_blank_suppliers = no       and (rqd_vend = p_supplier  /*xp004*/)
			  )) and
			 ((p_include_mrp_type           and rqd_type = "")
			  or
			  (p_include_mro_type           and rqd_type <> ""))   and
			 (rqd_site = p_site             or  p_site = "")
	         ) 
          and ( /*xp005*_start*/ 
               ((not rqd_nbr begins "C" ) and can-find(first in_mstr where in_domain = global_domain 
                                                            and in_site = rqd_site 
                                                            and in_part = rqd_part 
                                                            and in_loc  = p_loc)
               ) 
               or 
               (rqd_nbr begins "C" and (can-find(first vp_mstr where vp_domain = global_domain 
                                                         and vp_part = "C" and vp_vend = rqd_vend and vp_vend_part = p_loc )                                        
                                        or (  (not can-find(first vp_mstr where vp_domain = global_domain 
                                                             and vp_part = "C" and vp_vend = rqd_vend )
                                              ) and( can-find(first in_mstr where in_domain = global_domain 
                                                              and in_site = rqd_site and in_part = rqd_part and in_loc  = p_loc)
                                                   )
                                           )
                                        )
               )
              ) /*xp005*_end*/
    
	  no-lock :

         /* DETERMINE OPEN QTY: QTY ALREADY PLACED ON PO'S */
         open_qty = 0.
         {gprun.i ""rqoqty.p""
            "(input true,
              input rqd_site,
              input rqm_nbr,
              input rqd_line,
              output open_qty,
              output qty_um)"}

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

         end.  /* if open_qty > 0 */

      end.  /* for each rqd_det */

   end.  /* for each rqm_mstr */

end.
