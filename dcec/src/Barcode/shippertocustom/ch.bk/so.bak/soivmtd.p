/* GUI CONVERTED from soivmtd.p (converter v1.75) Mon Oct 23 22:30:01 2000 */
/* soivmtd.p - INVOICE MAINTENANCE DELETE                               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*V8:RunMode=Character,Windows*/
/* REVISION: 4.0      LAST MODIFIED: 01/28/88   BY: pml                 */
/* REVISION: 6.0      LAST MODIFIED: 03/21/90   BY: ftb *D011*          */
/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: WUG *D002*          */
/* REVISION: 6.0      LAST MODIFIED: 07/16/90   BY: EMB *D040*          */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443*          */
/* REVISION: 6.0      LAST MODIFIED: 04/03/91   BY: WUG *D472*          */
/* REVISION: 6.0      LAST MODIFIED: 10/08/91   BY: SMM *D887*          */
/* REVISION: 7.0      LAST MODIFIED: 11/13/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 09/19/91   BY: afs *F040*          */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*          */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   BY: afs *F240*          */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: afs *F344*          */
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: afs *F398*          */
/* REVISION: 7.0      LAST MODIFIED: 05/12/92   BY: sas *F450*          */
/* REVISION: 7.0      LAST MODIFIED: 06/09/92   BY: tjs *F504*          */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: afs *F519*          */
/* REVISION: 7.0      LAST MODIFIED: 07/17/92   BY: tjs *F805*          */
/* REVISION: 7.0      LAST MODIFIED: 07/27/92   BY: tjs *F802*          */
/* REVISION: 7.0      LAST MODIFIED: 08/20/92   BY: afs *F862*          */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*          */
/* REVISION: 7.3      LAST MODIFIED: 02/10/93   BY: bcm *G416*          */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G457*          */
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: tjs *G948*          */
/* REVISION: 7.3      LAST MODIFIED: 04/20/93   BY: afs *G970*          */
/* REVISION: 7.4      LAST MODIFIED: 09/16/94   BY: dpm *H075*          */
/* REVISION: 7.4      LAST MODIFIED: 02/02/94   BY: afs *FL89*          */
/* REVISION: 7.4      LAST MODIFIED: 03/28/94   BY: WUG *GJ21*          */
/* REVISION: 7.4      LAST MODIFIED: 09/15/94   BY: dpm *FR43*          */
/* REVISION: 8.5      LAST MODIFIED: 12/04/94   BY: mwd *J034*          */
/* REVISION: 8.5      LAST MODIFIED: 02/28/95   BY: dpm *J044*          */
/* REVISION: 7.4      LAST MODIFIED: 11/01/94   BY: ame *GN90*          */
/* REVISION: 7.4      LAST MODIFIED: 02/24/95   BY: smp *F0H4*          */
/* REVISION: 8.5      LAST MODIFIED: 04/07/95   BY: dah *J042*          */
/* REVISION: 7.4      LAST MODIFIED: 06/14/95   BY: bcm *F0SR*          */
/* REVISION: 7.4      LAST MODIFIED: 08/30/95   BY: jym *G0VQ*          */
/* REVISION: 7.4      LAST MODIFIED: 09/15/95   BY: dxk *G0WP*          */
/* REVISION: 7.4      LAST MODIFIED: 09/20/95   BY: ais *G0XN*          */
/* REVISION: 7.4      LAST MODIFIED: 10/05/95   BY: ais *G0YK*          */
/* REVISION: 8.5      LAST MODIFIED: 10/19/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: wjk *J0DV*          */
/* REVISION: 8.5      LAST MODIFIED: 04/03/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.6      LAST MODIFIED: 09/13/96   BY: *K004* Kurt De Wit  */
/* REVISION: 8.6      LAST MODIFIED: 05/15/97   BY: *H0Z4* Suresh Nayak */
/* REVISION: 8.6      LAST MODIFIED: 06/30/97   BY: *K0FL* Taek-Soo Chang */
/* REVISION: 8.6      LAST MODIFIED: 07/09/97   BY: *H0ZJ* Samir Bavkar */
/* REVISION: 8.6      LAST MODIFIED: 10/06/97   BY: *K0KJ* Joe Gawel    */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil  */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Russ Witt    */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* Sandy Brown  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 08/10/99   BY: *J3K7* Surekha Joshi*/
/* REVISION: 9.0      LAST MODIFIED: 09/05/99   BY: *M0DV* Robert Jensen*/
/* REVISION: 9.0      LAST MODIFIED: 09/25/00   BY: *L121* Gurudev C    */

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
/*L024*   define shared variable exch_rate like exd_rate.*/
/*L024*/  define shared variable exch_rate like exr_rate.
/*L024* *L00Y* define shared variable exch_rate2 like exd_rate.*/
/*L024*/  define shared variable exch_rate2 like exr_rate2.
/*L00Y*/  define shared variable exch_ratetype like exr_ratetype.
/*L00Y*/  define shared variable exch_exru_seq like exru_seq.

          define new shared variable prev_consume like sod_consume.
          define new shared variable prev_site like sod_site.
          define new shared variable sod_recno as recid.
          define new shared variable sod_entity like en_entity.
          define new shared variable transtype as character.
          define new shared variable trgl_recno as recid.
          define new shared variable sct_recno as recid.
          define new shared variable sonbr like sod_nbr.
          define new shared variable soline like sod_line.
          define new shared variable prev_type like sod_type.
          define new shared variable delete_line like mfc_logical.
          define new shared variable ord-db-cmtype like cm_type no-undo.
          define new shared variable amd as character.
          define new shared variable location like sod_loc.
          define new shared variable lotser like sod_serial.
          define new shared variable lotrf like sr_ref.
          define new shared variable tr_recno as recid.

          define variable yn like mfc_logical initial yes.
          define variable i as integer.
          define variable trqty like tr_qty_chg.
          define variable qty_left like tr_qty_chg.
          define variable prev_abnormal like sod_abnormal.
          define variable week as integer.
          define variable site like sod_site.
          define variable gl_amt like glt_amt.
          define variable dr_acct like sod_acct.
          define variable dr_cc like sod_cc.
          define variable from_entity like en_entity.
          define variable icx_acct like sod_acct.
          define variable so_db like si_db.
          define variable err_flag as integer.
          define variable icx_cc like sod_cc.
          define variable prev_found like mfc_logical.
          define variable glcost like sct_cst_tot.
          define variable assay like tr_assay.
          define variable grade like tr_grade.
          define variable expire like tr_expire.
          define variable site_change as logical initial no.
          define variable pend_inv as logical initial yes.
          define variable tax_nbr like tx2d_nbr initial "".
          define variable tax_tr_type like tx2d_tr_type initial "13".
          define variable ec_ok as logical.
          /* DEFINE GL_TMP_AMT FOR MFIVTR.I */
          define variable gl_tmp_amt as decimal.

         define variable shipper_found as integer no-undo.
         define variable save_abs like abs_par_id no-undo.
