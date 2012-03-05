/* glcrrp.p - GENERAL LEDGER CUSTOM REPORT                                  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.18 $                                                         */
/*V8:ConvertMode=Report                                                     */
/* REVISION: 4.0     LAST MODIFIED:  03/21/88   by: jms                     */
/*                                   05/10/88   by: jms   *A237*            */
/*                                   07/29/88   by: jms   *A373*            */
/*                                   10/11/88   by: jms   *A461*            */
/*                                   10/17/88   by: jms   *A476*            */
/*                                   11/08/88   by: jms   *A526*            */
/*                                   09/26/88   by: RL    *C028*            */
/*                                   01/23/89   by: jms   *A622* (rev only) */
/*                                   02/17/89   by: jms   *A656* (rev only) */
/* REVISION: 5.0     LAST MODIFIED:  05/01/89   by: jms   *B066*            */
/*                                   06/15/89   by: jms   *B147*            */
/*                                   06/15/89   by: jms   *B148* (rev only) */
/*                                   07/05/89   by: jms   *B154* (rev only) */
/*                                   07/06/89   by: jms   *B174* (rev only) */
/*                                   07/14/89   by: emb   *B184*            */
/*                                   12/22/89   by: jms   *B470* (rev only) */
/*                                   02/14/90   by: jms   *B499* (rev only) */
/* REVISION: 6.0     LAST MODIFIED:  09/21/90   by: jms   *D034*            */
/*                                   11/07/90   by: jms   *D189*            */
/*                                   02/07/91   by: jms   *D330*            */
/*                                   02/20/91   by: jms   *D366*            */
/*                                   04/03/91   by: jms   *D486*            */
/*                                   07/23/91   by: jms   *D791* (rev only) */
/* REVISION: 7.0     LAST MODIFIED:  10/03/91   by: jms   *F058*            */
/*                                   02/25/92   by: jms   *F231*            */
/*                                   04/10/92   by: jms   *F374* (rev only) */
/*                                   06/15/92   by: jms   *F661*            */
/*                                   09/02/92   by: jms   *F873* (rev only) */
/*                                   09/28/92   by: jms   *G104*            */
/* REVISION: 7.3     LAST MODIFIED:  02/23/93   by: mpp   *G479*            */
/*                                   04/07/93   by: jms   *G916* (rev only) */
/*                                   04/19/95   by: srk   *G0L1*            */
/* REVISION: 8.6     LAST MODIFIED:  10/11/97   by: ays   *K0TL*            */
/* REVISION: 8.6E    LAST MODIFIED:  02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E    LAST MODIFIED:  04/24/98   by: LN/SVA *L00S*           */
/* REVISION: 8.6E    LAST MODIFIED:  05/13/98   by: AWe   *L00Z*            */
/* REVISION: 8.6E    LAST MODIFIED:  06/11/98   BY: *L01W* Brenda Milton    */
/* REVISION: 8.6E    LAST MODIFIED:  08/06/98   BY: *H1M0* Prashanth Narayan */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *N0DJ* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *M0PQ* Falguni Dalal    */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */

/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* $Revision: 1.18 $    BY: Vihang Talwalkar DATE: 07/27/01 ECO: *M1G0*       */
/* $Revision: 1.18 $    BY: Bill Jiang DATE: 09/14/05 ECO: *SS - 20050914*       */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20050914 - B */
{a6glcrrp.i "new"}
/* SS - 20050914 - E */

{mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glcrrp_p_1 "Print for Each Cost Ctr"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_3 "Column 2 - Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_4 "Print Variances"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_6 "Budget Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_7 "Column 1 - Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_9 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_11 "Use Budgets"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_12 "Summarize Cost Centers"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_13 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_14 "Suppress Account Codes"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_15 "Suppress Zero Amounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_16 "Round to Nearest Thousand"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcrrp_p_17 "Round to Nearest Whole Unit"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable glname like en_name.
define new shared variable begdt as date extent 2.
define new shared variable enddt as date extent 2.
define new shared variable budget like mfc_logical extent 2.
define new shared variable zeroflag like mfc_logical
   label {&glcrrp_p_15}.
define new shared variable ctr like cc_ctr.
define new shared variable ctr1 like cc_ctr.
define new shared variable level as integer
   format ">9" initial 99 label {&glcrrp_p_9}.
define new shared variable varflag like mfc_logical
   initial yes label {&glcrrp_p_4}.
define new shared variable ccflag like mfc_logical
   label {&glcrrp_p_12}.
define new shared variable code like glr_code.
define new shared variable fiscal_yr as integer extent 2.
define new shared variable fiscal_yr1 as integer extent 2.
define new shared variable peryr as character format "x(8)".
define new shared variable per_end like glc_per extent 2.
define new shared variable per_beg like glc_per extent 2.
define new shared variable prtflag like mfc_logical initial yes
   label {&glcrrp_p_14}.
define new shared variable entity like en_entity.
define new shared variable entity1 like en_entity.
define new shared variable cname like glname.
define new shared variable proj like gltr_project.
define new shared variable proj1 like gltr_project.
define new shared variable pl like co_pl.
define new shared variable ret like co_ret.
define new shared variable rpt_title like glr_title.
define new shared variable hdrstring as character format "x(18)"
   extent 2.
define new shared variable budgetcode like bg_code extent 2.
define variable i as integer.
define new shared variable rpt_curr like ac_curr.
define new shared variable roundcnts like mfc_logical
   label {&glcrrp_p_17}.
define new shared variable prt1000 like mfc_logical
   label {&glcrrp_p_16}.
define new shared variable prtfmt as character format "x(30)".
define new shared variable prtfmt1 as character format "x(30)".
define new shared variable by_cc like mfc_logical
   label {&glcrrp_p_1}.
define new shared variable sub like sb_sub.
define new shared variable sub1 like sb_sub.
define new shared variable subflag like mfc_logical
   label {&glcrrp_p_13}.
define new shared variable yr_end as date extent 2 no-undo.

define variable msg1000 as character format "x(16)".
define variable cctitle as character format "x(30)".
define variable cc like cc_ctr.
define variable cc1 like cc_ctr.
define variable use_sub like co_use_sub.
define variable use_cc like co_use_cc.

{etrpvar.i &new = "NEW"}
{etvar.i   &new = "NEW"}
{eteuro.i              }

/* SELECT FORM */
form
   code           colon 30 glr_title at 50 no-label
   entity         colon 30 entity1  colon 55 label {t001.i}
   cname          colon 30
   begdt[1]       colon 30 label {&glcrrp_p_7}
   enddt[1]       colon 55 label {t001.i}
   budget[1]      colon 30 label {&glcrrp_p_11}
   budgetcode[1]  colon 55 label {&glcrrp_p_6}
   begdt[2]       colon 30 label {&glcrrp_p_3}
   enddt[2]       colon 55 label {t001.i}
   budget[2]      colon 30 label {&glcrrp_p_11}
   budgetcode[2]  colon 55 label {&glcrrp_p_6}
   sub            colon 30 sub1     colon 55 label {t001.i}
   ctr            colon 30 ctr1     colon 55 label {t001.i}
   proj           colon 30 proj1    colon 55 label {t001.i} skip
   zeroflag       colon 30
   level          colon 60
   varflag        colon 30
   prtflag        colon 60
   prt1000        colon 30
   subflag        colon 60
   roundcnts      colon 30
   ccflag         colon 60
   et_report_curr colon 30
   by_cc          colon 60
with frame a side-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* GET NAME OF CURRENT ENTITY */
find en_mstr where en_entity = current_entity no-lock no-error.
if not available en_mstr
then do:
   /* NO PRIMARY ENTITY DEFINED */
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3}
   if c-application-mode <> 'web'
   then
      pause.
   leave.
end.
else do:
   glname = en_name.
   release en_mstr.
end.

assign
   entity  = current_entity
   entity1 = current_entity
   cname   = glname.

