/* po03a01.i - PURCHASE ORDER PRINT INCLUDE FILE                        */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 5.0    LAST MODIFIED: 03/28/90   BY: MLB *B615**/
/* REVISION: 6.0    LAST MODIFIED: 08/14/91   BY: RAM *D828**/
/* REVISION: 6.0    LAST MODIFIED: 11/05/91   BY: RAM *D913**/
/* REVISION: 7.3    LAST MODIFIED: 02/22/93   BY: JMS *G712**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 07/28/99   BY: *N01B* John Corda   */
/* REVISION: 9.1      LAST MODIFIED: 07/31/00   BY: *N0GV* Mudit Mehta  */
/* NOTE:  to translate change only what is in quotes below. */
/*        this file compiles into porp0301.p                */


/* ********** Begin Translatable Strings Definitions ********* */

/*N0GV*------------START COMMENT----------------
 * &SCOPED-DEFINE po03a01_i_1 "Buyer:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_2 "Order Number:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_3 "Contact:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_4 "Page:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_5 "Confirming:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_6 "Order Date:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_7 "P U R C H A S E   O R D E R"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_8 "Print Date:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_9 "Credit Terms:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_10 "FOB:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_11 "Remarks:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_12 "Ship Via:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_13 "Ship To:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_14 "Revision:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_15 "Supplier:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE po03a01_i_16 "Supplier Telephone:"
 * /* MaxLen: Comment: */
 *
 * /*N01B*/ &SCOPED-DEFINE po03a01_i_17 "S I M U L A T I O N"
 * /*N01B*/ /* MaxLen: 28 Comment: IDENTIFICATION FOR SIMULATION MODE*/
 *N0GV*----------END COMMENT----------------- */

/* ********** End Translatable Strings Definitions ********* */

      form
         header         skip (3)
/*N0GV*/ getTermLabelRt("BANNER_PURCHASE_ORDER",38) to 46 format "x(38)"         
				 billto[1]      at 4
/*N0GV*  {&po03a01_i_7} to 80 */
         billto[2]      at 4
/*N01B*/ /* DISPLAYS "SIMULATION" TEXT, IF REPORT IS RUN IN SIMULATION MODE */

/*N01B*/ if not update_yn and po_print then
/*N0GV* /*N01B*/    {&po03a01_i_17} */
/*N0GV*/    getTermLabel("BANNER_SIMULATION",28)
/*N01B*/ else
/*N01B*/    ""          at 44 format "x(28)"

         billto[3]      at 4
/*N0GV*  {&po03a01_i_2} to 56 */
/*N0GV*/ getTermLabelRtColon("ORDER_NUMBER",14) to 56 format "x(14)"
         po_nbr
/*N0GV*  {&po03a01_i_14}    to 76 */
/*N0GV*/ getTermLabelRtColon("REVISION",10)    to 76 format "x(10)"
         po_rev
         billto[4]      at 4
/*N0GV*  {&po03a01_i_6}  to 56 */
/*N0GV*/ getTermLabelRtColon("ORDER_DATE",14)  to 56 format "x(14)"
         po_ord_date
/*N0GV*  {&po03a01_i_4}        to 76 */
/*N0GV*/ getTermLabelRtColon("PAGE_OF_REPORT",10)    to 76 format "x(10)"
         string         (page-number - pages,">>9")format "x(3)"
         billto[5]      at 4
/*N0GV*  {&po03a01_i_8}  to 56 */
/*N0GV*/ getTermLabelRtColon("PRINT_DATE",14)  to 56 format "x(14)"
         today
         billto[6]      at 4
         duplicate      to 80 skip (1)
/*N0GV*
 *       {&po03a01_i_15}    at 8
 *       po_vend
 *       {&po03a01_i_13}     at 46
 *       poship               skip (1)
 *N0GV*/
/*N0GV*/ getTermLabel("SUPPLIER",20) + ": " +
/*N0GV*/ po_vend at 8 format "x(30)"
/*N0GV*/ getTermLabel("SHIP_TO",20) + ": " +
/*N0GV*/ poship at 46 format "x(30)"  skip (1)
         vendor[1]      at 8
         shipto[1]      at 46
         vendor[2]      at 8
         shipto[2]      at 46
         vendor[3]      at 8
         shipto[3]      at 46
         vendor[4]      at 8
         shipto[4]      at 46
         vendor[5]      at 8
         shipto[5]      at 46
         vendor[6]      at 8
         shipto[6]      at 46

/*       vdattnlbl      to 17  vdattn label*/
         vdattn         at 8    /*  skip (1) */
/*N0GV*/ getTermLabelRtColon("CONTACT",15) to 54 format "x(15)"
         po_contact         
/*N0GV*/ getTermLabelRtColon("PHONE",8) at 8 format "x(8)"
         vend_phone
/*N0GV*  {&po03a01_i_5}  to 14 */
/*N0GV getTermLabelRtColon("CONFIRMING",14)  to 14 format "x(14)"
         po_confirm
*/
/*N0GV*  {&po03a01_i_16} to 54 */

/*N0GV*  {&po03a01_i_1}       to 14 */
/*N0GV*/ getTermLabelRtColon("BUYER",14)  to 54 format "x(14)"
         po_buyer
/*N0GV*  {&po03a01_i_3}     to 54 */

/*N0GV*  {&po03a01_i_9} to 14 */
/*N0GV*/ getTermLabelRtColon("CREDIT_TERMS",14)  to 14 format "x(14)"
         po_cr_terms
/*N0GV*  {&po03a01_i_12}    to 54 */
/*N0GV*/ getTermLabelRtColon("SHIP_VIA",15) to 54 format "x(15)"
         po_shipvia
         " "            to 14
         terms
/*N0GV*  {&po03a01_i_10}         to 54 */
/*N0GV*/ getTermLabelRtColon("FOB",10) to 54 format "x(10)"
         po_fob
/*N0GV*  {&po03a01_i_11}     to 14 */
/*N0GV*/ getTermLabelRtColon("REMARKS",14)  to 14 format "x(14)"
         po_rmks
/*G712*/ /* skip (2) .......................................................*/
/*G712*/ {povtepfm.i}
/*G712*/ skip(1)
      with frame phead1 page-top width 90.