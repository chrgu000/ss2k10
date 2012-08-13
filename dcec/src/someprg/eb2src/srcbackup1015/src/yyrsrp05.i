/* GUI CONVERTED from rsrp05.i (converter v1.77) Thu Nov 27 02:07:28 2003 */
/* rsrp05.i - Release Management Supplier Schedules                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.21.4.1 $                                                         */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.0    LAST MODIFIED: 01/29/92           BY: WUG *F110*    */
/* REVISION: 7.0    LAST MODIFIED: 03/16/92           BY: WUG *F312*    */
/* REVISION: 7.0    LAST MODIFIED: 03/26/92           BY: WUG *F323*    */
/* REVISION: 7.3    LAST MODIFIED: 09/25/92           BY: WUG *G094*    */
/* REVISION: 7.3    LAST MODIFIED: 12/17/92           BY: WUG *G462*    */
/* REVISION: 7.3    LAST MODIFIED: 03/18/93           BY: WUG *G841*    */
/* REVISION: 7.3    LAST MODIFIED: 06/01/93           BY: WUG *GB48*    */
/* REVISION: 7.3    LAST MODIFIED: 06/03/93           BY: WUG *GA75*    */
/* REVISION: 7.3    LAST MODIFIED: 06/07/93           BY: WUG *GB75*    */
/* REVISION: 7.3    LAST MODIFIED: 06/23/93           BY: WUG *GC62*    */
/* REVISION: 7.3    LAST MODIFIED: 07/14/93           BY: WUG *GD43*    */
/* REVISION: 7.4    LAST MODIFIED: 11/01/93           BY: WUG *H204*    */
/* REVISION: 7.4    LAST MODIFIED: 12/06/93           BY: WUG *GH75*    */
/* REVISION: 7.4    LAST MODIFIED: 02/24/94           BY: WUG *GI82*    */
/* REVISION: 7.4    LAST MODIFIED: 08/23/94           BY: dpm *GL43*    */
/* REVISION: 7.4    LAST MODIFIED: 11/01/94           BY: ame *GN88*    */
/* REVISION: 7.4    LAST MODIFIED: 01/06/95           BY: jxz *G0BJ*    */
/* REVISION: 7.4    LAST MODIFIED: 09/16/95           BY: vrn *G0X9*    */
/* REVISION: 7.3    LAST MODIFIED: 10/18/95           BY: vrn *G0ZY*    */
/* REVISION: 7.4    LAST MODIFIED: 11/28/95           BY: kjm *G1F5*    */
/* REVISION: 7.4    LAST MODIFIED: 11/17/97           BY: *G2QB* Niranjan R. */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 12/01/98   BY: *K1QY* Pat McCormick     */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 03/29/99   BY: *J3BM* Reetu Kapoor      */
/* REVISION: 9.1      LAST MODIFIED: 09/30/99   BY: *J3LY* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/08/00   BY: *N0J4* Mudit Mehta       */
/* SCHEDULE PRINT INCLUDE */