/* READ CONTROL FILE */
find first co_ctrl no-lock no-error.
if not available co_ctrl
then do:
   /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT */
   {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
   if c-application-mode <> 'web'
   then
      pause.
   leave.
end.

assign
   pl       = co_pl
   ret      = co_ret
   use_cc   = co_use_cc
   use_sub  = co_use_sub
   rpt_curr = base_curr.

release co_ctrl.

/* DEFINE HEADERS */
/* SS - 20050914 - B */
/*
form header
   cname at 1 space(2) msg1000
   mc-curr-label at 60 et_report_curr skip
   mc-exch-label at 60 mc-exch-line1 skip
   mc-exch-line2 at 82 skip(1)
   skip
   cctitle at 1
   rpt_title at 1
   hdrstring[1] at 65  hdrstring[2] at 85
   begdt[1] at 63 {t001.i} begdt[2] at 83 {t001.i}
   enddt[1] at 65 enddt[2] at 85 getTermLabelRt("VARIANCE",20) + "  "~  format "x(22)" to 116
   "--------------------" to 76 "--------------------" to 97
   "--------------------" to 118
   skip(1) with frame phead1 page-top width 132.

form header
   cname at 1 space(2) msg1000
   mc-curr-label at 60 et_report_curr skip
   mc-exch-label at 60 mc-exch-line1 skip
   mc-exch-line2 at 82 skip(1)
   skip
   cctitle at 1
   rpt_title at 1
   hdrstring[1] at 65  hdrstring[2] at 85
   begdt[1] at 63 {t001.i} begdt[2] at 83 {t001.i}
   enddt[1] at 65 enddt[2] at 85
   "--------------------" to 76 "--------------------" to 97
   skip(1) with frame phead2 page-top width 132.

do i = 1 to 2:
   hdrstring[i] = getTermLabel("ACTIVITY",18).
   if budget[i]
   then
      hdrstring[i] = " " + getTermLabel("BUDGET",17).
end.
*/
/* SS - 20050914 - E */

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:

   /* INPUT OPTIONS */
   if ctr1    = hi_char then ctr1    = "".
   if proj1   = hi_char then proj1   = "".
   if entity1 = hi_char then entity1 = "".
   if sub1    = hi_char then sub1    = "".

   if c-application-mode <> 'web'
   then
      update code
             entity
             entity1
             cname
             begdt[1]
             enddt[1]
             budget[1]
             budgetcode[1]
             begdt[2]
             enddt[2]
             budget[2]
             budgetcode[2]
             sub when (use_sub) sub1 when (use_sub)
             ctr when (use_cc) ctr1 when (use_cc)
             proj proj1 zeroflag varflag
             prt1000 roundcnts level prtflag subflag when (use_sub)
             ccflag when (use_cc)
             et_report_curr
             by_cc when (use_cc)
      with frame a
      editing:

         if frame-field = "code"
         then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i glr_mstr code glr_code code glr_code glr_code}
            if recno <> ?
            then do:
               code = glr_code.
               display code glr_title with frame a.
            end.
         end.
         else do:
            readkey.
            apply lastkey.
         end.
      end.

   {wbrp06.i &command = update
             &fields  = " code
                          entity
                          entity1
                          cname
                          begdt  [ 1 ]
                          enddt  [ 1 ]
                          budget [ 1 ]
                          budgetcode [ 1 ]
                          begdt  [ 2 ]
                          enddt  [ 2 ]
                          budget [ 2 ]
                          budgetcode [ 2 ]
                          sub  when (use_sub)
                          sub1 when (use_sub)
                          ctr  when (use_cc)
                          ctr1 when (use_cc)
                          proj
                          proj1
                          zeroflag
                          varflag
                          prt1000
                          roundcnts
                          level
                          prtflag
                          subflag when (use_sub)
                          ccflag  when (use_cc)
                          et_report_curr
                          by_cc   when (use_cc)
                        "
             &frm="a"}

   if (c-application-mode    <> 'web')
      or (c-application-mode =  'web'
          and (c-web-request begins 'data'))
   then do:

      find glr_mstr
         where glr_code = code
      no-lock no-error.
      if not available glr_mstr
      then do:
         /* INVALID REPORT CODE */
         {pxmsg.i &MSGNUM=3047 &ERRORLEVEL=3 }
         if c-application-mode = 'web'
         then
            return.
         undo mainloop, retry.
      end.

      display glr_title with frame a.

      rpt_title  = glr_title.

      if entity1 = "" then entity1 = hi_char.
      if ctr1    = "" then ctr1    = hi_char.
      if proj1   = "" then proj1   = hi_char.
      if sub1    = "" then sub1    = hi_char.

      run validate-input.

      display begdt enddt with frame a.

      /*  CHECK FOR VALID LEVEL */
      if level    < 1
         or level > 99
      then do:
         /*INVALID LEVEL*/
         {pxmsg.i &MSGNUM=3015 &ERRORLEVEL=3}
         if c-application-mode = 'web'
         then
            return.
         else
            next-prompt level with frame a.
         undo mainloop.
      end.

      if et_report_curr <> ""
      then do:
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input  et_report_curr,
              output mc-error-number)"}
         if mc-error-number    = 0
            and et_report_curr <> rpt_curr
         then do:

            /* CURRENCIES AND RATES REVERSED BELOW... */
            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input et_report_curr,
                 input rpt_curr,
                 input "" "",
                 input et_eff_date,
                 output et_rate2,
                 output et_rate1,
                 output mc-seq,
                 output mc-error-number)"}
         end.  /* IF mc-error-number = 0 */

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            if c-application-mode = 'web'
            then
               return.
            else
               next-prompt et_report_curr with frame a.
            undo, retry.
         end.  /* IF mc-error-number <> 0 */
         else
            if et_report_curr <> rpt_curr
            then do:
               /* CURRENCIES AND RATES REVERSED BELOW...   */
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
            end.
      end.  /* IF et_report_curr <> "" */

      if et_report_curr    = ""
         or et_report_curr = rpt_curr
      then
         assign
            mc-exch-line1  = ""
            mc-exch-line2  = ""
            et_report_curr = rpt_curr.

      run create-batch-input-string.

      msg1000 = "".

      if prt1000 then
         assign msg1000 = "(" + getTermLabel("IN_1000'S",10)
                              + " " + et_report_curr + ")".

   end.  /* IF (c-application-mode <> 'web') ... */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType    = "printer"
               &printWidth   = 132
               &pagedFlag    = " "
               &stream       = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption      = "yes"
               &displayStatementType = 1
               &withCancelMessage    = "yes"
               &pageBottomMargin     = 6
               &withEmail       = "yes"
               &withWinprint    = "yes"
               &defineVariables = "yes"}
               /* SS - 20050914 - B */
       /*
   {mfphead.i}

   /* SELECT READER */
   do i = 1 to 2:

      hdrstring[i] = getTermLabel("ACTIVITY",18).
      if budget[i]
      then
         hdrstring[i] = " " + getTermLabel("BUDGET",17).
   end.

   /* SET FORMAT FOR AMOUNTS*/
   if roundcnts or prt1000
   then
      prtfmt = "(>>,>>>,>>>,>>>,>>9)".
   else
      prtfmt = "(>>>,>>>,>>>,>>9.99)".

   if not by_cc
   then do:
      cctitle    = "".
      if varflag = yes
      then
         view frame phead1.
      else
         view frame phead2.

      {gprun.i ""glcrrpa.p""}
   end.
   else do:

      /* PRINT REPORT FOR EACH COST CENTER */
      assign
         cc  = ctr
         cc1 = ctr1.
      for each cc_mstr
         where cc_ctr >= cc
         and   cc_ctr <= cc1
      no-lock:
         assign
            cctitle = cc_ctr + " - " + cc_desc
            ctr     = cc_ctr
            ctr1    = cc_ctr.
         if varflag = yes
         then
            view frame phead1.
         else
            view frame phead2.

         {gprun.i ""glcrrpa.p""}
         page.
      end.

   end.  /* ELSE DO */

   if varflag
   then
      hide frame phead1.
   else
      hide frame phead2.

   /* REPORT TRAILER */
   {mfrtrail.i}
       */
       PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

        FOR EACH tta6glcrrp:
            DELETE tta6glcrrp.
        END.

       {gprun.i ""a6glcrrp.p"" "(
           INPUT CODE,
           INPUT entity,
           INPUT entity1,
           INPUT begdt[1],
           INPUT enddt[1],
           INPUT budget[1],
           INPUT budgetcode[1],
           INPUT begdt[2],
           INPUT enddt[2],
           INPUT budget[2],
           INPUT budgetcode[2],
           INPUT et_report_curr
       )"}

        EXPORT DELIMITER ";" "fpos" "desc" "et_tot" "et_tot1".
        FOR EACH tta6glcrrp:
            EXPORT DELIMITER ";" tta6glcrrp_fpos tta6glcrrp_desc tta6glcrrp_et_tot tta6glcrrp_et_tot1.
        END.

        PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

       {a6mfrtrail.i}
       /* SS - 20050914 - E */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}

