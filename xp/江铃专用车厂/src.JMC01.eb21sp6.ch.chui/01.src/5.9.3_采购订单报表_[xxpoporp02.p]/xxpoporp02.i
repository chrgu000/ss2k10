/* poporp02.i - PURCHASE ORDER REPORT BY ITEM                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0      LAST MODIFIED: 04/18/90   BY: PML      */
/* REVISION: 6.0      LAST MODIFIED: 05/24/90   BY: WUG *D002*/
/* REVISION: 6.0      LAST MODIFIED: 08/17/90   BY: SVG *D058*/
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: pma *G068*/
/* REVISION: 7.0      LAST MODIFIED: 09/17/92   BY: WUG *F909*/
/* REVISION: 7.3      LAST MODIFIED: 09/17/92   BY: WUG *G159*/
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: tjs *G704*/
/* REVISION: 8.5      LAST MODIFIED: 10/12/95   BY: taf *J053*/
/* REVISION: 8.5      LAST MODIFIED: 04/08/96   BY: jzw *G1LD**/
/* REVISION: 8.5      LAST MODIFIED: 07/18/96   BY: taf *J0ZS**/
/* REVISION: 8.6      LAST MODIFIED: 11/21/96   BY: *K022* Tejas Modi         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L020* Charles Yen        */
/* REVISION: 8.6E     LAST MODIFIED: 07/28/98   BY: *J2T7* Niranjan R.        */
/* REVISION: 9.0      LAST MODIFIED: 05/07/99   BY: *M0CJ* Santosh Rao        */
/* REVISION: 9.0      LAST MODIFIED: 12/23/99   BY: *L0N3* Sandeep Rao        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/21/00   BY: *N07D* Antony Babu        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/08/00   BY: *M0SD* Abhijeet Thakur    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.15        BY: Jean Miller          DATE: 04/08/02  ECO: *P058* */
/* Revision: 1.17        BY: Paul Donnelly (SB)   DATE: 06/28/03  ECO: *Q00J* */
/* $Revision: 1.18 $     BY: Jean Miller          DATE: 03/02/04  ECO: *Q069* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* GET ORDER RECORDS */
for each pod_det where pod_domain = global_domain and
   (not pod_sched and
    (pod_part >= part and pod_part <= part1) and
   ((pod_due_date >= due) and  (pod_due_date <= due1)
   or  pod_due_date = ? and (due = low_date))
   and (pod_nbr >= nbr) and (pod_nbr <= nbr1)
   and (pod_so_job>= so_job) and (pod_so_job <= so_job1)
   and ((pod_per_date >= perform) and  (pod_per_date <= perform1)
   or  (pod_per_date = ? and perform = low_date))
   and ((pod_status <> "c" and pod_status <> "x") or open_only = no)
   and pod_site >= site and pod_site <= site1)
no-lock,
    each po_mstr  where po_domain = global_domain and
      (  po_nbr = pod_nbr
   and (po_buyer >= buyer) and (po_buyer <= buyer1)
   and (not po_is_btb or incl_b2b_po)
   and ((base_rpt = po_curr) or (base_rpt = ""))
   and po_type <> "B")
no-lock  break by {&sort1}
               by {&sort2}
               by {&sort3}
               by {&sort4}
