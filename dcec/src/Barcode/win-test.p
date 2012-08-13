
DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR wo_id   AS CHAR VIEW-AS EDITOR SIZE 18 BY 1 LABEL "ID".
DEF VAR wo_part AS CHAR VIEW-AS EDITOR SIZE 18 BY 1 LABEL "Item".
DEF VAR wo_qty AS INT VIEW-AS FILL-IN SIZE 18 BY 1 LABEL "QTY".
DEF VAR wo_type AS CHAR VIEW-AS EDITOR SIZE 18 BY 1 LABEL "Type".
   DEFINE BUTTON b-done1 LABEL "Udate" SIZE 12 BY 1.2.
    DEFINE BUTTON b-done2 LABEL "Delete" SIZE 12 BY 1.2.
     DEFINE BUTTON b-done3 LABEL "Print" SIZE 12 BY 1.2.
     DEF VAR iscontinue AS LOGICAL.
     DEF VAR b AS INT.
    
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Work order maintenance"
         HEIGHT             = 27
         WIDTH              = 100
         MAX-HEIGHT         = 27
         MAX-WIDTH          = 100
         VIRTUAL-HEIGHT     = 27
         VIRTUAL-WIDTH      = 100
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
 DEFINE QUERY qry FOR pt_mstr.
    DEFINE BROWSE brw  QUERY qry
    DISPLAY
        /*pt_part*/
       /* j_wo_id LABEL "ID"    
       j_wo_part LABEL "Item"
        j_wo_qty LABEL "QTY"
           j_wo_type  LABEL "Type" */
         
      
           
            
         
    WITH   15 DOWN WIDTH 95 TITLE "计划外出/入库事务" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9  SEPARATORS.
 DEF FRAME wo_header
    SKIP(1)
    wo_id COLON 5 
    wo_part 
    wo_qty 
    wo_type SKIP(1)
         brw  COLON 1 SKIP(0.5)
      b-done1 AT COLUMN 15 ROW 21 
     b-done2 AT COLUMN 45 ROW 21 
     b-done3 AT COLUMN 75 ROW 21 SKIP(0.5)
   WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 97 BY 27.

/*REPEAT:*/
  

ASSIGN CURRENT-WINDOW                = c-win
       THIS-PROCEDURE:CURRENT-WINDOW = c-win.
C-Win:HIDDEN = no.
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
ENABLE ALL WITH frame wo_header IN WINDOW c-win.

/*OPEN QUERY qry   for each pt_mstr  NO-LOCK .*/
   
     
    VIEW c-win.
  ON LEAVE OF wo_id IN FRAME wo_header
  DO:
   
        
        IF WO_ID:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'AA'.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
        RETURN NO-APPLY.
            END.
        
        ELSE RETURN .
      /* FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE NO-LOCK NO-ERROR.
    END.
       ASSIGN wo_part:SCREEN-VALUE = j_wo_part
              wo_qty: SCREEN-VALUE = j_wo_qty
              wo_type:SCREEN-VALUE = j_wo_type.
      
      
      RETURN.*/
  END.
  ON ENTER OF wo_id IN FRAME wo_header
  DO:
   
        
        IF WO_ID:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'AA'.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
       
            END.
        
        ELSE APPLY "ENTRY":U TO WO_PART.
      /* FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE NO-LOCK NO-ERROR.
    END.
       ASSIGN wo_part:SCREEN-VALUE = j_wo_part
              wo_qty: SCREEN-VALUE = j_wo_qty
              wo_type:SCREEN-VALUE = j_wo_type.
      
      
      RETURN.*/
  END.
  ON TAB OF wo_id IN FRAME wo_header
  DO:
   
        
        IF WO_ID:SCREEN-VALUE = '' THEN DO:
        MESSAGE 'AA'.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
        RETURN NO-APPLY.
            END.
        
        ELSE RETURN .
      /* FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE NO-LOCK NO-ERROR.
    END.
       ASSIGN wo_part:SCREEN-VALUE = j_wo_part
              wo_qty: SCREEN-VALUE = j_wo_qty
              wo_type:SCREEN-VALUE = j_wo_type.
      
      
      RETURN.*/
  END.
ON 'choose':U OF b-done1 

