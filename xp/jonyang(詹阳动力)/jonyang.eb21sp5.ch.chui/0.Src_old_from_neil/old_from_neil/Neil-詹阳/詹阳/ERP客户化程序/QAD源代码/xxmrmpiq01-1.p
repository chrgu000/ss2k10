/* GUI CONVERTED from mrmpiq01.p (converter v1.71) Tue Oct 13 17:58:22 1998 */
/* mrmpiq01.p - MRP DETAIL INQUIRY                                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert mrmpiq01.p (converter v1.00) Fri Oct 10 13:57:49 1997 */
/* web tag in mrmpiq01.p (converter v1.00) Mon Oct 06 14:18:26 1997 */
/*F0PN*/ /*K10G*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0    LAST MODIFIED: 07/18/86     BY: EMB                 */
/* REVISION: 2.0    LAST MODIFIED: 08/07/87     BY: EMB                 */
/* REVISION: 4.0    LAST MODIFIED: 01/07/88     BY: EMB *A133*          */
/* REVISION: 4.0    LAST MODIFIED: 12/30/87     BY: WUG *A137*          */
/* REVISION: 2.0    LAST MODIFIED: 01/22/88     BY: PML *A158*          */
/* REVISION: 4.0    LAST MODIFIED: 03/18/88     BY: EMB *A162*          */
/* REVISION: 4.0    LAST MODIFIED: 05/17/88     BY: EMB                 */
/* REVISION: 5.0    LAST MODIFIED: 05/03/89     BY: WUG *B098*          */
/* REVISION: 5.0    LAST MODIFIED: 11/08/89     BY: EMB *B386*          */
/* REVISION: 5.0    LAST MODIFIED: 10/19/90     BY: emb *B806*          */
/* REVISION: 6.0    LAST MODIFIED: 05/17/90     BY: RAM *D026*          */
/* REVISION: 6.0    LAST MODIFIED: 08/07/90     BY: emb *D040*          */
/* REVISION: 6.0    LAST MODIFIED: 10/23/90     BY: emb *D130*          */
/* REVISION: 6.0    LAST MODIFIED: 10/29/90     BY: WUG *D151*          */
/* REVISION: 6.0    LAST MODIFIED: 11/15/90     BY: emb *D219*          */
/* REVISION: 6.0    LAST MODIFIED: 03/05/91     BY: emb *D399*          */
/* REVISION: 7.0    LAST MODIFIED: 10/10/91     BY: emb *F024*          */
/* REVISION: 7.0    LAST MODIFIED: 03/20/92     BY: WUG *F312*          */
/* REVISION: 7.0    LAST MODIFIED: 07/28/92     BY: emb *F816*          */
/* REVISION: 7.2    LAST MODIFIED: 11/09/92     BY: emb *G295*          */
/* REVISION: 7.3    LAST MODIFIED: 11/19/92     BY: jcd *G339*          */
/* REVISION: 7.3    LAST MODIFIED: 08/19/93     BY: emb *GE37*          */
/* REVISION: 7.3    LAST MODIFIED: 08/26/94     BY: rxm *GL56*          */
/* REVISION: 7.3    LAST MODIFIED: 09/01/94     BY: ljm *FQ67*          */
/* REVISION: 7.3    LAST MODIFIED: 09/09/94     BY: pxd *FQ92*          */
/* REVISION: 8.5    LAST MODIFIED: 09/29/94     BY: tjs *J014*          */
/* REVISION: 8.5    LAST MODIFIED: 03/28/95     BY: emb *J045*          */
/* REVISION: 7.3    LAST MODIFIED: 09/05/95     BY: str *G0WF*          */
/* REVISION: 7.3    LAST MODIFIED: 10/30/95     BY: jym *G1BJ*          */
/* REVISION: 8.6    LAST MODIFIED: 10/15/97     BY: ckm *K10G*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* Revision: 8.6E   LAST MODIFIED: 06/11/98     BY: *J23R* Santhosh Nair */
/* Revision: 8.6E   LAST MODIFIED: 10/12/98     BY: *L0BY* Alfred Tan    */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

     {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mrmpiq01_p_1 "父件:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_2 "计划订货量"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_3 "分销单:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_4 "子零件订单:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_5 "生产预测"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_6 "详述"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_7 "复合产品: "
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_8 "订货原则"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_9 "标志:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_10 "客户订单:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_11 "订货周期"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_12 "总需求量"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_13 "开始有效"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_14 "选项:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_15 "预测"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_16 "采购单:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_17 "序号:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_18 "预计库存量"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_19 "(废品申请)"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_20 " 项目:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_21 "供应商采购单:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_22 "申请号:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_23 "计划收货量"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_24 "订:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_25 "下达日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_26 "地点:"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmpiq01_p_27 "工单:"
/* MaxLen: Comment: */
&SCOPED-DEFINE mrmpiq01_p_28 "描述:"
/* ********** End Translatable Strings Definitions ********* */

     define new shared variable fcssite like si_site.
     define new shared variable fcspart like pt_part.
/*FQ67*  define new shared variable forward like soc_fcst_fwd. */
/*FQ67*/ define new shared variable frwrd like soc_fcst_fwd.
/*FQ67*  define new shared variable back like soc_fcst_bck. */
/*FQ67*/ define new shared variable bck like soc_fcst_bck.
     define new shared variable fcsduedate as date.

     define new shared workfile fsworkfile no-undo
       field fsdate as date
       field fsqty as decimal.
     define variable i as integer.
     define variable week as integer.
     define variable site like si_site.
     define variable start like ro_start.
     define variable part like mrp_part.
     define variable gross as dec format "->,>>>,>>>" label {&mrmpiq01_p_12}.
     define variable recpt like gross label {&mrmpiq01_p_23}.
     define variable ord like gross label {&mrmpiq01_p_2}.
     define variable qoh as decimal format "->,>>>,>>9" label {&mrmpiq01_p_18}.
     define variable detail as character format "x(35)" label {&mrmpiq01_p_6}.
     define variable detail1 like detail.
     define variable detail2 like detail.
     define variable detail3 like detail.
     define variable j as integer.
     define variable due_date like mrp_due_date.
     define variable begin_avail like mfc_logical.
     define variable qty_oh like in_qty_oh.
     define variable ptdesc like pt_desc1.
     define variable wkctr1 like ro_wkctr.
     define variable wkctr2 like ro_wkctr.
find first soc_ctrl where soc_domain = global_domain no-lock no-error.
/*F024*
 *  {fcsdate.i today fcsduedate week}
 *  if available soc_ctrl then fcsduedate = fcsduedate - 7 * soc_fcst_bck. */

     if available soc_ctrl then do:
/*FQ67*     forward = soc_fcst_fwd. */
/*FQ67*/    frwrd = soc_fcst_fwd.
/*FQ67*     back = soc_fcst_bck. */
/*FQ67*/    bck = soc_fcst_bck.
     end.

part = global_part.
site = global_site.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        in_part in_site start  skip
/*GL56      pt_desc1 no-label no-attr-space pt_desc2 no-label no-attr-space */
/*GL56*/    pt_desc1 no-label at 2 no-attr-space
/*GL56*/    pt_desc2 no-label no-attr-space
with frame a width 80 attr-space side-labels.

setframelabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*K10G*/ {wbrp01.i}

main-loop:
repeat:

   hide frame c.
   hide frame bb.

   display part @ in_part
   site @ in_site
   with frame a.

   do on error undo, retry:


/*K10G*/ if c-application-mode <> 'web':u then
      prompt-for in_part
      in_site start
      with frame a editing:


     if frame-field = "in_part" then do:

        /* FIND NEXT/PREVIOUS RECORD */
        {mfnp.i pt_mstr in_part " pt_mstr.pt_domain = global_domain and pt_part" in_part pt_part pt_part}

        if recno <> ? then do:
           display pt_part @ in_part pt_desc1 pt_desc2
           with frame a.
        end.
     end.
     else if frame-field = "in_site" then do:

        /* FIND NEXT/PREVIOUS RECORD */
        {mfnp.i si_mstr in_site "si_domain = global_domain and si_site" in_site si_site si_site}

        if recno <> ? then do:
           display si_site @ in_site with frame a.
        end.
     end.
     else do:
        readkey.
        apply lastkey.
     end.
      end.

/*K10G*/ {wbrp06.i &command = prompt-for &fields = "  in_part in_site start" &frm = "a"}

/*K10G*/ if (c-application-mode <> 'web':u) or
/*K10G*/ (c-application-mode = 'web':u and
/*K10G*/ (c-web-request begins 'data':u)) then do:

      status input "".

      find pt_mstr where pt_domain = global_domain and pt_part = input in_part no-lock no-error.
      if not available pt_mstr then do:
     hide message no-pause.
     {mfmsg.i 17 3}
     /* "ERROR: ITEM NUMBER DOES NOT EXIST.  Please re-enter.". */
/*K10G*/ if c-application-mode = 'web':u then return.
    undo.
      end.
      display pt_part @ in_part pt_desc1 pt_desc2 with frame a.

      find si_mstr no-lock where si_domain = global_domain and si_site = input in_site no-error.
      if not available si_mstr then do:
/*K10G*/ if c-application-mode = 'web':u then return.
     undo, retry.
      end.
      assign start site = si_site.
      if start = ? then start = low_date.

      part = pt_part.


/*K10G*/ end.

      /* SELECT PRINTER */
      {mfselprt.i "terminal" 80}

      hide frame a.

   end.

   qty_oh = 0.
   find first ro_det where ro_domain = global_domain and ro_routing = pt_part no-lock no-error.
   if available ro_det then wkctr1 = ro_wkctr.
   if not available ro_det then wkctr1 = "".
   find last ro_det where ro_domain = global_domain and ro_routing = pt_part no-lock no-error.
   if available ro_det then wkctr2 = ro_wkctr.
   if not available ro_det then wkctr2 = "".

   find ptp_det no-lock where ptp_domain = global_domain and ptp_part = pt_part
   and ptp_site = si_site no-error.
   find in_mstr no-lock where in_domain = global_domain and in_part = pt_part
   and in_site = si_site no-error.
   if available in_mstr then qty_oh = in_qty_oh.

FORM /*GUI*/ 
   pt_part        colon 14  
   qty_oh         colon 50
   si_site        colon 69
   pt_desc1 no-label format "x(46)"
   pt_um          colon 50
   pt_pm_code     colon 69
   pt_phantom     colon 74
   pt_buyer       colon 14
   pt_ord_pol     colon 32 label {&mrmpiq01_p_8}
   pt_ord_min     colon 50
   pt_mfg_lead    colon 69
   pt_ms          colon 14
   pt_ord_per     colon 32 label {&mrmpiq01_p_11}
   pt_ord_max     colon 50
   pt_pur_lead    colon 69
   pt_mrp         colon 14
   pt_timefence   colon 32
   pt_ord_mult    colon 50
   pt_insp_lead   colon 69
   pt_plan_ord    colon 14
   pt_sfty_time   colon 32
   pt_ord_qty     colon 50
   pt_insp_rqd    colon 69
   pt_iss_pol     colon 14
   pt_sfty_stk    colon 32
   pt_yield_pct   colon 50
   pt_cum_lead    colon 69
   wkctr1         colon 14
   wkctr2         colon 50 
with STREAM-IO /*GUI*/  frame bb side-labels width 100 no-attr-space.
setframelabels(frame bb:handle).

   if available ptp_det then display
      ptp_part @ pt_part
      si_site
      pt_um
      pt_phantom      
      ptp_ord_pol @ pt_ord_pol
      ptp_ord_min @ pt_ord_min
      pt_desc1 + " " + pt_desc2 @ pt_desc1
/*J045*  in_mrp when available in_mstr @ pt_mrp  */
/*J045*  pt_mrp when not available in_mstr       */
/*J045*/ in_mrp when (available in_mstr) @ pt_mrp
/*J045*/ pt_mrp when (not available in_mstr)
      ptp_ord_per @ pt_ord_per
      ptp_ord_max @ pt_ord_max
      ptp_ms @ pt_ms
      ptp_buyer @ pt_buyer
      ptp_plan_ord @ pt_plan_ord
      ptp_phantom @ pt_phantom
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
      wkctr1 label "首工序"
      wkctr2 label "尾工序"
      with frame bb STREAM-IO /*GUI*/ .
   else

      display
      pt_part
      si_site
      pt_um
      pt_ord_pol
      pt_ord_min
      pt_desc1 + " " + pt_desc2 @ pt_desc1
      pt_ms
/*J045*  in_mrp when available in_mstr @ pt_mrp */
/*J045*  pt_mrp when not available in_mstr      */
/*J045*/ in_mrp when (available in_mstr) @ pt_mrp
/*J045*/ pt_mrp when (not available in_mstr)
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
      pt_phantom
      pt_sfty_time
      pt_pur_lead
      pt_buyer
      pt_insp_rqd
      pt_insp_lead
      pt_timefence
      pt_cum_lead
      wkctr1 label "首工序"
      wkctr2 label "尾工序"
      with frame bb STREAM-IO /*GUI*/ .

   /* READ EACH SUPPLY / DEMAND RECORD IN DATE DUE SEQUENCE */
   hide message no-pause.
   recpt = 0.
   ord = 0.
   gross = 0.
   qoh = qty_oh.
   begin_avail = yes.   
   

/*J23R** /*F024*/ {fcsdate.i today fcsduedate week si_site} */
/*J23R*/ run proc-fcs (input-output fcsduedate, input-output week,
/*J23R*/           input si_site).

/*FQ67*   fcsduedate = fcsduedate - 7 * back. */
/*FQ67*/  fcsduedate = fcsduedate - 7 * bck.

/*J23R**  {mfdel.i "fsworkfile"} */
/*J23R*/ run proc-del.

     if can-find (first fcs_sum where fcs_domain = global_domain and fcs_part = pt_part
     and fcs_site = si_site)
     or can-find (first mrp_det where mrp_domain = global_domain and mrp_dataset = "fcs_sum"
     and mrp_part = pt_part) then do:
        fcspart = pt_part.
        fcssite = si_site.
        {gprun.i ""msfsre.p""}
     end.
/*J045*  find first fsworkfile no-error. */
/*J045*/ find first fsworkfile exclusive-lock no-error.

     find first mrp_det no-lock where mrp_domain = global_domain and mrp_part = part
     and mrp_site = site
     use-index mrp_site_due no-error.
     repeat:
        if not available mrp_det
        or mrp_dataset <> "fcs_sum" then leave.
        find next mrp_det no-lock where mrp_domain = global_domain and mrp_part = part
        and mrp_site = si_site
        use-index mrp_site_due no-error.
     end.

     repeat with frame c:

     FORM /*GUI*/ 
        due_date
        gross
        recpt
        qoh
        ord
        detail
     with STREAM-IO /*GUI*/  frame c no-attr-space width 100.
			setframelabels(frame c:handle).
     recpt = 0.
     ord = 0.
     gross = 0.


     if not available(mrp_det) and not available(fsworkfile) then do:
        if begin_avail then do with frame c:
           if start > today then display start @ due_date WITH STREAM-IO /*GUI*/ .
           else display today @ due_date WITH STREAM-IO /*GUI*/ .
           display qoh {&mrmpiq01_p_13} @ detail with frame c STREAM-IO /*GUI*/ .
/*G0WF*/       if qoh <> round(qoh,0)
          then display qoh format "->>>>,>>>.<<<<<<<" @ qoh WITH STREAM-IO /*GUI*/ .
           down 1.
           begin_avail = no.
        end.
        leave.
     end.

     if begin_avail
     and ((available mrp_det and mrp_due_date >= start)
     or (available fsworkfile and fsdate >= start))
     then do with frame c:
        if qoh <> qty_oh or start > today then display start @ due_date WITH STREAM-IO /*GUI*/ .
        display qoh {&mrmpiq01_p_13} @ detail with frame c STREAM-IO /*GUI*/ .
/*G0WF*/    if qoh <> round(qoh,0)
           then display qoh format "->>>>,>>>.<<<<<<<" @ qoh WITH STREAM-IO /*GUI*/ .
        down 1.
        begin_avail = no.
     end.

     if available(mrp_det)
     and (not available(fsworkfile) or mrp_due_date < fsdate)
     then do:

        due_date = mrp_due_date.
        detail = mrp_detail.
        detail1 = "".
        detail2 = "".
        detail3 = "".
        if index(mrp_type,"demand") > 0 then do:
           if mrp_dataset <> "fc_det" then do:
          /*do not include seasonal build*/
          gross = mrp_qty.
          qoh = qoh - mrp_qty.
           end.

           if mrp_dataset = "pfc_det" then
          detail = {&mrmpiq01_p_5} + " " + mrp_nbr.
           else
           if mrp_dataset = "sod_det" then
          detail = {&mrmpiq01_p_24} + " " + string(mrp_nbr,"x(8)")
          + " " + {&mrmpiq01_p_17} + " " + string(mrp_line).
/*F312 ADDED FOLLOWING SECTION*/
           else
           if mrp_dataset = "cs sch_mstr" then
          detail = {&mrmpiq01_p_10} + " " + string(mrp_nbr,"x(8)")
/*G1BJ*           + " " + "Line:" + " " + string(mrp_line). */
/*G1BJ*/          + " " + {&mrmpiq01_p_17} + string(mrp_line).
/*F312 END SECTION*/
           else
           if mrp_dataset = "ds_det" then
          detail = "I/S:" + " " + string(mrp_nbr,"x(8)")
          + " " + {&mrmpiq01_p_26} + " " + string(mrp_line2).
           else
           if mrp_dataset = "sob_det" then do:
          detail = {&mrmpiq01_p_4} + " " + string(mrp_nbr,"x(8)").
          detail1 = {&mrmpiq01_p_17} + " " + mrp_line.
           end.
/*J014*/       else
/*J014*/       if mrp_dataset = "jp_det" then do:
/*J045*  /*J014*/ detail = "Co-product: " +  string(mrp_detail,"x(18)"). */
/*J045*/          detail = {&mrmpiq01_p_7} +  string(mrp_nbr,"x(18)").
/*J014*/       end.
           else
           if mrp_dataset = "pb_sold"
/*F816*/       or mrp_dataset = "pbo_sold"
           then do:

/*F816*/          if mrp_dataset = "pb_sold" then do:
             find sod_det where sod_domain = global_domain and sod_nbr = mrp_nbr
             and sod_line = integer(mrp_line) no-lock no-error.
             if available sod_det then
             detail = detail + ":" + " " + sod_part.
/*F816*/          end.

/*F816*/          if mrp_dataset = "pbo_sold" then
/*F816*/             detail = {&mrmpiq01_p_14} + " " + mrp_line2.

          detail1 = {&mrmpiq01_p_24} + " " + string(mrp_nbr,"x(8)")
             + " " + {&mrmpiq01_p_20} + " " + mrp_line.
           end.
           else
           if mrp_dataset = "wod_det" then do:
          detail = {&mrmpiq01_p_27} + " " + mrp_nbr.
          if length(detail)
                + length("  " + {&mrmpiq01_p_9} + " " + mrp_line) <= 25
          then detail = detail + "  " + {&mrmpiq01_p_9} + " " + mrp_line.
          else detail =           " " + {&mrmpiq01_p_9} + " " + mrp_line.
          find wo_mstr where wo_domain = global_domain and wo_lot = mrp_line
          and wo_nbr = mrp_nbr no-lock no-error.
          if available wo_mstr then do:
             find pt_mstr where pt_domain = global_domain and pt_part = wo_part.
             if available pt_mstr then ptdesc = pt_desc1 + " " + pt_desc2.
             else ptdesc = "".
             if detail1 = ""
             then do:
                  detail1 = {&mrmpiq01_p_1} + " " + wo_part.
                  detail2 = {&mrmpiq01_p_28} + " " + ptdesc.
                  end.
             else do:
                  detail2 = {&mrmpiq01_p_1} + " " + wo_part. 
                  detail3 = {&mrmpiq01_p_28} + " " + ptdesc.
                  end.
             end.
           end.
           else
           if mrp_dataset = "wo_scrap" then do:
          detail = {&mrmpiq01_p_27} + " " + mrp_nbr
             + "  " + {&mrmpiq01_p_9} + " " + mrp_line.
          if length(detail) > 25 then do:
             detail = {&mrmpiq01_p_27} + " " + mrp_nbr.
             detail1 = " " + {&mrmpiq01_p_9} + " " + mrp_line.
          end.
          if detail1 = ""
          then detail1 = {&mrmpiq01_p_19}.
          else detail2 = {&mrmpiq01_p_19}.
           end.
           else
           if mrp_dataset = "fc_det" then do:
          /*seasonal build demand*/
          find fc_det where fc_domain = global_domain and fc_part = mrp_part
/*GE37*/          and fc_site = mrp_site
          and fc_start = mrp_due_date no-lock no-error.
          if available fc_det then
             detail = detail + " " + string(fc_qty).
          end.
       end.
       else do:
          if mrp_dataset = "wo_mstr" then do:
         detail = {&mrmpiq01_p_27} + " " + mrp_nbr
            + "  " + {&mrmpiq01_p_9} + " " + mrp_line.
         if length(detail) > 25 then do:
            detail = {&mrmpiq01_p_27} + " " + mrp_nbr.
            detail1 = " " + {&mrmpiq01_p_9} + " " + mrp_line.
         end.
          end.
          if mrp_dataset = "pod_det" then
         detail = {&mrmpiq01_p_16} + " " + string(mrp_nbr,"x(8)")
         + " " + {&mrmpiq01_p_17} + " " + string(mrp_line).
          if mrp_dataset = "req_det" then
         detail = {&mrmpiq01_p_22} + " " + mrp_nbr.

          if mrp_dataset = "sod_fas" then do:
         detail1 = {&mrmpiq01_p_24} + " " + string(mrp_nbr,"x(8)")
         + " " + {&mrmpiq01_p_17} + " " + string(mrp_line,"x(8)").
          end.

/*F816*/      if mrp_dataset = "dsd_det" then do:
/*F816*/         detail = "I/S:" + " " + mrp_nbr
/*F816*/         + " " + {&mrmpiq01_p_26} + " " + mrp_line2.
/*F816*/         if length(detail) > 25 then do:
/*F816*/            detail = "I/S:" + " " + mrp_nbr.
/*F816*/            detail1 = " " + {&mrmpiq01_p_26} + " " + mrp_line2.
/*F816*/         end.
/*F816*/         find dsd_det no-lock where dsd_domain = global_domain and dsd_req_nbr = mrp_nbr
/*F816*/         and dsd_site = mrp_line and dsd_shipsite = mrp_line2 no-error.
/*F816*/         if available dsd_det and dsd_nbr <> "" then do:
/*F816*/            if detail1 <> ""
/*F816*/            and length(detail1) + length(dsd_nbr) + 6 <= 25
/*F816*/            then detail1 = detail1 + " "+ {&mrmpiq01_p_3} + " " + dsd_nbr.
/*F816*/            else if detail1 = ""
/*F816*/            then detail1 = "     " + {&mrmpiq01_p_3} + " " + dsd_nbr.
/*F816*/            else detail2 = "     " + {&mrmpiq01_p_3} + " " + dsd_nbr.
/*F816*/         end.
/*F816*/      end.

/*FQ92*/  /* deleted space following "Line:" */
/*F312 ADDED FOLLOWING SECTION*/
          if mrp_dataset = "ss sch_mstr" then
         detail = {&mrmpiq01_p_21} + " " + string(mrp_nbr,"x(8)")
         + " " + {&mrmpiq01_p_17} + "" + string(mrp_line).
/*F312 END SECTION*/

          if index(mrp_type,"supplyp") > 0
          or index(mrp_type,"supplyf") > 0
          then do:
         if mrp_rel_date <> ? then
         do:
            if detail1 = ""
            then
            detail1 = {&mrmpiq01_p_25} + " " + string(mrp_rel_date).
            else
            detail2 = {&mrmpiq01_p_25} + " " + string(mrp_rel_date).
         end.
         ord = mrp_qty.
          end.
          else recpt = mrp_qty.
          qoh = qoh + mrp_qty.
       end.

       repeat:
          find next mrp_det no-lock where mrp_domain = global_domain and mrp_part = part
          and mrp_site = site
          use-index mrp_site_due no-error.
          if not available mrp_det
          or mrp_dataset <> "fcs_sum" then leave.
       end.
    end.
    else if available(fsworkfile)
     and (not available(mrp_det) or (mrp_due_date >= fsdate
     or mrp_due_date = ?))
    then do:
       gross = fsqty.
       qoh = qoh - fsqty.
       due_date = fsdate.
       detail = {&mrmpiq01_p_15}.
       detail1 = "".
       detail2 = "".
       detail3 = "".
/*J045*    find next fsworkfile no-error. */
/*J045*/   find next fsworkfile exclusive-lock no-error.
    end.

      if due_date < start then next.

      if ((frame-down <> 0 and frame-down = frame-line)
      or (page-size <> 0 and page-size - line-counter < 1)) and detail1 > ""
      then down 1.

      if ((frame-down <> 0 and frame-down = frame-line + 1)
      or (page-size <> 0 and page-size - line-counter < 2))
      and detail1 > "" and detail2 > "" then down 2.

      display due_date gross recpt qoh ord detail with frame c STREAM-IO /*GUI*/ .

      if gross <> round(gross,0)
     then display gross format "->>>>,>>>.<<<<<<<" @ gross WITH STREAM-IO /*GUI*/ .
      if recpt <> round(recpt,0)
     then display recpt format "->>>>,>>>.<<<<<<<" @ recpt WITH STREAM-IO /*GUI*/ .
      if qoh   <> round(qoh  ,0)
     then display qoh   format "->>>>,>>>.<<<<<<<" @ qoh WITH STREAM-IO /*GUI*/ .
      if ord   <> round(ord  ,0)
     then display ord   format "->>>>,>>>.<<<<<<<" @ ord WITH STREAM-IO /*GUI*/ .

      if detail1 > "" then down 1.
      if detail1 > "" then display detail1 @ detail WITH STREAM-IO /*GUI*/ .
      if detail2 > "" then down 1.
      if detail2 > "" then display detail2 @ detail WITH STREAM-IO /*GUI*/ .
      if detail3 > "" then down 1.
      if detail3 > "" then display detail3 @ detail with stream-io /*wl*/.
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
   end.

   {mfmsg.i 8 1}
   hide frame c.
   hide frame bb.

   hide message no-pause.
   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


   global_part = part.
   global_site = site.
end.

/*K10G*/ {wbrp04.i &frame-spec = a}

/*J23R*/ procedure proc-fcs:
/*J23R*/    define input-output parameter fcsduedate as date.
/*J23R*/    define input-output parameter week as integer.
/*J23R*/    define input parameter si_site like si_site.
/*J23R*/    {fcsdate.i today fcsduedate week si_site}
/*J23R*/ end. /* procedure proc-fcs */

/*J23R*/ procedure proc-del:
/*J23R*/    {mfdel.i "fsworkfile"}
/*J23R*/ end. /* procedure proc-del */
