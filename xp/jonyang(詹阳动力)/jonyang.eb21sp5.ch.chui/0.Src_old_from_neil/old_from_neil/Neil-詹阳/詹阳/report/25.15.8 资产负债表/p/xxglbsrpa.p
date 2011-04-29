/* glbsrpa.p - GENERAL LEDGER BALANCE SHEET REPORT (PART II)               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/*F0PN*/ /*K0V3*/
/*V8:ConvertMode=Report                                                    */
/* REVISION: 1.0      LAST MODIFIED: 12/03/86   BY: emb                    */
/*                                   06/18/87       jms                    */
/*                                   01/25/88       jms                    */
/*                                   02/02/88   by: jms  CSR 24912         */
/* REVISION: 4.0      LAST MODIFIED: 02/26/88   BY: JMS                    */
/*                                   02/29/88   BY: WUG *A175*             */
/*                                   04/11/88   by: jms                    */
/*                                   06/13/88   by: jms  *A274* (no-undo)  */
/*                                   07/29/88   by: jms  *A373*            */
/*                                   08/19/88   by: jms  *A402*            */
/*                                   09/26/88   BY: RL  *C0028*            */
/*                                   10/26/88   BY: JMS  *A506* (REV ONLY) */
/*                                   11/08/88   BY: JMS  *A526*            */
/*                                   02/23/89   BY: JMS  *A713*            */
/* REVISION: 5.0      LAST MODIFIED: 05/15/89   BY: JMS  *B066*            */
/*                                   05/16/89   BY: MLB  *B118*            */
/*                                   06/02/89   by: jms  *B141*            */
/*                                   06/19/89   by: jms  *B154*            */
/*                                   09/27/89   by: jms  *B135*            */
/*                                   11/21/89   by: jms  *B400*            */
/*                                   02/14/90   by: jms  *B499*            */
/*                                   06/07/90   by: jms  *B704*            */
/* REVISION: 6.0      LAST MODIFIED: 10/09/90   by: jms  *D034*            */
/*                                   11/07/90   by: jms  *D189*            */
/*                                   01/04/91   by: jms  *D287*            */
/*                                   04/04/91   by: jms  *D493*            */
/*                                   04/23/91   by: jms  *D577*            */
/*                                   07/22/91   by: jms  *D791*            */
/*                                   09/05/91   by: jms  *D849*            */
/* REVISION: 7.0      LAST MODIFIED: 11/08/91   by: jms  *F058*            */
/*                                   01/31/91   by: jms  *F119*            */
/*                                   02/26/92   by: jms  *F231*            */
/*                                   08/26/82   by: mpp  *F863*            */
/* REVISION: 7.3      LAST MODIFIED: 08/14/92   by: mpp  *G030* maj rewrite*/
/*                                   09/11/92   by: jms  *F890*            */
/*                                   11/08/94   by: srk  *GO05*            */
/* REVISION 8.6       LAST MODIFIED  10/13/97   by: ays  *K0V3*            */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 03/19/98   by: *J240* Kawal Batra     */
/* REVISION: 8.6E     LAST MODIFIED: 04/20/98   BY: *J2HN* Samir Bavkar    */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *L00S* CPD/EJ          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton   */
/* REVISION: 8.6E     LAST MODIFIED: 08/06/98   BY: *L05G* Brenda Milton   */
/* REVISION: 9.1      LAST MODIFIED: 09/27/99   BY: *M0F1* Annasaheb Rahane*/
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00   BY: *N0QF* Mudit Mehta     */
/* REVISION: 9.1      LAST MODIFIED: 10/24/00   BY: *N0T4* Jyoti Thatte    */
/* $Revision: 1.16 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090708.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/


/*J240********** GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND FOR SMALLER r-CODE *******J240*/

          {mfdeclre.i}
