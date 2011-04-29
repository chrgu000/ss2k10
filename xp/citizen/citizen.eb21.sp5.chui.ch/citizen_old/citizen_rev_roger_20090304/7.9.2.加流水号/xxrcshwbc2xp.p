/* rcshwbc2.p  - SHIPPER WORKBENCH - SUB PROGRAM - ADD ITEM                   */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.115.1.3 $                                                */
/* VERSION 7.5        LAST MODIFIED: 07/18/95           BY: GWM *J049*        */
/* VERSION 8.5        LAST MODIFIED: 04/12/96           BY: GWM *J0J1*        */
/* VERSION 8.5        LAST MODIFIED: 06/12/96           BY: GWM *J0R3*        */
/* VERSION 8.6        LAST MODIFIED: 08/01/96   BY: *K003* Vinay Nayak-Sujir  */
/* VERSION 8.6        LAST MODIFIED: 10/30/96   BY: *K003* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *K003* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 12/09/96   BY: *K022* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 01/24/97   BY: *K051* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 03/24/97   BY: *J1LY* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 05/09/97   BY: *K0CZ* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 06/12/97   BY: *K0DL* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 06/17/97   BY: *J1T4* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 06/27/97   BY: *K0FH* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 07/12/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 08/21/97   BY: *J1ZC* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 08/25/97   BY: *J1YJ* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 11/03/97   BY: *J22N* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 11/11/97   BY: *K18W* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 11/24/97   BY: *J26V* Manish Kulkarni    */
/* REVISION: 8.6      LAST MODIFIED: 11/24/97   BY: *K15N* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 01/28/98   BY: *J2CY* Manish Kulkarni    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/98   BY: *J2F2* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 04/06/98   BY: *J2CQ* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 04/12/98   BY: *J2J4* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *K1NF* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *J2LW* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *J2MH* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *J2NQ* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 07/17/98   BY: *J2QT* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 07/22/98   BY: *J2M7* Niranjan Ranka     */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2S5* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 08/11/98   BY: *K1VC* Dana Tunstall      */
/* REVISION: 9.0      LAST MODIFIED: 11/09/98   BY: *J33X* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 11/19/98   BY: *J34T* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *J35D* Manish Kulkarni    */
/* REVISION: 9.0      LAST MODIFIED: 01/06/99   BY: *K1YR* Raphael Thoppil    */
/* REVISION: 9.0      LAST MODIFIED: 01/12/99   BY: *J37V* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 02/02/99   BY: *J394* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 04/09/99   BY: *K20D* Anup Pereira       */
/* REVISION: 9.1      LAST MODIFIED: 06/23/99   BY: *N00F* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 08/18/99   BY: *K223* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 09/16/99   BY: *K21D* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 10/05/99   BY: *K21N* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 11/03/99   BY: *J3L5* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 11/27/99   BY: *N004* Patrick Rowan      */
/* REVISION: 9.1      LAST MODIFIED: 12/07/99   BY: *M0GG* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 12/20/99   BY: *L0M0* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 01/13/00   BY: *K23K* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 01/28/00   BY: *K21C* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 03/02/00   BY: *N03S* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Luke Pokic         */
/* REVISION: 9.1      LAST MODIFIED: 03/14/00   BY: *K23Q* Abhijeet Thakur    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 03/28/00   BY: *K25V* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *K250* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *L107* Ashwini Ghaisas    */
/* REVISION: 9.1      LAST MODIFIED: 07/05/00   BY: *N0F4* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 12/28/00   BY: *L13Y* Kaustubh Kulkarni  */
/* REVISION: 9.1      LAST MODIFIED: 10/06/00   BY: *N0WT* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 01/24/01   BY: *L14B* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 02/26/01   BY: *M12F* Rajaneesh Sarangi  */
/* Revision: 1.79       BY: Jean Miller            DATE: 03/22/01 ECO: *P008* */
/* Revision: 1.80       BY: Nikita Joshi           DATE: 04/19/01 ECO: *M15M* */
/* Revision: 1.81       BY: Rajesh Kini            DATE: 05/10/01 ECO: *M16B* */
/* Revision: 1.82       BY: Kaustubh Kulkarni      DATE: 05/28/01 ECO: *M18K* */
/* Revision: 1.83       BY: Russ Witt              DATE: 06/01/01 ECO: *P00J* */
/* Revision: 1.84       BY: Dan Herman             DATE: 07/09/01 ECO: *P007* */
/* Revision: 1.85       BY: Russ Witt              DATE: 07/20/01 ECO: *P011* */
/* Revision: 1.86       BY: Steve Nugent           DATE: 10/15/01 ECO: *P004* */
/* Revision: 1.87       BY: Ashwini Ghaisas        DATE: 11/09/01 ECO: *N160* */
/* Revision: 1.88       BY: Veena Lad              DATE: 11/30/01 ECO: *M1Q0* */
/* Revision: 1.89       BY: Mercy Chittilapilly    DATE: 01/24/02 ECO: *M1TT* */
/* Revision: 1.90       BY: Russ Witt              DATE: 02/04/02 ECO: *P04B* */
/* Revision: 1.91       BY: Katie Hilbert          DATE: 04/15/02 ECO: *P03J* */
/* Revision: 1.93       BY: Ashish Maheshwari      DATE: 07/17/02 ECO: *N1GJ* */
/* Revision: 1.94       BY: Samir Bavkar           DATE: 08/15/02 ECO: *P09K* */
/* Revision: 1.95       BY: Shoma Salgaonkar       DATE: 10/31/02 ECO: *N1YS* */
/* Revision: 1.97       BY: Paul Donnelly (SB)     DATE: 06/28/03 ECO: *Q00K* */
/* Revision: 1.98       BY: Rajinder Kamra         DATE: 05/05/03 ECO: *Q003* */
/* Revision: 1.99       BY: Manish Dani            DATE: 09/17/03 ECO: *N2L0* */
/* Revision: 1.101      BY: Paul Donnelly          DATE: 09/29/03 ECO: *Q03V* */
/* Revision: 1.102      BY: Rajesh Kini            DATE: 10/01/03 ECO: *P14G* */
/* Revision: 1.103      BY: Vinay Soman            DATE: 10/22/03 ECO: *N2M1* */
/* Revision: 1.104      BY: Vinay Soman            DATE: 10/27/03 ECO: *N2M8* */
/* Revision: 1.105      BY: Sandy Brown (OID)      DATE: 12/06/03 ECO: *Q04L* */
/* Revision: 1.107      BY: Robin McCarthy         DATE: 04/19/04 ECO: *P15V* */
/* Revision: 1.108      BY: Mandar Gawde           DATE: 05/17/04 ECO: *P1YF* */
/* Revision: 1.109      BY: Vinay Soman            DATE: 05/28/04 ECO: *P23X* */
/* Revision: 1.110      BY: Preeti Sattur          DATE: 06/23/04 ECO: *P25Z* */
/* Revision: 1.111      BY: Prashant Parab         DATE: 07/12/04 ECO: *Q0B9* */
/* Revision: 1.112      BY: Abhishek Jha           DATE: 07/23/04 ECO: *P2B9* */
/* Revision: 1.113      BY: Vivek Gogte            DATE: 07/28/04 ECO: *Q0BM* */
/* Revision: 1.114      BY: Vivek Gogte            DATE: 09/02/04 ECO: *Q0CQ* */
/* Revision: 1.115      BY: Shivanand H            DATE: 12/06/04 ECO: *P2Y9* */
/* Revision: 1.115.1.1  BY: Shivganesh Hegde       DATE: 03/07/05 ECO: *P3BN* */
/* Revision: 1.115.1.2  BY: Surajit Roy            DATE: 03/16/05 ECO: *P3C5* */
/* $Revision: 1.115.1.3 $   BY: Dan Herman            DATE: 09/07/05 ECO: *P40X* */


/* LAST MODIFIED: 2008/04/09   BY: Softspeed roger xiao   ECO: *xp001*   add:流水号v_nbr_cyl     */
/* LAST MODIFIED: 2008/06/16   BY: Softspeed roger xiao   ECO:*xp002* */  /*add:出货指示号*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gpoidfcn.i}  /* Defines nextOidValue() function */
{cxcustom.i "RCSHWBC2.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* INPUT PARAMETERS */
define input parameter absid       like abs_id no-undo.
define input parameter ship_from   as character.
define input parameter temp_parent as character.
define input parameter ship_to     as character.
define input parameter p_dock_id   as character no-undo.

/* OUTPUT PARAMETERS */
define output parameter abnormal_exit as logical.

/* SHARED VARIABLES TO CALL EXISTING CODE */
define new shared variable multi_entry   as logical no-undo.
define new shared variable cline         as character.
define new shared variable lotserial_control   like pt_lot_ser.
define new shared variable issue_or_receipt    as character.
define new shared variable total_lotserial_qty like sr_qty.
define new shared variable site          like sr_site no-undo.
define new shared variable location      like sr_loc no-undo.
define new shared variable lotserial     like sr_lotser no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable trans_um      like pt_um.
define new shared variable trans_conv    like sod_um_conv.
define new shared variable transtype     as character initial "ISS-SO".
define new shared variable lotref        like sr_ref no-undo.
define new shared variable cmtindx       like cmt_indx.
define new shared variable new_site      as character.
define new shared variable so_db         as character.
define new shared variable err_stat      as integer.

{rcinvtbl.i new}
{soabsdef.i new}
{rcexptbl.i new}

define shared variable ship_so      like so_nbr.
define shared variable ship_line    like sod_line.
define shared variable window_recid as   recid.
define shared variable global_recid as   recid.

/* LOCAL VARIABLES */
define var v_nbr_cyl1 as char format "x(20)" label "流水号" . /*xp001*/
define var v_nbr_cyl3 as char format "x(8)"  label "出货指示号" . /*xp002*/
define variable part_item         like pt_part
                                  label "Item Number" no-undo.
define variable part_site         like abs_site     no-undo.
define variable item_description  like pt_desc1 format "x(20)" no-undo.
define variable item_description_2 like pt_desc2 format "x(20)" no-undo.
define variable part_loc          like abs_loc      no-undo.
define variable part_wght         like pt_net_wt    no-undo.
define variable part_wt_um        like pt_net_wt_um no-undo.
define variable part_vol          like pt_size
                                  label "Volume"    no-undo.
define variable part_vol_um       like pt_size_um   no-undo.
define variable multiple          like mfc_logical
                                  label "Multi Entry" no-undo.
define variable nullstr           as character      no-undo.
define variable undotran          like mfc_logical  no-undo.
define variable i                 as integer        no-undo.
define variable part_qty          like sr_qty       no-undo.
define variable part_lot_ser      like abs_lot      no-undo.
define variable part_ref          like abs_ref
                                  label "Ref"       no-undo.
define variable qty_to_set        as integer        no-undo.
define variable qty_per           as integer        no-undo.
define variable qty_modulo        as integer        no-undo.
define variable part_qty_um       like pt_um        no-undo.
define variable part_qty_conv     like um_conv
                                  label "Conversion" no-undo.
define variable num_containers    as integer        no-undo.
define variable this_rec_qty      as integer        no-undo.
define variable part_po           like sod_contr_id
                                  label "Purchase Order" no-undo.
define variable part_order        like abs_order
                                  label "Sales Order" no-undo.
define variable part_order_line   like abs_line
                                  label "Line"      no-undo.
define variable error_flag        as integer        no-undo.
define variable ship_db           as character      no-undo.
define variable cons_ok           like mfc_logical  no-undo.
define variable shipgrp           like sgad_grp     no-undo.
define variable cmmts             like mfc_logical
                                  label "Comments"  no-undo.
define variable other_so          like so_nbr       no-undo.
define variable par_absid         like abs_id       no-undo.
define variable par_shipfrom      like abs_shipfrom no-undo.
define variable first_parent      like mfc_logical  no-undo.
define variable det_all           like mfc_logical
                                  label "Detail Alloc" no-undo.
define variable part_fa_lot       like wo_lot       no-undo.
define variable qty_ratio         like sod_qty_all  no-undo.
define variable totallqty         like sod_qty_all  no-undo.
define variable process_type      as integer        no-undo.
define variable kit_comp          like mfc_logical  no-undo.
define variable shp_canceled      like mfc_logical  no-undo.
define variable new_id            like abs_id       no-undo.
define variable errornum          as integer        no-undo.
define variable all_days          like soc_all_days no-undo.
define variable new_qty_all       like mfc_logical  no-undo.
define variable new_qty_set       like sod_qty_all  no-undo.
define variable ship_avail_qty    like mfc_logical
                                  label "Ship Avail Qty For Kit" no-undo.
define variable new_par_qty       like sod_qty_all  no-undo.
define variable cmf_flg           like mfc_logical  no-undo.
define variable adj_qty           like ld_qty_all   no-undo.
define variable stage_open        as logical initial no no-undo.
define variable this_rec_qty2     like abs_qty      no-undo.
define variable shipto_id         as character      no-undo.
define variable addr              as character      no-undo.
define variable del_lad           like mfc_logical  no-undo.

define variable l_abs_pick_qty    like sod_qty_pick no-undo.
define variable v_unpicked_qty    like sod_qty_pick no-undo.
define variable open_qty          like sod_qty_pick no-undo.
define variable l_sod_all         like sod_qty_all  no-undo.
define variable l_orig            like sod_qty_all  no-undo.
define variable l_abs_tot_tare_wt like abs_nwt      no-undo.
define variable l_abs_kit_tare_wt like abs_nwt      no-undo.
define variable l_abs_tot_net_wt  like abs_nwt      no-undo.
define variable l_pt_ship_wt      like pt_ship_wt   no-undo.
define variable l_recid           as   recid        no-undo.
define variable l_par_cont        like abs_id       no-undo.
define variable l_conv            as   decimal      no-undo.
define variable l_delproc         like mfc_logical  no-undo.
define variable l_prev_um         like pt_um        no-undo.
define variable l_errors          like mfc_logical  no-undo.
define variable lotnext           like wo_lot_next.
define variable lotprcpt          like wo_lot_rcpt  no-undo.
define variable line_recno        as recid          no-undo.
define variable disp-char6        as character      no-undo.
define variable disp-char8        as character      no-undo.
define variable ret-flag          as integer        no-undo.
define variable l_total_tare_wt   like abs_nwt      no-undo.
define variable l_total_net_wt    like abs_nwt      no-undo.
define variable l_sodall          like mfc_logical  no-undo.
define variable part_customer_ref like sod_custref  no-undo.
define variable part_model_year   like sod_modelyr  no-undo.
define variable use-log-acctg as logical no-undo.
define variable l_FrTermsErr like mfc_logical no-undo.
define variable l_FrTermsOnFirstOrder like so_fr_terms no-undo.
define variable l_wo_reject       like mfc_logical  no-undo.
define variable key1              as character      no-undo.
define variable ok_to_ship        as logical        no-undo.
define variable l_continue        like mfc_logical  no-undo.

define variable l_allowed         like mfc_logical  no-undo.
define variable parent_id         like abs_par_id   no-undo.
define variable l_item            as character      no-undo.
define variable l_lot             as character      no-undo.
define variable par_recid         as recid          no-undo.

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

{socnvars.i}   /* CONSIGNMENT VARIABLES */

/* TEMP-TABLES */
define new shared temp-table work_sr_wkfl like sr_wkfl.

{socnis.i}     /* CUSTOMER CONSIGNMENT SHIPMENT TEMP-TABLE DEFINITION */

/* BUFFERS */
define buffer parent_container for abs_mstr.
define buffer abs_buff for abs_mstr.
define buffer abs_tmp for abs_mstr.
define buffer abs_buff1 for abs_mstr.
define buffer abs_buff2 for abs_mstr.

FUNCTION prm-ssm-error-checking returns logical () forwards.

assign
   disp-char6 = getTermLabel("'FOR_REMOTE_INVENTORY'",30)
   disp-char8 = getTermLabel("'FOR_SALES_ORDERS'",30)
   issue_or_receipt = getTermLabel("ISSUE",8).

/* FORM FOR ADD CONTAINERS */
form 
   part_item         colon 25
   item_description  no-label
   part_po           colon 25
   part_customer_ref colon 25
   part_model_year   colon 25
   part_order        colon 25
   part_order_line
   skip(1)
   v_nbr_cyl1        colon 25 
   v_nbr_cyl3 skip(1) /*xp001*/ /*xp002*/ 

   part_qty          colon 25
   part_site         colon 54
   part_qty_um       colon 25
   part_loc          colon 54
   part_qty_conv     colon 25
   part_lot_ser      colon 54
   sod_type          colon 25
   part_ref          colon 54
   part_wght         colon 25
   part_wt_um        no-label
   multiple          colon 54
   part_vol          colon 25
   part_vol_um       no-label
   cmmts             colon 54
   part_fa_lot       colon 25
   det_all           colon 54
   ship_avail_qty    colon 54
   skip(1)
with frame a width 80 side-labels
title color normal (getFrameTitle("ITEM_INFORMATION",24)) attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DETERMINE IF CONTAINER AND LINE CHARGES IS ENABLED */
{cclc.i}

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_CUSTOMER_CONSIGNMENT,
           input 10,
           input ADG,
           input CUST_CONSIGN_CTRL_TABLE,
           output using_cust_consignment)"}

