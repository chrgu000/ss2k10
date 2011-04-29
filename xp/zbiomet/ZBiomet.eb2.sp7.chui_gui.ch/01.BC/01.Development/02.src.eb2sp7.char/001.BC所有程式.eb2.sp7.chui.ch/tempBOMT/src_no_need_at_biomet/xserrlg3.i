Define variable Eoutputstatment3 AS CHARACTER FORMAT "x(200)".
Define variable Eonetime3        AS CHARACTER FORMAT "x(1)" init "N".
Eonetime3        = "N".
Eoutputstatment3 = "".

PROCEDURE datain3.

Define variable outputstatment3 AS CHARACTER FORMAT "x(200)".
input from value ( ciminputfile3) .
output to  value ( "log.bc") APPEND.
put  unformatted skip(1) .
put  unformatted skip today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile3 " ".

    Do While True:
          IMPORT UNFORMATTED outputstatment3.
            put unformatted outputstatment3 "@".
	    Eoutputstatment3 =  Eoutputstatment3 + "@"  +  trim ( outputstatment3 ).


    End.
            put unformatted skip .

input close.
output close.
END PROCEDURE.
run datain3.

PROCEDURE dataout3.

Define variable woutputstatment3 AS CHARACTER .
input from value ( cimoutputfile3) .
    Do While True:
          IMPORT UNFORMATTED woutputstatment3.

	  IF index (woutputstatment3,"ERROR:")   <> 0 OR    /* for us langx */
	     index (woutputstatment3,"´íÎó:")	<> 0 OR    /* for ch langx */        
	     index (woutputstatment3,"¿ù»~:")	<> 0 OR    /* for tw langx */
         /*  
         index (woutputstatment3,"WARNING:") <> 0 OR 
         index (woutputstatment3,"¾¯¸æ:")    <> 0 OR 
         index (woutputstatment3,"Äµ§i")	    <> 0 OR 
         */           
      	 index (woutputstatment3,"(87)")	    <> 0 OR      
	     index (woutputstatment3,"(557)")	<> 0 OR      
      	 index (woutputstatment3,"(143)")	<> 0       
	     then do:
		  if Eonetime3 = "N" then do :
		     output to  value ( "log.err") APPEND.
		     put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile3 " " Eoutputstatment3  skip.
		     Eonetime3 = "Y".
                     output close.
		  end.
		  output to  value ( "log.bc") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile3 " " woutputstatment3  skip.
	          output close.

		  output to  value ( "log.err") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile3 " " woutputstatment3  skip.
	          output close.
             end.
        


    End.
input close.
output close.
END PROCEDURE.
run dataout3.