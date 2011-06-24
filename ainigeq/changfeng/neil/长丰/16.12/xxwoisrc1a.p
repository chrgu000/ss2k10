/* woisrc1a.p - WORK ORDER ISSUE WITH SERIAL NUMBERS                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 06/14/90   BY: emb                       */
/* REVISION: 6.0      LAST MODIFIED: 09/24/91   BY: wug *D858*                */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*                */
/* REVISION: 6.0      LAST MODIFIED: 11/29/91   BY: ram *D954*                */
/* REVISION: 7.3      LAST MODIFIED: 12/31/92   BY: pma *G382*                */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*                */
/* REVISION: 7.3      LAST MODIFIED: 03/04/93   BY: ram *G782*                */
/* REVISION: 7.0      LAST MODIFIED: 09/08/94   BY: ais *FQ57*                */
/* REVISION: 7.3      LAST MODIFIED: 09/09/94   BY: qzl *GM01*                */
/* Oracle changes (share-locks)      09/13/94   BY: rwl *GM56*                */
/* REVISION: 7.3      LAST MODIFIED: 10/16/94   BY: qzl *FS45*                */
/* REVISION: 8.5      LAST MODIFIED: 11/22/94   BY: taf *J038*                */
/* REVISION: 7.3      LAST MODIFIED: 12/15/94   BY: qzl *F09T*                */
/* REVISION: 7.3      LAST MODIFIED: 02/03/95   BY: pxd *F0H6*                */
/* REVISION: 7.3      LAST MODIFIED: 02/28/95   BY: ais *F0KS*                */
/* REVISION: 7.2      LAST MODIFIED: 03/07/95   BY: ais *F0LX*                */
/* REVISION: 7.3      LAST MODIFIED: 03/15/95   BY: pxe *F0N7*                */
/* REVISION: 7.3      LAST MODIFIED: 07/03/95   BY: qzl *F0T0*                */
/* REVISION: 7.3      LAST MODIFIED: 05/10/96   BY: rvw *G1V7*                */
/* REVISION: 7.3      LAST MODIFIED: 06/13/96   BY: rvw *G1Y3*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/08/98   BY: *J368* Mugdha Tambe       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 06/06/00   BY: *L0Z1* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *L141* Mark Christian     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13      BY: Veena Lad        DATE: 11/30/00 ECO: *P008*        */
/* Revision: 1.14      BY: Rajiv Ramaiah    DATE: 12/04/01 ECO: *N16T*        */
/* Revision: 1.15      BY: Hareesh V.       DATE: 09/27/02 ECO: *N1VY*        */
/* $Revision: 1.16 $        BY: Vivek Gogte      DATE: 12/03/02 ECO: *N213*        */
/* By: Neil Gao Date: 20061024 ECO: *ss 20061024.1 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

define shared variable wo_recno       as recid.
define shared variable fill_all       like mfc_logical.
define shared variable fill_pick      like mfc_logical.
define shared variable wo-op          like wod_op.
define shared variable backflush_qty  like wod_qty_chg.
define shared variable avgissue       like mfc_logical.
define shared variable eff_date       like glt_effdate.
define shared variable default_cancel like mfc_logical.

{woisrc1c.i}

define buffer woddet for wod_det.
define buffer ptmstr for pt_mstr.

define variable tot_lad_all  like lad_qty_all no-undo.
define variable ladqtychg    like lad_qty_all no-undo.
define variable found_reject like mfc_logical no-undo.
define variable issue_pol    like pt_iss_pol  no-undo.
define variable rejected     like mfc_logical no-undo.

/* ss 20061024.1 - b */
define shared var xlocation like loc_loc .
/* ss 20061024.1 - e */

for first wo_mstr
   fields(wo_lot wo_qty_comp wo_qty_ord)
   where recid(wo_mstr) = wo_recno
   no-lock:
end. /* FOR FIRST wo_mstr */

if quantity-method = phantom_first
then
   avgissue = no.
else
   avgissue = yes.

