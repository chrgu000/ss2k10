/* ppptmt04.p - PART ENGINEERING MAINTENANCE                                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.2 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 08/08/90   BY: emb  *D001*/
/*           7.2                     03/22/95   by: srk *F0NN**/
/*           8.6                     05/20/98   by: *K1Q4* Alfred Tan         */
/*           9.1                     08/13/00   by: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.4.1.2 $  BY: Jean Miller         DATE: 12/05/01  ECO: *P03B*  */
/*By: Neil Gao 08/09/12 ECO: *SS 20080912* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "N+ "}

define new shared variable ppform as character.

ppform = "a".
/*SS 20080912 - B*/
/*
{gprun.i ""ppptmta.p""}
*/
{gprun.i ""xxnppptmta.p""}

