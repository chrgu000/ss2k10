/* xxlnmt.i - Line shift common program                                      */
/* revision: 110422.1   created on: 20110422   by: zhang yun                 */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 0CYH LAST MODIFIED: 04/22/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

define variable con24h as integer initial 86400.
/** 整数到时数 **/
FUNCTION getHours RETURN INTEGER(tme AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose: 获取时数
    Notes:
------------------------------------------------------------------------------*/
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
/*------------------------------------------------------------------------------
  Purpose: 获取分数
    Notes:
------------------------------------------------------------------------------*/
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
/*------------------------------------------------------------------------------
  Purpose: 获取秒数
    Notes:
------------------------------------------------------------------------------*/
    RETURN tme MODULO (60).
END FUNCTION.

/** 整数时间到字符串以Separated分隔  **/
FUNCTION t2s RETURNS CHARACTER(tme AS INTEGER, Separated AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose: 时间转换为字符串
    Notes:
------------------------------------------------------------------------------*/
   DEFINE VARIABLE ret AS CHARACTER  NO-UNDO.
   ASSIGN ret = STRING(gethours(INPUT tme),"99") + Separated +
                STRING(getminutes(INPUT tme),"99") + Separated +
                STRING(getseconds(INPUT tme),"99").
   RETURN ret.
END FUNCTION.

/** 字符串转换为时间整数 ***/
FUNCTION s2t RETURNS INTEGER(ichar AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose: 字符串转换为时间
    Notes:
------------------------------------------------------------------------------*/
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

FUNCTION howLong RETURNS Decimal(iLong as integer,iType as Character):
/*------------------------------------------------------------------------------
  Purpose: 计算整数所用的时长
    Notes: iLong是时长整数,iType= "D,H,M,S("")"
------------------------------------------------------------------------------*/
define variable vType as integer.
    assign vType = 1.
    if iType = "M" then do:
       assign vType = 60.
    end.
    else if iType = "H" then do:
       assign vType = 3600.
    end.
    else if iType = "D" then do:
       assign vtype = 86400.
    end.
    return (iLong / vType).
END FUNCTION.