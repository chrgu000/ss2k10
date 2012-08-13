/* GUI CONVERTED from ppptmtaa.i (converter v1.78) Fri Oct 29 14:37:38 2004 */
/* ppptmtaa.i - ITEM MAINTENANCE INCLUDE FILE                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Maintenance                                            */
/* Revision: 1.4.2.1     BY: Anil Sudhakaran  DATE: 04/09/01 ECO: *M0P1*      */
/* $Revision: 1.4.2.2 $    BY: Narathip W.      DATE: 04/16/03 ECO: *P0PW*      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* This include has been created to replace the form statement defined in
* Ppptmta1.i and included in ppptmta.p. The new form stagement changes
* The position of the fields pt_part and pt_um by 2 to the left to
* Accomodate the batchdelete field. By not making the form statement
* Changes to ppptmta1.i the impact of this modification is limited only to
* Ppptmta.p and not to the other programs which has ppptmta1.i as an
* Include file */

/* Form Statement used with ppptmta.p. It includes the variable
* Batchdelete used to perform delete during CIM. */
{cxcustom.i "PPPTMTAA.I"}
{&PPPTMTAA-I-TAG1}
pt_part        colon 18
         view-as fill-in size 18 by 1   
   space(0)
   batchdelete       at 39 space(0)
   pt_desc1       colon 52
         view-as fill-in size 26 by 1   
   pt_um          colon 18
   pt_desc2          at 54 no-label
         view-as fill-in size 26 by 1   
   {&PPPTMTAA-I-TAG2}
