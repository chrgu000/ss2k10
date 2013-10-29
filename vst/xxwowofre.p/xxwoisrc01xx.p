/* woisrc01.p - WORK ORDER ISSUE WITH SERIAL NUMBERS                    */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*N014*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 6.0     LAST MODIFIED: 05/24/90    BY: emb                 */
/* REVISION: 6.0     LAST MODIFIED: 12/17/90    BY: wug *D619*          */
/* REVISION: 6.0     LAST MODIFIED: 04/22/91    BY: wug *D563*          */
/* REVISION: 6.0     LAST MODIFIED: 06/06/91    BY: ram *D666*          */
/* REVISION: 6.0     LAST MODIFIED: 09/18/91    BY: wug *D858*          */
/* REVISION: 6.0     LAST MODIFIED: 10/03/91    BY: alb *D887*          */
/* REVISION: 7.0     LAST MODIFIED: 10/23/91    BY: pma *F003*          */
/* REVISION: 6.0     LAST MODIFIED: 11/08/91    BY: wug *D920*          */
/* REVISION: 6.0     LAST MODIFIED: 12/04/91    BY: ram *D954*          */
/* REVISION: 7.0     LAST MODIFIED: 01/28/92    BY: pma *F104*          */
/* REVISION: 7.0     LAST MODIFIED: 02/12/92    BY: pma *F190*          */
/* REVISION: 7.3     LAST MODIFIED: 09/30/92    BY: ram *G115*          */
/* REVISION: 7.3     LAST MODIFIED: 10/21/92    BY: emb *G216*          */
/* REVISION: 7.3     LAST MODIFIED: 09/27/93    BY: jcd *G247*          */
/* REVISION: 7.3     LAST MODIFIED: 02/08/93    BY: emb *G656*          */
/* REVISION: 7.3     LAST MODIFIED: 03/04/93    BY: ram *G782*          */
/* REVISION: 7.3     LAST MODIFIED: 07/06/93    BY: pma *GD11*          */
/* REVISION: 7.3     LAST MODIFIED: 08/18/93    BY: pxd *GE21*          */
/* REVISION: 7.3     LAST MODIFIED: 04/11/94    BY: ais *FM98*          */
/* REVISION: 7.3     LAST MODIFIED: 07/14/94    BY: pxd *GK74*          */
/* REVISION: 7.2     LAST MODIFIED: 09/08/94    BY: ais *FQ57*          */
/* REVISION: 7.3     LAST MODIFIED: 09/09/94    BY: qzl *GM01*          */
/* REVISION: 7.3     LAST MODIFIED: 09/22/94    BY: jpm *GM78*          */
/* REVISION: 8.5     LAST MODIFIED: 10/28/94    BY: tmf *J040*          */
/* REVISION: 8.5     LAST MODIFIED: 11/10/94    BY: taf *J038*          */
/* REVISION: 7.3     LAST MODIFIED: 12/11/94    BY: qzl *GO84*          */
/* REVISION: 7.3     LAST MODIFIED: 12/18/94    BY: qzl *F09T*          */
/* REVISION: 7.3     LAST MODIFIED: 01/18/95    BY: ais *F0F2*          */
/* REVISION: 7.3     LAST MODIFIED: 02/06/95    BY: pxd *F0H6*          */
/* REVISION: 7.2     LAST MODIFIED: 02/28/95    BY: ais *F0KS*          */
/* REVISION: 8.5     LAST MODIFIED: 03/08/95    BY: dzs *J046*          */
/* REVISION: 7.2     LAST MODIFIED: 03/07/95    BY: ais *F0LX*          */
/* REVISION: 7.3     LAST MODIFIED: 03/15/95    BY: pxe *F0N7*          */
/* REVISION: 7.3     LAST MODIFIED: 04/13/95    by: srk *G0KT*          */
/* REVISION: 8.5     LAST MODIFIED: 04/18/95    BY: sxb *J04D*          */
/* REVISION: 8.5     LAST MODIFIED: 08/04/95    BY: tjs *J060*          */
/* REVISION: 7.2     LAST MODIFIED: 08/17/95    BY: qzl *F0TC*          */
/* REVISION: 7.3     LAST MODIFIED: 08/24/95    by: dzs *G0SY*          */
/* REVISION: 8.5     LAST MODIFIED: 10/02/95    BY: tjs *J082*          */
/* REVISION: 7.3     LAST MODIFIED: 12/15/95    by: rvw *G1FL*          */
/* REVISION: 8.5  LAST MODIFIED: 05/13/96 BY: *G1TT* Julie Milligan     */
/* REVISION: 8.5  LAST MODIFIED: 08/29/96 BY: *G2D9* Julie Milligan     */
/* REVISION: 7.3  LAST MODIFIED: 10/03/96 BY: *G2GD* Murli Shastri      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *K20B* G.Latha          */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *M0L8* Jyoti Thatte     */
/* REVISION: 9.1      LAST MODIFIED: 05/19/00   BY: *L0XY* Vandna Rohira    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L3* Arul Victoria    */
/* REVISION: 9.1      LAST MODIFIED: 12/12/00   BY: *L16J* Thomas Fernandes */
/*ADM*                               07/13/04   by: *ADM*  Heshiyu          */

/*ss-20121226.1 by Steven*/


         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woisrc01_p_2 "Backflush Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc01_p_3 "Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc01_p_4 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc01_p_5 "Cancel B/O"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc01_p_6 "Issue Alloc"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc01_p_7 "Issue Picked"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc01_p_8 "Loc"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc01_p_10 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc01_p_11 "Qty Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc01_p_12 "Substitute"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*N0L3* ------------------- BEGIN DELETE ----------------------- *
 *
 * &SCOPED-DEFINE woisrc01_p_1 "Issue"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE woisrc01_p_9 " Issue Data Review "
 * /* MaxLen: Comment: */
 *
 *N0L3* ------------------- END   DELETE ----------------------- */

/*G2D9*/ {wndvar2.i "new shared"}

