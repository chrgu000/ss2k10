/* glbsrp.p - GENERAL LEDGER BALANCE SHEET REPORT                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.23 $                                                         */
/*K0V3*/ /*                                                                */
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
/*                                   06/19/89   by: jms  *B154* (rev only) */
/*                                   08/16/89   by: jms  *B133*            */
/*                                   09/20/89   by: jms  *B135*            */
/*                                   09/27/89   by: jms  *B316*            */
/*                                   11/21/89   by: jms  *B400*            */
/*                                   02/14/90   by: jms  *B499* (rev only) */
/*                                   06/07/90   by: jms  *B704* (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 09/10/90   by: jms  *D034*            */
/*                                   11/07/90   by: jms  *D189*            */
/*                                   12/11/90   by: jms  *D255*            */
/*                                   01/04/91   by: jms  *D287*            */
/*                                   02/20/91   by: jms  *D366*            */
/*                                   04/04/91   by: jms  *D493* (rev only) */
/*                                   04/22/91   by: jms  *D566* (rev only) */
/*                                   04/34/91   by: jms  *D577* (rev only) */
/*                                   07/22/91   by: jms  *D791* (rev only) */
/*                                   09/05/91   by: jms  *D849* (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 11/07/91   by: jms  *F058*            */
/*                                   01/31/92   by: jms  *F119*            */
/*                                   02/25/92   by: jms  *F231*            */
/*                                   06/24/92   by: jms  *F702*            */
/*                                   08/26/92   by: mpp  *F863*            */
/* REVISION 7.3       Last Modified  08/14/92   by: mpp  *G030*            */
/*                                   09/11/92   by: jms  *F890* (rev only) */
/*                                   12/30/92   by: mpp  *G479*            */
/*                                   10/21/93   by: jms  *GG57*            */
/*                                      (backs out G479)                   */
/*                                   09/11/94   by: rmh  *GM08*            */
/*                                   02/13/95   by: srk  *G0DS*            */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   by: ays  *K0V3*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     Last Modified  03/19/98   by: *J240* Kawal Batra     */
/* REVISION: 8.6E     LAST MODIFIED: 04/24/98   BY: *L00S* D. Sidel        */
/* REVISION: 8.6E     Last Modified  06/04/98   by: *K1RK* Mohan CK        */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton   */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/98   BY: *L05G* Brenda Milton   */
/* REVISION: 8.6E     LAST MODIFIED: 08/13/98   BY: *H1MY* Prashanth Narayan */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane*/
/* REVISION: 9.1      LAST MODIFIED: 08/02/00   BY: *M0QP* Falguni Dalal   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00   BY: *N0QF* Mudit Mehta     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.21  BY: Jean Miller DATE: 04/25/02 ECO: *P06H* */
/* $Revision: 1.23 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* SS - 090708.1 By: Neil Gao */
/* SS - 090817.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS 090817.1 - B */
/*
¼õÉÙheader¿í¶È
*/
/* SS 090817.1 - E */

/* SS 090708.1 - B */
{mfdtitle.i "090817.1"}
/* SS 090708.1 - E */

define new shared variable glname       like en_name  no-undo.
define new shared variable rptdt        like gltr_eff_dt
                                        label "Report Ending Date" no-undo.
define new shared variable level        as integer format ">9" initial 99
                                        label "Level"  no-undo.
define new shared variable pl_amt       as decimal no-undo.
define new shared variable yr_beg       as date no-undo.
define new shared variable yr_end       as date no-undo.
define new shared variable fiscal_yr    as integer no-undo.
define new shared variable peryr        as character format "x(8)" no-undo.
define new shared variable per_end      like glc_per no-undo.
define new shared variable per_beg      like glc_per no-undo.
define new shared variable zeroflag     like mfc_logical initial false
                                        label "Suppress Zero Amounts" no-undo.
define new shared variable ccflag       like mfc_logical no-undo
                                        label "Summarize Cost Centers".
define new shared variable subflag      like mfc_logical no-undo
                                        label "Summarize Sub-Accounts".
define new shared variable prtflag      like mfc_logical initial true no-undo
                                        label "Suppress Account Numbers".
define new shared variable budgflag     like mfc_logical
                                        label "Use Budgets"  no-undo.
