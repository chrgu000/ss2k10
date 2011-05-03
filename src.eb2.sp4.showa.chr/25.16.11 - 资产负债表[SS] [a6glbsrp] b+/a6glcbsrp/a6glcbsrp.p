/* glcbsrp.p - GENERAL LEDGER COMPARATIVE BALANCE SHEET REPORT            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*F0PN*/ /*V8:ConvertMode=Report                                          */
/* REVISION: 1.0      LAST MODIFIED: 12/03/86   BY: emb                   */
/*                                   06/18/87       jms                   */
/*                                   01/25/88       jms                   */
/*                                   02/02/88   by: jms  CSR 24912        */
/*                                   02/26/88   by: jms                   */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG *A175*            */
/*                                   03/11/88   BY: JMS                   */
/*                                   03/24/88   BY: WUG *A187*            */
/*                                   04/22/88   BY: JMS                   */
/*                                   06/13/88   by: jms *A274* (no-undo)  */
/*                                   07/29/88   by: jms *A373*            */
/*                                   08/23/88   by: jms *A402*            */
/*                                   10/10/88   by: jms *A476*            */
/*                                   10/26/88   by: jms *A506* (rev only) */
/*                                   11/08/88   by: jms *A526*            */
/*                                   09/01/88   BY: RL  *C0028*           */
/* REVISION: 5.0      LAST MODIFIED: 05/17/89   BY: jms *B066*            */
/*                                   05/16/89   BY: MLB *B118*            */
/*                                   09/06/89   by: jms *B133*            */
/*                                   09/20/89   by: jms *B135*            */
/*                                   09/27/89   by: jms *B316*            */
/*                                   10/24/89   by: jms *B358*            */
/*                                   11/21/89   by: jms *B400* (rev only) */
/*                                   01/12/90   by: jms *B499* (rev only) */
/*                                   06/07/90   by: jms *B704* (rev only) */
/*                                   06/27/90   by: jms *B721* (rev only) */
/* REVISION: 6.0      LAST MODIFIED: 10/09/90   by: jms *D034*            */
/*                                   11/07/90   by: jms *D189*            */
/*                                   11/30/90   by: jms *D251* (rev only) */
/*                                   12/11/90   by: jms *D255*            */
/*                                   01/22/91   by: jms *D330*            */
/*                                   02/20/91   by: jms *D366*            */
/*                                   04/04/91   by: jms *D493* (rev only) */
/*                                   04/22/91   by: jms *D566* (rev only) */
/*                                   04/23/91   by: jms *D577* (rev only) */
/*                                   05/03/91   by: jms *D612*            */
/*                                   07/23/91   by: jms *D791* (rev only) */
/*                                   09/05/91   by: jms *D849* (rev only) */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   by: jms *F058*            */
/*                                   02/25/92   by: jms *F231*            */
/*                                   06/24/92   by: jms *F702*            */
/*                                   06/29/92   by: jms *F714*            */
/* REVISION: 7.3      LAST MODIFIED: 08/25/92   by: mpp *G030*            */
/*                                   09/14/92   by: jms *F890* (rev only) */
/*                                   04/15/93   by: mpp *G479*            */
/*           7.3                     08/18/93   by: skk *GE29* batch prob */
/*                                   09/20/93   by: pcd *GF67*            */
/*                                   10/21/93   by: jms *GG57*            */
/*                                          (reverses G479)               */
/*                                   09/03/94   by: srk *FQ80*            */
/*                                   09/11/94   by: rmh *GM08*            */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ays  *K0TV*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J241* Jagdish Suvarna*/
/* REVISION: 8.6E     LAST MODIFIED: 04/22/98   BY: LN/SVA *L00M*         */
/* REVISION: 8.6E     LAST MODIFIED: 06/04/98   BY: Mohan CK *K1RK*       */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01W* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 08/13/98   BY: *H1MY* Prashanth Narayan */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 9.1      LAST MODIFIED: 09/10/99   BY: *N02V* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 09/01/00   BY: *N0QH* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 09/12/05   BY: *SS - 20050912* Bill Jiang       */
/* Old ECO marker removed, but no ECO header exists *F119*                   */

