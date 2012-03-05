/* sasarp5a.p - SALES BY PART REPORT SUBROUTINE                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert sasarp5a.p (converter v1.00) Fri Oct 10 13:58:01 1997    */
/* web tag in sasarp5a.p (converter v1.00) Mon Oct 06 14:18:41 1997     */
/*F0PN*/          /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 5.0      LAST MODIFIED: 06/20/89   BY: MLB *B130*          */
/* REVISION: 5.0      LAST MODIFIED: 12/08/89   BY: MLB *B434*          */
/* REVISION: 6.0      LAST MODIFIED: 06/14/90   BY: MLB *D038*          */
/* REVISION: 6.0      LAST MODIFIED: 10/25/90   BY: MLB *D141*          */
/* REVISION: 7.0      LAST MODIFIED: 04/17/92   BY: afs *F411*          */
/* REVISION: 7.3      LAST MODIFIED: 11/19/92   BY: jcd *G349*          */
/* REVISION: 7.3      LAST MODIFIED: 12/29/94   BY: rxm *F0C6*          */
/* REVISION: 8.6      LAST MODIFIED: 10/22/97   BY: ays *K14N*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00M*  DS          */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *L02V* Brenda Milton*/
/* SS - 20050801 - B */
{a6sasarp05.i}
define INPUT PARAMETER mon1 as INTEGER.
define INPUT PARAMETER yr1 like cph_year.
define INPUT PARAMETER show_memo like mfc_logical.
define INPUT PARAMETER cust like cm_addr.
define INPUT PARAMETER cust1 like cm_addr.
/* SS - 20050801 - E */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sasarp5a_p_1 "销售额与毛利以千元为单位 "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_2 "显示发货量"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_3 "数量:    "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_4 "销售额:  "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_5 "显示毛利 %"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_6 "显示销售额"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_7 "显示毛利"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_8 "报表合计: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_9 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_10 "错误: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_11 " 毛利 %: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_12 "   毛利: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_13 "  毛利:  "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_14 "  数量:  "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_15 " 合计: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_16 "     合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_17 " 销售额: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp5a_p_18 "产品类 "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {wbrp02.i}

         define shared variable pl like pt_prod_line.
         define shared variable pl1 like pt_prod_line.
         define shared variable part like pt_part.
         define shared variable part1 like pt_part.
         define shared variable ptgroup like pt_group.
         define shared variable type like pt_part_type.
         define shared variable mon as integer format ">9".
         /* SS - 20050801 - B */
         /*
         define shared variable mon1 as integer format ">9".
         define shared variable yr1 like cph_year.
         */
         /* SS - 20050801 - E */
         define shared variable yr like cph_year.
         define shared variable sum-yn like mfc_logical format {&sasarp5a_p_9}
            initial yes.
         define shared variable monhead as character format "x(8)"
            extent 12 no-undo.
         define shared variable under as character format "X(8)" extent 12.
         define variable qty as decimal format "->,>>>,>>9.99" extent 12 no-undo.
         define variable sales as decimal format "->,>>>,>>9.99" extent 12 no-undo.
         define variable cost as decimal format "->,>>>,>>9.99" extent 12 no-undo.
         define variable margin as decimal format "->,>>>,>>9.99" extent 12 no-undo.
         define variable margin_per as decimal format "->>>9.9%"
            extent 12 no-undo.
         define variable tot_marg_per as decimal format "->>>9.9%".
         define variable tot_plmarg_per like tot_marg_per.
         define variable pl_marg_per like margin_per.
         define variable tot_qty as decimal format "->>>,>>>,>>9.99".
         define variable tot_sales like tot_qty.
         define variable tot_margin like tot_qty.
         define variable i as integer.
         define shared variable disp_qty like mfc_logical initial yes
            label {&sasarp5a_p_2}.
         define shared variable disp_sales like mfc_logical initial yes
            label {&sasarp5a_p_6}.
         define shared variable disp_margin like mfc_logical initial yes
            label {&sasarp5a_p_7}.
         define shared variable disp_marg_per like mfc_logical initial yes
            label {&sasarp5a_p_5}.
         define variable pl_qty as decimal format "->,>>>,>>9.99" extent 12 no-undo.
         define variable pl_sales as decimal format "->,>>>,>>9.99"
            extent 12 no-undo.
         define variable pl_margin as decimal format "->,>>>,>>9.99"
            extent 12 no-undo.
         define variable tot_pl_qty as decimal format "->>,>>>,>>>,>>9.99".
         define variable tot_pl_sales as decimal format "->>,>>>,>>>,>>9.99".
         define variable tot_pl_margin as decimal format "->>,>>>,>>>,>>9.99".
         define variable pl-desc like pl_desc.

         define variable rpt_qty like qty.
         define variable rpt_sales like sales.
         define variable rpt_margin like margin.
         define variable rpt_marg_per like margin_per.
         define variable tot_rpt_qty like tot_pl_qty.
         define variable tot_rpt_sales like tot_pl_sales.
         define variable tot_rpt_margin like tot_pl_margin.
         define variable tot_rpt_marper like tot_marg_per.
         define shared variable in_1000s like mfc_logical.
         define variable desc1 like pt_desc1.
         define variable desc2 like pt_desc2.
         define variable um like pt_um.
         /* SS - 20050801 - B */
         /*
         define shared variable show_memo like mfc_logical.
         */
         /* SS - 20050801 - B */

