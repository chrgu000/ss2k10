/* GUI CONVERTED from arcsrp04.p (converter v1.78) Fri Oct 29 14:36:01 2004 */
/* arcsrp04.p - ACCOUNTS RECEIVABLE CUST CREDIT REPORT                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/*F0PN*/ /*K0QM*/
/*V8:ConvertMode=FullGUIReport                                           */
/* REVISION: 5.0      LAST MODIFIED: 02/23/89   BY: PML                  */
/* REVISION: 6.0      LAST MODIFIED: 10/16/90   BY: afs *D100*           */
/* REVISION: 7.0      LAST MODIFIED: 02/01/92   BY: pml *F127*           */
/*                                   09/16/92   by: jms *F899*           */
/* REVISION: 7.3      LAST MODIFIED: 09/03/92   BY: afs *G045*           */
/*                                   10/13/92   by: jms *G162*           */
/*                                   12/09/93   by: jms *GH82*           */
/*                                   06/10/94   by: dpm *FO77*           */
/* REVISION: 7.3      LAST MODIFIED: 08/23/94   BY: rxm *GL40*           */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   by: jzw *K00B*           */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   by: bvm *K0QM*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00M* D. Sidel      */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L02Q* Brenda Milton */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt     */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                 */
/* REVISION: 9.1      LAST MODIFIED: 09/14/00   BY: *N0VV* BalbeerS Rajput   */
/* $Revision: 1.11.1.7 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/


/*L00M   {mfdtitle.i "2+ "} */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*L00M*/ {mfdtitle.i "2+ "}

/*N0VV*/ {cxcustom.i "ARCSRP04.P"}
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arcsrp04_p_1 "Show Highest Dunning Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp04_p_2 "Over Credit Limit Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp04_p_3 "Calculate Days Paid Late"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*L02Q*/  /* THESE ARE NEEDED FOR FULL GUI REPORTS */
/*L02Q*/  {gprunpdf.i "mcpl" "p"}
/*L02Q*/  {gprunpdf.i "mcui" "p"}

          define variable code like cm_addr.
          define variable code1 like cm_addr.
          define variable name like ad_name.
          define variable name1 like ad_name.
          define variable type like cm_type.
          define variable type1 like cm_type.
          define variable calc_days like mfc_logical
             label {&arcsrp04_p_3} initial yes.
          define variable inv_count as integer.
          define variable days_late as integer.
          
          
          define variable due-date like ar_due_date.
          define variable show_dun like mfc_logical
             label {&arcsrp04_p_1} initial no.
          define variable show_over like mfc_logical
             label {&arcsrp04_p_2} initial no.
          define variable high_dun_level like ar_dun_level
             no-undo.

/*L00M*BEGIN ADDED SECTION*/
          {etrpvar.i &new = "new"}
          {etvar.i   &new = "new"}
          {eteuro.i}
/*L02Q*   define variable input_curr     like ex_curr. */
          define variable et_cm_cr_limit like cm_balance.
          define variable et_cm_balance  like cm_balance.
          define variable et_cm_high_cr  like cm_high_cr.

          find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
/*L00M*END ADDED SECTION*/

          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
             
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
code           colon 15
             code1          label {t001.i} colon 49 skip
             name           colon 15
             name1          label {t001.i} colon 49 skip
             type           colon 15
             type1          label {t001.i} colon 49 skip (1)
             calc_days      colon 33
             show_dun       colon 33
/*L00M       show_over      colon 33 skip */
/*L00M*/     show_over      colon 33
/*L02Q*/     et_report_curr colon 33 skip(1)
/*L02Q* /*L00M*/  et_report_txt  to 33    no-label */
/*L02Q* /*L00M*/  et_report_curr /*colon 33*/ no-label */
/*L02Q* /*L00M*/  et_rate_txt    to 33    no-label */
/*L02Q* /*L00M*/  et_report_rate /*colon 33*/ no-label skip(1) */
           SKIP(.4)  /*GUI*/
with frame a side-labels
/*L00M*/  no-attr-space
          width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



          /* SET EXTERNAL LABELS */
          setFrameLabels(frame a:handle).

          {wbrp01.i}

          
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

             if code1 = hi_char then code1 = "".
             if name1 = hi_char then name1 = "".
             if type1 = hi_char then type1 = "".

