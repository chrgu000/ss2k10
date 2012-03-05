/* grnctrl.i - NEXT CONTROL FILE NUMBER GLRW *GK35*                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* mfnctrl.i - NEXT CONTROL FILE NUMBER                                       */
/* REVISION: 1.0      LAST MODIFIED: 06/24/86   BY: pml                       */
/* REVISION: 7.3      LAST MODIFIED: 01/11/94   BY: COD *GK35*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.5 $    BY: Jean Miller           DATE: 04/15/02  ECO: *P05H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
   {1} control file name
   {2} control file field
   {3} file
   {4} field
   {5} variable/field to set
*/

if not can-find(first {1}) then create {1}.
find first {1} exclusive-lock.

do while can-find(first {3} where {4} = {2}):
   {2} = {2} + 1.
   if {2} > 99999999 then {2} = 1.
end.

{5} = {2}.
{2} = {2} + 1.

if {2} > 99999999 then {2} = 1.

release {1}.
