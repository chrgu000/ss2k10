DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/

DEF VAR bc_lot AS CHAR FORMAT "x(8)" LABEL "批/序号".
DEF VAR bc_merge_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "合并数量".
DEF TEMP-TABLE bc 
    FIELD  bc_id AS CHAR FORMAT "x(20)" 
FIELD bc_part AS CHAR FORMAT "x(18)" 
FIELD  bc_part_desc AS CHAR FORMAT "x(48)" 

FIELD bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" 
FIELD bc_site AS CHAR FORMAT "x(8)" 
FIELD bc_loc AS CHAR FORMAT "x(8)" 

FIELD bc_lot AS CHAR FORMAT "x(18)" 
    FIELD bc_mes_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" .
DEFINE QUERY bc_qry FOR bc.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
          bc_id  LABEL "条码"
 bc_part LABEL "零件号"
  bc_part_desc LABEL "零件描述"
 bc_lot LABEL "批/序号"
 bc_qty LABEL "数量"
 bc_site  LABEL "地点"
 bc_loc LABEL "材料库位"
  
   bc_mes_qty LABEL "需求量"    
  
WITH NO-ROW-MARKERS SEPARATORS 4 DOWN WIDTH 29  TITLE "待合并清单".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF FRAME bc_merge
    bc_id AT ROW 1.5 COL 4
    bc_brw AT ROW 3 COL 1
  /* bc_pkqty AT ROW 10 COL 4*/
   bc_merge_qty AT ROW 10.5 COL 1.3

   
    bc_button AT ROW 12 COL 10
    WITH SIZE 30 BY 14 TITLE "条码合并"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
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

ENABLE bc_id  WITH FRAME bc_merge IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_merge_qty WITH FRAME bc_merge.
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
