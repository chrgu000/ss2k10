/* arcsrp5a.p - AR AGING REPORT FROM AR EFF DATE SUBROUTINE               */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*F0PN*/ /*V8:ConvertMode=Report                                          */
/*L02Q*/ /*V8:RunMode=Character,Windows                                   */
/* REVISION: 6.0      LAST MODIFIED: 09/07/90   BY: afs *D059*            */
/*                                   09/07/90   BY: afs *D066*            */
/*                                   10/16/90   BY: afs *D101*            */
/*                                   01/02/91   BY: afs *D283*            */
/*                                   04/01/91   BY: bjb *D507*            */
/*                                   06/24/91   BY: afs *D723*            */
/* REVISION: 7.0      LAST MODIFIED: 11/25/91   BY: afs *F041*            */
/*                                   02/27/92   BY: jjs *F237*            */
/*                                   04/09/92   BY: tjs *F337*            */
/*                                   04/29/92   BY: mlv *F446*            */
/*                                   05/13/92   by: jms *F481*            */
/*                                   06/18/92   by: jjs *F670*            */
/*                                   08/03/92   by: jms *F829*            */
/* REVISION: 7.3      LAST MODIFIED: 09/28/92   BY: mpp *G476*            */
/*                                   03/11/93   by: jms *G795*            */
/*                                   03/18/93   by: jjs *G843*            */
/*                                   04/12/93   by: jjs *G944*            */
/*                                   04/05/94   by: wep *FN23*            */
/*                                   04/12/94   by: wep *FN39*            */
/*                                   07/25/94   by: pmf *FP54*            */
/*                                   10/13/94   by: str *FS40*            */
/*                                   12/22/94   by: pmf *F0BL*            */
/*                                   01/03/95   by: str *F0C3*            */
/* REVISION: 7.4      LAST MODIFIED: 06/19/95   by: wjk *F0TH*            */
/*                                   01/04/96   by: pmf *G1HD*            */
/*                                   01/31/96   by: mys *F0WY*            */
/* REVISION: 8.5      LAST MODIFIED: 12/08/95   BY: taf *J053*            */
/*                                   04/08/96   BY: jzw *G1P6*            */
/*                                   05/15/96   BY: wjk *G1VV*            */
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: taf *J101*            */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   by: jzw *K00B*            */
/* REVISION: 8.6      LAST MODIFIED: 10/02/96   by: rxm *G2GC*            */
/*                                   10/08/96   by: jzw *K00W*            */
/*                                   10/21/96   by: rxm *G2H3*            */
/* REVISION: 8.6      LAST MODIFIED: 08/30/97   BY: *H1DT* Irine D'mello  */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: bvm *K0Q0*            */
/* REVISION: 8.6      LAST MODIFIED: 01/06/98   BY: *J295* Irine D'mello  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 04/21/98   BY: *H1KH* Samir Bavkar   */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *L00S* D. Sidel       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton   */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L02Q* Brenda Milton  */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L059* Jean Miller    */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/98   BY: *L07H* Brenda Milton  */
/* REVISION: 8.6E     LAST MODIFIED: 09/22/98   BY: *L08W* Russ Witt      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/17/00   BY: *L0TP* Atul Dhatrak      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/07/00   BY: *N0CL* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0VV* BalbeerS Rajput   */
/* REVISION: 9.1      LAST MODIFIED: 06/29/01   BY: *N0ZX* Ed van de Gevel   */
/* REVISION: 9.1      LAST MODIFIED: 10/09/01   BY: *M1MN* Geeta Kotian      */
/* REVISION: 9.1      LAST MODIFIED: 11/26/01   BY: *N169* Seema Tyagi       */
/* REVISION: 9.1      LAST MODIFIED: 02/08/07   BY: *SS - 20070208.1* Bill Jiang       */

/* SS - 20070208.1 - B */
{a6arcsrp0504.i}

DEFINE VARIABLE t_acct LIKE ar_acct.
DEFINE VARIABLE t_sub LIKE ar_sub.
DEFINE VARIABLE t_cc LIKE ar_cc.

DEFINE BUFFER bard FOR ard_det.
/* SS - 20070208.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arcsrp5a_p_26 "Column Days"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp5a_p_3 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp5a_p_4 "Tel"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp5a_p_6 "Show Customer PO"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp5a_p_7 "Show Master Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp5a_p_8 "Show Payment Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp5a_p_9 "Show Invoice Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp5a_p_19 "Customer Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp5a_p_20 "Age by Date (DUE,EFF,INV)"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp5a_p_23 "Attn"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*N0CL* ------------------- BEGIN DELETE ----------------------- *
 * &SCOPED-DEFINE arcsrp5a_p_17 "Base Report Totals:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_24 " Customer Totals:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_2 "Total Base Aging:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_11 "Base Customer Totals:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_1 "Variance of "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_5 "Unapplied Payments:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_10 "Ref     "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_12 "   Total Amount"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_13 "Cr Terms"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_14 "Aging at "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_15 " Aging:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_16 "Dn"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_18 " to Base:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_21 "    Days Old   "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_22 "Dr/Cr Memos:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_25 "Drafts:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_27 " Less Than"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_28 "Due Date"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_29 "Finance Charges:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_30 "    Over"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_31 "Eff Date"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_32 "Lv"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_33 " Exchange Rate:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_34 "Invoices:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_35 " Total "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_36 "Inv Date"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_37 " Report Totals:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_38 "Multiple"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_39 "Customer"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_40 "Totals:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE arcsrp5a_p_41 "Report"
 * /* MaxLen: Comment: */
 *
 *N0CL* ------------------- END   DELETE ----------------------- */


          {mfdeclre.i}
