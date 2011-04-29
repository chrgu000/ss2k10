/* arcsrp5a.p - AR AGING REPORT FROM AR EFF DATE SUBROUTINE               */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.22.1.31.1.2 $                                             */
/*V8:ConvertMode=Report                                                   */
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
/* REVISION: 9.1      LAST MODIFIED: 29 JUN 2001 BY: *N0ZX* Ed van de Gevel  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.22.1.12  BY: Geeta Kotian           DATE: 10/09/01 ECO: *M1MN* */
/* Revision: 1.22.1.13  BY: Seema Tyagi            DATE: 11/26/01 ECO: *N169* */
/* Revision: 1.22.1.15  BY: Ed van de Gevel        DATE: 07/04/02 ECO: *P0B4* */
/* Revision: 1.22.1.16  BY: Amit Chaturvedi        DATE: 12/30/02 ECO: *N234* */
/* Revision: 1.22.1.17  BY: Veena Lad              DATE: 04/28/03 ECO: *N2DX* */
/* Revision: 1.22.1.18  BY: Orawan S.              DATE: 05/12/03 ECO: *P0RW* */
/* Revision: 1.22.1.19  BY: Ed van de Gevel        DATE: 05/28/03 ECO: *N2BR* */
/* Revision: 1.22.1.21  BY: Paul Donnelly (SB)     DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.22.1.22  BY: Dorota Hohol           DATE: 08/27/03 ECO: *P117* */
/* Revision: 1.22.1.25  BY: tippawan Ua            DATE: 08/28/03 ECO: *P0Y4* */
/* Revision: 1.22.1.26  BY: Dorota Hohol           DATE: 10/17/03 ECO: *P16K* */
/* Revision: 1.22.1.28  BY: Dayanand Jethwa        DATE: 08/23/04 ECO: *P2G7* */
/* Revision: 1.22.1.29  BY: Preeti Sattur          DATE: 09/13/04 ECO: *P2KC* */
/* Revision: 1.22.1.30  BY: Ashwini G.             DATE: 09/17/04 ECO: *P27V* */
/* Revision: 1.22.1.31  BY: Gaurav Kerkar        DATE: 12/16/04 ECO: *Q0FX* */
/* Revision: 1.22.1.31.1.1  BY: Sukhad Kulkarni    DATE: 05/05/05 ECO: *Q0J3* */
/* $Revision: 1.22.1.31.1.2 $ BY: Shoma Salgaonkar     DATE: 07/07/05 ECO: *P3RX* */
/* $Revision: 1.22.1.31.1.2 $ BY: Bill Jiang     DATE: 03/01/07 ECO: *SS - 20070301.1* */
/* $Revision: 1.22.1.31.1.2 $ BY: Bill Jiang     DATE: 03/23/07 ECO: *SS - 20070323.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20070301.1 - B */
{xxarcsrp0501.i}

DEFINE VARIABLE t_acct LIKE ar_acct.
DEFINE VARIABLE t_sub LIKE ar_sub.
DEFINE VARIABLE t_cc LIKE ar_cc.

DEFINE BUFFER bard FOR ard_det.
/* SS - 20070301.1 - E */

/* SS - 20070323.1 - B */
DEFINE VARIABLE amt_base LIKE ar_amt.
DEFINE VARIABLE applied_base LIKE ar_amt.
/* SS - 20070323.1 - E */

