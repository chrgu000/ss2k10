/* ct03a01.i - *Canadian Tax                                            */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* po03a01.i PURCHASE ORDER PRINT INCLUDE FILE    */
/* REVISION: 5.0    LAST MODIFIED: 03/28/90   BY: MLB *B615**/
/* REVISION: 5.0    LAST MODIFIED: 09/27/90   BY: SMM *C244*/
/* REVISION: 6.0    LAST MODIFIED: 01/02/91   BY: MLB *D238**/
/* REVISION: 6.0    LAST MODIFIED: 07/02/91   BY: MLV *D740**/
/* REVISION: 6.0    LAST MODIFIED: 08/14/91   BY: RAM *D828**/
/* REVISION: 6.0    LAST MODIFIED: 11/05/91   BY: RAM *D913**/
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E   LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1    LAST MODIFIED: 07/28/99   BY: *N01B* John Corda   */
/* REVISION: 9.1    LAST MODIFIED: 07/28/00   BY: *N0GV* BalbeerS Rajput*/
/* NOTE:  to translate change only what is in quotes below. */
/*        this file compiles into porp0301.p                */


/* ********** Begin Translatable Strings Definitions ********* */

/*N0GV*
 * &SCOPED-DEFINE ct03a01_i_1 "GST ID: "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_2 "Print Date:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_3 "FOB:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_4 "Order Date:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_5 "Credit Terms:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_6 "Order Number:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_7 "P U R C H A S E   O R D E R"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_8 "Page:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_9 "PST ID: "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_10 "Buyer:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_11 "Confirming:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_12 "Contact:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_13 "Supplier:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_14 "Supplier Telephone:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_15 "Ship Via:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_16 "Remarks:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_17 "Ship To:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ct03a01_i_18 "Revision:"
 * /* MaxLen: Comment: */
 *
 * /*N01B*/ &SCOPED-DEFINE ct03a01_i_19 "S I M U L A T I O N"
 * /*N01B*/ /* MaxLen: 28 Comment: IDENTIFICATION FOR SIMULATION MODE*/
 *N0GV*/

/* ********** End Translatable Strings Definitions ********* */

      form
         header         skip (3)
         billto[1]      at 4
/*N0GV*  {&ct03a01_i_7} to 80*/
/*N0GV*/ getTermLabelRt("BANNER_PURCHASE_ORDER",38) format "x(38)" to 80
         billto[2]      at 4

/*N01B*/ /* DISPLAYS "SIMULATION" TEXT, IF REPORT IS RUN IN SIMULATION MODE */

/*N01B*/ if not update_yn and po_print then
/*N0GV* /*N01B*/    {&ct03a01_i_19}*/
/*N0GV*/    getTermLabel("BANNER_SIMULATION",28)
/*N01B*/ else
/*N01B*/    ""          at 44 format "x(28)"

         billto[3]      at 4
/*N0GV*  {&ct03a01_i_6} to 56*/
/*N0GV*/ getTermLabelRtColon("ORDER_NUMBER",14) format "x(14)"         to 56
         po_nbr
/*N0GV*  {&ct03a01_i_18}    to 76*/
/*N0GV*/ getTermLabelRtColon("REVISION",10) format "x(10)"             to 76
         po_rev
         billto[4]      at 4
/*N0GV*  {&ct03a01_i_4}  to 56*/
/*N0GV*/ getTermLabelRtColon("ORDER_DATE",14) format "x(14)"           to 56
         po_ord_date
/*N0GV*  {&ct03a01_i_8}        to 76*/
/*N0GV*/ getTermLabelRtColon("PAGE_OF_REPORT",7) format "x(7)"         to 76
         string         (page-number - pages,">>9")format "x(3)"
         billto[5]      at 4
/*N0GV*  {&ct03a01_i_2}  to 56*/
/*N0GV*/ getTermLabelRtColon("PRINT_DATE",14) format "x(14)"           to 56
         today
         billto[6]      at 4
         duplicate      to 80 skip (1)
/*N0GV*  {&ct03a01_i_13}    at 8*/
/*N0GV*/ getTermLabel("SUPPLIER",27) + ": " +
         po_vend
/*N0GV*/    format "x(37)"                                             at 8
/*N0GV*  {&ct03a01_i_17}     at 46*/
/*N0GV*/ getTermLabel("SHIP_TO",32) + ": " +
/*N0GV*  poship       skip (1)*/
/*N0GV*/ poship format "x(42)"   at 46   skip (1)
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
         vdattnlbl      to 17
         vdattn       skip (1)
/*N0GV*  {&ct03a01_i_11}  to 14*/
/*N0GV*/ getTermLabelRtColon("CONFIRMING",14) format "x(14)"           to 14
         po_confirm
/*N0GV*  {&ct03a01_i_14} to 54*/
/*N0GV*/ getTermLabelRtColon("SUPPLIER_TELEPHONE",30) format "x(30)"   to 54
         vend_phone
/*N0GV*  {&ct03a01_i_10}       to 14*/
/*N0GV*/ getTermLabelRtColon("BUYER",14) format "x(14)"                to 14
         po_buyer
/*N0GV*  {&ct03a01_i_12}     to 54*/
/*N0GV*/ getTermLabelRtColon("CONTACT",20) format "x(20)"              to 54
         po_contact
/*N0GV*  {&ct03a01_i_5} to 14*/
/*N0GV*/ getTermLabelRtColon("CREDIT_TERMS",14) format "x(14)"         to 14
         po_cr_terms
/*N0GV*  {&ct03a01_i_15}    to 54*/
/*N0GV*/ getTermLabelRtColon("SHIP_VIA",20) format "x(20)"             to 54
         po_shipvia
         " "            to 14
         terms
/*N0GV*  {&ct03a01_i_3}         to 54*/
/*N0GV*/ getTermLabelRtColon("FOB",6) format "x(6)"                    to 54
         po_fob
/*N0GV*  {&ct03a01_i_1}     to 14*/
/*N0GV*/ getTermLabelRtColon("GST_ID",13) format "x(14)"               to 14
         po_fst_id
/*N0GV*  {&ct03a01_i_9}     to 14*/
/*N0GV*/ getTermLabelRtColon("PST_ID",13) format "x(14)"               to 14
         po_pst_id
/*N0GV*  {&ct03a01_i_16}     to 14*/
/*N0GV*/ getTermLabelRtColon("REMARKS",14) format "x(14)"              to 14
         po_rmks        skip (2)
      with frame phead1-can page-top width 90.
