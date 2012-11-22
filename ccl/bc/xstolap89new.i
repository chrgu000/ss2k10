   FUNCTION CALLBYLAP89 RETURNS CHARACTER (
     INPUT  wPramar1     AS character,
     INPUT  wPramar2     AS character,
     INPUT  wType        AS character,
     INPUT  wPramar4     AS CHARACTER).


     DEF VARIABLE i AS INTEGER.
     DEFINE VARIABLE wRESULT AS CHAR.
     DEFINE VARIABLE w-w AS INTEGER.


     /* wParamar3 is Return TYPE 
        1. GET MODEL 
        2. */

     CASE wType:
           WHEN "1" THEN
  DO:
               /*Parmar1 is Item No, Return Model No */
                 w-w = 0.
                 wResult = "".
                 DO i = 1 to length(wPramar1).
                    IF substring(wPramar1,i,1) = "-" THEN w-w = w-w + 1.
                    wRESULT = wRESULT + substring(wPramar1,i,1).
                    IF w-w = 3 AND  substring(wPramar1,i,1) <> "-"  THEN do:
                        IF substring(wPramar1,i,1) = "0" THEN  wRESULT = SUBSTRING( wRESULT , 1 ,LENGTH(wRESULT) - 2 ) . 
                        LEAVE.
                    END.
                 END.
           END.
               
               
  
           WHEN "2" THEN  
DO: 
               /*Parmar1 is Pt_desc1 + pt_desc2 , Return "SAMPLE 230-240~" */



               /* wResult = "IPS 230-240~*373W*1/2HP50Hz  1ph". */
               w-w = 0.
               wResult = "".
               DO i = 1 to length(wPramar1).
                  IF w-w = 1  THEN  wResult = wResult + substring(wPramar1,i,1).

                  IF substring(wPramar1,i,1) ="" OR  substring(wPramar1,i,1) = "*" THEN w-w = w-w + 1.
               END.
               wRESULT = SUBSTRING( wRESULT , 1 ,LENGTH(wRESULT) - 2 ).


           END.
           WHEN "3" THEN  
DO: 
                        /*Parmar1 is Pt_desc1 + pt_desc2 , Return "SAMPLE 373W" */



                        /* wResult = "IPS 230-240~*373W*1/2HP50Hz  1ph". */
                        w-w = 0.
                        wResult = "".
                        DO i = 1 to length(wPramar1).
                           IF w-w = 1  THEN  wResult = wResult + substring(wPramar1,i,1).

                           IF substring(wPramar1,i,1) = "*" THEN w-w = w-w + 1.
                        END.
                        wRESULT = SUBSTRING( wRESULT , 1 ,LENGTH(wRESULT) - 1 )
.

           END.
           WHEN "4" THEN  
DO: 
                            /*Parmar1 is Pt_desc1 + pt_desc2 , Return "SAMPLE 1/2HP50Hz 1ph" */



                            /* wResult = "IPS 230-240~*373W*1/2HP50Hz  1ph". */
                            w-w = 0.
                            wResult = "".
                            DO i = 1 to length(wPramar1).
                               IF w-w = 2  THEN  wResult = wResult + substring(wPramar1,i,1).

                               IF substring(wPramar1,i,1) = "*" THEN w-w = w-w + 1.
                            END.
                            IF LENGTH(wResult) = 11 THEN wResult = "  " + wResult.



           END.
           WHEN "5" THEN  
