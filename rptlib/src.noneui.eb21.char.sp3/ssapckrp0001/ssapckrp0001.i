/* aracdef.i - Common defs that are needed during the self-bill autocreate   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.3.1.4 $                                                         */
/*V8:ConvertModelikeReportAndMaintenance                                        */
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
DEFINE {1} SHARED TEMP-TABLE ttssapckrp0001
   field ttssapckrp0001_ap_batch like ap_batch
   field ttssapckrp0001_ck_bank like ck_bank
   field ttssapckrp0001_ck_nbr like ck_nbr
   field ttssapckrp0001_ck_ref like ck_ref
   field ttssapckrp0001_ap_vend like ap_vend
   field ttssapckrp0001_name AS CHARACTER
   field ttssapckrp0001_ap_date like ap_date
   field ttssapckrp0001_ap_effdate like ap_effdate
   field ttssapckrp0001_ap_curr like ap_curr
   field ttssapckrp0001_ap_ex_rate like ap_ex_rate
   field ttssapckrp0001_ap_ex_rate2 like ap_ex_rate2
   field ttssapckrp0001_ap_entity like ap_entity
   field ttssapckrp0001_ap_acct like ap_acct
   field ttssapckrp0001_ap_sub like ap_sub
   field ttssapckrp0001_ap_cc like ap_cc
   field ttssapckrp0001_ckstatus AS CHARACTER
   field ttssapckrp0001_base_disp_amt AS DECIMAL
   field ttssapckrp0001_ap_entity1 like ap_entity
   field ttssapckrp0001_ckd_voucher like ckd_voucher
   field ttssapckrp0001_ckd_type like ckd_type
   field ttssapckrp0001_order AS CHARACTER
   field ttssapckrp0001_rmks AS CHARACTER
   field ttssapckrp0001_invoice AS CHARACTER
   field ttssapckrp0001_ckd_acct like ckd_acct
   field ttssapckrp0001_ckd_sub like ckd_sub
   field ttssapckrp0001_ckd_cc like ckd_cc
   field ttssapckrp0001_base_ckd_amt AS DECIMAL
   field ttssapckrp0001_base_disc AS DECIMAL
   
   field ttssapckrp0001_ap_disc_acct like ap_disc_acct
   field ttssapckrp0001_ap_disc_sub like ap_disc_sub
   field ttssapckrp0001_ap_disc_cc like ap_disc_cc
   field ttssapckrp0001_ap_rmk like ap_rmk
   field ttssapckrp0001_ck_voideff  like ck_voideff
   
   field ttssapckrp0001_ckd_amt like ckd_amt
   field ttssapckrp0001_ckd_disc like ckd_disc

   field ttssapckrp0001_disp_amt AS DECIMAL
    .
/* SS - 20070415.1 - E */
