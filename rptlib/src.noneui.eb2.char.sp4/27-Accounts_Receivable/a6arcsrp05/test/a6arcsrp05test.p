/* arcsrp05.p - AR AGING REPORT FROM AR EFF DATE                             */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.13.1.12.1.1 $                                                          */
/*V8:ConvertMode=Report                                                      */
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
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 9.1      LAST MODIFIED: 29 JUN 2001 BY: *N0ZX* Ed van de Gevel  */
/* Revision: 1.13.1.11  BY: Vihang Talwalkar      DATE: 04/12/01 ECO: *M14T* */
/* Revision: 1.13.1.12  BY: Orawan S.             DATE: 05/12/03 ECO: *P0RW* */
/* $Revision: 1.13.1.12.1.1 $   BY: Dorota Hohol      DATE: 08/27/03 ECO: *P116* */
/* $Revision: 1.13.1.12.1.1 $   BY: Bill Jiang      DATE: 10/04/05 ECO: *SS - 20051004* */
/*****************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* Changed ConvertMode from FullGUIReport to Report                          */

/* SS - 20051004 - B */
{a6arcsrp05.i "new"}
/* SS - 20051004 - E */

{mfdtitle.i "2+ "}
{cxcustom.i "ARCSRP05.P"}

/* ********** Begin Translatable Strings Definitions ********* */

{&ARCSRP05-P-TAG1}

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

/* THESE ARE NEEDED FOR FULL GUI REPORTS */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

define new shared variable cust like ar_bill.
define new shared variable cust1 like ar_bill.
define new shared variable cust_type like cm_type
   label {&arcsrp05_p_4}.
define new shared variable cust_type1 like cm_type.
define new shared variable nbr like ar_nbr.
define new shared variable nbr1 like ar_nbr.
define new shared variable slspsn like sp_addr.
define new shared variable slspsn1 like slspsn.
define new shared variable acct like ar_acct.
define new shared variable acct1 like ar_acct.
define new shared variable sub like ar_sub.
define new shared variable sub1 like ar_sub.
define new shared variable cc like ar_cc.
define new shared variable cc1 like ar_cc.
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
/* SS - 20051004 - B */
/*
define new shared variable age_days as integer extent 4
   label {&arcsrp05_p_2}.
*/
define new shared variable age_days as integer extent 6
   label {&arcsrp05_p_2}.
/* SS - 20051004 - E */
define new shared variable mstr_type like cd_type initial "AR".
define new shared variable mstr_lang like cd_lang.
define variable i as integer.
define new shared variable entity like gl_entity.
define new shared variable entity1 like gl_entity.
define new shared variable lstype like ls_type.
define new shared variable age_by as character format "x(3)" label
   {&arcsrp05_p_3} initial "DUE".
define new shared variable mc-rpt-curr like base_rpt no-undo.
define variable mc-dummy-fixed like so_fix_rate no-undo.
define variable l_batchid      like bcd_batch   no-undo.

{&ARCSRP05-P-TAG12}
{etrpvar.i &new = "new"}
{etvar.i   &new = "new"}
{eteuro.i}

{&ARCSRP05-P-TAG2}
{&ARCSRP05-P-TAG13}
form
   cust            colon 15
   cust1           label {t001.i} colon 49 skip
   cust_type       colon 15
   cust_type1      label {t001.i} colon 49 skip
   nbr             colon 15
   nbr1            label {t001.i} colon 49 skip
   slspsn          colon 15
   slspsn1         label {t001.i} colon 49 skip
   acct            colon 15
   acct1           label {t001.i} colon 49 skip
   sub             colon 15
   sub1            label {t001.i} colon 49 skip
   cc              colon 15
   cc1             label {t001.i} colon 49 skip
   entity          colon 15
   entity1         label {t001.i} colon 49
   lstype          colon 15
   skip
   age_by          colon 26  show_po            colon 60
   effdate1        colon 26  show_pay_detail    colon 60
   summary_only    colon 26  show_comments      colon 60
   base_rpt        colon 26  show_mstr_comments colon 60
   et_report_curr  colon 26
   mstr_type colon 60
   mstr_lang colon 60
   skip
   space(1)
   age_days[1]
   age_days[2]    label "[2]"
   age_days[3]    label "[3]"
    /* SS - 20051004 - B */
    age_days[4]    label "[4]"
    age_days[5]    label "[5]"
    /* SS - 20051004 - E */
