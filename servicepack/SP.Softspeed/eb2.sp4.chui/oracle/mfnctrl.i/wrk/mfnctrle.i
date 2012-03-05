/* mfnctrle.i - NEXT CONTROL FILE NUMBER                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.8 $                                                      */
/*V8:ConvertMode=Maintenance                                             */
/* REVISION: 8.6E          CREATED: 08/21/98 BY: *K1SH* Dana Tunstall    */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99 BY: *M0B8* Hemanth Ebenezer */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99 BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1     LAST MODIFIED: 09/28/99 BY: *K237* Jose Alex        */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00 BY: *N0KR* myb              */
/* $Revision: 1.8 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*     */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*************************************************************************/
/*! This program is copied from mfnctrl.i and the DO WHILE block is
is replaced by the REPEAT block.
This logic does not freeze the system in ORACLE Database.
*/
/*!
{1} control file name
{2} control file field
{3} file
{4} field
{5} variable/field to set
*/
/*! THIS PROGRAM IS SIMILAR TO mfnctrl.i AND CHANGES DONE IN mfnctrl.i
MAY ALSO NEED TO BE DONE IN mfnctrle.i
*/
/*************************************************************************/

if not can-find(first {1}) then create {1}.
find first {1} exclusive-lock.
for first _field where _field-name = "{2}" no-lock:
end.

repeat:

   find first {3}
      where {4}
      no-lock no-error.
   if available {3} then do:
      assign
         {2} = {2} + 1.
      if length(string ({2})) > length(_format) then {2} = 1.
   end.
   else leave.
end.
assign
   {5} = string({2})
   {2} = {2} + 1.
if length(string ({2})) > length(_format) then {2} = 1.
release {1}.
