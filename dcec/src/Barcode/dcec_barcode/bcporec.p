DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_po_part_desc AS CHAR FORMAT "x(24)" LABEL "�������".
DEF VAR bc_po_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".

DEF VAR bc_po_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "�ص�".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "���Ͽ�λ".
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)" LABEL "�ɹ���".
DEF VAR bc_po_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_po_line AS CHAR FORMAT "x(8)" LABEL "�к�".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "��/���".
DEFINE BUTTON bc_button LABEL "ȷ��" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "ת��".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "��־".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "����".
DEF FRAME bc
    bc_po_nbr AT ROW 1.2 COL 2.5
    bc_po_line AT ROW 2.4 COL 4
  bc_po_part AT ROW 3.6 COL 2.5
    bc_po_qty AT ROW 4.8 COL 4
    /*bc_po_part_desc  AT ROW 6 COL 1
    bc_po_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
    bc_sub AT ROW 6 COL 4
    bc_wo AT ROW 7.2 COL 4
    bc_woid AT ROW 8.4 COL 4
    bc_id AT ROW 9.4 COL 4
    bc_part AT ROW 10.6 COL 2.5
   
    
   bc_lot AT ROW 11.8 COL 1.6
    bc_qty AT ROW 13 COL 4
   
    bc_site AT ROW 14.2 COL 4

    bc_loc AT ROW 15.4 COL 1
  
   
    bc_button AT ROW 16.5 COL 10
    WITH SIZE 30 BY 18.5 TITLE "�ɹ��ջ�"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "BARCODEING"
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

ENABLE bc_po_nbr 
    bc_po_line
  
    bc_id 
     WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_po_part_desc  bc_po_part_desc1 WITH FRAME bc_pick .*/
 DISP bc_part 
   bc_po_qty
  /*  bc_po_part_desc  
    bc_po_part_desc1  */
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.