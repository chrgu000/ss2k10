/* wolcal.p - WORK ORDER LOCATION ALLOCATION AND PICKING DETAIL               */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18.3.1 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 05/04/90      BY: MLB *D024*             */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90      BY: WUG *D619*             */
/* REVISION: 6.0      LAST MODIFIED: 05/28/91      BY: emb *D660*             */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91      BY: SMM *D887*             */
/* REVISION: 6.0      LAST MODIFIED: 11/05/91      BY: WUG *D912*             */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92      BY: emb *F295*             */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93      BY: emb *G656*             */
/* REVISION: 7.3      LAST MODIFIED: 11/15/93      BY: afs *GH26*             */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94      BY: pxd *FO84*             */
/* REVISION: 7.2      LAST MODIFIED: 11/23/94      BY: qzl *FU03*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/12/00   BY: *N09X* Antony Babu        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11         BY: Katie Hilbert     DATE: 04/01/01  ECO: *P008*   */
/* Revision: 1.16         BY: Russ Witt         DATE: 06/04/01  ECO: *P00J*   */
/* Revision: 1.17         BY: Seema Tyagi       DATE: 07/02/01  ECO: *M19H*   */
/* Revision: 1.18         BY: Jean Miller       DATE: 04/03/02  ECO: *P053*   */
/* $Revision: 1.18.3.1 $      BY: Kirti Desai       DATE: 12/03/03  ECO: *P1D2*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable totallqty like wod_qty_all.
define shared variable totpkqty like wod_qty_pick.
define shared variable wod_recno as recid.

define variable del-yn like mfc_logical.
define variable yn like mfc_logical.
define variable slad_loc like lad_loc no-undo.
define variable slad_lot like lad_lot no-undo.
define variable slad_ref like lad_ref no-undo.
define variable frametitle as character format "x(60)" no-undo.
define variable msgarg     as character format "x(20)" no-undo.

define buffer laddet for lad_det.

find wod_det where recid(wod_det) = wod_recno no-lock.
find wo_mstr where wo_lot = wod_lot no-lock.
find pt_mstr where pt_part = wod_part no-lock no-error.

loopb0:
repeat with frame alloc:

   frametitle = " " + getTermLabel("SITE",8)  + ": " +
                string(wod_site,"x(8)") + " " +
                getTermLabel("ALLOCATED/PICKED_DETAIL",32).

   form
      lad_loc
      lad_lot
      lad_ref       format "x(8)" column-label "Ref"
      lad_qty_all   format "->,>>>,>>9.9<<<<<<"
      lad_qty_pick  format "->,>>>,>>9.9<<<<<<"
   with frame alloc down attr-space column 9 row 9 overlay
   title color normal frametitle.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame alloc:handle).

   display
      wod_loc @ lad_loc
      wod_serial @ lad_lot.

   global_site = wod_site.

   display
      slad_loc @ lad_loc
      slad_lot @ lad_lot
      slad_ref @ lad_ref.

   block-do:
   do on error undo, retry:

      prompt-for
         lad_loc
         lad_lot
         lad_ref
      editing:

         assign
            global_loc = input lad_loc
            global_lot = input lad_lot
            .

         {mfnp06.i lad_det lad_det
            "lad_dataset = ""wod_det"" and lad_nbr = wod_lot
             and lad_line = string(wod_op) and lad_part = wod_part"
             lad_loc "input lad_loc" lad_lot "input lad_lot"}

         if recno <> ? then
            display
               lad_loc
               lad_lot
               lad_ref
               lad_qty_all
               lad_qty_all
               lad_qty_pick.
      end.
      status input.

      if index("LS",pt_lot_ser) > 0 and input lad_lot = "" then do:
         /* Lot/Serial Number Required */
         {pxmsg.i &MSGNUM=1119 &ERRORLEVEL=3}
         next-prompt lad_lot.
         undo, retry.
      end.
      find ld_det where
             ld_site = wod_site and ld_part = wod_part
         and ld_loc = input lad_loc and ld_lot = input lad_lot
         and ld_ref = input lad_ref
         no-error.
      if not available ld_det then do:
         /* LOCAION/PART/LOT/SERIAL DOES NOT EXIST */
         {pxmsg.i &MSGNUM=305 &ERRORLEVEL=3}
         next-prompt lad_loc.
         undo, retry.
      end.

      if not can-find (is_mstr where is_status = ld_status
                       and is_avail = yes)
      then do:
         /*LOCATION STATUS NOT AVAILABLE, CANNOT ALLOCATE*/
         {pxmsg.i &MSGNUM=4998 &ERRORLEVEL=3}
         next-prompt lad_loc.
         undo, retry.
      end.

      /* ISSUE ERROR IF THIS IS A RESTRICTED TRANSACTION   */
      for first isd_det fields (isd_status isd_tr_type isd_bdl_allowed)
      where isd_status = ld_status and isd_tr_type = "ISS-WO"
      no-lock:
        if batchrun = no or (batchrun = yes and isd_bdl_allowed = no)
        then do:
           /* RESTRICTED TRANSACTION FOR STATUS CODE: */
           {pxmsg.i &MSGNUM=373 &ERRORLEVEL=3 &MSGARG1=isd_status}
           next-prompt lad_loc.
           undo block-do, retry.
        end.
      end.   /* for first isd_det... */

      if ld_expire <> ? and ld_expire < today then do:
         /*LOT/SERIAL HAS EXPIRED*/
         {pxmsg.i &MSGNUM=76 &ERRORLEVEL=2}
      end.
      if ld_expire <> ? and ld_expire < wo_due_date then do:
         /*LOT/SERIAL DUE TO EXPIRE BEFORE DUE DATE*/
         {pxmsg.i &MSGNUM=4994 &ERRORLEVEL=2}
      end.
   end.

   find lad_det where lad_dataset = "wod_det"
      and lad_nbr = wod_lot and lad_line = string(wod_op)
      and lad_site = wod_site and lad_loc = input lad_loc
      and lad_part = wod_part and lad_lot = input lad_lot
      and lad_ref  = input lad_ref
   no-error.

   if available lad_det then do:

      {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1} /* MODIFYING EXISTING RECORD */
      /* Total lot/serial quantity entered # */
      {pxmsg.i &MSGNUM=300 &ERRORLEVEL=1 &MSGARG1=totallqty}

      find ld_det where
           ld_site = wod_site and
           ld_part = wod_part and
           ld_loc = input lad_loc and
           ld_lot = input lad_lot and
           ld_ref = input lad_ref
         no-error.
      if available ld_det then
         ld_qty_all = ld_qty_all - lad_qty_all - lad_qty_pick.
      assign
         totallqty = totallqty - lad_qty_all
         totpkqty = totpkqty - lad_qty_pick.
   end.

   else do:
      /*DON'T ALLOW TO ADD EXPIRED LOT*/
      if ld_expire <> ? and ld_expire < today then do:
         {pxmsg.i &MSGNUM=76 &ERRORLEVEL=3}
         /*LOT/SERIAL HAS EXPIRED*/
         next-prompt lad_loc.
         undo loopb0, retry.
      end.

      if pt_sngl_lot then do for laddet:
         for each laddet no-lock where lad_dataset = "wod_det"
            and lad_nbr = wod_lot and lad_line = string(wod_op)
            and lad_part = wod_part
            and lad_lot <> input lad_det.lad_lot:
            {pxmsg.i &MSGNUM=4986 &ERRORLEVEL=2}
            leave.
         end.
      end.

      /* Adding new record */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

      /*TOTAL LOT/SER QTY ENTERED*/
      {pxmsg.i &MSGNUM=300 &ERRORLEVEL=1 &MSGARG1=totallqty}

      /*LOT/SER QTY LEFT TO ALLOCATE*/
      msgarg = string(wod_qty_all - totallqty).
      {pxmsg.i &MSGNUM=4996 &ERRORLEVEL=1 &MSGARG1=msgarg}

      create lad_det.
      assign
         lad_dataset = "wod_det"
         lad_site = wod_site
         lad_nbr = wod_lot
         lad_line = string(wod_op)
         lad_loc = input lad_loc
         lad_lot = input lad_lot
         lad_ref = input lad_ref
         lad_part = wod_part.

      if pt_lot_ser = "S" then
         if wod_qty_all > 0 then
            lad_qty_all = 1.
         else lad_qty_all = -1.
   end.

   ststatus = stline[2].
   status input ststatus.

   assign
      slad_loc = input lad_loc
      slad_lot = input lad_lot
      slad_ref = input lad_ref
      .

   display lad_qty_all lad_qty_pick.
   do on error undo, retry with frame alloc:
      set lad_qty_all lad_qty_pick go-on (F5 CTRL-D).

      if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
      then do:
         if lad_qty_pick <> 0 then do:
            {pxmsg.i &MSGNUM=4988 &ERRORLEVEL=3}
            /* "QTY PICKED, DELETE NOT ALLOWED".*/
            undo, retry.
         end.
         del-yn = yes.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if not del-yn then undo, retry.
      end.
      if del-yn then do:
         delete lad_det.
         del-yn = no.
         next loopb0.
      end.

      if pt_lot_ser = "S" and lad_qty_all + lad_qty_pick <> 1
         and lad_qty_all + lad_qty_pick <> -1
         and (lad_qty_all <> 0 or lad_qty_all <> 0)
      then do:
         /* QTY MUST BE -1 OR 1 */
         {pxmsg.i &MSGNUM=314 &ERRORLEVEL=3}
         undo, retry.
      end.
   end.

   if wod_qty_req >= 0
      and wod_qty_req < totallqty + lad_qty_all +
      totpkqty + lad_qty_pick + wod_qty_iss
   then do:
      {pxmsg.i &MSGNUM=4987 &ERRORLEVEL=3}
      /* QTY REQ CANNOT BE LESS THAN ALL + PICK + ISSUED */
      next-prompt lad_qty_all.
      undo, retry.
   end.
   if wod_qty_req >= 0
      and lad_qty_all > 0
      and ld_qty_oh - ld_qty_all - lad_qty_all - lad_qty_pick < 0
   then do:
      {pxmsg.i &MSGNUM=4997 &ERRORLEVEL=3}
      /*QTY ALLOCATED WOULD EXCEED QTY AVAIL FOR THIS LOC/LOT*/
      next-prompt lad_qty_all with frame alloc.
      undo, retry.
   end.

   assign
      ld_qty_all = ld_qty_all + lad_qty_all + lad_qty_pick
      totallqty = totallqty + lad_qty_all
      totpkqty = totpkqty + lad_qty_pick.

   if totallqty = wod_qty_req - wod_qty_iss - totpkqty
      then leave.

   if wod_qty_req >= 0
      and wod_qty_req < totallqty + totpkqty + wod_qty_iss
   then do:
      {pxmsg.i &MSGNUM=4987 &ERRORLEVEL=3}
      /*QTY REQ CANNOT BE LESS THAN ALL + PICK + ISSUED*/
      undo, retry.
   end.

   if wod_qty_all - totallqty > 0 then do:
      {pxmsg.i &MSGNUM=4995 &ERRORLEVEL=2}
      /*TOTAL LOT QUANTITY LESS THAN QTY ALLOCATED*/
   end.

end. /*loopb0*/
