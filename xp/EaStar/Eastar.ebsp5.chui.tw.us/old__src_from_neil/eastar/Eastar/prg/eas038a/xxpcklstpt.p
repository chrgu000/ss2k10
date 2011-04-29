/* REVISION: EB SP5 Char   LAST MODIFIED: 03/19/04   BY: Kaine Zhang  *eas038* */

	{mfdtitle.i}
	
	DEFINE NEW SHARED VARIABLE strNbr		LIKE shah_pinbr.
	DEFINE NEW SHARED VARIABLE strNbra		LIKE shah_pinbr.
	DEFINE NEW SHARED VARIABLE strLang		AS   CHARACTER.
	
	FORM
		strNbr		COLON 27	LABEL "Proforma Invoice No."
		strNbra		COLON 51	LABEL {t001.i}
		strLang		COLON 27	LABEL "Language"
		SKIP(1)
	WITH FRAME a WIDTH 80 SIDE-LABELS.
	setframelabels(FRAME a:HANDLE).
	
	REPEAT ON ERROR UNDO, LEAVE:
		IF strNbra	= hi_char	THEN strNbra	= "".
		UPDATE strNbr strNbra strLang WITH FRAME a.
		
		bcdparm = "".
		{mfquoter.i strNbr}
		{mfquoter.i strNbra}
		{mfquoter.i strLang}
		
		IF strNbra	= "" THEN strNbra	= hi_char.
		
		{mfselbpr.i "printer" 80}
		
		{gprun.i ""xxpcklstpt1.p""}
		
		{mfreset.i}
		{mfgrptrm.i}
		/*{mfrtrail.i}*/
	END.