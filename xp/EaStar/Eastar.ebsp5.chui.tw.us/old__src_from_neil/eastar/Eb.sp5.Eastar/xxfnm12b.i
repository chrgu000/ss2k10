/* Revision eB SP5 Linux  Last Modified: 01/01/06   By: Kaine  *eas053a* */

	DO WHILE PAGE-SIZE - LINE-COUNTER > 8 :
		PUT SKIP(1).
	END.
	
	PUT "---------------" to 81.
	PUT "Total:" to 65.
	PUT total  to 81  format "->,>>>,>>9.99".
	PUT "===============" to 81.

	{xxfnmbtm.i}
	

	/******************/
	
	PAGE.
	
	DO WHILE PAGE-SIZE - LINE-COUNTER > 13 :
		PUT SKIP(1).
	END.
	
	PUT
		"REMARK:" AT 1
		.
	
	IF shah_shipvia = "A" THEN	
		PUT
			"AIR FORWARDER: " at 2
			shah_forwarder
			"HOUSING AWB# : " at 2
			shah_desc_line1
			"MASTER AWB#  : " at 2
			shah_desc_line2
			"FLIGHT NO.   : " at 2
			shah_desc_line4
			SKIP(2)
			.
	ELSE
		PUT
			"SHIPPING CO      : " at 2
			shah_forwarder
		  	"VESSEL NAME      : " at 2
			shah_desc_line1
		  	"B/L NO.          : " at 2
			shah_desc_line2
			"COUNTRY OF ORIGIN: " at 2
			shah_desc_line3
		  	"CONTAINER NO.    : " at 2
			shah_container
			SKIP(1)
			.
		
	{xxfnmbtm.i}
	