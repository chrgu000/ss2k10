/* apparp.p - AP PAYMENT SELECTION REGISTER                                  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.15.1.7 $                                                         */
/*V8:ConvertMode=Report                                                      */
/*H1D8 /*F0PN*/ /*V8:Convert***Mode***=***Full***GUI***Report        */      */
/* REVISION: 1.0      LAST MODIFIED: 11/21/86   BY: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 04/03/91   BY: MLV *D471*               */
/* REVISION: 6.0      LAST MODIFIED: 04/09/91   BY: MLV *D501*               */
/* REVISION: 6.0      LAST MODIFIED: 06/28/91   BY: MLV *D733*               */
/* REVISION: 7.0      LAST MODIFIED: 12/02/91   BY: MLV *F037*               */
/* REVISION: 7.0      LAST MODIFIED: 12/13/91   BY: MLV *F074*               */
/* REVISION: 7.0      LAST MODIFIED: 01/31/92   BY: MLV *F115*               */
/* REVISION: 7.0      LAST MODIFIED: 03/06/92   BY: mlv *F257*               */
/* REVISION: 7.3      LAST MODIFIED: 09/15/92   BY: MLV *G060*               */
/*                                   09/24/92   BY: MPP *G475*               */
/*                                   02/17/93   by: jms *G690*               */
/*                                   05/17/93   by: jms *GB09*               */
/*                                   06/01/93   by: wep *GB56*               */
/*                                   07/22/93   by: wep *GD59*               */
/*                                   09/22/93   by: wep *H131*               */
/*                                   10/15/93   by: jjs *H181*               */
/*                                   12/01/93   by: jjs *H262*               */
/*                                   02/25/94   by: jjs *H284*               */
/*                                   04/04/94   by: pcd *H324*               */
/*                                   04/21/94   by: jjs *FN54*               */
/*                                   04/28/94   by: srk *FN21*               */
/* PROGRAM SPLIT APPARP.P ----> APPARP.P AND APPARPA.P                       */
/*                                   06/29/94   by: bcm *H415*               */
/*                                   03/24/95   by: aed *G0HT*               */
/*                                   04/19/95   by: jzw *F0QR*               */
/*                                   04/10/96   by: jzw *G1LD*               */
/* REVISION: 7.4      LAST MODIFIED: 08/14/97   BY: *H1D8* Irine D'mello     */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: ckm *K15P*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 03/31/98   BY: *J2D8* Kawal Batra       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Pre-86E commented code removed, view in archive revision 1.11             */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 09/18/98   BY: *J30B* Santhosh Nair     */
/* REVISION: 8.6E     LAST MODIFIED: 10/09/98   BY: *L0BM* Steve Goeke       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/25/99   BY: *L0H7* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                 */
/* Old ECO marker removed, but no ECO header exists *N0C9*                    */
/* $Revision: 1.15.1.7 $    BY: Ed van de Gevel       DATE: 11/05/01  ECO: *N15M*  */
/* BY: Micho Yang    DATE: 08/24/06 ECO: *SS - 20060824.1*   */
/* BY: Bill Jiang    DATE: 08/28/06 ECO: *SS - 20060828.1*   */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*****************************************************************************/

{mfdtitle.i "b+ "}

/* SS - 200600824.1 B */
{a6apparp01.i "new" }
/* SS - 200600824.1 E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apparp_p_1 "Check Date"
/* MaxLen: 10 Comment: */

&SCOPED-DEFINE apparp_p_2 "Print Remarks"
/* MaxLen: Comment: */

&SCOPED-DEFINE apparp_p_4 "Account Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apparp_p_6 "Sort Vouchers by Amount"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* ADDED NO-UNDO, ASSIGN THROUGHOUT */

define new shared variable base_rpt   like ap_curr  no-undo.
define new shared variable bank       like ap_bank  no-undo.
define new shared variable print_rmk  like mfc_logical
   label {&apparp_p_2}
   initial yes  no-undo.
define new shared variable sort_by_amount like mfc_logical
   label {&apparp_p_6}
   initial yes no-undo.
define new shared variable check_rate like vo_ex_rate  no-undo.
define new shared variable check_rate2 like vo_ex_rate2 no-undo.

