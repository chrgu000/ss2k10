/* GUI CONVERTED from iclotrb.p (converter v1.71) Wed Nov 18 22:15:47 1998 */
/* iclotrb.p - LOCATION TRANSFER UN ISSUE / UN RECEIPT                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*V8:ConvertMode=Maintenance                                                  */
/*V8:WebEnabled=No                                                            */
/* REVISION: 8.6E            CREATED: 11/16/98   BY: *J327* Viswanathan M     */

         /* THIS FILE IS CLONED FROM ICLOTR.P. ANY CHANGES TO THIS SHOULD BE  */
         /* APPLIED TO ICLOTR.P AND VICE VERSA.                               */

         /* DISPLAY TITLE */
         {mfdtitle.i "f+ "}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE iclotrb_p_1 "订单"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE iclotrb_p_2 "转移备料库存"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE iclotrb_p_3 "库存状态冲突 (至/自)"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE iclotrb_p_4 "新的状态"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE iclotrb_p_5 "对于新的库位使用缺省状态"
         /* MaxLen: Comment: */


         /* ********** End Translatable Strings Definitions ********** */

         define new shared variable lotserial       like sr_lotser      no-undo.
         define new shared variable lotserial_qty   like sr_qty         no-undo.
         define new shared variable nbr             like tr_nbr
                                              label {&iclotrb_p_1}      no-undo.
         define new shared variable so_job              like tr_so_job  no-undo.
         define new shared variable rmks                like tr_rmks    no-undo.
         define new shared variable from_nettable       like mfc_logical.
         define new shared variable to_nettable         like mfc_logical.
         define new shared variable old_mrpflag         like pt_mrp.
         define new shared variable eff_date            like tr_effdate.
         define new shared variable intermediate_acct   like trgl_dr_acct.
         define new shared variable intermediate_cc     like trgl_dr_cc.
         define new shared variable from_expire         like ld_expire.
         define new shared variable from_date           like ld_date.
         define new shared variable site_from           like pt_site    no-undo.
         define new shared variable loc_from            like pt_loc     no-undo.
         define new shared variable lotser_from         like sr_lotser  no-undo.
         define new shared variable lotref_from         like ld_ref     no-undo.
         define new shared variable status_from         like ld_status  no-undo.
         define new shared variable site_to             like pt_site    no-undo.
         define new shared variable loc_to              like pt_loc     no-undo.
         define new shared variable lotser_to           like sr_lotser  no-undo.
         define new shared variable lotref_to           like ld_ref     no-undo.

         define new shared variable transtype           as character
                format "x(7)" initial "ISS-TR".
         define new shared variable null_ch             as character initial "".

         define shared variable trtype                  as character.

         define variable glcost             like sct_cst_tot.
         define variable undo-input         like mfc_logical.
         define variable yn                 like mfc_logical.
         define variable assay              like tr_assay.
         define variable grade              like tr_grade.
         define variable expire             like tr_expire.
