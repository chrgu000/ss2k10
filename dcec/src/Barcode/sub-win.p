 DEF VAR sub-win AS WIDGET-HANDLE .
          CREATE WINDOW sub-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Print"
         HEIGHT             = 15
         WIDTH              = 30
         MAX-HEIGHT         = 15
         MAX-WIDTH          = 30
         VIRTUAL-HEIGHT     = 15
         VIRTUAL-WIDTH      = 30
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
  ASSIGN CURRENT-WINDOW                = sub-win
       THIS-PROCEDURE:CURRENT-WINDOW = sub-win.
sub-Win:HIDDEN = no.
ON WINDOW-CLOSE OF sub-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
 HIDE sub-win.
      APPLY "CLOSE":U TO THIS-PROCEDURE.
   
  RETURN NO-APPLY.
END.
VIEW sub-win.  
WAIT-FOR CLOSE OF THIS-PROCEDURE.