/*L034*/ define variable mc-error-number like msg_nbr no-undo.
/*J3K7*/ define variable l_conf_ship as   integer     no-undo.
/*J3K7*/ define variable l_conf_shid like abs_par_id  no-undo.

          /* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
          {gpglefv.i}

          define new shared frame bi.
          define new shared stream bi.

          define buffer seoc_buf for seoc_ctrl.

         /* FORM DEFINITION FOR HIDDEN FRAME BI */
         {sobifrm.i}

          FORM /*GUI*/ 
             sod_det
          with frame bi width 80 THREE-D /*GUI*/.


/*L024*   /* FIND GL_CTRL FOR MFIVTR.I */       */
/*L024*   find first gl_ctrl no-lock no-error.  */

          find first soc_ctrl no-lock no-error.
          find so_mstr where recid(so_mstr) = so_recno.

          so_db = global_db.

          /*! MULTI-DB: USE SHIP-TO CUSTOMER TYPE FOR DEFAULT
              IF AVAILABLE ELSE USE BILL-TO TYPE USED TO
              FIND COGS ACCOUNT IN SOCOST02.p */
          {gprun.i ""gpcust.p"" "(input  so_nbr,
                                  output ord-db-cmtype)"}
/*GUI*/ if global-beam-me-up then undo, leave.


          for each sod_det where sod_nbr = so_nbr no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

             if sod_sched and
             (can-find(first sch_mstr where sch_type = 1
             and sch_nbr = sod_nbr and sch_line = sod_line) or
             can-find(first sch_mstr where sch_type = 2
             and sch_nbr = sod_nbr and sch_line = sod_line) or
             can-find(first sch_mstr where sch_type = 3
             and sch_nbr = sod_nbr and sch_line = sod_line)) then do:
                {mfmsg.i 6022 3} /* Schedule exists, delete not allowed */
                del-yn = no.
                return.
             end.

          /* DON'T ALLOW DELETE OF INVOICE IF ANY SHIPPER EXISTS */

