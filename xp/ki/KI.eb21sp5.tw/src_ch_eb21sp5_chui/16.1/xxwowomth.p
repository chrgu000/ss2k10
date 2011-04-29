/* xxwowomth.p - WORK ORDER MAINTENANCE JOINT ORDERS                    */
/* wowomth.p - WORK ORDER MAINTENANCE JOINT ORDERS                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.19 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      LAST EDIT: 03/30/95      MODIFIED BY: tjs *J027*        */
/* REVISION: 8.5      LAST EDIT: 03/13/95      MODIFIED BY: ktn *J040*        */
/* REVISION: 8.5      LAST EDIT: 04/23/95      MODIFIED BY: sxb *J04D*        */
/* REVISION: 8.5      LAST EDIT: 06/28/95      MODIFIED BY: srk *J056*        */
/* REVISION: 8.5      LAST EDIT: 09/01/95      MODIFIED BY: tjs *J07F*        */
/* REVISION: 8.5      LAST EDIT: 09/26/95      MODIFIED BY: srk *J081*        */
/* REVISION: 8.5      LAST EDIT: 09/28/95      MODIFIED BY: kxn *J072*        */
/* REVISION: 8.5      LAST EDIT: 10/13/95      MODIFIED BY: kxn *J08R*        */
/* REVISION: 8.5      LAST EDIT: 11/20/95      MODIFIED BY: kxn *J09C*        */
/* REVISION: 8.5      LAST EDIT: 06/03/96      MODIFIED BY: ruw *J0Q9*        */
/* REVISION: 8.5      LAST EDIT: 06/11/96      MODIFIED BY: sxb *J0SM*        */
/* REVISION: 8.5      LAST EDIT: 06/28/96      MODIFIED BY: ame *J0WG*        */
/* REVISION: 8.5      LAST EDIT: 02/04/97       BY: *J1GW* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 01/12/98   BY: *J29Q* Rajesh Talele      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 01/27/99   BY: *J38V* Viswanathan M      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.14     BY: Manish Kulkarni     DATE: 11/19/00 ECO: *P008*      */
/* Revision: 1.15     BY: Irine D'Mello       DATE: 09/10/01 ECO: *M164*      */
/* Revision: 1.16  BY: Katie Hilbert DATE: 03/19/02 ECO: *P04W* */
/* Revision: 1.18  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/* $Revision: 1.19 $   BY: Bharath Kumar  DATE: 10/25/04  ECO: *P2Q3* */
/* REVISION: 8.5      LAST MODIFIED: 01/12/98  BY: *090815.1* Rajesh Talele */
/* REVISION: 8.5      LAST MODIFIED: 09/05/01  BY: hkm *090815.1*          */ 
/*                    1. Change format of Frame a & calling program ID  */
/* REVISION: 8.5      LAST MODIFIED: 04/09/02    BY: hkm *090815.1*       */
/*                    1. Modify xxwowomta.p to calculate release date   */


/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable wostatus like wo_status.
define new shared variable conv     like ps_um_conv.

define shared variable wo_recno     as recid.
define shared variable wonbr        like wo_nbr.
define shared variable wolot        like wo_lot.
define shared variable wopart       like wo_part.
define shared variable prev_qty     like wo_qty_ord.
define shared variable prev_routing like wo_routing.
define shared variable prev_bomcode like wo_bom_code.
define shared variable prev_status  like wo_status.
define shared variable base_lot     like wo_lot.
define shared variable base_qty     like wo_qty_ord.
define shared variable base_um      like bom_batch_um.
define shared variable new_wo       like mfc_logical.
define shared variable add_2_joint  like mfc_logical.
define shared variable rel_date     like wo_rel_date.
define shared variable due_date     like wo_due_date.
define shared variable updt_subsys  like mfc_logical.
define shared variable del-yn       like mfc_logical initial no.
define shared variable del-joint    like mfc_logical initial no.
define shared variable undo_all     like mfc_logical no-undo.
define shared variable any_issued   like mfc_logical.
define shared variable any_feedbk   like mfc_logical.
define shared variable joint_type   like wo_joint_type.
define shared variable joint_qtys   like mfc_logical
                                    label "Adjust Co/By Order Quantities"
                                    initial yes.

