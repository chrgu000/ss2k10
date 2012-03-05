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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 02/28/07  ECO: *SS - 20070228.1*  */
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 03/20/07  ECO: *SS - 20070320.1*  */
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

/* SS - 20070228.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE ttxxapvorp0401
   field ttxxapvorp0401_ap_vend like ap_vend
   field ttxxapvorp0401_name AS CHARACTER
   field ttxxapvorp0401_ad_attn like ad_attn
   field ttxxapvorp0401_ad_phone like ad_phone
   field ttxxapvorp0401_ad_ext like ad_ext

   field ttxxapvorp0401_voucherno AS CHARACTER
   field ttxxapvorp0401_invdate AS DATE
   field ttxxapvorp0401_effdate AS DATE
   field ttxxapvorp0401_duedate AS DATE
   field ttxxapvorp0401_vo_cr_terms like vo_cr_terms
   field ttxxapvorp0401_et_age_amt AS DECIMAL EXTENT 8
   field ttxxapvorp0401_et_base_amt AS DECIMAL
   field ttxxapvorp0401_hold AS CHARACTER

   field ttxxapvorp0401_invoice as character

   field ttxxapvorp0401_ap_ex_rate like ap_ex_rate
   field ttxxapvorp0401_ap_ex_rate2 like ap_ex_rate2
   field ttxxapvorp0401_ap_curr like ap_curr

   field ttxxapvorp0401_ap_acct like ap_acct
   field ttxxapvorp0401_ap_sub like ap_sub
   field ttxxapvorp0401_ap_cc like ap_cc

   field ttxxapvorp0401_et_curr_amt AS DECIMAL
   .
/* SS - 20070228.1 - E */
