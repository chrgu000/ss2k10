/* soivpst.i - POST INVOICES TO AR AND GL REPORT                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0      LAST MODIFIED: 11/21/91   BY: sas  F017*/
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458*/
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G047**/
/* REVISION: 7.3      LAST MODIFIED: 10/23/92   BY: afs *G230**/
/* REVISION: 7.3      LAST MODIFIED: 07/12/93   BY: dpm *GD33**/
/* REVISION: 7.3      LAST MODIFIED: 09/18/94   BY: dpm *FR54**/
/* REVISION: 7.3      LAST MODIFIED: 03/13/95   BY: jxz *F0M3**/
/* REVISION: 8.5      LAST MODIFIED: 01/31/96   BY: taf *J053**/


/* SS - 090707.1 By: Roger Xiao */



	 define {1} variable gl_sum           like mfc_logical
					      format "Consolidated/Detail"
					      initial yes.
	 define {1} variable ref              like   glt_ref.
	 define {1} variable ext_price        as decimal label "总价"
/*J053* /*G230*/                                      decimals 2    */
/*G230**                                      format "->>>>,>>9.99" */
/*G230*/                                      format "->>>>,>>>,>>9.99".
	 define {1} variable so_recno         as recid.
	 define {1} variable sod_recno        as recid.
	 define {1} variable eff_date         like ar_effdate.
/*F0M3   define {1} variable undo_all         like mfc_logical initial no.*/
/*F0M3*/ define {1} variable undo_all         like mfc_logical no-undo.
	 define {1} variable batch            like ar_batch.
/*FR54*  define {1} variable inv              like ar_nbr label "Invoice". */
/*FR54*  define {1} variable inv1             like ar_nbr label {t001.i}.  */
/*FR54*/ define {1} variable inv              like so_inv_nbr label "发票".
/*FR54*/ define {1} variable inv1             like so_inv_nbr label {t001.i}.
	 define {1} variable name             like ad_name.
	 define {1} variable qty_open         like sod_qty_ord.
	 define {1} variable gr_margin        like sod_price label "单位毛利"
					      format "->>>>,>>9.99".
	 define {1} variable ext_gr_margin    like gr_margin label "毛利合计".
	 define {1} variable desc1            like pt_desc1 format "x(49)".
	 define {1} variable inv_only         like mfc_logical initial yes.
	 define {1} variable qty_bo           like sod_qty_ord
					      label "欠交量".
	 define {1} variable dr_amt           as decimal
					      format "->>>,>>>,>>>.99"
					      label "借方金额".
	 define {1} variable cr_amt           as decimal
					      format "->>>,>>>,>>>.99"
					      label "贷方金额".
	 define {1} variable yn               like mfc_logical.
	 define {1} variable base_amt         like ar_amt.
	 define {1} variable exch_rate        like exd_rate.
	 define {1} variable base_price       like ext_price.
	 define {1} variable base_margin      like ext_gr_margin.
	 define {1} variable ext_list         like sod_list_pr.
/*J053* 	 decimals 2.  */
	 define {1} variable ext_disc         as decimal.
/*J053* 	 decimals 2.  */
	 define {1} variable ext_cost         like sod_price.
	 define {1} variable tot_ext_cost     like sod_price.
	 define {1} variable post             like mfc_logical.
	 define {1} variable print_lotserials like mfc_logical
				     label "列印交运料品的批/序号".
	 define {1} variable lotserial_total  like tr_qty_chg.
	 define {1} variable tot_line_disc    as decimal.
/*J053* 	 decimals 2.  */
	 define {1} variable curr_amt         like glt_amt.
	 define {1} variable tot_curr_amt     like glt_amt.
	 define {1} variable already_posted   like glt_amt.
	 define {1} variable should_be_posted like glt_amt.
	 define {1} variable net_price        like sod_price.
	 define {1} variable net_list         like sod_list_pr.
	 define {1} variable post_entity      like ar_entity.
/*F029*/ define {1} variable ent_exch         like exd_ent_rate.
/*F458   define {1} variable tax_date         like tax_effdate.  */
/*F458*/ define {1} variable tax_recno        as recid.
/*G047*/ define {1} variable cust             like so_cust.
/*G047*/ define {1} variable cust1            like so_cust.
/*G047*/ define {1} variable bill             like so_bill.
/*G047*/ define {1} variable bill1            like so_bill.
/*GD33*/ define {1} variable  batch_tot like glt_amt.


/* SS - 090707.1 - B */
    define {1} var v_inv_date       as date  label "发票日期".
    define {1} var v_inv_date1      as date  label "至".
    define {1} var v_slspsn         as char  label "推销员"  .
    define {1} var v_slspsn1        as char  label "至"  .
    define {1} var v_group          like pt_group label "组别".
    define {1} var v_group1         like pt_group label "至".
    define {1} var v_all_ok         as logical format "Yes/No" .

    define {1} var v_manager        as char . /*应始终设值为global_userid*/
    define {1} temp-table sls_det field sls_user as char .  /*for procedure get-sales-person-list*/


    define {1} var v_ii as integer .
    define {1} temp-table temp1 
        field t1_select  as char format "x(1)" 
        field t1_line    as char format "x(3)"
        field t1_inv_nbr like so_inv_nbr
        field t1_nbr     like so_nbr 
        field t1_bill    like so_bill
        field t1_name    like ad_name
        field t1_amt     as decimal format "->>,>>>,>>9.99" 
        field t1_curr    like so_curr 
        field t1_slspsn  as char  
        field t1_ok      as logical format "Y/N".


define {1} var v_yn1         as logical .
define {1} var v_yn2         as logical .
define {1} var v_print       as logical .
define {1} var v_print_file  as char .
define {1} var v_counter  as integer .
define {1} var choice  as logical initial no.
define {1} var first_sw_call as logical initial true no-undo.
define {1} var temp_recno  as recid                no-undo.
define {1} var l_error       as integer              no-undo.
define {1} var include_cons_ent as logical           no-undo.
define {1} var select_all    as logical              no-undo.


/* SS - 090707.1 - E */