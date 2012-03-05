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

/* SS - 100706.1 By: Bill Jiang */

/* SS - 100706.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE ttxxapvorp0002
   field ttxxapvorp0002_vo_ref like vo_ref
   field ttxxapvorp0002_ap_date like ap_date
   field ttxxapvorp0002_vd_remit like vd_remit
   field ttxxapvorp0002_ap_curr like ap_curr
   field ttxxapvorp0002_disp_curr as   character 
   field ttxxapvorp0002_ap_base_amt like ap_amt
   field ttxxapvorp0002_vopo as   character 
   field ttxxapvorp0002_ap_effdate like ap_effdate
   field ttxxapvorp0002_vo_ship like vo_ship
   field ttxxapvorp0002_curr_disp_line1 as character 
   field ttxxapvorp0002_ap_acct like ap_acct
   field ttxxapvorp0002_ap_sub like ap_sub
   field ttxxapvorp0002_ap_cc like ap_cc
   field ttxxapvorp0002_curr_disp_line2 as character 
   field ttxxapvorp0002_ap_vend like ap_vend
   field ttxxapvorp0002_vo_due_date like vo_due_date
   field ttxxapvorp0002_vo_invoice like vo_invoice
   field ttxxapvorp0002_ap_bank like ap_bank
   field ttxxapvorp0002_vo_ndisc_amt like vo_ndisc_amt
   field ttxxapvorp0002_name like ad_name
   field ttxxapvorp0002_vo_disc_date like vo_disc_date
   field ttxxapvorp0002_ap_entity like ap_entity
   field ttxxapvorp0002_vo_type like vo_type
   field ttxxapvorp0002_vo_applied like vo_applied
   field ttxxapvorp0002_flag as   character 
   field ttxxapvorp0002_ap_rmk like ap_rmk 
   field ttxxapvorp0002_ap_ckfrm like ap_ckfrm
   field ttxxapvorp0002_vo_confirmed like vo_confirmed
   field ttxxapvorp0002_vo_conf_by like vo_conf_by
   field ttxxapvorp0002_vo_hold_amt like vo_hold_amt
   field ttxxapvorp0002_vo_is_ers like vo_is_ers
   field ttxxapvorp0002_remit_label as character 
   field ttxxapvorp0002_remit_name like ad_name
   field ttxxapvorp0002_ap_batch like ap_batch
   field ttxxapvorp0002_vod_ln like vod_ln
   field ttxxapvorp0002_vod_acc like vod_acct
   field ttxxapvorp0002_vod_sub like vod_sub
   field ttxxapvorp0002_vod_cc like vod_cc
   field ttxxapvorp0002_vod_project like vod_project
   field ttxxapvorp0002_vod_entity like vod_entity
   field ttxxapvorp0002_vod_base_amt like vod_amt
   field ttxxapvorp0002_vod_desc like vod_desc
   field ttxxapvorp0002_ap_amt like ap_amt
   field ttxxapvorp0002_ap_ex_rate like ap_ex_rate
   field ttxxapvorp0002_ap_ex_rate2 like ap_ex_rate2
   field ttxxapvorp0002_vod_amt like vod_amt
   INDEX ttxxapvorp0002_vo_ref_vod_ln IS UNIQUE ttxxapvorp0002_vo_ref ttxxapvorp0002_vod_ln
   .
/* SS - 100706.1 - E */
