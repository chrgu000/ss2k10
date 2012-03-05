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
/* REVISION: 8.6     LAST EDIT: 09/17/97    BY: kgs *K0J0* */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E    LAST EDIT: 05/17/98    BY: *K1Q4* Mohan CK         */
/* REVISION: 8.6E    LAST EDIT: 05/28/98    BY: *K1QW* Mohan CK         */
/* REVISION: 8.6E    LAST EDIT: 10/04/98    BY: *J314* Alfred Tan       */
/* REVISION: 9.0     LAST EDIT: 01/12/99    BY: *J372* Raphael Thoppil  */
/* REVISION: 9.0     LAST EDIT: 03/13/99    BY: *M0BD* Alfred Tan       */
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
         define variable next-handle as widget-handle no-undo.   /*J372*/
/*G0FB*/ */

/*K0J0*/ {wbgp03.i}

/*K0J0*  For display to screen in web mode, need final display to force */
/*K0J0*  display of last frame of data. Also added "End of Report" */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfrtrail_i_1 "--- 报表结束 ---"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfrtrail_i_2 "报表结束"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfrtrail_i_3 "报表数据选择条件:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfrtrail_i_4 "报表提交人:"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K1Q4*
 * /*K0J0*/ if c-application-mode = 'WEB':U and c-web-request = 'DATA':U then do:
 * /*K0J0*/    display {1} skip " " with frame wbtfoot.
 * /*K0J0*/    put stream webstream unformatted skip {&WEB-BREAK-TAG} skip(1)
 *              {&mfrtrail_i_1}.
 * /*K0J0*/ end.
 * /*K0J0*/ else do:
 *K1Q4*/
    /* SS - Bill - B 2005.05.19 */
    /*
/*K1Q4*/  if c-application-mode <> 'WEB':U
/*K1QW*/     or (c-application-mode = 'WEB':U and c-web-request <> 'DATA':U)
/*K1Q4*/   then do:
/*B695*/   repeat:
             display {1} skip(1) {&mfrtrail_i_2} at 60
             with frame rfoot width 132.
             if line-counter > 7 then do:
               page {1}.
             end.
             display {1} skip(3) {&mfrtrail_i_3}
/*B060*/     space(30) {&mfrtrail_i_4}
/*B569*/     report_userid no-label
/*G0FB*/     /*V8!       skip(1) */
             .
/*G0FB*/     /*V8-*/
             view {1} frame a.
/*G0FB*/     /*V8+*/
/*G0FB*/     /*V8!
             /* Print all report criteria from frame a */
             local-handle = frame a:first-child.      /* field group */
             local-handle = local-handle:first-child. /* first widget */
             repeat while local-handle <> ?:
           if local-handle:type = "literal":U                       /*J372*/
              or local-handle:type = "text":U                       /*J372*/
                  then next-handle = local-handle:next-sibling.         /*J372*/
               if not valid-handle(next-handle)                         /*J372*/
               then next-handle = local-handle.                         /*J372*/

               if local-handle:type = "fill-in":U
                 or ((local-handle:type = "literal":U) and              /*J372*/
             (next-handle:label = ? or next-handle:label = "")) /*J372*/
                 or ((local-handle:type = "text":U) and                 /*J372*/
             (next-handle:label = ? or next-handle:label = "")) /*J372*/
           then do:
               /*J372** if local-handle:labels then do:                       */
                   criteria-prt =
                                  if local-handle:labels then           /*J372*/
                    local-handle:label + ": " +
                                    local-handle:screen-value
                  else local-handle:screen-value.       /*J372*/
                   criteria-prt-column =
                     if local-handle:labels then                        /*J372*/
                      max(1,(local-handle:column -
/*G1KT*                length(local-handle:label))).                     */
/*G1KT*/               length(local-handle:label, "raw":U)))
                     else local-handle:column.                          /*J372*/
/*J17M*            put unformatted                                    */
/*J17M*/           put {1} unformatted
                      criteria-prt
                   at criteria-prt-column.  /* Print widget's current value */
                 /*J372**  end. /* if local-handle:labels */                  */
               end.
               local-handle = local-handle:next-sibling.
             end.  /* repeat */
/*G0FB*/     */

/*B695*/     leave.
/*B695*/   end.
/*K1Q4*/  end.
*/
/* SS - Bill - E */
           {mfreset.i {1}}
           {mfmsg.i 9 1}

/*K1Q4* /*K0J0*/ end. */
/*K1Q4*
 * /*K0J0* If in web mode, do report termination logic and then exit the report */
 * /*K0J0* (looping back for another set of user input is suppressed). */
 * /*K0J0*/ if c-application-mode = 'WEB':U then do:
 * /*K0J0*/    run web-end-data-reply in h-wblib.
 * /*K0J0*/    return.
 * /*K0J0*/ end.
 *K1Q4*/
/*end mfrtrail.i*/
