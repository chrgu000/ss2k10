/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}
{xxdcspub.i}
define variable prid     like xxdcs_period  no-undo.
define variable elem     like xxdcs_element no-undo.
define variable eledesc  like code_cmmt     no-undo.
define variable datef    as   date          no-undo.
define variable datet    as   date          no-undo.
define variable rout     like wo_routing    no-undo.
define variable dibase   as   decimal       no-undo.
define variable codecmmt like code_cmmt     no-undo.
define variable dptdesc  like dpt_desc      no-undo.
define variable vicstat as logical          no-undo.
define variable vdcstat as logical          no-undo.
define variable prlinef like pt_prod_line no-undo.
define variable prlinet like pt_prod_line no-undo.

define buffer tdi for xxdcsd_det.

form
   prid    colon 15 label "期间"
   elem    colon 40 label "分配因素" eledesc no-label format "x(12)"
   datef   colon 15 label "日期"
   datet   colon 40 label "至"
   prlinef colon 15
   prlinet colon 40 label "至"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

ON LEAVE OF prid IN FRAME a
DO:
  ASSIGN prid.
  RUN getPeriodDate(INPUT prid,OUTPUT datef,OUTPUT datet).
  DISPLAY datef datet WITH FRAME a.
END.

ON LEAVE OF elem IN FRAME a /* Fill 1 */
DO:
  ASSIGN elem.
  find first code_mstr no-lock where code_fldname = "xxdcs_element"
         and code_value = input elem no-error.
  if avail code_mstr then do:
     display code_cmmt @ eledesc WITH FRAME a.
  end.
  else do:
    display "" @ eledesc with frame a.
  end.
END.

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

{wbrp01.i}
repeat:
   if prlinet = hi_char then prlinet = "".
   if c-application-mode <> 'web' then

   update prid elem prlinef prlinet with frame a.
   RUN getglcstat(INPUT prid,OUTPUT vicstat,OUTPUT vdcstat).
   if vicstat = no then do:
      {pxmsg.i &MSGTEXT=""此期间总账未关闭"" &ERRORLEVEL=3}
      undo,retry.
   end.
   if vdcstat = yes then do:
      {pxmsg.i &MSGTEXT=""此期间零件成本已冻结"" &ERRORLEVEL=3}
      undo,retry.
   end.
   if not can-find(first xxdcs_mstr no-lock where xxdcs_period = prid
                     and (xxdcs_element = elem or elem = "")) then do:
      {pxmsg.i &MSGTEXT=""分配期间或分配因素错误"" &ERRORLEVEL=3}
      undo,retry.
   end.
   {wbrp06.i &command = update
             &fields = " prid elem prlinef prlinet " &frm = "a"}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if prlinet = "" then prlinet = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 182
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}
for each xxdcsd_det exclusive-lock where xxdcsd_period = prid :
    delete xxdcsd_det.
end.
for each tr_hist no-lock where tr_type = "rct-wo" and tr_effdate >= datef
     and tr_effdate <= datet ,
    each pt_mstr no-lock where pt_part = tr_part and pt_prod_line >= prlinef
     and pt_prod_line <= prlinet  break by tr_lot:
     if first-of(tr_lot) then do:
        assign rout = "".
        find first wo_mstr no-lock where wo_lot = tr_lot no-error.
        if avail wo_mstr then do:
            if wo_routing <> "" then do:
              assign rout = wo_routing.
            end.
            else do:
              assign rout = wo_part.
            end.
        end. /* if find first wo_mstr */
     end. /* if first-of(tr_lot)*/
     for each ro_det no-lock where ro_routing = rout and
        (ro_start <= datef or ro_start = ?) and
        (ro_end <= datet or ro_end = ?):
        find first wc_mstr no-lock where wc_wkctr = ro_wkctr no-error.
        if avail wc_mstr then do:
            for each xxdcs_mstr no-lock where xxdcs_period = prid and
                    (xxdcs_element = elem or elem = "") and
                     wc_dept = xxdcs_dept:
                create xxdcsd_det.
                assign xxdcsd_period  = prid
                       xxdcsd_element = xxdcs_element
                       xxdcsd_dept    = xxdcs_dept
                       xxdcsd_part    = tr_part
                       xxdcsd_amt     = xxdcs_amt
                       xxdcsd_lot     = tr_lot
                       xxdcsd_op      = ro_op
                       xxdcsd_qty     = tr_qty_loc
                       xxdcsd_run     = ro_run.
            end.
        end. /* find first wc_mstr */
     end.    /* for each ro_det    */
