/* woworl.p - RELEASE / PRINT WORK ORDERS USER INTERFACE                */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */


/* REVISION: 6.0      LAST MODIFIED: 05/03/90   BY: mlb *D024*          */
/* REVISION: 6.0      LAST MODIFIED: 07/10/90   BY: emb *D024a*         */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: emb *D040*          */
/* REVISION: 5.0      LAST MODIFIED: 08/21/90   BY: emb *B768*          */
/* REVISION: 6.0      LAST MODIFIED: 08/24/90   BY: wug *D054*          */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: emb *D413*          */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D741*          */
/* REVISION: 6.0      LAST MODIFIED: 08/29/91   BY: emb *D841*          */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: ram *F351*          */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: ram *F896*          */
/* REVISION: 7.3      LAST MODIFIED: 09/29/92   BY: ram *G110*          */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*          */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: emb *G268*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: emb *G870*          */
/* REVISION: 7.3      LAST MODIFIED: 04/29/93   BY: ksp *GA63*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 06/15/93   BY: qzl *GC28*          */
/* REVISION: 7.3      LAST MODIFIED: 12/02/93   BY: pxd *GH67*          */
/* REVISION: 7.3      LAST MODIFIED: 02/02/94   BY: qzl *FL91*          */
/* REVISION: 7.3      LAST MODIFIED: 07/27/94   BY: pxd *GK96*          */
/* REVISION: 7.3      LAST MODIFIED: 09/01/94   BY: ljm *FQ67*          */
/* REVISION: 7.5      LAST MODIFIED: 10/04/94   BY: taf *J035*          */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN76*          */
/* REVISION: 7.5      LAST MODIFIED: 12/09/94   BY: mwd *J034*          */
/* REVISION: 7.3      LAST MODIFIED: 12/13/94   BY: pxd *FU55*          */
/* REVISION: 7.5      LAST MODIFIED: 03/03/95   BY: tjs *J027*          */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 06/11/96   BY: *G1XY* Russ Witt    */
/* REVISION: 8.5      LAST MODIFIED: 02/04/97   BY: *J1GW* Julie Milligan */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 07/24/98   BY: *J2SX* Samir Bavkar */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 02/23/00   BY: *M0JN* Kirti Desai  */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Vincent Koh    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KC* myb              */
/* Revision: eB.SP5.Chui    Modified: 08/14/06  By: Kaine Zhang     *ss-20060818.1* */
/************************************************************************/
/*J034*  * MOVED MFDTITLE.I UP FROM BELOW */
         /* DISPLAY TITLE */
         {mfdtitle.i "b+ "}  /*FL91*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworl_p_1 "Operation"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworl_p_2 "Print Bar Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworl_p_3 "Print Co/By-Products"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworl_p_4 "Print Routing"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworl_p_5 "Print Picklist"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*       define shared variable mfguser as character.           *G247* */

         define new shared variable comp like ps_comp.
         define new shared variable qty like wo_qty_ord.
         define new shared variable eff_date as date.
         define new shared variable wo_recno as recid.
/*J027*/ define new shared variable wo_recno1 as recid.

         define new shared variable leadtime like pt_mfg_lead.
         define new shared variable prev_status like wo_status.
         define new shared variable prev_release like wo_rel_date.
         define new shared variable prev_due like wo_due_date.
         define new shared variable prev_qty like wo_qty_ord.
         define new shared variable del-yn like mfc_logical initial no.
         define new shared variable deliv like wod_deliver.
         define new shared variable barcode like mfc_logical
            label {&woworl_p_2}.
         define new shared variable wo_des like pt_desc1.
         define new shared variable wo_qty like wo_qty_ord.
         define new shared variable wo_um like pt_um.
         define new shared variable wc_description like wc_desc.
