DEFINE VAR C-Win AS WIDGET-HANDLE .

DEF VAR bcpklist AS CHAR FORMAT "x(24)" LABEL "���ϵ�".
DEFINE BUTTON bcpk_button LABEL "ȷ��" SIZE 8 BY 1.50.
/*DEF VAR m_bcpk_loc AS CHAR FORMAT "x(8)" LABEL "�߱߿�λ".*/
DEF TEMP-TABLE bcpk 
    FIELD  bcpk_id AS CHAR FORMAT "x(20)" 
FIELD bcpk_part AS CHAR FORMAT "x(18)" 
FIELD  bcpk_part_desc AS CHAR FORMAT "x(48)" 

FIELD bcpk_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" 
FIELD bcpk_site AS CHAR FORMAT "x(8)" 
FIELD bcpk_loc AS CHAR FORMAT "x(8)" 

FIELD bcpk_lot AS CHAR FORMAT "x(18)" 
    FIELD bcpkmes_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" .
DEFINE QUERY bcpk_qry FOR bcpk.
    DEFINE BROWSE bcpk_brw  QUERY bcpk_qry
    DISPLAY
          bcpk_id  LABEL "����"
 bcpk_part LABEL "�����"
  bcpk_part_desc LABEL "�������"
 bcpk_lot LABEL "��/���"
 bcpk_qty LABEL "����"
 bcpk_site  LABEL "�ص�"
 bcpk_loc LABEL "���Ͽ�λ"
 
   bcpkmes_qty LABEL "������"    
  
WITH NO-ROW-MARKERS SEPARATORS 8 DOWN WIDTH 29  TITLE "�����嵥".
DEF FRAME bcpk_pick
    
    bcpklist AT ROW 1.2 COL 1.3
   /* m_bcpk_loc AT ROW 2.4 COL 1*/
    bcpk_brw AT ROW 2.4 COL 1
    bcpk_button AT ROW 13.8 COL 10
    WITH SIZE 30 BY 16.5 TITLE "���ϵ�����"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
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

ENABLE  bcpklist /*m_bcpk_loc*/ WITH FRAME bcpk_pick IN WINDOW c-win.
/*DISABLE bcpk_part_desc  bcpk_part_desc1 WITH FRAME bcpk_pick .*/
 DISP  
    bcpk_brw 
    bcpk_button WITH FRAME bcpk_pick.
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
