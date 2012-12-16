/* Revision: QAD2011  BY: Apple Tam         DATE: 08/15/12  ECO: *SS -20120815.1  */

{mfdtitle.i "20120815.1"}

def var i as int .

def temp-table wf no-undo field wfkey as char
    index a1 wfkey.

define stream s_out.
output stream s_out to c:\sr_wkfl.d.

for each mon_ no-lock:
    find first wf where wfkey = mon_sid no-lock no-error.
    if not avail wf then do:
        create wf.
        wfkey = mon_sid.
    end.
end.

for each sr_wkfl where sr_domain = global_domain:
    find first wf where wfkey = substr(sr_userid,1,7) no-error.
    if not avail wf then do transaction:
        export stream s_out sr_wkfl.
        delete sr_wkfl.
        i = i + 1.
    end.
end.

disp i.  