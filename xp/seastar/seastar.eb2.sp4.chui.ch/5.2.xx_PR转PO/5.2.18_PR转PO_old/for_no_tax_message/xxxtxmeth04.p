/* txmeth04.p - qad TAX CALCULATION ROUTINE WITH TAX BASE PERCENT <> 100    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.4 $                                                         */
/*V8:ConvertMode=Maintenance                                                */
/* Revision: 9.1      CREATED:       08/24/00   By: *N0D0* Santosh Rao      */
/* $Revision: 1.4 $    BY: Samir Bavkar        DATE: 07/07/02  ECO: *P0B0*  */
/* $Revision: 1.4 $    BY: Ashish Maheshwari   DATE: 10/16/02  ECO: *N1W5*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/***************************************************************************/
/*!
    txmeth04.p  qad Generic Tax Calculation routine
                receives the following parameters
        input   tax_code        tx2_tax_code    Tax Code
        input   tax_round       txed_round      Rounding Method
        input   tax_curr        tx2d_curr       Tax Currency
        input   tax_in          sod_tax_in      Tax Included In Price
        input   tr_type         tx2d_tr_type    Tax Transaction Type
        input   ref             tx2d_ref        Document Reference
        input   nbr             tx2d_nbr        Second Reference
        input   line            tx2d_line       Line Number
        input   trlr_code       trl_code        Trailer_code
        input   tax_line        tx2d_line       Tax Line Number
        input   adj_factor      mfc_decimal     Adjustment factor
        input   tot_amt         tx2d_totamt     Total Amount
        input   adjust_factor   mfc_decimal     Flexible Adjustment Factor
        output  taxes           mfc_decimal     Taxes
        output  adj_amt         tx2d_totamt     Adjustment Amount
        output  recoverable     tx2d_totamt     Recoverable Amount
        output  tax_base_amt    mfc_decimal     Taxable Base Amount
        output  ntax_amt        mfc_decimal     Non-Taxable Amount

*/
/*!
    NOTE: ANY CHANGES MADE TO THIS PROGRAM SHOULD ALSO BE MADE TO
    ALL TXMETH*.P PROGRAMS
*/
/***************************************************************************/

{mfdeclre.i}

define input        parameter tax_code     like tx2_tax_code no-undo.
define input        parameter tax_round    like txed_round   no-undo.
define input        parameter amt_curr     like tx2d_curr    no-undo.
define input        parameter tax_in       like sod_tax_in   no-undo.
define input        parameter tr_type      like tx2d_tr_type no-undo.
define input        parameter ref          like tx2d_ref     no-undo.
define input        parameter nbr          like tx2d_nbr     no-undo.
define input        parameter line         like tx2d_line    no-undo.
define input        parameter trlr_code    like tx2d_trl     no-undo.
define input        parameter tax_line     like tx2d_line    no-undo.
define input        parameter adj_factor   like mfc_decimal  no-undo.
define input-output parameter tot_amt      like tx2d_totamt  no-undo.
define output       parameter taxes        like tx2d_totamt  no-undo.
define output       parameter adj_amt      like tx2d_totamt  no-undo.
define output       parameter recoverable  like tx2d_totamt  no-undo.
define output       parameter tax_base_amt like tx2d_totamt  no-undo.
define output       parameter ntax_amt     like tx2d_totamt  no-undo.

define variable start_tot       like tx2d_totamt        no-undo.
define variable base_percent    like mfc_dec format "->>9.99<<%"
                                label "Base Percent"    no-undo.
define variable ar_ap           as logical initial true no-undo.
define variable found_base_tx2d like mfc_logical        no-undo.
define variable l_tmp_amt       like tx2d_totamt        no-undo.
define variable mc-error-number like msg_nbr            no-undo.

/* FIND TAX RATE MASTER */
for first tx2_mstr
   fields (tx2_apr_use tx2_ara_use tx2_base tx2_max tx2_min
           tx2_pct_recv tx2_tax_code tx2_tax_pct)
   where tx2_tax_code = tax_code no-lock:
end. /* FOR FIRST TX2_MSTR */

if not available(tx2_mstr) then do:
   /* TAX MASTER DOES NOT EXIST */
   {pxmsg.i &MSGNUM=872 &ERRORLEVEL=4}
end. /* IF NOT AVAILABLE(TX2_MSTR) */

/* CURRENCY ISSUES FOR TAXABLE AMOUNT? */

/* CALCULATE */
if tx2_tax_pct = 0 then
   assign
      taxes        = 0
      tax_base_amt = tot_amt
      ntax_amt     = 0.
