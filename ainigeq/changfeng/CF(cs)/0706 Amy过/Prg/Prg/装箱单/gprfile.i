/* gprfile.i - SALES ORDER PRINT INCLUDE FILE                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0    LAST MODIFIED: 04/25/90   BY: MLB */
/* REVISION: 6.0    LAST MODIFIED: 11/12/90   BY: MLB *d200*      */
/* REVISION: 9.1    LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown           */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.4 $    BY: Jean Miller           DATE: 12/05/01  ECO: *P039*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

run_file = form_code.

if run_file  = "" then
   run_file = "1".

if length(run_file) = 1 then
   run_file  = "0" + run_file.
