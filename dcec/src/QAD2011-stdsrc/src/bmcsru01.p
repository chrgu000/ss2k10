/* GUI CONVERTED from bmcsru01.p (converter v1.78) Fri Oct 29 14:36:05 2004 */
/* bmcsru01.p - BOM COST ROLL-UP                                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.6 $                                                */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0     LAST MODIFIED: 01/18/92    BY: pma *F206*                */
/* REVISION: 7.2     LAST MODIFIED: 11/09/92    BY: emb *G294*                */
/* REVISION: 7.3     LAST MODIFIED: 02/18/93    BY: emb *G700*                */
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: pma *G681*                */
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001*                */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/11/00    BY: *N0KK* Jacolyn Neder      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.1.5    BY: Jean Miller       DATE: 04/12/02  ECO: *P05H*     */
/* $Revision: 1.5.1.6 $   BY: Manjusha Inglay DATE: 07/29/02  ECO: *N1P4*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable transtype as character format "x(7)".

{gldydef.i new}
{gldynrm.i new}

transtype = "BM".
{gprun.i ""bmcsru.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