/*N0QF*/  {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glbsrpa_p_1 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE glbsrpa_p_4 "Suppress Zero Amounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glbsrpa_p_5 "Suppress Account Numbers"
/* MaxLen: Comment: */

&SCOPED-DEFINE glbsrpa_p_6 "Summarize Cost Centers"
/* MaxLen: Comment: */

&SCOPED-DEFINE glbsrpa_p_7 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glbsrpa_p_8 "Use Budgets"
/* MaxLen: Comment: */

&SCOPED-DEFINE glbsrpa_p_9 "Round to Nearest Whole Unit"
/* MaxLen: Comment: */

&SCOPED-DEFINE glbsrpa_p_10 "Round to Nearest Thousand"
/* MaxLen: Comment: */

&SCOPED-DEFINE glbsrpa_p_11 "Report Ending Date"
/* MaxLen: Comment: */

/*N0QF***********BEGIN COMMENTING*************
 * &SCOPED-DEFINE glbsrpa_p_2 "Discrepancy Due to Rounding"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glbsrpa_p_3 "TOTAL "
 * /* MaxLen: Comment: */
 *
 * /*M0F1* *** Begin Add Code *** */
 * &SCOPED-DEFINE glbsrpa_p_12 " (Rounded)"
 * /* MaxLen:10  Comment: Value rounded to certain digits */
 * /*M0F1* *** End Add Code *** */
 *N0QF***********END COMMENTING************* */

/* ********** End Translatable Strings Definitions ********* */

         define shared variable glname like en_name  no-undo.
         define shared variable rptdt like gltr_eff_dt
            label {&glbsrpa_p_11}  no-undo.
         define shared variable level as integer format ">9" initial 99
            label {&glbsrpa_p_1}  no-undo.
         define shared variable pl_amt as decimal no-undo.
         define shared variable yr_beg as date no-undo.
         define shared variable yr_end as date no-undo.
         define shared variable fiscal_yr as integer no-undo.
         define shared variable peryr as character format "x(8)" no-undo.
         define shared variable per_end like glc_per no-undo.
         define shared variable per_beg like glc_per no-undo.
         define shared variable zeroflag like mfc_logical
            label {&glbsrpa_p_4}  no-undo.
         define shared variable budgflag like mfc_logical
            label {&glbsrpa_p_8}  no-undo.
         define shared variable ccflag like mfc_logical
            label {&glbsrpa_p_6}  no-undo.
         define shared variable subflag like mfc_logical
            label {&glbsrpa_p_7}  no-undo.
         define shared variable prtflag like mfc_logical initial true
            label {&glbsrpa_p_5}  no-undo.
         define shared variable pl_cc like mfc_logical  no-undo.
         define shared variable pl like co_pl  no-undo.
         define shared variable ret like co_ret  no-undo.
         define shared variable entity like en_entity  no-undo.
         define shared variable entity1 like en_entity  no-undo.
         define shared variable entity0 like en_entity  no-undo.
         define shared variable cname like glname  no-undo.
         define shared variable hdrstring as character format "x(14)"  no-undo.
         define shared variable sub like sb_sub  no-undo.
         define shared variable sub1 like sb_sub  no-undo.
         define shared variable ctr like cc_ctr  no-undo.
         define shared variable ctr1 like cc_ctr  no-undo.
         define shared variable balance as decimal no-undo.
         define shared variable knt as integer  no-undo.
         define shared variable rpt_curr like gltr_curr  no-undo.
         define shared variable budgetcode like bg_code  no-undo.
         define shared variable prt1000 as logical
            label {&glbsrpa_p_10}  no-undo.
         define shared variable roundcnts as logical
            label {&glbsrpa_p_9}  no-undo.
         define shared variable prtfmt as character format "x(30)"  no-undo.
         define shared variable per_end_dt as date  no-undo.
         define shared variable per_end_dt1 as date  no-undo.

         define new shared variable ac_recno as recid  no-undo.
         define new shared variable fmbgflag like mfc_logical  no-undo.
         define new shared variable fm_recno as recid  no-undo.
         define new shared variable xacc like ac_code  no-undo.
         define new shared variable cur_level as integer  no-undo.
         define new shared variable tot as decimal extent 100 no-undo.
         define new shared variable totflag as logical extent 100 no-undo.

         define new shared variable balance1 like balance  no-undo.
         define variable crtot like balance1 no-undo.
         define variable skpflag as logical no-undo.
         define variable record as recid extent 100 no-undo.
         define variable fpos like fm_fpos no-undo.
         define variable roundamt as decimal  no-undo.
         define variable rounderr as decimal format "(>>>,>>>,>>>,>>9)"
            no-undo.
/*N0QF*
 *       define variable roundmsg as character format "x(30)" initial
 *          {&glbsrpa_p_2}  no-undo.
 *N0QF*/
/*N0QF*/ define variable roundmsg as character format "x(30)" no-undo.
         define variable roundflag as logical  no-undo.
         define variable dt as date  no-undo.
         define variable dt1 as date  no-undo.
         define variable xper like glc_per  no-undo.
/*N0T4** define new shared variable account as character format "x(14)" */
/*N0T4*/ define variable account as character format "x(22)"
            no-undo.
         define variable xsub like sb_sub  no-undo.
         define variable xcc like cc_ctr  no-undo.
         define variable fmbgrecid as recid  no-undo.

         define buffer a1 for ac_mstr.

/*L00S*ADD SECTION*/
         {etvar.i}   /* common euro variables */
         {etrpvar.i} /* common euro report variables */
         define new shared variable et_tot      like tot.
         define new shared variable et_balance  like balance.
         define            variable et_roundamt like roundamt.
         define            variable et_crtot    like crtot.
/*L00S*END ADD SECTION*/

/*N0QF*/ assign
          roundmsg = getTermLabel("DISCREPANCY_DUE_TO_ROUNDING",30).

         {wbrp02.i}

         /* CYCLE THROUGH FORMAT POSITION FILE */
         assign
            roundflag = no
            cur_level = 1
            fmbgflag = no.

/*J240** find first fm_mstr use-index fm_fpos where fm_type = "B" **/
/*J240**    and fm_sums_into = 0 no-lock no-error.                **/
/*J240*/ for first fm_mstr fields( fm_domain fm_desc fm_dr_cr fm_fpos fm_header
/*J240*/ fm_page_brk fm_skip fm_sums_into
/*J240*/ fm_total fm_type fm_underln )
/*J240*/ use-index fm_fpos no-lock  where fm_mstr.fm_domain = global_domain and
 fm_type = "B"
/*J240*/ and fm_sums_into = 0: end.

         loopa:
         repeat:

            if not available fm_mstr then do:
               repeat:
                  assign cur_level = cur_level - 1.
                  if cur_level < 1 then leave.
/*J240**          find fm_mstr where recid(fm_mstr) = record[cur_level] **/
/*J240**             no-lock no-error.                                  **/
/*J240*/          for first fm_mstr fields( fm_domain fm_desc fm_dr_cr fm_fpos
/*J240*/          fm_header fm_page_brk fm_skip fm_sums_into
/*J240*/          fm_total fm_type fm_underln)
/*J240*/          no-lock where recid(fm_mstr) = record[cur_level]: end.

                  assign
                     fpos = fm_sums_into
                     fm_recno = recid(fm_mstr).

/* SS 090708.1 - B */
/*
                  {gprun.i ""glbsrpb.p"" "(subflag, ccflag)"}
*/
                  {gprun.i ""xxglbsrpb.p"" "(subflag, ccflag)"}
/* SS 090708.1 - E */
                  if keyfunction(lastkey) = "end-error" then
                     undo, leave loopa.
                  if fmbgflag = yes then do:
                     {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr &per=per_beg
                      &per1=per_end &budget=balance &bcode=budgetcode}

/*L01W* /*L00S*/  {etrpconv.i balance et_balance} */

/*L01W*/          if et_report_curr <> rpt_curr then do:
/*L01W*/             {gprunp.i "mcpl" "p" "mc-curr-conv"
                       "(input rpt_curr,
                         input et_report_curr,
                         input et_rate1,
                         input et_rate2,
                         input balance,
                         input true,    /* ROUND */
                         output et_balance,
                         output mc-error-number)"}
/*L01W*/             if mc-error-number <> 0 then do:
/*L01W*/                {mfmsg.i mc-error-number 2}
/*L01W*/             end.
/*L01W*/          end.  /* if et_report_curr <> rpt_curr */
/*L01W*/          else assign et_balance = balance.

                  if prt1000 then assign balance = round(balance / 1000, 0).
                  else if roundcnts then assign balance = round(balance, 0).
                  assign tot[cur_level] = balance.
/*L00S*ADD SECTION*/
                  if prt1000 then et_balance = round(et_balance / 1000, 0).
                  else if roundcnts then et_balance = round(et_balance, 0).
                  et_tot[cur_level] = et_balance.
/*L00S*END ADD SECTION*/
               end.

               if cur_level > 1 then
/*L00S*/       do:
                  assign tot[cur_level - 1] =
                         tot[cur_level - 1] + tot[cur_level].
/*L00S*/          et_tot[cur_level - 1] =
/*L00S*/             et_tot[cur_level - 1] + et_tot[cur_level].
/*L00S*/       end.
               else do:
                  if not roundflag then do:
                     assign
                        roundamt = tot[cur_level]
/*L00S*/                et_roundamt = et_tot[cur_level]
                        roundflag = yes.
                  end.
                  else do:
                     assign rounderr = roundamt + tot[cur_level].
/*L00S*/                    rounderr = et_roundamt + et_tot[cur_level].
                     if (roundcnts or prt1000) and rounderr <> 0 and
                     rounderr < 5 and rounderr > -5
/*L00S*/             and not prt1000
/*L00S*/             and not roundcnts
                     then do:
                        put roundmsg at 4
                            rounderr to 77.
/*L00S                  assign tot[cur_level] = tot[cur_level] - rounderr. */
/*L05G*/                assign
/*L00S*/                   tot[cur_level] = - roundamt
/*L00S*/                   et_tot[cur_level] = et_tot[cur_level] - rounderr.
                     end.
                  end.  /* else do */
               end.  /* else do */

               if level >= cur_level then do:
                  if fm_total = no or level = cur_level then do:
                     if not fmbgflag or fmbgrecid = recid(fm_mstr) then do:
                        if totflag[cur_level] then
/*J2HN*/                   /* TOTAL'S DESCRIPTION IS DISPLAYED USING */
/*J2HN*/                   /* EXPLICIT POSITION SO THAT DESCRIPTION  */
/*J2HN*/                   /* IS NOT TRUNCATED, WHEN THE OUTPUT IS   */
/*J2HN*/                   /* TERMINAL.                              */

                           put "--------------------" to 77
/*N0QF*                        {&glbsrpa_p_3} at min(16, cur_level * 3 - 2) */

/*N0T4* BEGIN DELETE **
 * /*N0QF*/                       {gplblfmt.i
 *                                 &FUNC=caps(getTermLabel(""TOTAL"",8))
 *                                 &CONCAT = "' '"
 *                                } at min(16, cur_level * 3 - 2)
 * /*J2HN**                       fm_desc. */
 * /*J2HN*/                       fm_desc at min(22, cur_level * 3 + 4).
 *N0T4* END DELETE */

/*N0T4*/                       {gplblfmt.i
                                 &FUNC=caps(getTermLabel(""TOTAL"",8))
                                 &CONCAT = "' '"
                                } at min(19, cur_level * 2 - 1)
/*N0T4*/                       fm_desc.

                        else if fm_header then put fm_desc at

/*N0T4**                   min(16, cur_level * 3 - 2). */
/*N0T4*/                   min(19, cur_level * 2 - 1).
/*L00S*BEGIN DELETE
 *                      if fm_dr_cr = false then do:
 *                         assign crtot = - tot[cur_level].
 *                         put string(crtot, prtfmt) format "x(20)" to 77.
 *                      end.
 *                      else put string(tot[cur_level], prtfmt)
 *                         format "x(20)" to 77.
 *L00S*END DELETE*/

/*L00S*ADD SECTION*/
                        if fm_dr_cr = false
                           then et_crtot = - et_tot[cur_level].
                        else et_crtot = et_tot[cur_level].
                        put string(et_crtot, prtfmt) format "x(20)" to 77.
                        if cur_level <= 1 then do:
                           if fm_dr_cr = false
                              then crtot = - tot[cur_level].
                           else crtot = tot[cur_level].

/*L01W*                    {etrpconv.i crtot crtot} */

/*L01W*/                   if et_report_curr <> rpt_curr then do:
/*L01W*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input rpt_curr,
                                  input et_report_curr,
                                  input et_rate1,
                                  input et_rate2,
                                  input crtot,
                                  input true,    /* ROUND */
                                  output crtot,
                                  output mc-error-number)"}
