/*zzuserupld.p to restore the inquire users data into inquire database*/

/******************comments******************************
input file layout:
       Field             Format
     1. �û���־               x(8)
     2. �û���                 x(35)
     3.����                    x(2)
     4.���Ҵ���                x(3)
     5.����                    x(6)
     6.����                    x(16)
     7.�û�����                x(8) 
     8.�޶�                    x(1)
     9.ʱ��                    x(8)
     10.���ʿ�λ               x(8)
     11.�����ʼ�               x(50)
     12.����                   x(8)
     13.��ʽ                   x(1)
     14.������ʾ               x(8)
     15.�˵��滻               x(1)
     16.����                   x(100)
******************end comments************************************/

{mfdeclre.i "new"}


def workfile xxwk
    field id like usr_userid
    field name1 like usr_name
    field lang like usr_lang
    field country like usr_ctry_code
    FIELd code1 like usr_variant_code
    field passwd like usr_passwd
    field type_code AS CHAR
    field restrict /*like usr_restrict*/ AS CHAR
    field timezone like usr_timezone
    FIELD loc like usr_access_loc
    FIELD address like usr_mail_address
    FIELD qad02 like usr__qad02
    FIELD style like uip_style
    FIELD help1 /*like uip_hypertext_help*/ AS CHAR
    FIELD sub AS CHAR
    field group1 like usr_groups. /*��������ļ�ʱ�õ��ı�*/


def var srcfile as char format "x(40)". /*���������ļ�����*/
def var upload_file as char format "x(40)". /*���������־*/

def stream src.
def stream upload.
def var x_data as char extent 20 format "x(200)".
def var i as inte.
    

srcfile = "f:\appeb2\batch\inbox\inqypwd.txt".
upload_file = "f:\appeb2\batch\outbox\upload.in".

if search(srcfile) = ? then do:
      message "Դ�ļ� " + srcfile + " ������".
      leave.
end.

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
          assign xxwk.id = trim(x_data[1])
                 xxwk.name1 = trim(x_data[2])
                 xxwk.lang = trim(X_data[4])  
                 xxwk.country = "PRC"
                 xxwk.code1 = ""
                 xxwk.passwd = trim(x_data[5])
                 xxwk.type_code = "Employee"
                 xxwk.restrict = "N"
                 xxwk.timezone = "GMT+8"
                 xxwk.loc = "PRIMARY"
                 xxwk.address = ""
                 xxwk.qad02 = ""
                 xxwk.style = "A"
                 xxwk.help1 = "Y"
                 xxwk.sub = "Y"
                 xxwk.group1 = trim(x_data[3]).
                 
    end.
end.
input stream src close. /*�������ļ��ж�ȡ����*/


/*To create the upload cimload format file*/
output stream upload close.
output stream upload to value(upload_file).

put stream upload "~"" at 1 "mrp" "~"" " ~"" "mrp" "~"".
put stream upload "~"" at 1 "mgurmt.p" "~"".


for each xxwk no-lock:
     put stream upload "~"" at 1 xxwk.id "~"".
     put stream upload "~"" at 1 xxwk.name1 "~"".
     put stream upload "~"" at 1 xxwk.lang "~"" " ~"" xxwk.country "~""
                       " ~"" xxwk.code1 "~"" " ~"" xxwk.passwd "~""
                       " ~"" xxwk.type_code "~"" " ~"" xxwk.restrict "~""
                       " ~"" xxwk.timezone "~""
                       " ~""  xxwk.loc "~"" " ~"" xxwk.address "~""
                       " ~"" xxwk.qad02 "~"" " ~"" xxwk.style "~""
                       " ~"" xxwk.help1 "~""
                        " ~"" xxwk.sub "~"" " ~"" xxwk.group1 "~"".
                      
     put stream upload "~"" at 1 xxwk.passwd "~"".
     put stream upload  "Y" AT 1 SKIP.
     put stream upload  "." AT 1 SKIP.
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

/*
FOR EACH usr_mstr NO-LOCK.
    FIND FIRST xxwk WHERE xxwk.id = usr_userid NO-LOCK NO-ERROR.
    IF AVAIL xxwk THEN  ASSIGN usr_passwd = xxwk.passwd.
END.
*/
    
