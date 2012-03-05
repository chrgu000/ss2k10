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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 12/29/05  ECO: *SS - 20051229*  */
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

                                                                                     /* SS - 20051229 - B */
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
DEFINE {1} SHARED TEMP-TABLE tta6apvniq0101
    field tta6apvniq0101_ap_ref like ap_ref
    field tta6apvniq0101_vo_invoice like vo_invoice
    field tta6apvniq0101_base_prepay like vo_prepay
    field tta6apvniq0101_ap_date like ap_date
    field tta6apvniq0101_vo_cr_terms like vo_cr_terms
    field tta6apvniq0101_base_amt like ap_amt
    field tta6apvniq0101_ap_effdate like ap_effdate
    field tta6apvniq0101_ap_entity like ap_entity
    field tta6apvniq0101_base_applied like vo_applied
    field tta6apvniq0101_ap_ex_rate like ap_ex_rate
    field tta6apvniq0101_ap_ex_rate2 like ap_ex_rate2
    field tta6apvniq0101_ap_curr like ap_curr
    field tta6apvniq0101_disp_curr as character 
    field tta6apvniq0101_ap_acct like ap_acct
    field tta6apvniq0101_ap_sub like ap_sub
    field tta6apvniq0101_ap_cc like ap_cc
    field tta6apvniq0101_ap_vend like ap_vend
    field tta6apvniq0101_vopo like vpo_po
    field tta6apvniq0101_ap_batch like ap_batch
    field tta6apvniq0101_vo_confirmed like vo_confirmed
    field tta6apvniq0101_vo_conf_by like vo_conf_by
    field tta6apvniq0101_vo_type like vo_type
    field tta6apvniq0101_ap_ckfrm like ap_ckfrm
    field tta6apvniq0101_base_hold_amt like vo_hold_amt
    .
/* SS - 20051229 - E */
