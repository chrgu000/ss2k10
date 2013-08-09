/* so05a02.i - Shipper Print Include File                                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.1 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* $Revision: 1.1 $   BY: K Paneesh          DATE: 06/12/03  ECO: *P0VB*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 9.1      LAST MODIFIED: 05/03/04   BY: *nad001* Apple Tam        */

/* DISPLAYS THE ****** Continue ****** MESSAGE FOR SO SHIPPERS */
if v_tr_type = "ISS-SO"
then do:
   display
      disp_item
      xxline
      xxnbr
      l_continue_lbl @ shipper-po
   with frame f_det.

   down with frame f_det.
end. /* if v_tr_type = "ISS-SO" */
else do:
   /* DISPLAYS THE ****** Continue ****** MESSAGE FOR NON-SO RELATED SHIPPERS */
   display
      disp_item
      xxline
      xxnbr
      l_continue_lbl @ shipper-po
   with frame f_non_so_ship.

   down with frame f_non_so_ship.
end. /* ELSE DO: */
