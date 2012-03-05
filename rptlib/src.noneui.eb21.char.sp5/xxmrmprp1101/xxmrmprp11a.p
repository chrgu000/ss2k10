/* mrmprp1a.p - MRP SUMMARY REPORT ITEM NUMBER SORT                     */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 1.0    LAST MODIFIED: 05/12/86     BY: PML       */
/* REVISION: 1.0    LAST MODIFIED: 07/17/86     BY: EMB       */
/* REVISION: 1.0    LAST MODIFIED: 09/12/86     BY: EMB *20*  */
/* REVISION: 1.0    LAST MODIFIED: 10/21/86     BY: EMB *36*  */
/* REVISION: 2.0    LAST MODIFIED: 03/06/87     BY: EMB *A39* */
/* REVISION: 2.0    LAST MODIFIED: 08/07/87     BY: EMB *A75* */
/* REVISION: 2.0    LAST MODIFIED: 01/06/88     BY: PML *A125**/
/* REVISION: 4.0    LAST MODIFIED: 01/07/88     BY: EMB *A133**/
/* REVISION: 4.0    LAST MODIFIED: 03/18/88     BY: EMB *A162**/
/* REVISION: 4.0    LAST MODIFIED: 02/05/88     BY: EMB *A173**/
/* REVISION: 4.0    LAST MODIFIED: 12/05/88     BY: EMB *A549**/
/* REVISION: 5.0    LAST MODIFIED: 11/13/89     BY: EMB *B386**/
/* REVISION: 5.0    LAST MODIFIED: 02/20/90     BY: MLB *B557**/
/* REVISION: 5.0    LAST MODIFIED: 03/27/90     BY: EMB *B634**/
/* REVISION: 6.0    LAST MODIFIED: 05/17/90     BY: RAM *D026**/
/* REVISION: 6.0    LAST MODIFIED: 08/10/90     BY: emb *D040**/
/* REVISION: 6.0    LAST MODIFIED: 10/11/90     BY: emb *D089**/
/* REVISION: 6.0    LAST MODIFIED: 05/06/91     BY: WUG *D615**/
/* REVISION: 7.0    LAST MODIFIED: 10/30/91     BY: pma *F003**/
/* REVISION: 7.0    LAST MODIFIED: 03/31/92     BY: pma *F318**/
/* REVISION: 7.0    LAST MODIFIED: 04/28/92     BY: emb *F443**/
/* REVISION: 7.0    LAST MODIFIED: 05/11/92     BY: emb *F475**/
/* REVISION: 7.0    LAST MODIFIED: 07/29/92     BY: emb *F816**/
/* REVISION: 7.0    LAST MODIFIED: 10/25/93     BY: pxd *GG65**/
/* REVISION: 7.0    LAST MODIFIED: 09/01/94     BY: ljm *FQ67**/
/* REVISION: 7.5    LAST MODIFIED: 03/03/95     BY: tjs *J014**/
/* REVISION: 7.3    LAST MODIFIED: 10/24/95     BY: jym *G19T**/
/* REVISION: 7.3    LAST MODIFIED: 05/30/96     BY: rvw *G1WS**/
/* REVISION: 8.6    LAST MODIFIED: 10/22/97     BY: ays *K14V**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KR* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/07/00 BY: *N0RL* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F024*                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* Revision: 1.7.1.4  BY: Russ Witt             DATE: 09/21/01 ECO: *P01H*   */
/* Revision: 1.7.1.5  BY: Robin McCarthy        DATE: 01/31/02 ECO: *P000*   */
/* Revision: 1.7.1.7  BY: Paul Donnelly (SB)    DATE: 06/28/03 ECO: *Q00J*   */
/* Revision: 1.7.1.8  BY: Pankaj Goswami        DATE: 09/13/04 ECO: *Q0CX*   */
/* $Revision: 1.7.1.9 $  BY: Amit Singh  DATE: 12/13/05 ECO: *P4BW*   */

/*-Revision end---------------------------------------------------------------*/
/* SS - 20081029.1 By: Bill Jiang */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*! Prints the mrp summary and optionally runs other programs to print
 *   mrp detail, mrp action messages and substitute parts.
*   Similar to mrmprp1i.p (BOM/Formula sort)                            */

