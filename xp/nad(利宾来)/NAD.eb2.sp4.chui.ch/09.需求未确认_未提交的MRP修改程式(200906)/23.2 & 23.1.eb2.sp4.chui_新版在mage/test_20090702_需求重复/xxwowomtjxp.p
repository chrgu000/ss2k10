/* wowomtj.p - WORK ORDER MAINTENANCE frame b                                 */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.25.3.1 $                                                          */
/* REVISION: 8.5      LAST MODIFIED: 03/01/95   BY: tjs *J027*                */
/* REVISION: 8.5      LAST MODIFIED: 03/14/95   BY: ktn *J040*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 04/26/95   BY: sxb *J04D*                */
/* REVISION: 8.5      LAST MODIFIED: 06/28/95   BY: srk *J034*                */
/* REVISION: 8.5      LAST MODIFIED: 09/12/95   BY: tjs *J07F*                */
/* REVISION: 8.5      LAST MODIFIED: 09/28/95   BY: kxn *J072*                */
/* REVISION: 8.5      LAST MODIFIED: 10/13/95   BY: kxn *J08R*                */
/* REVISION: 8.5      LAST MODIFIED: 11/08/95   BY: tjs *J08Q*                */
/* REVISION: 8.5      LAST MODIFIED: 11/20/95   BY: kxn *J09C*                */
/* REVISION: 8.5      LAST MODIFIED: 01/11/96   BY: tjs *J0BG*                */
/* REVISION: 7.3      LAST MODIFIED: 03/19/96   BY: rvw *G1QZ*                */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96   BY: *J0X9* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 07/26/96   BY: *J10X* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: *J135* T Farnsworth       */
/* REVISION: 8.5      LAST MODIFIED: 09/30/96   BY: *J159* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 11/22/96   BY: *G2HQ* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 01/09/97   BY: *H0QX* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 02/04/97   BY: *J1GW* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 02/10/97   BY: *G2JV* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 03/28/97   BY: *G2LG* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 05/29/97   BY: *J1SD* Manmohan K.Pardesi */
/* REVISION: 8.5      LAST MODIFIED: 06/24/97   BY: *G2NM* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 07/03/97   BY: *G2NV* Maryjeane DAte     */
/* REVISION: 8.5      LAST MODIFIED: 12/19/97   BY: *H1HK* Felcy D'Souza      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/16/99   BY: *J3H2* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 08/20/99   BY: *N00J* Russ Witt          */
/* REVISION: 9.1      LAST MODIFIED: 12/15/99   BY: *L0MR* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Revision: 1.22     BY: Manish Kulkarni        DATE: 04/01/01  ECO: *P008*  */
/* Revision: 1.23     BY: Robin McCarthy         DATE: 11/26/01  ECO: *P023*  */
/* Revision: 1.24     BY: Jean Miller            DATE: 05/17/02  ECO: *P05V*  */
/* Revision: 1.25     BY: Inna Fox               DATE: 06/13/02  ECO: *P04Z*  */
/* $Revision: 1.25.3.1 $    BY: Manisha Sawant         DATE: 06/17/03  ECO: *N2H7*  */


/* $Revision: ss - 090616.1  $    BY: mage chen : 05/14/09 ECO: *090616.1*    */



/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* STANDARD INCLUDE FOR MAINTENANCE COMPONENTS */
{pxmaint.i}

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
   label "Adjust Co/By Order Quantities" initial yes.
define shared variable joint_dates        like mfc_logical
   label "Adjust Co/By Order Dates" initial yes.
define shared variable prev_mthd    like cs_method no-undo.

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
define variable joint_label         like lngd_translation.
define variable wocmmts             like woc_wcmmts label "Comments".
define variable qty_ord_entered     like mfc_logical no-undo.
define variable ord_date_entered    like mfc_logical no-undo.
define variable rel_date_entered    like mfc_logical no-undo.
define variable due_date_entered    like mfc_logical no-undo.
define variable bom_code_entered    like mfc_logical no-undo.
define variable do-delete           as logical.
define variable yield_pct           like wo_yield_pct no-undo.
define variable use_op_yield        as logical no-undo.
define variable ok like mfc_logical no-undo.
define variable prompt-routing like mfc_logical no-undo.
define variable flow-exists         as logical no-undo.
define variable l_ptstatus          like pt_status no-undo.

