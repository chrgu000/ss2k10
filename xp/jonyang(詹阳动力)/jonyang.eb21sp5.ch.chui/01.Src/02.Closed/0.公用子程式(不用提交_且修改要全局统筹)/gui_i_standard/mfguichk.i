/* mfguichk.i - Report Exit for paging include file                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10 $                                                     */

/******************************** Tokens ********************************/
/*V8:ConvertMode=NoConvert                                              */
/*V8:RunMode=Windows                                                    */
/************************************************************************/

/******************************** History *******************************/
/* Revision: 8.3     Last Modified: 09/12/92     By: jcd                */
/* Revision: 8.3     Last Modified: 12/03/92     By: jcd                */
/* Revision: 8.5     Last Modified: 01/25/96     By: jpm      /*J0CF*/  */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane   */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98     BY: *J314* Alfred Tan  */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00     BY: *N0KR* myb         */
/* $Revision: 1.10 $    BY: Katie Hilbert DATE: 03/09/01 ECO: *N0XB*       */
/************************************************************************/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/********************************* Notes ********************************/
/*!
    {&label}    = optional label of block to exit.
    {&warn}     = false if report terminated message not to be printed.
          Default is to print warning.
    {&stream}   = optional name of output stream, e.g. "(prt)".
*/
/************************************************************************/

if keyfunction(lastkey) = "END-ERROR" then do:
   if "{&warn}" <> "false" and "{&warn}" <> "no" then
      put skip(1)
      CAPS(dynamic-function ('getTermLabelFillCentered' in h-label,
                         input "REPORT_TERMINATED",
                         input 44,
                         input "*")) format "x(44)"
      skip.
   leave {&label}.
end.
else
if (maxpage > 0 and (page-number {&stream} > maxpage or
   (page-number {&stream} = maxpage
   and line-counter {&stream} >= printlength - 2) ) ) then do:

   if "{&warn}" <> "false" and "{&warn}" <> "no" then
      put skip(1)
      CAPS(dynamic-function ('getTermLabelFillCentered' in h-label,
                         input "MAXIMUM_PAGE_REACHED",
                         input 48,
                         input "*")) format "x(48)"
      skip.
   leave {&label}.
end.
else do:
   if not batchrun then
      process events.
   if flag-report-exit then do:
      if "{&warn}" <> "false" and "{&warn}" <> "no" then
         put skip(1)
         CAPS(dynamic-function ('getTermLabelFillCentered' in h-label,
                         input "REPORT_TERMINATED",
                         input 44,
                         input "*")) format "x(44)"
         skip.
      leave {&label}.
   end.
end.
