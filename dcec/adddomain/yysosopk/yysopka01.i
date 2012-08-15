/* GUI CONVERTED from sopka01.i (converter v1.75) Thu Aug 17 11:51:04 2000 */
/* sopka01.i - SALES ORDER PRINT INCLUDE FILE                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 5.0    LAST MODIFIED: 03/28/90   BY: MLB *B615**/
/* REVISION: 7.0    LAST MODIFIED: 03/26/92   BY: dld *F322**/
/* REVISION: 7.0    LAST MODIFIED: 04/30/92   BY: tjs *F444**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/23/99   BY: *N01B* Poonam Bahl  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0JM* Mudit Mehta      */

/* NOTE:  to translate change only what is in quotes below */
/*        this file compiles into sopk01.p                 */


/* ********** Begin Translatable Strings Definitions ********* */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

&SCOPED-DEFINE sopka01_i_7 "Salespersons"
/* MaxLen: Comment: */

/*N0JM*------------START COMMENT----------------
 * &SCOPED-DEFINE sopka01_i_1 "Order Date:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE sopka01_i_2 "Print Date:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE sopka01_i_3 "Order Number:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE sopka01_i_4 "P A C K I N G   L I S T"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE sopka01_i_5 "Page:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE sopka01_i_6 "Ship To:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE sopka01_i_8 "Sold To:"
 * /* MaxLen: Comment: */
 *
 * /*N01B*/ &SCOPED-DEFINE sopka01_i_9 "S I M U L A T I O N"
 * /*N01B*/ /* MaxLen: 28 Comment: IDENTIFICATION FOR SIMULATION MODE */
 *N0JM*----------END COMMENT----------------- */

/* ********** End Translatable Strings Definitions ********* */
     FORM /*GUI*/ 
        header         skip (3)
  /*judy 07/07/05*/ /*       company[1]     at 4
/*N0JM*  {&sopka01_i_4} to 79 */
/*N0JM*/ getTermLabelRt("BANNER_PACKING_LIST",30) to 79 format "x(30)"
        company[2]     at 4
/*N01B*/ if not update_yn then
/*N0JM* /*N01B*/ {&sopka01_i_9} */
/*N0JM*/    getTermLabelRt("BANNER_SIMULATION",28)
/*N01B*/ else
/*N01B*/    ""         to 79 format "x(28)"
        company[3]     at 4
/*N0JM*  {&sopka01_i_3} to 61 */
/*N0JM*/ getTermLabelRtColon("ORDER_NUMBER",18) to 61 format "x(18)"
        so_nbr         at 63
/*N0JM*  {&sopka01_i_5} */
/*N0JM*/ getTermLabelRtColon("PAGE",5)
        +
        string         (page-number - pages,">>9") to 80
        company[4]     at 4
/*N0JM*  {&sopka01_i_1} to 61 */
/*N0JM*/ getTermLabelRtColon("ORDER_DATE",18) to 61 format "x(18)"
        so_ord_date    at 63
        company[5]     at 4
