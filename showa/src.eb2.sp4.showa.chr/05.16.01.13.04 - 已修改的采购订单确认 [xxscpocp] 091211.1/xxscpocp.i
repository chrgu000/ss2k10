/* poporp.i - PURCHASE ORDER REPORT INCLUDE FILE                              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16.4.1 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0     LAST MODIFIED: 04/18/90    BY: pml                       */
/* REVISION: 6.0     LAST MODIFIED: 08/17/90    BY: SVG *D058*                */
/* REVISION: 6.0     LAST MODIFIED: 10/31/90    BY: pml *D157*                */
/* REVISION: 6.0     LAST MODIFIED: 01/02/91    BY: RAM *D282*                */
/* REVISION: 6.0     LAST MODIFIED: 03/19/91    BY: bjb *D461*                */
/* REVISION: 6.0     LAST MODIFIED: 04/17/91    BY: bjb *D515*                */
/* REVISION: 7.0     LAST MODIFIED: 03/18/92    BY: TMD *F261*                */
/* REVISION: 7.0     LAST MODIFIED: 09/17/92    BY: WUG *G159*                */
/* REVISION: 7.3     LAST MODIFIED: 02/18/93    BY: tjs *G704*                */
/* REVISION: 7.3     LAST MODIFIED: 04/30/93    BY: WUG *GA61*                */
/* REVISION: 7.3     LAST MODIFIED: 10/13/94    BY: dpm *FS36*                */
/* REVISION: 7.3     LAST MODIFIED: 03/10/95    BY: dxk *F0MM*                */
/* REVISION: 7.3     LAST MODIFIED: 09/14/95    BY: dxk *F0V5*                */
/* REVISION: 8.5     LAST MODIFIED: 09/28/95    BY: taf *J053*                */
/* REVISION: 8.5     LAST MODIFIED: 02/16/96    BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5     LAST MODIFIED: 04/08/96    BY: jzw *G1LD*                */
/* REVISION: 8.5     LAST MODIFIED: 07/18/96    BY: taf *J0ZS*                */
/* REVISION: 8.6     LAST MODIFIED: 11/21/96    BY: *K022* Tejas Modi         */
/* REVISION: 8.6     LAST MODIFIED: 04/24/97    BY: *J1PF* Aruna Patil        */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 06/02/98    BY: *L020* Charles Yen        */
/* REVISION: 8.6E    LAST MODIFIED: 07/28/98    BY: *J2T7* Niranjan R.        */
/* REVISION: 8.6E    LAST MODIFIED: 12/23/99    BY: *L0N3* Sandeep Rao        */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 05/02/00    BY: *N09M* Peter Faherty      */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* Mark Brown         */
/* REVISION: 9.1     LAST MODIFIED: 09/08/00    BY: *M0SD* Abhijeet Thakur    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16     BY: Jean Miller          DATE: 04/08/02  ECO: *P058*  */
/* $Revision: 1.16.4.1 $    BY: Shilpa Athalye       DATE: 07/23/03  ECO: *N2JF*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 091117.1 By: Bill Jiang */
/* SS - 091209.1 By: Lambert Xiang */

find first gl_ctrl no-lock.

/* SS - 091117.1 - B */
DO TRANSACTION ON ERROR UNDO:
/* SS - 091117.1 - E */

for each po_mstr where
       (po_nbr >= nbr) and (po_nbr <= nbr1)
   and (po_vend >= vend) and (po_vend <= vend1)
   and ((po_ord_date >= ord) and  (po_ord_date <= ord1)
   or  (po_ord_date = ? and ord = low_date))
   and ((po_cls_date >= cdate and po_cls_date <= cdate1)
   or  (po_cls_date = ? and cdate = low_date))
   and (po_stat = "" or not open_only)
   and (not po_is_btb or incl_b2b_po)
   and (po_buyer >= buyer and po_buyer <= buyer1)
   and  (po_curr = base_rpt
   or base_rpt = "")
   and  (po_blanket >= blanket and po_blanket <= blanket1)
   and po_type <> "B" 
   no-lock
   ,
   each pod_det where pod_nbr = po_nbr
   and not pod_sched
   and ((pod_due_date >= due and pod_due_date <= due1)
   or  (pod_due_date = ? and due = low_date))
   and ((pod_per_date >= perform and pod_per_date <= perform1)
   or  (pod_per_date = ? and perform = low_date))
   and (pod_site >= site and pod_site <= site1)
   and (pod_req_nbr  >= req   and pod_req_nbr <= req1)
   and ((pod_status <> "c" and pod_status <> "x") or open_only = no)
   /* SS - 091117.1 - B
   no-lock
   SS - 091117.1 - E */
   /* SS - 091117.1 - B */
   AND (pod_user1 = "03" AND pod_status <> "X")
   EXCLUSIVE-LOCK
   /* SS - 091117.1 - E */
   break by {&sort1} by {&sort2} by {&sort3}
