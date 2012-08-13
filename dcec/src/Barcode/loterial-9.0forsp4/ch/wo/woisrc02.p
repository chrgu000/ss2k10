/* woisrc02.p - WORK ORDER RECEIPT W/ SERIAL NUMBERS                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 6.0     LAST MODIFIED: 06/08/90    BY: emb                 */
/* REVISION: 6.0     LAST MODIFIED: 12/17/90    BY: wug *D619*          */
/* REVISION: 6.0     LAST MODIFIED: 09/12/91    BY: wug *D858*          */
/* REVISION: 6.0     LAST MODIFIED: 10/02/91    BY: alb *D887*          */
/* REVISION: 6.0     LAST MODIFIED: 11/08/91    BY: wug *D920*          */
/* REVISION: 6.0     LAST MODIFIED: 11/27/91    BY: ram *D954*          */
/* REVISION: 7.0     LAST MODIFIED: 01/28/92    BY: pma *F104*          */
/* REVISION: 7.0     LAST MODIFIED: 02/12/92    BY: pma *F190*          */
/* REVISION: 7.3     LAST MODIFIED: 09/22/92    BY: ram *G079*          */
/* REVISION: 7.3     LAST MODIFIED: 09/27/93    BY: jcd *G247*          */
/* REVISION: 7.3     LAST MODIFIED: 03/04/93    BY: ram *G782*          */
/* REVISION: 7.3     LAST MODIFIED: 05/07/93    BY: ram *GA79*          */
/* REVISION: 7.4     LAST MODIFIED: 07/22/93    BY: pcd *H039*          */
/* REVISION: 7.4     LAST MODIFIED: 12/20/93    BY: pcd *GH30*          */
/* REVISION: 7.2     LAST MODIFIED: 04/12/94    BY: pma *FN34*          */
/* Oracle changes (share-locks)    09/13/94           BY: rwl *GM56*    */
/* REVISION: 7.2     LAST MODIFIED: 09/22/94    BY: ljm *GM78*          */
/* REVISION: 8.5     LAST MODIFIED: 10/07/94    BY: TAF *J035*          */
/* REVISION: 7.2     LAST MODIFIED: 11/08/94    BY: ljm *GO33*          */
/* REVISION: 8.5     LAST MODIFIED: 10/27/94    BY: pma *J040*          */
/* REVISION: 8.5     LAST MODIFIED: 11/10/94    BY: TAF *J038*          */
/* REVISION: 8.5     LAST MODIFIED: 12/08/94    by: mwd *J034*          */
/* REVISION: 8.5     LAST MODIFIED: 12/28/94    by: ktn *J041*          */
/* REVISION: 8.5     LAST MODIFIED: 03/08/95    by: dzs *J046*          */
/* REVISION: 7.4     LAST MODIFIED: 03/23/95    by: srk *G0KT*          */
/* REVISION: 8.5     LAST MODIFIED: 06/07/95    by: sxb *J04D*          */
/* REVISION: 7.3     LAST MODIFIED: 06/26/95    by: qzl *G0R0*          */
/* REVISION: 8.5     LAST MODIFIED: 07/31/95    by: kxn *J069*          */
/* REVISION: 7.2     LAST MODIFIED: 08/17/95    BY: qzl *F0TC*          */
/* REVISION: 8.5     LAST MODIFIED: 11/29/95    by: kxn *J09C*          */
/* REVISION: 8.5     LAST MODIFIED: 03/18/96    by: jpm *J0F5*          */
/* REVISION: 8.5     LAST MODIFIED: 07/16/96    by: kxn *J0QX*          */
/* REVISION: 8.5     LAST MODIFIED: 07/27/96    by: jxz *J12C*          */
/* REVISION: 8.5     LAST MODIFIED: 08/06/96    BY: *G1YK*  Russ Witt       */
/* REVISION: 8.5     LAST MODIFIED: 08/17/97    BY: *J1Z9* Felcy D'Souza*/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.5     LAST MODIFIED: 04/15/98    BY: *J2K7* Fred Yeadon  */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan       */
/* REVISION: 9.0     LAST MODIFIED: 12/01/98    BY: *J35X* Thomas Fernandes */
/* REVISION: 9.0     LAST MODIFIED: 03/05/99    BY: *J3C2* Vivek Gogte      */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan       */
/* REVISION: 9.0     LAST MODIFIED: 03/30/99    BY: *J39K* Sanjeev Assudani */
/* REVISION: 9.0     LAST MODIFIED: 03/09/00    BY: *L0TJ* Jyoti Thatte     */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woisrc02_p_1 "总量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_2 "收货"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_3 "废品数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_4 "结算"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_5 "L/S"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_6 "短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_7 "改变属性"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_8 "多记录"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_9 "换算因子"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*G0KT*
 *       /* DISPLAY TITLE */
 * /*GM78*/ /*V8-*/
 * /*H039*/ {mfdtitle.i "0+ "}
 * /*GM78*/ /*V8+*/ /*V8! {mfdeclre.i} */
 *G0KT*/

         define variable field1 as character.
         define shared variable wo_recno as recid.
         define shared variable eff_date like glt_effdate.