/*F104*************************************************************/
/*       Since this program does not allow UM conversion,         */
/*       sr_qty, its dependancies, wo_qty_chg, and wo_rjct_chg    */
/*       are stated in STOCKING UM.  If Um conversion is ever     */
/*       added, the above variables must remain stated in the     */
/*       stock units of measure.                                  */
/*F104*************************************************************/

         define shared variable wo_recno as recid.
         define shared variable eff_date like glt_effdate.
/*       define shared variable mfguser as character.           *G247* */
/*G0KT*/ define shared variable outta_here as logical no-undo.

         define new shared variable part like wod_part.
         define new shared variable wopart_wip_acct like pl_wip_acct.
/*N014*/ define new shared variable wopart_wip_sub  like pl_wip_sub .
         define new shared variable wopart_wip_cc like pl_wip_cc.
         define new shared variable site like sr_site no-undo.
         define new shared variable location like sr_loc no-undo.
         define new shared variable lotserial like sr_lotser no-undo.
         define new shared variable lotserial_qty like sr_qty no-undo.
         define new shared variable multi_entry as logical
            label {&woisrc01_p_4} no-undo.
         define new shared variable lotserial_control as character.
         define new shared variable cline as character.
         define new shared variable row_nbr as integer.
         define new shared variable col_nbr as integer.
         define new shared variable total_lotserial_qty like wod_qty_chg.
         define new shared variable wo_recid as recid.
         define new shared variable wod_recno as recid.
         define new shared variable fill_all like mfc_logical
            label {&woisrc01_p_6} initial no.
         define new shared variable fill_pick like mfc_logical
            label {&woisrc01_p_7} initial yes.

/*J040*/ define shared variable wolot like wo_lot.
/*J040*/ define shared variable nbr like wo_nbr.
/*G2D9*/ define variable wfirst as logical no-undo initial yes.
/*J082*/ define variable base_id like wo_base_id.
/*J040*/ define variable issue_component like mfc_logical.
/*J060*  define variable nbr like wo_nbr. */
         define variable qopen like wod_qty_all label {&woisrc01_p_11}
/*G2D9*/   format "->>>>>>9.9<<<<<<" no-undo.
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
         define variable lotref like tr_ref format "x(8)" label {&woisrc01_p_10}.
         define variable sub_comp like mfc_logical label {&woisrc01_p_12}.
         define variable firstpass like mfc_logical.
         define variable cancel_bo like mfc_logical label {&woisrc01_p_5}.
/*G782   define variable backflush_qty like wod_qty_chg. */
/*G782*/ define new shared variable backflush_qty like wod_qty_chg
/*G782*/    label {&woisrc01_p_2}.
/*F0LX   define variable default_cancel like cancel_bo.  */
/*F0LX*/ define new shared variable default_cancel like cancel_bo.
         define variable ptum like pt_um no-undo.
         define variable totladqty like lad_qty_chg.
/*GK74*/ define variable savsite like lad_site.
/*GK74*/ define variable savloc  like lad_loc.
/*GK74*/ define variable savlot  like lad_lot.
/*GK74*/ define variable savref  like lad_ref.
/*GM01*/ define new shared variable avgissue like mfc_logical initial yes.

/*G656*/ define new shared variable wo-op like wod_op.
/*G656*/ define variable op like wod_op label {&woisrc01_p_3}.
/*G1TT*/ define variable total_partqty like wod_qty_chg no-undo.
/*G1TT*/ define buffer woddet for wod_det.
/*G1TT*/ define variable overissue_ok like mfc_logical no-undo.

/*L16J*/ define variable l_error like mfc_logical   no-undo.

/*F0F2*/ define new shared variable setd-action as integer.
/*F0LX*/ {woisrc1c.i "new"} /* shared variables for modified backflush */

/*N0L3* ------------------- BEGIN DELETE ----------------------- *
 *       define new shared variable issue_or_receipt as character
 *       initial {&woisrc01_p_1}.
 *N0L3* ------------------- END   DELETE ----------------------- */

/*N0L3* ------------------- BEGIN ADD ----------------------- */
         define new shared variable issue_or_receipt as character.
         issue_or_receipt = getTermLabel("ISSUE",8).
/*N0L3* ------------------- END   ADD ----------------------- */


/*F0LX** MOVED FORM TO woisrc1d.p ****************************************
         form                                                            *
            wo_qty_ord     colon 25                                      *
            wo_qty_comp    colon 25                                      *
/*G782      wo_qty_chg     colon 25 label "Backflush Qty" */             *
/*G782*/    backflush_qty  colon 25                                      *
            skip(1)                                                      *
/*GM01*     fill_all       colon 25 fill_pick skip */                    *
/*GM01*/    fill_all       colon 25 fill_pick colon 55 skip              *
            default_cancel colon 25                                      *
/*GM01*/    avgissue       colon 55 label "Issue by Average Usage"       *
         with frame a side-labels width 80 attr-space.                   *
**F0LX********************************************************************/

/*G2D9*  form with frame c 5 down no-attr-space width 80. */

         form
            part           colon 13
/*G656*/    op             colon 37
/*G656*     pt_um */
            site           colon 54
            location       colon 68 label {&woisrc01_p_8}
            pt_desc1       colon 13
            lotserial      colon 54
            lotserial_qty  colon 13
/*G656*/    pt_um          colon 37
            lotref         colon 54
            sub_comp       colon 13
            cancel_bo
            multi_entry    colon 54
         with
/*G2D9*/ overlay
         frame d side-labels width 80 attr-space
/*G2D9*/ row 16.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/*J060*/ /* begin added block */
         form
            lad_part
            lad_site
            lad_loc
            lad_lot
            lad_ref format "x(8)" column-label {&woisrc01_p_10}
/*M0L8**    lad_qty_chg */
/*M0L8*/    lad_qty_chg format "->>>>>>9.9<<<<<<"
         with down frame e width 80 title color normal
/*N0L3*             (getFrameTitle("ISSUE_DATA_REVIEW",25)).   */
/*N0L3*/            (getFrameTitle("ISSUE_DATA_REVIEW",78)).

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame e:handle).
/*J060*/ /* end added block */

