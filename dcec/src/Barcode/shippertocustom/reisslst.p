/* GUI CONVERTED from reisslst.p (converter v1.78) Fri Oct 29 14:34:00 2004 */
/* reisslst.p - REPETITIVE   SUBPROGRAM TO MODIFY COMPONENT PART ISSUE LIST   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.1.16.1.8 $                                                        */
/*V8:ConvertMode=Maintenance                                                  */
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
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *M0Q3* Vandna Rohira      */
/* revision: 9.1      LAST MODIFIED: 08/02/00   BY: *N0GD* Peggy Ng           */
/* REVISION: 9.1      LAST MODIFIED: 12/12/00   BY: *L16J* Thomas Fernandes   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.1.11      BY: Rajesh Thomas       DATE: 07/23/01 ECO: *M1FL* */
/* Revision: 1.9.1.12      BY: Kirti Desai         DATE: 11/01/01 ECO: *N151* */
/* Revision: 1.9.1.13      BY: Kirti Desai         DATE: 02/08/02 ECO: *M1TV* */
/* Revision: 1.9.1.14      BY: Hareesh V           DATE: 10/11/02 ECO: *N1X2* */
/* Revision: 1.9.1.15      BY: Subramanian Iyer    DATE: 12/10/02 ECO: *N21V* */
/* Revision: 1.9.1.16      BY: Narathip W.         DATE: 04/21/03 ECO: *P0Q9* */
/* Revision: 1.9.1.16.1.3  BY: Subramanian Iyer    DATE: 10/22/03 ECO: *P13Q* */
/* Revision: 1.9.1.16.1.7  BY: Mike Dempsey        DATE: 11/27/03 ECO: *N2GM* */
/* $Revision: 1.9.1.16.1.8 $ BY: Dayanand Jethwa      DATE: 04/28/04  ECO: *P1YJ* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* TAKEN FROM reisrc01.p */

{mfdeclre.i}
{cxcustom.i "REISSLST.P"}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

{wndvar2.i "new shared"}

define input parameter cumwo_lot as character.
define input parameter wopart    as character.
define input parameter wosite    as character.
define input parameter eff_date  as date.
define input parameter wkctr     as character.
define input parameter qty_comp  as decimal.

define output parameter undo_stat like mfc_logical no-undo.

define new shared variable parent_assy       like pts_par.
define new shared variable part              like wod_part.
define new shared variable wopart_wip_acct   like pl_wip_acct.
define new shared variable wopart_wip_sub    like pl_wip_sub.
define new shared variable wopart_wip_cc     like pl_wip_cc.
define new shared variable site              like sr_site              no-undo.
define new shared variable location          like sr_loc               no-undo.
define new shared variable lotserial         like sr_lotser            no-undo.
define new shared variable lotref            like sr_ref format "x(8)" no-undo.
define new shared variable lotserial_qty     like sr_qty               no-undo.
define new shared variable  multi_entry      as   logical
   label "Multi Entry"                                                 no-undo.
define new shared variable lotserial_control as character.
define new shared variable cline             as character.
define new shared variable row_nbr           as integer.
define new shared variable col_nbr           as integer.
define new shared variable issue_or_receipt  as character.

define new shared variable total_lotserial_qty like wod_qty_chg.
define new shared variable wo_recid            as   recid.
define new shared variable pk_recno            as   recid.
define new shared variable comp                like ps_comp.
define new shared variable fill_all            like mfc_logical
   label "Issue Alloc" initial no.
define new shared variable fill_pick           like mfc_logical
   label "Issue Picked" initial yes.
define new shared variable trans_um            like pt_um.
define new shared variable trans_conv          like sod_um_conv.
define new shared variable transtype           as   character.
define new shared variable h_ui_proc           as   handle        no-undo.

define variable wfirst   as   logical     initial yes       no-undo.
define variable nbr      like wo_nbr.
define variable qopen    like wod_qty_all label "Qty Open".
define variable yn       like mfc_logical.
define variable ref      like glt_ref.
define variable desc1    like pt_desc1.
define variable trqty    like tr_qty_chg.
define variable trlot    like tr_lot.
define variable qty_left like tr_qty_chg.
define variable del-yn   like mfc_logical initial no.

