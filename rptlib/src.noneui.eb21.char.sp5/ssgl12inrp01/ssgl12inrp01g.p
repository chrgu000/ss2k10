/* gl12inrg.p - GENERAL LEDGER 12-COLUMN INCOME STATEMENT (PART VIII)   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K1DS*/
/*V8:ConvertMode=Report                                        */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   by: jms   *F340*        */
/*                                   09/01/92   by: jms   *F890*        */
/*                                   09/13/96   by: jzw   *G2F9*        */
/* REVISION: 8.6      LAST MODIFIED: 12/15/97   by: bvm   *K1DS*        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E          MODIFIED: 03/12/98   By: *J23W* Sachin Shah  */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00S* D. Sidel     */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown    */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00   BY: *N0QF* Rajinder Kamra*/
/* $Revision: 1.13 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.13 $ BY: Bill Jiang DATE: 08/16/07 ECO: *SS - 20070816.1* */
/*-Revision end---------------------------------------------------------------*/


/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

          {mfdeclre.i}
/*N0QF*/  {gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gl12inrg_p_1 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inrg_p_2 "Round to Nearest Thousand"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inrg_p_3 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inrg_p_4 "Summarize Cost Centers"
/* MaxLen: Comment: */

&SCOPED-DEFINE gl12inrg_p_5 "Suppress Zero Amounts"
/* MaxLen: Comment: */

/*N0QF
 * &SCOPED-DEFINE gl12inrg_p_6 "TOTAL "
 * /* MaxLen: Comment: */
 *N0QF*/


/* ********** End Translatable Strings Definitions ********* */

          {wbrp02.i}

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
             initial no label {&gl12inrg_p_5} no-undo.
          define shared variable ctr like cc_ctr no-undo.
          define shared variable ctr1 like cc_ctr no-undo.
          define shared variable sub like sb_sub no-undo.
          define shared variable sub1 like sb_sub no-undo.
          define shared variable level as integer
             format ">9" initial 99 label {&gl12inrg_p_1} no-undo.
          define shared variable ccflag like mfc_logical
             label {&gl12inrg_p_4} no-undo.
          define shared variable subflag like mfc_logical
             label {&gl12inrg_p_3} no-undo.
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
             label {&gl12inrg_p_2} no-undo.
          define shared variable label1 as character format "x(12)"
             extent 12 no-undo.
          define shared variable label2 as character format "x(12)"
             extent 12 no-undo.
          define shared variable label3 as character format "X(12)"
             extent 12 no-undo.

          define shared variable balance as decimal
             format "(>>,>>>,>>>,>>9)" extent 12 no-undo.
          define shared variable fmbgflag as logical extent 12 no-undo.
/*J23W* no-undo added ** BEGIN */
          define shared variable ac_recno as recid no-undo.
          define shared variable fm_recno as recid no-undo.
/*J23W* no-undo added ** END */
          define shared variable totflag like mfc_logical extent 100
             no-undo.
          define shared variable tot1 as decimal extent 100 no-undo.
          define shared variable tot2 like tot1 no-undo.
          define shared variable tot3 like tot1 no-undo.
          define shared variable tot4 like tot1 no-undo.
          define shared variable tot5 like tot1 no-undo.
          define shared variable tot6 like tot1 no-undo.
          define shared variable tot7 like tot1 no-undo.
          define shared variable tot8 like tot1 no-undo.
          define shared variable tot9 like tot1 no-undo.
          define shared variable tot10 like tot1 no-undo.
          define shared variable tot11 like tot1 no-undo.
          define shared variable tot12 like tot1 no-undo.
/*J23W* no-undo added ** BEGIN */
          define shared variable xacc like ac_code no-undo.
          define shared variable cur_level as integer no-undo.
/*J23W* no-undo added ** END */
          define shared variable fpos like fm_fpos no-undo.

          define variable cramt as decimal format "(>>,>>>,>>>,>>9)" no-undo.
          define variable desc1 like ac_desc no-undo.
          define variable tot as decimal format "(>>,>>>,>>>,>>9)" extent 12
             no-undo.
          define variable pct as decimal format "->>>>.9%" no-undo.
/*J23W* no-undo added ** BEGIN */
          define variable i as integer no-undo.
/*J23W* no-undo added ** END */

/*L00S*ADD SECTION*/
          {etvar.i}
          {etrpvar.i}
/*L00S*END ADD SECTION*/

/*J23W**  find fm_mstr where recid(fm_mstr) = fm_recno no-lock.**/

/*J23W*/  for first fm_mstr
/*J23W*/      fields( fm_domain fm_fpos fm_desc fm_dr_cr fm_underln fm_page_brk
              fm_skip fm_total)
/*J23W*/      where recid(fm_mstr) = fm_recno no-lock: end.

          /* CHECK IF BUDGET FOR FORMAT POSITION EXISTS*/
          do i = 1 to 12:
/*J23W*/     assign
                fmbgflag[i] = no.

/*J23W****** RESTRUCTURE FOR PERFORMANCE *** BEGIN DELETE ****************
*            if budget[i] then do:
*               find first bg_mstr where bg_code = bcode[i] and
*               bg_fpos = fm_fpos and
*               bg_entity >= entity and
*               bg_entity <= entity1
*               no-lock use-index bg_ind1 no-error.
*               if available bg_mstr then fmbgflag[i] = yes.
*            end.
*J23W******************** END DELETE *************************************/

/*J23W* BEGIN ADD */
             if budget[i] and
             can-find (first bg_mstr  where bg_mstr.bg_domain = global_domain
             and  bg_code = bcode[i] and
                                           bg_fpos = fm_fpos and
                                           bg_entity >= entity and
                                           bg_entity <= entity1
                                           use-index bg_ind1)
                then assign fmbgflag[i] = yes.
/*J23W* END ADD */
          end.  /* do i = 1 to 12 */

          if can-find(first asc_mstr  where asc_mstr.asc_domain = global_domain
          and  asc_fpos = fm_fpos)
          then do:

             /* CALCULATE BALANCE IF BOTH SUB-ACCTS & COST CTRS */
             if ccflag and subflag then do:
                /* SS - 20070816.1 - B */
                /*
                {gprun.i ""gl12inrc.p""}
                */
                {gprun.i ""ssgl12inrp01c.p""}
                /* SS - 20070816.1 - E */
             end.

             /* CALCULATE BALANCE IF SUB-ACCTS ARE SUMMARIZED */
             else if subflag then do:
                {gprun.i ""gl12inrd.p""}
             end.

             /* CALCULATE BALANCE IF COST CTRS ARE SUMMARIZED */
             else if ccflag then do:
                {gprun.i ""gl12inre.p""}
             end.

             /* CALCULATE BALANCE FOR INDIVIDUAL ACCOUNTS */
             else do:
                /* SS - 20070816.1 - B */
                /*
                {gprun.i ""gl12inrf.p""}
                */
                {gprun.i ""ssgl12inrp01f.p""}
                /* SS - 20070816.1 - E */
             end.

          end. /* IF CAN-FIND FIRST ASC_MSTR */

          do i = 1 to 12:
             if fmbgflag[i] and budget[i] then do:
                {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[i] &per=per_beg[i]
                     &per1=per_end[i] &budget=balance[i] &bcode=bcode[i]}

/*L01W* /*L00S*/{etrpconv.i balance[i] balance[i]} */

/*L01W*/        if et_report_curr <> rpt_curr then do:
/*L01W*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input rpt_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input balance[i],
                       input true,    /* ROUND */
                       output balance[i],
                       output mc-error-number)"}
