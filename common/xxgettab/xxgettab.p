/* xxgettab.p - getTable Fileds and index                                    */
/* REVISION: 0CYH LAST MODIFIED: 12/17/10   BY: zy                           */
/* REVISION: 0CYH LAST MODIFIED: 05/26/11   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "15YP"}

define variable db_name as character format "x(24)".
define variable db_hold as character format "x(24)".
define variable sfile   as character format "x(32)".

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

find first qaddb.qad_wkfl exclusive-lock where qad_domain = global_domain
       and qad_key1 = "xxgettable" and qad_key2 = global_userid no-error.
if available qad_wkfl then do:
   assign qad_charfld[1] = ""
          qad_charfld[2] = "".
end.

ON VALUE-CHANGED OF sfile IN FRAME a
DO:
   assign db_name sfile.
   find first qaddb.qad_wkfl exclusive-lock where qad_domain = global_domain
          and qad_key1 = "xxgettable" and qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
      assign qad_charfld[1] = db_name
             qad_charfld[2] = sfile.
   end.
   else do:
     create qad_wkfl.
     assign qad_domain = global_domain
            qad_key1 = "xxgettable"
            qad_key2 = global_userid
            qad_charfld[1] = db_name
            qad_charfld[2] = sfile.
   end.
END.
setFrameLabels(frame a:handle).

{wbrp01.i}
assign
   db_name = sdbname("qaddb") when db_name = ""
   db_hold = sdbname("qaddb").
repeat:
if c-application-mode <> 'web' then.
   update sfile db_name with frame a.
   assign db_name sfile.
   find first qaddb.qad_wkfl exclusive-lock where qad_domain = global_domain
          and qad_key1 = "xxgettable" and qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
      assign qad_charfld[1] = db_name
             qad_charfld[2] = sfile.
   end.
   else do:
     create qad_wkfl.
     assign qad_domain = global_domain
            qad_key1 = "xxgettable"
            qad_key2 = global_userid
            qad_charfld[1] = db_name
            qad_charfld[2] = sfile.
   end.
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
create alias dictdb for database value(db_name).
  {xxgettabd.i dictdb sfile}
create alias dictdb for database value(db_hold).
   {mftrl080.i}
end.
{wbrp04.i &frame-spec = a}