/*L01W*/                      if mc-error-number <> 0 then do:
/*L01W*/                         {mfmsg.i mc-error-number 2}
/*L01W*/                      end.
/*L01W*/                   end.  /* if et_report_curr <> rpt_curr */

                           if crtot <> et_crtot and et_show_diff
                           and not prt1000
                           and not roundcnts
                           then
                              put
                                 et_diff_txt
/*L05G*                          to 50 */
/*N0T4** /*L05G*/                         at min(16, cur_level * 3 - 2) */
/*N0T4*/                         at min(19, cur_level * 2 - 1)
                                 string((et_crtot - crtot), prtfmt)
                                 format "x(20)" to 77
/*N0QF* /*L05G*/                 {&glbsrpa_p_3} at min(16, cur_level * 3 - 2) */

/*N0T4** BEGIN DELETE **
 * /*N0QF*/                         {gplblfmt.i
 *                                &FUNC=caps(getTermLabel(""TOTAL"",8))
 *                                &CONCAT = "' '"
 *                               } at min(16, cur_level * 3 - 2)
 *N0T4** END DELETE */

/*N0T4*/                         {gplblfmt.i
                                  &FUNC=caps(getTermLabel(""TOTAL"",8))
                                  &CONCAT = "' '"
                                 } at min(19, cur_level * 2 - 1)

