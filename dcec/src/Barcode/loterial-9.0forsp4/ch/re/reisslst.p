/* GUI CONVERTED from reisslst.p (converter v1.75) Thu Mar 15 23:32:46 2001 */
/* reisslst.p - REPETITIVE   SUBPROGRAM TO MODIFY COMPONENT PART ISSUE LIST   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                       */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 12/16/94   BY: WUG *G09J*                */
/* REVISION: 7.3      LAST MODIFIED: 02/28/95   by: srk *G0FZ*                */
/* REVISION: 7.3      LAST MODIFIED: 03/14/95   BY: pcd *G0H8*                */
/* REVISION: 8.5      LAST MODIFIED: 05/11/95   by: sxb *J04D*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*                */
/* REVISION: 7.3      LAST MODIFIED: 08/24/95   BY: dzs *G0SY*                */
/* REVISION: 7.3      LAST MODIFIED: 02/05/96   BY: jym *G1G0*                */
/* REVISION: 8.5      LAST MODIFIED: 08/29/96   BY: *G2D9* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 12/31/96   BY: *H0Q8* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 02/03/98   BY: *J2DF* Viswanathan        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 08/26/98   BY: *L07B* Jean Miller        */
/* REVISION: 9.0      LAST MODIFIED: 07/20/00   BY: *M0Q3* Vandna Rohira      */
/* REVISION: 9.0      LAST MODIFIED: 12/12/00   BY: *L16J* Thomas Fernandes   */

/* TAKEN FROM reisrc01.p */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE reisslst_p_1 "���Ŵ���Ʒ"
/* MaxLen: Comment: */

&SCOPED-DEFINE reisslst_p_2 "�ο�"
/* MaxLen: Comment: */

&SCOPED-DEFINE reisslst_p_3 "��ȱ��"
/* MaxLen: Comment: */

&SCOPED-DEFINE reisslst_p_4 "�ص�"
/* MaxLen: Comment: */

&SCOPED-DEFINE reisslst_p_5 "��"
/* MaxLen: Comment: */

&SCOPED-DEFINE reisslst_p_6 " �������ݲ鿴 "
/* MaxLen: Comment: */

&SCOPED-DEFINE reisslst_p_7 "���¼"
/* MaxLen: Comment: */

&SCOPED-DEFINE reisslst_p_8 "����"
/* MaxLen: Comment: */

&SCOPED-DEFINE reisslst_p_9 "����������"
/* MaxLen: Comment: */

&SCOPED-DEFINE reisslst_p_10 "����������"
/* MaxLen: Comment: */

&SCOPED-DEFINE reisslst_p_11 "ȡ��Ƿ����"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*G2D9*/ {wndvar2.i "new shared"}

         define input parameter cumwo_lot as character.
         define input parameter wopart as character.
         define input parameter wosite as character.
         define input parameter eff_date as date.
         define input parameter wkctr as character.
         define input parameter qty_comp as decimal.
         define output parameter undo_stat like mfc_logical no-undo.

         define new shared variable parent_assy like pts_par.
         define new shared variable part like wod_part.
         define new shared variable wopart_wip_acct like pl_wip_acct.
         define new shared variable wopart_wip_cc like pl_wip_cc.
         define new shared variable site like sr_site no-undo.
         define new shared variable location like sr_loc no-undo.
         define new shared variable lotserial like sr_lotser no-undo.
         define new shared variable lotref like sr_ref format "x(8)" no-undo.
         define new shared variable lotserial_qty like sr_qty no-undo.
         define new shared variable  multi_entry as logical
            label {&reisslst_p_7} no-undo.
         define new shared variable lotserial_control as character.
         define new shared variable cline as character.
         define new shared variable row_nbr as integer.
         define new shared variable col_nbr as integer.
         define new shared variable issue_or_receipt as character
            initial {&reisslst_p_8}.
         define new shared variable total_lotserial_qty like wod_qty_chg.
         define new shared variable wo_recid as recid.
         define new shared variable pk_recno as recid.
         define new shared variable comp like ps_comp.
         define new shared variable fill_all like mfc_logical
            label {&reisslst_p_10} initial no.
         define new shared variable fill_pick like mfc_logical
            label {&reisslst_p_9} initial yes.
         define new shared variable trans_um like pt_um.
         define new shared variable trans_conv like sod_um_conv.
         define new shared variable transtype as character.

