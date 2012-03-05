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

/* 以下为版本历史 */
/* SS - 090223.1 By: Amy Wu */
/* SS - 090223.1 - B
禁用并保留标准代码,以便参考
/*
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
SS - 090223.1 - E */

/* SS - 090223.1 - B */
/* 定义共享的临时表.注意命名规范 */
DEFINE {1} SHARED TEMP-TABLE ttxxrwdprp0001
   field ttxxrwdprp0001_dpt_dept like dpt_dept
   field ttxxrwdprp0001_dpt_desc  like dpt_desc 
   field ttxxrwdprp0001_dpt_lbr_cap  like dpt_lbr_cap 
   field ttxxrwdprp0001_dpt_cop_acct like dpt_cop_acct
   field ttxxrwdprp0001_dpt_lbr_acct like dpt_lbr_acct
   field ttxxrwdprp0001_dpt_bdn_acct like dpt_bdn_acct
   field ttxxrwdprp0001_dpt_lvar_acc like dpt_lvar_acc
   field ttxxrwdprp0001_dpt_lvrr_acc  like dpt_lvrr_acc 
   field ttxxrwdprp0001_dpt_bvar_acc  like dpt_bvar_acc 
   field ttxxrwdprp0001_dpt_bvrr_acc like dpt_bvrr_acc

   field ttxxrwdprp0001_dpt_cop_sub like dpt_cop_sub
   field ttxxrwdprp0001_dpt_lbr_sub like dpt_lbr_sub
   field ttxxrwdprp0001_dpt_bdn_sub like dpt_bdn_sub
   field ttxxrwdprp0001_dpt_lvar_sub like dpt_lvar_sub
   field ttxxrwdprp0001_dpt_lvrr_sub  like dpt_lvrr_sub 
   field ttxxrwdprp0001_dpt_bvar_sub  like dpt_bvar_sub 
   field ttxxrwdprp0001_dpt_bvrr_sub like dpt_bvrr_sub

   field ttxxrwdprp0001_dpt_cop_cc like dpt_cop_cc
   field ttxxrwdprp0001_dpt_lbr_cc like dpt_lbr_cc
   field ttxxrwdprp0001_dpt_bdn_cc like dpt_bdn_cc
   field ttxxrwdprp0001_dpt_lvar_cc like dpt_lvar_cc
   field ttxxrwdprp0001_dpt_lvrr_cc  like dpt_lvrr_cc 
   field ttxxrwdprp0001_dpt_bvar_cc  like dpt_bvar_cc 
   field ttxxrwdprp0001_dpt_bvrr_cc like dpt_bvrr_cc

   .
/* SS - 090223.1 - E */
