/* GUI CONVERTED from arcsrp2a.p (converter v1.71) Thu Oct  1 14:20:02 1998 */
/* arcsrp2a.p - AR AGING REPORT BY INVOICE DATE SUBROUTINE               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=Report                                                  */
/*L02Q*/ /*V8:WebEnabled=No                                              */
/* REVISION: 1.0      LAST MODIFIED: 08/14/86   BY: PML-01               */
/* REVISION: 6.0      LAST MODIFIED: 09/06/90   BY: afs *D059*           */
/* REVISION: 6.0      LAST MODIFIED: 09/06/90   BY: afs *D066*           */
/* REVISION: 6.0      LAST MODIFIED: 10/16/90   BY: afs *D101*           */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: afs *D283*           */
/* REVISION: 6.0      LAST MODIFIED: 03/30/91   BY: bjb *D507*           */
/* REVISION: 6.0      LAST MODIFIED: 06/24/91   BY: afs *D723*           */
/* REVISION: 7.0      LAST MODIFIED: 11/26/91   BY: afs *F041*           */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   BY: jjs *F237*           */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: tjs *F337*           */
/*                                   05/13/92   by: jms *F481*           */
/*                                   06/18/92   by: jjs *F670*           */
/*                                   07/29/92   by: jms *F829*           */
/* REVISION: 7.3      LAST MODIFIED: 09/28/92   by: mpp *G476*           */
/*                                   08/10/93   by: jms *GE05*           */
/*                                   10/13/94   by: str *FS40*           */
/*                                   12/29/94   by: str *F0C3*           */
/*                                   08/22/95   by: wjk *F0TH*           */
/*                                   01/31/96   by: mys *F0WY*           */
/* REVISION: 8.5      LAST MODIFIED: 12/15/95   by: taf *J053*           */
/*                                   04/08/96   by: jzw *G1P6*           */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   by: jzw *K00B*           */
/*                                   10/08/96   by: jzw *K00W*           */
/* REVISION: 8.6      LAST MODIFIED: 08/30/97   BY: *H1DT* Irine D'mello */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: bvm *K0PY*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00S* D. Sidel      */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton  */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L02Q* Brenda Milton */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L059* Jean Miller   */
/* REVISION: 8.6E     LAST MODIFIED: 08/24/98   BY: *L079* Brenda Milton */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt     */

/* ********** Begin Translatable Strings Definitions ********* */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          {mfdeclre.i} /*GUI moved to top.*/
&SCOPED-DEFINE arcsrp2a_p_1 "栏目天数"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_2 " 报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_3 "财务费用:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_4 "联系人"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_5 "        天      "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_6 "级"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_7 "基本货币客户合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_8 " 兑换率的合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_9 "发票:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_10 "帐龄日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_11 " 合计 "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_12 "基本货币报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_13 "    超过"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_14 "帐龄日为 "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_15 "    小于  "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_16 "帐龄日期   "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_17 " 客户合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_18 "争议"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_19 "       合计金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_20 " 帐龄:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_21 "-相对于基本货币:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_22 "借/贷项通知单:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_23 "支付方式"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_24 "汇票:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_25 "催帐"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_26 "去除有争议金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_27 "客户类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_28 "  日期    "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_29 "  参考    "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_30 "打印主说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_31 "打印发票说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_32 "打印付款明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_33 "打印客户采购单"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_34 "未指定用途的付款:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_35 "电话"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_36 "差异-"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_37 "以基本货币计算的帐龄金额合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_38 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_39 "客户    "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_40 "  合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_41 "报表"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_43 " 客户名称              "
&SCOPED-DEFINE arcsrp2a_p_44 "    城市  "



/* ********** End Translatable Strings Definitions ********* */

/*GUI moved mfdeclre/mfdtitle.*/

/*L02Q*   {wbrp02.i} */

          define shared variable cust like ar_bill.
          define shared variable cust1 like ar_bill.
          define shared variable cust_type like cm_type label {&arcsrp2a_p_27}.
          define shared variable cust_type1 like cm_type.
          define shared variable ardate like ar_date.
          define shared variable ardate1 like ar_date.
          define shared variable nbr like ar_nbr.
          define shared variable nbr1 like ar_nbr.
          define shared variable slspsn like sp_addr.
          define shared variable slspsn1 like sp_addr.
          define shared variable acct_type like ar_acct.
          define shared variable acct_type1 like ar_acct.
          define shared variable age_date like ar_due_date
             label {&arcsrp2a_p_10} initial today.
          define shared variable summary_only like mfc_logical
             label {&arcsrp2a_p_38} initial no format {&arcsrp2a_p_38}.
          define shared variable base_rpt like ar_curr.
          define shared variable deduct_contest like mfc_logical
             label {&arcsrp2a_p_26}.
          define shared variable show_po like mfc_logical
             label {&arcsrp2a_p_33} initial no.
          define shared variable show_pay_detail like mfc_logical
             label {&arcsrp2a_p_32} initial no.
          define shared variable show_comments like mfc_logical
             label {&arcsrp2a_p_31} initial no.
          define shared variable show_mstr_comments like mfc_logical
             label {&arcsrp2a_p_30} initial no.
          define shared variable age_days as integer extent 4
             label {&arcsrp2a_p_1}.
          define shared variable mstr_type like cd_type.
          define shared variable mstr_lang like cd_lang.
          define shared variable entity like gl_entity.
          define shared variable entity1 like gl_entity.
          define variable name like ad_name.
          define variable age_range as character extent 4 format "X(16)".
          define variable i as integer.
          define variable age_amt like ar_amt extent 4.
          define variable age_period as integer.
          define variable cm_recno as recid.
          define variable balance like cm_balance.
          define variable age_paid like ar_amt extent 4.
          define variable sum_amt like ar_amt extent 4.
          define variable inv_tot like ar_amt.
          define variable memo_tot like ar_amt.
          define variable fc_tot like ar_amt.
          define variable paid_tot like ar_amt.
          define variable drft_tot like ar_amt.
          define variable base_amt like ar_amt.
          define variable base_applied like ar_applied.
          define variable contested as character format "x(5)".
          define variable curr_amt like ar_amt.
          define variable new_cust like mfc_logical initial true.
          define variable use_rec like mfc_logical initial false.
          define variable rec_printed like mfc_logical initial false.
          define buffer payment for ar_mstr.
          define shared variable lstype like ls_type.
          define variable u_amt like base_amt.
          define buffer armstr for ar_mstr.
          define variable u_applied like base_amt.
