/* bcrun.i - Run a subprogram with 2-letter-subdir search only.   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7 $                                                         */
/*V8:ConvertMode=NoConvert                                              */
/* REVISION: 6.0   LAST MODIFIED: 08/31/90   BY: WUG *D054**/
/* REVISION: 7.3   LAST MODIFIED: 02/16/95   BY: jzs *G0FB**/
/* REVISION: 8.5   LAST MODIFIED: 09/29/95   BY: jpm *J086**/
/* REVISION: 9.1   LAST MODIFIED: 08/13/00   BY: *N0KS* myb             */
/* $Revision: 1.7 $    BY: Katie Hilbert  DATE: 03/23/01 ECO: *P008*          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*****************************************************************************/
/*!
Runs a program from a 2-letter subdirectory, where the program MUST be.

{1} program name
{2} parameters to pass the program
{3} optional [ PERSISTENT [set handle] ] parameter for Progress v7.
*/
/*****************************************************************************/

run value(substring({1},3,2) + '\' + {1}) {2}.
