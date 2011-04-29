/* Revision eB SP5 Linux  Last Modified: 12/01/05   Create By: Kaine  *easnew* */

FUNCTION strYear2Let RETURNS CHARACTER(INPUT strInYear AS CHARACTER).
	DEFINE VARIABLE strOutChr AS CHARACTER.
	DEFINE VARIABLE intTmpYear AS INTEGER.

	intTmpYear = INTEGER(strInYear) NO-ERROR.

	IF intTmpYear < 2010 THEN DO:
		CASE strInYear:
			WHEN "2004" THEN DO:
				strOutChr = "4".
			END.
			WHEN "2005" THEN DO:
				strOutChr = "5".
			END.
			WHEN "2006" THEN DO:
				strOutChr = "6".
			END.
			WHEN "2007" THEN DO:
				strOutChr = "7".
			END.
			WHEN "2008" THEN DO:
				strOutChr = "8".
			END.
			WHEN "2009" THEN DO:
				strOutChr = "9".
			END.
		END CASE.
	END.
	ELSE IF intTmpYear >= 2010 AND intTmpYear < 2036 THEN DO:	/* 2010-A, 2011-B, ... 2035-Z */
		strOutChr = KEYFUNCTION(intTmpYear - 1945).	/* 2010, 2011,... -> 65, 66,... -> A, B,... */
	END.

	IF strOutChr = "" THEN strOutChr = "-".

	RETURN strOutChr.
END FUNCTION.

FUNCTION strYr2Lt RETURNS CHARACTER(INPUT strInYr AS CHARACTER).
	DEFINE VARIABLE strOutYrChr AS CHARACTER.
	DEFINE VARIABLE intTmpYr 	AS INTEGER.

	intTmpYr = INTEGER(strInYr) NO-ERROR.
	strOutYrChr = "".

	IF intTmpYr >= 2005 AND intTmpYr < 2030 THEN DO:	/* 2005-A, 2006-B, ... 2030-Z */
		strOutYrChr = KEYFUNCTION(intTmpYr - 1940).	/* 2005, 2006,... -> 65, 66,... -> A, B,... */
	END.

	IF strOutYrChr = "" THEN strOutYrChr = "-".

	RETURN strOutYrChr.
END FUNCTION.
