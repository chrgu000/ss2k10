/* so05f01.i SALES ORDER PRINT include file                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.1.3 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.2            CREATED: 04/19/95   BY: rxm *F0PD*/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* $Revision: 1.3.1.3 $  BY: Jean Miller         DATE: 12/11/01  ECO: *P03N*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

form
   sod_line
   sod_part
   sod_due_date
   qty_open
   sod_um
   /*Kaine*  sod_price  */
   /*Kaine*  ext_price  */
with frame c width 80 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
