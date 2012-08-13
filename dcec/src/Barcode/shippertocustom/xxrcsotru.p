/* xxrcsotru.p - Customer Schedules Transfer Inventory to Customer Location   */
/* REVISION: 9.0      LAST MODIFIED: 01/19/99   BY: *M05Q* Seema Varma       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */

         /* ********** Begin Translatable Strings Definitions ********* */
         {mfdeclre.i} /*GUI moved to top.*/

         &SCOPED-DEFINE xxrcsotru_p_1 "货物发往/码头"
         /* MaxLen: Comment: */ 

         &SCOPED-DEFINE xxrcsotru_p_2 "货物移出"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE xxrcsotru_p_3 "货运单号"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE xxrcsotru_p_11 "P-备料单/S-货运单"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE xxrcsotru_p_15 "号码"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE xxrcsotru_p_21 "生效日期"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */
         {gldydef.i new}
         {gldynrm.i new}

         /* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
         define new shared variable rndmthd like rnd_rnd_mthd.
         define new shared variable abs_carr_ref as character.
         define new shared variable abs_fob like so_fob.
         define new shared variable abs_recid as recid.
         define new shared variable abs_shipvia like so_shipvia.
         define new shared variable accum_wip like tr_gl_amt.
         define new shared variable already_posted like glt_amt.
         define new shared variable base_amt   like ar_amt.
         define new shared variable change_db like mfc_logical.
         define new shared variable eff_date like glt_effdate label {&xxrcsotru_p_21}.
         define new shared variable loc like pt_loc.
         define new shared variable lotserial_total like tr_qty_chg.
         define new shared variable order_ct as integer.
         define new shared variable order_nbrs as character extent 30.
         define new shared variable qty as decimal.
         define new shared variable qty_ord  like sod_qty_ord.
         define new shared variable qty_req like in_qty_req.
         define new shared variable qty_ship like sod_qty_ship.
         define new shared variable ref like glt_ref.
         define new shared variable rejected like mfc_logical no-undo.
         define new shared variable rmks like tr_rmks.
         define new shared variable ship_dt like so_ship_date.
         define new shared variable so_db like global_db.
         define new shared variable ship_db like global_db.
         define new shared variable yn    like mfc_logical.
         define new shared variable trlot like tr_lot.

         define new shared workfile work_abs_mstr like abs_mstr.

         /* SHARED VARIABLES, BUFFERS AND FRAMES */

         define new shared variable prog_name as character initial "rcsois.p" no-undo.
         define     shared variable transfer_mode like mfc_logical no-undo.
         define shared variable global_recid as recid.

         /* LOCAL VARIABLES, BUFFERS AND FRAMES */
         define variable abs_trans_mode as character.
         define variable abs_veh_ref as character.
         define variable disp_abs_id like abs_mstr.abs_id.
         define variable conf_type as logical format {&xxrcsotru_p_11}  initial true no-undo.
         define variable oldcurr like so_curr.
         define variable id_length as integer no-undo.
         define variable shipgrp        like sg_grp no-undo.
         define variable shipnbr        like abs_mstr.abs_id no-undo.
         define variable nrseq          like shc_ship_nr_id no-undo.
         define variable errorst        as logical no-undo.
         define variable errornum       as integer no-undo.
         define variable is_valid       as logical no-undo.
         define variable is_internal    as logical no-undo.

         define buffer abs_temp for abs_mstr.

         define variable change-queued   as   logical     no-undo.
/*J2MG*/ define variable l_flag          like mfc_logical no-undo.
/*L0CD*/ define variable undo_stat       like mfc_logical no-undo.

/*F701*/ define new shared variable site_from like pt_site no-undo.
/*F701*/ define new shared variable loc_from like pt_loc no-undo.
/*F701*/ define new shared variable lotser_from like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_from like ld_ref no-undo.
/*F701*/ define new shared variable status_from like ld_status no-undo.
/*F701*/ define new shared variable site_to like pt_site no-undo.
/*F701*/ define new shared variable loc_to like pt_loc initial "c001it" no-undo.
/*F701*/ define new shared variable lotser_to like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_to like ld_ref no-undo.
/*F701*/ define variable ld_recid as recid.
         define new shared variable lotserial_qty like tr_qty_chg no-undo.
/*F190*/ define variable undo-input like mfc_logical.
/*J1W2*/ define variable ld_recid_from as recid no-undo.
/*xx**/  define variable up_abs_id like abs_mstr.abs_id .

/**xxxx*begin */DEFINE  VAR mabsqty AS INT.
                define new shared variable lotserial like sr_lotser no-undo.
                define new shared variable nbr like tr_nbr no-undo.
                define new shared variable so_job like tr_so_job no-undo.
