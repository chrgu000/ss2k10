/* txcalca.i - OBTAIN TAX VARIABLES FOR TAX LINE CALCULATION LINE ITEMS    */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.13.1.7 $                                                   */
/*V8:ConvertMode=NoConvert                                                 */
/* REVISION: 7.4      CREATED:      6/22/93    BY:  wep *H010*             */
/*                                 09/27/93    BY:  bcm *H138*             */
/*                                 09/29/93    BY:  bcm *H143*             */
/*                                 12/29/93    By:  bcm *H270*             */
/*                                 09/08/94    By:  bcm *H509*             */
/*                                 02/23/95    By:  jzw *H0BM*             */
/*                                 03/27/95    By:  tvo *H0BJ*             */
/*                                 09/26/96   by: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6    LAST MODIFIED: 10/20/97   *K0JV* Shankar Subramanian   */
/*                                 10/30/97   *J24S* Shankar Subramanian   */
/* REVISION: 8.6    LAST MODIFIED: 01/07/98   *J29D* Jim Josey             */
/* REVISION: 8.6    LAST MODIFIED: 02/19/98   *K1J0* Surendra Kumar        */
/* REVISION: 8.6E   LAST MODIFIED: 05/15/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E   LAST MODIFIED: 06/22/98   BY: *J2D9* Sachin Shah       */
/* REVISION: 8.6E   LAST MODIFIED: 06/30/98   BY: *L01B* Jim Josey         */
/* REVISION: 8.6E   LAST MODIFIED: 08/11/98   BY: *J2R1* Ajit Deodhar      */
/* REVISION: 8.6E   LAST MODIFIED: 10/11/98   BY: *L0BG* Surendra Kumar    */
/* REVISION: 8.6E   LAST MODIFIED: 02/20/99   BY: *L0CG* Surendra Kumar    */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KC* myb               */
/* REVISION: 9.1    LAST MODIFIED: 11/27/00   BY: *L12B* Santosh Rao       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                 */
/* Revision: 1.13.1.5     BY: Veena Lad       DATE: 08/06/01 ECO: *L19H*   */
/* Revision: 1.13.1.6     BY: Manjusha Inglay DATE: 11/01/01 ECO: *M1NF*   */
/* Revision: 1.13.1.6     BY: Reetu Kapoor    DATE: 19/07/02 ECO: *P0BV*   */
/* $Revision: 1.13.1.7 $     BY: Amit Chaturvedi DATE: 01/20/03 ECO: *N20Y*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
Reads the appropriate detail file based on the prefix and sets
tax variables for individual tax line calculation.  Used by several
programs which have similar structure for computing taxes, the only
difference being the names of the detail file and field names (sales
orders, sales quotes, purchase orders, purchase order receipts, etc.).

&det_prefix     detail file prefix (e.g. sales order detail = "sod").
&mstr_prefix    master file prefix (e.g. sales orders = "so").
&det_file       detail file name for "for" statement.
&det_key        detail file key which detail file is read by.
&criteria       additional search criteria for detail records.
&det_index      detail file index.
&tax_qty        calculation for extended line amount; quantity
                and price for tax calculation.
&taxable        value for what "taxable" is to evaluate to.
&tax_date       if not previously set from the master, field from detail
                file for setting tax date.
&adj_fact       Adjustment multiplier
&ship_to1       primary tax ship-to address
&ship_to2       secondary tax ship-to address
&ship_from1     primary tax ship-from address
&ship_from2     secondary tax ship-from address

/**********************************************************************
ADDITIONAL PARAMETER INTRODUCED FOR QUANTUM TAX CALCULATION
**********************************************************************/
&qty            Line item quantity

*/

define variable l_exch_exru_seq       like exru_seq     no-undo.
define variable l_mstr_prefix         as character      no-undo.
define variable l_ship_date           like so_ship_date no-undo.

/*OBTAIN ENTITY*/
for first si_mstr
   fields ( si_entity si_site)
   where si_site = {&mstr_prefix}_site
   no-lock:
   tax_entity = si_entity.
end.

