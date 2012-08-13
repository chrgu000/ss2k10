{mfdtitle.i}
DEFINE VAR line AS INT initial "1".
DEFINE VAR record AS CHAR FORMAT "x(250)".
DEFINE VAR record1 AS CHAR FORMAT "x(250)".
DEFINE VAR title1 AS CHAR FORMAT "x(106)".
DEFINE VAR sys_date AS DATE INITIAL TODAY.
DEFINE VAR mh AS CHAR FORMAT "x(2)".
DEFINE VAR dy AS CHAR FORMAT "x(2)".
DEFINE VAR vdate AS CHAR FORMAT "x(10)".
DEFINE VAR massets_begin AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE VAR massets_end AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE VAR mpl_begin AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE BUFFER fm_mstr01 FOR fm_mstr.

DEFINE VAR mpl_end AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE VAR ac_sum AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE VAR entity LIKE acd_entity.
DEFINE VAR mperiod LIKE acd_per.
DEFINE VAR myear AS INT FORMAT "9999".
DEFINE VAR path AS CHAR.
FORM
    SKIP(0.5)
    entity COLON 12 
    mperiod COLON 35
    myear COLON 50
      SKIP(1)
    path COLON 65 LABEL "Output Path"
    WITH FRAME a  WIDTH 80 THREE-D SIDE-LABELS.

ASSIGN /*sys_date = TODAY*/
          myear = YEAR(TODAY).
 FIND FIRST gl_ctrl NO-LOCK NO-ERROR.  
 entity = gl_entity.
 FIND FIRST glc_cal WHERE glc_start <= TODAY AND glc_end >= TODAY NO-LOCK NO-ERROR.
 mperiod = glc_per.
 DISPLAY myear WITH FRAME a.     
REPEAT:

UPDATE entity mperiod path  WITH FRAME a.
  /*IF FRAME-FIELD = "entity" THEN DO:*/
      IF entity = '' THEN do:
          entity = gl_entity.
        DISPLAY entity WITH FRAME a.
      END.
       /* END.*/
 /*IF FRAME-FIELD = "mperiod" THEN DO:*/
    IF mperiod = ? THEN do:
        mperiod = glc_per.
     DISPLAY entity WITH FRAME a.
     
         end.
        /*  END. */
     /* IF FRAME-FIELD = "path" THEN DO:*/
       IF path = "" THEN do:
           path = "c:\".
         DISPLAY path WITH FRAME a.
               end.
              /*  END.*/

IF LENGTH(string(MONTH(sys_date)))=1 THEN mh="0"+ STRING(MONTH(sys_date)).
        ELSE mh =string(MONTH(sys_date)).
IF LENGTH(string(DAY(sys_date)))=1 THEN dy="0"+ string(DAY(sys_date)).
        ELSE dy =string(DAY(sys_date)).

ASSIGN vdate= string(INTEGER (YEAR(sys_date))) + mh + dy
       title1 = '"' + "会计01表" + '"' + chr(09) + '"' + "****公司" + '"' + chr(09) + '"' + vdate + '"' + chr(09) + '"'+ "元" + '"'.
Function accbalance RETURN DECIMAL (INPUT ac AS CHAR , INPUT period AS CHAR,INPUT mactype AS CHAR):

    DEFINE VAR per_bal AS INT INITIAL "0".
   /* DEFINE VAR Y AS INTEGER FORMAT "9999".*/
    /*DEFINE VAR m AS INTEGER.*/
    DEFINE VAR balance_begin AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    DEFINE VAR balance_end AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".

          /* Y = YEAR(TODAY).
           m = MONTH(TODAY).*/
    /*for each ac_mstr where ac_code = ac no-lock: 
    mactype = ac_type.
    end.*/
  
    FIND FIRST acd_det WHERE acd_acc = ac  AND acd_year = myear AND acd_entity = entity NO-LOCK NO-ERROR.
    IF NOT AVAILABLE acd_det THEN ASSIGN balance_begin = 0.00 balance_end = 0.00.
    ELSE DO:
        FOR EACH acd_det WHERE acd_acc = ac AND acd_year = myear AND acd_entity = entity NO-LOCK:

            IF acd_year < myear  THEN 
                balance_end = balance_end + acd_amt.
                
            ELSE DO:
                
                /*IF acd_per = 0  THEN
                    RETURN.*/
               IF acd_per < mperiod THEN 
                    balance_begin = balance_begin + acd_amt.
                IF acd_per <= mperiod THEN 
                    balance_end = balance_end + acd_amt.
                   
            END.
                   
        END.  
    END.
    
    if period="begin" then 
    return(per_bal).
    else
    return(balance_end).

