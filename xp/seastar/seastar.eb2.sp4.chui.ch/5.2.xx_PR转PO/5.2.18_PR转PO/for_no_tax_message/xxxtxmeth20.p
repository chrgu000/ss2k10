/* txmeth20.p - qad TAX CALCULATION ROUTINE THAT CALLS QUANTUM             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.9.2.6 $                                                   */
/*V8:ConvertMode=Maintenance                                               */
/* REVISION: 8.6     CREATED  : 10/20/97     *K0JV* Shankar Subramanian    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton    */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98   BY: *J2D9* Sachin Shah     */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *L01B* Jim Josey       */
/* REVISION: 8.6E     LAST MODIFIED: 10/11/98   BY: *L0BG* Surendra Kumar  */
/* REVISION: 8.6E     LAST MODIFIED: 10/26/98   BY: *L0CF* Sami Kureishy   */
/* REVISION: 8.6E     LAST MODIFIED: 08/12/99   BY: *J3KY* Sachin Shinde   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb             */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0W4* BalbeerS Rajput */
/* REVISION: 9.1      LAST MODIFIED: 02/12/01   BY: *M11P* Veena Lad       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                 */
/* $Revision: 1.9.2.6 $   BY: Ashish M.      DATE: 12/10/01  ECO: *M1R1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*!
    txmeth20.p  qad Quantum Tax Calculation routine

        I/O     Parameter           Like          Description
        ------  ------------------- ------------- ---------------------------
        input   tax_code            tx2_tax_code  Tax Code
        input   tax_round           txed_round    Rounding Method
        input   rndmthd             rnd_rnd_mthd  Rounding Method
        input   tax_by_line         tx2_by_line   Tax By Line
        input   amt_curr            tx2d_curr     Tax Currency
        input   tax_in              sod_tax_in    Tax Included
        input   entity              en_entity     Entity
        input   entity_exrate       exr_rate      Exchange Rate
        input   exrate              exr_rate
        input   tr_type             tx2d_tr_type  Tax Transaction Type
        input   ref                 tx2d_ref      Document Reference
        input   nbr                 tx2d_nbr      Second Reference
        input   line                tx2d_line     Line Number
        input   trlr_code           tx2d_trl      Trailer_code
        input   tax_line            tx2d_line     Tax Line Number
        input   tax_date            tx2d_effdate  Tax Rate Effective date
        input   tax_post_date       tx2d_effdate  GL Posted Date
        input   adj_factor          mfc_decimal   Adjustment Factor
        input   company-code        en_entity     Company Code
        input   divn-code           sod_site      Division Code
        input   cmvd-addr           ad_addr       Customer Id
        input   cmvd-taxclass       ad_taxc       Customer Tax Class
        input   shipfrom-taxzone    ad_tax_zone   Ship-from Tax Zone
        input   shipto-taxzone      ad_tax_zone   Ship-to Tax Zone
        input   orderaccept-taxzone ad_tax_zone   Order Acceptance Tax Zone
        input   shipfrom-incity     mfc_logical   Ship-from Incity indicator
        input   shipto-incity       mfc_logical   Ship-to Incity indicator
        input   orderaccept-incity  mfc_logical   Ord Accept Incity indicator
        input   lineitem-qty        sod_qty_ord   Line Item Quantity
        input   taxc                tx2_pt_taxc   Item Tax Class
        input   first-taxtype       mfc_logical   First Tax Type
        input   vq-post             mfc_logical   Quantum Register Post flag
        input   vq-exch-rate        exr_rate      Exch Rate: Trans Curr - USD
        input   vq-exch-rate2       exr_rate2     Exch Rate: Trans Curr - USD
        input   vq-rndmthd          cu_rnd_mthd   Rounding Method:Trans Curr- US
        output  result-status       integer       Result Status
        input-output   tot_amt      tx2d_totamt   Extended Amount
        output  taxes               tx2d_totamt   Taxes
        output  adj_amt             tx2d_totamt   Taxable Base Amount
        output  recoverable         tx2d_totamt   Taxable Base Amount
        output  tax_base_amt        tx2d_totamt   Taxable Base Amount
        output  ntax_amt            tx2d_totamt   Non-Taxable Amount

*/
/*!
    NOTE: ANY CHANGES MADE TO THIS PROGRAM SHOULD ALSO BE MADE TO
    ALL TXMETH*.P PROGRAMS
*/
/***************************************************************************/
{mfdeclre.i}
{cxcustom.i "TXMETH20.P"}

