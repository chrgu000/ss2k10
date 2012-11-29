/* rwrocp.p - COPY ROUTING                                              */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0      LAST MODIFIED: 05/05/85   BY: PML */
/* REVISION: 1.0      LAST MODIFIED: 05/12/86   BY: EMB */
/* REVISION: 1.0      LAST MODIFIED: 09/02/87   BY: EMB */
/* REVISION: 2.1      LAST MODIFIED: 09/23/87   BY: WUG *A94* */
/* REVISION: 2.1      LAST MODIFIED: 11/04/87   BY: WUG *A101* */
/* REVISION: 2.1      LAST MODIFIED: 12/10/87   bY: PML *a110* */
/* REVISION: 4.0      LAST MODIFIED: 02/17/88   BY: RL  *A171**/
/* REVISION: 4.0      LAST MODIFIED: 08/17/88   BY: WUG *A396**/
/* REVISION: 5.0      LAST MODIFIED: 03/05/90   BY: emb *B605*/
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: emb *D001*/
/* REVISION: 6.0      LAST MODIFIED: 07/09/90   BY: WUG *D043*/
/* REVISION: 6.0      LAST MODIFIED: 10/23/90   BY: emb *D129*/
/* REVISION: 6.0      LAST MODIFIED: 01/15/91   BY: bjb *D248*/
/* REVISION: 6.0      LAST MODIFIED: 06/03/91   BY: emb *D668*/
/* REVISION: 7.0      LAST MODIFIED: 09/11/92   BY: emb *F887*/
/* REVISION: 7.3      LAST MODIFIED: 09/01/94   BY: pxd *FQ69*/
/* REVISION: 7.3      LAST MODIFIED: 10/19/94   BY: ljm *GN40*/
/* REVISION: 7.3      LAST MODIFIED: 11/08/94   BY: WUG *GO39*/
/* REVISION: 7.3      LAST MODIFIED: 12/20/94   BY: jwy *F09J*/
/* REVISION: 8.5      LAST MODIFIED: 04/23/96   BY: *J04C* Sue Poland       */
/* REVISION: 8.5      LAST MODIFIED: 06/14/96   BY: *J0TR* M. Deleeuw       */
/* REVISION: 8.5      LAST MODIFIED: 01/09/97   BY: *H0QZ* Julie Milligan   */
/* REVISION: 8.5      LAST MODIFIED: 07/02/97   BY: *J1PM* Amy Esau         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 06/21/99   BY: *J3GZ* Sanjeev Assudani */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                */
/* REVISION: 9.1      LAST MODIFIED: 05/04/01 BY: *N0YC* Hualin Zhong         */

/************************************************************************/

/* Note: Changes made here may also be necessary in fsrocp.p */

/* DISPLAY TITLE */
{mfdtitle.i "120829.0"}
{xxloaddata.i}
/* ********** Begin Translatable Strings Definitions ********* */

/*N0YC* &SCOPED-DEFINE rwrocp_p_1 "Run" */
/* MaxLen: Comment: */

/*N0YC* &SCOPED-DEFINE rwrocp_p_2 "Setup" */
/* MaxLen: Comment: */

&SCOPED-DEFINE rwrocp_p_3 "Source Routing Code"
/* MaxLen: Comment: */

/*N0YC* &SCOPED-DEFINE rwrocp_p_4 "Move" */
/* MaxLen: Comment: */

&SCOPED-DEFINE rwrocp_p_5 "Hours"
/* MaxLen: Comment: */

&SCOPED-DEFINE rwrocp_p_6 "Destination Routing Code"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable part1 like ro_routing
/*F887*/  label {&rwrocp_p_3}.
define variable part2 like ro_routing
/*F887*/ label {&rwrocp_p_6}.
define variable op1 like ro_op format ">>>>>>".
define variable op2 like ro_op format ">>>>>>".
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc1.
define variable yn like mfc_logical.
define buffer ro_from for ro_det.
/*N0YC* define variable srh as character format "x(5)" initial {&rwrocp_p_2}. */
/*N0YC*/ define variable srh as character format "x(5)".
define variable s_hours like ro_run column-label {&rwrocp_p_5}.

define buffer cmtdet for cmt_det.
define variable i as integer.
define variable cmtindx like cmt_indx.
define variable cmtseq like cmt_seq.