/*N02V* Removed obsoleted ConvertMode                                   */

/*J241* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

/* SS - 20050912 - B */
{a6glcbsrp.i}

define input parameter i_entity like en_entity.
define input parameter i_entity1 like en_entity.
define input parameter rptdt01 like gltr_eff_dt.
define input parameter rptdt02 like gltr_eff_dt.
define input parameter budgflag01 like mfc_logical.
define input parameter budgflag02 like mfc_logical.
define input parameter budgetcode01 like bg_code.
define input parameter budgetcode02 like bg_code.
define input parameter i_et_report_curr  like exr_curr1.
/* SS - 20050912 - E */
                
         /* DISPLAY TITLE */
         /* SS - 20050912 - B */
         /*
/*L00M*/ {mfdtitle.i "b+ "}
    */
    /*L00M*/ {a6mfdtitle.i "b+ "}
    /* SS - 20050912 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glcbsrp_p_1 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_5 "Budget Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_6 "Column 1 -- Ending Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_7 "Column 2 -- Ending Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_9 "Print Variances"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_10 "Suppress Zero Amounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_11 "Suppress Account Numbers"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_12 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_13 "Summarize Cost Centers"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_15 "Use Budgets"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_16 "Report currency"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_17 "Round to Nearest Thousand"
/* MaxLen: Comment: */

&SCOPED-DEFINE glcbsrp_p_18 "Round to Nearest Whole Unit"
/* MaxLen: Comment: */

/*N0QH***********BEGIN COMMENTING*************
 * &SCOPED-DEFINE glcbsrp_p_2 "Balance as of "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glcbsrp_p_3 " Budget as of "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glcbsrp_p_4 "Inc/Dec"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glcbsrp_p_8 "Pct  "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glcbsrp_p_14 "Variance   "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE glcbsrp_p_19 "(In 1000's "
 * /* MaxLen: Comment: */
 *N0QH***********END COMMENTING************* */

/* ********** End Translatable Strings Definitions ********* */

         define new shared variable glname like en_name no-undo.
         define new shared variable rptdt like gltr_eff_dt extent 2 no-undo.
         define new shared variable sub like sb_sub no-undo.
         define new shared variable sub1 like sb_sub no-undo.
         define new shared variable ctr like cc_ctr no-undo.
         define new shared variable ctr1 like cc_ctr no-undo.
         define new shared variable level as integer
             format ">9" initial 99 label {&glcbsrp_p_1} no-undo.
         /* SS - 20050912 - B */
         /*
         define new shared variable varflag like mfc_logical
             initial true label {&glcbsrp_p_9} no-undo.
         define new shared variable budgflag like mfc_logical extent 2 no-undo.
         define new shared variable zeroflag like mfc_logical
             initial false label {&glcbsrp_p_10} no-undo.
         define new shared variable ccflag like mfc_logical
             label {&glcbsrp_p_13} no-undo.
         define new shared variable subflag like mfc_logical
             label {&glcbsrp_p_12} no-undo.
         define new shared variable prtflag like mfc_logical initial true
             label {&glcbsrp_p_11} no-undo.
         */
         define new shared variable varflag like mfc_logical
             initial FALSE label {&glcbsrp_p_9} no-undo.
         define new shared variable budgflag like mfc_logical extent 2 no-undo.
         define new shared variable zeroflag like mfc_logical
             initial TRUE label {&glcbsrp_p_10} no-undo.
         define new shared variable ccflag like mfc_logical
             INITIAL TRUE label {&glcbsrp_p_13} no-undo.
         define new shared variable subflag like mfc_logical
             INITIAL TRUE label {&glcbsrp_p_12} no-undo.
         define new shared variable prtflag like mfc_logical initial FALSE
             label {&glcbsrp_p_11} no-undo.
         /* SS - 20050912 - E */
         define new shared variable peryr as character format "x(8)" no-undo.
         define new shared variable per_end like glc_per extent 2 no-undo.
         define new shared variable fiscal_yr as integer extent 2 no-undo.
         define new shared variable yr_beg as date extent 2 no-undo.
         define new shared variable per_beg like glc_per extent 2 no-undo.
         define new shared variable yr_end as date extent 2 no-undo.
         define new shared variable pl like co_pl no-undo.
         define new shared variable ret like co_pl no-undo.
         define new shared variable pl_amt as decimal extent 2 no-undo.
         define new shared variable balance as decimal extent 2 no-undo.
         define new shared variable balance1 like balance extent 2 no-undo.
         define new shared variable entity like en_entity no-undo.
         define new shared variable entity1 like en_entity no-undo.
         define new shared variable cname like glname no-undo.
         define new shared variable hdrstring as character format "x(14)"
             no-undo.
         define new shared variable hdrstring1 like hdrstring no-undo.
         define new shared variable knt as integer no-undo.
         define new shared variable rpt_curr like gltr_curr
             label {&glcbsrp_p_16} no-undo.
         define new shared variable budgetcode like bg_code extent 2 no-undo.
         define new shared variable prt1000 like mfc_logical
             label {&glcbsrp_p_17} no-undo.
         define new shared variable roundcnts like mfc_logical
             label {&glcbsrp_p_18} no-undo.
         define new shared variable prtfmt as character format "x(30)" no-undo.
         define new shared variable vprtfmt as character format "x(30)"
             no-undo.
         define new shared variable xlen as integer no-undo.
         define new shared variable per_end_dt as date extent 2 no-undo.
         define new shared variable per_end_dt1 as date extent 2 no-undo.

         define variable msg1000 as character
