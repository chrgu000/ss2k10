/* aracdef.i - Common defs that are needed during the self-bill autocreate   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.3.1.4 $                                                         */
/*V8:ConvertModelikeReportAndMaintenance                                        */
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
DEFINE {1} SHARED TEMP-TABLE tta6soivrp0101 NO-UNDO
   field tta6soivrp0101_so_inv_nbr like so_inv_nbr
   field tta6soivrp0101_so_bill like so_bill
   field tta6soivrp0101_bill_name like ad_name
   field tta6soivrp0101_so_cust like so_cust
   field tta6soivrp0101_name like ad_name
   field tta6soivrp0101_so_slspsn like so_slspsn
   field tta6soivrp0101_so_ar_acct like so_ar_acct
   field tta6soivrp0101_so_ar_sub like so_ar_sub
   field tta6soivrp0101_so_ar_cc like so_ar_cc
   field tta6soivrp0101_so_tax_env like so_tax_env
   field tta6soivrp0101_so_tax_usage like so_tax_usage
   
   field tta6soivrp0101_so_nbr like so_nbr
   field tta6soivrp0101_so_ship like so_ship
   field tta6soivrp0101_ship_name like ad_name
   field tta6soivrp0101_so_ord_date like so_ord_date
   field tta6soivrp0101_so_po like so_po
   
   field tta6soivrp0101_nontaxable_amt as decimal
   field tta6soivrp0101_taxable_amt as decimal
   field tta6soivrp0101_so_curr  like so_curr 
   field tta6soivrp0101_line_total as decimal
   field tta6soivrp0101_so_disc_pct like so_disc_pct 
   field tta6soivrp0101_disc_amt as decimal
   field tta6soivrp0101_tax_date like so_tax_date 
   field tta6soivrp0101_user_desc like trl_desc extent 3
   field tta6soivrp0101_so_trl1_cd like so_trl1_cd
   field tta6soivrp0101_so_trl1_amt like so_trl1_amt 
   field tta6soivrp0101_so_trl2_cd like so_trl2_cd 
   field tta6soivrp0101_so_trl2_amt like so_trl2_amt
   field tta6soivrp0101_so_trl3_cd like so_trl3_cd 
   field tta6soivrp0101_so_trl3_amt like so_trl3_amt 
   field tta6soivrp0101_tax_amt as decimal 
   field tta6soivrp0101_ord_amt as decimal
   field tta6soivrp0101_container_charge as decimal
   field tta6soivrp0101_line_charge_total as decimal
   field tta6soivrp0101_invcrdt as character
   field tta6soivrp0101_et_line_total as decimal
   field tta6soivrp0101_et_disc_amt as decimal
   field tta6soivrp0101_et_trl1_amt as decimal
   field tta6soivrp0101_et_trl2_amt as decimal
   field tta6soivrp0101_et_trl3_amt as decimal
   field tta6soivrp0101_et_tax_amt as decimal
   field tta6soivrp0101_et_ord_amt as decimal
   
   field tta6soivrp0101_invtot_line_total as decimal
   field tta6soivrp0101_invtot_container as decimal
   field tta6soivrp0101_invtot_linecharge as decimal
   field tta6soivrp0101_invtot_disc_amt as decimal
   field tta6soivrp0101_invtot_trl1_amt like so_trl1_amt 
   field tta6soivrp0101_invtot_trl2_amt like so_trl2_amt
   field tta6soivrp0101_invtot_trl3_amt like so_trl3_amt 
   field tta6soivrp0101_invtot_tax_amt as decimal 
   field tta6soivrp0101_invtot_ord_amt as decimal
   
   field tta6soivrp0101_ettot_line_total as decimal
   field tta6soivrp0101_ettot_disc_amt as decimal
   field tta6soivrp0101_ettot_trl1_amt like so_trl1_amt 
   field tta6soivrp0101_ettot_trl2_amt like so_trl2_amt
   field tta6soivrp0101_ettot_trl3_amt like so_trl3_amt 
   field tta6soivrp0101_ettot_tax_amt as decimal 
   field tta6soivrp0101_ettot_ord_amt as decimal
   .
/* SS - 20050827 - E */
