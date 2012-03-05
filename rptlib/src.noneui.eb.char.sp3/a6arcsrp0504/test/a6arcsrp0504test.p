/* arcsrp05.p - AR AGING REPORT FROM AR EFF DATE                             */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*K0Q0*/
/*V8:ConvertMode=Report                                                      */
/*L02Q*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION: 4.0      LAST MODIFIED: 08/26/88   BY: pml                      */
/* REVISION: 6.0      LAST MODIFIED: 09/07/90   BY: afs *D059*               */
/* REVISION: 6.0      LAST MODIFIED: 09/07/90   BY: afs *D066*               */
/* REVISION: 6.0      LAST MODIFIED: 10/16/90   BY: afs *D101*               */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: afs *D283*   (rev only)  */
/* REVISION: 6.0      LAST MODIFIED: 06/24/91   BY: afs *D723*               */
/* REVISION: 7.0      LAST MODIFIED: 11/26/91   BY: afs *F041*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   BY: jjs *F237*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: tjs *F337*               */
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: MLV *F446*               */
/*                                   05/12/92   by: jms *F481*   (rev only)  */
/*                                   06/18/92   by: jjs *F670*               */
/*                                   07/29/92   by: jms *F829*   (rev only)  */
/* REVISION: 7.3      LAST MODIFIED: 03/10/93   by: jms *G795*   (rev only)  */
/*                                   03/18/93   by: jjs *G843*   (rev only)  */
/*                                   04/12/93   by: jjs *G944*   (rev only)  */
/*                                   04/08/94   by: wep *FN23*               */
/*                                   08/23/94   by: rxm *GL40*               */
/*                                   09/10/94   by: rxm *FQ94*               */
/*                                   04/10/96   by: jzw *G1P6*               */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   by: bvm *K0Q0*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *L00S* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L02Q* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 04/14/00   BY: *N08H* Rajesh Thomas     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 10/05/00   BY: *N0SG* Katie Hilbert     */
/* REVISION: 9.1      LAST MODIFIED: 08/04/00   BY: *N0VQ* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 04/12/01   BY: *M14T* Vihang Talwalkar  */
/* REVISION: 9.1      LAST MODIFIED: 29 JUN 2001 BY: *N0ZX* Ed van de Gevel  */
/* REVISION: 9.1      LAST MODIFIED: 8 FEB 2007 BY: *SS - 20070208.1* Bill Jiang  */
/*****************************************************************************/

/* SS - 20070208.1 - B */
{a6arcsrp0504.i "new"}
/* SS - 20070208.1 - E */

/*L0BZ*/ /* Changed ConvertMode from FullGUIReport to Report                 */

/*L00S*  {mfdtitle.i "b+ "} */
/*L00S*/ {mfdtitle.i "b+ "}
/*N0VQ*/ {cxcustom.i "ARCSRP05.P"}

         /* ********** Begin Translatable Strings Definitions ********* */

/*N08H** BEGIN DELETE
 *       &SCOPED-DEFINE arcsrp05_p_1 "Must be DUE, EFF, or INV, Please re-enter. * "
 *       /* MaxLen: Comment: */
 *N08H** END DELETE */
/*N0VQ*/ {&ARCSRP05-P-TAG1}

         &SCOPED-DEFINE arcsrp05_p_2 "Column Days"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_3 "Age by Date (DUE,EFF,INV)"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_4 "Customer Type"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_5 "Show Customer PO"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_6 "Show Master Comments"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_7 "Show Payment Detail"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_8 "Show Invoice Comments"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_9 "Summary/Detail"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

/*L02Q*/  /* THESE ARE NEEDED FOR FULL GUI REPORTS */
/*L02Q*/  {gprunpdf.i "mcpl" "p"}
/*L02Q*/  {gprunpdf.i "mcui" "p"}

          define new shared variable cust like ar_bill.
          define new shared variable cust1 like ar_bill.
          define new shared variable cust_type like cm_type
             label {&arcsrp05_p_4}.
          define new shared variable cust_type1 like cm_type.
          define new shared variable nbr like ar_nbr.
          define new shared variable nbr1 like ar_nbr.
          define new shared variable slspsn like sp_addr.
          define new shared variable slspsn1 like slspsn.
