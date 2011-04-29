/* GUI CONVERTED from soivrp.p (converter v1.71) Tue Aug 11 12:13:52 1998 */
/* soivrp.p - PENDING INVOICE REGISTER                                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*K0LD*/ /*V8#ConvertMode=WebReport                                 */
/*V8:ConvertMode=FullGUIReport                                               */
/*L024*/ /*V8:WebEnabled=No                                                  */
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

/* THIS REPORT USES THE gltw_wkfl TO ACCUMULATE GL      */
/* TRANSACTIONS AND THEN DOES AN UNDO TO DELETE THEN    */

         /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*H593*/ {mfdtitle.i "e+ "}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE soivrp_p_1 "合并贷方"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp_p_2 " 报表合计: "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp_p_3 "包括准备过帐的发票"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp_p_4 "合并借方"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp_p_5 "借方金额"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp_p_6 "包括准备打印的发票"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp_p_7 "合并发票"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp_p_8 "贷方金额"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp_p_9 "打印发运零件的批/序号"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp_p_10 "只打印要开发票的项目"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */


/*K001*/ {gldydef.i new}
/*K001*/ {gldynrm.i new}

/*H050*/ define new shared variable tot_base_amt like ar_amt.
/*J053* /*H050*/ define new shared variable tot_base_price like sod_price */
/*J053*                  decimals 2 format "->>>>,>>>,>>9.99".                   */
/*J053*/ define new shared variable tot_base_price as decimal
/*J053*/          format "->>>>,>>>,>>9.99".
/*J053* /*H050*/ define new shared variable tot_base_margin like sod_price */
/*J053*/ define new shared variable tot_base_margin as decimal
                  format "->>>>,>>>,>>9.99".
         define new shared variable nbr like so_nbr.
         define new shared variable nbr1 like so_nbr.
         define new shared variable shipdate like so_ship_date.
         define new shared variable shipdate1 like shipdate.
/*G047*/ define new shared variable cust  like so_cust.
/*G047*/ define new shared variable cust1 like so_cust.
/*G047*/ define new shared variable bill  like so_bill.
/*G047*/ define new shared variable bill1 like so_bill.
/*F328*/ define new shared variable print_ready2inv like mfc_logical
                  initial yes.
/*F328*/ define new shared variable print_ready2post like mfc_logical
                  initial no.
         define new shared variable inv_only like mfc_logical initial yes.
         define new shared variable print_lotserials like mfc_logical
                  label {&soivrp_p_9}.

         define variable dr_amt as decimal format "->>,>>>,>>>,>>9.99"
                  label {&soivrp_p_5}.
         define variable cr_amt as decimal format "->>,>>>,>>>,>>9.99"
                  label {&soivrp_p_8}.
         define variable runok_noundo like mfc_logical no-undo initial no.
/*H593*/ define new shared variable conso like mfc_logical initial no
/*H593*/          label {&soivrp_p_7}.
/*J053*/ define variable tot_price_fmt as character no-undo.
/*J053*/ define variable tot_marg_fmt as character no-undo.
/*J053*/ define variable tot_amt_fmt as character no-undo.
/*J053*/ define variable gltwdr_fmt as character no-undo.
/*J053*/ define variable gltwdr as decimal format "->>>>,>>>,>>9.99" no-undo.
/*J053*/ define variable gltwcr_fmt as character no-undo.
/*J053*/ define variable gltwcr as decimal format "->>>>,>>>,>>9.99" no-undo.
/*J053*/ define variable rptstr as character format "x(19)" no-undo.

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
nbr                  colon 15
            nbr1                 label {t001.i} colon 50 skip
            shipdate             colon 15
            shipdate1            label {t001.i} colon 50 skip
/*G047*/    cust           colon 15
/*G047*/    cust1          label {t001.i} colon 50 skip
/*G047*/    bill           colon 15
/*G047*/    bill1          label {t001.i} colon 50 skip(1)
            inv_only             colon 40 label {&soivrp_p_10}
            print_lotserials     colon 40
/*H593*/    conso                colon 40
            skip(1)
            print_ready2inv      colon 40 label {&soivrp_p_6}
            print_ready2post     colon 40 label {&soivrp_p_3}
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*J053*/ /* DEFINE FRAME FOR DISPLAYING REPORT TOTALS IN BASE CURRENCY */
/*J053*/ FORM /*GUI*/ 
/*J053*/   rptstr to 19 format "x(19)"
/*J053*/   tot_base_amt    to 39
/*J053*/   tot_base_price  to 59
/*J053*/   tot_base_margin to 79
/*J053*/   skip(1)
/*J053*/ with STREAM-IO /*GUI*/  frame rpttot no-labels width 132 down.

/*J053*/ /*DEFINE FRAME FOR DISPLAYING GL TOTALS */
/*J053*/ FORM /*GUI*/ 
/*J053*/    gltw_acct
/*J053*/    gltw_cc
/*J053*/    gltw_date
/*J053*/    gltwdr label {&soivrp_p_4}
/*J053*/    gltwcr label {&soivrp_p_1}
/*J053*/ with STREAM-IO /*GUI*/  frame gltwtot width 80 down.