define new shared variable pl_cc        like mfc_logical  no-undo.
define new shared variable pl           like co_pl        no-undo.
define new shared variable ret          like co_ret       no-undo.
define new shared variable entity       like en_entity    no-undo.
define new shared variable entity1      like en_entity    no-undo.
define new shared variable cname        like glname       no-undo.
define new shared variable hdrstring    as character format "x(14)" no-undo.
define new shared variable sub          like sb_sub       no-undo.
define new shared variable sub1         like sb_sub       no-undo.
define new shared variable ctr          like cc_ctr       no-undo.
define new shared variable ctr1         like cc_ctr       no-undo.
define new shared variable ex_gl_amt    like gltr_curramt no-undo.
define new shared variable balance      as decimal        no-undo.
define new shared variable curr_balance like gltr_curramt no-undo.
define new shared variable knt          as integer        no-undo.
define new shared variable rpt_curr     like gltr_curr
                                        label "Report currency"  no-undo.
define new shared variable budgetcode   like bg_code      no-undo.
define new shared variable prt1000      like mfc_logical no-undo
                                        label "Round to Nearest Thousand".
define new shared variable roundcnts    like mfc_logical no-undo
                                        label "Round to Nearest Whole Unit".
define new shared variable prtfmt       as character format "x(30)" no-undo.
define new shared variable per_end_dt   as date  no-undo.
define new shared variable per_end_dt1  as date  no-undo.
define new shared variable et_balance   like balance.
define new shared variable et_tot       as decimal extent 100 no-undo.

define variable msg1000    as character format "x(32)".
define variable xper       like glc_per  no-undo.
define variable use_sub    like co_use_sub  no-undo.
define variable use_cc     like co_use_cc  no-undo.
define variable l-assigned as logical  no-undo.

{etvar.i   &new = "new"} /* common euro variables        */
{etrpvar.i &new = "new"} /* common euro report variables */
{eteuro.i              } /* some initializations         */

/* SELECT FORM */
form
   entity     colon 30 entity1    colon 50 label {t001.i}
   cname      colon 30 skip(1)
   rptdt      colon 30
   budgflag   colon 30 budgetcode colon 50
   zeroflag   colon 30 skip(1)
   sub        colon 30 sub1       colon 50 label {t001.i}
   ctr        colon 30 ctr1       colon 50 label {t001.i}
   level      colon 30
   subflag    colon 30
   ccflag     colon 30
   prtflag    colon 30
   prt1000    colon 30
   roundcnts  colon 30
   et_report_curr colon 30
with frame a width 80 side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

run assign-values ( output l-assigned ).
if l-assigned = no then return.

/* DEFINE HEADERS */
form header
   cname at 1 space(2) msg1000
   mc-curr-label et_report_curr skip
   mc-exch-label at 60 mc-exch-line1 skip
   mc-exch-line2 at 82 skip(1)
   skip
   hdrstring at 62
   rptdt at 65
   "--------------------" to 77
   skip(1)
with frame phead1 page-top width 132.

{wbrp01.i}

