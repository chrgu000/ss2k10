
/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}
{xxdcspub.i}

define variable period  as character format "x(8)" no-undo.
define variable date1 as date no-undo.
define variable date2 as date no-undo.
define variable vicstat as logical no-undo.
define variable vdcstat as logical no-undo.
define variable iLayer  as integer no-undo.
DEFINE VARIABLE lperiod AS CHARACTER NO-UNDO. /* 上一期间 */
define variable lastPeriodQty  as decimal no-undo. /*上期库存*/
define variable currperiodqty  as decimal no-undo.
define variable lpovhcost like sct_cst_tot no-undo.
define variable lpsubcost like sct_cst_tot no-undo.
define variable lpbdncost like sct_cst_tot no-undo.
define variable lplbrcost like sct_cst_tot no-undo.
define variable lpmtlcost like sct_cst_tot no-undo.
define variable currperiodcost like sct_cst_tot no-undo.
define variable tagqty  like tr_qty_loc no-undo.
define variable sctmtl  like sct_mtl_tl no-undo.
define variable ftjshj  as decimal no-undo. /*分摊基数合计*/
define variable ovhcst  as decimal no-undo. /*父件盘点差异成本*/
define variable subcst  as decimal no-undo. /*父件采购价差成本*/
define variable mtlcst  as decimal no-undo.
define variable lbrcst  as decimal no-undo.
define variable bdncst  as decimal no-undo.
define variable xxdchdesc as character no-undo.
define variable vrun    like ro_run no-undo.
form
   period  colon 25 validate (can-find (first xxpoc_mstr where
                  xxpoc_period = period) ,"请输入正确的期间")
   date1 colon 25
   date2 colon 42
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

