/* woworl2.p - MULTI WO RELEASE / PRINT WORK ORDERS DRIVER                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 8.5      LAST MODIFIED: 03/27/95   BY: tjs *J027*                */
/* REVISION: 8.5      LAST MODIFIED: 03/13/95   BY: ktn *J035*                */
/* REVISION: 8.5      LAST MODIFIED: 02/07/96   BY: tjs *J0CL*                */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 06/11/96   BY: *G1XY* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 07/09/96   BY: *J0YB* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 02/04/97   BY: *J1GW* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 06/04/97   BY: *J1SM* Manmohan K.Pardesi */
/* REVISION: 8.5      LAST MODIFIED: 12/08/97   BY: *H1H3* Thomas Fernandes   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 01/31/00   BY: *J3NZ* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 03/06/2000 BY: *N05Q* Vincent Koh        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/10/00   BY: *N091* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13       BY: Katie Hilbert       DATE: 04/05/01  ECO: *P008*   */
/* Revision: 1.14       BY: Jean Miller         DATE: 12/13/01  ECO: *P03Q*   */
/* Revision: 1.15       BY: Rajaneesh S.        DATE: 02/07/02  ECO: *N191*   */
/* Revision: 1.16       BY: Inna Fox            DATE: 06/13/02  ECO: *P04Z*   */
/* Revision: 1.17       BY: Vivek Gogte         DATE: 01/28/03  ECO: *N25C*   */
/* Revision: 1.19       BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00N*   */
/* $Revision: 1.20 $      BY: Manisha Sawant      DATE: 08/25/03  ECO: *N2H7*   */
/* 100716.1  $  BY: mage chen  DATE: 07/16/10    ECO: *P45S*  */
/* 100727.1  $  BY: mage chen  DATE: 07/16/10    ECO: *P45S*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i "  "}
{gplabel.i}

/* STANDARD INCLUDE FOR MAINTENANCE COMPONENTS */
{pxmaint.i}

define new shared variable joint_type like wo_joint_type.
define new shared variable any_issued like mfc_logical.
define new shared variable any_feedbk like mfc_logical.
define new shared variable picklistprinted like mfc_logical.
define new shared variable routingprinted like mfc_logical.
define new shared variable jpprinted like mfc_logical.
define new shared variable wr_recid as recid.
define new shared variable wo_recno1 as recid.
define new shared variable prev_site like wod_site.
define new shared variable del-joint like mfc_logical initial no.
define new shared variable no_msg like mfc_logical initial no.
define new shared variable err_msg as integer.
define new shared variable undo_all like mfc_logical no-undo.
define new shared variable joint_dates like mfc_logical.
define new shared variable joint_qtys  like mfc_logical.

define shared variable prd_recno as recid.
define shared variable critical-part like wod_part no-undo.
define shared variable wonbr like wo_nbr.
define shared variable wonbr1 like wo_nbr.
define shared variable wolot like wo_lot.
define shared variable wolot1 like wo_lot.
define shared variable part like wo_part.
define shared variable part1 like wo_part.
define shared variable woreldate like wo_rel_date.
define shared variable woreldate1 like wo_rel_date.
define shared variable wostatus like wo_status.
define shared variable wotype like wo_type.
define shared variable planner  like pt_buyer.
define shared variable planner1 like pt_buyer.
define shared variable comp like ps_comp.
define shared variable qty as decimal.
define shared variable eff_date as date.
define shared variable wo_recno as recid.
define shared variable prev_status like wo_status.
define shared variable prev_release like wo_rel_date.
define shared variable prev_due like wo_due_date.
define shared variable prev_qty like wo_qty_ord.
define shared variable wo_qty like wo_qty_ord.
define shared variable move like woc_move.
define shared variable barcode    like mfc_logical label "Print Bar Code".
define shared variable print_pick like mfc_logical label "Print Picklist"
   initial yes.
define shared variable print_rte  like mfc_logical label "Print Routing"
   initial yes.
define shared variable print_jp   like mfc_logical label "Print Co/By-Products"
   initial yes.
define shared variable phantom    like mfc_logical label "Include Phantom Items"
   initial no.
define shared variable wobatch like wo_batch.
define shared variable wobatch1 like wo_batch.
define shared variable site  like wo_site no-undo.
define shared variable site1 like wo_site no-undo.

