DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR path AS CHAR FORMAT "x(20)" LABEL "接口".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF FRAME bc_srm
    path AT ROW 2 COL 4
   
  /* bc_pkqty AT ROW 10 COL 4*/
  

   
    bc_button AT ROW 4 COL 10
    WITH SIZE 30 BY 6 TITLE "SRM接口"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DCEC BARCODEING"
         HEIGHT             = 6
         WIDTH              = 30
         MAX-HEIGHT         = 6
         MAX-WIDTH          = 30
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

ENABLE path  WITH FRAME bc_srm IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
