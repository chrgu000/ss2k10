/* gl4inrpa.p - GENERAL LEDGER 4-COLUMN INCOME STATEMENT (PART II)           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* web convert gl4inrpa.p (converter v1.00) Fri Oct 10 13:57:40 1997         */
/* web tag in gl4inrpa.p (converter v1.00) Mon Oct 06 14:18:14 1997          */
/*F0PN*/ /*K0S5*/
/*V8:ConvertMode=Report                                                      */
/* REVISION: 4.0      LAST MODIFIED: 06/09/88   BY: JMS   *A275*             */
/*                                   09/23/88   by: jms   *A454*  (rev only) */
/*                                   10/10/88   by: jms   *A477*  (rev only) */
/*                                   11/08/88   by: jms   *A526*             */
/* REVISION: 5.0      LAST MODIFIED: 04/26/89   BY: JMS   *B066*             */
/*                                   06/19/89   by: jms   *B154*  (rev only) */
/*                                   09/19/89   by: jms   *B135*             */
/*                                   10/08/89   by: jms   *A789*  (rev only) */
/*                                   11/21/89   by: jms   *B400*  (rev only) */
/*                                   02/14/90   by: jms   *B499*  (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 10/15/90   by: jms   *D034*             */
/*                                   10/17/90   by: jms   *D103*             */
/*             (this portion of program split into glinrp1.p and glinrp1c.p) */
/*                                   11/07/90   by: jms   *D189*             */
/*                                   09/05/91   by: jms   *D849*             */
/* REVISION: 7.0      LAST MODIFIED: 11/12/91   by: jms   *F058*             */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   by: ays   *K0S5*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* Revision: 8.6E          MODIFIED: 03/12/98   By: *J23W*  Sachin Shah      */
/* REVISION: 8.6E     LAST MODIFIED: 04/24/98   BY: *L00M* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton     */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0VY* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 09/14/05   BY: *SS - 20050914* Bill Jiang       */

/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

         /* DISPLAY TITLE */
         {mfdeclre.i}
