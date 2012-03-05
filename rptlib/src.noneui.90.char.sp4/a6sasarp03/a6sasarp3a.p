/* sasarp3a.p - SALES BY CUSTOMER REPORT SUBROUTINE                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/
/*V8:ConvertMode=Report                                                 */
/* REVISION: 6.0      LAST MODIFIED: 06/14/90   BY: MLB *D038*          */
/* REVISION: 6.0      LAST MODIFIED: 10/11/90   BY: MLB *D087*          */
/* REVISION: 6.0      LAST MODIFIED: 10/25/90   BY: MLB *D141*          */
/* REVISION: 6.0      LAST MODIFIED: 04/24/91   BY: MLV *D572*          */
/* REVISION: 6.0      LAST MODIFIED: 09/20/91   BY: MLV *D863*          */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: tjs *F337*          */
/* REVISION: 7.3      LAST MODIFIED: 11/19/92   By: jcd *G349*          */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: ckm *K0VN*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00M*  DS          */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *L02V* Brenda Milton*/
/* REVISION: 8.6E     LAST MODIFIED: 05/04/00   BY: *L0X4* Abhijeet T   */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/05   BY: *SS - 20050817* Bill Jiang   */
/* SS - 20050817 - B */
{a6sasarp03.i}

         define input parameter cust like cm_addr.
         define input parameter cust1 like cm_addr.
         define input parameter pl like pt_prod_line.
         define input parameter pl1 like pt_prod_line.
         define input parameter part like pt_part.
         define input parameter part1 like pt_part.
         define input parameter cmtype like cm_type.
         define input parameter cmtype1 like cm_type.
         define input parameter region like cm_region.
         define input parameter region1 like cm_region.
         define input parameter slspsn like sp_addr.
         define input parameter slspsn1 like slspsn.
         define input parameter lstype like ls_type.

         define input parameter mon1 as integer.
         define input parameter yr1 like cph_year.
         define input parameter disp_qty like mfc_logical.
         define input parameter disp_sales like mfc_logical.
         define input parameter disp_margin like mfc_logical.
         define input parameter disp_marg_per like mfc_logical.
         define input parameter in_1000s like mfc_logical.
         define input parameter show_memo like mfc_logical.
         define input parameter sum-yn like mfc_logical.
	     define input parameter et_report_curr like exr_curr1.
/* SS - 20050817 - E */


         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sasarp3a_p_1 "客户     "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_2 " 毛利 %: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_3 "产品类 "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_4 "客户类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_5 "  毛利:  "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_6 "错误: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_7 "包括非库存零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_8 " 销售额: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_9 "    货物发往: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_10 "   毛利: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_11 "        客户: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_12 "     合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_13 "  数量:  "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_14 " 合计: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_15 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_16 "报表合计: "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_17 "销售额与毛利以千元为单位 "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_18 "显示销售额"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_19 "销售额:  "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_20 "显示毛利"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_21 "显示发货量"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_22 "显示毛利 %"
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_23 "货物发往 "
/* MaxLen: Comment: */

&SCOPED-DEFINE sasarp3a_p_24 "数量:    "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {wbrp02.i}

    /* SS - 20050817 - B */
    /*
         define shared variable pl like pt_prod_line.
         define shared variable pl1 like pt_prod_line.
         define shared variable part like pt_part.
         define shared variable part1 like pt_part.
         define shared variable cust like cm_addr.
         define shared variable cust1 like cm_addr.
         define shared variable cmtype like cm_type label {&sasarp3a_p_4}.
         define shared variable cmtype1 like cm_type label {&sasarp3a_p_4}.
         define shared variable region like cm_region.
         define shared variable region1 like cm_region.
         define shared variable slspsn like sp_addr.
         define shared variable slspsn1 like slspsn.
         define shared variable lstype like ls_type.
         define shared variable mon as integer format ">9".
         define shared variable mon1 as integer format ">9".
         define shared variable yr1 like cph_year.
         define shared variable yr like cph_year.
         define shared variable sum-yn like mfc_logical
            format {&sasarp3a_p_15} initial yes.
         */
         define shared variable mon as integer format ">9".
         define shared variable yr like cph_year.
         /* SS - 20050817 - E */
         define shared variable monhead as character
            format "x(8)" extent 12 no-undo.
         define shared variable under as character format "X(8)" extent 12.
         /* SS - 20050817 - B */
         /*
         define shared variable disp_qty like mfc_logical initial yes
            label {&sasarp3a_p_21}.
         define shared variable disp_sales like mfc_logical initial yes
            label {&sasarp3a_p_18}.
         define shared variable disp_margin like mfc_logical initial yes
            label {&sasarp3a_p_20}.
         define shared variable disp_marg_per like mfc_logical initial yes
            label {&sasarp3a_p_22}.
         define variable i as integer.
         define shared variable in_1000s like mfc_logical.
         */
         define variable i as integer.
         /* SS - 20050817 - E */
         define variable desc1 like pt_desc1.
         define variable desc2 like pt_desc2.
         define variable um like pt_um.
         define variable pl-desc like pl_desc.
