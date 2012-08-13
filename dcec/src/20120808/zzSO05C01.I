/* GUI CONVERTED from so05c01.i (converter v1.69) Sat Mar 30 01:22:43 1996 */
/* so05c01.i - SALES ORDER PRINT INCLUDE FILE                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 6.0    LAST MODIFIED:  12/27/90   BY: MLB *D238**/
/* REVISION: 6.0      LAST MODIFIED: 12/16/91   BY: MLV *D962**/
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: dld *F322**/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

	    FORM /*GUI*/ 
	       billattn       colon 15 /* label "Contact"  */
	       shipattn       colon 53 /* label "Contact" */
	       billphn        colon 15 /* label "Telephone" */
	       shipphn        colon 53 /* label "Telephone" */
	       billfax		  colon 15  label "传真" /* label fax lb01*/
	       shipfax		  colon 53  label "传真"   /* label fax lb01 */
	       skip (1)
/*lb01*--
/*F322         so_slspsn[1]   colon 15 /* label "Salesperson" */          */
/*F322*/       so_slspsn[1]   colon 15    label "推销员"
/*F322         so_slspsn[2]   label "[2]"                                 */
/*F322*/       so_slspsn[2]               no-label
/*F322*/       so_slspsn[3]   at 17       no-label
/*F322*/       so_slspsn[4]               no-label
---lb01*/
/*lb01--*/
			saleattn colon 15    label "销售工程师"   
			salephn	 colon 15	 label "电话"
			salephn2 no-label
			salefax	 colon 15    label "传真"
			saleqry	 colon 15    label "发货查询电话"
/*--Lb01*/
	       so_po          colon 59 /* label "Purchase Order" */
	       so_cr_terms    colon 15 /* label "Credit Terms" */
	   /*    so_shipvia     colon 59 /* Label "Ship Via" */ */
	       termsdesc      colon 15 no-label
	       so_fob         colon 59 /* label "FOB" */
	       resale         colon 15 /* label "Resale" */
	       so_rmks        colon 15 /* label "Remarks" */
	       skip (1)
	    with STREAM-IO /*GUI*/  frame phead3 side-labels width 90.
