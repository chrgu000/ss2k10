/* xxmprp1a.p - MRP SUMMARY REPORT ITEM NUMBER SORT                           */
/*V8:ConvertMode=FullGUIReport                                                */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
&SCOPED-DEFINE mrmprp11_p_1 "Include Base Process Orders"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_2 "Per Column"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_3 "Include Zero Requirements"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_4 "Print Action Messages"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_5 "Item Number/BOM Formula"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_6 "Print Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_7 "Print Substitute Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_8 "Day/Week/Month"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_9 "Use Cost Plans"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_10 "Sort by Item or BOM/Formula"
/* MaxLen: Comment: */

   {xxmprp1a.i}
   {gplabel.i} /* EXTERNAL LABEL INCLUDE */
/*    {xxbmwua.i} **/

   /* ********** Begin Translatable Strings Definitions ********* * /

   &SCOPED-DEFINE mrmprp1a_p_1 "Use Cost Plans"
   /* MaxLen: Comment: */

   &SCOPED-DEFINE mrmprp1a_p_4 "Day/Week/Month"
   /* MaxLen: Comment: */

   &SCOPED-DEFINE mrmprp1a_p_5 "Per Column"
   /* MaxLen: Comment: */

   / * ********** End Translatable Strings Definitions ********* */

   {wbrp02.i}
define variable qtybom like ps_mstr.ps_qty_per no-undo.
define variable sdate as date extent 14 no-undo.
define variable idate as date.
define variable monthend as integer.
define variable num_intervals as integer initial 13.
define variable interval as integer extent 14 format "->>>>>>9" no-undo.
define variable i as integer.
define variable j as integer.
define variable vlog as logical.
define variable qtyiss like tr_qty_loc.
define variable qtyrct like tr_qty_loc.
define variable qtyoh  like in_qty_oh.
define variable tmpchar as  character no-undo.
for first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock: end.
find first soc_ctrl where soc_ctrl.soc_domain = global_domain no-lock no-error.

if available soc_ctrl then do:
   frwrd = soc_fcst_fwd.
   bck = soc_fcst_bck.
end.

/* INITIALIZE VARIABLES */

old_start = start.
sdate[1] = low_date.
{mfcsdate.i}
/* {mfdel.i "tmp_ps"} */
empty temp-table tmp_list no-error.
empty temp-table tmp_ps no-error.
empty temp-table tmp_data0 no-error.

/* for each si_mstr no-lock  where si_mstr.si_domain = global_domain and  */
/*          si_site >= site and si_site <= site1,                         */
/*     each pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and  */
/*       (pt_part >= part and pt_part <= part1) and                       */
/*       pt_buyer >= buyer and pt_buyer <= buyer1:                        */
/*                                                                        */
/*       assign qtybom = 1.                                               */
/*       run getComp(input pt_part,input today).                          */
/*                                                                        */
/* end.                                                                   */

 FOR EACH pt_mstr no-lock
    where pt_domain = global_domain
      and pt_part >= part and (pt_part <= part1 or part1 = "")
      and pt_site >= site and (pt_site <= site1 or site1 = "")
      and pt_pm_code = "P"
      and pt_buyer >= buyer and (pt_buyer <= buyer1 or buyer1 = "")
      and pt_prod_line >= prod_line
      and (pt_prod_line <= prod_line1 or prod_line1 = "")
      and pt_group >= ptgroup and (pt_group <= ptgroup1 or ptgroup1 = "")
      and pt_part_type >= part_type
      and (pt_part_type <= part_type1 or part_type1 = "")
      and pt_vend >= vendor and (pt_vend <= vendor1 or vendor1 = ""):
      run getlist(input pt_part,input today).
