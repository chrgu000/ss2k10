/*{mfdtitle.i}*/
DEFINE VAR entity LIKE acd_entity.
DEFINE VAR mperiod LIKE acd_per.
DEFINE VAR myear AS INT FORMAT "9999".
DEFINE VAR path AS CHAR.
DEFINE VAR curr AS CHAR.
DEF  VAR mstr1 AS CHAR  .
DEF  VAR mstr2 AS CHAR.
DEF  VAR mstr3 AS CHAR.
DEF  VAR mstr4 AS CHAR.
DEF  VAR mstr5 AS CHAR.
DEF  VAR mstr6 AS CHAR.
DEF TEMP-TABLE acc 
    FIELD macct  AS CHAR FORMAT "X(8)"
    FIELD mactyp AS CHAR FORMAT "x(8)".
FORM
    SKIP(0.5)
    entity COLON 12 
    mperiod COLON 35 LABEL "Period"
    myear COLON 50 LABEL "Year"
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

UPDATE entity mperiod  path WITH FRAME a.
 /*IF FRAME-FIELD = "entity" THEN DO:*/
      IF entity = '' THEN do:
          entity = gl_entity.
        DISPLAY entity WITH FRAME a.
      END.
      /*  END.*/
/* IF FRAME-FIELD = "mperiod" THEN DO:*/
    IF mperiod = ? THEN do:
        mperiod = glc_per.
     DISPLAY entity WITH FRAME a.
     
         end.
        /* END.*/
    /* IF FRAME-FIELD = "path" THEN DO:*/
       IF path = "" THEN do:
           path = "c:\".
         DISPLAY path WITH FRAME a.
               end.
             /*  END.*/ 
INPUT FROM "c:\kjkm.txt".
REPEAT :
    CREATE acc.
    IMPORT DELIMITER "	" macct mstr1 mstr2 mstr3 mstr4 mstr5 mstr6  mactyp .
   

    END.
    FOR EACH acc:
        DISP acc WITH 1 COLUMN.
    END.
path = path + "KMYE.TXT".               
OUTPUT TO value(path) .

    FOR EACH qad_wkfl WHERE qad_key1 = 'cas'   NO-LOCK :
 
 
FIND ac_mstr WHERE ac_mstr.ac_code = qad_wkfl.qad_charfld[2]   NO-LOCK NO-ERROR.
IF AVAILABLE ac_mstr THEN curr = ac_mstr.ac_curr.
   ELSE curr = gl_base_curr.
FIND FIRST acc WHERE macct = qad_wkfl.qad_key2 NO-LOCK NO-ERROR.
 RUN balance(qad_wkfl.qad_key2,qad_wkfl.qad_charfld[2],qad_wkfl.qad_key4,curr,mperiod,myear,entity,mactyp).
END.

