/* sopl.p - GENERAL PURPOSE SO MODULE PROCEDURE LIBRARY                       */
/* Copyright 1986-2009 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Revision: 1.3      BY:Vivek Gogte             DATE:08/02/03   ECO: *N2GZ*  */
/* Revision: 1.4      BY:Paul Donnelly           DATE:10/01/03   ECO: *Q041*  */
/* Revision: 1.5      BY:Mandar Gawde            DATE:05/17/04   ECO: *P1YF*  */
/* Revision: 1.7      BY:Bharath Kumar           DATE:08/10/04   ECO: *P2FC*  */
/* Revision: 1.7.1.1  BY:Sandeep Panchal         DATE:01/09/06   ECO: *P3HZ*  */
/* Revision: 1.7.1.2  BY:Naseem M Torgal         DATE:05/08/06   ECO: *Q0X7*  */
/* Revision: 1.7.1.3  BY:Naseem M Torgal         DATE:08/07/06   ECO: *Q0X7*  */
/* $Revision: 1.7.1.4 $       BY:John Corda              DATE:07/28/09   ECO: *Q35Y*  */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/27/12  ECO: *SS-20120927.1*   */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=NoConvert                                                    */
{mfdeclre.i}
{gprunpdf.i "mcpl" "p"}
{sotxidef.i}

PROCEDURE calDiscAmountAfterSubtractingTax:

   /* THIS PROCEDURE RETURNS ORDER TOTAL AND DISCOUNT, ORDER TOTAL IS */
   /* RE-CALCULATED AFTER SUBTRACTING INCLUDED TAX AND DISCOUNT IS    */
   /* RE-CALCULATED ON THE MODIFIED ORDER TOTAL                       */

   /* INPUT PARAMETERS                                                */
   /* table          - TEMPORARY TABLE STORING VALUE OF LINE TOTAL    */
   /*                  TABLES LIKE sod_det, qod_det, idh_hist         */
   /* p_rndmthd      - CURRENCY ROUNDING METHOD                       */
   /* p_so_disc_pct  - ORDER DISCOUNT                                 */
   /* p_tx2d_ref     - SALES ORDER NUMBER IF IT IS CALLED BY SALES    */
   /*                  ORDER FUNCTIONS                                */
   /*                  SALES QUOTE NUMBER IF IT IS CALLED BY SALES    */
   /*                  QUOTE FUNCTIONS                                */
   /*                  INVOICE NUMBER IF IT IS CALLED BY INVOICE      */
   /*                  FUNCTIONS                                      */
   /* p_tx2d_nbr     - SALES QUOTE NUMBER OR INVOICE NUMBER IF        */
   /*                  IT IS CALLED BY SALES ORDER FUNCTIONS          */
   /*                  BLANK IF IT IS CALLED BY SALES QUOTE FUNCTIONS */
   /*                  SALES ORDER NUMBER IF IT IS CALLED BY INVOICE  */
   /*                  FUNCTIONS                                      */
   /* p_tax_tr_type  - TAX TRANSACTION TYPE                           */
   /*                                                                 */
   /* OUTPUT PARAMETERS                                               */
   /* p_line_total   - ORDER TOTAL                                    */
   /* p_disc_amt     - DISCOUNT AMOUNT                                */

   define input  parameter table         for  t_store_ext_actual.
   define input  parameter p_rndmthd     like rnd_rnd_mthd no-undo.
   define input  parameter p_so_disc_pct like so_disc_pct  no-undo.
   define input  parameter p_tx2d_ref    like so_nbr       no-undo.
   define input  parameter p_tx2d_nbr    like so_inv_nbr   no-undo.
   define input  parameter p_tax_tr_type like tx2d_tr_type no-undo.
   define output parameter p_line_total  as   decimal      no-undo.
   define output parameter p_disc_amt    like p_line_total no-undo.

   define variable mc-error-number like msg_nbr   no-undo.
   define variable p_ext_actual    like sod_price no-undo.

   assign
      p_ext_actual = 0
      p_line_total = 0
      p_disc_amt   = 0.

   for each t_store_ext_actual:

      p_ext_actual = t_ext_actual.

      run getExtendedAmount
         (input        p_rndmthd,
          input        t_line,
          input        p_tx2d_ref,
          input        p_tx2d_nbr,
          input        p_tax_tr_type,
          input-output p_ext_actual).

      p_line_total = p_line_total + p_ext_actual.
   end. /* FOR EACH t_store_ext_actual ... */

   p_disc_amt = (- p_line_total * (p_so_disc_pct / 100)).

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output p_disc_amt,
        input        p_rndmthd,
        output       mc-error-number)"}

   if mc-error-number <> 0
   then do:
 /* *SS-20120927.1*       {mfmsg.i mc-error-number 2} */
   end. /* IF mc-error-number <> 0 */