/*G2D9*/ define variable wfirst as logical no-undo initial yes.
         define variable nbr like wo_nbr.
         define variable qopen like wod_qty_all label {&reisslst_p_3}.
         define variable yn like mfc_logical.
         define variable ref like glt_ref.
         define variable desc1 like pt_desc1.
/*G2D9*  define variable i as integer. */
         define variable trqty like tr_qty_chg.
         define variable trlot like tr_lot.
         define variable qty_left like tr_qty_chg.
         define variable del-yn like mfc_logical initial no.
/*G2D9*  define variable j as integer. */
         define variable tot_lad_all like lad_qty_all.
         define variable ladqtychg like lad_qty_all.
         define variable sub_comp like mfc_logical label {&reisslst_p_1}.
/*J04T   define variable firstpass like mfc_logical. */
         define variable cancel_bo like mfc_logical label {&reisslst_p_11}.
         define variable default_cancel like cancel_bo.
         define variable ptum like pt_um no-undo.
         define variable iss_loc like pk_loc.
         define variable rejected like mfc_logical.
         define variable op like wod_op.

/*J04T*/ define variable lotnext like wo_lot_next.
/*J04T*/ define variable lotprcpt like wo_lot_rcpt no-undo.

/*L16J*/ define variable l_error like mfc_logical  no-undo.

         define buffer ptmstr for pt_mstr.
 DEFINE VAR mavailable_qty AS INT.
           DEFINE VAR mremain_qty AS INT.
/*G2D9* * * BEGIN DELETE SECTION *
.         form
.         with frame c 5 down no-attr-space width 80 title
./*G1G0*/ color normal
.         " Issue Data Input ".
**G2D9* * * END DELETED SECTION */

         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part           colon 13 LABEL "�������"
            op          LABEL "����"
            wosite         colon 58 label {&reisslst_p_4}
            pt_desc1       colon 13 LABEL "�������"
            location       colon 58 label {&reisslst_p_5}
            pt_desc2       colon 13 no-label
            lotserial      colon 58 LABEL "��/���"
            lotserial_qty  colon 13 LABEL "����"
            pt_um          no-label
            lotref         colon 58 LABEL "�ο�"
            sub_comp       colon 13
            multi_entry    colon 58
          SKIP(.4)  /*GUI*/
with
/*G2D9*/ overlay
         frame d side-labels width 80 attr-space
/*G2D9*/ row 14 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/


         undo_stat = yes.
/*L16J*/ assign
/*L16J*/    site    = wosite
            iss_loc = "".

         if can-find (loc_mstr where loc_loc = wkctr and loc_site = wosite)
         then iss_loc = wkctr.

