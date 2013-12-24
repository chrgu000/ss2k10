/* rcshwbb1.i - SHIPPER WORKBENCH INCLUDE FILE                              */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 7.5    LAST MODIFIED: 07/18/95           BY: GWM *J049*        */
/* REVISION: 8.5    LAST MODIFIED: 04/24/96           BY: GWM *J0K9*        */
/* REVISION: 8.6    LAST MODIFIED: 10/14/96           BY: kxn *K003*        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 04/24/00   BY: *L0PR* Kedar Deherkar   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/06/00   BY: *N0RG* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 02/21/01   BY: *M11X* Rajesh Lokre     */

         /* PREPARE VAR DISP_LINE FOR DISPLAY */
         /* DISPLAY LINE FOR A CONTAINER OR ITEM */

/* ********** Begin Translatable Strings Definitions ********* */

/*N0RG***********BEGIN COMMENTING*************
 * &SCOPED-DEFINE rcshwbb1_i_1 "Pre-Shipper: "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE rcshwbb1_i_2 "  Ship-To: "
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE rcshwbb1_i_3 " Shipper: "
 * /* MaxLen: Comment: */
 *N0RG***********END COMMENTING************* */

/* ********** End Translatable Strings Definitions ********* */

/*L0PR*/ if available sod_det then
/*L0PR*/    cancel_bo = sod_det.sod__qadl01.
/*L0PR*/ else
/*L0PR*/    cancel_bo = no.

         if not ship_line.abs_id begins "p"
         and not ship_line.abs_id begins "s" then do:

            if ship_line.abs_id begins "c" then
            cont_id = substring(ship_line.abs_id,2).

            else cont_id = "".

/*K003*   CHANGE abs_qty FORMAT TO ALLOW NEGATIVE */
            disp_line =
            string(ship_line.abs_order,"X(8)")
            + " "
            + string(ship_line.abs_line,"XXX")
            + " "
            + string(ship_line.abs_item,"X(18)")
            + " "
            + string(ship_line.abs_qty,"->>>>,>>9.9<<<<<<<")
            + " "
            + string(ship_line.abs__qad02,"XX")
            + " "
/*L0PR**    + string(cont_id,"X(9)"). */
/*L0PR*/    + string(cont_id,"X(9)")
/*L0PR*/    + " "
/*L0PR*/    + string(cancel_bo)
/*L0PR*/    .
         end.

         else do:

            /* DISPLAY LINE FOR A PICKLIST OR SHIPPER */
            if ship_line.abs_id begins "p" then
/*J0K9         disp_line = "Picklist: ". */
/*N0RG* /*J0K9*/     disp_line = {&rcshwbb1_i_1}. */
/*N0RG*/       disp_line = getTermLabel("PRE-SHIPPER",15) + ": ".
            else
/*N0RG*        disp_line = {&rcshwbb1_i_3}. */
/*N0RG*/       disp_line = " " + getTermLabel("SHIPPER",15) + ": ".

            disp_line = disp_line
            + ship_line.abs_shipfrom
            + "/"
/*M11X**    + substring(ship_line.abs_id,2,8) */
/*M11X*/     + substring(ship_line.abs_id,2,20)
/*N0RG*     + {&rcshwbb1_i_2} */
/*N0RG*/    + "  " + getTermLabel("SHIP-TO",10) + ": "
            + shipto_code
            + " ".
/*M11X**    + shipto_name. */
         end.
