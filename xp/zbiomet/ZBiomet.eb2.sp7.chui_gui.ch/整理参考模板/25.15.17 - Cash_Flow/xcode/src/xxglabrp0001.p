/* glabrp.p - GENERAL LEDGER ACCOUNT BALANCES REPORT                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*F0PN*/ /*V8:ConvertMode=Report                                          */
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
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt       */
/* REVISION: 8.6E     LAST MODIFIED: 11/18/98   BY: *J34P* Hemali Desai    */
/* REVISION: 9.1      LAST MODIFIED: 08/03/99   BY: *N014* Murali Ayyagari */
/* REVISION: 9.1      LAST MODIFIED: 01/28/00   BY: *L0QN* Atul Dhatrak    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00 BY: *N0QF* Mudit Mehta       */
/* $Revision: 1.22 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.22 $ BY: Bill Jiang DATE: 11/17/06 ECO: *SS - 20061117.1* */

/*-Revision end---------------------------------------------------------------*/


/*J240********** GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND FOR SMALLER r-CODE *******J240*/

/* SS - 20061117.1 - B */                                                                            
/*
/*L00M*/ {mfdtitle.i "2+ "}
/*L00M*  {mfdtitle.i "2+ "} */
*/
/*L00M*/ {xxmfdtitle.i "2+ "}

define input parameter i_entity like gltr_entity.
define input parameter i_entity1 like gltr_entity.
define input parameter i_acc like ac_code.
define input parameter i_acc1 like ac_code.
define input parameter i_sub like sb_sub.
define input parameter i_sub1 like sb_sub.
define input parameter i_ctr like cc_ctr.
define input parameter i_ctr1 like cc_ctr.
define input parameter i_begdt like gltr_eff_dt.
define input parameter i_enddt like gltr_eff_dt.
define input parameter i_rpt_curr like gltr_curr.
define input parameter i_et_report_curr  like exr_curr1.
/* SS - 20061117.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glabrp_p_2 "Curr"
/* MaxLen: Comment: */

/*N0QF***********BEGIN COMMENTING*************
 * &SCOPED-DEFINE glabrp_p_1 "Period Activity  "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glabrp_p_3 "Ending Balance  "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glabrp_p_4 "Beginning Balance"
 * /* MaxLen: Comment: */
 *
 * /*N014* &SCOPED-DEFINE glabrp_p_5 "Account         Description" */
 * /*N014*/ &SCOPED-DEFINE glabrp_p_5 "Account                 Description"
 * /* MaxLen: 48 Comment: Label for Account and the Description in the report */
 *N0QF***********END COMMENTING************* */

&SCOPED-DEFINE glabrp_p_6 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp_p_7 "Summarize Cost Centers"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          define new shared variable glname like en_name  no-undo.
          define new shared variable per as integer  no-undo.
          define new shared variable per1 as integer  no-undo.
          define new shared variable yr as integer  no-undo.
          define new shared variable begdt like gltr_eff_dt  no-undo.
          define new shared variable begdt1 like gltr_eff_dt  no-undo.
          define new shared variable begdt0 like begdt  no-undo.
          define new shared variable enddt like gltr_eff_dt  no-undo.
          define new shared variable enddt1 like gltr_eff_dt  no-undo.
          define new shared variable enddt0 like enddt  no-undo.
          define new shared variable yr_beg like gltr_eff_dt  no-undo.
          define new shared variable yr_end as date  no-undo.
          define new shared variable acc like ac_code  no-undo.
          define new shared variable acc1 like ac_code  no-undo.
          define new shared variable sub like sb_sub  no-undo.
          define new shared variable sub1 like sb_sub  no-undo.
          define new shared variable ctr like cc_ctr  no-undo.
          define new shared variable ctr1 like cc_ctr  no-undo.
          /* SS - 20061117.1 - B */
          /*
          define new shared variable ccflag like mfc_logical
             label {&glabrp_p_7}  no-undo.
          define new shared variable subflag like mfc_logical
             label {&glabrp_p_6}  no-undo.
          */
          define new shared variable ccflag like mfc_logical
             INITIAL YES label {&glabrp_p_7}  no-undo.
          define new shared variable subflag like mfc_logical
             INITIAL YES label {&glabrp_p_6}  no-undo.
          /* SS - 20061117.1 - E */
          define new shared variable oldacc like ac_code  no-undo.
          define new shared variable entity like gltr_entity  no-undo.
          define new shared variable entity1 like gltr_entity  no-undo.
          define new shared variable entity0 like gltr_entity  no-undo.
          define new shared variable cname like glname  no-undo.
          define new shared variable ret like ac_code  no-undo.
          define new shared variable disp_curr like gltr_curr
             label {&glabrp_p_2}  no-undo.
          define new shared variable begdtxx as date  no-undo.
          define new shared variable rpt_curr like gltr_curr  no-undo.

          define variable peryr   as   character format "x(8)"  no-undo.
          define variable use_cc  like co_use_cc   no-undo.
          define variable use_sub like co_use_sub  no-undo.

