DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bdbk_file AS CHAR FORMAT "x(24)" LABEL "异步接口".
DEF VAR bdbkmes_file AS CHAR FORMAT "x(24)" LABEL "回冲单".
DEFINE BUTTON bdbk_button LABEL "确认" SIZE 8 BY 1.50.
DEF TEMP-TABLE bdbk_end 
    FIELD  bdbk_endid AS CHAR FORMAT "x(20)" 
FIELD bdbk_endpart AS CHAR FORMAT "x(18)" 
FIELD  bdbk_endpart_desc AS CHAR FORMAT "x(48)" 

FIELD bdbk_endqty AS DECIMAL FORMAT "->>,>>>,>>9.9" 
FIELD bdbk_endsite AS CHAR FORMAT "x(8)" 
FIELD bdbk_endloc AS CHAR FORMAT "x(8)" 

FIELD bdbk_endlot AS CHAR FORMAT "x(18)" .

DEFINE QUERY bdbk_qry_end FOR bdbk_end.
    DEFINE BROWSE bdbk_brw_end  QUERY bdbk_qry_end
    DISPLAY
          bdbk_endid  LABEL "条码"
 bdbk_endpart LABEL "零件号"
  bdbk_endpart_desc LABEL "零件描述"
 bdbk_endlot LABEL "批/序号"
 bdbk_endqty LABEL "数量"
 bdbk_endsite  LABEL "地点"
 bdbk_endloc LABEL "总成/成品库位"

  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  TITLE "总成/成品清单".
    DEF TEMP-TABLE bdbk 
        FIELD bdbk_endid    AS CHAR FORMAT "x(20)" 
        FIELD bdbk_endpart AS CHAR FORMAT "x(18)" 
        FIELD  bdbk_id AS CHAR FORMAT "x(20)" 
FIELD bdbk_part AS CHAR FORMAT "x(18)" 
FIELD  bdbk_part_desc AS CHAR FORMAT "x(48)" 

FIELD bdbk_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" 
FIELD bdbk_site AS CHAR FORMAT "x(8)" 
FIELD bdbk_loc AS CHAR FORMAT "x(8)" 

FIELD bdbk_lot AS CHAR FORMAT "x(18)" 
        FIELD bdbkmes_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" .

DEFINE QUERY bdbk_qry FOR bdbk.
    DEFINE BROWSE bdbk_brw  QUERY bdbk_qry
    DISPLAY
        bdbk.bdbk_endid LABEL "总成/成品条码"
        bdbk.bdbk_endpart LABEL "总成/成品号"
        bdbk_id  LABEL "子件条码"
 bdbk_part LABEL "子零件号"
  bdbk_part_desc LABEL "子零件描述"
 bdbk_lot LABEL "批/序号"
 bdbk_qty LABEL "数量"
 bdbk_site  LABEL "地点"
 bdbk_loc LABEL "线边库位"
        bdbkmes_qty LABEL "实耗量"

  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  TITLE "子件回冲清单".
DEF FRAME bdbk_bk
   bdbk_file AT ROW 1.2 COL 1
    bdbkmes_file AT ROW 2.4 COL 2.5
    bdbk_brw_end AT ROW 3.6 COL 1
    bdbk_brw AT ROW 10.6 COL 1
    bdbk_button AT ROW 18.7 COL 10
    WITH SIZE 30 BY 20.7 TITLE "重复生产回冲"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DCEC BARCODEING"
         HEIGHT             = 20.7
         WIDTH              = 30
         MAX-HEIGHT         = 20.7
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

ENABLE bdbk_file WITH FRAME bdbk_bk IN WINDOW c-win.
/*DISABLE bdbk_part_desc  bdbk_part_desc1 WITH FRAME bdbk_pick .*/
 DISP   
    bdbk_brw bdbk_brw_end
    bdbk_button WITH FRAME bdbk_bk.
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
