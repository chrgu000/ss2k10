/* arcsrp1a.p - AR AGING REPORT FROM DUE DATE SUBROUTINE                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=Report                                                  */
/*L02Q*/ /*V8:RunMode=Character,Windows                                  */
/* REVISION: 6.0      LAST MODIFIED: 08/30/90   BY: afs *D059*           */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: afs *D066*           */
/* REVISION: 6.0      LAST MODIFIED: 10/16/90   BY: afs *D101*           */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   by: afs *D283*           */
/* REVISION: 6.0      LAST MODIFIED: 03/30/91   by: bjb *D507*           */
/* REVISION: 6.0      LAST MODIFIED: 06/24/91   by: afs *D723*           */
/* REVISION: 6.0      LAST MODIFIED: 07/12/91   by: afs *D760*           */
/* REVISION: 7.0      LAST MODIFIED: 11/25/91   by: afs *F041*           */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   by: jjs *F237*           */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   by: tmd *F288*           */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   by: tjs *F337*           */
/*                                   05/12/92   by: jms *F481*           */
/*                                   06/18/92   by: jjs *F670*           */
/*                                   07/29/92   by: jms *F829*           */
/*                                   09/03/92   by: afs *G045*           */
/* REVISION: 7.3      LAST MODIFIED: 09/28/92   by: mpp *G476*           */
/*                                   10/13/94   by: str *FS40*           */
/*                                   12/29/94   by: str *F0C3*           */
/*                                   08/22/95   by: wjk *F0TH*           */
/*                                   01/31/96   by: mys *F0WY*           */
/* REVISION: 8.5      LAST MODIFIED: 12/08/95   BY: taf *J053*           */
/*                                   04/08/96   BY: jzw *G1P6*           */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*           */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   by: jzw *K00B*           */
/*                                   10/08/96   by: jzw *K00W*           */
/* REVISION: 8.6      LAST MODIFIED: 08/30/97   BY: *H1DT* Irine D'mello */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: bvm *K0PN*           */
/* REVISION: 8.6      LAST MODIFIED: 01/06/98   BY: *J295* Irine D'mello */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00M* D. Sidel      */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton  */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   BY: *K1SG* Ashok Swaminathan */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L02Q* Brenda Milton */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L059* Jean Miller   */
/* REVISION: 8.6E     LAST MODIFIED: 08/24/98   BY: *L079* Brenda Milton */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan             */
/* REVISION: 9.0      LAST MODIFIED: 08/08/05   BY: *SS - 20050808* Bill Jiang        */
/* SS - 20050808 - B */
{a6arcsrp01.i}

define input parameter cust like ar_bill.
define input parameter cust1 like ar_bill.
define input parameter cust_type like cm_type.
define input parameter cust_type1 like cm_type.
define input parameter due_date like ar_due_date.
define input parameter due_date1 like ar_due_date.
define input parameter nbr like ar_nbr.
define input parameter nbr1 like ar_nbr.
define input parameter slspsn like sp_addr.
define input parameter slspsn1 like slspsn.
define input parameter acct_type like ar_acct.
define input parameter acct_type1 like ar_acct.
define input parameter entity like gl_entity.
define input parameter entity1 like gl_entity.
define input parameter lstype like ls_type.

define input parameter age_date like ar_due_date.
define input parameter summary_only like mfc_logical.
define input parameter base_rpt like ar_curr.
define input parameter et_report_curr  like exr_curr1.
define input parameter show_po like mfc_logical.
define input parameter show_pay_detail like mfc_logical.
define input parameter show_comments like mfc_logical.
define input parameter deduct_contest like mfc_logical.
define input parameter mstr_lang like cd_lang.
define input parameter show_mstr_comments like mfc_logical.
define input parameter mstr_type like cd_type.

DEFINE VARIABLE aracct LIKE ar_acct.
DEFINE VARIABLE arcc LIKE ar_cc.
/*
define input parameter age_days1 as integer.
define input parameter age_days2 as integer.
define input parameter age_days3 as integer.
define input parameter age_days4 as integer.
define input parameter age_days5 as integer.
*/
/* SS - 20050808 - E */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arcsrp1a_p_1 "以基本货币计算的帐龄金额合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_2 "未指定用途的付款:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_3 "电话"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_4 "差异-"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_5 "参考    "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_6 "多个"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_7 "栏目天数"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_8 "汇票:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_9 " 帐龄:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_10 "帐龄日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_11 "Dn"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_12 "       合计金额 "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_13 "帐龄日为 "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_14 "借/贷项通知单:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_15 "-相对于基本货币:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_16 "帐龄日期   "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_17 "到期日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_18 " 客户合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_19 "联系人"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_20 "支付方式"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_21 "    超过"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_22 "基本货币客户合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_23 " 合计 "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_24 "基本货币报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_25 "      天   "
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_26 " 报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_27 "     至"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_28 " 兑换率的合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_29 "发票:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_30 "财务费用:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_31 "Lv"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_32 "客户"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_33 "  合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp1a_p_34 "报表"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*L02Q*  {wbrp02.i} */

         define variable rndmthd like rnd_rnd_mthd.
         define variable oldcurr like ar_curr.
         /* SS - 20050808 - B */
         /*
         define shared variable cust like ar_bill.
         define shared variable cust1 like ar_bill.
         define shared variable cust_type like cm_type.
         define shared variable cust_type1 like cm_type.
         define shared variable nbr like ar_nbr.
         define shared variable nbr1 like ar_nbr.
         define shared variable due_date like ar_due_date.
         define shared variable due_date1 like ar_due_date.
         define shared variable slspsn like sp_addr.
         define shared variable slspsn1 like slspsn.
         define shared variable acct_type like ar_acct.
         define shared variable acct_type1 like ar_acct.
         */
         /* SS - 20050808 - E */
         define shared variable name like ad_name.
         define shared variable age_days as integer extent 5
            label {&arcsrp1a_p_7}.
         define shared variable age_range as character extent 5
            format "x(15)".
         define shared variable i as integer.
         define shared variable age_amt like ar_amt
            format "->>>,>>>,>>9.99"
            extent 5.
         define shared variable age_period as integer.
         define shared variable cm_recno as recid.
         define shared variable balance like cm_balance.
         define shared variable age_paid like ar_amt extent 5.
         define shared variable sum_amt like ar_amt extent 5.
         /* SS - 20050808 - B */
         /*
         define shared variable show_pay_detail like mfc_logical.
         define shared variable summary_only like mfc_logical.
         define shared variable show_po like mfc_logical.
         */
         /* SS - 20050808 - E */
         define shared variable inv_tot like ar_amt.
         define shared variable memo_tot like ar_amt.
         define shared variable fc_tot like ar_amt.
         define shared variable paid_tot like ar_amt.
         define shared variable drft_tot like ar_amt.
         define shared variable base_amt like ar_amt.
         define shared variable base_applied like ar_applied.
         /* SS - 20050808 - B */
         /*
         define shared variable base_rpt like ar_curr.
         define shared variable age_date like ar_due_date label {&arcsrp1a_p_10}
            initial today.
         */
         /* SS - 20050808 - E */
         define shared variable due-date like ar_date.
         define shared variable applied-amt like ar_applied.
         define shared variable amt-due like ar_amt.
         define shared variable this-applied like ar_applied.
         define shared variable multi-due like mfc_logical.
         /* SS - 20050808 - B */
         /*
         define shared variable deduct_contest like mfc_logical.
         */
         /* SS - 20050808 - E */
         define shared variable curr_amt like ar_amt.
         /* SS - 20050808 - B */
         /*
         define shared variable show_comments like mfc_logical.
         define shared variable show_mstr_comments like mfc_logical.
         define shared variable mstr_type like cd_type initial "AR".
         define shared variable mstr_lang like cd_lang.
         */
         /* SS - 20050808 - E */
         define variable new_cust as logical initial true.
         define variable use_rec as logical initial false.
         define variable rec_printed as logical initial false.
         /* SS - 20050808 - B */
         /*
         define shared variable entity like gl_entity.
         define shared variable entity1 like gl_entity.
         define shared variable lstype like ls_type.
         */
         /* SS - 20050808 - E */
         define buffer payment for ar_mstr.
         define buffer armstr for ar_mstr.
         define variable u_amt like base_amt.
         define variable u_applied like base_amt.