OUTPUT CLOSE.
MESSAGE "KMYE has built!" VIEW-AS ALERT-BOX BUTTON OK. 
END.
PROCEDURE balance:
    DEFINE INPUT PARAMETER xacc AS CHAR.
     DEFINE INPUT PARAMETER macc AS CHAR.
    DEFINE INPUT PARAMETER mactype AS CHAR.
     DEFINE INPUT PARAMETER mac_curr AS CHAR.
   DEFINE INPUT PARAMETER mperiod AS INT.
     DEFINE INPUT PARAMETER myear AS INTEGER FORMAT "9999".
      DEFINE INPUT PARAMETER entity AS char. 
      DEF INPUT PARAMETER mdir AS CHAR.
      /*define buffer ac_mstr01 for ac_mstr.*/
    DEFINE VAR per_bal AS INT INITIAL "0".
    DEFINE VAR per_bal_curr AS INT INITIAL "0".
    
    DEFINE VAR sys_date AS DATE.
   
   /* DEFINE VAR m AS INTEGER.*/
    DEFINE VAR it_num AS CHAR FORMAT "x(30)".
    DEFINE VAR it_curr AS CHAR FORMAT "x(14)".
    DEFINE VAR it_addtion AS CHAR FORMAT "x(255)".
    DEFINE VAR it_amt_begin AS DECIMAL FORMAT ">>,>>>,>>>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    DEFINE VAR it_amt_curr_begin AS DECIMAL FORMAT ">>,>>>,>>>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    DEFINE VAR it_amt_dr AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    DEFINE VAR it_amt_cr AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    DEFINE VAR it_amt_curr_dr AS DECIMAL FORMAT " >>>,>>>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    DEFINE VAR it_amt_curr_cr AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    DEFINE VAR it_amt_end AS DECIMAL FORMAT ">>,>>>,>>>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    DEFINE VAR it_amt_curr_end AS DECIMAL FORMAT ">>,>>>,>>>,>>>,>>>,>>>,9.99" INITIAL "0.00".
    DEFINE VAR it_per AS CHAR FORMAT "x(2)".
  /* DEFINE VAR mactype AS CHAR FORMAT "x(2)".*/
    DEFINE VAR it AS CHAR FORMAT "x(400)".

   
          /* m = MONTH(TODAY).*/
        
    /*for each ac_mstr01 where ac_code = t no-lock: 
    mactype = ac_type.
    end.*/
    FIND FIRST gl_ctrl NO-LOCK NO-ERROR. 
    ASSIGN it_num = xacc
                   
                   it_addtion = ""
                   it_per = string(mperiod).
            IF mac_curr <> gl_base_curr THEN it_curr = mac_curr.
                  ELSE
                      it_curr = gl_base_curr. 
    if mactype = "A" or mactype = "L" then do:
    FIND FIRST acd_det WHERE 
       /* IF  length(xacc) = 4 THEN  acd_acc BEGINS macc
             ELSE
                 IF length(xacc) = 6 THEN acd_acc BEGINS macc
                   ELSE
                       acd_acc = macc */ acd_acc BEGINS macc
         AND acd_year <= myear AND acd_entity = entity NO-LOCK NO-ERROR.
    IF NOT AVAILABLE acd_det THEN do:
        ASSIGN it = '"' + it_num + '"'+ CHR(09) + '"' + it_curr + '"' + CHR(09) + '"' + it_addtion + '"' + CHR(09) + 
        String(0.00) + chr(09) + string(0.00) + CHR(09) + String(0.00) + 
        CHR(09) + string(0.00) + chr(09) + STRING(0.00) + CHR(09) +  string(0.00) + 
        CHR(09) + string(abs(0.00)) + CHR(09) + STRING(0.00) + CHR(09) +  string(0.00) + CHR(09) + string(0.00) + chr(09) + 
        string(0.00) + chr(09) + string(0.00) + CHR(09) + '"' + it_per + '"'.
     PUT SKIP.   
     PUT UNFORMAT it.
    END.
    ELSE DO:
        FOR EACH acd_det WHERE /*IF  length(xacc) = 4 THEN substring(acd_acc,1,LENGTH(macc)) = macc 
             ELSE
                 IF length(xacc) = 6 THEN SUBSTRING(acd_acc,1,LENGTH(macc)) = macc
                   ELSE
                        acd_acc = macc AND */ acd_acc BEGINS macc AND acd_year <= myear AND acd_entity = entity NO-LOCK:
         
          
             IF acd_year = myear AND acd_per = mperiod THEN   DO:   
        
                 
                 IF mac_curr <> gl_base_curr THEN DO:
                       it_amt_curr_dr = it_amt_curr_dr + acd_dr_curr_amt.
                      
                        
                        it_amt_curr_cr = it_amt_curr_cr + acd_cr_curr_amt.
                         it_amt_dr = it_amt_dr + acd_dr_amt.

                  it_amt_cr = it_amt_cr + acd_cr_amt. 
                        
                        
                       END.
                  ELSE  do:
                      it_amt_dr = it_amt_dr + acd_dr_amt.

                  it_amt_cr = it_amt_cr + acd_cr_amt. 
                  END.
                 END. 

            IF acd_year < myear  THEN DO: 
               IF mac_curr <> gl_base_curr THEN DO: 
                    it_amt_begin = it_amt_begin + acd_amt.
                    it_amt_curr_begin = it_amt_curr_begin + acd_curr_amt.
                    it_amt_curr_end = it_amt_curr_end + acd_curr_amt. 
                    it_amt_end = it_amt_end + acd_amt.
                                                     END.
                  ELSE DO:
                       it_amt_begin = it_amt_begin + acd_amt.
                      it_amt_end = it_amt_end + acd_amt.
                      
                      
                      END.
            END.
               
            ELSE DO:
                
              /*  IF acd_per = 0  THEN
                    RETURN.*/
               
                IF acd_per < mperiod THEN DO:
                    IF mac_curr <> gl_base_curr THEN  DO:
                          it_amt_begin = it_amt_begin + acd_amt.
                        it_amt_curr_begin = it_amt_curr_begin + acd_curr_amt.
                        
                       END.   
                  else
                      it_amt_begin = it_amt_begin + acd_amt.
                END.
                IF acd_per <= mperiod THEN DO:
                
                     IF mac_curr <> gl_base_curr THEN  DO:
                          it_amt_end = it_amt_end + acd_amt.
                        it_amt_curr_end = it_amt_curr_end + acd_curr_amt.
                        
                       END.   
                  else
                      it_amt_end = it_amt_end + acd_amt.
                    
                    
                    
                    
                    
                    END.
                      
                      
                     
                END.
                   
            END.
                   
        END.  
    
   /* it_amt_begin = it_amt_end - per_bal .
    it_amt_curr_begin = it_amt_curr_end - per_bal_curr .*/
    /* FIND FIRST acc WHERE macct = it_num NO-LOCK NO-ERROR.*/
      IF mdir = '´û' THEN DO:
        it_amt_begin = it_amt_begin * (-1).
         it_amt_curr_begin = it_amt_curr_begin * (-1).
        it_amt_end = it_amt_end * (-1).
        it_amt_curr_end = it_amt_curr_end * (-1).  
        END.
        
        ASSIGN it = '"' + it_num + '"'+ CHR(09) + '"' + it_curr + '"' + CHR(09) + '"' + it_addtion + '"' + CHR(09) + 
        String(it_amt_begin) + chr(09) + string(0.00) + CHR(09) + String(it_amt_curr_begin) + 
        CHR(09) + string(it_amt_dr) + chr(09) + STRING(0.00) + CHR(09) +  string(it_amt_curr_dr) + 
        CHR(09) + string(abs(it_amt_cr)) + CHR(09) + STRING(0.00) + CHR(09) +  string(abs(it_amt_curr_cr)) + CHR(09) + string(it_amt_end) + chr(09) + 
        string(0.00) + chr(09) + string(it_amt_curr_end) + CHR(09) + '"' + it_per + '"'.
     PUT SKIP.   
     PUT UNFORMAT it.
    