/*     EACH mrp_det no-lock WHERE mrp_part = pt_part and                    */
/*          mrp_detail = "计划单" and                                       */
/*          mrp_site >= site and mrp_site <= site1 and                      */
/*          mrp_due_date >= start and mrp_due_date <= ending                */
/*          USE-INDEX mrp_part:                                             */
/*                                                                          */
/*     run getComp(input pt_part,input today, input mrp_qty).               */
/*                                                                          */
/*     for each tmp_ps where tps_par = mrp_part:                            */
/*         find first tmp_data0 where t0_part = tps_comp no-error.          */
/*         if not available tmp_data0 then do:                              */
/*            create tmp_data0.                                             */
/*            assign t0_part = tps_comp.                                    */
/*         end.                                                             */
/*         run getIdx(input mrp_due_date,output i).                         */
/*         t0_qty_req[i] = t0_qty_req[i] + mrp_qty * tps_qty.               */
/*     end.                                                                 */
end.

for each tmp_list no-lock break by tl_part:
    if first-of(tl_part) then do:
       run getPar(input tl_part,input today).
    end.
end.


for EACH mrp_det no-lock USE-INDEX mrp_part WHERE
     mrp_detail = "计划单" and
     mrp_site >= site and mrp_site <= site1 and
     mrp_due_date >= start and mrp_due_date <= ending,
     each tmp_ps where tps_par = mrp_part:
     run getIdx(input mrp_due_date,output i).
     find first tmp_data0 exclusive-lock where t0_part = tps_comp no-error.
        if not available tmp_data0 then do:
           create tmp_data0.
           assign t0_part = tps_comp
                  t0_site = mrp_site.
        end.
        t0_qty_req[i] = t0_qty_req[i] + mrp_qty * tps_qty.
end.

/*   for each tmp_list:                                 */
/*       display tmP_list with width 300.               */
/*   end.                                               */
/*   for each tmp_ps:                                   */
/*       display tmp_ps with width 300 .                */
/*   end.                                               */
/*                                                      */
/*   for each tmp_data0:                                */
/*       display tmp_data0 with width 360.              */
/*   end.                                               */

/*   由于会在多个地点出/收货,因此将所有地点收发货数量汇总   */
for each tr_hist fields(tr_part tr_site tr_type tr_qty_loc tr_effdate)
   use-index tr_part_trn no-lock
   where tr_domain = global_domain and
         tr_part >= part and tr_part <= part1 and
         tr_type = "iss-so"
    break by tr_part:
    IF FIRST-OF(TR_PART) THEN DO:
       ASSIGN qtyiss = 0.
    END.
    if (tr_type = "ISS-SO") then assign qtyiss = qtyiss + (-1) * tr_qty_loc.
    if last-of(tr_part) then do:
       find first tmp_data0 exclusive-lock where t0_part = tr_part no-error.
       if available tmp_data0 then do:
          assign t0_iss_so = qtyiss.
       end.
    end.
end.

/*******TS采购收货多少量B1**************/
for each tmp_ps exclusive-lock:
    assign qtyiss = 0.
    for each tr_hist fields(tr_part tr_site tr_type tr_qty_loc tr_effdate)
        use-index tr_part_trn no-lock
            where tr_domain = global_domain and tr_part = tps_par and
        (tr_type = "rct-po" or tr_type = "ISS-PRV"):
        assign qtyiss = qtyiss + tr_qty_loc.
    end.
    assign tps_rctpo = qtyiss.
end.

for each tmp_data0 exclusive-lock:
    assign qtyiss = 0.
    for each tmp_ps no-lock where t0_part = tps_comp:
        assign qtyiss = qtyiss + tps_rctpo.
    end.
    assign t0_rct_po = qtyiss.
end.

/*******TS采购计划收货量B1**************/
for each tmp_ps exclusive-lock,
     each pod_det no-lock where pod_domain = global_domain and
         pod_part = tps_par and
         pod_status <> "C" and pod_status <> "X" and
         (pod_qty_ord - pod_qty_rcvd) > 0 :
            run getIdx(input pod_due_date,output i).
            assign tps_planpo[i] = tps_planpo[i] + pod_qty_ord - pod_qty_rcvd.
end.