/*L02Q*  define variable exdrate like exd_rate. */
/*L02Q*/ define variable exdrate like exr_rate no-undo.
/*L02Q* /*L00Y*/ define variable exdrate2 like exd_rate. */
/*L02Q*/ define variable exdrate2 like exr_rate no-undo.
/*L02Q*/ define variable exdratetype like exr_ratetype no-undo.
         define variable tempstr as character format "x(25)".
         define variable high_dun_level like ar_dun_level.
         define variable disp_dun_level like ar_dun_level format ">>" no-undo.
         define variable total-amt like ar_amt no-undo.
/*L02Q*/ define shared variable mc-rpt-curr like ar_curr no-undo.

/*L00M*BEGIN ADDED SECTION*/
/* SS - 20050808 - B */
/*
         {etrpvar.i }
             */
             {a6etrpvar.i }
             /* SS - 20050808 - E */
         {etvar.i   }
         define variable et_age_amt          like age_amt extent 5.
         define variable et_age_paid         like ar_amt extent 5.
         define variable et_sum_amt          like ar_amt extent 5.
         define variable et_base_amt         like ar_amt.
         define variable et_base_applied     like ar_amt.
         define variable et_curr_amt         like ar_amt.
         define variable et_inv_tot          like ar_amt.
         define variable et_memo_tot         like ar_amt.
         define variable et_fc_tot           like ar_amt.
         define variable et_paid_tot         like ar_amt.
         define variable et_drft_tot         like ar_amt.
         define variable et_org_sum_amt      like ar_amt extent 5.
         define variable et_org_base_amt     like ar_amt.
         define variable et_org_base_applied like ar_amt.
         define variable et_org_curr_amt     like ar_amt.
         define variable et_org_inv_tot      like ar_amt.
         define variable et_org_memo_tot     like ar_amt.
         define variable et_org_fc_tot       like ar_amt.
         define variable et_org_paid_tot     like ar_amt.
         define variable et_org_amt          like ar_amt.
         define variable et_org_drft_tot     like ar_amt.
/*L02Q*  define shared variable display_curr like base_rpt no-undo. */
         define variable et_diff_exist    like mfc_logical initial false.
/*L00M*END ADDED SECTION*/

         /* SS - 20050808 - B */
         /*
         {mfphead.i}
             */
             /* SS - 20050808 - E */

         find first gl_ctrl no-lock. /*for rounding after
                                       currency conversion*/

         /* CREATE REPORT HEADER */
         do i = 1 to 4:
            age_range[i] = {&arcsrp1a_p_27}  + string(age_days[i],"->>>9") .
         end.
         age_range[5] = {&arcsrp1a_p_21} + string(age_days[4],"->>>9") .

         /* SS - 20050808 - B */
         /*
         form
            header
            {&arcsrp1a_p_16}  at 1
            age_date       skip
            space (29)
            {&arcsrp1a_p_11} /* FOR DUNNING LEVEL */
            age_range[1 for 5]  skip
            {&arcsrp1a_p_5}
            "T"
            {&arcsrp1a_p_17}
            {&arcsrp1a_p_20}
            {&arcsrp1a_p_31} /* FOR DUNNING LEVEL */
            {&arcsrp1a_p_25}
            {&arcsrp1a_p_25}
            {&arcsrp1a_p_25}
            {&arcsrp1a_p_25}
            {&arcsrp1a_p_25}
            {&arcsrp1a_p_12} skip
            "--------"
            "-"
            "--------"
            "--------"
            "--" /* FOR DUNNING LEVEL */
            "---------------"
            "---------------"
            "---------------"
            "---------------"
            "---------------"
            "----------------" skip
         with frame phead1 width 132 page-top no-attr-space.
         view frame phead1.
         */
         OUTPUT TO "a6arcsrp1a".
         /* SS - 20050808 - E */

         oldcurr = "".
         do with frame c down no-box:

            for each cm_mstr where (cm_addr >= cust) and (cm_addr <= cust1)
            and (cm_type >= cust_type) and (cm_type <= cust_type1)
            no-lock by cm_sort:

               high_dun_level = 0.

               /* MODIFIED THE SELECTION CRITERIA OF THE FOR EACH ar_mstr */
               /* LOOP TO INCLUDE ALL THE 4 SALESPERSONS                  */

               for each ar_mstr where (ar_bill = cm_addr)
                    and (ar_nbr >= nbr) and (ar_nbr <= nbr1)
                    and ((ar_slspsn[1] >= slspsn and ar_slspsn[1] <= slspsn1)
                    or   (ar_slspsn[2] >= slspsn and ar_slspsn[2] <= slspsn1)
                    or   (ar_slspsn[3] >= slspsn and ar_slspsn[3] <= slspsn1)
                    or   (ar_slspsn[4] >= slspsn and ar_slspsn[4] <= slspsn1))
                    and (ar_type = "P" or
                    (ar_entity >= entity and ar_entity <= entity1))
                    and (ar_amt - ar_applied <> 0)
                    and (ar_type = "P" or ar_due_date = ?
                    or (ar_due_date >= due_date and ar_due_date <= due_date1))
                    and (not ar_type = "D" or ar_draft = true)
                    and ((ar_curr = base_rpt)
                    or  (base_rpt = ""))
                    and ((deduct_contest and ar_contested = no)
                    or (not deduct_contest))
                    no-lock break by ar_bill by ar_nbr with frame c
               width 132 no-labels:

                  if lstype = "" or
                  (lstype <> "" and can-find(first ls_mstr
                  where ls_type = lstype and ls_addr = cm_addr)) then do:
/*L02Q* /*K1SG*/     if c-application-mode = 'web':u then put skip. */
                     if (oldcurr <> ar_curr)  or (oldcurr = "") then do:
/*L02Q*              {gpcurmth.i */
/*L02Q*                    "ar_curr" */
/*L02Q*                    "4" */
/*L02Q*                    "leave" */
/*L02Q*                    "pause 0" } */
/*L02Q*/             /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L02Q*/             {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                       "(input ar_curr,
                         output rndmthd,
                         output mc-error-number)"}
