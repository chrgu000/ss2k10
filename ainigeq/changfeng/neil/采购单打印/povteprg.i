/* povteprg.i - FIND VAT REG NO. & COUNTRY CODE                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7.1.3 $                                             */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.2      LAST MODIFIED: 12/01/92   BY: jms *FB02*          */
/* REVISION: 7.3      LAST MODIFIED: 02/19/92   BY: JMS *G712*          */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   BY: jzw *K008*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *N0GF* Mudit Mehta  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* $Revision: 1.7.1.3 $    BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

if can-find(first txc_ctrl where txc_prt_vat_reg)
then
   vatreg = substring(ad_pst_id,1,2) + " "
          + substring(ad_pst_id,3,13).
else vatreg = "".
if vatreg = "" then vatreglbl = "".
else vatreglbl = " " + getTermLabel("OUR_VAT_REGISTRATION",11) + ":".