/*L02Q* /*L00M*/     display et_report_txt */
/*L02Q* /*L00M*/             et_rate_txt with frame a. */

             if c-application-mode <> 'web':u then
                
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


             {wbrp06.i &command = update &fields = "  code code1 name
              name1 type type1 calc_days  show_dun show_over
/*L00M*/      et_report_curr
/*L02Q* /*L00M*/ et_report_rate */
              " &frm = "a"}

/*L02Q* /*L00M*/ {etcurval.i &curr   = "et_report_curr" &errlevel = "4" */
/*L02Q* /*L00M*/             &action = "next"           &prompt   = "pause"} */

/*L00M*/     assign et_eff_date = today.
/*L02Q* /*L00M*/ input_curr = "". */
/*L02Q* /*L00M*/ {gprun.i ""etrate.p"" "(input input_curr)"} */

             if (c-application-mode <> 'web':u) or
             (c-application-mode = 'web':u and
             (c-web-request begins 'data':u)) then do:

                /*CREATE BATCH INPUT STRING */
                bcdparm = "".
                {mfquoter.i code      }
                {mfquoter.i code1     }
                {mfquoter.i name      }
                {mfquoter.i name1     }
                {mfquoter.i type      }
                {mfquoter.i type1     }
                {mfquoter.i calc_days }
                {mfquoter.i show_dun  }
                {mfquoter.i show_over }
/*L00M*/        {mfquoter.i et_report_curr }
/*L02Q* /*L00M*/ {mfquoter.i et_report_rate } */

                if code1 = "" then code1 = hi_char.
                if name1 = "" then name1 = hi_char.
                if type1 = "" then type1 = hi_char.

/*L02Q*/        if et_report_curr <> "" then do:
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                     "(input et_report_curr,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number = 0
/*L02Q*/           and et_report_curr <> base_curr then do:
/*L08W*               CURRENCIES AND RATES REVERSED BELOW...             */
/*L02Q*/              {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                        "(input et_report_curr,
                          input base_curr,
                          input "" "",
                          input et_eff_date,
                          output et_rate2,
                          output et_rate1,
                          output mc-seq,
                          output mc-error-number)"}
/*L02Q*/           end.  /* if mc-error-number = 0 */

/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 3}
/*L02Q*/              if c-application-mode = 'web':u then return.
/*L02Q*/              else /*GUI NEXT-PROMPT removed */
/*L02Q*/              /*GUI UNDO removed */ RETURN ERROR.
/*L02Q*/           end.  /* if mc-error-number <> 0 */
/*L02Q*/           else if et_report_curr <> base_curr then do:
/*L08W*               CURRENCIES AND RATES REVERSED BELOW...             */
/*L02Q*/              {gprunp.i "mcui" "p" "mc-ex-rate-output"
                        "(input et_report_curr,
                          input base_curr,
                          input et_rate2,
                          input et_rate1,
                          input mc-seq,
                          output mc-exch-line1,
                          output mc-exch-line2)"}
/*L02Q*/              {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                        "(input mc-seq)"}
/*L02Q*/           end.  /* else do */
/*L02Q*/        end.  /* if et_report_curr <> "" */
/*L02Q*/        if et_report_curr = "" or et_report_curr = base_curr then
/*L02Q*/           assign
/*L02Q*/              mc-exch-line1 = ""
/*L02Q*/              mc-exch-line2 = ""
/*L02Q*/              et_report_curr = base_curr.

             end.  /* if (c-application-mode <> 'web':u) ... */

             /* Select printer */
             
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

define buffer armstr for ar_mstr.
define buffer cmmstr for cm_mstr.


             {mfphead.i}

             for each cm_mstr  where cm_mstr.cm_domain = global_domain and (
             (cm_addr >= code and cm_addr <= code1)
                                   and (cm_sort >= name and cm_sort <= name1)
                                   and (cm_type >= type and cm_type <= type1)
                                   and (not show_over or
                                   cm_balance > cm_cr_limit)
                                   ) no-lock break by cm_sort
                                   with frame b width 132:

                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                if calc_days = yes
                or show_dun /* SHOW HIGHEST DUNNING LEVEL */
                then do:
                   inv_count = 0.
                   days_late = 0.
                   high_dun_level = 0.
                   for each ar_mstr  where ar_mstr.ar_domain = global_domain
                   and (  ar_bill = cm_addr
                   and (show_dun
                   or (ar_type = "P"
                   or ar_type = "D"
                   or ar_type = "A"))
                   ) no-lock:

                      /* SAVE HIGHEST DUNNING LEVEL FOR CUSTOMER */
                      if show_dun
                      and ar_open = yes
                      and ar_type <> "D"
                      and ar_dun_level > high_dun_level then
                         high_dun_level = ar_dun_level.

                      if calc_days
                      and (ar_type = "P"
                      or ar_type = "D"
                      or ar_type = "A")
                      then do:
                         for each ard_det  where ard_det.ard_domain =
                         global_domain and  ard_nbr = ar_nbr no-lock:
                            do for armstr:
                               find armstr  where armstr.ar_domain =
                               global_domain and  armstr.ar_nbr = ard_ref
                               no-lock no-error.
                               if available armstr then do:
                                  find ct_mstr
                                   where ct_mstr.ct_domain = global_domain and
                                   ct_code = armstr.ar_cr_terms
                                  no-lock no-error.
                                  if available ct_mstr
                                  and ct_dating = yes then do:
                                     for each ctd_det
                                      where ctd_det.ctd_domain = global_domain
                                      and  ctd_code = ar_cr_terms
                                     no-lock
                                     use-index ctd_cdseq:
                                        find ct_mstr
                                         where ct_mstr.ct_domain =
                                         global_domain and  ct_code =
                                         ctd_date_cd
                                        no-lock no-error.
                                        if available ct_mstr then do:
/*N0VV*/                                   {&ARCSRP04-P-TAG1}
                                           if (ct_due_inv = 1)
                                           then
                                              due-date  = ar_date + ct_due_days.
                                           else
                                              due-date =
                                                date((month(ar_date) + 1) mod 12
                                                + if month(ar_date) = 11 then
                                                12 else 0, 1, year(ar_date) +
                                                if month(ar_date) >= 12
                                                then 1 else 0)
                                                + integer(ct_due_days)
                                                - if ct_due_days <> 0
                                                then 1 else 0.
                                           if ct_due_date <> ? then
                                              due-date = ct_due_date.
/*N0VV*/                                   {&ARCSRP04-P-TAG2}

                                           inv_count = inv_count + 1.
                                           days_late = days_late +
                                              (ar_mstr.ar_effdate - due-date).
                                        end. /* IF AVAILABLE CT_MSTR */
                                     end. /* FOR EACH CTD_DET */
                                  end. /* IF AVAILABLE CT_MSTR AND CT_DATING */
                                  else do:
                                     inv_count = inv_count + 1.
                                     days_late = days_late +
                                     (ar_mstr.ar_effdate - armstr.ar_due_date).
                                  end.
                               end. /* IF AVAILABLE ARMSTR */
                            end. /* DO FOR ARMSTR */
                         end. /* FOR EACH ARD_DET */
                      end. /* IF CALC_DAYS AND AR-TYPE = P,D,A */
                   end. /* FOR EACH AR_MSTR */
                   if inv_count <> 0 then  do for cmmstr:
                      find cmmstr  where cmmstr.cm_domain = global_domain and
                      cmmstr.cm_addr = cm_mstr.cm_addr.
                      cmmstr.cm_avg_pay = days_late /  inv_count.
                      release cmmstr.
                   end.
                end. /* IF CALC_DAYS OR SHOW_DUN */

                find ad_mstr  where ad_mstr.ad_domain = global_domain and
                ad_addr = cm_addr no-lock.

                if page-size - line-counter < 2 then page.

/*L00M*BEGIN ADD*/
                /*DETERMINE CONVERTED AMOUNT*/
/*L02Q*         {etrpconv.i cm_balance   et_cm_balance  } */
/*L02Q*         {etrpconv.i cm_cr_limit  et_cm_cr_limit } */
/*L02Q*         {etrpconv.i cm_high_cr   et_cm_high_cr  } */

/*L02Q*/        if et_report_curr <> base_curr then do:
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input cm_balance,
                       input true,  /* ROUND */
                       output et_cm_balance,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input cm_cr_limit,
                       input true,  /* ROUND */
                       output et_cm_cr_limit,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input cm_high_cr,
                       input true,  /* ROUND */
                       output et_cm_high_cr,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/        end.  /* if et_report_curr <> base_curr */
/*L02Q*/        else assign
/*L02Q*/           et_cm_balance = cm_balance
/*L02Q*/           et_cm_cr_limit = cm_cr_limit
/*L02Q*/           et_cm_high_cr = cm_high_cr.

                assign et_cm_cr_limit = round( et_cm_cr_limit , 0).
/*L00M*END ADD*/

                display cm_addr cm_cr_terms
/*L00M*            cm_balance */
/*L00M*/           et_cm_balance
                   cm_pay_date cm_sale_date
/*L00M*            cm_cr_limit */
/*L00M*/           et_cm_cr_limit format ">>>,>>>,>>>,>>9" @ cm_cr_limit
                   cm_cr_rating
/*L00M*            cm_high_cr */
/*L00M*/           et_cm_high_cr
                   cm_high_date cm_cr_hold cm_fin cm_dun
                   cm_avg_pay WITH STREAM-IO /*GUI*/ .
                down 1.
                put ad_name at 3
/*L00M*/            et_report_curr to 36.
                if show_dun
                and high_dun_level <> 0 then
                   put high_dun_level at 118 skip.
                else
                   put skip.
                if cm_pay_date <> ? then accumulate cm_avg_pay(average).
                
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/


                if last(cm_sort)  then do:
                   underline cm_avg_pay.
                   display accum average  cm_avg_pay @ cm_avg_pay WITH STREAM-IO /*GUI*/ .
/*L02Q*/           put skip(1)
/*L02Q*/               mc-curr-label et_report_curr skip
/*L02Q*/               mc-exch-label mc-exch-line1 skip
/*L02Q*/               mc-exch-line2 at 22 skip(1).
                end.
             end. /*for each cm_mstr */

             /* REPORT TRAILER  */
             
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


          end. /* REPEAT: */

          {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" code code1 name name1 type type1 calc_days show_dun show_over  et_report_curr  "} /*Drive the Report*/
