/* wowoisc.p - WORK ORDER ISSUE WITH SERIAL NUMBERS - ISSUE COMPONENTS        */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.39.1.1 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      CREATED:       05/01/96   BY: *G1MN* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 05/13/96   BY: *G1TT* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: *J137* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 03/14/97   BY: *G2JJ* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 05/02/97   BY: *H0YS* Russ Witt          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 12/07/99   BY: *L0M1* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 03/08/00   BY: *L0TF* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *M0PQ* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1      LAST MODIFIED: 11/01/00   BY: *M0VP* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0WT* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 12/12/00   BY: *L16J* Thomas Fernandes   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.19          BY: Seema Tyagi        DATE: 05/28/01  ECO: *N0Z8* */
/* Revision: 1.21          BY: Vandna Rohira      DATE: 09/18/01  ECO: *M1LJ* */
/* Revision: 1.23          BY: Ashish Maheshwari  DATE: 07/17/02  ECO: *N1GJ* */
/* Revision: 1.24          BY: A.R. Jayaram       DATE: 08/08/02  ECO: *N1QY* */
/* Revision: 1.25          BY: K Paneesh          DATE: 11/14/02  ECO: *N1ZG* */
/* Revision: 1.27          BY: Anitha Gopal       DATE: 03/28/03  ECO: *P0PG* */
/* Revision: 1.28          BY: Narathip W.        DATE: 04/29/03  ECO: *P0QN* */
/* Revision: 1.30          BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00N* */
/* Revision: 1.33          BY: Shoma Salgaonkar   DATE: 10/09/03  ECO: *P15S* */
/* Revision: 1.37          BY: Ken Casey          DATE: 02/19/04  ECO: *N2GM* */
/* Revision: 1.38          BY: Max Iles           DATE: 07/08/04  ECO: *N2VQ* */
/* Revision: 1.39          BY: Pankaj Goswami     DATE: 11/15/04  ECO: *P2V2* */
/* $Revision: 1.39.1.1 $            BY: Manjusha Inglay    DATE: 03/22/05  ECO: *P3D7* */
/* By: Neil Gao Date: 07/04/18 ECO: * ss 20070418.1 * */
/* By: Neil Gao Date: 07/06/06 ECO: * ss 20070606.1 * */
/*By: Neil Gao 08/03/28 ECO: *SS 20080328* */
/*By: Neil Gao 08/08/23 ECO: *SS 20080823* */

/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*DISPLAY TITLE */
{mfdeclre.i }

{cxcustom.i "WOWOISC.P"}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowoisc_p_1 "Substitute"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_2 "Qty Picked"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_3 "Qty Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_4 "Qty to Iss"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_5 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_6 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_7 "Op"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_8 "Loc"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_9 "Qty Alloc"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_10 "Qty B/O"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoisc_p_11 "Cancel B/O"
/* MaxLen: Comment: */

/*********** End Translatable Strings Definitions ********* */

define input parameter  wo-op    as   integer.
define output parameter undo-all like mfc_logical.

define variable undo-input  like mfc_logical.
define variable qopen       like wod_qty_all column-label {&wowoisc_p_3}.
define variable yn          like mfc_logical.
define variable i           as   integer.
define variable sub_comp    like mfc_logical label {&wowoisc_p_1}.
define variable firstpass   like mfc_logical.
define variable cancel_bo   like mfc_logical
   label {&wowoisc_p_11}.
define variable op               like wod_op.
define variable msg-counter      as   integer        no-undo.
define variable overissue_ok     like mfc_logical    no-undo.
define variable lineid_list      as   character      no-undo.
define variable currid           as   character      no-undo.
define variable l_remove_srwkfl  like mfc_logical    no-undo.
define variable l_overissue_yn   like mfc_logical    no-undo.
define variable prompt_for_op    like mfc_logical    no-undo.
define variable l_error          like mfc_logical    no-undo.
define variable l_temp_from_part like pt_part        no-undo.
define variable l_temp_to_part   like pt_part        no-undo.
{&WOWOISC-P-TAG3}

define new shared variable transtype           as     character
                                               initial "ISS-WO".
define     shared variable eff_date            like   glt_effdate.
define     shared variable part                like   wod_part.
define     shared variable wo_recno            as     recid.
define     shared variable site                like   sr_site      no-undo.
define     shared variable location            like   sr_loc       no-undo.
define     shared variable lotserial           like   sr_lotser    no-undo.
define     shared variable lotref              like   sr_ref format "x(8)"
                                                                   no-undo.
define     shared variable lotserial_qty       like   sr_qty       no-undo.
define     shared variable multi_entry         like   mfc_logical
                         label {&wowoisc_p_6}                      no-undo.
define     shared variable lotserial_control   as     character.
define     shared variable cline               as     character.
define     shared variable total_lotserial_qty like   wod_qty_chg.
define     shared variable trans_um            like   pt_um.
define     shared variable trans_conv          like   sod_um_conv.
define     shared variable wod_recno           as     recid.
define     shared variable lotnext             like   wo_lot_next .
define     shared variable lotprcpt            like   wo_lot_rcpt no-undo.
define     shared variable h_wiplottrace_procs as     handle      no-undo.
define     shared variable h_wiplottrace_funcs as     handle      no-undo.