/*L02Q*/             if mc-error-number <> 0 then do:
/*L02Q*/                {mfmsg.i mc-error-number 4}
/*L02Q*/                pause 0.
/*L02Q*/                leave.
/*L02Q*/             end.
                     oldcurr = ar_curr.
                  end.  /* if lstype = "" or ... */

                  /* Store first customer information in a logical, since */
                  /* The account validation may cause the actual first    */
                  /* Record to be skipped.                                */
                  if first-of(ar_bill) then new_cust = true.

                  /* Validate the AR account (if range specified) */
                  use_rec = true.
                  if (acct_type <> "" or acct_type1 <> hi_char) or
                     (entity <> "" or entity1 <> hi_char) then do:

                     if ar_type <> "P" then do:
                        if (ar_acct < acct_type or ar_acct > acct_type1) then
                           use_rec = false.
                        /* SS - 20050808 - B */
                        if (ar_acct < acct_type or ar_acct > acct_type1) THEN DO:
                            aracct = ar_acct.
                            arcc = ar_cc.
                        END.
                        /* SS - 20050808 - E */
                     end.
                     else do: /* Payments: if unapplied, get the detail to
                                 determine the application account */
                        use_rec = false.
                        u_amt = 0.
                        u_applied = 0.
                        for each ard_det where ard_nbr = ar_nbr
                                   and ard_type = "U"
                                   and ard_ref = ""
                                   no-lock:
                           if ard_acct >= acct_type and ard_acct <= acct_type1
                              and ard_entity >= entity and ard_entity <= entity1
                              then do:
                                 use_rec = true.
                                 u_amt = u_amt - ard_amt.
                                 /* SS - 20050808 - B */
                                 aracct = ard_acct.
                                 arcc = ard_cc.
                                 /* SS - 20050808 - E */
                              end.
                           end.
                           for each armstr where
                                 armstr.ar_check = ar_mstr.ar_check and
                                 armstr.ar_bill = ar_mstr.ar_bill and
                                 armstr.ar_type = "A" no-lock:
                              for each ard_det where ard_nbr  = armstr.ar_nbr
                              no-lock:
                                 u_applied = u_applied - ard_amt.
                              end.
                           end.

                        end.  /* for each ard_det */
                     end.  /* else do */
                     else if ar_type = "P" then do:
                        u_amt = ar_amt.
                        u_applied = ar_applied.
                        /* SS - 20050808 - B */
                        FOR EACH ard_det
                            WHERE ard_nbr = ar_nbr
                            AND ard_type = "U"
                            AND ard_ref = ""
                            NO-LOCK:
                            aracct = ard_acct.
                            arcc = ard_cc.
                        END.
                        /* SS - 20050808 - E */
                     end.
                     /* SS - 20050808 - B */
                     ELSE DO:
                         aracct = ar_acct.
                         arcc = ar_cc.
                     END.
                     /* SS - 20050808 - E */

                     if use_rec then do:

                        form
                           ar_nbr format "x(8)"
                           ar_type
                           ar_due_date
                           ar_cr_terms
                           ar_dun_level format ">>"
/*L00M*                    age_amt */
/*L00M*/                   et_age_amt
                           ar_amt
                        with frame c
                        width 132.

                        do i = 1 to 5:
 /*L00M*/                  et_age_amt[i] = 0.
 /*L00M*/                  et_age_paid[i] = 0.
 /*L00M*/                  et_sum_amt[i] = 0.
                           age_amt[i] = 0.
                           age_paid[i] = 0.
                           sum_amt[i] = 0.
                        end.

                        if new_cust then do:
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
                                   ad_state
                                   cm_pay_date
                                   ad_attn label {&arcsrp1a_p_19}
                                   ad_phone label {&arcsrp1a_p_3}
                                   ad_ext no-label
                           with frame b side-labels width 132.
                           if show_mstr_comments then do:
                              {gpcdprt.i &type = mstr_type &ref = cm_addr
                                         &lang = mstr_lang &pos = 10}
                           end.
                        end.  /* if new_cust */

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
/*L02Q*                    base_amt = base_amt / ar_ex_rate. */
                           /* ROUND PER BASE ROUND METHOD */
/*L02Q*                    {gprun.i ""gpcurrnd.p"" "(input-output base_amt, */
/*L02Q*                                              input gl_rnd_mthd)"}   */
/*L02Q*                    base_applied = base_applied / ar_ex_rate. */
                           /* ROUND PER BASE ROUND METHOD */
/*L02Q*                    {gprun.i ""gpcurrnd.p"" */
/*L02Q*                      "(input-output base_applied, */
/*L02Q*                        input gl_rnd_mthd"} */

/*L02Q*/                   assign
/*L02Q*/                      base_amt = ar_base_amt
/*L02Q*/                      base_applied = ar_base_applied.

/*L02Q*                    {gpgtex8.i &ent_curr = base_curr */
/*L02Q*                               &curr = ar_curr */
/*L02Q*                               &date = age_date */
/*L02Q*                               &exch_from = exd_rate */
/*L02Q*                               &exch_to = exdrate} */

/*L02Q*/                   /* GET EXCHANGE RATE */
/*L079*/                   /* REVERSED AR_CURR AND BASE_CURR BELOW */
/*L02Q*/                   {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                             "(input ar_curr,
                               input base_curr,
                               input exdratetype,
                               input age_date,
                               output exdrate,
                               output exdrate2,
                               output mc-error-number)"}
/*L02Q*/                   if mc-error-number <> 0 then do:
/*L02Q*/                      {mfmsg.i mc-error-number 2}
/*L02Q*/                   end.
/*L02Q*                    if available exd_det then */
/*L02Q*                       curr_amt = curr_amt / exdrate. */
/*L02Q*/                   if mc-error-number = 0 then do:
/*L079*/                   /* REVERSED AR_CURR AND BASE_CURR BELOW */
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input ar_curr,
                                  input base_curr,
                                  input exdrate,
                                  input exdrate2,
                                  input curr_amt,
                                  input true,  /* ROUND */
                                  output curr_amt,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
/*L02Q*/                   end.  /* if mc-error-number = 0 */
                           /* If no exchange rate for today, use the */
                           /* invoice rate */
                           else
/*L02Q*/                   do:
/*L02Q*                       curr_amt = curr_amt / ar_ex_rate. */
/*L02Q*/                      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input ar_curr,
                                  input base_curr,
                                  input ar_ex_rate,
                                  input ar_ex_rate2,
                                  input curr_amt,
                                  input true, /* ROUND */
                                  output curr_amt,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
                           end.  /* else do */

                           /* ROUND PER BASE ROUND METHOD */
/*L02Q*                    {gprun.i ""gpcurrnd.p"" "(input-output curr_amt,*/
/*L02Q*                                                 input gl_rnd_mthd)"} */
                        end.  /* if base_rpt = "" and ar_curr <> base_curr */
                        multi-due = no.

                        /*CHECK FOR CREDIT DATING TERMS */
                        find ct_mstr where ct_code = ar_cr_terms
                        no-lock no-error.
                        if available ct_mstr and ct_dating = yes then do:
                           multi-due = yes.
                           applied-amt = base_applied.
                           total-amt = 0.
                           for each ctd_det where ctd_code = ar_cr_terms no-lock
                           break by ctd_code:
                              find ct_mstr where ct_code = ctd_date_cd no-lock
                              no-error.
                              if available ct_mstr then do:
                                 if (ct_due_inv = 1) then
                                    due-date  = ar_date + ct_due_days.
                                 else    /* FROM END OF MONTH */
                                    due-date = date((month(ar_date) + 1) mod 12
                                               + if month(ar_date) = 11 then 12
                                               else 0, 1, year(ar_date)
                                               + if month(ar_date) >= 12 then 1
                                               else 0) + integer(ct_due_days)
                                               - if ct_due_days <> 0 then 1
                                               else 0.
                                 if ct_due_date <> ? then
                                    due-date = ct_due_date.

                                 /*CALCULATE AMT-DUE LESS THE APPLIED
                                   FOR THIS SEGMENT*/

                                 /* TO PREVENT ROUNDING ERRORS ASSIGN LAST   */
                                 /* BUCKET = ROUNDED TOTAL - RUNNING TOTAL */
                                 if last-of(ctd_code) then
                                    amt-due = base_amt - total-amt.
                                 else
                                    amt-due = base_amt * (ctd_pct_due / 100).
                                 if base_rpt = ""
                                 and ar_curr <> base_curr
                                 then do:
                                    /* ROUND PER BASE ROUND METHOD */