/* REPORT BLOCK */
repeat:
   if sub1 = hi_char then assign sub1 = "".
   if ctr1 = hi_char then assign ctr1 = "".
   if entity1 = hi_char then assign entity1 = "".

   if c-application-mode <> 'web' then
      update
         entity
         entity1
         cname
         rptdt
         budgflag
         budgetcode
         zeroflag
         sub when (use_sub) sub1 when (use_sub)
         ctr when (use_cc)  ctr1 when (use_cc)
         level
         subflag when (use_sub)
         ccflag  when (use_cc)
         prtflag
         prt1000
         roundcnts
         et_report_curr
      with frame a.

   {wbrp06.i &command = update &fields = "  entity entity1 cname
        rptdt budgflag budgetcode  zeroflag sub when (use_sub) sub1
        when (use_sub) ctr when (use_cc)  ctr1 when
        (use_cc) level subflag when (use_sub)  ccflag when (use_cc)
        prtflag prt1000 roundcnts
        et_report_curr
        " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      if sub1 = "" then assign sub1 = hi_char.
      if ctr1 = "" then assign ctr1 = hi_char.
      if entity1 = "" then assign entity1 = hi_char.

      /* CHECK FOR VALID REPORT DATE */
      if rptdt = ? then rptdt = today.
      display rptdt with frame a.
      {glper1.i rptdt peryr}  /*GET PERIOD/YEAR*/
      if peryr = "" then do:
         /* DATE NOT WITHIN A VALID PERIOD */
         {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt rptdt with frame a.
         undo, retry.
      end.
      assign
         per_end = glc_per
         per_end_dt = glc_start
         per_end_dt1 = glc_end
         per_beg = 1
         fiscal_yr = glc_year.

      /* DETERMINE DATE OF BEGINNING OF FISCAL YEAR */

      for first glc_cal fields( glc_domain glc_end glc_per glc_start glc_year)
      no-lock  where glc_cal.glc_domain = global_domain and  glc_year =
      fiscal_yr and glc_per = 1:
      end.

      if not available glc_cal then do:
         /* NO FIRST PERIOD DEFINED FOR THIS FISCAL YEAR. */
         {pxmsg.i &MSGNUM=3033 &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt rptdt with frame a.
         undo, retry.
      end.
      yr_beg = glc_start.
      find last glc_cal  where glc_cal.glc_domain = global_domain and  glc_year
      = fiscal_yr no-lock no-error.
      yr_end = glc_end.

      /* VALIDATE BUDGET CODE */
      if budgflag = yes then do:
         if not can-find(first bg_mstr  where bg_mstr.bg_domain = global_domain
         and  bg_code = budgetcode)
         then do:
            {pxmsg.i &MSGNUM=3105 &ERRORLEVEL=3} /* INVALID BUDGET CODE */
            if c-application-mode = 'web' then return.
            else next-prompt budgetcode with frame a.
            undo, retry.
         end.
      end.

      run create-batch-input-string.

      /* CHECK FOR VALID LEVEL */
      if level < 1 or level > 99 then do:
         {pxmsg.i &MSGNUM=3015 &ERRORLEVEL=3}   /*INVALID LEVEL*/
         if c-application-mode = 'web' then return.
         else next-prompt level with frame a.
         undo, retry.
      end.

      if et_report_curr <> "" then do:
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input et_report_curr,
              output mc-error-number)"}
         if mc-error-number = 0
            and et_report_curr <> rpt_curr then do:

            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input et_report_curr,
                 input rpt_curr,
                 input "" "",
                 input et_eff_date,
                 output et_rate2,
                 output et_rate1,
                 output mc-seq,
                 output mc-error-number)"}
         end.  /* if mc-error-number = 0 */

         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            if c-application-mode = 'web' then return.
            else next-prompt et_report_curr with frame a.
            undo, retry.
         end.  /* if mc-error-number <> 0 */
         else if et_report_curr <> rpt_curr then do:

            {gprunp.i "mcui" "p" "mc-ex-rate-output"
               "(input et_report_curr,
                 input rpt_curr,
                 input et_rate2,
                 input et_rate1,
                 input mc-seq,
                 output mc-exch-line1,
                 output mc-exch-line2)"}
            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input mc-seq)"}
         end.  /* else do */
      end.  /* if et_report_curr <> "" */
      if et_report_curr = "" or et_report_curr = rpt_curr then
         assign
            mc-exch-line1 = ""
            mc-exch-line2 = ""
            et_report_curr = rpt_curr.

      msg1000 = "".

      if prt1000 then
         msg1000 = "("+ getTermLabel("IN_1000'S",15) + " "
                 + et_report_curr + ")".

   end.  /* if (c-application-mode <> 'web') */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

/* SS 090817.1 - B */
/*
   {mfphead.i}
*/
   {mfphead2.i}
/* SS 090817.1 - E */

   run print-report.

   /* REPORT TRAILER */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}

