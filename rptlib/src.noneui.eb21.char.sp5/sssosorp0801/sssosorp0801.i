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
DEFINE {1} SHARED TEMP-TABLE ttsssosorp0801
   field ttsssosorp0801_so_nbr like so_nbr
   field ttsssosorp0801_so_cust like so_cust
   field ttsssosorp0801_name like ad_NAME
   field ttsssosorp0801_so_ship like so_ship
   field ttsssosorp0801_so_ord_date like so_ord_date
   field ttsssosorp0801_so_stat like so_stat
   field ttsssosorp0801_so_slspsn like so_slspsn
   field ttsssosorp0801_so_curr like so_curr
   field ttsssosorp0801_v_disp_line1 AS CHARACTER
   field ttsssosorp0801_v_disp_line2 AS CHARACTER
   field ttsssosorp0801_so_rmks like so_rmks
   field ttsssosorp0801_sod_line like sod_line
   field ttsssosorp0801_sod_part like sod_part
   field ttsssosorp0801_sod_um like sod_um
   field ttsssosorp0801_sod_qty_ord like sod_qty_ord
   field ttsssosorp0801_sod_qty_ship like sod_qty_ship
   field ttsssosorp0801_qty_open like sod_qty_ord
   field ttsssosorp0801_sod_confirm like sod_confirm
   field ttsssosorp0801_prt_curr like so_curr
   field ttsssosorp0801_base_price like sod_price
   field ttsssosorp0801_ext_price like sod_price
   field ttsssosorp0801_ext_gr_margin like sod_price
   field ttsssosorp0801_sod_due_date like sod_due_date
   field ttsssosorp0801_sod_type like sod_type
   field ttsssosorp0801_so_ex_rate like so_ex_rate
   field ttsssosorp0801_so_ex_rate2 like so_ex_rate2
   field ttsssosorp0801_so_exru_seq like so_exru_seq
   INDEX ttsssosorp0801_so_nbr_sod_line IS UNIQUE ttsssosorp0801_so_nbr ttsssosorp0801_sod_line
   .
/* SS - 20070415.1 - E */
