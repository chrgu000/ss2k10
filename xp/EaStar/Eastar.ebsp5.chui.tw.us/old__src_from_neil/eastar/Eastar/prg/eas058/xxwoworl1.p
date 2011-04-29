/* woworl1.p - SINGLE WO RELEASE / PRINT WORK ORDER DRIVER              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 8.5     LAST MODIFIED: 02/03/95    BY: tjs *J027*          */
/* REVISION: 8.5     LAST MODIFIED: 06/11/96    BY: *G1XY*  Russ Witt   */
/* REVISION: 8.5     LAST MODIFIED: 07/09/96    BY: *J0YB*  Kieu Nguyen */
/* REVISION: 8.5     LAST MODIFIED: 02/04/97    BY: *J1GW* Julie Milligan */
/* REVISION: 8.5     LAST MODIFIED: 06/04/97    BY: *J1SM* Manmohan K.Pardesi */


/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/10/00   BY: *N091* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1      LAST MODIFIED: 02/07/02   BY: *N191* Rajaneesh S.       */
/* Revision: eB.SP5.Chui    Modified: 08/14/06  By: Kaine Zhang     *ss-20060818.1* */

         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworl1_p_1 "Print Picklist"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworl1_p_2 "Print Routing"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworl1_p_3 "Print Co/By-Products"
/* MaxLen: Comment: */

/*N091** BEGIN DELETE
 * &SCOPED-DEFINE woworl1_p_4 "***No routing was printed for work order "
/* MaxLen: Comment: */
 *N091** END DELETE */

/*N091** BEGIN DELETE
 * &SCOPED-DEFINE woworl1_p_5 "***No picklist was printed for work order "
/* MaxLen: Comment: */
 *N091** END DELETE */

/* ********** End Translatable Strings Definitions ********* */

         define new shared variable any_issued like mfc_logical.
         define new shared variable any_feedbk like mfc_logical.
         define new shared variable picklistprinted like mfc_logical.
         define new shared variable routingprinted like mfc_logical.
         define new shared variable jpprinted like mfc_logical.
         define new shared variable prev_site like wo_site.
         define new shared variable joint_type like wo_joint_type.
         define new shared variable del-joint like mfc_logical initial no.
         define new shared variable no_msg like mfc_logical initial no.
         define new shared variable err_msg as integer.
         define new shared variable undo_all like mfc_logical no-undo.
/*J1SM*/ define new shared variable joint_dates like mfc_logical.
/*J1SM*/ define new shared variable joint_qtys  like mfc_logical.

         define shared variable prd_recno as recid.
/*G1XY*/ define shared variable critical-part like wod_part no-undo.
         define shared variable wo_qty like wo_qty_ord.
         define shared variable move like woc_move.
         define shared variable comp like ps_comp.
         define shared variable qty like wo_qty_ord.
         define shared variable eff_date as date.
         define shared variable wo_recno as recid.
         define shared variable leadtime like pt_mfg_lead.
         define shared variable prev_status like wo_status.
         define shared variable print_pick like mfc_logical
            label {&woworl1_p_1} initial yes.
         define shared variable print_rte like mfc_logical
            label {&woworl1_p_2} initial yes.
         define shared variable print_jp  like mfc_logical
/*J1GW*     label "Print Joint Products" initial yes. */
/*J1GW*/    label {&woworl1_p_3} initial yes.

         define variable wrlot like wr_lot.
         define variable wrnbr like wo_nbr.
/*N091*/ define variable l_msgdesc like msg_desc no-undo.

         {mfworlb1.i &row="7"}

         /* CREATE PAGE TITLE BLOCK */
         {mfphead2.i}
         eff_date = today.

         printset:
         do on error undo, leave:

            do:
               find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno.

               if wo_rel_date <> today and wo_status <> "R" then
                  wo_rel_date = today.

               if index("PFBEA",wo_status) <> 0 then wo_status = "R".
            end.

            if wo_qty_ord >= 0 then
               qty = max (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).
            else
               qty = min (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).
            wo_qty = qty.

            prev_site = wo_site.
            undo_all = no.

/*J0YB*     if wo_joint_type <> "" then do:                   */
/*J0YB*/    if wo_joint_type <> "" and
/*J0YB*/       (index("PBFC",prev_status) > 0)  then do:
               /* Create/re-establish its effective joint WOs.*/
               {gprun.i ""wowomtf.p""}
               find wo_mstr no-lock where recid(wo_mstr) = wo_recno.
               if undo_all then undo, retry.
            end.