/*L02Q*                             {gprun.i ""gpcurrnd.p"" */
/*L02Q*                                        "(input-output amt-due, */
/*L02Q*                                          input gl_rnd_mthd)"} */
/*L02Q*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                      "(input-output amt-due,
                                        input gl_rnd_mthd,
                                        output mc-error-number)"}
/*L02Q*/                            if mc-error-number <> 0 then do:
/*L02Q*/                               {mfmsg.i mc-error-number 2}
/*L02Q*/                            end.
                                 end.
                                 else do:
                                    /* ROUND PER AR_CURR ROUND METHOD */
/*L02Q*                             {gprun.i ""gpcurrnd.p"" */
/*L02Q*                                        "(input-output amt-due, */
/*L02Q*                                          input rndmthd)"} */
/*L02Q*/                            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                      "(input-output amt-due,
                                        input rndmthd,
                                        output mc-error-number)"}
/*L02Q*/                            if mc-error-number <> 0 then do:
/*L02Q*/                               {mfmsg.i mc-error-number 2}
/*L02Q*/                            end.
                                 end.
                                 total-amt = total-amt + amt-due.
                                 if ar_amt >= 0 then
                                    this-applied = min(amt-due, applied-amt).
                                 else this-applied = max(amt-due, applied-amt).
                                 applied-amt = applied-amt - this-applied.

                                 age_period = 5.
                                 do i = 1 to 5:
                                    if (age_date - age_days[i]) <= due-date then
                                       age_period = i.
                                    if age_period <> 5 then leave.
                                 end.
                                 if due-date = ? then age_period = 1.

                                 age_amt[age_period] = age_amt[age_period]
                                                       + amt-due.
                                 if not show_pay_detail then
                                    age_amt[age_period] = age_amt[age_period]
                                                          - this-applied.
                                 sum_amt[age_period] = sum_amt[age_period]
                                                       + amt-due - this-applied.
                                 age_paid[age_period] =
                                    age_paid[age_period] + this-applied.
                              end. /*if avail ct_mstr*/
                              if ctd_pct_due = 100 then leave.
                           end. /*for each ctd_det*/
                        end. /*if available ct_mstr &  ct_dating = yes*/
                        else do:
                           age_period = 5.
                           do i = 1 to 5:
                              if (age_date - age_days[i]) <= ar_due_date
                                 then age_period = i.
                              if age_period <> 5 then leave.
                           end.
                           if ar_due_date = ? then age_period = 1.
                           if not show_pay_detail or ar_type = "P"
                             then age_amt[age_period] = base_amt - base_applied.
                           else age_amt[age_period] = base_amt.
                           age_paid[age_period] = base_applied * (-1).
                           sum_amt[age_period] = base_amt - base_applied.
                        end.  /* CREDIT/DATING BLOCK */

                        if summary_only = no then do with frame c:
                           if new_cust then down 1.
                           if ar_type <> "P" then display ar_nbr ar_type.
                           else display ar_check @ ar_nbr "U" @ ar_type.
                           if multi-due = no then display ar_due_date.
                           else display {&arcsrp1a_p_6} @ ar_due_date.
                           display ar_cr_terms
                                   ar_dun_level.
                           /* SS - 20050808 - B */
                           CREATE tta6arcsrp01.
                           ASSIGN
                               tta6arcsrp01_bill = ar_bill
                               tta6arcsrp01_acct = aracct
                               tta6arcsrp01_cc = arcc
                               .
                           IF ar_type <> "P" THEN DO:
                               ASSIGN
                                   tta6arcsrp01_nbr = ar_nbr
                                   tta6arcsrp01_type = ar_type
                                   .
                           END.
                           ELSE DO:
                               ASSIGN
                                   tta6arcsrp01_nbr = ar_check
                                   tta6arcsrp01_type = "U"
                                   .
                           END.
                           IF multi-due = NO THEN DO:
                               tta6arcsrp01_due_date = ar_due_date.
                           END.
                           /* SS - 20050808 - E */
                        end.
                        else
                           /* SAVE HIGHEST DUNNING LEVEL FOR THIS CUSTOMER */
                           if ar_dun_level > high_dun_level then
                              high_dun_level = ar_dun_level.

                           if ar_type = "I" then inv_tot =
                              base_amt - base_applied.
                           else inv_tot = 0.
                           if ar_type = "M" then memo_tot =
                              base_amt - base_applied.
                           else memo_tot = 0.
                           if ar_type = "F" then fc_tot =
                              base_amt - base_applied.
                           else fc_tot = 0.
                           if ar_type = "D" then drft_tot =
                              base_amt - base_applied.
                           else drft_tot = 0.
                           if ar_type = "P" then paid_tot =
                              base_amt - base_applied.
                           else paid_tot = 0.

/*L00M*BEGIN ADDED SECTION*/
/*L02Q*                    {etrpconv.i sum_amt[1] et_sum_amt[1]} */
/*L02Q*                    {etrpconv.i sum_amt[2] et_sum_amt[2]} */
/*L02Q*                    {etrpconv.i sum_amt[3] et_sum_amt[3]} */
/*L02Q*                    {etrpconv.i sum_amt[4] et_sum_amt[4]} */
/*L02Q*                    {etrpconv.i sum_amt[5] et_sum_amt[5]} */
/*L02Q*                    {etrpconv.i age_amt[1] et_age_amt[1]} */
/*L02Q*                    {etrpconv.i age_amt[2] et_age_amt[2]} */
/*L02Q*                    {etrpconv.i age_amt[3] et_age_amt[3]} */
/*L02Q*                    {etrpconv.i age_amt[4] et_age_amt[4]} */
/*L02Q*                    {etrpconv.i age_amt[5] et_age_amt[5]} */
/*L02Q*                    {etrpconv.i age_paid[1] et_age_paid[1]} */
/*L02Q*                    {etrpconv.i age_paid[2] et_age_paid[2]} */
/*L02Q*                    {etrpconv.i age_paid[3] et_age_paid[3]} */
/*L02Q*                    {etrpconv.i age_paid[4] et_age_paid[4]} */
/*L02Q*                    {etrpconv.i age_paid[5] et_age_paid[5]} */
/*L02Q*                    {etrpconv.i base_amt et_base_amt} */
/*L02Q*                    {etrpconv.i base_applied et_base_applied} */
/*L02Q*                    {etrpconv.i inv_tot et_inv_tot} */
/*L02Q*                    {etrpconv.i memo_tot et_memo_tot} */
/*L02Q*                    {etrpconv.i fc_tot et_fc_tot} */
/*L02Q*                    {etrpconv.i paid_tot et_paid_tot} */
/*L02Q*                    {etrpconv.i drft_tot et_drft_tot} */
/*L02Q*                    {etrpconv.i curr_amt et_curr_amt} */
/*L00M*END ADDED SECTION*/

/*L02Q*/                   do i = 1 to 5:
/*L02Q*/                      if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/                         {gprunp.i "mcpl" "p" "mc-curr-conv"
                                   "(input mc-rpt-curr,
                                     input et_report_curr,
                                     input et_rate1,
                                     input et_rate2,
                                     input sum_amt[i],
                                     input true, /* ROUND */
                                     output et_sum_amt[i],
                                     output mc-error-number)"}
