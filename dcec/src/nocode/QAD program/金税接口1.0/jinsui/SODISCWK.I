/* GUI CONVERTED from sodiscwk.i (converter v1.69) Mon Jul  8 14:13:33 1996 */
/* sodiscwk.i - Workfile include for sales order discounts              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 8.5      LAST MODIFIED: 12/27/95   BY: afs *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 06/14/96   BY: DAH *J0T0*          */

	 /***************************************************************
	 * This file contains the definition for the workfile           *
	 * disc_wkfl, used to store summary (whole order) discount      *
	 * information items during sales order maintenance,            *
	 * and definitions of variables used by the discont-related     *
	 * include files sopiprn1.i and sopiprn2.i.                     *
	 ***************************************************************/

	 define      shared variable disc_det_key  like lngd_key1
						   initial "1".
	 define      shared variable disc_sum_key  like lngd_key1
						   initial "1".
	 define             variable prnt_disc_amt like pih_amt.
/*J0T0*/ define             variable prnt_sum_disc_amt like pih_amt.
	 define             variable amt_type      like pih_amt_type.

	 define {&new} shared workfile disc_wkfl
	    field disc_prilist  like pih_list
	    field disc_extamt   like pih_amt
	    field disc_disc_amt like pih_disc_amt
	    field disc_desc     like pi_desc
	    field disc_amt_type like pih_amt_type
	    .

	 FORM /*GUI*/ 
	    space(5)
	    pi_desc
	    amt_type
	    prnt_disc_amt
	 with frame disc_print down width 80 THREE-D /*GUI*/.


/*J0T0*/ FORM /*GUI*/ 
/*J0T0*/    space(5)
/*J0T0*/    disc_desc
/*J0T0*/    amt_type
/*J0T0*/    prnt_sum_disc_amt
/*J0T0*/ with frame disc_sum_print down title color normal "  ÕÛ¿Û»ã×Ü "
/*J0T0*/    width 80 THREE-D /*GUI*/.

