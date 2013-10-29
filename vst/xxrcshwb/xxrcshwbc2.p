/* rcshwbc2.p  - SHIPPER WORKBENCH - SUB PROGRAM - ADD ITEM                  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=Maintenance                                                 */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                      */
/* VERSION 7.5        LAST MODIFIED: 07/18/95           BY: GWM *J049*       */
/* VERSION 8.5        LAST MODIFIED: 04/12/96           BY: GWM *J0J1*       */
/* VERSION 8.5        LAST MODIFIED: 06/12/96           BY: GWM *J0R3*       */
/* VERSION 8.6        LAST MODIFIED: 08/01/96   BY: *K003* Vinay Nayak-Sujir */
/* VERSION 8.6        LAST MODIFIED: 10/30/96   BY: *K003* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *K003* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 12/09/96   BY: *K022* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 01/24/97   BY: *K051* Kieu Nguyen       */
/* REVISION: 8.5      LAST MODIFIED: 03/24/97   BY: *J1LY* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 05/09/97   BY: *K0CZ* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 06/12/97   BY: *K0DL* Arul Victoria     */
/* REVISION: 8.6      LAST MODIFIED: 06/17/97   BY: *J1T4* Seema Varma       */
/* REVISION: 8.6      LAST MODIFIED: 06/27/97   BY: *K0FH* Taek-Soo Chang    */
/* REVISION: 8.6      LAST MODIFIED: 07/12/97   BY: *K0DH* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 08/21/97   BY: *J1ZC* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 08/25/97   BY: *J1YJ* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 11/03/97   BY: *J22N* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 11/11/97   BY: *K18W* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 11/24/97   BY: *J26V* Manish K.         */
/* REVISION: 8.6      LAST MODIFIED: 11/24/97   BY: *K15N* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 01/28/98   BY: *J2CY* Manish K.         */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/98   BY: *J2F2* Samir Bavkar      */
/* REVISION: 8.6E     LAST MODIFIED: 04/06/98   BY: *J2CQ* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 04/12/98   BY: *J2J4* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *K1NF* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *J2LW* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *J2MH* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *J2NQ* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 07/17/98   BY: *J2QT* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 07/22/98   BY: *J2M7* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2S5* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 08/11/98   BY: *K1VC* Dana Tunstall     */
/* REVISION: 9.0      LAST MODIFIED: 11/09/98   BY: *J33X* Seema Varma       */
/* REVISION: 9.0      LAST MODIFIED: 11/19/98   BY: *J34T* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *J35D* Manish K.         */
/* REVISION: 9.0      LAST MODIFIED: 01/06/99   BY: *K1YR* Raphael Thoppil   */
/* REVISION: 9.0      LAST MODIFIED: 01/12/99   BY: *J37V* Seema Varma       */
/* REVISION: 9.0      LAST MODIFIED: 02/02/99   BY: *J394* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 04/09/99   BY: *K20D* Anup Pereira      */
/* REVISION: 9.1      LAST MODIFIED: 06/23/99   BY: *N00F* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 08/18/99   BY: *K223* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 09/16/99   BY: *K21D* Poonam Bahl       */
/* REVISION: 9.1      LAST MODIFIED: 10/05/99   BY: *K21N* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 11/03/99   BY: *J3L5* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 11/27/99   BY: *N004* Patrick Rowan     */
/* REVISION: 9.1      LAST MODIFIED: 12/07/99   BY: *M0GG* Kedar Deherkar    */
/* REVISION: 9.1      LAST MODIFIED: 12/20/99   BY: *L0M0* Manish K.         */
/* REVISION: 9.1      LAST MODIFIED: 01/13/00   BY: *K23K* Manish K.         */
/* REVISION: 9.1      LAST MODIFIED: 01/28/00   BY: *K21C* Sachin Shinde     */
/* REVISION: 9.1      LAST MODIFIED: 03/02/00   BY: *N03S* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Luke Pokic        */
/* REVISION: 9.1      LAST MODIFIED: 03/14/00   BY: *K23Q* Abhijeet Thakur   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 03/28/00   BY: *K25V* Surekha Joshi     */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *K250* Surekha Joshi     */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *L107* Ashwini G.        */
/* REVISION: 9.1      LAST MODIFIED: 07/05/00   BY: *N0F4* Rajinder Kamra    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* REVISION: 9.1      LAST MODIFIED: 12/28/00   BY: *L13Y* Kaustubh K.       */
/* REVISION: 9.1      LAST MODIFIED: 10/06/00   BY: *N0WT* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 01/24/01   BY: *L14B* Satish Chavan     */
/* REVISION: 9.1      LAST MODIFIED: 02/26/01   BY: *M12F* Rajaneesh S.      */
/* REVISION: 9.1      LAST MODIFIED: 04/19/01   BY: *M15M* Nikita Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 05/18/01   BY: *M16B* Rajesh Kini       */
/* REVISION: 9.1      LAST MODIFIED: 05/28/01   BY: *M18K* Kaustubh K.       */
/* REVISION: 9.1      LAST MODIFIED: 11/09/01   BY: *N160* Ashwini G.        */
/* REVISION: 9.1      LAST MODIFIED: 11/30/01   BY: *M1Q0* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 01/24/02   BY: *M1TT* Mercy C.          */

/*L14B*/ /* REPLACED qty_ratio WITH part_qty / part2_qty       */
     {mfdeclre.i}
