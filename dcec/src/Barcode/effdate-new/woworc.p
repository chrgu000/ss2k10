/* GUI CONVERTED from woworc.p (converter v1.75) Thu Aug 17 22:53:47 2000 */
/* woworc.p - WORK ORDER RECEIPT W/ SERIAL NUMBERS                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*V8:RunMode=Character,Windows                                          */
/* REVISION: 1.0      LAST MODIFIED: 04/02/86   BY: pml                 */
/* REVISION: 1.0      LAST MODIFIED: 08/21/86   BY: emb                 */
/* REVISION: 1.0      LAST MODIFIED: 10/30/86   BY: emb *39*            */
/* REVISION: 2.1      LAST MODIFIED: 08/04/87   BY: wug *A94*           */
/* REVISION: 2.1      LAST MODIFIED: 11/04/87   BY: wug *A102*          */
/* REVISION: 4.0      LAST MODIFIED: 01/18/88   BY: wug *A151*          */
/* REVISION: 4.0      LAST MODIFIED: 02/04/88   BY: emb *A172*          */
/* REVISION: 4.0      LAST MODIFIED: 03/15/88   BY: rl  *A171*          */
/* REVISION: 4.0      LAST MODIFIED: 04/19/88   BY: emb *A206*          */
/* REVISION: 4.0      LAST MODIFIED: 05/03/88   BY: emb *A225*          */
/* REVISION: 4.0      LAST MODIFIED: 05/04/88   BY: flm *A222*          */
/* REVISION: 4.0      LAST MODIFIED: 05/24/88   BY: flm *A250*          */
/* REVISION: 4.0      LAST MODIFIED: 05/24/88   BY: flm *A252*          */
/* REVISION: 4.0      LAST MODIFIED: 08/25/88   BY: wug *A408*          */
/* REVISION: 4.0      LAST MODIFIED: 09/19/88   BY: wug *A441*          */
/* REVISION: 5.0      LAST MODIFIED: 03/24/89   BY: emb *B061*          */
/* REVISION: 4.0      LAST MODIFIED: 04/24/89   BY: emb *A719*          */
/* REVISION: 5.0      LAST MODIFIED: 06/15/89   BY: mlb *B130*          */
/* REVISION: 5.0      LAST MODIFIED: 06/22/89   BY: rl  *B157*          */
/* REVISION: 5.0      LAST MODIFIED: 06/23/89   BY: mlb *B159*          */
/* REVISION: 5.0      LAST MODIFIED: 07/06/89   BY: wug *B175*          */
/* REVISION: 5.0      LAST MODIFIED: 08/21/89   BY: emb *B237*          */
/* REVISION: 5.0      LAST MODIFIED: 09/21/89   BY: emb *B265*          */
/* REVISION: 5.0      LAST MODIFIED: 01/23/90   BY: mlb *B522*          */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002*          */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: wug *D002*          */
/* REVISION: 6.0      LAST MODIFIED: 06/27/90   BY: emb *D024*          */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: wug *D051*          */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: wug *D447*          */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: emb *D413*          */
/* REVISION: 6.0      LAST MODIFIED: 04/12/91   BY: ram *D524*          */
/* REVISION: 6.0      LAST MODIFIED: 04/24/91   BY: ram *D581*          */
/* REVISION: 6.0      LAST MODIFIED: 06/19/91   BY: ram *D717*          */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D741*          */
/* REVISION: 6.0      LAST MODIFIED: 08/29/91   BY: emb *D841*          */
/* REVISION: 6.0      LAST MODIFIED: 09/12/91   BY: wug *D858*          */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*          */
/* REVISION: 6.0      LAST MODIFIED: 11/08/91   BY: wug *D920*          */
/* REVISION: 6.0      LAST MODIFIED: 11/27/91   BY: ram *D954*          */
/* REVISION: 7.0      LAST MODIFIED: 01/28/92   BY: pma *F104*          */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*          */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: ram *F896*          */
/* REVISION: 7.3      LAST MODIFIED: 09/22/92   BY: ram *G079*          */
/* Revision: 7.3        Last edit: 09/27/93            BY: jcd *G247* */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: emb *G292*          */
/* REVISION: 7.3      LAST MODIFIED: 01/15/93   BY: emb *G558*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 02/03/93   BY: fwy *G630*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: emb *G871*          */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*          */
/* REVISION: 7.3      LAST MODIFIED: 12/20/93   BY: pxd *GH30*          */
/* REVISION: 7.3      LAST MODIFIED: 03/21/94   BY: pxd *FM90*          */
/* REVISION: 7.2      LAST MODIFIED: 04/12/94   BY: pma *FN34*          */
/* REVISION: 7.4      LAST MODIFIED: 09/12/94   BY: slm *GM61*          */
/* REVISION: 7.4      LAST MODIFIED: 09/22/94   BY: jpm *GM78*          */
/* REVISION: 7.4      LAST MODIFIED: 09/27/94   BY: emb *GM78*          */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   BY: taf *J035*          */
/* REVISION: 8.5      LAST MODIFIED: 10/25/94   BY: pma *J040*          */
/* REVISION: 7.4      LAST MODIFIED: 11/02/94   BY: ame *FT23*          */
/* REVISION: 8.5      LAST MODIFIED: 11/17/94   BY: taf *J038*          */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: ktn *J041*          */
/* REVISION: 7.4      LAST MODIFIED: 03/06/95   BY: jzs *G0FB*          */
/* REVISION: 8.5      LAST MODIFIED: 03/08/94   BY: dzs *J046*          */
/* REVISION: 8.5      LAST MODIFIED: 03/08/95   BY: pma *J046*          */
/* REVISION: 7.3      LAST MODIFIED: 06/26/95   BY: qzl *G0R0*          */
/* REVISION: 8.5      LAST MODIFIED: 10/20/95   BY: tjs *J08X*          */
/* REVISION: 8.5      LAST MODIFIED: 02/28/96   BY: sxb *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: jym *G1Q9*          */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*          */
/* REVISION: 8.5      LAST MODIFIED: 06/24/96   BY: rvw *G1XY*          */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: kxn *J0QX*          */
/* REVISION: 8.5      LAST MODIFIED: 07/27/96   BY: jxz *J12C*          */
/* REVISION: 8.6      LAST MODIFIED: 03/19/97   BY: *J1LF* Murli Shastri*/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 04/15/98   BY: *J2K7* Fred Yeadon  */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton */
/* REVISION: 9.0      LAST MODIFIED: 02/23/00   BY: *M0JN* Kirti Desai  */
/* REVISION: 9.0      LAST MODIFIED: 08/11/00   BY: *M0QJ* Rajesh Thomas*/

     {mfdtitle.i "0+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworc_p_1 "短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworc_p_2 "换算因子"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworc_p_3 "结算"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworc_p_4 "多记录"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworc_p_5 "总量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworc_p_6 "设置属性"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworc_p_7 "废品数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworc_p_8 "收货"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {gldydef.i new}
         {gldynrm.i new}

         define new shared variable gldetail like mfc_logical no-undo init no.
         define new shared variable gltrans like mfc_logical no-undo init no.
         define new shared variable nbr like wo_nbr.
         define new shared variable yn like mfc_logical.
         define new shared variable open_ref like wo_qty_ord label {&woworc_p_1}.
     define new shared variable rmks like tr_rmks.
     define NEW shared variable vendlot like tr_vend_lot.
     define new shared variable serial like tr_serial.
     define new shared variable ref like glt_ref.
         define new shared variable lot like ld_lot.
         define new shared variable i as integer.
     define new shared variable total_lotserial_qty like sr_qty.
         define new shared variable null_ch as character initial "".
         define new shared variable close_wo like mfc_logical label {&woworc_p_3}.
     define new shared variable comp like ps_comp.
     define new shared variable qty like wo_qty_ord.
     define new shared variable eff_date like glt_effdate.
     define new shared variable wo_recno as recid.
     define new shared variable leadtime like pt_mfg_lead.
     define new shared variable prev_status like wo_status.
     define new shared variable prev_release like wo_rel_date.
     define new shared variable prev_due like wo_due_date.
     define new shared variable prev_qty like wo_qty_ord.
     define new shared variable prev_site like wo_site.
     define new shared variable del-yn like mfc_logical.
     define new shared variable deliv like wod_deliver.
     define new shared variable any_issued like mfc_logical.
         define new shared variable any_feedbk like mfc_logical.
     define new shared variable conv like um_conv
        label {&woworc_p_2} no-undo.
         define new shared variable um like pt_um no-undo.
         define new shared variable tot_units like wo_qty_chg
     label {&woworc_p_5}.
         define new shared variable reject_um like pt_um no-undo.
     define new shared variable reject_conv like conv no-undo.
     define new shared variable pl_recno as recid.
                  define new shared variable fas_wo_rec like fac_wo_rec.
         define new shared variable reject_qty like wo_rjct_chg
        label {&woworc_p_7} no-undo.
     define new shared variable multi_entry like mfc_logical
        label {&woworc_p_4} no-undo.
     define new shared variable lotserial_control as character.
     define new shared variable site like sr_site no-undo.
     define new shared variable location like sr_loc no-undo.
     define new shared variable lotserial like sr_lotser no-undo.
     define new shared variable lotref like sr_ref format "x(8)" no-undo.
     define new shared variable lotserial_qty like sr_qty no-undo.
     define new shared variable cline as character.
     define new shared variable issue_or_receipt as character
     initial {&woworc_p_8}.
     define new shared variable trans_um like pt_um.
     define new shared variable trans_conv like sod_um_conv.
     define new shared variable transtype as character initial "RCT-WO".
         define new shared variable back_qty like sr_qty.
         define new shared variable undo_jp like mfc_logical.
         define new shared variable joint_type like wo_joint_type.
         define new shared variable sf_cr_acct like dpt_lbr_acct.
         define new shared variable sf_dr_acct like dpt_lbr_acct.
         define new shared variable sf_cr_cc like dpt_lbr_cc.
         define new shared variable sf_dr_cc like dpt_lbr_cc.
         define new shared variable sf_cr_proj like glt_project.
         define new shared variable sf_dr_proj like glt_project.
         define new shared variable sf_gl_amt like tr_gl_amt.
         define new shared variable sf_entity like en_entity.
         define new shared variable undo_all      like mfc_logical no-undo.
         define new shared variable critical-part like wod_part    no-undo.
/*M0JN*/ define new shared variable critical_flg  like mfc_logical no-undo.
         define new shared variable msg-counter as integer no-undo.
         define new shared variable undo_setd like mfc_logical no-undo.
         define new shared variable wo_recid as recid.
         define new shared variable tr_recno as recid.
         define new shared variable jp like mfc_logical.
         define new shared variable base like mfc_logical.
         define new shared variable base_id like wo_base_id.
         define new shared variable joint_qtys  like mfc_logical.
         define new shared variable joint_dates like mfc_logical.
         define new shared variable no_msg      like mfc_logical.
         define new shared variable err_msg as integer.
         define variable glcost like sct_cst_tot.
         define variable msgref like tr_msg.
         define variable wip_accum like wo_wip_tot.
         define variable glx_mthd like cs_method.
         define variable glx_set like cs_set.
         define variable cur_mthd like cs_method.
         define variable cur_set like cs_set.
         define variable alloc_mthd like acm_method.
         define new shared variable chg_attr like mfc_logical no-undo
     label {&woworc_p_6}.
         define variable gl_tmp_amt as decimal no-undo.
 DEFINE VAR xx_recno AS RECID.
         define new shared workfile alloc_wkfl no-undo
        field alloc_wonbr as character
        field alloc_recid as recid
        field alloc_numer as decimal
        field alloc_pct   as decimal.

         define new shared frame a.
         define buffer womstr for wo_mstr.

         /*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
         {gpatrdef.i "new shared"}

         if daybooks-in-use then
            {gprun.i ""nrm.p"" "persistent set h-nrm"}
/*GUI*/ if global-beam-me-up then undo, leave.


         find first gl_ctrl no-lock.

     do transaction:

        find mfc_ctrl exclusive-lock
        where mfc_field = "fas_wo_rec" no-error.
        if available mfc_ctrl then do:

           find first fac_ctrl exclusive-lock no-error.
           if available fac_ctrl then do:
          fac_wo_rec = mfc_logical.
          delete mfc_ctrl.
           end.
           release fac_ctrl.
        end.
            release mfc_ctrl.

        find first fac_ctrl no-lock no-error.
        if available fac_ctrl then fas_wo_rec = fac_wo_rec.

     end.

         /*FRAME A*/
         {mfworc.i }

     /* DISPLAY */
     mainloop:
     repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J2K7*/    transtype = "RCT-WO".

                hide all no-pause.
        if global-tool-bar and global-tool-bar-handle <> ? then
          view global-tool-bar-handle.      

        /* PROMPT FOR WO, INITIAL VALIDATION, SAVE prev VALUES */
            {gprun.i ""woworcf.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


            if undo_all then leave.
   xx_recno = wo_recno.

            find wo_mstr no-lock where recid(wo_mstr) = wo_recno.
            find pt_mstr no-lock where pt_part = wo_part no-error.

        lotserial_qty = 0.
        reject_qty = 0.
        um = "".
        reject_um = "".
        if available pt_mstr then do:
           um = pt_um.
           reject_um = pt_um.
        end.
        conv = 1.
        reject_conv = 1.

        lotserial_control = "".
        if available pt_mstr then lotserial_control = pt_lot_ser.

            do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

               for each sr_wkfl exclusive-lock where sr_userid = mfguser:
                  delete sr_wkfl.
/*M0QJ**       {gprun.i ""gplotwdl.p""} */
               end.
/*M0QJ*/       {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            undo_setd = no.
            {gprun.i ""woworcd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            if undo_setd then undo mainloop, retry mainloop.

            /* REGULAR PRODUCT INVENTORY, GL, AND WO_MSTR UPDATES */
            if not jp then do:

               /* Create Transaction History Record */
               {gprun.i ""woworca.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


               do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

                  {gplock.i
           &file-name=wo_mstr
           &find-criteria="recid(wo_mstr) = wo_recno"
           &exit-allowed=no
           &record-id=recno}

                  if (wo_lot_rcpt = no) then
                  wo_lot_next = lotserial.
                  if close_wo then wo_status = "C".
                  release wo_mstr.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.


               if close_wo then do:
          {gprun.i ""wowomta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
            end.  /* if not jp then do */

            /* JOINT PRODUCT INVENTORY, GL, AND WO_MSTR UPDATES */
            if jp and not undo_setd then do:
              do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

                 find womstr no-lock where recid(womstr) = wo_recno.

                 /* MEMO RECEIPT FOR BASE PROCESS ORDER */
                 find first wo_mstr exclusive-lock
                 where wo_mstr.wo_nbr = womstr.wo_nbr
                 and wo_mstr.wo_joint_type = "5"
                 no-error.

                 if available wo_mstr then do:
                    wo_mstr.wo_qty_chg = 1.
/*L00Y*/            /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
                    {ictrans.i
              &addrid=""""
              &bdnstd=0
              &cracct=""""
              &crcc=""""
              &crproj=""""
              &curr=""""
              &dracct=""""
              &drcc=""""
              &drproj=""""
              &effdate=eff_date
              &exrate=0
              &exrate2=0
              &exratetype=""""
              &exruseq=0
              &glamt=0
              &lbrstd=0
              &line=0
              &location=""""
              &lotnumber=wo_mstr.wo_lot
                  &lotserial=wo_mstr.wo_lot
              &lotref=""""
              &mtlstd=0
              &ordernbr=wo_mstr.wo_nbr
              &ovhstd=0
              &part=wo_mstr.wo_part
              &perfdate=?
              &price=glcost
              &quantityreq=0
              &quantityshort=0
              &quantity=1
              &revision=""""
              &rmks=rmks
              &shiptype=""M""
              &site=wo_mstr.wo_site
              &slspsn1=""""
              &slspsn2=""""
              &sojob=""""
              &substd=0
              &transtype=""RCT-WO""
              &msg=0
              &ref_site=wo_mstr.wo_site
            }
                 
                        
                        end.
                 /* MEMO ISSUES OF BASE PROCESS ITEM TO JOINT PRODUCT LOT #s */
                 for each womstr where womstr.wo_nbr = wo_mstr.wo_nbr
                 and womstr.wo_joint_type <> "5" and wo_mstr.wo_joint_type > ""
                 and womstr.wo_base_id = wo_mstr.wo_lot:
/*GUI*/ if global-beam-me-up then undo, leave.

                    find first sr_wkfl where sr_userid = mfguser
                    and substring(sr_lineid,4,18) = womstr.wo_part
                    and sr_lineid begins "RCT" no-lock no-error.
                    if available sr_wkfl then do:
/*L00Y*/            /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
                    {ictrans.i
              &addrid=""""
              &bdnstd=0
              &cracct=""""
              &crcc=""""
              &crproj=""""
              &curr=""""
              &dracct=""""
              &drcc=""""
              &drproj=""""
              &effdate=eff_date
              &exrate=0
              &exrate2=0
              &exratetype=""""
              &exruseq=0
              &glamt=0
              &lbrstd=0
              &line=0
              &location=""""
              &lotnumber=womstr.wo_lot
              &lotserial=wo_mstr.wo_lot
              &lotref=""""
              &mtlstd=0
              &ordernbr=womstr.wo_nbr
              &ovhstd=0
              &part=wo_mstr.wo_part
              &perfdate=?
              &price=glcost
              &quantityreq=0
              &quantityshort=0
              &quantity=1
              &revision=""""
              &rmks=rmks
              &shiptype=""M""
              &site=wo_mstr.wo_site
              &slspsn1=""""
              &slspsn2=""""
              &sojob=""""
              &substd=0
              &transtype=""ISS-WO""
              &msg=0
              &ref_site=wo_mstr.wo_site
            }
                 
                        
                        if available trgl_det then delete trgl_det.
                    end.
                 end.
/*GUI*/ if global-beam-me-up then undo, leave.


                 /* BASE PROCESS WORK ORDER */
                 find womstr no-lock where womstr.wo_nbr = wo_mstr.wo_nbr
                                       and womstr.wo_joint_type = "5".

                 /* JOINT PRODUCT WORK ORDERS */
                 for each wo_mstr exclusive-lock where
                 wo_mstr.wo_nbr = womstr.wo_nbr and
                 wo_mstr.wo_joint_type <> "" and
                 recid(wo_mstr) <> recid(womstr):
/*GUI*/ if global-beam-me-up then undo, leave.

                    wo_recno = recid(wo_mstr).

                    /* INVENTORY AND GL TRANSACTIONS FOR JOINT PRODUCT ORDERS */
                   {gprun.i ""woworca.p""}
                     

/*GUI*/ if global-beam-me-up then undo, leave.


                    /* UPDATE wip_accum */
                    wip_accum = wip_accum + wo_mstr.wo_wip_tot.
                    wo_mstr.wo_wip_tot = 0.

                 end.

                 if global-beam-me-up then undo, leave.
 /* END - JOINT PRODUCT WORK ORDERS */

                 /* UPDATE BASE PROCESS ORDER */
                 find wo_mstr exclusive-lock
                 where wo_mstr.wo_nbr = womstr.wo_nbr
                 and wo_mstr.wo_joint_type = "5" no-error.
                 if available wo_mstr then do:

                    /* UPDATE RATE AND USAGE VARIANCES FOR BASE PROCESS ORDER */
                    if wip_accum <> 0 then do:
                       /*DETERMINE COSTING METHOD*/
                       {gprun.i ""csavg01.p"" "(input wo_mstr.wo_part,
                    input wo_mstr.wo_site,
                    output glx_set,
                    output glx_mthd,
                    output cur_set,
                    output cur_mthd)"
               }
/*GUI*/ if global-beam-me-up then undo, leave.

                       if glx_mthd <> "AVG" then do:
                          wo_recid = recid(wo_mstr).
                          transtype = "VAR-POST".
                          {gprun.i ""wovarup.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                       end.
                    end.
                    /* UPDATE wo_wip_tot FOR BASE PROCESS ORDER */
                    wo_mstr.wo_wip_tot = wo_mstr.wo_wip_tot + wip_accum.
                    wip_accum = 0.
                    /* CLOSE BASE PROCESS ORDER */
                    if close_wo then do:
                       wo_mstr.wo_status = "C".
                       wo_recno = recid(wo_mstr).
                       {gprun.i ""wowomta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


                       /* UPDATE JOINT WOs WITH STATUS AND UNIT COST */
                       {gprun.i ""wowomti.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


                       if glx_mthd = "AVG" or cur_mthd = "AVG"
                       or cur_mthd = "LAST" then do:

                          /* ALLOC METHOD PROGs HERE FOR XREF ONLY. NOT RUN. */
                          if false then do:
                             {gprun0.i ""wocsal01.p""}
                             {gprun0.i ""wocsal02.p""}
                             {gprun0.i ""wocsal03.p""}
                          end.

                          /*CHOOSE ALLOCATION METHOD*/
                          {gprun.i ""wocsjpal.p"" "(input wo_mstr.wo_part,
                            input wo_mstr.wo_site,
                            output alloc_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                          /*CALCULATE ALLOCATION PERCENTAGE*/
                          {gprun.i alloc_mthd "(input recid(wo_mstr))"}
/*GUI*/ if global-beam-me-up then undo, leave.


                          {gprun.i ""csavg04.p"" "(input recid(wo_mstr),
                           input glx_mthd,
                           input glx_set,
                           input cur_mthd,
                           input cur_set,
                           input gltrans,
                           input gldetail,
                           output wip_accum)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                          wo_mstr.wo_wip_tot = wo_mstr.wo_wip_tot - wip_accum.

                       end. /* IF GLX_MTHD = "AVG" ... */
                    end. /* IF CLOSE_WO */
                 end. /* BASE PROCESS ORDER UPDATE */
              end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION */
           end. /* IF JP THEN DO */




        end.
/*GUI*/ if global-beam-me-up then undo, leave.

        if daybooks-in-use then delete procedure h-nrm no-error.
        
        
