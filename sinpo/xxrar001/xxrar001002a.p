/* arcsrp2a.p - AR AGING REPORT BY INVOICE DATE SUBROUTINE               */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.16.1.15 $                                            */
/*V8:ConvertMode=Report                                                  */
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
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/07/00   BY: *N0CL* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16.1.9   BY: Seema Tyagi         DATE: 11/26/01   ECO: *N169*  */
/* Revision: 1.16.1.10  BY: Manjusha Inglay     DATE: 11/07/02   ECO: *N1Z3*  */
/* Revision: 1.16.1.11  BY: Ed van de Gevel     DATE: 05/28/03   ECO: *N2BR*  */
/* Revision: 1.16.1.13  BY: Paul Donnelly (SB)  DATE: 06/26/03   ECO: *Q00B*  */
/* $Revision: 1.16.1.15 $ BY: Ajay Nair         DATE: 10/26/05   ECO: *P468*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

/* 110802.1 by: jack 处理u 类型 */

DEFINE  SHARED   TEMP-TABLE tt  /* */
    FIELD tt_cat AS CHAR  /* 分类 */
    FIELD tt_dept AS CHAR 
    FIELD tt_deptname LIKE dpt_desc
    FIELD tt_vend LIKE po_vend
    FIELD tt_name LIKE ad_name
    FIELD tt_nbr LIKE vo_invoice
    FIELD tt_date AS DATE
    FIELD tt_part LIKE pt_part
    FIELD tt_desc1 LIKE pt_desc1
    FIELD tt_qty LIKE pod_qty_ord
    FIELD tt_cost LIKE prh_pur_cost
    FIELD tt_amt LIKE ap_amt
    FIELD tt_type AS CHAR /* 1 发出商品 2 应收金额 m/i 3 预收金额 u 4 预收票据 d*/
    .
/* ss - 10802.1 -b */
DEFINE VAR v_nbr LIKE ar_nbr .
DEFINE VAR v_type LIKE ar_type .
DEFINE VAR v_sub LIKE ar_sub .
DEFINE VAR v_cc LIKE ar_cc .
/* ss - 110802.1 -e */

