/* rcshwbfm.i  SHIPPER WORKBENCH INCLUDE FOR FORMS                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/* REVISON: 7.5     LAST MODIFIED: 07/18/95 BY: GWM *J049*                    */
/* REVISON: 8.5     LAST MODIFIED: 04/24/96 BY: GWM *J0K9*                    */
/* REVISON: 8.6     LAST MODIFIED: 09/20/96 BY: TSI *K005*                    */
/* VERSION: 8.6     LAST MODIFIED: 08/02/96 BY: *K003* Vinay Nayak-Sujir      */
/* VERSION: 8.6     LAST MODIFIED: 10/14/96 BY: *K003* Kieu Nguyen            */
/* VERSION: 8.5     LAST MODIFIED: 03/24/97 BY: *J1LY* Kieu Nguyen            */
/* VERSION: 8.6     LAST MODIFIED: 09/24/97 BY: *K0JC* John Worden            */
/* REVISION: 8.6    LAST MODIFIED: 11/11/97 BY: *K18W* Suresh Nayak           */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98 BY: *L007* Annasaheb Rahane       */
/* REVISION: 8.6E   LAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan             */
/* REVISION: 8.6E   LAST MODIFIED: 06/01/98 BY: *K1NF* Niranjan Ranka         */
/* REVISION: 8.6E   LAST MODIFIED: 07/22/98 BY: *J2M7* Niranjan Ranka         */
/* REVISION: 9.0    LAST MODIFIED: 12/29/99 BY: *K24W* Kedar Deherkar         */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane       */
/* REVISION: 9.1    LAST MODIFIED: 04/24/00 BY: *L0PR* Kedar Deherkar         */
/* REVISION: 9.1    LAST MODIFIED: 07/10/00 BY: *N0FP* Arul Victoria          */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00 BY: *N0KP* Mark Brown             */
/* REVISION: 9.1    LAST MODIFIED: 08/23/00 BY: *N0NH* Dave Caveney           */
/* REVISION: 9.1    LAST MODIFIED: 09/06/00 BY: *N0RG* Mudit Mehta            */
/* Revision: 1.11.1.8      BY: Jean Miller        DATE: 09/07/01  ECO: *N122* */
/* Revision: 1.11.1.9      BY: Kirti Desai        DATE: 03/14/02  ECO: *N1D4* */
/* Revision: 1.11.1.12     BY: Katie Hilbert      DATE: 04/15/02  ECO: *P03J* */
/* Revision: 1.11.1.13     BY: Ashutosh Pitre     DATE: 08/19/03  ECO: *P0ZZ* */
/* $Revision: 1.11.1.14 $  BY: Robin McCarthy     DATE: 04/19/04  ECO: *P15V* */



/* REVISION: 1.0      LAST MODIFIED: 2008/05/07   BY: Softspeed roger xiao   ECO:*xp001* */
/* REVISION: 1.0      LAST MODIFIED: 2008/06/16   BY: Softspeed roger xiao   ECO:*xp002* */  /*add:出货指示号*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

define variable del-form-line-1        as character.
define variable del-form-line-2        as character.
define variable del-form-line-3        as character.
define variable del-form-line-4        as character.
define variable del-form-line-5        as character.
define variable disp-add-item          as character no-undo format "x(70)".
define variable disp-add-new-container as character no-undo format "x(70)".
define variable disp-add-new-container-plus-cont as character
                                                    no-undo format "x(70)".
define variable disp-add-exist         as character no-undo format "x(70)".

/* WORKBENCH MAIN DISPLAY FORM */
form
   first_column label "Level"
   disp_line
with frame k width 80  /*7*/ 6   /*xp001*/ down scroll 1
title color normal (getFrameTitle("SHIPPER_WORKBENCH",25)) attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame k:handle).
disp_line:label in frame k = getTermLabel("ORDER",5)           + fill(" ",4)
                           + getTermLabel("LINE",2)            + fill(" ",2)
                           + getTermLabel("ITEM_NUMBER",11)    + fill(" ",8)
                           + getTermLabel("QUANTITY",8)        + fill(" ",4)
                           + getTermLabel("UNIT_OF_MEASURE",2) + fill(" ",1)
                           + getTermLabel("CONTAINER",9)       + fill(" ",1)
                           + getTermLabel("CANC_B/O",8).