{mfdeclre.i}
{cxcustom.i "ARCSRP5A.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{&ARCSRP5A-P-TAG1}
define variable rndmthd           like rnd_rnd_mthd no-undo.
define variable oldcurr           like ar_curr      no-undo.
/* SS - 20070301.1 - B */
/*
define shared variable age_days   as   integer extent 4
   label "Column Days".
*/   
define shared variable age_days   as   integer extent 9
   label "Column Days".
/* SS - 20070301.1 - E */

define shared variable age_by       as character format "x(3)"
   label "Age by Date (Due,Eff,Inv)".

define shared variable l_ageby as character format "x(1)".

define shared variable cust         like ar_bill.
define shared variable cust1        like ar_bill.
define shared variable cust_type    like cm_type label "Customer Type".
define shared variable cust_type1   like cm_type.
define shared variable nbr          like ar_nbr.
define shared variable nbr1         like ar_nbr.
define shared variable slspsn       like sp_addr.
define shared variable slspsn1      like slspsn.
define shared variable acct         like ar_acct.
define shared variable acct1        like ar_acct.
define shared variable sub          like ar_sub.
define shared variable sub1         like ar_sub.
define shared variable cc           like ar_cc.
define shared variable cc1          like ar_cc.
define shared variable entity       like gl_entity.
define shared variable entity1      like gl_entity.
define shared variable effdate1     like ar_effdate initial today.
define shared variable mstr_type    like cd_type initial "AR".
define shared variable mstr_lang    like cd_lang.
define shared variable lstype       like ls_type.
define shared variable summary_only like mfc_logical
   label "Summary/Detail"
   format "Summary/Detail"
   initial no.
define shared variable base_rpt     like ar_curr.
define shared variable show_po      like mfc_logical
   label "Show Customer PO"
   initial no.
define shared variable show_pay_detail like mfc_logical
   label "Show Payment Detail"
   initial no.
define shared variable show_comments like mfc_logical
   label "Show Invoice Comments"
   initial no.
define shared variable show_mstr_comments like mfc_logical
   label "Show Master Comments"
   initial no.

{&ARCSRP5A-P-TAG29}
define variable age_period       as integer               no-undo.
define variable i                as integer               no-undo.
define variable cm_recno         as recid                 no-undo.
define variable new_cust         as logical initial true  no-undo.
define variable use_rec          as logical initial false no-undo.
define variable rec_printed      as logical initial false no-undo.
/* SS - 20070301.1 - B */
/*
define variable age_range        as character extent 4
   format "x(15)"                                         no-undo.
define variable age_amt        like ar_amt format "->>>,>>>,>>9.99"
   extent 4                                               no-undo.

{&ARCSRP5A-P-TAG30}
define variable name           like ad_name               no-undo.
define variable balance        like cm_balance            no-undo.
define variable age_paid       like ar_amt extent 4       no-undo.
define variable sum_amt        like ar_amt extent 4       no-undo.
*/
define variable age_range        as character extent 9
   format "x(15)"                                         no-undo.
define variable age_amt        like ar_amt format "->>>,>>>,>>9.99"
   extent 9                                               no-undo.

{&ARCSRP5A-P-TAG30}
define variable name           like ad_name               no-undo.
define variable balance        like cm_balance            no-undo.
define variable age_paid       like ar_amt extent 9       no-undo.
define variable sum_amt        like ar_amt extent 9       no-undo.
/* SS - 20070301.1 - E */
define variable inv_tot        like ar_amt                no-undo.
define variable memo_tot       like ar_amt                no-undo.
define variable fc_tot         like ar_amt                no-undo.
define variable paid_tot       like ar_amt                no-undo.
define variable applied_amt    like ar_applied            no-undo.
define variable base_amt       like ar_amt                no-undo.
define variable base_applied   like ar_applied            no-undo.
define variable curr_amt       like ar_amt                no-undo.
define variable check_total      as decimal               no-undo.
define variable drft_tot       like ar_amt                no-undo.
{&ARCSRP5A-P-TAG31}
define variable age_by_date    like ap_date               no-undo.
define variable u_amt          like base_amt              no-undo.
define variable exdrate        like exr_rate              no-undo.
define variable exdrate2       like exr_rate              no-undo.
define variable exdratetype    like exr_ratetype          no-undo.
define variable tempamt        like ard_amt               no-undo.
define variable tempstr        as character format "x(25)" no-undo.
{&ARCSRP5A-P-TAG32}
define variable high_dun_level like ar_dun_level          no-undo.
define variable disp_dun_level like ar_dun_level format ">>" no-undo.
define variable total-amt      like ar_amt                no-undo.
define variable due-date       like ap_date               no-undo.
define variable applied-amt    like vo_applied            no-undo.
define variable amt-due        like ap_amt                no-undo.
define variable multi-due      like mfc_logical           no-undo.
define variable this-applied   like ar_applied            no-undo.
define shared variable mc-rpt-curr like base_rpt          no-undo.

define buffer armstr  for ar_mstr.
define buffer arddet  for ard_det.
define buffer armstr1 for ar_mstr.

{etrpvar.i }
{etvar.i   }

{&ARCSRP5A-P-TAG33}
/* SS - 20070301.1 - B */
/*
define variable et_age_amt          like age_amt extent 4 no-undo.
{&ARCSRP5A-P-TAG34}
define variable et_age_paid         like ar_amt extent 4  no-undo.
define variable et_sum_amt          like ar_amt extent 4  no-undo.
define variable et_base_amt         like ar_amt           no-undo.
define variable et_base_applied     like ar_amt           no-undo.
define variable et_curr_amt         like ar_amt           no-undo.
define variable et_inv_tot          like ar_amt           no-undo.
define variable et_memo_tot         like ar_amt           no-undo.
define variable et_fc_tot           like ar_amt           no-undo.
define variable et_paid_tot         like ar_amt           no-undo.
define variable et_drft_tot         like ar_amt           no-undo.
define variable et_org_sum_amt      like ar_amt extent 4 no-undo.
*/
define variable et_age_amt          like age_amt extent 9 no-undo.
{&ARCSRP5A-P-TAG34}
define variable et_age_paid         like ar_amt extent 9  no-undo.
define variable et_sum_amt          like ar_amt extent 9  no-undo.
define variable et_base_amt         like ar_amt           no-undo.
define variable et_base_applied     like ar_amt           no-undo.
define variable et_curr_amt         like ar_amt           no-undo.
define variable et_inv_tot          like ar_amt           no-undo.
define variable et_memo_tot         like ar_amt           no-undo.
define variable et_fc_tot           like ar_amt           no-undo.
define variable et_paid_tot         like ar_amt           no-undo.
define variable et_drft_tot         like ar_amt           no-undo.
define variable et_org_sum_amt      like ar_amt extent 9 no-undo.
/* SS - 20070301.1 - E */
define variable et_org_base_amt     like ar_amt           no-undo.
define variable et_org_base_applied like ar_amt           no-undo.
define variable et_org_curr_amt     like ar_amt           no-undo.
define variable et_org_inv_tot      like ar_amt           no-undo.
define variable et_org_memo_tot     like ar_amt           no-undo.
define variable et_org_fc_tot       like ar_amt           no-undo.
define variable et_org_paid_tot     like ar_amt           no-undo.
define variable et_org_amt          like ar_amt           no-undo.
define variable et_org_drft_tot     like ar_amt           no-undo.
define variable et_diff_exist         as logical initial false no-undo.

/*BEGIN PROGRAM*/

/*FOR ROUNDING AFTER CURRENCY CONVERSION*/
for first gl_ctrl
   fields(  gl_rnd_mthd)
   no-lock:
end. /* FOR FIRST gl_ctrl */

/* SS - 20070301.1 - B */
/*
/* CREATE REPORT HEADER */

do i = 2 to 4:
   age_range[i] = getTermLabelRt("OVER",8)
                + string(age_days[i - 1],"->>>9").
end. /* DO i = 2 TO 4 */

age_range[1] = getTermLabelRt("LESS_THAN",10) + string(age_days[1],"->>>9").

{&ARCSRP5A-P-TAG35}
form
   header
   space (47)
   getTermLabel("DUNNING",2) format "x(2)" /* FOR DUNNING LEVEL */
   age_range[1 for 4]        format "x(15)" skip
   getTermLabel("REFERENCE",8)
   getTermLabel("TYPE",1)    format "x(1)"
   getTermLabel("EFFECTIVE_DATE",8)
   getTermLabel("DUE_DATE",8)
   getTermLabel("INVOICE_DATE",8)
   getTermLabel("CREDIT_TERMS",8)
   getTermLabel("LEVEL",2)   format "x(2)" /* FOR DUNNING LEVEL */
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
{&ARCSRP5A-P-TAG36}
view frame phead1.
*/
/* SS - 20070301.1 - E */

do with frame c down no-box
   on endkey undo, leave:
   for each cm_mstr
       where  (cm_mstr.cm_addr     >= cust
             and cm_addr <= cust1)
      and   (cm_type     >= cust_type
             and cm_type <= cust_type1)
      no-lock
      {&ARCSRP5A-P-TAG76}
      by cm_sort:

      high_dun_level = 0.

      {&ARCSRP5A-P-TAG37}
      {&ARCSRP5A-P-TAG27}
      for each ar_mstr
          where (  ar_mstr.ar_bill              =
          cm_addr
         and  (ar_nbr              >= nbr
               and ar_nbr          <= nbr1)
         and ((ar_slspsn[1]        >= slspsn
               and ar_slspsn[1]    <= slspsn1)
              or (ar_slspsn[2]     >= slspsn
                  and ar_slspsn[2] <= slspsn1)
              or (ar_slspsn[3]     >= slspsn
                  and ar_slspsn[3] <= slspsn1)
              or (ar_slspsn[4]     >= slspsn
                  and ar_slspsn[4] <= slspsn1))
         and (ar_type               = "P"
              or (ar_entity        >= entity
                  and ar_entity    <= entity1))
         and (ar_type               = "P"
              and (ar_effdate      <= effdate1)
              or ((ar_effdate      <= effdate1)
                   or ar_effdate    = ? ))
         and (not ar_type           = "D"
              or ar_draft) /* APPRVD DRAFTS ONLY */
         and ((ar_curr              = base_rpt)
               or (base_rpt         = ""))
         and (ar_type               <> "A")
         ) no-lock
         break by ar_bill
               by ar_nbr
         {&ARCSRP5A-P-TAG38}
         with frame c width 132 no-labels:
         {&ARCSRP5A-P-TAG39}
         {&ARCSRP5A-P-TAG28}

         if (oldcurr    <> ar_curr)
            or (oldcurr = "")
         then do:

            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ar_curr,
                 output rndmthd,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
               pause 0.
               next.
            end. /* IF mc-error-number <> 0 */

            oldcurr = ar_curr.
         end.  /* IF (oldcurr <> ar_curr) OR (oldcurr = "") */

         if lstype = ""
            or (lstype <> ""
            and can-find(first ls_mstr
                where ls_mstr.ls_type = lstype
               and   ls_addr = cm_addr))
         then do:

            /* STORE FIRST CUSTOMER INFORMATION IN A LOGICAL */
            /* SINCE THE ACCOUNT VALIDATION MAY CAUSE THE    */
            /* ACTUAL FIRST RECORD TO BE SKIPPED             */
            if first-of(ar_bill)
            then
               new_cust = true.

            /* VALIDATE THE AR ACCOUNT (IF RANGE SPECIFIED)  */
            use_rec = true.
            if ar_type <> "P"
            then do:

               if (ar_acct   < acct
                  or ar_acct > acct1)
                  or (ar_sub < sub
                  or ar_sub  > sub1)
                  or (ar_cc  < cc
                  or ar_cc   > cc1)
               then
                  use_rec = false.

               /* SS - 20070301.1 - B */
               if (ar_acct   < acct
                  or ar_acct > acct1)
                  or (ar_sub < sub
                  or ar_sub  > sub1)
                  or (ar_cc  < cc
                  or ar_cc   > cc1)
               then
               DO:
                   t_acct = ar_acct.
                   t_sub = ar_sub.
                   t_cc = ar_cc.
               END.
               /* SS - 20070301.1 - E */

            end. /* IF ar_type <> "P" */
            else do:
               /* PAYMENTS: GET THE DETAIL TO DETERMINE MEETING */
               /* THE CRITERIA, THIS WILL BE USED TO BACK THE   */
               /* AMOUNTS NOT APPLIED AT TIME OF THE EFFECTIVE  */
               /* DATE LATER IN THE PROGRAM. ALWAYS EXCLUDE THE */
               /* NON-AR REGARDLESS OF CRITERIA. NON-AR IS      */
               /* NEVER TO SHOW UP ON REPORT.                   */
               assign
                  use_rec = false
                  u_amt   = 0.

               for each ard_det
                   where ard_det.ard_nbr =
                   ar_nbr
                  no-lock:

                  if ard_typ <> "n"
                  then
                     if (ard_entity >= entity
                        and ard_entity <= entity1
                        and ard_acct   >= acct
                        and ard_acct   <= acct1
                        and ard_sub    >= sub
                        and ard_sub    <= sub1
                        and ard_cc     >= cc
                        and ard_cc     <= cc1)
                     then
                        assign
                           use_rec = true
                           u_amt   = if ard_type = "U"
                                     then
                                        u_amt - ard_amt - ard_disc
                                     else
                                        u_amt - ard_amt.

                                        /* SS - 20070301.1 - B */
                                        if ard_typ <> "n"
                                        then
                                           if (ard_entity >= entity
                                              and ard_entity <= entity1
                                              and ard_acct   >= acct
                                              and ard_acct   <= acct1
                                              and ard_sub    >= sub
                                              and ard_sub    <= sub1
                                              and ard_cc     >= cc
                                              and ard_cc     <= cc1)
                                           then
                                                 if ard_type = "U" THEN DO:
                                                    t_acct = ard_acct.
                                                    t_sub = ard_sub.
                                                    t_cc = ard_cc.
                                                 END.
                                        /* SS - 20070301.1 - E */

               end. /* FOR EACH ard_det */
            end. /* ELSE DO */

            if use_rec
            then do:
               {&ARCSRP5A-P-TAG2}
               {&ARCSRP5A-P-TAG40}
               form
                  ar_nbr format "x(8)"
                  ar_type
                  ar_effdate
                  ar_due_date
                  ar_date
                  ar_cr_terms
                  ar_dun_level format ">>"
                  et_age_amt[ 1 for 4]
                  ar_amt
               with frame c width 132.
               {&ARCSRP5A-P-TAG41}
               {&ARCSRP5A-P-TAG3}

               /* SS - 20070301.1 - B */
               /*
               do i = 1 to 4:
               */
               do i = 1 to 9:
               /* SS - 20070301.1 - E */
                  assign
                     age_amt[i]     = 0
                     age_paid[i]    = 0
                     sum_amt[i]     = 0
                     et_age_amt[i]  = 0
                     et_age_paid[i] = 0
                     et_sum_amt[i]  = 0.
               end. /* DO i = 1 TO 4 */

               if l_ageby = "2"
               then
                  age_by_date = ar_effdate.
               else
               if l_ageby = "3"
               then
                  age_by_date = ar_date.
               else do:
                  if ar_type <> "P"
                  then
                     age_by_date = ar_due_date.
                  else
                     age_by_date = ar_date.
               end. /* ELSE DO */

               /* SS - 20070301.1 - B */
               /*
               age_period = 4.
               do i = 1 to 4:
                  if (effdate1 - age_days[i]) <= age_by_date
                  then
                     age_period = i.
                  if age_period <> 4
                  then
                     leave.
               end. /* DO i = 1 TO 4 */
               */
               age_period = 9.
               do i = 1 to 9:
                  if (effdate1 - age_days[i]) <= age_by_date
                  then
                     age_period = i.
                  if age_period <> 9
                  then
                     leave.
               end. /* DO i = 1 TO 4 */
               /* SS - 20070301.1 - E */

               if age_by_date = ?
               then
                  age_period = 1.

               applied_amt = 0.

               {&ARCSRP5A-P-TAG4}

               /* SEE IF PAID PRIOR TO EFFDATE */
               {&ARCSRP5A-P-TAG82}
               do for armstr:
                  {&ARCSRP5A-P-TAG5}

                  /* IF INVOICE OR MEMO */
                  if ar_mstr.ar_type <> "P"
                  then do:
                     check_total = 0.

                     /*SEE IF OPEN ITEM PASSES CRITERIA CHECK*/
                     if ar_mstr.ar_entity     >= entity
                        and ar_mstr.ar_entity <= entity1
                        and ar_mstr.ar_acct   >= acct
                        and ar_mstr.ar_acct   <= acct1
                        and ar_mstr.ar_sub    >= sub
                        and ar_mstr.ar_sub    <= sub1
                        and ar_mstr.ar_cc     >= cc
                        and ar_mstr.ar_cc     <= cc1
                     then do:

                        /* FOR EACH PAYMENT DETAIL LINE FOR */
                        /* THIS INVOICE/MEMO                */
                        for each ard_det
                            where ard_det.ard_ref = ar_mstr.ar_nbr
                           no-lock:

                           /* FIND PAYMENT HEADER FOR THIS */
                           /* PAYMENT DETAIL LINE          */
                           for first armstr
                              fields( ar_acct
                                      ar_amt
                                      ar_applied
                                      ar_bill
                                      ar_cc
                                      ar_check
                                      ar_cmtindx
                                      ar_cr_terms
                                      ar_curr
                                      ar_date
                                      ar_draft
                                      ar_due_date
                                      ar_dun_level
                                      ar_effdate
                                      ar_entity
                                      ar_ex_rate
                                      ar_ex_rate2
                                      ar_nbr
                                      ar_po
                                      ar_slspsn
                                      ar_sub
                                      {&ARCSRP5A-P-TAG62}
                                      ar_type)
                               where 
                               armstr.ar_nbr = ard_nbr
                              no-lock:
                           end. /* FOR FIRST armstr */

                           if available armstr
                              and (armstr.ar_type = "P"
                               or  armstr.ar_type = "D"
                               or  armstr.ar_type = "A")
                           then do:

                              /* ONLY EXECUTE THE FOLLOWING CODE    */
                              /* IF WE'VE FOUND A PAYMENT OR DRAFT  */
                              /* RECORD.  OTHERWISE, THIS IS A MEMO */
                              /* OR INVOICE TO WHICH A DRAFT WAS    */
                              /* APPLIED                            */
                              if armstr.ar_effdate <= effdate1
                                 and ard_type      <> "n"
                              then do:
                                 {&ARCSRP5A-P-TAG17}
                                 if ar_mstr.ar_curr <> armstr.ar_curr
                                 then
                                    applied_amt = applied_amt
                                                + ard_cur_amt
                                                + ard_cur_disc.

                                    /* applied_amt IS USED IN PLACE OF */
                                    /* applied_base_amt TO ELIMINATE ROUNDING */
                                    /* ERRORS */

                                 else
                                    applied_amt = applied_amt
                                                + ard_amt
                                                + ard_disc.
                                 {&ARCSRP5A-P-TAG18}
                              end. /* EFF DATE, TYPE CHECK */
                              {&ARCSRP5A-P-TAG19}

                              if ar_mstr.ar_curr <> armstr.ar_curr
                              then
                                 check_total = check_total
                                             + ard_cur_amt
                                             + ard_cur_disc.
                              else
                                 check_total = check_total
                                             + ard_amt
                                             + ard_disc.
                              {&ARCSRP5A-P-TAG20}
                           end. /* IF AVAIL armstr */

                        end. /* FOR EACH ard_det */

                        /* THE FOLLOWING CODE IS PRESENT TO DETECT */
                        /* THE SITUATION WHERE MEMOS OR INVOICES   */
                        /* HAD PARTIAL PMTS THAT HAVE BEEN ARCHIVED*/
                        /* /DELETED                                */
                        {&ARCSRP5A-P-TAG23}
                        if check_total <> ar_mstr.ar_applied
                           and ar_mstr.ar_open
                        then
                           {&ARCSRP5A-P-TAG24}
                           {&ARCSRP5A-P-TAG74}
                            applied_amt = applied_amt
                                       + (ar_mstr.ar_applied
                                       - check_total).
                           {&ARCSRP5A-P-TAG75}

                     end. /* AR_ACCT/AR_ENTITY CHECK */

                  end. /* IF ar_mstr.ar_type */

                  /* OTHERWISE AR_MSTR IS A PAYMENT RECORD */
                  else do:

                     /* UNROLL PAYMENT TO SEE OPEN ITEMS. CHECK */
                     /* TO SEE WHAT WAS UNAPPLIED PRIOR TO      */
                     /* EFFECTIVE DATE                          */
                     for each ard_det
                         where ard_det.ard_nbr
                         = ar_mstr.ar_nbr
                        no-lock:

                        /*SEE IF OPEN ITEM EXISTED PRIOR TO EFF DATE*/
                        if ard_type <> "U"
                        then do:
                           for first armstr
                              fields( ar_acct
                                      ar_amt
                                      ar_applied
                                      ar_bill
                                      ar_cc
                                      ar_check
                                      ar_cmtindx
                                      ar_cr_terms
                                      ar_curr
                                      ar_date
                                      ar_draft
                                      ar_due_date
                                      ar_dun_level
                                      ar_effdate
                                      ar_entity
                                      ar_ex_rate
                                      ar_ex_rate2
                                      ar_nbr
                                      ar_po
                                      ar_slspsn
                                      ar_sub
                                      {&ARCSRP5A-P-TAG62}
                                      ar_type)
                               where 
                               armstr.ar_nbr = ard_ref
                              no-lock:
                           end. /* FOR FIRST armstr */

                           if (available armstr
                              and armstr.ar_effdate <= effdate1
                              and armstr.ar_entity  >= entity
                              and armstr.ar_entity  <= entity1
                              and armstr.ar_acct    >= acct
                              and armstr.ar_acct    <= acct1
                              and armstr.ar_sub     >= sub
                              and armstr.ar_sub     <= sub1
                              and armstr.ar_cc      >= cc
                              and armstr.ar_cc      <= cc1)
                              and ard_type          <> "n"
                           then
                              applied_amt = applied_amt - ard_amt.

                        end. /* ARD_TYPE <> U */
                     end. /* FOR EACH ARD_DET */

                     /* FOR EACH APPLIED UNAPPLIED FOR THIS */
                     /* UNAPPLIED PAYMENT, CHECK TO SEE IF  */
                     /* OPEN ITEM MEETS CRITERIA.           */
                     for each armstr
                         where 
                         armstr.ar_check    = ar_mstr.ar_check
                        and   armstr.ar_bill     = ar_mstr.ar_bill
                        and   armstr.ar_type     = "A"
                        and   armstr.ar_effdate <= effdate1
                        and   armstr.ar_acct    >= acct
                        and   armstr.ar_acct    <= acct1
                        and   armstr.ar_sub     >= sub
                        and   armstr.ar_sub     <= sub1
                        and   armstr.ar_cc      >= cc
                        and   armstr.ar_cc      <= cc1
                        and   armstr.ar_entity  >= entity
                        and   armstr.ar_entity  <= entity1
                        no-lock:

                        /* LINES OF THE APPLIED, THIS IS THE    */
                        /* UNAPLIED RECORD ENTITY FILTERING ON  */
                        /* THE ARD_DET SEEMS INCONSISTENT WITH  */
                        /* ACCT FILTERING ON AR_MSTR.           */
                        for each arddet
                            where 
                            arddet.ard_nbr = armstr.ar_nbr
                           no-lock:

                           for first armstr1
                              fields( ar_acct
                                      ar_amt
                                      ar_applied
                                      ar_bill
                                      ar_cc
                                      ar_check
                                      ar_cmtindx
                                      ar_cr_terms
                                      ar_curr
                                      ar_date
                                      ar_draft
                                      ar_due_date
                                      ar_dun_level
                                      ar_effdate
                                      ar_entity
                                      ar_ex_rate
                                      ar_ex_rate2
                                      ar_nbr
                                      ar_po
                                      ar_slspsn
                                      ar_sub
                                      {&ARCSRP5A-P-TAG62}
                                      ar_type)
                               where 
                               armstr1.ar_nbr = arddet.ard_ref
                              no-lock:
                           end. /* FOR FIRST armstr1 */

                           if available armstr1
                              and armstr1.ar_effdate <= effdate1
                           then
                              applied_amt = applied_amt - arddet.ard_amt.
                        end. /* FOR EACH ARDDET */
                     end. /* FOR EACH ARMSTR */

                  end. /* ar_mstr IS A PAYMENT (ELSE DO:) */

               end. /* DO FOR armstr */

               if ar_type = "P"
               then
                  assign
                     curr_amt = u_amt - applied_amt
                     base_amt = u_amt.
               else
                  assign
                     base_amt = ar_amt
                     curr_amt = ar_amt - applied_amt.

               base_applied = applied_amt.
               /* SS - 20070323.1 - B */
               amt_base = base_amt.
               applied_base = base_applied.
               /* SS - 20070323.1 - E */
               {&ARCSRP5A-P-TAG42}

               if base_rpt = ""
                  and (base_amt - base_applied) <> 0
                  and  ar_curr                  <> base_curr
               then do:

                  /* IF RUNNING REPORT IN BASE, AND WORKING ON A   */
                  /* NON-BASE CURRENCY MEMO OR INVOICE, USE THE    */
                  /* APPLIED BASE AMOUNT CALCULATED WHEN FILTERING */
                  /* THROUGH THE PAYMENTS                          */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input ar_curr,
                       input base_curr,
                       input ar_ex_rate,
                       input ar_ex_rate2,
                       input base_amt,
                       input true,  /* ROUND */
                       output base_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF mc-error-number <> 0 */

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input ar_curr,
                       input base_curr,
                       input ar_ex_rate,
                       input ar_ex_rate2,
                       input base_applied,
                       input true,  /* ROUND */
                       output base_applied,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF mc-error-number <> 0 */

                  /* SHOULD NOT SKIP A CUSTOMER AND ITS INVOICES/ */
                  /* MEMOS DETAILS WHEN EXCHANGE RATE IS NOT      */
                  /* DEFINED FOR THE EFFECTIVE DATE OF THE REPORT */

                  /* GET EXCHANGE RATE */
                  {&ARCSRP5A-P-TAG6}
                  {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                     "(input ar_curr,
                       input base_curr,
                       input exdratetype,
                       input effdate1,
                       output exdrate,
                       output exdrate2,
                       output mc-error-number)"}
                  {&ARCSRP5A-P-TAG7}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
                     pause 0.
                  end. /* IF mc-error-number <> 0 */

                  if mc-error-number = 0
                  then do:
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input ar_curr,
                          input base_curr,
                          input exdrate,
                          input exdrate2,
                          input curr_amt,
                          input true, /* ROUND */
                          output curr_amt,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */
                  end.  /* IF mc-error-number = 0 */

                  /* IF NO EXCHANGE RATE FOR TODAY, */
                  /* USE THE INVOICE RATE           */
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
                          output mc-error-number)"}.
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */
                  end. /* ELSE DO */

               end. /* IF BASE_RPT = "" */

               {&ARCSRP5A-P-TAG68}
               /* DON'T DISPLAY IF CLOSED */
               if base_amt - base_applied <> 0
               then do:
               {&ARCSRP5A-P-TAG69}
                  multi-due = no.

                  /*CHECK FOR CREDIT DATING TERMS */
                  for first ct_mstr
                     fields( ct_code
                             ct_dating
                             ct_due_date
                             ct_due_days
                             ct_due_inv)
                      where ct_mstr.ct_code =
                      ar_cr_terms
                     and   l_ageby  = "1"
                     no-lock:
                  end. /* FOR FIRST ct_mstr */

                  if available ct_mstr
                     and ct_dating = yes
                  then do:
                     assign
                        multi-due   = yes
                        applied-amt = base_applied
                        total-amt   = 0.

                     for each ctd_det
                         where ctd_det.ctd_code
                         = ar_cr_terms
                        no-lock
                        break by ctd_code:

                        for first ct_mstr
                           fields( ct_code
                                   ct_dating
                                   ct_due_date
                                   ct_due_days
                                   ct_due_inv)
                            where ct_mstr.ct_code = ctd_date_cd
                           no-lock:
                        end. /* FOR FIRST ct_mstr */

                        if available ct_mstr
                        then do:
                           {&ARCSRP5A-P-TAG8}
                           if ct_due_inv = 1
                           then
                              due-date  = ar_date + ct_due_days.
                           else       /* FROM END OF MONTH */
                              due-date = date((month(ar_date) + 1)
                                              modulo 12 + if month(ar_date) = 11
                                                          then
                                                             12
                                                          else
                                                             0, 1, year(ar_date)
                                                       + if month(ar_date) >= 12
                                                          then
                                                             1
                                                          else
                                                             0)
                                          + integer(ct_due_days)
                                          - if ct_due_days <> 0
                                            then
                                               1
                                            else
                                               0.

                           if ct_due_date <> ?
                           then
                              due-date = ct_due_date.
                           {&ARCSRP5A-P-TAG9}

                           /*CALCULTE AMT-DUE LESS THE APPLIED */
                           /* FOR THIS SEGMENT */
                           /* TO PREVENT ROUNDING ERRORS ASSIGN   */
                           /* LAST BUCKET   =                     */
                           /* ROUNDED TOTAL - RUNNING TOTAL       */
                           if last-of(ctd_code)
                           then
                              amt-due = base_amt - total-amt.
                           else
                              amt-due = base_amt * (ctd_pct_due / 100).

                           if ar_mstr.ar_curr <> base_curr
                              and base_rpt     = ""
                           then do:
                              /* ROUND PER BASE ROUND METHOD */

                              {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                 "(input-output amt-due,
                                   input gl_rnd_mthd,
                                   output mc-error-number)"}
                              if mc-error-number <> 0
                              then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                              end. /* IF mc-error-number <> 0 */
                           end. /* IF ar_mstr <> base_curr */

                           else do:
                              /* ROUND PER AR_CURR ROUND METHOD */

                              {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                 "(input-output amt-due,
                                   input rndmthd,
                                   output mc-error-number)"}
                              if mc-error-number <> 0
                              then do:
                                 {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                              end. /* IF mc-error-number <> 0 */
                           end. /* ELSE DO */

                           total-amt = total-amt + amt-due.

                           if ar_amt >= 0
                           then
                              this-applied = min(amt-due, applied-amt).
                           else
                              this-applied = max(amt-due, applied-amt).

                           /* SS - 20070301.1 - B */
                           /*
                           assign
                              applied-amt = applied-amt - this-applied
                              age_period  = 4.

                           do i = 1 to 4:
                              if (effdate1 - age_days[i]) <= due-date
                              then
                                 age_period = i.
                              if age_period <> 4
                              then
                                 leave.
                           end. /* DO i = 1 TO 4 */
                           */
                           assign
                              applied-amt = applied-amt - this-applied
                              age_period  = 9.

                           do i = 1 to 9:
                              if (effdate1 - age_days[i]) <= due-date
                              then
                                 age_period = i.
                              if age_period <> 9
                              then
                                 leave.
                           end. /* DO i = 1 TO 4 */
                           /* SS - 20070301.1 - E */

                           if due-date = ?
                           then
                              age_period = 1.

                           age_amt[age_period] = age_amt[age_period] + amt-due.

                           if not show_pay_detail
                           then
                              age_amt[age_period] = age_amt[age_period]
                                                  - this-applied.

                           assign
                              sum_amt[age_period]  = sum_amt[age_period]
                                                   + amt-due
                                                   - this-applied
                              age_paid[age_period] = age_paid[age_period]
                                                   + this-applied.
                        end. /*IF AVAIL ct_mstr*/

                        if ctd_pct_due = 100
                        then
                           leave.
                     end. /*FOR EACH ctd_det*/
                  end. /*IF AVAILABLE ct_mstr & ct_dating = YES*/

                  else do:
                     if not show_pay_detail
                        or ar_type = "P"
                     then
                        age_amt[age_period] = base_amt - base_applied.
                     else
                        age_amt[age_period] = base_amt.

                     assign
                        age_paid[age_period] =  base_applied * (-1)
                        sum_amt[age_period] = base_amt - base_applied.
                  end. /* ELSE DO */

                  {&ARCSRP5A-P-TAG63}

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

                  {&ARCSRP5A-P-TAG43}
                  /* SS - 20070301.1 - B */
                  /*
                  do i = 1 to 4:
                  */
                  do i = 1 to 9:
                  /* SS - 20070301.1 - E */
                     if et_report_curr <> mc-rpt-curr
                     then do:
                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input mc-rpt-curr,
                             input et_report_curr,
                             input et_rate1,
                             input et_rate2,
                             input sum_amt[i],
                             input true,  /* ROUND */
                             output et_sum_amt[i],
                             output mc-error-number)"}
                        if mc-error-number <> 0
                        then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        end. /* IF mc-error-number <> 0 */

                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input mc-rpt-curr,
                             input et_report_curr,
                             input et_rate1,
                             input et_rate2,
                             input age_amt[i],
                             input true,  /* ROUND */
                             output et_age_amt[i],
                             output mc-error-number)"}
                        if mc-error-number <> 0
                        then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        end. /* IF mc-error-number <> 0 */

                        {gprunp.i "mcpl" "p" "mc-curr-conv"
                           "(input mc-rpt-curr,
                             input et_report_curr,
                             input et_rate1,
                             input et_rate2,
                             input age_paid[i],
                             input true,  /* ROUND */
                             output et_age_paid[i],
                             output mc-error-number)"}
                        if mc-error-number <> 0
                        then do:
                           {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                        end. /* IF mc-error-number <> 0 */
                     end.  /* IF et_report_curr <> mc-rpt-curr */
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
                          input true,  /* ROUND */
                          output et_base_amt,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input base_applied,
                          input true,  /* ROUND */
                          output et_base_applied,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input inv_tot,
                          input true,  /* ROUND */
                          output et_inv_tot,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input memo_tot,
                          input true,  /* ROUND */
                          output et_memo_tot,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input fc_tot,
                          input true,  /* ROUND */
                          output et_fc_tot,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input paid_tot,
                          input true,  /* ROUND */
                          output et_paid_tot,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input drft_tot,
                          input true,  /* ROUND */
                          output et_drft_tot,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */

                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input mc-rpt-curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input curr_amt,
                          input true,  /* ROUND */
                          output et_curr_amt,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     end. /* IF mc-error-number <> 0 */
                     {&ARCSRP5A-P-TAG44}
                  end.  /* IF et_report_curr <> mc-rpt-curr */
                  else
                     assign
                        et_base_amt     = base_amt
                        et_base_applied = base_applied
                        et_inv_tot      = inv_tot
                        et_memo_tot     = memo_tot
                        et_fc_tot       = fc_tot
                        et_paid_tot     = paid_tot
                        et_drft_tot     = drft_tot
                        {&ARCSRP5A-P-TAG45}
                        et_curr_amt     = curr_amt.

                  {&ARCSRP5A-P-TAG77}
                  accumulate et_sum_amt (total by ar_bill).
                  accumulate et_base_amt - et_base_applied (total by ar_bill).
                  {&ARCSRP5A-P-TAG78}

                  accumulate et_inv_tot  (total).
                  accumulate et_memo_tot (total).
                  accumulate et_fc_tot   (total).
                  accumulate et_paid_tot (total).
                  accumulate et_drft_tot (total).
                  accumulate et_curr_amt (total).
                  {&ARCSRP5A-P-TAG46}

                  {&ARCSRP5A-P-TAG10}

                  accumulate sum_amt (total by ar_bill).
                  accumulate base_amt - base_applied (total by ar_bill).
                  /* SS - 20070323.1 - B */
                  accumulate amt_base - applied_base (total by ar_bill).
                  /* SS - 20070323.1 - E */
                  accumulate inv_tot (total).
                  accumulate memo_tot (total).
                  accumulate fc_tot (total).
                  accumulate paid_tot (total).
                  accumulate drft_tot (total).
                  accumulate curr_amt (total).

                  /* Display customer header line */
                  if new_cust
                     and age_amt[age_period] <> 0
                  then
                     do with frame b down:
                     assign
                        new_cust    = false
                        rec_printed = true
                        name        = "".
                     for first ad_mstr
                        fields( ad_addr
                                ad_attn
                                ad_ext
                                ad_name
                                ad_phone
                                ad_state)
                         where ad_mstr.ad_addr =
                         ar_bill
                        no-lock:
                     end. /* FOR FIRST ad_mstr */

                     assign
                        cm_recno = recid(cm_mstr)
                        balance  = cm_balance.

                     /* SS - 20070301.1 - B */
                     /*
                     if available ad_mstr
                     then
                        name = ad_name.

                      if page-size - line-counter < 4
                     then
                        page.

                     /* SET EXTERNAL LABELS */
                     setFrameLabels(frame b:handle).
                     display
                        ar_bill no-label
                        name    no-label
                        ad_state
                        cm_pay_date
                        ad_attn    label "Attn"
                        ad_phone   label "Tel"
                        ad_ext  no-label
                     with frame b side-labels width 132.

                     if show_mstr_comments
                     then do:
                        {gpcdprt.i &type = mstr_type
                                   &ref  = cm_addr
                                   &lang = mstr_lang
                                   &pos  = 10}
                     end. /* IF show_mstr_comments */

                     if summary_only = no
                     then
                        down 1.
                     */
                     /* SS - 20070301.1 - E */
                  end. /* IF new_cust ... */

                  if summary_only             = no
                     and age_amt[age_period] <> 0
                  then do with frame c:
                     /* SS - 20070301.1 - B */
                      CREATE tta6arcsrp0501.
                      ASSIGN
                          tta6arcsrp0501_bill = ar_bill
                          tta6arcsrp0501_ar_nbr = ar_nbr
                          tta6arcsrp0501_ar_type = ar_type
                          .

                      IF ar_type <> "P" THEN DO:
                          ASSIGN
                              tta6arcsrp0501_acct = ar_acct
                              tta6arcsrp0501_sub = ar_sub
                              tta6arcsrp0501_cc = ar_cc
                              .
                      END.
                      ELSE DO:
                          FIND FIRST bard
                             WHERE  bard.ard_nbr = ar_nbr 
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
                                  tta6arcsrp0501_acct = bard.ard_acct
                                  tta6arcsrp0501_sub = bard.ard_sub
                                  tta6arcsrp0501_cc = bard.ard_cc
                                  .
                          END.
                          ELSE DO:
                              ASSIGN
                                  tta6arcsrp0501_acct = ar_acct
                                  tta6arcsrp0501_sub = ar_sub
                                  tta6arcsrp0501_cc = ar_cc
                                  .
                          END.
                      END.

                     {&ARCSRP5A-P-TAG11}
                     if ar_type <> "P"
                     THEN DO:
                        ASSIGN
                           tta6arcsrp0501_nbr = ar_nbr
                           tta6arcsrp0501_type = ar_type
                           .
                     END.
                     ELSE DO:
                        ASSIGN
                           tta6arcsrp0501_nbr = ar_check
                           tta6arcsrp0501_type = "U"
                           .
                     END.
                     {&ARCSRP5A-P-TAG12}

                     if not multi-due
                     THEN DO:
                        ASSIGN
                           tta6arcsrp0501_effdate = ar_effdate
                           tta6arcsrp0501_due_date = ar_due_date
                           tta6arcsrp0501_date = ar_date
                           tta6arcsrp0501_cr_terms = ar_cr_terms
                           tta6arcsrp0501_dun_level = ar_dun_level
                           .
                     END.
                     ELSE DO:
                        ASSIGN
                           tta6arcsrp0501_effdate = ar_effdate
                           tta6arcsrp0501_date = ar_date
                           tta6arcsrp0501_cr_terms = ar_cr_terms
                           tta6arcsrp0501_dun_level = ar_dun_level
                           .
                     END.

                     ASSIGN
                        tta6arcsrp0501_et_age_amt[1] = et_age_amt[1]
                        tta6arcsrp0501_et_age_amt[2] = et_age_amt[2]
                        tta6arcsrp0501_et_age_amt[3] = et_age_amt[3]
                        tta6arcsrp0501_et_age_amt[4] = et_age_amt[4]
                        tta6arcsrp0501_et_age_amt[5] = et_age_amt[5]
                        tta6arcsrp0501_et_age_amt[6] = et_age_amt[6]
                        tta6arcsrp0501_et_age_amt[7] = et_age_amt[7]
                        tta6arcsrp0501_et_age_amt[8] = et_age_amt[8]
                        tta6arcsrp0501_et_age_amt[9] = et_age_amt[9]
                        tta6arcsrp0501_amt = (et_base_amt - et_base_applied)
                        /* SS - 20070323.1 - B */
                        tta6arcsrp0501_curr_amt = (amt_base - applied_base)
                        /* SS - 20070323.1 - E */
                        tta6arcsrp0501_ar_curr = ar_curr
                        tta6arcsrp0501_ar_po = ar_po
                        .

                     /*
                     {&ARCSRP5A-P-TAG11}
                     if ar_type <> "P"
                     then
                        display
                           ar_nbr
                           ar_type.
                     else
                        display
                           ar_check @ ar_nbr
                           "U"      @ ar_type.
                     {&ARCSRP5A-P-TAG12}

                     if not multi-due
                     then
                        display
                           ar_effdate
                           ar_due_date
                           ar_date
                           ar_cr_terms
                           ar_dun_level.
                     else
                        display
                           ar_effdate
                           getTermLabel("MULTIPLE",8) @ ar_due_date
                           ar_date
                           ar_cr_terms
                           ar_dun_level.

                     {&ARCSRP5A-P-TAG61}
                     if not show_pay_detail
                        or ar_type = "P"
                     then do:
                        display et_age_amt[1 for 4]
                                {&ARCSRP5A-P-TAG67}
                                (et_base_amt - et_base_applied) @ ar_amt.
                        down 1.
                        {&ARCSRP5A-P-TAG47}
                        {&ARCSRP5A-P-TAG73}
                     end. /* IF NOT show_pay_detail */
                     else do:
                        display et_age_amt[1 for 4]
                                {&ARCSRP5A-P-TAG64}
                                et_base_amt @ ar_amt.
                                {&ARCSRP5A-P-TAG65}
                        down 1.

                        {&ARCSRP5A-P-TAG48}
                        if base_applied <> 0
                        then do:
                           {&ARCSRP5A-P-TAG70}
                           display
                              et_age_paid[1] @ et_age_amt[1]
                              et_age_paid[2] @ et_age_amt[2]
                              et_age_paid[3] @ et_age_amt[3]
                              et_age_paid[4] @ et_age_amt[4]
                              et_base_applied * (-1) @ ar_amt.
                           {&ARCSRP5A-P-TAG49}
                           down 1.
                           {&ARCSRP5A-P-TAG50}
                           /* SHOW PAYMENT DETAIL */
                           for each ard_det
                               where ard_det.ard_ref = ar_nbr
                              no-lock with frame c:

                              for first armstr
                                 fields( ar_acct
                                         ar_amt
                                         ar_applied
                                         ar_bill
                                         ar_cc
                                         ar_check
                                         ar_cmtindx
                                         ar_cr_terms
                                         ar_curr
                                         ar_date
                                         ar_draft
                                         ar_due_date
                                         ar_dun_level
                                         ar_effdate
                                         ar_entity
                                         ar_ex_rate
                                         ar_ex_rate2
                                         ar_nbr
                                         ar_po
                                         ar_slspsn
                                         ar_sub
                                         {&ARCSRP5A-P-TAG62}
                                         ar_type)
                                  where 
                                  armstr.ar_nbr      = ard_nbr
                                 and   armstr.ar_effdate <= effdate1
                                 no-lock:
                              end. /* FOR FIRST armstr */

                              if available armstr
                              then do:
                                 if (armstr.ar_type    = "P"
                                    or  armstr.ar_type = "D"
                                    or  armstr.ar_type = "A")
                                 then do:
                                    {&ARCSRP5A-P-TAG25}
                                    display
                                       armstr.ar_type
                                       {&ARCSRP5A-P-TAG15}
                                       @ ar_mstr.ar_type
                                       {&ARCSRP5A-P-TAG16}
                                       armstr.ar_effdate
                                       @ ar_mstr.ar_effdate
                                       {&ARCSRP5A-P-TAG72}
                                       armstr.ar_check
                                       @ ar_mstr.ar_cr_terms.
                                    down 1.
                                    {&ARCSRP5A-P-TAG26}
                                 end. /* IF (armstr.ar_type = "P" */
                              end. /* IF AVAILABLE armstr ... */
                           end. /* FOR EACH ard_det ... */
                           {&ARCSRP5A-P-TAG71}
                        end. /* IF base_applied <> 0 */
                     end. /* ELSE DO: */

                     {&ARCSRP5A-P-TAG66}

                     if show_po and ar_po <> ""
                     then
                        put ar_po at 10.

                     /* DISPLAY DOCUMENT COMMENTS */
                     if show_comments and ar_cmtindx <> 0
                     then do:
                        {arcscmt.i &cmtindx = ar_cmtindx
                                   &subhead = "ar_nbr format ""X(8)"" "}
                     end. /* IF show_comments AND ar_cmtindx <> 0 */
                     */
                     /* SS - 20070301.1 - E */
                  end. /* IF summary_only ... */

                  if summary_only
                  then
                     /* SAVE HIGHEST DUNNING LEVEL */
                     /* FOR THIS CUSTOMER */
                     if ar_dun_level > high_dun_level
                     then
                        high_dun_level = ar_dun_level.
               end. /* IF base_amt ... */
            end.  /* use_rec BLOCK */

            {&ARCSRP5A-P-TAG83}
            {&ARCSRP5A-P-TAG79}

            /* SS - 20070301.1 - B */
            /*
            /* CUSTOMER TOTALS */
            if last-of(ar_bill)
               and rec_printed
            then do:
               rec_printed = false.

               if summary_only = no
               then do:
                  if page-size - line-counter < 2
                  then
                     page.

                  underline et_age_amt ar_amt.
                  {&ARCSRP5A-P-TAG51}
               end. /* IF summary_only = NO */

               display
                  {&ARCSRP5A-P-TAG52}
                  "    " + et_report_curr @ ar_nbr
                  getTermLabel("CUSTOMER",8) @ ar_effdate
                  getTermLabelRtColon("TOTALS",8) @ ar_cr_terms
                  {&ARCSRP5A-P-TAG53}
                  accum total by ar_bill (et_sum_amt[1]) @ et_age_amt[1]
                  accum total by ar_bill (et_sum_amt[2]) @ et_age_amt[2]
                  accum total by ar_bill (et_sum_amt[3]) @ et_age_amt[3]
                  accum total by ar_bill (et_sum_amt[4]) @ et_age_amt[4]
                  {&ARCSRP5A-P-TAG54}
                  accum total by ar_bill (et_base_amt - et_base_applied)
                                                         @ ar_amt.
               down 1.
               {&ARCSRP5A-P-TAG55}
            end.  /* CUSTOMER TOTALS */
            {&ARCSRP5A-P-TAG80}
            */
            /* SS - 20070301.1 - E */
            
         end.  /* IF LSTYPE */
      end. /* FOR EACH ar_mstr */
      {&ARCSRP5A-P-TAG56}

      {&ARCSRP5A-P-TAG81}

      {mfrpchk.i}
   end. /* FOR EACH cm_mstr */

   /* SS - 20070301.1 - B */
   /*
   /* REPORT TOTALS */
   if page-size - line-counter < 3
   then
      page.
   else
      down 2.

   underline et_age_amt ar_amt.
   {&ARCSRP5A-P-TAG57}
   display
      "    " + et_report_curr @ ar_nbr
      getTermLabel("REPORT",8) @ ar_effdate
      getTermLabelRtColon("TOTALS",8) @ ar_cr_terms
      accum total (et_sum_amt[1]) @ et_age_amt[1]
      accum total (et_sum_amt[2]) @ et_age_amt[2]
      accum total (et_sum_amt[3]) @ et_age_amt[3]
      accum total (et_sum_amt[4]) @ et_age_amt[4]
      accum total (et_base_amt - et_base_applied) @ ar_amt.
   {&ARCSRP5A-P-TAG58}
   down 1.

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
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         end. /* IF mc-error-number <> 0 */
      end.  /* DO i = 1 to 4 */

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
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
      end. /* IF mc-error-number <> 0 */
   end.  /* IF et_report_curr <> mc-rpt-curr */

   if et_show_diff
      and
      (
      (((accum total (et_sum_amt[1]))
         - (et_org_sum_amt[1]))  <> 0)
      or (((accum total (et_sum_amt[2]))
         - (et_org_sum_amt[2]))  <> 0)
      or (((accum total (et_sum_amt[3]))
         - (et_org_sum_amt[3]))  <> 0)
      or (((accum total (et_sum_amt[4]))
         - (et_org_sum_amt[4]))  <> 0)
      or (((accum total (et_base_amt - et_base_applied))
         - (et_org_amt))         <> 0)
      )
   then
      /* DISPLAY DIFFRENCCES */
      put et_diff_txt
         format "x(40)" to 44 ":" to 45
         ((accum total et_sum_amt[1]) - et_org_sum_amt[1])
         to 65
         ((accum total et_sum_amt[2]) - et_org_sum_amt[2])
         to 81
         ((accum total et_sum_amt[3]) - et_org_sum_amt[3])
         to 97
         ((accum total et_sum_amt[4]) - et_org_sum_amt[4])
         to 113
         ((accum total (et_base_amt -  et_base_applied)) -
         et_org_amt)
         to 130.
      down 1.
   */
   /* SS - 20070301.1 - E */
end.  /* SCOPE OF FRAME C */

/* SS - 20070301.1 - B */
/*
/* DISPLAY SUMMARY TOTAL INFORMATION */
if page-size - line-counter < 9
then
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

if et_report_curr <> mc-rpt-curr
then do:
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_inv_tot,
        input true,  /* ROUND */
        output et_org_inv_tot,
        output mc-error-number)"}
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   end. /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_memo_tot,
        input true,  /* ROUND */
        output et_org_memo_tot,
        output mc-error-number)"}
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   end. /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_fc_tot,
        input true,  /* ROUND */
        output et_org_fc_tot,
        output mc-error-number)"}
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   end. /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_paid_tot,
        input true,  /* ROUND */
        output et_org_paid_tot,
        output mc-error-number)"}
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   end. /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_drft_tot,
        input true,  /* ROUND */
        output et_org_drft_tot,
        output mc-error-number)"}
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   end. /* IF mc-error-number <> 0 */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input mc-rpt-curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input et_org_curr_amt,
        input true,  /* ROUND */
        output et_org_curr_amt,
        output mc-error-number)"}
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   end. /* IF mc-error-number <> 0 */

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
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
   end. /* IF mc-error-number <> 0 */
