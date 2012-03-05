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
/* $Revision: 1.3.1.4 $    BY: Bill Jiang         DATE: 12/29/05  ECO: *SS - 100705.1*  */
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

                                                                                     /* SS - 100705.1 - B */
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
DEFINE {1} SHARED TEMP-TABLE ttxxpoporp0601
   field ttxxpoporp0601_prh_nbr like prh_nbr
   field ttxxpoporp0601_prh_vend like prh_vend
   field ttxxpoporp0601_descname AS CHARACTER
   field ttxxpoporp0601_pj_project like pj_project
   field ttxxpoporp0601_pj_desc like pj_desc
   field ttxxpoporp0601_prh_receiver like prh_receiver
   field ttxxpoporp0601_prh_line like prh_line
   field ttxxpoporp0601_prh_part like prh_part
   field ttxxpoporp0601_prh_rcp_date like prh_rcp_date
   field ttxxpoporp0601_qty_open AS DECIMAL
   field ttxxpoporp0601_prh_rcp_type like prh_rcp_type
   field ttxxpoporp0601_std_cost AS DECIMAL
   field ttxxpoporp0601_disp_curr AS CHARACTER
   field ttxxpoporp0601_base_cost AS DECIMAL
   field ttxxpoporp0601_std_ext AS DECIMAL
   field ttxxpoporp0601_pur_ext AS DECIMAL
   field ttxxpoporp0601_std_var AS DECIMAL
   field ttxxpoporp0601_prh_ps_nbr like prh_ps_nbr
   field ttxxpoporp0601_prh_ps_qty like prh_ps_qty
   field ttxxpoporp0601_poders AS CHARACTER
   field ttxxpoporp0601_prh_ship_date like prh_ship_date
   field ttxxpoporp0601_tax_amt AS DECIMAL
   field ttxxpoporp0601_prh_curr like prh_curr
   field ttxxpoporp0601_base_curr like prh_curr
   field ttxxpoporp0601_ex_rate AS DECIMAL
   field ttxxpoporp0601_ex_rate2 AS DECIMAL
   field ttxxpoporp0601_pvoddet_exru_seq LIKE prh_exru_seq
   field ttxxpoporp0601_prh_curr_amt like prh_curr_amt
   field ttxxpoporp0601_prh_um_conv like prh_um_conv
   field ttxxpoporp0601_prh_pur_cost like prh_curr_amt
   field ttxxpoporp0601_prh_rcvd like prh_rcvd
   .
/* SS - 100705.1 - E */
