/* GUI CONVERTED from iclotr02.p (converter v1.78) Fri Oct 29 14:37:07 2004 */
/* iclotr02.p - INVENTORY TRANSFER SINGLE ITEM (RESTRICTED)                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0     LAST MODIFIED: 07/02/92    BY: pma *F701*                */
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001*                */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7     BY: Jean Miller            DATE: 12/10/01  ECO: *P03H*   */
/* $Revision: 1.8 $      BY: Manjusha Inglay        DATE: 08/16/02  ECO: *N1QP*   */
/* $Revision: eb21sp6    BY: Apple Tam        DATE:  05/10/10 ECO: *ss-20100510.1* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ss - 100520.1 by: jack */  /* 增加检料量*/
/* ss - 100630.1 by: jack */
/* ss - 100701.1 by: jack */
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable trtype as character.

{gldydef.i new}
{gldynrm.i new}

trtype = "SITE/LOC".
/*ss-20100510.1  {gprun.i ""iclotr.p""}*/
/*ss-20100510.1*/  {gprun.i ""xxiclotr21.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

