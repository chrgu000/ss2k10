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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 10/25/05  ECO: *SS - 20051025*  */
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

                                                                                     /* SS - 20051025 - B */
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
DEFINE {1} SHARED TEMP-TABLE tta6woworp0506
   field tta6woworp0506_wo_nbr like wo_nbr
   field tta6woworp0506_wo_lot like wo_lot
   field tta6woworp0506_wo_batch like wo_batch
   field tta6woworp0506_wo_qty_ord like wo_qty_ord
   field tta6woworp0506_wo_ord_date like wo_ord_date
   field tta6woworp0506_glx_mthd like cs_method
   field tta6woworp0506_wo_part like wo_part
   field tta6woworp0506_desc1 like pt_desc1
   field tta6woworp0506_wo_qty_comp like wo_qty_comp
   field tta6woworp0506_wo_rel_date like wo_rel_date
   field tta6woworp0506_premsg as character
   field tta6woworp0506_wo_so_job like wo_so_job
   field tta6woworp0506_wo_qty_rjct like wo_qty_rjct
   field tta6woworp0506_wo_due_date like wo_due_date
   field tta6woworp0506_wo_vend like wo_vend
   field tta6woworp0506_wo_status like wo_status
   field tta6woworp0506_wo_rmks like wo_rmks
   field tta6woworp0506_wod_part like wod_part
   field tta6woworp0506_accqty like wod_qty_iss
   field tta6woworp0506_expcst like wod_mvrte_post
   field tta6woworp0506_acrvar like wod_mvuse_accr
   field tta6woworp0506_acccst like wod_mvrte_post
   field tta6woworp0506_rtevar like wod_mvrte_post
   field tta6woworp0506_usevar like wod_mvuse_post
   field tta6woworp0506_wowipx like wod_mvrte_post
   field tta6woworp0506_wipamt like wod_mvrte_post
   .
/* SS - 20051025 - E */
