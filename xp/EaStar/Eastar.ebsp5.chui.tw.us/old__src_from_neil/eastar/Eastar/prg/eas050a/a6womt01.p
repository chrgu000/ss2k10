/* wowomt01.p - MULTIPLE WORK ORDER STATUS CHANGE                       */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: emb *D413*          */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D741*          */
/* REVISION: 6.0      LAST MODIFIED: 08/29/91   BY: emb *D841*          */
/* REVISION: 6.0      LAST MODIFIED: 09/26/91   BY: ram *D876*          */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*(rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: ram *F896*          */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*          */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: emb *G268*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: emb *G870*          */
/* REVISION: 7.3      LAST MODIFIED: 09/16/93   BY: ram *GF36*          */
/* REVISION: 7.5      LAST MODIFIED: 08/09/94   BY: tjs *J014*          */
/* REVISION: 7.3      LAST MODIFIED: 09/01/94   BY: ljm *FQ67*          */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN76*          */
/* REVISION: 8.5      LAST MODIFIED: 03/03/95   BY: tjs *J027*          */
/* REVISION: 8.5      LAST MODIFIED: 11/08/95   BY: tjs *J08Q*          */
/* REVISION: 8.5      LAST MODIFIED: 06/11/96   BY: rvw *G1XY*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 01/31/00   BY: *J3NZ* Kirti Desai  */
/* REVISION: 9.0      LAST MODIFIED: 02/23/00   BY: *M0JN* Kirti Desai  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KC* myb              */
/* REVISION: eB sp5 chui  LAST MODIFIED: 08/31/05  BY: *eas050a* Kaine Zhang */

   {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowomt01_p_1 "Include Phantom Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowomt01_p_2 "Current Status"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowomt01_p_3 "Change from Status"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowomt01_p_4 "Original Status"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*       define shared variable mfguser as character.           *G247* */

         define new shared variable comp like ps_comp.
         define new shared variable qty as decimal.
         define new shared variable eff_date as date.
         define new shared variable wo_recno as recid.
         define new shared variable leadtime like pt_mfg_lead.
         define new shared variable prev_status like wo_status.
         define new shared variable prev_release like wo_rel_date.
         define new shared variable prev_due like wo_due_date.
         define new shared variable prev_qty like wo_qty_ord.
         define new shared variable del-yn like mfc_logical initial no.
         define new shared variable deliv like wod_deliver.
/*J027*/ /* Begin added block */
         define new shared variable wo_recno1   as recid.
         define new shared variable joint_type  like wo_joint_type.
         define new shared variable del-joint   like mfc_logical initial no.
         define new shared variable joint_qtys  like mfc_logical initial no.
         define new shared variable joint_dates like mfc_logical initial no.
         define new shared variable no_msg      like mfc_logical initial yes.
         define new shared variable err_msg     as integer.
         define variable joint_wo   like wo_nbr.
         define variable b_nbr      like wo_nbr.
         define variable b_lot      like wo_lot.
         define variable b_part     like wo_part.
         define variable b_rel_date like wo_rel_date.
         define variable b_due_date like wo_due_date.
         define variable b_qty_ord  like wo_qty_ord.
         define variable b_so_job   like wo_so_job.
/*J027*/ /* End added block */
         define variable i as integer.
         define variable nonwdays as integer.
         define variable overlap as integer.
         define variable workdays as integer.
         define variable interval as integer.
         define variable know_date as date.
         define variable find_date as date.
/*FQ67*  define variable forward as integer. */
/*FQ67*/ define variable frwrd as integer.

         define variable last_due as date.
         define variable hours as decimal.
         define variable queue like wc_queue.
         define variable wait like wc_wait.
         define variable last_op like wr_op.
         define variable des like pt_desc1.

         define variable wonbr like wo_nbr.
         define variable wonbr1 like wo_nbr.
         define variable wolot like wo_lot.
         define variable wolot1 like wo_lot.
         define variable part like wo_part.
         define variable part1 like wo_part.
/*J027*/ define variable bom  like wo_bom_code.
/*J027*/ define variable bom1 like wo_bom_code.
         define variable woreldate like wo_rel_date.
         define variable woreldate1 like wo_rel_date.
         define variable wostat_to like wo_status initial "E".
         define variable wostat_from like wo_status
            label {&wowomt01_p_3} initial "B".
         define variable wostat1 as character format "x(12)"
            label {&wowomt01_p_4}.
         define variable wostat2 as character format "x(12)"
            label {&wowomt01_p_2}.
         define variable save_wonbr like wonbr.
         define variable prev_wonbr like wonbr.
         define variable prev_wolot like wo_lot.
         define variable prev_recno as recid.

         define new shared variable any_issued like mfc_logical.
/*F896*/ define new shared variable any_feedbk like mfc_logical.

         define variable phantom like mfc_logical initial no
            label {&wowomt01_p_1}.
/*D024*/ define new shared variable prev_site like wo_site.
/*D024*/ define new shared variable undo_all      like mfc_logical no-undo.
/*G1XY*/ define new shared variable critical-part like wod_part    no-undo.
/*M0JN*/ define new shared variable critical_flg  like mfc_logical no-undo.

/*J027*/ define buffer wo_mstr1 for wo_mstr.

/*J3NZ*/ define variable site  like wo_site no-undo.
/*J3NZ*/ define variable site1 like wo_site no-undo.

/************************eas050a B Add***********************/
DEFINE VARIABLE datClose AS DATE INITIAL TODAY.
/************************eas050a E Add***********************/

         eff_date = today.

         form
            skip (1)
            wonbr          colon 25
            wonbr1         colon 50 label {t001.i}
            wolot          colon 25
            wolot1         colon 50 label {t001.i}
            woreldate      colon 25
            woreldate1     colon 50 label {t001.i}
            part           colon 25
/*J027*     part1          colon 50 label {t001.i} skip (1) */
/*J027*/    part1          colon 50 label {t001.i}
/*J3NZ*/    site           colon 25
/*J3NZ*/    site1          colon 50 label {t001.i}
/*J027*/    bom            colon 25
/*J027*/    bom1           colon 50 label {t001.i} skip (1)
            wostat_from    colon 25
            wostat_to      colon 50 label {t001.i}
            /*eas050a*/  datClose	COLON 25 LABEL "close date"
            skip(1)
            phantom       colon 25
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*J027*/ /* Begin added block */
         form
            b_nbr
            b_lot
            b_part
            b_rel_date
            b_due_date
            wostat1
            wostat2
            b_qty_ord
            b_so_job
         with down frame b width 132 no-attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
/*J027*/ /* End added block */

         repeat on error undo , retry:

            if wonbr1 = hi_char then wonbr1 = "".
            if wolot1 = hi_char then wolot1 = "".
            if woreldate1 = hi_date then woreldate1 = ?.
            if woreldate = low_date then woreldate = ?.
            if part1 = hi_char then part1 = "".
/*J3NZ*/    if site1 = hi_char then site1 = "".
/*J027*/    if bom1 = hi_char then bom1 = "".

            update wonbr wonbr1 wolot wolot1 woreldate woreldate1
/*J027*        part part1 wostat_from wostat_to */
/*J3NZ** /*J027*/   part part1 bom bom1 wostat_from wostat_to */
/*J3NZ*/       part part1 site site1
/*J3NZ*/       bom bom1 wostat_from wostat_to
  /*eas050a*/  datClose
               phantom
            with frame a.

            bcdparm = "".
            {mfquoter.i wonbr  }
            {mfquoter.i wonbr1 }
            {mfquoter.i wolot  }
            {mfquoter.i wolot1 }
            {mfquoter.i woreldate}
            {mfquoter.i woreldate1}
            {mfquoter.i part   }
            {mfquoter.i part1  }
/*J3NZ*/    {mfquoter.i site   }
/*J3NZ*/    {mfquoter.i site1  }
/*J027*/    {mfquoter.i bom    }
/*J027*/    {mfquoter.i bom1   }
            {mfquoter.i wostat_from}
            {mfquoter.i wostat_to}
            /*eas050a*/  {mfquoter.i datClose}
            {mfquoter.i phantom}

            if wonbr1 = "" then wonbr1 = hi_char.
            if wolot1 = "" then wolot1 = hi_char.
            if woreldate1 = ? then woreldate1 = hi_date.
            if woreldate = ? then woreldate = low_date.
            if part1 = "" then part1 = hi_char.
/*J3NZ*/    if site1 = "" then site1 = hi_char.
/*J027*/    if bom1 = "" then bom1 = hi_char.

/*J3NZ*/    /* BEGIN ADD SECTION */

            /* FIND IF A SITE CANNOT BE ACCESSED BY A USER */
            {gprun.i ""gpsirvr.p""
             "(input site, input site1, output return_int)"}
            if return_int = 0 then do:
               if c-application-mode = 'WEB' then return.
               next-prompt site with frame a.
               undo, retry.
            end. /* IF RETURN_INT = 0 */

/*J3NZ*/    /* END ADD SECTION */

		/************************eas050a B Add***********************/
		IF wostat_to = "c" AND datClose = ? THEN DO:
			MESSAGE "invalid close date".
			NEXT-PROMPT datClose WITH FRAME a.
			UNDO, RETRY.
		END.
		/************************eas050a E Add***********************/

            if index("PBFEARC",wostat_from) = 0
            and wostat_from <> ""
            then do with frame a:
               {mfmsg.i 19 3}
               next-prompt wostat_from.
               undo , retry.
            end.
            if index("BFEAC",wostat_to) = 0 then do with frame a:
               {mfmsg.i 19 3}
               next-prompt wostat_to.
               undo , retry.
            end.
            wostat_from = caps(wostat_from).
            wostat_to = caps(wostat_to).
            save_wonbr = wonbr.
            prev_wonbr = ?.
            prev_recno = ?.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}

            /* CREATE PAGE TITLE BLOCK */
            {mfphead.i}

            repeat with frame b width 132 no-attr-space:
               /* FIND ROUTABLE, B STAT WOs FOR PREV WO. SKIP OTHER B STAT WOs*/
/*J08Q*/       if wostat_to <> "B" then
               find first wo_mstr where wo_nbr = prev_wonbr and wo_status = "B"
/*J08Q*/       and wo_site = prev_site and wo_lot > prev_wolot use-index wo_nbr
               no-lock no-error.
               repeat:
                  if not available wo_mstr then leave.
/*J08Q*/          find ptp_det where ptp_part = wo_part
/*J08Q*/          and ptp_site = wo_site no-lock no-error.
/*J08Q*/          if available ptp_det then do:
/*J08Q*/             if ptp_pm_code = "R"
/*J08Q*/             and (ptp_phantom = no or phantom = yes)
/*J08Q*/             then leave.
/*J08Q*/          end.
/*J08Q*/          else do:
                     find pt_mstr where pt_part = wo_part no-lock no-error.
                     if available pt_mstr and pt_pm_code = "R"
                     and (pt_phantom = no or phantom = yes)
                     then leave.
/*J08Q*/          end.
                  find next wo_mstr where wo_nbr = prev_wonbr
/*J08Q*           and wo_status = "B" no-lock no-error. */
/*J08Q*/          and wo_status = "B"
/*J08Q*/          and wo_site = prev_site and wo_lot > prev_wolot
/*J08Q*/          use-index wo_nbr no-lock no-error.
               end.

               if not available wo_mstr then do:
                  /* NO ROUTABLE WO, FIND PRIOR WO TO GET READY TO FIND NEXT */

/*J3NZ**          find wo_mstr where recid(wo_mstr) = prev_recno             */
/*J3NZ**           no-lock no-error.                                         */

/*J3NZ*/          /* BEGIN ADD SECTION */

                  for first wo_mstr
                     fields(wo_nbr wo_lot wo_rel_date wo_part wo_site wo_type
                            wo_bom_code wo_status wo_due_date wo_fsm_type
                            wo_joint_type wo_qty_comp wo_qty_rjct wo_qty_ord
                            wo_so_job)
                      where recid(wo_mstr) = prev_recno
                  no-lock: end.

/*J3NZ*/          /* END ADD SECTION */

                  if not available wo_mstr then

/*J3NZ**       find first wo_mstr where wo_nbr >= wonbr and wo_nbr <= wonbr1 */
/*J3NZ**       and wo_lot >= wolot and wo_lot <= wolot1                      */
/*J3NZ**       and wo_rel_date >= woreldate and wo_rel_date <= woreldate1    */

/*J3NZ*/          /* BEGIN ADD SECTION */

                  for first wo_mstr
                     fields(wo_nbr wo_lot wo_rel_date wo_part wo_site
                            wo_type wo_bom_code wo_status wo_due_date
                            wo_fsm_type wo_joint_type wo_qty_comp
                            wo_qty_rjct wo_qty_ord wo_so_job)
                     where wo_nbr >= wonbr and wo_nbr <= wonbr1
                     and   wo_lot >= wolot and wo_lot <= wolot1
                     and   wo_rel_date >= woreldate
                     and   wo_rel_date <= woreldate1
                     and   wo_site >= site and wo_site <= site1

/*J3NZ*/          /* END ADD SECTION */

                     and wo_part >= part and wo_part <= part1
/*GN76*/             and not (wo_type = "c" and wo_nbr = "")
/*J027*/             and (wo_bom_code >= bom and wo_bom_code <= bom1)
                     and (wo_status = wostat_from or wostat_from = "")
/*J3NZ**             use-index wo_nbr no-lock no-error.                      */
/*J3NZ*/             use-index wo_nbr no-lock: end.
                  else
                  find next wo_mstr where wo_nbr >= wonbr and wo_nbr <= wonbr1
                     and wo_lot >= wolot and wo_lot <= wolot1
                     and wo_rel_date >= woreldate and wo_rel_date <= woreldate1
                     and wo_part >= part and wo_part <= part1
/*J3NZ*/             and wo_site >= site and wo_site <= site1
/*GN76*/             and not (wo_type = "c" and wo_nbr = "")
/*J027*/             and (wo_bom_code >= bom and wo_bom_code <= bom1)
                     and (wo_status = wostat_from or wostat_from = "")
                     use-index wo_nbr no-lock no-error.

                  prev_recno = ?.
                  if available wo_mstr then do:
/*J08Q*              if wo_status = wostat_to then next. */
                     prev_recno = recid(wo_mstr).
                     prev_wonbr = wo_nbr.
/*J08Q*/             prev_wolot = wo_lot.
/*J08Q*/             prev_site = wo_site.
                     if phantom = no then do:
/*J08Q*/                find ptp_det where ptp_part = wo_part
/*J08Q*/                and ptp_site = wo_site no-lock no-error.
/*J08Q*/                if available ptp_det and ptp_phantom then next.
/*J08Q*/                if not available ptp_det then
                        find pt_mstr where pt_part = wo_part no-lock no-error.
                        if available pt_mstr and pt_phantom then next.
                     end.
                  end.
               end.

               if not available wo_mstr then leave.

/*J08Q*/       /* JOINT WOs ALREADY UPDATED AS A SET & MAY NOT CHG TO STAT B */
/*J08Q*        if wo_joint_type <> "" and wo_nbr = joint_wo then leave. */
/*J08Q*/       if wo_joint_type <> ""
/*J08Q*/       and (wo_nbr = joint_wo or wostat_to = "B") then next.

               prev_wonbr = wo_nbr.
               prev_wolot = wo_lot.
/*J08Q*/       prev_site = wo_site.

               wonbr = wo_nbr.
/*J08Q*/       if wo_status = wostat_to then next.
               wo_recno = recid(wo_mstr).
               comp = wo_part.

               prev_status = wo_status.
               prev_release = wo_rel_date.
               prev_due = wo_due_date.
               prev_qty = wo_qty_ord.
/*J08Q*        prev_site = wo_site. */

               if wo_qty_ord >= 0
               then qty = max (wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).
               else qty = min (wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).

/*J04C*/       /* IN ADDITION TO CHECKS ON TYPE/STATUS, CALL ACTIVITY   */
               /* RECORDING WORK ORDERS SHOULD NOT BE UPDATED HERE.     */
               /* RMA WORK ORDERS, HOWEVER, SHOULD BE ALLOWED.          */
/*J04C*               if index("FRESC",wo_type) = 0    */
/*J04C*/       if (index("FRESC",wo_type) = 0
               or (index ("RE",wo_type) <> 0 and index ("ARC",wostat_to) <> 0)
               or (index ("F",wo_type) <> 0 and index ("EARC",wostat_to) <> 0)
/*J04C*/          ) and (wo_fsm_type = " " or wo_fsm_type = "RMA")
               then do:

/*G870*           find wo_mstr where recid(wo_mstr) = wo_recno. */

/*G870*/          do transaction:
/*G870*/             find wo_mstr exclusive-lock
/*G870*/             where recid(wo_mstr) = wo_recno.

                     wo_status = wostat_to.
                     
                     /************************eas050a B Add***********************/
                     IF wostat_to = "c" THEN DO:
                     	wo__dte01 = datClose.
                     END.
                     /************************eas050a E Add***********************/
                     
/*G870*/          end.

/*GF36*/          undo_all = no.

                  {gprun.i ""wowomta.p""}

/*G870****        if any_issued
/*F896*/ *        or any_feedbk
         *        then wo_status = prev_status. */

/*J027*/ /* Begin added block */
/*J08Q*           if not any_issued and not any_feedbk then do:*/
/*J08Q*/          if wo_joint_type <> "" and
/*J08Q*/          not any_issued and not any_feedbk then do:
                     /* RE-IMPLODE JOINT PRODUCT WOs OR CHANGE THEIR STATUS */
/*J08Q*              if wo_joint_type <> "" and         */
/*J08Q*              (index("PBFC",prev_status) > 0 and */
/*J08Q*/             if (index("PBFC",prev_status) > 0 and
                      index("FEAR",wo_status) > 0)
                     then do:
                        /* RE-ESTABLISH ITS EFFECTIVE JOINT WOs.*/
                        {gprun.i ""wowomtf.p""}
                        find wo_mstr no-lock where recid(wo_mstr) = wo_recno.
                     end.
                     else do:
                        /* UPDATE ALL JP WOs IN THE SET (STATUS CHANGE ONLY) */
                        {gprun.i ""wowomti.p""}
                     end.
                  end.
/*J027*/ /* End added block */

/*J027*           if any_issued or any_feedbk then do transaction: */
/*J027*/          if any_issued or any_feedbk or undo_all then do transaction:
/*G870*/             wo_status = prev_status.
/*G870*/          end.

               end.
               /* STRING TEXT FOR LETTER (e.g. EXPLODED for E) */
               {mfwostat.i wostat1 prev_status}
               {mfwostat.i wostat2 wo_status}
/*J027*        display wo_nbr wo_lot wo_part wo_rel_date wo_due_date */
/*J027*        wostat1 wostat2 wo_qty_ord wo_so_job                  */
/*J027*        with frame b.                                         */
/*J027*/ /* Begin added block */
               display wo_nbr @ b_nbr
                       wo_lot         @ b_lot
                       wo_part        @ b_part
                       wo_rel_date    @ b_rel_date
                       wo_due_date    @ b_due_date
                       wostat1
                       wostat2
                       wo_qty_ord     @ b_qty_ord
                       wo_so_job      @ b_so_job
               with frame b.
               down 1 with frame b.
               /* DISPLAY JOINT PRODUCT ORDERS IN THE SET */
               if wo_joint_type <> "" then do:
                  joint_wo = wo_nbr.
                  for each wo_mstr1 no-lock where
                  wo_mstr1.wo_nbr =  wo_mstr.wo_nbr and
/*J08Q*/          wo_mstr1.wo_type = "" and
                  wo_mstr1.wo_lot <> wo_mstr.wo_lot:
                     display wo_mstr1.wo_nbr      @ b_nbr
                             wo_mstr1.wo_lot      @ b_lot
                             wo_mstr1.wo_part     @ b_part
                             wo_mstr1.wo_rel_date @ b_rel_date
                             wo_mstr1.wo_due_date @ b_due_date
                             wostat1
                             wostat2
                             wo_mstr1.wo_qty_ord  @ b_qty_ord
                             wo_mstr1.wo_so_job   @ b_so_job
                     with frame b.
                     down 1 with frame b.
                  end.
               end.
/*J027*/ /* End added block */
            end.

            /* REPORT TRAILER */
            {mfrtrail.i}
            wonbr = save_wonbr.
         end.
