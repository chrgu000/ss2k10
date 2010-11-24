/* xxrcshwbb.p - SHIPPER WORKBENCH - SUB PROGRAM                             */
/* modify from rcshwbb.p                                                     */
/* REVISION: 1.0      LAST MODIFIED: 09/14/10   BY: zy                       */
/*-Revision end--------------------------------------------------------------*/
/* check shipqty must less or equ to ordqty                                  */

{mfdeclre.i}
{cxcustom.i "RCSHWBB.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{rcinvtbl.i new}  /* DEFINITIONS NEEDED FOR rcinvcon.i */

/* INPUT PARAMETERS */
define input parameter ship_from  as character.
define input parameter tmp_prefix as character.
define input parameter abs_recid  as recid.

/* SHARED VARIABLES */
define new shared variable new_site like si_site.
define new shared variable err_stat as integer.
define new shared variable so_db as character.
define new shared variable cmtindx like cmt_indx.

define shared variable ship_so   like so_nbr.
define shared variable ship_line like sod_line.

define shared variable global_recid as recid.

/* LOCAL VARIABLES */
define variable save_frame_line  as integer          no-undo.
define variable i                as integer          no-undo.
define variable first_column     as character format "x(5)" no-undo.
define variable transtype        as character initial "ISS-UNP" no-undo.
define variable nullstr          as character        no-undo.
define variable undotran         like mfc_logical    no-undo.
define variable del-yn           like mfc_logical    no-undo.
define variable delete_recid     as recid            no-undo.
define variable sel_var_add      as integer format "9" no-undo.
define variable sel_var_del      as integer format "9" no-undo.
define variable error_lot        as logical          no-undo.
define variable error_part       as logical          no-undo.
define variable valid_entry      as logical          no-undo.
define variable refresh          as logical          no-undo.
define variable cont_id          as character format "x(9)" no-undo.
define variable return_code      as integer          no-undo.
define variable sort_recs        as logical          no-undo.
define variable create_recs      as logical          no-undo.
define variable gwt_um           as character        no-undo.
define variable disp_line        as character format "x(69)" no-undo.
define variable shipto_name      like ad_name        no-undo.
define variable shipto_code      like abs_shipto     no-undo.
define variable nwt_old          like abs_nwt        no-undo.
define variable absship_recid    as recid            no-undo.
define variable par_id           as character        no-undo.
define variable cnsm_req         as logical          no-undo.
define variable open_qty         like schd_all_qty   no-undo.
define variable peg_qty          like schd_all_qty   no-undo.
define variable shipgrp          like sgad_grp       no-undo.
define variable cmmts            like mfc_logical label "Comments" no-undo.
define variable parent_abs_recid as recid            no-undo.
define variable errorst          as logical          no-undo.
define variable errornum         as integer          no-undo.
define variable can_discard      as logical          no-undo.
define variable msgnum           as integer          no-undo.
define variable pick_qty         like sod_qty_pick   no-undo.
define variable tmp_qty          like sod_qty_pick   no-undo.
define variable avail_qty        like sod_qty_pick   no-undo.
define variable old_lot          like lad_lot        no-undo.
define variable old_qty          like lad_qty_all    no-undo.
define variable old_loc          like lad_loc        no-undo.
define variable old_site         like lad_site       no-undo.
define variable old_ref          like lad_ref        no-undo.
define variable kit_comp         as logical          no-undo.
define variable del_lad          as logical          no-undo.
define variable cmf_flg          as logical          no-undo.
define variable qty_old          as decimal          no-undo.
define variable vol_old          as decimal          no-undo.
define variable v_editall        as logical          no-undo.
define variable ch_nwt           like abs_nwt        no-undo.
define variable next_editloop    as logical          no-undo.
define variable next_mainloop    as logical          no-undo.
define variable original_nwt     like abs_nwt        no-undo.
define variable original_gwt     like abs_gwt        no-undo.
define variable so_ok            as logical          no-undo.
define variable part_order       like abs_order      no-undo.
define variable part_order_line  like abs_line       no-undo.
define variable v-abs_format     like abs_mstr.abs_format no-undo.
define variable adj_qty          like ld_qty_all     no-undo.
define variable fas_so_rec       as character.
define variable leave_editloop   as logical          no-undo.
define variable l_abs_pick_qty   like sod_qty_pick   no-undo.
define variable v_unpicked_qty   like sod_qty_pick   no-undo.
define variable l_part_qty       like abs_qty        no-undo.
define variable l_twt_old        like abs_nwt        no-undo.
define variable l_abs_tare_wt    like abs_nwt        no-undo.
define variable l_twt_um         as character        no-undo.
define variable l_tr_type        like tr_type        no-undo.
define variable l_order_change   like mfc_logical    no-undo.
define variable l_warning        like mfc_logical    no-undo.
define variable rcf_file_found   like mfc_logical    no-undo.
define variable l_updalloc       like mfc_logical    no-undo.
define variable l_delproc        like mfc_logical    no-undo.
define variable cancel_bo        like mfc_logical    no-undo.
define variable l_prev_pick_qty  like l_abs_pick_qty no-undo.
define variable l_lad_qty_all    like lad_qty_all    no-undo.
define variable l_avail_qty      like lad_qty_all    no-undo.
define variable vLastField       as character        no-undo.
define variable vErrorOrder      like mfc_logical    no-undo.
define variable vErrorOrderLine  like mfc_logical    no-undo.
define variable vErrorMsgNumber  as integer          no-undo.
define variable vErrorSite       like sod_site       no-undo.
define variable vNewOrder        like mfc_logical    no-undo.
define variable vOldAbsID        like abs_id         no-undo.
define variable vOldOrder        like abs_order      no-undo.
define variable vOldLine         like abs_line       no-undo.
define variable clc_file_found   like mfc_logical    no-undo.
define variable shpc_file_found  like mfc_logical    no-undo.
define variable add_container    as logical          no-undo.
define variable add_item         as logical          no-undo.
define variable sodfanbr         like sod_fa_nbr.
define variable l_msgar1         as character format "x(26)" extent 2 no-undo.
define variable add_parent_container    like mfc_logical no-undo.
define variable add_existing_container  like mfc_logical no-undo.
define variable using_container_charges like mfc_logical no-undo.
define variable using_line_charges      like mfc_logical no-undo.
define variable ok_to_recalc_wt_vol     like mfc_logical no-undo.

define variable h_nrm as handle no-undo.

define variable use-log-acctg as logical no-undo.
define variable l_FrTermsErr like mfc_logical no-undo.
define variable l_FrTermsOnFirstOrder like so_fr_terms no-undo.

define variable l_undochk     like mfc_logical initial "no" no-undo.
define variable l_absso_recid as   recid                    no-undo.
define variable l_abs_recid    as   recid       no-undo initial ?.
define variable l_confirm_comp like mfc_logical no-undo.
define variable l_abs_qty      like abs_qty     no-undo.
define variable ret-flag       as   integer     no-undo.
define variable l_stat         like si_status   no-undo.
define variable ok_to_ship     as logical       no-undo.
define variable l_shipto_id    as character     no-undo.
define variable l_dock_id      as character     no-undo.

define variable l_allowed      like mfc_logical no-undo.
define variable l_ship_id      as character     no-undo.
define variable l_addr         as character     no-undo.


define variable l_orig_order like abs_order   no-undo .
define variable l_orig_line  like abs_line    no-undo .
define variable l_tmp_qty    like abs_qty     no-undo initial 0.
define variable l_ship_qty   like abs_qty     no-undo.
define variable l_match_so   like mfc_logical no-undo.
define variable cont_yn      like mfc_logical no-undo.
define variable l_contr_id   like sod_contr_id no-undo .

define variable qty_avaiable like sod_qty_ord no-undo.
{socnvars.i}   /* CONSIGNMENT VARIABLES */

{socnis.i}     /* CUSTOMER CONSIGNMENT SHIPMENT TEMP-TABLE DEFINITION */

{rcexptbl.i new}

define temp-table  abs-tt no-undo
  fields abs-tt-id   like  abs_id
  fields abs-tt-nbr  like  abs_order
  fields abs-tt-item like  abs_item
  fields abs-tt-line like  abs_line
  fields abs-tt-qty  like  abs_qty
index abs-tt-id abs-tt-id .

/* BUFFERS */
define buffer ship_line       for abs_mstr.
define buffer abs_parent_buff for abs_mstr.
define buffer abs_child_buff  for abs_mstr.

assign
   l_msgar1[1] = getTermLabel("FOR_SALES_ORDERS",22)
   l_msgar1[2] = getTermLabel("FOR_REMOTE_INVENTORY",26).

/* CONTAINER WORKBENCH FORMS */
{rcshwbfm.i}

/* DETERMINE IF CUST. SEQ. CONTROL FILE EXISTS */
run check_tablename
   (input "rcf_ctrl",
   output rcf_file_found).

/* DETERMINE IF SHIPMENT PERFORMANCE CONTROL FILE EXISTS */
run check_tablename
   (input "shpc_ctrl",
    output shpc_file_found).

/*DETERMINE IF CONTAINER AND LINE CHARGES IS ENABLED */
run check_tablename
    (input "ccl_ctrl",
     output clc_file_found).

if can-find (mfc_ctrl
   where mfc_domain = global_domain
   and   mfc_field = "enable_container_charges"
   and   mfc_logical)
   and   clc_file_found
then
   using_container_charges =  yes.

if can-find (mfc_ctrl
   where mfc_ctrl.mfc_domain = global_domain
   and mfc_field = "enable_line_charges"
   and mfc_logical) and clc_file_found
then
   using_line_charges =  yes.

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
/* COMBINED THE FOLLOWING ASSIGNMENTS IN A SINGLE */
/* ASSIGN STATEMENT TO REDUCE ACTION SEGMENT SIZE */
assign
   so_db = global_db
   del_lad = no
   parent_abs_recid = abs_recid
   absship_recid = abs_recid.

find first fac_ctrl
   where fac_domain = global_domain
no-lock no-error.
if available fac_ctrl then
   fas_so_rec = string(fac_so_rec).

/* Check whether all data is editable, or only informational fields */
run ip_editall (abs_recid, output v_editall).

find ship_line where recid(ship_line) = abs_recid no-lock no-error.

if not available ship_line then
   assign
      add_container          = true
      add_item               = true
      add_parent_container   = true
      add_existing_container = true
      create_recs            = true.
else do:
   assign
      shipto_code  = ship_line.abs_shipto
      v-abs_format = ship_line.abs_format
      sort_recs    = true.

   find ad_mstr
      where ad_domain = global_domain
      and   ad_addr = ship_line.abs_shipto
   no-lock no-error.
   if available ad_mstr then
      shipto_name = ad_name.
end.

/* GET SHIPTO AND DOCKID */
{gprunp.i "sopl" "p" "getShipToAndDockID"
    "(input abs_shipto,
      output l_shipto_id,
      output l_dock_id)"}

MAINLOOP:
repeat:

   l_absso_recid = ?.

   /* CREATE NEW RECORDS */
   if create_recs then do:

      {gprun.i ""xxrcctwbc.p""
               "(input ship_from,
                 input add_container,
                 input add_item,
                 input add_parent_container,
                 input tmp_prefix,
                 input true,
                 input shipto_code,
                 input l_dock_id,
                 input-output abs_recid)"}.

      if add_existing_container then do:
         /* ADDED THE O/P PARAMETER, TO INDICATE WHETHER THE   */
         /* SALES ORDER IS ATTACHED TO THE ITEM IN THE SHIPPER */
         {gprun.i ""rcshwbd.p""
                  "(input ship_from,
                    input tmp_prefix,
                    input shipto_code,
                    input v-abs_format,
                    input-output abs_recid,
                    output l_match_so)"}
      end.

      /* RESORT AND REPAINT THE SCREEN WITH NEW RECORDS */
      assign
         sort_recs   = true
         create_recs = false.

   end. /* IF CREATE_RECS */

   EDITLOOP:
   repeat with frame k:
      /* INITIALIZE L_UPDALLOC, L_DELPROC AND L_SHIP_QTY */
      assign
            l_updalloc = yes
        l_delproc = no
        l_ship_qty = 0.

      /* SORT THE RECORDS AND EXCLUSIVE-LOCK THEM ALL */
      if sort_recs then do:

         {gprun.i ""rcshwbs.p""
                  "(input abs_recid,
                    input tmp_prefix,
                    output return_code)"}.

         /* HANDLE ERRORS */
         if return_code > 0 then
            undo EDITLOOP, leave MAINLOOP.

         assign
            sort_recs = false
            abs_recid = ?
            refresh   = true.
      end.

      if l_abs_recid <> ? then
         assign
            abs_recid   = l_abs_recid
            l_abs_recid = ?.

      /* REPAINT THE SCREEN */
      if refresh then do:

         ststatus = stline[10].
         status input ststatus.
         clear frame k all no-pause.

         /* FIND SAVED RECORD */
         if abs_recid <> ? then
         find ship_line where recid(ship_line) = abs_recid
            no-lock no-error.

         /* NO SAVED RECORD OR SAVED RECORD NOT FOUND */
         if abs_recid = ? or not available ship_line then do:

            find first ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto begins tmp_prefix
            no-lock no-error.

            /* NO MORE RECORDS AVAILABLE SO LEAVE EDITING */
            if not available ship_line then
              leave MAINLOOP.

            assign
               save_frame_line = 1
               abs_recid = ?.
         end.

         /* BACK OFF RECORDS SO THAT THE RECORD WILL BE DISPLAYED */
         /* IN THE SAME FRAME LINE AS BEFORE */
         i = save_frame_line.

         do while i > 1:

            find prev ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto begins tmp_prefix
            no-lock no-error.

            i = i - 1.
         end.

         /* REFRESH THE FRAME */
         i = 0.

         do while i < 7:

            if available ship_line then do:

               for first sod_det
                  fields (sod_domain sod_cfg_type sod_contr_id sod_fa_nbr
                          sod_line sod_nbr sod_part sod_pickdate
                          sod_qty_all sod_qty_ord sod_qty_pick
                          sod_qty_ship sod_sched sod_type sod_site
                          sod_um_conv sod__qadl01)
                  where sod_domain = global_domain
                  and   sod_nbr    = ship_line.abs_order
                  and   sod_line   = integer(abs_line) no-lock:
               end. /* FOR FIRST SOD_DET */

               /* SET UP DISP_LINE */
               {rcshwbb1.i}

               display
                  fill(".",minimum(4,integer(ship_line.abs__qad06)))
                  + ship_line.abs__qad06
                  @ first_column
                  disp_line
               with frame k.

               find next ship_line
                  where ship_line.abs_domain = global_domain
                  and   ship_line.abs_shipfrom = ship_from
                  and   ship_line.abs_shipto begins tmp_prefix
               no-lock no-error.
            end.

            i = i + 1.

            if i < 7 then down 1 with frame k.
         end. /* DO WHILE I < 8 */

         /* INTRODUCED TRANSACTION BLOCK TO MINIMISE abs_mstr LOCKING */
         do transaction:

            /* FIND THE SAVED RECORD */
            if abs_recid <> ? then
               find ship_line
                  where recid(ship_line) = abs_recid
               exclusive-lock no-error.

            /* FIND THE FIRST RECORD */
            else
               find first ship_line
                  where ship_line.abs_domain = global_domain
                  and   ship_line.abs_shipfrom = ship_from
                  and   ship_line.abs_shipto begins tmp_prefix
               exclusive-lock no-error.

         end. /* do transaction */
         /* MOVE UP TO THE SELECTED RECORD IN THE FRAME */
         up frame-line(k) - save_frame_line.

         refresh = false.
      end. /* IF REFRESH */

      /* RESTORE FIRST_COLUMN */
      color display normal first_column with frame k.

      find pt_mstr
         where pt_domain = global_domain
         and   pt_part = ship_line.abs_item
      no-lock no-error.
      find sod_det
         where sod_domain = global_domain
         and   sod_nbr = ship_line.abs_order
         and   sod_line = integer(abs_line)
      no-lock no-error.

      find so_mstr
         where so_domain = global_domain
         and   so_nbr = ship_line.abs_order
      no-lock no-error.

      cnsm_req = can-find(first absr_det
         where absr_domain = global_domain
         and   absr_shipfrom = abs_shipfrom
         and absr_id = abs_id).

      /* SET UP DISP_LINE */
      {rcshwbb1.i}

      if ship_line.abs_id    begins "C"
         or ship_line.abs_id begins "I"
      then do:
         /* SET GLOBAL_DB USING ABS_SITE */
         old_site = "".
         new_site = ship_line.abs_site.
         {gprun.i ""gpalias.p""}

         /* SWITCH TO THE INVENTORY SITE */
         if so_db <> global_db then do:
            {gprun.i ""gpalias2.p""
               "(input ship_line.abs_site, output errornum)"}
            if errornum <> 0 and errornum <> 9 then do:
               /* DOMAIN # IS NOT AVAILABLE */
               run p-pxmsg (input 6137,
                            input 4,
                            input l_msgar1[2]).

            end.
            /* FIND FINAL ASSEMBLY CONTROL IN REMOTE DOMAIN */
            {gprun.i ""sofactrl.p"" "(output fas_so_rec)"}
         end.

         /* SWITCH BACK TO THE SALES ORDER DOMAIN */
         if so_db <> global_db then do:
            {gprun.i ""gpalias3.p"" "(input so_db, output errornum)"}
            if errornum <> 0 and errornum <> 9 then do:
               /* DOMAIN # IS NOT AVAILABLE */
               run p-pxmsg (input 6137,
                            input 4,
                            input l_msgar1[1]).
            end.
         end.
      end. /* IF ship_line.abd_id begins "C"... */

      display
         disp_line
      with frame k.

      {absupack.i  "ship_line" 3 22 "l_abs_pick_qty"}

      {absupack.i  "ship_line" 26 22 "l_abs_tare_wt"}

      assign
         vOldAbsID = ship_line.abs_id
         vOldOrder = ship_line.abs_order
         vOldLine  = ship_line.abs_line.

      status input stline[13].

      l_contr_id = "".

      if ship_line.abs_line <> ""
      then do:

         if available sod_det
         then
            l_contr_id  = sod_contr_id.

         else do:

            for first idh_hist
               fields (idh_domain idh_contr_id idh_inv_nbr idh_line idh_nbr)
               where  idh_domain  = global_domain
                  and idh_inv_nbr = ship_line.abs_inv_nbr
                  and idh_nbr     = ship_line.abs_order
                  and idh_line    = integer(ship_line.abs_line)
            no-lock :
               l_contr_id =  idh_contr_id.
            end. /* FOR FIRST idh_hist */

         end. /* IF NOT AVAILABLE sod_det */

      end. /* IF ship_line.abs_line <> "" */

      /* DISPLAY OTHER INFO FOR THE RECORD IN THE LOWER FRAME */
      display
         ship_line.abs_order @ part_order
         ship_line.abs_line  @ part_order_line
         ship_line.abs_qty
         l_abs_pick_qty
         l_abs_tare_wt
         ship_line.abs_wt_um @ l_twt_um
         ship_line.abs__qad02
         ship_line.abs_site
         ship_line.abs_loc
         ship_line.abs_nwt
         ship_line.abs_wt_um
         ship_line.abs_lotser
         ship_line.abs_gwt
         ship_line.abs_wt_um @ gwt_um
         ship_line.abs_ref
         sod_type     when (available sod_det)
         ""           when (not available sod_det) @ sod_type
         ship_line.abs_vol
         ship_line.abs_vol_um
         cnsm_req
         pt_desc1     when (available pt_mstr)
         ""           when (not available pt_mstr) @ pt_desc1
         l_contr_id @ sod_contr_id
         cmmts
         cancel_bo
         ship_line.abs_fa_lot
      with frame sample.

      l_prev_pick_qty = l_abs_pick_qty.

      /* HANDLE THE UPPER FRAME INTERFACE ONLY IN NON-BATCH MODE */
      if not batchrun then do:

         /* ENABLE UPPER FRAME FOR INPUT */
         set first_column
            with frame k
         editing:

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
               or lastkey = keycode("PF3")
               or lastkey = keycode("CTRL-T")
               or keyfunction(lastkey) = "GO"
               or keyfunction(lastkey) = "END-ERROR"
               or lastkey = keycode("F4")
               or lastkey = keycode("RETURN")
               or keyfunction(lastkey) = "page-up"
               or lastkey = keycode("F7")
               or keyfunction(lastkey) = "page-down"
               or lastkey = keycode("F8")
               or ({gpiswrap.i} and
                   (keyfunction(lastkey) = "help" or lastkey = keycode(" ")))
               or lastkey = keycode("CTRL-E")
            then
               leave.

         end. /* EDITING */

         if {gpiswrap.i} and keyfunction(lastkey) = "help" then do:
            apply lastkey.
            next EDITLOOP.
         end.

         /* HANDLE THE END-ERROR KEY */
         if lastkey = keycode("F4")
            or keyfunction(lastkey) = "END-ERROR"
         then do:
            if l_match_so
            then do:
            /* ENSURE THAT LINE ITEM(S) HAVE MATCHING SALES ORDER. CHECK NOW? */
               {pxmsg.i &MSGNUM=5881
                        &ERRORLEVEL=2
                        &CONFIRM=cont_yn}
               l_match_so = no.
               if cont_yn
               then
                  next editloop.
            end. /* IF l_match_so */
            leave EDITLOOP.
         end. /* IF LASTKEY = KEYCODE ("F4") */

         if (lastkey = keycode("F9")
            or keyfunction(lastkey) = "CURSOR-UP"
            or lastkey = keycode("F10")
            or keyfunction(lastkey) = "CURSOR-DOWN")
            or keyfunction(lastkey) = "page-up"
            or lastkey = keycode("F7")
            or keyfunction(lastkey) = "page-down"
            or lastkey = keycode("F8")
         then do:

            run navigate_proc.

         end. /* IF CURSOR KEYS */

         cmmts = ship_line.abs_cmtindx > 0.

         /* HANDLE GO KEY */
         if (lastkey = keycode("F1")
            or lastkey = keycode("PF1")
            or lastkey = keycode("CTRL-X")
            or lastkey = keycode("RETURN")
            or keyfunction(lastkey) = "GO")
            or ({gpiswrap.i} and lastkey = keycode(" "))
         then

         SET_DATA:
         do on endkey undo SET_DATA, leave SET_DATA
            on error undo SET_DATA, retry SET_DATA:

            if ship_line.abs_id begins "i" then do:

               /* GET THE OPEN QTY FOR THE SALES ORDER LINE */
               for first so_mstr
                  fields (so_domain so_nbr  so_sched so_primary so_secondary
                          so_bill   so_ship so_cust  so_fsm_type so_fr_terms
                          so_po so_seq_order)
                  where so_domain = global_domain
                  and   so_nbr = ship_line.abs_order
               no-lock:

               end. /* FOR FIRST SO_MSTR */

               empty temp-table abs-tt .
               if available so_mstr and not so_sched
               then do:

                  run create_tt (input sod_nbr,
                                 input sod_line,
                                 input sod_part ) .

               end. /* IF AVAILABLE so_mstr */

               /* GET THE TRANSACTION TYPE OF THE SHIPPER */
               {gprun.i ""icshtyp.p""
                        "(input recid(ship_line),
                          output l_tr_type)"}

               find first abs_child_buff
                  use-index abs_par_id
                  where abs_child_buff.abs_domain = global_domain
                  and   abs_child_buff.abs_shipfrom = ship_line.abs_shipfrom
                  and   abs_child_buff.abs_par_id = ship_line.abs_id
                  and   abs_child_buff.abs_id begins "i"
               no-lock no-error.

               {&RCSHWBB-P-TAG1}

               status input stline[1].

              assign
                  l_orig_order = ship_line.abs_order
                  l_orig_line  = ship_line.abs_line  .

               set
                  part_order when (ship_line.abs_id begins "i" and
                                   l_tr_type = "ISS-SO"        and
                                  not available abs_child_buff and
                                  not ship_line.abs_par_id begins "i")

                  part_order_line when (ship_line.abs_id begins "i" and
                                        l_tr_type = "ISS-SO"        and
                                       not available abs_child_buff and
                                       not ship_line.abs_par_id begins "i")
               with frame sample
                  {&RCSHWBB-P-TAG2}
                  editing:
                     if frame-field <> "" then
                        vLastField = frame-field.

                     if frame-field = "part_order" or
                        frame-field = "part_order_line"
                     then do:
                        {mfnp10.i sod_det
                                  part_order
                                  "sod_domain = global_domain and sod_nbr "
                                  part_order_line
                                  string(sod_line)
                                  "and ship_line.abs_item = sod_part"}
                        if recno <> ? then
                           display
                              sod_nbr @ part_order
                              string(sod_line) @ part_order_line
                           with frame sample.
                     end. /*IF FRAME-FIELD = "PART_ORDER" OR*/
                     else do:
                        readkey.
                        apply lastkey.
                     end. /*ESLE DO*/

                     if (go-pending or (vLastField <> frame-field))  and
                        (using_container_charges or using_line_charges)
                     then do:
                        run getUserFieldData (input yes,
                                              input vLastField,
                                              input ship_line.abs_id,
                                              input ship_line.abs_shipfrom).
                     end. /* IF GO-PENDING last-field <> frame-field */
                  end. /* editing */
/*zy*/   find so_mstr
/*zy*/        where so_domain = global_domain
/*zy*/        and   so_nbr = part_order
/*zy*/     exclusive-lock no-error.
/*zy*/     if available so_mstr and so__chr06 = "" then do:
/*zy*/     assign so__chr06 = string(so_trl1_amt) + ";"
/*zy*/                      + string(so_trl2_amt) + ";"
/*zy*/                      + string(so_trl3_amt).
/*zy*/     end.
/*zy get qty_avaiable*/
/*zy*/   assign qty_avaiable= 0.
/*zy*/   find first sod_det no-lock where sod_det.sod_domain = global_domain
/*zy*/          and sod_det.sod_nbr = part_order and
/*zy*/              sod_det.sod_line = integer(part_order_line)  no-error.
/*zy*/   if avail sod_det then do:
/*zy*/      assign qty_avaiable = sod_qty_ord - sod_qty_ship.
/*zy*/   end.
               find abs_parent_buff
                  where abs_parent_buff.abs_domain = global_domain
                  and   recid(abs_parent_buff) = parent_abs_recid
               no-lock no-error.

               {&RCSHWBB-P-TAG3}

               if not ship_line.abs_par_id begins "i"
                  and l_tr_type = "ISS-SO"
                  and not available abs_child_buff
               then do:

                  {&RCSHWBB-P-TAG4}

                  if part_order <> "" then do:
                     {gprun.i ""rcshsov.p""
                              "(input recid(ship_line),
                                input parent_abs_recid,
                                input abs_parent_buff.abs_format,
                                input part_order,
                                input part_order_line,
                                input shipto_code,
                                output so_ok)"}

                     if use-log-acctg then do:
                        /* VALIDATE SALES ORDER FREIGHT TERMS */
                        run validateSOFrTerms (input ship_line.abs_id,
                                               input ship_line.abs_shipfrom,
                                               input parent_abs_recid,
                                               input part_order,
                                               output l_FrTermsOnFirstOrder,
                                               output l_FrTermsErr).

                        if l_FrTermsErr then do:
                           /* ALL ATTACHED ORDERS MUST HAVE FREIGHT TERMS # */
                           run p-pxmsg (input 5056,
                                        input 3,
                                        input l_FrTermsOnFirstOrder).

                           so_ok = no.
                        end. /* IF l_FrTermsErr */
                     end.   /* if use-log-acctg */

                  end. /* part_order <> "" */
                  else do:
                     so_ok = no.
                     /* BLANK NOT ALLOWED */
                     run p-pxmsg (input 40,
                                  input 3,
                                  input "").
                  end. /* part_order = "" */

                  if not so_ok then do:
                     undo set_data, retry set_data.
                  end.
               end. /* if not ship_line.abs_par_id begins "i" */
               else
                  assign
                     part_order = ship_line.abs_order
                     part_order_line = ship_line.abs_line.

               {&RCSHWBB-P-TAG5}

               if l_tr_type = "ISS-SO" then
               {&RCSHWBB-P-TAG6}
                  find first sod_det
                     where sod_det.sod_domain = global_domain
                     and   sod_det.sod_nbr = part_order
                     and   sod_det.sod_line = integer(part_order_line)
                  no-lock.

               l_order_change = no.
/*zy*/         assign qty_avaiable = sod_qty_ord - sod_qty_ship.
               if part_order <> ship_line.abs_order
               then do:

                  if ship_line.abs_order <> "" then do:

                     /* SET GLOBAL_DB USING ABS_SITE */
                     new_site = ship_line.abs_site.
                     {gprun.i ""gpalias.p""}

                     /* SWITCH TO THE INVENTORY SITE */
                     if so_db <> global_db then do:
                        {gprun.i ""gpalias2.p""
                                 "(input ship_line.abs_site, output errornum)"}

                        if errornum <> 0 and errornum <> 9 then do:
                           /* DOMAIN # IS NOT AVAILABLE */
                           run p-pxmsg (input 6137,
                                        input 4,
                                        input l_msgar1[2]).
                           undo SET_DATA, retry SET_DATA.
                        end.
                     end.

                     {gprun.i ""soitallb.p""
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
                                output tmp_qty,
                                output undotran)"}

                     if undotran then
                        undo set_data, retry set_data.

                     /* SWITCH BACK TO THE SALES ORDER DOMAIN */
                     if so_db <> global_db then do:

                        /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
                        /* IN REMOTE DOMAIN                         */
                        {gprun.i ""sosopka2.p""
                                 "(input ship_line.abs_order,
                                   input integer (ship_line.abs_line),
                                   input (- l_abs_pick_qty *
                                         decimal(ship_line.abs__qad03)),
                                   input l_delproc)"}

                        {gprun.i ""gpalias3.p""
                                 "(input so_db, output errornum)"}
                        if errornum <> 0 and errornum <> 9 then do:
                           /* DOMAIN # IS NOT AVAILABLE */
                           run p-pxmsg (input 6137,
                                        input 4,
                                        input l_msgar1[1]).
                           undo SET_DATA, retry SET_DATA.
                        end.
                     end.

                     {gprun.i ""sosopka2.p""
                              "(input ship_line.abs_order,
                                input integer (ship_line.abs_line),
                                input (- l_abs_pick_qty *
                                      decimal(ship_line.abs__qad03)),
                                input l_delproc )"}
                  end. /* ship_line.abs_order <> "" */

                  assign
                     l_order_change      = yes
                     ship_line.abs_order = part_order
                     ship_line.abs_line = part_order_line.

                  if (ship_line.abs_par_id begins  "i") then
                     assign
                        ship_line.abs_id = ship_line.abs_par_id
                                         +  ship_line.abs_site
                                         +  ship_line.abs_order
                                         +  ship_line.abs_line
                                         +  ship_line.abs_item
                                         +  ship_line.abs_loc
                                         +  ship_line.abs_lot
                                         +  ship_line.abs_ref
                                         +  ship_line.abs_fa_lot.
                  else
                     assign
                        ship_line.abs_id = "i"
                                         + ship_line.abs_par_id
                                         + ship_line.abs_site
                                         + ship_line.abs_order
                                         + ship_line.abs_line
                                         + ship_line.abs_item
                                         + ship_line.abs_loc
                                         + ship_line.abs_lot
                                         + ship_line.abs_ref
                                         + ship_line.abs_fa_lot.

               end. /* if part_order <> ship_line.abs_order ... */

               {gprun.i ""gpsiver.p""
                        "(input ship_line.abs_site,
                          input ?, output return_int)"}
               if return_int = 0 then do:
                  /* USER DOES NOT HAVE ACCESS TO THIS SITE */
                  run p-pxmsg (input 725,
                               input 3,
                               input "").
                  undo, retry.
               end.

               /* Show available quantity if able to edit quantities */
               if v_editall then do:

                  /* SET GLOBAL_DB USING ABS_SITE */
                  new_site = ship_line.abs_site.
                  {gprun.i ""gpalias.p""}

                  /* SWITCH TO THE INVENTORY SITE */
                  if so_db <> global_db then do:
                     {gprun.i ""gpalias2.p""
                        "(ship_line.abs_site, output errornum)"}
                     if errornum <> 0 and errornum <> 9 then
                        /* DOMAIN # IS NOT AVAILABLE */
                        run p-pxmsg (input 6137,
                                     input 4,
                                     input l_msgar1[2]).
                  end.

                  /* GET QTY AVAILABLE TO ALLOCATE  AND DISPLAY IT */
                  {gprun.i ""soitallb.p""
                           "(input ship_line.abs_order,
                             input ship_line.abs_line,
                             input ship_line.abs_item,
                             input ship_line.abs_site,
                             input ship_line.abs_loc,
                             input ship_line.abs_lotser,
                             input ship_line.abs_ref,
                             input "0",
                             input "0",
                             input del_lad,
                             input l_delproc,
                             output avail_qty,
                             output tmp_qty,
                             output undotran)"}

                  if undotran then
                     undo set_data, retry set_data.

                        /* SWITCH BACK TO THE SALES ORDER DOMAIN */
                        if so_db <> global_db then do:
                           {gprun.i ""gpalias3.p""
                                    "(input so_db, output errornum)"}
                           if errornum <> 0 and errornum <> 9 then
                              /* DOMAIN # IS NOT AVAILABLE */
                              run p-pxmsg (input 6137,
                                           input 4,
                                           input l_msgar1[1]).
                        end.

                        if available sod_det and sod_type = "" then do:
                          /* QUANTITY AVAILABLE IN SITE LOCATION FOR LOT/SER*/
                           run p-pxmsg (input 208,
                                        input 1,
                                        input avail_qty).

                  display l_abs_pick_qty with frame sample.
               end.

            end.  /* if v_editall */

            {absupack.i  "ship_line" 3 22 "l_abs_pick_qty"}

            display l_abs_pick_qty with frame sample.

            /* SAVE NET WEIGHT FOR LATER COMPARISON */
            assign
               nwt_old   = ship_line.abs_nwt
               l_twt_old = l_abs_tare_wt
               vol_old   = ship_line.abs_vol
               qty_old   = ship_line.abs_qty

               old_qty   = l_abs_pick_qty
               old_site  = ship_line.abs_site
               old_loc   = ship_line.abs_loc
               old_lot   = ship_line.abs_lot
               old_ref   = ship_line.abs_ref
               kit_comp  =  (ship_line.abs_par_id begins  "i").

            if available so_mstr
               and so_secondary
            then do:
               find trq_mstr
                  where trq_domain = global_domain
                  and  (trq_doc_type = "SO"
                  and   trq_doc_Ref  = so_nbr
                  and   trq_add_ref  = ""
                  and  (trq_msg_type = "ORDRSP-I"
                  or    trq_msg_type = "ORDRSP-C"))
               no-lock no-error.

               if available trq_mstr then do:
                  /* CHANGE ON EMT ORDER WITH PENDING CHANGE IS NOT ALLOWED */
                  run p-pxmsg (input 2834,
                               input 3,
                               input "").
                  undo SET_DATA, leave SET_DATA.
               end.
            end.

            if (available so_mstr and so_secondary)
               and (available sod_det and not sod_sched
               and sod_qty_ship = 0)
            then
               cmf_flg = yes.
            else
               cmf_flg = no.

         end. /* IF SHIP_LINE.ABS_ID BEGINS "i" */

         else do:
            assign
               nwt_old = ship_line.abs_nwt
               vol_old = ship_line.abs_vol
               qty_old = ship_line.abs_qty.

            if ship_line.abs_id begins "p"
               or ship_line.abs_id begins "s"
            then
               assign
                  part_order      = ship_line.abs_order
                  part_order_line = ship_line.abs_line.
         end.

         {absupack.i  "ship_line" 26 22 "l_abs_tare_wt"}

         assign l_twt_old = l_abs_tare_wt.


         /* CHECK LOCAL VARIABLE fas_so_rec POSSIBLY FROM REMOTE DOMAIN */
         set
            part_order when (using_container_charges and
                             substring(ship_line.abs_id,1,1) = "c")
            part_order_line when (using_container_charges and
                                  substring(ship_line.abs_id,1,1) = "c")
            ship_line.abs_qty when
               (v_editall and ship_line.abs_id begins "i")
            l_abs_pick_qty when
               (v_editall                   and
                available sod_det           and
                sod_type = ""               and
                ship_line.abs_qty > 0       and
                ship_line.abs_id begins "i" and
                not ship_line.abs_canceled)
            ship_line.abs_nwt when
               (substring(ship_line.abs_id,1,1) = "i")
            l_abs_tare_wt when
               (substring(ship_line.abs_id,1,1) = "s")
            or (substring(ship_line.abs_id,1,1) = "c")
            or (substring(ship_line.abs_id,1,1) = "p")
            ship_line.abs_vol
            ship_line.abs_site when
               (v_editall and ship_line.abs_id begins "i")
            ship_line.abs_loc  when
               (v_editall and ship_line.abs_id begins "i")
            ship_line.abs_lotser  when
               (v_editall and ship_line.abs_id begins "i")
            ship_line.abs_ref  when
               (v_editall and ship_line.abs_id begins "i")
            cnsm_req when
               (v_editall and ship_line.abs_id begins "i")
            ship_line.abs_fa_lot when
               (v_editall                   and
                ship_line.abs_id begins "i" and
                available sod_det           and
                fas_so_rec = string(true)   and
                fac_wo_rec = no             and
                (sod_cfg_type = "1" or
                 sod_fa_nbr <> "" ))
            cmmts
            cancel_bo when
               (v_editall and ship_line.abs_id begins "i")
         with frame sample
            editing:

            status input stline[1].
            if frame-field <> "" then
               vLastField = frame-field.

            assign
               global_site = input ship_line.abs_site
               global_loc  = input ship_line.abs_loc
               global_part =       ship_line.abs_item
               global_lot  = input ship_line.abs_lotser.

            readkey.

            if last-key = keycode("F4")           or
               keyfunction(lastkey) = "END-ERROR" or
               keyfunction(lastkey) = "ENDKEY"
            then do:
               /* REFRESHING LOWER SCREEN   */
               empty temp-table abs-tt .
               run ip-refresh.
            end.

            /* CHECK FOR EXISTING RECORD HAVING SAME               */
            /* SITE/ LOCATION/ LOT-SERIAL/ REFERENCE COMBINATION   */
            /* AT SAME SHIPPER LEVEL FOR CORRESPONDING SALES ORDER */
            else do:
               l_undochk = no.
               if (lastkey             = keycode("F1")
               or  lastkey             = keycode("PF1")
               or  lastkey             = keycode("CTRL-X")
               or (frame-field         = "cancel_bo"     and
                   lastkey             = keycode("RETURN"))
               or keyfunction(lastkey) = "GO")
               and
                  (  old_site <>  ship_line.abs_site:screen-value
                  or old_loc  <>  ship_line.abs_loc:screen-value
                  or old_lot  <>  ship_line.abs_lot:screen-value
                  or old_ref  <>  ship_line.abs_ref:screen-value )
               then do:
                  if kit_comp then do:

                     if can-find (first abs_mstr
                        where abs_mstr.abs_domain = global_domain
                        and   abs_mstr.abs_shipfrom = ship_line.abs_shipfrom
                        and   abs_mstr.abs_id begins ship_line.abs_par_id
                        and   abs_mstr.abs_order = ship_line.abs_order
                        and   abs_mstr.abs_line = ship_line.abs_line
                        and   abs_mstr.abs_item = ship_line.abs_item
                        and   abs_mstr.abs_site =
                              ship_line.abs_site:screen-value
                        and   abs_mstr.abs_loc = ship_line.abs_loc:screen-value
                        and   abs_mstr.abs_lot = ship_line.abs_lot:screen-value
                        and   abs_mstr.abs_ref = ship_line.abs_ref:screen-value
                     use-index abs_id)
                     then
                        l_undochk = yes.
                  end. /* IF kit_comp */
                  else do:

                     if can-find (first abs_mstr
                        where abs_mstr.abs_domain = global_domain
                        and   abs_mstr.abs_shipfrom = ship_line.abs_shipfrom
                        and   abs_mstr.abs_id  begins "i" +
                              ship_line.abs_par_id
                        and   abs_mstr.abs_order = ship_line.abs_order
                        and   abs_mstr.abs_line = ship_line.abs_line
                        and   abs_mstr.abs_item = ship_line.abs_item
                        and   abs_mstr.abs_site =
                              ship_line.abs_site:screen-value
                        and   abs_mstr.abs_loc = ship_line.abs_loc:screen-value
                        and   abs_mstr.abs_lot = ship_line.abs_lot:screen-value
                        and   abs_mstr.abs_ref = ship_line.abs_ref:screen-value
                     use-index abs_id)
                     then
                        l_undochk = yes.

                     /* CHECK IF THE SERIAL IS ALREADY ATTACHED */
                     /* AT ANY LEVEL IN SHIPPER                 */
                     if (available pt_mstr)
                        and (pt_lot_ser = "S")
                     then do:

                        run p_chk_serial(input ship_from,
                                         input global_recid,
                                         input ship_line.abs_item,
                                         input ship_line.abs_lot:screen-value,
                                         output l_allowed).

                        if l_allowed = yes
                        then
                           l_undochk = yes.

                     end. /* IF pt_lot_ser = "S" */

                  end. /* ELSE DO */

                  if l_undochk then do:
                     /* YOU CANNOT HAVE MULTIPLE ITEMS FOR */
                     /* SAME SITE /LOC /LOT-SERIAL /REF... */
                     {mfmsg.i 753 3}
                     undo set_data, retry set_data.
                  end. /* IF l_undochk */
                  else
                     leave.
               end. /* IF LASTKEY... */
            end. /* ELSE DO */

            apply lastkey.

            if (go-pending or (vLastField <> frame-field))  and
               (using_container_charges or using_line_charges) then do:
                /* Update shipper field specific user fields */
                run getUserFieldData
                   (input yes,
                    input vLastField,
                    input ship_line.abs_id,
                    input ship_line.abs_shipfrom).

                /* Update non-specific shipper field user fields */
                if go-pending then
                   run getUserFieldData
                      (input no,
                       input vLastField,
                       input ship_line.abs_id,
                       input ship_line.abs_shipfrom).
            end. /* IF GO-PENDING last-field <> frame-field */
         end. /* EDITING */

         if using_container_charges
            and (part_order <> "" or part_order_line <> "")
         then do:
            run ValidateSalesOrderLine
               (input part_order,
                input part_order_line,
                input ship_line.abs_shipfrom,
                input shipto_code,
                output vErrorOrder,
                output vErrorOrderLine,
                output vErrorMsgNumber,
                output vErrorSite).

            if not vErrorOrder
               and not vErrorOrderLine
            then
               assign
                  ship_line.abs_order = part_order
                  ship_line.abs_line = part_order_line.

            if vErrorOrder then do:
               if vErrorMsgNumber >= 8228 then
                  /*SO SHIPTO or SHIPFROM is invalid*/
                  run p-pxmsg (input vErrorMsgNumber,
                               input 3,
                               input vErrorSite).
               else run p-pxmsg (input vErrorMsgNumber,
                                 input 3,
                                 input "").
               next-prompt part_order with frame sample.
               undo set_data, retry set_data.
            end. /*IF vErrorOrder*/
            else if vErrorOrderLine then do:
               run p-pxmsg (input vErrorMsgNumber,
                            input 3,
                            input "").
               next-prompt part_order_line with frame sample.
               undo set_data, retry set_data.
            end.
         end. /* IF USING_CONTAINER*/

         if truncate(qty_old, 4) = ship_line.abs_qty then
            assign
               ship_line.abs_qty = qty_old.

         if truncate(old_qty, 4) = l_abs_pick_qty then
            assign
               l_abs_pick_qty = old_qty.

         if not kit_comp
            and qty_old <> ship_line.abs_qty
            and can-find (first sob_det
            where sob_domain = global_domain
            and   sob_nbr    = sod_nbr
            and   sob_line   = sod_line)
         then do:

            l_confirm_comp = yes.

            /* RECALCULATE QUANTITY FOR COMPONENTS */
           run p-pxmsgconfirm (input 6396,
                               input 1,
                               input-output l_confirm_comp).

            if l_confirm_comp then do:

               l_abs_qty = 0.

               for each sob_det
                  fields (sob_domain sob_line sob_nbr sob_part sob_qty_req)
                  where   sob_domain = global_domain
                  and     sob_nbr    = sod_nbr
                  and     sob_line   = sod_line
               no-lock
               break by sob_part:

                  l_abs_qty = l_abs_qty
                            + ((sob_qty_req * ship_line.abs_qty)
                            / sod_qty_ord).

                  if last-of (sob_part) then do:

                     for first abs_child_buff
                        where abs_child_buff.abs_domain = global_domain
                        and   abs_child_buff.abs_par_id begins ship_line.abs_id
                        and   abs_child_buff.abs_item   = sob_part
                     exclusive-lock:

                        /* CHECK FOR RESTRICTED TRANSACTION */
                        for first ld_det
                           fields (ld_domain ld_loc ld_lot  ld_part   ld_qty_all
                                   ld_ref ld_site ld_status ld_qty_oh)
                           where   ld_domain = global_domain
                           and     ld_part   = abs_child_buff.abs_item
                           and     ld_lot    = abs_child_buff.abs_lot
                           and     ld_ref    = abs_child_buff.abs_ref
                           and     ld_site   = abs_child_buff.abs_site
                           and     ld_loc    = abs_child_buff.abs_loc
                        no-lock:

                           for first isd_det
                              fields (isd_domain isd_bdl_allowed
                                      isd_status isd_tr_type)
                              where   isd_domain = global_domain
                              and     isd_status         = ld_status
                              and     isd_tr_type        = "ISS-FAS"
                           no-lock:

                              if (batchrun              = no
                                 or (batchrun           = yes
                                 and isd_bdl_allowed = no))
                              then do:

                                 /* RESTRICTED TRANSACTION FOR STATUS CODE: */
                                 run p-pxmsg (input 373,
                                              input 3,
                                              input isd_status).
                                 undotran = yes.

                              end. /* IF batchrun = no... */

                           end. /* FOR FIRST isd_det */

                        end. /* FOR FIRST ld_det */

                        if not undotran then do:

                           run check-reserved-location.

                           if ret-flag = 0 then do:

                              /* THIS LOCATION RESERVED FOR ANOTHER CUSTOMER */
                              run p-pxmsg (input 3346,
                                           input 3,
                                           input "").

                              undotran = yes.

                           end. /* IF ret-flag = 0 */

                        end. /* IF NOT undotran */

                        if ret-flag = 2
                           and not undotran
                        then do:

                           /* CHECK FOR OVERSHIPMENT */
                           for first ld_det
                              fields (ld_domain ld_loc ld_lot  ld_part ld_site
                                      ld_qty_all ld_ref ld_status ld_qty_oh)
                              where   ld_domain = global_domain
                              and     ld_part   = abs_child_buff.abs_item
                              and     ld_lot    = abs_child_buff.abs_lot
                              and     ld_ref    = abs_child_buff.abs_ref
                              and     ld_site   = abs_child_buff.abs_site
                              and     ld_loc    = abs_child_buff.abs_loc
                           no-lock:
                              l_stat = ld_status.
                           end.

                           if not available ld_det then do:
                              for first loc_mstr
                                 fields (loc_domain loc_loc loc_site loc_status)
                                 where   loc_domain = global_domain
                                 and     loc_site   = abs_child_buff.abs_site
                                 and     loc_loc    = abs_child_buff.abs_loc
                              no-lock:
                                 l_stat = loc_status.
                              end.

                              if not available loc_mstr then
                                 for first si_mstr
                                    fields (si_domain si_site si_status)
                                    where   si_domain = global_domain
                                    and     si_site = abs_child_buff.abs_site
                                 no-lock:
                                    l_stat = si_status.
                                 end.

                           end. /*IF NOT AVAILABLE ld_det */

                           if available ld_det then
                              if (l_abs_qty - abs_child_buff.abs_qty) >
                                 max (ld_qty_oh - ld_qty_all, 0)
                                 and can-find (first is_mstr
                                where is_domain    = global_domain
                                 and   is_status    = l_stat
                                 and   is_overissue = false)
                              then do:

                               /*OVERISSUE FOR THIS SITE/LOCATION NOT ALLOWED */
                               run p-pxmsg (input 1283,
                                            input 3,
                                            input "").
                                 undotran = yes.

                              end. /* IF CAN-FIND (FIRST is_mstr...) */

                        end. /* IF ret-flag = 2 */

                        assign
                           abs_child_buff.abs_qty = l_abs_qty
                           l_abs_qty              = 0.

                        if undotran then
                           undo SET_DATA, retry SET_DATA.

                     end. /* FOR FIRST abs_child_buff */

                  end. /* IF LAST-OF (sob_part) */

               end. /* FOR EACH sob_det */

            end. /* IF l_confirm_comp */

         end. /* IF NOT kit_comp */

         assign
            abs_recid   = recid(ship_line)
            l_abs_recid = recid(ship_line)
            sort_recs   = true.

         {abspack.i "ship_line" 26 22 "l_abs_tare_wt"}

         l_part_qty = (ship_line.abs_qty - qty_old)
                    * decimal(ship_line.abs__qad03).

         for first so_mstr
            fields (so_domain so_nbr  so_sched so_primary  so_secondary
                    so_bill   so_ship so_cust  so_fsm_type so_fr_terms
                    so_po     so_seq_order)
            where so_domain = global_domain
            and   so_nbr    = ship_line.abs_order
         no-lock:
         end. /* FOR FIRST so_mstr */

         if  available so_mstr
         and not so_sched
         then do:

            assign
               l_tmp_qty         = ship_line.abs_qty
               ship_line.abs_qty = qty_old.
            if ( l_orig_order = ""    )
            or ( l_orig_order  <>  ship_line.abs_order )
            or ( l_orig_line   <>  string(sod_line) )
            then do:
               if not can-find (abs-tt where abs-tt-nbr = sod_nbr
                                         and abs-tt-item = sod_part
                                         and abs-tt-line  = string(sod_line))
               then do:

                  /* CREATE TEMP-TABLE TO STORE QUALIFYING SHIPPER RECORDS */
                  /* FOR THE ORDER LINE IN FOCUS                           */

                  run create_tt ( input sod_nbr,
                                  input sod_line,
                                  input sod_part ) .
               end. /* IF NOT CAN-FIND (abs-tt ) */
               /*  NEED TO EXPLICITLY CREATE A TEMP TABLE RECORD IN ORDER    */
               /*  TO COMPUTE THE open_qty , AS IN ORACLE , THE SALES ORDER  */
               /* BEING ASSOCIATED WITH THE CONTAINER DOES NOT GET COMMITTED */
               /* INTO THE DB , AT THIS POINT OF THE WORKFLOW                */

               if not can-find (first abs-tt
               where abs-tt-id = ship_line.abs_id)
               then do:

                  create abs-tt.
                  assign
                     abs-tt-id    = ship_line.abs_id
                     abs-tt-nbr   = ship_line.abs_order
                     abs-tt-item  = ship_line.abs_item
                     abs-tt-line  = ship_line.abs_line
                     abs-tt-qty   = (ship_line.abs_qty - ship_line.abs_ship_qty
                                   - l_abs_pick_qty ) *
                                     decimal(ship_line.abs__qad03 ) .

               end. /* IF NOT CAN-FIND (FIRST abs-tt */

            end. /* IF l_orig_order = "" .. */


            /* COMPUTE OPEN QTY */
            run  compute_openqty (input sod_nbr ,
                                  input sod_line ,
                                  input sod_part ,
                                  output open_qty)   .
            ship_line.abs_qty = l_tmp_qty.
            if ship_line.abs_qty > qty_avaiable then do:
               /**zy 发货数量不可大于订单量*/
               run p-pxmsg (input 25070,
                           input 3,
                           input "").
               undo SET_DATA, retry SET_DATA.
            end.
            if ((sod_qty_ord >= 0  and
               ((l_part_qty ) / sod_um_conv) > open_qty )  or
               (sod_qty_ord < 0  and
               ((l_part_qty ) / sod_um_conv) < open_qty ))
            then do:
               /* QTY ORDERED CANNOT BE LESS THAN ALLOCATED */
               /* + PICKED + SHIPPED                        */
               run p-pxmsg (input 4999,
                            input 2,
                            input "").
            end. /* IF PART_QTY > OPEN_QTY */
         end. /* IF AVAILABLE so_mstr AND ... */

         {abspack.i "ship_line" 3 22 "l_abs_pick_qty"}

         l_lad_qty_all = 0.

         for first lad_det
            fields (lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
                    lad_part lad_qty_all lad_qty_pick lad_ref lad_site)
            where lad_domain  = global_domain
            and   lad_dataset = "sod_det"
            and   lad_nbr     = ship_line.abs_order
            and   lad_line    = ship_line.abs_line
            and   lad_part    = ship_line.abs_item
            and   lad_site    = ship_line.abs_site
            and   lad_loc     = ship_line.abs_loc
            and   lad_lot     = ship_line.abs_lot
            and   lad_ref     = ship_line.abs_ref
         no-lock:
            l_lad_qty_all = lad_qty_all.
         end.

         for first lad_det
            fields (lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
                    lad_part lad_qty_all lad_qty_pick lad_ref lad_site)
            where lad_det.lad_domain = global_domain
            and   lad_dataset = "sob_det"
            and    lad_nbr     = ship_line.abs_order
            and    lad_line    = ship_line.abs_line
            and    lad_part    = ship_line.abs_item
            and    lad_site    = ship_line.abs_site
            and    lad_loc     = ship_line.abs_loc
            and    lad_lot     = ship_line.abs_lot
            and    lad_ref     = ship_line.abs_ref
         no-lock:
            l_lad_qty_all = lad_qty_all.
         end.

         /* UPDATE avail_qty AND l_prev_pick_qty IF THERE  */
         /* IS A CHANGE IN SITE, LOCATION, LOT/SERIAL OR   */
         /* REFERENCE.                                     */
         if old_site <> ship_line.abs_site or
            old_loc  <> ship_line.abs_loc  or
            old_lot  <> ship_line.abs_lot  or
            old_ref  <> ship_line.abs_ref
         then do:
            assign
               avail_qty = 0
               l_prev_pick_qty = 0.

            /* SET GLOBAL DB USING abs_site */
            {gprun.i ""gpalias.p""}

            /* SWITCH OVER TO THE LINE SITE'S DOMAIN */
            if so_db <> global_db
            then do:
               {gprun.i ""gpalias2.p""
                  "(input  ship_line.abs_site,
                    output errornum)"}

               if errornum     <> 0
                  and errornum <> 9
               then do:
                  /* DOMAIN # IS NOT CONNECTED */
                  run p-pxmsg (input 6137,
                               input 4,
                               input l_msgar1[2]).

                  undo SET_DATA, retry SET_DATA .
               end. /* IF errornum <> 0 AND errornum <> 9 */

            end. /* IF so_db <> global_db */

            /* THE LOGIC TO UPDATE avail_qty FROM ld_det   */
            /* IS MOVED TO THE PROGRAM rcldqad.p           */
            {gprun.i ""rcldqad.p""
               "(input  ship_line.abs_site,
                 input  ship_line.abs_loc,
                 input  ship_line.abs_item,
                 input  ship_line.abs_lotser,
                 input  ship_line.abs_ref,
                 output avail_qty)"}

            /* SWITCH OVER TO THE HEADER SITE'S DOMAIN */
            {gprun.i ""gpalias3.p""
               "(input  so_db,
                 output errornum)"}

            if errornum     <> 0
               and errornum <> 9
            then do:
               /* DOMAIN # IS NOT CONNECTED */
               run p-pxmsg (input 6137,
                            input 4,
                            input l_msgar1[1]).

               undo SET_DATA, retry SET_DATA.
            end. /* IF errornum <> 0 AND errornum <> 9 */

         end. /* IF old_site <> ship_line.abs_site ... */
         if avail_qty < 0 then
            run p-alloclad.

         if (ship_line.abs_qty     >= 0
            and l_abs_pick_qty    >  0)
            or (ship_line.abs_qty  <  0
            and l_abs_pick_qty >= 0)
         then

         if l_abs_pick_qty > ship_line.abs_qty
         then do:
            /* PICK QUANTITY EXCEEDS SHIP QUANTITY */
            run p-pxmsg (input 2525,
                         input 3,
                         input "").
            undo SET_DATA, retry SET_DATA.
         end. /* IF L_ABS_PICK_QTY > SHIP_LINE.ABS_QTY */

         l_avail_qty  = max(l_lad_qty_all - v_unpicked_qty, avail_qty).

         if l_abs_pick_qty * decimal(ship_line.abs__qad03)
            > (l_avail_qty + l_lad_qty_all
            + l_prev_pick_qty * decimal(ship_line.abs__qad03))
            and ship_line.abs_qty > 0
            and l_abs_pick_qty * decimal(ship_line.abs__qad03) > 0
         then do:
            /* QUANTITY AVAILABLE IN SITE LOCATION FOR LOT/SERIAL */
            run p-pxmsg (input 208,
                         input 3,
                         input l_avail_qty).
            undo SET_DATA, retry SET_DATA.
         end. /* IF l_abs_pick_qty > (avail_qty ...) */

         find ld_det
            where ld_domain = global_domain
            and   ld_site = ship_line.abs_site
            and   ld_loc  = ship_line.abs_loc
            and   ld_part = ship_line.abs_item
            and   ld_lot  = ship_line.abs_lotser
            and   ld_ref  = ship_line.abs_ref
         no-lock no-error.

         /* THIS MESSAGE IS ADDED SO THAT IF THE USERS ENTERS A QUANTITY    */
         /* GREATER THAN QTY AVAILABLE FOR A VALID LOCATION LOT/SERIAL THEN */
         /* THE SYSTEM WILL GIVE AN ERROR NOT ALLOWING THE USER TO PROCEED. */
         if available ld_det and
            l_abs_pick_qty * decimal(ship_line.abs__qad03) >
            (qty_old - old_qty) * decimal(ship_line.abs__qad03) +
            max(ld_qty_oh - ld_qty_all,0) +
            old_qty * decimal(ship_line.abs__qad03)
            and ship_line.abs_qty > 0
         then do:
            /* CONVERTED OLD_QTY TO INVENTORY UM */
            /* QUANTITY AVAILABLE IN SITE LOCATION FOR LOT/SERIAL */
            run p-pxmsg (input 208,
                         input 3,
                         input (max(max(ld_qty_oh - ld_qty_all,0)
                               + (qty_old - old_qty)
                               * decimal(ship_line.abs__qad03)
                               + old_qty * decimal(ship_line.abs__qad03),0))).
            undo SET_DATA, retry SET_DATA.
         end.

         if ship_line.abs_qty entered
            and can-find(first absr_det
            where absr_domain = global_domain
            and   absr_shipfrom = ship_line.abs_shipfrom
            and   absr_id = ship_line.abs_id)
         then do:
            peg_qty = 0.

            if ship_line.abs_qty = 0 then do:
                /* DELETING LINKS TO REQUIRED SHIP SCHEDULE */
                run p-pxmsg (input 1653,
                             input 2,
                             input "").

               del-yn = false.

               /* REMOVE / DELETE RECORD, PLEASE CONFIRM */
               run p-pxmsgconfirm (input 11,
                                   input 1,
                                   input-output del-yn).
               if not del-yn then
                  undo SET_DATA, retry SET_DATA.

               {gprun.i ""rcdlabsr.p"" "(input recid(ship_line))"}

               run delete_sequences (input recid(ship_line)).

               /* DELETE SHIPPER USER FIELDS AND LINE CHARGES */
               if using_line_charges
                  or using_container_charges
               then
                  run delete_absl_absd_detail (input recid(ship_line)).

               /* DELETE SHIPMENT PERFORMANCE REASON CODES */
               run delete_shipment_reasons
                  (input recid(ship_line)).

               leave SET_DATA.

            end.
            else
               for each absr_det
                  where absr_domain = global_domain
                  and   absr_shipfrom = ship_line.abs_shipfrom
                  and   absr_id = ship_line.abs_id
               exclusive-lock:

               peg_qty = peg_qty + absr_qty.

               if peg_qty > ship_line.abs_qty and
                  not(cnsm_req)
               then do:
                  /* QUANTITY PEGGED GREATER THAN SHIP LINE QUANTITY */
                  run p-pxmsg (input 1652,
                               input 2,
                               input "").
                  l_warning = yes.

                  set
                     ship_line.abs_qty when
                        (v_editall and ship_line.abs_id begins "i")
                     l_abs_pick_qty when
                        (v_editall
                         and available sod_det
                         and sod_type = ""
                         and ship_line.abs_qty > 0
                         and ship_line.abs_id begins "i"
                         and not ship_line.abs_canceled)
                     ship_line.abs_nwt when
                        (substring(ship_line.abs_id,1,1) = "i")
                     l_abs_tare_wt when
                        (substring(ship_line.abs_id,1,1) = "s")
                     or (substring(ship_line.abs_id,1,1) = "c")
                     or (substring(ship_line.abs_id,1,1) = "p")
                     ship_line.abs_vol
                     ship_line.abs_site when
                        (v_editall and ship_line.abs_id begins "i")
                     ship_line.abs_loc  when
                        (v_editall and ship_line.abs_id begins "i")
                     ship_line.abs_lotser  when
                        (v_editall and ship_line.abs_id begins "i")
                     ship_line.abs_ref  when
                        (v_editall and ship_line.abs_id begins "i")
                     cnsm_req when
                        (v_editall and ship_line.abs_id begins "i")
                     ship_line.abs_fa_lot when
                        (v_editall
                         and ship_line.abs_id begins "i"
                         and available sod_det
                         and fas_so_rec = string(true)
                         and fac_wo_rec = no
                         and (sod_cfg_type = "1"
                         or sod_fa_nbr <> "" ))
                     cmmts
                     cancel_bo when
                        (v_editall and ship_line.abs_id begins "i")
                  with frame sample
                  editing:
                     if l_warning then do:
                        /* PROMPTING FOR CONSUME REQ FIELD   */
                        /* WHEN WARNING 1652 IS DISPLAYED    */
                        /* TO FACILITATE THE USER TO CHANGE  */
                        /* THE CONSUME REQ TO YES AND        */
                        /* ACCORDINGLY ADJUST THE PEGGED QTY */
                        next-prompt cnsm_req with frame sample.
                        l_warning = no.
                     end. /* IF L_WARNING */

                     readkey.

                     if lastkey = keycode("F4") or
                        keyfunction(lastkey) = "END-ERROR" or
                        keyfunction(lastkey) = "END-KEY" then
                     do:
                        /* REFRESHING LOWER SCREEN   */
                        empty temp-table abs-tt .
                        run ip-refresh.
                        undo SET_DATA, retry SET_DATA.
                     end. /* IF LASTKEY = KEYCODE("F4").. */
                     else
                     if (lastkey = keycode("F1") or
                        lastkey = keycode("CTRL-X") or
                        keyfunction(lastkey) = "GO") then
                     do:
                        if peg_qty > input ship_line.abs_qty and
                           not(input cnsm_req) then
                        do:
                           /*Quantity pegged greater than ship line quantity */
                           run p-pxmsg (input 1652,
                                        input 2,
                                        input "").
                           next-prompt cnsm_req
                           with frame sample.
                           pause.
                        end. /* IF PEG_QTY > INPUT SHIP_LINE */
                        else leave.
                     end. /* IF LASTKEY = KEYCODE("F1").. */

                     apply lastkey.

                  end. /* SET...*/
               end. /* IF PEG_QTY > SHIP_LINE.ABS_QTY .. */
            end. /* for each absr_det */
         end. /* if ship_line.abs_qty entered */

         /* IF ENTRY THEN VALIDATE THE LINE UNTIL PASS CONDITION */

         /* INITIALIZE TRANSTYPE TO "ISS-SO" FOR ITEMS AND */
         /* "ISS-UNP" FOR CONTAINER ITEMS BEFORE CHECKING  */
         /* FOR RESTRICTED TRANSACTION                     */
         if v_editall and
            lookup(substring(ship_line.abs_id,1,1),"p,s") = 0 and
            ((available sod_det and sod_type = "") or
            (not available sod_det)) then
         do:

            {&RCSHWBB-P-TAG7}
            if ship_line.abs_id begins "i" then
               {&RCSHWBB-P-TAG8}

               assign
                  ship_so   = sod_nbr
                  ship_line = sod_line
                  transtype = "ISS-SO".

               {&RCSHWBB-P-TAG9}
            else
               if ship_line.abs_id begins "c" then
                  transtype = "ISS-UNP".

            /* VALIDATE LOT / PART */
            {gprun.i ""rcctmtb.p""
                     "(input transtype,
                       input ship_from,
                       input ship_line.abs_site,
                       input ship_line.abs_loc,
                       input ship_line.abs_item,
                       input ship_line.abs_lotser,
                       input ship_line.abs_ref,
                       input ship_line.abs_qty,
                       input ship_line.abs__qad02,
                       input decimal(ship_line.abs__qad03),
                       output undotran)"}

            if undotran then
              undo SET_DATA, retry SET_DATA.
         end.   /* IF v_editall */

         if v_editall
            and ship_line.abs_site <> ship_from
         then do:
            {gprun.i ""gpgetgrp.p""
                     "(input ship_line.abs_site,
                       input ship_from,
                       output shipgrp)"}

            if shipgrp <> ? then do:
               if can-find (sg_mstr
                  where sg_domain = global_domain
                  and   sg_grp = shipgrp
                  and   sg_auto_tr = no )
               then do:
                  /* AUTOMATIC TRANSFER FROM SITE # TO SITE # PROHIBITED */
                  run p-pxmsg1 (input 5845,
                                input 3,
                                input ship_line.abs_site,
                                input ship_from).

                  undo SET_DATA, retry SET_DATA.
               end.
            end. /* if shipgrp <> ? */
         end. /* if ship_line.abs_site <> ship_from  */

         if using_cust_consignment then do:

            if ship_line.abs_qty <> qty_old
            then do:

               /* CREATE CONSIGNMENT TEMP-TABLE RECORD TO HOLD RETURN SETTING */
               {gprunmo.i &program = "socnship.p" &module = "ACN"
                          &param   = """(input  part_order,
                                         input  integer(part_order_line),
                                         input  ship_line.abs_site,
                                         input  ship_line.abs_loc,
                                         input  ship_line.abs_item,
                                         input  ship_line.abs_lotser,
                                         input  ship_line.abs_ref,
                                         input  ship_line.abs_qty,
                                         output ok_to_ship,
                                         input-output table
                                            tt_consign_shipment_detail)"""}

               if not ok_to_ship then
                  undo set_data, retry set_data.
            end.

            ship_line.abs__qadc01 = "".

            /* DETERMINE IF CONSIGNMENT RETURN */
            for first tt_consign_shipment_detail
               where sales_order = part_order
               and   order_line = integer(part_order_line)
               and   ship_from_site = ship_line.abs_site
               and   ship_from_loc = ship_line.abs_loc
               and   lot_serial = ship_line.abs_lotser
               and   reference = ship_line.abs_ref
             no-lock:

               if consigned_return_material then
                  ship_line.abs__qadc01 = "yes".
             end.

         end.  /* IF using_cust_consignment */

         /* FOR VALID ITEMS ONLY,                             */
         /* IF THE USER ENTERED A NEW QTY AND DIDN'T CHANGE   */
         /* EITHER VOLUME OR WEIGHT, ASK IF VOLUME AND WEIGHT */
         /* SHOULD BE RECALCULATED.                           */
         find pt_mstr
            where pt_domain = global_domain
            and   pt_part = ship_line.abs_item
         no-lock no-error.

         /* NET WT AND QTY ARE CHANGED TOGETHER FOR ITEM     */
         /* OR TARE WT AND QTY FOR CONTAINER                 */

         /* SINCE ONLY ITEM LEVEL QUANTITY CAN BE EDITED,    */
         /* THE CODE RELATED TO CHANGING TARE WT AND QTY AT  */
         /* THE CONTAINER LEVEL IS NOT NECESSARY             */

         if available pt_mstr
            and ship_line.abs_nwt <> nwt_old
            and ship_line.abs_qty <> qty_old
            and ship_line.abs_vol = vol_old
         then do:

            assign
               ch_nwt =  (ship_line.abs_nwt - nwt_old)
               ship_line.abs_nwt = nwt_old
               l_abs_tare_wt = if qty_old <> 0 then
                               (l_abs_tare_wt / qty_old) * ship_line.abs_qty
                               else
                               l_abs_tare_wt * ship_line.abs_qty.

            {gprun.i ""icshnwt.p""
                     "(input recid(ship_line),
                       input ch_nwt,
                       input yes,
                       input ship_Line.abs_wt_um)"}

            {gprun.i ""icshnwt.p""
                     "(input recid(ship_line),
                       input l_abs_tare_wt - l_twt_old,
                       input no,
                       input ship_Line.abs_wt_um)"}

            {abspack.i "ship_line" 26 22 "l_abs_tare_wt"}

         end. /* IF ABS_NWT <> NWT_OLD AND QTY_OLD <> ABS_QTY */

         if available pt_mstr then do:

            if ship_line.abs_nwt <> nwt_old and
               ship_line.abs_vol <> vol_old and
               ship_line.abs_qty <> qty_old
            then do:
               assign
                  ch_nwt            = ship_line.abs_nwt - nwt_old
                  ship_line.abs_nwt = nwt_old.

               {gprun.i ""icshnwt.p""
                        "(input recid(ship_line),
                          input ch_nwt,
                          input yes,
                          input ship_line.abs_wt_um)"}.

               display
                  ship_line.abs_nwt
                  ship_line.abs_vol
               with frame sample.

            end. /* IF ABS_NWT <> NWT_OLD AND ABS_VOL <> VOL_OLD */
                 /* AND ABS_QTY <> QTY_OLD                       */

            if ship_line.abs_qty <> qty_old
               and ship_line.abs_vol = vol_old
               and ship_line.abs_nwt = nwt_old
            then do:
               ok_to_recalc_wt_vol = true.
               /*QUANTITY CHANGED.  RECALCULATE WEIGHT AND VOLUME?*/
               run p-pxmsgconfirm (input 1480,
                                   input 1,
                                   input-output ok_to_recalc_wt_vol).

               if ok_to_recalc_wt_vol then do:

                  if qty_old <> 0 then
                     assign
                        ch_nwt = (ship_line.abs_nwt / qty_old )
                               * ship_line.abs_qty - nwt_old
                        ship_line.abs_nwt  = nwt_old
                        l_abs_tare_wt = (l_abs_tare_wt / qty_old ) *
                                        ship_line.abs_qty.

                  else
                     assign
                        ch_nwt = MAX (pt_net_wt * ship_line.abs_qty,0)
                        ship_line.abs_nwt    = nwt_old
                        l_abs_tare_wt  = max ((pt_ship_wt * ship_line.abs_qty )
                                       - (pt_net_wt * ship_line.abs_qty ),0)
                        ship_line.abs_vol_um = pt_size_um
                        ship_line.abs_wt_um  = pt_net_wt_um.

                  ship_line.abs_vol = max (pt_size * ship_line.abs_qty
                                    * decimal(ship_line.abs__qad03),0).

                  {abspack.i  "ship_line" 26 22 "l_abs_tare_wt"}

                  {gprun.i ""icshnwt.p""
                           "(input recid(ship_line),
                             input ch_nwt,
                             input yes,
                             input ship_Line.abs_wt_um)"}

                  {gprun.i ""icshnwt.p""
                           "(input recid(ship_line),
                             input ( - ch_nwt),
                             input no,
                             input ship_Line.abs_wt_um)"}

                  if qty_old <> 0 then
                     ch_nwt = (ship_line.abs_gwt / qty_old )
                            * ship_line.abs_qty - (ship_line.abs_gwt).
                  else do:
                     ch_nwt = MAX (pt_ship_wt * ship_line.abs_qty,0).

                     /* ASSIGN NET WT IF ITEM SHIP WT */
                     /* IS ZERO IN PART MASTER */
                     if pt_ship_wt = 0 and pt_net_wt <> 0 then
                        ch_nwt = MAX (pt_net_wt * ship_line.abs_qty,0).
                  end. /* IF QTY_OLD = 0 */

                  {gprun.i ""icshnwt.p""
                           "(input recid(ship_line),
                             input ch_nwt,
                             input no,
                             input ship_Line.abs_wt_um)"}

                  display
                     ship_line.abs_nwt
                     ship_line.abs_vol
                  with frame sample.

               end.   /* if ok_to_recalc_wt_vol */
            end.  /* if ship_line.abs_qty <> qty_old */
         end.  /* if available pt_mstr */

         if cmmts then do:
            find abs_parent_buff
               where abs_parent_buff.abs_domain = global_domain
               and   recid(abs_parent_buff) = parent_abs_recid
            no-lock no-error.
            assign
               cmtindx = ship_line.abs_cmtindx
               global_ref = abs_parent_buff.abs_format
               global_lang = abs_parent_buff.abs_lang.

            {gprun.i ""gpcmmt01.p"" "(input 'abs_mstr')"}

            ship_line.abs_cmtindx = cmtindx.
         end.

         /* Gather additional line item data */
         {gprun.i ""sofsgi.p"" "(recid(ship_line))"}

         {absupack.i  "ship_line" 26 22 "l_abs_tare_wt"}

         /* IF QTY OF THE PARENT CHANGED */

         /* SINCE ONLY ITEM LEVEL QUANTITY CAN BE EDITED,    */
         /* THE CODE RELATED TO CHANGING TARE WT AND QTY AT  */
         /* PARENT LEVEL IS NOT NECESSARY                    */

         /* CHECK FOR WEIGHT CHANGE AND PROPOGATE */
         if ship_line.abs_nwt <> nwt_old and
            ship_line.abs_qty = qty_old
         then do:

            assign
               ch_nwt = ship_line.abs_nwt - nwt_old
               ship_line.abs_nwt = nwt_old.

            {gprun.i ""icshnwt.p""
               "(input recid(ship_line),
                 input ch_nwt,
                 input yes,      /* CHANGE_NET */
                 input ship_Line.abs_wt_um)"}

         end. /* IF ABS_NWT <> NWT_OLD */

         /* CHECK FOR TARE WEIGHT CHANGE AND PROPOGATE */
         if l_abs_tare_wt <> l_twt_old
            and ship_line.abs_nwt = nwt_old
            and ship_line.abs_qty = qty_old
         then do:

            {gprun.i ""icshnwt.p""
                     "(input recid(ship_line),
                       input l_abs_tare_wt - l_twt_old,
                       input no,
                       input ship_Line.abs_wt_um)"}
         end. /* IF L_ABS_TARE_WT <> L_TWT_OLD */

         /* CONSUME REQUIREMENTS */
         if ship_line.abs_id begins "i"
            and cnsm_req then
         do:
            {gprun.i ""rcshwbb2.p""
                     "(input recid(ship_line),
                       input absship_recid)"}
         end.

         /* MAINTAIN SEQUENCES */
         if ship_line.abs_id begins "i" then
            run maintain_sequences
               (input ship_line.abs_id,
                input ship_line.abs_shipfrom).

         /* MAINTAIN SHIPMENT PERFORMANCE REASON CODES */
         if ship_line.abs_id begins "i" then
            run maintain_shipment_reasons
               (input ship_line.abs_id,
                input ship_line.abs_shipfrom).

         /* MAINTAIN SHIPPER LINE CHARGES */
         if using_line_charges and
            ship_line.abs_id begins "i"
         then do:

            vNewOrder = no.

            if ship_line.abs_order <> vOldOrder or
               ship_line.abs_line <> vOldLine
            then do:

               vNewOrder = yes.
               {gprunmo.i &module = "ACL" &program = ""rcsochg.p""
                          &param = """(input recid(ship_line),
                                       input vOldOrder,
                                       input vOldLine,
                                       input vOldAbsID,
                                       input program-name(1))"""}.

            end. /*IF SHIP_LINE.ABS_ORDER <> vOldOrder*/

            if ship_line.abs_order <> "" and
               ship_line.abs_id begins "i"
            then
               run getLineCharges
                  (input ship_line.abs_shipfrom,
                   input ship_line.abs_id,
                   input recid(so_mstr),
                   input recid(sod_det)).

         end. /* IF using_line_charges*/

         if ship_line.abs_id begins "i"
         then do:
            /* SET GLOBAL_DB USING ABS_SITE */
            new_site = ship_line.abs_site.
            {gprun.i ""gpalias.p""}

            /* SWITCH TO THE INVENTORY SITE */
            if so_db <> global_db then do:
               {gprun.i ""gpalias2.p""
                  "(input ship_line.abs_site, output errornum)"}

               if errornum <> 0 and errornum <> 9
               then do:
                  /* DOMAIN # IS NOT AVAILABLE */
                  run p-pxmsg (input 6137,
                               input 4,
                               input l_msgar1[2]).

                  undo SET_DATA, retry SET_DATA.
               end. /* IF ERRORNUM <> 0 AND ... */

               /* UPDATE SOD__QADL01 (CANCEL B/O) IN INVENTORY DOMAIN */
               {gprun.i ""rcsodqad.p""
                        "(input cancel_bo,
                          input ship_line.abs_order,
                          input ship_line.abs_line)"}

               /* SWITCH BACK TO THE SALES ORDER DOMAIN */
               {gprun.i ""gpalias3.p"" "(input so_db, output errornum)"}

               if errornum <> 0 and errornum <> 9 then do:
                  /* DOMAIN # IS NOT AVAILABLE */
                  run p-pxmsg (input 6137,
                               input 4,
                               input l_msgar1[1]).

                  undo SET_DATA, retry SET_DATA.
               end. /* IF ERRORNUM <> 0 AND ... */

            end. /* IF SO_DB <> GLOGAL_DB */

            /* UPDATE SOD__QADL01 (CANCEL B/O) IN ORDER DOMAIN */
            {gprun.i ""rcsodqad.p"" "(input cancel_bo,
                                      input ship_line.abs_order,
                                      input ship_line.abs_line)"}
         end. /* IF SHIP_LINE.ABS_ID BEGINS "I" */

         /* NEXT if BLOCK VALIDATES WORK ORDER IN INVENTORY DOMAIN */
         if ship_line.abs_fa_lot <> "" then do:

            /* PASS "NA" IN sodfanbr TO rcshvid.p WHEN sod_det IS NOT AVAILABLE */
            if available sod_det then sodfanbr = sod_fa_nbr.
            else sodfanbr = "NA".

            /* SET GLOBAL_DB USING ABS_SITE */
            new_site = ship_line.abs_site.
            {gprun.i ""gpalias.p""}

            if so_db <> global_db then do:
               /* SWITCH TO THE REMOTE SITE */
               {gprun.i ""gpalias2.p""
                  "(input ship_line.abs_site,
                    output errornum)"}

               if errornum <> 0 and errornum <> 9 then do:
                  /* UNABLE TO CONNECT TO REMOTE DOMAIN */
                  run p-pxmsg (input 6137,
                               input 4,
                               input l_msgar1[2]).
                  next-prompt ship_line.abs_fa_lot
                  with frame sample.
                  undo SET_DATA, retry SET_DATA.
               end.
            end. /* so_db <> global_db */

            undotran = no.
            /* VALIDATE WORK ORDER POSSIBLY IN REMOTE DOMAIN */
            {gprun.i ""rcshvid.p""
               "(input ship_line.abs_fa_lot,
                 input sodfanbr,
                 output undotran)"}

            if so_db <> global_db then do:
               /* RESET TO CENTRAL DOMAIN */
               {gprun.i ""gpalias3.p""
                  "(input so_db,
                    output errornum)"}

               if errornum <> 0 and errornum <> 9 then do:
                  /* UNABLE TO CONNECT TO SALES DOMAIN */
                  run p-pxmsg (input 6137,
                               input 4,
                               input l_msgar1[1]).
                  next-prompt ship_line.abs_fa_lot
                  with frame sample.
                  undo SET_DATA, retry SET_DATA.
               end.
            end. /* so_db <> global_db */

           /* CHECKING undotran FROM rcshvid.p CALL HERE TO */
           /* ALLOW DOMAIN SWITCHING */
            if undotran then do:
               next-prompt ship_line.abs_fa_lot with frame sample.
               undo SET_DATA, retry SET_DATA.
            end.
         end. /* if ship_line.abs_fa_lot <> "" */

         /* CHANGING SITE, LOC, LOT, or REF */
         /* ALLOCATE REG ITEM, KIT COMP, & ATO W/ F/A LOT */
         if v_editall and
            (available sod_det and sod_type = "" and
            (sod_cfg_type <> "2" or
            (kit_comp)))
         then do:

            if l_order_change then do:
               /* UPDATE DETAIL ALLOCATIONS */
               run p_update_alloc.
               if undotran then
                  undo SET_DATA, retry SET_DATA.

            end. /* IF L_ORDER_CHANGE */
            else do:
               if (old_site <> ship_line.abs_site) or
                  (old_lot <> ship_line.abs_lotser) or
                  (old_loc <> ship_line.abs_loc) or
                  (old_ref <> ship_line.abs_ref)
               then do:

                  /* SET GLOBAL_DB USING ABS_SITE */
                  new_site = ship_line.abs_site.
                  {gprun.i ""gpalias.p""}

                  /* SWITCH TO THE INVENTORY SITE */
                  if so_db <> global_db then do:
                     {gprun.i ""gpalias2.p""
                        "(input ship_line.abs_site, output errornum)"}
                     if errornum <> 0 and errornum <> 9 then do:
                        /* DOMAIN # IS NOT AVAILABLE */
                        run p-pxmsg (input 6137,
                                     input 4,
                                     input l_msgar1[2]).
                        undo SET_DATA, retry SET_DATA.
                     end.
                  end.

                  /* CONVERTED - OLD_QTY TO INVENTORY UM        */
                  {gprun.i ""soitallb.p""
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
                             output tmp_qty,
                             output undotran)"}

                  if undotran then
                     undo set_data, retry set_data.



                  /* CHANGED 8th INPUT PARAMETER FROM      */
                  /* ship_line.abs_qty *                   */
                  /*         decimal(ship_line.abs__qad03) */
                  /* TO l_abs_pick_qty                     */
                  /*         decimal(ship_line.abs__qad03) */
                  /* TO  ENSURE CORRECT UPDATE OF INVENTORY*/
                  /* TABLES                                */


                  /* DETAIL ALLOCATE NEW QTY, LOC, LOT ... */
                  {gprun.i ""soitalla.p""
                           "(input ship_line.abs_order,
                             input ship_line.abs_line,
                             input ship_line.abs_item,
                             input ship_line.abs_site,
                             input ship_line.abs_loc,
                             input ship_line.abs_lotser,
                             input ship_line.abs_ref,
                             input l_abs_pick_qty *
                                   decimal(ship_line.abs__qad03),
                             input 0,
                             output adj_qty,
                             output undotran)"}

                  if undotran then
                     undo SET_DATA, retry SET_DATA.


                  /* SWITCH BACK TO THE SALES ORDER DOMAIN */
                  if so_db <> global_db then do:

                     /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
                     /* IN REMOTE DOMAIN                         */
                     if not kit_comp then do:
                        {gprun.i ""sosopka2.p""
                                 "(input ship_line.abs_order,
                                   input integer (ship_line.abs_line),
                                   input (l_abs_pick_qty - old_qty) *
                                          decimal(ship_line.abs__qad03),
                                   input l_delproc)"}
                     end. /* IF NOT KIT_COMP */

                     {gprun.i ""gpalias3.p"" "(input so_db, output errornum)"}
                     if errornum <> 0 and errornum <> 9 then do:
                        /* DOMAIN # IS NOT AVAILABLE */
                        run p-pxmsg (input 6137,
                                     input 4,
                                     input l_msgar1[1]).
                        undo SET_DATA, retry SET_DATA.
                     end.
                  end.

                  if undotran then
                     undo SET_DATA, retry SET_DATA.

                  if not kit_comp then do:
                     /* UPDATE DETAIL QTY ALL, QTY PICK */
                     /* CONVERTED L_ABS_PICK_QTY - OLD_QTY TO INVENTORY UM */
                     {gprun.i ""sosopka2.p""
                              "(input ship_line.abs_order,
                                input integer (ship_line.abs_line),
                                input (l_abs_pick_qty - old_qty) *
                                       decimal(ship_line.abs__qad03),
                                input l_delproc)"}
                  end.

               end.     /*  old_site <> ship_line.abs_site */

               /* HERE  ONLY CHANGE QTY - UPDATE QTY DIFF  */
               else
               if (available sod_det) and (sod_type = "") and
                  ((qty_old <> ship_line.abs_qty) or
                  (old_qty <> l_abs_pick_qty))
               then do:

                  /* UPDATE DETAIL ALLOCATION WHEN THE SHIP */
                  /* AND/OR PICK QTY HAVE BEEN MODIFIED.    */
                  run p_update_alloc1.
                  if undotran then
                     undo SET_DATA, retry SET_DATA.
               end. /* IF OLD_SITE <> SHIP_LINE.ABS_SITE OR ... */
            end. /* IF NOT L_ORDER_CHANGE */

            if cmf_flg and
               available sod_det and
               ((old_qty < ship_line.abs__dec01 and old_qty = 0) or
               (old_qty > ship_line.abs__dec01
               and ship_line.abs__dec01 = 0))
            then
               run create-so-cmf (input recid (sod_det)).

         end.    /* if available sod_det... */

      end. /* SET_DATA */

      /* HANDLE F5 KEY */
      if (lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D"))
      then do:
         next_editloop = no.
         run delete_proc (output next_editloop).

         l_absso_recid = ?.

         if next_editloop then next editloop.

      end. /* IF LASTKEY = KEYCODE F5 */

   end. /* IF NOT BATCHRUN */

   /* HANDLE F3 KEY */
   /* ALWAYS ENTER ADD MODE WHEN BATCH-RUN */
   if batchrun
      or lastkey = keycode("F3")
      or lastkey = keycode("PF3")
      or lastkey = keycode("CTRL-T")
   then do:
      assign
         next_editloop  = no
         next_mainloop  = no
         leave_editloop = no
         l_delproc      = no.

      run add_proc (output next_editloop, output next_mainloop, output leave_editloop).
      if next_editloop then next editloop.
      if next_mainloop then next mainloop.
      if leave_editloop then leave editloop.

   end. /* LASTKEY = KEYCODE F3 */

end. /* EDITLOOP */

/* CLEAN UP RECORDS */
run p_clean_up ( input ship_from, input tmp_prefix ).

if lastkey = keycode("F4")
or keyfunction(lastkey) = "END-ERROR"
or keyfunction(lastkey) = "ENDKEY"
or ( batchrun and keyfunction(lastkey) = "." )
or lastkey = keycode("CTRL-E")
or not cont_yn
then
   leave MAINLOOP.

end. /* MAINLOOP */

hide frame k no-pause.
hide frame sample no-pause.

/* END OF MAIN PROCEDURE BODY */


PROCEDURE create_tt :

   define input parameter  ip_sod_nbr   like  sod_nbr  no-undo.
   define input parameter  ip_sod_line  like  sod_line no-undo.
   define input parameter  ip_sod_part  like  sod_part no-undo.

   define variable  ip_abs_pick_qty  like abs_qty      no-undo.

   for each abs_mstr
      where abs_domain = global_domain
        and abs_id begins "i"
        and   abs_order = ip_sod_nbr
        and abs_line    = string(ip_sod_line)
        and abs_item    = ip_sod_part
        and abs_qty  <> abs_ship_qty no-lock :
      {absupack.i  "abs_mstr" 3 22 "ip_abs_pick_qty" }
         find first abs-tt
         where  abs-tt-id = abs_id  no-lock no-error .

      if  not available abs-tt
      then do:
         create abs-tt .
         abs-tt-id   = abs_id .
      end. /* IF  not available abs-tt */
      assign
         abs-tt-nbr  = abs_order
         abs-tt-item  = abs_item
         abs-tt-line  = abs_line
         abs-tt-qty  = (abs_qty - abs_ship_qty - ip_abs_pick_qty ) *
                                       decimal(abs__qad03 ) .
   end. /* FOR EACH abs_mstr */

END PROCEDURE.  /* create_tt */

PROCEDURE compute_openqty :

   /* THE LOGIC OF OPENQTY.I  HAS  BEEN REPLACED WITH THE LOGIC  */
   /* CREATING THE TEMP-TABLE abs-tt AND THEN COMPUTING          */
   /* THE  OPEN QTY FROM THE TEMP-TABLE RECORDS  . THIS WAS DONE */
   /* OWING TO ORACLE COMMIT ISSUE                               */

   define input  parameter  ip_sod_nbr   like  sod_nbr  no-undo .
   define input  parameter  ip_sod_line  like  sod_line no-undo.
   define input  parameter  ip_sod_part  like  sod_part no-undo.
   define output parameter  ip_openqty   like abs_qty  no-undo.

   define variable open_qty  like open_qty initial 0  no-undo.

   for first sod_det
      fields (sod_domain sod_cfg_type sod_contr_id sod_fa_nbr
              sod_line sod_nbr sod_part sod_pickdate
              sod_qty_all sod_qty_ord sod_qty_pick
              sod_qty_ship sod_sched sod_type sod_site
              sod_um_conv sod__qadl01)
      where sod_domain = global_domain
        and sod_nbr   = ip_sod_nbr
        and sod_line  = ip_sod_line
        and sod_part  = ip_sod_part
   no-lock:

      for each abs-tt
         where abs-tt.abs-tt-nbr   = ip_sod_nbr
           and abs-tt.abs-tt-item  = ip_sod_part
           and abs-tt.abs-tt-line  = string(ip_sod_line)  :
        ip_openqty  = ip_openqty + abs-tt-qty .
      end. /* FOR EACH abs-tt */

      assign
         ip_openqty   = ip_openqty / sod_um_conv
         ip_openqty   = sod_qty_ord - sod_qty_pick - sod_qty_ship  - ip_openqty .
   end. /* FOR FIRST sod_det */

END PROCEDURE.  /* compute_openqty  */



PROCEDURE ip_editall:

   /* Set flag determining whether non-informational fields (any */
   /* field actually used during confirmation, such as quantities, */
   /* site, sales order #, etc) are allowed to be edited.  Only */
   /* purely informational fields (such as comments) may be editing */
   /* for non-SO shippers or confirmed SO shippers. */

   /* PARAMETERS */
   define input  parameter i_recid   as recid             no-undo.
   define output parameter o_editall as logical initial true no-undo.

   /* LOCAL VARIABLES */
   define variable v_par_recid as recid no-undo.

   /* BUFFERS */
   define buffer b_abs_mstr for abs_mstr.

   /* PROCEDURE BODY */

   /* Find top-level parent shipper or preshipper */
   {gprun.i ""gpabspar.p""
            "(input i_recid,
              input 'PS',
              input false,
              output v_par_recid)"}

   find b_abs_mstr no-lock where recid(b_abs_mstr) = v_par_recid
      no-error.

   {&RCSHWBB-P-TAG10}
   if available b_abs_mstr             and
      (b_abs_mstr.abs_id begins "s" or
      b_abs_mstr.abs_id begins "p")   and
      (can-find (im_mstr where im_domain = global_domain and (
      im_inv_mov = b_abs_mstr.abs_inv_mov and
      im_tr_type <> "ISS-SO")) or
      substring(b_abs_mstr.abs_status,2,1) = "y")
   then
      o_editall = false.

   {&RCSHWBB-P-TAG11}

   else o_editall = true.

END PROCEDURE.  /* ip_editall */

{gpnrseq.i}

{rccmf.i}

PROCEDURE delete_proc:
   define output parameter next_editloop as logical no-undo.

   DEL_LOOP:
   do on endkey undo DEL_LOOP, leave DEL_LOOP
         on error undo DEL_LOOP, retry DEL_LOOP:
      if not v_editall then do:
         {pxmsg.i &MSGNUM=5811 &ERRORLEVEL=3}
         /* Selection only available for unconfirmed SO shippers */
         next_editloop = yes.
         return.
      end.  /* if not v_editall */

      save_frame_line = frame-line(k).
      color display input first_column with frame k.

      /* DISPLAY F5 SELECTION FRAME */
      hide frame sample no-pause.
      view frame m1.

      display
         del-form-line-1
         del-form-line-2
         del-form-line-3
         del-form-line-4
         del-form-line-5
      with frame m1.

      assign
         sel_var_del = 0
         valid_entry = false.

      GET_SELECTION:
      do on endkey undo GET_SELECTION, leave GET_SELECTION
            on error undo GET_SELECTION, retry GET_SELECTION:

         /* PLEASE ENTER A SELECTION */
         {pxmsg.i &MSGNUM=39 &ERRORLEVEL=1
                  &CONFIRM=sel_var_del
                  &CONFIRM-TYPE='NON-LOGICAL'}

         if sel_var_del < 1 or sel_var_del > 5 then do:
            {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3} /* NOT A VALID CHOICE */
            undo GET_SELECTION, retry GET_SELECTION.
         end.

         if ship_line.abs_id begins "i" and
            (sel_var_del <> 1 and sel_var_del <> 2)
         then do:
            /* THIS OPTION NOT ALLOWED FOR .. */
            {pxmsg.i &MSGNUM=761 &ERRORLEVEL=3}
            undo GET_SELECTION, retry GET_SELECTION.
         end.

         if sel_var_del = 1 then do:
            find abs_parent_buff
               where recid(abs_parent_buff) = parent_abs_recid
            no-lock.

            if abs_parent_buff.abs_nr_id <> "" then do:
               run chk_delnbr
                  (input abs_parent_buff.abs_nr_id,
                   output can_discard,
                   output errorst,
                   output errornum).
               if errorst then do:
                  {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=4}
                  undo GET_SELECTION, retry GET_SELECTION.
               end. /* errorst */

               msgnum = if abs_parent_buff.abs_id begins "p"
                        then
                           5944
                        else 5946.

               if not can_discard then do:
                  {pxmsg.i &MSGNUM=msgnum &ERRORLEVEL=4}
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
                  {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=4}
                  undo GET_SELECTION, retry GET_SELECTION.
               end. /* errorst */

               if not can_discard then do:
                  {pxmsg.i &MSGNUM=5944 &ERRORLEVEL=4}
                  /*DELETION PROHIBITED, GAPS IN PRE-SHIPPER SEQUENCE
                  NOT PERMITTED*/
                  undo GET_SELECTION, retry GET_SELECTION.
               end. /* not can_discard */
            end. /* if abs_parent_buff.abs_preship_nr_id <> "" */
         end. /* if sel_var_del = 1 */

         /* DELETE RESTRICTION FOR PRE-SHIPPER/SHIPPER   */
         /* ON SELECTING OPTION 2 TO 5                   */

         if (sel_var_del >= 2 and sel_var_del <= 5)
            and ((ship_line.abs_id >= "p" and
            ship_line.abs_id <= "p" + hi_char) or
            (ship_line.abs_id >= "s" and
            ship_line.abs_id <= "s" + hi_char))
         then do:
            /* THIS OPTION IS NOT ALLOWED FOR THE SELECTED RECORDS */
            {pxmsg.i &MSGNUM=761 &ERRORLEVEL=3}
            undo GET_SELECTION, retry GET_SELECTION.
         end. /* END OF if sel_var_del >= 2 and sel_var_del <= 5 */

         /* CHECK FOR ORPHAN ITEM RECORDS */
         if ship_line.abs_par_id = ""
            and sel_var_del = 2 or sel_var_del = 4
         then do:
            for each abs_mstr
               where abs_mstr.abs_domain = global_domain
               and   abs_mstr.abs_shipfrom = ship_from
               and   abs_mstr.abs_par_id = ship_line.abs_id
            no-lock:
               if abs_mstr.abs_id begins "i" then do:
                  /* CANNOT ORPHAN AN ITEM RECORD */
                  {pxmsg.i &MSGNUM=762 &ERRORLEVEL=3}
                  undo GET_SELECTION, retry GET_SELECTION.
               end. /* if abs_id begins i */
            end. /* for each abs_mstr */
         end. /* if par_id = "" and 2 or 4 */

         del-yn = false.
         /* REMOVE / DELETE RECORD, PLEASE CONFIRM */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if not del-yn then
            undo GET_SELECTION, leave GET_SELECTION.
         valid_entry = true.
      end. /* GET SELECTION */

      /* GENERAL ALLOCATE PICKED QUANTITY ? */
      if sel_var_del >= 1 and
         sel_var_del <= 5 and
         del-yn
      then do:
         {pxmsg.i &MSGNUM=3411 &ERRORLEVEL=1 &CONFIRM=l_updalloc}
         if not l_updalloc then
        l_delproc = yes.
      end. /* IF SEL_VAR_DEL */

      /* HIDE DELETE FRAME */
      hide frame m1 no-pause.
      view frame sample.

      /* HANDLE DELETE SELECTION */
      if valid_entry then do:
         delete_recid = recid(ship_line).
         kit_comp =  (ship_line.abs_par_id begins  "i").
         /* SUBTRACT WEIGHT FROM PARENTS */
         if sel_var_del <> 1 then do:
            assign
               original_nwt = ship_line.abs_nwt
               original_gwt = ship_line.abs_gwt.

            {absupack.i  "ship_line" 26 22 "l_abs_tare_wt"}

            if sel_var_del = 2 or sel_var_del = 4 then
               assign
                  l_twt_old = l_abs_tare_wt * -1
                  nwt_old = ship_line.abs_nwt * -1.
            else
               assign
                  l_twt_old = (ship_line.abs_gwt - ship_line.abs_nwt) * -1
                  nwt_old = ship_line.abs_nwt * -1.

            if (ship_line.abs_id begins "i" and sel_var_del = 2)
               or (sel_var_del = 3 or sel_var_del = 5 )
            then do:
               {gprun.i ""icshnwt.p""
                        "(input recid(ship_line),
                          input nwt_old,
                          input yes,
                          input ship_line.abs_wt_um)"}
            end. /* IF SHIP_LINE.ABS_ID BEGINS "I" ...*/

            {gprun.i ""icshnwt.p""
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
               where abs_mstr.abs_domain = global_domain
               and   abs_mstr.abs_shipfrom = ship_from
               and   abs_mstr.abs_par_id = ship_line.abs_id
            exclusive-lock:

               /* CHANGE PARENT POINTERS OF CHILD RECORDS */
               assign
                  abs_mstr.abs_par_id = ship_line.abs_par_id
                  abs_mstr.abs__qad06 =
                  string(integer(abs_mstr.abs__qad06) - 1,"9").

               /* ADJUST LEVELS OF CHILD RECORDS */
               {gprun.i ""rcctwbu3.p"" "(input recid(abs_mstr))"}
            end. /* for each abs_mstr */

            /* Delete custom shipper document information
             * associated with the record */
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
            assign
               ship_line.abs_nwt = original_nwt
               ship_line.abs_gwt = original_gwt
               ship_line.abs_par_id = "".

         /* REMOVE RECORD - REMOVE STRUCTURE */
         if sel_var_del = 4 or sel_var_del = 5 then
            ship_line.abs_shipto = ship_line.abs__qad05.

         /* CHECK FOR NEXT RECORD */
         find next ship_line
            where ship_line.abs_domain = global_domain
            and   ship_line.abs_shipfrom = ship_from
            and   ship_line.abs_shipto begins tmp_prefix
         no-lock no-error.

         if available ship_line then
            abs_recid = recid(ship_line).
         else do:
            /* IF NO NEXT RECORD THEN FIND PREVIOUS RECORD */
            find ship_line
               where recid(ship_line) = delete_recid
            no-lock no-error.

            find prev ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto begins tmp_prefix
            no-lock no-error.

            if available ship_line then do:
               abs_recid = recid(ship_line).
               if save_frame_line > 1 then
                  save_frame_line = save_frame_line - 1.
            end. /* available ship_line */
            else
               /* NO RECORDS LEFT SO RESET */
               assign
                  abs_recid = ?
                  save_frame_line = 1.
         end. /* ELSE DO */

         if sel_var_del = 5 then do:

            /* DELETE ALLOCATIONS AND RESET THE SHIPPER SALES ORDER, */
            /* LINE AND PICK QTY.                                    */
            {gprun.i ""rcctwbu1.p""
                     "(input delete_recid,
                       input yes,
                       input no,
                       input l_delproc,
                       output undotran)"}

            if undotran then
               undo DEL_LOOP, retry DEL_LOOP.
         end. /* IF SEL_VAR_DEL = 5 */

         /* HANDLE DELETES */
         if sel_var_del = 2 or sel_var_del = 3 then do:

            find ship_line
               where recid(ship_line) = delete_recid
            exclusive-lock no-error.

            /* DELETE ABSR_DET RECORDS */
            if ship_line.abs_id begins "i" then do:
               {gprun.i ""rcdlabsr.p"" "(input delete_recid)"}

               /* DELETE SEQUENCES */
               run delete_sequences (input delete_recid).

               /* DELETE SHIPPER USER FIELDS AND LINE CHARGES */
               if using_line_charges or using_container_charges then
                  run delete_absl_absd_detail (input delete_recid).

               /* DELETE SHIPMENT PERFORMANCE REASON CODES */
               run delete_shipment_reasons
                  (input delete_recid).

            end.

            /* IF DELETE STRUCTURE THEN DELETE ALL CHILDREN */
            if sel_var_del = 3 then do:

               if using_container_charges or using_line_charges then
                  /* DELETE THE USER FIELDS FROM THE CONTAINER*/
                  run delete_absl_absd_detail (input delete_recid).

               /* DELETE ALL CHILD RECORDS */
               {gprun.i ""rcctwbu1.p""
                        "(input delete_recid,
                          input yes,   /* ALLOCATION */
                          input yes,   /* DELETE */
                          input l_delproc,
                          output undotran)"}

               if undotran then
                  undo DEL_LOOP, retry DEL_LOOP.

            end.

            /* IF DELETE KIT PARENT THEN DELETE ALL COMPONENTS */
            if sel_var_del = 2 and
               ship_line.abs_id begins "i"
            then do:
               /* CAN'T CHECK sod_det, SO MAY HAVE BEEN DELETED */
               find first abs_mstr
                  where abs_mstr.abs_domain = global_domain
                  and   abs_mstr.abs_shipfrom = ship_from
                  and   abs_mstr.abs_par_id = ship_line.abs_id
               no-lock no-error.
               if available abs_mstr then do:
                  /* DELETE ALL COMPONENT RECORDS */
                  /* ALLOCATION = YES & DELETE = YES                */
                  {gprun.i ""rcctwbu1.p""
                           "(input delete_recid,
                             input yes,
                             input yes,
                             input l_delproc,
                             output undotran)"}
                  if undotran then
                     undo DEL_LOOP, retry DEL_LOOP.
               end. /* available abs_mstr */

               del_lad = kit_comp.

           if not l_updalloc then
              l_ship_qty = ship_line.abs_qty.

               /* SET GLOBAL_DB USING ABS_SITE */
               new_site = ship_line.abs_site.
               {gprun.i ""gpalias.p""}

               /* SWITCH TO THE INVENTORY SITE */
               if so_db <> global_db then do:
                  {gprun.i ""gpalias2.p""
                           "(input ship_line.abs_site, output errornum)"}
                  if errornum <> 0 and errornum <> 9 then do:
                     /* DOMAIN # IS NOT AVAILABLE */
                     run p-pxmsg (input 6137,
                                  input 4,
                                  input l_msgar1[2]).
                     undo DEL_LOOP, retry DEL_LOOP.
                  end. /* if errornum <> 0 and 9 */
               end. /* if so_db <> global_db */

               /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
               {gprun.i ""soitallb.p""
                        "(input ship_line.abs_order,
                          input ship_line.abs_line,
                          input ship_line.abs_item,
                          input ship_line.abs_site,
                          input ship_line.abs_loc,
                          input ship_line.abs_lotser,
                          input ship_line.abs_ref,
                          input - l_ship_qty *
                                decimal(ship_line.abs__qad03),
                          input - l_abs_pick_qty *
                                decimal(ship_line.abs__qad03),
                          input del_lad,
                          input l_delproc,
                          output avail_qty,
                          output tmp_qty,
                          output undotran)"}

               if undotran then
                  undo del_loop, retry del_loop.

               /* SWITCH BACK TO THE SALES ORDER DOMAIN */
               if so_db <> global_db then do:

                  /* UPDATE SALES ORDER DETAIL QTY ALL AND */
                  /* PICK IN REMOTE DOMAIN                 */
                  {gprun.i ""sosopka3.p""
                     "(input ship_line.abs_order,
                       input ship_line.abs_line,
                       input l_abs_pick_qty,
                       input ship_line.abs__qad03,
                       input l_delproc)"}

                  {gprun.i ""gpalias3.p"" "(input so_db, output errornum)"}

                  if errornum <> 0 and errornum <> 9 then do:
                     /* DOMAIN # IS NOT AVAILABLE */
                     run p-pxmsg (input 6137,
                                  input 4,
                                  input l_msgar1[1]).
                     undo DEL_LOOP, retry DEL_LOOP.
                  end. /* errornum <> 0 and 9 */
               end. /* if so_db <> global_db */

               find sod_det
                  where sod_det.sod_domain = global_domain
                  and   sod_nbr = ship_line.abs_order
                  and   sod_line = integer (ship_line.abs_line)
               no-lock no-error.

               if available sod_det
                  and sod_cfg_type <> "2"
               then do:
                  /* UPDATE DETAIL QTY ALL, QTY PICK */
                  /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
                  {gprun.i ""sosopka2.p""
                           "(input ship_line.abs_order,
                             input integer (ship_line.abs_line),
                             input - l_abs_pick_qty * decimal(ship_line.abs__qad03),
                             input l_delproc)"}

                  if sod_sched then
                     sod_pickdate = ?.

                  find so_mstr
                     where so_domain = global_domain
                     and   so_nbr = sod_nbr
                  no-lock no-error.

                  if available so_mstr
                     and so_secondary
                  then
                     run create-so-cmf (input recid (sod_det)).
               end. /* available sod_det and sod_cfg ... */

               del_lad = no.

            end. /* if sel_var_del = 2 and id beings i */

            /* Delete custom shipper document information
             * associated with the record */
            {gprun.i ""sofsde.p"" "(input recid(ship_line))"}

            /* DELETE RECORD */
            for first clc_ctrl
               fields (clc_domain clc_lotlevel)
               where   clc_domain = global_domain
            no-lock: end.

            if  available clc_ctrl then do:

               if clc_lotlevel = 1 then do:
                  for each lotw_wkfl
                     where lotw_domain = global_domain
                     and   lotw_mfguser = mfguser
                     and   lotw_lotser  = ship_line.abs_lotser
                     and   lotw_part    = ship_line.abs_item
                  exclusive-lock:
                     delete lotw_wkfl.
                  end. /* FOR EACH lotw_wkfl */
               end.  /* IF clc_lotlevel */

               if clc_lotlevel = 2 then do:
                  for each lotw_wkfl
                     where lotw_domain = global_domain
                     and   lotw_mfguser = mfguser
                     and   lotw_lotser  = ship_line.abs_lotser
                  exclusive-lock:
                     delete lotw_wkfl.
                  end. /* FOR EACH lotw_wkfl */
               end. /* IF clc_lotlevel */

            end. /* IF AVAILABLE clc_ctrl */

            delete ship_line.

         end. /* if sel_var_del = 2 or 3 */

         if sel_var_del = 1 then do:

            find abs_parent_buff
               where abs_parent_buff.abs_domain = global_domain
               and   recid(abs_parent_buff) = parent_abs_recid
            no-lock.

            for each absc_det
               where absc_domain = global_domain
               and   absc_abs_id = abs_parent_buff.abs_id
            exclusive-lock:
               delete absc_det.
            end.

            if using_container_charges or using_line_charges then
               /* DELETE THE USER FIELDS FROM THE CONTAINER*/
               run delete_absl_absd_detail (input recid(abs_parent_buff)).

            for each ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto begins tmp_prefix
            exclusive-lock:
               if ship_line.abs_par_id begins "i" then
                  del_lad = yes.
               else
                  del_lad = no.

               if not l_updalloc then
              l_ship_qty = ship_line.abs_qty.

               {absupack.i  "ship_line" 3 22 "l_abs_pick_qty"}

               if ship_line.abs_id begins "C"
               or ship_line.abs_id begins "I"
               then do:

                  /* SET GLOBAL_DB USING ABS_SITE */
                  new_site = ship_line.abs_site.
                  {gprun.i ""gpalias.p""}

                  /* SWITCH TO THE INVENTORY SITE */
                  if so_db <> global_db then do:
                     {gprun.i ""gpalias2.p""
                              "(input ship_line.abs_site, output errornum)"}

                      if errornum <> 0 and errornum <> 9 then do:
                        /* DOMAIN # IS NOT AVAILABLE */
                        run p-pxmsg (input 6137,
                                     input 4,
                                     input l_msgar1[2]).
                        undo DEL_LOOP, retry DEL_LOOP.
                     end. /* errornum <> 0 or 9 */
                  end. /* if so_db <> global_db */

                  /* DELETE ALLOCATION */

                  /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
                  {gprun.i ""soitallb.p""
                           "(input ship_line.abs_order,
                             input ship_line.abs_line,
                             input ship_line.abs_item,
                             input ship_line.abs_site,
                             input ship_line.abs_loc,
                             input ship_line.abs_lotser,
                             input ship_line.abs_ref,
                             input - l_ship_qty *
                                   decimal(ship_line.abs__qad03),
                             input - l_abs_pick_qty *
                                   decimal(ship_line.abs__qad03),
                             input del_lad,
                             input l_delproc,
                             output avail_qty,
                             output tmp_qty,
                             output undotran)"}

                  if undotran then
                     undo del_loop, retry del_loop.

                  del_lad = no.

                  /* SWITCH BACK TO THE SALES ORDER DOMAIN */
                  if so_db <> global_db then do:

                     /* UPDATE SALES ORDER DETAIL QTY ALL AND */
                     /* PICK IN REMOTE DOMAIN                 */
                     {gprun.i ""sosopka3.p""
                        "(input ship_line.abs_order,
                          input ship_line.abs_line,
                          input l_abs_pick_qty,
                          input ship_line.abs__qad03,
                          input l_delproc)"}

                     {gprun.i ""gpalias3.p"" "(so_db, output errornum)"}
                     if errornum <> 0 and errornum <> 9 then do:
                        /* DOMAIN # IS NOT AVAILABLE */
                        run p-pxmsg (input 6137,
                                     input 4,
                                     input l_msgar1[1]).
                        undo DEL_LOOP, retry DEL_LOOP.
                     end. /* if errornum <> 0 or 9 */
                  end. /* if so_db <> global_db */
               end. /* IF ship_line.abs_id BEGINS "C" ... */

               /* UPDATE ALLOCATION, PICK, AND SEND CMF MSG  */
               find sod_det
                  where sod_domain = global_domain
                  and   sod_nbr = ship_line.abs_order
                  and   sod_line = integer (ship_line.abs_line)
               no-lock no-error.

               if available sod_det
                  and sod_cfg_type <> "2"
               then do:
                  /* CONVERTED - L_ABS_PICK_QTY TO INVENTORY UM */
                  {gprun.i ""sosopka2.p""
                           "(input ship_line.abs_order,
                             input integer (ship_line.abs_line),
                             input - l_abs_pick_qty * decimal(ship_line.abs__qad03),
                             input l_delproc)"}

                  find so_mstr
                     where so_domain = global_domain
                     and   so_nbr = sod_nbr
                  no-lock no-error.

                  if available so_mstr
                     and so_secondary
                  then
                     run create-so-cmf (input recid (sod_det)).

                  if sod_sched then
                     sod_pickdate = ?.

               end. /* if available sod_det and ... */

               /* DELETE ABSR_DET RECORDS */
               if ship_line.abs_id begins "i"
               then do:
                  {gprun.i ""rcdlabsr.p""
                           "(input recid(ship_line))"}

                  /* DELETE SEQUENCES */
                  run delete_sequences
                     (input recid(ship_line)).

                  /* DELETE SHIPPER USER FIELDS AND LINE CHARGES */
                  if using_line_charges or using_container_charges then
                     run delete_absl_absd_detail (input recid(ship_line)).

                 /* DELETE SHIPMENT PERFORMANCE REASON CODES */
                 run delete_shipment_reasons
                    (input recid(ship_line)).

               end. /* abs_id begins "i" */

               /* Delete custom shipper document information
                * associated with the record */
               {gprun.i ""sofsde.p"" "(input recid(ship_line))"}

               for each lotw_wkfl
                  where lotw_domain = global_domain
                  and   lotw_mfguser = mfguser
               exclusive-lock:
                  delete lotw_wkfl.
               end.

               {gprun.i ""nrm.p"" " " "persistent set h_nrm"}

               /* RECORD CREATION IN nrh_hist WITH ACTION AS 'VOID' AFTER */
               /* DELETION OF SHIPPER */
               run nr_void_value in h_nrm(input ship_line.abs_nr_id,
                                          input substring(ship_line.abs_id,2),
                                          input " ").

               /* TO RELEASE THE LOCK ON nr_mstr/nrh_hist HELD BY THE HANDLE */
               delete procedure h_nrm no-error.

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

PROCEDURE add_proc:
   define output parameter next_editloop as logical no-undo.
   define output parameter next_mainloop as logical no-undo.
   define output parameter leave_editloop as logical no-undo.

   if not v_editall then do:
      {pxmsg.i &MSGNUM=5811 &ERRORLEVEL=3}
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
      {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3} /* NOT A VALID SELECTION */
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
      {pxmsg.i &MSGNUM=39 &ERRORLEVEL=1
               &CONFIRM=sel_var_add
               &CONFIRM-TYPE='NON-LOGICAL'}

      if (sel_var_add < 1 or sel_var_add > 4)
         or (sel_var_add <> 1 and ship_line.abs_id begins "i")
      then do:
         {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3} /* NOT A VALID CHOICE */
         undo GET_SELECTION_2, retry GET_SELECTION_2.
      end. /* if sel_var_add < 1 ... */

      valid_entry = true.
   end. /* get_selection_2 */

   /* HIDE FRAMES FOR ADD */
   hide frame m no-pause.
   hide frame sample no-pause.
   hide frame k no-pause.

   if batchrun and
      (lastkey = keycode("F4") or
      keyfunction(lastkey) = "END-ERROR" or
      keyfunction(lastkey) = "ENDKEY" or
      keyfunction(lastkey) = "."    or
      lastkey = keycode("CTRL-E"))
   then do:
      leave_editloop = yes.
      return.
   end. /* IF BATCHRUN AND */

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
         add_existing_container = true
         add_parent_container = true.

      /* ADD AN ITEM RECORD */
      if sel_var_add = 1 then
         assign
            add_container = false
            add_existing_container = false
            add_parent_container = false.

      /* ADD A CONTAINER RECORD */
      if sel_var_add = 2 then
         assign
            add_item = false
            add_existing_container = false
            add_parent_container = false.

      if sel_var_add = 3 then
         add_existing_container = false.

      if sel_var_add = 4 then
         assign
            add_item = false
            add_parent_container = false
            add_container = false.

      create_recs = true.
      assign next_mainloop = yes.
      return.
   end. /* IF VALID ENTRY */
END PROCEDURE. /* add_proc */

PROCEDURE navigate_proc:
   define variable n as integer no-undo.
   define variable loopMax as integer no-undo.

   if (keyfunction(lastkey) = "page-down" or
       lastkey = keycode("F8"))
   then do with frame k:

      loopMax = frame-down - frame-line + 1.

      PAGEDOWNLOOP:
      do n = 1 to loopMax:

         if l_absso_recid <> ? then
            find first ship_line
               where recid(ship_line) = l_absso_recid
            no-lock no-error.

         find next ship_line
            where ship_line.abs_domain = global_domain
            and   ship_line.abs_shipfrom = ship_from
            and   ship_line.abs_shipto begins tmp_prefix
         exclusive-lock no-error.

         if available ship_line then
            l_absso_recid = recid(ship_line).

         if not available ship_line then do:
            find last ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto >= tmp_prefix
               and   ship_line.abs_shipto <= tmp_prefix  + fill(hi_char,8)
            exclusive-lock no-error.

            leave PAGEDOWNLOOP.
         end.
      end.

      run findSalesOrderDet.

      if available ship_line
         and can-find(first absl_det
         where absl_domain = global_domain
         and   absl_abs_id = ship_line.abs_id
         and   absl_abs_shipfrom = ship_line.abs_shipfrom)
       then
         /*ADDITIONAL LINE CHARGES EXIST FOR THIS LINE ITEM*/
         run p-pxmsg (input 4457,
                      input 1,
                      input "").
      assign
         save_frame_line = 1
         abs_recid = recid(ship_line)
         refresh = yes.

      return.

   end. /* If (keyfunction(lastkey) = "page-down" or ... */

   if (keyfunction(lastkey) = "page-up" or
       lastkey = keycode("F7"))
   then do with frame k:

      loopMax = frame-line - 1 + frame-down.

      PAGEUPLOOP:
      do n = 1 to loopMax:

         if l_absso_recid <> ? then
            find first ship_line
               where recid(ship_line) = l_absso_recid
            no-lock no-error.

         find prev ship_line
            where ship_line.abs_domain = global_domain
            and   ship_line.abs_shipfrom = ship_from
            and   ship_line.abs_shipto begins tmp_prefix
         exclusive-lock no-error.

         if available ship_line then
            l_absso_recid = recid(ship_line).

         if not available ship_line then do:
            find first ship_line
               where ship_line.abs_domain = global_domain
               and   ship_line.abs_shipfrom = ship_from
               and   ship_line.abs_shipto begins tmp_prefix
            exclusive-lock no-error.

            leave PAGEUPLOOP.
         end.
      end.

      run findSalesOrderDet.

      if available ship_line
         and can-find(first absl_det
         where absl_domain = global_domain
         and   absl_abs_id = ship_line.abs_id
         and absl_abs_shipfrom = ship_line.abs_shipfrom)
      then
         /*ADDITIONAL LINE CHARGES EXIST FOR THIS LINE ITEM*/
         run p-pxmsg (input 4457,
                      input 1,
                      input "").

      assign
         save_frame_line = 1
         abs_recid = recid(ship_line)
         refresh = yes.

      return.

   end. /* If (keyfunction(lastkey) = "page-up" or ... */


   /* HANDLE CURSOR MOVEMENT UP */
   if (lastkey = keycode("F9")
      or keyfunction(lastkey) = "CURSOR-UP")
   then do:

      if l_absso_recid <> ? then
         find first ship_line
            where recid(ship_line) = l_absso_recid
         no-lock no-error.

      /* MOVE UP ONE LINE IN SCROLLING WINDOW */
      find prev ship_line
         where ship_line.abs_domain = global_domain
         and   ship_line.abs_shipfrom = ship_from
         and   ship_line.abs_shipto begins tmp_prefix
      exclusive-lock no-error.

      if available ship_line then do:
         l_absso_recid = recid(ship_line).

         run findSalesOrderDet.

         up 1 with frame k.

         /* SET UP DISP_LINE */
         {rcshwbb1.i}

         display
            fill(".",minimum(4,integer(ship_line.abs__qad06)))
            + ship_line.abs__qad06
            @ first_column
            disp_line
         with frame k.

         if can-find(first absl_det
            where absl_det.absl_domain = global_domain
            and   absl_abs_id = ship_line.abs_id
            and  absl_abs_shipfrom = ship_line.abs_shipfrom)
         then
            /*ADDITIONAL LINE CHARGES EXIST FOR THIS LINE ITEM*/
            run p-pxmsg (input 4457,
                         input 1,
                         input "").
      end.
      else do:
         /* NO RECORD FOUND */
         find first ship_line
            where ship_line.abs_domain = global_domain
            and   ship_line.abs_shipfrom = ship_from
            and   ship_line.abs_shipto begins tmp_prefix
         exclusive-lock no-error.

         bell.

         if can-find(first absl_det
            where absl_det.absl_domain = global_domain
            and   absl_abs_id = ship_line.abs_id
            and   absl_abs_shipfrom = ship_line.abs_shipfrom)
         then
            /*ADDITIONAL LINE CHARGES EXIST FOR THIS LINE ITEM*/
            run p-pxmsg (input 4457,
                         input 1,
                         input "").
      end.
   end. /* IF LASTKEY = F9 */

   /* HANDLE CURSOR MOVEMENT DOWN */
   if (lastkey = keycode("F10")
      or keyfunction(lastkey) = "CURSOR-DOWN")
   then do:

      if l_absso_recid <> ? then
         find first ship_line
            where recid(ship_line) = l_absso_recid
         no-lock no-error.

      /* MOVE DOWN ONE LINE IN SCROLLING WINDOW */
      find next ship_line
         where ship_line.abs_domain = global_domain
         and   ship_line.abs_shipfrom = ship_from
         and   ship_line.abs_shipto begins tmp_prefix
      exclusive-lock no-error.

      if available ship_line then do:
         l_absso_recid = recid(ship_line).

         run findSalesOrderDet.

         down 1 with frame k.

         if can-find(first absl_det  where absl_det.absl_domain = global_domain
         and  absl_abs_id = ship_line.abs_id
                     and absl_abs_shipfrom = ship_line.abs_shipfrom)
         then /*ADDITIONAL LINE CHARGES EXIST FOR THIS LINE ITEM*/
            run p-pxmsg (input 4457,
                         input 1,
                         input "").

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
            where ship_line.abs_domain = global_domain
            and   ship_line.abs_shipfrom = ship_from
            and   ship_line.abs_shipto >= tmp_prefix
            and   ship_line.abs_shipto <= tmp_prefix + fill(hi_char,8)
         exclusive-lock no-error.

         bell.

      end.
   end. /* IF LASTKEY = F10 */
END PROCEDURE. /* navigate_proc */

PROCEDURE p_clean_up:

   define input parameter l_shpfrm  like abs_shipfrom no-undo.
   define input parameter l_tmpprfx as   character    no-undo.

   for each ship_line
      where ship_line.abs_domain = global_domain
      and   ship_line.abs_shipfrom    = l_shpfrm
      and   ship_line.abs_shipto begins l_tmpprfx
   exclusive-lock:

      ship_line.abs_shipto = ship_line.abs__qad05.
   end.

end. /* PROCEDURE p_clean_up */

PROCEDURE p_update_alloc:
   /* THIS PROCEDURE IS USED FOR UPDATING THE LD_DET AND LAD_DET   */
   /* WHEN THE SALES ORDER IS CHANGED.                             */

   /* LOCAL VARIABLES */
   define variable l_adj_qty  like ld_qty_all   no-undo.
   define variable l_sod_all  like sod_qty_all  no-undo.

   /* THE PROGRAM SOITALLD.P WHICH IS USED FOR UPDATING THE  */
   /* LAD_DET AND LD_DET FOR CHANGE IN ALLOCATION AND PICK.  */
   /* CANNOT BE USED FOR CREATING THE DETAIL ALLOCATIONS FOR */
   /* CHANGE IN SO, SINCE IT ONLY UPDATES THE EXISTING LAD_DET */
   /* IF CHANGE IN SHIP AND PICK ARE BOTH NON ZERO. AND DOESNT */
   /* CREATE ONE IF NONE EXIST. WE HANDLE THIS BY USING 2 CALLS */
   /* TO SOITALLA.P, ONE TO CREATE AN LAD_DET WITH PICK = SHIP. */
   /* AND THE SECOND TO ADJUST THE PICK QTY.                    */

   /* SET GLOBAL_DB USING ABS_SITE */
   new_site = ship_line.abs_site.
   {gprun.i ""gpalias.p""}

   /* SWITCH TO THE INVENTORY SITE */
   if so_db <> global_db then do:
      {gprun.i ""gpalias2.p""
               "(input  ship_line.abs_site,
                 output errornum)"}

      if errornum <> 0 and errornum <> 9 then do:
         /* DOMAIN # IS NOT AVAILABLE */
         run p-pxmsg (input 6137,
                      input 4,
                      input l_msgar1[2]).
         undotran = yes.
         return.
      end. /* IF ERRORNUM <> 0 ... */
   end. /* IF SO_DB <> GLOBAL_DB */

   /* DO THE GENERAL ALLOCATIONS */
   for first soc_ctrl
      fields (soc_domain soc_all_days)
      where   soc_domain = global_domain
   no-lock:
   end.

   {gprun.i ""soitallc.p""
            "(input ship_line.abs_order,
              input integer(ship_line.abs_line),
              input soc_all_days,
              input ship_line.abs_qty *
                    decimal(ship_line.abs__qad03) / sod_det.sod_um_conv,
              output l_sod_all)"}

   /* CREATE DETAIL ALLOCATIONS */

   /* CHANGED 8th INPUT PARAMETER FROM      */
   /* ship_line.abs_qty *                   */
   /*         decimal(ship_line.abs__qad03) */
   /* TO l_abs_pick_qty                     */
   /*         decimal(ship_line.abs__qad03) */
   /* TO  ENSURE CORRECT UPDATE OF INVENTORY*/
   /* TABLES                                */

   {gprun.i ""soitalla.p""
            "(input ship_line.abs_order,
              input ship_line.abs_line,
              input ship_line.abs_item,
              input ship_line.abs_site,
              input ship_line.abs_loc,
              input ship_line.abs_lotser,
              input ship_line.abs_ref,
              input l_abs_pick_qty * decimal(ship_line.abs__qad03),
              input 0,
              output adj_qty,
              output undotran)"}

    /* ADJUST THE PICK QTY IF NECESSARY*/

    adj_qty    = adj_qty     + l_adj_qty.

   /* SWITCH BACK TO THE SALES ORDER DOMAIN */
   if so_db <> global_db then do:

      /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
      /* IN REMOTE DOMAIN                         */
      if not kit_comp then do:
         {gprun.i ""sosopka2.p""
                  "(input ship_line.abs_order,
                    input integer (ship_line.abs_line),
                    input l_abs_pick_qty
                          * decimal(ship_line.abs__qad03),
                    input l_delproc)"}
      end. /* IF NOT KIT_COMP */

      {gprun.i ""gpalias3.p"" "(input so_db, output errornum)"}

      if errornum <> 0 and errornum <> 9 then do:
         /* DOMAIN # IS NOT AVAILABLE */
         run p-pxmsg (input 6137,
                      input 4,
                      input l_msgar1[1]).
         undotran = yes.
         return.
      end. /* IF ERRORNUM <> 0 ... */
   end. /* IF SO_DB <> GLOBAL_DB */

   if undotran then
      return.

   /* UPDATE THE SALES ORDER QTY ALL, QTY PICK */
   if not kit_comp then do:

      /* IF GENERAL ALLOCATIONS WERE DONE PREVIOUSLY THEN UPDATE */
      /* THE SOD_QTY_ALL IN THE CENTRAL DOMAIN BEFORE ADJUSTMENT OF  */
      /* THE PICK QTY BY SOSOPKA2.P.                             */
      if sod_det.sod_qty_all = 0 then do:
         find sod_det
            where sod_domain = global_domain
            and   sod_nbr  = ship_line.abs_order
            and   sod_line = integer(ship_line.abs_line)
         exclusive-lock.

         assign
            sod_qty_all = l_sod_all.

         find sod_det
            where sod_domain = global_domain
            and  sod_nbr  = ship_line.abs_order
            and  sod_line = integer(ship_line.abs_line)
         no-lock.
      end. /* IF SOD_DET.SOD_QTY_ALL = 0 */

      /* UPDATE THE SO QTY PICKED */
      {gprun.i ""sosopka2.p""
               "(input ship_line.abs_order,
                 input integer (ship_line.abs_line),
                 input l_abs_pick_qty
                       * decimal(ship_line.abs__qad03),
                 input l_delproc)"}

   end. /* IF NOT KIT_COMP */
END PROCEDURE. /* P_UPDATE_ALLOC */

PROCEDURE p_update_alloc1:
   /* THIS PROCEDURE IS USED FOR UPDATING THE LD_DET AND LAD_DET   */
   /* WHEN THE SHIP AND/OR PICK QTY IS CHANGED.                    */

   /* SET GLOBAL_DB USING ABS_SITE */
   new_site = ship_line.abs_site.
   {gprun.i ""gpalias.p""}

   /* SWITCH TO THE INVENTORY SITE */
   if so_db <> global_db then do:
      {gprun.i ""gpalias2.p""
               "(input  ship_line.abs_site,
                 output errornum)"}

      if errornum <> 0 and errornum <> 9 then do:
         /* DOMAIN # IS NOT AVAILABLE */
         run p-pxmsg (input 6137,
                      input 4,
                      input l_msgar1[2]).
         undotran = yes.
         return.
      end. /* IF ERRORNUM <> 0 ... */
   end. /* IF SO_DB <> GLOBAL_DB */

   if (qty_old = ship_line.abs_qty)
      and (old_qty <> l_abs_pick_qty)
   then do:

      {gprun.i ""soitalla.p""
               "(input ship_line.abs_order,
                 input ship_line.abs_line,
                 input ship_line.abs_item,
                 input old_site,
                 input old_loc,
                 input old_lot,
                 input old_ref,
                 input (l_abs_pick_qty - old_qty) *
                       decimal(ship_line.abs__qad03),
                 input (ship_line.abs_qty - old_qty) *
                       decimal(ship_line.abs__qad03),
                 output adj_qty,
                 output undotran)"}

   end. /* IF QTY_OLD = SHIP_LINE.ABS_QTY AND ... */
   else do:
      {gprun.i ""soitalld.p""
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
                 input qty_old * decimal(ship_line.abs__qad03),
                 input del_lad,
                 output adj_qty,
                 output undotran)"}

   end. /*  ELSE DO */

   /* SWITCH BACK TO THE SALES ORDER DOMAIN */
   if so_db <> global_db then do:

      /* UPDATE SALES ORDER DETAIL QTY ALL AND PICK */
      /* IN REMOTE DOMAIN                         */
      if not kit_comp then do:
         {gprun.i ""sosopka2.p""
                  "(input ship_line.abs_order,
                    input integer (ship_line.abs_line),
                    input adj_qty,
                    input l_delproc)"}

      end. /* IF NOT KIT_COMP */

      {gprun.i ""gpalias3.p"" "(input so_db, output errornum)"}

      if errornum <> 0 and errornum <> 9 then do:
         /* DOMAIN # IS NOT AVAILALBE */
         run p-pxmsg (input 6137,
                      input 4,
                      input l_msgar1[1]).
         undotran = yes.
         return.
      end. /* IF ERRORNUM <> 0 ... */
   end. /* IF SO_DB <> GLOBAL_DB */

   if undotran then
      return.

   /* UPDATE THE SALES ORDER QTY ALL, QTY PICK */
   if not kit_comp then
      {gprun.i ""sosopka2.p""
               "(input ship_line.abs_order,
                 input integer (ship_line.abs_line),
                 input adj_qty,
                 input l_delproc)"}

END PROCEDURE. /* P_UPDATE_ALLOC1 */

PROCEDURE ip-refresh:

   /* THIS PROCEDURE REFRESHES THE LOWER SCREEN WHEN ENDKEY  */
   /* IS PRESSED                                             */
   display
      ship_line.abs_order @ part_order
      ship_line.abs_line @ part_order_line
      qty_old @ ship_line.abs_qty
      old_qty @ l_abs_pick_qty
      l_twt_old @ l_abs_tare_wt
      ship_line.abs_wt_um @ l_twt_um
      ship_line.abs__qad02
      old_site @ ship_line.abs_site
      old_loc @ ship_line.abs_loc
      nwt_old @ ship_line.abs_nwt
      ship_line.abs_wt_um
      old_lot @ ship_line.abs_lot
      ship_line.abs_gwt
      ship_line.abs_wt_um @ gwt_um
      old_ref @ ship_line.abs_ref
      sod_det.sod_type when (available sod_det)
      "" when (not available sod_det) @ sod_type
      vol_old @ ship_line.abs_vol
      ship_line.abs_vol_um
      cnsm_req
      pt_mstr.pt_desc1 when (available pt_mstr)
      "" when (not available pt_mstr) @ pt_desc1
      l_contr_id @ sod_contr_id
      cmmts
      cancel_bo
      ship_line.abs_fa_lot
   with frame sample.
END PROCEDURE. /* PROCEDURE IP-REFRESH */

PROCEDURE maintain_sequences:
   define input parameter l_abs_id  like abs_id no-undo.
   define input parameter l_shipfrom like abs_shipfrom no-undo.

   for first abs_mstr
      where abs_mstr.abs_domain = global_domain
      and   abs_id = l_abs_id
      and   abs_shipfrom = l_shipfrom
   no-lock: end.

   if available (abs_mstr) then do:
      /* IS CUST. SEQ. SCHEDULES INSTALLED ? */
      if can-find (mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and
         mfc_field = "enable_sequence_schedules" and
         mfc_logical) and rcf_file_found then do:

         for first so_mstr
            where so_domain = global_domain
            and   so_nbr = abs_order
         no-lock:

            if so_seq_order then do:

               /* MAINTAIN SEQUENCES FOR abs_mstr */
               {gprunmo.i &program = ""rcabssup.p"" &module = "ASQ"
                          &param   = """(input l_abs_id,
                                         input l_shipfrom,
                                         input "yes")"""}

               /*PUT THE STATUS LINE BACK */
               status input stline[13].
            end. /* IF so_seq_order */
         end.  /* FOR FIRST so_mstr */
      end. /* if can-find */
   end. /* if available */
END PROCEDURE.  /* maintain_sequences */

PROCEDURE delete_sequences:
   define input parameter l_recid  as recid no-undo.

   for first abs_mstr
      where abs_mstr.abs_domain = global_domain
      and   recid(abs_mstr) = l_recid
   no-lock:
      /* IS CUST. SEQ. SCHEDULES INSTALLED ? */
      if can-find (mfc_ctrl
         where mfc_ctrl.mfc_domain = global_domain
         and   mfc_field = "enable_sequence_schedules"
         and   mfc_logical) and rcf_file_found
      then do:

         /* DELETE SEQUENCES */
         {gprunmo.i &program = ""rcabssdl.p"" &module = "ASQ"
                    &param   = """(input l_recid, input '')"""}
      end. /* if can-find */
   end. /* for first abs_mstr */
END PROCEDURE.  /* delete_sequences */

PROCEDURE check_tablename:
   define input parameter l_tablename as character no-undo.
   define output parameter l_file_found like mfc_logical  no-undo.

   /* VARIABLE DEFINITIONS FOR gpfile.i */
   {gpfilev.i}

   {gpfile.i &file_name = l_tablename}
   l_file_found = file_found.

END PROCEDURE.  /* check_tablename */

PROCEDURE p-pxmsg:
   define input parameter p_num     as integer   no-undo.
   define input parameter p_stat    as integer   no-undo.
   define input parameter p_msgarg1 as character no-undo.

   {pxmsg.i &MSGNUM  = p_num  &ERRORLEVEL = p_stat
            &MSGARG1 = p_msgarg1}

END PROCEDURE. /* PROCEDURE p-pxmsg */

PROCEDURE p-pxmsgconfirm:
   define input parameter p_num     as integer   no-undo.
   define input parameter p_stat    as integer   no-undo.
   define input-output parameter p_confirm like mfc_logical no-undo.

   {pxmsg.i &MSGNUM  = p_num  &ERRORLEVEL = p_stat
            &CONFIRM = p_confirm}

END PROCEDURE. /* PROCEDURE p-pxmsgconfirm */

PROCEDURE p-pxmsg1:
   define input parameter p_num     as integer   no-undo.
   define input parameter p_stat    as integer   no-undo.
   define input parameter p_msgarg1 as character no-undo.
   define input parameter p_msgarg2 as character no-undo.

   {pxmsg.i &MSGNUM  = p_num  &ERRORLEVEL = p_stat
            &MSGARG1 = p_msgarg1
            &MSGARG2 = p_msgarg2}

END PROCEDURE. /* PROCEDURE p-pxmsg1 */

PROCEDURE p-alloclad:
/* ACCUMULATE lad_qty_all FOR ALL SHIPPERS FOR PART */

   l_lad_qty_all = 0.
   for each lad_det
       fields (lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
               lad_part lad_qty_all lad_qty_pick lad_ref lad_site)
       where   lad_domain = global_domain
       and     lad_site   = ship_line.abs_site
       and lad_loc        = ship_line.abs_loc
       and lad_part       = ship_line.abs_item
       and lad_lot        = ship_line.abs_lot
       and lad_ref        = ship_line.abs_ref
   no-lock:
       l_lad_qty_all     = l_lad_qty_all + lad_qty_all.
   end. /* FOR EACH lad_det */

END PROCEDURE. /* PROCEDURE p-alloclad */

PROCEDURE ValidateSalesOrderLine:
   define input parameter ipOrder like abs_order no-undo.
   define input parameter ipOrderLine like abs_line no-undo.
   define input parameter ipShipFrom like abs_shipfrom no-undo.
   define input parameter ipShipTo like abs_shipto no-undo.
   define output parameter opErrorOrder like mfc_logical no-undo.
   define output parameter opErrorOrderLine like mfc_logical no-undo.
   define output parameter opErrorNumber as integer no-undo.
   define output parameter opErrorSite like sod_site no-undo.

   for first so_mstr
      where so_domain = global_domain
      and   so_nbr = part_order
   no-lock: end.

   if not available so_mstr then
      assign
         opErrorOrder = yes
         opErrorNumber = 609. /*SALES ORDER DOESN'T EXIST*/
   else do:

      for first ad_mstr
         fields (ad_domain ad_addr)
         where ad_domain = global_domain
         and   ad_addr   = ipShipTo no-lock:
      end. /* FOR FIRST ad_mstr */

      for first ls_mstr
         fields (ls_domain ls_addr ls_type)
         where ls_domain = global_domain
         and   ls_addr   = ad_addr
         and  (ls_type   = "ship-to" or
               ls_type   = "customer") no-lock:
      end. /* FOR FIRST ls_mstr */

      do while not available ls_mstr
         and ad_ref > "":

         l_addr = ad_ref.

         for first ad_mstr
            fields (ad_domain ad_addr)
            where ad_domain = global_domain
            and   ad_addr   = l_addr no-lock:
         end. /* FOR FIRST ad_mstr */

         for first ls_mstr
            fields (ls_domain ls_addr ls_type)
            where ls_domain = global_domain
            and   ls_addr   = ad_addr
            and  (ls_type   = "ship-to" or
                  ls_type   = "customer") no-lock:
         end. /* FOR FIRST ls_mstr */
      end. /* DO WHILE NOT AVAIL ls_mstr */

      l_ship_id = ad_addr.

      if (so_ship <> ipShipTo) and
         (so_ship <> l_ship_id)
      then do:
         assign
            opErrorOrder = yes
            opErrorSite = so_ship
            opErrorNumber = 8229. /*INVALID ORDER SHIP-TO*/
         leave.
      end.

      for first sod_det
         where sod_domain = global_domain
         and   sod_nbr = so_nbr
         and   sod_line = integer(ipOrderLine)
      no-lock: end.

      if not available sod_det then do:
         assign
            opErrorOrderLine = yes
            opErrorNumber = 764. /*SALES ORDER LINE DOESNT EXIST*/
        leave.
      end.
      if sod_site <> ipShipFrom then do:
         assign
            opErrorOrder = yes
            opErrorSite = sod_site
            opErrorNumber = 8228. /*INVALID ORDER SHIPFROM SITE*/
         leave.
      end.
   end.

END PROCEDURE.

PROCEDURE delete_absl_absd_detail:
   define input parameter ipAbsRecID as recid no-undo.

   if can-find (first abs_mstr
      where abs_domain = global_domain
      and   recid(abs_mstr) = ipAbsRecID)
   then do:

      /* DELETE SHIPPER USER FIELDS AND LINE CHARGES */
      {gprunmo.i &program = "rcabsdd.p" &module = "ACL"
                 &param   = """(input ipAbsRecID)"""}
   end. /* IF CAN-FIND abs_mstr */

END PROCEDURE.

PROCEDURE getUserFieldData:
   define input parameter ipSpecificField like mfc_logical.
   define input parameter ipFieldName as character.
   define input parameter ipAbsID like abs_id.
   define input parameter ipShipfrom like abs_shipfrom.

   if can-find(first absd_det
      where absd_det.absd_domain = global_domain
      and   absd_abs_id = ipAbsID
      and   absd_shipfrom = ipShipfrom
      and   absd_abs_fld_name = (if ipSpecificField then
                                    ipFieldName else "")
      and absd_fld_prompt = yes)
   then do:

      {gprunmo.i &program = ""rcswbuf.p"" &module = "ACL"
                 &param  = """(input ipSpecificField,
                               input ipFieldName,
                               input ipAbsID,
                               input ipShipfrom)"""}
   end. /*IF CAN-FIND*/

END PROCEDURE. /*getUserFieldData*/

PROCEDURE getLineCharges:
   /* PARAMETERS
    * ipShipfrom - Site Address
    * ipAbsID - abs_id from ship_line
    * ipSoRecno - recid for so_mstr
    * ipSodRecno - recid for sod_det
    */
   define input parameter ipShipfrom like abs_shipfrom no-undo.
   define input parameter ipAbsID like abs_id no-undo.
   define input parameter ipSoRecno as recid no-undo.
   define input parameter ipSodRecno as recid no-undo.

   {gprunmo.i &program = "rcabslmt.p" &module = "ACL"
              &param   = """(input ipSoRecno,
                             input ipSodRecno,
                             input ipAbsID,
                             input ipShipfrom)"""}

END PROCEDURE.  /*getLineCharges*/

PROCEDURE maintain_shipment_reasons:
   define input parameter v_abs_id like abs_id no-undo.
   define input parameter v_shipfrom like abs_shipfrom no-undo.

   for first shpc_ctrl
      fields (shpc_domain shpc_shipper_reasons)
      where   shpc_domain = global_domain
   no-lock: end.

   if can-find (first abs_mstr
      where abs_domain = global_domain
      and   abs_id = v_abs_id
      and   abs_shipfrom = v_shipfrom)
   then do:

     /* IS SHIPMENT PERFORMANCE INSTALLED? */
     if can-find(mfc_ctrl
        where mfc_domain = global_domain
        and   mfc_field = "enable_shipment_perf"
        and   mfc_logical) and shpc_file_found
        and   shpc_shipper_reasons
     then do:

        {gprunmo.i &program = ""sorsnup.p"" &module = "ASR"
                   &param   = """(input v_abs_id,
                                  input v_shipfrom)"""}

      end. /* IF CAN-FIND mfc_ctrl */
   end. /* IF CAN-FIND (abs_mstr) */
END PROCEDURE.

PROCEDURE delete_shipment_reasons:
   define input parameter v_recid as recid no-undo.

   if can-find (first abs_mstr
      where abs_domain = global_domain
      and   recid(abs_mstr) = v_recid)
   then do:

      if can-find (mfc_ctrl
         where mfc_domain = global_domain
         and   mfc_field = "enable_shipment_perf"
         and   mfc_logical) and shpc_file_found
      then do:

         /* DELETE REASON CODES */
         {gprunmo.i &program = ""sorsndel.p"" &module = "ASR"
                    &param   = """(input v_recid)"""}

      end. /* IF CAN-FIND mfc_ctrl */
   end. /* IF CAN-FIND abs_mstr */
END PROCEDURE.

{rcinvcon.i}   /* INTERNAL PROCEDURE get_abs_parent INCLUDED IN THIS .i */

PROCEDURE validateSOFrTerms:
/*--------------------------------------------------------------------
 * Purpose:     Get the highest level parent (Shipper record)
 *              Get the first order attached to this shipper along with
 *                 the freight terms on this order.
 *              Compare the terms on this order to those on the order being
 *                attached and return op_FrTermsErr if they are different.
 * Parameters:
 * Notes:
 *----------------------------------------------------------------------*/
   define input parameter ip_AbsId        like   abs_id       no-undo.
   define input parameter ip_ShipFrom     like   abs_shipfrom no-undo.
   define input parameter ip_ParentRecId  as   recid    no-undo.
   define input parameter ip_Order        like so_nbr  no-undo.

   define output parameter op_FrTermsOnFirstOrder as character  no-undo.
   define output parameter op_FrTermsErr like mfc_logical  no-undo.

   define buffer b1_abs_mstr for abs_mstr.
   define buffer b2_abs_mstr for abs_mstr.
   define buffer b_so_mstr for so_mstr.

   define variable par_absid like abs_id no-undo.
   define variable par_shipfrom like abs_shipfrom no-undo.
   define variable l_FirstOrder like so_nbr no-undo.
   define variable l_OrderFrTerms like so_fr_terms no-undo.

   for first b_so_mstr
      fields (so_domain so_fr_terms)
      where b_so_mstr.so_domain = global_domain
      and   b_so_mstr.so_nbr = ip_Order
    no-lock: end.

   if not available b_so_mstr then
      return.
   else
     l_OrderFrTerms = b_so_mstr.so_fr_terms.

   /* MAKE SURE THAT THE PARENT_ID IS ACTUALLY THE HIGHEST LEVEL PARENT */
   for first b1_abs_mstr
      where recid(b1_abs_mstr) = ip_ParentRecId
   no-lock: end.

   if available b1_abs_mstr
      and b1_abs_mstr.abs_par_id = ""
   then
      assign
         par_absid = b1_abs_mstr.abs_id
         par_shipfrom = b1_abs_mstr.abs_shipfrom.
   else do:
      run get_abs_parent
         (input ip_AbsId,
          input ip_ShipFrom,
          output par_absid,
          output par_shipfrom).

   end. /* ELSE, NOT AVAILABLE b1_abs_mstr */

   if par_absid <> ?
   then do for b2_abs_mstr:
      for first b2_abs_mstr
         where b2_abs_mstr.abs_domain = global_domain
         and b2_abs_mstr.abs_id = par_absid
         and b2_abs_mstr.abs_shipfrom = par_shipfrom
      no-lock: end.

      if available b2_abs_mstr then do:
         {gprunmo.i  &module = "LA" &program = "lashex01.p"
                     &param  = """(buffer b2_abs_mstr,
                                   output l_FirstOrder,
                                   output op_FrTermsOnFirstOrder)"""}

         /* IF THERE IS AN ORDER ATTACHED TO THE PARENT ABS_MSTR,   */
         /* COMPARE THE FREIGHT TERMS ON THAT ORDER TO THOSE ON THE */
         /* ORDER BEING ATTACHED.                                   */
         if l_FirstOrder <> ""
            and op_FrTermsOnFirstOrder <> l_OrderFrTerms
         then do:
            op_FrTermsErr = true.
            return.
         end. /* IF l_FirstOrder <> "" AND... */

      end. /* IF AVAILABLE b2_abs_mstr */
   end. /* DO FOR ABS_BUFF6 */

END PROCEDURE. /* validateSOFrTerms */

PROCEDURE findSalesOrderDet:
 /*--------------------------------------------------------------------------
  * Purpose : Find sod_det record based on the available ship_line
  *           record.
  *------------------------------------------------------------------------*/
   if available ship_line then do:
      for first sod_det
         fields (sod_domain sod_cfg_type sod_contr_id sod_fa_nbr sod_line
                 sod_nbr sod_site
                 sod_part sod_pickdate sod_qty_all sod_qty_ord sod_qty_pick
                 sod_qty_ship sod_sched sod_type sod_um_conv sod__qadl01)
         where   sod_domain = global_domain
         and     sod_nbr    = ship_line.abs_order
         and     sod_line   = integer(abs_line)
      no-lock: end.
   end.
END PROCEDURE. /* FindSalesOrderDet */

PROCEDURE check-reserved-location:
/*--------------------------------------------------------------------
 * Purpose:    Check if Reserved Locations to be used is valid.
 *----------------------------------------------------------------------*/

   ret-flag = 2.

   /* BYPASS CHECKING SSM ORDERS */
   if so_mstr.so_fsm_type = "" then do:

      {gprun.i ""sorlchk.p""
               "(input so_ship,
                 input so_bill,
                 input so_cust,
                 input abs_child_buff.abs_site,
                 input abs_child_buff.abs_loc,
                 output ret-flag)"}

   end. /* IF so_mstr.so_fsm_type = "" */

END PROCEDURE. /* check-reserved-location */

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

PROCEDURE p_chk_serial:

   /* EXPLODES THE SHIPPER INTO WORK2_ABS_MSTR AND CHECKS IF */
   /* CURRENT ITEM/SERIAL/REF NUMBER ALREADY EXISTS          */
   define input  parameter i_ship_from  as   character   no-undo.
   define input  parameter i_abs_recid  as   recid       no-undo.
   define input  parameter i_abs_item   as   character   no-undo.
   define input  parameter i_abs_lot    as   character   no-undo.
   define output parameter o_undo       like mfc_logical no-undo.

   define variable parent_id as   character   no-undo.
   define variable l_allowed like mfc_logical no-undo.
   define variable l_item    as   character   no-undo.
   define variable l_lot     as   character   no-undo.

   /* FIND THE SHIPPER ID */
   for first abs_parent_buff
      fields(abs_id)
      where recid(abs_parent_buff) = i_abs_recid
   no-lock:
   end. /* FOR FIRST abs_parent_buff */

   assign
      o_undo    = no
      parent_id = abs_parent_buff.abs_id
      l_allowed = yes.

   empty temp-table work2_abs_mstr.

   /* EXPLODE THE SHIPPER */
   {gprun.i ""rcabsexp.p"" "(input        i_ship_from,
                             input        parent_id,
                             input-output l_allowed,
                             input-output l_item,
                             input-output l_lot)"}

   if can-find(first work2_abs_mstr
                  where work2_abs_mstr.w_abs_shipfrom
                        = i_ship_from
                    and work2_abs_mstr.w_abs_id
                        begins "i"
                    and work2_abs_mstr.w_abs_item
                        = i_abs_item
                    and work2_abs_mstr.w_abs_lot
                        = i_abs_lot
                    use-index order)
   then do:

      /* SERIAL: # FOR PART: # ALREADY PICKED IN THIS SHIPMENT */
      run DisplayMessage(input 6592,
                         input 3,
                         input i_abs_lot,
                         input i_abs_item).
      empty temp-table work2_abs_mstr.
      o_undo = yes.

   end. /* IF CAN-FIND(FIRST work2_abs_mstr */

END PROCEDURE. /* PROCEDURE p_chk_serial */