/*K082** /*K001*/ if daybooks-in-use then
 * /*K001*/    {gprun.i ""nrm.p"" "persistent set h-nrm"}. **/

         find first gl_ctrl no-lock.
/*H0N9*/ for each gltw_wkfl exclusive-lock where gltw_userid = mfguser:
/*L024*/    {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input gltw_exru_seq)"}
/*H0N9*/    delete gltw_wkfl.
/*H0N9*/ end.

/*J053*/ /* SETUP THE FORMATS FOR THE TOTAL DISPLAYS.  BECAUSE THESE ARE IN */
/*J053*/ /* BASE THEY ONLY NEED TO BE SET UP ONCE.  */
/*J053*/ assign
/*J053*/   gltwdr_fmt = gltwdr:format
/*J053*/   gltwcr_fmt = gltwcr:format
/*J053*/   tot_amt_fmt = tot_base_amt:format
/*J053*/   tot_price_fmt = tot_base_price:format
/*J053*/   tot_marg_fmt = tot_base_margin:format.

/*J053*/ /* SET CURRENCY FORMAT FOR TOT_BASE_AMT */
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output tot_amt_fmt,
                                      input gl_rnd_mthd)"}
/*J053*/ /* SET CURRENCY FORMAT FOR TOT_BASE_PRICE */
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output tot_price_fmt,
                                   input gl_rnd_mthd)"}
/*J053*/ /* SET CURRENCY FORMAT FOR TOT_BASE_MARGIN */
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output tot_marg_fmt,
                                      input gl_rnd_mthd)"}
/*J053*/ /* SET CURRENCY FORMAT FOR GLTWDR */
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output gltwdr_fmt,
                                   input gl_rnd_mthd)"}
/*J053*/ /* SET CURRENCY FORMAT FOR GLTWCR */
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output gltwcr_fmt,
                                   input gl_rnd_mthd)"}
/*J053*/ assign
/*J053*/    tot_base_amt:format = tot_amt_fmt
/*J053*/    tot_base_price:format = tot_price_fmt
/*J053*/    tot_base_margin:format = tot_marg_fmt
/*J053*/    gltwdr:format = gltwdr_fmt
/*J053*/    gltwcr:format = gltwcr_fmt.

/*K0LD*/ {wbrp01.i}


/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


         if nbr1 = hi_char then nbr1 = "".
         if shipdate = low_date then shipdate = ?.
         if shipdate1 = hi_date then shipdate1 = ?.
/*G047*/ if cust1 = hi_char then cust1 = "".
/*G047*/ if bill1 = hi_char then bill1 = "".