/* ADD OPTIONS FRAME */
form
   disp-add-item                    no-label
   skip
   disp-add-new-container           no-label
   skip
   disp-add-new-container-plus-cont no-label
   skip
   disp-add-exist                   no-label
with frame m width 80 title color normal (getFrameTitle("ADD_OPTIONS",17)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame m:handle).

assign
   disp-add-item:screen-value =
      " 1 - " + getTermLabel("ADD_ITEM", 60)
   disp-add-new-container:screen-value =
      " 2 - " + getTermLabel("ADD_NEW_CONTAINER",60)
   disp-add-new-container-plus-cont:screen-value =
      " 3 - " + getTermLabel("ADD_NEW_CONTAINER_(PLUS_CONTENTS)",60)
   disp-add-exist:screen-value =
      " 4 - " + getTermLabel("ADD_EXISTING_CONTAINER",60).

assign
   del-form-line-1 =   "1 - " + getTermLabel("DELETE_PRE-SHIPPER/SHIPPER",60)
   del-form-line-2 =   "2 - " + getTermLabel("DELETE_ITEM/CONTAINER_LINE",60)
   del-form-line-3 =   "3 - " + getTermLabel("DELETE_CONTAINER_PLUS_CONTENTS",60)
   del-form-line-4 =   "4 - " + getTermLabel("REMOVE_CONTAINER",60)
   del-form-line-5 =   "5 - " + getTermLabel("REMOVE_CONTAINER_PLUS_CONTENTS",60).

/* DELETE OPTIONS FRAME */
form
   del-form-line-1 format "x(70)" skip
   del-form-line-2 format "x(70)" skip
   del-form-line-3 format "x(70)" skip
   del-form-line-4 format "x(70)" skip
   del-form-line-5 format "x(70)"
with frame m1 no-label width 80
title color normal (getFrameTitle("DELETE_OPTIONS",21)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame m1:handle).

/* WORKBENCH LOWER UPDATE FRAME */
form
   part_order           colon 16 label "Sales Order"
   part_order_line      colon 35 label "Line"
   sod_contr_id         colon 53 label "PO" format "x(23)"
   ship_line.abs_qty    colon 16 label "Quantity" format "->,>>>,>>9.9<<<"
   ship_line.abs__qad02 colon 35 label "UM" format "XX"
   ship_line.abs_site   colon 53
   ship_line.abs_loc             label "Loc"
   l_abs_pick_qty       colon 16 label "Qty Picked" format "->,>>>,>>9.9<<<"
   ship_line.abs_lotser colon 53 label "Lot/Serial"
   ship_line.abs_nwt    colon 16
   ship_line.abs_wt_um           no-label
   ship_line.abs_ref    colon 53                        format "x(8)"
   sod_type             colon 68 label "Type" format "X"
   l_abs_tare_wt        colon 16 label "Tare Weight"
   l_twt_um                      no-label
   cnsm_req             colon 53 label "Consume Req"
   ship_line.abs_fa_lot          label " ID"
   ship_line.abs_gwt    colon 16
   gwt_um                        no-label
   pt_desc1             colon 53                        format "X(21)"
   ship_line.abs_vol    colon 16
   ship_line.abs_vol_um          no-label
   cmmts                colon 53
   cancel_bo            colon 71 label "Cancel B/O"
   ship_line.abs__chr01           colon 16 label "流水号" format "x(20)" /*xp001*/
   ship_line.abs__chr02            label "出货指示号" format "x(8)" /*xp002*/
with frame sample side-labels width 80 1 down attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame sample:handle).

/* CONSUME REQUIREMENT FORM */
form
   space
   abs_qty
   peg_qty    label "Peg Qty"
with frame peg-1 width 80 overlay centered row 8 side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame peg-1:handle).

abs_qty:label in frame peg-1 = getTermLabel("QUANTITY_TO_SHIP",12).

/*V8:EditableDownFrame=peg-2 */
form
   schd_date
   schd_time
   schd_interval  label "Int"
   schd_reference
   open_qty       column-label "Open Qty"
   absr_qty       column-label "Ship Line!Peg Qty"
with frame peg-2 overlay width 80 centered 5 down
attr-space scroll 1 row 11
title color normal (getFrameTitle("CONSUME_REQD_SHIP_SCHD_REQUIREMENTS",59)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame peg-2:handle).
