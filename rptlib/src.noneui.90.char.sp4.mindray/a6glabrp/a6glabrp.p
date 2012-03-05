/* glabrp.p - GENERAL LEDGER ACCOUNT BALANCES REPORT                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*K0VL*/ /*V8#ConvertMode=WebReport                              */
/*V8:ConvertMode=Report                                                   */
/*J1C7*                   FullGUIReport converter failed on set...when ( )*/
/* REVISION: 1.0      LAST MODIFIED: 04/21/87   BY: JMS                   */
/*                                   01/29/88   by: jms  CSR 28967        */
/* REVISION: 4.0      LAST MODIFIED: 02/26/88   by: jms                   */
/*                                   02/29/88   BY: WUG  *A175*           */
/*                                   04/11/88   by: jms                   */
/* REVISION: 5.0      LAST MODIFIED: 05/10/89   BY: JMS  *B066*           */
/*                                   06/16/89   by: jms  *B154*           */
/*                                   08/03/89   BY: jms  *C0028*          */
/*                                   10/08/89   by: jms  *B331*           */
/*                                   11/21/89   by: jms  *B400*           */
/*                                   04/11/90   by: jms  *B499*           */
/*                             (split into glabrp.p and glabrpa.p)        */
/* REVISION: 6.0      LAST MODIFIED: 09/05/90   by: jms  *D034*           */
/*                                   01/03/91   by: jms  *D287*           */
/*                                   02/20/91   by: jms  *D366*           */
/*                                   09/05/91   by: jms  *D849*           */
/* REVISION: 7.0      LAST MODIFIED: 10/15/91   by: jms  *F058*           */
/*                                   01/28/92   by: jms  *F107*           */
/*                                   06/10/92   by: jms  *F593* (rev)     */
/*                                   06/24/92   by: jms  *F702*           */
/* REVISION: 7.3      LAST MODIFIED: 02/23/93   by: mpp  *G479*           */
/*                                   01/05/95   by: srk  *G0B8*           */
/* REVISION: 8.5      LAST MODIFIED: 12/19/96   by: rxm  *J1C7*           */
/*                                   01/31/97   by: bkm  *J1GL*           */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: ays  *K0VL*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 03/19/98   by: *J240* Kawal Batra    */
/* REVISION: 8.6E     LAST MODIFIED: 04/08/98   BY: *H1K1* Samir Bavkar   */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel       */
/* REVISION: 8.6E     LAST MODIFIED: 05/14/98   by: *L010* AWe            */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01W* Brenda Milton  */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt     */
/* REVISION: 8.6E     LAST MODIFIED: 11/18/98   BY: *J34P* Hemali Desai  */

/*J240********** GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND FOR SMALLER r-CODE *******J240*/

            /* SS - Bill - B 2005.06.02 */
            /*
/*L00M*/ {mfdtitle.i "f+ "}
    */