/*J04D*/ find first clc_ctrl no-lock no-error.
/*J060*/ if not available clc_ctrl then do:
/*J060*/    {gprun.i ""gpclccrt.p""}
/*J060*/    find first clc_ctrl no-lock no-error.
/*J060*/ end.

         find wo_mstr no-lock where recid(wo_mstr) = wo_recno.
/*G782   backflush_qty = max(wo_qty_ord - wo_qty_comp - wo_qty_rjct,0). */
/*G782*/ backflush_qty = wo_qty_chg + wo_rjct_chg.

/*J040*/ nbr = wo_nbr.
/*J040*/ wolot = wo_lot.

         seta:
         repeat:

            do transaction:

               find wo_mstr where recid(wo_mstr) = wo_recno.
/*G782         wo_qty_chg = backflush_qty. */

               hide frame d.
/*G2D9*        hide frame c. */
/*F0KS***** Do not force user into avgissue = no if issues were done
/*F09T*/ /* Added the following block to force component issue not by average */
         /* if any component has been issed through wowois.p                  */
 *F09T*   *    if wo__qad01 = "" then
 *F09T*   *    for each wod_det where wod_lot = wo_lot and
 *F09T*   *    wod_qty_iss > 0 no-lock:
 *F09T*   *       wo__qad01 = "PHFIRST".
 *F09T*   *       leave.
 *F09T*   *    end.
**F0KS*****/

/*F0LX*//*ADM*/  {gprun.i ""woisrc1dxx.p""}
/*J046*/       /* Chgs orig applied here are now in woisrc1d.p as J060. tjs*/
/*F0LX******** CODE REVISED TO GET NEW OPTIONS, AND MOVED TO woisrc1d.p ***
               /* DISPLAY */                                              *
               do on error undo, retry with frame a:                      *
                  display wo_qty_ord wo_qty_comp.                         *
                                                                          *
 *F0KS *GM01*     if wo__qad01 = "PHFIRST" then avgissue = no.            *
 *F0KS *GM01*     else avgissue = yes.                                    *
 *F0KS*           avgissue = yes.                                         *
 *GM01*           display avgissue.                                       *
 *G782            update wo_qty_chg fill_all fill_pick default_cancel     *
 *G782*           update backflush_qty fill_all fill_pick default_cancel. *
 *F0KS  *GM01*    avgissue when wo__qad01 = ""                            *
 *F0KS*           avgissue.                                               *
                  hide frame a.                                           *
               end.                                                       *
**F0LX*********   END OF CODE MOVED TO woisrc1d.p *************************/

/*G782         backflush_qty = wo_qty_chg. */
            end.

/*J082*/    /* IF JOINT PRODUCT WO THEN GET ITS BASE PROCESS WO */
/*J082*/    if index("1234",wo_joint_type) <> 0 then do:
/*J082*/       base_id = wo_base_id.
/*J082*/       find wo_mstr no-lock where wo_lot = base_id.
/*J082*/    end.

/*G2D9*/    phantom_first_error = no.

            do transaction:

               {gprun.i ""woisrc1a.p""}
            end.

/*G2D9*/    if phantom_first_error then undo, retry.

            do transaction on error undo, retry:

               setd:
               repeat:

/*G2D9* * * BEGIN DELETE SECTION *
.                  /* DISPLAY DETAIL */
.                  form
.                     wod_part
.                     qopen          format "->>>>>>9.9<<<<<<"
.                                    label "Qty Open"
.                     wod_qty_all    format "->>>>>>9.9<<<<<<"
.                                    label "Qty Alloc"
.                     wod_qty_pick   format "->>>>>>9.9<<<<<<"
.                                    label "Qty Picked"
.                     wod_qty_chg    format "->>>>>>9.9<<<<<<"
.                                    label "Qty to Iss"
.                     wod_bo_chg     format "->>>>>>9.9<<<<<<"
.                                    label "Qty B/O"
.                  with frame c 5 down no-attr-space width 80
./*G0KT*              title " Component Issue ". */
./*G0KT*/             title color normal " Component Issue ".
.
.                  view frame c.
**G2D9* * * END DELETE SECTION */
                  view frame d.

                  /* DISPLAY DETAIL */
/*J060*/          select-part:
                  repeat on endkey undo, leave:
/*G2D9*           with frame c: */

/*F0KS*/ /* changed display 2 from "(max(backflush_qty,wod_qty_req)      */
         /*                        - wod_qty_iss @ qopen"                */
         /* to                     "max(wod_qty_req - wod_qty_iss,0)     */
         /*                         @ qopen"                             */
/*F0H6*/ /* changed display 2 from "wod_qty_req - wod_qty_iss @ qopen"   */
                     if not batchrun then do:
/*G2D9* * * BEGIN ADD SECTION */
                       {gprun.i ""woisssw.p""
                           "(input wfirst")}
                       wfirst = no.
                       wod_recno = window_recid.
/*G2D9* * * END ADDED SECTION */

/*G2D9* * * BEGIN DELECTED SECTION * *
.                        {swindowa.i
.                           &file=wod_det
.                           &framename="c"
.                           &record-id=wod_recno
.                           &search=wod_lot
.                           &equality=wo_lot
.                           &scroll-field=wod_part
.                           &update-leave=yes
.                           &display1=wod_part
.                           &display2="max(wod_qty_req - wod_qty_iss,0) @ qopen"
.                           &display3=wod_qty_all
.                           &display4=wod_qty_pick
.                           &display5=wod_qty_chg
.                           &display6=wod_bo_chg}
.
.                        /* {1}.file name
.                           {2}.frame name
.                           {3}.record id variable
.                           {4}.equality field
.                           {5}.equality value
.                           {6}.scrolling field name
.                           {7}.field to update
.                           {8}...{14}.display fields */
**G2D9* * * END DELETED SECTION */

                        if keyfunction(lastkey) = "end-error" then leave.
                     end.

                     do on error undo, retry with frame d:
                        part = "".
