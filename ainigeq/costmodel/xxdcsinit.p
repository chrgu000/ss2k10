/* xxptsimin.p - cim_load part sim cost set                                  */

/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}
{xxdcspub.i}
{xxicld01.i}
/* /* CONSIGNMENT INVENTORY VARIABLES */ */
{pocnvars.i}

DEFINE VARIABLE period      LIKE xxdcs_period NO-UNDO.
DEFINE VARIABLE lperiod   as   character    no-undo.
DEFINE VARIABLE datef     AS   date         NO-UNDO.
DEFINE VARIABLE datet     AS   date         NO-UNDO.
DEFINE VARIABLE fname     AS   CHARACTER format "x(40)"  NO-UNDO label "文件".
define variable xxdchdesc as character no-undo.
define variable vstat     as   character format "x(40)" column-label "备注".

define temp-table tmpc
fields tmpc_part like pt_part
fields tmpc_qty  like ld_qty_oh
fields tmpc_mtl  as   decimal column-label "燃料动力"
fields tmpc_lbr  as   decimal column-label "人工费用"
fields tmpc_bdn  as   decimal column-label "制造费用"
fields tmpc_ovh  as   decimal column-label "盘点差异"
fields tmpc_sub  as   decimal column-label "采购差异".

form
   period  colon 20 label "期间"
   datef colon 20 label "日期"
   datet colon 50 label "至" SKIP(1)
   fname colon 20 LABEL "文件" skip(1)
   "文件格式：(以逗号隔开的文本文件)" colon 10 skip
   "料号,期初库存,燃料动力,人工费用,制造费用,盘点差异,采购差异" colon 10 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
/* setFrameLabels(frame a:handle). */

ON LEAVE OF period IN FRAME a
DO:
  ASSIGN period.
  lperiod = getPrePeriod(period).
  RUN getPeriodDate(INPUT period,OUTPUT datef,OUTPUT datet).
  DISPLAY datef datet WITH FRAME a.
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

/*    if period = hi_char then site1 = "". */

   if c-application-mode <> 'web' then
      UPDATE period fname with frame a.
      run getPeriodDate(input period,output datef,output datet).
      display datef datet with fram a.
     if search(fname) = ? or search(fname) = "" THEN DO:
         {pxmsg.i &MSGTEXT=""输入文件未找到"" &ERRORLEVEL=3}
         undo,retry.
     END.

empty temp-table tmpc.
input from value(fname).
repeat:
create tmpc.
import delimiter ","
                    tmpc_part
                    tmpc_qty
                    tmpc_mtl
                    tmpc_lbr
                    tmpc_bdn
                    tmpc_ovh
                    tmpc_sub
        no-error.
end.
input close.

for each tmpc no-lock where tmpc_part >= "0" and tmpc_part <= "ZZZZZ":
  find first xxdcl_hst exclusive-lock where xxdcl_period = lperiod
           and xxdcl_part = tmpc_part no-error.
  if not avail xxdcl_hst then do:
      create xxdcl_hst.
      assign xxdcl_part   = tmpc_part
             xxdcl_period = lperiod
             xxdcl_qty    = tmpc_qty.
  end.
  if available pt_mstr then do:
      find first xxdch_hst no-lock where xxdch_period = period
             and xxdch_type = "material" and xxdch_part = tmpc_part.
      if available xxdch_hst then do:
         assign xxdch_cost = tmpc_mtl.
      end.
      else do:
         create xxdch_hst.
         assign xxdch_period = period
                xxdch_type   = "material"
                xxdch_part   = tmpc_part
                xxdch_cost   = tmpc_mtl.
      end.
      find first xxdch_hst no-lock where xxdch_period = period
             and xxdch_type = "labor" and xxdch_part = tmpc_part.
      if available xxdch_hst then do:
         assign xxdch_cost = tmpc_lbr.
      end.
      else do:
         create xxdch_hst.
         assign xxdch_period = period
                xxdch_type   = "labor"
                xxdch_part   = tmpc_part
                xxdch_cost   = tmpc_lbr.
      end.
      find first xxdch_hst no-lock where xxdch_period = period
             and xxdch_type = "burden" and xxdch_part = tmpc_part.
      if available xxdch_hst then do:
         assign xxdch_cost = tmpc_bdn.
      end.
      else do:
         create xxdch_hst.
         assign xxdch_period = period
                xxdch_type   = "burden"
                xxdch_part   = tmpc_part
                xxdch_cost   = tmpc_bdn.
      end.
      find first xxdch_hst no-lock where xxdch_period = period
             and xxdch_type = "overhead" and xxdch_part = tmpc_part.
      if available xxdch_hst then do:
         assign xxdch_cost = tmpc_ovh.
      end.
      else do:
         create xxdch_hst.
         assign xxdch_period = period
                xxdch_type   = "overhead"
                xxdch_part   = tmpc_part
                xxdch_cost   = tmpc_ovh.
      end.
      find first xxdch_hst no-lock where xxdch_period = period
             and xxdch_type = "subcontr" and xxdch_part = tmpc_part.
      if available xxdch_hst then do:
         assign xxdch_cost = tmpc_sub.
      end.
      else do:
         create xxdch_hst.
         assign xxdch_period = period
                xxdch_type   = "subcontr"
                xxdch_part   = tmpc_part
                xxdch_cost   = tmpc_sub.
      end.
  end.
end.
   {wbrp06.i &command = update
             &fields = " period datef datet fname "
             &frm = "a"}

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
