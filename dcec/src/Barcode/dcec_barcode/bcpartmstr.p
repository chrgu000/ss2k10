DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "�������".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".*/

DEF VAR bc_lot AS CHAR FORMAT "x(8)" LABEL "��/���".
DEF VAR bc_supp AS CHAR FORMAT "x(8)" LABEL "��Ӧ��".

DEFINE BUTTON bc_button LABEL "ȷ��" SIZE 8 BY 1.50.
DEF FRAME bc
    bc_id AT ROW 2 COL 4
    bc_part AT ROW 3.5 COL 2.5
   
    bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5
   bc_lot AT ROW 7.5 COL 1.6
    bc_qty AT ROW 9 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
   bc_supp AT ROW 10.5 COL 2.5

   
    bc_button AT ROW 12 COL 10
    WITH SIZE 30 BY 14 TITLE "ԭ��������ά��"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "BARCODEING"
         HEIGHT             = 14
         WIDTH              = 30
         MAX-HEIGHT         = 14
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

ENABLE bc_id bc_part WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP  
   
    bc_part_desc  
    bc_part_desc1  
   bc_lot 
    bc_qty 
   
  
    WITH FRAME bc .
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.