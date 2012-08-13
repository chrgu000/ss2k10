/* txnew.i - CHECKS IF TAX MANAGEMENT IS IN USE                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3            CREATED: 12/10/92   BY: bcm *G401*          */
/* REVISION: 7.3      LAST MODIFIED: 02/04/92   by: bcm *G633*          */
/* REVISION: 7.3      LAST MODIFIED: 02/10/92   by: bcm *G666*          */
/***************************************************************************/
/*!
    txnew.i     Checks for the existence of the system setting
		where the Tax Management module is in use.
*/
/***************************************************************************/


/*G401*/    /* tax92 BEGIN*/

/*G666*/    can-find(mfc_ctrl where mfc_field = "txc_use_new")

/*G633**    can-find(mfc_ctrl where mfc_field = "txc_use_new") */
/*G633*//*G666**    false */
