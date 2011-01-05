/* arpafmb.i - AR PAYMENT MAINTENANCE: FRAME b DEFINITION                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.8 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4            CREATED: 09/15/93   by: pcd *H115*                */
/*                    LAST MODIFIED: 01/16/95   by: srk *G0B8*                */
/*                                   04/24/95   by: wjk *H0CS*                */
/* REVISION: 8.6      LAST MODIFIED: 06/18/96   by: pjg *K001*                */
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   by: taf *J0Z5*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *N0VV* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.1.7    BY: Jean Miller        DATE: 05/25/02  ECO: *P076*  */
/* $Revision: 1.7.1.8 $   BY: Orawan S.          DATE: 05/20/03  ECO: *P0RX*  */
/* $Revision: 1.7.1.8 $   BY: Bill Jiang          DATE: 08/17/07  ECO: *SS - 20070817.1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{cxcustom.i "ARPAFMB.I"}
/* FRAME b DEFINITION */

{&ARPAFMB-I-TAG1}
form
   ar_check       colon 15
   ar_bill        colon 40
   cm_sort                 no-label
   ar_curr        colon 15
   ar_type        colon 51
   artotal        colon 15
   ar_amt         colon 51 label "Total"
   ar_date        colon 15
   {&ARPAFMB-I-TAG3}
   ar_batch       colon 51
   ar_effdate     colon 15
   ar_dy_code     colon 51
   bank           colon 15
   ar_acct        colon 51
   ar_sub                  no-label
   ar_cc                   no-label
   desc1          colon 15 no-label format "X(26)"
   ar_disc_acct   colon 51
   ar_disc_sub             no-label
   ar_disc_cc              no-label
   ar_po          colon 15
   ar_entity      colon 51
   auto_apply     colon 15 label "Auto Apply"
   /* SS - 20070817.1 - B */
   ar_user2 
   /* SS - 20070817.1 - E */
with frame b side-labels width 80.

{&ARPAFMB-I-TAG2}
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
