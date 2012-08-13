DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bdwo_file AS CHAR FORMAT "x(24)" LABEL "异步接口".
DEFINE BUTTON bdwo_button LABEL "确认" SIZE 8 BY 1.50.
DEF TEMP-TABLE bdwo 
    FIELD  bdwo_id AS CHAR FORMAT "x(20)" 
FIELD bdwo_part AS CHAR FORMAT "x(18)" 
FIELD  bdwo_part_desc AS CHAR FORMAT "x(48)" 

FIELD bdwo_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" 
FIELD bdwo_site AS CHAR FORMAT "x(8)" 
FIELD bdwo_loc AS CHAR FORMAT "x(8)" 
   FIELD bdwo_wo_nbr AS CHAR FORMAT "x(8)"
    FIELD bdwo_wo_id as CHAR FORMAT "x(8)"

FIELD bdwo_lot AS CHAR FORMAT "x(18)" .
DEFINE QUERY bdwo_qry FOR bdwo.
    DEFINE BROWSE bdwo_brw  QUERY bdwo_qry
    DISPLAY
          bdwo_id  LABEL "条码"
 bdwo_part LABEL "零件号"
  bdwo_part_desc LABEL "零件描述"
 bdwo_lot LABEL "批/序号"
 bdwo_qty LABEL "数量"
 bdwo_site  LABEL "地点"
        bdwo_loc LABEL "成品库位"
       bdwo_wo_nbr LABEL "工单"
        bdwo_wo_id LABEL "标识"
       

  
WITH NO-ROW-MARKERS SEPARATORS 8 DOWN WIDTH 29  TITLE "总成/成品入库清单".
DEF FRAME bdwo
   bdwo_file AT ROW 1.5 COL 1
    bdwo_brw AT ROW 3 COL 1
    bdwo_button AT ROW 14.3 COL 10
    WITH SIZE 30 BY 17 TITLE "加工单入库"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DCEC BARCODEING"
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

ENABLE bdwo_file WITH FRAME bdwo IN WINDOW c-win.
/*DISABLE bdwo_part_desc  bdwo_part_desc1 WITH FRAME bdwo_pick .*/
 DISP  bdwo_file 
    bdwo_brw 
    bdwo_button WITH FRAME bdwo.
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
