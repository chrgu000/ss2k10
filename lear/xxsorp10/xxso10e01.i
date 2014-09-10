/* so10e01.i - DEFINE FRAME FOR INVOICE LINE ITEM INFORMATION                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.19 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/*so10e01.i INVOICE PRINT include file                                        */
/* REVISION: 5.0    LAST MODIFIED:  03/12/89   BY: MLB *B615                  */
/* REVISION: 6.0    LAST MODIFIED:  07/05/90   BY: WUG *D043*                 */
/* REVISION: 8.5    LAST MODIFIED:  08/31/95   BY: taf *J053*                 */
/* REVISION: 8.5    LAST MODIFIED:  06/26/96   BY: *J0WF* Sue Poland          */
/* REVISION: 8.5    LAST MODIFIED:  08/16/96   BY: *G29K* Markus Barone       */
/* REVISION: 8.6E   LAST MODIFIED:  02/23/98   BY: *L007* A. Rahane           */
/* REVISION: 8.6E   LAST MODIFIED:  04/23/98   BY: *L00L* EvdGevel            */
/* REVISION: 8.6E   LAST MODIFIED:  05/20/98   BY: *K1Q4* Alfred Tan          */
/* REVISION: 8.6E   LAST MODIFIED:  06/04/98   BY: *L01M* Jean Miller         */
/* REVISION: 9.0    LAST MODIFIED:  11/20/98   BY: *J33Y* Poonam Bahl         */
/* REVISION: 9.0    LAST MODIFIED:  03/13/99   BY: *M0BD* Alfred Tan          */
/* REVISION: 9.1    LAST MODIFIED:  10/07/99   BY: *K23H* Sachin Shinde       */
/* REVISION: 9.1    LAST MODIFIED:  03/24/00   BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1    LAST MODIFIED:  05/02/00   BY: *L0X1* Veena Lad           */
/* REVISION: 9.1    LAST MODIFIED:  08/12/00   BY: *N0JM* Mudit Mehta         */
/* REVISION: 9.1    LAST MODIFIED:  08/25/00   BY: *N0P0* Arul Victoria       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.19 $    BY: Jean Miller          DATE: 04/16/02  ECO: *P05S*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*       the translated text should be the same size if possible*/
/*       this include file is called by sorp1a01.p              */
/* INVOICE REPRINT, ANY CHANGES MADE HERE WILL BE NEEDED IN SOIVRP1A.P */

define variable cont_lbl as character format "x(10)".

assign cont_lbl = dynamic-function('getTermLabelFillCentered' in h-label,
                                   input "CONTINUE", input 10, input '*').

/* FOR CALL INVOICES, WE DON'T ALWAYS PRINT THE PRICE BECAUSE,     */
/* WHEN IT'S NOT A 'FIXED PRICE REPAIR' (MEANING WHENEVER PART     */
/* NUMBER X GETS FIXED, IT COSTS $100, FOR EXAMPLE), SOD_PRICE IS  */
/* THE TOTAL OF ALL LABOR/EXPENSES/PARTS USED IN THE REPAIR LESS   */
/* EXCHANGE CREDITS, LESS CONTRACT COVERAGE.  AND, THAT PRICE IS   */
/* FOR THE FULL QUANTITY OF PARTS REPAIRED - IT'S NOT A UNIT PRICE */
/* SO, IT DOESN'T MAKE SENSE TO PRINT IT THAT WAY. HOWEVER, WHEN   */
/* FIXED PRICE REPAIRS ARE BEING INVOICED, THE GROSS FIXED PRICE   */
/* DOES PRINT IN THE 'PRICE' COLUMN.  THE NET PRICE DISPLAYED IS   */
/* NET OF ANY EXCHANGE CREDIT GIVEN.                               */

/* ALSO, FOR CALL INVOICES, AS WE DON'T REALLY 'SHIP' ANYTHING,    */
/* THE QUANTITY OF INTEREST IS THE QUANTITY REPAIRED ON THE CALL   */
/* LINE.  THEREFORE, PRINT THAT INSTEAD OF QTY TO INVOICE AND      */
/* PRINT NO BACKORDER QUANTITY (BECAUSE THERE ISN'T ANY).          */

if sod_fsm_type <> "FSM-RO" then
assign
   ext_price:label in frame d     = getTermLabel("EXTENDED_PRICE",16)
   ext_price:label in frame deuro = getTermLabel("EXTENDED_PRICE",16).
else
assign
   ext_price:label in frame d     = getTermLabel("NET_PRICE",16)
   ext_price:label in frame deuro = getTermLabel("NET_PRICE",16).

if not et_dc_print then do:

   display
      sod_part
      sod_um
      sod_qty_inv      format "->>>>>>9.9<<<<<" when (sod_fsm_type <> "FSM-RO")
      itm_qty_call     when (sod_fsm_type = "FSM-RO" and available itm_det)
         @ sod_qty_inv format "->>>>>>9.9<<<<<"
      qty_bo           column-label "Backorder" when (sod_fsm_type <> "FSM-RO")
      sod_taxable
      sod_price        when(sod_fsm_type <> "FSM-RO" or
                           (sod_fsm_type = "FSM-RO" and sod_fix_pr = no))
      sod_fixed_price  when (sod_fsm_type = "FSM-RO" and sod_fix_pr)
         @ sod_price
      ext_price
/*roger*/   np_fp   LABEL "类型"
   with frame d no-attr-space.

end. /* if not et_dc_print then */

/* ADDED FOLLOWING SECTION */
else if et_dc_print then do:

   {etdcrd.i so_curr 78 94}

   display
      sod_part
      sod_um
      sod_qty_inv
      qty_bo
      sod_taxable
      sod_price
      ext_price
      et_ext_price column-label " Currency Price"
/*roger*/   np_fp   LABEL "类型"
   with no-attr-space down width 132 frame deuro.

end.
