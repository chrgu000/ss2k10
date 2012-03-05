/* arcsiq.p - ACCOUNTS RECEIVABLE CUSTOMER INQUIRY                         */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.25.1.12 $                                                  */
/*V8:ConvertMode=Report                                                    */
/* REVISION: 1.0      LAST MODIFIED: 06/19/86   BY: PML                    */
/*           2.0                     12/16/87       pml                    */
/* REVISION: 4.0      LAST EDIT:     12/30/87   BY: WUG *A137*             */
/* REVISION: 4.0      LAST MODIFIED: 08/02/88   BY: RL  *C0028*            */
/* REVISION: 4.0      LAST MODIFIED: 12/06/88   BY: JLC *C0028.1*          */
/* REVISION: 5.0      LAST EDIT:     05/03/89   BY: WUG *B098*             */
/* REVISION: 5.0      LAST MODIFIED: 09/11/89   BY: MLB *B267*             */
/* REVISION: 6.0      LAST MODIFIED: 09/20/90   BY: afs *D059*             */
/* REVISION: 6.0      LAST MODIFIED: 10/10/90   BY: MLB *D084*             */
/* REVISION: 7.0      LAST MODIFIED: 02/28/92   by: jms *F239*             */
/*                                   05/13/92   by: jms *F484*             */
/*                                   07/01/92   by: jms *F722*             */
/* REVISION: 7.3      LAST MODIFIED: 10/05/92   by: jms *G121*             */
/* REVISION: 7.3      LAST MODIFIED: 11/13/92   by: jms *G317*             */
/*                                   11/18/92   by: jjs *G334*             */
/* Revision: 7.3          Last edit: 11/19/92   By: jcd *G339*             */
/*                                   11/12/94   by: srk *FR94*             */
/* REVISION: 8.5      LAST MODIFIED: 12/08/95   by: taf *J053*             */
/* REVISION: GE       LAST MODIFIED: 04/09/96   by: jzw *G1SC*             */
/* REVISION: 8.5      LAST MODIFIED: 07/18/96   BY: *J0ZQ* Robert Wachowicz*/
/* REVISION: 8.5      LAST MODIFIED: 05/27/97   BY: *J1S2* Samir Bavkar    */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: ckm *K15M*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 03/09/98   BY: *J2FN* Samir Bavkar    */
/* REVISION: 8.6E     LAST MODIFIED: 04/21/98   BY: *H1JY* A. Licha        */
/* REVISION: 8.6E     LAST MODIFIED: 04/28/98   BY: *L00K* D. Sidel        */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *J2PN* Dana Tunstall   */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L02Q* Brenda Milton   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 10/13/99   BY: *L0K4* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *L06T*                    */
/* Revision: 1.25.1.6     BY: Rajesh Kini        DATE: 10/04/01  ECO: *N13G*  */
/* Revision: 1.25.1.7     BY: Hareesh V.         DATE: 06/21/02  ECO: *N1HY*  */
/* Revision: 1.25.1.8     BY: Vinod Nair         DATE: 11/14/02  ECO: *N1Z2*  */
/* Revision: 1.25.1.10    BY: Paul Donnelly (SB) DATE: 06/26/03  ECO: *Q00B*  */
/* Revision: 1.25.1.11    BY: Anitha Gopal       DATE: 05/21/04  ECO: *P229*  */
/* $Revision: 1.25.1.12 $    BY: Max Iles         DATE: 02/14/05  ECO: *P36M*  */
/* $Revision: 1.25.1.12 $    BY: Bill Jiang         DATE: 03/23/07  ECO: *SS - 20070323.1*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20070323.1 - B */
/*                                                                     
{mfdtitle.i "1+ "}
*/
{a6mfdtitle.i "1+ "}

{a6arcsiq01.i}