define variable i                   as integer.
define variable nonwdays            as integer.
define variable workdays            as integer.
define variable overlap             as integer.
define variable interval            as integer.
define variable frwrd               as integer.
define variable co_products         as integer.
define variable know_date           as date.
define variable find_date           as date.
define variable valid_mnemonic      like mfc_logical.
define variable joint_code          like wo_joint_type.
define variable joint_label         like lngd_translation.
define variable qty_type            like wo_qty_type.
define variable tot_prod_pct        like wo_prod_pct.
define variable tot_prod_pctx       as character.
define variable prod_percent        like mfc_logical.
define variable batch_size          like bom_batch.
define variable sav_qty             like wo_qty_ord.
define variable sav_driver_id       like wo_lot.
define variable trans-ok            like mfc_logical.
define variable displayed-lines     as integer no-undo.
define variable msg-text            as character no-undo.

define new shared frame attrmt.

/* ATTRIBUTES FRAME DEFINITION */
{mfwoat.i}

define shared frame a.
define new shared frame c.
define new shared frame d.
define new shared frame e.

define buffer wo_mstr1 for wo_mstr.

find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock no-error.
if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock.
end.


/* HEADER FOR ADD WO */
form
   wo_nbr              colon 25
   wo_lot
   wo_part             colon 25
/* SS 090815.1 - B */
/*
   pt_desc1            at 47 no-label
   wo_type             colon 25
   pt_desc2            at 47 no-label
*/
   wo_type        colon 51
   pt_desc1       at 27 no-label format 'x(49)'
   pt_desc2       at 27 no-label format 'x(49)'
/* SS 090815.1 - E */
   wo_site             colon 25
   joint_label         at 47 no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* HEADER FOR BASE WORK ORDER */
form
   wo_nbr              colon 15
   wo_bom_code         colon 57
   wo_status           colon 15
   wo_qty_ord          colon 31
   batch_size          colon 60 label "Standard Batch"
with frame c side-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/* DISPLAY WOS */
form
   wo_part
   pt_desc1            format "x(23)"
   wo_qty_ord
   pt_um
   wo_prod_pct
   wo_lot
   joint_code