/* ss 20070606.1 - b */
define var ifcheck as char label "退货原因".
define var line 	as int format ">>9".
define var xxpart like pt_part.
define var del-yn like mfc_logical .
define shared temp-table tqc
/*  field tqc_line as int */
	field tqc_part like xxqc_part
	field tqc_part1 like xxqc_part
	field tqc_qty_comp like xxqc_qty_comp
	field tqc_project like xxqc_project
	field tqc_job like xxqc_job
	field tqc_log like xxqc_autoissue label "连带" init yes
	index tqc_part tqc_part.
/*	field tqc_rmks as char format "x(16)" */.	

/* ss 20080109 - b */
DEFINE SHARED VARIABLE strLoc LIKE loc_loc.
/* ss 20080109 - e */

form 
/*	line format ">>9" label "序号" */
	xxpart
	tqc_qty_comp
	tqc_project format "x(20)"
	tqc_job
	tqc_log
/*	tqc_rmks */
with frame aa overlay 5 down width 80 /*no-attr-space*/ .
/* SET EXTERNAL LABELS */
setFrameLabels(frame aa:handle).

/* ss 20070606.1 - e */

/* FUNCTION FORWARD DECLARATIONS */
{wlfnc.i}

/* CONSTANTS DEFINITIONS */
{wlcon.i}

{&WOWOISC-P-TAG1}

{&WOWOISC-P-TAG4}

/* ss 20070418.1 - b */
/*
form with frame c 5 down no-attr-space width 80.
*/
form with frame c 4 down no-attr-space width 80.
/* ss 20070418.1 - e */
{&WOWOISC-P-TAG5}

for first clc_ctrl
   fields( clc_domain clc_comp_issue)
    where clc_ctrl.clc_domain = global_domain no-lock:
end. /* FOR FIRST clc_ctrl */

{&WOWOISC-P-TAG6}
form
   part           colon 13
   op                        label {&wowoisc_p_7}
   site           colon 53
   location       colon 68   label {&wowoisc_p_8}
   pt_desc1       colon 13
   lotserial      colon 53
   lotserial_qty  colon 13
   pt_um          colon 31
   lotref         colon 53
   sub_comp       colon 13
   cancel_bo      colon 31
   multi_entry    colon 53
/* ss 20070606.1 */
   ifcheck
/* ss 20070606.1 */
with frame d
side-labels
width 80
attr-space.
{&WOWOISC-P-TAG7}

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
setFrameLabels(frame d:handle).

pause 0.
/*SS 20081007 - B*/
/*
view frame c.

view frame d.
*/
/*SS 20081007 - E*/
{&WOWOISC-P-TAG8}
pause before-hide.

undo-all = yes.

/* ss 20070606.1 - b */
for each tqc : delete tqc. end.
/* ss 20070606.1 - e */

mainloop:
do transaction on endkey undo, leave:

   find wo_mstr
      where recid(wo_mstr) = wo_recno
/*SS 20080328 - B*/
/*
      exclusive-lock.
*/
			no-lock.
/*SS 20080328 - E*/

   setd:
   do while true:

/*SS 20081007 - B*/
/*
      /* DISPLAY DETAIL */
      select-part:
      repeat:

         clear frame c all no-pause.

         clear frame d no-pause.

         view frame c.

         view frame d.

         for each wod_det
            fields( wod_domain wod_bo_chg  wod_critical wod_iss_date
                    wod_loc     wod_lot      wod_nbr
                    wod_op      wod_part     wod_qty_all
                    wod_qty_chg wod_qty_iss  wod_qty_pick
                    wod_qty_req wod_site)
             where wod_det.wod_domain = global_domain and (  wod_lot   = wo_lot
            and   wod_part >= part
            and  (wod_op    = wo-op
            or    wo-op     = 0)
            ) no-lock
            by wod_lot
            by wod_part:

            if wod_qty_req >= 0
            then
               qopen = max(0, wod_qty_req - max(wod_qty_iss,0)).
            else
               qopen = min(0, wod_qty_req - min(wod_qty_iss,0)).

            display
               wod_part
               qopen        format "->>>>>>>9.9<<<<<<<"
                            label  {&wowoisc_p_3}
               wod_qty_all  format "->>>>>>>9.9<<<<<<<"
                            label  {&wowoisc_p_9}
               wod_qty_pick format "->>>>>>>9.9<<<<<<<"
                            label {&wowoisc_p_2}
               wod_qty_chg  format "->>>>>>>9.9<<<<<<<"
                            label {&wowoisc_p_4}
               wod_bo_chg   format "->>>>>>>9.9<<<<<<<"
                            label {&wowoisc_p_10}
            with frame c.

            if frame-line(c) = frame-down(c)
            then
               leave.

            down 1 with frame c.

         end. /* FOR EACH wod_det */

         /* gpiswrap.i QUERIES THE SESSION PARAMETER FOR */
         /* THE MFGWRAPPER TAG                           */
         if not {gpiswrap.i}
         then
            input clear.

         assign
            part = ""
            op   = 0.

         prompt_for_op = true.

         if index(program-name(2),'wobkfl') > 0
         or
            (
            is_wiplottrace_enabled()
         and
            is_woparent_wiplot_traced(wo_lot)
            )
         then
            prompt_for_op = false.

         if not prompt_for_op
         then do:
            op = wo-op.
            display
               op
            with frame d.
         end. /* IF NOT prompt_for_op */

         do on error undo, retry:

            set
               part
               op   when (prompt_for_op)
            with frame d
            editing:

               if frame-field = "part"
               then do:

                  recno = ?.

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp05.i wod_det wod_det
                     " wod_det.wod_domain = global_domain and wod_lot  = wo_lot
                     and (wod_op = wo-op or wo-op = 0)"
                     wod_part
                     "input part" }

                  if recno <> ?
                  then do:

                     assign
                        part = wod_part
                        op   = wod_op.

                     display
                        part
                        op
                     with frame d.

                     for first pt_mstr
                        fields( pt_domain pt_critical pt_desc1 pt_loc
                                pt_lot_ser  pt_part  pt_um)
                         where pt_mstr.pt_domain = global_domain and  pt_part =
                         wod_part
                        no-lock:
                     end. /* FOR FIRST pt_mstr */

                     if available pt_mstr
                     then
                        display
                           pt_um
                           pt_desc1
                        with frame d.

                     display
                        wod_qty_chg @ lotserial_qty
                        no          @ sub_comp
                        no          @ cancel_bo
                        ""          @ lotserial
                        wod_loc     @ location
                        wod_site    @ site
                        ""          @ multi_entry
                     with frame d.
                     {&WOWOISC-P-TAG9}

                  end. /* IF recno <> ? */

               end. /* IF FRAME-FIELD = "part" */

               else
               if frame-field = "op"
               then do:

                  /* FIND NEXT/PREVIOUS RECORD */
                  /* "input op"  WAS  op  IN mfnp05.i BELOW. */
                  {mfnp05.i wod_det wod_det
                     " wod_det.wod_domain = global_domain and wod_lot  = wo_lot
                     and wod_part = input part
                     and (wod_op = wo-op or wo-op = 0)"
                     wod_op "input op"}

                  if recno <> ?
                  then do:

                     op = wod_op.

                     display
                        op
                     with frame d.

                     display
                        wod_qty_chg @ lotserial_qty
                        no          @ sub_comp
                        no          @ cancel_bo
                        ""          @ lotserial
                        wod_loc     @ location
                        wod_site    @ site
                        ""          @ multi_entry
                     with frame d.
                     {&WOWOISC-P-TAG10}

                  end. /* IF recno <> ? */

               end. /* ELSE IF FRAME-FIELD = "op" */

               else do:
                  status input.
                  readkey.
                  apply lastkey.
               end. /* ELSE */

            end. /* SET part op WITH FRAME d EDITING */

            status input.

            if part = ""
            then
               leave.

/*SS 20080823 - B*/
						if (not can-find(first flpw_mstr  where flpw_mstr.flpw_domain = global_domain
    					and (  flpw_field   = "wod_price")) or
    					can-find (flpw_mstr  where flpw_mstr.flpw_domain = global_domain and (
    					flpw_field = "wod_price" and flpw_userid = global_userid))) then .
    				else do:
    					message "无权限修改".
    					undo,retry.
    				end.