/*L02Q*/                         if mc-error-number <> 0 then do:
/*L02Q*/                            {mfmsg.i mc-error-number 2}
/*L02Q*/                         end.
/*L02Q*/                         {gprunp.i "mcpl" "p" "mc-curr-conv"
                                   "(input mc-rpt-curr,
                                     input et_report_curr,
                                     input et_rate1,
                                     input et_rate2,
                                     input age_amt[i],
                                     input true, /* ROUND */
                                     output et_age_amt[i],
                                     output mc-error-number)"}
/*L02Q*/                         if mc-error-number <> 0 then do:
/*L02Q*/                            {mfmsg.i mc-error-number 2}
/*L02Q*/                         end.
/*L02Q*/                         {gprunp.i "mcpl" "p" "mc-curr-conv"
                                   "(input mc-rpt-curr,
                                     input et_report_curr,
                                     input et_rate1,
                                     input et_rate2,
                                     input age_paid[i],
                                     input true, /* ROUND */
                                     output et_age_paid[i],
                                     output mc-error-number)"}
/*L02Q*/                         if mc-error-number <> 0 then do:
/*L02Q*/                            {mfmsg.i mc-error-number 2}
/*L02Q*/                         end.
/*L02Q*/                      end.  /* if et_report_curr <> mc-rpt-curr */
/*L02Q*/                      else assign
/*L02Q*/                         et_sum_amt[i] = sum_amt[i]
/*L02Q*/                         et_age_amt[i] = age_amt[i]
/*L02Q*/                         et_age_paid[i] = age_paid[i].
/*L02Q*/                   end.  /* do i = 1 to 5 */

/*L02Q*/                   if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input mc-rpt-curr,
                                  input et_report_curr,
                                  input et_rate1,
                                  input et_rate2,
                                  input base_amt,
                                  input true,  /* ROUND */
                                  output et_base_amt,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input mc-rpt-curr,
                                  input et_report_curr,
                                  input et_rate1,
                                  input et_rate2,
                                  input base_applied,
                                  input true,  /* ROUND */
                                  output et_base_applied,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input mc-rpt-curr,
                                  input et_report_curr,
                                  input et_rate1,
                                  input et_rate2,
                                  input inv_tot,
                                  input true,  /* ROUND */
                                  output et_inv_tot,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input mc-rpt-curr,
                                  input et_report_curr,
                                  input et_rate1,
                                  input et_rate2,
                                  input memo_tot,
                                  input true,  /* ROUND */
                                  output et_memo_tot,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input mc-rpt-curr,
                                  input et_report_curr,
                                  input et_rate1,
                                  input et_rate2,
                                  input fc_tot,
                                  input true,  /* ROUND */
                                  output et_fc_tot,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input mc-rpt-curr,
                                  input et_report_curr,
                                  input et_rate1,
                                  input et_rate2,
                                  input paid_tot,
                                  input true,  /* ROUND */
                                  output et_paid_tot,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input mc-rpt-curr,
                                  input et_report_curr,
                                  input et_rate1,
                                  input et_rate2,
                                  input drft_tot,
                                  input true,  /* ROUND */
                                  output et_drft_tot,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input mc-rpt-curr,
                                  input et_report_curr,
                                  input et_rate1,
                                  input et_rate2,
                                  input curr_amt,
                                  input true,  /* ROUND */
                                  output et_curr_amt,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
/*L02Q*/                   end.  /* if et_report_curr <> mc-rpt-curr */
/*L02Q*/                   else assign
/*L02Q*/                      et_base_amt = base_amt
/*L02Q*/                      et_base_applied = base_applied
/*L02Q*/                      et_inv_tot = inv_tot
/*L02Q*/                      et_memo_tot = memo_tot
/*L02Q*/                      et_fc_tot = fc_tot
/*L02Q*/                      et_paid_tot = paid_tot
/*L02Q*/                      et_drft_tot = drft_tot
/*L02Q*/                      et_curr_amt = curr_amt.


                           accumulate et_sum_amt (total by ar_bill).
                           accumulate et_base_amt - et_base_applied
                              (total by ar_bill).
                           accumulate et_inv_tot  (total).
                           accumulate et_memo_tot (total).
                           accumulate et_fc_tot   (total).
                           accumulate et_paid_tot (total).
                           accumulate et_drft_tot (total).
                           accumulate et_curr_amt (total).

                           accumulate sum_amt (total by ar_bill).
                           accumulate base_amt - base_applied
                              (total by ar_bill).
                           accumulate inv_tot (total).
                           accumulate memo_tot (total).
                           accumulate fc_tot (total).
                           accumulate drft_tot (total).
                           accumulate paid_tot (total).
                           accumulate curr_amt (total).

                           if summary_only = no then do with frame c:
                              if not show_pay_detail or ar_type = "P" then do:
/*L00M*                          display age_amt[1 for 5] */
/*L00M*/                         display et_age_amt[1 for 5]
/*L00M*                            (base_amt - base_applied) @ ar_amt. */
/*L00M*/                           (et_base_amt - et_base_applied) @ ar_amt.
                                 down 1.
                                 /* SS - 20050808 - B */
                                 ASSIGN
                                     tta6arcsrp01_amt1 = et_age_amt[1]
                                     tta6arcsrp01_amt2 = et_age_amt[2]
                                     tta6arcsrp01_amt3 = et_age_amt[3]
                                     tta6arcsrp01_amt4 = et_age_amt[4]
                                     tta6arcsrp01_amt5 = et_age_amt[5]
                                     tta6arcsrp01_amt = (et_base_amt - et_base_applied)
                                     .
                                 /* SS - 20050808 - E */
                              end.
                              else do:
                                 display
/*L00M*                             age_amt[1 for 5]       */
/*L00M*/                            et_age_amt[1 for 5]
/*L00M*                             base_amt @ ar_amt.     */
/*L00M*/                            et_base_amt @ ar_amt.
                                 down 1.
                                 if base_applied <> 0 then do:
/*L00M*BEGIN DELETE*
*                                   display age_paid[1] @ age_amt[1]
*                                      age_paid[2] @ age_amt[2]
*                                      age_paid[3] @ age_amt[3]
*                                      age_paid[4] @ age_amt[4]
*                                      age_paid[5] @ age_amt[5]
*                                      base_applied * (-1) @ ar_amt.
*END DELETE*/

/*L00M*BEGIN ADD */
                                    display et_age_paid[1] @ et_age_amt[1]
                                       et_age_paid[2] @ et_age_amt[2]
                                       et_age_paid[3] @ et_age_amt[3]
                                       et_age_paid[4] @ et_age_amt[4]
                                       et_age_paid[5] @ et_age_amt[5]
                                       et_base_applied * (-1) @ ar_amt.
/*L00M*END ADD*/
                                    down 1.
                                    /* Show payment detail */
                                    for each ard_det where ard_ref = ar_nbr
                                    no-lock
                                    with frame c:
                                       find payment where
                                       payment.ar_nbr = ard_nbr
                                       no-lock no-error.
                                       if available payment then do:
                                          display payment.ar_type
                                             @ ar_mstr.ar_type
                                             payment.ar_effdate
                                             @ ar_mstr.ar_due_date
                                             payment.ar_check
                                             @ ar_mstr.ar_cr_terms.
                                          down 1.
                                       end.
                                    end.
                                 end.  /* if base_applied <> 0 */
                              end.  /* else do */
                              if show_po and ar_po <> "" then put ar_po at 10.
                              if ar_contested then put "contested" to 131.
                              /* Display document comments */
                              if show_comments and ar_cmtindx <> 0 then do:
                                 {arcscmt.i &cmtindx = ar_cmtindx
                                   &subhead = "ar_nbr format ""X(8)"" " }
                              end.
                           end.  /* if summary_only = no */
                        end.  /* use_rec block */

                        /* Customer totals */
                        if last-of(ar_bill) and rec_printed then do
                        with frame c:
                           rec_printed = false.
                           if summary_only = no then do:
                              if page-size - line-counter < 2 then page.
                              underline
