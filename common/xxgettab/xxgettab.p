/* xxgettab.p - getTable Fileds and index                                    */
/* REVISION: 0CYH LAST MODIFIED: 12/17/10   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "0CYH"}

define variable db_name as character format "x(24)".
define variable sfile   as character format "x(32)".

form
   db_name colon 20 label "DATABASE"
   sfile   colon 20 label "TABLE"
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
   db_name = sdbname("qaddb").
repeat:
if c-application-mode <> 'web' then.
   update db_name with frame a.
   update sfile with frame a.
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
assign db_name sfile.
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
create alias dictdb for database value(db_name).
for each dictdb._File no-lock where (_FILE-NAME = sfile or sfile = ""):
    display _file-name _desc _Tbl-Type with frame x side-labels width 254.
    FOR EACH _FIELD OF _FILE BY _ORDER:
     DISPLAY _ORDER _FIELD-NAME _FORMAT _EXTENT _DATA-TYPE _INITIAL _LABEL
             _COL-LABEL _desc WITH WIDTH 254 STREAM-IO.
    END.
    FOR EACH _index WHERE _index._file-recid = RECID(_file):
      FOR EACH _index-field NO-LOCK WHERE
               _index-field._index-recid = RECID(_index)
         BREAK BY _index._file-recid:
         IF FIRST-OF(_index._file-recid) THEN
         DISPLAY _index._Index-Name
                 yes WHEN recid(_index) = _Prime-Index LABEL "Primary-idx"
                 _index._Unique _index._Idxowner   _index._Active.
         FIND FIRST _field NO-LOCK WHERE
              recid(_field) = _index-field._field-recid NO-ERROR.
         DISPLAY _index-field._Index-Seq  _field._field-name
                 _index-field._Ascending
                 WITH WIDTH 254 STREAM-IO.
      END.
 END.
end.
   {mftrl080.i}
end.
{wbrp04.i &frame-spec = a}
