/* glcctrra.p - GENERAL LEDGER COMPARATIVE COST CENTER REPORT (Part II)    */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.14 $                                                         */
/*K0TW*                                                                    */
/*V8:ConvertMode=Report                                                    */
/* REVISION: 7.0      LAST MODIFIED: 12/03/91   by: jms *F058*             */
/*                                   06/19/92   BY: JJS *F661*             */
/* REVISION: 7.3      LAST MODIFIED: 10/19/92   BY: MPP *G206*             */
/*                                   04/26/94   BY: srk *FN63*             */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ays *K0TW*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J241* Jagdish Suvarna */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L030* Edwin Janse     */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L01W* Brenda Milton   */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *N0G5* Rajinder Kamra  */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TH* Jyoti Thatte    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.14 $    BY: Kedar Deherkar        DATE: 05/27/03  ECO: *N2G0*  */
/* $Revision: 1.14 $    BY: Bill Jiang        DATE: 09/19/05  ECO: *SS - 20050919*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*J241* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
WHEREVER MISSING for performance and SMALLER R-CODE */

/* SS - 20050919 - B */
{a6glcctrrp.i}
/* SS - 20050919 - E */

      {mfdeclre.i}
      {gplabel.i}

      /* ********** Begin Translatable Strings Definitions ********* */

      &SCOPED-DEFINE glcctrra_p_2 "Round to Nearest Whole Unit"
      /* MaxLen: Comment: */

      &SCOPED-DEFINE glcctrra_p_3 "Suppress Zero Accounts"
      /* MaxLen: Comment: */

      /* ********** End Translatable Strings Definitions ********* */

      {wbrp02.i}
      define shared variable glname like en_name no-undo.
   define shared variable begdt as date extent 2 no-undo.
   define shared variable enddt as date extent 2 no-undo.
   define shared variable acc like ac_code no-undo.
   define shared variable acc1 like ac_code no-undo.
   define shared variable sub like sb_sub no-undo.
   define shared variable sub1 like sb_sub no-undo.
   define shared variable ctr like cc_ctr no-undo.
   define shared variable ctr1 like cc_ctr no-undo.
   define shared variable yr_beg as date no-undo.
   define shared variable yr as integer no-undo.
   define shared variable budget like mfc_logical extent 2 no-undo.
   define shared variable peryr as character format "x(8)" no-undo.
   define shared variable fiscal_yr as integer extent 2 no-undo.
   define shared variable fiscal_yr1 as integer extent 2 no-undo.
   define shared variable per_end like glc_per extent 2 no-undo.
   define shared variable per_beg like glc_per extent 2 no-undo.
   define shared variable entity like en_entity no-undo.
   define shared variable entity1 like en_entity no-undo.
   define shared variable cname like glname no-undo.
   define shared variable hdrstring as character format "x(8)" no-undo.
   define shared variable hdrstring1 like hdrstring no-undo.
   define shared variable yr_end as date extent 2 no-undo.
   define shared variable ret like ac_code no-undo.
   define shared variable proj like gltr_project no-undo.
   define shared variable proj1 like gltr_project no-undo.
   define shared variable budgetcode like bg_code extent 2 no-undo.
   define shared variable rpt_curr like ac_curr no-undo.
   define shared variable prtcents like mfc_logical
      label {&glcctrra_p_2} no-undo.
   define shared variable prtfmt as character format "x(30)" no-undo.
   define shared variable prtfmt1 as character format "x(30)" no-undo.
   define shared variable zeroflag like mfc_logical
      label {&glcctrra_p_3} no-undo.

   define variable acc_tot as decimal extent 2 no-undo.
   define variable ctr_tot as decimal extent 2 no-undo.
   define variable grand_tot as decimal extent 2 no-undo.
   define variable variance as decimal no-undo.
   define variable percent as decimal format "->>>9.9%" no-undo.
   define variable per_char as character format "x(8)" no-undo.
   define variable knt as integer no-undo.
   define variable i as integer no-undo.
   define variable dt as date no-undo.
   define variable dt1 as date no-undo.

   define variable account as character format "x(17)" no-undo.

   /* DEFINE EURO VARIABLES */
   {etrpvar.i }
   {etvar.i   }
   /* GET EURO INFORMATION  */
   {eteuro.i}

   define variable et_acc_tot        as decimal extent 2 no-undo.
   define variable et_ctr_tot        as decimal extent 2 no-undo.
   define variable et_grand_tot      as decimal extent 2 no-undo.
   define variable et_conv_tot       as decimal extent 2 no-undo.
   define variable et_variance       as decimal          no-undo.

   /* ***** GET EXCHANGE RATE ***** */
   assign et_eff_date    = today.

   /* ***** DEFINE FIXED EXCHANGE RATE ***** */

   /* CYCLE THROUGH ACCOUNT FILE */
   assign grand_tot = 0
      et_grand_tot = 0
      et_conv_tot = 0.

   for each cc_mstr
         fields (cc_ctr cc_desc)
         where cc_ctr >= ctr and cc_ctr <= ctr1 no-lock:
      assign knt = 0.
      /* SS - 20050919 - B */
      /*
      if page-size - line-counter < 2 then page.
      put cc_ctr at 1 cc_desc at 8 skip.
      assign ctr_tot = 0
         et_ctr_tot = 0.
      */
      /* SS - 20050919 - E */

      for each asc_mstr
            fields (asc_acc asc_sub asc_cc)
            where asc_cc = cc_ctr and
            asc_acc >= acc and asc_acc <= acc1 and
            asc_sub >= sub and asc_sub <= sub1
         no-lock use-index asc_cc:

         for first ac_mstr fields (ac_type ac_curr ac_desc ac_code)
            where ac_code = asc_acc no-lock:
         end.
         if ac_type = "M" or ac_type = "S" then next.

         /* CALCULATE ACCOUNT AMOUNTS */
         assign et_acc_tot = 0.
         do i = 1 to 2:
            if budget[i] then do:
               {glacbg2.i &acc=asc_acc &sub=asc_sub &cc=cc_ctr
                  &yr=fiscal_yr[i] &per=per_beg[i]
                  &yr1=fiscal_yr1[i] &per1=per_end[i]
                  &budget=acc_tot[i] &bcode=budgetcode[i]}
            end.
            else do:
               {glacbal1.i &acc=asc_acc &sub=asc_sub &cc=cc_ctr
                  &begdt=begdt[i] &enddt=enddt[i] &balance=acc_tot[i]
                  &yrend=yr_end[i] &rptcurr=rpt_curr &accurr=ac_curr}
            end.

            if et_report_curr <> rpt_curr then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input rpt_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input acc_tot[i],
                    input true,  /* ROUND */
                    output et_acc_tot[i],
                    output mc-error-number)"}
            end.  /* IF et_report_curr <> rpt_curr */
            else et_acc_tot[i] = acc_tot[i].

            if prtcents then
         do:
               assign

                  et_acc_tot[i] = round(et_acc_tot[i], 0).
            end.
            /* SS - 20050919 - B */
            /*
            assign
               ctr_tot[i] = ctr_tot[i] + acc_tot[i]
               et_ctr_tot[i] = et_ctr_tot[i] + et_acc_tot[i]
               grand_tot[i] = grand_tot[i] + acc_tot[i]
               et_grand_tot[i] = et_grand_tot[i] + et_acc_tot[i].
            */
            /* SS - 20050919 - E */
         end.  /* DO i = 1 TO 2 */
         /* SS - 20050919 - B */
         /*
         assign variance = 0
            et_variance = 0.
         if acc_tot[1] <> 0 or acc_tot[2] <> 0 then do:
            assign variance = acc_tot[2] - acc_tot[1]
               et_variance = et_acc_tot[2] - et_acc_tot[1].
            if ac_type = "I" or ac_type = "L" then
            assign variance = - variance
               et_variance = - et_variance.
            assign percent = 0.
            if acc_tot[2] <> 0 then do:

               assign percent = (et_variance / et_acc_tot[2]) * 100
                  per_char = string(percent, "->>>9.9%").
            end.
            else assign per_char = "   **".
         end.
         else assign per_char = "   **".
         */
         /* SS - 20050919 - E */

         if not zeroflag or acc_tot[1] <> 0 or acc_tot[2] <> 0
         then do:
             /* SS - 20050919 - B */
             /*
            if page-size - line-counter = 0 then do:
               page.
               put cc_ctr at 1 substring(cc_desc, 1, 16) at 8

                  " ("  {gplblfmt.i
                  &FUNC=getTermLabel(""CONTINUE"",4)
                  &CONCAT="'.)'"
                  } skip.
            end.

            assign knt = knt + 1.

            {glacct.i
               &acc  = asc_acc
               &sub  = asc_sub
               &cc   = """"
               &acct = account}
            put account at 12

               ac_desc at 30

               string(et_acc_tot[1], prtfmt) format "x(20)" to 80
               string(et_acc_tot[2], prtfmt) format "x(20)" to 101
               string(et_variance, prtfmt)   format "x(20)" to 122

               per_char to 131 skip.
            */
             CREATE tta6glcctrrp.
             ASSIGN
                 tta6glcctrrp_acc = ASC_acc
                 tta6glcctrrp_sub = ASC_sub
                 tta6glcctrrp_ctr = cc_ctr
                 tta6glcctrrp_et_tot01 = et_acc_tot[1]
                 tta6glcctrrp_et_tot02 = et_acc_tot[2]
                 .
            /* SS - 20050919 - E */
         end.
      end.

      /* PRINT COST CENTER TOTALS */
      /* SS - 20050919 - B */
      /*
      assign et_variance = et_ctr_tot[2] - et_ctr_tot[1]
         percent = 0.
      if ctr_tot[2] <> 0 then do:

         assign percent = (et_variance / et_ctr_tot[2]) * 100
            per_char = string(percent, "->>>9.9%").
      end.
      else assign per_char = "   **".
      if page-size - line-counter < 2 then page.
      if knt <> 0 then
      put "--------------------" to 80
         "--------------------" to 101
         "--------------------" to 122
         "--------" to 131 skip.
      put

         string(et_ctr_tot[1], prtfmt) format "x(20)" to 80
         string(et_ctr_tot[2], prtfmt) format "x(20)" to 101
         string(et_variance, prtfmt1)  format "x(20)" to 122

         per_char to 131 skip(1).
      */
      /* SS - 20050919 - E */

      {mfrpchk.i}
   end.

   /* PRINT TOTALS */
      /* SS - 20050919 - B */
      /*
   if page-size - line-counter < 3 then page.
   put "--------------------" to 80
      "--------------------" to 101

      string(et_grand_tot[1], prtfmt)   format "x(20)" to 80
      string(et_grand_tot[2], prtfmt)   format "x(20)" to 101 skip.

   DIFFBLOCK:
   do:
      if et_show_diff
         and not prtcents
      then do:

         if et_report_curr <> rpt_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input rpt_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input grand_tot[1],
                 input true,  /* ROUND */
                 output et_conv_tot[1],
                 output mc-error-number)"}
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input rpt_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input grand_tot[2],
                 input true,  /* ROUND */
                 output et_conv_tot[2],
                 output mc-error-number)"}
         end.  /* if et_report_curr <> rpt_curr */
         else
         assign
            et_conv_tot[1] = grand_tot[1]
            et_conv_tot[2] = grand_tot[2].

         if prtcents
            then
         assign grand_tot[1] = round(grand_tot[1],0)
            grand_tot[2] = round(grand_tot[2],0).
         if (et_grand_tot[1] - et_conv_tot[1]) <> 0 or
            (et_grand_tot[2] - et_conv_tot[2]) <> 0
         then do:
            if prtcents and
               round((et_grand_tot[1] - et_conv_tot[1]),0) = 0 and
               round((et_grand_tot[2] - et_conv_tot[2]),0) = 0
               then leave DIFFBLOCK.
            put
               et_diff_txt format "x(30)" to  60
               string((et_grand_tot[1] - et_conv_tot[1]), prtfmt)
               format "x(20)" to 80
               string((et_grand_tot[2] - et_conv_tot[2]),prtfmt)
               format "x(20)" to 101 skip.
         end. /* IF THERE IS A CONVERSION DIFF.*/
      end.    /* SHOW DIFF = YES */
   end.

   put
      "====================" to 80
      "====================" to 101 skip.
   */
   /* SS - 20050919 - E */
   {wbrp04.i}
