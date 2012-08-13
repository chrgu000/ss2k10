/* iclotr02.p - INVENTORY TRANSFER SINGLE ITEM (RESTRICTED)             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0     LAST MODIFIED: 07/02/92    BY: pma *F701*          */

	 define new shared variable trtype as character.

	 {mfdeclre.i}

	 trtype = "SITE/LOC".
	 {gprun.i ""zziclotr.p""}