/*L01W*/           if mc-error-number <> 0 then do:
/*L01W*/              {mfmsg.i mc-error-number 2}
/*L01W*/           end.
/*L01W*/        end.  /* if et_report_curr <> rpt_curr */

                if prt1000 then balance[i] =
/*L00S             round(balance[i], 1000). */
                   /* SS - 20070816.1 - B */
                   /*
/*L00S*/           round(balance[i] / 1000, 0).
*/
/*L00S*/           round(balance[i] / 1000, 2).
                   /* SS - 20070816.1 - E */
                if i = 1 then assign tot1[cur_level] = balance[i].
                if i = 2 then assign tot2[cur_level] = balance[i].
                if i = 3 then assign tot3[cur_level] = balance[i].
                if i = 4 then assign tot4[cur_level] = balance[i].
                if i = 5 then assign tot5[cur_level] = balance[i].
                if i = 6 then assign tot6[cur_level] = balance[i].
                if i = 7 then assign tot7[cur_level] = balance[i].
                if i = 8 then assign tot8[cur_level] = balance[i].
                if i = 9 then assign tot9[cur_level] = balance[i].
                if i = 10 then assign tot10[cur_level] = balance[i].
                if i = 11 then assign tot11[cur_level] = balance[i].
                if i = 12 then assign tot12[cur_level] = balance[i].
             end.  /* if fmbgflag[i] and budget[i] */
          end.  /* do i = 1 to 12 */

          if cur_level > 1 then do:
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
             assign
                tot1[cur_level - 1] = tot1[cur_level - 1] + tot1[cur_level]
                tot2[cur_level - 1] = tot2[cur_level - 1] + tot2[cur_level]
                tot3[cur_level - 1] = tot3[cur_level - 1] + tot3[cur_level]
                tot4[cur_level - 1] = tot4[cur_level - 1] + tot4[cur_level]
                tot5[cur_level - 1] = tot5[cur_level - 1] + tot5[cur_level]
                tot6[cur_level - 1] = tot6[cur_level - 1] + tot6[cur_level]
                tot7[cur_level - 1] = tot7[cur_level - 1] + tot7[cur_level]
                tot8[cur_level - 1] = tot8[cur_level - 1] + tot8[cur_level]
                tot9[cur_level - 1] = tot9[cur_level - 1] + tot9[cur_level]
                tot10[cur_level - 1] = tot10[cur_level - 1] + tot10[cur_level]
                tot11[cur_level - 1] = tot11[cur_level - 1] + tot11[cur_level]
                tot12[cur_level - 1] = tot12[cur_level - 1] + tot12[cur_level].
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */
          end.  /* if cur_level > 1 */

          if level >= cur_level then do:
             if fm_total = no or level = cur_level then do:
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE */
                assign
                   tot[1] = tot1[cur_level]
                   tot[2] = tot2[cur_level]
                   tot[3] = tot3[cur_level]
                   tot[4] = tot4[cur_level]
                   tot[5] = tot5[cur_level]
                   tot[6] = tot6[cur_level]
                   tot[7] = tot7[cur_level]
                   tot[8] = tot8[cur_level]
                   tot[9] = tot9[cur_level]
                   tot[10] = tot10[cur_level]
                   tot[11] = tot11[cur_level]
                   tot[12] = tot12[cur_level].