/*SS 20080823 - E*/
            if (wo-op <> 0
            and op    <> wo-op)
            or  op     = ?
            then do:
              /* NOT A VALID CHOICE */
               {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3}
               next-prompt op with frame d.
               undo, retry.
            end. /* IF (wo-op <> 0 */

            firstpass = yes.

            frame-d-loop:
            repeat:

               assign
                  cancel_bo   = no
                  sub_comp    = no
                  multi_entry = no.

               find wod_det  where wod_det.wod_domain = global_domain and
               wod_lot  = wo_lot
                            and   wod_part = part
                            and   wod_op   = op
                            use-index wod_det
                            exclusive-lock no-error.

               if not available wod_det
               then do:

                  for first pt_mstr
                     fields( pt_domain pt_critical pt_desc1 pt_loc
                             pt_lot_ser  pt_part  pt_um)
                      where pt_mstr.pt_domain = global_domain and  pt_part =
                      part
                     no-lock:
                  end. /* FOR FIRST pt_mstr */

                  if not available pt_mstr
                  then do:
                     /* ITEM DOES NOT EXIST */
                     {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
                     undo, retry.
                  end. /* IF NOT AVAILABLE pt_mstr */

                  if firstpass
                  then do:

                     /* UNRESTRICTED COMPONENT ISSUES */
                     if clc_comp_issue
                     or wo_type = "R"
                     or wo_type = "E"
                     then do:
                        /* ITEM DOES NOT EXIST ON THIS BILL OF MATERIAL */
                        {pxmsg.i &MSGNUM=547 &ERRORLEVEL=2}
                     end. /* IF clc_comp_issue */

                     /* COMPLIANCE MODULE RESTRICTS COMP ISSUE */
                     else do:
                        /* ITEM DOES NOT EXIST ON THIS BILL OF MATERIAL */
                        {pxmsg.i &MSGNUM=547 &ERRORLEVEL=3}
                        undo select-part, retry.
                     end. /* ELSE */

                  end. /* IF firstpass */

                  create wod_det. wod_det.wod_domain = global_domain.

                  assign
                     wod_lot      = wo_lot
                     wod_nbr      = wo_nbr
                     wod_part     = part
                     wod_op       = input op
                     {&WOWOISC-P-TAG11}
                     wod_site     = wo_site
                     wod_iss_date = wo_rel_date.

                  if recid(wod_det) = -1 then .

               end. /* IF NOT AVAILABLE wod_det */

               for first pt_mstr
                  fields( pt_domain pt_critical pt_desc1 pt_loc
                          pt_lot_ser  pt_part  pt_um)
                   where pt_mstr.pt_domain = global_domain and  pt_part =
                   wod_part
                  no-lock:
               end. /* FOR FIRST pt_mstr */

               if not available pt_mstr
               then do:

                  /* ITEM DOES NOT EXIST */
                  {pxmsg.i &MSGNUM=16 &ERRORLEVEL=2}

                  display
                     part
                     " " @ pt_um
                     " " @ pt_desc1
                  with frame d.

               end. /* IF NOT AVAILABLE pt_mstr */

               else do:

                  if new wod_det
                  then
                     assign
                        wod_loc      = pt_loc
                        wod_critical = pt_critical.

                  display
                     pt_part @ part
                     pt_um
                     pt_desc1
                  with frame d.

               end. /* ELSE */

               assign
                  qopen             = wod_qty_req - wod_qty_iss
                  lotserial_control = if available pt_mstr
                                      then
                                         pt_lot_ser
                                      else ""
                  site              = ""
                  location          = ""
                  lotserial         = ""
                  lotref            = ""
                  lotserial_qty     = if firstpass
                                      then
                                         wod_qty_chg
                                      else
                                         wod_qty_chg
                                       + lotserial_qty
                  cline             =    string(wod_part,"x(18)")
                                       + string(wod_op)
                  global_part       = wod_part.

               if not can-find (first sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
               and   sr_lineid = cline)
               then
                  assign
                     site     = wod_site
                     location = wod_loc.

               else do:

                  for first sr_wkfl
                     fields( sr_domain sr_lineid sr_loc      sr_lotser
                             sr_qty    sr_ref      sr_site
                             sr_userid sr_vend_lot)
                      where sr_wkfl.sr_domain = global_domain and  sr_userid =
                      mfguser
                     and   sr_lineid = cline
                     no-lock:
                  end. /* FOR FIRST sr_wkfl */

                  if available sr_wkfl
                  then
                     assign
                        site      = sr_site
                        location  = sr_loc
                        lotserial = sr_lotser
                        lotref    = sr_ref.

                  else multi_entry = yes.

               end. /* ELSE */

               {&WOWOISC-P-TAG12}
               locloop:
               do on error undo, retry
                  on endkey undo select-part, retry:

                  wod_recno = recid(wod_det).

/* ss 20070606.1 - b */
									ifcheck = "".
/* ss 20070606.1 - e */

                  update
                     lotserial_qty
                     sub_comp
                     cancel_bo
                     site
                     location
                     lotserial
                     lotref
                     multi_entry
/* ss 20070606.1 */
   									 ifcheck
/* ss 20070606.1 */
                     {&WOWOISC-P-TAG13}
                  with frame d
                  editing:

                     assign
                        global_site = input site
                        global_loc  = input location
                        global_lot  = input lotserial.

                     readkey.
                     apply lastkey.

                  end. /* UPDATE WITH FRAME d EDITING */

                  if sub_comp
                  then do:

                     if can-find (first pts_det
                      where pts_det.pts_domain = global_domain and (  pts_part
                      = wod_part
                     and   pts_par  = ""))
                     or
                        can-find (first pts_det
                      where pts_det.pts_domain = global_domain and  pts_part =
                      wod_part
                     and   pts_par  = wo_part)
                     then do:

                        /* REFRESH VALUE OF wod_qty_chg WITH lotserial_qty */
                        /* BEFORE PASSING VALUE TO wosumt.p                */

                        wod_qty_chg = lotserial_qty.

                        {gprun.i ""wosumt.p""}

                        if keyfunction(lastkey) = "end-error"
                        then
                           undo, retry.

                        firstpass = no.

                        next frame-d-loop.

                     end. /* IF CAN-FIND (FIRST pts_det */

                     else do with frame d:
                        /* APPROVED ALTERNATE ITEM DOES NOT EXIST */
                        {pxmsg.i &MSGNUM=545 &ERRORLEVEL=3}
                        next-prompt sub_comp.
                        undo, retry.
                     end. /* ELSE DO WITH FRAME d */

                  end. /* IF sub_comp */

                  i = 0.

                  for each sr_wkfl
                     fields( sr_domain sr_lineid sr_loc      sr_lotser
                             sr_qty    sr_ref      sr_site
                             sr_userid sr_vend_lot)
                      where sr_wkfl.sr_domain = global_domain and  sr_userid =
                      mfguser
                     and   sr_lineid = cline
                     no-lock:

                     i = i + 1.

                     if i > 1
                     then do:
                        multi_entry = yes.
                        leave.
                     end. /* IF i > 1 */

                  end. /* FOR EACH sr_wkfl */

                  assign
                     total_lotserial_qty = wod_qty_chg
                     trans_um            = if available pt_mstr
                                           then
                                              pt_um
                                           else ""
                     trans_conv          = 1.

                  if multi_entry
                  then do:

                     if i >= 1
                     then
                        assign
                           site      = ""
                           location  = ""
                           lotserial = ""
                           lotref    = "".

                     assign
                        lotnext  = ""
                        lotprcpt = no.

                     /* ADDED SIXTH INPUT PARAMETER AS NO */
/*SS 20080823 - B*/
/*
                     {gprun.i ""icsrup.p"" "(input wo_site,
*/
                     {gprun.i ""xxicsrup.p"" "(input wo_site,
                                             input """",
                                             input """",
                                             input-output lotnext,
                                             input lotprcpt,
                                             input no)"}
/*SS 20080823 - E*/

                     /* SECTION TO VALIDATE NO OVERISSUE */

                     assign
                        overissue_ok     = no
                        lineid_list      = ""
                        currid           = string(part,"x(18)") +
                                           string(op)
                        l_temp_from_part = string(wod_part, "x(18)")
                        l_temp_to_part   = l_temp_from_part +
                                           hi_char.

                     for each sr_wkfl
                        fields( sr_domain sr_lineid sr_loc sr_lotser
                                sr_qty    sr_ref sr_site
                                sr_userid sr_vend_lot)
                         where sr_wkfl.sr_domain = global_domain and  sr_userid
                         = mfguser
                        and   sr_lineid >= l_temp_from_part
                        and   sr_lineid <= l_temp_to_part
                        no-lock:

                        if not can-do(lineid_list,sr_lineid)
                        then
                           lineid_list = lineid_list +
                                         sr_lineid   +
                                         ",".

                     end. /* FOR EACH sr_wkfl */

                     {gprun.i ""icoviss1.p""
                        "(input part,
                          input lineid_list,
                          input currid,
                          output overissue_ok)"
                        }

                     if not overissue_ok
                     then
                        undo, retry.

                  end. /* IF multi_entry */

                  else do:

/*SS 20080823 - B*/
											define var ires as logical.
											{gprun.i ""xxpdserial.p"" "(input lotserial,output ires)"}
											if ires then do:
												next-prompt lotserial with frame d.
												message "批/序号不符合要求".
												undo,retry.
											end.
/*SS 20080823 - B*/

                     if lotserial_qty <> 0
                     then do:

                        {gprun.i ""icedit.p""
                           "(""ISS-WO"",
                               site,
                               location,
                               global_part,
                               lotserial,
                               lotref,
                               lotserial_qty,
                               trans_um,
                               """",
                               """",
                               output undo-input)" }

                        if undo-input
                        then
                           undo, retry.

                        if wo_site <> site
                        then do:

                           {gprun.i ""icedit4.p"" "(input ""ISS-WO"",
                                                    input wo_site,
                                                    input site,
                                                    input pt_loc,
                                                    input location,
                                                    input global_part,
                                                    input lotserial,
                                                    input lotref,
                                                    input lotserial_qty,
                                                    input trans_um,
                                                    input """",
                                                    input """",
                                                    output yn)"
                              }

                           if yn
                           then
                              undo locloop, retry.

                        end. /* IF wo_site <> site */

                     end. /* IF lotserial_qty <> 0 */

                     find first sr_wkfl
                         where sr_wkfl.sr_domain = global_domain and  sr_userid
                         = mfguser
                        and   sr_lineid = cline
                        exclusive-lock no-error.

                     if lotserial_qty = 0
                     then do:

                        if available sr_wkfl
                        then do:
                           total_lotserial_qty = total_lotserial_qty -
                                                 sr_qty.
                           delete sr_wkfl.
                        end. /* IF AVAILABLE sr_wkfl */

                     end. /* IF lotserail_qty = 0 */

                     else do:

                        if available sr_wkfl
                        then
                           assign
                              total_lotserial_qty = total_lotserial_qty -
                                                    sr_qty              +
                                                    lotserial_qty
                              sr_site             = site
                              sr_loc              = location
                              sr_lotser           = lotserial
                              sr_ref              = lotref
                              sr_qty              = lotserial_qty.

                        else do:

                           create sr_wkfl. sr_wkfl.sr_domain = global_domain.

                           assign
                              sr_userid           = mfguser
                              sr_lineid           = cline
                              sr_site             = site
                              sr_loc              = location
                              sr_lotser           = lotserial
                              sr_ref              = lotref
                              sr_qty              = lotserial_qty
                              total_lotserial_qty = total_lotserial_qty +
                                                    lotserial_qty.

                           if recid(sr_wkfl) = -1 then .

                        end.  /* ELSE */

                        /* SECTION TO VALIDATE NO OVERISSUE */

                        assign
                           overissue_ok     = no
                           lineid_list      = ""
                           currid           = string(part,"x(18)") +
                                              string(op)
                           l_temp_from_part = string(wod_part, "x(18)")
                           l_temp_to_part   = l_temp_from_part +
                                              hi_char.

                        for each sr_wkfl
                           fields( sr_domain sr_lineid sr_loc      sr_lotser
                                   sr_qty    sr_ref      sr_site
                                   sr_userid sr_vend_lot)
                            where sr_wkfl.sr_domain = global_domain and
                            sr_userid  = mfguser
                           and   sr_lineid >= l_temp_from_part
                           and   sr_lineid <= l_temp_to_part
                           no-lock:

                           if not can-do(lineid_list,sr_lineid)
                           then
                              lineid_list = lineid_list +
                                            sr_lineid   +
                                            ",".

                        end. /* FOR EACH sr_wkfl */

                        {gprun.i ""icoviss1.p""
                           "(input  part,
                             input  lineid_list,
                             input  currid,
                             output overissue_ok)"
                           }

                        if not overissue_ok
                        then
                           undo, retry.

                     end. /* ELSE */

                  end. /* ELSE */

                  {&WOWOISC-P-TAG14}
                  assign
                     wod_qty_chg = total_lotserial_qty
                     wod_bo_chg  = if cancel_bo
                                   then
                                      0
                                   else
                                      wod_qty_req -
                                      wod_qty_iss -
                                      wod_qty_chg.

                  if wod_qty_req >= 0
                  then
                     wod_bo_chg = max(wod_bo_chg,0).

                  if wod_qty_req < 0
                  then
                     wod_bo_chg = min(wod_bo_chg,0).

                  if  cancel_bo
                  and not can-find (first sr_wkfl
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                  and   sr_lineid = cline)
                  then do:

                     create sr_wkfl. sr_wkfl.sr_domain = global_domain.

                     assign
                        sr_userid = mfguser
                        sr_lineid = cline
                        sr_qty    = 0
                        sr_site   = site.
                        recno     = recid(sr_wkfl).

                  end. /* IF cancel_bo */


               end. /* locloop */

               leave.

            end. /* frame-d-loop */

         end. /* DO ON ERROR, UNDO RETRY */

      end. /* select-part */