/*J027*/ define new shared variable move like woc_move.
/*J027*/ define new shared variable print_pick like mfc_logical
/*J027*/    label {&woworl_p_5} initial yes.
/*J027*/ define new shared variable print_rte like mfc_logical
/*J027*/    label {&woworl_p_4} initial yes.
/*J027*/ define new shared variable print_jp  like mfc_logical
/*J1GW* /*J027*/    label "Print Joint Products" initial yes. */
/*J1GW*/    label {&woworl_p_3} initial yes.
/*J027*  define variable i as integer.
      *  define variable nonwdays as integer.
      *  define variable overlap as integer.
      *  define variable workdays as integer.
      *  define variable interval as integer.
      *  define variable know_date as date.
      *  define variable find_date as date.
      *  define variable forward as integer.
/*FQ67*  define variable forward as integer. */
/*FQ67*/ define variable frwrd as integer.   *
      *  define variable last_due as date.
      *  define variable hours as decimal.
      *  define variable queue like wc_queue.
      *  define variable wait like wc_wait.
      *  define variable last_op like wr_op.
 *J027*/
         define variable des like pt_desc1.
/*J027*  define variable move like woc_move.  */
         define variable wrnbr like wo_nbr.
/*J027*  define variable trnbr like op_trnbr. */
         define variable wrlot like wr_lot.
/*J027*/ define variable base_id like wo_base_id.
/*J027*  define variable print_pick like mfc_logical
      *     label "Print Picklist" initial yes.
      *  define variable print_rte like mfc_logical
      *     label "Print Routing" initial yes.
      *  define variable print_pick like mfc_logical
      *     label "Print Picklist" initial yes.
      *  define variable print_rte like mfc_logical
      *     label "Print Routing" initial yes.
      *  define new shared variable any_issued like mfc_logical.
      *  define new shared variable any_feedbk like mfc_logical.
      *  define new shared variable picklistprinted like mfc_logical.
      *  define new shared variable routingprinted like mfc_logical.
 *J027*/
         define new shared variable prd_recno as recid.
/*G1XY*/ define new shared variable critical-part like wod_part    no-undo.
/*M0JN*/ define new shared variable critical_flg  like mfc_logical no-undo.
/*J027*  define new shared variable prev_site like wo_site.            */
/*J027*  define new shared variable undo_all like mfc_logical no-undo. */
/*J035*/ define variable wobatch like wo_batch.

/*ss-20060818.1*/  DEFINE NEW SHARED VARIABLE rcdXwtp AS RECID NO-UNDO.
/*ss-20060818.1*/  DEFINE NEW SHARED VARIABLE strWoPtType LIKE pt_part_type NO-UNDO.

         /* OVERLAY frame a1 REPORT OPTIONS */
/*J027*  {mfworlb1.i &new="new" &row="7"} */
/*J027*/ {mfworlb1.i &new="new" &row="10"}

         eff_date = today.

         find first woc_ctrl no-lock no-error.
         if available woc_ctrl then move = woc_move.
         release woc_ctrl.

         form
            skip(1)
            wrnbr          colon 23
            deliv          colon 58
            wrlot          colon 23
            barcode        colon 58
/*J035*/    wobatch        colon 23
/*J035*/    move           colon 58 label {&woworl_p_1}
            print_pick     colon 23
/*            move           colon 58         */
/*J027*     print_rte      colon 23 skip(1) */
/*J027*/    print_rte      colon 23
/*J027*/    print_jp       colon 23 skip(1)
            wo_part        colon 23
            wo_rel_date    colon 58
            des            at 25 no-label
            wo_qty_ord     colon 23
            wo_due_date    colon 58
            wo_qty_comp    colon 23
            wo_status      colon 58
            wo_so_job      colon 23
            wo_vend        colon 58
            skip(1)
            wo_rmks        colon 23
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         repeat with frame a:

            seta:
/*GH67      do on error undo, retry:      */
/*GH67*/    do transaction on error undo, retry:

/*G870*/       /* Added section */
               if batchrun then do
               with frame batch 2 columns width 80 no-attr-space:
                  prompt-for

/*J2SX**             wrnbr wrlot print_pick print_rte deliv barcode */
/*J2SX*/             wrnbr wrlot print_pick print_rte print_jp deliv barcode
                     move
                     incl_zero_reqd incl_zero_open
                     incl_pick_qtys incl_floor_stk