end.         /* for each tr_hist   */

for each xxdcsd_det exclusive-lock where xxdcsd_period = prid
    break by xxdcsd_dept by xxdcsd_element by xxdcsd_part:
    if first-of(xxdcsd_part) then do:
      assign dibase = 0.
      for each tdi no-lock where
          tdi.xxdcsd_period = xxdcsd_det.xxdcsd_period and
          tdi.xxdcsd_dept = xxdcsd_det.xxdcsd_dept and
          tdi.xxdcsd_element = xxdcsd_det.xxdcsd_element and
          tdi.xxdcsd_part = xxdcsd_det.xxdcsd_part:
          assign dibase = dibase + tdi.xxdcsd_qty * tdi.xxdcsd_run.
      end.
   end.
    assign
          xxdcsd_dist_base = xxdcsd_det.xxdcsd_qty * xxdcsd_det.xxdcsd_run
          xxdcsd_dist_rate = xxdcsd_det.xxdcsd_qty * xxdcsd_det.xxdcsd_run
                           / dibase
          xxdcsd_dist_amt  = xxdcsd_det.xxdcsd_amt * xxdcsd_det.xxdcsd_qty
                           * xxdcsd_det.xxdcsd_run / dibase.
end.

for each xxdcsd_det no-lock where xxdcsd_period = prid
    break by xxdcsd_dept by xxdcsd_element by xxdcsd_part
    with frame b width 182 no-attr-space:
    if first-of(xxdcsd_element) then do:
       FIND FIRST code_mstr NO-LOCK WHERE code_fldname = "xxdcs_element"
              AND code_value = xxdcsd_det.xxdcsd_element NO-ERROR.
       if avail code_mstr then do:
          assign codecmmt = code_cmmt.
       end.
       else do:
          assign codecmmt = "".
       end.
   end.
   if first-of(xxdcsd_dept) then do:
       find first dpt_mstr no-lock where
                  dpt_dept = xxdcsd_det.xxdcsd_dept no-error.
       if avail dpt_mstr then do:
          assign dptdesc = dpt_desc.
       end.
       else do:
         assign dptdesc = "".
       end.
   end.
   display xxdcsd_det.xxdcsd_element column-label "分配因素"
           codecmmt format "x(10)"  column-label "因素说明"
           xxdcsd_det.xxdcsd_amt
                    format "->>>,>>>,>>9.9<" column-label "分配金额"
           xxdcsd_det.xxdcsd_dept    column-label "分配范围"
           dptdesc                   column-label "部门说明"
           xxdcsd_det.xxdcsd_part    column-label "零件号"
           xxdcsd_det.xxdcsd_lot     column-label "制令参考"
           xxdcsd_det.xxdcsd_op      column-label "工序"
           xxdcsd_det.xxdcsd_qty     column-label "完成数量"
           xxdcsd_det.xxdcsd_run     column-label "单位标准工时"
           xxdcsd_dist_base  format "->>>,>>>,>>9.9<" column-label "分配基数"
           xxdcsd_dist_rate  format "->>>,>>>,>>9.9<" column-label "分配比例"
           xxdcsd_dist_amt   format "->>>,>>>,>>9.9<" column-label "分配金额"
           with stream-io.
      setFrameLabels(frame b:handle).
      {mfrpchk.i}
end. /* for each xxdcsd_det no-lock */
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
