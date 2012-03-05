/* glcrrpa.p - GENERAL LEDGER CUSTOM REPORT (PART II)                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/
/*V8:ConvertMode=Report                                                 */
/* REVISION: 4.0      LAST MODIFIED: 03/18/88   BY: JMS                 */
/*                                   04/08/88   BY: FLM  *A197*         */
/*                                   04/14/88   by: jms                 */
/*                                   05/10/88   by: jms  *A237*         */
/*                                   07/29/88   by: jms  *A373*         */
/*                                   10/11/88   by: jms  *A461*         */
/*                                   10/11/88   by: jms  *A476*         */
/*                                   11/08/88   by: jms  *A526*         */
/*                                   09/29/88   BY: RL   *C028*         */
/*                                   01/23/89   by: jms  *A622*         */
/*                                   02/17/89   by: jms  *A656*         */
/* REVISION: 5.0      LAST MODIFIED: 05/15/89   by: jms  *B066*         */
/*                                   05/16/89   BY: MLB  *B118*         */
/*                                   06/15/89   by: jms  *B147*         */
/*                                   06/15/89   by: jms  *B148*         */
/*                                   06/19/89   by: jms  *B154*         */
/*                                   07/06/89   by: jms  *B174*         */
/*                                   07/14/89   by: emb  *B184*         */
/*                                   09/27/89   by: jms  *B316*         */
/*                                   12/22/89   by: jms  *B470*         */
/*                                   04/18/90   by: jms  *B499*         */
/* REVISION: 6.0      LAST MODIFIED: 09/25/90   by: jms  *D034*         */
/*                                   11/07/90   by: jms  *D189*         */
/*                                   01/22/91   by: jms  *D330*         */
/*                                   07/23/91   by: jms  *D791*         */
/* REVISION: 7.0      LAST MODIFIED: 10/03/91   by: jms  *F058*         */
/*                                   02/26/92   by: jms  *F231*         */
/*                                   04/10/92   by: jms  *F374*         */
/*                                   06/16/92   by: jms  *F661*         */
/* REVISION: 8.6     LAST MODIFIED   10/11/97   by: ays   *K0TL*        */
/* REVISION: 8.6E    LAST MODIFIED:  02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E    LAST MODIFIED:  04/24/98   BY: LN/SVA  *L00S*      */
/* REVISION: 8.6E    LAST MODIFIED:  06/17/98   BY: *L01W* Brenda Milton*/
/* REVISION: 9.1     LAST MODIFIED:  07/17/00   BY: *N0G5* Mudit Mehta  */
/* REVISION: 9.1     LAST MODIFIED:  08/14/00   BY: *N0L1* Mark Brown   */
/* REVISION: 9.1     LAST MODIFIED:  09/14/05   BY: *SS - 20050914* Bill Jiang   */
/* Old ECO marker removed, but no ECO header exists *F873*              */

/* SS - 20050914 - B */
{a6glcrrp.i}
/* SS - 20050914 - E */

          {mfdeclre.i}