/*N0JM*  {&sopka01_i_2} to 61 */
/*N0JM*/ getTermLabelRtColon("PRINT_DATE",18) to 61 format "x(18)"
        today          at 63
 /*judy 07/07/05*/   /*/*B056*/    company[6]     at 4 skip (1)*/
 /*judy 07/07/05*/  company[6]     at 4 */
 
   /*judy 07/07/05*/    getTermLabelRt("XXBANNER_PACKING_LIST",30) to 40  format "x(30)" 
   /*judy 07/07/05*/   getTermLabelRtColon("PAGE",5)
   /*judy 07/07/05*/      +
    /*judy 07/07/05*/     string         (page-number - pages,">>9") to 61
    /*judy 07/07/05*/   company[1] AT 4
    /*judy 07/07/05*/   getTermLabelRtColon("ORDER_NUMBER",18) to 61 format "x(18)"
    /*judy 07/07/05*/    so_nbr         at 63
    /*judy 07/07/05*/    company[2]     at 4
   /*judy 07/07/05*/  getTermLabelRtColon("ORDER_DATE",18) to 61 format "x(18)"
   /*judy 07/07/05*/     so_ord_date    at 63
   /*judy 07/07/05*/     company[3]     at 4
  /*judy 07/07/05*/   getTermLabelRtColon("PRINT_DATE",18) to 61 format "x(18)"
   /*judy 07/07/05*/     today          at 63
 /*N0JM*
 * /*F444   "Bill To:" */ {&sopka01_i_8}  at 8
 *      so_cust
 *      {&sopka01_i_6}     at 46
 *      so_ship        skip (1)
 *N0JM*/
 /*judy 07/07/05*/ /*/*N0JM*/ getTermLabel("SOLD_TO",20) + ": " +
 /*judy 07/07/05*//*N0JM*/ so_cust at 8 format "x(30)"
 /*judy 07/07/05*//*N0JM*/ getTermLabel("SHIP_TO",20) + ": " +
 /*judy 07/07/05*/ /*N0JM*/ so_ship at 46 format "x(30)" skip (1)*/
 /*judy 07/07/05*/   getTermLabel("SOLD_TO",20) + ": "  AT 4
 /*judy 07/07/05*/   so_cust 
 /*judy 07/07/05*/    getTermLabel("SHIP_TO",20) + ": "  TO 61
 /*judy 07/07/05*/   so_ship at 63 

 /*judy 07/07/05*/  /*          
 /*judy 07/07/05*/    billto[1]      at 8
  /*judy 07/07/05*/          shipto[1]      at 46
  /*judy 07/07/05*/          billto[2]      at 8
  /*judy 07/07/05*/          shipto[2]      at 46
  /*judy 07/07/05*/          billto[3]      at 8
  /*judy 07/07/05*/          shipto[3]      at 46
  /*judy 07/07/05*/          billto[4]      at 8
  /*judy 07/07/05*/          shipto[4]      at 46
  /*judy 07/07/05*/          billto[5]      at 8
  /*judy 07/07/05*/          shipto[5]      at 46
  /*judy 07/07/05*/          billto[6]      at 8
  /*judy 07/07/05*/          shipto[6]      at 46  skip (2)*/
    
     with STREAM-IO /*GUI*/  frame phead1 page-top width 90.
/*F322
 *       form
 *          so_slspsn[1] colon 15    /* label "Salesperson" */
 *          so_slspsn[2]             label "[2]"
 *          so_po        colon 59    /* label "Purchase Order" */
 *          so_cr_terms  colon 15    /* label "Credit Terms" */
 *          so_shipvia   colon 59    /* label "Ship Via"    */
 *          termsdesc    colon 15 no-label
 *          so_fob       colon 59    /* label "FOB" */
 *          so_rmks      colon 15    /* label "Remarks" */
 *          so_rmks        skip (2)
 *        with frame phead2 side-labels width 90.
 *F322*/

/*F322*/ /* Altered form for the addition of two salespersons. */
     FORM /*GUI*/ 
/*judy 07/07/05*/  /*      so_slspsn[1] colon 15    label {&sopka01_i_7}*/
/*judy 07/07/05*/       so_slspsn[1] AT 4   label {&sopka01_i_7} 
  /*judy 07/07/05*/   /*        so_slspsn[2]             no-label*/
    /*judy 07/07/05*/ /*     so_po        colon 59    /* label "Purchase Order" */*/
    /*judy 07/07/05*/     so_po        AT 26    /* label "Purchase Order" */
  /*judy 07/07/05*/  /*        so_slspsn[3] at 17       no-label
  /*judy 07/07/05*/          so_slspsn[4]             no-label 
    /*judy 07/07/05*/        so_shipvia   colon 59    /* label "Ship Via"    */ */
     /*judy 07/07/05*/  /*    so_cr_terms  colon 15    /* label "Credit Terms" */*/
        /*judy 07/07/05*/      so_cr_terms  AT 64    /* label "Credit Terms" */
         /*judy 07/07/05*/   /*      so_fob       colon 59    /* label "FOB" */
     /*judy 07/07/05*/       termsdesc    colon 15 no-label*/
     /*judy 07/07/05*/  /*     so_rmks      colon 15    /* label "Remarks" */  skip (2)*/
     /*judy 07/07/05*/      so_rmks      AT 4    /* label "Remarks" */ 
           
      with STREAM-IO /*GUI*/  frame phead2 side-labels width 90.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame phead2:handle).
