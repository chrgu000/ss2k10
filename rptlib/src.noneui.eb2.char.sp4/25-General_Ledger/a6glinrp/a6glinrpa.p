/* glinrpa.p - GENERAL LEDGER INCOME STATEMENT REPORT (PART II)          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/*F0PN*/ /*K1DT*/
/*V8:ConvertMode=Report                                                  */
/* REVISION: 1.0      LAST MODIFIED: 12/03/86   BY: emb                  */
/*                                   06/18/87       jms                  */
/*                                   09/23/87       pml                  */
/*                                   01/25/88       jms                  */
/*                                   02/01/88   by: jms  CSR 24912       */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   by: jms                  */
/*                                   02/29/88   BY: WUG *A175*           */
/*                                   04/14/88   by: jms                  */
/*                                   06/13/88   by: jms *A274* (no-undo) */
/*                                   07/29/88   by: jms *A373*           */
/*                                   11/08/88   by: jms *A526*           */
/* REVISION: 5.0      LAST MODIFIED: 05/17/89   BY: JMS *B066*           */
/*                                   06/12/89   by: jms *B141*           */
/*                                   06/19/89   by: jms *B154*           */
/*                                   09/27/89   by: jms *B135*           */
/*                                   11/21/89   by: jms *B400*           */
/*                                   02/08/90   by: jms *B499*           */
/* REVISION: 6.0      LAST MODIFIED: 10/09/90   by: jms *D034*           */
/*                                   11/07/90   by: jms *D189*           */
/*                                   01/04/91   by: jms *D287*           */
/*                                   04/04/91   by: jms *D493*           */
/*                                   04/23/91   by: jms *D577*           */
/*                                   07/23/91   by: jms *D791*           */
/*                                   09/05/91   by: jms *D849*           */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   by: jms *F058*           */
/*                                   02/04/92   by: jms *F146*           */
/*                                   02/26/92   by: jms *F231*           */
/* REVISION: 7.3      LAST MODIFIED: 08/28/92   by: mpp *G030*           */
/*                                   09/15/92   by: jms *F890*           */
/* REVISION: 7.3      LAST MODIFIED: 07/12/93   by: pcd *GD36*           */
/* REVISION: 8.6      LAST MODIFIED: 12/15/97   by: bvm *K1DT*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 03/18/98   BY: *J242*   Sachin Shah */
/*J242* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00S* AWe           */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   BY: *L01W* Brenda Milton */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *N0G5* Mudit Mehta   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown    */
/* REVISION: 9.1      LAST MODIFIED: 10/24/00   BY: *N0T4* Manish K.     */
/* REVISION: 9.1      LAST MODIFIED: 09/22/05   BY: *SS - 20050922* Manish K.     */


          {mfdeclre.i}