define input        parameter tax_code            like tx2_tax_code  no-undo.
define input        parameter tax_round           like txed_round    no-undo.
define input        parameter rndmthd             like rnd_rnd_mthd  no-undo.
define input        parameter tax_by_line         like tx2_by_line   no-undo.
define input        parameter amt_curr            like tx2d_curr     no-undo.
define input        parameter tax_in              like sod_tax_in    no-undo.
define input        parameter entity              like en_entity     no-undo.
define input        parameter entity_exrate       like exr_rate      no-undo.
define input        parameter exrate              like exr_rate      no-undo.
define input        parameter tr_type             like tx2d_tr_type  no-undo.
define input        parameter ref                 like tx2d_ref      no-undo.
define input        parameter nbr                 like tx2d_nbr      no-undo.
define input        parameter line                like tx2d_line     no-undo.
define input        parameter trlr_code           like tx2d_trl      no-undo.
define input        parameter tax_line            like tx2d_line     no-undo.
define input        parameter tax_date            like tx2d_effdate  no-undo.
define input        parameter tax_post_date       like tx2d_effdate  no-undo.
define input        parameter adj_factor          like mfc_decimal   no-undo.
define input        parameter company-code        as   character     no-undo.
define input        parameter divn-code           as   character     no-undo.
define input        parameter cmvd-addr           as   character     no-undo.
define input        parameter cmvd-taxclass       as   character     no-undo.
define input        parameter shipfrom-taxzone    as   character     no-undo.
define input        parameter shipto-taxzone      as   character     no-undo.
define input        parameter orderaccept-taxzone as   character     no-undo.
define input        parameter shipfrom-incity     as   logical       no-undo.
define input        parameter shipto-incity       as   logical       no-undo.
define input        parameter orderaccept-incity  as   logical       no-undo.
define input        parameter lineitem-qty        like mfc_decimal   no-undo.
define input        parameter taxc                like tx2_pt_taxc   no-undo.
define input        parameter first-taxtype       as   logical       no-undo.
define input        parameter vq-post             as   logical       no-undo.
define input        parameter vq-exch-rate        like exr_rate      no-undo.
define input        parameter vq-exch-rate2       like exr_rate2     no-undo.
define input        parameter vq-rndmthd          like cu_rnd_mthd   no-undo.
define output       parameter result-status       as   integer       no-undo.
define input-output parameter tot_amt             like tx2d_totamt   no-undo.
define output       parameter taxes               like tx2d_totamt   no-undo.
define output       parameter adj_amt             like tx2d_totamt   no-undo.
define output       parameter recoverable         like tx2d_totamt   no-undo.
define output       parameter tax_base_amt        like tx2d_totamt   no-undo.
define output       parameter ntax_amt            like tx2d_totamt   no-undo.

define variable mc-error-number like msg_nbr     no-undo.

/* DEFINE VARIABLES TO HOLD THE EXTENDED AMOUNT, TAXES AND       */
/* NON-TAX AMOUNT IN US DOLLARS. THIS IS BECAUSE QUANTUM CAN     */
/* CALCULATE TAXES IN US DOLLARS ONLY. WE ARE CONVERTING TOT-AMT */
/* TO US DOLLARS BEFORE CALLING QUANTUM TO CALCULATE TAXES AND   */
/* CONVERTING TOT-AMT, TAXES AND NON-TAX AMOUNTS BACK TO         */
/* TRANSACTION CURRENCY FROM US DOLLARS                          */

define variable     vq-tot-amt    like tx2d_totamt no-undo.
define variable     vq-taxes      like tx2d_totamt no-undo.
define variable     vq-ntax-amt   like tx2d_totamt no-undo.

/* INCLUDE VQ WORKFILE HERE. THIS FILE HAS A FEW VARIABLE(S)     */
/* DEFINED THAT WILL ENSURE CALLING OF THE QUANTUM API ONLY ONCE */
/* FOR A DOCUMENT. IT HAS A TEMP-TABLE DEFINITION THAT WILL HOLD */
/* ALL THE LINE ITEM, TAX TYPE INFORMATION AND WILL CALL         */
/* VQTXCALC.P AFTER THE LAST LINE ITEM IN A FOR EACH ... LOOP    */
/* IS PROCESSED.                                                 */

{vqwrkdef.i}

/* FIND TAX RATE MASTER */

for first tx2_mstr
   fields (tx2_apr_use tx2_ara_use tx2_pct_recv tx2_tax_code
           tx2_tax_pct tx2_tax_type)
   where tx2_tax_code = tax_code