&SCOPED-DEFINE arcsrp2a_p_1 "Column Days"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_4 "Attn"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_10 "Aging Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_26 "Deduct Contested"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_27 "Customer Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_30 "Show Master Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_31 "Show Invoice Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_32 "Show Payment Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_33 "Show Customer PO"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_35 "Tel"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp2a_p_38 "Summary/Detail"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{mfdeclre.i}
{cxcustom.i "ARCSRP2A.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable cust               like ar_bill.
define shared variable cust1              like ar_bill.
define shared variable cust_type          like cm_type label {&arcsrp2a_p_27}.
define shared variable cust_type1         like cm_type.
define shared variable ardate             like ar_date.
define shared variable ardate1            like ar_date.
define shared variable nbr                like ar_nbr.
define shared variable nbr1               like ar_nbr.
define shared variable slspsn             like sp_addr.
define shared variable slspsn1            like sp_addr.
define shared variable acct               like ar_acct.
define shared variable acct1              like ar_acct.
define shared variable sub                like ar_sub.
define shared variable sub1               like ar_sub.
define shared variable cc                 like ar_cc.
define shared variable cc1                like ar_cc.
define shared variable age_date           like ar_due_date
   label {&arcsrp2a_p_10} initial today.
define shared variable summary_only       like mfc_logical
   label {&arcsrp2a_p_38} initial no format {&arcsrp2a_p_38}.
define shared variable base_rpt           like ar_curr.
define shared variable deduct_contest     like mfc_logical
   label {&arcsrp2a_p_26}.
define shared variable show_po            like mfc_logical
   label {&arcsrp2a_p_33} initial no.
define shared variable show_pay_detail    like mfc_logical
   label {&arcsrp2a_p_32} initial no.
define shared variable show_comments      like mfc_logical
   label {&arcsrp2a_p_31} initial no.
define shared variable show_mstr_comments like mfc_logical
   label {&arcsrp2a_p_30} initial no.
define shared variable age_days           as   integer extent 4
   label {&arcsrp2a_p_1}.
define shared variable mstr_type          like cd_type.
define shared variable mstr_lang          like cd_lang.
define shared variable entity             like gl_entity.
define shared variable entity1            like gl_entity.
define shared variable lstype             like ls_type.
define shared variable mc-rpt-curr        like ar_curr no-undo.

define variable name           like ad_name.
define variable age_range      as   character extent 4 format "X(16)".
define variable i              as   integer.
define variable age_amt        like ar_amt extent 4.
define variable age_period     as   integer.
define variable cm_recno       as   recid.
define variable balance        like cm_balance.
define variable age_paid       like ar_amt extent 4.
define variable sum_amt        like ar_amt extent 4.
define variable inv_tot        like ar_amt.
define variable memo_tot       like ar_amt.
define variable fc_tot         like ar_amt.
define variable paid_tot       like ar_amt.
define variable drft_tot       like ar_amt.
define variable base_amt       like ar_amt.
define variable base_applied   like ar_applied.
define variable contested      as   character format "x(5)".
define variable curr_amt       like ar_amt.
define variable new_cust       as   logical initial true.
define variable use_rec        as   logical initial false.
define variable rec_printed    as   logical initial false.
define variable u_amt          like base_amt.
define variable u_applied      like base_amt.
define variable exdrate        like exr_rate.
define variable exdrate2       like exr_rate.
define variable exdratetype    like exr_ratetype no-undo.
define variable tempstr        as   character format "x(25)".
define variable high_dun_level like ar_dun_level.
define variable disp_dun_level like ar_dun_level format ">>" no-undo.

define buffer payment for ar_mstr.
define buffer armstr  for ar_mstr.

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

{&ARCSRP2A-P-TAG1}

/* CREATE REPORT HEADER */
do i = 2 to 4:
   age_range[i] = getTermLabelRt("OVER",8) + string(age_days[i - 1],"->>>9").
end. /* DO i = 2 to 4 */

age_range[1] = getTermLabelRt("LESS_THAN",10) + string(age_days[1],"->>>9").

/*                                                                              */
/* form                                                                         */
/*    header                                                                    */
/*    getTermLabel("AGING_DATE",11)       format "x(11)" at 1                   */
/*    age_date       skip space (29)                                            */
/*    getTermLabel("DUNNING",2)           format "x(2)" /* FOR DUNNING LEVEL */ */
/*    age_range[1 for 4]   skip                                                 */
/*    getTermLabel("REFERENCE",8)                                               */
/*    getTermLabel("TYPE",1)              format "x(1)"                         */
/*    getTermLabel("DATE",8)              format "x(8)"                         */
/*    getTermLabel("CREDIT_TERMS",8)                                            */
/*    getTermLabel("LEVEL",2)             format "x(2)" /* FOR DUNNING LEVEL */ */
/*    getTermLabelCentered("DAYS_OLD",16) format "x(16)"                        */
/*    getTermLabelCentered("DAYS_OLD",16) format "x(16)"                        */
/*    getTermLabelCentered("DAYS_OLD",16) format "x(16)"                        */
/*    getTermLabelCentered("DAYS_OLD",16) format "x(16)"                        */
/*    getTermLabelRt("TOTAL_AMOUNT",16)   format "x(16)"                        */
/*    skip                                                                      */
/*    "--------"                                                                */
/*    "-"                                                                       */
/*    "--------"                                                                */
/*    "--------"                                                                */
/*    "--" /* FOR DUNNING LEVEL */                                              */
/*    "----------------"                                                        */
/*    "----------------"                                                        */
/*    "----------------"                                                        */
/*    "----------------"                                                        */
/*    "----------------" skip                                                   */
/* with frame phead1 width 132 page-top.                                        */
/*                                                                              */
/* view frame phead1.                                                           */

/* do with frame c down no-box:  */

   
   for each cm_mstr
      fields( cm_domain cm_addr cm_balance cm_pay_date cm_sort cm_type)
       where cm_mstr.cm_domain = global_domain and   (cm_addr     >= cust
              and cm_addr <= cust1)
        and  (cm_type     >= cust_type
              and cm_type <= cust_type1)
      no-lock by cm_sort:

      high_dun_level = 0.

      /* MODIFIED THE SELECTION CRITERIA OF THE FOR EACH ar_mstr */
      /* LOOP TO INCLUDE ALL THE 4 SALESPERSONS                  */

      for each ar_mstr
         fields( ar_batch ar_domain ar_acct ar_amt ar_applied ar_base_amt
         ar_base_applied ar_bill ar_cust
                 ar_cc ar_check ar_cmtindx ar_contested ar_cr_terms ar_curr
                 ar_date ar_draft ar_dun_level ar_effdate ar_entity ar_ex_rate
                 ar_ex_rate2 ar_nbr ar_po ar_slspsn ar_sub ar_type ar_open)
          where ar_mstr.ar_domain = global_domain and (   ar_bill
           = cm_addr
           and (ar_nbr                >= nbr
                and ar_nbr            <= nbr1)
           and (   (ar_slspsn[1]      >= slspsn
                    and ar_slspsn[1]  <= slspsn1)
                or (ar_slspsn[2]      >= slspsn
                    and ar_slspsn[2]  <= slspsn1)
                or (ar_slspsn[3]      >= slspsn
                    and ar_slspsn[3]  <= slspsn1)
                or (ar_slspsn[4]      >= slspsn
                    and ar_slspsn[4]  <= slspsn1))
           and (ar_type                = "P"
                or (ar_entity     >= entity
                    and ar_entity <= entity1))
           and (ar_amt - ar_applied <> 0)
           and (ar_type = "P"
                or (ar_date     >= ardate
                    and ar_date <= ardate1)
                     or ar_date  = ?)
                and (not ar_type = "D"  /* 110803.1 为何去除了d类型 */
                      or ar_draft) /* APPRVD DRAFTS ONLY */
                and (ar_curr     = base_rpt
                     or base_rpt = "")
                and (not (deduct_contest
                          and ar_contested = yes))
         ) no-lock break by ar_bill by ar_nbr
         with frame c width 132 no-labels:

         
          

         if lstype = ""
            or (lstype <> ""
                and can-find(first ls_mstr
                              where ls_mstr.ls_domain = global_domain and
                              ls_type = lstype
                               and ls_addr = cm_addr))
         then do:

            /* STORE FIRST CUSTOMER INFORMATION IN A LOGICAL, SINCE THE
            ACCOUNT VALIDATION MAY CAUSE THE ACTUAL FIRST RECORD
            TO BE SKIPPED */

            if first-of(ar_bill)
            then
               new_cust = true.

            /* VALIDATE THE AR ACCOUNT (IF RANGE SPECIFIED) */

            use_rec = true.

           

            if    (acct       <> ""
                   or acct1   <> hi_char)
               or (sub        <> ""
                   or sub1    <> hi_char)
               or (cc         <> ""
                   or cc1     <> hi_char)
               or (entity     <> ""
                   or entity1 <> hi_char)
            then do:

               if ar_type <> "P"
               then do:
                  if    (ar_acct    < acct
                         or ar_acct > acct1)
                     or (ar_sub     < sub
                         or ar_sub  > sub1)
                     or (ar_cc      < cc
                         or ar_cc   > cc1)
                  then
                     use_rec = false.
               end. /* IF ar_type <> "P" */

               else do:
                  /* PAYMENTS: IF UNAPPLIED, GET THE DETAIL TO DETERMINE THE */
                  /* APPLICATION ACCOUNT */

                  assign
                     use_rec   = false
                     u_amt     = 0
                     u_applied = 0.

                  for each ard_det
                     fields(ard_domain ard_acct ard_amt ard_cc ard_entity
                            ard_nbr ard_ref ard_sub ard_type ard_disc)
                      where ard_det.ard_domain = global_domain and  ard_nbr  =
                      ar_nbr
                       and ard_type = "U"
                       and ard_ref  = ""
                       no-lock:

                     if     ard_acct   >= acct
                        and ard_acct   <= acct1
                        and ard_sub    >= sub
                        and ard_sub    <= sub1
                        and ard_cc     >= cc
                        and ard_cc     <= cc1
                        and ard_entity >= entity
                        and ard_entity <= entity1
                     then
                        assign
                           use_rec = true
                           u_amt   = u_amt - ard_amt - ard_disc.

                     /* ss - 110802.1 -b */
                     v_sub = ard_sub .
                     v_cc = ard_cc .
                     /* ss - 110802.1 -e */

                  end. /*FOR EACH ard_det */

                  for each armstr
                     fields( ar_domain ar_acct ar_amt ar_applied ar_base_amt
                             ar_base_applied ar_bill ar_cc ar_check ar_cmtindx
                             ar_contested ar_cr_terms ar_curr ar_date ar_draft
                             ar_dun_level ar_effdate ar_entity ar_ex_rate
                             ar_ex_rate2 ar_nbr ar_po ar_slspsn ar_sub ar_type)
                      where armstr.ar_domain = global_domain and
                      armstr.ar_check = ar_mstr.ar_check
                       and armstr.ar_bill  = ar_mstr.ar_bill
                       and armstr.ar_type  = "A"
                     no-lock:

                     for each ard_det
                      fields( ard_domain ard_acct ard_amt ard_cc ard_entity
                      ard_nbr
                              ard_ref ard_sub ard_type)
                         where ard_det.ard_domain = global_domain and  ard_nbr
                         = armstr.ar_nbr
                        no-lock:
                        u_applied = u_applied - ard_amt.
                        
                     end. /* FOR EACH ard_det */

                  end. /* FOR EACH armstr */

               end.  /* ELSE DO */

            end.  /* IF acct <> "" ... */

            else if ar_type = "P"
            then
               assign
                  u_amt     = ar_amt
                  u_applied = ar_applied.

          

            if use_rec
            then do:

/*                form                            */
/*                   ar_nbr         format "x(8)" */
/*                   ar_type                      */
/*                   ar_date                      */
/*                   ar_cr_terms                  */
/*                   ar_dun_level format ">>"     */
/*                   et_age_amt[1 for 4]          */
/*                   ar_amt                       */
/*                   contested                    */
/*                with frame c                    */
/*                width 132.                      */


               do i = 1 to 4:
                  assign
                     et_age_amt[i]  = 0
                     et_age_paid[i] = 0
                     et_sum_amt[i]  = 0
                     age_amt[i]     = 0
                     age_paid[i]    = 0
                     sum_amt[i]     = 0.
               end. /* DO i = 1 to 4 */

               {&ARCSRP2A-P-TAG2}

               if new_cust
               then do with frame b down:
                  assign
                     new_cust    = false
                     rec_printed = true
                     name        = "".

                  for first ad_mstr
                     fields( ad_domain ad_addr ad_attn ad_ext ad_name ad_phone
                     ad_state)
                      where ad_mstr.ad_domain = global_domain and  ad_addr =
                      ar_bill
                     no-lock :
                  end. /* FOR FIRST ad_mstr */

                  assign
                     cm_recno = recid(cm_mstr)
                     balance  = cm_balance.

                  if available ad_mstr
                  then
                     name = ad_name.

/*                   if page-size - line-counter < 4 */
/*                   then                            */
/*                      page.                        */

/*                   /* SET EXTERNAL LABELS */           */
/*                   setFrameLabels(frame b:handle).     */
/*                                                       */
/*                   display                             */
/*                      ar_bill  no-label                */
/*                      name     no-label                */
/*                      ad_state                         */
/*                      cm_pay_date                      */
/*                      ad_attn  label {&arcsrp2a_p_4}   */
/*                      ad_phone label {&arcsrp2a_p_35}  */
/*                      ad_ext   no-label                */
/*                   with frame b side-labels width 132. */

/*                   if show_mstr_comments            */
/*                   then do:                         */
/*                      {gpcdprt.i &type = mstr_type  */
/*                                 &ref  = cm_addr    */
/*                                 &lang = mstr_lang  */
/*                                 &pos  = 10}        */
/*                   end. /* IF show_mstr_comments */ */

/*                   if summary_only = no */
/*                   then                 */
/*                      down 1.           */

               end.  /* IF new_cust */

               if summary_only = no
               then do with frame c:
/*                   if ar_type <> "P"         */
/*                   then                      */
/*                      display                */
/*                         ar_nbr              */
/*                         ar_type.            */
/*                   else                      */
/*                      display                */
/*                         ar_check @ ar_nbr   */
/*                         "U"      @ ar_type. */
/*                   display                   */
/*                      ar_date                */
/*                      ar_cr_terms            */
/*                      ar_dun_level.          */
                   /* ss - 110802.1 -b */
             if ar_type <> "P" THEN DO:
                 
                     ASSIGN
                 v_nbr = ar_nbr
                 v_type = ar_type
                 .
                    
             END.
                  
                  else
                     
                     ASSIGN
                         v_nbr = ar_check
                         v_type = "u" 
                         .
                 
                   /* ss - 110802.1 -e */

               end. /* IF summary_only = no */

               else
               /* SAVE HIGHEST DUNNING LEVEL FOR THIS CUSTOMER */

               if ar_dun_level > high_dun_level
               then
                  high_dun_level = ar_dun_level.

               age_period = 4.

               do i = 1 to 4:

                  if age_date - age_days[i] <= ar_date
                  then
                     age_period = i.

                  if age_period <> 4
                  then
                     leave.

               end. /* DO i = 1 to 4 */

               if ar_type = "P"
               then
                  assign
                     curr_amt     = u_amt - u_applied
                     base_amt     = u_amt
                     base_applied = u_applied.

               else
                  assign
                     curr_amt     = ar_amt - ar_applied
                     base_amt     = ar_amt
                     base_applied = ar_applied.


               if base_rpt = ""
                  and ar_curr <> base_curr
               then do:

                  assign
                     base_amt     = ar_base_amt
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

                  if mc-error-number <> 0
                  then do:

                     {pxmsg.i &MSGNUM     = mc-error-number
                              &ERRORLEVEL = 4}

                     pause 0.
                     leave.

                  end. /*IF mc-error-number <> 0 */

                  if mc-error-number = 0
                  then do:

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

                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM     = mc-error-number
                                 &ERRORLEVEL = 2}
                     end. /* IF mc-error-number <> 0 */

                  end.  /* if mc-error-number = 0 */

                  /*IF NO EXCHANGE RATE FOR TODAY, USE THE INV RATE*/
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

                     if mc-error-number <> 0
                     then do:

                        {pxmsg.i &MSGNUM     = mc-error-number
                                 &ERRORLEVEL = 2}

                     end. /* IF mc-error-number <> 0 */

                  end.  /* ELSE DO */

               end.  /* IF base_rpt = "" and ar_curr <> base_curr */

               if ar_date = ?
               then
                  age_period = 1.

               if not show_pay_detail
                  or ar_type = "P"
               then
                  age_amt[age_period] = base_amt - base_applied.
               else
                  age_amt[age_period] = base_amt.

               assign
                  age_paid[age_period] = base_applied * (-1)
                  sum_amt[age_period]  = base_amt - base_applied.

               {&ARCSRP2A-P-TAG3}

               if ar_type = "I"
               then
                  inv_tot = base_amt - base_applied.
               else
                  inv_tot = 0.

               if ar_type = "M"
               then
                  memo_tot = base_amt - base_applied.
               else
                  memo_tot = 0.

               if ar_type = "F"
               then
                  fc_tot = base_amt - base_applied.
               else
                  fc_tot = 0.

               if ar_type = "D"
               then
                  drft_tot = base_amt - base_applied.
               else
                  drft_tot = 0.

               if ar_type = "P"
               then
                  paid_tot = base_amt - base_applied.
               else
                  paid_tot = 0.

               do i = 1 to 4:

                  if et_report_curr <> mc-rpt-curr
                  then do:

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input sum_amt[i],
                          input true, /* ROUND */
                          output et_sum_amt[i],
                          output mc-error-number)"}

                     if mc-error-number <> 0
                     then do:

                        {pxmsg.i &MSGNUM     = mc-error-number
                                 &ERRORLEVEL = 2}

                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input age_amt[i],
                          input true, /* ROUND */
                          output et_age_amt[i],
                          output mc-error-number)"}

                     if mc-error-number <> 0
                     then do:

                        {pxmsg.i &MSGNUM     = mc-error-number
                                 &ERRORLEVEL = 2}

                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input age_paid[i],
                          input true, /* ROUND */
                          output et_age_paid[i],
                          output mc-error-number)"}

                     if mc-error-number <> 0
                     then do:

                        {pxmsg.i &MSGNUM     = mc-error-number
                                 &ERRORLEVEL = 2}

                     end. /* IF mc-error-number <> 0 */

                  end.  /* if et_report_curr <> mc-rpt-curr */

                  else
                    assign
                       et_sum_amt[i]  = sum_amt[i]
                       et_age_amt[i]  = age_amt[i]
                       et_age_paid[i] = age_paid[i].

               end.  /* DO i = 1 to 4 */

               if et_report_curr <> mc-rpt-curr
               then do:

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input base_amt,
                       input true, /* ROUND */
                       output et_base_amt,
                       output mc-error-number)"}

                  if mc-error-number <> 0
                  then do:

                     {pxmsg.i &MSGNUM     = mc-error-number
                              &ERRORLEVEL = 2}

                  end. /* IF mc-error-number <> 0 */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input base_applied,
                       input true, /* ROUND */
                       output et_base_applied,
                       output mc-error-number)"}

                  if mc-error-number <> 0
                  then do:

                     {pxmsg.i &MSGNUM     = mc-error-number
                              &ERRORLEVEL = 2}

                  end. /* IF mc-error-number <> 0 */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input inv_tot,
                       input true, /* ROUND */
                       output et_inv_tot,
                       output mc-error-number)"}

                  if mc-error-number <> 0
                  then do:

                     {pxmsg.i &MSGNUM     = mc-error-number
                              &ERRORLEVEL = 2}

                  end. /* IF mc-error-number <> 0 */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input memo_tot,
                       input true, /* ROUND */
                       output et_memo_tot,
                       output mc-error-number)"}

                  if mc-error-number <> 0
                  then do:

                     {pxmsg.i &MSGNUM     = mc-error-number
                              &ERRORLEVEL = 2}

                  end. /* IF mc-error-number <> 0 */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input fc_tot,
                       input true, /* ROUND */
                       output et_fc_tot,
                       output mc-error-number)"}

                  if mc-error-number <> 0
                  then do:

                     {pxmsg.i &MSGNUM     = mc-error-number
                              &ERRORLEVEL = 2}

                  end. /* IF mc-error-number <> 0 */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input paid_tot,
                       input true, /* ROUND */
                       output et_paid_tot,
                       output mc-error-number)"}

                  if mc-error-number <> 0
                  then do:

                     {pxmsg.i &MSGNUM     = mc-error-number
                              &ERRORLEVEL = 2}

                  end. /* IF mc-error-number <> 0 */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input drft_tot,
                       input true, /* ROUND */
                       output et_drft_tot,
                       output mc-error-number)"}

                  if mc-error-number <> 0
                  then do:

                     {pxmsg.i &MSGNUM     = mc-error-number
                              &ERRORLEVEL = 2}

                  end. /* IF mc-error-number <> 0 */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input curr_amt,
                       input true, /* ROUND */
                       output et_curr_amt,
                       output mc-error-number)"}

                  if mc-error-number <> 0
                  then do:

                     {pxmsg.i &MSGNUM     = mc-error-number
                              &ERRORLEVEL = 2}

                  end. /* IF mc-error-number <> 0 */

               end.  /* if et_report_curr <> mc-rpt-curr */

               else
                 assign
                    et_base_amt     = base_amt
                    et_base_applied = base_applied
                    et_inv_tot      = inv_tot
                    et_memo_tot     = memo_tot
                    et_fc_tot       = fc_tot
                    et_paid_tot     = paid_tot
                    et_drft_tot     = drft_tot
                    et_curr_amt     = curr_amt.

               accumulate et_sum_amt  (total by ar_bill).
               accumulate et_base_amt - et_base_applied (total by ar_bill).
               accumulate et_inv_tot  (total).
               accumulate et_memo_tot (total).
               accumulate et_fc_tot   (total).
               accumulate et_paid_tot (total).
               accumulate et_drft_tot (total).
               accumulate et_curr_amt (total).
               accumulate sum_amt     (total by ar_bill).
               accumulate base_amt - base_applied (total by ar_bill).
               accumulate inv_tot     (total).
               accumulate memo_tot    (total).
               accumulate fc_tot      (total).
               accumulate drft_tot    (total).
               accumulate paid_tot    (total).
               accumulate curr_amt    (total).

               

               if summary_only = no
               then do with frame c:
                   
                  if not show_pay_detail
                     or  ar_type = "P"
                  then do:

                  
                    IF v_type = "m" OR v_type = "i"  THEN DO:
                    
                         CREATE tt .
                       FIND FIRST cc_mstr WHERE cc_domain = GLOBAL_domain AND cc_ctr = ar_cc NO-LOCK NO-ERROR .
                       FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = ar_cust NO-LOCK NO-ERROR .
                
                       ASSIGN
                
                          tt_dept = ar_cc
                          tt_deptname = IF AVAILABLE cc_mstr THEN cc_desc ELSE ""
                          tt_vend = ar_cust
                          tt_name = IF AVAILABLE ad_mstr THEN ad_name ELSE ""
                          tt_nbr = v_nbr
                          tt_date = ar_effdate
                          tt_amt = et_base_amt - et_base_applied
                          tt_type = "2"
                              .
                        CASE ar_sub:
                           WHEN  "hk001"  THEN DO:
                               tt_cat = "仪器" .
                           END.
                           WHEN "hk002"  THEN DO:
                                tt_cat = "数显" .
                           END.
                           WHEN "hk003" THEN
                                tt_cat = "其他" .
                        END CASE.
                    END.
                    ELSE IF v_type = "u" THEN DO:

                      

                          CREATE tt .
                       FIND FIRST cc_mstr WHERE cc_domain = GLOBAL_domain AND cc_ctr = v_cc NO-LOCK NO-ERROR .
                       FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = ar_cust NO-LOCK NO-ERROR .
                
                       ASSIGN
                
                          tt_dept = v_cc
                          tt_deptname = IF AVAILABLE cc_mstr THEN cc_desc ELSE ""
                          tt_vend = ar_cust
                          tt_name = IF AVAILABLE ad_mstr THEN ad_name ELSE ""
                          tt_nbr = ar_batch
                          tt_date = ar_effdate
                          tt_amt = et_base_amt - et_base_applied
                          tt_type = "3"
                              .
                        CASE v_sub:
                           WHEN  "hk001"  THEN DO:
                               tt_cat = "仪器" .
                           END.
                           WHEN "hk002"  THEN DO:
                                tt_cat = "数显" .
                           END.
                           WHEN "hk003" THEN
                                tt_cat = "其他" .
                        END CASE.

                    END.
                    ELSE IF v_type = "d" THEN DO:

                        

                         CREATE tt .
                       FIND FIRST cc_mstr WHERE cc_domain = GLOBAL_domain AND cc_ctr = ar_cc NO-LOCK NO-ERROR .
                       FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = ar_cust NO-LOCK NO-ERROR .
                
                       ASSIGN
                
                          tt_dept = ar_cc
                          tt_deptname = IF AVAILABLE cc_mstr THEN cc_desc ELSE ""
                          tt_vend = ar_cust
                          tt_name = IF AVAILABLE ad_mstr THEN ad_name ELSE ""
                          tt_nbr = v_nbr
                          tt_date = ar_effdate
                          tt_amt = et_base_amt - et_base_applied
                          tt_type = "4"
                              .
                        CASE ar_sub:
                           WHEN  "hk001"  THEN DO:
                               tt_cat = "仪器" .
                           END.
                           WHEN "hk002"  THEN DO:
                                tt_cat = "数显" .
                           END.
                           WHEN "hk003" THEN
                                tt_cat = "其他" .
                        END CASE.

                    END.
