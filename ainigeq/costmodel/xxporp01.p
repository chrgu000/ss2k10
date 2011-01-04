/* xxporp01  rct-po record REPORT                                            */
/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}
{xxdcspub.i}
define variable period as character.
define variable datef as date.
define variable datet as date.
define variable vendf like vd_addr.
define variable vendt like vd_addr.
define variable summary like mfc_logical format "Summary/Detail"
       label "汇总(S)/明细(D)" no-undo.
DEFINE VARIABLE vicstat as logical    NO-UNDO.
DEFINE VARIABLE vdcstat as logical    NO-UNDO.
form
   period   colon 20 LABEL "期间" skip
   datef    colon 20 label "生效日"
   datet    colon 40 label "至"
   vendf    colon 20 label "供应商"
   vendt    colon 40 label "至"
   summary  colon 20 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
/* setFrameLabels(frame a:handle). */

ON LEAVE OF period IN FRAME a /* Fill 1 */
DO:
  ASSIGN period.
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
   if datef = low_date then datef = ?.
   if datet = today then datet = ?.
   if vendt = hi_char then vendt = "".
   if c-application-mode <> 'web' THEN
      UPDATE period vendf vendt summary with frame a.
      RUN getglcstat(INPUT period,OUTPUT vicstat,OUTPUT vdcstat).
      if vicstat = no then do:
          {pxmsg.i &MSGTEXT=""此期间总账未关闭"" &ERRORLEVEL=3}
          undo,retry.
      end.
      if vdcstat = yes then do:
          {pxmsg.i &MSGTEXT=""此期间零件成本已冻结"" &ERRORLEVEL=3}
          undo,retry.
      end.
   {wbrp06.i &command = update
             &fields = " period  vendf vendt summary " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      if vendf = ? then vendf = "".
      if vendt = "" then vendt = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 152
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
loopb:
   do on error undo , leave:
      if summary then do on error undo , leave loopb:
         {gprun.i ""xxporp01a.p""
                  "(input period,input datef,input datet,
                    input vendf,input vendt)" }
      end.
      else do on error undo , leave loopb:
         {gprun.i ""xxporp01b.p""
                  "(input datef,input datet,
                    input vendf,input vendt)" }
      end.
   end.
   {mfrtrail.i}
end.
{wbrp04.i &frame-spec = a}
