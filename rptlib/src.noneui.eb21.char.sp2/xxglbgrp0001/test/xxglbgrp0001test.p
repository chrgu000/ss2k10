/* glbgrp.p - GENERAL LEDGER BUDGET REPORT                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.21 $                                                           */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 06/01/87   BY: JMS                       */
/* REVISION: 4.0                     02/25/88   BY: JMS                       */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG *A175*                */
/*                                   03/14/88   by: jms                       */
/*                                   08/01/88   by: jms *A374*                */
/* REVISION: 5.0      LAST MODIFIED: 05/24/89   by: jms *B066*                */
/*                                   06/26/89   by: jms *B135*                */
/*                                   08/11/89   by: jms *B239*                */
/*                                   11/20/89   by: jms *B398*                */
/* REVISION: 6.0      LAST MODIFIED: 08/14/90   by: jms *D034*                */
/*                                   02/26/91   by: jms *D366*                */
/* REVISION: 7.0      LAST MODIFIED: 10/29/91   by: jms *F058*                */
/*                                         (major re-write)                   */
/* REVISION: 7.3      LAST MODIFIED: 12/15/92   by: mpp *G479*                */
/*                                   03/16/93   by: skk *G825*                */
/*                                   04/07/93   by: skk *G918*                */
/*                                   04/20/93   by: jms *G992*                */
/*                                   12/20/93   by: srk *GI17*                */
/*                                   09/03/94   by: srk *FQ80*                */
/*                                   02/21/95   by: str *G0FM*                */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   by: bvm *K11B*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/24/98   BY: *L00S* D. Sidel           */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 08/11/98   BY: *L05N* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 09/10/98   BY: *L092* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 09/21/98   BY: *L08W* Russ Witt          */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *N0G5* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/16/00   BY: *N0TH* Manish K.          */
/* Revision: 1.20     BY: Paul Donnelly (SB)    DATE: 06/26/03 ECO: *Q00D*    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.21 $    BY: Vandna Rohira         DATE: 10/08/03  ECO: *P159*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/

/* SS - 090205.1 By: Bill Jiang */

/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "090205.1"}

/* SS - 090205.1 - B */
{xxglbgrp0001.i "new"}
/* SS - 090205.1 - E */

/*! ECO G0FM BACKS OUT G479 AS ENTITY CURRENCY NOT IMPLEMENTED  */

/* LOCAL VARIABLES */
define variable glname  like en_name.
define variable acc     like bgd_acc.
define variable acc1    like bgd_acc.
define variable sub     like bgd_sub.
define variable sub1    like bgd_sub.
define variable ctr     like bgd_cc.
define variable ctr1    like bgd_cc.
define variable fpos    like fm_fpos.
define variable fpos1   like fm_fpos.
define variable proj    like bgd_project.
define variable proj1   like bgd_project.
define variable per     like bgd_per format ">>9".
define variable per1    like bgd_per format ">>9".
define variable yr      like bgd_year.
define variable yr1     like bgd_year.
define variable peryr   as character format "X(8)".
define variable peryr1  as character format "x(6)"
   column-label "Per!Year".
define variable cumflag like mfc_logical initial no
   label "Cumulative Only".
define variable desc1   like ac_desc.
define variable entity  like en_entity.
define variable entity1 like en_entity.
define variable code    like bg_code.
define variable code1   like bg_code.
define variable use_cc  like co_use_cc.
define variable use_sub like co_use_sub.
define variable account as character format "x(22)"
   label "Account".
define variable b_account as character format "x(22)"
   label "Base Account".
define variable totamt  like bgd_amt.
define variable et_diff_amt  like bgd_amt.
define variable et_bgd_amt   like bgd_amt.
define variable et_totamt    like bgd_amt.

/* COMMON EURO VARIABLES        */
{etvar.i   &new = "new"}
/* COMMON EURO REPORT VARIABLES */
{etrpvar.i &new = "new"}
/* SOME INITIALIZATIONS         */
{eteuro.i              }

/* READ GENERAL LEDGER CONTROL FILE */
find first co_ctrl
   where co_ctrl.co_domain = global_domain no-lock no-error.
if available co_ctrl
then do:
   assign
      use_cc  = co_use_cc
      use_sub = co_use_sub.
   release co_ctrl.
end. /* IF AVAILABLE co_ctrl */

