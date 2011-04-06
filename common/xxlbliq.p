/* mgmsgiq.p - MESSAGE INQUIRY                                               */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

/* DISPLAY TITLE */
{mfdtitle.i "09Y1"}
define variable lang   like lbl_lang.
define variable lblterm  like lbl_term format "x(16)".
define variable cdref  as   character format "x(12)".
define variable dcount as   integer.
/* DISPLAY TITLE */

form
   space(1)
   lang format "x(4)"
   lblterm colon 24
   cdref
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

lang = global_user_lang.

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update lang lblterm cdref with frame a.

   {wbrp06.i &command = update &fields = " lang lblterm cdref" &frm = "a"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
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

   dcount = 0.

   for each lbl_mstr where
            lbl_lang = lang and
            lbl_term >= lblterm and (index(lbl_long,cdref) > 0 or cdref = "")
   no-lock with frame b:

      {mfrpchk.i}

      setFrameLabels(frame b:handle). /* SET EXTERNAL LABELS */

      display lbl_term lbl_long lbl_medium lbl_short
      with width 140 stream-io.

      dcount = dcount + 1.

      if dev <> "terminal" and dev <> "page" and dev<> "printer"
         and dcount modulo 5 = 0 then
         put skip(1).

   end.

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