END PROCEDURE. /* calDiscAmountAfterSubtractingTax */

PROCEDURE getExtendedAmount:

   /* THIS PROCEDURE RETURNS LINE TOTAL, LINE TOTAL IS RE-CALCULATED  */
   /* AFTER SUBTRACTING INCLUDED TAX                                  */

   /* INPUT PARAMETERS                                                */
   /* p_rndmthd      - CURRENCY ROUNDING METHOD                       */
   /* p_line         - ORDER LINE FOR SALES ORDER, SALES QUOTE ETC.   */
   /* p_tx2d_ref     - SALES ORDER NUMBER IF IT IS CALLED BY SALES    */
   /*                  ORDER FUNCTIONS                                */
   /*                  SALES QUOTE NUMBER IF IT IS CALLED BY SALES    */
   /*                  QUOTE FUNCTIONS                                */
   /*                  INVOICE NUMBER IF IT IS CALLED BY INVOICE      */
   /*                  FUNCTIONS                                      */
   /* p_tx2d_nbr     - SALES QUOTE NUMBER OR INVOICE NUMBER IF        */
   /*                  IT IS CALLED BY SALES ORDER FUNCTIONS          */
   /*                  BLANK IF IT IS CALLED BY SALES QUOTE FUNCTIONS */
   /*                  SALES ORDER NUMBER IF IT IS CALLED BY INVOICE  */
   /*                  FUNCTIONS                                      */
   /* p_tax_tr_type  - TAX TRANSACTION TYPE                           */
   /*                                                                 */
   /* INPUT-OUTPUT PARAMETER                                          */
   /* p_ext_actual   - LINE TOTAL                                     */

   define input        parameter p_rndmthd          like rnd_rnd_mthd  no-undo.
   define input        parameter p_line             like sod_line      no-undo.
   define input        parameter p_tx2d_ref         like so_nbr        no-undo.
   define input        parameter p_tx2d_nbr         like so_inv_nbr    no-undo.
   define input        parameter p_tax_tr_type      like tx2d_tr_type  no-undo.
   define input-output parameter p_ext_actual       like sod_price     no-undo.

   define variable mc-error-number like msg_nbr no-undo.
   define variable l_ext_actual like sod_price initial 0 no-undo.
   define variable l_ext_actual1 like sod_price initial 0 no-undo.
   l_ext_actual = p_ext_actual.

   if p_tax_tr_type = "16" then do:
      for each tx2d_det
         where tx2d_domain   = global_domain
           and (tx2d_ref     = p_tx2d_ref)
           and (tx2d_nbr     = ""
                or tx2d_nbr  = p_tx2d_nbr
                or tx2d_nbr  = "CONSOL")
           and  tx2d_line    = p_line
           and  tx2d_tr_type = p_tax_tr_type
           and  tx2d_tax_in  = yes
         no-lock:

         if tx2d_edited then
            l_ext_actual1 = tx2d_cur_tax_amt.
         else
         for first tx2_mstr
            where tx2_domain = global_domain
            and   tx2_tax_code = tx2d_tax_code
            no-lock:

            l_ext_actual1 = l_ext_actual1 + (l_ext_actual - (l_ext_actual /
                            (1 + tx2_tax_pct / 100))).

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output l_ext_actual1,
                 input        p_rndmthd,
                 output       mc-error-number)"}

            if mc-error-number <> 0 then
            do:
/* *SS-20120927.1*                {mfmsg.i mc-error-number 2} */ 
            end. /* IF mc-error-number <> 0 */

         end. /* FOR FIRST tx2_mstr */

         p_ext_actual = l_ext_actual - l_ext_actual1.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output p_ext_actual,
              input        p_rndmthd,
              output       mc-error-number)"}

         if mc-error-number <> 0 then
         do:
            {mfmsg.i mc-error-number 2}
         end. /* IF mc-error-number <> 0 */

      end. /* FOR FIRST tx2d_det ... */
   end. /* if p_tax_tr_type = "16" */
   else do:
      for each tx2d_det
         fields(tx2d_domain     tx2d_ref      tx2d_nbr      tx2d_line
             tx2d_tr_type    tx2d_tax_in   tx2d_tax_code tx2d_edited
             tx2d_tax_amt    tx2d_cur_tax_amt
             tx2d_cur_abs_ret_amt)
         where tx2d_domain   = global_domain
           and (tx2d_ref     = p_tx2d_ref)
           and (tx2d_nbr     = ""
                or tx2d_nbr  = p_tx2d_ref
                or tx2d_nbr  = p_tx2d_nbr)
           and  tx2d_line    = p_line
           and  tx2d_tr_type = p_tax_tr_type
           and  tx2d_tax_in  = yes
         no-lock:

         if tx2d_edited then
            l_ext_actual1 = tx2d_cur_tax_amt.
         else
         for first tx2_mstr
            fields(tx2_domain tx2_tax_code tx2_tax_pct)
            where tx2_domain = global_domain
            and   tx2_tax_code = tx2d_tax_code
            no-lock:

            l_ext_actual1 = l_ext_actual1 + (l_ext_actual - (l_ext_actual /
                           (1 + tx2_tax_pct / 100))).

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output l_ext_actual1,
                 input        p_rndmthd,
                 output       mc-error-number)"}

            if mc-error-number <> 0 then
            do:
               {mfmsg.i mc-error-number 2}
            end. /* IF mc-error-number <> 0 */

         end. /* FOR FIRST tx2_mstr */

         p_ext_actual = l_ext_actual - l_ext_actual1.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output p_ext_actual,
              input        p_rndmthd,
              output       mc-error-number)"}

         if mc-error-number <> 0 then
         do:
            {mfmsg.i mc-error-number 2}
         end. /* IF mc-error-number <> 0 */

      end. /* FOR FIRST tx2d_det ... */

      for each tx2d_det
         fields(tx2d_domain     tx2d_ref      tx2d_nbr      tx2d_line
                tx2d_tr_type    tx2d_tax_in   tx2d_tax_code tx2d_edited
                tx2d_tax_amt    tx2d_cur_tax_amt
                tx2d_cur_abs_ret_amt)
         where tx2d_domain   = global_domain
           and (tx2d_ref     = p_tx2d_nbr)
           and (tx2d_nbr     = ""
                or tx2d_nbr  = p_tx2d_ref
                or tx2d_nbr  = p_tx2d_nbr)
           and  tx2d_line    = p_line
           and  tx2d_tr_type = p_tax_tr_type
           and  tx2d_tax_in  = yes
         no-lock:

         if tx2d_edited then
            l_ext_actual1 = tx2d_cur_tax_amt.
         else
         for first tx2_mstr
            fields(tx2_domain tx2_tax_code tx2_tax_pct)
            where tx2_domain = global_domain
              and tx2_tax_code = tx2d_tax_code
            no-lock:

            l_ext_actual1 = l_ext_actual1 + (l_ext_actual - (l_ext_actual /
                            (1 + tx2_tax_pct / 100))).

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output l_ext_actual1,
                 input        p_rndmthd,
                 output       mc-error-number)"}

            if mc-error-number <> 0 then
            do:
               {mfmsg.i mc-error-number 2}
            end. /* IF mc-error-number <> 0 */

         end. /* FOR FIRST tx2_mstr */

         p_ext_actual = l_ext_actual - l_ext_actual1.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output p_ext_actual,
              input        p_rndmthd,
              output       mc-error-number)"}

         if mc-error-number <> 0 then
         do:
            {mfmsg.i mc-error-number 2}
         end. /* IF mc-error-number <> 0 */

      end. /* FOR FIRST tx2d_det ... */
   end. /* else */