/*L00M* CHANGED DATA TYPE OF *SALES AND *COST
 *   FROM INTEGER TO DECIMAL                            */
/*L0X4** BEGIN DELETE
 *       define variable qty            as integer format "->>>>>>9" extent 12
 *                                                                   no-undo.
 *       define variable sales          as integer format "->>>>>>9" extent 12
 *                                                                   no-undo.
 *       define variable cost           as integer format "->>>>>>9" extent 12
 *                                                                   no-undo.
 *L0X4** END DELETE */
/*L0X4*/ define variable qty            as decimal format "->>>>>>9" extent 12
/*L0X4*/                                                             no-undo.
/*L0X4*/ define variable sales          as decimal format "->>>>>>9" extent 12
/*L0X4*/                                                             no-undo.
/*L0X4*/ define variable cost           as decimal format "->>>>>>9" extent 12
/*L0X4*/                                                             no-undo.
         define variable margin         as decimal format "->>>>>>9" extent 12
                                                                     no-undo.
         define variable margin_per     as decimal format "->>>9.9%" extent 12
                                                                     no-undo.
         define variable tot_qty        as decimal format "->>>,>>>,>>9".
         define variable tot_sales      like tot_qty.
         define variable tot_margin     like tot_qty.
         define variable tot_marg_per   as decimal format "->>>9.9%".
/*L0X4** BEGIN DELETE
 *      define variable  cm_qty         as integer format "->>>>>>9" extent 12
 *                                                                   no-undo.
 *      define variable  cm_sales       as integer format "->>>>>>9" extent 12
 *                                                                   no-undo.
 *L0X4** END DELETE */
/*L0X4*/ define variable cm_qty         as decimal format "->>>>>>9" extent 12
/*L0X4*/                                                             no-undo.
/*L0X4*/ define variable cm_sales       as decimal format "->>>>>>9" extent 12
/*L0X4*/                                                             no-undo.
         define variable cm_margin      as decimal format "->>>>>>9" extent 12
                                                                     no-undo.
         define variable cm_marg_per    like margin_per.
/*L0X4** define variable tot_cm_qty     as integer format "->>>>>>>>>>9".  */
/*L0X4** define variable tot_cm_sales   as integer format "->>>>>>>>>>9".  */
/*L0X4*/ define variable tot_cm_qty     as decimal format "->>>>>>>>>>9"
/*L0X4*/                                                             no-undo.
/*L0X4*/ define variable tot_cm_sales   as decimal format "->>>>>>>>>>9"
/*L0X4*/                                                             no-undo.
         define variable tot_cm_margin  as decimal format "->>>>>>>>>>9".
         define variable tot_cmmarg_per like tot_marg_per.
/*L0X4** BEGIN DELETE
 *       define variable st_qty         as integer format "->>>>>>9" extent 12
 *                                                                   no-undo.
 *       define variable st_sales       as integer format "->>>>>>9" extent 12
 *                                                                   no-undo.
 *L0X4** END DELETE */
