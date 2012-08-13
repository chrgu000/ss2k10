/* GUI CONVERTED from woisrc01.p (converter v1.78) Fri Oct 29 14:34:26 2004 */
/* woisrc01.p - WORK ORDER ISSUE WITH SERIAL NUMBERS                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.26.1.10 $                                                    */
/*V8:ConvertMode=Maintenance                                            */
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
/* REVISION: 8.5     LAST MODIFIED: 05/13/96   BY: *G1TT* Julie Milligan     */
/* REVISION: 8.5     LAST MODIFIED: 08/29/96   BY: *G2D9* Julie Milligan     */
/* REVISION: 7.3     LAST MODIFIED: 10/03/96   BY: *G2GD* Murli Shastri      */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0     LAST MODIFIED: 04/16/99   BY: *K20B* G.Latha            */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 04/13/00   BY: *M0L8* Jyoti Thatte       */
/* REVISION: 9.1     LAST MODIFIED: 05/19/00   BY: *L0XY* Vandna Rohira      */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00   BY: *N0L3* Arul Victoria      */
/* REVISION: 9.1     LAST MODIFIED: 12/12/00   BY: *L16J* Thomas Fernandes   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.21     BY: Veena Lad               DATE: 03/28/01 ECO: *P008* */
/* Revision: 1.23     BY: Niranjan R.             DATE: 06/25/02 ECO: *P09L* */
/* Revision: 1.24     BY: Hareesh V               DATE: 10/11/02 ECO: *N1X2* */
/* Revision: 1.25     BY: Anitha Gopal            DATE: 03/28/03 ECO: *P0PG* */
/* Revision: 1.26     BY: Narathip W.             DATE: 04/29/03 ECO: *P0QN* */
/* Revision: 1.26.1.3 BY: Manisha Sawant          DATE: 06/10/03 ECO: *N2GV* */
/* Revision: 1.26.1.7 BY: Mike Dempsey            DATE: 11/27/03  ECO: *N2GM* */
/* Revision: 1.26.1.8 BY: Dayanand Jethwa         DATE: 04/28/04  ECO: *P1YJ* */
/* Revision: 1.26.1.9 BY: Max Iles                DATE: 07/01/04  ECO: *N2VQ* */
/* $Revision: 1.26.1.10 $ BY: Bhagyashri Shinde DATE: 07/14/04  ECO: *P29X* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "WOISRC01.P"}

{wndvar2.i "new shared"}

/*       SINCE THIS PROGRAM DOES NOT ALLOW UM CONVERSION,         */
/*       sr_qty, ITS DEPENDANCIES, wo_qty_chg, AND wo_rjct_chg    */
/*       ARE STATED IN STOCKING UM.  IF UM CONVERSION IS EVER     */
/*       ADDED, THE ABOVE VARIABLES MUST REMAIN STATED IN THE     */
/*       STOCK UNITS OF MEASURE.                                  */

define input parameter pModifyBackflush as logical no-undo.

define new shared variable part              like wod_part.
define new shared variable wopart_wip_acct   like pl_wip_acct.
define new shared variable wopart_wip_sub    like pl_wip_sub .
define new shared variable wopart_wip_cc     like pl_wip_cc.
define new shared variable site              like sr_site        no-undo.
define new shared variable location          like sr_loc         no-undo.
define new shared variable lotserial         like sr_lotser      no-undo.
define new shared variable lotserial_qty     like sr_qty         no-undo.
define new shared variable multi_entry       as logical
                                             label "Multi Entry" no-undo.
define new shared variable lotserial_control as character.
define new shared variable cline             as character.
define new shared variable row_nbr           as integer.
define new shared variable col_nbr           as integer.
define new shared variable total_lotserial_qty like wod_qty_chg.
define new shared variable wo_recid          as recid.
define new shared variable wod_recno         as recid.
define new shared variable fill_all          like mfc_logical
                                             label "Issue Alloc" initial no.
define new shared variable fill_pick         like mfc_logical
                                             label "Issue Picked" initial yes.
define new shared variable setd-action       as   integer.
define new shared variable issue_or_receipt  as   character.
define new shared variable backflush_qty     like wod_qty_chg
                                             label "Backflush Qty".
