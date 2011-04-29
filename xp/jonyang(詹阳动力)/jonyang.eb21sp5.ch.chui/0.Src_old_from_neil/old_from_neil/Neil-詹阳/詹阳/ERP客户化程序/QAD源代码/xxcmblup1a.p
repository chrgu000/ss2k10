/* arcsrp1a.p - AR AGING REPORT FROM DUE DATE SUBROUTINE                      */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.19.1.15 $                                                     */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0      LAST MODIFIED: 08/30/90   BY: afs *D059*                */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: afs *D066*                */
/* REVISION: 6.0      LAST MODIFIED: 10/16/90   BY: afs *D101*                */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   by: afs *D283*                */
/* REVISION: 6.0      LAST MODIFIED: 03/30/91   by: bjb *D507*                */
/* REVISION: 6.0      LAST MODIFIED: 06/24/91   by: afs *D723*                */
/* REVISION: 6.0      LAST MODIFIED: 07/12/91   by: afs *D760*                */
/* REVISION: 7.0      LAST MODIFIED: 11/25/91   by: afs *F041*                */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   by: jjs *F237*                */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   by: tmd *F288*                */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   by: tjs *F337*                */
/*                                   05/12/92   by: jms *F481*                */
/*                                   06/18/92   by: jjs *F670*                */
/*                                   07/29/92   by: jms *F829*                */
/*                                   09/03/92   by: afs *G045*                */
/* REVISION: 7.3      LAST MODIFIED: 09/28/92   by: mpp *G476*                */
/*                                   10/13/94   by: str *FS40*                */
/*                                   12/29/94   by: str *F0C3*                */
/*                                   08/22/95   by: wjk *F0TH*                */
/*                                   01/31/96   by: mys *F0WY*                */
/* REVISION: 8.5      LAST MODIFIED: 12/08/95   BY: taf *J053*                */
/*                                   04/08/96   BY: jzw *G1P6*                */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*                */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   by: jzw *K00B*                */
/*                                   10/08/96   by: jzw *K00W*                */
/* REVISION: 8.6      LAST MODIFIED: 08/30/97   BY: *H1DT* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: bvm *K0PN*                */
/* REVISION: 8.6      LAST MODIFIED: 01/06/98   BY: *J295* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00M* D. Sidel           */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   BY: *K1SG* Ashok Swaminathan  */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L02Q* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L059* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 08/24/98   BY: *L079* Brenda Milton      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/07/00   BY: *N0CL* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 08/04/00   BY: *N0VV* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.19.1.11   BY: Jean Miller       DATE: 01/04/02  ECO: *P03Y*    */
/* Revision: 1.19.1.12   BY: Ed van de Gevel   DATE: 05/28/03  ECO: *N2BR*    */
/* Revision: 1.19.1.14   BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B*    */
/* $Revision: 1.19.1.15 $ BY: Ajay Nair        DATE: 10/26/05  ECO: *P468*    */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ARCSRP1A.P"}
{gplabel.i}

define variable rndmthd like rnd_rnd_mthd.
define variable oldcurr like ar_curr.
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

define shared variable acct like ar_acct.
define shared variable acct1 like ar_acct.
define shared variable sub like ar_sub.
define shared variable sub1 like ar_sub.
define shared variable cc like ar_cc.
define shared variable cc1 like ar_cc.
define shared variable name like ad_name.
define shared variable age_days  as integer   extent 5 label "Column Days".
define shared variable age_range as character extent 5 format "x(15)".
define shared variable i as integer.
define shared variable age_amt like ar_amt format "->>>,>>>,>>9.99"
   extent 5.
define shared variable age_period as integer.
define shared variable cm_recno as recid.
define shared variable balance  like cm_balance.
define shared variable age_paid like ar_amt extent 5.
define shared variable sum_amt  like ar_amt extent 5.
define shared variable show_pay_detail like mfc_logical.
define shared variable summary_only    like mfc_logical.
define shared variable show_po         like mfc_logical.
define shared variable inv_tot  like ar_amt.
define shared variable memo_tot like ar_amt.
define shared variable fc_tot   like ar_amt.
define shared variable paid_tot like ar_amt.
define shared variable drft_tot like ar_amt.
define shared variable base_amt like ar_amt.
define shared variable base_applied like ar_applied.
define shared variable base_rpt like ar_curr.
define shared variable age_date like ar_due_date label "Aging Date"
   initial today.
