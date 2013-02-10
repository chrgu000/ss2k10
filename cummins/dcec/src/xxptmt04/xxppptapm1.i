/* GUI CONVERTED from xxppptapm1.i (converter v1.78) Thu Jan 19 15:47:30 2012 */
/* ppptapm1.i - APM INTERFACE PROGRAM                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 9.0      LAST MODIFIED: 11/20/98  BY: *M002* Mayse Lai           */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99  BY: *M0BD* Alfred Tan          */
/* REVISION: 9.1      LAST MODIFIED: 05/08/00  BY: *N0B0* Annasaheb Rahane    */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00  BY: *N0LJ* Mark Brown          */
/* $Revision: 1.10 $    BY: Jean Miller           DATE: 04/09/02  ECO: *P058*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

FORM /*GUI*/ 
    
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
pt_promo        label "Promotion Group"  colon 23
    tt-ptgrp_desc   no-label  colon 40 skip
    item_def_div    label "Default Division" colon 23
    tt-dv_name      no-label  colon 40 skip
    item_prig1      label "Pricing Group 1"  colon 23
    prgrp1_desc     no-label  colon 40 skip
    item_prig2      label "Pricing Group 2"  colon 23
    prgrp2_desc     no-label  colon 40 skip
 SKIP(.4)  /*GUI*/
with frame f_apmdata 
side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-f_apmdata-title AS CHARACTER.
 F-f_apmdata-title = (getFrameTitle("APM_DATA",13)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame f_apmdata = F-f_apmdata-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame f_apmdata =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame f_apmdata + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame f_apmdata =
  FRAME f_apmdata:HEIGHT-PIXELS - RECT-FRAME:Y in frame f_apmdata - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME f_apmdata = FRAME f_apmdata:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame f_apmdata:handle).