/*J04T*/ find first clc_ctrl no-lock no-error.
/*J04T*/ if not available clc_ctrl then do:
/*J04T*/    {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04T*/    find first clc_ctrl no-lock no-error.
/*J04T*/ end.

         do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

/*G09J*/    /*ADDED EXCLUSIVE TO FOLLOWING*/
            for each sr_wkfl exclusive-lock where sr_userid = mfguser
            and sr_lineid begins "-":
               delete sr_wkfl.
            end.
 
            for each pk_det where pk_user = mfguser:
/*GUI*/ if global-beam-me-up then undo, leave.


/*H0Q8* * * BEGIN DELETE SECTION *
./*G1G0*/  if iss_loc <> "" then pk_loc = iss_loc.
./*G1G0*/  else do:
./*G1G0*/    find pt_mstr where pt_part = pk_part no-lock no-error.
./*G1G0*/    if available pt_mstr then pk_loc = pt_loc.
./*G1G0*/  end.
.*H0Q8* * * END DELETE SECTION */
         mavailable_qty = 0.
         cline = "-" + string(pk_part,"x(18)")
                                          + pk_reference.
                                      FOR EACH ld_det WHERE ld_part = pk_part AND ld_site = wosite AND ld_LOC = pk_loc BY  ld_lot:
                                       mavailable_qty = mavailable_qty + ld_qty_oh.

                                      END.
                                      IF mavailable_qty >= pk_qty THEN DO:

                                      mremain_qty = pk_qty.

                                      FOR EACH ld_det WHERE ld_part = pk_part AND ld_site = wosite AND ld_LOC = pk_loc AND ld_qty_oh > 0 BY ld_date BY ld_lot BY ld_ref :

                                        IF ld_qty_oh >= mremain_qty THEN DO:

                                            CREATE sr_wkfl.
                                            sr_userid = mfguser.
                                            sr_lineid = cline.
                                            sr_site = wosite.
                                            sr_loc = pk_loc.
                                            sr_lotser = ld_lot.
                                            sr_ref = ld_ref.
                                            sr_qty = mremain_qty.
                                            mremain_qty = 0.
                                            LEAVE.



                                            END.
                                        ELSE DO:

                                            CREATE sr_wkfl.
                                            sr_userid = mfguser.
                                            sr_lineid = cline.
                                            sr_site = wosite.
                                            sr_loc = pk_loc.
                                            sr_lotser = ld_lot.
                                            sr_ref = ld_ref.
                                            sr_qty =ld_qty_oh.
                                            mremain_qty = mremain_qty - sr_qty.



                                         END.


                                        END.
                                      END.
                                      ELSE DO:
                                       MESSAGE  pk_part ' ' pk_loc ' ' "��ǰ��λ�������������س�!" view-AS ALERT-BOX  error BUTTONS OK.                                  
                                          
                                        /* LEAVE.*/
                                          END.
                                          
              find FIRST sr_wkfl where sr_userid = mfguser
               and sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference
               and sr_site = wosite
               and sr_loc = pk_loc no-error.
               
               find ptmstr where ptmstr.pt_part = pk_part no-lock.
               
/*J04T*/       /*ADD BLANKS FOR TRNBR AND TRLINE INPUT PARAMTERS */
               {gprun.i ""icedit2.p"" "(input ""ISS-WO"",
                                        input wosite,
                                        input pk_loc,
                                        input ptmstr.pt_part,
                                        input """",
                                        input """",
                                        input pk_qty + if available sr_wkfl
                                                       then sr_qty else 0,
                                        input ptmstr.pt_um,
                                        input """",
                                        input """",
                                        output rejected)"
               }
               
/*GUI*/ if global-beam-me-up then undo, leave.


               if rejected then do on endkey undo , retry:
                  {mfmsg02.i 161 2 ptmstr.pt_part}
               end.

               if not available sr_wkfl then do:
                  create sr_wkfl.

                  assign
                  sr_userid = mfguser
                  sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference
                  sr_site = wosite
                  sr_loc = pk_loc.
              

               sr_qty = sr_qty + pk_qty. 
               end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.


         seta:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

            do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               setd:
               repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

/*G2D9* * * BEGIN DELETED SECTION
.                  form
.                     pk_part
.                     pk_reference   column-label "Op"
.                     pk_qty         label "Qty to Iss"
.                  with frame c 5 down no-attr-space width 80.
.
.                  view frame c.
**G2D9* * * END DELETED SECTION */
                  clear frame d.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
                  view frame d.

/*J04T*/          select-part:
                  repeat on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.

/*G2D9*           with frame c:  */
                     if batchrun = no then do:
/*G2D9* * * BEGIN ADD SECTION */

