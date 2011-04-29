/* rqpovars.i - Define shared variables for Requisition - PO Build            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.2.7 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      LAST MODIFIED: 04/15/97   BY: *J1Q2* Patrick Rowan      */
/* REVISION: 8.5      LAST MODIFIED: 06/22/98   BY: *J2QB* B. Gates           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.2.6      BY: Mugdha Tambe       DATE: 09/11/01  ECO: *P012*  */
/* $Revision: 1.7.2.7 $     BY: Manisha Sawant     DATE: 12/05/02  ECO: *N219*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: DEFINE variables needed for building a PO from requisitions.
              Supports the multi-line Purchase Requisition Module of MFG/PRO.

 Notes:
 ============================================================================
 !*/

/* VARIABLES */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rqpovars_i_1 "Open Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqpovars_i_2 "Copy Line Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqpovars_i_3 "Copy Header Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define {1} shared variable info_correct
   like mfc_logical no-undo.
define {1} shared variable return_code
   as integer no-undo.
define {1} shared variable rqpo_recno as recid no-undo.

/* LOGICALS */
define {1} shared variable include_hcmmts
   like mfc_logical no-undo  label {&rqpovars_i_3}.
define {1} shared variable include_lcmmts
   like mfc_logical no-undo  label {&rqpovars_i_2}.

/* TEMP TABLE */
 /*define {1} shared temp-table rqpo_wrk no-undo
   field rqpo_nbr                     like rqm_mstr.rqm_nbr
   field rqpo_line                    like rqd_line
   field rqpo_site                    like rqd_site
   field rqpo_item                    like rqd_part
   field rqpo_net_qty                 like rqd_req_qty  label {&rqpovars_i_1}
   field rqpo_need_date               like rqd_need_date
   field rqpo_supplier                like rqd_vend
   field rqpo_ship                    like rqd_ship
   field rqpo_buyer_id                like rqm_buyer
   field rqpo_copy_to_po              like mfc_logical  label "Copy"
   index rqpo_index1                  is unique primary
   rqpo_nbr ascending
   rqpo_line ascending.
  xp001*/

define {1} shared temp-table wkrqm_mstr no-undo
   field wkrqm_nbr          like rqm_mstr.rqm_nbr
   field wkrqm_disc_pct     like rqm_disc_pct
   field wkrqm_rmks         like rqm_rmks
   field wkrqm_sub          like rqm_sub
   field wkrqm_cc           like rqm_cc
   field wkrqm_curr         like rqm_curr
   field wkrqm_pr_list      like rqm_pr_list
   field wkrqm_pr_list2     like rqm_pr_list2
   field wkrqm_fix_rate     like rqm_fix_rate
   field wkrqm_lang         like rqm_lang
   field wkrqm_buyer        like rqm_buyer
   field wkrqm_due_date     like rqm_due_date
   field wkrqm_job          like rqm_job
   field wkrqm_site         like rqm_site
   field wkrqm_project      like rqm_project
   field wkrqm_rqby_userid  like rqm_rqby_userid
   field wkrqm_prev_userid  like rqm_prev_userid
   field wkrqm_cmtindx      like rqm_cmtindx
   .

define {1} shared temp-table wkrqd_det no-undo
   field wkrqd_nbr          like rqd_nbr
   field wkrqd_line         like rqd_line
   field wkrqd_site         like rqd_site
   field wkrqd_disc_pct     like rqd_disc_pct
   field wkrqd_desc         like rqd_desc
   field wkrqd_project      like rqd_project
   field wkrqd_part         like rqd_part
   field wkrqd_um           like rqd_um
   field wkrqd_um_conv      like rqd_um_conv
   field wkrqd_acct         like rqd_acct
   field wkrqd_sub          like rqm_sub
   field wkrqd_cc           like rqm_cc

   field wkrqd_status       like rqd_status
   field wkrqd_pur_cost     like rqd_pur_cost
   field wkrqd_vpart        like rqd_vpart
   field wkrqd_vend         like rqd_vend
   field wkrqd_insp_rqd     like rqd_insp_rqd
   field wkrqd_loc          like rqd_loc
   field wkrqd_rev          like rqd_rev
   field wkrqd_due_date     like rqd_due_date
   field wkrqd_need_date    like rqd_need_date
   field wkrqd_type         like rqd_type
   field wkrqd_cmtindx      like rqd_cmtindx
   field wkrqd_job          like rqm_job
   field wkrqd_rqby_userid  like rqm_rqby_userid
   field wkrqd_prev_userid  like rqm_prev_userid
   field wkrqd_end_userid   like rqm_end_userid
   field wkrqd_email_opt    like rqm_email_opt
   field wkrqd_curr         like rqm_curr
   field wkrqd_qadc01       like rqd__qadc01
   .

define {1} shared temp-table wkcmt_det no-undo
   like cmt_det.
