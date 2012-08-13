
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
         HEIGHT             = 35
         WIDTH              = 110
         MAX-HEIGHT         = 35
         MAX-WIDTH          = 110
         VIRTUAL-HEIGHT     = 35
         VIRTUAL-WIDTH      = 110
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
 DEFINE QUERY qry FOR j_wo_mstr.
    DEFINE BROWSE brw  QUERY qry
    DISPLAY
        
        j_wo_id LABEL "ID"    
       j_wo_part LABEL "Item"
        j_wo_qty LABEL "QTY"
           j_wo_type  LABEL "Type" 
         
      
           
            
         
    WITH   7 DOWN WIDTH 98 TITLE "计划外出/入库事务" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9  SEPARATORS.
 DEF FRAME wo_header
    SKIP(1)
    wo_id COLON 5 
    wo_part 
    wo_qty 
    wo_type SKIP(1)
         brw  COLON 1 SKIP(0.5)
      b-done1 AT COLUMN 15 ROW 14 
     b-done2 AT COLUMN 45 ROW 14 
     b-done3 AT COLUMN 75 ROW 14 SKIP(0.5)
   WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 100 BY 15.

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

OPEN QUERY qry   for each j_wo_mstr  NO-LOCK BY DESCENDING .
   
     
    VIEW c-win.
  ON LEAVE OF wo_id IN FRAME wo_header
  DO:
      FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE NO-LOCK NO-ERROR.
       ASSIGN wo_part:SCREEN-VALUE = j_wo_part
              wo_qty: SCREEN-VALUE = j_wo_qty
              wo_type:SCREEN-VALUE = j_wo_type.
      
      
      RETURN.
  END.
ON 'choose':U OF b-done1 

DO:
    iscontinue = YES.
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
           END.
           END.
       
       ON 'choose':U OF b-done2
       DO:
           FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE j_wo_mstr THEN DO:
          
           DELETE j_wo_mstr.
           MESSAGE "This Work Order have been deleted!" VIEW-AS  ALERT-BOX WARNING BUTTONS OK.
            OPEN QUERY qry   for each j_wo_mstr  NO-LOCK BY DESCENDING .
           END.
  
           
       END.
       
       
       
       
      
    /* WAIT-FOR CHOOSE OF b-done1.*/
       WAIT-FOR CLOSE OF THIS-PROCEDURE.
    /* END.*/
