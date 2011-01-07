/* woworcf.p - WORK ORDER RECEIPT W/ SERIAL NUMBERS                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3     LAST MODIFIED: 09/27/94    BY: emb *GM78*                */
/* REVISION: 8.5     LAST MODIFIED: 10/05/94    BY: taf *J035*                */
/* REVISION: 8.5     LAST MODIFIED: 10/29/94    BY: tmf *J040*                */
/* REVISION: 7.3     LAST MODIFIED: 10/31/94    BY: WUG *GN76*                */
/* REVISION: 8.5     LAST MODIFIED: 12/08/94    by: mwd *J034*                */
/* REVISION: 8.5     LAST MODIFIED: 03/08/95    BY: dzs *J046*                */
/* REVISION: 8.5     LAST MODIFIED: 10/24/95    BY: tjs *J08X*                */
/* REVISION: 8.5     LAST MODIFIED: 04/10/96    BY: *J04C* Sue Poland         */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/06/2000 BY: *N05Q* Vincent Koh        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/10/00   BY: *N091* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11          BY: Katie Hilbert       DATE: 04/01/01 ECO: *P008* */
/* Revision: 1.12          BY: Irene D'Mello       DATE: 06/15/01 ECO: *P00X* */
/* Revision: 1.13          BY: Inna Fox            DATE: 06/13/02 ECO: *P04Z* */
/* Revision: 1.16          BY: Narathip W.         DATE: 04/19/03 ECO: *P0Q7* */
/* Revision: 1.18          BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00N* */
/* Revision: 1.19          BY: Mercy Chittilapilly DATE: 11/27/03 ECO: *P1CM* */
/* $Revision: 1.20 $       BY: Vandna Rohira       DATE: 01/29/04 ECO: *P1LK* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "WOWORCF.P"}
/*110106.1*/ {xxpartbomfunc.i}
define shared variable nbr like wo_nbr.
define variable open_ref like wo_qty_ord label "Open Qty".
define shared variable rmks like tr_rmks.
define shared variable serial like tr_serial.
define shared variable ref like glt_ref.
define variable lot like ld_lot.
define variable i as integer.
define shared variable total_lotserial_qty like sr_qty.
define variable null_ch as character initial "".
define shared variable close_wo like mfc_logical label "Close".
define shared variable eff_date like glt_effdate.
define shared variable wo_recno as recid.
define shared variable prev_status like wo_status.
define shared variable prev_release like wo_rel_date.
define shared variable prev_due like wo_due_date.
define shared variable prev_qty like wo_qty_ord.
define shared variable prev_site like wo_site.
define shared variable conv like um_conv
   label "Conversion" no-undo.
define variable um like pt_um no-undo.
define variable tot_units like wo_qty_chg label "Total Units".
define variable reject_um like pt_um no-undo.
define shared variable reject_conv like conv no-undo.
define shared variable pl_recno as recid.
define shared variable fas_wo_rec like fac_wo_rec.
define shared variable reject_qty like wo_rjct_chg
   label "Scrapped Qty" no-undo.
define shared variable multi_entry like mfc_logical
   label "Multi Entry" no-undo.
define shared variable lotserial_control as character.
define shared variable site like sr_site no-undo.
define shared variable location like sr_loc no-undo.
define shared variable lotserial like sr_lotser no-undo.
define shared variable lotref like sr_ref format "x(8)" no-undo.
define shared variable lotserial_qty like sr_qty no-undo.
define shared variable jp like mfc_logical.
define shared variable base like mfc_logical.
define shared variable base_id like wo_base_id.
define shared variable undo_all like mfc_logical no-undo.
{&WOWORCF-P-TAG1}

define shared frame a.
define shared variable chg_attr like mfc_logical no-undo.

{mfworc.i }
{gpglefv.i}
undo_all = yes.

