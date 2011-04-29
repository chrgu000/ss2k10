/*TRAILER*/ 
                  
		 lines2 = 0.
		 if charge_yn = yes then lines2 = lines2 + 2.
		 if return_yn = yes then lines2 = lines2 + 2.
		  if shah_shipvia = "A" then do:
                  	if page-size - line-counter < 14 + lines2 then page.
                  	do while page-size - line-counter > 14 + lines2 :
                  	   put skip(1).
                  	end.
                  	put "---------------" to 79.
			put "Total:" to 63.
                        put total  to 79  format ">,>>>,>>9.9999".
		  	put "===============" to 79.		  	
			if charge_yn = yes then do:
			   put "PAST DUE ACCOUNTS MAY BE ASSESSED" to 78.
			   put "A SERVICE CHARGE OF " to 65.
			   put mar1 to 67 .
			   put "% PER MONTH" .
			end.
			put skip(1).
		  	put "AIR FORWARDER: " at 2.
			put shah_forwarder.
		  	put "HOUSING AWB# : " at 2.
			put shah_desc_line1.
		  	put "MASTER AWB#  : " at 2.
			put shah_desc_line2.
		  	put "FLIGHT NO.   : " at 2.
			put shah_desc_line4.
		  	put "ETD HK       : " at 2.
			put etdate2.
			put skip(1).
			if return_yn = yes then do:
			   put "NO RETURNS ACCEPTED UNLESS AUTHORIZED BY EASTAR (HK) LIMITED" at 1.
			   put "ALL CLAIMS MUST BE MADE WITHIN " at 1.
			   put mar2 to 33.
			   put "DAYS UPON GOODS RECEIVED" .
			end.
			put skip(1).
			put "***** END ***** "  at 32 .
			put skip(1).
			put "THIS IS A COMPUTER-GENERATED DOCUMENT AND NO SIGNATURE REQUIRED".
                  end.
		  else do:
                  	if page-size - line-counter < 15 + lines2 then page.
                  	do while page-size - line-counter > 15 + lines2 :
                  	   put skip(1).
                  	end.
                  	put "---------------" to 79.
			put "Total:" to 63.
                        put total  to 79  format ">,>>>,>>9.9999".
		  	put "===============" to 79.		  	
			if charge_yn = yes then do:
			   put "PAST DUE ACCOUNTS MAY BE ASSESSED" to 78.
			   put "A SERVICE CHARGE OF " to 65.
			   put mar1 to 67.
			   put "% PER MONTH" .
			end.
			put skip(1).
		  	put "SHIPPING CO      : " at 2.
			put shah_forwarder.
		  	put "VESSEL NAME      : " at 2.
			put shah_desc_line1.
		  	put "B/L NO.          : " at 2.
			put shah_desc_line2.
			put "COUNTRY OF ORIGIN: " at 2.
			put shah_desc_line3.
		  	put "ETD HK           : " at 2.
			put etdate2.
		  	put "CONTAINER NO.    : " at 2.
			put shah_container.
			put skip(1).
			if return_yn = yes then do:
			   put "NO RETURNS ACCEPTED UNLESS AUTHORIZED BY EASTAR (HK) LIMITED" at 1.
			   put "ALL CLAIMS MUST BE MADE WITHIN " at 1.
			   put mar2 to 33.
			   put "DAYS UPON GOODS RECEIVED" .
			end.
			put skip(1).
			put "***** END ***** "  at 32 .
			put skip(1).
			put "THIS IS A COMPUTER-GENERATED DOCUMENT AND NO SIGNATURE REQUIRED".
		  end.
             pages = page-number .
 	     total = 0.
	     lines = 0.
	   page_yn = no.
