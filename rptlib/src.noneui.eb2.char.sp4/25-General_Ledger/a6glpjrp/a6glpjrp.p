/* glpjrp.p - GENERAL LEDGER PROJECT SUMMARY REPORT                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/          /*                                                         */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 1.0      LAST MODIFIED: 04/21/87   BY: JMS                      */
/* REVISION: 4.0      LAST MODIFIED: 02/24/88   By: JMS                      */
/*                                   02/29/88   BY: WUG *A175*               */
/*                                   03/10/88   BY: JMS                      */
/* REVISION: 5.0      LAST MODIFIED: 05/15/89   by: jms *B066*               */
/* REVISION: 6.0      LAST MODIFIED: 09/20/90   by: jms *D034*               */
/*                                   11/07/90   by: jms *D189*               */
/*                                   02/07/91   by: jms *D330*               */
/*                                   02/20/91   by: jms *D366*               */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   by: jms *F058*               */
/*                                            (major re-write)               */
/*                                   06/24/92   by: jms *F702*               */
/*                                   06/29/92   by: jms *F712*               */
/* REVISION: 7.3      LAST MODIFIED: 03/30/93   by: jms *G884* (rev only)    */
/*                                   04/27/93   by: skk *GA51*               */
/*                                   09/03/94   by: srk *FQ80*               */
/*                                   09/22/94   by: str *FR73*               */
/*                                   02/13/95   by: srk *G0DS*               */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   by: ckm *K15S*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00M* AWe *             */
/* REVISION: 8.6E     LAST MODIFIED: 06/16/98   BY: *L01W* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 09/10/98   BY: *L092* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 09/21/98   BY: *L08W* Russ Witt         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown          */
/* REVISION: 9.1      LAST MODIFIED: 09/22/05 BY: *SS - 20050922* Bill Jiang          */

/* SS - 20050922 - B */                                                                            
{a6glpjrp.i}

DEFINE INPUT PARAMETER i_entity LIKE en_entity.
DEFINE INPUT PARAMETER i_entity1 LIKE en_entity.
DEFINE INPUT PARAMETER i_acc LIKE ac_code.
DEFINE INPUT PARAMETER i_acc1 LIKE ac_code.
DEFINE INPUT PARAMETER i_sub LIKE sb_sub.
DEFINE INPUT PARAMETER i_sub1 LIKE sb_sub.
DEFINE INPUT PARAMETER i_ctr LIKE cc_ctr.
DEFINE INPUT PARAMETER i_ctr1 LIKE cc_ctr.
DEFINE INPUT PARAMETER i_begdt LIKE gltr_eff_dt.
DEFINE INPUT PARAMETER i_enddt LIKE gltr_eff_dt.
/*
         {mfdtitle.i "b+ "}
             */
             {a6mfdtitle.i "b+ "}
             /* SS - 20050922 - E */

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE glpjrp_p_1 "Print comments"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE glpjrp_p_2 "Put Projects on Separate Pages"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE glpjrp_p_3 "Summarize Sub-Accounts"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE glpjrp_p_4 "Suppress Zero Amounts"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE glpjrp_p_5 "Summarize Cost Centers"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE glpjrp_p_6 "Round to Nearest Whole Unit"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         define new shared variable glname   like en_name.
         define new shared variable begdt    like gltr_eff_dt.
         define new shared variable enddt    like gltr_eff_dt.
         define new shared variable acc      like ac_code.
         define new shared variable acc1     like ac_code.
         define new shared variable sub      like sb_sub.
         define new shared variable sub1     like sb_sub.
         define new shared variable ctr      like cc_ctr.
         define new shared variable ctr1     like cc_ctr.
         define new shared variable proj_tot  as decimal.
         define new shared variable grand_tot as decimal.
         define new shared variable entity   like en_entity.
         define new shared variable entity1  like en_entity.
         define new shared variable cname    like glname.
         define new shared variable prtcents like mfc_logical
            label {&glpjrp_p_6}.
         define new shared variable prtfmt as character format "x(30)".
         define new shared variable page_break like mfc_logical initial true
            label {&glpjrp_p_2}.
         define new shared variable show_cmmts like mfc_logical initial true
            label {&glpjrp_p_1}.
         define new shared variable subflag like mfc_logical
            label {&glpjrp_p_3}.
         define new shared variable ccflag like mfc_logical
            label {&glpjrp_p_5}.
         define new shared variable zeroflag like mfc_logical
            label {&glpjrp_p_4}.
         define new shared variable pj_recno as recid.

         define new shared variable proj like gltr_project.
         define new shared variable proj1 like gltr_project.
         define new shared variable unposted_flag like mfc_logical.
         define new shared variable projfound like mfc_logical.

         define variable peryr as character.
         define variable yr as integer.