/*L00M*                          age_amt */
/*L00M*/                         et_age_amt
                                 ar_amt.
                           end.
/*L02Q* /*L00M*/           display  "     "  + et_disp_curr   @ ar_nbr */
/*L02Q*/                   display  "     "  + et_report_curr @ ar_nbr
/*L059* /*L00M*/           "Customer" @ ar_due_date "Totals:" @ ar_cr_terms */
/*L059*/                   {&arcsrp1a_p_32} @ ar_due_date
/*L059*/                   {&arcsrp1a_p_33} @ ar_cr_terms

/*L00M*BEGIN ADD */
                              accum total by ar_bill (et_sum_amt[1])
                              @ et_age_amt[1]
                              accum total by ar_bill (et_sum_amt[2])
                              @ et_age_amt[2]
                              accum total by ar_bill (et_sum_amt[3])
                              @ et_age_amt[3]
                              accum total by ar_bill (et_sum_amt[4])
                              @ et_age_amt[4]
                              accum total by ar_bill (et_sum_amt[5])
                              @ et_age_amt[5]
                              accum total by ar_bill
                                 (et_base_amt - et_base_applied)
                              @ ar_amt.
                           down 1.

                           /*DETERMINE ORIGINAL TOTALS, NOT YET CONVERTED*/
                           assign
                              et_org_sum_amt[1] = accum total by ar_bill
                                 sum_amt[1]
                              et_org_sum_amt[2] = accum total by ar_bill
                                 sum_amt[2]
                              et_org_sum_amt[3] = accum total by ar_bill
                                 sum_amt[3]
                              et_org_sum_amt[4] = accum total by ar_bill
                                 sum_amt[4]
                              et_org_sum_amt[5] = accum total by ar_bill
                                 sum_amt[5]
                              et_org_amt= accum total by ar_bill (base_amt -
                                 base_applied).

                           /*CONVERT AMOUNTS*/
/*L02Q*                    {etrpconv.i et_org_sum_amt[1] et_org_sum_amt[1]} */
/*L02Q*                    {etrpconv.i et_org_sum_amt[2] et_org_sum_amt[2]} */
/*L02Q*                    {etrpconv.i et_org_sum_amt[3] et_org_sum_amt[3]} */
/*L02Q*                    {etrpconv.i et_org_sum_amt[4] et_org_sum_amt[4]} */
/*L02Q*                    {etrpconv.i et_org_sum_amt[5] et_org_sum_amt[5]} */
/*L02Q*                    {etrpconv.i et_org_amt        et_org_amt       } */

/*L02Q*/                   if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/                      do i = 1 to 5:
/*L02Q*/                         {gprunp.i "mcpl" "p" "mc-curr-conv"
                                   "(input mc-rpt-curr,
                                     input et_report_curr,
                                     input et_rate1,
                                     input et_rate2,
                                     input et_org_sum_amt[i],
                                     input true,  /* ROUND */
                                     output et_org_sum_amt[i],
                                     output mc-error-number)"}
/*L02Q*/                         if mc-error-number <> 0 then do:
/*L02Q*/                            {mfmsg.i mc-error-number 2}
/*L02Q*/                         end.
/*L02Q*/                      end.  /* do i = 1 to 5 */
/*L02Q*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                "(input mc-rpt-curr,
                                  input et_report_curr,
                                  input et_rate1,
                                  input et_rate2,
                                  input et_org_amt,
                                  input true,  /* ROUND */
                                  output et_org_amt,
                                  output mc-error-number)"}
/*L02Q*/                      if mc-error-number <> 0 then do:
/*L02Q*/                         {mfmsg.i mc-error-number 2}
/*L02Q*/                      end.
/*L02Q*/                   end.  /* if et_report_curr <> mc-rpt-curr */

                           /*L00M*AMOUNT MUST BE <> 0*/
                           if et_show_diff and
                           ((((accum total by ar_bill et_sum_amt[1]) -
                               et_org_sum_amt[1]) <> 0) or
                           (((accum total by ar_bill et_sum_amt[2]) -
                               et_org_sum_amt[2]) <> 0) or
                           (((accum total by ar_bill et_sum_amt[3]) -
                               et_org_sum_amt[3]) <> 0) or
                           (((accum total by ar_bill et_sum_amt[4]) -
                               et_org_sum_amt[4]) <> 0)
                           )
                           then
                              /* DISPLAY DIFFRENCCES IF <> 0*/
                              put et_diff_txt to 21 ":" to 27
                                 ((accum total by ar_bill et_sum_amt[1]) -
                                     et_org_sum_amt[1])
/*L02Q*                              to 45 */
/*L02Q*/                             to 47
                                 ((accum total by ar_bill et_sum_amt[2]) -
                                     et_org_sum_amt[2])
/*L02Q*                              to 62 */
/*L02Q*/                             to 63
                                 ((accum total by ar_bill et_sum_amt[3]) -
                                     et_org_sum_amt[3])
                                     to 79
                                 ((accum total by ar_bill et_sum_amt[4]) -
                                     et_org_sum_amt[4])
/*L02Q*                              to 96 */
/*L02Q*/                             to 95
                                 ((accum total by ar_bill et_sum_amt[5]) -
                                     et_org_sum_amt[5])
/*L02Q*                              to 113 */
/*L02Q*/                             to 111
                                 ((accum total by ar_bill
                                     (et_base_amt -  et_base_applied)) -
                                      et_org_amt)
/*L02Q*                               to 130. */
/*L02Q*/                              to 128.
/*K1SG*/                         put skip.
/*L00M*END ADD*/

/*L00M*BEGIN DELETE*
 *                         if base_rpt = ""
 *                            then
 *                            tempstr = "    " + "Base Customer Totals:".
 *                         else
 *                            tempstr = "     " + base_rpt +" Customer Totals:".
 *                         /* DETAIL REPORT SHOWS DUNNING LEVEL FOR EACH ITEM.*/
 *                         /* SUMMARY REPORT SHOWS HIGHEST DUNNING LEVEL. */
 *                         disp_dun_level =
 *                            (if summary_only
 *                            and high_dun_level <> 0
 *                            then high_dun_level else 0).
 *                         put tempstr
 *                            disp_dun_level
 *                            to 31
 *                            accum total by ar_bill (sum_amt[1])
 *                            to 47
 *                            format "->>>>,>>>,>>9.99"
 *                            accum total by ar_bill (sum_amt[2])
 *                            to 63
 *                            format "->>>>,>>>,>>9.99"
 *                            accum total by ar_bill (sum_amt[3])
 *                            to 79
 *                            format "->>>>,>>>,>>9.99"
 *                            accum total by ar_bill (sum_amt[4])
 *                            to 95
 *                            format "->>>>,>>>,>>9.99"
 *                            accum total by ar_bill (sum_amt[5])
 *                            to 111
 *                            format "->>>>,>>>,>>9.99"
 *                            accum total by ar_bill (base_amt - base_applied)
 *                            to 128
 *                            format "->>>>,>>>,>>9.99".
 *L00M*END DELETE*/

                        end.  /* if last-of(ar_bill) */

                     end.  /* IF LSTYPE */

                     if rec_printed then new_cust = false.
                  end.  /* FOR EACH AR_MSTR */

                  {mfrpexit.i}
               end.  /* FOR EACH CM_MSTR */

               if page-size - line-counter < 3 then page.
               else down 2.
               underline