define input parameter i_entity		like en_entity.
define input parameter i_entity1	like en_entity.
define input parameter i_cust	    like ap_vend.
define input parameter i_cust1		like ap_vend.
define input parameter i_acct		like glt_acct.
define input parameter i_acct1		like glt_acct.
define input parameter i_sub		like glt_sub.
define input parameter i_sub1		like glt_sub.
define input parameter i_cc	        LIKE glt_cc.
define input parameter i_cc1		like glt_cc.
define input parameter i_effdate	like tr_effdate.
define input parameter i_effdate1	like tr_effdate.
define input parameter i_rpt_curr	like ap_curr.
DEFINE INPUT PARAMETER i_et_report_curr LIKE ar_curr .

define variable entity		like en_entity.
define variable entity1		like en_entity.
define variable cust1	    like ap_vend.
define variable acct		like glt_acct.
define variable acct1		like glt_acct.
define variable sub		like glt_sub.
define variable sub1		like glt_sub.
define variable cc		like	glt_cc.
define variable cc1		like glt_cc.
define variable effdate		like tr_effdate.
define variable effdate1	like tr_effdate.
/* SS - 20070323.1 - E */

/* DISPLAY TITLE */

define            variable cust            like ar_bill.
define            variable amt_open        like ar_amt
   label "Amount Open".
/* SS - 20070323.1 - B */
/*
define            variable open_only       like mfc_logical
   label "Open Only".
*/
define            variable open_only       like mfc_logical
   label "Open Only" INIT NO.
/* SS - 20070323.1 - E */
define            variable base_amt        like ar_amt.
define            variable base_applied    like ar_applied.
define            variable disp_curr       as character
   format "x(1)" label "C".
define            variable rpt_curr        like ar_curr.
define            variable curr_tot        like ar_amt.
define            variable days_open       as integer
   format "->>>" label "Days" no-undo.
define            variable base_rate       like exr_rate       no-undo.
define            variable rpt_rate        like exr_rate       no-undo.
define            variable et_ar_applied   like ar_applied.
define            variable et_ar_amt       like ar_amt.
define            variable et_cm_balance   like cm_balance.
define            variable et_curr_tot     like ar_amt.
define            variable et_base_amt     like ar_amt.
define            variable et_base_applied like ar_applied.
define            variable l_rpt_flag      like mfc_logical no-undo.

define buffer armstr for ar_mstr.

{etvar.i   &new = "new"}
{etrpvar.i &new = "new"}
{eteuro.i}

define temp-table t_armstr no-undo
   field t_ar_check   like ar_check
   field t_ar_effdate like ar_effdate.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
rpt_curr = "".

form
   cust                   /*V8! colon 9 */
   open_only              /*V8! colon 30 */
   rpt_curr               /*V8! colon 44 */
   space(2)
   cm_balance             /*V8! colon 60 */
   cm_sort format "x(20)" /*V8-*/ no-label /*V8+*/
   /*V8! colon 9 */
   et_report_curr         /*V8-*/ colon 42 /*V8+*/
   /*V8! colon 44 */
with frame a
   side-labels no-underline no-attr-space width 80.

/* SS - 20070323.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
entity = i_entity		 .
entity1 = i_entity1	 .
cust = i_cust	       .
cust1 = i_cust1		.
acct = i_acct		.
acct1 = i_acct1		.
sub = i_sub		.
sub1 = i_sub1		 .
cc = i_cc	       .
cc1 = i_cc1		.
effdate = i_effdate	.
effdate1 = i_effdate1	.
rpt_curr = i_rpt_curr	.
et_report_curr = i_et_report_curr.
/* SS - 20070323.1 - E */

{wbrp01.i}

