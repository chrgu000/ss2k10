/* xxusrbk.p - backup userinfo                                               */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */
/*注意：这个CIM_LOAD是字符版程序的格式不能在GUI下运行                        */

define variable expUser as character initial
       "mfg,admin".
define variable intI as integer.
define variable intJ as integer.

for each usr_mstr no-lock:
    accum usr_userid(count).
end.
assign intJ = accum count(usr_userid).
if intJ >= 400 then do:
     OUTPUT TO upwd.txt.
     inti = 0.
     FOR EACH usr_mstr NO-LOCK WHERE usr_userid <> "" and
        index(expUser,usr_userid) = 0:
        inti = inti + 1.
        EXPORT DELIMITER ";" usr_userid usr_passwd.
     END.
     OUTPUT CLOSE.
     output to value("./log.txt").
     put unformat "Total " + trim(string(inti))
                + " users passwd export(Not include " + expUser + ")." skip.
     output close.
end.
else do:
     output to value("./log.txt").
     put unformat "not backup user passwd information." skip.
     output close.
end.
OUTPUT TO u.bpi.
put unformat '"mfg" "qadqad"' skip.
put unformat '"dcec"' skip.

put unformat '"qxopm.p"' skip.
put unformat 'N' skip.
put unformat '.' skip.

put unformat '"mgdommt.p"' skip. /*Change DOmain description.*/
put unformat '"DCEC"' skip.
put unformat '"Test Env - ' + string(today) + ' ' + string(time,"HH:MM") + '" Test_Env' skip.
put unformat '.' skip.

put unformat '"admgmt06.p"' skip.
put unformat '"~~screens"' skip.
put unformat '"Test Env - ' + string(today) + ' ' + string(time,"HH:MM") + '" '.
put unformat '- - - - - - - PRC'  skip.
put unformat '-' skip. /*tax*/
put unformat '.' skip. /*bank*/
put unformat '.' skip. /*addr*/

put unformat '"xxusrpw.p"' skip. /*create usr and change user password.*/

put unformat 'mgurmt.p' skip. /* cim load user information */
inti = 0.
FOR EACH usr_mstr NO-LOCK WHERE usr_userid <> "" and
         index(expUser,usr_userid) = 0:
    inti = inti + 1.
    PUT UNFORMAT '"' usr_userid '"' SKIP.
    PUT UNFORMAT '"' usr_name '"' SKIP.
    PUT UNFORMAT usr_lang ' "' usr_variant_code '" ' usr_ctry_code ' ' usr_restrict ' "Employee" "PRIMARY" "GMT+8" '.
    PUT UNFORMAT '"' usr__qad02 '" "' usr_mail_address '" - - "' usr_remark '"' SKIP .
    PUT UNFORMAT usr_active ' "QAD_DEF" N N' SKIP.
    PUT UNFORMAT "-" SKIP.
    for each udd_det no-lock where udd_userid = usr_userid break by udd_userid:
        put unformat '"' udd_domain '"' skip.
        put unformat udd_primary ' N' skip.
        if last-of(udd_userid) then do:
           put unformat "." skip.
        end.
    end.
    for each usrl_det no-lock where usrl_userid = usr_userid break by usrl_userid:
        put unformat '"' usrl_product '"' skip.
        put unformat usrl_active skip.
        if last-of(usrl_userid) then do:
        put unformat "." skip.
        end.
    end.
    put unformat "y" skip.
END.
put unformat '.' skip.
put unformat '.' skip.
put 'Y' skip.
OUTPUT CLOSE.

output to value("./log.txt") append.
put unformat "Total " + trim(string(inti)) + " users output(Not include " + expUser + ")." skip.
output close.
