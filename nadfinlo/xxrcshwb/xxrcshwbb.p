/* rcshwbb.p - SHIPPER WORKBENCH - SUB PROGRAM                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=Maintenance                                                 */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                      */
/* VERSION 7.5        LAST MODIFIED: 07/18/95   BY: GWM  *J049*              */
/* VERSION 8.5        LAST MODIFIED: 04/16/96   BY: GWM  *J0JC*              */
/* VERSION 8.5        LAST MODIFIED: 04/24/96   BY: GWM  *J0K8*              */
/* REVISION 8.5       LAST MODIFIED: 06/05/96   BY: GWM  *J0QY*              */
/* REVISION 8.5       LAST MODIFIED: 07/10/96   BY: AJW  *J0YL*              */
/* REVISION 8.5       LAST MODIFIED: 07/28/96   BY: taf  *J12M*              */
/* REVISION 8.5       LAST MODIFIED: 07/31/96   BY: jpm  *J134*              */
/* REVISION: 8.6      LAST MODIFIED: 08/03/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 09/20/96   BY: TSI  *K005*              */
/* REVISION: 8.6      LAST MODIFIED: 10/30/96   BY: *K003* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *K003* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 12/02/96   BY: *J18G* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 12/03/96   BY: *K02T* Chris Theisen     */
/* REVISION: 8.6      LAST MODIFIED: 12/25/96   BY: *K03S* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 12/30/96   BY: *K022* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 01/26/96   BY: *K03K* Vinay Nayak-Sujir */
/* REVISION: 8.5      LAST MODIFIED: 02/12/97   BY: *J1HV* B. Gates          */
/* REVISION: 8.6      LAST MODIFIED: 02/28/97   BY: *K06K* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.5      LAST MODIFIED: 03/24/97   BY: *J1LY* Kieu Nguyen       */
/* REVISION: 8.5      LAST MODIFIED: 03/24/97   BY: *G2M9* David Seo         */
/* REVISION: 8.6      LAST MODIFIED: 05/09/97   BY: *K0CZ* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 06/11/97   BY: *K0DY* Taek-Soo Chang    */
/* REVISION: 8.6      LAST MODIFIED: 07/13/97   BY: *K0DH* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 09/23/97   BY: *K0J7* John Worden       */
/* REVISION: 8.6      LAST MODIFIED: 09/24/97   BY: *K0JC* John Worden       */
/* REVISION: 8.6      LAST MODIFIED: 10/24/97   BY: *J246* Nirav Parikh      */
/* REVISION: 8.6      LAST MODIFIED: 10/28/97   BY: *K165* John Worden       */
/* REVISION: 8.6      LAST MODIFIED: 11/11/97   BY: *K18W* Suresh Nayak      */
/* REVISION: 8.6      LAST MODIFIED: 11/18/97   BY: *J22Y* Ajit Deodhar      */
/* REVISION: 8.6      LAST MODIFIED: 12/19/97   BY: *K1F0* Niranjan R.       */
/* REVISION: 8.6      LAST MODIFIED: 11/24/97   BY: *K15N* Jim Williams      */
/* REVISION: 8.6      LAST MODIFIED: 01/30/98   BY: *J2BZ* Seema Varma       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/06/98   BY: *J2CQ* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *K1NF* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *J2LW* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *J2MH* Dans Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 07/16/98   BY: *L042* Surekha Joshi     */
/* REVISION: 8.6E     LAST MODIFIED: 07/22/98   BY: *J2M7* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 07/30/98   BY: *J2RL* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2S5* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 08/11/98   BY: *J2TP* Poonam Bahl       */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *K1WG* Seema Varma       */
/* REVISION: 8.6E     LAST MODIFIED: 09/10/98   BY: *J2ZC* Manish K.         */
/* REVISION: 9.0      LAST MODIFIED: 11/09/98   BY: *J33X* Seema Varma       */
/* REVISION: 9.0      LAST MODIFIED: 11/19/98   BY: *J34T* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *J35D* Manish K.         */
/* REVISION: 9.0      LAST MODIFIED: 01/12/99   BY: *J37V* Seema Varma       */
/* REVISION: 9.0      LAST MODIFIED: 01/11/99   BY: *J389* Surekha Joshi     */
/* REVISION: 9.0      LAST MODIFIED: 02/02/99   BY: *J399* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED: 02/17/99   BY: *J394* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 06/07/99   BY: *K20P* Sanjeev Assudani  */
/* REVISION: 9.1      LAST MODIFIED: 08/06/99   BY: *K21H* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 08/18/99   BY: *K223* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 09/29/99   BY: *K238* Kedar Deherkar    */
/* REVISION: 9.1      LAST MODIFIED: 10/05/99   BY: *K21N* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 10/28/99   BY: *J3GJ* Sachin Shinde     */
/* REVISION: 9.1      LAST MODIFIED: 11/09/99   BY: *K22Q* J. Fernando       */
/* REVISION: 9.1      LAST MODIFIED: 05/28/99   BY: *N004* Patrick Rowan     */
/* REVISION: 9.1      LAST MODIFIED: 12/02/99   BY: *L0M0* Manish K.         */
/* REVISION: 9.1      LAST MODIFIED: 02/16/00   BY: *L0RV* Sachin Shinde     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 04/24/00   BY: *L0PR* Kedar Deherkar    */
/* REVISION: 9.1      LAST MODIFIED: 08/04/00   BY: *L12G* Ashwini G.        */
/* REVISION: 9.1      LAST MODIFIED: 08/16/00   BY: *L12R* Ashwini G.        */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *M0RX* Ashwini G.        */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *N0NH* Dave Caveney      */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *L14M* Falguni Dalal     */
/* REVISION: 9.1      LAST MODIFIED: 10/30/00   BY: *M0VG* Seema Tyagi       */
/* REVISION: 9.1      LAST MODIFIED: 02/07/01   BY: *M110* Kaustubh K.       */
/* REVISION: 9.1      LAST MODIFIED: 09/30/00   BY: *N0WX* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 03/15/01   BY: *N0TY* Reetu Kapoor      */
/* REVISION: 9.1      LAST MODIFIED: 05/21/01   BY: *M16Y* Kirti Desai       */
/* REVISION: 9.1      LAST MODIFIED: 06/14/01   BY: *M1B7* Kedar Deherkar    */
/* REVISION: 9.1      LAST MODIFIED: 07/10/01   BY: *K26P* Hareesh V.        */
/* REVISION: 9.1      LAST MODIFIED: 07/24/01   BY: *M1D0* Kirti Desai       */
/* REVISION: 9.1      LAST MODIFIED: 07/26/01   BY: *L13N* Rajaneesh S.      */
/* REVISION: 9.1      LAST MODIFIED: 10/03/01   BY: *M1FF* Nikita Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 03/12/02   BY: *N1CN* Vandna Rohira     */

         {mfdeclre.i}

