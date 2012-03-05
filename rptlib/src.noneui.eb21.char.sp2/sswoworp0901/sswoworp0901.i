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
DEFINE {1} SHARED TEMP-TABLE ttsswoworp0901
    FIELD ttsswoworp0901_acct LIKE wo_acct
    FIELD ttsswoworp0901_sub LIKE wo_sub
    FIELD ttsswoworp0901_cc LIKE wo_cc
    FIELD ttsswoworp0901_project LIKE wo_project
    FIELD ttsswoworp0901_nbr LIKE wo_nbr
    FIELD ttsswoworp0901_lot LIKE wo_lot
    FIELD ttsswoworp0901_part LIKE wo_part
    FIELD ttsswoworp0901_site LIKE wo_site
    FIELD ttsswoworp0901_desc1 LIKE pt_desc1
    FIELD ttsswoworp0901_qty_ord LIKE wo_qty_ord
    FIELD ttsswoworp0901_qty_comp LIKE wo_qty_comp
    FIELD ttsswoworp0901_mtl_tot LIKE wo_mtl_tot
    FIELD ttsswoworp0901_lbr_tot LIKE wo_lbr_tot
    FIELD ttsswoworp0901_bdn_tot LIKE wo_bdn_tot
    FIELD ttsswoworp0901_sub_tot LIKE wo_sub_tot
    FIELD ttsswoworp0901_wip_tot LIKE wo_wip_tot
   FIELD ttsswoworp0901_avg_cost LIKE sct_cst_tot
   FIELD ttsswoworp0901_total_std LIKE wo_wip_tot
   FIELD ttsswoworp0901_qty_open LIKE wo_qty_comp
   FIELD ttsswoworp0901_batch LIKE wo_batch
   .
/* SS - 20070415.1 - E */