/*N0VV*/  {cxcustom.i "ARCSRP5A.P"}
          {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/*L02Q*   {wbrp02.i} */

/*N0VV*/  {&ARCSRP5A-P-TAG1}
          define variable rndmthd like rnd_rnd_mthd.
          define variable oldcurr like ar_curr.
          /* SS - 20070208.1 - B */
          /*
          define shared variable age_days     as integer extent 4
                                              label {&arcsrp5a_p_26}.
          */
          define shared variable age_days     as integer extent 9
                                              label {&arcsrp5a_p_26}.
          /* SS - 20070208.1 - E */

          define shared variable age_by       as character format "x(3)"
                                              label {&arcsrp5a_p_20}
                                              initial "DUE".

          define shared variable cust         like ar_bill.
          define shared variable cust1        like ar_bill.
          define shared variable cust_type    like cm_type
                                              label {&arcsrp5a_p_19}.
          define shared variable cust_type1   like cm_type.
          define shared variable nbr          like ar_nbr.
          define shared variable nbr1         like ar_nbr.
          define shared variable slspsn       like sp_addr.
          define shared variable slspsn1      like slspsn.
/*N014*   define shared variable acct_type    like ar_acct. */
/*N014*   define shared variable acct_type1   like ar_acct. */
/*N014*/  define shared variable acct         like ar_acct.
/*N014*/  define shared variable acct1        like ar_acct.
/*N014*/  define shared variable sub          like ar_sub.
/*N014*/  define shared variable sub1         like ar_sub.
/*N014*/  define shared variable cc           like ar_cc.
/*N014*/  define shared variable cc1          like ar_cc.
          define shared variable entity       like gl_entity.
          define shared variable entity1      like gl_entity.
          define shared variable effdate1     like ar_effdate initial today.
          define shared variable mstr_type    like cd_type initial "AR".
          define shared variable mstr_lang    like cd_lang.
          define shared variable lstype       like ls_type.

          define shared variable summary_only like mfc_logical
                                              label {&arcsrp5a_p_3}
                                              format {&arcsrp5a_p_3}
                                              initial no.

          define shared variable base_rpt     like ar_curr.

          define shared variable show_po      like mfc_logical
                                              label {&arcsrp5a_p_6}
                                              initial no.

          define shared variable show_pay_detail like mfc_logical
                                              label {&arcsrp5a_p_8}
                                              initial no.

          define shared variable show_comments like mfc_logical
                                              label {&arcsrp5a_p_9}
                                              initial no.

          define shared variable show_mstr_comments like mfc_logical
                                              label {&arcsrp5a_p_7}
                                              initial no.

          define variable age_period   as integer.
          define variable i            as integer.
          define variable cm_recno     as recid.
          define variable new_cust     as logical initial true.
          define variable use_rec      as logical initial false.
          define variable rec_printed  as logical initial false.
          /* SS - 20070208.1 - B */
          /*
          define variable age_range    as character extent 4
                                       format "x(15)".
          define variable age_amt      like ar_amt
                                       format "->>>,>>>,>>9.99"
                                       extent 4.
          define variable name         like ad_name.
          define variable balance      like cm_balance.
          define variable age_paid     like ar_amt extent 4.
          define variable sum_amt      like ar_amt extent 4.
          */
          define variable age_range    as character extent 9
                                       format "x(15)".
          define variable age_amt      like ar_amt
                                       format "->>>,>>>,>>9.99"
                                       extent 9.
          define variable name         like ad_name.
          define variable balance      like cm_balance.
          define variable age_paid     like ar_amt extent 9.
          define variable sum_amt      like ar_amt extent 9.
          /* SS - 20070208.1 - E */
          define variable inv_tot      like ar_amt.
          define variable memo_tot     like ar_amt.
          define variable fc_tot       like ar_amt.
          define variable paid_tot     like ar_amt.
          define variable applied_amt  like ar_applied.
          define variable base_amt     like ar_amt.
          define variable base_applied like ar_applied.
          define variable curr_amt     like ar_amt.
          define variable check_total  as decimal no-undo.
          define variable drft_tot     like ar_amt.
          define variable age_by_date  like ap_date.
          define variable u_amt        like base_amt.
/*L02Q*   define variable exdrate      like exd_rate. */
/*L02Q*/  define variable exdrate      like exr_rate.
/*L02Q* /*L00Y*/  define variable exdrate2     like exd_rate. */
/*L02Q*/  define variable exdrate2     like exr_rate.
/*L02Q*/  define variable exdratetype like exr_ratetype no-undo.
/*H1KH**  define variable applied_base_amt like ar_applied. */
          define variable tempamt      like ard_amt.
          define variable tempstr      as character format "x(25)".
          define variable high_dun_level like ar_dun_level.
          define variable disp_dun_level like ar_dun_level format ">>" no-undo.
          define variable total-amt      like ar_amt no-undo.

          define variable due-date     like ap_date.
          define variable applied-amt  like vo_applied.
          define variable amt-due      like ap_amt.
          define variable multi-due    like mfc_logical.
          define variable this-applied like ar_applied.

/*L02Q*/  define shared variable mc-rpt-curr like base_rpt no-undo.

          define buffer armstr  for ar_mstr.
          define buffer arddet  for ard_det.
          define buffer armstr1 for ar_mstr.

/*L00S*BEGIN ADDED SECTION*/
          {etrpvar.i }
          {etvar.i   }
          /* SS - 20070208.1 - B */
          /*
          define variable et_age_amt          like age_amt extent 4.
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
          */
          define variable et_age_amt          like age_amt extent 9.
          define variable et_age_paid         like ar_amt extent 9.
          define variable et_sum_amt          like ar_amt extent 9.
          define variable et_base_amt         like ar_amt.
          define variable et_base_applied     like ar_amt.
          define variable et_curr_amt         like ar_amt.
          define variable et_inv_tot          like ar_amt.
          define variable et_memo_tot         like ar_amt.
          define variable et_fc_tot           like ar_amt.
          define variable et_paid_tot         like ar_amt.
          define variable et_drft_tot         like ar_amt.
          define variable et_org_sum_amt      like ar_amt extent 9.
          /* SS - 20070208.1 - E */
          define variable et_org_base_amt     like ar_amt.
          define variable et_org_base_applied like ar_amt.
          define variable et_org_curr_amt     like ar_amt.
          define variable et_org_inv_tot      like ar_amt.
          define variable et_org_memo_tot     like ar_amt.
          define variable et_org_fc_tot       like ar_amt.
          define variable et_org_paid_tot     like ar_amt.
          define variable et_org_amt          like ar_amt.
          define variable et_org_drft_tot     like ar_amt.
          define variable et_diff_exist       as logical initial false.
/*L00S*END ADDED SECTION*/

          /*BEGIN PROGRAM*/
          find first gl_ctrl no-lock. /*for rounding after currency conversion*/

          /* CREATE REPORT HEADER */

/*N0CL* ------------------- BEGIN DELETE ----------------------- *
 *        do i = 2 to 4:
 *           age_range[i] = {&arcsrp5a_p_30} + string(age_days[i - 1],"->>>9").
 *        end.
 *        age_range[1] = {&arcsrp5a_p_27} + string(age_days[1],"->>>9").
 *
 *          form
 *             header
 *             space (47)
 *             {&arcsrp5a_p_16} /* FOR DUNNING LEVEL */
 *             age_range[1 for 4] skip
 *             {&arcsrp5a_p_10}
 *             "T"
 *             {&arcsrp5a_p_31}
 *             {&arcsrp5a_p_28}
 *             {&arcsrp5a_p_36}
 *             {&arcsrp5a_p_13}
 *             {&arcsrp5a_p_32} /* FOR DUNNING LEVEL */
 *             {&arcsrp5a_p_21}
 *             {&arcsrp5a_p_21}
 *             {&arcsrp5a_p_21}
 *             {&arcsrp5a_p_21}
 *             {&arcsrp5a_p_12} skip
 *             "--------"
 *             "-"
 *             "--------"
 *             "--------"
 *             "--------"
 *             "--------"
 *             "--" /* FOR DUNNING LEVEL */
 *             "---------------"
 *             "---------------"
 *             "---------------"
 *             "---------------"
 *             "----------------" skip
 *          with frame phead1 width 132 page-top.
 *N0CL* ------------------- END   DELETE ----------------------- */

/*N0CL* ------------------- BEGIN ADD ----------------------- */
          /* SS - 20070208.1 - B */
          /*
          do i = 2 to 4:
             age_range[i] = getTermLabelRt("OVER",8) +
                            string(age_days[i - 1],"->>>9").
          end.
          age_range[1] = getTermLabelRt("LESS_THAN",10) +
                         string(age_days[1],"->>>9").

          form
             header
             space (47)
             getTermLabel("DUNNING",2) format "x(2)" /* FOR DUNNING LEVEL */
             age_range[1 for 4] format "x(15)" skip
             getTermLabel("REFERENCE",8)
             getTermLabel("TYPE",1) format "x(1)"
             getTermLabel("EFFECTIVE_DATE",8)
             getTermLabel("DUE_DATE",8)
             getTermLabel("INVOICE_DATE",8)
             getTermLabel("CREDIT_TERMS",8)
             getTermLabel("LEVEL",2)  format "x(2)" /* FOR DUNNING LEVEL */
             getTermLabelCentered("DAYS_OLD",15) format "x(15)"
             getTermLabelCentered("DAYS_OLD",15) format "x(15)"
             getTermLabelCentered("DAYS_OLD",15) format "x(15)"
             getTermLabelCentered("DAYS_OLD",15) format "x(15)"
             getTermLabelRt("TOTAL_AMOUNT",15)   format "x(15)"
             skip
             "--------"
             "-"
             "--------"
             "--------"
             "--------"
             "--------"
             "--" /* FOR DUNNING LEVEL */
             "---------------"
             "---------------"
             "---------------"
             "---------------"
             "----------------" skip
          with frame phead1 width 132 page-top.
/*N0CL* ------------------- END   ADD ----------------------- */

          view frame phead1.
          */
          /* SS - 20070208.1 - E */

          do with frame c down no-box
/*L00S*/     on endkey undo, leave:
             for each cm_mstr
                where (cm_addr >= cust and cm_addr <= cust1)
                and (cm_type >= cust_type and cm_type <= cust_type1)
                no-lock by cm_sort:

                high_dun_level = 0.

                for each ar_mstr where ar_bill = cm_addr
                   and (ar_nbr >= nbr and ar_nbr <= nbr1)
                   and ((ar_slspsn[1] >= slspsn and ar_slspsn[1] <= slspsn1)
                   or   (ar_slspsn[2] >= slspsn and ar_slspsn[2] <= slspsn1)
                   or   (ar_slspsn[3] >= slspsn and ar_slspsn[3] <= slspsn1)
                   or   (ar_slspsn[4] >= slspsn and ar_slspsn[4] <= slspsn1))
                   and (ar_type = "P" or
                   (ar_entity >= entity and ar_entity <= entity1))
                   and  (ar_type = "P" and (ar_effdate <= effdate1)
                   or ((ar_effdate <= effdate1) or ar_effdate = ? ))
                   and (not ar_type = "D" or ar_draft) /* APPRVD DRAFTS ONLY */
                   and ((ar_curr = base_rpt)
                   or (base_rpt = ""))
                   and (ar_type <> "A")
                   no-lock break by ar_bill by ar_nbr
                   with frame c width 132 no-labels:

                   if (oldcurr <> ar_curr) or (oldcurr = "") then do:
/*L02Q*               {gpcurmth.i */
/*L02Q*                   "ar_curr" */
/*L02Q*                   "4" */
/*L02Q*                   "next" */
/*L02Q*                   "pause" } */
/*L02Q*/              /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L02Q*/              {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                        "(input ar_curr,
                          output rndmthd,
                          output mc-error-number)"}
/*L02Q*/              if mc-error-number <> 0 then do:
/*L02Q*/                 {mfmsg.i mc-error-number 4}
/*L08W*L02Q*             pause.   */
/*L08W*/                 pause 0.
/*L02Q*/                 next.
/*L02Q*/              end.

                      oldcurr = ar_curr.
                   end.  /* if (oldcurr <> ar_curr) or (oldcurr = "") */

                   if lstype = "" or (lstype <> "" and can-find(first ls_mstr
                   where ls_type = lstype and ls_addr = cm_addr)) then do:

                      /* STORE FIRST CUSTOMER INFORMATION IN A LOGICAL */
                      /* SINCE THE ACCOUNT VALIDATION MAY CAUSE THE    */
                      /* ACTUAL FIRST RECORD TO BE SKIPPED             */
                      if first-of(ar_bill) then new_cust = true.

                      /* VALIDATE THE AR ACCOUNT (IF RANGE SPECIFIED)  */
                      use_rec = true.
                      if ar_type <> "P" then do:
/*N014*                  if (ar_acct < acct_type or ar_acct > acct_type1) */
/*N014*/                 if (ar_acct < acct or ar_acct > acct1)
/*N014*/                 or (ar_sub < sub or ar_sub > sub1)
/*N014*/                 or (ar_cc < cc or ar_cc > cc1)
/*N014*/                 then
                            use_rec = false.

/* SS - 20070208.1 - B */
                      if ar_type <> "P" then do:
/*N014*                  if (ar_acct < acct_type or ar_acct > acct_type1) */
/*N014*/                 if (ar_acct < acct or ar_acct > acct1)
/*N014*/                 or (ar_sub < sub or ar_sub > sub1)
/*N014*/                 or (ar_cc < cc or ar_cc > cc1)
/*N014*/                 THEN DO:
                                    t_acct = ar_acct.
                                    t_sub = ar_sub.
                                    t_cc = ar_cc.
                                 END.
                      END.
/* SS - 20070208.1 - E */

                      end. /* if ar_type <> "P" */
                      else do:
                         /* PAYMENTS: GET THE DETAIL TO DETERMINE MEETING */
                         /* THE CRITERIA, THIS WILL BE USED TO BACK THE   */
                         /* AMOUNTS NOT APPLIED AT TIME OF THE EFFECTIVE  */
                         /* DATE LATER IN THE PROGRAM. ALWAYS EXCLUDE THE */
                         /* NON-AR REGARDLESS OF CRITERIA. NON-AR IS      */
                         /* NEVER TO SHOW UP ON REPORT.                   */
                         use_rec = false.
                         u_amt = 0.

                         for each ard_det where ard_nbr = ar_nbr no-lock:
                            if ard_typ <> "n" then
                               if  (ard_entity >= entity      and
                                    ard_entity <= entity1     and
/*N014*                             ard_acct   >= acct_type   and */
/*N014*                             ard_acct   <= acct_type1) */
/*N014*/                            ard_acct   >= acct        and
/*N014*/                            ard_acct   <= acct1       and
/*N014*/                            ard_sub    >= sub         and
/*N014*/                            ard_sub    <= sub1        and
/*N014*/                            ard_cc     >= cc          and
/*N014*/                            ard_cc     <= cc1)
                               then do:
                                  use_rec = true.
                                  u_amt = u_amt - ard_amt.
                                  /* SS - 20070208.1 - B */
                                  IF ard_type = "u" THEN DO:
                                     t_acct = ard_acct.
                                     t_sub = ard_sub.
                                     t_cc = ard_cc.
                                  END.
                                  /* SS - 20070208.1 - E */
                               end. /* IF MEETS CRITERIA OR NON-AR */
                         end.  /* for each ard_det */
                      end.  /* else do */

                      if use_rec then do:
/*N0VV*/                 {&ARCSRP5A-P-TAG2}
                         form
                            ar_nbr         format "x(8)"
                            ar_type
                            ar_effdate
                            ar_due_date
                            ar_date
                            ar_cr_terms
                            ar_dun_level format ">>"
/*L00S*                     age_amt[1 for 4] */
/*L00S*/                    et_age_amt[ 1 for 4]
                            ar_amt
                         with frame c width 132.
/*N0VV*/                 {&ARCSRP5A-P-TAG3}

                         /* SET EXTERNAL LABELS */
                         setFrameLabels(frame c:handle).

                         /* SS - 20070208.1 - B */
                         /*
                         do i = 1 to 4:
                            */
                         do i = 1 to 9:
                            /* SS - 20070208.1 - E */
                            age_amt[i] = 0.
                            age_paid[i] = 0.
                            sum_amt[i] = 0.
/*L00S*/                    et_age_amt[i]  = 0.
/*L00S*/                    et_age_paid[i] = 0.
/*L00S*/                    et_sum_amt[i]  = 0.
                         end.

                         if age_by = "EFF" then age_by_date = ar_effdate.
                         else if age_by = "INV" then age_by_date = ar_date.
                         else do:
                            if ar_type <> "P" then age_by_date = ar_due_date.
                            else age_by_date = ar_date.
                         end.
                         /* SS - 20070208.1 - B */
                         /*
                         age_period = 4.
                         do i = 1 to 4:
                            if (effdate1 - age_days[i]) <= age_by_date
                                               then age_period = i.
                            if age_period <> 4 then leave.
                         end.
                         */
                         age_period = 9.
                         do i = 1 to 9:
                            if (effdate1 - age_days[i]) <= age_by_date
                                               then age_period = i.
                            if age_period <> 9 then leave.
                         end.
                         /* SS - 20070208.1 - E */
                         if age_by_date = ? then age_period = 1.

                         applied_amt = 0.
/*H1KH**                 applied_base_amt = 0. */
/*N0VV*/                 {&ARCSRP5A-P-TAG4}

                         do for armstr: /* SEE IF PAID PRIOR TO EFFDATE */
/*N0VV*/                    {&ARCSRP5A-P-TAG5}

                            /* IF INVOICE OR MEMO */
                            if ar_mstr.ar_type <> "P" then do:

                               check_total = 0.

                               /*SEE IF OPEN ITEM PASSES CRITERIA CHECK*/
                               if ar_mstr.ar_entity >= entity     and
                                  ar_mstr.ar_entity <= entity1    and
/*N014*                           ar_mstr.ar_acct   >= acct_type  and */
/*N014*                           ar_mstr.ar_acct   <= acct_type1 */
/*N014*/                          ar_mstr.ar_acct   >= acct       and
/*N014*/                          ar_mstr.ar_acct   <= acct1      and
/*N014*/                          ar_mstr.ar_sub    >= sub        and
/*N014*/                          ar_mstr.ar_sub    <= sub1       and
/*N014*/                          ar_mstr.ar_cc     >= cc         and
/*N014*/                          ar_mstr.ar_cc     <= cc1
                               then do:

                                  /* FOR EACH PAYMENT DETAIL LINE FOR */
                                  /* THIS INVOICE/MEMO                */
                                  for each ard_det where
                                     ard_ref = ar_mstr.ar_nbr no-lock:

                                     /* FIND PAYMENT HEADER FOR THIS */
                                     /* PAYMENT DETAIL LINE          */
                                     find armstr where
                                        armstr.ar_nbr = ard_nbr
                                        no-lock no-error.

                                     if available armstr
                                     and (armstr.ar_type = "P"
                                     or   armstr.ar_type = "D"
                                     or   armstr.ar_type = "A")
                                     then do:

                                        /* ONLY EXECUTE THE FOLLOWING CODE    */
                                        /* IF WE'VE FOUND A PAYMENT OR DRAFT  */
                                        /* RECORD.  OTHERWISE, THIS IS A MEMO */
                                        /* OR INVOICE TO WHICH A DRAFT WAS    */
                                        /* APPLIED                            */
                                        if armstr.ar_effdate <= effdate1
                                           and ard_type <> "n" then do:

                                           if ar_mstr.ar_curr <> armstr.ar_curr
                                           then do:
                                                applied_amt = applied_amt
                                                            + ard_cur_amt
                                                            + ard_cur_disc.

/*H1KH*/ /* applied_amt IS USED IN PLACE OF applied_base_amt */
/*H1KH*/ /* TO ELIMINATE ROUNDING ERRORS                     */
/*H1KH** BEGIN DELETE
 *                                              applied_base_amt =
 *                                                       applied_base_amt
 *                                                     + (ard_cur_amt
 *                                                     +  ard_cur_disc) /
 *                                                        ar_mstr.ar_ex_rate.
 *
 *                                              /* ROUND PER BASE CURR */
 *                                              {gprun.i ""gpcurrnd.p""
 *                                              "(input-output applied_base_amt,
 *                                                input gl_rnd_mthd)"}
 *H1KH** END DELETE */

                                           end. /* if ar_mstr.ar_curr ... */
                                           else do:
                                                applied_amt = applied_amt
                                                            + ard_amt
                                                            + ard_disc.
/*H1KH** BEGIN DELETE
 *                                              applied_base_amt =
 *                                                  applied_base_amt +
 *                                                  (ard_amt + ard_disc) /
 *                                                  ar_mstr.ar_ex_rate.
 *H1KH** END DELETE */

                                           end.  /* else do */

                                        end. /* EFF DATE, TYPE CHECK */

                                        if ar_mstr.ar_curr <> armstr.ar_curr
                                        then
                                           check_total = check_total
                                                       + ard_cur_amt
                                                       + ard_cur_disc.
                                        else
                                           check_total = check_total
                                                       + ard_amt
                                                       + ard_disc.

                                     end. /* IF AVAIL ARMSTR */

                                  end. /* FOR EACH ARD_DET */

                                  /* THE FOLLOWING CODE IS PRESENT TO DETECT */
                                  /* THE SITUATION WHERE MEMOS OR INVOICES   */
                                  /* HAD PARTIAL PMTS THAT HAVE BEEN ARCHIVED*/
                                  /* /DELETED                                */
                                  if check_total <> ar_mstr.ar_applied then do:
                                     applied_amt = applied_amt +
                                        (ar_mstr.ar_applied - check_total).
/*H1KH** BEGIN DELETE
 *                                   applied_base_amt = applied_base_amt +
 *                                      ((ar_mstr.ar_applied - check_total) /
 *                                      ar_mstr.ar_ex_rate).
 *H1KH** END DELETE */
                                  end.

                               end. /* AR_ACCT/AR_ENTITY CHECK */

                            end. /* IF AR_MSTR.AR_TYPE */

                            /* OTHERWISE AR_MSTR IS A PAYMENT RECORD */
                            else do:

                               /* UNROLL PAYMENT TO SEE OPEN ITEMS. CHECK */
                               /* TO SEE WHAT WAS UNAPPLIED PRIOR TO      */
                               /* EFFECTIVE DATE                          */
                               for each ard_det where ard_nbr = ar_mstr.ar_nbr
                               no-lock:

                                  /*SEE IF OPEN ITEM EXISTED PRIOR TO EFF DATE*/
                                  if ard_type <> "U" then do:
                                     find armstr where armstr.ar_nbr = ard_ref
                                        no-lock no-error.

                                     if (available armstr                and
                                         armstr.ar_effdate <= effdate1   and
                                         armstr.ar_entity >= entity      and
                                         armstr.ar_entity <= entity1     and
/*N014*                                  armstr.ar_acct >= acct_type     and */
/*N014*                                  armstr.ar_acct <= acct_type1)   and */
/*N014*/                                 armstr.ar_acct >= acct          and
/*N014*/                                 armstr.ar_acct <= acct1         and
/*N014*/                                 armstr.ar_sub >= sub            and
/*N014*/                                 armstr.ar_sub <= sub1           and
/*N014*/                                 armstr.ar_cc >= cc              and
/*N014*/                                 armstr.ar_cc <= cc1)            and
                                         ard_type <> "n" then
                                            applied_amt = applied_amt - ard_amt.

                                  end. /* ARD_TYPE <> U */
                               end. /* FOR EACH ARD_DET */

                               /* FOR EACH APPLIED UNAPPLIED FOR THIS */
                               /* UNAPPLIED PAYMENT, CHECK TO SEE IF  */
                               /* OPEN ITEM MEETS CRITERIA.           */
                               for each armstr
                                  where armstr.ar_check = ar_mstr.ar_check
                                  and armstr.ar_bill = ar_mstr.ar_bill
                                  and armstr.ar_type = "A"
                                  and armstr.ar_effdate <= effdate1
/*N014*                           and armstr.ar_acct >= acct_type */
/*N014*                           and armstr.ar_acct <= acct_type1 */
/*N014*/                          and armstr.ar_acct >= acct
/*N014*/                          and armstr.ar_acct <= acct1
/*N014*/                          and armstr.ar_sub >= sub
/*N014*/                          and armstr.ar_sub <= sub1
/*N014*/                          and armstr.ar_cc >= cc
/*N014*/                          and armstr.ar_cc <= cc1
                                  and armstr.ar_entity >= entity
                                  and armstr.ar_entity <= entity1
                                  no-lock:

                                  /* LINES OF THE APPLIED, THIS IS THE    */
                                  /* UNAPLIED RECORD ENTITY FILTERING ON  */
                                  /* THE ARD_DET SEEMS INCONSISTENT WITH  */
                                  /* ACCT FILTERING ON AR_MSTR.           */
                                  for each arddet where
                                     arddet.ard_nbr = armstr.ar_nbr
                                     no-lock:

                                     find armstr1
                                        where armstr1.ar_nbr = arddet.ard_ref
                                        no-lock no-error.
                                     if available armstr1 and
                                        armstr1.ar_effdate <= effdate1 then
                                        applied_amt = applied_amt -
                                        arddet.ard_amt.
                                  end. /* FOR EACH ARDDET */
                               end. /* FOR EACH ARMSTR */

                            end. /* AR_MSTR IS A PAYMENT (else do:) */

                         end. /* DO FOR ARMSTR */

                         if ar_type = "P" then do:
                            curr_amt = u_amt - applied_amt.
                            base_amt = u_amt.
                         end.
                         else do:
                            base_amt = ar_amt.
                            curr_amt = ar_amt - applied_amt.
                         end.
                         base_applied = applied_amt.

                         if base_rpt = ""
/*M1MN*/                 and (base_amt - base_applied) <> 0
                         and  ar_curr <> base_curr then do:
/*L02Q*                     base_amt = base_amt / ar_ex_rate. */

                            /* ROUND PER BASE ROUND METHOD */
/*L02Q*                     {gprun.i ""gpcurrnd.p"" "(input-output base_amt, */
/*L02Q*                                               input gl_rnd_mthd)"} */

                            /* IF RUNNING REPORT IN BASE, AND WORKING ON A   */
                            /* NON-BASE CURRENCY MEMO OR INVOICE, USE THE    */
                            /* APPLIED BASE AMOUNT CALCULATED WHEN FILTERING */
                            /* THROUGH THE PAYMENTS                          */
/*H1KH** BEGIN DELETE
 *                          if ar_type <> "P" then
 *                             base_applied = applied_base_amt.
 *                          else do:
 *H1KH** END DELETE */
/*L02Q*                        base_applied = base_applied / ar_ex_rate. */
                               /* ROUND PER BASE ROUND METHOD */
/*L02Q*                        {gprun.i ""gpcurrnd.p"" */
/*L02Q*                                   "(input-output base_applied, */
/*L02Q*                                     input gl_rnd_mthd)"} */
/*H1KH**                    end. */

/*L07H* /*L02Q*/            assign
 *      /*L02Q*/               base_amt = ar_base_amt
 *      /*L02Q*/               base_applied = ar_base_applied.
 *L07H*/
/*L07H*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input ar_curr,
                                input base_curr,
                                input ar_ex_rate,
                                input ar_ex_rate2,
                                input base_amt,
                                input true,  /* ROUND */
                                output base_amt,
                                output mc-error-number)"}