/*       define shared variable mfguser as character.           *G247* */
         define new shared variable transtype as character initial "RCT-WO".
 define shared variable vendlot like tr_vend_lot.
         define variable nbr like wo_nbr.
         define variable yn like mfc_logical.
         define variable open_ref like wo_qty_ord label {&woisrc02_p_6}.
         define shared variable rmks like tr_rmks.
         define shared variable serial like tr_serial.
         define variable lot like ld_lot.
         define variable i as integer.
         define new shared variable total_lotserial_qty like sr_qty.
         define variable null_ch as character initial "".
         define shared variable close_wo like mfc_logical label {&woisrc02_p_4}.
         define new shared variable comp like ps_comp.
         define new shared variable qty like wo_qty_ord.
         define new shared variable leadtime like pt_mfg_lead.
         define new shared variable prev_status like wo_status.
         define new shared variable prev_release like wo_rel_date.
         define new shared variable prev_due like wo_due_date.
         define new shared variable prev_qty like wo_qty_ord.
         define new shared variable del-yn like mfc_logical.
         define new shared variable deliv like wod_deliver.
         define new shared variable any_issued like mfc_logical.
         define shared variable conv like um_conv label {&woisrc02_p_9} no-undo.
         define variable um like pt_um no-undo.
         define variable tot_units like wo_qty_chg label {&woisrc02_p_1}.
         define variable reject_um like pt_um no-undo.
         define shared variable reject_conv like conv no-undo.
         define new shared variable pl_recno as recid.
         define variable fas_wo_rec as character.
         define new shared variable reject_qty like wo_rjct_chg
/*FN34*/ label {&woisrc02_p_3}
         no-undo.
         define new shared variable multi_entry like mfc_logical
            label {&woisrc02_p_8} no-undo.
         define new shared variable lotserial_control as character.
         define new shared variable site like sr_site no-undo.
         define new shared variable location like sr_loc no-undo.
/*J041* define new shared variable lotserial like sr_lotser no-undo.  */
/*J041*/ define shared variable lotserial like sr_lotser no-undo.
         define new shared variable lotserial_qty like sr_qty no-undo.
         define new shared variable cline as character.
         define new shared variable issue_or_receipt as character
         init {&woisrc02_p_2}.
         define new shared variable trans_um like pt_um.
         define new shared variable trans_conv like sod_um_conv.
         define new shared variable lotref like sr_ref format "x(8)" no-undo.

