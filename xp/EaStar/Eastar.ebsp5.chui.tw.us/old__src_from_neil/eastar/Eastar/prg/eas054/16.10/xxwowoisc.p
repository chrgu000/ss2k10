/* wowoisc.p - WORK ORDER ISSUE WITH SERIAL NUMBERS - ISSUE COMPONENTS        */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                       */
/* REVISION: 8.5        CREATED: 05/01/96       BY: *G1MN* Julie Milligan     */
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
/* REVISION: 9.1      LAST MODIFIED: 05/28/01   BY: *N0Z8* Seema Tyagi        */
/* REVISION: 9.1      LAST MODIFIED: 09/18/01   BY: *M1LJ* Vandna Rohira      */
/******************************************************************************/

         /*DISPLAY TITLE */
         {mfdeclre.i }
/*N0WT*/ {cxcustom.i "WOWOISC.P"}
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

/* ********** End Translatable Strings Definitions ********* */

/*J137*/ define input parameter wo-op as integer.
         define output parameter undo-all like mfc_logical.

         define     shared variable part like wod_part.

         define variable undo-input like mfc_logical.
         define variable qopen like wod_qty_all column-label {&wowoisc_p_3}.
         define variable yn like mfc_logical.

         define     shared variable eff_date like glt_effdate.

/*M1LJ** define variable ref like glt_ref.                   */
/*M1LJ** define variable desc1 like pt_desc1.                */

         define variable i as integer.

/*M1LJ** define variable trqty like tr_qty_chg.              */
/*M1LJ** define variable trlot like tr_lot.                  */
/*M1LJ** define variable qty_left like tr_qty_chg.           */
/*M1LJ** define variable del-yn like mfc_logical initial no. */

         define     shared variable wo_recno as recid.
         define     shared variable site like sr_site no-undo.
         define     shared variable location like sr_loc no-undo.
         define     shared variable lotserial like sr_lotser no-undo.
         define     shared variable lotref like sr_ref format "x(8)" no-undo.
         define     shared variable lotserial_qty like sr_qty no-undo.
      /* define     shared variable multi_entry as logical              **M0PQ*/
         define     shared variable multi_entry like mfc_logical        /*M0PQ*/
            label {&wowoisc_p_6}
            no-undo.
         define     shared variable lotserial_control as character.
         define     shared variable cline as character.
         define     shared variable total_lotserial_qty like wod_qty_chg.
         define     shared variable trans_um like pt_um.
         define     shared variable trans_conv like sod_um_conv.
         define     shared variable transtype as character initial "ISS-WO".
        define shared var v_trchr01 like pt_part  .  /*davild-20051206*/
/*M1LJ** define variable tot_lad_all like lad_qty_all. */
/*M1LJ** define variable ladqtychg like lad_qty_all.   */

         define variable sub_comp like mfc_logical label {&wowoisc_p_1}.

         define     shared variable wod_recno as recid.

         define variable firstpass like mfc_logical.

      /* define variable cancel_bo as logical                           **M0PQ*/
         define variable cancel_bo like mfc_logical                     /*M0PQ*/
            label {&wowoisc_p_11}.

         define variable op like wod_op.

/*J137*  define variable wo-op like wod_op label "Op".  */
/*M1LJ** define buffer woddet for wod_det.              */

         define variable msg-counter as integer no-undo.
/*G1TT*/ define variable overissue_ok like mfc_logical no-undo.
/*G1TT*/ define variable lineid_list as character no-undo.
/*G1TT*/ define variable currid as character no-undo.

/*M1LJ** define variable wolot like wo_lot.                */
/*M1LJ** define variable issue_component like mfc_logical. */

/*L0TF*/ define variable l_remove_srwkfl like mfc_logical no-undo.
/*M0VP*/ define variable l_overissue_yn  like mfc_logical no-undo.
         define     shared variable lotnext like wo_lot_next .
         define     shared variable lotprcpt like wo_lot_rcpt no-undo.
/*N002*/ define variable prompt_for_op like mfc_logical no-undo.
/*N002*/ define shared variable h_wiplottrace_procs as handle no-undo.
/*N002*/ define shared variable h_wiplottrace_funcs as handle no-undo.
/*N002*/ {wlfnc.i} /* FUNCTION FORWARD DECLARATIONS */
/*N002*/ {wlcon.i} /* CONSTANTS DEFINITIONS         */

