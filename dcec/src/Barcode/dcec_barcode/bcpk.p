DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "材料库位".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "线边库位".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF FRAME bc_pick
    bc_id AT ROW 1.5 COL 4
    bc_part AT ROW 3 COL 2.5
   
    
   bc_lot AT ROW 4.5 COL 1.6
   /* bc_ref AT ROW 6 COL 2.5*/
    bc_qty AT ROW 6 COL 4
   /*bc_pkqty AT ROW 10 COL 4*/
    bc_site AT ROW 7.5 COL 4

    bc_loc AT ROW 9 COL 1
  bc_loc1 AT ROW 10.5 COL 1
   
    bc_button AT ROW 12.5 COL 10
    WITH SIZE 30 BY 15 TITLE "生产领料"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15
         WIDTH              = 30
         MAX-HEIGHT         = 15
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

ENABLE bc_id WITH FRAME bc_pick IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc_pick .*/
 DISP bc_part 
   
    
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc_pick .
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
