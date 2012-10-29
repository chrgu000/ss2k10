find _file where _file-name = "glt_det".

find _file-trig where _file-recid = RECID(_file) and _event = "Delete" no-error.
if not available _file-trig then do:
create _file-trig.
assign _file-trig._file-recid = RECID(_file)
       _file-trig._event      = "Delete"
       _file-trig._override   = False
       _file-trig._Proc-name  = "gltd.t"
       _file-trig._Trig-CRC   = ?.
end.
find _file-trig where _file-recid = RECID(_file) and _event = "Write" no-error.
if not available _file-trig then do:
create _file-trig.
assign _file-trig._file-recid = RECID(_file)
       _file-trig._event      = "Write"
       _file-trig._override   = False
       _file-trig._Proc-name  = "gltw.t"
       _file-trig._Trig-CRC   = ?.
       end.
message "Congratulation! You have done successfully" view-as alert-box.

