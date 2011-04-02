/* xxmeiq.p - Menu INQUIRY                                                   */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 14Y2 LAST MODIFIED: 11/19/10   BY: zy                           */

{mfdtitle.i "14Y2"}
&SCOPED-DEFINE xxmeiq_p_1 "INCLUDE"

define variable lang like lng_lang.
define variable incl as character format "x(20)" label {&xxmeiq_p_1}.
define variable dcount as integer no-undo.

form
   space(1)
   lang
   incl
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

lang = global_user_lang.

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update lang incl with frame a.

   {wbrp06.i &command = update &fields = " lang incl " &frm = "a"}

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

   for each mnt_det no-lock where mnt_lang = lang and
            index(mnt_label,incl) > 0,
       each mnd_det no-lock where mnd_nbr = mnt_nbr and
            mnd_select = mnt_select
    with frame f-a:

      {mfrpchk.i}

      setFrameLabels(frame f-a:handle). /* SET EXTERNAL LABELS */

      display mnt_nbr mnt_select mnt_label mnd_exec
      with width 80.

      dcount = dcount + 1.

      if dev <> "terminal" and dcount modulo 5 = 0 then
         put skip(1).

   end.

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
