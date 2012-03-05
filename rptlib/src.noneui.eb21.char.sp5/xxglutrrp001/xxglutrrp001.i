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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 02/28/07  ECO: *SS - 090423.1*  */
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

/* SS - 090423.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE ttxxglutrrp001
   field ttxxglutrrp001_glt_ref like glt_det.glt_ref
   field ttxxglutrrp001_glt_date like glt_det.glt_date
   field ttxxglutrrp001_glt_userid like glt_det.glt_userid
   field ttxxglutrrp001_glt_effdate like glt_det.glt_effdate
   field ttxxglutrrp001_glt_line like glt_det.glt_line
   field ttxxglutrrp001_glt_acc like glt_det.glt_acc
   field ttxxglutrrp001_glt_sub like glt_det.glt_sub
   field ttxxglutrrp001_glt_cc like glt_det.glt_cc
   field ttxxglutrrp001_glt_project like glt_det.glt_project
   field ttxxglutrrp001_glt_entity like glt_det.glt_entity
   field ttxxglutrrp001_glt_desc like glt_det.glt_desc
   field ttxxglutrrp001_glt_amt like glt_det.glt_amt
   field ttxxglutrrp001_glt_curr like glt_det.glt_curr
   field ttxxglutrrp001_glt_dy_code like glt_det.glt_dy_code
   field ttxxglutrrp001_glt_error like glt_det.glt_error
   field ttxxglutrrp001_glt_dy_num like glt_det.glt_dy_num
   field ttxxglutrrp001_glt_unb like glt_det.glt_unb
   .
/* SS - 090423.1 - E */