/*L092*  define variable i as integer.  *L092*/
         define variable use_sub like co_use_sub.
         define variable use_cc like co_use_cc.

/*L00M*  ADD SECTION */
         {etvar.i   &new = "new"} /* common euro variables        */
         {etrpvar.i &new = "new"} /* common euro report variables */
         {eteuro.i}               /* some initializations         */
         define new shared variable et_proj_tot like proj_tot.
         define new shared variable et_grand_tot like grand_tot.
/*L01W*  define new shared variable et_show_curr as character format "x(30)".*/
/*L00M*  END ADD SECTION */

/*L092*/ {gprunpdf.i "mcpl" "p"}
/*L092*/ {gprunpdf.i "mcui" "p"}

         /* SS - 20050922 - B */
         /*
         /* SELECT FORM */
         form
            entity     colon 33
            entity1    colon 50 label {t001.i}
            cname      colon 33 skip(1)
            proj       colon 33
            proj1      colon 50 label {t001.i}
            acc        colon 33
            acc1       colon 50 label {t001.i}
            sub        colon 33
            sub1       colon 50 label {t001.i}
            ctr        colon 33
            ctr1       colon 50 label {t001.i}
            begdt      colon 33
            enddt      colon 50 label {t001.i} skip
            subflag    colon 33
            ccflag     colon 33
            prtcents   colon 33
            zeroflag   colon 33
            page_break colon 33
            show_cmmts colon 33
/*L01W*/    et_report_curr colon 33
/*L00M*     ADD SECTION */
/*L01W*     et_report_txt  to 33 no-label no-attr-space */
/*L01W*     et_report_curr       no-label */
/*L01W*     et_rate_txt    to 33 no-label no-attr-space */
/*L01W*     et_report_rate       no-label */
/*L00M*     END ADD SECTION */
         with frame a side-labels attr-space width 80.

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
         /* SS - 20050922 - E */

         /* READ GENERAL LEDGER CONTROL FILE */
         find first co_ctrl no-lock no-error.
         if not available co_ctrl then do:
            {mfmsg.i 3032 3} /*CONTROL FILE MUST BE DEFINED BEFORE
                               RUNNING REPORT*/
            if not batchrun and c-application-mode <> 'web' then pause.
            leave.
         end.
