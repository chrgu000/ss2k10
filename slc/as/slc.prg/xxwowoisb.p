/* wowoisb.p - WORK ORDER ISSUE WITH SERIAL NUMBERS SUBROUTINE                */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3      LAST MODIFIED: 09/23/94   by: emb  *GM78*/
/* REVISION: 7.3      LAST MODIFIED: 11/08/94   by: rwl  *GO34*/
/* REVISION: 7.5      LAST MODIFIED: 11/21/94   by: taf  *J038*/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   by: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   by: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6       BY: Katie Hilbert        DATE: 04/01/01  ECO: *P008*   */
/* Revision: 1.7       BY: Jean Miller          DATE: 05/16/02  ECO: *P05V*   */
/* Revision: 1.9       BY: Rajesh Kini          DATE: 09/05/02  ECO: *N1T7*   */
/* Revision: 1.11      BY: Paul Donnelly (SB)   DATE: 06/28/03  ECO: *Q00N*   */
/* $Revision: 1.12 $   BY: Sukhad Kulkarni     DATE: 02/08/05  ECO: *P37G*   */
/* By: Neil Gao Date: 20070412 ECO: * ss 20070412.1 * */
/*By: Neil Gao 08/03/28 ECO: *SS 20080328* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{mfdeclre.i}

define input parameter wo_recno as recid.
define input parameter wo-op as integer.
define input parameter fill_all as logical.
define input parameter fill_pick as logical.
define output parameter undo-all as logical.

define variable tot_lad_all like lad_qty_all.
define variable ladqtychg like lad_qty_all.
define variable msg-counter as integer no-undo.
define variable rejected like mfc_logical.

define buffer woddet for wod_det.

/* ss 20070412.1 - b */
DEFINE SHARED VARIABLE strLoc LIKE loc_loc.
/* ss 20070412.1 - e */

undo-all = yes.

mainloop:
do:

   find first wo_mstr
      where wo_domain      = global_domain
      and   recid(wo_mstr) = wo_recno
/*SS 20080329 - B*/
/*
   exclusive-lock no-error.
*/
		no-lock no-error.
