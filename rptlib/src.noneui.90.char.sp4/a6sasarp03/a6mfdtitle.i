/* mfdtitle.i - INCLUDE FILE FOR TITLE AND DEFINED VARIABLES            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
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
/* REVISION: 7.4     LAST MODIFIED: 04/07/98  *H1L9*   *Vijaya Pakala   */
/* REVISION: 9.0     LAST MODIFIED: 10/25/98  *M018*   *Mohan C K */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99  BY: *M0BD* Alfred Tan     */
/******* Orignal mfdtitle.i for character based application **********/

/*G0FB*/ /*V8-*/
{mfdeclre.i}


/*THERE ARE TWO POSSIBLE VALUES FOR "DTITLE". ONE WHERE IT BEGINS WITH THE
 *PROGRAM NAME, MENU OPTION, AND TODAY'S DATE; AND THE OTHER WHICH HAS JUST
 *THE MENU OPTION.  IF IT'S THE LATTER THEN THE PASSED VALUE MUST BE ADDED
 *TO THE BEGINNING OF "DTITLE", OTHERWISE IT CAN BE PUT AFTER THE PROGRAM NAME
 *AS IT ALWAYS HAS BEEN.                                                   */

/*J0WM*/ if substring(dtitle,1,1) >= "0" and substring(dtitle,1,1) <= "9" then
/*J0WM*/    dtitle = "{1}" + dtitle.
/*J0WM*/ else
dtitle = substr(dtitle,1,index(dtitle," ")) + "{1}" +
substr(dtitle,index(dtitle," ") + length("{1}","raw":U) + 1,78).   /*H1L9*/
/* substr(dtitle,index(dtitle," ") + length("{1}") + 1,78).       *H1L9*/

/* SS - Bil - B 2005.06.02 */
/*
/*M018*/ if c-application-mode <> 'WEB-ChUI':U then
display dtitle format "x(78)"
with no-labels width 80 row 1 column 2 frame dtitle no-box no-attr-space.
/*G0FB*/ /*V8+*/

/******* New mfdtitle.i for gui application *************************/
/*G0FB*/ /*V8!

         {mfdtitl1.i}      /*Everything except add "Help" to the menubar*/
         {mftool.i}        /*Add Optional Tool Bar*/
         {mfdtitl2.i}      /*Display the Menu Bar*/
/*G0N9*/ global_program_rev = "{1}". /*Track program rev for Help About */

/*G0FB*/ */
*/
/* SS - Bill - E */