PROCEDURE create-batch-input-string:

   bcdparm = "".
   {gprun.i ""gpquote.p""
      "(input-output bcdparm,
                     12,
                     code,
                     entity,
                     entity1,
                     cname,
                     string(begdt[1]),
                     string(enddt[1]),
                     string(budget[1]),
                     string(budgetcode[1]),
                     string(begdt[2]),
                     string(enddt[2]),
                     string(budget[2]),
                     string(budgetcode[2]),
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char,
                     null_char)"
   }
   if use_sub
   then do:
      {mfquoter.i sub       }
      {mfquoter.i sub1      }
   end.
   if use_cc
   then do:
      {mfquoter.i ctr       }
      {mfquoter.i ctr1      }
   end.
   {mfquoter.i proj         }
   {mfquoter.i proj1        }
   {mfquoter.i zeroflag     }
   {mfquoter.i varflag      }
   {mfquoter.i prt1000      }
   {mfquoter.i roundcnts    }
   {mfquoter.i level        }
   {mfquoter.i prtflag      }
   if use_sub
   then do:
      {mfquoter.i subflag   }
   end.
   if use_cc
   then do:
      {mfquoter.i ccflag    }
   end.
   {mfquoter.i et_report_curr}
   {mfquoter.i by_cc         }

END PROCEDURE.