/*N0G5*/  {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glinrpa_p_1 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrpa_p_2 "End of Period"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrpa_p_3 "Beginning of Period"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrpa_p_4 "Round to Nearest Thousand"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrpa_p_5 "Round to Nearest Whole Unit"
/* MaxLen: Comment: */

/*N0G5*
 * &SCOPED-DEFINE glinrpa_p_6 "TOTAL "
 * /* MaxLen: Comment: */
 *N0G5*/

&SCOPED-DEFINE glinrpa_p_7 "Summarize Cost Centers"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrpa_p_8 "Suppress Zero Amounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrpa_p_9 "Suppress Account Numbers"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrpa_p_10 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrpa_p_11 "Use Budgets"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          {wbrp02.i}

          define shared variable glname like en_name no-undo.
          define shared variable begdt like gltr_eff_dt
             label {&glinrpa_p_3} no-undo.
          define shared variable enddt like gltr_eff_dt label {&glinrpa_p_2}
             no-undo.
          define shared variable fiscal_yr like glc_year no-undo.
          define shared variable balance as decimal no-undo.
          define shared variable sub like sb_sub no-undo.
          define shared variable sub1 like sb_sub no-undo.
          define shared variable ctr like cc_ctr no-undo.
          define shared variable ctr1 like cc_ctr no-undo.
          define shared variable level as integer format ">9" initial 99
             label {&glinrpa_p_1} no-undo.
          define shared variable budgflag like mfc_logical
             label {&glinrpa_p_11} no-undo.
          define shared variable zeroflag like mfc_logical label
             {&glinrpa_p_8} no-undo.
          define shared variable ccflag like mfc_logical label
             {&glinrpa_p_7} no-undo.
          define shared variable subflag like mfc_logical
             label {&glinrpa_p_10} no-undo.
          define shared variable prtflag like mfc_logical initial yes
             label {&glinrpa_p_9} no-undo.
          define shared variable entity like en_entity no-undo.
          define shared variable entity1 like en_entity no-undo.
          define shared variable cname like glname no-undo.
          define shared variable yr_end as date no-undo.
          define shared variable ret like ac_code no-undo.
          define shared variable per_end like glc_per no-undo.
          define shared variable per_beg like glc_per no-undo.
          define shared variable rpt_curr like gltr_curr no-undo.
          define shared variable budgetcode like bg_code no-undo.
          define shared variable prt1000 like mfc_logical
             label {&glinrpa_p_4} no-undo.
          define shared variable roundcnts like mfc_logical
             label {&glinrpa_p_5} no-undo.
          define shared variable hdrstring as character format "x(8)" no-undo.
          define shared variable prtfmt as character format "x(30)" no-undo.
          define shared variable income like gltr_amt no-undo.
          define shared variable percent as decimal format "->>>9.9%" no-undo.

          define new shared variable xacc like ac_code no-undo.
          define new shared variable ac_recno as recid no-undo.
          define new shared variable fm_recno as recid no-undo.
          define new shared variable cur_level as integer no-undo.
          define new shared variable fmbgflag like mfc_logical no-undo.
          define new shared variable tot as decimal extent 100 no-undo.
          define new shared variable totflag like mfc_logical extent 100
             no-undo.

          define variable balance1 like balance no-undo.
          define variable crtot like balance1 no-undo.
          define variable record as recid extent 100 no-undo.
          define variable fpos like fm_fpos no-undo.
          define variable i as integer no-undo.
          define variable knt as integer no-undo.
          define variable dt as date no-undo.
          define variable dt1 as date no-undo.
          define variable xsub like sb_sub no-undo.
          define variable xcc like cc_ctr no-undo.
/*N0T4**  define variable account as character format "x(14)" no-undo. */
/*N0T4*/  define variable account as character format "x(22)" no-undo.
          define variable fmbgrecid as recid no-undo.

/*L00S - BEGIN ADD*/
/*        ***** DEFINE EURO TOOLKIT VARIABLES ***** */
          {etrpvar.i }
          {etvar.i   }
          define     shared variable et_income      like income    no-undo.
          define     shared variable et_balance     like balance   no-undo.
          define            variable et_balance1    like balance1  no-undo.
          define new shared variable et_tot         like tot       no-undo.
          define new shared variable et_crtot       like crtot     no-undo.
          /* VARIABLES FOR CALCULATING CONVERSION DIFFERENCE */
          define            variable et_conv_crtot  like crtot     no-undo.
          define            variable et_conv_tot    like tot       no-undo.
/*L00S - END ADD*/

          /* CYCLE THROUGH FORMAT POSITION FILE */
/*J242*/  assign cur_level = 1
                 fmbgflag = no.

/*J242**  find first fm_mstr use-index fm_fpos where fm_type = "I" **/
/*J242**  and fm_sums_into = 0 no-lock no-error. **/
/*J242*/  for first fm_mstr
/*J242*/  fields (fm_desc fm_dr_cr fm_fpos fm_header fm_page_brk
          fm_skip fm_sums_into fm_total fm_type fm_underln)
/*J242*/  use-index fm_fpos
/*J242*/  where fm_type = "I" and fm_sums_into = 0 no-lock: end.

          loopaa:
          repeat:

             if not available fm_mstr then do:
                repeat:
                   assign cur_level = cur_level - 1.
                   if cur_level < 1 then leave.
/*J242**           find fm_mstr where recid(fm_mstr) = record[cur_level] **/
/*J242**           no-lock no-error. **/
/*J242*/           for first fm_mstr
/*J242*/           fields (fm_desc fm_dr_cr fm_fpos fm_header fm_page_brk
                   fm_skip fm_sums_into fm_total fm_type fm_underln)
/*J242*/           no-lock where recid(fm_mstr) = record[cur_level]: end.
/*J242*/           assign
                      fpos = fm_sums_into
                      fm_recno = recid(fm_mstr).
/* SS - 20050922 - B */
/*
                      {gprun.i ""glinrpb.p""}
                          */
                          {gprun.i ""a6glinrpb.p""}
                          /* SS - 20050922 - E */
                   if fmbgflag and budgflag then do:
                      {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr &per=per_beg
                                &per1=per_end &budget=balance &bcode=budgetcode}

/*L00S
 *                    if prt1000 then balance = round(balance / 1000, 0).
 *                    else if roundcnts then balance = round(balance, 0).
 */

/*L00S                *** CONVERT AFTER ROUNDING *** */
/*L01W* /*L00S*/      {etrpconv.i balance et_balance} */
/*L01W*/              if et_report_curr <> rpt_curr then do:
/*L01W*/                 {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input rpt_curr,
                             input et_report_curr,
                             input et_rate1,
                             input et_rate2,
                             input balance,
                             input true,  /* ROUND */
                             output et_balance,
                             output mc-error-number)"}
/*L01W*/                 if mc-error-number <> 0 then do:
/*L01W*/                    {mfmsg.i mc-error-number 2}
/*L01W*/                 end.
/*L01W*/              end.  /* if et_report_curr <> rpt_curr */
/*L01W*/              else assign et_balance = balance.

/*L00S*/              if prt1000
                         then assign et_balance = round(et_balance / 1000, 0).
/*L00S*/              else if roundcnts
                         then assign et_balance = round(et_balance,0).

                      assign tot[cur_level] = balance
/*L00S*/                     et_tot[cur_level] = et_balance.
                   end.  /* if fmgbflag and budgflag */

                   if cur_level > 1 then
                      assign tot[cur_level - 1] = tot[cur_level - 1] +
                                                  tot[cur_level].

/*L00S*/           if cur_level > 1 then assign et_tot[cur_level - 1] =
/*L00S*/              et_tot[cur_level - 1] + et_tot[cur_level].

                   if level >= cur_level then do:
                      if fm_total = no or level = cur_level then do:
                         if not fmbgflag or fmbgrecid = recid(fm_mstr) then do:
                             /* SS - 20050922 - B */
                             /*
                            if totflag[cur_level] then
                               put "--------------------" to 77 "--------" at 79
/*N0G5*                            {&glinrpa_p_6} at min(16, cur_level * 3 - 2) */
/*N0T4** BEGIN DELETE **
 * /*N0G5*/                        {gplblfmt.i
 *                                  &FUNC=caps(getTermLabel(""TOTAL"",5))
 *                                   &CONCAT="' '"
 *                                  } at min(16, cur_level * 3 - 2)
 *N0T4** END DELETE */
/*N0T4*/                        {gplblfmt.i
                                  &FUNC=caps(getTermLabel(""TOTAL"",5))
                                  &CONCAT="' '"
                                  } at min(19, cur_level * 2 - 1)
                                   fm_desc.
                            else if fm_header then put fm_desc at
/*N0T4**                       min(16, cur_level * 3 - 2).      */
/*N0T4*/                       min(19, cur_level * 2 - 1).
                            */
                            /* SS - 20050922 - E */
                            if fm_dr_cr = false then do:
                               assign crtot = - tot[cur_level]
/*L00S*/                              et_crtot = - et_tot[cur_level].
/*L00S
 *                             if income <> 0 then
 *                                percent = crtot / income * 100.
 *                             put string(crtot, prtfmt) format "x(20)" to 77
 *                                 percent at 79.
 */
/*L00S - BEGIN ADD */
                               if et_income <> 0 then assign
                                  percent = et_crtot / et_income * 100.
                               /* SS - 20050922 - B */
                               /*
                               put string (et_crtot, prtfmt)
                                   format "x(20)" to 77 percent at 79.
                               */
                               /* SS - 20050922 - E */
/*L00S - END ADD   */

                            end.  /* if fm_dr_cr = false */
                            else do:
/*L00S
 *                             if income <> 0 then assign
 *                                percent = tot[cur_level] / income * 100.
 *                             put string(tot[cur_level], prtfmt)
 *                                 format "x(20)" to 77
 *                                 percent at 79.
 */
/*L00S - BEGIN ADD*/
                               if et_income <> 0 then assign percent =
                                  et_tot[cur_level] / et_income * 100.
                               /* SS - 20050922 - B */
                               /*
                               put string(et_tot[cur_level], prtfmt)
                                   format "x(20)" to 77 percent at 79.
                               */
                               /* SS - 20050922 - E */
/*L00S - END ADD*/
                            end.  /* else do */

/*L00S*ADD SECTION*/
                            if cur_level <= 1 and et_show_diff and
                            not prt1000 and not roundcnts and
                            et_report_curr <> "" then do:
/*L01W*                        {etrpconv.i tot[cur_level]  */
/*L01W*                                    et_conv_tot[cur_level]} */
/*L01W*/                       if et_report_curr <> rpt_curr then do:
/*L01W*/                          {gprunp.i "mcpl" "p" "mc-curr-conv"
                                    "(input rpt_curr,
                                      input et_report_curr,
                                      input et_rate1,
                                      input et_rate2,
                                      input tot[cur_level],
                                      input true,  /* ROUND */
                                      output et_conv_tot[cur_level],
                                      output mc-error-number)"}
/*L01W*/                          if mc-error-number <> 0 then do:
/*L01W*/                             {mfmsg.i mc-error-number 2}
/*L01W*/                          end.
/*L01W*/                       end.  /* if et_report_curr <> rpt_curr */
/*L01W*/                       else assign
/*L01W*/                          et_conv_tot[cur_level] = tot[cur_level].

/* SS - 20050922 - B */
/*
                               if et_conv_tot[cur_level] <> et_tot[cur_level]
                               then do:
                                  put et_diff_txt + ":" format "x(23)" to 24
                                      string ((et_conv_tot[cur_level] -
                                      et_tot[cur_level]), prtfmt)
                                      format "x(20)" to 77 skip.
                               end.
                               */
                               /* SS - 20050922 - E */
                            end.  /* if cur_level <= 1 and et_show_diffs */
/*L00S*END ADD SECTION*/

                            /* SS - 20050922 - B */
                            /*
                            if fm_underln then put "====================" to 77
                                                   "========" at 79.
                            if totflag[cur_level] and fm_skip then put skip(1).
                            */
                            /* SS - 20050922 - E */
                         end.  /* if not fmbgflag or fmbgrecid ... */
                      end.  /* if fm_total = no or level = cur_level */
                      /* SS - 20050922 - B */
                      /*
                      if fm_page_brk then page.
                      */
                      /* SS - 20050922 - E */
                      if cur_level > 1 then assign totflag[cur_level - 1] = yes.
                   end.  /* if level >= cur_level */

                   if fmbgrecid = recid(fm_mstr) then assign fmbgflag = no.
                   find next fm_mstr use-index fm_fpos where fm_type = "I"
                   and fm_sums_into = fpos no-lock no-error.
                   if available fm_mstr then leave.

                end.  /* repeat */
             end.  /* if not available fm_mstr */
             if cur_level < 1 then leave.

             /* SS - 20050922 - B */
             /*
             if fm_header = no and level >= cur_level then
/*N0T4**        put fm_desc at min(16, cur_level * 3 - 2). */
/*N0T4*/        put fm_desc at min(19, cur_level * 2 - 1).
             */
             /* SS - 20050922 - E */

/*J242*/     assign
                record[cur_level] = recid(fm_mstr)
                tot[cur_level] = 0
/*L00S*/        et_tot[cur_level] = 0
                totflag[cur_level] = no.

/*J242** BEGIN DELETE *** RESTRUCTURE FOR PERFORMANCE ***************
*            if budgflag then do:
*               find first bg_mstr where bg_code = budgetcode and
*                                        bg_entity >= entity and
*                                        bg_entity <= entity1 and
*                                        bg_acc = "" and bg_cc = "" and
*                                        bg_project = "" and
*                                        bg_fpos = fm_fpos no-lock no-error.
*               if available bg_mstr then do:
*J242********** END DELETE *****************************************/

/*J242* BEGIN ADD */
             if budgflag and
             can-find (first bg_mstr where bg_code = budgetcode and
                                           bg_entity >= entity and
                                           bg_entity <= entity1 and
                                           bg_acc = "" and bg_cc = "" and
                                           bg_project = "" and
                                           bg_fpos = fm_fpos )
             then assign
/*J242* END ADD */
                fmbgflag = yes
                fmbgrecid = recid(fm_mstr).
/*J242**     end. **/
/*J242**     end. **/

             assign fpos = fm_fpos.
/*J242**     find first fm_mstr use-index fm_fpos where fm_sums_into = fpos**/
/*J242**     and fm_type = "I" no-lock no-error.**/
/*J242*/     for first fm_mstr
/*J242*/     fields (fm_desc fm_dr_cr fm_fpos fm_header fm_page_brk
             fm_skip fm_sums_into fm_total fm_type fm_underln)
/*J242*/     use-index fm_fpos
/*J242*/     where fm_sums_into = fpos and fm_type = "I" no-lock: end.
             if available fm_mstr and cur_level < 100 then
                assign cur_level = cur_level + 1.
             else do:
/*J242**        find fm_mstr where recid(fm_mstr) = record[cur_level] **/
/*J242**        no-lock no-error. **/
/*J242*/        for first fm_mstr
/*J242*/        fields (fm_desc fm_dr_cr fm_fpos fm_header fm_page_brk
                fm_skip fm_sums_into fm_total fm_type fm_underln)
/*J242*/        no-lock where recid(fm_mstr) = record[cur_level]: end.
                assign fpos = fm_sums_into
                       fm_recno = recid(fm_mstr).

                /* SS - 20050922 - B */
                /*
                {gprun.i ""glinrpb.p""}
                    */
                    {gprun.i ""a6glinrpb.p""}
                    /* SS - 20050922 - E */

                if fmbgflag and budgflag then do:
                   {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr &per=per_beg
                             &per1=per_end &budget=balance &bcode=budgetcode}

/*L00S*
 *                 if prt1000 then balance = round(balance / 1000, 0).
 *                 else if roundcnts then balance = round(balance, 0).
 */

/*L01W* /*L00S*/   {etrpconv.i balance et_balance} */

/*L01W*/           if et_report_curr <> rpt_curr then do:
/*L01W*/              {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input rpt_curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input balance,
                          input true,  /* ROUND */
                          output et_balance,
                          output mc-error-number)"}
/*L01W*/              if mc-error-number <> 0 then do:
/*L01W*/                 {mfmsg.i mc-error-number 2}
/*L01W*/              end.
/*L01W*/           end.  /* if et_report_curr <> rpt_curr */
/*L01W*/           else assign
/*L01W*/              et_balance = balance.

/*L00S*/           if prt1000 then assign et_balance =
/*L00S*/              round(et_balance / 1000, 0).
/*L00S*/           else if roundcnts then assign et_balance =
/*L00S*/              round(et_balance, 0).

                   assign
/*L00S*/              et_tot[cur_level] = et_balance
                      tot[cur_level] = balance.
                end.  /* if fmbgflag and budgflag */

                if cur_level > 1 then
/*J242*/           assign
                      tot[cur_level - 1] = tot[cur_level - 1] + tot[cur_level].

/*L00S*/        if cur_level > 1 then assign et_tot[cur_level - 1] =
/*L00S*/           et_tot[cur_level - 1] + et_tot[cur_level].

                if level >= cur_level then do:
                   if fm_total = no or level = cur_level then do:
                      if not fmbgflag or fmbgrecid = recid(fm_mstr) then do:
                          /* SS - 20050922 - B */
                          /*
                         if totflag[cur_level] then
                            put "--------------------" to 77 "--------" at 79
/*N0G5*                         {&glinrpa_p_6} at min(16, cur_level * 3 - 2) */
/*N0T4** BEGIN DELETE **
 * /*N0G5*/                     {gplblfmt.i
 *                               &FUNC=caps(getTermLabel(""TOTAL"",5))
 *                               &CONCAT="' '"
 *                              } at min(16, cur_level * 3 - 2)
 *N0T4** END DELETE */
/*N0T4*/                     {gplblfmt.i
                               &FUNC=caps(getTermLabel(""TOTAL"",5))
                               &CONCAT="' '"
                              } at min(19, cur_level * 2 - 1)
                              fm_desc .
                         else if fm_header then put fm_desc at
/*N0T4**                    min(16, cur_level * 3 - 2).  */
/*N0T4*/                    min(19, cur_level * 2 - 1).
                         */
                         /* SS - 20050922 - E */
                         if fm_dr_cr = false then do:
                            assign
/*L00S*/                       et_crtot = - et_tot[cur_level]
                               crtot = - tot[cur_level].
/*L00S                      if income <> 0 then assign percent =
 *                             crtot / income * 100.
 *                          put string(crtot, prtfmt) format "x(20)" to 77
 *                              percent at 79.
 */
/*L00S - BEGIN ADD*/
                            if et_income <> 0 then assign
                               percent = et_crtot / et_income * 100.
                            /* SS - 20050922 - B */
                            /*
                            put string(et_crtot, prtfmt) format "x(20)" to 77
                                percent at 79.
                            */
                            /* SS - 20050922 - E */
/*L00S - END ADD*/
                         end.  /* if fm_dr_cr */
                         else do:
/*L00S                      if income <> 0 then
 *                             assign percent = tot[cur_level] / income * 100.
 *                          put string(tot[cur_level], prtfmt) format "x(20)"
 *                              to 77
 *                              percent at 79.
 */
/*L00S - BEGIN ADD*/
                            if et_income <> 0 then assign
                               percent = et_tot[cur_level] / et_income * 100.
                            /* SS - 20050922 - B */
                            /*
                            put string(et_tot[cur_level], prtfmt)
                                format "x(20)" to 77 percent  at 79.
                            */
                            /* SS - 20050922 - E */
/*L00S - END ADD*/
                         end.  /* else do */

/*L00S*ADD SECTION*/
                         if cur_level <= 1 and et_show_diff and
                         not prt1000 and not roundcnts
                         and et_report_curr <> "" then do:
/*L01W*                     {etrpconv.i tot[cur_level] et_conv_tot[cur_level]}*/
/*L01W*/                    if et_report_curr <> rpt_curr then do:
/*L01W*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input tot[cur_level],
                                   input true,  /* ROUND */
                                   output et_conv_tot[cur_level],
                                   output mc-error-number)"}