/*L00M*ADD SECTION*/
        {etvar.i  } /* common euro variables */
        {etrpvar.i} /* common euro report variables */
/*L00M*END ADD SECTION*/

         find first soc_ctrl  no-lock.
            /* SS - 20050801 - B */
            /*
         form
            header         space (12)
            monhead
            {&sasarp5a_p_16}    skip space (10)
            under
            "-----------"  skip
         with frame hdr page-top width 132 no-box.

         view frame hdr.
         */
         /* SS - 20050801 - E */

         /* clear report total variables */
         tot_rpt_qty = 0.
         tot_rpt_sales = 0.
         tot_rpt_margin = 0.
         tot_rpt_marper = 0.
         rpt_qty = 0.
         rpt_sales = 0.
         rpt_margin = 0.
         rpt_marg_per = 0.


         /* SS - 20050801 - B */
         /*
         form
            {&sasarp5a_p_1} base_curr no-label
         with frame footer page-bottom width 132.

         if in_1000s
/*L02V* /*L00M*/ and not et_tk_active */
            then view frame footer.
         */
         /* SS - 20050801 - E */

         /* MAIN LOOP */
         for each cph_hist where cph_part >= part and cph_part <= part1
         and cph_pl >= pl and cph_pl <= pl1
         and (cph_year = yr or cph_year = yr1)
         and (cph_type = "" or show_memo = yes)
         and (can-find(pt_mstr where pt_part = cph_part and pt_part_type = type)
         or type = "")
         and (can-find(pt_mstr where pt_part = cph_part and pt_group = ptgroup)
         or ptgroup = "")
         /* SS - 20050801 - B */
         AND cph_cust >= cust
         AND cph_cust <= cust1
         /* SS - 20050801 - E */
         no-lock break by cph_pl by cph_part
         with frame b no-labels no-box width 132:
            {mfrpchk.i}

            if cph_smonth <> soc_fysm then do:
               find msg_mstr where msg_nbr = 116
               and msg_lang = global_user_lang no-lock no-error.
               if available msg_mstr then put {&sasarp5a_p_10} + msg_desc
                  format "x(70)" skip.
            end.

            if first-of(cph_pl) then do:
               tot_pl_qty = 0.
               tot_pl_sales = 0.
               tot_pl_margin = 0.
               tot_plmarg_per = 0.
               pl_qty = 0.
               pl_sales = 0.
               pl_margin = 0.
               pl_marg_per = 0.
            end.
            if first-of(cph_part) then do:
               /* CLEAR VARIABLES */
               tot_qty = 0.
               tot_sales = 0.
               tot_margin = 0.
               tot_marg_per = 0.
               qty = 0.
               sales = 0.
               margin = 0.
               margin_per = 0.
               cost = 0.
            end.

            /* ACCUMULATES VALUES */
            if cph_year = yr then
            do i = 1 to (13 - mon):
                /* SS - 20050801 - B */
                /*
               qty[i] = qty[i] + cph_qty[mon + i - 1].
               sales[i] = sales[i] + cph_sales[mon + i - 1].
               cost[i] = cost[i] + cph_cost[mon + i - 1].
               */
                qty[i] = 0.
                sales[i] = 0.
                cost[i] = 0.
               /* SS - 20050801 - E */
            end.
            else if cph_year = yr1 and yr <> yr1 then
            do i = (13 - mon1) to 12:
               qty[i] = qty[i] + cph_qty[i - (12 - mon1) ].
               sales[i] = sales[i] + cph_sales[i - (12 - mon1) ].
               cost[i] = cost[i] + cph_cost[i - (12 - mon1)].
            end.

            if last-of(cph_part) then do:
/*L00M*ADD SECTION*/
               do i = 1 to 12:
/*L02V*           {etrpconv.i sales[i] sales[i]} */
/*L02V*           {etrpconv.i cost[i]  cost[i]} */
/*L02V*/          if et_report_curr <> base_curr then do:
/*L02V*/             {gprunp.i "mcpl" "p" "mc-curr-conv"
                       "(input base_curr,
                         input et_report_curr,
                         input et_rate1,
                         input et_rate2,
                         input sales[i],
                         input true,   /* ROUND */
                         output sales[i],
                         output mc-error-number)"}
/*L02V*/             if mc-error-number <> 0 then do:
/*L02V*/                {mfmsg.i mc-error-number 2}
/*L02V*/             end.
/*L02V*/             {gprunp.i "mcpl" "p" "mc-curr-conv"
                       "(input base_curr,
                         input et_report_curr,
                         input et_rate1,
                         input et_rate2,
                         input cost[i],
                         input true,   /* ROUND */
                         output cost[i],
                         output mc-error-number)"}
/*L02V*/             if mc-error-number <> 0 then do:
/*L02V*/                {mfmsg.i mc-error-number 2}
/*L02V*/             end.
/*L02V*/          end.  /* if et_report_curr <> base_curr */

               end.  /* do i = 1 to 12 */
