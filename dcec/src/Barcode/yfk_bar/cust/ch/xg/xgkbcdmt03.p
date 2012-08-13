/* kbcdmt03.p - KANBAN CARD MAINTENANCE - CLOSE SINGLE CARD                  */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */

/* Revision: 1.4.1.1    BY: Patrick Rowan       DATE: 03/01/03  ECO: *P0M4*  */
/* Revision: 1.4.2.1    BY: Russ Witt           DATE: 06/27/04  ECO: *P1Y7*  */
/* $Revision: 1.4.2.2 $ BY: Russ Witt           DATE: 01/20/05  ECO: *P2MH*  */
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
define variable dummyInteger as integer no-undo.
define variable v_rowid      as rowid.

{kbcdvars.i}
{kbconst.i}
{kbvars.i}

p_msg = "".

find first knbd_det where knbd_id = p_kbid no-lock no-error.
if not available knbd_det then do:
   p_msg = "KANBAN ID DOES NOT EXIST".
   return.
end.
v_rowid = rowid(knbd_det).

for first knbd_det
where rowid(knbd_det) = v_rowid
exclusive-lock: end.


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


if knbd_active = No then do:
   return.
end.  /* if knbd_active = No */
else do:
   if knbd_active_code = {&KB-CARD-ACTIVE-CODE-CLOSE} then do:
      return.
   end.  /* if knbd_active_code = {&KB-CARD-ACTIVE-CODE-CLOSE} */
   else do:

   /* ----->  VALIDATION RULES NEEDED HERE  <----- */

      knbd_active_code = {&KB-CARD-ACTIVE-CODE-CLOSE}.

      /* CREATE TRANSACTION HISTORY */
      {pxrun.i &PROC ='updateKanbanCardWithEvent' &PROGRAM='kbknbdxr.p'
               &HANDLE=ph_kbknbdxr
               &PARAM="(buffer knbd_det,
                        input {&KB-CARDEVENT-CLOSE},
                        input today,
                        input '',
                        input '',
                        output dummyInteger)"}

   end.  /* else do */
end.  /* else do */

release knbd_det.

