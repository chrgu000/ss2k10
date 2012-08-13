DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_wo_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_wo_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
DEF VAR bc_wo_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "成品库位".
DEF VAR bc_wo_nbr AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR bc_wo_part AS CHAR FORMAT "x(18)" LABEL "工单零件".
DEF VAR bc_wo_id AS CHAR FORMAT "x(8)" LABEL "标识".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEF FRAME bc
    bc_wo_nbr AT ROW 1.2 COL 4
    bc_wo_id AT ROW 2.4 COL 4  
  bc_wo_part AT ROW 3.6 COL 1 
    bc_wo_qty AT ROW 4.8 COL 4
   
    bc_id AT ROW 6 COL 4
    bc_part AT ROW 7.2 COL 2.5
   
    
   bc_lot AT ROW 8.4 COL 1.6
    /*bc_ref AT ROW 9.6 COL 2.5*/
    bc_qty AT ROW 9.6 COL 4
   
    bc_site AT ROW 10.8 COL 4

    bc_loc AT ROW 12 COL 1
  
  
    bc_button AT ROW 13.5 COL 10
    WITH SIZE 30 BY 17 TITLE "加工单入库"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 30
         MAX-HEIGHT         = 17
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

ENABLE bc_wo_nbr 
    bc_wo_id
  
    bc_id 
     WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_wo_part_desc  bc_wo_part_desc1 WITH FRAME bc_pick .*/
 DISP bc_part 
   bc_wo_qty
    
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