/*L00M*/ {a6mfdtitle.i "f+ "}
/*L00M*  {mfdtitle.i "f+ "} */
    /* SS - Bill - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glabrp_p_1 " 期间活动金额    "
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp_p_2 "货币"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp_p_3 "      期末余额  "
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp_p_4 "     期初余额    "
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp_p_5 "帐户            摘要        "
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp_p_6 "汇总分帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp_p_7 "汇总成本中心"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          define new shared variable glname like en_name  no-undo.
          define new shared variable per as integer  no-undo.
          define new shared variable per1 as integer  no-undo.
          define new shared variable yr as integer  no-undo.
          /* SS - Bill - B 2005.06.02 */
          /*
          define new shared variable begdt like gltr_eff_dt  no-undo.
          */
          DEFINE INPUT-OUTPUT PARAMETER output_et_beg_bal AS DECIMAL NO-UNDO.
          DEFINE INPUT-OUTPUT PARAMETER output_et_end_bal AS DECIMAL NO-UNDO.
          DEFINE INPUT PARAMETER begdt LIKE gltr_eff_dt NO-UNDO.
          /* SS - Bill - E */
          define new shared variable begdt1 like gltr_eff_dt  no-undo.
          define new shared variable begdt0 like begdt  no-undo.
          /* SS - Bill - B 2005.06.02 */
          /*
          define new shared variable enddt like gltr_eff_dt  no-undo.
          */
          DEFINE INPUT PARAMETER enddt LIKE gltr_eff_dt NO-UNDO.
          /* SS - Bill - E */
          define new shared variable enddt1 like gltr_eff_dt  no-undo.
          define new shared variable enddt0 like enddt  no-undo.
          define new shared variable yr_beg like gltr_eff_dt  no-undo.
          define new shared variable yr_end as date  no-undo.
          /* SS - Bill - B 2005.06.02 */
          /*
          define new shared variable acc like ac_code  no-undo.
          define new shared variable acc1 like ac_code  no-undo.
          define new shared variable sub like sb_sub  no-undo.
          define new shared variable sub1 like sb_sub  no-undo.
          define new shared variable ctr like cc_ctr  no-undo.
          define new shared variable ctr1 like cc_ctr  no-undo.
          */
          DEFINE INPUT PARAMETER acc LIKE ac_code NO-UNDO.
          DEFINE INPUT PARAMETER acc1 LIKE ac_code NO-UNDO.
          DEFINE INPUT PARAMETER sub LIKE sb_sub NO-UNDO.
          DEFINE INPUT PARAMETER sub1 LIKE sb_sub NO-UNDO.
          DEFINE INPUT PARAMETER ctr LIKE cc_ctr NO-UNDO.
          DEFINE INPUT PARAMETER ctr1 LIKE cc_ctr NO-UNDO.
          /*
          define new shared variable ccflag like mfc_logical
             label {&glabrp_p_7}  no-undo.
          define new shared variable subflag like mfc_logical
             label {&glabrp_p_6}  no-undo.
          define new shared variable oldacc like ac_code  no-undo.
          define new shared variable entity like gltr_entity  no-undo.
          define new shared variable entity1 like gltr_entity  no-undo.
          */
          define new shared variable ccflag like mfc_logical
             label {&glabrp_p_7}  INIT YES no-undo.
          define new shared variable subflag like mfc_logical
             label {&glabrp_p_6}  INIT YES no-undo.
          define new shared variable oldacc like ac_code  no-undo.
          DEFINE INPUT PARAMETER entity LIKE gltr_entity NO-UNDO.
          DEFINE INPUT PARAMETER entity1 LIKE gltr_entity NO-UNDO.
          /* SS - Bill - E */
          define new shared variable entity0 like gltr_entity  no-undo.
          define new shared variable cname like glname  no-undo.
          define new shared variable ret like ac_code  no-undo.
          define new shared variable disp_curr like gltr_curr
             label {&glabrp_p_2}  no-undo.
          define new shared variable begdtxx as date  no-undo.
          define new shared variable rpt_curr like gltr_curr  no-undo.

          define variable peryr as character format "x(8)"  no-undo.
          define variable use_cc like co_use_cc  no-undo.
          define variable use_sub like co_use_sub  no-undo.

/*L00M*ADD SECTION*/
          {etvar.i   &new = "new"} /* common euro variables        */
          {etrpvar.i &new = "new"} /* common euro report variables */
          {eteuro.i              } /* some initializations         */
/*L00M*END ADD SECTION*/

          /* GET NAME OF CURRENT ENTITY */

/*J240**  find en_mstr where en_entity = current_entity no-lock no-error. **/
          for first en_mstr fields (en_entity en_name en_curr)
