
DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR wo_id   AS CHAR VIEW-AS EDITOR SIZE 15 BY 1 LABEL "ID".
DEF VAR wo_part AS CHAR VIEW-AS EDITOR SIZE 18 BY 1 LABEL "Item".
DEF VAR wo_qty AS CHAR VIEW-AS EDITOR SIZE 12 BY 1 LABEL "QTY".
DEF VAR wo_type AS CHAR VIEW-AS EDITOR SIZE 5 BY 1 LABEL "Type".
DEF VAR WO_ST AS CHAR LABEL "Status" FORMAT "x(1)" INITIAL 'F'.   
DEFINE BUTTON b-done1 LABEL "Udate" SIZE 12 BY 1.2.
    DEFINE BUTTON b-done2 LABEL "Delete" SIZE 12 BY 1.2.
     DEFINE BUTTON b-done3 LABEL "Print" SIZE 12 BY 1.2.
     DEF VAR iscontinue AS LOGICAL.
     DEF VAR b AS INT.
    
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Work order maintenance"
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
 DEFINE QUERY qry FOR j_wo_mstr.
    DEFINE BROWSE brw  QUERY qry
    DISPLAY
        
       j_wo_id LABEL "ID"    
       j_wo_part LABEL "Item"
        j_wo_qty LABEL "QTY"
          CAPS( j_wo_type)  LABEL "Type" FORMAT "x(10)" 
         j_wo_status LABEL "Status" FORMAT "x(10)" 
      
           
            
         
    WITH   15 DOWN WIDTH 83 TITLE "Work Order" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9  SEPARATORS.
 DEF FRAME wo_header
    SKIP(1)
    wo_id COLON 5 
    wo_part 
    wo_qty 
    wo_type 
     WO_ST 
     SKIP(1)
         brw  COLON 2.5 SKIP(0.5)
      b-done1 AT COLUMN 15 ROW 20.5 
     b-done2 AT COLUMN 40 ROW 20.5 
     b-done3 AT COLUMN 62 ROW 20.5 SKIP(0.5)
   WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89 BY 24.

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
ENABLE wo_id wo_part wo_type wo_qty brw b-done1 b-done2 b-done3 WITH frame wo_header IN WINDOW c-win.
 DISP wo_st WITH FRAME wo_header.
OPEN QUERY qry   for each j_wo_mstr  NO-LOCK BY j_wo_id DESCENDING .
   
     
    VIEW c-win.
    ON LEFT-MOUSE-CLICK OF brw IN FRAME wo_header
DO:
 ASSIGN WO_ID:SCREEN-VALUE =  J_WO_MSTR.J_WO_ID
          WO_PART:SCREEN-VALUE =  J_WO_MSTR.J_WO_PART
       WO_QTY:SCREEN-VALUE =  STRING(J_WO_MSTR.J_WO_QTY)
       WO_TYPE:SCREEN-VALUE =  CAPS(J_WO_MSTR.J_WO_TYPE)
          WO_ST = J_WO_MSTR.J_WO_STATUS.
       .
     
   DISP WO_ST WITH FRAME WO_HEADER.