/*         define variable v_shipnbr          like tr_ship_id         no-undo.*/            /*kevin*/
/*         define variable v_shipdate         like tr_ship_date       no-undo.*/            /*kevin*/
/*         define variable v_invmov           like tr_ship_inv_mov    no-undo.*/            /*kevin*/
         define variable lot_control        like clc_lotlevel       no-undo.
         define variable lot_found          like mfc_logical        no-undo.

         define variable ld_recid           as recid.
         define variable v_abs_recid        as recid                no-undo.
         define variable ld_recid_from      as recid                no-undo.
         define variable errmsg             as integer              no-undo.
         define variable mesg_desc          as character            no-undo.
         define variable ve_recid           as recid                no-undo.

         define variable trans_all          as logical
                         initial Yes  label {&iclotrb_p_2}          no-undo.
         define variable stat_conflict      as logical format "To/From"
                         initial Yes  label {&iclotrb_p_3}          no-undo.
         define variable use_default        as logical
                         initial Yes  label {&iclotrb_p_5}          no-undo.

         define variable new_stat           like ld_status
                                      label {&iclotrb_p_4}          no-undo.

         define buffer lddet    for ld_det.
         define buffer lddet1   for ld_det.

         {gpglefdf.i}

         /* SHARED TEMP TABLES */
         {xxicshmtdf.i "new" }

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
pt_part          colon 22
            pt_desc1         colon 22
            pt_desc2         colon 51 no-label
            pt_um            colon 22
            skip(1)
            lotserial_qty    colon 22
            eff_date         colon 55
            nbr              colon 22
            so_job           colon 22
            rmks             colon 22
            skip(1)
            trans_all        colon 37
            stat_conflict    colon 68
            use_default      colon 37
            new_stat         colon 68
            skip(1)
            {t002.i}            to 27     {t001.i}         to 58
            site_from        colon 22     site_to          colon 55
            loc_from         colon 22     loc_to           colon 55
            lotser_from      colon 22     lotser_to        colon 55
            lotref_from      colon 22     lotref_to        colon 55
            status_from      colon 22     lddet.ld_status  colon 55
          SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME




         /* DISPLAY */
         transloop:
         repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


            {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


            clear frame a all no-pause.

            nbr           = "".
            so_job        = "".
            rmks          = "".
            lotserial_qty = 0.
            eff_date      = today.

            find pt_mstr where pt_part = global_part no-lock no-error.
            if available pt_mstr then
               display
                  pt_part
                  pt_desc1
                  pt_um
                  lotserial_qty.

            prompt-for pt_part
            with frame a no-validate editing:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}
               if recno <> ? then
                  display
                     pt_part
                     pt_desc1
                     pt_desc2
                     pt_um
                     pt_site @ site_from
                     pt_loc  @ loc_from
               with frame a.
            end. /* PROMPT-FOR PT_PART...EDITING */
            status input.

            find pt_mstr using pt_part no-lock no-error.
            if not available pt_mstr then
            do:
               {mfmsg.i 7179 3} /* ITEM DOES NOT EXIST */
               if batchrun = yes then
                  undo transloop, leave transloop.
               else
                  undo, retry.
            end. /* IF NOT AVAILABLE PT_MSTR */

            display
               pt_desc1
               pt_desc2
               pt_um
               pt_site @ site_from
               pt_loc @ loc_from
               lotserial_qty
               "" @ lotser_from
               "" @ lotref_from
            with frame a.

            old_mrpflag = pt_mrp.

            /* SET GLOBAL PART VARIABLE */
            global_part = pt_part.

            xferloop:
            repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


               toloop:
               do for lddet on error undo, retry with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


                  display eff_date with frame a.
                  set
                     lotserial_qty
                     eff_date
                     nbr
                     so_job
                     rmks
                  with frame a.
                  if lotserial_qty = 0 then
                  do:
                     {mfmsg.i 7100 3} /* QUANTITY IS ZERO */
                     if batchrun = yes then
                        undo transloop, leave transloop.
                     else
                        undo, retry.
                  end. /* IF LOTSERIAL_QTY = 0 */

                  warn-loop:
                  do on error undo, retry with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.

                     update
                        trans_all
                        stat_conflict
                        use_default
                        new_stat
                     with frame a.

                     if use_default = no then
                     do:
                        if not can-find (first is_mstr
                           where is_status = new_stat) then
                        do:
                           {mfmsg.i 361 3} /* INVENTORY STATUS DOES NOT EXIST */
                           next-prompt new_stat with frame a.
                           if batchrun = yes then
                              undo transloop, leave transloop.
                           else
                              undo, retry.
                        end. /* IF NOT CAN-FIND(... */
                     end. /* IF USE_DEFAULT = NO */
                     else
                     do:
                        new_stat = "".
                        display new_stat with frame a.
                     end. /* IF USE_DEFAULT = YES */
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* END OF warn-loop */

                  from-loop:
                  do on error undo:
/*GUI*/ if global-beam-me-up then undo, leave.


                     set
                        site_from
                        loc_from
                        lotser_from
                        lotref_from
                     with frame a editing:
                        assign
                           global_site = input site_from
                           global_loc  = input loc_from
                           global_lot  = input lotser_from.
                           readkey.
                           apply lastkey.
                     end. /* SET SITE_FROM...EDITING */

                     find si_mstr where si_site = site_from no-lock no-error.
                     if not available si_mstr then
                     do:
                        {mfmsg.i 708 3}  /* SITE DOES NOT EXIST */
                        next-prompt site_from with frame a.
                        if batchrun = yes then
                           undo transloop, leave transloop.
                        else
                           undo from-loop, retry from-loop.
                     end. /* IF NOT AVAILABLE SI_MSTR */

                     {gprun.i ""gpsiver.p""
                               "(input si_site,
                                 input recid(si_mstr),
                                 output return_int)"
                     }
/*GUI*/ if global-beam-me-up then undo, leave.


                     if return_int = 0 then
                     do:
                        /* USER DOES NOT HAVE ACCESS TO THIS SITE */
                        {mfmsg.i 725 3}
                        next-prompt site_from with frame a.
                        if batchrun = yes then
                           undo transloop, leave transloop.
                        else
                           undo from-loop, retry from-loop.
                     end. /* IF RETURN_INT = 0 */

                     /* OPEN PERIOD VALIDATION FOR THE ENTITY OF FROM SITE */
                     {gpglef02.i &module = ""IC""
                              &entity = si_entity
                              &date   = eff_date
                              &prompt = "site_from"
                              &frame  = "a"
                              &loop   = "from-loop"
                     }

                     assign
                        site_to   = pt_site
                        loc_to    = pt_loc
                        lotser_to = lotser_from
                        lotref_to = lotref_from.

                     find ld_det where ld_det.ld_part = pt_part
                                   and ld_det.ld_site = site_from
                                   and ld_det.ld_loc = loc_from
                                   and ld_det.ld_lot = lotser_from
                                   and ld_det.ld_ref = lotref_from
                     no-lock no-error.

                     if not available ld_det then
                     do:
                        find si_mstr where si_site = site_from no-lock no-error.
                        find loc_mstr where loc_site = site_from
                                        and loc_loc  = loc_from no-lock no-error.

                        if not available si_mstr then
                        do:
                           /* SITE DOES NOT EXIST */
                           {mfmsg.i 708 3}
                           if batchrun = yes then
                              undo transloop, leave transloop.
                           else
                              undo from-loop, retry from-loop.
                        end. /* IF NOT AVAILABLE SI_MSTR */
                        if not available loc_mstr then
                        do:
                           if not si_auto_loc then
                           do:
                              /* LOCATION/LOT/ITEM/SERIAL DOES NOT EXIST */
                              {mfmsg.i 305 3}
                              next-prompt loc_from.
                              if batchrun = yes then
                                 undo transloop, leave transloop.
                              else
                                 undo from-loop, retry from-loop.
                           end. /* IF NOT SI_AUTO_LOC */
                           else do:
                              find is_mstr where is_status = si_status
                              no-lock no-error.
                              if available is_mstr
                                 and is_overissue then
                              do:
                                 create loc_mstr.
                                    assign
                                       loc_site   = si_site
                                       loc_loc    = loc_from
                                       loc_date   = today
                                       loc_perm   = no
                                       loc_status = si_status.
                              end. /* IF AVAILABLE IS_MSTR AND... */
                              else do:
                                 /* QUANTITY AVAILABLE IN SITE LOC FOR LOT SERIAL */
                                 {mfmsg02.i 208 3 0}
                                 if batchrun = yes then
                                    undo transloop, leave transloop.
                                 else
                                    undo xferloop, retry xferloop.
                              end. /* ELSE DO */
                           end. /* ELSE DO */
                        end. /* IF NOT AVAILABLE LOC_MSTR */

                        find is_mstr where is_status = loc_status
                        no-lock no-error.
                        if available is_mstr
                           and is_overissue
                           and (pt_lot_ser =  "" ) then
                        do:
                           create ld_det.
                           assign
                              ld_det.ld_site   = site_from
                              ld_det.ld_loc    = loc_from
                              ld_det.ld_part   = pt_part
                              ld_det.ld_lot    = lotser_from
                              ld_det.ld_ref    = lotref_from
                              ld_det.ld_status = loc_status
                              status_from      = loc_status.
                        end. /* IF AVAILABLE IS_MSTR AND... */
                        else do:
                           /* LOCATION/LOT/ITEM/SERIAL DOES NOT EXIST */
                           {mfmsg.i 305 3}
                           if batchrun = yes then
                              undo transloop, leave transloop.
                           else
                              undo xferloop, retry xferloop.
                        end. /* ELSE DO */
                     end. /* IF NOT AVAILABLE LD_DET */

                     else if (ld_det.ld_qty_oh - lotserial_qty
                                               - ld_det.ld_qty_all) < 0
                                             and ld_det.ld_qty_all  > 0
                                             and ld_det.ld_qty_oh   > 0
                                             and lotserial_qty      > 0 then
                     do:
                        status_from = ld_det.ld_status.
                        display status_from with frame a.

                        if not trans_all then
                        do:
                           if batchrun = yes then
                              undo transloop, leave transloop.
                           else
                              undo, retry.
                        end. /* IF NOT TRANS_ALL */
                     end. /* ELSE IF (LD_DET.LD_QTY_OH -... */
                     else do:
                        status_from = ld_det.ld_status.
                     end. /* ELSE DO */
                     display status_from with frame a.

                     ld_recid_from = recid(ld_det).

                     /* ADDED BLANKS FOR TRNBR and TRLINE */
                     {gprun.i ""icedit.p""
                               "(""ISS-TR"",
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


                     if undo-input then
                     do:
                        if batchrun = yes then
                           undo transloop, leave transloop.
                        else
                           undo, retry.
                     end. /* IF UNDO-INPUT */

                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* from-loop */

                  send-loop:
                  do on error undo toloop, retry toloop:
/*GUI*/ if global-beam-me-up then undo, leave.


                     display
                        site_to
                        loc_to
                        lotser_to
                        lotref_to.

                     if trtype = "LOT/SER" then
                     do:
                        set
                           site_to
                           loc_to
                           lotser_to
                           lotref_to
                        with frame a editing:
                           global_site = input site_to.
                           global_loc  = input loc_to.
                           global_lot  = input lotser_to.
                           readkey.
                           apply lastkey.
                        end. /* SET SITE_TO...EDITING */
                     end. /* IF TRTYPE = "LOT/SER" */
                     else do:
                        set
                           site_to
                           loc_to
                        with frame a editing:
                           global_site = input site_to.
                           global_loc = input loc_to.
                           readkey.
                           apply lastkey.
                        end. /* SET SITE_TO...EDITING */
                     end. /* ELSE DO */

                     find si_mstr where si_site = site_to no-lock no-error.
                     if not available si_mstr then
                     do:
                       {mfmsg.i 708 3}  /* SITE DOES NOT EXIST */
                       next-prompt site_to with frame a.
                       if batchrun = yes then
                          undo transloop, leave transloop.
                       else
                          undo toloop, retry.
                     end. /* IF NOT AVAILABLE SI_MSTR */

                     {gprun.i ""gpsiver.p""
                               "(input site_to,
                                 input ?,
                                 output return_int)"
                     }