*/
/*SS 20081007 - E*/

      {&WOWOISC-P-TAG15}
      do on endkey undo mainloop, leave mainloop:

         assign
            l_remove_srwkfl = yes
            yn              = yes.

/*SS 20081007 - B*/
/*
         /*V8-*/
         /* DISPLAY ITEMS BEING ISSUED */
         {pxmsg.i &MSGNUM=636 &ERRORLEVEL=1 &CONFIRM=yn
                  &CONFIRM-TYPE='LOGICAL'}
         /*V8+*/

         /*V8!
         /* DISPLAY ITEMS BEING ISSUED */
         {mfgmsg10.i 636 1 yn}
         */


         if yn
         then do:

            hide frame c no-pause.

            hide frame d no-pause.

					 	define var iy as logical.
					
            	for each wod_det
               		fields( wod_domain wod_bo_chg  wod_critical wod_iss_date
                       wod_loc     wod_lot      wod_nbr
                       wod_op      wod_part     wod_qty_all
                       wod_qty_chg wod_qty_iss  wod_qty_pick
                       wod_qty_iss
                       wod_qty_req wod_site)
                	where wod_det.wod_domain = global_domain and  wod_lot = wo_lot
               		no-lock with frame dd width 80: 

								 	/* SET EXTERNAL LABELS */
               		setFrameLabels(frame dd:handle).
							
									iy = no.
                	for  each sr_wkfl
                  	fields( sr_domain sr_lineid sr_loc      sr_lotser
                          sr_qty    sr_ref      sr_site
                          sr_userid sr_vend_lot)
                   	where sr_wkfl.sr_domain = global_domain and  sr_userid =	mfguser
                  				and   sr_lineid = string(wod_part,"x(18)") +  string(wod_op)
                  	no-lock
										break by sr_lineid by substring(sr_lotser,10,6):
                  
            
										iy = yes.
              			/* ss 20080103 - b */
										/*	
               			display
                  					wod_part
                  					sr_site
                  					sr_loc
                  					sr_lotser
                  					sr_ref format "x(8)" column-label {&wowoisc_p_5}
                 						sr_qty.
               			*/
               			accumu sr_qty (total by substring(sr_lotser,10,6)).
										if last-of( substring(sr_lotser,10,6) ) then do:
               				find first pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error.
               				find first vd_mstr where vd_domain = global_domain and vd_addr = substring(sr_lotser,10,6) no-lock no-error.
               				find first cd_det where cd_domain = global_domain and cd_ref = wod_part and cd_type = "SC" and cd_lang = "ch"
               					no-lock no-error.               		
               				display
               					wod_part
               					pt_desc1 when (avail pt_mstr) format "x(16)"
               					substring(sr_lotser,10,6) label "供应商"
               					vd_sort format "x(8)" label "名称"
               					accumulate total by substring(sr_lotser,10,6) sr_qty label "发料量"
               					with frame dd.
               		
               				if avail cd_det then do:
               					find first pt_mstr where pt_domain = global_domain and pt_part = substring(cd_cmmt[1],1,4) no-lock no-error.
               					if avail pt_mstr then disp pt_desc1 @ pt_desc2 format "x(10)" with frame dd.
               				end.
               				down with frame dd.
               				/*
               				{gpwait.i &INSIDELOOP=yes &FRAMENAME=dd}*/
              			end.
              
            			/*end.*/
            	
            			end.  /* for each sr_hist */
            			
            			if not iy and ( wod_loc = strloc ) and wod_qty_req > wod_qty_iss then do:
            				find first pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error.
