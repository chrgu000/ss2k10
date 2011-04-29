/* wowomtj.p - WORK ORDER MAINTENANCE frame b                                */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*V8:RunMode=Character,Windows                                               */


/* REVISION: 8.5      LAST EDIT: 03/01/95        MODIFIED BY: tjs *J027*     */
/* REVISION: 8.5      LAST EDIT: 03/14/95        MODIFIED BY: ktn *J040*     */
/* REVISION: 8.5      LAST EDIT: 04/26/95        MODIFIED BY: sxb *J04D*     */
/* REVISION: 8.5      LAST EDIT: 06/28/95        MODIFIED BY: srk *J034*     */
/* REVISION: 8.5      LAST EDIT: 09/12/95        MODIFIED BY: tjs *J07F*     */
/* REVISION: 8.5      LAST EDIT: 09/28/95        MODIFIED BY: kxn *J072*     */
/* REVISION: 8.5      LAST EDIT: 10/13/95        MODIFIED BY: kxn *J08R*     */
/* REVISION: 8.5      LAST EDIT: 11/08/95        MODIFIED BY: tjs *J08Q*     */
/* REVISION: 8.5      LAST EDIT: 11/20/95        MODIFIED BY: kxn *J09C*     */
/* REVISION: 8.5      LAST EDIT: 01/11/96        MODIFIED BY: tjs *J0BG*     */
/* REVISION: 7.3      LAST EDIT: 03/19/96        MODIFIED BY: rvw *G1QZ*     */
/* REVISION: 8.5      LAST EDIT: 04/11/96        BY: *J04C* Markus Barone    */
/* REVISION: 8.5      LAST EDIT: 07/02/96        BY: *J0X9* Kieu Nguyen      */
/* REVISION: 8.5      LAST EDIT: 07/26/96        BY: *J10X* Markus Barone    */
/* REVISION: 8.5      LAST EDIT: 07/31/96        BY: *J135* T Farnsworth     */
/* REVISION: 8.5      LAST EDIT: 09/30/96        BY: *J159* Murli Shastri    */
/* REVISION: 8.5      LAST EDIT: 11/22/96        BY: *G2HQ* Murli Shastri    */
/* REVISION: 8.5      LAST EDIT: 01/09/97        BY: *H0QX* Julie Milligan   */
/* REVISION: 8.5      LAST EDIT: 02/04/97        BY: *J1GW* Julie Milligan   */
/* REVISION: 8.5      LAST EDIT: 02/10/97        BY: *G2JV* Julie Milligan   */
/* REVISION: 8.5      LAST EDIT: 03/28/97        BY: *G2LG* Murli Shastri    */
/* REVISION: 8.5      LAST MODIFIED: 05/29/97    BY: *J1SD* Manmohan K.Pardesi*/
/* REVISION: 8.5      LAST EDIT: 06/24/97        BY: *G2NM* Murli Shastri    */
/* REVISION: 8.5      LAST EDIT: 07/03/97        BY: *G2NV* Maryjeane DAte   */
/* REVISION: 8.5      LAST MODIFIED: 12/19/97    BY: *H1HK* Felcy D'Souza    */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/16/99   BY: *J3H2* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 08/20/99   BY: *N00J* Russ Witt          */
/* REVISION: 9.1      LAST MODIFIED: 12/15/99   BY: *L0MR* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KC* myb                  */
/* REVISION: eB sp5 chui  LAST MODIFIED: 08/31/05  BY: *eas050a* Kaine Zhang */

         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowomtj_p_1 "Adjust Co/By Order Dates"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowomtj_p_2 "Adjust Co/By Order Quantities"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowomtj_p_3 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define shared variable wo_recno           as recid.
         define shared variable leadtime           like pt_mfg_lead.
         define shared variable prev_site          like wo_site.
         define shared variable prev_status        like wo_status.
         define shared variable prev_ord           like wo_ord_date.
         define shared variable prev_release       like wo_rel_date.
         define shared variable prev_due           like wo_due_date.
         define shared variable prev_qty           like wo_qty_ord.
         define shared variable prev_routing       like wo_routing.
         define shared variable prev_bomcode       like wo_bom_code.
         define shared variable rel_date           like wo_rel_date.
         define shared variable due_date           like wo_due_date.
         define shared variable cmtindx            like wo_cmtindx.
         define shared variable any_issued         like mfc_logical.
         define shared variable any_feedbk         like mfc_logical.
         define shared variable add_2_joint        like mfc_logical.
         define shared variable del-yn             like mfc_logical initial no.
         define shared variable del-joint          like mfc_logical initial no.
         define shared variable new_wo             like mfc_logical initial no.
         define shared variable undo_all           like mfc_logical no-undo.
         define shared variable joint_qtys         like mfc_logical
         label {&wowomtj_p_2} initial yes.
         define shared variable joint_dates        like mfc_logical
         label {&wowomtj_p_1} initial yes.
         define variable ok like mfc_logical no-undo.
         define variable prompt-routing like mfc_logical no-undo.

         define variable i                   as integer.
         define variable nonwdays            as integer.
         define variable workdays            as integer.
         define variable overlap             as integer.
         define variable interval            as integer.
         define variable frwrd               as integer.
         define variable msg-type            as integer.
         define variable msg-counter         as integer.
         define variable know_date           as date.
         define variable find_date           as date.
         define variable yn                  like mfc_logical initial no.
         define variable glx_mthd            like cs_method.
         define variable glx_set             like cs_set.
         define variable cur_mthd            like cs_method.
         define variable cur_set             like cs_set.