/*M0F1* /*L05G*/          string(fm_desc + " (Rounded)") format "x(34)" */
/*N0QF* /*M0F1*/       string(fm_desc + {&glbsrpa_p_12}) format "x(34)" */

/*N0QF*/string(fm_desc + " (" + getTermLabel("ROUNDED",7) + ")" ) format "x(34)"
/*N0T4** /*L05G*/         at min(22, cur_level * 3 + 4)  */
/*L05G*/                         string(crtot, prtfmt)
/*L05G*/                         format "x(20)" to 77.
                        end.  /* if cur_level <= 1 */
/*L00S*END ADD SECTION*/

                        if fm_underln then put "====================" to 77.
                        if totflag[cur_level] and fm_skip then put skip(1).
                     end.  /* if not fmbgflag */
                  end.  /* if fm_total = no */
                  if fm_page_brk then page.
                  if cur_level > 1 then assign totflag[cur_level - 1] = yes.
               end.  /* if level >= cur_level */

               if fmbgrecid = recid(fm_mstr) then assign fmbgflag = no.

               find next fm_mstr use-index fm_fpos  where fm_mstr.fm_domain =
               global_domain and
               fm_type = "B" and fm_sums_into = fpos
               no-lock no-error.
               if available fm_mstr then leave.

            end. /* END OF REPEAT */
         end. /* END OF IF FM_MSTR AVAILABLE */
         if cur_level < 1 then leave.

         if fm_header = no and level >= cur_level then
