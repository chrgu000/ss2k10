/* xxqusrret.p - query db user reset                                         */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

{mfdtitle.i "130113.1"}
define variable yn like mfc_logical no-undo.
define variable fpwd as character format "x(46)"
			 initial "D:\dcec\src\SRC-2011SE\xxusrpm\win\pwd.txt".
define variable fcim as character format "x(46)"
			 initial "D:\dcec\src\SRC-2011SE\xxusrpm\win\u.cim".
DEFINE VARIABLE u LIKE usr_userid.
DEFINE VARIABLE P LIKE usr_passwd.
define variable txt as character.
define variable expUser as character initial
			 "mfg,admin".
DEFINE stream bfi.
DEFINE stream bfo.
{gpcdget.i "UT"}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
	  fpwd colon 20
	  fcim colon 20 skip(2)
		yn colon 26
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


setFrameLabels(frame a:handle).

repeat with frame a:
update fpwd fcim yn.
if not yn then leave.

output stream bfo to value("u.bpi").
input stream bfi from value(fcim).
repeat:
	import stream bfi unformat txt.
	if index(txt , "@@batchload") = 0 and index(txt , "@@end") = 0 then do:
  	 put stream bfo unformat txt skip.
  end.
end.
input stream bfi close.
output stream bfo close.

input from value("u.bpi").
output to value("u.bpo") keep-messages.
hide message no-pause.
batchrun = yes.
  {gprun.i ""mgurmt.p""}
batchrun = no.
hide message no-pause.
output close.
input close.

/*
os-delete value("u.bpi") no-error.
os-delete value("u.bpo") no-error.
*/

INPUT FROM value(fpwd).
REPEAT:
    IMPORT DELIMITER "," u p.
    FIND FIRST usr_mstr EXCLUSIVE-LOCK WHERE USr_userid = u NO-ERROR.
    IF AVAILABLE usr_mstr and index(expUser , usr_userid) = 0 THEN DO:
        ASSIGN usr_passwd = p.
    END.
END.
INPUT CLOSE.

end.  /* repeat with frame a: */
status input.