/*N0G5*/  {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glcrrpa_p_1 "Print Variances"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrpa_p_2 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrpa_p_3 "Suppress Account Numbers"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrpa_p_4 "Summarize Cost Centers"
/* MaxLen: Comment: */

/*N0G5*
 * &SCOPED-DEFINE glcrrpa_p_5 "TOTAL "
 * /* MaxLen: Comment: */
 *N0G5*/

&SCOPED-DEFINE glcrrpa_p_6 "Suppress Zero Amounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrpa_p_7 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrpa_p_8 "Round to Nearest Whole Unit"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrpa_p_9 "Round to Nearest Thousand"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          {wbrp02.i}

          define shared variable glname like en_name.
          define shared variable begdt as date extent 2.
          define shared variable enddt as date extent 2.
          define shared variable budget like mfc_logical extent 2.
          define shared variable zeroflag as logical
             label {&glcrrpa_p_6}.
          define shared variable ctr like cc_ctr.
          define shared variable ctr1 like cc_ctr.
          define shared variable level as integer
             format ">9" initial 99 label {&glcrrpa_p_2}.
          define shared variable varflag like mfc_logical
             initial yes label {&glcrrpa_p_1}.
          define shared variable ccflag like mfc_logical
             label {&glcrrpa_p_4}.
          define shared variable code like glr_code.
          define shared variable fiscal_yr as integer extent 2.
          define shared variable fiscal_yr1 as integer extent 2.
          define shared variable peryr as character format "x(8)".
          define shared variable per_end like glc_per extent 2.
          define shared variable per_beg like glc_per extent 2.
          define shared variable prtflag like mfc_logical initial yes
             label {&glcrrpa_p_3}.
          define shared variable entity like en_entity.
          define shared variable entity1 like en_entity.
          define shared variable cname like glname.
          define shared variable proj like gltr_project.
          define shared variable proj1 like gltr_project.
          define shared variable pl like co_pl.
          define shared variable ret like co_ret.
          define shared variable rpt_title like glr_title.
          define shared variable hdrstring as character format "x(18)"
             extent 2.
          define shared variable budgetcode like bg_code extent 2.
          define shared variable roundcnts like mfc_logical
             label {&glcrrpa_p_8}.
          define shared variable prt1000 like mfc_logical
             label {&glcrrpa_p_9}.
          define shared variable prtfmt as character format "x(30)".
          define shared variable prtfmt1 as character format "x(30)".
          define shared variable sub like sb_sub.
          define shared variable sub1 like sb_sub.
          define shared variable subflag like mfc_logical
             label {&glcrrpa_p_7}.
          define shared variable yr_end as date extent 2 no-undo.

          define new shared variable balance as decimal extent 2 no-undo.
          define new shared variable ac_recno as recid.
          define new shared variable g1_recno as recid.
          define new shared variable glrd_recno as recid.
          define new shared variable tot as decimal extent 100 no-undo.
          define new shared variable tot1 like tot no-undo.
          define new shared variable totflag as logical extent 100 no-undo.
          define new shared variable cur_level as integer.
          define new shared variable i as integer.
          define new shared variable xacc like ac_code.
          define new shared variable drflag like glrd_dr_cr.

          define variable record as recid extent 100 no-undo.
          define variable fpos like fm_fpos.
          define variable variance as decimal.
          define variable knt as integer.
          define variable accstrng as character format "x(14)".
          define variable cc like cc_ctr.
/*L01W*/  define shared variable rpt_curr like ac_curr.

/*L00S*BEGIN ADD*/
          {etrpvar.i  }
          {etvar.i    }
          define new shared variable et_tot as decimal extent 100 no-undo.
          define new shared variable et_tot1 as decimal extent 100 no-undo.
          define            variable et_variance as decimal.
          define new shared variable et_balance as decimal extent 2 no-undo.
          define            variable et_org_tot  as decimal extent 100 no-undo.
          define            variable et_org_tot1 as decimal extent 100 no-undo.
          define            variable et_org_variance as decimal.
/*L00S*END ADD*/

          define buffer g1 for glrd_det.



          /* CYCLE THROUGH FORMAT POSITION FILE */
          cur_level = 1.
          find first glrd_det use-index glrd_code
          where glrd_det.glrd_code = code and glrd_det.glrd_fpos <> 0 and
          glrd_det.glrd_sums = 0 no-lock no-error.
          glrd_recno = recid(glrd_det).

          loopa:
          repeat:

             if not available glrd_det then do:
                repeat:
                   cur_level = cur_level - 1.
                   if cur_level < 1 then leave.
                   find glrd_det where recid(glrd_det) = record[cur_level]
                   no-lock no-error.
                   glrd_recno = recid(glrd_det).
                   fpos = glrd_det.glrd_sums.
                   drflag = glrd_det.glrd_dr_cr.

                   for each g1 where g1.glrd_code = code and
                   g1.glrd_sums = glrd_det.glrd_fpos and
                   g1.glrd_acct <> ""
                   no-lock by g1.glrd_acct by g1.glrd_sub
                   by g1.glrd_cc
                   on endkey undo, leave loopa:
                      g1_recno = recid(g1).

                      for each ac_mstr where ac_code >= g1.glrd_acct and
                                             ac_code <= g1.glrd_acct1 no-lock
                      on endkey undo, leave loopa:
                         ac_recno = recid(ac_mstr).
                         xacc = ac_code.

                         /* CALCULATE BALANCE IF BOTH SUB-ACCTS AND COSTS CTRS
                            ARE SUMMARIZED */
                         if ccflag and subflag then do:
                             /* SS - 20050914 - B */
                             /*
                            {gprun.i ""glcrrpb.p""}
                                */
                                {gprun.i ""a6glcrrpb.p""}
                                /* SS - 20050914 - E */
                         end.

                         /* CALCULATE BALANCE IF SUB-ACCTS ARE SUMMARIZED */
                         else if subflag then do:
                            {gprun.i ""glcrrpc.p""}
                         end.

                         /* CALCULTE BALANCE IF COST CTRS ARE SUMMARIZED */
                         else if ccflag then do:
                            {gprun.i ""glcrrpd.p""}
                         end.

                         /*CALCULATE BALANCE FOR INDIVIDUAL ACCOUNTS */
                         else do:
                            {gprun.i ""glcrrpe.p""}
                         end.

                      end.  /* END OF AC_MSTR LOOP */
                   end.  /* END OF GLRD_DET LOOP */

                   if cur_level > 1 then
                      assign
                         tot[cur_level - 1] = tot[cur_level - 1] +
                                              tot[cur_level]
                         tot1[cur_level - 1] = tot1[cur_level - 1] +
                                               tot1[cur_level]
/*L00S*/                 et_tot[cur_level - 1] = et_tot[cur_level - 1] +
/*L00S*/                                         et_tot[cur_level]
/*L00S*/                 et_tot1[cur_level - 1] = et_tot1[cur_level - 1] +
/*L00S*/                                          et_tot1[cur_level].

                   if level >= cur_level then do:
                      if glrd_det.glrd_total = no or level = cur_level then do:
                         if totflag[cur_level] then do:
                             /* SS - 20050914 - B */
                             /*
                            put "--------------------" to 76
                                "--------------------" to 97.
                            if varflag then put "--------------------" to 118.
/*N0G5*                     put {&glcrrpa_p_5} at min(13, cur_level * 3 - 2) */
/*N0G5*/                    put {gplblfmt.i
                                 &FUNC=caps(getTermLabel(""TOTAL"",5))
                                 &CONCAT="' '"
                                } at min(13, cur_level * 3 - 2)
                                glrd_det.glrd_desc.
*/
                             CREATE tta6glcrrp.
                             ASSIGN
                                 tta6glcrrp_fpos = glrd_det.glrd_fpos
                                 tta6glcrrp_desc = glrd_det.glrd_desc
                                 .
/* SS - 20050914 - E */
                         end.

                         /* SS - 20050914 - B */
                         /*
                         assign variance = tot1[cur_level] - tot[cur_level]
/*L00S*/                 et_variance = et_tot1[cur_level] - et_tot[cur_level].
                         if glrd_det.glrd_dr_cr = false then
                            put
/*L00S*                        string( -     tot[cur_level], prtfmt) */
/*L00S*/                       string( -  et_tot[cur_level], prtfmt)
                               format "x(20)" to 76
/*L00S*                        string( -    tot1[cur_level], prtfmt) */
/*L00S*/                       string( - et_tot1[cur_level], prtfmt)
                               format "x(20)" to 97.
                         else put
/*L00S*                     string(    tot[cur_level], prtfmt) */
/*L00S*/                    string( et_tot[cur_level], prtfmt)
                            format "x(20)" to 76
/*L00S*                     string(    tot1[cur_level], prtfmt) */
/*L00S*/                    string( et_tot1[cur_level], prtfmt)
                            format "x(20)" to 97.
                         if varflag then put
/*L00S*                     string(   variance, prtfmt) */
/*L00S*/                    string( et_variance, prtfmt)
                            format "x(20)" to 118.
                         */

                         if glrd_det.glrd_dr_cr = false then
                             ASSIGN
                             tta6glcrrp_et_tot = - et_tot[cur_level]
                             tta6glcrrp_et_tot1 = - et_tot1[cur_level]
                             .
                         else 
                             ASSIGN
                             tta6glcrrp_et_tot = et_tot[cur_level]
                             tta6glcrrp_et_tot1 = et_tot1[cur_level]
                             .
                         /* SS - 20050914 - E */

/*L00S*BEGIN ADD*/
                         /* SS - 20050914 - B */
                         /*
                         if et_show_diff and not prt1000 and not roundcnts
                         and cur_level = 1  /* ONLY AT REPORT TOTALS */
                         then do:
/*L01W*                     {etrpconv.i tot[cur_level] et_org_tot[cur_level]} */
/*L01W*                     {etrpconv.i tot1[cur_level]  */
/*L01W*                                 et_org_tot1[cur_level]} */

/*L01W*/                    if et_report_curr <> rpt_curr then do:
/*L01W*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input tot[cur_level],
                                   input true,    /* ROUND */
                                   output et_org_tot[cur_level],
                                   output mc-error-number)"}
