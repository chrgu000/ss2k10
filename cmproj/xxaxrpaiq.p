/* arpaiq.p - AR PAYMENT INQUIRY                                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15.1.15 $                                                     */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 06/24/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*                */
/*                                   03/28/91   BY: afs *D464*                */
/*                                   04/02/91   BY: bjb *D507*                */
/*                                   06/11/91   BY: MLV *D687*                */
/*                                   03/04/92   BY: jms *F237*                */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F258*                */
/* REVISION: 7.3      LAST MODIFIED: 11/19/92   By: jcd *G339*                */
/*                                   04/23/93   BY: JMS *GA27*                */
/*                                   06/16/93   by: jms *GC38*                */
/*                                   08/18/94   by: pmf *FQ33*                */
/* REVISION: 8.5      LAST MODIFIED: 12/04/95   By: taf *J053*                */
/*                                   04/09/96   By: jzw *G1P6*                */
/*                                   05/28/96   By: jzw *G1WL*                */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   By: bvm *K0QH*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/21/98   BY: *H1JY* A. Licha           */
/* REVISION: 8.6E     LAST MODIFIED: 04/28/98   BY: *L00K* D. Sidel           */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01K* Jaydeep Parikh     */
/* REVISION: 8.6E     LAST MODIFIED: 08/24/98   BY: *H1LT* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 09/10/98   BY: *L092* Steve Goeke        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/19/00   BY: *N0CL* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 08/02/00   BY: *N0VV* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.15.1.11    BY: Jean Miller        DATE: 10/04/01  ECO: *N13L*  */
/* Revision: 1.15.1.12    BY: Hareesh V.        DATE: 06/21/02  ECO: *N1HY*  */
/* Revision: 1.15.1.13  BY: Narathip W. DATE: 05/19/03 ECO: *P0SH* */
/* $Revision: 1.15.1.15 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "ARPAIQ.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arpaiq_p_2 "Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpaiq_p_5 "Amt Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpaiq_p_6 "Open Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpaiq_p_7 "Exch Rate"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpaiq_p_13 "Sort Name"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{etvar.i   &new = "new"}
{etrpvar.i &new = "new"}

define variable cust          like ar_bill.
define variable nbr           like ar_nbr.
define variable amt_open      like ar_amt label {&arpaiq_p_5}.
define variable open_only     like mfc_logical label {&arpaiq_p_6}.
define variable type          like ar_type format "x(12)"
   column-label {&arpaiq_p_2}.
define variable check_nbr     like ar_check.
define variable base_amt      like ar_amt.
define variable base_applied  like ar_applied.
define variable base_damt     like ard_amt.
define variable base_disc     like ard_disc.
define variable base_rpt      like ar_curr.
define variable disp_curr     like ar_curr format "x(1)".
{&ARPAIQ-P-TAG20}

define variable ex_rate_relation1 as character format "x(40)" no-undo.
define variable ex_rate_relation2 as character format "x(40)" no-undo.

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/* DEFINITION OF SHARED VARS OF gprunpdf.i */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

{&ARPAIQ-P-TAG1}

form
   check_nbr
   cust
   open_only
   base_rpt
   cm_sort format "x(25)" /*V8-*/ no-label /*V8+*/
   /*V8! label {&arpaiq_p_13} */
with frame a width 80 no-underline.

