/* xxpcatld.p - xxppctmt.p auto cim load                                     */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "131121.1"}
{xxpcatld.i "new"}
{gpcdget.i "UT"}

assign sTxtDir = "/app/qadftp".
find first code_mstr no-lock where code_fldname = "PCLIST_AUTO_LOAD_PARAMETER"
       and code_value = "Source_Text_Dir" no-error.
if available code_mstr then do:
   assign sTxtDir = code_cmmt.
end.
form
   skip(1)
   sTxtDir colon 18
   cloadfile colon 18 skip(2)
with frame a side-labels width 80.
setframelabels(frame a:handle).

repeat:
  FILE-INFO:FILE-NAME = sTxtDir.
  IF FILE-INFO:FILE-TYPE = ? THEN DO:
       /* The directory is invalid */
      {mfmsg.i 3679 3}
       leave.
  END.
  display sTxtDir cLoadfile with frame a.
 update cloadfile with frame a.
 if cloadfile then do:
    for each xxfl exclusive-lock: delete xxfl. end.
    input from os-dir(sTxtDir).
    repeat:
       create xxfl.
       import delimiter "~t" xf_file xf_dname xf_type.
    end.
    input close.

    for each xxfl exclusive-lock:
        if index(xf_type,"F") = 0 then delete xxfl.
        else do:
          if substring(xf_file,length(xf_file) - 3) <> ".csv" then delete xxfl.
        end.
    end.
    {gprun.i ""xxpcatld0.p""}
    if can-find(first xxtmppc) then do:
       {gprun.i ""xxpcatld1.p""}
    end.
 end.
end.
