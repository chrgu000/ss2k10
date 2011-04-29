/* txmeth11.p - qad REGRESSIVE TAX-INCLUDED CALCULATION ROUTINE            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.10.2.8 $                                                   */
/*V8:ConvertMode=Maintenance                                               */
/* Revision: 7.4      CREATED:       03/23/94   By: bcm  *H301*            */
/*                                   09/20/94   By: bcm  *H531*            */
/*                                   09/20/94   By: bcm  *H610*            */
/*                                   02/23/95   By: jzw  *H0BM*            */
/* Revision: 8.5      CREATED:       07/05/95   By: taf  *J053*            */
/*                                   05/08/96   By: jzw  *H0KY*            */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   By: jzw  *K008*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/*                                   11/25/96   By: jzw  *K01X*            */
/*                                   11/10/97   BY: *K197* Jeff Wootton    */
/* REVISION: 8.6E     LAST MODIFIED: 04/22/98   BY: *J2D9* Sachin Shah     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 04/27/99   BY: *J3DV* Santosh Rao     */
/* REVISION: 8.6E     LAST MODIFIED: 08/20/99   BY: *J3KY* Sachin Shinde   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb             */
/* REVISION: 9.1      LAST MODIFIED: 10/11/00   BY: *L12X* Shilpa Athalye  */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0W4* BalbeerS Rajput */
/* Old ECO marker removed, but no ECO header exists *F0PN*                 */
/* Revision: 1.10.2.7   BY: Samir Bavkar      DATE: 07/08/02  ECO: *P0B0*  */
/* $Revision: 1.10.2.8 $ BY: Ashish Maheshwari DATE: 10/16/02  ECO: *N1W5*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/***************************************************************************/
/*!
    txmeth11.p  Regressive Tax-Included Calculation Routine

    Originally designed to meet Brazilian requirements for tax included.
    The tax rate represents the percentage of total price (price + tax)
    as opposed to the percentage on top of original (derived) priced.

    Ex:

        Standard Taxes
        Total Price: $125   Tax Rate: 25%   Tax Base: $100  Taxes: $25
        (25% of $100 = $25)

        Regressive Taxes
        Total Price: $125   Tax Rate: 20%   Tax Base: $100  Taxes: $25
        (20% of $125 = $25)
*/
/*!
    NOTE: ANY CHANGES MADE TO THIS PROGRAM SHOULD ALSO BE MADE TO
    ALL TXMETH*.P PROGRAMS
*/
/***************************************************************************/

{mfdeclre.i}
{cxcustom.i "TXMETH11.P"}

define input        parameter tax_code     like tx2_tax_code no-undo.
define input        parameter tax_round    like txed_round no-undo.
define input        parameter amt_curr     like tx2d_curr no-undo.
define input        parameter tax_in       like sod_tax_in no-undo.
define input        parameter tr_type      like tx2d_tr_type no-undo.
define input        parameter ref          like tx2d_ref no-undo.
define input        parameter nbr          like tx2d_nbr no-undo.
define input        parameter line         like tx2d_line no-undo.
define input        parameter trlr_code    like tx2d_trl no-undo.
define input        parameter tax_line     like tx2d_line no-undo.
define input        parameter adj_factor   like mfc_decimal no-undo.
define input-output parameter tot_amt      like tx2d_totamt no-undo.
define output       parameter taxes        like tx2d_totamt no-undo.
define output       parameter adj_amt      like tx2d_totamt no-undo.
define output       parameter recoverable  like tx2d_totamt no-undo.
define output       parameter tax_base_amt like tx2d_totamt no-undo.
define output       parameter ntax_amt     like tx2d_totamt no-undo.

define variable     start_tot   like tx2d_totamt no-undo.
define variable base_percent    like mfc_dec format "->>9.99<<%"
                                label "Base Percent" no-undo.
define variable ar_ap           as logical initial true /*AR*/ no-undo.
define variable found_base_tx2d like mfc_logical no-undo.

{gpcrnd.i}

/* FIND TAX RATE MASTER */

for first tx2_mstr
   fields (tx2_apr_use tx2_ara_use tx2_base tx2_max tx2_min
           tx2_pct_recv tx2_tax_code tx2_tax_pct)
   where tx2_tax_code = tax_code
no-lock:
end.

if not available(tx2_mstr) then do:
   {pxmsg.i &MSGNUM=872 &ERRORLEVEL=4} /* TAX MASTER DOES NOT EXIST */
end.

/* CURRENCY ISSUES FOR TAXABLE AMOUNT? */

/* CALCULATE */
if tx2_tax_pct = 0 then
   assign
      taxes        = 0
      tax_base_amt = tot_amt
      ntax_amt     = 0.

