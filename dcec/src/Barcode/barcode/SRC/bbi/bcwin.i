DEFINE VAR C-Win AS WIDGET-HANDLE .

CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "ÌõÂëÏµÍ³"
         HEIGHT             = 26
         WIDTH              = 90
         /*MAX-HEIGHT         = 26
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 26
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = NO*/
         SENSITIVE          = yes.

ASSIGN CURRENT-WINDOW                = c-win
       THIS-PROCEDURE:CURRENT-WINDOW = c-win.
C-Win:HIDDEN = no.


