/* apcrrp.p - AP CHECK RECONCILIATION REPORT                                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12.1.19 $                                                     */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 11/21/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 10/10/90   BY: mlb *D084*                */
/* REVISION: 5.0      LAST MODIFIED: 10/19/90   BY: mlb *B805*                */
/* REVISION: 7.0      LAST MODIFIED: 04/28/92   BY: mlv *F441*                */
/*                                   05/14/92   BY: mlv *F492*                */
/*                                   07/31/92   BY: mlv *F825*                */
/* REVISION: 7.3      LAST MODIFIED: 04/25/93   BY: jms *G934*                */
/* REVISION: 7.4      LAST MODIFIED: 11/29/93   BY: wep *H246*                */
/*                                   06/29/94   BY: bcm *H416*                */
/*                                   09/10/94   BY: rxm *FQ94*                */
/*                                   10/19/94   BY: had *H571*                */
/*                                   02/11/95   BY: ljm *G0DZ*                */
/*                                   07/07/95   BY: jzw *H0F8*                */
/*                                   10/31/95   BY: mys *G1BQ*                */
/* REVISION: 8.5      LAST MODIFIED: 12/24/95   by: mwd *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 04/04/96   by: jzw *G1LD*                */
/* REVISION: 8.6      LAST MODIFIED: 10/02/96   by: svs *K007*                */
/*                    LAST MODIFIED: 11/19/96   by: jpm *K020*                */
/* REVISION: 8.6      LAST MODIFIED: 10/20/97   by: mur *K12V*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 09/09/98   BY: *J2Z3* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 10/06/98   BY: *L09C* Santhosh Nair      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   by: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   by: *M0BD* Alfred Tan         */
/* Pre-86E commented code removed, view in archive revision 1.9               */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 05/27/99   BY: *J3FV* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/12/00   BY: *N07D* Antony Babu        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MH* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0W0* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 02/08/00   BY: *N0WP* Chris Green        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12.1.11     BY: Ed van de Gevel    DATE: 11/09/01  ECO: *N15N* */
/* Revision: 1.12.1.12     BY:  Ed van de Gevel   DATE: 04/17/02  ECO: *N1GR* */
/* Revision: 1.12.1.13     BY: Kedar Deherkar     DATE: 11/15/02  ECO: *N1WS* */
/* Revision: 1.12.1.14     BY: Kedar Deherkar     DATE: 03/24/03  ECO: *N2B5* */
/* Revision: 1.12.1.15     BY: Orawan S.          DATE: 05/03/03  ECO: *P0R6* */
/* Revision: 1.12.1.17     BY: Paul Donnelly (SB) DATE: 06/26/03  ECO: *Q00B* */
/* Revision: 1.12.1.18   BY: Jean Miller        DATE: 09/23/03  ECO: *Q03S* */
/* $Revision: 1.12.1.19 $  BY: Reena Ambavi    DATE: 11/30/04  ECO: *P2XC* */
/* SS - 090601.1 By: Neil Gao */
/* SS - 090619.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "090521.1"}
{cxcustom.i "APCRRP.P"}

/* DEFINE GPRUNP VARIABLES OUTSIDE OF FULL GUI INTERNAL PROCEDURES */
{gprunpdf.i "mcpl" "p"}

define variable detail_lines    as integer.
define variable dispcurr        as character format "x(4)".
define variable rptdate         as date label "As of Date".
define variable out_count       as integer.
{&APCRRP-P-TAG1}
/*V8-*/
define variable nbr             like ck_nbr.
define variable nbr1            like ck_nbr.
/*V8+*/
/*V8!
define variable nbr             as integer format ">999999"
label "Check".
define variable nbr1            as integer format ">999999".
*/
{&APCRRP-P-TAG2}
define variable bank            like ck_bank.
define variable bank1           like ck_bank.
define variable apdate          like ap_date
   label "Check Date".