/*L16J*/ define variable l_error like mfc_logical   no-undo.

/*M1LJ*/ define variable l_temp_from_part like pt_part no-undo.
/*M1LJ*/ define variable l_temp_to_part   like pt_part no-undo.

/*N0WT*/ {&WOWOISC-P-TAG1}
         form with frame c 5 down no-attr-space width 80.
         find first clc_ctrl no-lock no-error.

         form
            part           colon 13
            op label {&wowoisc_p_7}
            site           colon 53
            location       colon 68   label {&wowoisc_p_8}
            pt_desc1       colon 13
            lotserial      colon 53
            lotserial_qty  colon 13
            pt_um          colon 31
            lotref         colon 53
            sub_comp       colon 13
            cancel_bo      /*colon 31*/
            multi_entry    /*colon 53*/
   v_trchr01  label "³æ¾Ú½s¸¹" format "x(12)"   /*add-by-davild20051206*/
         with frame d side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame d:handle).

/*N002*/ pause 0.
/*N002*/ view frame c.
/*N002*/ view frame d.
/*N002*/ pause before-hide.

         undo-all = yes.

         mainloop:
         do transaction on endkey undo, leave:

           find wo_mstr where recid(wo_mstr) = wo_recno exclusive-lock.

             setd:
             do while true:

                /* DISPLAY DETAIL */
                select-part:
                repeat:
                   clear frame c all no-pause.
                   clear frame d no-pause.
                   view frame c.
                   view frame d.
                   for each wod_det no-lock
                   where wod_lot = wo_lot and wod_part >= part
                   and (wod_op = wo-op or wo-op = 0) by wod_lot
                   by wod_part:

                      if wod_qty_req >= 0
                      then qopen = max(0, wod_qty_req - max(wod_qty_iss,0)).
                      else qopen = min(0, wod_qty_req - min(wod_qty_iss,0)).

                      /* SET EXTERNAL LABELS */
                      setFrameLabels(frame c:handle).
                      display
                      wod_part
                      qopen          format "->>>>>>>9.9<<<<<<<"
                                     label {&wowoisc_p_3}
                      wod_qty_all    format "->>>>>>>9.9<<<<<<<"
                                     label {&wowoisc_p_9}
                      wod_qty_pick   format "->>>>>>>9.9<<<<<<<"
                                     label {&wowoisc_p_2}
                      wod_qty_chg    format "->>>>>>>9.9<<<<<<<"
                                     label {&wowoisc_p_4}
                      wod_bo_chg     format "->>>>>>>9.9<<<<<<<"
                                     label {&wowoisc_p_10}
                      with frame c.
                      if frame-line(c) = frame-down(c) then leave.
                      down 1 with frame c.
                   end.

                   input clear.

/*M1LJ**           part = "". */

/*M1LJ*/           assign
/*M1LJ*/              part = ""
                      op   = 0.

/*N002*/           prompt_for_op = true.
/*N002*/
/*N002*/           if index(program-name(2),'wobkfl') > 0
/*N002*/           or
/*N002*/           (
/*N002*/              is_wiplottrace_enabled()
/*N002*/              and
/*N002*/              is_woparent_wiplot_traced(wo_lot)
/*N002*/           )
/*N002*/           then prompt_for_op = false.
/*N002*/
/*N002*/           if not prompt_for_op then do:
/*N002*/              op = wo-op.
/*N002*/              display op with frame d.
/*N002*/           end.

                   do on error undo, retry:

                      set part
                      op
/*N002*/               when (prompt_for_op)
                      with frame d editing:
                         if frame-field = "part" then do:
/*G2JJ*/                    recno = ?.
                            /* FIND NEXT/PREVIOUS RECORD */
                            {mfnp05.i wod_det wod_det
                            "wod_lot = wo_lot
                             and (wod_op = wo-op or wo-op = 0)"
                             wod_part
                             "input part" }

                            if recno <> ? then do:

/*M1LJ**                       part = wod_part. */

