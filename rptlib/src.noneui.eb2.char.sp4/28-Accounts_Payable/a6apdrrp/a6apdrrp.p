/* apdrrp.p  -  AP DRAFT RECONCILIATION (STATUS) REPORT                */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                 */
/* All rights reserved worldwide.  This is an unpublished work.        */
/* $Revision: 1.8.1.12 $                                                         */
/*V8:ConvertMode=Report                                       */
/* REVISION: 7.4      LAST MODIFIED: 11/29/93   BY: wep *H246*         */
/*                                   06/29/94   BY: bcm *H416*         */
/*                                   10/19/94   BY: had *H571*         */
/*                                   04/10/95   BY: jpm *H0CH*         */
/*                                   07/07/95   BY: jzw *H0F8*         */
/* REVISION: 8.5      LAST MODIFIED: 12/24/95   BY: mwd *J053*         */
/* REVISION: 8.5      LAST MODIFIED: 04/04/96   BY: jzw *G1LD*         */
/* REVISION: 8.5      LAST MODIFIED: 05/05/97   BY: rxm *H0X5*         */
/* REVISION: 8.6      LAST MODIFIED: 10/21/97   BY: bvm *K13Y*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton*/
/* Pre-86E commented code removed, view in archive revision 1.5        */
/* Old ECO marker removed, but no ECO header exists *F441*             */
/* Old ECO marker removed, but no ECO header exists *F825*             */
/* Old ECO marker removed, but no ECO header exists *G934*             */
/* REVISION: 8.6E     LAST MODIFIED: 10/06/98   BY: *L09C* Santhosh Nair     */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1      LAST MODIFIED: 04/12/00   BY: *N07D* Antony Babu       */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MH* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00 BY: *N0W0* Mudit Mehta         */
/* Revision: 1.8.1.9  BY: Ed van de Gevel       DATE: 11/09/01  ECO: *N15N*  */
/* Revision: 1.8.1.10 BY: Ed van de Gevel       DATE: 09/05/02  ECO: *P0HQ*  */
/* Revision: 1.8.1.11 BY: Kedar Deherkar        DATE: 11/15/02  ECO: *N1WS* */
/* $Revision: 1.8.1.12 $  BY: Kedar Deherkar   DATE: 03/24/03 ECO: *N2B5* */
/* $Revision: 1.8.1.12 $  BY: Micho Yang       DATE: 02/24/06 ECO: *ADD BY SSMICHO - 20060224* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/***********************************************************************/

/* ADD BY SSMICHO - 20060224 - B */
/*
{mfdtitle.i "2+ "}
 */
 {a6mfdtitle.i "b+ "}
 {a6apdrrp.i}

    DEFINE INPUT PARAMETER i_bank        AS CHAR         .
    DEFINE INPUT PARAMETER i_bank1       AS CHAR         .
    DEFINE INPUT PARAMETER i_nbr         LIKE ck_nbr        .
    DEFINE INPUT PARAMETER i_nbr1        LIKE ck_nbr        .
    DEFINE INPUT PARAMETER i_apdate      AS DATE         .
    DEFINE INPUT PARAMETER i_apdate1     AS DATE         .
    DEFINE INPUT PARAMETER i_effdate     AS DATE         .
    DEFINE INPUT PARAMETER i_effdate1    AS DATE         .
    DEFINE INPUT PARAMETER i_clrdate     AS DATE         .
    DEFINE INPUT PARAMETER i_clrdate1    AS DATE         .
    DEFINE INPUT PARAMETER i_voideff     AS DATE         .
    DEFINE INPUT PARAMETER i_voideff1    AS DATE         .
    DEFINE INPUT PARAMETER i_due_date    AS DATE         .
    DEFINE INPUT PARAMETER i_due_date1   AS DATE         .
    DEFINE INPUT PARAMETER i_acc         LIKE ap_acct    .
    DEFINE INPUT PARAMETER i_acc1        LIKE ap_acct    .
    DEFINE INPUT PARAMETER i_rptdate     AS DATE         .
    DEFINE INPUT PARAMETER i_stat        LIKE ck_status .
    DEFINE INPUT PARAMETER i_base_rpt    LIKE ap_curr .
    DEFINE INPUT PARAMETER i_dispcurr    LIKE ap_curr .

    DEFINE VAR v_bk_dftap_acct AS CHAR .
    DEFINE VAR v_bk_dftap_sub  AS CHAR .
    DEFINE VAR v_bk_dftap_cc   AS CHAR .
    DEFINE VAR v_bk_desc       AS CHAR .