/*G656*/                op = 0.
                        if wod_recno <> ? then do:
                           find wod_det no-lock
                           where recid(wod_det) = wod_recno no-error.
                           if available wod_det then
/*G656*/                   assign op = wod_op
                                part = wod_part.
                        end.
                        display part
/*G656*/                op.

                        find pt_mstr no-lock where pt_part = part no-error.
                        if available pt_mstr then display pt_desc1.
                        else display "" @ pt_desc1.

                        input clear.

                        update part
/*G656*/                   op
                        with frame d editing:
                           if frame-field = "part" then do:

                              /* FIND NEXT/PREVIOUS RECORD */
                              {mfnp01.i wod_det part wod_part wo_lot wod_lot
                                 wod_det}

                              if recno <> ? then do:
                                 part = wod_part.
/*G656*/                         op = wod_op.
                                 display part
/*G656*/                           op
                                 with frame d.
                                 find pt_mstr
                                 where pt_part = wod_part no-lock no-error.
                                 if available pt_mstr then do:
                                    display pt_um pt_desc1 with frame d.
                                 end.
                              end.
                           end.
                           else do:
                              status input.
                              readkey.
                              apply lastkey.
                           end.
                        end.
                        status input.

                        assign part
/*G656*/                   op.
                        if part = "" then leave.

/*GD11*/                find pt_mstr where pt_part = part no-lock no-error.
/*GD11*/                if not available pt_mstr then do:
/*GD11*/                   {mfmsg.i 16 3}
/*GD11*/                   undo, retry.
                        end.

                        firstpass = yes.
                        frame-d-loop: repeat:

                           cancel_bo = default_cancel.
                           sub_comp = no.
                           multi_entry = no.

                           find wod_det where wod_lot = wo_lot
                           and wod_part = part
/*G656*/                   and wod_op = op
                           no-error.
                           if not available wod_det then do:

/*J060***********************************************************************
 * /*J040*/                   if wo_type <> "r" and wo_type <> "e" then do:
 * /*J04D*/                     if not clc_comp_issue then do:
 * /*J040*/                        {gprun.i ""gpveriss.p"" "(input nbr,
 *                                                           input wolot,
 *                                                     output issue_component)"}
 * /*J040*/                        if not issue_component then do:
 * /*J040*/                           {mfmsg.i 517 3} /*COMPONENT DOES NOT*/
 * /*J040*/                           undo, retry.  /*EXIST ON THIS WORK ORDER*/
 * /*J040*/                        end.
 * /*J040*/                     end. /* IF NOT WOC_COMP_ISSUE */
 * /*J040*/                   end. /* IF WO_TYPE <> "R" AND */
 * /*J04D*/                   if clc_comp_issue then do:
 *                               {mfmsg.i 517 2}
 *                               /* COMP DOES NOT EXIST ON THIS WORK ORDER */
 * /*J040*/                   end.
**J060**********************************************************************/

/*J060*/                      if firstpass then do:
/*J060*/                         /*UNRESTRICTED COMPONENT ISSUES*/
/*J060*/                         if clc_comp_issue
/*J060*/                         or wo_type = "R" or wo_type = "E" then do:
/*J060*/                            {mfmsg.i 517 2} /*COMP NOT ON THIS WO*/
/*J060*/                         end.
/*J060*/                         /*COMPLIANCE MODULE RESTRICTS COMP ISSUE*/
/*J060*/                         else do:
/*J060*/                            {mfmsg.i 517 3} /*COMP NOT ON THIS WO*/
/*J060*/                            undo select-part, retry.
/*J060*/                         end.
/*J060*/                      end. /*IF FIRSTPASS*/

                              create wod_det.
                              assign
                              wod_lot = wo_lot
                              wod_nbr = wo_nbr
                              wod_part = part
/*G656*/                      wod_op = op
/*G216*/                      wod_site = wo_site
                              wod_iss_date = wo_rel_date.

/*L0XY*/                      if recid(wod_det) = -1 then .

                           end.

/*GD11                     find pt_mstr                                 */
/*GD11                     where pt_part = wod_part no-lock no-error.   */
/*GD11                     if not available pt_mstr then do:            */
/*GD11                        {mfmsg.i 16 2}                            */
/*GD11                        display part " " @ pt_um " " @ pt_desc1   */
/*GD11                        with frame d.                             */
/*GD11                        ptum = "".                                */
/*GD11                     end.                                         */
/*GD11                     else do:                                     */
                              if new wod_det then assign wod_loc = pt_loc.
/*F003                        wod_tot_std = pt_tot_std. */

/*GE21*/                   find pt_mstr
/*GE21*/                   where pt_part = wod_part no-lock no-error.
/*GE21*/                   if not available pt_mstr
/*GE21*/                           then do:
/*GE21*/                      {mfmsg.i 16 2}
/*GE21*/                      display part " " @ pt_um " " @ pt_desc1
/*GE21*/                      with frame d.
/*GE21*/                      ptum = "".
/*GE21*/                           end.
/*GE21*/                   else do:
/*GE21*/                      display wod_part @ part pt_um pt_desc1
                              with frame d.
                              ptum = pt_um.
/*GE21*/                   end.
/*GD11                     end.                                         */

/*G2GD*                    qopen = wod_qty_req - wod_qty_iss. */
/*G2GD*/           qopen = if wod_qty_req >= 0 then
/*G2GD*/                      max(min(wod_qty_req - wod_qty_iss,wod_qty_req),0)
/*G2GD*/                          else
/*G2GD*/                      min(max(wod_qty_req - wod_qty_iss,wod_qty_req),0).

                           lotserial_control = "".
                           if available pt_mstr then
                              lotserial_control = pt_lot_ser.
                           site = "".
                           location = "".
                           lotserial = "".
                           lotref = "".

/*G115                     if not firstpass                                   */
/*G115                     then lotserial_qty = wod_qty_chg + lotserial_qty.  */
/*G115                     else lotserial_qty = wod_qty_chg.                  */
/*G115*/                   if firstpass then
/*G115*/                      lotserial_qty = wod_qty_chg.

