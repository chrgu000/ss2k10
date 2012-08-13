/* ppptmt02.p - PART PLANNING MAINTENANCE                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.2 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 5.0      LAST MODIFIED: 04/24/89   BY: MLB  *B104**/
/* REVISION: 4.0      LAST MODIFIED: 06/14/89   BY: MLB  *A745**/
/* REVISION: 6.0      LAST MODIFIED: 02/08/90   BY: emb  *D001*/
/*           7.2                     03/22/95   by: srk *F0NN**/
/*           8.6                     05/20/98   by: *K1Q4* Alfred Tan         */
/*           9.1                     08/13/00   by: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.4.1.2 $  BY: Jean Miller         DATE: 12/07/01  ECO: *P03F*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "b+ "}

define new shared variable ppform as character.

ppform = "c".
/*tfq {gprun.i ""ppptmta.p""} */
/*roger*/ {gprun.i ""yyptmta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.