define buffer wo_mstr1 for wo_mstr.

define shared frame attrmt.
define shared frame a.
define shared frame b.

{mfwoat.i}

/* DEFINE THE PERSISTENT HANDLE FOR THE PROGRAM wocmnrtn.p */
{pxphdef.i wocmnrtn}

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
/* SS - 090616.1 - B 
view frame a.
view frame b.
SS - 090616.1 - E */

find wo_mstr where recid(wo_mstr) = wo_recno exclusive-lock.

find first clc_ctrl no-lock no-error.
if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl no-lock.
end.

run checkWorkOrderOnFlowSchedule.

if wo_type <> "w" then
detail-loop:
do on error undo, retry with frame b:

/* SS - 090616.1 - B 
   ststatus = stline[2].
   status input ststatus.

   set
      wo_qty_ord
      wo_ord_date
      wo_rel_date
      wo_due_date when (not flow-exists)
      wo_status
      wo_so_job
      wo_vend
      wo_yield_pct
      wo_site     when (not flow-exists)
      wo_routing
      wo_bom_code
      wo_rmks
      wocmmts
      wo_var when (glx_mthd <> "AVG")
   go-on(F5 CTRL-D).
SS - 090616.1 - E */

   /* DISPLAYS WILL DISTURB 'ENTERED', SO SET VARIABLES HERE */
   if prev_qty <> wo_qty_ord  then
      qty_ord_entered = yes.
   else
      qty_ord_entered = no.
   if prev_ord <> wo_ord_date then
      ord_date_entered = yes.
   else
      ord_date_entered = no.
   if prev_release <> wo_rel_date then
      rel_date_entered = yes.
   else
      rel_date_entered = no.
   if prev_due <> wo_due_date then
      due_date_entered = yes.
   else
      due_date_entered = no.
   if prev_bomcode <> wo_bom_code then
      bom_code_entered = yes.
   else
      bom_code_entered = no.

   if wo_qty_ord * wo_qty_comp <  0 then do:
      /* REVERSE RECEIPTS MAY NOT EXCEED TOTAL PREVIOUS RECEIPTS */
      {pxmsg.i &MSGNUM=556 &ERRORLEVEL=3}.
      undo, retry.
   end.

   if wo_qty_ord * prev_qty <  0 then do:
      /* Sign change not allowed on quantity ordered */
      {pxmsg.i &MSGNUM=95 &ERRORLEVEL=3}.
      undo, retry.
   end.

   if wo_qty_ord = 0 and  prev_qty <>  0 then do:
      /* Zero Not allowed */
      {pxmsg.i &MSGNUM=317 &ERRORLEVEL=3}.
      undo, retry.
   end.

   if wo_joint_type <> "" and wo_qty_ord < 0 then do:
      /* NEGATIVE NUMBERS NOT ALLOWED */
      {pxmsg.i &MSGNUM=5619 &ERRORLEVEL=3}.
      undo, retry.
   end.

   /* CHECK IF ADD-WO TRANSACTION IS PERMITTED FOR ITEM BEFORE */
   /* CHANGING THE STATUS OF WORK ORDER FROM PLANNED TO ANY    */
   /* OTHER STATUS                                             */
   if  prev_status = "p"
   and wo_status   <> prev_status
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
                  &ERRORLEVEL = {&APP-ERROR-RESULT}
                  &MSGARG1 = l_ptstatus}

         next-prompt wo_status.
         undo, retry.

      end. /* IF return-value = {&APP-ERROR-RESULT} */

   end. /* IF  prev_status = "P" */

   /* DELETE */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:

      do for wo_mstr1:

         find first mph_hist where mph_lot = wo_mstr.wo_lot
         no-lock no-error.
         if available mph_hist then do:
            /*QUALITY TEST RESULTS EXIST FOR THIS W.ORDER FOR ITEM#*/
            {pxmsg.i &MSGNUM=7109 &ERRORLEVEL=2 &MSGARG1=mph_part}
            pause.
         end.

         if wo_mstr.wo_joint_type <> "" then do:
            for each wo_mstr1
               where wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                     wo_mstr1.wo_type = "" and
                     wo_mstr1.wo_lot <> wo_mstr.wo_lot
            no-lock:
               find first mph_hist where mph_lot = wo_mstr1.wo_lot
               no-lock no-error.
               if available mph_hist then do:
                  /*QUALITY TEST RESULTS EXIST FOR THIS W.ORDR FOR ITEM#*/
                  {pxmsg.i &MSGNUM=7109 &ERRORLEVEL=2 &MSGARG1=mph_part}
                  pause.
               end.
            end.
         end.

         /* CHECK FOR JOINT ORDER WITH WO_WIP_TOT */
         if wo_mstr.wo_joint_type <> "" then do:
            find first wo_mstr1
                 where wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                       wo_mstr1.wo_type = "" and
                       wo_mstr1.wo_wip_tot <> 0
            exclusive-lock no-error.
         end.

         if wo_mstr.wo_wip_tot <> 0 or available wo_mstr1
         then do:
            /* DELETE NOT ALLOWED, W.ORDER ACCOUNTING MUST BE CLOSED */
            {pxmsg.i &MSGNUM=536 &ERRORLEVEL=3}
            undo.
         end.

         do-delete = true.

         if prev_status = "C" and
            wo_mstr.wo_acct_close and
            wo_mstr.wo_wip_tot = 0
         then
            do-delete = true.

         else
         if can-do("P,B,F",prev_status) and
            wo_mstr.wo_wip_tot = 0
         then
            do-delete = true.

         else
            do-delete = false.

         /* TO AVOID DELETION OF WORK ORDERS WHEN wo_wip_tot = 0     */
         /* AND wo_qty_comp <> 0                                     */
         if can-do("B,F",wo_mstr.wo_status) and
            wo_mstr.wo_qty_comp <> 0
         then
            do-delete = false.

         if not do-delete
         then do:
            /* DELETE NOT ALLOWED. WO ACCOUNTING MUST BE CLOSED */
            {pxmsg.i &MSGNUM=536 &ERRORLEVEL=3}
            undo.
         end.

         del-yn = yes.
         /* PLEASE CONFIRM DELETE */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = no then
            undo.

         if wo_mstr.wo_joint_type <> "" and
            wo_mstr.wo_status <> "B"
         then do:

            del-joint = no.

            /* DELETE JOINT WORK ORDERS? */
            {pxmsg.i &MSGNUM=6541 &ERRORLEVEL=1 &CONFIRM=del-joint}

            /* ABOUT TO DELETE LAST REMAINING CO-PRODUCT WO? */
            if not del-joint and wo_mstr.wo_joint_type = "1" then
            find first wo_mstr1
                 where wo_mstr1.wo_nbr =  wo_mstr.wo_nbr and
                       wo_mstr1.wo_lot <> wo_mstr.wo_lot and
                       wo_mstr1.wo_type = "" and
                       wo_mstr1.wo_joint_type = "1"
            exclusive-lock no-error.

            /* MUST DEL JOINT ORDER SET IF BASE OR THE LAST REMAINING*/
            if not del-joint and
               (wo_mstr.wo_joint_type = "5" or wo_mstr.wo_status = "F" or
               (wo_mstr.wo_joint_type = "1" and not available wo_mstr1))
            then do:
               del-yn = no.
               undo.
            end.

         end.

      end. /* DO FOR WO_MSTR1 */

   end.  /* IF DELETE... */

   if not del-yn then do:

      if index("PFB",prev_status) = 0
         and index("PFB",wo_status) = 0
         and wo_routing <> prev_routing
      then do:
         /* CANNOT CHANGE ROUTING */
         {pxmsg.i &MSGNUM=127 &ERRORLEVEL=3}
         next-prompt wo_routing.
         display prev_routing @ wo_routing.
         undo, retry.
      end.

      if index("PFB",prev_status) = 0
         and index("PFB",wo_status) = 0
         and wo_bom_code <> prev_bomcode
      then do:
         /* CANNOT CHANGE PRODUCT STRUCTURE */
         {pxmsg.i &MSGNUM=153 &ERRORLEVEL=3}
         next-prompt wo_bom_code.
         display prev_bomcode @ wo_bom_code.
         undo, retry.
      end.

      if wo_type = "" and (new_wo or bom_code_entered)
      then do:

         if not add_2_joint then do:
            /* EXPLODE TO SEE IF THIS IS A CO-PRODUCT */
            find first ps_mstr where
                       ps_par = wo_part
                   and ps_comp = wo_bom_code and ps_ref = ""
                   and ps_ps_code = "J" and ps_joint_type = "1"
                   and (ps_start <= wo_rel_date or ps_start = ?)
                   and (ps_end   >= wo_rel_date or ps_end = ?)
            no-lock no-error.
            if not available ps_mstr then do:
               /* SEE IF THIS IS A BASE PROCESS */
               if wo_bom_code <> ""
               then do:
                  find first ps_mstr where
                             ps_comp = wo_bom_code
                         and ps_ref = ""
                         and ps_ps_code = "J"
                         and ps_joint_type <> ""
                         and (ps_start <= wo_rel_date or ps_start = ?)
                         and (ps_end   >= wo_rel_date or ps_end = ?)
                  no-lock no-error.
               end.
               else do:
                  find first ps_mstr where
                             ps_comp = wo_part
                         and ps_ref = ""
                         and ps_ps_code = "J"
                         and ps_joint_type <> ""
                         and (ps_start <= wo_rel_date or ps_start = ?)
                         and (ps_end   >= wo_rel_date or ps_end = ?)
                  no-lock no-error.
               end.
            end.

            /* JP WO IS CO/BY DEFAULT. NOT JP: NO PS OR ADD TO NON-JP*/
            if new_wo and not available ps_mstr
               and not wo_joint_type = "5"
               and not add_2_joint
            then do:
               assign
                  wo_joint_type = ""
                  wo_base_id = ""
                  joint_label = "".