/*J2DF*/                for first pk_det exclusive-lock where pk_user = mfguser:
/*J2DF*/                end.

                        {gprun.i ""reisssw.p"" "(wfirst)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                        wfirst = no.
                        pk_recno = window_recid.

/*G2D9* * * END ADD SECTION */
/*G2D9* * * BEGIN DELETE SECTION * * *
.                        {swindowa.i
.                        &file=pk_det
.                        &framename="c"
.                        &record-id=pk_recno
.                        &search=pk_user
.                        &equality=mfguser
.                        &scroll-field=pk_part
.                        &update-leave=yes
.                        &display1=pk_part
.                        &display2=pk_reference
.                        &display3=pk_qty
.                        }
**G2D9* * * END DELETE SECTION */

                     end.
/*GUI*/ if global-beam-me-up then undo, leave.


                     if keyfunction(lastkey) = "END-ERROR":U then leave.
                     clear frame d.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.

                     do on error undo , retry with frame d:
/*GUI*/ if global-beam-me-up then undo, leave.

                        part = "".
                        op = 0.

                        if pk_recno <> ? then do:
                           find pk_det no-lock
                           where recid(pk_det) = pk_recno no-error.

                           if available pk_det
                           then do:
                              assign
                              op = integer(pk_reference)
                              part = pk_part.
                           end.
                        end.

                        display part op.
                        find pt_mstr no-lock where pt_part = part no-error.
                        if available pt_mstr then
                        display
                           pt_desc1
                           pt_desc2.
                        else
                        display
                           "" @ pt_desc1
                           "" @ pt_desc2.

                        trans_um = "".
                        if available pt_mstr then trans_um = pt_um.
                        trans_conv = 1.

                        input clear.

                        get-part:
                        do on error undo , retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                           set part op with frame d editing:
                              if frame-field = "part" then do:
                                 {mfnp01.i pk_det part pk_part
                                           mfguser pk_user pk_det}

                                 if recno <> ? then do:
                                    part = pk_part.
                                    op = integer(pk_reference).
                                    display part op with frame d.
                                    find pt_mstr where pt_part = part
                                    no-lock no-error.

                                    if available pt_mstr then do:
                                       display pt_um pt_desc1 pt_desc2
                                       with frame d.
                                    end.
                                 end.
                              end.
                              else do:
                                 ststatus = stline[3].
                                 status input ststatus.
                                 readkey.
                                 apply lastkey.
                              end.
                           end.

                           find wr_route where wr_lot = cumwo_lot
                           and wr_op = op no-lock no-error.

                           if not available wr_route then do:
                              {mfmsg.i 106 3}
                              next-prompt op.
                              undo, retry.
                           end.

                           status input.

                           if part = "" then leave.
/*J04T                     firstpass = yes.          */
                           frame-d-loop:
                           repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

                              pause 0.
                              sub_comp = no.
                              multi_entry = no.

                              find first pk_det where pk_user = mfguser
                              and pk_part = part
                              and pk_reference = string(op)
                              no-error.

                              if not available pk_det then do:
/*J04T*                          {mfmsg.i 517 2} /* COMP DOESN'T EXIST ON WO*/*/
/*J04T*/                         if clc_comp_issue then do:
/*J04T*/                            /*ITEM DOES NOT EXIST ON THIS BILL OF MATL*/
                                    {mfmsg.i 547 2} /* WARNING ONLY */
/*J04T*/                         end.
/*J04T*/                         else do:
/*J04T*/                            /*COMPLIANCE MODULE RESTRICTS COMP ISSUE*/
/*J04T*/                            /*ITEM DOES NOT EXIST ON THIS BILL OF MATL*/
/*J04T*/                            {mfmsg.i 547 3} /* ERROR */
/*J04T*/                            undo select-part, retry.
/*J04T*/                         end.

                                 create pk_det.
                                 assign
                                 pk_user = mfguser
                                 pk_part = part
                                 pk_reference = string(op).
                              end.

                              find pt_mstr where pt_part = part
                              no-lock no-error.

                              if not available pt_mstr then do:
                                 {mfmsg.i 16 3}
                                 undo get-part , retry get-part.

                                 display
                                 part " " @ pt_um
                                 " " @ pt_desc1
                                 " " @ pt_desc2
                                 with frame d.
                                 ptum = "".
                              end.
                              else do:
                                 if new pk_det then assign pk_loc = pt_loc.
                                 if iss_loc <> "" then pk_loc = iss_loc.
/*G1G0*/                         else pk_loc = pt_loc.

                                 display pt_part @ part pt_um pt_desc1 pt_desc2
                                 with frame d.

                                 ptum = pt_um.
                              end.

                              qopen = pk_qty.
                              lotserial_control = "".

                              if available pt_mstr
                                 then lotserial_control = pt_lot_ser.
                              location = "".
                              lotserial = "".
                              lotref = "".
                              lotserial_qty = pk_qty.
                              cline = "-" + string(pk_part,"x(18)")
                                          + pk_reference.
                              global_part = pk_part.

                              find first sr_wkfl where sr_userid = mfguser
                              and sr_lineid = cline no-lock no-error.

                              if available sr_wkfl then do:
                                 find sr_wkfl where sr_userid = mfguser
                                 and sr_lineid = cline no-lock no-error.

                                 if available sr_wkfl then do:
                                    wosite = sr_site.
                                    location = sr_loc.
                                    lotserial = sr_lotser.
                                    lotref = sr_ref.
                                 end.

                                 else multi_entry = yes.
                              end.
                              else do:
                                 location = pk_loc.
                              end.

                              do on error undo, retry
/*J04T                        on endkey undo , leave:    */
/*J04T*/                      on endkey undo select-part, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                                 pk_recno = recid(pk_det).
                                 /* multi_entry = yes.*/
                                 DISPLAY  wosite location multi_entry WITH FRAME d.
                                 update lotserial_qty sub_comp
                                 wosite location lotserial lotref multi_entry
                                 with frame d editing:
                                    global_site = input wosite.
                                    global_loc = input location.
                                    global_lot = input lotserial.
                                    ststatus = stline[3].
                                    status input ststatus.
                                    readkey.
                                    apply lastkey.
                                 end.

                                 if sub_comp then do:
                                    if can-find (first pts_det where
                                    pts_part = pk_part and pts_par = "")
                                    or can-find (first pts_det where
                                     pts_part = pk_part and pts_par = wopart)
                                    then do:

/*G0H8                                 {gprun.i ""resumt.p""}    */
/*G0H8*/                               find wo_mstr where wo_lot = cumwo_lot
/*G0H8*/                               no-lock.
/*G0H8*/                               {gprun.i ""resumt1.p"" "(input wo_part)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                                       if keyfunction(lastkey) = "END-ERROR":U
                                       then undo , retry.

                                       find pt_mstr where pt_part = part
                                       no-lock no-error.

                                       if not available pt_mstr then do:
                                          {mfmsg.i 16 3}
                                          undo seta , retry seta.
                                       end.

                                       find pk_det where pk_user = mfguser
                                       and pk_part = part
                                       no-error.

                                       if not available pk_det then do:
                                          create pk_det.
                                          assign
                                          pk_user = mfguser
                                          pk_part = part
                                          pk_reference = string(op).

                                          if iss_loc <> ""
                                          then pk_loc = iss_loc.
                                          else pk_loc = pt_loc.
                                       end.

                                       pk_qty = pk_qty + lotserial_qty.

                                       find sr_wkfl where sr_userid = mfguser
                                       and sr_lineid = cline
                                       and sr_site = wosite
                                       and sr_loc = pk_loc
                                       and sr_lotser = ""
                                       and sr_ref = ""
                                       no-error.

                                       if not available sr_wkfl then do:
                                          create sr_wkfl.

                                          assign
                                          sr_userid = mfguser
                                          sr_lineid = cline
                                          sr_site = wosite
                                          sr_loc = pk_loc.
                                       end.

                                       sr_qty = sr_qty + lotserial_qty.
                                       next frame-d-loop.
                                    end.

                                    else do with frame d:
                                       {mfmsg.i 545 3}
                                       next-prompt sub_comp.
                                       undo , retry.
                                    end.
                                 end.


                                 if can-find (first sr_wkfl
                                              where sr_userid = mfguser
                                                and sr_lineid = cline)
                                 and not can-find (sr_wkfl
                                                   where sr_userid = mfguser
                                                     and sr_lineid = cline)
                                 then multi_entry = yes.

                                 total_lotserial_qty = pk_qty.

                                 if multi_entry then do:
                                    pk_qty = lotserial_qty.
                                    transtype = "ISS-WO".
/*J04D*/                            lotnext = lotserial.
/*J04D*/                            lotprcpt = no.

/*M0Q3*/                            if available pt_mstr then
/*M0Q3*/                               trans_um = pt_um.

/*J04T*/                            /* ADDED BLANKS FOR INPUTS TRNBR AND  */
/*J04T*/                            /* TRLINE TO ICSRUP.P CALL BELOW      */
/*J04T*                             {gprun.i ""icsrup.p"" "(input wosite)"} */
/*J04T*/                            {gprun.i ""icsrup.p"" "(input wosite,
                                                            input """",
                                                            input """",
                                                           input-output lotnext,
                                                            input lotprcpt)"
                                    }
/*GUI*/ if global-beam-me-up then undo, leave.

                                 end.
                                 else do:

/*J04T******************* CHANGED ICEDIT.I TO ICEDIT.P **********************
 *                                  {icedit.i
 *                                  &transtype=""ISS-WO""
 *                                  &site=wosite
 *                                  &location=location
 *                                  &part=global_part
 *                                  &lotserial=lotserial
 *                                  &lotref=lotref
 *                                  &quantity=lotserial_qty
 *                                  &um=ptum}
**J04T**********************************************************************/

/*G0SY*/                  if lotserial_qty <> 0 then do:
/*J04T*/                            {gprun.i ""icedit.p"" "(input ""ISS-WO"",
                                                            input wosite,
                                                            input location,
                                                            input global_part,
                                                            input lotserial,
                                                            input lotref,
                                                            input lotserial_qty,
                                                            input ptum,
                                                            input """",
                                                            input """",
                                                            output rejected)"
                                    }
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04T*/                            if rejected then undo, retry.
/*G0SY*/                  end.

                                    find first sr_wkfl
                                       where sr_userid = mfguser
                                       and sr_lineid = cline
                                    exclusive-lock no-error.

                                    if lotserial_qty = 0 then do:

                                       if available sr_wkfl then do:
                                          total_lotserial_qty =
                                             total_lotserial_qty - sr_qty.
                                          sr_qty = 0.
                                       end.
                                    end.
                                    else do:
                                       if not available sr_wkfl then do:
                                          create sr_wkfl.
                                          assign
                                          sr_userid = mfguser
                                          sr_lineid = cline.
                                       end.

                                       assign
                                       total_lotserial_qty = lotserial_qty
                                       sr_site = wosite
                                       sr_loc = location
                                       sr_lotser = lotserial
                                       sr_ref = lotref
                                       sr_qty = lotserial_qty.
                                    end.
                                 end.

                                 pk_qty = total_lotserial_qty.
