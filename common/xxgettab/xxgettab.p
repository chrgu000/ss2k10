/* xxgettab.p - getTable Fileds and index                                    */
/* REVISION: 0CYH LAST MODIFIED: 12/17/10   BY: zy                           */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdtitle.i "0CYH"}

define variable db_name as character format "x(24)".
define variable sfile as character format "x(32)".

form
   db_name colon 20 label "DATABASE"
   sfile   colon 20 label "TABLE"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
assign
   db_name = sdbname("qaddb").
repeat:
if c-application-mode <> 'web' then
   update db_name with frame a.
   update sfile with frame a.
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
/* {xxgettab.i &DataBaseName = db_name &TableName = sfile}  */
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
         DISPLAY _index._Index-Name _index._Unique
                 _index._Idxowner   _index._Active.
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
