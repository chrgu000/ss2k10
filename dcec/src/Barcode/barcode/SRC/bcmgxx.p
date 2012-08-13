DEFINE VAR C-Win AS WIDGET-HANDLE .
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 24
         WIDTH              = 90
         MAX-HEIGHT         = 24
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 24
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
DEFINE BUTTON b-done1 LABEL "Udate" SIZE 12 BY 1.2.

 DEF FRAME tst
    SKIP(1)
   B-done1 AT ROW 2 COL 4
   WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89 BY 24.


ASSIGN CURRENT-WINDOW                = c-win
       THIS-PROCEDURE:CURRENT-WINDOW = c-win.
C-Win:HIDDEN = no.
ENABLE b-done1 WITH FRAME tst.
 ON 'choose':U OF b-done1 

DO:
   
     RUN bcmgbdpro.p(INPUT 'e:\rep.cim',INPUT 'e:\out.txt').
     
    
 END.
 WAIT-FOR CHOOSE OF b-done1.





