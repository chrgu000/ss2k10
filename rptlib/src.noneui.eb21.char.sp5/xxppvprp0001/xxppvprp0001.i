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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 12/12/05  ECO: *SS - 100401.1*  */
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

                                                                                     /* SS - 100401.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE ttxxppvprp0001
   field ttxxppvprp0001_vp_part like vp_part
   field ttxxppvprp0001_vp_vend like vp_vend
   field ttxxppvprp0001_vp_vend_part like vp_vend_part
   field ttxxppvprp0001_vp_um like vp_um
   field ttxxppvprp0001_vp_mfgr like vp_mfgr
   field ttxxppvprp0001_vp_mfgr_part like vp_mfgr_part
   field ttxxppvprp0001_vp_vend_lead like vp_vend_lead
   field ttxxppvprp0001_vp_q_date like vp_q_date
   field ttxxppvprp0001_vp_q_qty like vp_q_qty
   field ttxxppvprp0001_vp_q_price like vp_q_price
   field ttxxppvprp0001_vp_curr like vp_curr
   field ttxxppvprp0001_vp_pr_list like vp_pr_list
   field ttxxppvprp0001_vp_tp_use_pct like vp_tp_use_pct
   field ttxxppvprp0001_vp_tp_pct like vp_tp_pct
   field ttxxppvprp0001_pt_desc1 like pt_desc1
   field ttxxppvprp0001_pt_desc2 like pt_desc2
   index index1 ttxxppvprp0001_vp_part ttxxppvprp0001_vp_vend ttxxppvprp0001_vp_vend_part
   .
/* SS - 100401.1 - E */