DO:
               /* Parmar1 is Date Return WMMYY*/


                DEFINE VARIABLE aa AS DATE INIT TODAY.
                DEFINE VARIABLE aakk AS CHAR.
                
                
                DEFINE VARIABLE tmp AS DEC.
                
                
                
                aakk = "".

                if weekday( date (wPramar1) ) = 1 then aakk = "7" . 
                else aakk =  string (weekday( date (wPramar1) ) - 1 ). /* WeekDay */
                wRESULT = aakk.
                


                AA = DATE ( 1,1,YEAR(Date(wPramar1))) .
                tmp  = (DATE(wpramar1) - aa - 1 + WEEKDAY(aa) ) / 7 + 1.
                IF INT(tmp) - tmp > 0 THEN
                    aakk = STRING ( INT(tmp)  - 1 ).
                ELSE aakk = STRING ( INT (tmp) ).
                aakk = SUBSTRING(aakk,2,1) + SUBSTRING(aakk,1,1)  .     /*Week*/
                

                wRESULT = wRESULT + aakk.
                
                aakk = substring ( wPramar1, length(wPramar1) - 1 , 2) . /* Year */
                aakk = SUBSTRING(aakk,2,1) + SUBSTRING(aakk,1,1)  .

                

                
                wRESULT = wRESULT + aakk.             /*Weekday + Week + Year*/           
                
              


           END.
           WHEN "6" THEN  
DO:
               /*parmar1 is MODEL@WEEKDAYWEEKYEAR ,
                 Parmar3 is TYPE = 6
                 RETURN NEXT NO
                 
               QAD_KEY2 = MODEL_WEEKDAY_WEEK_YEAR_START_END.
               QAD_CHARFLD[1] = START NO.
               QAD_CHARFLD[2] = END NO.
               QAD_CHARFLD[3] = NEXT NO.
               QAD_CHARFLD[4] = WO.
               */

               FIND LAST QAD_WKFL where QAD_KEY1 = "BARCODE_MODEL_WEEKDAY_WEEK_YEAR_START_END" 
                                    and QAD_KEY2 >= trim(wPramar1)  no-error.
               IF  AVAILABLE(QAD_WKFL) Then Do:
                   wRESULT = QAD_CHARFLD[3]   /* NEXT NO */.
               END.
               ELSE DO:
                  wRESULT = "001".
               END.

           END.




           WHEN "7" THEN  
DO:
               /*parmar1 is MODEL@WEEKDAYWEEKYEAR@START@END ,
                 parmar2 is WO 
                 Parmar3 is TYPE = 7
                 parmar4 is MODEL@WEEKDAYWEEKYEAR
                 WRITE TO DB
                 
               QAD_KEY2 = MODEL_WEEKDAY_WEEK_YEAR_START_END.
               QAD_CHARFLD[1] = START NO.
               QAD_CHARFLD[2] = END NO.
               QAD_CHARFLD[3] = NEXT NO.
               QAD_CHARFLD[4] = WO.
              */
                   FIND LAST QAD_WKFL where QAD_KEY1 = "BARCODE_MODEL_WEEKDAY_WEEK_YEAR_START_END" 
                                        and QAD_KEY2 >= trim(wPramar4)  no-error.
                   IF  AVAILABLE(QAD_WKFL) Then Do:
                       wRESULT = QAD_CHARFLD[3] /* NEXT NO */.
                   END.
                   ELSE DO:
                      wRESULT = "001".
                   END.
		   
                   IF  ENTRY(3, wPramar1, "@") = wRESULT  THEN  DO:
                   
                       CREATE QAD_WKFL.
                       ASSIGN QAD_KEY1 = "BARCODE_MODEL_WEEKDAY_WEEK_YEAR_START_END"
                              QAD_KEY2 = wPramar1
                              QAD_CHARFLD[1] = ENTRY (3,wPramar1,"@")
                              QAD_CHARFLD[2] = ENTRY (4,wPramar1,"@")
                              QAD_CHARFLD[3] = STRING ( INTEGER ( ENTRY (4,wPramar1,"@") ) + 1 ,"999")
                              QAD_CHARFLD[4] = wPramar2.
                             
                   END.


       


             END.

     
END CASE.

     RETURN   wRESULT.
    END FUNCTION.



/*

    /* DISPLAY  CALLBYLAP89 ("FWD-050SS-A-923456","","1") FORMAT "x(30)". */
    DISPLAY  CALLBYLAP89 ("FWD-0550SSA-1@21280","","6","") FORMAT "x(40)". 
    DISPLAY  CALLBYLAP89 ("FWD-0550SSA-1@21280@008@010","WO321","7","FWD-0550SSA-1@21280") FORMAT "x(40)". 
                       

*/