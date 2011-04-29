def var usrid1 like usr_userid.
def var aa as char.
def var pp as char.
def stream upload.
def var upload_file as char format "x(40)".

DEF WORKFILE tmp
    FIELD tmp_userid LIKE usr_userid
    field tmp_lang like usr_lang.
    
                define stream aa.
                input  STREAM aa from /home/public/uprod.csv.

                 {mfdtitle.i}   
 repeat :
 IMPORT STREAM aa delimiter ","  usrid1 aa pp .
                  
     IF usrid1 > ""  THEN DO:
       CREATE tmp.
     
       ASSIGN  tmp_userid = usrid1.
       if pp = "p" then tmp_lang = "de".
       if pp = "d" then tmp_lang = "fr".
    end.           
end.    
/*for each tmp:
disp tmp.
end.*/

              for each tmp /*where tmp_lang = "fr"*/,
                  each usrl_det where usrl_userid = tmp_userid :
                   if tmp_lang = "fr" then delete  usrl_det.
                   if tmp_lang = "de" and usrl__qadt01 >= 08/03/07
                   then usrl__qadt01 = 08/02/07.

              end.
              
            for each tmp /*where tmp_lang = "fr"*/ ,
               each lua_det where lua_userid = tmp_userid:
               /* disp lua_det.*/
               if tmp_lang = "fr" then delete  lua_det.
               if tmp_lang = "de"  and lua_in_date  >= 08/01/07
                  then delete lua_det.
              
            end.  
            for each tmp where /*tmp_lang = "fr"*/ ,
                each lcap_hist where lcap_mod_userid = tmp_userid.
                /*disp lcap_hist.*/
                if tmp_lang = "fr" then delete  lua_det.
                 if tmp_lang = "de" and lcap_mod_date  >= 08/01/07
                 then disp lcap_hist.
                
            end.
            for each tmp /*where tmp_lang = "fr"*/ ,
                each usg_det where usg_userid = tmp_userid :
                 /*if tmp_lang = "fr" then delete  usg_det.*/
                 if tmp_lang = "de" and usg_date >= 08/01/07 
                 then disp usg_det.
                 if usg_userid = "hulj" then usg_userid = "caoxh" .
                 if usg_userid = "aijx" then usg_userid = "jinfz".
                 if usg_userid = "qib" then usg_userid = "wangy".
                  if usg_userid = "lij" then usg_userid = "zhouwy".
                   if usg_userid = "wuce" then usg_userid = "wangy".
                   if usg_userid = "xut" then usg_userid = "zhangwl".
                    if usg_userid = "zhangjj" then usg_userid = "humx".
                     if usg_userid = "wangxm" then usg_userid = "jinfz".
                 
                /*disp usg_det.*/            end.
            for each tmp,
            each hwm_det where hwm_userid =  tmp_userid :
              if hwm_date  >= 08/01/07 then do:
                disp hwm_det.
                 if hwm_userid = "aijx" then hwm_userid = "jinfz".
                 if hwm_userid = "wuce" then hwm_userid = "wangy".
                 if hwm_userid = "hulj" then hwm_userid = "caoxh" .
                  if hwm_userid = "lij" then hwm_userid = "zhouwy".
                   if hwm_userid = "xut" then hwm_userid = "zhangwl".
                    if hwm_userid = "gongll" then hwm_userid = "zhouwy".
                     if hwm_userid = "hujr" then hwm_userid = "wangy".
                     if hwm_userid = "zhaohh" then hwm_userid = "zengf".
                  
             end.   
            end.
                 


/****
upload_file = "/home/public/usr1.in".          
output stream upload close.
output stream upload to value(upload_file).
put stream upload "~"" at 1 "mfg" "~"" " ~"" "shadac" "~"".
put stream upload "~"" at 1 "mgurmt.p" "~"" skip.          
          
          
          for each tmp where tmp_lang = "de",
              each usrl_det where usrl_userid = tmp_userid:

              put stream upload "~"" at 1 tmp_userid "~"".    
              put stream upload skip.     
              put stream upload skip.

              put stream upload  "~"" at 1 "COMPLIANCE" "~"" skip.
              put stream upload  "N" AT 1 SKIP.
              put stream upload  "~"" at 1 "CONSIGNMENT" "~"" skip.
              put stream upload  "N" AT 1 SKIP.
              put stream upload  "~"" at 1 "MFG/PRO" "~"" skip.
              put stream upload  "N" AT 1 SKIP.
                             
               put stream upload  "." AT 1 SKIP.     
               put stream upload "Y" at 1.           
             /* disp usrl_userid usrl_active.*/
           end.       

  put stream upload "." at 1.
  put stream upload "." at 1.
  put stream upload "Y" at 1.
  output stream upload close.

INPUT CLOSE.
INPUT from value(upload_file).
output to value(upload_file + ".out").
PAUSE 0 BEFORE-HIDE.
RUN mf.p.
INPUT CLOSE.
OUTPUT CLOSE.

**************/