/*L0MR** define variable prev_mthd           like cs_method. */
         define variable joint_label         like lngd_translation.
         define variable wocmmts             like woc_wcmmts label {&wowomtj_p_3}.
         define variable qty_ord_entered     like mfc_logical no-undo.
         define variable ord_date_entered    like mfc_logical no-undo.
         define variable rel_date_entered    like mfc_logical no-undo.
         define variable due_date_entered    like mfc_logical no-undo.
         define variable bom_code_entered    like mfc_logical no-undo.
         define variable do-delete           as logical.
/*N00J*/ define variable yield_pct           like wo_yield_pct no-undo.
/*N00J*/ define variable use_op_yield        as logical no-undo.
/*L0MR*/ define shared variable prev_mthd    like cs_method no-undo.

         define shared frame attrmt.

         {mfwoat.i}

         define shared frame a.
         define shared frame b.
         define buffer wo_mstr1 for wo_mstr.

         form
            wo_nbr         colon 25
            wo_lot
            wo_part        colon 25
            pt_desc1       at 47 no-label
            wo_type        colon 25
            pt_desc2       at 47 no-label
            wo_site        colon 25
            joint_label    at 47 no-label
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         form
            wo_qty_ord     colon 25
            wo_ord_date    colon 55
            wo_qty_comp    colon 25
            wo_rel_date    colon 55
            wo_qty_rjct    colon 25
            wo_due_date    colon 55
            skip(1)
            wo_status      colon 25
            wo_site        colon 55
            wo_so_job      colon 25
            wo_routing     colon 55
            wo_vend        colon 25
            wo_bom_code    colon 55
            wo_yield_pct   colon 25
            /*eas050a*/  wo__dte01 COLON 55
            skip(1)
            wo_rmks        colon 25
            skip(1)
            wocmmts        colon 18
            wo_var         colon 48
         with frame b side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         form
            joint_qtys    colon 35
            joint_dates   colon 35
            space(2)
         with frame b2 overlay side-labels row 12 column 20.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b2:handle).

         undo_all = yes.
         view frame a.
         view frame b.

         find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno.

         find first clc_ctrl no-lock no-error.
         if not available clc_ctrl then do:
            {gprun.i ""gpclccrt.p""}
            find first clc_ctrl no-lock.
         end.

         detail-loop:
         do on error undo, retry with frame b:
            ststatus = stline[2].
            status input ststatus.

            set wo_qty_ord
                wo_ord_date
                wo_rel_date
                wo_due_date
                wo_status
                wo_so_job
                wo_vend
                wo_yield_pct
                wo_site
                wo_routing
                wo_bom_code
                wo_rmks
                wocmmts
                wo_var when (glx_mthd <> "AVG")
            go-on(F5 CTRL-D).

            /* Displays will disturb 'entered', so set variables here */
            if prev_qty     <> wo_qty_ord  then  qty_ord_entered = yes.
                                           else  qty_ord_entered = no.
            if prev_ord     <> wo_ord_date then ord_date_entered = yes.
                                           else ord_date_entered = no.
            if prev_release <> wo_rel_date then rel_date_entered = yes.
                                           else rel_date_entered = no.
            if prev_due     <> wo_due_date then due_date_entered = yes.
                                           else due_date_entered = no.
            if prev_bomcode <> wo_bom_code then bom_code_entered = yes.
                                           else bom_code_entered = no.

            if wo_qty_ord * wo_qty_comp <  0 then do:
               /* Reverse receipts may not exceed total previous receipts */
               {mfmsg.i 556 3}.
               undo, retry.
            end.

            if wo_qty_ord * prev_qty <  0 then do:
               {mfmsg.i 95 3}.
               undo, retry.
            end.

            if wo_qty_ord = 0 and  prev_qty <>  0 then do:
               {mfmsg.i 317 3}.
               undo, retry.
            end.

            if wo_joint_type <> "" and wo_qty_ord < 0 then do:
               /* Negative numbers not allowed */
               {mfmsg.i 5619 3}.
               undo, retry.
            END.
            
            /************************eas050a B Add***********************/
            IF wo_status <> "c" THEN DO:
            	wo__dte01 = ?  .
            END.
            ELSE DO:
            	IF wo__dte01 = ? THEN wo__dte01 = TODAY.
            END.
            
            DISPLAY wo__dte01 WITH FRAME b.
            /************************eas050a E Add***********************/

            /* DELETE */
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:

               do for wo_mstr1:

                  find first mph_hist where mph_lot = wo_mstr.wo_lot
                  no-lock no-error.
                  if available mph_hist then do:
                     /*QUALITY TEST RESULTS EXIST FOR THIS W.ORDER FOR ITEM#*/
                     {mfmsg02.i 7109 2 mph_part}.
                     pause.
                  end.
                  if wo_mstr.wo_joint_type <> "" then do:
                     for each wo_mstr1 no-lock
                     where wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                           wo_mstr1.wo_type = "" and
                           wo_mstr1.wo_lot <> wo_mstr.wo_lot.
                        find first mph_hist where mph_lot = wo_mstr1.wo_lot
                        no-lock no-error.
                        if available mph_hist then do:
                        /*QUALITY TEST RESULTS EXIST FOR THIS W.ORDR FOR ITEM#*/
                           {mfmsg02.i 7109 2 mph_part}.
                           pause.
                        end.
                     end.
                  end.

                  /* Check for joint order with wo_wip_tot */
                  if wo_mstr.wo_joint_type <> "" then do:
                     find first wo_mstr1 exclusive-lock
                     where wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                           wo_mstr1.wo_type = "" and
                           wo_mstr1.wo_wip_tot <> 0 no-error.
                  end.

                  if wo_mstr.wo_wip_tot <> 0 or available wo_mstr1 then do:
                     /* Delete not allowed, w.order accounting must be closed */
                     {mfmsg.i 536 3}
                     undo.
                  end.

                  do-delete = true.

                  if prev_status = "C" and

                     wo_mstr.wo_acct_close and
                     wo_mstr.wo_wip_tot = 0 then do-delete = true.

                  else if can-do("P,B,F",prev_status) and
                     wo_mstr.wo_wip_tot = 0 then do-delete = true.

                  else do-delete = false.

