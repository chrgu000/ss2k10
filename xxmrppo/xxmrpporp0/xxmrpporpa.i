/* xxmrpporpa.i - vender mrp po report                                       */
/* revision: 110831.1   created on: 20110830   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

procedure MinPackQty:
/*------------------------------------------------------------------------------
    Purpose: ����Բ����С��װ��
  Parameter: iSourceQty - ԭʼ����
             iBase      - �����������ʼ��Ϊ1
             iDiff      - �м���,��ʼ��ʱΪ0����ʱ���Է���Ϊ׼.
             iReqQty    - ���ص�ʵ������
      Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER iSourceQty AS DECIMAL.
DEFINE INPUT PARAMETER iBase AS DECIMAL.
DEFINE INPUT-OUTPUT PARAMETER iDiff AS DECIMAL.
DEFINE OUTPUT PARAMETER iReqQty AS DECIMAL.

    iDiff = iSourceQty - iDiff.
    IF iDiff > 0  THEN DO:
       IF iDiff MODULO iBase = 0 then do:
/*           assign iReqQty = (truncate(iDiff / iBase,0)) * iBase.           */
						 assign iReqQty = iDiff.
       end.
       else do:
           assign iReqQty = (truncate(iDiff / iBase,0) + 1) * iBase.
       end.
    END.
    ELSE DO:
        ASSIGN iReqQty = 0.
    END.
    ASSIGN iDiff = iReqQty - iDiff.
end procedure.

PROCEDURE getDateArea:
/*------------------------------------------------------------------------------
    Purpose: �������ڷ�Χ
      Notes:  
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iDate AS DATE.
    DEFINE INPUT PARAMETER iRule AS CHARACTER.
    DEFINE OUTPUT PARAMETER oStart AS DATE.
    DEFINE OUTPUT PARAMETER oEnd AS DATE.
    
    IF SUBSTRING(irule,1,1) = "M" THEN
        ASSIGN iRule = entry(2,iRule,";").
    ELSE
        ASSIGN iRule = substring(iRule,2).

    oStart = date(month(iDate),1,year(iDate)).
    repeat:
          if index(iRule,string(weekday(oStart) - 1)) > 0 then do:
               leave.
          end.
          oStart = oStart + 1.
    end.
    oEnd = DATE(MONTH(oStart),28,YEAR(oStart)) + 5.
    oEnd = DATE(MONTH(oEnd),1,YEAR(oEnd)).
    repeat:
          if index(iRule,string(weekday(oEnd) - 1)) > 0 then do:
               leave.
          end.
          oEnd = oEnd + 1.
    end. 
    oEnd = oEnd - 1.
END PROCEDURE.

procedure getOrdDay:
/*------------------------------------------------------------------------------
    Purpose: ��ȡ�ͻ�����
      Notes: ��������������Ϊ�ǹ���������ǰ����һ���ǹ�����.
------------------------------------------------------------------------------*/
  define input parameter isite like si_site.
  define input parameter iRule as character.
  define input parameter iStart as date.
  define input parameter iDate as date.
  define output parameter odate as date.

    define variable vrule as character.  /* �ͻ�ԭ�� */
    define variable vtype as character.  /* ��� M/W */
    define variable vCyc  as integer.    /* Ƶ��  */
    define variable vStart as date.
    define variable vEnd as date.

/*   empty temp-table tmp_date no-error. */
  	ASSIGN vtype = substring(iRule,1,1).  
    IF vtype = "M" THEN DO: .
    	ASSIGN vcyc = integer(substring(ENTRY(1,irule,";"),2)).
    END.

    RUN getDateArea(INPUT iStart,INPUT iRule,OUTPUT vStart,OUTPUT vEnd).
    IF vtype = "M" THEN ASSIGN vRule = ENTRY(2,iRule,";").
                   ELSE ASSIGN vrule = SUBSTRING(iRule,2).
    IF idate >= vstart AND iDate <= vend THEN DO:
        IF vType = "W" THEN DO:
           ASSIGN oDate = iDate.
           REPEAT: 
               IF INDEX(vRule,STRING(WEEKDAY(odate) - 1)) > 0 THEN DO:
                   LEAVE.
               END.
               oDate = oDate - 1.
           END.
        END.
        ELSE IF vType = "M" THEN DO: 
            IF vCyc = 1 THEN DO:
                ASSIGN odate = vStart.
            END.
            IF vCyc = 2 THEN DO:
                IF iDate < vStart + 14 THEN DO:
                   ASSIGN oDate = vStart.
                END.
                ELSE DO:
                   ASSIGN oDate = vStart + 14.
                END.
            END.
        END.
    END.
    ELSE if iDate < vStart Then DO:
         ASSIGN oDate = iDate.  
    END.
    ELSE DO:
    	   ASSIGN oDate = ?.
    END.

/* ����ͻ�����Ϊ�ڼ�������ǰ����һ�������� */
  REPEAT: /*����*/
     IF CAN-FIND(FIRST hd_mstr NO-LOCK WHERE
                       hd_site = isite AND hd_date = odate) THEN DO:
        ASSIGN odate = odate - 1.
     END.
     ELSE DO:
         LEAVE.
     END.
  END. /* REPEAT: ����*/
end procedure.