/* SS - 090616.1 - B 
               display
                  joint_label
               with frame a.
SS - 090616.1 - E */
            end.

         end.

      end.

      find pt_mstr no-lock where pt_part = wo_part no-error.
      find ptp_det where
           ptp_part = wo_part and
           ptp_site = wo_site
      no-lock no-error.

      if index("1234",wo_joint_type) = 0 then do:
         /* NOT A JOINT PRODUCT */
         if available ptp_det then
            leadtime = ptp_mfg_lead.
         else
            leadtime = pt_mfg_lead.
      end.

      if wo_joint_type <> "" and wo_yield_pct <> 100 then do:
         /* YIELD MUST BE 100% ON JOINT PRODUCTS */
         {pxmsg.i &MSGNUM=6527 &ERRORLEVEL=3}
         next-prompt wo_yield.
         undo, retry.
      end.

      if wo_ord_date = ? then
         wo_ord_date = today.
      if wo_rel_date = ? and wo_due_date = ? then
         wo_rel_date = max(today,wo_ord_date).

      if add_2_joint then do:
         assign
            wo_rel_date = rel_date
            wo_due_date = due_date
            wo_routing  = prev_routing
            wo_bom_code = prev_bomcode.
      end.

/* SS - 090616.1 - B 
      display
         wo_ord_date
         wo_rel_date
         wo_due_date.
SS - 090616.1 - E */

      if wo_due_date < wo_rel_date then do:
         /* DUE DATE BEFORE RELEASE DATE NOT ALLOWED */
         {pxmsg.i &MSGNUM=514 &ERRORLEVEL=3}
         next-prompt wo_rel_date.
         undo, retry.
      end.

      if wo_status = "" or wo_status = ? then
         wo_status = prev_status.

      if index("BFEARC",wo_status) = 0
      or ((index("RE",wo_type) > 0) and index("ARC",wo_status) = 0)
      or ((index("F",wo_type) > 0)  and index("FEARC",wo_status) = 0)
      or (wo_joint_type <> "" and not new_wo and
          wo_status = "B" and prev_status <> "B")
      then do:
         /* INVALID STATUS */
         {pxmsg.i &MSGNUM=19 &ERRORLEVEL=3
                  &MSGARG1="""'"" + wo_status + ""'"""}
         display
            prev_status @ wo_status.
         next-prompt wo_status.
         undo, retry.
      end.

      if index("PFBEARC",wo_status) > 0 then
         wo_status = entry(index("PFBEARC",wo_status),"P,F,B,E,A,R,C").

      /* UPDATE STATUS CLOSE DATE AND USERID ON DISCRETE WORK ORDERS */
      {wostatcl.i}

      if ((index("PFB",prev_status) > 0 and index("FEAR",wo_status) > 0))
      or ((index("FEARC",prev_status) > 0 and index("FB",wo_status) > 0))
      then do:
         /* CHECK WOD_QTY_ISS STATUS FOR ALL COMPONENTS */
         if wo_joint_type = "" or wo_joint_type = "5" then do:
            {mfwomta.i wo_lot any_issued any_feedbk}
         end.
         else do:
            {mfwomta.i wo_base_id any_issued any_feedbk}
         end.
         if any_issued then do:
            /* WORK ORDER COMPONENTS HAVE BEEN ISSUED */
            {pxmsg.i &MSGNUM=529 &ERRORLEVEL=3}
         end.
         if any_feedbk then do:
            /* LABOR FEEDBACK HAS BEEN REPORTED */
            {pxmsg.i &MSGNUM=554 &ERRORLEVEL=3}
         end.
         if any_issued or any_feedbk then do:
            /* PREVIOUS VALUE: */
            {pxmsg.i &MSGNUM=530 &ERRORLEVEL=1 &MSGARG1=prev_status}
            next-prompt wo_status.
            undo, retry.
         end.
      end.

      if prev_status = "R" and prev_qty <> wo_qty_ord then
      do on error undo, retry:
         /* ORDER QUANTITY CHANGED ON RELEASED ORDER */
         {pxmsg.i &MSGNUM=552 &ERRORLEVEL=2}
         if not batchrun then pause.
      end.
