/* arcsrp01.p - AR AGING REPORT FROM DUE DATE                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.11.1.6 $                                                         */
/*K0PN         */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 6.0      LAST MODIFIED: 08/30/90   BY: afs *D059*               */
/* REVISOIN: 6.0      LAST MODIFIED: 08/31/90   BY: afs *D066*               */
/* REVISION: 6.0      LAST MODIFIED: 10/16/90   BY: afs *D101*               */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: afs *D283*   (rev only)  */
/* REVISION: 6.0      LAST MODIFIED: 06/24/91   BY: afs *D723*               */
/* REVISION: 6.0      LAST MODIFIED: 07/12/91   BY: afs *D760*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 11/25/91   BY: afs *F041*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   BY: jjs *F237*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F288*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: tjs *F337*               */
/*                                   05/11/92   by: jms *F481*   (rev only)  */
/*                                   06/18/92   by: jjs *F670*               */
/*                                   07/29/92   by: jms *F829*   (rev only)  */
/*                                   09/15/94   by: ljm *GM57*   (rev only)  */
/*                                   04/10/96   by: jzw *G1P6*               */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: bvm *K0PN*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00M* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L02Q* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                 */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.11.1.6 $    BY: Karan Motwani         DATE: 06/27/02  ECO: *N1MK*  */
/*By: Neil Gao 09/03/17 ECO: *SS 20090317* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*****************************************************************************/

/* Changed ConvertMode from FullGUIReport to Report                          */

