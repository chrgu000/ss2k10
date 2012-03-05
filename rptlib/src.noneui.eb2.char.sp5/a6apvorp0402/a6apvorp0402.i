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
DEFINE {1} SHARED TEMP-TABLE tta6apvorp0402
   field tta6apvorp0402_ap_vend like ap_vend
   field tta6apvorp0402_name AS CHARACTER
   field tta6apvorp0402_ad_attn like ad_attn
   field tta6apvorp0402_ad_phone like ad_phone
   field tta6apvorp0402_ad_ext like ad_ext
   field tta6apvorp0402_voucherno AS CHARACTER
   field tta6apvorp0402_invdate AS DATE
   field tta6apvorp0402_effdate AS DATE
   field tta6apvorp0402_duedate AS DATE
   field tta6apvorp0402_vo_cr_terms like vo_cr_terms
   field tta6apvorp0402_et_age_amt AS DECIMAL EXTENT 4
   field tta6apvorp0402_et_base_amt AS DECIMAL
   field tta6apvorp0402_hold AS CHARACTER
   field tta6apvorp0402_ap_ex_rate like ap_ex_rate
   field tta6apvorp0402_ap_ex_rate2 like ap_ex_rate2
   field tta6apvorp0402_ap_curr like ap_curr
   field tta6apvorp0402_ap_acct like ap_acct
   field tta6apvorp0402_ap_sub like ap_sub
   field tta6apvorp0402_ap_cc like ap_cc
   .
/* SS - 20051229 - E */