/*L0X4*/ define variable st_qty         as decimal format "->>>>>>9" extent 12
/*L0X4*/                                                             no-undo.
/*L0X4*/ define variable st_sales       as decimal format "->>>>>>9" extent 12
/*L0X4*/                                                             no-undo.
         define variable st_margin      as decimal format "->>>>>>9" extent 12
                                                                     no-undo.
         define variable st_marg_per    like margin_per.
/*L0X4** define variable tot_st_qty     as integer format "->>>>>>>>>>9".  */
/*L0X4** define variable tot_st_sales   as integer format "->>>>>>>>>>9".  */
/*L0X4*/ define variable tot_st_qty     as decimal format "->>>>>>>>>>9"
/*L0X4*/                                                             no-undo.
/*L0X4*/ define variable tot_st_sales   as decimal format "->>>>>>>>>>9"
/*L0X4*/                                                             no-undo.
         define variable tot_st_margin  as decimal format "->>>>>>>>>>9".
         define variable tot_stmarg_per like tot_marg_per.
/*L0X4** BEGIN DELETE
 *        define variable pl_qty        as integer format "->>>>>>9" extent 12
                                                                     no-undo.
 *        define variable pl_sales      as integer format "->>>>>>9" extent 12
 *                                                                   no-undo.
 *L0X4** END DELETE */
/*L0X4*/ define variable pl_qty         as decimal format "->>>>>>9" extent 12
/*L0X4*/                                                             no-undo.
/*L0X4*/ define variable pl_sales       as decimal format "->>>>>>9" extent 12
/*L0X4*/                                                             no-undo.
         define variable pl_margin      as decimal format "->>>>>>9" extent 12
                                                                     no-undo.
         define variable pl_marg_per    like margin_per.
/*L0X4** define variable tot_pl_qty     as integer format "->>>>>>>>>>9".  */
/*L0X4** define variable tot_pl_sales   as integer format "->>>>>>>>>>9".  */
/*L0X4*/ define variable tot_pl_qty     as decimal format "->>>>>>>>>>9"
/*L0X4*/                                                             no-undo.
/*L0X4*/ define variable tot_pl_sales   as decimal format "->>>>>>>>>>9"
/*L0X4*/                                                             no-undo.
         define variable tot_pl_margin  as decimal format "->>>>>>>>>>9".
         define variable tot_plmarg_per like tot_marg_per.
         define variable rpt_qty        like qty.
         define variable rpt_sales      like sales.
         define variable rpt_margin     like margin.
         define variable rpt_marg_per   like margin_per.
         define variable tot_rpt_qty    like tot_pl_qty.
         define variable tot_rpt_sales  like tot_pl_sales.
         define variable tot_rpt_margin like tot_pl_margin.
         define variable tot_rpt_marper like tot_marg_per.
         /* SS - 20050817 - B */
         /*
         define shared variable show_memo like mfc_logical label
            {&sasarp3a_p_7}.
         */
         /* SS - 20050817 - E */

/*L00M*ADD SECTION*/
         {etvar.i  } /* common euro variables */
             /* SS - 20050817 - B */
             /*
         {etrpvar.i} /* common euro report variables */
             */
             {a6etrpvar.i} /* common euro report variables */
