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
DEFINE {1} SHARED TEMP-TABLE ttsswoworp0502
   field ttsswoworp0502_wo_nbr like wo_nbr
   field ttsswoworp0502_wo_lot like wo_lot
   field ttsswoworp0502_wo_batch like wo_batch
   field ttsswoworp0502_wo_rmks like wo_rmks
   field ttsswoworp0502_wo_part like wo_part
   field ttsswoworp0502_wo_so_job like wo_so_job
   field ttsswoworp0502_wo_qty_ord like wo_qty_ord
   field ttsswoworp0502_wo_ord_date like wo_ord_date
   field ttsswoworp0502_glx_mthd AS CHARACTER
   field ttsswoworp0502_desc1 AS CHARACTER
   field ttsswoworp0502_wo_qty_comp like wo_qty_comp
   field ttsswoworp0502_wo_rel_date like wo_rel_date
   field ttsswoworp0502_premsg AS CHARACTER
   field ttsswoworp0502_wo_status like wo_status
   field ttsswoworp0502_wo_vend like wo_vend
   field ttsswoworp0502_wo_qty_rjct like wo_qty_rjct
   field ttsswoworp0502_wo_due_date like wo_due_date
   field ttsswoworp0502_mtl_expcst as decimal
   field ttsswoworp0502_mtl_acrvar as decimal
   field ttsswoworp0502_mtl_acccst as decimal
   field ttsswoworp0502_mtl_rtevar as decimal
   field ttsswoworp0502_mtl_usevar as decimal
   field ttsswoworp0502_mtl_wowipx as decimal
   field ttsswoworp0502_mtl_wipamt as decimal
   field ttsswoworp0502_lbr_expcst as decimal
   field ttsswoworp0502_lbr_acrvar as decimal
   field ttsswoworp0502_lbr_acccst as decimal
   field ttsswoworp0502_lbr_rtevar as decimal
   field ttsswoworp0502_lbr_usevar as decimal
   field ttsswoworp0502_lbr_wowipx as decimal
   field ttsswoworp0502_lbr_wipamt as decimal
   field ttsswoworp0502_bdn_expcst as decimal
   field ttsswoworp0502_bdn_acrvar as decimal
   field ttsswoworp0502_bdn_acccst as decimal
   field ttsswoworp0502_bdn_rtevar as decimal
   field ttsswoworp0502_bdn_usevar as decimal
   field ttsswoworp0502_bdn_wowipx as decimal
   field ttsswoworp0502_bdn_wipamt as decimal
   field ttsswoworp0502_sub_expcst as decimal
   field ttsswoworp0502_sub_acrvar as decimal
   field ttsswoworp0502_sub_acccst as decimal
   field ttsswoworp0502_sub_rtevar as decimal
   field ttsswoworp0502_sub_usevar as decimal
   field ttsswoworp0502_sub_wowipx as decimal
   field ttsswoworp0502_sub_wipamt as decimal
   INDEX index2 ttsswoworp0502_wo_lot
   INDEX index1 ttsswoworp0502_wo_nbr ttsswoworp0502_wo_lot
   .
/* SS - 20050827 - E */
