/* dmdmmt.p - DRAFT MANAGEMENT MAINTENANCE                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.14.1.15 $                                                 */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: JJS   *F065*             */
/*                                   03/16/92   by: jjs   *F198*             */
/*                                                     (major re-write)      */
/*                                   05/13/92   by: jjs   *F489*             */
/*                                   05/15/92   by: jjs   *F501*             */
/*                                   05/22/92   by: jjs   *F523*             */
/* REVISION: 7.3      LAST MODIFIED: 11/05/92   by: jjs   *G280*             */
/* REVISION: 7.3      LAST MODIFIED: 10/27/94   BY: ame   *FS96*             */
/*                                   12/01/94   BY: str   *GO64*             */
/* REVISION: 8.5      LAST MODIFIED: 01/02/95   BY: taf   *J053*             */
/* REVISION: 8.6      LAST MODIFIED: 06/18/96   BY: bjl   *K001*             */
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: taf   *J101*             */
/* REVISION: 8.5      LAST MODIFIED: 08/26/96   BY: *G2D0* Sanjay Patil      */
/* REVISION: 8.5      LAST MODIFIED: 10/10/96   BY: rxm   *G1WR*             */
/* REVISION: 8.6      LAST MODIFIED  01/07/96   BY: bkm   *H0QL*             */
/* REVISION: 8.6      LAST MODIFIED: 01/23/97   BY: bjl   *K01G*             */
/*                                   02/17/97   BY: *K01R* E. Hughart        */
/*                                   03/04/97   BY: bkm   *J1HX*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 8.6E     LAST MODIFIED: 09/10/98   BY: *J2RK* Samir Bavkar      */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *J303* Prashanth Narayan */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/21/00   BY: *N0DB* Rajinder Kamra    */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *L10W* A. Philips        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* Revision: 9.1      Last Modified: 10/20/00   BY: *L14K* Jean Miller       */
/* REVISION: 8.6E     LAST MODIFIED: 01/12/01   BY: *L17C* Jean Miller       */
/* REVISION: 9.0      LAST MODIFIED: 10/23/00   BY: *N0WP* Ed van de Gevel   */
/* REVISION: 9.1      LAST MODIFIED: 29 JUN 2001 BY: *N0ZX* Ed van de Gevel  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.14.1.14    BY: Subramanian Iyer  DATE: 06/17/02  ECO: *N1LP*  */
/* $Revision: 1.14.1.15 $           BY: Manjusha Inglay   DATE: 07/29/02  ECO: *N1P4*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "DMDMMT.P"}

{gldydef.i new}
{gldynrm.i new}

/* FOR SWOPNINV.P */
define new shared variable arbill like ar_bill.

define variable rndmthd         like rnd_rnd_mthd                  no-undo.
define variable oldcurr         like ar_curr                       no-undo.
define variable retval          as   integer                       no-undo.
define variable ar_amt_fmt      as character                       no-undo.
define variable ar_amt_old      as character                       no-undo.
define variable artotal         like ar_amt    label "Total"       no-undo.

{&DMDMMT-P-TAG1}

define variable arnbr           like ar_nbr                        no-undo.

{&DMDMMT-P-TAG2}

define variable del-yn          as logical                         no-undo.
define variable amt             like ar_amt    label "Open Amount" no-undo.
define variable duedate         like ar_due_date                   no-undo.
define variable ardnbr          like ard_nbr                       no-undo.
define variable openamt         like ar_amt                        no-undo.
define variable ard_recno       as recid                           no-undo.
define variable unap-yn         like mfc_logical                   no-undo.
define variable arstatus        as character format "x(10)"        no-undo.
define variable mc-error-number like msg_nbr                       no-undo.
define variable is_transparent  like mfc_logical                   no-undo.
define variable tmpamt          like ard_amt                       no-undo.
define variable dft-ard-amt     like ard_amt                       no-undo.
define variable dft-ard-disc    like ard_disc                      no-undo.
define variable docamt          like ard_amt                       no-undo.

define buffer a1   for ar_mstr.
define buffer dft  for ar_mstr.
define buffer ard1 for ard_det.

{&DMDMMT-P-TAG3}

form
   ar_nbr       colon 17 format "x(8)"
   ar_bill      colon 36
   arstatus     at 19 no-label
   cm_sort      at 38 no-label
   ar_date      colon 17
   ar_bank      colon 36
   ar_po        colon 50
   duedate      colon 17
   ar_curr      colon 36
   ar_amt       colon 50
   ar_expt_date colon 17
   ar_print     colon 36
   artotal      colon 50
with frame a side-labels width 80.

{&DMDMMT-P-TAG4}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   ard_nbr
   amt
   dft-ard-amt
   dft-ard-disc
with frame b down width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

ar_amt_old = dft-ard-amt:format in frame b.

for first gl_ctrl
   fields(gl_base_curr gl_entity gl_rnd_mthd)
   no-lock:
end. /* FOR FIRST gl_ctrl */

{&DMDMMT-P-TAG5}

/* ADDED ENTITY INPUT PARAMETER */
{gprun.i ""gldydft.p"" "(input ""AR"",
                         input ""D"",
                         input gl_entity,
                         output dft-daybook,
                         output daybook-desc)"}