/*G216*/                   if not firstpass
/*G216*/                   then lotserial_qty = wod_qty_chg + lotserial_qty.

/*G656*                    cline = wod_part. */
/*G656*/                   cline = string(wod_part,"x(18)") + string(wod_op).
                           global_part = wod_part.

                           find first lad_det where lad_dataset = "wod_det"
/*G656*                    and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/                   and lad_nbr = wod_lot and lad_line = string(wod_op)
                           and lad_part = wod_part no-lock no-error.
                           if available lad_det then do:
                              assign
                                 site = lad_site
                                 location = lad_loc
                                 lotserial = lad_lot
                                 lotref = lad_ref.
                              find next lad_det where lad_dataset = "wod_det"
/*G656*                       and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/                      and lad_nbr = wod_lot
/*G656*/                      and lad_line = string(wod_op)
                              and lad_part = wod_part no-lock no-error.
                              if available lad_det then
                                 assign
                                    multi_entry = yes
                                    site = ""
                                    location = ""
                                    lotserial = ""
                                    lotref = "".
                           end.
                           else do:
                              site = wod_site.
                              /*ss - 20121226.1 - b*/
                              /*location = wod_loc.*/
                              find first tr_hist where tr_type = 'iss-wo' and 
                              tr_part = wod_part and tr_lot = wod_lot and
                              tr_wod_op = wod_op no-lock no-error.
                              if avail tr_hist then
                                 location = tr_loc.                                 
                              /*ss - 20121226.1 - e*/
                           end.

/*F190*/                   locloop:
                           do on error undo, retry
/*J060                     on endkey undo, leave:     */
/*J060*/                   on endkey undo select-part, retry:

                              wod_recno = recid(wod_det).
/****ADM begin add***********
*                              find wopass where w_name = global_userid no-lock no-error.
*                              if available wopass then do:
*                                  update lotserial_qty  
*                                  sub_comp   /*ADM cancel_bo*/
*                                  site location lotserial lotref multi_entry
*                                  with frame d
*                                  editing:
*                                      global_site = input site.
*                                      global_loc = input location.
*                                      global_lot = input lotserial.
*                                      readkey.
*                                      apply lastkey.
*                                  end.
*                              end.
*                              else do:
*                                  update   /*lotserial_qty  */
*                                  sub_comp   /*ADM cancel_bo*/
*                                  site location lotserial lotref multi_entry
*                                  with frame d
*                                  editing:
*                                      global_site = input site.
*                                      global_loc = input location.
*                                      global_lot = input lotserial.
*                                      readkey.
*                                      apply lastkey.
*                                  end.
*                              end.
****ADM end add**************/
/*ADM                             update lotserial_qty  */
/*ADM*/                       display lotserial_qty with frame d.
/*ADM*/                       update 
                              sub_comp   /*ADM cancel_bo*/
                              site location lotserial lotref multi_entry
                              with frame d
                              editing:
                                 global_site = input site.
                                 global_loc = input location.
                                 global_lot = input lotserial.
                                 readkey.
                                 apply lastkey.
                              end.
                              if sub_comp then do:
                                 if can-find (first pts_det where
                                    pts_part = wod_part and pts_par = "")
                                 or can-find (first pts_det where
                                    pts_part = wod_part and pts_par = wo_part)
                                 then do:
                                    {gprun.i ""wosumt.p""}
                                    if keyfunction(lastkey) = "end-error" then
                                       undo, retry.
                                    firstpass = no.
                                    next frame-d-loop.
                                 end.
                                 else do with frame d:
                                    {mfmsg.i 545 3}
                                    next-prompt sub_comp.
                                    undo, retry.
                                 end.
                              end.

                              if can-find (first lad_det
                              where lad_dataset = "wod_det"
/*G656*                       and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/                      and lad_nbr = wod_lot
/*G656*/                      and lad_line = string(wod_op)
                              and lad_part = wod_part)
                              and not can-find (lad_det
                              where lad_dataset = "wod_det"
/*G656*                       and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/                      and lad_nbr = wod_lot
/*G656*/                      and lad_line = string(wod_op)
                              and lad_part = wod_part) then multi_entry = yes.

                              total_lotserial_qty = wod_qty_chg.

                              if multi_entry then do:
                                 wod_qty_chg = lotserial_qty.
/*ADM*/                          {gprun.i ""iclad01xx.p""}
/*G1TT*/ /* BEGIN ADD TO VALIDATE NO OVERISSUE */
                                 {gprun.i ""woisrc1e.p"" "(input wo_lot,
                                       input wod_part,
                                       output overissue_ok)"}
                                 if not overissue_ok then undo locloop, retry.
/*G1TT*/ /* END SECTION */
                              end. /* IF multi_entry */
                              else do:
/*J038************* REPLACE ICEDIT.I WITH ICEDIT.P ********************/
/*J038*                          {icedit.i                            */
/*J038*                             &transtype=""ISS-WO""             */
/*J038*                             &site=site                        */
/*J038*                             &location=location                */
/*J038*                             &part=global_part                 */
/*J038*                             &lotserial=lotserial              */
/*J038*                             &lotref=lotref                    */
/*J038*                             &quantity=lotserial_qty           */
/*J038*                             &um=ptum                          */
/*J038*                          }                                    */
/*J038*****************************************************************/
/*G0SY*/                         if lotserial_qty <> 0 then do:
/*G1TT*/ /* BEGIN ADD * * SUM ALL LINES FOR PART/SITE/LOC/LOT/REF */
                                   total_partqty = lotserial_qty.
                                   for each lad_det no-lock where
                                     lad_dataset = "wod_det" and
                                     lad_nbr = wod_lot and
                                     lad_line <> string(wod_op) and
                                     lad_part = part and
                                     lad_site = site and
                                     lad_loc = location and
                                     lad_ref = lotref and
                                     lad_lot = lotserial:
                                     total_partqty = total_partqty +
                                        lad_qty_chg.
                                     end.
