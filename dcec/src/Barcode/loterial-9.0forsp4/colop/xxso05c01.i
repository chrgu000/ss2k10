/* xxso05c01.i - SALES ORDER PRINT INCLUDE FILE                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.5 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0      LAST MODIFIED: 12/27/90   BY: MLB *D238**/
/* REVISION: 6.0      LAST MODIFIED: 12/16/91   BY: MLV *D962**/
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: dld *F322**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.5.1.5 $   BY: Jean Miller        DATE: 04/16/02  ECO: *P05S*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

FORM /*GUI*/ 
   billattn       colon 15 /* label "Contact"  */
   shipattn       colon 53 /* label "Contact" */
   billphn        colon 15 /* label "Telephone" */
   shipphn        colon 53 /* label "Telephone" */ skip (1)
   so_slspsn[1]   colon 15    label "Salesperson(1)" 
   spname1    NO-LABEL
   sptel1          NO-LABEL  SPACE(2)
   spemail1      NO-LABEL 
   so_slspsn[2]   COLON 15 LABEL "Salesperson(2)"
   spname2    NO-LABEL
   sptel2          NO-LABEL   SPACE(2)
   spemail2      NO-LABEL   SKIP
/**xxx**   so_slspsn[3]   at 17       no-label
   so_slspsn[4]               no-label
   *****/
   so_po          colon 59 /* label "Purchase Order" */
   so_cr_terms    colon 15 /* label "Credit Terms" */
   so_shipvia     colon 59 /* Label "Ship Via" */
   termsdesc      colon 15    no-label
   so_fob         colon 59 /* label "FOB" */
   resale         colon 15 /* label "Resale" */
/*xx**/   
   baseprice  COLON 15  LABEL "Copper base"
    netweight   COLON 59  
    custtax COLON 15   LABEL "Customer Tax"
    mytax   COLON 59   LABEL "Company Tax"
   so_rmks        colon 15 /* label "Remarks" */
   skip (1)
with STREAM-IO /*GUI*/  frame phead3 side-labels width 90.

/* SET EXTERNAL LABELS */
setFrameLabels(frame phead3:handle).
