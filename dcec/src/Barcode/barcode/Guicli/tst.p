DEF VAR a AS CHAR.
FORM
    a COLON 20
WITH FRAME b WIDTH 80 THREE-D SIDE-LABEL.
REPEAT:
    UPDATE a WITH FRAME b.
    {bcrun.i ""bcmgbdpro.p"" "(INPUT ""c:\prsh.cim"",INPUT ""out.txt"")"}

END.
