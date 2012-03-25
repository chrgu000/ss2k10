/* xxmgstrp.p - system status report                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 9.1  LAST MODIFIED: 09/25/00   BY: *N0W9* Mudit Mehta            */
/******************************************************************************/

{mfdtitle.i "23YQ"}
{gplabel.i}
{xxecdc.i}

define variable loc_phys_addr as character format "x(20)".
define variable dt as date initial today.
define variable trtime as integer.
define variable apr_date_form as character.
define variable mfvers as character format "x(76)".
assign loc_phys_addr = trim(getTermLabel("SHOW_SYSTEM_TABLES",12)) +
             trim(getTermLabel("REPORT",12)).

form
   loc_phys_addr no-label colon 10
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).
display loc_phys_addr with frame a.

{wbrp01.i}
repeat:

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
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

if dev <> "terminal" then do:
        {mfphead2.i}
    end.
    assign trtime = time
           loc_phys_addr = getMac().
    display global_userid loc_phys_addr dt
            string(time,"hh:mm:ss") @ trtime
            session:date-format @ apr_date_form
            with frame b width 80.
    setFrameLabels(frame b:handle).        
    do trtime = 1 to 5 with frame c down:
       {gprun.i ""gpgetver.p"" "(input trtime,output mfvers)"} 
       if trtime = 1 then do:
       		display PROVERSION @ mfvers with frame c.
       		setFrameLabels(frame c:handle).
       		down with frame c.
       end.
       display mfvers .
    end.
    
    for each ad_mstr no-lock where 
    			     ad_addr = "~~screens" with frame d width 80.
    		display  {xxaddom0.i} ad_name format "x(40)" with frame d.
    		setFrameLabels(frame d:handle). 
    end.

      
  if dev <> "terminal" then do:
   {mftrl080.i}
  end.
  else do:
  {mfreset.i}
  end.
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
