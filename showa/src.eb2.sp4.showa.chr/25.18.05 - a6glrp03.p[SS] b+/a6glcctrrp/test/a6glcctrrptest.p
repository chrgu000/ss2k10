/* glcctrrp.p - GENERAL LEDGER COMPARATIVE COST CENTER REPORT           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 02/17/88   BY: JMS                 */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG *A175*          */
/*                                   03/11/88   BY: JMS                 */
/*                                   10/11/88   by: jms *A476*          */
/* REVISION: 5.0      LAST MODIFIED: 05/15/89   by: jms *B066*          */
/*                                   06/15/89   by: jms *B147*          */
/* REVISION: 6.0      LAST MODIFIED: 10/15/90   by: jms *D034*          */
/*                                   01/25/91   by: jms *D253*          */
/*                                   02/07/91   by: jms *D330*          */
/*                                   02/27/91   by: jms *D366*          */
/*                                   04/03/91   by: jms *D487*          */
/*                                   09/05/91   by: jms *D849*          */
/* REVISION: 7.0      LAST MODIFIED: 12/03/91   by: jms *F058*          */
/*                                           (program split)            */
/*                                   02/25/92   by: jms *F231*          */
/*                                   06/19/92   BY: JJS *F661*(rev only)*/
/*                                   06/24/92   by: jms *F702*          */
/* REVISION: 7.3      LAST MODIFIED: 10/19/92   by: mpp *G206*(rev only)*/
/*                                   07/23/93   by: skk *GD62*          */
/*                                   09/03/94   by: srk *FQ80*          */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ays *K0TW*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J241* Jagdish Suvarna  */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   by: LN/SVA   *L00M*         */
/* REVISION: 8.6E     LAST MODIFIED: 06/12/98   by: Mohan CK   *K1S9*       */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L01W* Brenda Milton    */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00   BY: *N0QH* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TH* Jyoti Thatte     */
/* REVISION: 9.1      LAST MODIFIED: 09/19/05   BY: *SS - 20050919* Bill Jiang     */

