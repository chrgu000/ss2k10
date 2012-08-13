DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "成品条码".
 DEF VAR    bc_part AS CHAR FORMAT "x(18)" LABEL "零件号" .
  DEF VAR   bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
   DEF VAR  bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量" .
   DEF VAR l_op AS CHAR FORMAT "x(8)" LABEL "最后工序".
   DEF VAR  bc_loc AS CHAR FORMAT "x(8)" LABEL "成品库位".
   DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "成品地点".
DEF VAR bcmes_file AS CHAR FORMAT "x(24)" LABEL "回冲单".
DEF VAR bc_emp AS CHAR FORMAT "x(8)" LABEL "雇员".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)" .
DEF VAR pro_line AS CHAR FORMAT "x(8)" LABEL "生产线".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
   /* DEF TEMP-TABLE bc 
        
        FIELD  bc_id AS CHAR FORMAT "x(20)" 
FIELD bc_part AS CHAR FORMAT "x(18)" 
FIELD  bc_part_desc AS CHAR FORMAT "x(48)" 

FIELD bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" 
FIELD bc_site AS CHAR FORMAT "x(8)" 
FIELD bc_loc AS CHAR FORMAT "x(8)" 

FIELD bc_lot AS CHAR FORMAT "x(18)" 
        FIELD bcmes_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" .

DEFINE QUERY bc_qry FOR bc.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
        
        bc_id  LABEL "子件条码"
 bc_part LABEL "子零件号"
  bc_part_desc LABEL "子零件描述"
 bc_lot LABEL "批/序号"
 bc_qty LABEL "数量"
 bc_site  LABEL "地点"
 bc_loc LABEL "线边库位"
bcmes_qty LABEL "实耗量"
  
WITH NO-ROW-MARKERS SEPARATORS 4 DOWN WIDTH 29  TITLE "子件回冲清单".*/
DEF FRAME bc_bk
    bc_emp AT ROW 1.2 COL 4
    bc_id AT ROW 2.4 COL 1
    bc_part AT ROW 3.6 COL 2.5
    /*bc_part_desc AT ROW 4.8 COL 1
    bc_part_desc1 AT ROW 5.8 COL 8.5 NO-LABEL*/
    bc_lot AT ROW 4.8 COL 1.6
    /*bc_ref AT ROW 6 COL 2.5*/
    l_op AT ROW 6 COL 1
    pro_line AT ROW 7.2 COL 2.5
    bc_qty AT ROW 8.4 COL 4
     bcmes_file AT ROW 9.6 COL 2.5
   bc_site  AT ROW 10.8 COL 1
    bc_loc AT ROW 12 COL 1
 
   
    bc_button AT ROW 14 COL 10
    WITH SIZE 30 BY 16 TITLE "成品入库回冲"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16
         WIDTH              = 30
         MAX-HEIGHT         = 16
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

ENABLE bc_emp bc_id WITH FRAME bc_bk IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc_pick .*/
 DISP   
   
    bc_button bc_qty WITH FRAME bc_bk.
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