/*L07H*/                    if mc-error-number <> 0 then do:
/*L07H*/                       {mfmsg.i mc-error-number 2}
/*L07H*/                    end.
/*L07H*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input ar_curr,
                                input base_curr,
                                input ar_ex_rate,
                                input ar_ex_rate2,
                                input base_applied,
                                input true,  /* ROUND */
                                output base_applied,
                                output mc-error-number)"}
/*L07H*/                    if mc-error-number <> 0 then do:
/*L07H*/                       {mfmsg.i mc-error-number 2}
/*L07H*/                    end.

/*L02Q*                     {gpgtex8.i &ent_curr = base_curr */
/*L02Q*                                &curr = ar_curr */
/*L02Q*                                &date = effdate1 */
/*L02Q*                                &exch_from = exd_rate */
/*L02Q*                                &exch_to = exdrate } */

/*L0TP*/                    /* SHOULD NOT SKIP A CUSTOMER AND ITS INVOICES/ */
/*L0TP*/                    /* MEMOS DETAILS WHEN EXCHANGE RATE IS NOT      */
/*L0TP*/                    /* DEFINED FOR THE EFFECTIVE DATE OF THE REPORT */

/*L02Q*/                    /* GET EXCHANGE RATE */
/*N0VV*/                    {&ARCSRP5A-P-TAG6}
/*L02Q*/                    {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                              "(input ar_curr,
                                input base_curr,
                                input exdratetype,
                                input effdate1,
                                output exdrate,
                                output exdrate2,
                                output mc-error-number)"}
