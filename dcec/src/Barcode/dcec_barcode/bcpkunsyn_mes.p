
DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bdpk_file AS CHAR FORMAT "x(24)" LABEL "�첽�ӿ�".
DEF VAR bdpkmes_file AS CHAR FORMAT "x(24)" LABEL "MES�ϵ�".
DEFINE BUTTON bdpk_button LABEL "ȷ��" SIZE 8 BY 1.50.
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
          bdpk_id  LABEL "����"
 bdpk_part LABEL "�����"
  bdpk_part_desc LABEL "�������"
bdpk_lot LABEL "��/���"
 bdpk_qty LABEL "����"
 bdpk_site  LABEL "�ص�"
 bdpk_loc LABEL "���Ͽ�λ"
 bdpk_loc1 LABEL "�߱߿�λ"
  bdpkmes_qty LABEL "������"
WITH NO-ROW-MARKERS SEPARATORS 7 DOWN WIDTH 29  TITLE "�����嵥".
DEF FRAME bdpk_pick
   bdpk_file AT ROW 1.5 COL 1
    bdpkmes_file AT ROW 3 COL 1.3
    bdpk_brw AT ROW 4.5 COL 1
    bdpk_button AT ROW 14.8 COL 10
    WITH SIZE 30 BY 17 TITLE "������������"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
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
