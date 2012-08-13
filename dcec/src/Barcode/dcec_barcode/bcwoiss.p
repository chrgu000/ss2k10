DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_wo_nbr AS CHAR FORMAT "x(8)" LABEL "����".
DEF VAR bc_wo_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_wo_id AS CHAR FORMAT "x(8)" LABEL "��ʶ".
DEF VAR bc_wo_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
DEF VAR bc_mes_file AS CHAR FORMAT "x(24)" LABEL "�ϵ�".
DEFINE BUTTON bc_button LABEL "ȷ��" SIZE 8 BY 1.50.
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
          bc_id  LABEL "����"
 bc_part LABEL "�����"
  bc_part_desc LABEL "�������"
 bc_lot LABEL "��/���"
 bc_qty LABEL "����"
 bc_site  LABEL "�ص�"
 bc_loc LABEL "���Ͽ�λ"
  
   bc_mes_qty LABEL "������"    
  
WITH NO-ROW-MARKERS SEPARATORS 4 DOWN WIDTH 29  TITLE "�����嵥".
DEF FRAME bc_pick
    bc_wo_nbr AT ROW 1.2 COL 4
    bc_wo_id AT ROW 2.4 COL 4
    bc_wo_part AT ROW 3.6 COL 2.4
    bc_wo_qty AT ROW 4.8 COL 4
    bc_mes_file AT ROW 6 COL 4
   
    bc_brw AT ROW 7.2 COL 1
    bc_button AT ROW 14.5 COL 10
    WITH SIZE 30 BY 16.5 TITLE "�ӹ�������"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "BARCODEING"
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

ENABLE bc_wo_nbr bc_wo_id  bc_mes_file  WITH FRAME bc_pick IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc_pick .*/
 DISP  
    bc_brw 
    bc_button WITH FRAME bc_pick.
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
