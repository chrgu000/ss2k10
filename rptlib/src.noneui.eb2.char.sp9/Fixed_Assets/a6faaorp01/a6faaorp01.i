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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 05/05/06  ECO: *SS - 20060505.1*  */
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 05/11/06  ECO: *SS - 20060511.1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060511.1 - B */
/*
1. 增加了以下字段的输出:FA_PURAMT
2. 执行列表:
   a6faaorp01.p
   a6faaorp01a.p
*/
/* SS - 20060511.1 - E */

/* SS - 20060505.1 - B */
/*
1. 标准输入输出
2. 执行列表:
   a6faaorp01.p
   a6faaorp01a.p
*/
/* SS - 20060505.1 - E */

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

                                                                                     /* SS - 20060505.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE tta6faaorp01
   field tta6faaorp01_fa_faloc_id like fa_faloc_id
   field tta6faaorp01_fa_id like fa_id
   field tta6faaorp01_fa_desc1 like fa_desc1
   field tta6faaorp01_fa_facls_id like fa_facls_id
   field tta6faaorp01_fabk_id like fab_fabk_id
   field tta6faaorp01_costAmt AS DECIMAL
   field tta6faaorp01_accDepr AS DECIMAL
   field tta6faaorp01_netBook AS DECIMAL
   field tta6faaorp01_annDepr AS DECIMAL
	/* SS - 20060511.1 - B */
   field tta6faaorp01_fa_puramt like fa_puramt
	/* SS - 20060511.1 - E */
   .
/* SS - 20060505.1 - E */
