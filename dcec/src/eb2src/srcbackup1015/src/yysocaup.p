/* GUI CONVERTED from socaup.p (converter v1.76) Wed Jan 23 23:00:12 2002 */
/* socaup.p SALES ORDER AUTO CREDIT APPROVAL UPDATE                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.17.1.7 $                                                              */
/*V8:ConvertMode=Report                                                      */
/* Revision: 5.0      LAST MODIFIED: 03/28/90   BY: ftb                      */
/* Revision: 6.0      LAST MODIFIED: 10/18/90   BY: pml *D106*               */
/* Revision: 6.0      LAST MODIFIED: 12/02/90   BY: afs *D236*               */
/* Revision: 6.0      LAST MODIFIED: 01/26/91   BY: pml *D319*               */
/* Revision: 6.0      LAST MODIFIED: 04/05/91   BY: bjb *D507*               */
/* Revision: 7.3      LAST MODIFIED: 09/03/92   BY: afs *G045*               */
/* Revision: 7.3      LAST MODIFIED: 12/01/92   BY: mpp *G484*               */
/* Revision: 7.3      LAST MODIFIED: 01/26/93   BY: tjs *G599*               */
/* Revision: 7.4      LAST MODIFIED: 10/01/93   BY: tjs *H070*               */
/* Revision: 7.4      LAST MODIFIED: 01/10/93   BY: tjs *H188*               */
/* Revision: 7.4      LAST MODIFIED: 02/01/94   BY: tjs *FL86*               */
/* Revision: 7.4      LAST MODIFIED: 06/15/94   BY: dpm *FO89*               */
/* Revision: 7.4      LAST MODIFIED: 06/21/94   BY: dpm *H396*               */
/* Revision: 7.4      LAST MODIFIED: 11/01/94   BY: bcm *H583*               */
/* Revision: 8.5      LAST MODIFIED: 07/21/95   BY: tjs *J04F*               */
/*                                   08/08/95   BY: srk *J06N*               */
/*                                   08/30/95   BY: kjm *G0VZ*               */
/*                                   10/25/95   by: jym *G0XY*               */
/* Revision: 7.3      LAST MODIFIED: 10/24/95   BY: rvw *G19Z*               */
/* Revision: 8.5      LAST MODIFIED: 07/27/95   BY: taf *J053*               */
/* Revision: 8.5      LAST MODIFIED: 05/28/96   BY: tzp *G1W8*               */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ*               */
/* Revision: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Stephane Collard  */
/* REVISION: 8.6      LAST MODIFIED: 04/23/97   BY: *J1LV* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 07/11/97   BY: *K0G6* Arul Victoria     */
/* REVISION: 8.6      LAST MODIFIED: 08/14/97   BY: *J1Z0* Ajit Deodhar      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel          */
/* REVISION: 8.6E     LAST MODIFIED: 05/06/98   BY: *J2D8* Kawal Batra       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *K1RZ* Ashok Swaminathan */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 09/27/99   BY: *L0J4* Satish Chavan     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *M0QW* Falguni Dalal     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* Revision: 1.17.1.5     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.17.1.6     BY: Ellen Borden    DATE: 07/09/01 ECO: *P007*  */
/* $Revision: 1.17.1.7 $           BY: Ashwini G.      DATE: 01/10/02  ECO: *L194* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE socaup_p_1 "Days"
/* MaxLen: Comment: */

&SCOPED-DEFINE socaup_p_2 "Include Sales Orders "
/* MaxLen: Comment: */

&SCOPED-DEFINE socaup_p_3 "Past Due"
/* MaxLen: Comment: */

&SCOPED-DEFINE socaup_p_4 "Credit Remaining"
/* MaxLen: Comment: */

&SCOPED-DEFINE socaup_p_5 "Open Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE socaup_p_6 "Check Credit Limit"
/* MaxLen: Comment: */

&SCOPED-DEFINE socaup_p_7 "Check Past Due Invoices"
/* MaxLen: Comment: */

&SCOPED-DEFINE socaup_p_8 "Check Credit Hold"
/* MaxLen: Comment: */

&SCOPED-DEFINE socaup_p_9 "Clear Action Status"
/* MaxLen: Comment: */

&SCOPED-DEFINE socaup_p_10 "Amount"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable convertmode as character no-undo
   initial "report".

