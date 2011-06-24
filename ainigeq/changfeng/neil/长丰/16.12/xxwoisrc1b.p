/* woisrc1b.p - WORK ORDER ISSUE WITH SERIAL NUMBERS                          */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.2     LAST MODIFIED: 01/18/95    BY: ais *F0F2*                */
/* REVISION: 8.5     LAST MODIFIED: 07/28/95    BY: tjs *J060*                */
/* REVISION: 7.3     LAST MODIFIED: 12/15/95    BY: rvw *G1FL*                */
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8     BY: Veena Lad            DATE: 03/29/01   ECO: *P008*    */
/* $Revision: 1.9 $  BY:Katie Hilbert         DATE: 01/06/03   ECO: *P0LN*    */
/* By: Neil Gao Date: 20061024 ECO: *ss 20061024.1 */
/* By: Neil Gao Date: 20061127 EcO: *ss 20061127.1 */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

define shared variable wo_recno    as recid.
define shared variable wod_recno   as recid.
define shared variable setd-action as integer.

define variable totladqty like lad_qty_chg.
define variable rejected like mfc_logical.

find wo_mstr no-lock where recid(wo_mstr) = wo_recno.

/* ss 20061024.1 - b */
define shared var xlocation like loc_loc .
/*ss 20061127.1 define shared temp-table xxpart 
       field xxpart_1 like pt_part.*/
/* ss 20061024.1 - e */

mainloop:
do:
   /* VERIFY STOCK EXISTS FOR ISSUE */
   for each wod_det no-lock where wod_lot = wo_lot,
       each lad_det no-lock where lad_dataset = "wod_det"
                              and lad_nbr = wod_lot
                              and lad_line = string(wod_op)
                              and lad_part = wod_part
                              and lad_qty_chg <> 0:

      find pt_mstr where pt_part = wod_part no-lock no-error.

      {gprun.i ""icedit2.p""
         "(input ""ISS-WO"",
           input lad_site,
           input lad_loc,
           input lad_part,
           input lad_lot,
           input lad_ref,
           input lad_qty_chg,
           input pt_um,
           input """",
           input """",
           output rejected)"}

      if rejected then do:
         /* Process not completed */
         {pxmsg.i &MSGNUM=5630 &ERRORLEVEL=4}
         /* Unable to issue or receive item */
         {pxmsg.i &MSGNUM=161 &ERRORLEVEL=1 &MSGARG1=lad_part}
         setd-action = 1.
         leave mainloop.
      end.
   end.

   for each wod_det
      where wod_lot = wo_lot
       and (wod_qty_chg <> 0 or
            wod_bo_chg <> max(wod_qty_req - wod_qty_iss,0))
/* ss 20061127   and can-find(first xxpart no-lock where xxpart_1 = wod_part)  */
   no-lock:

      totladqty = 0.

      for each lad_det
         where lad_dataset = "wod_det"
           and lad_nbr = wod_lot
           and lad_line = string(wod_op)
           and lad_part = wod_part
           and lad_qty_chg <> 0
      no-lock:
         totladqty = totladqty + lad_qty_chg.
      end.

      if totladqty <> wod_qty_chg then do:
         wod_recno = recid(wod_det).
         /* Unable to issue or receive item */
         {pxmsg.i &MSGNUM=161 &ERRORLEVEL=3 &MSGARG1=wod_part}
         setd-action = 2.
         leave mainloop.
      end.

   end.

   for each wod_det no-lock where wod_lot = wo_lot,
       each lad_det no-lock where lad_dataset = "wod_det"
       and lad_nbr = wod_lot and lad_line = string(wod_op)
       and lad_part = wod_part
/* 20061127.1 */ and lad_loc = xlocation       :

      create sr_wkfl.
      assign
         sr_userid = mfguser
         sr_lineid = string(wod_part,"x(18)") + string(wod_op)
         sr_site   = lad_site
         sr_loc    = lad_loc
         sr_lotser = lad_lot
         sr_qty    = lad_qty_chg
         sr_ref    = lad_ref.
   end.

end.
