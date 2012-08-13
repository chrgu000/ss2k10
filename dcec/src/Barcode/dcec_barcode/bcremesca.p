DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "至".
DEF VAR bc_emp AS CHAR FORMAT "x(18)" LABEL "领料员".
DEF VAR bc_emp1 AS CHAR FORMAT "x(18)" LABEL "至".
    DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF FRAME bc
    
    
    bc_part AT ROW 1.5 COL 4
     bc_part1 AT ROW 3 COL 6.9
   
  /* bc_pkqty AT ROW 10 COL 4*/
  

   
    bc_button AT ROW 5 COL 10
    WITH SIZE 30 BY 8 TITLE "生产领料计算"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 8
         WIDTH              = 30
         MAX-HEIGHT         = 8
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

ENABLE  bc_part bc_part1  WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