define variable apdate1         like ap_date.
define variable stat            like ck_status initial "OPEN"
   label "Status (OPEN,VOID,CANCEL,<blank>)".
{&APCRRP-P-TAG15}
define variable name            like ad_name.
{&APCRRP-P-TAG16}
define variable out_amt         like ap_amt label "Outstanding Amount".
define variable base_amt        like ap_amt format "->>>>>,>>>,>>9.99".
define variable base_ckd_amt    like ap_amt format "->>>>>,>>>,>>9.99"
   no-undo.
define variable base_out        like out_amt.
define variable effdate         like ap_effdate
   label "Check Eff".
define variable effdate1        like ap_effdate.
define variable ckstatus        like ck_status.
define variable clrdate         like ck_clr_date
   label "Clear Eff".
define variable clrdate1        like ck_clr_date.
define variable voideff         like ck_voideff.
define variable voideff1        like ck_voideff.
define variable acc             like ap_acct.
define variable acc1            like ap_acct.
define variable base_rpt        like ap_curr.
define variable disp_base_amt   like ap_amt.
define variable remit-name      like ad_mstr.ad_name no-undo.
define variable mc-error-number like msg_nbr         no-undo.
define variable l_print_rec     like mfc_logical     no-undo.
/* SS 090619.1 - B */
define var sub 	like sb_sub.
define var sub1 like sb_sub.
/* SS 090619.1 - E */

find first gl_ctrl where gl_domain = global_domain no-lock.

{&APCRRP-P-TAG17}
form
   bank           colon 15   bank1    label "To" colon 49
   {&APCRRP-P-TAG13}
   nbr            colon 15   format "999999"
   nbr1           colon 49   format "999999" label "To"
   {&APCRRP-P-TAG14}
   apdate         colon 15   apdate1  label "To" colon 49
   effdate        colon 15   effdate1 label "To" colon 49
   clrdate        colon 15   clrdate1 label "To" colon 49
   voideff        colon 15   voideff1 label "To" colon 49
   acc            colon 15   acc1     label "To" colon 49
/* SS 090619.1 - B */
	 sub 						colon 15   sub1     colon 49
/* SS 090619.1 - B */
   skip(1)
   rptdate        colon 35
   stat           colon 35
   base_rpt       colon 35   dispcurr at 42 no-label
with frame a side-labels width 80.
{&APCRRP-P-TAG18}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   if bank1    = hi_char  then bank1    = "".
   if apdate   = low_date then apdate   = ?.
   if apdate1  = hi_date  then apdate1  = ?.
   if effdate  = low_date then effdate  = ?.
   if effdate1 = hi_date  then effdate1 = ?.
   if clrdate  = low_date then clrdate  = ?.
   if clrdate1 = hi_date  then clrdate1 = ?.
   if voideff  = low_date then voideff  = ?.
   if voideff1 = hi_date  then voideff1 = ?.
   if acc1     = hi_char  then acc1     = "".
/* SS 090619.1 - B */
	 if sub1     = hi_char  then sub1 =  "".
/* SS 090619.1 - B */

   if c-application-mode <> 'web' then
   update
      bank    bank1
      nbr     nbr1
      apdate  apdate1
      effdate effdate1
      clrdate clrdate1
      voideff voideff1
      acc     acc1
/* SS 090619.1 - B */
			sub     sub1
