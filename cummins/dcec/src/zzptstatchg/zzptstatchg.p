/*zzuserupld.p to restore the inquire users data into inquire database*/

/******************comments******************************
input file layout:
       Field             Format
     1. 零件                   x(16)
     2. 状态                   x(8)

******************end comments************************************/

{mfdeclre.i "new global"}
{mf1.i "new global"}
session:date-format = 'dmy'.
base_curr = "RMB".
global_userid = "MFG".
mfguser="".
global_user_lang = "ch".
global_user_lang_dir = "ch/".
global_domain = "DCEC".
global_db = "DCEC".
execname = "qadtoatpu.p".
hi_char = chr(255).
low_date = date(01,01,1900).
hi_date = date(12,31,3999).

define variable v_key like usrw_key1 no-undo initial "ZZPTSTATCHG.P-CTRL".

def var srcfile as char format "x(40)".
def workfile xxwk
    field part1 as char format "x(16)"
    field status1 like pt_status.

def stream src.
def stream upload.
def var upload_file as char format "x(40)".
def var x_data as char extent 20 format "x(72)".
def var i as inte.

/*
srcfile = "f:\mfgntsvr\batch\inq_userid_up\inquire_user.txt".
upload_file = "f:\mfgntsvr\batch\inq_userid_up\upload.in".
*/

srcfile = "\\qadtemp\FTP\DCEC\PART_STATE_CHANGE.TXT".
upload_file = "f:\appeb2\batch\outbox\PART_STATE_CHANGE.in".

find usrw_wkfl where usrw_domain = global_domain and
                     usrw_key1 = v_key and
                     usrw_key2 = v_key no-error.
if available usrw_wkfl then do:
  assign srcfile = usrw_key3
         upload_file = usrw_key4.
end.

if search(srcfile) = ? then do:
      message "源文件 " + srcfile + " 不存在".
      leave.
end.

/*To create the upload cimload format file
output stream upload close.
output stream upload to value(upload_file).

put stream upload "~"" at 1 "admin" "~"" " ~"" "admin" "~"".
put stream upload "~"" at 1 "yyppptmt04-2.p" "~"".
*/
for each xxwk:
     delete xxwk.
end.

input stream src from value(srcfile).
i = 0.
repeat:
    x_data = "".
    i = i + 1.
    import stream src delimiter ";" x_data.

    if i >= 1 then do:
          create xxwk.
          assign xxwk.part1   = x_data[1]
                 xxwk.status1 = x_data[2].
    end.
end.
input stream src close.

output stream upload to value(upload_file).
for each xxwk no-lock:
    find first pt_mstr no-lock where pt_part = xxwk.part1 no-error.
    if AVAILABLE pt_mstr THEN DO:
       put stream upload unformat '"'  xxwk.part1 '"'  SKIP.
       put stream upload unformat '-' SKIP.
       put stream upload unformat '- - - - - "' status1 '"' SKIP.
    end.
end.
output stream upload close.

INPUT from value(upload_file).
output to value(upload_file + ".out").
PAUSE 0 BEFORE-HIDE.
batchrun = yes.
{gprun.i ""xxptmt04c.p""}
batchrun = no.
OUTPUT CLOSE.
INPUT CLOSE.
