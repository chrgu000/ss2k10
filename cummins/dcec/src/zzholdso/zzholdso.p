/* GUI CONVERTED from yybw200.p (converter v1.78) Mon Nov 19 19:17:03 2012 */

{mfdtitle.i "121119.1"}
define variable yn like mfc_logical no-undo.
{gpcdget.i "UT"}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
yn colon 40
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
/*GUI*/ if global-beam-me-up then undo, leave.

update yn.
if not yn then leave.
FOR EACH so_mstr WHERE so_domain = "dcec" and so_stat = "".
    ASSIGN so_stat = "HD".
END.

end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* repeat with frame a: */
status input.