mainloop:
repeat with frame a:
   do transaction:
      prompt-for
         ar_nbr editing:
         artotal = 0.

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp07.i ar_mstr "input ar_nbr" ar_nbr ""D"" ar_type
          true ar_open """" """" ar_nbr}

         if recno <> ?
         then do:
            if (oldcurr <> ar_curr)
            or (oldcurr = "")
            then do:
               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input  ar_curr,
                    output rndmthd,
                    output mc-error-number)"}

               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                  undo mainloop.
               end. /* IF mc-error-number <> 0 */

               /* SET AR_AMT_FMT */
               run set-ar-amt-fmt.

            end. /* IF (oldcurr <> ar_curr)... */

            duedate = ar_due_date.

            {&DMDMMT-P-TAG6}

            run get-arstatus
               (input  ar_nbr,
                input  ar_draft,
                input  ar_open,
                output arstatus).

            {&DMDMMT-P-TAG7}

            display
               ar_nbr
               arstatus
               ar_bill
               ar_date
               ar_amt
               duedate
               ar_curr
               ar_expt_date
               ar_po
               ar_bank
               ar_print.

            for first cm_mstr
               fields(cm_addr cm_curr cm_sort)
               where cm_addr = ar_bill
               no-lock:
            end. /* FOR FIRST cm_mstr */

            if available cm_mstr
            then
               display
                  cm_sort.
            else
               display
                  " " @ cm_sort.

            {&DMDMMT-P-TAG8}

            for each ard_det
               fields(ard_acct ard_amt ard_cc ard_desc ard_disc
                  ard_dy_code ard_dy_num ard_entity ard_nbr
                  ard_ref ard_sub ard_type)
               where ard_ref = ar_nbr
               and (ard_type = "I"
               or   ard_type = "M"
               or   ard_type = "F")
               no-lock
               use-index ard_ref:

               {&DMDMMT-P-TAG9}

               {&DMDMMT-P-TAG44}

               for first a1
                  fields(ar_acct ar_amt ar_applied ar_bank ar_base_amt
                     ar_bill ar_cc ar_check ar_curr ar_cust ar_date
                     ar_dd_exru_seq ar_draft ar_due_date ar_dy_code
                     ar_effdate ar_entity ar_expt_date ar_exru_seq
                     ar_ex_rate ar_ex_rate2 ar_ex_ratetype ar_ldue_date
                     ar_nbr ar_open ar_po ar_print ar_sub ar_type
                     ar__qad01)
                  where a1.ar_nbr = ard_nbr
                  no-lock:
               end. /* FOR FIRST a1 */

               tmpamt = ard_amt.

               run convert_amt_from_doc_to_draft
                  (input        a1.ar_curr,
                   input        a1.ar_ex_rate,
                   input        a1.ar_ex_rate2,
                   input-output tmpamt).

               artotal = artotal + tmpamt.

               {&DMDMMT-P-TAG45}

            end. /* FOR EACH ard_det */
            display
               artotal.
         end. /* IF recno <> ? */
      end. /* PROMPT-FOR */

      if input ar_nbr = ""
      then do:
         {&DMDMMT-P-TAG10}
         {mfnctrl.i arc_ctrl arc_memo ar_mstr ar_nbr arnbr}
         display
            arnbr @ ar_nbr.
      end. /* IF INPUT ar_nbr = "" */
      else
         arnbr = input ar_nbr.

      {&DMDMMT-P-TAG11}

      for first ar_mstr
         fields(ar_acct ar_amt ar_applied ar_bank ar_base_amt
                ar_bill ar_cc ar_check ar_curr ar_cust ar_date
            ar_dd_exru_seq ar_draft ar_due_date ar_dy_code
            ar_effdate ar_entity ar_expt_date ar_exru_seq
            ar_ex_rate ar_ex_rate2 ar_ex_ratetype ar_ldue_date
            ar_nbr ar_open ar_po ar_print ar_sub ar_type ar__qad01)
         using ar_nbr
         no-lock:
      end. /* FOR FIRST ar_mstr */

      if available ar_mstr
      and ar_type <> "D"
      then do:
         /* RECORD IS NOT A DRAFT */
         {pxmsg.i &MSGNUM=3502 &ERRORLEVEL=3}
         undo mainloop.
      end. /* IF AVAILABLE ar_mstr AND ar_type <> "D" */

      if not available ar_mstr
      then do:
         /* ADDING NEW RECORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      end. /* IF NOT AVAILABLE ar_mstr */

   end. /* DO TRANSACTION */

   {&DMDMMT-P-TAG12}

   do transaction:
      /* ADD/MOD/DELETE */
      find ar_mstr
         using ar_nbr
         exclusive-lock no-error.

      if available ar_mstr
      then do:
         if (oldcurr <> ar_curr)
         or (oldcurr = "")
         then do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ar_curr,
                 output rndmthd,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               pause.
               undo mainloop.
            end. /* IF mc-error-number <> 0  */

            /* SET AR_AMT_FMT */
            run set-ar-amt-fmt.

         end. /* IF (oldcurr <> ar_curr)... */
      end. /* IF AVAILABLE ar_mstr */

      if not available ar_mstr
      then do:
         create ar_mstr.
         assign
            ar_nbr  = arnbr
            ar_type = "D"
            ar_date = today
            ar_open = true
            {&DMDMMT-P-TAG13}
            ar_dy_code = dft-daybook
            ar_curr    = gl_base_curr
            rndmthd    = gl_rnd_mthd.

         if recid(ar_mstr) = -1 then.

         /* SET AR_AMT_FMT */
         run set-ar-amt-fmt.

      end. /* IF NOT AVAILABLE ar_mstr */

      duedate = ar_due_date.
      {&DMDMMT-P-TAG14}
      run get-arstatus (input  ar_nbr,
                        input  ar_draft,
                        input  ar_open,
                        output arstatus).

      {&DMDMMT-P-TAG15}

      display
         ar_nbr
         arstatus
         ar_bill
         ar_date
         ar_amt
         duedate
         ar_curr
         ar_expt_date
         ar_po
         ar_bank
         ar_print.

      for first cm_mstr
         fields(cm_addr cm_curr cm_sort)
         where cm_addr = ar_bill
         no-lock:
      end.  /* FOR FIRST cm_mstr */

      if available cm_mstr
      then
         display
            cm_sort.
      else
         display
            " " @ cm_sort.

      {&DMDMMT-P-TAG16}

      for each ard_det
         fields(ard_acct ard_amt ard_cc ard_desc ard_disc
                ard_dy_code ard_dy_num ard_entity ard_nbr
                ard_ref ard_sub ard_type)
         where ard_ref = ar_nbr
         and (ard_type = "I"
         or ard_type   = "F"
         or ard_type   = "M")
         no-lock
         use-index ard_ref:

         {&DMDMMT-P-TAG17}

         do for a1:
            {&DMDMMT-P-TAG46}

            for first a1
               fields(ar_acct ar_amt ar_applied ar_bank ar_base_amt
               ar_bill ar_cc ar_check ar_curr ar_cust ar_date
               ar_dd_exru_seq ar_draft ar_due_date ar_dy_code
               ar_effdate ar_entity ar_expt_date ar_exru_seq
               ar_ex_rate ar_ex_rate2 ar_ex_ratetype ar_ldue_date
               ar_nbr ar_open ar_po ar_print ar_sub ar_type
               ar__qad01)
               where a1.ar_nbr = ard_det.ard_nbr
               no-lock:
            end. /* FOR FIRST a1 */

            tmpamt = ard_amt.

            run convert_amt_from_doc_to_draft
               (input        a1.ar_curr,
                input        a1.ar_ex_rate,
                input        a1.ar_ex_rate2,
                input-output tmpamt).
            artotal = artotal + tmpamt.

            {&DMDMMT-P-TAG47}
         end. /* DO FOR a1 */
      end. /* FOR EACH ard_det */

      display
         artotal.

      /* DRAFT IS OPEN OR APPROVED */
      if ar_open
      then do:
         /* DRAFT IS APPROVED */
         if ar_draft
         then do:
            loopa:
            do on error undo, retry:
               set
                  duedate
                  ar_expt_date
                  ar_print
                  ar_po.

               /* DUE DATE IS MANDATORY */
               if duedate = ?
               then do:
                  /* DATE REQUIRED */
                  {pxmsg.i &MSGNUM=711 &ERRORLEVEL=3}

                  next-prompt
                     duedate.
                  undo, retry.
               end. /* IF duedate = ? */

               ar_due_date = duedate.
            end. /* DO ON ERROR UNDO, RETRY */
         end. /* IF ar_draft */
         else do:
            {&DMDMMT-P-TAG18}
            /* NAME IF CUSTOMER ADDRESS WAS TYPED IN  */
            seta:
            do on error undo, retry:
               /* IF THE DRAFT IS NOT ATTACHED TO AN INVOICE THEN  */
               /* CUSTOMER ADDRESS CAN BE CHANGED */
               if not can-find(first ard_det
                  where ard_ref = ar_nbr)
               then do:
                  set
                     ar_bill
                     with frame a
                     editing:

                     {mfnp.i cm_mstr ar_bill cm_addr ar_bill cm_addr cm_addr}

                     if recno <> ?
                     then do:
                        ar_bill = cm_addr.
                        display
                           ar_bill
                           cm_sort
                           cm_curr @ ar_curr.
                     end. /* IF recno <> ? */
                  end. /* FRAME A EDITING */
                  ar_cust = ar_bill.
               end. /* IF NOT CAN-FIND(FIRST ard_det... */

               global_addr = ar_bill.

               for first cm_mstr
                  fields(cm_addr cm_curr cm_sort)
                  where cm_addr = ar_bill
                  no-lock:
               end. /* FOR FIRST cm_mstr */

               /* VALIDATE BILL-TO */
               if not available cm_mstr
               then do:
                  /* NOT A VALID CUSTOMER */
                  {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}

                  next-prompt
                     ar_bill
                     with frame a.
                  undo, retry.
               end. /* IF NOT AVAILABLE cm_mstr */

               if available cm_mstr
               and new ar_mstr
               then
                  display
                     cm_addr @ ar_bill
                     cm_sort
                     cm_curr @ ar_curr.
               else
                  display
                     cm_addr @ ar_bill
                     cm_sort
                     ar_curr.
            end.  /* SETA */

            {&DMDMMT-P-TAG19}

            setaa:
            do on error undo, retry:
               ststatus = stline[2].
               status input ststatus.
               del-yn = false.

               {&DMDMMT-P-TAG20}
               set
                  ar_date
                  duedate
                  ar_expt_date
                  ar_bank when (new ar_mstr
                                or not can-find(first ard_det
                                where ard_ref = ar_nbr))
                  ar_curr when (new ar_mstr
                               or not can-find(first ard_det
                               where ard_ref = ar_nbr))
                  ar_print
                  ar_po
                  go-on("F5" "CTRL-D") with frame a.

               {&DMDMMT-P-TAG21}

               /* DELETE */
               if lastkey = keycode("F5")
               or lastkey = keycode("CTRL-D")
               then do:
                  del-yn = true.
                  /* CONFIRM DELETE */
                  {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn
                           &CONFIRM-TYPE='LOGICAL'}
                  if not del-yn
                  then
                     undo setaa.
               end. /* IF lastkey = keycode("F5")... */

               if del-yn
               then do:
                  if ar_draft
                  then do:
                     /*DRAFT IS APPROVED CANNOT DELETE */
                     {pxmsg.i &MSGNUM=3514 &ERRORLEVEL=3}
                      undo, retry setaa.
                  end. /* IF ar_draft */
                  else do:
                     run delete-record.
                     clear frame a.
                     next mainloop.
                  end. /* ELSE DO */
               end.  /* IF del-yn */

               /* DUE DATE IS MANDATORY */
               if duedate = ?
               then do:
                  /* DATE REQUIRED */
                  {pxmsg.i &MSGNUM=711 &ERRORLEVEL=3}

                  next-prompt
                     duedate.
                  undo, retry.
               end. /* IF duedate = ? */

               ar_due_date = duedate.
               /* STORE ORIGINAL DUE DATE */
               if new ar_mstr
               then
                  ar_ldue_date = duedate.

               for first bk_mstr
                  fields (bk_code bk_curr bk_entity)
                  where bk_code = ar_bank
                  no-lock:
               end. /* FOR FIRST bk_mstr */

               if not available bk_mstr
               then do:
                  /* INVALID BANK CODE */
                  {pxmsg.i &MSGNUM=1200 &ERRORLEVEL=3}

                  next-prompt
                     ar_bank
                     with frame a.
                  undo, retry.
               end. /* IF NOT AVAILABLE bk_mstr */
               else
                  ar_entity = bk_entity.

               /* VALIDATE AR CURRENCY TO BANK CURRENCY */
               {&DMDMMT-P-TAG23}

               /* CHECK TO SEE IF THE BANK IS EURO TRANSPARENT */
               if  bk_curr <> ar_curr
               and bk_curr <> base_curr
               then
                  run is_euro_transparent (input  bk_curr,
                                           input  ar_curr,
                                           input  base_curr,
                                           input  ar_mstr.ar_due_date,
                                           output is_transparent).
               else
                  is_transparent = false.

               if is_transparent
               then do:
                  /* BANK IS EURO TRANSPARENT */
                  {pxmsg.i &MSGNUM=2769 &ERRORLEVEL=2}
               end.  /* IF is_transparent */
               else
               if  bk_curr <> ar_curr
               and bk_curr <> base_curr
               then do:
                  /* BANK DEFINED FOR DIFF CURR */
                  {pxmsg.i &MSGNUM=93 &ERRORLEVEL=3}

                  next-prompt
                     ar_curr
                     with frame a.
                  undo, retry.
               end. /* IF bk_curr <> ar_curr... */

               /* DETERMINE ROUND METHOD FROM DOC CURRENCY OR BASE */
               if (oldcurr <> ar_curr)
               then do:
                  if ar_curr = gl_base_curr
                  then
                     rndmthd = gl_rnd_mthd.
                  else do:
                     /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                     {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                        "(input  ar_curr,
                          output rndmthd,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        pause.
                        undo mainloop.
                     end. /* IF mc-error-number <> 0 */
                  end. /* ELSE DO: */

                  oldcurr = ar_curr.
               end.  /* IF (oldcurr <> ar_curr) */

               /* SET AR_AMT_FMT */
               run set-ar-amt-fmt.

               setb:
               do on error undo, retry:
                  set
                     ar_amt
                     with frame a.

                  if ar_amt < 0
                  then do:
                     /* NEGATIVE AMOUNT NOT ALLOWED */
                     {pxmsg.i &MSGNUM=228 &ERRORLEVEL=3}

                     next-prompt
                        ar_amt
                        with frame a.
                     undo, retry.
                  end. /*  IF ar_amt < 0 */

                  {&DMDMMT-P-TAG24}
                  if (ar_amt <> 0)
                  then do:
                     {gprun.i ""gpcurval.p"" "(input ar_amt,
                                               input rndmthd,
                                               output retval)"}

                     if (retval <> 0)
                     then do:
                        next-prompt
                           ar_amt
                           with frame a.
                        undo setb, retry.
                     end. /* IF (retval <> 0) */
                  end. /*  IF (ar_amt <> 0) */
               end. /* SETB */
            end. /* SETAA */

            {&DMDMMT-P-TAG43}

            /* PICK UP EXCH RATE FOR AR_DATE, NORMALLY TODAY. THIS   */
            /* IS ONLY USED FOR REPORTS, THE ACTUAL EXCH RATE IS     */
            /* PICKED UP DURING THE APPROVAL                         */

            /* IN MODIFY MODE DELETE THE OLD USAGE RECORD BEFORE     */
            /* GETTING THE NEW SEQUENCE FROM mc-create-ex-rate-usage */
            /* SINCE THE CALL CREATES A NEW USAGE RECORD.            */

            if ar_exru_seq <> 0
            then do:
               {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                  "(input ar_mstr.ar_exru_seq)"}
            end. /* IF ar_exru_seq <> 0 */

            /* GET EXCHANGE RATE AND ALSO CREATE THE */
            /* RATE USAGE RECORD IF TRIANGULATED RATE */
            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input  ar_curr,
                 input  base_curr,
                 input  ar_ex_ratetype,
                 input  ar_date,
                 output ar_ex_rate,
                 output ar_ex_rate2,
                 output ar_exru_seq,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                undo, retry.
            end. /* if mc-error-number <> 0 */

            if ar_mstr.ar_amt <> 0
            then do:
               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               /* UPDATE ar_base_amt */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input  ar_curr,
                    input  base_curr,
                    input  ar_ex_rate,
                    input  ar_ex_rate2,
                    input  ar_amt,
                    input  true, /* ROUND */
                    output ar_base_amt,
                    output mc-error-number)"}.

               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end. /* IF mc-error-number <> 0 */
            end. /* IF ar_mstr.ar_amt <> 0 */

            /* ATTACH INVOICES TO DRAFT DRAFT AR_NBR = INVOICE AR_CHECK */
            clear frame b all.
            arbill = ar_bill.

            {&DMDMMT-P-TAG25}
            checkloop:
            repeat:
               loopb:
               repeat with frame b:
                  view frame b.
                  {&DMDMMT-P-TAG26}
                  prompt-for
                     ard_nbr editing:
                     {mfnp01.i ard_det ard_nbr ard_nbr ar_nbr
                     ard_ref ard_nbr}

                     if     recno <> ?
                     and (ard_type = "I"
                     or   ard_type = "F"
                     or   ard_type = "M")
                     then do for a1:
                        display
                           ard_nbr.

                        for first a1
                           fields(ar_acct ar_amt ar_applied ar_bank
                                  ar_base_amt ar_bill ar_cc ar_check ar_curr
                                  ar_cust ar_date ar_dd_exru_seq ar_draft
                                  ar_due_date ar_dy_code ar_effdate ar_entity
                                  ar_expt_date ar_exru_seq ar_ex_rate
                                  ar_ex_rate2 ar_ex_ratetype ar_ldue_date
                                  ar_nbr ar_open ar_po ar_print ar_sub ar_type
                                  ar__qad01)
                           where a1.ar_nbr = input ard_nbr
                           no-lock:
                        end. /* FOR FIRST a1 */

                        /* IF THE DRAFT AND INV CURRENCY MATCH */
                        if a1.ar_bill = ar_mstr.ar_bill
                        then do:
                           {&DMDMMT-P-TAG27}
                           assign
                              amt:format          = ar_amt_fmt
                              dft-ard-amt:format  = ar_amt_fmt
                              dft-ard-disc:format = ar_amt_fmt
                              amt                 = a1.ar_amt
                                                    - a1.ar_applied
                              docamt              = amt.

                           if ar_mstr.ar_curr <> a1.ar_curr
                           then
                              run convert_amt_from_doc_to_draft
                                 (input        a1.ar_curr,
                                  input        a1.ar_ex_rate,
                                  input        a1.ar_ex_rate2,
                                  input-output amt).

                           for each ard1
                              fields(ard_acct ard_amt ard_cc ard_desc ard_disc
                                 ard_dy_code ard_dy_num ard_entity ard_nbr
                             ard_ref ard_sub ard_type)
                              where ard1.ard_nbr = a1.ar_nbr
                              and ard1.ard_ref <> ar_mstr.ar_nbr
                              and ard1.ard_ref <> ""
                              no-lock:

                              do for dft:
                                 for first dft
                                    fields(ar_acct ar_amt ar_applied
                                           ar_bank ar_base_amt ar_bill ar_cc
                                           ar_check ar_curr ar_cust ar_date
                                           ar_dd_exru_seq ar_draft ar_due_date
                                           ar_dy_code ar_effdate ar_entity
                                           ar_expt_date ar_exru_seq ar_ex_rate
                                           ar_ex_rate2 ar_ex_ratetype
                                           ar_ldue_date ar_nbr ar_open
                                           ar_po ar_print ar_sub ar_type
                                           ar__qad01)
                                    where dft.ar_nbr = ard1.ard_ref
                                    and dft.ar_effdate = ?
                                    no-lock:
                                 end. /* FOR FIRST dft  */

                                 if available dft
                                 then do:
                                    assign
                                       docamt = docamt - (ard1.ard_amt +
                                                ard1.ard_disc)
                                       tmpamt = ard1.ard_amt +
                                                ard1.ard_disc.

                                    run convert_amt_from_doc_to_draft
                                       (input dft.ar_curr,
                                        input dft.ar_ex_rate,
                                        input dft.ar_ex_rate2,
                                        input-output tmpamt).
                                    amt = amt - tmpamt.
                                 end. /* IF AVAILABLE dft */
                              end. /* DO FOR dft */
                           end.  /* FOR EACH ard1 */
                           {&DMDMMT-P-TAG28}
                           assign
                              dft-ard-amt  = ard_amt
                              dft-ard-disc = ard_disc.

                           run convert_amt_from_doc_to_draft
                              (input        a1.ar_curr,
                               input        a1.ar_ex_rate,
                               input        a1.ar_ex_rate2,
                               input-output dft-ard-amt).

                           run convert_amt_from_doc_to_draft
                              (input        a1.ar_curr,
                               input        a1.ar_ex_rate,
                               input        a1.ar_ex_rate2,
                               input-output dft-ard-disc).

                           display
                              amt
                              dft-ard-amt
                              dft-ard-disc.

                        end. /* IF a1.ar_bill = ar_mstr.ar_bill */

                        {&DMDMMT-P-TAG29}

                     end. /* IF recno <> ? */
                  end. /* EDITING */

                  /* ADD/MOD/DELETE */
                  {&DMDMMT-P-TAG30}

                  for first ard_det
                     fields(ard_acct ard_amt ard_cc ard_desc ard_disc
                            ard_dy_code ard_dy_num ard_entity ard_nbr
                            ard_ref ard_sub ard_type)
                     where ard_nbr = input ard_nbr
                     and ard_ref = ar_nbr
                     and (ard_type = "I"
                     or ard_type = "F"
                     or ard_type = "M")
                     use-index ard_nbr
                     no-lock:
                  end. /* FOR FIRST ard_det */

                  do for a1:
                     find a1
                        where ar_nbr  =  input ard_nbr
                        and   ar_bill = ar_mstr.ar_bill
                        and   ar_open = true
                        and  (ar_type = "I"
                        or    ar_type = "F"
                        or    ar_type = "M")
                     exclusive-lock no-error.

                     if not available a1
                     then do:
                        /* INVALID INVOICE REFERENCE NUMBER */
                        {pxmsg.i &MSGNUM=3511 &ERRORLEVEL=3}
                        undo, retry.
                     end. /* IF NOT AVAILABLE a1 */

                     {&DMDMMT-P-TAG31}

                     /* CHECK TO SEE IF EURO TRANSPARENT */
                     if available a1
                     and (a1.ar_curr      <> base_curr
                     or   ar_mstr.ar_curr <> base_curr)
                     then
                        run is_euro_transparent
                           (input  ar_mstr.ar_curr,
                            input  a1.ar_curr,
                            input  base_curr,
                            input  ar_mstr.ar_due_date,
                            output is_transparent).

                     if ar_mstr.ar_curr <> base_curr
                     and not is_transparent
                     and a1.ar_curr     <> ar_mstr.ar_curr
                     then do:
                        /* BANK DEFINED FOR DIFF CURR */
                        {pxmsg.i &MSGNUM=93 &ERRORLEVEL=3}
                        undo, retry.
                     end. /* IF ar_mstr.ar_curr <> base_curr... */

                     assign
                        amt:format          =  ar_amt_fmt
                        dft-ard-amt:format  =  ar_amt_fmt
                        dft-ard-disc:format =  ar_amt_fmt.

                     if available ard_det
                     then do:
                        assign
                           dft-ard-amt  = ard_amt
                           dft-ard-disc = ard_disc.

                        run convert_amt_from_doc_to_draft
                           (input        a1.ar_curr,
                            input        a1.ar_ex_rate,
                            input        a1.ar_ex_rate2,
                            input-output dft-ard-amt).

                        run convert_amt_from_doc_to_draft
                           (input        a1.ar_curr,
                            input        a1.ar_ex_rate,
                            input        a1.ar_ex_rate2,
                            input-output dft-ard-disc).
                        artotal = artotal - dft-ard-amt.
                     end. /* IF AVAILABLE ard_det */

                     assign
                        amt    = a1.ar_amt - a1.ar_applied
                        docamt = amt.

                     if ar_mstr.ar_curr <> a1.ar_curr
                     then
                        run convert_amt_from_doc_to_draft
                          (input        a1.ar_curr,
                           input        a1.ar_ex_rate,
                           input        a1.ar_ex_rate2,
                           input-output amt).

                     if not available ard_det
                     then do:
                        /* ADDING NEW RECORD */
                        {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

                        create ard_det.
                        assign
                           ard_acct    =  a1.ar_acct
                           ard_sub     =  a1.ar_sub
                           ard_cc      =  a1.ar_cc
                           ard_entity  =  a1.ar_entity
                           ard_nbr     =  a1.ar_nbr
                           ard_ref     =  substring(ar_mstr.ar_nbr,1,8)
                           ard_type    =  a1.ar_type
                           ard_dy_code =  dft-daybook
                           ard_dy_num  =  nrm-seq-num
                           ard_desc    =  a1.ar_po
                           a1.ar_check = substring(ar_mstr.ar_nbr,1,8)
                           a1.ar_draft = true
                           /* INDICATES INVOICE IS TIED TO A DRAFT */
                           dft-ard-amt  =  0
                           dft-ard-disc =  0.

                     end.  /* IF NOT AVAILABLE ard_det */

                     assign
                        ard_recno =  recid(ard_det)
                        ardnbr    =  ard_nbr.

                     for each ard_det
                        fields(ard_acct ard_amt ard_cc ard_desc ard_disc
                               ard_dy_code ard_dy_num ard_entity ard_nbr
                               ard_ref ard_sub ard_type)
                        where ard_nbr = ardnbr
                        and ard_ref   <> ar_mstr.ar_nbr
                        and ard_ref   <> ""
                        no-lock:

                        /* FIND OTHER UNAPPROVED DFTS ATTACHED TO INV */
                        for first a1
                           fields(ar_acct ar_amt ar_applied ar_bank
                                  ar_base_amt ar_bill ar_cc ar_check ar_curr
                                  ar_cust ar_date ar_dd_exru_seq ar_draft
                                  ar_due_date ar_dy_code ar_effdate ar_entity
                                  ar_expt_date ar_exru_seq ar_ex_rate
                                  ar_ex_rate2 ar_ex_ratetype ar_ldue_date
                                  ar_nbr ar_open ar_po ar_print ar_sub ar_type
                                  ar__qad01)
                           where a1.ar_nbr   = ard_ref
                           and a1.ar_effdate = ?
                           no-lock:
                        end. /* FOR FIRST a1  */

                        if available a1
                        then do:
                           {&DMDMMT-P-TAG32}
                           docamt = docamt  - (ard_amt + ard_disc).
                           tmpamt = ard_amt + ard_disc.

                           if a1.ar_curr <> ar_mstr.ar_curr
                           then
                              run convert_amt_from_doc_to_draft
                                 (input        a1.ar_curr,
                                  input        a1.ar_ex_rate,
                                  input        a1.ar_ex_rate2,
                                  input-output tmpamt).

                           amt = amt - tmpamt.
                           {&DMDMMT-P-TAG33}
                        end. /* IF AVAILABLE a1 */
                     end. /* FOR EACH ard_det */
                  end. /* DO FOR a1 */

                  find ard_det
                     where recid(ard_det) = ard_recno
                     exclusive-lock.

                  do for a1:
                     find a1
                        where a1.ar_nbr = ard_nbr
                        exclusive-lock.

                     if decimal(ar__qad01) <> 0
                     then
                        ar__qad01 = string(decimal(ar__qad01)
                                    - dft-ard-amt - dft-ard-disc).
                  end. /* DO FOR a1 */

                  openamt = amt.

                  if dft-ard-amt = 0
                  then
                     dft-ard-amt = amt.

                  {&DMDMMT-P-TAG34}

                  ststatus = stline[2].
                  status input ststatus.

                  display
                     ard_nbr
                     amt
                     dft-ard-amt
                     dft-ard-disc.

                  setb:
                  do on error undo, retry:
                     del-yn = false.
                     {&DMDMMT-P-TAG35}

                     set
                        dft-ard-amt
                        dft-ard-disc
                        go-on("F5" "CTRL-D").

                     {&DMDMMT-P-TAG36}

                     /* DELETE */
                     if lastkey = keycode("F5")
                     or lastkey = keycode("CTRL-D")
                     then do:
                        del-yn = true.

                        /* CONFIRM DELETE */
                        {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn
                                 &CONFIRM-TYPE='LOGICAL'}

                        if not del-yn
                        then
                           undo setb.
                     end. /* IF lastkey = keycode("F5")...  */

                     if del-yn
                     then do for a1:
                        find a1
                           where a1.ar_nbr   =  ard_nbr
                           exclusive-lock.

                        assign
                           a1.ar_check =  ""
                           a1.ar_draft =  false.

                        /* DETERMINE IF INVOICE IS ATTACHED TO ANY    */
                        /* OTHER DRAFTS.  IF SO AR_DRAFT WILL BE RESET*/
                        /* TO TRUE.                                   */
                        for each ard1
                           fields(ard_acct ard_amt ard_cc ard_desc ard_disc
                                  ard_dy_code ard_dy_num ard_entity ard_nbr
                                  ard_ref ard_sub ard_type)
                           where  ard1.ard_nbr  =  a1.ar_nbr
                              and ard1.ard_ref  =  ar_mstr.ar_nbr
                              and ard1.ard_type =  a1.ar_type
                           no-lock:

                           do for dft:
                              for first dft
                                 fields(ar_acct ar_amt ar_applied
                                        ar_bank ar_base_amt ar_bill ar_cc
                                        ar_check ar_curr ar_cust ar_date
                                        ar_dd_exru_seq ar_draft ar_due_date
                                        ar_dy_code ar_effdate ar_entity
                                        ar_expt_date ar_exru_seq ar_ex_rate
                                        ar_ex_rate2 ar_ex_ratetype
                                        ar_ldue_date ar_nbr ar_open
                                        ar_po ar_print ar_sub ar_type
                                        ar__qad01)
                                 where dft.ar_nbr = ard1.ard_ref
                                 no-lock:
                              end. /* FOR FIRST dft */

                              if available dft
                              then do:
                                 a1.ar_draft = true.
                                 leave.
                              end. /* IF AVAILABLE dft */
                           end. /* DO FOR dft */
                        end. /* FOR EACH ard1 */

                        delete ard_det.
                        display
                           artotal with frame a.
                        clear frame b.
                        next loopb.
                     end. /* DO FOR a1 */

                     if (dft-ard-amt <> 0)
                     then do:
                        {gprun.i ""gpcurval.p"" "(input dft-ard-amt,
                                                  input rndmthd,
                                                  output retval)"}

                        if (retval <> 0)
                        then do:
                           next-prompt
                              dft-ard-amt
                              with frame b.
                           undo setb, retry.
                        end. /* IF (retval <> 0) */
                     end. /* IF (dft-ard-amt <> 0) */

                     if (dft-ard-disc <> 0)
                     then do:
                        /* CHANGED ard_disc TO dft-ard-disc */
                        {gprun.i ""gpcurval.p"" "(input dft-ard-disc,
                                                  input rndmthd,
                                                  output retval)"}
                        if (retval <> 0)
                        then do:
                           next-prompt
                              dft-ard-disc
                              with frame b.
                           undo setb, retry.
                        end. /* IF (retval <> 0) */
                     end. /* IF (dft-ard-disc <> 0) */

                     {&DMDMMT-P-TAG37}

                     if openamt < (dft-ard-amt + dft-ard-disc)
                     then do:
                        {&DMDMMT-P-TAG38}

                        /* AMOUNT IS GREATER THAN OPEN INVOICE AMOUNT */
                        {pxmsg.i &MSGNUM=3521 &ERRORLEVEL=3}
                        undo setb.
                     end. /* IF openamt < (dft-ard-amt + dft-ard-disc) */

                     artotal = artotal + dft-ard-amt.

                     if artotal > ar_amt
                     then do:
                        /* AMOUNT CANNOT EXCEED DRAFT AMOUNT */
                        {pxmsg.i &MSGNUM=3526 &ERRORLEVEL=3}
                        undo setb, retry.
                     end. /* IF artotal > ar_amt */

                     {&DMDMMT-P-TAG39}

                     amt = openamt - (dft-ard-amt + dft-ard-disc).

                     /* RECORD THE OPEN INVOICE AMOUNT ATTACHED */
                     /* TO UNAPPROVED DRAFTS                    */

                     do for a1:
                        find a1
                           where a1.ar_nbr = ard_nbr
                           exclusive-lock.

                        /* CONVERT THE DRAFT AMOUNTS TO DOC AMTS */
                        assign
                           ard_amt  =  dft-ard-amt
                           ard_disc =  dft-ard-disc.

                        run convert_amt_from_draft_to_doc
                           (input        a1.ar_curr,
                            input        a1.ar_ex_rate,
                            input        a1.ar_ex_rate2,
                            input-output ard_amt).

                        run convert_amt_from_draft_to_doc
                           (input        a1.ar_curr,
                            input        a1.ar_ex_rate,
                            input        a1.ar_ex_rate2,
                            input-output ard_disc).

                        ar__qad01 = string(decimal(ar__qad01) + ard_amt
                                  + ard_disc).
                     end. /* DO FOR a1 */

                    {&DMDMMT-P-TAG40}

                     display
                        artotal
                        with frame a.

                     display
                        amt
                        dft-ard-amt
                        dft-ard-disc.
                     down 1.

                     /* If AMT DUE IS 0 MAKE SURE CONVERTED AMT IS 0 */
                     if amt = 0
                     and (docamt - (ard_amt + ard_disc)) <> 0
                     then do:
                        if ard_amt <> 0
                        then
                           ard_amt = ard_amt +
                                     (docamt - (ard_amt + ard_disc)).
                        else
                           if ard_disc <> 0
                           then
                              ard_disc = ard_disc +(docamt -
                                         (ard_amt + ard_disc)).
                     end. /* IF amt = 0 AND... */
                  end.  /* SETB */
               end.  /* LOOPB */

               if artotal <> ar_amt
               then do:
                  /* INVOICES TOTAL DOES NOT EQUAL DRAFT AMOUNT */
                  {pxmsg.i &MSGNUM=3513 &ERRORLEVEL=2}
                  pause.
               end.  /* IF artotal <> ar_amt */

               leave checkloop.
            end. /* CHECKLOOP */

            {&DMDMMT-P-TAG41}
         end. /* ELSE DO - NOT AR_DRAFT */

         hide frame b.
      end.  /* IF AR_OPEN */

   end.  /* DO TRANSACTION */
end.  /* REPEAT - MAINLOOP */

{&DMDMMT-P-TAG42}

PROCEDURE delete_rate_usage_records:
   /* BEING CALLED UPON CTRL-D (DELETE) AND WHEN NO LINE DETAIL ENTERED */
   /* DELETE ANY EXCHANGE RATE USAGE (exru_usage) RECORDS               */
   if ar_mstr.ar_exru_seq <> 0
   then do:
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
     "(input ar_mstr.ar_exru_seq)"}
   end. /* IF ar_mstr.ar_exru_seq <> 0 */

   if ar_mstr.ar_dd_exru_seq <> 0
   then do:
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
     "(input ar_mstr.ar_dd_exru_seq)"}
   end. /* IF ar_mstr.ar_dd_exru_seq <> 0 */