/*N014*   define new shared variable acct_type like ar_acct. */
/*N014*   define new shared variable acct_type1 like ar_acct. */
/*N014*/  define new shared variable acct like ar_acct.
/*N014*/  define new shared variable acct1 like ar_acct.
/*N014*/  define new shared variable sub like ar_sub.
/*N014*/  define new shared variable sub1 like ar_sub.
/*N014*/  define new shared variable cc like ar_cc.
/*N014*/  define new shared variable cc1 like ar_cc.
          define new shared variable effdate1 like ar_effdate initial today.
          define new shared variable summary_only like mfc_logical
             label {&arcsrp05_p_9} format {&arcsrp05_p_9} initial no.
          define new shared variable base_rpt like ar_curr.
          define new shared variable show_po like mfc_logical
             label {&arcsrp05_p_5} initial no.
          define new shared variable show_pay_detail like mfc_logical
             label {&arcsrp05_p_7} initial no.
          define new shared variable show_comments like mfc_logical
             label {&arcsrp05_p_8} initial no.
          define new shared variable show_mstr_comments like mfc_logical
             label {&arcsrp05_p_6} initial no.
          /* SS - 20070208.1 - B */
          /*
          define new shared variable age_days as integer extent 4
             label {&arcsrp05_p_2}.
          */
          define new shared variable age_days as integer extent 9
             label {&arcsrp05_p_2}.
          /* SS - 20070208.1 - E */
          define new shared variable mstr_type like cd_type initial "AR".
          define new shared variable mstr_lang like cd_lang.
          define variable i as integer.
          define new shared variable entity like gl_entity.
          define new shared variable entity1 like gl_entity.
          define new shared variable lstype like ls_type.
          define new shared variable age_by as character format "x(3)" label
             {&arcsrp05_p_3} initial "DUE".

/*L02Q*/  define new shared variable mc-rpt-curr like base_rpt no-undo.
/*L02Q*/  define variable mc-dummy-fixed like so_fix_rate no-undo.
/*M14T*/  define variable l_batchid      like bcd_batch   no-undo.

/*L00S*   * BEGIN ADDED SECTION */
          {etrpvar.i &new = "new"}
          {etvar.i   &new = "new"}
          {eteuro.i}
/*L02Q*   define variable input_curr   like ex_curr. */
/*L02Q*   define new shared variable display_curr like base_rpt. */
/*L00S*   * END ADDED SECTION */

/*N0VQ*/  {&ARCSRP05-P-TAG2}
          form
             cust            colon 15
             cust1           label {t001.i} colon 49 skip
             cust_type       colon 15
             cust_type1      label {t001.i} colon 49 skip
             nbr             colon 15
             nbr1            label {t001.i} colon 49 skip
             slspsn          colon 15
             slspsn1         label {t001.i} colon 49 skip
/*N014*      acct_type       colon 15 */
/*N014*      acct_type1      label {t001.i} colon 49 skip */
/*N014*/     acct            colon 15
/*N014*/     acct1           label {t001.i} colon 49 skip
/*N014*/     sub             colon 15
/*N014*/     sub1            label {t001.i} colon 49 skip
/*N014*/     cc              colon 15
/*N014*/     cc1             label {t001.i} colon 49 skip
             entity          colon 15
             entity1         label {t001.i} colon 49
             lstype          colon 15 /*L00S skip(1)*/
/*L00S*/     skip
             age_by         colon  26
/*N08H**        validate((lookup(age_by,"DUE,EFF,INV") <> 0), */
/*N08H**        {&arcsrp05_p_1}) */
             show_po            colon 60
             effdate1        colon 26  show_pay_detail    colon 60
             summary_only    colon 26  show_comments      colon 60
             base_rpt        colon 26  show_mstr_comments colon 60
