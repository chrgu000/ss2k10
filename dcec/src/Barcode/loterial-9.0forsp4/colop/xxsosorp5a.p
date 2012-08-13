/* GUI CONVERTED from sosorp5a.p (converter v1.76) Wed Dec 12 05:48:45 2001 */
/* sosorp5a.p - SALES ORDER PRINT UPDATE PRINT                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.2 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 04/28/86   BY: PML */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: dld *F358**/
/* REVISION: 7.3      LAST MODIFIED: 03/17/93   BY: afs *G820**/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.4.1.2 $  BY: Jean Miller         DATE: 12/07/01  ECO: *P03F*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

define shared variable so_recno as recid.
define shared variable bump_rev like mfc_logical.

/* UPDATE SO_MSTR  */
find so_mstr where recid(so_mstr) = so_recno exclusive-lock.

assign
   so_print_so = no.

if bump_rev then
   so_rev = so_rev + 1.
