DEFINE VAR C-Win AS WIDGET-HANDLE .

DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "至".

/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "至".


DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF FRAME bc
     bc_site AT ROW 2 COL 4
    bc_site1 AT ROW 3.5 COL 5.5
   
    bc_loc AT ROW 5 COL 4
     bc_loc1 AT ROW 6.5 COL 5.5
   bc_part AT ROW 8 COL 2.5
    bc_part1 AT ROW 9.5 COL 5.5
  /* bc_pkqty AT ROW 10 COL 4*/
  

   

   
    bc_button AT ROW 11.5 COL 10
    WITH SIZE 30 BY 14 TITLE "盘点差异报表"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "BARCODEING"
         HEIGHT             = 14
         WIDTH              = 30
         MAX-HEIGHT         = 14
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

ENABLE ALL WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc_pick .*/
 
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
