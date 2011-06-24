/* po03b01.i - PURCHASE ORDER PRINT INCLUDE FILE                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.5 $                                                         */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 5.0     LAST MODIFIED: 03/28/90    BY: MLB *B615**/
/* REVISION: 6.0     LAST MODIFIED: 05/24/90    BY: WUG *D002**/
/* REVISION: 6.0     LAST MODIFIED: 06/14/90    BY: RAM *D030**/
/* REVISION: 6.0     LAST MODIFIED: 11/05/91    BY: RAM *D913**/
/* REVISION: 7.0     LAST MODIFIED: 04/09/93    BY: afs *G926**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 05/24/00   BY: *N09M* Peter Faherty */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown    */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.6.1.4  BY: Rajiv Ramaiah       DATE: 09/05/01 ECO: *N120* */
/* $Revision: 1.6.1.5 $       BY: Falguni Dalal       DATE: 12/21/01 ECO: *N176* */

/* NOTE:  To translate, change only what is in quotes below.  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*        This file compiles into porp0301.p                  */

assign
   dup-lbl       = "*" + caps(getTermLabel("DUPLICATE",9)) + "*"
   prepaid-lbl   = getTermLabel("AMOUNT_PREPAID",18) + ":"
   by-lbl        = getTermLabel("BY",02) + ":"
   signature-lbl = getTermLabelRt("AUTHORIZED_SIGNATURE",30)

   y-lbl         = "Y"            /*meaning "yes", limited to 1 char*/
   n-lbl         = "N"            /*meaning "no",  limited to 1 char*/

   rev-lbl       = getTermLabel("REVISION",8) + ": "  /*limited to 10 char*/
   vpart-lbl     = getTermLabel("SUPPLIER_ITEM",13) + ": "
   manuf-lbl     = getTermLabel("MANUFACTURER",12) + ": "
   part-lbl      = getTermLabel("ITEM",4) + ": "      /*limited to 6 char*/
   site-lbl      = getTermLabel("SITE",4) + ": "      /*limited to 6 char*/
   type-lbl      = getTermLabel("TYPE",4) + ": "      /*limited to 6 char*/
   cont-lbl      = "***" +
                   (dynamic-function('getTermLabelFillCentered' in h-label,
                      input "CONTINUE",
                      input 06,
                      input "*")) + "***"             /*limited to 12 char*/
   disc-lbl      = getTermLabel("DISCOUNT",4) + ": "  /*limited to 5 char*/
   vd-attn-lbl   = caps(getTermLabelRtColon("ATTENTION",16))
                   /*limited to 16 char*/
   substring(lot-lbl,1,30,"RAW")
                 = getTermLabel("LOT/SERIAL_NUMBERS_SHIPPED",29) + ":"
   substring(lot-lbl,32,5,"RAW")
                 = getTermLabel("QUANTITY",5)
   substring(lot-lbl,38,6,"RAW")
                = getTermLabel("EXPIRE",6).
                  /*limited to 43 char*/
