DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "�������".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".*/
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "�ص�".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "��λ".
DEF VAR bc_lot AS CHAR FORMAT "x(8)" LABEL "��/���".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "�ص�".
DEF VAR bc_so_job AS CHAR FORMAT "x(8)" LABEL "����".
DEFINE BUTTON bc_button LABEL "ȷ��" SIZE 8 BY 1.50.
DEF FRAME bc
    bc_id AT ROW 1.5 COL 4
    bc_part AT ROW 3 COL 2.5
   
    bc_part_desc  AT ROW 4.5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 5.5 COL 8.5
   bc_lot AT ROW 7 COL 1.6
    bc_qty AT ROW 8.5 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
    bc_site AT ROW 10 COL 4

    bc_loc AT ROW 11.5 COL 4
  bc_so_job AT ROW 13 COL 4
   
    bc_button AT ROW 14.5 COL 10
    WITH SIZE 30 BY 16.5 TITLE "�ƻ������"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
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

ENABLE bc_id WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_part 
   
    bc_part_desc  
    bc_part_desc1  
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .
VIEW c-win.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
