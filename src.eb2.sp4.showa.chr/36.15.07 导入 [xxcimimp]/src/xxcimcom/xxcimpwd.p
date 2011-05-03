/* SS - 081222.1 By: Bill Jiang */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE OUTPUT PARAMETER currentDir AS CHARACTER.

DEFINE VARIABLE tmpfilename AS CHARACTER.
DEFINE VARIABLE comm-line AS CHARACTER.
DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE i2 AS INTEGER.

DEFINE TEMP-TABLE tt1
   FIELD tt1_c1 AS CHARACTER
   .

{gprun.i ""xxcimnow.p"" "(
   OUTPUT tmpfilename
   )"}
tmpfilename = "TMP" + tmpfilename.
{gprun.i ""xxcimfilename.p"" "(
   INPUT '',
   INPUT-OUTPUT tmpfilename
   )"}

comm-line = "pwd > " + tmpfilename.
os-command silent value(comm-line).

EMPTY TEMP-TABLE tt1.
IF SEARCH(tmpfilename) = ? THEN RETURN.
INPUT FROM VALUE(SEARCH(tmpfilename)).
REPEAT:
   CREATE tt1.
   IMPORT DELIMITER "`" tt1.
END.
INPUT CLOSE.

OS-DELETE VALUE(tmpfilename).

FOR FIRST tt1:
   currentDir = tt1_c1.
END.