define new shared variable avgissue          like mfc_logical initial yes.
define new shared variable wo-op             like wod_op.
{&WOISRC01-P-TAG1}

/* SHARED VARIABLES FOR MODIFIED BACKFLUSH */
{woisrc1c.i "new"}

define shared variable wolot      like wo_lot.
define shared variable nbr        like wo_nbr.
define shared variable wo_recno   as   recid.
define shared variable eff_date   like glt_effdate.
define shared variable outta_here as logical        no-undo.

/* LOCAL VARIABLES */
define variable wfirst  as   logical    initial yes no-undo.
define variable base_id like wo_base_id.
define variable ref     like glt_ref.
define variable desc1   like pt_desc1 no-undo.
define variable ptum    like pt_um    no-undo.

define variable trqty    like tr_qty_chg.
define variable trlot    like tr_lot.
define variable qty_left like tr_qty_chg.
define variable lotref   like tr_ref format "x(8)" label "Ref".

define variable totladqty   like lad_qty_chg.
define variable savsite     like lad_site.
define variable savloc      like lad_loc.
define variable savlot      like lad_lot.
define variable savref      like lad_ref.
define variable tot_lad_all like lad_qty_all.
define variable ladqtychg   like lad_qty_all.

define variable op            like wod_op      label "Op".
define variable total_partqty like wod_qty_chg            no-undo.
define variable qopen         like wod_qty_all label "Qty Open"
                              format "->>>>>>9.9<<<<<<"   no-undo.

define variable issue_component like mfc_logical initial no         no-undo.
define variable yn              like mfc_logical initial no         no-undo.
define variable del-yn          like mfc_logical initial no         no-undo.
define variable sub_comp        like mfc_logical label "Substitute".
define variable firstpass       like mfc_logical initial no         no-undo.
define variable cancel_bo       like mfc_logical label "Cancel B/O".
define variable overissue_ok    like mfc_logical initial no         no-undo.
define variable l_error         like mfc_logical initial no         no-undo.

define new shared variable default_cancel    like cancel_bo.

DEF NEW SHARED VAR path1 AS CHAR FORMAT "x(20)" LABEL "½Ó¿Ú".

/* BUFFERS */
define buffer woddet for wod_det.

issue_or_receipt = getTermLabel("ISSUE",8).

{&WOISRC01-P-TAG2}
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part           colon 13
   op             colon 37
   site           colon 54
   location       colon 68 label "Loc"
   pt_desc1       colon 13
   lotserial      colon 54
   lotserial_qty  colon 13
   pt_um          colon 37
   lotref         colon 54
   sub_comp       colon 13
   cancel_bo
   multi_entry    colon 54
    PATH1 COLON 13
 SKIP(.4)  /*GUI*/
with overlay frame d side-labels width 80 attr-space row 16 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/