/*L02Q*/     et_report_curr  colon 26
/*L02Q* /*L00S*/ et_report_txt   to    26 no-label */
/*L02Q* /*L00S*/ et_report_curr  /*colon 26*/ no-label */
             mstr_type 
             /* SS - 20070208.1 - B */
             /*
             colon 60
             */
             /* SS - 20070208.1 - E */
/*L00S*      mstr_lang */
/*L00S*      skip(1) */
/*L02Q* /*L00S*/ et_rate_txt    to    26 no-label */
/*L02Q* /*L00S*/ et_report_rate /*colon 26*/ no-label */
/*L00S*/     mstr_lang 
             /* SS - 20070208.1 - B */
             /*
             colon 60
             */
             /* SS - 20070208.1 - E */
/*N014*      /*L00S*/ skip(1) */
/*N014*/     skip
             space(1)
             age_days[1]
             age_days[2]    label "[2]"
             age_days[3]    label "[3]"
             /* SS - 20070208.1 - B */
             age_days[4]    label "[4]"
             age_days[5]    label "[5]"
             age_days[6]    label "[6]"
             age_days[7]    label "[7]"
             age_days[8]    label "[8]"
             /* SS - 20070208.1 - E */
/*N014*      skip(1) */
          with frame a side-labels
/*L00S*/  no-attr-space
          width 80.
/*N0VQ*/  {&ARCSRP05-P-TAG3}

          /* SET EXTERNAL LABELS */
          setFrameLabels(frame a:handle).

/*L00S*   form.... */
          form header
/*L02Q* /*L00S*/  et_report_txt to 65 et_disp_curr */
/*L02Q*/     mc-curr-label to 65 et_report_curr skip
/*L02Q*/     mc-exch-label to 65 mc-exch-line1 skip
/*L02Q*/     mc-exch-line2 at 67 skip(1)
          with frame phead2
/*L02Q*   overlay */
          no-labels page-top
/*L02Q*/  width 132.

/*L02Q*   {wbrp01.i} */

          repeat:

             if cust1 = hi_char then cust1 = "".
             if cust_type1 = hi_char then cust_type1 = "".
             if nbr1 = hi_char then nbr1 = "".
             if slspsn1 = hi_char then slspsn1 = "".
/*N014*      if acct_type1 = hi_char then acct_type1 = "". */
/*N014*/     if acct1 = hi_char then acct1 = "".
/*N014*/     if sub1 = hi_char then sub1 = "".
/*N014*/     if cc1 = hi_char then cc1 = "".
             if entity1 = hi_char then entity1 = "".

             /* SS - 20070208.1 - B */
             /*
             do i = 1 to 4:
                */
             do i = 1 to 9:
                /* SS - 20070208.1 - E */
                if age_days[i] = 0 then age_days[i] = (i * 30).
             end.

/*L02Q* /*L00S*/ display et_report_txt */
/*L02Q* /*L00S*/         et_rate_txt with frame a. */

/*L02Q*      if c-application-mode <> 'web':u then */
/*N0VQ*/        {&ARCSRP05-P-TAG4}
                update cust cust1
                       cust_type cust_type1
                       nbr nbr1
                       slspsn slspsn1
/*N014*                acct_type acct_type1 */
/*N014*/               acct acct1
/*N014*/               sub sub1
/*N014*/               cc cc1
                       entity entity1
                       lstype
                       age_by
                       effdate1 summary_only base_rpt
/*L00S*/               et_report_curr
/*L02Q* /*L00S*/       et_report_rate */
                       show_po show_pay_detail show_comments
                       show_mstr_comments mstr_type mstr_lang
   /* SS - 20070208.1 - B */
   /*
                       age_days[1 for 3]
   */
   age_days[1 for 8]
   /* SS - 20070208.1 - E */
                with frame a.
/*N0VQ*/        {&ARCSRP05-P-TAG5}