define new shared variable rndmthd like rnd_rnd_mthd.
define variable nbr like so_nbr.
define variable nbr1 like so_nbr.
define variable cust like so_bill.
define variable cust1 like so_bill.
define variable ord_date like so_ord_date.
define variable ord_date1 like so_ord_date.
define variable due_date like so_due_date.
define variable due_date1 like so_due_date.
define variable act_stat like so_stat.
define variable act_stat1 like so_stat.
define variable ovr_cr_lim  like mfc_logical initial yes.
define variable inc_so_bal  like mfc_logical initial yes.
define variable off_cr_hold like mfc_logical initial yes.
define variable past_due    like mfc_logical initial no.
define variable past_due_days as integer format ">>9" initial 30.
define variable past_due_allow like ar_amt.
define variable past_due_tot like ar_amt label {&socaup_p_3} initial 0.
define variable set_hold like mfc_logical initial no.
define variable so_open_amt like ar_amt label {&socaup_p_5}.
define variable open_amt like ar_amt.
define variable total_exp like ar_amt.
define variable cust_name like ad_name.
define variable closed as logical.
define variable age_date like ar_due_date initial today.
define variable base_amt like ar_amt.
define variable curr_amt like ar_amt.
define variable base_applied like ar_amt.
define variable due-date like due_date.
define variable disc-date like due_date.
define variable applied-amt like ar_amt.
define variable this-applied like ar_amt.
define variable amt-due like ar_amt.
define variable cr_remain like ar_amt label {&socaup_p_4}.
define variable first_cust as logical.
define variable last_so_bill like so_bill.
define variable exdrate like exr_rate.
define variable exdrate2 like exr_rate2.
define variable l_new_so like mfc_logical initial no no-undo.
define new shared variable so_recno as recid.
define new shared variable new_order      like mfc_logical initial no.
define new shared variable due_date_range like mfc_logical initial yes.
define new shared variable date_range     like sod_due_date.
define new shared variable date_range1    like sod_due_date.
define new shared variable display_trail  like mfc_logical initial no.
define variable oldcurr like so_curr no-undo.
define new shared variable undo_trl2 like mfc_logical.

define new shared frame sotot.
define            variable first_time     like mfc_logical.
define variable found-po-mstr like mfc_logical initial no no-undo.

{mfsotrla.i "NEW"}

{etdcrvar.i new}
{etvar.i &new = new}
{etrpvar.i &new = new}

define buffer somstr for so_mstr.

assign
   nontax_old = nontaxable_amt:format
   taxable_old = taxable_amt:format
   line_tot_old = line_total:format
   disc_old     = disc_amt:format
   trl_amt_old = so_trl1_amt:format
   tax_amt_old = tax_amt:format
   ord_amt_old = ord_amt:format
   container_old = container_charge_total:format
   line_charge_old = line_charge_total:format.

