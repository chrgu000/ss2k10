DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".

DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF FRAME bc
    bc_id AT ROW 2 COL 4
    bc_site AT ROW 3.5 COL 4
   
    bc_loc  AT ROW 5 COL 4
   
  /* bc_pkqty AT ROW 10 COL 4*/
   

   
    bc_button AT ROW 6.5 COL 10
    WITH SIZE 30 BY 9 TITLE "库位条码维护"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "BARCODEING"
         HEIGHT             = 9
         WIDTH              = 30
         MAX-HEIGHT         = 9
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

ENABLE bc_id bc_site bc_loc WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
