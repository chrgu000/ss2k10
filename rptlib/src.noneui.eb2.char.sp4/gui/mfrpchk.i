/* mfrpchk.i - REPORT EXIT for paging INCLUDE FILE                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.13 $                                                    */
/*V8:ConvertMode=Report                                                 */
/*V8:RunMode=Character                                                  */
/*
    {&label}    = optional label of block to exit.
    {&warn}     = false if report terminated message not to be printed.
                  Default is to print warning.
    {&stream}   = optional name of output stream, e.g. "(prt)".
*/
/* Revision: 7.3      Last Modified: 09/12/92   By: jcd *G058*          */
/* Revision: 7.3      Last Modified: 12/03/92   By: jcd *G361*          */
/* Revision: 8.6      Last Modified: 09/17/97   By: kgs *K0J0*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/27/98   BY: *K1QW* Mohan CK     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 09/23/99   BY: *N034* Jean Miller  */
/* REVISION: 9.1      LAST MODIFIED: 03/01/00   BY: *N03S* Doug Norton  */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LJ* Mark Brown   */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* $Revision: 1.13 $    BY: Katie Hilbert  DATE: 03/07/01 ECO: *N0XB*     */
/* $Revision: 1.13 $    BY: Bill Jiang  DATE: 07/20/06 ECO: *SS - 20060720.1*     */

/* SS - 20060720.1 - B */
/*
1.	直接复制于CHARACTER
*/
/* SS - 20060720.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

if keyfunction(lastkey) = "END-ERROR"
then do:
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