/*                      display                                        */
/*                         et_age_amt[1 for 4]                         */
/*                         {&ARCSRP2A-P-TAG4}                          */
/*                         (et_base_amt - et_base_applied) @ ar_amt.   */
/*                         {&ARCSRP2A-P-TAG5}                          */
/*                                                                     */
/*                      if ar_contested                                */
/*                      then                                           */
/*                         display                                     */
/*                            getTermLabel("CONTESTED",5) @ contested. */
/*                                                                     */
/*                      down 1.                                        */

                  end. /* IF NOT show_pay_detail OR ar_type = "P" */

                  else do:

/*                      display                                        */
/*                         et_age_amt[1 for 4]                         */
/*                         {&ARCSRP2A-P-TAG6}                          */
/*                         et_base_amt @ ar_amt.                       */
/*                         {&ARCSRP2A-P-TAG7}                          */
/*                                                                     */
/*                      if ar_contested                                */
/*                      then                                           */
/*                         display                                     */
/*                            getTermLabel("CONTESTED",5) @ contested. */
/*                                                                     */
/*                      down 1.                                        */

                     if base_applied <> 0
                     then do:

/*                         display                             */
/*                            et_age_paid[1] @ et_age_amt[1]   */
/*                            et_age_paid[2] @ et_age_amt[2]   */
/*                            et_age_paid[3] @ et_age_amt[3]   */
/*                            et_age_paid[4] @ et_age_amt[4]   */
/*                            et_base_applied * (-1) @ ar_amt. */
/*                                                             */
/*                         down 1.                             */
/*                                                             */
                        /* SHOW PAYMENT DETAIL */
                        for each ard_det
                           fields( ard_domain ard_acct ard_amt ard_cc
                           ard_entity ard_nbr
                                   ard_ref ard_sub ard_type)
                            where ard_det.ard_domain = global_domain and
                            ard_ref = ar_nbr
                           no-lock with frame c:

                           for first payment
                              fields( ar_domain ar_acct ar_amt ar_applied
                              ar_base_amt
                                      ar_base_applied ar_bill ar_cc ar_check
                                      ar_cmtindx ar_contested ar_cr_terms
                                      ar_curr ar_date ar_draft ar_dun_level
                                      ar_effdate ar_entity ar_ex_rate
                                      ar_ex_rate2 ar_nbr ar_po ar_slspsn
                                      ar_sub ar_type)
                               where payment.ar_domain = global_domain and
                               payment.ar_nbr = ard_nbr
                              no-lock:
                           end. /* FOR FIRST payment */

                           if available payment
                           then do:

/*                               display                                      */
/*                                  payment.ar_type    @ ar_mstr.ar_type      */
/*                                  payment.ar_effdate @ ar_mstr.ar_date      */
/*                                  payment.ar_check   @ ar_mstr.ar_cr_terms. */
/*                                                                            */
/*                               down 1.                                      */

                           end. /* IF AVAILABLE payment */

                        end. /* FOR EACH ard_det */

                     end.  /* IF base_applied <> 0 */

                  end.  /* ELSE DO */

                  {&ARCSRP2A-P-TAG8}

/*                   if show_po and ar_po <> ""                           */
/*                   then                                                 */
/*                      put ar_po at 10.                                  */
/*                                                                        */
/*                   /* DISPLAY DOCUMENT COMMENTS */                      */
/*                   if show_comments                                     */
/*                      and ar_cmtindx <> 0                               */
/*                   then do:                                             */
/*                                                                        */
/*                      {arcscmt.i &cmtindx = ar_cmtindx                  */
/*                                 &subhead = "ar_nbr format ""X(8)"" " } */
/*                                                                        */
/*                   end. /* IF show_comments and ar_cmtindx <> 0 */      */

               end.  /* IF summary_only = no */

            end.  /* use_rec block */

           

            /* CUSTOMER TOTALS */
            if last-of(ar_bill)
               and rec_printed
            then do with frame c:

               rec_printed = false.

            

               if summary_only = no
               then do:

/*                   if page-size - line-counter < 2 */
/*                   then                            */
/*                      page.                        */
/*                                                   */
/*                   underline                       */
/*                      et_age_amt                   */
/*                      ar_amt.                      */

               end. /* IF summary_only = no */

/*                display                                                   */
/*                   "    " + et_report_curr                @ ar_nbr        */
/*                   getTermLabel("CUSTOMER",8)             @ ar_date       */
/*                   getTermLabelRtColon("TOTALS",8)        @ ar_cr_terms   */
/*                   accum total by ar_bill (et_sum_amt[1]) @ et_age_amt[1] */
/*                   accum total by ar_bill (et_sum_amt[2]) @ et_age_amt[2] */
/*                   accum total by ar_bill (et_sum_amt[3]) @ et_age_amt[3] */
/*                   accum total by ar_bill (et_sum_amt[4]) @ et_age_amt[4] */
/*                   accum total by ar_bill (et_base_amt - et_base_applied) */
/*                                                          @ ar_amt.       */
/*                down 1.                                                   */

            end.  /* CUSTOMER TOTALS */

         end.  /* IF LSTYPE */

      end.  /* FOR EACH AR_MSTR */

/*       {mfrpchk.i} */

   end. /* FOR EACH cm_mstr */

/*    if page-size - line-counter < 3 */
/*    then                            */
/*       page.                        */
/*    else                            */
/*       down 2.                      */
/*                                    */
/*    underline                       */
/*       et_age_amt                   */
/*       ar_amt.                      */