/*L02Q*   define variable exdrate like exd_rate. */
/*L02Q*/  define variable exdrate like exr_rate.
/*L02Q* /*L00Y*/  define variable exdrate2 like exd_rate. */
/*L02Q*/  define variable exdrate2 like exr_rate.
/*L02Q*/  define variable exdratetype like exr_ratetype no-undo.
          define variable tempstr as character format "x(25)".
          define variable high_dun_level like ar_dun_level.
          define variable disp_dun_level like ar_dun_level format ">>" no-undo.

/*L02Q*/  define shared variable mc-rpt-curr like ar_curr no-undo.

/*L00S*BEGIN ADDED SECTION*/
          {etrpvar.i }
          {etvar.i   }
          define variable et_age_amt          like ar_amt extent 4.
          define variable et_age_paid         like ar_amt extent 4.
          define variable et_sum_amt          like ar_amt extent 4.
          define variable et_base_amt         like ar_amt.
          define variable et_base_applied     like ar_amt.
          define variable et_curr_amt         like ar_amt.
          define variable et_inv_tot          like ar_amt.
          define variable et_memo_tot         like ar_amt.
          define variable et_fc_tot           like ar_amt.
          define variable et_paid_tot         like ar_amt.
          define variable et_drft_tot         like ar_amt.
          define variable et_org_sum_amt      like ar_amt extent 4.
          define variable et_org_base_amt     like ar_amt.
          define variable et_org_base_applied like ar_amt.
          define variable et_org_curr_amt     like ar_amt.
          define variable et_org_inv_tot      like ar_amt.
          define variable et_org_memo_tot     like ar_amt.
          define variable et_org_fc_tot       like ar_amt.
          define variable et_org_paid_tot     like ar_amt.
          define variable et_org_amt          like ar_amt.
          define variable et_org_drft_tot     like ar_amt.
          define variable et_diff_exist       like mfc_logical initial false.
/*L00S*END ADDED SECTION*/

          find first gl_ctrl no-lock. /*rounding after currency conversion*/

          /* CREATE REPORT HEADER */
          do i = 2 to 4:
             age_range[i] = {&arcsrp2a_p_13} + string(age_days[i - 1],"->>>9").
          end.
          age_range[1] = {&arcsrp2a_p_15} + string(age_days[1],"->>>9").

          FORM /*GUI*/ 
             header
             space (64)
          /*    {&arcsrp2a_p_25} FOR DUNNING LEVEL */
             age_range[1 for 4]    skip
             {&arcsrp2a_p_39}
             {&arcsrp2a_p_43}
             {&arcsrp2a_p_44}
             {&arcsrp2a_p_29}
             "T"
             {&arcsrp2a_p_28}
          /*   {&arcsrp2a_p_23} */
            /*  {&arcsrp2a_p_6} FOR DUNNING LEVEL */
             {&arcsrp2a_p_5}
             {&arcsrp2a_p_5}
             {&arcsrp2a_p_5}
             {&arcsrp2a_p_5}
             {&arcsrp2a_p_19} skip
             "--------"
             "-------------------------"
             "--------"
             "--------"
             "--" /* FOR DUNNING t */
             "--------"
             "----------------"
             "----------------"
             "----------------"
             "----------------"
             "----------------"skip
             with STREAM-IO /*GUI*/  frame phead1 width 256 page-top.
          view frame phead1.

          do with frame c down no-box:

             for each cm_mstr where
                (cm_addr >= cust and cm_addr <= cust1)
                and (cm_type >= cust_type and cm_type <= cust_type1)
                no-lock by cm_sort:

                high_dun_level = 0.

                /* MODIFIED THE SELECTION CRITERIA OF THE FOR EACH ar_mstr */
                /* LOOP TO INCLUDE ALL THE 4 SALESPERSONS                  */

                for each ar_mstr where ar_bill = cm_addr
                   and (ar_nbr >= nbr and ar_nbr <= nbr1)
                   and ((ar_slspsn[1] >= slspsn and ar_slspsn[1] <= slspsn1)
                   or   (ar_slspsn[2] >= slspsn and ar_slspsn[2] <= slspsn1)
                   or   (ar_slspsn[3] >= slspsn and ar_slspsn[3] <= slspsn1)
                   or   (ar_slspsn[4] >= slspsn and ar_slspsn[4] <= slspsn1))
                   and (ar_type = "P" or
                   (ar_entity >= entity and ar_entity <= entity1))
                   and (ar_amt - ar_applied <> 0) and abs( ar_amt - ar_applied )>1 
                   and (ar_type = "P"
                   or (ar_date >= ardate and ar_date <= ardate1) or ar_date = ?)
                   and (not ar_type = "D" or ar_draft) /* APPRVD DRAFTS ONLY */
                   and (ar_curr = base_rpt
                   or base_rpt = "")
                   and (not (deduct_contest and ar_contested = yes))
                   no-lock break by ar_bill by ar_nbr
                   with frame c width 132 no-labels:

                   if lstype = "" or (lstype <> "" and can-find(first ls_mstr
                      where ls_type = lstype and ls_addr = cm_addr)) then do:

                     /* Store first customer information in a logical, since the
                         account validation may cause the actual first record
                         to be skipped */
                      if first-of(ar_bill) then new_cust = true.

                      /* Validate the AR account (if range specified) */
                      use_rec = true.
                      if (acct_type <> "" or acct_type1 <> hi_char) or
                         (entity <> "" or entity1 <> hi_char) then do:
                         if ar_type <> "P" then do:
                            if (ar_acct < acct_type or ar_acct > acct_type1)
                               then use_rec = false.
                         end.
                         else do: /* Payments: if unapplied, get the detail to
                                     determine the application account */
                            use_rec = false.
                            u_amt = 0.
                            u_applied = 0.
                            for each ard_det where ard_nbr = ar_nbr
                               and ard_type = "U" and ard_ref = "" no-lock:
                               if ard_acct >= acct_type and
                                  ard_acct <= acct_type1 and
                                  ard_entity >= entity and ard_entity <= entity1
                                  then do:
                                  use_rec = true.
                                  u_amt = u_amt - /* + */ ard_amt.
                               end.
                            end.
                            for each armstr where
                                    armstr.ar_check = ar_mstr.ar_check and
                                    armstr.ar_bill = ar_mstr.ar_bill and
                                    armstr.ar_type = "A" no-lock:
                              for each ard_det where ard_nbr = armstr.ar_nbr
                                 no-lock:
                                 u_applied = u_applied - ard_amt.
                              end.
                            end.
                         end.  /* else do */
                      end.  /* if (acct_type <> "" ... */
                      else if ar_type = "P" then do:
                         u_amt = ar_amt.
                         u_applied = ar_applied.
                      end.

                      if use_rec then do:

                          FORM /*GUI*/                             
                            ar_bill
                            name
                            ad_city
                            ad_country
                            ar_nbr         format "x(8)"
                            ar_type
                            ar_date
                           /* ar_cr_terms
                            ar_dun_level format ">>"*/