with frame d 5 down no-attr-space width 80
title color normal (getFrameTitle("CO/BY-PRODUCT_WORK_ORDERS",36)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* UPDATE WO */
form
   wopart              colon 20
   pt_desc1                     no-label
   wolot
   wo_prod_pct         colon 20
   qty_type            colon 49
   wo_qty_ord          colon 20
   pt_um                        no-label
   joint_code          colon 49
   joint_label                  no-label
   wo_qty_comp         colon 20
with frame e side-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

/* ADJUST JOINT ORDER QUANTITIES */
form
   joint_qtys          colon 35
with frame f overlay side-labels row 12 column 20 width 45.

/* SET EXTERNAL LABELS */
setFrameLabels(frame f:handle).

/* DISPLAY THE BASE WORK ORDER & ITS STD BATCH SIZE */
find wo_mstr no-lock
   where recid(wo_mstr) = wo_recno.

if wo_joint_type = "5"
then
   base_lot = wo_lot.
else
   base_lot = wo_base_id.

assign
   sav_driver_id = wo_lot
   sav_qty = prev_qty
   wolot = "".

mainloop:
repeat:

   if wo_joint_type <> "5"
   then do:

      find wo_mstr no-lock
          where wo_mstr.wo_domain = global_domain and  wo_lot = base_lot
          no-error.

      if not available wo_mstr
      then
         leave.
   end.

   /* SAVE DEFAULTS FOR ADD */
   assign
      wonbr        = wo_nbr
      wostatus     = wo_status
      base_qty     = wo_qty_ord
      rel_date     = wo_rel_date
      due_date     = wo_due_date
      batch_size   = 1.

   find pt_mstr no-lock
       where pt_mstr.pt_domain = global_domain and  pt_part = wo_part.

   base_um = pt_um.

   find bom_mstr no-lock
       where bom_mstr.bom_domain = global_domain and  bom_parent = wo_bom_code
       no-error.

   if available bom_mstr
   then do:
      base_um = bom_batch_um.
      if bom_batch <> 0
      then
         batch_size = bom_batch.
   end.

   display
      wo_nbr
      wo_bom_code
      wo_status
      string(round(wo_qty_ord,6)) + " " + base_um @ wo_qty_ord
      string(batch_size) + " " + base_um @ batch_size
   with frame c.

   tot_prod_pct = 0.

   /* DISPLAY THE JOINT WORK ORDERS IN DOWN FRAME */
   view frame d.

   assign
      displayed-lines = 0
      co_products = 0.

   for each wo_mstr
       where wo_mstr.wo_domain = global_domain and  wo_nbr = wonbr
        and wo_type = ""
      exclusive-lock with frame d:

      find pt_mstr no-lock
          where pt_mstr.pt_domain = global_domain and  pt_part = wo_part.

      /* RE-CALC PERCENT OF PRODUCTION */
      wo_prod_pct = 0.
      if base_qty <> 0 and wo_joint_type <> "5" and
         wo_qty_type = "P"
      then do:

         /* UOM CONVERSION FACTOR */
         conv = 1.
         if pt_um <> base_um
         then do:

            {gprun.i ""gpumcnv.p""
               "(base_um, pt_um, wo_part, output conv)"}
            if conv = ? then conv = 0.
         end.

         if conv <> 0
         then
            wo_prod_pct = ((wo_qty_ord / conv) / base_qty) * 100.
      end.

      /* NUMERIC WO_JOINT_TYPE RETURNS ALPHA CODE, LABEL */
      {gplngn2a.i &file     = ""wo_mstr""
         &field    = ""wo_joint_type""
         &code     = wo_joint_type
         &mnemonic = joint_code
         &label    = joint_label}

      if wo_joint_type = "1"
      then
         co_products = co_products + 1.

      tot_prod_pct = tot_prod_pct + wo_prod_pct.

      if wo_lot >= wolot
         and displayed-lines < frame-down(d)
      then do:

         display
            wo_part
            pt_desc1
            wo_prod_pct when (wo_prod_pct <> 0)
            wo_qty_ord
            pt_um
            wo_lot
            joint_code.

         displayed-lines = displayed-lines + 1.

         if displayed-lines < frame-down(d) then
            down 1 with frame d.
      end.

   end.

   wolot = "".

   msg-text = "(" + string(tot_prod_pct) + "%) ".
   /*PERCENT OF BATCH TOTAL*/
   {pxmsg.i &MSGNUM=4605 &ERRORLEVEL=1 &MSGARG1=msg-text}

   /* UPDATE BLOCK */
   e:
   do on error undo, retry with frame e:

      del-yn = no.
      clear frame e no-pause.
      hide frame f no-pause.

      prompt-for wopart
      editing:

         if frame-field = "wopart"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i wo_mstr wo_type_nbr " wo_mstr.wo_domain = global_domain
            and wo_type=""""  and wo_nbr=wonbr"
               wo_part wopart}

            if recno <> ?
            then do:

               joint_label = "".

               /* NUMERIC WO_JOINT_TYPE RETURNS ALPHA CODE, LABEL */
               {gplngn2a.i &file     = ""wo_mstr""
                  &field    = ""wo_joint_type""
                  &code     = wo_joint_type
                  &mnemonic = joint_code
                  &label    = joint_label}

               find pt_mstr no-lock
                   where pt_mstr.pt_domain = global_domain and  pt_part =
                   wo_part.

               display
                  wo_part @ wopart
                  pt_desc1
                  wo_lot @ wolot
                  wo_prod_pct when (wo_prod_pct <> 0)
                  wo_qty_type @ qty_type
                  wo_qty_ord
                  pt_um
                  joint_code
                  joint_label
                  wo_qty_comp.

               if wo_prod_pct = 0
               then
                  display "" @ wo_prod_pct.

            end. /* RECNO <> ? */

         end.

         else do:
            readkey.
            apply lastkey.
         end.

      end.  /* PROMPT-FOR WOPART */

      wopart = input wopart.

      if not available wo_mstr and wopart <> ""
      then do:

         display
            "" @ pt_desc1
            "" @ wolot
            "" @ wo_prod_pct
            "" @ qty_type
            "" @ wo_qty_ord
            "" @ pt_um
            "" @ joint_code
            "" @ joint_label
            "" @ wo_qty_comp.

         find first wo_mstr use-index wo_part
             where wo_mstr.wo_domain = global_domain and  wo_nbr = wonbr
              and wo_part = wopart
              and wo_type = ""
            no-lock no-error.

         if available wo_mstr
         then do:

            wolot = wo_lot.

            find wo_mstr
                where wo_mstr.wo_domain = global_domain and  wo_lot = wolot
                exclusive-lock no-error.

            joint_label = "".

            /* NUMERIC WO_JOINT_TYPE RETURNS ALPHA CODE, LABEL */
            {gplngn2a.i &file     = ""wo_mstr""
               &field    = ""wo_joint_type""
               &code     = wo_joint_type
               &mnemonic = joint_code
               &label    = joint_label}

            display
               wo_part @ wopart
               wo_lot @ wolot
               wo_prod_pct when (wo_prod_pct <> 0)
               wo_qty_type @ qty_type
               wo_qty_ord
               joint_code
               joint_label
               wo_qty_comp.

            if wo_prod_pct = 0
            then
               display
                  "" @ wo_prod_pct.

         end.

         find pt_mstr no-lock
             where pt_mstr.pt_domain = global_domain and  pt_part = wopart
             no-error.

         if available pt_mstr
         then
            display
               pt_desc1
               pt_um.

         if not available pt_mstr
         then do:

            /* ITEM NUMBER DOES NOT EXIST.*/
            {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
            next-prompt wopart.
            undo, retry.
         end.

      end.

      if available wo_mstr and wo_part <> wopart
      then do:
         clear frame e no-pause.
         display wopart.
      end.

      prompt-for wolot
      editing:

         if frame-field = "wolot"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i wo_mstr wo_type_nbr " wo_mstr.wo_domain = global_domain
            and wo_type=""""  and wo_nbr=wonbr"
               wo_lot wolot}

            if recno <> ?
            then do:

               joint_label = "".
               /* NUMERIC WO_JOINT_TYPE RETURNS ALPHA CODE, LABEL */
               {gplngn2a.i &file     = ""wo_mstr""
                  &field    = ""wo_joint_type""
                  &code     = wo_joint_type
                  &mnemonic = joint_code
                  &label    = joint_label}

               find pt_mstr no-lock
                   where pt_mstr.pt_domain = global_domain and  pt_part =
                   wo_part.

               display
                  wo_part @ wopart
                  pt_desc1
                  wo_lot @ wolot
                  wo_prod_pct when (wo_prod_pct <> 0)
                  wo_qty_type @ qty_type
                  wo_qty_ord
                  pt_um
                  joint_code
                  joint_label
                  wo_qty_comp.

               if wo_prod_pct = 0
               then
                  display
                     "" @ wo_prod_pct.
            end. /* RECNO <> ? */

         end.

         else do:
            readkey.
            apply lastkey.
         end.

      end.  /* prompt-for wolot */

      wolot = input wolot.

      if wopart = "" and wolot = ""
      then
         undo, retry.

      find wo_mstr exclusive-lock
          where wo_mstr.wo_domain = global_domain and  wo_lot = wolot no-error.

      if not available wo_mstr
      then do:

         if wolot <> "" and wolot <> ?
         then
            find wo_mstr exclusive-lock
                where wo_mstr.wo_domain = global_domain and  wo_lot = wolot
                no-error.

         else do:

            if wolot <> ?
            then
               find first wo_mstr use-index wo_part
                   where wo_mstr.wo_domain = global_domain and  wo_nbr = wonbr
                    and wo_part = wopart
                    and wo_type = ""
                  no-lock no-error.

            if available wo_mstr
            then do:

               wolot = wo_lot.
               find wo_mstr
                   where wo_mstr.wo_domain = global_domain and  wo_lot = wolot
                   exclusive-lock no-error.
            end.
         end.
      end.

      if available wo_mstr and
         (wo_nbr <> wonbr or wo_type <> "")
      then do:

         /* LOT NUMBER BELONGS TO DIFFERENT WORK ORDER */
         {pxmsg.i &MSGNUM=508 &ERRORLEVEL=3 &MSGARG1=wo_nbr}
         undo, retry.
      end.

      if not available wo_mstr
      then do:

         display
            "" @ wo_prod_pct
            "" @ wo_qty_ord
            "" @ pt_um
            "" @ joint_code
            "" @ joint_label
            "" @ wo_qty_comp.
         wo_recno = ?.

         /* ADD JOINT PRODUCT WO */