/*L01W*/                       if mc-error-number <> 0 then do:
/*L01W*/                          {mfmsg.i mc-error-number 2}
/*L01W*/                       end.
/*L01W*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input rpt_curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input tot1[cur_level],
                                   input true,    /* ROUND */
                                   output et_org_tot1[cur_level],
                                   output mc-error-number)"}
/*L01W*/                       if mc-error-number <> 0 then do:
/*L01W*/                          {mfmsg.i mc-error-number 2}
/*L01W*/                       end.
/*L01W*/                    end.  /* if et_report_curr <> rpt_curr */
/*L01W*/                    else
/*L01W*/                       assign et_org_tot[cur_level] = tot[cur_level]
/*L01W*/                              et_org_tot1[cur_level] = tot1[cur_level].

                            assign et_org_variance =
                               (et_org_tot1[cur_level] - et_org_tot[cur_level]).

                            /*CHECK WHETHER THERE IS A CONVERSION DIFFERENCE*/
                            if ((et_tot[cur_level] -
                            et_org_tot[cur_level]) <> 0) or
                            ((et_tot1[cur_level] -
                            et_org_tot1[cur_level]) <> 10) or
                            ((et_variance - et_org_variance) <> 0)
                            then do:
                               if glrd_det.glrd_dr_cr = false
                                  then put
                                     et_diff_txt at 1
                                     string( ( -1 * et_tot[cur_level] +
                                     et_org_tot[cur_level]), prtfmt)
                                     format "x(20)" to 76
                                     string(( -1 * et_tot1[cur_level] +
                                     et_org_tot1[cur_level]), prtfmt)
                                     format "x(20)" to 97.
                               else put
                                  et_diff_txt at 1
                                  string((   et_tot[cur_level] -
                                  et_org_tot[cur_level]), prtfmt)
                                  format "x(20)" to 76
                                  string(( et_tot1[cur_level] -
                                  et_org_tot1[cur_level]), prtfmt)
                                  format "x(20)" to 97.
                               if varflag
                                  then put
                                     string((et_variance - et_org_variance),
                                     prtfmt)
                                     format "x(20)" to 118.
                            end. /*IF CONVERSION DIFFERENCE*/
                         end. /* IF ET_SHOW_DIFF AND ET_TK_ACTIVE*/