/*L00S*                     age_amt[1 for 4] */
/*L00S*/                    et_age_amt[1 for 4]
                            ar_amt
                            contested
                         with STREAM-IO /*GUI*/  frame c
                         width 256.

                         do i = 1 to 4:
/*L00S*/                    et_age_amt[i] = 0.
/*L00S*/                    et_age_paid[i] = 0.
/*L00S*/                    et_sum_amt[i] = 0.
                            age_amt[i] = 0.
                            age_paid[i] = 0.
                            sum_amt[i] = 0.
                         end.

                         if new_cust then do:
                            new_cust = false.
                            rec_printed = true.
                           name = "".
                            find ad_mstr where ad_addr = ar_bill no-lock no-wait
                               no-error.

                            cm_recno = recid(cm_mstr).
                            balance = cm_balance.

                            if available ad_mstr then name = ad_name.
                            if page-size - line-counter < 4 then page.

                         display ar_bill no-label
                                name no-label
                               ad_city
                               ad_country
                             /*  cm_pay_date
                             ad_attn label {&arcsrp2a_p_4}
                               ad_phone label {&arcsrp2a_p_35} 
                               ad_ext no-label */
                            with frame c no-labels width 256 STREAM-IO /*GUI*/ . 
                            if show_mstr_comments then do:
                               {gpcdprt.i &type = mstr_type &ref = cm_addr
                                          &lang = mstr_lang &pos = 10}
                            end.
                   /*         if summary_only = no then down 1.*/
                         end.  /* if new_cust */

                         if summary_only = no then do with frame c:
                            if ar_type <> "P" then display ar_nbr ar_type name ar_bill WITH STREAM-IO /*GUI*/ .
                            else display ar_check @ ar_nbr "U" @ ar_type name ar_bill WITH STREAM-IO /*GUI*/ .
                            display ar_date WITH STREAM-IO .
                                     /* ar_cr_terms
                                    ar_dun_level WITH STREAM-IO GUI.*/ 
                         end.
                         else
                            /* SAVE HIGHEST DUNNING LEVEL FOR THIS CUSTOMER */
                            if ar_dun_level > high_dun_level then
                               high_dun_level = ar_dun_level.

                         age_period = 4.
                         do i = 1 to 4:
                            if age_date - age_days[i] <= ar_date then
                               age_period = i.
                            if age_period <> 4 then leave.
                         end.

                         if ar_type = "P" then do:
                            curr_amt = u_amt - u_applied.
                            base_amt = u_amt.
                            base_applied = u_applied.
                         end.
                         else do:
                            curr_amt = ar_amt - ar_applied.
                            base_amt = ar_amt.
                            base_applied = ar_applied.
                         end.

                         if base_rpt = ""
                         and ar_curr <> base_curr then do:
/*L02Q*                     base_amt = base_amt / ar_ex_rate. */
                            /* ROUND PER BASE ROUND METHOD */
/*L02Q*                     {gprun.i ""gpcurrnd.p"" "(input-output base_amt, */
/*L02Q*                                               input gl_rnd_mthd)"} */
/*L02Q*                     base_applied = base_applied / ar_ex_rate. */
                            /* ROUND PER BASE ROUND METHOD */
/*L02Q*                     {gprun.i ""gpcurrnd.p"" "(input-output  */
/*L02Q*                                               base_applied, */
/*L02Q*                                               input gl_rnd_mthd)"} */

/*L02Q*/                    assign
/*L02Q*/                       base_amt = ar_base_amt
/*L02Q*/                       base_applied = ar_base_applied.

/*L02Q*                     {gpgtex8.i &ent_curr = base_curr */
/*L02Q*                                &curr = ar_curr */
/*L02Q*                                &date = age_date */
/*L02Q*                                &exch_from = exd_rate */
/*L02Q*                                &exch_to = exdrate} */

/*L02Q*/                    /* GET EXCHANGE RATE */
/*L079*/                    /* REVERSED AR_CURR AND BASE_CURR BELOW */
/*L02Q*/                    {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                              "(input ar_curr,
                                input base_curr,
                                input exdratetype,
                                input age_date,
                                output exdrate,
                                output exdrate2,
                                output mc-error-number)"}
