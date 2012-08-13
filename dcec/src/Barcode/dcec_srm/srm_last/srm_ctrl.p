{mfdtitle.i}
    DEF VAR path AS CHAR FORMAT "x(24)".
    DEF FRAME a
    path COLON 20
    WITH WIDTH 80 THREE-D SIDE-LABELS.


REPEAT :
    PROMPT-FOR path WITH FRAME a.
FIND FIRST CODE_mstr WHERE CODE_fldname = 'srmpath' EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE code_mstr THEN CODE_cmmt = INPUT path.
END.
