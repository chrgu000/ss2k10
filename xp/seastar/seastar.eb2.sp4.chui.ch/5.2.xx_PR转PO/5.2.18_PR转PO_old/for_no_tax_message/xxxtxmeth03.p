/* txmeth03.p - qad EXTERNAL TAX CALCULATION ROUTINE                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                          */
/*V8:ConvertMode=NoConvert                                                    */
/******************************************************************************/
/* REVISION: 9.1      LAST MODIFIED: 09/07/99   BY: *N02K* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 09/28/99   BY: *N02S* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/19/99   BY: *N049* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Revision: 1.12     BY: Jean Miller          DATE: 05/15/02  ECO: *P05V*  */
/* $Revision: 1.13 $    BY: Samir Bavkar          DATE: 07/07/02  ECO: *P0B0*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/***************************************************************************/
/*!
    txmeth03.p  qad External Tax Calculation routine
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
        output  tax_base_amt    mfc_decimal     Taxable Base Amount
        output  ntax_amt        mfc_decimal     Non-Taxable Amount

    NOTE: ANY CHANGES MADE TO THIS PROGRAM SHOULD ALSO BE MADE TO
    ALL TXMETH*.P PROGRAMS
*/

{mfdeclre.i}

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

define variable lgData as logical no-undo.
define variable found as logical no-undo.
define variable tax_pct as decimal no-undo.
define variable ar_ap   as logical initial true no-undo.


{gpcrnd.i}
/* FIND TAX RATE MASTER */
for last tx2_mstr
   fields (tx2_pt_taxc tx2_tax_usage tx2_tax_code tx2_tax_type tx2_ara_use)
   where tx2_tax_code = tax_code
no-lock: end.

if not available(tx2_mstr) then do:
   {pxmsg.i &MSGNUM=872 &ERRORLEVEL=4} /* TAX MASTER DOES NOT EXIST */
   return "99".
end.

/* see if any tax data available */
/* When calculating "11" records, look for a "13" or a "16" record */
/* than matches." */
/* When calculating "13" records, look for a "11" or a "16" record */
/* than matches." */
/* When calculating "16" records, look for a "13" or a "11" record */
/* than matches." */
/* "18" records are different.  They can only be calculated when the */
/* Logistics imported document is present, that is while the document*/
/* is being processed. If not available, give an error. */

/* When looking for data in multiple records, check that */
/* the taxable amount in the the record is not 0. Accept a 0 */
/* on the second look because if a tax is present, we want to */
/* set an error if we can't use the value. */

/* For "11" "13" "14", ref = so_nbr, nbr = "" */
/* For "16" ref = inv nbr, nbr = so_nbr */

/* An "11" record is requested */
if tr_type = "11" then do:
   for first tx2d_det
      fields (tx2d_cur_tax_amt tx2d_totamt)
      where tx2d_nbr = nbr and
      tx2d_ref = ref and
      tx2d_line = line and
      tx2d_taxc = tx2_pt_taxc and
      tx2d_tax_usage = tx2_tax_usage and
      tx2d_trl = trlr_code and
      tx2d_tax_type = tx2_tax_type and
      tx2d_tr_type = "13"
   no-lock: end.
end.

/* A "13" record is requested */
/* Or a "14" record is requested. */
else if tr_type = "13" or tr_type = "14" then do:

   for first tx2d_det
      fields (tx2d_cur_tax_amt tx2d_totamt)
      where tx2d_nbr = nbr and
      tx2d_ref = ref and
      tx2d_line = line and
      tx2d_trl = trlr_code and
      tx2d_tax_type = tx2_tax_type and
      tx2d_taxc = tx2_pt_taxc and
      tx2d_tax_usage = tx2_tax_usage and
      tx2d_tr_type = "11"
   no-lock: end.

   if not available tx2d_det and tr_type="14" then do:
      /* Try the original Sales Order for values */
      for first tx2d_det
         fields (tx2d_cur_tax_amt tx2d_totamt)
         where tx2d_nbr = "" and
         tx2d_ref = nbr and
         tx2d_line = line and
         tx2d_taxc = tx2_pt_taxc and
         tx2d_tax_usage = tx2_tax_usage and
         tx2d_trl = trlr_code and
         tx2d_tax_type = tx2_tax_type and
         tx2d_tr_type = "11"
      no-lock: end.
   end.

end.

/* A "16" record is requested */
else if tr_type = "16" then do:

   /* Look for invoiced non-zero values */
   for first tx2d_det
      fields (tx2d_cur_tax_amt tx2d_totamt)
      where tx2d_nbr = "" and
      tx2d_ref = nbr and
      tx2d_line = line and
      tx2d_trl = trlr_code and
      tx2d_tax_type = tx2_tax_type and
      tx2d_taxc = tx2_pt_taxc and
      tx2d_tax_usage = tx2_tax_usage and
      tx2d_tr_type = "13" and
      tx2d_totamt <> 0
   no-lock: end.

   if not available tx2d_det then do:
      /* Try the original Sales Order for values */
      for first tx2d_det
         fields (tx2d_cur_tax_amt tx2d_totamt)
         where tx2d_nbr = "" and
         tx2d_ref = nbr and
         tx2d_line = line and
         tx2d_taxc = tx2_pt_taxc and
         tx2d_tax_usage = tx2_tax_usage and
         tx2d_trl = trlr_code and
         tx2d_tax_type = tx2_tax_type and
         tx2d_tr_type = "11"
      no-lock: end.
   end.