/*G1TT*/ /* END ADD */
/*G1TT*/ /*CHANGE lotserial_qty TO total_partqty */
/*J038*/                          {gprun.i ""icedit.p"" " (""ISS-WO"",
                                                          site,
                                                          location,
                                                          global_part,
                                                          lotserial,
                                                          lotref,
                                                          total_partqty,
                                                          ptum,
                                                          """",
                                                          """",
                                                          output yn )" }
/*J038*/                          if yn then undo locloop, retry.

/*F190*/                          if site <> wo_site then do:
/*F0TC*/ /**** The following code has been replaced by icedit4.p which ****/
/*F0TC*/ /**** can be used in both multi line and single line mode.    ****/
/*F0TC*/ /*************************** Delete: Begin ***********************
/*J038* ADD INPUT PARAMETERS FOR TRNBR AND TRLINE                            */
/*F190*/ *                          {gprun.i ""icedit3.p"" "(input ""ISS-WO"",
 *                                                         input wo_site,
 *                                                         input location,
 *                                                         input global_part,
 *                                                         input lotserial,
 *                                                         input lotref,
 *                                                         input lotserial_qty,
 *                                                         input ptum,
 *                                                         input """",
 *                                                         input """",
 *                                                         output yn)"
 *                                  }
/*F190*/ *                          if yn then undo locloop, retry.
 *
/*J038* ADD INPUT PARAMETERS FOR TRNBR AND TRLINE                            */
/*F190*/ *                          {gprun.i ""icedit3.p"" "(input ""ISS-TR"",
 *                                                         input site,
 *                                                         input location,
 *                                                         input global_part,
 *                                                         input lotserial,
 *                                                         input lotref,
 *                                                         input lotserial_qty,
 *                                                         input ptum,
 *                                                         input """",
 *                                                         input """",
 *                                                         output yn)"
 *                                  }
/*F190*/ *                          if yn then undo locloop, retry.
 *
/*J038* ADD INPUT PARAMETERS FOR TRNBR AND TRLINE                            */
/*F190*/ *                          {gprun.i ""icedit3.p"" "(input ""RCT-TR"",
 *                                                         input wo_site,
 *                                                         input location,
 *                                                         input global_part,
 *                                                         input lotserial,
 *                                                         input lotref,
 *                                                         input lotserial_qty,
 *                                                         input ptum,
 *                                                         input """",
 *                                                         input """",
 *                                                         output yn)"
 *                                  }
/*F0TC*/ **************************** Delete: End *************************/

/*J038* ADD INPUT PARAMETERS FOR TRNBR AND TRLINE  (done during Dec 5 merge) */
/*F0TC*/                            {gprun.i ""icedit4.p"" "(input ""ISS-WO"",
                                                           input wo_site,
                                                           input site,
                                                           input pt_loc,
                                                           input location,
                                                           input global_part,
                                                           input lotserial,
                                                           input lotref,
                                                           input lotserial_qty,
                                                           input ptum,
                                                           input """",
                                                           input """",
                                                           output yn)"
                                    }
/*F190*/                            if yn then undo locloop, retry.
/*F190*/                          end.
/*G0SY*/                         end.

                                 find first lad_det
                                 where lad_dataset = "wod_det"
/*G656*                          and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/                         and lad_nbr = wod_lot
/*G656*/                         and lad_line = string(wod_op)
                                 and lad_part = wod_part no-error.

/*GK74*/                         if available lad_det then do:
/*F0N7*/                          assign
/*GK74*/                          savsite = lad_site
/*GK74*/                          savloc  = lad_loc
/*GK74*/                          savlot = lad_lot
/*GK74*/                          savref  = lad_ref
/*F0N7*/                          lad_qty_chg = 0.
/*GK74*/                         end.

                                 if lotserial_qty = 0 then do:
                                    if available lad_det then do:
                                       lad_qty_chg = 0.
                                    end.
                                 end.
                                 else do:
/*F0N7*/                            find lad_det
/*F0N7*/                            where lad_dataset = "wod_det"
/*F0N7*/                            and lad_nbr = wod_lot
/*F0N7*/                            and lad_line = string(wod_op)
/*F0N7*/                            and lad_part = wod_part
/*F0N7*/                            and lad_site = site
/*F0N7*/                            and lad_loc = location
/*F0N7*/                            and lad_lot = lotserial
/*F0N7*/                            and lad_ref = lotref
/*F0N7*/                            no-error.
                                    if not available lad_det then do:
                                       create lad_det.
                                       assign
                                       lad_dataset = "wod_det"
/*G656*                                lad_nbr = wod_nbr
                                       lad_line = wod_lot */
/*G656*/                               lad_nbr = wod_lot
/*G656*/                               lad_line = string(wod_op)
/*F0N7*/                               lad_site = site
/*F0N7*/                               lad_loc = location
/*F0N7*/                               lad_lot = lotserial
/*F0N7*/                               lad_ref = lotref
                                       lad_part = wod_part.
                                    end.
/*F0N7*                             assign                 */
/*F0N7*                             lad_site = site        */
/*F0N7                              lad_loc = location     */
/*F0N7                              lad_lot = lotserial    */
/*F0N7                              lad_ref = lotref       */
                                    lad_qty_chg = lotserial_qty.

/*L0XY*/                         if recid(lad_det) = -1 then .

                                 end.
                                 total_lotserial_qty = lotserial_qty.
                              end.  /* else (not multi_entry) */

/*F0N7********SECTION DELETED************************************************
/*GK74*/   *                  if savsite <> site or savloc <> location or
/*GK74*/   *                  savlot <> lotserial or savref <> lotref then do:
/*GK74*/   *                   find ld_det where ld_site = savsite
/*GK74*/   *                   and ld_part = wod_part
/*GK74*/   *                   and ld_loc = savloc and ld_lot = savlot
/*GK74*/   *                   and ld_ref = savref no-error.
/*GK74*/   *                   if available ld_det then
/*GK74*/   *                   ld_qty_all = ld_qty_all - lotserial_qty.
/*F0F2*/   *                   {mflddel.i}
/*GK74*/   *                  end.

