/* xxgentig.i - generate tracer .i parameter file                            */
/*V8:ConvertMode=NoConvert                                                   */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 11YJ LAST MODIFIED: 01/19/11   BY: zy                           */
/* REVISION END                                                              */

/*General Trigger parameter file procedure.*/
procedure genTrig:
  define input parameter incmfdeclre as integer.
  define input parameter ifilename as character.
  define input parameter itab as character.
  define input parameter itype as character.
  define input parameter idomain as character.
  define input parameter ipart like pt_part.
  define input parameter isite like si_site.
  define input parameter inbr like wo_nbr.
  define input parameter key0 as character.
  define input parameter key1 as character.
  define input parameter key2 as character.
  define input parameter key3 as character.
  define input parameter key4 as character.
  define input parameter key5 as character.
  define input parameter key6 as character.
  define input parameter key7 as character.
  define input parameter key8 as character.
  define input parameter key9 as character.
  define variable vbef as character.
  define variable vaft as character.
  output to value(ifilename) append.
    put skip.
    if incmfdeclre = 0 then do: /**not found*/
       if itype = "w" then do:
          put unformat "TRIGGER PROCEDURE for write of ".
          put unformat itab " old buffer OLD_" itab "." skip.
       end.
       else if itype = "d" then do:
          put unformat "TRIGGER PROCEDURE FOR DELETE OF " itab "." skip.
       end.
    end.
    if incmfdeclre <= 1 then put unformat "~{mfdeclre.i~}"SKIP.
    if incmfdeclre = 2 then put unformat "~{xxdeclre.i~}"SKIP.
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
              input ipart,
              input isite,
              input inbr,
              input key0,
              input key1,
              input key2,
              input key3,
              input key4,
              input key5,
              input key6,
              input key7,
              input key8,
              input key9
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
                  vbef = 'old_' + itab + "." + _field-name.
           PUT UNFORMAT fill(" ",14) 'when "' _field-name '" then' SKIP.
           run printdet(input itab,
                        input _field-name,
                        input itype,
                        input vaft,
                        input vbef,
                        input idomain,
                        input ipart,
                        input isite,
                        input inbr,
                        input key0,
                        input key1,
                        input key2,
                        input key3,
                        input key4,
                        input key5,
                        input key6,
                        input key7,
                        input key8,
                        input key9
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
  define input parameter ipart like pt_part.
  define input parameter isite like si_site.
  define input parameter inbr like wo_nbr.
  define input parameter key0 as character.
  define input parameter key1 as character.
  define input parameter key2 as character.
  define input parameter key3 as character.
  define input parameter key4 as character.
  define input parameter key5 as character.
  define input parameter key6 as character.
  define input parameter key7 as character.
  define input parameter key8 as character.
  define input parameter key9 as character.
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
       if idomain = "" then
          put unformat FILL(" ",18) 'input "",' SKIP.
       else
          put unformat FILL(" ",18) 'input ' itab '.' idomain ',' SKIP.
       if ipart = "" then
          put unformat FILL(" ",18) 'input "",' SKIP.
       else
          put unformat FILL(" ",18) 'input ' itab '.' ipart ',' SKIP.
       if isite = "" then
          put unformat FILL(" ",18) 'input "",' SKIP.
       else
          put unformat FILL(" ",18) 'input ' itab '.' isite ',' SKIP.
       if inbr = "" then
          put unformat FILL(" ",18) 'input "",' SKIP.
       else
       put unformat FILL(" ",18) 'input ' itab '.' inbr ',' SKIP.
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
           put unformat FILL(" ",18) 'input "",' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key8 '),' SKIP.
       IF key9 = "" THEN
           put unformat FILL(" ",18) 'input ""' SKIP.
       ELSE
           put unformat FILL(" ",18) 'input string(' itab '.' key9 ')' SKIP.
       put unformat FILL(" ",17) ').' SKIP.
end procedure.


FUNCTION getConnCount RETURNS INTEGER( /* parameter-definitions */ ) :
/*-----------------------------------------------------------------------------
  Purpose:  Get Current connection count.
    Notes:
-----------------------------------------------------------------------------*/
    FOR EACH _connect NO-LOCK WHERE _Connect-Server > 0:
        ACCUM _connect-server(COUNT).
    END.
    return ACCUM COUNT(_connect-server).
END FUNCTION.

function getTrigname returns character(
         itabname as character, itype as character):
/*----------------------------------------------------------------------------
  Purpose:  Get Triggert Name.
    Notes:
-----------------------------------------------------------------------------*/
    define variable ret as character initial "".
    define variable vEvent as character.
    case itype:
         when "C" then assign vevent = "Create".
         when "D" then assign vevent = "Delete".
         when "W" then assign vevent = "Write".
    end case.

    for each _file no-lock where _file-name = itabname:
        find first _file-trig no-lock where _file-recid = RECID(_File)
             and _Event = vevent NO-ERROR.
        if available _file-trig then do:
           assign ret = _proc-name.
        end.
    end.
    return ret.
end function.

procedure createTrigRecord:
/*----------------------------------------------------------------------------
  Purpose: Create Trigger To _Trigger file.
    Notes: returns 10 :input parameter error must be c/w/d
                   20 :database must in
-----------------------------------------------------------------------------*/
    define input parameter itablename as character.
    define input parameter itype as character.
    define output parameter oRet as INTEGER.
    define variable vEvent as character.

    ASSIGN itype = LOWER(itype).
    assign oRet = 0.
    case itype:
         when "c" then assign vevent = "Create".
         when "d" then assign vevent = "Delete".
         when "w" then assign vevent = "Write".
         OtherWise oRet = 10.
    end case.

    if getConnCount() > 1 then do:
       assign oret = 20.
    end.

    IF getTrigname(INPUT itablename,INPUT itype) <> "" THEN DO:
       ASSIGN oret = 1.
    END.
    ELSE DO:
       if oret = 0 then do:
          for First _file exclusive-lock where _file-name = itablename:
              assign _Frozen = no.
          end.
          FOR EACH _file NO-LOCK WHERE _file-name = itablename:
              CREATE _file-trig.
              ASSIGN
                  _File-Recid = RECID(_file)
                  _Event = vevent
                  _Proc-name = ENTRY(1, _file-name, "_") + itype + ".t"
                  _Override = NO
                  _Trig-CRC = ?
                  .
          END.
          for First _file exclusive-lock where _file-name = itablename:
              assign _Frozen = yes.
          end.
       END.
     END.
end procedure.

function getSrcDir returns character():
/*----------------------------------------------------------------------------
  Purpose: get _Trigger file source dir.
    Notes:
-----------------------------------------------------------------------------*/
define variable vfile as character.
define variable vtrig as character.
define variable vsrc  as character.
define variable vfind as logical   no-undo.
   ASSIGN vfind = NO.
   assign vfile = propath.

   do while index(vfile,",") > 0:
      assign vsrc = substring(vfile,1,index(vfile,",") - 1).
      IF INDEX(vsrc,"xrc") > 0  THEN DO:
          ASSIGN vsrc = SUBSTRING(vsrc,1,LENGTH(vsrc) - 3) + "src".
          FOR EACH qaddb._file-trig no-lock where _proc-name <> "":
             IF SEARCH(vsrc + "/" + _proc-name) <> ? THEN DO:
                 ASSIGN vfind = YES.
                 LEAVE.
             END.
          END.
          IF vfind  THEN LEAVE.
      END.
      IF vfind THEN LEAVE.
      assign vfile = substring(vfile,index(vfile,",") + 1).
   end.
   IF NOT vfind THEN ASSIGN vsrc = "".
   RETURN vsrc.
end function.
