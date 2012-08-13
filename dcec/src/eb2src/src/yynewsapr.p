/**
 @File: yynewsapr.p
 @Description: 销售价格报表
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 销售价格报表
 @Todo: 
 @History: 
**/

{mfdtitle.i}

DEF VAR plist LIKE pi_list .
DEF VAR plist1 LIKE pi_list .
DEF VAR pics_code LIKE pi_cs_code .
DEF VAR pics_code1 LIKE pi_cs_code .
DEF VAR part_code LIKE pi_part_code .
DEF VAR part_code1 LIKE pi_part_code .
DEF VAR curr LIKE pi_curr .
DEF VAR curr1 LIKE pi_curr .
DEF VAR effective LIKE pi_start .
DEF VAR onlynew AS LOGICAL LABEL "只显示最新价格" .
DEF VAR pics_type_key LIKE lngd_key1 .
DEF VAR part_type_key LIKE lngd_key1 .
DEF VAR yn AS LOGICAL .
DEF VAR part LIKE pi_part_code .
DEF VAR pics LIKE pi_cs_code .

FORM
    plist COLON 25 plist1 LABEL {t001.i} COLON 50
    pics_code COLON 25 pics_code1 LABEL {t001.i} COLON 50
    part_code COLON 25 part_code1 LABEL {t001.i} COLON 50
    curr COLON 25 curr1 LABEL {t001.i} COLON 50
    effective COLON 25
    onlynew COLON 25
    SKIP(1)
WITH FRAME a WIDTH 80 SIDE-LABELS NO-ATTR-SPACE THREE-D .
setFrameLabels(frame a:handle).

FORM
pi_list pi_desc pi_cs_code pi_part_code pi_curr pi_um pi_start pi_expire pi_list_price pi_min_price pi_max_price
WITH FRAME b DOWN WIDTH 160 STREAM-IO .
setFrameLabels(frame b:handle).

REPEAT ON ERROR UNDO,LEAVE : 
   
    HIDE MESSAGE NO-PAUSE.
 
    IF plist1 = hi_char THEN plist1 = "" .
    IF pics_code1 = hi_char THEN pics_code1 = "" .
    IF part_code1 = hi_char THEN part_code1 = "" .
    IF curr1 = hi_char THEN curr1 = "" .

    UPDATE plist plist1 pics_code pics_code1 part_code part_code1 curr curr1 effective onlynew WITH FRAME a .

    IF plist1 = "" THEN plist1 = hi_char .
    IF pics_code1 = "" THEN pics_code1 = hi_char .
    IF part_code1 = "" THEN part_code1 = hi_char .
    IF curr1 = "" THEN curr1 = hi_char .

    {mfselprt.i "printer" 132}

    pics_type_key = "9".
    part_type_key = "6".

    FOR EACH pi_mstr WHERE (pi_list >= plist AND pi_list <= plist1)
        AND ((pi_cs_code >= pics_code AND pi_cs_code <= pics_code1) OR (pics_code = "" AND pi_cs_code BEGINS "qadall"))
        AND pi_cs_type = pics_type_key
        AND pi_part_type = part_type_key
        AND ((pi_part_code >= part_code AND pi_part_code <= part_code1) OR (part_code = "" AND pi_part_code BEGINS "qadall"))
        AND (pi_curr >= curr AND pi_curr <= curr1)
        AND (((pi_start <= effective OR pi_start = ?) AND (pi_expire >= effective OR pi_expire = ?)) OR effective = ?)
        AND pi_amt_type = "1"
        USE-INDEX pi_list
        BREAK BY pi_cs_code + pi_part_code + pi_curr + pi_um :

        {mfguichk.i}

        yn = NO .
        IF onlynew = NO THEN yn = YES .
        ELSE IF LAST-OF(pi_cs_code + pi_part_code + pi_curr + pi_um) THEN yn = YES .

        IF yn THEN DO :
            IF pi_cs_code BEGINS "qadall" THEN pics = "" .
            ELSE pics = pi_cs_code .
            IF pi_part_code BEGINS "qadall" THEN part = "" .
            ELSE part = pi_part_code .
            DISPLAY pi_list pi_desc pics @ pi_cs_code part @ pi_part_code pi_curr pi_um pi_start pi_expire pi_list_price pi_min_price pi_max_price WITH FRAME b STREAM-IO.
            DOWN 1 WITH FRAME b .
        END.

    END.
    
    {mfrtrail.i}

end. /*repeat*/