ON LEAVE OF period IN FRAME a
DO:
  ASSIGN period.
  lperiod = getPrePeriod(period).
  RUN getPeriodDate(INPUT period,OUTPUT date1,OUTPUT date2).
  DISPLAY date1 date2 WITH FRAME a.
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

   if c-application-mode <> 'web' then
      update period with frame a.
      RUN getglcstat(INPUT period,OUTPUT vicstat,OUTPUT vdcstat).
      if vicstat = no then do:
          {pxmsg.i &MSGTEXT=""此期间总账未关闭"" &ERRORLEVEL=3}
          undo,retry.
      end.
      if vdcstat = yes then do:
          {pxmsg.i &MSGTEXT=""此期间零件成本已冻结"" &ERRORLEVEL=3}
          undo,retry.
      end.
   {wbrp06.i &command = update &fields = " period" &frm = "a"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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
assign ilayer= 0.
for each xxdcq_hst no-lock where xxdcq_period = period:
  if ilayer < xxdcq_layer then assign ilayer = xxdcq_layer.
end.

/***自下往上计算自制件成本***/
do while ilayer > 0:
for each pt_mstr no-lock:
   if can-find(first xxdcq_hst use-index xxdcq_period_part_layer no-lock where xxdcq_period = period
                 and xxdcq_layer= ilayer and xxdcq_part = pt_part)
      then do:
        assign lastPeriodQty = 0 /*期初库存量*/.
        find first xxdcl_hst no-lock where xxdcl_period = lperiod and xxdcl_part = pt_part no-error.
        if available xxdcl_hst then do:
           assign lastPeriodQty = xxdcl_qty_oh.
        end.

        assign sctmtl = 0. /* 工单制造件成本 */
        find first sct_det no-lock where sct_sim = "standard" and sct_part = pt_part and sct_site = pt_site  no-error.
        if available sct_det then do:
           assign sctmtl = sct_mtl_tl + sct_mtl_ll.
        end.
        find first xxpocd_det NO-LOCK WHERE xxpocd_period = period and xxpocd_part = pt_part no-error.
        if available xxpocd_det then do:
           assign sctmtl = sctmtl + xxpocd_adiff.
        end.

        /* overhead/subcontrt采购价差  盘点差异计算 */

        assign lpovhcost = 0.
        find first xxdch_hst no-lock where xxdch_period = lperiod
               and xxdch_type = "overhead"
               and xxdch_part = pt_part no-error.
        if available xxdch_hst then do:
           assign lpovhcost = xxdch_cost.
        end. /*期初盘点差异成本*/

        assign lpsubcost = 0.
        find first xxdch_hst no-lock where xxdch_period = lperiod
               and xxdch_type = "subcontr"
               and xxdch_part = pt_part no-error.
        if available xxdch_hst then do:
           assign lpovhcost = xxdch_cost.
        end. /*期初盘点差异成本*/

        /* 本期差异额 */
/*      assign currperiodqty = 0. */
        assign ovhcst = 0
               subcst = 0.
        for each xxdcq_hst no-lock where xxdcq_period = period and xxdcq_part = pt_part:
            assign ftjshj = xxdcq_qty_rct * xxdcq_qty_per.
            for each xxdch_hst no-lock where xxdch_period = period
                   and (xxdch_type = "overhead" or xxdch_type = "subcontr")
                   and xxdch_part = xxdcq_comp:
               if xxdch_type = "overhead" then do:
                  assign ovhcst = ovhcst + xxdch_cost * ftjshj.
               end.
               else do:
                  assign subcst = subcst + xxdch_cost * ftjshj.
               end.
            end.
        end.

        /* 本期入库量 */
        assign currperiodqty = 0.
        for each xxdcq_hst no-lock where xxdcq_period = period and xxdcq_part = pt_part
            break by xxdcq_par:
            if first-of(xxdcq_par) then do:
               assign currperiodqty = currperiodqty + xxdcq_qty_rct.
            end.
        end.

        find first xxdch_hst exclusive-lock where xxdch_period = period
                   and xxdch_type = "overhead" and xxdch_part = pt_part no-error.
        if available xxdch_hst then do:
            assign xxdch_qty_loc = lastPeriodQty
                   xxdch_cost_loc = lpovhcost
                   xxdch_qty_chg = currperiodqty
                   xxdch_cost_chg = ovhcst
                   xxdch_cost = (lastperiodqty * lpovhcost + currperiodqty * ovhcst) / (lastperiodqty + currperiodqty)
                   .
        end.
        else do:
            create xxdch_hst.
            assign xxdch_period = period
                   xxdch_type = "overhead"
                   xxdch_part = pt_part
                   xxdch_qty_loc = lastPeriodQty
                   xxdch_cost_loc = lpovhcost
                   xxdch_qty_chg = currperiodqty
                   xxdch_cost_chg = ovhcst
                   xxdch_cost = (lastperiodqty * lpovhcost + currperiodqty * ovhcst) / (lastperiodqty + currperiodqty)
                   .
        end.

        find first xxdch_hst exclusive-lock where xxdch_period = period
                   and xxdch_type = "subcontr" and xxdch_part = pt_part no-error.
        if available xxdch_hst then do:
            assign xxdch_qty_loc  = lastPeriodQty
                   xxdch_cost_loc = lpsubcost
                   xxdch_qty_chg  = currperiodqty
                   xxdch_cost_chg = subcst
                   xxdch_cost = (lastperiodqty * lpsubcost + currperiodqty * subcst) / (lastperiodqty + currperiodqty)
                   .
        end.
        else do:
            create xxdch_hst.
            assign xxdch_period = period
                   xxdch_type     = "subcontr"
                   xxdch_part     = pt_part
                   xxdch_qty_loc  = lastPeriodQty
                   xxdch_cost_loc = lpsubcost
                   xxdch_qty_chg  = currperiodqty
                   xxdch_cost_chg = subcst
                   xxdch_cost = (lastperiodqty * lpsubcost + currperiodqty * subcst) / (lastperiodqty + currperiodqty)
                   .
        end.
/* overhead   盘点差异计算 */
        assign vrun = 0.
        for each ro_det no-lock where ro_routing = xxdcq_par
            and (ro_start <= today or ro_start = ?)
            and (ro_end >= today or ro_end = ?) :
            assign vrun = vrun + ro_run.
        end.
/* 费用分摊计算 */
        assign mtlcst = 0
               bdncst = 0
               lbrcst = 0.
        for each xxdcq_hst no-lock where xxdcq_period = period and xxdcq_part = pt_part:
            assign ftjshj = xxdcq_qty_rct * xxdcq_qty_per.
            for each xxdch_hst no-lock where xxdch_period = period
                   and (xxdch_type = "material" or xxdch_type = "labor" or xxdch_type = "burden")
                   and xxdch_part = xxdcq_comp:
               if xxdch_type = "material" then do:
                  assign mtlcst = mtlcst + xxdch_cost * ftjshj * vrun.
               end.
               else if xxdch_type = "burden" then do:
                  assign bdncst = bdncst + xxdch_cost * ftjshj * vrun.
               end.
               else do:
                  assign lbrcst = lbrcst + xxdch_cost * ftjshj * vrun.
               end.
            end.
        end.
/* material cost */
        assign lpsubcost = 0.
        find first xxdch_hst no-lock where xxdch_period = lperiod
               and xxdch_type = "material"
               and xxdch_part = pt_part no-error.
        if available xxdch_hst then do:
           assign lpmtlcost = xxdch_cost.
        end. /*期初盘点差异成本*/

        find first xxdch_hst exclusive-lock where xxdch_period = period
                   and xxdch_type = "material" and xxdch_part = pt_part no-error.
        if available xxdch_hst then do:
            assign xxdch_qty_loc = lastPeriodQty
                   xxdch_cost_loc = lpmtlcost
                   xxdch_qty_chg = currperiodqty
                   xxdch_cost_chg = mtlcst
                   xxdch_cost = (lastperiodqty * lpmtlcost + currperiodqty * mtlcst) / (lastperiodqty + currperiodqty)
                   .
        end.
        else do:
            create xxdch_hst.
            assign xxdch_period = period
                   xxdch_type = "material"
                   xxdch_part = pt_part
                   xxdch_qty_loc = lastPeriodQty
                   xxdch_cost_loc = lpmtlcost
                   xxdch_qty_chg = currperiodqty
                   xxdch_cost_chg = mtlcst
                   xxdch_cost = (lastperiodqty * lpmtlcost + currperiodqty * mtlcst) / (lastperiodqty + currperiodqty)
                   .
        end.
/* labor cost */
        assign lpsubcost = 0.
        find first xxdch_hst no-lock where xxdch_period = lperiod
               and xxdch_type = "labor"
               and xxdch_part = pt_part no-error.
        if available xxdch_hst then do:
           assign lplbrcost = xxdch_cost.
        end. /*期初盘点差异成本*/

        find first xxdch_hst exclusive-lock where xxdch_period = period
                   and xxdch_type = "labor" and xxdch_part = pt_part no-error.
        if available xxdch_hst then do:
            assign xxdch_qty_loc = lastPeriodQty
                   xxdch_cost_loc = lplbrcost
                   xxdch_qty_chg = currperiodqty
                   xxdch_cost_chg = lbrcst
                   xxdch_cost = (lastperiodqty * lplbrcost + currperiodqty * lbrcst) / (lastperiodqty + currperiodqty)
                   .
        end.
        else do:
            create xxdch_hst.
            assign xxdch_period = period
                   xxdch_type = "labor"
                   xxdch_part = pt_part
                   xxdch_qty_loc = lastPeriodQty
                   xxdch_cost_loc = lplbrcost
                   xxdch_qty_chg = currperiodqty
                   xxdch_cost_chg = lbrcst
                   xxdch_cost = (lastperiodqty * lplbrcost + currperiodqty * lbrcst) / (lastperiodqty + currperiodqty)
                   .
        end.
/* burden cost */
        assign lpsubcost = 0.
        find first xxdch_hst no-lock where xxdch_period = lperiod
               and xxdch_type = "burden"
               and xxdch_part = pt_part no-error.
        if available xxdch_hst then do:
           assign lpbdncost = xxdch_cost.
        end. /*期初盘点差异成本*/

        find first xxdch_hst exclusive-lock where xxdch_period = period
                   and xxdch_type = "burden" and xxdch_part = pt_part no-error.
        if available xxdch_hst then do:
            assign xxdch_qty_loc = lastPeriodQty
                   xxdch_cost_loc = lpbdncost
                   xxdch_qty_chg = currperiodqty
                   xxdch_cost_chg = bdncst
                   xxdch_cost = (lastperiodqty * lpbdncost + currperiodqty * bdncst) / (lastperiodqty + currperiodqty)
                   .
        end.
        else do:
            create xxdch_hst.
            assign xxdch_period = period
                   xxdch_type = "burden"
                   xxdch_part = pt_part
                   xxdch_qty_loc = lastPeriodQty
                   xxdch_cost_loc = lpbdncost
                   xxdch_qty_chg = currperiodqty
                   xxdch_cost_chg = bdncst
                   xxdch_cost = (lastperiodqty * lpbdncost + currperiodqty * bdncst) / (lastperiodqty + currperiodqty)
                   .
        end.
/* 费用分摊计算 */

   end. /* if can-find(first xxdcq_hst no-lock)*/
end.
ilayer = ilayer - 1.
end.

FOR EACH xxdch_hst NO-LOCK WHERE xxdch_period = period
    with frame b width 132 no-attr-space:
      /* SET EXTERNAL LABELS */
       {mfrpchk.i}
   find first code_mstr no-lock where code_fldname = "xxdcs_element"
          and code_value = xxdch_type no-error.
   if avail code_mstr then do:
      assign xxdchdesc = code_cmmt.
   end.
   else do:
      assign xxdchdesc = "".
   end.
   DISPLAY  xxdch_period xxdch_type xxdchdesc xxdch_part xxdch_qty_loc xxdch_qty_chg
            xxdch_cost_loc xxdch_cost_chg xxdch_cost
       WITH STREAM-IO 20 DOWN.
   setFrameLabels(frame b:handle).
END.
{mfrtrail.i}
end.



{wbrp04.i &frame-spec = a}