else do:
   assign
      start_tot = tot_amt
      /* CHECK TAX BASE */
      tax_base_amt = tot_amt
      ntax_amt = 0.
   if tx2_base > "" then do:

      for first code_mstr
         fields (code_cmmt code_fldname code_value)
         where code_fldname = "txb_base" and
               code_value = tx2_base no-lock:
      end.

      if available(code_mstr) then do:

         for each txbd_det where txbd_base = tx2_base:

            found_base_tx2d = no.

            base_tx2d:
            for each tx2d_det
               where tx2d_ref = ref
                 and tx2d_nbr = nbr
                 and tx2d_trl = trlr_code
                 and tx2d_tr_type = tr_type
            exclusive-lock:

               if tax_line <> 0 /* TAX_BY_LINE = YES */
                  and tx2d_line <> tax_line /* NOT SAME LINE */
               then
                  next base_tx2d.  /* NOT WANTED */

               if tx2d_tax_type <> txbd_tax_type  /* NOT SAME TAX TYPE */
               then
                  next base_tx2d.  /* NOT WANTED */

               found_base_tx2d = yes.

               if not tx2d_tax_in
                  /* FIRST TAX WAS NOT TAX-INCLUDED */
                  or (tx2d_tax_in and not tax_in)
                  /* FIRST TAX WAS TAX-INCLUDED, */
                  /* THIS TAX IS NOT TAX-INCLUDED, */
                  /* SO NEED TO ADD TAX TO THE BASE AMOUNT. */
               then
                  /* UPDATE tx2d__qadd02[1] AS TO CONTAIN TAX AMOUNT OF    */
                  /* CURRENT tx2d_det RECORD AND STORE IT IN               */
                  /*  tx2d__qadd02[2] TO USE IN SUBSEQUENT LINE OF ORDER   */
                  /* TO CALCULATE TAX AMOUNT WITH SAME taxtype IF REQUIRED */
                  assign
                     tx2d__qadd02[1] = tx2d_cur_tax_amt - tx2d__qadd02[1]
                                       + tx2d__qadd02[2]
                     tax_base_amt    = tax_base_amt + tx2d__qadd02[1]
                     tx2d__qadd02[2] = tx2d__qadd02[1].

            end. /* BASE_TX2D: */

            if found_base_tx2d = no
            then do:
               /* TAX DETAIL RECORD FOR */
               /* TAX BASE TAX TYPE DOES NOT EXIST {pxmsg.i &MSGNUM=868 &ERRORLEVEL=2}*/
               
            end.
         end. /* FOR EACH TXBD_DET */

         /* MULTIPLY TOTAL BY PERCENTAGE */
         assign
            base_percent = decimal(substring(code_cmmt,1,9))
            ntax_amt     = tax_base_amt * (1 - base_percent / 100)
            tax_base_amt = tax_base_amt * base_percent / 100.

      end. /* IF AVAILABLE (CODE_MSTR) */
      else do:
         {pxmsg.i &MSGNUM=866 &ERRORLEVEL=2} /* TAX BASE DOES NOT EXIST */
      end.
   end. /* IF TX2_BASE > "" */

   /* CHECK MIN/MAX AMOUNTS */
   if (tx2_min > 0)
   and (tax_base_amt > 0)
   and (tax_base_amt < tx2_min)
   then
      assign
         ntax_amt     = ntax_amt + tax_base_amt - tx2_min
         tax_base_amt = tx2_min.
   else
   if (tx2_max > 0
   and tax_base_amt > tx2_max)
   then
      assign
         ntax_amt     = ntax_amt + tax_base_amt - tx2_max
         tax_base_amt = tx2_max.

   /* CALCULATE */
   taxes = tax_base_amt * (tx2_tax_pct / 100) * adj_factor.

   /*NOTE: The adj_factor value is used to allow special case calculations
           such as VAT Discount At Payment or Invoice adjustments.  */

   /* APPLY ROUNDING */
   run gpcrnd (input-output taxes,input tax_round).

   /* DERIVE OUTPUT VALUES */

   /* FORCE TAX INCLUDED AMOUNTS TO MATCH TOTAL AMOUNT */
   if tax_in then do:
      /* CHANGED THE FOLLOWING FOR REGRESSIVE TAXES, WHICH DEFINE  */
      /* INCLUDED TAXES AS CALCULATED ON THE VALUE PLUS THE TAX... */

      tot_amt = start_tot.
      if (taxes + tax_base_amt <> tot_amt + taxes) then
         assign tax_base_amt = tot_amt.
   end.

   /* HANDLE AP Reverse & AR Absorbed Amounts */

   {&TXMETH11-P-TAG1}
   ar_ap = lookup(tr_type,
        "20,21,22,23,24,25,26,27,28,29,32,40,41,42,43,44,45,46,47,48") = 0.

   {&TXMETH11-P-TAG2}

   if ar_ap and tx2_ara_use
   then
      assign adj_amt = - taxes.
   else if not ar_ap then do:
      if tx2_apr_use then
         assign adj_amt = - taxes.
      if tx2_pct_recv <> 0 then do:
         recoverable = (( taxes) * (tx2_pct_recv / 100)).
         run gpcrnd (input-output recoverable,input tax_round).
      end.
   end.

end.