/*J04D*/ define variable lotnext like wo_lot_next .
/*J041*/ define variable newlot like wo_lot_next.
/*J041*/ define variable trans-ok like mfc_logical.
/*J04D*/ define variable lotprcpt like wo_lot_rcpt no-undo.
/*J041*/ define variable alm_recno as recid.
/*J041*/ define variable filename as character.
/*J041*/ define variable wonbr like wo_nbr.
/*J041*/ define variable wolot like wo_lot.

/*J040*/ define variable srlot like sr_lotser no-undo.
/*J040*/ define variable chg_attr like mfc_logical
            label {&woisrc02_p_7} no-undo.
/*J041*/ define output parameter trans_ok like mfc_logical.
/*J046*/ define shared variable jp        like mfc_logical initial no.
/*J046*/ define shared variable undo_all  like mfc_logical no-undo.
/*J069*/ define variable almr like alm_pgm.
/*J069*/ define variable ii as integer.

         DEFINE FRAME xx
              vendlot COLON 15 LABEL "供应商批号"
              WITH WIDTH 80 THREE-D SIDE-LABEL.

/*J0QX* /*H039*/ {gpglefdf.i} */
/*J0QX*/ {gpglefv.i}

/*J040*/ /*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
/*J040*/ {gpatrdef.i "shared"}

         form
            wo_rmks        colon 15 LABEL "备注"
            open_ref       colon 15 
/*J035*/    pt_um          colon 40 LABEL "单位"
/*J035*/    pt_lot_ser     colon 57 label {&woisrc02_p_5}
/*J035*/    wo_batch       colon 15 LABEL "批处理"
/*J035*     pt_lot_ser     colon 57 label "L/S"               */
/*J035*     pt_um          colon 15                           */
            pt_auto_lot    colon 57 LABEL "自动批号"
            skip(1)
            lotserial_qty  colon 15 LABEL "数量"
            site           colon 57 LABEL "地点"
            um             colon 15 LABEL "单位"
            location       colon 57 LABEL "库位"
            conv           colon 15
            lotserial      colon 57 LABEL "批/序号"
            reject_qty     colon 15 
            lotref         colon 57
            reject_um      colon 15
            multi_entry    colon 57
            reject_conv    colon 15
            chg_attr       colon 57
            tot_units      colon 57
            skip(1)
            rmks           colon 15
/*J040*/    close_wo       colon 40
            eff_date       colon 57
/*J040      close_wo       colon 15                          */
         with frame a side-labels width 80 THREE-D attr-space.

/*J04D*/ find first clc_ctrl no-lock no-error.
/*J04D*/ if not available clc_ctrl then do:
/*J04D*/    {gprun.i ""gpclccrt.p""}
/*J04D*/    find first clc_ctrl no-lock.
/*J04D*/ end.
/*J041*/ trans_ok = yes.

         find wo_mstr no-lock where recid(wo_mstr) = wo_recno.
/*J041*/ lotserial = "".
/*J041*/ lotnext   = "".
/*J041*/ newlot   = "".
/*J041*/ if wo_type = "E" or wo_type = "R" then do:
/*J041*/    wonbr = "".
/*J041*/    wolot = "".
/*J041*/    lotprcpt = no.
/*J041*/ end.
/*J041*/ else do:
/*J041*/    wonbr = wo_nbr.
/*J041*/    wolot = wo_lot.
/*J041*/    lotprcpt = wo_lot_rcpt.
/*J041*/ end.
/*J041*/ find pt_mstr where pt_part = wo_part no-lock no-error.

/*J1Z9*     wo_lot_next HOLDS THE LOT NUMBER FOR A PARTICULAR WORK ORDER.   */
/*J1Z9*     WHEN THE PARENT ITEM IS LOT CONTROLLED AND LOT GROUP IS BLANK,  */
/*J1Z9*     wo_lot_next SHOULD BE ASSIGNED THE WORK ORDER ID.               */