/*M1LJ*/                       assign
/*M1LJ*/                          part = wod_part
                                  op   = wod_op.

                               display part
                                  op
                               with frame d.
                               find pt_mstr
                               where pt_part = wod_part no-lock no-error.

                               if available pt_mstr then do:
                                  display pt_um pt_desc1 with frame d.
                               end.

                               display wod_qty_chg @ lotserial_qty
                               no @ sub_comp no @ cancel_bo
                               "" @ lotserial wod_loc @ location
                               wod_site @ site "" @ multi_entry
                               with frame d.

                            end.
                         end.
                         /* Added section */
                         else if frame-field = "op" then do:
                            /* FIND NEXT/PREVIOUS RECORD */
                            /* "input op"  was  op  in mfnp05.i below. */
                            {mfnp05.i wod_det wod_det
                            "wod_lot = wo_lot and wod_part = input part
                             and (wod_op = wo-op or wo-op = 0)"
                             wod_op "input op"}
                            if recno <> ? then do:
                               op = wod_op.

                               display op with frame d.

                               display wod_qty_chg @ lotserial_qty
                               no @ sub_comp no @ cancel_bo
                               "" @ lotserial wod_loc @ location
                               wod_site @ site "" @ multi_entry
                               with frame d.

                            end.
                         end.
                         /* End of added section */
                         else do:
                            status input.
                            readkey.
                            apply lastkey.
                         end.
                      end.
                      status input.

                      if part = "" then leave.

                      /* Added section */
/*G1TT*                      if wo-op <> 0 and op <> wo-op then do: */
/*G1TT*/              if (wo-op <> 0 and op <> wo-op) or op = ? then do:
                         {mfmsg.i 13 3}
                         next-prompt op with frame d.
                         undo, retry.
                      end.
                      /* End of added section */

                      firstpass = yes.

                      frame-d-loop:
                      repeat:

/*M1LJ**                 cancel_bo = no. */
/*M1LJ**                 sub_comp = no.  */

/*M1LJ*/                 assign
/*M1LJ*/                    cancel_bo   = no
/*M1LJ*/                    sub_comp    = no
                            multi_entry = no.

                         find wod_det where wod_lot   = wo_lot
                                      and   wod_part  =  part
                                      and   wod_op    = op
/*M1LJ**                              no-error. */
/*M1LJ*/                              use-index wod_det
/*M1LJ*/                              exclusive-lock no-error.

                         if not available wod_det then do:

                            find pt_mstr
                            where pt_part =  part no-lock no-error.
                            if not available pt_mstr then do:
                               {mfmsg.i 16 3}
                               undo, retry.
                            end.

                            /* Begin added block */
                            if firstpass then do:
                               /*UNRESTRICTED COMPONENT ISSUES*/
                               if clc_comp_issue
                               or wo_type = "R" or wo_type = "E" then do:
                               /* ITEM DOES NOT EXIST ON THIS BILL OF MAT'L */
                                  {mfmsg.i 547 2}
                               end.
                               /*COMPLIANCE MODULE RESTRICTS COMP ISSUE*/
                               else do:
                               /* ITEM DOES NOT EXIST ON THIS BILL OF MAT'L */
                                  {mfmsg.i 547 3}
                                  undo select-part, retry.
                               end.
                            end.
                            /* End added block */

                            create wod_det.
                            assign
                            wod_lot = wo_lot
                            wod_nbr = wo_nbr
                            wod_part = part
                            wod_op = input op
                            wod_site = wo_site.
                            wod_iss_date = wo_rel_date.
                            if recid(wod_det) = -1 then .
                         end. /*NOT AVAILABLE WOD_DET*/
                         find pt_mstr
                         where pt_part = wod_part no-lock no-error.
                         if not available pt_mstr then do:
                            {mfmsg.i 16 2}
                            display part " " @ pt_um " " @ pt_desc1
                            with frame d.
                         end.
                         else do:
                            if new wod_det then
                            assign wod_loc = pt_loc
                              wod_critical = pt_critical.

                            display pt_part @ part pt_um pt_desc1
                            with frame d.
                         end.