/*J027*/             jp_1st_last_doc
                  with frame batch.
/*J2SX**          assign wrnbr wrlot print_pick print_rte deliv barcode move */
/*J2SX*/          assign wrnbr wrlot print_pick print_rte
/*J2SX*/                 print_jp deliv barcode move
                     incl_zero_reqd incl_zero_open
/*J027*              incl_pick_qtys incl_floor_stk. */
/*J027*/             incl_pick_qtys incl_floor_stk jp_1st_last_doc.

/*J2SX**          display wrnbr wrlot print_pick print_rte deliv barcode move */
/*J2SX*/          display wrnbr wrlot print_pick print_rte print_jp deliv
/*J2SX*/                  barcode move
                  with frame a.
/*FU55*/          find wo_mstr where wo_nbr = wrnbr and wo_lot = wrlot no-error.
               end.
               else do:
/*G870*/       /* End of added section */
                  update wrnbr with frame a editing:

                     /* FIND NEXT/PREVIOUS RECORD */
                     {mfnp.i wo_mstr wrnbr wo_nbr wrnbr wo_nbr wo_nbr}

                     if recno <> ? then do:
                        wrlot = wo_lot.
                        des = "".
                        find pt_mstr where pt_part = wo_part
                        no-lock no-error no-wait.
                        if available pt_mstr then des = pt_desc1.
                        display
                           wo_nbr @ wrnbr
                           wo_lot @ wrlot
/*J035*/                   wo_batch @ wobatch
                           wo_part
                           des
                           wo_qty_ord
                           wo_qty_comp
                           wo_so_job
                           wo_rel_date
                           wo_due_date
                           wo_status
                           wo_vend
                           wo_rmks.
                     end.
                  end.
/*G870*/       end.

               if available wo_mstr then
                  find wo_mstr no-lock where wo_nbr = wrnbr
                  and wo_lot = wrlot no-error.
               if not available wo_mstr then
                  if wrnbr <> "" then
                     find wo_mstr no-lock where wo_nbr = wrnbr no-error.
               if ambiguous wo_mstr and wrnbr <> "" then
                  find first wo_mstr no-lock where wo_nbr = wrnbr no-error.
               if available wo_mstr then do:
                  des = "".
                  find pt_mstr where pt_part = wo_part
                  no-lock no-error no-wait.
                  if available pt_mstr then des = pt_desc1.
                  display
                     wo_nbr @ wrnbr
                     wo_lot @ wrlot
/*J035*/             wo_batch @ wobatch
                     wo_part
                     des
                     wo_qty_ord
                     wo_qty_comp
                     wo_so_job
                     wo_rel_date
                     wo_due_date
                     wo_status
                     wo_vend
                     wo_rmks.
               end.
               else display " " @ wrlot
/*J035*/               "" @ wobatch.

/*FL91*/ /* /*GC28*/       wrlot = "". */
/*FL91*/       if input wrlot = "" then
/*GC28*/       find first wo_mstr where wo_nbr = wrnbr no-lock no-error.
/*GC28*/       if available wo_mstr then wrlot = wo_lot.

/*G870*/       if not batchrun then
               prompt-for wrlot editing:

                  if wrnbr = "" then do:
                     /* FIND NEXT/PREVIOUS RECORD */
                     {mfnp.i wo_mstr wrlot wo_lot wrlot wo_lot wo_lot}
                  end.
                  else do:
                     {mfnp01.i wo_mstr wrlot wo_lot wrnbr wo_nbr wo_nbr}
                  end.

                  if recno <> ? then do:
                     des = "".
                     find pt_mstr where pt_part = wo_part
                     no-lock no-error no-wait.
                     if available pt_mstr then des = pt_desc1.
                     display
                        wo_nbr @ wrnbr
                        wo_lot @ wrlot
/*J035*/                wo_batch @ wobatch
                        wo_part
                        des
                        wo_qty_ord
                        wo_qty_comp
                        wo_so_job
                        wo_rel_date
                        wo_due_date
                        wo_status
                        wo_vend
                        wo_rmks.
                  end.
               end.