end.
ELSE DO:
     FIND FIRST acd_det WHERE  /*IF  length(xacc) = 4 THEN substring(acd_acc,1,LENGTH(macc)) = macc 
             ELSE
                 IF length(xacc) = 6 THEN SUBSTRING(acd_acc,1,LENGTH(macc)) = macc
                   ELSE
                        acd_acc = macc AND*/  acd_acc BEGINS macc  AND acd_year = myear AND acd_entity = entity NO-LOCK no-error.
    IF NOT AVAILABLE acd_det THEN do:
        ASSIGN it = '"' + it_num + '"'+ CHR(09) + '"' + it_curr + '"' + CHR(09) + '"' + it_addtion + '"' + CHR(09) + 
        String(0.00) + chr(09) + string(0.00) + CHR(09) + String(0.00) + 
        CHR(09) + string(0.00) + chr(09) + STRING(0.00) + CHR(09) +  string(0.00) + 
        CHR(09) + string(abs(0.00)) + CHR(09) + STRING(0.00) + CHR(09) +  string(0.00) + CHR(09) + string(0.00) + chr(09) + 
        string(0.00) + chr(09) + string(0.00) + CHR(09) + '"' + it_per + '"'.
     PUT SKIP.   
     PUT UNFORMAT it.
    END.
    ELSE DO:
        FOR EACH acd_det WHERE /* IF  length(xacc) = 4 THEN substring(acd_acc,1,LENGTH(macc)) = macc 
             ELSE
                 IF length(xacc) = 6 THEN SUBSTRING(acd_acc,1,LENGTH(macc)) = macc
                   ELSE
                     acd_acc = macc  AND */ acd_acc BEGINS macc AND acd_year = myear  AND acd_entity = entity NO-LOCK:
            
             IF acd_per = mperiod THEN   DO:   
           
                   IF mac_curr <> gl_base_curr THEN DO:
                       it_amt_curr_dr = it_amt_curr_dr + acd_dr_curr_amt.
                      
                        
                        it_amt_curr_cr = it_amt_curr_cr + acd_cr_curr_amt.
                         it_amt_dr = it_amt_dr + acd_dr_amt.

                  it_amt_cr = it_amt_cr + acd_cr_amt. 
                        
                        
                        END.
                  ELSE  do:
                      it_amt_dr = it_amt_dr + acd_dr_amt.

                  it_amt_cr = it_amt_cr + acd_cr_amt. 
                  END.
                 END. 

     IF acd_year < myear  THEN DO: 
                it_amt_end = it_amt_end + acd_amt.
                it_amt_curr_end = it_amt_curr_end + acd_curr_amt.
            END.
               
            ELSE DO:
                
              /*  IF acd_per = 0  THEN
                    RETURN.*/
               
                IF acd_per < mperiod THEN DO:
                    IF mac_curr <> gl_base_curr THEN  DO:
                          it_amt_begin = it_amt_begin + acd_amt.
                        it_amt_curr_begin = it_amt_curr_begin + acd_curr_amt.
                        
                       END.   
                  else
                      it_amt_begin = it_amt_begin + acd_amt.
                END.
                IF acd_per <= mperiod THEN DO:
                
                    IF mac_curr <> gl_base_curr THEN  DO:
                          it_amt_end = it_amt_end + acd_amt.
                        it_amt_curr_end = it_amt_curr_end + acd_curr_amt.
                        
                       END.   
                  else
                      it_amt_end = it_amt_end + acd_amt.
                    
                    
                    
                    
                    
                    END.
                       
                END.
                   
            END.
                   
        END.  
    
   /* it_amt_begin = it_amt_end - per_bal .
    it_amt_curr_begin = it_amt_curr_end - per_bal_curr .*/
    /* FIND FIRST acc WHERE macct = it_num NO-LOCK NO-ERROR.*/
      IF mdir = '´û' THEN DO:
        it_amt_begin = it_amt_begin * (-1).
         it_amt_curr_begin = it_amt_curr_begin * (-1).
        it_amt_end = it_amt_end * (-1).
        it_amt_curr_end = it_amt_curr_end * (-1).  
        END.
        ASSIGN it = '"' + it_num + '"'+ CHR(09) + '"' + it_curr + '"' + CHR(09) + '"' + it_addtion + '"' + CHR(09) + 
        String(it_amt_begin) + chr(09) + string(0.00) + CHR(09) + String(it_amt_curr_begin) + 
        CHR(09) + string(it_amt_dr) + chr(09) + STRING(0.00) + CHR(09) +  string(it_amt_curr_dr) + 
        CHR(09) + string(abs(it_amt_cr)) + CHR(09) + STRING(0.00) + CHR(09) +  string(abs(it_amt_curr_cr)) + CHR(09) + string(it_amt_end) + chr(09) + 
        string(0.00) + chr(09) + string(it_amt_curr_end) + CHR(09) + '"' + it_per + '"'.
     PUT SKIP.
        PUT UNFORMAT it.

    END.
 END PROCEDURE.
