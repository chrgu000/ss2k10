/* pirp01.i - TAG PRINT SUBROUTINE INCLUDE FILE                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7 $                                                           */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*/
/* REVISION: 7.3      LAST MODIFIED: 07/23/93   BY: QZL *GD66*/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 08/31/98   BY: *L086* A.Shobha           */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.7 $    BY: Jean Miller           DATE: 04/16/02  ECO: *P05H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

do i = 1 to 20:
   put control substring(printline[i],1,max_printwidth).
   put skip(1).
   printline[i] = "".
end.

if print_barcode and available prd_det then do:
   {mfprtbar.i tagnumber[1]}
end.

do i = 22 to lines_form:
   put skip(1).
end.

forms_built = 0.
