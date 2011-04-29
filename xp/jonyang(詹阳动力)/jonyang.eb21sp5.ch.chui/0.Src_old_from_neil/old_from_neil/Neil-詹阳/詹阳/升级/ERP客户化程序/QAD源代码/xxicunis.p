/* xxicunis.p - UNPLANNED ISSUE W/SERIAL NUMBERS                          */
/* GUI CONVERTED from icunis.p (converter v1.71) Fri May 22 23:17:41 1998 */
/* icunis.p - UNPLANNED ISSUE W/SERIAL NUMBERS                          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 2.1     LAST MODIFIED: 10/01/87    BY: WUG       */
/* REVISION: 6.0     LAST MODIFIED: 08/01/91    BY: emb *D800*/
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001*          */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan   */


{mfdeclre.i}

define new shared variable transtype as character format "x(7)".

/*K001*/ {gldydef.i new}
/*K001*/ {gldynrm.i new}
/*K001*/ if daybooks-in-use then
/*K001*/    {gprun.i ""nrm.p"" "persistent set h-nrm"}
/*GUI*/ if global-beam-me-up then undo, leave.


         transtype = "ISS-UNP".
/*JY000**    {gprun.i ""xxicintr.p""}           **/
/*JY000*/    {gprun.i ""xxicintr.p""}           
/*GUI*/ if global-beam-me-up then undo, leave.


/*K001*/ if daybooks-in-use then delete procedure h-nrm no-error.
