/* eB SP5 Linux US    Created By: Kaine Zhang 11/28/05 *eas051a* */

DEFINE VARIABLE strBomA		LIKE	wo_bom_code.
DEFINE VARIABLE strBomB		LIKE	wo_bom_code.
DEFINE VARIABLE strPartA	LIKE	pt_part.
DEFINE VARIABLE strPartB	LIKE	pt_part.
DEFINE VARIABLE strSiteA	LIKE	si_site.
DEFINE VARIABLE strSiteB	LIKE	si_site.
DEFINE VARIABLE strBuyer	LIKE	pt_buyer.
DEFINE VARIABLE strPdLn		LIKE	pt_prod_line.
DEFINE VARIABLE strPtGroup	LIKE	pt_group.
DEFINE VARIABLE strVendor	LIKE	pt_vend.
DEFINE VARIABLE strPMcode	LIKE	pt_pm_code.
DEFINE VARIABLE blnZero		LIKE	mfc_logical.
DEFINE VARIABLE blnReplace	LIKE	mfc_logical.
DEFINE VARIABLE datBg		AS		DATE.
DEFINE VARIABLE datEd		AS		DATE.

DEFINE VARIABLE datWeekEnd	AS		DATE.


DEFINE WORK-TABLE xtmrp_tmp
	FIELD xtmrp_part		LIKE	pt_part
	FIELD xtmrp_site		LIKE	si_site
	FIELD xtmrp_qty_oh		AS		DECIMAL		FORMAT "->>>>>>9.9<"
	FIELD xtmrp_req_ps		AS		DECIMAL		FORMAT "->>>>>>9.9<"
	FIELD xtmrp_recpts_ps	AS		DECIMAL		FORMAT "->>>>>>9.9<"
	FIELD xtmrp_pr_ps		AS		DECIMAL		FORMAT "->>>>>>9.9<"
	FIELD xtmrp_qoh_o		AS		DECIMAL		FORMAT "->>>>>>9.9<"
	FIELD xtmrp_reqwk		AS		DECIMAL		FORMAT "->>>>>>9.9<"	EXTENT 8
	FIELD xtmrp_reqmth		AS		DECIMAL		FORMAT "->>>>>>9.9<"	EXTENT 36
	FIELD xtmrp_podwk		AS		DECIMAL		FORMAT "->>>>>>9.9<"	EXTENT 8
	FIELD xtmrp_podmth		AS		DECIMAL		FORMAT "->>>>>>9.9<"	EXTENT 36
	FIELD xtmrp_qohwk		AS		DECIMAL		FORMAT "->>>>>>9.9<"	EXTENT 8
	FIELD xtmrp_qohmth		AS		DECIMAL		FORMAT "->>>>>>9.9<"	EXTENT 36
	FIELD xtmrp_prwk		AS		DECIMAL		FORMAT "->>>>>>9.9<"	EXTENT 8
	FIELD xtmrp_prmth		AS		DECIMAL		FORMAT "->>>>>>9.9<"	EXTENT 36
	FIELD xtmrp_rmks		AS		CHARACTER	FORMAT "x(375)"
	.
	
DEFINE WORK-TABLE xtps_mrp
	FIELD xtps_part			LIKE	pt_part
	FIELD xtps_site			LIKE	si_site
	FIELD xtps_qtyoh		LIKE	in_qty_oh	FORMAT "->>>>>>>>>>9.99"
	FIELD xtps_req			AS		DECIMAL		FORMAT "->>>>>>9.99"
	FIELD xtps_pod			AS		DECIMAL		FORMAT "->>>>>>>9.99"
	.