/*L02Q*      {wbrp06.i &command = update &fields = "  cust cust1 cust_type
 *            cust_type1 nbr nbr1 slspsn slspsn1 acct_type acct_type1
 *            entity entity1  lstype   age_by
 *            effdate1 summary_only base_rpt
 *            show_po show_pay_detail
 *            show_comments
 * /*L00S*/   et_report_curr
 * /*L00S*/   et_report_rate
 *            show_mstr_comments mstr_type mstr_lang age_days [ 1 for 3 ]"
 *            &frm = "a"}
 *L02Q*/

/*L02Q* /*L00S*/ if et_report_curr = "" then assign display_curr = base_rpt. */
/*L02Q* /*L00S*/ else assign display_curr = et_report_curr. */

/*L02Q* /*L00S*/ {etcurval.i &curr   = "et_report_curr" &errlevel = "4" */
/*L02Q* /*L00S*/             &action = "next"           &prompt   = "pause" } */
/*N0VQ*/     {&ARCSRP05-P-TAG6}
/*L00S*/     assign et_eff_date = effdate1.
/*N0VQ*/     {&ARCSRP05-P-TAG7}
/*L02Q* /*L00S*/ if base_rpt = "base" then assign input_curr = "". */
/*L02Q* /*L00S*/ else assign input_curr = base_rpt. */
/*L02Q* /*L00S*/ {gprun.i ""etrate.p"" "(input input_curr)"} */

/*L02Q*      if (c-application-mode <> 'web':u) or */
/*L02Q*      (c-application-mode = 'web':u and */
/*L02Q*      (c-web-request begins 'data':u)) then do: */

/*L08W*     Code below to be wrapped in a 'do' code block for correct GUI conversion  */
/*L08W*/    do:
                bcdparm = "".
                {mfquoter.i cust        }
                {mfquoter.i cust1       }
                {mfquoter.i cust_type   }
                {mfquoter.i cust_type1  }
                {mfquoter.i nbr         }
                {mfquoter.i nbr1        }
                {mfquoter.i slspsn      }
                {mfquoter.i slspsn1     }
/*N014*         {mfquoter.i acct_type   } */
/*N014*         {mfquoter.i acct_type1  } */
/*N014*/        {mfquoter.i acct        }
/*N014*/        {mfquoter.i acct1       }
/*N014*/        {mfquoter.i sub         }
/*N014*/        {mfquoter.i sub1        }
/*N014*/        {mfquoter.i cc          }
/*N014*/        {mfquoter.i cc1         }
                {mfquoter.i entity      }
                {mfquoter.i entity1     }
                {mfquoter.i lstype      }
/*N0VQ*/        {&ARCSRP05-P-TAG8}
                {mfquoter.i age_by     }
/*N0VQ*/        {&ARCSRP05-P-TAG9}
                {mfquoter.i effdate1    }
                {mfquoter.i summary_only}
                {mfquoter.i base_rpt    }
/*L00S*/        {mfquoter.i et_report_curr }
/*L02Q* /*L00S*/{mfquoter.i et_report_rate } */
                {mfquoter.i show_po     }
                {mfquoter.i show_pay_detail}
                {mfquoter.i show_comments}
                {mfquoter.i show_mstr_comments}
                {mfquoter.i mstr_type   }
                {mfquoter.i mstr_lang   }
                {mfquoter.i age_days[1] }
                {mfquoter.i age_days[2] }
                {mfquoter.i age_days[3] }
                /* SS - 20070208.1 - B */
                {mfquoter.i age_days[4] }
                {mfquoter.i age_days[5] }
                {mfquoter.i age_days[6] }
                {mfquoter.i age_days[7] }
                {mfquoter.i age_days[8] }
                /* SS - 20070208.1 - E */

                if cust1 = "" then cust1 = hi_char.
                if cust_type1 = "" then cust_type1 = hi_char.
                if nbr1 = "" then nbr1 = hi_char.
                if slspsn1 = "" then slspsn1 = hi_char.
/*N014*         if acct_type1 = "" then acct_type1 = hi_char. */
/*N014*/        if acct1 = "" then acct1 = hi_char.
/*N014*/        if sub1 = "" then sub1 = hi_char.
/*N014*/        if cc1 = "" then cc1 = hi_char.
                if entity1 = "" then entity1 = hi_char.
