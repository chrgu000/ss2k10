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
DEFINE {1} SHARED TEMP-TABLE tta6socnrp0101
	field tta6socnrp0101_cncix_site like cncix_site
	field tta6socnrp0101_site_description like ad_name
	field tta6socnrp0101_cncix_so_nbr like cncix_so_nbr
	field tta6socnrp0101_cncix_sod_line like cncix_sod_line
	field tta6socnrp0101_cncix_cust like cncix_cust
	field tta6socnrp0101_cust_description like cm_sort
	field tta6socnrp0101_cncix_shipto like cncix_shipto
	field tta6socnrp0101_ship_description like si_desc
	field tta6socnrp0101_cncix_part like cncix_part
	field tta6socnrp0101_part_description like pt_desc1
	field tta6socnrp0101_cncix_po like cncix_po
	field tta6socnrp0101_max_aging_days like sod_max_aging_days
	field tta6socnrp0101_cncix_current_loc like cncix_current_loc
	field tta6socnrp0101_cncix_lotser like cncix_lotser
	field tta6socnrp0101_cncix_auth like cncix_auth
	field tta6socnrp0101_cncix_qty_stock like cncix_qty_stock
	field tta6socnrp0101_cncix_stock_um like cncix_stock_um
	field tta6socnrp0101_cncix_qty_ship like cncix_qty_ship
	field tta6socnrp0101_cncix_asn_shipper like cncix_asn_shipper
	field tta6socnrp0101_cncix_ship_date like cncix_ship_date
	field tta6socnrp0101_cncix_ref like cncix_ref
	field tta6socnrp0101_cncix_intransit like cncix_intransit
	field tta6socnrp0101_cncix_aged_date like cncix_aged_date
   .
/* SS - 20050827 - E */
