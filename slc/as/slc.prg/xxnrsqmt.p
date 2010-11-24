/* nrsqmt.p - NRM - Sequence Maintenance                                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.2 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.6      LAST MODIFIED: 06/10/96   BY: pcd  *K002*               */
/*                                   04/18/97   BY: *K0C1* E. Hughart         */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* $Revision: 1.4.1.2 $  BY: Jean Miller         DATE: 12/07/01  ECO: *P03F*  */
/* By: Neil Gao Date: 07/12/03 ECO: * ss 20071203 * */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i}

define variable nrui-h as handle.

/* ss 20071203 - b */
/*
{gprun.i ""nrui.p"" "persistent set nrui-h"}
*/
{gprun.i ""xxnrui.p"" "persistent set nrui-h"}
/* ss 20071203 - e */

run sequence_mt in nrui-h.

DELETE PROCEDURE nrui-h no-error.
