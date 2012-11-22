/* swindap.i - AP VOUCHER MAINTENANCE Receiver Matching Detail SCROLL WIN     */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 7.4            CREATED: 10/15/93   by: pcd *H199*                */
/*                    LAST MODIFIED: 05/20/94   by: wep *H372*                */
/*                                   02/28/95   by: str *H0BP*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/*                                   04/20/95   by: srk *H0CG*                */
/*                                   07/02/96   by: jwk *H0LR*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   by: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   by: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* Mark Brown           */
/* Revision: 1.3.2.4        BY: Jean Miller       DATE: 12/03/01  ECO: *P036* */
/* Revision: 1.3.2.6        BY: Patrick Rowan     DATE: 04/17/02  ECO: *P043* */
/* Revision: 1.3.2.7        BY: Patrick Rowan     DATE: 06/18/02  ECO: *P090* */
/* Revision: 1.3.2.9        BY: Patrick Rowan     DATE: 11/15/02  ECO: *P0K4* */
/* Revision: 1.3.2.10       BY: Tiziana Giustozzi DATE: 01/13/03  ECO: *P0MX* */
/* Revision: 1.3.2.12       BY: Paul Donnelly (SB)DATE: 06/26/03  ECO: *Q00M* */
/* Revision: 1.3.2.13       BY: Vandna Rohira     DATE: 11/03/03  ECO: *P14V* */
/* Revision: 1.3.2.14       BY: Robin McCarthy    DATE: 01/05/05  ECO: *P2P6* */
/* $Revision: 1.3.2.15 $ BY: S. Nugent    DATE: 08/11/05  ECO: *P2PJ* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

define variable pvo_recno              as recid no-undo.
define variable pvo_recno1             as recid no-undo.
define variable pvoID                  as integer no-undo.

if not batchrun then do:
view frame match_detail.
end.

/* POPULATE PENDING VOUCHER TEMP-TABLE FOR VIEWING */
for each vph_hist no-lock
   where vph_domain = global_domain
   and vph_ref = vo_ref
     and vph_pvo_id <> 0
     and vph_pvod_id_line = 0
     use-index vph_ref,
each pvo_mstr no-lock
   where pvo_domain = global_domain
   and pvo_id = vph_pvo_id:

   /* UPDATE THE tt_pvo_vouchered_qty WHEN THE TEMP-TABLE RECORD IS */
   /* AVAILABLE SO THAT CORRECT INVOICE QUANTITY IS DISPLAYED IN    */
   /* RECEIVER MATCHING DETAIL FRAME                                */
   for first tt_pvo_mstr exclusive-lock
      where tt_pvo_id = pvo_mstr.pvo_id:
      tt_pvo_vouchered_qty = pvo_mstr.pvo_vouchered_qty.
   end.

   if available tt_pvo_mstr then
      next.

   create tt_pvo_mstr.
   assign
      tt_pvo_id            = pvo_mstr.pvo_id
      tt_pvo_receiver      = pvo_mstr.pvo_internal_ref
      tt_pvo_order         = pvo_mstr.pvo_order
      tt_pvo_line          = pvo_mstr.pvo_line
      tt_pvo_part          = pvo_mstr.pvo_part
      tt_pvo_supplier      = pvo_mstr.pvo_supplier
      tt_pvo_vouchered_qty = pvo_mstr.pvo_vouchered_qty
      tt_vph_ref           = vph_hist.vph_ref.

end.  /* for each vph_hist */

sw_block:
do on endkey undo, leave:

   if not batchrun then do:

      {swview.i
         &buffer       = tt_pvo_mstr
         &scroll-field = tt_pvo_receiver
         &searchkey    = "tt_vph_ref = vo_ref"
         &index-phrase = "use-index sort_order"
         &framename    = "match_detail"
         &framesize    = 4
         &display1     = tt_pvo_receiver
         &display2     = tt_pvo_line
         &display3     = "tt_pvo_order @ vph_nbr"
         &display4     = "tt_pvo_part @ pvo_part"
         &display5     = vp-part
         &display6     = "tt_pvo_vouchered_qty @ vph_inv_qty"
         &exitlabel    = loopf1
         &exit-flag    = "true"
         &record-id    = pvo_recno
         &first-recid  = pvo_recno1
         &exec_cursor  = "{apvph01.i}"
         &logical1     = true}

      if available tt_pvo_mstr then do:
         assign
            pvoID     = tt_pvo_id
            receiver  = tt_pvo_receiver
                rcvr_line = tt_pvo_line.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f:handle).
         display
            receiver
            rcvr_line
         with frame f.
      end.  /* if available pvo_mstr */

   end. /* not batchrun */

   leave sw_block.

end.  /* SW_BLOCK */