/*L00M*END ADD SECTION*/
             /* SS - 20050817 - E */

         find first soc_ctrl no-lock.
         /* SS - 20050817 - B */
         /*
         form
            header         space (12)
            monhead
            {&sasarp3a_p_12}    skip space (10)
            under
            "-----------"  skip
         with frame hdr page-top width 132 no-box.

         view frame hdr.
         */
         /* SS - 20050817 - E */

         /* clear report total variables */
         tot_rpt_qty = 0.
         tot_rpt_sales = 0.
         tot_rpt_margin = 0.
         tot_rpt_marper = 0.
         rpt_qty = 0.
         rpt_sales = 0.
         rpt_margin = 0.
         rpt_marg_per = 0.

         /* SS - 20050817 - B */
         /*
         form
            {&sasarp3a_p_17} base_curr no-label
         with frame footer page-bottom width 80.
         if in_1000s
/*L02V* /*L00M*/    and not et_tk_active */
            then view frame footer.
         */
         /* SS - 20050817 - E */

         /* MAIN LOOP */
         for each cph_hist where cph_cust >= cust and cph_cust <= cust1
         and cph_part >= part and cph_part <= part1
         and cph_pl >= pl and cph_pl <= pl1
         and (cph_year = yr or cph_year = yr1)
         and (cph_type = "" or show_memo = yes)
         no-lock,
         each cm_mstr where cm_addr = cph_cust and
         cm_type >= cmtype and cm_type <= cmtype1
         and cm_slspsn[1] >= slspsn and cm_slspsn[1] <= slspsn1
         and cm_region >= region and cm_region <= region1
         no-lock break by cph_cust by cph_ship by cph_pl by cph_part
         with frame b no-labels no-box width 132:
            {mfrpchk.i}

            if lstype = "" or (lstype <> "" and can-find(first ls_mstr
            where ls_type = lstype and ls_addr = cm_addr)) then do:

                /* SS - 20050817 - B */
                /*
               if cph_smonth <> soc_fysm then do:
                  find msg_mstr where msg_nbr = 116
                  and msg_lang = global_user_lang no-lock no-error.
                  if available msg_mstr then put {&sasarp3a_p_6} +
                     caps(msg_desc)
                     format "x(70)" skip.
               end.
               */
               /* SS - 20050817 - E */

               if first-of(cph_cust) then do:
                   /* SS - 20050817 - B */
                   /*
                  find ad_mstr where ad_addr = cph_cust
                  no-lock no-error no-wait.
                  if page-size - line-counter < 8 then page.
                  put skip {&sasarp3a_p_11} cph_cust " ".
                  if available ad_mstr then put ad_name skip.
                  */
                  /* SS - 20050817 - E */

                  tot_cm_qty = 0.
                  tot_cm_sales = 0.
                  tot_cm_margin = 0.
                  tot_cmmarg_per = 0.
                  cm_qty = 0.
                  cm_sales = 0.
                  cm_margin = 0.
                  cm_marg_per = 0.
               end.

               if first-of(cph_ship) then do:
                   /* SS - 20050817 - B */
                   /*
                  find ad_mstr where ad_addr = cph_ship
                  no-lock no-error no-wait.
                  if page-size - line-counter < 7 then page.
                  put skip {&sasarp3a_p_9} cph_ship " ".
                  if available ad_mstr then put ad_name skip.
                  */
                  /* SS - 20050817 - E */

                  tot_st_qty = 0.
                  tot_st_sales = 0.
                  tot_st_margin = 0.
                  tot_stmarg_per = 0.
                  st_qty = 0.
                  st_sales = 0.
                  st_margin = 0.
                  st_marg_per = 0.
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
                   /* SS - 20050817 - B */
                   /*
                  qty[i] = qty[i] + cph_qty[mon + i - 1].
                  sales[i] = sales[i] + cph_sales[mon + i - 1].
                  cost[i] = cost[i] + cph_cost[mon + i - 1].
                  */
                   qty[i] = 0.
                   sales[i] = 0.
                   cost[i] = 0.
                  /* SS - 20050817 - E */
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
/*L02V*              {etrpconv.i sales[i] sales[i]} */
/*L02V*              {etrpconv.i cost[i]  cost[i] } */
/*L02V*/             if et_report_curr <> base_curr then do:
/*L02V*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                          "(input base_curr,
                            input et_report_curr,
                            input et_rate1,
                            input et_rate2,
                            input sales[i],
                            input true,   /* ROUND */
                            output sales[i],
                            output mc-error-number)"}
/*L02V*/                if mc-error-number <> 0 then do:
/*L02V*/                   {mfmsg.i mc-error-number 2}
/*L02V*/                end.
/*L02V*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                          "(input base_curr,
                            input et_report_curr,
                            input et_rate1,
                            input et_rate2,
                            input cost[i],
                            input true,   /* ROUND */
                            output cost[i],
                            output mc-error-number)"}
/*L02V*/                if mc-error-number <> 0 then do:
/*L02V*/                   {mfmsg.i mc-error-number 2}
/*L02V*/                end.
/*L02V*/             end.  /* if et_report_curr <> base_curr */
                  end.  /* do i = 1 to 12 */
