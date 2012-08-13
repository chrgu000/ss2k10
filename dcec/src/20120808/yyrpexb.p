/* rerpexb.p - COMPONENT EXPLOSION FOR REPETITIVE ORDERS                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*J23R*/ /*V8:WebEnabled=No                                             */
/* REVISION: 5.0       LAST EDIT: 04/07/89      MODIFIED BY: EMB      */
/* REVISION: 5.0   LAST MODIFIED: 06/23/89               BY: MLB *B159* */
/* REVISION: 7.0       LAST EDIT: 09/14/92      MODIFIED BY: emb *F892*/
/* REVISION: 7.3       LAST EDIT: 10/12/92      MODIFIED BY: emb *G071*/
/* REVISION: 7.3       LAST EDIT: 11/30/92      MODIFIED BY: emb *G365*/
/* REVISION: 7.3       LAST EDIT: 07/12/94      MODIFIED BY: pxd *GK70*/
/* REVISION: 7.3       LAST EDIT: 07/18/94      MODIFIED BY: pxd *GK81*/
/* REVISION: 7.3       LAST EDIT: 10/14/94      MODIFIED BY: pxd *FR91*/
/* REVISION: 7.3       LAST EDIT: 11/30/94      MODIFIED BY: emb *FU13*/
/* REVISION: 7.3       LAST EDIT: 12/11/95      MODIFIED BY: jym *G1FR*/
/* REVISION: 8.6   LAST MODIFIED: 03/03/98      BY: *J23R* Santhosh Nair  */
/* REVISION: 9.1   LAST MODIFIED: 08/12/00      BY: *N0KP* myb            */

/*GK70*/  {mfdeclre.i}
/*GK70 define shared variable mfguser as character.  */
define shared variable comp like ps_comp.
/*F892*/ define shared variable site like ptp_site.

define variable qty as decimal initial 1 NO-UNDO.
define variable level as integer initial 1 NO-UNDO.
define variable i as integer NO-UNDO.
define variable phantom like mfc_logical NO-UNDO.
define variable effstart as date NO-UNDO.
define variable effend as date NO-UNDO.

define variable maxlevel as integer initial 99 NO-UNDO.
define variable record as integer extent 100 NO-UNDO.
define variable save_qty as decimal extent 100 NO-UNDO.
define variable eff_start like pk_start extent 100 NO-UNDO.
/*FU13* /*FR91*/ define variable tmprnd as decimal initial 10000000000000000.*/
define variable eff_end like pk_end extent 100 NO-UNDO.
/*G365*/ define variable op like ps_op NO-UNDO.

/*J23R* {mfdel.i pk_det "where pk_user = mfguser"} */
/*J23R*/ {mfdel1.i pk_det "where pk_user = mfguser"}
/*J23R*find*/ for first ps_mstr
use-index ps_parcomp where ps_par = comp no-lock /*no-error*/: end.
repeat:

   if not available ps_mstr then do:
      repeat:
     level = level - 1.
     if level < 1 then leave.
     /*J23R*find*/ for first ps_mstr
     where recid(ps_mstr) = record[level] no-lock /*no-error*/: end.
     assign
     comp = ps_par
     qty = save_qty[level].
     if level = 1 then effstart = ?.
     else effstart = eff_start[level - 1].
     if level = 1 then effend = ?.
     else effend = eff_end [level - 1].
     find next ps_mstr use-index ps_parcomp where ps_par = comp
     no-lock no-error.
     if available ps_mstr then leave.
      end.
   end.

   if level < 1 then leave.

   phantom = no.
   /*J23R*find*/ for first pt_mstr
/*J23R*/ fields(pt_bom_code pt_part pt_phantom)
   where pt_part = ps_comp no-lock /*no-error*/: end.
   if available pt_mstr then phantom = pt_phantom.

/*F892*/ /*J23R*find*/ for first ptp_det
/*J23R*/ fields(ptp_bom_code ptp_part ptp_phantom ptp_site)
     no-lock where ptp_part = ps_comp
/*F892*/ and ptp_site = site /*no-error*/: end.
/*F892*/ if available ptp_det then phantom = ptp_phantom.

/*tfq /*G365*/ if level = 1 then op = ps_op. */
/*roger*/ if string(ps_op) <> "0" then op = ps_op.
   if ps_ps_code = "X"
/*F892*/ or (not available pt_mstr and ps_ps_code = "")
/*G365*/ or (phantom and ps_ps_code = "")
   then do:
      assign
      record[level] = recid(ps_mstr)
      save_qty[level] = qty
      eff_start[level] = max(effstart,ps_start).
      if effstart = ? then eff_start[level] = ps_start.
      if ps_start = ? then eff_start[level] = effstart.
      eff_end[level] = min(effend,ps_end).
      if effend = ? then eff_end[level] = ps_end.
      if ps_end = ? then eff_end[level] = effend.
      if level < maxlevel or maxlevel = 0 then do:
     comp = ps_comp.

