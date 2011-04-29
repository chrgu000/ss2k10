define input  parameter PRICE_TOT   AS DEC  FORMAT "->>>,>>>,>>9.9999". /*原始数据*/
DEFINE output parameter SAY_TOT1    AS CHAR FORMAT "X(80)".    /*英文金额*/

DEFINE VAR V_DEC   AS DEC FORMAT "->>>,>>>,>>9.99".  /*原始数据(取2位小数显示)*/
DEFINE VAR V_frc   AS INT FORMAT "->>>,>>>,>>9". /*fractional 小数部分*/
DEFINE VAR V_INT   AS INT.                      /*integer   整数部分*/
DEFINE VAR v_bit   AS INT INIT 0.               /*digit bit 整数位数*/

DEFINE  VAR SAYTOT AS CHAR FORMAT "X(13)"  EXTENT 99 
    INIT ["ONE","TWO","THREE","FOUR","FIVE","SIX","SEVEN","EIGHT","NINE","TEN","ELEVEN","TWELVE","THIRTEEN","FOURTEEN",
          "FIFTEEN","SIXTEEN","SEVENTEEN","EIGHTEEN","NINETEEN","TWENTY","TWENTY-ONE","TWENTY-TWO","TWENTY-THREE","TWENTY-FOUR","TWENTY-FIVE",
          "TWENTY-SIX","TWENTY-SEVEN","TWENTY-EIGHT","TWENTY-NINE","THIRTY","THIRTY-ONE","THIRTY-TWO","THIRTY-THREE","THIRTY-FOUR",
          "THIRTY-FIVE","THIRTY-SIX","THIRTY-SEVEN","THIRTY-EIGHT","THIRTY-NINE","FORTY","FORTY-ONE","FORTY-TWO","FORTY-THREE","FORTY-FOUR",
          "FORTY-FIVE","FORTY-SIX","FORTY-SEVEN","FORTY-EIGHT","FORTY-NINE","FIFTY","FIFTY-ONE","FIFTY-TWO","FIFTY-THREE","FIFTY-FOUR","FIFTY-FIVE",
          "FIFTY-SIX","FIFTY-SEVEN","FIFTY-EIGHT","FIFTY-NINE","SIXTY","SIXTY-ONE","SIXTY-TWO",
          "SIXTY-THREE","SIXTY-FOUR","SIXTY-FIVE","SIXTY-SIX","SIXTY-SEVEN","SIXTY-EIGHT","SIXTY-NINE",
          "SEVENTY","SEVENTY-ONE","SEVENTY-TWO","SEVENTY-THREE","SEVENTY-FOUR","SEVENTY-FIVE","SEVENTY-SIX","SEVENTY-SEVEN","SEVENTY-EIGHT","SEVENTY-NINE",
          "EIGHTY","EIGHTY-ONE","EIGHTY-TWO","EIGHTY-THREE","EIGHTY-FOUR","EIGHTY-FIVE","EIGHTY-SIX","EIGHTY-SEVEN","EIGHTY-EIGHT","EIGHTY-NINE",
          "NINETY","NINETY-ONE","NINETY-TWO","NINETY-THREE","NINETY-FOUR","NINETY-FIVE","NINETY-SIX","NINETY-SEVEN","NINETY-EIGHT","NINETY-NINE"].

      
/*update PRICE_TOT . */

ASSIGN V_DEC = PRICE_TOT
       V_INT = TRUNCATE(V_DEC,0)
       V_frc = (V_DEC - V_INT) * 100.
       v_bit = LENGTH(STRING(V_INT)).
       
       