/*L00M*           age_amt  */
/*L00M*/          et_age_amt
                  ar_amt.

/*L02Q* /*L00M*/       display "    " + et_disp_curr @ ar_nbr */
/*L02Q*/               display "    " + et_report_curr @ ar_nbr
/*L059* /*L00M*/       "Report" @ ar_due_date "Totals:" @ ar_cr_terms */
/*L059*/               {&arcsrp1a_p_34} @ ar_due_date
/*L059*/               {&arcsrp1a_p_33} @ ar_cr_terms

/*L00M*BEGIN ADD */
                       accum total (et_sum_amt[1]) @ et_age_amt[1]
                       accum total (et_sum_amt[2]) @ et_age_amt[2]
                       accum total (et_sum_amt[3]) @ et_age_amt[3]
                       accum total (et_sum_amt[4]) @ et_age_amt[4]
                       accum total (et_sum_amt[5]) @ et_age_amt[5]
                       accum total (et_base_amt - et_base_applied) @ ar_amt.
               down 1.

               /*DETERMINE ORIGINAL REPORT TOTALS, NOT YET CONVERTED*/
               assign
                  et_org_sum_amt[1] = accum total sum_amt[1]
                  et_org_sum_amt[2] = accum total sum_amt[2]
                  et_org_sum_amt[3] = accum total sum_amt[3]
                  et_org_sum_amt[4] = accum total sum_amt[4]
                  et_org_sum_amt[5] = accum total sum_amt[5]
                  et_org_amt        = accum total (base_amt - base_applied).

               /*CONVERT REPORT TOTAL AMOUNTS*/
/*L02Q*        {etrpconv.i et_org_sum_amt[1] et_org_sum_amt[1]} */
/*L02Q*        {etrpconv.i et_org_sum_amt[2] et_org_sum_amt[2]} */
/*L02Q*        {etrpconv.i et_org_sum_amt[3] et_org_sum_amt[3]} */
/*L02Q*        {etrpconv.i et_org_sum_amt[4] et_org_sum_amt[4]} */
/*L02Q*        {etrpconv.i et_org_sum_amt[5] et_org_sum_amt[5]} */
/*L02Q*        {etrpconv.i et_org_amt        et_org_amt       } */

/*L02Q*/       if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/          do i = 1 to 5:
/*L02Q*/             {gprunp.i "mcpl" "p" "mc-curr-conv"
                       "(input mc-rpt-curr,
                         input et_report_curr,
                         input et_rate1,
                         input et_rate2,
                         input et_org_sum_amt[i],
                         input true,  /* ROUND */
                         output et_org_sum_amt[i],
                         output mc-error-number)"}
/*L02Q*/              if mc-error-number <> 0 then do:
/*L02Q*/                 {mfmsg.i mc-error-number 2}
/*L02Q*/              end.
/*L02Q*/          end.  /* do i = 1 to 5 */
/*L02Q*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input mc-rpt-curr,
                      input et_report_curr,
                      input et_rate1,
                      input et_rate2,
                      input et_org_amt,
                      input true,  /* ROUND */
                      output et_org_amt,
                      output mc-error-number)"}
/*L02Q*/          if mc-error-number <> 0 then do:
/*L02Q*/             {mfmsg.i mc-error-number 2}
/*L02Q*/          end.
/*L02Q*/       end.  /* if et_report_curr <> mc-rpt-curr */

               /*L00M*AMOUNT MUST BE <> 0*/
               if et_show_diff and
               (
               (((accum total et_sum_amt[1]) - et_org_sum_amt[1]) <> 0) or
               (((accum total et_sum_amt[2]) - et_org_sum_amt[2]) <> 0) or
               (((accum total et_sum_amt[3]) - et_org_sum_amt[3]) <> 0) or
               (((accum total et_sum_amt[4]) - et_org_sum_amt[4]) <> 0) or
               (((accum total et_sum_amt[5]) - et_org_sum_amt[5]) <> 0) or
               (((accum total (et_base_amt -  et_base_applied)) -
                 et_org_amt) <> 0)
               ) then

                  /* DISPLAY CONVERTED AMOUNTS IF <> 0*/
                  put et_diff_txt to 26 ":" to 27
                     ((accum total et_sum_amt[1]) - et_org_sum_amt[1])
/*L02Q*              to 45 */
/*L02Q*/             to 47
                     ((accum total et_sum_amt[2]) - et_org_sum_amt[2])
/*L02Q*              to 62 */
/*L02Q*/             to 63
                     ((accum total et_sum_amt[3]) - et_org_sum_amt[3])
                     to 79
                     ((accum total et_sum_amt[4]) - et_org_sum_amt[4])
/*L02Q*              to 96 */
/*L02Q*/             to 95
                     ((accum total et_sum_amt[5]) - et_org_sum_amt[5])
/*L02Q*              to 113 */
/*L02Q*/             to 111
                     ((accum total (et_base_amt -  et_base_applied)) -
                     et_org_amt)
/*L02Q*              to 130. */
/*L02Q*/             to 128.
/*K1SG*/          put skip.
/*L00M*END ADD*/

/*L00M*BEGIN DELETE*
 *
 *                if base_rpt = ""
 *                then
 *                   tempstr = "    " + "Base Report Totals:".
 *                else
 *                   tempstr = "     " + base_rpt + " Report Totals:".
 *                put tempstr
 *                   accum total (sum_amt[1])
 *                   to 47
 *                   format "->>>>,>>>,>>9.99"
 *                   accum total (sum_amt[2])
 *                   to 63
 *                   format "->>>>,>>>,>>9.99"
 *                   accum total (sum_amt[3])
 *                   to 79
 *                   format "->>>>,>>>,>>9.99"
 *                   accum total (sum_amt[4])
 *                   to 95
 *                   format "->>>>,>>>,>>9.99"
 *                   accum total (sum_amt[5])
 *                   to 111
 *                   format "->>>>,>>>,>>9.99"
 *                   accum total (base_amt - base_applied)
 *                   to 128
 *                   format "->>>>,>>>,>>9.99".
 *L00M*END DELETE*/

               end.  /* DO WITH FRAME C */

               /* DISPLAY SUMMARY TOTAL INFORMATION */
               if page-size - line-counter < 9 then page.
               else down 2.

/*L00M*BEGIN DELETE*
 *             display "Invoices:" to 34 accum total (inv_tot) at 35
 *                format "->>>,>>>,>>>,>>9.99"
 *                "Cr Memos:" to 34 accum total (memo_tot) at 35
 *                format "->>>,>>>,>>>,>>9.99"
 *                "Finance Charges:" to 34 accum total (fc_tot) at 35
 *                format "->>>,>>>,>>>,>>9.99"
 *                "Unapplied Payments:" to 34 accum total (paid_tot) at 35
 *                format "->>>,>>>,>>>,>>9.99"
 *                "Drafts:" to 34 accum total (drft_tot) at 35
 *                format "->>>,>>>,>>>,>>9.99"
 *L00M*END DELETE*/

/*L00M*BEGIN ADD */

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
/*L02Q*         {etrpconv.i et_org_inv_tot  et_org_inv_tot  } */
/*L02Q*         {etrpconv.i et_org_memo_tot et_org_memo_tot } */
/*L02Q*         {etrpconv.i et_org_fc_tot   et_org_fc_tot   } */
/*L02Q*         {etrpconv.i et_org_paid_tot et_org_paid_tot } */
/*L02Q*         {etrpconv.i et_org_drft_tot et_org_drft_tot } */
/*L02Q*         {etrpconv.i et_org_curr_amt et_org_curr_amt } */
/*L02Q*         {etrpconv.i et_org_amt      et_org_amt      } */