/* ADD BY SSMICHO - 20060224 - E */
{cxcustom.i "APDRRP.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apdrrp_p_1 "Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apdrrp_p_3 "As of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apdrrp_p_4 "Due Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apdrrp_p_6 "Clear Eff"
/* MaxLen: Comment: */

&SCOPED-DEFINE apdrrp_p_8 "Clr Eff"
/* MaxLen: Comment: */

&SCOPED-DEFINE apdrrp_p_11 "Draft Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE apdrrp_p_13 "Draft Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apdrrp_p_14 "Draft Eff"
/* MaxLen: Comment: */

&SCOPED-DEFINE apdrrp_p_15 "Draft"
/* MaxLen: Comment: */

&SCOPED-DEFINE apdrrp_p_16 "Eff Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apdrrp_p_18 "Status (CANCEL,VOID,OPEN)"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable detail_lines    as integer.
define variable dispcurr        as character format "x(4)".
define variable rptdate         as date label {&apdrrp_p_3}.
define variable out_count       as integer.
{&APDRRP-P-TAG1}
define variable nbr             like ck_nbr label {&apdrrp_p_15}.
define variable nbr1            like ck_nbr.
{&APDRRP-P-TAG2}
define variable bank            like ck_bank.
define variable bank1           like ck_bank.
define variable apdate          like ap_date
   label {&apdrrp_p_13}.
define variable apdate1         like ap_date.
define variable stat            like ck_status initial "OPEN"
   label {&apdrrp_p_18}.
define variable name            like ad_name.
define variable base_amt        like ap_amt format "->>>>>,>>>,>>9.99".
define variable effdate         like ap_effdate
   label {&apdrrp_p_14}.
define variable effdate1        like ap_effdate.
define variable ckstatus        like ck_status.
define variable clrdate         like ck_clr_date
   label {&apdrrp_p_6}.
define variable clrdate1        like ck_clr_date.
define variable voideff         like ck_voideff.
define variable voideff1        like ck_voideff.
define variable acc             like ap_acct.
define variable acc1            like ap_acct.
define variable due_date        like ap_date label {&apdrrp_p_4}.
define variable due_date1       like ap_date.
define variable base_rpt        like ap_curr.
define variable disp_base_amt   like ap_amt.
define variable ap_due_date     like ap_date.
define variable mc-error-number like msg_nbr     no-undo.
define variable l_print_rec     like mfc_logical no-undo.

find first gl_ctrl no-lock no-error.

form
   bank           colon 15   bank1     label {t001.i} colon 49
   nbr            colon 15   {&APDRRP-P-TAG15} format "999999" {&APDRRP-P-TAG16}
   nbr1      label {t001.i} colon 49
                             {&APDRRP-P-TAG17} format "999999" {&APDRRP-P-TAG18}
   apdate         colon 15   apdate1   label {t001.i} colon 49
   effdate        colon 15   effdate1  label {t001.i} colon 49
   clrdate        colon 15   clrdate1  label {t001.i} colon 49
   voideff        colon 15   voideff1  label {t001.i} colon 49
   due_date       colon 15   due_date1 label {t001.i} colon 49
   acc            colon 15   acc1      label {t001.i} colon 49 skip(1)
   rptdate        colon 35
   stat           colon 35

   base_rpt       colon 35   dispcurr  at 42 no-label
with frame a side-labels width 80.

/* ADD BY SSMICHO - 20060224 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
/* ADD BY SSMICHO - 20060224 - E */

bank = i_bank.
bank1 = i_bank1.
nbr = i_nbr.
nbr1 = i_nbr1.
apdate = i_apdate.
apdate1 = i_apdate1.
effdate = i_effdate.
effdate1 = i_effdate1.
clrdate = i_clrdate.
clrdate1 = i_clrdate1.
voideff = i_voideff.
voideff1 = i_voideff1.
due_date = i_due_date.
due_date1 = i_due_date1.
acc = i_acc.
acc1 = i_acc1.
rptdate = i_rptdate.
stat = i_stat.
base_rpt = i_base_rpt.
dispcurr = i_dispcurr.

{wbrp01.i}

/* ADD BY SSMICHO - 20060224 - B */
/*
repeat:
 */
/* ADD BY SSMICHO - 20060224 - E */

   if bank1     = hi_char  then bank1     = "".
   if apdate    = low_date then apdate    = ?.
   if apdate1   = hi_date  then apdate1   = ?.
   if effdate   = low_date then effdate   = ?.
   if effdate1  = hi_date  then effdate1  = ?.
   if clrdate   = low_date then clrdate   = ?.
   if clrdate1  = hi_date  then clrdate1  = ?.
   if voideff   = low_date then voideff   = ?.
   if voideff1  = hi_date  then voideff1  = ?.
   if due_date  = low_date then due_date  = ?.
   if due_date1 = hi_date  then due_date1 = ?.
   if acc1      = hi_char  then acc1      = "".

   /* ADD BY SSMICHO - 20060224 - B */
   /*
   if c-application-mode <> 'web' then
   update
      bank     bank1
      nbr      nbr1
      apdate   apdate1
      effdate  effdate1
      clrdate  clrdate1
      voideff  voideff1
      due_date due_date1
      acc      acc1
      rptdate
      stat
      base_rpt
   with frame a.

   {wbrp06.i &command = update &fields = "  bank bank1 nbr nbr1 apdate
        apdate1 effdate effdate1  clrdate clrdate1 voideff voideff1 due_date due_date1
        acc acc1 rptdate  stat   base_rpt" &frm = "a"}
   */
   /* ADD BY SSMICHO - 20060224 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i bank}
      {mfquoter.i bank1}
      {mfquoter.i nbr}
      {mfquoter.i nbr1}
      {mfquoter.i apdate}
      {mfquoter.i apdate1}
      {mfquoter.i effdate}
      {mfquoter.i effdate1}
      {mfquoter.i clrdate}
      {mfquoter.i clrdate1}
      {mfquoter.i voideff}
      {mfquoter.i voideff1}
      {mfquoter.i due_date}
      {mfquoter.i due_date1}
      {mfquoter.i acc}
      {mfquoter.i acc1}
      {mfquoter.i rptdate}
      {mfquoter.i stat}
      {mfquoter.i base_rpt}

      if bank1     = "" then bank1     = hi_char.
      {&APDRRP-P-TAG3}
      if nbr1      = 0  then nbr1      = 999999.
      {&APDRRP-P-TAG4}
      if apdate    = ?  then apdate    = low_date.
      if apdate1   = ?  then apdate1   = hi_date.
      if effdate   = ?  then effdate   = low_date.
      if effdate1  = ?  then effdate1  = hi_date.
      if clrdate   = ?  then clrdate   = low_date.
      if clrdate1  = ?  then clrdate1  = hi_date.
      if voideff   = ?  then voideff   = low_date.
      if voideff1  = ?  then voideff1  = hi_date.
      if due_date  = ?  then due_date  = low_date.
      if due_date1 = ?  then Due_date1 = hi_date.
      if acc1      = "" then acc1      = hi_char.
      if rptdate   = ?  then rptdate   = today.

     /* ADD BY SSMICHO - 20060224 - B */
      /*
      display rptdate with frame a.

      if base_rpt = "" then
      display

         getTermLabel("BASE",4) @ dispcurr
      with frame a.
      else display "" @ dispcurr with frame a.

      if (clrdate <> low_date or clrdate1 <> hi_date) and
         stat <> "" and stat <> "CANCEL" then do:
         {pxmsg.i &MSGNUM=2212 &ERRORLEVEL=2}
         /* CLEAR DATE RANGE ENTERED, BUT CANCEL */
         /* STATUS NOT SELECTED */
      end.
      if (voideff <> low_date or voideff1 <> hi_date) and
         stat <> "" and stat <> "VOID" then do:
         {pxmsg.i &MSGNUM=2213 &ERRORLEVEL=2}
         /* VOID DATE RANGE ENTERED,     */
         /* BUT VOID STATUS NOT SELECTED */
      end.

      if (stat <> " "  and ((index("VOID CANCEL OPEN", stat) = 0))) or
         stat = ? then
      do:
         {pxmsg.i &MSGNUM=3639 &ERRORLEVEL=3}
         /*Must be CANCEL, VOID, OPEN or blank */
         next-prompt stat.
         undo, retry.
      end.
      */
      /* ADD BY SSMICHO - 20060224 - E */
   end.

   /* ADD BY SSMICHO - 20060224 - B */
   /*
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
   {mfphead.i}
    */
   DEFINE VAR l_textfile AS CHAR NO-UNDO.
   /* ADD BY SSMICHO - 20060224 - E */
             v_bk_dftap_acct = "" .
             v_bk_dftap_sub  = "" .
             v_bk_dftap_cc   = "" .
             v_bk_desc       = "" .

   check_loop:
   for each ck_mstr where ck_bank >= bank and ck_bank <= bank1
         and ck_nbr >= nbr and ck_nbr <= nbr1
         and (stat = "" or
         ((stat = "OPEN" and ck_status = "")
         or (stat = "VOID" and ck_status = "VOID")
         or (stat = "CANCEL" and ck_status = "CANCEL")))
         and (base_rpt = "" or ck_curr = base_rpt)
      no-lock break by ck_bank by ck_nbr
      with frame c width 132 down:

      /* ADD BY SSMICHO - 20060224 - B */
       /*
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
        */
      /* ADD BY SSMICHO - 20060224 - E */

      find ap_mstr where ap_ref = ck_ref and ap_type = "CK"
      no-lock          no-error.

      /* USED l_print_rec TO PRINT THE BANK HEADER AND BANK TOTALS CORRECTLY. */

      if    (not available ap_mstr)
         or (ap_acct < acc or
             ap_acct > acc1)
      then
         l_print_rec = no.
      else
         l_print_rec = yes.

      /* ADD BY SSMICHO - 20060224 - B */
      /*
      if first(ck_bank) then display with frame c.
      */
      /* ADD BY SSMICHO - 20060224 - E */

      if first-of(ck_bank) then do:
         find bk_mstr where bk_code = string(ck_bank, "X(2)") no-lock
            no-error.
         /* ADD BY SSMICHO - 20060224 - B */
         /*
         put
            {gplblfmt.i
            &FUNC=getTermLabel(""BANK"",6)
            &CONCAT="': '"
            }
            string(ck_bank, "X(2)").
         */
         /* ADD BY SSMICHO - 20060224 - E */

         if available bk_mstr then do:
            /* ADD BY SSMICHO - 20060224 - B */
            /*
            put
               {gplblfmt.i
               &FUNC=getTermLabel(""DRAFTS_PAYABLE_ACCT"",19)
               &CONCAT="': '"
               }
               bk_dftap_acct
               space(1) bk_dftap_sub space(1)
               bk_dftap_cc
               space(2) bk_desc skip.
            */
             v_bk_dftap_acct = bk_dftap_acct.
             v_bk_dftap_sub  = bk_dftap_sub.
             v_bk_dftap_cc   = bk_dftap_cc.
             v_bk_desc       = bk_desc .
            /* ADD BY SSMICHO - 20060224 - E */

         end.
         /* ADD BY SSMICHO - 20060224 - B */
         /*
         put skip(1).
         */
         /* ADD BY SSMICHO - 20060224 - E */
         out_count = 0.
      end.

      if l_print_rec
      then do:

         /* FIND STATUS AT TIME OF REPORT */
         if ck_status = "" or
            (ck_status = "VOID" and ck_voiddate > rptdate) or
            (ck_status = "CANCEL" and ck_clr_date > rptdate)
         then ckstatus = "".
         else ckstatus = ck_status.

         /* FOR DRAFT MANAGEMENT, ALLOW SEARCH BY DUE DATE. CONVERT */
         /* AP_DUE_DATE FROM DATE STORED IN AP__QAD01.              */
         /* CONVERT AP__QAD01 TO AP_DUE_DATE*/
         if ap__qad01 > "" then do:
            {gprun.i ""gpchtodt.p"" "(input  ap__qad01,
                 output ap_due_date)"}

            if (ap_date >= apdate and ap_date <= apdate1)
               and (ap_effdate >= effdate and ap_effdate <= effdate1)
               and (ck_status <> "VOID" or
               (ck_voideff >= voideff and ck_voideff <= voideff1))
               and (ck_status <> "CANCEL" or ck_clr_date = ? or
               (ck_clr_date >= clrdate and ck_clr_date <= clrdate1))
               and (ap_due_date >= due_date and ap_due_date <= due_date1)
            then do:

               if  base_rpt =  ""
               and ck_curr  <> base_curr
               then
                  base_amt = ap_base_amt.
               else
                  base_amt = ap_amt.

               /* IF VOID OR CLOSED NOW, BUT WAS OPEN THEN FIND AMOUNT */
               /* (IE. THE CHECKS HAVING VOID DATE > REPORT DATE)      */
               /*                   OR                                 */
               /* CHECKS HAVING VOID STATUS                            */

               if  (ck_status <> ""
               and  ckstatus  =  "")
                or  ck_status =  "VOID"
               then do:

                  if ckstatus = ""
                  then
                     base_amt = 0.

                  for each ckd_det
                     fields (ckd_amt ckd_cur_amt ckd_ref ckd_voucher)
                     where ckd_ref = ck_ref
                  no-lock:

                     if  base_rpt    =  ""
                     and ck_curr     <> base_curr
                     and ckd_voucher <> ""
                     and can-find (first ap_mstr
                                      where ap_type =  "VO"
                                        and ap_ref  =  ckd_voucher
                                        and ap_curr <> ck_curr)
                     then
                        assign
                           base_amt = if ckstatus = ""
                                      then
                                         (base_amt - ckd_cur_amt)
                                      else
                                      if ck_status = "VOID"
                                      then
                                         (- ckd_cur_amt)
                                      else
                                         base_amt.
                     else
                        assign
                           base_amt = if ckstatus = ""
                                      then
                                         (base_amt - ckd_amt)
                                      else
                                      if ck_status = "VOID"
                                      then
                                         (- ckd_amt)
                                      else
                                         base_amt.
                  end. /* FOR EACH ckd_det */

                  if  base_rpt =  ""
                  and ck_curr  <> base_curr
                  then do:
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input  ck_curr,
                          input  base_curr,
                          input  ck_ex_rate,
                          input  ck_ex_rate2,
                          input  base_amt,
                          input  true,
                          output base_amt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0
                     then do:
                        {pxmsg.i
                           &MSGNUM=mc-error-number
                           &ERRORLEVEL=2}
                     end. /* IF mc-error-number <> 0 */
                  end. /* IF base_rpt = "" .. */
               end. /* IF (ck_status <> "" .. */

               accumulate base_amt (total by ck_bank).

               accumulate base_amt (total by ck_bank).
               accumulate ck_nbr (count by ck_bank).
               if ckstatus = "" then out_count = out_count + 1.
               name = "".

               find ad_mstr where ad_addr = ap_vend no-lock no-wait
               no-error.
               if available ad_mstr then name = ad_name.

               /* ADD BY SSMICHO - 20060224 - B */
               /*
               {&APDRRP-P-TAG5}
               display
                  ck_nbr       column-label {&apdrrp_p_15} format "999999"
                  ck_type
                  ap_vend
                  name
                  format "x(23)"

                  space(1)
                  (- base_amt) column-label {&apdrrp_p_11}
                  format "->>>>>,>>>,>>9.99"

                  space(1)
                  ap_acct
                  space(1)
                  ap_sub
                  space(1)
                  ap_date      column-label {&apdrrp_p_1}
                  space(1)
                  ap_effdate   column-label {&apdrrp_p_16}
                  space(1)
                  ap_due_date  column-label {&apdrrp_p_4}
                  space(1)
                  ck_clr_date  column-label {&apdrrp_p_8}
                  space(1)
                  ck_voideff
                  space(1)
                  ckstatus.
               {&APDRRP-P-TAG6}
                */
                 CREATE tta6apdrrp05.
                 ASSIGN
                     tta6apdrrp05_ck_bank = ck_bank
                     tta6apdrrp05_bk_dftap_acct = v_bk_dftap_acct
                     tta6apdrrp05_bk_dftap_sub  = v_bk_dftap_sub
                     tta6apdrrp05_bk_dftap_cc   = v_bk_dftap_cc
                     tta6apdrrp05_bk_dftap_desc = v_bk_desc 
                     tta6apdrrp05_ck_nbr          =  ck_nbr
                     tta6apdrrp05_ck_type         =  ck_type
                     tta6apdrrp05_ap_vend         =  ap_vend
                     tta6apdrrp05_name            =  name
                     tta6apdrrp05_base_amt        =  (- base_amt)
                     tta6apdrrp05_ap_acct         =  ap_acct
                     tta6apdrrp05_ap_sub          =  ap_sub
                     tta6apdrrp05_ap_date         =  ap_date
                     tta6apdrrp05_ap_effdate      =  ap_effdate
                     tta6apdrrp05_ap_due_date     =  ap_due_date
                     tta6apdrrp05_ck_clr_date     =  ck_clr_date
                     tta6apdrrp05_ck_voideff      =  ck_voideff
                     tta6apdrrp05_ckstatus        =  ckstatus
                     .

               /* ADD BY SSMICHO - 20060224 - E */

               {mfrpchk.i}
            end.
         end. /*AP__QAD01*/
      end. /* IF l_print_rec THEN DO */

      /* ADD BY SSMICHO - 20060224 - B */
      /*
      if last-of(ck_bank) then do:
         find bk_mstr where bk_code = string(ck_bank, "X(2)") no-lock
            no-error.
         disp_base_amt = accum total by ck_bank (base_amt).
         disp_base_amt = - (disp_base_amt).

         {&APDRRP-P-TAG7}

         put "-----------------" to 60
            skip
            {gplblfmt.i
            &FUNC=getTermLabel(""BANK_TOTALS"",35)
            &CONCAT=':'
            } to 39
            disp_base_amt format "->>>>>,>>>,>>9.99" to 60 .

         {&APDRRP-P-TAG8}

         if available bk_mstr then
         {&APDRRP-P-TAG9}
         put

            bk_curr to 65
            skip.
         {&APDRRP-P-TAG10}

         put
            {gplblfmt.i
            &FUNC=getTermLabel(""DRAFTS_OUTSTANDING"",18)
            &CONCAT="': '"
            }
            out_count format ">>>>>9" skip
            {gplblfmt.i
            &FUNC=getTermLabel(""TOTAL_DRAFTS"",20)
            &CONCAT="':       '"
            }
            accum count by ck_bank (ck_nbr) format ">>>>>9" skip(1).

      end.
      */
      /* ADD BY SSMICHO - 20060224 - E */

   end. /* CHECK_LOOP */

   /* ADD BY SSMICHO - 20060224 - B */
   /*
   {&APDRRP-P-TAG11}
   put "-----------------" to 60
      skip.
   {&APDRRP-P-TAG12}

   if base_rpt = "" then
   put base_curr + " " +
      getTermLabel("REPORT_TOTALS",13) + ' :' format "x(19)" to 39.
   else
   put base_rpt + " " +
      getTermLabel("REPORT_TOTALS",13) + ' :' format "x(19)" to 39.
   /**N07D** -------------- END - ADD CODE ----------------------------*/

   assign
      disp_base_amt = accum total (base_amt)
      disp_base_amt = - (disp_base_amt).

   {&APDRRP-P-TAG13}
   put disp_base_amt format "->>>>>,>>>,>>9.99" to 60
      skip(1).
   {&APDRRP-P-TAG14}
    */
   /* ADD BY SSMICHO - 20060224 - E */

/* ADD BY SSMICHO - 20060224 - B */
/*
   /* REPORT TRAILER */

   {mfrtrail.i}

end. /* REPEAT */
*/
/* ADD BY SSMICHO - 20060224 - E */

{wbrp04.i &frame-spec = a}