/*L0TJ*/    do transaction:
/*L0TJ*/       find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno
/*L0TJ*/       no-error.
/*J1Z9*/       if pt_auto_lot = yes and pt_lot_grp = " " then do:
/*J1Z9*/          if (wo_lot_next = "") then wo_lot_next =   wo_lot.
/*J1Z9*/       end. /* IF PT_AUTO_LOT = YES */
/*L0TJ*/    end. /* DO TRANSACTION */


/*J041*/ if (pt_lot_ser = "L") and
/*J041*/    (not pt_auto_lot or (index("ER", wo_type) > 0))
/*J041*/ then   lotserial = wo_lot_next.
/*J041*/ if (pt_lot_ser = "L" and pt_auto_lot = yes and
/*J041*/ pt_lot_grp <> "") and (index("ER",wo_type) = 0 )
/*J041*/ then do:
/*J041*/    find alm_mstr where alm_lot_grp = pt_lot_grp
/*J041*/    and alm_site = wo_site no-lock no-error.
/*J041*/    if not available alm_mstr then
/*J041*/    find alm_mstr where alm_lot_grp = pt_lot_grp
/*J041*/    and alm_site = "" no-lock no-error.
/*J041*/    if not available alm_mstr then do:
/*J041*/      {mfmsg.i 2737 3} /* LOT FORMAT RECORD DOES NOT EXIST */
/*J041*/      trans_ok = no.
/*J041*/      return.
/*J041*/    end.
/*J041*/    else do:
/*J041*/       if (search(alm_pgm) = ?) then do:
/*J069*/           ii = index(alm_pgm,".p").
/*J0F5* /*J069*/   almr = substring(alm_pgm, 1, 2) + "/"  */
/*J0F5*/           almr = global_user_lang_dir + "/"
/*J0F5*/                + substring(alm_pgm, 1, 2) + "/"
/*J069*/                + substring(alm_pgm,1,ii - 1) + ".r".
/*J069*/           if (search(almr)) = ? then do:
/*J041*/             {mfmsg02.i 2732 4 alm_pgm} /* AUTO LOT PROGRAM NOT FOUND */
/*J041*/             trans_ok = no.
/*J041*/             return.
/*J069*/           end.
/*J041*/       end.
/*J041*/    end.
/*J041*/    find first sr_wkfl where sr_userid = mfguser
/*J041*/    and sr_lineid = cline no-lock no-error.
/*J041*/    if available sr_wkfl then lotserial = sr_lotser.
/*J041*/    if newlot = "" then do:
/*J041*/       alm_recno = recid(alm_mstr).
/*J041*/       filename = "wo_mstr".
/*J041*/       if false then do:
/*J0F5* *****************************************************************
 * /*J041*/       {gprun0.i gpauto01.p "(input alm_recno,
 *                                       input wo_recno,
 *                                       input "filename",
 *                                       output newlot,
 *                                       output trans-ok)"
 *                 }
 *************************************************************************/
/*J0F5*/          {gprun.i ""gpauto01.p"" "(input alm_recno,
                                            input wo_recno,
                                            input "filename",
                                            output newlot,
                                            output trans-ok)"
                   }
/*J041*/       end.
/*J041*/       {gprun.i alm_pgm "(input alm_recno,
                                  input wo_recno,
                                  input "filename",
                                  output newlot,
                                  output trans-ok)"
               }
/*J041*/       if not trans-ok then do:
/*J041*/          {mfmsg.i 2737 3}  /* LOT FORMAT RECORD DOES NOT EXIST */
/*J041*/          trans_ok = no.
/*J041*/          return.
/*J041*/       end.
/*J041*/       lotserial = newlot.
/*J041*/       release alm_mstr.
/*J041*/    end.  /* NEWLOT = "" */
/*J041*/ end.  /* PT_LOT_SER = "L" */
/*J041*/    display lotserial with frame a.


         /* DISPLAY */
         mainloop:
         do on error undo, retry with frame a:
/*J069*  /*GM56*/    for each sr_wkfl exclusive    */
/*J069*/ /*GM56*/    for each sr_wkfl exclusive-lock
               where sr_userid = mfguser and sr_lineid = "":
               delete sr_wkfl.
            end.

            total_lotserial_qty = 0.
            nbr = wo_nbr.
            status input.

            open_ref = wo_qty_ord - wo_qty_comp - wo_qty_rjct.
            display wo_rmks open_ref /*J035*/ wo_batch with frame a.

/*J041***** find pt_mstr where pt_part = wo_part no-lock no-error.  */

            um = "".
            conv = 1.
            if available pt_mstr then do:
               um = pt_um.
               display pt_um pt_lot_ser pt_auto_lot with frame a.
            end.
            else do:
               display "" @ pt_um "" @ pt_lot_ser "" @ pt_auto_lot
               with frame a.
            end.

            prev_status = wo_status.
            prev_release = wo_rel_date.
            prev_due = wo_due_date.
            prev_qty = wo_qty_ord.

/*G782***** lotserial_qty = 0. */
/*G782*/    total_lotserial_qty = open_ref.
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

            setd:
            repeat on endkey undo mainloop, leave mainloop:
               site = "".
               location = "".
/*J041******** lotserial = "". ***/
               lotref = "".
               lotserial_qty = total_lotserial_qty.
/*G782*/       total_lotserial_qty = 0.
/*J12C         cline = "". */
/*J12C*/       if wo_joint_type <> "" and wo_joint_type <> "5"
/*J12C*/       then cline = "RCT" + wo_part.
/*J12C*/       else cline = "".

               global_part = wo_part.
               i = 0.
               for each sr_wkfl no-lock where sr_userid = mfguser
               and sr_lineid = cline:
                  i = i + 1.
                  if i > 1 then leave.
               end.
/*GA79******** if i = 0 and available pt_mstr then do:   */
/*GA79********    site = pt_site.                        */
/*GA79*/       if i = 0 then do:
/*GA79*/          assign
/*GA79*/             site = wo_site
/*GA79*/             location = wo_loc.
/*GA79*/          if location = "" and available pt_mstr then
                     location = pt_loc.
               end.
               else
               if i = 1 then do:
                  find first sr_wkfl where sr_userid = mfguser
                  and sr_lineid = cline no-lock.
                  site = sr_site.
                  location = sr_loc.
                  lotserial = sr_lotser.
                  lotref = sr_ref.
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

/*F190*/       locloop:
               do on error undo, retry on endkey undo mainloop, leave mainloop:
                  if available pt_mstr and pt_auto_lot then do:
/*J09C* /*J041*/             if pt_lot_grp = "" then lotserial = wo_lot.    */
/*J09C*/             if pt_lot_grp = "" then lotserial = wo_lot_next.
                     multi_entry = no.
                     display lotserial multi_entry lotref with frame a.
                     update lotserial_qty
                        um
                        conv
                        reject_qty
                        reject_um
                        reject_conv
                        site
                        location
/*J04D*                 lotref */
/*J3C2** /*J04D*/       lotref when (pt_lot_grp <> "")                       */
/*J3C2** /*J04D*/       multi_entry when (pt_lot_grp <> "")                  */
/*J3C2*/                /*lotref*/
/*J3C2*/                multi_entry
                        chg_attr
                        with frame a
                     editing:
                        global_site = input site.
                        global_loc = input location.
                        readkey.
                        apply lastkey.
                     end.
                  end.
                  else do:
                      DISPLAY lotref WITH FRAME a.
                      update lotserial_qty
                        um
                        conv
                        reject_qty
                        reject_um
                        reject_conv
                        site
                        location
                        lotserial
                       /* lotref */
                        multi_entry
                        chg_attr
                     with frame a editing:
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

                  if available pt_mstr then do:
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
/*G782                        conv = 1. */
/*G782*/                      reject_conv = 1.
                           end.
                           display reject_conv with frame a.
                        end.
                     end.