else do:
   if tx2_base > "" then
      for first code_mstr
         fields(code_cmmt code_fldname code_value)
         where code_fldname = "txb_base" and
         code_value   = tx2_base no-lock:
      end. /* FOR FIRST CODE_MSTR */

   assign
      start_tot    = tot_amt
      l_tmp_amt    = start_tot
      base_percent = if available code_mstr then
                        decimal(substring(code_cmmt,1,9))
                     else 100
      tax_base_amt = tot_amt.

   /* CHECK TAX INCLUDED */
   if tax_in then
      assign
         tot_amt      = tot_amt / (1 + ((base_percent / 100) *
                        (tx2_tax_pct / 100)))
         tax_base_amt = tot_amt
         l_tmp_amt    = tot_amt.

   /* CHECK TAX BASE */
   assign
      tax_base_amt = tot_amt
      ntax_amt     = 0.

   if tx2_base > "" then do:

      if available(code_mstr) then do:
         for each txbd_det
               fields(txbd_base txbd_tax_type)
               where txbd_base = tx2_base no-lock:

            found_base_tx2d = no.

            base_tx2d:
            for each tx2d_det
               where tx2d_ref     = ref
                 and tx2d_nbr     = nbr
                 and tx2d_trl     = trlr_code
                 and tx2d_tr_type = tr_type
               exclusive-lock:

               if tax_line  <> 0 and
                  tx2d_line <> tax_line then
                  next base_tx2d.

               if tx2d_tax_type <> txbd_tax_type then
                  next base_tx2d.

               found_base_tx2d = yes.
               if not tx2d_tax_in or
                  (tx2d_tax_in and not tax_in) then
                  assign
                     /* UPDATE tx2d__qadd02[1] AS TO CONTAIN TAX AMOUNT OF    */
                     /* CURRENT tx2d_det RECORD AND STORE IT IN               */
                     /*  tx2d__qadd02[2] TO USE IN SUBSEQUENT LINE OF ORDER   */
                     /* TO CALCULATE TAX AMOUNT WITH SAME taxtype IF REQUIRED */
                     tx2d__qadd02[1] = tx2d_cur_tax_amt - tx2d__qadd02[1]
                                       + tx2d__qadd02[2]
                     tax_base_amt    = tax_base_amt + tx2d__qadd02[1]
                     l_tmp_amt       = l_tmp_amt + tx2d__qadd02[2]
                     tx2d__qadd02[2] = tx2d__qadd02[1].

            end. /* BASE_TX2D: */

            if found_base_tx2d = no then do:
               /* TAX DETAIL RECORD FOR TAX BASE TAX TYPE */
               /* DOES NOT EXIST      {pxmsg.i &MSGNUM=868 &ERRORLEVEL=2}                    */
               
            end. /* IF FOUND_BASE_TX2D = NO */
         end. /* FOR EACH TXBD_DET */

         /* MULTIPLY TOTAL BY PERCENTAGE */
         assign
            tax_base_amt = tax_base_amt * base_percent / 100
            ntax_amt     = l_tmp_amt - tax_base_amt .

      end. /* IF AVAILABLE (CODE_MSTR) */
      else do:
         /* TAX BASE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=866 &ERRORLEVEL=2}
      end. /* ELSE DO */
   end. /* IF TX2_BASE > "" */

   /* CHECK MIN/MAX AMOUNTS */
   if (tx2_min > 0)      and
      (tax_base_amt > 0) and
      (tax_base_amt < tx2_min) then
      assign
         ntax_amt     = ntax_amt + tax_base_amt - tx2_min
         tax_base_amt = tx2_min.
   else
   if (tx2_max > 0 and
      tax_base_amt > tx2_max) then
      assign
         ntax_amt     = ntax_amt + tax_base_amt - tx2_max
         tax_base_amt = tx2_max.

   /* CALCULATE */
   taxes = tax_base_amt * (tx2_tax_pct / 100) * adj_factor.

   /* NOTE: THE ADJ_FACTOR VALUE IS USED TO ALLOW SPECIAL CASE  */
   /* CALCULATIONS SUCH AS VAT DISCOUNT AT PAYMENT OR INVOICE   */
   /* ADJUSTMENTS.                                              */

   /* APPLY ROUNDING */
   /* DETERMINE ROUNDING METHOD */

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output taxes,
        input tax_round,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end. /* IF MC-ERROR-NUMBER <> 0 THEN */

   /* DERIVE OUTPUT VALUES */

   /* FORCE TAX INCLUDED AMOUNTS TO MATCH TOTAL AMOUNT */
   if tax_in then do:
      tot_amt = start_tot.
      if (taxes + tax_base_amt + ntax_amt <> tot_amt) then
         tax_base_amt = tot_amt - taxes - ntax_amt.
   end. /* IF TAX_IN */

   /* ADD TRANSACTION TYPES FOR LOGISTICS CHARGES(40-48) */
   /* HANDLE AP Reverse & AR Absorbed Amounts */
   ar_ap = lookup(tr_type,
         "20,21,22,23,24,25,26,27,28,29,32,40,41,42,43,44,45,46,47,48") = 0.

   if ar_ap and
      tx2_ara_use then
      adj_amt = - taxes.
   else
   if not ar_ap then do:
      if tx2_apr_use then
         adj_amt = - taxes.
      if tx2_pct_recv <> 0 then do:
         recoverable = (( taxes) * (tx2_pct_recv / 100)).
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output recoverable,
              input tax_round,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF MC-ERROR-NUMBER <> 0 THEN */
      end. /* IF TX2_PCT_RECV <> 0 */
   end. /* ELSE IF NOT AR_AP THEN */
end. /* ELSE IF TX2_TAX_PCT <> 0 AND .. */