/* GET NAME OF PRIMARY ENTITY */
find en_mstr
   where en_mstr.en_domain = global_domain
   and  en_entity          = current_entity no-lock no-error.
if not available en_mstr
then do:
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3}
   /* NO PRIMARY ENTITY DEFINED */
   if c-application-mode <> "WEB"
   then
      pause.
   leave.
end. /* IF NOT AVAILABLE en_mstr */
else do:
   assign
      glname  = en_name
      entity  = en_entity
      entity1 = en_entity.
   release en_mstr.
end. /* IF AVAILABLE en_mstr */

/* GET CURRENT YEAR */
{glper1.i today peryr}
if peryr <> ""
then
   assign
      yr  = glc_year
      yr1 = glc_year.

assign
   per1  = 999
   fpos1 = 999999.

/* SELECT FORM */
form
   entity  colon 25    entity1 colon 50 label {t001.i}
   code    colon 25    code1   colon 50 label {t001.i}
   acc     colon 25    acc1    colon 50 label {t001.i}
   sub     colon 25    sub1    colon 50 label {t001.i}
   ctr     colon 25    ctr1    colon 50 label {t001.i}
   fpos    colon 25    fpos1   colon 50 label {t001.i}
   proj    colon 25    proj1   colon 50 label {t001.i}
   yr      colon 25    yr1     colon 50 label {t001.i}
   per     colon 25    per1    colon 50 label {t001.i} skip(1)
   /* SS - 090205.1 - B */
   /*
   cumflag colon 25
   et_report_curr colon 25
   */
   /* SS - 090205.1 - E */

with frame a side-labels attr-space
   title color normal glname width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}