/*FL91*/       assign wrlot.

               find wo_mstr no-lock where wo_lot = wrlot no-error.
               if not available wo_mstr then do:
                  {mfmsg.i 503 3}
                  /* WORK ORDER NOT FOUND */
                  next.
               end.
               else do:
                  if wo_nbr <> wrnbr and wrnbr <> "" then do:
                     {mfmsg.i 508 3}
                     /* LOT NUMBER BELONGS TO A DIFFERENT WORK ORDER */
                     next.
                  end.
               end.

/*N05Q*/       /* PREVENT ACCESS TO PROJECT ACTIVITY RECORDING WORK ORDERS */
/*N05Q*/       if wo_fsm_type = "PRM" then do:
/*N05Q*/           {mfmsg.i 3426 3}    /* CONTROLLED BY PRM MODULE */
/*N05Q*/           next.
/*N05Q*/       end.

               /* PREVENT ACCESS TO CALL ACTIVITY RECORDING WORK ORDERS */
/*J04C*/       if wo_fsm_type = "FSM-RO" then do:
/*J04C*/           {mfmsg.i 7492 3}    /* FIELD SERVICE CONTROLLED */
/*J04C*/           next.
/*J04C*/       END.

            /* ***********************ss-20060818.1 B Add********************** */
            FOR FIRST xwtp_det
                WHERE wo_nbr BEGINS xwtp_type
                    AND xwtp_site = wo_site
                    AND xwtp_is_ser = YES
                NO-LOCK:
            END.
            
            IF NOT AVAILABLE xwtp_det THEN DO:
                /*ss-20060818.1*  ERROR msg 9002: NOT VALIDATE TYPE wo  */
                {mfmsg.i 9002 3}
                NEXT.
            END.
            ELSE DO:
                rcdXwtp = RECID(xwtp_det) .
            END.
            
            FOR FIRST pt_mstr WHERE pt_part = wo_part NO-LOCK:  END.
            strWoPtType = IF AVAILABLE pt_mstr THEN pt_part_type ELSE "" .
            /* ***********************ss-20060818.1 E Add********************** */

               wrnbr = wo_nbr.
               wrlot = wo_lot.

               des = "".
               find pt_mstr where pt_part = wo_part no-lock no-error no-wait.
               if available pt_mstr then des = pt_desc1.
               display
                  wo_nbr @ wrnbr
                  wo_lot @ wrlot
/*J035*/          wo_batch @ wobatch
                  wo_part
                  des
                  wo_qty_ord
                  wo_qty_comp
                  wo_so_job
                  wo_rel_date
                  wo_due_date
                  wo_status
                  wo_vend
                  wo_rmks.

               if index("PFBEAR",wo_status) = 0 then do:
                  {mfmsg.i 516 3}
                  /* CAN ONLY RELEASE FIRM PLANNED OR ALLOCATED WORK ORDERS */
                  next.
               end.

                /*GN76 ADDED FOLLOWING SECTION*/
                if wo_type = "c" and wo_nbr = "" then do:
                   {mfmsg.i 5123 3}
                   next.
                end.
                /*GN76 END SECTION*/

/*J027*/       /* GET BASE PROCESS WO IF THIS IS A JOINT PRODUCT */
/*J027*/       if index("1234",wo_joint_type) > 0 then do:
/*J027*/          base_id = wo_base_id.
/*J027*/          find wo_mstr where wo_lot = base_id no-lock no-error.
/*J027*/          if not available wo_mstr then do:
/*J027*/             /* Joint Product not produced by BOM/Formula */
/*J027*/             {mfmsg.i 6546 3}
/*J027*/             next.
/*J027*/          end.
/*J027*/       end.

/*J034*/       if not batchrun then do:
/*J034*/          {gprun.i ""gpsiver.p""
                   "(input wo_site, input ?, output return_int)"}
