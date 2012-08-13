/* xxsosomt01.i - SO MAINTENANCE FRAME D SECOND TRAILER FRAME                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3      LAST MODIFIED: 02/22/93   BY: afs *G692*                */
/* REVISION: 7.3      LAST MODIFIED: 06/11/93   BY: WUG *GB74*                */
/* REVISION: 7.3      LAST MODIFIED: 03/16/95   BY: WUG *G0CW*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.10 $    BY: Jean Miller          DATE: 05/26/02  ECO: *P076*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

define variable print_ih like mfc_logical label "Print Inv Hist".
define variable edi_ih   like mfc_logical label "EDI Inv Hist".
define variable edi_ack  like mfc_logical label "EDI PO Ack".

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
so_cr_init     colon 15
   so_print_so    colon 39
    so__dec01  COLON 60 LABEL "Surcharge Amt"  FORMAT "->>>,>>>,>>9.9<<<<<"
   so_ar_acct     colon 15  label "AR Acct"
   so_ar_sub      no-label
   so_ar_cc       no-label
   so_cr_card     colon 15
   so_print_pl    colon 39
   so_prepaid     colon 60
   so_stat        colon 15
   print_ih       colon 39
   so_fob         colon 60
   so_rev         colon 15
   edi_ih         colon 39
   so_shipvia     colon 60
   edi_ack        colon 15
   so_partial     colon 39
   so_bol         colon 60
 SKIP(.4)  /*GUI*/
with frame d side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).
