/* porp3a01.p - PURCHASE ORDER PRINT DETAIL SUBROUTINE                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.1.2 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0     LAST MODIFIED: 08/14/91    BY: RAM *D828**/
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.3.1.2 $  BY: Jean Miller         DATE: 12/05/01  ECO: *P039*  */
/* $Revision: 1.3.1.2 $  BY: Bill Jiang         DATE: 04/10/08  ECO: *SS - 20080410.1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080410.1 - B */
/*
{porp0301.i &sort1 = "pod_site" &sort2 = "pod_line"}
*/
{sspoporp0301.i}

{sspoporp030101.i &sort1 = "pod_site" &sort2 = "pod_line"}
/* SS - 20080410.1 - E */
