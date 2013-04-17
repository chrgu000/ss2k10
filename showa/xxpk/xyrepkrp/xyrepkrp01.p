/* repkrp01.p - REPETITIVE PICKLIST PRINT                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13 $                                                           */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3       LAST MODIFIED: 09/06/92   BY: emb *G071*               */
/* REVISION: 7.3       LAST MODIFIED: 11/19/92   BY: jcd *G348*               */
/* Oracle changes (share-locks)       09/12/94   BY: rwl *FR25*               */
/* Revision: 7.3        Last edit: 11/22/94      BY: qzl *GO59*               */
/*                                 01/04/95      BY: srk *G0B8*               */
/* REVISION: 7.5       LAST MODIFIED: 01/03/95   BY: mwd *J034*               */
/* REVISION: 8.5       LAST MODIFIED: 06/19/96   BY: taf *J0VG*               */
/* REVISION: 8.5    LAST MODIFIED: 08/08/96  BY: *G2BR* Julie Milligan        */
/* REVISION: 8.5    LAST MODIFIED: 12/17/96  BY: *H0P6* Murli Shastri         */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 09/01/98   BY: *L08D* A.Shobha           */
/* REVISION: 9.0      LAST MODIFIED: 01/18/00   BY: *K252* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                  */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00 BY: *N0PJ* Dave Caveney         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.13 $    BY: Hualin Zhong   DATE: 06/13/01 ECO: *N0ZF*          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE repkrp01_p_1 "Production Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp01_p_2 "Picklist"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp01_p_3 "Print Allocated"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp01_p_4 " Issued"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp01_p_6 "Reprint Picked"
/* MaxLen: Comment: */

&SCOPED-DEFINE repkrp01_p_7 "Sequence"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define shared variable global_recid as recid.
define variable nbr as character format "x(10)" label {&repkrp01_p_2}.
define variable nbr1 like nbr.
define variable wkctr like op_wkctr.
define variable wkctr1 like wkctr.
define variable part like ps_par.
define variable part1 like ps_par.
define variable comp like ps_comp.
define variable comp1 like ps_comp.
define variable site like lad_site.
define variable site1 like lad_site.
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc1.
define variable issue like wo_rel_date label {&repkrp01_p_1}.
define variable issue1 like wo_rel_date.
define variable alloc like mfc_logical label {&repkrp01_p_3} initial yes.
define variable picked like mfc_logical label {&repkrp01_p_6}.
define variable um like pt_um.
define variable issued as character label {&repkrp01_p_4} initial "(      )".
define variable assy_ord_max like pt_ord_max.
define variable ord_max like pt_ord_max.
define variable qty_all like lad_qty_all.
define variable print_more like mfc_logical.
define variable comp_max like lad_qty_all.
define variable tot_picked like lad_qty_all.
define variable print-loop as integer label {&repkrp01_p_7}.
define variable ord_mult like pt_ord_mult.
define buffer laddet for lad_det.

assign
   site  = global_site
   site1 = global_site.

form
   site                    colon 20
   site1   label {t001.i}  colon 49 skip
   nbr                     colon 20
   nbr1    label {t001.i}  colon 49 skip
   comp                    colon 20
   comp1   label {t001.i}  colon 49 skip
   wkctr                   colon 20
   wkctr1  label {t001.i}  colon 49 skip(1)
   picked                  colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{wbrp01.i}
mainloop:

repeat:

   if nbr1  = hi_char then
      nbr1  = "".
   if comp1 = hi_char then
      comp1 = "".
   if wkctr1 = hi_char then
      wkctr1 = "".
   if site1 = hi_char then
      site1 = "".
   if issue = low_date then
      issue = ?.
   if issue1 = hi_date then
      issue1 = ?.

   global_recid = ?.
   if c-application-mode <> 'WEB' then
   update
      site
      site1
      nbr
      nbr1
      comp
      comp1
      wkctr
      wkctr1
      picked
      with frame a
   editing:
      if frame-field = "nbr" and global_recid <> ? then do:
         find lad_det where recid(lad_det) =
            global_recid exclusive-lock no-error.
         if available lad_det then
            display substring(lad_nbr,9) @ nbr with frame a.
         global_recid = ?.
      end.
      else
      if frame-field = "nbr1" and global_recid <> ? then do:
         find lad_det where recid(lad_det) =
            global_recid exclusive-lock no-error.
         if available lad_det then
            display substring(lad_nbr,9) @ nbr1 with frame a.
         global_recid = ?.
      end.
      readkey.
      apply lastkey.
   end.

   {wbrp06.i &command = update
      &fields = " site site1 nbr nbr1 comp comp1
                  wkctr wkctr1 picked "
      &frm = "a" }

   if c-application-mode <> 'WEB' or
      (c-application-mode = 'WEB' and
      c-web-request begins 'DATA') then do:
      bcdparm = "".
      {mfquoter.i site    }
      {mfquoter.i site1   }
      {mfquoter.i nbr     }
      {mfquoter.i nbr1    }
      {mfquoter.i comp    }
      {mfquoter.i comp1   }
      {mfquoter.i wkctr   }
      {mfquoter.i wkctr1  }
      {mfquoter.i picked  }

      nbr1 = string(nbr1,"x(10)").

      if nbr1  = "" then
         nbr1  = hi_char.
      if comp1 = "" then
         comp1 = hi_char.
      if site1 = "" then
         site1 = hi_char.
      if wkctr1  = "" then
         wkctr1 = hi_char.
      if issue = ? then
         issue = low_date.
      if issue1 = ? then
         issue1 = hi_date.

      if not batchrun then do:
         {gprun.i ""gpsirvr.p"" "(input site,
                                  input site1,
                                  output return_int)"}
         if return_int = 0 then do:
            if c-application-mode = 'WEB' then return.
            next-prompt site with frame a.
            undo mainloop, retry mainloop.
         end.
      end.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead2.i}

   assign
      print_more   = yes
      page_counter = 0.

   if picked then
      for each lad_det exclusive-lock
      where lad_dataset = "rps_det"
        and lad_nbr >= trim(string(site,"x(8)") + string(nbr,"x(10)"))
        and lad_nbr <= trim(string(site1,"x(8)") + string(nbr1,"x(10)"))
                     + "999"
        and substring(lad_nbr,9,10) >= nbr
        and substring(lad_nbr,9,10) <= nbr1
        and lad_line >= wkctr and lad_line <= wkctr1
        and lad_part >= comp and lad_part <= comp1
        and lad_site >= site and lad_site <= site1
        and lad_qty_pick <> 0:
         {mfrpchk.i}
         lad_qty_all = lad_qty_all + lad_qty_pick.
         lad_qty_pick = 0.
      end.

   print-loop = 0.

   /* FIND AND DISPLAY */
   do while print_more = yes with frame b:

      print_more = no.
      if print-loop <> 0 then
         page_counter = page-number.
      print-loop = print-loop + 1.

      for each lad_det exclusive-lock
      where lad_dataset = "rps_det"
        and lad_nbr >= trim(string(site,"x(8)") + string(nbr,"x(10)"))
        and lad_nbr <= trim(string(site1,"x(8)") + string(nbr1,"x(10)"))
                    + "999"
        and substring(lad_nbr,9,10) >= nbr
        and substring(lad_nbr,9,10) <= nbr1
        and lad_line >= wkctr and lad_line <= wkctr1
        and lad_part >= comp and lad_part <= comp1
        and lad_site >= site and lad_site <= site1
        and lad_qty_all <> 0
        break by lad_dataset by lad_nbr by lad_line
        by lad_user1 by lad_part by lad_loc by lad_lot by lad_ref
        with frame b width 80 no-attr-space down:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         {mfrpchk.i}

         if first-of (lad_user1) then do:

            find wc_mstr no-lock where wc_wkctr = lad_line no-error.

            if page-number <> 1 then
               page_counter = page-number.
            page.

            form with frame c.
            setFrameLabels(frame c:handle).
            display
               substring(lad_nbr,1,8) @ lad_site colon 12
               lad_line @ wc_wkctr colon 40
               wc_desc no-label when (available wc_mstr)
               substring(lad_nbr,9) @ nbr colon 12
               print-loop colon 12
               lad_user1 @ wod_deliver colon 40
            with frame c side-labels width 80 no-attr-space page-top.

            if length(substring(lad_nbr,19)) <> 0 then
               display integer(substring(lad_nbr,19)) @ print-loop
               with frame c.

         end.

         if first-of (lad_part) then do:

            assign desc1      = ""
                   desc2      = ""
                   um         = ""
                   ord_max    = 0
                   qty_all    = 0
                   tot_picked = 0
                   comp_max   = 0.
            if lad_user2 <> "" then comp_max = decimal(lad_user2).

            find pt_mstr no-lock where pt_part = lad_part no-error.
            if available pt_mstr then
               assign
                  ord_max  = pt_ord_max
                  ord_mult = pt_ord_mult
                  desc1    = pt_desc1
                  desc2    = pt_desc2
                  um       = pt_um.

            for first ptp_det
            fields(ptp_ord_max
                   ptp_ord_mult
                   ptp_part
                   ptp_site) no-lock
            where ptp_part = lad_part
                  and right-trim(ptp_site) = right-trim(substring(lad_nbr,1,8)):
               assign
                  ord_max  = ptp_ord_max
                  ord_mult = ptp_ord_mult.
            end. /* FOR FIRST PTP_DET */

            if (page-size - line-counter < 2
               and (desc1 > "" or desc2 > ""))
               or (page-size - line-counter < 3
               and (desc1 > "" and desc2 > "")) then
               page.

            display lad_part format "x(27)"
            with frame b.

         end.
         else do:

            if desc1 > "" then do:
               display "   " + desc1 @ lad_part with frame b.
               desc1 = "".
            end.
            else if desc2 > "" then do:
               display "   " + desc2 @ lad_part with frame b.
               desc2 = "".
            end.
         end.

         if length(substring(lad_nbr,19)) <> 0 then
            qty_all = lad_qty_all.
         else do:

            qty_all = 0.

            if alloc
               and ((tot_picked < ord_max)
               or (tot_picked < comp_max)
               or (comp_max = 0 and ord_max = 0)) then do:
               if ord_max = 0 or comp_max = 0 then
                  qty_all = lad_qty_all.
               if ord_max <> 0 then
                  qty_all = min(max(ord_max - tot_picked,0),lad_qty_all).
               if comp_max <> 0 then
                  qty_all = min(max(comp_max - tot_picked,0),qty_all).

               if ord_mult <> 0 then do:
                  if qty_all / ord_mult <> truncate(qty_all / ord_mult,0) then
                     qty_all = min(lad_qty_all,
                        truncate(qty_all / ord_mult + .9999999999,0) *
                        ord_mult).
               end.

            end.
         end.

         if qty_all <> 0 then do:

            if (page-size - line-counter < 1) and not last-of (lad_part)
               or (page-size - line-counter < 2) and lad_ref > "" then do:
               page.

               display
                  lad_part + fill(" ",2) +
                  "(" + getTermLabel("CONTINUE",6) + ".)" @ lad_part.
            end.

            display
               lad_loc
               lad_lot
               qty_all
               @ lad_qty_chg
               um issued
            with frame b.

            if lad_ref > "" then do:
               down 1 with frame b.
               display
                  "   " + desc1 @ lad_part
                  getTermLabel("REFERENCE",8) + ": " + lad_ref @ lad_lot
               with frame b.
               desc1 = "".
            end.

            tot_picked = tot_picked + qty_all.

            if alloc and lad_qty_all <> 0 then do:
               assign
                  lad_qty_pick = lad_qty_pick + qty_all
                  lad_qty_all  = lad_qty_all - qty_all.
               if lad_qty_all <> 0 then print_more = yes.
            end.

            if substring(lad_nbr,19) = "" then do for laddet:
               find laddet exclusive-lock
               where lad_dataset = "rps_det"
                 and lad_nbr = trim(string(lad_det.lad_nbr,"x(18)")
                             + string(print-loop,"999"))
                 and lad_line = lad_det.lad_line
                 and lad_part = lad_det.lad_part
                 and lad_site = lad_det.lad_site
                 and lad_loc = lad_det.lad_loc
                 and lad_lot = lad_det.lad_lot
                 and lad_ref = lad_det.lad_ref no-error.

               if not available laddet then
                  create laddet.

               assign
                  lad_dataset  = "rps_det"
                  lad_nbr      = trim(string(lad_det.lad_nbr,"x(18)")
                               + string(print-loop,"999"))
                  lad_line     = lad_det.lad_line
                  lad_part     = lad_det.lad_part
                  lad_site     = lad_det.lad_site
                  lad_loc      = lad_det.lad_loc
                  lad_lot      = lad_det.lad_lot
                  lad_ref      = lad_det.lad_ref
                  lad_qty_pick = qty_all
                  lad_user1    = lad_det.lad_user1
                  lad_user2    = lad_det.lad_user2
                  lad_det.lad_qty_pick = lad_det.lad_qty_pick
                                       - qty_all.

               if recid(laddet) = -1 then .

               if lad_det.lad_qty_pick = 0 and
                   lad_det.lad_qty_all = 0 then
                  delete lad_det.
            end.
         end.

         if last-of (lad_part) then do with frame b:
            if desc1 > "" then do:
               down 1 with frame b.
               display
                  "   " + desc1 @ lad_part with frame b.
               desc1 = "".
            end.
            if desc2 > "" then do:
               down 1 with frame b.
               display
                  "   " + desc2 @ lad_part with frame b.
               desc2 = "".
            end.
            if not last (lad_dataset) then
               down 1.
         end.
         if not last (lad_dataset) then
            down 1.
      end.
   end.

   /* REPORT TRAILER  */
   {mftrl080.i}

end.  /* REPEAT */

{wbrp04.i &frame-spec=a}
