/* woworcd.p - WORK ORDER RECEIPT W/ SERIAL NUMBERS                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.2     LAST MODIFIED: 04/12/94    BY: pma *FN34*          */
/* REVISION: 7.4     LAST MODIFIED: 05/16/94    BY: ais *H371*          */
/* REVISION: 8.5     LAST MODIFIED: 10/05/94    BY: taf *J035*          */
/* REVISION: 8.5     LAST MODIFIED: 10/28/94    BY: pma *J040*          */
/* REVISION: 8.5     LAST MODIFIED: 11/17/94    BY: taf *J038*          */
/* REVISION: 8.5     LAST MODIFIED: 12/20/94    BY: ktn *J041*          */
/* REVISION: 7.4     LAST MODIFIED: 12/22/94    BY: ais *H09K*          */
/* REVISION: 7.4     LAST MODIFIED: 01/18/95    BY: qzl *H09V*          */
/* REVISION: 8.5     LAST MODIFIED: 03/08/95    BY: dzs *J046*          */
/* REVISION: 7.4     LAST MODIFIED: 04/17/95    BY: jpm *H0CJ*          */
/* REVISION: 8.5     LAST MODIFIED: 04/23/95    BY: sxb *J04D*          */
/* REVISION: 7.4     LAST MODIFIED: 06/06/95    BY: dzs *G0P4*          */
/* REVISION: 7.3     LAST MODIFIED: 06/26/95    by: qzl *G0R0*          */
/* REVISION: 8.5     LAST MODIFIED: 07/31/95    BY: kxn *J069*          */
/* REVISION: 7.2     LAST MODIFIED: 08/17/95    BY: qzl *F0TC*          */
/* REVISION: 8.5     LAST MODIFIED: 11/09/95    BY: tjs *J08X*          */
/* REVISION: 8.5     LAST MODIFIED: 11/29/95    BY: kxn *J09C*          */
/* REVISION: 7.4     LAST MODIFIED: 02/05/96    BY: rvw *H0JL*          */
/* REVISION: 8.5     LAST MODIFIED: 03/18/96    by: jpm *J0F5*          */
/* REVISION: 8.5     LAST MODIFIED: 01/18/96    BY: bholmes *J0FY*      */
/* Revision  8.5     Last Modified: 04/26/96    BY: BHolmes *J0KF*      */
/* REVISION: 8.5     LAST MODIFIED: 05/01/96    BY: jym *J0QX*          */
/* REVISION: 8.5     LAST MODIFIED: 07/27/96    BY: jxz *J12C*          */
/* REVISION: 8.5     LAST MODIFIED: 08/01/96    BY: GWM *J10N*          */
/* REVISION: 8.5     LAST MODIFIED: 08/06/96    BY: *G1YK* Russ Witt    */
/* REVISION: 8.5     LAST MODIFIED: 08/12/96    BY: *J141* Fred Yeadon  */
/* REVISION: 8.5     LAST MODIFIED: 02/04/97    BY: *J1GW* Murli Shastri  */
/* REVISION: 8.5     LAST MODIFIED: 08/17/97    BY: *J1Z9* Felcy D'Souza  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.5     LAST MODIFIED: 04/15/98    BY: *J2K7* Fred Yeadon      */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan       */
/* REVISION: 9.0     LAST MODIFIED: 12/01/98    BY: *J35X* Thomas Fernandes */
/* REVISION: 9.0     LAST MODIFIED: 01/27/99    BY: *J38V* Viswanathan M    */
/* REVISION: 9.0     LAST MODIFIED: 03/05/99    BY: *J3C2* Vivek Gogte      */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan       */
/* REVISION: 9.0     LAST MODIFIED: 03/30/99    BY: *J39K* Sanjeev Assudani */
/* REVISION: 9.0     LAST MODIFIED: 03/08/00    BY: *L0TJ* Jyoti Thatte     */

/*FN34***********************************************************************/
/*FN34  MOVED ALL FUNCTIONAL CODE FROM WOWORC.P DUE TO R-CODE CONSTRAINT    */
/*FN34***********************************************************************/

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworcd_p_1 "收到所有的复合产品/副产品"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_2 "废品数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_3 "收货"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_4 "参考"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_5 "总量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_6 "多记录"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_7 "结算"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_8 "换算因子"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_9 "短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_10 "复合产品/副产品收货选项"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworcd_p_11 "           收货量 = 缺缺量"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define shared variable nbr like wo_nbr.
         define shared variable yn like mfc_logical.
         define shared variable open_ref like wo_qty_ord label {&woworcd_p_9}.
         define shared variable rmks like tr_rmks.
          define shared variable vendlot like tr_vend_lot.
         define shared variable serial like tr_serial.
         define shared variable ref like glt_ref.
         define shared variable lot like ld_lot.
         define shared variable i as integer.
         define shared variable total_lotserial_qty like sr_qty.
         define shared variable null_ch as character initial "".
         define shared variable close_wo like mfc_logical label {&woworcd_p_7}.
         define shared variable comp like ps_comp.
         define shared variable qty like wo_qty_ord.
         define shared variable eff_date like glt_effdate.
         define shared variable wo_recno as recid.
         define shared variable leadtime like pt_mfg_lead.
         define shared variable prev_status like wo_status.
         define shared variable prev_release like wo_rel_date.
         define shared variable prev_due like wo_due_date.
         define shared variable prev_qty like wo_qty_ord.
         define shared variable prev_site like wo_site.
         define shared variable del-yn like mfc_logical.
         define shared variable deliv like wod_deliver.
         define shared variable any_issued like mfc_logical.
         define shared variable any_feedbk like mfc_logical.
         define shared variable conv like um_conv
            label {&woworcd_p_8} no-undo.
         define shared variable um like pt_um no-undo.
         define shared variable tot_units like wo_qty_chg
         label {&woworcd_p_5}.
         define shared variable reject_um like pt_um no-undo.
         define shared variable reject_conv like conv no-undo.
         define shared variable pl_recno as recid.
         define shared variable fas_wo_rec like fac_wo_rec.
         define shared variable reject_qty like wo_rjct_chg
            label {&woworcd_p_2} no-undo.
         define shared variable multi_entry like mfc_logical
            label {&woworcd_p_6} no-undo.
         define shared variable lotserial_control as character.
         define shared variable site like sr_site no-undo.
         define shared variable location like sr_loc no-undo.
         define shared variable lotserial like sr_lotser no-undo.
         define shared variable lotref like sr_ref format "x(8)" no-undo.
         define shared variable lotserial_qty like sr_qty no-undo.
         define shared variable cline as character.
         define shared variable issue_or_receipt as character init {&woworcd_p_3}.
         define shared variable trans_um like pt_um.
         define shared variable trans_conv like sod_um_conv.
         define shared variable transtype as character initial "RCT-WO".

         define shared variable undo_all like mfc_logical no-undo.
         define shared variable msg-counter as integer no-undo.