/*N0VQ*/        {&ARCSRP05-P-TAG10}

/*N08H*/    /* BEGIN ADD SECTION */

            /* VALIDATE AGE_BY   */
/*N0SG*            if (lookup(age_by,"DUE, EFF, INV") = 0)  */
/*N0SG*/    if (lookup(age_by,"DUE,EFF,INV") = 0)
            then do:
               /* MUST BE DUE, EFF or INV */
               {mfmsg.i 3551 3}
               next-prompt age_by with frame a.
               undo,retry.
            end.
/*N0ZX*/    {&ARCSRP05-P-TAG11}

/*N08H*/    /* END ADD SECTION */

/*L0BZ*/        /* Validate currency */
/*L0BZ*/        run ip-chk-valid-curr
/*L0BZ*/           (input  base_rpt,
/*L0BZ*/            output mc-error-number).

/*L0BZ*/        if mc-error-number <> 0 then do:
/*L0BZ*/           next-prompt base_rpt with frame a.
/*L0BZ*/           undo, retry.
/*L0BZ*/        end.

/*L0BZ*/        /* Validate reporting currency */
/*L0BZ*/        run ip-chk-valid-curr
/*L0BZ*/           (input  et_report_curr,
/*L0BZ*/            output mc-error-number).

/*L0BZ*/        if mc-error-number = 0 then do:

/*L0BZ*/           /* Default currencies if blank */
/*L0BZ*/           mc-rpt-curr = if base_rpt = "" then base_curr else base_rpt.
/*L0BZ*/           if et_report_curr = "" then et_report_curr = mc-rpt-curr.

/*L0BZ*/           /* Prompt for exchange rate and format for output */
/*L0BZ*/           run ip-ex-rate-setup
/*L0BZ*/              (input  et_report_curr,
/*L0BZ*/               input  mc-rpt-curr,
/*L0BZ*/               input  " ",
/*L0BZ*/               input  et_eff_date,
/*L0BZ*/               output et_rate2,
/*L0BZ*/               output et_rate1,
/*L0BZ*/               output mc-exch-line1,
/*L0BZ*/               output mc-exch-line2,
/*L0BZ*/               output mc-error-number).

/*L0BZ*/        end.  /* if mc-error-number = 0 */

/*L0BZ*/        if mc-error-number <> 0 then do:
/*L0BZ*/           next-prompt et_report_curr with frame a.
/*L0BZ*/           undo, retry.
/*L0BZ*/        end.

