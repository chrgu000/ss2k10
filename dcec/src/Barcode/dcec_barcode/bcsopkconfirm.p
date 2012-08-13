DEFINE VAR C-Win AS WIDGET-HANDLE .

DEF VAR bclist AS CHAR FORMAT "x(20)" LABEL "单号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
/*DEF VAR m_bc_loc AS CHAR FORMAT "x(8)" LABEL "线边库位".*/
DEF TEMP-TABLE bc 
    FIELD  bc_id AS CHAR FORMAT "x(20)" 
FIELD bc_part AS CHAR FORMAT "x(18)" 
FIELD  bc_part_desc AS CHAR FORMAT "x(48)" 

FIELD bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" 
FIELD bc_site AS CHAR FORMAT "x(8)" 
FIELD bc_loc AS CHAR FORMAT "x(8)" 
FIELD bc_so_nbr AS CHAR FORMAT "x(8)"
    FIELD bc_so_line AS CHAR FORMAT "x(4)"
FIELD bc_lot AS CHAR FORMAT "x(18)" 
    FIELD bcmes_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" .
DEFINE QUERY bc_qry FOR bc.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
          bc_id  LABEL "条码"
        bc_so_nbr LABEL "销售订单"
        bc_so_line LABEL "行号"
        bc_part LABEL "零件号"
  bc_part_desc LABEL "零件描述"
 bc_lot LABEL "批/序号"
 bc_qty LABEL "数量"
 bc_site  LABEL "地点"
 bc_loc LABEL "材料库位"
 
   bcmes_qty LABEL "需求量"    
  
WITH NO-ROW-MARKERS SEPARATORS 8 DOWN WIDTH 29  TITLE "货运单/备料单".
DEF FRAME bc_pick
    
    bclist AT ROW 1.2 COL 1.3
   /* m_bc_loc AT ROW 2.4 COL 1*/
    bc_brw AT ROW 2.4 COL 1
    bc_button AT ROW 13.8 COL 10
    WITH SIZE 30 BY 16.5 TITLE "货运单/备料单确认"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "7.9.5 货运单/备料单确认"
         HEIGHT             = 16.5
         WIDTH              = 30
         MAX-HEIGHT         = 16.5
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

ENABLE  bclist /*m_bc_loc*/ WITH FRAME bc_pick IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc_pick .*/
 DISP  
    bc_brw 
    bc_button WITH FRAME bc_pick.
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