/* SS 090815.1 - B */
/*
         {gprun.i ""wowomth1.p""}
*/
         {gprun.i ""xxwowomth1.p""}
/* SS 090815.1 - E */
         if undo_all or wo_recno = ?
         then do:
            next-prompt wopart.
            undo, retry.
         end.

         find wo_mstr exclusive-lock
            where recid(wo_mstr) = wo_recno.

      end.
      else
         new_wo = no.

      assign
         prev_qty = wo_qty_ord
         joint_type = wo_joint_type
         joint_label = "".

      /* NUMERIC WO_JOINT_TYPE RETURNS ALPHA CODE, LABEL */
      {gplngn2a.i &file     = ""wo_mstr""
         &field    = ""wo_joint_type""
         &code     = wo_joint_type
         &mnemonic = joint_code
         &label    = joint_label}

      find pt_mstr no-lock
          where pt_mstr.pt_domain = global_domain and  pt_part = wo_part.

      /* RE-CALC PERCENT OF PRODUCTION */
      wo_prod_pct = 0.
      prod_percent = no.
      if base_qty <> 0 and wo_joint_type <> "5" and
         (wo_qty_type = "P" or (wo_qty_type = "B" and new_wo))
      then do:

         /* UOM CONVERSION FACTOR */
         conv = 1.
         if pt_um <> base_um
         then do:

            {gprun.i ""gpumcnv.p""
               "(base_um, pt_um, wo_part, output conv)"}
            if conv = ? then conv = 0.
         end.

         if conv <> 0
         then do:

            if wo_qty_ord <> 0 then
               wo_prod_pct = ((wo_qty_ord / conv) / base_qty) * 100.
            prod_percent = yes.
         end.
      end.

      display
         wo_part @ wopart
         pt_desc1
         wo_lot @ wolot
         wo_prod_pct when (wo_prod_pct <> 0)
         wo_qty_type @ qty_type
         wo_qty_ord
         pt_um
         joint_code
         joint_label
         wo_qty_comp.

      if wo_prod_pct = 0
      then
         display
            "" @ wo_prod_pct.

      ststatus = stline[2].
      status input ststatus.

      /* REPEAT SO NEXT-PROMPT WORKS */
      repeat with frame e:

         if prod_percent
         then do:

            set wo_prod_pct go-on(F1 CTRL-X F5 CTRL-D).

            if lastkey <> keycode("F5") and
               lastkey <> keycode("CTRL-D")
            then do:

               /* RECALC WO_QTY_ORD */
               if conv <> 0 and base_qty <> 0 and wo_prod_pct <> 0 then
                  wo_qty_ord = base_qty * (wo_prod_pct / 100) * conv.

               display
                  wo_qty_ord.

               if lastkey <> keycode("F1")
               then do:

                  set
                     wo_qty_ord
                     joint_code when (wo_joint_type <> "5")
                  go-on(F1 CTRL-X F5 CTRL-D).

                  if wo_qty_ord entered
                  then do:

                     /* RECALC WO_PROD_PCT */
                     if conv <> 0 and base_qty <> 0
                        and wo_status <> "F"
                     then
                        wo_prod_pct = ((wo_qty_ord * conv) / base_qty) * 100.
                     display
                        wo_prod_pct.
                  end.
               end.

            end.

         end.

         else
         set
            wo_qty_ord
            joint_code when (wo_joint_type <> "5")
         go-on(F1 CTRL-X F5 CTRL-D).

         if wo_qty_ord < 0
         then do:

            /* NEGATIVE NUMBERS NOT ALLOWED */
            {pxmsg.i &MSGNUM=5619 &ERRORLEVEL=3}.
            undo, retry.
         end.

         /* BATCH QTY TYPE ALLOWS % OF PROCESS AT ADD (NOT MODIFY) */
         if new_wo and wo_qty_type = "B"
         then
            wo_prod_pct = 0.

         if joint_code entered
         then do:

            /* VALIDATE JOINT_CODE MNEMONIC */
            {gplngv.i &file     = ""wo_mstr""
               &field    = ""wo_joint_type""
               &mnemonic = joint_code
               &isvalid  = valid_mnemonic}

            if not valid_mnemonic
            then do:

               /* INVALID JOINT TYPE */
               {pxmsg.i &MSGNUM=6501 &ERRORLEVEL=3}
               next-prompt joint_code.
               undo, retry.
            end.

            /* ALPHA JOINT_CODE RETURNS NUMERIC JOINT_TYPE, LABEL */
            {gplnga2n.i &file     = ""wo_mstr""
               &field    = ""wo_joint_type""
               &mnemonic = joint_code
               &code     = joint_type
               &label    = joint_label}

            display
               joint_label.

            if joint_type = "5"
            then do:

               /* JOINT WORK ORDERS MAY HAVE ONLY ONE BASE ORDER */
               {pxmsg.i &MSGNUM=6542 &ERRORLEVEL=3}
               next-prompt joint_code.
               undo, retry.
            end.

            if joint_type <> "1" and co_products = 1
            then do:

               /* JOINT WORK ORDERS MUST HAVE AT LEAST ONE CO-PRODUCT*/
               {pxmsg.i &MSGNUM=6545 &ERRORLEVEL=3}
               next-prompt joint_code.
               undo, retry.
            end.

            wo_joint_type = joint_type.

         end.

         leave.

      end. /* REPEAT */

      if available clc_ctrl
         and (lookup(wo_status,"P,B,C,") = 0)
         and lastkey <> keycode("F5") and lastkey <> keycode("CTRL-D")
         and lastkey <> keycode(kblabel("END-ERROR"))
      then do:

         wo_recno = recid(wo_mstr).
         hide frame d no-pause.
         hide frame e no-pause.

         if pt_auto_lot = yes and pt_lot_grp = " "
         then do:

            if wo_lot_next = ""
            then
               wo_lot_next = wo_lot.
            wo_lot_rcpt = no.
         end.

         {gprun.i ""clatmt1.p"" "(wo_recno)"}
         hide frame attrmt no-pause.
         view frame d.
         view frame e.

      end.

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:

         if new_wo then undo e, retry e.

         do for wo_mstr1:

            /* CHECK FOR JOINT ORDERS WITH WO_WIP_TOT */
            find first wo_mstr1
                where wo_mstr1.wo_domain = global_domain and  wo_mstr1.wo_nbr =
                wo_mstr.wo_nbr
                 and wo_mstr1.wo_type = ""
                 and wo_mstr1.wo_wip_tot <> 0
               no-lock no-error.

            if wo_mstr.wo_wip_tot <> 0 or available wo_mstr1
            then do:

               /* DELETE NOT ALLOWED, W.ORDER ACCOUNTING MUST BE CLOSED */
               {pxmsg.i &MSGNUM=536 &ERRORLEVEL=3}
               undo e, retry e.
            end.

            del-yn = yes.
            /* PLEASE CONFIRM DELETE */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn
                     &CONFIRM-TYPE='LOGICAL'}
            if del-yn = no then undo e.

            del-joint = no.

            /* DELETE JOINT WORK ORDERS? */
            {pxmsg.i &MSGNUM=6541 &ERRORLEVEL=1 &CONFIRM=del-joint
                     &CONFIRM-TYPE='LOGICAL'}

            /* ABOUT TO DELETE LAST REMAINING CO-PRODUCT WO? */
            if not del-joint and wo_mstr.wo_joint_type = "1"
            then
               find first wo_mstr1 no-lock
                   where wo_mstr1.wo_domain = global_domain and
                   wo_mstr1.wo_nbr =  wo_mstr.wo_nbr
                    and wo_mstr1.wo_lot <> wo_mstr.wo_lot
                    and wo_mstr1.wo_joint_type = "1" no-error.

            /* MUST DEL JOINT SET IF BASE OR THE LAST REMAINING     */
            /* CO-PROD IS DELETED. ALSO STATUS F IS ALL OR NOTHING. */
            if not del-joint and
               (wo_mstr.wo_joint_type = "5" or
                wo_mstr.wo_status = "F" or
               (wo_mstr.wo_joint_type = "1" and
                not available wo_mstr1))
            then do:

               del-yn = no.
               undo e, retry e.
            end.

         end. /* DO FOR WO_MSTR1 */

         wo_recno = recid(wo_mstr).

         {gprun.i ""wowomte.p""}

         clear frame a no-pause.

         clear frame d all no-pause.

         del-yn = no.
         updt_subsys = no.

         if del-joint then
            leave.

         wolot = "".
         find wo_mstr no-lock
             where wo_mstr.wo_domain = global_domain and  wo_lot = base_lot
             no-error.
         wo_recno = recid(wo_mstr).
         next mainloop.

      end.

      if (wo_qty_ord entered or wo_prod_pct entered) and not del-yn and
         lastkey <> keycode(kblabel("END-ERROR"))
      then do:

         wo_recno = recid(wo_mstr).

         /* UPDATE COMPONENT MRP_DET, IN_MSTR, ON ORDER, ETC */