for each tmp_ps no-lock,
    each tmp_data0 exclusive-lock where t0_part = tps_comp:
    do i = 1 to 14:
       assign t0_open_po1[i] = t0_open_po1[i] + tps_planpo[i] * tps_qty.
    end.
end.


/**************TS计划销售量C1***************/
 for each tmp_data0 exclusive-lock,
     each sod_det fields(sod_part sod_qty_ord sod_qty_ship)
          use-index sod_part no-lock
   where sod_domain = global_domain and sod_site = t0_site and
         sod_part = t0_part and sod_qty_ord - sod_qty_ship > 0:
         run getIdx(input sod_due_date,output i).
          assign t0_open_so[i] = t0_open_so[i] + (sod_qty_ord - sod_qty_ship).
end.

/*******TS计划收货量C1**************/
for each tmp_data0 exclusive-lock,
     each pod_det no-lock where pod_domain = global_domain and
         pod_part = t0_part and
         pod_status <> "C" and pod_status <> "X" and
         (pod_qty_ord - pod_qty_rcvd) > 0 :
            run getIdx(input pod_due_date,output i).
     assign t0_open_po[i] = t0_open_po[i] + pod_qty_ord - pod_qty_rcvd.
end.

/***供应商预计库存(C1)*******/
for each tmp_data0 exclusive-lock:
    assign qtybom = 0.
    find first xcsm_det no-lock where xcsm_part = t0_part no-error.
         if available xcsm_det then do:
            assign qtybom = xcsm_qty.
         end.
    do i = 1 to 1:
       assign qtyiss = 0
              qtyrct = 0.
       for each tmp_ps where tps_comp = t0_part:
          assign qtyiss = qtyiss + tps_rctpo * tps_qty
                 qtyrct = qtyrct + tps_planpo[i] * tps_qty.
       end.
       assign t0_vd_qtyoh[i] = t0_iss_so - qtyiss + t0_open_so[i]
                             - qtyrct - qtybom.
    end.
    do i = 2 to 14:
       assign qtyiss = 0
              qtyrct = 0.
       for each tmp_ps where tps_comp = t0_part:
          assign qtyiss = qtyiss + tps_rctpo * tps_qty
                 qtyrct = qtyrct + tps_planpo[i] * tps_qty.
       end.
       assign t0_vd_qtyoh[i] = t0_vd_qtyoh[i - 1]
                             - t0_open_po1[i].
    end.
end.

/*预计库存量*/
 for each tmp_data0 exclusive-lock:
          assign qtyoh = 0.
          for each in_mstr no-lock where in_domain = global_domain and
                   in_part = t0_part:
            assign qtyoh = qtyoh + in_qty_oh.
          end.
          assign t0_qty_loc[1] = qtyoh + t0_open_po[1]
                               + t0_vd_qtyoh[1] - t0_qty_req[1].
          do i = 2 to 14:
             if t0_qty_req[i] = 0 then do:
             assign t0_qty_loc[i] = t0_qty_loc[i - 1] - t0_qty_req[i]
                                  + t0_open_po[i].
             end.
             else do:
             /*=TS库存+计划收货C1+VD预计库存C1-采购计收货B1-总需求C1 */
             assign t0_qty_loc[i] = t0_qty_loc[i - 1] + t0_open_po[i]
                                  - t0_open_po1[i] - t0_qty_req[i].
                                  /* + t0_open_po1[ i - 1]. */
             end.
          end.
  end.

  /**计划订购量***************/
  for each tmp_data0 exclusive-lock,
      each pt_mstr no-lock where pt_part = t0_part:
      assign vlog = yes.
      do i = 1 to 14:
         if t0_qty_loc[i] < 0 then do:
            if vlog = yes then do:
               assign vlog = no.
               assign t0_qty_planpo[i] =  t0_qty_loc[i] * - 1.
            end.
            else do:
               assign t0_qty_planpo[i] =  t0_qty_req[i].
            end.
            if t0_qty_req[i] = 0 then do:
                assign vlog = yes
                       t0_qty_loc[i] = 0.
            end.
         end.
      end.
  end.