{&WOISRC01-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

FORM /*GUI*/ 
   lad_part
   lad_site
   lad_loc
   lad_lot
   lad_ref format "x(8)" column-label "Ref"
   lad_qty_chg format "->>>>>>9.9<<<<<<"
with down frame e width 80
title color normal (getFrameTitle("ISSUE_DATA_REVIEW",78)) THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

find first clc_ctrl
no-lock no-error.
if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

   find first clc_ctrl
   no-lock no-error.
end. /* FIND FIRST clc_ctrl */

find wo_mstr no-lock
   where recid(wo_mstr) = wo_recno
   no-error.

assign
   backflush_qty = wo_qty_chg + wo_rjct_chg
   nbr           = wo_nbr
   wolot         = wo_lot.
{&WOISRC01-P-TAG4}

seta:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


      find wo_mstr
         where recid(wo_mstr) = wo_recno
         exclusive-lock no-error.

      hide frame d.

      /* ADDED INPUT PARAMETER pModifyBackflush */
      {gprun.i ""woisrc1d.p"" "(input pModifyBackflush)" }
/*GUI*/ if global-beam-me-up then undo, leave.


   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*DO TRANSACTION */

   /* IF JOINT PRODUCT WO THEN GET ITS BASE PROCESS WO */
   if index("1234",wo_joint_type) <> 0
   then do:
      base_id = wo_base_id.
      find wo_mstr no-lock
         where wo_lot = base_id
         no-error.
   end. /* IF INDEX( */

   phantom_first_error = no.

   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


      {gprun.i ""woisrc1a.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION */

   if phantom_first_error
   then
      undo, retry.

   do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      setd:
      repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


      if pModifyBackflush
      then do:
         view frame d.

         /* DISPLAY DETAIL */
         select-part:
         repeat on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


            if not batchrun
            then do:

                assign
                   wfirst      = yes
                   window_row  = 7.

                {windowxt.i
                   &file = wod_det
                   &display = "wod_part
                               wod_op
                               max(min(wod_qty_req - wod_qty_iss,wod_qty_req),0)
                                    when (wod_qty_req >= 0)
                                    @ qopen format '->>>>>>9.9<<<<<<'
                               min(max(wod_qty_req - wod_qty_iss,wod_qty_req),0)
                                    when (wod_qty_req < 0)
                                    @ qopen format '->>>>>>9.9<<<<<<'
                               wod_qty_all + wod_qty_pick @ wod_qty_all
                                    format '->>>>>>9.9<<<<<<'
                                    label 'Alloc/Pick'
                               wod_qty_chg
                                    format '->>>>>>9.9<<<<<<'
                               wod_bo_chg
                                    format '->>>>>>9.9<<<<<<'"
                   &index-fld1 = wod_part
                   &use-index1 = "use-index wod_det"
                   &index-fld2 = wod_part
                   &use-index2 = "use-index wod_det"
                   &frametitle = "'COMPONENT_ISSUE'"
                   &framephrase = " width 80 "
                   &window-down = 5
                   &where1 = "where wod_lot = wo_lot"
                   &where2 = "where true"
                   &and         = "(wod_lot = wo_lot)"
                   &time-out    =  0
                   }

                if keyfunction(lastkey) <> "END-ERROR" then
                   view frame w.

               assign
                  wfirst    = no
                  wod_recno = window_recid.

               if keyfunction(lastkey) = "end-error"
               then
                  leave.
            end. /* IF NOT batchrun */

            do on error undo, retry with frame d:
/*GUI*/ if global-beam-me-up then undo, leave.

               assign
                  part = ""
                  op   = 0.
               if wod_recno <> ?
               then do:
                  find wod_det no-lock
                     where recid(wod_det) = wod_recno
                     no-error.
                  if available wod_det
                  then
                     assign
                        op   = wod_op
                        part = wod_part.
               end. /* IF wod_recno <> ? */
               display
                  part
                  {&WOISRC01-P-TAG5}
                  op.

               find pt_mstr no-lock
                  where pt_part = part
                  no-error.
               if available pt_mstr
               then
                  display
                     pt_desc1.
               else
                  display
                     "" @ pt_desc1.

               /* CONDITION ADDED TO IMPROVE PERFORMANCE IN DESKTOP 2 */
               if not {gpiswrap.i}
               then
                  input clear.

               update part
                  op
                  with frame d
               editing:
                  if frame-field = "part"
                  then do:

                     /* FIND NEXT/PREVIOUS RECORD */
                     {mfnp01.i wod_det part wod_part wo_lot wod_lot
                        wod_det}

                     if recno <> ?
                     then do:
                        assign
                           part = wod_part
                           op   = wod_op.
                        display
                           part
                           op
                        with frame d.
                        find pt_mstr
                           where pt_part = wod_part
                           no-lock no-error.
                        if available pt_mstr
                        then do:
                           display
                              pt_um
                              pt_desc1
                           with frame d.
                        end. /* IF AVAILABLE pt_mstr */
                     end. /* IF recno <> ? */
                  end. /* IF frame-field = "part" */
                  else do:
                     status input.
                     readkey.
                     apply lastkey.
                  end. /* ELSE DO */
               end. /* UPDATE */
               status input.

               assign part
                  op.
               if part = ""
               then
                  leave.

               find pt_mstr
                  where pt_part = part
                  no-lock no-error.
               if not available pt_mstr
               then do:
                  {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
                  undo, retry.
               end. /* IF NOT AVAILABLE pt_mstr */

               firstpass = yes.
               frame-d-loop:
               repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


                  assign
                     cancel_bo   = default_cancel
                     sub_comp    = no
                     multi_entry = no.

                  find wod_det
                     where wod_lot  = wo_lot
                     and   wod_part = part
                     and   wod_op   = op
                  exclusive-lock no-error.
                  if not available wod_det
                  then do:

                     if firstpass
                     then do:
                        /*UNRESTRICTED COMPONENT ISSUES*/
                        if clc_comp_issue
                           or wo_type = "R"
                           or wo_type = "E"
                        then do:
                           {pxmsg.i &MSGNUM=517 &ERRORLEVEL=2}
                           /*COMP NOT ON THIS WO*/
                        end. /* IF clc_comp_issue */
                        /*COMPLIANCE MODULE RESTRICTS COMP ISSUE*/
                        else do:
                           {pxmsg.i &MSGNUM=517 &ERRORLEVEL=3}
                           /*COMP NOT ON THIS WO*/
                           undo select-part, retry.
                        end. /* ELSE DO */
                     end. /*IF firstpass*/

                     create wod_det.
                     assign
                        wod_lot      = wo_lot
                        wod_nbr      = wo_nbr
                        wod_part     = part
                        wod_op       = op
                        wod_site     = wo_site
                        {&WOISRC01-P-TAG6}
                        wod_iss_date = wo_rel_date.

                     if recid(wod_det) = -1
                     then
                        .

                  end. /* IF NOT AVAILABLE wod_det */

                  if new wod_det
                  then
                     wod_loc = pt_loc.

                  find pt_mstr
                     where pt_part = wod_part
                     no-lock no-error.
                  if not available pt_mstr
                  then do:
                     {pxmsg.i &MSGNUM=16 &ERRORLEVEL=2}
                     display
                        part
                        " " @ pt_um
                        " " @ pt_desc1
                     with frame d.
                     ptum = "".
                  end. /* IF NOT AVAILABLE pt_mstr */
                  else do:
                     display
                        wod_part @ part
                        pt_um
                        pt_desc1
                     with frame d.
                     ptum = pt_um.
                  end. /* ELSE DO */

                  assign
                     qopen            = if wod_qty_req >= 0
                                        then
                                           max(min(wod_qty_req - wod_qty_iss,
                                                   wod_qty_req) ,0)
                                        else
                                           min(max(wod_qty_req - wod_qty_iss,
                                                   wod_qty_req) ,0)
                     lotserial_control = "".
                  if available pt_mstr
                  then
                     lotserial_control = pt_lot_ser.

                  assign
                     site      = ""
                     location  = ""
                     lotserial = ""
                     lotref    = "".

                  if firstpass
                  then
                     lotserial_qty = wod_qty_chg.

                  if not firstpass
                  then
                     lotserial_qty = wod_qty_chg + lotserial_qty.

                  assign
                     cline       = string(wod_part,"x(18)") + string(wod_op)
                     global_part = wod_part.

                  find first lad_det
                     where lad_dataset = "wod_det"
                     and   lad_nbr     = wod_lot
                     and   lad_line    = string(wod_op)
                     and   lad_part    = wod_part
                     no-lock no-error.
                  if available lad_det
                  then do:
                     assign
                        site      = lad_site
                        location  = lad_loc
                        lotserial = lad_lot
                        lotref    = lad_ref.

                     find next lad_det
                        where lad_dataset = "wod_det"
                        and   lad_nbr     = wod_lot
                        and   lad_line    = string(wod_op)
                        and   lad_part    = wod_part
                        no-lock no-error.
                     if available lad_det
                     then
                        assign
                           multi_entry = yes
                           site        = ""
                           location    = ""
                           lotserial   = ""
                           lotref      = "".
                  end. /* IF AVAILABLE lad_det */
                  else do:
                     assign
                        site     = wod_site
                        location = wod_loc.
                  end. /* ELSE DO */

                  locloop:
                  do on error undo, retry
                     on endkey undo select-part, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


                     wod_recno = recid(wod_det).
                MULTI_ENTRY = YES.
                DISP MULTI_ENTRY WITH FRAME D.
                     {&WOISRC01-P-TAG7}
                     update
                        lotserial_qty
                        sub_comp
                        cancel_bo
                        site
                        location
                        lotserial
                        lotref PATH1
                       /* multi_entry*/
                        {&WOISRC01-P-TAG8}
                     with frame d editing:
                        assign
                           global_site = input site
                           global_loc  = input location
                           global_lot  = input lotserial.
                        readkey.
                        apply lastkey.
                     end. /* UPDATE */

                     if sub_comp
                     then do:
                        if can-find (first pts_det
                           where pts_part = wod_part
                           and   pts_par  = "")
                        or can-find (first pts_det
                           where pts_part = wod_part
                           and   pts_par  = wo_part)
                        then do:
                           {gprun.i ""wosumt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                           if keyfunction(lastkey) = "END-ERROR"
                           then
                              undo, retry.
                           firstpass = no.
                           next frame-d-loop.
                        end. /* IF CAN-FIND */
                        else do with frame d:
                           /* APPROVED ALTERNATE ITEM DOES NOT EXIST */
                           {pxmsg.i &MSGNUM=545 &ERRORLEVEL=3}
                           next-prompt sub_comp.
                           undo, retry.
                        end. /* ELSE DO */
                     end. /* IF sub_comp */

                     if can-find (first lad_det
                        where lad_dataset = "wod_det"
                        and   lad_nbr     = wod_lot
                        and   lad_line    = string(wod_op)
                        and   lad_part    = wod_part)
                     and not can-find (lad_det
                        where lad_dataset = "wod_det"
                        and lad_nbr       = wod_lot
                        and lad_line      = string(wod_op)
                        and lad_part      = wod_part)
                     then
                        multi_entry = yes.

                     total_lotserial_qty = wod_qty_chg.

                     if multi_entry
                     then do:
                        wod_qty_chg = lotserial_qty.
                        {gprun.i ""XXiclad01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                        /* TO VALIDATE NO OVERISSUE */
                        {gprun.i ""woisrc1e.p""
                           "(input wo_lot,
                             input wod_part,
                             output overissue_ok)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                        if not overissue_ok
                        then
                           undo locloop, retry.
                     end. /* IF multi_entry */
                     else do:

                        if lotserial_qty <> 0
                        then do:

                           total_partqty = lotserial_qty.

                           for each lad_det
                              fields (lad_dataset lad_line lad_loc lad_lot
                                      lad_nbr lad_part lad_qty_chg lad_ref
                                      lad_site)
                              where lad_dataset = "wod_det"
                              and   lad_nbr     = wod_lot
                              and   lad_line    <> string(wod_op)
                              and   lad_part    = part
                              and   lad_site    = site
                              and   lad_loc     = location
                              and   lad_ref     = lotref
                              and   lad_lot     = lotserial
                           no-lock:
                              total_partqty = total_partqty +
                                              lad_qty_chg.
                           end. /* FOR EACH lad_det */

                           {gprun.i ""icedit.p""
                              "(input ""ISS-WO"",
                                input site,
                                input location,
                                input global_part,
                                input lotserial,
                                input lotref,
                                input total_partqty,
                                input ptum,
                                input """",
                                input """",
                                output yn )" }
/*GUI*/ if global-beam-me-up then undo, leave.


                           if yn
                           then
                              undo locloop, retry.

                           if site <> wo_site
                           then do:
                              {gprun.i ""icedit4.p""
                                 "(input ""ISS-WO"",
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
                                   output yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                              if yn
                              then
                                 undo locloop, retry.
                           end. /* IF site <> wo_site */

                        end. /* IF lotserial_qty <> 0 */

                        find first lad_det
                           where lad_dataset = "wod_det"
                             and lad_nbr     = wod_lot
                             and lad_line    = string(wod_op)
                             and lad_part    = wod_part
                        exclusive-lock no-error.

                        if available lad_det
                        then do:
                           assign
                              savsite     = lad_site
                              savloc      = lad_loc
                              savlot      = lad_lot
                              savref      = lad_ref
                              lad_qty_chg = 0.
                        end. /* IF AVAILABLE lad_det */

                        if lotserial_qty = 0
                        then do:
                           if available lad_det
                           then do:
                              lad_qty_chg = 0.
                           end. /* IF AVAILABLE lad_det */
                        end. /* IF lotserial_qty = 0 */
                        else do:
                           find lad_det
                              where lad_dataset = "wod_det"
                              and   lad_nbr     = wod_lot
                              and   lad_line    = string(wod_op)
                              and   lad_part    = wod_part
                              and   lad_site    = site
                              and   lad_loc     = location
                              and   lad_lot     = lotserial
                              and   lad_ref     = lotref
                           exclusive-lock no-error.
                           if not available lad_det
                           then do:
                              create lad_det.
                              assign
                                 lad_dataset = "wod_det"
                                 lad_nbr     = wod_lot
                                 lad_line    = string(wod_op)
                                 lad_site    = site
                                 lad_loc     = location
                                 lad_lot     = lotserial
                                 lad_ref     = lotref
                                 lad_part    = wod_part.
                           end. /* IF NOT AVAILABLe lad_det */

                           lad_qty_chg = lotserial_qty.

                           if recid(lad_det) = -1
                           then
                              .

                        end. /* ELSE DO */

                        total_lotserial_qty = lotserial_qty.

                     end.  /* ELSE (NOT multi_entry) */

                     /* DELETE LOCATION ALLOCATION DETAIL (lad_det) */
                     /* RECORD WHEN lad_qty_all, lad_qty_pick AND   */
                     /* lad_qty_chg ARE ALL ZERO                    */

                     for each lad_det
                        exclusive-lock
                        where lad_dataset  = "wod_det"
                        and   lad_nbr      = wod_lot
                        and   lad_line     = string(wod_op)
                        and   lad_part     = wod_part
                        and   lad_qty_all  = 0
                        and   lad_qty_pick = 0
                        and   lad_qty_chg  = 0:

                        delete lad_det.

                     end. /* FOR EACH lad_det */

                     {&WOISRC01-P-TAG9}
                     wod_qty_chg = total_lotserial_qty.

                     if cancel_bo
                     then
                        wod_bo_chg = 0.
                     else
                        if wod_qty_req <> 0
                        then
                           wod_bo_chg = wod_qty_req - wod_qty_iss - wod_qty_chg.

                     if wod_qty_req >= 0
                     then
                        wod_bo_chg = max(wod_bo_chg,0).
                     if wod_qty_req < 0
                     then
                        wod_bo_chg = min(wod_bo_chg,0).

                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* locloop */

                  leave.

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* frame-d-loop */

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* select-part */

         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


            yn = yes.

            /* Identify context for QXtend */
            {gpcontxt.i
               &STACKFRAG = 'woisrc01,wowoisrc'
               &FRAME = 'yn' &CONTEXT = 'A'}

            /*V8+*/

                 
            /* DISPLAY ITEMS BEING ISSUED? */
            {mfgmsg10.i 636 1 yn}
              

            /* Clear context for QXtend */
            {gpcontxt.i
               &STACKFRAG = 'woisrc01,wowoisrc'
               &FRAME = 'yn'}

            if yn = yes
            then do:

               hide frame d no-pause.

               {&WOISRC01-P-TAG10}
               FORM /*GUI*/ 
               with frame e down width 80 row 7 overlay
               title color normal (getFrameTitle("ISSUE_DATA_REVIEW",78)) THREE-D /*GUI*/.

               {&WOISRC01-P-TAG11}

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame e:handle).

               clear frame e all no-pause.
               view frame e.

               /* THE JOINS ARE BROKEN INTO MULTIPLE "FOR EACH" */
               /* FOR EACH TABLE TO IMPROVE ORACLE PERFORMANCE  */
               /* SO THAT `QUANTITY TO ISSUE' FOR THE LAST      */
               /* UPDATED ITEM IS DISPLAYED CORRECTLY           */
               for each wod_det
                  fields(wod_bo_chg wod_iss_date wod_loc
                         wod_lot wod_nbr wod_op wod_part
                         wod_qty_chg wod_qty_iss wod_qty_req
                         wod_site)
                  where wod_lot = wo_lot
                  {&WOISRC01-P-TAG12}
                  no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

                  {&WOISRC01-P-TAG13}

                  for each lad_det
                     fields(lad_dataset lad_line lad_loc
                            lad_lot lad_nbr lad_part
                            lad_qty_chg lad_ref lad_site)
                      where lad_dataset = "wod_det"
                      and lad_nbr       = wod_lot
                      and lad_line      = string(wod_op)
                      and lad_part      = wod_part
                      and lad_qty_chg   <> 0
                      no-lock
                  with frame e:

                     display
                        lad_part
                        lad_site
                        lad_loc
                        lad_lot
                        lad_ref
                        lad_qty_chg.
                     down 1 with frame e.

                  end. /* FOR EACH lad_det */
                  {gpwait.i &INSIDELOOP=yes &FRAMENAME=e}
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH wod_det */
               {gpwait.i &OUTSIDELOOP=yes}

               end. /* IF yn = YES */

            leave.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* REPEAT */

         do on endkey undo setd, leave seta:
            yn = yes.
            /*V8+*/

                 
            /* IS ALL INFORMATION CORRECT */
            {mfgmsg10.i 12 1 yn}

            /* Clear context for QXtend */
            {gpcontxt.i
               &STACKFRAG = 'woisrc01,wowoisrc'
               &FRAME = 'yn'}

            if yn = ?
            then do:
               outta_here = yes.
               undo setd, leave seta.
            end. /* IF yn = ? */
              
         end. /* DO */
         end. /* IF pModifyBackflush */

         if not pModifyBackflush
         then
            yn = yes.

         /*VALIDATE THAT NO OVERISSUE HAS OCCURED BEGIN ADD*/
         if yn
         then do:
            {gprun.i ""woisrc1e.p""
               "(input wo_lot,
                 input ""*"",
                 output overissue_ok)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            if not overissue_ok
            then
               assign
                  pModifyBackflush = yes
                  yn               = no.
         end. /* IF yn */

         if yn
         then do:

            setd-action = 0.

            {gprun.i ""woisrc1b.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


            if setd-action = 1
            then
               undo setd, retry setd.
            if setd-action = 2
            then
               next setd.

            /* ADDED A CALL TO icedit4.p AS ALL THE VALIDATIONS OF */
            /* icedit4.p WERE SKIPPED IF THE USER ACCEPTED THE     */
            /* DEFAULTS AND EXITED (F4) NOT PROCESSING THE         */
            /* INDIVIDUAL LINES.                                   */
            l_error = no.

            for each wod_det
               fields(wod_bo_chg  wod_iss_date   wod_loc
                      wod_lot     wod_nbr        wod_op
                      wod_part    wod_qty_chg    wod_qty_iss
                      wod_qty_req wod_site)
               where wod_lot = wo_lot
               no-lock,
               each sr_wkfl
                  fields(sr_userid sr_lineid sr_site
                         sr_loc    sr_lotser sr_ref
                         sr_qty)
                  where sr_userid = mfguser
                    and sr_lineid = string(wod_part,"x(18)")
                                    + string(wod_op)
                    and sr_qty    <> 0.00
                  no-lock:

               for first pt_mstr
                  fields(pt_desc1 pt_loc pt_lot_ser pt_part pt_um)
                  where pt_part = wod_part
                  no-lock:
               end. /* FOR FIRST pt_mstr ... */

               ptum = "".
               if available(pt_mstr)
               then
                  ptum = pt_um.

               if (wo_site <> sr_site)
               then do:
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
/*GUI*/ if global-beam-me-up then undo, leave.


                  if yn
                  then do:
                     l_error = yes.
                     /* FOR ITEM/SITE/LOCATION: #/#/#/# */
                     {pxmsg.i &MSGNUM=16 &ERRORLEVEL=1
                              &MSGARG1=trim(substring(sr_lineid,1,18))
                              &MSGARG2=sr_site
                              &MSGARG3=sr_loc
                              &MSGARG4sr_lotser}
                  end. /* IF yn     */
               end. /* IF (wo_site <> sr_site)  */
            end. /* FOR EACH WOD_DET */

            if l_error
            then
               undo setd, retry setd.

            hide frame d.
            hide frame e.
            leave setd.

         end. /* IF yn */

         else do:
            find first wod_det
               where wod_lot = wo_lot
               no-lock no-error.
            if available wod_det
            then
               wod_recno = recid(wod_det).
         end. /* ELSE DO */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* SETD */

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION ON ERROR UNDO, RETRY */

   leave.

end. /* seta */

/* Clear context for QXtend */
{gpcontxt.i
   &STACKFRAG = 'woisrc01,wowoisrc'
   &FRAME = 'yn'}

hide frame e.
hide frame d.
