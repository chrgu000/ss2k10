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
DEFINE {1} SHARED TEMP-TABLE ttxxarcsrp0301
   FIELD ttxxarcsrp0301_ar_bill LIKE ar_bill
   FIELD ttxxarcsrp0301_ar_cust LIKE ar_cust
   FIELD ttxxarcsrp0301_ar_date LIKE ar_date
   FIELD ttxxarcsrp0301_ar_nbr LIKE ar_nbr
   FIELD ttxxarcsrp0301_ar_check LIKE ar_check
   FIELD ttxxarcsrp0301_ar_type LIKE ar_type
   FIELD ttxxarcsrp0301_type AS CHARACTER FORMAT "x(8)"
   FIELD ttxxarcsrp0301_ar_due_date LIKE ar_due_date
   FIELD ttxxarcsrp0301_ar_effdate LIKE ar_effdate
   FIELD ttxxarcsrp0301_amt_due LIKE ar_amt
   FIELD ttxxarcsrp0301_amt_open LIKE ar_amt
   FIELD ttxxarcsrp0301_contested AS CHARACTER FORMAT "x(1)"
   FIELD ttxxarcsrp0301_ar_curr LIKE ar_curr
   FIELD ttxxarcsrp0301_acct LIKE ar_acct
   FIELD ttxxarcsrp0301_sub LIKE ar_sub
   FIELD ttxxarcsrp0301_cc LIKE ar_cc
   FIELD ttxxarcsrp0301_ar_ex_rate LIKE ar_ex_rate
   FIELD ttxxarcsrp0301_ar_ex_rate2 LIKE ar_ex_rate2
   INDEX index1 ttxxarcsrp0301_ar_cust
   INDEX index2 ttxxarcsrp0301_ar_effdate ttxxarcsrp0301_ar_type
   INDEX index3 ttxxarcsrp0301_ar_effdate 
   INDEX index4 ttxxarcsrp0301_ar_cust ttxxarcsrp0301_ar_effdate 
   INDEX index5 ttxxarcsrp0301_acct
   INDEX index6 ttxxarcsrp0301_acct ttxxarcsrp0301_ar_effdate 
   INDEX index7 ttxxarcsrp0301_acct ttxxarcsrp0301_ar_type ttxxarcsrp0301_ar_effdate 
   INDEX index8 ttxxarcsrp0301_ar_bill
   INDEX index9 ttxxarcsrp0301_ar_bill ttxxarcsrp0301_ar_effdate 
   .
/* SS - 20070415.1 - E */
