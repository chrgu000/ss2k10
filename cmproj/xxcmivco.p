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
   vsysnbrf COLON 20 LABEL "发票系统号"
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
if can-find(first xxiv_mstr no-lock where xxiv_domain = global_domain and
                  xxiv_sysnbr >= vsysnbrf and
                  xxiv_sysnbr <= vsysnbrt) then do:
output stream bf to value(vfname).
for each xxiv_mstr no-lock where xxiv_domain = global_domain and
         xxiv_sysnbr >= vsysnbrf and xxiv_sysnbr <= vsysnbrt:
  put stream bf unformat '"' xxiv_sysnbr '"' skip.
  put stream bf unformat '-' skip.
  put stream bf unformat '"' xxiv_ref '"' skip.
  put stream bf unformat '"' xxiv_bill '"' skip.
  put stream bf unformat '- F ' today " " xxiv_date " " xxiv_promise_date skip.
/*  put stream bf unformat '- ' skip. */
  put stream bf unformat '- - - - - - - "' xxiv_userid '"' skip.
  put stream bf unformat '-' skip.
  put stream bf unformat '- USA' skip. /* 税用途 */
  for each xxivd_det no-lock where xxivd_sysnbr = xxiv_sysnbr:
      put stream bf unformat '"' xxivd_sonbr '"' skip.
      put stream bf unformat '"' xxivd_rmks '" ' xxivd_confim_amt skip.
  end.
  put stream bf unformat '.' skip.
  put stream bf unformat '.' skip.
  put stream bf unformat '.' skip.
  put stream bf unformat '.' skip.
end. /** for each xxiv_mstr **/
output stream bf close.
  /******* cimindata begin *******/
    batchrun  = yes.
    input from value(vfname).
    output to value(vfname + ".out") keep-messages.
    hide message no-pause.
    {gprun.i ""ardrmt.p""}
    hide message no-pause.
    output close.
    input close.
    batchrun  = no.
  /******* cimindata end *******/
end. /**if can-find first xxiv_mstr**/

/*
os-delete value(vfname + ".out") no-error.
os-delete value(vfname) no-error.
*/

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

FOR EACH xxiv_mstr no-LOCK where xxiv_domain = global_domain and
         xxiv_sysnbr >= vsysnbrf and xxiv_sysnbr <= vsysnbrt
    with frame b width 182 no-attr-space:
  display xxiv_sysnbr xxiv_nbr xxiv_bill.
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
end.