/*GK74*/   *                  find ld_det where ld_site = site and
/*GK74*/   *                  ld_part = wod_part and ld_loc = location
/*GK74*/   *                  and ld_lot = lotserial
/*GK74*/   *                  and ld_ref = lotref no-error.
/*GK74*/   *                  if available ld_det then
/*GK74*/   *                  ld_qty_all = ld_qty_all + lotserial_qty.
**F0N7********SECTION DELETED************************************************/

                              wod_qty_chg = total_lotserial_qty.
                              if cancel_bo then
                                 wod_bo_chg = 0.
                              else
                                 wod_bo_chg = wod_qty_req
                                             - wod_qty_iss
                                             - wod_qty_chg.
                              if wod_qty_req >= 0 then
                                 wod_bo_chg = max(wod_bo_chg,0).
                              if wod_qty_req < 0 then
                                 wod_bo_chg = min(wod_bo_chg,0).
                           end.

                           leave.
                        end.
                     end.
                  end.

                  repeat:
                     yn = yes.
/*G0KT*/ /*V8-*/
                     {mfmsg01.i 636 1 yn} /* Display items being issued? */
/*G0KT*/ /*V8+*/
/*G0KT*/ /*V8!       {mfgmsg10.i 636 1 yn} */
                     if yn = yes then do:
/*G2D9*                 hide frame c no-pause. */
                        hide frame d no-pause.
/*G0SY*/                form
/*G1FL* /*G0SY*/       with frame e down width 80 title " Issue Data Review ".*/
/*G1FL*/                with frame e down width 80
/*G2D9*/                row 7 overlay
/*G1FL*/                title color normal

/*N0L3*     /*G1FL*/    (getFrameTitle("ISSUE_DATA_REVIEW",25)).   */
/*N0L3*/            (getFrameTitle("ISSUE_DATA_REVIEW",78)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).
/*J082*/                clear frame e all no-pause.
/*J060*/                view frame e.

/*K20B*/                /* THE JOINS ARE BROKEN INTO MULTIPLE "FOR EACH" */
/*K20B*/                /* FOR EACH TABLE TO IMPROVE ORACLE PERFORMANCE  */
/*K20B*/                /* SO THAT `QUANTITY TO ISSUE' FOR THE LAST      */
/*K20B*/                /* UPDATED ITEM IS DISPLAYED CORRECTLY           */

/*K20B** BEGIN DELETE SECTION
 *                      for each wod_det no-lock where wod_lot = wo_lot,
 *                      each lad_det no-lock where lad_dataset = "wod_det"
 * /*G656*              and lad_nbr = wod_nbr and lad_line = wod_lot */
 * /*G656*/             and lad_nbr = wod_lot and lad_line = string(wod_op)
 * /*G1FL*              and lad_part = wod_part and lad_qty_chg <> 0       */
 * /*G1FL*/             and lad_part = wod_part
 * /*G0SY*              with frame e width 80 title " Issue Data Review ": */
 *K20B** END DELETE SECTION */

/*K20B*/                /* BEGIN ADD SECTION */
                        for each wod_det
                           fields(wod_bo_chg wod_iss_date wod_loc
                                  wod_lot wod_nbr wod_op wod_part
                                  wod_qty_chg wod_qty_iss wod_qty_req
                                  wod_site)
                           no-lock where wod_lot = wo_lot:

                           for each lad_det
                              fields(lad_dataset lad_line lad_loc
                                     lad_lot lad_nbr lad_part
                                     lad_qty_chg lad_ref lad_site)
                              no-lock where lad_dataset = "wod_det"
                                        and lad_nbr     = wod_lot
                                        and lad_line    = string(wod_op)
                                        and lad_part    = wod_part
/*L0XY*/                                and lad_qty_chg <> 0
/*K20B*/                /* END ADD SECTION */
/*G0SY*/                   with frame e:

                              display
/*J060*                          wod_part lad_site lad_loc lad_lot        */
/*J060*                          lad_ref format "x(8)" column-label "Ref" */
/*J060*/                         lad_part lad_site lad_loc lad_lot
/*J060*/                         lad_ref
                                 lad_qty_chg.
/*J060*                       down. */
/*J060*/                      down 1 with frame e.

                           end. /* FOR EACH LAD_DET */
/*J060*                    view frame e. */
/*K20B*/                end. /* FOR EACH WOD_DET */
                     end. /* IF YN = YES */
                     leave.
                  end. /* REPEAT */

/*F0N7            do on endkey undo seta, leave seta: */
/*F0N7*/          do on endkey undo setd, leave seta:
                     yn = yes.
/*G0KT*/ /*V8-*/
                     {mfmsg01.i 12 1 yn} /* "Is all info correct?" */
/*G0KT*/ /*V8+*/
/*G0KT*/ /*V8!       {mfgmsg10.i 12 1 yn}
                     if yn = ? then do:
                        outta_here = yes.
                        undo setd, leave seta.
                     end.
          */
/*GO84*/ /* /*GM78*/ if yn = no then undo seta, leave seta. */

/*L0XY*/             if yn = no then undo setd, retry setd.

                  end.

/*G1TT*/ /*VALIDATE THAT NO OVERISSUE HAS OCCURED BEGIN ADD*/
                  if yn then do:
                    {gprun.i ""woisrc1e.p"" "(input wo_lot,
                      input ""*"",
                      output overissue_ok)" }
                    if not overissue_ok then yn = no.
                  end.
/*G1TT* * * END ADD */

                  if yn then do:
/*F0F2*/             setd-action = 0.
/*F0F2*/             {gprun.i ""woisrc1b.p""}
/*F0F2*/             if setd-action = 1 then undo setd, retry setd.
/*F0F2*/             if setd-action = 2 then next setd.

