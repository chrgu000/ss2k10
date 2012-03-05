/* gl12inra.p - GENERAL LEDGER 12-COLUMN INCOME STATEMENT (PART II)     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*                    SUBPROGRAM TO CALCULATE INCOME                    */
/* REVISION: 7.0      LAST MODIFIED: 03/31/92   by: jms  *F340*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/*                                   04/14/92   by: jms  *F396*         */
/* REVISION: 8.6E          MODIFIED: 03/12/98   By: *J23W* Sachin Shah  */
/* REVISION: 8.6E     LAST MODIFIED: 04/24/98   BY: *L00S* D. Sidel     */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown    */
/* $Revision: 1.10 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.10 $ BY: Bill Jiang DATE: 08/16/07 ECO: *SS - 20070816.1* */
/*-Revision end---------------------------------------------------------------*/


/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gl12inra_p_1 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inra_p_2 "Round to Nearest Thousand"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inra_p_3 "Summarize Cost Centers"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inra_p_4 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inra_p_5 "Suppress Zero Amounts"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          /* DISPLAY TITLE */
          {mfdeclre.i}

          define shared variable glname like en_name no-undo.
          define shared variable begdt as date extent 12 no-undo.
          define shared variable enddt as date extent 12 no-undo.
          define shared variable actual like mfc_logical extent 12 no-undo.
          define shared variable budget like mfc_logical extent 12 no-undo.
          define shared variable bcode as character format "x(8)" extent 12
             no-undo.
          define shared variable variance like mfc_logical extent 12 no-undo.
          define shared variable varpct like mfc_logical extent 12 no-undo.
          define shared variable incpct like mfc_logical extent 12 no-undo.
          define shared variable zeroflag like mfc_logical
             initial no label {&gl12inra_p_5} no-undo.
          define shared variable ctr like cc_ctr no-undo.
          define shared variable ctr1 like cc_ctr no-undo.
          define shared variable sub like sb_sub no-undo.
          define shared variable sub1 like sb_sub no-undo.
          define shared variable level as integer
             format ">9" initial 99 label {&gl12inra_p_1} no-undo.
          define shared variable ccflag like mfc_logical
             label {&gl12inra_p_3} no-undo.
          define shared variable subflag like mfc_logical
             label {&gl12inra_p_4} no-undo.
          define shared variable entity like en_entity no-undo.
          define shared variable entity1 like en_entity no-undo.
          define shared variable cname like glname no-undo.
          define shared variable fiscal_yr like glc_year extent 12 no-undo.
          define shared variable per_beg like glc_per extent 12 no-undo.
          define shared variable per_end like glc_per extent 12 no-undo.
          define shared variable ret like ac_code no-undo.
          define shared variable yr_end as date extent 12 no-undo.
          define shared variable income as decimal extent 12 no-undo.
          define shared variable rpt_curr like gltr_curr no-undo.
          define shared variable prt1000 like mfc_logical
             label {&gl12inra_p_2} no-undo.
          define shared variable label1 as character format "x(12)"
             extent 12 no-undo.
          define shared variable label2 as character format "x(12)"
             extent 12 no-undo.
          define shared variable label3 as character format "X(12)"
             extent 12 no-undo.

          define variable balance like gltr_amt no-undo.
          define variable knt as integer no-undo.
          define variable i as integer no-undo.
          define variable j as integer no-undo.
          define variable dt as date no-undo.
          define variable dt1 as date no-undo.

/*L00S*ADD SECTION*/
          {etvar.i}
          {etrpvar.i}
/*L00S*END ADD SECTION*/

          /* CALCULATE TOTAL INCOME AMOUNTS */
          do i = 1 to 12:
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
             assign
                j = i - 1
                income[i] = 0.
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */
             if incpct[i] and i > 1 then do:
                loopa:
                for each ac_mstr
                fields( ac_domain ac_code ac_curr ac_fpos ac_type)
                 where ac_mstr.ac_domain = global_domain and  ac_type = "I"
                 no-lock:
                   for each asc_mstr
/*J23W*/           fields( asc_domain asc_acc asc_sub asc_cc)
                    where asc_mstr.asc_domain = global_domain and  asc_acc =
                    ac_code and
                   asc_sub >= sub and asc_sub <= sub1 and
                   asc_cc >= ctr and asc_cc <= ctr1 no-lock:
                      if actual[j] then do:
                         {glacbal1.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
                                     &begdt=begdt[j] &enddt=enddt[j]
                                     &balance=balance &yrend=yr_end[j]
                                     &rptcurr=rpt_curr &accurr=ac_curr}
                         assign income[i] = income[i] + balance.
                      end.  /* if actual[j] */

                      else if budget[j] then do:
                         /* CALCULATE BUDGET AMOUNT FOR INCOME ACCTS */
                         {glacbg.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
                                   &yr=fiscal_yr[j] &begper=per_beg[j]
                                   &endper= per_end[j] &budget=balance
                                   &bcode=bcode[j]}
                         assign income[i] = income[i] + balance.
                      end.  /* else if budjet[j] */
                   end.  /* for each asc_mstr */
                end.  /* for each ac_mstr */

                if budget[j] then do:
                   for each bg_mstr
/*J23W*/           fields( bg_domain bg_acc bg_code bg_fpos)
                    where bg_mstr.bg_domain = global_domain and  bg_code =
                    bcode[j] and
                   bg_acc = "" no-lock use-index bg_ind1:
/*J23W**              find fm_mstr where fm_fpos = bg_fpos no-lock no-error.**/

/*J23W*/              for first fm_mstr
/*J23W*/              fields( fm_domain fm_fpos fm_type)
/*J23W*/              no-lock  where fm_mstr.fm_domain = global_domain and
fm_fpos = bg_fpos: end.
                      if available fm_mstr and fm_type = "I" then do:
/*J23W**                 find first ac_mstr where ac_fpos = fm_fpos **/
/*J23W**                 no-lock no-error. **/

/*J23W*/                 for first ac_mstr
                         fields( ac_domain ac_code ac_curr ac_fpos ac_type)
/*J23W*/                 no-lock  where ac_mstr.ac_domain = global_domain and
ac_fpos = fm_fpos: end.
                         if available ac_mstr and ac_type = "I" then do:
                            {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[j]
                                      &per=per_beg[j] &per1=per_end[j]
                                      &budget=balance &bcode=bcode[j]}
                            assign income[i] = income[i] + balance.
                         end.  /* if available ac_mstr */
                      end.  /* if available fm_mstr */
                   end.  /* for each bg_mstr */
                end.  /* if budget[j] */
                assign income[i] = - income[i].

/*L01W* /*L00S*/ {etrpconv.i income[i] income[i]} */

/*L01W*/        if et_report_curr <> rpt_curr then do:
/*L01W*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input rpt_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input income[i],
                       input true,  /* ROUND */
                       output income[i],
                       output mc-error-number)"}
/*L01W*/           if mc-error-number <> 0 then do:
/*L01W*/              {mfmsg.i mc-error-number 2}
/*L01W*/           end.
/*L01W*/        end.  /* if et_report_curr <> rpt_curr */

/* SS - 20070816.1 - B */
/*
                if prt1000 then assign income[i] = round(income[i] / 1000, 0).
                else assign income[i] = round(income[i], 0).
                */
                if prt1000 then assign income[i] = round(income[i] / 1000, 2).
                else assign income[i] = round(income[i], 2).
/* SS - 20070816.1 - E */
             end.  /* if incpct[i] and i > 1 */
          end.  /* do i = 1 to 12 */
