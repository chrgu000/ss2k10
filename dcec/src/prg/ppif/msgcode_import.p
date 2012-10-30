DEF VAR a AS CHAR  FORMAT "x(4)".
DEF VAR b AS CHAR  FORMAT "x(100)".
INPUT FROM c:\123.txt.
REPEAT:
    PAUSE 0.
    IMPORT DELIMITER "chr(9)" a b .

    find first code_mstr where code_fldname = "PPIF_MSG" and code_value = a  no-error.    /*PPIF TO QAD*/
    IF NOT AVAIL CODE_mstr THEN DO:
       CREATE CODE_mstr.
       ASSIGN CODE_fldname = "PPIF_MSG"
           CODE_value = a.
       CODE_cmmt = b.
    END.
           

END.
INPUT CLOSE.