/*L16J*/             /* BEGIN ADD SECTION */
/*L16J*/             /* ADDED A CALL TO icedit4.p AS ALL THE VALIDATIONS OF */
/*L16J*/             /* icedit4.p WERE SKIPPED IF THE USER ACCEPTED THE     */
/*L16J*/             /* DEFAULTS AND EXITED (F4) NOT PROCESSING THE         */
/*L16J*/             /* INDIVIDUAL LINES.                                   */

                     l_error = no.

                     for each wod_det
                        fields(wod_bo_chg  wod_iss_date   wod_loc
                               wod_lot     wod_nbr        wod_op
                               wod_part    wod_qty_chg    wod_qty_iss
                               wod_qty_req wod_site)
                        where wod_lot = wo_lot no-lock,
                        each sr_wkfl fields(sr_userid sr_lineid sr_site
                                            sr_loc    sr_lotser sr_ref
                                            sr_qty)
                        where sr_userid = mfguser
                          and sr_lineid = string(wod_part,"x(18)")
                                        + string(wod_op)
                          and sr_qty    <> 0.00
                          no-lock:

                        for first pt_mstr
                            fields(pt_desc1 pt_loc pt_lot_ser pt_part pt_um)
                            where pt_part = wod_part no-lock:
                        end. /* FOR FIRST pt_mstr ... */

                        ptum = "".
                        if available(pt_mstr) then
                           ptum = pt_um.

                        if (wo_site <> sr_site) then do:
                           {gprun.i ""icedit4.p""
                                    "(input ""ISS-WO"",
                                      input wo_site,
                                      input sr_site,
                                      input pt_loc,
                                      input sr_loc,
                                      input trim(substring(sr_lineid,1,18)),
                                      input sr_lotser,
                                      input sr_ref,
                                      input sr_qty,
                                      input ptum,
                                      input """",
                                      input """",
                                      output yn)"}

                           if yn then do:
                              l_error = yes.

                              /* FOR ITEM/SITE/LOCATION: #/#/#/# */
                                 {mfmsg03.i 4578 1 trim(substring(sr_lineid,1,18))
                                                   sr_site
                                                sr_loc
                                                sr_lotser}
                           end. /* IF yn     */
                        end. /* IF (wo_site <> sr_site)  */
                     end. /* FOR EACH WOD_DET */

                     if l_error then
                        undo setd, retry setd.
/*L16J*/             /* END ADD SECTION */

/*F0F2****           /* CODE MOVED TO woisrc1b.p */
/*FQ57*/ *           /* ADDED SECTION TO VERIFY STOCK EXISTS FOR ISSUE */
         *           for each wod_det no-lock where wod_lot = wo_lot,
         *               each lad_det no-lock where lad_dataset = "wod_det"
         *               and lad_nbr = wod_lot and lad_line = string(wod_op)
         *               and lad_part = wod_part and lad_qty_chg <> 0:
         *               find pt_mstr where pt_part = wod_part no-lock
         no-error.
         *
         *              define variable rejected like mfc_logical.
         *              {gprun.i ""icedit2.p""
         *                            "(input ""ISS-WO"",
         *                              input lad_site,
         *                              input lad_loc,
         *                              input lad_part,
         *                              input lad_lot,
         *                              input lad_ref,
         *                              input lad_qty_chg,
         *                              input pt_um,
         *                              output rejected)"
         *              }
         *
         *              if rejected then do:
         *                 {mfmsg02.i 5630 4 """"}
         *                 {mfmsg02.i 161 1 lad_part}
         *                 undo setd, retry setd.
         *              end.
         *           end.
/*FQ57*/ *           /* END OF SECTION VERIFYING STOCK EXISTS FOR ISSUE */
         *
         *           for each wod_det no-lock
         *           where wod_lot = wo_lot
         *           and (wod_qty_chg <> 0
         *           or wod_bo_chg <> max(wod_qty_req - wod_qty_iss,0)):
         *              totladqty = 0.
         *              for each lad_det no-lock
         *              where lad_dataset = "wod_det"
/*G656*  *              and lad_nbr = wod_nbr
         *              and lad_line = wod_lot */
/*G656*/ *              and lad_nbr = wod_lot
/*G656*/ *              and lad_line = string(wod_op)
         *              and lad_part = wod_part
         *              and lad_qty_chg <> 0:
         *                 totladqty = totladqty + lad_qty_chg.
         *              end.
         *              if totladqty <> wod_qty_chg then do:
         *                 wod_recno = recid(wod_det).
         *                 {mfmsg02.i 161 3 wod_part}
         *                 next setd.
         *              end.
         *           end.
         *
/*G782   *           for each wod_det no-lock where wod_lot = wo_lot */
/*G782   *           and wod_qty_req >= 0,                           */
/*G782*/ *           for each wod_det no-lock where wod_lot = wo_lot,
         *           each lad_det no-lock where lad_dataset = "wod_det"
/*G656*  *           and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/ *           and lad_nbr = wod_lot and lad_line = string(wod_op)
         *           and lad_part = wod_part and lad_qty_chg <> 0:
         *              create sr_wkfl.
         *              assign
         *              sr_userid = mfguser
/*G656*  *              sr_lineid = lad_part */
/*G656*/ *              sr_lineid = string(wod_part,"x(18)") + string(wod_op)
         *              sr_site = lad_site
         *              sr_loc = lad_loc
         *              sr_lotser = lad_lot
         *              sr_qty = lad_qty_chg
         *              sr_ref = lad_ref.
         *           end.
         *
/*GM01*/ *           if avgissue then wo__qad01 = "AVGISS".
/*GM01*/ *           else wo__qad01 = "PHFIRST".
         *
**F0F2****/          /*  END OF CODE MOVED TO woisrc1b.p ****************/
/*G2D9*              hide frame c. */
                     hide frame d.
                     hide frame e.
                     leave setd.
                  end.
/*FM98*/          else do:
/*FM98*/             find first wod_det where wod_lot = wo_lot no-lock no-error.
/*FM98*/             if available wod_det then wod_recno = recid(wod_det).
/*FM98*/          end.
               end. /* setd */
            end.
            leave.
         end.

/*J082*/ hide frame e.
         hide frame d.
/*G2D9*  hide frame c. */
/*F0LX   hide frame a. */