define variable wrnbr like wo_nbr.
define variable lastnbr like wo_nbr.
define variable base_id like wo_base_id.
define variable trnbr like op_trnbr.
define variable wrlot like wr_lot.
define variable ptplanner like pt_buyer.
define variable ptphantom like pt_phantom.
define variable l_tmp_message like msg_desc no-undo.
define variable l_msgdesc     like msg_desc no-undo.
define variable l_ptstatus    like pt_status no-undo.

{mfworlb1.i &row="13"}

/* DEFINE THE PERSISTENT HANDLE FOR THE PROGRAM wocmnrtn.p */
{pxphdef.i wocmnrtn}

/* CREATE PAGE TITLE BLOCK */
{mfphead2.i}
eff_date = today.

rpt-block:
repeat:

   find next wo_mstr no-lock use-index wo_nbr
       where wo_mstr.wo_domain = global_domain and (  wo_nbr >= wonbr and
       wo_nbr <= wonbr1
      and   wo_lot >= wolot and wo_lot <= wolot1
      and   wo_rel_date >= woreldate and wo_rel_date <= woreldate1
      and   wo_part >= part and wo_part <= part1
      and   wo_site >= site and wo_site <= site1
      and   wo_batch >= wobatch and wo_batch <= wobatch1
      and   wo_type = wotype
      and   wo_type <> "W"
      and   (wo_status = wostatus
      or    (wostatus = "" and wo_status <> "R"))
      and   wo_status <> "C" ) no-error.

   if not available wo_mstr then leave.

   /* CHECK IF ADD-WO TRANSACTION IS PERMITTED FOR ITEM BEFORE */
   /* CHANGING THE STATUS OF WORK ORDER FROM PLANNED TO ANY    */
   /* OTHER STATUS                                             */

   if  wo_status = "p"
   then do:

      {pxrun.i &PROC = 'validateRestrictedStatus'
               &PROGRAM = 'wocmnrtn.p'
               &HANDLE = ph_wocmnrtn
               &PARAM = "(input wo_part,
                          ""ADD-WO"",
                          output l_ptstatus)"
               &NOAPPERROR = true
               &CATCHERROR = true}

      if return-value = {&APP-ERROR-RESULT}
      then do:

         /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
         {pxmsg.i &MSGNUM = 358
                  &ERRORLEVEL = {&APP-ERROR-NO-REENTER-RESULT}
                  &MSGBUFFER = l_tmp_message
                  &MSGARG1 = l_ptstatus}

         put l_tmp_message skip.

         /* WORK ORDER NOT PROCESSED */
         {pxmsg.i &MSGNUM = 6245
                  &ERRORLEVEL = {&APP-ERROR-NO-REENTER-RESULT}
                  &MSGBUFFER = l_tmp_message
                  &MSGARG1 = wo_nbr
                  &MSGARG2 = wo_lot}

         put l_tmp_message skip.

         next.
      end. /* IF return-value = {&APP-ERROR-RESULT} */
   end. /* IF  wo_status = "P" */

   /*  DO NOT ATTEMPT TO RELEASE/PRINTCALL ACTIVITY         */
   /*  RECORDING WORK ORDERS.                               */
   /*  WORK ORDERS FROM PRM SHOULD BE EXCLUDED              */
   if wo_fsm_type = "FSM-RO"
      or wo_fsm_type = "PRM"
      then next.

   if wo_joint_type <> "" then do:
      if wo_nbr = lastnbr then next.
      lastnbr = wo_nbr.
   end.

   if planner <> "" or planner1 <> hi_char
      or phantom = no then do:
      find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
      wo_part and ptp_site = wo_site
         no-lock no-error.
      if available ptp_det then
         assign
            ptplanner = ptp_buyer
            ptphantom = ptp_phantom.
      else do:
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         wo_part no-lock no-error.
         if available pt_mstr then
            assign
               ptplanner = pt_buyer
               ptphantom = pt_phantom.
         else
            assign
               ptplanner = ""
               ptphantom = no.
      end.
      if ptplanner < planner or ptplanner > planner1
         or (phantom = no and ptphantom = yes) then next.
   end.

   assign
      wo_recno = recid(wo_mstr)
      comp = wo_part
      prev_status = wo_status
      prev_release = wo_rel_date
      prev_due = wo_due_date
      prev_qty = wo_qty_ord.

   if wo_qty_ord >= 0 then
      qty = max (wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).
   else
      qty = min (wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).
   wo_qty = qty.

   trac-block:
   do transaction:

      find first wo_mstr
         where recid(wo_mstr) = wo_recno
         exclusive-lock
         no-wait no-error.

      if locked wo_mstr
      then
         next rpt-block.

      /* GET BASE PROCESS WO IF THIS IS A JOINT PRODUCT */
      if index("1234",wo_joint_type) > 0 then do:
         base_id = wo_base_id.
         find wo_mstr exclusive-lock  where wo_mstr.wo_domain = global_domain
         and  wo_lot = base_id.
         wo_recno = recid(wo_mstr).
      end.