/*N0WT*/ {cxcustom.i "RCSHWBC2.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rcshwbc2_p_1 "Purchase Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwbc2_p_2 " Item Information "
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwbc2_p_3 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwbc2_p_5 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwbc2_p_7 "Item Number"
/* MaxLen: Comment: */

/*N0F4
 * &SCOPED-DEFINE rcshwbc2_p_4 "Issue"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE rcshwbc2_p_6 "'For Remote Inventory'"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE rcshwbc2_p_8 "'For Sales Orders'"
 * /* MaxLen: Comment: */
 *N0F4*/

&SCOPED-DEFINE rcshwbc2_p_9 "Line"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwbc2_p_10 "Conversion"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwbc2_p_11 "Detail Alloc"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwbc2_p_12 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwbc2_p_13 "Ship Avail Qty For Kit"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwbc2_p_14 "Sales Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwbc2_p_15 "Volume"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     /* INPUT PARAMETERS */
/*K003*/ define input parameter absid like abs_id no-undo.
     define input parameter ship_from as character.
     define input parameter temp_parent as character.
     define input parameter ship_to as character.

     /* OUTPUT PARAMETERS */
     define output parameter abnormal_exit as logical.

     /* LOCAL VARIABLES */
     define variable part_item like pt_part
        label {&rcshwbc2_p_7} no-undo.
     define variable part_site like abs_site no-undo.
     define variable item_description like pt_desc1 format "X(20)" no-undo.
     define variable item_description_2 like pt_desc2 format "X(20)"
        no-undo.
     define variable part_loc like abs_loc no-undo.
     define variable part_wght like pt_net_wt no-undo.
     define variable part_wt_um like pt_net_wt_um no-undo.
     define variable part_vol like pt_size
        label {&rcshwbc2_p_15} no-undo.
     define variable part_vol_um like pt_size_um no-undo.
     define variable multiple like mfc_logical
        label {&rcshwbc2_p_5} no-undo.
     define variable nullstr as character no-undo.
     define variable undotran as logical no-undo.
     define variable i as integer no-undo.
     define variable part_qty like sr_qty no-undo.
     define variable part_lot_ser like abs_lot no-undo.
     define variable part_ref like abs_ref label {&rcshwbc2_p_12} no-undo.
     define variable qty_to_set as integer no-undo.
     define variable qty_per as integer no-undo.
     define variable qty_modulo as integer no-undo.
     define variable part_qty_um like pt_um no-undo.
     define variable part_qty_conv like um_conv
        label {&rcshwbc2_p_10} no-undo.
     define variable num_containers as integer no-undo.
     define variable this_rec_qty as integer no-undo.
     define variable part_po like sod_contr_id
        label {&rcshwbc2_p_1} no-undo.
     define variable part_order like abs_order
        label {&rcshwbc2_p_14} no-undo.
     define variable part_order_line like abs_line
        label {&rcshwbc2_p_9} no-undo.
     define variable error_flag as integer no-undo.
     define variable ship_db as character no-undo.
/*K003*/ define variable cons_ok as logical no-undo.
/*K003*/ define variable shipgrp like sgad_grp no-undo.
/*K003*/ define variable cmmts like mfc_logical label {&rcshwbc2_p_3}
/*K003*/    no-undo.
/*K003*/ define variable other_so like so_nbr no-undo.
/*K003*/ define variable par_absid like abs_id no-undo.
/*K003*/ define variable par_shipfrom like abs_shipfrom no-undo.
/*K003*/ define variable first_parent like mfc_logical no-undo.
/*K003*/ define variable det_all like mfc_logical label {&rcshwbc2_p_11}
/*K003*/    no-undo.
/*K003*/ define variable part_fa_lot like wo_lot no-undo.
/*K003*/ define variable qty_ratio like sod_qty_all no-undo.
/*K003*/ define variable totallqty like sod_qty_all no-undo.
/*K003*/ define variable process_type as integer no-undo.
/*K003*/ define variable kit_comp like mfc_logical no-undo.
/*K003*/ define variable shp_canceled like mfc_logical no-undo.
/*K003*/ define variable new_id like abs_id no-undo.
/*K003*/ define variable errornum as integer no-undo.
/*K003*/ define variable all_days like soc_all_days no-undo.
/*K003*/ define variable new_qty_all as logical no-undo.
/*K003*/ define variable new_qty_set like sod_qty_all no-undo.
/*K022*/ define variable ship_avail_qty like mfc_logical
/*K022*/    label {&rcshwbc2_p_13} no-undo.
/*K022*/ define variable new_par_qty like sod_qty_all no-undo.
/*K022*/ define variable cmf_flg as logical no-undo.
/*K18W*/ define variable adj_qty like ld_qty_all no-undo.
/*K18W*/ define variable stage_open as logical initial no no-undo.
/*J26V*/ define variable this_rec_qty2 like abs_qty no-undo.
/*J2F2*/ define variable shipto_id as character no-undo.
/*J2F2*/ define variable addr as character no-undo.
/*J2CQ*/ define variable del_lad like mfc_logical no-undo.

/*J2LW*/ define variable l_abs_pick_qty like sod_qty_pick no-undo.
/*J2LW*/ define variable v_unpicked_qty like sod_qty_pick no-undo.
/*J2LW*/ define variable open_qty       like sod_qty_pick no-undo.
/*J37V*/ define variable l_sod_all      like sod_qty_all  no-undo.
/*K21D*/ define variable l_abs_tot_tare_wt like abs_nwt    no-undo.
/*K21D*/ define variable l_abs_kit_tare_wt like abs_nwt    no-undo.
/*K21D*/ define variable l_abs_tot_net_wt  like abs_nwt    no-undo.
/*K21D*/ define variable l_pt_ship_wt      like pt_ship_wt no-undo.
/*K21D*/ define variable l_recid           as   recid      no-undo.
/*K21D*/ define variable l_par_cont        like abs_id     no-undo.
/*K21D*/ define variable l_conv            as   decimal    no-undo.
/*L0M0*/ define variable l_delproc         like mfc_logical no-undo.
/*K23K*/ define variable l_prev_um         like pt_um       no-undo.
/*K25V*/ define variable l_errors          like mfc_logical no-undo.

/*N160*/ define variable l_total_tare_wt   like abs_nwt    no-undo.
/*N160*/ define variable l_total_net_wt    like abs_nwt    no-undo.
/*M1Q0*/ define variable l_sodall          like mfc_logical no-undo.

/*N00F*/ define     shared  variable window_recid     as   recid.
         define variable WHEN_SO_HOLD_DISABL_SHIP as integer initial 2.
/*K003*/ define new shared variable cmtindx like cmt_indx.
/*K003*/ {rcinvtbl.i new}
/*L13Y*/ {soabsdef.i new}

     /* OUTPUT VARIABLES */
     define new shared variable new_site as character.
     define new shared variable so_db as character.
     define new shared variable err_stat as integer.
/*J0J1*/ define variable lotnext like wo_lot_next.
/*J0J1*/ define variable lotprcpt like wo_lot_rcpt no-undo.
/*K003*/ define variable line_recno as recid no-undo.

     /* SHARED VARIABLES TO CALL EXISTING CODE */
     define new shared variable multi_entry as log no-undo.
     define new shared variable cline as character.
     define new shared variable lotserial_control like pt_lot_ser.
     define new shared variable issue_or_receipt as character
/*N0F4* initial {&rcshwbc2_p_4} */ .
     define new shared variable total_lotserial_qty like sr_qty.
     define new shared variable site like sr_site no-undo.
     define new shared variable location like sr_loc no-undo.
     define new shared variable lotserial like sr_lotser no-undo.
     define new shared variable lotserial_qty like sr_qty no-undo.
     define new shared variable trans_um like pt_um.
     define new shared variable trans_conv like sod_um_conv.
     define new shared variable transtype as character initial "ISS-SO".
     define new shared variable lotref like sr_ref no-undo.
/*J2S5** define new shared variable ship_so like sod_site. */
/*J2S5** define new shared variable ship_line like sod_line. */

/*J2S5*/ define shared variable ship_so   like so_nbr.
/*J2S5*/ define shared variable ship_line like sod_line.

/*N05Q*/ FUNCTION prm-ssm-error-checking returns logical () forward.

/*K003*  define new shared workfile work_sr_wkfl like sr_wkfl.             */
/*K003*/ define new shared temp-table work_sr_wkfl like sr_wkfl.

/*N0F4*/ define variable disp-char6 as character no-undo.
/*N0F4*/ define variable disp-char8 as character no-undo.

/*N0F4*/ assign disp-char6 = getTermLabel("'FOR_REMOTE_INVENTORY'",30)
                disp-char8 = getTermLabel("'FOR_SALES_ORDERS'",30)
                issue_or_receipt = getTermLabel("ISSUE",8).

     /* BUFFERS */
     define buffer parent_container for abs_mstr.
/*K003*/ define buffer abs_buff for abs_mstr.
/*K003*/ define buffer abs_tmp for abs_mstr.
/*K21D*/ define buffer abs_buff1 for abs_mstr.
/*K21D*/ define buffer abs_buff2 for abs_mstr.

/*N004*/ /* VARIABLE DEFINITIONS FOR gpfile.i */
/*N004*/ {gpfilev.i}

     /* FORM FOR ADD CONTAINERS */
     form part_item colon 25
          item_description no-label
          part_po colon 25
          part_order colon 25
          part_order_line skip(1)
          part_qty colon 25
          part_site colon 54
          part_qty_um colon 25
          part_loc colon 54
          part_qty_conv colon 25
          part_lot_ser colon 54
/*J1LY*/      sod_type colon 25
          part_ref colon 54
          part_wght colon 25
          part_wt_um no-label
          multiple colon 54
          part_vol colon 25
/*K003*       part_vol_um no-label skip(1) */
/*K003*/      part_vol_um no-label
/*K003* /*K003*/      cmmts    colon 54 skip(1)                 */
/*K003*/      cmmts    colon 54
/*K003*/      part_fa_lot colon 25
/*K003*/      det_all  colon 54 /*  skip(1)    */
/*K022*/      ship_avail_qty  colon 54 skip(1)
     with frame a width 80 side-labels
         title color normal (getFrameTitle("ITEM_INFORMATION",24)) attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

     /* INITIALIZE CENTRAL DATABASE ALIAS NAME */
/*L0M0*/ assign
            so_db = global_db
            abnormal_exit = true
/*L0M0*/    l_delproc = no
            cline = global_db + "rcshwbc2.p".

/*K21N*/ for first fac_ctrl
/*K21N*/    fields(fac_wo_rec) no-lock:
/*K21N*/ end. /* FOR FIRST FAC_CTRL */

/*K003*/ find first soc_ctrl no-lock no-error.
/*K003*/ assign det_all = soc_det_all
/*K003*/        all_days = soc_all_days
/*K003*/        shp_canceled = no.

     /* ADD OR CREATE CONTAINERS */
     MAIN:
     do on endkey undo MAIN, leave MAIN
     on error undo MAIN, retry MAIN:

            /* ADDING A KIT COMPONENT - DISPLAY PARENT'S ORDER # & LINE */
/*K003*/    kit_comp = no.
/*K003*/    if absid begins "i" then

/*N05Q   BEGIN DELETE
* /*K003*/    find abs_mstr where abs_id = absid and abs_shipfrom = ship_from
* /*K003*/       no-lock no-error.
* /*K003*/    if available abs_mstr then do:
* /*K003*/       display abs_order @ part_order
* /*K003*/               abs_line @ part_order_line with frame a.
* /*K003*/      assign part_order = abs_order
* /*K003*/         part_order_line = abs_line
* /*K003*/         kit_comp = yes.
* /*K003*/    end.
* N05Q   END DELETE */

/*K23Q*/    /* FIND SHIPPER MASTER RECORD USING SHIP-FROM ID AND ID TO  */
/*K23Q*/    /* IMPROVE PERFORMANCE                                      */
/*N05Q*/    for first abs_mstr
/*K23Q*/       fields(abs_canceled abs_cmtindx abs_cons_ship abs_dataset
/*K23Q*/              abs_fa_lot abs_format abs_gwt abs_id abs_item abs_lang
/*K23Q*/              abs_line abs_loc abs_lotser abs_nwt abs_order
/*K23Q*/              abs_par_id abs_qty abs_ref abs_shipfrom abs_shipto
/*K23Q*/              abs_ship_qty abs_shp_date abs_site abs_status abs_type
/*K23Q*/              abs_vol abs_vol_um abs_wt_um abs__qad01 abs__qad02
/*K23Q*/              abs__qad03 abs__qad06 abs__qad10)
/*K23Q** /*N05Q*/ where abs_id = absid and abs_shipfrom = ship_from  */
/*K23Q*/       where abs_shipfrom = ship_from
/*K23Q*/       and   abs_id       = absid
/*N05Q*/    no-lock:

/*N05Q*/       display abs_order @ part_order
/*N05Q*/               abs_line @ part_order_line with frame a.
/*N05Q*/       assign part_order      = abs_order
/*N05Q*/              part_order_line = abs_line
/*N05Q*/              kit_comp        = yes.
/*N05Q*/    end.

        set
           part_item
           part_po
           part_order when (not kit_comp)
           part_order_line when (not kit_comp)
        with frame a editing:

/*J1ZC*/ if frame-field = "part_item" then do:
           {mfnp.i sod_det
               part_item
               sod_part
               part_item
               sod_part
               sod_part}

/*N05Q  if recno <> ? then do: */
/*N05Q*/ if recno <> ? then

          display
             sod_part @ part_item
             sod_contr_id @ part_po
/*K003*          sod_nbr @ part_order                       */
/*K003*          string(sod_line) @ part_order_line         */
/*K003*/         sod_nbr when (not kit_comp) @ part_order
/*K003*/         part_order when (kit_comp)
/*K003*/         string(sod_line) when (not kit_comp) @ part_order_line
/*K003*/         part_order_line when (kit_comp)
          with frame a.
/*N05Q           end. */
/*J1ZC*/ end. /* IF FRAME-FIELD = "part_item" */

         else do:
            readkey.
            apply lastkey.
         end.

/*N00F*/ if window_recid <> ? then
/*N00F*/ do:
/*N00F*/    for first sod_det
/*N00F*/       fields(sod_cfg_type sod_confirm sod_contr_id sod_cum_qty
/*N00F*/              sod_desc sod_end_eff sod_fa_nbr sod_line sod_loc
/*N00F*/              sod_nbr sod_part sod_qty_all sod_qty_ord sod_qty_pick
/*N00F*/              sod_qty_ship sod_sched sod_site sod_start_eff sod_type
/*N00F*/              sod_um sod_um_conv)
/*N00F*/       where recid(sod_det) = window_recid no-lock:
/*N00F*/    end. /* FOR FIRST SOD_DET */
/*N00F*/    if available sod_det then
/*N00F*/    do:
/*N00F*/       display
/*N00F*/          sod_part @ part_item
/*N00F*/          sod_contr_id @ part_po
/*N00F*/          sod_nbr @ part_order
/*N00F*/          sod_line @ part_order_line
/*N00F*/       with frame a.
/*N00F*/    end. /* IF AVAILABLE SOD_DET */
/*N00F*/    window_recid = ?.
/*N00F*/ end.  /* IF WINDOW_RECID <> ? */
        end.
/*K21C*/ /* THIS PROCEDURE UPDATES THE SHIP-VIA AND FOB FOR A SHIPPER */
/*K21C*/ run p_upd_ship_fob(input temp_parent, input part_order).

/*J2NQ*/ if (part_order_line <> "") then
/*J2NQ*/    part_order_line = left-trim(part_order_line).

/* N05Q  BEGIN DELETE
* /*J1YJ*/ find so_mstr where so_nbr = part_order no-lock no-error.
* /*J1YJ*/ if available so_mstr and so_fsm_type <> "" then do:
* /*J1YJ*/    /* USE SSM MODULE TRANSACTIONS FOR SSM ORDERS */
* /*J1YJ*/    {mfmsg.i 1933 4}
* /*J1YJ*/    undo MAIN, retry MAIN.
* /*J1YJ*/ end.
* N05Q   END DELETE */

/*N05Q*/ if prm-ssm-error-checking() then undo MAIN, retry MAIN.

        /* VALIDATE IF VALID SALES ORDER LINE */
/*M16B** find sod_det where sod_nbr = part_order                   */
/*M16B** and sod_line = integer(part_order_line) no-lock no-error. */

/*M16B*/ for first sod_det
/*M16B*/    fields(sod_cfg_type sod_confirm   sod_contr_id sod_cum_qty
/*M16B*/           sod_desc     sod_end_eff   sod_fa_nbr   sod_line
/*M16B*/           sod_loc      sod_nbr       sod_part     sod_qty_all
/*M16B*/           sod_qty_ord  sod_qty_pick  sod_qty_ship sod_sched
/*M16B*/           sod_site     sod_start_eff sod_type     sod_um
/*M1TT*/           sod_btb_type
/*M16B*/           sod_um_conv)
/*M16B*/    where sod_nbr          = part_order
/*M16B*/    and   string(sod_line) = part_order_line
/*M16B*/    no-lock:
/*M16B*/ end. /* FOR FIRST sod_det */

/*M1TT*/ if available sod_det
/*M1TT*/    and sod_btb_type = "03"
/*M1TT*/ then do:
/*M1TT*/    /* SHIPMENT NOT ALLOWED FOR DIR-SHIP EMT SALES ORDER */
/*M1TT*/    run DisplayMessage (input 3985,
/*M1TT*/                        input 3,
/*M1TT*/                        input '').
/*M1TT*/    undo MAIN, retry MAIN.
/*M1TT*/ end. /* IF AVAILABLE sod_det AND sod_btb_type = "03" */

        if not available sod_det then do:

/*N05Q   START DELETE
*            /* TRY THE PART PO COMBINATION */
*            find first sod_det where sod_part = part_item
*            and sod_contr_id = part_po no-lock no-error.
*
*            if not available sod_det then do:
*
*           {mfmsg.i 764 3} /* SALES ORDER LINE DOES NOT EXIST */
*           undo MAIN, retry MAIN.
*            end.
*
*            else do:
*
* /*K003*/          if not kit_comp then assign
*              part_order = sod_nbr
*              part_order_line = string(sod_line).
*
*            end.
* N05Q   END DELETE */

/*N05Q*/     /* TRY THE PART PO COMBINATION */
/*N05Q*/     for first sod_det
/*M16B*/        fields(sod_cfg_type sod_confirm   sod_contr_id sod_cum_qty
/*M16B*/               sod_desc     sod_end_eff   sod_fa_nbr   sod_line
/*M16B*/               sod_loc      sod_nbr       sod_part     sod_qty_all
/*M16B*/               sod_qty_ord  sod_qty_pick  sod_qty_ship sod_sched
/*M16B*/               sod_site     sod_start_eff sod_type     sod_um
/*M16B*/               sod_um_conv)
/*N05Q*/      where sod_part     =  part_item
/*M16B*/      and   sod_part     <> ""
/*N05Q*/      and   sod_contr_id =  part_po
/*M16B*/      and   sod_contr_id <> ""
/*N05Q*/      no-lock:
/*N05Q*/         if not kit_comp then
/*N05Q*/            assign part_order = sod_nbr
/*N05Q*/                   part_order_line = string(sod_line).
/*N05Q*/      end.

/*N05Q*/     if not available sod_det then do:
/*N05Q*/        run mess-764.
/*N05Q*/        undo MAIN, retry MAIN.
/*N05Q*/     end.

/*N05Q*/ end. /* IF NOT AVAILABLE SOD_DET */

            /* ALLOW ADDING A KIT COMPONENT TO A KIT PARENT SHIPPER */
        /* INPUT PART NUMBER IS REQUIRED FOR KIT COMPONENT      */
/*K003*/    if available abs_mstr and absid begins "i" then do:
/*K003*/       if part_item = "" then do:
/*K003*/      {mfmsg.i 40 3}
         /* BLANK NOT ALLOWED  */
/*K003*/      next-prompt part_item with frame a.
/*K003*/      undo MAIN, retry MAIN.
/*K003*/       end.
/*K003*/       if (abs_item = part_item) then do:
/*K003*/          {mfmsg.i 599 3 }   /* CYCLIC RELATIONSHIP NOT ALLOWED */
/*K003*/          next-prompt part_item with frame a.
/*K003*/          undo MAIN, retry MAIN.
/*K003*/       end.
/*K003*/    end.

/*K23Q**    BEGIN DELETE
 * /*K003*/    find abs_mstr where abs_id = absid and abs_shipfrom = ship_from
 * /*K003*/     no-lock no-error.
 *K23Q**    END DELETE  */

/*K23Q*/    /* FIND SHIPPER MASTER RECORD USING SHIP-FROM ID AND ID TO  */
/*K23Q*/    /* IMPROVE PERFORMANCE                                      */
/*K23Q*/    for first abs_mstr
/*K23Q*/       fields(abs_canceled abs_cmtindx abs_cons_ship abs_dataset
/*K23Q*/              abs_fa_lot abs_format abs_gwt abs_id abs_item abs_lang
/*K23Q*/              abs_line abs_loc abs_lotser abs_nwt abs_order abs_par_id
/*K23Q*/              abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
/*K23Q*/              abs_shp_date abs_site abs_status abs_type abs_vol
/*K23Q*/              abs_vol_um abs_wt_um abs__qad01 abs__qad02 abs__qad03
/*K23Q*/              abs__qad06 abs__qad10)
/*K23Q*/       where abs_shipfrom = ship_from
/*K23Q*/       and   abs_id       = absid no-lock:
/*K23Q*/    end. /* FOR FIRST ABS_MSTR */

/*K003*/    if available abs_mstr then do:

           /* If shipper consolidation is no, then check whether we
          are putting more than one SO on the shipper */
/*K003*/       if abs_cons_ship = "0" then do:
/*K003*/          run chk_abs_shp_cons (input abs_id, input abs_shipfrom,
                    input "", input "", input part_order,
                    output cons_ok, output other_so).
/*K003*/      if not cons_ok then do:
/*K003*/         {mfmsg03.i 5825 3 other_so """" """"}
/*K003*/      /*SHIPPER REFERENCES SALES ORDER #. CONSOLIDATION NOT
PERMITTED*/
/*K003*/         next-prompt part_order with frame a.
/*K003*/         undo MAIN, retry MAIN.
/*K003*/          end.
/*K003*/       end. /* if abs_cons_ship = "0" */

/*K003*/      /* If invoice consolidation is to happen, then check
             for compatibility of SOs on the shipper */
/*K003*/       if can-find (first df_mstr where df_format = abs_format and
/*K003*/              df_type = "1" and
/*K003*/                  df_inv = true) then do:
/*K003*/      run chk_abs_inv_cons (input absid, input ship_from,
                      "", "", part_order, output cons_ok).
/*K003*/      if cons_ok = false then do:
/*K003*/         {mfmsg.i 5835 3}
          /* SALES ORDERS DO NOT MEET INVOICE CONSOLIDATION CONDITION */
/*K003*/         next-prompt part_order with frame a.
/*K003*/         undo MAIN, retry MAIN.
/*K003*/      end.
/*K003*/       end.
/*K003*/    end. /* if available abs_mstr */

        find so_mstr where so_nbr = sod_nbr no-lock.
/*K003*     find pt_mstr where pt_part = sod_part no-lock.               */
/*K003*/    find pt_mstr where pt_part = sod_part no-lock no-error.

            /* ADDING A KIT COMPONENT, get pt_mstr by part_item to AVOID */
        /* USING KIT PARENT PART                                     */
/*K003*/    if kit_comp then
/*K003*/       find pt_mstr where pt_part = part_item no-lock no-error.
/*K003*/    if available pt_mstr then part_item = pt_part.
/*K003*/    else if not kit_comp then part_item = sod_part.

        assign
/*K003*     part_item =  pt_part     */
        part_po = sod_contr_id
/*J2S5**    ship_so   = sod_site */
/*J2S5*/    ship_so   = sod_nbr
         ship_line = sod_line.

        /* VALIDATE SALES ORDER LINE SITE SAME AS SHIPFROM SITE */
        if sod_site <> ship_from then do:
           /* INVALID ORDER SHIP-FROM SITE */
           {mfmsg02.i 8228 3 sod_site}
           undo MAIN, retry MAIN.
        end.

/*J2F2*/ find ad_mstr where ad_addr = ship_to no-lock no-error.

/*J2F2*  *THIS LOGIC FINDS THE Ship-To OF THE ENTERED ADDRESS IF IT IS A DOCK */
/*J2F2*/ find first ls_mstr where ls_addr = ad_addr
/*J2F2*/ and (ls_type = "ship-to" or ls_type = "customer") no-lock no-error.
/*J2F2*/ do while not available ls_mstr and ad_ref > "":
/*J2F2*/    addr = ad_ref.
/*J2F2*/    find ad_mstr where ad_addr = addr no-lock.
/*J2F2*/    find first ls_mstr where ls_addr = ad_addr
/*J2F2*/    and (ls_type = "ship-to" or ls_type = "customer") no-lock no-error.
/*J2F2*/ end. /* DO WHILE NOT AVAILABLE LS_MSTR */
/*J2F2*/ shipto_id = ad_addr.

/*J2F2** if so_ship <> ship_to then do: */
/*J2F2*/ if ( so_ship <> shipto_id ) and
/*J2F2*/    ( so_ship <> ship_to) then do:
           /* INVALID ORDER SHIP-TO */
           {mfmsg02.i 8229 3 so_ship}
           undo MAIN, retry MAIN.
        end.

        /* MUST BE IN SAME DATABASE AS ORDER CREATED IN */

/*J1T4*/    /* THE VARIABLE so_db WHICH CONTAINS THE VALUE OF CENTRAL DB WAS  */
/*J1T4*/    /* BEING UNCONVENTIONALLY USED TO STORE A VALUE FOR AN UNRELATED  */
/*J1T4*/    /* COMPARISON. HENCE THE ERRONEOUS ASSIGNMENT OF so_db HAS BEEN   */
/*J1T4*/    /* REMOVED AND THE SUBSEQUENT TWO REFERENCES WHICH DEPEND ON THE  */
/*J1T4*/    /* ERRONEOUSLY ASSIGNED VALUE HAVE BEEN REPLACED BY THE VALUE     */
/*J1T4*/    /* ITSELF                                                         */

/*J1T4**    BEGIN DELETE **
 * /*K051*/ if so_sched then
 *      so_db = trim(substr(so_conrep,15,20)).
 *      if
 *      so_sched and
 *      so_db <> global_db then do:
 *         /* YOU MUST BE IN DATABASE */
 *         {mfmsg02.i 8148 3 so_db}
 *         undo MAIN, retry MAIN.
 *      end.
 *J1T4**    END DELETE   */

/*J1T4*/    if so_sched and
/*J1T4*/    trim(substring(so_conrep,15,20)) <> global_db then do:
/*J1T4*/       /* YOU MUST BE IN DATABASE */
/*J1T4*/       {mfmsg02.i 8148 3 trim(substring(so_conrep,15,20))}
/*J1T4*/       undo MAIN, retry MAIN.
/*J1T4*/    end.
/*131023.1*/ find first code_mstr no-lock where code_fldname = "WHEN_SO_HOLD_DISABL_SHIP" no-error.
/*131023.1*/ if available code_mstr and substring(code_value,1,1) = "Y" then do:
/*131023.1*/    assign WHEN_SO_HOLD_DISABL_SHIP = 3.
/*131023.1*/ end.
/*J22N*/    if  available so_mstr and so_stat <> "" then do:
/*J22N*/      /* SALES ORDER STATUS NOT BLANK */
/*J22N*/      {mfmsg.i 623 WHEN_SO_HOLD_DISABL_SHIP}
/*131023.1*/  if WHEN_SO_HOLD_DISABL_SHIP = 3 then 
/*131023.1*/  undo,retry.
/*J22N*/    end. /* IF SO_STAT <> "" */

        if sod_start_eff[1] > today or sod_end_eff[1] < today then do:
           /* SCHEDULED ORDER IS NO LONGER EFFECTIVE */
           {mfmsg.i 8138 2}
           bell.
        end.

        if sod_cum_qty[1] >= sod_cum_qty[3] and sod_cum_qty[3] > 0 then do:
           /* CUM SHIPPED QTY > MAX ORDER QTY FOR ORDER SELECTED */
           {mfmsg.i 8220 2}
        end.

/*K003*/    if (not sod_sched) and (not sod_confirm) then do:
           /* SALES ORDER LINE IS NOT SCHEDULED */
/*K0DL** /*K003*/          {mfmsg.i 6004 3} */
/*K0DL*/       {mfmsg.i 621 3}
/*K003*/       undo MAIN, retry MAIN.
/*K003*/    end.

/*K0CZ    ALSO NEED TO CHECK IF THERE IS ANY CHANGES FROM PBU  */
/*K0DH* /*K0CZ*/ if not so_primary then do :                   */
/*K0DH*/    if so_secondary then do:
/*K0CZ*/       find trq_mstr no-lock where trq_doc_type = "SO"
/*K0CZ*/                      and trq_doc_Ref  = so_nbr
/*K0CZ*/                      and trq_add_ref  = ""
/*K0CZ*/                     and (trq_msg_type = "ORDRSP-I" or
/*K0CZ*/                          trq_msg_type = "ORDRSP-C") no-error.
/*K0CZ*/       if available trq_mstr and trq_msg_type = "ORDRSP-C" then do:
/*K0CZ*/          {mfmsg.i 2834 3}
/*K0CZ*/          undo MAIN, retry MAIN.
/*K0CZ*/       end.
/*K0CZ*/       if available trq_mstr and trq_msg_type = "ORDRSP-I" then do:
/*K0CZ*/          {mfmsg.i 2935 3}
/*K0CZ*/          undo MAIN, retry MAIN.
/*K0CZ*/       end.
/*K0CZ*/    end.

/*K022*     SET CMF MESSAGES ONLY IN SBU AND NOT ALREADY PICK OR SHIPPED */
/*K0DH* /*K022*/ if not so_primary and not sod_sched and sod_qty_ship = 0 and */
/*J3L5** BEGIN DELETE **
 * /*K0DH*/   if so_secondary and not sod_sched and sod_qty_ship = 0 and
 * /*K022*/   not can-find (first lad_det where lad_nbr = sod_nbr and lad_line
 * /*K022*/   = string (sod_line)) then
 *J3L5** END DELETE **/

/*J3L5*/    if so_secondary     and
/*J3L5*/       not sod_sched    and
/*J3L5*/       sod_qty_ship = 0 and
/*J3L5*/       (not can-find(first lad_det
/*J3L5*/                        where lad_dataset = "sod_det" and
/*J3L5*/                              lad_nbr     = sod_nbr   and
/*J3L5*/                              lad_line    = string(sod_line))) and
/*J3L5*/       (not can-find(first lad_det
/*J3L5*/                        where lad_dataset = "sob_det" and
/*J3L5*/                              lad_nbr     = sod_nbr   and
/*J3L5*/                              lad_line    = string(sod_line)))
/*J3L5*/    then
/*K022*/       cmf_flg = yes.
/*K022*/    else cmf_flg = no.

/*K15N*** BEGIN DELETE - MOVED TO rcshwbc5.p FOR MULTI-DB CAPABILITIES ****
 *          /* FOR an ATO WITH F/A WO THEN USE THE FIRST ID         */
 *      /* ALLOW CHANGES ONLY IF THERE ARE MORE THAN 1 WO ID    */
 * /*K003*/    if sod_fa_nbr <> "" then do:
 * /*K003*/       find wo_mstr no-lock where wo_nbr = sod_fa_nbr
 * /*K003*/         and wo_type = "F"
 * /*K003*/         and wo_part = sod_part no-error.
 * /*K003*/       if available wo_mstr then
 * /*K003*/          part_fa_lot = wo_lot.
 * /*K003*/       if ambiguous wo_mstr then do:
 * /*K003*/          find first wo_mstr no-lock where wo_nbr = sod_fa_nbr
 * /*K003*/      and wo_type = "F" and wo_part = sod_part no-error.
 * /*K003*/      if available wo_mstr  then part_fa_lot = wo_lot.
 * /*K003*/       end.
 * /*K003*/    end.
 *K15N** END DELETE ******************************************/

/*K15N*/   if sod_fa_nbr <> "" then do:
/*K15N*/      /* SWITCH TO THE REMOTE SITE */
/*K15N*/      {gprun.i ""gpalias2.p""
               "(input sod_site,
                 output error_flag)"}

/*K15N*/      if error_flag <> 0 and error_flag <> 9 then do:
/*K15N*/         /* UNABLE TO CONNECT TO REMOTE DATABASE */
/*N05Q /*K15N*/         {mfmsg03.i 2510 4 {&rcshwbc2_p_6} """" """"} */
/*N0F4 /*N05Q*/  run mess-2510 ({&rcshwbc2_p_6}). */
/*N0F4*/         run mess-2510 (disp-char6).
/*K15N*/         undo MAIN, retry MAIN.
/*K15N*/      end.

/*K15N*/      /* FIND FINAL ASSEMBLY WORK ORDER FOR LOT NUMBER */
/*K15N*/      {gprun.i ""rcshwbc5.p""
               "(input sod_fa_nbr,
                 input sod_part,
                 output part_fa_lot)"}

/*K15N*/      /* RESET TO CENTRAL DATABASE */
/*K15N*/      {gprun.i ""gpalias3.p""
               "(input so_db,
                 output error_flag)"}

/*K15N*/      if error_flag <> 0 and error_flag <> 9 then do:
/*K15N*/         /* UNABLE TO CONNECT TO SALES DATABASE */
/*N05Q /*K15N*/         {mfmsg03.i 2510 4 {&rcshwbc2_p_8} """" """"} */
/*N0F4 /*N05Q*/  run mess-2510 ({&rcshwbc2_p_8}). */
/*N0F4*/         run mess-2510 (disp-char8).
/*K15N*/         undo MAIN, retry MAIN.
/*K15N*/      end.
/*K15N*/   end. /* if sod_fa_nbr <> "" */

    /*  CHECK IF PRE-SHIPPER/SHIPPER IS CANCELED */
/*K1YR** /*K003*/    find abs_mstr where abs_id = absid   */
/*K1YR*/    find abs_mstr where abs_shipfrom = ship_from
/*K1YR*/      and abs_id = absid
/*K003*/      no-lock no-error.
/*K003*/    if available abs_mstr then do:
/*K003*/       run get_abs_parent (input abs_id,
/*K003*/                           input abs_shipfrom,
/*K003*/                           output par_absid,
/*K003*/                           output par_shipfrom).
/*K003*/       if par_absid <> ? then do:
/*K003*/          find abs_tmp where abs_tmp.abs_id = par_absid and
/*K003*/          abs_tmp.abs_shipfrom = par_shipfrom no-lock no-error.
/*K003*/          if available abs_tmp and abs_tmp.abs_canceled = yes
/*K003*/          then shp_canceled = yes.
/*K003*/        end.
/*K003*/     end.
/*K003*/     if shp_canceled then det_all = no.
/*K003*/     if sod_type <> "" then det_all = no.

/*K003*     display pt_desc1 @ item_description    */
/*K003*/    display pt_desc1 when (available pt_mstr) @ item_description
/*J1LY* /*K003*/    "Item Not in Inventory" when (not available pt_mstr)   */
/*J1LY*/            sod_desc when (not available pt_mstr)
/*K003*/            @ item_description
            part_po
/*K003*         pt_um @ part_qty_um                                */
/*K003*/            pt_um when (available pt_mstr) @ part_qty_um
/*J1LY* /*K003*/    "" when (not available pt_mstr) @ part_qty_um      */
/*J1LY*/            sod_um when (not available pt_mstr) @ part_qty_um
            part_item
            part_order
            part_order_line
        with frame a.

        /* ASSIGN DEFAULTS */
/*K003*     ALLOW MEMO ITEM, IF NO pt_mstr SET DEFAULTS TO BLANK */
/*K003* /*J0R3***  assign part_loc = pt_loc             *****/  */
/*K003* /*J0R3*/   assign part_loc = sod_loc             */
/*K003*        part_site = ship_from                         */
/*K003*        part_qty = 0                                  */
/*K003*        part_qty_um = pt_um                           */
/*K003*        part_qty_conv = 1                             */
/*K003*        part_wght = pt_net_wt                         */
/*K003*        part_wt_um = pt_net_wt_um                     */
/*K003*        part_vol = pt_size                            */
/*K003*        part_vol_um = pt_size_um                      */
/*K003*        part_lot_ser = ""                             */
/*K003*        part_ref = ""                                 */
/*K003*        multiple = false                              */
/*K003*        lotserial_control = pt_lot_ser                */
/*K003*            cmmts = false                                 */
/*K003*        global_part = pt_part.                        */

/*N03S*     BEGIN DELETE
 *K003*     assign part_loc = sod_loc
 *K003*        part_site = ship_from
 *K003*        part_qty = 0
 *J1LY*  *K003*    part_qty_um = if available pt_mstr then pt_um  else "" *
 *J1LY*        part_qty_um = if available pt_mstr then pt_um else sod_um
 *K003*        part_qty_conv = 1
 *K003*        part_wght = if available pt_mstr then pt_net_wt else 0
 *K003*        part_wt_um = if available pt_mstr then pt_net_wt_um else ""
 *K003*        part_vol = if available pt_mstr then pt_size else 0
 *K003*        part_vol_um = if available pt_mstr then pt_size_um else ""
 *K003*        part_lot_ser = ""
 *K003*        part_ref = ""
 *K003*        multiple = false
 *K003*        lotserial_control = if available pt_mstr
 *K003*                                then pt_lot_ser else ""
 *K003*            cmmts = false
 *K003*        global_part = if available pt_mstr then pt_part else part_item.
 *N03S*     END DELETE */
/*N03S*/    run assign_part_defaults.

/*J2LW*/ /* GET THE OPEN QTY FOR THE SALES ORDER LINE */
/*J2LW*/ if not so_sched then
/*J2LW*/    run p-get-open (input recid(sod_det)).

        display
           part_site
           part_loc
           part_lot_ser
           part_ref
           part_qty
           part_qty_um
           part_qty_conv
/*J1LY*/       sod_type when (available sod_det)
/*J1LY*/       "" when (not available sod_det) @ sod_type
           part_wght
           part_wt_um
           part_vol
           part_vol_um
           multiple
/*K003*/       cmmts
/*K003*/       part_fa_lot
/*K003*/       det_all
/*K022*/       ship_avail_qty
        with frame a.

/*K23K*/ assign
/*K23K*/    l_prev_um = part_qty_um.

        /* GET INVENTORY DETAIL INFORMATION */
        INV_DETAIL:
        do on endkey undo MAIN, retry MAIN
        on error undo INV_DETAIL, retry INV_DETAIL:

/*K21N*/ /* THE WORK ORDER ID WILL NOT BE EDITABLE IN PRE-SHIPPER/SHIPPER  */
/*K21N*/ /* WORKBENCH WHEN RECEIVE F/A IN WO = YES                         */

           set
          part_qty
          part_qty_um
          part_qty_conv
          part_wght
          part_wt_um
          part_vol
          part_vol_um
/*K003*/  part_fa_lot
/*K21N*/     when (fac_wo_rec = no)
          part_site
          part_loc
          part_lot_ser
          part_ref
/*K003*       multiple                             */
/*J1LY* /*K003*/  multiple  when (sod_fa_nbr = "")     */
/*K20D** /*J1LY*/ multiple  when ((sod_fa_nbr = "") and (sod_type = "")) */
/*K20D*/  multiple when (sod_type = "")
/*K003*/          cmmts
/*J35D**   with frame a.  */
/*J35D*/   with frame a
/*J35D*/   editing:
/*J35D*/      assign
/*J35D*/         global_site = input part_site
/*J35D*/         global_loc  = input part_loc
/*J35D*/         global_lot  = input part_lot_ser.
/*J35D*/      readkey .
/*J35D*/      apply lastkey.
/*J35D*/   end. /* EDITING */

           /* CHECK FOR CONVERSION FACTOR */
/*K003*        if part_qty_um <> pt_um then do:                    */
/*K003*/       if available pt_mstr and pt_um <> part_qty_um  then do:

          if not part_qty_conv entered then do:

             {gprun.i ""gpumcnv.p""
                  "(input part_qty_um,
                input pt_um,
                input pt_part,
                output part_qty_conv)"}

             if part_qty_conv = ? then do:

            {mfmsg.i 33 2} /* NO UM CONVERSION EXISTS */
            part_qty_conv = 1.

             end.

             display part_qty_conv with frame a.

          end. /* IF NOT PART_QTY_CONV ENTERED */

           end. /* IF PART_QTY_UM <> PT_UM */

/*K23K*/   if part_qty_conv entered then
/*K23K*/   do:
/*K23K*/      for first um_mstr
/*K23K*/         fields ( um_alt_um um_conv um_part um_um )
/*K23K*/         where um_um     = l_prev_um
/*K23K*/           and um_alt_um = part_qty_um
/*K23K*/           and ( um_part = part_item or
/*K23K*/                 um_part = "") no-lock:
/*K23K*/      end. /* FOR FIRST UM_MSTR */
/*K23K*/      if available um_mstr and
/*K23K*/         um_conv <> part_qty_conv then
/*K23K*/      do:
/*K23K*/         /* UM CONVERSION CAN NOT BE EDITED FOR AN EXISTING */
/*K23K*/         /* ALTERNATE UM                                    */
/*K23K*/         {mfmsg.i 3429 3}
/*K23K*/         undo INV_DETAIL,retry INV_DETAIL.
/*K23K*/      end.  /* IF AVAILABLE UM_MSTR */
/*K23K*/   end. /* IF PART_QTY_CONV ENTERED */

/*J2LW*/   if not so_sched then
/*J2LW*/      if ((sod_qty_ord >= 0  and
/*J2LW*/         ((part_qty * part_qty_conv) / sod_um_conv) > open_qty )  or
/*J2LW*/          (sod_qty_ord < 0  and
/*J2LW*/         ((part_qty * part_qty_conv) / sod_um_conv) < open_qty ))
/*J2LW*/      then do:
/*J2LW*/      /* QTY ORDERED CANNOT BE LESS THAN ALLOCATED + PICKED + SHIPPED */
/*J2LW*/          {mfmsg.i  4999 2}
/*J2LW*/      end. /* IF PART_QTY > OPEN_QTY */

           /* IF SPECIFIED SITE IS NOT DEFINED SHIP-FROM SITE, */
           /* MAKE SURE IT'S IN THE SAME DATABASE              */

           if part_site <> ship_from then do:
          find si_mstr where si_site = ship_from no-lock.
          ship_db = si_db.
          find si_mstr where si_site = part_site no-lock.
          if si_db <> ship_db then do:

             /* ALL SHIP-FROM SITES MUST BE IN SAME DB */
             {mfmsg.i 2512 3}
             next-prompt part_site.
             undo INV_DETAIL, retry INV_DETAIL.
          end.
           end.

/*K003*/       if part_site <> ship_from then do:
/*K003*/       {gprun.i ""gpgetgrp.p""
                "(input part_site,
                  input ship_from,
                  output shipgrp)"}
/*K003*/       if shipgrp <> ? then do:
/*K003*/          find sg_mstr where sg_grp = shipgrp
/*K003*/           no-lock no-error.
/*K003*/          if available sg_mstr and
/*K003*/             sg_auto_tr = no then do:
/*K003*/             {mfmsg03.i 5845 3 part_site ship_from """"}
             /* Automatic transfer from site # to site # prohibited */
/*K003*/             undo MAIN, retry MAIN.
/*K003*/          end.
/*K003*/       end. /* if shipgrp <> ? */
/*K003*/       end. /* if part_site <> ship_from  */

           /* QTY IS NEG  - NO ALLOCATION, NO WEIGHT, NO VOLUME */
/*K003*/      if part_qty < 0 then
/*K003*/      assign det_all = no.
/*K003*/      set
/*K003*/          det_all   when (not shp_canceled and sod_type = ""
/*K003*/                           and part_qty > 0)
/*K022*/          ship_avail_qty
           with frame a.

/*K022*/       if ship_avail_qty and not det_all then do:
/*K022*/         {mfmsg.i 2860 3}
/*K022*/         next-prompt ship_avail_qty with frame a.
/*K022*/         undo INV_DETAIL, retry INV_DETAIL.
/*K022*/       end.

               /* VALIDATE F/A WO ID  */
/*K003*/       if part_fa_lot <> "" then do:
/*K022*/           run val-fa-id (input part_fa_lot,
                                  input recid (sod_det),
                  output undotran).
/*K022*/           if undotran then do:
/*K022*/          next-prompt part_fa_lot.
/*K022*/          undo INV_DETAIL, retry INV_DETAIL.
/*K022*/       end.

/*K022*  MOVE FOLLOWING SECTION TO INTERNAL PROCEDURE val-fa-id  *
 * /*K003*/   find wo_mstr no-lock where
 * /*K003*/          wo_lot = part_fa_lot no-error.
 * /*K003*/   if not available wo_mstr then do:
 * /*K003*/      {mfmsg.i 510 3} /* WO number doesn't exist */
 * /*K003*/      next-prompt part_fa_lot.
 * /*K003*/      undo INV_DETAIL, retry INV_DETAIL.
 * /*K003*/   end.
 * /*K003*/          else if index ("EAR",wo_status) = 0 then do:
 * /*K003*/      {mfmsg.i 523 3} /* WO IS CLOSED PLANNED OR FIRM */
 * /*K003*/      next-prompt part_fa_lot.
 * /*K003*/      undo INV_DETAIL, retry INV_DETAIL.
 * /*K003*/   end.
 * /*K003*/   if wo_nbr <> sod_fa_nbr then
 * /*K003*/      {mfmsg.i 5852 2} /* WO IS FOR DIFF SO  */
 *
 *
 * /*K003*/          /* CHECK FOR DUPLICATE F/A WO ID                      */
 * /*K003*/          for each abs_buff no-lock where
 * /*K003*/          abs_buff.abs_order = sod_nbr
 * /*K003*/   and abs_buff.abs_shipfrom = sod_site
 * /*K003*/   and abs_buff.abs_line = string(sod_line):
 * /*K003*/      if abs_buff.abs_fa_lot = part_fa_lot then do:
 * /*K003*/                run get_abs_parent (input abs_buff.abs_id,
 *                                          input abs_buff.abs_shipfrom,
 *                                          output par_absid,
 *                                          output par_shipfrom).
 * /*K003*/                if par_absid <> ? then do:
 * /*K003*/                   find abs_tmp where abs_tmp.abs_id = par_absid and
 * /*K003*/                abs_tmp.abs_shipfrom = par_shipfrom no-lock no-error.
 * /*K003*/                   if available abs_tmp and
 * /*K003*/                   (abs_tmp.abs_canceled = no or
 * /*K003*/                   substring(abs_tmp.abs_status,2,1) <> "y")
 * /*K003*/                   then do:
 *                            /* F/A WO ID exists for Pre-shipper/shipper  */
 * /*K003*/                      {mfmsg.i 5851 3}
 * /*K003*/                      next-prompt part_fa_lot.
 * /*K003*/                      undo INV_DETAIL, retry INV_DETAIL.
 * /*K003*/                   end.
 * /*K003*/                end.
 * /*K003*/             end.
 * /*K003*/          end.
 * **K022*  END SECTION MOVED */
/*K003*/       end.

           /* DELETE OLD SR_WKFL RECORDS */
           {gprun.i ""rcshmtb1.p""
            "(input mfguser,
              input cline,
              input no,
              input ship_from)"}

           /* SWITCH TO THE REMOTE SITE IF NECESSARY */
           {gprun.i ""gpalias2.p""
            "(input part_site,
              output error_flag)"}

           if error_flag <> 0 and error_flag <> 9 then do:
           /* UNABLE TO CONNECT TO REMOTE DATABASE */
/*N05Q           {mfmsg03.i 2510 4 {&rcshwbc2_p_6} """" """"} */
/*N0F4 /*N05Q*/  run mess-2510 ({&rcshwbc2_p_6}). */
/*N0F4*/         run mess-2510 (disp-char6).
                 undo INV_DETAIL, retry INV_DETAIL.
           end.

           /* DELETE OLD SR_WKFL RECORDS */
/*K003*/       {gprun.i ""rcshmtb1.p""
            "(input mfguser,
              input cline,
              input no,
              input ship_from)"}

/*J1LY*        if not multiple then do:                        */
/*J1LY*/       if available sod_det and sod_type = "" and
/*M15M*/          sod_cfg_type <> "2" and
/*J1LY*/          not multiple then do:

/*N0WT*/  {&RCSHWBC2-P-TAG1}
          /* VALIDATE THE INVENTORY DETAIL INFORMATION */
/*K223*/  /* ADDED UM CONV AS TENTH INPUT PARAMETER ; PASSING PART_QTY_CONV */
          {gprun.i ""rcctmtb.p"" "(input transtype,
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

          if undotran then do:

             /* RESET TO CENTRAL DATABASE IF NECESSARY */
             {gprun.i ""gpalias3.p""
                  "(input so_db,
                output error_flag)"}

             undo INV_DETAIL, retry INV_DETAIL.
          end.

           end. /* IF NOT MULTIPLE */

           /* SET THE MULTIPLE INFO IF NECESSARY */
           if multiple then do:

/*N03S*   BEGIN DELETE
 *        assign
 *        cline = ""
 *        site = part_site
 *        location = part_loc
 *        lotserial = part_lot_ser
 *        lotserial_qty = part_qty
 *        trans_um = part_qty_um
 *        trans_conv = 1
 *J0J1*           lotnext = ""
 *J0J1*           lotprcpt = no
 *        lotref = part_ref.
 *N03S*   END DELETE */
/*N03S*/  run assign_multiple_info.

          /* MULTIPLE ENTRY ROUTINE */
/*J0J1 ADDED ADDITIONAL PARAMETERS TO THE ICSRUP.P CALL */
/*J0J1            {gprun.i ""icsrup.p"" "(input ship_from)"}    */
/*J0J1*/          {gprun.i ""icsrup.p"" "(input ship_from,
                      input """",
                      input """",
                      input-output lotnext,
                      input lotprcpt)"}

/*J2QT*/ /* LOGIC TO ACCESS SR_WKFL TRANSFERRED TO RCSHWBC6.p, SO AS TO   */
/*J2QT*/ /* RETAIN THE VALUE OF SR_USERID IN A MULTI DATABASE ENVIRONMENT */
/*J2QT** /* HANDLE NO MULTIPLE ENTRY RECORDS CREATED CONDITION */         */
/*J2QT**  find first sr_wkfl where sr_userid = mfguser no-lock no-error.  */

/*J2QT**  if not available sr_wkfl then do: */

/*J2QT*/  assign undotran = no.
/*J2QT*/  {gprun.i ""rcshwbc6.p"" "(output undotran)"}

/*J2QT*/  if undotran then do:
             /* RESET TO CENTRAL DATABASE IF NECESSARY */
             {gprun.i ""gpalias3.p""
                  "(input so_db,
                output error_flag)"}

             undo INV_DETAIL, retry INV_DETAIL.
          end. /* IF UNDOTRAN */

           end. /* IF MULTIPLE */

           /* SET WORK_SR_WKFL WORKFILE RECORDS */
           {gprun.i ""rcshmtb2.p""
            "(input mfguser, input cline)"}

           /* RESET TO CENTRAL DATABASE IF NECESSARY */
           {gprun.i ""gpalias3.p""
            "(input so_db,
              output error_flag)"}

/*K15N*/   if error_flag <> 0 and error_flag <> 9 then do:
/*K15N*/      /* UNABLE TO CONNECT TO SALES DATABASE */
/*N05Q /*K15N*/      {mfmsg03.i 2510 4 {&rcshwbc2_p_8} """" """"} */
/*N0F4 /*N05Q*/  run mess-2510 ({&rcshwbc2_p_8}). */
/*N0F4*/         run mess-2510 (disp-char8).
/*K15N*/      undo INV_DETAIL, retry INV_DETAIL.
/*K15N*/   end.

        end. /* INV_DETAIL */

        /* CREATE WORK_SR_WKFL FOR MULTI-ENTRY = FALSE */
        find first work_sr_wkfl no-lock no-error.

        if not available work_sr_wkfl then do:

           create work_sr_wkfl.

           assign
           work_sr_wkfl.sr_userid = mfguser
           work_sr_wkfl.sr_site = part_site
           work_sr_wkfl.sr_loc = part_loc
           work_sr_wkfl.sr_lotser = part_lot_ser
           work_sr_wkfl.sr_ref = part_ref
           work_sr_wkfl.sr_qty = part_qty.
        end.

        num_containers = 0.

        /* COUNT THE NUMBER OF PARENT CONTAINERS FOR THIS ITEM */
        for each abs_mstr where abs_mstr.abs_shipfrom = ship_from
        and abs_mstr.abs_shipto = temp_parent
        and integer(abs_mstr.abs__qad06) = 2 no-lock:
           num_containers = num_containers + 1.
        end.

        part_qty = 0.

        /* COUNT THE QTY OF ITEMS FOR THE PARENT CONTAINERS */
        for each work_sr_wkfl no-lock:
           part_qty = part_qty + work_sr_wkfl.sr_qty.
        end.

         /* ADDING A KIT PARENT, PROCESS KIT COMPONENTS */

/*K003*/    if can-find (first sob_det where sob_nbr = sod_nbr and
/*K003*/       sob_line = sod_line)
/*K003*/       and part_item = sod_part and
/*K003*/       sod_cfg_type = "2" and  sod_fa_nbr = "" then do:
/*L13Y** /*K003*/ assign process_type = 1 */
/*L14B** /*L13Y*/ assign process_type = 2                          */
/*L14B** /*K003*/        qty_ratio = part_qty * sod_um_conv /      */
/*L14B** /*K003*/                    (sod_qty_ord - sod_qty_ship). */

/*L14B*/       process_type = 2.

/*K022*        ADDED input ship_avail_qty                                  */
/*K18W*/       /* ADDED INPUT PARAMETER stage_open to soskit01.p           */

/*L14B*/       /* REPLACED FOURTH INPUT PARAMETER qty_ratio WITH           */
/*L14B*/       /* (part_qty * sod_um_conv)                                 */
/*L14B*/       /* ADDED FIFTH INPUT PARAMETER (sod_qty_ord - sod_qty_ship) */

/*M12F*/    /* ADDED SIXTH INPUT PARAMETER process_type                    */
/*K003*/    {gprun.i ""soskit01.p""
                "(input recid(so_mstr),
                  input recid(sod_det),
                  input det_all,
                  input (part_qty * sod_um_conv),
                  input (sod_qty_ord - sod_qty_ship),
                  input process_type,
                  input ship_avail_qty,
                  input stage_open,
                  output abnormal_exit)"}

/*K003*/       if (abnormal_exit) then
/*K003*/          undo MAIN, retry MAIN.
/*K022*/       new_par_qty = part_qty.
/*K022*/       if ship_avail_qty then do:
/*K022*/           run get_par_qty (input recid(sod_det),
                    input-output new_par_qty).
/*K1VC** /*K022*/  if new_par_qty <> part_qty then do: */
/*K1VC*/           if new_par_qty <> part_qty * part_qty_conv then
/*K1VC*/           do:
/*K022*/             {mfmsg02.i 208 3 "new_par_qty"}
/*K022*/             undo MAIN, retry MAIN.
/*K022*/           end.
/*K022*/       end.
/*K003*/    end.
/*K003*/    else do:
              /* GENERAL ALLOCATION FOR REGULAR ITEM */

             /* SWITCH TO THE INVENTORY SITE */
/*K003*/    {gprun.i ""gpalias2.p"" "(sod_site, output errornum)"}

/*K003*/    if errornum <> 0 and errornum <> 9 then do:

/*K003*/       /* DATABASE # IS NOT CONNECTED */
/*N05Q /*K003*/       {mfmsg03.i 2510 4 {&rcshwbc2_p_6} """" """"} */
/*N0F4 /*N05Q*/  run mess-2510 ({&rcshwbc2_p_6}). */
/*N0F4*/         run mess-2510 (disp-char6).
/*K003*/       abnormal_exit = true.
/*K003*/       undo MAIN, leave MAIN.
/*K003*/    end.

/*M1Q0*/    if sod_qty_all = 0
/*M1Q0*/    then
/*M1Q0*/       l_sodall = yes.

        /* DO THE GENERAL ALLOCATIONS */
/*K003*/        if sod_qty_all = 0 then
/*J2MH*/    /* CONVERTED PART_QTY TO SO UM */
/*J37V*/    /* ADDED OUTPUT PARAMETER L_SOD_ALL */
/*K003*/    {gprun.i ""soitallc.p""
                     "(input part_order,
                       input integer(part_order_line),
                       input all_days,
                       input part_qty * part_qty_conv / sod_um_conv,
                       output l_sod_all)"}

        /* SWITCH BACK TO THE SALES ORDER DATABASE */
/*K003*/    {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}

/*K003*/    if errornum <> 0 and errornum <> 9 then do:

        /* DATABASE # IS NOT CONNECTED */
/*N05Q /*K003*/       {mfmsg03.i 2510 4 {&rcshwbc2_p_8} """" """"} */
/*N0F4 /*N05Q*/  run mess-2510 ({&rcshwbc2_p_8}). */
/*N0F4*/         run mess-2510 (disp-char8).
/*K003*/       abnormal_exit = true.
/*K003*/       undo MAIN, leave MAIN.
/*K003*/    end.

/*K003*/    end.

        /* AT THIS POINT NUM_CONTAINERS CONTAINS THE NUMBER OF PARENT    */
        /* RECORDS THAT THE ITEM QTY IS TO BE DIVIDED AMONGST. PART_QTY  */
        /* WILL CONTAIN THE TOTAL ITEM QTY                               */

        /* DETERMINE QUANTITY PER AND MODULO */
/*J2CY** qty_per =                           */
/*J1LY*      (part_qty - (part_qty modulo num_containers)) / num_containers. */
/*J2CY** /*J1LY*/      part_qty / num_containers. */
/*J2CY*/ qty_per = truncate ( part_qty / num_containers,0 ).
        qty_modulo = part_qty modulo num_containers.

        /* PART QUANTITIES WILL BE ASSIGNED TO PARENT CONTAINER RECORDS  */
        /* ON A CONSUMPTION BASIS I.E. SR_WKFL'S WILL BE FOUND ONE BY ONE*/
        /* AND AS MUCH OF THE QUANTITY THAT CAN, WILL BE APPLIED TO THE  */
        /* CURRENT RECORD UNTIL THE QUANTITY LEFT IS ZERO. THEN THE NEXT */
        /* SR_WKFL RECORD WILL BE APPLIED AND SO ON UNTIL ALL HAVE BEEN  */
        /* APPLIED                                                       */

/*K003*/    first_parent = yes.

        /* CREATE THE ALLOTED NUMBER OF CONTAINER RECORDS */
        /* FROM THE SR_WKFL RECORDS */
        for each parent_container
        where parent_container.abs_shipfrom = ship_from
        and parent_container.abs_shipto = temp_parent
/*K21D** and integer(abs__qad06) = 2 no-lock: */
/*K21D*/ and integer(abs__qad06) = 2 exclusive-lock:

           /* SET PART QTY FOR THIS RECORD */
           qty_to_set = qty_per.
/*K18W*/   this_rec_qty = 0.

           /* ASSIGN MODULO QTY TO FIRST RECORD ONLY */

           if qty_modulo > 0 then do:
/*J1LY*/          if part_qty > 0 then
             qty_to_set = qty_to_set + qty_modulo.
/*J1LY*/          else
/*J1LY*/         qty_to_set = qty_to_set + (qty_modulo - num_containers).
          qty_modulo = 0.
           end.

/*J2J4**  do while qty_to_set <> 0: */
/*J2J4*/  do while (qty_to_set <> 0) or (num_containers = 1 and part_qty <> 0):

          find first work_sr_wkfl exclusive-lock.

          /* CASE SR_QTY IS MORE THAN REQUIRED */
/*K003*       if work_sr_wkfl.sr_qty > qty_to_set then do:      */
/*J26V*/  if num_containers > 1 then do:
/*K003*/     if absolute (work_sr_wkfl.sr_qty) >
/*K003*/             absolute (qty_to_set) then do:

/*K21C**         work_sr_wkfl.sr_qty = work_sr_wkfl.sr_qty - qty_to_set. */
/*K21C**         this_rec_qty = qty_to_set.  */
/*K21C*/         assign
/*K21C*/            work_sr_wkfl.sr_qty = work_sr_wkfl.sr_qty - qty_to_set
/*K21C*/            this_rec_qty = qty_to_set
                    qty_to_set = 0.
              end.
          /* CASE SR_QTY IS LESS THAN OR EQUAL AMT REQUIRED */
          else do:

/*K21C**        this_rec_qty = work_sr_wkfl.sr_qty.            */
/*K21C**        qty_to_set = qty_to_set - work_sr_wkfl.sr_qty. */
/*K21C*/        assign
/*K21C*/           this_rec_qty = work_sr_wkfl.sr_qty
/*K21C*/           qty_to_set = qty_to_set - work_sr_wkfl.sr_qty
                   work_sr_wkfl.sr_qty = 0.
             end.
/*J26V*/     assign this_rec_qty2 = this_rec_qty .
/*J26V*/  end. /* NUM_CONTAINERS > 1 */
/*J26V*/  else do:
/*J26V*/     assign this_rec_qty2 = work_sr_wkfl.sr_qty
/*J2CY** /*J26V*/   qty_to_set = 0           */
/*J26V*/            work_sr_wkfl.sr_qty = 0.
/*J26V*/  end. /* ELSE OF NUM_CONTAINERS > 1 */

          /* CHECK FOR DUPLICATE RECORDS */
/*K0FH*/          if kit_comp then
/*K0FH*/         find abs_mstr where abs_mstr.abs_shipfrom = ship_from
/*K0FH*/         and abs_mstr.abs_id = parent_container.abs_id +
/*K0FH*/         work_sr_wkfl.sr_site +
/*K0FH*/             part_order + part_order_line + part_item +
/*K0FH*/         work_sr_wkfl.sr_loc + work_sr_wkfl.sr_lotser +
/*K0FH*/         work_sr_wkfl.sr_ref
/*K0FH*/         no-lock no-error.
/*K0FH*/      else
             find abs_mstr where abs_mstr.abs_shipfrom = ship_from
             and abs_mstr.abs_id = "i" + parent_container.abs_id +
/*J1LY*          work_sr_wkfl.sr_site + part_item +                     */
/*J1LY*/         work_sr_wkfl.sr_site +
/*J1LY*/             part_order + part_order_line + part_item +
             work_sr_wkfl.sr_loc + work_sr_wkfl.sr_lotser +
             work_sr_wkfl.sr_ref
             no-lock no-error.

          if available abs_mstr then do:

             /* YOU CANNOT HAVE MULTIPLE ITEMS FOR SAME ... */
             {mfmsg.i 753 3}
             undo MAIN, retry MAIN.

          end.

/*K003*/      if first_parent then do:
/*K003*/         first_parent = no.

/*K003*/             if cmmts then do:
               /* The parent shipper if the container is attached to one */
/*K003*/                run get_abs_parent (input parent_container.abs_id,
                                            input ship_from,
                                            output par_absid,
                                            output par_shipfrom).

/*K003*/                if par_absid <> ? then do:
/*K003*/                   find abs_buff where abs_buff.abs_id = par_absid and
/*K003*/                        abs_buff.abs_shipfrom = par_shipfrom
/*K003*/                        no-lock no-error.
/*K003*/                   if available abs_buff then do:
/*K003*/                      assign global_ref = abs_buff.abs_format
/*K003*/                             global_lang = abs_buff.abs_lang.
/*K003*/                      {gprun.i ""gpcmmt01.p"" "(input 'abs_mstr')"}
/*K003*/                   end.
/*K003*/                end. /* if par_absid <> ? */
/*K003*/             end. /* if cmmts */

/*K003*/          end.  /* if first_parent */

/*K003*/         /* UPDATE ALLOCATION  FOR REG ITEM & ATO */
/*K21N** /*K003*/ if ((sod_cfg_type <> "2" and sod_fa_nbr = "") or kit_comp) */
/*K21N*/          if sod_cfg_type <> "2" or
/*K21N*/             kit_comp
/*J2CQ** /*K003*/ and det_all then do: */
/*J2CQ*/          then do:

                 /* SET GLOBAL_DB USING ABS_SITE */
/*K003*/             new_site = part_site.
/*K003*/             {gprun.i ""gpalias.p""}

                 /* SWITCH TO THE INVENTORY SITE */
/*K003*/         if so_db <> global_db then do:
/*K003*/             {gprun.i ""gpalias2.p""
                      "(part_site, output errornum)"}
/*K003*/             if errornum <> 0 and errornum <> 9 then do:
                    /* DATABASE # IS NOT CONNECTED */
/*N05Q /*K003*/                {mfmsg03.i 2510 4 */
/*N05Q                         {&rcshwbc2_p_6} """" """"} */
/*N0F4 /*N05Q*/         run mess-2510 ({&rcshwbc2_p_6}). */
/*N0F4*/                run mess-2510 (disp-char6).
/*K003*/                undo MAIN, retry MAIN.
/*K003*/             end.
/*K003*/          end.

/*J2CQ*/          if det_all then do:

/*M0GG*/ /* CALL SOITALLE.P INSTEAD OF SOITALLA.P */

/*M0GG** BEGIN DELETE
 * /*J26V*/ /* CHANGED EIGHTH INPUT PARAMETER this_rec_qty TO this_rec_qty2  */
 * /*K18W*/ /* ADDED OUTPUT PARAMETER adj_qty                                */
 * /*J2MH*/ /* CONVERTED THIS_REC_QTY2 TO INVENTORY UM */
 * /*J33X*/ /* ADDED NINTH INPUT PARAMETER 0           */
 * /*K003*/            {gprun.i ""soitalla.p""
 *                              "(input part_order,
 *                                input part_order_line,
 *                                input part_item,
 *                                input work_sr_wkfl.sr_site,
 *                                input work_sr_wkfl.sr_loc,
 *                                input work_sr_wkfl.sr_lotser,
 *                                input work_sr_wkfl.sr_ref,
 *                                input this_rec_qty2 * part_qty_conv,
 *                                input 0,
 *                                output adj_qty,
 *                                output undotran)"}
 *M0GG** END DELETE */

/*M0GG*/            {gprun.i ""soitalle.p""
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
/*J2CQ*/         end.
/*J2CQ*/         else do:

/*M0GG*/ /* CALL SOITALLF.P INSTEAD OF SOITALLD.P */

/*M0GG** BEGIN DELETE
 * /*J2MH*/            /* CONVERTED THIS_REC_QTY2 TO INVENTORY UM */
 * /*J2CQ*/            {gprun.i ""soitalld.p""
 *                           "(input part_order,
 *                             input part_order_line,
 *                             input part_item,
 *                             input work_sr_wkfl.sr_site,
 *                             input work_sr_wkfl.sr_loc,
 *                             input work_sr_wkfl.sr_lotser,
 *                             input work_sr_wkfl.sr_ref,
 *                             input 0,
 *                             input this_rec_qty2 * part_qty_conv,
 *                             input 0,
 *                             input del_lad,
 *                             output adj_qty,
 *                             output undotran)"}
 *M0GG** END DELETE */

/*M1Q0*/               /* ADDED TENTH INPUT PARAMETER l_sodall               */
/*M1Q0*/               /* l_sodall = Yes, sod_qty_all = 0 DURING SO CREATION */

/*M0GG*/               {gprun.i ""soitallf.p""
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
/*M0GG*/            adj_qty = 0.

/*J2CQ*/         end.
/*J34T** /*K003*/  if undotran then  undo MAIN, retry MAIN. */

                 /* SWITCH BACK TO THE SALES ORDER DATABASE */
/*K003*/         if so_db <> global_db then do:

/*J394*/            /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
/*J394*/            /* IN REMOTE DATABASE                         */
/*J394*/            if not kit_comp and det_all
/*J394*/            then do:
/*L0M0*/               /* ADDED FOURTH INPUT PARAMETER L_DELPROC */
/*J394*/               {gprun.i ""sosopka2.p"" "(input part_order,
                                                input integer (part_order_line),
                                                input adj_qty,
                                                input l_delproc)"}
/*J394*/            end. /* IF NOT KIT_COMP AND DET_ALL */

/*K003*/            {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}
/*K003*/            if errornum <> 0 and errornum <> 9 then do:
                   /* DATABASE # IS NOT CONNECTED */
/*N05Q /*K003*/               {mfmsg03.i 2510 4 {&rcshwbc2_p_8} """" """"} */
/*N0F4 /*N05Q*/  run mess-2510 ({&rcshwbc2_p_8}). */
/*N0F4*/         run mess-2510 (disp-char8).
/*K003*/                undo MAIN, retry MAIN.
/*K003*/            end.
/*K003*/         end.

/*J34T*/         if undotran then  undo MAIN, retry MAIN.

/*K18W*/ /* PARAMETER CHANGED FROM this_rec_qty to adj_qty */
                /* UPDATE DETAIL QTY ALL, QTY PICK */
/*J2CQ**  /*K003*/ if not kit_comp then */
/*L0M0*/         /* ADDED FOURTH INPUT PARAMETER L_DELPROC */
/*J2CQ*/         if not kit_comp and det_all then
/*K003*/            {gprun.i ""sosopka2.p""
                             "(input part_order,
                               input integer (part_order_line),
                               input adj_qty,
                               input l_delproc)"}

/*K003*/          end. /* con_type <> "2"  ... */

/*J1LY*  ADDED part_order and part_order_line to new_id                  */
/*K003*  FOR A KIT COMPONENT set new_id DIFF to AVOID "ii" because       */
/*K003*  PARENT ID ALREADY BEGINS WITH "i"                               */
/*K003*/          if kit_comp then
              new_id =  parent_container.abs_id +
                work_sr_wkfl.sr_site +
/*J1LY*/                        part_order +
/*J1LY*/                        part_order_line +
                part_item +
                work_sr_wkfl.sr_loc +
                work_sr_wkfl.sr_lotser +
                work_sr_wkfl.sr_ref +
                part_fa_lot.
/*K003*/          else
              new_id =  "i" + parent_container.abs_id +
                work_sr_wkfl.sr_site +
/*J1LY*/                        part_order +
/*J1LY*/                        part_order_line +
                part_item +
                work_sr_wkfl.sr_loc +
                work_sr_wkfl.sr_lotser +
                work_sr_wkfl.sr_ref +
                part_fa_lot.

/*K003*       Input paramter cmtindx added to rcctwbc3 invocation */
/*K003*       Added Input parm part_fa_lot and output parm line_recno */
/*K003*           CHANGE    input 'i' + parent_container.abs_id +         */
/*K003*             work_sr_wkfl.sr_site +                    */
/*K003*             part_item +                               */
/*K003*             work_sr_wkfl.sr_loc +                     */
/*K003*             work_sr_wkfl.sr_lotser +                  */
/*K003*             work_sr_wkfl.sr_ref +                     */
/*K003*             part_fa_lot                               */
/*K003*           TO         input new_id                                 */

         /* CREATE THE CONTAINER RECORD */

/*J26V*/ /* CHANGED FIFTH INPUT PARAMETER this_rec_qty TO this_rec_qty2 */
/*J2M7*/  /* REPLACED NINETEENTH PARAMETER PART_WGHT WITH */
/*J2M7*/  /* IF AVAILABLE PT_MSTR THEN PT_SHIP_WT ELSE 0  */
/*K21D*/  /* REPLACED CALL TO RCCTWBC3.P TO AN INTERNAL PROCEDURE */
/*K21D** BEGIN DELETE **
 *           {gprun.i ""rcctwbc3.p""
 *                "(input ship_from,
 *                  input temp_parent,
 *                  input new_id,
 *                  input parent_container.abs_id,
 *                  input this_rec_qty2,
 *                  input part_item,
 *                  input work_sr_wkfl.sr_loc,
 *                  input work_sr_wkfl.sr_lotser,
 *                  input 1,
 *                  input 'NONE',
 *                  input work_sr_wkfl.sr_ref,
 *                  input part_wght,
 *                  input part_wt_um,
 *                  input part_vol,
 *                  input part_vol_um,
 *                  input work_sr_wkfl.sr_site,
 *                  input part_qty_um,
 *                  input part_qty_conv,
 *          input (if available pt_mstr then pt_ship_wt else 0),
 *                  input part_order,
 *                  input part_order_line,
 *                  input cmtindx,
 *                  input part_fa_lot,
 *                  output line_recno)"}
 *K21D** END DELETE */

/*K21D*/  run p_create_item
             (input ship_from,
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
/*M18K*/      buffer pt_mstr,
              output line_recno).

/*K25V*/  if sod_sched then do:

/*K25V*/     /* AUTOMATIC FIFO PEGGING DURING THE SHIPPER LINE CREATION */
/*K25V*/     /* IN P/S WORKBENCH                                        */
/*K25V*/     {gprun.i ""rcrspeg.p"" "(input line_recno,
                                      input true,
                                      input low_date,
                                      input hi_date,
                                      input """",
                                      input hi_char,
                                      input """",
                                      input hi_char,
                                      output l_errors)"}
/*K25V*/  end. /* IF SOD_SCHED */

/*K21D*/  /* UPDATING IMMEDIATE PARENT CONTAINER WEIGHT FOR THE ITEM CREATED */
/*K21D*/  l_par_cont = parent_container.abs_id.

/*K21D*/   if available pt_mstr then
/*K21D*/      l_pt_ship_wt = pt_ship_wt.
/*K21D*/   else
/*K21D*/      l_pt_ship_wt = part_wght.

/*K21D*/   if substring(parent_container.abs_id ,1,1) = "c" then
/*K21D*/   do:
/*K21D*/       l_conv = 1.
/*K21D*/       /* CONSIDERING CHANGES IN NET WEIGHT UM IN THE ITEM  */
/*K21D*/       /* INFORMATION FRAME AND ACCORDINGLY ADJUSTING THE   */
/*K21D*/       /* THE NET AND GROSS WEIGHTS OF THE PARENT CONTAINER */
/*K21D*/       if (parent_container.abs_wt_um <> "" ) and
/*K21D*/           part_wt_um <> parent_container.abs_wt_um then
/*K21D*/       do:
/*K250*/          /* INTERCHANGED FIRST TWO PARAMETERS */
/*K21D*/          {gprun.i ""gpumcnv.p""
                           "(part_wt_um,
                             parent_container.abs_wt_um,
                             """",
                             output l_conv)" }

/*K250*/          if l_conv = ? then
/*K250*/             l_conv = 1.
/*K21D*/       end.  /* IF PARENT_CONTAINER.ABS_WT_UM <> "" AND ...    */

/*N03S*       BEGIN DELETE
 *K21D*       if l_pt_ship_wt = 0 and part_wght <> 0 then
 *K21D*          /* ASSIGN NET WT TO GROSS WT IF ITEM SHIP WT IS ZERO  */
 *K21D*          /* IN PART MASTER                                     */
 *K21D*          assign
 *K21D*             parent_container.abs_nwt = parent_container.abs_nwt +
 *K21D*                     MAX(part_wght * this_rec_qty2 * part_qty_conv,0)
 *K21D*                     * l_conv
 *K21D*             parent_container.abs_gwt =  parent_container.abs_gwt +
 *K21D*                     MAX(part_wght * this_rec_qty2 * part_qty_conv,0)
 *K21D*                     * l_conv.
 *K21D*        else
 *K21D*           assign
 *K21D*              parent_container.abs_nwt = parent_container.abs_nwt +
 *K21D*                     MAX(part_wght * this_rec_qty2 * part_qty_conv,0)
 *K21D*                     * l_conv
 *K21D*              parent_container.abs_gwt = parent_container.abs_gwt +
 *K21D*                     MAX(l_pt_ship_wt * this_rec_qty2 * part_qty_conv,0)
 *K21D*                     * l_conv.
 *K21D*        parent_container.abs_wt_um = part_wt_um.
 *N03S*       END DELETE */
/*N03S*/      run calc_container_weights.

/*N160*/      assign
/*N160*/         l_total_tare_wt = 0
/*N160*/         l_total_net_wt  = 0.

/*K21D*/   end.  /* IF SUBSTRING(PARENT_CONTAINER.ABS_ID, 1, 1) = 'c' */

/*K21D*/   else if substring(parent_container.abs_id, 1, 1) = "i" then
/*K21D*/   do:
/*K21D*/      /* ROLLING UP TARE WEIGHT FROM KIT COMPONENT TO THE KIT PARENT */
/*K21D*/      /* THE NET AND GROSS WT ROLLUP WILL BE HANDLED BY SUBSEQUENT   */
/*K21D*/      /* CALL TO ICSHNWT.P                                           */
/*K21D*/      {absupack.i  "parent_container" 26 22 "l_abs_kit_tare_wt" }
/*K21D*/      l_abs_kit_tare_wt = l_abs_kit_tare_wt + l_abs_tot_tare_wt.
/*K21D*/      {abspack.i "parent_container" 26 22 "l_abs_kit_tare_wt" }
/*K21D*/   end.  /* IF SUBSTRING(PARENT_CONTAINER.ABS_ID, 1, 1) = "i" */

/*K18W*/ /* FOLLOWING SECTION ADDED SO THAT THE DEFAULT VALUE FOR PICKED QTY */
/*K18W*/ /* BE SET IN abs_mstr (abs__dec01) */

/*K21D*/ /* MOVED CODE BELOW TO INTERNAL PROCEDURE P_CREATE_ITEM */
/*K21D** BEGIN DELETE **
 * /*K18W*/        find abs_mstr where recid(abs_mstr)= line_recno
 * /*K18W*/           exclusive-lock no-error.
 * /*K1NF** /*K18W*/    if available abs_mstr and det_all then */
 * /*K1NF** /*K18W*/       abs_mstr.abs__dec01 =  adj_qty.     */
 *
 * /*K1NF*/  if available abs_mstr and det_all then do:
 * /*J2MH*/     /* CONVERTED ADJ_QTY TO SHIPPER UM */
 * /*K1NF*/     {abspack.i "abs_mstr" 3 22 "adj_qty / part_qty_conv" }
 * /*K1NF*/  end. /* IF AVAILABLE ABS_MSTR */
 *K21D** END DELETE */

/*K003*/          /* Gather additional line item data */
/*K003*/          {gprun.i ""sofsgi.p"" "(line_recno)" }

/*N004*/        /* MAINTAIN SEQUENCES, IF CUST. SEQ. SCHEDULES ARE INSTALLED */
/*N004*/        {gpfile.i &file_name = """"rcf_ctrl""""}

/*N05Q   BEGIN DELETE
* /*N004*/        if can-find (mfc_ctrl where
* /*N004*/            mfc_field = "enable_sequence_schedules" and
* /*N004*/            mfc_logical) and  file_found then do:
*
* /*N004*/                for first so_mstr where
* /*N004*/                          so_nbr = part_order no-lock:
* /*N004*/                end.
* /*N004*/                if available so_mstr and so_seq_order then do:
* /*N004*/                     {gprunmo.i
*                                &program = ""rcabssup.p""
*                                &module = "ASQ"
*                                &param = """(input new_id,
*                                input ship_from,
*                                input "yes")"""}
*
* /*N004*/                end. /* IF AVAILABLE so_mstr */
* /*N004*/        end. /* if enable sequenced schedules */
* N05Q   END DELETE */

/*N05Q*/        if can-find (mfc_ctrl where
/*N05Q*/           mfc_field = "enable_sequence_schedules"
/*N05Q*/           and mfc_logical)
/*N05Q*/           and file_found then
/*N05Q*/              for first so_mstr where
/*N05Q*/                        so_nbr = part_order
/*N05Q*/                        and so_seq_order no-lock:
/*N05Q*/                   {gprunmo.i
                             &program = ""rcabssup.p""
                             &module = "ASQ"
                             &param = """(input new_id,
                             input ship_from,
                             input "yes")"""}
/*N05Q*/              end.

                  /*  ADD ABS RECORDS FOR KIT COMPONENTS */
/*K18W*/ /* ADDED INPUT PARAMETER det_all to rcshwbc3.p */
/*K003*/          if can-find (first sob_det where sob_nbr = sod_nbr and
/*K003*/          sob_line = sod_line) then do:

/*J26V*/ /* CHANGED FOURTH INPUT PARAMETER this_rec_qty TO this_rec_qty2 */
/*J2CY*/ /* CHANGED THIRD  INPUT PARAMETER this_rec_qty / part_qty TO    */
/*J2CY*/ /* TO this_rec_qty2 / part_qty                                  */

/*K003*/         {gprun.i ""rcshwbc3.p""
               "(input line_recno,
                 input recid(sod_det),
                 input this_rec_qty2 / part_qty,
                 input this_rec_qty2 ,
                 input work_sr_wkfl.sr_site,
                 input work_sr_wkfl.sr_loc,
                 input work_sr_wkfl.sr_lotser,
                 input work_sr_wkfl.sr_ref,
                 input det_all)"}
/*K003*/          end.

          if work_sr_wkfl.sr_qty = 0 then delete work_sr_wkfl.

/*J2CY*/  find first work_sr_wkfl no-lock no-error.
/*J2CY*/  /* IF ALL WORK_SR_WKFL RECORDS ARE CONSIDERED THEN EXIT THE LOOP */
/*J2J4**  /*J2CY*/  if not available work_sr_wkfl then qty_to_set = 0. */

/*J2J4*/     if not available work_sr_wkfl then
/*J2J4*/        assign qty_to_set = 0
/*J2J4*/               part_qty   = 0.

           end. /* DO WHILE QTY_TO_SET > 0 */
        end. /* FOR EACH PARENT_CONTAINER */

/*K21D*/   for first abs_buff2
/*K21D*/      fields (abs_canceled abs_cmtindx abs_cons_ship abs_dataset
/*K21D*/              abs_fa_lot abs_format abs_gwt abs_id abs_item
/*K21D*/              abs_lang abs_line abs_loc abs_lotser abs_nwt
/*K21D*/              abs_order abs_par_id abs_qty abs_ref abs_shipfrom
/*K21D*/              abs_shipto abs_ship_qty abs_shp_date abs_site
/*K21D*/              abs_status abs_type abs_vol abs_vol_um
/*K21D*/              abs__qad02 abs__qad03 abs__qad06 abs__qad10) where
/*K21D*/       abs_buff2.abs_shipfrom = ship_from and
/*K21D*/       abs_buff2.abs_id       = l_par_cont no-lock : end.
/*K21D*/   if available abs_buff2 then
/*K21D*/   do:
/*K21D*/       if substring(abs_buff2.abs_id, 1, 1) = "c" then
/*K21D*/       do:
/*K21D*/      /* IF THE IMMEDIATE PARENT OF THE ITEM CREATED IS A CONTAINER   */
/*K21D*/      /* THEN THE ITEM WEIGHTS SHOULD NOT BE ROLLED UP TO CONTAINER   */
/*K21D*/      /* SINCE THIS IS ALREADY DONE IN THE PARENT_CONTAINER LOOP ABOVE*/

/*K21D*/         /* FINDING PARENT RECORD OF THE CONTAINER */
/*K21D*/         for first abs_buff1
/*K21D*/            fields (abs_canceled abs_cmtindx abs_cons_ship abs_dataset
/*K21D*/                    abs_fa_lot abs_format abs_gwt abs_id abs_item
/*K21D*/                    abs_lang abs_line abs_loc abs_lotser abs_nwt
/*K21D*/                    abs_order abs_par_id abs_qty abs_ref abs_shipfrom
/*K21D*/                    abs_shipto abs_ship_qty abs_shp_date abs_site
/*K21D*/                    abs_status abs_type abs_vol abs_vol_um
/*K21D*/                    abs__qad02 abs__qad03 abs__qad06 abs__qad10) where
/*K21D*/            abs_buff1.abs_shipfrom = abs_buff2.abs_shipfrom and
/*K21D*/            abs_buff1.abs_id       = abs_buff2.abs_par_id no-lock: end.
/*K21D*/         if available abs_buff1 then
/*K21D*/            l_recid = recid(abs_buff1).
/*K21D*/       end. /* IF SUBSTRING(ABS_BUFF2,ABS_ID,1,1) = "C"  */
/*K21D*/       else
/*K21D*/          l_recid = recid(abs_buff2).

/*K21D*/       /* ROLLUP NET WEIGHT */
/*K21D*/       {gprun.i ""icshnwt.p""
                        "(input l_recid,
                          input l_abs_tot_net_wt,
                          input yes,
                          input part_wt_um)"}
/*K21D*/       /* ROLLUP TARE WEIGHT */
/*K21D*/       {gprun.i ""icshnwt.p""
                        "(input l_recid,
                          input l_abs_tot_tare_wt,
                          input no,
                          input part_wt_um)"}
/*K21D*/   end. /* IF AVAILABLE ABS_BUFF2 */

            /*  DELETE qad_wkfl for KIT COMPONENTS */
/*K003*/    if can-find (first sob_det where sob_nbr = sod_nbr and
/*K003*/    sob_line = sod_line) then
/*K003*/       {gprun.i ""rcshwbc4.p""
               "(input recid(sod_det))"}

/*K0CZ* /*K022*/    if cmf_flg then                            */
/*K0CZ*/    if cmf_flg  and det_all then
/*K022*/    run create-so-cmf (input recid (sod_det)).

        abnormal_exit = false.

     end. /* MAIN */

     hide frame a no-pause.

/*K003*/ {rcinvcon.i}

/*K022*/ /* Internal procedure get_par_qty */
/*K022*/ {soskit1c.i}

/*K022*/ /* Internal procedure create-so-cmf */
/*K022*/ {rccmf.i}

/* Internal procedure val-fa-id */
/*K022*/ PROCEDURE val-fa-id:

     define input parameter part_fa_lot like wo_lot no-undo.
     define input parameter so_recid as recid no-undo.
     define output parameter err-flg as logical no-undo.

     find sod_det where recid(sod_det) = so_recid no-lock no-error.
     if not available sod_det then return.

/*K15N*** BEGIN DELETE - MOVED TO rcshvid.p FOR MULTI-DB CAPABILITIES ****
 *   find wo_mstr no-lock where
 *       wo_lot = part_fa_lot no-error.
 *   if not available wo_mstr then do:
 *      {mfmsg.i 510 3} /* WO number doesn't exist */
 *      err-flg = yes.
 *      leave.
 *   end.
 *       else if index ("EAR",wo_status) = 0 then do:
 *      {mfmsg.i 523 3} /* WO IS CLOSED PLANNED OR FIRM */
 *      err-flg = yes.
 *      leave.
 *   end.
 *   if wo_nbr <> sod_fa_nbr then
 *       {mfmsg.i 5852 2} /* WO IS FOR DIFF SO  */
 *K15N** END DELETE ******************************************/

/*K15N*/ /* SWITCH TO THE REMOTE SITE */
/*K15N*/ {gprun.i ""gpalias2.p""
          "(input sod_site,
            output error_flag)"}

/*K15N*/ if error_flag <> 0 and error_flag <> 9 then do:
/*K15N*/    /* UNABLE TO CONNECT TO REMOTE DATABASE */
/*N05Q /*K15N*/    {mfmsg03.i 2510 4 {&rcshwbc2_p_6} """" """"} */
/*N0F4 /*N05Q*/  run mess-2510 ({&rcshwbc2_p_6}). */
/*N0F4*/         run mess-2510 (disp-char6).
/*K15N*/    err-flg = yes.
/*K15N*/    leave.
/*K15N*/ end.

/*K15N*/ /* VALIDATE WORK ORDER POSSIBLY IN REMOTE DB */
/*K15N*/ {gprun.i ""rcshvid.p""
          "(input part_fa_lot,
            input sod_fa_nbr,
            output err-flg)"}

/*K15N*/ /* RESET TO CENTRAL DATABASE */
/*K15N*/ {gprun.i ""gpalias3.p""
          "(input so_db,
            output error_flag)"}

/*K15N*/ if error_flag <> 0 and error_flag <> 9 then do:
/*K15N*/    /* UNABLE TO CONNECT TO SALES DATABASE */
/*N05Q /*K15N*/    {mfmsg03.i 2510 4 {&rcshwbc2_p_8} """" """"} */
/*N0F4 /*N05Q*/  run mess-2510 ({&rcshwbc2_p_8}). */
/*N0F4*/         run mess-2510 (disp-char8).
/*K15N*/    err-flg = yes.
/*K15N*/    leave.
/*K15N*/ end.

/*K15N*/ /* CHECKING err-flg FROM rcshvid.p CALL HERE TO ALLOW DB SWITCHING */
/*K15N*/ if err-flg = yes then leave.

          /* CHECK FOR DUPLICATE F/A WO ID                      */
          for each abs_buff no-lock where
          abs_buff.abs_order = sod_nbr
      and abs_buff.abs_shipfrom = sod_site
      and abs_buff.abs_line = string(sod_line):
         if abs_buff.abs_fa_lot = part_fa_lot then do:
                run get_abs_parent (input abs_buff.abs_id,
                                            input abs_buff.abs_shipfrom,
                                            output par_absid,
                                            output par_shipfrom).
                if par_absid <> ? then do:
                   find abs_tmp where abs_tmp.abs_id = par_absid and
                   abs_tmp.abs_shipfrom = par_shipfrom no-lock no-error.
                   if available abs_tmp and
                   (abs_tmp.abs_canceled = no or
                   substring(abs_tmp.abs_status,2,1) <> "y")
                   then do:
                    /* F/A WO ID exists for Pre-shipper/shipper  */
                      {mfmsg.i 5851 3}
                  err-flg = yes.
                  leave.
                   end.
                end.    /* par_absid */
             end.
          end.

      err-flg = no.
/*K022*/ end.   /* END procedure */

/*J2LW*/ PROCEDURE p-get-open:
/*J2LW*/ /* THIS PROCEDURE CALCULATES THE OPEN QTY FOR THE SALES ORDER LINE */

/*J2LW*/ define input parameter l_sod_recid as recid no-undo.

/*J2LW*/ find sod_det where recid(sod_det) = l_sod_recid no-lock.
/*J2LW*/ {openqty.i}
/*J2LW*/ end. /* PROCEDURE P-GET-OPEN */

/*K21D*/ PROCEDURE p_create_item:

/*K21D*/     /* THIS PROCEDURE CREATES ABS_MSTR ITEM RECORDS.          */
/*K21D*/     /* ROLLUP OF ITEM WEIGHTS TO ITS PARENTS IS NOT DONE HERE */

/*K21D*/     /* INPUT PARAMETERS */
/*K21D*/     define input parameter cont_shipfrom    like abs_shipfrom.
/*K21D*/     define input parameter cont_shipto      like abs_shipto.
/*K21D*/     define input parameter cont_id          like abs_id.
/*K21D*/     define input parameter cont_parid       like abs_par_id.
/*K21D*/     define input parameter cont_qty         like abs_qty.
/*K21D*/     define input parameter cont_item        like abs_item.
/*K21D*/     define input parameter cont_loc         like abs_loc.
/*K21D*/     define input parameter cont_lot         like abs_lot.
/*K21D*/     define input parameter cont_ref         like abs_ref.
/*K21D*/     define input parameter cont_wt          like abs_nwt.
/*K21D*/     define input parameter cont_wt_um       like abs_wt_um.
/*K21D*/     define input parameter cont_vol         like abs_vol.
/*K21D*/     define input parameter cont_vol_um      like abs_vol_um.
/*K21D*/     define input parameter cont_site        like abs_site.
/*K21D*/     define input parameter cont_qty_um      like abs__chr02.
/*K21D*/     define input parameter cont_qty_conv    as decimal.
/*K21D*/     define input parameter cont_gwt         like abs_gwt.
/*K21D*/     define input parameter cont_order       like abs_order.
/*K21D*/     define input parameter cont_line        like abs_line.
/*K21D*/     define input parameter cmtindx          like abs_cmtindx.
/*K21D*/     define input parameter part_fa_lot      like wo_lot.
/*M18K*/     define parameter buffer ptmstr          for pt_mstr.

/*K21D*/     /* OUTPUT PARAMETERS */
/*K21D*/     define output parameter line_recno as recid.

/*K21D*/     /* LOCAL VARIABLES */
/*K21D*/     define variable l_abs_tare_wt like abs_nwt no-undo.
/*K21D*/     define variable cont_level    as integer   no-undo.
/*K21D*/     define variable cont_child    like abs_id  no-undo.
/*M18K*/     define variable l_part_wt_conv as decimal  no-undo.

/*K21D*/     /* BUFFERS */
/*K21D*/     define buffer child_container for abs_mstr.

/*K21D*/     assign
/*K21D*/        cont_level = 1
/*K21D*/        cont_child = 'NONE'.

/*K21D*/     create abs_mstr.

/*K21D*/     assign
/*K21D*/     abs_mstr.abs_shipfrom = cont_shipfrom
/*K21D*/     abs_mstr.abs_id       = cont_id
/*K21D*/     abs_mstr.abs_shipto   = cont_shipto
/*K21D*/     abs_mstr.abs_par_id   = cont_parid
/*K21D*/     abs_mstr.abs_qty      = cont_qty
/*K21D*/     abs_mstr.abs_shp_date = today
/*K21D*/     abs_mstr.abs_type     = "s"
/*K21D*/     abs_mstr.abs_item     = cont_item
/*K21D*/     abs_mstr.abs_loc      = cont_loc
/*K21D*/     abs_mstr.abs_lot      = cont_lot
/*K21D*/     abs_mstr.abs__qad06   = string(cont_level,"99")
/*K21D*/     abs_mstr.abs_ref      = cont_ref
/*M18K** /*K21D*/ abs_mstr.abs_gwt = MAX(cont_gwt * cont_qty,0) */
/*M18K** /*K21D*/                    * cont_qty_conv            */
/*K21D*/     abs_mstr.abs_nwt      = MAX(cont_wt * cont_qty,0)
/*K21D*/                             * cont_qty_conv
/*K21D*/     abs_mstr.abs_vol      = MAX(cont_vol * cont_qty * cont_qty_conv, 0)
/*K21D*/     abs_mstr.abs_vol_um   = cont_vol_um
/*K21D*/     abs_mstr.abs_wt_um    = cont_wt_um
/*K21D*/     abs_mstr.abs_site     = cont_site
/*K21D*/     abs_mstr.abs__qad02   = cont_qty_um
/*K21D*/     abs_mstr.abs__qad03   = string(cont_qty_conv)
/*K21D*/     abs_cmtindx           = cmtindx
/*K21D*/     abs_mstr.abs_order    = cont_order
/*K21D*/     abs_mstr.abs_line     = cont_line
/*K21D*/     abs_mstr.abs_fa_lot   = part_fa_lot.

/*M18K*/     if recid(abs_mstr) = -1 then .

/*M18K** /*K21D*/ l_abs_tare_wt=MAX((cont_gwt * cont_qty * cont_qty_conv) - */
/*M18K** /*K21D*/                  (cont_wt * cont_qty * cont_qty_conv),0). */

/*M18K*/     if available ptmstr
/*M18K*/     then do:
/*M18K*/        if pt_ship_wt_um <> pt_net_wt_um
/*M18K*/        then do:
/*M18K*/           {gprun.i ""gpumcnv.p""
                            "(input  pt_ship_wt_um,
                              input  pt_net_wt_um,
                              input  pt_part,
                              output l_part_wt_conv)"}
/*M18K*/           if l_part_wt_conv = ?
/*M18K*/           then do:
/*M18K*/              {mfmsg.i 33 2}
/*M18K*/              /* NO UM CONVERSION EXISTS */
/*M18K*/              l_part_wt_conv = 1.
/*M18K*/           end. /* IF l_part_wt_conv = ? */
/*M18K*/        end. /* IF pt_ship_wt_um <> pt_net_wt_um */
/*M18K*/        else
/*M18K*/           l_part_wt_conv = 1.
/*M18K*/        l_abs_tare_wt  = MAX ((pt_ship_wt * cont_qty * cont_qty_conv
/*M18K*/                               * l_part_wt_conv) -
/*M18K*/                             (pt_net_wt * cont_qty * cont_qty_conv),0).
/*M18K*/        if cont_wt_um <> pt_net_wt_um
/*M18K*/        then do:
/*M18K*/           {gprun.i ""gpumcnv.p""
                            "(input  pt_net_wt_um,
                              input  cont_wt_um,
                              input  pt_part,
                              output l_part_wt_conv)"}
/*M18K*/           if l_part_wt_conv = ?
/*M18K*/           then do:
/*M18K*/              {mfmsg.i 33 2}
/*M18K*/              /* NO UM CONVERSION EXISTS */
/*M18K*/              l_part_wt_conv = 1.
/*M18K*/           end. /* IF l_part_wt_conv = ? */
/*M18K*/           l_abs_tare_wt = l_abs_tare_wt * l_part_wt_conv.
/*M18K*/        end. /* IF cont_wt_um <> pt_net_wt_um */
/*M18K*/     end. /* IF AVAIL pt_mstr */
/*M18K*/     else
/*M18K*/        l_abs_tare_wt    = 0.

/*K21D*/     {abspack.i "abs_mstr" 26 22 "l_abs_tare_wt" }

/*M18K*/     abs_mstr.abs_gwt = abs_mstr.abs_nwt + l_abs_tare_wt.

/*K21D*/     line_recno = recid(abs_mstr).

/*K21D*/     /* ASSIGN NET WT TO GROSS WT IF ITEM SHIP WT IS ZERO  */
/*K21D*/     /* IN PART MASTER                                     */
/*K21D*/     if abs_mstr.abs_gwt = 0 and abs_mstr.abs_nwt <> 0 then
/*K21D*/        abs_mstr.abs_gwt = abs_mstr.abs_nwt.

/*K21D*/     /* ACCUMULATING WEIGHTS OF CHILD ITEMS TO BE ROLLED UP          */
/*K21D*/     /* TO ITS PARENT                                                */
/*K21D*/     assign
/*K21D*/        l_abs_tot_tare_wt  = l_abs_tot_tare_wt + l_abs_tare_wt
/*K21D*/        l_abs_tot_net_wt   = l_abs_tot_net_wt  + abs_mstr.abs_nwt
/*N160*/        l_total_tare_wt    = l_total_tare_wt   + l_abs_tare_wt
/*N160*/        l_total_net_wt     = l_total_net_wt    + abs_mstr.abs_nwt.


/*K21D*/     if det_all then
/*K21D*/     do:
/*K21D*/        {abspack.i "abs_mstr" 3 22 "adj_qty / cont_qty_conv" }
/*K21D*/     end. /* IF DET_ALL */

/*K21D*/     if cont_child <> "NONE" then
/*K21D*/     do:
/*K21D*/        find child_container
/*K21D*/           where child_container.abs_shipfrom = cont_shipfrom
/*K21D*/           and child_container.abs_id = cont_child
/*K21D*/        exclusive-lock no-error.

/*K21D*/        if available child_container then
/*K21D*/           child_container.abs_par_id = abs_mstr.abs_id.

/*K21D*/     end. /* IF CONT_CHILD <> "NONE" */

/*K21D*/     if recid(abs_mstr) = -1 then.

/*K21D*/ end. /* PROCEDURE P_CREATE_ITEM */

/*K21C*/ PROCEDURE p_upd_ship_fob:

/*K21C*/  /* THE SHIPVIA AND FOB OF PARENT SHIPPER ARE UPDATED WITH THE    */
/*K21C*/  /* CORRESPONDING VALUES OF SALES ORDER OF THE FIRST SHIPPER LINE */
/*K21C*/  /* ONLY IF THEY ARE BLANK.                                       */

/*K21C*/    define input parameter l_temp_par   as   character  no-undo.
/*K21C*/    define input parameter l_part_order like so_nbr     no-undo.

/*K21C*/    define buffer abs_buff3 for abs_mstr.
/*K21C*/    define buffer abs_buff4 for abs_mstr.

/*K21C*/    do for abs_buff3:

/*K21C*/       find first abs_buff3 where
/*K21C*/          recid(abs_buff3) =
/*K21C*/          integer(substring(l_temp_par,(index(l_temp_par,"::") + 2)))
/*K21C*/          exclusive-lock no-error.

/*K21C*/       if available abs_buff3 and
/*K21C*/          (right-trim(substring(abs_buff3.abs__qad01,1,20)) = "" or
/*K21C*/           right-trim(substring(abs_buff3.abs__qad01,21,20)) = "")
/*K21C*/       then do for abs_buff4:

/*K21C*/         for first abs_buff4
/*K21C*/           fields(abs_shipfrom abs_par_id abs_id)
/*K21C*/           where abs_buff4.abs_shipfrom = abs_buff3.abs_shipfrom
/*K21C*/           and   abs_buff4.abs_par_id   = abs_buff3.abs_id
/*K21C*/           and   abs_buff4.abs_id begins "i"
/*K21C*/           no-lock:
/*K21C*/         end. /* FOR FIRST ABS_BUFF4 */

/*K21C*/         if not available abs_buff4
/*K21C*/         then do:
/*K21C*/           for first so_mstr
/*K21C*/              fields(so_nbr so_shipvia so_fob)
/*K21C*/              where so_nbr = l_part_order
/*K21C*/              no-lock:
/*K21C*/           end. /* FOR FIRST SO_MSTR */

/*K21C*/           if available so_mstr
/*K21C*/           then do:
/*K21C*/              if right-trim(substring(abs_buff3.abs__qad01,1,20)) = ""
/*K21C*/              then
/*K21C*/                 substring(abs_buff3.abs__qad01,1,20) =
/*K21C*/                                         string(so_shipvia,"x(20)").
/*K21C*/              if right-trim(substring(abs_buff3.abs__qad01,21,20)) = ""
/*K21C*/              then
/*K21C*/                 substring(abs_buff3.abs__qad01,21,20) =
/*K21C*/                                         string(so_fob,"x(20)").
/*K21C*/           end. /* IF AVAILABLE SO_MSTR */

/*K21C*/         end. /* IF NOT AVAILABLE ABS_BUFF4 */

/*K21C*/       end. /* IF AVAILABLE ABS_BUFF3 */

/*K21C*/    end. /* DO FOR ABS_BUFF3 */

/*K21C*/ end. /* PROCEDURE p_upd_ship_fob */

/*N03S*/ PROCEDURE assign_part_defaults:
            assign
               part_loc = sod_det.sod_loc
               part_site = ship_from
               part_qty = 0
               part_qty_um = if available pt_mstr
                             then pt_mstr.pt_um else sod_um
               part_qty_conv = 1
               part_wght = if available pt_mstr then pt_net_wt else 0
               part_wt_um = if available pt_mstr then pt_net_wt_um else ""
               part_vol = if available pt_mstr then pt_size else 0
               part_vol_um = if available pt_mstr then pt_size_um else ""
               part_lot_ser = ""
               part_ref = ""
               multiple = false
               lotserial_control = if available pt_mstr
                                   then pt_lot_ser else ""
               cmmts = false
               global_part = if available pt_mstr then pt_part else part_item.
/*N03S*/ end. /* PROCEDURE assign_part_defaults */

/*N03S*/ PROCEDURE assign_multiple_info:
            assign
               cline = ""
               site = part_site
               location = part_loc
               lotserial = part_lot_ser
               lotserial_qty = part_qty
               trans_um = part_qty_um
/*L107**       trans_conv = 1           */
/*L107*/       trans_conv = part_qty_conv
               lotnext = ""
               lotprcpt = no
               lotref = part_ref.
/*N03S*/ end. /* PROCEDURE assign_multiple_info */

/*N03S*/ PROCEDURE calc_container_weights:

            if l_pt_ship_wt = 0 and part_wght <> 0 then
               /* ASSIGN NET WT TO GROSS WT IF ITEM SHIP WT IS ZERO  */
               /* IN PART MASTER                                     */
               assign
                  parent_container.abs_nwt = parent_container.abs_nwt +
                     MAX(part_wght * this_rec_qty2 * part_qty_conv,0)
                     * l_conv
                  parent_container.abs_gwt =  parent_container.abs_gwt +
                     MAX(part_wght * this_rec_qty2 * part_qty_conv,0)
                     * l_conv.
            else
               assign
                  parent_container.abs_nwt = parent_container.abs_nwt +
                     MAX(part_wght * this_rec_qty2 * part_qty_conv,0)
                     * l_conv
                  parent_container.abs_gwt = parent_container.abs_gwt +
/*M18K**             MAX(l_pt_ship_wt * this_rec_qty2 * part_qty_conv,0) */
/*N160** /*M18K*/    (l_abs_tot_tare_wt + l_abs_tot_net_wt)              */
/*N160*/             (l_total_tare_wt + l_total_net_wt)
                     * l_conv.
/*K250*/    if parent_container.abs_wt_um = "" then
               parent_container.abs_wt_um = part_wt_um.

/*N03S*/ end. /* PROCEDURE calc_container_weights */

/*N05Q*/ PROCEDURE mess-764:
            {mfmsg.i 764 3} /* SALES ORDER LINE DOES NOT EXIST */
         end. /* PROCEDURE mess-764 */

/*N05Q*/ PROCEDURE mess-2510:

            define input parameter messtext as character.

            {mfmsg03.i 2510 4 messtext """" """"}
            /* UNABLE TO CONNECT TO REMOTE DATABASE */
         end. /* PROCEDURE mess-2510 */

/*N05Q*/ FUNCTION prm-ssm-error-checking returns logical ():

            for first so_mstr
            where so_mstr.so_nbr = part_order
            no-lock:
               if so_mstr.so_fsm_type = "PRM" then do:
                  /* USE PRM MODULE TRANSACTIONS FOR PRM PENDING INVOICES */
                  {mfmsg.i 3434 4}
                  return yes.
               end.
               else if so_mstr.so_fsm_type <> "" then do:
                  /* USE SSM MODULE TRANSACTIONS FOR SSM ORDERS */
                  {mfmsg.i 1933 4}
                  return yes.
               end.
            end. /* FOR FIRST SO_MSTR */
            return no.

         end function. /* prm-ssm-error-checking */

/*M1TT*/ PROCEDURE DisplayMessage:
         define input parameter ipMsgNum as integer no-undo.
         define input parameter ipLevel  as integer no-undo.
         define input parameter ipMsg1   as character no-undo.

         {pxmsg.i &MSGNUM     = ipMsgNum
                  &ERRORLEVEL = ipLevel
                  &MSGARG1    = ipMsg1}
/*M1TT*/ END PROCEDURE. /* PROCEDURE DisplayMessage */
