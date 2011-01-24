/* xxgentig.i - generate tracer .i parameter file                            */
/*V8:ConvertMode=NoConvert                                                   */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 11YJ LAST MODIFIED: 01/19/11   BY: zy                           */
/* REVISION END                                                              */

/*General Trigger parameter file procedure.*/
procedure genTrig:
  define input parameter ifilename as character.
  define input parameter itab as character.
  define input parameter itype as character.
  define input parameter idomain as character.
  define input parameter key0 as character.
  define input parameter key1 as character.
  define input parameter key2 as character.
  define input parameter key3 as character.
  define input parameter key4 as character.
  define input parameter key5 as character.
  define input parameter key6 as character.
  define input parameter key7 as character.
  define input parameter key8 as character.
  define variable vbef as character.
  define variable vaft as character.
  output to value(ifilename).
       put unformat "~{mfdeclre.i~}"SKIP.
       put unformat "~{xxtrace.i~}" SKIP.
       put unformat "xxtrig:" skip.
       put unformat "do:" SKIP FILL(" ",4).
       put unformat 'if not can-find(first tcr_reg no-lock where tcr_table'.
       put unformat  ' = "' itab '"' SKIP FILL(" ",22).
    IF itype = "C" or itype = "D" THEN DO:
       put unformat 'and tcr_type = "' itype '")then leave xxtrig.' skip.
       run printdet(input itab,
              input "",
              input itype,
              input vaft,
              input vbef,
              input idomain,
              input key0,
              input key1,
              input key2,
              input key3,
              input key4,
              input key5,
              input key6,
              input key7,
              input key8
              ).
    END.
    ELSE IF itype = "W" THEN DO:
       put unformat 'and tcr_type = "W" and tcr_field <> "")' SKIP.
       put unformat fill(" ",4) 'then leave xxtrig.' skip.
       put unformat fill(" ",4).
       PUT UNFORMAT 'FOR EACH tcr_reg no-lock where tcr_table = "'.
       PUT UNFORMAT itab '" and tcr_field <> ""' skip.
       PUT UNFORMAT fill(" ",9) 'and tcr_type = "W":' SKIP.
       PUT UNFORMAT FILL(" ",9).
       PUT UNFORMAT "case tcr_field :" SKIP.
       FOR first qaddb._FILE NO-LOCK WHERE _FILE-NAME = itab:
       for each qaddb._field no-lock of qaddb._file:
           assign vaft = itab + "." + _field-name
                  vbef = 'OLD_' + itab + "." + _field-name.
           PUT UNFORMAT fill(" ",14) 'when "' _field-name '" then' SKIP.
           run printdet(input itab,
                        input _field-name,
                        input itype,
                        input vaft,
                        input vbef,
                        input idomain,
                        input key0,
                        input key1,
                        input key2,
                        input key3,
                        input key4,
                        input key5,
                        input key6,
                        input key7,
                        input key8
                        ).
       end.
       end.
       PUT UNFORMAT FILL(" ",9) 'END. /*CASE*/' SKIP.
       PUT UNFORMAT FILL(" ",4) 'END. /*for each tcr_reg*/'.
    END.
       put unformat SKIP "end." SKIP.
  output close.
end procedure.

/*print create tce_hist function.*/
procedure printDet:
  define input parameter itab as character.
  define input parameter ifield as character.
  define input parameter itype as character.
  define input parameter iaft as character.
  define input parameter ibef as character.
  DEFINE INPUT PARAMETER idomain AS CHARACTER.
  define input parameter key0 as character.
  define input parameter key1 as character.
  define input parameter key2 as character.
  define input parameter key3 as character.
  define input parameter key4 as character.
  define input parameter key5 as character.
  define input parameter key6 as character.
  define input parameter key7 as character.
  define input parameter key8 as character.
       put unformat fill(" ",14) 'run addtcehst(' skip.
       PUT UNFORMAT fill(" ",18) 'input "' itab '",' SKIP.
       if itype = "W" then
       put unformat fill(" ",18) 'input "' ifield '",' skip.
       else
       put unformat fill(" ",18) 'input "",' skip.
       put unformat fill(" ",18) 'input "' upper(itype) '",' skip.
       if itype <> "W" then assign iaft = '""' ibef = '""'.
       put unformat fill(" ",18) 'input ' iaft ',' skip.
       put unformat fill(" ",18) 'input ' ibef ',' skip.
       put unformat FILL(" ",18) 'input RECID(' itab '),' SKIP.
       put unformat FILL(" ",18) 'input ' itab '.' idomain ',' SKIP.
       IF key0 = "" THEN
           put unformat FILL(" ",18) 'input "",' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key0 '),' SKIP.
       IF key1 = "" THEN
           put unformat FILL(" ",18) 'input "",' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key1 '),' SKIP.
       IF key2 = "" THEN
           put unformat FILL(" ",18) 'input "",' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key2 '),' SKIP.
       IF key3 = "" THEN
           put unformat FILL(" ",18) 'input "",' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key3 '),' SKIP.
       IF key4 = "" THEN
           put unformat FILL(" ",18) 'input "",' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key4 '),' SKIP.
       IF key5 = "" THEN
           put unformat FILL(" ",18) 'input "",' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key5 '),' SKIP.
       IF key6 = "" THEN
           put unformat FILL(" ",18) 'input "",' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key6 '),' SKIP.
       IF key7 = "" THEN
           put unformat FILL(" ",18) 'input "",' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key7 '),' SKIP.
       IF key8 = "" THEN
           put unformat FILL(" ",18) 'input ""' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key8 ')' SKIP.
       put unformat FILL(" ",17) ').' SKIP.
end procedure.