/*N0VY*/ {cxcustom.i "GL4INRPA.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gl4inrpa_p_1 "Round to Nearest Thousand"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl4inrpa_p_2 "Summarize Cost Centers"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          {wbrp02.i}

/*J23W*  no-undo added ** BEGIN */
         define shared variable begdt as date extent 4 no-undo.
         define shared variable enddt as date extent 4 no-undo.
         define shared variable budget as logical initial no extent 4 no-undo.
         define shared variable sub like sb_sub no-undo.
         define shared variable sub1 like sb_sub no-undo.
         define shared variable ctr like cc_ctr no-undo.
         define shared variable ctr1 like cc_ctr no-undo.
         define shared variable ccflag as logical initial no
            label {&gl4inrpa_p_2} no-undo.
         define shared variable entity like en_entity no-undo.
         define shared variable entity1 like en_entity no-undo.
         define shared variable fiscal_yr like glc_year extent 4 no-undo.
         define shared variable per_beg like glc_per extent 4 no-undo.
         define shared variable per_end like glc_per extent 4 no-undo.
         define shared variable ret like ac_code no-undo.
         define shared variable yr_end as date extent 4 no-undo.
         define shared variable income as decimal extent 4 no-undo.
         define shared variable rpt_curr like gltr_curr no-undo.
         define shared variable budgetcode like bg_code extent 4 no-undo.
         define shared variable prt1000 as logical
            label {&gl4inrpa_p_1} no-undo.
         define shared variable prtfmt as character format "x(30)" no-undo.

         define variable balance like gltr_amt no-undo.
         define variable knt as integer no-undo.
         define variable i as integer no-undo.
         define variable dt as date no-undo.
         define variable dt1 as date no-undo.
/*J23W*  no-undo added ** END */

/*L00M - BEGIN ADD*/
         /* *** DEFINITION OF EURO TOOLKIT VARIABLES */
         {etrpvar.i &new = " "}
         {etvar.i   &new = " "}
/*L00M - END ADD*/

         /* CALCULATE TOTAL INCOME AMOUNTS */
         do i = 1 to 4:
/*J23W*/    assign
               income[i] = 0.

            loopa:
            for each ac_mstr
/*N0VY*/    {&GL4INRPA-P-TAG1}
            fields (ac_code ac_curr)
/*N0VY*/    {&GL4INRPA-P-TAG2}
            where ac_type = "I" no-lock:

               for each asc_mstr
/*J23W*/       fields (asc_sub asc_acc asc_cc )
               where asc_acc = ac_code and
                     asc_sub >= sub and asc_sub <= sub1 and
                     asc_cc >= ctr and asc_cc <= ctr1
               no-lock:
                  if not budget[i] then do:
                     {glacbal1.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
                        &begdt=begdt[i] &enddt=enddt[i] &balance=balance
                        &yrend=yr_end[i] &rptcurr=rpt_curr &accurr=ac_curr}
                     assign income[i] = income[i] + balance.
                  end.

                  else do:
                     /* CALCULATE BUDGET AMOUNT FOR INCOME ACCTS */
                     {glacbg.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
                      &yr=fiscal_yr[i] &begper=per_beg[i] &endper=per_end[i]
                      &budget=balance &bcode=budgetcode[i]}
                     assign income[i] = income[i] + balance.
                  end.
               end.  /* for each asc_mstr */
            end.  /* for each ac_mstr */
            if budget[i] then do:
               for each bg_mstr
/*J23W*/       fields (bg_acc bg_code bg_fpos)
               where bg_code = budgetcode[i] and
                     bg_acc = ""
               use-index bg_ind1:

/*J23W**          find fm_mstr where fm_fpos = bg_fpos no-lock no-error. **/

/*J23W*/          for first fm_mstr fields (fm_fpos fm_type)
/*J23W*/          no-lock where fm_fpos = bg_fpos: end.

                  if available fm_mstr and fm_type = "I" then do:

/*J23W**             find first ac_mstr where ac_fpos = fm_fpos **/
/*J23W**             no-lock no-error. **/

/*J23W*/             for first ac_mstr fields (ac_code ac_curr
/*J23W*/             ac_fpos ac_type)
/*J23W*/             no-lock where ac_fpos = fm_fpos: end.

                     if available ac_mstr and ac_type = "I" then do:
                        {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[i]
                         &per=per_beg[i] &per1=per_end[i] &budget=balance
                         &bcode=budgetcode[i]}
/*J23W*/                assign
                           income[i] = income[i] + balance.
                     end.
                  end.  /* if available fm_mstr */
               end.  /* for each bg_mstr */
            end.  /* if budget[i] */

/*J23W*/    assign
               income[i] = - income[i].
/*L01W* /*L00M*/  {etrpconv.i income[i] income[i]} */
/*L01W*/    if et_report_curr <> rpt_curr then do:
/*L01W*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                 "(input rpt_curr,
                   input et_report_curr,
                   input et_rate1,
                   input et_rate2,
                   input income[i],
                   input true,  /* ROUND */
                   output income[i],
                   output mc-error-number)"}
/*L01W*/       if mc-error-number <> 0 then do:
/*L01W*/          {mfmsg.i mc-error-number 2}
/*L01W*/       end.
/*L01W*/    end.  /* if et_report_curr <> rpt_curr */

/* SS - 20050914 - B */
/*
            if prt1000 then assign income[i] = round(income[i] / 1000, 0).
            else assign income[i] = round(income[i], 0).
            */
            if prt1000 then assign income[i] = round(income[i] / 1000, 2).
            else assign income[i] = round(income[i], 2).
            /* SS - 20050914 - E */
         end.  /* do i = 1 to 4 */
         {wbrp04.i}