/*L02Q*/                    if mc-error-number <> 0 then do:
/*L08W*L02Q*                   {mfmsg.i mc-error-number 3}   */
/*L08W*/                       {mfmsg.i mc-error-number 4}
/*L08W*/                       pause 0.
/*L08W*/                       leave.
/*L02Q*/                    end.

/*L02Q*                     if available exd_det then */
/*L02Q*                        curr_amt = curr_amt / exdrate. */
/*L02Q*/                    if mc-error-number = 0 then do:
/*L079*/                       /* REVERSED AR_CURR AND BASE_CURR BELOW */
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input ar_curr,
                                   input base_curr,
                                   input exdrate,
                                   input exdrate2,
                                   input curr_amt,
                                   input true,  /* ROUND */
                                   output curr_amt,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 2}
/*L02Q*/                       end.
/*L02Q*/                    end.  /* if mc-error-number = 0 */

                            /*IF NO EXCHANGE RATE FOR TODAY, USE THE INV RATE*/
                            else
/*L02Q*/                    do:
/*L02Q*                        curr_amt = curr_amt / ar_ex_rate. */
/*L02Q*/                       /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input ar_curr,
                                   input base_curr,
                                   input ar_ex_rate,
                                   input ar_ex_rate2,
                                   input curr_amt,
                                   input true, /* ROUND */
                                   output curr_amt,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 2}
/*L02Q*/                       end.
/*L02Q*/                    end.  /* else do */

                            /* ROUND PER BASE ROUND METHOD */
/*L02Q*                     {gprun.i ""gpcurrnd.p"" "(input-output  */
/*L02Q*                                               curr_amt, */
/*L02Q*                                               input gl_rnd_mthd)"} */
                         end.  /* if base_rpt = "" and ar_curr <> base_curr */

                         if ar_date = ? then age_period = 1.

                         if not show_pay_detail or ar_type = "P"
                            then age_amt[age_period] = base_amt - base_applied.
                         else age_amt[age_period] = base_amt.
                         age_paid[age_period] = base_applied * (-1).
                         sum_amt[age_period] = base_amt - base_applied.

                         if ar_type = "I" then
                            inv_tot = base_amt - base_applied.
                         else inv_tot = 0.

                         if ar_type = "M" then
                            memo_tot = base_amt - base_applied.
                         else memo_tot = 0.
                         if ar_type = "F" then fc_tot = base_amt - base_applied.
                            else fc_tot = 0.
                         if ar_type = "D" then
                            drft_tot = base_amt - base_applied.
                         else drft_tot = 0.
                         if ar_type = "P" then
                            paid_tot = base_amt - base_applied.
                         else paid_tot = 0.

/*L00S*BEGIN ADDED SECTION*/

/*L02Q*
 *                       {etrpconv.i sum_amt[1] et_sum_amt[1]}
 *                       {etrpconv.i sum_amt[2] et_sum_amt[2]}
 *                       {etrpconv.i sum_amt[3] et_sum_amt[3]}
 *                       {etrpconv.i sum_amt[4] et_sum_amt[4]}
 *                       {etrpconv.i age_amt[1] et_age_amt[1]}
 *                       {etrpconv.i age_amt[2] et_age_amt[2]}
 *                       {etrpconv.i age_amt[3] et_age_amt[3]}
 *                       {etrpconv.i age_amt[4] et_age_amt[4]}
 *                       {etrpconv.i age_paid[1] et_age_paid[1]}
 *                       {etrpconv.i age_paid[2] et_age_paid[2]}
 *                       {etrpconv.i age_paid[3] et_age_paid[3]}
 *                       {etrpconv.i age_paid[4] et_age_paid[4]}
 *                       {etrpconv.i base_amt et_base_amt}
 *                       {etrpconv.i base_applied et_base_applied}
 *                       {etrpconv.i inv_tot et_inv_tot}
 *                       {etrpconv.i memo_tot et_memo_tot}
 *                       {etrpconv.i fc_tot et_fc_tot}
 *                       {etrpconv.i paid_tot et_paid_tot}
 *                       {etrpconv.i drft_tot et_drft_tot}
 *                       {etrpconv.i curr_amt et_curr_amt}
 *L02Q*/

/*L02Q*/                 do i = 1 to 4:
/*L02Q*/                    if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input sum_amt[i],
                                   input true, /* ROUND */
                                   output et_sum_amt[i],
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 2}
/*L02Q*/                       end.
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input age_amt[i],
                                   input true, /* ROUND */
                                   output et_age_amt[i],
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 2}
/*L02Q*/                       end.
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input age_paid[i],
                                   input true, /* ROUND */
                                   output et_age_paid[i],
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 2}
/*L02Q*/                       end.
/*L02Q*/                    end.  /* if et_report_curr <> mc-rpt-curr */
/*L02Q*/                    else assign
/*L02Q*/                       et_sum_amt[i] = sum_amt[i]
/*L02Q*/                       et_age_amt[i] = age_amt[i]
/*L02Q*/                       et_age_paid[i] = age_paid[i].
/*L02Q*/                 end.  /* do i = 1 to 4 */

/*L02Q*/                 if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input mc-rpt-curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input base_amt,
                                input true, /* ROUND */
                                output et_base_amt,
                                output mc-error-number)"}
/*L02Q*/                    if mc-error-number <> 0 then do:
/*L02Q*/                       {mfmsg.i mc-error-number 2}
/*L02Q*/                    end.
/*L02Q*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input mc-rpt-curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input base_applied,
                                input true, /* ROUND */
                                output et_base_applied,
                                output mc-error-number)"}
/*L02Q*/                    if mc-error-number <> 0 then do:
/*L02Q*/                       {mfmsg.i mc-error-number 2}
/*L02Q*/                    end.
/*L02Q*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input mc-rpt-curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input inv_tot,
                                input true, /* ROUND */
                                output et_inv_tot,
                                output mc-error-number)"}
/*L02Q*/                    if mc-error-number <> 0 then do:
/*L02Q*/                       {mfmsg.i mc-error-number 2}
/*L02Q*/                    end.
/*L02Q*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input mc-rpt-curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input memo_tot,
                                input true, /* ROUND */
                                output et_memo_tot,
                                output mc-error-number)"}
