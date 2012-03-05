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
DEFINE {1} SHARED TEMP-TABLE ttssreworp0201
   field ttssreworp0201_wo_lot like wo_lot
   field ttssreworp0201_wo_routing like wo_routing
   field ttssreworp0201_wo_site like wo_site
   field ttssreworp0201_si_desc like si_desc
   field ttssreworp0201_wo_bom_code like wo_bom_code
   field ttssreworp0201_wo_part like wo_part
   field ttssreworp0201_pt_desc1 like pt_desc1
   field ttssreworp0201_wo_rel_date like wo_rel_date
   field ttssreworp0201_wo_line like wo_line
   field ttssreworp0201_ln_desc like ln_desc
   field ttssreworp0201_wo_due_date like wo_due_date
   field ttssreworp0201_wo_qty_ord like wo_qty_ord
   field ttssreworp0201_wostatus as character
   field ttssreworp0201_wr_op like wr_op
   field ttssreworp0201_wr_desc like wr_desc
   field ttssreworp0201_wr_setup like wr_setup
   field ttssreworp0201_iro_mtl_ll like iro_mtl_ll
   field ttssreworp0201_wr_wkctr like wr_wkctr
   field ttssreworp0201_wc_desc like wc_desc
   field ttssreworp0201_wr_setup_rte like wr_setup_rte
   field ttssreworp0201_iro_mtl_tl like iro_mtl_tl
   field ttssreworp0201_wr_mch like wr_mch
   field ttssreworp0201_wr_run like wr_run
   field ttssreworp0201_iro_lbr_ll like iro_lbr_ll
   field ttssreworp0201_wr_milestone like wr_milestone
   field ttssreworp0201_wr_lbr_rate like wr_lbr_rate
   field ttssreworp0201_iro_lbr_tl like iro_lbr_tl
   field ttssreworp0201_wr_mv_nxt_op like wr_mv_nxt_op
   field ttssreworp0201_wr_bdn_pct like wr_bdn_pct
   field ttssreworp0201_iro_bdn_ll like iro_bdn_ll
   field ttssreworp0201_wr_bdn_rate like wr_bdn_rate
   field ttssreworp0201_iro_bdn_tl like iro_bdn_tl
   field ttssreworp0201_wr_mch_bdn like wr_mch_bdn
   field ttssreworp0201_iro_sub_ll like iro_sub_ll
   field ttssreworp0201_wr_mch_op like wr_mch_op
   field ttssreworp0201_iro_sub_tl like iro_sub_tl
   field ttssreworp0201_wr_sub_cost like wr_sub_cost
   field ttssreworp0201_iro_cost_tot like iro_cost_tot
   field ttssreworp0201_wr_yield_pct like wr_yield_pct
   INDEX index1 ttssreworp0201_wo_lot ttssreworp0201_wr_op
   .
/* SS - 20050827 - E */