/*J041*   IF SINLE LOT PER WO RECEIPTS THEN VERIFY IF IT IS GOOD */
/*J041*/             if (lotprcpt = yes) and (pt_lot_ser = "L")
/*J04D*/             and (clc_lotlevel <> 0) then do:
/*J041*/                find first lot_mstr where lot_serial = lotserial
/*J041*/                   and lot_part = wo_part and lot_nbr = wo_nbr
/*J041*/                   and lot_line = wo_lot no-lock no-error.
/*J041*/                if available lot_mstr
/*J041*/                then do:
/*J041*/                   {mfmsg.i 2759 3}  /* LOT IS IN USED */
/*J041*/                   next-prompt lotserial with frame a.
/*J041*/                   undo, retry .
/*J041*/                end.
/*J041*/                find
/*J041*/                first lotw_wkfl where lotw_lotser = lotserial and
/*J041*/                lotw_mfguser <> mfguser and lotw_part <> pt_part
/*J041*/                no-lock no-error.
/*J041*/                if available lotw_wkfl then do:
/*J041*/                   {mfmsg.i 2759 3}  /* LOT IS IN USED */
/*J041*/                   next-prompt lotserial with frame a.
/*J041*/                   undo , retry .
/*J041*/                end.
/*J041*/             end.

                  end.   /* AVAILABLE PT_MSTR */

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
                        site = "".
                        location = "".
/*J041*                 lotserial = "".                           */
                        lotref = "".
                     end.
/*J041*/            if (lotprcpt = yes) then lotnext = lotserial.
/*F190               {gprun.i ""icsrup.p""}            */
/*J038*  /*F190*/    {gprun.i ""icsrup.p"" "(wo_site)"}           */
/*J038* ADDED INPUTS WO_NBR AND WO_LOT TO ICSRUP.P CALL           */
/*J04D*/             {gprun.i ""icsrup.p"" "(input wo_site,
                                             input wo_nbr,
                                             input wo_lot,
                                             input-output lotnext,
                                             input lotprcpt)"}
                  end.
                  else do:
/*J038*********** REPLACE ICEDIT.I WITH ICEDIT.P ******************/
/*J038*************  {icedit.i                  *******************/
/*J038*                 &transtype=""RCT-WO""                     */
/*J038*                 &site=site                                */
/*J038*                 &location=location                        */
/*J038*                 &part=global_part                         */
/*J038*                 &lotserial=lotserial                      */
/*J038*                 &lotref=lotref                            */
/*J038*                 &quantity="lotserial_qty * trans_conv"    */
/*J038*                 &um=trans_um                              */
/*J038*              }                                            */

/*J038*********************** CALL ICEDIT.P ***********************/
/*J35X*/             if lotserial_qty <> 0 then do:

/*J04D*/                {gprun.i ""icedit.p"" " (input transtype,
                                                 input site,
                                                 input location,
                                                 input global_part,
                                                 input lotserial,
                                                 input lotref,
                                                input (lotserial_qty * trans_conv),
                                                 input trans_um,
                                                 input wonbr,
                                                 input wolot,
                                                 output yn )" }
/*J038*/                if yn then undo locloop, retry.
/*J038*************** END OF BLOCK TO CALL ICEDIT.P ***************/

/*J35X*/             end. /* IF LOTSERIAL_QTY <> 0 */