/*H0Q8*/                         if lotserial_qty <> 0 then do:
/*H0Q8*/                           {gprun.i ""reoptr1f.p""
                                     "(input pk_part,
                                       output yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0Q8*/                           if yn then undo, retry.
/*H0Q8*/                         end.
                              end.
/*GUI*/ if global-beam-me-up then undo, leave.


                              leave.
                           end.
/*GUI*/ if global-beam-me-up then undo, leave.

                        end.
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.
/*GUI*/ if global-beam-me-up then undo, leave.



                  repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

                     yn = yes.
                     {mfmsg01.i 636 1 yn}

                     if yn = yes then do:
/*G2D9*                 hide frame c no-pause. */
                        hide frame d no-pause.
/*G0SY*/                FORM /*GUI*/ 
/*G0SY*/                with frame e down width 80 title
/*G1G0*/                color normal
                        {&reisslst_p_6} THREE-D /*GUI*/.


/*L07B*                 for each pk_det no-lock where pk_user = mfguser, */
/*L07B*                 each sr_wkfl no-lock where sr_userid = mfguser   */
/*L07B*/                for each pk_det no-lock where pk_user = mfguser:

/*L07B*/                   for each sr_wkfl no-lock where sr_userid = mfguser
                           and sr_lineid =
                              "-" + string(pk_part,"x(18)") + pk_reference
                           and sr_qty <> 0
/*G0SY*                    with frame e width 80 title " Issue Data Review ": */
/*G0SY*/                   with frame e:

                              display
                                 pk_part
                                 sr_site
                                 sr_loc
                                 sr_lotser
                                 sr_ref format "x(8)"
                                    column-label {&reisslst_p_2}
                                 sr_qty.
/*G0SY*/                      down.
                           end.
/*L07B*/                end.
                        view frame e.

                     end.

                     leave.

                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat */

                  do on endkey undo seta , leave seta:
                     yn = yes.
/*G0FZ*/ /*V8+*/
/*G0FZ*/             {mfgmsg10.i 12 1 yn}
                     if yn = ? then undo seta, leave seta.   
                  end.

                  if yn then do:

/*L16J*/             /* BEGIN ADD SECTION */
/*L16J*/             /* ADDED A CALL TO icedit4.p AS ALL THE VALIDATIONS OF */
/*L16J*/             /* icedit4.p WERE SKIPPED IF THE USER ACCEPTED THE     */
/*L16J*/             /* DEFAULTS AND EXITED (F4) NOT PROCESSING THE         */
/*L16J*/             /* INDIVIDUAL LINES.                                   */

                     l_error = no.

                     for each pk_det fields(pk_loc       pk_part pk_qty
                                            pk_reference pk_user)
                        where pk_user = mfguser
                        no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

                        for each sr_wkfl fields
                           (sr_userid sr_lineid sr_site
                            sr_loc    sr_lotser sr_ref
                            sr_qty)
                           where sr_userid = pk_user
                             and sr_lineid = "-" + string(pk_part,"x(18)")
                                                 + pk_reference
                             and sr_qty    <> 0.00
                           no-lock:

                           for first pt_mstr
                               fields(pt_desc1 pt_desc2 pt_loc pt_lot_ser
                                      pt_part  pt_um)
                               where pt_part = pk_part no-lock:
                           end. /* FOR FIRST pt_mstr ... */

                           ptum = "".
                           if available(pt_mstr) then
                              ptum = pt_um.

                           if (site <> sr_site) then do:
                              {gprun.i ""icedit4.p""
                                       "(input ""ISS-WO"",
                                         input site,
                                         input sr_site,
                                         input pt_loc,
                                         input sr_loc,
                                         input trim(substring(sr_lineid,2,18)),
                                         input sr_lotser,
                                         input sr_ref,
                                         input sr_qty,
                                         input ptum,
                                         input """",
                                         input """",
                                         output yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                              if yn then do:
                                 l_error = yes.

                                 /* FOR ITEM/SITE/LOCATION: #/#/#/# */
                                 {mfmsg03.i 4578 1
                                            trim(substring(sr_lineid,2,18))
                                            sr_site
                                            sr_loc
                                            sr_lotser}
                              end. /* IF yn     */
                           end. /* IF (site <> sr_site) */
                        end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH sr_wkfl */
                     end. /* FOR EACH pk_det */

                     if l_error then
                        undo seta, retry seta.
/*L16J*/ /* END ADD SECTION */

/*L07B*              for each pk_det no-lock where pk_user = mfguser, */
/*L07B*              each sr_wkfl no-lock where sr_userid = mfguser   */
/*L07B*/             for each pk_det no-lock where pk_user = mfguser:
/*GUI*/ if global-beam-me-up then undo, leave.


/*L07B*/                for each sr_wkfl no-lock where sr_userid = mfguser
                        and sr_lineid = "-" + string(pk_part,"x(18)")
                                            + pk_reference
                        and sr_qty <> 0:
/*GUI*/ if global-beam-me-up then undo, leave.


                           find pt_mstr no-lock where pt_part = pk_part no-error.

/*J04T*/                   /*ADD BLANKS FOR TRNBR AND TRLINE INPUT PARAMTERS */
                           {gprun.i ""icedit2.p"" "(""ISS-WO"",
                                                    sr_site,
                                                    sr_loc,
                                                    pk_part,
                                                    sr_lotser,
                                                    sr_ref,
                                                    sr_qty,
                                                    pt_um,
                                                    input """",
                                                    input """",
                                                    output rejected)"
                           }
/*GUI*/ if global-beam-me-up then undo, leave.


                           if rejected then do:
/*G09J*/                      /*CHANGED WARNING TO ERROR IN FOLLOWING*/
                              {mfmsg02.i 161 3 pk_part} /* UNABLE TO ISSUE OR
                                                           RECEIVE FOR ITEM */
                              next setd.
                           end.

                        end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* for each sr_wkfl */
/*L07B*/             end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* for eack pk_det */

/*G2D9*              hide frame c. */
                     hide frame d.
                     hide frame e.
                     undo_stat = no.
                     leave seta.

                  end.
/*GUI*/ if global-beam-me-up then undo, leave.


               end.
/*GUI*/ if global-beam-me-up then undo, leave.


            end.

         end.

         hide frame d.
/*G2D9*  hide frame c. */
