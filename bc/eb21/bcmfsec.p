/* mfsec.p - Perform security checking for mfmenu.p, mgbatch.p, apphelp.p     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 7.3        Last modified: 08/17/95         By: str   *G0V7*      */
/* Revision: 7.3        Last modified: 06/05/96         By: rkc   *G1VJ*      */
/* Revision: 9.1        Last modified: 08/13/00         By: *N0KR* myb        */
/* $Revision: 1.4 $    BY: Jean Miller           DATE: 05/27/02  ECO: *P076*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{mf1.i}
{bccomm.i}

define input  parameter mndnbr as character no-undo.
define input  parameter mndselect as integer no-undo.
define input  parameter show_message as logical no-undo.

define output parameter menu_ok as logical no-undo.
define shared variable menu as character.

{mfsec2.i &mndnbr=mndnbr &mndselect=mndselect &show_message=show_message}

if can_do_menu and index(mndnbr,getBcRootMenu()) = 1 then do:
   menu_ok = can_do_menu.
end.