/*J3H2*/          /* TO AVOID DELETION OF WORK ORDERS WHEN wo_wip_tot = 0     */
/*J3H2*/          /* AND wo_qty_comp <> 0                                     */
/*J3H2*/          if can-do("B,F",wo_mstr.wo_status) and
/*J3H2*/             wo_mstr.wo_qty_comp <> 0 then
/*J3H2*/             do-delete = false.

                  if not do-delete
                  then do:
                     /* DELETE NOT ALLOWED. WO ACCOUNTING MUST BE CLOSED */
                     {mfmsg.i 536 3}
                     undo.
                  end.

                  del-yn = yes.
                  /* Please confirm delete */
                  {mfmsg01.i 11 1 del-yn}
                  if del-yn = no then undo.

                  if wo_mstr.wo_joint_type <> "" and
                  wo_mstr.wo_status <> "B" then do:
                     del-joint = no.
                     /* Delete joint work orders? */
                     {mfmsg01.i 6541 1 del-joint}

                     /* About to delete last remaining co-product WO? */
                     if not del-joint and wo_mstr.wo_joint_type = "1" then
                     find first wo_mstr1 exclusive-lock
                     where wo_mstr1.wo_nbr =  wo_mstr.wo_nbr and
                           wo_mstr1.wo_lot <> wo_mstr.wo_lot and
                           wo_mstr1.wo_type = "" and
                           wo_mstr1.wo_joint_type = "1" no-error.

                     /* Must del joint order set if base or the last remaining*/
                     if not del-joint and
                     (wo_mstr.wo_joint_type = "5" or wo_mstr.wo_status = "F" or
                     (wo_mstr.wo_joint_type = "1" and not available wo_mstr1))
                     then do:
                        del-yn = no.
                        undo.
                     end.
                  end.
               end. /* do for wo_mstr1 */
            end.  /* if delete... */

            if not del-yn then do:

               if index("PFB",prev_status) = 0
               and index("PFB",wo_status) = 0
               and wo_routing <> prev_routing then do:
                  /* Cannot change routing */
                  {mfmsg.i 127 3}
                  next-prompt wo_routing.
                  display prev_routing @ wo_routing.
                  undo, retry.
               end.

               if index("PFB",prev_status) = 0
               and index("PFB",wo_status) = 0
               and wo_bom_code <> prev_bomcode then do:
                  /* Cannot change product structure */
                  {mfmsg.i 153 3}
                  next-prompt wo_bom_code.
                  display prev_bomcode @ wo_bom_code.
                  undo, retry.
               end.

               if wo_type = "" and (new_wo or bom_code_entered) then do:
                  if not add_2_joint then do:
                     /* Explode to see if this is a co-product */
                     find first ps_mstr no-lock where ps_par = wo_part
                     and ps_comp = wo_bom_code and ps_ref = ""
                     and ps_ps_code = "J" and ps_joint_type = "1"
                     and (ps_start <= wo_rel_date or ps_start = ?)
                     and (ps_end   >= wo_rel_date or ps_end = ?)
                     no-error.
                     if not available ps_mstr then do:
                        /* See if this is a base process */
                        if wo_bom_code <> ""
                        then do:
                           find first ps_mstr no-lock where
                           ps_comp = wo_bom_code
                           and ps_ref = ""
                           and ps_ps_code = "J" and ps_joint_type <> ""
                           and (ps_start <= wo_rel_date or ps_start = ?)
                           and (ps_end   >= wo_rel_date or ps_end = ?)
                           no-error.
                        end.
                        else do:
                           find first ps_mstr no-lock where
                           ps_comp = wo_part
                           and ps_ref = ""
                           and ps_ps_code = "J" and ps_joint_type <> ""
                           and (ps_start <= wo_rel_date or ps_start = ?)
                           and (ps_end   >= wo_rel_date or ps_end = ?)
                           no-error.
                        end.
                     end.

                     /* JP WO is co/by default. Not JP: No PS or add to non-JP*/
                     if new_wo and not available ps_mstr
                     and not wo_joint_type = "5"
                     and not add_2_joint then do:
                        wo_joint_type = "".
                        wo_base_id = "".
                        joint_label = "".
                        display joint_label with frame a.
                     end.
                  end.
               end.

               find pt_mstr no-lock where pt_part = wo_part no-error.
               find ptp_det no-lock where ptp_part = wo_part and
               ptp_site = wo_site no-error.

               if index("1234",wo_joint_type) = 0 then do:
                  /* Not a joint product */
                  if available ptp_det then leadtime = ptp_mfg_lead.
                  else leadtime = pt_mfg_lead.
               end.

               if wo_joint_type <> "" and wo_yield_pct <> 100 then do:
                  /* Yield must be 100% on joint products */
                  {mfmsg.i 6527 3}
                  next-prompt wo_yield.
                  undo, retry.
               end.

               if wo_ord_date = ? then wo_ord_date = today.
               if wo_rel_date = ? and wo_due_date = ? then
                  wo_rel_date = max(today,wo_ord_date).

               if add_2_joint then do:
                  wo_rel_date = rel_date.
                  wo_due_date = due_date.
                  wo_routing  = prev_routing.
                  wo_bom_code = prev_bomcode.
               end.

               display wo_ord_date wo_rel_date wo_due_date.
               if wo_due_date < wo_rel_date then do:
                  {mfmsg.i 514 3}
                  /* Due date before release date not allowed */
                  next-prompt wo_rel_date.
                  undo, retry.
               end.

               if wo_status = "" or wo_status = ? then wo_status = prev_status.

               if index("BFEARC",wo_status) = 0
               or ((index("RE",wo_type) > 0)
                    and index("ARC",wo_status) = 0)
               or ((index("F",wo_type) > 0)

/*J3H2*/            /* TO ALLOW CHANGE OF WORK ORDER STATUS TO "F" */
/*J3H2**            and index("EARC",wo_status)  = 0)              */
/*J3H2*/            and index("FEARC",wo_status) = 0)

               or (wo_joint_type <> "" and
                   not new_wo and
                   wo_status = "B" and prev_status <> "B")
               then do:
                  {mfmsg02.i 19 3 """'"" + wo_status + ""'"""}
                  /* Invalid status */
                  display prev_status @ wo_status.
                  next-prompt wo_status.
                  undo, retry.
               end.

               if index("pfbearc",wo_status) > 0 then
               wo_status = entry(index("pfbearc",wo_status),"P,F,B,E,A,R,C").

               if ((index("PFB",prev_status) > 0
                  and index("FEAR",wo_status) > 0))
               or ((index("FEARC",prev_status) > 0
                  and index("FB",wo_status) > 0))
               then do:
                  /* Check wod_qty_iss status for all components */
                  if wo_joint_type = "" or wo_joint_type = "5" then do:
                     {mfwomta.i wo_lot any_issued any_feedbk}
                  end.
                  else do:
                     {mfwomta.i wo_base_id any_issued any_feedbk}
                  end.
                  if any_issued then do:
                     /* Work order components have been issued */
                     {mfmsg.i 529 3}
                  end.
                  if any_feedbk then do:
                     /* Labor feedback has been reported */
                     {mfmsg.i 554 3}
                  end.
                  if any_issued or any_feedbk then do:
                     /* Previous value: */
                     {mfmsg02.i 530 1 prev_status}
                     next-prompt wo_status.
                     undo, retry.
                  end.
               end.

               if prev_status = "R" and prev_qty <> wo_qty_ord
               then do on error undo, retry:
                  /* Order quantity changed on released order */
                  {mfmsg.i 552 2}
                  if not batchrun then pause.
               end.

               {gprun.i ""gpsiver.p""
                "(input wo_site, input ?, output return_int)"}
               if return_int = 0 then do:
                  /* USER DOES NOT HAVE ACCESS TO THIS SITE */
                  {mfmsg.i 725 3}
                  next-prompt wo_site with frame a.
                  undo, retry.
               end.

               /* Change on a joint WO may affect other joint WOs */
               if wo_joint_type <> "" and not new_wo then do:

                  /* Change to Batch status, delete other JP orders in set */
                  if wo_status = "B" and prev_status <> "B" then do:
                     del-joint = no.
                     for each wo_mstr1 exclusive-lock where
                     wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                     wo_mstr1.wo_type = "" and
                     wo_mstr1.wo_lot <> wo_mstr.wo_lot:
                        wo_recno = recid(wo_mstr1).
                        {gprun.i ""wowomte.p""}
                     end.
                     wo_recno = recid(wo_mstr).
                     wo_base_id = "".
                  end.

                  /* Check product structure */
                  if bom_code_entered or rel_date_entered then do:
                     if wo_joint_type = "5" then /* Base still makes co-prod? */
                     find first ps_mstr no-lock where ps_comp = wo_part
                     and ps_ref = ""
                     and ps_ps_code = "J" and ps_joint_type = "1"
                     and (ps_start <= wo_rel_date or ps_start = ?)
                     and (ps_end   >= wo_rel_date or ps_end = ?)
                     no-error.
                     else                        /* JProduct still effective? */
                     find first ps_mstr no-lock where ps_par = wo_part
                     and ps_comp = wo_bom_code and ps_ref = ""
                     and ps_ps_code = "J" and index("1234",ps_joint_type) > 0
                     and (ps_start <= wo_rel_date or ps_start = ?)
                     and (ps_end   >= wo_rel_date or ps_end = ?)
                     no-error.
                     /* Switched to a non-joint WO? Try a non-JP bom. */
                     if not available ps_mstr then do:
                        find first ps_mstr no-lock where ps_par = wo_part
                        and ps_comp = wo_bom_code and ps_joint_type = ""
                        and (ps_start <= wo_rel_date or ps_start = ?)
                        and (ps_end   >= wo_rel_date or ps_end = ?)
                        no-error.

                        /* Make on a Non-JP WO. Delete other JP WO in set. */
                        if available ps_mstr then do:
                           del-joint = yes.

                           /* Item is not effective in joint product structure*/
                           {mfmsg.i 6528 1}
                           /* Delete joint work orders? */
                           {mfmsg01.i 6541 1 del-joint}
                           if not del-joint then undo, retry.
                           joint_label = "".
                           display joint_label with frame a.

                           del-joint = no.
                           for each wo_mstr1 exclusive-lock where
                           wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                           wo_mstr1.wo_type = "" and
                           wo_mstr1.wo_lot <> wo_mstr.wo_lot:
                              wo_recno = recid(wo_mstr1).
                              {gprun.i ""wowomte.p""}
                           end.
                           wo_recno = recid(wo_mstr).
                           wo_joint_type = "".
                        end.
                        else do:
                           next-prompt wo_bom_code.
                           display prev_bomcode @ wo_bom_code.
                           /* JP not produced by BOM/Formula */
                           {mfmsg.i 6546 3}
                           undo, retry.
                        end.
                     end.
                  end.

                  /* Ask if other joint WOs need update. */
                  if wo_status <> "B" and wo_joint_type <> "" and
                  (qty_ord_entered or ord_date_entered
                   or rel_date_entered or due_date_entered)
                  then do:
                     if wo_status = "F" then do:
                        /* Always update Firm orders */
                        joint_qtys = yes.
                        joint_dates = yes.
                     end.
                     else do:
                        pause 0.
                        if (qty_ord_entered)
                        then
                           joint_qtys = yes.
                        else
                           joint_qtys = no.
                        if (ord_date_entered or rel_date_entered or
                            due_date_entered)
                        then
                            joint_dates = yes.
                        else
                            joint_dates = no.
                        clear frame b2.
                        update
                        joint_qtys when (qty_ord_entered)
                        joint_dates when (ord_date_entered or
                                          rel_date_entered or
                                          due_date_entered)
                        with frame b2.
                        hide frame b2 no-pause.
                     end.
                  end.
               end.  /* wo_joint_type <> ""... */

               check-routing: do: /* and bom */
                  /* FOR RMA TYPE WORK ORDERS, DON'T PERFORM ROUTING CHECKS */
                  if wo_fsm_type = "RMA"
                     then leave check-routing.

                  if available ptp_det then do:
                     if (wo_routing = ptp_routing or wo_routing = wo_part)
                     and (wo_bom_code = ptp_bom_code or
                         (wo_bom_code = wo_part and wo_joint_type = "5"))
                     then leave check-routing.
                  end.
                  else do:
                     if (wo_routing = pt_routing or wo_routing = wo_part)
                     and (wo_bom_code = pt_bom_code or
                         (wo_bom_code = wo_part and wo_joint_type = "5"))
                     then leave check-routing.
                  end.

                  /* JP have no routing. Check pt_bom, ptp_bom or ps alt */
                  if index("1234",wo_joint_type) <> 0 then do:
                     if not new_wo or add_2_joint then leave check-routing.

                     /* Valid BOM if pt_bom or ptp_bom */
                     if available ptp_det and wo_bom_code = ptp_bom_code
                     then leave check-routing.
                     if not available ptp_det and wo_bom_code = pt_bom_code
                     then leave check-routing.

                     /* Valid BOM if alt structure defined */
                     find first ps_mstr no-lock where ps_par = wo_part
                     and ps_comp = wo_bom_code
                     and ps_ps_code = "A"
                     no-error.
                     if available ps_mstr then leave check-routing.

                     msg-type = 3.
                     if index("PFB",prev_status) = 0
                     and index("PFB",wo_status) = 0
                     then msg-type = 2.
                     /* Product structure not valid for item */
                     {mfmsg.i 151 msg-type}
                     if msg-type = 3 then do:
                        next-prompt wo_bom_code.
                        undo, retry.
                     end.
                     if wo_bom_code <> "" and msg-type = 3 then
                       if not can-find(first ps_mstr where ps_par = wo_bom_code)
                       then do:
                        /* No bill of material exists */
                        {mfmsg.i 100 2}
                       end.

                  end.  /* is Joint product... */
                  else do: /* Not Joint Product */

                     /* VALIDATE ROUTING AND PRODUCT STRUCTURE */
                     msg-type = 3.
                     if index("PFB",prev_status) = 0
                     and index("PFB",wo_status) = 0
                     then msg-type = 2.
                     if msg-type = 3 then do:
                       {gprun.i ""wortbmv.p""
                                 "(input wo_part,
                                   input wo_site,
                                   input wo_routing,
                                   input wo_bom_code,
                                   input msg-type,
                                   output ok,
                                   output prompt-routing)"}
                       if not ok then do:
                         if prompt-routing then
                           next-prompt wo_routing.
                         else
                           next-prompt wo_bom_code.
                         undo, retry.
                       end.
                     end. /* if msg-type = 3 */

                  end. /* not a joint product */
               end.  /* check-routing */