/*M1LJ**  BEGIN DELETE
 *                       qopen = wod_qty_req - wod_qty_iss.
 *
 *                       lotserial_control = "".
 *                       if available pt_mstr then
 *                          lotserial_control = pt_lot_ser.
 *                       site = "".
 *                       location = "".
 *                       lotserial = "".
 *                       lotref = "".
 *
 *                       if firstpass then
 *                          lotserial_qty = wod_qty_chg.
 *
 *                       if not firstpass then
 *                          lotserial_qty = wod_qty_chg + lotserial_qty.
 *
 *                       cline = string(wod_part,"x(18)") + string(wod_op).
 *M1LJ** END DELETE  */

/*M1LJ*/                 assign
/*M1LJ*/                    qopen             = wod_qty_req - wod_qty_iss
/*M1LJ*/                    lotserial_control = if available pt_mstr
/*M1LJ*/                                        then
/*M1LJ*/                                           pt_lot_ser
/*M1LJ*/                                        else ""
/*M1LJ*/                    site              = ""
/*M1LJ*/                    location          = ""
/*M1LJ*/                    lotserial         = ""
/*M1LJ*/                    lotref            = ""
/*M1LJ*/                    lotserial_qty     = if firstpass
/*M1LJ*/                                        then
/*M1LJ*/                                           wod_qty_chg
/*M1LJ*/                                        else
/*M1LJ*/                                           wod_qty_chg + lotserial_qty
/*M1LJ*/                    cline             =    string(wod_part,"x(18)")
/*M1LJ*/                                         + string(wod_op)
                            global_part       = wod_part.

                         if not can-find (first sr_wkfl
                         where sr_userid = mfguser
/*M1LJ**                 and sr_lineid = cline) then do: */
/*M1LJ*/                 and sr_lineid = cline)
/*M1LJ*/                 then

/*M1LJ**                    site = wod_site.             */

/*M1LJ*/                    assign
/*M1LJ*/                       site     = wod_site
                               location = wod_loc.

/*M1LJ**                 end.                            */

                         else do:

                            find sr_wkfl where sr_userid = mfguser
                            and sr_lineid = cline no-lock no-error.

/*M1LJ** BEGIN DELETE
 *
 *                          if available sr_wkfl then do:
 *                             site = sr_site.
 *                             location = sr_loc.
 *                             lotserial = sr_lotser.
 *                             lotref = sr_ref.
 *                          end.
 *
 *M1LJ** END DELETE */

/*M1LJ*/                    if available sr_wkfl
/*M1LJ*/                    then
/*M1LJ*/                       assign
/*M1LJ*/                          site      = sr_site
/*M1LJ*/                          location  = sr_loc
/*M1LJ*/                          lotserial = sr_lotser
/*M1LJ*/                          lotref    = sr_ref.

                            else multi_entry = yes.

                         end.

                         locloop:
                         do on error undo, retry
                         on endkey undo select-part, retry:

                            wod_recno = recid(wod_det).

                            update lotserial_qty
                            sub_comp cancel_bo
                            site location lotserial lotref multi_entry
                            v_trchr01   /*add-by-davild20051206*/
                            with frame d
                            editing:

/*M1LJ**                       global_site = input site.    */
/*M1LJ**                       global_loc = input location. */

/*M1LJ*/                       assign
/*M1LJ*/                          global_site = input site
/*M1LJ*/                          global_loc  = input location
                                  global_lot  = input lotserial.

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

                            i = 0.
                            for each sr_wkfl no-lock
                            where sr_userid = mfguser
                            and sr_lineid = cline:
                               i = i + 1.
                               if i > 1 then do:
                                  multi_entry = yes.
                                  leave.
                               end.
                            end.

/*M1LJ**                    total_lotserial_qty = wod_qty_chg.         */
/*M1LJ**                    trans_um = if available pt_mstr then pt_um */
/*M1LJ**                                else "".                       */

/*M1LJ*/                    assign
/*M1LJ*/                       total_lotserial_qty = wod_qty_chg
/*M1LJ*/                       trans_um            = if available pt_mstr
/*M1LJ*/                                             then
/*M1LJ*/                                                pt_um
/*M1LJ*/                                             else ""
                               trans_conv          = 1.

                            if multi_entry then do:

/*M1LJ** BEGIN DELETE
 *
 *                             if i >= 1 then do:
 *                                site = "".
 *                                location = "".
 *                                lotserial = "".
 *                                lotref = "".
 *                             end.
 *
 *M1LJ** END DELETE */

/*M1LJ*/                       if i >= 1
/*M1LJ*/                       then
/*M1LJ*/                          assign
/*M1LJ*/                             site      = ""
/*M1LJ*/                             location  = ""
/*M1LJ*/                             lotserial = ""
/*M1LJ*/                             lotref    = "".

/*M1LJ**                       lotnext = "". */

/*M1LJ*/                       assign
/*M1LJ*/                          lotnext  = ""
                                  lotprcpt = no.

                               {gprun.i ""icsrup.p"" "(input wo_site,
                                                       input """",
                                                       input """",
                                                       input-output lotnext,
                                                       input lotprcpt)"}

/*G1TT*/ /* BEGIN ADD SECTION TO VALIDATE NO OVERISSUE PROBLEM */

                               assign
                                  overissue_ok     = no
                                  lineid_list      = ""
                                  currid           = string(part,"x(18)") +
/*M1LJ**                                             string(op). */
/*M1LJ*/                                             string(op)
/*M1LJ*/                          l_temp_from_part = string(wod_part,"x(18)")
/*M1LJ*/                          l_temp_to_part   = l_temp_from_part + hi_char.

                               for each sr_wkfl
/*M1LJ*/                          fields (sr_lineid sr_loc sr_lotser sr_vend_lot
/*M1LJ*/                                  sr_qty    sr_ref sr_site   sr_userid)
                                  where sr_userid = mfguser
/*M1LJ**                            and substring(sr_lineid,1,18) = */
/*M1LJ**                                string(part,"x(18)")        */
/*M1LJ*/                            and   sr_lineid >= l_temp_from_part
/*M1LJ*/                            and   sr_lineid <= l_temp_to_part
                                  no-lock:

/*L0M1*/                          if not can-do(lineid_list,sr_lineid)
/*L0M1*/                          then
                                  lineid_list = lineid_list +
                                                sr_lineid + ",".

                               end. /* for each sr_wkfl */

                               {gprun.i ""icoviss1.p""
                                  "(input part,
                                    input lineid_list,
                                    input currid,
                                    output overissue_ok)"
                               }

                               if not overissue_ok then undo, retry.

/*G1TT*/ /* END ADD SECTION */

                            end.
                            else do:
                               if lotserial_qty <> 0 then do:
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

                                  if undo-input then undo, retry.

                                  if wo_site <> site then do:

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
                                     if yn then undo locloop, retry.
                                  end.
                               end.

                               find first sr_wkfl where sr_userid = mfguser
/*M1LJ**                       and sr_lineid = cline no-error. */
/*M1LJ*/                       and sr_lineid = cline
/*M1LJ*/                       exclusive-lock no-error.

                               if lotserial_qty = 0 then do:
                                  if available sr_wkfl then do:
                                     total_lotserial_qty =
                                        total_lotserial_qty - sr_qty.
                                     delete sr_wkfl.
                                  end.
                               end.
                               else do:
                                  if available sr_wkfl then do:
                                     assign
                                     total_lotserial_qty =
                                        total_lotserial_qty - sr_qty
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
                                     sr__qadc01          = v_trchr01   /*add-by-davild20051206*/
                                     sr_userid           = mfguser
                                     sr_lineid           = cline
                                     sr_site             = site
                                     sr_loc              = location
                                     sr_lotser           = lotserial
                                     sr_ref              = lotref
/*M1LJ**                             sr_qty              = lotserial_qty. */
/*M1LJ*/                             sr_qty              = lotserial_qty
                                     total_lotserial_qty = total_lotserial_qty +
                                                           lotserial_qty.

                                     if recid(sr_wkfl) = -1 then .

                                  end.  /* CREATE sr_wkfl */

/*G1TT*/ /* BEGIN ADD SECTION TO VALIDATE NO OVERISSUE PROBLEM */

                                  assign
                                     overissue_ok     = no
                                     lineid_list      = ""
                                     currid           = string(part,"x(18)") +
