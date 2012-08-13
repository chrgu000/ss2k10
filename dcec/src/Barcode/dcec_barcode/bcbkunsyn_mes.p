DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bdbk_file AS CHAR FORMAT "x(24)" LABEL "�첽�ӿ�".
DEF VAR bdbkmes_file AS CHAR FORMAT "x(24)" LABEL "�س嵥".
DEFINE BUTTON bdbk_button LABEL "ȷ��" SIZE 8 BY 1.50.
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
          bdbk_endid  LABEL "����"
 bdbk_endpart LABEL "�����"
  bdbk_endpart_desc LABEL "�������"
 bdbk_endlot LABEL "��/���"
 bdbk_endqty LABEL "����"
 bdbk_endsite  LABEL "�ص�"
 bdbk_endloc LABEL "�ܳ�/��Ʒ��λ"

  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  TITLE "�ܳ�/��Ʒ�嵥".
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
        bdbk.bdbk_endid LABEL "�ܳ�/��Ʒ����"
        bdbk.bdbk_endpart LABEL "�ܳ�/��Ʒ��"
        bdbk_id  LABEL "�Ӽ�����"
 bdbk_part LABEL "�������"
  bdbk_part_desc LABEL "���������"
 bdbk_lot LABEL "��/���"
 bdbk_qty LABEL "����"
 bdbk_site  LABEL "�ص�"
 bdbk_loc LABEL "�߱߿�λ"
        bdbkmes_qty LABEL "ʵ����"

  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  TITLE "�Ӽ��س��嵥".
DEF FRAME bdbk_bk
   bdbk_file AT ROW 1.2 COL 1
    bdbkmes_file AT ROW 2.4 COL 2.5
    bdbk_brw_end AT ROW 3.6 COL 1
    bdbk_brw AT ROW 10.6 COL 1
    bdbk_button AT ROW 18.7 COL 10
    WITH SIZE 30 BY 20.7 TITLE "�ظ������س�"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
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