/*L0QN*/  define variable l_begdt like mfc_logical no-undo.
/*L0QN*/  define variable l_enddt like mfc_logical no-undo.

/*L00M*ADD SECTION*/
          {etvar.i   &new = "new"} /* common euro variables        */
          {etrpvar.i &new = "new"} /* common euro report variables */
          {eteuro.i              } /* some initializations         */
/*L00M*END ADD SECTION*/

          /* GET NAME OF CURRENT ENTITY */

/*J240**  find en_mstr where en_entity = current_entity no-lock no-error. **/
          for first en_mstr fields( en_domain en_entity en_name en_curr)
/*J240*/      no-lock  where en_mstr.en_domain = global_domain and  en_entity =
current_entity: end.

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

          /* SS - 20061117.1 - B */
          /*
          /* SET EXTERNAL LABELS */
          setFrameLabels(frame a:handle).
          */
          entity = i_entity.
          entity1 = i_entity1.
          acc = i_acc.
          acc1 = i_acc1.
          sub = i_sub.
          sub1 = i_sub1.
          ctr = i_ctr.
          ctr1 = i_ctr1.
          begdt = i_begdt.
          enddt = i_enddt.
          rpt_curr = i_rpt_curr.
          et_report_curr = i_et_report_curr.
          /* SS - 20061117.1 - E */

          /* GET RETAINED EARNINGS ACCOUNT CODE FROM CONTROL FILE */
/*J240**  find first co_ctrl no-lock no-error. **/
/*J240*/  for first co_ctrl fields( co_domain co_ret co_use_cc co_use_sub)
/*J240*/      where co_ctrl.co_domain = global_domain no-lock: end.
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

          /* DEFINE FORM */
/*N014*   BEGIN DELETE *
 *          form header
 *            cname at 1 skip
 * /*L01W*/     mc-curr-label at 27 et_report_curr skip
 * /*L01W*/     mc-exch-label at 27 mc-exch-line1 at 49
 * /*L01W*/     mc-exch-line2 at 49 skip(1)
 *             {&glabrp_p_4} to 66
 *             {&glabrp_p_1} to 92
 *             {&glabrp_p_3} to 117 skip
 *             {&glabrp_p_5} at 1
 *             begdt at 55
 *             begdt0 at 74 "-" enddt
 *             enddt0 to 112 skip
 *             "--------------- ------------------------" at 1
 *             "-----------------------" to 69
 *             "-----------------------" to 94
 *             "-----------------------" to 119
 *         with frame phead1 page-top width 132.
 *N014*   END DELETE */

/*N014*/  /* BEGIN ADD */
          /* SS - 20061117.1 - B */
          /*
          form header
             cname at 1 skip
             mc-curr-label at 27 et_report_curr skip
             mc-exch-label at 27 mc-exch-line1 at 49
             mc-exch-line2 at 49 skip(1)
/*N0QF*
 *           {&glabrp_p_4} to 74
 *           {&glabrp_p_1} to 100
 *           {&glabrp_p_3} to 125 skip
 *           {&glabrp_p_5} at 1
 *N0QF*/
/*N0QF*/     getTermLabelRt("BEGINNING_BALANCE",25) to 74 format "x(25)"
/*N0QF*/     getTermLabelRt("PERIOD_ACTIVITY",22) + "  " to 100 format "x(24)"
/*N0QF*/     getTermLabelRt("ENDING_BALANCE",22) + "  " to 125 format "x(24)" skip
/*N0QF*/     getTermLabel("ACCOUNT",22) format "x(22)" at 1
/*N0QF*/     getTermLabel("DESCRIPTION",30) at 25 format "x(30)"
             begdt at 63
             begdt0 at 82 "-" enddt
             enddt0 to 120 skip
             "----------------------- ------------------------" at 1
             "-----------------------" to 77
             "-----------------------" to 102
             "-----------------------" to 127
          with frame phead1 page-top width 132.
          */
          /* SS - 20061117.1 -E */
/*N014*/  /* END ADD */

         {wbrp01.i}

/* REPORT BLOCK */
            /* SS - 20061117.1 - B */
            /*
         mainloop:
         repeat:
              */
            /* SS - 20061117.1 - E */
/*L0QN*/    assign
/*L0QN*/       l_begdt = no
/*L0QN*/       l_enddt = no.

            if entity1 = hi_char then assign entity1 = "".
            if acc1 = hi_char then assign acc1 = "".
            if sub1 = hi_char then assign sub1 = "".
            if ctr1 = hi_char then assign ctr1 = "".
            /* SS - 20061117.1 - B */
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
            /* SS - 20061117.1 - E */

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

