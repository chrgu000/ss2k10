Define variable Eoutputstatment AS CHARACTER FORMAT "x(200)".
Define variable Eonetime        AS CHARACTER FORMAT "x(1)" init "N".
Eonetime        = "N".
Eoutputstatment = "".

PROCEDURE datain.

Define variable outputstatment AS CHARACTER FORMAT "x(200)".
input from value ( ciminputfile) .
output to  value ( "log.edi") APPEND.
put  unformatted skip(1) .
put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile " ".

    Do While True:
          IMPORT UNFORMATTED outputstatment.
            put unformatted outputstatment "@" .
	    Eoutputstatment =  Eoutputstatment + "@"  +  trim ( outputstatment ).

    End.
            put unformatted skip .
input close.
output close.
END PROCEDURE.
run datain.

PROCEDURE dataout.

Define variable woutputstatment AS CHARACTER .
input from value ( cimoutputfile) .
    Do While True:
          IMPORT UNFORMATTED woutputstatment.

	  IF index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */
	     index (woutputstatment,"����:")	<> 0 OR    /* for ch langx */
    	     index (woutputstatment,"ĵ�i")	<> 0 OR    /* for tw langx */
	     index (woutputstatment,"���~:")	<> 0 OR
      	     index (woutputstatment,"(87)")	<> 0 OR      
	     index (woutputstatment,"(557)")	<> 0 OR      
      	     index (woutputstatment,"(143)")	<> 0       
	     
	     then do:
		  if Eonetime = "N" then do :
		     output to  value ( "log.err") APPEND.
		     put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " ciminputfile " " Eoutputstatment  skip.
		     Eonetime = "Y".
                     output close.
		  end.
		  output to  value ( "log.edi") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile " " woutputstatment  skip.
	          output close.

		  output to  value ( "log.err") APPEND.
                  put  unformatted today " " string (time,"hh:mm:ss") " " userid(sdbname('qaddb')) " " cimoutputfile " " woutputstatment  skip.
	          output close.

	     end.


    End.
input close.
END PROCEDURE.
run dataout.