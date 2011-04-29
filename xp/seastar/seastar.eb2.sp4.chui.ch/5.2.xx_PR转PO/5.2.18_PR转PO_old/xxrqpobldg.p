/* rqpobldg.p - Requisition Line Item Retrieval Sub-Program                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.5.3.7 $                                                     */
/*V8:ConvertMode=ReportAndMaintenance                                       */
/* REVISION 8.5       LAST MODIFIED: 04/15/97  BY: *J1Q2* Patrick Rowan     */
/* REVISION 8.6       LAST MODIFIED: 05/20/98  BY: *K1Q4* Alfred Tan        */
/* REVISION 8.6       LAST MODIFIED: 06/22/98  BY: *J2QB* B. Gates          */
/* REVISION 9.1       LAST MODIFIED: 10/01/99  BY: *N014* Robin McCarthy    */
/* REVISION 9.1       LAST MODIFIED: 08/12/00  BY: *N0KP* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.3.6     BY: Mugdha Tambe        DATE: 08/28/01  ECO: *P012*  */
/* $Revision: 1.5.3.7 $    BY: Manisha Sawant      DATE: 12/05/02  ECO: *N219*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */

/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: Copy all requisition detail from a supplied site to a work-file.
              Supports the GRS Purchase Requisition Module of MFG/PRO.

 Notes:

============================================================================
!*/
{mfdeclre.i " "}

/* PARAMETERS */
define input parameter p_first_call   like mfc_logical no-undo.
define input parameter p_site         like rqd_site no-undo.
define input parameter v_vend         like po_vend no-undo.

/* VARIABLES */
define variable old_db                as character no-undo.
define variable err-flag              as integer no-undo.
define variable i                     as integer no-undo.
define var      v_effdate             as date initial today . /*xp001*/

/* CONSTANTS */
{rqconst.i}

/* SHARED VARIABLES*/
{xxrqpovars.i }

/* INITIALIZATION */
if p_first_call then do:

   /* FIRST TIME IN, WE CLEAR TEMP TABLES  */
   for each wkrqd_det exclusive-lock:
      delete wkrqd_det.
   end.

   for each wkcmt_det exclusive-lock:
      delete wkcmt_det.
   end.

end.  /* IF p_first_call */

if p_first_call and p_site <> ""
then do:
   /* WE SWITCH DB'S IF A SITE HAS BEEN PASSED AND        */
   /* CALL OURSELVES AGAIN, WHICH WILL EXECUTE THE ELSE BLOCK*/

   for first si_mstr
      fields(si_db si_site)
      where si_site = p_site
      no-lock:
   end. /* FOR FIRST si_mstr */


   if si_db <> global_db
   then do:
      old_db = global_db.
      {gprun.i ""gpalias3.p"" "(si_db, output err-flag)"}
   end.

   {gprun.i ""xxrqpobldg.p""
      "(input false,
        input p_site,
		input v_vend)"}

   /*SWITCH BACK TO CENTRAL PO DB IF WE HAVE TO*/
   if old_db <> global_db then do:
      {gprun.i ""gpalias3.p"" "(old_db, output err-flag)"}
   end.

end. /* IF p_first_call AND p_site <> "" */
else do:

   /*  RETRIEVE RECORDS AND LOAD TEMP-TABLES */

   rqpoloop:
   for each rqpo_wrk
      where rqpo_copy_to_po
	  and rqpo_supplier  = v_vend 
	  and rqpo_site = p_site no-lock:

      /* COPY REQUISITION LINE ITEM */

      for first rqd_det
         where rqd_nbr  = rqpo_nbr
         and   rqd_line = rqpo_line
         no-lock:
      end. /* FOR FIRST rqd_det */

      create wkrqd_det.
      assign
         wkrqd_nbr          = rqd_nbr
         wkrqd_line         = rqd_line
         wkrqd_site         = rqd_site
         wkrqd_due_date     = rqd_due_date
         wkrqd_disc_pct     = rqd_disc_pct
         wkrqd_desc         = rqd_desc
         wkrqd_project      = rqd_project
         wkrqd_um           = rqd_um
         wkrqd_um_conv      = rqd_um_conv
         wkrqd_acct         = rqd_acct
         wkrqd_status       = rqd_status
         /* wkrqd_pur_cost     = rqd_pur_cost */ /*xp001*/
         wkrqd_vpart        = rqd_vpart
         wkrqd_vend         = rqd_vend
         wkrqd_part         = rqd_part
         wkrqd_insp_rqd     = rqd_insp_rqd
         wkrqd_loc          = rqd_loc
         wkrqd_rev          = rqd_rev
         wkrqd_due_date     = rqd_due_date
         wkrqd_need_date    = rqd_need_date
         wkrqd_type         = rqd_type
         wkrqd_qadc01       = rqd__qadc01
         .


      /* COPY REQUISITION HEADER DATA */
      for first rqm_mstr
         fields( rqm_cc rqm_curr rqm_email_opt rqm_end_userid
                 rqm_job rqm_nbr rqm_prev_userid rqm_rqby_userid rqm_sub
               )
         where rqm_nbr  = rqpo_nbr
         no-lock:
      end. /* FOR FIRST rqd_det */

      assign
         wkrqd_job          = rqm_job
         wkrqd_rqby_userid  = rqm_rqby_userid
         wkrqd_prev_userid  = rqm_prev_userid
         wkrqd_end_userid   = rqm_end_userid
         wkrqd_email_opt    = rqm_email_opt
         wkrqd_curr         = rqm_curr
         wkrqd_sub          = rqm_sub
         wkrqd_cc           = rqm_cc
         .

/*xp001*/

	  for each pc_mstr use-index pc_part 
						where pc_part = rqpo_item 
	                     and pc_list = rqpo_supplier 
						 and pc_um = rqd_um 
						 and pc_curr = rqm_curr 
						 and (pc_start  <= v_effdate or v_effdate = ? )
						 and (pc_expire >= v_effdate or pc_expire = ? )
		  no-lock break by pc_start by pc_amt[1] desc :

		  if last-of(pc_start) then do:  
			  wkrqd_pur_cost  = pc_amt[1] .
		  end.
	  end.
      

/*xp001*/

      /* COPY REQ. LINE COMMENTS, IF THEY EXIST AND ARE FLAGGED */
      if include_lcmmts and rqd_cmtindx <> 0
      then do:

         wkrqd_cmtindx = rqd_cmtindx.

         /*COPY COMMENTS*/

         for each cmt_det where cmt_indx = rqd_cmtindx
            no-lock:
            create wkcmt_det.

            assign
               wkcmt_det.cmt_indx      = cmt_det.cmt_indx
               wkcmt_det.cmt_seq       = cmt_det.cmt_seq
               wkcmt_det.cmt_ref       = cmt_det.cmt_ref
               wkcmt_det.cmt_type      = cmt_det.cmt_type
               wkcmt_det.cmt_print     = cmt_det.cmt_print
               wkcmt_det.cmt_lang      = cmt_det.cmt_lang .

            do i = 1 to 15:
               wkcmt_det.cmt_cmmt [i]  = cmt_det.cmt_cmmt [i].
            end.

         end. /* FOR EACH cmt_det WHERE cmt_indx = rqd_cmtindx  */

      end. /* IF include_lcmmts AND rqd_cmtindx <> 0  */
      else
         wkrqd_cmtindx = 0.

   end.  /* FOR EACH rqpo_wrk */

end. /* ELSE DO: */

/* RETURN */
