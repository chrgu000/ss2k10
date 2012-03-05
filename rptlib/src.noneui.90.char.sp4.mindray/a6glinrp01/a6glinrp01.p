/* glinrp.p - GENERAL LEDGER INCOME STATEMENT REPORT                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*K1DT*/ /*V8#ConvertMode=WebReport                              */
/*V8:ConvertMode=Report                                                   */
/* REVISION: 1.0      LAST MODIFIED: 12/03/86   BY: emb                   */
/*                                   06/18/87       jms                   */
/*                                   09/23/87       pml                   */
/*                                   01/25/88       jms                   */
/*                                   02/01/88   by: jms  CSR 24912        */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   by: jms                   */
/*                                   02/29/88   BY: WUG *A175*            */
/*                                   04/14/88   by: jms                   */
/*                                   06/13/88   by: jms *A274* (no-undo)  */
/*                                   07/29/88   by: jms *A373*            */
/*                                   11/08/88   by: jms *A526*            */
/* REVISION: 5.0      LAST MODIFIED: 05/17/89   BY: JMS *B066*            */
/*                                   06/12/89   by: jms *B141*            */
/*                                   09/18/89   by: jms *B135*            */
/*                                   11/21/89   by: jms *B400* (rev only) */
/*                                   02/08/90   by: jms *B499* (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 10/09/90   by: jms *D034*            */
/*                                   11/07/90   by: jms *D189*            */
/*                                   01/04/91   by: jms *D287*            */
/*                                   02/20/91   by: jms *D366*            */
/*                                   04/04/91   by: jms *D493* (rev only) */
/*                                   04/23/91   by: jms *D577* (rev only) */
/*                                   07/23/91   by: jms *D791* (rev only) */
/*                                   09/05/91   by: jms *D849*            */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   by: jms *F058*            */
/*                                   02/04/92   by: jms *F146*            */
/*                                   02/25/92   by: jms *F231*            */
/*                                   06/24/92   by: jms *F702*            */
/* REVISION: 7.3      LAST MODIFIED: 08/28/92   by: mpp *G030* (rev only) */
/*                                   09/15/92   by: jms *F890* (rev only) */
/*                                   02/05/93   by: mpp *G479*            */
/*                                   04/12/93   by: skk *G943*            */
/*                                   07/07/93   by: skk *GD27* batch prob */
/* REVISION: 7.3      LAST MODIFIED: 07/12/93   by: pcd *GD36*            */
/*                                   10/21/93   by: jms *GG57*            */
/*                                        (reverses G479)                 */
/*                                   09/03/94   by: srk *FQ80*            */
/*                                   02/07/95   by: srk *G0DP*            */
/* REVISION: 8.6      LAST MODIFIED: 12/15/97   by: bvm *K1DT*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 03/18/98   BY: *J242*   Sachin Shah  */
/*J242* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */
/* REVISION: 8.6E     LAST MODIFIED: 05/06/98   BY: *L00S* CPD/EJ         */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *K1RK*   Mohan CK     */
/* REVISION: 8.6E     LAST MODIFIED: 06/18/98   BY: *L017* Adam Harris    */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L01G* Robin McCarthy */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01W* Brenda Milton  */
/* REVISION: 8.6E     LAST MODIFIED: 08/06/98   BY: *H1M0* Prashanth Narayan */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt     */
/* REVISION: 9.0SP4 LAST MODIFIED: 2005/07/10 BY: *SS - 20050710* Bill Jiang */

         /* SS - 20050710 - B */
         /*
          {mfdtitle.i "e+ "}
         */
         {a6mfdtitle.i "e+ "}
         {a6glinrp01.i}
         /* SS - 20050710 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glinrp_p_1 "打印说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_2 "结束日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_3 "开始日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_4 "主说明参考"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_5 "活动金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_6 "层次"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_7 "说明类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_8 "收入 %"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_9 "(单位: 1000"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_10 "% 的"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_11 " 预算"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_12 "报表货币"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_13 "圆整至整数单位"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_14 "圆整至千元"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_15 "汇总成本中心"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_16 "To"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_17 "抑制帐户号码"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_18 "抑制有零余额的帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_19 "汇总分帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glinrp_p_20 "使用预算金额"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          define new shared variable glname like en_name no-undo.
         /* SS - 20050710 - B */
         /*
          define new shared variable begdt like gltr_eff_dt
             label {&glinrp_p_3} no-undo.
          define new shared variable enddt like gltr_eff_dt
             label {&glinrp_p_2} no-undo.
          */
          /* SS - 20050710 - E */
          define new shared variable fiscal_yr like glc_year no-undo.
          define new shared variable balance as decimal no-undo.
          define new shared variable sub like sb_sub no-undo.
          define new shared variable sub1 like sb_sub no-undo.
          define new shared variable ctr like cc_ctr no-undo.
          define new shared variable ctr1 like cc_ctr no-undo.
          define new shared variable level as integer format ">9" initial 99
             label {&glinrp_p_6} no-undo.
          define new shared variable budgflag like mfc_logical
             label {&glinrp_p_20} no-undo.
          /* SS - 20050710 - B */
          /*
          define new shared variable zeroflag like mfc_logical label
             {&glinrp_p_18} no-undo.
          define new shared variable ccflag like mfc_logical label
             {&glinrp_p_15} no-undo.
          define new shared variable subflag like mfc_logical
             label {&glinrp_p_19} no-undo.
          */
          define new shared variable zeroflag like mfc_logical INIT YES label
             {&glinrp_p_18} no-undo.
          /* SS - 20050710 - E */
          define new shared variable prtflag like mfc_logical initial yes
             label {&glinrp_p_17} no-undo.
          /* SS - 20050710 - B */
          /*
          define new shared variable entity like en_entity no-undo.
          define new shared variable entity1 like en_entity no-undo.
          */
          /* SS - 20050710 - E */
          define new shared variable cname like glname no-undo.
          define new shared variable yr_end as date no-undo.
          define new shared variable ret like ac_code no-undo.
          define new shared variable per_end like glc_per no-undo.
          define new shared variable per_beg like glc_per no-undo.
          define new shared variable rpt_curr like gltr_curr
             label {&glinrp_p_12} no-undo.
          define new shared variable budgetcode like bg_code no-undo.
          define new shared variable prt1000 like mfc_logical
             label {&glinrp_p_14} no-undo.
          define new shared variable roundcnts like mfc_logical
             label {&glinrp_p_13} no-undo.
          define new shared variable hdrstring as character format "x(8)"
             no-undo.
          define new shared variable income as decimal no-undo.
          define new shared variable percent as decimal format "->>>9.9%"
             no-undo.
          define new shared variable prtfmt as character format "x(30)" no-undo.

          define new shared variable msg1000 as character format "x(16)"
             no-undo.
          define new shared variable peryr as character format "x(8)" no-undo.
          define new shared variable knt as integer no-undo.
          define new shared variable i as integer no-undo.
          define new shared variable xlen as integer no-undo.
          define new shared variable dt as date no-undo.
          define new shared variable dt1 as date no-undo.
          define new shared variable cmmt_ref like cd_ref label {&glinrp_p_4}
             no-undo.
          define new shared variable cmmt_type like cd_type label {&glinrp_p_7}
             no-undo.
          define new shared variable cmmt-yn like mfc_logical
             label {&glinrp_p_1} no-undo.
          define new shared variable use_cc like co_use_cc no-undo.
          define new shared variable use_sub like co_use_sub no-undo.
          /* SS - 20050710 - B */
          define INPUT PARAMETER entity like en_entity no-undo.
          define INPUT PARAMETER entity1 like en_entity no-undo.
          define INPUT PARAMETER begdt like gltr_eff_dt no-undo.
          define INPUT PARAMETER enddt like gltr_eff_dt no-undo.
          define INPUT PARAMETER subflag like mfc_logical no-undo.
          define INPUT PARAMETER ccflag like mfc_logical no-undo.
          /* SS - 20050710 - E */