repeat:

   /* INITIALIZE VARIABLES */
   if entity1 = hi_char then entity1 = "".
   if code1   = hi_char then code1   = "".
   if acc1    = hi_char then acc1    = "".
   if sub1    = hi_char then sub1    = "".
   if ctr1    = hi_char then ctr1    = "".
   if proj1   = hi_char then proj1    = "".

   if c-application-mode <> "WEB"
   then
      update
         entity
         entity1
         code
         code1
         acc
         acc1
         sub when (use_sub)
         sub1 when (use_sub)
         ctr when (use_cc)
         ctr1 when (use_cc)
         fpos
         fpos1
         proj
         proj1
         yr
         yr1
         per
         per1
         /* SS - 090205.1 - B */
         /*
         cumflag
         et_report_curr
         */
         /* SS - 090205.1 - E */
   with frame a.

   {wbrp06.i &command = update &fields = "  entity entity1 code
        code1 acc acc1 sub when (use_sub) sub1 when (use_sub) ctr
        when (use_cc) ctr1 when (use_cc) fpos fpos1 proj
        proj1 yr yr1 per per1 
        /* SS - 090205.1 - B */
        /*
        cumflag
        et_report_curr
        */
        /* SS - 090205.1 - E */
        " &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      run create-batch-input-string.

      if et_report_curr <> ""
      then do:
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input et_report_curr,
              output mc-error-number)"}
         if mc-error-number = 0
            and et_report_curr <> base_curr
         then do:

            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input et_report_curr,
                 input base_curr,
                 input "" "",
                 input et_eff_date,
                 output et_rate2,
                 output et_rate1,
                 output mc-seq,
                 output mc-error-number)"}
         end.  /* if mc-error-number = 0 */

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            if c-application-mode = "WEB" then return.

            /* SS - 090205.1 - B */
            /*
            next-prompt et_report_curr with frame a.
            */
            /* SS - 090205.1 - E */
            undo, retry.
         end.  /* if mc-error-number <> 0 */
         else if et_report_curr <> base_curr
         then do:

            {gprunp.i "mcui" "p" "mc-ex-rate-output"
               "(input et_report_curr,
                 input base_curr,
                 input et_rate2,
                 input et_rate1,
                 input mc-seq,
                 output mc-exch-line1,
                 output mc-exch-line2)"}

            run ip-delete-ex-rate-usage (input mc-seq).

         end. /* IF et_report_curr <> base_curr */
      end.  /* IF et_report_curr <> "" */

      if et_report_curr = "" or
         et_report_curr = base_curr
      then
         assign
            mc-exch-line1  = ""
            mc-exch-line2  = ""
            et_report_curr = base_curr.

   end.  /* if (c-application-mode <> "WEB") ... */

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
   /* SS - 090205.1 - B */
   /*
   {mfphead.i}

   for each bg_mstr
      where bg_mstr.bg_domain = global_domain
      and   bg_entity        >= entity
      and   bg_entity        <= entity1
      and   bg_code          >= code
      and   bg_code          <= code1
      and   bg_acc           >= acc
      and   bg_acc           <= acc1
      and   bg_sub           >= sub
      and   bg_sub           <= sub1
      and   bg_cc            >= ctr
      and   bg_cc            <= ctr1
      and   bg_fpos          >= fpos
      and   bg_fpos          <= fpos1
      and   bg_project       >= proj
      and   bg_project       <= proj1 no-lock
         break by bg_entity
               by bg_code
               by bg_acc
               by bg_sub
               by bg_cc
               by bg_fpos
               by bg_project:

      find en_mstr
         where en_mstr.en_domain = global_domain
         and   en_entity = bg_entity no-lock no-error.
      desc1 = "".
      if bg_acc <> ""
      then do:
         find ac_mstr
            where ac_mstr.ac_domain = global_domain
            and   ac_code           = bg_acc no-lock no-error.
         if available ac_mstr
         then
            desc1 = ac_desc.
      end. /* IF bg_acc <> "" */
      else do:
         find fm_mstr
            where fm_mstr.fm_domain = global_domain
            and   fm_fpos           = bg_fpos no-lock no-error.
         if available fm_mstr
         then
            desc1 = fm_desc.
      end. /* IF bg_acc = "" */

      {glacct.i &acc=bg_acc &sub=bg_sub &cc=bg_cc &acct=account}
      {glacct.i &acc=bg_budg_acc &sub=bg_budg_sub &cc=bg_budg_cc
         &acct=b_account}

      /* PRINT CUMMULATIVE BUDGETS ONLY */
      for each bgd_det
         where bgd_det.bgd_domain = global_domain
         and   bgd_entity         = bg_entity
         and   bgd_code           = bg_code
         and   bgd_acc            = bg_acc
         and   bgd_sub            = bg_sub
         and   bgd_cc             = bg_cc
         and   bgd_fpos           = bg_fpos
         and   bgd_project        = bg_proj
         and   bgd_year          >= yr
         and   bgd_year          <= yr1
         and   bgd_per           >= per
         and   bgd_per           <= per1 no-lock
            break by bgd_entity
                  by bgd_code
                  by bgd_acc
                  by bgd_sub
                  by bgd_cc
                  by bgd_fpos
                  by bgd_project
                  by bgd_year
         with down frame b width 132 no-box:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         if et_report_curr <> base_curr
         then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input bgd_amt,
                 input true,    /* ROUND */
                 output et_bgd_amt,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-error-number <> 0 */
         end.  /* IF et_report_curr <> base_curr */
         else
            et_bgd_amt = bgd_amt.

         accumulate bgd_amt (total by bgd_year).
         accumulate et_bgd_amt (total by bgd_year).
         peryr1 = string(bgd_per,"999") + "/" +
            substring(string(bgd_year), 3, 2).

         if not cumflag
         then do:
            if first-of(bgd_year)
            then
               display
                  bg_entity
                  bg_code column-label "Budget!Code"
                  account
                  bg_fpos
                  bg_project
                  desc1
                  b_account
                  bg_budg_fpos with frame b.

            display
               peryr1     at 11
               bgd_ent_dt column-label "Entered!Date" at 18
               bgd_pct    column-label "Percent" at 30
               et_bgd_amt to 71 format "->>,>>>,>>>,>>9.99"
               et_report_curr column-label "Cur"
            with frame c width 132 down.
            down with frame c.

         end.  /* IF NOT cumflag */

         setFrameLabels(frame c:handle).
         if last-of(bgd_year)
         then do:
            if cumflag
            then do:

               display
                  bg_entity
                  bg_code column-label "Budget!Code"
                  account
                  bg_fpos
                  bg_project column-label "Proj"
                  desc1
                  b_account
                  bg_budg_fpos
               with frame b.

               display
                  bgd_year @ peryr1
                  accum total by bgd_year
                  et_bgd_amt @ et_bgd_amt
               with frame c width 132 down.
               down with frame c.
            end.  /* IF cumflag */

            else do:

               put fill ("-",18) format "x(18)" at 54 .

               display accum total et_bgd_amt @ et_bgd_amt

               with frame c width 132 down.
               down with frame c.
            end. /* IF NOT cumflag */
            assign
               totamt    = totamt + accum total by bgd_year bgd_amt
               et_totamt = et_totamt + accum total by bgd_year et_bgd_amt.
         end.  /* IF LAST-OF(bgd_year) */
      end.  /* FOR EACH bgd_det */

      if last(bg_entity)
      then do:

         run display-diffs.

      end.  /* if last(bg_entity) */

      {mfrpchk.i}

   end. /* FOR EACH bg_mstr  */

   /* REPORT TRAILER  */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   EMPTY TEMP-TABLE ttxxglbgrp0001.
   {gprun.i ""xxglbgrp0001.p"" "(
      input entity,
      input entity1,
      input code,
      input code1,
      input acc,
      input acc1,
      input sub,
      input sub1,
      input ctr,
      input ctr1,
      input fpos,
      input fpos1,
      input proj,
      input proj1,
      input yr,
      input yr1,
      input per,
      input per1
      )"}
   EXPORT DELIMITER ";" "bg_entity" "bg_code" "bg_acc" "bg_sub" "bg_cc" "bg_fpos" "bg_project" "desc1" "b_account" "bg_budg_fpos" "bgd_per" "bgd_year" "bgd_ent_dt" "bgd_pct" "et_bgd_amt" "et_report_curr".
   FOR EACH ttxxglbgrp0001:
      EXPORT DELIMITER ";" ttxxglbgrp0001.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   /* REPORT TRAILER  */
   {xxmfrtrail.i}
   /* SS - 090205.1 - E */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}

