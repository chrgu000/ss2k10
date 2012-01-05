/* xxcxysrp.p -   REPORT                                                      */
/*V8:ConvertMode=FullGUIReport                                                */
/* DISPLAY TITLE */
{mfdtitle.i "111130.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

define variable planDept  like usrw_wkfl.usrw_key3.
define variable planDept1 like usrw_wkfl.usrw_key3.
define variable modele    like usrw_wkfl.usrw_key4.
define variable modele1   like usrw_wkfl.usrw_key4.
define variable part      like pt_part.
define variable part1     like pt_part.
define variable line      like ln_line.
define variable line1     like ln_line.
define variable ptpart    like pt_part.

form
   planDept   colon 25
   planDept1  colon 49 label "To"
   modele     colon 25
   modele1    colon 49 label "To"
   part       colon 25
   part1      colon 49 label "To"
   line       colon 25
   line1      colon 49 label "To"

with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if planDept1 = hi_char then planDept1 = "".
   if modele1 = hi_char then modele1 = "".
   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".

   if c-application-mode <> 'web' then
      update planDept planDept1 modele modele1 part part1 line line1
             with frame a.

   {wbrp06.i &command = update
    &fields = " planDept planDept1 modele modele1 part part1 line line1"
    &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if planDept1 = "" then planDept1 = hi_char.
      if modele1 = "" then modele1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if line1 = "" then line1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 172
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

   for each usrw_wkfl no-lock
       where usrw_wkfl.usrw_domain = global_domain
         and usrw_wkfl.usrw_key1 = "SSGZTS-CX"
         and usrw_wkfl.usrw_key3 >= planDept and usrw_wkfl.usrw_key3 <= planDept1
         and usrw_wkfl.usrw_key4 >= modele and usrw_wkfl.usrw_key4 <= modele1
         and usrw_wkfl.usrw_key5 >= part and usrw_wkfl.usrw_key5 <= part1
         and usrw_wkfl.usrw_key6 >= line and usrw_wkfl.usrw_key6 <= line1
   with frame b width 172 no-attr-space:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      ptpart = "".
      FIND FIRST lnd_det WHERE lnd_domain = global_domain
                 and lnd_line = usrw_key6 and lnd_part = usrw_key5 no-error.
      if  available lnd_det then do:
          display usrw_wkfl.usrw_key3 format "x(12)"
                  usrw_wkfl.usrw_key4 format "x(24)"
                  usrw_wkf.usrw_charfld[1] format "x(40)"
                  usrw_wkf.usrw_intfld[1] format "->>9"
                  usrw_wkfl.usrw_key5 format "x(18)"
                  usrw_wkfl.usrw_key6 format "x(12)"
                  lnd_start lnd_rate.
      end.
      else do:
          display usrw_wkfl.usrw_key3 format "x(12)"
                  usrw_wkfl.usrw_key4 format "x(24)"
                  usrw_wkf.usrw_charfld[1] format "x(40)"
                  usrw_wkf.usrw_intfld[1] format "->>9"
                  usrw_wkfl.usrw_key5 format "x(18)"
                  usrw_wkfl.usrw_key6 format "x(12)".
      end.
      {mfrpchk.i}
   end.
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