/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg02.i 2710 3 wo_site} /* USER DOES NOT HAVE  */
/*J034*/                                        /* ACCESS TO SITE XXXX */
/*J034*/             undo seta, retry.
/*J034*/          end.
/*J034*/       end.

               if wo_qty_ord >= 0 then
                  qty = max (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).
               else
                  qty = min (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).
               wo_qty = qty.
               wo_recno = recid(wo_mstr).
               comp = wo_part.

               prev_status = wo_status.
               prev_release = wo_rel_date.
               prev_due = wo_due_date.
               prev_qty = wo_qty_ord.

/*G870*/       if not batchrun then
               update
                  print_pick
                  print_rte
/*J027*/          print_jp
                  deliv
                  barcode
                  move.
/*J027****
/*F351*/ *     if print_pick
/*G870*/ *     and not batchrun
/*F351*/ *     then do:
/*F351*/ *        update
/*F351*/ *           incl_zero_reqd
/*F351*/ *           incl_zero_open
/*F351*/ *           incl_pick_qtys
/*F351*/ *           incl_floor_stk
/*F351*/ *        with frame a1.
/*F351*/ *     end.
 *J027****/
/*J027*/ /* Begin added block */
               if (print_pick or print_jp) and not batchrun
               then do:
                  update
                     incl_zero_reqd when (print_pick)
                     incl_zero_open when (print_pick)
                     incl_pick_qtys when (print_pick)
                     incl_floor_stk when (print_pick)
                     jp_1st_last_doc when (print_jp)
                  with frame a1.
               end.
/*J027*/ /* End added block */

/*G870*/       /* Added section */
               bcdparm = "".
               {mfquoter.i wrnbr}
               {mfquoter.i wrlot}
               {mfquoter.i print_pick}
               {mfquoter.i print_rte}
/*J027*/       {mfquoter.i print_jp}
               {mfquoter.i deliv}
               {mfquoter.i barcode}
               {mfquoter.i move}
               {mfquoter.i incl_zero_reqd}
               {mfquoter.i incl_zero_open}
               {mfquoter.i incl_pick_qtys}
               {mfquoter.i incl_floor_stk}
/*J027*/       {mfquoter.i jp_1st_last_doc}
/*G870*/       /* End of added section */

               /* SELECT PRINTER */
/*G870*        {mfselprt.i "printer" 80} */
/*G870*/       {mfselbpr.i "printer" 80}

               /* SAVE prd_det RECID FOR BAR-CODES LATER */
/*J027*/       find prd_det where prd_dev = dev no-lock no-error.
/*J027*/       if available prd_det then prd_recno = recid(prd_det).

/*ss-20060818.1*  /*J027*/       {gprun.i ""woworl1.p""}  */
/*ss-20060818.1*/                {gprun.i ""xxwoworl1x.p""}

/*J027*/       {mfreset.i}
/*J027********************************************** now in woworl1.p *********
               printset:                                                      *
               do on error undo, leave:                                       *
                                                                              *
/*GH67/*G870*/    do transaction:       */                                    *
/*GH67*/          do:                                                         *
/*G870*/             find wo_mstr exclusive where recid(wo_mstr) = wo_recno.  *
                                                                              *
                     if wo_rel_date <> today and wo_status <> "R" then        *
                        wo_rel_date = today.                                  *
                                                                              *
                     if index("PFBEA",wo_status) <> 0 then wo_status = "R".   *
/*G870*/          end.                                                        *
                                                                              *
/*GK96*/          if wo_qty_ord >= 0 then                                     *
/*GK96*/           qty = max (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).     *
/*GK96*/          else                                                        *
/*GK96*/           qty = min (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).     *
/*GK96*/          wo_qty = qty.                                               *
                                                                              *
                  prev_site = wo_site.                                        *
                  undo_all = no.                                              *
                                                                              *
                  {gprun.i ""wowomta.p""}                                     *
                                                                              *
                  picklistprinted = no.                                       *
                  routingprinted = no.                                        *
                                                                              *
                  if undo_all = no then do:                                   *
                     if print_pick then do:                                   *
                        page_counter = page-number - 1.                       *
                        wo_recno = recid(wo_mstr).                            *
                        {gprun.i ""woworlb.p"" }                              *
                     end.                                                     *
                     if print_rte then do:                                    *
                        page_counter = page-number - 1.                       *
                        wo_recno = recid(wo_mstr).                            *
                        prd_recno = recid(prd_det).                           *
                        {gprun.i ""woworld.p"" }                              *
                     end.                                                     *
                  end.                                                        *
                                                                              *
                  if (print_pick and not picklistprinted)                     *
                  or (print_rte and not routingprinted)                       *
                  or undo_all = yes                                           *