/*K04X*/        define variable v_shipnbr   like tr_ship_id      no-undo.
/*K04X*/        define variable v_shipdate  like tr_ship_date    no-undo.
/*K04X*/        define variable v_invmov    like tr_ship_inv_mov no-undo.
/*F003*/        define variable glcost like sct_cst_tot.
/*F190*/        define variable assay like tr_assay.
/*F190*/        define variable grade like tr_grade.
/*F190*/        define variable expire like tr_expire.
                define new shared variable transtype as character  format "x(7)" initial "ISS-TR".
/**xxxx*end */ DEFINE VAR MLD_DATE LIKE LD_DATE.
DEFINE VAR MLD_ASSAY LIKE LD_ASSAY.
DEFINE VAR MLD_EXPIRE LIKE LD_EXPIRE.
DEFINE VAR MLD_GRADE LIKE LD_GRADE.
/*DEFINE VAR ismodi AS LOGICAL.*/
DEFINE BUFFER LDDET FOR LD_DET.
    DEFINE VAR ISCONTINUE AS LOGICAL.
/*K04X*/ /* TEMP TABLES */
/*K04X*/ define temp-table t_trhist no-undo
/*K04X*/    field t_part      like global_part
/*K04X*/    field t_lotserial like tr_lot
/*K04X*/    field t_lotref    like tr_ref
/*K04X*/    field t_trqty     like tr_qty_chg
/*K04X*/    index t_part is primary
/*K04X*/       t_part
/*K04X*/       t_lotserial
/*K04X*/       t_lotref.

/*L0CD*/ /* Euro Tool Kit definitions */
/*L0CD*/ {etvar.i &new="new"}
/*L0CD*/ {etdcrvar.i "new"}
/*L0CD*/ {etrpvar.i &new="new"}
/*L0CD*/ {etsotrla.i "new"}

         {fsdeclr.i new}

         {gpglefdf.i}
         {txcalvar.i}

         if daybooks-in-use then
            {gprun.i ""nrm.p"" "persistent set h-nrm"}
