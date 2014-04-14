/* mfrtrail.i - REPORT TRAILER INCLUDE FILE                             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 1.0     Created  : 03/13/86    BY: EMB        */
/* REVISION: 4.0     LAST EDIT: 03/03/89    BY: WUG *B060* */
/* REVISION: 5.0     LAST EDIT: 06/29/89    BY: emb *B164* */
/* REVISION: 5.0     LAST EDIT: 02/15/90    BY: WUG *B569* */
/* REVISION: 5.0     LAST EDIT: 05/23/90    BY: emb *B695* */
/* REVISION: 7.3     LAST EDIT: 03/23/95    BY: jzs *G0FB* */
/* REVISION: 7.3     LAST EDIT: 02/04/96    BY: dzn *G1KT* */
/* REVISION: 8.5     LAST EDIT: 11/04/96    BY: *J17M* Cynthia J. Terry */
/************************************************************************/
/*!
    {1} "stream name"    if necessary
*/
/************************************************************************/

/*! GUI cannot do a VIEW FRAME A to get the criteria fields printed to
*   the trailer, so V8 has some extra code to do this by looping thru
*   all widgets (fields) in frame a.
*/
/*G0FB*/ /*V8!
         define variable criteria as char.
         define variable criteria-column as integer.
/*G0FB*/ */

/*B695*/ repeat:
            display {1} skip(1) "End of Report" at 60
            with frame rfoot width 132.
				leave.
/*B695*/ end.

{mfreset.i {1}}
{mfmsg.i 9 1}
/*end mfrtrail.i*/
