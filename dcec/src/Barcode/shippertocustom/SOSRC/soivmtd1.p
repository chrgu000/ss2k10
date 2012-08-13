/* GUI CONVERTED from soivmtd1.p (converter v1.71) Thu Apr 29 01:26:28 1999 */
/* soivmtd1.p - INVOICE MAINTENANCE DELETE                              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/*V8:RunMode=Character,Windows                                          */
/* REVISION: 7.4            CREATED: 09/11/95   BY: jym *G0VQ*          */
/* REVISION: 7.4      LAST MODIFIED: 09/11/95   BY: dxk *G0WP*          */
/* REVISION: 7.4      LAST MODIFIED: 09/25/95   BY: jym *G0Y0*          */
/* REVISION: 7.4            CREATED: 10/05/95   BY: ais *G0YK*          */
/* REVISION: 8.5      LAST MODIFIED: 03/13/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: ais *G1R4*          */
/* REVISION: 8.5      LAST MODIFIED: 04/15/97   BY: *H0X6* Jim Williams */
/* REVISION: 8.5      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil  */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Markus Barone*/
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L024* Sami Kureishy*/
/* REVISION: 8.6E     LAST MODIFIED: 04/21/99   BY: *F0Y0* Poonam Bahl  */

         {mfdeclre.i}

         define shared variable line like sod_line.
         define shared variable del-yn like mfc_logical.
         define shared variable qty_req like in_qty_req.
         define shared variable qty_all like in_qty_all.
         define shared variable prev_due like sod_due_date.
         define shared variable prev_qty_ord like sod_qty_ord.
         define shared variable trnbr like tr_trnbr.
         define shared variable qty as decimal.
         define shared variable part as character format "x(18)".
         define shared variable eff_date as date.
         define shared variable all_days like soc_all_days.
         define shared variable all_avail like soc_all_avl.
         define shared variable ln_fmt like soc_ln_fmt.
         define shared variable ref like glt_det.glt_ref.
         define shared variable so_recno as recid.
         define shared variable comp like ps_comp.
         define shared variable trlot like tr_lot.
         define shared variable cmtindx like cmt_indx.
         define variable yn like mfc_logical initial yes.
         define variable i as integer.
         define variable trqty like tr_qty_chg.
         define variable qty_left like tr_qty_chg.
         define variable prev_abnormal like sod_abnormal.
         define shared  variable prev_consume like sod_consume.
/*L024*  define shared variable exch_rate like exd_rate. */
/*L024*/ define shared variable exch_rate like exr_rate.
/*L024* /*L00Y*/ define shared variable exch_rate2 like exd_rate. */
/*L024*/ define shared variable exch_rate2 like exr_rate2.
/*L00Y*/ define shared variable exch_ratetype like exr_ratetype.
/*L00Y*/ define shared variable exch_exru_seq like exru_seq.
         define shared  variable prev_site like sod_site.
         define variable week as integer.
         define variable site like sod_site.
         define variable location like sod_loc.
         define variable lotser like sod_serial.
         define variable lotrf  like ld_ref.
         define shared variable sod_recno as recid.
         define shared variable sod_entity like en_entity.
         define variable gl_amt like glt_amt.
         define variable dr_acct like sod_acct.
         define variable dr_cc like sod_cc.
         define variable from_entity like en_entity.
         define variable icx_acct like sod_acct.
         define variable icx_cc like sod_cc.
         define shared variable transtype as character.
         define variable prev_found like mfc_logical.
         define shared variable trgl_recno as recid.
         define shared variable sct_recno as recid.
         define variable so_db like si_db.
         define variable err_flag as integer.
         define shared variable sonbr like sod_nbr.
         define shared variable soline like sod_line.
         define variable glcost like sct_cst_tot.
         define variable assay like tr_assay.
         define variable grade like tr_grade.
         define variable expire like tr_expire.
         define variable site_change as logical initial no.
         define variable pend_inv as logical initial yes.
         define shared variable prev_type like sod_type.
         define shared variable delete_line like mfc_logical.
         define variable tax_nbr like tx2d_nbr initial "".
         define variable tax_tr_type like tx2d_tr_type initial "13".
         define variable ec_ok as logical.
         define shared variable tr_recno as recid .
         define            variable ieline      as integer no-undo.
         define            variable ietype      as character no-undo.
         define shared variable ord-db-cmtype like cm_type no-undo.
         define            variable trqty_alloc like tr_qty_chg no-undo.
         define            variable noentries as integer no-undo.
         define            variable save_site like sod_site no-undo.
         define            variable save_loc like sod_loc no-undo.
         define            variable save_lot like sod_lot no-undo.
         define            variable save_ref like sod_ref no-undo.
         define            variable save_qtyship like sod_qty_ship no-undo.
         define            variable save_qtyinv like sod_qty_inv no-undo.
         define            variable save_qtychg like sod_qty_chg no-undo.
         define            variable save_um like sod_um no-undo.
         define            variable save_um_conv like sod_um_conv no-undo.
         define            variable save_price like sod_price no-undo.
         define            variable gl_tmp_amt as decimal.
