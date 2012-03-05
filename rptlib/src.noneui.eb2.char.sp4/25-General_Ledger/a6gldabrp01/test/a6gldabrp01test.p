/* gldabrp.p - GENERAL LEDGER DETAILED ACCOUNT BALANCES REPORT            */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.29.1.1 $                                                       */
/*V8:ConvertMode=Report                                                   */
/* REVISION: 1.0      LAST MODIFIED: 04/21/87   by: jms                   */
/*                                   02/01/88   by: jms  CSR 24912        */
/* REVISION: 4.0      LAST MODIFIED: 02/26/88   by: jms                   */
/*                                   02/29/88   by: wug *A175*            */
/*                                   04/11/88   by: jms                   */
/*                                   01/02/89   by: rl  *C0028*           */
/* REVISION: 5.0      LAST MODIFIED: 04/25/89   by: jms *B066*            */
/*                                   08/03/89   by: jms *B154*            */
/*                                   10/09/89   by: jms *B331*            */
/*                                   11/21/89   by: jms *B400*            */
/*                                   04/11/90   by: jms *B499*            */
/*                            (split into gldabrp.p and gldabrpa.p)       */
/* REVISION: 6.0      LAST MODIFIED: 09/06/90   by: jms *D034*            */
/*                                   01/04/91   by: jms *D287*            */
/*                                   02/22/91   by: jms *D366*            */
/*                                   08/28/91   by: jms *D837*            */
/*                                   09/05/91   by: jms *D849* (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 11/07/91   by: jms *F058*            */
/*                                   01/28/92   by: jms *F107*            */
/*                                   03/24/92   by: jms *F309*            */
/*                                   06/24/92   by: jms *F702*            */
/* REVISION: 7.3      LAST MODIFIED: 03/10/93   by: jms *G793*            */
/*                                   05/10/93   by: jms *GA83* (rev only) */
/*                                   05/25/93   by: jms *GB34* (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 07/15/93   by: skk *H026* sub/cc descrp */
/*                                   10/04/93   by: wep *H156*            */
/*                                   09/03/94   by: srk *FQ80*            */
/*                                   01/05/95   by: srk *G0B8*            */
/*                                   01/16/95   by: str *F0DS*            */
/* REVISION: 8.6      LAST MODIFIED: 06/13/96   by: jjp *K001*            */
/*                                   09/09/96   by: jzw *G2DN*            */
/*                                   12/19/96   by: rxm *J1C7*            */
/* REVISION: 8.6      LAST MODIFIED  10/11/97   by: ays *K0T2*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J241* Jagdish Suvarna*/
/* REVISION: 8.6E     LAST MODIFIED: 04/08/98   BY: *H1K1* Samir Bavkar   */
/* REVISION: 8.6E     LAST MODIFIED: 04/09/98   BY: EMS *L00S*            */
/* REVISION: 8.6e     LAST MODIFIED: 06/08/98   BY: *K1RZ* Ashok Swaminathan */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L01G* Robin McCarthy   */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01W* Brenda Milton    */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt        */
/* REVISION: 9.1      LAST MODIFIED: 08/05/99   BY: *N014* Murali Ayyagari  */
/* REVISION: 9.1      LAST MODIFIED: 01/28/00   BY: *L0QN* Atul Dhatrak     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *N0DJ* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 10/18/00   BY: *N0VQ* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.26     BY: Jean Miller           DATE: 04/25/02  ECO: *P06H* */
/* Revision: 1.27     BY: Ed van de Gevel       DATE: 12/03/02  ECO: *N1T1* */
/* Revision: 1.28     BY: Narathip W.           DATE: 05/14/03  ECO: *P0QM* */
/* Revision: 1.29     BY: Kedar Deherkar        DATE: 05/27/03  ECO: *N2G0* */
/* $Revision: 1.29.1.1 $    BY: Karan Motwani   DATE: 06/03/03  ECO: *N28Y* */
/* $Revision: 1.29.1.1 $    BY: Bill Jiang   DATE: 03/27/06  ECO: *SS - 20060327* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060327 - B */
{a6gldabrp01.i "new"}
/* SS - 20060327 - E */