/*L00S - BEGIN ADD*/
/*        ***** DEFINITION COMMON REPORT VARIABLES ***** */
          {etrpvar.i &new = "new"}
          {etvar.i   &new = "new"}
/*        ***** GET EURO INFORMATION ***** */
          {eteuro.i}
/*L01W*   define variable et_select_curr like exd_curr no-undo. */
/*L01W*   define variable et_show_curr as character format "x(30)". */
          define new shared variable et_income like income no-undo.
          define new shared variable et_balance like balance no-undo.
/*L00S - END ADD*/

          /* SELECT FORM */
          form
             entity    colon 30  entity1    colon 57 label {t001.i}
             cname     colon 30  skip(1)
             begdt     colon 30  enddt      colon 57
             budgflag  colon 30  budgetcode colon 57 skip(1)
             zeroflag  colon 30
             sub       colon 30  sub1       colon 57 label {t001.i}
             ctr       colon 30  ctr1       colon 57 label {t001.i}
             level     colon 30
             subflag   colon 30
             ccflag    colon 30
             prtflag   colon 30
             prt1000   colon 30  roundcnts  colon 65
             cmmt-yn   colon 30  cmmt_type  colon 65
             cmmt_ref  colon 30
/*L01W*/     et_report_curr colon 30
/*L01W* /*L00S*/  et_report_txt     to 20 no-label no-attr-space */
/*L01W* /*L00S*/  et_report_curr          no-label */
/*L01W* /*L00S*/  et_rate_txt       to 40 no-label no-attr-space */
/*L01W* /*L00S*/  et_report_rate          no-label */
          with frame a side-labels attr-space width 80.

          /* GET NAME OF CURRENT ENTITY */
