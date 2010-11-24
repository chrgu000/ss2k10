procedure getPeriodDate:
  define input  parameter iPeriod as character.
  define output parameter oDteF   as date.
  define output parameter oDteT   as date.
  assign oDteF = date(int(substring(iPeriod,5,2)),
                      1,
                      int(substrin(iPeriod,1,4))).
  assign oDteT = oDteF + 32 - day(oDteF + 32).
end procedure.

/* 查找上期期间代码 */
FUNCTION getPrePeriod RETURNS CHARACTER (period AS CHARACTER):
  DEFINE VARIABLE idate AS DATE NO-UNDO.
  ASSIGN idate = DATE(INT(SUBSTRING(period,5,2)),1,int(SUBSTRING(period,1,4))).
  IF idate = ? THEN DO:
      ASSIGN idate = TODAY - DAY(TODAY) + 1.
  END.
  ASSIGN idate = iDATE - 1.
  RETURN string(year(idate),"9999")  + STRING(MONTH(idate),"99").
END FUNCTION.

/* 获取QAD_WKFL中总账的key */
PROCEDURE getGlcdkey :
    DEFINE INPUT PARAMETER iperiod AS CHARACTER.
    DEFINE OUTPUT PARAMETER okey1   LIKE qad_key1.
    DEFINE OUTPUT PARAMETER okey2   LIKE qad_key2.

    ASSIGN okey1 = "GLCD_DET".
    FOR FIRST en_mstr NO-LOCK :
        ASSIGN okey2 =  SUBSTRING(iperiod,1,4) + '0' +
              SUBSTRING(iperiod,5,2) + en_entity.
    END.
END PROCEDURE.

/* 获取总账中 glcalmt.p 工库及分摊状态 */
procedure getglcstat:
  define input  parameter iperiod  as character.
  define output parameter oicstat  as logical initial no.
  define output parameter odcsstat as logical initial no.
    DEFINE VARIABLE vkey1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vkey2 AS CHARACTER   NO-UNDO.

    RUN getGlcdKey(INPUT iperiod,OUTPUT vkey1,OUTPUT vkey2).

    for FIRST qad_wkfl no-lock where
      qad_key1 = vkey1 AND qad_key2 = vkey2:
       ASSIGN /* oicstat =  (qad_decfld[4] = 1) */       		    
              odcsstat = (qad_decfld[9] = 1). /* 用于锁定月分摊资料 */
   end.
   oicstat = yes.
end procedure.

PROCEDURE setdcics:
    DEFINE INPUT PARAMETER iperiod AS CHARACTER.
    DEFINE INPUT PARAMETER istat   AS INTEGER.

    DEFINE VARIABLE vkey1 AS CHARACTER NO-UNDO.
    DEFINE VARIABLE vkey2 AS CHARACTER NO-UNDO.
    RUN getGlcdKey(INPUT iperiod,OUTPUT vkey1,OUTPUT vkey2).

    FIND FIRST qad_wkfl EXCLUSIVE-LOCK WHERE qad_key1 = vkey1
           AND qad_key2 = vkey2 NO-ERROR.
    IF AVAIL qad_wkfl THEN DO:
        ASSIGN qad_decfld[9] = istat.
     END.
    ELSE DO:
        CREATE qad_wkfl.
        ASSIGN qad_key1 = vkey1
               qad_key2 = vkey2
               qad_decfld[9] = istat.
    END.
END PROCEDURE.