/* INITIALIZE CENTRAL DOMAIN NAME */
assign
   so_db = global_db
   abnormal_exit = true
   l_delproc = no
   cline = global_db + "rcshwbc2.p".

for first fac_ctrl
   fields (fac_domain fac_wo_rec)
   where   fac_domain = global_domain
no-lock: end.

find first soc_ctrl
   where soc_domain = global_domain
no-lock no-error.

assign
   det_all = soc_det_all
   all_days = soc_all_days
   shp_canceled = no.

/* ADD OR CREATE CONTAINERS */
main:
do on endkey undo main, leave main
   on error undo main, retry main:

   /* ADDING A KIT COMPONENT - DISPLAY PARENT'S ORDER # & LINE */
   kit_comp = no.
   if absid begins "I" then

   /* FIND SHIPPER MASTER RECORD USING SHIP-FROM ID AND ID TO  */
   /* IMPROVE PERFORMANCE                                      */
   for first abs_mstr
      fields (abs_domain abs_canceled abs_cmtindx abs_cons_ship abs_dataset
              abs_fa_lot abs_format abs_gwt abs_id abs_item abs_lang
              abs_line abs_loc abs_lotser abs_nwt abs_order
              abs_par_id abs_qty abs_ref abs_shipfrom abs_shipto
              abs_ship_qty abs_shp_date abs_site abs_status abs_type
              abs_vol abs_vol_um abs_wt_um abs__qad01 abs__qad02
              abs__qad03 abs__qad06 abs__qad10)
      where   abs_domain = global_domain
      and     abs_shipfrom = ship_from
      and     abs_id       = absid
   no-lock:

      display
         abs_order @ part_order
         abs_line  @ part_order_line
      with frame a.

      assign
         part_order      = abs_order
         part_order_line = abs_line
         kit_comp        = yes.
   end.

   set
      part_item
      part_po
      part_customer_ref
      part_model_year
      part_order      when (not kit_comp)
      part_order_line when (not kit_comp)
   with frame a editing:

      if frame-field = "part_item" then do:
         {mfnp.i sod_det
            part_item
             "sod_domain = global_domain and sod_part "
            part_item
            sod_part
            sod_part}

         if recno <> ? then
            display
               sod_part     @ part_item
               sod_contr_id @ part_po
               sod_custref  @ part_customer_ref
               sod_modelyr  @ part_model_year
               sod_nbr          when (not kit_comp) @ part_order
               part_order       when (kit_comp)
               string(sod_line) when (not kit_comp) @ part_order_line
               part_order_line  when (kit_comp)
            with frame a.

      end. /* IF FRAME-FIELD = "part_item" */
      else do:
         readkey.
         apply lastkey.
      end.

      if window_recid <> ?
      then do:
         for first sod_det
            fields(sod_btb_type  sod_cfg_type sod_confirm sod_consignment
                   sod_contr_id  sod_cum_qty  sod_custref sod_desc
                   sod_dock      sod_domain   sod_end_eff  sod_fa_nbr  sod_line
                   sod_loc       sod_lot      sod_modelyr sod_nbr
                   sod_part      sod_pickdate sod_qty_all sod_qty_ord
                   sod_qty_pick  sod_qty_ship sod_sched   sod_site
                   sod_start_eff sod_type     sod_um      sod_um_conv)
            where recid(sod_det) = window_recid
         no-lock:
            display
               sod_part     @ part_item
               sod_contr_id @ part_po
               sod_custref  @ part_customer_ref
               sod_modelyr  @ part_model_year
               sod_nbr      @ part_order
               sod_line     @ part_order_line
            with frame a.
         end. /* FOR FIRST SOD_DET */

         window_recid = ?.

      end.  /* IF WINDOW_RECID <> ? */

   end. /* set with editing */

   /* THIS PROCEDURE UPDATES THE SHIP-VIA AND FOB FOR A SHIPPER */
   run p_upd_ship_fob
      (input temp_parent,
       input part_order).

   if (part_order_line <> "") then
      part_order_line = left-trim(part_order_line).

   if prm-ssm-error-checking() then
      undo main, retry main.

   /* VALIDATE IF VALID SALES ORDER LINE */
   for first sod_det
      fields(sod_btb_type  sod_cfg_type sod_confirm sod_consignment
             sod_contr_id  sod_cum_qty  sod_custref sod_desc
             sod_dock      sod_domain   sod_end_eff  sod_fa_nbr  sod_line
             sod_loc       sod_lot      sod_modelyr sod_nbr
             sod_part      sod_pickdate sod_qty_all sod_qty_ord
             sod_qty_pick  sod_qty_ship sod_sched   sod_site
             sod_start_eff sod_type     sod_um      sod_um_conv)
      where sod_domain = global_domain
      and   sod_nbr = part_order
      and   string(sod_line) = part_order_line
   no-lock: end.

   /* CHECK IF WORK ORDER IS RELEASED OR ALLOCATED */
   /* FOR ATO CONFIGURED ITEMS                     */
   if available sod_det then do:

      l_wo_reject = no.

      if sod_lot <> "" then do:

         for first wo_mstr
            fields (wo_domain wo_lot wo_nbr wo_status)
            where   wo_domain = global_domain
            and     wo_lot    = sod_lot
         no-lock: end.

         if available wo_mstr
            and lookup(wo_status, "A,R,C") = 0
         then
            l_wo_reject = yes.

      end. /* IF sod_lot <> "" */
      else do:

         if sod_fa_nbr <> "" then do:

            for first wo_mstr
               fields (wo_domain wo_lot wo_nbr wo_status)
               where   wo_domain = global_domain
               and     wo_nbr = sod_fa_nbr
               and     lookup(wo_status, "A,R,C") = 0
            no-lock: end.

            if available wo_mstr then
               l_wo_reject = yes.

         end. /* IF sod_fa_nbr <> "" */

      end. /* ELSE */

      if l_wo_reject = yes then do:

         /* WORK ORDER ID IS CLOSED, PLANNED OR */
         /* FIRM PLANNED                        */
         run DisplayMessage(input 523,
                            input 3,
                            input '',
                            input '').

         /* CURRENT WORK ORDER STATUS: */
         run DisplayMessage(input 525,
                            input 1,
                            input wo_status,
                            input '').

         undo main, retry main.

      end. /* IF l_wo_reject = yes */

   end. /* IF AVAILABLE sod_det */

   if available sod_det
      and sod_btb_type = "03"
   then do:
      /* SHIPMENT NOT ALLOWED FOR DIR-SHIP EMT SALES ORDER */
      run DisplayMessage (input 3985,
                          input 3,
                          input '',
                          input '').
      undo MAIN, retry MAIN.
   end. /* IF AVAILABLE sod_det AND sod_btb_type = "03" */

   if not available sod_det then do:

      /* TRY THE PART, PO, CUSTREF, AND MODEL YEAR COMBINATION */
      for first sod_det
         fields(sod_btb_type  sod_cfg_type sod_confirm sod_consignment
                sod_contr_id  sod_cum_qty  sod_custref sod_desc
                sod_dock      sod_domain   sod_end_eff  sod_fa_nbr  sod_line
                sod_loc       sod_lot      sod_modelyr sod_nbr
                sod_part      sod_pickdate sod_qty_all sod_qty_ord
                sod_qty_pick  sod_qty_ship sod_sched   sod_site
                sod_start_eff sod_type     sod_um      sod_um_conv)
          where  sod_domain = global_domain
          and    sod_part   = part_item
          and    sod_part     <> ""
          and    sod_contr_id =  part_po
          and    sod_contr_id <> ""
          and    sod_custref  = part_customer_ref
          and    sod_modelyr  = part_model_year
      no-lock:
         if not kit_comp then
            assign
               part_order = sod_nbr
               part_order_line = string(sod_line).
      end.

      if not available sod_det then do:
         /* SALES ORDER LINE DOES NOT EXIST */
         run mess-764.
         undo main, retry main.
      end.

   end. /* IF NOT AVAILABLE SOD_DET */

   /* ALLOW ADDING A KIT COMPONENT TO A KIT PARENT SHIPPER */
   /* INPUT PART NUMBER IS REQUIRED FOR KIT COMPONENT      */
   if available abs_mstr
      and absid begins "I"
   then do:
      if part_item = "" then do:
         /* BLANK NOT ALLOWED  */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         next-prompt part_item with frame a.
         undo main, retry main.
      end.

      if (abs_item = part_item) then do:
         /* CYCLIC RELATIONSHIP NOT ALLOWED */
         {pxmsg.i &MSGNUM=599 &ERRORLEVEL=3}
         next-prompt part_item with frame a.
         undo main, retry main.
      end.
   end.

   /* FIND SHIPPER MASTER RECORD USING SHIP-FROM ID AND ID TO  */
   /* IMPROVE PERFORMANCE                                      */
   for first abs_mstr
      fields (abs_domain abs_canceled abs_cmtindx abs_cons_ship abs_dataset
              abs_fa_lot abs_format abs_gwt abs_id abs_item abs_lang
              abs_line abs_loc abs_lotser abs_nwt abs_order abs_par_id
              abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
              abs_shp_date abs_site abs_status abs_type abs_vol
              abs_vol_um abs_wt_um abs__qad01 abs__qad02 abs__qad03
              abs__qad06 abs__qad10)
      where abs_domain = global_domain
      and   abs_shipfrom = ship_from
      and   abs_id       = absid
   no-lock:

      /* If shipper consolidation is no, then check whether we
       * are putting more than one SO on the shipper */
      if abs_cons_ship = "0" then do:
         run chk_abs_shp_cons
            (input abs_id,
             input abs_shipfrom,
             input "",
             input "",
             input part_order,
             output cons_ok,
             output other_so).

         if not cons_ok then do:
            /*SHIPPER REFERENCES SALES ORDER #. CONSOLIDATION NOT PERMITTED*/
            {pxmsg.i &MSGNUM=5825 &ERRORLEVEL=3 &MSGARG1=other_so}
            next-prompt part_order with frame a.
            undo main, retry main.
         end.
      end. /* if abs_cons_ship = "0" */

      /* If invoice consolidation is to happen, then check
       * for compatibility of SOs on the shipper */
      if can-find (first df_mstr
         where df_domain = global_domain
         and   df_format = abs_format
         and   df_type = "1"
         and   df_inv = true)
      then do:
         run chk_abs_inv_cons
            (input absid,
             input ship_from,
             input "",
             input "",
             input part_order,
             output cons_ok).

         if cons_ok = false then do:
            /* SALES ORDERS DO NOT MEET INVOICE CONSOLIDATION CONDITION */
            {pxmsg.i &MSGNUM=5835 &ERRORLEVEL=3}
            next-prompt part_order with frame a.
            undo main, retry main.
         end.
      end.

   end. /* FOR FIRST ABS_MSTR */

   find so_mstr
      where so_domain = global_domain
      and   so_nbr = sod_nbr
   no-lock.

   find pt_mstr
      where pt_domain = global_domain
      and   pt_part = sod_part
   no-lock no-error.

   /* ADDING A KIT COMPONENT, get pt_mstr by part_item to AVOID */
   /* USING KIT PARENT PART                                     */
   if kit_comp then
      find pt_mstr
         where pt_domain = global_domain
         and   pt_part = part_item
      no-lock no-error.

   if available pt_mstr then
      part_item = pt_part.
   else if not kit_comp then
      part_item = sod_part.

   assign
      part_po = sod_contr_id
      part_customer_ref = sod_custref
      part_model_year = sod_modelyr
      ship_so   = sod_nbr
      ship_line = sod_line.

   /* VALIDATE SALES ORDER LINE SITE SAME AS SHIPFROM SITE */

   if sod_dock <> ""
      and sod_dock <> p_dock_id
   then do:
      /* SCHEDULED ORDER DOCK IS DIFFERENT */
      {pxmsg.i &MSGNUM=8227 &ERRORLEVEL=2 &MSGARG1=sod_dock}
      /* DO YOU WISH TO CONTINUE? */
      {pxmsg.i &MSGNUM=7734 &ERRORLEVEL=1 &CONFIRM=l_continue}
      if l_continue = no
      then do:
         clear frame a.
         undo main , retry main.
      end. /* IF l_continue = no */
   end. /* IF sod_dock <> "" */

   if sod_site <> ship_from then do:
      /* INVALID ORDER SHIP-FROM SITE */
      {pxmsg.i &MSGNUM=8228 &ERRORLEVEL=3 &MSGARG1=sod_site}
      undo main, retry main.
   end.

   find ad_mstr
       where ad_domain = global_domain
       and   ad_addr = ship_to
   no-lock no-error.

   find first ls_mstr
      where ls_mstr.ls_domain = global_domain
      and  (ls_addr = ad_addr
      and  (ls_type = "ship-to" or ls_type = "customer"))
   no-lock no-error.

   do while not available ls_mstr and ad_ref > "":
      addr = ad_ref.

      find ad_mstr
         where ad_domain = global_domain
         and   ad_addr = addr
      no-lock.

      find first ls_mstr
         where ls_domain = global_domain
         and  (ls_addr = ad_addr
         and  (ls_type = "ship-to" or ls_type = "customer"))
      no-lock no-error.
   end. /* DO WHILE NOT AVAILABLE LS_MSTR */

   shipto_id = ad_addr.

   if (so_ship <> shipto_id) and
      (so_ship <> ship_to)
   then do:
      /* INVALID ORDER SHIP-TO */
      {pxmsg.i &MSGNUM=8229 &ERRORLEVEL=3 &MSGARG1=so_ship}
      undo main, retry main.
   end.

   /* MUST BE IN SAME DOMAIN AS ORDER CREATED IN */
   /* THE VARIABLE so_db WHICH CONTAINS THE VALUE OF CENTRAL DOM WAS */
   /* BEING UNCONVENTIONALLY USED TO STORE A VALUE FOR AN UNRELATED  */
   /* COMPARISON. HENCE THE ERRONEOUS ASSIGNMENT OF so_db HAS BEEN   */
   /* REMOVED AND THE SUBSEQUENT TWO REFERENCES WHICH DEPEND ON THE  */
   /* ERRONEOUSLY ASSIGNED VALUE HAVE BEEN REPLACED BY THE VALUE     */
   /* ITSELF                                                         */

   if so_sched and
      trim(substring(so_conrep,15,20)) <> global_db
   then do:
      /* YOU MUST BE IN DOMAIN */
      {pxmsg.i &MSGNUM=6188 &ERRORLEVEL=3
               &MSGARG1=trim(substring(so_conrep,15,20))}
      undo main, retry main.
   end.

   if available so_mstr
      and so_stat <> ""
   then do:
      /* SALES ORDER STATUS NOT BLANK */
      {pxmsg.i &MSGNUM=623 &ERRORLEVEL=2}
   end. /* IF SO_STAT <> "" */

   if sod_start_eff[1] > today
      or sod_end_eff[1] < today
   then do:
      /* SCHEDULED ORDER IS NO LONGER EFFECTIVE */
      {pxmsg.i &MSGNUM=8138 &ERRORLEVEL=2}
   end.

   if sod_cum_qty[1] >= sod_cum_qty[3] and sod_cum_qty[3] > 0 then do:
      /* CUM SHIPPED QTY > MAX ORDER QTY FOR ORDER SELECTED */
      {pxmsg.i &MSGNUM=8220 &ERRORLEVEL=2}
   end.

   if (not sod_sched) and (not sod_confirm) then do:
      /* SALES ORDER LINE IS NOT SCHEDULED */
      {pxmsg.i &MSGNUM=621 &ERRORLEVEL=3}
      undo main, retry main.
   end.

   if use-log-acctg then do:
      /* VALIDATE SALES ORDER FREIGHT TERMS FOR THIS CONTAINER/SHIPPER */
      run validateSOFrTerms
         (input absid,
          input ship_from,
          input temp_parent,
          input so_nbr,
          input so_fr_terms,
          output l_FrTermsOnFirstOrder,
          output l_FrTermsErr).

      if l_FrTermsErr then do:
         /* ALL ATTACHED ORDERS MUST HAVE FREIGHT TERMS # */
         run DisplayMessage
            (input 5056,
             input 3,
             input l_FrTermsOnFirstOrder,
             input '').
         next-prompt part_order with frame a.
         undo main, retry main.
      end. /* IF l_FrTermsErr */
   end.   /* if use-log-acctg */

   if so_secondary then do:

      find trq_mstr
         where trq_domain = global_domain
         and  (trq_doc_type = "SO"
         and   trq_doc_Ref  = so_nbr
         and   trq_add_ref  = ""
         and  (trq_msg_type = "ORDRSP-I"
         or    trq_msg_type = "ORDRSP-C"))
      no-lock no-error.

      if available trq_mstr and trq_msg_type = "ORDRSP-C" then do:
         /* Change on EMT Order with pending change not allowed */
         {pxmsg.i &MSGNUM=2834 &ERRORLEVEL=3}
         undo main, retry main.
      end.

      if available trq_mstr and trq_msg_type = "ORDRSP-I" then do:
         /* Modification not allowed, awaiting PO Acknowledgement */
         {pxmsg.i &MSGNUM=2935 &ERRORLEVEL=3}
         undo main, retry main.
      end.

   end. /* if so_secondary */

   if so_secondary
      and not sod_sched
      and sod_qty_ship = 0
      and (not can-find(first lad_det
      where lad_domain  = global_domain
      and   lad_dataset = "sod_det"
      and   lad_nbr     = sod_nbr
      and   lad_line    = string(sod_line)))
      and   (not can-find(first lad_det
      where lad_domain  = global_domain
      and   lad_dataset = "sob_det"
      and   lad_nbr     = sod_nbr
      and   lad_line    = string(sod_line)))
   then
      cmf_flg = yes.
   else
      cmf_flg = no.

   if sod_fa_nbr <> "" then do:

      /* SWITCH TO THE REMOTE SITE */
      {gprun.i ""gpalias2.p""
               "(input sod_site, output error_flag)"}

      if error_flag <> 0 and error_flag <> 9 then do:
         /* UNABLE TO CONNECT TO REMOTE DOMAIN */
         run mess-6137 (disp-char6).
         undo main, retry main.
      end.

      /* FIND FINAL ASSEMBLY WORK ORDER FOR LOT NUMBER */
      {gprun.i ""rcshwbc5.p""
               "(input sod_fa_nbr,
                 input sod_part,
                 output part_fa_lot)"}

      /* RESET TO CENTRAL DOMAIN */
      {gprun.i ""gpalias3.p""
               "(input so_db, output error_flag)"}

      if error_flag <> 0 and error_flag <> 9 then do:
         /* UNABLE TO CONNECT TO SALES DOMAIN */
         run mess-6137 (disp-char8).
         undo main, retry main.
      end.

   end. /* if sod_fa_nbr <> "" */

   /*  CHECK IF PRE-SHIPPER/SHIPPER IS CANCELED */
   find abs_mstr
      where abs_domain = global_domain
      and   abs_shipfrom = ship_from
      and   abs_id = absid
   no-lock no-error.

   if available abs_mstr then do:
      run get_abs_parent
         (input abs_id,
          input abs_shipfrom,
          output par_absid,
          output par_shipfrom).

      if par_absid <> ? then do:
         find abs_tmp
            where abs_tmp.abs_domain = global_domain
            and   abs_tmp.abs_id = par_absid
            and   abs_tmp.abs_shipfrom = par_shipfrom
         no-lock no-error.

         if available abs_tmp and
            abs_tmp.abs_canceled = yes
         then
            shp_canceled = yes.
      end.
   end.

   if shp_canceled then
      det_all = no.

   if sod_type <> "" then
      det_all = no.

   display
      pt_desc1 when (available pt_mstr)     @ item_description
      sod_desc when (not available pt_mstr) @ item_description
      part_po
      pt_um    when (available pt_mstr)     @ part_qty_um
      sod_um   when (not available pt_mstr) @ part_qty_um
      part_item
      part_order
      part_order_line
      part_customer_ref
      part_model_year
   with frame a.

   /* ASSIGN DEFAULTS */
   run assign_part_defaults.

   /* GET THE OPEN QTY FOR THE SALES ORDER LINE */
   if not so_sched then
      run p-get-open
         (input recid(sod_det)).

   display
      part_site
      part_loc
      part_lot_ser
      part_ref
      part_qty
      part_qty_um
      part_qty_conv
      sod_type      when (available sod_det)
      ""            when (not available sod_det) @ sod_type
      part_wght
      part_wt_um
      part_vol
      part_vol_um
      multiple
      cmmts
      part_fa_lot
      det_all
      ship_avail_qty
   with frame a.

   assign
      l_prev_um = part_qty_um.

   /* GET INVENTORY DETAIL INFORMATION */
   INV_DETAIL:
   do on endkey undo main, retry main
      on error undo INV_DETAIL, retry INV_DETAIL:

      undotran = no.

      /* THE WORK ORDER ID WILL NOT BE EDITABLE IN PRE-SHIPPER/SHIPPER  */
      /* WORKBENCH WHEN RECEIVE F/A IN WO = YES                         */
      set
		 v_nbr_cyl1    /*xp001*/
		 v_nbr_cyl3    /*xp002*/
         
         part_qty
         part_qty_um
         part_qty_conv
         part_wght
         part_wt_um
         part_vol
         part_vol_um
         part_fa_lot   when (fac_wo_rec = no)
         part_site
         part_loc
         part_lot_ser
         part_ref
         multiple      when (sod_type = "")
         cmmts
      with frame a editing:
         assign
            global_site = input part_site
            global_loc  = input part_loc
            global_lot  = input part_lot_ser.
         readkey.
         apply lastkey.
      end. /* EDITING */

      if input v_nbr_cyl1 <> "" then do:
          find first abs_mstr 
                where abs_mstr.abs_domain = global_domain 
                and abs_mstr.abs__chr01 = input v_nbr_cyl1
          no-lock no-error .
          if avail abs_mstr then do:
                message "流水号已经存在" .
                undo,retry .
          end.
	  end. /*xp001*/



      /* CHECK FOR CONVERSION FACTOR */
      if available pt_mstr
         and pt_um <> part_qty_um
      then do:

         if not part_qty_conv entered then do:

            {gprun.i ""gpumcnv.p""
                     "(input part_qty_um,
                       input pt_um,
                       input pt_part,
                       output part_qty_conv)"}

            if part_qty_conv = ? then do:
               /* NO UM CONVERSION EXISTS */
               {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
               part_qty_conv = 1.
            end.

            display
               part_qty_conv
            with frame a.

         end. /* IF NOT PART_QTY_CONV ENTERED */

      end. /* IF PART_QTY_UM <> PT_UM */

      if part_qty_conv entered then do:

         for first um_mstr
            fields (um_domain um_alt_um um_conv um_part um_um)
            where   um_domain = global_domain
            and     um_um     = l_prev_um
            and     um_alt_um = part_qty_um
            and    (um_part = part_item
            or      um_part = "")
         no-lock:
            if um_conv <> part_qty_conv then do:
               /* UM CONVERSION CAN NOT BE EDITED FOR AN EXISTING */
               /* ALTERNATE UM                                    */
               {pxmsg.i &MSGNUM=3429 &ERRORLEVEL=3}
               undo INV_DETAIL,retry INV_DETAIL.
            end.
         end. /* FOR FIRST UM_MSTR */
      end. /* IF PART_QTY_CONV ENTERED */

      if not so_sched then
         if ((sod_qty_ord >= 0  and
            ((part_qty * part_qty_conv) / sod_um_conv) > open_qty )  or
             (sod_qty_ord < 0  and
            ((part_qty * part_qty_conv) / sod_um_conv) < open_qty ))
         then do:
            /* QTY ORDERED CANNOT BE LESS THAN ALLOCATED + PICKED + SHIPPED */
            {pxmsg.i  &MSGNUM=4999 &ERRORLEVEL=2}
         end. /* IF PART_QTY > OPEN_QTY */

      /* IF SPECIFIED SITE IS NOT DEFINED SHIP-FROM SITE, */
      /* MAKE SURE IT'S IN THE SAME DOMAIN              */
      if part_site <> ship_from then do:
         find si_mstr
            where si_domain = global_domain
            and   si_site   = ship_from
         no-lock.

         ship_db = si_db.

         find si_mstr
            where si_domain = global_domain
            and   si_site   = part_site
         no-lock.

         if si_db <> ship_db then do:
            /* ALL SHIP-FROM SITES MUST BE IN SAME DOMAIN */
            {pxmsg.i &MSGNUM=6253 &ERRORLEVEL=3}
            next-prompt part_site.
            undo INV_DETAIL, retry INV_DETAIL.
         end.
      end.

      if part_site <> ship_from then do:
         {gprun.i ""gpgetgrp.p""
                  "(input part_site,
                    input ship_from,
                    output shipgrp)"}

         if shipgrp <> ? then do:
            find sg_mstr
               where sg_domain = global_domain
               and   sg_grp = shipgrp
            no-lock no-error.

            if available sg_mstr
               and sg_auto_tr = no
            then do:
               /* Automatic transfer from site # to site # prohibited */
               {pxmsg.i &MSGNUM=5845 &ERRORLEVEL=3
                        &MSGARG1=part_site &MSGARG2=ship_from}
               undo main, retry main.
            end.
         end. /* if shipgrp <> ? */
      end. /* if part_site <> ship_from  */

      /* QTY IS NEG  - NO ALLOCATION, NO WEIGHT, NO VOLUME */
      if part_qty < 0 then
         assign det_all = no.

      set
         det_all   when (not shp_canceled and sod_type = "" and part_qty > 0)
         ship_avail_qty
      with frame a.

      if ship_avail_qty
         and not det_all
      then do:
         /* Allocate components must be yes for this feature */
         {pxmsg.i &MSGNUM=2860 &ERRORLEVEL=3}
         next-prompt ship_avail_qty with frame a.
         undo INV_DETAIL, retry INV_DETAIL.
      end.

      /* VALIDATE F/A WO ID  */
      if part_fa_lot <> "" then do:
         run val-fa-id
            (input part_fa_lot,
             input recid (sod_det),
             output undotran).

         if undotran then do:
            next-prompt part_fa_lot.
            undo INV_DETAIL, retry INV_DETAIL.
         end.
      end.

      /* CHECK IF THE SERIAL IS ALREADY ATTACHED */
      /* AT ANY LEVEL IN SHIPPER                 */
      if (available pt_mstr)
         and (pt_lot_ser = "S")
      then do:

         /* FIND THE SHIPPER ID */
         for first abs_tmp
            fields(abs_id)
               where recid(abs_tmp) = global_recid
         no-lock:
         end. /* FOR FIRST abs_tmp */

         assign
            parent_id = abs_tmp.abs_id
            l_allowed = yes.

         empty temp-table work2_abs_mstr.

         /* EXPLODE THE SHIPPER */
         {gprun.i ""rcabsexp.p"" "(input        ship_from,
                                   input        parent_id,
                                   input-output l_allowed,
                                   input-output l_item,
                                   input-output l_lot)"}

         if can-find(first work2_abs_mstr
                        where work2_abs_mstr.w_abs_shipfrom = ship_from
                          and work2_abs_mstr.w_abs_id       begins "i"
                          and work2_abs_mstr.w_abs_item     = part_item
                          and work2_abs_mstr.w_abs_lot      = part_lot_ser
                          use-index order)
         then do:

            /* SERIAL: # FOR PART: # ALREADY PICKED IN THIS SHIPMENT */
            run DisplayMessage(input 6592,
                               input 3,
                               input part_lot_ser,
                               input part_item).
            empty temp-table work2_abs_mstr.
            undo inv_detail, retry inv_detail.

         end. /* IF CAN-FIND(FIRST work2_abs_mstr */

      end. /* IF pt_lot_ser = "S" */

      run delete-srwkfl.

      /* SWITCH TO THE REMOTE SITE IF NECESSARY */
      {gprun.i ""gpalias2.p""
               "(input part_site,
                 output error_flag)"}

      if error_flag <> 0 and error_flag <> 9 then do:
         /* UNABLE TO CONNECT TO REMOTE DOMAIN */
         run mess-6137 (disp-char6).
         undo INV_DETAIL, retry INV_DETAIL.
      end.

      run delete-srwkfl.

      if available sod_det
         and sod_type = ""
         and not multiple
      then do:

         {&RCSHWBC2-P-TAG1}

         /* CHECK TO SEE IF RESERVED LOCATION EXISTS */
         /* FOR OTHER CUSTOMERS--                    */
         if available so_mstr then do:

            run check-reserved-location.

            if ret-flag = 0 then do:
               /* THIS LOCATION RESERVED FOR ANOTHER CUSTOMER */
               {pxmsg.i &MSGNUM=3346 &ERRORLEVEL=3}
               undotran = yes.
            end.

         end.  /* if available so_mstr... */

         if not undotran then do:

            /* VALIDATE THE INVENTORY DETAIL INFORMATION */
            {gprun.i ""rcctmtb.p""
                     "(input transtype,
                       input ship_from,
                       input part_site,
                       input part_loc,
                       input part_item,
                       input part_lot_ser,
                       input part_ref,
                       input part_qty,
                       input part_qty_um,
                       input part_qty_conv,
                       output undotran)"}
         end.   /* if not undotran... */

         if undotran then do:
            /* RESET TO CENTRAL DOMAIN IF NECESSARY */
            {gprun.i ""gpalias3.p""
                     "(input so_db, output error_flag)"}
            undo INV_DETAIL, retry INV_DETAIL.
         end.


         if using_cust_consignment
            and sod_consignment
         then do:

            /* CREATE CONSIGNMENT TEMP-TABLE RECORD TO HOLD RETURN SETTING */
            {gprunmo.i &program = "socnship.p" &module = "ACN"
                       &param   = """(input  part_order,
                                      input  integer(part_order_line),
                                      input  part_site,
                                      input  part_loc,
                                      input  part_item,
                                      input  part_lot_ser,
                                      input  part_ref,
                                      input  part_qty,
                                      output ok_to_ship,
                                      input-output table
                                         tt_consign_shipment_detail)"""}

            if not ok_to_ship then
               undo inv_detail, retry inv_detail.
         end.  /* IF using_cust_consignment */

      end. /* IF NOT MULTIPLE */

      /* SET THE MULTIPLE INFO IF NECESSARY */
      if multiple then do:

         run assign_multiple_info.

         CHK-SERIAL:
         repeat on error  undo chk-serial, leave chk-serial
                on endkey undo chk-serial, leave chk-serial:

            l_allowed = yes.
            if (available pt_mstr)
               and (pt_lot_ser = "S")
            then do:

               empty temp-table work2_abs_mstr.

               /* EXPLODE THE SHIPPER */
               {gprun.i ""rcabsexp.p"" "(input        ship_from,
                                         input        parent_id,
                                         input-output l_allowed,
                                         input-output l_item,
                                         input-output l_lot)"}

            end. /* IF pt_lot_ser = "S" */

            /* MULTIPLE ENTRY ROUTINE */
            {gprun.i ""icsrup.p""
                     "(input ship_from,
                       input sod_nbr,
                       input sod_line,
                       input-output lotnext,
                       input lotprcpt,
                       input no)"}

            if (available pt_mstr)
               and (pt_lot_ser = "S")
            then do:

               for each sr_wkfl
                  where sr_wkfl.sr_domain = global_domain
                    and sr_wkfl.sr_userid = mfguser
               no-lock:

                  if can-find(first work2_abs_mstr
                                 where work2_abs_mstr.w_abs_shipfrom
                                       = ship_from
                                   and work2_abs_mstr.w_abs_id
                                       begins "i"
                                   and work2_abs_mstr.w_abs_item
                                       = sod_part
                                   and work2_abs_mstr.w_abs_lot
                                       = sr_wkfl.sr_lotser
                                   and not(work2_abs_mstr.w_abs_order
                                       = sod_nbr
                                   and work2_abs_mstr.w_abs_line
                                       = string(sod_line)
                                   and work2_abs_mstr.w_abs_par_id
                                       = abs_mstr.abs_id)
                                   use-index order)
                  then do:

                    /* SERIAL: # FOR PART: # ALREADY PICKED IN THIS SHIPMENT */
                     run DisplayMessage(input 6592,
                                        input 3,
                                        input sr_wkfl.sr_lotser,
                                        input sod_part).
                     l_allowed = no.
                     pause.
                     empty temp-table work2_abs_mstr.
                     next chk-serial.

                  end. /* IF CAN-FIND(FIRST work2_abs_mstr */

               end. /* FOR EACH sr_wkfl */

            end. /* IF pt_lot_ser = "S" */

            if l_allowed = yes
            then
               leave chk-serial.

         end. /* REPEAT */

         if using_cust_consignment
            and sod_consignment
         then do:
            key1 = mfguser + "CONS".

            /* TRANSFER qad_wkfl TO CONSIGNMENT TEMP-TABLE */
            {gprunmo.i &program = "socntmp.p" &module = "ACN"
                       &param   = """(input 1,
                                      input key1,
                                      input-output table
                                         tt_consign_shipment_detail)"""}
         end.

         /* LOGIC TO ACCESS SR_WKFL TRANSFERRED TO RCSHWBC6.p, SO AS TO   */
         /* RETAIN THE VALUE OF SR_USERID IN A MULTI DOMAIN ENVIRONMENT */
         assign
            undotran = no.

         {gprun.i ""rcshwbc6.p"" "(output undotran)"}

         if undotran then do:
            /* RESET TO CENTRAL DOMAIN IF NECESSARY */
            {gprun.i ""gpalias3.p""
                     "(input so_db, output error_flag)"}
            undo INV_DETAIL, retry INV_DETAIL.
         end. /* IF UNDOTRAN */

      end. /* IF MULTIPLE */

      /* SET WORK_SR_WKFL WORKFILE RECORDS */
      {gprun.i ""rcshmtb2.p""
               "(input mfguser, input cline)"}

      /* RESET TO CENTRAL DOMAIN IF NECESSARY */
      {gprun.i ""gpalias3.p""
               "(input so_db, output error_flag)"}

      if error_flag <> 0 and error_flag <> 9 then do:
         /* UNABLE TO CONNECT TO SALES DOMAIN */
         run mess-6137 (disp-char8).
         undo INV_DETAIL, retry INV_DETAIL.
      end.

   end. /* INV_DETAIL */

   /* CREATE WORK_SR_WKFL FOR MULTI-ENTRY = FALSE */
   for first work_sr_wkfl
      fields(oid_sr_wkfl sr_loc  sr_lotser sr_qty
             sr_ref      sr_site sr_userid)
   no-lock:
   end. /* FOR FIRST work_sr_wkfl */

   if not available work_sr_wkfl
   then do:
      create work_sr_wkfl.
      assign
         work_sr_wkfl.oid_sr_wkfl = nextOidValue()
         work_sr_wkfl.sr_userid   = mfguser
         work_sr_wkfl.sr_site     = part_site
         work_sr_wkfl.sr_loc      = part_loc
         work_sr_wkfl.sr_lotser   = part_lot_ser
         work_sr_wkfl.sr_ref      = part_ref
         work_sr_wkfl.sr_qty      = part_qty.
   end.

   /* COUNT THE NUMBER OF PARENT CONTAINERS FOR THIS ITEM */
   num_containers = 0.

   for each abs_mstr
      where abs_mstr.abs_domain = global_domain
      and   abs_mstr.abs_shipfrom = ship_from
      and abs_mstr.abs_shipto = temp_parent
      and integer(abs_mstr.abs__qad06) = 2
   no-lock:
      num_containers = num_containers + 1.
   end.

   /* COUNT THE QTY OF ITEMS FOR THE PARENT CONTAINERS */
   part_qty = 0.

   for each work_sr_wkfl
      fields(oid_sr_wkfl sr_loc  sr_lotser sr_qty
             sr_ref      sr_site sr_userid)
   no-lock:
      part_qty = part_qty + work_sr_wkfl.sr_qty.
   end. /* FOR EACH work_sr_wkfl */

   /* ADDING A KIT PARENT, PROCESS KIT COMPONENTS */
   if can-find (first sob_det
      where sob_det.sob_domain = global_domain
      and   sob_nbr = sod_nbr
      and   sob_line = sod_line)
      and   part_item = sod_part
      and   sod_cfg_type = "2"
      and   sod_fa_nbr = ""
   then do:

      process_type = 2.

      {gprun.i ""soskit01.p""
               "(input recid(so_mstr),
                 input recid(sod_det),
                 input det_all,
                 input part_qty,
                 input (sod_qty_ord - sod_qty_ship),
                 input process_type,
                 input ship_avail_qty,
                 input stage_open,
                 output abnormal_exit)"}

      if (abnormal_exit) then
         undo main, retry main.

      new_par_qty = part_qty.

      if ship_avail_qty then do:
         run get_par_qty
            (input recid(sod_det),
             input-output new_par_qty).

         if new_par_qty <> part_qty * part_qty_conv
         then do:
            /* Quantity available in site location */
            {pxmsg.i &MSGNUM=208 &ERRORLEVEL=3 &MSGARG1=new_par_qty}
            undo main, retry main.
         end.
      end.

   end.  /* if can-find sob_det */
   else do:
      /* GENERAL ALLOCATION FOR REGULAR ITEM */
      /* SWITCH TO THE INVENTORY SITE */
      {gprun.i ""gpalias2.p""
               "(input sod_site, output errornum)"}

      if errornum <> 0 and errornum <> 9 then do:
         /* DOMAIN # IS NOT AVAILABLE */
         run mess-6137 (disp-char6).
         abnormal_exit = true.
         undo main, leave main.
      end.

      if sod_qty_all = 0 then
         l_sodall = yes.

      /* DO THE GENERAL ALLOCATIONS */
      if sod_qty_all = 0 then
         {gprun.i ""soitallc.p""
                  "(input part_order,
                    input integer(part_order_line),
                    input all_days,
                    input part_qty * part_qty_conv / sod_um_conv,
                    output l_sod_all)"}

      /* SWITCH BACK TO THE SALES ORDER DOMAIN */
      {gprun.i ""gpalias3.p""
               "(input so_db, output errornum)"}

      if errornum <> 0 and errornum <> 9 then do:
         /* DOMAIN # IS NOT AVAILABLE */
         run mess-6137 (disp-char8).
         abnormal_exit = true.
         undo main, leave main.
      end.

   end.

   /* AT THIS POINT NUM_CONTAINERS CONTAINS THE NUMBER OF PARENT    */
   /* RECORDS THAT THE ITEM QTY IS TO BE DIVIDED AMONGST. PART_QTY  */
   /* WILL CONTAIN THE TOTAL ITEM QTY                               */

   /* DETERMINE QUANTITY PER AND MODULO */
   assign
      qty_per = truncate ( part_qty / num_containers,0 )
      qty_modulo = part_qty modulo num_containers.

   /* PART QUANTITIES WILL BE ASSIGNED TO PARENT CONTAINER RECORDS  */
   /* ON A CONSUMPTION BASIS I.E. SR_WKFL'S WILL BE FOUND ONE BY ONE*/
   /* AND AS MUCH OF THE QUANTITY THAT CAN, WILL BE APPLIED TO THE  */
   /* CURRENT RECORD UNTIL THE QUANTITY LEFT IS ZERO. THEN THE NEXT */
   /* SR_WKFL RECORD WILL BE APPLIED AND SO ON UNTIL ALL HAVE BEEN  */
   /* APPLIED                                                       */
   first_parent = yes.

   /* CREATE THE ALLOTED NUMBER OF CONTAINER RECORDS */
   /* FROM THE SR_WKFL RECORDS */
   for each parent_container
      where parent_container.abs_domain = global_domain
      and   parent_container.abs_shipfrom = ship_from
      and   parent_container.abs_shipto = temp_parent
      and   integer(abs__qad06) = 2
   exclusive-lock:

      /* SET PART QTY FOR THIS RECORD */
      assign
         qty_to_set = qty_per
         this_rec_qty = 0.

      /* ASSIGN MODULO QTY TO FIRST RECORD ONLY */
      if qty_modulo > 0 then do:
         if part_qty > 0 then
            qty_to_set = qty_to_set + qty_modulo.
         else
            qty_to_set = qty_to_set + (qty_modulo - num_containers).
         qty_modulo = 0.
      end.

      do while (qty_to_set <> 0) or (num_containers = 1 and part_qty <> 0):

         find first work_sr_wkfl
         exclusive-lock.

         /* CASE SR_QTY IS MORE THAN REQUIRED */
         if num_containers > 1 then do:

            if absolute (work_sr_wkfl.sr_qty) >
               absolute (qty_to_set)
            then
               assign
                  work_sr_wkfl.sr_qty = work_sr_wkfl.sr_qty - qty_to_set
                  this_rec_qty = qty_to_set
                  qty_to_set = 0.

            /* CASE SR_QTY IS LESS THAN OR EQUAL AMT REQUIRED */
            else
               assign
                  this_rec_qty = work_sr_wkfl.sr_qty
                  qty_to_set = qty_to_set - work_sr_wkfl.sr_qty
                  work_sr_wkfl.sr_qty = 0.

            assign
               this_rec_qty2 = this_rec_qty.
         end. /* NUM_CONTAINERS > 1 */
         else
            assign
               this_rec_qty2 = work_sr_wkfl.sr_qty
               work_sr_wkfl.sr_qty = 0.

         /* CHECK FOR DUPLICATE RECORDS */
         if kit_comp then
            find abs_mstr
               where abs_mstr.abs_domain = global_domain
               and   abs_mstr.abs_shipfrom = ship_from
               and   abs_mstr.abs_id = parent_container.abs_id
                                     + work_sr_wkfl.sr_site
                                     + part_order
                                     + part_order_line
                                     + part_item
                                     + work_sr_wkfl.sr_loc
                                     + work_sr_wkfl.sr_lotser
                                     + work_sr_wkfl.sr_ref
            no-lock no-error.
         else
            find abs_mstr
               where abs_mstr.abs_domain = global_domain
               and   abs_mstr.abs_shipfrom = ship_from
               and   abs_mstr.abs_id = "I" + parent_container.abs_id
                                     +  work_sr_wkfl.sr_site
                                     +  part_order
                                     + part_order_line
                                     + part_item
                                     + work_sr_wkfl.sr_loc
                                     + work_sr_wkfl.sr_lotser
                                     +  work_sr_wkfl.sr_ref
            no-lock no-error.

         if available abs_mstr then do:
            /* YOU CANNOT HAVE MULTIPLE ITEMS FOR SAME ... */
            {pxmsg.i &MSGNUM=753 &ERRORLEVEL=3}
            undo main, retry main.
         end.

         if first_parent then do:

            first_parent = no.

            if cmmts then do:
               /* The parent shipper if the container is attached to one */
               run get_abs_parent
                  (input parent_container.abs_id,
                   input ship_from,
                   output par_absid,
                   output par_shipfrom).

               if par_absid <> ? then do:
                  find abs_buff
                     where abs_buff.abs_domain = global_domain
                     and   abs_buff.abs_id = par_absid
                     and   abs_buff.abs_shipfrom = par_shipfrom
                  no-lock no-error.

                  if available abs_buff then do:
                     assign
                        global_ref = abs_buff.abs_format
                        global_lang = abs_buff.abs_lang.

                     {gprun.i ""gpcmmt01.p"" "(input 'abs_mstr')"}

                  end.
               end. /* if par_absid <> ? */

            end. /* if cmmts */

         end.  /* if first_parent */

         /* UPDATE ALLOCATION  FOR REG ITEM & ATO */
         if sod_cfg_type <> "2"
            or kit_comp
         then do:

            /* SET GLOBAL_DB USING ABS_SITE */
            new_site = part_site.
            {gprun.i ""gpalias.p""}

            /* SWITCH TO THE INVENTORY SITE */
            if so_db <> global_db then do:
               {gprun.i ""gpalias2.p""
                        "(input part_site, output errornum)"}

               if errornum <> 0 and errornum <> 9 then do:
                  /* DOMAIN # IS NOT AVAILABLE */
                  run mess-6137 (disp-char6).
                  undo main, retry main.
               end.
            end.

            if det_all then do:
               /* CALL SOITALLE.P INSTEAD OF SOITALLA.P */
               {gprun.i ""soitalle.p""
                        "(input part_order,
                          input part_order_line,
                          input part_item,
                          input work_sr_wkfl.sr_site,
                          input work_sr_wkfl.sr_loc,
                          input work_sr_wkfl.sr_lotser,
                          input work_sr_wkfl.sr_ref,
                          input this_rec_qty2 * part_qty_conv,
                          output adj_qty,
                          output undotran)"}
            end.
            else do:

               /* DURING SO CREATION l_sodall = Yes, sod_qty_all = 0  */
               {gprun.i ""soitallf.p""
                        "(input part_order,
                          input part_order_line,
                          input part_item,
                          input work_sr_wkfl.sr_site,
                          input work_sr_wkfl.sr_loc,
                          input work_sr_wkfl.sr_lotser,
                          input work_sr_wkfl.sr_ref,
                          input this_rec_qty2 * part_qty_conv,
                          input del_lad,
                          input l_sodall,
                          output undotran)"}

               adj_qty = 0.
            end.

            l_orig = 0.

            /* SWITCH BACK TO THE SALES ORDER DOMAIN */
            if so_db <> global_db then do:

               /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
               /* IN REMOTE DOMAIN                         */
               if not kit_comp
                  and det_all
               then do:

                  l_orig = sod_qty_all + sod_qty_pick.

                  /* UPDATE SO ALLOCATED AND PICKED QUANTITY */
                  /* AND INV QTY ALLOCATED                   */
                  {gprun.i ""sosopka4.p""
                     "(input part_order,
                      input part_order_line,
                      input adj_qty,
                      input v_unpicked_qty,
                      input l_orig)"}

               end. /* IF NOT kit_comp AND det_all */

               {gprun.i ""gpalias3.p""
                        "(input so_db, output errornum)"}

               if errornum <> 0 and errornum <> 9 then do:
                  /* DOMAIN # IS NOT AVAILABLE */
                  run mess-6137 (disp-char8).
                  undo main, retry main.
               end.

            end.

            if undotran then  undo main, retry main.

            /* UPDATE DETAIL QTY ALL, QTY PICK */
            if not kit_comp
               and det_all
            then do:

               for first sod_det
                  fields(sod_btb_type sod_cfg_type  sod_confirm  sod_consignment
                         sod_contr_id sod_cum_qty   sod_custref  sod_desc
                         sod_dock     sod_domain    sod_end_eff  sod_fa_nbr
                         sod_line     sod_loc       sod_lot      sod_modelyr
                         sod_nbr      sod_part      sod_pickdate sod_qty_all
                         sod_qty_ord  sod_qty_pick  sod_qty_ship sod_sched
                         sod_site     sod_start_eff sod_type     sod_um
                         sod_um_conv)
                  where sod_domain = global_domain
                    and sod_nbr    = part_order
                    and sod_line   = integer(part_order_line)
                  no-lock:
               end. /* FOR FIRST sod_det ... */

               if available sod_det
               then
                  l_orig = sod_qty_all + sod_qty_pick.

               /* UPDATE SO ALLOCATED AND PICKED QUANTITY */
               /* AND INV QTY ALLOCATED                   */
               {gprun.i ""sosopka4.p""
                  "(input part_order,
                   input part_order_line,
                   input adj_qty,
                   input v_unpicked_qty,
                   input l_orig)"}

            end.  /* IF NOT kit_comp ... */
         end. /* con_type <> "2"  ... */

         if kit_comp then
            new_id = parent_container.abs_id
                   + work_sr_wkfl.sr_site
                   + part_order
                   + part_order_line
                   + part_item
                   + work_sr_wkfl.sr_loc
                   + work_sr_wkfl.sr_lotser
                   + work_sr_wkfl.sr_ref
                   + part_fa_lot.
         else
            new_id = "I" + parent_container.abs_id
                   +   work_sr_wkfl.sr_site
                   +   part_order
                   +   part_order_line
                   +   part_item
                   +   work_sr_wkfl.sr_loc
                   +   work_sr_wkfl.sr_lotser
                   +   work_sr_wkfl.sr_ref
                   +  part_fa_lot.

         /* CREATE THE CONTAINER RECORD */	 /*xp001*/
         run p_create_item
            (input v_nbr_cyl1,
             input v_nbr_cyl3,
			 input ship_from,
             input temp_parent,
             input new_id,
             input parent_container.abs_id,
             input this_rec_qty2,
             input part_item,
             input work_sr_wkfl.sr_loc,
             input work_sr_wkfl.sr_lotser,
             input work_sr_wkfl.sr_ref,
             input part_wght,
             input part_wt_um,
             input part_vol,
             input part_vol_um,
             input work_sr_wkfl.sr_site,
             input part_qty_um,
             input part_qty_conv,
             input (if available pt_mstr then pt_ship_wt else part_wght),
             input part_order,
             input part_order_line,
             input cmtindx,
             input part_fa_lot,
             input using_cust_consignment,
             input-output table tt_consign_shipment_detail,
             buffer pt_mstr,
             output line_recno).
			 
		

         if sod_sched
         then do:

            /* ADDED VALIDATION TO FIND PARENT ID TO PASS AS INPUT */
            /* TO PEGGING PROGRAM    */

            if par_absid <> ? and execname = "rcshgw.p"
            then do:
               for first abs_mstr
                  fields(abs_mstr.abs_domain abs_mstr.abs_shipfrom
                  abs_mstr.abs_id)
                  where abs_mstr.abs_domain   = global_domain
                  and   abs_mstr.abs_shipfrom = par_shipfrom
                  and   abs_mstr.abs_id       = par_absid
               no-lock:
               end. /* FOR FIRST abs_mstr */

               par_recid = if available abs_mstr
                           then
                              recid(abs_mstr)
                           else
                              line_recno.
            end.

            else
               par_recid = line_recno.

            /* AUTOMATIC FIFO PEGGING DURING THE SHIPPER LINE CREATION */
            /* IN P/S WORKBENCH                                        */
            {gprun.i ""rcrspeg.p""
                     "(input par_recid,
                       input true,
                       input low_date,
                       input hi_date,
                       input """",
                       input hi_char,
                       input """",
                       input hi_char,
                       output l_errors)"}
         end. /* IF SOD_SCHED */

         if (using_container_charges or using_line_charges) and
            ship_to > ""
         then
            run CreateUserFields
               (input ship_from,
                input shipto_id,
                input new_id).

         if using_line_charges then
            run CreateLineCharges
               (input new_id,
                input ship_from,
                input part_order,
                input integer(part_order_line)).

         /* UPDATING IMMEDIATE PARENT CONTAINER WEIGHT FOR THE ITEM CREATED */
         l_par_cont = parent_container.abs_id.

         if available pt_mstr then
            l_pt_ship_wt = pt_ship_wt.
         else
            l_pt_ship_wt = part_wght.

         if substring(parent_container.abs_id, 1, 1) = "C"
         then do:

            l_conv = 1.

            /* CONSIDERING CHANGES IN NET WEIGHT UM IN THE ITEM  */
            /* INFORMATION FRAME AND ACCORDINGLY ADJUSTING THE   */
            /* THE NET AND GROSS WEIGHTS OF THE PARENT CONTAINER */
            if (parent_container.abs_wt_um <> "" ) and
               part_wt_um <> parent_container.abs_wt_um
            then do:
               /* INTERCHANGED FIRST TWO PARAMETERS */
               {gprun.i ""gpumcnv.p""
                        "(input part_wt_um,
                          input parent_container.abs_wt_um,
                          input """",
                          output l_conv)"}

               if l_conv = ? then
                  l_conv = 1.
            end.  /* IF PARENT_CONTAINER.ABS_WT_UM <> "" AND ...    */

            run calc_container_weights.

            assign
               l_total_tare_wt = 0
               l_total_net_wt  = 0.

         end.  /* IF SUBSTRING(PARENT_CONTAINER.ABS_ID, 1, 1) = 'c' */

         else
         if substring(parent_container.abs_id, 1, 1) = "I"
         then do:
            /* ROLLING UP TARE WEIGHT FROM KIT COMPONENT TO THE KIT PARENT */
            /* THE NET AND GROSS WT ROLLUP WILL BE HANDLED BY SUBSEQUENT   */
            /* CALL TO ICSHNWT.P                                           */
            {absupack.i  "parent_container" 26 22 "l_abs_kit_tare_wt"}

            l_abs_kit_tare_wt = l_abs_kit_tare_wt + l_abs_tot_tare_wt.

            {abspack.i "parent_container" 26 22 "l_abs_kit_tare_wt"}
         end.  /* IF SUBSTRING(PARENT_CONTAINER.ABS_ID, 1, 1) = "i" */

         /* Gather additional line item data */
         {gprun.i ""sofsgi.p"" "(input line_recno)"}

         /*MAINTAIN CONTAINER AND LINE CHARGE DATA*/
         if using_container_charges or
            using_line_charges
         then do:
            run getUserFieldData
                (input new_id, input ship_from).

            if using_line_charges then do:

                run getLineCharges
                   (input new_id,
                    input ship_from,
                    input recid(so_mstr),
                    input recid(sod_det)).
                view frame a.
                pause 0.
            end. /* IF USING_LINE_CHARGES */
         end. /* IF USING_CONTAINER_CHARGES */

         /* MAINTAIN SEQUENCES, IF CUST. SEQ. SCHEDULES ARE INSTALLED */
         {gpfile.i &file_name = """"rcf_ctrl""""}

         if can-find (mfc_ctrl
            where mfc_domain = global_domain
            and   mfc_field = "enable_sequence_schedules"
            and   mfc_logical)
            and   file_found
         then
            for first so_mstr
               where so_domain = global_domain
               and   so_nbr = part_order
               and   so_seq_order
            no-lock:
               {gprunmo.i &program = ""rcabssup.p"" &module = "ASQ"
                          &param   = """(input new_id,
                                         input ship_from,
                                         input "yes")"""}
            end.

         /*  ADD ABS RECORDS FOR KIT COMPONENTS */
         if can-find (first sob_det
            where sob_domain = global_domain
            and   sob_nbr = sod_nbr
            and   sob_line = sod_line)
         then do:
            {gprun.i ""rcshwbc3.p""
                     "(input line_recno,
                       input recid(sod_det),
                       input this_rec_qty2 / part_qty,
                       input this_rec_qty2,
                       input work_sr_wkfl.sr_site,
                       input work_sr_wkfl.sr_loc,
                       input work_sr_wkfl.sr_lotser,
                       input work_sr_wkfl.sr_ref,
                       input det_all)"}
         end.

         if work_sr_wkfl.sr_qty = 0 then
            delete work_sr_wkfl.

         for first work_sr_wkfl
            fields(oid_sr_wkfl sr_loc  sr_lotser sr_qty
                   sr_ref      sr_site sr_userid)
         no-lock:
         end. /* FOR FIRST work_sr_wkfl */

         /* IF ALL WORK_SR_WKFL RECORDS ARE CONSIDERED THEN EXIT THE LOOP */
         if not available work_sr_wkfl then
            assign
               qty_to_set = 0
               part_qty   = 0.

      end. /* DO WHILE QTY_TO_SET > 0 */

   end. /* FOR EACH PARENT_CONTAINER */

   /* MAINTAIN SHIPMENT PERFORMANCE REASON CODES */
   {gpfile.i &file_name = """"shpc_ctrl""""}

   if can-find (mfc_ctrl
      where mfc_domain = global_domain
      and   mfc_field = "enable_shipment_perf"
      and   mfc_logical)
      and   file_found
   then do:

      for first shpc_ctrl
         fields (shpc_domain shpc_shipper_reasons)
         where   shpc_domain = global_domain
      no-lock: end.

      if available shpc_ctrl
         and shpc_shipper_reasons
      then do:

         {gprunmo.i &program = ""sorsnup.p"" &module = "ASR"
                    &param   = """(input new_id,
                                   input ship_from)"""}

      end. /* IF AVAILABLE shpc_ctrl */
   end. /* IF CAN-FIND mfc_ctrl */

   for first abs_buff2
      fields (abs_domain abs_canceled abs_cmtindx abs_cons_ship abs_dataset
              abs_fa_lot abs_format abs_gwt abs_id abs_item
              abs_lang abs_line abs_loc abs_lotser abs_nwt
              abs_order abs_par_id abs_qty abs_ref abs_shipfrom
              abs_shipto abs_ship_qty abs_shp_date abs_site
              abs_status abs_type abs_vol abs_vol_um
              abs__qad02 abs__qad03 abs__qad06 abs__qad10)
      where abs_buff2.abs_domain   = global_domain
      and   abs_buff2.abs_shipfrom = ship_from
      and   abs_buff2.abs_id       = l_par_cont
   no-lock:

      if substring(abs_buff2.abs_id, 1, 1) = "C"
      then do:

         /* IF THE IMMEDIATE PARENT OF THE ITEM CREATED IS A CONTAINER   */
         /* THEN THE ITEM WEIGHTS SHOULD NOT BE ROLLED UP TO CONTAINER   */
         /* SINCE THIS IS ALREADY DONE IN THE PARENT_CONTAINER LOOP ABOVE*/

         /* FINDING PARENT RECORD OF THE CONTAINER */
         for first abs_buff1
            fields (abs_domain abs_canceled abs_cmtindx abs_cons_ship
                    abs_dataset abs_fa_lot abs_format abs_gwt abs_id abs_item
                    abs_lang abs_line abs_loc abs_lotser abs_nwt
                    abs_order abs_par_id abs_qty abs_ref abs_shipfrom
                    abs_shipto abs_ship_qty abs_shp_date abs_site
                    abs_status abs_type abs_vol abs_vol_um
                    abs__qad02 abs__qad03 abs__qad06 abs__qad10)
            where   abs_buff1.abs_domain   = global_domain
            and     abs_buff1.abs_shipfrom = abs_buff2.abs_shipfrom
            and     abs_buff1.abs_id       = abs_buff2.abs_par_id
         no-lock:
            l_recid = recid(abs_buff1).
         end.

      end. /* IF SUBSTRING(ABS_BUFF2,ABS_ID,1,1) = "C"  */
      else
         l_recid = recid(abs_buff2).

      /* ROLLUP NET WEIGHT */
      {gprun.i ""icshnwt.p""
               "(input l_recid,
                 input l_abs_tot_net_wt,
                 input yes,
                 input part_wt_um)"}

      /* ROLLUP TARE WEIGHT */
      {gprun.i ""icshnwt.p""
               "(input l_recid,
                 input l_abs_tot_tare_wt,
                 input no,
                 input part_wt_um)"}

   end.   /* FOR FIRST ABS_BUFF2 */

   /*  DELETE qad_wkfl for KIT COMPONENTS */
   if can-find (first sob_det
      where sob_domain = global_domain
      and   sob_nbr = sod_nbr
      and   sob_line = sod_line)
   then
      {gprun.i ""rcshwbc4.p""
               "(input recid(sod_det))"}

   if cmf_flg  and det_all then
      run create-so-cmf
         (input recid (sod_det)).

   abnormal_exit = false.

end. /* main */

hide frame a no-pause.

{rcinvcon.i}


/* Internal procedure get_par_qty */
{soskit1c.i}

/* Internal procedure create-so-cmf */
{rccmf.i}

PROCEDURE val-fa-id:
   define input parameter part_fa_lot like wo_lot no-undo.
   define input parameter so_recid as recid no-undo.
   define output parameter err-flg as logical no-undo.

   find sod_det where recid(sod_det) = so_recid no-lock no-error.
   if not available sod_det then return.

   /* SWITCH TO THE REMOTE SITE */
   {gprun.i ""gpalias2.p""
            "(input sod_site, output error_flag)"}

   if error_flag <> 0 and error_flag <> 9 then do:
      /* UNABLE TO CONNECT TO REMOTE DOMAIN */
      run mess-6137 (disp-char6).
      err-flg = yes.
      leave.
   end.

   /* VALIDATE WORK ORDER POSSIBLY IN REMOTE DOMAIN */
   {gprun.i ""rcshvid.p""
            "(input part_fa_lot,
              input sod_fa_nbr,
              output err-flg)"}

   /* RESET TO CENTRAL DOMAIN */
   {gprun.i ""gpalias3.p""
            "(input so_db, output error_flag)"}

   if error_flag <> 0 and error_flag <> 9 then do:
      /* UNABLE TO CONNECT TO SALES DOMAIN */
      run mess-6137 (disp-char8).
      err-flg = yes.
      leave.
   end.

   /* CHECKING err-flg FROM rcshvid.p CALL HERE TO ALLOW DOMAIN SWITCHING */
   if err-flg = yes then
      leave.

   /* CHECK FOR DUPLICATE F/A WO ID                      */
   for each abs_buff
      where abs_buff.abs_domain = global_domain
      and   abs_buff.abs_order = sod_nbr
      and   abs_buff.abs_shipfrom = sod_site
      and   abs_buff.abs_line = string(sod_line)
   no-lock:

      if abs_buff.abs_fa_lot = part_fa_lot then do:

         run get_abs_parent
            (input abs_buff.abs_id,
             input abs_buff.abs_shipfrom,
             output par_absid,
             output par_shipfrom).

         if par_absid <> ? then do:

            find abs_tmp
               where abs_tmp.abs_domain = global_domain
               and   abs_tmp.abs_id = par_absid
               and   abs_tmp.abs_shipfrom = par_shipfrom
            no-lock no-error.

            if available abs_tmp
               and (abs_tmp.abs_canceled = no
               or substring(abs_tmp.abs_status,2,1) <> "y")
            then do:
               /* F/A WO ID exists for Pre-shipper/shipper  */
               {pxmsg.i &MSGNUM=5851 &ERRORLEVEL=3}
               err-flg = yes.
               leave.
            end.
         end.    /* par_absid */
      end.
   end.

   err-flg = no.

END PROCEDURE.

PROCEDURE p-get-open:
/*--------------------------------------------------------------------
 *  Purpose:     Calculates the open quantity for the sales order line
 *--------------------------------------------------------------------*/
   define input parameter l_sod_recid as recid no-undo.

   find sod_det where recid(sod_det) = l_sod_recid no-lock.
   {openqty.i}

END PROCEDURE.

PROCEDURE p_create_item:
/*--------------------------------------------------------------------
 *  Purpose:     Creates abs_mstr item records.
 *  Notes:       Rollup of item weights to its parents is not done here
 *---------------------------------------------------------------------*/
   /* INPUT PARAMETERS */
   define input parameter v_nbr_cyl2       like abs__chr01 . /*流水号*/       /*xp001*/
   define input parameter v_nbr_cyl4       like abs__chr02 . /*出货指示号*/   /*xp002*/
   define input parameter cont_shipfrom    like abs_shipfrom.
   define input parameter cont_shipto      like abs_shipto.
   define input parameter cont_id          like abs_id.
   define input parameter cont_parid       like abs_par_id.
   define input parameter cont_qty         like abs_qty.
   define input parameter cont_item        like abs_item.
   define input parameter cont_loc         like abs_loc.
   define input parameter cont_lot         like abs_lot.
   define input parameter cont_ref         like abs_ref.
   define input parameter cont_wt          like abs_nwt.
   define input parameter cont_wt_um       like abs_wt_um.
   define input parameter cont_vol         like abs_vol.
   define input parameter cont_vol_um      like abs_vol_um.
   define input parameter cont_site        like abs_site.
   define input parameter cont_qty_um      like abs__chr02.
   define input parameter cont_qty_conv    as decimal.
   define input parameter cont_gwt         like abs_gwt.
   define input parameter cont_order       like abs_order.
   define input parameter cont_line        like abs_line.
   define input parameter cmtindx          like abs_cmtindx.
   define input parameter part_fa_lot      like wo_lot.
   define input parameter using_cust_consignment as logical.
   define input-output parameter table     for tt_consign_shipment_detail.
   define parameter buffer ptmstr          for pt_mstr.

   /* OUTPUT PARAMETERS */
   define output parameter line_recno as recid.

   /* LOCAL VARIABLES */
   define variable l_abs_tare_wt like abs_nwt no-undo.
   define variable cont_level    as integer   no-undo.
   define variable cont_child    like abs_id  no-undo.
   define variable l_part_wt_conv as decimal  no-undo.

   /* BUFFERS */
   define buffer child_container for abs_mstr.

   assign
      cont_level = 1
      cont_child = 'NONE'.

   create abs_mstr.
   abs_mstr.abs_domain   = global_domain.
   assign
	  abs_mstr.abs__chr01   = v_nbr_cyl2  /*xp001*/
      abs_mstr.abs__chr02   = v_nbr_cyl4  /*xp002*/
      abs_mstr.abs_shipfrom = cont_shipfrom
      abs_mstr.abs_id       = cont_id
      abs_mstr.abs_shipto   = cont_shipto
      abs_mstr.abs_par_id   = cont_parid
      abs_mstr.abs_qty      = cont_qty
      abs_mstr.abs_shp_date = today
      abs_mstr.abs_type     = "S"
      abs_mstr.abs_item     = cont_item
      abs_mstr.abs_loc      = cont_loc
      abs_mstr.abs_lot      = cont_lot
      abs_mstr.abs__qad06   = string(cont_level,"99")
      abs_mstr.abs_ref      = cont_ref
      abs_mstr.abs_nwt      = max(cont_wt * cont_qty,0) * cont_qty_conv
      abs_mstr.abs_vol      = max(cont_vol * cont_qty * cont_qty_conv, 0)
      abs_mstr.abs_vol_um   = cont_vol_um
      abs_mstr.abs_wt_um    = cont_wt_um
      abs_mstr.abs_site     = cont_site
      abs_mstr.abs__qad02   = cont_qty_um
      abs_mstr.abs__qad03   = string(cont_qty_conv)
      abs_cmtindx           = cmtindx
      abs_mstr.abs_order    = cont_order
      abs_mstr.abs_line     = cont_line
      abs_mstr.abs_fa_lot   = part_fa_lot.

   if recid(abs_mstr) = -1 then .

   if using_cust_consignment then do:

      abs_mstr.abs__qadc01 = "".

      /* DETERMINE NATURE OF CONSIGNMENT RETURN */
      for first tt_consign_shipment_detail
         where sales_order = abs_mstr.abs_order
         and   order_line = integer(abs_mstr.abs_line)
         and   ship_from_site = abs_mstr.abs_site
         and   ship_from_loc = abs_mstr.abs_loc
         and   lot_serial = abs_mstr.abs_lotser
         and   reference = abs_mstr.abs_ref
      no-lock:

         if consigned_return_material then
            abs_mstr.abs__qadc01 = "yes".
      end.
   end.  /* IF using_cust_consignment */

   if available ptmstr then do:
      if pt_ship_wt_um <> pt_net_wt_um
      then do:
         {gprun.i ""gpumcnv.p""
                  "(input  pt_ship_wt_um,
                    input  pt_net_wt_um,
                    input  pt_part,
                    output l_part_wt_conv)"}

         if l_part_wt_conv = ? then do:
            /* NO UM CONVERSION EXISTS */
            {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
            l_part_wt_conv = 1.
         end. /* IF l_part_wt_conv = ? */
      end. /* IF pt_ship_wt_um <> pt_net_wt_um */
      else
         l_part_wt_conv = 1.

      l_abs_tare_wt  = max ((pt_ship_wt * cont_qty * cont_qty_conv
                             * l_part_wt_conv) -
                           (pt_net_wt * cont_qty * cont_qty_conv),0).

      if cont_wt_um <> pt_net_wt_um then do:
         {gprun.i ""gpumcnv.p""
                  "(input  pt_net_wt_um,
                    input  cont_wt_um,
                    input  pt_part,
                    output l_part_wt_conv)"}

         if l_part_wt_conv = ? then do:
            /* NO UM CONVERSION EXISTS */
            {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
            l_part_wt_conv = 1.
         end. /* IF l_part_wt_conv = ? */

         l_abs_tare_wt = l_abs_tare_wt * l_part_wt_conv.

      end. /* IF cont_wt_um <> pt_net_wt_um */
   end. /* IF AVAIL pt_mstr */
   else
      l_abs_tare_wt    = 0.

   {abspack.i "abs_mstr" 26 22 "l_abs_tare_wt"}

   abs_mstr.abs_gwt = abs_mstr.abs_nwt + l_abs_tare_wt.

   line_recno = recid(abs_mstr).

   /* ASSIGN NET WT TO GROSS WT IF ITEM SHIP WT IS ZERO  */
   /* IN PART MASTER                                     */
   if abs_mstr.abs_gwt = 0
      and abs_mstr.abs_nwt <> 0
    then
      abs_mstr.abs_gwt = abs_mstr.abs_nwt.

   /* ACCUMULATING WEIGHTS OF CHILD ITEMS TO BE ROLLED UP          */
   /* TO ITS PARENT                                                */
   assign
      l_abs_tot_tare_wt  = l_abs_tot_tare_wt + l_abs_tare_wt
      l_abs_tot_net_wt   = l_abs_tot_net_wt  + abs_mstr.abs_nwt
      l_total_tare_wt    = l_total_tare_wt   + l_abs_tare_wt
      l_total_net_wt     = l_total_net_wt    + abs_mstr.abs_nwt.

   if det_all then do:
      {abspack.i "abs_mstr" 3 22 "adj_qty / cont_qty_conv"}
   end. /* IF DET_ALL */

   if cont_child <> "NONE" then do:

      find child_container
         where child_container.abs_domain = global_domain
         and   child_container.abs_shipfrom = cont_shipfrom
         and   child_container.abs_id = cont_child
      exclusive-lock no-error.

      if available child_container then
         child_container.abs_par_id = abs_mstr.abs_id.

   end. /* IF CONT_CHILD <> "NONE" */

   if recid(abs_mstr) = -1 then.

END PROCEDURE.

PROCEDURE p_upd_ship_fob:
/*--------------------------------------------------------------------
 *  Purpose:     Updates the shipvia and fob of parent shipper with the
 *               corresponding values of alesorder of the first shipper
 *               line only if they are blank.
 *--------------------------------------------------------------------*/
   define input parameter l_temp_par   as   character  no-undo.
   define input parameter l_part_order like so_nbr     no-undo.

   define buffer abs_buff3 for abs_mstr.
   define buffer abs_buff4 for abs_mstr.

   do for abs_buff3:

      find first abs_buff3
         where recid(abs_buff3) =
            integer(substring(l_temp_par,(index(l_temp_par,"::") + 2)))
      exclusive-lock no-error.

      if available abs_buff3
         and (right-trim(substring(abs_buff3.abs__qad01,1,20)) = ""
         or   right-trim(substring(abs_buff3.abs__qad01,21,20)) = ""
         or   right-trim(substring(abs_buff3.abs__qad01,41,20)) = "")
      then do for abs_buff4:

         for first abs_buff4
            fields (abs_domain abs_shipfrom abs_par_id abs_id)
            where   abs_buff4.abs_domain = global_domain
            and     abs_buff4.abs_shipfrom = abs_buff3.abs_shipfrom
            and     abs_buff4.abs_par_id   = abs_buff3.abs_id
            and     abs_buff4.abs_id begins "i"
         no-lock: end.

         if not available abs_buff4 then do:

            for first so_mstr
               fields (so_domain so_nbr so_shipvia so_fob so_bol
                       so_bill  so_conrep so_cust so_fr_terms so_fsm_type
                       so_po so_sched so_secondary so_seq_order so_ship
                       so_stat)
               where   so_domain = global_domain
               and     so_nbr = l_part_order
            no-lock:
               if right-trim(substring(abs_buff3.abs__qad01,1,20)) = "" then
                  substring(abs_buff3.abs__qad01,1,20) =
                     string(so_shipvia,"x(20)").

               if right-trim(substring(abs_buff3.abs__qad01,21,20)) = "" then
                  substring(abs_buff3.abs__qad01,21,20) =
                     string(so_fob,"x(20)").

               if right-trim(substring(abs_buff3.abs__qad01,41,20)) = "" then
                  substring(abs_buff3.abs__qad01,41,20) =
                     string(so_bol,"x(20)").

            end. /* FOR FIRST SO_MSTR */
         end. /* IF NOT AVAILABLE ABS_BUFF4 */
      end. /* IF AVAILABLE ABS_BUFF3 */
   end. /* DO FOR ABS_BUFF3 */

END PROCEDURE.

PROCEDURE assign_part_defaults:

   assign
      part_loc          = sod_det.sod_loc
      part_site         = ship_from
      part_qty          = 0
      part_qty_um       = if available pt_mstr then
                             pt_mstr.pt_um
                          else
                             sod_um
      part_qty_conv     = 1
      part_wght         = if available pt_mstr then pt_net_wt else 0
      part_wt_um        = if available pt_mstr then pt_net_wt_um else ""
      part_vol          = if available pt_mstr then pt_size else 0
      part_vol_um       = if available pt_mstr then pt_size_um else ""
      part_lot_ser      = ""
      part_ref          = ""
      multiple          = false
      lotserial_control = if available pt_mstr then pt_lot_ser else ""
      cmmts             = false
      global_part       = if available pt_mstr then pt_part else part_item.

END PROCEDURE.

PROCEDURE assign_multiple_info:

   assign
      cline = ""
      site = part_site
      location = part_loc
      lotserial = part_lot_ser
      lotserial_qty = part_qty
      trans_um = part_qty_um
      trans_conv = part_qty_conv
      lotnext = ""
      lotprcpt = no
      lotref = part_ref.

END PROCEDURE.

PROCEDURE calc_container_weights:

   if l_pt_ship_wt = 0 and part_wght <> 0 then
      /* ASSIGN NET WT TO GROSS WT IF ITEM SHIP WT IS ZERO  */
      /* IN PART MASTER                                     */
      assign
         parent_container.abs_nwt =
            parent_container.abs_nwt +
               max(part_wght * this_rec_qty2 * part_qty_conv,0) * l_conv
         parent_container.abs_gwt =
            parent_container.abs_gwt +
               max(part_wght * this_rec_qty2 * part_qty_conv,0) * l_conv.

   else
      assign
         parent_container.abs_nwt = parent_container.abs_nwt +
            max(part_wght * this_rec_qty2 * part_qty_conv,0) * l_conv
         parent_container.abs_gwt = parent_container.abs_gwt +
            (l_total_tare_wt + l_total_net_wt) * l_conv.

   if parent_container.abs_wt_um = "" then
      parent_container.abs_wt_um = part_wt_um.

END PROCEDURE.

PROCEDURE mess-764:
   /* SALES ORDER LINE DOES NOT EXIST */
   {pxmsg.i &MSGNUM=764 &ERRORLEVEL=3}

END PROCEDURE.

PROCEDURE mess-6137:
   define input parameter messtext as character.

   /* DOMAIN # IS NOT AVAILABLE */
   {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=messtext}

END PROCEDURE.

PROCEDURE check-reserved-location:
/*--------------------------------------------------------------------
 *  Purpose:    Check if Reserved Locations to be used is valid.
 *--------------------------------------------------------------------*/

   ret-flag = 2.

   /* Bypass checking SSM orders */
   if so_mstr.so_fsm_type = "" then do:
     {gprun.i ""sorlchk.p""
              "(input so_ship,
                input so_bill,
                input so_cust,
                input part_site,
                input part_loc,
                output ret-flag)"}
   end.

END PROCEDURE.

PROCEDURE delete-srwkfl:
   /* DELETE OLD SR_WKFL RECORDS */
   {gprun.i ""rcshmtb1.p""
            "(input mfguser,
              input cline,
              input no,
              input ship_from)"}
END PROCEDURE.


FUNCTION prm-ssm-error-checking returns logical ():

   for first so_mstr
      where so_mstr.so_domain = global_domain
      and   so_mstr.so_nbr = part_order
   no-lock:
      if so_mstr.so_fsm_type = "PRM" then do:
         /* USE PRM MODULE TRANSACTIONS FOR PRM PENDING INVOICES */
         {pxmsg.i &MSGNUM=3434 &ERRORLEVEL=4}
         return yes.
      end.
      else if so_mstr.so_fsm_type <> "" then do:
         /* USE SSM MODULE TRANSACTIONS FOR SSM ORDERS */
         {pxmsg.i &MSGNUM=1933 &ERRORLEVEL=4}
         return yes.
      end.
   end. /* FOR FIRST SO_MSTR */

   return no.

END FUNCTION. /* prm-ssm-error-checking */

PROCEDURE CreateUserFields:
   define input parameter ipShipFrom like abs_shipfrom no-undo.
   define input parameter ipShipTo like abs_shipto no-undo.
   define input parameter ipAbsID like abs_id no-undo.

   /* CREATE LINE LEVEL USER FIELDS */
   {gprunmo.i &program = ""sosob1b.p"" &module  = "ACL"
              &param   = """(input ipAbsID,
                             input ipShipFrom,
                             input ipShipTo,
                             input 2)"""}
END PROCEDURE. /*CreateUserFields*/

PROCEDURE CreateLineCharges:
   define input parameter ipAbsID like abs_id no-undo.
   define input parameter ipShipFrom like abs_shipfrom no-undo.
   define input parameter ipOrder like abs_order no-undo.
   define input parameter ipLine like sod_line no-undo.

   {gprunmo.i &program = ""sosob1c.p"" &module = "ACL"
              &param   = """(input ipAbsID,
                             input ipShipFrom,
                             input ipOrder,
                             input ipLine)"""}
END PROCEDURE. /* CreateLineCharges */

PROCEDURE getUserFieldData:
   define input parameter ipAbsID like abs_id no-undo.
   define input parameter ipShipFrom like abs_shipfrom no-undo.

   define variable vFieldCounter as integer no-undo.
   define variable vFieldList as character no-undo.
   define variable vFieldName as character no-undo.


   vFieldList = "part_item,item_description,part_po,part_order," +
                "part_order_line,part_qty,part_site," +
                "part_qty_um,part_loc,part_qty_conv," +
                "part_lot_ser,sod_type,part_ref,part_wght," +
                "part_wt_um,multiple,part_vol,part_vol_um," +
                "cmmts,part_fa_lot,det_all,ship_avail_qty".

    do vFieldCounter = 1 to num-entries(vFieldList,","):
       vFieldName = entry(vFieldCounter,vFieldList,",").

        if can-find(first absd_det
           where absd_domain = global_domain
           and   absd_abs_id = ipAbsID
           and   absd_shipfrom = ipShipFrom
           and   absd_abs_fld_name = vFieldName
           and   absd_fld_prompt = yes)
        then do:
           {gprunmo.i &program = ""rcswbuf.p"" &module = "ACL"
                      &param   = """(input yes,
                                     input vFieldName,
                                     input ipAbsID,
                                     input ipShipFrom)"""}
        end. /* IF CAN-FIND */
    end. /* DO vFieldCounter = 1 TO */

    if can-find(first absd_det
       where absd_det.absd_domain = global_domain
       and   absd_abs_id = ipAbsID
       and   absd_shipfrom = ipShipFrom
       and   absd_abs_fld_name = ""
       and   absd_fld_prompt = yes)
    then do:

       {gprunmo.i &program = ""rcswbuf.p"" &module  = "ACL"
                  &param   = """(input no,
                                 input "''",
                                 input ipAbsID,
                                 input ipShipFrom)"""}
    end. /* IF CAN_FIND */
END PROCEDURE. /* getUserFieldData */

PROCEDURE getLineCharges:
   define input parameter ipAbsID like abs_id no-undo.
   define input parameter ipShipFrom like abs_shipfrom no-undo.
   define input parameter ipSoRecID as recid no-undo.
   define input parameter ipSodRecID as recid no-undo.

   {gprunmo.i &program = ""rcabslmt.p"" &module  = "ACL"
              &param   = """(input ipSoRecID,
                             input ipSodRecID,
                             input ipAbsID,
                             input ipShipFrom)"""}
END PROCEDURE. /* getLineCharges */

PROCEDURE DisplayMessage:
   define input parameter ipMsgNum as integer no-undo.
   define input parameter ipLevel  as integer no-undo.
   define input parameter ipMsg1   as character no-undo.
   define input parameter ipMsg2   as character no-undo.

   {pxmsg.i &MSGNUM     = ipMsgNum
            &ERRORLEVEL = ipLevel
            &MSGARG1    = ipMsg1
            &MSGARG2    = ipMsg2}

END PROCEDURE. /* PROCEDURE DisplayMessage */

PROCEDURE validateSOFrTerms:
/*--------------------------------------------------------------------
 *  Purpose:     Get the highest level parent (Shipper record)
 *               Get the first order attached to this shipper along with
 *                  the freight terms on this order.
 *               Compare the terms on this order to that of the input parameter
 *                 ip_OrderFrTerms and return op_FrTermsErr if they are
 *                 different.
 *----------------------------------------------------------------------*/
   define input parameter ip_AbsId        like   abs_id       no-undo.
   define input parameter ip_ShipFrom     like   abs_shipfrom no-undo.
   define input parameter ip_TempParent   as   character    no-undo.
   define input parameter ip_Order        like so_nbr  no-undo.
   define input parameter ip_OrderFrTerms like so_fr_terms  no-undo.

   define output parameter op_FrTermsOnFirstOrder as character  no-undo.
   define output parameter op_FrTermsErr like mfc_logical  no-undo.

   define buffer b1_abs_mstr for abs_mstr.
   define buffer b2_abs_mstr for abs_mstr.

   define variable par_absid like abs_id no-undo.
   define variable par_shipfrom like abs_shipfrom no-undo.
   define variable l_FirstOrder like so_nbr no-undo.

   l_FirstOrder = "".

   if ip_AbsId <> ? then
      run get_abs_parent (input ip_AbsId,
                          input ip_ShipFrom,
                          output par_absid,
                          output par_shipfrom).
   else do:
      for first b1_abs_mstr
         where recid(b1_abs_mstr) =
         integer(substring(ip_TempParent,(index(ip_TempParent,"::") + 2)))
      no-lock:

         run get_abs_parent (input b1_abs_mstr.abs_id,
                             input b1_abs_mstr.abs_shipfrom,
                             output par_absid,
                             output par_shipfrom).
      end.
   end. /* ELSE, IF ABS_D <> ? AND ... */

   if par_absid <> ? then
   do for b2_abs_mstr:

      for first b2_abs_mstr
         where b2_abs_mstr.abs_domain = global_domain
         and   b2_abs_mstr.abs_id = par_absid
         and   b2_abs_mstr.abs_shipfrom = par_shipfrom
      no-lock: end.

      if available b2_abs_mstr then do:
         {gprunmo.i  &module = "LA" &program = "lashex01.p"
                     &param  = """(buffer b2_abs_mstr,
                                   output l_FirstOrder,
                                   output op_FrTermsOnFirstOrder)"""}

         /* IF THERE IS AN ORDER ATTACHED TO THE PARENT ABS_MSTR,   */
         /* COMPARE THE FREIGHT TERMS ON THAT ORDER TO THOSE ON THE */
         /* ORDER BEING ATTACHED.                                   */
         if l_FirstOrder <> "" and
            op_FrTermsOnFirstOrder <> ip_OrderFrTerms then
         do:
            op_FrTermsErr = true.
            return.
         end. /* IF l_FirstOrder <> "" AND... */

      end. /* IF AVAILABLE B2_ABS_MSTR */
   end. /* DO FOR B2_ABS_MSTR */

END PROCEDURE. /* validateSOFrTerms */