/*SS 20080329 - E*/
   if available wo_mstr
   then
      recno = recid(wo_mstr).

   if keyfunction(lastkey) = "end-error" then leave mainloop.

   for each sr_wkfl exclusive-lock  where sr_wkfl.sr_domain = global_domain and
    sr_userid = mfguser:
      delete sr_wkfl.
   end.

   for each wod_det  where wod_det.wod_domain = global_domain and (  wod_lot =
   wo_lot
      and (wod_op = wo-op or wo-op = 0)
   )
		AND wod_loc = strLoc
   no-lock:

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wod_part no-lock.
/*SS 20081117 - B*/
/*
			if avail pt_mstr and pt_article <> strloc and strloc <> "" then next.
*/
/*SS 20081117 - E*/
      do for woddet:

         find woddet exclusive-lock where recid(woddet) = recid(wod_det).

         wod_qty_chg = 0.

         if wod_qty_req >= 0
         then
            wod_bo_chg = max(0, wod_qty_req -
                         max(wod_qty_iss,0) - wod_qty_chg).
         else
            wod_bo_chg = min(0, wod_qty_req -
                         min(wod_qty_iss,0) - wod_qty_chg).

         if fill_all or fill_pick then do:

            tot_lad_all = 0.

            for each lad_det  where lad_det.lad_domain = global_domain and
            lad_dataset = "wod_det"
                  and lad_nbr = wod_lot and lad_line = string(wod_op)
                  and lad_part = wod_part:

               {gprun.i ""icedit2.p""
                  "(""ISS-WO"",
                    lad_site,
                    lad_loc,
                    wod_part,
                    lad_lot,
                    lad_ref,
                    (if fill_all then lad_qty_all else 0)
                  + (if fill_pick then lad_qty_pick else 0),
                    pt_um,
                    """",
                    """",
                    output rejected)"}

               if rejected then do on endkey undo, retry:
                  {pxmsg.i
                      &MSGNUM=161
                      &ERRORLEVEL=2
                      &MSGARG1=wod_part
                      &PAUSEAFTER=TRUE}

                  if wod_qty_req >= 0
                  then
                     wod_bo_chg = max(0, wod_qty_req
                                - max(wod_qty_iss,0) - wod_qty_chg).
                  else
                     wod_bo_chg = min(0, wod_qty_req
                                - min(wod_qty_iss,0) - wod_qty_chg).
                  next.
               end.

               ladqtychg = 0.

               if fill_all then
                  assign
                     ladqtychg = lad_qty_all
                     wod_qty_chg = wod_qty_chg + lad_qty_all
                     tot_lad_all = tot_lad_all + lad_qty_all.

               if fill_pick then
                  assign
                     ladqtychg = ladqtychg + lad_qty_pick
                     wod_qty_chg = wod_qty_chg + lad_qty_pick.

               if ladqtychg <> 0 then do:
                  create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                  assign
                     sr_userid = mfguser
                     sr_lineid = string(wod_part,"x(18)") + string(wod_op)
                     sr_site = lad_site
                     sr_loc = lad_loc
                     sr_lotser = lad_lot
                     sr_ref = lad_ref
                     sr_qty = ladqtychg.
                  if recid(sr_wkfl) = -1 then .
               end.

            end.

            if fill_all and tot_lad_all <> wod_qty_all then do:

               find pt_mstr  where pt_mstr.pt_domain = global_domain and
               pt_part = wod_part no-lock no-error.

               if not available pt_mstr or pt_lot_ser = "" then do:

                  find sr_wkfl  where sr_wkfl.sr_domain = global_domain and
                  sr_userid = mfguser
                     and sr_lineid = string(wod_part,"x(18)") + string(wod_op)
                     and sr_site = wod_site
                     and sr_loc = wod_loc and sr_lotser = ""
                     and sr_ref = ""
                  no-error.

                  {gprun.i ""icedit2.p""
                     "(input ""ISS-WO"",
                       input wod_site,
                       input wod_loc,
                       input wod_part,
                       input """",
                       input """",
                       input ((wod_qty_all - tot_lad_all)
                     + if available sr_wkfl then sr_qty else 0),
                       input if available pt_mstr
                       then pt_um else """",
                       """",
                       """",
                       output rejected)"}

                  if rejected then do on endkey undo, retry:
                     {pxmsg.i
                         &MSGNUM=161
                         &ERRORLEVEL=2
                         &MSGARG1=wod_part
                         &PAUSEAFTER=TRUE}

                     if wod_qty_req >= 0 then
                        wod_bo_chg = max(0, wod_qty_req
                                   - max(wod_qty_iss,0) - wod_qty_chg).
                     else
                        wod_bo_chg = min(0, wod_qty_req
                                - min(wod_qty_iss,0) - wod_qty_chg).
                     next.
                  end.

                  if not available sr_wkfl then do:
                     create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                     assign
                        sr_userid = mfguser
                        sr_lineid = string(wod_part,"x(18)") + string(wod_op)
                        sr_site = wod_site
                        sr_loc = wod_loc
                        sr_lotser = ""
                        sr_ref = "".
                     if recid(sr_wkfl) = -1 then .
                  end.

                  assign
                     sr_qty = sr_qty + (wod_qty_all - tot_lad_all)
                     wod_qty_chg = wod_qty_chg + (wod_qty_all - tot_lad_all).

               end.

            end.

         end.

         if wod_qty_req >= 0 then
            wod_bo_chg = max(0, wod_qty_req -
                         max(wod_qty_iss,0) - wod_qty_chg).
         else
            wod_bo_chg = min(0, wod_qty_req -
                         min(wod_qty_iss,0) - wod_qty_chg).

      end. /* DO FOR woddet */

   end. /*FOR EACH wod_det*/

   undo-all = no.

end.
