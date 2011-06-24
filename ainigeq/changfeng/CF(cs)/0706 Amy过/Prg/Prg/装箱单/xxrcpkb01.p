/* rcpkb01.p - Release Management Customer Schedules                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.9.1.4 $                                                       */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.0      LAST MODIFIED: 01/29/92          BY: WUG *F110*         */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92          BY: WUG *F312*         */
/* REVISION: 7.0      LAST MODIFIED: 04/15/92          BY: afs *F398*         */
/* REVISION: 7.3      LAST MODIFIED: 12/22/93          BY: WUG *GI32*         */
/* REVISION: 7.3      LAST MODIFIED: 04/21/94          BY: WUG *GJ50*         */
/* REVISION: 7.3      LAST MODIFIED: 01/28/95          BY: ljm *G0D7*         */
/* REVISION: 7.3      LAST MODIFIED: 09/04/95          BY: dzn                */
/* REVISION: 8.6      LAST MODIFIED: 04/28/97          BY: tcc *K0CH*         */
/* REVISION: 8.6      LAST MODIFIED: 09/29/97   BY: *J220* Ajit Deodhar       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/04/00   BY: *N0RB* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.9.1.4 $    BY: Jean Miller          DATE: 03/22/01 ECO: *P008*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* PACKING LIST SUBROUTINE */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rcpkb01_p_2 "Print Features and Options"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcpkb01_p_3 "Print Only Lines to Pick"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcpkb01_p_4 " Shipped"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcpkb01_p_6 "Qty to Ship"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcpkb01_p_7 "Qty Open!Qty to Ship"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable addr as character format "x(38)" extent 6.
define new shared variable alc_sod_nbr like sod_nbr.
define new shared variable alc_sod_line like sod_line.
define new shared variable tot_qty_all like lad_qty_all.

define shared variable due_date      like sod_due_date.
define shared variable due_date1     like sod_due_date.
define shared variable site          like sod_site.
define shared variable site1         like sod_site.
define shared variable all_only      as logical initial yes label {&rcpkb01_p_3}.
define shared variable pages         as integer.
define shared variable old_sod_nbr   like sod_nbr.
define shared variable sod_recno     as recid.
define shared variable so_recno      as recid.
define shared variable first_line    as logical.
define shared variable print_options as logical initial no label {&rcpkb01_p_2}.
define shared variable print_neg like mfc_logical.

define variable qty_open like sod_qty_ord
                         column-label {&rcpkb01_p_7} format "->>>>>9.9<<<<<".
define variable open_qty like sod_qty_ord.
define variable desc1    like pt_desc1. /* format "x(21)". */
define variable location like pt_loc.
define variable i as integer.
define variable qtyshipped as character format "x(8)" initial "(      )"
                           label {&rcpkb01_p_4}.
define variable descount   as integer.
define variable rev        like pt_rev.
define variable det_lines  as integer.
define variable desc2      like desc1.
define variable sob_desc   like pt_desc1.
define variable sob_desc2  like pt_desc2.
define variable sob_um     like pt_um.
define variable sob-qty    like sob_qty_req.
define variable cspart-lbl as character format "x(15)".
define variable qty_all like lad_qty_all format "->>>>>9.9<<<<<"
   label {&rcpkb01_p_6}.
define variable cont_lbl as character format "x(12)".
define variable so_db like si_db.
define variable err-flag as integer.
define variable oktouse like mfc_logical.
define variable over_shipped_left as decimal.
define variable amt_to_reduce as decimal.
define variable prior_cum_net_req as decimal.
define variable cum_net_req as decimal.
define variable net_req as decimal.
define variable sched_netting as logical initial yes.

find so_mstr where recid(so_mstr) = so_recno no-lock.

define new shared frame d.

{sopkf01.i}
/*V8:HiddenDownFrame=d */

for each sod_det no-lock
   where sod_nbr = so_nbr
     and sod_sched
     and sod_site >= site and sod_site <= site1
     and sod_pickdate = ?
