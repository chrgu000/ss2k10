/* $Revision: eB2.1SP5 LAST MODIFIED: 02/23/12 BY: Apple Tam *SS - 20120223.1* */
/* $Revision: eB21SP3 $  BY: Jordan Lin       DATE: 05/30/12  ECO: *SS-20120530.1* */

Define variable Eoutputstatment AS CHARACTER FORMAT "x(200)".
Define variable Eonetime        AS CHARACTER FORMAT "x(1)" init "N".
ciminputfile = usection + ".i".
cimoutputfile = usection + ".o".
Eonetime        = "N".
Eoutputstatment = "".


PROCEDURE datain.

Define variable outputstatment AS CHARACTER FORMAT "x(200)".
input from value ( ciminputfile) .
output to  value ( "log.in") APPEND.
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
errstr="".
input from value ( cimoutputfile) .
    Do While errstr = "":
          IMPORT UNFORMATTED woutputstatment.

	  IF index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */
	     index (woutputstatment,"WARNING:") <> 0 OR    
	     index (woutputstatment,"´íÎó:")	<> 0 OR    /* for ch langx */
	     index (woutputstatment,"¾¯¸æ:")	<> 0 OR
    	     index (woutputstatment,"Äµ§i")	<> 0 OR    /* for tw langx */
	     index (woutputstatment,"¿ù»~:")	<> 0 OR
      	     index (woutputstatment,"(87)")	<> 0 OR      
	     index (woutputstatment,"(557)")	<> 0 OR      
      	     index (woutputstatment,"(143)")	<> 0       
	     
	     then do:
		  IF (index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */			     
			     index (woutputstatment,"´íÎó:")	<> 0 OR    /* for ch langx */			    			    
			     index (woutputstatment,"¿ù»~:")	<> 0 
			     ) 
			     then 
			     errstr=woutputstatment.


                  


	     end.


    End.
input close.
END PROCEDURE.
run dataout.