/*N00J*        Begin new code...               */
               /* Check if component yield item,                */
               /* and if yield needs to be recalculated.        */
               run check-component-yield
                 (output use_op_yield,
                  output yield_pct).
               if use_op_yield then do:
                  wo_yield_pct = yield_pct.
                  display wo_yield_pct with frame b.
               end.
/*N00J*        End new code...               */

               if prev_site <> wo_site then do:
                  {gprun.i ""csavg01.p"" "(input global_part,
                                           input wo_site,
                                           output glx_set,
                                           output glx_mthd,
                                           output cur_set,
                                           output cur_mthd)"}
                  if (prev_mthd <> glx_mthd)
                  and (wo_mtl_tot <> 0 or wo_lbr_tot <> 0 or
                       wo_bdn_tot <> 0 or wo_ovh_tot <> 0 or
                       wo_sub_tot <> 0 or wo_wip_tot <> 0)
                  then do:
                     /* New site uses different costing method.     */
                     /* Change not allowed                          */
                     {mfmsg.i 5426 3}
                     next-prompt wo_site.
                     display prev_site @ wo_site.
                     undo, retry.
                  end.
                  if glx_mthd = "AVG" and wo_var then do:
                     /* Average cost site.                          */
                     /* Variance posting at labor entry not allowed */
                     {mfmsg.i 5427 3}
                     next-prompt wo_var.
                     undo, retry.
                  end.
               end.

               /* ATTRIBUTES DATA */
               if available clc_ctrl
                  and (lookup(wo_status,"P,B,C,") = 0) then do:
                  hide frame b no-pause.
                  if pt_auto_lot = yes and pt_lot_grp = " " then do:
                     if (wo_lot_next = "") then wo_lot_next =   wo_lot.
                     wo_lot_rcpt = no.
                  end.
                  {gprun.i ""clatmt1.p"" "(wo_recno)"}
               end.

               /* Set & validate GL accounts/cost centers */
               hide frame attrmt no-pause.
               hide frame b no-pause.
               {gprun.i ""womtacct.p""}
               if keyfunction (lastkey) = "end-error" then undo, retry.

               if wo_joint_type = "" or wo_status = "B" then view frame b.

               define buffer simstr for si_mstr.
               if wo_wip_tot <> 0 and wo_site <> prev_site then do:
                  find simstr where simstr.si_site = prev_site no-lock.
                  find si_mstr where si_mstr.si_site = wo_site no-lock.
                  if simstr.si_entity <> si_mstr.si_entity then do:
                     /* WIP value exists for previous site entity */
                     {mfmsg.i 551 3}
                     next-prompt wo_site.
                     undo, retry.
                  end.
               end.

               /* Transaction comments */
               if wocmmts = yes then do:
                  global_ref = wo_part.
                  cmtindx = wo_cmtindx.
                  hide frame a no-pause.
                  hide frame b no-pause.
                  {gprun.i ""gpcmmt01.p"" "(input ""wo_mstr"")"}
                  view frame a.
                  view frame b.
                  wo_cmtindx = cmtindx.
               end.

               if new_wo then
                  assign prev_ord = wo_ord_date
                         prev_due = wo_due_date
                        prev_site = wo_site
                     prev_routing = wo_routing
                     prev_bomcode = wo_bom_code
                     prev_release = wo_rel_date.

            end. /* not del-yn */
            undo_all = no.
         end. /* do with frame b */