/*L00M*END ADD SECTION*/


               /* ROUND TO NEAREST 1000 IF NECESSARY*/
               if in_1000s then do:
                   /* SS - 20050801 - B */
                   /*
                  do i = 1 to 12:
                     sales[i] = round(sales[i] / 1000,0).
                     cost[i]  = round(cost[i]  / 1000,0).
                  end.
                  */
                  do i = 1 to 12:
                     sales[i] = round(sales[i] / 1000,2).
                     cost[i]  = round(cost[i]  / 1000,2).
                  end.
                  /* SS - 20050801 - E */
               end.

               /* CALCULATE MARGINS */
               do i = 1 to 12:
                  margin[i] = sales[i] - cost[i].
                  if sales[i] = 0 then margin_per[i] = 0.
                  else margin_per[i] = (margin[i] / sales[i]) * 100.
               end.

               /* PRINT PART AND MONTHS */
               /* SS - 20050801 - B */
               /*
               if page-size - line-counter < 5 then page.
               view frame hdr.
               */
               /* SS - 20050801 - E */
               if sum-yn = no then do:
                  find pt_mstr where pt_part = cph_part
                  no-lock no-error no-wait.
                  if available pt_mstr then do:
                     desc1 = pt_desc1.
                     desc2 = pt_desc2.
                     um = pt_um.
                  end.
                  else do:
                     desc1 = "".
                     desc2 = "".
                     um    = "".
                  end.
                  /* SS - 20050801 - B */
                  /*
                  put skip(1)
                     cph_pl " " cph_part " " um " " desc1 " " desc2 skip.
                  */
                  /* SS - 20050801 - E */
               end.
               else if last-of(cph_pl) then do:
                  find pl_mstr where pl_prod_line = cph_pl no-lock no-error.
                  if available pl_mstr then pl-desc = pl_desc.
                  put skip(1)
                     cph_pl "  " pl-desc skip.
               end.

               /* TOTAL down - pl and rpt  */
               do i = 1 to 12:
                  pl_qty[i] = pl_qty[i] + qty[i].
                  pl_sales[i] = pl_sales[i] + sales[i].
                  pl_margin[i] = pl_margin[i] + margin[i].
                  rpt_qty[i] = rpt_qty[i] + qty[i].
                  rpt_sales[i] = rpt_sales[i] + sales[i].
                  rpt_margin[i] = rpt_margin[i] + margin[i].
               end.

               /* TOTAL across */
               do i = 1 to 12:
                  tot_qty = tot_qty + qty[i].
                  tot_sales = tot_sales + sales[i].
                  tot_margin = tot_margin + margin[i].
               end.
               /* total across Marg% */
               if tot_sales = 0 then tot_marg_per = 0.
               else
                  tot_marg_per = (tot_margin / tot_sales) * 100.

               /* SS - 20050801 - B */
               /*
               /*DISPLAY*/
               if disp_qty = yes and sum-yn = no then
                  display {&sasarp5a_p_3} qty tot_qty to 129
                  with frame c no-box no-labels
                  width 132.
               if disp_sales = yes and sum-yn = no then
                  display {&sasarp5a_p_4} sales tot_sales to 129
                  with frame d no-box
                  no-labels width 132.
               if disp_margin = yes and sum-yn = no then
                  display {&sasarp5a_p_13} margin tot_margin to 129
                  with frame e no-box
                  no-labels width 132.
               if disp_marg_per = yes and sum-yn = no then
                  display {&sasarp5a_p_11} margin_per tot_marg_per to 129
                  with frame f no-box
                  no-labels width 132.
               */
                  /*
                  EXPORT DELIMITER ";" cph_part desc1 + desc2 um sales[12] cost[12] margin[12] qty[12] tot_sales tot_sales - tot_margin tot_qty.
                  */
                  CREATE ttcph.
                  ASSIGN
                      ttcph_pl = cph_pl
                      ttcph_part = cph_part
                      ttcph_um = um
                      ttcph_desc1 = desc1
                      ttcph_desc2 = desc2
                      ttcph_sales12 = sales[12]
                      ttcph_margin12 = margin[12]
                      ttcph_qty12 = qty[12]
                      ttcph_tot_sales = tot_sales
                      ttcph_tot_margin = tot_margin
                      ttcph_tot_qty = tot_qty
                      .
               /* SS - 20050801 - E */

               if last-of(cph_pl) then do:
                  /* Total PL across */
                  do i = 1 to 12:
                     tot_pl_qty = tot_pl_qty + pl_qty[i].
                     tot_pl_sales = tot_pl_sales + pl_sales[i].
                     tot_pl_margin = tot_pl_margin + pl_margin[i].
                  end.
                  /* Total PL Marg% */
                  do i = 1 to 12:
                     if pl_sales[i] = 0 then pl_marg_per[i] = 0.
                     else
                        pl_marg_per[i] = (pl_margin[i] / pl_sales[i]) * 100.
                  end.
                  /* Total Total PL Marg% */
                  if tot_pl_sales = 0 then tot_plmarg_per = 0.
                  else
                     tot_plmarg_per = (tot_pl_margin / tot_pl_sales) * 100.
                     /* SS - 20050801 - B */
                     /*
                  if page-size - line-counter < 6 then page.
                  if sum-yn = no then
                     display "         " under "-----------" skip
                     with frame g no-box no-labels width 132.
                  display {&sasarp5a_p_18} cph_pl {&sasarp5a_p_15}
/*L00M*/             {&sasarp5a_p_1}
/*L02V* /*L00M*/     when (et_tk_active and in_1000s) to 124 */
/*L02V* /*L00M*/     et_disp_curr when (et_tk_active) to 128 */
/*L02V*/             when (in_1000s) to 124
/*L02V*/             et_report_curr to 129
                     skip
                     with frame x1
