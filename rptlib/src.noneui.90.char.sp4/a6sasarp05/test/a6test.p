/* sasarp05.p - SALES BY PART REPORT                                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.    */
/*F0PN*/          /*V8#ConvertMode=WebReport                               */
/*V8:ConvertMode=FullGUIReport                                             */
/* REVISION: 4.0      LAST MODIFIED: 12/30/88   BY: PML                    */
/* REVISION: 4.0      LAST MODIFIED: 01/01/89   BY: MLB                    */
/* REVISION: 4.0      LAST MODIFIED: 04/17/89   BY: MLB                    */
/* REVISION: 5.0      LAST MODIFIED: 06/20/89   BY: MLB *B130*             */
/* REVISION: 5.0      LAST MODIFIED: 12/08/89   BY: MLB *B434* (REV ONLY)  */
/* REVISION: 6.0      LAST MODIFIED: 06/14/90   BY: MLB *D038*             */
/* REVISION: 6.0      LAST MODIFIED: 10/11/90   BY: MLB *D087*             */
/* REVISION: 6.0      LAST MODIFIED: 04/24/91   BY: MLV *D572*             */
/* REVISION: 7.0      LAST MODIFIED: 04/17/92   BY: afs *F411* (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 09/10/94   BY: rxm *FQ94*             */
/* REVISION: 7.3      LAST MODIFIED: 11/18/96   BY: *G2J4* Suresh Nayak    */
/* REVISION: 8.6      LAST MODIFIED: 10/22/97   BY: ays *K14N*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00M*  DS             */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* R. McCarthy     */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L02V* Brenda Milton   */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt       */
/* SS - 20050801 - B */
{a6sasarp05.i "new"}
/* SS - 20050801 - E */

     /* DISPLAY TITLE */
     {mfdtitle.i "e+ "}    /*L00M*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sasarp05_p_1 "截止周期"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_2 "6月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_3 "4月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_4 "截止财政年度"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_5 "3月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_6 "8月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_7 "2月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_8 "1月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_9 "12月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_10 "5月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_11 "7月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_12 "包括非库存零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_13 "无效月份"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_14 "10月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_15 "11月"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_16 "必须是本年度或前一年度"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_17 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_18 "显示发货量"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_19 "显示销售额"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_20 "显示毛利"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_21 "显示毛利 %"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_22 "圆整至千元"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp05_p_23 "9月"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*L02V*/ /* THESE ARE NEEDED FOR FULL GUI REPORTS */
/*L02V*/ {gprunpdf.i "mcpl" "p"}
/*L02V*/ {gprunpdf.i "mcui" "p"}

         /* SS - 20050801 - B */
         define new shared variable cust like cm_addr.
         define new shared variable cust1 like cm_addr.
         /* SS - 20050801 - E */
         define new shared variable pl like pt_prod_line.
         define new shared variable pl1 like pt_prod_line.
         define new shared variable part like pt_part.
         define new shared variable part1 like pt_part.
         define new shared variable ptgroup like pt_group.
         define new shared variable type like pt_part_type.
         define new shared variable mon as integer format ">9".
         define new shared variable mon1 as integer format ">9".
         define new shared variable yr1 like cph_year.
         define new shared variable yr like cph_year.
         define new shared variable sum-yn like mfc_logical
            format {&sasarp05_p_17} initial yes.
         define variable mon-name as character format "x(3)" extent 12 no-undo.
         define new shared variable monhead as character
            format "x(8)" extent 12 no-undo.
         define new shared variable under as character format "X(8)" extent 12.
         define variable i as integer.
         define new shared variable disp_qty like mfc_logical
            initial yes label {&sasarp05_p_18}.
         define new shared variable disp_sales like mfc_logical
            initial yes label {&sasarp05_p_19}.
         define new shared variable disp_margin like mfc_logical
            initial yes label {&sasarp05_p_20}.
         define new shared variable disp_marg_per like mfc_logical
            initial yes label {&sasarp05_p_21}.
         define variable cur_year like cph_year.
         define variable amt_to_move as integer.
         define variable j as integer.
         define new shared variable in_1000s like mfc_logical label
            {&sasarp05_p_22}.
         define new shared variable show_memo like mfc_logical label
            {&sasarp05_p_12}
            initial yes.
         define variable amt_to_move1 like amt_to_move.
         define variable mon-name1 like mon-name extent 24.
         define variable adj_year as integer.
         define variable tmp_fysm like soc_fysm.