PROCEDURE create-batch-input-string:
/*-----------------------------------------------------------------
Purpose: Run mfquoter for all input variables
Parameters:
Notes:   Added with patch /*L00S*/
-----------------------------------------------------------------*/

   bcdparm = "".

   {mfquoter.i entity }
   {mfquoter.i entity1}
   {mfquoter.i code   }
   {mfquoter.i code1  }
   {mfquoter.i acc    }
   {mfquoter.i acc1   }
   if use_sub
   then do:
      {mfquoter.i sub    }
      {mfquoter.i sub1   }
   end. /* IF use_sub */
   if use_cc
   then do:
      {mfquoter.i ctr    }
      {mfquoter.i ctr1   }
   end. /* IF use_cc */
   {mfquoter.i fpos   }
   {mfquoter.i fpos1  }
   {mfquoter.i proj   }
   {mfquoter.i proj1  }
   {mfquoter.i yr     }
   {mfquoter.i yr1    }
   {mfquoter.i per    }
   {mfquoter.i per1   }
   {mfquoter.i cumflag}
   {mfquoter.i et_report_curr}

   if acc1    = "" then acc1    = hi_char.
   if sub1    = "" then sub1    = hi_char.
   if ctr1    = "" then ctr1    = hi_char.
   if proj1   = "" then proj1   = hi_char.
   if entity1 = "" then entity1 = hi_char.
   if code1   = "" then code1   = hi_char.

   assign
      totamt    = 0
      et_totamt = 0.

END PROCEDURE.

PROCEDURE display-diffs:
/*-----------------------------------------------------------------
Purpose:
Parameters:
Notes:   Added with patch /*L01W*/
-----------------------------------------------------------------*/

   put
      skip
      fill ("=",18) format "x(18)" at 54
      skip

      {gplblfmt.i
      &FUNC=getTermLabel(""TOTAL"",10)
      &CONCAT="' '"
      } at 40 et_totamt to 71 skip.

   if et_report_curr <> base_curr
   then
      put
         mc-curr-label
         et_report_curr skip
         mc-exch-label
         mc-exch-line1 skip
         mc-exch-line2 at 22.

   if et_report_curr <> base_curr
   then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input base_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input totamt,
           input true,    /* ROUND */
           output totamt,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */

   end.  /* IF et_report_curr <> base_curr */

   et_diff_amt = et_totamt - totamt.

   if et_diff_amt <> 0 and
      et_ctrl.et_show_diff
   then
      put
        et_diff_txt to 105
        et_diff_amt to 128.

END PROCEDURE.

PROCEDURE ip-delete-ex-rate-usage:
/*-----------------------------------------------------------------
Purpose:    Delete exchange rate usage records
Parameters: Sequence number of exchange rate usage records
Notes:      Added with patch /*L092*/
-----------------------------------------------------------------*/

   define input parameter i_seq like exru_seq no-undo.

   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage" "(input i_seq)"}

END PROCEDURE.
