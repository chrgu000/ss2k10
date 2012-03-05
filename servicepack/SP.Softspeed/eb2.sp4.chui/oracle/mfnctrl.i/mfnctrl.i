/* mfnctrl.i - NEXT CONTROL FILE NUMBER                                 */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.18 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST MODIFIED: 06/24/86   BY: pml                     */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *K1SH* Dana Tunstall    */
/* REVISION: 9.0      LAST MODIFIED: 11/12/98   BY: *J34F* Vijaya Pakala    */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.17     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*        */
/* $Revision: 1.18 $    BY: Piotr Witkowicz DATE: 03/14/03 ECO: *P0NP*       */
/* $Revision: 1.18 $    BY: Bill Jiang DATE: 08/03/06 ECO: *SS - 20060803.1*       */

/* SS - 20060803.1 - B */
/*
1. 试图解决使用ORACLE数据库时不同批处理生成了相同总账参考号的BUG,结果待验证
2.	发现受影响的事务类型如下:AR,AP
*/
/* SS - 20060803.1 - E */

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
{cxcustom.i "MFNCTRL.I"}

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

{&MFNCTRL-I-TAG1}
{gpfield.i &field_name = fieldname}

if field_found then do:
   /* DETERMINE LENGTH OF FIELD AS DEFINED IN DATABASE SCHEMA */
   {gpfldlen.i}

   {&MFNCTRL-I-TAG2}
   if not can-find(first {1}) then create {1}.
   find first {1} exclusive-lock.

   do while can-find(first {3} where {4} = string ({2})):
      assign
         {2}  = {2} + 1.
      if length(string ({2})) > fieldlen then {2} = 1.
      /* SS - 20060803.1 - B */
      if dbtype("qaddb") <> "Progress" then
         validate {1} no-error.
      /* SS - 20060803.1 - E */
   end.
   assign
      {5} = string({2})
      {2} = {2} + 1.
   if length(string ({2})) > fieldlen then {2} = 1.
   /* SS - 20060803.1 - B */
   if dbtype("qaddb") <> "Progress" then
      validate {1} no-error.
   /* SS - 20060803.1 - E */
   release {1}.
   {&MFNCTRL-I-TAG3}
end.
