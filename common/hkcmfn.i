/* common function sets                                                      */

/** 整数到时数 **/
FUNCTION getHours RETURN INTEGER(tme AS INTEGER):
    DEFINE VARIABLE tfrom AS INTEGER    NO-UNDO.
    IF tme >= (24 * 60 * 60) THEN DO:
        tfrom = tme - (TRUNCATE(tme / (24 * 60 * 60) , 0)) * (24 * 60 * 60).
    END.
    ELSE DO:
        ASSIGN tfrom = tme.
    END.
    ASSIGN tfrom = TRUNCATE(tfrom / (60 * 60), 0).
    RETURN tfrom.
END FUNCTION.

/** 整数到分数 **/
FUNCTION getMinutes RETURN INTEGER(tme AS INTEGER):
    DEFINE VARIABLE tfrom AS INTEGER    NO-UNDO.
    IF tme >= (24 * 60 * 60) THEN DO:
        tfrom = tme - (TRUNCATE(tme / (24 * 60 * 60) , 0)) * (24 * 60 * 60).
    END.
    ELSE DO:
        ASSIGN tfrom = tme.
    END.
    ASSIGN tfrom = tfrom - (TRUNCATE(tfrom / (60 * 60), 0) * (60 * 60)).
    ASSIGN tfrom = TRUNCATE(tfrom / 60,0).
    RETURN tfrom.
END FUNCTION.

/** 整数到秒数 **/
FUNCTION getSeconds RETURN INTEGER(tme AS INTEGER):
    RETURN tme MODULO (60).
END FUNCTION.

/** 整数时间到字符串以Separated分隔  **/
FUNCTION time2char RETURNS CHARACTER(tme AS INTEGER, Separated AS CHARACTER):
   DEFINE VARIABLE ret AS CHARACTER  NO-UNDO.
   ASSIGN ret = STRING(gethours(INPUT tme),"99") + Separated +
                STRING(getminutes(INPUT tme),"99") + Separated +
                STRING(getseconds(INPUT tme),"99").
   RETURN ret.
END FUNCTION.

/** 字符串转换为时间整数 ***/
FUNCTION char2time RETURNS INTEGER(ichar AS CHARACTER):
    DEFINE VARIABLE C AS CHARACTER  NO-UNDO.
    IF length(trim(ichar)) = 0 THEN DO:
        ASSIGN ichar = "000000".
    END.
    ELSE IF LENGTH(TRIM(ichar)) <= 4 AND INDEX(ichar,":") = 0 THEN DO:
       ASSIGN c = SUBSTRING(ichar,1,2) + SUBSTRING(ichar,3,2) + "00".
    END.
    ELSE IF LENGTH(TRIM(ichar)) <= 5 AND INDEX(ichar,":") > 0 THEN DO:
       ASSIGN c = SUBSTRING(ichar,1,2) + SUBSTRING(ichar,4,2) + "00".
    END.
    ELSE IF LENGTH(TRIM(ichar)) > 5 AND INDEX(ichar,":") = 0 THEN DO:
        ASSIGN c = SUBSTRING(ichar,1,2) + SUBSTRING(ichar,3,2) +
                   SUBSTRING(ichar,5,2).
    END.
    ELSE DO:
        ASSIGN c = SUBSTRING(ichar,1,2) + SUBSTRING(ichar,4,2) +
                   SUBSTRING(ichar,7,2).
    END.

    RETURN INT(SUBSTRING(c,1,2)) * 60 * 60 +
           INT(SUBSTRING(c,3,2)) * 60 +
           INT(SUBSTRING(c,5,2)).

END FUNCTION.

/** convert progress date format to SQL yyyy-mm-dd format                    */
FUNCTION cDate2Str RETURN CHARACTER (idate AS DATE):
    DEFINE VARIABLE rdate AS CHARACTER FORMAT "x(10)".
    IF idate = ? THEN DO:
        ASSIGN rdate = "".
    END.
    ELSE DO:
        ASSIGN rdate = STRING(YEAR(idate),"9999") + "-" +
                       STRING(MONTH(idate),"99") + "-" +
                       STRING(DAY(idate),"99").
    END.
    RETURN rdate.
END FUNCTION.

/** get pt_desc1 pt_desc2 from idesc cut it to 40 character length           */
PROCEDURE getPtDesc:
DEFINE INPUT  PARAMETER iDesc  AS CHARACTER FORMAT "x(100)".
DEFINE OUTPUT PARAMETER oDesc1 AS CHARACTER FORMAT "x(40)".
DEFINE OUTPUT PARAMETER oDesc2 AS CHARACTER FORMAT "x(40)".

DEFINE VARIABLE vdesc LIKE iDesc.
DEFINE VARIABLE str   AS CHARACTER  NO-UNDO.

ASSIGN vDesc = iDesc.
str = SUBSTRING(vDesc, 39, 1, "RAW") + SUBSTRING(vDesc, 40, 1, "RAW").
IF INDEX(idesc, str) = 0 THEN DO:
   ASSIGN odesc1 = trim(SUBSTRING(vDesc, 1, 39, "RAW"))
          vdesc  = SUBSTRING(iDesc,LENGTH(SUBSTRING(iDesc,1,39,"RAW")) + 1,44).