/*L034*/ define            variable mc-error-number like msg_nbr no-undo.
/*L034*/ define            variable base-price      like tr_price no-undo.
/*F0Y0*/ define            variable l_lotedited     like mfc_logical no-undo.

         define            buffer   soddet     for sod_det.

         define            workfile wf-tr-hist
            field trsite like tr_site
            field trloc like tr_loc
            field trlotserial like tr_serial
            field trref like tr_ref
            field trqtychg like tr_qty_chg
            field trum like tr_um
            field trprice like tr_price.

         define shared frame bi.
         define shared stream bi.

         /* FORM DEFINITION FOR HIDDEN FRAME BI */
         {sobifrm.i}

         FORM /*GUI*/ 
            sod_det
         with  frame bi THREE-D /*GUI*/.


         find first gl_ctrl no-lock.
         find first soc_ctrl no-lock no-error.
         find so_mstr where recid(so_mstr) = so_recno.
         find sod_det where recid(sod_det) = sod_recno.

         find si_mstr where si_site = sod_site no-lock.

     /* Only create ISS-SO records in current DB when inventory
        was issued originally from that DB.  ISS-SO records needed
        in remote DBs are created by the call to solndel.p below.
        That routine calls soivtr.p which includes mfivtr.i.  This
        include-file creates the ISS-SO tr_hist in the remote DB. */

         if si_db = global_db then do:

        /*TEST TO SEE IF THIS LINE HAS BEEN SHIPPED VIA MULTI-LOCATIONS
          IF MULTI-LOCATIONS WERE ENTERED, THEN USER CANNOT CHANGE THE
          SITE, LOCATION OR QUANTITY.
          WF-TR-HIST IS USED TO STORE THE QUANTITY SHIPPED AT EACH
          SITE/LOCATION/SERIAL-LOT/REFERENCE COMBINIATION               */

        assign noentries = 0.

        for each wf-tr-hist exclusive-lock:
          delete wf-tr-hist.
        end.

       /* IF NOENTRIES = 0, THEN NO TR_HIST ISS-SO RECORDS EXISTS
          IF NOENTRIES = 1, THEN NO MULTI ALLOCATIONS HAVE BEEN MADE
          IF NOENTRIES > 1, THEN MULTI ALLOCATIONS HAVE BEEN MADE
          TRTOTQTY = TOTAL AMOUNT SHIPPED */

        entries-loop:
        for each tr_hist where tr_nbr = so_nbr
          and tr_line = sod_line
          and tr_type = "iss-so"
          and tr_part = sod_part
              and tr_rmks = ""
          no-lock
          break by tr_site
            by tr_loc
            by tr_serial
            by tr_ref
                    by tr_trnbr:
/*GUI*/ if global-beam-me-up then undo, leave.

          if first-of(tr_ref) then
        trqty_alloc = 0.

                trqty_alloc = trqty_alloc + tr_qty_loc.
        if last-of(tr_ref) then do:
          if trqty_alloc <> 0 then do:
            assign
              noentries = noentries + 1.

            create wf-tr-hist.
            assign
               wf-tr-hist.trsite = tr_site
               wf-tr-hist.trloc = tr_loc
               wf-tr-hist.trlotserial = tr_serial
               wf-tr-hist.trref = tr_ref
               wf-tr-hist.trqtychg = trqty_alloc
               wf-tr-hist.trum = tr_um.
/*L024*     wf-tr-hist.trprice = tr_price * tr_ex_rate. */
/*L024*/    {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input base_curr,
                          input tr_curr,
                          input tr_ex_rate2,
                          input tr_ex_rate,
                          input tr_price,
                          input false,
                          output wf-tr-hist.trprice,
                          output mc-error-number)"}
/*L024*/    if mc-error-number <> 0 then do:
/*L024*/       {mfmsg.i mc-error-number 2}
/*L024*/    end.

          end. /* trqty_alloc <> 0 */
        end.
        end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* for each tr_hist */

        assign
                save_um = sod_um
                save_um_conv = sod_um_conv
                save_price = sod_price
        save_site = sod_site
        save_loc = sod_loc
        save_ref = sod_ref
        save_lot = sod_lot
        save_qtychg = sod_qty_chg
        save_qtyinv = sod_qty_inv
        save_qtyship = sod_qty_ship.

        for each wf-tr-hist:
/*GUI*/ if global-beam-me-up then undo, leave.


          assign
                sod_um = wf-tr-hist.trum
                sod_um_conv = 1
                sod_price = wf-tr-hist.trprice
        location = wf-tr-hist.trloc
        lotser = wf-tr-hist.trlotserial
        lotrf = wf-tr-hist.trref
        sod_site = wf-tr-hist.trsite
        sod_loc = wf-tr-hist.trloc
        sod_lot = wf-tr-hist.trlotserial
        sod_qty_chg = trqtychg
        sod_qty_inv = -1 * wf-tr-hist.trqtychg
        sod_qty_ship = -1 * wf-tr-hist.trqtychg.

                {mfivtr.i " " """no in_qty_req update"""}

        end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* for each wf-tr-hist */

        assign
                sod_um = save_um
                sod_um_conv = save_um_conv
                sod_price = save_price
        sod_site = save_site
        sod_loc = save_loc
        sod_ref = save_ref
        sod_lot = save_lot
        sod_qty_chg = save_qtychg
        sod_qty_inv = save_qtyinv
        sod_qty_ship = save_qtyship.

         end.

         else do:

        /* When Multi-DBs involved with deletion, save sod_det into
           the shared frame bi using the null stream.  This shared
           frame will be used in soivtr.p which is called by solndel.p.
           Note that sod_qty_chg has been set above to -sod_qty_inv.
           This will be used by mfivtr.i when creating the ISS-SO entry. */

            {mfoutnul.i &stream_name = "bi"}
            display stream bi sod_det with frame bi.
            output stream bi close.
         end.
