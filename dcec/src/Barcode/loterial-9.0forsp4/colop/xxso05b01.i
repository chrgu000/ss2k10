/* xxso05b01.i SALES ORDER PRINT INCLUDE FILE                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.17 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0     LAST MODIFIED: 07/05/90 BY: WUG *D043**/
/* REVISION: 7.2     LAST MODIFIED: 04/19/95 BY: rxm *F0PD**/
/* REVISION: 8.5     LAST MODIFIED: 05/14/97 BY: *J1RD* Suresh Nayak          */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98 BY: *L007* A. Rahane             */
/* REVISION: 8.6E    LAST MODIFIED: 04/23/98 BY: *L00L* EvdGevel              */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98 BY: *K1Q4* Alfred Tan            */
/* REVISION: 8.6E    LAST MODIFIED: 06/04/98 BY: *L01M* Jean Miller           */
/* REVISION: 8.6E    LAST MODIFIED: 07/07/98 BY: *L03G* Ed van de Gevel       */
/* REVISION: 9.0     LAST MODIFIED: 11/16/98 BY: *J34M* Manish K.             */
/* REVISION: 9.0     LAST MODIFIED: 02/06/99 BY: *M06R* Doug Norton           */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99 BY: *M0BD* Alfred Tan            */
/* REVISION: 9.1     LAST MODIFIED: 08/14/99 BY: *N01Q* Michael Amaladhas     */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane      */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00 BY: *N0JM* Mudit Mehta           */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.17 $    BY: Jean Miller          DATE: 04/16/02  ECO: *P05H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* NOTES:  To translate, change what is in quotes below and uncomment.  */
/*         This file compiles into sorp0501.p                           */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

if not et_dc_print then do:

    /***
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame c:handle).
        ***/
   display
      sod_line
      sod_part
      sod_due_date   COLUMN-LABEL "Approximate Date"
      qty_open
      sod_um
       tmp_price 
      net_price @ sod_price
      surchange LABEL "Total Cu-Surcharge" 
      ext_price    COLUMN-LABEL "Final Amount"
   with frame c WIDTH 142 STREAM-IO /*GUI*/ .

   down 1 with frame c.

end.

else do:

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame ceuro:handle).

   display
      sod_line
      sod_part
      sod_due_date
      qty_open
      sod_um
      sod_price
      ext_price
      et_ext_price   column-label " Currency Price"
   with frame ceuro width 132 STREAM-IO /*GUI*/ .

   down 1 with frame ceuro.

end.

if sod_custpart <> "" then
   put
      {gplblfmt.i &FUNC=getTermLabel(""CUSTOMER_ITEM"",16) &CONCAT="': '"}
      at 5 sod_custpart skip.
