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
DEFINE {1} SHARED TEMP-TABLE ttssrsrp010001
   field ttssrsrp010001_scx_po like scx_po
   field ttssrsrp010001_scx_line like scx_line
   field ttssrsrp010001_scx_part like scx_part
   field ttssrsrp010001_pod_vpart like pod_vpart
   field ttssrsrp010001_pod_um like pod_um
   field ttssrsrp010001_scx_shipfrom like scx_shipfrom
   field ttssrsrp010001_ad_name like ad_name
   field ttssrsrp010001_scx_shipto like scx_shipto
   field ttssrsrp010001_sch_rlse_id like sch_rlse_id
   
   field ttssrsrp010001_cmmts like poc_hcmmts
   field ttssrsrp010001_sch_cr_date like sch_cr_date
   field ttssrsrp010001_sch_cr_time like sch_cr_time
   field ttssrsrp010001_prior_disp_qty like sch_pcr_qty
   field ttssrsrp010001_sch_eff_start  like sch_eff_start
   field ttssrsrp010001_sch_pcs_date like sch_pcs_date
   field ttssrsrp010001_sch_eff_end like sch_eff_end
   
   field ttssrsrp010001_schd_date like schd_date
   field ttssrsrp010001_schd_time like schd_time
   field ttssrsrp010001_schd_interval like schd_interval
   field ttssrsrp010001_schd_reference like schd_reference
   field ttssrsrp010001_disp_qty like schd_upd_qty
   field ttssrsrp010001_schd_fc_qual like schd_fc_qual

   field ttssrsrp010001_scx_order like scx_order
   field ttssrsrp010001_po_buyer like po_buyer
   
   index index1 ttssrsrp010001_scx_po ttssrsrp010001_scx_line ttssrsrp010001_schd_date
   .
/* SS - 20050827 - E */