/*    display                                                        */
/*       "    " + et_report_curr                     @ ar_nbr        */
/*       getTermLabel("REPORT",8)                    @ ar_date       */
/*       getTermLabelRtColon("TOTALS",8)             @ ar_cr_terms   */
/*       accum total (et_sum_amt[1])                 @ et_age_amt[1] */
/*       accum total (et_sum_amt[2])                 @ et_age_amt[2] */
/*       accum total (et_sum_amt[3])                 @ et_age_amt[3] */
/*       accum total (et_sum_amt[4])                 @ et_age_amt[4] */
/*       accum total (et_base_amt - et_base_applied) @ ar_amt.       */
/*    down 1.                                                        */

   /*DETERMINE ORIGINAL REPORT TOTALS, NOT YET CONVERTED*/
   assign
      et_org_sum_amt[1] = accum total sum_amt[1]
      et_org_sum_amt[2] = accum total sum_amt[2]
      et_org_sum_amt[3] = accum total sum_amt[3]
      et_org_sum_amt[4] = accum total sum_amt[4]
      et_org_amt        = accum total (base_amt - base_applied).

   /*CONVERT REPORT TOTAL AMOUNTS*/

   if et_report_curr <> mc-rpt-curr
   then do:

      do i = 1 to 4:

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input mc-rpt-curr,
              input et_report_curr,
              input et_rate1,
              input et_rate2,
              input et_org_sum_amt[i],
              input true,  /* ROUND */
              output et_org_sum_amt[i],
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:

            {pxmsg.i &MSGNUM     = mc-error-number
                     &ERRORLEVEL = 2}

         end. /* IF mc-error-number <> 0 */

      end.  /* DO i = 1 to 5 */

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input mc-rpt-curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input et_org_amt,
           input true,  /* ROUND */
           output et_org_amt,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:

         {pxmsg.i &MSGNUM     = mc-error-number
                  &ERRORLEVEL = 2}

      end.  /* IF mc-error-number <> 0 */

   end.  /* if et_report_curr <> mc-rpt-curr */

   /* DISPLAY CONVERTED AMOUNTS */
   if et_show_diff
      and (
           (  ((accum total et_sum_amt[1]) - et_org_sum_amt[1]) <> 0
           or ((accum total et_sum_amt[2]) - et_org_sum_amt[2]) <> 0
           or ((accum total et_sum_amt[3]) - et_org_sum_amt[3]) <> 0
           or ((accum total et_sum_amt[4]) - et_org_sum_amt[4]) <> 0
           or ((accum total (et_base_amt   -  et_base_applied))
                - et_org_amt) <> 0 )
          )
   then do:

      /* PUT DIFFERENCE TEXT "Conversion diff" */
