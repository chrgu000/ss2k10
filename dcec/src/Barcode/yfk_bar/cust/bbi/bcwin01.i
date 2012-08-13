DEFINE VAR C-Win AS WIDGET-HANDLE .
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ÌõÂëÏµÍ³"
         HEIGHT             = 22
         WIDTH              = 80
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 80
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = NO
         SENSITIVE          = yes.
ASSIGN CURRENT-WINDOW                = c-win
       THIS-PROCEDURE:CURRENT-WINDOW = c-win.
C-Win:HIDDEN = no.