/*V8:ConvertMode=Report                                                 */
   {mfdeclre.i}
   {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* SS - 20081029.1 - B */
{xxmrmprp1101.i}

DEFINE VARIABLE i1 AS INTEGER.
/* SS - 20081029.1 - E */

   /* ********** Begin Translatable Strings Definitions ********* */

   &SCOPED-DEFINE mrmprp1a_p_1 "Use Cost Plans"
   /* MaxLen: Comment: */

   &SCOPED-DEFINE mrmprp1a_p_4 "Day/Week/Month"
   /* MaxLen: Comment: */

   &SCOPED-DEFINE mrmprp1a_p_5 "Per Column"
   /* MaxLen: Comment: */

   /* ********** End Translatable Strings Definitions ********* */

   {wbrp02.i}

define new shared variable fcssite like si_site.
define new shared variable fcspart like pt_part.

define new shared variable frwrd like soc_fcst_fwd.
define new shared variable bck like soc_fcst_bck.
define new shared variable fcsduedate as date.
define new shared variable site2 like si_site.

define new shared workfile fsworkfile no-undo
   field fsdate as date
   field fsqty as decimal.

define shared variable site like si_site.
define shared variable site1 like si_site.
define shared variable part like pt_part.
define shared variable part1 like pt_part.
define shared variable bom like bom_parent.
define shared variable bom1 like bom_parent.
define shared variable buyer like pt_buyer.
define shared variable buyer1 like pt_buyer.
define shared variable prod_line like pt_prod_line.
define shared variable prod_line1 like pt_prod_line.
define shared variable ptgroup like pt_group.
define shared variable ptgroup1 like pt_group.
define shared variable part_type like pt_part_type.
define shared variable part_type1 like pt_part_type.
define shared variable vendor like pt_vend.
define shared variable vendor1 like pt_vend.
define shared variable start like ro_start.
define shared variable ending like ro_end.
define shared variable pm_code like pt_pm_code.
define shared variable dwm as character format "!(1)"
   label {&mrmprp1a_p_4}.
define shared variable idays as integer format ">>>>>9"
   label {&mrmprp1a_p_5}.
define shared variable detail like mfc_logical.
define shared variable action like mfc_logical.
define shared variable subs like mfc_logical.
define shared variable show_base like mfc_logical.
define shared variable item_sort like mfc_logical.

define variable old_start as date.
define variable due_date like mrp_due_date.
define variable interval as integer extent 14
   format "->>>>>>9" no-undo.
define variable sdate as date extent 14 no-undo.
define variable workdays as integer extent 14
   format ">>>>,>>9" no-undo.

define variable pl_recpts as decimal extent 14
   format "->>>>>>9" no-undo.
define variable ords as decimal extent 14
   format "->>>>>>9" no-undo.
define variable qoh as decimal extent 14
   format "->>>>>>9" no-undo.
define variable req like qoh.
define variable forecast like qoh.
define variable recpts like qoh.
define variable gl-site  like site no-undo.


define variable i as integer.
define variable j as integer.
define variable nonwdays as decimal.
define variable overlap as integer.
define variable monthend as integer.
define variable not_part as integer.
define variable num_intervals as integer initial 13.
define variable more like mfc_logical.
define variable total_units as character format "x(50)".
define variable total_std as character format "x(50)".
define variable units as decimal.
define variable week as integer.
define new shared variable date1 as date.
define new shared variable date2 as date.
define new shared variable qty_oh like in_qty_oh.
define variable part2 like pt_part.
define variable is_mrp like mfc_logical.
define shared variable show_zero like mfc_logical.

define variable cost1 as decimal.
define variable tot1 as decimal.
define variable k as integer.
define variable temp_cost like mrp_qty.
define variable chg_date like mrp_due_date.
define variable cost_tot like sct_cst_tot extent 14.
define shared variable plan_yn like mfc_logical
   label {&mrmprp1a_p_1}.

define new shared workfile totfile no-undo
   field tot_seq as integer
   field tot_date like sdate
   field tot_qoh as decimal extent 14 format "->>>>>>9"
   field tot_ords like tot_qoh
   field tot_req like tot_qoh
   field tot_recpts like tot_qoh
   field tot_pl_recpts like tot_qoh
   field cost_qoh as decimal extent 14 format "->>>>>>9"
   field cost_ords like cost_qoh
   field cost_req like cost_qoh
   field cost_recpts like cost_qoh
   field cost_adj like cost_qoh
   field cost_pl_recpts like cost_qoh.

define new shared workfile sumfile no-undo
   field sum_seq as integer
   field sum_tot as decimal
   field sum_cost as decimal.

define variable path like prd_path.

part2 = part.

for first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock: end.
find first soc_ctrl  where soc_ctrl.soc_domain = global_domain no-lock no-error.

if available soc_ctrl then do:

   frwrd = soc_fcst_fwd.
   bck = soc_fcst_bck.
end.

/* INITIALIZE VARIABLES */

old_start = start.
{mfdel.i "totfile"}

for each si_mstr no-lock  where si_mstr.si_domain = global_domain and  si_site
>= site and si_site <= site1,
      each pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
      (pt_part >= part2 and pt_part <= part1):

      if  (pt_prod_line >= prod_line and pt_prod_line <= prod_line1)
           and (pt_group >= ptgroup and pt_group <= ptgroup1)
           and (pt_part_type >= part_type and pt_part_type <= part_type1)
      then do:

      find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
      ptp_part = pt_part
         and ptp_site = si_site no-error.
      if available ptp_det then do:
         if (ptp_buyer < buyer or ptp_buyer > buyer1)
            or (ptp_vend < vendor or ptp_vend > vendor1)
            or (not show_base and ptp_joint_type = "5")
            or (ptp_pm_code <> pm_code and pm_code <> "" )
            or (ptp_bom_code <> "" and
            (ptp_bom_code < bom or ptp_bom_code > bom1))
            or (ptp_bom_code = "" and
            (ptp_part     < bom or ptp_part     > bom1))
            then next.
      end.
      else do:
            if (pt_buyer < buyer or pt_buyer > buyer1)
            or (pt_vend < vendor or pt_vend > vendor1)
            or (not show_base and pt_joint_type = "5")

            or (pt_pm_code <> pm_code and pm_code <> "" )
            or (pt_bom_code <> "" and
            (pt_bom_code < bom or pt_bom_code > bom1))
            or (pt_bom_code = "" and
            (pt_part     < bom or pt_part     > bom1))
            then next.
      end.

      /* SS - 20081029.1 - B */
      /*
      if page-size - line-counter < 12 then page.
      */
      /* SS - 20081029.1 - E */

      {fcsdate.i today fcsduedate week si_site}

      fcsduedate = fcsduedate - 7 * bck.

      start = old_start.
      {mfdel.i "fsworkfile"}
      if can-find (first fcs_sum  where fcs_sum.fcs_domain = global_domain and
      (  fcs_part = pt_part
         and fcs_site = si_site))
         or can-find (first mrp_det  where mrp_det.mrp_domain = global_domain
         and (  mrp_dataset = "fcs_sum"
         and mrp_part = pt_part)) then do:
         fcssite = si_site.
         fcspart = pt_part.
         {gprun.i ""msfsre.p""}
      end.

      if show_zero = yes then is_mrp = yes.
      else do:
         is_mrp = no.
         for each mrp_det  where mrp_det.mrp_domain = global_domain and
         mrp_part = pt_part
               and mrp_site = si_site
               and mrp_due_date <= ending
               and mrp_dataset <> "fcs_sum" no-lock:
            is_mrp = yes.
            leave.
         end.
         if is_mrp = no then do:
            for each fsworkfile where fsworkfile.fsdate <= ending
                  and fsworkfile.fsdate >= fcsduedate:
               is_mrp = yes.
               leave.
            end.
         end.
      end.
      if is_mrp = no then next.

      qty_oh = 0.

      find first in_mstr no-lock
         where in_mstr.in_domain = global_domain
         and   in_part           = pt_part
         and   in_site           = si_site no-error.

      if available in_mstr
      then
         qty_oh = in_qty_oh.
      else
         next.

      form
         pt_part        colon 14
         pt_desc1 no-label format "x(50)"
         pt_buyer       colon 100
         si_site        colon 120
      with frame bbb side-labels width 132 no-attr-space page-top.

      /* SS - 20081029.1 - B */
      /*
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame bbb:handle).
      */
      /* SS - 20081029.1 - E */

      form
         qty_oh         colon 14
         pt_um          colon 36
         pt_timefence   colon 60
         pt_mfg_lead    colon 100
         pt_mrp         colon 120
         pt_ord_pol     colon 14
         pt_ord_min     colon 36
         pt_sfty_time   colon 60
         pt_pm_code     colon 80
         pt_pur_lead    colon 100
         pt_ms          colon 120
         pt_ord_per     colon 14
         pt_ord_max     colon 36
         pt_sfty_stk    colon 60
         pt_insp_rqd    colon 80
         pt_insp_lead   colon 100
         pt_plan_ord    colon 120
         pt_ord_qty     colon 14
         pt_ord_mult    colon 36
         pt_yield_pct   colon 60
         pt_cum_lead    colon 100
         pt_iss_pol     colon 120
         pt_bom_code    colon 100
      with frame bb side-labels width 132 no-attr-space no-box.

      /* SS - 20081029.1 - B */
      /*
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame bb:handle).

      if available ptp_det then do:
         display
            ptp_part @ pt_part
            pt_desc1 + " " + pt_desc2 @ pt_desc1
            ptp_buyer @ pt_buyer
            si_site
         with frame bbb.

         display
            pt_um
            ptp_ord_pol @ pt_ord_pol
            ptp_ord_min @ pt_ord_min
            in_mrp when (available in_mstr) @ pt_mrp
            pt_mrp when (not available in_mstr)
            ptp_ord_per @ pt_ord_per
            ptp_ord_max @ pt_ord_max
            ptp_ms @ pt_ms
            ptp_plan_ord @ pt_plan_ord
            ptp_ord_qty @ pt_ord_qty
            ptp_ord_mult @ pt_ord_mult
            qty_oh
            ptp_iss_pol @ pt_iss_pol
            ptp_sfty_stk @ pt_sfty_stk
            ptp_mfg_lead @ pt_mfg_lead
            ptp_yld_pct @ pt_yield_pct
            ptp_pm_code @ pt_pm_code
            ptp_sfty_tme @ pt_sfty_time
            ptp_pur_lead @ pt_pur_lead
            ptp_ins_lead @ pt_insp_lead
            ptp_ins_rqd @ pt_insp_rqd
            ptp_timefnce @ pt_timefence
            ptp_cum_lead @ pt_cum_lead
            ptp_bom_code @ pt_bom_code
         with frame bb.
      end.
      else do:
         display
            pt_part
            pt_desc1 + " " + pt_desc2 @ pt_desc1
            pt_buyer
            si_site
         with frame bbb.

         display
            pt_um
            pt_ord_pol
            pt_ord_min
            pt_ms
            in_mrp when (available in_mstr) @ pt_mrp
            pt_mrp when (not available in_mstr)
            pt_ord_per
            pt_ord_max
            pt_plan_ord
            pt_ord_qty
            pt_ord_mult
            qty_oh
            pt_iss_pol
            pt_sfty_stk
            pt_mfg_lead
            pt_yield_pct
            pt_pm_code
            pt_sfty_time
            pt_pur_lead
            pt_insp_rqd
            pt_insp_lead
            pt_timefence
            pt_cum_lead
            pt_bom_code
         with frame bb.
      end.
      */
      /* SS - 20081029.1 - E */

      k = 0.

      repeat:
         k = k + 1.

         /* COMPUTE START DATES */
         sdate[1] = low_date.
         {mfcsdate.i}

         /* INITIALIZE VARIABLES */
         assign
            forecast = 0
            req      = 0
            recpts   = 0
            pl_recpts = 0
            qoh      = 0
            ords     = 0.

         more = no.

         if sdate[2] = old_start then do:
            {gpsct05.i &part=pt_part &site=si_site &cost=sct_cst_tot}
            chg_date = hi_date.
         end.
         cost_tot[1] = glxcst.

         do i = 2 to num_intervals + 1:
            if plan_yn then do:
               chg_date = sdate[2].
               if sdate[i] >= chg_date then do:
                  find last cost_cal  where cost_cal.cost_domain =
                  global_domain and  cost_site = si_site
                     and cost_start <= sdate[i]
                     use-index cost_site no-lock no-error.
                  if available cost_cal then do:

                     gl-site = si_site.

                     for first cs_mstr fields( cs_domain cs_type cs_method)
                      where cs_mstr.cs_domain = global_domain and  cs_set =
                      cost_set no-lock:
                        if cs_type = "GL" and cs_method = "STD" then

                           /* IF THIS IS ACTIVE GL COST SET AND NOT AVG */
                           /* METHOD THEN USE LINKED GL COST SITE FROM  */
                           /* in_mstr TO GET COST RECORDS.              */
                           for first in_mstr fields( in_domain in_gl_cost_site
                           in_gl_set)
                            where in_mstr.in_domain = global_domain and
                            in_part = pt_part and in_site = si_site
                           no-lock:
                              if (in_gl_set <> "" and in_gl_set = cost_set)
                              or
                              (in_gl_set = "" and icc_gl_set = cost_set)
                              then
                                 gl-site = in_gl_cost_site.
                           end.
                     end. /* FOR FIRST cs_mstr */

                     find sct_det  where sct_det.sct_domain = global_domain and
                      sct_sim = cost_set
                      and sct_part = pt_part and sct_site = gl-site
                        no-lock no-error.
                     if available sct_det then glxcst = sct_cst_tot.
                     else glxcst = 0.
                  end.
                  find first cost_cal  where cost_cal.cost_domain =
                  global_domain and  cost_site = si_site
                     and cost_start > sdate[i]
                     use-index cost_site no-lock no-error.
                  if available cost_cal then chg_date = cost_start.
                  else chg_date = hi_date.
               end.
            end.
            cost_tot[i] = glxcst.
         end.

         if plan_yn then do:
            if sdate[2] <> old_start then do:
               cost_tot[1] = cost_tot[2].
               glxcst = cost_tot[2].
               chg_date = low_date.
            end.
            else do:
               {gpsct05.i &part=pt_part &site=si_site &cost=sct_cst_tot}
            end.
            chg_date = sdate[2].
         end.

         /* CREATE WORKFILE FOR TOTALS */
         find first totfile where tot_seq = k no-error.
         if not available totfile then do:
            create totfile.
            tot_seq = k.
            do i = 1 to num_intervals + 1:
               tot_date[i] = sdate[i].
            end.
         end.

         /* CALCULATE REQUIREMENTS FOR EACH INTERVAL */
         for each mrp_det  where mrp_det.mrp_domain = global_domain and
         mrp_part = pt_part
               and mrp_site = si_site
               use-index mrp_site_due
               no-lock:

            /* DETERMINE COST TO USE AND DATE TO CHANGE COST TO USE */
            if plan_yn then do:
               if mrp_due_date >= chg_date then do:
                  find last cost_cal  where cost_cal.cost_domain =
                  global_domain and  cost_site = si_site
                     and cost_start <= mrp_due_date
                     use-index cost_site no-lock no-error.
                  if available cost_cal then do:

                     gl-site = si_site.

                     for first cs_mstr fields( cs_domain cs_type cs_method)
                      where cs_mstr.cs_domain = global_domain and  cs_set =
                      cost_set no-lock:
                        if cs_type = "GL" and cs_method = "STD" then

                           /* IF THIS IS ACTIVE GL COST SET AND NOT AVG */
                           /* METHOD THEN USE LINKED GL COST SITE FROM  */
                           /* in_mstr TO GET COST RECORDS.              */
                           for first in_mstr fields( in_domain in_gl_cost_site
                           in_gl_set)
                            where in_mstr.in_domain = global_domain and
                            in_part = pt_part and in_site = si_site
                           no-lock:
                              if (in_gl_set <> "" and in_gl_set = cost_set)
                              or
                              (in_gl_set = "" and icc_gl_set = cost_set)
                              then
                                 gl-site = in_gl_cost_site.
                           end.
                     end. /* FOR FIRST cs_mstr */

                     find sct_det  where sct_det.sct_domain = global_domain and
                      sct_sim = cost_set
                      and sct_part = pt_part and sct_site = gl-site
                        no-lock no-error.
                     if available sct_det then glxcst = sct_cst_tot.
                     else glxcst = 0.
                  end.
                  find first cost_cal  where cost_cal.cost_domain =
                  global_domain and  cost_site = si_site
                     and cost_start > mrp_due_date
                     use-index cost_site no-lock no-error.
                  if available cost_cal then chg_date = cost_start.
                  else chg_date = hi_date.
               end.
            end.

            if mrp_dataset = "fcs_sum" then next.
            due_date = mrp_due_date.
            do i = num_intervals + 1 to 1 by -1:
               if due_date >= sdate[i] then do:
                  if mrp_dataset = "sod_det" then
               do:
                     req[i] = req[i] + mrp_qty.
                     tot_req[i] = tot_req[i] + mrp_qty.
                     cost_req[i] = cost_req[i] + (mrp_qty * glxcst).
                  end.
                  else
                     if mrp_dataset = "wod_det" then
               do:
                     req[i] = req[i] + mrp_qty.
                     tot_req[i] = tot_req[i] + mrp_qty.
                     cost_req[i] = cost_req[i] + (mrp_qty * glxcst).
                  end.
                  else
                     if mrp_dataset = "fcs_sum" then
               do:
                     req[i] = req[i] + mrp_qty.
                     tot_req[i] = tot_req[i] + mrp_qty.
                     cost_req[i] = cost_req[i] + (mrp_qty * glxcst).
                  end.
                  else
                     if mrp_dataset = "pfc_det" then
               do:
                     req[i] = req[i] + mrp_qty.
                     tot_req[i] = tot_req[i] + mrp_qty.
                     cost_req[i] = cost_req[i] + (mrp_qty * glxcst).
                  end.
                  else
                     if mrp_dataset = "wo_scrap" then
               do:
                     req[i] = req[i] + mrp_qty.
                     tot_req[i] = tot_req[i] + mrp_qty.
                     cost_req[i] = cost_req[i] + (mrp_qty * glxcst).
                  end.
                  else

                  if mrp_dataset = "fc_det" then
               do:
                     req[i] = req[i].
                  end.
                  else
                     if mrp_type = "demand" then
               do:
                     req[i] = req[i] + mrp_qty.
                     tot_req[i] = tot_req[i] + mrp_qty.
                     cost_req[i] = cost_req[i] + (mrp_qty * glxcst).
                  end.

                  if mrp_type begins "supply" then do:

                     if mrp_type = "supply" then
                  do:
                        recpts[i] = recpts[i] + mrp_qty.
                        tot_recpts[i] = tot_recpts[i] + mrp_qty.
                        cost_recpts[i] =
                        cost_recpts[i] + (mrp_qty * glxcst).
                     end.
                     else
                     if mrp_type = "supplyf"
                        or mrp_type = "supplyp" then do:

                        assign
                           pl_recpts[i] = pl_recpts[i] + mrp_qty
                           tot_pl_recpts[i] = tot_pl_recpts[i] + mrp_qty
                           cost_pl_recpts[i] =
                           cost_pl_recpts[i] + (mrp_qty * glxcst).

                        do j = num_intervals + 1 to 1 by -1:
                           if mrp_rel_date >= sdate[j] then do:
                              ords[j] = ords[j] + mrp_qty.
                              tot_ords[j] = tot_ords[j] + mrp_qty.
                              cost_ords[j] =

                              cost_ords[j] + (mrp_qty * cost_tot[j]).
                              leave.
                           end.
                        end.
                     end.

                  end.

                  if i = num_intervals + 1 then more = yes.
                  leave.
               end.
            end.
         end.
         for each fsworkfile by fsdate:
            if fsdate>= sdate[num_intervals + 1] then do:
               more = yes.
               leave.
            end.
            do i = num_intervals + 1 to 1 by -1:
               if fsdate >= sdate[i] then do:
                  req[i] = req[i] + fsqty.
                  tot_req[i] = tot_req[i] + fsqty.

                  cost_req[i] = cost_req[i] + (fsqty * cost_tot[i]).

                  leave.
               end.
            end.
         end.

         qoh[1] = qty_oh - req[1] + recpts[1] + pl_recpts[1].
         tot_qoh[1]  = tot_qoh[1] + qoh[1].
         cost_qoh[1] = cost_qoh[1] + (qoh[1] * cost_tot[1]).

         do i = 2 to num_intervals:
            qoh[i] = qoh[i - 1] - req[i] + recpts[i] + pl_recpts[i].
            tot_qoh[i]  = tot_qoh[i] + qoh[i].
            cost_qoh[i] = cost_qoh[i] + (qoh[i] * cost_tot[i]).

            if plan_yn then do:
               cost_adj[i] = cost_adj[i] + cost_qoh[i] - cost_qoh[i - 1]
               + cost_req[i] - cost_recpts[i] - cost_pl_recpts[i].
               /* DELETE FOLLOWING SECTION *
               ./*GG65*/            cost_req[i - 1] =
               ./*GG65*/                         ((cost_req[i - 1] + cost_req[i]) / idays ).
               ./*GG65*/            cost_adj[i - 1]  = cost_ords[i] -
               ./*GG65*/                         (cost_recpts[i - 1] + cost_req[i - 1]).
               ./*GG65*/            cost_ords[i - 1] = cost_ords[i].
               ./*G19T*/            cost_pl_recpts[i - 1] = cost_pl_recpts[i].
               ./*G1WS*/            END OF DELETED SECTION                      */
            end.
         end.

         tot1 = qoh[num_intervals].
         cost1 = qoh[num_intervals] * cost_tot[num_intervals].

         /* SS - 20081029.1 - B */
         /*
         display
            space(16)

            getTermLabel("PAST",8) format "x(8)"
            sdate[2 for 12] skip
            space(16)
            sdate[2] - 1 sdate[3] - 1 sdate[4] - 1 sdate[5] - 1
            sdate[6] - 1 sdate[7] - 1 sdate[8] - 1 sdate[9] - 1
            sdate[10] - 1 sdate[11] - 1 sdate[12] - 1 sdate[13] - 1
            sdate[14] - 1 skip
            space(14)
            "---------- -------- -------- -------- -------- -------- --------"
            "-------- -------- -------- -------- -------- --------" skip
         with frame b no-labels width 132 no-attr-space no-box.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         display
            getTermLabel("GROSS_REQUIREMENTS",13) format "x(13)"
            req[1] format "->>>>>>>>9"
            req[2 for 12] skip
            getTermLabel("SCHED_RECEIPT",13) format "x(13)"
            recpts[1] format "->>>>>>>>9"
            recpts[2 for 12] skip
            getTermLabel("PROJECTED_QUANTITY_ON_HAND",13) format "x(13)"
            qoh[1] format "->>>>>>>>9"
            qoh[2 for 12] skip
            getTermLabel("PLAN_ORDS_DUE",13) format "x(13)"
            pl_recpts[1] format "->>>>>>>>9"
            pl_recpts[2 for 12] skip
            getTermLabel("PLAN_ORDS_REL",13) format "x(13)"
            ords[1] format "->>>>>>>>9"
            ords[2 for 12] skip
         with frame b.
         */

         CREATE ttxxmrmprp1101.

         if available ptp_det then do:
            ASSIGN
               ttxxmrmprp1101_pt_part = ptp_part
               ttxxmrmprp1101_pt_desc1 = pt_desc1
               ttxxmrmprp1101_pt_desc2 = pt_desc2
               ttxxmrmprp1101_pt_buyer = ptp_buyer
               ttxxmrmprp1101_si_site = si_site
            .

            ASSIGN
               ttxxmrmprp1101_pt_um = pt_um
               ttxxmrmprp1101_pt_ord_pol = ptp_ord_pol
               ttxxmrmprp1101_pt_ord_min = ptp_ord_min
               ttxxmrmprp1101_pt_ord_per = ptp_ord_per
               ttxxmrmprp1101_pt_ord_max = ptp_ord_max
               ttxxmrmprp1101_pt_ms = ptp_ms
               ttxxmrmprp1101_pt_plan_ord = ptp_plan_ord
               ttxxmrmprp1101_pt_ord_qty = ptp_ord_qty
               ttxxmrmprp1101_pt_ord_mult = ptp_ord_mult
               ttxxmrmprp1101_qty_oh = qty_oh
               ttxxmrmprp1101_pt_iss_pol = ptp_iss_pol
               ttxxmrmprp1101_pt_sfty_stk = ptp_sfty_stk
               ttxxmrmprp1101_pt_mfg_lead = ptp_mfg_lead
               ttxxmrmprp1101_pt_yield_pct = ptp_yld_pct
               ttxxmrmprp1101_pt_pm_code = ptp_pm_code
               ttxxmrmprp1101_pt_sfty_time = ptp_sfty_tme
               ttxxmrmprp1101_pt_pur_lead = ptp_pur_lead
               ttxxmrmprp1101_pt_insp_lead = ptp_ins_lead
               ttxxmrmprp1101_pt_insp_rqd = ptp_ins_rqd
               ttxxmrmprp1101_pt_timefence = ptp_timefnce
               ttxxmrmprp1101_pt_cum_lead = ptp_cum_lead
               ttxxmrmprp1101_pt_bom_code = ptp_bom_code
            .

            IF AVAILABLE IN_mstr THEN DO:
               ASSIGN
                  ttxxmrmprp1101_pt_mrp = IN_mrp
                  .
            END.
            ELSE DO:
               ASSIGN
                  ttxxmrmprp1101_pt_mrp = pt_mrp
                  .
            END.
         end.
         else do:
            ASSIGN
               ttxxmrmprp1101_pt_part = pt_part
               ttxxmrmprp1101_pt_desc1 = pt_desc1
               ttxxmrmprp1101_pt_desc2 = pt_desc2
               ttxxmrmprp1101_pt_buyer = pt_buyer
               ttxxmrmprp1101_si_site = si_site
            .

            ASSIGN
               ttxxmrmprp1101_pt_um = pt_um
               ttxxmrmprp1101_pt_ord_pol = pt_ord_pol
               ttxxmrmprp1101_pt_ord_min = pt_ord_min
               ttxxmrmprp1101_pt_ms = pt_ms
               ttxxmrmprp1101_pt_ord_per = pt_ord_per
               ttxxmrmprp1101_pt_ord_max = pt_ord_max
               ttxxmrmprp1101_pt_plan_ord = pt_plan_ord
               ttxxmrmprp1101_pt_ord_qty = pt_ord_qty
               ttxxmrmprp1101_pt_ord_mult = pt_ord_mult
               ttxxmrmprp1101_qty_oh = qty_oh
               ttxxmrmprp1101_pt_iss_pol = pt_iss_pol
               ttxxmrmprp1101_pt_sfty_stk = pt_sfty_stk
               ttxxmrmprp1101_pt_mfg_lead = pt_mfg_lead
               ttxxmrmprp1101_pt_yield_pct = pt_yield_pct
               ttxxmrmprp1101_pt_pm_code = pt_pm_code
               ttxxmrmprp1101_pt_sfty_time = pt_sfty_time
               ttxxmrmprp1101_pt_pur_lead = pt_pur_lead
               ttxxmrmprp1101_pt_insp_rqd = pt_insp_rqd
               ttxxmrmprp1101_pt_insp_lead = pt_insp_lead
               ttxxmrmprp1101_pt_timefence = pt_timefence
               ttxxmrmprp1101_pt_cum_lead = pt_cum_lead
               ttxxmrmprp1101_pt_bom_code = pt_bom_code
            .
            IF AVAILABLE IN_mstr THEN DO:
               ASSIGN
                  ttxxmrmprp1101_pt_mrp = IN_mrp
                  .
            END.
            ELSE DO:
               ASSIGN
                  ttxxmrmprp1101_pt_mrp = pt_mrp
                  .
            END.
         end.

         DO i1 = 1 TO 14:
            ASSIGN
               ttxxmrmprp1101_req[i1] = req[i1]
               ttxxmrmprp1101_recpts[i1] = recpts[i1]
               ttxxmrmprp1101_qoh[i1] = qoh[i1]
               ttxxmrmprp1101_pl_recpts[i1] = pl_recpts[i1]
               ttxxmrmprp1101_ords[i1] = ords[i1]
               .
         END.
         /* SS - 20081029.1 - E */

         {mfstrl01.i}
         {mfrpchk.i}
      end. /*repeat*/

      site2 = si_site.
      part = pt_part.
      date1 = sdate[1].
      date2 = sdate[14] - 1.

      find first sumfile where sum_seq = k + 1 no-error.
      if not available sumfile then do:
         create sumfile.
         sum_seq = k + 1.
      end.
      sum_tot = sum_tot + tot1.
      sum_cost = sum_cost + cost1.

      /* SS - 20081029.1 - B */
      /*
      /* MRP DETAIL */
      if detail
         and keyfunction(lastkey) <> "end-error"
      then do:
         {gprun.i ""mrmprp1b.p""}
      end.

      /* ACTION MESSAGES */
      if action
         and keyfunction(lastkey) <> "end-error"
      then do:
         {gprun.i ""mrmprp1c.p""}
      end.

      /* SUBSTITUTE PARTS */
      if subs
         and keyfunction(lastkey) <> "end-error"
      then do:
         {gprun.i ""mrmprp1d.p""}
      end.
      */
      /* SS - 20081029.1 - E */

      {mfrpchk.i}
   end. /* if pt_prod_line */
end. /*for each si_mstr*/

{mfrpexit.i "false"}

start = old_start.

/* RE-COMPUTE START DATES */

/* SS - 20081029.1 - B */
/*
/* PRINT TOTALS & COST TOTALS */
{gprun.i ""mrmprp1e.p""}

hide message no-pause.
hide frame b.
hide frame bb.
*/
/* SS - 20081029.1 - E */
part = part2.
{wbrp04.i}
