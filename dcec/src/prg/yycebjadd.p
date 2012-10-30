/*zzuserupld.p to restore the inquire users data into inquire database*/

/******************comments******************************
input file layout:
       Field             Format
     1.订单号                  x(8)
     2.货物发自地点            x(8)
     3.接收地点                x(8)
     4.截止日期                x(6)
     5.备注                    x(6)
     6.项                      x(8)
     7.零件号                  x(18) 
     8.采购数量                x(8)
     9.运输标志                x(8)
******************end comments************************************/

{mfdeclre.i "new"}

def var srcfile as char format "x(40)".
def workfile xxwk
    field nbr like dss_nbr
    field shipsite like dss_shipsite
    field recsite like dss_rec_site
    field date1 AS CHARACTER
    FIELd rmks like dss_rmks
    field reqnbr like ds_req_nbr
    field part like ds_part
    field qtyord AS CHARACTER
    field transid like ds_trans_id.

def stream src.
def stream upload.
def var upload_file as char format "x(40)".
def var x_data as char extent 20 format "x(72)".
def var i as inte.
    
/*
srcfile = "f:\mfgntsvr\batch\inq_userid_up\inquire_user.txt".
upload_file = "f:\mfgntsvr\batch\inq_userid_up\upload.in".
*/

srcfile = "c:\fxddwh.csv".
upload_file = "c:\upload.in".

if search(srcfile) = ? then do:
      message "源文件 " + srcfile + " 不存在".
      leave.
end.

/*To create the upload cimload format file*/
output stream upload close.
output stream upload to value(upload_file).

put stream upload "~"" at 1 "admin" "~"" " ~"" "admin" "~"".
put stream upload "~"" at 1 "dsdomt.p" "~"".

for each xxwk:
     delete xxwk.
end.

input stream src from value(srcfile).
i = 0.
repeat:
    x_data = "".
    i = i + 1.
    import stream src delimiter "," x_data.
    
    if i > 1 then do:
          create xxwk.
          assign xxwk.nbr = x_data[1]
                 xxwk.shipsite = x_data[6]
                 xxwk.recsite = "cebj"  
                 xxwk.date1 = x_data[8]  
                 xxwk.rmks = "OK"  
                 xxwk.reqnbr = x_data[2]  
                 xxwk.part = x_data[3]
                 xxwk.qtyord = x_data[7]     
                 xxwk.transid = "CEBJTR". 
                 
    end.
end.
input stream src close.
     put stream upload "~"" at 1 xxwk.nbr "~" " "~"" xxwk.shipsite "~" " skip.                       
     put stream upload "~"" xxwk.recsite "~"" SKIP.
     put stream upload " - " " - " " ~"" xxwk.date1 "~""
                       " ~"" xxwk.rmks "~"" SKIP.

for each xxwk no-lock:
     put stream upload "~"" at 1 xxwk.reqnbr "~"" SKIP.
     put stream upload " ~"" xxwk.part "~"" SKIP.
     put stream upload " ~"" xxwk.qtyord "~"" SKIP.
     put stream upload " " AT 1 SKIP.
     put stream upload  " - " " - " 
                        "  - "   
                       " ~"" xxwk.transid "~"". 
end.

 put stream upload " . " at 1. 
 put stream upload " . " at 1. 
 put stream upload " . " at 1.
 put stream upload " y " at 1.
output stream upload close.

INPUT CLOSE.
INPUT from value(upload_file).
output to value(upload_file + ".out").
PAUSE 0 BEFORE-HIDE.
/*try here*/ batchrun = YES .
RUN MF.P.
INPUT CLOSE.
OUTPUT CLOSE.
    
