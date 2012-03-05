/* mfnctrl.i - NEXT CONTROL FILE NUMBER                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.17 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST MODIFIED: 06/24/86   BY: pml                     */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *K1SH* Dana Tunstall    */
/* REVISION: 9.0      LAST MODIFIED: 11/12/98   BY: *J34F* Vijaya Pakala    */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* $Revision: 1.17 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*        */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/**************************************************************************/
/*!
{1} control file name
{2} control file field
{3} file
{4} field
{5} variable/field to set
*/
/********************************************************/
/* CHANGES DONE IN THIS PROGRAM MAY ALSO NEED TO BE DONE IN          */
/* mfnctrle.i                                                        */

&if defined(fldlennme) = 0 &then
   &global-define fldlennme
   define variable fieldlen as integer initial 0 no-undo.
   define variable fieldname as character no-undo.
&endif

fieldname = "{2}".

&if defined(gpfieldv) = 0 &then
   &global-define gpfieldv
   {gpfieldv.i}
&endif

{gpfield.i &field_name = fieldname}

if field_found then do:
   /* DETERMINE LENGTH OF FIELD AS DEFINED IN DATABASE SCHEMA */
   {gpfldlen.i}

   if not can-find(first {1}) then create {1}.
   find first {1} exclusive-lock.

   do while can-find(first {3} where {4} = string ({2})):
      assign
         {2}  = {2} + 1.
      if length(string ({2})) > fieldlen then {2} = 1.
   end.
   assign
      {5} = string({2})
      {2} = {2} + 1.
   if length(string ({2})) > fieldlen then {2} = 1.
   release {1}.
end.
