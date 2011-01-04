/* xxpocdrp.p - 采购价差分摊报表                                             */
/* REVISION: 9.1     LAST MODIFIED: 09/16/10   BY: *zy*                      */
/* 取消加权平均，放到xxdchrp.p里统一加权平均                                 */

/* DISPLAY TITLE */
{mfdtitle.i "100906.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}
{xxdcspub.i}
{xxicld01.i}

DEFINE VARIABLE period  AS CHARACTER NO-UNDO.
DEFINE VARIABLE date1   AS DATE      NO-UNDO.
DEFINE VARIABLE date2   AS DATE      NO-UNDO.
DEFINE VARIABLE lperiod AS CHARACTER NO-UNDO.
DEFINE VARIABLE lloc    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE rcvd    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE vicstat as logical   NO-UNDO.
DEFINE VARIABLE vdcstat as logical   NO-UNDO.
define variable prlinef like pt_prod_line no-undo.
define variable prlinet like pt_prod_line no-undo.

form
   period  COLON 25 LABEL "期间"
   date1   COLON 25 LABEL "日期"
   date2   colon 48 label "至" skip
   prlinef colon 25
   prlinet colon 48 label "至"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

ON LEAVE OF period IN FRAME a /* Fill 1 */
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

   if prlinet = hi_char then prlinet = "".

   if c-application-mode <> 'web' then
      update period prlinef prlinet  with frame a.
      RUN getglcstat(INPUT PERIOD,OUTPUT vicstat,OUTPUT vdcstat).
      if vicstat = no then do:
          {pxmsg.i &MSGTEXT=""此期间总账未关闭"" &ERRORLEVEL=3}
          undo,retry.
      end.
      if vdcstat = yes then do:
          {pxmsg.i &MSGTEXT=""此期间零件成本已冻结"" &ERRORLEVEL=3}
          undo,retry.
      end.
   {wbrp06.i &command = update
             &fields = "  period date1 date2 prlinef prlinet "
             &frm = "a"}

  if (c-application-mode <> 'web') or
     (c-application-mode = 'web' and
     (c-web-request begins 'data'))
  then do:
      if prlinet = "" then prlinet = hi_char.
  end.

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

FOR EACH pt_mstr NO-LOCK WHERE pt_prod_line >= prlinef and
         pt_prod_line <= prlinet:
    FOR EACH xxpocd_det EXCLUSIVE-LOCK WHERE xxpocd_period = period
         AND xxpocd_part = pt_part.
        DELETE xxpocd_det.
    END.

    ASSIGN lloc = 0
           rcvd = 0.
    RUN getGivenDaySto(INPUT date1,INPUT pt_part,OUTPUT lloc,OUTPUT rcvd).
    CREATE xxpocd_det.
    ASSIGN xxpocd_period  = period
           xxpocd_part    = pt_part.
    FIND FIRST xxpoc_mstr NO-LOCK WHERE xxpoc_period = lperiod AND
               xxpoc_part = pt_part NO-ERROR.
    IF AVAIL xxpoc_mstr THEN DO:
        ASSIGN xxpocd_ldiff = xxpoc_dif_amt.
    END.
    FIND FIRST xxpoc_mstr NO-LOCK WHERE xxpoc_period = period AND
               xxpoc_part = pt_part NO-ERROR.
    IF AVAIL xxpoc_mstr THEN DO:
        ASSIGN xxpocd_cdiff = xxpoc_dif_amt.
    END.
    ASSIGN xxpocd_qty_lloc = lloc
           xxpocd_rcvd     = rcvd.
end.

/*******
FOR EACH xxpocd_det EXCLUSIVE-LOCK:
    ASSIGN xxpocd_tdiff = xxpocd_cdiff + xxpocd_ldiff.
    /* 单位价差 = 价差合计 / 入库量合计 */
    ASSIGN xxpocd_adiff =
      IF xxpocd_qty_lloc + xxpocd_rcvd <> 0
      THEN (xxpocd_ldiff + xxpocd_cdiff) / (xxpocd_qty_lloc + xxpocd_rcvd)
      else 0.
END.
********/

FOR EACH xxpocd_det NO-LOCK WHERE xxpocd_period = period
    with frame b width 132 no-attr-space:
      /* SET EXTERNAL LABELS */
       {mfrpchk.i}
   DISPLAY  xxpocd_part format "x(18)" xxpocd_ldiff xxpocd_cdiff xxpocd_tdiff
            xxpocd_qty_lloc xxpocd_rcvd
            xxpocd_adiff COLUMN-LABEL "单位价差" WITH STREAM-IO 20 DOWN.
END.
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
