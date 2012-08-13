/* GUI CONVERTED from mfworc.i (converter v1.78) Fri Oct 29 14:33:39 2004 */
/* mfworc.i - WORK ORDER RECEIPT FRAME DEFINITION                             */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12 $                                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.5     LAST MODIFIED: 10/05/94    BY: taf *J035*                */
/* REVISION: 7.5     LAST MODIFIED: 10/05/94    BY: pma *J040*                */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KR* myb                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8     BY: Irene D'Mello DATE: 06/27/01 ECO: *P00X*          */
/* $Revision: 1.12 $    BY: Narathip W.   DATE: 04/19/03 ECO: *P0Q7*          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{cxcustom.i "MFWORC.I"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfworc_i_1 "L/S"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworc_i_2 "Ref"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{&MFWORC-I-TAG1}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wo_nbr                             colon 15
   wo_lot                             colon 38
   eff_date                           colon 58
   wo_rmks        format "x(33)"      colon 15
   wo_batch                           colon 58
   wo_part                            colon 15
   pt_lot_ser     label {&mfworc_i_1} colon 58
   pt_um                              colon 65
   pt_desc1                           colon 15
   wo_status                          colon 58
   open_ref                           colon 15
   pt_auto_lot                        colon 58
   skip(1)
   lotserial_qty                      colon 15
   site                               colon 54
   um                                 colon 15
   location                           colon 54
   conv                               colon 15
   lotserial                          colon 54
   reject_qty                         colon 15
   lotref         label {&mfworc_i_2} colon 54
   reject_um                          colon 15
   multi_entry                        colon 54
   reject_conv                        colon 15
   chg_attr                           colon 54
   tot_units                          colon 54
   skip(1)
   rmks                               colon 15 path COLON 54
   close_wo                           colon 15
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{&MFWORC-I-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
