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
DEFINE {1} SHARED TEMP-TABLE ttssapvorp0001
   field ttssapvorp0001_vo_ref like vo_ref
   field ttssapvorp0001_ap_date like ap_date
   field ttssapvorp0001_vd_remit like vd_remit
   field ttssapvorp0001_ap_curr like ap_curr
   field ttssapvorp0001_disp_curr as   character 
   field ttssapvorp0001_ap_amt like ap_amt
   field ttssapvorp0001_vopo as   character 
   field ttssapvorp0001_ap_effdate like ap_effdate
   field ttssapvorp0001_vo_ship like vo_ship
   field ttssapvorp0001_curr_disp_line1 as character 
   field ttssapvorp0001_ap_acct like ap_acct
   field ttssapvorp0001_ap_sub like ap_sub
   field ttssapvorp0001_ap_cc like ap_cc
   field ttssapvorp0001_curr_disp_line2 as character 
   field ttssapvorp0001_ap_vend like ap_vend
   field ttssapvorp0001_vo_due_date like vo_due_date
   field ttssapvorp0001_vo_invoice like vo_invoice
   field ttssapvorp0001_ap_bank like ap_bank
   field ttssapvorp0001_vo_ndisc_amt like vo_ndisc_amt
   field ttssapvorp0001_name like ad_name
   field ttssapvorp0001_vo_disc_date like vo_disc_date
   field ttssapvorp0001_ap_entity like ap_entity
   field ttssapvorp0001_vo_type like vo_type
   field ttssapvorp0001_vo_applied like vo_applied
   field ttssapvorp0001_flag as   character 
   field ttssapvorp0001_ap_rmk like ap_rmk 
   field ttssapvorp0001_ap_ckfrm like ap_ckfrm
   field ttssapvorp0001_vo_confirmed like vo_confirmed
   field ttssapvorp0001_vo_conf_by like vo_conf_by
   field ttssapvorp0001_vo_hold_amt like vo_hold_amt
   field ttssapvorp0001_vo_is_ers like vo_is_ers
   field ttssapvorp0001_remit_label as character 
   field ttssapvorp0001_remit_name like ad_name
   field ttssapvorp0001_ap_batch like ap_batch
   field ttssapvorp0001_vod_ln like vod_ln
   field ttssapvorp0001_vod_acc like vod_acct
   field ttssapvorp0001_vod_sub like vod_sub
   field ttssapvorp0001_vod_cc like vod_cc
   field ttssapvorp0001_vod_project like vod_project
   field ttssapvorp0001_vod_entity like vod_entity
   field ttssapvorp0001_vod_amt like vod_amt
   field ttssapvorp0001_vod_desc like vod_desc
    
   field ttssapvorp0001_prh_receiver like prh_receiver
   field ttssapvorp0001_prh_line like prh_line
   field ttssapvorp0001_prh_nbr like prh_nbr
   field ttssapvorp0001_prh_part like prh_part
   field ttssapvorp0001_prh_um like prh_um
   field ttssapvorp0001_prh_type like prh_type
   field ttssapvorp0001_prh_rcvd like prh_rcvd
   field ttssapvorp0001_inv_qty like vph_inv_qty
   field ttssapvorp0001_pur_amt AS DECIMAL
   field ttssapvorp0001_prh_curr like prh_curr
   field ttssapvorp0001_inv_amt AS DECIMAL
   field ttssapvorp0001_vo_curr like vo_curr
   field ttssapvorp0001_pvod_trans_qty as decimal /* like pvod_trans_qty */
   INDEX ttssapvorp0001_index1 IS UNIQUE 
   ttssapvorp0001_vo_ref
   ttssapvorp0001_prh_nbr
   ttssapvorp0001_prh_receiver 
   ttssapvorp0001_prh_line
   .
/* SS - 20070415.1 - E */