/*FN34*/ define shared variable undo_setd like mfc_logical no-undo.
/*J040*/ define shared variable chg_attr like mfc_logical no-undo.

/*J040*/ define variable srlot like sr_lotser no-undo.
/*J04D*/ define variable lotnext like wo_lot_next.
/*J041*/ define variable newlot like wo_lot_next.
/*J041*/ define variable trans-ok like mfc_logical.
/*J04D*/ define variable lotprcpt like wo_lot_rcpt no-undo.
/*J041*/ define variable alm_recno as recid.
/*J041*/ define variable filename as character.
/*J041*/ define variable wonbr like wo_nbr.
/*J041*/ define variable wolot like wo_lot.

/*J046*/ define shared variable undo_jp like mfc_logical.
/*J046*/ define shared variable jp like mfc_logical.
/*J046*/ define shared variable base like mfc_logical.
/*J046*/ define shared variable base_id like wo_base_id.
/*J046*/ define shared variable base_qty like sr_qty.
/*J046*/ define new shared variable jp-yn like mfc_logical initial yes.
/*J046*/ define new shared variable recv-yn like mfc_logical.
/*J046*/ define new shared variable recv_all like mfc_logical.
/*J046*/ define new shared variable recv like mfc_logical initial yes.
/*J046*/ define variable regular like mfc_logical initial yes.
/*J046*/ define new shared variable recpt-bkfl like mfc_logical initial no.
/*J046*/ define new shared variable firstpass like mfc_logical initial no.
/*J069*/  define variable almr like alm_pgm.
/*J069*/  define variable ii as integer.

/*J141  THE FOLLOWING VARIABLES ARE NO LONGER NEEDED BY THE W/H INTERFACE
 * /*J0FY*/ define variable w-file-type as character format "x(25)".
 * /*J0FY*/ define variable w_nbr like wo_mstr.wo_nbr.
 * /*J0FY*/ define variable w_wip_site like si_mstr.si_site.
 * /*J0FY*/ define variable w_wo_lot   like wo_mstr.wo_lot.
 * /*J0FY*/ define variable w_part     like pt_mstr.pt_part.
 * /*J0KF* moved from include file icrcex.i */
 * /*J0KF*/ define variable w-te_nbr as integer.
 *J141*/

/*J0KF*/ define variable w-te_type as character.

/*J141  THE FOLLOWING VARIABLES ARE NO LONGER NEEDED BY THE W/H INTERFACE
 * /*J0KF*/ define variable w-datastr as character format "x(255)".
 * /*J0KF*/ define variable w-len as integer.
 * /*J0KF*/ define variable w-counter as integer.
 * /*J0KF*/ define variable w-tstring as character format "x(50)".
 * /*J0KF*/ define variable w-group as character format "x(18)".
 * /*J0KF*/ define variable w-str-len as integer.
 * /*J0KF*/ define variable w-update as character format "x".
 * /*J0KF*/ define variable w_whl_src_dest_id like whl_mstr.whl_src_dest_id.
 * /*J0KF*/ define variable w-sent as integer initial 0.
 *J141*/

         define shared frame a.

/*J0QX*         {gpglefdf.i} */
/*J0QX*/ {gpglefv.i}

/*J040*/ /*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
/*J040*/ {gpatrdef.i "shared"}

/*J38V*/ define variable def_status like tr_status no-undo.

/*J035*/ /*FRAME A*/
/*J035*/ {mfworc.i } 

/*J035************** FORM STATEMENT PUT IN MFWORC.I INCLUDE *****************
*        form
*           wo_nbr         colon 15
*           wo_lot         colon 45
*           wo_status      colon 63
*           wo_rmks        colon 15
*           wo_part        colon 15
*           pt_lot_ser     label "L/S" colon 56
*           pt_um          colon 63
*           pt_desc1       colon 15
*           pt_auto_lot    colon 63
*           open_ref       colon 15
*           skip(1)
*           lotserial_qty  colon 15
*           site           colon 54
*           um             colon 15
*           location       colon 54
*           conv           colon 15
*           lotserial      colon 54
*           reject_qty     colon 15
*           lotref         colon 54 label "Ref"
*           reject_um      colon 15
*           multi_entry    colon 54
*           reject_conv    colon 15
*           tot_units      colon 54
*           skip(1)
*           rmks           colon 15
*           eff_date       colon 15
*           close_wo       colon 15
*        with frame a side-labels width 80 attr-space.
*J035************** FORM STATEMENT PUT IN MFWORC.I INCLUDE ****************/