/*J240*/      no-lock where en_entity = current_entity: end.

          if not available en_mstr then do:
             {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
             if not batchrun then
                if c-application-mode <> 'web':u then
                   pause.
             leave.
          end.
          else do:
             assign
/*J34P**        rpt_curr = en_curr */
                glname = en_name.

             release en_mstr.
          end.

          assign
             entity = current_entity
             entity1 = current_entity
/*J34P*/     rpt_curr = base_curr
             cname = glname.

          /* SS - Bill - B 2005.06.02 */
          /*
          /* SELECT FORM */
          form
             entity   colon 25 entity1 colon 50 label {t001.i}
             cname    colon 25
             acc      colon 25 acc1    colon 50 label {t001.i}
             sub      colon 25 sub1    colon 50 label {t001.i}
             ctr      colon 25 ctr1    colon 50 label {t001.i}
             begdt    colon 25 enddt   colon 50 label {t001.i}
             subflag  colon 25
             ccflag   colon 25
/*L00M*/     skip(1)
             rpt_curr colon 25
/*L01W*/     et_report_curr colon 25
/*L00M*ADD SECTION*/
/*L01W*      et_report_txt to 25 no-label     */
/*L01W*      space(0) et_report_curr no-label */
/*L01W*      et_rate_txt   to 25 no-label     */
/*L01W*      space(0) et_report_rate no-label */
/*L00M*END ADD SECTION*/

          with frame a side-labels attr-space width 80.
          */
          /* SS - Bill - E */

          /* GET RETAINED EARNINGS ACCOUNT CODE FROM CONTROL FILE */
/*J240**  find first co_ctrl no-lock no-error. **/
/*J240*/  for first co_ctrl fields (co_ret co_use_cc co_use_sub)
/*J240*/     no-lock: end.
          if not available co_ctrl then do:
             {mfmsg.i 3032 3} /* CONTROL FILE MUST BE DEFINED BEFORE
                                 RUNNING REPORT */
             if not batchrun then
                if c-application-mode <> 'web':u then
                   pause.
             leave.
          end.
          assign
             ret = co_ret
             use_cc = co_use_cc
             use_sub = co_use_sub.

          release co_ctrl.

          /* SS - Bill - B 2005.06.02 */
          /*
          /* DEFINE FORM */
          form header
             cname at 1 skip
/*L01W*/     mc-curr-label at 27 et_report_curr skip
/*L01W*/     mc-exch-label at 27 mc-exch-line1 at 49
/*L01W*/     mc-exch-line2 at 49 skip(1)
             {&glabrp_p_4} to 66
             {&glabrp_p_1} to 92
             {&glabrp_p_3} to 117 skip
             {&glabrp_p_5} at 1
             begdt at 55
             begdt0 at 74 "-" enddt
             enddt0 to 112 skip
             "--------------- ------------------------" at 1
             "-----------------------" to 69
             "-----------------------" to 94
             "-----------------------" to 119
          with frame phead1 page-top width 132.
          */
          /* SS - Bill - E */

         {wbrp01.i}

/* REPORT BLOCK */
         /* SS - Bill - B 2005.06.02 */
         /*
         mainloop:
         repeat:
             */
             /* SS - Bill - E */
            if entity1 = hi_char then assign entity1 = "".
            if acc1 = hi_char then assign acc1 = "".
            if sub1 = hi_char then assign sub1 = "".
            if ctr1 = hi_char then assign ctr1 = "".
            /* SS - Bill - B 2005.06.02 */
            /*
            display entity entity1 cname acc acc1 sub sub1 ctr ctr1 begdt
               enddt
               subflag
               ccflag
               rpt_curr

/*L00M*ADD SECTION*/
/*L01W*        et_report_txt */
               et_report_curr
/*L01W*        et_rate_txt */
/*L01W*        et_report_rate */
/*L00M*END ADD SECTION*/

            with frame a.

            if c-application-mode <> 'web':u then
               set entity entity1 cname acc acc1 sub when (use_sub)
                   sub1 when (use_sub) ctr when (use_cc) ctr1 when (use_cc)
                   begdt enddt subflag when (use_sub) ccflag when (use_cc)
                   rpt_curr
/*L00M*/           et_report_curr
/*L01W* /*L00M*/   et_report_rate */
                with frame a.

            {wbrp06.i &command = set &fields = "  entity entity1 cname acc acc1
             sub when ( use_sub )  sub1 when ( use_sub ) ctr when ( use_cc )
             ctr1 when ( use_cc )  begdt enddt
             subflag when ( use_sub ) ccflag when ( use_cc ) rpt_curr
/*L01W*/     et_report_curr
             " &frm = "a"}
            */
            /* SS - Bill - E */

            if (c-application-mode <> 'web':u) or
            (c-application-mode = 'web':u and
            (c-web-request begins 'data':u)) then do:

               /* VALIDATE INPUT */
               if entity1 = "" then assign entity1 = hi_char.
               if acc1 = "" then assign acc1 = hi_char.
               if sub1 = "" then assign sub1 = hi_char.
               if ctr1 = "" then assign ctr1 = hi_char.
               if rpt_curr = "" then assign rpt_curr = base_curr.

               /* VALIDATE DATES */
               if enddt = ? then assign enddt = today.
               {glper1.i enddt peryr}
               if peryr = "" then do:
                  {mfmsg.i 3018 3}
                  if c-application-mode = 'web':u then return.
                  else next-prompt enddt with frame a.
                  undo, retry.
               end.

               assign
                  yr = glc_year
                  per1 = glc_per.

/*J240**       find glc_cal where glc_year = yr and            **/
/*J240**            glc_per = 1 no-lock no-error.              **/

/*L01W*/       run validate-input.

/*L01W*
 * /*J240*/    for first glc_cal fields (glc_end glc_per glc_start glc_year)
 * /*J240*/    no-lock where glc_year = yr and glc_per = 1: end.
 *
 *             if not available glc_cal then do:
 *                {mfmsg.i 3033 3} /* NO FIRST PERIOD DEFINED FOR THIS
 *                                    FISCAL YEAR. */
 *
 *                if c-application-mode = 'web':u then return.
 *                else next-prompt enddt with frame a.
 *                undo, retry.
 *             end.
 *             if begdt = ? then assign begdt = glc_start.
 *             display begdt enddt with frame a.
 *             assign yr_beg = glc_start.
 *             if begdt < glc_start then do:
 *                {mfmsg.i 3031 3} /* REPORT CANNOT SPAN FISCAL YEAR */
 *                if c-application-mode = 'web':u then return.
 *                else next-prompt enddt with frame a.
 *                undo, retry.
 *             end.
 *             if begdt > enddt then do:
 *                {mfmsg.i 27 3} /* INVALID DATE */
 *                if c-application-mode = 'web':u then return.
 *                else next-prompt begdt with frame a.
 *                undo, retry.
 *             end.
 *             {glper1.i begdt peryr}
 *             if peryr = "" then do:
 *                {mfmsg.i 3018 3}
 *                if c-application-mode = 'web':u then return.
 *                else next-prompt begdt with frame a.
 *                undo, retry.
 *             end.
 *             assign per = glc_per.
 *
 *             find last glc_cal where glc_year = yr no-lock.
 *             assign
 *                yr_end = glc_end
 *                begdt0 = begdt
 *                enddt0 = enddt.
 *L01W*/

               /* CREATE BATCH INPUT STRING */
               assign bcdparm = "".
               {mfquoter.i entity  }
               {mfquoter.i entity1 }
               {mfquoter.i cname   }
               {mfquoter.i acc     }
               {mfquoter.i acc1    }
               if use_sub then do:
                  {mfquoter.i sub     }
                  {mfquoter.i sub1    }
               end.
               if use_cc then do:
                  {mfquoter.i ctr     }
                  {mfquoter.i ctr1    }
               end.
               {mfquoter.i begdt   }
               {mfquoter.i enddt   }
               if use_sub then do:
                  {mfquoter.i subflag }
               end.
               if use_cc then do:
                  {mfquoter.i ccflag  }
               end.
               {mfquoter.i rpt_curr}
/*L00M*/       {mfquoter.i et_report_curr}
/*L01W* /*L00M*/ {mfquoter.i et_report_rate} */

/*L00M*ADD SECTION*/
/*L01W*        {etcurval.i &curr     = "et_report_curr" */
/*L01W*                    &errlevel = "4"              */
/*L01W*                    &action   = "next"           */
/*L01W*                    &prompt   = "pause"}         */
/*L01W*        et_disp_curr = rpt_curr./*used when et_tk_active not active */ */
/*L01W*        {gprun.i ""etrate.p"" "(rpt_curr)"}      */
/*L010         et_disp_curr = rpt_curr. */
/*L00M*END ADD SECTION*/

/*L01W*/       if et_report_curr <> "" then do:
/*L01W*/          {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                    "(input et_report_curr,
                      output mc-error-number)"}
/*L01W*/          if mc-error-number = 0
/*L01W*/          and et_report_curr <> rpt_curr then do:
/*L08W*           CURRENCIES AND RATES REVERSED BELOW...             */
/*L01W*/             {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                       "(input et_report_curr,
                         input rpt_curr,
                         input "" "",
                         input et_eff_date,
                         output et_rate2,
                         output et_rate1,
                         output mc-seq,
                         output mc-error-number)"}
/*L01W*/          end.  /* if mc-error-number = 0 */

/*L01W*/          if mc-error-number <> 0 then do:
/*L01W*/             {mfmsg.i mc-error-number 3}
/*L01W*/             if c-application-mode = 'web':u then return.
/*L01W*/             else next-prompt et_report_curr with frame a.
/*L01W*/             undo, retry.
/*L01W*/          end.  /* if mc-error-number <> 0 */
/*L01W*/          else if et_report_curr <> rpt_curr then do:
/*L08W*           CURRENCIES AND RATES REVERSED BELOW...             */
/*L01W*/             {gprunp.i "mcui" "p" "mc-ex-rate-output"
                       "(input et_report_curr,
                         input rpt_curr,
                         input et_rate2,
                         input et_rate1,
                         input mc-seq,
                         output mc-exch-line1,
                         output mc-exch-line2)"}
/*L01W*/             {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                       "(input mc-seq)"}
/*L01W*/          end.  /* else do */
/*L01W*/       end.  /* if et_report_curr <> "" */
/*L01W*/       if et_report_curr = "" or et_report_curr = rpt_curr then assign
/*L01W*/          mc-exch-line1 = ""
/*L01W*/          mc-exch-line2 = ""
/*L01W*/          et_report_curr = rpt_curr.

           end.  /* if (c-application-mode <> 'web':u) ... */

           /* SS - Bill - B 2005.06.02 */
           /* SELECT PRINTER */
           /*
           {mfselbpr.i "printer" 132}
           {mfphead.i}

           view frame phead1.
/*J240************ REPLACE WITH A CAN-FIND FOR PERFORMANCE ****************
*               find first glt_det where glt_entity >= entity and
*                                        glt_entity <= entity1 and
*                                        glt_acc >= acc and glt_acc <= acc1 and
*                                        glt_sub >= sub and glt_sub <= sub1 and
*                                        glt_cc >= ctr and glt_cc <= ctr1 and
*                                        glt_effdate >= begdt and
*                                        glt_effdate <= enddt no-lock no-error.
*               if available glt_det then do:
*J240**********************************************************************/
/*J240*/   if can-find (first glt_det where glt_entity >= entity and
/*J240*/                              glt_entity <= entity1 and
/*J240*/                              glt_acc >= acc and glt_acc <= acc1 and
/*J240*/                              glt_sub >= sub and glt_sub <= sub1 and
/*J240*/                              glt_cc >= ctr and glt_cc <= ctr1 and
/*J240*/                              glt_effdate >= begdt and
/*J240*/                              glt_effdate <= enddt)
/*J240*/   then do:

              {mfmsg.i 3151 2} /* UNPOSTED TRANSACTIONS EXIST FOR RANGES ON
                                  THIS REPORT */
           end.
           */
           /* SS - Bill - E */

           /* CYCLE THROUGH ACCOUNT FILE */
              /* SS - Bill - B 2005.06.02 */
              /*
           {gprun.i ""glabrpa.p""}
               */
           {gprun.i ""a6glabrpa.p"" "(input-output output_et_beg_bal, input-output output_et_end_bal, input begdt, input enddt, input acc, input acc1, input sub, input sub1, input ctr, input ctr1, input entity, input entity1)"}
               /* SS - Bill - E */

               /* SS - Bill - B 2005.06.02 */
               /*
           /* REPORT TRAILER */
           {mfrtrail.i}

        end.
        {wbrp04.i &frame-spec = a}
            */
            /* SS - Bill - E */

/*L01W BEGIN ADD*/
procedure validate-input:
/*J240*/  for first glc_cal fields (glc_end glc_per glc_start glc_year)
/*J240*/  no-lock where glc_year = yr and glc_per = 1: end.

          if not available glc_cal then do:
             {mfmsg.i 3033 3} /* NO FIRST PERIOD DEFINED FOR THIS
                                 FISCAL YEAR. */

             if c-application-mode = 'web':u then return.
             else next-prompt enddt with frame a.
             undo, retry.
          end.
          if begdt = ? then assign begdt = glc_start.
          /* SS - Bill - B 2005.06.02 */
          /*
          display begdt enddt with frame a.
          */
          /* SS - Bill - E */
          assign yr_beg = glc_start.
          if begdt < glc_start then do:
             {mfmsg.i 3031 3} /* REPORT CANNOT SPAN FISCAL YEAR */
             if c-application-mode = 'web':u then return.
             else next-prompt enddt with frame a.
             undo, retry.
          end.
          if begdt > enddt then do:
             {mfmsg.i 27 3} /* INVALID DATE */
             if c-application-mode = 'web':u then return.
             else next-prompt begdt with frame a.
             undo, retry.
          end.
          {glper1.i begdt peryr}
          if peryr = "" then do:
             {mfmsg.i 3018 3}
             if c-application-mode = 'web':u then return.
             else next-prompt begdt with frame a.
             undo, retry.
          end.
          assign per = glc_per.

          find last glc_cal where glc_year = yr no-lock.
          assign
             yr_end = glc_end
             begdt0 = begdt
             enddt0 = enddt.
end.
/*L01W END ADD*/