/*K0LD*/ if c-application-mode <> 'web':u then
     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0LD*/ {wbrp06.i &command = update &fields = "  nbr nbr1 shipdate shipdate1
cust cust1 bill bill1 inv_only print_lotserials  conso  print_ready2inv
print_ready2post" &frm = "a"}

/*K0LD*/ if (c-application-mode <> 'web':u) or
/*K0LD*/ (c-application-mode = 'web':u and
/*K0LD*/ (c-web-request begins 'data':u)) then do:


         bcdparm = "".
         {mfquoter.i nbr    }
         {mfquoter.i nbr1   }
         {mfquoter.i shipdate  }
         {mfquoter.i shipdate1 }
/*G047*/ {mfquoter.i cust   }
/*G047*/ {mfquoter.i cust1  }
/*G047*/ {mfquoter.i bill   }
/*G047*/ {mfquoter.i bill1  }
         {mfquoter.i inv_only}
         {mfquoter.i print_lotserials}
/*H593*/ {mfquoter.i conso}
         {mfquoter.i print_ready2inv}
         {mfquoter.i print_ready2post}

         if nbr1 = "" then nbr1 = hi_char.
         if shipdate = ? then shipdate = low_date.
         if shipdate1 = ? then shipdate1 = hi_date.
/*G047*/ if cust1 = "" then cust1 = hi_char.
/*G047*/ if bill1 = "" then bill1 = hi_char.

/*K0LD*/ end.

   /* SELECT PRINTER*/
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first gl_ctrl no-lock.




/*K082*/ if daybooks-in-use then
/*K082*/   {gprun.i ""nrm.p"" "persistent set h-nrm"}.


   {mfphead2.i}

   tranloop:                                                            /*F0C0*/
   do transaction on endkey undo, leave.                                /*F0C0*/
/*F0C0**   do transaction:   **/


      /* Main Report Loop */
      {gprun.i  ""xxsoivrpa.p""}

/*F0C0*/ if keyfunction(lastkey) <> "end-error" then do:
    /*    Report Totals */
    
/*J053******************* DEFINE RPTTOT FRAME AND USE FOR DISPLAY ************
*            put skip(1)
* /*H002*/ "---------------" to 77 "---------------" to 108 "---------------" to
* /*H002*/    129
*            skip base_curr + " Report Totals: " to 61 format "x(19)"
* /*H050*/    tot_base_amt format "->>>>,>>>,>>9.99" to 77
* /*H002*/    tot_base_price format "->>>>,>>>,>>9.99" to 108
* /*H002*/    tot_base_margin format "->>>>,>>>,>>9.99" to 129 skip(1).
**J053******************* DEFINE RPTTOT FRAME AND USE FOR DISPLAY *********** */

/*J05  underline tot_base_amt tot_base_price tot_base_margin 
/*J053*/    with frame rpttot.*/
/*J053    down 1 with frame rpttot.*/
/*J053*/    display
/*J053*/     /*  base_curr + {&soivrp_p_2} @ rptstr */
/*J053*/       tot_base_amt LABEL "合计金额"
/*J053*/       tot_base_price  label "不含税金额"
/*J053*/       (tot_base_amt - tot_base_price) @ tot_base_margin label "税款"
/*J053*/    with frame rpttot STREAM-IO /*GUI*/ .


         /* Print GL Recap
          put "" at 2.
            put "" at 2.
            put "制表:_______________ 审批:_________________日期：__________________"at 6.

         page.*/


/*K001*  Replaced the following line for Oracle compatibility */
/*K001*  for each gltw_wkfl where gltw_userid = global_userid */
/*H0N9** /*K001*/ for each gltw_wkfl exclusive-lock where gltw_userid = global_userid */
/*H0N9*/ for each gltw_wkfl exclusive-lock where gltw_userid = mfguser
         break by gltw_userid by gltw_acct by gltw_cc
/*J053*/ with frame gltwtot:
/*J053*         with width 132:  */


            cr_amt = 0.
            dr_amt = 0.
            if gltw_amt < 0 then cr_amt = - gltw_amt.
                            else dr_amt = gltw_amt.
            accumulate (dr_amt) (total by gltw_cc).
            accumulate (cr_amt) (total by gltw_cc).

/*F0C0*/    
/*GUI*/ {mfguichk.i  &loop="tranloop"} /*Replace mfrpchk*/

/*F0C0**    {mfrpexit.i} **/

            if last-of(gltw_cc) then do:
               display gltw_acct gltw_cc gltw_date with frame gltwtot STREAM-IO /*GUI*/ .

               if (accum total by gltw_cc dr_amt) <> 0 then
/*J053*/       do:
/*J053*/          gltwdr = accum total by gltw_cc dr_amt.
/*H0N9** /*J053*/          display gltwdr with frame gltwtot.              */
/*H0N9*/          display gltwdr "" @ gltwcr with frame gltwtot STREAM-IO /*GUI*/ .
/*J053*           display accum total by gltw_cc (dr_amt)                  */
/*J053*           format "->>>>,>>>,>>9.99" label "Consolidated Dr".       */
/*J053*/       end.
               if (accum total by gltw_cc cr_amt) <> 0 then
/*J053*/       do:
/*J053*/          gltwcr = accum total by gltw_cc cr_amt.
/*H0N9** /*J053*/          display gltwcr with frame gltwtot.              */
/*H0N9*/          display gltwcr "" @ gltwdr with frame gltwtot STREAM-IO /*GUI*/ .
/*J053*           display accum total by gltw_cc (cr_amt)                  */
/*J053*           format "->>>>,>>>,>>9.99" label "Consolidated Cr".       */
/*J053*/       end.
/*J053*/       down 1 with frame gltwtot.
               
            end.

            if last-of(gltw_userid) then do:
/*J053 */     underline gltwdr gltwcr with frame gltwtot.
/*J053*/       down 1 with frame gltwtot.
/*J053*/       display
/*J053*/          accum total (dr_amt) @ gltwdr
/*J053*/          accum total (cr_amt) @ gltwcr with frame gltwtot STREAM-IO /*GUI*/ .
/*J053*               put "----------------" to 39 "----------------" to 56 skip   */
/*J053*               accum total (dr_amt) format "->>>>,>>>,>>9.99" to 39         */
/*J053*               accum total (cr_amt) format "->>>>,>>>,>>9.99" to 56 skip(2).*/  
            put "" at 2.
            put "" at 2.
            put "制表:___________________ 审批:________________________日期：_____________________"at 6. 
            page.
            end.

/*L024*/ {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input gltw_exru_seq)"}

/*F0LC*/ delete gltw_wkfl.

         end. /* for each gltw_ */
/*F0C0*/ end. /* if not end-error */

/*F0C0** {mfrtrail.i}
 **      runok_noundo = runok.
 **      undo, leave. **/

   end.  /* TRANLOOP */

/*F0C0*/ 
/*GUI*/ /*{mfguitrl.i} Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


/*K082*/ if daybooks-in-use then delete procedure h-nrm no-error.

end.
/*F0C0** runok = runok_noundo. **/
/*K082** /*K001*/ if daybooks-in-use then delete procedure h-nrm no-error. **/

/*K0LD*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 shipdate shipdate1  cust cust1 bill bill1 inv_only print_lotserials  conso  print_ready2inv print_ready2post "} /*Drive the Report*/