END.
 /* ON LEAVE OF wo_id IN FRAME wo_header
  DO:
        IF WO_ID:SCREEN-VALUE = '' THEN DO:
             MESSAGE "ID can't be blank!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
        RETURN NO-APPLY.
            END.
        
        ELSE DO:
      


      FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE NO-LOCK NO-ERROR.
        IF AVAILABLE j_wo_mstr THEN
          ASSIGN wo_part:SCREEN-VALUE = j_wo_part
              wo_qty:SCREEN-VALUE = string(j_wo_qty)
              wo_type:SCREEN-VALUE = j_wo_type
             wo_st = j_wo_status.
    DISP wo_st WITH FRAME wo_header.
        RETURN.  
      END.
  END.*/
   ON ENTER OF wo_id IN FRAME wo_header
  DO:
   
        
        IF WO_ID:SCREEN-VALUE = '' THEN DO:
        MESSAGE "ID can't be blank!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
       
            END.
        
        ELSE DO:
      FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF AVAILABLE j_wo_mstr THEN
            ASSIGN wo_part:SCREEN-VALUE = j_wo_part
              wo_qty:SCREEN-VALUE = string(j_wo_qty)
              wo_type:SCREEN-VALUE = j_wo_type
            wo_st = j_wo_status.
            APPLY "ENTRY":U TO WO_PART.
        END.
   END.
    ON TAB OF wo_id IN FRAME wo_header
  DO:
   
        
        IF WO_ID:SCREEN-VALUE = '' THEN DO:
        MESSAGE "ID can't be blank!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
          RETURN NO-APPLY.
            END.
        
        ELSE DO:
      FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE NO-LOCK NO-ERROR.
       IF AVAILABLE j_wo_mstr THEN
            ASSIGN wo_part:SCREEN-VALUE = j_wo_part
              wo_qty:SCREEN-VALUE = string(j_wo_qty)
              wo_type:SCREEN-VALUE = j_wo_type
            wo_st = j_wo_status.
           
        END.
   END.
   /*ON LEAVE OF wo_part IN FRAME wo_header
  DO:
       FIND pt_mstr WHERE pt_part = wo_part:SCREEN-VALUE NO-LOCK NO-ERROR. 
    
       
       
       IF NOT AVAILABLE pt_mstr THEN DO:
             MESSAGE "Invalid Item!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
        RETURN NO-APPLY.
            END.
        
        ELSE DO:
      


      
      
      
      RETURN.  
      END.
  END.*/
   ON ENTER OF wo_part IN FRAME wo_header
  DO:
   
        FIND pt_mstr WHERE pt_part = wo_part:SCREEN-VALUE NO-LOCK NO-ERROR. 
    
       
       
       IF NOT AVAILABLE pt_mstr THEN DO:
        MESSAGE "Invalid Item!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
       
            END.
        
        ELSE DO:
     
            APPLY "ENTRY":U TO WO_QTY.
        END.
   END.
    ON TAB OF wo_part IN FRAME wo_header
  DO:
   
        FIND pt_mstr WHERE pt_part = wo_part:SCREEN-VALUE NO-LOCK NO-ERROR. 
    
       
       
       IF NOT AVAILABLE pt_mstr THEN DO:
        MESSAGE "Invalid Item!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
          RETURN NO-APPLY.
            END.
        
        ELSE DO:
      
           
        END.
   END.
    /*ON LEAVE OF wo_qty IN FRAME wo_header
  DO:
        IF (wo_qty:SCREEN-VALUE < '0' OR wo_qty:SCREEN-VALUE > '9')  THEN DO:
            MESSAGE "Invalid QTY!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
             RETURN NO-APPLY.
            
            END.
        IF int(WO_qty:SCREEN-VALUE) <= 0 THEN DO:
              MESSAGE "QTY can't be zero or negative!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
        RETURN NO-APPLY.
            END.
        
        ELSE DO:
      


      
      
      
      RETURN.  
      END.
  END.*/
   
  ON ENTER OF wo_qty IN FRAME wo_header
  DO:
    IF (wo_qty:SCREEN-VALUE < '0' OR wo_qty:SCREEN-VALUE > '9') THEN DO:
            MESSAGE "Invalid QTY!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
             RETURN NO-APPLY.
            
            END.
        
       IF int(WO_qty:SCREEN-VALUE) <= 0 THEN DO:
              MESSAGE "QTY can't be zero or negative!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.

            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
       
            END.
        
        ELSE DO:
     
            APPLY "ENTRY":U TO wo_type.
        END.
   END.
    ON TAB OF wo_qty IN FRAME wo_header
  DO:
   
         IF (wo_qty:SCREEN-VALUE < '0' OR wo_qty:SCREEN-VALUE > '9')  THEN DO:
            MESSAGE "Invalid QTY!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
             RETURN NO-APPLY.
            
            END.
      IF int(WO_qty:SCREEN-VALUE) <= 0 THEN DO:
              MESSAGE "QTY can't be zero or negative!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.

            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
          RETURN NO-APPLY.
            END.
        
        ELSE DO:
      
           
        END.
   END.
   ON VALUE-CHANGED OF wo_qty IN FRAME wo_header
  DO:
     IF (wo_qty:SCREEN-VALUE < '0' OR wo_qty:SCREEN-VALUE > '9') THEN
         wo_qty:SCREEN-VALUE = ''.
        
   END.
   /* ON LEAVE OF wo_type IN FRAME wo_header
  DO:
         IF wo_type:SCREEN-VALUE IN FRAME wo_header <> '' AND wo_type:SCREEN-VALUE IN FRAME wo_header <> 'r' THEN DO:
   MESSAGE "Invalid type!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           RETURN NO-APPLY.
            END.
        
        ELSE DO:
      


      
      
      
      RETURN.  
      END.
  END.*/
   ON ENTER OF wo_type IN FRAME wo_header
  DO:
   
        
       IF wo_type:SCREEN-VALUE IN FRAME wo_header <> '' AND wo_type:SCREEN-VALUE IN FRAME wo_header <> 'r' THEN DO:
   MESSAGE "Invalid type!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
       
            END.
        
        ELSE DO:
     
            APPLY "ENTRY":U TO WO_id.
        END.
   END.
    ON TAB OF wo_type IN FRAME wo_header
  DO:
   
        
      IF wo_type:SCREEN-VALUE IN FRAME wo_header <> '' AND wo_type:SCREEN-VALUE IN FRAME wo_header <> 'r' THEN DO:
   MESSAGE "Invalid type!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            /*WAIT-FOR LEAVE OF WO_ID FOCUS WO_ID.*/
          RETURN NO-APPLY.
            END.
        
        ELSE DO:
      
           
        END.
   END.
  
   ON 'choose':U OF b-done1 