/*L02Q*/        if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input et_org_inv_tot,
                       input true,  /* ROUND */
                       output et_org_inv_tot,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input et_org_memo_tot,
                       input true,  /* ROUND */
                       output et_org_memo_tot,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input et_org_fc_tot,
                       input true,  /* ROUND */
                       output et_org_fc_tot,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input et_org_paid_tot,
                       input true,  /* ROUND */
                       output et_org_paid_tot,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input et_org_drft_tot,
                       input true,  /* ROUND */
                       output et_org_drft_tot,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input et_org_curr_amt,
                       input true,  /* ROUND */
                       output et_org_curr_amt,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input et_org_amt,
                       input true,  /* ROUND */
                       output et_org_amt,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/        end.  /* if et_report_curr <> mc-rpt-curr */
                if ((accum total et_inv_tot) - et_org_inv_tot)   <> 0   or
                ((accum total et_memo_tot) - et_org_memo_tot)    <> 0   or
                ((accum total et_fc_tot) - et_org_fc_tot)        <> 0   or
                ((accum total et_paid_tot) - et_org_paid_tot)    <> 0   or
                ((accum total et_drft_tot) - et_org_drft_tot)    <> 0   or
                ((accum total (et_base_amt - et_base_applied)) -
                  et_org_amt) <> 0   or
                ((accum total (et_curr_amt)) - et_org_curr_amt)  <> 0   or
                (((( accum total (et_curr_amt ))   -
                (accum total (et_base_amt - et_base_applied ))) -
                (et_org_curr_amt - et_org_amt))) <> 0
                   then assign et_diff_exist = true.

                /*DISPLAY CONVERSION TXT*/
                display
                   et_diff_txt
/*L02Q*            to 96 */
/*L02Q*/           to 95
                   when (et_show_diff and et_diff_exist)
/*L02Q*            "Invoices:"   to 34 */
/*L02Q*/           {&arcsrp1a_p_29} to 34
                   accum total (et_inv_tot) at 35
                   format "->>>,>>>,>>>,>>9.99"
                   ((accum total et_inv_tot) - et_org_inv_tot) when
                   (et_show_diff and et_diff_exist)
/*L02Q*            at 75 */
/*L02Q*/           to 75
                   format "->>>,>>>,>>>,>>9.99"
/*L02Q*            "Dr/Cr Memos:" to 34 */
/*L02Q*/           {&arcsrp1a_p_14} to 34
                   accum total (et_memo_tot) at 35
                   format "->>>,>>>,>>>,>>9.99"
                   ((accum total et_memo_tot) - et_org_memo_tot) when
                   (et_show_diff and et_diff_exist)
/*L02Q*            at 75 */
/*L02Q*/           to 75
                   format "->>>,>>>,>>>,>>9.99"
/*L02Q*            "Finance Charges:"    to 34 */
/*L02Q*/           {&arcsrp1a_p_30} to 34
                   accum total (et_fc_tot) at 35
                   format "->>>,>>>,>>>,>>9.99"
                   ((accum total et_fc_tot) - et_org_fc_tot) when
                   (et_show_diff and et_diff_exist)
/*L02Q*            at 75 */
/*L02Q*/           to 75
                   format "->>>,>>>,>>>,>>9.99"
/*L02Q*            "Unapplied Payments:" to 34 */
/*L02Q*/           {&arcsrp1a_p_2} to 34
                   accum total (et_paid_tot) at 35
                   format "->>>,>>>,>>>,>>9.99"
                   ((accum total et_paid_tot) - et_org_paid_tot)
                   when (et_show_diff and et_diff_exist)
/*L02Q*            at 75 */
/*L02Q*/           to 75
                   format "->>>,>>>,>>>,>>9.99"
/*L02Q*            "Drafts:"             to 34 */
/*L02Q*/           {&arcsrp1a_p_8} to 34
                   accum total (et_drft_tot) at 35
                   format "->>>,>>>,>>>,>>9.99"
                   ((accum total et_drft_tot) - et_org_drft_tot)
                   when (et_show_diff and et_diff_exist)
/*L02Q*            at 75 */
/*L02Q*/           to 75
                   format "->>>,>>>,>>>,>>9.99"
/*L02Q*            "Total " + display_curr + fill(" ",4 - length(base_rpt)) */
/*L02Q*            + " Aging:" format "x(17)" to 34 */
/*L02Q*/           {&arcsrp1a_p_23} + et_report_curr + {&arcsrp1a_p_9}
/*L02Q*/           format "x(17)" to 34
                   accum total (et_base_amt - et_base_applied) at 35
                   format "->>>,>>>,>>>,>>9.99"
                   ((accum total (et_base_amt - et_base_applied)) -
                   et_org_amt) when (et_show_diff and et_diff_exist)
/*L02Q*            at 75  */
/*L02Q*/           to 75
                   format "->>>,>>>,>>>,>>9.99"
/*L00M*END ADD*/

/*L00M*BEGIN DELETE*
 *              (if base_rpt = ""
 *                 then "Total Base Aging:"
 *              else " Total " + base_rpt + " Aging:")
 *                 format "x(17)" to 34
 *                 accum total (base_amt - base_applied) at 35
 *                 format "->>>,>>>,>>>,>>9.99"
 *L00M*END DELETE*/

                 with frame d width 132 no-labels.

                 if base_rpt = "" then
                    display {&arcsrp1a_p_13} + string(age_date) +
                            {&arcsrp1a_p_28}
                            format "x(32)" to 34
/*L00M*                     accum total (curr_amt) at 35 */
/*L00M*/                    accum total (et_curr_amt) at 35
                            format "->>>,>>>,>>>,>>9.99"
/*L00M*/                    ((accum total (et_curr_amt)) - et_org_curr_amt)
/*L00M*/                    when (et_show_diff and et_diff_exist)
/*L02Q*                     at 75 */
/*L02Q*/                    to 75
                            {&arcsrp1a_p_4} + string(age_date) +
                            {&arcsrp1a_p_15}
                            format "x(29)" to 34
/*L00M*                     (accum total (curr_amt)) -
 *L00M*                     (accum total (base_amt - base_applied)) at 35    */
/*L00M*/                    (accum total (et_curr_amt)) -
/*L00M*/                    (accum total (et_base_amt - et_base_applied)) at 35
                            format "->>>,>>>,>>>,>>9.99"
/*L00M*/                    ((((accum total (et_curr_amt))   -
/*L00M*/                    (accum total (et_base_amt - et_base_applied))
/*L00M*/                    ) -
/*L00M*/                    (et_org_curr_amt - et_org_amt)
/*L00M*/                    )) when (et_show_diff and et_diff_exist)
/*L02Q* /*L00M*/            at 75 */
/*L02Q*/                    to 75
/*L00M*/                    format "->>>,>>>,>>>,>>9.99"

/*L02Q*/                    skip(1)
/*L02Q*/                    mc-curr-label at 3 et_report_curr skip
/*L02Q*/                    mc-exch-label at 3 mc-exch-line1 skip
/*L02Q*/                    mc-exch-line2 at 25 skip(1)
                    with frame d width 132 no-labels.

                    /* REPORT TRAILER */
                    hide frame phead1.
/*L02Q*             {wbrp04.i} */

                    /* SS - 20050808 - B */
                    OUTPUT CLOSE.
                    OS-DELETE "a6arcsrp1a".
                    /* SS - 20050808 - e */