END PROCEDURE. /* delete_rate_usage_records */

/* DEFINITION FOR procedure is_euro_transparent */
{gpacctet.i}

PROCEDURE convert_amt_from_doc_to_draft:
   define input        parameter doc-curr       like ar_mstr.ar_curr no-undo.
   define input        parameter doc-ex-rate    like ar_mstr.ar_ex_rate
                                     no-undo.
   define input        parameter doc-ex-rate2   like ar_mstr.ar_ex_rate2
                                     no-undo.
   define input-output parameter amt-to-convert like ar_mstr.ar_amt  no-undo.

   /* CONVERT FOREIGN CURRENCY AMT OF INVOICE TO BASE CURRENCY */
   if doc-curr <> base_curr
   then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv" "(input  doc-curr,
                                            input  base_curr,
                                            input  doc-ex-rate,
                                            input  doc-ex-rate2,
                                            input  amt-to-convert,
                                            input  false, /* DO NOT ROUND */
                                            output amt-to-convert,
                                            output mc-error-number)"}.
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end. /* IF mc-error-number <> 0 */
   end. /* IF doc-curr <> base_curr */

   /* CONVERT BASE CURRENCY AMT TO CURRENCY OF THE DRAFT */
   if ar_mstr.ar_curr <> base_curr
   then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv" "(input  base_curr,
                                            input  ar_mstr.ar_curr,
                                            input  ar_mstr.ar_ex_rate2,
                                            input  ar_mstr.ar_ex_rate,
                                            input  amt-to-convert,
                                            input  false, /* DO NOT ROUND */
                                            output amt-to-convert,
                                            output mc-error-number)"}.
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end. /* IF mc-error-number <> 0 */
   end. /* IF ar_mstr.ar_curr <> base_curr */

   /* USE DRAFT ROUNDING METHOD, NOT */
   /* ROUNDING METHOD OF APPLY-TO MEMO/INV. */
   {gprunp.i "mcpl" "p" "mc-curr-rnd" "(input-output amt-to-convert,
                                        input        rndmthd,
                                        output       mc-error-number)"}

   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   end. /* IF mc-error-number <> 0 */

