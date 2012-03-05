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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 04/14/06  ECO: *SS - 20060414*  */
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

/* SS - 20060414 - B */
/*
1. 基于A6SOIVRP0903.P,增加了以下字段的输出:IH_CURR
*/
/* SS - 20060414 - E */

                                                                                     /* SS - 20060414 - B */
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
DEFINE {1} SHARED TEMP-TABLE tta6soivrp0904
    field tta6soivrp0904_inv_nbr like ih_inv_nbr
    field tta6soivrp0904_nbr like ih_nbr
    field tta6soivrp0904_line like idh_line
    field tta6soivrp0904_cust like ih_cust
    field tta6soivrp0904_prodline like idh_prodline
    field tta6soivrp0904_part like idh_part
    field tta6soivrp0904_qty_inv like idh_qty_inv
    field tta6soivrp0904_ext_price AS DECIMAL
    field tta6soivrp0904_ext_margin AS DECIMAL
    field tta6soivrp0904_ext_tax AS DECIMAL
    field tta6soivrp0904_base_price AS DECIMAL
    field tta6soivrp0904_base_margin AS DECIMAL
    field tta6soivrp0904_base_tax AS DECIMAL
    field tta6soivrp0904_taxc like idh_taxc
    field tta6soivrp0904_acct like idh_acct
    field tta6soivrp0904_sub like idh_sub
    field tta6soivrp0904_cc like idh_cc
    field tta6soivrp0904_eff_dt like gltr_eff_dt
    field tta6soivrp0904_inv_date like ih_inv_date
    field tta6soivrp0904_ih_channel like ih_channel
    field tta6soivrp0904_idh_site like idh_site
    field tta6soivrp0904_ih_curr like ih_curr
    .
/* SS - 20060414 - E */
