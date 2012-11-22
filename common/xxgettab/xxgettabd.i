/* xxgettabd.i - gettable field detail                                       */
/*V8:ConvertMode=Report                                                      */
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
for each dictdb._File no-lock where (_FILE-NAME = {2} or {2} = ""):
    put unformat "File-Name: " _file-name "Desc: " at 30 _file._desc skip.
    put unformat "Tbl-Type: " at 2 _Tbl-Type "Forzen: " at 28 _Frozen.
    put unformat "CRC: " at 50 _CRC skip.
    if can-find(first _file-trig no-lock where _file-recid = RECID(_File))
    then do:
       put skip(1).
       put unformat "Trigger:".
       for each _file-trig no-lock where _file-recid = RECID(_File):
          display _Event _proc-name _Override _Trig-Crc.
       end.
    end.
    put skip(2).

/*  Order 5                     */
/*  Field-Name  32              */
/*  Data-Type 9                 */
/*  Format  40                  */
/*  Extent  6                   */
/*  Initial 10                  */
/*  Label 30                    */
/*  Col-label 30                */
/*  Desc  200                   */
/*  Valexp  120                 */
/*  Valmsg  72                  */

    assign i = 1.
    put unformat "Order" at i.
    assign i = i + 5 + 1.
    put unformat "Field-Name" at i.
    assign i = i + 32 + 1.
    put unformat "Data-Type" at i.
    assign i = i + 9 + 1.
    put unformat "Format" at i.
    assign i = i + 40 + 1.
    put unformat "Extent" at i.
    assign i = i + 6 + 1.
    put unformat "Initial" at i.
    assign i = i + 10 + 1.
    put unformat "Label" at i.
    assign i = i + 30 + 1.
    put unformat "Col-label" at i.
    assign i = i + 30 + 1.
    put unformat "Desc" at i.
    assign i = i + 200 + 1.
    put unformat "Valexp" at i.
    assign i = i + 120 + 1.
    put unformat "Valmsg" at i skip.

    put unformat fill("-",5) " ".
    put unformat fill("-",32) " ".
    put unformat fill("-",9) " ".
    put unformat fill("-",40) " ".
    put unformat fill("-",6) " ".
    put unformat fill("-",10) " ".
    put unformat fill("-",30) " ".
    put unformat fill("-",30) " ".
    put unformat fill("-",200) " ".
    put unformat fill("-",120) " ".
    put unformat fill("-",72) skip.

    FOR EACH _FIELD OF _FILE BY _ORDER:
        assign i = 1.
        put unformat _ORDER at i.
        assign i = i + 5 + 1.
        put unformat _FIELD-NAME at i.
        assign i = i + 32 + 1.
        put unformat _DATA-TYPE at i.
        assign i = i + 9 + 1.
        put unformat _FORMAT at i.
        assign i = i + 40 + 1.
        if _extent > 0 then put unformat _EXTENT at i.
        assign i = i + 6 + 1.
        put unformat _INITIAL at i.
        assign i = i + 10 + 1.
        put unformat _LABEL at i.
        assign i = i + 30 + 1.
        put unformat _COL-LABEL at i.
        assign i = i + 30 + 1.
        put unformat replace(_field._desc,chr(10),"") at i.
        assign i = i + 200 + 1.
        put unformat _Valexp at i.
        assign i = i + 120 + 1.
        put unformat _FIELD._Valmsg at i skip.
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
    END. /* FOR EACH _index */
end.

if genprg then do:
	 if opsys = "unix" then do:
	 		assign fname = fname + "/".
	 end.
	 else if opsys = "win" or opsys = "dos" then do:
	 		assign fname = fname + "~\".
	 end.
	 output stream eo to value(fname + "xx" + sfile + "o.p").
   put stream eo unformat 'SESSION:DATE-FORMAT = "' + dtefmt + '".' skip.
   put stream eo unformat 'OUTPUT TO "' + fname + sfile + '.d".' skip.
   put stream eo unformat 'for each ' sfile ' no-lock:' skip.
   put stream eo unformat '    EXPORT DELIMITER ","' skip.
   for each dictdb._File no-lock where (_FILE-NAME = {2} or {2} = ""):  
       FOR EACH _FIELD OF _FILE BY _ORDER:
   		     put stream eo unformat fill(' ',11) _FIELD-NAME skip.
   		 END.
   end.
   put stream eo unformat fill(' ',11) '.' skip.
   put stream eo 'END.' skip.
   output stream eo close.
   
   output stream ei to value(fname + "xx" + sfile + "i.p").
   put stream ei unformat 'SESSION:DATE-FORMAT = "' + dtefmt + '".' skip.
   put stream ei unformat 'INPUT FROM "' + fname + sfile + '.d".' skip.
   put stream ei unformat 'repeat:' skip.
   put stream ei unformat '    create ' sfile ' .' skip.
   put stream ei unformat '    IMPORT DELIMITER ","' skip.
   for each dictdb._File no-lock where (_FILE-NAME = {2} or {2} = ""):  
       FOR EACH _FIELD OF _FILE BY _ORDER:
   		     put stream ei unformat fill(' ',11) _FIELD-NAME skip.
   		 END.
   end.
   put stream ei unformat fill(' ',11) '.' skip.
   put stream ei 'END.' skip.
   output stream ei close.
end.