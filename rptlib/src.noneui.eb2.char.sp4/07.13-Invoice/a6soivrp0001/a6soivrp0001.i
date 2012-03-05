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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 05/11/07  ECO: *SS - 20070511.1*  */
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

                                                                                     /* SS - 20070511.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE tta6soivrp0001
	field tta6soivrp0001_so_inv_nbr like so_inv_nbr
	field tta6soivrp0001_so_bill like so_bill
	field tta6soivrp0001_bill_name like ad_name
	field tta6soivrp0001_so_cust like so_cust
	field tta6soivrp0001_name like ad_name
	field tta6soivrp0001_so_slspsn like so_slspsn
	field tta6soivrp0001_so_ar_acct like so_ar_acct
	field tta6soivrp0001_so_ar_sub like so_ar_sub
	field tta6soivrp0001_so_ar_cc like so_ar_cc

	field tta6soivrp0001_so_tax_env like so_tax_env
	field tta6soivrp0001_so_tax_usage like so_tax_usage

	field tta6soivrp0001_so_nbr like so_nbr
	field tta6soivrp0001_so_ship like so_ship
	field tta6soivrp0001_ship_name like ad_name
	field tta6soivrp0001_so_ord_date like so_ord_date
	field tta6soivrp0001_so_po like so_po

	field tta6soivrp0001_sod_line like sod_line
	field tta6soivrp0001_sod_part like sod_part
	field tta6soivrp0001_sod_um like sod_um
	field tta6soivrp0001_sod_acct like sod_acct
	field tta6soivrp0001_sod_sub like sod_sub
	field tta6soivrp0001_sod_cc like sod_cc
	field tta6soivrp0001_sod_qty_inv like sod_qty_inv
	field tta6soivrp0001_sod_taxable like sod_taxable
	field tta6soivrp0001_sod_taxc like sod_taxc
	field tta6soivrp0001_net_price like sod_price
	field tta6soivrp0001_ext_price as decimal label "Ext Price" format "->>>>,>>>,>>9.99"
	field tta6soivrp0001_ext_gr_margin like sod_price
	field tta6soivrp0001_desc1 like pt_desc1
	field tta6soivrp0001_qty_bo like sod_qty_ord
	field tta6soivrp0001_sod_tax_usage like sod_tax_usage
   INDEX index1 IS UNIQUE tta6soivrp0001_so_nbr tta6soivrp0001_sod_line
    .
/* SS - 20070511.1 - E */
