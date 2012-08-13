/* GUI CONVERTED from iclotr02.p (converter v1.69) Sat Mar 30 01:15:29 1996 */
/* iclotr02.p - INVENTORY TRANSFER SINGLE ITEM (RESTRICTED)             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0     LAST MODIFIED: 07/02/92    BY: pma *F701*          */
/* REVISION: 7.0     LAST MODIFIED: 10/20/03    BY: Kevin             */

	 {mfdeclre.i} /*GUI moved to top.*/
	 define new shared variable trtype as character.

/*GUI moved mfdeclre/mfdtitle.*/

	 trtype = "SITE/LOC".
	 {gprun.i ""zziclotr.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

