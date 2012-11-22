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

form
    pt_promo        label "Promotion Group"  colon 23
    tt-ptgrp_desc   no-label  colon 40 skip
    item_def_div    label "Default Division" colon 23
    tt-dv_name      no-label  colon 40 skip
    item_prig1      label "Pricing Group 1"  colon 23
    prgrp1_desc     no-label  colon 40 skip
    item_prig2      label "Pricing Group 2"  colon 23
    prgrp2_desc     no-label  colon 40 skip
with frame f_apmdata title color normal (getFrameTitle("APM_DATA",13))
side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame f_apmdata:handle).