{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arcsrp01_p_1 "Customer Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp01_p_2 "Deduct Contested"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp01_p_3 "Aging Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp01_p_4 "Column Days"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp01_p_5 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp01_p_6 "Show Invoice Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp01_p_7 "Show Customer PO"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp01_p_8 "Show Payment Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp01_p_9 "Show Master Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* THESE ARE NEEDED FOR FULL GUI REPORTS */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

define new shared variable cust               like ar_bill.
define new shared variable cust1              like ar_bill.
define new shared variable cust_type          like cm_type
   label {&arcsrp01_p_1}.
define new shared variable cust_type1         like cm_type.
define new shared variable nbr                like ar_nbr.
define new shared variable nbr1               like ar_nbr.
define new shared variable slspsn             like sp_addr.
define new shared variable slspsn1            like slspsn.
define new shared variable acct               like ar_acct.
define new shared variable acct1              like ar_acct.
define new shared variable sub                like ar_sub.
define new shared variable sub1               like ar_sub.
define new shared variable cc                 like ar_cc.
define new shared variable cc1                like ar_cc.
define new shared variable due_date           like ar_due_date.
define new shared variable due_date1          like ar_due_date.
define new shared variable name               like ad_name.
define new shared variable age_days           as integer   extent 5
   label {&arcsrp01_p_4}.
define new shared variable age_range          as character extent 5
   format "X(16)".
define new shared variable i                  as integer.
define new shared variable age_amt            like ar_amt  extent 5.
define new shared variable age_period         as integer.
define new shared variable cm_recno           as recid.
define new shared variable balance            like cm_balance.
define new shared variable age_paid           like ar_amt extent 5.
define new shared variable sum_amt            like ar_amt extent 5.
define new shared variable show_pay_detail    like mfc_logical
   label {&arcsrp01_p_8} initial no.
define new shared variable summary_only       like mfc_logical
   format {&arcsrp01_p_5} label {&arcsrp01_p_5} initial no.
define new shared variable show_po            like mfc_logical
   label {&arcsrp01_p_7} initial no.
define new shared variable inv_tot            like ar_amt.
define new shared variable memo_tot           like ar_amt.
define new shared variable fc_tot             like ar_amt.
define new shared variable drft_tot           like ar_amt.
define new shared variable paid_tot           like ar_amt.
define new shared variable base_amt           like ar_amt.
define new shared variable base_applied       like ar_applied.
define new shared variable base_rpt           like ar_curr.
define new shared variable age_date           like ar_due_date
   label {&arcsrp01_p_3} initial today.
define new shared variable due-date           like ar_date.
define new shared variable applied-amt        like ar_applied.
define new shared variable amt-due            like ar_amt.
define new shared variable this-applied       like ar_applied.
define new shared variable closed             like mfc_logical.
define new shared variable multi-due          like mfc_logical.
define new shared variable deduct_contest     like mfc_logical
   label {&arcsrp01_p_2}.
define new shared variable contested          as character format "x(5)".
define new shared variable curr_amt           like ar_amt.
define new shared variable show_comments      like mfc_logical
   label {&arcsrp01_p_6} initial no.
define new shared variable show_mstr_comments like mfc_logical
   label {&arcsrp01_p_9} initial no.
define new shared variable mstr_type          like cd_type initial "AR".
define new shared variable mstr_lang          like cd_lang.
define new shared variable entity             like gl_entity.
define new shared variable entity1            like gl_entity.
define new shared variable lstype             like ls_type.
define new shared variable mc-rpt-curr        like ar_curr no-undo.

define            variable mc-dummy-fixed     like so_fix_rate no-undo.
define            variable l_batchid          like bcd_batch   no-undo.

{etrpvar.i &new = "new"}
{etvar.i   &new = "new"}
{eteuro.i}

form
   cust           colon 15
   cust1          label {t001.i} colon 49 skip
   cust_type      colon 15
   cust_type1     label {t001.i} colon 49 skip
   due_date       colon 15
   due_date1      label {t001.i} colon 49 skip
   nbr            colon 15
   nbr1           label {t001.i} colon 49 skip
   slspsn         colon 15
   slspsn1        label {t001.i} colon 49
   acct           colon 15
   acct1          label {t001.i} colon 49 skip
   sub            colon 15
   sub1           label {t001.i} colon 49 skip
   cc             colon 15
   cc1            label {t001.i} colon 49 skip
   entity         colon 15
   entity1        label {t001.i} colon 49
   lstype         colon 15
   skip
   age_date        colon 22  show_po            colon 58
   summary_only    colon 22  show_pay_detail    colon 58
   base_rpt        colon 22  show_comments      colon 58
   et_report_curr  colon 22
   deduct_contest  colon 58
   mstr_lang
   show_mstr_comments        colon 58
   mstr_type
   /*V8! space(.2) */
   skip
   space(1)
   age_days[1]
   age_days[2]    label "[2]"
   age_days[3]    label "[3]"
   age_days[4]    label "[4]"
with frame a side-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:

   if nbr1 = hi_char
   then
      nbr1 = "".

   if cust1 = hi_char
   then
      cust1 = "".

   if cust_type1 = hi_char
   then
      cust_type1 = "".

   if due_date = low_date
   then
      due_date = ?.

   if due_date1 = hi_date
   then
      due_date1 = ?.

   if slspsn1 = hi_char
   then
      slspsn1 = "".

   if acct1 = hi_char
   then
      acct1 = "".

   if sub1 = hi_char
   then
      sub1 = "".

   if cc1 = hi_char
   then
      cc1 = "".

   if entity1 = hi_char
   then
      entity1 = "".

   do i = 1 to 5:
      if age_days[i] = 0
      then
         age_days[i] = ((i - 1) * 30).
   end. /* DO i = 1 to 5 */

   update
      cust
      cust1
      cust_type
      cust_type1
      due_date
      due_date1
      nbr
      nbr1
      slspsn
      slspsn1
      acct
      acct1
      sub
      sub1
      cc
      cc1
      entity
      entity1
      lstype
      age_date
      summary_only
      base_rpt
      et_report_curr
      show_po
      show_pay_detail
      show_comments
      deduct_contest
      show_mstr_comments
      mstr_lang
      mstr_type
      age_days[1 for 4]
   with frame a.

   et_eff_date = age_date.

   do:
      bcdparm = "".
      {mfquoter.i cust        }
      {mfquoter.i cust1       }
      {mfquoter.i cust_type   }
      {mfquoter.i cust_type1  }
      {mfquoter.i due_date    }
      {mfquoter.i due_date1   }
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
      {mfquoter.i age_date    }
      {mfquoter.i summary_only}
      {mfquoter.i base_rpt    }
      {mfquoter.i et_report_curr }
      {mfquoter.i show_po     }
      {mfquoter.i show_pay_detail}
      {mfquoter.i show_comments}
      {mfquoter.i deduct_contest}
      {mfquoter.i show_mstr_comments}
      {mfquoter.i mstr_lang   }
      {mfquoter.i mstr_type   }
      {mfquoter.i age_days[1] }
      {mfquoter.i age_days[2] }
      {mfquoter.i age_days[3] }
      {mfquoter.i age_days[4] }

      if cust1 = ""
      then
         cust1 = hi_char.

      if cust_type1 = ""
      then
         cust_type1 = hi_char.

      if due_date = ?
      then
         due_date = low_date.

      if due_date1 = ?
      then
         due_date1 = hi_date.

      if nbr1 = ""
      then
         nbr1 = hi_char.

      if slspsn1 = ""
      then
         slspsn1 = hi_char.

      if acct1 = ""
      then
         acct1 = hi_char.

      if sub1 = ""
      then
         sub1 = hi_char.

      if cc1 = ""
      then
         cc1 = hi_char.

      if entity1 = ""
      then
         entity1 = hi_char.

      /* Validate currency */
      run ip-chk-valid-curr
         (input  base_rpt,
         output mc-error-number).

      if mc-error-number <> 0
      then do:
         next-prompt base_rpt with frame a.
         undo, retry.
      end. /* IF mc-error-number <> 0 */

      /* Validate reporting currency */
      run ip-chk-valid-curr
         (input  et_report_curr,
         output mc-error-number).

      if mc-error-number = 0
      then do:

         /* Default currencies if blank */
         mc-rpt-curr = if base_rpt = ""
                       then
                          base_curr
                       else
                          base_rpt.

         if et_report_curr = ""
         then
            et_report_curr = mc-rpt-curr.

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

      end.  /* IF mc-error-number = 0 */

      if mc-error-number <> 0
      then do:
         next-prompt et_report_curr with frame a.
         undo, retry.
      end. /* IF mc-error-number <> 0 */

   end. /* DO */

   /* OUTPUT DESTINATION SELECTION */

   on go anywhere
   do:
      if frame-field = "batch_id":U
      then
         l_batchid = frame-value.

      /* TO CHECK NON-BLANK VALUE OF BATCH ID WHEN CURSOR IS */
      /* IN BATCH ID OR OUTPUT FIELD                         */
      if ((frame-field       =  "batch_id":U
           and frame-value   <> "")
           or (frame-field   =  "dev":U
           and l_batchid <> ""))
           and (mc-rpt-curr  <> et_report_curr)
      then do:
         /* USER-INPUT EXCHANGE RATE WILL BE IGNORED IN BATCH MODE */
         {pxmsg.i &MSGNUM=4629 &ERRORLEVEL=2}
         pause.
      end. /* IF FRAME-FIELD = "batch_id" AND ... */
   end. /* ON GO ANYWHERE */

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

/*SS 20090317 - B*/
/*
   {gprun.i ""arcsrp1a.p""}
*/
	{gprun.i ""xxcmblup1a.p""}
/*SS 20090317 - E*/
   {mfrtrail.i}

end.  /* REPEAT */

PROCEDURE ip-chk-valid-curr:

   define input  parameter i_curr  as character no-undo.
   define output parameter o_error as integer   no-undo initial 0.

   if i_curr <> ""
   then do:

      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input  i_curr,
           output o_error)" }

      if o_error <> 0
      then do:
         {pxmsg.i &MSGNUM=o_error &ERRORLEVEL=3}
      end. /* IF o_error <> 0 */

   end.  /* IF i_curr */

END PROCEDURE.  /* PROCEDURE ip-chk-valid-curr */

PROCEDURE ip-ex-rate-setup:

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
   define variable v_fix_rate           as logical   no-undo.

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

      if o_error = 0
      then do:

         /* Prompt user to edit exchange rate */
         if not batchrun
         then do:

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

         end. /* IF NOT batchrun */

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

      end.  /* IF o_error */

      else do:
         {pxmsg.i &MSGNUM=o_error &ERRORLEVEL=3}
      end. /* ELSE DO */

   end.  /* DO TRANSACTION */

END PROCEDURE.  /* PROCEDURE ip-ex-rate-setup */
