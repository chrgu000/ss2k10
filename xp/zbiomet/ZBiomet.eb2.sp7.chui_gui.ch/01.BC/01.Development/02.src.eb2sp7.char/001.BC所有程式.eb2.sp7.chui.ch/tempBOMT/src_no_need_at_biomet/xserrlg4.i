


procedure write_error_to_log:
	define input parameter file_name as char .
	define input parameter file_name_o as char .
	define output parameter v_ok as logical .
	define variable linechar as char .
	define variable woutputstatment as char.

	linechar = "" .
	input from value (file_name_o) .

		repeat: 
			import unformatted woutputstatment.                         

			IF  index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */ 
				index (woutputstatment,"´íÎó:")	<> 0 OR    /* for ch langx */
				index (woutputstatment,"¿ù»~:")	<> 0       /* for tw langx */ 		     
			then do:			  
				output to  value ( "log.err") APPEND.
					put unformatted today " " string (time,"hh:mm:ss")  " "  userid(sdbname('qaddb')) " " file_name_o " " woutputstatment  skip.
				output close.
				linechar = "ERROR" .			  
			end.		     
		End.

	input close.

	/*if linechar <> "ERROR" then do:
		unix silent value ("rm -f "  + trim(file_name)).
		unix silent value ("rm -f "  + trim(file_name_o)).
	end. */

	v_ok = if linechar = "ERROR" then no else yes .

end. /*PROCEDURE write_error_to_log*/