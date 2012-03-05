/* mfrpexit.i - REPORT EXIT INCLUDE FILE                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*G2R0*/ /*F0PN*/ /*V8:ConvertMode=NoConvert                            */
/*V8:RunMode=Character                                                  */
/* REVISION: 1.0      LAST MODIFIED: 01/21/86   BY: PML                 */
/* REVISION: 6.0      LAST MODIFIED: 04/09/90   BY: PML                 */
/* REVISION: 6.0      LAST MODIFIED: 08/02/91   BY: bjb *D811*          */
/* Revision: 7.3      Last modified: 09/17/92   By: jcd         *G058*  */
/* Revision: 9.0      Last modified: 02/06/99   By: *M06R* Doug Norton  */
/* Revision: 9.0      Last modified: 03/13/99   By: *M0BD* Alfred Tan   */
/* REVISION: 9.1   LAST MODIFIED: 03/01/00   BY: *N03S* Doug Norton     */
/* REVISION: 9.1   LAST MODIFIED: 08/17/00   BY: *N0LJ* Mark Brown      */

/* {1} = false if report terminated message not to be printed           */

/*G058*********************************************************
* /* if dev <> "terminal" then readkey pause 0. */
* if keyfunction(lastkey) = "end-error" then do:
*   if "{1}" <> "false" then /*D811*/
*   put skip(1) "************* REPORT TERMINATED ************".
*   leave.
* end.
*************************************************************/

{mfrpchk.i &warn={1} }