END PROCEDURE. /* getExtendedAmount */

PROCEDURE adjustDiscountAmount:

   /* THIS PROCEDURE RETURNS ADJUSTED DISCOUNT TO AVOID ROUNDING ERROR */
   /* IN THE AMOUNT WHICH CUSTOMER PAYS i.e. Total IN TRAILER FRAMES   */

   /* INPUT PARAMETERS                                                 */
   /* p_taxable_amt     - ORDER TAXABLE AMOUNT                         */
   /* p_non_taxable_amt - ORDER NON TAXABLE AMOUNT                     */
   /* p_trl1_amt        - ORDER FIRST  TRAILER AMOUNT                  */
   /* p_trl2_amt        - ORDER SECOND TRAILER AMOUNT                  */
   /* p_trl3_amt        - ORDER THIRD  TRAILER AMOUNT                  */
   /* p_line_total      - ORDER TOTAL                                  */
   /*                                                                  */
   /* INPUT-OUTPUT PARAMETER                                           */
   /* p_disc_amt        - DISCOUNT AMOUNT                              */

   define input        parameter p_taxable_amt     as   decimal       no-undo.
   define input        parameter p_non_taxable_amt like p_taxable_amt no-undo.
   define input        parameter p_trl1_amt        like so_trl1_amt   no-undo.
   define input        parameter p_trl2_amt        like so_trl2_amt   no-undo.
   define input        parameter p_trl3_amt        like so_trl3_amt   no-undo.
   define input        parameter p_line_total      as   decimal       no-undo.
   define input-output parameter p_disc_amt        like p_line_total  no-undo.

   define variable p_rnd_difference like p_disc_amt no-undo.

   p_rnd_difference = (p_non_taxable_amt + p_taxable_amt
                       - p_trl1_amt - p_trl2_amt - p_trl3_amt)
                       - (p_line_total + p_disc_amt).

   /* DISCOUNT AMOUNT IS ADJUSTED TO AVOID ROUNDING ERROR */
   /* IN CALCULATION OF ORDER AMOUNT                      */
   if p_rnd_difference <> 0
   then
      p_disc_amt = p_disc_amt + p_rnd_difference.

END PROCEDURE. /* adjustDiscountAmount */

PROCEDURE getShipToAndDockID:
   /* THIS PROCEDURE RETURNS SHIP-TO AND DOCK RELATED TO THE CUSTOMER. */

   define input  parameter p_ShipTo   as character no-undo.
   define output parameter p_ShipToID as character no-undo.
   define output parameter p_DockID   as character no-undo.

   define variable         l_addr        as character no-undo.

   for first ad_mstr
      fields(ad_domain ad_addr ad_ref)
      where ad_domain = global_domain
      and   ad_addr   = p_ShipTo
   no-lock:
   end. /* FOR FIRST ad_mstr */
   if available ad_mstr
   then do:
      /* THIS LOGIC FINDS THE Ship-To OF THE ENTERED ADDRESS IF IT IS A DOCK */
      p_ShipToID = p_ShipTo.

      for first ls_mstr
         fields(ls_domain ls_addr ls_type)
         where ls_domain = global_domain
         and   ls_addr   = ad_addr
         and  (ls_type   = "ship-to"
          or   ls_type   = "customer")
      no-lock:
      end. /* FOR FIRST ls_mstr */

      do while not available ls_mstr
         and ad_ref > "":
            l_addr = ad_ref.
            find ad_mstr
               where ad_domain = global_domain
               and   ad_addr   = l_addr
            no-lock.

            find first ls_mstr
               where ls_domain = global_domain
               and   ls_addr   = ad_addr
               and  (ls_type   = "ship-to"
                  or ls_type   = "customer")
            no-lock no-error.

      end. /* DO WHILE NOT AVAILABLE ls_mstr */
      assign
         p_ShipToID = ad_addr
         p_DockID   = p_ShipTo.
   end. /* IF AVAILABLE ad_mstr */
END PROCEDURE.  /* getShipToAndDockID */