/*F190*/             if wo_site <> site then do:
/*F0TC*/ /**** The following code has been replaced by icedit4.p which ****/
/*F0TC*/ /**** can be used in both multi line and single line mode.    ****/
/*F0TC*/ /*************************** Delete: Begin ***********************
/*F190*/                {gprun.i ""icedit3.p"" "(input ""RCT-WO"",
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
/*F190*/                if yn then undo locloop, retry.
 *
/*F190*/                {gprun.i ""icedit3.p"" "(input ""ISS-TR"",
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
/*F190*/                if yn then undo locloop, retry.
 *
/*F190*/                {gprun.i ""icedit3.p"" "(input ""RCT-TR"",
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

/*J038*/  /* ADDED input wonbr, input wolot, BELOW. DONE DURING 1/5/96 MERGE */
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

/*F190*/                   if yn then undo locloop, retry.
/*J35X*/                end. /* IF LOTSERIAL_QTY <> 0 */
/*F190*/             end.

/*G782*/             total_lotserial_qty = 0.
/*G782*/             for each sr_wkfl no-lock where sr_userid = mfguser
/*G782*/             and sr_lineid = cline:
/*G782*/                total_lotserial_qty = total_lotserial_qty + sr_qty.
/*G782*/             end.

                     find first sr_wkfl where sr_userid = mfguser
                     and sr_lineid = cline no-error.
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
                           sr_ref = lotref
                           sr_qty = lotserial_qty.
                           total_lotserial_qty = total_lotserial_qty
                                                + lotserial_qty.
                        end.
                     end.
                  end.

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

               end. /*LOCLOOP*/
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
/*GH30*/       if wo_qty_ord > 0 and
/*GH30*/       wo_qty_comp + (total_lotserial_qty * conv) < 0 then do:
/*GH30*/        {mfmsg.i 556 3}.
/*GH30*/        pause.
/*GH30*/        undo, retry.
/*GH30*/       end.
/*GH30*/       else
/*GH30*/       if wo_qty_ord < 0 and
/*GH30*/       wo_qty_comp + (total_lotserial_qty * conv) >  0 then do:
/*GH30*/        {mfmsg.i 556 3}.
/*GH30*/        pause.
/*GH30*/        undo, retry.
/*GH30*/       end.
**FN34*******************DELETED PRECEDING SECTION*************************/

/*G1YK*/       /* CHECK FOR lotserial_qty ENTERED */
/*FN34*/       if (wo_qty_ord > 0 and (wo_qty_comp
/*FN34*/          + (total_lotserial_qty * conv)
/*G1YK /*FN34*/   + (reject_qty * reject_conv)) < 0)         */
/*G1YK*/          ) < 0)
/*FN34*/       or (wo_qty_ord < 0 and (wo_qty_comp
/*FN34*/          + (total_lotserial_qty * conv)
/*G1YK /*FN34*/   + (reject_qty * reject_conv)) < 0)  */
/*G1YK*/          ) >  0)
/*FN34*/       then do:
/*FN34*/          {mfmsg.i 556 3}. /*REVERSE RCPT MAY NOT EXCEED PREV RCPT*/
/*FN34*/          reject_qty = 0.
/*FN34*/          undo, retry.
/*FN34*/       end.

/*G1YK*/       /* CHECK FOR reject_qty ENTERED */
/*G1YK*/       if (wo_qty_ord > 0 and (wo_qty_rjct
/*G1YK*/          + (reject_qty * reject_conv)) < 0)
/*G1YK*/       or (wo_qty_ord < 0 and (wo_qty_rjct
/*G1YK*/          + (reject_qty * reject_conv)) >  0)
/*G1YK*/       then do:
/*G1YK*/          {mfmsg.i 1373 3}. /*REVERSE SCRAP MAY NOT EXCEED PREV SCRAP*/
/*G1YK*/          reject_qty = 0.
/*G1YK*/          undo, retry.
/*G1YK*/       end.

               display tot_units with frame a.

/*J046*        if available pt_mstr then do   */
/*J046*/       if available pt_mstr and not jp then do
               on endkey undo mainloop, retry mainloop:
                  if eff_date = ? then eff_date = today.
/*J0QX*/          seta:
/*J0QX*/          do on error undo:
                    DISPLAY eff_date WITH  FRAME a.               
              update rmks close_wo /*eff_date*/ with frame a.

                  /* CHECK EFFECTIVE DATE */