END PROCEDURE. /* convert_amt_from_doc_to_draft */

PROCEDURE convert_amt_from_draft_to_doc:
   define input        parameter doc-curr       like ar_mstr.ar_curr no-undo.
   define input        parameter doc-ex-rate    like ar_mstr.ar_ex_rate
                                     no-undo.
   define input        parameter doc-ex-rate2   like ar_mstr.ar_ex_rate2
                                     no-undo.
   define input-output parameter amt-to-convert like ar_mstr.ar_amt  no-undo.

   /* CONVERT FOREIGN CURRENCY AMT OF DRAFT TO BASE CURRENCY */
   if ar_mstr.ar_curr <> base_curr
   then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv" "(input  doc-curr,
                                            input  base_curr,
                                            input  ar_mstr.ar_ex_rate,
                                            input  ar_mstr.ar_ex_rate2,
                                            input  amt-to-convert,
                                            input  false, /* DO NOT ROUND */
                                            output amt-to-convert,
                                            output mc-error-number)"}.

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end. /* IF mc-error-number <> 0 */
   end. /* IF ar_mstr.ar_curr <> base_curr */

   /* CONVERT BASE CURRENCY AMT TO CURRENCY OF THE DRAFT */
   if doc-curr <> base_curr
   then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv" "(input  base_curr,
                                            input  doc-curr,
                                            input  doc-ex-rate2,
                                            input  doc-ex-rate,
                                            input  amt-to-convert,
                                            input  true,
                                            output amt-to-convert,
                                            output mc-error-number)"}.

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
      end. /* IF mc-error-number <> 0 */
   end. /* IF doc-curr <> base_curr */