if not avgissue
then do:
   {gprun.i ""wowoisa1.p"" "(input wo_recno, backflush_qty, eff_date)"}
end. /* IF NOT avgissue */

for each wod_det
   fields(wod_bom_qty wod_bo_chg wod_loc wod_lot wod_op wod_part
          wod_qty_chg wod_qty_iss wod_qty_req wod_serial wod_site)
   where wod_lot = wo_lot
   and   (wod_op = wo-op or wo-op = 0)
   no-lock:

   assign
      found_reject = no
      issue_pol    = no.

   for first pt_mstr
      fields(pt_iss_pol pt_part pt_um)
      where pt_part = wod_part
      no-lock:
      issue_pol = pt_iss_pol.
   end. /* FOR FIRST pt_mstr */

   for first ptp_det
      fields(ptp_iss_pol ptp_part ptp_site)
      where ptp_part = wod_part
      and   ptp_site = wod_site
      no-lock:
      issue_pol = ptp_iss_pol.
   end. /* FOR FIRST ptp_det */

   do for woddet:

      find woddet
         where recid(woddet) = recid(wod_det)
         exclusive-lock no-error.

      /* PHANTOM FIRST WAS HANDLED IN wowoisa1;                     */
      /* NOW DO EVERYTHING ELSE                                     */
      if quantity-method <> phantom_first
      then do:
         if issue_pol = no
         then
            wod_qty_chg = 0.
         else do:

            /* USE STANDARD FORMULA, STANDARD BACKFLUSH                    */

            /* QUANTITY TO ISSUE SHOULD BE CALCULATED BY USING QUANTITY    */
            /* REQUIRED, BACKFLUSH QUANTITY AND WO QUANTITY ORDERED        */
            /* FOR CALCULATING CORRECT QUANTITY TO ISSUE IN CASE           */
            /* OF SUBSTITUTE ITEMS QUANTITY CALCULATION METHOD 'WORK       */
            /* ORDER BILL QTY PER' SHOULD BE USED                          */

            if quantity-method      = comp_rqd_qty
               and backflush-method = std_backflush
            then
               wod_qty_chg = wod_qty_req * backflush_qty / wo_qty_ord.

            /* USE STANDARD FORMULA, NET OF PRIOR ISSUES, RECEIPTS   */
            else if quantity-method = comp_rqd_qty
               and backflush-method = net_backflush
            then
               if wod_qty_req > 0
               then
                  wod_qty_chg = max(wod_qty_req * (wo_qty_comp + backflush_qty)
                                / wo_qty_ord - max(wod_qty_iss,0),0).
               else
                  wod_qty_chg = min(wod_qty_req * (wo_qty_comp + backflush_qty)
                                / wo_qty_ord - min(wod_qty_iss,0),0).

            /* USE wod_bom_qty, STANDARD BACKFLUSH                   */
            else if quantity-method = w_o_bill_qty
               and backflush-method = std_backflush
            then
               wod_qty_chg = wod_bom_qty * backflush_qty.

            /* USE wod_bom_qty, NET OF PRIOR ISSUES, RECEIPTS        */
            else if quantity-method = w_o_bill_qty
               and backflush-method = net_backflush
            then
               if wod_qty_req > 0
               then
                  wod_qty_chg = max(wod_bom_qty * (wo_qty_comp + backflush_qty)
                                - max(wod_qty_iss,0),0).
               else
                  wod_qty_chg = min(wod_bom_qty * (wo_qty_comp + backflush_qty)
                                - min(wod_qty_iss,0),0).
               if wod_qty_chg = ?
               then
                  wod_qty_chg = 0.

               /* TRUNCATE wod_qty_chg TO AVOID ROUNDING ERRORS */
               wod_qty_chg = truncate(wod_qty_chg,7).

         end. /* IF issue_pol = no */

      end. /* IF quantity-method <> phantom_first */

      assign
         wod_bo_chg  = 0
         tot_lad_all = 0
         ladqtychg   = 0.

      if wod_qty_req = 0
      then
         wod_qty_chg = 0.

      for each lad_det
         fields(lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
                lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site)
         where lad_dataset = "wod_det"
         and   lad_nbr     = wod_lot
         and   lad_line    = string(wod_op)
         and   lad_part    = wod_part         
         exclusive-lock:

         lad_qty_chg = 0.