/*N0VV*/                        {&ARCSRP5A-P-TAG7}
/*L02Q*/                    if mc-error-number <> 0 then do:
/*L08W*L02Q*                   {mfmsg.i mc-error-number 3}   */
/*L08W*/                       {mfmsg.i mc-error-number 4}
/*L08W*/                       pause 0.
/*L0TP** /*L08W*/              leave. */
/*L02Q*/                    end.

/*L02Q*                     if available exd_det then curr_amt = */
/*L02Q*                        curr_amt / exdrate. */

/*L02Q*/                    if mc-error-number = 0 then do:
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input ar_curr,
                                   input base_curr,
                                   input exdrate,
                                   input exdrate2,
                                   input curr_amt,
                                   input true, /* ROUND */
                                   output curr_amt,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 3}
/*L02Q*/                       end.
                            end.  /* if mc-error-number = 0 */

                            /* IF NO EXCHANGE RATE FOR TODAY, */
                            /* USE THE INVOICE RATE           */
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
                                   output mc-error-number)"}.
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 3}
/*L02Q*/                       end.
/*L02Q*/                    end.
                            /* ROUND PER BASE ROUND METHOD */
/*L02Q*                     {gprun.i ""gpcurrnd.p"" "(input-output curr_amt, */
/*L02Q*                                               input gl_rnd_mthd)"} */
                         end. /* IF BASE_RPT = "" */

                         /* DON'T DISPLAY IF CLOSED */
                         if base_amt - base_applied <> 0 then do:

                             multi-due = no.

                             /*CHECK FOR CREDIT DATING TERMS */
                             find ct_mstr where ct_code = ar_cr_terms
                             and age_by = "DUE" no-lock no-error.
                             if available ct_mstr and ct_dating = yes then do:
                                multi-due = yes.
                                applied-amt = base_applied.
                                total-amt = 0.
                                for each ctd_det where ctd_code = ar_cr_terms
                                   no-lock break by ctd_code:

                                   find ct_mstr where ct_code = ctd_date_cd
                                   no-lock no-error.
                                   if available ct_mstr then do:
/*N0VV*/                              {&ARCSRP5A-P-TAG8}
                                      if ct_due_inv = 1 then
                                         due-date  = ar_date + ct_due_days.
                                      else       /* from end of month */
                                         due-date = date((month(ar_date) + 1)
                                         mod 12 + if month(ar_date) = 11 then 12
                                         else 0, 1, year(ar_date)
                                         + if month(ar_date) >= 12 then 1
                                         else 0) + integer(ct_due_days)
                                         - if ct_due_days <> 0 then 1 else 0.
                                      if ct_due_date <> ? then
                                         due-date = ct_due_date.
/*N0VV*/                              {&ARCSRP5A-P-TAG9}

                                      /*CALCULTE AMT-DUE LESS THE APPLIED */
                                      /* FOR THIS SEGMENT */
                                      /* TO PREVENT ROUNDING ERRORS ASSIGN   */
                                      /* LAST BUCKET   =                     */
                                      /* ROUNDED TOTAL - RUNNING TOTAL       */
                                      if last-of(ctd_code) then
                                         amt-due = base_amt - total-amt.
                                      else
                                         amt-due =
                                            base_amt * (ctd_pct_due / 100).
                                      if ar_mstr.ar_curr <> base_curr and
                                      base_rpt = ""
                                      then do:
                                         /* ROUND PER BASE ROUND METHOD */
/*L02Q*                                  {gprun.i ""gpcurrnd.p"" */
/*L02Q*                                             "(input-output amt-due, */
/*L02Q*                                               input gl_rnd_mthd)"} */
/*L02Q*/                                 {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                            "(input-output amt-due,
                                              input gl_rnd_mthd,
                                              output mc-error-number)"}
/*L02Q*/                                 if mc-error-number <> 0 then do:
/*L02Q*/                                    {mfmsg.i mc-error-number 3}
/*L02Q*/                                 end.
                                      end.
                                      else do:
                                         /* ROUND PER AR_CURR ROUND METHOD */
/*L02Q*                                  {gprun.i ""gpcurrnd.p"" */
/*L02Q*                                            "(input-output amt-due, */
/*L02Q*                                              input rndmthd)"} */
/*L02Q*/                                 {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                            "(input-output amt-due,
                                              input rndmthd,
                                              output mc-error-number)"}
/*L02Q*/                                 if mc-error-number <> 0 then do:
/*L02Q*/                                    {mfmsg.i mc-error-number 3}
/*L02Q*/                                 end.
                                      end.
                                      total-amt = total-amt + amt-due.
                                      if ar_amt >= 0 then
                                         this-applied =
                                            min(amt-due, applied-amt).
                                      else
                                         this-applied =
                                            max(amt-due, applied-amt).
                                      applied-amt = applied-amt - this-applied.

                                      /* SS - 20070208.1 - B */
                                      /*
                                      age_period = 4.
                                      do i = 1 to 4:
                                         if (effdate1 - age_days[i]) <= due-date
                                            then age_period = i.
                                         if age_period <> 4 then leave.
                                      end.
                                      */
                                      age_period = 9.
                                      do i = 1 to 9:
                                         if (effdate1 - age_days[i]) <= due-date
                                            then age_period = i.
                                         if age_period <> 9 then leave.
                                      end.
                                      /* SS - 20070208.1 - E */
                                      if due-date = ? then age_period = 1.

                                      age_amt[age_period] = age_amt[age_period]
                                                           + amt-due.
                                      if not show_pay_detail then
                                         age_amt[age_period] =
                                            age_amt[age_period]
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
                                if not show_pay_detail or ar_type = "P" then
                                   age_amt[age_period] = base_amt -
                                                         base_applied.
                                else age_amt[age_period] = base_amt.

                                age_paid[age_period] =  base_applied * (-1).
                                sum_amt[age_period] = base_amt - base_applied.
                             end.
                             if ar_type = "I" then
                                inv_tot = base_amt - base_applied.
                             else inv_tot = 0.
                             if ar_type = "M" then
                                memo_tot = base_amt - base_applied.
                             else memo_tot = 0.
                             if ar_type = "F" then
                                fc_tot = base_amt - base_applied.
                             else fc_tot = 0.
                             if ar_type = "D" then
                                drft_tot = base_amt - base_applied.
                             else drft_tot = 0.
                             if ar_type = "P" then
                                paid_tot = base_amt - base_applied.
                             else paid_tot = 0.

/*L00S*BEGIN ADDED SECTION*/
/*L02Q*                      {etrpconv.i sum_amt[1] et_sum_amt[1]}    */
/*L02Q*                      {etrpconv.i sum_amt[2] et_sum_amt[2]}    */
/*L02Q*                      {etrpconv.i sum_amt[3] et_sum_amt[3]}    */
/*L02Q*                      {etrpconv.i sum_amt[4] et_sum_amt[4]}    */
/*L02Q*                      {etrpconv.i age_amt[1] et_age_amt[1]}    */
/*L02Q*                      {etrpconv.i age_amt[2] et_age_amt[2]}    */
/*L02Q*                      {etrpconv.i age_amt[3] et_age_amt[3]}    */
/*L02Q*                      {etrpconv.i age_amt[4] et_age_amt[4]}    */
/*L02Q*                      {etrpconv.i age_paid[1] et_age_paid[1]}  */
/*L02Q*                      {etrpconv.i age_paid[2] et_age_paid[2]}  */
/*L02Q*                      {etrpconv.i age_paid[3] et_age_paid[3]}  */
/*L02Q*                      {etrpconv.i age_paid[4] et_age_paid[4]}  */
/*L02Q*                      {etrpconv.i base_amt et_base_amt}        */
/*L02Q*                      {etrpconv.i base_applied et_base_applied}*/
/*L02Q*                      {etrpconv.i inv_tot et_inv_tot}          */
/*L02Q*                      {etrpconv.i memo_tot et_memo_tot}        */
/*L02Q*                      {etrpconv.i fc_tot et_fc_tot}            */
/*L02Q*                      {etrpconv.i paid_tot et_paid_tot}        */
/*L02Q*                      {etrpconv.i drft_tot et_drft_tot}        */
/*L02Q*                      {etrpconv.i curr_amt et_curr_amt}        */

                                  /* SS - 20070208.1 - B */
                                  /*
/*L02Q*/                     do i = 1 to 4:
   */
/*L02Q*/                     do i = 1 to 9:
   /* SS - 20070208.1 - E */
/*L02Q*/                        if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/                           {gprunp.i "mcpl" "p" "mc-curr-conv"
                                     "(input mc-rpt-curr,
                                       input et_report_curr,
                                       input et_rate1,
                                       input et_rate2,
                                       input sum_amt[i],
                                       input true,  /* ROUND */
                                       output et_sum_amt[i],
                                       output mc-error-number)"}
/*L02Q*/                           if mc-error-number <> 0 then do:
/*L02Q*/                              {mfmsg.i mc-error-number 3}
/*L02Q*/                           end.
/*L02Q*/                           {gprunp.i "mcpl" "p" "mc-curr-conv"
                                     "(input mc-rpt-curr,
                                       input et_report_curr,
                                       input et_rate1,
                                       input et_rate2,
                                       input age_amt[i],
                                       input true,  /* ROUND */
                                       output et_age_amt[i],
                                       output mc-error-number)"}
/*L02Q*/                           if mc-error-number <> 0 then do:
/*L02Q*/                              {mfmsg.i mc-error-number 3}
/*L02Q*/                           end.
/*L02Q*/                           {gprunp.i "mcpl" "p" "mc-curr-conv"
                                     "(input mc-rpt-curr,
                                       input et_report_curr,
                                       input et_rate1,
                                       input et_rate2,
                                       input age_paid[i],
                                       input true,  /* ROUND */
                                       output et_age_paid[i],
                                       output mc-error-number)"}
/*L02Q*/                           if mc-error-number <> 0 then do:
/*L02Q*/                              {mfmsg.i mc-error-number 3}
/*L02Q*/                           end.
/*L02Q*/                       end.  /* if et_report_curr <> mc-rpt-curr */
/*L02Q*/                       else assign
/*L02Q*/                          et_sum_amt[i] = sum_amt[i]
/*L02Q*/                          et_age_amt[i] = age_amt[i]
/*L02Q*/                          et_age_paid[i] = age_paid[i].
/*L02Q*/                    end.  /* do i = 1 to 4 */
/*L02Q*/                    if et_report_curr <> mc-rpt-curr then do:
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input base_amt,
                                   input true,  /* ROUND */
                                   output et_base_amt,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 3}
/*L02Q*/                       end.
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input base_applied,
                                   input true,  /* ROUND */
                                   output et_base_applied,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 3}
/*L02Q*/                       end.
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input inv_tot,
                                   input true,  /* ROUND */
                                   output et_inv_tot,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 3}
/*L02Q*/                       end.
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input memo_tot,
                                   input true,  /* ROUND */
                                   output et_memo_tot,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 3}
/*L02Q*/                       end.
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input fc_tot,
                                   input true,  /* ROUND */
                                   output et_fc_tot,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 3}
/*L02Q*/                       end.
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input paid_tot,
                                   input true,  /* ROUND */
                                   output et_paid_tot,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 3}
/*L02Q*/                       end.
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input drft_tot,
                                   input true,  /* ROUND */
                                   output et_drft_tot,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 3}
