DEFINE VARIABLE pfile AS CHARACTER view-as fill-in size 50 by 1
       FORMAT "X(300)" initial "/mnt/hgfs/trunk/common/xxbufcp/xxbufcopy.p"  NO-UNDO.
define variable dom as character no-undo initial "dcec".
define variable sdb as character no-undo initial "qaddb".
define variable ddb as character no-undo initial "tstdb".
define variable fle as character no-undo initial "all".
DEFINE VARIABLE outstring AS CHARACTER NO-UNDO FORMAT "X(100)".
define variable tablst as character no-undo.
define variable icnt as integer.
DEFINE STREAM bfcpcmds.

form
   dom   colon 10 label "Domain"
   sdb   colon 10 label "Logic DB"
   ddb   colon 40 label "buffer copy To"
   fle   colon 10 label "tables" skip(2)
   pfile colon 10 label "program"
with frame a side-labels width 80 attr-space.
display dom sdb ddb fle pfile with frame a.


repeat with frame a:
    update dom sdb ddb fle pfile with frame a.
    OUTPUT STREAM bfcpcmds TO value("." + pfile).
    ASSIGN outstring = "def var v_domain as char initial '" + dom + "'.".
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = 'def var msg as char format "x(60)".'.
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = "def var aaa as int.".
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = "def var bbb as int.".
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = 'def var bufcpy_log as char format "x(40)".'.
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = "def stream bf1.".
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = "bufcpy_log = 'bufcpy_log_' + v_domain + '.log'.".
    PUT STREAM bfcpcmds unformat outstring Skip(1).
    ASSIGN outstring = 'form'.
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = fill(" ",4) + 'v_domain colon 20 label "Domain"'.
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = fill(" ",4) + 'bufcpy_log colon 20 label "log-file" skip(3)'.
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = fill(" ",4) + 'msg colon 20 no-label'.
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = 'with frame a side-labels width 80 attr-space.'.
    PUT STREAM bfcpcmds unformat outstring Skip(1).
    ASSIGN outstring = 'display v_domain bufcpy_log with frame a.'.
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = 'repeat with frame a:'.
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = fill(" ",7) + 'update v_domain bufcpy_log with frame a.'.
    PUT STREAM bfcpcmds unformat outstring Skip(1).
    ASSIGN outstring = fill(" ",7) + "output stream bf1 close.".
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = fill(" ",7) + "output stream bf1 to value (bufcpy_log).".
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = fill(" ",7) + "put stream bf1 unformat 'Start: ' string(time,'HH:MM:SS') skip(1).".
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = fill(" ",7) + "output stream bf1 close.".
    PUT STREAM bfcpcmds unformat outstring Skip(1).

    assign icnt = 0.
    FOR EACH _file WHERE _file-num > 0 AND _file-num < 32768
         and can-find(first _field where _file-recid = recid(_file)
         and _field-name matches "*_domain")
         and (index(_file-name,fle) > 0  or fle = "all")
         break by _file-name:
        assign icnt = icnt + 1.
        find first _field where _file-recid = recid(_file) and _field-name matches "*_domain" no-lock no-error.
        ASSIGN outstring  = fill(" ",7) + "disable triggers for load of " + ddb + "." + _file-name + ".".
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring  = fill(" ",7) + "assign aaa = 0 bbb = 0.".
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring = fill(" ",7) + "for each " + sdb + "." + _file-name + " where " + sdb + "." + _file-name + "." + _field-name + " = v_domain:".
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring  = fill(" ",11) + "aaa = aaa + 1.".
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring = fill(" ",11) + 'msg = "copying... ' + _file-name + ':" + trim(string(aaa)).'.
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring = fill(" ",11) + 'display msg with frame a.'.
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring  = fill(" ",11) + "create " + ddb + "." + _file-name + ".".
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring  = fill(" ",11) + "buffer-copy " + sdb + "." + _file-name + " to " +  ddb + "." + _file-name + ".".
        PUT STREAM bfcpcmds unformat outstring Skip.
        assign outstring = fill(" ",7) + "end.".
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring  = fill(" ",7) + "for each " + ddb + "." + _file-name + " where " + ddb + "." + _file-name + "." + _field-name + " = v_domain:".
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring  =fill(" ",11) + "bbb = bbb + 1.".
        PUT STREAM bfcpcmds unformat outstring Skip.
        assign outstring = fill(" ",7) + "end."     .
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring = fill(" ",7) + "output stream bf1 to value (bufcpy_log) append.".
        PUT STREAM bfcpcmds unformat outstring Skip.
        assign outstring = fill(" ",7) + "put stream bf1 unformat 'table (" + string(icnt,"9999") + ") " + _file-name + " ' string(aaa,'>>>>>>>>9') ' of '.".
        PUT STREAM bfcpcmds unformat outstring skip.
        assign outstring = fill(" ",7) + "put stream bf1 unformat string(bbb,'>>>>>>>>9') fill(' ',7) '(converted) ' string(time,'HH:MM:SS') skip.".
        PUT STREAM bfcpcmds unformat outstring Skip.
        ASSIGN outstring = fill(" ",7) + "output stream bf1 close.".
        PUT STREAM bfcpcmds unformat outstring Skip(1).
    END.

    ASSIGN outstring = fill(" ",7) + "output stream bf1 to value (bufcpy_log) append.".
    PUT STREAM bfcpcmds unformat outstring Skip.
    assign outstring = fill(" ",7) + "put stream bf1 unformat skip(1) 'End: ' string(time,'HH:MM:SS') skip.".
    PUT STREAM bfcpcmds unformat outstring Skip.
    assign outstring = fill(" ",7) + "output stream bf1 close.".
    PUT STREAM bfcpcmds unformat outstring Skip.
    ASSIGN outstring = 'end. /*repeat with frame a:*/'.
    PUT STREAM bfcpcmds unformat outstring Skip.
    OUTPUT STREAM bfcpcmds CLOSE.
    
    OUTPUT STREAM bfcpcmds TO value('./tmp.prn').
    put stream bfcpcmds '/**/' skip.
    OUTPUT STREAM bfcpcmds close.
end. /* repeat with frame a: */