/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.21     BY: Mugdha Tambe  DATE: 03/29/01 ECO: *N0XW*          */
/* $Revision: 1.21.4.1 $    BY: Rajaneesh S.  DATE: 11/24/03 ECO: *N2N9*          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/



/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

define new shared variable billto as character format "x(38)" extent 6.
define new shared variable vendor as character format "x(38)" extent 6.
define new shared variable shipto as character format "x(38)" extent 6.
define new shared variable addr as character format "x(38)" extent 6.

define shared variable zeroqtyline like mfc_logical no-undo.

define variable vend_phone like ad_phone.
define variable ship_phone like ad_phone.
define variable vend_fax like ad_fax.
define variable ship_fax like ad_fax.
define variable vdattn like ad_attn.
define variable shipattn like ad_attn.
define variable terms like ct_desc.
define variable i as integer.
define variable prior_cum_net_req like schd_cum_qty label "Net Req Qty".
define variable prior_cum_req like sch_pcr_qty.
define variable cum_qty like schd_cum_qty.
define variable cum_net_req as decimal.
define variable net_req like schd_discr_qty label "Net Req Qty" .
define variable prh_recid as recid.
define variable rcp_date like prh_rcp_date.
define variable rcvd like prh_rcvd.
define variable cum_rcvd like prh_cum_rcvd.
define variable ps_nbr like prh_ps_nbr.
define variable schtype_desc as character format "x(40)".
define variable sd_pat_desc like code_cmmt.
define variable rcp_time as character format "x(5)".
define variable interval as character label "Interval" .
define variable old_interval like interval.
define variable wk_schd_interval like schd_det.schd_interval no-undo.
define variable wk_print_zero_lines_sw
   like mfc_logical initial yes no-undo.
define variable po_edi_enabled
   like mfc_logical initial no no-undo.
define variable release_date as date no-undo.
define variable lastdaysdt as date.
define variable lastweeksdt as date.
define variable lastmthsdt as date.
define variable work_dt as date.
define variable all_zero like mfc_logical.
define variable curr_line_ct as integer.
define variable before like mfc_logical initial yes.
define variable schedule_days as integer.
define variable intransit_qty like pod_qty_ord label "In Transit Qty" .
define variable bucketing like mfc_logical.
define variable last_date as date.
define variable idate as date.
define variable last_firm_date as date.

define variable l_shp_date  like schd_date no-undo .
define variable l_shp_time  like schd_time no-undo .
define variable l_dly_date  like schd_date no-undo .
define variable l_dly_time  like schd_time no-undo .

define workfile work_schd
   field schd_date      like schd_det.schd_date
   field schd_time      like schd_det.schd_time
   field schd_interval  like schd_det.schd_interval
   field schd_reference like schd_det.schd_reference
   field schd_discr_qty like schd_det.schd_discr_qty
   field schd_cum_qty   like schd_det.schd_cum_qty
   field schd_fc_qual   like schd_det.schd_fc_qual.
define workfile work2_schd
   field schd_date      like schd_det.schd_date
   field schd_time      like schd_det.schd_time
   field schd_interval  like schd_det.schd_interval
   field schd_reference like schd_det.schd_reference
   field schd_discr_qty like schd_det.schd_discr_qty
   field schd_cum_qty   like schd_det.schd_cum_qty
   field schd_fc_qual   like schd_det.schd_fc_qual.

if (substring(po_sch_mthd,1,1) = "e"   or
   substring(po_sch_mthd,1,1)  = "b"   or
   substring(po_sch_mthd,2,1)  = "y")  then
   po_edi_enabled = yes.

prh_recid = ?.

for each prh_hist no-lock
      where prh_nbr = pod_nbr
      and prh_line = pod_line
      and prh_part = pod_part
      use-index prh_part
      break by prh_rcp_date descending by prh_receiver descending:
   prh_recid = recid(prh_hist).
   leave.
end.

assign
   rcp_date = ?.
   rcvd = 0.
   cum_rcvd = pod_cum_qty[1].
   ps_nbr = "".

if prh_recid <> ? then do:
   find prh_hist where recid(prh_hist) = prh_recid no-lock.
   rcp_date = prh_rcp_date.
   rcvd = prh_rcvd.
   ps_nbr = prh_ps_nbr.

   find last tr_hist where tr_addr = po_vend
      and tr_type = "rct-po"
      and tr_nbr  = pod_nbr
      and tr_line = pod_line
      and tr_lot = prh_receiver
      and tr_part = prh_part
      and tr_effdate = prh_rcp_date
      use-index tr_part_eff
      no-lock no-error.

   rcp_time = if available tr_hist then string(tr_time,"hh:mm") else "".
end.

/* GET INTRANSIT QTY*/
{gprun.i ""rsitq.p"" "(input pod_nbr, input pod_line, output intransit_qty)"}

/* FIND LAST FIRM  DATE  IN  SCHEDULE  TO  FIGURE  SCHEDULE  DAYS
   BECAUSE FIRM QUANTITIES WILL NOT BE BUCKETED */

assign
   last_firm_date = sch_pcs_date + pod_firm_days.
   schedule_days = pod_plan_days.

find last schd_det
   where schd_type = sch_type
   and schd_nbr = sch_nbr
   and schd_line = sch_line
   and schd_rlse_id = sch_rlse_id
   and schd_fc_qual = "f"
   no-lock no-error.

if available schd_det then do:
   if pod_plan_days > 0 then
      schedule_days = max(schd_date - sch_pcs_date,pod_plan_days).

   last_firm_date = max(last_firm_date, schd_date).
end. /* IF AVAILABLE SCHD_DET */