/* for each tmp_data0 exclusive-lock:                                       */
/*    assign qtyoh = 0.                                                     */
/*    for each in_mstr no-lock where in_domain = global_domain and          */
/*             in_part = t0_part:                                           */
/*      assign qtyoh = qtyoh + in_qty_oh.                                   */
/*    end.                                                                  */
/*    do i = 1 to 1:                                                        */
/*       assign t0_qty_loc[i] = qtyoh + t0_vd_qtyoh[i]                      */
/*                            + t0_open_po[i] - t0_qty_req[i].              */
/*    end.                                                                  */
/*    do i = 2 to 14:                                                       */
/*       assign t0_qty_loc[i] = t0_qty_loc[i - 1] + qtyoh + t0_vd_qtyoh[i]  */
/*                            + t0_open_po[i] - t0_qty_req[i].              */
/*       if qtyoh < 0 then                                                  */
/*       assign t0_qty_planpo[i] = t0_qty_req[1] - qtyoh.                   */
/*    end.                                                                  */
/*  end.                                                                    */

/* for each tmp_data0 exclusive-lock break by t0_part:         */
/* if not first-of(t0_part) then do:                           */
/*   delete tmp_data0.                                         */
/* end.                                                        */
/* end.                                                        */

for each tmp_data0 exclusive-lock,
    each pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
         t0_part = pt_part and pt_pm_code = "P":
      if  (pt_prod_line >= prod_line and pt_prod_line <= prod_line1)
           and (pt_group >= ptgroup and pt_group <= ptgroup1)
           and (pt_part_type >= part_type and pt_part_type <= part_type1)
      then do:
/*      find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and   */
/*           ptp_part = pt_part and ptp_site = si_site no-error.             */
/*      if available ptp_det then do:                                        */
/*         if (ptp_buyer < buyer or ptp_buyer > buyer1)                      */
/*            or (ptp_vend < vendor or ptp_vend > vendor1)                   */
/*            or (not show_base and ptp_joint_type = "5")                    */
/*            or (ptp_pm_code <> pm_code and pm_code <> "" )                 */
/*            then next.                                                     */
/*      end.                                                                 */
/*      else do:                                                             */
/*            if (pt_buyer < buyer or pt_buyer > buyer1)                     */
/*            or (pt_vend < vendor or pt_vend > vendor1)                     */
/*            or (not show_base and pt_joint_type = "5")                     */
/*            or (pt_pm_code <> pm_code and pm_code <> "" )                  */
/*            then next.                                                     */
/*      end.                                                                 */

      if page-size - line-counter < 12 then page.

  /*    {fcsdate.i today fcsduedate week si_site}

      fcsduedate = fcsduedate - 7 * bck.
*/
      start = old_start.
/*      {mfdel.i "fsworkfile"}
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
 */
      qty_oh = 0.
      for each in_mstr no-lock  where in_mstr.in_domain = global_domain and
               in_part = pt_part:
              assign qty_oh = qtyoh + in_qty_oh.
      end.

      form
         pt_part        colon 14
         pt_desc1 no-label format "x(50)"
         pt_buyer       colon 100
         pt_site        colon 120
      with frame bbb side-labels width 132 no-attr-space page-top.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame bbb:handle).

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

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame bb:handle).