/*J3GZ*/ define variable l_ro_routing like ro_routing no-undo.
/*J3GZ*/ define variable l_ro_op      like ro_op      no-undo.
/*ADM*/ {quotuser.i}
/* NOTE:  THE CODE CONTAINED IN THIS INCLUDE FILE WAS COMMENTED OUT FOR 8.5 */
/*        AS THE REFERENCED FIELDS HAVE NOW BEEN ADDED TO THE RO_DET SCHEMA */
/*J0TR**  {rerosdef.i}                                   /*GO39*/         ***/

/*J0TR** THE FOLLOWING FIELDS WERE COMMENTED OUT - NO LONGER NEEDED **
. define variable save_ro_po_nbr like wr_po_nbr.                      /*GO39*/
. define variable save_ro_po_line like pod_line.                      /*GO39*/
. define variable save_ro_mv_nxt_op like mfc_logical label "Move Next Op".        /*GO39*/
. define variable save_ro_wipmtl_part like pt_part label "WIP Item".  /*GO39*/
. define variable save_ro_auto_lbr like mfc_logical label "Auto Labor Report".    /*GO39*/
**J0TR END OF COMMENTED CODE **/

/*FQ69*/  /* changes made for translation SR30009542  */
form
/*GN40*   "     Source Routing Code:" */
/*GN40*/   part1          colon 27 /* no-label */
   desc1          no-label
   op1            colon 27
   op2            label {t001.i}
   skip(1)
/*GN40*   "Destination Routing Code:" */
/*GN40*/   part2          colon 27 /* no-label */
   desc2          no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*N0YC*/ srh = getTermLabel("SETUP",5).

repeat:

/*J3GZ*/    assign
/*J3GZ*/       l_ro_routing = ""
/*J3GZ*/       l_ro_op      = ?.

            display part1 op1 op2 part2 with frame a.
            do on error undo , retry with frame a:
                set part1 op1 op2 part2 with frame a editing:

                   if frame-field = "part1" then do:
                       /* FIND NEXT/PREVIOUS RECORD */
/*J04C*              {mfnp.i ro_det part1 ro_routing part1 ro_routing ro_routing} */
/*J04C*/             {mfnp05.i ro_det ro_fsm_type
                        "ro_fsm_type = "" "" " ro_routing
                        "input part1"}

                       if recno <> ? then do:
                           find pt_mstr where pt_part = ro_routing no-lock no-error.
                           part1 = ro_routing.
                           display part1.
                           if available pt_mstr then display pt_desc1 @ desc1.
                           else display "" @ desc1.
                       end.
                       recno = ?.
                   end.
                   else if frame-field = "part2" then do:
                       /* FIND NEXT/PREVIOUS RECORD */
                       {mfnp.i pt_mstr part2 pt_part part2 pt_part pt_part}
                       if recno <> ? then do:
                            part2 = pt_part.
                            display part2 pt_desc1 @ desc2.
                       end.
                   end.
                   else do:
                       status input.
                       readkey.
                       apply lastkey.
                   end.
                end.    /* editing */

