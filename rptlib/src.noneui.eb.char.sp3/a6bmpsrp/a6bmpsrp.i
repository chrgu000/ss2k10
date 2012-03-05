/* bmpsrp.i - PRODUCT STRUCTURE REPORT INCLUDE FILE                          */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*J30L*/
/*J30L*/ /*V8:ConvertMode=Report                                             */
/* REVISION: 9.0      CREATED: 10/22/98       BY: *J30L* Raphael T.          */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 07/15/99   BY: *J3J4* Jyoti Thatte      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 12/06/00   BY: *M0XK* Vandna Rohira     */
/* REVISION: 9.1      LAST MODIFIED: 10/17/05   BY: *SS - 20051017* Bill Jiang     */


         /*J30L* BEGIN ADD PROCEDURE */
         procedure process_report:

         define query q_ps_mstr            for ps_mstr .
         define input parameter comp       like ps_comp     no-undo.
         define input parameter level      as   integer     no-undo.
/*M0XK** define input parameter new_parent like mfc_logical. */
/*M0XK*/ define input parameter skpge      like mfc_logical no-undo.

         define buffer bommstr for bom_mstr.

         find bom_mstr no-lock where bom_parent = comp no-error.

/*J3J4** find pt_mstr no-lock where pt_part = bom_parent no-error.  */
/*J3J4*/ for first pt_mstr
/*J3J4*/    fields ( pt_bom_code pt_desc1 pt_desc2 pt_iss_pol
/*J3J4*/             pt_part pt_phantom pt_rev pt_um )
/*J3J4*/ no-lock where pt_part = comp:
/*J3J4*/ end. /* FOR FIRST PT_MSTR */
/*J3J4*/ if available pt_mstr and pt_bom_code <> "" then
/*J3J4*/ comp = pt_bom_code.

         if sort_ref then
            open query q_ps_mstr for each ps_mstr use-index ps_parref
            where ps_par = comp and (ps_op >= op and ps_op <= op1) no-lock.

         else
            open query q_ps_mstr for each ps_mstr use-index ps_parcomp
            where ps_par = comp and (ps_op >= op and ps_op <= op1) no-lock.


         get first q_ps_mstr no-lock.

         if not available ps_mstr then return.

         assign parent  = ps_par
                phantom = if available pt_mstr then pt_phantom else no.

/*M0XK** repeat while avail ps_mstr with frame det2 down : */

            form
               lvl
               ps_comp
               ps_ref
               desc1
               ps_qty_per
               um
               ps_op
               phantom
               ps_ps_code
               iss_pol
               ps_start
               ps_end
               ps_scrp_pct
               ps_lt_off
            with frame det2 width 132 no-attr-space no-box.

            /* SET EXTERNAL LABELS */
            /* SS - 20051017 - B */
            /*
            setFrameLabels(frame det2:handle).
            */
            /* SS - 20051017 - E */

            /*DETAIL FORM */

/* SS - 20051017 - B */
/*
/*M0XK** if new_parent = yes then do: */
/*M0XK*/ if level = 1 then do:

            if page-size - line-counter < 7 then page.
            display {&bmpsrp_p_8} @ lvl parent @ ps_comp
                    pt_desc1 when (available pt_mstr) @ desc1
                    bom_desc when (not available pt_mstr) @ desc1
                    pt_um when (available pt_mstr) @ um
                    bom_batch_um when (not available pt_mstr) @ um
                    phantom @ phantom with frame det2.

            down 1 with frame det2.

            if available pt_mstr and pt_desc2 > "" then do:
               display  pt_desc2 @ desc1 with frame det2.
               down 1 with frame det2.
            end.  /* IF AVAILABLE pt_mstr ... */
            if available pt_mstr and pt_rev <> "" then do:
               display {&bmpsrp_p_1} +  pt_rev format "X(24)" @ desc1
               with frame det2.
               down 1 with frame det2.
            end. /* IF AVAILABLE pt_mstr ... */
/*M0XK**    new_parent = no.             */
/*M0XK** end.  /* if new_parent = yes */ */
/*M0XK*/ end.  /* IF level = 1 */
*/
IF level = 1 THEN DO:
    ASSIGN
        parent01 = PARENT
        .
END.
/* SS - 20051017 - E */