/*L00S*END ADD*/

                         if glrd_det.glrd_underln then do:
                            put "====================" to 76
                                "====================" to 97.
                            if varflag then put "====================" to 118.
                         end.
                         if totflag[cur_level] and glrd_det.glrd_skip then
                            put skip(1).
                         */
                         /* SS - 20050914 - E */
                      end.  /* glrd_det.glrd_total = no or level = cur_level */
                      /* SS - 20050914 - B */
                      /*
                      if glrd_det.glrd_page then page.
                      */
                      /* SS - 20050914 - E */
                      if cur_level > 1 then totflag[cur_level - 1] = yes.
                   end.  /* if level > cur_level */

                   find next glrd_det use-index glrd_code
                   where glrd_det.glrd_code = code and
                   glrd_det.glrd_fpos <> 0
                   and glrd_det.glrd_sums = fpos no-lock no-error.
                   if available glrd_det then do:
                      glrd_recno = recid(glrd_det).
                      leave.
                   end.
                end.  /* repeat */
             end.  /* if not available glrd_det */
             if cur_level < 1 then leave.

             glrd_recno = recid(glrd_det).
             /* SS - 20050914 - B */
             /*
             if glrd_det.glrd_header = no and level >= cur_level then
                put glrd_det.glrd_desc at min(13, cur_level * 3 - 2).
             else if level = cur_level then put glrd_det.glrd_desc at
                min(13, cur_level * 3 - 2).
             */
             CREATE tta6glcrrp.
             ASSIGN
                 tta6glcrrp_fpos = glrd_det.glrd_fpos
                 tta6glcrrp_desc = glrd_det.glrd_desc
                 .
             /* SS - 20050914 - E */
             assign
                record[cur_level] = recid(glrd_det)
                tot[cur_level] = 0
                tot1[cur_level] = 0
                totflag[cur_level] = no