/* SS - 090616.1 - B 
      {gprun.i ""gpsiver.p""
         "(input wo_site, input ?, output return_int)"}
      if return_int = 0 then do:
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         next-prompt wo_site with frame a.
         undo, retry.
      end.
SS - 090616.1 - E */

      /* CHANGE ON A JOINT WO MAY AFFECT OTHER JOINT WOs */
      if wo_joint_type <> "" and not new_wo then do:

         /* CHANGE TO BATCH STATUS, DELETE OTHER JP ORDERS IN SET */
         if wo_status = "B" and prev_status <> "B" then do:

            del-joint = no.

            for each wo_mstr1 where
                     wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                     wo_mstr1.wo_type = "" and
                     wo_mstr1.wo_lot <> wo_mstr.wo_lot
            exclusive-lock:
               wo_recno = recid(wo_mstr1).
               {gprun.i ""wowomte.p""}
            end.

            assign
               wo_recno = recid(wo_mstr)
               wo_base_id = "".

         end.

         /* CHECK PRODUCT STRUCTURE */
         if bom_code_entered or rel_date_entered then do:

            if wo_joint_type = "5" then /* Base still makes co-prod? */
            find first ps_mstr where
                       ps_comp = wo_part
                   and ps_ref = ""
                   and ps_ps_code = "J"
                   and ps_joint_type = "1"
                   and (ps_start <= wo_rel_date or ps_start = ?)
                   and (ps_end   >= wo_rel_date or ps_end = ?)
            no-lock no-error.

            else                        /* JProduct still effective? */
            find first ps_mstr where
                       ps_par = wo_part
                   and ps_comp = wo_bom_code
                   and ps_ref = ""
                   and ps_ps_code = "J"
                   and index("1234",ps_joint_type) > 0
                   and (ps_start <= wo_rel_date or ps_start = ?)
                   and (ps_end   >= wo_rel_date or ps_end = ?)
            no-lock no-error.

            /* SWITCHED TO A NON-JOINT WO? TRY A NON-JP BOM. */
            if not available ps_mstr then do:

               find first ps_mstr where
                          ps_par = wo_part
                      and ps_comp = wo_bom_code
                      and ps_joint_type = ""
                      and (ps_start <= wo_rel_date or ps_start = ?)
                      and (ps_end   >= wo_rel_date or ps_end = ?)
               no-lock no-error.

               /* MAKE ON A NON-JP WO. DELETE OTHER JP WO IN SET. */
               if available ps_mstr then do:

                  del-joint = yes.

                  /* ITEM IS NOT EFFECTIVE IN JOINT PRODUCT STRUCTURE*/
                  {pxmsg.i &MSGNUM=6528 &ERRORLEVEL=1}
                  /* Delete joint work orders? */
                  {pxmsg.i &MSGNUM=6541 &ERRORLEVEL=1 &CONFIRM=del-joint}

                  if not del-joint then
                     undo, retry.
                  joint_label = "".
                  display
                     joint_label
                  with frame a.

                  del-joint = no.
                  for each wo_mstr1 where
                           wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                           wo_mstr1.wo_type = "" and
                           wo_mstr1.wo_lot <> wo_mstr.wo_lot
                  exclusive-lock:
                     wo_recno = recid(wo_mstr1).
                     {gprun.i ""wowomte.p""}
                  end.
                  wo_recno = recid(wo_mstr).
                  wo_joint_type = "".
               end.
               else do:
                  next-prompt
                     wo_bom_code.
                  display
                     prev_bomcode @ wo_bom_code.
                  /* JP not produced by BOM/Formula */
                  {pxmsg.i &MSGNUM=6546 &ERRORLEVEL=3}
                  undo, retry.
               end.
            end.
         end.

         /* ASK IF OTHER JOINT WOS NEED UPDATE. */
         if wo_status <> "B" and wo_joint_type <> "" and
            (qty_ord_entered or ord_date_entered or
            rel_date_entered or due_date_entered)
         then do:

            if wo_status = "F" then do:
               /* ALWAYS UPDATE FIRM ORDERS */
               assign
                  joint_qtys = yes
                  joint_dates = yes.
            end.
            else do:
               pause 0.
               if (qty_ord_entered) then
                  joint_qtys = yes.
               else
                  joint_qtys = no.
               if (ord_date_entered or rel_date_entered or due_date_entered)
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

      end.  /* WO_JOINT_TYPE <> ""... */

      check-routing:
      do:
         /* FOR RMA TYPE WORK ORDERS, DON'T PERFORM ROUTING CHECKS */
         if wo_fsm_type = "RMA" then
            leave check-routing.

         if available ptp_det then do:
            if (wo_routing = ptp_routing or wo_routing = wo_part)
               and (wo_bom_code = ptp_bom_code or
                   (wo_bom_code = wo_part and wo_joint_type = "5"))
            then
               leave check-routing.
         end.
         else do:
            if (wo_routing = pt_routing or wo_routing = wo_part)
               and (wo_bom_code = pt_bom_code or
                   (wo_bom_code = wo_part and wo_joint_type = "5"))
            then
               leave check-routing.
         end.

         /* JP HAVE NO ROUTING. CHECK PT_BOM, PTP_BOM OR PS ALT */
         if index("1234",wo_joint_type) <> 0 then do:

            if not new_wo or add_2_joint then
               leave check-routing.

            /* VALID BOM IF PT_BOM OR PTP_BOM */
            if available ptp_det and wo_bom_code = ptp_bom_code then
               leave check-routing.
            if not available ptp_det and wo_bom_code = pt_bom_code then
               leave check-routing.

            /* VALID BOM IF ALT STRUCTURE DEFINED */
            find first ps_mstr where
                       ps_par = wo_part
                   and ps_comp = wo_bom_code
                   and ps_ps_code = "A"
            no-lock no-error.
            if available ps_mstr then leave check-routing.

            msg-type = 3.
            if index("PFB",prev_status) = 0
               and index("PFB",wo_status) = 0
            then
               msg-type = 2.

            /* PRODUCT STRUCTURE NOT VALID FOR ITEM */
            {pxmsg.i &MSGNUM=151 &ERRORLEVEL=msg-type}

            if msg-type = 3 then do:
               next-prompt wo_bom_code.
               undo, retry.
            end.

            if wo_bom_code <> "" and msg-type = 3 then
               if not can-find(first ps_mstr where ps_par = wo_bom_code)
               then do:
                  /* NO BILL OF MATERIAL EXISTS */
                  {pxmsg.i &MSGNUM=100 &ERRORLEVEL=2}
               end.

         end.  /* IS JOINT PRODUCT... */

         else do: /* NOT JOINT PRODUCT */

            /* VALIDATE ROUTING AND PRODUCT STRUCTURE */
            msg-type = 3.
            if index("PFB",prev_status) = 0
               and index("PFB",wo_status) = 0
            then
               msg-type = 2.

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

         end. /* NOT A JOINT PRODUCT */
      end.  /* CHECK-ROUTING */

      /* CHECK IF COMPONENT YIELD ITEM,                */
      /* AND IF YIELD NEEDS TO BE RECALCULATED.        */
      run check-component-yield
         (output use_op_yield,
          output yield_pct).
      if use_op_yield then do:
         wo_yield_pct = yield_pct.
