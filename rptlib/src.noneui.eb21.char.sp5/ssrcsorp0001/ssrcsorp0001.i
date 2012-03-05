/* aracdef.i - Common defs that are needed during the self-bill autocreate   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.3.1.4 $                                                         */
/*V8:ConvertMode=ReportAndMaintenance                                        */
/* REVISION: 8.6E           CREATED: 08/18/98   BY: *K1DR* Suresh Nayak      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* $Revision: 1.3.1.4 $    BY: Katie Hilbert         DATE: 04/15/02  ECO: *P03J*  */
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 02/28/07  ECO: *SS - 20070415.1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/* SS - 20070415.1 - B */
/*/*
define temp-table t_autocr
   field ac_sixrecid as recid
   field ac_sixselect      as logical label "*" format "*/"
   field ac_sopart         like six_sopart
   field ac_authorization  like six_authorization
   field ac_ship_id        like six_ship_id
   field ac_po             like six_po
   field ac_custref        like six_custref
   field ac_modelyr        like six_modelyr
   field ac_salesorder     like six_order
   index ac_partauth
         ac_sopart
         ac_authorization
   index ac_authpart
         ac_authorization
         ac_sopart
   index ac_shippart
         ac_ship_id
         ac_sopart
   index ac_popart
         ac_po
         ac_sopart
   index ac_sixrecid is unique
         ac_sixrecid.
*/
DEFINE {1} SHARED TEMP-TABLE rcsorp01
   field rcsorp01_scx_shipfrom like scx_shipfrom
   field rcsorp01_scx_order like scx_order
   field rcsorp01_scx_line like scx_line
   field rcsorp01_scx_shipto like scx_shipto
   field rcsorp01_ad_name like ad_name
   field rcsorp01_scx_part like scx_part
   field rcsorp01_l_desc1 like pt_desc1
   field rcsorp01_pt_um like pt_um
   field rcsorp01_scx_po like scx_po
   field rcsorp01_scx_custref like scx_custref
   field rcsorp01_sod_custpart like sod_custpart
   field rcsorp01_scx_modelyr like scx_modelyr
   field rcsorp01_so_ar_acct like so_ar_acct
   field rcsorp01_so_ar_sub like so_ar_sub
   field rcsorp01_so_ar_cc like so_ar_cc
   field rcsorp01_so_taxable like so_taxable
   field rcsorp01_so_taxc like so_taxc
   field rcsorp01_so_inv_auth like mfc_logical
   field rcsorp01_so_incl_iss like so_incl_iss
   field rcsorp01_so_wk_offset like ad_wk_offset
   field rcsorp01_so_cumulative like mfc_logical
   field rcsorp01_so_consignment like so_consignment
   field rcsorp01_so_bill like so_bill
   field rcsorp01_impexp like mfc_logical 
   field rcsorp01_so_shipvia like so_shipvia
   field rcsorp01_so_fob like so_fob
   field rcsorp01_so_translt_days like sod_translt_days
   field rcsorp01_socmmts like soc_hcmmts
   field rcsorp01_print_ih like mfc_logical 
   field rcsorp01_edi_ih like mfc_logical 
   field rcsorp01_so_print_pl like so_print_pl
   field rcsorp01_so_auto_inv like mfc_logical 
   field rcsorp01_so_site like so_site
   field rcsorp01_so_channel like so_channel
   field rcsorp01_so_bump_all like so_bump_all
   field rcsorp01_so_cum_acct like so_cum_acct
   field rcsorp01_so_curr like so_curr
   field rcsorp01_so_userid like so_userid
   field rcsorp01_so_seq_order like so_seq_order
   field rcsorp01_so_rmks like so_rmks
   field rcsorp01_so_custref_val like so_custref_val
   field rcsorp01_so_auth_days like so_auth_days
   field rcsorp01_so_ship_cmplt like so_ship_cmplt
   field rcsorp01_so_merge_rss like so_merge_rss
   field rcsorp01_so__qadl02 like so__qadl02
   field rcsorp01_so_inc_in_rss like so_inc_in_rss
   field rcsorp01_so_firm_seq_days like so_firm_seq_days
   field rcsorp01_sod_pr_list like sod_pr_list
   field rcsorp01_sod_list_pr like sod_list_pr
   field rcsorp01_sod_price like sod_price
   field rcsorp01_sod_acct like sod_acct
   field rcsorp01_sod_sub like sod_sub
   field rcsorp01_sod_cc like sod_cc
   field rcsorp01_sod_dsc_acct like sod_dsc_acct
   field rcsorp01_sod_dsc_sub like sod_dsc_sub
   field rcsorp01_sod_dsc_cc like sod_dsc_cc
   field rcsorp01_sod_taxable like sod_taxable
   field rcsorp01_sod_taxc like sod_taxc
   field rcsorp01_sod_consume like sod_consume
   field rcsorp01_sod_type like sod_type
   field rcsorp01_sod_loc like sod_loc
   field rcsorp01_sod_order_category like sod_order_category
   field rcsorp01_sod_consignment like sod_consignment
   field rcsorp01_sod_rbkt_days like sod_rbkt_days
   field rcsorp01_sod_dock like sod_dock
   field rcsorp01_sod_psd_pat like sch_sd_pat
   field rcsorp01_sod_rbkt_weeks like sod_rbkt_weeks
   field rcsorp01_sod_start_eff like sod_start_eff /* [1] */
   field rcsorp01_sod_psd_time like sch_sd_time
   field rcsorp01_sod_rbkt_mths like sod_rbkt_mths
   field rcsorp01_sod_end_eff like sod_end_eff /* [1] */
   field rcsorp01_sod_ssd_pat like sch_sd_pat
   field rcsorp01_sod_fab_days like sod_fab_days
   field rcsorp01_sod_cum_qty like sod_cum_qty /* [3] */
   field rcsorp01_sod_ssd_time like sch_sd_time
   field rcsorp01_sod_raw_days like sod_raw_days
   field rcsorp01_sod_ord_mult like sod_ord_mult
   field rcsorp01_sod_conrep like sod_conrep
   /*
   field rcsorp01_sod_custpart like sod_custpart
   */
   field rcsorp01_sod_cum_date like sod_cum_date /* [1] */
   field rcsorp01_sod_pkg_code like sod_pkg_code
   field rcsorp01_sod_alt_pkg like sod_alt_pkg
   field rcsorp01_sodcmmts like mfc_logical
   field rcsorp01_sod_charge_type like sod_charge_type
   .
/* SS - 20070415.1 - E */