{mfdtitle.i "2+ "}
{cxcustom.i "GLDABRP.P"}

define new shared variable first_acct like mfc_logical no-undo.
define new shared variable first_sub  like mfc_logical no-undo.
define new shared variable first_cc   like mfc_logical no-undo.
define new shared variable glname     like en_name no-undo.
define new shared variable per        as integer no-undo.
define new shared variable per1       as integer no-undo.
define new shared variable yr         as integer no-undo.
define new shared variable begdt      like gltr_eff_dt no-undo.
define new shared variable enddt      like gltr_eff_dt no-undo.
define new shared variable yr_beg     like gltr_eff_dt no-undo.
define new shared variable yr_end     as date no-undo.
define new shared variable acc        like ac_code no-undo.
define new shared variable acc1       like ac_code no-undo.
define new shared variable sub        like sb_sub no-undo.
define new shared variable sub1       like sb_sub no-undo.
define new shared variable ctr        like cc_ctr no-undo.
define new shared variable ctr1       like cc_ctr no-undo.
define new shared variable beg_tot    as decimal
                                      format ">>>>>>,>>>,>>9.99cr" no-undo.
define new shared variable per_tot    like beg_tot no-undo.
define new shared variable end_tot    like beg_tot no-undo.
define new shared variable transflag  like mfc_logical initial no no-undo
                                      label "Transaction Totals Only".
define new shared variable rpt_curr   like gltr_curr no-undo.
define new shared variable entity     like gltr_entity no-undo.
define new shared variable entity1    like gltr_entity no-undo.
define new shared variable ret        like ac_code no-undo.
define new shared variable asc_recno  as recid no-undo.
define new shared variable round_cnts like mfc_logical no-undo
                                      label "Round to Nearest Whole Unit".
define new shared variable prtfmt     as character format "x(30)" no-undo.
define new shared variable begdtxx    as date no-undo.
define new shared variable doc_detail like mfc_logical initial yes
                                      label "Print Document Detail" no-undo.
define new shared variable code       like dy_dy_code no-undo.
define new shared variable code1      like dy_dy_code no-undo.
define new shared variable et_beg_tot like beg_tot.
define new shared variable et_per_tot like per_tot.
define new shared variable et_end_tot like end_tot.
define new shared variable daybooks-in-use as logical initial no no-undo.
define new shared variable l_show_hidden like mfc_logical no-undo initial yes
                                       label "Show Non-Selected Transctions".

define variable knt            as integer no-undo.
define variable cname          like glname no-undo.
define variable pl             like co_pl no-undo.
define variable use_cc         like co_use_cc no-undo.
define variable use_sub        like co_use_sub no-undo.
define variable l-return-value as logical.
define variable l_begdt        like mfc_logical no-undo.
define variable l_enddt        like mfc_logical no-undo.
{&GLDABRP-P-TAG22}

{etvar.i   &new = "new"} /* common euro variables        */
{etrpvar.i &new = "new"} /* common euro report variables */
{eteuro.i              } /* some initializations         */

define buffer a1 for ac_mstr.
{&GLDABRP-P-TAG1}

/* GET NAME OF CURRENT ENTITY */
run get-current-entity (output l-return-value).
if l-return-value = false then leave.

/* GET RETAINED EARNINGS CODE FROM CONTROL FILE */
run get-retained-earnings (output l-return-value).
if l-return-value = false then leave.

{&GLDABRP-P-TAG2}
if can-find(first dyd_mstr) then
   assign daybooks-in-use = yes.