IF V_DEC > 0.00 THEN DO:  

    /*小数*/
    IF V_frc <> 0 THEN 
         SAY_TOT1 = "CENTS " + SAYTOT[ V_frc ] .
    ELSE SAY_TOT1 = "".

    /*十位个位*/
    IF V_INT < 10 THEN DO: 
        IF SAY_TOT1 = "" THEN 
             SAY_TOT1 = SAYTOT[INT(SUBSTRING(STRING(V_INT), v_bit,1)) ]  +  SAY_TOT1.
        ELSE SAY_TOT1 = SAYTOT[INT(SUBSTRING(STRING(V_INT), v_bit,1)) ]  + " AND " + SAY_TOT1.
    END.
    ELSE IF V_INT < 100 THEN DO: 
        IF V_frc > 0 THEN 
              SAY_TOT1 = SAYTOT[INT(SUBSTRING(STRING(V_INT), v_bit - 1,2)) ]  + " AND " + SAY_TOT1.
        ELSE  SAY_TOT1 = SAYTOT[INT(SUBSTRING(STRING(V_INT), v_bit - 1,2)) ]  + SAY_TOT1.
    END.
    ELSE DO:
        IF  INT(SUBSTRING(STRING(V_INT),v_bit - 1,2))  > 0 then do:
            if V_frc > 0  THEN 
                  SAY_TOT1 = SAYTOT[INT(SUBSTRING(STRING(V_INT), v_bit - 1,2)) ]  + " AND " + SAY_TOT1.   
            ELSE 
                  SAY_TOT1 = " AND " +  SAYTOT[INT(SUBSTRING(STRING(V_INT), v_bit - 1,2)) ]  + SAY_TOT1.
        end.
    END.

    /*百位*/
    IF v_bit >= 3 AND SUBSTRING(STRING(V_INT),v_bit - 2 ,1) <> "0" THEN 
            SAY_TOT1 =  SAYTOT[ INT(SUBSTRING(STRING(V_INT),v_bit - 2,1)) ] + " HUNDRED "  + SAY_TOT1.   
    /*千位万位*/
    IF v_bit = 4 AND SUBSTRING(STRING(V_INT),v_bit - 3 ,1) <> "0" THEN 
            SAY_TOT1 =  SAYTOT[ INT(SUBSTRING(STRING(V_INT),v_bit - 3,1)) ] + " THOUSAND, " + SAY_TOT1.
    ELSE IF v_bit >= 5 AND SUBSTRING(STRING(V_INT),v_bit - 4 ,1) <> "0" THEN 
            SAY_TOT1 =  SAYTOT[ INT(SUBSTRING(STRING(V_INT),v_bit - 4,2)) ] + " THOUSAND, " + SAY_TOT1.
    /*十万位*/
    IF v_bit >= 6 AND SUBSTRING(STRING(V_INT),v_bit - 5 ,1) <> "0" THEN 
        IF SUBSTRING(STRING(V_INT),v_bit - 4 ,1) <> "0" THEN 
              SAY_TOT1 =  SAYTOT[ INT(SUBSTRING(STRING(V_INT),v_bit - 5,1)) ] + " HUNDRED AND "  + SAY_TOT1.
        ELSE  SAY_TOT1 =  SAYTOT[ INT(SUBSTRING(STRING(V_INT),v_bit - 5,1)) ] + " HUNDRED THOUSAND "  + SAY_TOT1.                              
    
    /*百万位千万位亿位*/
    IF v_bit >= 7 and v_bit <= 9 THEN do:
        IF v_bit = 7 THEN 
                SAY_TOT1 =  SAYTOT[ INT(SUBSTRING(STRING(V_INT),v_bit - 6,1)) ] + " MILLION, " + SAY_TOT1.
        else IF v_bit = 8 THEN 
                SAY_TOT1 =  SAYTOT[ INT(SUBSTRING(STRING(V_INT),v_bit - 7,2)) ] + " MILLION, " + SAY_TOT1.
        else do:
            if INT(SUBSTRING(STRING(V_INT),v_bit - 7,2)) <> 0 then 
                 SAY_TOT1 = "AND " + SAYTOT[ INT(SUBSTRING(STRING(V_INT),v_bit - 7,2)) ] + " MILLION, " + SAY_TOT1.
            else SAY_TOT1 = "MILLION, " + SAY_TOT1.
            SAY_TOT1 = SAYTOT[ INT(SUBSTRING(STRING(V_INT),v_bit - 8,1)) ] + " HUNDRED " + SAY_TOT1.
        end.
    end.

    /*十亿位以上未添加*/


END. /*IF V_DEC > 0.00*/
      
/*
message  
v_bit skip 
V_DEC skip 
V_INT skip 
V_frc skip
SAY_TOT1 skip
view-as alert-box .
*/

