/* ppptmt02.p - PART PLANNING MAINTENANCE                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
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

/*----rev history-------------------------------------------------------------------------------------*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2007/11/27  ECO: *xp001*  */
/* SS - 101208.1  By: Roger Xiao */ /*xxppptmtc.p if pt_vend changed ,modify pt__chr03 to default */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "101208.1"}

define new shared variable ppform as character.

ppform = "c".
{gprun.i ""xxppptmtax.p""} /*xp001*/
