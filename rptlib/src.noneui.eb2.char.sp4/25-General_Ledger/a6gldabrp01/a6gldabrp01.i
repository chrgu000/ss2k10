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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 08/27/05  ECO: *SS - 20050827*  */
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

                                                                                     /* SS - 20050827 - B */
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
DEFINE {1} SHARED TEMP-TABLE tta6gldabrp01
   field tta6gldabrp01_ref like gltr_ref
   field tta6gldabrp01_eff_dt like gltr_eff_dt
   field tta6gldabrp01_ent_dt like gltr_ent_dt
   field tta6gldabrp01_user like gltr_user
   field tta6gldabrp01_batch like gltr_batch
   field tta6gldabrp01_line like gltr_line
   field tta6gldabrp01_acc like gltr_acc
   field tta6gldabrp01_sub like gltr_sub
   field tta6gldabrp01_ctr like gltr_ctr
   field tta6gldabrp01_project like gltr_project
   field tta6gldabrp01_entity like gltr_entity
   field tta6gldabrp01_desc like gltr_desc
   field tta6gldabrp01_amt like gltr_amt
   field tta6gldabrp01_curramt like gltr_curramt
   field tta6gldabrp01_curr like gltr_curr
   field tta6gldabrp01_addr like gltr_addr
   field tta6gldabrp01_doc_typ like gltr_doc_typ
   field tta6gldabrp01_doc like gltr_doc
   .
/* SS - 20050827 - E */