DO:
   /* iscontinue = YES.
   IF wo_id:SCREEN-VALUE IN FRAME wo_header = '' THEN DO:
   MESSAGE "ID can't be blank!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      iscontinue = NO. 
       END.
       IF wo_part:SCREEN-VALUE IN FRAME wo_header = '' THEN DO:
   MESSAGE "part can't be blank!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      iscontinue = NO. 
       END.
        IF int(wo_qty:SCREEN-VALUE) IN FRAME wo_header <= 0  THEN DO:
   MESSAGE "QTY can't be zero or negative!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      iscontinue = NO. 
       END. 
       IF wo_type:SCREEN-VALUE IN FRAME wo_header <> '' AND wo_type:SCREEN-VALUE IN FRAME wo_header <> 'r' THEN DO:
   MESSAGE "part can't be blank!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      iscontinue = NO. 
       END.
       IF  iscontinue THEN DO:
           FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE NO-LOCK  NO-ERROR.
           IF AVAILABLE j_wo_mstr THEN DO:
          
         
          ASSIGN j_wo_id = wo_id:SCREEN-VALUE
                j_wo_part = wo_part:SCREEN-VALUE
               j_wo_qty =  int(wo_qty:SCREEN-VALUE)
               j_wo_type = wo_type:SCREEN-VALUE.
           

           END.
           ELSE DO:
            CREATE j_wo_mstr.
            ASSIGN j_wo_id = wo_id:SCREEN-VALUE
            j_wo_part = wo_part:SCREEN-VALUE
           j_wo_qty =  int(wo_qty:SCREEN-VALUE)
           j_wo_type = wo_type:SCREEN-VALUE.

               
               
               END.

           
           
       
           OPEN QUERY qry   for each j_wo_mstr  NO-LOCK BY DESCENDING .
           END.*/
           END.
       
       ON 'choose':U OF b-done2
       DO:
         /*  FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE j_wo_mstr THEN DO:
          
           DELETE j_wo_mstr.
           MESSAGE "This Work Order have been deleted!" VIEW-AS  ALERT-BOX WARNING BUTTONS OK.
            OPEN QUERY qry   for each j_wo_mstr  NO-LOCK BY DESCENDING .
           END.*/
  
           
       END.
     

      
      DEF VAR sub-win AS WIDGET-HANDLE .
          CREATE WINDOW sub-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Print"
         HEIGHT             = 5
         WIDTH              = 35
         MAX-HEIGHT         = 5
         MAX-WIDTH          = 35
         VIRTUAL-HEIGHT     = 5
         VIRTUAL-WIDTH      = 35
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
  ASSIGN CURRENT-WINDOW                = sub-win
       THIS-PROCEDURE:CURRENT-WINDOW = sub-win.
sub-Win:HIDDEN = no.
DEF VAR m_print AS CHAR INITIAL "print" VIEW-AS COMBO-BOX SORT INNER-LINES 3
LIST-ITEMS "print","notepad" LABEL "Output".
  DEFINE BUTTON b-done4 LABEL "OK" SIZE 8 BY 1.2.
    DEFINE BUTTON b-done5 LABEL "Cancel" SIZE 8 BY 1.2.
DEF FRAME wo_print
    SKIP(0.5)
    m_print  
    b-done4 COLON 20
    SKIP(0.5)
    b-done5 COLON 20

   WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 1
         SIZE 34 BY 5.
m_print:SCREEN-VALUE = m_print.
ENABLE ALL WITH FRAME wo_print IN WINDOW sub-win.
ON ESCAPE OF sub-win
DO:
   HIDE sub-win.
   APPLY "CLOSE":U TO THIS-PROCEDURE.

END.
ON WINDOW-CLOSE OF sub-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
 HIDE sub-win.
      APPLY "CLOSE":U TO THIS-PROCEDURE.
   
  RETURN NO-APPLY.
END.
VIEW sub-win. 
 WAIT-FOR CLOSE OF THIS-PROCEDURE.     

  
       /*  WAIT-FOR CLOSE OF THIS-PROCEDURE.*/
do on endkey undo, leave:
         pause 5.
      end.
      
    /* WAIT-FOR CHOOSE OF b-done1.*/
  
    /* END.*/