/*J23W* END OF GROUPING FIELD ASSIGNMENTS */

                /* SS - 20070816.1 - B */
                /*
                if totflag[cur_level] then do:
                   do i = 1 to 12:
                      if actual[i] or budget[i] or variance[i] or varpct[i]
                      or incpct[i] then
                         put "----------------" to (51 + ((i - 1) * 17)).
                   end.  /* do i = 1 to 12 */
/*J23W*/           assign
/*N0QF                desc1 = substring(({&gl12inrg_p_6} + fm_desc), 1, 24). */
/*N0QF*/              desc1 = substring(caps((getTermLabel("TOTAL",5)) + " " + fm_desc), 1, 24).
                   put desc1 at min(9, ((cur_level - 1) * 2 + 1)).
                end.  /* if totflag[cur_level] */

                if not fm_dr_cr then do:
                   do i = 1 to 12:
                      if actual[i] or budget[i] then do:
/*J23W*/                 assign
                            cramt = - tot[i].
                         put cramt to 51 + ((i - 1) * 17).
                      end.
                      else if variance[i] then do:
/*J23W*/                 assign
                            cramt = - (tot[i - 2] - tot[i - 1]).
                         put cramt to 51 + ((i - 1) * 17).
                      end.
                      else if varpct[i] then do:
/*J23W*/                 assign
                            pct = 0.
                         if tot[i - 2] <> 0 then
/*J23W*/                    assign
                               pct = (tot[i - 1] / tot[i - 2]) * 100.
                         put pct to 51 + ((i - 1) * 17).
                      end.
                      else if incpct[i] then do:
/*J23W*/                 assign
                            pct = 0.
                         if income[i] <> 0 then
/*J23W*/                    assign
                               pct = - ((tot[i - 1] / income[i]) * 100).
                         put pct to 51 + ((i - 1) * 17).
                      end.
                   end.  /* do i = 1 to 12 */
                end.  /* if not fm_dr_cr */

                else do:
                   do i = 1 to 12:
                      if actual[i] or budget[i] then
                         put tot[i] to 51 + ((i - 1) * 17).
                      else if variance[i] then do:
/*J23W*/                 assign
                            cramt = tot[i - 2] - tot[i - 1].
                         put cramt to 51 + ((i - 1) * 17).
                      end.
                      else if varpct[i] then do:
/*J23W*/                 assign
                            pct = 0.
                         if tot[i - 2] <> 0 then
/*J23W*/                    assign
                               pct = (tot[i - 1] / tot[i - 2]) * 100.
                         put pct to 51 + ((i - 1) * 17).
                      end.
                      else if incpct[i] then do:
/*J23W*/                 assign
                            pct = 0.
                         if income[i] <> 0 then
/*J23W*/                    assign
                               pct = (tot[i - 1] / income[i]) * 100.
                         put pct to 51 + ((i - 1) * 17).
                      end.
                   end.  /* do i = 1 to 12 */
                end.  /* else do */

                if fm_underln then do i = 1 to 12:
                   if actual[i] or budget[i] or variance[i] or varpct[i] or
                   incpct[i] then
                      put "================" to (51 + ((i - 1) * 17)).
                end.
                if totflag[cur_level] and fm_skip then put skip(1).
                */
                /* SS - 20070816.1 - E */
             end.  /* if fm_total = no or level = cur_level */
             /* SS - 20070816.1 - B */
             /*
             if fm_page_brk then page.
             */
             /* SS - 20070816.1 - E */
             if cur_level > 1 then totflag[cur_level - 1] = yes.

          end.  /* if level >= cur_level */
          {wbrp04.i}