/*      if available ptp_det then do:                                     */
/*         display                                                        */
/*            pt_part                                                     */
/*            pt_desc1 + " " + pt_desc2 @ pt_desc1                        */
/*            pt_buyer                                                    */
/*            si_site                                                     */
/*         with frame bbb.                                                */
/*                                                                        */
/*         display                                                        */
/*            pt_um                                                       */
/*            ptp_ord_pol @ pt_ord_pol                                    */
/*            ptp_ord_min @ pt_ord_min                                    */
/*            in_mrp when (available in_mstr) @ pt_mrp                    */
/*            pt_mrp when (not available in_mstr)                         */
/*            ptp_ord_per @ pt_ord_per                                    */
/*            ptp_ord_max @ pt_ord_max                                    */
/*            ptp_ms @ pt_ms                                              */
/*            ptp_plan_ord @ pt_plan_ord                                  */
/*            ptp_ord_qty @ pt_ord_qty                                    */
/*            ptp_ord_mult @ pt_ord_mult                                  */
/*            qty_oh                                                      */
/*            ptp_iss_pol @ pt_iss_pol                                    */
/*            ptp_sfty_stk @ pt_sfty_stk                                  */
/*            ptp_mfg_lead @ pt_mfg_lead                                  */
/*            ptp_yld_pct @ pt_yield_pct                                  */
/*            ptp_pm_code @ pt_pm_code                                    */
/*            ptp_sfty_tme @ pt_sfty_time                                 */
/*            ptp_pur_lead @ pt_pur_lead                                  */
/*            ptp_ins_lead @ pt_insp_lead                                 */
/*            ptp_ins_rqd @ pt_insp_rqd                                   */
/*            ptp_timefnce @ pt_timefence                                 */
/*            ptp_cum_lead @ pt_cum_lead                                  */
/*            ptp_bom_code @ pt_bom_code                                  */
/*         with frame bb.                                                 */
/*      end.                                                              */
/*      else do:                                                          */
         display
            pt_part
            pt_desc1 + " " + pt_desc2 @ pt_desc1
            pt_buyer
            pt_site
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
/*      end.  */

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

         setFrameLabels(frame b:handle).


         display
            getTermLabel("DEMAND_TOTAL",13) format "x(13)"
            t0_qty_req[1] format "->>>>>>>>9"
            t0_qty_req[2 for 12] skip

            getTermLabel("SO_SHIP_QUANTITY",13) format "x(13)"
            t0_iss_so format "->>>>>>>>9"
            skip

            getTermLabel("PO_RCPT_QUANTITY",13) format "x(13)"
            t0_rct_po format "->>>>>>>>9"
            skip

            getTermLabel("PO_PLAN_RCPT_QUANTITY",13) format "x(13)"
            t0_open_po1[1] format "->>>>>>>>9"
            t0_open_po1[2 for 12]
            skip

            getTermLabel("SO_PLAN_SHIP_QUANTITY",13) format "x(13)"
            t0_open_so[1] format "->>>>>>>>9"
            t0_open_so[2 for 12]
            skip

            getTermLabel("SUPPLIER_PROJECTED_QOH",13) format "x(13)"
            t0_vd_qtyoh[1] format "->>>>>>>>9"
            t0_vd_qtyoh[2 for 12]
            skip

            getTermLabel("PLAN_RECIVED_QUANTITY",13) format "x(13)"
            t0_open_po[1] format "->>>>>>>>9"
            t0_open_po[2 for 12]
            skip

            getTermLabel("PROJECTED_QOH",13) format "x(13)"
            t0_qty_loc[1] format "->>>>>>>>9"
            t0_qty_loc[2 for 12]
            skip

            getTermLabel("SCHEDULE_ORDER_QUANTITY",13) format "x(13)"
            t0_qty_planpo[1] format "->>>>>>>>9"
            t0_qty_planpo[2 for 12]
            skip

          with frame b.

      {mfrpchk.i}
   end. /* if pt_prod_line */
end. /*for each si_mstr*/

{mfrpexit.i "false"}

start = old_start.

/* RE-COMPUTE START DATES */

hide message no-pause.
hide frame b.
hide frame bb.
{wbrp04.i}

procedure getIdx:
  define input parameter iDate as date.
  define output parameter oIdx as integer.

  define variable vi as integer.
  define variable vj as integer.
  assign vj = 1.
  do vi = 1 to 14:
     if iDate >= sdate[vi] then do:
        vj = vi.
     end.
     else do:
         leave.
     end.
  end.
  assign oIdx = vj.
end procedure.