/*L02Q*/                    if mc-error-number <> 0 then do:
/*L02Q*/                       {mfmsg.i mc-error-number 2}
/*L02Q*/                    end.
/*L02Q*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input mc-rpt-curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input fc_tot,
                                input true, /* ROUND */
                                output et_fc_tot,
                                output mc-error-number)"}
/*L02Q*/                    if mc-error-number <> 0 then do:
/*L02Q*/                       {mfmsg.i mc-error-number 2}
/*L02Q*/                    end.
/*L02Q*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input mc-rpt-curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input paid_tot,
                                input true, /* ROUND */
                                output et_paid_tot,
                                output mc-error-number)"}
/*L02Q*/                    if mc-error-number <> 0 then do:
/*L02Q*/                       {mfmsg.i mc-error-number 2}
/*L02Q*/                    end.
/*L02Q*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input mc-rpt-curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input drft_tot,
                                input true, /* ROUND */
                                output et_drft_tot,
                                output mc-error-number)"}
/*L02Q*/                    if mc-error-number <> 0 then do:
/*L02Q*/                       {mfmsg.i mc-error-number 2}
/*L02Q*/                    end.
/*L02Q*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input mc-rpt-curr,
                                input et_report_curr,
                                input et_rate1,
                                input et_rate2,
                                input curr_amt,
                                input true, /* ROUND */
                                output et_curr_amt,
                                output mc-error-number)"}
/*L02Q*/                    if mc-error-number <> 0 then do:
/*L02Q*/                       {mfmsg.i mc-error-number 2}
/*L02Q*/                    end.
/*L02Q*/                 end.  /* if et_report_curr <> mc-rpt-curr */
/*L02Q*/                 else assign
/*L02Q*/                    et_base_amt = base_amt
/*L02Q*/                    et_base_applied = base_applied
/*L02Q*/                    et_inv_tot = inv_tot
/*L02Q*/                    et_memo_tot = memo_tot
/*L02Q*/                    et_fc_tot = fc_tot
/*L02Q*/                    et_paid_tot = paid_tot
/*L02Q*/                    et_drft_tot = drft_tot
/*L02Q*/                    et_curr_amt = curr_amt.


                         accumulate et_sum_amt (total by ar_bill).
                         accumulate et_base_amt - et_base_applied
                            (total by ar_bill).
                         accumulate et_inv_tot  (total).
                         accumulate et_memo_tot (total).
                         accumulate et_fc_tot   (total).
                         accumulate et_paid_tot (total).
                         accumulate et_drft_tot (total).
                         accumulate et_curr_amt (total).
/*L00S*END ADDED SECTION*/

                         accumulate sum_amt (total by ar_bill).
                         accumulate base_amt - base_applied (total by ar_bill).
                         accumulate inv_tot (total).
                         accumulate memo_tot (total).
                         accumulate fc_tot (total).
                         accumulate drft_tot (total).
                         accumulate paid_tot (total).
                         accumulate curr_amt (total).

                         if summary_only = no then do with frame c:
                            if not show_pay_detail or ar_type = "P" then do:
/*L00S*                        display age_amt[1 for 4]  */
/*L00S*/                       display et_age_amt[1 for 4]
/*L00S*                                (base_amt - base_applied) @ ar_amt.  */
/*L00S*/                               (et_base_amt - base_applied) @ ar_amt WITH STREAM-IO /*GUI*/ .

                            if ar_contested then
                                  display {&arcsrp2a_p_18} @ contested WITH STREAM-IO /*GUI*/ .
                               down 1.
                            end.
                            else do:
                               display
/*L00S*                           age_amt[1 for 4]  */
/*L00S*/                          et_age_amt[1 for 4]
/*L00S*                           base_amt @ ar_amt. */
/*L00S*/                          et_base_amt @ ar_amt WITH STREAM-IO /*GUI*/ .

                              if ar_contested then
                                  display {&arcsrp2a_p_18} @ contested WITH STREAM-IO /*GUI*/ . 
                               down 1.
                           if base_applied <> 0 then do:
/*L00S*BEGIN DELETE
 *                                display age_paid[1] @ age_amt[1]
 *                                   age_paid[2] @ age_amt[2]
 *                                   age_paid[3] @ age_amt[3]
 *                                   age_paid[4] @ age_amt[4]
 *                                   base_applied * (-1) @ ar_amt.
 *L00S*END DELETE */

/*L00S*BEGIN ADD */
                                  display et_age_paid[1] @ et_age_amt[1]
                                          et_age_paid[2] @ et_age_amt[2]
                                          et_age_paid[3] @ et_age_amt[3]
                                          et_age_paid[4] @ et_age_amt[4]
                                          et_base_applied * (-1) @ ar_amt WITH STREAM-IO /*GUI*/ .
 /*L00S*END ADD*/

/*L02Q*
 *                                display age_paid[1] @ age_amt[1]
 *                                        age_paid[2] @ age_amt[2]
 *                                        age_paid[3] @ age_amt[3]
 *                                        age_paid[4] @ age_amt[4]
 *                                        base_applied * (-1) @ ar_amt.
 *L02Q*/
                                  down 1.
                                  /* Show payment detail */
                                  for each ard_det where ard_ref = ar_nbr
                                  no-lock with frame c:
                                     find payment where payment.ar_nbr = ard_nbr
                                        no-lock no-error.
                                     if available payment then do:
                                        display
                                        payment.ar_type @ ar_mstr.ar_type
                                        payment.ar_effdate @ ar_mstr.ar_date WITH STREAM-IO .
                              /*          payment.ar_check @ ar_mstr.ar_cr_terms WITH STREAM-IO /*GUI*/ .*/
                                        down 1.
                                     end.
                                  end.
                               end.  /* if base_applied <> 0 */
                            end.  /* else do */
                            if show_po and ar_po <> "" then put ar_po at 10.

                            /* Display document comments */
                            if show_comments and ar_cmtindx <> 0 then do:
                               {arcscmt.i &cmtindx = ar_cmtindx
                                          &subhead = "ar_nbr format ""X(8)"" " }
                            end.

                         end.  /* if summary_only = no */

                      end.  /* use_rec block */

                      /* Customer totals */
    /*                  if last-of(ar_bill) and rec_printed then do with frame c:
                         rec_printed = false.
                         if summary_only = no then do:
                            if page-size - line-counter < 2 then page.
                            underline
/*L00S*                        age_amt */
/*L00S*/                       et_age_amt
                               ar_amt.
                         end.

