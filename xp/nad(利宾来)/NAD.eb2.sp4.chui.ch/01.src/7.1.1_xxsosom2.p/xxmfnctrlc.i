/* mfnctrlc.i - NEXT CONTROL FILE NUMBER WITH PREFIX                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.11 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.0     LAST MODIFIED: 01/30/92    BY: RAM *F126*          */
/* REVISION: 7.0     LAST MODIFIED: 03/06/92    BY: RAM *F267*          */
/* REVISION: 8.6     LAST MODIFIED: 04/22/98    BY: *K1NN* Vinay Nayak-Sujir */
/* REVISION: 9.0     LAST MODIFIED: 11/12/98    BY: *J34F* Vijaya Pakala     */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99    BY: *M0B8* Hemanth Ebenezer  */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KR* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* $Revision: 1.11 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*     */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110121.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*************************************************************************/
/*!
{1} control file name
{2} control file prefix field
{3} control file number field
{4} file
{5} field
{6} variable/field to set
{7} condition expression
*/
/********************************************************/

&if defined(fldlennme) = 0 &then
   &global-define fldlennme
   define variable fieldlen as integer initial 0 no-undo.
   define variable fieldname as character no-undo.
&endif

fieldname = "{3}".

&if defined(gpfieldv) = 0 &then
   &global-define gpfieldv
   {gpfieldv.i}
&endif

{gpfield.i &field_name = fieldname}

if field_found then do:
   /* DETERMINE LENGTH OF FIELD AS DEFINED IN DATABASE SCHEMA  */
   {gpfldlen.i}

   if not can-find(first {1}) then create {1}.
   find first {1} exclusive-lock.

   if length({2}) + length(string({3})) > fieldlen then
      {3} = string(1).
   {6} = {2} + string({3}).
   do while can-find(first {4} where {5} = {6}
                     &if "{7}" <> "" &then
                        and {7}
                     &endif):

      {3} = string(integer({3}) + 1).
      if length({2}) + length(string({3})) > fieldlen then
         {3} = string(1).
      {6} = {2} + string({3}).
   end.
   {3} = string(integer({3}) + 1).

   if length({2}) + length(string({3})) > fieldlen then
      {3} = string(1).
   release {1}.
end.
