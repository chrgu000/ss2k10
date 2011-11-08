/* xxgettab.p - getTable Fileds and index                                    */
/* REVISION: 0CYH LAST MODIFIED: 12/17/10   BY: zy                           */
/* REVISION: 0CYH LAST MODIFIED: 05/26/11   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/*V8:ConvertMode=Report                                                      */
/* REVISION END                                                              */

{mfdtitle.i "15YP"}

define variable db_name as character format "x(24)".
define variable db_hold as character format "x(24)".
define variable sfile   as character format "x(32)".
define new shared variable sdb as character.
define new shared variable stb as character.

form
   sfile   colon 20 label "TABLE"
   db_name colon 20 label "DATABASE"
with frame a side-labels width 80 attr-space.

find first qaddb.flh_mstr NO-LOCK WHERE flh_field = "sfile" no-error.
if not available qaddb.flh_mstr then do:
    create qaddb.flh_mstr.
    assign flh_field = "sfile"
           flh_exec = "xxswtbl.p"
           flh_y = 7
           flh_down = 6.
end.

assign sdb = ""
       stb = "".
on entry of sfile in frame a do:
   assign db_name sfile.
   assign sdb = db_name
          stb = sfile.
end.
ON VALUE-CHANGED OF sfile IN FRAME a
DO:
   assign db_name sfile.
   assign sdb = db_name
          stb = sfile.

END.
on leave of sfile in frame a do:
   assign db_name sfile.
   assign sdb = db_name
          stb = sfile.
end.
setFrameLabels(frame a:handle).

{wbrp01.i}
assign
   db_name = sdbname("qaddb") when db_name = ""
   db_hold = sdbname("qaddb").
repeat:
if c-application-mode <> 'web' then.
   update sfile db_name with frame a.
   if sfile = "" then do:
   	  {pxmsg.i &MSGNUM=4463 &ERRORLEVEL=3}
   	  undo,retry.
   end.
   assign db_name sfile.
   assign sdb = db_name
          stb = sfile.
{wbrp06.i &command = update &fields = " db_name sfile" &frm = "a"}

if (c-application-mode <> 'web') or
   (c-application-mode = 'web' and (c-web-request begins 'data')) then do:
end.
/* SELECT PRINTER */
/*   {mfselprt.i "printer" 80}   */
/* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "Printer"
      &printWidth = 254
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

   {mfphead2.i}
create alias dictdb for database value(sdb).
  {xxgettabd.i dictdb sfile}
create alias dictdb for database value(db_hold).
   {mftrl080.i}
end.
{wbrp04.i &frame-spec = a}