define shared variable due-date like ar_date.
define shared variable applied-amt like ar_applied.
define shared variable amt-due like ar_amt.
define shared variable this-applied like ar_applied.
define shared variable multi-due like mfc_logical.
define shared variable deduct_contest like mfc_logical.
define shared variable curr_amt like ar_amt.
define shared variable show_comments like mfc_logical.
define shared variable show_mstr_comments like mfc_logical.
define shared variable mstr_type like cd_type initial "AR".
define shared variable mstr_lang like cd_lang.
define variable new_cust as logical initial true.
define variable use_rec as logical initial false.
define variable rec_printed as logical initial false.
define shared variable entity like gl_entity.
define shared variable entity1 like gl_entity.
define shared variable lstype like ls_type.
define buffer payment for ar_mstr.
define buffer armstr for ar_mstr.
define variable u_amt like base_amt.
define variable u_applied like base_amt.

define variable exdrate like exr_rate no-undo.
define variable exdrate2 like exr_rate no-undo.
define variable exdratetype like exr_ratetype no-undo.
define variable tempstr as character format "x(25)".
define variable high_dun_level like ar_dun_level.
define variable disp_dun_level like ar_dun_level format ">>" no-undo.
define variable total-amt like ar_amt no-undo.

define shared variable mc-rpt-curr like ar_curr no-undo.

{etrpvar.i }
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

define variable et_diff_exist    like mfc_logical initial false.

{&ARCSRP1A-P-TAG3}

{mfphead.i}

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock. /*for
rounding after currency conversion*/

/* CREATE REPORT HEADER */
do i = 1 to 4:
   age_range[i] = getTermLabelRt("TO",7) +
   string(age_days[i],"->>>9").
end.

age_range[5] = getTermLabelRt("OVER",8) + string(age_days[4],"->>>9").

form
   header
   getTermLabel("AGING_DATE",10)  format "x(10)" at 1
   age_date       skip
   space (29)
   getTermLabel("DUNNING",2) format "x(2)" /* FOR DUNNING LEVEL */
   age_range[1 for 5]   skip
   getTermLabel("REFERENCE",8)
   getTermLabel("TYPE",1) format "x(1)"
   getTermLabel("DUE_DATE",8)
   getTermLabel("CREDIT_TERMS",8)
   getTermLabel("LEVEL",2)  format "x(2)" /* FOR DUNNING LEVEL */
   getTermLabelCentered("DAYS_OLD",15) format "x(15)"
   getTermLabelCentered("DAYS_OLD",15) format "x(15)"
   getTermLabelCentered("DAYS_OLD",15) format "x(15)"
   getTermLabelCentered("DAYS_OLD",15) format "x(15)"
   getTermLabelCentered("DAYS_OLD",15) format "x(15)"
   getTermLabelRt("TOTAL_AMOUNT",16)   format "x(16)"
   skip
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

oldcurr = "".

