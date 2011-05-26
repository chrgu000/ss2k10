/* xxgettabd.i - gettable field detail                                       */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 0CYH LAST MODIFIED: 04/24/11   BY: zy        Add EB common   *EB*/
/* Environment: Progress:10.1C   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

/*****************************************************************************

get table's fields detail.
{1} Logical databas
{2} Table name

e.g.
RUN "d:\trunk\common\xxgettab.p" "pt_mstr" "CLIPBOARD".

*****************************************************************************/
if sdb = "" then do:
   create alias dictdb for database qaddb no-error.
end.
else do:
  create alias dictdb for database value(sdb) no-error.
end.
for each {1}._File no-lock where (_FILE-NAME = {2} or {2} = ""):
    display _file-name _desc _Tbl-Type _Frozen
           with frame x side-labels width 254.
    FOR EACH _FIELD OF _FILE BY _ORDER:
     DISPLAY _ORDER _FIELD-NAME _FORMAT _EXTENT _DATA-TYPE _INITIAL _LABEL
             _COL-LABEL _desc WITH WIDTH 254.
    END.
    FOR EACH _index WHERE _index._file-recid = RECID(_file):
      FOR EACH _index-field NO-LOCK WHERE
               _index-field._index-recid = RECID(_index)
         BREAK BY _index._file-recid:
         IF FIRST-OF(_index._file-recid) THEN
         DISPLAY _index._Index-Name
                 yes WHEN recid(_index) = _Prime-Index LABEL "Primary-idx"
                 _index._Unique _index._Idxowner _index._Active.
         FIND FIRST _field NO-LOCK WHERE
              recid(_field) = _index-field._field-recid NO-ERROR.
         DISPLAY _index-field._Index-Seq  _field._field-name
                 _index-field._Ascending
                 WITH WIDTH 254.
      END.
    END.
    FOR EACH _FIELD OF _FILE where
       (_FIELD._Valexp <> "" and _FIELD._Valexp <> ?) BY _ORDER:
        DISPLAY _ORDER _FIELD-NAME _FIELD._Valexp _FIELD._Valmsg
                WITH WIDTH 254.
    END.
end.
