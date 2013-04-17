/* GUI CONVERTED from so05a01.i (converter v1.76) Sun Oct 21 17:39:20 2001 */
/* so05a01.i - SALES ORDER PRINT INCLUDE FILE                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.6 $                                                           */
/*V8:ConvertMode=Report                                                       */
/* NOTES:  To translate, change only what is in quotes below.                 */
/*         This file compiles into sorp0501.p.                                */
/*         If you want to change the order of the ship and                    */
/*          bill to addresses, you must also change the order                 */
/*          of the labels and fields.                                         */
/* REVISION: 6.0    LAST MODIFIED: 12/13/90    BY: dld *D257*                 */
/* REVISION: 6.0    LAST MODIFIED: 12/27/90    BY: MLB *D238*                 */
/* REVISION: 7.0    LAST MODIFIED: 04/06/92    BY: dld *F358*                 */
/* REVISION: 7.3    LAST MODIFIED: 02/19/93    By: jms *G712*                 */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane           */
/* REVISION: 8.6E   LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan          */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan          */
/* REVISION: 9.1    LAST MODIFIED: 07/30/99    BY: *N01B* John Corda          */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1    LAST MODIFIED: 07/24/00    BY: *N0GJ* Mudit Mehta         */
/* REVISION: 9.1    LAST MODIFIED: 08/23/00    BY: *N0ND* Mark Brown          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.6.1.6 $    BY: Tiziana Giustozzi     DATE: 10/01/01  ECO: *N138*      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/



/*GUI preprocessor directive settings */
 &SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

define variable c-cont as character format "x(35)" no-undo.


c-cont = CAPS(dynamic-function('getTermLabelFillCentered' in h-label,
              input "CONTINUED",
              input 35,
              input '*')).

FORM /*GUI*/  header
   skip (3)
   company[1]     at 4
   getTermLabelRt("BANNER_SALES_ORDER",30) to 80 format "x(30)"
   company[2]     at 4

   /* DISPLAYS "SIMULATION" TEXT, IF REPORT IS RUN IN SIMULATION MODE */
   if not update_yn then
      getTermLabel("BANNER_SIMULATION",28)
   else
      ""          at 44 format "x(28)"

   company[3]  at 4
   getTermLabelRtColon("ORDER_NUMBER",14) to 56 format "x(14)"
   so_nbr      at 58
   getTermLabelRtColon("REVISION",10)   to 76 format "x(10)"
   so_rev      to 80
   company[4]  at 4
   getTermLabelRtColon("ORDER_DATE",14) to 56 format "x(14)"
   so_ord_date at 58
   getTermLabel("PAGE_OF_REPORT",4) + ": " +
   string(page-number - pages,">>9") format "X(9)" to 80
   company[5]  at 4
   getTermLabelRtColon("PRINT_DATE",14) to 56 format "x(14)"
   today       at 58
   company[6]  at 4
/*judy 07/06/05*/ getTermLabelRtColon("xxfax_date",12) to 56 format "x(14)"  skip   /*"传真日期:"*/
   trim(getTermLabelRtColon("CONSIGNED",12)) + string(so_consignment) format "x(30)" at 4
   trim(getTermLabelRtColon("CONSIGNMENT_LOCATION",22)) + so_consign_loc format "x(22)" colon 44
   skip (1)
/*judy 07/06/05*/ /*with STREAM-IO /*GUI*/  frame phead1 page-top width 90.*/
/*judy 07/06/05*/ with STREAM-IO /*GUI*/  frame phead1 /*page-top*/ width 90.

FORM /*GUI*/
   so_cust        colon 15
   so_ship        colon 53 skip (1)
   billto[1]      at 8 no-label
   shipto[1]      at 46 no-label
   billto[2]      at 8  no-label
   shipto[2]      at 46 no-label
   billto[3]      at 8  no-label
   shipto[3]      at 46 no-label
   billto[4]      at 8  no-label
   shipto[4]      at 46 no-label
   billto[5]      at 8  no-label
   shipto[5]      at 46 no-label
   billto[6]      at 8  no-label
   shipto[6]      at 46 no-label
   skip(1)
/*judy 07/06/05*/ /*with STREAM-IO /*GUI*/  frame phead2 side-labels page-top width 90. */
/*judy 07/06/05*/ with STREAM-IO /*GUI*/  frame phead2 side-labels /*page-top*/ width 90.


/* SET EXTERNAL LABELS */
setFrameLabels(frame phead2:handle).

FORM /*GUI*/  header
   fill("-",77)   format "x(77)" skip
   space(30)
   c-cont
   skip(8)
with STREAM-IO /*GUI*/  frame continue page-bottom width 80.

assign
   prepaid-lbl = getTermLabel("AMOUNT_PAID",11) + ":"
   total-lbl = so_cur + " " + getTermLabel("TOTAL",7) + ":".
