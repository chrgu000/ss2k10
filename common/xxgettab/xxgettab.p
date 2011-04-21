/* xxgettab.p - getTable Fileds and index                                    */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 0CYH LAST MODIFIED: 12/17/10   BY: zy                           */
/* REVISION: 0CYH LAST MODIFIED: 03/26/11   BY: zy        Add EB common   *EB*/
/* REVISION: 0CYH LAST MODIFIED: 04/24/11   BY: zy                           */
/* Environment: Progress:10.1C   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "14YF"}

define variable sesc_db as character format "x(24)".
define variable sfile   as character format "x(32)".

form
  sfile   colon 20 label "TABLE"
  sesc_db colon 20 label "DATABASE"
with frame a side-labels width 80 attr-space.

find first qaddb.flh_mstr NO-LOCK WHERE flh_field = "sfile" no-error.
if not available qaddb.flh_mstr then do:
    create qaddb.flh_mstr.
    assign flh_field = "sfile"
           flh_exec = "xxswtbl.p"
           flh_y = 7
           flh_down = 6.
end.

find first qaddb.qad_wkfl exclusive-lock where
/*EB*/     qad_domain = global_domain and
           qad_key1 = "xxgettable" and qad_key2 = global_userid no-error.
if available qad_wkfl then do:
   assign qad_charfld[1] = ""
          qad_charfld[2] = "".
end.

ON VALUE-CHANGED OF sfile IN FRAME a DO:
   assign sesc_db sfile.
   find first qaddb.qad_wkfl exclusive-lock where
/*EB*/        qad_domain = global_domain and
              qad_key1 = "xxgettable" and qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
      assign qad_charfld[1] = sesc_db
             qad_charfld[2] = sfile.
   end.
   else do:
     create qad_wkfl.
     assign
/*EB*/      qad_domain = global_domain
            qad_key1 = "xxgettable"
            qad_key2 = global_userid
            qad_charfld[1] = sesc_db
            qad_charfld[2] = sfile.
   end.
END.
setFrameLabels(frame a:handle).

{wbrp01.i}
assign
   sesc_db = sdbname("qaddb").
repeat:
if c-application-mode <> 'web' then.
   update sfile sesc_db with frame a.
   assign sesc_db sfile.
   find first qaddb.qad_wkfl exclusive-lock where
/*EB*/        qad_domain = global_domain and
              qad_key1 = "xxgettable" and qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
      assign qad_charfld[1] = sesc_db
             qad_charfld[2] = sfile.
   end.
   else do:
     create qad_wkfl.
     assign
/*EB*/      qad_domain = global_domain
            qad_key1 = "xxgettable"
            qad_key2 = global_userid
            qad_charfld[1] = sesc_db
            qad_charfld[2] = sfile.
   end.
{wbrp06.i &command = update &fields = " sfile sesc_db " &frm = "a"}
assign sesc_db sfile.
if (c-application-mode <> 'web') or
   (c-application-mode = 'web' and (c-web-request begins 'data')) then do:
end.
   /* SELECT PRINTER                */
   /*{mfselprt.i "printer" 80}      */
   /* OUTPUT DESTINATION SELECTION  */
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
create alias dictdb for database value(sesc_db).
   {xxgettabd.i dictdb sfile}
   {mftrl080.i}
end.
{wbrp04.i &frame-spec = a}