/*J046*/ form
/*J046*/    skip (1)
/*J1GW* /*J046*/    recv_all colon 40 label "Receive All Joint Products" */
/*J1GW*/    recv_all colon 40 label {&woworcd_p_1}
/*J046*/    recv     colon 40 label {&woworcd_p_11}
/*J046*/    skip (1)
/*J046*/ with frame r side-labels overlay row 9 column 24
/*J046*/ title color normal
/*J1GW* /*J046*/     " Joint Products Receipt Options " width 50 attr-space. */
/*J1GW*/ {&woworcd_p_10} width 50 attr-space.

/*J04D*/    find first clc_ctrl no-lock no-error.
/*J04D*/    if not available clc_ctrl then do:
/*J04D*/       {gprun.i ""gpclccrt.p""}
/*J04D*/       find first clc_ctrl no-lock.
/*J04D*/    end.

/*L0TJ** /*FN34*/ find wo_mstr /*no-lock*/ where recid(wo_mstr) = wo_recno. */


/*L0TJ*/    /* BEGIN ADD SECTION */
            for first wo_mstr
               fields(wo_assay wo_batch wo_expire wo_grade wo_joint_type
                      wo_loc wo_lot wo_lot_next wo_lot_rcpt wo_nbr wo_part
                      wo_qty_chg wo_qty_comp wo_qty_ord wo_qty_rjct
                      wo_rctstat wo_rctstat_active wo_rjct_chg wo_rmks
                      wo_site wo_status wo_type)
               where recid(wo_mstr) = wo_recno no-lock:
            end. /* FOR FIRST WO_MSTR */
/*L0TJ*/    /* END ADD SECTION */

/*H09K*/    find pt_mstr no-lock where pt_part = wo_part no-error.
/*FN34*/    undo_setd = yes.

/*J046*/    if jp then do:
/*J046*/       regular = no.
/*J046*/       jp-yn = yes.
/*J046*/       firstpass = yes.
/*J046*/       recv_all = yes.
/*J046*/       recv = no.
/*J046*/       pause 0.
/*J08X*/       if base then display recv_all with frame r.
/*J046*/       update recv_all when (not base) with frame r.
/*J046*/       if recv_all then update recv with frame r.
/*J08X*/       hide frame r.
/*J046*/       if recv_all or base then do:
/*J046*/          /* Branch off to JP Receipts Frame */
/*J046*/          {gprun.i ""wojprc.p"" "(input wo_nbr)"}.
/*J046*/          if undo_setd = yes then leave.
/*J046*/       end.
/*J046*/    end.

/*J046*/  if regular or not recv_all then do:


/*J041*/    if index("ER",wo_type) > 0 then do:
/*J041*/       wonbr = "".
/*J041*/       wolot = "".
/*J041*/       lotprcpt = no.
/*J041*/    end.
/*J041*/    else do:
/*J041*/       wonbr = wo_nbr.
/*J041*/       wolot = wo_lot.
/*J041*/       lotprcpt = wo_lot_rcpt.
/*J041*/    end.
/*J041*/    find pt_mstr where pt_part = wo_part no-lock no-error.

/*J1Z9*     wo_lot_next HOLDS THE LOT NUMBER FOR A PARTICULAR WORK ORDER.   */
/*J1Z9*     WHEN THE PARENT ITEM IS LOT CONTROLLED AND LOT GROUP IS BLANK,  */
/*J1Z9*     wo_lot_next SHOULD BE ASSIGNED THE WORK ORDER ID.               */

/*L0TJ*/    do transaction:
/*L0TJ*/       for first wo_mstr
/*L0TJ*/          where recid(wo_mstr) = wo_recno exclusive-lock:
/*L0TJ*/       end. /* FOR FIRST WO_MSTR */
/*J1Z9*/       if pt_auto_lot = yes and pt_lot_grp = " " then do:
/*J1Z9*/          if (wo_lot_next = "") then wo_lot_next =   wo_lot.
/*J1Z9*/       end. /* IF PT_AUTO_LOT = YES */
/*L0TJ*/    end. /* DO TRANSACTION */

/*J041*/    if (pt_lot_ser = "L")  and
/*J041*/    (not pt_auto_lot or (index("ER", wo_type) > 0))
/*J041*/       then lotserial = wo_lot_next.
/*J041*/       else lotserial = "".
/*J041*/    lotnext = "".
/*J041*/    newlot = "".
/*J041*/    if (pt_lot_ser = "L" and pt_auto_lot = yes and
/*J041*/    pt_lot_grp <> "") and (index("ER", wo_type) = 0)
/*J041*/    then do:
/*J041*/       find alm_mstr where alm_lot_grp = pt_lot_grp
/*J041*/       and alm_site = wo_site no-lock no-error.
/*J041*/       if not available alm_mstr then
/*J041*/       find alm_mstr where alm_lot_grp = pt_lot_grp
/*J041*/       and alm_site = "" no-lock no-error.
/*J041*/       if not available alm_mstr then do:
/*J041*/          {mfmsg.i 2737 3}    /* LOT FORMAT RECORD DOES NOT EXIST */
/*J041*/          leave.
/*J041*/       end.
/*J041*/       else do:
/*J041*/          if (search(alm_pgm) = ?) then do:
/*J069*/             ii = index(alm_pgm,".p").
/*J0F5* /*J069*/     almr = substring(alm_pgm, 1, 2) + "/"  */
/*J0F5*/             almr = global_user_lang_dir + "/"
/*J0F5*/                  + substring(alm_pgm, 1, 2) + "/"
/*J069*/                  + substring(alm_pgm,1,ii - 1) + ".r".
/*J069*/             if (search(almr)) = ? then do:
/*J041*/                {mfmsg02.i 2732 4 alm_pgm}
                         /* AUTO LOT PROGRAM NOT FOUND*/