/*L00S*/        et_tot[cur_level] = 0
/*L00S*/        et_tot1[cur_level] = 0
                fpos = glrd_det.glrd_fpos.

             find first glrd_det use-index glrd_code
             where glrd_det.glrd_code = code and glrd_det.glrd_fpos <> 0 and
             glrd_det.glrd_sums = fpos no-lock no-error.
             if available glrd_det and cur_level < 100 then do:
                glrd_recno = recid(glrd_det).
                cur_level = cur_level + 1.
             end.
             else do:
                find glrd_det where recid(glrd_det) = record[cur_level]
                no-lock no-error.
                glrd_recno = recid(glrd_det).
                fpos = glrd_det.glrd_sums.
                drflag = glrd_det.glrd_dr_cr.

                for each g1 where g1.glrd_code = code and
                g1.glrd_sums = glrd_det.glrd_fpos and
                g1.glrd_acct <> "" no-lock by g1.glrd_acct
                by g1.glrd_sub by g1.glrd_cc
                on endkey undo, leave loopa:
                   g1_recno = recid(g1).

                   for each ac_mstr where ac_code >= g1.glrd_acct and
                                          ac_code <= g1.glrd_acct1
                   no-lock
                   on endkey undo, leave loopa:
                      ac_recno = recid(ac_mstr).
                      xacc = ac_code.

                      /* CALCULATE BALANCE IF BOTH SUB-ACCTS AND COSTS CTRS
                         ARE SUMMARIZED */
                      if ccflag and subflag then do:
                          /* SS - 20050914 - B */
                          /*
                         {gprun.i ""glcrrpb.p""}
                             */
                             {gprun.i ""a6glcrrpb.p""}
                             /* SS - 20050914 - E */
                      end.

                      /* CALCULATE BALANCE IF SUB-ACCTS ARE SUMMARIZED */
                      else if subflag then do:
                         {gprun.i ""glcrrpc.p""}
                      end.

                      /* CALCULTE BALANCE IF COST CTRS ARE SUMMARIZED */
                      else if ccflag then do:
                         {gprun.i ""glcrrpd.p""}
                      end.

                      /*CALCULATE BALANCE FOR INDIVIDUAL ACCOUNTS */
                      else do:
                         {gprun.i ""glcrrpe.p""}
                      end.

                   end. /* END AC_MSTR LOOP */
                end. /* END GLRD_DET LOOP */

                if cur_level > 1 then
                   assign
                      tot[cur_level - 1] = tot[cur_level - 1] +
                                           tot[cur_level]
                      tot1[cur_level - 1] = tot1[cur_level - 1] +
                                            tot1[cur_level]
/*L00S*/              et_tot[cur_level - 1] = et_tot[cur_level - 1] +
                                              et_tot[cur_level]
/*L00S*/              et_tot1[cur_level - 1] = et_tot1[cur_level - 1] +
/*L00S*/                                       et_tot1[cur_level].

                if level >= cur_level then do:
                   if glrd_det.glrd_total = no or level = cur_level then do:
                      if totflag[cur_level] then do:
                          /* SS - 20050914 - B */
                          /*
                         put "--------------------" to 76
                             "--------------------" to 97.
                         if varflag then put "--------------------" to 118.
/*N0G5*                  put {&glcrrpa_p_5} at min(13,cur_level * 3 - 2) */
/*N0G5*/                 put {gplblfmt.i
                              &FUNC=caps(getTermLabel(""TOTAL"",5))
                              &CONCAT="' '"
                             } at min(13,cur_level * 3 - 2)
                             glrd_det.glrd_desc.
*/
                          CREATE tta6glcrrp.
                          ASSIGN
                              tta6glcrrp_fpos = glrd_det.glrd_fpos
                              tta6glcrrp_desc = glrd_det.glrd_desc
                              .
/* SS - 20050914 - E */
                      end.

                      /* SS - 20050914 - B */
                      /*
                      assign variance = tot1[cur_level] - tot[cur_level]
/*L00S*/                 et_variance = et_tot1[cur_level] - et_tot[cur_level].

                      if glrd_det.glrd_dr_cr = false then
                         put
/*L00S*                     string( -    tot[cur_level], prtfmt) */
/*L00S*/                    string( - et_tot[cur_level], prtfmt)
                            format "x(20)" to 76
/*L00S*                     string( -    tot1[cur_level], prtfmt) */
/*L00S*/                    string( - et_tot1[cur_level], prtfmt)
                            format "x(20)" to 97.
                      else put
/*L00S*                  string(   tot[cur_level], prtfmt) */
/*L00S*/                 string(et_tot[cur_level], prtfmt)
                         format "x(20)" to 76