/* SS - 090616.1 - B 
         display
            wo_yield_pct
         with frame b.
SS - 090616.1 - E */
      end.

      if prev_site <> wo_site then do:
         {gprun.i ""csavg01.p""
            "(input global_part,
              input wo_site,
              output glx_set,
              output glx_mthd,
              output cur_set,
              output cur_mthd)"}

         if (prev_mthd <> glx_mthd) and
            (wo_mtl_tot <> 0 or wo_lbr_tot <> 0 or
             wo_bdn_tot <> 0 or wo_ovh_tot <> 0 or
             wo_sub_tot <> 0 or wo_wip_tot <> 0)
         then do:
            /* NEW SITE USES DIFFERENT COSTING METHOD.     */
            /* CHANGE NOT ALLOWED                          */
            {pxmsg.i &MSGNUM=5426 &ERRORLEVEL=3}
            next-prompt wo_site.
            display prev_site @ wo_site.
            undo, retry.
         end.

         if glx_mthd = "AVG" and wo_var then do:
            /* AVERAGE COST SITE.                          */
            /* VARIANCE POSTING AT LABOR ENTRY NOT ALLOWED */
            {pxmsg.i &MSGNUM=5427 &ERRORLEVEL=3}
            next-prompt wo_var.
            undo, retry.
         end.

      end.

      /* ATTRIBUTES DATA */
