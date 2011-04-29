/*TRAILER*/ 
/*TRAILER*/ 
                  
		 lines2 = 0.
		 if charge_yn = yes then lines2 = lines2 + 2.
		 if return_yn = yes then lines2 = lines2 + 4.
                  	if page-size - line-counter < 10 + lines2 then page.
                  	do while page-size - line-counter > 10 + lines2 :
                  	   put skip(1).
                  	end.
                  	put "---------------" to 81.
			put "Total:" to 65.
                        put total  to 81  format "->,>>>,>>9.9999".
		  	put "===============" to 81.		  	
			if charge_yn = yes then do:
			   put "PAST DUE ACCOUNTS MAY BE ASSESSED" to 78.
			   put "A SERVICE CHARGE OF " to 65.
			   put mar1 to 67 .
			   put "% PER MONTH" .
			end.
			put skip(1).
			put "Per Pull Report# " at 1 feedback.
			if return_yn = yes then do:
			   put skip(1).
			   put "NO RETURNS ACCEPTED UNLESS AUTHORIZED BY EASTAR (HK) LIMITED" at 1.
			   put "ALL CLAIMS MUST BE MADE WITHIN " at 1.
			   put mar2 to 33.
			   put "DAYS UPON GOODS RECEIVED" .
			end.
			put skip(2).
			put "***** END ***** "  at 32 .
			put skip(1).
			put "THIS IS A COMPUTER-GENERATED DOCUMENT AND NO SIGNATURE REQUIRED".

             pages = page-number .
 	     total = 0.
	     lines = 0.
	   page_yn = no.