/*L00S*                  string(   tot1[cur_level], prtfmt) */
/*L00S*/                 string(et_tot1[cur_level], prtfmt)
                         format "x(20)" to 97.
                      if varflag then put
/*L00S*                  string(   variance, prtfmt) */
/*L00S*/                 string(et_variance, prtfmt)
                         format "x(20)" to 118.
                      */
                      if glrd_det.glrd_dr_cr = false then
                          ASSIGN
                          tta6glcrrp_et_tot = - et_tot[cur_level]
                          tta6glcrrp_et_tot1 = - et_tot1[cur_level]
                          .
                      else 
                          ASSIGN
                          tta6glcrrp_et_tot = et_tot[cur_level]
                          tta6glcrrp_et_tot1 = et_tot1[cur_level]
                          .
                      /* SS - 20050914 - E */

/*L00S*BEGIN ADD*/
                      /* SS - 20050914 - B */
                      /*
                      if et_show_diff and not roundcnts and not prt1000 and
                      cur_level <= 1
                      then do:
/*L01W*                  {etrpconv.i  tot[cur_level]  et_org_tot[cur_level]} */
/*L01W*                  {etrpconv.i  tot1[cur_level] et_org_tot1[cur_level]} */

/*L01W*/                 if et_report_curr <> rpt_curr then do:
/*L01W*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input rpt_curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input tot[cur_level],
                                input true,    /* ROUND */
                                output et_org_tot[cur_level],
                                output mc-error-number)"}
/*L01W*/                    if mc-error-number <> 0 then do:
/*L01W*/                       {mfmsg.i mc-error-number 2}
/*L01W*/                    end.
/*L01W*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input rpt_curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input tot1[cur_level],
                                input true,    /* ROUND */
                                output et_org_tot1[cur_level],
                                output mc-error-number)"}
/*L01W*/                    if mc-error-number <> 0 then do:
/*L01W*/                       {mfmsg.i mc-error-number 2}
/*L01W*/                    end.
/*L01W*/                 end.  /* if et_report_curr <> rpt_curr */
/*L01W*/                 else
/*L01W*/                    assign et_org_tot[cur_level] = tot[cur_level]
/*L01W*/                           et_org_tot1[cur_level] = tot1[cur_level].

                         assign et_org_variance =
                            (et_org_tot1[cur_level] - et_org_tot[cur_level]).

                         if ((et_tot[cur_level] - et_org_tot[cur_level]) <> 0)
                         or ((et_tot1[cur_level] - et_org_tot1[cur_level]) <> 0)
                         or (( et_variance - et_org_variance) <> 0)
                         then do:
                            if glrd_det.glrd_dr_cr = false then
                               put
                                  et_diff_txt at 1
                                  string( ( -1 * et_tot[cur_level] +
                                  et_org_tot[cur_level]), prtfmt)
                                  format "x(20)" to 76
                                  string(( -1 * et_tot1[cur_level] +
                                  et_org_tot1[cur_level]), prtfmt)
                                  format "x(20)" to 97.
                            else put
                               et_diff_txt at 1
                               string((   et_tot[cur_level] -
                               et_org_tot[cur_level]), prtfmt)
                               format "x(20)" to 76
                               string(( et_tot1[cur_level] -
                               et_org_tot1[cur_level]), prtfmt)
                               format "x(20)" to 97.

                           if varflag then put
                              string( et_variance - et_org_variance, prtfmt)
                              format "x(20)" to 118.
                        end. /*IF CONVERSION DIFFERENCE*/
                     end. /* IF ET_SHOW_DIFF */
/*L00S*END ADD*/

                     if glrd_det.glrd_underln then do:
                        put "====================" to 76
                            "====================" to 97.
                        if varflag then put "====================" to 118.
                     end.
                     if totflag[cur_level] and glrd_det.glrd_skip then
                        put skip(1).
                     */
                     /* SS - 20050914 - E */
                  end.
                  /* SS - 20050914 - B */
                  /*
                  if glrd_det.glrd_page then page.
                  */
                  /* SS - 20050914 - E */
                  if cur_level > 1 then totflag[cur_level - 1] = yes.
               end.  /* repeat */

               find next glrd_det use-index glrd_code
               where glrd_det.glrd_code = code and
               glrd_det.glrd_fpos <> 0 and
               glrd_det.glrd_sums = fpos no-lock no-error.
            end.  /* if not available glrd_det */

            {mfrpexit.i}
         end.  /* repeat */
         {wbrp04.i}