DO:
     
    iscontinue = YES.
   IF wo_id:SCREEN-VALUE IN FRAME wo_header = '' THEN DO:
   MESSAGE "ID can't be blank!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      iscontinue = NO. 
       END.
        FIND pt_mstr WHERE pt_part = wo_part:SCREEN-VALUE NO-LOCK NO-ERROR. 
    
       
       
       IF NOT AVAILABLE pt_mstr THEN DO:
        MESSAGE "Invalid Item!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      iscontinue = NO. 
       END.
       
         IF (wo_qty:SCREEN-VALUE < '0' OR wo_qty:SCREEN-VALUE > '9')  THEN DO:
            MESSAGE "Invalid QTY!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            iscontinue = NO.
         END.
         ELSE
         DO:
              IF int(wo_qty:SCREEN-VALUE IN FRAME wo_header) <= 0  THEN DO:
   MESSAGE "QTY can't be zero or negative!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      iscontinue = NO. 
       END. 
             END.
       IF wo_type:SCREEN-VALUE IN FRAME wo_header <> '' AND wo_type:SCREEN-VALUE IN FRAME wo_header <> 'r' THEN DO:
   MESSAGE "Invalid type!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
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
           j_wo_type = CAPS(wo_type:SCREEN-VALUE).
           j_wo_status = 'F'.
               
               
               END.

           wo_st = j_wo_status.
           
       
           OPEN QUERY qry   for each j_wo_mstr  NO-LOCK BY j_wo_id DESCENDING .
           END.
           END.
       
       ON 'choose':U OF b-done2
       DO:
         FIND FIRST j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE j_wo_mstr THEN DO:
          
           DELETE j_wo_mstr.
           MESSAGE "This Work Order have been deleted!" VIEW-AS  ALERT-BOX WARNING BUTTONS OK.
            OPEN QUERY qry   for each j_wo_mstr  NO-LOCK BY j_wo_id DESCENDING .
           END.
  
           
       END.
        ON 'choose':U OF b-done3
        DO:
     DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 8 BY 1.17
     BGCOLOR 8 .


DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 8 BY 1.17
     BGCOLOR 8 .
DEF VAR m_print AS CHAR INITIAL "Print" VIEW-AS COMBO-BOX SIZE 14 BY 1 SORT INNER-LINES 3
    LIST-ITEMS "Print","Notepad" LABEL "Output" .
DEFINE FRAME Dialog-Frame
    SKIP(0.5)
    m_print AT ROW 1.5 COL 2.5
     Btn_OK AT ROW 1.5 COL 25
   
    Btn_Cancel AT ROW 2.95 COL 25
    
     
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         TITLE "Print"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel SIZE 37 BY 6.
         ENABLE Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
         m_print:SCREEN-VALUE = 'Print'.
         ENABLE ALL WITH FRAME dialog-frame.
         VIEW FRAME Dialog-Frame.
      ON WINDOW-CLOSE OF FRAME Dialog-Frame /* <insert dialog title> */
DO:
  APPLY "END-ERROR":U TO SELF.
END.
      
      ON 'choose':U OF btn_ok
      DO:
          DEF VAR itemdesc AS CHAR FORMAT "x(48)".
          DEF FRAME out
             SKIP(5)
              "Work order" AT 12
              SKIP(2)
              j_wo_id  AT 12 LABEL "WO"
             SKIP(1)
             j_wo_part AT 12 LABEL "Item" 
             
              j_wo_qty AT 50 LABEL "QTY"
           SKIP(1)
             itemdesc  AT 12 LABEL "Description"
          SKIP(1)
             j_wo_type AT 12 LABEL "Type"
             j_wo_status AT 35 LABEL "Status"
             WITH WIDTH 100 STREAM-IO SIDE-LABELS.
            FIND pt_mstr WHERE pt_part = j_wo_mstr.j_wo_part  NO-LOCK NO-ERROR.
          
          /*FIND j_wo_mstr WHERE j_wo_id = wo_id:SCREEN-VALUE IN FRAME wo_header NO-LOCK NO-ERROR.*/
           itemdesc = pt_desc1 + pt_desc2.
          IF m_print:SCREEN-VALUE = 'print'  THEN DO:
            
             
             OUTPUT TO prt.

             DISP j_wo_mstr.j_wo_id j_wo_mstr.j_wo_part j_wo_mstr.j_wo_qty
               pt_desc1 + pt_desc2 @ itemdesc
                 caps(j_wo_mstr.j_wo_type) j_wo_mstr.j_wo_status WITH FRAME out.
             OUTPUT CLOSE.
             DEF VAR l_successful AS LOGICAL.
            
          RUN osprint1.p(
        INPUT ?,                    /* parentWindowHandle */
        INPUT 'prt',           /* printFile */
        INPUT 5,         /* fontNumber */
        INPUT 1,          /* useDialog */
        INPUT 0,                    /* pageSize */
        INPUT 0,                    /* pageCount */
        INPUT YES,  /* clear session printer context */
        OUTPUT l_successful  ) .  
                /* returnCode */
 

             
             END.
             ELSE DO:
              OUTPUT TO notepad.txt.
             
               DISP j_wo_mstr.j_wo_id j_wo_mstr.j_wo_part j_wo_mstr.j_wo_qty
               pt_desc1 + pt_desc2 @ itemdesc
                 caps(j_wo_mstr.j_wo_type) j_wo_mstr.j_wo_status WITH FRAME out.
              
                 
         OUTPUT CLOSE.

            DOS SILENT VALUE('notepad notepad.txt').     
                 
                 
                 
                 END.
      
             
             
             
             
             
             
             END.





WAIT-FOR GO OF FRAME dialog-frame.       
            
            END.
       
       
       
      
    /* WAIT-FOR CHOOSE OF b-done1.*/
       WAIT-FOR CLOSE OF THIS-PROCEDURE.
    /* END.*/