/*J041*/                leave.
/*J069*/             end.
/*J041*/          end.
/*J041*/       end.
/*J041*/       find first sr_wkfl where sr_userid = mfguser
/*J041*/       and sr_lineid = cline no-lock no-error.
/*J041*/       if available sr_wkfl then lotserial = sr_lotser.
/*J041*/       if newlot = "" then do:
/*J041*/          alm_recno = recid(alm_mstr).
/*J041*/          filename = "wo_mstr".
/*J041*/          if false then do:
/*J0F5* *****************************************************************
 * /*J041*/         {gprun0.i gpauto01.p "(input alm_recno,
 *                                           input wo_recno,
 *                                               input "filename",
 *                                           output newlot,
 *                                           output trans-ok)"
 *                   }
 *************************************************************************/
/*J0F5*/            {gprun.i ""gpauto01.p"" "(input alm_recno,
                                               input wo_recno,
                                               input "filename",
                                               output newlot,
                                               output trans-ok)"
                    }
/*J041*/          end.
/*J041*/          {gprun.i alm_pgm "(input alm_recno,
                                     input wo_recno,
                                     input "filename",
                                     output newlot,
                                     output trans-ok)"
                  }
/*J041*/          if not trans-ok then do:
/*J041*/             {mfmsg.i 2737 3} /* LOT FORMAT RECORD DOES NOT EXIST */
/*J041*/             leave.
/*J041*/          end.
/*J041*/          lotserial = newlot.
/*J041*/          release alm_mstr.
/*J041*/       end.  /* NEWLOT = "" */
/*J041*/    end.  /* PT_LOT_SER = L */
/*J041*/    display lotserial with frame a.

            setd:
/*FN34*     repeat on endkey undo mainloop, retry mainloop:  */
/*FN34*/    repeat on endkey undo setd, leave:
               site = "".
               location = "".
/*J041*        lotserial = "".     */
               lotref = "".
               lotserial_qty = total_lotserial_qty.
/*J12C         cline = "".   */
/*J12C*/       if wo_joint_type <> "" and wo_joint_type <> "5"
/*J12C*/       then cline = "RCT" + wo_part.
/*J12C*/       else cline = "".

               global_part = wo_part.
               i = 0.
               for each sr_wkfl no-lock where sr_userid = mfguser
               and sr_lineid = cline :
                  i = i + 1.
                  if i > 1 then leave.
               end.
               if i = 0 then do:
                  site = wo_site.
                  location = wo_loc.
                  if location = "" and available pt_mstr then
                     location = pt_loc.
               end.
               else
               if i = 1 then do:
                  find first sr_wkfl where sr_userid = mfguser
/*H0CJ*/          and sr_lineid = cline no-lock no-error.
/*H0CJ*/          if available sr_wkfl then do:
                     site = sr_site.
                     location = sr_loc.
                     lotserial = sr_lotser.
                     lotref = sr_ref.
/*H0CJ*/          end.
               end.

/*J040*/       /*INITIALIZE ATTRIBUTE VARIABLES WITH CURRENT SETTINGS*/
/*J040*/       assign chg_assay   = wo_assay
/*J040*/              chg_grade   = wo_grade
/*J040*/              chg_expire  = wo_expire
/*J040*/              chg_status  = wo_rctstat
/*J040*/              assay_actv  = yes
/*J040*/              grade_actv  = yes
/*J040*/              expire_actv = yes
/*J040*/              status_actv = yes
/*J040*/              resetattr   = no.

/*J040*/       if wo_rctstat_active = no then do:
/*J040*/          find in_mstr where in_part = wo_part and in_site = wo_site
/*J040*/          no-lock no-error.
/*J040*/          if available in_mstr and in_rctwo_active = yes then
/*J040*/             chg_status = in_rctwo_status.
/*J040*/          else if available pt_mstr and pt_rctwo_active = yes then
/*J040*/             chg_status = pt_rctwo_status.
/*J040*/          else do:
/*J040*/             chg_status = "".
/*J040*/             status_actv = no.
/*J040*/          end.
/*J040*/       end.

/*J38V*/       def_status = chg_status.

               locloop:
/*FN34*******  do on error undo, retry on endkey undo mainloop, retry:  */
/*FN34*/       do on error undo, retry on endkey undo setd, leave:
                  if available pt_mstr then do:
                     if pt_auto_lot then do:
/*J09C*  /*J041*/                if pt_lot_grp = "" then lotserial = wo_lot. */
/*J09C*/                if pt_lot_grp = "" then lotserial = wo_lot_next.
                        multi_entry = no.
                        display lotserial multi_entry with frame a.
                        update lotserial_qty
                           um
                           conv
                           reject_qty
                           reject_um
                           reject_conv
                           site
                           location