/*L0QN*/       /* TO AVOID SCOPING PROBELM OF INTERNAL PROCEDURE VALIDATE-   */
/*L0QN*/       /* INPUT SO THAT CONTROL WOULD BE PLACED ON THE RESPECTIVE    */
/*L0QN*/       /* FROM OR TO DATE FIELDS WHEN ERROR IS RECEIVED AND HENCE    */
/*L0QN*/       /* AVOID TO GENERATE REPORT WITH ERRONEOUS SELECTION CRITERIA */

/*L0QN*/       if l_begdt or
/*L0QN*/          l_enddt
/*L0QN*/       then do:
/*L0QN*/          if c-application-mode = 'web':u then return.
/*L0QN*/          else
/*L0QN*/          do:
/*L0QN*/             if l_begdt
/*L0QN*/             then
/*L0QN*/                next-prompt begdt with frame a.
/*L0QN*/             else
/*L0QN*/                next-prompt enddt with frame a.
/*L0QN*/             undo, retry.
/*L0QN*/          end. /* ELSE IF C-APPLICATION-MODE */
/*L0QN*/       end. /* IF L_BEGDT OR L_ENDDT */

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

           /* SELECT PRINTER */
           /* SS - 20061117.1 - B */
           /*
           {mfselbpr.i "printer" 132}
           {mfphead.i}

           view frame phead1.
           */
             /* SS - 20061117.1 -E */
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
           /* SS - 20061117.1 - B */
           /*
/*J240*/   if can-find (first glt_det  where glt_det.glt_domain = global_domain
and  glt_entity >= entity and
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
           /* SS - 20061117.1 - E */

           /* CYCLE THROUGH ACCOUNT FILE */
           /* SS - 20061117.1 - B */
           /*
           {gprun.i ""glabrpa.p""}

           /* REPORT TRAILER */
           {mfrtrail.i}

        end.
        */
           {gprun.i ""xxglabrp0001a.p""}
        /* SS - 20061117.1 - B */
        {wbrp04.i &frame-spec = a}

/*L01W BEGIN ADD*/
procedure validate-input:
/*J240*/  for first glc_cal fields( glc_domain glc_end glc_per glc_start
glc_year)
/*J240*/  no-lock  where glc_cal.glc_domain = global_domain and  glc_year = yr
and glc_per = 1: end.

          if not available glc_cal then do:
             {mfmsg.i 3033 3} /* NO FIRST PERIOD DEFINED FOR THIS
                                 FISCAL YEAR. */
/*L0QN*/     assign
/*L0QN*/        l_enddt = yes.
/*L0QN*/     return.
/*L0QN*   BEGIN DELETE
 *           if c-application-mode = 'web':u then return.
 *           else next-prompt enddt with frame a.
 *           undo, retry.
 *L0QN*   END DELETE */
          end.
          if begdt = ? then assign begdt = glc_start.
          /* SS - 20061117.1 - B */
          /*
          display begdt enddt with frame a.
          */
          /* SS - 20061117.1 - E */
          assign yr_beg = glc_start.
          if begdt < glc_start then do:
             {mfmsg.i 3031 3} /* REPORT CANNOT SPAN FISCAL YEAR */
/*L0QN*/     assign
/*L0QN*/        l_enddt = yes.
/*L0QN*/     return.
/*L0QN*   BEGIN DELETE
 *           if c-application-mode = 'web':u then return.
 *           else next-prompt enddt with frame a.
 *           undo, retry.
 *L0QN*   END DELETE */
          end.
          if begdt > enddt then do:
             {mfmsg.i 27 3} /* INVALID DATE */
/*L0QN*/     assign
/*L0QN*/        l_begdt = yes.
/*L0QN*/     return.
/*L0QN*   BEGIN DELETE
 *           if c-application-mode = 'web':u then return.
 *           else next-prompt begdt with frame a.
 *           undo, retry.
 *L0QN*   END DELETE */
          end.
          {glper1.i begdt peryr}
          if peryr = "" then do:
             {mfmsg.i 3018 3}
/*L0QN*/     assign
/*L0QN*/        l_begdt = yes.
/*L0QN*/     return.
/*L0QN*   BEGIN DELETE
 *           if c-application-mode = 'web':u then return.
 *           else next-prompt begdt with frame a.
 *           undo, retry.
 *L0QN*   END DELETE */
          end.
          assign per = glc_per.

          find last glc_cal  where glc_cal.glc_domain = global_domain and
          glc_year = yr no-lock.
          assign
             yr_end = glc_end
             begdt0 = begdt
             enddt0 = enddt.
end.
/*L01W END ADD*/
