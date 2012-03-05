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

/* 以下为版本历史 */
/* SS - 090227.1 By: Ellen Xu */
/* SS - 090227.1 - B 
禁用并保留标准代码,以便参考
/*
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
SS - 090227.1 - E */

/* SS - 090227.1 - B */
/* 定义共享的临时表.注意命名规范 */
DEFINE {1} SHARED TEMP-TABLE ttxxpoporp0101
	field ttxxpoporp0101_po_nbr like po_nbr
	field ttxxpoporp0101_po_vend like po_vend
	field ttxxpoporp0101_po_ship like po_ship
	field ttxxpoporp0101_po_ord_date like po_ord_date
	field ttxxpoporp0101_ad_name like ad_name
	field ttxxpoporp0101_ship_name like ad_name
	field ttxxpoporp0101_po_cr_terms like po_cr_terms
	field ttxxpoporp0101_ad_phone like ad_mstr.ad_phone
	field ttxxpoporp0101_ad_ext like ad_mstr.ad_ext
	field ttxxpoporp0101_ship_phone like ad_mstr.ad_phone
	field ttxxpoporp0101_ship_ext like ad_mstr.ad_ext
	field ttxxpoporp0101_po_buyer like po_buyer
	field ttxxpoporp0101_po_contact like po_contact
	field ttxxpoporp0101_po_rev like po_rev
	field ttxxpoporp0101_po_cls_date like po_cls_date
	field ttxxpoporp0101_po_stat like po_stat
	field ttxxpoporp0101_po_curr like po_curr
	field ttxxpoporp0101_po_blanket like po_blanket
	field ttxxpoporp0101_po_rel_nbr like po_rel_nbr
	field ttxxpoporp0101_l_currdisp1 as character
	field ttxxpoporp0101_l_currdisp2 as character
	field ttxxpoporp0101_po_rmks like po_rmks
	field ttxxpoporp0101_disp_curr as character
	field ttxxpoporp0101_pod_line like pod_line
	field ttxxpoporp0101_pod_req_nbr like pod_req_nbr
	field ttxxpoporp0101_pod_part like pod_part
	field ttxxpoporp0101_desc1 like pt_desc1
	field ttxxpoporp0101_desc2 like pt_desc1
	field ttxxpoporp0101_pod_um like pod_um
	field ttxxpoporp0101_pod_rev like pod_rev
        field ttxxpoporp0101_pod_ers_opt like pod_ers_opt
	field ttxxpoporp0101_pod_pr_lst_tp like pod_pr_lst_tp
	field ttxxpoporp0101_pod_vpart like pod_vpart
	field ttxxpoporp0101_pod_qty_ord like pod_qty_ord
	field ttxxpoporp0101_qty_open like pod_qty_ord
	field ttxxpoporp0101_base_cost like pod_pur_cost
	field ttxxpoporp0101_pod_disc_pct like pod_disc_pct
	field ttxxpoporp0101_ext_cost like pod_pur_cost
	field ttxxpoporp0101_pod_due_date like pod_due_date
	field ttxxpoporp0101_pod_wo_lot like pod_wo_lot
	field ttxxpoporp0101_pod_so_job like pod_so_job
	field ttxxpoporp0101_pod_status like pod_status
        .

DEFINE {1} SHARED TEMP-TABLE ttxxpoporp0101a
	field ttxxpoporp0101_po_nbr like po_nbr
	field ttxxpoporp0101_po_vend like po_vend
	field ttxxpoporp0101_po_ship like po_ship
	field ttxxpoporp0101_po_ord_date like po_ord_date
	field ttxxpoporp0101_ad_name like ad_name
	field ttxxpoporp0101_ship_name like ad_name
	field ttxxpoporp0101_po_cr_terms like po_cr_terms
	field ttxxpoporp0101_ad_phone like ad_mstr.ad_phone
	field ttxxpoporp0101_ad_ext like ad_mstr.ad_ext
	field ttxxpoporp0101_ship_phone like ad_mstr.ad_phone
	field ttxxpoporp0101_ship_ext like ad_mstr.ad_ext
	field ttxxpoporp0101_po_buyer like po_buyer
	field ttxxpoporp0101_po_contact like po_contact
	field ttxxpoporp0101_po_rev like po_rev
	field ttxxpoporp0101_po_cls_date like po_cls_date
	field ttxxpoporp0101_po_stat like po_stat
	field ttxxpoporp0101_po_curr like po_curr
	field ttxxpoporp0101_po_blanket like po_blanket
	field ttxxpoporp0101_po_rel_nbr like po_rel_nbr
	field ttxxpoporp0101_l_currdisp1 as character
	field ttxxpoporp0101_l_currdisp2 as character
	field ttxxpoporp0101_po_rmks like po_rmks
	field ttxxpoporp0101_disp_curr as character
	field ttxxpoporp0101_pod_line like pod_line
	field ttxxpoporp0101_pod_req_nbr like pod_req_nbr
	field ttxxpoporp0101_pod_part like pod_part
	field ttxxpoporp0101_desc1 like pt_desc1
	field ttxxpoporp0101_desc2 like pt_desc1
	field ttxxpoporp0101_pod_um like pod_um
	field ttxxpoporp0101_pod_rev like pod_rev
        field ttxxpoporp0101_pod_ers_opt like pod_ers_opt
	field ttxxpoporp0101_pod_pr_lst_tp like pod_pr_lst_tp
	field ttxxpoporp0101_pod_vpart like pod_vpart
	field ttxxpoporp0101_pod_qty_ord like pod_qty_ord
	field ttxxpoporp0101_qty_open like pod_qty_ord
	field ttxxpoporp0101_base_cost like pod_pur_cost
	field ttxxpoporp0101_pod_disc_pct like pod_disc_pct
	field ttxxpoporp0101_ext_cost like pod_pur_cost
	field ttxxpoporp0101_pod_due_date like pod_due_date
	field ttxxpoporp0101_pod_wo_lot like pod_wo_lot
	field ttxxpoporp0101_pod_so_job like pod_so_job
	field ttxxpoporp0101_pod_status like pod_status
        .
/* SS - 090227.1 - E */