/*L0BZ* /*L02Q*/ if base_rpt <> "" then
 *L0BZ* /*L02Q*/    mc-rpt-curr = base_rpt.
 *L0BZ* /*L02Q*/ else mc-rpt-curr = base_curr.
 *L0BZ* /*L02Q*/ if et_report_curr <> "" then do:
 *L0BZ* /*L02Q*/    {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
 *L0BZ*               "(input et_report_curr,
 *L0BZ*                 output mc-error-number)"}
 *L0BZ* /*L02Q*/    if mc-error-number = 0
 *L0BZ* /*L02Q*/    and et_report_curr <> mc-rpt-curr then do:
 *L0BZ* /*L08W*        CURRENCIES AND RATES REVERSED BELOW...             */
 *L0BZ* /*L02Q*/       {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
 *L0BZ*                  "(input et_report_curr,
 *L0BZ*                    input mc-rpt-curr,
 *L0BZ*                    input "" "",
 *L0BZ*                    input et_eff_date,
 *L0BZ*                    output et_rate2,
 *L0BZ*                    output et_rate1,
 *L0BZ*                    output mc-seq,
 *L0BZ*                    output mc-error-number)"}
 *L0BZ* /*L02Q*/    end.  /* if mc-error-number = 0 */
 *L0BZ* /*L02Q*/    if mc-error-number <> 0 then do:
 *L0BZ* /*L02Q*/       {mfmsg.i mc-error-number 3}
 *L0BZ* /*L02Q*/       next-prompt et_report_curr with frame a.
 *L0BZ* /*L02Q*/       undo, retry.
 *L0BZ* /*L02Q*/    end.  /* if mc-error-number <> 0 */
 *L0BZ* /*L02Q*/    else if et_report_curr <> mc-rpt-curr then do:
 *L0BZ* /*L08W*        CURRENCIES AND RATES REVERSED BELOW...             */
 *L0BZ* /*L02Q*/       {gprunp.i "mcui" "p" "mc-ex-rate-input"
 *L0BZ*                  "(input et_report_curr,
 *L0BZ*                    input mc-rpt-curr,
 *L0BZ*                    input et_eff_date,
 *L0BZ*                    input mc-seq,
 *L0BZ*                    input false,
 *L0BZ*                    input 5,
 *L0BZ*                    input-output et_rate2,
 *L0BZ*                    input-output et_rate1,
 *L0BZ*                    input-output mc-dummy-fixed)"}
 *L0BZ* /*L08W*        CURRENCIES AND RATES REVERSED BELOW...             */
 *L0BZ* /*L02Q*/       {gprunp.i "mcui" "p" "mc-ex-rate-output"
 *L0BZ*                  "(input et_report_curr,
 *L0BZ*                    input mc-rpt-curr,
 *L0BZ*                    input et_rate2,
 *L0BZ*                    input et_rate1,
 *L0BZ*                    input mc-seq,
 *L0BZ*                    output mc-exch-line1,
 *L0BZ*                    output mc-exch-line2)"}
 *L0BZ* /*L02Q*/       {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
 *L0BZ*                  "(input mc-seq)"}
 *L0BZ* /*L02Q*/    end.  /* else do */
 *L0BZ* /*L02Q*/ end.  /* if et_report_curr <> "" */
 *L0BZ* /*L02Q*/ if et_report_curr = "" or et_report_curr = mc-rpt-curr then
 *L0BZ* /*L02Q*/    assign
 *L0BZ* /*L02Q*/       mc-exch-line1 = ""
 *L0BZ* /*L02Q*/       mc-exch-line2 = ""
 *L0BZ* /*L02Q*/       et_report_curr = mc-rpt-curr.
 *L0BZ*/

/*L02Q*      end.  /* if (c-application-mode <> 'web':u) ... */ */
/*L08W*/     end.

             /* SELECT PRINTER */

/*M14T*/    on go anywhere
/*M14T*/    do:
/*M14T*/       if frame-field = "batch_id":U
/*M14T*/       then
/*M14T*/          l_batchid = frame-value.

/*M14T*/       /* TO CHECK NON-BLANK VALUE OF BATCH ID WHEN CURSOR IS */
/*M14T*/       /* IN BATCH ID OR OUTPUT FIELD                         */
/*M14T*/       if ((frame-field       =  "batch_id":U
/*M14T*/            and frame-value   <> "")
/*M14T*/            or (frame-field   =  "dev":U
/*M14T*/                and l_batchid <> ""))
/*M14T*/            and (mc-rpt-curr  <> et_report_curr)
/*M14T*/       then do:
/*M14T*/          /* USER-INPUT EXCHANGE RATE WILL BE IGNORED IN BATCH MODE */
/*M14T*/          {mfmsg.i 4629 2}
/*M14T*/          pause.
/*M14T*/       end. /* IF FRAME-FIELD = "batch_id" AND ... */
/*M14T*/    end. /* ON GO ANYWHERE */

             {mfselbpr.i "printer" 132}
             /* SS - 20070208.1 - B */
             /*
             {mfphead.i}

/*L00S*/     view frame phead2.

             {gprun.i ""arcsrp5a.p""}