/*M0XK*/ repeat while available ps_mstr with frame det2 down :

            if eff_date = ? or (eff_date <> ? and
               (ps_start = ? or ps_start <= eff_date)
               and  (ps_end = ? or eff_date <= ps_end)) then do :

               assign um = ""
                      desc1 = {&bmpsrp_p_9}
                      iss_pol = no
                      phantom = no.

               find pt_mstr where pt_part = ps_comp no-lock no-error.
               if available pt_mstr then do:
                  assign um = pt_um
                         desc1 = pt_desc1
                         iss_pol = pt_iss_pol
                         phantom = pt_phantom.
               end. /* IF AVAILABLE pt_mstr */
               else do:
                  find bommstr no-lock
                     where bommstr.bom_parent = ps_comp no-error.
                  if available bommstr then
                     assign um = bommstr.bom_batch_um
                            desc1 = bommstr.bom_desc.
               end. /* ELSE DO */

               lvl = "........".
               lvl = substring(lvl,1,min (level - 1,9)) + string(level).
               if length(lvl) > 10
               then lvl = substring(lvl,length (lvl) - 9,10).

               /* SS - 20051017 - B */
               /*
               lines = 1.
               if ps_rmks > "" then lines = lines + 1.
               if available pt_mstr and pt_desc2 > ""
               then lines = lines + 1.
               if available pt_mstr and pt_rev > ""
               then lines = lines + 1.
               if page-size - line-counter < lines then page.

               display lvl ps_comp ps_ref desc1 ps_qty_per
                  um
                  ps_op
                  phantom
                  ps_ps_code iss_pol ps_start ps_end ps_lt_off
                  ps_scrp_pct when (ps_scrp_pct <> 0)
               with frame det2.
               down with frame det2.

               if available pt_mstr and pt_desc2 > "" then do :
                  display pt_desc2 @ desc1 with frame det2.
                  down with frame det2.
               end.  /* IF AVAILABLE pt_mstr ... */
               if available pt_mstr and pt_rev <> "" then do :
                  display  {&bmpsrp_p_1} +  pt_rev format "X(24)" @ desc1
                  with frame det2.
                  down with frame det2.
               end. /* IF AVAILABLE pt_mstr ... */
               if length(ps_rmks) <> 0 then do :
                  display ps_rmks @ desc1 with frame det2.
                  down with frame det2.
               end. /* IF LENGTH(ps_rmks) <> 0 */
               */
               CREATE tta6bmpsrp.
               ASSIGN
                   tta6bmpsrp_par = parent01
                   tta6bmpsrp_level = level
                   tta6bmpsrp_lvl = lvl
                   tta6bmpsrp_comp = ps_comp
                   tta6bmpsrp_ref = ps_ref
                   tta6bmpsrp_desc1 = desc1
                   tta6bmpsrp_qty_per = ps_qty_per
                   tta6bmpsrp_um = um
                   tta6bmpsrp_op = ps_op
                   tta6bmpsrp_phantom = phantom
                   tta6bmpsrp_ps_code = ps_ps_code
                   tta6bmpsrp_iss_pol = iss_pol
                   tta6bmpsrp_start = ps_start
                   tta6bmpsrp_end = ps_end
                   tta6bmpsrp_lt_off = ps_lt_off
                   tta6bmpsrp_scrp_pct = ps_scrp_pct
                   .
               if available pt_mstr and pt_desc2 > "" then do :
                   ASSIGN
                       tta6bmpsrp_desc2 = pt_desc2
                       .
               end.  /* IF AVAILABLE pt_mstr ... */
               if available pt_mstr and pt_rev <> "" then do :
                   ASSIGN
                       tta6bmpsrp_rev = pt_rev
                       .
               end. /* IF AVAILABLE pt_mstr ... */
               if length(ps_rmks) <> 0 then do :
                   ASSIGN
                       tta6bmpsrp_rmks = ps_rmks
                       .
               end. /* IF LENGTH(ps_rmks) <> 0 */
               /* SS - 20051017 - E */

               if level < maxlevel or maxlevel = 0 then do:

/*M0XK*/          /* THIRD INPUT PARAMETER CHANGED FROM new_parent TO skpge */

                  run process_report in this-procedure
                     (input ps_comp,
                      input level + 1,
                      input skpge).

                  get next q_ps_mstr no-lock.
               end.  /* IF level < maxlevel ... */
               else do:
                  get next q_ps_mstr no-lock.
               end. /* ELSE DO */
            end.  /* End of Valid date */
            else do:
               get next q_ps_mstr no-lock.
            end. /* ELSE DO */
         end.  /* End of Repeat loop */

/* SS - 20051017 - B */
/*
/*M0XK*/ if level = 1 then do :
/*M0XK*/    if skpge then page.
/*M0XK*/    else put skip(1).
/*M0XK*/ end. /* IF level = 1 */
*/
/* SS - 20051017 - E */

         close query q_ps_mstr.

         end procedure.

/*J30L* END ADD PROCEDURE */
