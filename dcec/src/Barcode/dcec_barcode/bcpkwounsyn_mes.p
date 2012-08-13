DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bdpk_wo_nbr AS CHAR FORMAT "x(8)" LABEL "����".
DEF VAR bdpk_wo_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bdpk_wo_id AS CHAR FORMAT "x(8)" LABEL "��ʶ".
DEF VAR bdpkmes_file AS CHAR FORMAT "x(24)" LABEL "MES�ϵ�".
DEF VAR bdpk_file AS CHAR FORMAT "x(24)" LABEL "�첽�ӿ�".
DEFINE BUTTON bdpk_button LABEL "ȷ��" SIZE 8 BY 1.50.
DEF VAR m_bdpk_loc AS CHAR FORMAT "x(8)" LABEL "�߱߿�λ".
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
  bdpk_loc1 "�߱߿�λ"
   bdpkmes_qty LABEL "������"    
  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  TITLE "�����嵥".
DEF FRAME bdpk_pick
      bdpk_file at ROW 1.2 COL 1
    bdpk_wo_nbr AT ROW 2.4 COL 4
    bdpk_wo_id AT ROW 3.6 COL 4
    bdpk_wo_part AT ROW 4.8 COL 2.4
    bdpkmes_file AT ROW 6 COL 1.3
  
    m_bdpk_loc AT ROW 7.2 COL 1
    bdpk_brw AT ROW 8.4 COL 1
    bdpk_button AT ROW 16.5 COL 10
    WITH SIZE 30 BY 18.5 TITLE "�ӹ�������"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "DCEC BARCODEING"
         HEIGHT             = 18.5
         WIDTH              = 30
         MAX-HEIGHT         = 18.5
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

ENABLE bdpk_wo_nbr bdpk_wo_id bdpk_wo_part bdpk_file bdpkmes_file m_bdpk_loc WITH FRAME bdpk_pick IN WINDOW c-win.
/*DISABLE bdpk_part_desc  bdpk_part_desc1 WITH FRAME bdpk_pick .*/
 DISP  
    bdpk_brw 
    bdpk_button WITH FRAME bdpk_pick.
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