/*L00S*                  display "    " + base_rpt @ ar_nbr  */
/*L02Q* /*L00S*/         display "    " + et_disp_curr @ ar_nbr */
/*L02Q*/                 display "    " + et_report_curr @ ar_nbr
/*L059* /*L00S*/           "Customer" @ ar_date "Totals:" @ ar_cr_terms */
/*L059*/                   {&arcsrp2a_p_39} @ ar_date
/*L059*/                   {&arcsrp2a_p_40} @ ar_cr_terms */

/*L00S*BEGIN DELETE*
 *                       if base_rpt = ""
 *                       then
 *                          tempstr = "    " + "Base Customer Totals:".
 *                       else
 *                          tempstr = "     " + base_rpt + " Customer Totals:".
 *
 *                       /* DETAIL REPORT SHOWS DUNNING LEVEL FOR EACH ITEM. */
 *                       /* SUMMARY REPORT SHOWS HIGHEST DUNNING LEVEL. */
 *                       disp_dun_level =
 *                          (if summary_only
 *                           and high_dun_level <> 0
 *                           then high_dun_level else 0).
 *
 *                       put tempstr
 *                             disp_dun_level
 *                             to 31
 *                             accum total by ar_bill (sum_amt[1])
 *                             to 48
 *                             format "->>>>,>>>,>>9.99"
 *                             accum total by ar_bill (sum_amt[2])
 *                             to 65
 *                             format "->>>>,>>>,>>9.99"
 *                             accum total by ar_bill (sum_amt[3])
 *                             to 82
 *                             format "->>>>,>>>,>>9.99"
 *                             accum total by ar_bill (sum_amt[4])
 *                             to 99
 *                             format "->>>>,>>>,>>9.99"
 *                             accum total by ar_bill (base_amt - base_applied)
 *                             to 116
 *                             format "->>>>,>>>,>>9.99".
 *L00S*END DELETE*/

/*L00S*BEGIN ADD
                         accum total by ar_bill (et_sum_amt[1])
                         @ et_age_amt[1]
                         accum total by ar_bill (et_sum_amt[2])
                         @ et_age_amt[2]
                         accum total by ar_bill (et_sum_amt[3])
                         @ et_age_amt[3]
                         accum total by ar_bill (et_sum_amt[4])
                         @ et_age_amt[4]
                         accum total by ar_bill (et_base_amt - et_base_applied)
                         @ ar_amt WITH STREAM-IO /*GUI*/ .
                         down 1.*/
/*L00S*END ADD*/

                      end.  /* CUSTOMER TOTALS */

                   end.  /* IF LSTYPE */

                end.  /* FOR EACH AR_MSTR */

                
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

             end.

             if page-size - line-counter < 3 then page.
             else down 2.
             underline
/*L00S*         age_amt */
/*L00S*/        et_age_amt
                ar_amt.

/*L02Q* /*L00S*/     display "    " + et_disp_curr @ ar_nbr */
/*L02Q*/             display "    " + et_report_curr @ ar_nbr
/*L059* /*L00S*/       "Report" @ ar_date "Totals:" @ ar_cr_terms */
/*L059*/               {&arcsrp2a_p_41} @ ar_date
/*L059*/               {&arcsrp2a_p_40} @ ar_cr_terms 

/*L00S*BEGIN DELETE*
 *              if base_rpt = ""
 *              then
 *                 tempstr = "    " + "Base Report Totals:".
 *              else
 *                 tempstr = "     " + base_rpt + " Report Totals:".
 *              put tempstr
 *                  accum total (sum_amt[1])
 *                  to 48
 *                  format "->>>>,>>>,>>9.99"
 *                  accum total (sum_amt[2])
 *                  to 65
 *                  format "->>>>,>>>,>>9.99"
 *                  accum total (sum_amt[3])
 *                  to 82
 *                  format "->>>>,>>>,>>9.99"
 *                  accum total (sum_amt[4])
 *                  to 99
 *                  format "->>>>,>>>,>>9.99"
 *                  accum total (base_amt - base_applied)
 *                  to 116
 *                  format "->>>>,>>>,>>9.99".
 *L00S*END DELETE*/

/*L00S*BEGIN ADD 
                accum total (et_sum_amt[1])
                @ et_age_amt[1]
                accum total (et_sum_amt[2])
                @ et_age_amt[2]
                accum total (et_sum_amt[3])
                @ et_age_amt[3]
                accum total (et_sum_amt[4])
                @ et_age_amt[4]
                accum total (et_base_amt - et_base_applied)
                @ ar_amt WITH STREAM-IO /*GUI*/ .
             down 1.*/

             /*DETERMINE ORIGINAL REPORT TOTALS, NOT YET CONVERTED*/
             assign
                et_org_sum_amt[1] = accum total sum_amt[1]
                et_org_sum_amt[2] = accum total sum_amt[2]
                et_org_sum_amt[3] = accum total sum_amt[3]
                et_org_sum_amt[4] = accum total sum_amt[4]
                et_org_amt        = accum total (base_amt - base_applied).

             /*CONVERT REPORT TOTAL AMOUNTS*/