/* SS - 090616.1 - B 
      if available clc_ctrl
         and (lookup(wo_status,"P,B,C,") = 0) then do:
         hide frame b no-pause.
         if pt_auto_lot = yes and pt_lot_grp = " " then do:
            if (wo_lot_next = "") then
               wo_lot_next =   wo_lot.
            wo_lot_rcpt = no.
         end.
         {gprun.i ""clatmt1.p"" "(wo_recno)"}
      end.
SS - 090616.1 - E */
/* SS - 090616.1 - B */
wo_lot_rcpt = no .
wo_lot_next = "" .
/* SS - 090616.1 - E */

      /* SET & VALIDATE GL ACCOUNTS/COST CENTERS */
/* SS - 090616.1 - B 
      hide frame attrmt no-pause.
      hide frame b no-pause.

      {gprun.i ""womtacct.p""}
SS - 090616.1 - E */
/* SS - 090616.1 - B */
      {gprun.i ""xxwomtacctxp.p""}
/* SS - 090616.1 - E */
      if keyfunction (lastkey) = "end-error" then undo, retry.
/* SS - 090616.1 - B 
      if wo_joint_type = "" or wo_status = "B" then view frame b.
SS - 090616.1 - E */

      define buffer simstr for si_mstr.
      if wo_wip_tot <> 0 and wo_site <> prev_site then do:
         find simstr where simstr.si_site = prev_site no-lock.
         find si_mstr where si_mstr.si_site = wo_site no-lock.
         if simstr.si_entity <> si_mstr.si_entity then do:
            /* WIP value exists for previous site entity */
            {pxmsg.i &MSGNUM=551 &ERRORLEVEL=3}
            next-prompt wo_site.
            undo, retry.
         end.
      end.

      /* TRANSACTION COMMENTS */
