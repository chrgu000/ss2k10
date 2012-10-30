/* yytriger.p : Change xxqad_ctrl                                          */
/* Revision: 1.0           BY: Leo Zhou (SH)              DATE: 11/25/07   */

find first xxqad_ctrl no-error.
if not avail xxqad_ctrl then create xxqad_ctrl.


if xxqad_so = "1" or 
   xxqad_basic1 = "1"  or
   xxqad_basic2 = "1"  or
   xxqad_basic3 = "1"  or
   xxqad_basic4 = "1"  or
   xxqad_basic5 = "1"  or
   xxqad_basic6 = "1"  or
   xxqad_basic7 = "1"  or
   xxqad_basic8 = "1"  or
   xxqad_basic9 = "1"
   then return.


assign  xxqad_so = "1"
        xxqad_basic1 = "1"
	xxqad_basic2 = "1"
	xxqad_basic3 = "1"
	xxqad_basic4 = "1"
	xxqad_basic5 = "1"
	xxqad_basic6 = "1"
	xxqad_basic7 = "1"
	xxqad_basic8 = "1"
	xxqad_basic9 = "1".