/*F892*/ if available ptp_det and ptp_bom_code <> ""
/*F892*/    then comp = ptp_bom_code.
/*F892*/ else if available ptp_det and ptp_bom_code = ""
/*F892*/    then comp = ptp_part.
/*F892*/ else if not available ptp_det and available pt_mstr
/*F892*/    and pt_bom_code <> "" then comp = pt_bom_code.
/*F892*/ else if not available ptp_det and available pt_mstr
/*F892*/    and pt_bom_code = "" then comp = pt_part.

     qty = qty * ps_qty_per * (100 / ( 100 - ps_scrp_pct)).

     effstart = max(eff_start[level],ps_start).
     if eff_start[level] = ? then effstart = ps_start.
     if ps_start = ? then effstart = eff_start[level].
     effend = min(eff_end[level],ps_end).
     if eff_end[level] = ? then effend = ps_end.
     if ps_end = ? then effend = eff_end[level].
     level = level + 1.
     /*J23R*find*/ for first ps_mstr
     use-index ps_parcomp where ps_par = comp
     no-lock /*no-error*/: end.
      end.
      else do:
     find next ps_mstr use-index ps_parcomp where ps_par = comp
     no-lock no-error.
      end.
   end.
   else do:
      if available pt_mstr and ps_qty_per <> 0 then do:
     if ps_ps_code = "" then do:

/*GK70      find first pk_det exclusive where pk_user = mfguser
.*           and pk_part = ps_comp
.* /*G365*
.* /*G071*/    and pk_reference = string(ps_op) */
.* /*G365*/    and pk_reference = string(op)
.*            and pk_start = effstart and pk_end = effend no-error.
.*GK70*/

/*GK70*/ /*G1FR* find first pk_det where pk_reference = string(ps_op) */
/*G1FR*/ /*J23R*find*/ for first pk_det
/*J23R*/ fields(pk_end pk_lot pk_part pk_qty pk_reference pk_start pk_user)
     where pk_reference = string(op)
/*GK70*/ and pk_user = mfguser
/*GK70*/ and pk_part = ps_comp
/*GK70*/ and pk_start = max(if effstart = ? then low_date else effstart,
/*GK70*/             if ps_start <> ? then ps_start else low_date)
/*GK70*/ and pk_end = min(if effend = ? then hi_date else effend,
/*GK70*/                 if ps_end <> ? then ps_end else hi_date) /*no-error*/: end.

        if available (pk_det) then do:
           assign

/*FR91     pk_qty = pk_qty + ps_qty_per * qty * (100 / (100 - ps_scrp_pct)).*/
/*FU13*
/*FR91*/       pk_qty = pk_qty + ps_qty_per * tmprnd * qty *
/*FR91*/                100 / (100 - ps_scrp_pct). */
/*FU13*/       pk_qty = pk_qty + ps_qty_per * qty * 100 / (100 - ps_scrp_pct).

           if ps_lt_off < integer(pk_lot)
           then pk_lot = string(ps_lt_off).

        end.
        else do:
           create pk_det.
/*GK70*/       assign pk_user = mfguser
/*GK70*/       pk_part  = ps_comp

/*GK70*/       pk_start = max(if effstart = ? then low_date else effstart,
                  if ps_start <> ? then ps_start else low_date)
/*GK70*/       pk_end = min(if effend = ? then hi_date else effend,
                if ps_end <> ? then ps_end else hi_date)
/*GK70*/ /*G1FR*      pk_reference = string(ps_op) */
/*G1FR*/       pk_reference = string(op)

/*GK81*/       pk_lot = string(ps_lt_off)

/*FR91/*GK81*/       pk_qty = qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).*/
/*FU13* /*FR91*/     pk_qty = tmprnd * qty * ps_qty_per
                * 100 / (100 - ps_scrp_pct). */
/*FU13*/       pk_qty = qty * ps_qty_per * 100 / (100 - ps_scrp_pct).

/*GK70         assign pk_user = mfguser
.*                      pk_part = ps_comp
.* /*G365*
.* /*G071*/         pk_reference = string(ps_op) */
.* /*G365*/         pk_reference = string(op)
.*                      pk_start = max(effstart,ps_start)
.*                       pk_end = min(effend,ps_end)
.*                       pk_lot = string(ps_lt_off)
.*
.* /*FR91             pk_qty = qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).*/
.* /*FU13*
.* /*FR91*/       pk_qty = qty * ps_qty_per *
.* /*FR91*/                tmprnd * 100 / (100 - ps_scrp_pct). */
.* /*FU13*/       pk_qty = qty * ps_qty_per * 100 / (100 - ps_scrp_pct).
.*
.*               if effstart = ? then pk_start = ps_start.
.*               if pk_start = ? then pk_start = effstart.
.*               if effend = ? then pk_end = ps_end.
.*               if ps_end = ? then pk_end = effend.
.*GK70*/

        end.
     end.
      end.
      find next ps_mstr use-index ps_parcomp where ps_par = comp
      no-lock no-error.
   end.
end.