/* DISPLAY */
mainloop:
repeat with frame a:

   /*V8!       hide all no-pause.
   if global-tool-bar and
      global-tool-bar-handle <> ?
   then
      view global-tool-bar-handle.  */
   assign
      nbr                 = ""
      total_lotserial_qty = 0.

   display eff_date with frame a.
   prompt-for wo_nbr wo_lot eff_date with frame a
      editing:
      if frame-field = "wo_nbr"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i wo_mstr wo_nbr  " wo_mstr.wo_domain = global_domain and wo_nbr
         "  wo_nbr wo_nbr wo_nbr}
         if recno <> ?
         then do:
            open_ref = wo_qty_ord - wo_qty_comp - wo_qty_rjct.
            display
               wo_nbr
               wo_lot
               wo_batch
               wo_part
               wo_status
               wo_rmks
               open_ref.
            {&WOWORCF-P-TAG2}
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wo_part no-lock no-error.
            if available pt_mstr
            then
               display
                  pt_desc1
                  pt_um
                  pt_lot_ser
                  pt_auto_lot.
            else
               display
                  " " @ pt_desc1
                  " " @ pt_um
                  " " @ pt_lot_ser
                  " " @ pt_auto_lot.
         end.
      end.
      else if frame-field = "wo_lot"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         if input wo_nbr <> ""
         then do:
            {mfnp01.i
               wo_mstr
               wo_lot
               wo_lot
               "input wo_nbr"
                " wo_mstr.wo_domain = global_domain and wo_nbr "
               wo_nbr}
         end.
         else do:
            {mfnp.i wo_mstr wo_lot  " wo_mstr.wo_domain = global_domain and
            wo_lot "  wo_lot wo_lot wo_lot}
         end.
         if recno <> ?
         then do:
            open_ref = wo_qty_ord - wo_qty_comp - wo_qty_rjct.
            display
               wo_lot
               wo_batch
               wo_part
               wo_status
               wo_rmks
               open_ref.
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wo_part no-lock no-error.
            if available pt_mstr
            then
            display
               pt_desc1
               pt_um
               pt_lot_ser
               pt_auto_lot.
            else
            display
               " " @ pt_desc1
               " " @ pt_um
               " " @ pt_lot_ser
               " " @ pt_auto_lot.
         end.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end.

   display tot_units with frame a.

   nbr = input wo_nbr.
   status input.

   if nbr          = "" and
      input wo_lot = ""
   then
      undo, retry.

   if nbr          <> "" and
      input wo_lot <> ""
   then
      find wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and  wo_nbr
      = nbr using wo_lot no-error.

   if nbr           = "" and
      input wo_lot <> ""
   then
find wo_mstr no-lock using  wo_lot where wo_mstr.wo_domain = global_domain
no-error.

   if nbr         <> "" and
      input wo_lot = ""
   then
      find first wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and
      wo_nbr = nbr no-error.

   if not available wo_mstr
   then do:
      /* WORK ORDER/LOT DOES NOT EXIST. */
      {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
      undo, retry.
   end.

   eff_date = input eff_date.
   if eff_date = ?
   then
      eff_date = today.
   /* CHECK EFFECTIVE DATE */
   find si_mstr  where si_mstr.si_domain = global_domain and  si_site = wo_site
   no-lock.
   {gpglef1.i &module = ""WO""
              &entity = si_entity
              &date   = eff_date
              &prompt = "eff_date"
              &frame  = "a"
              &loop   = "mainloop"}
/*110106.1*/    if not(canAccessPart(wo_part)) then do:
/*110106.1*/        {pxmsg.i &msgnum = 90010}
/*110106.1*/        undo, retry.
/*110106.1*/    end.
   /* PREVENT PROJECT ACTIVITY RECORDING ORDERS FROM BEING UPDATED */
   if wo_fsm_type = "PRM"
   then do:
      /* CONTROLLED BY PRM MODULE*/
      {pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* PREVENT CALL ACTIVITY RECORDING ORDERS FROM BEING UPDATED */
   if wo_fsm_type = "FSM-RO"
   then do:
      /* FIELD SERVICE CONTROLLED */
      {pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}
      undo, retry.
   end.

   {gprun.i ""gpsiver.p"" "(input wo_site, input ?, output return_int)"}
   if return_int = 0
   then do:
      /* USER DOES NOT HAVE ACCESS TO SITE XXXX */
      {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=wo_site}
      undo mainloop, retry.
   end.

   if wo_type = "c" and
      wo_nbr  = ""
   then do:
      {pxmsg.i &MSGNUM=5123 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* Word Order type is flow */
   if wo_type = "w" then do:
      {pxmsg.i &MSGNUM=5285 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* CHECK FOR JOINT PRODUCT FLAGS */
   if wo_joint_type <> ""
   then do:
      assign
         jp   = yes
         base = yes.
      if wo_joint_type <> "5"
      then
         base = no.
   end.
   else
      assign
         jp   = no
         base = no.

   /* JOINT PRODUCT WORK ORDER */
   if not base
   then
      base_id = wo_base_id.
   open_ref = wo_qty_ord - wo_qty_comp - wo_qty_rjct.

   {&WOWORCF-P-TAG3}
   display
      wo_nbr
      wo_lot
      wo_batch
      wo_part
      wo_status
      wo_rmks
      open_ref
   with frame a.
   {&WOWORCF-P-TAG4}

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
   no-lock no-error.

   assign
      um   = ""
      conv = 1.
   if available pt_mstr
   then do:
      um = pt_um.
      display pt_desc1 pt_um pt_lot_ser pt_auto_lot with frame a.
   end.
   else do:
      display
         "" @ pt_desc1
         "" @ pt_um
         "" @ pt_lot_ser
         "" @ pt_auto_lot
      with frame a.
   end.

   if lookup(wo_status,"A,R" ) = 0
   then do:
      /* WORK ORDER LOT IS CLOSED, PLANNED OR FIRM PLANNED */
      {pxmsg.i &MSGNUM=523 &ERRORLEVEL=3}
      /* CURRENT WORK ORDER STATUS: */
      {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
      undo, retry.
   end.

   if wo_type    = "F" and
      fas_wo_rec = false
   then do:
      /* WORK ORDER RECEIPT NOT ALLOWED FOR FINAL ASSY ORDER */
      {pxmsg.i &MSGNUM=3804 &ERRORLEVEL=3}
      undo, retry.
   end.
   assign
      prev_status  = wo_status
      prev_release = wo_rel_date
      prev_due     = wo_due_date
      prev_qty     = wo_qty_ord
      prev_site    = wo_site
      wo_recno     = recid(wo_mstr).
   undo_all = no.
   leave.
end.