/*L00M*END ADD SECTION*/

                  /*ROUND TO NEAREST 1000 IF NECESSARY*/
                  if in_1000s then do:
                      /* SS - 20050817 - B */
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
                     /* SS - 20050817 - E */
                  end.

                  /* CALCULATE MARGINS */
                  do i = 1 to 12:
                     margin[i] = sales[i] - cost[i].
                     if sales[i] = 0 then margin_per[i] = 0.
                     else margin_per[i] = (margin[i] / sales[i]) * 100.
                  end.

                  /* PRINT PART AND MONTHS */
                  /* SS - 20050817 - B */
                  /*
                  if page-size - line-counter < 4 then page.
                  view frame hdr.
                  */
                  /* SS - 20050817 - E */
                  if sum-yn = no then do:
                     desc1 = "".
                     find pt_mstr where pt_part = cph_part
                     no-lock no-error no-wait.

                     if available pt_mstr then do:
                        desc1 = pt_desc1.
                        desc2 = pt_desc2.
                        um = pt_um.
                     end.
                     /* SS - 20050817 - B */
                     /*
                     put skip(1)
                         cph_pl " " cph_part " " um " " desc1 " " desc2 skip.
                     */
                     /* SS - 20050817 - B */
                  end.
                  else if last-of(cph_pl) then do:
                     find pl_mstr where pl_prod_line = cph_pl no-lock no-error.
                     if available pl_mstr then pl-desc = pl_desc.
                     /* SS - 20050817 - B */
                     /*
                     put skip(1)
                         cph_pl "  " pl-desc skip.
                     */
                     /* SS - 20050817 - B */
                  end.

                  /* TOTAL down - pl ship cust and rpt  */
                  do i = 1 to 12:
                     pl_qty[i] = pl_qty[i] + qty[i].
                     pl_sales[i] = pl_sales[i] + sales[i].
                     pl_margin[i] = pl_margin[i] + margin[i].
                     st_qty[i] = st_qty[i] + qty[i].
                     st_sales[i] = st_sales[i] + sales[i].
                     st_margin[i] = st_margin[i] + margin[i].
                     cm_qty[i] = cm_qty[i] + qty[i].
                     cm_sales[i] = cm_sales[i] + sales[i].
                     cm_margin[i] = cm_margin[i] + margin[i].
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

                  /* TOTAL across Marg% */
                  if tot_sales = 0 then tot_marg_per = 0.
                  else
                     tot_marg_per = (tot_margin / tot_sales) * 100.

                  /*DISPLAY*/
                     /* SS - 20050817 - B */
                     /*
                  if disp_qty = yes and sum-yn = no then
                     display {&sasarp3a_p_24} qty tot_qty to 129
                     with frame c no-box no-labels
                     width 132.
                  if disp_sales = yes and sum-yn = no then
                     display {&sasarp3a_p_19} sales tot_sales to 129
                     with frame d no-box
                     no-labels width 132.
                  if disp_margin = yes and sum-yn = no then
                     display {&sasarp3a_p_5} margin tot_margin to 129
                     with frame e no-box
                     no-labels width 132.
                  if disp_marg_per = yes and sum-yn = no then
                     display {&sasarp3a_p_2} margin_per tot_marg_per to 129
                     with frame f no-box
                     no-labels width 132.
                  */
                     IF sum-yn = NO THEN DO:
                         CREATE ttcph.
                         ASSIGN
                             ttcph_cust = cph_cust
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
                     END.
                  /* SS - 20050817 - E */

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
                     /* SS - 20050817 - B */
                     /*
                     if page-size - line-counter < 5 then page.
                     if sum-yn = no then display "         "
                        under "-----------" skip
                        with frame g no-box no-labels width 132.

/*L02V* /*L00M*/     if et_tk_active then do: */
/*L02V* /*L00M*/             put {&sasarp3a_p_3} cph_pl {&sasarp3a_p_14}. */
/*L02V* /*L00M*/             if in_1000s then put {&sasarp3a_p_17} to 124. */
/*L02V* /*L00M*/     put et_disp_curr to 129 skip. end. */
/*L02V* /*L00M*/     else */

                     put {&sasarp3a_p_3} cph_pl {&sasarp3a_p_14} skip.