/*GUI*/ if global-beam-me-up then undo, leave.


                     if return_int = 0 then
                     do:
                        /* USER DOES NOT HAVE ACCESS TO THIS SITE */
                        {mfmsg.i 725 3}
                        next-prompt site_to with frame a.
                        if batchrun = yes then
                           undo transloop, leave transloop.
                        else
                           undo toloop, retry.
                     end. /* IF RETURN_INT = 0 */

                     /* OPEN PERIOD VALIDATION FOR THE ENTITY OF TO SITE */
                     {gpglef02.i &module = ""IC""
                                 &entity = si_entity
                                 &date   = eff_date
                                 &prompt = "site_to"
                                 &frame  = "a"
                                 &loop   = "toloop"
                     }

                     if (pt_lot_ser <> "")
                         and (lotser_from <> lotser_to) then
                     do:
                        /* PERFORM COMPLIANCE CHECK  */
                        {gprun.i ""gpltfnd1.p""
                                  "(pt_part,
                                    lotser_to,
                                    """",
                                    """",
                                    output lot_control,
                                    output lot_found,
                                    output errmsg)"
                        }
/*GUI*/ if global-beam-me-up then undo, leave.

                        if (lot_control > 0
                           and lot_found) then
                        do:
                           /* SERIAL NUMBER ALREADY EXISTS */
                           {mfmsg.i 7482 3}
                           next-prompt lotser_to.
                           if batchrun = yes then
                              undo transloop, leave transloop.
                           else
                              undo, retry.
                        end. /* IF (LOT_CONTROL > 0... */
                     end. /* IF (PT_LOT_SER <> "")... */

                     find lddet where lddet.ld_part = pt_part
                                  and lddet.ld_site = site_to
                                  and lddet.ld_loc  = loc_to
                                  and lddet.ld_lot  = lotser_to
                                  and lddet.ld_ref  = lotref_to
                     no-error.

                     ld_recid = ?.
                     if not available lddet then
                     do:
                        create lddet.
                        assign
                           lddet.ld_site = site_to
                           lddet.ld_loc  = loc_to
                           lddet.ld_part = pt_part
                           lddet.ld_lot  = lotser_to
                           lddet.ld_ref  = lotref_to.
                        find loc_mstr where loc_site = site_to
                                        and loc_loc  = loc_to no-lock no-error.
                        if available loc_mstr then
                        do:
                           lddet.ld_status = loc_status.
                        end. /* IF AVAILABLE LOC_MSTR */
                        else do:
                           find si_mstr where si_site = site_to no-lock no-error.
                           if available si_mstr then
                           do:
                              lddet.ld_status = si_status.
                           end. /* IF AVAILABLE SI_MSTR */
                        end. /* ELSE DO */
                        ld_recid = recid(lddet).
                     end. /* IF NOT AVAILABLE LDDET */
                     display lddet.ld_status with frame a.

                     /* ERROR CONDITIONS */
                     if ld_det.ld_site = lddet.ld_site
                        and ld_det.ld_loc  = lddet.ld_loc
                        and ld_det.ld_part = lddet.ld_part
                        and ld_det.ld_lot  = lddet.ld_lot
                        and ld_det.ld_ref  = lddet.ld_ref then
                     do:
                        {mfmsg.i 1919 3} /* DATA RESULTS IN NULL TRANSFER */
                        if batchrun = yes then
                           undo transloop, leave transloop.
                        else
                           undo, retry.
                     end. /* IF LD_DET.LD_SITE = LDDET.LD_SITE AND... */

                     if (pt_lot_ser = "S") then
                     do:
                        /* LDDET EXACTLY MATCHES THE USER'S 'TO' CRITERIA */
                        if lddet.ld_part       = pt_part
                           and lddet.ld_site   = site_to
                           and lddet.ld_loc    = loc_to
                           and lddet.ld_lot    = lotser_to
                           and lddet.ld_ref    = lotref_to
                           and lddet.ld_qty_oh > 0 then
                        do:
                           mesg_desc = lddet.ld_site + ', ' + lddet.ld_loc.
                           /* SERIAL EXISTS AT SITE, LOCATION */
                           {mfmsg02.i 79 2 mesg_desc }
                        end. /* IF LDDET.LD_PART = PT_PART AND... */
                        else do:
                           find first lddet1 where lddet1.ld_part   = pt_part
                                               and lddet1.ld_lot    = lotser_to
                                               and lddet1.ld_qty_oh > 0
                                               and recid(lddet1) <> ld_recid_from
                           no-lock no-error.
                           if available lddet1 then
                           do:
                              mesg_desc = lddet1.ld_site + ', ' + lddet1.ld_loc.
                              /* SERIAL EXISTS AT SITE, LOCATION */
                              {mfmsg02.i 79 2 mesg_desc }
                           end. /* IF AVAILABLE LDDET1 */
                        end. /* ELSE DO */
                     end. /* IF (PT_LOT_SER = "S") */

                     if lddet.ld_qty_oh = 0 then
                     do:
                        assign
                           lddet.ld_date   = ld_det.ld_date
                           lddet.ld_assay  = ld_det.ld_assay
                           lddet.ld_grade  = ld_det.ld_grade
                           lddet.ld_expire = ld_det.ld_expire.
                     end. /* IF LDDET.LD_QTY_OH = 0 */
                     else do:
                        /*ASSAY, GRADE OR EXPIRATION CONFLICT. XFER NOT ALLOWED*/
                        if lddet.ld_grade     <> ld_det.ld_grade
                           or lddet.ld_expire <> ld_det.ld_expire
                           or lddet.ld_assay  <> ld_det.ld_assay then
                        do:
                           {mfmsg.i 1918 4}
                           if batchrun = yes then
                              undo transloop, leave transloop.
                           else
                              undo, retry.
                        end. /* IF LDDET.LD_GRADE <> LD_DET.LD_GRADE */
                     end. /* ELSE DO */

                     if status_from <> lddet.ld_status then
                     do:
                        if lddet.ld_qty_oh = 0 then
                        do:

                           if use_default = no then
                           do:
                              if trtype = "LOT/SER" then
                              do:
                                 lddet.ld_status = new_stat.
                                 display lddet.ld_status with frame a.
                              end. /*LDDET.LD_QTY_OH = 0 AND TRTYPE = LOT/SER*/
                              else do:
                                 /* IF STAT_CONFLICT FLAG IS SET TO "FROM" */
                                 if not stat_conflict then
                                    lddet.ld_status = ld_det.ld_status.
                              end. /*LDDET.LD_QTY_OH = 0 AND TRTYPE <> LOT/SER*/
                           end. /* IF USE_DEFAULT = NO */

                        end. /* LD_QTY_OH = 0 */
                        else do:
                           /* IF STAT_CONFLICT FLAG IS SET TO "FROM" AND IF   */
                           /* QUANTITY ALREADY EXISTS IN TO-LOCATION WITH     */
                           /* DIFFERENT INV. STATUS THEN TRANSFER NOT ALLOWED.*/
                           if not stat_conflict then
                           do:
                              if batchrun = yes then
                                 undo transloop, leave transloop.
                              else
                                 undo, retry.
                           end. /* IF NOT STAT_CONFLICT */
                        end. /* LDDET.LD_QTY_OH <> 0 & LOT/SER */
                     end. /* LDDET.LD_STATUS <> LD_DET.LD_STATUS */

                     find is_mstr where is_status = lddet.ld_status no-lock.
                     if not is_overissue
                        and (lddet.ld_qty_oh + lotserial_qty) < 0 then
                     do:
                        /* TRANSFER WILL RESULT IN NEGATIVE QTY AT "TO" LOC */
                        {mfmsg.i 1920 3}
                        if batchrun = yes then
                           undo transloop, leave transloop.
                        else
                           undo, retry.
                     end. /* IF NOT IS_OVERISSUE AND... */

                     /* ADDED BLANKS FOR TRNBR and TRLINE */
                     {gprun.i ""icedit.p""
                               "(""RCT-TR"",
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


                     if undo-input
                        and batchrun = yes then
                        undo transloop, leave transloop.

                     if undo-input
                        and can-find(si_mstr where si_site = site_to)
                        and not can-find(loc_mstr where loc_site = site_to
                        and loc_loc = loc_to) then
                        next-prompt loc_to.

                     if undo-input then
                        undo, retry.

                     ve_recid = recid(ld_det).

                     release lddet.
                     release ld_det.

                     /* ADDED BLANKS FOR TRNBR and TRLINE. */
                     {gprun.i ""icedit.p""
                               "(""ISS-TR"",
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


                     if undo-input then
                     do:
                        if batchrun = yes then
                           undo transloop, leave transloop.
                        else
                           undo transloop, retry transloop.
                     end. /* IF UNDO-INPUT */
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* END OF send-loop */

                  hide message.

                  /* RESET GLOBAL PART VARIABLE IN CASE IT HAS BEEN CHANGED */
                  global_part = pt_part.
                  global_addr = "".

                  /* PASS BOTH LOTSER_FROM & LOTSER_TO IN PARAMETER LOTSERIAL */
                  lotserial = lotser_from.
                  if lotser_to = "" then
                     substring(lotserial,40,1) = "#".
                  else
                     substring(lotserial,19,18) = lotser_to.

                  yn = true.

                  if batchrun = No then
                  do:
                     {mfmsg01.i 12 1 yn} /* IS ALL INFORMATION CORRECT? */
                     if not yn then
                        undo transloop, retry transloop.
                  end. /* IF BATCHRUN = NO */

                  /* CLEAR SHIPPER LINE ITEM TEMP TABLE */
                  {gprun.i  ""icshmt1c.p"" }
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* ADD TO SHIPPER LINE ITEM TEMP TABLE */
                  {gprun.i ""icshmt1a.p""
                            "(pt_part,
                              lotser_from,
                              lotref_from,
                              site_from,
                              loc_from,
                              lotserial_qty,
                              pt_um,
                              1,
                              pt_net_wt * lotserial_qty,
                              pt_net_wt_um,
                              pt_size * lotserial_qty,
                              pt_size_um)"
                  }
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* CREATE SHIPPER */
                  {gprun.i ""icshmt.p""
                            "(site_from,
                              site_to,
                              ""ISS-TR"",
                              eff_date,
                              output v_abs_recid)"
                  }