/* SELECT FORM */
{&GLDABRP-P-TAG3}
form
   entity         colon 30 entity1 colon 50 label {t001.i}
   cname          colon 30
   acc            colon 30 acc1    colon 50 label {t001.i}
   sub            colon 30 sub1    colon 50 label {t001.i}
   ctr            colon 30 ctr1    colon 50 label {t001.i}
   begdt          colon 30 enddt   colon 50 label {t001.i} skip
   /* SS - 20060327 - B */
   /*
   code           colon 30 code1   colon 50 label {t001.i}
   transflag      colon 30
   rpt_curr       colon 30
   round_cnts     colon 30
   doc_detail     colon 30
   et_report_curr colon 30
   skip(1)
   l_show_hidden  colon 35
   */
   /* SS - 20060327 - E */

with frame a side-labels attr-space width 80.
{&GLDABRP-P-TAG4}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&GLDABRP-P-TAG5}
assign
   entity = current_entity
   entity1 = current_entity
   cname = glname.

/* SS - 20060327 - B */
/*
/* DEFINE PAGE HEADER */
/* RE-ALIGNED HEADERS, DETAILS AND TOTALS TO FIT EXPANDED DOC INFO*/
/* OLD POSITION NUMBERS HAVE BEEN COMMENTED OUT FOR REFERENCE     */
{&GLDABRP-P-TAG6}
{&GLDABRP-P-TAG23}
form header
   cname at 1

   mc-curr-label at 27 et_report_curr skip
   mc-exch-label at 27 mc-exch-line1  skip
   mc-exch-line2 at 49
   skip

   getTermLabelRt("PERIOD_ACTIVITY",20) format "x(20)" to 100
   getTermLabelRt("PERIOD_ACTIVITY",20) format "x(20)" to 123
   getTermLabel("ACCOUNT",25)           format "x(25)" at 1
   getTermLabel("DESCRIPTION",20)       format "x(20)" at 27
   getTermLabelRt("DEBITS",20)          format "x(20)" to 95
   getTermLabelRt("CREDITS",20)         format "x(20)" to 119

   "-----------------------  ------------------------" at 1
   "-------------------" to 102
   "------------------" to 124
with frame phead1 page-top width 132.
{&GLDABRP-P-TAG24}
{&GLDABRP-P-TAG7}
*/
/* SS - 20060327 - E */

{wbrp01.i}