/*J04D*                    lotref */
/*J3C2** /*J04D*/          lotref when (pt_lot_grp <> "")                    */
/*J3C2** /*J04D*/          multi_entry when (pt_lot_grp <> "")               */
/*J3C2*/                   lotref
/*J3C2*/                   multi_entry
                           chg_attr
                           with frame a
                        editing:
                           global_site = input site.
                           global_loc = input location.
                           readkey.
                           apply lastkey.
                        end.
                     end.   /* if pt_auto_lot */
                     else do:
                        update lotserial_qty
                           um
                           conv
                           reject_qty
                           reject_um
                           reject_conv
                           site
                           location
                           lotserial
                           lotref
                           multi_entry
                           chg_attr
                        with frame a editing:
                           global_site = input site.
                           global_loc = input location.
                           global_lot = input lotserial.
                           readkey.
                           apply lastkey.
                        end.
                     end.
                     if um <> pt_um then do:
                        if not conv entered then do:
                           {gprun.i ""gpumcnv.p"" "(input um,
                                                    input pt_um,
                                                    input wo_part,
                                                    output conv)"}
                           if conv = ? then do:
                              {mfmsg.i 33 2}
                              conv = 1.
                           end.
                           display conv with frame a.
                        end.
                     end.
                     if reject_um <> pt_um then do:
                        if not reject_conv entered then do:
                           {gprun.i ""gpumcnv.p"" "(input reject_um,
                                                    input pt_um,
                                                    input wo_part,
                                                    output reject_conv)"}
                           if reject_conv = ? then do:
                              {mfmsg.i 33 2}
                              reject_conv = 1.
                           end.
                           display reject_conv with frame a.
                        end.
                     end. /* IF REJECT_UM <> PT_UM */

/*J041*  IF SINGLE LOT PER RECEIPT THEN VERIFY IF LOT IS USED */
/*J041*/             if (lotprcpt = yes) and (pt_lot_ser = "L")
/*J04D*/             and (clc_lotlevel <> 0)
/*J041*/             then do:
/*J041*/                find first lot_mstr where lot_serial = lotserial
/*J041*/                and lot_part = wo_part and lot_nbr = wo_nbr
/*J041*/                and lot_line = wo_lot no-lock no-error.
/*J041*/                if available lot_mstr
/*J041*/                then do:
/*J041*/                   {mfmsg.i 2759 3} /* LOT IS IN USE */
/*J041*/                    next-prompt lotserial with frame a.
/*J041*/                   undo, retry.
/*J041*/                end.
/*J041*/                find first lotw_wkfl where lotw_lotser = lotserial and
/*J041*/                lotw_mfguser <> mfguser and lotw_part <> pt_part
/*J041*/                no-lock no-error.
/*J041*/                if available lotw_wkfl then do:
/*J041*/                   {mfmsg.i 2759 3} /* LOT IS IN USED */
/*J041*/                   next-prompt lotserial with frame a.
/*J041*/                   undo, retry.
/*J041*/                end.
/*J041*/             end.

                  end.     /* IF AVAILABLE PT_MSTR */
                  else do:
                     update lotserial_qty um conv
                        reject_qty reject_um reject_conv
                        site location lotserial lotref
                        chg_attr
                        multi_entry
                     with frame a
                     editing:
                        global_site = input site.
                        global_loc = input location.
                        global_lot = input lotserial.
/*J040*/                global_ref = input lotref.
                        readkey.
                        apply lastkey.
                     end.
                  end.

/*J2K7  If the work order is being received into a warehouse location, set
        the Reference field to the warehouse's default inventory status
        unless the user has explicitly entered a Reference value.  This is
        necessary in order to permit a single warehouse to store inventory
        with multiple statuses (e.g. good, scrap, inspect) for the same item
        number.  The primary key structure of ld_det will force the
        inventory to have the same status unless the quantities can be
        distinguished through different Lot/Serial or Ref numbers. */

/*J2K7*/          if lotref = "" and
/*J2K7*/            can-find(whl_mstr where whl_site = site
/*J2K7*/              and whl_loc = location no-lock)
/*J2K7*/          then do:
/*J2K7*/              find loc_mstr where loc_site = site
/*J2K7*/                and loc_loc = location no-lock.
/*J2K7*/              assign lotref = loc_status
/*J2K7*/                global_ref = loc_status.
/*J2K7*/          end.

                  i = 0.
                  for each sr_wkfl no-lock where sr_userid = mfguser
                  and sr_lineid = cline:
                     i = i + 1.
                     if i > 1 then do:
                        multi_entry = yes.
                        leave.
                     end.
                  end.

                  trans_um = um.
                  trans_conv = conv.

                  if multi_entry then do:
                     if i >= 1 then do:
                        assign site = ""
                               location = ""
/*J041*                        lotserial = ""  */
                                      lotref = "".
                     end.
/*J041*/             if (lotprcpt = yes) then lotnext = lotserial.
/*J038*              {gprun.i ""icsrup.p"" "(wo_site)"}                     */
/*J038*  ADDED WO_NBR AND WO_LOT AS INPUTS TO ICSRUP.P                      */
/*J04D*/             {gprun.i ""icsrup.p"" "(input wo_site,
                                             input wonbr,
                                             input wolot,
                                             input-output lotnext,
                                             input lotprcpt)"}
                  end.
                  else do:
/*J038*************** REPLACE ICEDIT.I WITH ICEDIT.P ************************/
/*J038*************  {icedit.i       ****************************************/
/*J038*                 &transtype=""RCT-WO""                               */
/*J038*                 &site=site                                          */
/*J038*                 &location=location                                  */
/*J038*                 &part=global_part                                   */
/*J038*                 &lotserial=lotserial                                */
/*J038*                 &lotref=lotref                                      */
/*J038*                 &quantity="lotserial_qty * trans_conv"              */
/*J038*                 &um=trans_um                                        */
/*J038*              }                                                      */

