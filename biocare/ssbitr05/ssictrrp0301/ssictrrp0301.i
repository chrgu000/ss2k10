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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 04/16/07  ECO: *SS - 20070416.1*  */
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

/* SS - 20070416.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE ttssictrrp0301
   field ttssictrrp0301_tr_effdate like tr_effdate
   field ttssictrrp0301_tr_trnbr like tr_trnbr
   field ttssictrrp0301_trgl_type like trgl_type
   field ttssictrrp0301_tr_nbr like tr_nbr
   field ttssictrrp0301_trgl_gl_ref like trgl_gl_ref
   field ttssictrrp0301_trgl_dr_acct like trgl_dr_acct
   field ttssictrrp0301_trgl_dr_sub like trgl_dr_sub
   field ttssictrrp0301_trgl_dr_cc like trgl_dr_cc
   field ttssictrrp0301_trgl_dr_proj like trgl_dr_proj
   field ttssictrrp0301_trgl_dr_amt like trgl_gl_amt
   field ttssictrrp0301_trgl_cr_acct like trgl_cr_acct
   field ttssictrrp0301_trgl_cr_sub like trgl_cr_sub
   field ttssictrrp0301_trgl_cr_cc like trgl_cr_cc
   field ttssictrrp0301_trgl_cr_proj like trgl_cr_proj
   field ttssictrrp0301_trgl_cr_amt like trgl_gl_amt
   field ttssictrrp0301_tr_part like tr_part
   field ttssictrrp0301_si_entity like si_entity
   field ttssictrrp0301_tr_rmks like tr_rmks
   field ttssictrrp0301_tr_line like tr_line
   field ttssictrrp0301_tr_site like tr_site
   field ttssictrrp0301_tr_prod_line like tr_prod_line
   field ttssictrrp0301_tr_lot like tr_lot
   field ttssictrrp0301_tr_date like tr_date
   field ttssictrrp0301_tr_type like tr_type
   field ttssictrrp0301_tr_loc like tr_loc
   field ttssictrrp0301_tr_qty_loc like tr_qty_loc
   field ttssictrrp0301_wo_part like wo_part
   INDEX index1 ttssictrrp0301_tr_trnbr
   INDEX index2 ttssictrrp0301_tr_part
   .
/* SS - 20070416.1 - E */