oldcurr = "".


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
nbr            colon 20
   nbr1           label {t001.i} colon 54 skip
   cust           colon 20
   cust1          label {t001.i} colon 54 skip
   ord_date       colon 20
   ord_date1      label {t001.i} colon 54 skip
   due_date       colon 20
   due_date1      label {t001.i} colon 54 skip
   act_stat       colon 20
   act_stat1      label {t001.i} colon 54 skip(1)
   set_hold       label {&socaup_p_9}  colon 39
   off_cr_hold    label {&socaup_p_8}  colon 39 skip(1)
   ovr_cr_lim     label {&socaup_p_6}  colon 39 skip
   inc_so_bal     label {&socaup_p_2}  colon 39 skip(1)
   past_due       label {&socaup_p_7}  colon 39
   past_due_days  label {&socaup_p_1}  colon 39
   past_due_allow label {&socaup_p_10} colon 39 skip
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:

   if nbr1 = hi_char then nbr1 = "".
   if cust1 = hi_char then cust1 = "".
   if ord_date = low_date then ord_date = ?.
   if ord_date1 = hi_date or ord_date1 = low_date then
      ord_date1 = ?.
   if due_date = low_date then due_date = ?.
   if due_date1 = hi_date or due_date1 = low_date then
      due_date1 = ?.
   if act_stat1 = hi_char then act_stat1 = "".

   view frame a.
   update nbr
      nbr1
      cust
      cust1
      ord_date
      ord_date1
      due_date
      due_date1
      act_stat
      act_stat1
      set_hold
      off_cr_hold
      ovr_cr_lim
      inc_so_bal
      past_due
      past_due_days
      past_due_allow
   with frame a side-labels attr-space width 80.

   /* Prepare parameters for display */
   run ip-mfquoter.

   if nbr1 = "" then nbr1 = hi_char.
   if cust1 = "" then cust1 = hi_char.
   if ord_date = ? then ord_date = low_date.
   if ord_date1 = ? then ord_date1 = hi_date.
   if due_date = ? then due_date = low_date.
   if due_date1 = ? then due_date1 = hi_date.
   if act_stat1 = "" then act_stat1 = hi_char.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer" &printWidth = 132
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
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

    { mfphead.i }

   last_so_bill = ?.
   for each so_mstr use-index so_bill no-lock where
         so_nbr >= nbr and so_nbr <= nbr1 and
         so_bill >= cust and so_bill <= cust1 and
         so_ord_date >= ord_date and so_ord_date <= ord_date1
         break by so_bill by so_ord_date with frame d down width 132:

      if so_stat < act_stat or so_stat > act_stat1 then next.

      run check-po-mstr(input so_nbr, output found-po-mstr).
      if found-po-mstr then next.

      /* SET CURLOOP TO CAUSE SETTING OR FORMATS FOR CURRENCY */

      /* CHECK IF ANY SALES ORDER IS BEING CREATED */
      l_new_so = no.
      {gprun.i ""sonewso.p"" "(input recid(so_mstr),
                               output l_new_so)"}
      if l_new_so then next.

      if (oldcurr <> so_curr) or (oldcurr = "") then do:

         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input  so_curr,
              output rndmthd,
              output mc-error-number)" }
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
            leave.
         end.

         {socurfmt.i}  /* SET CURRENCY FORMATS */
         oldcurr = so_curr.
      end. /* IF OLDCURR <> SO_CURR */

      if last_so_bill <> so_bill then
      assign
         first_cust = yes
         first_time = yes
         last_so_bill = so_bill.

      find first sod_det where sod_nbr = so_nbr and sod_confirm and
         ((sod_due_date = ? and due_date = low_date) or
         (sod_due_date >= due_date and sod_due_date <= due_date1 and
         sod_due_date <> ?)) no-lock no-error.
      if not available sod_det then next.

      find cm_mstr where cm_addr = so_bill no-lock no-error.

      run find-ad-mstr(input so_bill).

      if available cm_mstr then do:
         if first_time   then do:
            assign
               first_time   = no
               total_exp    = cm_balance
               so_open_amt  = 0
               open_amt     = 0
               cr_remain    = cm_cr_limit - cm_balance
               past_due_tot = 0.
            /* Calculate past_due using multiple credit terms */
            if past_due = yes then do:
               for each ar_mstr where  ar_bill = cm_addr and ar_open = yes
                     no-lock use-index ar_bill_open:
                  open_amt = 0.

                  /* BASE_AMT IS IN DOCUMENT CURRENCY AND ROUNDED PER*/
                  /* THAT CURR IF DOC CURR AND BASE CURR ARE NOT THE */
                  /* SAME THEN CALCULATE BASE_AMOUNT USING THE BASE  */
                  /* EXCHANGE RATE AND ROUND PER BASE CURR  */
                  if ar_curr <> base_curr then do:

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  ar_curr,
                          input  base_curr,
                          input  ar_ex_rate,
                          input  ar_ex_rate2,
                          input  ar_amt,
                          input  true,  /* ROUND */
                          output base_amt,
                          output mc-error-number)" }
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  ar_curr,
                          input  base_curr,
                          input  ar_ex_rate,
                          input  ar_ex_rate2,
                          input  ar_applied,
                          input  true,  /* ROUND */
                          output base_applied,
                          output mc-error-number)" }
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                     /* Use invoice rate if today's rate is unavailable */
                     assign
                        exdrate  = ar_ex_rate
                        exdrate2 = ar_ex_rate2.

                     {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                                 "(input  ar_curr,
                                   input  base_curr,
                                   input  ar_ex_ratetype,
                                   input  age_date,
                                   output exdrate,
                                   output exdrate2,
                                   output mc-error-number)" }

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input  ar_curr,
                                   input  base_curr,
                                   input  exdrate,
                                   input  exdrate2,
                                   input  ar_amt - ar_applied,
                                   input  true,  /* ROUND */
                                   output curr_amt,
                                   output mc-error-number)" }
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                  end. /* IF AR_CURR <> BASE_CURR */

                  else  /* AR already in base currency */
                  assign
                     base_amt     = ar_amt
                     base_applied = ar_applied
                     curr_amt     = ar_amt - ar_applied.

                  due-date = ar_due_date.
                  find ct_mstr where ct_code = ar_cr_terms no-lock no-error.
                  if available ct_mstr and ct_dating = yes then do:
                     applied-amt = base_applied.
                     run get-due-date (input ar_cr_terms, input ar_date).
                  end. /*if available ct_mstr &  ct_dating = yes*/
                  else
                  if (today - past_due_days) >  due-date then
                     open_amt = base_amt - base_applied.
                  past_due_tot = past_due_tot + open_amt.
               end. /* for ar_mstr */
            end. /* if past_due = yes */
         end. /* if first_cust = yes */

         /* DETERMINE ord_amt */
         assign
            maint = no
            date_range  = due_date
            date_range1 = due_date1
            so_recno = recid(so_mstr).

         {gprun.i ""sosotrl2.p""}

         /* ORD_AMT IS IN DOCUMENT CURRENCY AND IS ROUNDED PER THAT CURR */
         /* IF DOC CURR AND BASE CURR ARE NOT THE SAME THEN CALCULATE ORD*/
         /* AMOUNT USING THE BASE EXCHANGE RATE AND ROUND PER BASE CURR  */
         /*LB01*..   check all the orders assosiated with the customer...          */
