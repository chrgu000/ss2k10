/*supply a individule window */
/*
DEFINE VAR C-Win AS WIDGET-HANDLE .

CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ÌõÂëÏµÍ³"
         HEIGHT-CHARS             = 18
         WIDTH-CHARS            =  30
         MAX-HEIGHT         = 18
         MAX-WIDTH          = 30
         VIRTUAL-HEIGHT     = 18
         VIRTUAL-WIDTH      = 30
         RESIZE             = yes
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ? 
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = NO
         SENSITIVE          = yes.

ASSIGN CURRENT-WINDOW = c-win
THIS-PROCEDURE:CURRENT-WINDOW = c-win.
C-Win:HIDDEN = no.
*/

 CURRENT-WINDOW:WIDTH = 30.
CURRENT-WINDOW:HEIGHT = 18.
CURRENT-WINDOW:MESSAGE-AREA = FALSE.
