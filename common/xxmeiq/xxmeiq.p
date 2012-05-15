/* xxmeiq.p - Menu INQUIRY                                                   */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 14Y2 LAST MODIFIED: 11/19/10   BY: zy                           */
/* REVISION: 17Y6 LAST MODIFIED: 11/19/10   BY: zy  #Add progName variable   */

{mfdtitle.i "23YT"}
&SCOPED-DEFINE xxmeiq_p_1 "cdrefUDE"

define variable lang like lng_lang.
define variable cdref as character format "x(20)" label {&xxmeiq_p_1}.
define variable dcount as integer no-undo.
define variable mndnbr like mnd_nbr.
define variable nbr1 like mnd_nbr.
define variable progName like mnd_exec.
define variable scx_qkey as character format "x(4)".
define variable abc1 as character format "x(4)".
define variable os as character format "x(8)".
define variable ver as character format "x(12)".
form
   space(1)
   lang     colon 25
   mndnbr   colon 25   nbr1 colon 50
   cdref    colon 25
   scx_qkey colon 25   abc1 colon 50
   progName colon 25
   skip(1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

lang = global_user_lang.

{wbrp01.i}
{xxchklv.i 'MODEL-CAN-RUN' 10}
repeat:

   if c-application-mode <> 'web' then
      update lang mndnbr nbr1 cdref scx_qkey abc1 progName with frame a.

   {wbrp06.i &command = update
             &fields = " lang mndnbr nbr1 cdref scx_qkey abc1 progName "
             &frm = "a"}
   assign nbr1 = nbr1 + hi_char.
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "report"
               &printWidth = 320
               &pagedFlag = "nopage"
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
            mnt_nbr >= mndnbr and (mnt_nbr <= nbr1 or nbr1 = "") and
           (index(mnt_label,cdref) > 0 or cdref = ""),
       each mnd_det no-lock where mnd_nbr = mnt_nbr and
            mnd_select = mnt_select and
           (mnd_name >= scx_qkey or scx_qkey = "") and
           (mnd_name <= abc1 or abc1 = "") and
           (index(mnd_exec,progName) > 0 or progName = "")
    with frame f-a:
      setFrameLabels(frame f-a:handle). /* SET EXTERNAL LABELS */
   find first usrw_wkfl NO-LOCK WHERE {xxusrwdomver.i} {xxand.i}
		      usrw_key1 = mnd_exec and
		     (usrw_key2 = "UNIX" or usrw_key2 = "MSDOS" or usrw_key2 = "WIN32") and 
		      usrw_charfld[15] = 'version_number'
		      no-error.
	 if available usrw_wkfl then do:
	 			assign os = usrw_key2
	 						 ver = usrw_key3.
	 end.
	 else do:
	  	  assign os = ""
	  	  	     ver = "".
	 end.
 
      display mnt_nbr + "." + trim(string(mnt_select,">>>>>9")) @ mnt_nbr
              mnt_label mnd_exec mnd_name os
              ver column-label "REV" format "x(36)"
              mnd_canrun format "x(180)"
      with width 320.

      dcount = dcount + 1.

      if dev <> "terminal" and dcount modulo 5 = 0 then
         put skip(1).
      {mfrpchk.i}
   end.

/*   {mfreset.i}   */
   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
