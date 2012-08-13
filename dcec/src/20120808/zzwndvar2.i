/* GUI CONVERTED from wndvar2.i (converter v1.69) Sat Mar 30 01:26:36 1996 */
/* wndvar2.i - Scrolling Window Variables definitions.                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*G1GQ*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3    CREATED:       12/18/95              BY: jzs *G1GQ* */
/* REVISION: 7.3    LAST MODIFIED: 12/18/95              BY: jzs *G1LR* */

/*! Use for Scrolling Window programs when mfdeclre.i is already included.*/

/* These variables need to be able to be shared from SW program's caller */
/*G1LR*/ define new {1} variable sw_drop_in     like mfc_logical no-undo initial yes.
	 define new {1} variable sw_no_pivot    like mfc_logical no-undo.
	 define new {1} variable sw_at_end      like mfc_logical no-undo.
	 define new {1} variable sw_at_top      like mfc_logical no-undo.
	 define new {1} variable partial_ixval  as character no-undo.
	 define new {1} variable partial_ixlen  as integer no-undo.
	 define new {1} variable ix1array       as character extent 25 no-undo.
	 define new {1} variable ix2array       as character extent 25 no-undo.
	 define new {1} variable recidarray     as recid extent 25 no-undo.
	 define new {1} variable ixlastline     as integer no-undo.
/*	 define {1} variable i              as integer no-undo.*/
	 define new {1} variable j              as integer no-undo.
	 define new {1} variable field_nbr      as integer no-undo.
	 define new {1} variable frame_val_save as character no-undo.
	 define new {1} variable selectall      like mfc_logical.
	 define new {1} variable repaint        like mfc_logical no-undo initial yes.
	 define new {1} variable up_jump        as integer no-undo initial 1.
	 define new {1} variable wtemp3         as character no-undo.
	 define new {1} variable spcs           as character no-undo
   	    initial "                                                   ".

/* These variables are globals in mf1.i not mfdeclre.i */
	 define shared variable window_recid as recid.
	 define shared variable global_recid as recid.