/*L01W*/                       if mc-error-number <> 0 then do:
/*L01W*/                          {mfmsg.i mc-error-number 2}
/*L01W*/                       end.
/*L01W*/                    end.  /* if et_report_curr <> rpt_curr */
/*L01W*/                    else assign
/*L01W*/                       et_conv_tot[cur_level] = tot[cur_level].

/* SS - 20050922 - B */
/*
                            if et_conv_tot[cur_level] <> et_tot[cur_level]
                            then do:
                               put et_diff_txt + ":" format "x(24)" to 24
                                   string ((et_conv_tot[cur_level] -
                                   et_tot[cur_level]), prtfmt)
                                   format "x(20)" to 77 skip.
                            end.
                            */
                            /* SS - 20050922 - E */
                         end.  /* if cur_level <= 1 and et_show_diff */
/*L00S*END ADD SECTION*/

                         /* SS - 20050922 - B */
                         /*
                         if fm_underln then put "====================" to 77
                                                "========" at 79.
                         if totflag[cur_level] and fm_skip then put skip(1).
                         */
                         /* SS - 20050922 - E */
                      end.  /* if not fmbgflag or fmbgrecid ... */
                   end.  /* if fm_total = no or level = cur_level */
                   /* SS - 20050922 - B */
                   /*
                   if fm_page_brk then page.
                   */
                   /* SS - 20050922 - E */
                   if cur_level > 1 then assign totflag[cur_level - 1] = yes.
                end.  /* if level >= cur_level */

                if fmbgrecid = recid(fm_mstr) then assign fmbgflag = no.
                find next fm_mstr use-index fm_fpos where fm_sums_into = fpos
                and fm_type = "I" no-lock no-error.
             end.  /* else do */

             {mfrpexit.i}
          end.  /* repeat */
          {wbrp04.i}