END PROCEDURE. /* convert_amt_from_draft_to_doc */

PROCEDURE set-ar-amt-fmt:
   ar_amt_fmt = ar_amt_old.

   {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                             input        rndmthd)"}

   assign
      artotal:format      in frame a  = ar_amt_fmt
      ar_amt:format       in frame a  = ar_amt_fmt
      amt:format          in frame b  = ar_amt_fmt
      dft-ard-amt:format  in frame b  = ar_amt_fmt
      dft-ard-disc:format in frame b  = ar_amt_fmt
      oldcurr                         = ar_mstr.ar_curr.

END PROCEDURE. /* set-ar-amt-fmt */

PROCEDURE get-arstatus:
   define input  parameter p-arnbr like ar_mstr.ar_nbr            no-undo.
   define input  parameter p-draft like ar_mstr.ar_draft          no-undo.
   define input  parameter p-open  like ar_mstr.ar_open           no-undo.
   define output parameter p-arstatus as character format "x(10)" no-undo.

   p-arstatus = "".

   if p-draft and p-open
   then do:
      p-arstatus = getTermLabel("APPROVED",10).

      for first ard_det
         fields(ard_acct ard_amt ard_cc ard_desc ard_disc
            ard_dy_code ard_dy_num ard_entity ard_nbr
                ard_ref ard_sub ard_type)
         where ard_ref = p-arnbr
         and   ard_type begins "C"
         no-lock:
      end. /* FOR FIRST ard_det */

      if available ard_det
      then
         p-arstatus = getTermLabel("DISCOUNTED",10).
   end. /* IF p-draft and p-open */
   else
   if p-draft
   and not p-open
   then
      p-arstatus = getTermLabel("CLOSED",10).
   else
   if  not p-draft
   and not p-open
   then
      p-arstatus = getTermLabel("VOID",10).
   else
   if  not p-draft
   and p-open
   then
      p-arstatus = getTermLabel("PROPOSED",10).
