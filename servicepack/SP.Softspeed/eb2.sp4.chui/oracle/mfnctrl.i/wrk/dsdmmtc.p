/* dsdmmtc.p - DISTR SITE INTER-PLANT REQ'N MAINT (SUBPROGRAM)                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.6 $                                                   */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3            CREATED: 03/14/95   BY: srk *G0HD*                */
/* REVISION: 8.5      LAST MODIFIED: 10/18/94   BY: mwd *J034*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 8.5      LAST MODIFIED: 04/05/95   BY: pxd *F0PZ*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/13/00   BY: *L0ZF* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* $Revision: 1.7.1.6 $  BY: Samir Bavkar   DATE: 07/31/01 ECO: *P009*    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable req_nbr like dsr_req_nbr.
define shared variable dsrcmmts like woc_wcmmts label "Comments".
define shared variable dsdcmmts like woc_wcmmts label "Comments".
define shared variable undomain      as logical no-undo.
define shared variable undomainretry as logical no-undo.

define variable l_undocim as logical no-undo.

define shared frame a.
define shared frame b.

/* DISPLAY SELECTION FORM */
form
   dsr_site        colon 25
   dsr_req_nbr     colon 55
   dsr_part        colon 25
   pt_desc1        at 47    no-label
   pt_desc2        at 47    no-label
   dsr_ord_date    colon 25
   dsr_so_job      colon 55
   dsr_due_date    colon 25
   dsr_loc         colon 55
   dsr_qty_req     colon 25
   pt_um                    no-label
   dsrcmmts        colon 55
   dsr_status      colon 25
   dsr_rmks        colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   dsd_shipsite   colon 25
   dsd_qty_conf   colon 55
   dsd_qty_ord    colon 25
   dsd_qty_rcvd   colon 55
   dsd_trans_id   colon 25
   dsd_qty_ship   colon 55
   dsd_shipdate   colon 25
   dsd_nbr        colon 55
   dsd_due_date   colon 25
   dsd_git_site   colon 55
   dsdcmmts       colon 25
   dsd_project    colon 55
   dsd_rmks       colon 25
with frame b width 80 side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

l_undocim = no.

do transaction with frame a:

   prompt-for dsr_site dsr_req_nbr
   editing:
      if frame-field = "dsr_site" then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i dsr_mstr dsr_site dsr_site
            dsr_site dsr_site dsr_mstr}
      end.
      else if frame-field = "dsr_req_nbr" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i dsr_mstr dsr_req_nbr dsr_req_nbr dsr_req_nbr
            dsr_req_nbr dsr_req_nbr}
      end.
      else do:
         readkey.
         apply lastkey.
      end.

      if recno <> ? then do:
         find pt_mstr where pt_part = dsr_part no-lock no-error.
         if available pt_mstr then
            display pt_desc1
               pt_desc2
               pt_um.
         else
            display " " @ pt_desc1
               " " @ pt_desc2
               " " @ pt_um.

         if dsr_cmtindx = 0 then
            dsrcmmts = no.
         else
             dsrcmmts = yes.

         display
            dsr_site
            dsr_req_nbr
            dsr_part
            dsr_qty_req
            dsr_ord_date
            dsr_due_date
            dsr_status
            dsr_so_job
            dsr_loc
            dsr_rmks
            dsrcmmts
         with frame a.

         find first dsd_det no-lock where
            dsd_req_nbr = dsr_req_nbr
            and dsd_site = dsr_site no-error.
         if available dsd_det then do:

            if dsd_cmtindx = 0 then
               dsdcmmts = no.
            else
               dsdcmmts = yes.

            display
               dsd_shipsite
               dsd_qty_ord
               dsd_trans_id
               dsd_shipdate
               dsd_due_date
               dsdcmmts
               dsd_rmks
               dsd_qty_conf
               dsd_qty_rcvd
               dsd_qty_ship
               dsd_nbr
               dsd_git_site
               dsd_project
            with frame b.
         end.
         else clear frame b.
      end.
   end.

   find si_mstr no-lock where si_site = input dsr_site no-error.
   if available si_mstr then
      if si_db <> global_db then do:
         /* SITE IS NOT ASSIGNED TO THIS DATABASE */
         {pxmsg.i &MSGNUM = 5421 &ERRORLEVEL = 3}
         next-prompt dsr_site with frame a.
         undo, retry.
      end.
end. /* transaction */

/* CHECK SITE SECURITY */
if available si_mstr then do:
   {gprun.i ""gpsiver.p""
      "(input si_site, input recid(si_mstr), output return_int)"}
end.
else do:
   {gprun.i ""gpsiver.p""
      "(input (input dsr_site), input ?, output return_int)"}
end.
if return_int = 0 then do:
   /*USER DOES NOT HAVE ACCESS TO THIS SITE */
   {pxmsg.i &MSGNUM = 725 &ERRORLEVEL = 3}
   next-prompt dsr_site with frame a.
   undo, retry.
end.

if batchrun and
   not can-find(first si_mstr where si_site = input dsr_site) or
   can-find(first si_mstr where si_site = input dsr_site
   and si_db   <> global_db)
then
   l_undocim = yes.

reqnbr_loop:
do transaction:

   /* ADD/MOD/DELETE */
   find dsr_mstr use-index dsr_req_nbr using dsr_site
      and dsr_req_nbr no-error.
   if available dsr_mstr then
      req_nbr = dsr_req_nbr.
   else do:
      if input dsr_req_nbr > "" then
         req_nbr = input dsr_req_nbr.
      else do:
         find first drp_ctrl no-lock no-error.
         if available drp_ctrl then do:
            if not drp_auto_req then do:
               assign
                  l_undocim     = yes
                  undomainretry = yes.
               /* BLANK NOT ALLOWED */
               {pxmsg.i &MSGNUM = 40 &ERRORLEVEL = 3}
               next-prompt dsr_req_nbr with frame a.
               leave reqnbr_loop.
            end.
            {mfnctrl.i drp_ctrl drp_req_nbr dsr_mstr
               dsr_req_nbr req_nbr}
         end.
      end.

      if req_nbr = "" then
         undo, retry.
      display
         req_nbr @ dsr_req_nbr
      with frame a.
   end.
end. /* transaction */

if batchrun and l_undocim = yes then
   undomain = yes.
else
   undomain = no.