/*GUI*/ if global-beam-me-up then undo, leave.


                  view frame a.

/*marked by kevin
                  /* GET ASSOCIATED SHIPPER */
                  find abs_mstr where recid(abs_mstr) = v_abs_recid
                  no-lock no-error.
                  if available abs_mstr then
                     assign
                        v_shipnbr  = substring(abs_id,2)
                        v_shipdate = abs_shp_date
                        v_invmov   = abs_inv_mov.
                  else
                     assign
                        v_shipnbr  = ""
                        v_shipdate = ?
                        v_invmov   = "".
end marked by kevin*/

                  {gprun.i ""icxfer.p""
                            "("""",
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
/*GUI*/ if global-beam-me-up then undo, leave.


               end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* END TRANSACTION toloop */

               /* DETERMINE IF SUPPLIER PERFORMANCE IS INSTALLED */
               if can-find (mfc_ctrl where
                  mfc_field = "enable_supplier_perf" and mfc_logical)
                  and can-find (_File where _File-name = "vef_ctrl") then
               do:
                  {gprunmo.i
                            &program=""iclotrve.p""
                            &module="ASP"
                            &param="""(input ve_recid)"""
                  }
               end. /* IF ENABLE SUPPLIER PERFORMANCE */

               do transaction:
                  if ld_recid <> ? then
                     find ld_det where ld_recid = recid(ld_det) no-error.

                  if available ld_det then
                  do:
                     find loc_mstr no-lock where loc_site = ld_det.ld_site
                                             and loc_loc  = ld_det.ld_loc.
                     if ld_det.ld_qty_oh = 0
                        and ld_det.ld_qty_all = 0
                        and not loc_perm
                        and not can-find(first tag_mstr
                                where tag_site   = ld_det.ld_site
                                  and tag_loc    = ld_det.ld_loc
                                  and tag_part   = ld_det.ld_part
                                  and tag_serial = ld_det.ld_lot
                                  and tag_ref    = ld_det.ld_ref) then
                        delete ld_det.
                  end. /* IF AVAILABLE LD_DET */
               end. /* END TRANSACTION */

               display global_part @ pt_part with frame a.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* END OF xferloop */
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* END OF transloop */