/* SS 090619.1 - B */
      rptdate
      stat base_rpt
   with frame a.

   {wbrp06.i &command = update &fields = "  bank bank1 nbr nbr1 apdate
        apdate1 effdate effdate1  clrdate clrdate1 voideff voideff1
        acc acc1 rptdate   stat
        base_rpt" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

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
      {mfquoter.i acc}
      {mfquoter.i acc1}
      {mfquoter.i rptdate}
      {mfquoter.i stat}
      {mfquoter.i base_rpt}

      if bank1    = "" then bank1    = hi_char.
      {&APCRRP-P-TAG3}
      {&APCRRP-P-TAG19}
      if nbr1     = 0  then nbr1     = 999999.
      {&APCRRP-P-TAG20}
      {&APCRRP-P-TAG4}
      if apdate   = ?  then apdate   = low_date.
      if apdate1  = ?  then apdate1  = hi_date.
      if effdate  = ?  then effdate  = low_date.
      if effdate1 = ?  then effdate1 = hi_date.
      if clrdate  = ?  then clrdate  = low_date.
      if clrdate1 = ?  then clrdate1 = hi_date.
      if voideff  = ?  then voideff  = low_date.
      if voideff1 = ?  then voideff1 = hi_date.
      if acc1     = "" then acc1     = hi_char.
      if rptdate  = ?  then rptdate  = today.
      display rptdate with frame a.

/* SS 090619.1 - B */
			if sub1 = "" then sub1 = hi_char.
/* SS 090619.1 - B */

      if base_rpt = "" then
         display
            getTermLabel("BASE",4) @ dispcurr
      with frame a.
      else
         display "" @ dispcurr with frame a.

      if (clrdate <> low_date or clrdate1 <> hi_date) and
         stat <> "" and stat <> "CANCEL"
      then do:
         /* CLEAR DATE RANGE ENTERED, BUT CANCEL STATUS NOT SELECTED */
         {pxmsg.i &MSGNUM=2212 &ERRORLEVEL=2}
      end.

      if (voideff <> low_date or voideff1 <> hi_date) and
         stat <> "" and stat <> "VOID"
      then do:
         /* VOID DATE RANGE ENTERED, BUT VOID STATUS NOT SELECTED */
         {pxmsg.i &MSGNUM=2213 &ERRORLEVEL=2}
      end.

      if (stat <> " "  and ((index("VOID CANCEL OPEN", stat) = 0))) or
         stat = ?
      then do:
         /*Must be CANCEL, VOID, OPEN or blank */
         {pxmsg.i &MSGNUM=3639 &ERRORLEVEL=3}
         next-prompt stat.
         undo, retry.
      end.

   end.

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

   check_loop:
   for each ck_mstr where ck_domain = global_domain and
                         (ck_bank >= bank and ck_bank <= bank1) and
                         (ck_nbr >= nbr and ck_nbr <= nbr1) and
                         (stat = "" or
                          (stat = "OPEN" and ck_status = "") or
                          (stat = "VOID" and ck_status = "VOID") or
                          (stat = "CANCEL" and ck_status = "CANCEL")) and
                         (base_rpt = "" or ck_curr = base_rpt)
   no-lock break by ck_bank by ck_nbr
   {&APCRRP-P-TAG21}
/* SS 090619.1 - B */
/*
   with frame c width 132 down:
*/
   with frame c width 160 down:
/* SS 090619.1 - E */
      {&APCRRP-P-TAG22}
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).

      find ap_mstr where ap_domain = global_domain and
                         ap_ref = ck_ref and
                         ap_type = "CK"
      no-lock no-error.

      /* USED l_print_rec TO PRINT THE BANK HEADER AND BANK TOTALS CORRECTLY. */
      if    (not available ap_mstr)
         or (ap_acct   < acc or
             ap_acct   > acc1)
/* SS 090619.1 - B */
				 or (ap_sub    < sub or
				     ap_sub    > sub1)