/*H039*             {mfglef.i eff_date} */
/*J0QX* /*H039*/          {gpglef.i ""IC"" glentity eff_date} */
/*J0QX*/            find si_mstr where si_site = site no-lock.
/*J0QX*/              {gpglef1.i  &module = ""WO""
                        &entity = si_entity
                        &date = eff_date
                        &prompt = "eff_date"
                        &frame = "a"
                        &loop = "seta"
                      }
/*J0QX*/          end. /* seta */
               end.

/*J046*/       /* CLOSING FOR A SINGLE JOINT PRODUCT RECEIPT   */
/*J046*/       /* RESULTS IN CLOSING ALL RELATED JOINT PRODUCT */
/*J046*/       /* WORK ORDERS                                  */

/*J046*/       if jp then
/*J046*/       do on endkey undo setd, retry:
/*J046*/          if eff_date = ? then eff_date = today.
/*J0QX*/          setb:
/*J0QX*/          do on error undo:
/*J046*/           DISPLAY eff_date WITH FRAME a.
                 update rmks /*eff_date*/ close_wo with frame a.

/*J046*/          /* CHECK EFFECTIVE DATE */
/*J0QX* /*J046*/          {gpglef.i ""IC"" glentity eff_date} */
/*J0QX*/            find si_mstr where si_site = wo_site no-lock.
/*J0QX*/            {gpglef1.i  &module = ""WO""
                      &entity = si_entity
                      &date = eff_date
                      &prompt = "eff_date"
                      &frame = "a"
                      &loop = "setb"
                      }
/*J0QX*/           end. /* setb */
/*J046*/       end.
 UPDATE vendlot WITH FRAME xx.
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

               do on endkey undo mainloop, retry mainloop:
                  yn = yes.
                  {mfmsg01.i 359 1 yn}
                  /* Display lotserials being received ? */
                  if yn then do:
/*GO33*/ /*V8! hide frame a no-pause. */
                     for each sr_wkfl no-lock where sr_userid = mfguser
                     and sr_lineid = ""
                     with width 80:
                        display sr_site sr_loc sr_lotser
                        sr_ref
                        sr_qty.
                     end.
                  end.
               end.

               do on endkey undo mainloop, retry mainloop:
                  yn = yes.
/*GO33*/ /*V8-*/
                  {mfmsg01.i 12 1 yn} /* "Is all info correct?" */
/*GO33*/ /*V8+*/ /*V8! {mfgmsg10.i 12 1 yn } /* Is all info correct? */ */
/*G079*/          if yn then leave setd.
/*G079  /*F104            if yn then leave setd.  */                       */
/*G079  /*F104*/          if conv <> 1 then                                */
/*G079  /*F104*/          for each sr_wkfl where sr_userid = mfguser       */
/*G079  /*F104*/          and sr_lineid = "":                              */
/*G079  /*F104*/             sr_qty = sr_qty * conv.                       */
/*G079  /*F104*/          end.                                             */
/*G079  /*F104*/          total_lotserial_qty = total_lotserial_qty * conv.*/
/*G079  /*F104*/          leave setd.                                      */
               end.
            end.
            /*setd*/

/*G079*/    if conv <> 1 then
/*J069*  /*GM56*/       for each sr_wkfl exclusive where sr_userid = mfguser */
/*J069*/ /*GM56*/ for each sr_wkfl exclusive-lock where sr_userid = mfguser
/*G079*/       and sr_lineid = "":
/*G079*/          sr_qty = sr_qty * conv.
/*G079*/       end.
/*G079*/    total_lotserial_qty = total_lotserial_qty * conv.

            wo_qty_chg = total_lotserial_qty.
/*F104      wo_rjct_chg = reject_qty.  */
/*F104*/    wo_rjct_chg = reject_qty * reject_conv.

         end.