/* IF THE SITE SPECIFIED IN THE HEADER IS BLANK THEN SITE MASTER  */
/* WILL NOT BE AVAILABLE, IN SUCH CASE OBTAIN TAX ENTITY FROM     */
/* THE DEFAULT SYSTEM ENTITY                                      */
if not available si_mstr
then do:
   for first gl_ctrl
      no-lock:
      tax_entity = gl_entity.
   end. /* FOR FIRST gl_ctrl */
end. /* IF NOT AVAILABLE si_mstr */

l_mstr_prefix = "{&mstr_prefix}".

if l_mstr_prefix   = "so"
   and txc_tr_type = "13"
then do:

   for first so_mstr
      where so_nbr = mstr_ref
      no-lock:
   end. /* FOR FIRST so_mstr */

   if so_ship_date <> ?
   then
      l_ship_date = so_ship_date.
   else
      l_ship_date = tax_date.

   if so_fix_rate  = no
   then do:
      {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
         "(input  so_curr,
           input  base_curr,
           input  so_ex_ratetype,
           input  l_ship_date,
           output tax_ex_rate,
           output tax_ex_rate2,
           output l_exch_exru_seq,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
         undo, retry.
      end. /* IF mc-error-number <> 0 */

      assign
         tax_curr         = so_curr
         tax_ex_ratetype  = so_ex_ratetype.

   end. /* IF so_fix_rate = no AND ... */
   else
      assign
         tax_curr         = so_curr
         tax_ex_rate      = so_ex_rate
         tax_ex_rate2     = so_ex_rate2
         tax_ex_ratetype  = so_ex_ratetype.

end. /* IF l_mstr_prefix = "SO" AND ... */
else
   assign
      tax_curr         = {&mstr_prefix}_curr
      tax_ex_rate      = {&mstr_prefix}_ex_rate
      tax_ex_rate2     = {&mstr_prefix}_ex_rate2
      tax_ex_ratetype  = {&mstr_prefix}_ex_ratetype.

/*****************************************************************/
/* QUANTUM RELATED PARAMETERS WILL BE ASSIGNED HERE. THE INCLUDE */
/* FILE txapihdr.i ASSIGNS THE VALUES FOR company-code,          */
/* division-code, customer-class AND THE EXCHANGE RATE IF THE    */
/* TRANSACTION CURRENCY IS NOT US DOLLARS.                       */
/*****************************************************************/
{txapihdr.i}

/* A DUMMY FIND ON {&det_file} IS REQUIRED AS THE RECORDS COMMITTED ARE */
/* DONE AT THE END OF THE TRANSACTION IN ORACLE ENVIRONMENT. WITH THIS  */
/* THE UPDATED VALUES PRESENT IN THE BUFFER of {&det_file} CAN BE READ  */

for first {&det_file}
   where {&det_key} = mstr_ref
no-lock:
end. /* FOR FIRST {&det_file} */

/* LOOP THROUGH LINE ITEMS */
for each {&det_file}
   where {&det_key} = mstr_ref
   and   (txc_line  = 0
          or {&det_prefix}_line = txc_line)
   /* ADDITIONAL SELECTION CRITERIA */
   {&criteria}
   use-index {&det_index}
   break by {&det_prefix}_line:

   tax_line = {&det_prefix}_line.

   /* BREAK BY INTRODUCED TO IDENTIFY LAST LINE PROCESSED.      */
   /* THIS IS REQUIRED WHEN QUANTUN IS USED TO CALCULATE TAXES. */
   /* WILL NOT AFFECT FUNCTIONALITY IF QUANTUM IS NOT USED TO   */
   /* CALCULATE TAXES.                                          */

   last-line = if last({&det_prefix}_line)
                  and last-trlr = 0
               then
                  yes
               else
                  no.

   /* TRANSACTION TYPES 33 (SERVICE QUOTES) AND 34 (SERVICE CONTRACTS)   */
   /* USE TRAILER CODE 'a' FOR ADDITIONAL CHARGES, WHILE THE LINE-NUMBER */
   /* DOES NOT CHANGE. UNFORTUNATELY, NO OTHER SOLUTION WAS POSSIBLE.    */

   if txc_tr_type     <> "33"
      and txc_tr_type <> "34"
   then
      trlr_code = "".

   assign
      taxable = {&taxable}
      tax_in  = {&det_prefix}_tax_in.

   if {&det_prefix}_tax_env > ""
   then
      tax_tax_env = {&det_prefix}_tax_env.
   else
      tax_tax_env = {&mstr_prefix}_tax_env.

   if {&det_prefix}_taxc > ""
   then
      tax_taxc = {&det_prefix}_taxc.
   else
      tax_taxc = "".

   assign
      tax_usage  = {&det_prefix}_tax_usage
      tax_amt    = {&tax_qty}
      txd_entity = "".

   /* GET EXTENDED PRICE OF AUTHORIZATIONS */
   if "{&det_file}"   = "sod_det"
      and txc_tr_type = "13"
   then do:

      run p-auth
         (buffer so_mstr,
          buffer {&det_file},
          input-output tax_amt).
   end. /* IF "{&det_file}" = "sod_det" */

   for first si_mstr
      fields (si_entity si_site)
      where si_site = {&det_prefix}_site
      no-lock:
      txd_entity = si_entity.
   end. /* FOR FIRST si_mstr */

   /* FIND ship-from & ship-to TAX ZONES */
   /* LOAD DEFAULTS */
   assign
      tax_zone_to   = ""
      tax_zone_from = "".

   for first ad_mstr
      fields (ad_addr ad_taxc ad_tax_zone ad__qad01)
      where ad_addr = "~~taxes"
      no-lock:

      assign
         tax_zone_to   = ad_tax_zone
         tax_zone_from = ad_tax_zone
         /* MAKE ASSIGNMENTS FOR SHIPFROM/ TO INCITY FLAGS ALSO */
         shipfrom-incity = if substring(ad__qad01, 1, 1) = '1'
                           then
                              yes
                           else
                              no
         shipto-incity   = shipfrom-incity.

   end. /* FOR FIRST ad_mstr */

   /* LOAD ship-to */
   if "{&ship_to1}" > ""
   then do:

      for first ad_mstr
         fields (ad_addr ad_taxc ad_tax_zone ad__qad01)
         where ad_addr = {&ship_to1}
         no-lock:
      end.
      if available(ad_mstr)
      then
         tax_zone_to = ad_tax_zone.
      else
      if "{&ship_to2}" > ""
      then do:
         for first ad_mstr
            fields (ad_addr ad_taxc ad_tax_zone ad__qad01)
            where ad_addr = {&ship_to2}
            no-lock:
         end.
         if available(ad_mstr)
         then
            tax_zone_to = ad_tax_zone.
      end.

      /* ASSIGN THE shipto-incity FLAG. FOR QUANTUM API */
      if available ad_mstr
      then
         shipto-incity = if substring(ad__qad01, 1, 1) = "1"
                         then
                            yes
                         else
                            no.
   end. /* LOAD ship-to */

   /* LOAD SHIP-FROM */
   if "{&ship_from1}" > ""
   then do:

      for first ad_mstr
         fields (ad_addr ad_taxc ad_tax_zone ad__qad01)
         where ad_addr = {&ship_from1}
         no-lock :
      end.
      if available(ad_mstr)
      then
         tax_zone_from = ad_tax_zone.
      else
      if "{&ship_from2}" > ""
      then do:

         for first ad_mstr
            fields (ad_addr ad_taxc ad_tax_zone ad__qad01)
            where ad_addr = {&ship_from2}
            no-lock:
         end.
         if available(ad_mstr)
         then
            tax_zone_from = ad_tax_zone.
      end.

      /* ASSIGNED VALUES FOR tax_zone_from AND tax_zone_to    */
      /* FOR CALL INVOICES BASED ON THE LOCATION OF THE ITEM  */
      if  l_mstr_prefix = "so"
      and txc_tr_type   = "16"
      then do:
         if so_fsm_type = "FSM-RO"
         then do:
            for first itm_det
               fields (itm_nbr itm_line itm_ca_int_type itm_site
                       itm_sad_line itm_sa_nbr)
               where {&det_key}         = itm_nbr
               and   {&det_prefix}_line = itm_line
            no-lock:
               for first fwk_mstr
                  fields (fwk_ca_int_type fwk_repair_ctr)
                  where fwk_ca_int_type = itm_ca_int_type
               no-lock:

                  /* IF ITEM AT REPAIR CENTER */
                  if fwk_repair_ctr
                  then do:
                     for first ad_mstr
                        fields (ad_addr ad_taxc ad_tax_zone ad__qad01)
                        where ad_addr = itm_site
                     no-lock:
                        assign
                           tax_zone_from = ad_tax_zone
                           tax_zone_to   = ad_tax_zone.
                     end. /* FOR FIRST ad_mstr */
                  end. /* IF fwk_repair_ctr */
                  else do:

                     /* IF ITEM AT END-USER */
                     for first ad_mstr
                        fields (ad_addr ad_taxc ad_tax_zone ad__qad01)
                        where ad_addr = so_ship
                     no-lock:
                        assign
                           tax_zone_from = ad_tax_zone
                           tax_zone_to   = ad_tax_zone.
                     end. /* FOR FIRST ad_mstr */
                     if not available ad_mstr
                     then do:

                        /* IF ITEM AT CUSTOMER */
                        for first ad_mstr
                           fields (ad_addr ad_taxc ad_tax_zone ad__qad01)
                           where ad_addr = so_cust
                        no-lock:
                           assign
                              tax_zone_from = ad_tax_zone
                              tax_zone_to   = ad_tax_zone.
                        end. /* FOR FIRST ad_mstr */
                     end. /* IF NOT AVAILABLE ad_mstr */
                  end. /* ELSE DO - IF NOT fwk_repair_ctr */
               end. /* FOR FIRST fwk_mstr */
            end. /* FOR FIRST itm_det */
         end. /* IF so_fsm_type = "FSM-RO" */
      end. /* IF l_mstr_prefix = "so" */

      /* ASSIGN THE shipfrom-incity FLAG. FOR QUANTUM API */
      if available ad_mstr then
         shipfrom-incity = if substring(ad__qad01, 1, 1) = "1"
                           then
                              yes
                           else
                              no.
   end. /* LOAD SHIP-FROM */

   if tax_tax_env = ""
   then do:
      /* BLANK TAX ENVIRONMENT NOT ALLOWED */
      {pxmsg.i &MSGNUM=944 &ERRORLEVEL=4}
      return.
   end.

   /******************************************************************/
   /* WE WILL ASSIGN THE LINE ITEM SITE TO QUANTUM DIVISION CODE.    */
   /* THE HEADER SITE IS ALREADY ASSIGNED IN txapihdr.i. WHAT WE ARE */
   /* GOING TO DO HERE IS, IF THE LINE ITEM SITE IS NOT BLANK,       */
   /* ASSIGN IT TO divn-code. THIS WILL OVERRIDE THE ASSIGNMENT      */
   /* MADE IN txapihdr.i. IF THE LINE ITEM SITE IS BLANK, WE STILL   */
   /* HAVE THE ASSIGNMENT MADE FROM THE HEADER IN txapihdr.i.        */

   /* EXCEPTIONS ARE TR_TYPE 18 (AR), TR_TYPE 22 (VOUCHERS) AND      */
   /* TR_TYPE 32 (RECURRING VOUCHERS). THERE IS NO SITE INFO.        */
   /* AT A DETAIL LEVEL FOR THESE. WHATEVER ASSIGNMENT IS MADE       */
   /* TO divn-code IN txapihdr.i HOLDS GOOD.                         */
   /******************************************************************/

   if {&det_prefix}_site > ""
   then
      divn-code = {&det_prefix}_site.

   lineitem-qty = {&qty}.

   if lineitem-qty = 0
   then
      lineitem-qty = 1.

   /* PASSES THE FOLLOWING ADDITIONAL PARAMETERS: company-code,    */
   /* divn-code, cmvd-addr, cmvd-taxclass, orderaccept-taxzone,    */
   /* shipfrom-incity, shipto-incity, orderaccept-incity,          */
   /* lineitem-qty, vq-post, vq-exch-rate, vq-rndmthd,             */
   /* OUTPUT PARAMETER result-status FOR QUANTUM TAX CALCULATIONS. */
   /* txline.p WILL BE CALLED DURING TAX CALCULATION AND vqline.p  */
   /* WILL BE CALLED ONLY WHEN WE REQUIRE QUANTUM TO CREATE        */
   /* REGISTER RECORDS. vq-post WILL BE 'YES' ONLY WHEN txcalc.p   */
   /* IS CALLED BY txglpost.p.                                     */

   if not vq-post
   then do:

      /* DURING CONVERSION, ASSIGN SALES ORDER NUMBER FOR AN   */
      /* CONSOLIDATED INVOICE (TYPE = "16").                   */

      if txc_tr_type = "16"
      then
         txc_nbr = {&det_prefix}_nbr.

      /* ADDED SECOND EXCHANGE RATE BELOW */
      /* ADDED RATE TYPE BELOW */
      {gprun.i ""xxxtxline.p""
         "(tax_curr,
           txc_tr_type,
           txc_ref,
           txc_nbr,
           tax_line,
           trlr_code,
           taxable,
           tax_in,
           tax_date,
           tax_gl_date,
           tax_tax_env,
           tax_zone_from,
           tax_zone_to,
           tax_taxc,
           tax_usage,
           tax_amt,
           tax_ex_rate,
           tax_ex_rate2,
           tax_ex_ratetype,
           tax_entity,
           txd_entity,
           adj_factor,
           inv_disc_pct,
           """",
           company-code,
           divn-code,
           cmvd-addr,
           cmvd-taxclass,
           orderaccept-taxzone,
           shipfrom-incity,
           shipto-incity,
           orderaccept-incity,
           lineitem-qty,
           vq-post,
           vq-exch-rate,
           vq-exch-rate2,
           vq-rndmthd,
           output txcalc-result)"}
   end.
   else do:
      /* ADDED SECOND EXCHANGE RATE BELOW */
      /* ADDED RATE TYPE BELOW */
      {gprun.i ""vqline.p""
         "(tax_curr,
           txc_tr_type,
           txc_ref,
           txc_nbr,
           tax_line,
           trlr_code,
           taxable,
           tax_in,
           tax_date,
           tax_gl_date,
           tax_tax_env,
           tax_zone_from,
           tax_zone_to,
           tax_taxc,
           tax_usage,
           tax_amt,
           tax_ex_rate,
           tax_ex_rate2,
           tax_ex_ratetype,
           tax_entity,
           txd_entity,
           adj_factor,
           inv_disc_pct,
           """",
           company-code,
           divn-code,
           cmvd-addr,
           cmvd-taxclass,
           orderaccept-taxzone,
           shipfrom-incity,
           shipto-incity,
           orderaccept-incity,
           lineitem-qty,
           vq-post,
           vq-exch-rate,
           vq-exch-rate2,
           vq-rndmthd,
           output txcalc-result)"}
   end.
   /****************************************************************/
   /* IF THE RETURN STATUS INDICATES A FAILURE, IT WILL HAVE A     */
   /* NON-ZERO VALUE. IN SUCH A CASE WE SET result-status = STATUS */
   /* VALUE RETURNED BY txline.p. THE VALUE OF result-status WILL  */
   /* REMAIN UNCHANGED EVEN IF THERE ARE PROCESSING ERRORS DURING  */
   /* SUBSEQUENT CALLS TO QUANTUM. THIS WAY WE WILL BE ABLE TO     */
   /* FINALLY TELL THE USER AT A DOCUMENT LEVEL THAT SOMETHING HAS */
   /* GONE WRONG                                                   */
   /****************************************************************/

   if txcalc-result <> 0
   then
      if result-status <> 0 then
         result-status = txcalc-result.

end. /* FOR EACH */