/*M1LJ**                                                string(op). */
/*M1LJ*/                                                string(op)
/*M1LJ*/                             l_temp_from_part = string(wod_part,"x(18)")
/*M1LJ*/                             l_temp_to_part   =   l_temp_from_part
/*M1LJ*/                                                + hi_char.

                                  for each sr_wkfl
/*M1LJ*/                             fields (sr_lineid   sr_loc    sr_lotser
/*M1LJ*/                                     sr_qty      sr_ref    sr_site
/*M1LJ*/                                     sr_vend_lot sr_userid)
                                     where sr_userid = mfguser
/*M1LJ**                               and substring(sr_lineid,1,18) = */
/*M1LJ**                                   string(part,"x(18)")        */
/*M1LJ*/                             and   sr_lineid >= l_temp_from_part
/*M1LJ*/                             and   sr_lineid <= l_temp_to_part
                                     no-lock:

/*L0M1*/                             if not can-do(lineid_list,sr_lineid)
/*L0M1*/                             then
                                     lineid_list = lineid_list +
                                                   sr_lineid + ",".

                                  end. /* for each sr_wkfl */
                                  {gprun.i ""icoviss1.p""
                                     "(input part,
                                       input lineid_list,
                                       input currid,
                                       output overissue_ok)"
                                  }
                                  if not overissue_ok then undo, retry.
/*G1TT*/ /* END ADD SECTION */

                               end.
                            end.

/*M1LJ** BEGIN DELETE
 *                          wod_qty_chg = total_lotserial_qty.
 *                          if cancel_bo then
 *                             wod_bo_chg = 0.
 *                          else
 *                             wod_bo_chg = wod_qty_req
 *                                         - wod_qty_iss - wod_qty_chg.
 *M1LJ** END DELETE */

/*M1LJ*/                    assign
/*M1LJ*/                       wod_qty_chg = total_lotserial_qty
/*M1LJ*/                       wod_bo_chg  = if cancel_bo
/*M1LJ*/                                     then
/*M1LJ*/                                        0
/*M1LJ*/                                     else
/*M1LJ*/                                        wod_qty_req - wod_qty_iss
/*M1LJ*/                                                    - wod_qty_chg.

                            if wod_qty_req >= 0 then
                               wod_bo_chg = max(wod_bo_chg,0).
                            if wod_qty_req < 0  then
                               wod_bo_chg = min(wod_bo_chg,0).
                            if cancel_bo and
                               not can-find (first sr_wkfl where
                                     sr_userid = mfguser and
                                     sr_lineid = cline)
                            then do:
                               create sr_wkfl.
                               assign
                                  sr_userid = mfguser
                                  sr_lineid = cline
/*N0Z8**                             sr_qty = 0                           */
/*N0Z8*/                             sr_qty = 0
/*N0Z8*/                            sr_site = site.
                               recno = recid(sr_wkfl).
                            end.

                         end.

                         leave.
                      end.
                   end.
                end.

                do on endkey undo mainloop, leave mainloop:
/*L0TF*/           assign
/*L0TF*/              l_remove_srwkfl = yes
                      yn              = yes.
       /*V8-*/
                   {mfmsg01.i 636 1 yn} /* Display wo lines being shipped? */
       /*V8+*/
       /*V8!       {mfgmsg10.i 636 1 yn} */ /* Display wo lns being shippd? */
                   if yn = yes then do:
                      hide frame c no-pause.
                      hide frame d no-pause.
                      for each wod_det no-lock where wod_lot = wo_lot,
                      each sr_wkfl no-lock where sr_userid = mfguser
                      and sr_lineid = string(wod_part,"x(18)")
                          + string(wod_op)
                      with
/*N002*/              frame dd
                      width 80:
                         /* SET EXTERNAL LABELS */
                         setFrameLabels(frame dd:handle).
                         display wod_part sr_site sr_loc sr_lotser
                         sr_ref format "x(8)" column-label {&wowoisc_p_5}
                         sr_qty.
                      end.
                   end.
       /*V8!     else if yn = ? then                 */
       /*V8!       undo mainloop, retry mainloop.    */
                end.

                do on endkey undo mainloop, leave mainloop:
       /*V8-*/
                   yn = yes.
                   {mfmsg01.i 12 1 yn} /* "Is all info correct?" */
       /*V8+*/
       /*V8!       yn = ?. */
       /*V8!       {mfgmsg10.i 12 1 yn} */ /* "Is all info correct?" */

