/* soivrp.p - PENDING INVOICE REGISTER                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.13.1.6 $                                                              */
/* REVISION: 6.0      LAST MODIFIED: 07/11/90   BY: WUG *D051*               */
/* REVISION: 6.0      LAST MODIFIED: 08/17/90   BY: MLB *D055*               */
/* REVISION: 5.0      LAST MODIFIED: 08/18/90   BY: MLB *B755*               */
/* REVISION: 6.0      LAST MODIFIED: 12/27/90   BY: MLB *D238*               */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*               */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*               */
/* REVISION: 6.0      LAST MODIFIED: 04/05/91   BY: bjb *D507*               */
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: MLV *D825*               */
/* REVISION: 6.0      LAST MODIFIED: 10/09/91   BY: dgh *D892*               */
/* REVISION: 7.0      LAST MODIFIED: 02/11/92   BY: tjs *F191*               */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   BY: tjs *F244*               */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: tjs *F247*               */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: TMD *F263*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 03/27/92   BY: tjs *F328*               */
/* REVISION: 7.0      LAST MODIFIED: 03/30/92   BY: tjs *F333*               */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*(rev only)     */
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458*               */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: afs *G047*               */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: tjs *G858*               */
/* REVISION: 7.3      LAST MODIFIED: 05/04/93   BY: tjs *GA65*               */
/* REVISION: 7.4      LAST MODIFIED: 06/16/93   BY: skk *H002*               */
/* REVISION: 7.4      LAST MODIFIED: 07/14/93   BY: jjs *H050*               */
/* REVISION: 7.4      LAST MODIFIED: 11/11/94   BY: afs *H593*               */
/* REVISION: 7.4      LAST MODIFIED: 12/28/94   BY: bcm *F0C0*               */
/* REVISION: 7.4      LAST MODIFIED: 03/09/95   BY: kjm *F0LC*               */
/* REVISION: 8.5      LAST MODIFIED: 09/01/95   BY: taf *J053*               */
/* REVISION: 8.6      LAST MODIFIED: 06/26/96   BY: bjl *K001*               */
/* REVISION: 8.6      LAST MODIFIED: 11/12/96   BY: *H0N9* Aruna Patil       */
/*                                   03/19/97   BY: *K082* E. Hughart        */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0LD*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 07/01/98   BY: *L024* Sami Kureishy     */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0JM* BalbeerS Rajput   */
/* REVISION: 9.1      LAST MODIFIED: 12/22/00   BY: *L16X* Seema Tyagi       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13.1.5   BY: Paul Donnelly        DATE: 02/08/02  ECO: *N16J*  */
/* $Revision: 1.13.1.6 $         BY: John Corda           DATE: 08/09/02  ECO: *N1QP*  */
/* $Revision: 1.13.1.6 $         BY: Bill Jiang           DATE: 06/02/026  ECO: *SS - 20060602.1*  */

/*V8:ConvertMode=FullGUIReport                                               */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060602.1 - B */
/*
1. 标准输入输出
2. 执行列表:
   a6soivrp0101.p
   a6soivrp0101a.p
   a6soivrp0101b.p,a6soivtrl20101.p
   a6soivtrlc0101.p
   a6soivtrl20101.i
   a6sototfrm0101.i
*/
/* SS - 20060602.1 - E */

/* THIS REPORT USES THE gltw_wkfl TO ACCUMULATE GL      */
/* TRANSACTIONS AND THEN DOES AN UNDO TO DELETE THEN    */