/* SS - 20070323.1 - B */
/*
repeat:
*/
/* SS - 20070323.1 - E */

   /* SS - 20070323.1 - B */
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = today.
   if entity1   = hi_char then entity1 = "".
   if cust1   = hi_char then cust1 = "".
   if acct1   = hi_char then acct1 = "".
   if sub1   = hi_char then sub1 = "".
   if cc1   = hi_char then cc1 = "".
   /* SS - 20070323.1 - E */

   if l_rpt_flag
      then
   assign
      rpt_curr   = ""
      l_rpt_flag = false.

   /* SS - 20070323.1 - B */
   /*
   if c-application-mode <> 'web'
      then
   update
      cust
      open_only
      rpt_curr
      et_report_curr
   with frame a
      editing:

      if frame-field = "cust"
         then do for ar_mstr:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i ar_mstr cust  " ar_mstr.ar_domain = global_domain and ar_bill
                 "  cust ar_bill ar_bill}
            if recno <> ?
            then do:
               cust = ar_bill.
               find cm_mstr
                  where cm_mstr.cm_domain = global_domain and  cm_addr = cust
               no-lock.
               display
                  cust
                  cm_sort
                  cm_balance
               with frame a.
               recno = ?.
            end. /* IF recno <> ? */
         end. /* IF frame-field = "cust" ... */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO */
      end.  /* UPDATE WITH FRAME A EDITING */

      {wbrp06.i
         &command = update
         &fields  = "cust
           open_only
           rpt_curr
           et_report_curr"
         &frm     = "a"}
   */
   /* SS - 20070323.1 - E */

      if (c-application-mode <> 'web') or
         (c-application-mode = 'web'   and
         (c-web-request begins 'data'))
      then do:

         /* SS - 20070323.1 - B */
         /*
         status input "".
         display
            "" @ cm_sort
         with frame a.

         et_eff_date = today.
         */
         /* SS - 20070323.1 - E */

         if rpt_curr = ""
            then
         assign
            l_rpt_flag = true
            rpt_curr   = base_curr.

         if et_report_curr <> ""
         then do:
            {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
               "(input et_report_curr,
                 output mc-error-number)"}

            if mc-error-number    =  0
               and et_report_curr <> rpt_curr
            then do:
               {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                  "(input rpt_curr,
                    input et_report_curr,
                    input "" "",
                    input et_eff_date,
                    output et_rate1,
                    output et_rate2,
                    output mc-error-number)"}
            end.  /* IF mc-error-number = 0 */

            /* NEED TO SEE IF THERE IS A VALID EXCHANGE */
            /* RATE BETWEEN THE BASE AND REPORTING      */
            /* CURRENCIES IN ORDER TO CONVERT THE       */
            /* CUSTOMER BALANCE                         */

            if mc-error-number    =  0
               and et_report_curr <> base_curr
               and et_report_curr <> rpt_curr
            then do:
               {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                  "(input base_curr,
                    input et_report_curr,
                    input "" "",
                    input et_eff_date,
                    output base_rate,
                    output rpt_rate,
                    output mc-error-number)"}
            end.  /* IF mc-error-number = 0 */

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               if c-application-mode = 'web'
                  then
                  return.
               else
                  next-prompt et_report_curr with frame a.
               undo, retry.
            end.  /* IF mc-error-number <> 0 */

         end.  /* IF et_report_curr <> "" */

         if et_report_curr = ""
            then
            et_report_curr = rpt_curr.

         find cm_mstr
            where cm_mstr.cm_domain = global_domain and  cm_addr = cust
         no-lock no-error.

         if available cm_mstr
         then do:

            /* SS - 20070323.1 - B */
            /*
            display cm_sort
            with frame a.
            */
            /* SS - 20070323.1 - E */

            if rpt_curr = base_curr
               and et_report_curr = base_curr
               then
            /* SS - 20070323.1 - B */
            /*
            display cm_balance
            with frame a.
            */
            .
            /* SS - 20070323.1 - E */

            else do:   /* rpt_curr <> base_curr */
               et_curr_tot = 0.

               for each ar_mstr
                     where ar_mstr.ar_domain = global_domain and (  ar_bill = cust
                     and   ar_open = yes
                     and   (ar_curr = rpt_curr
                     or l_rpt_flag = true)
                     ) no-lock use-index ar_bill_open:
                  {mfrpchk.i}
                  if ar_type = "D"
                     and not ar_draft
                     then
                     next.

                  if et_report_curr <> ar_curr
                  then do:
                     assign
                        et_ar_amt     = ar_base_amt
                        et_ar_applied = ar_base_applied.

                     /* CONVERT THE BASE AMOUNT AND APPLIED TO */
                     /* THE REPORTING CURRENCY TO DISPLAY AS   */
                     /* THE CM_BALANCE */

                     if et_report_curr <> base_curr
                     then do:
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input base_curr,
                             input et_report_curr,
                             input base_rate,
                             input rpt_rate,
                             input et_ar_amt,
                             input true,  /* ROUND */
                             output et_ar_amt,
                             output mc-error-number)"}

                        if mc-error-number <> 0
                        then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                        end. /* IF mc-error-number <> 0 */

                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input base_curr,
                             input et_report_curr,
                             input base_rate,
                             input rpt_rate,
                             input et_ar_applied,
                             input true,  /* ROUND */
                             output et_ar_applied,
                             output mc-error-number)"}

                        if mc-error-number <> 0
                        then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                        end. /* IF mc-error-number <> 0 */

                     end.  /* IF et_report_curr <> base_curr */
                  end.  /* IF et_report_curr <> ar_curr */

                  else
                  assign
                     et_ar_amt     = ar_amt
                     et_ar_applied = ar_applied.

                  et_curr_tot = et_curr_tot +
                  (et_ar_amt - et_ar_applied).

               end.  /* FOR EACH ar_mstr */

               /* SS - 20070323.1 - B */
               /*
               display
                  et_curr_tot @ cm_balance
               with frame a.
               */
               /* SS - 20070323.1 - E */

            end.  /* ELSE DO */
         end.  /* IF AVAILABLE cm_mstr */

         hide frame b.

         /* SS - 20070323.1 - B */
         {mfquoter.i effdate           }
         {mfquoter.i effdate1          }
         {mfquoter.i entity           }
         {mfquoter.i entity1          }
         {mfquoter.i cust           }
         {mfquoter.i cust1          }
         {mfquoter.i acct           }
         {mfquoter.i acct1          }
         {mfquoter.i sub           }
         {mfquoter.i sub1          }
         {mfquoter.i cc           }
         {mfquoter.i cc1          }
         {mfquoter.i rpt_curr           }
         {mfquoter.i et_report_curr          }

         if effdate = ? then effdate = low_date.
         if effdate1 = ? then effdate1 = today.
         if entity1 = "" then entity1 = hi_char.
         if cust1 = "" then cust1 = hi_char.
         if acct1 = "" then acct1 = hi_char.
         if sub1 = "" then sub1 = hi_char.
         if cc1 = "" then cc1 = hi_char.
         /* SS - 20070323.1 - E */
      end.  /* IF (c-application-mode <> 'web') ... */

      /* SS - 20070323.1 - B */
      /*
      /* OUTPUT DESTINATION SELECTION */
      {gpselout.i &printType                = "terminal"
         &printWidth               = 80
         &pagedFlag                = " "
         &stream                   = " "
         &appendToFile             = " "
         &streamedOutputToTerminal = " "
         &withBatchOption          = "no"
         &displayStatementType     = 1
         &withCancelMessage        = "yes"
         &pageBottomMargin         = 6
         &withEmail                = "yes"
         &withWinprint             = "yes"
         &defineVariables          = "yes"}
      */
      define variable l_textfile        as character no-undo.
      /* SS - 20070323.1 - E */

      for each ar_mstr
         where ar_mstr.ar_domain = global_domain and (  
            /* SS - 20070323.1 - B */
            /*
            ar_bill = cust
            */
            ar_bill >= cust AND ar_bill <= cust1
            /* SS - 20070323.1 - E */
            and  (ar_curr = rpt_curr or l_rpt_flag = true)
            ) 
         /* SS - 20070323.1 - B */
         AND ar_effdate >= effdate 
         AND ar_effdate <= effdate1 
         AND ar_entity >= entity 
         AND ar_entity <= entity1 
         AND ar_acct >= acct 
         AND ar_acct <= acct1 
         AND ar_sub >= sub 
         AND ar_sub <= sub1 
         AND ar_cc >= cc 
         AND ar_cc <= cc1
         /* SS - 20070323.1 - E */
         no-lock use-index ar_bill
            by ar_bill descending
            by ar_date descending
         with frame b
            down
            width 80:

         /* SS - 20070323.1 - B */
         /*
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         */
         /* SS - 20070323.1 - E */
         {mfrpchk.i}

         if ar_type = "D"
            and not ar_draft
            then next.

         assign
            base_amt     = ar_amt
            base_applied = ar_applied
            disp_curr    = "".

         if rpt_curr = base_curr
            and base_curr <> ar_curr
         then do:
            assign
               base_amt     = ar_base_amt
               base_applied = ar_base_applied
               disp_curr    = getTermLabel("YES",1).

            if ar_curr <> et_report_curr
               and et_report_curr <> base_curr
            then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input et_report_curr,
                    input base_rate,
                    input rpt_rate,
                    input base_amt,
                    input true, /* ROUND */
                    output et_base_amt,
                    output mc-error-number)"}

               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end. /* IF mc-error-number <> 0 */

               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input et_report_curr,
                    input base_rate,
                    input rpt_rate,
                    input base_applied,
                    input true, /* ROUND */
                    output et_base_applied,
                    output mc-error-number)"}

               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end. /* IF mc-error-number <> 0 */

            end.  /* IF ar_curr <> et_report_curr ... */

            else
         if et_report_curr = base_curr
               then
            assign
               et_base_amt     = ar_base_amt
               et_base_applied = ar_base_applied.
            else
            assign
               et_base_amt     = ar_amt
               et_base_applied = ar_applied.

         end.  /* IF rpt_curr = base_curr AND base_curr <> ar_curr */

         /*DETERMINE CONVERTED AMOUNT*/

         else
      if et_report_curr <> rpt_curr
         then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input rpt_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input base_amt,
                 input true, /* ROUND */
                 output et_base_amt,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-error-number <> 0 */

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input rpt_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input base_applied,
                 input true, /* ROUND */
                 output et_base_applied,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-erro-number <> 0 */

         end.  /* IF et_report_curr <> rpt_curr */

         else
         assign
            et_base_amt = base_amt
            et_base_applied = base_applied.

         amt_open = et_base_amt - et_base_applied.

         if not open_only or amt_open <> 0
         then do:
            /* SS - 20070323.1 - B */
            /*
            display
               ar_date.

            if ar_type <> "P"
               then
            display
               ar_nbr label "Ref" format "X(8)"
               ar_type
               ar_due_date.
            else
            display
               ar_check @ ar_nbr
               ar_type
               "" @ ar_due_date.

            display
               disp_curr
               et_base_amt
               amt_open.
            */
            CREATE tta6arcsiq01.
            ASSIGN
               tta6arcsiq01_ar_date = ar_date
               .

            if ar_type <> "P" THEN DO:
               ASSIGN
                  tta6arcsiq01_ar_nbr = ar_nbr
                  tta6arcsiq01_ar_type = ar_type
                  tta6arcsiq01_ar_due_date = ar_due_date
                  .
            END.
            ELSE DO:
               ASSIGN
                  tta6arcsiq01_ar_nbr = ar_check
                  tta6arcsiq01_ar_type = ar_type
                  .
            END.

            ASSIGN
               tta6arcsiq01_disp_curr = DISP_curr
               tta6arcsiq01_et_base_amt = et_base_amt
               tta6arcsiq01_amt_open = amt_open
               .
            /* SS - 20070323.1 - E */

            if ar_type <> "P"
            then do:

               for each ard_det
                     fields( ard_domain ard_nbr ard_ref ard_type)
                     where ard_det.ard_domain = global_domain and (  ard_ref    =
                     ar_nbr
                     and ((ard_type   = "D" and ar_type = "D")
                     or ar_type <> "D")
                     ) no-lock:

                  for first armstr
                     fields( ar_domain ar_amt ar_applied ar_base_amt
                     ar_base_applied ar_bill ar_check ar_curr
                     ar_date ar_draft ar_due_date ar_effdate
                     ar_nbr ar_open ar_paid_date ar_type)
                     where armstr.ar_domain = global_domain and  armstr.ar_nbr =
                     ard_nbr
                  no-lock:
                  end. /* FOR FIRST armstr */
                  if available armstr
                  then do:
                     create t_armstr.
                     assign
                        t_ar_check     = if armstr.ar_type = "D"
                        then
                        armstr.ar_nbr
                        else
                        armstr.ar_check
                        t_ar_effdate   = armstr.ar_effdate.

                  end. /* IF AVAILABLE armstr */
                  /* SS - 20070323.1 - B */
                  /*
                  else
                     display "" @ armstr.ar_check.
                  */
                  ELSE DO:
                     ASSIGN
                        tta6arcsiq01_ar_check = ""
                        .
                  END.
                  /* SS - 20070323.1 - E */

               end. /* FOR EACH ard_det */

               for each t_armstr
                  no-lock
                     break by t_ar_effdate:

                  if last(t_ar_effdate)
                     then
                  /* SS - 20070323.1 - B */
                  /*
                  display
                     t_ar_check @ armstr.ar_check with frame b.
                  */
                  ASSIGN
                     tta6arcsiq01_ar_check = t_ar_check
                     .
                  /* SS - 20070323.1 - E */

               end. /* FOR EACH t_armstr */

               for each t_armstr
                  exclusive-lock:
                  delete t_armstr.
               end. /* FOR EACH t_armstr */

               days_open = ar_mstr.ar_paid_date - ar_mstr.ar_date.

               /* SS - 20070323.1 - B */
               /*
               if days_open <> ?
                  then
               display
                  days_open.
               else
               display
                  "" @ days_open.
               */
               if days_open <> ? THEN DO:
                  ASSIGN
                     tta6arcsiq01_days_open = days_open
                     .
               END.
               ELSE DO:
                  ASSIGN
                     tta6arcsiq01_days_open = 0
                     .
               END.
               /* SS - 20070323.1 - E */

            end. /* IF ar_type <> "P" */

            /* SS - 20070323.1 - B */
            /*
            else
            display
               "" @ armstr.ar_check
               "" @ days_open.

            if not scrollonly and
               not spooler then do:
               {gpwait.i &INSIDELOOP=yes &FRAMENAME=b}
            end.
            */
            ELSE DO:
               ASSIGN
                  tta6arcsiq01_ar_check = ""
                  tta6arcsiq01_days_open = 0
                  .
            END.

            ASSIGN
               tta6arcsiq01_ar_entity = ar_entity
               tta6arcsiq01_ar_bill = ar_bill
               tta6arcsiq01_ar_batch = ar_batch
               tta6arcsiq01_ar_effdate = ar_effdate
               tta6arcsiq01_ar_po = ar_po
               tta6arcsiq01_ar_curr = ar_curr
               tta6arcsiq01_ar_acct = ar_acct
               tta6arcsiq01_ar_sub = ar_sub
               tta6arcsiq01_ar_cc = ar_cc
               tta6arcsiq01_ar_amt = ar_amt
               tta6arcsiq01_ar_ex_rate = ar_ex_rate
               tta6arcsiq01_ar_ex_rate2 = ar_ex_rate2
               .
            /* SS - 20070323.1 - E */

         end.  /* IF NOT OPEN_ONLY */

      end. /* FOR EACH ar_mstr */

      /* SS - 20070323.1 - B */
      /*
      if not scrollonly and
         not spooler then do:
         {gpwait.i &OUTSIDELOOP=yes}
      end.
      {mfreset.i}

      {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
   end. /* REPEAT */
      */
      /* SS - 20070323.1 - E */

   {wbrp04.i &frame-spec = a}
