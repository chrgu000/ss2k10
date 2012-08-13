/* mfrpchk.i - REPORT EXIT for paging INCLUDE FILE                      */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*N034*/ /*V8:RunMode=Character                                         */
/*
    {&label}    = optional label of block to exit.
    {&warn}     = false if report terminated message not to be printed.
                  Default is to print warning.
    {&stream}   = optional name of output stream, e.g. "(prt)".
*/
/* Revision: 7.3      Last Modified: 09/12/92   By: jcd *G058*          */
/* Revision: 7.3      Last Modified: 12/03/92   By: jcd *G361*          */
/* Revision: 8.6      Last Modified: 09/17/97   By: kgs *K0J0*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/27/98   BY: *K1QW* Mohan CK  */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 09/23/99   BY: *N034* Jean Miller   */
/* REVISION: 9.1   LAST MODIFIED: 03/01/00   BY: *N03S* Doug Norton     */
/* REVISION: 9.1   LAST MODIFIED: 08/17/00   BY: *N0LJ* Mark Brown       */

/*K1QW*
 * /*K0J0*/ {wbgp03.i}
 */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfrpchk_i_1 "************* REPORT TERMINATED ************"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfrpchk_i_2 "************* MAX PAGE REACHED ************"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K1QW*
 * /*K0J0*/ if c-application-mode = 'WEB':U then do:
 * /*K0J0*/   run web-status-check in h-wblib
 * /*K0J0*/     (OUTPUT c-web-status).
 * /*K0J0*/   if c-web-status <> '{&PP-EXIT}':U then
 * /*K0J0*/     run web-output-check in h-wblib
 * /*K0J0*/       (INPUT (PAGE-NUMBER {&stream} * PAGE-SIZE {&stream} + LINE-COUNTER {&stream}),
 * /*K0J0*/        OUTPUT c-web-status).
 * /*K0J0*/ end. /* if c-application-mode */

 * /*K0J0*  if keyfunction(lastkey) = "end-error" then do: */
 * /*K0J0*/ if keyfunction(lastkey) = "END-ERROR":U or
 * /*K0J0*/   (c-application-mode = 'WEB':U and c-web-status = '{&PP-EXIT}':U)
 *K1QW*/
/*K1QW*/ if keyfunction(lastkey) = "END-ERROR":U
/*K0J0*/ then do:
           if "{&warn}" <> "false" and "{&warn}" <> "no" then
           put skip(1) {&mfrpchk_i_1} skip.
           leave {&label}.
         end.
         else if (maxpage > 0 and (page-number {&stream} > maxpage or
         (page-number {&stream} = maxpage
         and line-counter {&stream} >= printlength - 2) ) ) then do:

           if "{&warn}" <> "false" and "{&warn}" <> "no" then
           put skip(1) {&mfrpchk_i_2} skip.

           leave {&label}.

         end.