/*L00M*      format "x(16)" */
/*L00M*/     format "x(32)"
             no-undo.
         define variable i as integer no-undo.
         define variable xper like glc_per no-undo.
         define variable use_sub like co_use_sub no-undo.
         define variable use_cc like co_use_sub no-undo.
         define variable l-assigned as logical no-undo.

/*L00M*/ /*ADD SECTION*/
         {etrpvar.i &new = "new"} /* common euro report variables */
         {etvar.i   &new = "new"} /* common euro variables        */
         {eteuro.i}               /* some initializations         */
         define new shared variable et_balance like balance.
         define new shared variable et_balance1 like balance1.
/*L01W*  define            variable et_show_curr as character format "x(30)".*/
/*L00M*/ /*END ADD SECTION*/

         /* SELECT FORM */
         form
             entity        colon 30 entity1   colon 55 label {t001.i}
             cname         colon 30 skip(1)
             rptdt[1]      colon 30 label {&glcbsrp_p_6}
             budgflag[1]   colon 30 label {&glcbsrp_p_15}
             budgetcode[1] colon 55 label {&glcbsrp_p_5}
             rptdt[2]      colon 30 label {&glcbsrp_p_7}
             budgflag[2]   colon 30 label {&glcbsrp_p_15}
             budgetcode[2] colon 55 label {&glcbsrp_p_5}
             zeroflag      colon 30
             sub           colon 30 sub1     colon 55  label {t001.i}
             ctr           colon 30 ctr1     colon 55  label {t001.i}
             level         colon 30
             varflag       colon 30
/*L00M*      subflag       colon 30 */
/*L00M*/     subflag       colon 65
             ccflag        colon 30
/*L00M*      prtflag       colon 30 */
/*L00M*/     prtflag       colon 65
             prt1000       colon 30
/*L00M*      roundcnts     colon 30  */
/*L00M*/     roundcnts     colon 65
/*L01W*/     et_report_curr colon 30
/*L01W*      et_report_txt to 30 no-label     */
/*L01W*      space(0) et_report_curr no-label */
/*L01W*      et_rate_txt to 30 no-label       */
/*L01W*      space(0) et_report_rate no-label */
         with frame a side-labels attr-space width 80.

         /* SET EXTERNAL LABELS */
         /* SS - 20050912 - B */
         /*
         setFrameLabels(frame a:handle).
         */
         /* SS - 20050912 - E */

         /* SS - 20050912 - B */
         entity = i_entity.
         entity1 = i_entity1.
         rptdt[1] = rptdt01.
         rptdt[2] = rptdt02.
         budgflag[1] = budgflag01.
         budgflag[2] = budgflag02.
         budgetcode[1] = budgetcode01.
         budgetcode[2] = budgetcode02.
         et_report_curr = i_et_report_curr.
         /* SS - 20050912 - E */

         run assign-values
            (output l-assigned).
         if not l-assigned then return.

         /* DEFINE HEADERS */
         /* SS - 20050912 - B */
         /*
         form header
            cname at 1 space(2) msg1000
/*L01W* /*L00M*/ et_show_curr */
/*L01W*/    mc-curr-label et_report_curr skip
/*L01W*/    mc-exch-label at 60 mc-exch-line1 skip
/*L01W*/    mc-exch-line2 at 82 skip(1)
            skip