/*J35X*/             if lotserial_qty <> 0 then do:

/*J038******************** CALL ICEDIT.P ************************************/
/*J04D*/                { gprun.i ""icedit.p"" " ( input ""RCT-WO"",
                                                   input site,
                                                   input location,
                                                   input global_part,
                                                   input lotserial,
                                                   input lotref,
                                                  input lotserial_qty * trans_conv,
                                                   input trans_um,
                                                   input wonbr,
                                                   input wolot,
                                                   output yn )"
                        }
/*J038*/                if yn then undo locloop, retry.
/*J35X*/             end. /* IF LOTSERIAL_QTY <> 0 */

                     if wo_site <> site then do:
/*F0TC*/ /**** The following code has been replaced by icedit4.p which ****/
/*F0TC*/ /**** can be used in both multi line and single line mode.    ****/
/*F0TC*/ /*************************** Delete: Begin ***********************
 *                      {gprun.i ""icedit3.p"" "(input ""RCT-WO"",
 *                                               input wo_site,
 *                                               input location,
 *                                               input global_part,
 *                                               input lotserial,
 *                                               input lotref,
 *                                               input lotserial_qty
 *                                                     * trans_conv,
 *                                               input trans_um,
 *                                               output yn)"
 *                      }
 *                      if yn then undo locloop, retry.
 *
 *                      {gprun.i ""icedit3.p"" "(input ""ISS-TR"",
 *                                               input wo_site,
 *                                               input location,
 *                                               input global_part,
 *                                               input lotserial,
 *                                               input lotref,
 *                                               input lotserial_qty
 *                                                     * trans_conv,
 *                                               input trans_um,
 *                                               output yn)"
 *                      }
 *                      if yn then undo locloop, retry.
 *
 *                      {gprun.i ""icedit3.p"" "(input ""RCT-TR"",
 *                                               input site,
 *                                               input location,
 *                                               input global_part,
 *                                               input lotserial,
 *                                               input lotref,
 *                                               input lotserial_qty
 *                                                     * trans_conv,
 *                                               input trans_um,
 *                                               output yn)"
 *                      }
/*F0TC*/ **************************** Delete: End *************************/

/*J35X*/                if lotserial_qty <> 0 then do:

/*J038*/    /*          Added wonbr & wolot below.  Done during merge 1/5/96 */
/*F0TC*/                   {gprun.i ""icedit4.p"" "(input ""RCT-WO"",
                                                    input wo_site,
                                                    input site,
                                                    input pt_loc,
                                                    input location,
                                                    input global_part,
                                                    input lotserial,
                                                    input lotref,
                                                    input lotserial_qty
                                                          * trans_conv,
                                                    input trans_um,
                                                    input wonbr,
                                                    input wolot,
                                                    output yn)"
                           }
                           if yn then undo locloop, retry.
/*J35X*/                end. /* IF LOTSERIAL_QTY <> 0 */
                     end.

                     find first sr_wkfl where sr_userid = mfguser
/*H0CJ*/             and sr_lineid = cline exclusive-lock no-error.
                     if lotserial_qty = 0 then do:
                        if available sr_wkfl then do:
                           total_lotserial_qty = total_lotserial_qty - sr_qty.
                           delete sr_wkfl.
                        end.
                     end.
                     else do:
                        if available sr_wkfl then do:
                           assign
                           total_lotserial_qty = total_lotserial_qty - sr_qty
                           + lotserial_qty
                           sr_site = site
                           sr_loc = location
                           sr_lotser = lotserial
                           sr_ref = lotref
                           sr_qty = lotserial_qty.
                        end.
                        else do:
                           create sr_wkfl.
                           assign
                           sr_userid = mfguser
                           sr_lineid = cline
                           sr_site = site
                           sr_loc = location
                           sr_lotser = lotserial
                           sr_ref = lotref.
                           sr_qty = lotserial_qty.
                           total_lotserial_qty = total_lotserial_qty
                                                + lotserial_qty.
                        end.
                     end.
                  end. /*else do (multi-entry = no)*/

/*J040*/          /*SET AND UPDATE INVENTORY DETAIL ATTRIBUTES*/
/*J39K*/          /* ADDED THIRD PARAMETER EFF_DATE */
/*J040*/          {gprun.i ""worcat02.p"" "(input  recid(wo_mstr),
                                            input  chg_attr,
                                            input  eff_date,
                                            input-output chg_assay,
                                            input-output chg_grade,
                                            input-output chg_expire,
                                            input-output chg_status,
                                            input-output assay_actv,
                                            input-output grade_actv,
                                            input-output expire_actv,
                                            input-output status_actv)"}

/*J040*/          /*TEST FOR ATTRIBUTE CONFLICTS*/
/*J040*/          for each sr_wkfl where sr_userid = mfguser
/*J040*/          and sr_lineid = cline no-lock with frame a:

/*J39K*/             /* ADDED SIXTH PARAMETER EFF_DATE */
/*J040*/             {gprun.i ""worcat01.p"" "(input recid(wo_mstr),
                                               input sr_site,
                                               input sr_loc,
                                               input sr_ref,
                                               input sr_lotser,
                                               input eff_date,
                                               input-output chg_assay,
                                               input-output chg_grade,
                                               input-output chg_expire,
                                               input-output chg_status,
                                               input-output assay_actv,
                                               input-output grade_actv,
                                               input-output expire_actv,
                                               input-output status_actv,
                                               output trans-ok)"}