/* SS 090815.1 - B */
/*
         {gprun.i ""wowomta.p""}
*/
         {gprun.i ""xxwowomta.p""}
/* SS 090815.1 - E */

         if undo_all or any_issued or any_feedbk
         then do:

            if undo_all
            then do:

               if wo_status = "A"
               then do:

                  /* CRITICAL PART NOT AVAIL, WO NOT ALLOCATED.*/
                  {pxmsg.i &MSGNUM=4985 &ERRORLEVEL=2}
               end.

               else do:
                  /*CRITICAL ITEM NOT AVAIL, STATUS CHGD FROM R to E */
                  {pxmsg.i &MSGNUM=6547 &ERRORLEVEL=2}
                  wo_status = "E".
                  display
                     wo_status
                  with frame b.
                  /* UPDATE OTHER JOINT ORDER WITH STATUS */
                  wo_recno = recid(wo_mstr).
                  {gprun.i ""wowomti.p""}
               end.
            end.

            if any_issued
            then do:

               /* WORK ORDER COMPONENTS HAVE BEEN ISSUED */
               {pxmsg.i &MSGNUM=529 &ERRORLEVEL=4}
            end.

            if any_feedbk
            then do:

               /* LABOR FEEDBACK HAS BEEN REPORTED */
               {pxmsg.i &MSGNUM=554 &ERRORLEVEL=4}
            end.
            undo e, retry e.
         end.

         /* AVOID WOWOMTA VIA WOWOMT ON THIS ID, IT WAS JUST DONE. */
         if sav_driver_id = wo_lot
         then
            updt_subsys = no.

         /* ASK IF OTHER JOINT WOS NEED UPDATE. */
         joint_qtys = no.

         if wo_status = "F"
         then
            joint_qtys = yes.

         if joint_qtys = no and prev_qty <> 0
         then do:

            pause 0.
            /* ADJUST JOINT ORDER QUANTITIES? */
            update
               joint_qtys
            with frame f.
            hide frame f no-pause.
         end.

         if joint_qtys
         then do:

            wo_recno = recid(wo_mstr).
            /* UPDATE OTHER WOS IN SET */
            {gprun.i ""wowomti.p""}
            if undo_all then undo e, retry e.
         end.

      end. /* WO_QTY_ORD ENTERED OR WO_PROD_PCT ENTERED . . */

      if lastkey = keycode(kblabel("END-ERROR"))
      then do:
         undo e, retry e.
      end.

   end.  /* e: */

   clear frame d all no-pause.