/*N0WX*/ {cxcustom.i "RCSHWBB.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

/*L0PR*/ /* ADDED CANC B/O IN PRE-PROCESSOR RCSHWBB_P_1 */
&SCOPED-DEFINE rcshwbb_p_1 "Order    Ln  Item Number           Quantity UM Container Canc B/O"
/* MaxLen: 98 Comment: */

&SCOPED-DEFINE rcshwbb_p_2 "Comments"
/* MaxLen: Comment: */

/*M110** &SCOPED-DEFINE rcshwbb_p_3 "'For Sales Orders'" */
/* MaxLen: Comment: */

/*M110** &SCOPED-DEFINE rcshwbb_p_4 "'For Remote Inventory'" */
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         /* INPUT PARAMETERS */
         define input parameter ship_from as character.
         define input parameter tmp_prefix as character.
         define input parameter abs_recid as recid.

         /* LOCAL VARIABLES */
         define variable save_frame_line as integer no-undo.
         define variable i as integer no-undo.
         define variable first_column as character format "X(5)" no-undo.
         define variable transtype as character initial "ISS-UNP" no-undo.
         define variable nullstr as character no-undo.
         define variable undotran like mfc_logical no-undo.
         define variable del-yn like mfc_logical no-undo.
/*J0K8*
.        define variable statusline as character init
.    "F1-Go 2-Hlp 3-Add 4-End 5-Delete 6-Mnu 7-Rcl 8-Clr 9-Prev 10-Next 11-Buf"
.           no-undo.
.*J0K8*/
         define variable delete_recid as recid no-undo.
         define variable sel_var_add as integer format "9" no-undo.
         define variable sel_var_del as integer format "9" no-undo.
         define variable error_lot as logical no-undo.
         define variable error_part as logical no-undo.
         define variable valid_entry as logical no-undo.
         define variable refresh as logical no-undo.
         define variable cont_id as character format "X(9)" no-undo.
         define variable return_code as integer no-undo.
         define variable sort_recs as logical no-undo.
         define variable create_recs as logical no-undo.
         define variable gwt_um as character no-undo.
         define variable disp_line as character format "X(69)"
            label {&rcshwbb_p_1}
            no-undo.
         define variable shipto_name like ad_name no-undo.
         define variable shipto_code like abs_shipto no-undo.
         define variable nwt_old like abs_nwt no-undo.
/*K005*/ define variable absship_recid as recid no-undo.
/*K005*/ define variable par_id as character no-undo.
/*K005*/ define variable cnsm_req as logical no-undo.
/*K005*/ define variable open_qty like schd_all_qty no-undo.
/*K005*/ define variable peg_qty like schd_all_qty no-undo.
/*K003*/ define variable shipgrp like sgad_grp no-undo.
/*K003*/ define variable cmmts like mfc_logical label {&rcshwbb_p_2}
/*K003*/         no-undo.
/*K003*/ define variable parent_abs_recid as recid no-undo.
/*K003*/ define variable errorst as logical no-undo.
/*K003*/ define variable errornum as integer no-undo.
/*K003*/ define variable can_discard as logical no-undo.
/*K003*/ define variable msgnum as integer no-undo.
/*K003*/ define variable pick_qty like sod_qty_pick no-undo.
/*K003*/ define variable tmp_qty like sod_qty_pick no-undo.
/*K003*/ define variable avail_qty like sod_qty_pick no-undo.
/*K003*/ define variable old_lot like lad_lot no-undo.
/*K003*/ define variable old_qty like lad_qty_all no-undo.
/*K003*/ define variable old_loc like lad_loc no-undo.
/*K003*/ define variable old_site like lad_site no-undo.
/*K003*/ define variable old_ref like lad_ref no-undo.
/*K003*/ define variable kit_comp as logical no-undo.
/*K003*/ define variable del_lad as logical no-undo.
/*K022*/ define variable cmf_flg as logical no-undo.
/*J1HV*/ define variable qty_old as decimal no-undo.
/*J1HV*/ define variable vol_old as decimal no-undo.
/*J1HV*/ define variable ok_to_recalc_wt_vol like mfc_logical no-undo.
/*K04X*/ define variable v_editall as logical no-undo.
/*K0DY*/ define variable ch_nwt like abs_nwt no-undo.
/*K0J7*/ define variable next_editloop as logical no-undo.
/*K0J7*/ define variable next_mainloop as logical no-undo.
/*K0JC*/ define variable original_nwt like abs_nwt no-undo.
/*K0JC*/ define variable original_gwt like abs_gwt no-undo.
/*K0JC*/ define variable so_ok as logical no-undo.
/*K0JC*/ define variable part_order like abs_order no-undo.
/*K0JC*/ define variable part_order_line like abs_line no-undo.
/*K0JC*/ define variable v-abs_format like abs_mstr.abs_format no-undo.
/*K18W*/ define variable adj_qty like ld_qty_all no-undo.
/*K15N*/ define variable fas_so_rec as character.
/*J22Y*/ define variable leave_editloop as logical no-undo.
/*K1NF*/ define variable l_abs_pick_qty like sod_qty_pick no-undo.
/*J2LW*/ define variable v_unpicked_qty like sod_qty_pick no-undo.
/*J2LW*/ define variable l_part_qty     like abs_qty      no-undo.

/*J2M7*/ define variable l_twt_old        like abs_nwt      no-undo.
/*J2M7*/ define variable l_abs_tare_wt    like abs_nwt      no-undo.
/*J2M7*/ define variable l_twt_um         as character      no-undo.
/*K1WG*/ define variable l_tr_type        like tr_type      no-undo.
/*J37V*/ define variable l_order_change   like mfc_logical  no-undo.
/*K21H*/ define variable l_warning        like mfc_logical  no-undo.
/*N004*/ define variable rcf_file_found   like mfc_logical no-undo.
/*L0M0*/ define variable l_updalloc       like mfc_logical  no-undo.
/*L0M0*/ define variable l_delproc        like mfc_logical  no-undo.
/*L0PR*/ define variable cancel_bo        like mfc_logical  no-undo.
/*L12G*/ define variable l_prev_pick_qty  like l_abs_pick_qty no-undo.
/*L12G*/ define variable l_lad_qty_all    like lad_qty_all    no-undo.
/*N0TY*/ define variable l_avail_qty      like lad_qty_all    no-undo.

         /* OUTPUT VARIABLES */
         define new shared variable new_site like si_site.
         define new shared variable err_stat as integer.
         define new shared variable so_db as character.
/*K003*/ define new shared variable cmtindx like cmt_indx.

/*J2S5*/ define shared variable ship_so   like so_nbr.
/*J2S5*/ define shared variable ship_line like sod_line.

         define variable add_container as logical no-undo.
         define variable add_item as logical no-undo.
         define variable add_parent_container as logical no-undo.
/*K0JC*/ define variable add_existing_container as logical no-undo.
/*K15N*/ define variable sodfanbr like sod_fa_nbr.

         /* BUFFERS */
         define buffer ship_line for abs_mstr.
/*K003*/ define buffer abs_parent_buff for abs_mstr.
/*K165*/ define buffer abs_child_buff for abs_mstr.

/*M0VG*/ define variable h_nrm as handle no-undo.

/*M110*/ define variable l_msgar1 as character format "X(26)" extent 2 no-undo.
/*M110*/ assign
/*M110*/    l_msgar1[1] = getTermLabel("FOR_SALES_ORDERS",22)
/*M110*/    l_msgar1[2] = getTermLabel("FOR_REMOTE_INVENTORY",26).

         /* CONTAINER WORKBENCH FORMS */
         {rcshwbfm.i}

/*N004*/ /* DETERMINE IF CUST. SEQ. CONTROL FILE EXISTS */
/*N004*/ run check_tablename
/*N004*/        (input "rcf_ctrl",
/*N004*/         output rcf_file_found).

         /* INITIALIZE CENTRAL DATABASE ALIAS NAME */
/*J33X*/ /* COMBINED THE FOLLOWING ASSIGNMENTS IN A SINGLE */
/*J33X*/ /* ASSIGN STATEMENT TO REDUCE ACTION SEGMENT SIZE */
/*L0M0*/ /* INITIALIZE L_UPDALLOC AND L_DELPROC */
/*J33X*/ assign
            so_db = global_db
/*L0M0*/    l_updalloc = yes
/*L0M0*/    l_delproc = no
/*K003*/    del_lad = no
/*K003*/    parent_abs_recid = abs_recid
/*K005*/    absship_recid = abs_recid.
/*K003*/ find first fac_ctrl no-lock no-error.
/*K15N*/ if available fac_ctrl then fas_so_rec = string(fac_so_rec).

/*K04X*/ /* Check whether all data is editable, or only informational fields */
/*K04X*/ run ip_editall (abs_recid, output v_editall).

         find ship_line where recid(ship_line) = abs_recid no-lock no-error.

         if not available ship_line then
         assign
            add_container = true
            add_item = true
            add_parent_container = true
/*K0JC*/    add_existing_container = true
            create_recs = true.
         else do:
            assign
               shipto_code = ship_line.abs_shipto
/*K0JC*/       v-abs_format = ship_line.abs_format
               sort_recs = true.

            find ad_mstr where ad_addr = ship_line.abs_shipto no-lock no-error.
            if available ad_mstr then shipto_name = ad_name.
         end.

         MAINLOOP:
         repeat:

            /* CREATE NEW RECORDS */
            if create_recs then do:

               {gprun.i ""rcctwbc.p""
                        "(input ship_from,
                          input add_container,
                          input add_item,
                          input add_parent_container,
                          input tmp_prefix,
                          input true,
                          input shipto_code,
                          input-output abs_recid)"}.

/*K0JC*/       if add_existing_container then do:
/*K0JC*/         {gprun.i ""rcshwbd.p""
                   "(input ship_from,
                     input tmp_prefix,
                     input shipto_code,
                     input v-abs_format,
                     input-output abs_recid)"}
/*K0JC*/       end.

               /* RESORT AND REPAINT THE SCREEN WITH NEW RECORDS */
               assign
               sort_recs = true
               create_recs = false.

            end. /* IF CREATE_RECS */

/*K003*  CHANGE SCOPE_TRANS TO RELEASE LOCKING OF IM_MSTR WHEN DETAIL ALLOC */
/*K003*        SCOPE_TRANS:        */
/*K003*        do transaction:     */

               EDITLOOP:
               repeat with frame k:

                  /* SORT THE RECORDS AND EXCLUSIVE-LOCK THEM ALL */
                  if sort_recs then do:

/*J0QY*              {gprun.i ""rcctwba.p""
 *                            "(input abs_recid,
 *                              input tmp_prefix,
 *J0QY*                         output return_code)"}. */
/*J0QY*/             {gprun.i ""rcshwbs.p""
                              "(input abs_recid,
                                input tmp_prefix,
                                output return_code)"}.

                     /* HANDLE ERRORS */
                     if return_code > 0 then
                     undo EDITLOOP, leave MAINLOOP.

                     assign
                        sort_recs = false
                        abs_recid = ?
                        refresh = true.
                  end.

                  /* REPAINT THE SCREEN */
                  if refresh then do:

/*J0K8*              status input statusline.         */
/*J0K8*/             status input stline[13].
                     clear frame k all no-pause.

                     /* FIND SAVED RECORD */
                     if abs_recid <> ? then
                     find ship_line where recid(ship_line) = abs_recid
                     no-lock no-error.

                     /* NO SAVED RECORD OR SAVED RECORD NOT FOUND */
                     if abs_recid = ? or not available ship_line then do:

                        find first ship_line
                        where ship_line.abs_shipfrom = ship_from
                        and ship_line.abs_shipto begins tmp_prefix
                        no-lock no-error.

                        /* NO MORE RECORDS AVAILABLE SO LEAVE EDITING */
                        if not available ship_line then leave MAINLOOP.

                        assign
                        save_frame_line = 1
                        abs_recid = ?.
                     end.

                     /* BACK OFF RECORDS SO THAT THE RECORD WILL BE DISPLAYED */
                     /* IN THE SAME FRAME LINE AS BEFORE */
                     i = save_frame_line.

                     do while i > 1:

                        find prev ship_line
                        where ship_line.abs_shipfrom = ship_from
                        and ship_line.abs_shipto begins tmp_prefix
                        no-lock no-error.

                        i = i - 1.
                     end.

                     /* REFRESH THE FRAME */
                     i = 0.
/*K0JC*              do while i < 8: */
/*K0JC*/             do while i < 7:

                        if available ship_line then do:

/*L0PR*/                   for first sod_det
/*L0PR*/                      fields (sod_cfg_type sod_contr_id sod_fa_nbr
/*L0PR*/                              sod_line sod_nbr sod_part sod_pickdate
/*L0PR*/                              sod_qty_all sod_qty_ord sod_qty_pick
/*L0PR*/                              sod_qty_ship sod_sched sod_type
/*L0PR*/                              sod_um_conv sod__qadl01)
/*L0PR*/                      where sod_nbr  = ship_line.abs_order
/*L0PR*/                       and  sod_line = integer(abs_line) no-lock:
/*L0PR*/                   end. /* FOR FIRST SOD_DET */

                           /* SET UP DISP_LINE */
                           {rcshwbb1.i}
                           message minimum(4,integer(ship_line.abs__qad06)) ship_line.abs__qad06 view-as alert-box.
                           display
                           fill(".",minimum(4,integer(ship_line.abs__qad06)))
                              + ship_line.abs__qad06
                              @ first_column
                              disp_line
                           with frame k.

                           find next ship_line
                           where ship_line.abs_shipfrom = ship_from
                           and ship_line.abs_shipto begins tmp_prefix
                           no-lock no-error.

                        end.

                        i = i + 1.
/*K0JC*                 if i < 8 then down 1 with frame k. */
/*K0JC*/                if i < 7 then down 1 with frame k.
                     end. /* DO WHILE I < 8 */

/*M1D0*/             /* INTRODUCED TRANSACTION BLOCK TO MINIMISE */
/*M1D0*/             /* abs_mstr LOCKING                         */
/*M1D0*/             do transaction:

                        /* FIND THE SAVED RECORD */
                        if abs_recid <> ? then
                           find ship_line where recid(ship_line) = abs_recid
                           exclusive-lock no-error.

                        /* FIND THE FIRST RECORD */
                        else
                           find first ship_line
                           where ship_line.abs_shipfrom = ship_from
                           and ship_line.abs_shipto begins tmp_prefix
                           exclusive-lock no-error.

/*M1D0*/             end. /* DO TRANSACTION */

                     /* MOVE UP TO THE SELECTED RECORD IN THE FRAME */
                     up frame-line(k) - save_frame_line.

                     refresh = false.
                  end. /* IF REFRESH */

                  /* RESTORE FIRST_COLUMN */
                  color display normal first_column with frame k.

                  find pt_mstr where pt_part = ship_line.abs_item
                  no-lock no-error.

                  find sod_det where sod_nbr = ship_line.abs_order
                  and sod_line = integer(abs_line) no-lock no-error.

/*K022*/          find so_mstr where so_nbr = ship_line.abs_order
/*K022*/          no-lock no-error.

/*K02T*  /*K005*/ cnsm_req = can-find(first absr_det where absr_id = abs_id). */
/*K02T*/          cnsm_req = can-find(first absr_det
/*K02T*/                        where absr_shipfrom = abs_shipfrom
/*K02T*/                          and absr_id = abs_id).

/*K22Q*/ /* FIND WAS REDUNDANT AND NOT BASED ON AN INDEX AND THEREFORE IT */
/*K22Q*/ /* HAS BEEN REMOVED.                                             */

/*K22Q** /*K005*/ cnsm_req = can-find(first absr_det where absr_id = abs_id). */

                  /* SET UP DISP_LINE */
                  {rcshwbb1.i}

/*K003*   ADDED FOLLOWING */
                  /* SET GLOBAL_DB USING ABS_SITE */
/*K003*/                  new_site = ship_line.abs_site.
/*K003*/                  {gprun.i ""gpalias.p""}

                  /* SWITCH TO THE INVENTORY SITE */
/*K003*/          if so_db <> global_db then do:
/*K003*/              {gprun.i ""gpalias2.p""
/*K003*/                       "(ship_line.abs_site, output errornum)"}
/*K003*/              if errornum <> 0 and errornum <> 9 then do:
                         /* DATABASE # IS NOT CONNECTED */
/*M110** /*K003*/        {mfmsg03.i 2510 4 {&rcshwbb_p_4} """" """"} */
/*M110*/                 /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                 run p-pxmsg (input 2510,
                      input 4,
                                      input l_msgar1[2]).

/*K003*/              end.
/*K15N*/              /* FIND FINAL ASSEMBLY CONTROL IN REMOTE DB */
/*K15N*/              {gprun.i ""sofactrl.p"" "(output fas_so_rec)"}
/*K003*/          end.

/*K18W*/ /* CALL TO soitallb.p USED TO GET THE DEFAULT VALUE OF  */
/*K18W*/ /* pick_qty. THIS CALL IS COMMENTED BECAUSE WE ARE REPLACING    */
/*K18W*/ /* pick_qty with abs__dec01.                                    */

/*K18W**BEGIN DELETE**
 *                  /* GET QTY AVAILABLE TO ALLOCATE  AND DISPLAY IT */
 * /*K003*/           {gprun.i ""soitallb.p""
 *                        "(input ship_line.abs_order,
 *                         input ship_line.abs_line,
 *                         input ship_line.abs_item,
 *                         input ship_line.abs_site,
 *                         input ship_line.abs_loc,
 *                         input ship_line.abs_lot,
 *                         input ship_line.abs_ref,
 *                         input "0" ,
 *                         input del_lad,
 *                         output avail_qty,
 *                         output pick_qty)"}
 **K18W**END DELETE*/

                  /* SWITCH BACK TO THE SALES ORDER DATABASE */
/*K003*/          if so_db <> global_db then do:
/*K003*/             {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}
/*K003*/             if errornum <> 0 and errornum <> 9 then do:
                        /* DATABASE # IS NOT CONNECTED */
/*M110** /*K003*/       {mfmsg03.i 2510 4 {&rcshwbb_p_3} """" """"} */
/*M110*/                /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                run p-pxmsg (input 2510,
                                     input 4,
                                     input l_msgar1[1]).
/*K003*/             end.
/*K003*/          end.

                  display
                     disp_line
                  with frame k.
/*K1NF*/          {absupack.i  "ship_line" 3 22 "l_abs_pick_qty" }
/*J2M7*/          {absupack.i  "ship_line" 26 22 "l_abs_tare_wt" }

/*M1B7*/          status input stline[13].
           message ship_line.abs_order ship_line.abs_line ship_line.abs_gwt view-as alert-box.
                  /* DISPLAY OTHER INFO FOR THE RECORD IN THE LOWER FRAME */
                  display
/*K0JC*/             ship_line.abs_order @ part_order
/*K0JC*/             ship_line.abs_line @ part_order_line
                     ship_line.abs_qty
/*K18W** /*K003*/    pick_qty     */
/*K1NF** /*K18W*/    ship_line.abs__dec01 */
/*K1NF*/             l_abs_pick_qty
/*J2M7*/             l_abs_tare_wt
/*J2M7*/             ship_line.abs_wt_um @ l_twt_um
                     ship_line.abs__qad02
                     ship_line.abs_site
                     ship_line.abs_loc
                     ship_line.abs_nwt
                     ship_line.abs_wt_um
                     ship_line.abs_lot
                     ship_line.abs_gwt
                     ship_line.abs_wt_um @ gwt_um
                     ship_line.abs_ref
/*J1LY*/             sod_type when (available sod_det)
/*J1LY*/             "" when (not available sod_det) @ sod_type
                     ship_line.abs_vol
                     ship_line.abs_vol_um
/*K005*              ship_line.abs__qad04 */
/*K005*/             cnsm_req
                     pt_desc1 when (available pt_mstr)
                     "" when (not available pt_mstr) @ pt_desc1
                     sod_contr_id when (available sod_det)
                     "" when (not available sod_det) @ sod_contr_id
/*K003*/             cmmts
/*L0PR*/             cancel_bo
/*K003*/             ship_line.abs_fa_lot
                  with frame sample.

/*L12G*/       l_prev_pick_qty = l_abs_pick_qty.

/*J22Y*/       /* HANDLE THE UPPER FRAME INTERFACE ONLY IN NON-BATCH MODE */
/*J22Y*/       if not batchrun then do:

                  /* ENABLE UPPER FRAME FOR INPUT */
                  set first_column
                  with frame k editing:

                     readkey.

                     if lastkey = keycode("F9")
                     or keyfunction(lastkey) = "CURSOR-UP"
                     or lastkey = keycode("F10")
                     or keyfunction(lastkey) = "CURSOR-DOWN"
                     or lastkey = keycode("F5")
                     or lastkey = keycode("CTRL-D")
                     or lastkey = keycode("F1")
                     or lastkey = keycode("CTRL-X")
                     or lastkey = keycode("PF1")
                     or lastkey = keycode("F3")
/*G2M9*/             or lastkey = keycode("PF3")
                     or lastkey = keycode("CTRL-T")
                     or keyfunction(lastkey) = "GO"
                     or keyfunction(lastkey) = "END-ERROR"
                     or lastkey = keycode("F4")
                     or lastkey = keycode("RETURN")
                     or lastkey = keycode("CTRL-E") then leave.

                  end. /* EDITING */

                  /* HANDLE THE END-ERROR KEY */
                  if lastkey = keycode("F4")
                  or keyfunction(lastkey) = "END-ERROR" then leave EDITLOOP.

                  if (lastkey = keycode("F9")
                  or keyfunction(lastkey) = "CURSOR-UP"
                  or lastkey = keycode("F10")
                  or keyfunction(lastkey) = "CURSOR-DOWN") then do:

/*K0J7*/            run navigate_proc.
/*K0J7* moved the following code to internal procedure navigate_proc ***************
**                     /* HANDLE CURSOR MOVEMENT UP */
**                     if (lastkey = keycode("F9")
**                     or keyfunction(lastkey) = "CURSOR-UP") then do:
**
**                         /* MOVE UP ONE LINE IN SCROLLING WINDOW */
**                         find prev ship_line
**                         where ship_line.abs_shipfrom = ship_from
**                         and ship_line.abs_shipto begins tmp_prefix
**                         exclusive-lock no-error.
**
**                         if available ship_line then do:
**
**                            up 1 with frame k.
**
**                            /* SET UP DISP_LINE */
**                            {rcshwbb1.i}
**
**                            display
**                               fill(".",minimum(4,integer(ship_line.abs__qad06)))
**                               + ship_line.abs__qad06
**                               @ first_column
**                               disp_line
**                            with frame k.
**                         end.
**
**                         else do:
**
**                            /* NO RECORD FOUND */
**                            find first ship_line
**                            where ship_line.abs_shipfrom = ship_from
**                            and ship_line.abs_shipto begins tmp_prefix
**                            exclusive-lock no-error.
**
**                            bell.
**
**                         end.
**                      end. /* IF LASTKEY = F9 */
**
**                      /* HANDLE CURSOR MOVEMENT DOWN */
**                      if (lastkey = keycode("F10")
**                      or keyfunction(lastkey) = "CURSOR-DOWN") then do:
**
**                         /* MOVE DOWN ONE LINE IN SCROLLING WINDOW */
**                         find next ship_line
**                         where ship_line.abs_shipfrom = ship_from
**                         and ship_line.abs_shipto begins tmp_prefix
**                         exclusive-lock no-error.
**
**                         if available ship_line then do:
**
**                            down 1 with frame k.
**
**                            /* SET UP DISP_LINE */
**                            {rcshwbb1.i}
**
**                            display
**                               fill(".",minimum(4,integer(ship_line.abs__qad06)))
**                               + ship_line.abs__qad06
**                               @ first_column
**                               disp_line
**                            with frame k.
**                         end.
**
**                         else do:
**
**                            /* NO RECORD FOUND */
**                            find last ship_line
**                            where ship_line.abs_shipfrom = ship_from
** /*J18G**                   and ship_line.abs_shipto begins tmp_prefix      */
** /*J18G*/                   and ship_line.abs_shipto >= tmp_prefix
** /*J18G*/                   and ship_line.abs_shipto <= tmp_prefix
** /*J18G*/                                             + fill(hi_char,8)
**                            exclusive-lock no-error.
**
**                            bell.
**
**                         end.
**                      end. /* IF LASTKEY = F10 */
**K0J7* end of moved code ***************************************************************/
                  end. /* IF CURSOR KEYS */

/*K003*/                 cmmts = ship_line.abs_cmtindx > 0.

                  /* HANDLE GO KEY */
                  if (lastkey = keycode("F1")
                  or lastkey = keycode("PF1")
                  or lastkey = keycode("CTRL-X")
                  or lastkey = keycode("RETURN")
                  or keyfunction(lastkey) = "GO") then

                  SET_DATA:
                  do on endkey undo SET_DATA, leave SET_DATA
                  on error undo SET_DATA, retry SET_DATA:

/*K1F0*/            if ship_line.abs_id begins "i" then do:
/*K1F0** /*K0JC*/   if not ship_line.abs_id begins "i" then leave SET_DATA. */

/*J2LW*/             /* GET THE OPEN QTY FOR THE SALES ORDER LINE */
/*J2LW*/             for first so_mstr
/*J2M7** /*J2LW*/                 fields(so_nbr so_sched) */
/*J2M7*/                 fields(so_nbr so_sched so_primary so_secondary)
/*J2LW*/                 where so_nbr = ship_line.abs_order no-lock:
/*J2LW*/             end. /* FOR FIRST SO_MSTR */

/*J2M7** /*J2LW*/    if not so_sched then do: */
/*J2M7*/             if available so_mstr and not so_sched then do:
/*J2LW*/                {openqty.i}
/*J2LW*/             end. /* IF NOT SO_SCHED */

/*K1WG*/             /* GET THE TRANSACTION TYPE OF THE SHIPPER */
/*K1WG*/             {gprun.i ""icshtyp.p""
                              "(input recid(ship_line) ,
                                output l_tr_type)"}

/*K165*/             find first abs_child_buff use-index abs_par_id
/*K165*/              where abs_child_buff.abs_shipfrom = ship_line.abs_shipfrom
/*K165*/                 and abs_child_buff.abs_par_id = ship_line.abs_id
/*K165*/                 and abs_child_buff.abs_id begins "i"
/*K165*/               no-lock no-error.
/*N0WX*/             {&RCSHWBB-P-TAG1}

/*M1B7*/             status input stline[1].

/*K0JC*/             set
/*K165* /*K0JC*/        part_order when (ship_line.abs_id begins "i") */
/*K165*/                part_order when (ship_line.abs_id begins "i" and
/*K1WG*/                                 l_tr_type = "ISS-SO"        and
/*K165*/                                 not available abs_child_buff and
/*K165*/                                 not ship_line.abs_par_id begins "i")
/*K165* /*K0JC*/        part_order_line when (ship_line.abs_id begins "i") */
/*K165*/                part_order_line when (ship_line.abs_id begins "i" and
/*K1WG*/                                 l_tr_type = "ISS-SO"        and
/*K165*/                                 not available abs_child_buff and
/*K165*/                                 not ship_line.abs_par_id begins "i")
/*K0JC*/             with frame sample
/*N0WX*/             {&RCSHWBB-P-TAG2}
/*K0JC*/             editing:
/*K0JC*/               readkey.
/*K0JC*/               apply lastkey.
/*K0JC*/               if keyfunction(lastkey) = "GO" then leave.
/*K0JC*/               {mfnp10.i sod_det
                          part_order
                          sod_nbr
                          part_order_line
                          string(sod_line)
                          "and ship_line.abs_item = sod_part"}
/*K0JC*/               if recno <> ? then do:
/*K0JC*/                 display
/*K0JC*/                   sod_nbr @ part_order
/*L0RV** /*K0JC*/          sod_line @ part_order_line */
/*L0RV*/                   string(sod_line) @ part_order_line
/*K0JC*/                 with frame sample.
/*K0JC*/               end.
/*K0JC*/             end.

/*K0JC*/             find abs_parent_buff where
/*K0JC*/               recid(abs_parent_buff) = parent_abs_recid
/*K0JC*/             no-lock no-error.
/*N0WX*/             {&RCSHWBB-P-TAG3}
/*K165*/             if not ship_line.abs_par_id begins "i"
/*K1WG*/                and l_tr_type = "ISS-SO"
/*K165*/                and not available abs_child_buff then do:
/*N0WX*/             {&RCSHWBB-P-TAG4}
/*K0JC*/             if part_order <> "" then do:
/*K0JC*/             {gprun.i ""rcshsov.p""
                        "(input recid(ship_line),
                          input parent_abs_recid,
                          input abs_parent_buff.abs_format,
                          input part_order,
                          input part_order_line,
                          input shipto_code,
                          output so_ok)"
                     }
/*K0JC*/             end. /* part_order <> "" */
/*K0JC*/             else do:
/*K0JC*/               so_ok = no.
/*K0JC*/               {mfmsg.i 40 3}
/*K0JC*/             end. /* part_order = "" */

/*K0JC*/             if not so_ok then do:
/*K0JC*/               undo set_data, retry set_data.
/*K0JC*/             end.
/*K165*/             end. /* if not ship_line.abs_par_id begins "i" */
/*K165*/             else do:
/*K165*/               assign
/*K165*/                 part_order = ship_line.abs_order
/*K165*/                 part_order_line = ship_line.abs_line.
/*K165*/             end. /* ship_line.abs_par_id begins "i" */
/*N0WX*/             {&RCSHWBB-P-TAG5}
/*K1WG*/             if l_tr_type = "ISS-SO" then
/*N0WX*/             {&RCSHWBB-P-TAG6}
/*K0JC*/               find first sod_det where sod_det.sod_nbr = part_order
/*K0JC*/               and sod_det.sod_line = integer(part_order_line) no-lock.

/*J37V*/             l_order_change = no.
/*K0JC*/             if part_order <> ship_line.abs_order
/*K0JC*/             then do:

/*K18W*/   /* PASSED PARAMETER abs__dec01 INSTEAD OF abs_qty TO soitallb.p */
/*K0JC*/               if ship_line.abs_order <> "" then do:

/*K15N*/                  /* SET GLOBAL_DB USING ABS_SITE */
/*K15N*/                  new_site = ship_line.abs_site.
/*K15N*/                  {gprun.i ""gpalias.p""}

/*K15N*/                  /* SWITCH TO THE INVENTORY SITE */
/*K15N*/                  if so_db <> global_db then do:
/*K15N*/                      {gprun.i ""gpalias2.p""
                                       "(ship_line.abs_site, output errornum)"}
/*K15N*/                      if errornum <> 0 and errornum <> 9 then do:
/*K15N*/                         /* DATABASE # IS NOT CONNECTED */
/*M110** /*K15N*/                {mfmsg03.i 2510 4              */
/*M110**                         {&rcshwbb_p_4} """" """"}      */
/*M110*/                         /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                         run p-pxmsg (input 2510,
                                              input 4,
                                              input l_msgar1[2]).
/*K15N*/                         undo SET_DATA, retry SET_DATA .
/*K15N*/                      end.
/*K15N*/                  end.

/*J2TP*/               /* ADDED INPUT PARAMETER -SHIP_LINE.ABS_QTY */
/*J37V*/               /* CHANGED THE NINTH PARAMETER FROM         */
/*J37V*/               /* SHIP_LINE.ABS_DEC01 TO L_ABS_PICK_QTY    */
/*L0M0*/               /* ADDED ELEVENTH INPUT PARAMETER L_DELPROC */
/*K0JC*/               {gprun.i ""soitallb.p""
                          "(input ship_line.abs_order,
                            input ship_line.abs_line,
                            input ship_line.abs_item,
                            input ship_line.abs_site,
                            input ship_line.abs_loc,
                            input ship_line.abs_lot,
                            input ship_line.abs_ref,
                            input - ship_line.abs_qty *
                                    decimal(ship_line.abs__qad03),
                            input - l_abs_pick_qty *
                                    decimal(ship_line.abs__qad03),
                            input  del_lad,
                            input  l_delproc,
                            output avail_qty,
                            output tmp_qty)"}

/*K15N*/                  /* SWITCH BACK TO THE SALES ORDER DATABASE */
/*K15N*/                  if so_db <> global_db then do:

/*J394*/                     /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
/*J394*/                     /* IN REMOTE DATABASE                         */
/*L0M0*/                     /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
/*J394*/                     {gprun.i ""sosopka2.p""
                                      "(input ship_line.abs_order,
                                        input integer (ship_line.abs_line),
                                        input (- l_abs_pick_qty *
                                              decimal(ship_line.abs__qad03)),
                                        input l_delproc)"}

/*K15N*/                     {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}
/*K15N*/                     if errornum <> 0 and errornum <> 9 then do:
/*K15N*/                        /* DATABASE # IS NOT CONNECTED */
/*M110** /*K15N*/               {mfmsg03.i 2510 4                    */
/*M110**                                   {&rcshwbb_p_3} """" """"} */
/*M110*/                        /* REPLACED MFMSG03 CALL BY PXMSG    */
/*M110*/                        run p-pxmsg (input 2510,
                                             input 4,
                                             input l_msgar1[1]).
/*K15N*/                        undo SET_DATA, retry SET_DATA .
/*K15N*/                     end.
/*K15N*/                  end.

/*K18W*/   /* PASSED PARAMETER abs__dec01 INSTEAD OF abs_qty TO sosopka2.p */
/*J37V*/   /* CHANGED THE THIRD PARAMETER FROM ABS_DEC01 TO L_ABS_PICK_QTY */
/*L0M0*/   /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
/*K0JC*/               {gprun.i ""sosopka2.p""
                         "(input ship_line.abs_order,
                          input integer (ship_line.abs_line),
                          input (- l_abs_pick_qty *
                                    decimal(ship_line.abs__qad03)),
                          input l_delproc )"}
/*K0JC*/               end. /* ship_line.abs_order <> "" */

/*K0JC*/               assign
/*J37V*/                 l_order_change      = yes
/*K0JC*/                 ship_line.abs_order = part_order
/*K0JC*/                 ship_line.abs_line = part_order_line.

/*K0JC*/               if (ship_line.abs_par_id begins  "i") then
/*K0JC*/                 assign ship_line.abs_id =
/*K0JC*/                   ship_line.abs_par_id +
/*K0JC*/                   ship_line.abs_site +
/*K0JC*/                   ship_line.abs_order +
/*K0JC*/                   ship_line.abs_line +
/*K0JC*/                   ship_line.abs_item +
/*K0JC*/                   ship_line.abs_loc +
/*K0JC*/                   ship_line.abs_lot +
/*K0JC*/                   ship_line.abs_ref +
/*K0JC*/                   ship_line.abs_fa_lot.
/*K0JC*/               else
/*K0JC*/                 assign ship_line.abs_id =
/*K0JC*/                   "i" + ship_line.abs_par_id +
/*K0JC*/                   ship_line.abs_site +
/*K0JC*/                   ship_line.abs_order +
/*K0JC*/                   ship_line.abs_line +
/*K0JC*/                   ship_line.abs_item +
/*K0JC*/                   ship_line.abs_loc +
/*K0JC*/                   ship_line.abs_lot +
/*K0JC*/                   ship_line.abs_ref +
/*K0JC*/                   ship_line.abs_fa_lot.

/*K0JC*/             end. /* if part_order <> ship_line.abs_order ... */

/*J12M*/             {gprun.i ""gpsiver.p""
                       "(input ship_line.abs_site,
                               input ?, output return_int)"}
/*J12M*/             if return_int = 0 then do:
/*J12M*/                /* USER DOES NOT HAVE ACCESS TO THIS SITE */
/*J12M*/                {mfmsg.i 725 3}
/*J12M*/                undo, retry.
/*J12M*/             end.

/*K04X*/             /* Show available quantity if able to edit quantities */
/*K04X*/             if v_editall then do:

/*K003*   ADDED FOLLOWING */
                     /* SET GLOBAL_DB USING ABS_SITE */
/*K003*/                new_site = ship_line.abs_site.
/*K003*/                {gprun.i ""gpalias.p""}

                        /* SWITCH TO THE INVENTORY SITE */
/*K003*/                if so_db <> global_db then do:
/*K003*/                    {gprun.i ""gpalias2.p""
/*K003*/                             "(ship_line.abs_site, output errornum)"}
/*K003*/                    if errornum <> 0 and errornum <> 9 then do:
                               /* DATABASE # IS NOT CONNECTED */
/*M110** /*K003*/              {mfmsg03.i 2510 4              */
/*M110**                         {&rcshwbb_p_4} """" """"}    */
/*M110*/                       /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                       run p-pxmsg (input 2510,
                                            input 4,
                                            input l_msgar1[2]).
/*K003*/                    end.
/*K003*/                end.

                        /* GET QTY AVAILABLE TO ALLOCATE  AND DISPLAY IT */
/*K18W*/   /* PASSED PARAMETER tmp_qty INSTEAD OF pick_qty TO soitallb.p */
/*J2TP*/   /* ADDED INPUT PARAMETER "0" FOR -SHIP_LINE.ABS_QTY           */
/*L0M0*/   /* ADDED ELEVENTH INPUT PARAMETER L_DELPROC                   */
/*K003*/                {gprun.i ""soitallb.p""
                                "(input ship_line.abs_order,
                                 input ship_line.abs_line,
                                 input ship_line.abs_item,
                                 input ship_line.abs_site,
                                 input ship_line.abs_loc,
                                 input ship_line.abs_lot,
                                 input ship_line.abs_ref,
                                 input "0" ,
                                 input "0" ,
                                 input del_lad,
                                 input l_delproc,
                                 output avail_qty,
                                 output tmp_qty)"}

                        /* SWITCH BACK TO THE SALES ORDER DATABASE */
/*K003*/                if so_db <> global_db then do:
/*K003*/                   {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}
/*K003*/                   if errornum <> 0 and errornum <> 9 then do:
                              /* DATABASE # IS NOT CONNECTED */
/*M110** /*K003*/             {mfmsg03.i 2510 4 {&rcshwbb_p_3} """" """"} */
/*M110*/                      /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                      run p-pxmsg (input 2510,
                                           input 4,
                                           input l_msgar1[1]).
/*K003*/                   end.
/*K003*/                end.

/*J1LY*/                if available sod_det and sod_type = "" then do:
/*K003*/                  {mfmsg02.i 208 1 "avail_qty"}

/*K18W** /*K003*/         display pick_qty with frame sample.  */
/*K1NF** /*K18W*/         display ship_line.abs__dec01 with frame sample. */
/*K1NF*/                  display l_abs_pick_qty with frame sample.
/*J1LY*/                end.

/*K04X*/             end.  /* if v_editall */

/*J2RL*/             {absupack.i  "ship_line" 3 22 "l_abs_pick_qty" }
/*J2RL*/             display l_abs_pick_qty with frame sample.

                     /* SAVE NET WEIGHT FOR LATER COMPARISON */
                     assign
                     nwt_old = ship_line.abs_nwt
/*J2M7*/             l_twt_old = l_abs_tare_wt
/*J1HV*/             vol_old = ship_line.abs_vol
/*J1HV*/             qty_old = ship_line.abs_qty
/*K18W** /*K003*/    old_qty = pick_qty    */
/*K1NF** /*K18W*/    old_qty = ship_line.abs__dec01 */
/*K1NF*/             old_qty = l_abs_pick_qty
/*K003*/             old_site = ship_line.abs_site
/*K003*/             old_loc = ship_line.abs_loc
/*K003*/             old_lot = ship_line.abs_lot
/*K003*/             old_ref = ship_line.abs_ref
/*K003*/             kit_comp =  (ship_line.abs_par_id begins  "i").

/*K0DH* /*K0CZ*/     if not so_primary then do :       */
/*K0JC* /*K0DH*/             if so_secondary then do : */
/*K0JC*/             if available so_mstr and so_secondary then do:
/*K0CZ*/               find trq_mstr no-lock where trq_doc_type = "SO"
/*K0CZ*/                              and trq_doc_Ref  = so_nbr
/*K0CZ*/                              and trq_add_ref  = ""
/*K0CZ*/                              and (trq_msg_type = "ORDRSP-I" or
/*K0CZ*/                                   trq_msg_type = "ORDRSP-C") no-error.
/*K0CZ*/               if available trq_mstr then do:
/*K0CZ*/                 {mfmsg.i 2834 3}
/*K0CZ*/                 undo SET_DATA, leave SET_DATA.
/*K0CZ*/               end.
/*K0CZ*/             end.

/*K022*     SET CMF MESSAGES ONLY IN SBU AND NOT ALREADY  SHIPPED        */
/*K06K* /*K022*/     if not so_primary and not sod_sched                 */
/*K0CZ* /*K06K*/     if (available so_mstr and not so_primary)           */
/*K0CZ* /*K06K*/     and (available sod_det and not sod_sched            */
/*K0CZ* /*K022*/     and sod_qty_ship = 0) and not can-find              */
/*K0CZ* /*K022*/     (first lad_det where lad_nbr = sod_nbr              */
/*K0CZ* /*K022*/     and lad_line = string (sod_line)) then              */
/*K0DH*  /*K0CZ*/    if (available so_mstr and not so_primary)           */
/*K0DH*/             if (available so_mstr and so_secondary)
/*K0CZ*/             and (available sod_det and not sod_sched
/*K0CZ*/             and sod_qty_ship = 0) then
/*K022*/               cmf_flg = yes.
/*K022*/             else cmf_flg = no.

                     /* MAINTAIN LOWER FRAME DATA */
/*J1HV**               USING SET INSTEAD OF UPDATE CAUSED FRAME DISPLAY
.                      VALUES TO BE RESET ON F4; RESTORING SET
. /*K02T*                     set */
. /*K02T*/             update */

/*K04X*  /*J1HV*/       set
 *K04X*                  ship_line.abs_qty
 *K04X*  /*K003*/       pick_qty  when (available sod_det and sod_type = ""
 *K04X*  /*K003*/                       and ship_line.abs_qty > 0
 *K04X*  /*K003*/                       and not ship_line.abs_canceled)
 *K04X*                 ship_line.abs_nwt
 *K04X*                 ship_line.abs_vol
 *K04X*                 ship_line.abs_site
 *K04X*                 ship_line.abs_loc
 *K04X*                 ship_line.abs_lot
 *K04X*                 ship_line.abs_ref
 *K04X*  /*K005*        ship_line.abs__qad04 */
 *K04X*  /*K005*/       cnsm_req when (ship_line.abs_id begins "i")
 *K04X*  /*K003*/       ship_line.abs_fa_lot when (available sod_det and
 *K04X*  /*K003*/                                  fac_so_rec = yes and
 *K04X*  /*K003*/                                  (sod_cfg_type = "1" or
 *K04X*  /*K003*/                                   sod_fa_nbr <> "" ))
 *K04X*  /*K003*/       cmmts
 *K04X*               with frame sample.
 *K04X*/

/*K1F0*/             end. /* IF SHIP_LINE.ABS_ID BEGINS "i" */
/*J2M7** /*J2BZ*/        else nwt_old = ship_line.abs_nwt. */
/*J2M7*/             else
/*J2M7*/               assign
/*J2M7*/                  nwt_old = ship_line.abs_nwt
/*J2M7*/                  vol_old = ship_line.abs_vol
/*J2M7*/                  qty_old = ship_line.abs_qty.

/*J2M7*/             {absupack.i  "ship_line" 26 22 "l_abs_tare_wt" }
/*J2M7*/             assign l_twt_old = l_abs_tare_wt.

/*K15N*/ /* CHECK LOCAL VARIABLE fas_so_rec POSSIBLY FROM REMOTE DB */
/*K04X*/             set
/*K1F0** /*K04X*/       ship_line.abs_qty when (v_editall) */
/*K1F0*/                ship_line.abs_qty when
/*J2M7** /*K1F0*/            (v_editall and ship_line.abs_id begins "i") */
/*J389** /*J2M7*/            (v_editall and (ship_line.abs_id begins "i" */
/*J389** /*J2M7*/                       or ship_line.abs_id begins "c")) */
/*J389*/                     (v_editall and ship_line.abs_id begins "i")
/*K18W** /*K04X*/                pick_qty when    */
/*K1NF** /*K18W*/       ship_line.abs__dec01 when */
/*K1NF*/                l_abs_pick_qty when
/*K04X*/                   (v_editall              and
/*K04X*/                    available sod_det      and
/*K04X*/                    sod_type eq ""         and
/*K04X*/                    ship_line.abs_qty gt 0 and
/*K1F0*/                    ship_line.abs_id begins "i" and
/*K04X*/                    not ship_line.abs_canceled)
/*J2M7** /*K04X*/                ship_line.abs_nwt */
/*J2M7*/                ship_line.abs_nwt when
/*J2M7*/                                (substring(ship_line.abs_id,1,1) = "i")
/*J2M7*/                l_abs_tare_wt when
/*J2M7*/                                (substring(ship_line.abs_id,1,1) = "s")
/*J2M7*/                             or (substring(ship_line.abs_id,1,1) = "c")
/*J2M7*/                             or (substring(ship_line.abs_id,1,1) = "p")
/*K04X*/                ship_line.abs_vol
/*K1F0** /*K04X*/       ship_line.abs_site when (v_editall) */
/*K1F0*/                ship_line.abs_site when
/*K1F0*/                   (v_editall and ship_line.abs_id begins "i")
/*K1F0** /*K04X*/       ship_line.abs_loc  when (v_editall) */
/*K1F0*/                ship_line.abs_loc  when
/*K1F0*/                   (v_editall and ship_line.abs_id begins "i")
/*K1F0** /*K04X*/       ship_line.abs_lot  when (v_editall) */
/*K1F0*/                ship_line.abs_lot  when
/*K1F0*/                   (v_editall and ship_line.abs_id begins "i")
/*K1F0** /*K04X*/       ship_line.abs_ref  when (v_editall) */
/*K1F0*/                ship_line.abs_ref  when
/*K1F0*/                   (v_editall and ship_line.abs_id begins "i")
/*K04X*/                cnsm_req when
/*K04X*/                   (v_editall and ship_line.abs_id begins "i")
/*K04X*/                ship_line.abs_fa_lot when
/*K04X*/                   (v_editall                   and
/*K1F0*/                    ship_line.abs_id begins "i" and
/*K04X*/                    available sod_det           and
/*K15N* /*K04X*/            fac_so_rec eq yes and */
/*K15N*/                    fas_so_rec eq string(true)  and
/*K21N*/                    fac_wo_rec = no             and
/*K04X*/                    (sod_cfg_type eq "1" or
/*K04X*/                     sod_fa_nbr ne "" ))
/*K04X*/                cmmts
/*L0PR*/                cancel_bo when
/*L0PR*/                   (v_editall and ship_line.abs_id begins "i")
/*J35D** /*K04X*/    with frame sample.   */
/*J35D*/             with frame sample
/*J35D*/             editing:

/*M1B7*/                status input stline[1].

/*J35D*/                assign
/*J35D*/                   global_site = input ship_line.abs_site
/*J35D*/                   global_loc  = input ship_line.abs_loc
/*L12R*/                   global_part =       ship_line.abs_item
/*J35D*/                   global_lot  = input ship_line.abs_lot.
/*J35D*/                readkey.
/*K21H*/                if last-key = keycode("F4")           or
/*K21H*/                   keyfunction(lastkey) = "END-ERROR" or
/*K21H*/                   keyfunction(lastkey) = "ENDKEY" then
/*K21H*/                   /* REFRESHING LOWER SCREEN   */
/*K21H*/                   run ip-refresh.
/*J35D*/                apply lastkey.
/*J35D*/             end. /* EDITING */

/*J399*/             if truncate(qty_old, 4) = ship_line.abs_qty then
/*J399*/                assign
/*J399*/                  ship_line.abs_qty = qty_old.
/*J399*/             if truncate(old_qty, 4) = l_abs_pick_qty then
/*J399*/                assign
/*J399*/                  l_abs_pick_qty = old_qty.

/*J2M7*/             {abspack.i "ship_line" 26 22 "l_abs_tare_wt" }

/*J2LW*/             l_part_qty = (ship_line.abs_qty - qty_old) *
/*J2LW*/                           decimal(ship_line.abs__qad03).

/*J2M7** /*J2LW*/    if not so_sched then */
/*J2M7*/             if available so_mstr and not so_sched then
/*J2LW*/                if ((sod_qty_ord >= 0  and
/*J2LW*/                   ((l_part_qty ) / sod_um_conv) > open_qty )  or
/*J2LW*/                    (sod_qty_ord < 0  and
/*J2LW*/                   ((l_part_qty ) / sod_um_conv) < open_qty ))
/*J2LW*/                then do:
/*J2LW*/                    /* QTY ORDERED CANNOT BE LESS THAN ALLOCATED */
/*J2LW*/                    /* + PICKED + SHIPPED                        */
/*J2LW*/                    {mfmsg.i  4999 2}
/*J2LW*/                end. /* IF PART_QTY > OPEN_QTY */

/*K1NF*/             {abspack.i "ship_line" 3 22 "l_abs_pick_qty" }

/*L14M*/             l_lad_qty_all = 0.

/*K1NF** /*J2CQ*/    if ship_line.abs__dec01 > ship_line.abs_qty then do: */
/*L12G*/             for first lad_det
/*L12G*/                fields(lad_dataset lad_line lad_loc lad_lot lad_nbr
/*L12G*/                       lad_part lad_qty_all lad_qty_pick
/*L12G*/                       lad_ref lad_site)
/*L12G*/                where  lad_dataset = "sod_det"            and
/*L12G*/                       lad_nbr     = ship_line.abs_order  and
/*L12G*/                       lad_line    = ship_line.abs_line   and
/*L12G*/                       lad_part    = ship_line.abs_item   and
/*L12G*/                       lad_site    = ship_line.abs_site   and
/*L12G*/                       lad_loc     = ship_line.abs_loc    and
/*L12G*/                       lad_lot     = ship_line.abs_lot    and
/*L12G*/                       lad_ref     = ship_line.abs_ref no-lock:
/*L12G*/             end. /* FOR FIRST LAD_DET */

/*L12G*/             if available lad_det then
/*L12G*/                l_lad_qty_all = lad_qty_all.

/*L12G*/             for first lad_det
/*L12G*/                fields(lad_dataset lad_line lad_loc lad_lot lad_nbr
/*L12G*/                       lad_part lad_qty_all lad_qty_pick
/*L12G*/                       lad_ref lad_site)
/*L12G*/                where  lad_dataset = "sob_det"            and
/*L12G*/                       lad_nbr     = ship_line.abs_order  and
/*L12G*/                       lad_line    = ship_line.abs_line   and
/*L12G*/                       lad_part    = ship_line.abs_item   and
/*L12G*/                       lad_site    = ship_line.abs_site   and
/*L12G*/                       lad_loc     = ship_line.abs_loc    and
/*L12G*/                       lad_lot     = ship_line.abs_lot    and
/*L12G*/                       lad_ref     = ship_line.abs_ref no-lock:
/*L12G*/             end. /* FOR FIRST LAD_DET */

/*L12G*/             if available lad_det then
/*L12G*/                l_lad_qty_all = lad_qty_all.

/*L14M*/             /* UPDATE avail_qty AND l_prev_pick_qty IF THERE  */
/*L14M*/             /* IS A CHANGE IN SITE, LOCATION, LOT/SERIAL OR   */
/*L14M*/             /* REFERENCE.                                     */
/*L14M*/             if old_site <> ship_line.abs_site or
/*L14M*/                old_loc  <> ship_line.abs_loc  or
/*L14M*/                old_lot  <> ship_line.abs_lot  or
/*L14M*/                old_ref  <> ship_line.abs_ref
/*L14M*/             then do:
/*L14M*/                assign avail_qty = 0
/*L14M*/                       l_prev_pick_qty = 0.
/*L14M*/                for first ld_det
/*L14M*/                   fields (ld_site ld_loc ld_part ld_lot ld_ref
/*L14M*/                           ld_status ld_qty_oh ld_qty_all)
/*L14M*/                   where ld_site = ship_line.abs_site and
/*L14M*/                         ld_loc  = ship_line.abs_loc  and
/*L14M*/                         ld_part = ship_line.abs_item and
/*L14M*/                         ld_lot  = ship_line.abs_lot  and
/*L14M*/                         ld_ref  = ship_line.abs_ref
/*L14M*/                   no-lock:
/*L14M*/                end. /* FOR FIRST ld_det */
/*L14M*/                if available ld_det
/*L14M*/                then do:
/*L14M*/                   if can-find (is_mstr where is_status = ld_status
/*L14M*/                                and is_avail = yes)
/*L14M*/                   then
/*L14M*/                      avail_qty = ld_qty_oh - ld_qty_all.
/*L14M*/                end. /* IF AVAILABLE ld_det */
/*L14M*/             end. /* IF old_site <> ship_line.abs_site ... */

/*M110*/             if avail_qty < 0
/*M110*/             then
/*M110*/                run p-alloclad.

/*M110** /*K238*/    if ship_line.abs_qty >= 0 then                    */
/*M110*/             if  ship_line.abs_qty >= 0
/*M110*/             and l_abs_pick_qty    >  0
/*M110*/             then

/*N0TY** BEGIN DELETE **
 * /*L0M0** /*K1NF*/       if l_abs_pick_qty > ship_line.abs_qty then do: */
 * /*L0M0*/                if l_abs_pick_qty > ship_line.abs_qty or
 * /*L12G** /*L0M0*/          l_abs_pick_qty > avail_qty then             */
 * /*L12G*/                   l_abs_pick_qty > avail_qty + l_prev_pick_qty
 * /*L12G*/                                    + l_lad_qty_all then
 *N0TY** END DELETE **/

/*N0TY*/                /* THE LOGIC INTRODUCED BY L12G TO DISPLAY THE ERROR */
/*N0TY*/                /* IS MISLEADING, SO MODIFIED THE CONDITION AND      */
/*N0TY*/                /* ASSIGNING l_abs_pick_qty BACK BY CONSIDERING THE  */
/*N0TY*/                /* AVAIL QTY, PREV QTY AND ALLOCATED QTY IF ANY      */

/*N0TY*/                if l_abs_pick_qty > ship_line.abs_qty then
/*L0M0*/                do:
/*J2CQ*/                   /* PICK QUANTITY EXCEEDS SHIP QUANTITY */
/*J2CQ*/                   {mfmsg.i 2525 3}
/*J2CQ*/                   undo SET_DATA, retry SET_DATA.
/*J2CQ*/                end. /* IF L_ABS_PICK_QTY > SHIP_LINE.ABS_QTY */

/*N0TY*/                l_avail_qty  = max(l_lad_qty_all - v_unpicked_qty,
/*N0TY*/                                   avail_qty).

/*K26P** /*N0TY*/       if l_abs_pick_qty > l_avail_qty + l_prev_pick_qty  */
/*K26P** /*N0TY*/                                    + l_lad_qty_all       */

/*K26P*/                if  l_abs_pick_qty      * decimal(ship_line.abs__qad03)
/*K26P*/                    > (l_avail_qty + l_lad_qty_all
/*K26P*/                      + l_prev_pick_qty * decimal(ship_line.abs__qad03))
/*M1FF*/                and ship_line.abs_qty > 0
/*N1CN*/                and l_abs_pick_qty      * decimal(ship_line.abs__qad03)
/*N1CN*/                    > 0
/*N0TY*/                then do:
/*N0TY*/                   {mfmsg02.i 208 3 "l_avail_qty"}
/*N0TY*/                   undo SET_DATA, retry SET_DATA.
/*N0TY*/                end. /* IF l_abs_pick_qty > (avail_qty ...) */

/*K18W*/                find ld_det where
/*K18W*/                ld_site = ship_line.abs_site and
/*K18W*/                ld_loc = ship_line.abs_loc and
/*K18W*/                ld_part = ship_line.abs_item and
/*K18W*/                ld_lot = ship_line.abs_lot and
/*K18W*/                ld_ref = ship_line.abs_ref no-lock no-error.

/*K18W*/ /* THIS MESSAGE IS ADDED SO THAT IF THE USERS ENTERS A QUANTITY    */
/*K18W*/ /* GREATER THAN QTY AVAILABLE FOR A VALID LOCATION LOT/SERIAL THEN */
/*K18W*/ /* THE SYSTEM WILL GIVE AN ERROR NOT ALLOWING THE USER TO PROCEED. */

/*K18W*/         if available ld_det and
/*K1NF** /*K18W*/ ship_line.abs__dec01 > max(ld_qty_oh - ld_qty_all,0) + old_qty */
/*J2MH** /*K1NF*/   l_abs_pick_qty > max(ld_qty_oh - ld_qty_all,0) + old_qty */
/*J2MH*/            l_abs_pick_qty * decimal(ship_line.abs__qad03) >
/*J2TP*/            (qty_old - old_qty) * decimal(ship_line.abs__qad03) +
/*J2MH*/            max(ld_qty_oh - ld_qty_all,0) +
/*J2MH*/            old_qty * decimal(ship_line.abs__qad03)
/*M1FF*/            and ship_line.abs_qty > 0
/*K18W*/         then do:
/*J2MH*/            /* CONVERTED OLD_QTY TO INVENTORY UM */
/*K18W*/            /* QUANTITY AVAILABLE IN SITE LOCATION FOR LOT/SERIAL */
/*J2TP** /*K18W*/    {mfmsg02.i 208 3 "max(ld_qty_oh - ld_qty_all,0) +    */
/*J2TP**                       old_qty * decimal(ship_line.abs__qad03)"}  */

/*M1FF** BEGIN DELETE**
 * /*J2TP*/         {mfmsg02.i 208 3
 *                  "max(ld_qty_oh - ld_qty_all,0) +
 *                  (qty_old - old_qty) * decimal(ship_line.abs__qad03) +
 *                  old_qty * decimal(ship_line.abs__qad03)"}
 *M1FF** END DELETE** */

/*M1FF*/            {mfmsg02.i 208 3
                       "max(max(ld_qty_oh - ld_qty_all,0) +
                        (qty_old - old_qty) * decimal(ship_line.abs__qad03) +
                        old_qty * decimal(ship_line.abs__qad03),0)"}


/*K18W*/              undo SET_DATA, retry SET_DATA.
/*K18W*/         end.

/*K02T*              EVAL QTY CHANGE FOR REQ CONSUMPTION - BEGIN */
                     if ship_line.abs_qty entered
                        and can-find(first absr_det
                           where absr_shipfrom = ship_line.abs_shipfrom
                             and absr_id = ship_line.abs_id) then
                     do:
                        peg_qty = 0.

                        if ship_line.abs_qty = 0 then
                        do:
                           {mfmsg.i 1653 2}

                              /* REMOVE / DELETE RECORD, PLEASE CONFIRM */
                           del-yn = false.
                           {mfmsg01.i 11 1 del-yn}
                           if not del-yn then
                              undo SET_DATA, retry SET_DATA.

                           {gprun.i ""rcdlabsr.p"" "(input recid(ship_line))"}

/*N004*/                    run delete_sequences
/*N004*/                        (input recid(ship_line)).

                           leave SET_DATA.

                        end.

                        else
                        for each absr_det
                           where absr_shipfrom = ship_line.abs_shipfrom
                             and absr_id = ship_line.abs_id
                           exclusive-lock:

                           peg_qty = peg_qty + absr_qty.

/*K21H**                   if peg_qty > ship_line.abs_qty then   */
/*K21H*/                   if peg_qty > ship_line.abs_qty and
/*K21H*/                      not(cnsm_req) then
                           do:
/*K21H**                      {mfmsg.i 1652 3}                   */
/*K21H*/                      {mfmsg.i 1652 2}
/*K21H*/                      l_warning = yes.
/*K21H*/                      set
/*K21H*/                         ship_line.abs_qty when
/*K21H*/                           (v_editall and ship_line.abs_id begins "i")
/*K21H*/                         l_abs_pick_qty when
/*K21H*/                            (v_editall
/*K21H*/                             and available sod_det
/*K21H*/                             and sod_type eq ""
/*K21H*/                             and ship_line.abs_qty gt 0
/*K21H*/                             and ship_line.abs_id begins "i"
/*K21H*/                             and not ship_line.abs_canceled)
/*K21H*/                         ship_line.abs_nwt when
/*K21H*/                            (substring(ship_line.abs_id,1,1) = "i")
/*K21H*/                         l_abs_tare_wt when
/*K21H*/                            (substring(ship_line.abs_id,1,1) = "s")
/*K21H*/                         or (substring(ship_line.abs_id,1,1) = "c")
/*K21H*/                         or (substring(ship_line.abs_id,1,1) = "p")
/*K21H*/                         ship_line.abs_vol
/*K21H*/                         ship_line.abs_site when
/*K21H*/                           (v_editall and ship_line.abs_id begins "i")
/*K21H*/                         ship_line.abs_loc  when
/*K21H*/                           (v_editall and ship_line.abs_id begins "i")
/*K21H*/                         ship_line.abs_lot  when
/*K21H*/                           (v_editall and ship_line.abs_id begins "i")
/*K21H*/                         ship_line.abs_ref  when
/*K21H*/                           (v_editall and ship_line.abs_id begins "i")
/*K21H*/                         cnsm_req when
/*K21H*/                           (v_editall and ship_line.abs_id begins "i")
/*K21H*/                         ship_line.abs_fa_lot when
/*K21H*/                            (v_editall
/*K21H*/                             and ship_line.abs_id begins "i"
/*K21H*/                             and available sod_det
/*K21H*/                             and fas_so_rec eq string(true)
/*K21N*/                             and fac_wo_rec = no
/*K21H*/                             and (sod_cfg_type eq "1"
/*K21H*/                                  or sod_fa_nbr ne "" ))
/*K21H*/                         cmmts
/*L0PR*/                         cancel_bo when
/*L0PR*/                            (v_editall and ship_line.abs_id begins "i")
/*K21H*/                         with frame sample
/*K21H*/                         editing:
/*K21H*/                            if l_warning then
/*K21H*/                            do:
/*K21H*/                               /* PROMPTING FOR CONSUME REQ FIELD   */
/*K21H*/                               /* WHEN WARNING 1652 IS DISPLAYED    */
/*K21H*/                               /* TO FACILITATE THE USER TO CHANGE  */
/*K21H*/                               /* THE CONSUME REQ TO YES AND        */
/*K21H*/                               /* ACCORDINGLY ADJUST THE PEGGED QTY */
/*K21H*/                               next-prompt cnsm_req with frame sample.
/*K21H*/                               l_warning = no.
/*K21H*/                            end. /* IF L_WARNING */
/*K21H*/                            readkey.
/*K21H*/                            if lastkey = keycode("F4") or
/*K21H*/                               keyfunction(lastkey) = "END-ERROR" or
/*K21H*/                               keyfunction(lastkey) = "END-KEY" then
/*K21H*/                            do:
/*K21H*/                               /* REFRESHING LOWER SCREEN   */
/*K21H*/                               run ip-refresh.
                                       undo SET_DATA, retry SET_DATA.
/*K21H*/                            end. /* IF LASTKEY = KEYCODE("F4").. */
/*K21H*/                            else if (lastkey = keycode("F1") or
/*K21H*/                                     lastkey = keycode("CTRL-X") or
/*K21H*/                                     keyfunction(lastkey) = "GO") then
/*K21H*/                            do:
/*K21H*/                              if peg_qty > input ship_line.abs_qty and
/*K21H*/                                 not(input cnsm_req) then
/*K21H*/                              do:
/*K21H*/                                  {mfmsg.i 1652 2}
/*K21H*/                                  next-prompt cnsm_req
/*K21H*/                                  with frame sample.
/*K21H*/                                  pause.
/*K21H*/                              end. /* IF PEG_QTY > INPUT SHIP_LINE */
/*K21H*/                              else leave.
/*K21H*/                            end. /* IF LASTKEY = KEYCODE("F1").. */
/*K21H*/                            apply lastkey.
/*K21H*/                      end. /* SET...*/
                           end. /* IF PEG_QTY > SHIP_LINE.ABS_QTY .. */
                        end. /* for each absr_det */
                     end. /* if ship_line.abs_qty entered */
/*K02T*              EVAL QTY CHANGE FOR REQ CONSUMPTION - BEGIN */

                     /* IF ENTRY THEN VALIDATE THE LINE UNTIL PASS CONDITION */
/*J134*/  /*         if frame sample ship_line.abs_lot entered
 *                   or frame sample ship_line.abs_qty entered
 *                   or undotran then do:   *****/

/*J1LY* /*K04X*/     if v_editall then        */

/*J2S5*/             /* INITIALIZE TRANSTYPE TO "ISS-SO" FOR ITEMS AND */
/*J2S5*/             /* "ISS-UNP" FOR CONTAINER ITEMS BEFORE CHECKING  */
/*J2S5*/             /* FOR RESTRICTED TRANSACTION                     */

/*J2S5** /*J1LY*/ if v_editall and available sod_det and sod_type = "" then */

/*J2S5*/             if v_editall and
/*J3GJ*/                lookup(substring(ship_line.abs_id,1,1),"p,s") = 0 and
/*J2S5*/                ((available sod_det and sod_type = "") or
/*J2S5*/                 (not available sod_det)) then
/*J134*/             do:

/*N0WX*/                {&RCSHWBB-P-TAG7}
/*J2S5*/                if ship_line.abs_id begins "i" then
/*N0WX*/                {&RCSHWBB-P-TAG8}
/*J2S5*/                   assign ship_so   = sod_nbr
/*J2S5*/                          ship_line = sod_line
/*J2S5*/                          transtype = "ISS-SO".
/*N0WX*/                {&RCSHWBB-P-TAG9}
/*J2S5*/                else if ship_line.abs_id begins "c" then
/*J2S5*/                   transtype = "ISS-UNP".

                        /* VALIDATE LOT / PART */
/*K223*/                /* ADDED UM CONV AS TENTH INPUT PARAMETER ;  */
/*K223*/                /* PASSING ABS__QAD03                        */
                        {gprun.i ""rcctmtb.p""
                           "(input transtype,
                             input ship_from,
                             input ship_line.abs_site,
                             input ship_line.abs_loc,
                             input ship_line.abs_item,
                             input ship_line.abs_lot,
                             input ship_line.abs_ref,
                             input ship_line.abs_qty,
                             input ship_line.abs__qad02,
                             input decimal(ship_line.abs__qad03),
                             output undotran)"}

                        if undotran then undo SET_DATA, retry SET_DATA.
                     end.

/*K04X*  /*K003*/    if ship_line.abs_site <> ship_from then do:  *K04X*/

/*K04X*/             if v_editall and ship_line.abs_site <> ship_from then do:
/*K003*/                {gprun.i ""gpgetgrp.p""
                                 "(input ship_line.abs_site,
                                   input ship_from,
                                   output shipgrp)"}
/*K003*/                if shipgrp <> ? then do:
/*K003*/                   if can-find (sg_mstr where sg_grp = shipgrp and
/*K003*/                      sg_auto_tr = no ) then do:
/*K003*/                      {mfmsg03.i 5845 3 ship_line.abs_site
                                         ship_from """"}
                      /* Automatic transfer from site # to site # prohibited */
/*K003*/                      undo SET_DATA, retry SET_DATA.
/*K003*/                   end.
/*K003*/                end. /* if shipgrp <> ? */
/*K003*/             end. /* if ship_line.abs_site <> ship_from  */

/*J1HV*/             /* FOR VALID ITEMS ONLY,                             */
/*J1HV*/             /* IF THE USER ENTERED A NEW QTY AND DIDN'T CHANGE   */
/*J1HV*/             /* EITHER VOLUME OR WEIGHT, ASK IF VOLUME AND WEIGHT */
/*J1HV*/             /* SHOULD BE RECALCULATED.                           */
/*J1HV*/
/*J1HV*/             find pt_mstr where pt_part = ship_line.abs_item
/*J1HV*/             no-lock no-error.

/*J2M7*/             /* NET WT AND QTY ARE CHANGED TOGETHER FOR ITEM     */
/*J2M7*/             /* OR TARE WT AND QTY FOR CONTAINER                 */

/*J389*/             /* SINCE ONLY ITEM LEVEL QUANTITY CAN BE EDITED,    */
/*J389*/             /* THE CODE RELATED TO CHANGING TARE WT AND QTY AT  */
/*J389*/             /* THE CONTAINER LEVEL IS NOT NECESSARY             */

/*J2M7*/             if available pt_mstr
/*J389** /*J2M7*/       and (ship_line.abs_nwt <> nwt_old       */
/*J389** /*J2M7*/            or l_abs_tare_wt <> l_twt_old)     */
/*J389*/                and ship_line.abs_nwt <> nwt_old
/*J2M7*/                and ship_line.abs_qty <> qty_old
/*J2M7*/                and ship_line.abs_vol = vol_old
/*J2M7*/                then do:

/*J389** /*J2M7*/            if ship_line.abs_id begins "i" then */
/*J2M7*/                        assign
/*J2M7*/                          ch_nwt =  (ship_line.abs_nwt - nwt_old)
/*J2M7*/                          ship_line.abs_nwt = nwt_old
/*J389** /*J2M7*/                l_abs_tare_wt = (l_abs_tare_wt / qty_old ) * */
/*J389** /*J2M7*/                                 ship_line.abs_qty.          */
/*J389*/                          l_abs_tare_wt =
/*J389*/                              if qty_old <> 0 then
/*J389*/                                 (l_abs_tare_wt / qty_old) *
/*J389*/                                 ship_line.abs_qty
/*J389*/                              else
/*J389*/                                 l_abs_tare_wt * ship_line.abs_qty.

/*J389***BEGIN DELETE***
 * /*J2M7*/                     else
 * /*J2M7*/                        assign
 * /*J2M7*/                          ch_nwt = (ship_line.abs_nwt / qty_old )
 * /*J2M7*/                                       * ship_line.abs_qty - nwt_old
 * /*J2M7*/                          ship_line.abs_nwt = nwt_old.
 *J389***END DELETE**/

/*J2M7*/                  {gprun.i ""icshnwt.p""
                   "(input recid(ship_line),
                     input ch_nwt,
                     input yes,
                     input ship_Line.abs_wt_um)"}
/*J2M7*/                  {gprun.i ""icshnwt.p""
                   "(input recid(ship_line),
                     input l_abs_tare_wt - l_twt_old,
                     input no,
                         input ship_Line.abs_wt_um)"}
/*J2M7*/                  {abspack.i "ship_line" 26 22 "l_abs_tare_wt" }

/*J2M7*/             end. /* IF ABS_NWT <> NWT_OLD AND QTY_OLD <> ABS_QTY */

/*J1HV*/
/*J1HV*/             if available pt_mstr then do:

/*M0RX*/                if ship_line.abs_nwt <> nwt_old and
/*M0RX*/                   ship_line.abs_vol <> vol_old and
/*M0RX*/                   ship_line.abs_qty <> qty_old then
/*M0RX*/                do:
/*M0RX*/                   assign
/*M0RX*/                   ch_nwt            = ship_line.abs_nwt - nwt_old
/*M0RX*/                   ship_line.abs_nwt = nwt_old.
/*M0RX*/                   {gprun.i ""icshnwt.p""
/*M0RX*/                   "(input recid(ship_line),
/*M0RX*/                     input ch_nwt,
/*M0RX*/                     input yes,
/*M0RX*/                     input ship_line.abs_wt_um)"}.

/*M0RX*/                   display ship_line.abs_nwt ship_line.abs_vol
/*M0RX*/                   with frame sample.
/*M0RX*/                end. /* IF ABS_NWT <> NWT_OLD AND ABS_VOL <> VOL_OLD */
/*M0RX*/                     /* AND ABS_QTY <> QTY_OLD                       */

/*J1HV*/                if ship_line.abs_qty <> qty_old
/*J1HV*/                and ship_line.abs_vol = vol_old
/*J1HV*/                and ship_line.abs_nwt = nwt_old
/*J1HV*/                then do:
/*J1HV*/                   ok_to_recalc_wt_vol = true.
/*J1HV*/                   {mfmsg01.i 1480 1 ok_to_recalc_wt_vol}
/*J1HV*/                   /*Quantity changed.  Recalculate weight and volume?*/
/*J1HV*/
/*J1HV*/                   if ok_to_recalc_wt_vol then do:
/*J1HV*/
/*J2M7** /*J1HV*/       ship_line.abs_nwt = pt_net_wt * ship_line.abs_qty. */
/*J389*/                     if qty_old <> 0 then
/*J2M7*/                      assign
/*J2M7*/                      ch_nwt = (ship_line.abs_nwt / qty_old )
/*J2M7*/                                * ship_line.abs_qty - nwt_old
/*J2M7*/                      ship_line.abs_nwt  = nwt_old
/*J2M7*/                      l_abs_tare_wt = (l_abs_tare_wt / qty_old ) *
/*J2M7*/                                      ship_line.abs_qty
/*J389*/                      .

/*J389*/                     else
/*J389*/                        assign
/*J389*/                           ch_nwt =
/*J389*/                               MAX (pt_net_wt * ship_line.abs_qty,0)
/*J389*/                           ship_line.abs_nwt    = nwt_old
/*J389*/                           l_abs_tare_wt        =
/*J389*/                               MAX ((pt_ship_wt * ship_line.abs_qty ) -
/*J389*/                               (pt_net_wt * ship_line.abs_qty ),0)
/*J389*/                           ship_line.abs_vol_um = pt_size_um
/*J389*/                           ship_line.abs_wt_um  = pt_net_wt_um.

/*J2ZC** /*J1HV*/         ship_line.abs_vol = pt_size   * ship_line.abs_qty. */
/*K238** /*J2ZC*/         ship_line.abs_vol = pt_size   * ship_line.abs_qty  */
/*K238** /*J2ZC*/                          *  decimal(ship_line.abs__qad03). */

/*K238*/                  ship_line.abs_vol = MAX (pt_size * ship_line.abs_qty
/*K238*/                                   * decimal(ship_line.abs__qad03),0).

/*J2M7*/                      {abspack.i  "ship_line" 26 22 "l_abs_tare_wt" }

/*J2M7*/                      {gprun.i ""icshnwt.p""
                       "(input recid(ship_line),
                         input ch_nwt,
                         input yes,
                         input ship_Line.abs_wt_um)"}
/*J2M7*/                      {gprun.i ""icshnwt.p""
                       "(input recid(ship_line),
                     input ( - ch_nwt),
                     input no,
                     input ship_Line.abs_wt_um)"}

/*J389*/                      if qty_old <> 0 then
/*J2M7*/                         ch_nwt = (ship_line.abs_gwt / qty_old )
/*J2M7*/                                  * ship_line.abs_qty
/*J2M7*/                                  - (ship_line.abs_gwt).
/*J389*/                      else do:
/*J389*/                         ch_nwt =
/*J389*/                            MAX (pt_ship_wt * ship_line.abs_qty,0).

/*J389*/                         /* ASSIGN NET WT IF ITEM SHIP WT */
/*J389*/                         /* IS ZERO IN PART MASTER */

/*J389*/                        if pt_ship_wt = 0 and pt_net_wt <> 0 then
/*J389*/                           ch_nwt =
/*J389*/                              MAX (pt_net_wt * ship_line.abs_qty,0).
/*J389*/                      end. /* IF QTY_OLD = 0 */

/*J2M7*/                      {gprun.i ""icshnwt.p""
                       "(input recid(ship_line),
                             input ch_nwt,
                             input no,
                                 input ship_Line.abs_wt_um)"}
/*J1HV*/
/*J1HV*/                      display ship_line.abs_nwt ship_line.abs_vol
/*J1HV*/                      with frame sample.
/*J1HV*/                   end.
/*J1HV*/                end.
/*J1HV*/             end.

/*K003*/             if cmmts then do:
/*K003*/                find abs_parent_buff where
/*K003*/                     recid(abs_parent_buff) = parent_abs_recid
/*K003*/                     no-lock no-error.
/*K003*/                assign cmtindx = ship_line.abs_cmtindx
/*K003*/                       global_ref = abs_parent_buff.abs_format
/*K003*/                       global_lang = abs_parent_buff.abs_lang.
/*K003*/                {gprun.i ""gpcmmt01.p"" "(input 'abs_mstr')"}
/*K003*/                ship_line.abs_cmtindx = cmtindx.
/*K003*/             end.

/*K003*/             /* Gather additional line item data */
/*K003*/             {gprun.i ""sofsgi.p"" "(recid(ship_line))" }

/*J2M7*/             {absupack.i  "ship_line" 26 22 "l_abs_tare_wt" }

/*J2M7*/             /* IF QTY OF THE PARENT CHANGED */

/*J389*/             /* SINCE ONLY ITEM LEVEL QUANTITY CAN BE EDITED,    */
/*J389*/             /* THE CODE RELATED TO CHANGING TARE WT AND QTY AT  */
/*J389*/             /* PARENT LEVEL IS NOT NECESSARY                    */

/*J389***BEGIN DELETE***
 * /*J2M7*/            if not available pt_mstr and (ship_line.abs_id begins "p"
 * /*J2M7*/                or ship_line.abs_id begins "s" ) then do:
 * /*J2M7*/                if qty_old <> ship_line.abs_qty and
 * /*J2M7*/                   l_abs_tare_wt <> l_twt_old then
 * /*J2M7*/                      assign
 * /*J2M7*/                        ship_line.abs_nwt =
 * /*J2M7*/                                     (ship_line.abs_nwt / qty_old )
 * /*J2M7*/                                     * ship_line.abs_qty
 * /*J2M7*/                        ship_line.abs_gwt = (ship_line.abs_gwt +
 * /*J2M7*/                                       (l_abs_tare_wt - l_twt_old ) +
 * /*J2M7*/                                      (ship_line.abs_nwt - nwt_old)).
 * /*J2M7*/                if qty_old <> ship_line.abs_qty and
 * /*J2M7*/                   l_abs_tare_wt = l_twt_old then
 * /*J2M7*/                   assign
 * /*J2M7*/                   ship_line.abs_nwt = (ship_line.abs_nwt / qty_old )
 * /*J2M7*/                                       * ship_line.abs_qty
 * /*J2M7*/                      l_abs_tare_wt = (l_abs_tare_wt / qty_old ) *
 * /*J2M7*/                                      ship_line.abs_qty.
 * /*J2M7*/                      {abspack.i  "ship_line" 26 22 "l_abs_tare_wt" }
 * /*J2M7*/             end. /* IF NOT AVAILABLE PT_MSTR ....*/
 *J389***END DELETE**/

                     /* CHECK FOR WEIGHT CHANGE AND PROPOGATE */
/*J2M7**             if ship_line.abs_nwt <> nwt_old then do: */
/*J2M7*/             if ship_line.abs_nwt <> nwt_old and
/*J2M7*/                ship_line.abs_qty = qty_old then do:

/*J1HV*************
. /*J0YL*/                set
. /*J0YL*/                   ship_line.abs_gwt = ship_line.abs_nwt
. /*J0YL*/                with frame sample.
**J1HV************/
/*K0DY
* /*J1HV*/                ship_line.abs_gwt = ship_line.abs_gwt
* /*J1HV*/                + (ship_line.abs_nwt - nwt_old).
*
*                        {gprun.i ""rcctwbc4.p""
*                                 "(input recid(ship_line),
*                                   input ship_line.abs_nwt - nwt_old,
*                                   input ship_Line.abs_wt_um)"}
*K0DY*/

/*K0DY*/                  ch_nwt = ship_line.abs_nwt - nwt_old.
/*K0DY*/                  ship_line.abs_nwt = nwt_old.

/*J2M7*/                /* PASSING YES TO THE 3RD ADDED PARAMETER, CHANGE_NET */
/*K0DY*/                  {gprun.i ""icshnwt.p""
/*K0DY*/                          "(input recid(ship_line),
/*K0DY*/                            input ch_nwt,
                    input yes,
/*K0DY*/                            input ship_Line.abs_wt_um)"}

                     end. /* IF ABS_NWT <> NWT_OLD */

/*J2M7*/             /* CHECK FOR TARE WEIGHT CHANGE AND PROPOGATE */

/*J2M7*/             if l_abs_tare_wt <> l_twt_old
/*J2M7*/                and ship_line.abs_nwt = nwt_old
/*J2M7*/                and ship_line.abs_qty = qty_old
/*J2M7*/             then do:

/*J2M7*/                  {gprun.i ""icshnwt.p""
/*J2M7*/                          "(input recid(ship_line),
/*J2M7*/                            input l_abs_tare_wt - l_twt_old,
                    input no,
/*J2M7*/                            input ship_Line.abs_wt_um)"}
/*J2M7*/             end. /* IF L_ABS_TARE_WT <> L_TWT_OLD */

/*K005*/             /* CONSUME REQUIREMENTS */
/*K005*/             if ship_line.abs_id begins "i"
/*K005*/                and cnsm_req then
/*K005*/             do:
/*K005*/                {gprun.i ""rcshwbb2.p"" "(input recid(ship_line),
                                                  input absship_recid)"}
/*K005*/             end.

/*N004*/             /* MAINTAIN SEQUENCES */
/*N004*/             if ship_line.abs_id begins "i" then
/*N004*/                run maintain_sequences
/*N004*/                    (input ship_line.abs_id,
/*N004*/                     input ship_line.abs_shipfrom).

/*K15N*** BEGIN DELETE - MOVED TO rcshvid.p FOR MULTI-DB CAPABILITIES ****
 * /*K003*    ADDED FOLLOWING SECTION  */
 * /*K04X*  /*K003*/    if ship_line.abs_fa_lot entered then do:  *K04X*/
 * /*K04X*/             if ship_line.abs_fa_lot ne "" then do:
 * /*K003*/                find wo_mstr no-lock where
 * /*K003*/                wo_lot = ship_line.abs_fa_lot no-error.
 * /*K003*/                      if not available wo_mstr then do:
 * /*K003*/                   {mfmsg.i 503 3} /* WO number doesn't exist */
 * /*K003*/                  next-prompt ship_line.abs_fa_lot with frame sample.
 * /*K003*/                   undo SET_DATA, retry SET_DATA.
 * /*K003*/                     end.
 * /*K003*/                else if index ("EAR",wo_status) = 0 then do:
 * /*K003*/                   {mfmsg.i 523 3} /* WO IS CLOSED PLANNED OR FIRM */
 * /*K003*/                  next-prompt ship_line.abs_fa_lot with frame sample.
 * /*K003*/                   undo SET_DATA, retry SET_DATA.
 * /*K003*/                end.
 * /*K0JC* /*K003*/                if wo_nbr <> sod_fa_nbr then */
 * /*K0JC*/                if available sod_det and wo_nbr <> sod_fa_nbr then
 * /*K003*/                   {mfmsg.i 5852 2} /* WO IS FOR DIFF SO  */
 * /*K003*/             end.
 * K15N** END DELETE ******************************************/

/*L0PR*/             if ship_line.abs_id begins "i" then
/*L0PR*/             do:
/*L0PR*/                /* SET GLOBAL_DB USING ABS_SITE */
/*L0PR*/                new_site = ship_line.abs_site.
/*L0PR*/                {gprun.i ""gpalias.p""}

/*L0PR*/                /* SWITCH TO THE INVENTORY SITE */
/*L0PR*/                if so_db <> global_db then
/*L0PR*/                do:
/*L0PR*/                   {gprun.i ""gpalias2.p""
                                    "(ship_line.abs_site, output errornum)"}

/*L0PR*/                   if errornum <> 0 and errornum <> 9 then
/*L0PR*/                   do:
/*L0PR*/                      /* DATABASE # IS NOT CONNECTED */
/*M110** BEGIN DELETE
 * /*L0PR*/                   run p-mfmsg03 (input 2510,
 *                                           input 4,
 *                                           input {&rcshwbb_p_4},
 *                                           input "",
 *                                           input "").
 *M110** END DELETE */
/*M110*/                      /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                      run p-pxmsg (input 2510,
                                           input 4,
                                           input l_msgar1[2]).

/*L0PR*/                      undo SET_DATA, retry SET_DATA .
/*L0PR*/                   end. /* IF ERRORNUM <> 0 AND ... */

/*L0PR*/                   /* UPDATE SOD__QADL01 (CANCEL B/O) IN INVENTORY DB */
/*L0PR*/                   {gprun.i ""rcsodqad.p"" "(input cancel_bo,
                                                     input ship_line.abs_order,
                                                     input ship_line.abs_line)"}

/*L0PR*/                   /* SWITCH BACK TO THE SALES ORDER DATABASE */
/*L0PR*/                   {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}

/*L0PR*/                   if errornum <> 0 and errornum <> 9 then do:
/*L0PR*/                      /* DATABASE # IS NOT CONNECTED */

/*M110** BEGIN DELETE
 * /*L0PR*/                   run p-mfmsg03 (input 2510,
 *                                           input 4,
 *                                           input {&rcshwbb_p_3},
 *                                           input "",
 *                                           input "").
 *M110** END DELETE */
/*M110*/                      /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                      run p-pxmsg (input 2510,
                                           input 4,
                                           input l_msgar1[1]).

/*L0PR*/                      undo SET_DATA, retry SET_DATA.
/*L0PR*/                   end. /* IF ERRORNUM <> 0 AND ... */

/*L0PR*/                end. /* IF SO_DB <> GLOGAL_DB */

/*L0PR*/                /* UPDATE SOD__QADL01 (CANCEL B/O) IN ORDER DB */
/*L0PR*/                {gprun.i ""rcsodqad.p"" "(input cancel_bo,
                                                  input ship_line.abs_order,
                                                  input ship_line.abs_line)"}
/*L0PR*/             end. /* IF SHIP_LINE.ABS_ID BEGINS "I" */


/*K15N*/ /* ADDED NEXT if BLOCK TO VALIDATE WORK ORDER IN INVENTORY DATABASE */

/*K15N*/             if ship_line.abs_fa_lot ne "" then do:

/*K15N*/ /* PASS "NA" IN sodfanbr TO rcshvid.p WHEN sod_det IS NOT AVAILABLE */
/*K15N*/                if available sod_det then sodfanbr = sod_fa_nbr.
/*K15N*/                                     else sodfanbr = "NA".

/*K15N*/                /* SET GLOBAL_DB USING ABS_SITE */
/*K15N*/                new_site = ship_line.abs_site.
/*K15N*/                {gprun.i ""gpalias.p""}

/*K15N*/                if so_db <> global_db then do:
/*K15N*/                   /* SWITCH TO THE REMOTE SITE */
/*K15N*/                   {gprun.i ""gpalias2.p""
                            "(input ship_line.abs_site,
                              output errornum)"}

/*K15N*/                   if errornum <> 0 and errornum <> 9 then do:
/*K15N*/                      /* UNABLE TO CONNECT TO REMOTE DATABASE */
/*M110** /*K15N*/             {mfmsg03.i 2510 4                       */
/*M110**                          {&rcshwbb_p_4} """" """"}           */
/*M110*/                      /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                      run p-pxmsg (input 2510,
                                           input 4,
                                           input l_msgar1[2]).
/*K15N*/                      next-prompt ship_line.abs_fa_lot
/*K15N*/                                  with frame sample.
/*K15N*/                      undo SET_DATA, retry SET_DATA.
/*K15N*/                   end.
/*K15N*/                end. /* so_db <> global_db */

/*K15N*/                undotran = no.
/*K15N*/                /* VALIDATE WORK ORDER POSSIBLY IN REMOTE DB */
/*K15N*/                {gprun.i ""rcshvid.p""
                         "(input ship_line.abs_fa_lot,
                           input sodfanbr,
                           output undotran)"}

/*K15N*/                if so_db <> global_db then do:
/*K15N*/                   /* RESET TO CENTRAL DATABASE */
/*K15N*/                   {gprun.i ""gpalias3.p""
                            "(input so_db,
                              output errornum)"}

/*K15N*/                   if errornum <> 0 and errornum <> 9 then do:
/*K15N*/                      /* UNABLE TO CONNECT TO SALES DATABASE */
/*M110** /*K15N*/             {mfmsg03.i 2510 4                       */
/*M110**                          {&rcshwbb_p_3} """" """"}           */
/*M110*/                      /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                      run p-pxmsg (input 2510,
                                           input 4,
                                           input l_msgar1[1]).
/*K15N*/                      next-prompt ship_line.abs_fa_lot
/*K15N*/                                  with frame sample.
/*K15N*/                      undo SET_DATA, retry SET_DATA.
/*K15N*/                   end.
/*K15N*/                end. /* so_db <> global_db */

/*K15N*/ /* CHECKING undotran FROM rcshvid.p CALL HERE TO ALLOW DB SWITCHING */

/*K15N*/                if undotran then do:
/*K15N*/                   next-prompt ship_line.abs_fa_lot with frame sample.
/*K15N*/                   undo SET_DATA, retry SET_DATA.
/*K15N*/                end.
/*K15N*/             end. /* if ship_line.abs_fa_lot ne "" */

                     /* CHANGING SITE, LOC, LOT, or REF */
/*K003*              ALLOCATE REG ITEM, KIT COMP, & ATO W/ F/A LOT */
/*K04X*  /*K003*/    if (available sod_det and sod_type = "" and  *K04X*/

/*K04X*/             if v_editall and
/*K04X*/                (available sod_det and sod_type = "" and
/*K21N** /*K003*/        ((sod_cfg_type <> "2" and sod_fa_nbr = "") or */
/*K21N*/                 (sod_cfg_type <> "2" or
/*K003*/                 (kit_comp))) then do:

/*J37V*/                if l_order_change then
/*J37V*/                do:
/*J37V*/                   /* UPDATE DETAIL ALLOCATIONS */
/*J37V*/                   run p_update_alloc .
/*J37V*/                   if undotran then
/*J37V*/                      undo SET_DATA, retry SET_DATA.

/*J37V*/                end. /* IF L_ORDER_CHANGE */
/*J37V*/                else do:
/*K003*/                if (old_site <> ship_line.abs_site) or
/*K003*/                   (old_lot <> ship_line.abs_lot) or
/*K003*/                   (old_loc <> ship_line.abs_loc) or
/*K003*/                   (old_ref <> ship_line.abs_ref)  then do:

                          /* SET GLOBAL_DB USING ABS_SITE */
                          new_site = ship_line.abs_site.
                          {gprun.i ""gpalias.p""}

                          /* SWITCH TO THE INVENTORY SITE */
                          if so_db <> global_db then do:
                              {gprun.i ""gpalias2.p""
                                       "(ship_line.abs_site, output errornum)"}
                              if errornum <> 0 and errornum <> 9 then do:
                                 /* DATABASE # IS NOT CONNECTED */
/*M110**                         {mfmsg03.i 2510 4              */
/*M110**                         {&rcshwbb_p_4} """" """"}      */
/*M110*/                      /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                      run p-pxmsg (input 2510,
                                           input 4,
                                           input l_msgar1[2]).
                                 undo SET_DATA, retry SET_DATA .
                              end.
                          end.

/*J2CQ**    ** CALL TO SOITALLB.P HAS BEEN REPLACED BY CALL TO SOITALLD.P ** */
/*J2CQ** BEGIN DELETE **
 *                           {gprun.i ""soitallb.p""
 *                                "(input ship_line.abs_order,
 *                                  input ship_line.abs_line,
 *                                  input ship_line.abs_item,
 *                                  input old_site,
 *                                  input old_loc,
 *                                  input old_lot,
 *                                  input old_ref,
 *                                  input - old_qty,
 *                                  input  del_lad,
 *                                  output avail_qty,
 *                                  output tmp_qty)"}
 *J2CQ** END DELETE ** */
/*K1NF**    ** CALL TO SOITALLD.P HAS BEEN REPLACED BY CALL TO SOITALLB.P ** */
/*K1NF** BEGIN DELETE **
 * /*J2CQ*/                {gprun.i ""soitalld.p""
 *                                "(input ship_line.abs_order,
 *                                  input ship_line.abs_line,
 *                                  input ship_line.abs_item,
 *                                  input old_site,
 *                                  input old_loc,
 *                                  input old_lot,
 *                                  input old_ref,
 *                                  input - old_qty,
 *                                  input qty_old,
 *                                  input qty_old,
 *                                  input del_lad,
 *                                  output adj_qty,
 *                                  output undotran)"}
 *K1NF** END DELETE ** */

/*J2MH*/                  /* CONVERTED - OLD_QTY TO INVENTORY UM */
/*J2TP*/                  /* ADDED INPUT PARAMETER -SHIP_LINE.ABS_QTY */
/*J394*/                  /* REPLACED EIGHTH PARAMETER TO QTY_OLD     */
/*J394*/                  /* FROM SHIP_LINE.ABS_QTY                   */
/*L0M0*/                  /* ADDED ELEVENTH INPUT PARAMETER L_DELPROC */
/*K1NF*/                  {gprun.i ""soitallb.p""
                                   "(input ship_line.abs_order,
                                     input ship_line.abs_line,
                                     input ship_line.abs_item,
                                     input old_site,
                                     input old_loc,
                                     input old_lot,
                                     input old_ref,
                                     input - qty_old *
                                             decimal(ship_line.abs__qad03),
                                     input - old_qty *
                                             decimal(ship_line.abs__qad03),
                                     input  del_lad,
                                     input l_delproc,
                                     output avail_qty,
                                     output tmp_qty)"}

                           /* DETAIL ALLOCATE NEW QTY, LOC, LOT ... */
/*K18W*/ /* PASSED PARAMETER abs__dec01 INSTEAD OF abs_qty TO soitalla.p. */
/*K18W*/ /* ADDED OUTPUT PARAMETER adj_qty                                */
/*K1NF*/ /* REPLACE SHIP_LINE.ABS__DEC01 WITH L_ABS_PICK_QTY*/
/*J2MH*/ /* CONVERTED L_ABS_PICK_QTY TO INVENTORY UM */
/*J33X*/ /* ADDED NINTH INPUT PARAMETER 0            */
/*J394*/ /* REPLACED EIGHTH PARAMETER TO SHIP_LINE.ABS_QTY  */
/*J394*/ /* FROM L_ABS_PICK_QTY                             */
                           {gprun.i ""soitalla.p""
                                   "(input ship_line.abs_order,
                                     input ship_line.abs_line,
                                     input ship_line.abs_item,
                                     input ship_line.abs_site,
                                     input ship_line.abs_loc,
                                     input ship_line.abs_lot,
                                     input ship_line.abs_ref,
                                     input ship_line.abs_qty *
                                            decimal(ship_line.abs__qad03),
                                     input 0,
                                     output adj_qty,
                                     output undotran)"}

/*M1FF*/                   if undotran
/*M1FF*/                   then
/*M1FF*/                      undo SET_DATA, retry SET_DATA.

/*M1FF** /*J394*/          if ship_line.abs_qty <> l_abs_pick_qty then do : */

/*M1FF*/                   if  ship_line.abs_qty <> l_abs_pick_qty
/*M1FF*/                   and ship_line.abs_qty > 0
/*M1FF*/                   then do:
/*J394*/                         {gprun.i ""soitalla.p""
                                          "(input ship_line.abs_order,
                                            input ship_line.abs_line,
                                            input ship_line.abs_item,
                                            input ship_line.abs_site,
                                            input ship_line.abs_loc,
                                            input ship_line.abs_lot,
                                            input ship_line.abs_ref,
                                            input (l_abs_pick_qty -
                                                   ship_line.abs_qty) *
                                               decimal(ship_line.abs__qad03),
                                            input 0,
                                            output adj_qty,
                                            output undotran)"}
/*J394*/                      end. /* IF SHIP_LINE.ABS_QTY <> L_ABS_PICK_QTY */

/*J34T**                  if undotran then undo SET_DATA, retry SET_DATA. */

                          /* SWITCH BACK TO THE SALES ORDER DATABASE */
                          if so_db <> global_db then do:

/*J394*/                     /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
/*J394*/                     /* IN REMOTE DATABASE                         */
/*J394*/                     if not kit_comp
/*J394*/                     then do:
/*L0M0*/                        /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
/*J394*/                        {gprun.i ""sosopka2.p""
                                         "(input ship_line.abs_order,
                                           input integer (ship_line.abs_line),
                                           input (l_abs_pick_qty - old_qty) *
                                                decimal(ship_line.abs__qad03),
                                           input l_delproc)"}
/*J394*/                     end. /* IF NOT KIT_COMP */

                 {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}
                             if errornum <> 0 and errornum <> 9 then do:
                                /* DATABASE # IS NOT CONNECTED */
/*L042**                       {mfmsg03.i 2510 4                         */
/*L042**                                 "'For Sales Orders'" """" """"} */
/*M110** /*L042*/              {mfmsg03.i 2510 4 {&rcshwbb_p_3} """" """"} */
/*M110*/                       /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/                       run p-pxmsg (input 2510,
                                            input 4,
                                            input l_msgar1[1]).
                                undo SET_DATA, retry SET_DATA .
                             end.
                          end.

/*J34T*/                  if undotran then undo SET_DATA, retry SET_DATA.

/*K003*/                  if not kit_comp then
                          /* UPDATE DETAIL QTY ALL, QTY PICK */
/*K18W*/   /* PASSED PARAMETER abs__dec01 INSTEAD OF abs_qty TO sosopka2.p */
/*K1NF*/   /* REPLACE SHIP_LINE.ABS__DEC01 WITH L_ABS_PICK_QTY*/
/*J2MH*/   /* CONVERTED L_ABS_PICK_QTY - OLD_QTY TO INVENTORY UM */
/*L0M0*/   /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
/*K003*/                  {gprun.i ""sosopka2.p""
                                   "(input ship_line.abs_order,
                                     input integer (ship_line.abs_line),
                                     input (l_abs_pick_qty - old_qty) *
                                            decimal(ship_line.abs__qad03),
                                     input l_delproc)"}

                        end.     /*  old_site <> ship_line.abs_site */

                         /* HERE  ONLY CHANGE QTY - UPDATE QTY DIFF  */
/*K0JC*                        else if (sod_type = "") and */
/*K0JC*/                else if (available sod_det) and (sod_type = "") and

/*K18W**                        (old_qty <> pick_qty) then do:     */
/*J2CQ** /*K18W*/               (old_qty <> ship_line.abs__dec01) then do: */

/*J2CQ*/                        ((qty_old <> ship_line.abs_qty) or
/*K1NF** /*J2CQ*/                (old_qty <> ship_line.abs__dec01)) then do: */
/*K1NF*/                         (old_qty <> l_abs_pick_qty)) then do:

/*J37V*/ /* THE FOLLOWING BLOCK OF CODE HAS BEEN MOVED TO THE */
/*J37V*/ /* INTERNAL PROCEDURE P_UPDATE_ALLOC1 DUE TO ACTION  */
/*J37V*/ /* SEGMENT ERROR.                                    */
/*J37V** BEGIN DELETE **
 *                        /* SET GLOBAL_DB USING ABS_SITE */
 *                        new_site = ship_line.abs_site.
 *                        {gprun.i ""gpalias.p""}

 *                        /* SWITCH TO THE INVENTORY SITE */
 *                        if so_db <> global_db then do:
 *                            {gprun.i ""gpalias2.p""
 *                                     "(ship_line.abs_site, output errornum)"}
 *                            if errornum <> 0 and errornum <> 9 then do:
 *                               /* DATABASE # IS NOT CONNECTED */
 *                               {mfmsg03.i 2510 4
 *                               {&rcshwbb_p_4} """" """"}
 *                               undo SET_DATA, retry SET_DATA .
 *                            end.
 *                        end.
 * /*J2CQ*/                  if  (qty_old = ship_line.abs_qty) and
/*K1NF** /*J2CQ*/             (old_qty <> ship_line.abs__dec01) then do: */
 * /*K1NF*/                      (old_qty <> l_abs_pick_qty) then do:
 *
 *
 * /*K18W*/   /* PASSED PARAMETER abs__dec01 INSTEAD OF abs_qty TO soitalla.p */
 * /*K18W*/   /* ADDED OUTPUT PARAMETER adj_qty                               */
 * /*K1NF*/   /* REPLACE SHIP_LINE.ABS__DEC01 WITH L_ABS_PICK_QTY             */
 * /*J2MH*/   /* CONVERTED L_ABS_PICK_QTY - OLD_QTY TO INVENTORY UM */
 * /*J33X*/   /* ADDED NINTH INPUT PARAMETER (SHIP_LINE.ABS_QTY - */
 * /*J33X*/   /* OLD_QTY) * DECIMAL(SHIP_LINE.ABS_QAD03)     */
 * /*K003*/                      {gprun.i ""soitalla.p""
 *                                    "(input ship_line.abs_order,
 *                                      input ship_line.abs_line,
 *                                      input ship_line.abs_item,
 *                                      input old_site,
 *                                      input old_loc,
 *                                      input old_lot,
 *                                      input old_ref,
 *                                      input (l_abs_pick_qty - old_qty) *
 *                                              decimal(ship_line.abs__qad03),
 *                                      input (ship_line.abs_qty - old_qty)
 *                                           * decimal(ship_line.abs__qad03),
 *                                      output adj_qty,
 *                                      output undotran)"}
/*J34T**                     if undotran then undo SET_DATA, retry SET_DATA. */
 * /*J2CQ*/                  end. /* IF QTY_OLD = SHIP_LINE.ABS_QTY AND ... */
 * /*J2CQ*/                  else do:
 * /*K1NF*/               /* REPLACE SHIP_LINE.ABS__DEC01 WITH L_ABS_PICK_QTY*/
 * /*J2MH*/               /* CONVERTED L_ABS_PICK_QTY - OLD_QTY AND          */
 * /*J2MH*/               /* SHIP_LINE.ABS_QTY - QTY_OLD AND QTY_OLD TO      */
 * /*J2MH*/               /* INVENTORY UM                                    */
 * /*J2CQ*/                      {gprun.i ""soitalld.p""
 *                                     "(input ship_line.abs_order,
 *                                       input ship_line.abs_line,
 *                                       input ship_line.abs_item,
 *                                       input old_site,
 *                                       input old_loc,
 *                                       input old_lot,
 *                                       input old_ref,
 *                                       input (l_abs_pick_qty - old_qty )*
 *                                             decimal(ship_line.abs__qad03),
 *                                       input (ship_line.abs_qty - qty_old) *
 *                                             decimal(ship_line.abs__qad03),
 *                                       input qty_old *
 *                                             decimal(ship_line.abs__qad03),
 *                                       input del_lad,
 *                                       output adj_qty,
 *                                       output undotran)"}
/*J34T** /*J2CQ*/             if undotran then undo SET_DATA, retry SET_DATA. */
 * /*J2CQ*/                  end. /* ELSE DO */
 *
 *                        /* SWITCH BACK TO THE SALES ORDER DATABASE */
 *                        if so_db <> global_db then do:
 *                           {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}
 *                           if errornum <> 0 and errornum <> 9 then do:
 *                              /* DATABASE # IS NOT CONNECTED */
 *                              {mfmsg03.i 2510 4
 *                                         {&rcshwbb_p_3} """" """"}
 *                              undo SET_DATA, retry SET_DATA .
 *                           end.
 *                        end.
 * /*J34T*/                 if undotran then undo SET_DATA, retry SET_DATA.
 *
 * /*K003*/                  if not kit_comp then
 * /*K18W*/   /* PASSED PARAMETER abs__dec01 INSTEAD OF abs_qty TO sosopka2.p */
 * /*J2CQ*/   /* PASSED PARAMETER adj_qty INSTEAD OF abs__dec01 TO sosopka2.p */
 *
 *                        /* UPDATE DETAIL QTY ALL, QTY PICK */
 * /*K003*/                  {gprun.i ""sosopka2.p""
 *                                 "(input ship_line.abs_order,
 *                                   input integer (ship_line.abs_line),
 *                                   input adj_qty)"}

 *                      end.
 *J37V** END DELETE   */

/*J37V*/                      /* UPDATE DETAIL ALLOCATION WHEN THE SHIP */
/*J37V*/                      /* AND/OR PICK QTY HAVE BEEN MODIFIED.    */
/*J37V*/                      run p_update_alloc1.
/*J37V*/                      if undotran then
/*J37V*/                         undo SET_DATA, retry SET_DATA.
                            end. /* IF OLD_SITE <> SHIP_LINE.ABS_SITE OR ... */
/*J37V*/                end. /* IF NOT L_ORDER_CHANGE */

/*K022*                 SEND cmf MESSAGE TO PBU */
/*K0CZ* /*K022*/        if cmf_flg then         */
/*K0CZ*/                if cmf_flg and
/*K0JC*/                   available sod_det and
/*K18W**BEGIN DELETE**
 * /*K0CZ*/                ((old_qty < pick_qty and old_qty = 0) or
 * /*K0CZ*/                (old_qty > pick_qty and pick_qty = 0)) then
 *K18W**END DELETE**/

/*K18W*/                   ((old_qty < ship_line.abs__dec01 and old_qty = 0) or
/*K18W*/                   (old_qty > ship_line.abs__dec01
/*K18W*/                and ship_line.abs__dec01 = 0)) then
/*K022*/                   run create-so-cmf (input recid (sod_det)).

/*K003*/             end.    /* if available sod_det... */
/*K003*  END ADDED SECTION */

                  end. /* SET_DATA */

                  /* HANDLE F5 KEY */
                  if (lastkey = keycode("F5")
/*K003*           or lastkey = keycode("CTRL-D")) then do:        */
/*K003*/          or lastkey = keycode("CTRL-D")) then
/*K0J7*/          do:
/*K0J7*/            next_editloop = no.
/*K0J7*/            run delete_proc (output next_editloop).
/*K0J7*/            if next_editloop then next editloop.
/*K0J7* moved code to internal procedure delete_proc ***************************
** /*K003*/          DEL_LOOP:
** /*K003*/          do on endkey undo DEL_LOOP, leave DEL_LOOP
** /*K003*/          on error undo DEL_LOOP, retry DEL_LOOP:
** /*K04X*/             if not v_editall then do:
** /*K04X*/                {mfmsg.i 5811 3}
** /*K04X*/                /* Selection only available for */
** /*K04X*/                /* unconfirmed SO shippers */
** /*K04X*/                next editloop.
** /*K04X*/             end.  /* if not v_editall */
**
**                      save_frame_line = frame-line(k).
**                      color display input first_column with frame k.
**
**                      /* DISPLAY F5 SELECTION FRAME */
**                      hide frame sample no-pause.
**                      view frame m1.
**
**                      assign
**                      sel_var_del = 0
**                      valid_entry = false.
**
**                      GET_SELECTION:
**                      do on endkey undo GET_SELECTION, leave GET_SELECTION
**                      on error undo GET_SELECTION, retry GET_SELECTION:
**
**                         /* PLEASE ENTER A SELECTION */
** /*V8-*/
**                         {mfmsg01.i 39 1 sel_var_del}
** /*V8+*/
** /*V8!                   {mfmsg01c.i 39 1 sel_var_del}   */
**
**                         if sel_var_del < 1 or sel_var_del > 5 then do:
**
**                            {mfmsg.i 13 3} /* NOT A VALID CHOICE */
**                            undo GET_SELECTION, retry GET_SELECTION.
**                         end.
**
**
**                         if ship_line.abs_id begins "i" and
**                         (sel_var_del <> 1 and sel_var_del <> 2) then do:
**
**                            {mfmsg.i 761 3} /* THIS OPTION NOT ALLOWED FOR .. */
**                            undo GET_SELECTION, retry GET_SELECTION.
**                         end.
**
** /*K003*/                if sel_var_del = 1 then do:
** /*K003*/                   find abs_parent_buff where
** /*K003*/                        recid(abs_parent_buff) = parent_abs_recid
** /*K003*/                        no-lock.
** /*K003*/                   if abs_parent_buff.abs_nr_id <> "" then do:
** /*K003*/                         run chk_delnbr (input abs_parent_buff.abs_nr_id,
**                                               output can_discard,
**                                                  output errorst, output errornum).
** /*K003*/                         if errorst then do:
** /*K003*/                               {mfmsg.i errornum 4}
** /*K003*/                               undo GET_SELECTION, retry GET_SELECTION.
** /*K003*/                         end.
**
** /*K003*/                      msgnum = if abs_parent_buff.abs_id begins "p"
** /*K003*/                               then 5944 else 5946.
**
** /*K003*/                         if not can_discard then do:
** /*K003*/                               {mfmsg.i msgnum 4}
** /*K003*/                 /*DELETION PROHIBITED, GAPS IN (PRE-)SHIPPER SEQUENCE
**                                                         NOT PERMITTED*/
** /*K003*/                               undo GET_SELECTION, retry GET_SELECTION.
** /*K003*/                         end.
** /*K003*/                   end. /* if abs_parent_buff.abs_nr_id <> "" */
**
** /*K003*/                   if abs_parent_buff.abs_preship_nr_id <> "" then do:
** /*K003*/                         run chk_delnbr
**                                   (input abs_parent_buff.abs_preship_nr_id,
**                                    output can_discard, output errorst,
**                                    output errornum).
** /*K003*/                         if errorst then do:
** /*K003*/                               {mfmsg.i errornum 4}
** /*K003*/                               undo GET_SELECTION, retry GET_SELECTION.
** /*K003*/                         end.
** /*K003*/
** /*K003*/                         if not can_discard then do:
** /*K003*/                               {mfmsg.i 5944 4}
** /*K003*/                 /*DELETION PROHIBITED, GAPS IN PRE-SHIPPER SEQUENCE
**                                                             NOT PERMITTED*/
** /*K003*/                               undo GET_SELECTION, retry GET_SELECTION.
** /*K003*/                         end.
** /*K003*/                   end. /* if abs_parent_buff.abs_preship_nr_id <> "" */
**
** /*K003*/                end. /* if sel_var_del = 1 */
**
**                         /* CHECK FOR ORPHAN ITEM RECORDS */
**                         if ship_line.abs_par_id = ""
**                         and sel_var_del = 2 or sel_var_del = 4 then do:
**
**                            for each abs_mstr
**                            where abs_mstr.abs_shipfrom = ship_from
**                            and abs_mstr.abs_par_id = ship_line.abs_id no-lock:
**
**                               if abs_mstr.abs_id begins "i" then do:
**
**                                  /* CANNOT ORPHAN AN ITEM RECORD */
**                                  {mfmsg.i 762 3}
**                                  undo GET_SELECTION, retry GET_SELECTION.
**
**                               end.
**                            end.
**                         end.
**
**
**                         del-yn = false.
**
**                         /* REMOVE / DELETE RECORD, PLEASE CONFIRM */
**                         {mfmsg01.i 11 1 del-yn}
**                         if not del-yn then
**                         undo GET_SELECTION, leave GET_SELECTION.
**
**                         valid_entry = true.
**                      end. /* GET SELECTION */
**
**                      /* HIDE DELETE FRAME */
**                      hide frame m1 no-pause.
**                      view frame sample.
**
**                      /* HANDLE DELETE SELECTION */
**                      if valid_entry then do:
**
**                         delete_recid = recid(ship_line).
**
** /*K003*/                kit_comp =  (ship_line.abs_par_id begins  "i").
**
**                         /* SUBTRACT WEIGHT FROM PARENTS */
**
**                         if sel_var_del <> 1 then do:
**
** /*K0DY*                    if sel_var_del = 2 or sel_var_del = 4 then
** *                             nwt_old = ship_line.abs_nwt * -1.
** *
** *                          else nwt_old = ship_line.abs_gwt * -1.
** *
** *
** *                          {gprun.i ""rcctwbc4.p""
** *                                   "(input recid(ship_line),
** *                                     input nwt_old,
** *                                     input ship_line.abs_wt_um)"}
** *K0DY*/
**
** /*K0DY*/                   if (ship_line.abs_id begins "i") then
** /*K0DY*/                         nwt_old = ship_line.abs_nwt * -1.
** /*K0DY*/                   else do:
** /*K0DY*/                       if sel_var_del = 2 or sel_var_del = 4 then
** /*K0DY*/                            nwt_old = ship_line.abs_nwt * -1.
** /*K0DY*/                       else nwt_old = ship_line.abs_gwt * -1.
** /*K0DY*/                   end.
** /*K0DY*/                   {gprun.i ""icshnwt.p""
** /*K0DY*/                            "(input recid(ship_line),
** /*K0DY*/                              input nwt_old,
** /*K0DY*/                              input ship_line.abs_wt_um)"}
**
**                         end. /* SEL_VAR_DEL <> 1 */
**
**
**                         /* REMOVE CONTAINER RECORD OR DELETE CONTAINER RECORD */
**                         if (sel_var_del = 2 or sel_var_del = 4)
**                         and ship_line.abs_id begins "c" then do:
**
**                            for each abs_mstr
**                            where abs_mstr.abs_shipfrom = ship_from
**                            and abs_mstr.abs_par_id = ship_line.abs_id
**                            exclusive-lock:
**
**                               /* CHANGE PARENT POINTERS OF CHILD RECORDS */
**                               abs_mstr.abs_par_id = ship_line.abs_par_id.
**                               abs_mstr.abs__qad06 =
**                               string(integer(abs_mstr.abs__qad06) - 1,"9").
**
**                               /* ADJUST LEVELS OF CHILD RECORDS */
**                               {gprun.i ""rcctwbu3.p""
**                                        "(input recid(abs_mstr))"}
**
**                            end.
** /*K03K*/                       /* Delete custom shipper document information
**                               associated with the record */
** /*K03K*/                       {gprun.i ""sofsde.p"" "(input recid(ship_line))"}
**                         end. /* IF SEL_VAR_DEL = 2 OR 4 */
**
**                         /* REMOVE STRUCTURE OR DELETE STRUCTURE */
**                         if sel_var_del = 3 or sel_var_del = 5 then do:
**
**                            /* SET ALL CHILD RECORD SHIPTO'S TO ""      */
**                            /* FOR DELETES WILL ALLOW FIND NEXT TO FIND */
**                            /* THE CORRECT RECORD */
**                            {gprun.i ""rcctwbu2.p"" "(delete_recid)"}.
**                         end.
**
** /*K03K*/                if sel_var_del = 4 or sel_var_del = 5 then
**                         ship_line.abs_par_id = "".
**
**                         /* REMOVE RECORD - REMOVE STRUCTURE */
**                         if sel_var_del = 4 or sel_var_del = 5 then
**                            ship_line.abs_shipto = ship_line.abs__qad05.
**
**                         /* CHECK FOR NEXT RECORD */
**                         find next ship_line
**                         where ship_line.abs_shipfrom = ship_from
**                         and ship_line.abs_shipto begins tmp_prefix
**                         no-lock no-error.
**
**                         if available ship_line then
**                            abs_recid = recid(ship_line).
**
**                         /* IF NO NEXT RECORD THEN FIND PREVIOUS RECORD */
**                         else do:
**
**                            find ship_line
**                            where recid(ship_line) = delete_recid
**                            no-lock no-error.
**
**                            find prev ship_line
**                            where ship_line.abs_shipfrom = ship_from
**                            and ship_line.abs_shipto begins tmp_prefix
**                            no-lock no-error.
**
**                            if available ship_line then do:
**
**                               abs_recid = recid(ship_line).
**                               if save_frame_line > 1 then
**                               save_frame_line = save_frame_line - 1.
**                            end.
**
**                            /* NO RECORDS LEFT SO RESET */
**                            else do:
**
**                               assign
**                               abs_recid = ?
**                               save_frame_line = 1.
**                            end.
**
**                         end. /* ELSE DO */
**
**                         /* HANDLE DELETES */
**                         if sel_var_del = 2 or sel_var_del = 3 then do:
**
**                            find ship_line
**                            where recid(ship_line) = delete_recid
**                            exclusive-lock no-error.
**
** /*K005*/                   /* DELETE ABSR_DET RECORDS */
** /*K005*/                   if ship_line.abs_id begins "i" then
** /*K005*/                   do:
** /*K005*/                      {gprun.i ""rcdlabsr.p"" "(input delete_recid)"}
** /*K005*/                   end.
**
**                            /* IF DELETE STRUCTURE THEN DELETE ALL CHILDREN */
**                            if sel_var_del = 3 then do:
**
**                               /* DELETE ALL CHILD RECORDS */
**                               {gprun.i ""rcctwbu1.p"" "(input delete_recid,
**                                                       output undotran)"}
**                               if undotran then undo DEL_LOOP, retry DEL_LOOP.
**
**                            end.
**
**
**                            /* IF DELETE KIT PARENT THEN DELETE ALL COMPONENTS */
** /*K003*/                   if sel_var_del = 2 and
** /*K003*/                   ship_line.abs_id begins "i" then do:
**                              /* CAN'T CHECK sod_det, SO MAY HAVE BEEN DELETED */
** /*K003*/                      find first abs_mstr
** /*K003*/                      where abs_mstr.abs_shipfrom = ship_from
** /*K003*/                      and abs_mstr.abs_par_id = ship_line.abs_id
** /*K003*/                      no-lock no-error.
** /*K003*/                      if available abs_mstr then do:
**
**
**                                  /* DELETE ALL COMPONENT RECORDS */
**                                  {gprun.i ""rcctwbu1.p"" "(input delete_recid,
**                                                       output undotran)"}
**                                  if undotran then undo DEL_LOOP, retry DEL_LOOP.
**
** /*K003*/                      end.
**
** /*K003*                       SET del_lad to YES ONLY FOR  KIT COMPONENT */
** /*K003*/                      del_lad = kit_comp.
**
**                               /* SET GLOBAL_DB USING ABS_SITE */
**                               new_site = ship_line.abs_site.
**                               {gprun.i ""gpalias.p""}
**
**                               /* SWITCH TO THE INVENTORY SITE */
**                               if so_db <> global_db then do:
**                                   {gprun.i ""gpalias2.p""
**                                         "(ship_line.abs_site, output errornum)"}
**                                   if errornum <> 0 and errornum <> 9 then do:
**                                      /* DATABASE # IS NOT CONNECTED */
**                                      {mfmsg03.i 2510 4
**                                           "'For Remote Inventory'" """" """"}
**                                      undo DEL_LOOP, retry DEL_LOOP.
**                                   end.
**                               end.
**
** /*K003*/                      {gprun.i ""soitallb.p""
**                                    "(input ship_line.abs_order,
**                                     input ship_line.abs_line,
**                                     input ship_line.abs_item,
**                                     input ship_line.abs_site,
**                                     input ship_line.abs_loc,
**                                     input ship_line.abs_lot,
**                                     input ship_line.abs_ref,
**                                     input - ship_line.abs_qty ,
**                                     input del_lad,
**                                     output avail_qty,
**                                     output pick_qty)"}
**
**                               /* SWITCH BACK TO THE SALES ORDER DATABASE */
**                               if so_db <> global_db then do:
**                                  {gprun.i ""gpalias3.p""
**                                            "(so_db, output errornum)"}
**                                  if errornum <> 0 and errornum <> 9 then do:
**                                     /* DATABASE # IS NOT CONNECTED */
**                                     {mfmsg03.i 2510 4
**                                              "'For Sales Orders'" """" """"}
**                                     undo DEL_LOOP, retry DEL_LOOP.
**                                  end.
**                               end.
**
**
** /*K003*/                      find sod_det where sod_nbr = ship_line.abs_order
** /*K003*/                      and sod_line = integer (ship_line.abs_line)
** /*K003*/                      no-lock no-error.
** /*K003*/                      if available sod_det and sod_cfg_type <> "2"
** /*K003*/                      and sod_fa_nbr = "" then
** /*K0CZ*/                      do:
**                                  /* UPDATE DETAIL QTY ALL, QTY PICK */
** /*K003*/                         {gprun.i ""sosopka2.p""
**                                         "(input ship_line.abs_order,
**                                           input integer (ship_line.abs_line),
**                                           input - ship_line.abs_qty)"}
**
** /*K0CZ*/                         find so_mstr where so_nbr = sod_nbr no-lock no-error.
** /*K0DH* /*K0CZ*/                 if available so_mstr and not so_primary then */
** /*K0DH*/                         if available so_mstr and so_secondary then
** /*K0CZ*/                         run create-so-cmf (input recid (sod_det)).
**
** /*K0CZ*/                      end.
**
** /*K003*/                      del_lad = no.
** /*K003*/                   end.
**
** /*K03K*/                       /* Delete custom shipper document information
**                               associated with the record */
** /*K03K*/                       {gprun.i ""sofsde.p"" "(input recid(ship_line))"}
**
**                            /* DELETE RECORD */
**                            delete ship_line.
**
**                         end.
**
**
**                         if sel_var_del = 1 then do:
**
** /*K03S*/                   find abs_parent_buff where
** /*K03S*/                        recid(abs_parent_buff) = parent_abs_recid
** /*K03S*/                        no-lock.
** /*K03S*/                   for each absc_det
** /*K03S*/                   where absc_abs_id = abs_parent_buff.abs_id
** /*K03S*/                   exclusive-lock:
** /*K03S*/                       delete absc_det.
** /*K03S*/                   end.
**
**                            for each ship_line
**                            where ship_line.abs_shipfrom = ship_from
**                            and ship_line.abs_shipto begins tmp_prefix
**                            exclusive-lock:
** /*K003*/                       if ship_line.abs_par_id begins "i" then
** /*K003*/                           del_lad = yes.
** /*K003*/                       else del_lad = no.
**
** /*K03S*  Moved code outside the 'for each ship_line' loop
** ./*K003*/                       find abs_parent_buff where
** ./*K003*/                            recid(abs_parent_buff) = parent_abs_recid
** ./*K003*/                            no-lock.
** ./*K003*/                       for each absc_det
** ./*K003*/                       where absc_abs_id = abs_parent_buff.abs_id
** ./*K003*/                       exclusive-lock:
** ./*K003*/                           delete absc_det.
** ./*K003*/                       end.
** .*K03S*/
**
**                            /* SET GLOBAL_DB USING ABS_SITE */
** /*K003*/                      new_site = ship_line.abs_site.
** /*K003*/                       {gprun.i ""gpalias.p""}
**
**                            /* SWITCH TO THE INVENTORY SITE */
** /*K003*/                       if so_db <> global_db then do:
** /*K003*/                          {gprun.i ""gpalias2.p""
** /*K003*/                               "(ship_line.abs_site, output errornum)"}
** /*K003*/                          if errornum <> 0 and errornum <> 9 then do:
**                                      /* DATABASE # IS NOT CONNECTED */
** /*K003*/                             {mfmsg03.i 2510 4
**                                             "'For Remote Inventory'" """" """"}
** /*K003*/                             undo DEL_LOOP, retry DEL_LOOP.
** /*K003*/                          end.
** /*K003*/                       end.
**
** /*K003*/                   /* DELETE ALLOCATION */
** /*K003*/                      {gprun.i ""soitallb.p""
**                                    "(input ship_line.abs_order,
**                                     input ship_line.abs_line,
**                                     input ship_line.abs_item,
**                                     input ship_line.abs_site,
**                                     input ship_line.abs_loc,
**                                     input ship_line.abs_lot,
**                                     input ship_line.abs_ref,
**                                     input - ship_line.abs_qty ,
**                                     input del_lad,
**                                     output avail_qty,
**                                     output pick_qty)"}
**
** /*K003*/                      del_lad = no.
**                               /* SWITCH BACK TO THE SALES ORDER DATABASE */
** /*K003*/                      if so_db <> global_db then do:
** /*K003*/                        {gprun.i ""gpalias3.p""
** /*K003*/                                 "(so_db, output errornum)"}
** /*K003*/                        if errornum <> 0 and errornum <> 9 then do:
**                                    /* DATABASE # IS NOT CONNECTED */
** /*K003*/                           {mfmsg03.i 2510 4
**                                   "'For Sales Orders'" """" """"}
** /*K003*/                           undo DEL_LOOP, retry DEL_LOOP.
** /*K003*/                        end.
** /*K003*/                      end.
**
**
** /*K0CZ*                      UPDATE ALLOCATION, PICK, AND SEND CMF MSG  */
** /*K0CZ*/                      find sod_det where sod_nbr = ship_line.abs_order
** /*K0CZ*/                      and sod_line = integer (ship_line.abs_line)
** /*K0CZ*/                      no-lock no-error.
** /*K0CZ*/                      if available sod_det and sod_cfg_type <> "2"
** /*K0CZ*/                      and sod_fa_nbr = "" then
** /*K0CZ*/                      do:
** /*K0CZ*/                         {gprun.i ""sosopka2.p""
**                                         "(input ship_line.abs_order,
**                                           input integer (ship_line.abs_line),
**                                           input - ship_line.abs_qty)"}
** /*K0CZ*/                         find so_mstr where so_nbr = sod_nbr no-lock no-error.
** /*K0DH* /*K0CZ*/                 if available so_mstr and not so_primary then */
** /*K0DH*/                         if available so_mstr and so_secondary then
** /*K0CZ*/                         run create-so-cmf (input recid (sod_det)).
** /*K0CZ*/                      end.
**
**
** /*K005*/                      /* DELETE ABSR_DET RECORDS */
** /*K005*/                      if ship_line.abs_id begins "i" then
** /*K005*/                      do:
** /*K005*/                         {gprun.i ""rcdlabsr.p""
**                                     "(input recid(ship_line))"}
** /*K005*/                      end.
**
** /*K03K*/                      /* Delete custom shipper document information
**                                  associated with the record */
** /*K03K*/                      {gprun.i ""sofsde.p"" "(input recid(ship_line))"}
**
**                               delete ship_line.
**
**                            end.
**
**                            assign
**                            abs_recid = ?
**                            save_frame_line = 1.
**
**                         end.
**
**                         /* REPAINT THE SCREEN WITH NEW RECORDS */
**                         refresh = true.
**
**                      end. /* IF VALID_ENTRY */
**K0J7* end of moved code *************************************************************/

                  end. /* IF LASTKEY = KEYCODE F5 */

/*J22Y*/       end. /* IF NOT BATCHRUN */

                  /* HANDLE F3 KEY */
/*J22Y*/          /* ALWAYS ENTER ADD MODE WHEN BATCH-RUN */

/*J22Y**          if lastkey = keycode("F3") */
/*J22Y*/          if batchrun
/*J22Y*/          or lastkey = keycode("F3")
/*G2M9*/          or lastkey = keycode("PF3")
                  or lastkey = keycode("CTRL-T") then do:
/*K0J7*/            assign next_editloop = no
/*J22Y** /*K0J7*/          next_mainloop = no. */
/*J22Y*/                   next_mainloop = no
/*J22Y*/                   leave_editloop = no.

/*J22Y*/            /* ADDED OUTPUT PARAMETER leave_editloop */
/*K0J7*/            run add_proc (output next_editloop, output next_mainloop, output leave_editloop).
/*K0J7*/            if next_editloop then next editloop.
/*K0J7*/            if next_mainloop then next mainloop.
/*J22Y*/            if leave_editloop then leave editloop.
/*K0J7* the following code was moved to internal procedure add_proc **********************
** /*K04X*/             if not v_editall then do:
** /*K04X*/                {mfmsg.i 5811 3}
** /*K04X*/                /* Selection only available for */
** /*K04X*/                /* unconfirmed, non-SO shippers */
** /*K04X*/                next editloop.
** /*K04X*/             end.  /* if not v_editall */
**
**                   /* ALLOW ADDING COMPONENT TO A KIT ITEM  */
** /*K003*              if ship_line.abs_id begins "i" then do:             */
** /*K003*/             if ship_line.abs_id begins "i" and
** /*K003*/             (not available sod_det or
** /*K003*/             ((sod_cfg_type <> "2" or sod_type <> "" or
** /*K003*/               ship_line.abs_item <> sod_part))) then do:
**                         {mfmsg.i 13 3} /* NOT A VALID SELECTION */
**                        next EDITLOOP.
**                      end.
**
**                      color display input first_column with frame k.
**
**                      /* DISPLAY F3 ADD OPTIONS FRAME */
**                      hide frame sample no-pause.
**                      view frame m.
**
**                      assign
**                      valid_entry = false
**                      sel_var_add = 1
**                      save_frame_line = frame-line(k).
**
**                      /* GET USER SELECTION */
**                      GET_SELECTION_2:
**                      do on endkey undo GET_SELECTION_2, leave GET_SELECTION_2
**                      on error undo GET_SELECTION_2, retry GET_SELECTION_2:
**
**                         /* PLEASE SELECT A FUNCTION */
** /*V8-*/
**                         {mfmsg01.i 39 1 sel_var_add}
** /*V8+*/
** /*V8!                   {mfmsg01c.i 39 1 sel_var_add}   */
**
**                         if (sel_var_add < 1 or sel_var_add > 3)
** /*K003*/                or (sel_var_add <> 1 and ship_line.abs_id begins "i")
**                         then do:
**
**                            {mfmsg.i 13 3} /* NOT A VALID CHOICE */
**                            undo GET_SELECTION_2, retry GET_SELECTION_2.
**                         end.
**
**                         valid_entry = true.
**                      end.
**
**                      /* HIDE FRAMES FOR ADD */
**                      hide frame m no-pause.
**                      hide frame sample no-pause.
**                      hide frame k no-pause.
**
**                      /* PROCESS F3 ADD SELECTION */
**                      if valid_entry then do:
**
**                         /*** TRUTH TABLE - SEL_VAR */
**                         /*               1  2  3   */
**                         /*                         */
**                         /* ADD_ITEM      T  F  T   */
**                         /* ADD_CONTAINER F  T  T   */
**                         /* ADD_PARENT    F  F  T   */
**                         /***************************/
**
**                         assign
**                         abs_recid = recid(ship_line)
**                         add_container = true
**                         add_item = true
**                         add_parent_container = true.
**
**                         /* ADD AN ITEM RECORD */
**                         if sel_var_add = 1 then do:
**
**                            assign
**                            add_container = false
**                            add_parent_container = false.
**
**                         end.
**
**                         /* ADD A CONTAINER RECORD */
**                         if sel_var_add = 2 then do:
**
**                            assign
**                            add_item = false
**                            add_parent_container = false.
**
**                         end.
**
**                         create_recs = true.
**                         next MAINLOOP.
**                      end. /* IF VALID ENTRY */
**K0J7* end of moved code **************************************************************/
                   end. /* LASTKEY = KEYCODE F3 */

               end. /* EDITLOOP */

               /* CLEAN UP RECORDS */

/*J35D*/       /* MOVED THE FOLLOWING CODE TO INTERNAL PROCEDURE P_CLEAN_UP */
/*J35D*/       /* TO AVOID ACTION SEGMENT ERRORS                            */
/*J35D* **BEGIN DELETE**
 *           for each ship_line where ship_line.abs_shipfrom = ship_from
 *              and ship_line.abs_shipto begins tmp_prefix exclusive-lock:
 *                 ship_line.abs_shipto = ship_line.abs__qad05.
 *           end.
 *J35D* **END DELETE** */
/*J35D*/       run p_clean_up ( input ship_from , input tmp_prefix ).

               if lastkey = keycode("F4") or
/*J0JC*/       keyfunction(lastkey) = "END-ERROR" or
/*J22Y*/       keyfunction(lastkey) = "ENDKEY" or
/*J22Y*/       ( batchrun and keyfunction(lastkey) = "." ) or
               lastkey = keycode("CTRL-E") then leave MAINLOOP.

/*K003*            end. /* SCOPE_TRANS */    */

         end. /* MAINLOOP */

         hide frame k no-pause.
         hide frame sample no-pause.

         /* END OF MAIN PROCEDURE BODY */

/*K04X*/ PROCEDURE ip_editall:

/*K04X*/    /* Set flag determining whether non-informational fields (any */
/*K04X*/    /* field actually used during confirmation, such as quantities, */
/*K04X*/    /* site, sales order #, etc) are allowed to be edited.  Only */
/*K04X*/    /* purely informational fields (such as comments) may be editing */
/*K04X*/    /* for non-SO shippers or confirmed SO shippers. */

/*K04X*/    /* PARAMETERS */
/*K04X*/    define input  parameter i_recid   as recid             no-undo.
/*K04X*/    define output parameter o_editall as logical initial true no-undo.

/*K04X*/    /* LOCAL VARIABLES */
/*K04X*/    define variable v_par_recid as recid no-undo.

/*K04X*/    /* BUFFERS */
/*K04X*/    define buffer b_abs_mstr for abs_mstr.

/*K04X*/    /* PROCEDURE BODY */

/*K04X*/    /* Find top-level parent shipper or preshipper */
/*K04X*/    {gprun.i
               ""gpabspar.p""
               "(i_recid, 'PS', false, output v_par_recid)" }

/*K04X*/    find b_abs_mstr no-lock where recid(b_abs_mstr) eq v_par_recid
/*K04X*/       no-error.
/*N0WX*/    {&RCSHWBB-P-TAG10}
/*K04X*/    if available b_abs_mstr             and
/*K04X*/       (b_abs_mstr.abs_id begins "s" or
/*K04X*/        b_abs_mstr.abs_id begins "p")   and
/*K04X*/       (can-find
/*K04X*/          (im_mstr where
/*K04X*/             im_inv_mov eq b_abs_mstr.abs_inv_mov and
/*K04X*/             im_tr_type ne "ISS-SO") or
/*K04X*/        substring(b_abs_mstr.abs_status,2,1) eq "y")
/*K04X*/       then o_editall = false.
/*N0WX*/    {&RCSHWBB-P-TAG11}
/*K04X*/       else o_editall = true.

/*K04X*/ END PROCEDURE.  /* ip_editall */

/*K003*/ {gpnrseq.i}

/*K022*  INTERNAL PROCEDURE create-so-cmf */
/*K022*/ {rccmf.i}

/*K0J7* added delete_proc internal procedure */
  PROCEDURE delete_proc:
    define output parameter next_editloop as logical no-undo.

    DEL_LOOP:
    do on endkey undo DEL_LOOP, leave DEL_LOOP
    on error undo DEL_LOOP, retry DEL_LOOP:
      if not v_editall then do:
        {mfmsg.i 5811 3}
        /* Selection only available for */
        /* unconfirmed SO shippers */
        next_editloop = yes.  return.
      end.  /* if not v_editall */

      save_frame_line = frame-line(k).
      color display input first_column with frame k.

      /* DISPLAY F5 SELECTION FRAME */
      hide frame sample no-pause.
      view frame m1.

/*N0NH Begin Add*/
      display del-form-line-1
                  del-form-line-2
                  del-form-line-3
                  del-form-line-4
                  del-form-line-5
                  with frame m1.
/*N0NH End Add*/

      assign
        sel_var_del = 0
        valid_entry = false.

      GET_SELECTION:
      do on endkey undo GET_SELECTION, leave GET_SELECTION
      on error undo GET_SELECTION, retry GET_SELECTION:

        /* PLEASE ENTER A SELECTION */
/*V8-*/
        {mfmsg01.i 39 1 sel_var_del}
/*V8+*/
/*V8!   {mfmsg01c.i 39 1 sel_var_del}   */

        if sel_var_del < 1 or sel_var_del > 5 then do:
          {mfmsg.i 13 3} /* NOT A VALID CHOICE */
          undo GET_SELECTION, retry GET_SELECTION.
        end.

        if ship_line.abs_id begins "i" and
          (sel_var_del <> 1 and sel_var_del <> 2) then do:
          {mfmsg.i 761 3} /* THIS OPTION NOT ALLOWED FOR .. */
          undo GET_SELECTION, retry GET_SELECTION.
        end.

        if sel_var_del = 1 then do:
          find abs_parent_buff where recid(abs_parent_buff) = parent_abs_recid
            no-lock.
          if abs_parent_buff.abs_nr_id <> "" then do:
            run chk_delnbr
              (input abs_parent_buff.abs_nr_id,
               output can_discard,
               output errorst,
               output errornum).
            if errorst then do:
              {mfmsg.i errornum 4}
              undo GET_SELECTION, retry GET_SELECTION.
            end. /* errorst */

            msgnum = if abs_parent_buff.abs_id begins "p"
                     then 5944
                     else 5946.

            if not can_discard then do:
              {mfmsg.i msgnum 4}
              /*DELETION PROHIBITED, GAPS IN (PRE-)SHIPPER SEQUENCE
                NOT PERMITTED*/
              undo GET_SELECTION, retry GET_SELECTION.
            end. /* not can_discard*/
          end. /* if abs_parent_buff.abs_nr_id <> "" */

          if abs_parent_buff.abs_preship_nr_id <> "" then do:
            run chk_delnbr
              (input abs_parent_buff.abs_preship_nr_id,
               output can_discard,
               output errorst,
               output errornum).
            if errorst then do:
              {mfmsg.i errornum 4}
              undo GET_SELECTION, retry GET_SELECTION.
            end. /* errorst */

            if not can_discard then do:
              {mfmsg.i 5944 4}
               /*DELETION PROHIBITED, GAPS IN PRE-SHIPPER SEQUENCE
                 NOT PERMITTED*/
              undo GET_SELECTION, retry GET_SELECTION.
            end. /* not can_discard */
          end. /* if abs_parent_buff.abs_preship_nr_id <> "" */
        end. /* if sel_var_del = 1 */

/*J246*/ /* DELETE RESTRICTION FOR PRE-SHIPPER/SHIPPER   */
/*J246*/ /* ON SELECTING OPTION 2 TO 5                   */

/*J246*/ if (sel_var_del >= 2 and sel_var_del <= 5)
/*J246*/    and ((ship_line.abs_id >= "p" and
/*J246*/         ship_line.abs_id <= "p" + hi_char) or
/*J246*/        (ship_line.abs_id >= "s" and
/*J246*/         ship_line.abs_id <= "s" + hi_char)) then do:
/*J246*/    /* THIS OPTION IS NOT ALLOWED FOR THE SELECTED RECORDS */
/*J246*/    {mfmsg.i 761 3}
/*J246*/    undo GET_SELECTION, retry GET_SELECTION.
/*J246*/ end. /* END OF if sel_var_del >= 2 and sel_var_del <= 5 */

        /* CHECK FOR ORPHAN ITEM RECORDS */
        if ship_line.abs_par_id = ""
          and sel_var_del = 2 or sel_var_del = 4
        then do:
          for each abs_mstr
            where abs_mstr.abs_shipfrom = ship_from
              and abs_mstr.abs_par_id = ship_line.abs_id
          no-lock:
            if abs_mstr.abs_id begins "i" then do:
              /* CANNOT ORPHAN AN ITEM RECORD */
              {mfmsg.i 762 3}
              undo GET_SELECTION, retry GET_SELECTION.
            end. /* if abs_id begins i */
           end. /* for each abs_mstr */
        end. /* if par_id = "" and 2 or 4 */

        del-yn = false.
        /* REMOVE / DELETE RECORD, PLEASE CONFIRM */
        {mfmsg01.i 11 1 del-yn}
        if not del-yn then
          undo GET_SELECTION, leave GET_SELECTION.
        valid_entry = true.
      end. /* GET SELECTION */

/*L0M0*/ /* GENERAL ALLOCATE PICKED QUANTITY ? */
/*L0M0*/ if sel_var_del >= 1 and
/*L0M0*/    sel_var_del <= 5 and
/*L0M0*/    del-yn  then
/*L0M0*/ do:
/*L0M0*/    {mfmsg01.i 3411 1 l_updalloc }
/*L0M0*/    if not l_updalloc then
/*L0M0*/       l_delproc = yes .
/*L0M0*/ end. /* IF SEL_VAR_DEL */

      /* HIDE DELETE FRAME */
      hide frame m1 no-pause.
      view frame sample.

      /* HANDLE DELETE SELECTION */
      if valid_entry then do:
        delete_recid = recid(ship_line).
        kit_comp =  (ship_line.abs_par_id begins  "i").
        /* SUBTRACT WEIGHT FROM PARENTS */
        if sel_var_del <> 1 then do:
/*K0JC*/  assign original_nwt = ship_line.abs_nwt
/*K0JC*/         original_gwt = ship_line.abs_gwt.
/*J2M7*/  {absupack.i  "ship_line" 26 22 "l_abs_tare_wt" }
/*J2M7**  if (ship_line.abs_id begins "i") then  */
/*J2M7**    nwt_old = ship_line.abs_nwt * -1.  */
/*J2M7**  else do:                             */
        if sel_var_del = 2 or sel_var_del = 4 then
/*J2M7*/       assign l_twt_old = l_abs_tare_wt * -1
             nwt_old = ship_line.abs_nwt * -1.
/*J2M7**       else nwt_old = ship_line.abs_gwt * -1. */
/*J2M7*/    else
/*J2M7*/       assign
/*J2M7*/          l_twt_old = (ship_line.abs_gwt - ship_line.abs_nwt) * -1
/*J2M7*/          nwt_old = ship_line.abs_nwt * -1.
/*J2M7**  end. /* else do */   */

/*J2M7*/  if (ship_line.abs_id begins "i" and sel_var_del = 2)
/*J2M7*/     or (sel_var_del = 3 or sel_var_del = 5 ) then do:
/*J2M7*/     /* PASSING "YES" TO THIRD PARAMETER CHANGE_NET */
          {gprun.i ""icshnwt.p""
                   "(input recid(ship_line),
                     input nwt_old,
             input yes,
                     input ship_line.abs_wt_um)"}
/*J2M7*/  end. /* IF SHIP_LINE.ABS_ID BEGINS "I" ...*/

/*J2M7*/    {gprun.i ""icshnwt.p""
             "(input recid(ship_line),
               input l_twt_old,
                       input no,
               input ship_line.abs_wt_um)"}

        end. /* SEL_VAR_DEL <> 1 */

        /* REMOVE CONTAINER RECORD OR DELETE CONTAINER RECORD */
        if (sel_var_del = 2 or sel_var_del = 4)
          and ship_line.abs_id begins "c"
        then do:
          for each abs_mstr
            where abs_mstr.abs_shipfrom = ship_from
              and abs_mstr.abs_par_id = ship_line.abs_id
          exclusive-lock:

            /* CHANGE PARENT POINTERS OF CHILD RECORDS */
            abs_mstr.abs_par_id = ship_line.abs_par_id.
            abs_mstr.abs__qad06 =
              string(integer(abs_mstr.abs__qad06) - 1,"9").

            /* ADJUST LEVELS OF CHILD RECORDS */
            {gprun.i ""rcctwbu3.p""
                      "(input recid(abs_mstr))"}
          end. /* for each abs_mstr */
          /* Delete custom shipper document information
             associated with the record */
          {gprun.i ""sofsde.p"" "(input recid(ship_line))"}
        end. /* IF SEL_VAR_DEL = 2 OR 4 */

        /* REMOVE STRUCTURE OR DELETE STRUCTURE */
        if sel_var_del = 3 or sel_var_del = 5 then do:

          /* SET ALL CHILD RECORD SHIPTO'S TO ""      */
          /* FOR DELETES WILL ALLOW FIND NEXT TO FIND */
          /* THE CORRECT RECORD */
          {gprun.i ""rcctwbu2.p"" "(delete_recid)"}.
        end. /* if sel_var_del = 3 or 5 */

        if sel_var_del = 4 or sel_var_del = 5 then
/*K0JC*/ do:
/*K0JC*/   assign
/*K0JC*/     ship_line.abs_nwt = original_nwt
/*K0JC*/     ship_line.abs_gwt = original_gwt
          ship_line.abs_par_id = "".
/*K0JC*/ end.

        /* REMOVE RECORD - REMOVE STRUCTURE */
        if sel_var_del = 4 or sel_var_del = 5 then
          ship_line.abs_shipto = ship_line.abs__qad05.

        /* CHECK FOR NEXT RECORD */
        find next ship_line
          where ship_line.abs_shipfrom = ship_from
          and ship_line.abs_shipto begins tmp_prefix
        no-lock no-error.

        if available ship_line then
          abs_recid = recid(ship_line).

        /* IF NO NEXT RECORD THEN FIND PREVIOUS RECORD */
        else do:
          find ship_line
            where recid(ship_line) = delete_recid
          no-lock no-error.

          find prev ship_line
            where ship_line.abs_shipfrom = ship_from
            and ship_line.abs_shipto begins tmp_prefix
          no-lock no-error.

          if available ship_line then do:
            abs_recid = recid(ship_line).
            if save_frame_line > 1 then
              save_frame_line = save_frame_line - 1.
          end. /* available ship_line */

          /* NO RECORDS LEFT SO RESET */
          else do:
            assign
              abs_recid = ?
              save_frame_line = 1.
          end. /* not available ship_line */
        end. /* ELSE DO */

/*J37V*/ if sel_var_del = 5 then do:

/*J37V*/    /* DELETE ALLOCATIONS AND RESET THE SHIPPER SALES ORDER, */
/*J37V*/    /* LINE AND PICK QTY.                                    */
/*L0M0*/    /* ADDED FOURTH INPUT PARAMETER L_DELPROC                */
/*J37V*/    {gprun.i ""rcctwbu1.p"" "(input delete_recid,
                                      input yes,
                                      input no,
                                      input l_delproc,
                                      output undotran)"}
/*J37V*/    if undotran then
/*J37V*/       undo DEL_LOOP, retry DEL_LOOP.
/*J37V*/ end. /* IF SEL_VAR_DEL = 5 */

        /* HANDLE DELETES */
        if sel_var_del = 2 or sel_var_del = 3 then do:

          find ship_line
          where recid(ship_line) = delete_recid
          exclusive-lock no-error.

          /* DELETE ABSR_DET RECORDS */
          if ship_line.abs_id begins "i" then
          do:
            {gprun.i ""rcdlabsr.p"" "(input delete_recid)"}

/*N004*/    /* DELETE SEQUENCES */
/*N004*/    run delete_sequences
/*N004*/            (input delete_recid).
          end.

          /* IF DELETE STRUCTURE THEN DELETE ALL CHILDREN */
          if sel_var_del = 3 then do:

            /* DELETE ALL CHILD RECORDS */
/*J37V*/    /* ADDED SECOND AND THIRD INPUT PARAMETERS ADJUST */
/*J37V*/    /* ALLOCATION = YES & DELETE = YES                */
/*L0M0*/    /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
            {gprun.i ""rcctwbu1.p"" "(input delete_recid,
                                      input yes,
                                      input yes,
                                      input l_delproc,
                                      output undotran)"}
            if undotran then undo DEL_LOOP, retry DEL_LOOP.

          end.

          /* IF DELETE KIT PARENT THEN DELETE ALL COMPONENTS */
          if sel_var_del = 2 and
            ship_line.abs_id begins "i"
          then do:
            /* CAN'T CHECK sod_det, SO MAY HAVE BEEN DELETED */
            find first abs_mstr
              where abs_mstr.abs_shipfrom = ship_from
                and abs_mstr.abs_par_id = ship_line.abs_id
            no-lock no-error.
            if available abs_mstr then do:
              /* DELETE ALL COMPONENT RECORDS */
/*J37V*/    /* ADDED SECOND AND THIRD INPUT PARAMETERS ADJUST */
/*J37V*/    /* ALLOCATION = YES & DELETE = YES                */
/*L0M0*/    /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
              {gprun.i ""rcctwbu1.p"" "(input delete_recid,
                                        input yes,
                                        input yes,
                                        input l_delproc,
                                        output undotran)"}
              if undotran then undo DEL_LOOP, retry DEL_LOOP.
            end. /* available abs_mstr */

            del_lad = kit_comp.

            /* SET GLOBAL_DB USING ABS_SITE */
            new_site = ship_line.abs_site.
            {gprun.i ""gpalias.p""}

            /* SWITCH TO THE INVENTORY SITE */
            if so_db <> global_db then do:
              {gprun.i ""gpalias2.p""
                        "(ship_line.abs_site, output errornum)"}
              if errornum <> 0 and errornum <> 9 then do:
                /* DATABASE # IS NOT CONNECTED */
/*M110**        {mfmsg03.i 2510 4 {&rcshwbb_p_4} """" """"} */
/*M110*/        /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/        run p-pxmsg (input 2510,
                             input 4,
                             input l_msgar1[2]).
                undo DEL_LOOP, retry DEL_LOOP.
              end. /* if errornum <> 0 and 9 */
            end. /* if so_db <> global_db */
/*J2CQ**    ** CALL TO SOITALLB.P HAS BEEN REPLACED BY CALL TO SOITALLD.P ** */
/*J2CQ** BEGIN DELETE **
 * /*K18W*/   /* PASSED PARAMETER abs__dec01 INSTEAD OF abs_qty TO soitallb.p */
 * /*K18W*/   /* PASSED PARAMETER tmp_qty INSTEAD OF pick_qty TO soitallb.p   */
 *            {gprun.i ""soitallb.p""
 *                      "(input ship_line.abs_order,
 *                       input ship_line.abs_line,
 *                       input ship_line.abs_item,
 *                       input ship_line.abs_site,
 *                       input ship_line.abs_loc,
 *                       input ship_line.abs_lot,
 *                       input ship_line.abs_ref,
 *                       input - ship_line.abs__dec01 ,
 *                       input del_lad,
 *                       output avail_qty,
 *                       output tmp_qty)"}
 *J2CQ** END DELETE ** */
/*K1NF** BEGIN DELETE **
 * /*J2CQ*/     {gprun.i ""soitalld.p""
 *                     "(input ship_line.abs_order,
 *                       input ship_line.abs_line,
 *                       input ship_line.abs_item,
 *                       input ship_line.abs_site,
 *                       input ship_line.abs_loc,
 *                       input ship_line.abs_lot,
 *                       input ship_line.abs_ref,
 *                       input - ship_line.abs__dec01,
 *                       input - ship_line.abs_qty,
 *                        input qty_old,
 *                       input del_lad,
 *                       output adj_qty,
 *                       output undotran)"}
 *K1NF** END DELETE ** */

/*J2MH*/       /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
/*J2TP*/       /* ADDED INPUT PARAMETER -SHIP_LINE.ABS_QTY */
/*L0M0*/       /* ADDED ELEVENTH INPUT PARAMETER L_DELPROC */
/*K1NF*/       {gprun.i ""soitallb.p""
                        "(input ship_line.abs_order,
                          input ship_line.abs_line,
                          input ship_line.abs_item,
                          input ship_line.abs_site,
                          input ship_line.abs_loc,
                          input ship_line.abs_lot,
                          input ship_line.abs_ref,
                          input - ship_line.abs_qty *
                                decimal(ship_line.abs__qad03),
                          input - l_abs_pick_qty *
                                decimal(ship_line.abs__qad03),
                          input del_lad,
                          input l_delproc,
                          output avail_qty,
                          output tmp_qty)"}

            /* SWITCH BACK TO THE SALES ORDER DATABASE */

            /* SWITCH BACK TO THE SALES ORDER DATABASE */
            if so_db <> global_db then do:

/*J394*/       /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK IN */
/*J394*/       /* REMOTE DATABASE                               */
/*J394*/       for first sod_det

/*K20P** BEGIN DELETE SECTION **
 * /*J394*/ fields (sod_cfg_type sod_contr_id sod_fa_nbr sod_line
 *                  sod_nbr sod_part sod_qty_all sod_qty_ord sod_qty_pick
 *                  sod_qty_ship sod_sched sod_type sod_um_conv) where
 * /*J394*/         sod_nbr = ship_line.abs_order and
 * /*J394*/         sod_line = integer (ship_line.abs_line)
 * /*J394*/          no-lock:
 *K20P** END DELETE SECTION */

/*K20P*/          where sod_nbr = ship_line.abs_order and
/*K20P*/                sod_line = integer (ship_line.abs_line)
/*K20P*/                exclusive-lock:
/*J394*/       end. /* FOR FIRST SOD_DET */

/*J394*/       if available sod_det and sod_cfg_type <> "2"
/*K21N** /*J394*/ and sod_fa_nbr = ""    */
/*J394*/       then do:
/*L0M0*/          /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
/*J394*/          {gprun.i ""sosopka2.p""
                           "(input ship_line.abs_order,
                             input integer (ship_line.abs_line),
                             input - l_abs_pick_qty *
                                  decimal(ship_line.abs__qad03),
                             input l_delproc)"}
/*K20P*/ if sod_sched then sod_pickdate = ?.
/*J394*/       end. /* IF AVAILABLE SOD_DET */

              {gprun.i ""gpalias3.p""
                        "(so_db, output errornum)"}
              if errornum <> 0 and errornum <> 9 then do:
                /* DATABASE # IS NOT CONNECTED */
/*L042**        {mfmsg03.i 2510 4 "'For Sales Orders'" """" """"}  */
/*M110** /*L042*/ {mfmsg03.i 2510 4 {&rcshwbb_p_3} """" """"}      */
/*M110*/        /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/        run p-pxmsg (input 2510,
                             input 4,
                             input l_msgar1[1]).
                undo DEL_LOOP, retry DEL_LOOP.
              end. /* errornum <> 0 and 9 */
            end. /* if so_db <> global_db */

            find sod_det where sod_nbr = ship_line.abs_order
              and sod_line = integer (ship_line.abs_line)
            no-lock no-error.
            if available sod_det and sod_cfg_type <> "2"
/*K21N**       and sod_fa_nbr = ""               */
            then do:
              /* UPDATE DETAIL QTY ALL, QTY PICK */
/*K18W*/   /* PASSED PARAMETER abs__dec01 INSTEAD OF abs_qty TO sosopka2.p */
/*K1NF*/   /* REPLACE SHIP_LINE.ABS__DEC01 WITH L_ABS_PICK_QTY*/
/*J2MH*/   /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
/*L0M0*/   /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
             {gprun.i ""sosopka2.p""
                       "(input ship_line.abs_order,
                         input integer (ship_line.abs_line),
                         input - l_abs_pick_qty * decimal(ship_line.abs__qad03),
                         input l_delproc
                          )"}

/*K20P*/ if sod_sched then sod_pickdate = ?.

              find so_mstr where so_nbr = sod_nbr no-lock no-error.
              if available so_mstr and so_secondary then
                run create-so-cmf (input recid (sod_det)).
            end. /* available sod_det and sod_cfg ... */

            del_lad = no.

          end. /* if sel_var_del = 2 and id beings i */

          /* Delete custom shipper document information
             associated with the record */
          {gprun.i ""sofsde.p"" "(input recid(ship_line))"}

          /* DELETE RECORD */

/*L13N*/  for first clc_ctrl
/*L13N*/     fields(clc_lotlevel)
/*L13N*/     no-lock:
/*L13N*/  end. /* FOR FIRST clc_ctrl */

/*L13N*/  if  available clc_ctrl
/*L13N*/  then do :

/*L13N*/     if clc_lotlevel = 1
/*L13N*/     then do :
/*L13N*/        for each lotw_wkfl
/*L13N*/           where lotw_mfguser = mfguser
/*L13N*/             and lotw_lotser  = ship_line.abs_lotser
/*L13N*/             and lotw_part    = ship_line.abs_item
/*L13N*/           exclusive-lock:
/*L13N*/           delete lotw_wkfl.
/*L13N*/        end. /* FOR EACH lotw_wkfl */
/*L13N*/     end.  /* IF clc_lotlevel */

/*L13N*/     if clc_lotlevel = 2
/*L13N*/     then do:
/*L13N*/        for each lotw_wkfl
/*L13N*/           where lotw_mfguser = mfguser
/*L13N*/             and lotw_lotser  = ship_line.abs_lotser
/*L13N*/           exclusive-lock:
/*L13N*/           delete lotw_wkfl.
/*L13N*/        end. /* FOR EACH lotw_wkfl */
/*L13N*/     end. /* IF clc_lotlevel */

/*L13N*/  end. /* IF AVAILABLE clc_ctrl */


          delete ship_line.

        end. /* if sel_var_del = 2 or 3 */

        if sel_var_del = 1 then do:

          find abs_parent_buff where
            recid(abs_parent_buff) = parent_abs_recid
          no-lock.
          for each absc_det
            where absc_abs_id = abs_parent_buff.abs_id
          exclusive-lock:
            delete absc_det.
          end. /* for each */

          for each ship_line
            where ship_line.abs_shipfrom = ship_from
              and ship_line.abs_shipto begins tmp_prefix
          exclusive-lock:
            if ship_line.abs_par_id begins "i" then
              del_lad = yes.
            else del_lad = no.

/*J2MH*/    {absupack.i  "ship_line" 3 22 "l_abs_pick_qty" }

            /* SET GLOBAL_DB USING ABS_SITE */
            new_site = ship_line.abs_site.
            {gprun.i ""gpalias.p""}

            /* SWITCH TO THE INVENTORY SITE */
            if so_db <> global_db then do:
              {gprun.i ""gpalias2.p""
                        "(ship_line.abs_site, output errornum)"}
               if errornum <> 0 and errornum <> 9 then do:
                /* DATABASE # IS NOT CONNECTED */
/*L042**        {mfmsg03.i 2510 4 "'For Remote Inventory'" """" """"}   */
/*M110** /*L042*/ {mfmsg03.i 2510 4 {&rcshwbb_p_4} """" """"}           */
/*M110*/        /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/        run p-pxmsg (input 2510,
                             input 4,
                             input l_msgar1[2]).
                undo DEL_LOOP, retry DEL_LOOP.
               end. /* errornum <> 0 or 9 */
            end. /* if so_db <> global_db */

            /* DELETE ALLOCATION */
/*J2CQ**    ** CALL TO SOITALLB.P HAS BEEN REPLACED BY CALL TO SOITALLD.P ** */
/*J2CQ** BEGIN DELETE **
 * /*K18W*/   /* PASSED PARAMETER abs__dec01 INSTEAD OF abs_qty TO soitallb.p */
 * /*K18W*/   /* PASSED PARAMETER tmp_qty INSTEAD OF pick_qty TO soitallb.p   */
 *           {gprun.i ""soitallb.p""
 *                "(input ship_line.abs_order,
 *                 input ship_line.abs_line,
 *                 input ship_line.abs_item,
 *                 input ship_line.abs_site,
 *                 input ship_line.abs_loc,
 *                 input ship_line.abs_lot,
 *                 input ship_line.abs_ref,
 *                 input - ship_line.abs__dec01 ,
 *                 input del_lad,
 *                 output avail_qty,
 *                 output tmp_qty)"}
 *J2CQ** END DELETE ** */
/*K1NF** BEGIN DELETE **
 * /*J2CQ*/    {gprun.i ""soitalld.p""
 *                    "(input ship_line.abs_order,
 *                      input ship_line.abs_line,
 *                      input ship_line.abs_item,
 *                      input ship_line.abs_site,
 *                      input ship_line.abs_loc,
 *                      input ship_line.abs_lot,
 *                      input ship_line.abs_ref,
 *                      input - ship_line.abs__dec01,
 *                      input - ship_line.abs_qty,
 *                      input qty_old,
 *                      input del_lad,
 *                      output adj_qty,
 *                      output undotran)"}
 *K1NF** END DELETE ** */

/*J2MH*/        /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
/*J2TP*/        /* ADDED INPUT PARAMETER -SHIP_LINE.ABS_QTY */
/*L0M0*/        /* ADDED ELEVENTH INPUT PARAMETER L_DELPROC */
/*K1NF*/       {gprun.i ""soitallb.p""
                        "(input ship_line.abs_order,
                          input ship_line.abs_line,
                          input ship_line.abs_item,
                          input ship_line.abs_site,
                          input ship_line.abs_loc,
                          input ship_line.abs_lot,
                          input ship_line.abs_ref,
                          input - ship_line.abs_qty *
                                  decimal(ship_line.abs__qad03),
                          input - l_abs_pick_qty *
                                  decimal(ship_line.abs__qad03),
                          input del_lad,
                          input l_delproc,
                          output avail_qty,
                          output tmp_qty)"}

            del_lad = no.

            /* SWITCH BACK TO THE SALES ORDER DATABASE */
            if so_db <> global_db then do:

/*J394*/       /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK IN */
/*J394*/       /* REMOTE DATABASE                               */
/*J394*/       for first sod_det

/*K20P** BEGIN DELETE SECTION **
 * /*J394*/ fields (sod_cfg_type sod_contr_id sod_fa_nbr sod_line
 *                 sod_nbr sod_part sod_qty_all sod_qty_ord sod_qty_pick
 *                  sod_qty_ship sod_sched sod_type sod_um_conv) where
 * /*J394*/         sod_nbr = ship_line.abs_order and
 * /*J394*/         sod_line = integer (ship_line.abs_line)
 * /*J394*/         no-lock:
 *K20P** END DELETE SECTION */

/*K20P*/          where sod_nbr = ship_line.abs_order and
/*K20P*/                sod_line = integer (ship_line.abs_line)
/*K20P*/                exclusive-lock:
/*J394*/       end. /* FOR FIRST SOD_DET */

/*J394*/       if available sod_det and sod_cfg_type <> "2"
/*K21N** /*J394*/ and sod_fa_nbr = ""    */
/*J394*/       then do:
/*L0M0*/          /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
/*J394*/          {gprun.i ""sosopka2.p""
                           "(input ship_line.abs_order,
                             input integer (ship_line.abs_line),
                             input - l_abs_pick_qty *
                                     decimal(ship_line.abs__qad03),
                             input l_delproc)"}
/*K20P*/ if sod_sched then sod_pickdate = ?.
/*J394*/       end. /* IF AVAILABLE SOD_DET */

              {gprun.i ""gpalias3.p""
                       "(so_db, output errornum)"}
              if errornum <> 0 and errornum <> 9 then do:
                /* DATABASE # IS NOT CONNECTED */
/*M110**        {mfmsg03.i 2510 4         */
/*M110**        {&rcshwbb_p_3} """" """"} */
/*M110*/        /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/        run p-pxmsg (input 2510,
                             input 4,
                             input l_msgar1[1]).
                undo DEL_LOOP, retry DEL_LOOP.
              end. /* if errornum <> 0 or 9 */
            end. /* if so_db <> global_db */

            /* UPDATE ALLOCATION, PICK, AND SEND CMF MSG  */
            find sod_det where sod_nbr = ship_line.abs_order
              and sod_line = integer (ship_line.abs_line)
            no-lock no-error.
            if available sod_det and sod_cfg_type <> "2"
/*K21N**       and sod_fa_nbr = ""                        */
            then do:
/*K18W*/  /* PASSED PARAMETER abs__dec01 INSTEAD OF abs_qty TO sosopka2.p */
/*K1NF*/  /* REPLACE SHIP_LINE.ABS__DEC01 WITH L_ABS_PICK_QTY*/
/*J2MH*/  /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
/*L0M0*/  /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
              {gprun.i ""sosopka2.p""
                     "(input ship_line.abs_order,
                       input integer (ship_line.abs_line),
                       input - l_abs_pick_qty * decimal(ship_line.abs__qad03),
                       input l_delproc)"}
              find so_mstr where so_nbr = sod_nbr no-lock no-error.
              if available so_mstr and so_secondary then
                run create-so-cmf (input recid (sod_det)).
/*K20P*/ if sod_sched then sod_pickdate = ?.
            end. /* if available sod_det and ... */

            /* DELETE ABSR_DET RECORDS */
            if ship_line.abs_id begins "i"
            then do:
              {gprun.i ""rcdlabsr.p""
                  "(input recid(ship_line))"}

/*N004*/        /* DELETE SEQUENCES */
/*N004*/        run delete_sequences
/*N004*/            (input recid(ship_line)).
            end. /* abs_id begins "i" */

            /* Delete custom shipper document information
               associated with the record */
            {gprun.i ""sofsde.p"" "(input recid(ship_line))"}

/*L13N*/    for each lotw_wkfl
/*L13N*/       where lotw_mfguser = mfguser
/*L13N*/       exclusive-lock:
/*L13N*/       delete lotw_wkfl.
/*L13N*/    end. /* FOR EACH lotw_wkfl */

/*M0VG*/    {gprun.i ""nrm.p"" " " "persistent set h_nrm"}

/*M0VG*/    /* RECORD CREATION IN nrh_hist WITH ACTION AS 'VOID' AFTER */
/*M0VG*/    /* DELETION OF SHIPPER */
/*M0VG*/    run nr_void_value in h_nrm(input ship_line.abs_nr_id,
                                       input substring(ship_line.abs_id,2),
                                       input " ").

/*M16Y*/    /* TO RELEASE THE LOCK ON nr_mstr/nrh_hist HELD BY THE HANDLE */
/*M16Y*/    delete procedure h_nrm no-error.

            delete ship_line.

          end. /* for each ship_line */

          assign
            abs_recid = ?
            save_frame_line = 1.

        end. /* sel_var_del = 1 */
        /* REPAINT THE SCREEN WITH NEW RECORDS */
        refresh = true.

      end. /* IF VALID_ENTRY */
    end. /* del_loop */

  END PROCEDURE. /* delete_proc */

/*K0J7* added internal procedure add_proc */
  PROCEDURE add_proc:
    define output parameter next_editloop as logical no-undo.
    define output parameter next_mainloop as logical no-undo.
/*J22Y*/ define output parameter leave_editloop as logical no-undo.

    if not v_editall then do:
      {mfmsg.i 5811 3}
      /* Selection only available for */
      /* unconfirmed, non-SO shippers */
      next_editloop = yes.
      return.
    end.  /* if not v_editall */

    /* ALLOW ADDING COMPONENT TO A KIT ITEM  */
    if ship_line.abs_id begins "i" and
      (not available sod_det or
      ((sod_det.sod_cfg_type <> "2" or sod_det.sod_type <> "" or
      ship_line.abs_item <> sod_det.sod_part)))
    then do:
      {mfmsg.i 13 3} /* NOT A VALID SELECTION */
      next_editloop = yes.
      return.
    end.

    color display input first_column with frame k.

    /* DISPLAY F3 ADD OPTIONS FRAME */
    hide frame sample no-pause.
    view frame m.

    assign
      valid_entry = false
      sel_var_add = 1
      save_frame_line = frame-line(k).

    /* GET USER SELECTION */
    GET_SELECTION_2:
    do on endkey undo GET_SELECTION_2, leave GET_SELECTION_2
    on error undo GET_SELECTION_2, retry GET_SELECTION_2:

      /* PLEASE SELECT A FUNCTION */
/*V8-*/
     {mfmsg01.i 39 1 sel_var_add}
/*V8+*/
/*V8!                   {mfmsg01c.i 39 1 sel_var_add}   */

/*K0JC*  if (sel_var_add < 1 or sel_var_add > 3) */
/*K0JC*/ if (sel_var_add < 1 or sel_var_add > 4)
        or (sel_var_add <> 1 and ship_line.abs_id begins "i")
      then do:
        {mfmsg.i 13 3} /* NOT A VALID CHOICE */
        undo GET_SELECTION_2, retry GET_SELECTION_2.
      end. /* if sel_var_add < 1 ... */

      valid_entry = true.
    end. /* get_selection_2 */

    /* HIDE FRAMES FOR ADD */
    hide frame m no-pause.
    hide frame sample no-pause.
    hide frame k no-pause.

/*J22Y*/ if batchrun and
/*J22Y*/   (lastkey = keycode("F4") or
/*J22Y*/    keyfunction(lastkey) = "END-ERROR" or
/*J22Y*/    keyfunction(lastkey) = "ENDKEY" or
/*J22Y*/    keyfunction(lastkey) = "."    or
/*J22Y*/    lastkey = keycode("CTRL-E"))
/*J22Y*/ then do:
/*J22Y*/    leave_editloop = yes.
/*J22Y*/    return.
/*J22Y*/ end. /* IF BATCHRUN AND */

    /* PROCESS F3 ADD SELECTION */
    if valid_entry then do:

      /*** TRUTH TABLE - SEL_VAR */
      /*               1  2  3   */
      /*                         */
      /* ADD_ITEM      T  F  T   */
      /* ADD_CONTAINER F  T  T   */
      /* ADD_PARENT    F  F  T   */
      /***************************/

      assign
        abs_recid = recid(ship_line)
        add_container = true
        add_item = true
/*K0JC*/ add_existing_container = true
        add_parent_container = true.

      /* ADD AN ITEM RECORD */
      if sel_var_add = 1 then do:
        assign
          add_container = false
/*K0JC*/  add_existing_container = false
          add_parent_container = false.
      end.

      /* ADD A CONTAINER RECORD */
      if sel_var_add = 2 then do:
        assign
          add_item = false
/*K0JC*/  add_existing_container = false
          add_parent_container = false.
      end.

/*K0JC*/ if sel_var_add = 3 then do:
/*K0JC*/   add_existing_container = false.
/*K0JC*/ end.

/*K0JC*/ if sel_var_add = 4 then do:
/*K0JC*/   assign
/*K0JC*/     add_item = false
/*K0JC*/     add_parent_container = false
/*K0JC*/     add_container = false.
/*K0JC*/ end. /* sel_var_add = 4 */

      create_recs = true.
      assign next_mainloop = yes.
      return.
   end. /* IF VALID ENTRY */
  END PROCEDURE. /* add_proc */

  /*K0J7* added internal procedure navigate_proc */
  PROCEDURE navigate_proc:
    /* HANDLE CURSOR MOVEMENT UP */
    if (lastkey = keycode("F9")
      or keyfunction(lastkey) = "CURSOR-UP")
    then do:

      /* MOVE UP ONE LINE IN SCROLLING WINDOW */
      find prev ship_line
        where ship_line.abs_shipfrom = ship_from
        and ship_line.abs_shipto begins tmp_prefix
      exclusive-lock no-error.

      if available ship_line then do:

/*L0PR*/ for first sod_det
/*L0PR*/    fields (sod_cfg_type sod_contr_id sod_fa_nbr sod_line sod_nbr
/*L0PR*/            sod_part sod_pickdate sod_qty_all sod_qty_ord sod_qty_pick
/*L0PR*/            sod_qty_ship sod_sched sod_type sod_um_conv sod__qadl01)
/*L0PR*/    where sod_nbr  = ship_line.abs_order
/*L0PR*/      and sod_line = integer(abs_line) no-lock:
/*L0PR*/ end. /* FOR FIRST SOD_DET */

        up 1 with frame k.

        /* SET UP DISP_LINE */
        {rcshwbb1.i}

        display
           fill(".",minimum(4,integer(ship_line.abs__qad06)))
           + ship_line.abs__qad06
           @ first_column
           disp_line
        with frame k.
      end.

      else do:
        /* NO RECORD FOUND */
        find first ship_line
          where ship_line.abs_shipfrom = ship_from
          and ship_line.abs_shipto begins tmp_prefix
        exclusive-lock no-error.
       bell.
     end.
    end. /* IF LASTKEY = F9 */

    /* HANDLE CURSOR MOVEMENT DOWN */
    if (lastkey = keycode("F10")
    or keyfunction(lastkey) = "CURSOR-DOWN") then do:

      /* MOVE DOWN ONE LINE IN SCROLLING WINDOW */
      find next ship_line
        where ship_line.abs_shipfrom = ship_from
        and ship_line.abs_shipto begins tmp_prefix
      exclusive-lock no-error.

      if available ship_line then do:

/*L0PR*/ for first sod_det
/*L0PR*/    fields (sod_cfg_type sod_contr_id sod_fa_nbr sod_line sod_nbr
/*L0PR*/            sod_part sod_pickdate sod_qty_all sod_qty_ord sod_qty_pick
/*L0PR*/            sod_qty_ship sod_sched sod_type sod_um_conv sod__qadl01)
/*L0PR*/    where sod_nbr  = ship_line.abs_order
/*L0PR*/    and   sod_line = integer(abs_line) no-lock:
/*L0PR*/ end. /* FOR FIRST SOD_DET */

        down 1 with frame k.

        /* SET UP DISP_LINE */
        {rcshwbb1.i}

        display
           fill(".",minimum(4,integer(ship_line.abs__qad06)))
           + ship_line.abs__qad06
           @ first_column
           disp_line
        with frame k.
      end.

      else do:

        /* NO RECORD FOUND */
        find last ship_line
          where ship_line.abs_shipfrom = ship_from
          and ship_line.abs_shipto >= tmp_prefix
          and ship_line.abs_shipto <= tmp_prefix
                                  + fill(hi_char,8)
        exclusive-lock no-error.

        bell.

      end.
    end. /* IF LASTKEY = F10 */
 END PROCEDURE. /* navigate_proc */

/*J35D*/  PROCEDURE p_clean_up:

/*J35D*/     define input parameter l_shpfrm  like abs_shipfrom no-undo.
/*J35D*/     define input parameter l_tmpprfx as   character    no-undo.

/*J35D*/     for each ship_line where ship_line.abs_shipfrom    = l_shpfrm
/*J35D*/                          and ship_line.abs_shipto begins l_tmpprfx
/*J35D*/     exclusive-lock:

/*J35D*/        ship_line.abs_shipto = ship_line.abs__qad05.
/*J35D*/     end. /* FOR EACH SHIP_LINE */

/*J35D*/  end. /* PROCEDURE p_clean_up */

/*J37V*/ PROCEDURE p_update_alloc:
/*J37V*/ /* THIS PROCEDURE IS USED FOR UPDATING THE LD_DET AND LAD_DET   */
/*J37V*/ /* WHEN THE SALES ORDER IS CHANGED.                             */

/*J37V*/    /* LOCAL VARIABLES */
/*J37V*/    define variable l_adj_qty  like ld_qty_all   no-undo.
/*J37V*/    define variable l_sod_all  like sod_qty_all  no-undo.

/*J37V*/    /* THE PROGRAM SOITALLD.P WHICH IS USED FOR UPDATING THE  */
/*J37V*/    /* LAD_DET AND LD_DET FOR CHANGE IN ALLOCATION AND PICK.  */
/*J37V*/    /* CANNOT BE USED FOR CREATING THE DETAIL ALLOCATIONS FOR */
/*J37V*/    /* CHANGE IN SO, SINCE IT ONLY UPDATES THE EXISTING LAD_DET */
/*J37V*/    /* IF CHANGE IN SHIP AND PICK ARE BOTH NON ZERO. AND DOESNT */
/*J37V*/    /* CREATE ONE IF NONE EXIST. WE HANDLE THIS BY USING 2 CALLS */
/*J37V*/    /* TO SOITALLA.P, ONE TO CREATE AN LAD_DET WITH PICK = SHIP. */
/*J37V*/    /* AND THE SECOND TO ADJUST THE PICK QTY.                    */

/*J37V*/    /* SET GLOBAL_DB USING ABS_SITE */
/*J37V*/    new_site = ship_line.abs_site.
/*J37V*/    {gprun.i ""gpalias.p""}

/*J37V*/    /* SWITCH TO THE INVENTORY SITE */
/*J37V*/    if so_db <> global_db then do:
/*J37V*/       {gprun.i ""gpalias2.p""
                        "(input  ship_line.abs_site,
                          output errornum)"}
/*J37V*/       if errornum <> 0 and errornum <> 9 then do:
/*J37V*/          /* DATABASE # IS NOT CONNECTED */
/*M110** /*J37V*/ {mfmsg03.i 2510 4 "'For Remote Inventory'" """" """"} */
/*M110*/          /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/          run p-pxmsg (input 2510,
                               input 4,
                               input l_msgar1[2]).
/*J37V*/          undotran = yes.
/*J37V*/          return.
/*J37V*/       end. /* IF ERRORNUM <> 0 ... */
/*J37V*/    end. /* IF SO_DB <> GLOBAL_DB */

/*J37V*/    /* DO THE GENERAL ALLOCATIONS */
/*J37V*/    if sod_det.sod_qty_all = 0 then
/*J37V*/    do:
/*J37V*/       for first soc_ctrl fields(soc_all_days) no-lock:
/*J37V*/       end. /* FOR FIRST SOC_CTRL */

/*J37V*/       {gprun.i ""soitallc.p""
                         "(input ship_line.abs_order,
                           input integer(ship_line.abs_line),
                           input soc_all_days,
                           input ship_line.abs_qty *
                                 decimal(ship_line.abs__qad03) / sod_um_conv,
                           output l_sod_all)"}
/*J37V*/    end. /* IF SOD_QTY_ALL = 0 */

/*J37V*/    /* CREATE DETAIL ALLOCATIONS */
/*J37V*/    {gprun.i ""soitalla.p""
                     "(input ship_line.abs_order,
                       input ship_line.abs_line,
                       input ship_line.abs_item,
                       input ship_line.abs_site,
                       input ship_line.abs_loc,
                       input ship_line.abs_lot,
                       input ship_line.abs_ref,
                       input ship_line.abs_qty * decimal(ship_line.abs__qad03),
                       input 0,
                       output adj_qty,
                       output undotran)"}

/*J37V*/    /* ADJUST THE PICK QTY IF NECESSARY*/
/*J37V*/    if l_abs_pick_qty <> ship_line.abs_qty and
/*J37V*/       not undotran then
/*J37V*/    do:
/*J37V*/       {gprun.i ""soitalla.p""
                        "(input ship_line.abs_order,
                          input ship_line.abs_line,
                          input ship_line.abs_item,
                          input ship_line.abs_site,
                          input ship_line.abs_loc,
                          input ship_line.abs_lot,
                          input ship_line.abs_ref,
                          input (l_abs_pick_qty - ship_line.abs_qty) *
                                decimal(ship_line.abs__qad03),
                          input 0,
                          output l_adj_qty,
                          output undotran)"}

/*J37V*/    end. /* IF L_ABS_PICK_QTY <> SHIP_LINE.ABS_QTY  */

/*J37V*/    assign
/*J37V*/       adj_qty    = adj_qty     + l_adj_qty
/*J37V*/    .

/*J37V*/    /* SWITCH BACK TO THE SALES ORDER DATABASE */
/*J37V*/    if so_db <> global_db then do:

/*J394*/       /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
/*J394*/       /* IN REMOTE DATABASE                         */
/*J394*/       if not kit_comp
/*J394*/       then do:
/*L0M0*/          /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
/*J394*/          {gprun.i ""sosopka2.p""
                           "(input ship_line.abs_order,
                             input integer (ship_line.abs_line),
                             input l_abs_pick_qty,
                             input l_delproc)"}
/*J394*/       end. /* IF NOT KIT_COMP */

/*J37V*/       {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}
/*J37V*/       if errornum <> 0 and errornum <> 9 then do:
/*J37V*/          /* DATABASE # IS NOT CONNECTED */
/*M110** /*J37V*/ {mfmsg03.i 2510 4 "'For Sales Orders'" """" """"} */
/*M110*/          /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/          run p-pxmsg (input 2510,
                               input 4,
                               input l_msgar1[1]).
/*J37V*/           undotran = yes.
/*J37V*/           return.
/*J37V*/       end. /* IF ERRORNUM <> 0 ... */
/*J37V*/    end. /* IF SO_DB <> GLOBAL_DB */

/*J37V*/    if undotran then
/*J37V*/       return.

/*J37V*/    /* UPDATE THE SALES ORDER QTY ALL, QTY PICK */
/*J37V*/    if not kit_comp then
/*J37V*/    do:

/*J37V*/       /* IF GENERAL ALLOCATIONS WERE DONE PREVIOUSLY THEN UPDATE */
/*J37V*/       /* THE SOD_QTY_ALL IN THE CENTRAL DB BEFORE ADJUSTMENT OF  */
/*J37V*/       /* THE PICK QTY BY SOSOPKA2.P.                             */
/*J37V*/       if sod_det.sod_qty_all = 0 then
/*J37V*/       do:
/*J37V*/          find sod_det where sod_nbr  = ship_line.abs_order and
/*J37V*/                             sod_line = integer(ship_line.abs_line)
/*J37V*/          exclusive-lock.

/*J37V*/          assign
/*J37V*/             sod_qty_all = l_sod_all.

/*J37V*/          find sod_det where sod_nbr  = ship_line.abs_order and
/*J37V*/                             sod_line = integer(ship_line.abs_line)
/*J37V*/          no-lock.
/*J37V*/       end. /* IF SOD_DET.SOD_QTY_ALL = 0 */

/*J37V*/       /* UPDATE THE SO QTY PICKED */
/*L0M0*/       /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
/*J37V*/       {gprun.i ""sosopka2.p""
                        "(input ship_line.abs_order,
                          input integer (ship_line.abs_line),
                          input l_abs_pick_qty,
                          input l_delproc)"}

/*J37V*/    end. /* IF NOT KIT_COMP */
/*J37V*/ END PROCEDURE. /* P_UPDATE_ALLOC */

/*J37V*/ PROCEDURE p_update_alloc1:
/*J37V*/ /* THIS PROCEDURE IS USED FOR UPDATING THE LD_DET AND LAD_DET   */
/*J37V*/ /* WHEN THE SHIP AND/OR PICK QTY IS CHANGED.                    */

/*J37V*/    /* SET GLOBAL_DB USING ABS_SITE */
/*J37V*/    new_site = ship_line.abs_site.
/*J37V*/    {gprun.i ""gpalias.p""}

/*J37V*/    /* SWITCH TO THE INVENTORY SITE */
/*J37V*/    if so_db <> global_db then do:
/*J37V*/       {gprun.i ""gpalias2.p""
                        "(input  ship_line.abs_site,
                          output errornum)"}
/*J37V*/       if errornum <> 0 and errornum <> 9 then do:
/*J37V*/          /* DATABASE # IS NOT CONNECTED */
/*M110** /*J37V*/ {mfmsg03.i 2510 4 "'For Remote Inventory'" """" """"} */
/*M110*/          /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/          run p-pxmsg (input 2510,
                               input 4,
                               input l_msgar1[2]).
/*J37V*/          undotran = yes.
/*J37V*/          return.
/*J37V*/       end. /* IF ERRORNUM <> 0 ... */
/*J37V*/    end. /* IF SO_DB <> GLOBAL_DB */

/*J37V*/    if (qty_old = ship_line.abs_qty) and
/*J37V*/       (old_qty <> l_abs_pick_qty) then do:

/*J37V*/       {gprun.i ""soitalla.p""
                        "(input ship_line.abs_order,
                          input ship_line.abs_line,
                          input ship_line.abs_item,
                          input old_site,
                          input old_loc,
                          input old_lot,
                          input old_ref,
                          input (l_abs_pick_qty - old_qty) *
                               decimal(ship_line.abs__qad03),
                          input (ship_line.abs_qty - old_qty)
                             * decimal(ship_line.abs__qad03),
                          output adj_qty,
                          output undotran)"}
/*J37V*/    end. /* IF QTY_OLD = SHIP_LINE.ABS_QTY AND ... */
/*J37V*/    else do:
/*J37V*/       {gprun.i ""soitalld.p""
                        "(input ship_line.abs_order,
                          input ship_line.abs_line,
                          input ship_line.abs_item,
                          input old_site,
                          input old_loc,
                          input old_lot,
                          input old_ref,
                          input (l_abs_pick_qty - old_qty )*
                              decimal(ship_line.abs__qad03),
                          input (ship_line.abs_qty - qty_old) *
                              decimal(ship_line.abs__qad03),
                          input qty_old *
                              decimal(ship_line.abs__qad03),
                          input del_lad,
                          output adj_qty,
                          output undotran)"}
/*J37V*/    end. /*  ELSE DO */

/*J37V*/    /* SWITCH BACK TO THE SALES ORDER DATABASE */
/*J37V*/    if so_db <> global_db then do:

/*J394*/       /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
/*J394*/       /* IN REMOTE DATABASE                         */
/*J394*/       if not kit_comp
/*J394*/       then do:
/*L0M0*/          /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
/*J394*/          {gprun.i ""sosopka2.p""
                           "(input ship_line.abs_order,
                             input integer (ship_line.abs_line),
                             input adj_qty,
                             input l_delproc)"}
/*J394*/       end. /* IF NOT KIT_COMP */

/*J37V*/       {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}
/*J37V*/       if errornum <> 0 and errornum <> 9 then do:
/*J37V*/          /* DATABASE # IS NOT CONNECTED */
/*M110** /*J37V*/ {mfmsg03.i 2510 4 "'For Sales Orders'" """" """"} */
/*M110*/          /* REPLACED MFMSG03 CALL BY PXMSG */
/*M110*/          run p-pxmsg (input 2510,
                               input 4,
                               input l_msgar1[1]).
/*J37V*/          undotran = yes.
/*J37V*/          return.
/*J37V*/       end. /* IF ERRORNUM <> 0 ... */
/*J37V*/    end. /* IF SO_DB <> GLOBAL_DB */

/*J37V*/    if undotran then
/*J37V*/       return.

/*J37V*/    /* UPDATE THE SALES ORDER QTY ALL, QTY PICK */
/*L0M0*/    /* ADDED FOURTH INPUT PARAMETER L_DELPROC     */
/*J37V*/    if not kit_comp then
/*J37V*/       {gprun.i ""sosopka2.p""
                        "(input ship_line.abs_order,
                          input integer (ship_line.abs_line),
                          input adj_qty,
                          input l_delproc)"}

/*J37V*/ END PROCEDURE. /* P_UPDATE_ALLOC1 */

/*K21H*/ PROCEDURE ip-refresh:

/*K21H*/ /* THIS PROCEDURE REFRESHES THE LOWER SCREEN WHEN ENDKEY  */
/*K21H*/ /* IS PRESSED                                             */
/*K21H*/    display
/*K21H*/       ship_line.abs_order @ part_order
/*K21H*/       ship_line.abs_line @ part_order_line
/*K21H*/       qty_old @ ship_line.abs_qty
/*K21H*/       old_qty @ l_abs_pick_qty
/*K21H*/       l_twt_old @ l_abs_tare_wt
/*K21H*/       ship_line.abs_wt_um @ l_twt_um
/*K21H*/       ship_line.abs__qad02
/*K21H*/       old_site @ ship_line.abs_site
/*K21H*/       old_loc @ ship_line.abs_loc
/*K21H*/       nwt_old @ ship_line.abs_nwt
/*K21H*/       ship_line.abs_wt_um
/*K21H*/       old_lot @ ship_line.abs_lot
/*K21H*/       ship_line.abs_gwt
/*K21H*/       ship_line.abs_wt_um @ gwt_um
/*K21H*/       old_ref @ ship_line.abs_ref
/*K21H*/       sod_det.sod_type when (available sod_det)
/*K21H*/       "" when (not available sod_det) @ sod_type
/*K21H*/       vol_old @ ship_line.abs_vol
/*K21H*/       ship_line.abs_vol_um
/*K21H*/       cnsm_req
/*K21H*/       pt_mstr.pt_desc1 when (available pt_mstr)
/*K21H*/       "" when (not available pt_mstr) @ pt_desc1
/*K21H*/       sod_det.sod_contr_id when (available sod_det)
/*K21H*/       "" when (not available sod_det) @ sod_contr_id
/*K21H*/       cmmts
/*L0PR*/       cancel_bo
/*K21H*/       ship_line.abs_fa_lot
/*K21H*/    with frame sample.
/*K21H*/ END PROCEDURE. /* PROCEDURE IP-REFRESH */

/*N004*/  PROCEDURE maintain_sequences:
/*N004*/    define input parameter l_abs_id  like abs_id no-undo.
/*N004*/    define input parameter l_shipfrom like abs_shipfrom no-undo.

/*N004*/    for first abs_mstr where
/*N004*/        abs_id = l_abs_id and
/*N004*/        abs_shipfrom = l_shipfrom
/*N004*/        no-lock: end.

/*N004*/    if available (abs_mstr) then do:
/*N004*/        /* IS CUST. SEQ. SCHEDULES INSTALLED ? */
/*N004*/        if can-find (mfc_ctrl where
/*N004*/            mfc_field = "enable_sequence_schedules" and
/*N004*/            mfc_logical) and rcf_file_found then do:

/*N004*/            for first so_mstr where so_nbr = abs_order no-lock: end.
/*N004*/            if available so_mstr and so_seq_order then do:

/*N004*/               /* MAINTAIN SEQUENCES FOR abs_mstr */
/*N004*/               {gprunmo.i
                           &program = ""rcabssup.p""
                           &module = "ASQ"
                           &param = """(input l_abs_id,
                           input l_shipfrom,
                           input "yes")"""}

/*N004*/                /*PUT THE STATUS LINE BACK */
/*N004*/                status input stline[13].
/*N004*/            end. /* IF AVAILABLE so_mstr */
/*N004*/        end. /* if can-find */
/*N004*/    end. /* if available */
/*N004*/  END PROCEDURE.  /* maintain_sequences */

/*N004*/  PROCEDURE delete_sequences:
/*N004*/    define input parameter l_recid  as recid no-undo.

/*N004*/    for first abs_mstr where
/*N004*/        recid(abs_mstr) = l_recid
/*N004*/        no-lock: end.

/*N004*/    if available (abs_mstr) then do:
/*N004*/        /* IS CUST. SEQ. SCHEDULES INSTALLED ? */
/*N004*/        if can-find (mfc_ctrl where
/*N004*/            mfc_field = "enable_sequence_schedules" and
/*N004*/            mfc_logical) and rcf_file_found then do:

/*N004*/            /* DELETE SEQUENCES */
/*N004*/            {gprunmo.i
                        &program = ""rcabssdl.p""
                        &module = "ASQ"
                        &param = """(input l_recid, input '')"""}
/*N004*/        end. /* if can-find */
/*N004*/    end. /* if available */
/*N004*/  END PROCEDURE.  /* delete_sequences */

/*N004*/  PROCEDURE check_tablename:
/*N004*/    define input parameter l_tablename as character no-undo.
/*N004*/    define output parameter l_file_found like mfc_logical  no-undo.

/*N004*/    /* VARIABLE DEFINITIONS FOR gpfile.i */
/*N004*/    {gpfilev.i}

/*N004*/    {gpfile.i &file_name = l_tablename}
/*N004*/    l_file_found = file_found.

/*N004*/  END PROCEDURE.  /* check_tablename */

/*M110** BEGIN DELETE
 * /*L0PR*/ procedure p-mfmsg03:
 *
 * /*L0PR*/    define input parameter l_num     as integer   no-undo.
 * /*L0PR*/    define input parameter l_stat    as integer   no-undo.
 * /*L0PR*/    define input parameter l_msgarg1 as character no-undo.
 * /*L0PR*/    define input parameter l_msgarg2 as character no-undo.
 * /*L0PR*/    define input parameter l_msgarg3 as character no-undo.
 *
 * /*L0PR*/    {mfmsg03.i l_num l_stat l_msgarg1 l_msgarg2 l_msgarg3}
 *
 * /*L0PR*/ end.  /* PROCEDURE P-MFMSG03 */
 *M110** END DELETE */

/*M110*/ PROCEDURE p-pxmsg:
            define input parameter l_num     as integer   no-undo.
            define input parameter l_stat    as integer   no-undo.
            define input parameter l_msgarg1 as character no-undo.

            {pxmsg.i
             &MSGNUM     = l_num
             &ERRORLEVEL = l_stat
             &MSGARG1    = l_msgarg1
            }

         END PROCEDURE. /* PROCEDURE p-pxmsg */

/*M110*/ /* PROCEDURE TO ACCUMULATE lad_qty_all FOR ALL SHIPPERS FOR PART */
         PROCEDURE p-alloclad:

            l_lad_qty_all = 0.
            for each lad_det
               fields(lad_dataset lad_line lad_loc lad_lot lad_nbr
                      lad_part lad_qty_all lad_qty_pick
                      lad_ref lad_site)
               where lad_site    = ship_line.abs_site
                 and lad_loc     = ship_line.abs_loc
                 and lad_part    = ship_line.abs_item
                 and lad_lot     = ship_line.abs_lot
                 and lad_ref     = ship_line.abs_ref no-lock:

               l_lad_qty_all     = l_lad_qty_all + lad_qty_all.

            end. /* FOR EACH lad_det */

         END PROCEDURE. /* PROCEDURE p-alloclad */
