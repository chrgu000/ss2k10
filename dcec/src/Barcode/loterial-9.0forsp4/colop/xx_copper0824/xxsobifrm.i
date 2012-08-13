/* xxsobifrm.i - DEFINE FORM FOR FRAME BI                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* $Revision: 1.6 $    BY: Jean Miller           DATE: 12/10/01  ECO: *P03H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


FORM /*GUI*/ 
   sod_qty_ord                format "->>>>,>>9.9<<<<"
   sod_list_pr                format ">>>,>>>,>>9.99<<<"
   sod_disc_pct label "Disc%" format "->>>>9.99"
with frame bi width 80 THREE-D /*GUI*/.