/*L00M*ADD SECTION*/
         {etvar.i   &new = "new"} /* common euro variables        */
         {etrpvar.i &new = "new"} /* common euro report variables */
         {eteuro.i              } /* some initializations         */
/*L00M*END ADD SECTION*/

         find first soc_ctrl no-lock.
         if month(today) >= soc_fysm and soc_fysm > 1 then
            cur_year = year(today) + 1.
         else cur_year = year(today).

         tmp_fysm = soc_fysm.

         /* FIND AMT_TO_MOVE FOR DEFAULT ENDING MONTH*/
         if soc_fysm > 1 and month(today) < soc_fysm then
            amt_to_move = 13 - soc_fysm.
         else amt_to_move = 1 - soc_fysm.

         if soc_fysm > 1 then
            amt_to_move1 = 13 - soc_fysm.
         else amt_to_move1 = 0.

         mon-name[1] = {&sasarp05_p_8}.
         mon-name[2] = {&sasarp05_p_7}.
         mon-name[3] = {&sasarp05_p_5}.
         mon-name[4] = {&sasarp05_p_3}.
         mon-name[5] = {&sasarp05_p_10}.
         mon-name[6] = {&sasarp05_p_2}.
         mon-name[7] = {&sasarp05_p_11}.
         mon-name[8] = {&sasarp05_p_6}.
         mon-name[9] = {&sasarp05_p_23}.
         mon-name[10] = {&sasarp05_p_14}.
         mon-name[11] = {&sasarp05_p_15}.
         mon-name[12] = {&sasarp05_p_9}.

         /*ADJUST MONTH NAMES FOR FISCAL YEAR*/
         j = 0.
         do i = 12 - amt_to_move1 + 1 to 12:
            j = j + 1.
            mon-name1[j] = mon-name[i].
         end.
         do i = 12 - amt_to_move1 to 1 by -1:
            mon-name1[i + amt_to_move1] = mon-name[i].
         end.
         /*FILL MONTHS 13 TO 24 WITH 1 TO 12*/
         do i = 13 to 24:
            mon-name1[i] = mon-name1[i - 12].
         end.

         /* SELECT FORM */
         form
             /* SS - 20050801 - B */
             cust             colon 19
             cust1            label {t001.i} colon 49 skip
             /* SS - 20050801 - E */
            pl             colon 19
            pl1            label {t001.i} colon 49 skip
            part           colon 19
            part1          label {t001.i} colon 49 skip
            ptgroup        colon 19
            type           colon 19
/*L00M*/    skip(1)
            mon1           colon 19 label {&sasarp05_p_1}
               validate (mon1 <= 12, {&sasarp05_p_13})
/*L00M*     skip */
            yr1            colon 19 label {&sasarp05_p_4}
               validate (yr1 <= cur_year,{&sasarp05_p_16})
            skip
            disp_qty       colon 19
            disp_sales     colon 19
            disp_margin    colon 19
            disp_marg_per  colon 19
            in_1000s       colon 19
            show_memo      colon 19
            sum-yn         colon 19 label {&sasarp05_p_17} skip (1)
/*L02V*/    et_report_curr colon 19
/*L00M*ADD SECTION*/
/*L02V*     et_report_txt  to 19 no-label */
/*L02V*     et_report_curr at 21 no-label */
/*L02V*     et_rate_txt    to 19 no-label */
/*L02V*     et_report_rate at 21 no-label */
/*L00M*END ADD SECTION*/
         with frame a side-labels width 80.

         /* REPORT BLOCK */


         {wbrp01.i}
         repeat:

             /* SS - 20050801 - B */
             if cust1 = hi_char then cust1 = "".
             /* SS - 20050801 - E */
            if pl1 = hi_char then pl1 = "".
            if part1 = hi_char then part1 = "".

            if mon1 = 0 then do:
               mon1 = month(today) - 1 + amt_to_move.
               if mon1 = 0 then mon1 = 12.
               yr1 = cur_year.
               if month(today) = tmp_fysm then yr1 = cur_year - 1.
            end.