/*J040*/             if not trans-ok then do with frame a:
/*J040*/                srlot = sr_lotser.
/*J040*/                if sr_ref <> "" then srlot = srlot + "/" + sr_ref.
/*J040*/                /*ATTRIBUTES DO NOT MATCH LD_DET*/
/*J040*/                {mfmsg02.i 2742 4 srlot}
/*J040*/                next-prompt site.
/*J040*/                undo locloop, retry.
/*J040*/            end.
/*J040*/          end. /*for each sr_wkfl*/
               end. /*locloop*/
               tot_units = total_lotserial_qty * conv
                           + reject_qty * reject_conv.

/*FN34*/       if ((total_lotserial_qty * conv > 0) and
/*FN34*/           (reject_qty * reject_conv < 0))
/*FN34*/       or ((total_lotserial_qty * conv < 0) and
/*FN34*/           (reject_qty * reject_conv > 0))
/*FN34*/       then do:
/*FN34*/          {mfmsg.i 502 3} /*good & scrapped must have same sign*/
/*FN34*/          reject_qty = 0.
/*FN34*/          undo, retry.
/*FN34*/       end.

/*FN34*******************DELETED FOLLOWING SECTION**************************
       *       if wo_qty_ord > 0 and
       *       wo_qty_comp + (total_lotserial_qty * conv) < 0 or
       *       wo_qty_ord < 0 and
       *       wo_qty_comp + (total_lotserial_qty * conv) > 0 then do:
       *        {mfmsg.i 556 3}.
       *        pause.
       *        undo, retry.
       *       end.
**FN34*******************DELETED PRECEDING SECTION*************************/

/*G0P4*/       /* CHECK FOR lotserial_qty ENTERED */
/*FN34*/       if (wo_qty_ord > 0 and (wo_qty_comp
/*FN34*/          + (total_lotserial_qty * conv)
/*G0P4 /*FN34*/   + (reject_qty * reject_conv)) < 0)         */
/*G0P4*/          ) < 0)
/*FN34*/       or (wo_qty_ord < 0 and (wo_qty_comp
/*FN34*/          + (total_lotserial_qty * conv)
/*G0P4 /*FN34*/          + (reject_qty * reject_conv)) < 0)  */
/*G0P4*/          ) >  0)
/*FN34*/       then do:
/*FN34*/          {mfmsg.i 556 3}. /*REVERSE RCPT MAY NOT EXCEED PREV RCPT*/
/*FN34*/          reject_qty = 0.
/*FN34*/          undo, retry.
/*FN34*/       end.

/*G0P4*/       /* CHECK FOR reject_qty ENTERED */
/*G0P4*/       if (wo_qty_ord > 0 and (wo_qty_rjct
/*G0P4*/          + (reject_qty * reject_conv)) < 0)
/*G0P4*/       or (wo_qty_ord < 0 and (wo_qty_rjct
/*G0P4*/          + (reject_qty * reject_conv)) >  0)
/*G0P4*/       then do:
/*G1YK*G0P4*      {mfmsg.i 556 3}. /*REVERSE RCPT MAY NOT EXCEED PREV RCPT*/ */
/*G1YK*/          {mfmsg.i 1373 3}. /*REVERSE SCRAP MAY NOT EXCEED PREV SCRAP*/
/*G0P4*/          reject_qty = 0.
/*G0P4*/          undo, retry.
/*G0P4*/       end.

               display tot_units with frame a.

/*J046*               do on endkey undo setd, retry:            */
/*J046*/       if regular then
/*J046*/       do on endkey undo setd, retry:
                  if eff_date = ? then eff_date = today.
                  DISPLAY EFF_DATE WITH FRAME A.
                  update rmks /*eff_date*/ vendlot close_wo with frame a.

                  /* CHECK EFFECTIVE DATE */
/*J0QX*                  {gpglef.i ""IC"" glentity eff_date} */
/*J0QX*/            find si_mstr where si_site = site no-lock.
/*J0QX*/              {gpglef1.i
                        &module = ""WO""
                        &entity = si_entity
                        &date = eff_date
                        &prompt = "eff_date"
                        &frame = "a"
                        &loop = "setd"
                       }
               end.

/*J046*/       /* CLOSING FOR A SINGLE JOINT PRODUCT RECEIPT   */
/*J046*/       /* RESULTS IN CLOSING ALL RELATED JOINT PRODUCT */
/*J046*/       /* WORK ORDERS                                  */

/*J046*/       if jp then
/*J046*/       do on endkey undo setd, retry:
/*J046*/          if eff_date = ? then eff_date = today.
/*J046*/          DISPLAY eff_date WITH FRAME a.
              update rmks /*eff_date*/ close_wo with frame a.

/*J046*/          /* CHECK EFFECTIVE DATE */
/*J0QX* /*J046*/          {gpglef.i ""IC"" glentity eff_date} */
/*J0QX*/            find si_mstr where si_site = site no-lock.
/*J0QX*/              {gpglef1.i
                        &module = ""WO""
                        &entity = si_entity
                        &date = eff_date
                        &prompt = "eff_date"
                        &frame = "a"
                        &loop = "setd"
                       }
/*J046*/       end.