for each work_schd exclusive-lock:
   delete work_schd.
end.

for each work2_schd exclusive-lock:
   delete work2_schd.
end.

/*IF USING BUCKETING, CALCULATE DISCRETE/WEEK/MONTH ENDING DATES*/

if pod_plan_days = 0 and pod_plan_weeks = 0 and pod_plan_mths = 0 then do:
   bucketing = false.
end.
else do:
   bucketing = true.

   if sch_type > 4 then bucketing = false.

   /* CHECK FLAG TO SEE IF MODULE IS TURNED ON */
   if can-find (first mfc_ctrl where
      mfc_field = "enable_shipping_schedules"
      and mfc_seq = 4 and mfc_module = "ADG"
      and mfc_logical = yes) then do:
      {gprunmo.i
         &program=""rsrp05d.p""
         &module="ASH"
         &param="""(output wk_print_zero_lines_sw)"""}
      for each qad_wkfl where qad_key1 = "vd_mstr_ash" and
            qad_key2 = po_vend:
         if qad_charfld[3] = "yes"
         then
            wk_print_zero_lines_sw = yes.
         else
            wk_print_zero_lines_sw = no.
      end. /* for each */
   end. /* if can-find */

   {gprun.i ""rscalcld.p"" "(input sch_pcs_date + 1, input schedule_days,
       input pod_plan_weeks, input pod_plan_mths,
       output lastdaysdt, output lastweeksdt, output lastmthsdt)"}
end.