END PROCEDURE. /* get-arstatus */

PROCEDURE delete-record:

   define buffer a2   for ar_mstr.
   define buffer dft2 for ar_mstr.

   for each ard_det exclusive-lock
      where ard_ref = ar_mstr.ar_nbr
      and (ard_type = "I"
      or   ard_type = "F"
      or   ard_type = "M"):

      find a2
         where a2.ar_nbr = ard_nbr
      exclusive-lock.

      if ar_mstr.ar_nbr = a2.ar_check
      then
         a2.ar_check = "".

      /* REDUCE THE OPEN INVOICE AMOUNT ATTACHED */
      /* TO UNAPPROVED DRAFTS                    */
      tmpamt = (ard_amt + ard_disc).
      if a2.ar_curr <> ar_mstr.ar_curr
      then
         run convert_amt_from_doc_to_draft (input        a2.ar_curr,
                                            input        a2.ar_ex_rate,
                                            input        a2.ar_ex_rate2,
                                            input-output tmpamt).
      ar__qad01   = string(decimal(ar__qad01) - tmpamt).
      a2.ar_draft = false.

      for each ard1
         fields(ard_acct ard_amt ard_cc ard_desc ard_disc
                ard_dy_code ard_dy_num ard_entity ard_nbr
                ard_ref ard_sub ard_type)
         where ard1.ard_nbr  = a2.ar_nbr
         and   ard1.ard_ref  = ar_mstr.ar_nbr
         and   ard1.ard_type = a2.ar_type
         no-lock:

         for first dft2
            fields(ar_acct ar_amt ar_applied
                   ar_bank ar_base_amt ar_bill ar_cc
                   ar_check ar_curr ar_cust ar_date
                   ar_dd_exru_seq ar_draft ar_due_date
                   ar_dy_code ar_effdate ar_entity
                   ar_expt_date ar_exru_seq ar_ex_rate
                   ar_ex_rate2 ar_ex_ratetype
                   ar_ldue_date ar_nbr ar_open
                   ar_po ar_print ar_sub ar_type
                   ar__qad01)
            where dft2.ar_nbr = ard1.ard_ref
            no-lock:
         end. /* FOR FIRST dft2 */

         if available dft2
         then do:
            a2.ar_draft = true.
            leave.
         end. /* IF AVAILABLE dft2 */
      end. /* FOR EACH ard1 */

      delete ard_det.

   end. /* FOR EACH ard_det */

   /* DEL EXCHANGE RATE USAGE */
   run delete_rate_usage_records.

   delete ar_mstr.  /* DELETE DRAFT AR_MSTR */

END PROCEDURE. /* delete-record */
