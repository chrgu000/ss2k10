/* aracdef.i - Common defs that are needed during the self-bill autocreate   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.3.1.4 $                                                         */
/*V8:ConvertMode=ReportAndMaintenance                                        */
/* REVISION: 8.6E           CREATED: 08/18/98   BY: *K1DR* Suresh Nayak      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* $Revision: 1.3.1.4 $    BY: Katie Hilbert         DATE: 04/15/02  ECO: *P03J*  */
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 08/27/05  ECO: *SS - 20050827*  */
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

                                                                                     /* SS - 20050827 - B */
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
DEFINE {1} SHARED TEMP-TABLE ttxxrsporp0001
   field ttxxrsporp0001_scx_po like scx_po
   field ttxxrsporp0001_scx_line like scx_line
   field ttxxrsporp0001_scx_part like scx_part
   /*
   field ttxxrsporp0001_pod_vpart like pod_vpart
   field ttxxrsporp0001_pod_um like pod_um
   */
   field ttxxrsporp0001_scx_shipfrom like scx_shipfrom
   field ttxxrsporp0001_ad_name like ad_name
   field ttxxrsporp0001_scx_shipto like scx_shipto
   field ttxxrsporp0001_po_ap_acct like po_ap_acct
   field ttxxrsporp0001_po_ap_sub like po_ap_sub
   field ttxxrsporp0001_po_ap_cc like po_ap_cc
   field ttxxrsporp0001_po_shipvia like po_shipvia
   field ttxxrsporp0001_po_taxable like po_taxable
   field ttxxrsporp0001_po_fob like po_fob
   field ttxxrsporp0001_po_cr_terms like po_cr_terms
   field ttxxrsporp0001_po_buyer like po_buyer
   field ttxxrsporp0001_po_bill like po_bill
   field ttxxrsporp0001_po_ship like po_ship
   field ttxxrsporp0001_po_contact like po_contact
   field ttxxrsporp0001_print_sch like mfc_logical
   field ttxxrsporp0001_po_contract like po_contract
   field ttxxrsporp0001_edi_sch like mfc_logical
   field ttxxrsporp0001_fax_sch like mfc_logical
   field ttxxrsporp0001_po_curr like po_curr
   field ttxxrsporp0001_pocmmts like mfc_logical
   field ttxxrsporp0001_po_site like po_site
   field ttxxrsporp0001_po_consignment like po_consignment
   field ttxxrsporp0001_impexp like mfc_logical
   field ttxxrsporp0001_pod_pr_list like pod_pr_list
   field ttxxrsporp0001_pod_cst_up like pod_cst_up
   field ttxxrsporp0001_pod_pur_cost like pod_pur_cost
   field ttxxrsporp0001_pod_acct like pod_acct
   field ttxxrsporp0001_pod_sub like pod_sub
   field ttxxrsporp0001_pod_cc like pod_cc
   field ttxxrsporp0001_pod_loc like pod_loc
   field ttxxrsporp0001_pod_taxable like pod_taxable
   field ttxxrsporp0001_pod_um like pod_um
   field ttxxrsporp0001_pod_um_conv like pod_um_conv
   field ttxxrsporp0001_pod_type like pod_type
   field ttxxrsporp0001_pod_consignment like pod_consignment
   field ttxxrsporp0001_pod_wo_lot like pod_wo_lot
   field ttxxrsporp0001_pod_op like pod_op
   field ttxxrsporp0001_subtype as character
   field ttxxrsporp0001_pod_firm_days like pod_firm_days
   field ttxxrsporp0001_pod_sd_pat like pod_sd_pat
   field ttxxrsporp0001_pod_plan_days like pod_plan_days
   field ttxxrsporp0001_pod_plan_weeks like pod_plan_weeks
   field ttxxrsporp0001_pod_cum_qty like pod_cum_qty
   field ttxxrsporp0001_pod_plan_mths like pod_plan_mths
   field ttxxrsporp0001_pod_ord_mult like pod_ord_mult
   field ttxxrsporp0001_pod_fab_days like pod_fab_days
   field ttxxrsporp0001_pod_cum_date like pod_cum_date
   field ttxxrsporp0001_pod_raw_days like pod_raw_days
   field ttxxrsporp0001_podcmmts like mfc_logical
   field ttxxrsporp0001_pod_sftylt_days like pod_sftylt_days
   field ttxxrsporp0001_pod_vpart like pod_vpart
   field ttxxrsporp0001_pod_translt_days like pod_translt_days
   field ttxxrsporp0001_pod_start_eff like pod_start_eff
   field ttxxrsporp0001_pod_end_eff like pod_end_eff
   field ttxxrsporp0001_pod_pkg_code like pod_pkg_code
   .
/* SS - 20050827 - E */
