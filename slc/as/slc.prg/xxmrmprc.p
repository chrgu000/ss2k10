/* mrmprc.p - Recalculate Materials Plan -  MRP Selective                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.3 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.2          LAST EDIT: 01/25/95   BY: *F0GM* Evan Bishop        */
/* REVISION: 8.6          LAST EDIT: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* $Revision: 1.4.1.3 $  BY: Jean Miller         DATE: 12/07/01  ECO: *P03F*  */
/* By: Neil Gao Date: 07/11/21 ECO: * ss 20071121 * */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfglobal.i}

/* Define constants for mrp/drp net-change/regen/selective options */
{gpmpvar.i}

/* ss 20071121 - b */
/* 
{gprun.i ""gpmp.p"" "(mrp-module,selective)" }
*/
{gprun.i ""xxgpmp.p"" "(mrp-module,selective)" }
/* ss 20071121 - e */

