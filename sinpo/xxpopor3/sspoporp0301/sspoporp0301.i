/* aracdef.i - Common defs that are needed during the self-bill autocreate   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.3.1.4 $                                                         */
/*V8:ConvertMode=ReportAndMaintenance                                        */
/* REVISION: 8.6E           CREATED: 08/18/98   BY: *K1DR* Suresh Nayak      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* $Revision: 1.3.1.4 $    BY: Katie Hilbert         DATE: 04/15/02  ECO: *P03J*  */
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 02/28/07  ECO: *SS - 20070415.1*  */
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

/* SS - 20070415.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE ttsspoporp0301 no-undo
   field ttsspoporp0301_billto as character extent 6
   field ttsspoporp0301_po_nbr like po_nbr
   field ttsspoporp0301_po_rev like po_rev
   field ttsspoporp0301_po_ord_date like po_ord_date
   field ttsspoporp0301_po_vend like po_vend
   field ttsspoporp0301_poship like po_ship
   field ttsspoporp0301_vendor as character extent 6
   field ttsspoporp0301_shipto as character extent 6
   field ttsspoporp0301_vdattn like ad_attn
   field ttsspoporp0301_po_confirm like po_confirm
   field ttsspoporp0301_vend_phone like ad_phone
   field ttsspoporp0301_po_buyer like po_buyer
   field ttsspoporp0301_po_contact like po_contact
   field ttsspoporp0301_po_cr_terms like po_cr_terms
   field ttsspoporp0301_po_shipvia like po_shipvia
   field ttsspoporp0301_terms like ct_desc
   field ttsspoporp0301_po_fob like po_fob
   field ttsspoporp0301_po_rmks like po_rmks
   field ttsspoporp0301_vatreg as character
   field ttsspoporp0301_l_tx_misc1 like ad_misc1_id
   field ttsspoporp0301_l_tx_misc2 like ad_misc2_id
   field ttsspoporp0301_l_tx_misc3 like ad_misc3_id
   
   field ttsspoporp0301_pod_line like pod_line
   field ttsspoporp0301_pod_part like pod_part
   field ttsspoporp0301_tax_flag as character
   field ttsspoporp0301_pod_due_date like pod_due_date
   field ttsspoporp0301_qty_open like pod_qty_ord
   field ttsspoporp0301_pod_um like pod_um
   field ttsspoporp0301_pod_pur_cost like pod_pur_cost
   field ttsspoporp0301_ext_cost like pod_pur_cost
   
   field ttsspoporp0301_po_so_nbr like po_so_nbr
   field ttsspoporp0301_pod_sod_line like pod_sod_line
   
   field ttsspoporp0301_pod_rev like pod_rev
   field ttsspoporp0301_discdesc as character
   
   field ttsspoporp0301_pod_site like pod_site
   
   field ttsspoporp0301_pod_vpart like pod_vpart
   
   field ttsspoporp0301_pod_type like pod_type
   
   field ttsspoporp0301_mfgr like vp_mfgr
   field ttsspoporp0301_mfgr_part like vp_mfgr_part
   
   field ttsspoporp0301_desc1 like pod_desc
   field ttsspoporp0301_desc2 like pt_desc2
   
   field ttsspoporp0301_pod_wip_lotser like pod_wip_lotser
   
   field ttsspoporp0301_c-cn-contract as character

   field ttsspoporp0301_nontaxable_amt as decimal
   field ttsspoporp0301_taxable_amt as decimal
   field ttsspoporp0301_po_curr like po_curr
   field ttsspoporp0301_lines_total as decimal
   field ttsspoporp0301_tax_date as date
   field ttsspoporp0301_tax_total as decimal
   field ttsspoporp0301_order_amt as decimal

   INDEX ttsspoporp0301_index1 IS UNIQUE 
   ttsspoporp0301_po_nbr
   ttsspoporp0301_pod_line
   .

DEFINE {1} SHARED TEMP-TABLE ttsspoporp03012 no-undo
   field ttsspoporp03012_po_nbr like po_nbr
   field ttsspoporp03012_nontaxable_amt as decimal
   field ttsspoporp03012_taxable_amt as decimal
   field ttsspoporp03012_po_curr like po_curr
   field ttsspoporp03012_lines_total as decimal
   field ttsspoporp03012_tax_date as date
   field ttsspoporp03012_tax_total as decimal
   field ttsspoporp03012_order_amt as decimal
   INDEX ttsspoporp03012_index1 IS UNIQUE 
   ttsspoporp03012_po_nbr
   .
/* SS - 20070415.1 - E */