/*L02Q*      {etrpconv.i et_org_sum_amt[1] et_org_sum_amt[1]} */
/*L02Q*      {etrpconv.i et_org_sum_amt[2] et_org_sum_amt[2]} */
/*L02Q*      {etrpconv.i et_org_sum_amt[3] et_org_sum_amt[3]} */
/*L02Q*      {etrpconv.i et_org_sum_amt[4] et_org_sum_amt[4]} */
/*L02Q*      {etrpconv.i et_org_amt        et_org_amt       } */

/*L02Q*/     if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/        do i = 1 to 4:
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input et_org_sum_amt[i],
                       input true,  /* ROUND */
                       output et_org_sum_amt[i],
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/        end.  /* do i = 1 to 5 */
/*L02Q*/        {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input mc-rpt-curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input et_org_amt,
                    input true,  /* ROUND */
                    output et_org_amt,
                    output mc-error-number)"}
/*L02Q*/        if mc-error-number <> 0 then do:
/*L02Q*/           {mfmsg.i mc-error-number 2}
/*L02Q*/        end.
/*L02Q*/     end.  /* if et_report_curr <> mc-rpt-curr */

             /* DISPLAY CONVERTED AMOUNTS */
             if et_show_diff and
             (
             (((accum total et_sum_amt[1]) - et_org_sum_amt[1]) <> 0 or
              ((accum total et_sum_amt[2]) - et_org_sum_amt[2]) <> 0 or
              ((accum total et_sum_amt[3]) - et_org_sum_amt[3]) <> 0 or
              ((accum total et_sum_amt[4]) - et_org_sum_amt[4]) <> 0 or
              ((accum total (et_base_amt -  et_base_applied)) -
                et_org_amt) <> 0 )
             )
             then do:

                                                                                                /* PUT DIFFERENCE TEXT "Conversion diff" */
          /*      put et_diff_txt to 26 ":" to 27
                /* DISPLAY DIFFRENCES */
                ((accum total et_sum_amt[1]) - et_org_sum_amt[1])
/*L02Q*         to 45 */
/*L02Q*/        to 48
                ((accum total et_sum_amt[2]) - et_org_sum_amt[2])
/*L02Q*         to 62 */
/*L02Q*/        to 65
                ((accum total et_sum_amt[3]) - et_org_sum_amt[3])
/*L02Q*         to 79 */
/*L02Q*/        to 82
                ((accum total et_sum_amt[4]) - et_org_sum_amt[4])
/*L02Q*         to 96 */
/*L02Q*/        to 99
                ((accum total (et_base_amt -  et_base_applied)) -
                   et_org_amt)
/*L02Q*         to 113. */
/*L02Q*/        to 116.*/
                down 1.
             end. /*IF et_show_diff */
/*L00S*END ADD*/

/*          end. DO WITH FRAME C */

          if page-size - line-counter < 9 then page.
          else down 2.

/*L00S*BEGIN DELETE*
 *        display
 *            "Invoices:" to 34           accum total (inv_tot) at 35
 *                                        format "->>>,>>>,>>>,>>9.99"
 *            "Dr/Cr Memos:" to 34        accum total (memo_tot) at 35
 *                                        format "->>>,>>>,>>>,>>9.99"
 *            "Finance Charges:" to 34    accum total (fc_tot) at 35
 *                                        format "->>>,>>>,>>>,>>9.99"
 *            "Unapplied Payments:" to 34 accum total (paid_tot) at 35
 *                                        format "->>>,>>>,>>>,>>9.99"
 *            "Drafts:" to 34             accum total (drft_tot) at 35
 *                                        format "->>>,>>>,>>>,>>9.99"
 *            (if base_rpt = ""
 *             then "Total Base Aging:"
 *             else " Total " + base_rpt + " Aging:")
 *                format "x(17)" to 34
 *                               accum total (base_amt - base_applied) at 35
 *                                        format "->>>,>>>,>>>,>>9.99"
 *****L00S*END DELETE*/

/*L00S*BEGIN ADD */

          /*DETERMINE ORIGINAL TOTALS, NOT YET CONVERTED*/
          assign
             et_org_inv_tot  = accum total inv_tot
             et_org_memo_tot = accum total memo_tot
             et_org_fc_tot   = accum total fc_tot
             et_org_paid_tot = accum total paid_tot
             et_org_drft_tot = accum total drft_tot
             et_org_curr_amt = accum total curr_amt
             et_org_amt      = accum total (base_amt - base_applied).

          /*CONVERT REPORT TOTAL AMOUNTS*/
/*L02Q*   {etrpconv.i et_org_inv_tot  et_org_inv_tot  } */
/*L02Q*   {etrpconv.i et_org_memo_tot et_org_memo_tot } */
/*L02Q*   {etrpconv.i et_org_fc_tot   et_org_fc_tot   } */
/*L02Q*   {etrpconv.i et_org_paid_tot et_org_paid_tot } */
/*L02Q*   {etrpconv.i et_org_drft_tot et_org_drft_tot } */
/*L02Q*   {etrpconv.i et_org_curr_amt et_org_curr_amt } */
/*L02Q*   {etrpconv.i et_org_amt      et_org_amt      } */

/*L02Q*/  if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_inv_tot,
                 input true, /* ROUND */
                 output et_org_inv_tot,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 2}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_memo_tot,
                 input true, /* ROUND */
                 output et_org_memo_tot,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 2}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_fc_tot,
                 input true, /* ROUND */
                 output et_org_fc_tot,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 2}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_paid_tot,
                 input true, /* ROUND */
                 output et_org_paid_tot,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 2}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_drft_tot,
                 input true, /* ROUND */
                 output et_org_drft_tot,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 2}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_curr_amt,
                 input true, /* ROUND */
                 output et_org_curr_amt,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 2}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_amt,
                 input true, /* ROUND */
                 output et_org_amt,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 2}
