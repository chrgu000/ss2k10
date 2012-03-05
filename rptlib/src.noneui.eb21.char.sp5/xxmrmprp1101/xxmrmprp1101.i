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
DEFINE {1} SHARED TEMP-TABLE ttxxmrmprp1101
   field ttxxmrmprp1101_pt_part like pt_part
   field ttxxmrmprp1101_pt_desc1 like pt_desc1
   field ttxxmrmprp1101_pt_desc2 like pt_desc2
   field ttxxmrmprp1101_pt_buyer like pt_buyer
   field ttxxmrmprp1101_si_site like si_site
   field ttxxmrmprp1101_pt_um like pt_um
   field ttxxmrmprp1101_pt_ord_pol like pt_ord_pol
   field ttxxmrmprp1101_pt_ord_min like pt_ord_min
   field ttxxmrmprp1101_pt_ms like pt_ms
   field ttxxmrmprp1101_pt_ord_per like pt_ord_per
   field ttxxmrmprp1101_pt_ord_max like pt_ord_max
   field ttxxmrmprp1101_pt_plan_ord like pt_plan_ord
   field ttxxmrmprp1101_pt_ord_qty like pt_ord_qty
   field ttxxmrmprp1101_pt_ord_mult like pt_ord_mult
   field ttxxmrmprp1101_qty_oh like in_qty_oh
   field ttxxmrmprp1101_pt_iss_pol like pt_iss_pol
   field ttxxmrmprp1101_pt_sfty_stk like pt_sfty_stk
   field ttxxmrmprp1101_pt_mfg_lead like pt_mfg_lead
   field ttxxmrmprp1101_pt_yield_pct like pt_yield_pct
   field ttxxmrmprp1101_pt_pm_code like pt_pm_code
   field ttxxmrmprp1101_pt_sfty_time like pt_sfty_time
   field ttxxmrmprp1101_pt_pur_lead like pt_pur_lead
   field ttxxmrmprp1101_pt_insp_rqd like pt_insp_rqd
   field ttxxmrmprp1101_pt_insp_lead like pt_insp_lead
   field ttxxmrmprp1101_pt_timefence like pt_timefence
   field ttxxmrmprp1101_pt_cum_lead like pt_cum_lead
   field ttxxmrmprp1101_pt_bom_code like pt_bom_code
   
   field ttxxmrmprp1101_pt_mrp like pt_mrp
   
   field ttxxmrmprp1101_req as decimal extent 14
   field ttxxmrmprp1101_recpts as decimal extent 14
   field ttxxmrmprp1101_qoh as decimal extent 14
   field ttxxmrmprp1101_pl_recpts as decimal extent 14
   field ttxxmrmprp1101_ords as decimal extent 14

   INDEX index1 ttxxmrmprp1101_pt_part ttxxmrmprp1101_si_site
   .
/* SS - 20070415.1 - E */
