/* mfdtitle.i - INCLUDE FILE FOR TITLE AND DEFINED VARIABLES            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.18 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0     LAST MODIFIED: 07/17/86    BY: EMB       */
/* REVISION: 1.0     LAST MODIFIED: 05/10/86    BY: PML       */
/* REVISION: 2.0     LAST MODIFIED: 05/21/87    BY: EMB       */
/* REVISION: 4.0     LAST MODIFIED: 01/13/88    BY: WUG *A156**/
/* REVISION: 4.0     LAST MODIFIED: 05/03/88    BY: FLM *A220**/
/* REVISION: 4.0     LAST MODIFIED: 01/10/89    BY: EMB *A595**/
/* REVISION: 5.0     LAST MODIFIED: 04/10/89    BY: WUG *B097**/
/* REVISION: 8.3     LAST MODIFIED: 01/17/95    BY: jpm *G0FB**/
/* REVISION: 8.3     LAST MODIFIED: 01/17/95    BY: jzs *G0N9**/
/* REVISION: 8.5     LAST MODIFIED: 06/28/96    BY: *J0WM* Rob Wachowicz*/
/* REVISION: 7.4     LAST MODIFIED: 04/07/98    BY: *H1L9* Vijaya Pakala */
/* REVISION: 9.0     LAST MODIFIED: 10/25/98    BY: *M018* Mohan C K */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan     */
/* REVISION: 9.0     LAST MODIFIED: 03/26/99    BY: *N03S* Brian Wintz */
/* REVISION: 9.1     LAST MODIFIED: 03/08/00    BY: *N08K* Murali Ayyagari */
/* REVISION: 9.1     LAST MODIFIED: 03/23/00    BY: *N08T* D. TAYLOR */
/* Revision: 9.1     Last modified: 04/10/00    By: *N096* D. Taylor*/
/* Revision: 9.1     Last modified: 08/17/00    By: *N0LJ* Mark Brown    */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.17     BY: Katie Hilbert  DATE: 03/23/01 ECO: *P008*    */
/* $Revision: 1.18 $  BY: Ed van de Gevel DATE: 07/08/03 ECO: *Q003* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/******* Orignal mfdtitle.i  for character based application **********/
/*V8-*/
{mfdeclre.i}

/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}

/*THERE ARE TWO POSSIBLE VALUES FOR "DTITLE". ONE WHERE IT BEGINS WITH THE
* PROGRAM NAME, MENU OPTION, AND TODAY'S DATE; AND THE OTHER WHICH HAS JUST
* THE MENU OPTION.  IF IT'S THE LATTER THEN THE PASSED VALUE MUST BE ADDED
* TO THE BEGINNING OF "DTITLE", OTHERWISE IT CAN BE PUT AFTER THE PROGRAM NAME
* AS IT ALWAYS HAS BEEN.                                                   */
/*
if global_usrc_right_hdr_disp < 2 then do:
   if substring(dtitle,1,1) >= "0" and substring(dtitle,1,1) <= "9"
   then dtitle = "{1}" + dtitle.
   else dtitle = substring(dtitle,1,index(dtitle," ")) + "{1}" +
                 substring(dtitle,index(dtitle," ") + length("{1}","raw") + 1,78).
end.
else overlay(dtitle,150) = "{1}".

if c-application-mode <> 'WEB-ChUI' then
   display dtitle format "x(78)"
   with no-labels color messages
   width 80 row 1 column 1
   frame dtitle no-box no-attr-space.
*/
/*V8+*/
/******* New mfdtitle.i for gui application *************************/
/*V8!
{mfdtitl1.i}                /*Everything except add "Help" to the menubar*/
{mftool.i}                  /*Add Optional Tool Bar*/
{mfdtitl2.i}                /* BUILD USER MENU */

/* NOW THAT ALL THE MENUS ARE BUILT. WALK THE    */
/* MENU TREE AND SET EXTERNALIZED LABELS BEFORE  */
/* MENU IS SET TO CURRENT WINDOW AND DISPLAYED.  */
if valid-handle(menu menu-bar-ptr:handle) then do:
   setMenuLabels(menu menu-bar-ptr:handle).
   /* ASSIGN MENU BAR TO CURRENT WINDOW */
   assign current-window:menubar = menu menu-bar-ptr:handle.
end.

global_program_rev = "{1}". /*Track program rev for Help About */
*/

