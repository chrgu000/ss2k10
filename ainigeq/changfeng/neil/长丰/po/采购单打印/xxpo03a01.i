/* po03a01.i - PURCHASE ORDER PRINT INCLUDE FILE                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.3 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 5.0    LAST MODIFIED: 03/28/90   BY: MLB *B615**/
/* REVISION: 6.0    LAST MODIFIED: 08/14/91   BY: RAM *D828**/
/* REVISION: 6.0    LAST MODIFIED: 11/05/91   BY: RAM *D913**/
/* REVISION: 7.3    LAST MODIFIED: 02/22/93   BY: JMS *G712**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 07/28/99   BY: *N01B* John Corda         */
/* REVISION: 9.1      LAST MODIFIED: 07/31/00   BY: *N0GV* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.6.1.3 $  BY: Jean Miller         DATE: 12/05/01  ECO: *P039*  */
/* $Revision: 1.6.1.3 $  BY: Micho Yang          DATE: 03/20/06  ECO: *ss - 20060320*  */
/* By: Neil Date: 20061128 ECO: *ss 20061128.1 */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* NOTE:  This file compiles into porp0301.p                */

/* SS - Micho 20060320 B */
/*
form
   header         skip (3)
   billto[1]      at 4
   getTermLabelRt("BANNER_PURCHASE_ORDER",38) to 80 format "x(38)"
   billto[2]      at 4
   /* DISPLAYS "SIMULATION" TEXT, IF REPORT IS RUN IN SIMULATION MODE */
   if not update_yn and po_print then
      getTermLabel("BANNER_SIMULATION",28)
   else
      ""          at 44 format "x(28)"
   billto[3]      at 4
   getTermLabelRtColon("ORDER_NUMBER",14) to 56 format "x(14)"
   po_nbr
   getTermLabelRtColon("REVISION",10)    to 76 format "x(10)"
   po_rev
   billto[4]      at 4
   getTermLabelRtColon("ORDER_DATE",14)  to 56 format "x(14)"
   po_ord_date
   getTermLabelRtColon("PAGE_OF_REPORT",10)    to 76 format "x(10)"
   string         (page-number - pages,">>9")format "x(3)"
   billto[5]      at 4
   getTermLabelRtColon("PRINT_DATE",14)  to 56 format "x(14)"
   today
   billto[6]      at 4
   duplicate      to 80 skip (1)
   getTermLabel("SUPPLIER",20) + ": " +
   po_vend at 8 format "x(30)"
   getTermLabel("SHIP_TO",20) + ": " +
   poship at 46 format "x(30)"  skip (1)
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
   vdattn               skip (1)
   getTermLabelRtColon("CONFIRMING",14)  to 14 format "x(14)"
   po_confirm
   getTermLabelRtColon("SUPPLIER_TELEPHONE",20) to 54 format "x(20)"
   vend_phone
   getTermLabelRtColon("BUYER",14)  to 14 format "x(14)"
   po_buyer
   getTermLabelRtColon("CONTACT",15) to 54 format "x(15)"
   po_contact
   getTermLabelRtColon("CREDIT_TERMS",14)  to 14 format "x(14)"
   po_cr_terms
   getTermLabelRtColon("SHIP_VIA",15) to 54 format "x(15)"
   po_shipvia
   " "            to 14
   terms
   getTermLabelRtColon("FOB",10) to 54 format "x(10)"
   po_fob
   getTermLabelRtColon("REMARKS",14)  to 14 format "x(14)"
   po_rmks
   vatreglbl to 14
   vatreg
   skip(1)
with frame phead1 page-top width 90.
*/
/* ss 20061128.1 - b
form
   header         skip (3)
   billto[1]   AT 20
   "地址:" +    billto[2] +  "  邮编:"  +    billto[3]   AT 20 FORMAT "x(70)"     
   "TEL :" +    billto[4]  + "  FAX :"  +    billto[5]   AT 20 FORMAT "x(70)"
   
   SKIP(1)
   getTermLabelRtColon("ORDER_NUMBER",14) to 56 format "x(14)"
   po_nbr
   getTermLabelRtColon("REVISION",10)    to 76 format "x(10)"
   po_rev
   getTermLabelRt("BANNER_PURCHASE_ORDER",38) AT 8 format "x(18)"
   getTermLabelRtColon("ORDER_DATE",14)  to 56 format "x(14)"
   po_ord_date
   getTermLabelRtColon("PAGE_OF_REPORT",10)    to 76 format "x(10)"
   string         (page-number - pages,">>9")format "x(3)"
   getTermLabelRtColon("PRINT_DATE",14)  to 56 format "x(14)"
   today
   duplicate      to 80  SKIP(1)
   getTermLabel("SUPPLIER",20) + ": " +
   po_vend at 5 format "x(30)"   
   getTermLabel("SHIP_TO",20) + ": " +
   poship at 46 format "x(30)" 

   vendor[1]      AT 5
   shipto[1]      AT 46 
   vendor[2]      AT 5  FORMAT "x(40)"
   shipto[2]      AT 46 FORMAT "x(40)"
   vendor[3] + " " + vendor[5] + ", " + vendor[4] + ", " + vendor[6] AT 5
   shipto[3] + " " + shipto[5] + ", " + shipto[4] + ", " + shipto[6] AT 46
   "联系人:"      AT 5 vdattn AT 13 FORMAT "x(8)" 
    "(" + vend_phone + ")" AT 25 FORMAT "x(18)"
   "采购员:"      AT 46 vship_attn AT 54 FORMAT "x(8)" 
    "(" + vship_phone + ")" AT 68 FORMAT "x(18)"

   skip(1)
with frame phead1 page-top width 90.
/* SS - Micho 20060320 E */
 * ss - 20061128.1 - e */
/* ss 20061128.1 - b */
form
   "湖南长丰汽车沙发有限公司"   AT 25
   "采购单" at 35
with frame phead1 page-top width 90.
/* ss 20061128.1 - b */
