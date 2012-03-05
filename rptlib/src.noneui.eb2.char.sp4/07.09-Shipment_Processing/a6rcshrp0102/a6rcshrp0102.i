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
DEFINE {1} SHARED TEMP-TABLE tta6rcshrp0102
   FIELD tta6rcshrp0102_abs_shipfrom LIKE ABS_shipfrom
   FIELD tta6rcshrp0102_abs_shipto LIKE ABS_shipto
   FIELD tta6rcshrp0102_abs_inv_mov LIKE ABS_inv_mov
   FIELD tta6rcshrp0102_abs_id LIKE ABS_id
   FIELD tta6rcshrp0102_abs_item LIKE ABS_item
   FIELD tta6rcshrp0102_shipper_po LIKE sod_contr_id
   FIELD tta6rcshrp0102_abs_site LIKE ABS_site
   FIELD tta6rcshrp0102_abs_order LIKE ABS_order
   FIELD tta6rcshrp0102_abs_line LIKE ABS_line
   FIELD tta6rcshrp0102_abs_qty LIKE ABS_qty
   FIELD tta6rcshrp0102_open_qty LIKE sod_qty_ord
   FIELD tta6rcshrp0102_due_date LIKE sod_due_date
   FIELD tta6rcshrp0102_abs_shp_date LIKE ABS_shp_date
   FIELD tta6rcshrp0102_slspsn LIKE so_slspsn
   FIELD tta6rcshrp0102_cust LIKE so_cust
   FIELD tta6rcshrp0102_ship LIKE so_ship
   FIELD tta6rcshrp0102_po LIKE so_po
   FIELD tta6rcshrp0102_abs_lotser LIKE ABS_lotser
   FIELD tta6rcshrp0102_ord_date LIKE so_ord_date
   FIELD tta6rcshrp0102_so_due_date LIKE so_due_date
   FIELD tta6rcshrp0102_trans_mode LIKE ABS__qad01
   FIELD tta6rcshrp0102_veh_ref LIKE ABS__qad01
   FIELD tta6rcshrp0102_dec02 LIKE ABS__dec02
   FIELD tta6rcshrp0102_pt_um LIKE pt_um
   FIELD tta6rcshrp0102_carrier LIKE absc_carrier
   FIELD tta6rcshrp0102_abs_arr_date LIKE ABS_arr_date
   FIELD tta6rcshrp0102_abs_cmtindx LIKE ABS_cmtindx
   INDEX tta6rcshrp0102_abs_id tta6rcshrp0102_abs_id
   .
/* SS - 20050827 - E */
