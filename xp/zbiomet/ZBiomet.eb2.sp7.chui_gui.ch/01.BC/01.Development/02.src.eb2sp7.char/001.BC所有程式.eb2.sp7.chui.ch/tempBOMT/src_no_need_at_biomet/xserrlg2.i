Define variable Eoutputstatment2 AS CHARACTER FORMAT "x(200)".
Define variable Eonetime2        AS CHARACTER FORMAT "x(1)" init "N".
Eonetime2        = "N".
Eoutputstatment2 = "".

PROCEDURE datain2.

Define variable outputstatment2 AS CHARACTER FORMAT "x(200)".
input from value ( ciminputfile2) .
output to  value ( "log.bc") APPEND.
put  unformatted skip(1) .
put  unformatted skip today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile2 " ".

    Do While True:
          IMPORT UNFORMATTED outputstatment2.
            put unformatted outputstatment2 "@".
	    Eoutputstatment2 =  Eoutputstatment2 + "@"  +  trim ( outputstatment2 ).


    End.
            put unformatted skip .

input close.
output close.
END PROCEDURE.
run datain2.

PROCEDURE dataout2.

Define variable woutputstatment2 AS CHARACTER .
input from value ( cimoutputfile2) .
    Do While True:
          IMPORT UNFORMATTED woutputstatment2.

	  IF index (woutputstatment2,"ERROR:")   <> 0 OR    /* for us langx */
	     index (woutputstatment2,"´íÎó:")	<> 0 OR    /* for ch langx */        
	     index (woutputstatment2,"¿ù»~:")	<> 0 OR    /* for tw langx */
         /*  
         index (woutputstatment2,"WARNING:") <> 0 OR 
         index (woutputstatment2,"¾¯¸æ:")    <> 0 OR 
         index (woutputstatment2,"Äµ§i")	    <> 0 OR 
         */           
      	 index (woutputstatment2,"(87)")	    <> 0 OR      
	     index (woutputstatment2,"(557)")	<> 0 OR      
      	 index (woutputstatment2,"(143)")	<> 0      
	     then do:
		  if Eonetime2 = "N" then do :
		     output to  value ( "log.err") APPEND.
		     put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile2 " " Eoutputstatment2  skip.
		     Eonetime2 = "Y".
                     output close.
		  end.
		  output to  value ( "log.bc") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile2 " " woutputstatment2  skip.
	          output close.

		  output to  value ( "log.err") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile2 " " woutputstatment2  skip.
	          output close.

	     end.



    End.
input close.
output close.
END PROCEDURE.
run dataout2.