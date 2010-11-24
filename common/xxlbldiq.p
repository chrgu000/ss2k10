/* xxlbldiq.p - label detail query                                             */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

/* DISPLAY TITLE */
{mfdtitle.i "09Y1"}
define variable vterm like lbld_term.
define variable fld   like lbld_field format "x(16)".
define variable prog  like lbld_execname format "x(12)".
define variable dcount as integer.

/* DISPLAY TITLE */

form
   space(1)
   vterm colon 12
   fld   colon 12
   prog
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).



{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update vterm fld prog with frame a.

   {wbrp06.i &command = update &fields = " vterm fld prog" &frm = "a"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = "no page"
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
assign dcount = 0.
   for each lbld_det
     where (lbld_term = vterm or vterm = "")
       and (lbld_execname = prog or prog = "")
       and (lbld_fieldname = fld or fld = "")
   no-lock with frame b:

      {mfrpchk.i}

      setFrameLabels(frame b:handle). /* SET EXTERNAL LABELS */
      find first lbl_mstr no-lock where lbl_term = lbld_term
             and lbl_lang = global_user_lang no-error.
      if available lbl_mstr then do:
        display lbld_term lbld_execname format "x(24)"
                lbld_fieldname format "x(24)" lbl_long lbl_medium lbl_short
                with width 320 stream-io.
      end.
      else do:
       display lbld_term lbld_execname format "x(24)"
               lbld_fieldname format "x(24)"
               "#" @ lbl_long  "#" @  lbl_medium  "#" @  lbl_short
                with width 320 stream-io.
      end.
      dcount = dcount + 1.

      if dev <> "terminal" and dev <> "page" and dev<> "printer"
     and dcount modulo 5 = 0 then
         put skip(1).

   end.

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