/*N0T4**    put fm_desc at min(16, cur_level * 3 - 2). */
/*N0T4*/    put fm_desc at min(19, cur_level * 2 - 1).

         assign
            record[cur_level] = recid(fm_mstr)
            tot[cur_level] = 0
/*L00S*/    et_tot[cur_level] = 0.
            totflag[cur_level] = no.

/*J240***********************************************************
*        if budgflag then do:
*           find first bg_mstr where bg_code = budgetcode and
*                                    bg_fpos = fm_fpos and
*                                    bg_entity >= entity and
*                                    bg_entity <= entity1
*                                    no-lock use-index bg_ind1
*                                    no-error.
*           if available bg_mstr then do:
*J240***********************************************************/
/*J240*/ if budgflag and
/*J240*/    can-find (first bg_mstr  where bg_mstr.bg_domain = global_domain
and  bg_code = budgetcode and
/*J240*/                                  bg_fpos = fm_fpos and
/*J240*/                                  bg_entity >= entity and
/*J240*/                                  bg_entity <= entity1
/*J240*/                                  use-index bg_ind1)
/*J240*/ then do:
            assign
               fmbgflag = yes
               fmbgrecid = recid(fm_mstr).

/*J240** end. **/
         end.

         assign fpos = fm_fpos.

/*J240** find first fm_mstr use-index fm_fpos where fm_sums_into = fpos**/
/*J240**    and fm_type = "B" no-lock no-error.                        **/
/*J240*/ for first fm_mstr fields( fm_domain fm_desc fm_dr_cr fm_fpos fm_header
/*J240*/ fm_page_brk fm_skip fm_sums_into
/*J240*/ fm_total fm_type fm_underln )
/*J240*/ use-index fm_fpos  where fm_mstr.fm_domain = global_domain and
fm_sums_into = fpos
/*J240*/ and fm_type = "B" no-lock: end.

         if available fm_mstr and cur_level < 100 then
            assign cur_level = cur_level + 1.
         else do:

/*J240**    find fm_mstr where recid(fm_mstr) = record[cur_level] **/
/*J240**          no-lock no-error.                               **/
/*J240*/    for first fm_mstr fields( fm_domain fm_desc fm_dr_cr fm_fpos
fm_header
/*J240*/    fm_page_brk fm_skip fm_sums_into
/*J240*/    fm_total fm_type fm_underln )
/*J240*/    no-lock where recid(fm_mstr) = record[cur_level]: end.
            assign
               fpos = fm_sums_into
               fm_recno = recid(fm_mstr).
/* SS 090708.1 - B */
/*
            {gprun.i ""glbsrpb.p"" "(subflag, ccflag)"}
*/
            {gprun.i ""xxglbsrpb.p"" "(subflag, ccflag)"}
/* SS 090708.1 - E */
            if keyfunction(lastkey) = "end-error" then
               undo, leave loopa.
            if fmbgflag = yes then do:
               {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr &per=per_beg
                         &per1=per_end &budget=balance &bcode=budgetcode}

/*L01W* /*L00S*/ {etrpconv.i balance et_balance} */

/*L01W*/       if et_report_curr <> rpt_curr then do:
/*L01W*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input rpt_curr,
                      input et_report_curr,
                      input et_rate1,
                      input et_rate2,
                      input balance,
                      input true,    /* ROUND */
                      output et_balance,
                      output mc-error-number)"}
/*L01W*/          if mc-error-number <> 0 then do:
/*L01W*/             {mfmsg.i mc-error-number 2}
/*L01W*/          end.
/*L01W*/       end.  /* if et_report_curr <> rpt_curr */
/*L01W*/       else assign et_balance = balance.

               if prt1000 then assign balance = round(balance / 1000, 0).
               else if roundcnts then assign balance = round(balance, 0).
               assign tot[cur_level] = balance.
/*L00S*ADD SECTION*/
               if prt1000 then et_balance = round(et_balance / 1000, 0).
               else if roundcnts then et_balance = round(et_balance, 0).
               et_tot[cur_level] = et_balance.
/*L00S*END ADD SECTION*/
            end.  /* if fmgbflag = yes */

            if cur_level > 1 then
/*L00S*/    do:
/*L05G*/       assign
                  tot[cur_level - 1] = tot[cur_level - 1] + tot[cur_level]
/*L00S*/          et_tot[cur_level - 1] =
/*L00S*/             et_tot[cur_level - 1] + et_tot[cur_level].
/*L00S*/    end.
            else do:
               if not roundflag then do:
                  assign
                     roundamt = tot[cur_level]
/*L00S*/             et_roundamt = et_tot[cur_level].
                  roundflag = yes.
               end.
               else do:
                  assign rounderr = roundamt + tot[cur_level].
/*L00S*/                 rounderr = et_roundamt + et_tot[cur_level].
                  if (roundcnts or prt1000) and rounderr <> 0 and
                  rounderr < 5 and rounderr > -5
/*L00S*/          and not prt1000
/*L00S*/          and not roundcnts
                  then do:
                     put roundmsg at 4
                         rounderr to 77.
/*L00S               tot[cur_level] = tot[cur_level] - rounderr. */
/*L05G*/             assign
/*L00S*/                tot[cur_level] = - roundamt
/*L00S*/                et_tot[cur_level] = et_tot[cur_level] - rounderr.
                  end.
               end.  /* else do */
            end.  /* else do */

            if level >= cur_level then do:
               if fm_total = no or level = cur_level then do:
                  if not fmbgflag or fmbgrecid = recid(fm_mstr) then do:
                     if totflag[cur_level] then
                        put "--------------------" to 77
/*N0QF*                     {&glbsrpa_p_3} at min(16, cur_level * 3 - 2) */

/*N0T4** BEGIN DELETE**
 * /*N0QF*/                    {gplblfmt.i
 *                              &FUNC=caps(getTermLabel(""TOTAL"",8))
 *                              &CONCAT = "' '"
 *                             } at min(16, cur_level * 3 - 2)
 * /*J2HN**                    fm_desc. */
 * /*J2HN*/                    fm_desc at min(22, cur_level * 3 + 4).
 *N0T4** END DELETE*/