/*L02V*/             if in_1000s then put {&sasarp3a_p_17} to 124.
/*L02V*/             put et_report_curr to 129 skip.
                     if disp_qty = yes
                        then display {&sasarp3a_p_13} pl_qty tot_pl_qty to 129
                        with frame h no-labels no-box width 132.
                     if disp_sales = yes
                        then display {&sasarp3a_p_8} pl_sales tot_pl_sales
                        to 129 with frame i no-labels no-box width 132.
                     if disp_margin = yes
                        then display {&sasarp3a_p_10} pl_margin
                        tot_pl_margin to 129 with frame j no-labels no-box
                        width 132.
                     if disp_marg_per = yes
                        then display {&sasarp3a_p_2} pl_marg_per
                        tot_plmarg_per to 129 with frame k no-labels no-box
                        width 132.
                     */
                        IF sum-yn <> NO THEN DO:
                            CREATE ttcph.
                            ASSIGN
                                ttcph_cust = cph_cust
                                ttcph_pl = cph_pl
                                /*
                                ttcph_part = cph_part
                                ttcph_um = um
                                ttcph_desc1 = desc1
                                ttcph_desc2 = desc2
                                */
                                ttcph_sales12 = pl_sales[12]
                                ttcph_margin12 = pl_margin[12]
                                ttcph_qty12 = pl_qty[12]
                                ttcph_tot_sales = tot_pl_sales
                                ttcph_tot_margin = tot_pl_margin
                                ttcph_tot_qty = tot_pl_qty
                                .
                        END.
                     /* SS - 20050817 - E */
                     /* SS - 20050817 - B */
                     /*
                     if last-of(cph_ship) then do:
                        /* Total Ship-to across */
                        do i = 1 to 12:
                           tot_st_qty = tot_st_qty + st_qty[i].
                           tot_st_sales = tot_st_sales + st_sales[i].
                           tot_st_margin = tot_st_margin + st_margin[i].
                        end.
                        /* Total Ship-to Marg% */
                        do i = 1 to 12:
                           if st_sales[i] = 0 then st_marg_per[i] = 0.
                           else
                              st_marg_per[i] = (st_margin[i] /
                                               st_sales[i]) * 100.
                        end.
                        /* Total Total Ship-to Marg% */
                        if tot_st_sales = 0 then tot_stmarg_per = 0.
                        else
                           tot_stmarg_per = (tot_st_margin /
                                            tot_st_sales) * 100.
                        if page-size - line-counter < 5 then page.
                        if sum-yn = no
                           then display "         " under "-----------" skip
                           with frame gg no-box no-labels width 132.

/*L02V* /*L00M*/        if et_tk_active then do: */
/*L02V* /*L00M*/            put {&sasarp3a_p_23} cph_ship {&sasarp3a_p_14}. */
/*L02V* /*L00M*/            if in_1000s then put {&sasarp3a_p_17} to 124. */
/*L02V* /*L00M*/            put et_disp_curr to 129 skip. end. */
/*L02V* /*L00M*/        else */

                        put {&sasarp3a_p_23} cph_ship {&sasarp3a_p_14} skip.