no-lock:
end. /* FOR FIRST tx2_mstr */

if not available(tx2_mstr)
then do:
   /* TAX MASTER DOES NOT EXIST */
   {pxmsg.i &MSGNUM=872 &ERRORLEVEL=4}
end. /* IF NOT AVAILABLE(tx2_mstr) */

/* CHECK TAX INCLUDED */
if tax_in
then
   tot_amt = (tot_amt * 100)/(100 + tx2_tax_pct).

assign
   taxes        = 0
   ntax_amt     = 0
   tax_base_amt = tot_amt
   vq-tot-amt   = tot_amt.

/* NEED US CURRENCY CODE FOR MC-CURR-CONV */
for first mfc_ctrl
   fields (mfc_module mfc_field mfc_char)
   where mfc_module = "vq"
   and   mfc_field  = "vqc_us_curr"
   no-lock:
end. /* FOR FIRST mfc_ctrl */

if available mfc_ctrl
then do:

   /* DO NOT CONVERT THE AMOUNTS PASSED TO AND FROM VERTEX */
   /* FOR TAX CALCULATION PURPOSES.                        */

   assign
      vq-taxes    = 0
      vq-ntax-amt = 0.

   /* CALL QUANTUM TO CALCULATE TAXES */

   /* CREATE TEMP FILE AND STORE ALL THE VALUES IN IT. WHEN WE ARE */
   /* DONE PROCESSING THE LAST TAX TYPE OF THE LAST LINE, WE WILL  */
   /* CALL VQTXCALC.P SO THAT QUANTUM API WILL BE CALLED ONLY ONCE */
   /* TO CALCULATE TAXES FOR THE ENTIRE DOCUMENT. THIS APPROACH IS */
   /* EXPECTED TO REDUCE PROCESSING TIME SIGNIFICANTLY.            */

   /* WE ARE FORCING THE LINE NUMBERS SINCE TR-TYPE = 18 HAS JUST ONE LINE */
   /* WITH THE LINE NUMBER AS ZERO . IN THE CASE OF MULTIPLE LINE ITEMS,   */
   /* QUANTUM CANNOT DISTINGUISH BETWEEN LINES                             */

   if tr_type = "18"
   then
      assign
         line-ctr = line-ctr + 1
         line     = line-ctr.

   create temp_file.
   assign
      temp_tax_code            = tax_code
      temp_tax_round           = tax_round
      temp_rndmthd             = rndmthd
      temp_tax_by_line         = tax_by_line
      temp_entity_exrate       = temp_entity_exrate
      temp_exrate              = exrate
      temp_tax_curr            = amt_curr
      temp_tax_in              = tax_in
      temp_trlr_code           = trlr_code
      temp_tax_line            = tax_line
      temp_adj_factor          = adj_factor
      temp_vq_exch_rate        = vq-exch-rate
      temp_vq_rndmthd          = vq-rndmthd
      temp_line                = line
      temp_divn_code           = divn-code
      temp_cmvd_addr           = cmvd-addr
      temp_cmvd_taxclass       = cmvd-taxclass
      temp_tax_date            = tax_date
      temp_posted_date         = tax_post_date
      temp_shipfrom_taxzone    = shipfrom-taxzone
      temp_shipto_taxzone      = shipto-taxzone
      temp_orderaccept_taxzone = orderaccept-taxzone
      temp_shipfrom_incity     = shipfrom-incity
      temp_shipto_incity       = shipto-incity
      temp_orderaccept_incity  = orderaccept-incity
      temp_lineitem_qty        = lineitem-qty
      temp_taxc                = taxc
      temp_tax_type            = tx2_tax_type
      temp_tot_amt             = tot_amt.

   /* TO SATISFY ORACLE STANDARDS ... */
   if recid(temp_file) = -1
   then .

   /* CALL VQTXCALC.P ONLY WHEN WE ARE PROCESSING THE LAST LINE, */
   /* THE LAST TAX TYPE                                          */
   if (last-line and last-taxtype)
   then do:
      {gprun.i ""vqtxcalc.p""
         "(input company-code,
           input entity,
           input tr_type,
           input ref,
           input nbr,
           input vq-post,
           input first-taxtype)"}
      /* WE ARE DONE. SO INITIALIZE THE VALUES BACK TO 'NO'. */
      assign
         last-line    = no
         last-taxtype = no.
   end. /* IF last-line and last-taxtype ... */

end. /* IF AVAILABLE MFC_CTRL */