/*L02Q*/     end.
/*L02Q*/  end.  /* if et_report_curr <> mc-rpt-curr */

          et_diff_exist = no.

          if ((accum total et_inv_tot) - et_org_inv_tot)         <> 0 or
             ((accum total et_memo_tot) - et_org_memo_tot)       <> 0 or
             ((accum total et_fc_tot) - et_org_fc_tot)           <> 0 or
             ((accum total et_paid_tot) - et_org_paid_tot)       <> 0 or
             ((accum total et_drft_tot) - et_org_drft_tot)       <> 0 or
             ((accum total (et_base_amt - et_base_applied)) -
                                          et_org_amt)            <> 0 or
             ((accum total et_curr_amt) - et_org_curr_amt)       <> 0 or
             ((( accum total (et_curr_amt))
             -  (accum total (et_base_amt - et_base_applied))) -
              (et_org_curr_amt - et_org_amt))                      <> 0
              then assign et_diff_exist = true.

          /*    display
                 et_diff_txt
/*L02Q*          to 96 */
/*L02Q*/         to 95
                 when (et_diff_exist)
/*L02Q*          "Invoices:"           to 34 */
/*L02Q*/         {&arcsrp2a_p_9} to 34
                 accum total (et_inv_tot) at 35
                 format "->>>,>>>,>>>,>>9.99"
                 ((accum total et_inv_tot) - et_org_inv_tot)
/*L02Q*          at 75 */
/*L02Q*/         to 75
                 format "->>>,>>>,>>>,>>9.99"
/*L02Q*          "Dr/Cr Memos:"        to 34 */
/*L02Q*/         {&arcsrp2a_p_22} to 34
                 accum total (et_memo_tot) at 35
                 format "->>>,>>>,>>>,>>9.99"
                 ((accum total et_memo_tot) - et_org_memo_tot)
                 when (et_show_diff and et_diff_exist)
/*L02Q*          at 75 */
/*L02Q*/         to 75
                 format "->>>,>>>,>>>,>>9.99"
/*L02Q*          "Finance Charges:"    to 34 */
/*L02Q*/         {&arcsrp2a_p_3} to 34
                 accum total (et_fc_tot) at 35
                 format "->>>,>>>,>>>,>>9.99"
                 ((accum total et_fc_tot) - et_org_fc_tot)
                 when (et_show_diff and et_diff_exist)
/*L02Q*          at 75 */
/*L02Q*/         to 75
                 format "->>>,>>>,>>>,>>9.99"
/*L02Q*          "Unapplied Payments:" to 34 */
/*L02Q*/         {&arcsrp2a_p_34} to 34
                 accum total (et_paid_tot) at 35
                 format "->>>,>>>,>>>,>>9.99"
                 ((accum total et_paid_tot) - et_org_paid_tot)
                 when (et_show_diff and et_diff_exist)
/*L02Q*          at 75 */
/*L02Q*/         to 75
                 format "->>>,>>>,>>>,>>9.99"
/*L02Q*          "Drafts:"             to 34 */
/*L02Q*/         {&arcsrp2a_p_24} to 34
                 accum total (et_drft_tot) at 35
                 format "->>>,>>>,>>>,>>9.99"
                 ((accum total et_drft_tot) - et_org_drft_tot)
                 when (et_show_diff and et_diff_exist)
/*L02Q*          at 75 */
/*L02Q*/         to 75
                 format "->>>,>>>,>>>,>>9.99"
/*L02Q*          "Total " + et_disp_curr + fill(" ",4 - length(base_rpt)) */
/*L02Q*          + " Aging:" format "x(17)" to 34 */
/*L02Q*/         {&arcsrp2a_p_11} + et_report_curr + {&arcsrp2a_p_20}
/*L02Q*/         format "x(17)" to 34
                 accum total (et_base_amt - et_base_applied) at 35
                 format "->>>,>>>,>>>,>>9.99"
                 ((accum total (et_base_amt - et_base_applied)) -
                 et_org_amt) when (et_show_diff and et_diff_exist)
/*L02Q*          at 75  */
/*L02Q*/         to 75
                 format "->>>,>>>,>>>,>>9.99"

/*L00S*END ADD*/

              with frame d width 132 no-labels STREAM-IO /*GUI*/ . */

         /*     if base_rpt = "" then
                 display
                    {&arcsrp2a_p_14} + string(age_date) + {&arcsrp2a_p_8}
                    format "x(32)" to 34
/*L00S*             accum total (curr_amt) at 35 */
/*L00S*/            accum total (et_curr_amt) at 35
                    format "->>>,>>>,>>>,>>9.99"
/*L00S*/            ((accum total et_curr_amt) - et_org_curr_amt)
/*L00S*/            when (et_show_diff and et_diff_exist)
/*L02Q*             at 75 */
/*L02Q*/            to 75
/*L00S*/            format "->>>,>>>,>>>,>>9.99"
                    {&arcsrp2a_p_36} + string(age_date) + {&arcsrp2a_p_21}
                    format "x(29)" to 34
/*L00S*             (accum total (curr_amt)) -
 *L00S*             (accum total (base_amt - base_applied)) at 35 */
/*L00S*/            ((accum total (et_curr_amt)) -
/*L00S*/           (accum total (et_base_amt - et_base_applied)))
/*L00S*/           at 35 format "->>>,>>>,>>>,>>9.99"

/*L00S*/            ((( accum total (et_curr_amt))
/*L00S*/           -  (accum total (et_base_amt - et_base_applied))
/*L00S*/           ) -
/*L00S*/            (et_org_curr_amt - et_org_amt)
/*L00S*/             ) when (et_show_diff and et_diff_exist)
/*L02Q* /*L00S*/   at 75 */
/*L02Q*/           to 75
/*L00S*/           format "->>>,>>>,>>>,>>9.99"

                 with frame d width 132 no-labels STREAM-IO /*GUI*/ . */

/*L02Q       put skip(1)
/*L02Q*/             mc-curr-label at 3 et_report_curr skip
/*L02Q*/             mc-exch-label at 3 mc-exch-line1 skip
/*L02Q*/             mc-exch-line2 at 24 skip(1).*/  

                 hide frame phead1.
/*L02Q*          {wbrp04.i} */