/*GUI*/ if global-beam-me-up then undo, leave.
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*L03Q** /*K1JN*/    abs_mstr.abs_shipfrom colon 35 label "Ship-From" */
/*L03Q*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
     abs_mstr.abs_shipfrom colon 25 label {&xxrcsotru_p_2}
            si_desc               at 47 no-label
            conf_type             colon 25 label {&xxrcsotru_p_11}
            abs_mstr.abs_id       colon 25 label {&xxrcsotru_p_15}
            skip(0.5)
            abs_mstr.abs_shipto   colon 25 label {&xxrcsotru_p_1}
            ad_name               at 47 no-label
            ad_line1              at 47 no-label
            ship_dt    colon 25  eff_date  at 47
            loc_to     colon 25 label "客户在途库位"
          SKIP(0.5)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

 FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
with frame b width 132 attr-space NO-BOX THREE-D /*GUI*/.

         find first gl_ctrl no-lock no-error.
         {gprun.i ""socrshc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         find first shc_ctrl no-lock.

         {gprun.i ""rcpma.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         find abs_mstr where recid(abs_mstr) = global_recid no-lock no-error.

         if available abs_mstr and abs_type = "s"
         and (abs_id begins "p" or abs_id begins "s") then do:

            find si_mstr where si_site = abs_shipfrom no-lock.

            conf_type = abs_id begins "p".

            display
               abs_shipfrom
               si_desc
               conf_type
               substring(abs_id,2,50) @ abs_id
            with frame a.
         end.

         assign
            ship_dt  = today
            eff_date =
              if transfer_mode or not available abs_mstr
              then today
              else abs_eff_date
         oldcurr  = "".

         display
            ship_dt
            eff_date
            conf_type
         with frame a.

         mainloop:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

            run del-qad-wkfl.

            hide frame b .

            do with frame a:
               prompt-for abs_shipfrom conf_type abs_id editing:

                  global_site = input abs_shipfrom.

                  if frame-field = "abs_shipfrom" then do:

                     {mfnp05.i abs_mstr abs_id
                        "abs_id begins 's' or abs_id begins 'p'"
                         abs_shipfrom
                        "input abs_shipfrom"}

                     if recno <> ? then do:
                        find si_mstr where si_site = abs_shipfrom no-lock  no-error.

                        assign
                           global_site = abs_shipfrom
                           global_lot  = abs_id
                           conf_type   = abs_id begins "p"
                           disp_abs_id = substr(abs_id,2,50).

                        display
                           abs_shipfrom
                           si_desc  when (available si_mstr)
                           ""       when (not available si_mstr) @ si_desc
                           conf_type
                           disp_abs_id @ abs_id.
                     end. /* if recno <> ? */
                  end. /* if frame-field "abs_shipfrom" */
                  else if frame-field = "abs_id" then do:
                     /* HANDLE SHIPPERS */
                     if not input conf_type then do:

                        {mfnp05.i abs_mstr abs_id
                           "abs_shipfrom = input abs_shipfrom
                            and abs_id begins ""s"" and abs_type = ""s"""
                            abs_id " ""s"" + input abs_id"}

                     end. /* if not input conf_type */
                     else do:
                        {mfnp05.i abs_mstr abs_id
                           "abs_shipfrom = input abs_shipfrom and abs_id begins
                           ""p"" " abs_id " ""p"" + input abs_id"}
                     end. /* else */

                     if recno <> ? then do:
                        find si_mstr where si_site = abs_shipfrom no-lock
                           no-error.

                        assign
                           global_site = abs_shipfrom
                           global_lot  = abs_id
                           conf_type   = abs_id begins "p"
                           disp_abs_id = substr(abs_id,2,50).

                        display
                           abs_shipfrom
                           si_desc  when (available si_mstr)
                           ""       when (not available si_mstr) @ si_desc
                           conf_type
                           disp_abs_id @ abs_id.
                     end. /* if recno <> ? */
                  end. /* if frame-field = "abs_id" */
                  else do:
                     status input.
                     readkey.
                     apply lastkey.
                  end.
               end. /* prompt-for */
            end. /* do with frame a */

            so_db = global_db.

            find si_mstr where si_site = input abs_shipfrom no-lock no-error.
            if not available si_mstr then do:
/*L0CD*        {mfmsg.i 708 3}   /* Site doesn't exist */  *L0CD*/
/*L0CD*/       run ip_msg (input 708, input 3).   /* Site doesn't exist */
               next-prompt abs_shipfrom with frame a.
               undo, retry.
            end.
            display si_desc with frame a.

            /* Making sure db is connected */
            if si_db <> global_db and not connected(si_db) then do:
               {mfmsg03.i 2510 3 si_db """" """"}  /*db # not connected*/
               next-prompt abs_shipfrom with frame a.
               undo, retry.
            end.

/*L0CD*/    assign
               ship_db   = si_db
               change_db = ship_db <> global_db.
ISCONTINUE = YES .         
FOR EACH ABS_mstr WHERE substr(ABS_mstr.ABS_par_id,2,50) = INPUT ABS_ID NO-LOCK:
              FIND FIRST LD_DET WHERE LD_DET.LD_PART = ABS_MSTR.ABS_ITEM AND LD_DET.LD_SITE = ABS_MSTR.ABS_SITE AND LD_DET.LD_LOC = ABS_MSTR.ABS_LOC AND LD_DET.LD_LOT = ABS_MSTR.ABS_LOTSER  NO-LOCK NO-ERROR.
               FIND FIRST LDDET WHERE LDDET.LD_PART = LD_DET.LD_PART AND LDDET.LD_SITE = ABS_MSTR.ABS_SITE AND LDDET.LD_LOC = '8888' AND LDDET.LD_LOT = LD_DET.LD_LOT  AND LDDET.LD_QTY_OH <> 0
                    AND (LDDET.LD_GRADE <> LD_DET.LD_GRADE OR LDDET.LD_ASSAY <> LD_DET.LD_ASSAY  OR LDDET.LD_EXPIRE <> LD_DET.LD_EXPIRE ) NO-LOCK NO-ERROR.
               IF AVAILABLE LDDET THEN ISCONTINUE = NO.

              END.
              IF NOT ISCONTINUE THEN DO:
               {mfmsg.i 1918 4}
                next-prompt abs_shipfrom with frame a.
               undo, retry.
                  END.
/*L0CD*/    find abs_mstr where
/*L0CD*/       abs_shipfrom = input abs_shipfrom and
/*L0CD*/       abs_id       =
/*L0CD*/          (if input conf_type then "p" else "s") + input abs_id and
/*L0CD*/       abs_type     = "s"
/*L0CD*/       no-lock no-error.

            if not available abs_mstr then do:
/*L0CD*        bell.             *L0CD*/
/*L0CD*/       run ip_msg (input 8145, input 3).
               next-prompt abs_id with frame a.
               undo, retry.
            end.

            {gprun.i ""gpsiver.p""
               "(input (input abs_shipfrom), input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if return_int = 0 then do:
/*L0CD*        {mfmsg.i 725 3}  /* User does not have access to site */  *L0CD*/
/*L0CD*/       run ip_msg (input 725, input 3).  /* User does not have access to site */
               undo, retry.
            end.

/*L0CD*/    /* Changed "authorized" to "l_flag" below */
            {gprun.i ""gpsimver.p"" "(input abs_shipfrom,
                                      input abs_inv_mov,
                                      output l_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if not l_flag then do:
/*L0CD*        {mfmsg.i 5990 4}  *L0CD*/
/*L0CD*/       run ip_msg (input 5990, input 4).
               /* USER DOES NOT HAVE ACCESS TO THIS SITE/INVENTORY MOVEMENT CODE */
               undo, retry.
            end.

            if abs_canceled then do:
/*L0CD*        {mfmsg.i 5885 3}  *L0CD*/
/*L0CD*/       run ip_msg (input 5885, input 3).
               /* SHIPPER CANCELED */
               undo, retry.
            end.

/**Checkinh the transfer flag : abs__chr01 = "1" ***/
            if abs__chr01 <> "" then do:
               message "Error: The shipper has been transfered ". 
               /* SHIPPER HAD TRANSFERED */
               undo, retry.
            end.


/*L0CD*/    if (substr(abs_status,2,1) = "y") = transfer_mode then do:
/*L0CD*/       run ip_msg (input (if transfer_mode then 8146 else 8140), input 3).
/*L0CD*/       /* 8146 - Shipper previously confirmed */
/*L0CD*/       /* 8140 - Shipper previously not confirmed */
/*L0CD*/       undo, retry.
/*L0CD*/    end.

            if abs_inv_mov ne "" and
               not can-find
                  (first im_mstr where
                     im_inv_mov eq abs_inv_mov and
                     im_tr_type eq "ISS-SO")
               then do:
/*L0CD*        {mfmsg.i 5802 3} /* Not a sales order shipper */  *L0CD*/
/*L0CD*/       run ip_msg (input 5802, input 3).
               undo, retry.
            end.  /* if abs_inv_mov */

            if not transfer_mode then do:
               yn = no.
               {mfmsg01.i 5987 1 yn}
               /* Continue with Unconfirm ? */
               if not yn then undo mainloop, retry mainloop.
               assign
                  eff_date = abs_eff_date
                  ship_dt  = abs_shp_date.
               display eff_date ship_dt with frame a.
            end.

            /* Get length of shipper# */
            if abs_id begins "p" then do:
               {gprun.i ""gpgetgrp.p""
                  "(input  abs_shipfrom,
                    input  abs_shipto,
                    output shipgrp)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               nrseq = shc_ship_nr_id.
               if shipgrp <> ? then do:
                  find sgid_det where
                       sgid_grp = shipgrp and
                       sgid_inv_mov = abs_inv_mov no-lock no-error.
                  if available sgid_det then nrseq = sgid_ship_nr_id.
               end. /* if shipgrp <> ? */

               run get_nr_length (input nrseq, output id_length,
                                   output errorst,  output errornum).
               if errorst then do:
/*L0CD*           {mfmsg.i errornum 3}  *L0CD*/
/*L0CD*/          run ip_msg (input errornum, input 3).
                  undo, retry .
               end.

            end. /* if abs_id begins "p" */
            else
               id_length = length(substring(abs_id,2)).

            /* Since invoice# can be 8 char or less, we cannot process this
               preshipper to create a combined shipper-invoice*/
            if abs_id begins "p" and
               can-find (first df_mstr where
                  df_format = abs_format and
                  df_type   = "1"        and
                  df_inv)                and
               id_length > 8 then do:
/*L0CD*/       run ip_msg (input 5887, input 4).
               /* INVALID DOCUMENT FORMAT, CANNOT ASSIGN SHIPPER NUMBER */
               undo, retry.
            end. /* if abs_id begins "p" */

/*L0CD*/    if transfer_mode and substring(abs_status,1,1) <> "y" then
/*L0CD*/       run ip_msg (input 8147, input 2).

            abs_recid = recid(abs_mstr).

            for each work_abs_mstr exclusive-lock:
               delete work_abs_mstr.
            end.

            /* EXPLODE SHIPPER TO GET ORDER DETAIL */
            {gprun.i ""xxrcsotra.p"" "(input recid(abs_mstr))"}
/*GUI*/ if global-beam-me-up then undo, leave.

            /* USE THE qad_wkfl TO KEEP TRACK OF THE SALES ORDERS BEING     */
            /* TRANSFERED SO THAT SHIPPERS RELATED TO THE SAME ORDER ARE NOT */
            /* SIMULTANEOUSLY CONFIRMED.                                    */

            do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

               for each work_abs_mstr no-lock where work_abs_mstr.abs_order <> "":

                  find qad_wkfl no-lock where
                     qad_key1 = "xxrcsotr.p" and
                     qad_key2 = work_abs_mstr.abs_order no-error.

                  if available qad_wkfl and
                     qad_key4 <> mfguser
                  then do:
                     /* SALES ORDER # IS BEING CONFIRMED BY USER # */
                     {mfmsg03.i 2262 3 qad_key2 qad_charfld[1] """"}
                     undo mainloop, retry mainloop.
                  end.  /* IF AVAILABLE qad_wkfl */
                  else if not available qad_wkfl then do:
                     create qad_wkfl.
                     assign
                        qad_key1       = "xxrcsotr.p"
                        qad_key2       = work_abs_mstr.abs_order
                        qad_key3       = "xxrcsotr.p"
                        qad_key4       = mfguser
                        qad_charfld[1] = global_userid
                        qad_charfld[2] = work_abs_mstr.abs_par_id
                        qad_charfld[3] = work_abs_mstr.abs_shipfrom
                        qad_date[1]    = today
                        qad_charfld[5] = string(time, "hh:mm:ss").
                     if recid(qad_wkfl) = -1 then .
                  end.  /* ELSE OF IF AVAILABLE qad_wkfl */

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* FOR EACH work_abs_mstr */
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* DO TRANSACTION */

            for each work_abs_mstr exclusive-lock:
                work_abs_mstr.abs_ship_qty = 0.
            end.

            assign
               abs_shipvia    = substring(abs__qad01,1,20)
               abs_fob        = substring(abs__qad01,21,20)
               abs_carr_ref   = substring(abs__qad01,41,20)
               abs_trans_mode = substring(abs__qad01,61,20)
               abs_veh_ref    = substring(abs__qad01,81,20).

            find first scx_ref where
               scx_type     = 1            and
               scx_shipfrom = abs_shipfrom and
               scx_shipto   = abs_shipto
               no-lock no-error.

            find ad_mstr where ad_addr = abs_shipto no-lock.
            display si_desc abs_shipto ad_name ad_line1 with frame a.

            if transfer_mode then DO:
               
                
                FIND loc_mstr WHERE loc_loc = '8888' NO-LOCK.
             IF AVAILABLE loc_mstr THEN  loc_to = loc_loc.
       
      DISPLAY loc_to WITH FRAME a. 
              
      
      update
                  ship_dt
                  eff_date
                  /*loc_to */
               with frame a.
               END.
            run p_vtmstr_chk .

/*J2MG*/    /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY, */
/*J2MG*/    /* NOT PRIMARY ENTITY                               */

/*J2MG*/    /* THE PROCEDURE P_GLCALVAL, VERIFIES OPEN GL PERIOD FOR */
/*J2MG*/    /* SITE/ENTITY OF EACH LINE ITEM                         */

/*J2MG*/    run p_glcalval (output l_flag).
/*J2MG*/    if l_flag then do:
/*J2MG*/       next-prompt abs_mstr.abs_shipfrom with frame a.
/*J2MG*/       undo mainloop, retry mainloop.
/*J2MG*/    end.  /* IF L_FLAG */

/***Checking the location ***/
             find first si_mstr where si_site = input abs_shipfrom  no-lock no-error.
             if available si_mstr and not si_auto_loc then do:
                if not can-find (loc_mstr where loc_site = si_site
                 and loc_loc = loc_to ) then do:
                     {mfmsg.i 229 3} /*location master does not exist*/
                     undo, retry.
                 end.
             end.
/***********/
            
            /* Warn if there is any sales orders on the shipper that has
               its action status non-blank */
            for each work_abs_mstr no-lock
               where abs_order <> "" and abs_line <> ""
               break by abs_shipfrom by abs_dataset by abs_order
               on endkey undo mainloop, retry mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.

               if first-of (abs_order) then do:
                  find so_mstr where so_nbr = abs_order no-lock no-error.
                  if available so_mstr then do:
                     find cm_mstr where cm_addr = so_bill no-lock no-error.
                     if available cm_mstr and cm_cr_hold then do:
                        /* CUSTOMER ON CREDIT HOLD */
/*L0CD*                 {mfmsg.i 614 2}  *L0CD*/
/*L0CD*/                run ip_msg (input 614, input 2).
                        leave.
                     end. /* IF AVAILABLE CM_MSTR */
                     if so_stat <> "" then do:
/*L0CD*                 {mfmsg.i 623 2}  *L0CD*/
/*L0CD*/                run ip_msg (input 623, input 2).
                        /* SALES ORDER STATUS NOT BLANK */
                        leave.
                     end.
                  end. /* IF AVAILABLE SO_MSTR */
                  else if not available so_mstr then do:
/*L0CD*              {mfmsg.i 609 3}  *L0CD*/
/*L0CD*/             run ip_msg (input 609, input 3).
                     /* SALES ORDER DOES NOT EXIST  */
                     undo mainloop, retry mainloop.
                     leave.
                  end.
               end. /* if first-of  abs_order */
               if not
                  can-find(sod_det where
                     sod_nbr  = abs_order and
                     sod_line = integer(abs_line)) and
                  abs_qty <> abs_ship_qty then do:
                  {mfmsg.i 764 3}
/*L0CD*           {mfmsg.i 764 3}  *L0CD*/
/*L0CD*/          run ip_msg (input 764, input 3).
                  /* SALES ORDER LINE DOES NOT EXIST  */
                  undo mainloop, retry mainloop.
               end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* for each work_abs_mstr */

            /* CHECK FOR UNPEGGED SHIPPER LINES */
            {gprun.i ""rcsois4a.p"" "(input abs_recid,
                                      output yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            if yn then  undo mainloop, retry mainloop.

            /* VALIDATES THAT THERE IS ADEQUATE INVENTORY AVAILABLE TO SHIP ALL
               LINES WITH SAME SITE, LOC & PART IF OVER-ISSUE NOT ALLOWED */

            {gprun.i ""xxrcsotrg.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            if rejected then undo mainloop, retry mainloop.

            /* GO THRU WORKFILE FOR  VALIDATION,  UPDATE  STD  COSTS,  SET
            PRICES,  SET  INVOICING  FLAGS, UPDATE FREIGHT CHARGES, MANUAL
            UPDATE OF TRAILER CHARGES, AND ORDER  THE  SECRETARY  FLOWERS.
            */

            order_ct = 0.

            do transaction:

               clear frame b all.
               for each work_abs_mstr where abs_item <> "" with frame b down THREE-D  :
                   mabsqty = ABS_qty.
                   display abs_item format "x(16)" column-label "Item" 
                     mabsqty COLUMN-LABEL "Qty to ship" abs_site abs_loc 
                     abs_lot abs_order format "X(8)" .
                  down 1 .    
               end.
             
               yn = yes.
               {mfmsg01.i 12 1 yn}
               if not yn then undo mainloop, retry mainloop.  

               for each work_abs_mstr no-lock where abs_item <> "" , 
               each pt_mstr where pt_part = abs_item no-lock with frame b down :

                  lotserial_qty = abs_qty .
                global_part = pt_part .
                
                  assign
                     site_from   = abs_site
                     loc_from    = abs_loc
                     lotser_from = abs_lot
                     lotref_from = abs_ref.               

                  assign
                     site_to   = abs_site
                     lotser_to = abs_lot
                     lotref_to = abs_ref.

                  from-loop:
                  do on error undo:
/*GUI*/ if global-beam-me-up then undo, leave.
   
                     find si_mstr where si_site = site_from no-lock no-error.
                     find loc_mstr where loc_site = site_from and loc_loc = loc_from no-lock no-error.
                  
                     find first is_mstr where is_status = loc_status  no-lock no-error.
                     find first ld_det where ld_part = pt_part
                     and ld_det.ld_site = site_from
                     and ld_det.ld_loc = loc_from
                     and ld_det.ld_lot = lotser_from
                     and ld_det.ld_ref = lotref_from exclusive-lock no-error.
                 
                     if not available ld_det then do:
/*F0D2*/                   create ld_det.
/*G1D2*/                   assign
/*G1D2*/                     ld_det.ld_site = site_from
/*G1D2*/                     ld_det.ld_loc = loc_from
/*G1D2*/                     ld_det.ld_part = pt_part
/*G1D2*/                     ld_det.ld_lot = lotser_from
/*G1D2*/                     ld_det.ld_ref = lotref_from
/*G1D2*/                     ld_det.ld_status = loc_status
/*G1ZM*/                     status_from = loc_status.
                     end.
                  ASSIGN MLD_DATE = LD_DET.LD_DATE
                           MLD_ASSAY = LD_DET.LD_ASSAY
                          MLD_GRADE = LD_DET.LD_GRADE
                      MLD_EXPIRE = LD_DET.LD_EXPIRE.
/****************
/****xxx***/         else do: 
                       assign ld_qty_oh = ld_qty_oh - lotserial_qty.                     
                    end.
***************************/
                  
                    ld_recid_from = recid(ld_det).  

/*J038*          ADDED BLANKS FOR TRNBR and TRLINE       */
                     {gprun.i ""icedit.p"" "(""ISS-TR"",
                                         site_from,
                                         loc_from,
                                         pt_part,
                                         lotser_from,
                                         lotref_from,
                                         lotserial_qty,
                                         pt_um,
                                         """",
                                         """",
                                         output undo-input)"
                     }
/*GUI*/ if global-beam-me-up then undo, leave.
                  end. /**do-from***loop***/
              
/*FT37*/          if undo-input then undo, retry.

                  find first ld_det where ld_det.ld_part = pt_part
                    and ld_det.ld_site = site_to
                    and ld_det.ld_loc = loc_to
                    and ld_det.ld_lot = lotser_to
                    and ld_det.ld_ref = lotref_to exclusive-lock no-error.  
                                
                  find first loc_mstr where loc_site = abs_site and loc_loc = loc_to  no-lock no-error.

                  if not available ld_det then do:
                     create ld_det .
                     assign
                        ld_det.ld_part = pt_part
                        ld_det.ld_site = site_to
                        ld_det.ld_loc = loc_to
                        ld_det.ld_lot = lotser_to
                        ld_det.ld_ref = lotref_to
                        ld_det.ld_status = loc_status .
/****xxx**              ld_qty_oh = lotserial_qty .    **/
                  end.
/***xxx***        else ld_qty_oh = ld_qty_oh + lotserial_qty .     ***/

/*J038*        ADDED BLANKS FOR TRNBR and TRLINE       */
                 /* ismodi = YES. */
                  if ld_det.ld_qty_oh = 0 then do:
/*F701*/             assign
/*G319*/             ld_det.ld_date  = Mld_date
/*F701*/             ld_det.ld_assay = Mld_assay
/*F701*/             ld_det.ld_grade = Mld_grade
/*F701*/             ld_det.ld_expire = Mld_expire.
/*F701*/          end.
/*F701*/         /* else do:
/*F701*/             /*Assay, grade or expiration conflict. Xfer not allowed*/
/*F701*/             if ld_det.ld_grade  <> Mld_grade
/*F701*/             or ld_det.ld_expire <> Mld_expire
/*F701*/             or ld_det.ld_assay  <> Mld_assay then do:
/*F701*/                {mfmsg.i 1918 4}
/*F701*/               ismodi = NO.
/*F701*/             end.
           END.*/
                  
                  {gprun.i ""icedit.p"" "(""RCT-TR"",
                                       site_to,
                                       loc_to,
                                       pt_part,
                                       lotser_to,
                                       lotref_to,
                                       lotserial_qty,
                                       pt_um,
                                       """",
                                       """",
                                       output undo-input)"
                   }
/*GUI*/ if global-beam-me-up then undo, leave.

/****************************************************************/

/*K04X*/        assign  v_shipnbr  = ""
/*K04X*/                v_shipdate = ?
/*K04X*/                v_invmov   = "".
/*F003*/       lotserial = lotser_from.
                     {gprun.i ""xxicxfer.p"" "("""",
                                       lotserial,
                                       lotref_from,
                                       lotref_to,
                                       lotserial_qty,
                                       nbr,
                                       so_job,
                                       rmks,
                                       """",
                                       eff_date,
                                       site_from,
                                       loc_from, 
                                       site_to,
                                       loc_to,
                                       no,
                                       v_shipnbr,
                                       v_shipdate,
                                       v_invmov,
                                       output glcost,
                                       input-output assay,
                                       input-output grade,
                                       input-output expire)"
               }
/****************************************************************/

/*GUI*/ if global-beam-me-up then undo, leave.
            end.
            
             /**Update the transfer flag from company to customer location**/
               find first abs_mstr where recid(abs_mstr) = abs_recid exclusive-lock no-error.
               /*IF ismodi THEN */ ASSIGN  abs__chr01 = "1"
                     up_abs_id = abs_id .

               for each abs_mstr where abs_par_id = up_abs_id
               exclusive-lock :
                  /*IF ismodi THEN */ assign abs_loc = loc_to
                      .
              
                  /* FIND sod_det WHERE sod_nbr = ABS_order AND string(sod_line) = ABS_line  EXCLUSIVE-LOCK NO-ERROR.
                   sod_loc = loc_to.*/
                   
                   
                   end.  

             /**seek the abs_mstr ***/
               find first abs_mstr where recid(abs_mstr) = abs_recid exclusive-lock no-error.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
/* do transaction */

            global_recid = abs_recid.
            release sod_det.

         end.
         
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat */
         
         if daybooks-in-use then delete procedure h-nrm no-error.

         {gpnbrgen.i}
         {gpnrseq.i}
         
/*K1JN*/ procedure p-shipreq-update:

/*K1JN*/    /* THIS PROCEDURE TRANSFERS THE PEGGED SHIP LINE QUANTITY TO  */
/*K1JN*/    /* THE NEWLY CREATED SHIPPER                                  */

/*K1JN*/    define input parameter shipfrom like abs_shipfrom    no-undo.
/*K1JN*/    define input parameter absid    like abs_id          no-undo.
/*K1JN*/    define input parameter shipnbr  like abs_id no-undo.

/*K1JN*/    for each absr_det  where absr_shipfrom = shipfrom
/*K1JN*/                         and absr_ship_id  = absid  exclusive-lock :

/*K1JN*/       assign
/*M05Q*/          absr_id      = right-trim(substring(absr_id,1,1))
/*M05Q*/                       + shipnbr
/*M05Q*/                       + right-trim(substring
/*M05Q*/                         (absr_id,length(abs_mstr.abs_id) + 2))
/*K1JN*/          absr_ship_id = shipnbr.

/*K1JN*/    end.  /* FOR EACH ABSR_DET */
/*K1JN*/ end procedure.  /* P-SHIPREQ-UPDATE */


 procedure del-qad-wkfl:
    for each qad_wkfl exclusive-lock where
     qad_key3 = "xxrcsotr.p" and
     qad_key4 = mfguser:
       delete qad_wkfl.
    end.  /* FOR EACH qad_wkfl */
 end procedure.  /* del-qad-wkfl */

/*J2MG*/ PROCEDURE p_glcalval:

/*J2MG*/    define output parameter l_flag like mfc_logical no-undo.

/*J2MG*/    for each work_abs_mstr
/*J2MG*/       where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty and
/*J2MG*/             (work_abs_mstr.abs_id begins "i" or
/*J2MG*/              work_abs_mstr.abs_id begins "c") no-lock :

/*J2MG*/       for first si_mstr
/*J2MG*/          fields ( si_db si_desc si_entity si_site )
/*J2MG*/          where si_site = work_abs_mstr.abs_site no-lock:
/*J2MG*/       end. /* FOR FIRST SI_MSTR */

/*J2MG*/       if available si_mstr then do:
/*J2MG*/          /* CHECK GL EFFECTIVE DATE */
/*J2MG*/          {gpglef01.i ""IC"" si_entity eff_date}

/*J2MG*/          if gpglef > 0 then do:
/*J2MG*/             {mfmsg02.i gpglef 4 si_entity}
/*J2MG*/             l_flag = yes.
/*J2MG*/             return.
/*J2MG*/          end. /* IF GPGLEF > 0 */

/*J2MG*/          else
/*J2MG*/          do:
/*J2MG*/             /* CHECK GL EFFECTIVE DATE */
/*J2MG*/             {gpglef01.i ""SO"" si_entity eff_date}
/*J2MG*/             if gpglef > 0 then do:
/*J2MG*/                {mfmsg02.i gpglef 4 si_entity}
/*J2MG*/                l_flag = yes.
/*J2MG*/                return.
/*J2MG*/             end. /* IF GPGLEF > 0 */
/*J2MG*/          end. /* ELSE IF GPGLEF = 0 */

/*J2MG*/       end. /* IF AVAILABLE SI_MSTR */

/*J2MG*/    end. /* FOR EACH WORK_ABS_MSTR */

/*J2MG*/ END PROCEDURE.  /* p_glcalval */


/*H1LZ*/ procedure p_vtmstr_chk :
/*H1LZ*/    for first gl_ctrl
/*H1LZ*/        fields ( gl_base_curr gl_rnd_mthd gl_vat ) no-lock :
/*H1LZ*/    end. /* FOR FIRST */
/*H1LZ*/    if available gl_ctrl and gl_vat then do:
/*H1LZ*/       for each work_abs_mstr  where work_abs_mstr.abs_order <> ""
/*H1LZ*/                                 and work_abs_mstr.abs_line  <> ""
/*H1LZ*/                                 no-lock :
/*H1LZ*/          for first sod_det
/*H1LZ*/              fields ( sod_cum_qty sod_fsm_type sod_line sod_nbr
/*H1LZ*/                       sod_part sod_pr_list sod_qty_chg
/*H1LZ*/                       sod_sched sod_site sod_std_cost sod_taxc
/*H1LZ*/                       sod_um sod_um_conv )
/*H1LZ*/              where sod_nbr = abs_order
/*H1LZ*/                and sod_line = integer (abs_line) no-lock:
/*H1LZ*/          end. /* FOR FIRST */
/*H1LZ*/          if available sod_det and
/*H1LZ*/             not can-find ( first vt_mstr where
/*H1LZ*/                           ( vt_class = sod_taxc and
/*H1LZ*/                             ship_dt >= vt_start and
/*H1LZ*/                             ship_dt <= vt_end ) ) then do:
/*H1LZ*/             /* TAX CLASS DOES NOT EXIST */
/*L0CD* /*H1LZ*/     {mfmsg.i 2032 2}  *L0CD*/
/*L0CD*/             run ip_msg (input 2032, input 2).
/*H1LZ*/             leave.
/*H1LZ*/          end. /* IF AVAILABLE SOD_DET */
/*H1LZ*/       end.  /* FOR EACH WORK_ABS_MSTR */
/*H1LZ*/    end. /* IF AVAILABLE GL_CTRL */

/*H1LZ*/ end. /* PROCEDURE P_VTMSTR_CHK */


/*L0CD*/ procedure ip_msg:
/*L0CD*/    define input parameter i_num  as integer no-undo.
/*L0CD*/    define input parameter i_stat as integer no-undo.
/*L0CD*/    {mfmsg.i i_num i_stat}
/*L0CD*/ end procedure.  /* ip_msg */


/*L0CD*/ procedure ip_alias:

/*L0CD*/    define input  parameter i_db       like global_db no-undo.
/*L0CD*/    define output parameter o_err_flag as   logical   no-undo.
/*L0CD*/    define variable         v_err_num  as   integer   no-undo.

/*L0CD*/    {gprun.i ""gpalias3.p"" "(i_db, output v_err_num)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*L0CD*/    o_err_flag = v_err_num = 2 or v_err_num = 3.
/*L0CD*/    if o_err_flag then do:
/*L0CD*/       {mfmsg03.i 2510 4 "i_db" """" """"}  /* DB not connected */
/*L0CD*/    end.

/*L0CD*/ end procedure.  /* ip_alias */