/*ss 100727.1 *
      if wo_rel_date <> today and wo_status <> "R" then
         wo_rel_date = today.
*ss 100727.1 */
      if index("PFBEA",wo_status) <> 0 then wo_status = "R".
      assign
         prev_site = wo_site
         undo_all = no.

      if wo_joint_type <> "" and
         (index("PBFC",prev_status) > 0 ) then do:
         /* CREATE/RE-ESTABLISH ITS EFFECTIVE JOINT WOS.*/
         {gprun.i ""wowomtf.p""}
         find wo_mstr no-lock where recid(wo_mstr) = wo_recno.
      end.

      /*UPDATE OTHER CO/BY WO STATUS */
      else
         if wo_joint_type <> "" and (index("EA",prev_status) > 0)
         then do:
            assign
               joint_dates = no
               joint_qtys = no
               any_issued = no
               any_feedbk = no.
            {gprun.i ""wowomti.p""}
            find wo_mstr no-lock where recid(wo_mstr) = wo_recno.
         end.

      if not undo_all then do:
         joint_type = wo_joint_type.

/* Print Picklist */
      /*ss - 10070727.1 - b*
         {gprun.i ""wowomta.p""}
*ss - 10070727.1 - e*/

/*ss - 10070727.1 - b*/
   {gprun.i ""xxwowomta.p""}
/*ss - 10070727.1 - e*/

         if not undo_all then do:
            assign
               picklistprinted = no
               routingprinted = no
               jpprinted = no
               wo_recno = recid(wo_mstr).
            if print_jp and
               jp_1st_last_doc and wo_joint_type <> "" then do:
               page_counter = page-number - 1.
               {gprun.i ""woworlf.p"" }
            end.
            if print_pick then do:
               page_counter = page-number - 1.
               {gprun.i ""woworlb.p""}
            end.
            if print_rte then do:
               page_counter = page-number - 1.
               {gprun.i ""woworld.p""}
            end.
            if print_jp and
               not jp_1st_last_doc and wo_joint_type <> "" then do:
               page_counter = page-number - 1.
               {gprun.i ""woworlf.p"" }
            end.
         end.
      end.

      if (print_pick and not picklistprinted)
      or (print_rte and not routingprinted)
      or undo_all = yes
      then do:

         page.

         if undo_all then do:
            /* KEY ITEM NOT AVAILABLE, WORK ORDER NOT RELEASED */
            {pxmsg.i &MSGNUM=4984 &ERRORLEVEL=2 &MSGBUFFER=l_tmp_message}
            put
               l_tmp_message + " " + wo_nbr    format "x(78)" skip.
            /* ITEM IN WORK ORDER THAT IS NOT AVAILABLE: <item-number> */
            {pxmsg.i &MSGNUM=989 &ERRORLEVEL=1 &MSGBUFFER=l_tmp_message }
            put
               l_tmp_message + " " + critical-part format "x(78)" skip.

            undo trac-block, leave.
         end.

         if (print_pick and not picklistprinted)
         then do:
            /* NO PICKLIST WAS PRINTED FOR WORK ORDER */
            {pxmsg.i &MSGNUM=3773 &ERRORLEVEL=1 &MSGBUFFER=l_msgdesc
                     &MSGARG1=wo_nbr}
            put unformatted
               l_msgdesc skip.
         end.

         if (print_rte and not routingprinted)
         then do:
            /* ***NO ROUTING WAS PRINTED FOR WORK ORDER */
            {pxmsg.i &MSGNUM=3803 &ERRORLEVEL=1 &MSGBUFFER=l_msgdesc
                     &MSGARG1=wo_nbr}
            put unformatted
               l_msgdesc skip.
         end.

         page.

      end.

   end.

   if undo_all then next rpt-block.

   do transaction:
      if wo_status <> "R" then wo_status = "R".

      if move then do:
         move = no.
         find first wr_route  where wr_route.wr_domain = global_domain and
         wr_lot = wo_lot
            and wr_nbr = wo_nbr no-lock no-error.
         if available wr_route and wr_status = ""
         then do:
            wr_recid = recid(wr_route).
            {gprun.i ""woopmv.p""}
         end.
         move = yes.
      end.
   end.
end.
