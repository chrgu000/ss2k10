/*zzuserupld.p to restore the inquire users data into inquire database*/

/******************comments******************************
input file layout:
       Field             Format
     1. ���                   x(16)
     2. ״̬                   x(8)

******************end comments************************************/

{mfdeclre.i "new"}

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




if search(srcfile) = ? then do:
      message "Դ�ļ� " + srcfile + " ������".
      leave.
end.

/*To create the upload cimload format file*/
output stream upload close.
output stream upload to value(upload_file).

put stream upload "~"" at 1 "admin" "~"" " ~"" "admin" "~"".
put stream upload "~"" at 1 "yyppptmt04-2.p" "~"".

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

for each xxwk no-lock:

     find first pt_mstr no-lock where pt_part = xxwk.part1 no-error.
     if AVAILABLE pt_mstr THEN DO:
     put stream upload "~"" at 1 xxwk.part1 "~""  SKIP. 
     put stream upload "- " SKIP. 
     put stream upload "- " "- " "- " "- " "~""  status1 "~"" SKIP.                  
    end.
end.

put stream upload "." at 1.
put stream upload "." at 1.
put stream upload "Y" at 1.
output stream upload close.

INPUT CLOSE.
INPUT from value(upload_file).
output to value(upload_file + ".out").
PAUSE 0 BEFORE-HIDE.
RUN MF.P.
INPUT CLOSE.
OUTPUT CLOSE.
    