/*L0TF*/ /*V8!     if yn = ? then
/*L0TF*/              undo mainloop, leave mainloop. */
/*L0TF*/           l_remove_srwkfl = no.

                   if yn then do:
/*N0WT*/              {&WOWOISC-P-TAG2}

/*M0VP*/              /* ADDED CODE TO VALIDATE OVERISSUE WHEN DEFAULT ISSUE */
/*M0VP*/              /* QTY IS ACCEPTED DIRECTLY WITHOUT ANY MODIFICATION   */
/*M0VP*/              assign
/*M0VP*/                 currid         = "-99"
/*M0VP*/                 l_overissue_yn = no.

/*M0VP*/              for each wod_det
/*M0VP*/                 fields (wod_bo_chg wod_critical wod_iss_date wod_loc
/*M0VP*/                         wod_lot wod_nbr wod_op wod_part wod_qty_all
/*M0VP*/                         wod_qty_chg wod_qty_iss wod_qty_pick
/*M0VP*/                         wod_qty_req wod_site)
/*M1LJ** /*M0VP*/        where wod_lot = wo_lot no-lock: */

/*M1LJ*/                 where wod_lot = wo_lot
/*M1LJ*/                 no-lock
/*M1LJ*/                 break by wod_part:

/*M1LJ*/                 if first-of(wod_part)
/*M1LJ*/                 then do:

/*M0VP*/                    assign
/*M0VP*/                       overissue_ok     = no
/*M1LJ** /*M0VP*/              lineid_list      = "". */
/*M1LJ*/                       lineid_list      = ""
/*M1LJ*/                       l_temp_from_part = string(wod_part,"x(18)")
/*M1LJ*/                       l_temp_to_part   = l_temp_from_part + hi_char.

/*M0VP*/                    for each sr_wkfl
/*M0VP*/                       fields (sr_lineid sr_loc sr_lotser sr_qty sr_ref
/*M0VP*/                               sr_site sr_userid sr_vend_lot)
/*M1LJ* /*M0VP*/               where substring(sr_lineid,1,18) =       */
/*M1LJ* /*M0VP*/                     string(wod_part,"x(18)") no-lock: */

/*M1LJ*/                       where sr_userid  = mfguser
/*M1LJ*/                       and   sr_lineid >= l_temp_from_part
/*M1LJ*/                       and   sr_lineid <= l_temp_to_part
/*M1LJ*/                       no-lock:

/*M0VP*/                          if not can-do(lineid_list,sr_lineid)
/*M0VP*/                          then
/*M0VP*/                            lineid_list = lineid_list + sr_lineid + ",".

/*M0VP*/                    end. /* FOR EACH sr_wkfl ... */

/*M0VP*/                    {gprun.i ""icoviss1.p"" "(input wod_part,
                                                      input lineid_list,
                                                      input currid,
                                                      output overissue_ok)"
                            }

/*M0VP*/                    if not overissue_ok
/*M0VP*/                    then
/*M0VP*/                       l_overissue_yn = yes.

/*M1LJ*/                 end. /* IF FIRST-OF(wod_part) */

/*M0VP*/              end. /* FOR EACH wod_det ... */

/*M0VP*/              if l_overissue_yn then next setd.

