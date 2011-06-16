/* ppptmt01.p - PART INVENTORY MAINTENANCE                                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.2 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 5.0      LAST MODIFIED: 01/11/89   BY: MLB */
/* REVISION: 4.0      LAST MODIFIED: 06/14/89   BY: MLB A745 */
/* REVISION: 5.0      LAST MODIFIED: 12/14/89   BY: emb B455 */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: emb *D001*/
/* REVISION: 6.0      LAST MODIFIED: 05/17/90   BY: WUG *D002*/
/* REVISION: 6.0      LAST MODIFIED: 06/10/91   BY: emb *D682**/
/*           7.2                     03/22/95   by: srk *F0NN**/
/*           8.6                     05/20/98   by: *K1Q4* Alfred Tan         */
/*           9.1                     08/13/00   by: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.4.1.2 $  BY: Jean Miller         DATE: 12/10/01  ECO: *P03H*  */
/* SS - 091105.1 By: Neil Gao */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS 091105.1 - B */
{mfdtitle.i "091105.1"}
/* SS 091105.1 - E */

define new shared variable ppform as character.

ppform = "b".
/* SS 091105.1 - B */
/*
{gprun.i ""ppptmta.p""}
*/
{gprun.i ""xxppptmta.p""}
/* SS 091105.1 - E */