for each schd_det no-lock
      where schd_type = sch_type
      and schd_nbr = sch_nbr
      and schd_line = sch_line
      and schd_rlse_id = sch_rlse_id
      break by schd_date:
   if bucketing then do:
      work_dt = ?.

      if schd_date <= lastdaysdt then do:
         work_dt = schd_date.
         interval = "D".
      end.
      else
         if schd_date <= lastweeksdt then do:
         /* GET MONDAY OF WEEK THIS DATE IS IN */
         {gprun.i ""rswmd.p"" "(input schd_date, input before, output work_dt)"}
         interval = "W".
      end.
      else
         if schd_date <= lastmthsdt then do:
         /* GET MONDAY OF MONTH THIS DATE IS IN.  NOTE THAT IF THE DATE */
         /* FALLS  BEFORE THE FIRST MONDAY OF THE MONTH OF THE DATE, WE */
         /* USE THE DATE OF THE FIRST MONDAY OF THE PRIOR MONTH.*/

         {gprun.i ""rsm1md.p""
            "(input schd_date, input before, output work_dt)"}
         interval = "M".
      end.

      if work_dt <> ? then do for work_schd:
            create work_schd.

            assign
               schd_date = work_dt
               schd_time = schd_det.schd_time
               schd_interval = interval
               schd_reference = schd_det.schd_reference
               schd_discr_qty = schd_det.schd_discr_qty
               schd_fc_qual = schd_det.schd_fc_qual.

            if interval <> "D" then do:
               assign
                  schd_time = ""
                  schd_reference = ""
                  .
            end.
         end.
      end.
      else do for work_schd:

         if schd_det.schd_type = 4 then
            wk_schd_interval = "D".
         else
            wk_schd_interval = schd_det.schd_interval.

         create work_schd.

         assign
            schd_date = schd_det.schd_date
            schd_time = schd_det.schd_time

            schd_interval = wk_schd_interval
            schd_reference = schd_det.schd_reference
            schd_discr_qty = schd_det.schd_discr_qty
            schd_fc_qual = schd_det.schd_fc_qual.
      end.
   end.

   /* IF BUCKETING THEN ENSURE THERE ARE AT LEAST ZERO QUANTITIES FOR ALL */
   /* POSSIBLE DATES */

   if bucketing then do:
      last_date = lastmthsdt.
      if last_date = ? then last_date = lastweeksdt.
      if last_date = ? then last_date = lastdaysdt.

      if last_date <> ? then do for work_schd:
            idate = sch_pcs_date + 1.

            do while idate <= last_date:
               work_dt = ?.

               if idate <= lastdaysdt then do:
                  work_dt = idate.
                  Interval = "D".
                  idate = idate + 1.
               end.
               else
                  if idate <= lastweeksdt then do:
                  /* GET MONDAY OF WEEK THIS DATE IS IN */
                  {gprun.i ""rswmd.p"" "(input idate, input before, output work_dt)"}
                  interval = "W".
                  idate = work_dt + 7.
               end.
               else
                  if idate <= lastmthsdt then do:

                  /* GET MONDAY OF MONTH THIS DATE IS IN.  NOTE THAT IF THE */
                  /* DATE FALLS BEFORE THE FIRST MONDAY OF THE MONTH OF THE */
                  /* DATE, WE USE THE DATE OF THE FIRST MONDAY OF THE PRIOR */
                  /* MONTH. */

                  {gprun.i ""rsm1md.p"" "(input idate, input before, output work_dt)"}
                  interval = "M".
                  idate = work_dt + 45.
               end.

               if work_dt <> ? then do:
                  create work_schd.

                  assign
                     schd_date = work_dt
                     schd_interval = interval.

                  if schd_date <= last_firm_date then schd_fc_qual = "F".
                  else schd_fc_qual = "P".
               end.
            end.
         end.
      end.

      all_zero = yes.

      prior_cum_net_req = max(sch_pcr_qty - pod_cum_qty[1],0).
      if prior_cum_net_req > 0 then all_zero = no.

      for each work_schd no-lock

            break by schd_date
            by schd_time
            by schd_reference
            by schd_discr_qty:

         if schd_discr_qty <> 0 then all_zero = no.

         accumulate work_schd.schd_discr_qty
            (sub-total by work_schd.schd_reference).

         if last-of(schd_reference) then do for work2_schd:
               create work2_schd.

               assign
                  schd_date      = work_schd.schd_date
                  schd_time      = work_schd.schd_time
                  schd_interval  = work_schd.schd_interval
                  schd_reference = work_schd.schd_reference
                  schd_discr_qty = accum sub-total by work_schd.schd_reference
                  work_schd.schd_discr_qty.

               schd_fc_qual = work_schd.schd_fc_qual.
            end.
         end.

         if not print_zero and all_zero then next.

         sd_pat_desc = "".
         find code_mstr where code_fldname = "pod_sd_pat"
            and code_value = pod_sd_pat no-lock no-error.
         if available code_mstr then sd_pat_desc = code_cmmt.

         terms = "".
         find ct_mstr where ct_code = po_cr_terms no-lock no-error.
         if available ct_mstr then terms = ct_desc.

         schtype_desc = getTermLabel("DATES_SHOWN_ARE_FOR_RECPT_IN_PLANT",40).
         if pod_translt_days > 0 then do:

            schtype_desc = getTermLabel("DATES_SHOWN_ARE_FOR_SHPMNT_BY_SUPP",40).
         end.

         assign
            vendor = ""
            vdattn = ""
            vend_phone = ""
            vend_fax = "".

         find ad_mstr where ad_addr = po_vend no-lock no-error.

         if available ad_mstr then do:
            addr[1] = ad_name.
            addr[2] = ad_line1.
            addr[3] = ad_line2.
            addr[4] = ad_line3.
            addr[6] = ad_country.
            vend_phone = ad_phone.
            vend_fax = ad_fax.
            {mfcsz.i   addr[5] ad_city ad_state ad_zip}
            {gprun.i ""gpaddr.p"" }
            vendor[1] = addr[1].
            vendor[2] = addr[2].
            vendor[3] = addr[3].
            vendor[4] = addr[4].
            vendor[5] = addr[5].
            vendor[6] = addr[6].
            if ad_attn <> "" then do:
               vdattn = ad_attn.
            end.
         end.

         assign
            shipto = ""
            shipattn = ""
            ship_phone = ""
            ship_fax = "".

         find ad_mstr where ad_addr = pod_site no-lock
            no-error.

         if not available ad_mstr then do:
            find ad_mstr where ad_addr = po_ship no-lock no-error.
         end.

         if available ad_mstr then do:
            addr[1] = ad_name.
            addr[2] = ad_line1.
            addr[3] = ad_line2.
            addr[4] = ad_line3.
            addr[6] = ad_country.
            ship_phone = ad_phone.
            ship_fax = ad_fax.
            {mfcsz.i   addr[5] ad_city ad_state ad_zip}
            {gprun.i ""gpaddr.p"" }
            shipto[1] = addr[1].
            shipto[2] = addr[2].
            shipto[3] = addr[3].
            shipto[4] = addr[4].
            shipto[5] = addr[5].
            shipto[6] = addr[6].
            if ad_attn <> "" then do:
               shipattn = ad_attn.
            end.
         end.
         else do:
            find si_mstr where si_site = pod_site no-lock.
            shipto[1] = si_desc.
         end.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame phead1:handle).
         display
            fax_nbr                 no-label
   /*judy 07/07/05*/  "DCP-03-17-01-00 F002" skip(1)
            caps(getTermLabel("SUPPLIER_SCHEDULE",19)) + " / " +
            caps(getTermLabel("MATERIAL_RELEASE",18))
            format "x(40)" at 22 when (schtype <> 6)
            caps(getTermLabel("SUPPLIER_SHIPPING_SCHEDULE",40))
            format "x(40)" at 27 when (schtype = 6)
            skip(1)
            po_vend                 colon 12
            pod_site                colon 55 label "Ship-To"
            vendor[1]               at 4    no-label
            shipto[1]               at 48   no-label
            vendor[2]               at 4    no-label
            shipto[2]               at 48   no-label
            vendor[3]               at 4    no-label
            shipto[3]               at 48   no-label
            vendor[4]               at 4    no-label
            shipto[4]               at 48   no-label
            vendor[5]               at 4    no-label
            shipto[5]               at 48   no-label
            vendor[6]               at 4    no-label
            shipto[6]               at 48   no-label
            vdattn                  colon 13
            shipattn                colon 57
            vend_phone              colon 13
            ship_phone              colon 57
            vend_fax                colon 13
            ship_fax                colon 57
            skip(1)

            sch_rlse_id            colon 15

            sch_pcs_date + 1 @  release_date colon 60 label "Release Date"
            po_nbr                  colon 15
            po_buyer                colon 60
            pod_part                colon 15
            pod_um
            intransit_qty           colon 60
            pt_desc1                at 16 no-label
            rcp_date                colon 60
            rcp_time                no-label
            pt_desc2                to 39 no-label
            rcvd                    colon 60
            pod_vpart               colon 15
            cum_rcvd                colon 60
            po_contact              colon 15
            ps_nbr                  colon 60 label  "Packing Slip/Shipper"
            skip(1)

         with frame phead1 page-top width 90 no-box side-labels STREAM-IO /*GUI*/ .

         if schtype <> 6 then do with frame phead2:
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame phead2:handle).
            display
               pod_sd_pat
               sd_pat_desc no-label
               skip(1)
            with frame phead2 page-top width 90 no-box side-labels STREAM-IO /*GUI*/ .
         end. /* if schtype <> 6 then */

         
