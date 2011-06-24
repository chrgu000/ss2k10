/* porctrl2.p - PURCHASE ORDER RECEIPTS TRAILER                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.8.1.2 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* H074* changes  made here should be applied to posmtrl2.p             */
/* REVISION: 7.4            CREATED:           06/22/93   BY: JJS *H010**/
/*                                             07/06/93   BY: JJS *H024**/
/*                                             07/14/93   BY: bcm *H035**/
/*                                             07/28/93   BY: bcm *H042**/
/*                                             04/12/94   BY: bcm *H334**/
/*                                             04/12/94   BY: dpm *H074**/
/*                                             09/08/94   BY: bcm *H509**/
/*                                             11/17/94   BY: bcm *GO37**/
/*                                             11/30/94   BY: bcm *H606**/
/*                                             06/01/95   BY: tvo *H0BJ**/
/*                                             08/09/95   BY: jym *H0FH**/
/*                                             01/17/96   BY: rxm *H0J4**/
/* REVISION: 8.5           MODIFIED:           10/13/95   BY: taf *J053**/
/* REVISION: 8.5           MODIFIED:           02/14/96   BY: rxm *H0JJ**/
/* REVISION: 8.6           MODIFIED:           05/20/98   BY: *K1Q4* Alfred Tan */
/* REVISION: 9.1           MODIFIED:           08/13/00   BY: *N0KQ* myb        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.8.1.2 $    BY: Jean Miller           DATE: 04/25/02  ECO: *P06H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

define shared variable convertmode as character no-undo.

if convertmode = "MAINT" then do:
   {gprun.i ""porctrld.p""}
end.
else do:
   {gprun.i ""xxporctrlc.p""}
end.