/* SS 090619.1 - B */
         or (ap__qad01 > "")   /* EXCLUDE DRAFTS */
      then
         l_print_rec = no.
      else
         l_print_rec = yes.

      if first(ck_bank) then
         display with frame c.

      if first-of(ck_bank) then do:

         find bk_mstr where bk_domain = global_domain and
                            bk_code = string(ck_bank, "X(2)")
         no-lock no-error.

         put
            {gplblfmt.i &FUNC=getTermLabel(""BANK"",6) &CONCAT="': '"}
            string(ck_bank, "X(2)").

         if available bk_mstr then do:
            put
               "  "
               {gplblfmt.i &FUNC=getTermLabel(""ACCOUNT"",14) &CONCAT="': '"}
               bk_acct
               space(1) bk_sub space(1)
               bk_cc space(2)
               bk_desc space(2)
               {gplblfmt.i &FUNC=getTermLabel(""CURRENCY"",6) &CONCAT="': '"}
               bk_curr skip.
         end.
         put skip(1).
         out_count = 0.
      end.

      if l_print_rec
      then do:

         /* FIND STATUS AT TIME OF REPORT */
         if ck_status = "" or
            (ck_status = "VOID" and ck_voiddate > rptdate) or
            (ck_status = "CANCEL" and ck_clr_date > rptdate)
         then
            ckstatus = "".
         else
            ckstatus = ck_status.

         if (ap_date >= apdate and ap_date <= apdate1) and
            (ap_effdate >= effdate and ap_effdate <= effdate1) and
            (ck_status <> "VOID" or
            (ck_voideff >= voideff and ck_voideff <= voideff1)) and
            (ck_status <> "CANCEL" or ck_clr_date = ? or
            (ck_clr_date >= clrdate and ck_clr_date <= clrdate1))
         then do:

            out_amt = 0.
            if ck_status = "" then
               out_amt = ap_amt.

            find first bk_mstr where bk_domain = global_domain and
                                     bk_code = string(ck_bank, "X(2)")
            no-lock no-error.

            assign
               base_amt = ap_amt
               base_out = out_amt.

            /* IF VOID OR CLOSED NOW, BUT WAS OPEN THEN FIND AMOUNT */
            if ck_status <> "" and ckstatus = "" then do:
               assign
                  base_amt = 0
                  base_out = 0.
               for each ckd_det where ckd_domain = global_domain and
                                      ckd_ref = ck_ref
               no-lock:
                  assign
                     base_amt = base_amt - ckd_amt
                     base_out = base_out - ckd_amt.
               end.
            end.

            else do:
               /*IF VOID, DISPLAY ORIGINAL AMOUNT*/
               if ck_status = "VOID" then do:
                  base_amt = 0.
                  for each ckd_det where ckd_domain = global_domain
                                     and ckd_ref = ck_ref
                  no-lock:
                     base_amt = base_amt - ckd_amt.
                  end.
               end.
            end.

            {&APCRRP-P-TAG23}
            /* FOR FOREIGN CURRENCY CHECKS, CALCULATE THE CHECK     */
            /* DETAIL IN BASE AND THEN TOTAL                        */
            if base_rpt = "" and ck_curr <> base_curr then do:

               base_amt = 0.
               for each ckd_det
                  fields(ckd_domain ckd_amt ckd_cur_amt ckd_ref ckd_voucher)
                  where ckd_domain = global_domain and
                        ckd_ref = ck_ref
               no-lock:

                  /* THE BELOW CONDITION WILL BE TRUE ONLY AFTER */
                  /* BCC FOR FOREIGN CURRENCY VOUCHERS PAID IN   */
                  /* BASE CURRENCY BEFORE BCC.                   */

                  if ckd_voucher <> ""
                  and can-find (first ap_mstr where ap_domain = global_domain
                                                and ap_type =  "VO"
                                                and ap_ref  =  ckd_voucher
                                                and ap_curr <> ck_curr)
                  then
                     base_ckd_amt = ckd_cur_amt.
                  else
                     base_ckd_amt = ckd_amt.

                  /* CHANGED FIFTH   PARAMETER base_amt TO ckd_amt      */
                  /* CHANGED SEVENTH PARAMETER base_amt TO base_ckd_amt */
                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input ck_curr,
                       input base_curr,
                       input ck_ex_rate,
                       input ck_ex_rate2,
                       input base_ckd_amt,
                       input true,
                       output base_ckd_amt,
                       output mc-error-number)"}.
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  base_amt = base_amt - base_ckd_amt.

               end. /* FOR EACH ckd_det */

               /* ck_status = "" -> CHECKS WHICH ARE NOT VOID OR CLOSED */
               /* ck_status <> "" and ckstatus = "" ->                  */
               /* CHECKS FOR WHICH VOID DATE > REPORT DATE              */

               if ck_status = ""
               then
                  base_out = ap_base_amt.

               else
               if  ck_status <> ""
               and ckstatus  =  ""
               then
                  base_out = base_amt.

            end.

            accumulate base_amt (total by ck_bank).
            accumulate base_out (total by ck_bank).

            accumulate base_amt (total by ck_bank).
            accumulate base_out (total by ck_bank).
            accumulate ck_nbr (count by ck_bank).

            if ckstatus = "" then out_count = out_count + 1.

            name = "".

            find ad_mstr where ad_domain = global_domain and
                               ad_addr = ap_vend
            no-lock no-wait no-error.

            if available ad_mstr then name = ad_name.

            remit-name = "".
            {gprun.i ""apmisccr.p""
               "(input ck_mstr.ck_ref,
                 output remit-name)"}
            if remit-name <> "" then name = remit-name.

            {&APCRRP-P-TAG5}
            {&APCRRP-P-TAG24}