/*J242**  find en_mstr where en_entity = current_entity no-lock no-error. **/
/*J242*/  for first en_mstr fields (en_name en_entity)
/*J242*/  no-lock where en_entity = current_entity: end.
          if not available en_mstr then do:
             {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
             if not batchrun then
                if c-application-mode <> 'web':u then
                   pause.
             leave.
          end.
          else do:
             assign glname = en_name.
             release en_mstr.
          end.
/*J242*/  assign
             entity = current_entity
             entity1 = current_entity
             cname = glname
             rpt_curr = base_curr.

          /* GET RETAINED EARNINGS CODE FROM CONTROL FILE */
/*J242**  find first co_ctrl no-lock no-error. **/
/*J242*/  for first co_ctrl fields (co_ret co_use_cc co_use_sub) no-lock: end.
          if not available co_ctrl then do:
             {mfmsg.i 3032 3} /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING
                                 REPORT*/
             if not batchrun then
                if c-application-mode <> 'web':u then
                   pause.
             leave.
          end.
/*J242*/  assign
             ret = co_ret
             use_sub = co_use_sub
             use_cc = co_use_cc.

/* SS - Bill - B 2005.07.06 */
/*
          /* DEFINE HEADERS */
          form header
             cname at 1 space(2) msg1000
/*L01W* /*L00S*/ et_show_curr */
/*L01W*/     mc-curr-label at 60 et_report_curr skip
/*L01W*/     mc-exch-label at 60 mc-exch-line1 skip
/*L01W*/     mc-exch-line2 at 82
             skip
             hdrstring at 66
/*H1M0**     begdt at 64 "to" {&glinrp_p_10} at 82 */
/*H1M0*/     begdt at 64 {t001.i} {&glinrp_p_10} at 82
             enddt at 66   {&glinrp_p_8} at 81
             "--------------------" to 77 "--------" at 79
          skip with frame phead1 page-top width 132.

          form header /* HEADER USED IF REPORT DOESN'T START AT PAGE TOP */
             hdrstring at 66
             begdt at 64 {&glinrp_p_16} {&glinrp_p_10} at 82
             enddt at 66   {&glinrp_p_8} at 81
             "--------------------" to 77 "--------" at 79
          skip with frame phead2 width 132.
          */
          /* SS - Bill - E */

          {wbrp01.i}

              /* SS - 20050710 - B */
              /*
          /* REPORT BLOCK */
          repeat:
              */
              /* SS - 20050710 - E */

             /* INPUT OPTIONS */
             if sub1 = hi_char then assign sub1 = "".
             if ctr1 = hi_char then assign ctr1 = "".
             if entity1 = hi_char then assign entity1 = "".

/*L01W* /*L00S*/ display et_report_txt et_rate_txt with frame a. */

             /* SS - 20050710 - B */
             /*
             if c-application-mode <> 'web':u then
                update entity
                       entity1
                       cname
                       begdt
                       enddt
                       budgflag
                       budgetcode
                       zeroflag sub when (use_sub) sub1 when (use_sub) ctr when
                       (use_cc)
                       ctr1 when (use_cc) level subflag when (use_sub)
                       ccflag when (use_cc)
                       prtflag
                       prt1000 roundcnts cmmt-yn cmmt_type cmmt_ref
/*L00S*/               et_report_curr
/*L01W* /*L00S*/       et_report_rate */
                with frame a.

             {wbrp06.i &command = update &fields = "  entity entity1 cname
              begdt enddt budgflag budgetcode  zeroflag sub when use_sub
              sub1 when use_sub ctr when use_cc   ctr1 when use_cc level
              subflag when use_sub ccflag when use_cc   prtflag  prt1000
              roundcnts cmmt-yn cmmt_type cmmt_ref
/*L00S*/      et_report_curr
/*L01W* /*L00S*/ et_report_rate */
              " &frm = "a"}
                 */
                 /* SS - 20050710 - E */

             if (c-application-mode <> 'web':u) or
             (c-application-mode = 'web':u and
             (c-web-request begins 'data':u)) then do:

                if entity1 = "" then assign entity1 = hi_char.
                if sub1 = "" then assign sub1 = hi_char.
                if ctr1 = "" then assign ctr1 = hi_char.

                /* CHECK FOR VALID REPORT DATE */
                if enddt = ? then assign enddt = today.
                /* SS - 20050710 - B */
                /*
                display enddt with frame a.
                */
                /* SS - 20050710 - E */
                {glper1.i enddt peryr}  /* GET PERIOD/YEAR */
                if peryr = "" then do:
                   {mfmsg.i 3018 3}    /* DATE NOT WITHIN A VALID PERIOD */
                   if c-application-mode = 'web':u then return.
                   else next-prompt enddt with frame a.
                   undo, retry.
                end.
                assign per_end = glc_per

                /* DETERMINE DATE OF BEGINNING OF FISCAL YEAR */
                fiscal_yr = glc_year.
/*J242**        find glc_cal where glc_year = fiscal_yr and glc_per = 1 **/
/*J242**        no-lock no-error. **/
/*J242*/        for first glc_cal fields (glc_end glc_per glc_start glc_year)
/*J242*/        no-lock where glc_year = fiscal_yr and glc_per = 1: end.
                if not available glc_cal then do:
                   {mfmsg.i 3033 3}  /* NO FIRST PERIOD DEFINED FOR THIS
                                        FISCAL YEAR. */
                   if c-application-mode = 'web':u then return.
                   else next-prompt enddt with frame a.
                   undo, retry.
                end.
                if begdt = ? then assign begdt = glc_start.
                /* SS - 20050710 - B */
                /*
                display begdt with frame a.
                */
                /* SS - 20050710 - E */
                if begdt < glc_start then do:
                   {mfmsg.i 3031 3} /*REPORT CANNOT SPAN FISCAL YEARS*/
                   if c-application-mode = 'web':u then return.
                   else next-prompt begdt with frame a.
                   undo, retry.
                end.

                if begdt > enddt then do:
                   {mfmsg.i 123 3} /* END DATE CANNOT BE BEFORE START DATE */
                   if c-application-mode = 'web':u then return.
                   else next-prompt begdt with frame a.
                   undo, retry.
                end.

                {glper1.i begdt peryr}  /* GET PERIOD/YR */
                if peryr = "" then do:
                   {mfmsg.i 3018 3}    /* DATE NOT WITHIN A VALID PERIOD */
                   if c-application-mode = 'web':u then return.
                   else next-prompt begdt with frame a.
                   undo, retry.
                end.
                assign per_beg = glc_per.

/*L00S Moved to internal procedure
.               /* CREATE BATCH INPUT STRING */
.               assign bcdparm = "".
.               {mfquoter.i entity    }
.               {mfquoter.i entity1   }
.               {mfquoter.i cname     }
.               {mfquoter.i begdt     }
.               {mfquoter.i enddt     }
.               {mfquoter.i budgflag  }
.               {mfquoter.i budgetcode}
.               {mfquoter.i zeroflag  }
.               if use_sub then do:
.                  {mfquoter.i sub    }
.                  {mfquoter.i sub1   }
.               end.
.               if use_cc then do:
.                  {mfquoter.i ctr    }
.                  {mfquoter.i ctr1   }
.               end.
.               {mfquoter.i level     }
.               if use_sub then do:
.                  {mfquoter.i subflag}
.               end.
.               if use_cc then do:
.                  {mfquoter.i ccflag }
.               end.
.               {mfquoter.i prtflag   }
.               {mfquoter.i prt1000   }
.               {mfquoter.i roundcnts }
.               {mfquoter.i cmmt-yn   }
.               {mfquoter.i cmmt_type }
.               {mfquoter.i cmmt_ref  }
./*L00S*/       if et_tk_active then do:
./*L00S*/          {mfquoter.i et_report_curr}
./*L00S*/          {mfquoter.i et_report_rate}
./*L00S*/       end. /* if et_tk_active then do: */
.
*L00S End moved to internal proc */
/*L00S Replaced by: */

/*L00S*/        run create-batch-input-string.

                find last glc_cal where glc_year = fiscal_yr
                no-lock no-error.
                assign yr_end = glc_end.

                /* CHECK FOR VALID LEVEL */
                if level < 1 or level > 99 then do:
                   {mfmsg.i 3015 3}   /*INVALID LEVEL*/
                   if c-application-mode = 'web':u then return.
                   else next-prompt level with frame a.
                   undo, retry.
                end.

/*L01W*/        if et_report_curr <> "" then do:
/*L01W*/           {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                     "(input et_report_curr,
                       output mc-error-number)"}
/*L01W*/           if mc-error-number = 0
/*L01W*/           and et_report_curr <> rpt_curr then do:
/*L08W*           CURRENCIES AND RATES REVERSED BELOW...             */
/*L01W*/              {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                        "(input et_report_curr,
                          input rpt_curr,
                          input "" "",
                          input et_eff_date,
                          output et_rate2,
                          output et_rate1,
                          output mc-seq,
                          output mc-error-number)"}
/*L01W*/           end.  /* if mc-error-number = 0 */

/*L01W*/           if mc-error-number <> 0 then do:
/*L01W*/              {mfmsg.i mc-error-number 3}
/*L01W*/              if c-application-mode = 'web':u then return.
/*L01W*/              else next-prompt et_report_curr with frame a.
/*L01W*/              undo, retry.
/*L01W*/           end.  /* if mc-error-number <> 0 */
/*L01W*/           else if et_report_curr <> rpt_curr then do:
/*L08W*               CURRENCIES AND RATES REVERSED BELOW...             */
/*L01W*/              {gprunp.i "mcui" "p" "mc-ex-rate-output"
                        "(input et_report_curr,
                          input rpt_curr,
                          input et_rate2,
                          input et_rate1,
                          input mc-seq,
                          output mc-exch-line1,
                          output mc-exch-line2)"}
/*L01W*/              {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                        "(input mc-seq)"}
/*L01W*/           end.
/*L01W*/        end.  /* if et_report_curr <> "" */
/*L01W*/        if et_report_curr = "" or et_report_curr = rpt_curr then
/*L01W*/           assign
/*L01W*/              mc-exch-line1 = ""
/*L01W*/              mc-exch-line2 = ""
/*L01W*/              et_report_curr = rpt_curr.

             end.  /* if (c-application-mode <> 'web':u) ... */

/*L00S   ***** REPORTING CURRENCY VALIDATION ***** */
/*L01W* /*L00S*/{etcurval.i &curr     = "et_report_curr" */
/*L01W* /*L00S*/     &errlevel = 4 */
/*L01W* /*L00S*/     &prompt   = "next-prompt et_report_curr with frame a" */
/*L01W* /*L00S*/     &action   = "undo, retry"} */

/*L01W* /*L00S*/assign et_eff_date    = today */
/*L01W* /*L00S*/       et_select_curr = " ". */

/*L00S   ***** GET FIXED EXCHANGE RATE ***** */
/*L01W* /*L00S*/{gprun.i ""etrate.p"" "(input et_select_curr)"} */

             /* SS - 20050710 - B */
             /*
             /* SELECT PRINTER */
             {mfselbpr.i "printer" 132}
             {mfphead.i}
                 */
                 /* SS - 20050710 - E */

             /* SS - 20050710 - B */
             /*
             /* PRINT COMMENTS */
             if cmmt-yn then do:
                put cname at 1 skip.
/*K1RK*/        run print-comments in THIS-PROCEDURE.
/*K1RK* Moved to an internal procedure ******
 *
 *              for each cd_det
 * /*J242*/     fields (cd_cmmt cd_ref cd_type)
 *              where cd_ref = cmmt_ref and cd_type = cmmt_type
 *              no-lock:
 *                 do i = 1 to 15:
 *                    if cd_cmmt[i] <> "" then do:
 *                       if line-count > page-size then page.
 *                       put cd_cmmt[i] at 14 skip.
 *                    end.
 *                 end.
 *                 put skip.
 *              end.
 *K1RK* end of Move *******************/
             end.  /* if cmmt-yn */
             */
             /* SS - 20050710 - E */

             /* PRINT HEADER */
             assign msg1000 = "".
/*L00S - ADD SECTION */
/*L01W*      et_show_curr = "". */
/*L01W*      if et_tk_active then do: */
/*L01W*         assign et_show_curr = et_report_txt + et_disp_curr. */
/*L01W*         if prt1000 */
/*L01W*            then assign msg1000= {&glinrp_p_9} + et_disp_curr + ")".*/
/*L01W*      end. */
/*L01W*      else */
/*L00S - END ADD SECTION */
/*L01W*      if prt1000 then assign msg1000 = {&glinrp_p_9} +  */
/*L01W*                                       base_curr + ")". */
/*L01W*/     if prt1000 then assign
/*L01W*/        msg1000 = {&glinrp_p_9} + et_report_curr + ")".
             assign hdrstring = {&glinrp_p_5}.
             if budgflag then assign hdrstring = {&glinrp_p_11}.
             /* SS - 20050710 - B */
             /*
             if cmmt-yn and line-counter > 4 then do:
                view frame phead2.
                display "".
             end.
             view frame phead1.
             */
             /* SS - 20050710 - E */

                /* CHECK FOR UNPOSTED TRANSACTIONS */
/*J242******* REPLACE WITH A CAN-FIND FOR PERFORMANCE ***********************
*            if not budgflag then do:
*               find first glt_det where glt_entity >= entity and
*                                        glt_entity <= entity1 and
*                                        glt_sub >= sub and glt_sub <= sub1 and
*                                        glt_cc >= ctr and glt_cc <= ctr1 and
*                                        glt_effdate >= begdt and
*                                        glt_effdate <= enddt no-lock no-error.
*               if available glt_det then do:
*J242************************************************************************/

/*J242* BEGIN ADD */
             if not budgflag and
             can-find (first glt_det where glt_entity >= entity and
                                     glt_entity <= entity1 and
                                     glt_sub >= sub and glt_sub <= sub1 and
                                     glt_cc >= ctr and glt_cc <= ctr1 and
                                     glt_effdate >= begdt and
                                     glt_effdate <= enddt)
             then do:
/*J242* END ADD */
                {mfmsg.i 3151 2} /* UNPOSTED TRANSACTIONS EXIST FOR RANGES ON
                                    THIS REPORT */
/*J242**     end. **/
             end.

             /* CALCULATE TOTAL AMOUNT OF INCOME FOR CURRENT PERIOD */
             assign income = 0.
             {gprun.i ""glinrpe.p""}

             if budgflag then do:
/*L017*   /* Moved to internal procedure */
 *              for each bg_mstr
 * /*J242*/     fields (bg_fpos bg_acc bg_code) no-lock
 *              where bg_code = budgetcode and
 *              bg_acc = ""
 *              use-index bg_ind1:
 * /*J242**        find fm_mstr where fm_fpos = bg_fpos no-lock no-error. **/
 * /*J242*/        for first fm_mstr fields (fm_fpos fm_type)
 * /*J242*/        no-lock where fm_fpos = bg_fpos: end.
 *                 if available fm_mstr and fm_type = "I" then do:
 * /*J242**           find first ac_mstr where ac_fpos = fm_fpos **/
 * /*J242**           no-lock no-error. **/
 * /*J242*/           for first ac_mstr fields (ac_type ac_fpos)
 * /*J242*/           no-lock where ac_fpos = fm_fpos: end.
 *                    if available ac_mstr and ac_type = "I" then do:
 *                       {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr &per=per_beg
 *                          &per1=per_end &budget=balance &bcode=budgetcode}
 *                       assign income = income + balance.
 *                    end.
 *                 end.  /* if available fm_mstr */
 *              end.  /* for each bg_mstr */
 *L017*/  /* End of moved */

/*L017*/        run p-euro1.
             end.  /* if budgflag */
             assign income = - income.

             if income = 0 then assign percent = 0.

/*L00S       if prt1000 then income = round(income / 1000, 0).
 *           else if roundcnts then income = round(income, 0).
 *           if income = 0 then assign percent = 0.
 */

/*L00S   ***** CONVERT AMOUNTS AFTER ROUNDING ***** */
/*L01W* /*L00S*/ {etrpconv.i income et_income} */
/*L01W*/     if et_report_curr <> rpt_curr then do:
/*L01W*/        {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input rpt_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input income,
                    input true,  /* ROUND */
                    output et_income,
                    output mc-error-number)"}
/*L01W*/        if mc-error-number <> 0 then do:
/*L01W*/           {mfmsg.i mc-error-number 2}
/*L01W*/        end.
/*L01W*/     end.  /* if et_report_curr <> rpt_curr */
/*L01W*/     else assign et_income = income.

/*L00S*/     if prt1000 then assign et_income = round(et_income / 1000,0).
/*L00S*/     else if roundcnts then assign et_income = round(et_income,0).

/*L00S*/     if et_income = 0 then assign percent = 0.

             /* SET FORMAT FOR AMOUNTS*/
             if roundcnts or prt1000
                then assign prtfmt = "(>>,>>>,>>>,>>>,>>9)".
             else assign prtfmt = "(>>>,>>>,>>>,>>9.99)".

             /* SS - 20050710 - B */
             /* PRINT REPORT */
             /*
             {gprun.i ""glinrpa.p""}
                 */
             {gprun.i ""a6glinrpa01.p""
                 "(
                 input entity,
                 INPUT entity,
                 INPUT begdt,
                 INPUT enddt,
                 INPUT subflag,
                 INPUT ccflag
                 )"
                 }

             /*
             hide frame phead1.

             /* REPORT TRAILER */
             {mfrtrail.i}

          end.
             */
             /* SS - 20050710 - E */

             {wbrp04.i &frame-spec = a}

/*L00S Start added*/
PROCEDURE create-batch-input-string:
         /* CREATE BATCH INPUT STRING */
         assign bcdparm = "".
         {mfquoter.i entity    }
         {mfquoter.i entity1   }
         {mfquoter.i cname     }
         {mfquoter.i begdt     }
         {mfquoter.i enddt     }
         {mfquoter.i budgflag  }
         {mfquoter.i budgetcode}
         {mfquoter.i zeroflag  }
         if use_sub then do:
            {mfquoter.i sub    }
            {mfquoter.i sub1   }
         end.
         if use_cc then do:
            {mfquoter.i ctr    }
            {mfquoter.i ctr1   }
         end.
         {mfquoter.i level     }
         if use_sub then do:
            {mfquoter.i subflag}
         end.
         if use_cc then do:
            {mfquoter.i ccflag }
         end.
         {mfquoter.i prtflag   }
         {mfquoter.i prt1000   }
         {mfquoter.i roundcnts }
         {mfquoter.i cmmt-yn   }
         {mfquoter.i cmmt_type }
         {mfquoter.i cmmt_ref  }
/*L01G* /*L00S*/ if et_tk_active then do: */
/*L00S*/    {mfquoter.i et_report_curr}
/*L01W* /*L00S*/    {mfquoter.i et_report_rate} */
/*L01G* /*L00S*/ end. /* if et_tk_active then do: */ */
END PROCEDURE.
/*L00S End added*/

/*K1RK* start add section ***************/
procedure print-comments:
        for each cd_det
           fields (cd_cmmt cd_ref cd_type)
           where cd_ref = cmmt_ref and cd_type = cmmt_type
                      no-lock:
           do i = 1 to 15:
              if cd_cmmt[i] <> "" then do:
                if line-count > page-size then page.
                put cd_cmmt[i] at 14 skip.
              end.
           end.
           put skip.
        end.
end procedure.
/*K1RK* end of add section *********/

/*L017*/   /* Added following section */
procedure p-euro1:
         for each bg_mstr fields (bg_fpos bg_acc bg_code) no-lock
         where bg_code = budgetcode and
         bg_acc = "" use-index bg_ind1:

            for first fm_mstr fields (fm_fpos fm_type)
            no-lock where fm_fpos = bg_fpos: end.
            if available fm_mstr and fm_type = "I" then do:
               for first ac_mstr fields (ac_type ac_fpos)
               no-lock where ac_fpos = fm_fpos: end.
               if available ac_mstr and ac_type = "I" then do:
                  {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr &per=per_beg
                            &per1=per_end &budget=balance &bcode=budgetcode}
                  assign income = income + balance.
               end.
            end.
         end.
end procedure.
/*L017*/  /* End of added */