PROCEDURE assign-values:

   define output parameter l-assigned as logical.

   l-assigned = no.

   /* GET NAME OF PRIMARY ENTITY */

   for first en_mstr  fields( en_domain en_name en_entity)
       where en_mstr.en_domain = global_domain and  en_entity = current_entity
       no-lock:
   end.

   if not available en_mstr then do:
      {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
      if not batchrun then
         if c-application-mode <> 'web' then
            pause.
      leave.
   end.
   else do:
      glname = en_name.
      release en_mstr.
   end.

   assign
      entity = current_entity
      entity1 = current_entity
      cname = glname.

   /* GET COMPANY NAME AND RETAINED EARNINGS CODE FROM CONTROL FILE */

   for first co_ctrl
      fields( co_domain co_enty_bal co_pl co_ret co_use_cc co_use_sub)  where
      co_ctrl.co_domain = global_domain no-lock:
   end.

   if not available co_ctrl then do:
      /*CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT*/
      {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
      if not batchrun then
         if c-application-mode <> 'web' then
            pause.
      leave.
   end.
   assign
      pl = co_pl
      ret = co_ret
      use_cc = co_use_cc
      use_sub = co_use_sub
      rpt_curr = base_curr.

   if co_enty_bal = no then
      assign
         entity = ""
         entity1 = ""
         cname = "".

   /* CHANGE CAN-FIND TO A FOR FIRST FOR ORACLE PERFORMANCE */

   for first ac_mstr fields( ac_domain ac_code ac_fpos ac_desc ac_type)
       where ac_mstr.ac_domain = global_domain and  ac_code=pl no-lock:
   end.
   if not available ac_mstr then do:

      {pxmsg.i &MSGNUM=3155 &ERRORLEVEL=3} /*PL ACCT NOT FOUND*/
      if not batchrun then
         if c-application-mode <> 'web' then
            pause.
      leave.
   end.
   else do:
      if not can-find(first asc_mstr  where asc_mstr.asc_domain = global_domain
      and  asc_acc=pl) then do:

         create asc_mstr. asc_mstr.asc_domain = global_domain.

         assign
            asc_acc=ac_code
            asc_sub=""
            asc_cc=""
            asc_fpos=ac_fpos
            asc_desc=ac_desc
            recno = recid(asc_mstr).

      end.
   end.

   assign l-assigned = yes.
END PROCEDURE. /* assign-values */

PROCEDURE create-batch-input-string:

   /* CREATE BATCH INPUT STRING */
   bcdparm = "".
   {mfquoter.i entity    }
   {mfquoter.i entity1   }
   {mfquoter.i cname     }
   {mfquoter.i rptdt     }
   {mfquoter.i budgflag  }
   {mfquoter.i budgetcode}
   {mfquoter.i zeroflag  }
   if use_sub then do:
      {mfquoter.i sub       }
      {mfquoter.i sub1      }
   end.
   if use_cc then do:
      {mfquoter.i ctr       }
      {mfquoter.i ctr1      }
   end.
   {mfquoter.i level     }
   if use_sub then do:
      {mfquoter.i subflag}
   end.
   if use_cc then do:
      {mfquoter.i ccflag    }
   end.
   {mfquoter.i prtflag   }
   {mfquoter.i prt1000   }
   {mfquoter.i roundcnts  }
   {mfquoter.i et_report_curr}

END PROCEDURE.

PROCEDURE print-report:

   hdrstring = getTermLabel("BALANCE_AS_OF",14).
   if budgflag then hdrstring = " " + getTermLabel("BUDGET_AS_OF",13).
   view frame phead1.

   /* CHECK FOR UNPOSTED TRANSACTIONS */

   if can-find (first glt_det  where glt_det.glt_domain = global_domain and
   glt_entity >= entity and
      glt_entity <= entity1 and
      glt_sub >= sub and glt_sub <= sub1 and
      glt_cc >= ctr and glt_cc <= ctr1 and
      glt_effdate <= rptdt )
   then do:
      /* UNPOSTED TRANSACTIONS EXIST FOR RANGES ON THIS REPORT */
      {pxmsg.i &MSGNUM=3151 &ERRORLEVEL=2}
   end.

   /* CALCULATE AMOUNT IN P/L ACCOUNT */
   if not budgflag then do:
      {glpl.i &rptdt=rptdt &yr=fiscal_yr &plamt=pl_amt &per1=per_end
         &begdt=per_end_dt &enddt=per_end_dt1}
   end.
   else do:
      {glplbg.i &yr=fiscal_yr &plamt=pl_amt &per1=per_end
         &bcode=budgetcode}

      for each bg_mstr
         fields( bg_domain bg_acc bg_code bg_fpos)
          where bg_mstr.bg_domain = global_domain and  bg_code = budgetcode and
               bg_acc = "" no-lock
            use-index bg_ind1:
         for first fm_mstr fields( fm_domain fm_fpos fm_type)
            no-lock  where fm_mstr.fm_domain = global_domain and  fm_fpos =
            bg_fpos:
         end.

         if available fm_mstr and fm_type = "I" then do:
            {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr &per=per_beg
               &per1=per_end &budget=balance &bcode=budgetcode}
            assign pl_amt = pl_amt + balance.
         end.
      end.
   end.

   /* SET FORMATS FOR AMOUNTS */
   if roundcnts or prt1000 then
      prtfmt = "(>>,>>>,>>>,>>>,>>9)".
   else
      prtfmt = "(>>>,>>>,>>>,>>9.99)".

   /* PRINT REPORT */
/* SS 090708.1 - B */
/*   
   {gprun.i ""glbsrpa.p""}
*/
   {gprun.i ""xxglbsrpa.p""}
/* SS 090708.1 - E */
   hide frame phead1.
END PROCEDURE.
