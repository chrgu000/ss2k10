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
DEFINE {1} SHARED TEMP-TABLE ttssglutrrp01
field ttssglutrrp01_glt_ref like  glt_ref
field ttssglutrrp01_glt_date like glt_date
field ttssglutrrp01_glt_effdate like glt_effdate
field ttssglutrrp01_glt_userid like glt_userid
field ttssglutrrp01_glt_line like glt_line
field ttssglutrrp01_glt_acct like glt_acct
field ttssglutrrp01_glt_sub like glt_sub
field ttssglutrrp01_glt_cc like glt_cc
field ttssglutrrp01_glt_project like glt_project
field ttssglutrrp01_glt_entity like glt_entity
field ttssglutrrp01_glt_desc like glt_desc
field ttssglutrrp01_glt_curr like glt_curr
field ttssglutrrp01_glt_dy_code like glt_dy_code
field ttssglutrrp01_glt_dy_num like glt_dy_num
field ttssglutrrp01_glt_error like glt_error
field ttssglutrrp01_glt_unb like glt_unb
field ttssglutrrp01_glt_correction like glt_correction
field ttssglutrrp01_glt_ex_rate like glt_ex_rate 
field ttssglutrrp01_glt_ex_rate2 like glt_ex_rate2 
field ttssglutrrp01_glt_curr_amt like glt_curr_amt
index ttssglutrrp01_glt_ref_line is unique ttssglutrrp01_glt_ref ttssglutrrp01_glt_line
    .
/* SS - 20070415.1 - E */