END Function.


Function fpbalance RETURN DECIMAL (INPUT fp AS int , INPUT period AS CHAR,input isc as log):
   
 FOR FIRST fm_mstr01 WHERE fm_sums_into = fp  NO-LOCK: END.
   IF NOT AVAILABLE fm_mstr01  THEN DO:
    FOR EACH ac_mstr WHERE ac_mstr.ac_fpos = fp NO-LOCK :
               IF  AVAILABLE ac_mstr THEN 
               DO:
                 if period="begin" then ac_sum= ac_sum + accbalance(ac_mstr.ac_code,"begin",ac_mstr.ac_type).
                 if period="end" then ac_sum= ac_sum + accbalance(ac_mstr.ac_code,"end",ac_mstr.ac_type).
                
                 
               END.
           END.
   RETURN ac_sum.

  END.
   ELSE DO:
       /* FOR EACH fm_mstr01 WHERE fm_sums_into = fp NO-LOCK: 
           fp = fm_fpos.
           fpbalance (fp,period).
       END.*/
      FOR EACH fm_mstr01 WHERE fm_sums_into = fp  NO-LOCK:
      
         if not isc then DO:
         FOR EACH ac_mstr WHERE ac_mstr.ac_fpos = fp NO-LOCK :
               IF AVAILABLE ac_mstr THEN 
                DO:
                                if period="begin" then ac_sum = ac_sum + accbalance(ac_mstr.ac_code,"begin",ac_mstr.ac_type).
                 if period="end" then ac_sum = ac_sum + accbalance(ac_mstr.ac_code,"end",ac_mstr.ac_type).
              
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
path = path + "Q_LR.TXT".
OUTPUT TO value(path)  .
RUN icomestatment (0) .


OUTPUT CLOSE.
MESSAGE "Q_LR has built!" VIEW-AS ALERT-BOX BUTTON OK. 
END.
PROCEDURE icomestatment:
  
   /*DEFINE BUFFER ac_mstr01 FOR ac_mstr.*/

   DEFINE INPUT PARAMETER a1 AS INTEGER. 
 /*DEFINE INPUT PARAMETER b1 AS INTEGER.
     DEFINE INPUT PARAMETER isdisplay AS log.
   DEFINE INPUT PARAMETER st AS log.
   DEFINE INPUT PARAMETER direction AS log.
   DEFINE INPUT PARAMETER isc AS log.*/
  DEFINE VAR balance_begin AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
DEFINE VAR balance_end AS DECIMAL FORMAT "->>,>>>,>>>,>>>,9.99" INITIAL "0.00".
 DEFINE var mfp AS INTEGER.
 

 DEFINE var mwrite_begin AS LOG.
 DEFINE var mwrite_end AS LOG.
  DEFINE var first_display AS LOG.
DEFINE VAR seq AS CHAR FORMAT "x(2)".
    DEFINE VAR fm LIKE fm_mstr.fm_fpos.

DEFINE VAR fmdes LIKE fm_mstr.fm_desc.
  mwrite_begin = NO.
                mwrite_end = NO.