/*N02V*
 *          hdrstring to 75       hdrstring1 to 97 {&glcbsrp_p_8} to 129 skip
 *          rptdt[1]  at 64       rptdt[2] at 86
 *          {&glcbsrp_p_14} to 119  {&glcbsrp_p_4} to 129 skip
 *          "------------------" to 75    "------------------" to 97
 *          "-----------------" to 119 "--------" to 129 skip(1)
 *N02V*/

/*N0QH* /*N02V*/ hdrstring to 79   hdrstring1 to 100 {&glcbsrp_p_8} to 130 skip */
/*N0QH*/    hdrstring to 79       hdrstring1 to 100
/*N0QH*/    getTermLabelRt("PERCENT",3) + "  " to 130 format "x(5)" skip
/*N02V*/    rptdt[1]  at 68       rptdt[2] at 89
/*N0QH* /*N02V*/     {&glcbsrp_p_14} to 120  {&glcbsrp_p_4} to 130 skip */
/*N0QH*/    getTermLabelRt("VARIANCE",15) + "   " to 120 format "x(18)"
/*N0QH*/    getTermLabelRt("INC/DEC",8) to 130  format "x(8)" skip
/*N02V*/    "------------------" to 79    "------------------" to 100
/*N02V*/    "-----------------" to 120 "--------" to 130 skip(1)
         with frame phead1 page-top width 132.

         form header
            cname at 1 space(2) msg1000
/*L01W* /*L00M*/ et_show_curr */
/*L01W*/    mc-curr-label et_report_curr skip
/*L01W*/    mc-exch-label at 60 mc-exch-line1 skip
/*L01W*/    mc-exch-line2 at 82 skip(1)
            skip
/*N02V*
 *          hdrstring to 75       hdrstring1 to 97 skip
 *          rptdt[1] at 64        rptdt[2] at 86
 *          "------------------" to 75    "------------------" to 97 skip(1)
 *N02V*/

/*N02V*/    hdrstring to 79       hdrstring1 to 100 skip
/*N02V*/    rptdt[1] at 68        rptdt[2] at 89
/*N02V*/    "------------------" to 79    "------------------" to 100 skip(1)
         with frame phead2 page-top width 132.
         */
         /* SS - 20050912 - E */

         {wbrp01.i}

         /* REPORT BLOCK */
         /* SS - 20050912 - B */
         /*
         mainloop:
         repeat:
             */
             /* SS - 20050912 - E */

            if sub1 = hi_char then assign sub1 = "".
            if ctr1 = hi_char then assign ctr1 = "".
            if entity1 = hi_char then assign entity1 = "".