/*L02Q*/                       end.
/*L02Q*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input mc-rpt-curr,
                                   input et_report_curr,
                                   input et_rate1,
                                   input et_rate2,
                                   input curr_amt,
                                   input true,  /* ROUND */
                                   output et_curr_amt,
                                   output mc-error-number)"}
/*L02Q*/                       if mc-error-number <> 0 then do:
/*L02Q*/                          {mfmsg.i mc-error-number 3}
/*L02Q*/                       end.
/*L02Q*/                    end.  /* if et_report_curr <> mc-rpt-curr */
/*L02Q*/                    else assign
/*L02Q*/                       et_base_amt = base_amt
/*L02Q*/                       et_base_applied = base_applied
/*L02Q*/                       et_inv_tot = inv_tot
/*L02Q*/                       et_memo_tot = memo_tot
/*L02Q*/                       et_fc_tot = fc_tot
/*L02Q*/                       et_paid_tot = paid_tot
/*L02Q*/                       et_drft_tot = drft_tot
/*L02Q*/                       et_curr_amt = curr_amt.

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
/*N0VV*/                    {&ARCSRP5A-P-TAG10}

                            accumulate sum_amt (total by ar_bill).
                            accumulate base_amt - base_applied
                                (total by ar_bill).
                            accumulate inv_tot (total).
                            accumulate memo_tot (total).
                            accumulate fc_tot (total).
                            accumulate paid_tot (total).
                            accumulate drft_tot (total).
                            accumulate curr_amt (total).

                            /* Display customer header line */
                            if new_cust
                               and age_amt[age_period] <> 0
/*N169*                     then do with frame b:           */
/*N169*/                    then do with frame b down:
                               new_cust = false.
                               rec_printed = true.
                               name = "".
                               find ad_mstr where ad_addr = ar_bill
                                  no-lock no-wait no-error.

                               cm_recno = recid(cm_mstr).
                               balance = cm_balance.

                               /* SS - 20070208.1 - B */
                               /*
                               if available ad_mstr then name = ad_name.
                               if page-size - line-counter < 4 then page.

                               /* SET EXTERNAL LABELS */
                               setFrameLabels(frame b:handle).
                               display ar_bill no-label
                                       name no-label
                                       ad_state
                                       cm_pay_date
                                       ad_attn label {&arcsrp5a_p_23}
                                       ad_phone label {&arcsrp5a_p_4}
                                       ad_ext no-label
                               with frame b side-labels width 132.
                               if show_mstr_comments then do:
                                  {gpcdprt.i &type = mstr_type &ref = cm_addr
                                            &lang = mstr_lang &pos = 10}
                               end.
                               if summary_only = no then down 1.
                               */
                               /* SS - 20070208.1 - E */
                            end. /* if new_cust ... */

                            if summary_only = no and age_amt[age_period] <> 0
                               then do with frame c:

                               /* SS - 20070208.1 - B */
                               CREATE tta6arcsrp0504.
                               ASSIGN
                                  tta6arcsrp0504_bill = ar_bill
                                  tta6arcsrp0504_ar_nbr = ar_nbr
                                  tta6arcsrp0504_ar_type = ar_type
                                  .

                               if ar_type <> "P" THEN DO:
                                  ASSIGN
                                     tta6arcsrp0504_nbr = ar_nbr
                                     tta6arcsrp0504_type = ar_type
                                     .
                               END.
                               ELSE DO:
                                  ASSIGN
                                     tta6arcsrp0504_nbr = ar_check
                                     tta6arcsrp0504_type = "U"
                                     .
                               END.
         
                               IF ar_type <> "P" THEN DO:
                                   ASSIGN
                                       tta6arcsrp0504_acct = ar_acct
                                       tta6arcsrp0504_sub = ar_sub
                                       tta6arcsrp0504_cc = ar_cc
                                       .
                               END.
                               ELSE DO:
                                   FIND FIRST bard
                                       WHERE bard.ard_nbr = ar_nbr 
                                       AND bard.ard_ref = "" 
                                       AND bard.ard_type = "U" 
                                       AND bard.ard_entity >= entity
                                       and bard.ard_entity <= entity1
                                       and bard.ard_acct   >= acct
                                       and bard.ard_acct   <= acct1
                                       and bard.ard_sub    >= sub
                                       and bard.ard_sub    <= sub1
                                       and bard.ard_cc     >= cc
                                       and bard.ard_cc     <= cc1
                                       NO-LOCK 
                                       NO-ERROR
                                       .
                                   IF AVAILABLE bard THEN DO:
                                       ASSIGN
                                           tta6arcsrp0504_acct = bard.ard_acct
                                           tta6arcsrp0504_sub = bard.ard_sub
                                           tta6arcsrp0504_cc = bard.ard_cc
                                           .
                                   END.
                                   ELSE DO:
                                       ASSIGN
                                           tta6arcsrp0504_acct = ar_acct
                                           tta6arcsrp0504_sub = ar_sub
                                           tta6arcsrp0504_cc = ar_cc
                                           .
                                   END.
                               END.
         
                               if not multi-due
                               then
                                   ASSIGN
                                   tta6arcsrp0504_effdate = ar_effdate
                                   tta6arcsrp0504_due_date = ar_due_date
                                   tta6arcsrp0504_date = ar_date
                                   .
                               else
                                   ASSIGN
                                       tta6arcsrp0504_effdate = ar_effdate
                                       tta6arcsrp0504_date = ar_date
                                       .

                               if not show_pay_detail
                                  or ar_type = "P"
                               then do:
                                   ASSIGN
                                       tta6arcsrp0504_et_age_amt[1] = et_age_amt[1]
                                       tta6arcsrp0504_et_age_amt[2] = et_age_amt[2]
                                       tta6arcsrp0504_et_age_amt[3] = et_age_amt[3]
                                       tta6arcsrp0504_et_age_amt[4] = et_age_amt[4]
                                       tta6arcsrp0504_et_age_amt[5] = et_age_amt[5]
                                       tta6arcsrp0504_et_age_amt[6] = et_age_amt[6]
                                      tta6arcsrp0504_et_age_amt[7] = et_age_amt[7]
                                      tta6arcsrp0504_et_age_amt[8] = et_age_amt[8]
                                      tta6arcsrp0504_et_age_amt[9] = et_age_amt[9]
                                       tta6arcsrp0504_amt = (et_base_amt - et_base_applied)
                                       tta6arcsrp0504_ar_curr = ar_curr
                                       .
                               end. /* IF NOT show_pay_detail */
                               /* TODO */

                               /*
/*N0VV*/                       {&ARCSRP5A-P-TAG11}
                               if ar_type <> "P" then display ar_nbr ar_type.
                               else display ar_check @ ar_nbr "U" @ ar_type.
/*N0VV*/                       {&ARCSRP5A-P-TAG12}

                               if not multi-due then
                                  display ar_effdate
                                          ar_due_date
                                          ar_date
                                          ar_cr_terms
                                          ar_dun_level.
                               else
                                  display ar_effdate
/*N0CL*                                   {&arcsrp5a_p_38} @ ar_due_date */
/*N0CL*/                             getTermLabel("MULTIPLE",8) @ ar_due_date
                                     ar_date
                                     ar_cr_terms
                                     ar_dun_level.

                               if not show_pay_detail or ar_type = "P" then do:
                                  display
/*L00S*                              age_amt[1 for 4] */
/*L00S*/                             et_age_amt[1 for 4]
/*L00S*                              (base_amt - base_applied) */
/*L00S*/                             (et_base_amt - et_base_applied)
                                     @ ar_amt.
                                  down 1.
                               end.
                               else do:
                                  display
/*L00S*                              age_amt[1 for 4] */
/*L00S*/                             et_age_amt[1 for 4]
/*L00S*                              base_amt */
/*L00S*/                             et_base_amt
                                     @ ar_amt.
                                  down 1.
                                  if base_applied <> 0 then do:
/*L00S*                              display age_paid[1] @ age_amt[1]*/
/*L00S*                                 age_paid[2] @ age_amt[2]    */
/*L00S*                                 age_paid[3] @ age_amt[3]    */
/*L00S*                                 age_paid[4] @ age_amt[4]    */
/*L00S*                                 base_applied * (-1) @ ar_amt.  */
/*L00S*/                             display et_age_paid[1] @ et_age_amt[1]
/*L00S*/                                et_age_paid[2] @ et_age_amt[2]
/*L00S*/                                et_age_paid[3] @ et_age_amt[3]
/*L00S*/                                et_age_paid[4] @ et_age_amt[4]
/*L00S*/                                et_base_applied * (-1) @ ar_amt.
                                     down 1.
                                     /* SHOW PAYMENT DETAIL */
                                     for each ard_det where ard_ref = ar_nbr
                                        no-lock with frame c:
                                        find armstr where armstr.ar_nbr =
                                           ard_nbr
                                           and armstr.ar_effdate <= effdate1
                                           no-lock no-error.
                                        if available armstr then do:
                                           if (armstr.ar_type = "P"
                                           or  armstr.ar_type = "D"
                                           or  armstr.ar_type = "A")
                                           then do:

                                              display armstr.ar_type
/*N0ZX*/                                         {&ARCSRP5A-P-TAG15}
                                                 @ ar_mstr.ar_type