END.
ELSE DO:
   ASSIGN odesc1 = trim(SUBSTRING(vDesc, 1, 40, "RAW"))
          vdesc  = SUBSTRING(iDesc,LENGTH(SUBSTRING(iDesc,1,40,"RAW")) + 1,44).
END.

str = SUBSTRING(vDesc, 39, 1, "RAW") + SUBSTRING(vDesc, 40, 1, "RAW").
IF INDEX(idesc, str) = 0 THEN
    odesc2 = trim(SUBSTRING(vDesc, 1, 39, "RAW")).
ELSE
    odesc2 = trim(SUBSTRING(vDesc, 1, 40, "RAW")).
END PROCEDURE.

/**此过程将一个长的字符串截取成3个固定长度的字符串，且考虑汉字因素**/
procedure cutString:
    define input  parameter istr as character.  /* 源字符串 */
    define input  parameter lnth as integer.    /* 截取长度 */
    define output parameter ostr1 AS CHARACTER . /* 目标串1 - 3  */
    define output parameter ostr2 AS CHARACTER.
    define output parameter ostr3 AS CHARACTER.

    DEFINE VARIABLE vdesc LIKE istr.
    DEFINE VARIABLE vchar  AS CHARACTER  NO-UNDO.

    ASSIGN vDesc = istr.
    vchar = SUBSTRING(vDesc, lnth - 1 , 1, "RAW") +
            SUBSTRING(vDesc, lnth , 1, "RAW").
    IF INDEX(istr, vchar) = 0 THEN DO:
       ASSIGN ostr1 = trim(SUBSTRING(vDesc, 1, lnth - 1, "RAW"))
              vdesc  = SUBSTRING(vDesc,
                                 LENGTH(SUBSTRING(vdesc,1,lnth - 1,"RAW")) + 1,
                                 120).
    END.
    ELSE DO:
       ASSIGN ostr1 = trim(SUBSTRING(vDesc, 1, lnth, "RAW"))
              vdesc  = SUBSTRING(vDesc,
                                 LENGTH(SUBSTRING(vdesc,1,lnth ,"RAW")) + 1,
                                 120).
    END.

    IF LENGTH(vdesc,"RAW") > lnth THEN DO:
        vchar = SUBSTRING(vDesc, lnth - 1 , 1, "RAW") +
                SUBSTRING(vDesc, lnth , 1, "RAW").
        IF INDEX(istr, vchar) = 0 THEN DO:
           ASSIGN ostr2 = trim(SUBSTRING(vDesc, 1, lnth - 1, "RAW"))
                  vdesc = SUBSTRING(vDesc,
                              LENGTH(SUBSTRING(vdesc,1,lnth - 1,"RAW")) + 1,
                                    120).
        END.
        ELSE DO:
           ASSIGN ostr2 = trim(SUBSTRING(vDesc, 1, lnth, "RAW"))
                  vdesc = SUBSTRING(vDesc,
                                    LENGTH(SUBSTRING(vdesc,1,lnth ,"RAW")) + 1,
                                    120).
        END.
    END.
    ELSE DO:
        ASSIGN ostr2 = vdesc.
    END.

    IF LENGTH(vdesc,"RAW") > lnth  THEN DO:
        vchar = SUBSTRING(vDesc, lnth - 1 , 1, "RAW") +
                SUBSTRING(vDesc, lnth , 1, "RAW").
        IF INDEX(istr, vchar) = 0 THEN DO:
           ASSIGN ostr3 = trim(SUBSTRING(vDesc, 1, lnth - 1, "RAW")).
        END.
        ELSE DO:
           ASSIGN ostr3 = trim(SUBSTRING(vDesc, 1, lnth, "RAW")).
        END.
    END.
    ELSE DO:
        ASSIGN ostr3 = vdesc.
    END.
end procedure.

/* 日期YYYY-MM-DD转换为QAD日期格式 */
FUNCTION str2Date RETURNS DATE(INPUT datestr AS CHARACTER):
    DEFINE VARIABLE sstr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iY   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iM   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE id   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE od   AS DATE      NO-UNDO.
    if datestr = "" then do:
        assign od = ?.
    end.
    else do:
        ASSIGN sstr = datestr.
        ASSIGN iY = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,"-") - 1)).
        ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,"-") + 1).
        ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,"-") - 1)).
        ASSIGN iD = INTEGER(SUBSTRING(sstr,INDEX(sstr,"-") + 1)).
        ASSIGN od = DATE(im,id,iy).
    end.
    RETURN od.

END FUNCTION.

/* get current Host Name */
FUNCTION getHostName RETURNS CHARACTER:
    DEFINE VARIABLE hostname AS CHARACTER NO-UNDO.
    DEFINE VARIABLE tmpfile  AS CHARACTER NO-UNDO.
    ASSIGN tmpfile = "hostname" + STRING(TIME).
    DOS SILENT value("hostname > " + tmpfile).
    INPUT FROM VALUE(tmpfile).
        IMPORT hostname.
    INPUT CLOSE.
    OS-DELETE VALUE(tmpfile).
    RETURN hostname.
END FUNCTION.