/*J241* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

/* SS - 20050919 - B */
{a6glcctrrp.i "new"}
/* SS - 20050919 - E */

          /* DISPLAY TITLE */
          {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glcctrrp_p_1 "Suppress Zero Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcctrrp_p_2 "Use Budgets"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcctrrp_p_4 "Round to Nearest Whole Unit"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcctrrp_p_6 "Budget Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcctrrp_p_7 "Column 2 - Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcctrrp_p_9 "Column 1 - Date"
/* MaxLen: Comment: */

/*N0QH***********BEGIN COMMENTING*************
 * &SCOPED-DEFINE glcctrrp_p_3 "Variance"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glcctrrp_p_5 " Budget"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glcctrrp_p_8 "CC         Account        Description"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glcctrrp_p_10 "Activity"
 * /* MaxLen: Comment: */
 *N0QH***********END COMMENTING************* */

/* ********** End Translatable Strings Definitions ********* */

          define new shared variable glname like en_name no-undo.
          define new shared variable begdt as date extent 2 no-undo.
          define new shared variable enddt as date extent 2 no-undo.
          define new shared variable acc like ac_code no-undo.
          define new shared variable acc1 like ac_code no-undo.
          define new shared variable sub like sb_sub no-undo.
          define new shared variable sub1 like sb_sub no-undo.
          define new shared variable ctr like cc_ctr no-undo.
          define new shared variable ctr1 like cc_ctr no-undo.
          define new shared variable yr_beg as date no-undo.
          define new shared variable yr as integer no-undo.
          define new shared variable budget like mfc_logical extent 2 no-undo.
          define new shared variable peryr as character format "x(8)" no-undo.
          define new shared variable fiscal_yr as integer extent 2 no-undo.
          define new shared variable fiscal_yr1 as integer extent 2 no-undo.
          define new shared variable per_end like glc_per extent 2 no-undo.
          define new shared variable per_beg like glc_per extent 2 no-undo.
          define new shared variable entity like en_entity no-undo.
          define new shared variable entity1 like en_entity no-undo.
          define new shared variable cname like glname no-undo.
          define new shared variable hdrstring as character
             format "x(8)" no-undo.
          define new shared variable hdrstring1 like hdrstring no-undo.
          define new shared variable yr_end as date extent 2 no-undo.
          define new shared variable ret like ac_code no-undo.
          define new shared variable proj like gltr_project no-undo.
          define new shared variable proj1 like gltr_project no-undo.
          define new shared variable budgetcode like bg_code extent 2 no-undo.
          define new shared variable rpt_curr like ac_curr no-undo.
          define new shared variable prtcents like mfc_logical
             label {&glcctrrp_p_4} no-undo.
          define new shared variable prtfmt as character format "x(30)" no-undo.
          define new shared variable prtfmt1 as character
             format "x(30)" no-undo.
          define new shared variable zeroflag like mfc_logical
            label {&glcctrrp_p_1} no-undo.

          define variable use_sub like co_use_sub no-undo.
          define variable i as integer no-undo.

/*L00M * BEGIN ADD*/
          /* DEFINE EURO VARIABLES */
          {etrpvar.i &new = "new"}
          {etvar.i   &new = "new"}
/*L01W*   define new shared variable et_show_curr as character */
/*L01W*                                 format "x(30)"no-undo. */
          /* GET EURO INFORMATION  */
          {eteuro.i}
/*L00M * END ADD*/

          /* SELECT FORM */
          form
              entity        colon 30 entity1   colon 50 label {t001.i}
              cname         colon 30 skip(1)
              ctr           colon 30 ctr1      colon 50 label {t001.i}
              acc           colon 30 acc1      colon 50 label {t001.i}
              sub           colon 30 sub1      colon 50 label {t001.i}   skip(1)
              begdt[1]      colon 30 label {&glcctrrp_p_9}
              enddt[1]      colon 50 label {t001.i}
              budget[1]     colon 30 label {&glcctrrp_p_2}
              budgetcode[1] colon 50 label {&glcctrrp_p_6} skip(1)
              begdt[2]      colon 30 label {&glcctrrp_p_7}
              enddt[2]      colon 50 label {t001.i}
              budget[2]     colon 30 label {&glcctrrp_p_2}
              budgetcode[2] colon 50 label {&glcctrrp_p_6} skip(1)
              zeroflag      colon 30
              prtcents      colon 30
/*L01W*/      et_report_curr colon 30
/*L01W* /*L00M*/ et_report_txt  to 30    no-label space(0) */
/*L01W* /*L00M*/ et_report_curr          no-label          */
/*L01W* /*L00M*/ et_rate_txt    to 30    no-label space(0) */
/*L01W* /*L00M*/ et_report_rate          no-label          */
           with frame a side-labels attr-space width 80.

           /* SET EXTERNAL LABELS */
           setFrameLabels(frame a:handle).

          /* GET NAME OF CURRENT ENTITY */
/*J241**  find en_mstr where en_entity = current_entity no-lock no-error. **/
/*J241*/  for first en_mstr fields (en_name en_entity)
/*J241*/      no-lock where en_entity = current_entity: end.
          if not available en_mstr then do:
             {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
             if c-application-mode <> 'web' then
                pause.
             leave.
          end.
          else do:
             assign glname = en_name.
             release en_mstr.
          end.
          assign
             entity = current_entity
             entity1 = current_entity
             cname = glname
             rpt_curr = base_curr
             proj = ""
             proj1 = hi_char.
          /* GET RETAINED EARNINGS CODE FROM CONTROL FILE */
/*J241**  find first co_ctrl no-lock no-error. **/
/*J241*/  for first co_ctrl fields (co_ret co_use_sub) no-lock: end.
          if not available co_ctrl then do:
             {mfmsg.i 3032 3} /* CONTROL FILE MUST BE DEFINED BEFORE
                                 RUNNING REPORT */
             if c-application-mode <> 'web' then
                pause.
             leave.
          end.
          ret = co_ret.
          use_sub = co_use_sub.

          /* DEFINE HEADERS */
          /* SS - 20050919 - B */
          /*
          form header
             cname at 1
/*L01W* /*L00M*/ space(2) et_show_curr */
/*L01W*/     mc-curr-label at 27 et_report_curr skip
/*L01W*/     mc-exch-label at 27 mc-exch-line1 skip
/*L01W*/     mc-exch-line2 at 49 skip(1)
             skip
             hdrstring at 68
             hdrstring1 at 89
/*N0QH*      {&glcctrrp_p_8} at 1 */
/*N0QH*/     getTermLabel("COST_CENTER",10) at 1 format "x(10)"
/*N0TH** /*N0QH*/     getTermLabel("ACCOUNT",14)          format "x(14)" */
/*N0TH*/     getTermLabel("ACCOUNT",14)          format "x(17)"
/*N0QH*/     getTermLabel("DESCRIPTION",20)      format "x(20)"
             begdt[1] at 62 "-" enddt[1]
             begdt[2] at 83 "-" enddt[2]
/*N0QH*      {&glcctrrp_p_3} at 115  "%" at 130 */
/*N0QH*/     getTermLabel("VARIANCE",14) format "x(14)" at 115  "%" at 130
/*N0TH**     "----       -------------- ------------------------" at 1 */
/*N0TH*/     fill("-",8) format "x(8)" at 1
/*N0TH*/     fill("-",17) format "x(17)" at 12
/*N0TH*/     fill("-",24) format "x(24)" at 30
             "--------------------" to 80 "--------------------" to 101
             "--------------------" to 122 "--------" to 131
          with frame phead1 page-top width 132 no-box.
          */
          /* SS - 20050919 - E */

          {wbrp01.i}

          /* REPORT BLOCK */
          mainloop:
          repeat:

            /* INPUT OPTIONS */
            if entity1 = hi_char then assign entity1 = "".
            if acc1 = hi_char then assign acc1 = "".
            if sub1 = hi_char then assign sub1 = "".
            if ctr1 = hi_char then assign ctr1 = "".

/*L01W* /*L00M*/ display et_report_txt */
/*L01W* /*L00M*/         et_rate_txt   with frame a. */

            if c-application-mode <> 'web' then
               update entity entity1 cname ctr ctr1 acc acc1
                      sub when (use_sub)
                      sub1 when (use_sub)
                      begdt[1] enddt[1] budget[1] budgetcode[1]
                      begdt[2] enddt[2] budget[2] budgetcode[2]
                      zeroflag prtcents
/*L00M*/              et_report_curr
/*L01W* /*L00M*/      et_report_rate */
                   with frame a.

            {wbrp06.i &command = update &fields = "  entity entity1 cname
             ctr ctr1 acc acc1 sub when (use_sub)  sub1 when (use_sub)
             begdt [ 1 ] enddt [ 1 ] budget [ 1 ] budgetcode [ 1 ]
             begdt [ 2 ] enddt [ 2 ] budget [ 2 ] budgetcode [ 2 ]
             zeroflag prtcents
/*L00M*/     et_report_curr
/*L01W* /*L00M*/ et_report_rate */
             " &frm = "a"}

            if (c-application-mode <> 'web') or
            (c-application-mode = 'web' and
            (c-web-request begins 'data')) then do:

/*K1S9*/       run quote-vars.
/*K1S9*        moved to an internal procedure
 *             /* CREATE BATCH INPUT STRING */
 *             assign bcdparm = "".
 *             {mfquoter.i entity       }
 *             {mfquoter.i entity1      }
 *             {mfquoter.i cname        }
 *             {mfquoter.i ctr          }
 *             {mfquoter.i ctr1         }
 *             {mfquoter.i acc          }
 *             {mfquoter.i acc1         }
 *             if use_sub then do:
 *                 {mfquoter.i sub       }
 *                 {mfquoter.i sub1      }
 *             end.
 *             {mfquoter.i begdt[1]     }
 *             {mfquoter.i enddt[1]     }
 *             {mfquoter.i budget[1]    }
 *             {mfquoter.i budgetcode[1]}
 *             {mfquoter.i begdt[2]     }
 *             {mfquoter.i enddt[2]     }
 *             {mfquoter.i budget[2]    }
 *             {mfquoter.i budgetcode[2]}
 *             {mfquoter.i zeroflag     }
 *             {mfquoter.i prtcents     }
 *K1S9*        end of move */
/*L00M** BEGIN ADD*/
               {mfquoter.i et_report_curr}
/*L01W*        {mfquoter.i et_report_rate}  */
/*L00M** END ADD*/

               if entity1 = "" then assign entity1 = hi_char.
               if acc1 = "" then assign acc1 = hi_char.
               if sub1 = "" then assign sub1 = hi_char.
               if ctr1 = "" then assign ctr1 = hi_char.
               if enddt[1] = ? then assign enddt[1] = today.
               if enddt[2] = ? then assign enddt[2] = today.

/*L00M - BEGIN ADD*/
/*L01W*        {etcurval.i &curr     = "et_report_curr"                       */
/*L01W*                 &errlevel = 4                                         */
/*L01W*                 &prompt   = "next-prompt et_report_curr with frame a" */
/*L01W*                 &action   = "undo, retry"}                            */
/*L00M - END ADD*/

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
/*L01W*/             if c-application-mode = 'web' then return.
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
/*L01W*/          end.
/*L01W*/       end.  /* if et_report_curr <> "" */
/*L01W*/       if et_report_curr = "" or et_report_curr = rpt_curr then assign
/*L01W*/          mc-exch-line1 = ""
/*L01W*/          mc-exch-line2 = ""
/*L01W*/          et_report_curr = rpt_curr.

               do i = 1 to 2:

                  /* DETERMINE PERIOD/YEAR OF ENDING DATE */
                  {glper1.i enddt[i] peryr}  /*GET PERIOD/YEAR*/
                  if peryr = "" then do:
                     {mfmsg.i 3018 3}    /* DATE NOT WITHIN A VALID PERIOD */
                     if c-application-mode = 'web' then return.
                     else next-prompt enddt[i] with frame a.
                     undo mainloop.
                  end.
                  assign
                     per_end[i]= glc_per
                     fiscal_yr[i] = glc_year.
                  find last glc_cal where glc_year = fiscal_yr[i] no-lock
                  no-error.
                  assign yr_end[i] = glc_end
                         fiscal_yr1[i] = glc_year.

                  if begdt[i] = ? then do:
/*J241**          find glc_cal where glc_year = fiscal_yr[i] and glc_per = 1**/
/*J241**          no-lock no-error.**/
/*J241*/             for first glc_cal
/*J241*/             fields (glc_end glc_per glc_start glc_year)
/*J241*/             no-lock where glc_year = fiscal_yr[i] and glc_per = 1: end.
                     if available glc_cal then assign begdt[i] = glc_start.
                     else assign begdt[i] = low_date.
                  end.

                  /* VALIDATE DATES */
                  if begdt[i] > enddt[i] then do:
                     {mfmsg.i 27 3} /* INVALID DATE */
                     if c-application-mode = 'web' then return.
                     else next-prompt begdt[i] with frame a.
                     undo mainloop.
                  end.

                  if budget[i] then do:
                     /* DETERMINE PERIOD/YEAR OF BEGINNING DATE */
                     if begdt[i] = low_date then do:
                        assign
                           per_beg[i] = 1
                           fiscal_yr[i] = 0.
                     end.
                     else do:
                        {glper1.i begdt[i] peryr} /* GET PERIOD/YEAR */
                        if peryr = "" then do:
                           {mfmsg.i 3018 3} /* DATE NOT WITHIN A VALID PERIOD */
                           if c-application-mode = 'web' then return.
                           else next-prompt begdt[i] with frame a.
                           undo mainloop.
                        end.
                        assign
                           per_beg[i] = glc_per
                           fiscal_yr[i] = glc_year.
                     end.
                  end.  /* if budget[i] */
               end.   /* do i = 1 to 2 */
               display begdt enddt with frame a.

            end.  /* if (c-application-mode <> 'web') ... */

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
                /* SS - 20050919 - B */
                /*
            {mfphead.i}

/*N0QH*
 *          assign hdrstring = {&glcctrrp_p_10}.
 *          if budget[1] then assign hdrstring = {&glcctrrp_p_5}.
 *          assign hdrstring1 = {&glcctrrp_p_10}.
 *          if budget[2] then assign hdrstring1 = {&glcctrrp_p_5}.
 *N0QH*/
/*N0QH*/    assign
               hdrstring = getTermLabel("ACTIVITY",8).
/*N0QH*/    if budget[1] then assign
               hdrstring = " " + getTermLabel("BUDGET",7).
/*N0QH*/    assign
               hdrstring1 = getTermLabel("ACTIVITY",8).
/*N0QH*/    if budget[2] then assign
               hdrstring1 = " " + getTermLabel("BUDGET",7).

            view frame phead1.

            /* CHECK FOR UNPOSTED TRANSACTIONS */
            do i = 1 to 2:
/*J241** BEGIN DELETE FOR PERFORMANCE **
*              if not budget[i] then do:
*                 find first glt_det where glt_entity >= entity and
*                                          glt_entity <= entity1 and
*                                          glt_acc >= acc and
*                                          glt_acc <= acc1 and
*                                          glt_sub >= sub and
*                                          glt_sub <= sub1 and
*                                          glt_cc >= ctr and glt_cc <= ctr1 and
*                                          glt_effdate >= begdt[i] and
*                                          glt_effdate <= enddt[i] no-lock
*                                          no-error.
*                 if available glt_det then do:
*J241** END DELETE **/

/*J241* BEGIN ADD */
               if not budget[i] and
               can-find (first glt_det where glt_entity >= entity and
                                         glt_entity <= entity1 and
                                         glt_acc >= acc and
                                         glt_acc <= acc1 and
                                         glt_sub >= sub and
                                         glt_sub <= sub1 and
                                         glt_cc >= ctr and glt_cc <= ctr1 and
                                         glt_effdate >= begdt[i] and
                                         glt_effdate <= enddt[i])
               then do:
/*J241* END ADD */
                  {mfmsg.i 3151 2} /* UNPOSTED TRANSACTIONS EXIST FOR RANGES
                                      ON THIS REPORT */
                  leave.
/*J241**       end. **/
               end.
            end.  /* do i = 1 to 2 */

            /* SET FORMAT FOR AMOUNTS */
            if not prtcents then do:
               assign
                  prtfmt = ">>>,>>>,>>>,>>9.99cr"
                  prtfmt1 = "(>>>,>>>,>>>,>>9.99)".
            end.
            else do:
               assign
                  prtfmt = ">>,>>>,>>>,>>>,>>9cr"
                  prtfmt1 = "(>>,>>>,>>>,>>>,>>9)".
            end.

            /* PRINT REPORT */
            {gprun.i ""glcctrra.p""}
/*L00M*/    hide frame phead1.
            /* REPORT TRAILER */
            {mfrtrail.i}
                */
                PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

                FOR EACH tta6glcctrrp:
                    DELETE tta6glcctrrp.
                END.
        
               {gprun.i ""a6glcctrrp.p"" "(
                   INPUT entity,
                   INPUT entity1,
                   INPUT acc,
                   INPUT acc1,
                   INPUT sub,
                   INPUT sub1,
                   INPUT ctr,
                   INPUT ctr1,
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
        
                EXPORT DELIMITER ";" "acc" "sub" "ctr" "et_tot01" "et_tot02".
                FOR EACH tta6glcctrrp:
                    EXPORT DELIMITER ";" tta6glcctrrp_acc tta6glcctrrp_sub tta6glcctrrp_ctr tta6glcctrrp_et_tot01 tta6glcctrrp_et_tot02.
                END.
        
                PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

                {a6mfrtrail.i}
                /* SS - 20050919 - E */

         end.

         {wbrp04.i &frame-spec = a}

/*K1S9* Add section */
    PROCEDURE quote-vars:
         /* CREATE BATCH INPUT STRING */
         assign bcdparm = "".
         {mfquoter.i entity       }
         {mfquoter.i entity1      }
         {mfquoter.i cname        }
         {mfquoter.i ctr          }
         {mfquoter.i ctr1         }
         {mfquoter.i acc          }
         {mfquoter.i acc1         }
         if use_sub then do:
            {mfquoter.i sub       }
            {mfquoter.i sub1      }
         end.
         {mfquoter.i begdt[1]     }
         {mfquoter.i enddt[1]     }
         {mfquoter.i budget[1]    }
         {mfquoter.i budgetcode[1]}
         {mfquoter.i begdt[2]     }
         {mfquoter.i enddt[2]     }
         {mfquoter.i budget[2]    }
         {mfquoter.i budgetcode[2]}
         {mfquoter.i zeroflag     }
         {mfquoter.i prtcents     }
     END PROCEDURE.
/*K1S9* end of add */
