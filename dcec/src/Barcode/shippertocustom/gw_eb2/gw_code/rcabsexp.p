/* GUI CONVERTED from rcabsexp.p (converter v1.78) Fri Oct 29 14:33:56 2004 */
/* rcabsexp.p - SHIPPER WORKBENCH - SUB PROGRAM                               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.1 $                                                  */

/* $Revision: 1.1 $    CREATED BY: Vinay Soman         DATE: 05/28/04 ECO: *P23X* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/*!
 * THIS PROGRAM EXPLODES THE SHIPPER/CONTAINER ID PASSED TO IT AND STORES  *
 * THE DETAILS IN TEMP-TABLE work2_abs_mstr.  IF THE ITEM SERIAL BEING     *
 * ADDED IS ALREADY PRESENT IN THE SHIPPER THEN IT RETURNS THE ITEM/SERIAL *
 * AND FLAG INDICATING THAT                                                *
 */

{mfdeclre.i}

define input        parameter i_abs_shipfrom like abs_shipfrom no-undo.
define input        parameter i_abs_id       like abs_id       no-undo.
define input-output parameter o_allowed      like mfc_logical  no-undo.
define input-output parameter o_item         as   character    no-undo.
define input-output parameter o_lot          as   character    no-undo.

{rcexptbl.i }

define variable par_shipfrom as character no-undo.
define variable par_id       as character no-undo.

for first abs_mstr
   fields (abs_id abs_item abs_line abs_loc abs_lotser
           abs_order abs_par_id abs_ref abs_shipfrom abs_site)
   where abs_mstr.abs_shipfrom = i_abs_shipfrom
     and abs_mstr.abs_id       = i_abs_id
   use-index abs_id
no-lock:
end. /* FOR FIRST abs_mstr */

if abs_mstr.abs_id begins "i"
then do:

   if can-find(first work2_abs_mstr
                  where work2_abs_mstr.w_abs_item   = abs_mstr.abs_item
                    and work2_abs_mstr.w_abs_lotser = abs_mstr.abs_lotser)
   then do:

      assign
         o_allowed = no
         o_item    = abs_mstr.abs_item
         o_lot     = abs_mstr.abs_lotser.
      return.

   end. /* IF CAN-FIND(FIRST work2_abs_mstr */

end. /* IF abs_mstr.abs_id BEGINS "i" */

create work2_abs_mstr.
assign
   work2_abs_mstr.w_abs_shipfrom = abs_mstr.abs_shipfrom
   work2_abs_mstr.w_abs_id       = abs_mstr.abs_id
   work2_abs_mstr.w_abs_par_id   = abs_mstr.abs_par_id
   work2_abs_mstr.w_abs_item     = abs_mstr.abs_item
   work2_abs_mstr.w_abs_order    = abs_mstr.abs_order
   work2_abs_mstr.w_abs_line     = abs_mstr.abs_line
   work2_abs_mstr.w_abs_site     = abs_mstr.abs_site
   work2_abs_mstr.w_abs_loc      = abs_mstr.abs_loc
   work2_abs_mstr.w_abs_lotser   = abs_mstr.abs_lotser
   work2_abs_mstr.w_abs_ref      = abs_mstr.abs_ref
   par_shipfrom                  = abs_mstr.abs_shipfrom
   par_id                        = abs_mstr.abs_id.

if recid(work2_abs_mstr) = -1 then .

for each abs_mstr
   fields (abs_id abs_item abs_line abs_loc abs_lotser
           abs_order abs_par_id abs_ref abs_shipfrom abs_site)
   where abs_mstr.abs_shipfrom = par_shipfrom
     and abs_mstr.abs_par_id   = par_id
no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


   if  abs_mstr.abs_id begins "i"
   and can-find(first pt_mstr
                   where pt_part = abs_mstr.abs_item
                     and pt_lot_ser <> "S")
   then
      next.

   {gprun.i ""rcabsexp.p"" "(input        abs_mstr.abs_shipfrom,
                             input        abs_mstr.abs_id,
                             input-output o_allowed,
                             input-output o_item,
                             input-output o_lot)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   if o_allowed = no
   then
      return.

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH abs_mstr */
