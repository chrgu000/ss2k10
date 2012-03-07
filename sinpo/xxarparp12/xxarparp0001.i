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

/* SS - 100705.1 By: Bill Jiang */

/* SS - 100705.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE ttxxarparp0001
   field ttxxarparp0001_ar_batch like ar_batch
   field ttxxarparp0001_ar_check like ar_check
   field ttxxarparp0001_ar_bank like ar_bank
   field ttxxarparp0001_ar_po like ar_po
   field ttxxarparp0001_ar_type like ar_type
   field ttxxarparp0001_ar_date like ar_date
   field ttxxarparp0001_ar_entity like ar_entity
   field ttxxarparp0001_ar_acct like ar_acct
   field ttxxarparp0001_ar_sub like ar_sub
   field ttxxarparp0001_ar_cc like ar_cc
   field ttxxarparp0001_ar_bill like ar_bill
   field ttxxarparp0001_ad_name like ad_name
   field ttxxarparp0001_ex_rate_relation1 as character format "x(40)" 
   field ttxxarparp0001_ar_ex_rate like ar_ex_rate
   field ttxxarparp0001_ar_ex_rate2 like ar_ex_rate2
   field ttxxarparp0001_ar_effdate like ar_effdate
   field ttxxarparp0001_ar_disc_acct like ar_disc_acct
   field ttxxarparp0001_ar_disc_sub like ar_disc_sub
   field ttxxarparp0001_ar_disc_cc like ar_disc_cc
   field ttxxarparp0001_ex_rate_relation2 as character format "x(40)" 
   field ttxxarparp0001_ar_curr like ar_curr
   field ttxxarparp0001_ar_amt like ar_amt
   field ttxxarparp0001_ar_base_amt like ar_amt
   field ttxxarparp0001_ard_ref like ard_ref
   field ttxxarparp0001_ard_type like ard_type
   field ttxxarparp0001_ard_type_desc like ar_type format "X(6)"
   field ttxxarparp0001_ard_entity like ard_entity
   field ttxxarparp0001_ard_acct like ard_acct
   field ttxxarparp0001_ard_sub like ard_sub
   field ttxxarparp0001_ard_cc like ard_cc
   field ttxxarparp0001_disp_curr as character format "x(1)" 
   field ttxxarparp0001_ard_amt like ard_amt
   field ttxxarparp0001_ard_base_amt like ard_amt
   field ttxxarparp0001_ard_disc like ard_disc
   field ttxxarparp0001_ard_base_disc like ard_disc
   field ttxxarparp0001_aramt like ard_amt
   field ttxxarparp0001_base_aramt like ard_amt
   field ttxxarparp0001_unamt like ard_amt
   field ttxxarparp0001_base_unamt like ard_amt
   field ttxxarparp0001_nonamt like ard_amt
   field ttxxarparp0001_base_nonamt like ard_amt
   field ttxxarparp0001_ar_nbr like ar_nbr
   INDEX index1 ttxxarparp0001_ar_nbr
   .
/* SS - 100705.1 - E */