by sod_line:

   find first sch_mstr where
              sch_type = 3
          and sch_nbr = sod_nbr
          and sch_line = sod_line
          and sch_rlse_id = sod_curr_rlse_id[3]
   no-lock no-error.

   if not available sch_mstr then next.

   {gprun.i ""rcoqty.p""
      "(input recid(sod_det), input due_date1, input sched_netting,
                          output open_qty)"}
   if open_qty = 0 then next.

   oktouse = no.
   if (sod_qty_all > 0 or
      (not all_only and open_qty - sod_qty_pick > 0))
   then
      oktouse = yes.

   if not oktouse then next.

   if page-size - line-counter < 3 then page.

   /* CREATE HARD ALLOCATIONS IN THE INVENTORY SITE */
   if sod_type = "" then do:
      so_db = global_db.
      /* Switch to the Inventory site */
      {gprun.i ""gpalias2.p"" "(sod_site,output err-flag)" }
      alc_sod_nbr = sod_nbr.
      alc_sod_line = sod_line.
      {gprun.i ""xxsopkall.p""}
      /* Switch back to the sales order database */
      {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
   end.

   /*PRINT HEADER COMMENTS*/
   if old_sod_nbr <> sod_nbr then do:
      {gpcmtprt.i &type=PA &id=so_cmtindx &pos=3}
   end.

   old_sod_nbr = sod_nbr.

   /* PRINT ORDER DETAIL */
   assign
      qty_open = open_qty - sod_qty_pick
      desc1    = sod_desc
      desc2    = ""
      location = ""
      rev      = "".

   find pt_mstr where pt_part = sod_part no-lock no-wait no-error.
   if available pt_mstr then do:
      if desc1 = "" then
         desc1 = pt_desc1.
      desc2 = pt_desc2.
      rev = pt_rev.
   end.

   location = "".

   /*DISPLAY LINES*/
   assign
      cspart-lbl = getTermLabel("CUSTOMER_ITEM",13) + ": "
      cont_lbl   = dynamic-function('getTermLabelFillCentered' in h-label,
                   input "CONTINUE", input 12, input '*').

   display
      sod_line
      sod_part
      sod_type
      sod_site @ lad_loc
      sod_um
   with frame d.

   if desc1 <> "" then do:
      if page-size - line-counter < 1 then do:
         page.
         /*DISPLAY CONTINUED*/
         {sopkd01.i}
         down 1 with frame d.
      end.
      put desc1 at 5.
   end.

   if desc2 <> "" then do:
      if page-size - line-counter < 1 then do:
         page.
         /*DISPLAY CONTINUED*/
         {sopkd01.i}
         down 1 with frame d.
      end.
      put desc2 at 5.
   end.

   if sod_custpart <> "" then do:
      if page-size - line-counter < 1 then do:
         page.
         /*DISPLAY CONTINUED*/
         {sopkd01.i}
         down 1 with frame d.
      end.
      put cspart-lbl at 7 sod_custpart at 23.
   end.

   /* PRINT LINE ITEM COMMENTS */
   {gpcmtprt.i &type=PA &id=sod_cmtindx &pos=5
      &command="~{sopkd01.i~} down 1 with frame d."}

   /* PRINT SCHEDULE COMMENTS */
   {gpcmtprt.i &type=PA &id=sch_cmtindx &pos=5
      &command="~{sopkd01.i~} down 1 with frame d."}

   clear frame d no-pause.

   /* PRINT SCHEDULE DETAIL */
   prior_cum_net_req = max(sch_pcr_qty - sod_cum_qty[1],0).

   if prior_cum_net_req > 0 then do:
      if page-size - line-counter < 1 then do:
         page.
         /*DISPLAY CONTINUED*/
         {sopkd01.i}
         down 1 with frame d.
      end.

      qty_open = prior_cum_net_req.

      display
         qty_open
         sch_pcs_date @ sod_due_date
      with frame d.
      down 1 with frame d.
   end.

   for each schd_det
      where schd_type = sch_type
        and schd_nbr = sch_nbr
        and schd_line = sch_line
        and schd_rlse_id = sch_rlse_id
   no-lock:

      cum_net_req = max(schd_cum_qty - sod_cum_qty[1],0).
      net_req = cum_net_req - prior_cum_net_req.
      prior_cum_net_req = cum_net_req.

      if net_req <> 0 and schd_date >= due_date
         and schd_date <= due_date1
      then do:
         if page-size - line-counter < 1 then do:
            page.
            /*DISPLAY CONTINUED*/
            {sopkd01.i}
            down 1 with frame d.
         end.

         qty_open = net_req.

         display
            qty_open
            schd_date @ sod_due_date
         with frame d.
         down 1 with frame d.

         {gpcmtprt.i &type=PA &id=schd_cmtindx &pos=5
            &command="~{sopkd01.i~} down 1 with frame d."}
      end.

   end.

   /* DISPLAY ALLOCATION DETAIL */
   /* Done in a subroutine because the allocations are in the */
   /* inventory database.                                     */
   tot_qty_all = 0.
   if sod_type = "" then do:
      {gprun.i ""sopke01.p""}
      /* Switch back to the sales order database */
      {gprun.i ""gpalias3.p"" "(so_db,output err-flag)" }
   end.

   put skip(1).
   first_line = no.

   /* UPDATE QTY SALES ORDER QTY PICK AND PRINT STATUS */
   sod_recno = recid(sod_det).
   {gprun.i ""sosopka.p""}

   {mfrpchk.i}

end.