/*J1SM*     UPDATE OTHER CO/BY WO STATUS */
/*J1SM*/    else
/*J1SM*/    if wo_joint_type <> "" and (index("EA",prev_status) > 0)
/*J1SM*/    then do:
/*J1SM*/       assign
/*J1SM*/          joint_dates = no
/*J1SM*/          joint_qtys = no
/*J1SM*/          any_issued = no
/*J1SM*/          any_feedbk = no.
/*J1SM*/       {gprun.i ""wowomti.p""}
/*J1SM*/       find wo_mstr no-lock where recid(wo_mstr) = wo_recno.
/*J1SM*/       if undo_all then undo, retry.
/*J1SM*/    end.

            joint_type = wo_joint_type.
            /*ss-20060818.1*  {gprun.i ""wowomta.p""}  */
            /*ss-20060818.1*/ {gprun.i ""xxwowomta.p""}

            picklistprinted = no.
            routingprinted = no.
            jpprinted = no.

            if undo_all = no then do:
               if print_jp and
               jp_1st_last_doc and wo_joint_type <> "" then do:
                  /* Print joint products expected receipts */
                  page_counter = page-number - 1.
                  wo_recno = recid(wo_mstr).
                  {gprun.i ""woworlf.p"" }
               end.
               if print_pick then do:
                  page_counter = page-number - 1.
                  wo_recno = recid(wo_mstr).
                  {gprun.i ""woworlb.p"" }
               end.
               if print_rte then do:
                  page_counter = page-number - 1.
                  wo_recno = recid(wo_mstr).
                  {gprun.i ""woworld.p"" }
               end.
               if print_jp and
               not jp_1st_last_doc and wo_joint_type <> "" then do:
                  /* Print joint products expected receipts */
                  page_counter = page-number - 1.
                  wo_recno = recid(wo_mstr).
                  {gprun.i ""woworlf.p"" }
               end.
            end.

            if (print_pick and not picklistprinted)
            or (print_rte and not routingprinted)
            or undo_all = yes
            then do:
               page.
               if undo_all then do:
/*G1XY*           find msg_mstr where msg_lang = global_user_lang     */
/*G1XY*           and msg_nbr = 4984 no-lock no-error.                */
                  /* KEY ITEM NOT AVAILABLE, WORK ORDER NOT RELEASED  */
/*G1XY*           if available msg_mstr then                         */
/*G1XY*              put                                            */
/*G1XY*                 substr(msg_desc,1,40)                       */
/*G1XY*                 + wo_nbr                                    */
/*G1XY*                 + substr(msg_desc,40) format "x(80)" skip.  */
/*G1XY*/          {mfmsg02.i 4984 2 wo_nbr}
/*G1XY*/          {mfmsg02.i 989 1 critical-part}
/*G1XY*/          if not batchrun then pause.

                  wo_status = prev_status.
               end.
               if (print_pick and not picklistprinted) then
/*N091*/       do:
/*N091*/          /* ***NO PICKLIST WAS PRINTED FOR WORK ORDER */
/*N091*/          {mfmsg09.i 3773 l_msgdesc wo_nbr """" """"}
                  put
/*N191*/             unformatted
/*N091** BEGIN DELETE
 *                   {&woworl1_p_5}
 *                   wo_nbr skip.
 *N091** END DELETE */
/*N091*/             l_msgdesc skip.
/*N091*/       end. /* IF (PRINT_PICK AND NOT PICKLISTPRINTED) THEN */

               if (print_rte and not routingprinted) then
/*N091*/       do:
/*N091*/          /* ***NO ROUTING WAS PRINTED FOR WORK ORDER */
/*N091*/          {mfmsg09.i 3803 l_msgdesc wo_nbr """" """"}
                  put
/*N191*/             unformatted
/*N091** BEGIN DELETE
 *                   {&woworl1_p_4}
 *                   wo_nbr skip.
 *N091** END DELETE */
/*N091*/             l_msgdesc skip.
/*N091*/       end. /* IF (PRINT_RTE AND NOT ROUTINGPRINTED) THEN */

               page.
            end.

            if undo_all = no then do:

               if wo_status <> "R" then wo_status = "R".

               if move then do:
                  move = no.
                  find first wr_route where wr_lot = wo_lot
                  and wr_nbr = wo_nbr no-error.
                  if available wr_route and wr_status = ""
                  then do:
                     wrlot = wr_lot.
                     {mfopmv.i wr_qty_ord "no"}
                  end.
                  move = yes.
               end.
            end.

            if undo_all then do:
               /* CRITICAL ITEM NOT AVAILABLE, WORK ORDER NOT RELEASED */
/*G1XY*        {mfmsg.i 4984 4}        */
               undo printset, leave.
            end.

         end. /*printset*/
