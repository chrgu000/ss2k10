/* srsromt.p - SERVICE/REPAIR ORDER MAINTENANCE                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 02/24/87   BY: pml                       */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41*                 */
/* REVISION: 4.0      LAST MODIFIED: 02/12/88   BY: pml *Axx*                 */
/* REVISION: 4.0      LAST MODIFIED: 02/27/89   BY: WUG *B038*                */
/* REVISION: 6.0      LAST MODIFIED: 03/22/90   BY: ftb *D013*                */
/* REVISION: 6.0      LAST MODIFIED: 10/19/90   BY: pml *D109*                */
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048*                */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   BY: afs *F605*                */
/* REVISION: 7.0      LAST MODIFIED: 06/29/92   BY: tjs *F698*                */
/*           7.3                     09/10/94   BY: bcm *GM05*                */
/* REVISION: 7.3      LAST MODIFIED: 09/22/94   BY: jpm *GM78*                */
/* REVISION: 7.3      LAST MODIFIED: 10/19/94   BY: ljm *GN40*                */
/* REVISION: 7.3      LAST MODIFIED: 11/07/94   BY: ljm *GO15*removed GN40    */
/* REVISION: 7.3      LAST MODIFIED: 11/21/94   BY: afs *FT97*                */
/* REVISION: 7.3      LAST MODIFIED: 06/09/95   BY: rvw *G0PR*                */
/* REVISION: 8.5      LAST MODIFIED: 02/08/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane           */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan          */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan          */
/* REVISION: 9.0     LAST MODIFIED: 12/15/98   BY: *J34F* Vijaya Pakala       */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan          */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown          */
/* REVISION: 9.1     LAST MODIFIED: 11/20/00   BY: *N0TW* Jean Miller         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.16 $    BY: Jean Miller          DATE: 05/15/02  ECO: *P05V*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define new shared variable ad_recno as recid.
define new shared variable ship2_addr like sro_ship.
define new shared variable ship2_pst_id like cm_pst_id.
define new shared variable ship2_lang like cm_lang.
define new shared variable ship2_ref like cm_addr.

define variable del-yn like mfc_logical.
define variable sronbr like sro_nbr.
define variable yn like mfc_logical initial yes.
define variable i as integer.

do transaction on error undo, retry:
   find first sroc_ctrl no-lock no-error.
   if not available sroc_ctrl then create sroc_ctrl.
end.

mainloop:
repeat:

   find first sroc_ctrl no-lock no-error.

   do transaction on error undo, retry:

      /* DISPLAY SELECTION FORM */
      form
         space(1)
         sro_nbr
         sro_cust
         sro_ship
      with frame a side-labels width 80.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame a:handle).

      form
         sro_taken      colon 13
         sro_po         colon 36

         sro_rga        colon 67
         sro_assign     colon 13
         sro_type       colon 36

         sro_author     colon 67
         sro_ent_date   colon 13
         sro_cr_terms   colon 36

         sro_print_rg   colon 67
         sro_due_date   colon 13
         sro_wrrnty     colon 36

         sro_dspstn     colon 67
         sro_cls_date   colon 13
         sro_status     colon 36

         sro_dspstn     colon 67
         sro_part       colon 13
         sro_serial     colon 36 label "L/S"

         sro_rev        colon 67
         sro_failure1   colon 13
         sro_failure2   no-label
         sro_failure3   no-label
         sro_failure4   no-label
         sro_failure5   no-label
         sro_repair1    colon 13
         sro_repair2    no-label
         sro_repair3    no-label
         sro_repair4    no-label
         sro_repair5    no-label
      with frame b side-labels width 80.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      {mfadform.i "bill_to" 1 "BILL-TO"}
      {mfadform.i "ship_to" 41 "SHIP-TO"}

      view frame dtitle.
      view frame a.
      view frame bill_to.
      view frame ship_to.
      view frame b.

      prompt-for sro_nbr with frame a
      editing:

         /* Allow last SO number refresh */
         if keyfunction(lastkey) = "RECALL" or lastkey = 307
            then display sronbr @ sro_nbr with frame a.

         /* FIND NEXT/PREVIOUS  RECORD */
         {mfnp.i sro_mstr sro_nbr sro_nbr sro_nbr sro_nbr sro_nbr}

         if recno <> ? then do:

            {mfaddisp.i sro_cust bill_to}
            {mfaddisp.i sro_ship ship_to}

            display
               sro_nbr sro_cust sro_ship
            with frame a.

            display
               sro_taken sro_assign sro_ent_date
               sro_due_date sro_cls_date sro_type
               sro_po sro_cr_terms sro_wrrnty
               sro_status sro_rga sro_author sro_print_rg
               sro_dspstn
               sro_part sro_serial sro_rev
               sro_failure1 sro_failure2 sro_failure3
               sro_failure4 sro_failure5
               sro_repair1 sro_repair2 sro_repair3
               sro_repair4 sro_repair5
            with frame b.

         end.

      end.

      if input sro_nbr = "" then do:
         {mfnctrl.i sroc_ctrl sroc_sro sro_mstr sro_nbr sronbr}
      end.
      if input sro_nbr <> "" then
         sronbr = input sro_nbr.

   end.

   /* TRANSACTION */
   do transaction on error undo, retry:

      find sro_mstr where sro_nbr = sronbr exclusive-lock no-error.

      if not available sro_mstr then do:

         find first sroc_ctrl no-lock.

         clear frame bill_to.
         clear frame ship_to.
         clear frame b.

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         create sro_mstr.
         assign
            sro_nbr = sronbr
            sro_ent_date = today.
      end.

      else do:
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}

         {mfaddisp.i sro_cust bill_to}
         if not available ad_mstr then do:
            hide message no-pause.
            {pxmsg.i &MSGNUM=3 &ERRORLEVEL=2}
         end.

         {mfaddisp.i sro_ship ship_to}
      end.

      recno = recid(sro_mstr).

      display sro_nbr sro_cust sro_ship with frame a.

      display
         sro_taken sro_assign sro_ent_date
         sro_due_date sro_cls_date sro_type
         sro_po sro_cr_terms sro_wrrnty
         sro_status sro_rga sro_author sro_print_rg
         sro_dspstn
         sro_part sro_serial sro_rev
         sro_failure1 sro_failure2 sro_failure3 sro_failure4 sro_failure5
         sro_repair1 sro_repair2 sro_repair3 sro_repair4 sro_repair5
      with frame b.

      prompt-for sro_mstr.sro_cust with frame a
      editing:
         /* FIND NEXT/PREVIOUS  RECORD */
         {mfnp.i cm_mstr sro_cust cm_addr sro_cust cm_addr cm_addr}
         if recno <> ? then do:
            sro_cust = cm_addr.
            display sro_cust with frame a.
            find ad_mstr where ad_addr = cm_addr  no-lock.
            {mfaddisp.i sro_cust bill_to}
         end.
      end.

      assign sro_cust = input sro_cust.

      global_addr = sro_cust.

      {mfaddisp.i sro_cust bill_to}

      find cm_mstr where cm_addr = sro_cust no-lock no-error.
      if not available ad_mstr or not available cm_mstr then do:
         {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
         next-prompt sro_cust with frame a.
         undo, retry.
      end.

      if new sro_mstr then do:
         sro_ship = sro_cust.
         display sro_ship with frame a.
         {mfaddisp.i sro_ship ship_to}
      end.

      prompt-for sro_mstr.sro_ship with frame a
      editing:

         /* FIND NEXT/PREVIOUS  RECORD */
         {mfnp01.i ad_mstr sro_ship ad_addr ad_ref cm_addr ad_ref}

         if recno <> ? then do:
            sro_ship = ad_addr.
            display sro_ship with frame a.
            {mfaddisp.i sro_ship ship_to}
         end.
      end.

      assign sro_ship = input sro_ship.

      {mfaddisp.i sro_ship ship_to}

      if not available ad_mstr then do:

         /* Ship-to does not exist. Add */
         {pxmsg.i &MSGNUM=301 &ERRORLEVEL=1 &CONFIRM=yn}

         if yn then do:

            assign
               ship2_addr   = sro_ship
               ship2_lang   = cm_lang
               ship2_pst_id = cm_pst_id
               ship2_ref    = cm_addr.

            {gprun.i ""sosost.p""}  /* Add Ship To */

            find ad_mstr where recid(ad_mstr) = ad_recno  no-lock no-error.
            if not available ad_mstr then do:
               next-prompt sro_ship with frame a.
               undo, retry.
            end.

            sro_ship = ad_addr.
            display sro_ship with frame a.
            {mfaddisp.i sro_ship ship_to}

         end.

         if not available ad_mstr or ad_ref <> cm_addr then do:
            {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
            next-prompt sro_ship with frame a.
            undo, retry.
         end.

         /* Assign next automatic number for new ship-to customer */
         if sro_mstr.sro_ship = "qadtemp" + mfguser then do:

            find ad_mstr where ad_addr = sro_mstr.sro_ship exclusive-lock.

            {mfactrl.i cmc_ctrl cmc_nbr ad_mstr ad_addr sro_ship}

            create ls_mstr.
            assign
               ad_addr = sro_ship
               ls_type = "ship-to"
               ls_addr = sro_ship.

            /* Ship-to record added */
            {pxmsg.i &MSGNUM=638 &ERRORLEVEL=1 &MSGARG1=sro_ship}

            display sro_ship with frame a.
         end.

      end.

      order-header:
      do on error undo, retry with frame b:

         ststatus = stline[2].
         status input ststatus.
         del-yn = no.

         if new sro_mstr then do:
            /* USE SHIP-TO CUSTOMER INFO FOR DEFAULT IF AVAILABLE */
            /* ELSE USE BILL-TO INFO */
            if sro_cust <> sro_ship and
               can-find(cm_mstr where cm_addr = sro_ship)
            then
               find cm_mstr where cm_addr = sro_ship no-lock.
            sro_cr_terms = cm_cr_terms.
            sro_shipvia = cm_shipvia.
         end.

         update
            sro_taken sro_assign sro_ent_date
            sro_due_date sro_cls_date sro_part sro_po
            sro_type sro_cr_terms sro_wrrnty
            sro_status sro_serial sro_rga sro_author sro_print_rg
            sro_dspstn sro_rev
            sro_failure1 sro_failure2 sro_failure3 sro_failure4 sro_failure5
            sro_repair1 sro_repair2 sro_repair3 sro_repair4 sro_repair5
         with frame b
         editing:

            readkey.

            /* DELETE */
            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            then do:
               del-yn = yes.
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if del-yn then leave.
            end.
            else apply lastkey.
         end.

         if del-yn then do:
            delete sro_mstr.
            clear frame a.
            clear frame bill_to.
            clear frame ship_to.
            clear frame b.
            del-yn = no.
            next mainloop.
         end.

      end.

      assign
         sro_taken = caps(sro_taken)
         sro_assign = caps(sro_assign)
         sro_type = caps(sro_type)
         sro_status = caps(sro_status)
         sro_author = caps(sro_author)
         sro_dspstn = caps(sro_dspstn)
         sro_failure1 = caps(sro_failure1)
         sro_failure2 = caps(sro_failure2)
         sro_failure3 = caps(sro_failure3)
         sro_failure4 = caps(sro_failure4)
         sro_failure5 = caps(sro_failure5)
         sro_repair1 = caps(sro_repair1)
         sro_repair2 = caps(sro_repair2)
         sro_repair3 = caps(sro_repair3)
         sro_repair4 = caps(sro_repair4)
         sro_repair5 = caps(sro_repair5).

      /* Check if SRO is closed */
      if sro_cls_date <> ? then
         sro_close = yes.
      else
         sro_close = no.

      hide frame bill_to no-pause.
      hide frame ship_to no-pause.
      hide frame b no-pause.

   end.

   /* COMMENTS */
   do transaction on error undo, retry:

      status input.

      form
         space(1)
         sro_nbr
         sro_cust
         sro_part
         skip
         sro_cmmt  no-label /*V8! view-as fill-in size 76 by 1 at 2  */
      with frame d side-labels width 80.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame d:handle).

      display
         sro_nbr
         sro_cust
         sro_part
         sro_cmmt
      with frame d.

      update text(sro_cmmt) with frame d.

   end.

end.

status input.
