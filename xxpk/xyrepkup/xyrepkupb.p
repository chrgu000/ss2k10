/* repkupb.p - REPETITIVE PICKLIST CALCULATION SUBROUTINE               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: emb  *G071*/
/* REVISION: 7.3      LAST MODIFIED: 01/30/95   BY: qzl  *G0DD*/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb          */


define input parameter site like si_site.
define input parameter wkctr like op_wkctr.
define input parameter comp like ps_comp.
define input parameter issue1 like wo_rel_date.
define input parameter qtyneed like wod_qty_chg.
/*G0DD*/ define input parameter wolot like wo_lot.
define input-output parameter qtyavail like wod_qty_chg.

define shared variable netgr like mfc_logical.

define variable wc_qoh like ld_qty_oh.
define variable temp_nbr like lad_nbr no-undo.
define variable total_alloc like lad_qty_all no-undo.

/*G0DD*/  define shared variable reldate like wo_rel_date.
/*G0DD*/  define shared variable reldate1 like wo_rel_date.

/* DISPLAY TITLE */
{mfdeclre.i}

   /* CALCULATE COMPONENT REQUIREMENTS FOR THIS W/C */
   for each wod_det no-lock where wod_part = comp
/*G0DD*/ and wod_lot = wolot
   and wod_qty_req > wod_qty_iss
   and wod_iss_date <= issue1,

/*G071*
   last wr_route no-lock where wr_lot = wod_lot,
   first wc_mstr no-lock where wc_wkctr = wkctr
   and wc_wkctr = wr_wkctr and wc_mch = wr_mch,

   first wo_mstr no-lock where wo_lot = wod_lot
   and wo_due_date <= issue1
   and wo_qty_ord > wo_qty_comp + wo_qty_rjct
   and wo_type = "S"
   and wo_site = site and wo_status <> "C": */

/*G071*/ /* Added section */
   first wo_mstr no-lock where wo_lot = wod_lot
   and wo_due_date <= issue1
   and wo_qty_ord > wo_qty_comp + wo_qty_rjct
   and wo_type = "S"
   and wo_site = site and wo_status <> "C",
   first wr_route no-lock where wr_lot = wod_lot
   and wr_op = wod_op
   and wr_wkctr = wkctr:
/*G071*/ /* End of added section */

/*G0DD*/ find rps_mstr where rps_record = integer(wod_lot) no-lock no-error.
/*G0DD*/ if available rps_mstr and (rps_rel_date < reldate or
/*G0DD*/ rps_rel_date > reldate1) then next.

     accumulate max(wod_qty_req - wod_qty_all - wod_qty_pick - wod_qty_iss,0)
    (total).
   end.
   qtyneed = max((accum total
        (max(wod_qty_req - wod_qty_all - wod_qty_pick - wod_qty_iss,0)))
       - qtyneed,0).

   /* CALCULATE QUANTITY AVAILABLE AT WORK CENTER */
   for each ld_det no-lock where ld_part = comp
   and ld_site = site and ld_loc = wkctr
   and ld_qty_oh > 0
   and ld_qty_oh > ld_qty_all:
      accumulate max(max(ld_qty_oh,0) - max(ld_qty_all,0),0) (total).
   end.
   wc_qoh = accum total (max(max(ld_qty_oh,0) - max(ld_qty_all,0),0)).

     /* CALCULATE UNISSUED PICKLISTS FOR THIS W/C */
     temp_nbr = "".
     total_alloc = 0.
     repeat:
        find first lad_det no-lock where lad_dataset = "rps_det"
        and lad_nbr > temp_nbr no-error.
        if not available lad_det then leave.
        temp_nbr = lad_nbr.

        for each lad_det no-lock where lad_dataset = "rps_det"
        and lad_nbr = temp_nbr
        and lad_line = wkctr
        and lad_part = comp and lad_site = site:
           accumulate lad_qty_all + lad_qty_pick (total).
        end.
        total_alloc = total_alloc + accum total(lad_qty_all + lad_qty_pick).
     end.

     qtyavail = max(wc_qoh - qtyneed + total_alloc,0).