/*N0ZX*/                                         {&ARCSRP5A-P-TAG16}
                                                 armstr.ar_effdate
                                                 @ ar_mstr.ar_effdate
                                                 armstr.ar_check
                                                 @ ar_mstr.ar_cr_terms.
                                              down 1.
                                           end. /* if (armstr.ar_type = "P" */
                                        end. /* if available armstr ... */
                                     end. /* for each ard_det ... */
                                  end. /* if base_applied <> 0 */
                               end. /* else do: */
                               if show_po and ar_po <> "" then put ar_po at 10.
                               /* DISPLAY DOCUMENT COMMENTS */
                               if show_comments and ar_cmtindx <> 0 then do:
                                  {arcscmt.i &cmtindx = ar_cmtindx
                                     &subhead = "ar_nbr format ""X(8)"" "}
                               end.
                               */
                               /* SS - 20070208.1 - E */
                            end. /* if summary_only ... */
                            if summary_only then
                               /* SAVE HIGHEST DUNNING LEVEL */
                               /* FOR THIS CUSTOMER */
                               if ar_dun_level > high_dun_level then
                                   high_dun_level = ar_dun_level.
                         end. /* if base_amt ... */
                      end.  /* use_rec block */

                      /* SS - 20070208.1 - B */
                      /*
                      /* CUSTOMER TOTALS */
                      if last-of(ar_bill) and rec_printed then do:
                         rec_printed = false.
                         if summary_only = no then do:
                            if page-size - line-counter < 2 then page.
/*L00S*                     underline age_amt ar_amt. */
/*L00S*/                    underline et_age_amt ar_amt.
                         end.

/*L00S*BEGIN DELETE
 *                       if base_rpt = ""
 *                       then
 *                          tempstr = "    " + "Base Customer Totals:".
 *                       else
 *                          tempstr = "     " + base_rpt
 *                                  + " Customer Totals:".
 *
 *                       /* DETAIL REPORT SHOWS DUNNING LEVEL FOR EACH ITEM. */
 *                       /* SUMMARY REPORT SHOWS HIGHEST DUNNING LEVEL. */
 *                       disp_dun_level =
 *                          (if summary_only
 *                           and high_dun_level <> 0
 *                           then high_dun_level else 0).
 *
 *                       put tempstr
 *                          disp_dun_level
 *                          to 49
 *                          accum total by ar_bill (sum_amt[1])
 *                          to 65
 *                          format "->>>>,>>>,>>9.99"
 *                          accum total by ar_bill (sum_amt[2])
 *                          to 81
 *                          format "->>>>,>>>,>>9.99"
 *                          accum total by ar_bill (sum_amt[3])
 *                          to 97
 *                          format "->>>>,>>>,>>9.99"
 *                          accum total by ar_bill (sum_amt[4])
 *                          to 113
 *                          format "->>>>,>>>,>>9.99"
 *                          accum total by ar_bill (base_amt - base_applied)
 *                          to 130
 *                          format "->>>>,>>>,>>9.99".
 *L00S*END DELETE*/

/*L02Q* /*L00S*/         display "    " + et_disp_curr @ ar_nbr */

/*N0CL* ------------------- BEGIN DELETE ----------------------- *
 * /*L02Q*/                 display "    " + et_report_curr @ ar_nbr
 * /*L059* /*L00S*/           "Customer" @ ar_effdate "Totals:" @ ar_cr_terms */
 * /*L059*/                   {&arcsrp5a_p_39} @ ar_effdate
 * /*L059*/                   {&arcsrp5a_p_40} @ ar_cr_terms
 *N0CL* ------------------- END   DELETE ----------------------- */

/*N0CL* ------------------- BEGIN ADD ----------------------- */
                         display "    " + et_report_curr @ ar_nbr
                           getTermLabel("CUSTOMER",8) @ ar_effdate
                           getTermLabelRtColon("TOTALS",8) @ ar_cr_terms
/*N0CL* ------------------- END   ADD ----------------------- */

/*L00S*BEGIN ADD */
                            accum total by ar_bill (et_sum_amt[1])
                            @ et_age_amt[1]
                            accum total by ar_bill (et_sum_amt[2])
                            @ et_age_amt[2]
                            accum total by ar_bill (et_sum_amt[3])
                            @ et_age_amt[3]
                            accum total by ar_bill (et_sum_amt[4])
                            @ et_age_amt[4]
                            accum total by ar_bill
                            (et_base_amt - et_base_applied)
                            @ ar_amt.
                         down 1.
/*L00S*END ADD*/
                      end.  /* CUSTOMER TOTALS */
                      */
                      /* SS - 20070208.1 - E */
                   end.  /* IF LSTYPE */
                end. /* FOR EACH AR_MSTR */

                {mfrpexit.i}
             end. /* FOR EACH CM_MSTR */

             /* SS - 20070208.1 - B */
             /*
             /* REPORT TOTALS */
             if page-size - line-counter < 3 then page.
             else down 2.
/*L00S*      underline age_amt ar_amt.  */
/*L00S*/     underline et_age_amt ar_amt.

/*L00S*BEGIN DELETE
 *           if base_rpt = ""
 *           then
 *              tempstr = "    " + {&arcsrp5a_p_17}.
 *           else
 *              tempstr = "     " + base_rpt
 *                      + {&arcsrp5a_p_37}.
 *           put tempstr
 *              accum total (sum_amt[1])
 *              to 65
 *              format "->>>>,>>>,>>9.99"
 *              accum total (sum_amt[2])
 *              to 81
 *              format "->>>>,>>>,>>9.99"
 *              accum total (sum_amt[3])
 *              to 97
 *              format "->>>>,>>>,>>9.99"
 *              accum total (sum_amt[4])
 *              to 113
 *              format "->>>>,>>>,>>9.99"
 *              accum total (base_amt - base_applied)
 *              to 130
 *              format "->>>>,>>>,>>9.99".
 *L00S*END DELETE*/

/*N0CL* ------------------- BEGIN DELETE ----------------------- *
 * /*L00S*/     display
 * /*L02Q* /*L00S*/"    " + et_disp_curr @ ar_nbr */
 * /*L02Q*/        "    " + et_report_curr @ ar_nbr
 * /*L059* /*L00S*/       "Report" @ ar_effdate "Totals:" @ ar_cr_terms */
 * /*L059*/               {&arcsrp5a_p_41} @ ar_effdate
 * /*L059*/               {&arcsrp5a_p_40} @ ar_cr_terms
 *N0CL* ------------------- END   DELETE ----------------------- */

/*N0CL* ------------------- BEGIN ADD ----------------------- */
             display
                "    " + et_report_curr @ ar_nbr
                           getTermLabel("REPORT",8) @ ar_effdate
                           getTermLabelRtColon("TOTALS",8) @ ar_cr_terms
/*N0CL* ------------------- END   ADD ----------------------- */

/*L00S*BEGIN ADD */
                accum total (et_sum_amt[1]) @ et_age_amt[1]
                accum total (et_sum_amt[2]) @ et_age_amt[2]
                accum total (et_sum_amt[3]) @ et_age_amt[3]
                accum total (et_sum_amt[4]) @ et_age_amt[4]
                accum total (et_base_amt - et_base_applied) @ ar_amt.
             down 1.

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
/*L02Q*/              {mfmsg.i mc-error-number 3}
/*L02Q*/           end.
/*L02Q*/        end.  /* do i = 1 to 4 */
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
/*L02Q*/           {mfmsg.i mc-error-number 3}
/*L02Q*/        end.
/*L02Q*/     end.  /* if et_report_curr <> mc-rpt-curr */

             if et_show_diff and
             (
             (((accum total (et_sum_amt[1]))
             - (et_org_sum_amt[1]))  <> 0) or
             (((accum total (et_sum_amt[2]))
             - (et_org_sum_amt[2]))  <> 0) or
             (((accum total (et_sum_amt[3]))
             - (et_org_sum_amt[3]))  <> 0) or
             (((accum total (et_sum_amt[4]))
             - (et_org_sum_amt[4]))  <> 0) or
             (((accum total (et_base_amt - et_base_applied))
             - (et_org_amt))         <> 0)
             )
             then
                /* DISPLAY DIFFRENCCES */
                put et_diff_txt
/*L02Q*/           format "x(40)" to 44 ":" to 45
/*L02Q*            to 27 */
                   ((accum total et_sum_amt[1]) - et_org_sum_amt[1])
/*L02Q*            at 54 */
/*L02Q*/           to 65
                   ((accum total et_sum_amt[2]) - et_org_sum_amt[2])
/*L02Q*            at 71 */
/*L02Q*/           to 81
                   ((accum total et_sum_amt[3]) - et_org_sum_amt[3])
/*L02Q*            at 88 */
/*L02Q*/           to 97
                   ((accum total et_sum_amt[4]) - et_org_sum_amt[4])
/*L02Q*            at 105 */
/*L02Q*/           to 113
                   ((accum total (et_base_amt -  et_base_applied)) -
                   et_org_amt)
/*L02Q*            at 122. */
/*L02Q*/           to 130.
             down 1.
/*L00S*END ADD*/
             */
             /* SS - 20070208.1 - E */

          end.  /* SCOPE OF FRAME C */

          /* SS - 20070208.1 - B */
          /*
          /* DISPLAY SUMMARY TOTAL INFORMATION */
          if page-size - line-counter < 9 then page.
          else down 2.