FIRST_display = YES.

   FOR FIRST fm_mstr WHERE fm_sums_into = a1 AND (fm_type = "I")  NO-LOCK: END.
   IF NOT AVAILABLE fm_mstr  THEN DO:
   /* FOR EACH ac_mstr01 WHERE ac_mstr01.ac_fpos = a1 NO-LOCK :
               IF AVAILABLE ac_mstr01 THEN 
               DO:
                
                 balance_begin = accbalance(ac_mstr01.ac_code,"begin").
                 balance_end = accbalance(ac_mstr01.ac_code,"end").
                 if ac_mstr01.ac_type = "L"   then do:
                    if balance_begin < 0  then do:
                   balance_begin = abs(balance_begin).
                   mwrite_begin = YES.
                   end.
                   
                    if balance_end < 0  then do: 
                    balance_end = abs(balance_end). 
                    mwrite_end = YES.
                    end.
                 
                 if balance_begin > 0 and not mwrite_begin then balance_begin = balance_begin * (-1).
                   if balance_end > 0 and not mwrite_end then balance_end = balance_end * (-1).
                mwrite_begin = NO.
                mwrite_end = NO.

                 end.
               
                
                 /*RUN q (ac_mstr.ac_desc, ).*/
                PUT SKIP.
                record = title1 + chr(09) + '"' + ac_mstr01.ac_desc + '"' + chr(09) + '"'+ STRING(line) + '"' + chr(09) + string(balance_begin) + chr(09) + string(balance_end).
                line = line + 1.
                 PUT unformat record.

             
                END.            
             
           END.*/
   return.
   end.
ELSE DO:
     FOR EACH fm_mstr WHERE fm_sums_into = a1 AND (fm_type = "I")  NO-LOCK:
            
           mwrite_begin = NO.
                mwrite_end = NO.
               fm = fm_fpos.
               fmdes = fm_desc.

 
         
               RUN icomestatment(INPUT fm_fpos).
       
         
          
             AC_SUM=0.
           balance_begin = fpbalance(fm,"begin",NO).
            
             AC_SUM=0.
            balance_end = fpbalance(fm,"end",NO).
             /*if fm_mstr01.fm_dr_cr = NO  then do:*/
             IF fm <> 900001 THEN DO:
            
            if balance_begin < 0  then do:
                   balance_begin = abs(balance_begin).
                   mwrite_begin = YES.
                   end.
                   
                    if balance_end < 0  then do: 
                    balance_end = abs(balance_end). 
                    mwrite_end = YES.
                    end.
                 
                 if balance_begin > 0 and not mwrite_begin then balance_begin = balance_begin * (-1).
                   if balance_end > 0 and not mwrite_end then balance_end = balance_end * (-1).
                mwrite_begin = NO.
                mwrite_end = NO.
                 /*END.*/
          
           
          
          
           
 
           PUT SKIP. 
           record = title1 + chr(09) + '"' + fmdes + chr(09) + "total" +  '"' + chr(09) + '"'+ STRING(line) + '"' + chr(09) + string(balance_begin) + chr(09) + string(balance_end).
            
             line = line + 1.
       PUT unformat record.
       
     END.     /*end.900001*/
      
   END. /*end for each*/
end.
  
   return. 
END PROCEDURE.

/*PROCEDURE p2:
   DEFINE INPUT PARAMETER a1 AS INTEGER. 
   DEFINE INPUT PARAMETER b1 AS INTEGER.
   FOR FIRST fm_mstr01 WHERE fm_sums_into = a1 AND (fm_type = "B") AND (fm_dr_cr = NO) NO-LOCK: END.
   IF NOT AVAILABLE fm_mstr01 OR b1 > 6 THEN RETURN.
   ELSE DO:
       FOR EACH fm_mstr01 WHERE fm_sums_into = a1 AND (fm_type = "B") AND (fm_dr_cr = NO) NO-LOCK:
           a1= fm_fpos.
           record= title1 + '"' + STRING(b1) + "_" + fm_desc + ":" + '"'.
           PUT unformat record.
           PUT SKIP.
            FOR EACH ac_mstr WHERE ac_mstr.ac_fpos = fm_mstr01.fm_fpos NO-LOCK :
               IF NOT AVAILABLE ac_mstr THEN RETURN.
               ELSE DO:
                 RUN q (ac_mstr.ac_desc,ac_mstr.ac_code ).
                
               END.
           END.
           FOR FIRST fm_mstr0101 WHERE fm_mstr0101.fm_sums_into = a1 NO-LOCK : END.
           IF NOT AVAILABLE fm_mstr01 THEN DO:
           RETURN.
           END.
           ELSE DO:
               RUN p2(INPUT a1,INPUT b1 + 1 ).
           END.
          
       END.
   END.
    
END PROCEDURE.*/