end.  /* IF et_report_curr <> mc-rpt-curr */

et_diff_exist = false.

if et_show_diff
   and ((((accum total et_inv_tot) - et_org_inv_tot)                 <> 0)
   or  (((accum total et_memo_tot) - et_org_memo_tot)                <> 0)
   or  (((accum total et_fc_tot)   - et_org_fc_tot)                  <> 0)
   or  (((accum total et_paid_tot) - et_org_paid_tot)                <> 0)
   or  (((accum total et_drft_tot) - et_org_drft_tot)                <> 0)
   or  (((accum total (et_base_amt - et_base_applied)) - et_org_amt) <> 0)
   or  (((accum total et_curr_amt) - et_org_curr_amt)                <> 0)
   or  (((( accum total (et_curr_amt))
            - (accum total (et_base_amt - et_base_applied)))
            - (et_org_curr_amt - et_org_amt))                        <> 0))
   then
      et_diff_exist = true.

{&ARCSRP5A-P-TAG13}
{&ARCSRP5A-P-TAG59}
display
   et_diff_txt                        format "x(40)" to 95
      when (et_diff_exist)
   getTermLabelRtColon("INVOICES",33) format "x(33)" to 34
   accum total (et_inv_tot)                          at 35
      format "->>>,>>>,>>>,>>9.99"
   ((accum total et_inv_tot) - et_org_inv_tot)
      when (et_diff_exist)                           to 95
      format "->>>,>>>,>>>,>>9.99"
   getTermLabelRtColon("DR/CR_MEMOS",33) format "x(33)" to 34
   accum total (et_memo_tot)                         at 35
      format "->>>,>>>,>>>,>>9.99"
   ((accum total et_memo_tot) - et_org_memo_tot)
      when (et_diff_exist)                           to 95
      format "->>>,>>>,>>>,>>9.99"
   getTermLabelRtColon("FINANCE_CHARGES",33) format "x(33)" to 34
   accum total (et_fc_tot)                           at 35
      format "->>>,>>>,>>>,>>9.99"
   ((accum total et_fc_tot) - et_org_fc_tot)
      when (et_diff_exist)                           to 95
      format "->>>,>>>,>>>,>>9.99"
   getTermLabelRtColon("UNAPPLIED_PAYMENTS",33) format "x(33)" to 34
   accum total (et_paid_tot)                         at 35
      format "->>>,>>>,>>>,>>9.99"
   ((accum total et_paid_tot) - et_org_paid_tot)
      when (et_diff_exist)                           to 95
      format "->>>,>>>,>>>,>>9.99"
   getTermLabelRtColon("DRAFTS",33) format "x(33)"   to 34
   accum total (et_drft_tot)                         at 35
      format "->>>,>>>,>>>,>>9.99"
   ((accum total et_drft_tot) - et_org_drft_tot)
      when (et_diff_exist)                           to 95
      format "->>>,>>>,>>>,>>9.99"
   getTermLabelRt("TOTAL",10) + " " + et_report_curr  + " " +
   getTermLabelRtColon("AGING",6)
      format "x(21)" to 34
   accum total (et_base_amt - et_base_applied)       at 35
      format "->>>,>>>,>>>,>>9.99"
   ((accum total (et_base_amt - et_base_applied)) - et_org_amt)
      when (et_diff_exist)                           to 95
      format "->>>,>>>,>>>,>>9.99"