/*L00S*BEGIN DELETE
 *        display "Invoices:"           to 34  accum total (inv_tot) at 35
 *                                             format "->>>,>>>,>>>,>>9.99"
 *                "Dr/Cr Memos:"        to 34  accum total (memo_tot) at 35
 *                                             format "->>>,>>>,>>>,>>9.99"
 *                "Finance Charges:"    to 34  accum total (fc_tot) at 35
 *                                             format "->>>,>>>,>>>,>>9.99"
 *                "Unapplied Payments:" to 34  accum total (paid_tot) at 35
 *                                             format "->>>,>>>,>>>,>>9.99"
 *                "Drafts:"             to 34  accum total (drft_tot) at 35
 *                                             format "->>>,>>>,>>>,>>9.99"
 *                  (if base_rpt = "") at 35
 *                   then "Total Base Aging:"
 *                   else " Total " + base_rpt + " Aging:")
 *                                             format "x(17)" to 34
 *                accum total (base_amt - base_applied) at 35
 *                                             format "x(17)" to 34
 *                accum total (base_amt - base_applied) at 35
 *                format "->>>,>>>,>>>,>>9.99"
 *L00S*END DELETE */

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
                 input true,  /* ROUND */
                 output et_org_inv_tot,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 3}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_memo_tot,
                 input true,  /* ROUND */
                 output et_org_memo_tot,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 3}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_fc_tot,
                 input true,  /* ROUND */
                 output et_org_fc_tot,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 3}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_paid_tot,
                 input true,  /* ROUND */
                 output et_org_paid_tot,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 3}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_drft_tot,
                 input true,  /* ROUND */
                 output et_org_drft_tot,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 3}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_curr_amt,
                 input true,  /* ROUND */
                 output et_org_curr_amt,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 3}
/*L02Q*/     end.
/*L02Q*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input et_org_amt,
                 input true,  /* ROUND */
                 output et_org_amt,
                 output mc-error-number)"}
/*L02Q*/     if mc-error-number <> 0 then do:
/*L02Q*/        {mfmsg.i mc-error-number 3}
/*L02Q*/     end.
/*L02Q*/  end.  /* if et_report_curr <> mc-rpt-curr */

          assign et_diff_exist = false.

          if et_show_diff and
          ((((accum total et_inv_tot) - et_org_inv_tot)    <> 0) or
          (((accum total et_memo_tot) - et_org_memo_tot)   <> 0) or
          (((accum total et_fc_tot)   - et_org_fc_tot)     <> 0) or
          (((accum total et_paid_tot) - et_org_paid_tot)   <> 0) or
          (((accum total et_drft_tot) - et_org_drft_tot)   <> 0) or
          (((accum total (et_base_amt - et_base_applied))
          - et_org_amt) <> 0) or
          (((accum total et_curr_amt) - et_org_curr_amt)   <> 0) or
          (((( accum total (et_curr_amt))
          - (accum total (et_base_amt - et_base_applied)))
          - (et_org_curr_amt - et_org_amt)) <> 0))
             then assign et_diff_exist = true.

/*N0VV*/  {&ARCSRP5A-P-TAG13}
          display
             et_diff_txt
/*L02Q*      to 96  */
/*L02Q*/     format "x(40)" to 95
             when (et_diff_exist)
/*L02Q*      "Invoices:"           to 34 */
/*N0CL* /*L02Q*/     {&arcsrp5a_p_34} to 34     */
/*N0CL*/     getTermLabelRtColon("INVOICES",33) format "x(33)" to 34
             accum total (et_inv_tot) at 35
             format "->>>,>>>,>>>,>>9.99"
             ((accum total et_inv_tot) - et_org_inv_tot)
             when (et_diff_exist)
/*L02Q*      at 75  */
/*L02Q*/     to 95
             format "->>>,>>>,>>>,>>9.99"
/*L02Q*      "Dr/Cr Memos:"        to 34 */
/*N0CL*  /*L02Q*/     {&arcsrp5a_p_22} to 34  */
/*N0CL*/     getTermLabelRtColon("DR/CR_MEMOS",33) format "x(33)" to 34
             accum total (et_memo_tot) at 35
             format "->>>,>>>,>>>,>>9.99"
             ((accum total et_memo_tot) - et_org_memo_tot)
             when (et_diff_exist)
/*L02Q*      at 75  */
/*L02Q*/     to 95
             format "->>>,>>>,>>>,>>9.99"
/*L02Q*      "Finance Charges:"    to 34 */
/*N0CL* /*L02Q*/     {&arcsrp5a_p_29} to 34        */
/*N0CL*/     getTermLabelRtColon("FINANCE_CHARGES",33) format "x(33)" to 34
             accum total (et_fc_tot) at 35
             format "->>>,>>>,>>>,>>9.99"
             ((accum total et_fc_tot) - et_org_fc_tot)
             when (et_diff_exist)
/*L02Q*      at 75  */
/*L02Q*/     to 95
             format "->>>,>>>,>>>,>>9.99"
/*L02Q*      "Unapplied Payments:" to 34 */
/*N0CL* /*L02Q*/     {&arcsrp5a_p_5} to 34  */
/*N0CL*/     getTermLabelRtColon("UNAPPLIED_PAYMENTS",33) format "x(33)" to 34
             accum total (et_paid_tot) at 35
             format "->>>,>>>,>>>,>>9.99"
             ((accum total et_paid_tot) - et_org_paid_tot)
             when (et_diff_exist)
/*L02Q*      at 75  */
/*L02Q*/     to 95
             format "->>>,>>>,>>>,>>9.99"
/*L02Q*      "Drafts:"             to 34 */
/*N0CL* /*L02Q*/     {&arcsrp5a_p_25} to 34      */
/*N0CL*/     getTermLabelRtColon("DRAFTS",33) format "x(33)" to 34
             accum total (et_drft_tot) at 35
             format "->>>,>>>,>>>,>>9.99"
             ((accum total et_drft_tot) - et_org_drft_tot)
             when (et_diff_exist)
/*L02Q*      at 75  */
/*L02Q*/     to 95
             format "->>>,>>>,>>>,>>9.99"
/*L02Q*      "Total " + et_disp_curr + fill(" ",4 - length(base_rpt)) */
/*L02Q*      + " Aging:" format "x(17)" to 34 */
/*N0CL* /*L02Q*/     {&arcsrp5a_p_35} + et_report_curr + {&arcsrp5a_p_15} */
/*N0CL*/     getTermLabelRt("TOTAL",10) + " " +
/*N0CL*/     et_report_curr  + " " +
/*N0CL*/     getTermLabelRtColon("AGING",6)
/*L02Q*/     format "x(21)" to 34
             accum total (et_base_amt - et_base_applied) at 35
             format "->>>,>>>,>>>,>>9.99"
             ((accum total (et_base_amt - et_base_applied)) -
             et_org_amt) when (et_diff_exist)
/*L02Q*      at 75  */
/*L02Q*/     to 95
             format "->>>,>>>,>>>,>>9.99"
/*L00S*END ADD*/

          with frame d width 132 no-labels.

          if base_rpt = "" then
             display
/*N0CL*              {&arcsrp5a_p_14} + string(effdate1) + {&arcsrp5a_p_33}  */

/*N0CL*/             getTermLabel("AGING_AT",8) + " " +
/*N0CL*/             string(effdate1)           + " " +
/*N0CL*/             getTermLabelRtColon("EXCHANGE_RATE",14)
                     format "x(32)" to 34
/*L00S               accum total (curr_amt) at 35 */
/*L00S*/             accum total (et_curr_amt) at 35
                     format "->>>,>>>,>>>,>>9.99"
/*L00S*/             ((accum total et_curr_amt) - et_org_curr_amt)
/*L00S*/             when (et_diff_exist)
/*L02Q* /*L00S*/     at 75  */
/*L02Q*/             to 95
/*L00S*/             format "->>>,>>>,>>>,>>9.99"
/*N0CL*              {&arcsrp5a_p_1} + string(effdate1) + {&arcsrp5a_p_18} */

/*N0CL*/             getTermLabel("VARIANCE_OF",11) + " " +
/*N0CL*/             string(effdate1)               + " " +
/*N0CL*/             getTermLabelRtColon("TO_BASE",8)
                     format "x(29)" to 34
/*L00S*              (accum total (curr_amt)) -                    */
/*L00S*              (accum total (base_amt - base_applied)) at 35 */
/*L00S*/             (accum total (et_curr_amt)) -
/*L00S*/             (accum total (et_base_amt - et_base_applied)) at 35
                     format "->>>,>>>,>>>,>>9.99"
/*L00S*/             ((( accum total (et_curr_amt))
/*L00S*/             -  (accum total (et_base_amt - et_base_applied))
/*L00S*/             ) -
/*L00S*/             (et_org_curr_amt - et_org_amt)
/*L00S*/             ) when (et_diff_exist)
/*L02Q* /*L00S*/     at 75  */
/*L02Q*/             to 95
/*L00S*/             format "->>>,>>>,>>>,>>9.99"
             with frame d width 132 no-labels.

             hide frame phead1.
/*L02Q*      {wbrp04.i} */
/*N0VV*/  {&ARCSRP5A-P-TAG14}
*/
/* SS - 20070208.1 - E */
