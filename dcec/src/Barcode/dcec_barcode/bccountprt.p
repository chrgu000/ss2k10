DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "至".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/

DEF VAR bc_lot AS CHAR FORMAT "x(8)" LABEL "批/序号".
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "至".
DEFINE BUTTON bc_button LABEL "打印" SIZE 8 BY 1.50.
DEF FRAME bc
    
    bc_part AT ROW 1.5 COL 2.5
    bc_part1 AT ROW 3 COL 5.5
    
   
  /* bc_pkqty AT ROW 10 COL 4*/
   bc_site AT ROW 4.5 COL 4
    bc_site1 AT ROW 6 COL 5.5
    bc_loc AT ROW 7.5 COL 4
    bc_loc1 AT ROW 9 COL 5.5

   
    bc_button AT ROW 11 COL 10
    WITH SIZE 30 BY 13 TITLE "盘点单打印"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "BARCODEING"
         HEIGHT             = 13
         WIDTH              = 30
         MAX-HEIGHT         = 13
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

ENABLE bc_part  WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 /*DISP  
   bc_part
    bc_part_desc  
    bc_part_desc1  
   bc_lot 
    bc_qty 
   
  
    WITH FRAME bc .*/
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
