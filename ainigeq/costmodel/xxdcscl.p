/* xxdcscl.p -  成本冻结(F)/解冻(U)                                          */

/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}
{xxdcspub.i}
define variable prid    as character format "x(8)" no-undo.
define variable date1   as date    no-undo.
define variable date2   as date    no-undo.
define variable frz_flag like mfc_logical initial no
                         label  "Freeze/Unfreeze"
                         format "Freeze/Unfreeze" no-undo.
define variable xxdchdesc as character no-undo.

form
   prid     colon 16 validate (can-find (first xxpoc_mstr where
   			    xxpoc_period = prid) ,"请输入正确的期间")
   frz_flag colon 46
   date1    colon 16
   date2    colon 46
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}
ON LEAVE OF prid IN FRAME a
DO:
  ASSIGN prid.
  RUN getPeriodDate(INPUT prid,OUTPUT date1,OUTPUT date2).
  if date1 <> ? and date2 <>? then
  DISPLAY date1 date2 WITH FRAME a.
END.

{wbrp01.i}
repeat:

   if c-application-mode <> 'web' then
      update prid frz_flag with frame a.
   if frz_flag then do:
      run setdcics(input prid,input 1).
   end.
   else do:
      run setdcics(input prid,input 0).
   end.
   {wbrp06.i &command = update &fields = " prid frz_flag " &frm = "a"}

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
/**
   FOR EACH pt_mstr NO-LOCK,EACH xxdch_hst NO-LOCK
            WHERE xxdch_period = prid AND xxdch_part = pt_part
       with frame b width 320 no-attr-space:
/*       SET EXTERNAL LABELS              */
        setFrameLabels(frame b:handle).
    {mfrpchk.i}
    find first code_mstr no-lock where code_fldname = "xxdcs_element"
           and code_value = xxdch_type no-error.
    display xxdch_period
            xxdch_type
            code_cmmt format "x(12)"
            xxdch_part
            xxdch_qty_rct
            xxdch_qty_iss
            xxdch_qty_loc
            xxdch_qty_chg
            xxdch_cost
            xxdch_cost_chg
            xxdch_cost_loc
            WITH width 320 STREAM-IO.
   END.
***/
   FOR EACH xxdch_hst NO-LOCK WHERE xxdch_period = prid
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
