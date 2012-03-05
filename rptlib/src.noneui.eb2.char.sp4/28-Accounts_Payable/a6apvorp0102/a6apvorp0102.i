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
DEFINE {1} SHARED TEMP-TABLE tta6apvorp0102
    FIELD tta6apvorp0102_ap_vend LIKE ap_vend
    FIELD tta6apvorp0102_name AS CHARACTER
    FIELD tta6apvorp0102_ad_attn LIKE ad_attn
    FIELD tta6apvorp0102_ad_phone LIKE ad_phone
    FIELD tta6apvorp0102_ad_ext LIKE ad_ext
    FIELD tta6apvorp0102_ap_ref LIKE ap_ref
    FIELD tta6apvorp0102_vo_invoice LIKE vo_invoice
    FIELD tta6apvorp0102_vo_cr_terms LIKE vo_cr_terms
    FIELD tta6apvorp0102_vo_due_date LIKE vo_due_date
    FIELD tta6apvorp0102_et_age_amt LIKE ap_amt EXTENT 4
    FIELD tta6apvorp0102_et_vo_tot LIKE ap_amt
    FIELD tta6apvorp0102_hold AS CHARACTER
    FIELD tta6apvorp0102_ap_ex_rate LIKE ap_ex_rate
    FIELD tta6apvorp0102_ap_ex_rate2 LIKE ap_ex_rate
    FIELD tta6apvorp0102_ap_curr LIKE ap_curr
    FIELD tta6apvorp0102_ap_acct LIKE ap_acct
    FIELD tta6apvorp0102_ap_sub LIKE ap_sub
    FIELD tta6apvorp0102_ap_cc LIKE ap_cc
    FIELD tta6apvorp0102_ap_disc_acct LIKE ap_disc_acct
    FIELD tta6apvorp0102_ap_disc_sub LIKE ap_disc_sub
    FIELD tta6apvorp0102_ap_disc_cc LIKE ap_disc_cc
    .
/* SS - 20051229 - E */