do with frame c down no-box:

   for each cm_mstr  where cm_mstr.cm_domain = global_domain and
      (cm_addr >= cust) and (cm_addr <= cust1) and
      (cm_type >= cust_type) and (cm_type <= cust_type1)
   no-lock by cm_sort:

      high_dun_level = 0.

      /* MODIFIED THE SELECTION CRITERIA OF THE FOR EACH ar_mstr */
      /* LOOP TO INCLUDE ALL THE 4 SALESPERSONS                  */
      for each ar_mstr  where ar_mstr.ar_domain = global_domain and (
             (ar_bill = cm_addr)
         and (ar_nbr >= nbr) and (ar_nbr <= nbr1)
         and ((ar_slspsn[1] >= slspsn and ar_slspsn[1] <= slspsn1)
          or  (ar_slspsn[2] >= slspsn and ar_slspsn[2] <= slspsn1)
          or  (ar_slspsn[3] >= slspsn and ar_slspsn[3] <= slspsn1)
          or  (ar_slspsn[4] >= slspsn and ar_slspsn[4] <= slspsn1))
         and (ar_type = "P" or
             (ar_entity >= entity and ar_entity <= entity1))
         and (ar_amt - ar_applied <> 0)
         and (ar_type = "P" or ar_due_date = ?
          or (ar_due_date >= due_date and ar_due_date <= due_date1))
         and (not ar_type = "D" or ar_draft = true)
         and ((ar_curr = base_rpt) or  (base_rpt = ""))
         and ((deduct_contest and ar_contested = no) or (not deduct_contest))
      ) no-lock break by ar_bill by ar_nbr with frame c
      width 132 no-labels:

         if lstype = "" or
            (lstype <> "" and can-find(first ls_mstr
                 where ls_mstr.ls_domain = global_domain and  ls_type = lstype
                 and ls_addr = cm_addr))
         then do:

            if (oldcurr <> ar_curr)  or (oldcurr = "") then do:
               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input ar_curr,
                    output rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
                  pause 0.
                  leave.
               end.
               oldcurr = ar_curr.
            end.  /* if lstype = "" or ... */

            /* Store first customer information in a logical, since */
            /* The account validation may cause the actual first    */
            /* Record to be skipped.                                */
            if first-of(ar_bill) then new_cust = true.

            /* Validate the AR account (if range specified) */
            use_rec = true.

            if (acct <> "" or acct1 <> hi_char)
            or (sub <> "" or sub1 <> hi_char)
            or (cc <> "" or cc1 <> hi_char)
            or (entity <> "" or entity1 <> hi_char)
            then do:

               if ar_type <> "P" then do:
                  if (ar_acct < acct or ar_acct > acct1)
                  or (ar_sub < sub or ar_sub > sub1)
                  or (ar_cc < cc or ar_cc > cc1)
                  then
                     use_rec = false.
               end.

               /* Payments: if unapplied, get the detail to determine */
               /*           the application account                   */
               else do:

                  assign
                     use_rec = false
                     u_amt = 0
                     u_applied = 0.

                  for each ard_det  where ard_det.ard_domain = global_domain
                  and
                           ard_nbr = ar_nbr
                       and ard_type = "U"
                       and ard_ref = ""
                  no-lock:
                     if (ard_acct >= acct and ard_acct <= acct1) and
                        (ard_sub >= sub and ard_sub <= sub1) and
                        (ard_cc >= cc and ard_cc <= cc1) and
                        (ard_entity >= entity and ard_entity <= entity1)
                     then do:
                        use_rec = true.
                        u_amt = u_amt - ard_amt - ard_disc.
                     end.
                  end.

                  for each armstr  where armstr.ar_domain = global_domain and
                           armstr.ar_check = ar_mstr.ar_check and
                           armstr.ar_bill = ar_mstr.ar_bill and
                           armstr.ar_type = "A"
                  no-lock:
                     for each ard_det  where ard_det.ard_domain = global_domain
                     and  ard_nbr  = armstr.ar_nbr
                     no-lock:
                        u_applied = u_applied - ard_amt.
                     end.
                  end.

               end.

            end.

            else if ar_type = "P" then do:
               u_amt = ar_amt.
               u_applied = ar_applied.
            end.

            if use_rec then do:

               form
                  ar_nbr       format "x(8)"
                  ar_type
                  ar_due_date
                  ar_cr_terms
                  ar_dun_level format ">>"
                  et_age_amt
                  ar_amt
               with frame c width 132.

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame c:handle).

               do i = 1 to 5:
                  assign
                     et_age_amt[i]  = 0
                     et_age_paid[i] = 0
                     et_sum_amt[i]  = 0
                     age_amt[i]  = 0
                     age_paid[i] = 0
                     sum_amt[i]  = 0.
               end.

               {&ARCSRP1A-P-TAG4}

               if new_cust then do with frame b:

                  rec_printed = true.
                  name = "".

                  find ad_mstr  where ad_mstr.ad_domain = global_domain and
                  ad_addr = ar_bill
                  no-lock no-wait no-error.

                  cm_recno = recid(cm_mstr).
                  balance = cm_balance.

                  if available ad_mstr then
                     name = ad_name.

                  if page-size - line-counter < 4 then page.

                  /* SET EXTERNAL LABELS */
                  setFrameLabels(frame b:handle).

                  display
                     ar_bill  no-label
                     name     no-label
                     ad_state
                     cm_pay_date
                     ad_attn  label "Attn"
                     ad_phone label "Tel"
                     ad_ext   no-label
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

               if base_rpt = "" and ar_curr <> base_curr
               then do:

                  assign
                     base_amt = ar_base_amt
                     base_applied = ar_base_applied.

                  /* GET EXCHANGE RATE */
                  /* REVERSED AR_CURR AND BASE_CURR BELOW */
                  {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                     "(input ar_curr,
                       input base_curr,
                       input exdratetype,
                       input age_date,
                       output exdrate,
                       output exdrate2,
                       output mc-error-number)"}

                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  if mc-error-number = 0 then do:
                     /* REVERSED AR_CURR AND BASE_CURR BELOW */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input ar_curr,
                          input base_curr,
                          input exdrate,
                          input exdrate2,
                          input curr_amt,
                          input true,  /* ROUND */
                          output curr_amt,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.
                  end.  /* if mc-error-number = 0 */

                  /* If no exchange rate for today, use the */
                  /* invoice rate */
                  else do:

                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input ar_curr,
                          input base_curr,
                          input ar_ex_rate,
                          input ar_ex_rate2,
                          input curr_amt,
                          input true, /* ROUND */
                          output curr_amt,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                  end.  /* else do */

               end.  /* if base_rpt = "" and ar_curr <> base_curr */

               multi-due = no.

               /*CHECK FOR CREDIT DATING TERMS */
               find ct_mstr  where ct_mstr.ct_domain = global_domain and
               ct_code = ar_cr_terms
               no-lock no-error.

               if available ct_mstr and ct_dating = yes then do:

                  assign
                     multi-due = yes
                     applied-amt = base_applied
                     total-amt = 0.

                  for each ctd_det  where ctd_det.ctd_domain = global_domain
                  and  ctd_code = ar_cr_terms
                  no-lock break by ctd_code:

                     find ct_mstr  where ct_mstr.ct_domain = global_domain and
                     ct_code = ctd_date_cd
                     no-lock no-error.

                     if available ct_mstr then do:

                        {&ARCSRP1A-P-TAG1}
                        if (ct_due_inv = 1) then
                           due-date  = ar_date + ct_due_days.
                        else    /* FROM END OF MONTH */
                           due-date = date((month(ar_date) + 1) modulo 12
                                      + if month(ar_date) = 11 then 12
                                        else 0, 1, year(ar_date)
                                      + if month(ar_date) >= 12 then 1
                                        else 0)
                                      + integer(ct_due_days)
                                      - if ct_due_days <> 0 then 1
                                        else 0.

                        if ct_due_date <> ? then
                           due-date = ct_due_date.
                        {&ARCSRP1A-P-TAG2}

                        /* CALCULATE AMT-DUE LESS THE APPLIED FOR THIS SEGMENT*/
                        /* TO PREVENT ROUNDING ERRORS ASSIGN LAST   */
                        /* BUCKET = ROUNDED TOTAL - RUNNING TOTAL */
                        if last-of(ctd_code) then
                           amt-due = base_amt - total-amt.
                        else
                           amt-due = base_amt * (ctd_pct_due / 100).

                        if base_rpt = "" and ar_curr <> base_curr
                        then do:
                           /* ROUND PER BASE ROUND METHOD */
                           {gprunp.i "mcpl" "p" "mc-curr-rnd"
                              "(input-output amt-due,
                                input gl_rnd_mthd,
                                output mc-error-number)"}
                           if mc-error-number <> 0 then do:
                              {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                           end.
                        end.
                        else do:
                           /* ROUND PER AR_CURR ROUND METHOD */
                           {gprunp.i "mcpl" "p" "mc-curr-rnd"
                              "(input-output amt-due,
                                input rndmthd,
                                output mc-error-number)"}
                           if mc-error-number <> 0 then do:
                              {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                           end.
                        end.

                        total-amt = total-amt + amt-due.

                        if ar_amt >= 0 then
                           this-applied = min(amt-due, applied-amt).
                        else
                           this-applied = max(amt-due, applied-amt).

                        applied-amt = applied-amt - this-applied.

                        age_period = 5.

                        do i = 1 to 5:
                           if (age_date - age_days[i]) <= due-date then
                              age_period = i.
                           if age_period <> 5 then leave.
                        end.

                        if due-date = ? then age_period = 1.

                        age_amt[age_period] = age_amt[age_period] + amt-due.

                        if not show_pay_detail then
                           age_amt[age_period] = age_amt[age_period] -
                                                 this-applied.

                        sum_amt[age_period] = sum_amt[age_period] +
                                              amt-due - this-applied.

                        age_paid[age_period] = age_paid[age_period] +
                                               this-applied.

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

                  if not show_pay_detail or ar_type = "P" then
                     age_amt[age_period] = base_amt - base_applied.
                  else
                     age_amt[age_period] = base_amt.

                  age_paid[age_period] = base_applied * (-1).
                  sum_amt[age_period] = base_amt - base_applied.

               end.  /* CREDIT/DATING BLOCK */

               if summary_only = no then do with frame c:

                  if new_cust then down 1.

                  if ar_type <> "P" then
                     display
                        ar_nbr
                        ar_type.
                  else
                     display
                        ar_check @ ar_nbr
                        "U" @ ar_type.

                  if multi-due = no then
                     display
                        ar_due_date.
                  else
                     display
                        getTermLabel("MULTIPLE",8) @ ar_due_date.

                  display
                     ar_cr_terms
                     ar_dun_level.

               end.

               else
               /* SAVE HIGHEST DUNNING LEVEL FOR THIS CUSTOMER */
               if ar_dun_level > high_dun_level then
                  high_dun_level = ar_dun_level.

               {&ARCSRP1A-P-TAG5}

               if ar_type = "I" then
                  inv_tot = base_amt - base_applied.
               else
                  inv_tot = 0.

               if ar_type = "M" then
                  memo_tot = base_amt - base_applied.
               else
                  memo_tot = 0.

               if ar_type = "F" then
                  fc_tot = base_amt - base_applied.
               else
                  fc_tot = 0.

               if ar_type = "D" then
                  drft_tot = base_amt - base_applied.
               else
                  drft_tot = 0.

               if ar_type = "P" then
                  paid_tot = base_amt - base_applied.
               else
                  paid_tot = 0.

               do i = 1 to 5:
                  if et_report_curr <> mc-rpt-curr then do:
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input sum_amt[i],
                          input true, /* ROUND */
                          output et_sum_amt[i],
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input age_amt[i],
                          input true, /* ROUND */
                          output et_age_amt[i],
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input age_paid[i],
                          input true, /* ROUND */
                          output et_age_paid[i],
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.
                  end.  /* if et_report_curr <> mc-rpt-curr */
                  else
                     assign
                        et_sum_amt[i] = sum_amt[i]
                        et_age_amt[i] = age_amt[i]
                        et_age_paid[i] = age_paid[i].
               end.  /* do i = 1 to 5 */

               if et_report_curr <> mc-rpt-curr then do:
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input base_amt,
                       input true,  /* ROUND */
                       output et_base_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input base_applied,
                       input true,  /* ROUND */
                       output et_base_applied,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input inv_tot,
                       input true,  /* ROUND */
                       output et_inv_tot,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input memo_tot,
                       input true,  /* ROUND */
                       output et_memo_tot,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input fc_tot,
                       input true,  /* ROUND */
                       output et_fc_tot,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input paid_tot,
                       input true,  /* ROUND */
                       output et_paid_tot,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input drft_tot,
                       input true,  /* ROUND */
                       output et_drft_tot,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input curr_amt,
                       input true,  /* ROUND */
                       output et_curr_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
               end.  /* if et_report_curr <> mc-rpt-curr */

               else
                  assign
                     et_base_amt = base_amt
                     et_base_applied = base_applied
                     et_inv_tot = inv_tot
                     et_memo_tot = memo_tot
                     et_fc_tot = fc_tot
                     et_paid_tot = paid_tot
                     et_drft_tot = drft_tot
                     et_curr_amt = curr_amt.

               accumulate et_sum_amt (total by ar_bill).
               accumulate et_base_amt - et_base_applied (total by ar_bill).
               accumulate et_inv_tot  (total).
               accumulate et_memo_tot (total).
               accumulate et_fc_tot   (total).
               accumulate et_paid_tot (total).
               accumulate et_drft_tot (total).
               accumulate et_curr_amt (total).
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
                     display
                        et_age_amt[1 for 5]
                        {&ARCSRP1A-P-TAG6}
                        (et_base_amt - et_base_applied) @ ar_amt.
                        {&ARCSRP1A-P-TAG7}
                     down 1.
                  end.

                  else do:

                     display
                        et_age_amt[1 for 5]
                        {&ARCSRP1A-P-TAG8}
                        et_base_amt @ ar_amt.
                        {&ARCSRP1A-P-TAG9}

                     down 1.

                     if base_applied <> 0 then do:

                        display
                           et_age_paid[1] @ et_age_amt[1]
                           et_age_paid[2] @ et_age_amt[2]
                           et_age_paid[3] @ et_age_amt[3]
                           et_age_paid[4] @ et_age_amt[4]
                           et_age_paid[5] @ et_age_amt[5]
                           et_base_applied * (-1) @ ar_amt.

                        down 1.

                        /* Show payment detail */
                        for each ard_det  where ard_det.ard_domain =
                        global_domain and  ard_ref = ar_nbr
                        no-lock with frame c:

                           find payment  where payment.ar_domain =
                           global_domain and  payment.ar_nbr = ard_nbr
                           no-lock no-error.

                           if available payment then do:
                              display
                                 payment.ar_type    @ ar_mstr.ar_type
                                 payment.ar_effdate @ ar_mstr.ar_due_date
                                 payment.ar_check   @ ar_mstr.ar_cr_terms.
                              down 1.
                           end.

                        end.

                     end.  /* if base_applied <> 0 */

                  end.  /* else do */

                  {&ARCSRP1A-P-TAG10}

                  if show_po and ar_po <> "" then
                     put
                        ar_po at 10.

                  if ar_contested then
                     put
                        getTermLabel("CONTESTED",9) format "x(9)" to 131.

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
                     et_age_amt
                     ar_amt.
               end.

               display
                  "     "  + et_report_curr @ ar_nbr
                  getTermLabel("CUSTOMER",8) @ ar_due_date
                  getTermLabelRtColon("TOTALS",8) @ ar_cr_terms
                  accum total by ar_bill (et_sum_amt[1]) @ et_age_amt[1]
                  accum total by ar_bill (et_sum_amt[2]) @ et_age_amt[2]
                  accum total by ar_bill (et_sum_amt[3]) @ et_age_amt[3]
                  accum total by ar_bill (et_sum_amt[4]) @ et_age_amt[4]
                  accum total by ar_bill (et_sum_amt[5]) @ et_age_amt[5]
                  accum total by ar_bill (et_base_amt - et_base_applied)
                     @ ar_amt.

               down 1.

               /*DETERMINE ORIGINAL TOTALS, NOT YET CONVERTED*/
               assign
                  et_org_sum_amt[1] = accum total by ar_bill sum_amt[1]
                  et_org_sum_amt[2] = accum total by ar_bill sum_amt[2]
                  et_org_sum_amt[3] = accum total by ar_bill sum_amt[3]
                  et_org_sum_amt[4] = accum total by ar_bill sum_amt[4]
                  et_org_sum_amt[5] = accum total by ar_bill sum_amt[5]
                  et_org_amt= accum total by ar_bill (base_amt - base_applied).

               /*CONVERT AMOUNTS*/
               if et_report_curr <> mc-rpt-curr then do:
                  do i = 1 to 5:
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input et_org_sum_amt[i],
                          input true,  /* ROUND */
                          output et_org_sum_amt[i],
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.
                  end.  /* do i = 1 to 5 */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input et_org_amt,
                       input true,  /* ROUND */
                       output et_org_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
               end.  /* if et_report_curr <> mc-rpt-curr */

               if et_show_diff and
                  ((((accum total by ar_bill et_sum_amt[1]) -
                  et_org_sum_amt[1]) <> 0) or
                  (((accum total by ar_bill et_sum_amt[2]) -
                  et_org_sum_amt[2]) <> 0) or
                  (((accum total by ar_bill et_sum_amt[3]) -
                  et_org_sum_amt[3]) <> 0) or
                  (((accum total by ar_bill et_sum_amt[4]) -
                  et_org_sum_amt[4]) <> 0))
               then
                  /* DISPLAY DIFFRENCCES IF <> 0*/
                  put
                     et_diff_txt to 21 ":" to 27
                     ((accum total by ar_bill et_sum_amt[1]) - et_org_sum_amt[1])
                        to 47
                     ((accum total by ar_bill et_sum_amt[2]) - et_org_sum_amt[2])
                        to 63
                     ((accum total by ar_bill et_sum_amt[3]) - et_org_sum_amt[3])
                        to 79
                     ((accum total by ar_bill et_sum_amt[4]) - et_org_sum_amt[4])
                        to 95
                     ((accum total by ar_bill et_sum_amt[5]) - et_org_sum_amt[5])
                        to 111
                     ((accum total by ar_bill
                       (et_base_amt -  et_base_applied)) - et_org_amt)
                        to 128.
               put skip.

            end.  /* if last-of(ar_bill) */

         end.  /* IF LSTYPE */

         if rec_printed then new_cust = false.

      end.  /* FOR EACH AR_MSTR */

      {mfrpchk.i}

   end.  /* FOR EACH CM_MSTR */

   if page-size - line-counter < 3 then
      page.
   else
      down 2.

   underline
      et_age_amt
      ar_amt.

   display
      "    " + et_report_curr @ ar_nbr
      getTermLabel("REPORT",8) @ ar_due_date
      getTermLabelRtColon("TOTALS",8) @ ar_cr_terms
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
   if et_report_curr <> mc-rpt-curr then do:
      do i = 1 to 5:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input mc-rpt-curr,
              input et_report_curr,
              input et_rate1,
              input et_rate2,
              input et_org_sum_amt[i],
              input true,  /* ROUND */
              output et_org_sum_amt[i],
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end.  /* do i = 1 to 5 */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input mc-rpt-curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input et_org_amt,
           input true,  /* ROUND */
           output et_org_amt,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.  /* if et_report_curr <> mc-rpt-curr */

   if et_show_diff and
      ((((accum total et_sum_amt[1]) - et_org_sum_amt[1]) <> 0) or
       (((accum total et_sum_amt[2]) - et_org_sum_amt[2]) <> 0) or
       (((accum total et_sum_amt[3]) - et_org_sum_amt[3]) <> 0) or
       (((accum total et_sum_amt[4]) - et_org_sum_amt[4]) <> 0) or
       (((accum total et_sum_amt[5]) - et_org_sum_amt[5]) <> 0) or
       (((accum total (et_base_amt -  et_base_applied)) - et_org_amt) <> 0))
   then
      /* DISPLAY CONVERTED AMOUNTS IF <> 0*/
      put
         et_diff_txt to 26 ":" to 27
         ((accum total et_sum_amt[1]) - et_org_sum_amt[1]) to 47
         ((accum total et_sum_amt[2]) - et_org_sum_amt[2]) to 63
         ((accum total et_sum_amt[3]) - et_org_sum_amt[3]) to 79
         ((accum total et_sum_amt[4]) - et_org_sum_amt[4]) to 95
         ((accum total et_sum_amt[5]) - et_org_sum_amt[5]) to 111
         ((accum total (et_base_amt -  et_base_applied)) - et_org_amt) to 128.
   put skip.

end.  /* DO WITH FRAME C */

/* DISPLAY SUMMARY TOTAL INFORMATION */
if page-size - line-counter < 9 then
   page.
else
   down 2.

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
if et_report_curr <> mc-rpt-curr then do:
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_inv_tot,
        input true,  /* ROUND */
        output et_org_inv_tot,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_memo_tot,
        input true,  /* ROUND */
        output et_org_memo_tot,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_fc_tot,
        input true,  /* ROUND */
        output et_org_fc_tot,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_paid_tot,
        input true,  /* ROUND */
        output et_org_paid_tot,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_drft_tot,
        input true,  /* ROUND */
        output et_org_drft_tot,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_curr_amt,
        input true,  /* ROUND */
        output et_org_curr_amt,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_amt,
        input true,  /* ROUND */
        output et_org_amt,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
end.  /* if et_report_curr <> mc-rpt-curr */

if ((accum total et_inv_tot) - et_org_inv_tot)   <> 0   or
   ((accum total et_memo_tot) - et_org_memo_tot)    <> 0   or
   ((accum total et_fc_tot) - et_org_fc_tot)        <> 0   or
   ((accum total et_paid_tot) - et_org_paid_tot)    <> 0   or
   ((accum total et_drft_tot) - et_org_drft_tot)    <> 0   or
   ((accum total (et_base_amt - et_base_applied)) - et_org_amt) <> 0   or
   ((accum total (et_curr_amt)) - et_org_curr_amt)  <> 0   or
   (((( accum total (et_curr_amt ))   -
   (accum total (et_base_amt - et_base_applied ))) -
     (et_org_curr_amt - et_org_amt))) <> 0
then
   assign
      et_diff_exist = true.

/*DISPLAY CONVERSION TXT*/
display
   et_diff_txt to 95
      when (et_show_diff and et_diff_exist)
   getTermLabelRtColon("INVOICES",33) format "x(33)" to 34
   accum total (et_inv_tot) at 35 format "->>>,>>>,>>>,>>9.99"
   ((accum total et_inv_tot) - et_org_inv_tot)
      when (et_show_diff and et_diff_exist)
      to 75 format "->>>,>>>,>>>,>>9.99"
   getTermLabelRtColon("DR/CR_MEMOS",33) format "x(33)" to 34
   accum total (et_memo_tot) at 35 format "->>>,>>>,>>>,>>9.99"
   ((accum total et_memo_tot) - et_org_memo_tot)
      when (et_show_diff and et_diff_exist)
      to 75 format "->>>,>>>,>>>,>>9.99"
   getTermLabelRtColon("FINANCE_CHARGES",33) format "x(33)" to 34
   accum total (et_fc_tot) at 35 format "->>>,>>>,>>>,>>9.99"
   ((accum total et_fc_tot) - et_org_fc_tot)
      when (et_show_diff and et_diff_exist)
      to 75 format "->>>,>>>,>>>,>>9.99"
   getTermLabelRtColon("UNAPPLIED_PAYMENTS",33) format "x(33)" to 34
   accum total (et_paid_tot) at 35 format "->>>,>>>,>>>,>>9.99"
   ((accum total et_paid_tot) - et_org_paid_tot)
      when (et_show_diff and et_diff_exist)
      to 75 format "->>>,>>>,>>>,>>9.99"
   getTermLabelRtColon("DRAFTS",33) format "x(33)" to 34
   accum total (et_drft_tot) at 35 format "->>>,>>>,>>>,>>9.99"
   ((accum total et_drft_tot) - et_org_drft_tot)
   when (et_show_diff and et_diff_exist)
      to 75 format "->>>,>>>,>>>,>>9.99"
   getTermLabelRt("TOTAL",10) + " " + et_report_curr  + " " +
   getTermLabelRtColon("AGING",6) format "x(21)" to 34
   accum total (et_base_amt - et_base_applied) at 35 format "->>>,>>>,>>>,>>9.99"
   ((accum total (et_base_amt - et_base_applied)) - et_org_amt)
      when (et_show_diff and et_diff_exist)
      to 75 format "->>>,>>>,>>>,>>9.99"
with frame d width 132 no-labels.

if base_rpt = "" then
   display
      getTermLabel("AGING_AT",8) + " " + string(age_date) + " " +
      getTermLabelRtColon("EXCHANGE_RATE",14)
         format "x(32)" to 34
      accum total (et_curr_amt) at 35 format "->>>,>>>,>>>,>>9.99"
      ((accum total (et_curr_amt)) - et_org_curr_amt)
         when (et_show_diff and et_diff_exist)
         to 75
      getTermLabel("VARIANCE_OF",11) + " " + string(age_date) + " " +
      getTermLabelRtColon("TO_BASE",8)
         format "x(29)" to 34
      (accum total (et_curr_amt)) -
      (accum total (et_base_amt - et_base_applied)) at 35
         format "->>>,>>>,>>>,>>9.99"
      ((((accum total (et_curr_amt))   -
      (accum total (et_base_amt - et_base_applied))) -
      (et_org_curr_amt - et_org_amt)
   ))    when (et_show_diff and et_diff_exist)
         to 75 format "->>>,>>>,>>>,>>9.99"
      skip(1)
      mc-curr-label at 3 et_report_curr skip
      mc-exch-label at 3 mc-exch-line1 skip
      mc-exch-line2 at 25 skip(1)
   with frame d width 132 no-labels.

/* REPORT TRAILER */
hide frame phead1.