/* SS - 20060602.1 - B */               
define input parameter i_nbr like so_nbr.
define input parameter i_nbr1 like so_nbr.
define input parameter i_shipdate like so_ship_date.
define input parameter i_shipdate1 like so_ship_date.
define input parameter i_cust  like so_cust.
define input parameter i_cust1 like so_cust.
define input parameter i_bill  like so_bill.
define input parameter i_bill1 like so_bill.
define input parameter i_inv_only like mfc_logical.
define input parameter i_print_lotserials like mfc_logical.
define input parameter i_conso like mfc_logical.
define input parameter i_print_ready2inv like mfc_logical.
define input parameter i_print_ready2post like mfc_logical.
/*
/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
*/
{a6mfdtitle.i "2+ "}
/* SS - 20060602.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivrp_p_1 "Consolidated Cr"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_3 "Include Ready To Post"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_4 "Consolidated Dr"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_5 "Debit Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_6 "Include Ready To Print Invoice"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_7 "Consolidate Invoices"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_8 "Credit Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_9 "Print Lot/Serial Numbers Shipped"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp_p_10 "Print Only Lines To Invoice"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

define new shared variable tot_base_amt like ar_amt.

define new shared variable tot_base_price as decimal
   format "->>>>,>>>,>>9.99".

define new shared variable tot_base_margin as decimal
   format "->>>>,>>>,>>9.99".
define new shared variable nbr like so_nbr.
define new shared variable nbr1 like so_nbr.
define new shared variable shipdate like so_ship_date.
define new shared variable shipdate1 like shipdate.
define new shared variable cust  like so_cust.
define new shared variable cust1 like so_cust.
define new shared variable bill  like so_bill.
define new shared variable bill1 like so_bill.
define new shared variable print_ready2inv like mfc_logical
   initial yes.
define new shared variable print_ready2post like mfc_logical
   initial no.
define new shared variable inv_only like mfc_logical initial yes.
define new shared variable print_lotserials like mfc_logical
   label {&soivrp_p_9}.

define variable dr_amt as decimal format "->>,>>>,>>>,>>9.99"
   label {&soivrp_p_5}.
define variable cr_amt as decimal format "->>,>>>,>>>,>>9.99"
   label {&soivrp_p_8}.
define variable runok_noundo like mfc_logical no-undo initial no.
define new shared variable conso like mfc_logical initial no
   label {&soivrp_p_7}.
define variable tot_price_fmt as character no-undo.
define variable tot_marg_fmt as character no-undo.
define variable tot_amt_fmt as character no-undo.
define variable gltwdr_fmt as character no-undo.
define variable gltwdr as decimal format "->>>>,>>>,>>9.99" no-undo.
define variable gltwcr_fmt as character no-undo.
define variable gltwcr as decimal format "->>>>,>>>,>>9.99" no-undo.
define variable rptstr as character format "x(19)" no-undo.

form
   nbr                  colon 15
   nbr1                 label {t001.i} colon 50 skip
   shipdate             colon 15
   shipdate1            label {t001.i} colon 50 skip
   cust           colon 15
   cust1          label {t001.i} colon 50 skip
   bill           colon 15
   bill1          label {t001.i} colon 50 skip(1)
   inv_only             colon 40 label {&soivrp_p_10}
   print_lotserials     colon 40
   conso                colon 40
   skip(1)
   print_ready2inv      colon 40 label {&soivrp_p_6}
   print_ready2post     colon 40 label {&soivrp_p_3}
with frame a side-labels width 80 attr-space.

/* SS - 20060602.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
/* SS - 20060602.1 - E */

/* DEFINE FRAME FOR DISPLAYING REPORT TOTALS IN BASE CURRENCY */
form
   rptstr to 61 format "x(19)"
   tot_base_amt    to 77

   tot_base_price  to 110

   tot_base_margin to 130
   skip(1)
with frame rpttot no-labels width 132 down.

/*DEFINE FRAME FOR DISPLAYING GL TOTALS */
form
   gltw_entity
   gltw_acct
   gltw_sub
   gltw_cc
   gltw_date
   gltwdr label {&soivrp_p_4}
   gltwcr label {&soivrp_p_1}
with frame gltwtot width 80 down.

/* SS - 20060602.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame gltwtot:handle).
*/
ASSIGN
   nbr = i_nbr
   nbr1 = i_nbr1
   shipdate = i_shipdate
   shipdate1 = i_shipdate1
   cust = i_cust
   cust1 = i_cust1
   bill = i_bill
   bill1 = i_bill1
   inv_only = i_inv_only
   print_lotserials = i_print_lotserials
   conso = i_conso
   print_ready2inv = i_print_ready2inv
   print_ready2post = i_print_ready2post
   .
/* SS - 20060602.1 - E */

find first gl_ctrl no-lock.
for each gltw_wkfl exclusive-lock where gltw_userid = mfguser:
   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
      "(input gltw_exru_seq)"}
   delete gltw_wkfl.
end.

/* SETUP THE FORMATS FOR THE TOTAL DISPLAYS.  BECAUSE THESE ARE IN */
/* BASE THEY ONLY NEED TO BE SET UP ONCE.  */
assign
   gltwdr_fmt = gltwdr:format
   gltwcr_fmt = gltwcr:format
   tot_amt_fmt = tot_base_amt:format
   tot_price_fmt = tot_base_price:format
   tot_marg_fmt = tot_base_margin:format.

/* SET CURRENCY FORMAT FOR TOT_BASE_AMT */
{gprun.i ""gpcurfmt.p"" "(input-output tot_amt_fmt,
     input gl_rnd_mthd)"}
/* SET CURRENCY FORMAT FOR TOT_BASE_PRICE */
{gprun.i ""gpcurfmt.p"" "(input-output tot_price_fmt,
     input gl_rnd_mthd)"}
/* SET CURRENCY FORMAT FOR TOT_BASE_MARGIN */
{gprun.i ""gpcurfmt.p"" "(input-output tot_marg_fmt,
     input gl_rnd_mthd)"}
/* SET CURRENCY FORMAT FOR GLTWDR */
{gprun.i ""gpcurfmt.p"" "(input-output gltwdr_fmt,
     input gl_rnd_mthd)"}
/* SET CURRENCY FORMAT FOR GLTWCR */
{gprun.i ""gpcurfmt.p"" "(input-output gltwcr_fmt,
     input gl_rnd_mthd)"}
assign
   tot_base_amt:format = tot_amt_fmt
   tot_base_price:format = tot_price_fmt
   tot_base_margin:format = tot_marg_fmt
   gltwdr:format = gltwdr_fmt
   gltwcr:format = gltwcr_fmt.