/*L01W* /*L00M*/     display et_report_txt */
/*L01W* /*L00M*/             et_rate_txt   with frame a. */

            /* SS - 20050912 - B */
            /*
            if c-application-mode <> 'web' then
               update
                  entity entity1
                  cname
                  rptdt[1] budgflag[1] budgetcode[1]
                  rptdt[2] budgflag[2] budgetcode[2]
                  zeroflag
                  sub  when (use_sub)
                  sub1 when (use_sub)
                  ctr  when (use_cc)
                  ctr1 when (use_cc)
                  level
                  varflag
                  subflag when (use_sub)
                  ccflag when (use_cc)
                  prtflag
                  prt1000
                  roundcnts
/*L00M*/          et_report_curr
/*L01W* /*L00M*/  et_report_rate */
               with frame a.

            {wbrp06.i &command = update &fields = "  entity entity1
                 cname rptdt [ 1 ] budgflag [ 1 ] budgetcode [ 1 ]
                 rptdt [ 2 ] budgflag [ 2 ] budgetcode [ 2 ]  zeroflag sub
                 when (use_sub) sub1 when (use_sub) ctr when (use_cc)
                 ctr1 when (use_cc) level
                 varflag subflag when
                 (use_sub)  ccflag when (use_cc) prtflag prt1000 roundcnts
/*L00M*/         et_report_curr
/*L01W* /*L00M*/ et_report_rate */
                 " &frm = "a"}
                */
                /* SS - 20050912 - E */

            if (c-application-mode <> 'web') or
               (c-application-mode = 'web' and
               (c-web-request begins 'data'))
            then do:

               if sub1 = "" then assign sub1 = hi_char.
               if ctr1 = "" then assign ctr1 = hi_char.
               if entity1 = "" then assign entity1 = hi_char.

/*K1RK*/       run quote-vars.
/*K1RK* Moved to an Internal Procedure
 *
 *             /* CREATE BATCH INPUT STRING */
 *             assign bcdparm = "".
 *             {mfquoter.i entity       }
 *             {mfquoter.i entity1      }
 *             {mfquoter.i cname        }
 *             {mfquoter.i rptdt[1]     }
 *             {mfquoter.i budgflag[1]  }
 *             {mfquoter.i budgetcode[1]}
 *             {mfquoter.i rptdt[2]     }
 *             {mfquoter.i budgflag[2]  }
 *             {mfquoter.i budgetcode[2]}
 *             {mfquoter.i zeroflag     }
 *             if use_sub then do:
 *                 {mfquoter.i sub       }
 *                 {mfquoter.i sub1      }
 *             end.
 *             if use_cc then do:
 *                 {mfquoter.i ctr       }
 *                 {mfquoter.i ctr1      }
 *             end.
 *             {mfquoter.i level        }
 *             {mfquoter.i varflag      }
 *             if use_sub then do:
 *                 {mfquoter.i subflag   }
 *             end.
 *             if use_cc then do:
 *                 {mfquoter.i ccflag    }
 *             end.
 *             {mfquoter.i prtflag      }
 *             {mfquoter.i prt1000      }
 *             {mfquoter.i roundcnts    }
 * /*L00M*/    {mfquoter.i et_report_curr}
 * /*L00M*/    {mfquoter.i et_report_rate}
 *K1RK* end of Move */

               /* CHECK FOR VALID REPORT DATE */
               do i = 1 to 2:

                  if rptdt[i] = ? then assign rptdt[i] = today.

                  /* SS - 20050912 - B */
                  /*
                  display rptdt with frame a.
                  */
                  /* SS - 20050912 - E */

                  {glper1.i rptdt[i] peryr}  /*GET PERIOD/YEAR*/

                  if peryr = "" then do:
                     {mfmsg.i 3018 3}    /* DATE NOT WITHIN A VALID PERIOD */
                     if c-application-mode = 'web' then return.
                     else next-prompt rptdt[i] with frame a.
                     /* SS - 20050912 - B */
                     /*
                     undo mainloop.
                     */
                     /* SS - 20050912 - E */
                  end.

                  assign
                     per_end[i] = glc_per
                     fiscal_yr[i] = glc_year
                     per_end_dt[i]  = glc_start
                     per_end_dt1[i] = glc_end.

                  /* DETERMINE DATE OF BEGINNING OF FISCAL YEAR */
/*J241*           find glc_cal where glc_year = fiscal_yr[i] and **/
/*J241*                glc_per = 1 no-lock no-error.      **/
/*J241*/          for first glc_cal fields (glc_end glc_per glc_start glc_year)
/*J241*/          where glc_year = fiscal_yr[i] and
/*J241*/          glc_per = 1 no-lock:   end.

                  if not available glc_cal then do:
                     {mfmsg.i 3033 3}  /* NO FIRST PERIOD DEFINED FOR THIS
                                          FISCAL YEAR. */
                     if c-application-mode = 'web' then return.
                     else next-prompt rptdt[i] with frame a.
                     /* SS - 20050912 - B */
                     /*
                     undo mainloop.
                     */
                     /* SS - 20050912 - E */
                  end.

                  assign
                     yr_beg[i] = glc_start
                     per_beg[i] = 1.

                  find last glc_cal where glc_year = fiscal_yr[i]
                  no-lock no-error.
/*J241*/          if available glc_cal then assign
                     yr_end[i] = glc_end.

                  /* VALIDATE BUDGET CODE */
                  if budgflag[i] = yes then do:
                     if not can-find(first bg_mstr where bg_code = budgetcode[i])
                     then do:
                        {mfmsg.i 3105 3} /* INVALID BUDGET CODE */
                        if c-application-mode = 'web' then return.
                        else next-prompt budgetcode[i] with frame a.
                         /* SS - 20050912 - B */
                         /*
                         undo mainloop.
                         */
                         /* SS - 20050912 - E */
                     end.
                  end.

               end.  /* do i = 1 to 2 */

               /* CHECK FOR VALID LEVEL */
               if level < 1 or level > 99 then do:
                  {mfmsg.i 3015 3}   /*INVALID LEVEL*/
                  if c-application-mode = 'web' then return.
                  else next-prompt level with frame a.
                 /* SS - 20050912 - B */
                 /*
                 undo mainloop.
                 */
                 /* SS - 20050912 - E */
               end.

/*L01W*        {etcurval.i &curr     = "et_report_curr"  */
/*L01W*                    &errlevel = "4"               */
/*L01W*                    &action   = "next"            */
/*L01W*                    &prompt   = "pause"}          */
/*L01W*        {gprun.i ""etrate.p"" "("""")"}           */

/*L01W*/       if et_report_curr <> "" then do:

/*L01W*/          {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                     "(input et_report_curr,
                       output mc-error-number)"}

/*L01W*/          if mc-error-number = 0
/*L01W*/          and et_report_curr <> rpt_curr then do:
/*L08W*/             /* CURRENCIES AND RATES REVERSED BELOW...             */
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
/*L08W*/             /*  CURRENCIES AND RATES REVERSED BELOW...             */
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

/*L01W*/       if et_report_curr = "" or et_report_curr = rpt_curr then
/*L01W*/       assign
/*L01W*/          mc-exch-line1 = ""
/*L01W*/          mc-exch-line2 = ""
/*L01W*/          et_report_curr = rpt_curr.


            end.  /* if (c-application-mode <> 'web') ... */

            /* SELECT PRINTER */
            /* SS - 20050912 - B */
            /*
            {mfselbpr.i "printer" 132}
            {mfphead.i}
                */
                /* SS - 20050912 - E */

            assign msg1000 = "".

/*L01W*     et_show_curr = "". */
/*L01W*     if et_tk_active then do: */
/*L01W*         et_show_curr = et_report_txt + " " + et_disp_curr. */
/*L01W*         if prt1000 then msg1000 = "(in 1000's " + et_disp_curr + ")".*/
/*L01W*     end. */
/*L01W*     else */
/*L01W*     if prt1000 then assign msg1000 = "(in 1000's " + base_curr + ")".*/
/*H1MY*     /*L01W*/     if prt1000 then assign msg1000 = "(in 1000's " + */

/*N0QH* /*H1MY*/  if prt1000 then assign msg1000 = {&glcbsrp_p_19} + */
/*N0QH*/    if prt1000 then assign
/*N0QH*/       msg1000 = "(" + getTermLabel("IN_1000'S",15) + " " +
/*L01W*/                                      et_report_curr + ")".

/*N0QH*
 *          assign hdrstring = {&glcbsrp_p_2}.
 *          if budgflag[1] then assign hdrstring = {&glcbsrp_p_3}.
 *          assign hdrstring1 = {&glcbsrp_p_2}.
 *          if budgflag[2] then assign hdrstring1 = {&glcbsrp_p_3}.
 *N0QH*/
/*N0QH*/    assign
               hdrstring = getTermLabel("BALANCE_AS_OF",13) + " ".
/*N0QH*/    if budgflag[1] then assign
               hdrstring = " " + getTermLabel("BUDGET_AS_OF",12) + " ".
/*N0QH*/    assign
               hdrstring1 = getTermLabel("BALANCE_AS_OF",13) + " ".
/*N0QH*/    if budgflag[2] then assign
               hdrstring1 = " " + getTermLabel("BUDGET_AS_OF",12) + " ".

/* SS - 20050912 - B */
/*
            if varflag then
               view frame phead1.
            else
               view frame phead2.
               */
               /* SS - 20050912 - E */

            run assign-values2
               (output l-assigned).
            if not l-assigned then return.

/* SS - 20050912 - B */
/*
            if varflag then
               hide frame phead1.
            else
               hide frame phead2.

            /* REPORT TRAILER */
            {mfrtrail.i}

         end.  /* repeat */
               */
               /* SS - 20050912 - E */

         {wbrp04.i &frame-spec = a}

         PROCEDURE assign-values:

         define output parameter l-assigned as logical.

            l-assigned = no.

            /* GET NAME OF PRIMARY ENTITY */
/*J241*     find en_mstr where en_entity = current_entity no-lock no-error.**/
/*J241*/    for first en_mstr
/*J241*/    fields (en_name en_entity)
/*J241*/    no-lock where en_entity = current_entity: end.
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
               cname = glname.

            /* GET COMPANY NAME AND P/L ACCOUNT CODE FROM CONTROL FILE */
/*J241*     find first co_ctrl no-lock no-error.                        **/
/*J241*/    for first co_ctrl
/*J241*/    fields (co_enty_bal co_pl co_ret co_use_cc co_use_sub) no-lock: end.
            if not available co_ctrl then do:
               {mfmsg.i 3032 3} /*CONTROL FILE MUST BE DEFINED BEFORE
                                  RUNNING REPORT*/
               if c-application-mode <> 'web' then
                  pause.
               leave.
            end.
            pl = co_pl.

/*J241*     if not can-find(ac_mstr where ac_code=pl) then do: **/
/*J241*/    for first ac_mstr
/*J241*/    fields(ac_code ac_fpos ac_desc ac_type)
/*J241*/    no-lock where ac_code=pl:  end.
/*J241*/    if not available ac_mstr then do:
               {mfmsg.i 3155 3} /*PL ACCT NOT FOUND*/
               if c-application-mode <> 'web' then
                  pause.
               leave.
            end.
            else do:
               if not can-find(first asc_mstr where asc_acc = pl) then do:
/*J241*           find ac_mstr where ac_code=pl.  **/
                  create asc_mstr.
                  assign
                     asc_acc = ac_code
                     asc_sub = ""
                     asc_cc = ""
                     asc_fpos = ac_fpos
                     asc_desc = ac_desc.
                  recno = recid(asc_mstr).
               end.
            end.

            assign
               ret = co_ret
               use_cc = co_use_cc
               use_sub = co_use_sub
               rpt_curr = base_curr.

            if co_enty_bal = no then do:
               assign
                  entity = ""
                  entity1 = ""
                  cname = "".
            end.

            l-assigned = yes.

         END PROCEDURE. /* assign-values */

         PROCEDURE assign-values2:

         define output parameter l-assigned as logical.

            l-assigned = no.

            /* CHECK FOR UNPOSTED TRANSACTIONS */
            do i = 1 to 2:
               if not budgflag[i] then do:
/*J241** BEGIN DELETE FOR PERFORMANCE **
 *                find first glt_det where glt_entity >= entity and
 *                           glt_entity <= entity1 and
 *                           glt_sub >= sub and
 *                           glt_sub <= sub1 and
 *                           glt_cc >= ctr and glt_cc <= ctr1 and
 *                           glt_effdate <= rptdt[i] no-lock
 *                no-error.
 *                if available glt_det then do:
 **J241** END DELETE **/

/*J241*/          if can-find ( first glt_det where
                                      glt_entity >= entity and
                                      glt_entity <= entity1 and
                                      glt_sub >= sub and
                                      glt_sub <= sub1 and
                                      glt_cc >= ctr and
                                      glt_cc <= ctr1 and
                                      glt_effdate <= rptdt[i] )
                  then do:
    /* SS - 20050912 - B */
    /*
                     {mfmsg.i 3151 2} /* UNPOSTED TRANSACTIONS EXIST FOR RANGES
                                         ON THIS REPORT */
                         */
                         /* SS - 20050912 - E */
                     leave.
                  end.
               end.
            end.

            /* CALCULATE AMOUNT IN P/L ACCOUNT FOR CURRENT PERIOD */
            do i = 1 to 2:
               if not budgflag[i] then do:
                  {glpl.i &rptdt=rptdt[i] &yr=fiscal_yr[i] &plamt=pl_amt[i]
                          &per1=per_end[i] &begdt=per_end_dt[i]
                          &enddt=per_end_dt1[i]}
               end.
               else do:
                  {glplbg.i &yr=fiscal_yr[i] &plamt=pl_amt[i] &per1=per_end[i]
                            &bcode=budgetcode[i]}
                  for each bg_mstr
/*J241*/          fields (bg_acc bg_code bg_fpos)
                  where bg_code = budgetcode[i] and
                        bg_acc = ""
                  no-lock use-index bg_ind1:
/*J241*              find fm_mstr where fm_fpos = bg_fpos no-lock no-error. **/
/*J241*/             for first fm_mstr fields (fm_fpos fm_type)
/*J241*/             where fm_fpos = bg_fpos no-lock: end.
                     if available fm_mstr and fm_type = "I" then do:
                        {glfmbg.i &fpos=fm_fpos &yr=fiscal_yr[i]
                         &per=per_beg[i] &per1=per_end[i] &budget=balance[i]
                         &bcode=budgetcode[i]}
                        assign pl_amt[i] = pl_amt[i] + balance[i].
                     end.
                  end.
               end.

            end.

            /* SET FORMAT FOR AMOUNTS*/
            if roundcnts or prt1000 then do:
               assign
                  prtfmt = "(>>,>>>,>>>,>>>,>>9)"
                  vprtfmt = "->>,>>>,>>>,>>>,>>9".
            end.
            else do:
               assign
                  prtfmt = "(>>>,>>>,>>>,>>9.99)"
                  vprtfmt = "->>>,>>>,>>>,>>9.99".
            end.

            /* SS - 20050912 - B */
            /*
            {gprun.i ""glcbsrpa.p""}
                */
                {gprun.i ""a6glcbsrpa.p""}
                /* SS - 20050912 - E */

            l-assigned = yes.

         END PROCEDURE. /* assign-values2 */

/*K1RK*/ /* Begin ADD */
         PROCEDURE quote-vars:

            /* CREATE BATCH INPUT STRING */

            assign bcdparm = "".

            {mfquoter.i entity       }
            {mfquoter.i entity1      }
            {mfquoter.i cname        }
            {mfquoter.i rptdt[1]     }
            {mfquoter.i budgflag[1]  }
            {mfquoter.i budgetcode[1]}
            {mfquoter.i rptdt[2]     }
            {mfquoter.i budgflag[2]  }
            {mfquoter.i budgetcode[2]}
            {mfquoter.i zeroflag     }

            if use_sub then do:
               {mfquoter.i sub       }
               {mfquoter.i sub1      }
            end.
            if use_cc then do:
               {mfquoter.i ctr       }
               {mfquoter.i ctr1      }
            end.
            {mfquoter.i level        }
            {mfquoter.i varflag      }
            if use_sub then do:
               {mfquoter.i subflag   }
            end.
            if use_cc then do:
               {mfquoter.i ccflag    }
            end.
            {mfquoter.i prtflag      }
            {mfquoter.i prt1000      }
            {mfquoter.i roundcnts    }
            {mfquoter.i et_report_curr}
/*L01W*     {mfquoter.i et_report_rate} */

         END PROCEDURE.
/*K1RK*/ /* end of add section */
