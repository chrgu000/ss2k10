/* xxcmivco - 代开发票装入                                                   */

/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

DEFINE VARIABLE vsysnbrf  AS CHARACTER format "x(12)" NO-UNDO.
DEFINE VARIABLE vsysnbrt  AS CHARACTER format "x(12)" NO-UNDO.
define variable vfname  as character no-undo.
define stream bf.
form
   vsysnbrf COLON 20 LABEL "订单编号"
   vsysnbrt colon 40 label "至"
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
{wbrp01.i}
repeat:

    if vsysnbrt = hi_char then vsysnbrt = "".

   if c-application-mode <> 'web' then
      update vsysnbrf vsysnbrt with frame a.
   {wbrp06.i &command = update &fields = " vsysnbrf vsysnbrt " &frm = "a"}

    if (c-application-mode <> 'web') or
       (c-application-mode = 'web' and  (c-web-request begins 'data'))
    then do:
       if vsysnbrt = "" then vsysnbrt = hi_char.
    end.

assign vfname = "xxiv" + string(today,"999999") + string(time) + ".cim".
/* assign vfname ="x.cim". */
if can-find(first xxar_hst no-lock where xxar_sysnbr >= vsysnbrf and
                  xxar_sysnbr <= vsysnbrt) then do:
output stream bf to value(vfname).
for each xxar_hst no-lock where xxar_sysnbr >= vsysnbrf and
         xxar_sysnbr <= vsysnbrt:
/*    put stream bf unformat "@@batchload arpamt.p" skip. */
    put stream bf unformat '"' xxar_sysnbr '"' skip.
    put stream bf unformat "-" skip.
    put stream bf unformat '"' xxar_ivnbr '"' skip.
    put stream bf unformat '"' xxar_close_cs '"' skip.
    put stream bf unformat '-' skip.
    put stream bf unformat '- ' xxar_date " " xxar_bdate skip.
    put stream bf unformat '-' skip.
    put stream bf unformat 'no' skip.
    put stream bf unformat '-' skip.
    put stream bf unformat 'U' skip.
    put stream bf unformat '-' skip.
    put stream bf unformat '-' skip.
    put stream bf unformat '-' skip.
/*    put stream bf unformat 1 skip. */
    put stream bf unformat xxar_rc_amt skip.
    put stream bf unformat xxar_rc_amt skip.
    put stream bf unformat "." skip.
    put stream bf unformat "." skip.
    put stream bf unformat "." skip.
    put stream bf unformat "." skip.
/*    put stream bf unformat "@@end" skip. */
end. /** for each xxiv_mstr **/
output stream bf close.
  /******* cimindata begin *******/
    batchrun  = yes.
    input from value(vfname).
    output to value(vfname + ".out") keep-messages.
    hide message no-pause.
    {gprun.i ""arpamt.p""}
    hide message no-pause.
    output close.
    input close.
    batchrun  = no.
  /******* cimindata end *******/
end. /**if can-find first xxiv_mstr**/

os-delete value(vfname + ".out") no-error.
os-delete value(vfname) no-error.
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamdOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

{mfphead.i}

FOR EACH xxar_hst no-LOCK where xxar_sysnbr >= vsysnbrf and
         xxar_sysnbr <= vsysnbrt
    with frame b width 182 no-attr-space:
  display xxar_sysnbr xxar_ivnbr xxar_rcnbr xxar_rc_amt.
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
end.