/*        put et_diff_txt to 26 ":" to 27                                         */
/*          /* DISPLAY DIFFRENCES */                                              */
/*          ((accum total et_sum_amt[1]) - et_org_sum_amt[1])             to 48   */
/*          ((accum total et_sum_amt[2]) - et_org_sum_amt[2])             to 65   */
/*          ((accum total et_sum_amt[3]) - et_org_sum_amt[3])             to 82   */
/*          ((accum total et_sum_amt[4]) - et_org_sum_amt[4])             to 99   */
/*          ((accum total (et_base_amt -  et_base_applied)) - et_org_amt) to 116. */
/*       down 1.                                                                  */

   end. /*IF et_show_diff */

/* end.  /* DO WITH FRAME C */  */

/* if page-size - line-counter < 9 */
/* then                            */
/*    page.                        */
/*                                 */
/* else                            */
/*    down 2.                      */

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

if et_report_curr <> mc-rpt-curr
then do:

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_inv_tot,
        input true, /* ROUND */
        output et_org_inv_tot,
        output mc-error-number)"}

   if mc-error-number <> 0
   then do:

      {pxmsg.i &MSGNUM     = mc-error-number
               &ERRORLEVEL = 2}

   end. /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_memo_tot,
        input true, /* ROUND */
        output et_org_memo_tot,
        output mc-error-number)"}

   if mc-error-number <> 0
   then do:

      {pxmsg.i &MSGNUM     = mc-error-number
               &ERRORLEVEL = 2}

   end.  /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_fc_tot,
        input true, /* ROUND */
        output et_org_fc_tot,
        output mc-error-number)"}

   if mc-error-number <> 0
   then do:

      {pxmsg.i &MSGNUM     = mc-error-number
               &ERRORLEVEL = 2}

   end.  /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_paid_tot,
        input true, /* ROUND */
        output et_org_paid_tot,
        output mc-error-number)"}

   if mc-error-number <> 0
   then do:

      {pxmsg.i &MSGNUM     = mc-error-number
               &ERRORLEVEL = 2}

   end.  /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_drft_tot,
        input true, /* ROUND */
        output et_org_drft_tot,
        output mc-error-number)"}

   if mc-error-number <> 0
   then do:

      {pxmsg.i &MSGNUM     = mc-error-number
               &ERRORLEVEL = 2}

   end.  /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_curr_amt,
        input true, /* ROUND */
        output et_org_curr_amt,
        output mc-error-number)"}

   if mc-error-number <> 0
   then do:

      {pxmsg.i &MSGNUM     = mc-error-number
               &ERRORLEVEL = 2}

   end.  /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_amt,
        input true, /* ROUND */
        output et_org_amt,
        output mc-error-number)"}

   if mc-error-number <> 0
   then do:

      {pxmsg.i &MSGNUM     = mc-error-number
               &ERRORLEVEL = 2}

   end.  /* IF mc-error-number <> 0 */