/*GH67            then do                    */                               *
/*GH67/*G870*/    transaction:               */                               *
/*GH67*/          then do:                                                    *
                     page.                                                    *
                     if undo_all then do:                                     *
                        find msg_mstr where msg_lang = global_user_lang       *
                        and msg_nbr = 4984 no-lock no-error.                  *
                        if available msg_mstr then                            *
                           put                                                *
                              substr(msg_desc,1,40)                           *
/*G110                        wo_nbr                     */                   *
/*F351                        substr(msg_desc,41) skip.  */                   *
/*G110  /*F351*/              substr(msg_desc,40) skip.  */                   *
/*G110*/                      + wo_nbr                                        *
/*G110*/                      + substr(msg_desc,40) format "x(80)" skip.      *
                        wo_status = prev_status.                              *
                     end.                                                     *
                     if (print_pick and not picklistprinted) then             *
                        put                                                   *
                           "***No picklist was printed for work order "       *
                           wo_nbr skip.                                       *
                     if (print_rte and not routingprinted) then               *
                        put                                                   *
                           "***No routing was printed for work order "        *
                           wo_nbr skip.                                       *
                     page.                                                    *
                  end.                                                        *
                                                                              *
/*GH67            if undo_all = no then do       */                           *
/*GH67/*G870*/    transaction:                   */                           *
/*GH67*/          if undo_all = no then do:                                   *
                                                                              *
                     if wo_status <> "R" then wo_status = "R".                *
                                                                              *
                     if move then do:                                         *
                        move = no.                                            *
                        find first wr_route where wr_lot = wo_lot             *
                        and wr_nbr = wo_nbr no-error.                         *
                        if available wr_route and wr_status = ""              *
                        then do:                                              *
                           wrlot = wr_lot.                                    *
                           {mfopmv.i wr_qty_ord "no"}                         *
                        end.                                                  *
                        move = yes.                                           *
                     end.                                                     *
                  end.                                                        *
                  yn = yes.                                                   *
                                                                              *
                  {mfreset.i}                                                 *
                                                                              *
                  if undo_all then do:                                        *
/*G110               {mfmsg.i 4984 2} */                                      *
/*G110*/             {mfmsg.i 4984 4}                                         *
                     undo seta, retry seta.                                   *
                  end.                                                        *
                                                                              *
/*G870*           {mfmsg01.i 32 1 yn}                                         *
                  if yn = no then undo seta, retry seta.                      *
                  */                                                          *
               end. /*printset*/                                              *
                                                                              *
/*G870*        /* Deleted section */                                          *
 *             /* work order */                                               *
 *             {mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """"                  *
 *             wo_rel_date wo_due_date                                        *
 *             "wo_qty_ord - wo_qty_comp - wo_qty_rjct"                       *
 *             "SUPPLY" "Work Order" wo_site }                                *
 *                                                                            *
 *             if available mrp_det and index("FBE",wo_status) > 0 then       *
 *                mrp_type = "SUPPLYF".                                       *
 *                                                                            *
 *             {mfmrw.i "wo_scrap" wo_part wo_nbr wo_lot """"                 *
 *             wo_rel_date wo_due_date                                        *
 *             "(wo_qty_ord - wo_qty_comp - wo_qty_rjct)                      *
 *                   * (1 - wo_yield_pct / 100)"                              *
 *             "DEMAND" "Scrap Requirement" wo_site }                         *
**G870*/       /* End of deleted section */                                   *
                                                                              *
 *J027*************************************************************************/
            end.  /* seta */
         end. /* repeat */