with frame {&file1}  width 132 no-attr-space no-box:

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame {&file1}:handle).

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

   if pod_status = "c" or pod_status = "x" then
      qty_open = 0.
   else
     qty_open = pod_qty_ord - pod_qty_rcvd.

   base_cost = pod_pur_cost.

   if base_curr <> po_curr
   and base_rpt = ""
   then do:

      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input po_curr,
           input base_curr,
           input po_ex_rate,
           input po_ex_rate2,
           input base_cost,
           input false, /* DO NOT ROUND */
           output base_cost,
           output mc-error-number)"}.
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

   end.

   /* REGARDLESS OF BASE_RPT OPTION, CALCULATE THE EXT_COST IN */
   /* DOCUMENT CURRENCY */
   if pod_qty_ord < 0 then
      ext_cost = qty_open * pod_pur_cost * (1 - pod_disc_pct / 100).
   else do:

      if ((pod__qad02 = 0 or pod__qad02 = ?)  and
          (pod__qad09 = 0 or pod__qad09 = ?))
      then
         ext_cost = qty_open * pod_pur_cost * (1 - pod_disc_pct / 100 ).
      else
         ext_cost = (pod__qad09 + pod__qad02 / 100000) * qty_open.
   end. /* ELSE DO */

   /* ROUND PER THE DOCUMENT CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_cost,
        input rndmthd,
        output mc-error-number)"}

   /* CONVERT TO BASE IF NECESSARY */
   if base_curr <> po_curr
   and base_rpt = ""
   then do:
      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input po_curr,
           input base_curr,
           input po_ex_rate,
           input po_ex_rate2,
           input ext_cost,
           input true, /* DO ROUND */
           output ext_cost,
           output mc-error-number)"}.
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
      /* ROUND PER BASE CURRENCY ROUND METHOD */
   end.

   accumulate (qty_open * pod_um_conv)
              (total by pod_rev).
   accumulate (ext_cost)
              (total by pod_rev).
   accumulate (pod_qty_ord * pod_um_conv)
              (total by pod_rev).

   name = "".
   find ad_mstr where ad_domain = global_domain and ad_addr = po_vend
   no-lock no-error.
   if available ad_mstr then name = ad_name.

   if first-of(pod_rev) then do:

      if not first(pod_part) then put skip(1).

      desc1 = "".
      um = "".

      find pt_mstr where pt_domain = global_domain and pt_part = pod_part
      no-lock no-error.

      if available pt_mstr then desc1 = pt_desc1 + " " + pt_desc2.
      if available pt_mstr then um = pt_um.

      if page-size - line-counter < 5 then page.
      display.

      put
         {gplblfmt.i &FUNC=getTermLabel(""ITEM"",5) &CONCAT="': '"}
         pod_part format "x(18)" space(1)
         desc1 format "x(49)"
         skip
         {gplblfmt.i &FUNC=getTermLabel(""REVISION"",8) &CONCAT="': '"}
         pod_rev.

   end.

   if page-size - line-counter < 3 then page.

   display
      po_vend
      name        format "x(18)"
      pod_nbr
      pod_line
      pod_qty_ord format "->>>>>>>9.9<<<<"
      qty_open    format "->>>>>9.9<<<<"
      pod_um
      base_cost    when v_canrun /* SS - 101029.1  */
      ext_cost     when v_canrun /* SS - 101029.1  */
      pod_due_date
      pod_per_date
      po_buyer
      pod_type.

   {mfrpexit.i}

   if last-of(pod_rev) then do:

      if page-size - line-counter < 2 then page.
      underline pod_qty_ord qty_open ext_cost.

      display
         (if base_rpt = "" then getTermLabel("BASE_ITEM_TOTAL",20)
          else base_rpt + " " + getTermLabelRtColon("ITEM_TOTAL",20) )
         @ name
         accum total by pod_rev (pod_qty_ord * pod_um_conv) @ pod_qty_ord
         accum total by pod_rev (qty_open * pod_um_conv) @ qty_open
         um @ pod_um
         accum total by pod_rev (ext_cost)  when v_canrun  /* SS - 101029.1  */ @ ext_cost
         0 when v_canrun = no @ ext_cost /* SS - 101029.1  */.

   end.

   if last-of({&sort1}) and "{&sort1}" = "po_buyer" then page.

   if last({&sort1}) then do:

      if "{&sort1}" = "po_buyer" then page.
      if page-size - line-counter < 2 then page.

      underline pod_qty_ord qty_open ext_cost.

      display
         (if base_rpt = "" then getTermLabelRtColon("BASE_REPORT_TOTAL",18)
          else base_rpt + " " + getTermLabelRtColon("REPORT_TOTAL",13))
          @ name
         accum total (pod_qty_ord * pod_um_conv) @ pod_qty_ord
         accum total (qty_open * pod_um_conv) @ qty_open
         um @ pod_um
         0 when v_canrun = no @ ext_cost /* SS - 101029.1  */
         accum total (ext_cost)  when v_canrun  /* SS - 101029.1  */ @ ext_cost.
   end.

end. /* pod_det */