/*L092*/ assign
            use_cc  = co_use_cc
            use_sub = co_use_sub.

         /* SS - 20050922 - B */
         /*
         /* GET NAME OF CURRENT ENTITY */
         find en_mstr where en_entity = current_entity no-lock no-error.
         if not available en_mstr then do:
            {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
            if not batchrun and c-application-mode <> 'web' then pause.
            leave.
         end.
         else do:
            glname = en_name.
            release en_mstr.
         end.
/*L092*/ assign
            entity  = current_entity
            entity1 = current_entity
            cname   = glname.

         /* REPORT BLOCK */
         */
         /* SS - 20050922 - E */

         {wbrp01.i}

             /* SS - 20050922 - B */
             /*
         repeat:
            unposted_flag = no.
         */
         /* SS - 20050922 - E */

            /* INPUT OPTIONS */
            if entity1 = hi_char then entity1 = "".
            if proj1   = hi_char then proj1   = "".
            if acc1    = hi_char then acc1    = "".
            if sub1    = hi_char then sub1    = "".
            if ctr1    = hi_char then ctr1    = "".

/*L01W* /*L00M*/ display et_report_txt et_rate_txt with frame a. */

            /* SS - 20050922 - B */
            /*
            if c-application-mode <> 'web' then
               update entity
                      entity1
                      cname
                      proj
                      proj1
                      acc
                      acc1
                      sub when (use_sub)
                      sub1 when (use_sub)
                      ctr when (use_cc)
                      ctr1 when (use_cc)
                      begdt
                      enddt
                      subflag when (use_sub)
                      ccflag when (use_cc)
                      prtcents
                      zeroflag
                      page_break
                      show_cmmts
/*L00M*/              et_report_curr
/*L01W* /*L00M*/      et_report_rate */
               with frame a.

            {wbrp06.i &command = update &fields = " entity entity1 cname proj
               proj1 acc acc1 sub when (use_sub) sub1 when (use_sub) ctr
               when (use_cc)
               ctr1 when (use_cc) begdt enddt subflag when (use_sub)
               ccflag when (use_cc) prtcents zeroflag page_break show_cmmts
/*L00M*/       et_report_curr
/*L01W* /*L00M*/ et_report_rate */
               "  &frm = "a"}
                */
                /* SS - 20050922 - E */

            if (c-application-mode <> 'web') or
               (c-application-mode = 'web' and
               (c-web-request begins 'data')) then do:

               if entity1 = "" then entity1 = hi_char.
               if proj1   = "" then proj1   = hi_char.
               if acc1    = "" then acc1    = hi_char.
               if sub1    = "" then sub1    = hi_char.
               if ctr1    = "" then ctr1    = hi_char.
               if enddt   = ?  then enddt   = today.

               /* SS - 20050922 - B */
               /*
               /* VALIDATE DATES */
               {glper1.i enddt peryr} /* GET PERIOD/YEAR */
               if peryr = "" then do:
                  {mfmsg.i 3018 3} /* DATE NOT WITHIN A VALID PERIOD */
                  if c-application-mode = 'web' then return.
                  else next-prompt enddt with frame a.
                  undo, retry.
               end.
               yr = glc_year.
               if begdt = ? then do:
                  find glc_cal where glc_year = yr and glc_per = 1 no-lock
                  no-error.
/*L092*           if available glc_cal then begdt = glc_start.  *L092*/
/*L092*           else begdt = low_date.                        *L092*/
/*L092*/          begdt = if available glc_cal then glc_start else low_date.
               end.

               if begdt > enddt then do:
                  {mfmsg.i 27 3} /* INVALID DATE */
                  if c-application-mode = 'web' then return.
/*L092*           else  *L092*/
                  next-prompt begdt with frame a.
                  undo, retry.
               end.
               */
               /* SS - 20050922 - E */

               /* CREATE BATCH INPUT STRING */
               bcdparm = "".
               {mfquoter.i entity    }
               {mfquoter.i entity1   }
               {mfquoter.i cname     }
               {mfquoter.i proj      }
               {mfquoter.i proj1     }
               {mfquoter.i acc       }
               {mfquoter.i acc1      }
               if use_sub then do:
                  {mfquoter.i sub    }
                  {mfquoter.i sub1   }
               end.
               if use_cc then do:
                  {mfquoter.i ctr    }
                  {mfquoter.i ctr1   }
               end.
               {mfquoter.i begdt     }
               {mfquoter.i enddt     }
               if use_sub then do:
                  {mfquoter.i subflag}
               end.
               if use_cc then do:
                  {mfquoter.i ccflag }
               end.
               {mfquoter.i prtcents  }
               {mfquoter.i zeroflag  }
               {mfquoter.i page_break}
               {mfquoter.i show_cmmts}
/*L01W* /*L00M*/  if et_tk_active then do: */
/*L00M*/       {mfquoter.i et_report_curr}
/*L01W* /*L00M*/  {mfquoter.i et_report_rate} */
/*L01W* /*L00M*/  end. */

                   /* SS - 20050922 - B */
                   /*
               display begdt enddt with frame a.
               */
               /* SS - 20050922 - E */

/*L092* /*L01W*/  if et_report_curr <> "" then do:
 *L092* /*L01W*/     {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
 *L092*                "(input et_report_curr,
 *L092*                  output mc-error-number)"}
 *L092* /*L01W*/     if mc-error-number = 0
 *L092* /*L01W*/     and et_report_curr <> base_curr then do:
 *L092* /*L01W*/        {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
 *L092*                   "(input base_curr,
 *L092*                     input et_report_curr,
 *L092*                     input "" "",
 *L092*                     input et_eff_date,
 *L092*                     output et_rate1,
 *L092*                     output et_rate2,
 *L092*                     output mc-seq,
 *L092*                     output mc-error-number)"}
 *L092* /*L01W*/     end.  /* if mc-error-number = 0 */
 *L092* /*L01W*/     if mc-error-number <> 0 then do:
 *L092* /*L01W*/        {mfmsg.i mc-error-number 3}
 *L092* /*L01W*/        if c-application-mode = 'web' then return.
 *L092* /*L01W*/        else next-prompt et_report_curr with frame a.
 *L092* /*L01W*/        undo, retry.
 *L092* /*L01W*/     end.  /* if mc-error-number <> 0 */
 *L092* /*L01W*/     else if et_report_curr <> base_curr then do:
 *L092* /*L01W*/        {gprunp.i "mcui" "p" "mc-ex-rate-output"
 *L092*                   "(input base_curr,
 *L092*                     input et_report_curr,
 *L092*                     input et_rate1,
 *L092*                     input et_rate2,
 *L092*                     input mc-seq,
 *L092*                     output mc-exch-line1,
 *L092*                     output mc-exch-line2)"}
 *L092* /*L01W*/        {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
 *L092*                   "(input mc-seq)"}
 *L092* /*L01W*/     end.  /* else do */
 *L092* /*L01W*/  end.  /* if et_report_curr <> "" */
 *L092* /*L01W*/  if et_report_curr = "" or et_report_curr = base_curr then
 *L092* /*L01W*/     assign
 *L092* /*L01W*/        mc-exch-line1 = ""
 *L092* /*L01W*/        mc-exch-line2 = ""
 *L092* /*L01W*/        et_report_curr = base_curr.
 *L092*/

                   /* SS - 20050922 - B */
                   /*
/*L092*/       run ip-ex-rate-output
/*L092*/          (input  et_report_curr,
/*L092*/           input  base_curr,
/*L092*/           input  et_eff_date,
/*L092*/           output et_rate1,
/*L092*/           output et_rate2,
/*L092*/           output mc-exch-line1,
/*L092*/           output mc-exch-line2,
/*L092*/           output mc-error-number).

/*L092*/       if mc-error-number <> 0 then do:
/*L092*/          {mfmsg.i mc-error-number 3}
/*L092*/          if c-application-mode = 'web' then return.
/*L092*/          next-prompt et_report_curr with frame a.
/*L092*/          undo, retry.
/*L092*/       end.  /* if mc-error-number <> 0 */

/*L092*/       if et_report_curr = "" then et_report_curr = base_curr.
*/
/* SS - 20050922 - E */

            end.  /* if (c-application-mode <> 'web') ... */

/*L00M*     ADD SECTION*/
/*L01W*     {etcurval.i &curr     = "et_report_curr" */
/*L01W*                 &errlevel = "4" */
/*L01W*                 &action   = "next" */
/*L01W*                 &prompt   = "pause"} */
/*L01W*     {gprun.i ""etrate.p"" "("""")"} */
/*L01W*     if et_tk_active then do: */
/*L01W*        et_show_curr = et_report_txt + " " + et_disp_curr. */
/*L01W*     end. */
/*L01W*     else et_show_curr = "". */
/*L00M*     END ADD SECTION*/

               /* SS - 20050922 - B */
               /*
            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}

            {gprun.i ""glpjrp1a.p""}

            /* REPORT TRAILER */
            {mfrtrail.i}

         end.  /* repeat */

         {wbrp04.i &frame-spec = a}
             */
               {a6glpjrp1a.i}
             /* SS - 20050922 - E */

/*L092*/ PROCEDURE ip-ex-rate-output:

/*L092*/    define input  parameter i_report_curr as character no-undo.
/*L092*/    define input  parameter i_base_curr   as character no-undo.
/*L092*/    define input  parameter i_eff_date    as date      no-undo.

/*L092*/    define output parameter o_rate1       as decimal   no-undo initial 1.
/*L092*/    define output parameter o_rate2       as decimal   no-undo initial 1.
/*L092*/    define output parameter o_disp_line1  as character no-undo initial "".
/*L092*/    define output parameter o_disp_line2  as character no-undo initial "".
/*L092*/    define output parameter o_error       as integer   no-undo initial 0.

/*L092*/    define variable v_seq like exru_seq no-undo.

/*L092*/    if i_report_curr <> "" then do:

/*L092*/       {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                  "(input  i_report_curr,
                    output o_error)"}

/*L092*/       if i_report_curr <> i_base_curr then do:
/*L092*/          if o_error = 0 then do:

/*L08W*              CURRENCIES AND RATES REVERSED BELOW...             */
/*L092*/             {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                       "(input  i_report_curr,
                         input  i_base_curr,
                         input  "" "",
                         input  i_eff_date,
                         output o_rate2,
                         output o_rate1,
                         output v_seq,
                         output o_error)"}

/*L092*/          end.  /* if o_error = 0 */
/*L092*/          if o_error = 0 then do:

/*L08W*              CURRENCIES AND RATES REVERSED BELOW...             */
/*L092*/             {gprunp.i "mcui" "p" "mc-ex-rate-output"
                        "(input  i_report_curr,
                          input  i_base_curr,
                          input  o_rate2,
                          input  o_rate1,
                          input  v_seq,
                          output o_disp_line1,
                          output o_disp_line2)"}

/*L092*/             {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                        "(input v_seq)"}

/*L092*/          end.  /* if o_error = 0 */
/*L092*/       end.  /* if i_report_curr <> i_base_curr */
/*L092*/    end.  /* if i_report_curr <> "" */

/*L092*/ END PROCEDURE.  /* ip-ex-rate-output */