with frame d width 132 no-labels.

if base_rpt = ""
then
   display
      getTermLabel("AGING_AT",8) + " " +
      string(effdate1)           + " " +
      getTermLabelRtColon("EXCHANGE_RATE",14)
         format "x(32)"                             to 34
      accum total (et_curr_amt)                     at 35
         format "->>>,>>>,>>>,>>9.99"
      ((accum total et_curr_amt) - et_org_curr_amt)
         when (et_diff_exist)                       to 95
         format "->>>,>>>,>>>,>>9.99"
      getTermLabel("VARIANCE_OF",11) + " " +
      string(effdate1)               + " " +
      getTermLabelRtColon("TO_BASE",8)
         format "x(29)"                             to 34
      (accum total (et_curr_amt)) -
      (accum total (et_base_amt - et_base_applied)) at 35
         format "->>>,>>>,>>>,>>9.99"
      ((( accum total (et_curr_amt))
      -  (accum total (et_base_amt - et_base_applied)))
      - (et_org_curr_amt - et_org_amt)
      ) when (et_diff_exist)                        to 95
         format "->>>,>>>,>>>,>>9.99"
   with frame d width 132 no-labels.
{&ARCSRP5A-P-TAG60}
hide frame phead1.

{&ARCSRP5A-P-TAG14}
*/
/* SS - 20070301.1 - E */
