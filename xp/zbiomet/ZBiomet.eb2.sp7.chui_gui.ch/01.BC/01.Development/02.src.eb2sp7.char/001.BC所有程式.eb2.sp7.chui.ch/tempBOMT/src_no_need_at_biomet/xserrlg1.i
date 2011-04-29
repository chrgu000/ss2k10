Define variable Eoutputstatment1 AS CHARACTER FORMAT "x(200)".
Define variable Eonetime1        AS CHARACTER FORMAT "x(1)" init "N".
Eonetime1        = "N".
Eoutputstatment1 = "".

PROCEDURE datain1.

Define variable outputstatment1 AS CHARACTER FORMAT "x(200)".
input from value ( ciminputfile1) .
output to  value ( "log.bc") APPEND.
put  unformatted skip(1) .
put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile1 " ".

    Do While True:
          IMPORT UNFORMATTED outputstatment1.
            put unformatted outputstatment1 "@".
	    Eoutputstatment1 =  Eoutputstatment1 + "@"  +  trim ( outputstatment1 ).

    End.
            put unformatted skip .

input close.
output close.
END PROCEDURE.
run datain1.
PROCEDURE dataout1.

Define variable woutputstatment1 AS CHARACTER .
input from value ( cimoutputfile1) .
    Do While True:
          IMPORT UNFORMATTED woutputstatment1.

	  IF index (woutputstatment1,"ERROR:")   <> 0 OR    /* for us langx */
	     index (woutputstatment1,"´íÎó:")	<> 0 OR    /* for ch langx */        
	     index (woutputstatment1,"¿ù»~:")	<> 0 OR    /* for tw langx */
         /*  
         index (woutputstatment1,"WARNING:") <> 0 OR 
         index (woutputstatment1,"¾¯¸æ:")    <> 0 OR 
         index (woutputstatment1,"Äµ§i")	    <> 0 OR 
         */           
      	 index (woutputstatment1,"(87)")	    <> 0 OR      
	     index (woutputstatment1,"(557)")	<> 0 OR      
      	 index (woutputstatment1,"(143)")	<> 0         
	     then do:
		  if Eonetime1 = "N" then do :
		     output to  value ( "log.err") APPEND.
		     put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile1 " " Eoutputstatment1  skip.
		     Eonetime1 = "Y".
                     output close.
		  end.
		  output to  value ( "log.bc") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile1 " " woutputstatment1  skip.
	          output close.

		  output to  value ( "log.err") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile1 " " woutputstatment1  skip.
	          output close.

	     end.




    End.
input close.
END PROCEDURE.
run dataout1.