PROCEDURE validate-input:
   do i = 1 to 2:
      /* CHECK FOR VALID REPORT DATE */
      if enddt[i] = ?
      then
         enddt[i] = today.

      /*GET PERIOD/YEAR*/
      {glper1.i enddt[i] peryr}

      if peryr = ""
      then do:
         /* DATE NOT WITHIN A VALID PERIOD */
         {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
         if c-application-mode = 'web'
         then
            return.
         else
            next-prompt enddt[i] with frame a.
         undo, retry.
      end.

      /* DETERMINE DATE OF BEGINNING OF FISCAL YEAR */
      assign
         fiscal_yr1[i] = glc_year
         per_end[i]    = glc_per.

      if begdt[i] = ?
      then do:

         find glc_cal
            where glc_year = fiscal_yr1[i]
            and   glc_per  = 1
         no-lock no-error.
         if not available glc_cal
         then do:
            /*NO FIRST PERIOD DEFINED FOR THIS FISCAL YEAR. */
            {pxmsg.i &MSGNUM=3033 &ERRORLEVEL=3}
            if c-application-mode = 'web'
            then
               return.
            else
               next-prompt begdt[i] with frame a.
            undo, retry.
         end.

         begdt[i] = glc_start.

      end.

      if begdt[i] > enddt[i]
      then do:
          /* INVALID DATE */
         {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3}
         if c-application-mode = 'web'
         then
            return.
         else
            next-prompt begdt[i] with frame a.
         undo, retry.
      end.

      /* GET PERIOD/YEAR */
      {glper1.i begdt[i] peryr}
      if peryr = ""
      then do:
         /* DATE NOT WITHIN A VALID PERIOD */
         {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
         if c-application-mode = 'web'
         then
            return.
         else
            next-prompt begdt[i] with frame a.
         undo, retry.
      end.

      assign
         per_beg[i]   = glc_per
         fiscal_yr[i] = glc_year.

      /* DETERMINE DATE OF LAST OF FISCAL YEAR */
      find last glc_cal
         where glc_year = fiscal_yr[i]
      no-lock no-error.

      yr_end[i] = glc_end.

   end.  /* DO i = 1 TO 2 */
end.