/*L02V*/                if in_1000s then put {&sasarp3a_p_17} to 124.
/*L02V*/                put et_report_curr to 129 skip.

                        if disp_qty = yes
                           then display {&sasarp3a_p_13} st_qty
                           tot_st_qty to 129
                           with frame hh no-labels no-box width 132.
                        if disp_sales = yes
                           then display {&sasarp3a_p_8} st_sales tot_st_sales
                           to 129 with frame ii no-labels no-box width 132.
                        if disp_margin = yes
                           then display {&sasarp3a_p_10} st_margin
                           tot_st_margin to 129
                           with frame jj no-labels no-box width 132.
                        if disp_marg_per = yes
                           then display {&sasarp3a_p_2} st_marg_per
                           tot_stmarg_per to 129
                           with frame kk no-labels no-box width 132.
                        if last-of(cph_cust) then do:
                           /* Total Ship-to across */
                           do i = 1 to 12:
                              tot_cm_qty = tot_cm_qty + cm_qty[i].
                              tot_cm_sales = tot_cm_sales + cm_sales[i].
                              tot_cm_margin = tot_cm_margin + cm_margin[i].
                           end.
                           /* Total Ship-to Marg% */
                           do i = 1 to 12:
                              if cm_sales[i] = 0 then cm_marg_per[i] = 0.
                              else
                                 cm_marg_per[i] = (cm_margin[i] /
                                                  cm_sales[i]) * 100.
                           end.
                           /* Total Total Ship-to Marg% */
                           if tot_cm_sales = 0 then tot_cmmarg_per = 0.
                           else
                              tot_cmmarg_per = (tot_cm_margin /
                                               tot_cm_sales) * 100.
                           if page-size - line-counter < 5 then page.
                           if sum-yn = no then
                              display "         " under "-----------" skip
                              with frame ggg no-box no-labels width 132.
/*L02V* /*L00M*/           if et_tk_active then do: */
/*L02V* /*L00M*/               put {&sasarp3a_p_1} cph_cust {&sasarp3a_p_14}. */
/*L02V* /*L00M*/               if in_1000s then put {&sasarp3a_p_17} to 124. */
/*L02V* /*L00M*/               put et_disp_curr to 129 skip. end. */
/*L02V* /*L00M*/           else */
                           put {&sasarp3a_p_1} cph_cust {&sasarp3a_p_14} skip.
/*L02V*/                   if in_1000s then put {&sasarp3a_p_17} to 124.
/*L02V*/                   put et_report_curr to 129 skip.

                           if disp_qty = yes
                              then display {&sasarp3a_p_13} cm_qty
                              tot_cm_qty to 129
                              with frame hhh no-labels no-box width 132.
                           if disp_sales = yes
                              then display {&sasarp3a_p_8} cm_sales tot_cm_sales
                              to 129 with frame iii no-labels no-box width 132.
                           if disp_margin = yes
                              then display {&sasarp3a_p_10} cm_margin
                              tot_cm_margin to 129 with frame jjj
                              no-labels no-box width 132.
                           if disp_marg_per = yes
                              then display {&sasarp3a_p_2} cm_marg_per
                              tot_cmmarg_per to 129 with frame kkk
                              no-labels no-box width 132.
                        end. /*last-of cph_cust*/
                        put skip(1) " ".
                     end. /*last-of cph_ship*/
                     */
                     /* SS - 20050817 - E */
                  end.  /*last-of cph_pl*/
               end. /*last-of cph_part*/
            end. /* if lstype */
         end. /* for each cph_hist */

         /* SS - 20050817 - B */
         /*
         /* CALCULATE REPORT TOTALS */
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

         /* DISPLAY RPT TOTALS */
         if page-size - line-counter < 5 then page.
         display "         " under "-----------" to 129
         with frame p no-labels no-box width 132.
         display {&sasarp3a_p_16} skip.
         if disp_qty = yes
            then display {&sasarp3a_p_13} rpt_qty tot_rpt_qty to 129
            with frame l no-labels no-box width 132.
         if disp_sales = yes
            then display {&sasarp3a_p_8} rpt_sales tot_rpt_sales
            to 129 with frame m no-labels no-box width 132.
         if disp_margin = yes
            then display {&sasarp3a_p_10} rpt_margin
            tot_rpt_margin to 129 with frame n no-labels no-box width 132.
         if disp_marg_per = yes
            then display {&sasarp3a_p_2} rpt_marg_per
            tot_rpt_marper to 129 with frame o no-labels no-box width 132.

/*L02V*/ put skip(1)
/*L02V*/     mc-curr-label et_report_curr skip
/*L02V*/     mc-exch-label mc-exch-line1 skip
/*L02V*/     mc-exch-line2 at 22.

         hide frame hdr.
         */
         /* SS - 20050817 - E */
         {wbrp04.i}