/* ss 20061024.1 */ if lad_loc = xlocation then do:
         
         for first pt_mstr
            fields(pt_iss_pol pt_part pt_um)
            where pt_part = wod_part
            no-lock:

            if (fill_pick and lad_qty_pick <> 0)
            or (fill_all and lad_qty_all <> 0)
            then do:

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

            end. /* IF ( fill_pick AND lad_qty_pick <> 0 ) OR */
         end. /* FOR FIRST pt_mstr */

         if rejected
         then
            do on endkey undo, retry:
               found_reject = yes.
               next.
            end. /* DO ON ENDKEY */

         if fill_pick
         then do:
            assign
               lad_qty_chg = min(lad_qty_pick,wod_qty_chg - ladqtychg)
               ladqtychg   = ladqtychg + lad_qty_chg.
         end. /* IF fill_pick */

         if fill_all
         then do:
            assign
               lad_qty_chg = lad_qty_chg
                             + min(lad_qty_all, wod_qty_chg - ladqtychg)
               ladqtychg   = ladqtychg
                             + min(lad_qty_all, wod_qty_chg - ladqtychg).
         end. /* IF fill_all */
/* ss 20061024.1 */ end.  
      end. /* FOR EACH lad_det */

      if wod_qty_chg <> ladqtychg
      then do:

         for first pt_mstr
            fields(pt_iss_pol pt_part pt_um)
            where pt_part = wod_part
            no-lock:

            find lad_det
               where lad_dataset = "wod_det"
               and   lad_nbr     = wod_lot
               and   lad_line    = string(wod_op)
               and   lad_part    = wod_part
               and   lad_site    = wod_site
               and   lad_loc     = /*ss 1024 wod_loc*/ xlocation 
               and   lad_lot     = wod_serial
               exclusive-lock no-error.

            if not available lad_det
            then do:
               create lad_det.
               assign
                  lad_dataset = "wod_det"
                  lad_nbr     = wod_lot
                  lad_line    = string(wod_op)
                  lad_part    = wod_part
                  lad_site    = wod_site
                  lad_loc     = /*ss 1024 wod_loc*/ xlocation 
                  lad_lot     = wod_serial.
            end. /* IF NOT AVAILABLE lad_det */

            {gprun.i ""icedit2.p""
               "(input ""ISS-WO"",
                 input wod_site,
                 input /*ss 1127 wod_loc*/ xlocation ,
                 input wod_part,
                 input wod_serial,
                 input """",
                 input wod_qty_chg - ladqtychg +
                       if available lad_det
                       then
                          lad_qty_chg
                       else
                          0,
                 input if available pt_mstr
                       then
                          pt_um
                       else
                          """",
                 input """",
                 input """",
                 output rejected)"}

            if rejected
            then
               found_reject = yes.

            assign
               lad_qty_chg = lad_qty_chg + wod_qty_chg - ladqtychg
               ladqtychg   = wod_qty_chg.

         end. /* FOR FIRST pt_mstr */

      end. /* IF wod_qty_chg <> ladqtychg */

      wod_qty_chg = ladqtychg.

      if default_cancel
      then
         wod_bo_chg = 0.
      else if wod_qty_req >= 0
      then
         wod_bo_chg = max(0, wod_qty_req - max(wod_qty_iss, 0) - wod_qty_chg).
      else
         wod_bo_chg = min(0, wod_qty_req - min(wod_qty_iss, 0) - wod_qty_chg).

      if found_reject
      then
         do on endkey undo, retry:
         /* UNABLE TO ISSUE OR RECEIVE FOR ITEM: # */
         {pxmsg.i &MSGNUM=161 &ERRORLEVEL=2 &MSGARG1=wod_part}
      end. /* IF found_reject */

   end. /* DO FOR woddet */

end. /* FOR EACH wod_det */
