/* mfwarp.i - ALLOCATIONS BY ORDER REPORT include file                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.7 $                                                       */
/*V8:ConvertMode=Report                                                   */
/* REVISION: 1.0      LAST MODIFIED: 04/05/86   BY: EMB                   */
/* REVISION: 1.0      LAST MODIFIED: 09/02/86   BY: EMB *12*              */
/* REVISION: 5.0      LAST MODIFIED: 10/26/89   BY: emb *B357*            */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb            */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* Revision: 1.5  BY: Tiziana Giustozzi DATE: 09/16/01 ECO: *N12M* */
/* $Revision: 1.7 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* FIND AND DISPLAY */
/*35*/  if not can-find(first wod_det where wod_det.wod_domain = global_domain
/*35*/                    and  wod_lot = wo_lot) then do:
/*35*/          create xxwoworp02wod.
/*35*/          assign xx_wod_lot = wo_lot.
/*35*/  end.

for each wod_det  where wod_det.wod_domain = global_domain and  wod_lot =
wo_lot no-lock by wod_part /*35 with frame d */:

   /* SET EXTERNAL LABELS */
/*35   setFrameLabels(frame d:handle).  */

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   wod_part no-lock no-error.

   if wod_qty_req >= 0 then
      open_ref = max(wod_qty_req - wod_qty_iss,0).
   else
      open_ref = min(wod_qty_req - wod_qty_iss,0).

   if wo_status = "C" then open_ref = 0.

/*35   if page-size - line-counter < 3 then page.  */
   create xxwoworp02wod.
   assign xx_wod_lot = wo_lot
          xx_wod_desc1 = desc1
          xx_wod_rcpt_user = rcpt_userid
          xx_wod_rcpt_date = rcpt_date
          xx_wod_part = wod_part
          xx_wod_qty_req = wod_qty_req
          xx_wod_qty_all = wod_qty_all
          xx_wod_qty_pick = wod_qty_pick
          xx_wod_qty_iss = wod_qty_iss
          xx_wod_open_ref = open_ref
          xx_wod_iss_date = wod_iss_date
          xx_wod_deliver = wod_deliver.

/*35   display                     */
/*35      wod_part format "x(27)"  */
/*35      wod_qty_req              */
/*35      wod_qty_all              */
/*35      wod_qty_pick             */
/*35      wod_qty_iss              */
/*35      open_ref                 */
/*35      wod_iss_date             */
/*35      wod_deliver              */
/*35   with width 132 no-attr-space.*/

/*35   if available pt_mstr and pt_desc1 <> "" then down 1.     */

   if available pt_mstr and pt_desc1 <> "" then
      assign xx_wod_pt_desc = pt_desc1.
/*35      display "   " + pt_desc1 format "x(27)" @ wod_part.       */

/*   if available pt_mstr and pt_desc2 <> "" then down 1.            */

   if available pt_mstr and pt_desc2 <> "" then
      assign xx_wod_pt_desc = xx_wod_pt_desc + pt_desc2.
/*35      display "   " + pt_desc2 format "x(27)" @ wod_part.          */

end.