with frame {&frame1} width 132 no-attr-space no-box:

   /* SS - 091117.1 - B */
   IF pod_user1 = "03" AND pod_status <> "X" THEN DO:
      ASSIGN
         pod_user1 = "11"
         .
      {gprun.i ""xxgetponextqty.p"" "(input pod_nbr, 
                                input pod_part, 
                                input pod_due_date, 
                                output pod__dec01, 
                                output pod__dec02)  
                                "}

   END.
   /* SS - 091117.1 - E */

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame {&frame1}:handle).

   if first-of(po_nbr) then do for ship-to:

      if (oldcurr <> po_curr) or (oldcurr = "") then do:

         if po_curr = gl_base_curr then
            rndmthd = gl_rnd_mthd.
         else do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input po_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
               if c-application-mode <> "WEB" then
                  pause.

               next.
            end.
         end.

         oldcurr = po_curr.

      end.

      if page-size - line-counter < 11 then page.

      old_db = global_db.
      if global_db <> pod_po_db then do:
         {gprun.i ""gpalias3.p"" "(input pod_po_db, output error-flag)"}
      end.
      {gprun.i ""poporpb.p"" "(input po_nbr)"}.
      if global_db <> old_db then do:
         {gprun.i ""gpalias3.p"" "(input old_db, output error-flag)"}
      end.

      put skip(1).

   end.

   if pod_status = "c" or pod_status = "x" then
      qty_open = 0.
   else
      qty_open = pod_qty_ord - pod_qty_rcvd.

   if po_curr = base_curr or po_curr = base_rpt then
      base_cost = pod_pur_cost.
   else

   /* CONVERT FROM FOREIGN TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input po_curr,
        input base_curr,
        input po_ex_rate,
        input po_ex_rate2,
        input pod_pur_cost,
        input false, /* DO NOT ROUND */
        output base_cost,
        output mc-error-number)"}.

   /*  Ext_cost will be calculated in original currency    */

   /* REGARDLESS OF BASE_RPT OPTION, CALCULATE THE EXT_COST */
   /* IN DOCUMENT CURRENCY.                                 */
   if pod_qty_ord < 0 then
      ext_cost = qty_open * pod_pur_cost * (1 - pod_disc_pct / 100).

   else do:
      if ((pod__qad02 = 0 or pod__qad02 = ?) and
          (pod__qad09 = 0 or pod__qad09 = ?))
      then
         ext_cost = qty_open * pod_pur_cost * ( 1 - pod_disc_pct / 100).
      else
         ext_cost = (pod__qad09 + pod__qad02 / 100000) * qty_open.
   end. /* ELSE DO */

   /* ROUND THE EXT_COST PER THE DOCUMENT CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_cost,
        input rndmthd,
        output mc-error-number)"}

   /* CONVERT EXT_COST TO BASE AND STORE IN BASE_TOT */
   if base_rpt = "" and base_curr <> po_curr then do:

      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input po_curr,
           input base_curr,
           input po_ex_rate,
           input po_ex_rate2,
           input ext_cost,
           input yes, /* DO ROUND */
           output base_tot,
           output mc-error-number)"}.
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
      /* ROUND THE EXT_COST PER THE DOCUMENT CURRENCY */

   end.
   else
      base_tot = ext_cost.

   /* IF BASE_RPT = "BASE" THEN STORE BASE_TOT IN EXT_COST ALSO */
   if (po_curr <> base_curr)
      and (base_rpt = "" and not mixed_rpt)
   then
      ext_cost = base_tot.

   accumulate ext_cost(total by po_nbr).
   accumulate ext_cost(total by {&sort1}).
   accumulate base_tot(total by po_nbr).
   accumulate base_tot(total by {&sort1}).

   desc1 = pod_desc.
   desc2 = "".

   if can-find(first pt_mstr where pt_part = pod_part) then do:
      find pt_mstr where pt_part = pod_part no-lock no-wait no-error.
      if (pod_desc = "" or pod_desc = pt_desc1) and available pt_mstr
         then desc1 = pt_desc1 + " " + pt_desc2.
      else desc2 = pt_desc1 + " " + pt_desc2.
   end.

   if page-size - line-counter < 5 then page.

   if base_curr = po_curr
      or (base_rpt = "" and not mixed_rpt)
   then
   display
      pod_line pod_part pod_due_date pod_um pod_qty_ord
      pod__dec01 pod__dec02 base_cost  pod_disc_pct ext_cost 
      pod_wo_lot pod_status.
   else
   display
      pod_line pod_part pod_due_date pod_um pod_qty_ord
      pod__dec01 pod__dec02 pod_pur_cost @ base_cost pod_disc_pct
      ext_cost 
      pod_wo_lot pod_status.

   if desc1 <> "" then put desc1 at 16 format "x(49)".

   if pod_rev <> "" then
   put
      {gplblfmt.i &FUNC=getTermLabel(""REVISION"",16) &CONCAT="': '"}
      at 65 pod_rev
      skip  .

   if can-find(first poc_ctrl where poc_ers_proc = yes) then do:
      put
         getTermLabel("ERS_OPTION",13) + ": " +
            string(pod_ers_opt) format "x(14)" at 14
         getTermLabel("ERS_PRICE_LIST_OPTION",27) + ": " +
            string(pod_pr_lst_tp) format "x(25)" at 30
         skip.
   end. /*ERS PROC IS ON*/

   if desc2 <> ""
   then
      put desc2 at 16 format "x(49)" skip.

   if pod_vpart <> "" then
   put
      {gplblfmt.i &FUNC=getTermLabel(""SUPPLIER_ITEM"",17) &CONCAT="': '"}
      at 16 pod_vpart skip.

   /*  STORE TOTALS, BY CURRENCY, IN WORK FILE.                */
   if base_rpt = "" and mixed_rpt
   then do:
      find first po_wkfl where po_curr = powk_curr no-error.
      /* If a record for this currency doesn't exist, create one. */
      if not available po_wkfl then do:
         create po_wkfl.
         powk_curr = po_curr.
      end.
      /* Accumulate individual currency totals in work file.     */
      powk_for = powk_for + ext_cost.
      if base_curr <> po_curr then
         powk_base = powk_base + base_tot.
      else
         powk_base = powk_for.
   end.

   if last-of(po_nbr) then do:

      if page-size - line-counter < 2 then page.
      underline ext_cost.

      display
         (if base_rpt = "" then
            if mixed_rpt then
               po_curr + " " + getTermLabelRtColon("TOTAL",6)
            else
               getTermLabelRtColon("BASE_TOTAL",11)
         else
            base_rpt + " " + getTermLabelRtColon("TOTAL",6))
         @ pod_part
         accum total by po_nbr ext_cost @ ext_cost.

      down 1.

      if base_curr <> po_curr
         and base_rpt = ""
         and mixed_rpt
      then do:
         if page-size - line-counter < 1 then page.
         display
            getTermLabel("BASE_TOTAL",17) + ":" @ pod_part
            accum total by po_nbr base_tot @ ext_cost.
      end.

      /*  Show base total. If sorted on something other than  */
      if "{&sort1}" <> "po_nbr" and last-of({&sort1}) then do:
         {gpfield.i &field_name='"{&sort1}"'}
         if field_found then do:
            if page-size - line-counter < 2 then page.
            underline ext_cost.
            display
               field_label + " " + getTermLabel("TOTAL",10) + ":" @ pod_part
               accum total by {&sort1} base_tot @ ext_cost.
            page. /* new page on buyer sort*/
         end.
      end.

   end.

   if last(po_nbr) then do:

      if page-size - line-counter < 2 then page.
      underline ext_cost.

      display
         (if base_rpt = "" then
            getTermLabel("BASE_REPORT_TOTAL",17) + ":"
          else
             base_rpt + " " + getTermLabel("REPORT_TOTAL",12) + ":")
          @ pod_part
          accum total base_tot @ ext_cost.

      /*  Display Currency Totals.                                */
      if base_rpt = "" and mixed_rpt
      then
         {gprun.i ""gppopp.p""}.

   end.

   {mfrpchk.i}

end.

/* SS - 091117.1 - B */
   IF update-yn = NO THEN DO:
      UNDO.
   END.
END. /* DO TRANSACTION ON ERROR UNDO: */
/* SS - 091117.1 - E */