/*L16J*/             /* BEGIN ADD SECTION */
/*L16J*/             /* ADDED A CALL TO icedit4.p AS ALL THE VALIDATIONS OF */
/*L16J*/             /* icedit4.p WERE SKIPPED IF THE USER ACCEPTED THE     */
/*L16J*/             /* DEFAULTS AND EXITED (F4) NOT PROCESSING THE         */
/*L16J*/             /* INDIVIDUAL LINES.                                   */

                     l_error = no.

                     for each wod_det
                        fields(wod_bo_chg   wod_iss_date   wod_loc
                               wod_lot      wod_nbr        wod_op
                               wod_part     wod_qty_chg    wod_qty_iss
                               wod_critical wod_qty_all   wod_qty_pick
                               wod_qty_req  wod_site)
                        where wod_lot = wo_lot no-lock,
                        each sr_wkfl fields(sr_userid sr_lineid sr_site
                                            sr_loc    sr_lotser sr_ref
                                            sr_qty    sr_vend_lot)
                        where sr_userid = mfguser
                          and sr_lineid = string(wod_part,"x(18)")
                                           + string(wod_op)
                          and sr_qty    <> 0.00
                          no-lock:

                        for first pt_mstr
                            fields(pt_critical pt_desc1 pt_loc
                                   pt_lot_ser  pt_part  pt_um)
                            where pt_part = wod_part no-lock:
                        end. /* FOR FIRST pt_mstr ... */

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
                                      input pt_um,
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
                        end. /* IF wo_site <> sr_site */
                     end. /* FOR EACH wod_det */

                     if l_error then
                        undo mainloop, retry mainloop.
/*L16J*/             /* END ADD SECTION */

                      /* Added section */
                      {gplock.i
                      &file-name=wo_mstr
                      &find-criteria="recid(wo_mstr) = wo_recno"
                      &exit-allowed=yes
                      &record-id=recno}

       /*V8-*/
                      if keyfunction(lastkey) = "end-error" then do:

/*M1LJ**                find wo_mstr no-lock where recid(wo_mstr) = wo_recno. */

/*M1LJ*/                 for first wo_mstr
/*M1LJ*/                    fields (wo_lot      wo_nbr  wo_part
/*M1LJ*/                            wo_rel_date wo_site wo_type)
/*M1LJ*/                    where recid(wo_mstr) = wo_recno
/*M1LJ*/                    no-lock:
/*M1LJ*/                 end. /* FOR FIRST wo_mstr */

                         next setd.

                      end.
       /*V8+*/

                      if not available wo_mstr then do:
                         {mfmsg.i 510 4} /*  WORK ORDER DOES NOT EXIST.*/
                         leave mainloop.
                      end.

                      /* End of added section */

                      /* ADDED SECTION TO DO FINAL ISSUE CHECK */
/*H0YS*               CODE REPLACED BELOW
.                     {icintr2.i "sr_userid = mfguser"
.                                transtype
.                                substring(sr_lineid,1,18)
.                                trans_um
.                                undo-input
.                                """"
.                     }
.*H0YS*               end of REPLACED code   */
/*H0YS*               NEW CODE FOR ORACLE COMPATIBILITY   */
                      {icintr2.i "sr_userid = mfguser"
                                 transtype
                                 right-trim(substring(sr_lineid,1,18))
                                 trans_um
                                 undo-input
                                 """use pt_mstr"""
                      }
/*H0YS*               end of NEW code   */

                      if undo-input
                      then do:
                         /* UNABLE TO ISSUE OR RECEIVE FOR ITEM */
                         {mfmsg02.i 161 3 substring(sr_lineid,1,18)}
                         next setd.
                      end.
                      /* END OF ADDED SECTION */
                      hide frame c.
                      hide frame d.
                      leave setd.
                   end. /* IF yn = YES */
       /*V8!       else if yn = no then do:

/*M1LJ**              find wo_mstr no-lock where recid(wo_mstr) = wo_recno. */

/*M1LJ*/              for first wo_mstr
/*M1LJ*/                 fields (wo_lot      wo_nbr  wo_part
/*M1LJ*/                         wo_rel_date wo_site wo_type)
/*M1LJ*/                 where recid(wo_mstr) = wo_recno
/*M1LJ*/                 no-lock:
/*M1LJ*/              end. /* FOR FIRST wo_mstr */

                      next setd.
                   end.
                 else
                   leave mainloop.  */
                end.
             end.
             /* setd */
             undo-all = no.
         end. /* DO TRANSACTION */
/*N002*/ hide frame dd no-pause.
/*N002*/
/*N002*/ for each sr_wkfl exclusive-lock where sr_userid = mfguser:
/*N002*/    sr_vend_lot = 'wowoisc.p'.
/*L0TF*/    if l_remove_srwkfl then
/*L0TF*/       delete sr_wkfl.
/*N002*/ end.