end.  /* if et_report_curr <> mc-rpt-curr */

et_diff_exist = no.

if ((accum total et_inv_tot) - et_org_inv_tot)         <> 0 or
   ((accum total et_memo_tot) - et_org_memo_tot)       <> 0 or
   ((accum total et_fc_tot) - et_org_fc_tot)           <> 0 or
   ((accum total et_paid_tot) - et_org_paid_tot)       <> 0 or
   ((accum total et_drft_tot) - et_org_drft_tot)       <> 0 or
   ((accum total (et_base_amt - et_base_applied)) - et_org_amt) <> 0 or
   ((accum total et_curr_amt) - et_org_curr_amt)       <> 0 or
   ( ((accum total (et_curr_amt))
                   - (accum total (et_base_amt - et_base_applied))) -
                                   (et_org_curr_amt - et_org_amt)) <> 0
then
   et_diff_exist = true.
/*                                                                                */
/* display                                                                        */
/*    et_diff_txt to 95 when (et_diff_exist)                                      */
/*    getTermLabelRtColon("INVOICES",33)     format "x(33)"                 to 34 */
/*    accum total (et_inv_tot)        at 35  format "->>>,>>>,>>>,>>9.99"         */
/*    ((accum total et_inv_tot) - et_org_inv_tot)                           to 75 */
/*                                           format "->>>,>>>,>>>,>>9.99"         */
/*    getTermLabelRtColon("DR/CR_MEMOS",33)  format "x(33)"                 to 34 */
/*    accum total (et_memo_tot)       at 35  format "->>>,>>>,>>>,>>9.99"         */
/*    ((accum total et_memo_tot) - et_org_memo_tot)                               */
/*    when (et_show_diff and et_diff_exist)                                 to 75 */
/*                                           format "->>>,>>>,>>>,>>9.99"         */
/*    getTermLabelRtColon("FINANCE_CHARGES",33)                                   */
/*                                           format "x(33)"                 to 34 */
/*    accum total (et_fc_tot)         at 35  format "->>>,>>>,>>>,>>9.99"         */
/*    ((accum total et_fc_tot) - et_org_fc_tot)                                   */
/*    when (et_show_diff and et_diff_exist)                                 to 75 */
/*                                           format "->>>,>>>,>>>,>>9.99"         */
/*    getTermLabelRtColon("UNAPPLIED_PAYMENTS",33)                                */
/*                                           format "x(33)"                 to 34 */
/*    accum total (et_paid_tot)       at 35  format "->>>,>>>,>>>,>>9.99"         */
/*    ((accum total et_paid_tot) - et_org_paid_tot)                               */
/*    when (et_show_diff and et_diff_exist)                                 to 75 */
/*                                           format "->>>,>>>,>>>,>>9.99"         */
/*    getTermLabelRtColon("DRAFTS",33)       format "x(33)"                 to 34 */
/*    accum total (et_drft_tot)       at 35  format "->>>,>>>,>>>,>>9.99"         */
/*    ((accum total et_drft_tot) - et_org_drft_tot)                               */
/*    when (et_show_diff and et_diff_exist)                                 to 75 */
/*                                           format "->>>,>>>,>>>,>>9.99"         */
/*    getTermLabelRt("TOTAL",10) + " " + et_report_curr  + " " +                  */
/*    getTermLabelRtColon("AGING",6)         format "x(21)"                 to 34 */
/*    accum total (et_base_amt - et_base_applied)                           at 35 */
/*                                           format "->>>,>>>,>>>,>>9.99"         */
/*    ((accum total (et_base_amt - et_base_applied)) - et_org_amt)                */
/*    when (et_show_diff and et_diff_exist)                                 to 75 */
/*                                           format "->>>,>>>,>>>,>>9.99"         */
/* with frame d width 132 no-labels.                                              */

/* if base_rpt = ""                                                                 */
/* then                                                                             */
/*    display                                                                       */
/*    getTermLabel("AGING_AT",8) + " " + string(age_date)           + " " +         */
/*    getTermLabelRtColon("EXCHANGE_RATE",14)         format "x(32)" to 34          */
/*    accum total (et_curr_amt) at 35                 format "->>>,>>>,>>>,>>9.99"  */
/*    ((accum total et_curr_amt) - et_org_curr_amt)                                 */
/*    when (et_show_diff and et_diff_exist) to 75     format "->>>,>>>,>>>,>>9.99"  */
/*    getTermLabel("VARIANCE_OF",11) + " " + string(age_date)               + " " + */
/*    getTermLabelRtColon("TO_BASE",8)                format "x(29)" to 34          */
/*    ((accum total (et_curr_amt)) - (accum total (et_base_amt - et_base_applied))) */
/*    at 35                                           format "->>>,>>>,>>>,>>9.99"  */
/*    ((( accum total (et_curr_amt)) -                                              */
/*    (accum total (et_base_amt - et_base_applied))) -                              */
/*    (et_org_curr_amt - et_org_amt)) when (et_show_diff and et_diff_exist) to 75   */
/*                                                    format "->>>,>>>,>>>,>>9.99"  */
/* with frame d width 132 no-labels.                                                */
/*                                                                                  */
/* put skip(1)                                                                      */
/*    mc-curr-label at 3  et_report_curr skip                                       */
/*    mc-exch-label at 3  mc-exch-line1  skip                                       */
/*    mc-exch-line2 at 24                skip(1).                                   */
/*                                                                                  */
/* hide frame phead1.                                                               */
