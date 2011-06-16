/* ppptmt03.p - ITEM COST MAINTENANCE (DEFAULT)                               */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.5 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 5.0      LAST MODIFIED: 04/24/89   BY: MLB  *B104**/
/* REVISION: 4.0      LAST MODIFIED: 06/14/89   BY: MLB  *A745**/
/* REVISION: 6.0      LAST MODIFIED: 02/08/90   BY: emb  *D001*/
/*           7.2                     03/22/95   by: srk *F0NN**/
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.1.2     BY: Jean Miller         DATE: 12/11/01  ECO: *P03N*  */
/* Revision: 1.5.1.3     BY: John Corda          DATE: 08/09/02  ECO: *N1QP*  */
/* $Revision: 1.5.1.5 $    BY: Piotrw Witkowicz    DATE: 03/17/03  ECO: *P0NN*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ss - 090803.1 by: jack */  /* 增加税用途维护*/
/* ss - 090916.1 by: jack */

/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "090916.1 "}

{cxcustom.i "PPPTMT03.P" }

{gldydef.i new}
{gldynrm.i new}

define new shared variable ppform as character.
{&PPPTMT03-P-TAG1}

ppform = "d".
/* ss - 090803.1 -b
{gprun.i ""ppptmta.p""}
 ss - 090803.1 -e */

 /* ss - 090803.1 -b */
 {gprun.i ""xxppptmta.p""}
 /* ss - 090803.1 -e */