/* VARIABLE TO STORE BANK ACCOUNT SO THAT LEADING ZEROS ARE  */
/* RETAINED FOR CHECK FORM "3" and "4" AND                   */
/* BANK ACCOUNT VALIDATION AS BLANK                          */
define new shared variable l_bankacct1 like bk_bk_acct1 format "x(24)"
   no-undo.

define variable mc_fixed_rate_not_used like mfc_logical no-undo.
define new shared variable print_date like ap_date
   label {&apparp_p_1}
   initial today  no-undo.

define new shared variable ckfrm      like ap_ckfrm  no-undo.
define new shared variable bk_val     like mfc_logical  no-undo.
define new shared variable bankacct1  as decimal  no-undo.
define new shared variable bk1_ok     as logical  no-undo.
define new shared variable bk2_ok     as logical  no-undo.
define new shared variable isvalid    like mfc_logical  no-undo.
define new shared variable bk_acct1   like ad_bk_acct1  no-undo.
define new shared variable bk_acct2   like ad_bk_acct1  no-undo.

define new shared variable bk_acct_type      like ad_addr
   format "x(3)"
   label {&apparp_p_4}  no-undo.
define new shared variable bk_acct_type_code like ad_addr
   initial "2"  no-undo.
define new shared variable bk_acct_type_desc like glt_desc  no-undo.

define variable mc-error-number       like msg_nbr        no-undo.
define variable report_curr           like vo_curr        no-undo.
define variable check_ratetype        like vo_ex_ratetype no-undo.
define variable check_exru_seq        like vo_exru_seq    no-undo.

define new shared variable fname      like lngd_dataset no-undo
   initial "csbd_det".

define variable for_exg_rate as character format "x(33)".

for_exg_rate = " (" + getTermLabel("USED_FOR_EXCHANGE_RATES",30) + ")".

form
   base_rpt     colon 26 skip
   bank         colon 26

   space(2) bk_curr no-label
   space(2) bk_desc no-label

   ckfrm        colon 26 format "x(1)"
   bk_acct_type colon 26
   print_rmk    colon 26
   sort_by_amount colon 26

   print_date   colon 26 for_exg_rate no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

for first gl_ctrl
   fields (gl_bk_val) no-lock:
end.

for first apc_ctrl
   fields (apc_bank apc_ckfrm) no-lock:
end.

assign
   ckfrm = apc_ckfrm
   bank  = apc_bank.

/* GET DEFAULT BANK ACCOUNT TYPE FROM lngd_det */
{gplngn2a.i &file = ""csbd_det""
   &field = ""bk_acct_type""
   &code  = bk_acct_type_code
   &mnemonic = bk_acct_type
   &label = bk_acct_type_desc}

