
DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bdpk_file AS CHAR FORMAT "x(24)" LABEL "异步接口".
DEF VAR bdpkmes_file AS CHAR FORMAT "x(24)" LABEL "MES料单".
DEFINE BUTTON bdpk_button LABEL "确认" SIZE 8 BY 1.50.
DEF TEMP-TABLE bdpk 
    FIELD  bdpk_id AS CHAR FORMAT "x(20)" 
FIELD bdpk_part AS CHAR FORMAT "x(18)" 
FIELD  bdpk_part_desc AS CHAR FORMAT "x(48)" 

FIELD bdpk_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" 
FIELD bdpk_site AS CHAR FORMAT "x(8)" 
FIELD bdpk_loc AS CHAR FORMAT "x(8)" 
FIELD bdpk_loc1 AS CHAR FORMAT "x(8)" 
FIELD bdpk_lot AS CHAR FORMAT "x(18)" 
    FIELD bdpkmes_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" .
DEFINE QUERY bdpk_qry FOR bdpk.
    DEFINE BROWSE bdpk_brw  QUERY bdpk_qry
    DISPLAY
          bdpk_id  LABEL "条码"
 bdpk_part LABEL "零件号"
  bdpk_part_desc LABEL "零件描述"
bdpk_lot LABEL "批/序号"
 bdpk_qty LABEL "数量"
 bdpk_site  LABEL "地点"
 bdpk_loc LABEL "材料库位"
 bdpk_loc1 LABEL "线边库位"
  bdpkmes_qty LABEL "需求量"
WITH NO-ROW-MARKERS SEPARATORS 7 DOWN WIDTH 29  TITLE "物料清单".
DEF FRAME bdpk_pick
   bdpk_file AT ROW 1.5 COL 1
    bdpkmes_file AT ROW 3 COL 1.3
    bdpk_brw AT ROW 4.5 COL 1
    bdpk_button AT ROW 14.8 COL 10
    WITH SIZE 30 BY 17 TITLE "成批生产领料"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DCEC BARCODEING"
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

ENABLE bdpkmes_file bdpk_file WITH FRAME bdpk_pick IN WINDOW c-win.
/*DISABLE bdpk_part_desc  bdpk_part_desc1 WITH FRAME bdpk_pick .*/
 DISP  bdpk_file 
    bdpk_brw 
    bdpk_button WITH FRAME bdpk_pick.
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
