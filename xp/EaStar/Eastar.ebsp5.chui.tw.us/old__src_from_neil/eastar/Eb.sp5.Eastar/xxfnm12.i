/* Revision eB SP5 Linux  Last Modified: 01/01/06   By: Kaine  *eas053a* */

	IF PAGE-SIZE - LINE-COUNTER >= 15 THEN DO:
		{xxfnm12a.i}
	END.
	ELSE IF (PAGE-SIZE - LINE-COUNTER < 15) AND (PAGE-SIZE - LINE-COUNTER >= 8) THEN DO:
		{xxfnm12b.i}
	END.
	ELSE IF PAGE-SIZE - LINE-COUNTER < 8 THEN DO:
		{xxfnm12c.i}
	END.
	
	
	pages = page-number .
	total = 0.
	lines = 0.
	page_yn = no.
	