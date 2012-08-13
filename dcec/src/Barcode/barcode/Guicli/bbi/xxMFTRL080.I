/* GUI CONVERTED from mftrl080.i (converter v1.71) Tue Oct  6 14:33:26 1998 */
/* mftrl080.i - 80 Column Report Trailer                          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 1.0     Created  : 03/13/86    BY: emb        */
/* REVISION: 4.0     LAST EDIT: 03/03/89    BY: WUG *B060* */
/* REVISION: 5.0     LAST EDIT: 06/29/89    BY: emb *B164* */
/* REVISION: 5.0     LAST EDIT: 02/15/90    BY: WUG *B569* */
/* REVISION: 7.2     LAST EDIT: 02/19/93    BY: WUG *G706* */
/* REVISION: 7.3     LAST EDIT: 03/23/95    BY: jzs *G0FB* */
/* REVISION: 7.2     LAST EDIT: 01/27/95    BY: *F0GM* evan bishop */
/* REVISION: 8.6     LAST EDIT: 09/18/97    BY: kgs *K0J0* */
/* REVISION: 8.6     LAST EDIT: 10/01/97    BY: vrp *J225* */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* Revision: 8.6E    Last edit: 05/17/98   Modified by: Mohan CK *K1Q4* */
/* Revision: 8.6E    Last edit: 05/28/98   Modified by: Mohan CK *K1QW* */
/* Revision: 8.6E    Last edit: 10/04/98   BY: *J314* Alfred Tan        */
/************************************************************************/
/*!
   {1} "STREAM stream-name" if necessary (include STREAM keyword)
   {2} "(stream-name)"      if necessary (parenthesized stream-name only)
*/
/************************************************************************/

/*! GUI cannot do a VIEW FRAME A to get the criteria fields printed to
*   the trailer, so V8 has some extra code to do this by looping thru
*   all widgets (fields) in frame a. 80 version uses mfselbpr.i's variables
*   criteria-prt, criteria-prt-column, 132 version (mfrtrail.i) has its own.
*/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*K0J0*/ {wbgp03.i}

/*K0J0*  For display to screen in web mode, need final display to force */
/*K0J0*  display of last frame of data. Also added "End of Report" */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mftrl080_i_1 "报表提交人:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mftrl080_i_2 "报表数据选择条件:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mftrl080_i_3 "报表结束"
/* MaxLen: Comment: */

&SCOPED-DEFINE mftrl080_i_4 "--- 报表结束 ---"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K1Q4*
 * /*K0J0*/ if c-application-mode = 'WEB':U and c-web-request = 'DATA':U then do:
 * /*K0J0*/   display skip " " with frame wbtfoot.
 * /*K0J0*/   put stream webstream unformatted skip {&WEB-BREAK-TAG} skip(1)
 *              {&mftrl080_i_4}.
 * /*K0J0*/ end.
 * /*K0J0*/ else do:
 *K1Q4*/
/*K1Q4*/  if c-application-mode <> 'WEB':U
/*K1QW*/     or (c-application-mode = 'WEB':U and c-web-request <> 'DATA':U)
/*K1Q4*/   then do:
/*G706*/   repeat:
         /* display {1} skip(1) {&mftrl080_i_3} at 33 with frame rfoot width 80 STREAM-IO /*GUI*/ .
/*F0GM*   */   if line-counter > 8 then do: */
/*F0GM*/     if line-counter {2} > 8 then do:
             page {1}.
        end.

       /* display {1}
          skip(3) {&mftrl080_i_2}
/*B060*/     space(30) {&mftrl080_i_1}
/*B569*/     report_userid no-label
             SKIP(1)    /*G0FB*/
            WITH STREAM-IO /*GUI*/ .
/*G0FB     with frame rfoot1 width 80. */
/*G0FB*/   /*V8+*/*/
/*G0FB*/        
        /* Print all report criteria from frame a */
        local-handle = frame a:first-child.      /* field group */
        local-handle = local-handle:first-child. /* first widget */
        repeat while local-handle <> ?:
          if local-handle:type = "fill-in" then do:
         if local-handle:labels then do:
           criteria-prt = local-handle:label + ": " +
                          local-handle:screen-value.
           criteria-prt-column =
              max(1,(local-handle:column - length(local-handle:label))).
/*J225**   put unformatted **/
/*J225*/  /* put {1} unformatted
              criteria-prt
           at criteria-prt-column.*/  /* Print widget's current value */
         end. /* if local-handle:labels */
          end.
          local-handle = local-handle:next-sibling.
        end.  /* repeat */
             /*G0FB*/
/*G706*/   leave.
/*G706*/ end.

/*K1Q4*/ end. /*else do*/
         {mfreset.i {1}}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

         {mfmsg.i 9 1}

/*K1Q4* /*K0J0*/ end. /*else do*/ */
/*K1Q4*
 * /*K0J0* If in web mode, do report termination logic and then exit the report */
 * /*K0J0* (looping back for another set of user input is suppressed). */
 *
 * /*K0J0*/ if c-application-mode = 'WEB':U then do:
 * /*K0J0*/   run web-end-data-reply in h-wblib.
 * /*K0J0*/   return.
 * /*K0J0*/ end.
 *K1Q4*/
/*end mftrl080.i*/