/*SS 20081117 - B*/
/*
										if avail pt_mstr and pt_article <> strloc and strloc <> "" then next.
*/
/*SS 20081117 - E*/
            				disp wod_part	pt_desc1 when (avail pt_mstr) format "x(16)"	with frame dd.
            				find first cd_det where cd_domain = global_domain and cd_ref = wod_part and cd_type = "SC" and cd_lang = "ch"
               			no-lock no-error.
              			if avail cd_det then do:
               				find first pt_mstr where pt_domain = global_domain and pt_part = substring(cd_cmmt[1],1,4) no-lock no-error.
               				if avail pt_mstr then disp pt_desc1 @ pt_desc2 format "x(10)" with frame dd.
               				down with frame dd.
              			end.
              			/*
            				{gpwait.i &INSIDELOOP=yes &FRAMENAME=dd}*/
            			end.
            			
            
            	end. /* FOR EACH wod_det */
            
            	{gpwait.i &OUTSIDELOOP=yes}
         end. /* IF yn */

         /*V8!
         else
         if yn = ?
         then
            undo mainloop, leave mainloop.
         */
*/
/*SS 20081007 - E*/


      end. /* DO ON ENDKEY UNDO mainloop, LEAVE mainloop */

      do on endkey undo mainloop, leave mainloop:

         /* Identify context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'wowoisc,wowois'
            &FRAME = 'yn' &CONTEXT = 'INFO'}

         /*V8-*/
         yn = yes.

/*SS 20081007 - B*/
/*
         /* IS ALL INFORMATION CORRECT */
         {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn
                  &CONFIRM-TYPE='LOGICAL'}