/*Function accbalance RETURN DECIMAL :
    DEFINE INPUT PARAMETER ac AS CHAR.
    DEFINE INPUT PARAMETER period AS CHAR.
    DEFINE VAR a AS INT.
    DEFINE VAR Y AS INTEGER FORMAT "9999".
    DEFINE VAR m AS INTEGER.
    
           Y = YEAR(TODAY).
           m = MONTH(TODAY).
    FOR FIRST acd_det WHERE acd_acc = ac  AND acd_year <= Y NO-LOCK: END.
    IF NOT AVAILABLE acd_det THEN RETURN.
    ELSE DO:
        FOR EACH acd_det WHERE acd_acc = ac AND acd_year <= Y NO-LOCK:

            IF acd_year < Y  THEN 
                amt_end = amt_end + acd_amt.
                
            ELSE DO:
                
                IF acd_per = 0  THEN
                    RETURN.
               
                IF acd_per < m THEN DO:
                    amt_end = amt_end + acd_amt.
                   IF acd_per <> m - 1 THEN 
                       a = 0 .
                   ELSE
                       a = acd_amt.
                END.
                   
            END.
                   
        END.  
    END.
    amt_begin = amt_end - a .
    if period="begin" then 
    return(amt_begin).
    else
    return(amt_end).
    /*record1 = title1 + '"' + na + '"'+ chr(09) + STRING(amt_begin) + chr(09) + STRING(amt_end).
    PUT UNFORMATTED record1 .
    PUT SKIP.*/
END Function.

Function fpbalance RETURN INTEGER (INPUT f AS CHAR , INPUT p AS CHAR ,INPUT IS AS LOGICAL ):
  define input parameter fp as char.
  define input parameter period as char.
  define input parameter iscaculate as logical.

 FOR FIRST fm_mstr01 WHERE fm_sums_into = fp  NO-LOCK: END.
   IF NOT AVAILABLE fm_mstr01  THEN DO:
    FOR EACH ac_mstr WHERE ac_mstr.ac_fpos =fp NO-LOCK :
               IF NOT AVAILABLE ac_mstr THEN 
               ELSE DO:
                 if period="begin" then ac_sum=ac_sum+accbalance(ac_mstr.ac_code,"begin").
                 if period="end" then ac_sum=ac_sum+accbalance(ac_mstr.ac_code,"end").
                
                 
               END.
           END.
   RETURN ac_sum .
   end.
   ELSE DO:
       FOR EACH fm_mstr01 WHERE fm_sums_into = fp  NO-LOCK:
         if not iscaculate then DO:
         FOR EACH ac_mstr WHERE ac_mstr.ac_fpos = fp NO-LOCK :
               IF NOT AVAILABLE ac_mstr THEN 
               ELSE DO:
                 if period="begin" then ac_sum=ac_sum+accbalance(ac_mstr.ac_code,"begin").
                 if period="end" then ac_sum=ac_sum+accbalance(ac_mstr.ac_code,"end").
               END. 
        
          END. 
         iscaculate=1
         end.
         fp= fm_fpos.
          fpbalance(input fp, input period,input 0)
        end. 
  end.
   RETURN ac_sum.
  end Function.*/ 

  /*判断当前日期属于当年的第几周*/
/*一年共有52周*/
/*function getWeeknum return integer (input pDay as date).
    define variable start        as date extent 52.
    define variable weeks        as integer format ">9" extent 52.
    define variable i            as integer.
    define variable POSI         as integer.
    {fcsdate1.i year(today) start[1]}
    weeks[1] = 1.                           
    do i = 2 to 52:
       assign
          weeks[i] = i
          start[i] = start[i - 1] + 7.
    end. 
    do i = 1 to 51:
        if pDay >= start[i] and pDay < start[i + 1] then
            POSI = i.
    end.
    return POSI.
end function.*/
          
               
               
           

       
  

 
