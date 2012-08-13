/* GUI CONVERTED from poprwkfl.i (converter v1.69) Sat Mar 30 01:18:38 1996 */
/* poprwkfl.i - REQUISITION BY SITE WORKFILE INCLUDE FILE               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0     LAST MODIFIED: 12/04/91    BY: RAM *F033**/
/* REVISION: 7.3     LAST MODIFIED: 04/18/93    BY: afs *G971**/
/* REVISION: 7.3     LAST MODIFIED: 06/15/94    BY: afs *FO92**/
/* REVISION: 7.3     LAST MODIFIED: 03/14/96    BY: rxm *G1Q4**/

	 define {&new} shared workfile wkreq_det
	    field wkreq_nbr      like req_nbr
	    field wkreq_line     like req_line
	    field wkreq_part     like req_part
	    field wkreq_qty      like req_qty
	    field wkreq_rel_date like req_rel_date
	    field wkreq_need     like req_need
	    field wkreq_um       like req_um
	    field wkreq_site     like req_site
/*G971*/    field wkreq_po_site  like req_po_site
	    field wkreq_acct     like req_acct
	    field wkreq_cc       like req_cc
	    field wkreq_request  like req_request
	    field wkreq_apr_by   like req_apr_by
	    field wkreq_apr_code like req_apr_code
	    field wkreq_pur_cost like req_pur_cost
	    field wkreq_approved like req_approved
	    field wkreq_ptdesc   like pt_desc1 format "x(49)"
	    field wkreq_ptbuyer  like pt_buyer
/*G1Q4*/    field wkreq_ptpbuyer like pt_buyer
	    field wkreq_ptum     like pt_um
	    field wkreq_ptvend   like pt_vend
/*G1Q4*/    field wkreq_ptpvend  like pt_vend
	    field wkreq_ptvname  like ad_name
	    field wkreq_ptprice  like pt_price
	    field wkreq_insp_rqd like pt_insp_rqd
	    field wkreq_loc      like pt_loc
	    field wkreq_cmtindx  like req_cmtindx.

/****
*        define {&new} shared workfile wkvp_mstr
*           field wkvp_part      like vp_part
*           field wkvp_site      like si_site
*           field wkvp_mfgr      like vp_mfgr
*           field wkvp_mfgr_part like vp_mfgr_part
*           field wkvp_q_date    like vp_q_date
*           field wkvp_vend_part like vp_vend_part
*           field wkvp_vend_lead like vp_vend_lead
*           field wkvp_um        like vp_um
*           field wkvp_vend      like vp_vend
*           field wkvp_vname     like ad_name
*           field wkvp_q_price   like vp_q_price
*           field wkvp_q_qty     like vp_q_qty
*           field wkvp_pr_list   like vp_pr_list.
****/

	 define {&new} shared workfile wkcmt_det
	    field wkcmt_site     like req_site
	    field wkcmt_indx     like cmt_indx
	    field wkcmt_seq      like cmt_seq
/*FO92*/    field wkcmt_cmmt     like cmt_cmmt /* . */
/*FO92*/    field wkcmt_ref      like cmt_ref
/*FO92*/    field wkcmt_type     like cmt_type
/*FO92*/    field wkcmt_print    like cmt_print
/*FO92*/    field wkcmt_lang     like cmt_lang .
