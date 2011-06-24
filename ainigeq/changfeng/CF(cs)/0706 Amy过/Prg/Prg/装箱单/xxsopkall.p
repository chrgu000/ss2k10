/* sopkall.p - SALES ORDER PICK LIST HARD ALLOCATIONS                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */

/* $Revision: 1.16 $                                                         */

/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: MLB **D021**/
/* REVISION: 6.0      LAST MODIFIED: 06/23/90   BY: pml */
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 7.0      LAST MODIFIED: 05/12/92   BY: tjs *F444**/
/* REVISION: 7.2      LAST MODIFIED: 01/31/94   BY: afs *FL83*   (rev only) */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 10/30/98   BY: *M00D* Robert Jensen*/
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.14     BY: Russ Witt       DATE: 06/01/01 ECO: *P00J*          */
/* Revision: 1.15     BY: Russ Witt       DATE: 07/10/01 ECO: *P011*          */
/* $Revision: 1.16 $    BY: Kirti Desai     DATE: 05/22/01 ECO: *N0Y4*          */

/*V8:ConvertMode=Maintenance                                            */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{sotmpdef.i}

define variable tot_lad_qty like sod_qty_all.
define variable qty_to_all like sod_qty_all.
define variable all_this_loc like sod_qty_all.
define shared variable sod_recno as recid.
define variable this_lot like ld_lot.
define variable this_ref like ld_ref initial ? no-undo.
define shared variable alc_sod_nbr like sod_nbr.
define shared variable alc_sod_line like sod_line.
define shared variable tot_qty_all like lad_qty_all.
define variable cust-to-allocate like so_cust extent 3 no-undo.
define variable i as integer no-undo.
define variable ret-flag as integer no-undo.

/*DEFINE TEMP TABLE USED IN RESERVED LOCATION ALLOCATIONS */
define temp-table tt_resv_loc
   field tt_loc             like ld_loc
   field tt_primary_loc     like locc_primary_loc
   index tt_loc is unique primary
   tt_loc.

find first icc_ctrl no-lock.

for first so_mstr fields (so_nbr
                          so_fsm_type
                          so_bill
                          so_ship
                          so_cust)
where so_nbr = alc_sod_nbr no-lock:  end.

find sod_det where sod_nbr = alc_sod_nbr
and sod_line = alc_sod_line no-lock.

this_lot = ?.
tot_lad_qty = 0.

for each lad_det where lad_dataset = "sod_det" and lad_nbr = sod_nbr
and lad_line = string(sod_line) and lad_part = sod_part no-lock:
    tot_lad_qty = tot_lad_qty + lad_qty_all.
    if this_lot = ? and lad_qty_all > 0 then this_lot = lad_lot.
end.

qty_to_all = sod_qty_all * sod_um_conv - tot_lad_qty.

if qty_to_all > 0 then do:
   find pt_mstr where pt_part = sod_part no-lock no-error.

   if pt_sngl_lot = no then this_lot = ?.

   if icc_ascend then do:
      if icc_pk_ord <= 2 then do:
         {sopkall.i &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)" }
      end.
      else do:
         {sopkall.i
         &sort1 = "(if icc_pk_ord = 3 then ld_date else ld_expire)" }
      end.
   end.
   else do:
      if icc_pk_ord <= 2 then do:
         {sopkall.i &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)"
         &sort2 = "descending"}
      end.
      else do:
         {sopkall.i &sort1 = "(if icc_pk_ord = 3 then ld_date else ld_expire)"
         &sort2 = "descending"}
      end.
   end.
end.  /* if qty_to_all > 0 */

/*       I N T E R N A L      P R O C E D U R E S         */