/* SS - 090616.1 - B 
      if wocmmts = yes then do:
         assign
            global_ref = wo_part
            cmtindx = wo_cmtindx.

         hide frame a no-pause.
         hide frame b no-pause.

         {gprun.i ""gpcmmt01.p"" "(input ""wo_mstr"")"}

         view frame a.
         view frame b.

         wo_cmtindx = cmtindx.
      end.
SS - 090616.1 - E */
/* SS - 090616.1 - B */
wocmmts = no.
/* SS - 090616.1 - E */

      if new_wo then
      assign
         prev_ord = wo_ord_date
         prev_due = wo_due_date
         prev_site = wo_site
         prev_routing = wo_routing
         prev_bomcode = wo_bom_code
         prev_release = wo_rel_date.

   end. /* NOT DEL-YN */

   undo_all = no.

end. /* DO WITH FRAME B */
/* SS - 090616.1 - B 
/* If wo_type = "w" then display only */
else do:
   do on endkey undo, leave:
      if not batchrun then pause.
      /* ATTRIBUTES DATA */
      if available clc_ctrl
         and (lookup(wo_status,"P,B,C,") = 0) then do:
         hide frame b no-pause.
         find pt_mstr no-lock where pt_part = wo_part no-error.
         if pt_auto_lot = yes and pt_lot_grp = " " then do:
            if (wo_lot_next = "") then
               wo_lot_next =   wo_lot.
            wo_lot_rcpt = no.
         end.
         {gprun.i ""clatmt1.p"" "(wo_recno)"}
         if not batchrun then pause.
      end.
      /* SET & VALIDATE GL ACCOUNTS/COST CENTERS */
      hide frame attrmt no-pause.
      hide frame b no-pause.
      {gprun.i ""womtacct.p""}
      if not batchrun then pause.
      view frame b.
   end.
   if keyfunction (lastkey) = "end-error" then view frame b.