/* SS 090619.1 - B */
						find first sb_mstr where sb_domain = global_domain and sb_sub = ap_sub no-lock no-error.
/* SS 090619.1 - E */
            
            display
               ck_nbr format "999999"
               ck_type
               ap_vend
               name
               space(2)
               (- base_amt)
/* SS 090619.1 - B */
/*
               column-label "Check Amount" format "->>>>>,>>>,>>9.99"
*/
               column-label "支票金额" format "->>>>>,>>>,>>9.99"
/* SS 090619.1 - E */
               space(2)
/* SS 090619.1 - B */
/*
               ap_acct
               space(2)
*/
							 ap_sub
							 space(2)
							 sb_desc when avail sb_mstr
/* SS 090619.1 - E */
               ap_date      column-label "Ck Date"
               space(2)
               ap_effdate   column-label "Ck Eff"
               space (2)
               ck_clr_date  column-label "Clr Eff"
               space(2)
               ck_voideff
               space(3)
               ckstatus.

            {&APCRRP-P-TAG25}
            {&APCRRP-P-TAG6}
            {mfrpchk.i}
         end.

      end. /* IF l_print_rec THEN DO */

      if last-of(ck_bank) then do:

         disp_base_amt = accum total by ck_bank (base_amt).
         disp_base_amt = - (disp_base_amt).
         {&APCRRP-P-TAG7}
         {&APCRRP-P-TAG26}
         put "-----------------" to 66
            skip
            {gplblfmt.i &FUNC=getTermLabel(""BANK_TOTALS"",20)
                        &CONCAT=':'} to 45
            disp_base_amt format "->>>>>,>>>,>>9.99" to 66
            skip.

         {&APCRRP-P-TAG27}
         {&APCRRP-P-TAG8}

         put
            {gplblfmt.i &FUNC=getTermLabel(""CHECKS_OUTSTANDING"",18)
                        &CONCAT="': '"}
            out_count format ">>>>>9" skip
            {gplblfmt.i &FUNC=getTermLabel(""TOTAL_CHECKS"",18)
                        &CONCAT="':       '"}
            accum count by ck_bank (ck_nbr) format ">>>>>9"
            skip(1).

      end.

   end. /* CHECK_LOOP */

   {&APCRRP-P-TAG9}
   {&APCRRP-P-TAG28}

   put "-----------------" to 66
      skip.

   {&APCRRP-P-TAG29}
   {&APCRRP-P-TAG10}

   if base_rpt = "" then
   put base_curr + " " + getTermLabel("REPORT_TOTALS",13) + ' :'
      format "x(19)" to 45.
   else
   put base_rpt + " " + getTermLabel("REPORT_TOTALS",13) + ' :'
      format "x(19)" to 45.

   assign
      disp_base_amt = accum total (base_amt)
      disp_base_amt = - (disp_base_amt).
   {&APCRRP-P-TAG11}
   {&APCRRP-P-TAG30}
   put disp_base_amt format "->>>>>,>>>,>>9.99" to 66
      skip(1).

   {&APCRRP-P-TAG31}
   {&APCRRP-P-TAG12}

   /* REPORT TRAILER */
/* SS 090601.1 - B */
/*
   {mfrtrail.i}
*/	
		put skip(1).
		put "       制表:_______________                        审批:_______________ " skip.
		
		{mfreset.i}
		{mfgrptrm.i}
/* SS 090601.1 - E */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
