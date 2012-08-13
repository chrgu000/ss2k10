DEFINE VAR C-Win AS WIDGET-HANDLE .
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18
         WIDTH              = 80
         MAX-HEIGHT         = 18
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 120
         VIRTUAL-WIDTH      = 133
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ASSIGN CURRENT-WINDOW                = c-win
       THIS-PROCEDURE:CURRENT-WINDOW = c-win.
C-Win:HIDDEN = no.

