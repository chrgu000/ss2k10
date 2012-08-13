/*zzuserupld.p to restore the inquire users data into inquire database*/

/******************comments******************************
input file layout:
       Field             Format
    1. 用户标志               x(8)
     2. 用户名                 x(35)
     3. 组1                    x(72)
     4. 组2                    x(72)
     5. 组3                    x(72)
     6. 组4                    x(72)
     7. 语言                   x(2)
     8. 密码                   x(16)
******************end comments************************************/

{mfdeclre.i "new"}

def var srcfile as char format "x(40)".
def workfile xxwk
    field id like usr_userid
    field name like usr_name
    field group1 like usr_groups
    field group2 like usr_groups
    field group3 like usr_groups
    field group4 like usr_groups
    field lang like usr_lang
    field passwd like usr_passwd.

def stream src.
def stream upload.
def var upload_file as char format "x(40)".
def var x_data as char extent 8 format "x(72)".
def var i as inte.
    
srcfile = "f:\mfgntsvr\batch\inq_userid_up\inquire_user.txt".
upload_file = "f:\mfgntsvr\batch\inq_userid_up\upload.in".

if search(srcfile) = ? then do:
      message "源文件 " + srcfile + " 不存在".
      leave.
end.

/*To create the upload cimload format file*/
output stream upload close.
output stream upload to value(upload_file).

put stream upload "~"" at 1 "mrp" "~"" " ~"" "mrp" "~"".
put stream upload "~"" at 1 "mgurmt.p" "~"".

for each xxwk:
     delete xxwk.
end.

input stream src from value(srcfile).
i = 0.
repeat:
    x_data = "".
    i = i + 1.
    import stream src delimiter ";" x_data.
    
    if i > 1 then do:
          create xxwk.
          assign xxwk.id = x_data[1]
                 xxwk.name = x_data[2]
                 xxwk.group1 = x_data[3]
                 xxwk.group2 = x_data[4]
                 xxwk.group3 = x_data[5]
                 xxwk.group4 = x_data[6]
                 xxwk.lang = x_data[7]
                 xxwk.passwd = x_data[8].
    end.
end.
input stream src close.

for each xxwk no-lock:
     put stream upload "~"" at 1 xxwk.id "~"".
     put stream upload "~"" at 1 xxwk.name "~"" " ~"" xxwk.group1 "~""
                       " ~"" xxwk.group2 "~"" " ~"" xxwk.group3 "~""
                       " ~"" xxwk.group4 "~"" " ~"" xxwk.lang "~""
                       " ~"" xxwk.passwd "~"".
     put stream upload "Y" at 1.                   
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
    