define variable tot_lad_all    like lad_qty_all.
define variable ladqtychg      like lad_qty_all.
define variable sub_comp       like mfc_logical label "Substitute".
define variable cancel_bo      like mfc_logical label "Cancel B/O".
define variable default_cancel like cancel_bo.
define variable ptum           like pt_um                          no-undo.
define variable iss_loc        like pk_loc.
define variable rejected       like mfc_logical.
define variable op             like wod_op.

define variable l_error          like mfc_logical no-undo.
define variable l_sr_site        like sr_site     no-undo.
define variable l_delete_sr_wkfl like mfc_logical no-undo.
define variable l_update_sr_wkfl like mfc_logical no-undo.
define variable l_sr_lineid      like sr_lineid   no-undo.
define variable lotnext          like wo_lot_next.
define variable lotprcpt         like wo_lot_rcpt no-undo.

{&REISSLST-P-TAG1}

/* TEMP-TABLE t_sr_wkfl STORES THE LIST OF DEFAULT sr_wkfl      */
/* RECORDS (NOT MODIFIED BY THE USER)                           */
/* t_sr_wkfl RECORD IS DELETED WHEN THE DEFAULT sr_wkfl RECORD  */
/* IS MODIFIED. DURING MULTI-ENTRY, IF t_sr_wkfl RECORD EXISTS, */
/* DELETE DEFAULT sr_wkfl RECORD TO AVOID MANUAL DELETION.      */

define temp-table t_sr_wkfl no-undo
   field t_sr_lineid like sr_lineid
   index t_sr_lineid is unique t_sr_lineid.

define buffer ptmstr for pt_mstr.

define variable datainput as character format "x(20)" no-undo.

issue_or_receipt = getTermLabel("ISSUE",8).

{&REISSLST-P-TAG2}
FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part           colon 13
         View-as fill-in size 18 by 1   
   op
   wosite         colon 58 label "Site"
   pt_desc1       colon 13
   location       colon 58 label "Loc"
   pt_desc2       colon 13 no-label
   lotserial      colon 58
   lotserial_qty  colon 13
   pt_um                   no-label
   lotref         colon 58
   sub_comp       colon 13
   path1
    multi_entry    colon 58
 SKIP(.4)  /*GUI*/
with overlay frame d side-labels width 80 attr-space row 14 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/

{&REISSLST-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* INITIALISE TEMP-TABLE t_sr_wkfl */
for each t_sr_wkfl
   exclusive-lock:

   delete t_sr_wkfl.

end. /* FOR EACH t_sr_wkfl */

assign
   undo_stat = yes
   {&REISSLST-P-TAG4}
   site      = wosite
   iss_loc   = "".

if can-find (loc_mstr
   where loc_loc  = wkctr
   and   loc_site = wosite)
then
   iss_loc = wkctr.

for first clc_ctrl
   fields(clc_comp_issue)
   no-lock:
end. /* FOR FIRST clc_ctrl */

if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


   for first clc_ctrl
      fields(clc_comp_issue)
      no-lock:
   end. /* FOR FIRST clc_ctrl */

end. /* IF NOT AVAILABLE clc_ctrl */

do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

   for each sr_wkfl
      where sr_userid = mfguser
      and   sr_lineid begins "-"
   exclusive-lock:
         delete sr_wkfl.
   end. /* FOR EACH sr_wkfl */

   for each pk_det
      fields(pk_loc pk_part pk_qty pk_reference pk_user)
      where pk_user = mfguser
      no-lock:

      l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

      find sr_wkfl
         where sr_userid = mfguser
         and   sr_lineid = l_sr_lineid
         and   sr_site   = wosite
         and   sr_loc    = pk_loc
         exclusive-lock no-error.

      for first ptmstr
         fields(pt_desc1 pt_desc2 pt_loc pt_lot_ser pt_part pt_um)
         where ptmstr.pt_part = pk_part
         no-lock:
      end. /* FOR FIRST ptmstr */

      {gprun.i ""icedit2.p"" "(input ""ISS-WO"",
                               input wosite,
                               input pk_loc,
                               input ptmstr.pt_part,
                               input """",
                               input """",
                               input pk_qty + if available sr_wkfl
                                              then
                                                 sr_qty
                                              else
                                                 0,
                               input ptmstr.pt_um,
                               input """",
                               input """",
                               output rejected)"
      }