/*N0T4*/                    {gplblfmt.i
                              &FUNC=caps(getTermLabel(""TOTAL"",8))
                              &CONCAT = "' '"
                             } at min(19, cur_level * 2 - 1)
/*N0T4*/                    fm_desc.
                     else if fm_header then put fm_desc at
/*N0T4**                min(16, cur_level * 3 - 2). */
/*N0T4*/                min(19, cur_level * 2 - 1).

/*L00S*BEGIN DELETE
 *                   if fm_dr_cr = false then do:
 *                      assign crtot = - tot[cur_level].
 *                      put string(crtot, prtfmt) format "x(20)" to 77.
 *                   end.
 *                   else put string(tot[cur_level], prtfmt)
 *                      format "x(20)" to 77.
 *L00S*END DELETE*/
/*L00S*ADD SECTION*/
                     if fm_dr_cr = false
                        then et_crtot = - et_tot[cur_level].
                     else et_crtot = et_tot[cur_level].
                     put string(et_crtot, prtfmt) format "x(20)" to 77.
                     if cur_level <= 1 then do:
                        if fm_dr_cr = false
                           then crtot = - tot[cur_level].
                        else crtot = tot[cur_level].

/*L01W*                 {etrpconv.i crtot crtot} */

/*L01W*/                if et_report_curr <> rpt_curr then do:
/*L01W*/                   {gprunp.i "mcpl" "p" "mc-curr-conv"
                             "(input rpt_curr,
                               input et_report_curr,
                               input et_rate1,
                               input et_rate2,
                               input crtot,
                               input true,    /* ROUND */
                               output crtot,
                               output mc-error-number)"}
/*L01W*/                   if mc-error-number <> 0 then do:
/*L01W*/                      {mfmsg.i mc-error-number 2}
/*L01W*/                   end.
/*L01W*/                end.  /* if et_report_curr <> rpt_curr */

                        if crtot <> et_crtot and et_show_diff
                        and not prt1000
                        and not roundcnts
                        then
                           put
                              et_diff_txt
/*L05G*                       to 50 */
/*N0T4** /*L05G*/                      at min(16, cur_level * 3 - 2) */
/*N0T4*/                      at min(19, cur_level * 2 - 1)
                              string((et_crtot - crtot), prtfmt)
                              format "x(20)" to 77
/*N0QF* /*L05G*/              {&glbsrpa_p_3} at min(16, cur_level * 3 - 2) */

/*N0T4** BEGIN DELETE **
 * /*N0QF*/                      {gplblfmt.i
 *                                &FUNC=caps(getTermLabel(""TOTAL"",8))
 *                                &CONCAT = "' '"
 *                               } at min(16, cur_level * 3 - 2)
 *N0T4** END DELETE */

/*N0T4*/                      {gplblfmt.i
                                &FUNC=caps(getTermLabel(""TOTAL"",8))
                                &CONCAT = "' '"
                               } at min(19, cur_level * 2 - 1)

/*M0F1* /*L05G*/      string(fm_desc + " (Rounded)") format "x(34)" */
/*N0QF* /*M0F1*/      string(fm_desc + {&glbsrpa_p_12}) format "x(34)" */
/*N0QF*/string(fm_desc + " (" + getTermLabel("ROUNDED",7) + ")") format "x(34)"
/*N0T4** /*L05G*/                         at min(22, cur_level * 3 + 4) */
/*L05G*/                      string(crtot, prtfmt)
/*L05G*/                      format "x(20)" to 77.
                     end.  /* if cur_level <= 1 */
/*L00S*END ADD SECTION*/
                     if fm_underln then put "====================" to 77.
                     if totflag[cur_level] and fm_skip then put skip(1).
                  end.  /* if not fmbgflag */
               end.  /* if fm_total = no */
               if fm_page_brk then page.
               if cur_level > 1 then assign totflag[cur_level - 1] = yes.
            end.  /* if level >= cur_level */
            if fmbgrecid = recid(fm_mstr) then assign fmbgflag = no.
            find next fm_mstr use-index fm_fpos  where fm_mstr.fm_domain =
            global_domain and  fm_sums_into = fpos
            and fm_type = "B" no-lock no-error.
         end.  /* else do */

         {mfrpexit.i}
      end.  /* repeat */
      {wbrp04.i}
