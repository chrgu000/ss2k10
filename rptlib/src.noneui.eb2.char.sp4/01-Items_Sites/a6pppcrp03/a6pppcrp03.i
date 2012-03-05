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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 12/12/05  ECO: *SS - 20051212*  */
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

                                                                                     /* SS - 20051212 - B */
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
DEFINE {1} SHARED TEMP-TABLE tta6pppcrp03
   field tta6pppcrp03_list like pc_list
   field tta6pppcrp03_curr like pc_curr
   field tta6pppcrp03_prod_line like pc_prod_line
   field tta6pppcrp03_part like pc_part
   field tta6pppcrp03_um like pc_um
   field tta6pppcrp03_start like pc_start
   field tta6pppcrp03_expire like pc_expire
   field tta6pppcrp03_amt_type like pc_amt_type
   field tta6pppcrp03_glxcst AS DECIMAL
   field tta6pppcrp03_glxcst_ml AS DECIMAL
   field tta6pppcrp03_glxcst_ll AS DECIMAL
   field tta6pppcrp03_glxcst_bl AS DECIMAL
   field tta6pppcrp03_glxcst_ol AS DECIMAL
   field tta6pppcrp03_glxcst_sl AS DECIMAL
   field tta6pppcrp03_glxcst_mt AS DECIMAL
   field tta6pppcrp03_glxcst_lt AS DECIMAL
   field tta6pppcrp03_glxcst_bt AS DECIMAL
   field tta6pppcrp03_glxcst_ot AS DECIMAL
   field tta6pppcrp03_glxcst_st AS DECIMAL
   field tta6pppcrp03_desc1 like pt_desc1
   field tta6pppcrp03_desc2 like pt_desc2
   field tta6pppcrp03_pt_price like pt_price
   field tta6pppcrp03_amt like pc_amt
   field tta6pppcrp03_min_price like pc_min_price
   field tta6pppcrp03_max_price like pc_max_price
   field tta6pppcrp03_min_qty like pc_min_qty
   INDEX tta6pppcrp03_part tta6pppcrp03_part
   .
/* SS - 20051212 - E */