/*GUI*/ if global-beam-me-up then undo, leave.


      if rejected
      then do on endkey undo , retry:
         /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
         {pxmsg.i &MSGNUM=161 &ERRORLEVEL=2
                  &MSGARG1=ptmstr.pt_part}
      end. /* IF rejected */

      /* DEFAULT sr_wkfl RECORD IS STORED IN TEMP-TABLE t_sr_wkfl */
      if not available sr_wkfl
      then do:

         create sr_wkfl.
         create t_sr_wkfl.

         assign
            sr_userid   = mfguser
            sr_lineid   = l_sr_lineid
            sr_site     = wosite
            sr_loc      = pk_loc
            sr_lotser   = ""
            sr_ref      = ""
            t_sr_lineid = l_sr_lineid.

         if recid(sr_wkfl) = -1
         then
            .

      end. /* IF NOT AVAILABLE sr_wkfl */

      if available sr_wkfl
      then
         sr_qty = sr_qty + pk_qty.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH pk_det */
end. /* DO TRANSACTION */

seta:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

   do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

      setd:
      repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


         clear frame d.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
         view frame d.

         select-part:
         repeat on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


            if batchrun = no
            then do:

               for first pk_det
               where pk_user = mfguser
               exclusive-lock:
               end.

               datainput = getFrameTitle("ISSUE_DATA_INPUT",20).
               assign
                  wfirst     = yes
                  window_row = 6.

               {windowxt.i
                  &file = pk_det
                  &display = "pk_part pk_reference pk_qty"
                  &index-fld1 = pk_part
                  &use-index1 = "use-index pk_det"
                  &index-fld2 = pk_part
                  &use-index2 = "use-index pk_det"
                  &frametitle = datainput
                  &window-down = 5
                  &framephrase = "width 80"
                  &where1 = "where pk_user = mfguser"
                  &where2 = "where true"
                  &and = "(pk_user = mfguser)"
                  &time-out = 0
                  }

               if keyfunction(lastkey) <> "END-ERROR" then
                  view frame w.

               assign
                  wfirst   = no
                  pk_recno = window_recid.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF batchrun = no */

            if keyfunction(lastkey) = "END-ERROR"
            then
               leave.
            clear frame d.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.

            do on error undo , retry with frame d:
               assign
                  part = ""
                  op   = 0.

               if pk_recno <> ?
               then do:

                  for first pk_det
                     fields(pk_loc pk_part pk_qty pk_reference pk_user)
                     where recid(pk_det) = pk_recno
                     no-lock:
                  end. /* FOR FIRST pk_det */

                  if available pk_det
                  then
                     assign
                        op   = integer(pk_reference)
                        part = pk_part.
               end. /* IF pk_recno */

               display
                  part
                  op.

               for first pt_mstr
                  fields(pt_desc1 pt_desc2 pt_loc pt_lot_ser pt_part pt_um)
                  where pt_part = part
                  no-lock:
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST pt_mstr */

               if available pt_mstr
               then
                  display
                     pt_desc1
                     pt_desc2.
               else
                  display
                     "" @ pt_desc1
                     "" @ pt_desc2.

               trans_um = "".
               if available pt_mstr
               then
                  trans_um = pt_um.

               trans_conv = 1.

               /* CONDITION ADDED TO IMPROVE PERFORMANCE IN DESKTOP 2 */
               if not {gpiswrap.i}
               then
                  input clear.

               get-part:
               do on error undo , retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                  set
                     part
                     op
                     with frame d editing:

                     if frame-field = "part"
                     then do:
                        {mfnp01.i pk_det
                                  part
                                  pk_part
                                  mfguser
                                  pk_user
                                  pk_det}

                        if recno <> ?
                        then do:
                           assign
                              part = pk_part
                              op   = integer(pk_reference).

                           display
                              part
                              op
                           with frame d.

                           for first pt_mstr
                              fields(pt_desc1 pt_desc2 pt_loc pt_lot_ser
                                     pt_part pt_um)
                              where pt_part = part
                              no-lock:
                           end. /* FOR FIRST pt_mstr */

                           if available pt_mstr
                           then do:
                              display
                                 pt_um
                                 pt_desc1
                                 pt_desc2
                              with frame d.
                           end. /* IF AVAILABLE pt_mstr */
                        end. /* IF recno <> ? */
                     end. /* IF framefield = "part" */
                     else do:
                        ststatus = stline[3].
                        status input ststatus.
                        readkey.
                        apply lastkey.
                     end. /* ELSE DO */
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* SET */

                  for first wr_route
                     fields(wr_lot wr_op)
                     where wr_lot = cumwo_lot
                     and   wr_op  = op
                     no-lock:
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST wr_route */

                  if not available wr_route
                  then do:
                     /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
                     {pxmsg.i &MSGNUM=106 &ERRORLEVEL=3}
                     next-prompt op.
                     undo, retry.
                  end. /* IF NOT AVAILABLE wr_route */

                  status input.

                  if part = ""
                  then
                     leave.

                  frame-d-loop:
                  repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

                     pause 0.
                     assign
                        sub_comp    = no
                        multi_entry = no.

                     find first pk_det
                        where pk_user      = mfguser
                        and   pk_part      = part
                        and   pk_reference = string(op)
                     exclusive-lock no-error.

                     if not available pk_det
                     then do:
                        if clc_active
                        then do:

                           if clc_comp_issue
                           then do:

                              /* ITEM DOES NOT EXIST ON THIS BILL OF MATL */
                              {pxmsg.i &MSGNUM=547 &ERRORLEVEL=2}
                           end. /* IF clc_comp_issue */
                           else do:

                              /* COMPLIANCE MODULE RESTRICTS COMP ISSUE   */
                              /* ITEM DOES NOT EXIST ON THIS BILL OF MATL */
                              {pxmsg.i &MSGNUM=547 &ERRORLEVEL=3}
                              undo select-part, retry.
                           end. /* ELSE DO */
                        end. /* IF clc_active */
                        else
                           /* ITEM DOES NOT EXIST ON THIS BILL OF MATL */
                           {pxmsg.i &MSGNUM=547 &ERRORLEVEL=2}.

                        create pk_det.
                        assign
                           pk_user      = mfguser
                           pk_part      = part
                           pk_reference = string(op).

                        if recid(pk_det) = -1
                        then
                           .
                     end. /* IF NOT AVAILABLE pk_det */

                     for first pt_mstr
                        fields(pt_desc1 pt_desc2 pt_loc pt_lot_ser
                               pt_part pt_um)
                        where pt_part = part
                        no-lock:
                     end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST pt_mstr */

                     if not available pt_mstr
                     then do:
                        {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
                        undo get-part , retry get-part.

                        display
                           part " " @ pt_um
                           " " @ pt_desc1
                           " " @ pt_desc2
                        with frame d.
                        ptum = "".
                     end. /* IF NOT AVAILABLE pt_mstr */
                     else do:
                        if new pk_det
                        then
                           pk_loc = pt_loc.
                        if iss_loc <> ""
                        then
                           pk_loc = iss_loc.
                        else
                           pk_loc = pt_loc.

                        display
                           pt_part @ part
                           pt_um
                           pt_desc1
                           pt_desc2
                        with frame d.

                        ptum = pt_um.
                     end. /* ELSE DO */
                     assign
                        qopen             = pk_qty
                        lotserial_control = "".

                     if available pt_mstr
                     then
                        lotserial_control = pt_lot_ser.

                     assign
                        location      = ""
                        lotserial     = ""
                        lotref        = ""
                        lotserial_qty = pk_qty
                        cline         = "-" + string(pk_part,"x(18)")
                                            + pk_reference
                        global_part   = pk_part.

                     for first sr_wkfl
                        fields(sr_lineid sr_loc sr_lotser sr_qty sr_ref
                               sr_site sr_userid)
                        where sr_userid = mfguser
                        and   sr_lineid = cline
                        no-lock:
                     end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST sr_wkfl */

                     if available sr_wkfl
                     then do:

                        for first sr_wkfl
                           fields(sr_lineid sr_loc sr_lotser sr_qty sr_ref
                                  sr_site sr_userid)
                           where sr_userid = mfguser
                           and   sr_lineid = cline
                           no-lock:
                        end. /* FOR FIRST sr_wkfl */

                        if available sr_wkfl
                        then
                           assign
                              wosite    = sr_site
                              location  = sr_loc
                              lotserial = sr_lotser
                              lotref    = sr_ref.
                        else
                           multi_entry  = yes.
                     end. /* IF AVAILABLE sr_wkfl */
                     else
                        location = pk_loc.

                     do on error undo, retry
                        on endkey undo select-part, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


                        pk_recno = recid(pk_det).
                  multi_entry = YES.
                  DISP multi_entry WITH FRAME d.
                        update
                           lotserial_qty
                           sub_comp
                           wosite
                           location
                           lotserial
                           lotref
                          /* multi_entry*/ path1
                           {&REISSLST-P-TAG5}
                        with frame d
                        editing:
                           assign
                              global_site = input wosite
                              global_loc  = input location
                              global_lot  = input lotserial
                              ststatus    = stline[3].
                           status input ststatus.
                           readkey.
                           apply lastkey.
                        end. /* UPDATE */

                        {&REISSLST-P-TAG6}
                        if sub_comp
                        then do:
                           if can-find (first pts_det
                              where pts_part = pk_part
                              and   pts_par  = "")
                              or can-find (first pts_det
                                 where pts_part = pk_part
                                 and   pts_par  = wopart)
                           then do:

                              for first wo_mstr
                                 fields(wo_lot wo_part)
                                 where wo_lot = cumwo_lot
                                 no-lock:
                              end. /* FOR FIRST wo_mstr */

                              {gprun.i ""resumt1.p"" "(input wo_part)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                              if keyfunction(lastkey) = "END-ERROR"
                              then
                                 undo , retry.

                              for first pt_mstr
                                 fields(pt_desc1 pt_desc2 pt_loc pt_lot_ser
                                        pt_part pt_um)
                                 where pt_part = part
                                 no-lock:
                              end. /* FOR FIRST pt_mstr */

                              if not available pt_mstr
                              then do:
                                 /* ITEM NUMBER DOES NOT EXIST */
                                 {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
                                 undo seta , retry seta.
                              end. /* IF NOT AVAILABLE pt_mstr */

                              find pk_det
                                 where pk_user = mfguser
                                 and   pk_part = part
                                 exclusive-lock no-error.

                              if not available pk_det
                              then do:
                                 create pk_det.
                                 assign
                                    pk_user      = mfguser
                                    pk_part      = part
                                    pk_reference = string(op).

                                 if recid(pk_det) = -1
                                 then
                                    .
                                 if iss_loc <> ""
                                 then
                                    pk_loc = iss_loc.
                                 else
                                    pk_loc = pt_loc.
                              end. /* IF NOT AVAILABLE pk_det */

                              pk_qty = pk_qty + lotserial_qty.

                              {&REISSLST-P-TAG7}
                              find sr_wkfl
                                 where sr_userid = mfguser
                                 and   sr_lineid = cline
                                 and   sr_site   = wosite
                                 and   sr_loc    = pk_loc
                                 and   sr_lotser = ""
                                 and   sr_ref    = ""
                                 exclusive-lock no-error.

                              if not available sr_wkfl
                              then do:
                                 create sr_wkfl.

                                 assign
                                    sr_userid = mfguser
                                    sr_lineid = cline
                                    sr_site   = wosite
                                    sr_loc    = pk_loc.

                                 if recid(sr_wkfl) = -1
                                 then
                                    .

                                 if not can-find(first t_sr_wkfl
                                    where t_sr_lineid = cline)
                                 then do:

                                    create t_sr_wkfl.
                                    t_sr_lineid = cline.

                                 end. /* IF NOT CAN-FIND(FIRST ... */

                              end. /* IF NOT AVAILABLE sr_wkfl */

                              sr_qty = sr_qty + lotserial_qty.

                              next frame-d-loop.
                           end. /* IF CAN-FIND */

                           else do with frame d:
                              /* APPROVED ALTERNATE ITEM DOES NOT EXIST */
                              {pxmsg.i &MSGNUM=545 &ERRORLEVEL=3}
                              next-prompt sub_comp.
                              undo , retry.
                           end. /* ELSE DO */
                        end. /* IF sub-comp */

                        if can-find (first sr_wkfl
                           where sr_userid = mfguser and sr_lineid = cline)
                           and not can-find (sr_wkfl
                           where sr_userid = mfguser and sr_lineid = cline)
                           then
                              multi_entry = yes.

                        total_lotserial_qty = pk_qty.

                        if multi_entry
                        then do:

                           assign
                              l_delete_sr_wkfl = no
                              l_update_sr_wkfl = no
                              transtype        = "ISS-WO"
                              lotnext          = lotserial
                              lotprcpt         = no.

                           if available pt_mstr
                           then
                              trans_um = pt_um.

                           /* DEFAULT CREATED sr_wkfl RECORD IS     */
                           /* DELETED TO AVOID DELETING IT MANUALLY */
                           /* IN MULTI ENTRY SCREEN                 */

                           for first t_sr_wkfl
                              where t_sr_lineid = cline
                              no-lock:

                              find first sr_wkfl
                                 where sr_userid  = mfguser
                                 and   sr_lineid  = t_sr_lineid
                                 and   sr_loc     = pk_loc
                                 and   sr_ref     = ""
                                 and   sr_lot     = ""
                                 and   sr_qty     = pk_qty
                                 exclusive-lock no-error.

                              if available sr_wkfl
                              then do:

                                 /* STORING VALUE IN l_sr_site    */
                                 /* TO RE-CREATE DEFAULT sr_wkfl  */
                                 assign
                                    l_sr_site        = sr_site
                                    l_delete_sr_wkfl = yes.

                                 delete sr_wkfl.

                              end. /* IF AVAILABLE sr_wkfl */

                           end. /* FOR FIRST t_sr_wkfl */

                           {gprun.i ""xxicsrup1.p""       /*peter*/
                              "(input        wosite,
                                input        """",
                                input        """",
                                input-output lotnext,
                                input        lotprcpt,
                                input-output l_update_sr_wkfl)"
                              }
/*GUI*/ if global-beam-me-up then undo, leave.


                           /* RE-CREATE DEFAULT sr_wkfl, IF sr_wkfl */
                           /* IS NOT UPDATED IN MULTI ENTRY SCREEN. */
                           /* SO THIS RECORD IS DISPLAYED WHEN      */
                           /* "DISPLAY ITEMS BEING ISSUED" = YES    */
                           /* AND INVENTORY VALIDATION CAN BE DONE. */

                           if l_delete_sr_wkfl
                           then do:

                              if not l_update_sr_wkfl
                              then do:

                                 if not can-find(first sr_wkfl
                                        where sr_userid = mfguser
                                        and   sr_lineid = cline)
                                 then do:

                                    create sr_wkfl.

                                    assign
                                       sr_userid           = mfguser
                                       sr_lineid           = cline
                                       sr_site             = l_sr_site
                                       sr_loc              = pk_loc
                                       sr_lotser           = ""
                                       sr_ref              = ""
                                       sr_qty              = pk_qty
                                       total_lotserial_qty = pk_qty.

                                    if recid(sr_wkfl) = -1
                                    then
                                       .

                                 end. /* IF NOT CAN-FIND(FIRST ... */

                              end. /* IF NOT l_update_sr_wkfl */

                              else do:

                                 /* DELETE TEMP-TABLE RECORD TO   */
                                 /* INDICATE DEFAULT sr_wkfl IS   */
                                 /* UPDATED IN MULTI-ENTRY SCREEN */

                                 find first t_sr_wkfl
                                    where sr_lineid = cline
                                    exclusive-lock no-error.

                                 if available t_sr_wkfl
                                 then
                                    delete t_sr_wkfl.

                              end. /* ELSE DO */

                              l_delete_sr_wkfl = no.

                           end. /* IF l_delete_sr_wkfl */

                        end. /* IF multi-entry */
                        else do:

                           if lotserial_qty <> 0
                           then do:
                              {gprun.i ""icedit.p"" "(input ""ISS-WO"",
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

                              if rejected
                              then
                                 undo, retry.
                           end. /* IF lotserial_qty */

                           find first sr_wkfl
                              where sr_userid = mfguser
                              and   sr_lineid = cline
                              exclusive-lock no-error.

                           if lotserial_qty = 0
                           then do:

                              if available sr_wkfl
                              then
                                 assign
                                    total_lotserial_qty = total_lotserial_qty
                                                           - sr_qty
                                    sr_qty              = 0.

                           end. /* IF lotserial_qty = 0 */
                           else do:
                              if not available sr_wkfl
                              then do:
                                 create sr_wkfl.
                                 assign
                                    sr_userid = mfguser
                                    sr_lineid = cline.

                              if recid(sr_wkfl) = -1
                              then
                                 .
                              end. /* IF NOT AVAILABLE sr_wkfl */

                              /* DELETE TEMP-TABLE RECORD TO */
                              /* INDICATE DEFAULT CREATED    */
                              /* RECORD IS MODIFIED          */

                              find first t_sr_wkfl
                                 where t_sr_lineid = cline
                                 exclusive-lock no-error.

                              if available t_sr_wkfl
                              then
                                 delete t_sr_wkfl.

                              assign
                                 total_lotserial_qty = lotserial_qty
                                 sr_site             = wosite
                                 sr_loc              = location
                                 sr_lotser           = lotserial
                                 sr_ref              = lotref
                                 sr_qty              = lotserial_qty.
                           end. /* ELSE DO */
                        end. /* ELSE DO */

                        pk_qty = total_lotserial_qty.
                        {&REISSLST-P-TAG8}
                        if lotserial_qty <> 0
                        then do:
                           {gprun.i ""reoptr1f.p""
                                    "(input pk_part,
                                      output yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                           if yn
                           then
                              undo, retry.
                        end. /* IF lotserial_qty <> 0 */
                     end. /* DO */

                     leave.
                  end. /* FRAME-D-LOOP */
               end. /* GET-PART */
            end. /* DO */
         end. /* SELECT-PART */

         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

            yn = yes.

            /* Identify context for QXtend */
            {gpcontxt.i
               &STACKFRAG = 'reisslst,rebkfl'
               &FRAME = 'yn' &CONTEXT = 'DISPITEM'}

            /* DISPLAY ITEMS BEING ISSUED */
            {pxmsg.i &MSGNUM=636 &ERRORLEVEL=1
                     &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}

            /* Clear context for QXtend */
            {gpcontxt.i
               &STACKFRAG = 'reisslst,rebkfl'
               &FRAME = 'yn'}

            if yn = yes
            then do:

               hide frame d no-pause.
               FORM /*GUI*/ 
                  with frame e down width 80
                  title color normal getFrameTitle("ISSUE_DATA_REVIEW",80) THREE-D /*GUI*/.


               /* SET EXTERNAL LABELS */
               setFrameLabels(frame e:handle).

               for each pk_det
                  fields(pk_loc pk_part pk_qty pk_reference pk_user)
                  where pk_user = mfguser
                  no-lock:

                  l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

                  for each sr_wkfl
                     fields(sr_lineid sr_loc sr_lotser sr_qty sr_ref
                            sr_site sr_userid)
                     where sr_userid = mfguser
                     and   sr_lineid = l_sr_lineid
                     and   sr_qty <> 0
                     no-lock
                     with frame e:

                     display
                        pk_part
                        sr_site
                        sr_loc
                        sr_lotser
                        sr_ref format "x(8)"
                        column-label "Ref"
                        sr_qty.
                     down.
                  end. /* FOR EACH sr_wkfl */
               end. /* FOR EACH pk_det */
               view frame e.

            end. /* IF yn = yes */

            leave.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* REPEAT */

         do on endkey undo seta , leave seta:
            yn = yes.
            /*V8+*/
                        {mfgmsg10.i 12 1 yn}
            if yn = ?
            then
               undo seta, leave seta.   
         end. /* DO */

         if yn
         then do:

            /* ADDED A CALL TO icedit4.p AS ALL THE VALIDATIONS OF */
            /* icedit4.p WERE SKIPPED IF THE USER ACCEPTED THE     */
            /* DEFAULTS AND EXITED (F4) NOT PROCESSING THE         */
            /* INDIVIDUAL LINES.                                   */

            l_error = no.

            for each pk_det
               fields(pk_loc pk_part pk_qty pk_reference pk_user)
               where pk_user = mfguser
               no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


               l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

               for each sr_wkfl fields(sr_userid sr_lineid sr_site
                                       sr_loc    sr_lotser sr_ref sr_qty)
                  where sr_userid = pk_user
                  and   sr_lineid = l_sr_lineid
                  and   sr_qty    <> 0.00
               no-lock:

                  for first pt_mstr
                     fields(pt_desc1 pt_desc2 pt_loc pt_lot_ser
                            pt_part  pt_um)
                     where pt_part = pk_part
                  no-lock:
                  end. /* FOR FIRST pt_mstr ... */

                  ptum = "".
                  if available(pt_mstr)
                  then
                     ptum = pt_um.

                  if (site <> sr_site)
                  then do:
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


                     if yn
                     then do:
                        l_error = yes.

                        /* FOR ITEM/SITE/LOCATION: #/#/#/# */
                        {pxmsg.i &MSGNUM=4578
                                 &ERRORLEVEL=1
                                 &MSGARG1=trim(substring(sr_lineid,2,18))
                                 &MSGARG2=sr_site
                                 &MSGARG3=sr_loc
                                 &MSGARG4=sr_lotser}

                     end. /* IF yn     */
                  end. /* IF (site <> sr_site) */
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH sr_wkfl */
            end. /* FOR EACH pk_det */

            if l_error then
               undo seta, retry seta.

            for each pk_det
               fields(pk_loc pk_part pk_qty pk_reference pk_user)
               where pk_user = mfguser
               no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


               l_sr_lineid = "-" + string(pk_part,"x(18)") + pk_reference.

               for each sr_wkfl
                  fields(sr_lineid sr_loc sr_lotser sr_qty sr_ref
                         sr_site sr_userid)
                  where sr_userid = mfguser
                  and   sr_lineid = l_sr_lineid
                  and   sr_qty    <> 0
                  no-lock:

                  for first pt_mstr
                     fields(pt_desc1 pt_desc2 pt_loc pt_lot_ser pt_part pt_um)
                     where pt_part = pk_part
                     no-lock:
                  end. /* FOR FIRST pt_mstr */

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


                  if rejected
                  then do:
                     /* UNABLE TO ISSUE OR RECEIVE FOR ITEM   */
                     {pxmsg.i &MSGNUM=161 &ERRORLEVEL=3 &MSGARG1=pk_part}
                     next setd.
                  end. /* IF rejected */

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* for each sr_wkfl */
            end. /* for eack pk_det */

            hide frame d.
            hide frame e.
            undo_stat = no.
            leave seta.

         end. /* IF yn */

      end. /* SETD */

   end. /* DO */

end. /* REPEAT */

for each t_sr_wkfl
   exclusive-lock:

   delete t_sr_wkfl.

end. /* FOR EACH t_sr_wkfl */

hide frame d.