/*LB01      not like before only calculates the selected sales orders.      */
/*LB01*/so_open_amt = 0.
/*LB01*/for each somstr where somstr.so_cust = so_mstr.so_cust and so_fsm_type=" " no-lock use-index so_cust,
/*LB01*/  each sod_det where somstr.so_nbr = sod_nbr no-lock:
			so_open_amt = so_open_amt +
/*LB01*/                  (sod_qty_ord - sod_qty_ship + sod_qty_inv)
/*LB01*/                   * sod_price.
/*LB01*/end. 
/*tfq   ord_amt = so_open_amt.*/
    /******************tfq**add begin*****************/      
         if so_curr <> base_curr then
           do:

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  so_curr,
                 input  base_curr,
                 input  so_ex_rate,
                 input  so_ex_rate2,
                 input  so_open_amt /*tfq ord_amt*/,
                 input  true,  /* ROUND */
                 output so_open_amt,
                 output mc-error-number)" }
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

            {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input  so_curr,
                  input  base_curr,
                  input  so_ex_rate,
                  input  so_ex_rate2,
                  input  l_cr_ord_amt,
                  input  true, /* ROUND */
                  output l_cr_ord_amt,
                  output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-error-number <> 0 */

         end.
/******************tfq added end********************/        
   /******************tfq**deleted begin*****************      
         if so_curr = base_curr then
            so_open_amt = ord_amt.
         else do:

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  so_curr,
                 input  base_curr,
                 input  so_ex_rate,
                 input  so_ex_rate2,
                 input  ord_amt,
                 input  true,  /* ROUND */
                 output so_open_amt,
                 output mc-error-number)" }
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

            {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input  so_curr,
                  input  base_curr,
                  input  so_ex_rate,
                  input  so_ex_rate2,
                  input  l_cr_ord_amt,
                  input  true, /* ROUND */
                  output l_cr_ord_amt,
                  output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-error-number <> 0 */

         end.
******************tfq deleted end********************/
         cr_remain = cr_remain - so_open_amt.

         if inc_so_bal
         then
            total_exp = (total_exp + l_cr_ord_amt).

      end. /* available cm_mstr */

      if (past_due_tot <= past_due_allow or past_due = no) and
         (total_exp <= cm_cr_limit or ovr_cr_lim = no)     and
         (cm_cr_hold = no or off_cr_hold = no)             and
         (so_stat <> "" or not first_cust)
      then do:

         if (first_cust) then do:
            first_cust = no.
            if past_due = yes then do with frame b:
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame b:handle).
               display so_bill cust_name cm_cr_hold cm_cr_limit cm_balance
                  past_due_tot with frame b down width 132 STREAM-IO /*GUI*/ .
            end. /* if past_due = yes */
            else do with frame c:
               /* SET EXTERNAL LABELS */
               setFrameLabels(frame c:handle).
               display so_bill cust_name cm_cr_hold cm_cr_limit cm_balance
               with frame c down width 132 STREAM-IO /*GUI*/ .
            end. /* else */
         end.

         if set_hold = yes then do for somstr:
               find somstr exclusive-lock where recid(somstr) = so_recno no-error.
               if available somstr then do:
                  somstr.so_stat = "".
                  {gprun.i ""sobtbcrh.p"" "(input somstr.so_nbr,
                                            input somstr.so_stat)"}
               end.
            end.

            run find-rma-mstr (input so_nbr, input so_stat).

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame d:handle).
            display so_cust so_ship so_nbr so_stat so_po so_due_date
               so_conf_date so_open_amt so_cr_terms cr_remain
            with frame d down width 132 STREAM-IO /*GUI*/ .

         end.
      end. /* for each so_mstr */

      /*REPORT TRAILER */
      {mfrtrail.i}
   end. /* repeat */

   PROCEDURE ip-mfquoter:
      bcdparm = "".
      {mfquoter.i nbr       }
      {mfquoter.i nbr1      }
      {mfquoter.i cust      }
      {mfquoter.i cust1     }
      {mfquoter.i ord_date  }
      {mfquoter.i ord_date1 }
      {mfquoter.i due_date  }
      {mfquoter.i due_date1 }
      {mfquoter.i act_stat  }
      {mfquoter.i act_stat1 }
      {mfquoter.i set_hold  }
      {mfquoter.i off_cr_hold }
      {mfquoter.i ovr_cr_lim}
      {mfquoter.i inc_so_bal}
      {mfquoter.i past_due  }
      {mfquoter.i past_due_days }
      {mfquoter.i past_due_allow }
   END PROCEDURE.  /* ip-mfquoter */

   PROCEDURE find-rma-mstr:

      define input parameter inpar_nbr  like so_nbr.
      define input parameter inpar_stat like so_stat.

      find rma_mstr where rma_nbr = inpar_nbr and rma_prefix = "C"
         exclusive-lock no-error no-wait.
      if available rma_mstr then
         rma_stat = inpar_stat.

   END PROCEDURE.

   PROCEDURE find-ad-mstr:

      define input parameter inpso_bill like so_bill.

      find ad_mstr where ad_addr = inpso_bill no-lock no-error.
      if available ad_mstr then cust_name = ad_name.
   END PROCEDURE.

   PROCEDURE check-po-mstr:

      define input parameter inpso_nbr like so_nbr.
      define output parameter found-po-mstr like mfc_logical initial no
         no-undo.

      for each sod_det where sod_nbr      =  inpso_nbr
            and sod_btb_type <> "01"
            and sod_btb_po   <> "" no-lock
            break by sod_btb_po:
         if not first-of(sod_btb_po) then next.
         find po_mstr where  po_nbr  = sod_btb_po and
            po_xmit = "5" no-lock no-error.
         if available po_mstr then leave.
      end. /* for each sod_det */
      if available po_mstr then assign found-po-mstr = yes.
   END PROCEDURE.

   PROCEDURE get-due-date:
      define input parameter i-ar_cr_terms like ar_cr_terms.
      define input parameter i-ar_date     like ar_date.

      for each ctd_det where ctd_code = i-ar_cr_terms no-lock
            use-index ctd_cdseq:
         closed = no.
         find ct_mstr where ct_code = ctd_date_cd
            no-lock no-error.
         if available ct_mstr then do:
            /* GET DUE DATE FOR MULTI DUE DATE TERMS */
            due-date = ?.

            {gprun.i ""adctrms.p""
               "(input  i-ar_date,
                 input  ctd_date_cd,
                 output disc-date,
                 output due-date)"}

            /*CALCULATE AMT-DUE LESS APPLIED FOR THIS SEGMENT*/
            amt-due = base_amt * (ctd_pct_due / 100).
            if applied-amt >= amt-due then
            assign
               applied-amt = applied-amt - amt-due
               this-applied = amt-due * (-1)
               closed = yes.
            else
            assign
               amt-due = amt-due - applied-amt
               this-applied = applied-amt * (-1)
               applied-amt = 0.
            if (today - past_due_days) > due-date and not closed then
               open_amt = open_amt + base_amt * (ctd_pct_due / 100).
         end. /*if avail ct_mstr*/
         if ctd_pct_due = 100 then leave.
      end. /*for each ctd_det*/

   END PROCEDURE.  /* get-due-date */