end.

/* An "18" record is requested */
else if tr_type = "18" then do:

   /* Look to see if Logistics is active. */
   /* If so, get taxes from the source. */
   /* Otherwise return an error. */
   {gprun.i ""mgisact.p"" "(input 'lgarinv', output lgData)"}
   if not lgData then do:
      /* Unable to calculate externally supplied tax rate. */
      {pxmsg.i &MSGNUM=3324 &ERRORLEVEL=3}
      return "99".
   end.

   /* Get the matching record, if any */
   {gprunmo.i &module = "LG"
      &program = "lgtx18.p"
      &param = """(input line, input tx2_tax_type,
        input tx2_tax_usage, output found, output taxes)"""}

   if found then do:

      assign
         tax_base_amt = tot_amt
         ntax_amt = 0.

      /* Round the tax per the current method */
      run gpcrnd (input-output taxes,input tax_round).

      /* ADD TRANSACTION TYPES FOR LOGISTICS CHARGES(40-48) */
      /* Set AR Absorbed */
      ar_ap = lookup(tr_type,
             "20,21,22,23,24,25,26,27,28,29,32,40,41,42,43,44,45,46,47,48") = 0.

      if ar_ap and tx2_ara_use then
            assign adj_amt = - taxes.

      return "".

   end.

   /* No imported tax record exist for this tax type */
   else return "01".

end.

else do:
   /* Unsupported transaction tax type */
   /* Unable to calculate externally supplied tax rate. */
   {pxmsg.i &MSGNUM=3324 &ERRORLEVEL=3 &MSGARG1=tr_type}
   return "99".
end.

/* Since the taxes were orginally calculated by some other system */
/* such as On/Q, MFG/PRO has no idea how to calculate the taxes */
/* other than use the same rate as the orginal data.  If the */
/* taxable amount does not vary, this is ideal.  If this is a */
/* partial shipment, the taxes are prorated by the shipped amount. */
/* This is not ideal, but it will preserve the total.  The */
/* external system really ought to enter the new values itself. */
/* But MFG/PRO is shipping a partial order and something has to */
/* go into the tax field. */

/* CALCULATE */
if available tx2d_det then do:

   if tx2d_totamt = tot_amt then do:

      /* If unchanged, use the existing value. */
      assign
         taxes = tx2d_cur_tax_amt
         tax_base_amt = tx2d_totamt
         ntax_amt = 0.

      /* Round the tax per the current method */
      run gpcrnd (input-output taxes,input tax_round).

      /* ADD TRANSACTION TYPES FOR LOGISTICS CHARGES(40-48) */

      /* Set AR Absorbed */
      ar_ap = lookup(tr_type,
             "20,21,22,23,24,25,26,27,28,29,32,40,41,42,43,44,45,46,47,48") = 0.

      if ar_ap and tx2_ara_use then
         assign adj_amt = - taxes.

   end.

   else do:

      /* If nothing to tax, set tax to 0 */
      if tot_amt = 0 then tax_pct = 0 .

      else if tx2d_totamt <> 0 then do:
         /* Pro rate the new tax */
         /* Get the rate in the old record */
         tax_pct = tx2d_cur_tax_amt / tx2d_totamt .
      end.

      else do:

         /* When a taxable amount is reduced to 0, there is no way */
         if tr_type = "11" or tr_type = "13" or tr_type = "14" then do:

            /* Look for invoiced values */
            /* Use the last invoice found */
            for last tx2d_det
               fields (tx2d_cur_tax_amt tx2d_totamt)
               where tx2d_nbr = ref and
               tx2d_line = line and
               tx2d_trl = trlr_code and
               tx2d_tax_type = tx2_tax_type and
               tx2d_taxc = tx2_pt_taxc and
               tx2d_tax_usage = tx2_tax_usage and
               tx2d_tr_type = "16" and
               tx2d_totamt <> 0
            no-lock:
               tax_pct = tx2d_cur_tax_amt / tx2d_totamt.
            end.

            /* If we could not find the record, fail */
            if not available tx2d_det then do:
               /* Unable to calculate externally supplied tax rate. */
               {pxmsg.i &MSGNUM=3324 &ERRORLEVEL=3}
               return "99".
            end.

         end.

         else do:
            /* Unable to calculate externally supplied tax rate. */
            {pxmsg.i &MSGNUM=3324 &ERRORLEVEL=3}
            return "99".
         end.

      end.

      assign
         /* Pro rate the value */
         taxes = tot_amt * tax_pct
         tax_base_amt = tot_amt
         ntax_amt = 0.

      /* Round the tax per the current method */
      run gpcrnd (input-output taxes,input tax_round).

      /* ADD TRANSACTION TYPES FOR LOGISTICS CHARGES(40-48) */
      /* Set AR Absorbed */
      ar_ap = lookup(tr_type,
             "20,21,22,23,24,25,26,27,28,29,32,40,41,42,43,44,45,46,47,48") = 0.
      if ar_ap and tx2_ara_use then
         assign adj_amt = - taxes.

   end.

end.

else do:
   /* Not all possible taxes will exist for any one taxable item */
   /* This is not an error, just a signal that this particular */
   /* tax type does not apply. */
   return "01".
end.

return "".
