/**
 @File: yyusr.p
 @Description: 用户密码控制
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 用户密码控制
 @Todo: 
 @History: 
**/

DEF INPUT PARAMETER usid LIKE usr_userid .
DEF INPUT PARAMETER passwd LIKE usr_passwd .
DEF OUTPUT PARAMETER err AS LOG .

DEF VAR i AS INT .
DEF VAR xx AS INT .
DEF VAR x1 AS LOG .
DEF VAR x2 AS LOG .

DEF VAR y1 AS LOG .
DEF VAR y2 AS LOG .

err = YES .
xx = 1 .
FIND CODE_mstr NO-LOCK WHERE CODE_fldname = "password" AND CODE_value = "validation" NO-ERROR .
IF AVAILABLE CODE_mstr THEN xx = INTEGER(CODE_cmmt) NO-ERROR .

IF LENGTH(passwd) < 6 THEN DO :
    MESSAGE "密码必须超过6位！" VIEW-AS ALERT-BOX ERROR .
    err = NO .
    LEAVE .
END .

x1 = NO .
x2 = NO .
DO i = 1 TO LENGTH(passwd) :
    IF SUBSTRING(passwd,i,1) >= "0" AND SUBSTRING(passwd,i,1) <= "9" THEN x1 = YES .
    ELSE x2 = YES .
    IF x1 = YES AND x2 = YES THEN LEAVE .
END.

y1 = YES .
DO i = 1 TO LENGTH(passwd) :
    IF (SUBSTRING(passwd,i,1) >= "!" AND SUBSTRING(passwd,i,1) <= "/")
       OR SUBSTRING(passwd,i,1) >= ":" AND SUBSTRING(passwd,i,1) <= "@"
         THEN  y1 = YES .
         /*OR SUBSTRING(passwd,i,1) >= ":" AND SUBSTRING(passwd,i,1) <= "@"
         OR SUBSTRING(passwd,i,1) >= "[" AND SUBSTRING(passwd,i,1) <= "'"
         OR SUBSTRING(passwd,i,1) >= "|" AND SUBSTRING(passwd,i,1) <= "~" )*/
    
     ELSE y1 = NO .
    IF y1 = YES  THEN LEAVE .
END.


IF NOT (x1 = YES AND x2 = YES) OR y1 = NO THEN DO :
    MESSAGE "密码必须包含数字、字符和特殊字符！" passwd VIEW-AS ALERT-BOX ERROR .
    err = NO .
    LEAVE .
END .



FIND usr_mstr NO-LOCK WHERE usr_userid = usid NO-ERROR .

FIND xxusr_mstr WHERE xxusr_userid = usid NO-ERROR .
IF NOT AVAILABLE xxusr_mstr THEN DO :
    CREATE xxusr_mstr .
    xxusr_userid = usid .
    xxusr_passwd[1] = IF AVAILABLE usr_mstr THEN usr_passwd ELSE "" .
END.

DO i = 1 TO xx :
    IF ENCODE(passwd) = xxusr_passwd[i] THEN DO :
        MESSAGE "请不要输入与最近" xx "次内相同的密码！" VIEW-AS ALERT-BOX ERROR .
        err = NO .
        LEAVE .
    END.
END.

IF xx > 1 THEN DO :
    DO i = 1 TO (xx - 1) :
     xxusr_passwd[xx - i + 1] = xxusr_passwd[xx - i] .
    END.
END.

xxusr_passwd[1] = ENCODE(passwd) .

