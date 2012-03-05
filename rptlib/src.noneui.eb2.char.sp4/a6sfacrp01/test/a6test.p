/* sfacrp01.p - SHOP FLOOR OPERATIONS ACCOUNTING REPORT                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.3.1.3 $                                                     */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.0     LAST MODIFIED: 03/09/92    BY: pma *F270*          */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: ays *K0YH* */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KN* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* $Revision: 1.3.1.3 $    BY: Katie Hilbert  DATE: 04/05/01 ECO: *P008*   */
/* $Revision: 1.3.1.3 $    BY: Bill Jiang  DATE: 09/27/05 ECO: *SS - 20050927*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable transtype as character format "x(7)".

{wbrp01.i}

transtype = "SFC".
/* SS - 20050927 - B */
/*
{gprun.i ""sfacct01.p""}
    */
    {gprun.i ""a6test01.p""}
    /* SS - 20050927 - E */

{wbrp04.i}