{wbrp01.i}

/* SS - 20060602.1 - B */
/*
repeat:
*/
/* SS - 20060602.1 - E */

   if nbr1 = hi_char then nbr1 = "".
   if shipdate = low_date then shipdate = ?.
   if shipdate1 = hi_date then shipdate1 = ?.
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".

   /* SS - 20060602.1 - B */
   /*
   if c-application-mode <> 'web' then
   update nbr nbr1 shipdate shipdate1
      cust cust1 bill bill1
      inv_only print_lotserials
      conso
      print_ready2inv print_ready2post
   with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 shipdate shipdate1
        cust cust1 bill bill1 inv_only print_lotserials  conso  print_ready2inv
        print_ready2post" &frm = "a"}
   */
   /* SS - 20060602.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i nbr    }
      {mfquoter.i nbr1   }
      {mfquoter.i shipdate  }
      {mfquoter.i shipdate1 }
      {mfquoter.i cust   }
      {mfquoter.i cust1  }
      {mfquoter.i bill   }
      {mfquoter.i bill1  }
      {mfquoter.i inv_only}
      {mfquoter.i print_lotserials}
      {mfquoter.i conso}
      {mfquoter.i print_ready2inv}
      {mfquoter.i print_ready2post}

      if nbr1 = "" then nbr1 = hi_char.
      if shipdate = ? then shipdate = low_date.
      if shipdate1 = ? then shipdate1 = hi_date.
      if cust1 = "" then cust1 = hi_char.
      if bill1 = "" then bill1 = hi_char.

   end.

   /* SS - 20060602.1 - B */
   /*
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}


   {mfphead.i}
   */
   /* SS - 20060602.1 - E */

   tranloop:
   do transaction on endkey undo, leave:

      /* SS - 20060602.1 - B */
      /*
      /* Main Report Loop */
      {gprun.i  ""soivrpa.p""}
      */
      {gprun.i  ""a6soivrp0101a.p""}
      /* SS - 20060602.1 - E */

      /* SS - 20060602.1 - B */
      /*
      if keyfunction(lastkey) <> "end-error" then do:
         /* Report Totals */

         underline tot_base_amt tot_base_price tot_base_margin
         with frame rpttot.
         down 1 with frame rpttot.
         display

            base_curr + " " + getTermLabel("REPORT_TOTALS",14) + ":" @ rptstr
            tot_base_amt
            tot_base_price
            tot_base_margin
         with frame rpttot.

         /* Print GL Recap */
         page.

         for each gltw_wkfl exclusive-lock
         where gltw_userid = mfguser
         break by gltw_userid
         by gltw_entity
         by gltw_acct
         by gltw_sub
         by gltw_cc
         with frame gltwtot:

            cr_amt = 0.
            dr_amt = 0.
            if gltw_amt < 0 then cr_amt = - gltw_amt.
            else dr_amt = gltw_amt.
            accumulate (dr_amt) (total by gltw_cc).
            accumulate (cr_amt) (total by gltw_cc).

            {mfrpchk.i &loop="tranloop"}

            if last-of(gltw_cc) then do:

               display gltw_entity
                       gltw_acct
                       gltw_sub
                       gltw_cc
                       gltw_date with frame gltwtot.

               /** ADDED CODE TO INCLUDE THE CONDITION WHERE ACCUMULATED  **/
               /** DEBIT AND CREDIT AMOUNT IS NOT EQUAL TO ZERO           **/

               if     ((accum total by gltw_cc dr_amt) <> 0)
                  and ((accum total by gltw_cc cr_amt) <> 0)
               then do:
                  assign
                     gltwdr = accum total by gltw_cc dr_amt
                     gltwcr = accum total by gltw_cc cr_amt.
                  display gltwdr gltwcr with frame gltwtot.
               end. /* IF ((ACCUM TOTAL BY gltw_cc dr_amt) ... */
               else
                  if (accum total by gltw_cc dr_amt) <> 0 then
            do:
                  gltwdr = accum total by gltw_cc dr_amt.

                  display gltwdr "" @ gltwcr with frame gltwtot.

               end.
               else
                  if (accum total by gltw_cc cr_amt) <> 0 then
            do:
                  gltwcr = accum total by gltw_cc cr_amt.

                  display gltwcr "" @ gltwdr with frame gltwtot.

               end.
               down 1 with frame gltwtot.
            end.

            if last-of(gltw_userid) then do:
               underline gltwdr gltwcr with frame gltwtot.
               down 1 with frame gltwtot.
               display
                  accum total (dr_amt) @ gltwdr
                  accum total (cr_amt) @ gltwcr with frame gltwtot.

            end.

            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input gltw_exru_seq)"}

            delete gltw_wkfl.

         end. /* for each gltw_ */
      end. /* if not end-error */
      */
      /* SS - 20060602.1 - E */
      
   end.  /* TRANLOOP */

   /* SS - 20060602.1 - B */
   /*
   {mfrtrail.i}


end.
   */
   /* SS - 20060602.1 - E */

{wbrp04.i &frame-spec = a}