/*J3K7*/     assign
/*J3K7*/        l_conf_ship   = 0
                shipper_found = 0.

/*J3K7*/     /* ADDED TWO OUTPUT PARAMETERS L_CONF_SHIP, L_CONF_SHID */
             {gprun.i ""rcsddelb.p"" "(input sod_nbr,
                                       input sod_line,
                                       input sod_site,
                                       output shipper_found,
                                       output save_abs,
                                       output l_conf_ship,
                                       output l_conf_shid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


             if shipper_found > 0 then do:
/*J3K7*/        save_abs = substring(save_abs,2,20).
         /* # SHIPPER/CONTAINERS EXISTS FOR OLDER, INCLUDING # */
                {mfmsg03.i 1118 4 shipper_found save_abs """"}
                del-yn = no.
                return.
             end. /* IF SHIPPER FOUND > 0 */

/*J3K7*/     /* IF ALL THE SHIPPERS FOR THE ORDER HAVE BEEN CONFIRMED      */
/*J3K7*/     /* & INVOICE POSTED DISPLAY WARNING AND ALLOW TO DELETE ORDER */

/*J3K7*/     else if l_conf_ship > 0 then
/*J3K7*/     do:
/*J3K7*/        l_conf_shid = substring(l_conf_shid,2,20).
/*J3K7*/        /* # CONFIRMED SHIPPERS EXIST FOR ORDER, INCLUDING # */
/*J3K7*/        {mfmsg03.i 3314 2 l_conf_ship l_conf_shid """"}

/*J3K7*/        /* PAUSING FOR USER TO SEE THE MESSAGE */
/*J3K7*/        if not batchrun then
/*J3K7*/           pause.
/*J3K7*/     end. /* IF L_CONF_SHIP > 0 */

             {gprun.i ""gpsiver.p""
               "(input sod_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

             if return_int = 0 then do:
                {mfmsg.i 2709 4} /* DELETE NOT ALLOWED; USER DOES NOT */
                                 /* HAVE ACCESS TO DETAIL SITE(S)     */
                del-yn = no.
                return.
             end.

             /* DO NOT ALLOW DELETE WHEN BTB ORDER IS INVOLVED. DELETE HAS */
             /* TO BE PERFORMED IN THE SALES ORDER MAINTENANCE.            */
             if sod_btb_type = "02" or sod_btb_type = "03" then do:
                {mfmsg.i 1021 3}
                /* DELETE NOT ALLOWED */
                del-yn = no.
                return.
             end.

           /* DO NOT ALLOW DELETION OF ORDER THAT HAS LINES WITH      */
           /* INVOICED QUANTITIES.                                    */
             if sod_qty_inv <> 0 then do:
             /* OUTSTANDING QUANTITY TO INVOICE, DELETE NOT ALLOWED */
             {mfmsg.i 604 3}
                 del-yn = no .
                 return.
             end. /*IF SOD_QTY_INV <> 0 */

          end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* FOR EACH SOD_DET */

          for each sod_det where sod_nbr = so_nbr
             and sod_type = ""
             and sod_confirm
             and sod_qty_inv > 0
             no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


             find pt_mstr where pt_part = sod_part no-lock no-error.

             if (available pt_mstr and pt_lot_ser = "S")
                and (sod_qty_ship - sod_qty_inv > 1
                or sod_qty_ship - sod_qty_inv < -1) then do:
                {mfmsg.i 658 4}  /* Serialized items must be       */
                del-yn = no.     /* returned through SO shipments  */
                return.
             end.
          end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH SOD_DET */

          /* DON'T ALLOW DELETE OF INVOICE IF ANY LINE ITEMS EXIST
           * FOR WHICH THE PERIOD IS CLOSED FOR SPECIFIED SITE */
          for each sod_det where sod_nbr = so_nbr no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

             /* VALIDATE GL PERIOD FOR SPECIFIED ENTITY/DATABASE */
             find si_mstr where si_site = sod_site no-lock.
             {gpglef4.i &module  = ""IC""
                        &from_db = so_db
                        &to_db   = si_db
                        &entity  = si_entity
                        &date    = so_ship_date}
             if gpglef_result > 0 then do:
                del-yn = no.
                return.
             end.
          end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* for each sod_det */

          line = 0.
          for each sod_det where sod_nbr = so_nbr:
/*GUI*/ if global-beam-me-up then undo, leave.


             find si_mstr where si_site = sod_site no-lock.
             sod_entity = si_entity.
             line = line + 1.

             assign
                prev_type = sod_type
                prev_due      = sod_due_date
                prev_qty_ord  = sod_qty_ord * sod_um_conv
                prev_abnormal = sod_abnormal
                prev_consume  = sod_consume
                prev_site     = sod_site.

             /* REVERSE TRANSACTION HISTORY RECORD AND UPDATE PART MASTER */
             sod_qty_chg = - sod_qty_inv.
             eff_date = so_ship_date.
             find pt_mstr where pt_part = sod_part no-lock no-error.
             if available pt_mstr then
                find pl_mstr where pl_prod_line = pt_prod_line no-lock.

             sod_recno = recid(sod_det).

             /* CREATE THE ISS-SO TR_HIST RECORDS */
             {gprun.i ""soivmtd1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


             assign

                /* Line below was causing overstatement of quantity in tr_hist */

                qty_all = -(sod_qty_all + sod_qty_pick) * sod_um_conv
                sod_qty_all  = 0
                sod_qty_pick = 0.

             if sod_confirm then do:

                /* REVERSE TRANSACTION HISTORY RECORD */
                {mfsotr.i "DELETE"}

                /* TO TAKE PREVIOUS SHIPMENTS INTO ACCOUNT          */
                /* FORECAST RECORD */
/*L121*/        for first si_mstr
/*L121*/           fields(si_cur_set si_db si_git_acct si_git_cc
/*L121*/                  si_gl_set si_site)
/*L121*/           where si_site = sod_site no-lock:
/*L121*/        end. /* FOR FIRST si_mstr */
/*L121*/        if available si_mstr
/*L121*/        then
/*L121*/           if si_db = so_db
/*L121*/           then do:
                      {mfsofc01.i
                          &part=sod_part
                          &site=sod_site
                          &date=sod_due_date
                          &quantity="- (sod_qty_ord -
                                  (sod_qty_ship - sod_qty_inv)) * sod_um_conv"
                          &consume=sod_consume
                          &type=sod_type}

                      {mfsofc02.i
                          &nbr=sod_nbr
                          &line=string(sod_line)
                          &consume=sod_consume}
/*L121*/           end. /* IF si_db = so_db THEN */
                {mfmrwdel.i "sod_det" sod_part sod_nbr string(sod_line) """"}

                /* UPDATE PART MASTER MRP FLAG */
                {inmrp.i &part=sod_part &site=sod_site}

                /* Delete line info that might exist in other databases */

                if si_db <> so_db then do:

                   {gprun.i ""gpalias3.p"" "(si_db, output err_flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.


                   assign
                      sonbr  = so_nbr
                      soline = sod_line .
/*L121**           {gprun.i ""solndel.p""} */

/*L121*/           /* ADDED INPUT PARAMETER yes TO EXECUTE MFSOFC01.I   */
/*L121*/           /* AND MFSOFC02.I WHEN CALLED FROM HEADER            */

/*L121*/           {gprun.i ""solndel.p""
                            "(input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                   /* Reset the db alias to the sales order database */
                   {gprun.i ""gpalias3.p"" "(so_db, output err_flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

                end. /* IF SI_DB <> SO_DB */

             end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF SOD_CONFIRM */

             /*DELETE LINE ITEM COMMENTS */
             for each cmt_det exclusive-lock where cmt_indx = sod_cmtindx:
                delete cmt_det.
             end.

/*M0DV*/     /*DELETE ALLOCATION DETAIL*/
/*M0DV*/     for each lad_det exclusive-lock where lad_dataset = "sod_det"
/*M0DV*/     and lad_nbr     = sod_nbr
/*M0DV*/     and lad_line    = string(sod_line):
/*M0DV*/        find ld_det where ld_site = lad_site
/*M0DV*/        and ld_loc  = lad_loc
/*M0DV*/        and ld_lot  = lad_lot
/*M0DV*/        and ld_ref  = lad_ref
/*M0DV*/        and ld_part = lad_part
/*M0DV*/        exclusive-lock no-error .
/*M0DV*/        ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).
/*M0DV*/        delete lad_det.
/*M0DV*/     end.

/*M0DV*/     /* DELETE KIT COMPONENT DETAIL ALLOCATIONS */
/*M0DV*/     {gprun.i ""soktdel1.p"" "(input recid(sod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.


             /* DELETE SALES ORDER BILL RECORDS */
             if can-find (first sob_det where sob_nbr = sod_nbr and
                          sob_line = sod_line) then do:
                delete_line = yes.
                {gprun.i ""sosomtk.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

             end.

             /* MRP WORKFILE */
             {mfmrwdel.i "sod_fas" sod_part sod_nbr string(sod_line) """"}

             /* Delete cost records */
             for each sct_det exclusive-lock where
                sct_part = sod_part and
                sct_sim  = string(sod_nbr) + "." + string(sod_line):
                delete sct_det.
             end.

             find qad_wkfl where
                qad_key1  = "sod_sv_code" and
                qad_key2  = sod_nbr + "+" + string(sod_line)
                no-error.
             if available qad_wkfl then
                delete qad_wkfl.

         /* ADDED FOLLOWING BLOCK */

             if sod_sched then do:
                find scx_ref where
                   scx_type = 1 and
                   scx_order = sod_nbr and
                   scx_line = sod_line
                   exclusive-lock.
                delete scx_ref.
             end.

/*M017*/    /* DELETE APM SALES ORDER DETAIL RELATIONSHIP RECORDS */
/*M017*/    {gprun.i ""sosoapm4.p"" "(input sod_nbr, input sod_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.


             delete sod_det.

          end. /* FOR EACH SOD_DET */

          {mfmsg02.i 24 1 line} /* Line item record(s) deleted */

          hide message.

          /* DELETE IMPORT EXPORT RECORDS */
          for each ied_det exclusive-lock where
            ied_type = "1" and ied_nbr = so_nbr  :
            delete ied_det.
          end.

          for each ie_mstr exclusive-lock where
            ie_type = "1" and ie_nbr = so_nbr  :
            delete ie_mstr.
          end.

          /*DELETE COMMENTS*/
          for each cmt_det exclusive-lock where cmt_indx = so_cmtindx:
             delete cmt_det.
          end.

          /* DELETE TAX DETAIL RECORDS FOR PENDING INVOICE TAX CALCS */
          if {txnew.i} then do:
             {gprun.i ""txdelete.p"" "(input tax_tr_type,
                                       input so_nbr,
                                       input tax_nbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


             /* DELETE TAX DETAIL RECORDS FOR SHIPMENT TAX CALCS **/
             tax_tr_type = "12".
             {gprun.i ""txdelete.p"" "(input tax_tr_type,
                                       input so_nbr,
                                       input tax_nbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


             /* DELETE TAX DETAIL RECORDS FOR SO MAINT TAX CALCS **/
             tax_tr_type = "11".
             {gprun.i ""txdelete.p"" "(input tax_tr_type,
                                       input so_nbr,
                                       input tax_nbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


             /* DELETE TAX DETAIL RECORDS CREATED AT INVOICE PRINT */
             tax_tr_type = "16".
             {gprun.i ""txdelete.p"" "(input tax_tr_type,
                                       input so_inv_nbr,
                                       input so_nbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.

          end.

          /* DELETE ANY AD_MSTR CREATED WITH TEMP SO_SHIP */
          if so_mstr.so_ship = "qadtemp" + mfguser       then do:
             find ad_mstr where ad_addr = so_mstr.so_ship exclusive-lock.
             delete ad_mstr.
          end.

         /* DELETE PRICE LIST HISTORY */
         {gprun.i ""gppihdel.p"" "(
                                   1,
                                   so_nbr,
                                   0
                                  )"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*L024*/  {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
             "(input so_exru_seq)"}

/*M017*/  /* DELETE APM SALES ORDER HEADER RELATIONSHIP RECORD */
/*M017*/  {gprun.i ""sosoapm3.p"" "(input so_nbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


          /* DELETE SALES ORDER MASTER RECORD */
          delete so_mstr.