PROCEDURE detail-allocate:
   define buffer lddet for ld_det.

   allocate-proc:
   do:

      /* BYPASS ALLOCATION IS THIS IS A RESTRICTED TRANSACTION   */
      for first isd_det fields (isd_status isd_tr_type isd_bdl_allowed)
      where isd_status = ld_det.ld_status and isd_tr_type = "ISS-SO"
      no-lock:
        if batchrun = no or (batchrun = yes and isd_bdl_allowed = no)
        then leave allocate-proc.
      end.

      /* BYPASS ALLOCATION IS THIS IS RESERVED BY ANOTHER CUSTOMER   */
      run checkReservedLocation.
      if ret-flag = 0 then leave allocate-proc.

      if qty_to_all < ld_qty_oh - ld_qty_all
      then all_this_loc = qty_to_all.
      else all_this_loc = ld_qty_oh - ld_qty_all.

      if pt_mstr.pt_sngl_lot and all_this_loc < qty_to_all
      and this_lot = ?
      then do for lddet:
         for each lddet
         fields (ld_site ld_part ld_lot ld_ref ld_status ld_expire
                 ld_qty_oh ld_qty_all)
         where lddet.ld_site = sod_det.sod_site
         and lddet.ld_part = sod_part
         and lddet.ld_lot = ld_det.ld_lot
         and lddet.ld_ref = ld_det.ld_ref
         and can-find(is_mstr where is_status = lddet.ld_status
         and is_avail = yes)
         and (ld_expire > today or ld_expire = ?)
         and lddet.ld_qty_oh - lddet.ld_qty_all > 0
         no-lock:
            accum (lddet.ld_qty_oh - lddet.ld_qty_all) (total).
         end.

         if (accum total lddet.ld_qty_oh - lddet.ld_qty_all) >= qty_to_all
         then this_lot = ld_det.ld_lot.
      end.   /* do for lddet */

      /*IF ALL AVAILABLE TO ALLOCATE OR NOT SINGLE LOT THEN CREATE LAD_DET*/
      if all_this_loc = qty_to_all or pt_sngl_lot = no
         or (
         ((this_lot  = ? and this_ref <> ? )       or
         (this_lot <> ? and ld_lot   = this_lot)) and
         ((this_ref  = ? and this_lot <> ? )       or
         (this_ref <> ? and ld_ref   = this_ref))
         )

      then do:
         for first lad_det
         fields (lad_dataset lad_nbr lad_line lad_part lad_site
                 lad_loc lad_lot lad_ref lad_qty_all)
         where lad_dataset = "sod_det"
         and lad_nbr = sod_nbr
         and lad_line = string(sod_line)
         and lad_part = sod_part
         and lad_site = sod_site
         and lad_loc = ld_loc
         and lad_lot = ld_lot
         and lad_ref = ld_ref
         exclusive-lock: end.

         /*IF SNGL LOT AND LAD EXISTS THEN ALLOCATE ALL */
         /* TO EXISTING LAD_DET                         */
         if not available lad_det then do:
           create lad_det.
           assign
             lad_dataset = "sod_det"
             lad_nbr = sod_nbr
             lad_line = string(sod_line)
             lad_site = sod_site
             lad_loc = ld_loc
             lad_part = sod_part
             lad_lot = ld_lot
             lad_ref = ld_ref.
         end.  /* if not available lad_det */

         /* CREATE THE TEMP-TABLE TO STORE THE VALUES OF lad_det, ld_det */
         /* AND sod_det BEFORE THEY ARE UPDATED BY NEW VALUES            */

         if execname = "sososl.p"
         then do:
            create t_all_data.
            assign
               t_sod_nbr     = sod_nbr
               t_sod_line    = sod_line
               t_sod_all     = sod_qty_all
               t_sod_pick    = sod_qty_pick
               t_ld_all      = ld_qty_all
               t_lad_dataset = lad_dataset
               t_lad_site    = lad_site
               t_lad_loc     = lad_loc
               t_lad_lot     = lad_lot
               t_lad_ref     = lad_ref
               t_lad_part    = lad_part
               t_lad_all     = lad_qty_all
               t_lad_pick    = lad_qty_pick.
         end. /* IF execname  = "sososl.p" */
         qty_to_all = qty_to_all - all_this_loc.
         ld_qty_all = ld_qty_all + all_this_loc.
         lad_qty_all = lad_qty_all + all_this_loc.
      end.  /* if all_this_loc... */
   end. /* do block */
END PROCEDURE.    /* detail-allocate  */

/* DETERMINE IF LOC TO BE USED IS VALID     */
PROCEDURE checkReservedLocation:

   ret-flag = 2.

   /* bypass checking SSM orders */
   if so_mstr.so_fsm_type = "" then do:
     {gprun.i ""sorlchk.p""
              "(input so_mstr.so_ship,
                input so_mstr.so_bill,
                input so_mstr.so_cust,
                input ld_det.ld_site,
                input ld_det.ld_loc,
                output ret-flag)"}
   end.
END PROCEDURE.  /* checkReservedLocation */