/*L00M*/             width 132
                     no-labels no-box.
                  if disp_qty = yes
                     then display {&sasarp5a_p_14} pl_qty tot_pl_qty to 129
                     with frame h no-labels no-box width 132.
                  if disp_sales = yes
                     then display {&sasarp5a_p_17} pl_sales tot_pl_sales
                     to 129 with frame i no-labels no-box width 132.
                  if disp_margin = yes
                     then display {&sasarp5a_p_12} pl_margin
                     tot_pl_margin to 129
                     with frame j no-labels no-box width 132.
                  if disp_marg_per = yes
                     then display {&sasarp5a_p_11} pl_marg_per
                     tot_plmarg_per to 129
                     with frame k no-labels no-box width 132.
                  */
                  /* SS - 20050801 - E */
               end. /*last-of cph_pl*/
            end. /*last-of cph_part*/
         end.  /* for each cph_hist */

         /* calculate rest of report totals */
         do i = 1 to 12:
            if rpt_sales[i] = 0 then rpt_marg_per[i] = 0.
            else rpt_marg_per[i] = (rpt_margin[i] / rpt_sales[i]) * 100.
         end.
         do i = 1 to 12:
            tot_rpt_qty = tot_rpt_qty + rpt_qty[i].
            tot_rpt_sales = tot_rpt_sales + rpt_sales[i].
            tot_rpt_margin = tot_rpt_margin + rpt_margin[i].
         end.
         if tot_rpt_sales = 0 then tot_rpt_marper = 0.
         else tot_rpt_marper = (tot_rpt_margin / tot_rpt_sales) * 100.

              /* SS - 20050801 - B */
              /*
         /* DISPLAY RPT TOTALS */
         if page-size - line-counter < 6 then page.
         display "         " under "-----------" to 129
         with frame p no-labels no-box width 132.
         display {&sasarp5a_p_8} skip
/*L00M*/    {&sasarp5a_p_1}
/*L02V* /*L00M*/ when (et_tk_active and in_1000s) to 124 */
/*L02V* /*L00M*/ et_disp_curr when (et_tk_active) to 128 */
/*L02V*/    when (in_1000s) to 124
/*L02V*/    et_report_curr to 129
            with frame x2
/*L00M*/    width 132
            no-labels no-box.
         if disp_qty = yes
            then display {&sasarp5a_p_14} rpt_qty tot_rpt_qty to 129
            with frame l no-labels no-box width 132.
         if disp_sales = yes
            then display {&sasarp5a_p_17} rpt_sales tot_rpt_sales
            to 129 with frame m no-labels no-box width 132.
         if disp_margin = yes
            then display {&sasarp5a_p_12} rpt_margin
            tot_rpt_margin to 129 with frame n no-labels no-box width 132.
         if disp_marg_per = yes
            then display {&sasarp5a_p_11} rpt_marg_per
            tot_rpt_marper to 129 with frame o no-labels no-box width 132.

/*L02V*/ put skip(1)
/*L02V*/     mc-curr-label et_report_curr skip
/*L02V*/     mc-exch-label mc-exch-line1 skip
/*L02V*/     mc-exch-line2 at 22 skip(1).

         hide frame hdr.
*/
/*
EXPORT DELIMITER ";" "" "合计" "" rpt_sales[12] rpt_sales[12] - rpt_margin[12] rpt_margin[12] rpt_qty[12] tot_rpt_sales tot_rpt_sales - tot_rpt_margin tot_rpt_qty.
*/
/* SS - 20050801 - E */
         {wbrp04.i}
