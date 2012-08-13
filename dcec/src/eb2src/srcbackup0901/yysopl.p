/* sopl.p - GENERAL PURPOSE SO MODULE PROCEDURE LIBRARY                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.2.1.1 $                                                           */
/*V8:ConvertMode=NoConvert                                                    */
/* Revision: 1.2          BY:Vivek Gogte          DATE:07/14/03   ECO: *N2GZ* */
/* $Revision: 1.2.1.1 $       BY:Mandar Gawde         DATE:04/23/04   ECO: *P1YF* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

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
    {pxmsg.i
               &MSGNUM=mc-error-number
               &ERRORLEVEL=2
                         }
     /*tfq {mfmsg.i mc-error-number 2} */
   end. /* if mc-error-number <> 0 */

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

   for first tx2d_det
      fields(tx2d_ref tx2d_nbr tx2d_line tx2d_tr_type tx2d_tax_in
             tx2d_tax_code )
      where (tx2d_ref     = p_tx2d_ref
             or tx2d_ref  = p_tx2d_nbr)
        and (tx2d_nbr     = ""
             or tx2d_nbr  = p_tx2d_ref
             or tx2d_nbr  = p_tx2d_nbr)
        and  tx2d_line    = p_line
        and  tx2d_tr_type = p_tax_tr_type
        and  tx2d_tax_in  = yes
      no-lock:

      for first tx2_mstr
         fields( tx2_tax_code tx2_tax_pct )
         where tx2_tax_code = tx2d_tax_code
      no-lock:

         p_ext_actual = p_ext_actual / (1 + tx2_tax_pct / 100).

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output p_ext_actual,
              input        p_rndmthd,
              output       mc-error-number)"}

         if mc-error-number <> 0
         then do:
           /*tfq {mfmsg.i mc-error-number 2} */
           {pxmsg.i
               &MSGNUM=mc-error-number
               &ERRORLEVEL=2
                         }

         end. /* IF mc-error-number <> 0 */

      end. /* FOR FIRST tx2_mstr */

   end. /* FOR FIRST tx2d_det ... */

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
      fields(ad_addr ad_ref)
      where ad_addr = p_ShipTo
   no-lock:
   end. /* FOR FIRST ad_mstr */
   if available ad_mstr
   then do:
      /* THIS LOGIC FINDS THE Ship-To OF THE ENTERED ADDRESS IF IT IS A DOCK */
      p_ShipToID = p_ShipTo.

      for first ls_mstr
         fields(ls_addr ls_type)
         where ls_addr = ad_addr
         and  (ls_type = "ship-to"
            or ls_type = "customer")
      no-lock:
      end. /* FOR FIRST ls_mstr */

      do while not available ls_mstr
         and ad_ref > "":
            l_addr = ad_ref.
            find ad_mstr
               where ad_addr = l_addr
            no-lock.

            find first ls_mstr
               where ls_addr = ad_addr
               and (ls_type = "ship-to" or ls_type = "customer")
            no-lock no-error.

      end. /* DO WHILE NOT AVAILABLE ls_mstr */
      assign
         p_ShipToID = ad_addr
         p_DockID   = p_ShipTo.
   end. /* IF AVAILABLE ad_mstr */
END PROCEDURE.  /* getShipToAndDockID */