end. /* repeat */

if available clc_ctrl and clc_lotlevel <> 0
then do:

   for each wo_mstr
       where wo_mstr.wo_domain = global_domain and  wo_nbr = wonbr
        and wo_type = ""
      exclusive-lock:

      find pt_mstr
          where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
          no-lock no-error.

      if pt_auto_lot and pt_lot_grp = ""  and
         (lookup (wo_status, "P,B,C") = 0)
      then do:

         if wo_lot_next = ""
         then do:

            assign
               wo_lot_next = wo_lot
               wo_lot_rcpt = no.
         end.

         if (clc_lotlevel = 2)
         then do:

            find first lot_mstr
                where lot_mstr.lot_domain = global_domain and  lot_serial =
                wo_lot_next
               no-lock no-error.

            if available lot_mstr and (lot_part <> wo_part)
            then do:
               /*LOT/SERIAL ALREADY EXISTS FOR ANOTHER PART  */
               {pxmsg.i &MSGNUM=2706 &ERRORLEVEL=3}
               hide frame d no-pause.
               hide frame e no-pause.
               wo_recno = recid (wo_mstr).
               {gprun.i ""clatmt2.p"" "(wo_recno)"}
               hide frame attrmt no-pause.
            end.
         end.

      end.  /* pt_auto_lot */

   end.    /* FOR EACH wo_mstr */

end.       /*  IF AVAILABLE clc_ctrl  */

/* RETURN WITH THE DRIVER WO (IF IT STILL EXISTS) */
find wo_mstr no-lock
    where wo_mstr.wo_domain = global_domain and  wo_lot = sav_driver_id
    no-error.

if available wo_mstr
then do:
   wo_recno = recid(wo_mstr).
   if updt_subsys then prev_qty = sav_qty.
end.
else
   wo_recno = ?.

hide frame attrmt no-pause.
hide frame c no-pause.
hide frame d no-pause.
hide frame e no-pause.
hide frame a no-pause.

clear all no-pause.
