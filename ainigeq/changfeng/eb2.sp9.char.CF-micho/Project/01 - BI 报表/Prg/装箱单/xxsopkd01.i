/* sopkd01.i - SALES ORDER PRINT INCLUDE FILE                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.1.3 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0    LAST MODIFIED: 04/25/90    BY: MLB *D021**/
/* REVISION: 8.6    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan          */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00    BY: *N0KN* Mark Brown          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.3.1.3 $  BY: Jean Miller         DATE: 12/07/01  ECO: *P03F*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

display
   sod_line
   sod_part
   cont_lbl @ lad_loc
with frame d.