/**ADM Check "TO", for quotuser or non-quotuser*/
         if isquotuser and not batchrun then do:
      if substr(part2,1,4) <> "QUOT" then do:
               if global_user_lang = "tw" then
      compmsg = getmsg(8900).
         else
            compmsg = getmsg(8900).
         {mfmsg03.i 2685 1 compmsg """" """"}
               next-prompt part2 with frame a.
         undo,retry.
      end.
          end.
    else do:
      if substr(part2,1,4) = "QUOT" then do:
               if global_user_lang = "tw" then
      compmsg = getmsg(8901).
         else
      compmsg = getmsg(8901).
         {mfmsg03.i 2685 1 compmsg """" """"}
               next-prompt part2 with frame a.
         undo,retry.
      end.
    end.
/**ADM*/

                desc1 = "".
                desc2 = "".
                find pt_mstr where pt_part = part1 no-lock no-error.
                if available pt_mstr then do:
                   part1 = pt_part.
                   desc1 = pt_desc1.
                end.
                display part1 desc1 with frame a.
                find pt_mstr where pt_part = part2 no-lock no-error.
                if available pt_mstr then do:
                   part2 = pt_part.
                   desc2 = pt_desc1.
                end.
                display part2 desc2 with frame a.
                hide frame b.

/*J04C*         ADDED THE FOLLOWING */
                /* THIS TRANSACTION SHOULD COPY STANDARD (NON-SERVICE) */
                /* ROUTINGS ONLY.                                      */
                find first ro_det where ro_routing = part1
                    and ro_fsm_type = "FSM" no-lock no-error.
                if available ro_det then do:
/*N0YC*             {mfmsg.i 7423 3} */
/*N0YC*/            {pxmsg.i &MSGNUM=7423 &ERRORLEVEL=3}
                    /* THIS IS A SERVICE ROUTING, NOT A STANDARD ROUTING */
                    undo, retry.
                end.
/*J04C*         END ADDED CODE */

                yn = yes.
/*J04C*         if can-find (first ro_det where ro_routing = part2) then do:    */
/*J04C*/        find first ro_det where ro_routing = part2 no-lock no-error.
/*J04C*/        if available ro_det then do:
/*J04C*/            if ro_fsm_type = "FSM" then do:
                    /* DO NOT ADD NON-SERVICE OPERATIONS TO AN EXISTING */
                    /* SERVICE ROUTING.                                 */
/*J04C*/                {mfmsg.i 7423 3}
                        /* THIS IS A SERVICE ROUTING, NOT A STD ROUTING */
/*J04C*/                next-prompt part2 with frame a.
/*J04C*/                undo, retry.
/*J04C*/            end.
/*J04C*/            else do:
/*N0YC*                {mfmsg.i 250 2} */
/*N0YC*/               {pxmsg.i &MSGNUM=250 &ERRORLEVEL=2}
                       /* PART NUMBER HAS EXISTING ROUTING */
/*J04C*/            end.
                end.    /* if available ro_det */

                bcdparm = "".
                {mfquoter.i part1  }
                {mfquoter.i op1    }
                {mfquoter.i op2    }
                {mfquoter.i part2  }

                {mfselbpr.i "printer" 80}
                {mfphead2.i}
            end.    /* do on error */

   for each ro_from where ro_routing = part1 and ro_op >= op1
   and (ro_op <= op2 or op2 = 0) by ro_op
   with frame b width 80 no-attr-space:

/*J0TR** THE FOLLOWING CODE WAS COMMENTED OUT; NO LONGER NEEDED **
.      /*GO39 ADDED FOLLOWING SECTION*/
.      {rerosget.i
.      &routing=ro_from.ro_routing &op=ro_from.ro_op &start=ro_from.ro_start}
.
.      save_ro_po_nbr = ro_po_nbr.
.      save_ro_po_line = ro_po_line.
.      save_ro_mv_nxt_op = ro_mv_nxt_op.
.      save_ro_wipmtl_part = ro_wipmtl_part.
.      save_ro_auto_lbr = ro_auto_lbr.
.      /*GO39 END SECTION*/
**J0TR** END OF COMMENTED SECTION **/

/*J3GZ** find ro_det where ro_det.ro_routing = part2 */
/*J3GZ** and ro_det.ro_op = ro_from.ro_op no-error.  */

/*J3GZ*/ /* BEGIN ADD SECTION */

         for first ro_det
            fields(ro_auto_lbr ro_batch ro_bom_code ro_cmtindx ro_cyc_rate
                   ro_cyc_unit ro_desc ro_elm_bdn ro_elm_lbr ro_elm_sub ro_end
                   ro_fsc_code ro_fsm_type ro_inv_value ro_lbr_ovhd ro_mch
                   ro_mch_op ro_men_mch ro_milestone ro_move ro_mv_nxt_op ro_op
                   ro_po_line ro_po_nbr ro_queue ro_rollup ro_routing
                   ro_run ro_setup ro_setup_men ro_start ro_std_batch
                   ro_std_op ro_sub_cost ro_sub_lead ro_tool ro_tran_qty
                   ro_user1 ro_user2 ro_vend ro_wait ro_wipmtl_part ro_wkctr
                   ro_yield_pct ro__chr01 ro__chr02 ro__chr03 ro__chr04
                   ro__chr05 ro__dec01 ro__dec02 ro__dte01 ro__dte02 ro__log01)
                   no-lock
                   where ro_det.ro_routing = part2
                   and ro_det.ro_op = ro_from.ro_op:
         end. /* FOR FIRST RO_DET */

         if available ro_det and
            ro_det.ro_routing = l_ro_routing and
            ro_det.ro_op      = l_ro_op then
            release ro_det .

/*J3GZ*/ /* END ADD SECTION */

      if not available ro_det then do with frame b:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         if page-size - line-counter < 3 then page.

         display ro_from.ro_op ro_from.ro_desc ro_from.ro_wkctr
/*N0YC*  {&rwrocp_p_2} @ srh no-labels ro_from.ro_setup @ s_hours with width 80. */
/*N0YC*/ getTermLabel("SETUP",5) @ srh no-labels
         ro_from.ro_setup @ s_hours with width 80.

         down 1.
/*N0YC*  display {&rwrocp_p_1} @ srh no-labels ro_from.ro_run @ s_hours. */
/*N0YC*/ display getTermLabel("RUN",5) @ srh no-labels ro_from.ro_run @ s_hours.

         down 1.
/*N0YC*  display {&rwrocp_p_4} @ srh no-labels ro_from.ro_move @ s_hours. */
/*N0YC*/ display getTermLabel("MOVE",5) @ srh no-labels
         ro_from.ro_move @ s_hours.

         create ro_det.
         assign
            ro_det.ro_routing   = caps(part2)
            ro_det.ro_op     = ro_from.ro_op
            ro_det.ro_desc   = ro_from.ro_desc
            ro_det.ro_wkctr  = ro_from.ro_wkctr
            ro_det.ro_mch    = ro_from.ro_mch
            ro_det.ro_setup  = ro_from.ro_setup
            ro_det.ro_run    = ro_from.ro_run
            ro_det.ro_move   = ro_from.ro_move
            ro_det.ro_yield  = ro_from.ro_yield
            ro_det.ro_start  = ro_from.ro_start
            ro_det.ro_end    = ro_from.ro_end
            ro_det.ro_std_op = ro_from.ro_std_op
            ro_det.ro_tool   = ro_from.ro_tool
            ro_det.ro_vend   = ro_from.ro_vend
            ro_det.ro_sub_cost = ro_from.ro_sub_cost.

         assign
            ro_det.ro_batch    = ro_from.ro_batch
/*J04C*/    ro_det.ro_bom_code  = ""
            ro_det.ro_cyc_rate = ro_from.ro_cyc_rate
            ro_det.ro_cyc_unit = ro_from.ro_cyc_unit
/*J04C*/    ro_det.ro_fsc_code  = ""
/*J04C*/    ro_det.ro_fsm_type  = ""
            ro_det.ro_inv_value = ro_from.ro_inv_value
            ro_det.ro_lbr_ovhd = ro_from.ro_lbr_ovhd
            ro_det.ro_mch_op   = ro_from.ro_mch_op
            ro_det.ro_men_mch  = ro_from.ro_men_mch
            ro_det.ro_milestone = ro_from.ro_milestone
            ro_det.ro_queue    = ro_from.ro_queue
            ro_det.ro_setup_men = ro_from.ro_setup_men
            ro_det.ro_sub_lead = ro_from.ro_sub_lead
            ro_det.ro_tran_qty = ro_from.ro_tran_qty
            ro_det.ro_user1    = ro_from.ro_user1
            ro_det.ro_user2    = ro_from.ro_user2
            ro_det.ro_wait     = ro_from.ro_wait
/*F09J*/    ro_det.ro__chr01   = ro_from.ro__chr01
/*F09J*/    ro_det.ro__chr02   = ro_from.ro__chr02
/*F09J*/    ro_det.ro__chr03   = ro_from.ro__chr03
/*F09J*/    ro_det.ro__chr04   = ro_from.ro__chr04
/*F09J*/    ro_det.ro__chr05   = ro_from.ro__chr05
/*F09J*/    ro_det.ro__dte01   = ro_from.ro__dte01
/*F09J*/    ro_det.ro__dte02   = ro_from.ro__dte02
/*F09J*/    ro_det.ro__dec01   = ro_from.ro__dec01
/*F09J*/    ro_det.ro__dec02   = ro_from.ro__dec02
/*F09J*/    ro_det.ro__log01   = ro_from.ro__log01
/*F09J*/    ro_det.ro_std_batch = ro_from.ro_std_batch
/*F09J*/    ro_det.ro_rollup    = ro_from.ro_rollup
/*F09J*/  /*  ro_det.ro_rollup_id = ro_from.ro_rollup_id */
/*F09J*/    ro_det.ro_elm_lbr   = ro_from.ro_elm_lbr
/*F09J*/    ro_det.ro_elm_bdn   = ro_from.ro_elm_bdn
/*F09J*/    ro_det.ro_elm_sub   = ro_from.ro_elm_sub
/*F09J*/  /*  ro_det.ro_start_ecn = ro_from.ro_start_ecn */
/*F09J*/  /*  ro_det.ro_end_ecn   = ro_from.ro_end_ecn. */
/*J0TR*/    ro_det.ro_po_nbr      = ro_from.ro_po_nbr
/*J0TR*/    ro_det.ro_po_line     = ro_from.ro_po_line
/*J0TR*/    ro_det.ro_mv_nxt_op   = ro_from.ro_mv_nxt_op
/*J0TR*/    ro_det.ro_wipmtl_part = ro_from.ro_wipmtl_part
/*J0TR*/    ro_det.ro_auto_lbr    = ro_from.ro_auto_lbr.

/*J3GZ*/    assign
/*J3GZ*/       l_ro_routing = ro_det.ro_routing
/*J3GZ*/       l_ro_op      = ro_det.ro_op.

/*J0TR** COMMENTED OUT THE FOLLOWING; NO LONGER NEEDED **
.         /*GO39 ADDED FOLLOWING SECTION*/
.         {rerosget.i
.         &routing=ro_det.ro_routing &op=ro_det.ro_op &start=ro_det.ro_start}
.
.         ro_po_nbr = save_ro_po_nbr.
.         ro_po_line = save_ro_po_line.
.         ro_mv_nxt_op = save_ro_mv_nxt_op.
.         ro_wipmtl_part = save_ro_wipmtl_part.
.         ro_auto_lbr = save_ro_auto_lbr.
.
.         {rerosput.i}
.         /*GO39 END SECTION*/
.
**J0TR** END OF COMMENTED SECTION **/

         find last cmt_det where cmt_indx = ro_from.ro_cmtindx
         no-lock no-error.
         if available cmt_det then do:
            cmtseq = cmt_seq.
            create cmt_det.

/*J1PM*             assign_cmt_indx:
 *J1PM*             repeat:
 *J1PM*                do for cmtdet on error undo:
 *J1PM*                   find last cmtdet no-lock
 *J1PM* /*H0QZ*/            where cmtdet.cmt_indx >= 0
 *J1PM* /*H0QZ*/            and cmtdet.cmt_seq >= 0
 *J1PM*                   no-error.
 *J1PM*                   if available cmtdet then
 *J1PM*                      assign
 *J1PM*                      cmt_det.cmt_indx = cmtdet.cmt_indx + 1
 *J1PM*                      cmt_det.cmt_seq = 0.
 *J1PM*                   else
 *J1PM*                      assign cmt_det.cmt_indx = 1
 *J1PM*                      cmt_det.cmt_seq = 0.
 *J1PM*                   leave assign_cmt_indx.
 *J1PM*                end.  /* DO FOR CMTDET...*/
 *J1PM*             end. /* REPEAT: */
 *J1PM*/

            cmt_det.cmt_seq = cmtseq.
/*J1PM*/    {mfrnseq.i cmt_det cmt_det.cmt_indx cmt_sq01}
            cmtindx = cmt_det.cmt_indx.

            for each cmt_det no-lock where cmt_indx = ro_from.ro_cmtindx:
               find cmtdet where cmtdet.cmt_indx = cmtindx
               and cmtdet.cmt_seq = cmt_det.cmt_seq exclusive-lock no-error.
               if not available cmtdet then create cmtdet.
               assign
               cmtdet.cmt_indx = cmtindx
               cmtdet.cmt_seq = cmt_det.cmt_seq
               cmtdet.cmt_ref = cmt_det.cmt_ref
               cmtdet.cmt_type = cmt_det.cmt_type
               cmtdet.cmt_lang = cmt_det.cmt_lang
               cmtdet.cmt_print = cmt_det.cmt_print.
               do i = 1 to 15:
                  assign cmtdet.cmt_cmmt[i] = cmt_det.cmt_cmmt[i].
               end.
            end.  /* FOR EACH CMT_DET... */

            ro_det.ro_cmtindx = cmtindx.
         end.  /* IF AVAILABLE CMTDET...*/
      end.  /* IF NOT AVAILABLE RO_DET...*/
   end.  /* EACH RO_FROM WHERE RO_ROUTING = PART1...*/

   {mftrl080.i}
end.    /* repeat */
