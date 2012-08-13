/* kbcdmt01.p - KANBAN CARD MAINTENANCE - ACTIVATE SINGLE CARD               */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */

/* Revision: 1.6.1.1    BY: Patrick Rowan       DATE: 03/01/03  ECO: *P0M4*  */
/* Revision: 1.6.2.1    BY: Russ Witt           DATE: 06/27/04  ECO: *P1Y7*  */
/* $Revision: 1.6.2.2 $ BY: Russ Witt           DATE: 10/30/05 ECO: *P2MH*  */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Maintenance                                             */

/* copy from  kbcdmt01.p                        date: 2006/02/22             */

define input  parameter p_kbid    like  knbd_id.
define output parameter p_msg     as    char.

{mfdeclre.i}


{pxmaint.i}
{kbconst.i}
/* Define Handles for the programs. */
{pxphdef.i kbtranxr}
{pxphdef.i gplngxr}
{pxphdef.i gputlxr}
{pxphdef.i kbknbxr}
{pxphdef.i kbknbdxr}
{pxphdef.i ppitxr}
/* End Define Handles for the programs. */

/*VARIABLES*/
{kbcdvars.i}
{kbconst.i}
{kbvars.i}

define variable routing like knbi_routing no-undo.
define variable bomcode like knbi_bom_code no-undo.

p_msg = "".

for first knbd_det
where knbd_id = p_kbid
exclusive-lock: end.

if not available knbd_det then do:
   p_msg = "KANBAN ID DOES NOT EXIST ".
   return.
end.

for first knbl_det where
          knbl_keyid = knbd_knbl_keyid
          no-lock:
end.
for first knb_mstr where
          knb_keyid = knbl_knb_keyid
          no-lock:
end.

/* VALIDATE SITE SECURITY */
for first knbsm_mstr where
          knbsm_keyid = knb_knbsm_keyid
          no-lock:

   {gprun.i ""gpsiver.p""
      "(input knbsm_site,
        input ?,
        output return_int)"}

   if return_int = 0 then do:
      p_msg = "USER DOES NOT HAVE ACCESS TO THIS SITE".
      return.
   end.
end.  /* for first knbsm_mstr */


if knbd_active then do:
   return.
end.  /* if knbd_active */
else do:

   /* VALIDATE - ACTIVE STATUS CAN ONLY CHANGE FROM NO TO YES */
   /* WHEN THE DETAILS OF THE CARD MATCH THE LOOP.            */
   for first knbs_det where
             knbs_keyid = knb_knbs_keyid
             no-lock,
       first knbi_mstr where
             knbi_keyid = knb_knbi_keyid
             no-lock:

      if knbd_kanban_quantity <> knbl_kanban_quantity then do:
         p_msg = "QUANTITY ON THE CARD DOES NOT MATCH QTY OF KB MASTER".
         return.
      end.

      {pxrun.i &PROC  = 'getKanbanRoutingAndBOM' &PROGRAM = 'kbknbxr.p'
         &HANDLE = ph_kbknbxr
         &PARAM = "(input  knbi_part,
                    input  knbsm_supermarket,
                    input  knbi_routing,
                    input  knbi_bom_code,
                    output routing,
                    output bomcode)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      if knbd_routing <> routing then do:
         p_msg = "ROUTING ON THE CARD DOES NOT MATCH ROUTING OF KB ITEM".
         return.
      end.

      if knbd_bom_code <> bomcode then do:
         p_msg = "BOM CODE ON THE CARD DOES NOT MATCH BOM CODE OF KB ITEM".
         return.
      end.

      if knbd_ref1 <> knbs_ref1 or knbd_ref2 <> knbs_ref2 then do:
         p_msg = "SOURCE OF THE CARD DOES NOT MATCH SOURCE OF KB MASTER".
         return.
      end.

   end.  /* for first knbs_det */


   for first knbism_det where
             knbism_knbsm_keyid = knb_knbsm_keyid and
             knbism_knbi_keyid  = knb_knbi_keyid
             exclusive-lock:
   end.

   {pxrun.i &PROC ='activateCard' &PROGRAM='kbknbdxr.p'
            &HANDLE=ph_kbknbdxr
            &PARAM="(buffer knbism_det,
                     buffer knbd_det,
                     buffer knbl_det)"}

end.  /* else do */

release knbd_det.