/*N00J*  BEGIN NEW CODE... */
         /******************************************************************/

         /*   I N T E R N A L    P R O C E D U R E S     */

         /******************************************************************/

         PROCEDURE check-component-yield:

         define output parameter op_use_op_yield          as logical no-undo.
         define output parameter op_yield_pct             as decimal no-undo.

         define variable routing as character no-undo.
         define variable op      like wod_op  no-undo.

         op_yield_pct = wo_mstr.wo_yield_pct.

         if available ptp_det then op_use_op_yield = ptp_det.ptp_op_yield.
         else op_use_op_yield  = pt_mstr.pt_op_yield.

         if op_use_op_yield = yes then do:
            for first mrpc_ctrl
               fields (mrpc_op_yield)
               no-lock:  end.

            if (available mrpc_ctrl and mrpc_op_yield = no) or
            not available mrpc_ctrl
            then op_use_op_yield = no.

            if op_use_op_yield = yes then do:

              /* check if ref-date or routing code has changed */
              /* and not joint product */
              if ((wo_mstr.wo_rel_date <> prev_release) or
                 (wo_mstr.wo_routing <> prev_routing))
                 and wo_mstr.wo_joint_type = ""
              then do:
                 /* Determine if work order qualifies for re-explosion      */
                 /* as this is the only time the yield percentage           */
                 /* should change... */
                 if (index("FB",wo_status) > 0)
                 or (index("PFB",prev_status) > 0 and
                     index("FEAR",wo_status) > 0)
                 or (wo_type = "S")
                 then do:
                    /* Determine if Routing code or part should be used... */
                    if wo_routing <> "" then
                           routing = wo_routing.
                    else
                           routing = wo_part.

                    /* pass 9's as operation so all operations are used.. */
                    op = 999999999.

                    /* calculate yield percentage... */
                    {gprun.i ""gpcmpyld.p""
                        "(input routing,
                          input wo_rel_date,
                          input op,
                          output op_yield_pct)"}
                 end. /* if (index("FB",wo_status... */
              end. /* if wo_mstr.wo_rel_date <> prev_release... */
            end. /* if op-use-op-yield = yes... */
         end. /* if op-use-op-yield = yes... */

         END PROCEDURE.
/*N00J*  END NEW CODE... */
