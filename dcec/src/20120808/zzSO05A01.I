/* GUI CONVERTED from so05a01.i (converter v1.69) Sat Mar 30 01:22:43 1996 */
/* so05a01.i - SALES ORDER PRINT INCLUDE FILE                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* NOTES:  To translate, change only what is in quotes below. */
/*         This file compiles into sorp0501.p.                */
/*         If you want to change the order of the ship and    */
/*          bill to addresses, you must also change the order */
/*          of the labels and fields.                         */
/* REVISION: 6.0    LAST MODIFIED: 12/13/90    BY: dld *D257**/
/* REVISION: 6.0    LAST MODIFIED:  12/27/90   BY: MLB *D238**/
/* REVISION: 7.0    LAST MODIFIED:  04/06/92   BY: dld *F358**/
/* REVISION: 7.3    LAST MODIFIED:  02/19/93   by: jms *G712**/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

	    FORM /*GUI*/ 
	       header         skip (3)
	       company[1]     at 4
	       "  客  户  订  单  " to 80
	       company[2]     at 4
	       company[3]     at 4
	       "订单号:" to 56
	       so_nbr         at 58
/*F358*/       "版本:"    to 76
/*F358*/       so_rev         to 80
	       company[4]     at 4
	       "订单日期:"  to 56
	       so_ord_date    at 58
/*F358*/       "页号" + ": " + string(page-number - pages,">>9") format "X(9)"
			      to 80
	       company[5]     at 4
	       "打印日期:"  to 56
	       today          at 58
	       company[6]     at 4 
	       "传真日期:"	to 56
	       skip (1)
	    with STREAM-IO /*GUI*/  frame phead1 /*page-top lb01*/ width 90.

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
/*G712*/ /*    skip (2) ....................................................*/
/*G712*/       skip(1)
	       with STREAM-IO /*GUI*/  frame phead2 side-labels /*page-top lb01*/ width 90.


	    FORM /*GUI*/  header
	       fill("-",77)   format "x(77)" skip
	       space(30)
	       "***  继 续  ***" skip(8)
	    with STREAM-IO /*GUI*/  frame continue page-bottom width 80.

prepaid-lbl = "已付金额:".
total-lbl = so_cur + " " + "合计:".