{wbrp01.i}
repeat:

   bcdparm = "".

   display for_exg_rate with frame a.

   if c-application-mode <> 'web' then

   update
      base_rpt
      bank

      ckfrm
      bk_acct_type
      print_rmk
      sort_by_amount
      print_date
   with frame a.

   for first bk_mstr
      fields (bk_bk_acct1 bk_bk_acct2 bk_code bk_curr bk_desc)
      where bk_code = input bank no-lock:
   end.

   {wbrp06.i &command = update
      &fields = " base_rpt bank ckfrm
        bk_acct_type print_rmk  sort_by_amount
        print_date  "
      &frm = "a" }

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      for first bk_mstr
         fields (bk_bk_acct1 bk_bk_acct2 bk_code bk_curr bk_desc)
         where bk_code = bank no-lock:
      end.

      if available bk_mstr then
   do:
         display
            bk_desc
            bk_curr
         with frame a.
         pause 0.
      end.
      else do:
         {pxmsg.i &MSGNUM=1200 &ERRORLEVEL=3} /* NOT A VALID BANK */

         if c-application-mode = 'web' then return.
         else next-prompt bank with frame a.
         undo, retry.
      end.

      report_curr = if base_rpt = "" then base_curr else base_rpt.

      /* Validate that exchange rate exists */
      {gprunp.i "mcpl" "p" "mc-get-ex-rate"
         "(input  bk_curr,
           input  report_curr,
           input  check_ratetype,
           input  print_date,
           output check_rate,
           output check_rate2,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         next-prompt base_rpt with frame a.
         undo, retry.
      end.

      if ckfrm = "" then do:
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3} /*BLANK NOT ALLOWED*/

         if c-application-mode = 'web' then return.
         else next-prompt ckfrm with frame a.
         undo, retry.
      end.

      /* MORE CHECK FORM VALIDATION */
      if lookup(ckfrm, "1,2,3,4,5,6,7") = 0 then do:
         {pxmsg.i &MSGNUM=185 &ERRORLEVEL=3} /*INVALID CHECK FORM*/

         if c-application-mode = 'web' then return.
         else next-prompt ckfrm with frame a.
         undo, retry.
      end.

      /* VALIDATE BANK ACCOUNT TYPE - MUST BE IN lngd_det */
      {gplngv.i &file     = ""csbd_det""
         &field    = ""bk_acct_type""
         &mnemonic = bk_acct_type
         &isvalid  = isvalid}
      if not isvalid then do:
         {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3}
         /* INVALID MNEMONIC bk_acct_type */

         if c-application-mode = 'web' then return.
         else next-prompt bk_acct_type with frame a.
         undo, retry.
      end.

      /* PICK UP NUMERIC FOR BANK ACCOUNT TYPE CODE FROM MNEMONIC */
      {gplnga2n.i &file  = ""csbd_det""
         &field = ""bk_acct_type""
         &mnemonic = bk_acct_type
         &code = bk_acct_type_code
         &label = bk_acct_type_desc}

      /* VALIDATE USER BANK ACCT WITH 11 CHECK */
      /* IF FILE AND BKVAL = 11 */
      if gl_ctrl.gl_bk_val = "11" or gl_bk_val = "12" then
         bk_val = yes.
      else bk_val = no.

      if available bk_mstr then do:

         /* ADDED SEVENTH OUTPUT PARAMETER l_bankacct1 */

         {gprun.i ""apbkval.p"" "(input bk_val,
              input bk_bk_acct1,
              input bk_bk_acct2,
              output bk1_ok,
              output bk2_ok,
              output bankacct1,
              output l_bankacct1)" }

         if bk_val = no then do:
            assign
               bk1_ok = yes
               bk2_ok = yes.
         end.

      end.

      do transaction:
         /* Get exchange rate and create usage records for editing */
         {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
            "(input  bk_curr,
              input  report_curr,
              input  check_ratetype,
              input  print_date,
              output check_rate,
              output check_rate2,
              output check_exru_seq,
              output mc-error-number)"}
         /* Already validated, so no need to check mc-error-number */

         /* Input exchange rate */
         {gprunp.i "mcui" "p" "mc-ex-rate-input"
            "(input        bk_curr,
              input        report_curr,
              input        print_date,
              input        check_exru_seq,
              input        false,
              input        5,
              input-output check_rate,
              input-output check_rate2,
              input-output mc_fixed_rate_not_used)"}

         /* Delete exchange rate usage records */
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input check_exru_seq)"}
      end.  /* Transaction */

      bcdparm = "".
      {mfquoter.i base_rpt}
      {mfquoter.i bank}

      {mfquoter.i ckfrm}
      {mfquoter.i bk_acct_type}
      {mfquoter.i print_rmk}
      {mfquoter.i sort_by_amount}
      {mfquoter.i print_date}

      if print_date = ? then print_date = today.

   end. /* NOT WEB */

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
   /* SS - 20060828.1 - B */
   /*
   {mfphead.i}
   */
   /* SS - 20060828.1 - E */

   /* SS - 200600824.1 B */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   EMPTY TEMP-TABLE tta6apparp01.

   /* CALL TO SECOND HALF OF PROGRAM */
   {gprun.i ""a6apparp01.p"" "(
      INPUT base_rpt,
      INPUT bank,
      INPUT ckfrm,
      INPUT bk_acct_type,
      INPUT print_rmk,
      INPUT SORT_by_amount,
      INPUT print_date
      )"}

   EXPORT DELIMITER ";" "ap_vend" "name" "vo__qad02" "disp_bankno" "vo_ref" "vo_invoice" "vopo" "ap_bank" "ap_effdate" "vo_due_date" "vo_disc_date" "disp_curr" "ap_ckfrm" "gross_amt" "hold" "base_disc_chg" "base_amt_chg" "ap_rmk" "flag".

   FOR EACH tta6apparp01:
       EXPORT DELIMITER ";" tta6apparp01 .
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   /* SS - 200600824.1 E */

   /* REPORT TRAILER */
   {a6mfrtrail.i}
end.   /* REPEAT */

{wbrp04.i &frame-spec = a}
