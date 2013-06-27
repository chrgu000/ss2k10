/* soitallf.p -  SHIPPER WORKBENCH - DETAIL ALLOCATION AND PICK LOGIC    */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* REVISION: 9.0     CREATED: 12/07/99         BY: *M0GG* Kedar Deherkar */
/* REVISION: 9.1    MODIFIED: 08/12/00         BY: *N0KN* myb            */
/* Revision: 1.2.1.3     BY: Katie Hilbert  DATE: 03/11/01 ECO: *N0XB*   */
/* Revision: 1.4         BY: Russ Witt      DATE: 06/01/01 ECO: *P00J*   */
/* Revision: 1.6         BY: Nikita Joshi   DATE: 10/03/01 ECO: *M1FF*   */
/* Revision: 1.7         BY: Veena Lad      DATE: 11/30/01 ECO: *M1Q0*   */
/* Revision: 1.9         BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.10        BY: Shoma Salgaonkar   DATE: 08/02/03 ECO: *P0WL* */
/* Revision: 1.10.1.1    BY: Naseem Torgal      DATE: 04/26/07 ECO: *P5K5* */
/* $Revision: 1.10.1.5 $          BY: Madhabi Raiguru    DATE: 07/23/07 ECO: *P61Y* */
/* REVISION  EB21sp7   BY: MEL ZHAO DATE 13/06/07 ECO SS-20130607.1           */
/*-Revision end----------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                             */

/* DETAIL ALLOCATION AND PICK LOGIC FOR NEW SHIPPER LINE ITEM.           */

/* DETAIL ALLOCATIONS MADE IN SALES ORDER MAINTENANCE AND SALES          */
/* ORDER MANUAL ALLOCATIONS ARE NOT CONSIDERED.                          */

{mfdeclre.i}
{gplabel.i}
/* INPUT VARIABLES */
define input parameter sodnbr        like abs_order   no-undo.
define input parameter sodline       like abs_line    no-undo.
define input parameter part          like pk_part     no-undo.
define input parameter site          like lad_site    no-undo.
define input parameter loc           like lad_loc     no-undo.
define input parameter lot           like lad_lot     no-undo.
define input parameter ref           like lad_ref     no-undo.
define input parameter diff_ship_qty like pk_qty      no-undo.
define input parameter delete_lad    like mfc_logical no-undo.
define input parameter l_sodall      like mfc_logical no-undo.

/* OUTPUT VARIABLES */
define output parameter abnormal_exit as   logical    no-undo.

/* LOCAL VARIABLES */
define variable qty_avail      like in_qty_all   no-undo.
define variable dset           like lad_dataset  no-undo.
define variable up_yn          like mfc_logical  no-undo.
define variable adj_qty_ship   like ld_qty_all   no-undo.
define variable ret-flag       as   integer      no-undo.
define variable l_stat         like ld_status    no-undo.
define variable l_totallqty    like in_qty_all   no-undo.

for first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock:
end. /* FOR FIRST ICC_CTRL */

find first sod_det
    where sod_det.sod_domain = global_domain and  sod_nbr  = sodnbr
   and   sod_line = integer(sodline)
   exclusive-lock no-error.