/*J046*/       /*MAKE SURE THAT ALL JOINT ORDERS USE THE SAME COST SETS*/
/*J046*/       if close_wo and jp then do:
/*J046*/          {mfmsg.i 6554 2} /* All Joint WOs will close */
/*J046*/          {gprun.i ""woavgck1.p"" "(input  wo_nbr,
                                            output undo_all)"}
/*J046*/          if undo_all then do:
/*J046*/             {mfmsg.i 6553 4} /*Cost set assign incomplete*/
/*J046*/             close_wo = no.
/*J046*/             next-prompt close_wo with frame a.
/*J046*/          end.
/*J046*/       end.

               do on endkey undo setd, retry setd:
                  yn = yes.
                  {mfmsg01.i 359 1 yn} /* Display lotserials being received? */
                  if yn then do:
                     hide frame a.
                     form
/*H0CJ*/ /*V8!          space(1) */
                        wo_nbr wo_lot wo_part
                     with frame b side-labels width 80.
                     display wo_nbr wo_lot wo_part with frame b.
                     for each sr_wkfl no-lock where sr_userid = mfguser
                     with width 80:
/*H0CJ*/                display /*V8! space(1) */ sr_site sr_loc sr_lotser
                        sr_ref format "x(8)" column-label {&woworcd_p_4}
                        sr_qty.
                     end.
                  end.
               end.

               do on endkey undo setd, retry setd:

                  yn = yes.
                  {mfmsg01.i 12 1 yn} /* "Is all info correct?" */

                  /* Added section */
                  if yn then do:

                     {gplock.i
                     &file-name=wo_mstr
                     &find-criteria="recid(wo_mstr) = wo_recno"
                     &exit-allowed=yes
                     &record-id=recno}

                     if keyfunction(lastkey) = "end-error" then do:
                        find wo_mstr no-lock where recid(wo_mstr) = wo_recno
/*H0CJ*/                no-error.
                        next setd.
                     end.

                     if not available wo_mstr then do:
                        {mfmsg.i 510 4} /* WORK ORDER/LOT DOES NOT EXIST. */
/*FN34                  next mainloop.  */
/*FN34*/                leave.
                     end.


                     if conv <> 1 then
/*H0JL*H0CJ*         for each sr_wkfl no-lock where sr_userid = mfguser   */
/*H0JL*/             for each sr_wkfl exclusive-lock where sr_userid = mfguser
                     and sr_lineid = cline:
                        sr_qty = sr_qty * conv.
                     end.
                     total_lotserial_qty = total_lotserial_qty * conv.

                     wo_qty_chg = total_lotserial_qty.
                     wo_rjct_chg = reject_qty * reject_conv.

/*J38V*/             /* UPDATE WO_MSTR RECEIPT STATUS FIELDS IF USER SELECTS*/
/*J38V*/             /* USE AS DEFAULT = NO OR ATTRIBUTES FRAME IS NOT      */
/*J38V*/             /* ACCESSED AT ALL.                                    */

/*J38V*/             /* BEGIN OF ADDED CODE */
                     if resetattr = no then
                     do:
                        if status_actv = yes then
                           assign
                              wo_mstr.wo_rctstat = def_status
                              wo_mstr.wo_rctstat_active = status_actv.
                     end. /* IF RESETATTR = NO */
/*J38V*/             /* END OF ADDED CODE */

/*J10N********* REPLACED ICRCEX.I WITH WIICRCEX.P ************************/

                     /* DETERMINE IF WAREHOUSING INTERFACE IS ACTIVE */
/*J10N*/             if can-find(first whl_mstr
/*J10N*/                         where whl_act = true no-lock) then do:

                    /* SET EXPORT TRANS TYPE BASED ON MENU PROCEDURE NAME */
/*J141*/                w-te_type =
/*J141*/                     "wi-" + substring(execname,1,length(execname) - 2).

                        /* EXPORT DATA TO WAREHOUSE */
/*J10N*/                for each sr_wkfl where sr_userid = mfguser:

/*J141 /*J10N*/            {gprun.i ""wiicrcex.p"" */
/*J141                              "(input 'wi-wowoisrc', */
/*J141*/                   {gprun.i ""wiicrcex.p""
/*J141*/                            "(input w-te_type,
                                      input wo_nbr,
                                      input wo_lot,
                                      input wo_part,
                                      input sr_qty,
                                      input trans_um,
                                      input trans_conv,
                                      input sr_site,
                                      input sr_loc,
                                      input sr_lot,
                                      input sr_ref,
                                      input eff_date)"}

/*J10N*/                end. /* FOR EACH SR_WKFL */

/*J10N*/             end. /* IF WAREHOUSING ACTIVE */

/*J10N*************** REMOVED BELOW INCLUDE FILE *************************
 * /*J0FY*/              assign
 * /*J0FY*/                      w_nbr       = wo_nbr
 * /*J0FY*/                      w_wip_site  = ""
 * /*J0FY*/                      w_wo_lot    = wo_lot
 * /*J0FY*/                      w_part      = wo_part
 * /*J0FY*/                      w-file-type = "woworc".
 * /*J0FY*/             {icrcex.i}
 *J10N*************** END OF REMOVED CODE *********************************/

                     release wo_mstr.
/*H371*/             undo_setd = no.
                     leave setd.
                  end.
                  /* End of added section */

               end.

               undo_setd = no.

/*H0CJ*/ /*V8! hide frame b. */
            end.
            /*setd*/
/*J046*/ end.  /* If regular or not jp-yn then do */

/*H09V*/ if keyfunction(lastkey) = "END-ERROR" then undo_setd = yes.

/*J0FY*/ site = global_site.
/*J0FY*/ location = global_loc.