*/
/*SS 20081007 - E*/
         /*V8+*/

         /*V8!
         yn = yes.

         /* IS ALL INFORMATION CORRECT */
         {mfgmsg10.i 12 1 yn}
         if yn = ?
         then
            undo mainloop, leave mainloop.
         */

         /* Clear context for QXtend */
         {gpcontxt.i
            &STACKFRAG = 'wowoisc,wowois'
            &FRAME = 'yn'}

         l_remove_srwkfl = no.

         if yn
         then do:

            {&WOWOISC-P-TAG2}

            /* CODE TO VALIDATE OVERISSUE WHEN DEFAULT ISSUE       */
            /* QTY IS ACCEPTED DIRECTLY WITHOUT ANY MODIFICATION   */
            assign
               currid         = "-99"
               l_overissue_yn = no.

            for each wod_det
               fields( wod_domain wod_bo_chg  wod_critical wod_iss_date wod_loc
                       wod_lot     wod_nbr      wod_op       wod_part
                       wod_qty_all wod_qty_chg  wod_qty_iss  wod_qty_pick
                       wod_qty_req wod_site)
                where wod_det.wod_domain = global_domain and  wod_lot = wo_lot
               no-lock
               break by wod_part:

               if first-of(wod_part)
               then do:

                  assign
                     overissue_ok     = no
                     lineid_list      = ""
                     l_temp_from_part = string(wod_part, "x(18)")
                     l_temp_to_part   = l_temp_from_part +
                                        hi_char.

                  for each sr_wkfl
                     fields( sr_domain sr_lineid sr_loc    sr_lotser
                             sr_qty    sr_ref    sr_site
                             sr_userid sr_vend_lot)
                      where sr_wkfl.sr_domain = global_domain and  sr_userid  =
                      mfguser
                     and   sr_lineid >= l_temp_from_part
                     and   sr_lineid <= l_temp_to_part
                     no-lock:

                     if not can-do(lineid_list,sr_lineid)
                     then
                        lineid_list = lineid_list +
                                      sr_lineid   +
                                      ",".

                  end. /* FOR EACH sr_wkfl ... */

                  {gprun.i ""icoviss1.p"" "(input wod_part,
                                            input lineid_list,
                                            input currid,
                                            output overissue_ok)"
                  }

                  if not overissue_ok
                  then
                     l_overissue_yn = yes.

               end. /* IF FIRST-OF (wod_det) */

            end. /* FOR EACH wod_det ... */

            if l_overissue_yn
            then
               next setd.

            /* ADDED A CALL TO icedit4.p AS ALL THE VALIDATIONS OF */
            /* DEFAULTS AND EXITED (F4) NOT PROCESSING THE         */
            /* INDIVIDUAL LINES.                                   */

            l_error = no.

            for each wod_det
               fields( wod_domain wod_bo_chg   wod_iss_date   wod_loc
                      wod_lot      wod_nbr        wod_op
                      wod_part     wod_qty_chg    wod_qty_iss
                      wod_critical wod_qty_all    wod_qty_pick
                      wod_qty_req  wod_site)
                where wod_det.wod_domain = global_domain and  wod_lot = wo_lot
               no-lock,
                   each sr_wkfl
                  fields( sr_domain sr_userid sr_lineid sr_site
                         sr_loc    sr_lotser sr_ref
                         sr_qty    sr_vend_lot)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                  and   sr_lineid = string(wod_part,"x(18)") +
                                    string(wod_op)
                  and   sr_qty    <> 0.00
                  no-lock:

               for first pt_mstr
                  fields( pt_domain pt_critical pt_desc1 pt_loc
                         pt_lot_ser  pt_part  pt_um)
                   where pt_mstr.pt_domain = global_domain and  pt_part =
                   wod_part
                  no-lock:
               end. /* FOR FIRST pt_mstr ... */

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
                       input pt_um,
                       input """",
                       input """",
                       output yn)"}

                  if yn
                  then do:

                     l_error = yes.

                     /* FOR ITEM: # SITE: # LOCATION: # */
                      {pxmsg.i &MSGNUM=4578 &ERRORLEVEL=1
                                &MSGARG1=trim(substring(sr_lineid,1,18))
                                &MSGARG2=sr_site
                                &MSGARG3=sr_loc
                                &MSGARG4=sr_lotser}

                  end. /* IF yn */

               end. /* IF wo_site <> sr_site */

            end. /* FOR EACH wod_det */

            if l_error
            then
               undo mainloop, retry mainloop.

            {gplock.i &domain="wo_mstr.wo_domain = global_domain and "
               &file-name     = wo_mstr
               &find-criteria = "recid(wo_mstr) = wo_recno"
               &exit-allowed  = yes
               &record-id     = recno}

            /*V8-*/
            if keyfunction(lastkey) = "end-error"
            then do:

               for first wo_mstr
                  fields( wo_domain wo_lot      wo_nbr  wo_part
                          wo_rel_date wo_site wo_type)
                  where recid(wo_mstr) = wo_recno
                  no-lock:
               end. /* FOR FIRST wo_mstr */

               next setd.

            end. /* IF KEYFUNCTION(LASTKEY) = "END-ERROR" */

            /*V8+*/

            if not available wo_mstr
            then do:
               /*  WORK ORDER/ID DOES NOT EXIST.*/
               {pxmsg.i &MSGNUM=510 &ERRORLEVEL=4}
               leave mainloop.
            end. /* IF NOT AVAILABLE wo_mstr */


            /* ADDED SECTION TO DO FINAL ISSUE CHECK */

            {icintr2.i "sr_userid = mfguser"
               transtype
               right-trim(substring(sr_lineid,1,18))
               trans_um
               undo-input
               """use pt_mstr"""
               }

            if undo-input
            then do:
               /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
               {pxmsg.i &MSGNUM=161 &ERRORLEVEL=3
                        &MSGARG1=substring(sr_lineid,1,18)}
               next setd.
            end. /* IF undo-input */

            hide frame c.

            hide frame d.

            leave setd.

         end. /* IF yn */

         /*V8!
         else
         if not yn
         then do:

            for first wo_mstr
               fields (wo_lot      wo_nbr  wo_part
                       wo_rel_date wo_site wo_type)
               where recid(wo_mstr) = wo_recno
               no-lock:
            end. /* FOR FIRST wo_mstr */

            next setd.

         end. /* IF NOT yn */

         else
            leave mainloop.
         */

      end. /* DO ON ENDKEY UNDO mainloop, LEAVE mainloop */

   end. /* setd */

   undo-all = no.

end. /* mainloop */

/* Clear context for QXtend */
{gpcontxt.i
   &STACKFRAG = 'wowoisc,wowois'
   &FRAME = 'yn'}

hide frame dd no-pause.

for each sr_wkfl
    where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
   exclusive-lock:

   sr_vend_lot = 'wowoisc.p'.

   if l_remove_srwkfl
   then
      delete sr_wkfl.

end. /* FOR EACH sr_wkfl */