with frame a side-labels
   no-attr-space
   width 80.
{&ARCSRP05-P-TAG14}
{&ARCSRP05-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form header
   mc-curr-label to 65 et_report_curr skip
   mc-exch-label to 65 mc-exch-line1 skip
   mc-exch-line2 at 67 skip(1)
with frame phead2
   no-labels page-top
   width 132.

repeat:

   if cust1 = hi_char then cust1 = "".
   if cust_type1 = hi_char then cust_type1 = "".
   if nbr1 = hi_char then nbr1 = "".
   if slspsn1 = hi_char then slspsn1 = "".
   if acct1 = hi_char then acct1 = "".
   if sub1 = hi_char then sub1 = "".
   if cc1 = hi_char then cc1 = "".
   if entity1 = hi_char then entity1 = "".

   /* SS - 20051004 - B */
   /*
   do i = 1 to 4:
       */
   do i = 1 to 6:
       /* SS - 20051004 - E */
      if age_days[i] = 0 then age_days[i] = (i * 30).
   end.

   {&ARCSRP05-P-TAG4}
   update
      cust cust1
      cust_type cust_type1
      nbr nbr1
      slspsn slspsn1
      acct acct1
      sub sub1
      cc cc1
      entity entity1
      lstype
      age_by
      effdate1 summary_only base_rpt
      et_report_curr
      {&ARCSRP05-P-TAG15}
      show_po show_pay_detail show_comments
      show_mstr_comments mstr_type mstr_lang
      {&ARCSRP05-P-TAG16}
       /* SS - 20051004 - B */
       /*
      age_days[1 for 3]
       */
       age_days[1 for 5]
       /* SS - 20051004 - E */
   with frame a.
   {&ARCSRP05-P-TAG5}

   {&ARCSRP05-P-TAG6}
   assign et_eff_date = effdate1.
   {&ARCSRP05-P-TAG7}

/* Code below to be wrapped in a 'do' code block for correct GUI conversion */

   do:
      {&ARCSRP05-P-TAG17}
      bcdparm = "".
      {mfquoter.i cust        }
      {mfquoter.i cust1       }
      {mfquoter.i cust_type   }
      {mfquoter.i cust_type1  }
      {mfquoter.i nbr         }
      {mfquoter.i nbr1        }
      {mfquoter.i slspsn      }
      {mfquoter.i slspsn1     }
      {mfquoter.i acct        }
      {mfquoter.i acct1       }
      {mfquoter.i sub         }
      {mfquoter.i sub1        }
      {mfquoter.i cc          }
      {mfquoter.i cc1         }
      {mfquoter.i entity      }
      {mfquoter.i entity1     }
      {mfquoter.i lstype      }
      {&ARCSRP05-P-TAG8}
      {mfquoter.i age_by      }
      {&ARCSRP05-P-TAG9}
      {mfquoter.i effdate1    }
      {mfquoter.i summary_only}
      {mfquoter.i base_rpt    }
      {mfquoter.i et_report_curr }
      {&ARCSRP05-P-TAG18}
      {mfquoter.i show_po     }
      {mfquoter.i show_pay_detail}
      {mfquoter.i show_comments}
      {mfquoter.i show_mstr_comments}
      {&ARCSRP05-P-TAG22}
      {mfquoter.i mstr_type   }
      {mfquoter.i mstr_lang   }
      {&ARCSRP05-P-TAG19}
      {mfquoter.i age_days[1] }
      {mfquoter.i age_days[2] }
      {mfquoter.i age_days[3] }
          /* SS - 20051004 - B */
          {mfquoter.i age_days[4] }
          {mfquoter.i age_days[5] }
          /* SS - 20051004 - E */

      if cust1 = "" then cust1 = hi_char.
      if cust_type1 = "" then cust_type1 = hi_char.
      if nbr1 = "" then nbr1 = hi_char.
      if slspsn1 = "" then slspsn1 = hi_char.
      if acct1 = "" then acct1 = hi_char.
      if sub1 = "" then sub1 = hi_char.
      if cc1 = "" then cc1 = hi_char.
      if entity1 = "" then entity1 = hi_char.
      {&ARCSRP05-P-TAG10}

      /* VALIDATE AGE_BY   */
      if (lookup(age_by,"DUE,EFF,INV") = 0)
      then do:
         /* MUST BE DUE, EFF or INV */
         {pxmsg.i &MSGNUM=3551 &ERRORLEVEL=3}
         next-prompt age_by with frame a.
         undo,retry.
      end.
/*N0ZX*/    {&ARCSRP05-P-TAG11}
      /* Validate currency */
      run ip-chk-valid-curr
         (input  base_rpt,
         output mc-error-number).

      if mc-error-number <> 0 then do:
         next-prompt base_rpt with frame a.
         undo, retry.
      end.

      /* Validate reporting currency */
      run ip-chk-valid-curr
         (input  et_report_curr,
         output mc-error-number).

      if mc-error-number = 0 then do:

         /* Default currencies if blank */
         mc-rpt-curr = if base_rpt = "" then base_curr else base_rpt.
         if et_report_curr = "" then et_report_curr = mc-rpt-curr.

         /* Prompt for exchange rate and format for output */
         run ip-ex-rate-setup
            (input  et_report_curr,
            input  mc-rpt-curr,
            input  " ",
            input  et_eff_date,
            output et_rate2,
            output et_rate1,
            output mc-exch-line1,
            output mc-exch-line2,
            output mc-error-number).

      end.  /* if mc-error-number = 0 */

      if mc-error-number <> 0 then do:
         next-prompt et_report_curr with frame a.
         undo, retry.
      end.

   end.

   on go anywhere
   do:
      if frame-field = "batch_id"
      then
         l_batchid = frame-value.

      /* TO CHECK NON-BLANK VALUE OF BATCH ID WHEN CURSOR IS */
      /* IN BATCH ID OR OUTPUT FIELD                         */
      if ((frame-field     =  "batch_id"
          and frame-value  <> "")
          or (frame-field  =  "dev"
             and l_batchid <> ""))
          and (mc-rpt-curr <> et_report_curr)
      then do:
         /* USER-INPUT EXCHANGE RATE WILL BE IGNORED IN BATCH MODE */
         {pxmsg.i &MSGNUM=4629 &ERRORLEVEL=2}
         pause.
      end. /* IF FRAME-FIELD = "batch_id" AND... */
   end. /* ON GO ANYWHERE */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
       /* SS - 20051004 - B */
       /*
   {&ARCSRP05-P-TAG20}
   {mfphead.i}
   {&ARCSRP05-P-TAG21}

   view frame phead2.

   {gprun.i ""arcsrp5a.p""}

   hide frame phead2.

   /* REPORT TRAILER */
   {mfrtrail.i}
       */
       PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

       FOR EACH tta6arcsrp05:
           DELETE tta6arcsrp05.
       END.
       {gprun.i ""a6arcsrp05.p"" "(
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
           INPUT age_days[6]
           )"}
       EXPORT DELIMITER ";" "bill" "acct" "sub" "cc" "nbr" "type" "effdate" "due_date" "date" "et_age_amt[1]" "et_age_amt[2]" "et_age_amt[3]" "et_age_amt[4]" "et_age_amt[5]" "et_age_amt[6]" "amt".
       FOR EACH tta6arcsrp05:
           EXPORT DELIMITER ";" tta6arcsrp05_bill tta6arcsrp05_acct tta6arcsrp05_sub tta6arcsrp05_cc tta6arcsrp05_nbr tta6arcsrp05_type tta6arcsrp05_effdate tta6arcsrp05_due_date tta6arcsrp05_date tta6arcsrp05_et_age_amt[1] tta6arcsrp05_et_age_amt[2] tta6arcsrp05_et_age_amt[3] tta6arcsrp05_et_age_amt[4] tta6arcsrp05_et_age_amt[5] tta6arcsrp05_et_age_amt[6] tta6arcsrp05_amt.
       END.

       PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

       {a6mfrtrail.i}
       /* SS - 20051004 - E */

end.  /* repeat */

PROCEDURE ip-chk-valid-curr:

   define input  parameter i_curr  as character no-undo.
   define output parameter o_error as integer   no-undo initial 0.

   if i_curr <> "" then do:

      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input  i_curr,
           output o_error)" }

      if o_error <> 0 then do:
         {pxmsg.i &MSGNUM=o_error &ERRORLEVEL=3}
      end.

   end.  /* if i_curr */

END PROCEDURE.  /* ip-chk-valid-curr */

PROCEDURE ip-ex-rate-setup:

   define input  parameter i_curr1      as character no-undo.
   define input  parameter i_curr2      as character no-undo.
   define input  parameter i_type       as character no-undo.
   define input  parameter i_date       as date      no-undo.
   define output parameter o_rate       as decimal   no-undo initial 1.
   define output parameter o_rate2      as decimal   no-undo initial 1.
   define output parameter o_disp_line1 as character no-undo initial "".
   define output parameter o_disp_line2 as character no-undo initial "".
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
         if not batchrun
         then do:
            {gprunp.i "mcui" "p" "mc-ex-rate-input"
               "(input i_curr1,
                 input        i_curr2,
                 input        i_date,
                 input        v_seq,
                 input        false,
                 input        5,
                 input-output o_rate,
                 input-output o_rate2,
                 input-output v_fix_rate)" }
         end. /* IF NOT BATCHRUN */

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
         {pxmsg.i &MSGNUM=o_error &ERRORLEVEL=3}
      end.

   end.  /* do transaction */

END PROCEDURE.  /* ip-ex-rate-setup */
