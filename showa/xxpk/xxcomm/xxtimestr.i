/* xxlnmt.i - Line shift common program                                      */
/* revision: 110422.1   created on: 20110422   by: zhang yun                 */
/*V8:ConvertMode=NoConvert                                                   */
/* REVISION: 0CYH LAST MODIFIED: 04/22/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

define variable con24h as integer initial 86400.
/** ������ʱ�� **/
FUNCTION getHours RETURN INTEGER(tme AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose: ��ȡʱ��
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

/** ���������� **/
FUNCTION getMinutes RETURN INTEGER(tme AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose: ��ȡ����
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

/** ���������� **/
FUNCTION getSeconds RETURN INTEGER(tme AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose: ��ȡ����
    Notes:
------------------------------------------------------------------------------*/
    RETURN tme MODULO (60).
END FUNCTION.

/** ����ʱ�䵽�ַ�����Separated�ָ�  **/
FUNCTION t2s RETURNS CHARACTER(tme AS INTEGER, Separated AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose: ʱ��ת��Ϊ�ַ���
    Notes:
------------------------------------------------------------------------------*/
   DEFINE VARIABLE ret AS CHARACTER  NO-UNDO.
   ASSIGN ret = STRING(gethours(INPUT tme),"99") + Separated +
                STRING(getminutes(INPUT tme),"99") + Separated +
                STRING(getseconds(INPUT tme),"99").
   RETURN ret.
END FUNCTION.

/** �ַ���ת��Ϊʱ������ ***/
FUNCTION s2t RETURNS INTEGER(ichar AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose: �ַ���ת��Ϊʱ��
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
  Purpose: �����������õ�ʱ��
    Notes: iLong��ʱ������,iType= "D,H,M,S("")"
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