{&ARPAIQ-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

{wbrp01.i}

repeat:

   {&ARPAIQ-P-TAG3}

   if c-application-mode <> 'web' then
      update check_nbr cust open_only base_rpt with frame a
   editing:

      {&ARPAIQ-P-TAG4}

      if frame-field = "check_nbr" then
      do for ar_mstr:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i ar_mstr check_nbr ar_check ar_type  " ar_mstr.ar_domain =
         global_domain and ""P"" "  ar_check }

         if recno <> ? then do:
            check_nbr = ar_check.
            find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr
            = ar_bill no-lock.
            display check_nbr cm_addr @ cust base_rpt cm_sort
            with frame a.
            {&ARPAIQ-P-TAG5}
            recno = ?.
         end.

      end.

      else do:
         status input.
         readkey.
         apply lastkey.
      end.

   end.

   {&ARPAIQ-P-TAG6}

   {wbrp06.i &command = update
      &fields = " check_nbr cust open_only base_rpt"
      &frm = "a"}

   {&ARPAIQ-P-TAG7}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      status input "".

      /* DISPLAY CUSTOMER NAME */
      display "" @ cm_sort with frame a.

      if check_nbr <> "" then
      do for ar_mstr:
         if cust <> "" then
            find ar_mstr  where ar_mstr.ar_domain = global_domain and  ar_check
            = check_nbr
                           and ar_bill  = cust
            no-lock no-error.
         if not available ar_mstr then
            find first ar_mstr  where ar_mstr.ar_domain = global_domain and
            ar_check = check_nbr and
                                     ar_bill = cust
            no-lock no-error.
         if available ar_mstr then do:
            find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr
            = ar_bill no-lock no-error.
            cust = cm_addr.
            display
               cust
               cm_sort
            with frame a.
         end.
      end.

      hide frame b.
      hide frame c.
      hide frame d.
      hide frame e.
      hide frame f.
      hide frame g.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   if check_nbr = "" and cust <> "" then
   repeat for ar_mstr:

      {&ARPAIQ-P-TAG8}

      find prev ar_mstr  where ar_mstr.ar_domain = global_domain and (
                ar_bill = cust and
              ((ar_curr = base_rpt) or (base_rpt = ""))
      ) no-lock use-index ar_bill.

      {&ARPAIQ-P-TAG9}

      assign
         disp_curr    = ""
         base_amt     = ar_amt
         base_applied = ar_applied.

      if base_rpt = "" and
         ar_curr <> base_curr
      then
         assign
            base_amt     = ar_base_amt
            base_applied = ar_base_applied
            disp_curr    = getTermLabel("YES",1).

      amt_open = base_amt - base_applied.

      if (not open_only or amt_open <> 0) and (index("P",ar_type) <> 0
         or ar_type = "A")
      then do:

         type = "".

         if ar_type = "A" then
            type = getTermLabel("APPLIED",10).
         if ar_type = "P" then
            type = getTermLabel("PAYMENT",10).

         {&ARPAIQ-P-TAG21}
         find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
         ar_bill no-lock.

         /*USE mc-ex-rate-output ROUTINE TO GET THE RATES FOR DISPLAY*/
         {gprunp.i "mcui" "p" "mc-ex-rate-output"
            "(input ar_mstr.ar_curr,
              input base_curr,
              input ar_mstr.ar_ex_rate,
              input ar_mstr.ar_ex_rate2,
              input ar_mstr.ar_exru_seq,
              output ex_rate_relation1,
              output ex_rate_relation2)"}.

         {&ARPAIQ-P-TAG10}

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         display
            ar_check          colon 11
            type              colon 35
            base_amt          colon 60
            ar_date           colon 11
            ar_entity         colon 35
            amt_open          colon 60
            ar_effdate        colon 11
            ar_acct           colon 35
            ar_sub                     no-label
            ar_cc                      no-label
            ar_bill           colon 11
            ar_disc_acct      colon 35
            ar_disc_sub                no-label
            ar_disc_cc                 no-label
            cm_sort           at 2     no-label format "x(27)"
            ar_po             colon 35
            ex_rate_relation1 colon 11 label {&arpaiq_p_7}
            ar_batch          colon 62
            ex_rate_relation2 at 13    no-label
            {&ARPAIQ-P-TAG22}
            ar_curr           colon 62
            disp_curr                  no-label
         with frame b side-labels width 80.

         {&ARPAIQ-P-TAG11}

         for each ard_det  where ard_det.ard_domain = global_domain and
         ard_nbr = ar_nbr no-lock
         with frame c width 80:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame c:handle).

            {mfrpchk.i}

            assign
               base_damt = ard_amt
               base_disc = ard_disc.

            if base_rpt = "" and ar_curr <> base_curr
            then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_curr,
                    input base_curr,
                    input ar_ex_rate,
                    input ar_ex_rate2,
                    input base_damt,
                    input true, /* ROUND */
                    output base_damt,
                    output mc-error-number)"}.

               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
               end.

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_curr,
                    input base_curr,
                    input ar_ex_rate,
                    input ar_ex_rate2,
                    input base_disc,
                    input true, /* ROUND */
                    output base_disc,
                    output mc-error-number)"}.

               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
               end.

            end.

            display
               (if ard_type = "N" or ard_type = "U"
                   then ard_tax /* N/U REFERENCE */
                   else ard_ref) @ ard_ref format "x(8)"
               ard_type    column-label {&arpaiq_p_2}
               base_damt
               base_disc
               ard_entity
               ard_acct
               ard_sub
               ard_cc.

         end.

      end.

   end. /* if check_nbr = "" and cust <> "" */

   else if check_nbr <> "" then
   repeat for ar_mstr:

      {&ARPAIQ-P-TAG12}

      find prev ar_mstr  where ar_mstr.ar_domain = global_domain and (
                ar_check = check_nbr and
               (ar_bill = cust or cust = "") and
              ((ar_curr = base_rpt) or (base_rpt = ""))
      ) no-lock.

      {&ARPAIQ-P-TAG13}

      assign
         disp_curr    = ""
         base_amt     = ar_amt
         base_applied = ar_applied.

      if base_rpt = "" and ar_curr <> base_curr
      then
         assign
            base_amt     = ar_base_amt
            base_applied = ar_base_applied
            disp_curr    = getTermLabel("YES",1).

      amt_open = base_amt - base_applied.

      if (not open_only or amt_open <> 0) and (index("P",ar_type) <> 0
         or ar_type = "A")
      then do:

         type = "".

         if ar_type = "A" then
            type = getTermLabel("APPLIED",12).
         if ar_type = "M" then
            type = getTermLabel("MEMO",12).
         else
         if ar_type = "F" then
            type = getTermLabel("FINANCE_CHARGE",12).
         else
         if ar_type = "I" then
            type = getTermLabel("INVOICE",12).
         else
         if ar_type = "D" then
            type = getTermLabel("DRAFT",12).
         else
         if ar_type = "P" then
            type = getTermLabel("PAYMENT",12).

         find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
         ar_bill no-lock.
         {&ARPAIQ-P-TAG23}

         {gprunp.i "mcui" "p" "mc-ex-rate-output"
            "(input ar_mstr.ar_curr,
              input base_curr,
              input ar_ex_rate,
              input ar_ex_rate2,
              input ar_exru_seq,
              output ex_rate_relation1,
              output ex_rate_relation2)"}.

         {&ARPAIQ-P-TAG14}

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame d:handle).

         display
            ar_check          colon 11
            type              colon 35
            base_amt          colon 60
            ar_date           colon 11
            ar_entity         colon 35
            amt_open          colon 60
            ar_effdate        colon 11
            ar_acct           colon 35
            ar_sub                     no-label
            ar_cc                      no-label
            ar_bill           colon 11
            ar_disc_acct      colon 35
            ar_disc_sub                no-label
            ar_disc_cc                 no-label
            cm_sort           at 2     no-label format "x(27)"
            ar_po             colon 35
            ex_rate_relation1 colon 11 label {&arpaiq_p_7}
            ar_batch          colon 62
            ex_rate_relation2 at 13    no-label
            {&ARPAIQ-P-TAG24}
            ar_curr           colon 62
            disp_curr                  no-label
         with frame d side-labels width 80.

         {&ARPAIQ-P-TAG15}

         if can-find (first ard_det  where ard_det.ard_domain = global_domain
         and  ard_nbr = ar_nbr) then
         for each ard_det  where ard_det.ard_domain = global_domain and
         ard_nbr = ar_nbr no-lock
         with frame e width 80:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame e:handle).

            {mfrpchk.i}

            assign
               base_damt = ard_amt
               base_disc = ard_disc.

            if base_rpt = "" and ar_curr <> base_curr
            then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_curr,
                    input base_curr,
                    input ar_ex_rate,
                    input ar_ex_rate2,
                    input base_damt,
                    input true, /* ROUND */
                    output base_damt,
                    output mc-error-number)"}.

               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
               end.

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_curr,
                    input base_curr,
                    input ar_ex_rate,
                    input ar_ex_rate2,
                    input base_disc,
                    input true, /* ROUND */
                    output base_disc,
                    output mc-error-number)"}.

               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
               end.

            end.

            display
               (if ard_type = "N" or ard_type = "U"
                   then ard_tax /* N/U REFERENCE */
                   else ard_ref) @ ard_ref format "x(8)"
               ard_type    column-label {&arpaiq_p_2}
               base_damt
               base_disc
               ard_entity
               ard_acct
               ard_sub
               ard_cc.

         end.

      end.

   end.

   else
   repeat for ar_mstr:

      {&ARPAIQ-P-TAG16}

      find prev ar_mstr  where ar_mstr.ar_domain = global_domain and (
         ar_curr = base_rpt or base_rpt = ""
      ) no-lock use-index ar_date.

      {&ARPAIQ-P-TAG17}

      assign
         disp_curr    = ""
         base_amt     = ar_amt
         base_applied = ar_applied.

      if base_rpt = "" and ar_curr <> base_curr
      then
         assign
            base_amt = ar_base_amt
            base_applied = ar_base_applied
            disp_curr = getTermLabel("YES",1).

      amt_open = base_amt - base_applied.

      if (not open_only or amt_open <> 0) and (index("P",ar_type) <> 0
         or ar_type = "A")
      then do:

         type = "".

         if ar_type = "A" then
            type = getTermLabel("APPLIED",12).
         if ar_type = "M" then
            type = getTermLabel("MEMO",12).
         else
         if ar_type = "F" then
            type = getTermLabel("FINANCE_CHARGE",12).
         else
         if ar_type = "I" then
            type = getTermLabel("INVOICE",12).
         else
         if ar_type = "D" then
            type = getTermLabel("DRAFT",12).
         else
         if ar_type = "P" then
            type = getTermLabel("PAYMENT",12).

         {&ARPAIQ-P-TAG25}
         find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
         ar_bill no-lock.

         {gprunp.i "mcui" "p" "mc-ex-rate-output"
            "(input ar_mstr.ar_curr,
              input base_curr,
              input ar_ex_rate,
              input ar_ex_rate2,
              input ar_exru_seq,
              output ex_rate_relation1,
              output ex_rate_relation2)"}

         {&ARPAIQ-P-TAG18}

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f:handle).

         display
            ar_check          colon 11
            type              colon 35
            base_amt          colon 60
            ar_date           colon 11
            ar_entity         colon 35
            amt_open          colon 60
            ar_effdate        colon 11
            ar_acct           colon 35
            ar_sub                     no-label
            ar_cc                      no-label
            ar_bill           colon 11
            ar_disc_acct      colon 35
            ar_disc_sub                no-label
            ar_disc_cc                 no-label
            cm_sort           at 2     no-label format "x(27)"
            ar_po             colon 35
            ex_rate_relation1 colon 11 label {&arpaiq_p_7}
            ar_batch          colon 62
            ex_rate_relation2 at 13    no-label
            {&ARPAIQ-P-TAG26}
            ar_curr           colon 62
            disp_curr                  no-label
         with frame f side-labels width 80.

         {&ARPAIQ-P-TAG19}

         for each ard_det  where ard_det.ard_domain = global_domain and
         ard_nbr = ar_nbr no-lock
         with frame g width 80:

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame g:handle).

            {mfrpchk.i}

            assign
               base_damt = ard_amt
               base_disc = ard_disc.

            if base_rpt = "" and ar_curr <> base_curr
            then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_curr,
                    input base_curr,
                    input ar_ex_rate,
                    input ar_ex_rate2,
                    input base_damt,
                    input true, /* ROUND */
                    output base_damt,
                    output mc-error-number)"}.

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_curr,
                    input base_curr,
                    input ar_ex_rate,
                    input ar_ex_rate2,
                    input base_disc,
                    input true, /* ROUND */
                    output base_disc,
                    output mc-error-number)"}.

               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
               end.

            end.

            display
               (if ard_type = "N" or ard_type = "U"
                  then ard_tax /* N/U REFERENCE */
                  else ard_ref) @ ard_ref format "x(8)"
               ard_type     column-label {&arpaiq_p_2}
               ard_tax   format "x(12)"
               base_damt
               base_disc
               ard_entity
               ard_acct
               ard_sub
               ard_cc.

         end.

      end.

   end.

   {mfreset.i}

   /* I=Invc M=Memo D=Draft F=Fin Chg P=Pmt A=Appl U=Unappl N=Non-AR */
   {pxmsg.i &MSGNUM=3288 &ERRORLEVEL=1}

   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
