
DEFINE VAR record AS CHAR FORMAT "x(250)".
DEFINE VAR record1 AS CHAR FORMAT "x(250)".
DEFINE VAR record2 AS CHAR FORMAT "x(250)".
DEFINE VAR title1 AS CHAR FORMAT "x(106)".
DEFINE VAR sys_date AS DATE INITIAL TODAY.
DEFINE VAR mh AS CHAR FORMAT "x(2)".
DEFINE VAR dy AS CHAR FORMAT "x(2)".
DEFINE VAR vdate AS CHAR FORMAT "x(10)".
DEFINE VAR amt_begin AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE VAR amt_end AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE VAR ac_sum AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE VAR SUM_begin AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE VAR SUM_end AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE VAR temp AS INT.

Function accbalance RETURN DECIMAL (INPUT ac AS CHAR , INPUT period AS CHAR):

    DEFINE VAR a AS INT.
    DEFINE VAR Y AS INTEGER FORMAT "9999".
    DEFINE VAR m AS INTEGER.
    DEFINE VAR balance_begin AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    DEFINE VAR balance_end AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    
           Y = YEAR(TODAY).
           m = MONTH(TODAY).
    FOR FIRST acd_det WHERE acd_acc = ac  AND acd_year <= Y NO-LOCK: END.
    IF NOT AVAILABLE acd_det THEN ASSIGN balance_begin = 0.00 balance_end = 0.00.
    ELSE DO:
        FOR EACH acd_det WHERE acd_acc = ac AND acd_year <= Y NO-LOCK:

            IF acd_year < Y  THEN 
                balance_end = balance_end + acd_amt.
                
            ELSE DO:
                
                IF acd_per = 0  THEN
                    RETURN.
               
                IF acd_per < m THEN DO:
                    balance_end = balance_end + acd_amt.
                   IF acd_per <> m - 1 THEN 
                       a = 0 .
                   ELSE
                       a = acd_amt.
                END.
                   
            END.
                   
        END.  
    END.
    balance_begin = balance_end - a .
    if period="begin" then 
    return(balance_begin).
    else
    return(balance_end).
    /*record1 = title1 + '"' + na + '"'+ " " + STRING(balance_begin) + " " + STRING(balance_end).
    PUT UNFORMATTED record1 .
    PUT SKIP.*/
END Function.


Function fpbalance RETURN DECIMAL (INPUT fp AS int , INPUT period AS CHAR,input isc as log):
 
DEFINE BUFFER fm_mstr01 FOR fm_mstr.
 FOR FIRST fm_mstr01 WHERE fm_sums_into = fp  NO-LOCK: END.
   IF NOT AVAILABLE fm_mstr  THEN DO:
    FOR EACH ac_mstr WHERE ac_mstr.ac_fpos = fp NO-LOCK :
               IF  AVAILABLE ac_mstr THEN 
               DO:
                 if period="begin" then ac_sum= ac_sum + accbalance(ac_mstr.ac_code,"begin").
                 if period="end" then ac_sum= ac_sum + accbalance(ac_mstr.ac_code,"end").
                
                 
               END.
           END.
   RETURN ac_sum.

  END.
   ELSE DO:
       /* FOR EACH fm_mstr WHERE fm_sums_into = fp NO-LOCK: 
           fp = fm_fpos.
           fpbalance (fp,period).
       END.*/
      FOR EACH fm_mstr01 WHERE fm_sums_into = fp  NO-LOCK:
      
         if not isc then DO:
         FOR EACH ac_mstr WHERE ac_mstr.ac_fpos = fp NO-LOCK :
               IF AVAILABLE ac_mstr THEN 
                DO:
                
                 if period="begin" then ac_sum=ac_sum + accbalance(ac_mstr.ac_code,"begin").
                 if period="end" then ac_sum=ac_sum + accbalance(ac_mstr.ac_code,"end").
              
               END. 
        
          END. 
         isc=YES.
          
           end.
         fp = fm_fpos.
          
          fpbalance(fp,period,NO).
        end. 
  
  
   END.
   return ac_sum.
END Function. 
OUTPUT TO c:\Q_ZCFZ.TXT.
temp = fpbalance(11200,"begin",NO).
put temp.
OUTPUT CLOSE.