/*L02V* /*L00M*/ display et_report_txt /* when et_tk_active */ */
/*L02V* /*L00M*/         et_rate_txt   /* when et_tk_active */ with frame a. */

            /* SS - 20050801 - B */
            /*
            if c-application-mode <> 'web':u then
               update pl pl1 part part1 ptgroup  type  mon1
                      yr1
                      disp_qty disp_sales disp_margin disp_marg_per
                      in_1000s show_memo
                      sum-yn
/*L00M*/              et_report_curr /* when (et_tk_active) */
/*L02V* /*L00M*/      et_report_rate /* when (et_tk_active) */ */
               with frame a.

            {wbrp06.i &command = update &fields = "  pl pl1 part part1
             ptgroup type mon1  yr1  disp_qty disp_sales disp_margin
             disp_marg_per  in_1000s show_memo sum-yn
/*L00M*/     et_report_curr /* when et_tk_active */
/*L02V* /*L00M*/    et_report_rate /* when et_tk_active */ */
             " &frm = "a"}
                */
                if c-application-mode <> 'web':u then
                   update cust cust1 pl pl1 part part1 ptgroup  type  mon1
                          yr1
                          disp_qty disp_sales disp_margin disp_marg_per
                          in_1000s show_memo
                          sum-yn
    /*L00M*/              et_report_curr /* when (et_tk_active) */
    /*L02V* /*L00M*/      et_report_rate /* when (et_tk_active) */ */
                   with frame a.

                {wbrp06.i &command = update &fields = "  cust cust1 pl pl1 part part1
                 ptgroup type mon1  yr1  disp_qty disp_sales disp_margin
                 disp_marg_per  in_1000s show_memo sum-yn
    /*L00M*/     et_report_curr /* when et_tk_active */
    /*L02V* /*L00M*/    et_report_rate /* when et_tk_active */ */
                 " &frm = "a"}
                /* SS - 20050801 - E */

            if (c-application-mode <> 'web':u) or
            (c-application-mode = 'web':u and
            (c-web-request begins 'data':u)) then do:


               /* CREATE BATCH INPUT STRING */
               bcdparm = "".
               /* SS - 20050801 - B */
               {mfquoter.i cust     }
               {mfquoter.i cust1    }
               /* SS - 20050801 - E */
               {mfquoter.i pl     }
               {mfquoter.i pl1    }
               {mfquoter.i part   }
               {mfquoter.i part1  }
               {mfquoter.i ptgroup}
               {mfquoter.i type   }
               {mfquoter.i mon1   }
               {mfquoter.i yr1    }
               {mfquoter.i disp_qty }
               {mfquoter.i disp_sales }
               {mfquoter.i disp_margin}
               {mfquoter.i disp_marg_per}
               {mfquoter.i in_1000s}
               {mfquoter.i show_memo}
               {mfquoter.i sum-yn }
/*L01G* /*L00M*/ if et_tk_active then do: */
/*L00M*/       {mfquoter.i et_report_curr}
/*L02V* /*L00M*/   {mfquoter.i et_report_rate} */
/*L01G* /*L00M*/ end. */

                   /* SS - 20050801 - B */
                   if cust1 = "" then cust1 = hi_char.
                   /* SS - 20050801 - E */
               if pl1 = "" then pl1 = hi_char.
               if part1 = "" then part1 = hi_char.

/*L02V*/       if et_report_curr <> "" then do:
/*L02V*/          {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                    "(input et_report_curr,
                      output mc-error-number)"}
/*L02V*/          if mc-error-number = 0
/*L02V*/          and et_report_curr <> base_curr then do:
/*L08W*           CURRENCIES AND RATES REVERSED BELOW...             */
/*L02V*/             {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                       "(input et_report_curr,
                         input base_curr,
                         input "" "",
                         input et_eff_date,
                         output et_rate2,
                         output et_rate1,
                         output mc-seq,
                         output mc-error-number)"}
/*L02V*/          end.  /* if mc-error-number = 0 */

/*L02V*/          if mc-error-number <> 0 then do:
/*L02V*/             {mfmsg.i mc-error-number 3}
/*L02V*/             if c-application-mode = 'web':u then return.
/*L02V*/             else next-prompt et_report_curr with frame a.
/*L02V*/             undo, retry.
/*L02V*/          end.  /* if mc-error-number <> 0 */
/*L02V*/          else if et_report_curr <> base_curr then do:
/*L08W*              CURRENCIES AND RATES REVERSED BELOW...             */
/*L02V*/             {gprunp.i "mcui" "p" "mc-ex-rate-output"
                       "(input et_report_curr,
                         input base_curr,
                         input et_rate2,
                         input et_rate1,
                         input mc-seq,
                         output mc-exch-line1,
                         output mc-exch-line2)"}
/*L02V*/             {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                       "(input mc-seq)"}
/*L02V*/          end.  /* else do */
/*L02V*/       end.  /* if et_report_curr <> "" */
/*L02V*/       if et_report_curr = "" or et_report_curr = base_curr then
/*L02V*/          assign
/*L02V*/             mc-exch-line1 = ""
/*L02V*/             mc-exch-line2 = ""
/*L02V*/             et_report_curr = base_curr.

            end.  /* if (c-application-mode <> 'web':u) ... */

/*L00M*ADD SECTION*/
/*L02V*     {etcurval.i &curr     = "et_report_curr" */
/*L02V*                 &errlevel = "4" */
/*L02V*                 &action   = "next" */
/*L02V*                 &prompt   = "pause"} */
/*L02V*     {gprun.i ""etrate.p"" "("""")"} */
/*L01G*     if not et_tk_active then assign et_disp_curr = base_curr. */
/*L02V* /*L01G*/ assign et_disp_curr = base_curr. */
/*L00M*END ADD SECTION*/

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
                /* SS - 20050801 - B */
                /*
            {mfphead.i}
                */
                /* SS - 20050801 - E */

            /* SET VARIABLES FOR ROLLING 12 MONTHS */
            if mon1 = 0 then do:
               mon1 = 12.
               yr1 = yr1 - 1.
            end.
            /* CALCULATE STARTING YEAR AND MONTH */
            yr = yr1 - 1.
            mon = mon1 + 1.
            if mon1 = 12 then do:
               yr = yr1.
               mon = 1.
            end.

            /* FILL MONTH/YEAR HEADERS FOR ROLLING MONTHS*/
            amt_to_move = 1 - soc_fysm.
            if soc_fysm > 1 then
               adj_year = 1.
            else adj_year = 0.

            if mon1 >= 12 + amt_to_move and soc_fysm > 1 then do:
               yr1 = yr1 + 1.
               yr = yr + 1.
            end.

            if mon1 + amt_to_move < 12 then yr = yr1 - 1.

            mon1 = mon1 + 12.
            mon = mon1 - 11.

            j = 0.
            do i = mon to mon1:
               j = j + 1.
               if (i <= 12 + amt_to_move and mon1 < 24 + amt_to_move)
               or (i <= 24 + amt_to_move and mon1 >= 24 + amt_to_move) then
                  monhead[j] = mon-name1[i] + " " +
                               string(((yr - adj_year) mod 100), "99").
               else
                  monhead[j] = mon-name1[i] + " " +
                               string(((yr1 - adj_year) mod 100), "99").
            end.

            /* set variable back for subprogram */
            mon1 = mon1 - 12.
            if mon1 < 12 then mon = mon1 + 1.
            else mon = 1.
            if mon1 = 12 then yr = yr1.
            if mon1 >= 12 + amt_to_move and soc_fysm > 1 then do:
               yr1 = yr1 - 1.
               yr = yr - 1.
            end.

            under = "--------".

            /* SS - 20050801 - B */
            /*
            {gprun.i ""sasarp5a.p""}

            /* REPORT TRAILER */
            {mfrtrail.i}
            */
            FOR EACH ttcph:
                DELETE ttcph.
            END.
            {gprun.i ""a6sasarp05.p"" "(
                INPUT mon1,
                INPUT yr1,
                INPUT show_memo,
                INPUT cust,
                INPUT cust1
                )"}
            EXPORT DELIMITER ";" "ttcph_pl" "ttcph_part" "ttcph_um" "ttcph_desc1" "ttcph_desc2" "ttcph_sales12" "ttcph_margin12" "ttcph_qty12" "ttcph_tot_sales" "ttcph_tot_margin" "ttcph_tot_qty".
            FOR EACH ttcph:
                EXPORT DELIMITER ";" ttcph_pl ttcph_part ttcph_um ttcph_desc1 ttcph_desc2 ttcph_sales12 ttcph_margin12 ttcph_qty12 ttcph_tot_sales ttcph_tot_margin ttcph_tot_qty.
            END.
            {a6mfrtrail.i}
            /* SS - 20050801 - B */
         end.  /* repeat */

         {wbrp04.i &frame-spec = a}