end.  /* wo_type = "w" */
SS - 090616.1 - E */

PROCEDURE check-component-yield:
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
   define output parameter op_use_op_yield          as logical no-undo.
   define output parameter op_yield_pct             as decimal no-undo.

   define variable routing as character no-undo.
   define variable op      like wod_op  no-undo.

   assign
      op_yield_pct = wo_mstr.wo_yield_pct.

   if available ptp_det then
      op_use_op_yield = ptp_det.ptp_op_yield.
   else
      op_use_op_yield  = pt_mstr.pt_op_yield.

   if op_use_op_yield = yes then do:

      for first mrpc_ctrl
      fields (mrpc_op_yield)
      no-lock: end.

      if (available mrpc_ctrl and mrpc_op_yield = no) or
         not available mrpc_ctrl
      then
         op_use_op_yield = no.

      if op_use_op_yield = yes then do:

         /* CHECK IF REF-DATE OR ROUTING CODE HAS CHANGED */
         /* AND NOT JOINT PRODUCT                         */
         if ((wo_mstr.wo_rel_date <> prev_release) or
             (wo_mstr.wo_routing <> prev_routing))
            and wo_mstr.wo_joint_type = ""
         then do:

            /* DETERMINE IF WORK ORDER QUALIFIES FOR RE-EXPLOSION      */
            /* AS THIS IS THE ONLY TIME THE YIELD PERCENTAGE           */
            /* SHOULD CHANGE... */
            if (index("FB",wo_status) > 0)
            or (index("PFB",prev_status) > 0 and index("FEAR",wo_status) > 0)
            or (wo_type = "S")
            then do:

               /* DETERMINE IF ROUTING CODE OR PART SHOULD BE USED... */
               if wo_routing <> "" then
                  routing = wo_routing.
               else
                  routing = wo_part.

               /* PASS 9'S AS OPERATION SO ALL OPERATIONS ARE USED.. */
               op = 999999999.

               /* CALCULATE YIELD PERCENTAGE... */
               {gprun.i ""gpcmpyld.p""
                  "(input routing,
                    input wo_rel_date,
                    input op,
                    output op_yield_pct)"}

            end. /* IF (INDEX("FB",WO_STATUS... */

         end. /* IF WO_MSTR.WO_REL_DATE <> PREV_RELEASE... */

      end. /* IF OP-USE-OP-YIELD = YES... */

   end. /* IF OP-USE-OP-YIELD = YES... */

END PROCEDURE.

PROCEDURE checkWorkOrderOnFlowSchedule:
/*------------------------------------------------------------------------------
  Purpose: Determine if work order is assigned to a flow schedule detail record.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
if can-find(first flsd_det where flsd_site = wo_mstr.wo_site
   and flsd_part = wo_mstr.wo_part
   and flsd_flow_wo_nbr = wo_mstr.wo_nbr) then
   flow-exists = yes.
else flow-exists = no.

END PROCEDURE.  /* checkWorkOrderOnFlowSchedule */