/*GUI*/ {mfguichk.i  &warn=false &label=mainloop} /*Replace mfrpchk*/


         curr_line_ct = line-counter.

         {gpcmtprt.i &type=PO &id=po_cmtindx &pos=1}
         {gpcmtprt.i &type=PO &id=pod_cmtindx &pos=1}
         {gpcmtprt.i &type=PO &id=sch_cmtindx &pos=1}
         if line-counter <> curr_line_ct then put skip(1).

         prior_cum_net_req = max(sch_pcr_qty - pod_cum_qty[1],0).

         do for work2_schd:
            FORM /*GUI*/ 
               interval
               l_dly_date  column-label "Deliver!Date"
               l_dly_time  column-label "Deliver!Time"

               schd_reference    format "x(10)"
               schd_fc_qual
               schd_discr_qty label "Req Qty"
               schd_cum_qty   label "Cum Req Qty"
               net_req
            with STREAM-IO /*GUI*/  frame pd width 80 down no-box.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame pd:handle).

            FORM /*GUI*/ 
               interval
               l_shp_date column-label "Ship!Date"
               l_shp_time column-label "Ship!Time"

               schd_reference    format "x(10)"
               schd_fc_qual
               schd_discr_qty label "Req Qty"
               schd_cum_qty   label "Cum Req Qty"
               net_req
            with STREAM-IO /*GUI*/  frame ps width 80 down no-box.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame ps:handle).
         end.

         if pod_translt_days > 0 then do for work2_schd:

               display getTermLabel("PRIOR",8) @ l_shp_date
                  sch_pcr_qty @ schd_cum_qty
                  prior_cum_net_req @ net_req
               with frame ps STREAM-IO /*GUI*/ .

               down 1 with frame ps.
            end.
            else do for work2_schd:

               display getTermLabel("PRIOR",8) @ l_dly_date
                  sch_pcr_qty @ schd_cum_qty
                  prior_cum_net_req @ net_req
               with frame pd STREAM-IO /*GUI*/ .

               down 1 with frame pd.
            end.

            /* PRINT SCHEDULE DETAIL*/

            assign
               interval = ""
               old_interval = ""
               cum_qty = sch_pcr_qty.

            for each work2_schd no-lock
                  break by schd_date by schd_time by schd_reference:

               assign
                  interval =  if schd_interval = "D" then
                                 getTermLabel("DAILY",8)
                              else
                              if schd_interval = "W" then
                                 getTermLabel("WEEKLY",8)
                              else getTermLabel("MONTHLY",8)
                  cum_qty = cum_qty + schd_discr_qty
                  schd_cum_qty = cum_qty
                  cum_net_req = max(schd_cum_qty - pod_cum_qty[1],0)
                  net_req = cum_net_req - prior_cum_net_req
                  prior_cum_net_req = cum_net_req.

               if not wk_print_zero_lines_sw
                  and schd_discr_qty = 0 then .
               else
               if not zeroqtyline
                  and schd_discr_qty = 0 then .
                  /* SCHEDULE LINES WITH ZERO REQUIRED QUANTITY WILL NOT BE */
                  /* DISPLAYED IF zeroqtyline IS SET TO NO.                 */
               else do:

                  if pod_translt_days > 0 then do:
                     if interval <> old_interval then do with frame ps:
                        down 1.
                        display interval with frame ps STREAM-IO /*GUI*/ .

                        /* STORING THE VALUE OF INTERVAL WHICH IS DISPLAYED */
                        /* IN THE REPORT IN VARIABLE old_interval.          */
                        old_interval = interval.
                     end.
                    
                     assign
                        l_shp_date = schd_date
                        l_shp_time = schd_time .

                     display
                        l_shp_date  - pod_translt_days @ l_shp_date
                        l_shp_time
                        schd_reference
                        schd_discr_qty
                        schd_fc_qual
                        schd_cum_qty
                        net_req
                     with frame ps STREAM-IO /*GUI*/ .

                     down 1 with frame ps.
                  end.
                  else do:
                     if interval <> old_interval then do with frame pd:
                        down 1.
                        display interval with frame pd STREAM-IO /*GUI*/ .

                        /* STORING THE VALUE OF INTERVAL WHICH IS DISPLAYED */
                        /* IN THE REPORT IN VARIABLE old_interval.          */
                        old_interval = interval.
                     end.

                    
                     assign
                        l_dly_date = schd_date
                        l_dly_time = schd_time .

                     display
                        l_dly_date
                        l_dly_time
                        schd_reference
                        schd_discr_qty
                        schd_fc_qual
                        schd_cum_qty
                        net_req
                     with frame pd STREAM-IO /*GUI*/ .

                     down 1 with frame pd.
                  end.
               end. /* else do */

               
/*GUI*/ {mfguichk.i  &warn=false &label=mainloop} /*Replace mfrpchk*/

            end.

            /* DISPLAY AUTHORIZATION DATA */

            FORM /*GUI*/ 
               sch_fab_qty          at 1 label "Fab Authorization Cum Qty"
               sch_fab_end          label "Thru"
               sch_raw_qty          at 1 label "Raw Authorization Cum Qty"
               sch_raw_end          label "Thru"
            with STREAM-IO /*GUI*/  frame res_auth_data width 80 side-labels.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame res_auth_data:handle).

            if sch_type <> 6 then

            display
               sch_fab_qty
               sch_fab_end
               sch_raw_qty
               sch_raw_end
            with frame res_auth_data STREAM-IO /*GUI*/ .

            
/*GUI*/ {mfguichk.i  &warn=false &label=mainloop} /*Replace mfrpchk*/


            do while line-counter < page-size - 1:
               put skip(1).
            end.

            put skip(1).

            put {gplblfmt.i
               &FUNC=getTermLabel(""APPROVED_BY"",20)
               &CONCAT = "':_____________________________'"
               } skip.

            hide frame phead1.
            hide frame phead2.
            page.