if available sod_det and sod_type = ""
then do:
   assign
      qty_avail    = 0
      adj_qty_ship = 0.

   if sod_part = part then
      dset = "sod_det".
   else
      dset = "sob_det".

   find first in_mstr
       where in_mstr.in_domain = global_domain and  in_part = sod_part
      and   in_site = sod_site
      exclusive-lock no-error.

   /* BACK OFF in_qty_all FROM sod_qty_all */
   if available in_mstr
   then
      in_qty_all = in_qty_all - sod_qty_all * sod_um_conv.

   find first ld_det
       where ld_det.ld_domain = global_domain and    ld_part = part
      and     ld_lot  = lot
      and     ld_ref  = ref
      and     ld_site = site
      and     ld_loc  = loc
      exclusive-lock no-error.

   /* CHECK TO SEE IF RESERVED LOCATION EXISTS FOR THIS CUSTOMER-- */
   run check-reserved-location.

   if ret-flag = 0 then do:
     {pxmsg.i &MSGNUM=3346 &ERRORLEVEL=3}
     /* THIS LOCATION RESERVED FOR ANOTHER CUSTOMER */
     abnormal_exit = yes.
   end.

   if  ret-flag      = 2
   then do:
      if available ld_det
      then
         l_stat = ld_status.
      else do:
         for first loc_mstr
            fields( loc_domain loc_loc loc_site loc_status)
             where loc_mstr.loc_domain = global_domain and  loc_site = site
            and   loc_loc  = loc
            no-lock:
            l_stat = loc_status.
         end. /* FOR FIRST loc_mstr */

         if not available loc_mstr
         then
            for first si_mstr
               fields( si_domain si_site si_status)
                where si_mstr.si_domain = global_domain and  si_site = site
               no-lock:
               l_stat = si_status.
            end. /* FOR FIRST si_mstr */
      end. /* ELSE DO */

      if  can-find (first is_mstr
                     where is_mstr.is_domain = global_domain and  is_status
                     = l_stat
                    and   is_avail      = false
                    and   is_overissue  = false)
      and diff_ship_qty > 0
      then do:
         /*LOCATION STATUS NOT AVAILABLE, CAN NOT ALLOCATE*/
         {pxmsg.i &MSGNUM=4998 &ERRORLEVEL=3}
         abnormal_exit = yes.
      end. /* IF CAN-FIND (FIRST is_mstr...) */
   end. /* IF ret-flag = 2 */


   if available ld_det
   then do:
      for first isd_det
         fields (isd_domain isd_bdl_allowed isd_status isd_tr_type)
         where isd_det.isd_domain = global_domain
         and   isd_status         = ld_status
         and   isd_tr_type        = "ISS-SO"
      no-lock:
         if (batchrun = no
            and not execname = "rcshwb.p")
         or (batchrun = yes
            and isd_bdl_allowed = no)
         then do:
            /* RESTRICTED TRANSACTION FOR STATUS CODE: */
            {pxmsg.i &MSGNUM=373
                     &ERRORLEVEL=3
                     &MSGARG1=isd_status}
            abnormal_exit = yes.
         end. /* IF batchrun = no... */
      end. /* FOR FIRST isd_det */
      qty_avail = max (ld_qty_oh - ld_qty_all, 0).
   end. /* IF AVAILABLE ld_det */

   /* DO DETAIL ALLOCATION  */
   find lad_det  where lad_det.lad_domain = global_domain and
      lad_dataset = dset             and
      lad_nbr     = sod_nbr          and
      lad_line    = string(sod_line) and
      lad_part    = part             and
      lad_site    = site             and
      lad_loc     = loc              and
      lad_lot     = lot              and
      lad_ref     = ref
      exclusive-lock no-error.

   if available lad_det
   then do:
      if diff_ship_qty <> 0
      then do:
         if qty_avail >= diff_ship_qty
         then do:
            if diff_ship_qty > 0
            then
               assign
                  adj_qty_ship = diff_ship_qty
                  lad_qty_all  = max(lad_qty_all + diff_ship_qty, 0).
         end. /*if qty_avail >= diff_ship_qty */
         else
            assign
               adj_qty_ship = qty_avail
               lad_qty_all  = max(lad_qty_all + qty_avail, 0).
      end. /* IF DIFF_SHIP_QTY <> 0 */
   end. /* IF AVAILABLE LAD_DET */
   else
   do:
      if qty_avail > 0 then
      do:
         create lad_det. lad_det.lad_domain = global_domain.
         assign
            lad_dataset  = dset
            lad_nbr      = sod_nbr
            lad_line     = string(sod_line)
            lad_site     = site
            lad_loc      = loc
            lad_part     = part
            lad_lot      = lot
            lad_ref      = ref
            lad_qty_pick = 0.

         if recid(lad_det) = -1 then .

         if qty_avail >= diff_ship_qty then
            assign
               lad_qty_all = max(diff_ship_qty, 0).
         else do:
            assign
               lad_qty_all = max(qty_avail, 0).

            /* SHIP QTY IS GREATER THAN QTY AVAILABLE ALLOCATE */
            {pxmsg.i &MSGNUM=5853 &ERRORLEVEL=2}
            up_yn = no.

            {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=up_yn}

            /* CONFIRM UPDATE */
            if not up_yn then do:
               abnormal_exit = yes.
               return.
            end. /* IF NOT UP_YN */
         end. /* IF QTY_AVAIL < DIFF_SHIP_QTY */

         adj_qty_ship = lad_qty_all.
      end. /* IF QTY_AVAIL > 0 */
      else
      do:
         for first loc_mstr
               fields( loc_domain loc_loc loc_site loc_status)
                where loc_mstr.loc_domain = global_domain and  loc_site = site
                and
               loc_loc  = loc no-lock:
         end. /* FOR FIRST LOC_MSTR */

         if available loc_mstr then do:
            for first is_mstr
                  fields( is_domain is_avail is_overissue is_status)
                   where is_mstr.is_domain = global_domain and  is_status =
                   loc_status no-lock:
            end. /* FOR FIRST IS_MSTR */
            if available is_mstr and is_overissue then do:
               /* QUANTITY AVAILABLE IN SITE LOCATION */
               /* FOR LOT/SERIAL */
               {pxmsg.i &MSGNUM=208 &ERRORLEVEL=1 &MSGARG1="qty_avail"}
            end. /* IF AVALABLE IS_MSTR */
         end. /* IF AVAILABLE LOC_MSTR */

      end. /* IF QTY_AVAIL <= 0 */
   end. /* IF NOT AVAILABLE LAD_DET */

   /* ADJUST LD_DET AND IN_MSTR ALLOCATION */
   if available ld_det and adj_qty_ship > 0
   then
      ld_qty_all = ld_qty_all + adj_qty_ship.
      l_totallqty = 0.
   for each lad_det
       where lad_det.lad_domain = global_domain and  lad_dataset = "sod_det"
      and   lad_nbr     = sod_nbr
      and   lad_line    = string(sod_line):
      l_totallqty = l_totallqty + (lad_qty_all / sod_um_conv).
   end. /* FOR EACH lad_det */

   if sod_sched
   then do:

      /* FOR SCHEDULED ORDERS, sod_qty_all IS UPDATED       */
      /* WITH diff_ship_qty WHEN NO INVENTORY IS AVAILABLE. */
      /* WITH THE GREATER OF l_totallqty / sod_qty_all WHEN */
      /* INVENTORY IS AVAILABLE.                            */

      if l_totallqty = 0
      then do:
         if l_sodall
         then
            sod_qty_all = diff_ship_qty.
         else
            sod_qty_all = sod_qty_all + diff_ship_qty.
      end. /* IF l_totallqty = 0 */
      else do:
         sod_qty_all = if (sod_qty_all > l_totallqty)
                       then
                          sod_qty_all
                       else
                          l_totallqty.
      end. /* IF l_totallqty <> 0 */

   end. /* IF sod_sched */
   else do:

      /* FOR DISCRETE ORDERS, sod_qty_all IS UPDATED                 */
      /* WITH SHIP QTY / sod_qty_ord WHEN NO INVENTORY IS AVAILABLE. */
      /* WITH THE GREATER OF l_totallqty / sod_qty_all WHEN          */
      /* INVENTORY IS AVAILABLE.                                     */

      if  l_totallqty = 0
      and sod_qty_all < sod_qty_ord
      then do:
         if l_sodall
         then
            sod_qty_all = max( diff_ship_qty,0).
         else do:
            if diff_ship_qty > 0
            then
               sod_qty_all = max(min((sod_qty_all + diff_ship_qty),
                         (sod_qty_ord + sod_qty_pick + sod_qty_ship)) , 0).
         end. /* ELSE IF l_sodall*/
      end. /* IF l_totallqty = 0 AND ... */
      else do:
         sod_qty_all = if (sod_qty_all > l_totallqty)
                       then
                          sod_qty_all
                       else
                          l_totallqty.
      end. /* IF l_totalqty <> 0 AND ... */

   end. /* IF NOT sod_sched */

   if  available in_mstr
   and (in_qty_avail - in_qty_all) < (sod_qty_all * sod_um_conv)
   and sod_type = ""
   then do:
      /* QUANTITY AVAILABLE FOR ITEM */
      {pxmsg.i &MSGNUM=237 &ERRORLEVEL=2
         &MSGARG1=" sod_part + "": "" + string(in_qty_avail - in_qty_all) "}
   end. /* IF AVAILABLE in_mstr AND ... */

   if available in_mstr
   then
      in_qty_all = in_qty_all + sod_qty_all * sod_um_conv.

   if sod_type <> ""
   then
      sod_qty_all = max(sod_qty_ord - sod_qty_ship - sod_qty_pick,0).

end. /* IF AVAILABLE SOD_DET */

/* DETERMINE IF LOC TO BE USED IS VALID     */
PROCEDURE check-reserved-location:

   ret-flag = 2.

   for first so_mstr
   fields( so_domain so_bill so_cust so_fsm_type so_nbr so_ship so_site)
    where so_mstr.so_domain = global_domain and  so_nbr = sodnbr
   no-lock:
      if so_fsm_type = "" then do:
        {gprun.i ""sorlchk.p""
                 "(input so_ship,
                   input so_bill,
                   input so_cust,
                   input so_site,
                   input loc,
                   output ret-flag)"}
      end.
   end.  /* for first so_mstr...*/
END PROCEDURE.
