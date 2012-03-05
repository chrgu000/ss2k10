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
DEFINE {1} SHARED TEMP-TABLE tta6soivrp0901
   field tta6soivrp0901_ih_inv_nbr like ih_inv_nbr
   field tta6soivrp0901_ih_rev like ih_rev
   field tta6soivrp0901_ih_cust like ih_cust
   field tta6soivrp0901_name like ad_NAME
   field tta6soivrp0901_ih_po like ih_po
   field tta6soivrp0901_ih_ship LIKE ih_ship
   field tta6soivrp0901_ih_ship_date like ih_ship_date
   field tta6soivrp0901_inv_date like ih_inv_date
   field tta6soivrp0901_ih_slspsn like ih_slspsn
   field tta6soivrp0901_ih_curr like ih_curr
   field tta6soivrp0901_base_curr like ih_curr
   field tta6soivrp0901_ih_ex_rate like ih_ex_rate
   field tta6soivrp0901_ih_ex_rate2 like ih_ex_rate2
   field tta6soivrp0901_ih_exru_seq like ih_exru_seq
   field tta6soivrp0901_v_disp_line1 AS CHARACTER
   field tta6soivrp0901_v_disp_line2 AS CHARACTER
   field tta6soivrp0901_ih_rmks like ih_rmks
   field tta6soivrp0901_idh_nbr like idh_nbr
   field tta6soivrp0901_idh_line like idh_line
   field tta6soivrp0901_idh_part like idh_part
   field tta6soivrp0901_idh_um like idh_um
   field tta6soivrp0901_idh_qty_ord like idh_qty_ord
   field tta6soivrp0901_idh_qty_inv like idh_qty_inv
   field tta6soivrp0901_idh_bo_chg like idh_bo_chg
   field tta6soivrp0901_disp_curr AS CHARACTER
   field tta6soivrp0901_base_net_price AS DECIMAL
   field tta6soivrp0901_base_price AS DECIMAL
   field tta6soivrp0901_base_margin AS DECIMAL
   field tta6soivrp0901_idh_due_date like idh_due_date
   field tta6soivrp0901_idh_type like idh_type
   field tta6soivrp0901_ih_channel like ih_channel
   field tta6soivrp0901_ih_project like ih_project
   field tta6soivrp0901_idh_site like idh_site
   field tta6soivrp0901_idh_prodline like idh_prodline
   field tta6soivrp0901_idh_taxc like idh_taxc
   field tta6soivrp0901_idh_taxable like idh_taxable
   field tta6soivrp0901_idh_tax_in like idh_tax_in
   field tta6soivrp0901_idh_acct like idh_acct
   field tta6soivrp0901_idh_sub like idh_sub
   field tta6soivrp0901_idh_cc like idh_cc
   field tta6soivrp0901_idh_project like idh_project
   field tta6soivrp0901_ar_effdate like tr_effdate
   field tta6soivrp0901_ext_price AS DECIMAL
   field tta6soivrp0901_ext_margin AS DECIMAL
   field tta6soivrp0901_ext_tax AS DECIMAL
   field tta6soivrp0901_base_tax AS DECIMAL
   INDEX index1 IS UNIQUE tta6soivrp0901_ih_inv_nbr tta6soivrp0901_idh_nbr tta6soivrp0901_idh_line
    .
/* SS - 20070511.1 - E */