/*L00S*/     hide frame phead2.

             /* REPORT TRAILER */
             {mfrtrail.i}
             */
             PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

             FOR EACH tta6arcsrp0504:
                 DELETE tta6arcsrp0504.
             END.
             {gprun.i ""a6arcsrp0504.p"" "(
                INPUT cust,
                INPUT cust1,
                INPUT cust_type,
                INPUT cust_type1,
                INPUT nbr,
                INPUT nbr1,
                INPUT slspsn,
                INPUT slspsn1,
                INPUT acct,
                INPUT acct1,
                INPUT sub,
                INPUT sub1,
                INPUT cc,
                INPUT cc1,
                INPUT entity,
                INPUT entity1,
                INPUT lstype,
                INPUT age_by,
                INPUT effdate1,
                INPUT base_rpt,
                INPUT et_report_curr,
                INPUT age_days[1],
                INPUT age_days[2],
                INPUT age_days[3],
                INPUT age_days[4],
                INPUT age_days[5],
                INPUT age_days[6],
                INPUT age_days[7],
                INPUT age_days[8],
                INPUT age_days[9]
                 )"}
             EXPORT DELIMITER ";" "bill" "acct" "sub" "cc" "nbr" "type" "ar_nbr" "ar_type" "effdate" "due_date" "date" "et_age_amt[1]" "et_age_amt[2]" "et_age_amt[3]" "et_age_amt[4]" "et_age_amt[5]" "et_age_amt[6]" 
                "et_age_amt[7]" "et_age_amt[8]" "et_age_amt[9]" 
                "amt" "ar_curr".
             FOR EACH tta6arcsrp0504:
                 EXPORT DELIMITER ";" tta6arcsrp0504.
             END.

             PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

             {a6mfrtrail.i}
             /* SS - 20070208.1 - E */

          end.  /* repeat */

/*L02Q*   {wbrp04.i &frame-spec = a} */


/*L0BZ*/ procedure ip-chk-valid-curr:


            define input  parameter i_curr  as character no-undo.
            define output parameter o_error as integer   no-undo initial 0.


            if i_curr <> "" then do:

               {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                  "(input  i_curr,
                    output o_error)" }

               if o_error <> 0 then do:
                  {mfmsg.i o_error 3}
               end.

            end.  /* if i_curr */


         end procedure.  /* ip-chk-valid-curr */


/*L0BZ*/ procedure ip-ex-rate-setup:

            define input  parameter i_curr1      as character no-undo.
            define input  parameter i_curr2      as character no-undo.
            define input  parameter i_type       as character no-undo.
            define input  parameter i_date       as date      no-undo.

            define output parameter o_rate       as decimal   no-undo initial 1.
            define output parameter o_rate2      as decimal   no-undo initial 1.
            define output parameter o_disp_line1 as character no-undo
                                                              initial "".
            define output parameter o_disp_line2 as character no-undo
                                                              initial "".
            define output parameter o_error      as integer   no-undo initial 0.

            define variable v_seq                as integer   no-undo.
            define variable v_fix_rate           as logical no-undo.


            do transaction:

               /* Get exchange rate and create usage records */
               {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                  "(input  i_curr1,
                    input  i_curr2,
                    input  i_type,
                    input  i_date,
                    output o_rate,
                    output o_rate2,
                    output v_seq,
                    output o_error)" }

               if o_error = 0 then do:

               /* Prompt user to edit exchange rate */
/*M14T*/       if not batchrun
/*M14T*/       then do:
                  {gprunp.i "mcui" "p" "mc-ex-rate-input"
                     "(input        i_curr1,
                       input        i_curr2,
                       input        i_date,
                       input        v_seq,
                       input        false,
                       input        5,
                       input-output o_rate,
                       input-output o_rate2,
                       input-output v_fix_rate)" }
/*M14T*/       end. /* IF NOT BATCHRUN */

                  /* Format exchange rate for output */
                  {gprunp.i "mcui" "p" "mc-ex-rate-output"
                     "(input  i_curr1,
                       input  i_curr2,
                       input  o_rate,
                       input  o_rate2,
                       input  v_seq,
                       output o_disp_line1,
                       output o_disp_line2)" }

                  /* Delete usage records */
                  {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                     "(input v_seq)" }

               end.  /* if o_error */

               else do:
                  {mfmsg.i o_error 3}
               end.

            end.  /* do transaction */


         end procedure.  /* ip-ex-rate-setup */