/* REPORT BLOCK */
repeat:

   assign
      l_begdt = no
      l_enddt = no.

   /* INPUT OPTIONS */
   if entity1 = hi_char then assign entity1 = "".
   if acc1 = hi_char then assign acc1 = "".
   if sub1 = hi_char then assign sub1 = "".
   if ctr1 = hi_char then assign ctr1 = "".
   if code1 = hi_char then assign code1 = "".

   display
      entity entity1 cname
      acc acc1
      sub sub1
      ctr ctr1
      begdt enddt
      /* SS - 20060327 - B */
      /*
      transflag
      rpt_curr
      round_cnts
      doc_detail
      et_report_curr
      l_show_hidden
      */
      /* SS - 20060327 - E */
   with frame a.
   {&GLDABRP-P-TAG8}

   if c-application-mode <> 'web' then
   {&GLDABRP-P-TAG9}
      set
         entity entity1 cname
         acc acc1
         sub  when (use_sub)
         sub1 when (use_sub)
         ctr  when (use_cc)
         ctr1 when (use_cc)
         begdt
         enddt
      /* SS - 20060327 - B */
      /*
         code
         code1
         transflag
         rpt_curr
        round_cnts
         doc_detail
         et_report_curr
         l_show_hidden
      */
      /* SS - 20060327 - E */
   with frame a.

                 /* SS - 20060327 - B */
                 /*
   {wbrp06.i &command = set &fields = "  entity entity1 cname
        acc acc1
        sub when ( use_sub )  sub1 when ( use_sub )
        ctr when ( use_cc )   ctr1 when ( use_cc )
        begdt enddt
        code  code1 transflag rpt_curr round_cnts  doc_detail
        et_report_curr
        l_show_hidden
        " &frm = "a"}
      */
                 {wbrp06.i &command = set &fields = "  entity entity1 cname
                      acc acc1
                      sub when ( use_sub )  sub1 when ( use_sub )
                      ctr when ( use_cc )   ctr1 when ( use_cc )
                      begdt enddt
                      " &frm = "a"}
      /* SS - 20060327 - E */
   {&GLDABRP-P-TAG10}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* VALIDATE INPUT */
      if entity1 = "" then assign entity1 = hi_char.
      if acc1 = "" then assign acc1 = hi_char.
      if sub1 = "" then assign sub1 = hi_char.
      if ctr1 = "" then assign ctr1 = hi_char.
      if code1 = "" then assign code1 = hi_char.
      if rpt_curr = "" then assign rpt_curr = base_curr.

      {&GLDABRP-P-TAG11}
      run validate-input.
      {&GLDABRP-P-TAG12}

      /* TO AVOID SCOPING PROBLEM OF INTERNAL PROCEDURE */
      /* VALIDATE-INPUT SO THAT CONTROL WOULD BE PLACED */
      /* ON THE RESPECTIVE FROM OR TO DATE FIELDS WHEN  */
      /* ERROR IS RECEIVED AND HENCE AVOID TO GENERATE  */
      /* REPORT WITH ERRONEOUS SELECTION CRITERIA       */

      if l_begdt or
         l_enddt
      then do:
         if c-application-mode = 'web' then return.
         else do:
            if l_begdt
            then
               next-prompt begdt with frame a.
            else
               next-prompt enddt with frame a.
            undo, retry.
         end. /* ELSE IF C-APPLICATION-MODE */
      end. /* IF L_BEGDT OR L_ENDDT */

      /* CREATE BATCH INPUT STRING */

      run create-batch-input-string.

   end.  /* if (c-application-mode <> 'web') ... */

   /* SS - 20060327 - B */
   /*
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
      end.
   end.  /* if et_report_curr <> "" */
   if et_report_curr = "" or et_report_curr = rpt_curr then
      assign
         mc-exch-line1 = ""
         mc-exch-line2 = ""
         et_report_curr = rpt_curr.
   */
   /* SS - 20060327 - E */
   
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
               /* SS - 20060327 - B */
      /*
   {mfphead.i}

   view frame phead1.

   if can-find (first glt_det
      where glt_entity >= entity and
            glt_entity <= entity1 and
            glt_acc >= acc and glt_acc <= acc1 and
            glt_sub >= sub and glt_sub <= sub1 and
            glt_cc >= ctr and glt_cc <= ctr1 and
            glt_effdate >= begdt and
            glt_effdate <= enddt)
   then do:
      /* UNPOSTED TRANSACTIONS EXIST FOR RANGES ON THIS REPORT */
      {pxmsg.i &MSGNUM=3151 &ERRORLEVEL=2}
   end.

   /* SET PRINT FORMAT */
   prtfmt = ">>>>>>,>>>,>>9.99cr".
   if round_cnts then prtfmt = ">>>>>,>>>,>>>,>>9cr".

   {&GLDABRP-P-TAG25}
   /* CYCLE THROUGH ACCOUNT FILE */
   assign
      beg_tot    = 0
      end_tot    = 0
      per_tot    = 0
      et_beg_tot = 0
      et_end_tot = 0
      et_per_tot = 0
      begdtxx    = begdt - 1.

   loopa:
   for each asc_mstr
      fields (asc_acc asc_sub asc_cc)
      where asc_acc >= acc  and
            asc_acc <= acc1 and
            asc_sub >= sub  and
            asc_sub <= sub1 and
            asc_cc >= ctr   and
            asc_cc <= ctr1  and
            asc_acc <> pl
      no-lock
         break by asc_acc by asc_sub by asc_cc
      with frame b width 132:

      if first-of(asc_acc) then first_acct = yes.
      else first_acct = no.
      if first-of(asc_sub) then first_sub = yes.
      else first_sub = no.
      if first-of(asc_cc) then first_cc = yes.
      else first_cc = no.
      /*!
      if daybooks are being used and the user entered some criteria
      in the daybook code range then we want to check if there are
      any transactions within the given daybook range for this account
      if there are not then go to the next account
      */
      if daybooks-in-use and
         not l_show_hidden and
         (code <> "" or code1 <> hi_char) then
         if not can-find(first gltr_hist where
            gltr_acc      = asc_acc and
            gltr_sub      = asc_sub and
            gltr_ctr      = asc_cc  and
            gltr_entity  >= entity  and
            gltr_entity  <= entity1 and
            gltr_dy_code >= code    and
            gltr_dy_code <= code1   and
            gltr_eff_dt  >= begdt   and
            gltr_eff_dt  <= enddt)
         then next loopa.

      for first ac_mstr fields (ac_curr ac_code)
      no-lock where ac_code = asc_acc:
      end.
      if rpt_curr = base_curr or ac_curr = rpt_curr then do:
         asc_recno = recid(asc_mstr).
         {gprun.i ""gldabrpa.p""}
      end.

      {mfrpchk.i}
   end.

   /* PRINT TOTALS */

   {&GLDABRP-P-TAG26}
   put {gplblfmt.i
          &FUNC=getTermLabel(""CURRENCY"",15)
          &CONCAT = "':'"
        } et_report_curr to 60 skip

      {gplblfmt.i
         &FUNC=getTermLabel(""TOTAL_BEGINNING_BALANCE"",35)
         &CONCAT = "':'"
      } string(et_beg_tot, prtfmt) format "x(20)" to 63 skip

      {gplblfmt.i
         &FUNC=getTermLabel(""TOTAL_ACTIVITY_TO_DATE"",35)
         &CONCAT = "':'"
      } string(et_per_tot, prtfmt) format "x(20)" to 63 skip

      {gplblfmt.i
         &FUNC=getTermLabel(""TOTAL_ENDING_BALANCE"",35)
         &CONCAT = "':'"
      } string(et_end_tot, prtfmt) format "x(20)" to 63 skip.

   {&GLDABRP-P-TAG27}
   {&GLDABRP-P-TAG20}

   if et_report_curr <> rpt_curr then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input beg_tot,
           input true,   /* ROUND */
           output beg_tot,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input per_tot,
           input true,   /* ROUND */
           output per_tot,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input end_tot,
           input true,   /* ROUND */
           output end_tot,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.  /* if et_report_curr <> rpt_curr */

   {&GLDABRP-P-TAG21}

   if (beg_tot <> et_beg_tot or
       per_tot <> et_per_tot or
       end_tot <> et_end_tot) and
      et_show_diff           and
      not round_cnts
   then do:
      put
         et_diff_txt to 61
         string(et_beg_tot - beg_tot, prtfmt) format "x(20)" to 63
         skip
         string(et_per_tot - per_tot, prtfmt) format "x(20)" to 63
         skip
         string(et_end_tot - end_tot, prtfmt) format "x(20)" to 63
         skip.
   end.

   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH tta6gldabrp01:
      DELETE tta6gldabrp01.
   END.

   {gprun.i ""a6gldabrp01.p"" "(
      INPUT entity,
      INPUT entity1,
      INPUT acc,
      INPUT acc1,
      INPUT sub,
      INPUT sub1,
      INPUT ctr,
      INPUT ctr1,
      INPUT begdt,
      INPUT enddt
      )"}

   EXPORT DELIMITER ";" "ref" "eff_dt" "ent_dt" "user" "batch" "line" "acc" "sub" "ctr" "project" "entity" "desc" "amt" "curramt" "curr" "addr" "doc_typ" "doc".
   FOR EACH tta6gldabrp01:
       EXPORT DELIMITER ";" tta6gldabrp01.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {a6mfrtrail.i}
   /* SS - 20060327 - E */

end.

{wbrp04.i &frame-spec = a}

PROCEDURE create-batch-input-string:

   assign bcdparm = "".
   {mfquoter.i entity   }
   {mfquoter.i entity1  }
   {mfquoter.i cname    }
   {mfquoter.i acc      }
   {mfquoter.i acc1     }
   if use_sub then do:
      {mfquoter.i sub   }
      {mfquoter.i sub1  }
   end.
   if use_cc then do:
      {mfquoter.i ctr   }
      {mfquoter.i ctr1  }
   end.
   {mfquoter.i begdt    }
   {mfquoter.i enddt    }
   {mfquoter.i code     }
   {mfquoter.i code1    }
   {mfquoter.i transflag}
   {mfquoter.i rpt_curr }
   {mfquoter.i round_cnts}
   {&GLDABRP-P-TAG13}
   {mfquoter.i doc_detail}
   {mfquoter.i et_report_curr}
   {mfquoter.i l_show_hidden}
   {&GLDABRP-P-TAG14}

END PROCEDURE.

PROCEDURE get-current-entity:
   define output parameter l-return-value as logical.

   l-return-value = true.
   for first en_mstr fields (en_name en_entity)
   no-lock where en_entity = current_entity:
   end.
   if not available en_mstr then do:
      {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
      if not batchrun then
         if c-application-mode <> 'web' then
            pause.
      l-return-value = false.
      return.
   end.
   else do:
      glname = en_name.
      release en_mstr.
   end.
END PROCEDURE. /* get-current-entity */

PROCEDURE get-retained-earnings:
   define output parameter l-return-value as logical.

   l-return-value = true.
   for first co_ctrl
      fields (co_pl co_ret co_use_cc co_use_sub)
   no-lock:
   end.
   if not available co_ctrl then do:
      /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT */
      {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
      if not batchrun then
         if c-application-mode <> 'web' then
            pause.
      l-return-value = false.
      return.
   end.
   assign
      pl       = co_pl
      ret      = co_ret
      use_cc   = co_use_cc
      use_sub  = co_use_sub
      rpt_curr = base_curr.

   release co_ctrl.
END PROCEDURE. /* get-retained-earinings */

PROCEDURE validate-input:
   define variable begdt0         as date no-undo.
   define variable enddt0         as date no-undo.
   define variable peryr          as character format "x(8)" no-undo.

   if enddt = ? then enddt = today.
   display enddt with frame a.
   {glper1.i enddt peryr}
   if peryr = "" then do:
      {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
      {&GLDABRP-P-TAG15}
      l_enddt = yes.
      return.

   end.
   assign
      yr = glc_year
      per1 = glc_per.

   for first glc_cal
      fields (glc_end glc_per glc_start glc_year)
      where glc_year = yr and glc_per = 1
   no-lock:
   end.
   if not available glc_cal then do:
      /* NO FIRST PERIOD DEFINED FOR THIS FISCAL YEAR. */
      {pxmsg.i &MSGNUM=3033 &ERRORLEVEL=3}
      {&GLDABRP-P-TAG16}
      l_enddt = yes.
      return.

   end.
   if begdt = ? then begdt = glc_start.
   display begdt with frame a.
   yr_beg = glc_start.
   if begdt < glc_start then do:
      {pxmsg.i &MSGNUM=3031 &ERRORLEVEL=3} /* REPORT CANNOT SPAN FISCAL YEAR */
      {&GLDABRP-P-TAG17}
      l_enddt = yes.
      return.

   end.
   if begdt > enddt then do:
      {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3} /* INVALID DATE */
      {&GLDABRP-P-TAG18}
      l_begdt = yes.
      return.

   end.
   {glper1.i begdt peryr}
   if peryr = "" then do:
      {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
      {&GLDABRP-P-TAG19}
      l_begdt = yes.
      return.

   end.
   per = glc_per.
   find last glc_cal where glc_year = yr no-lock.
   assign
      yr_end = glc_end
      begdt0 = begdt
      enddt0 = enddt.
end.
