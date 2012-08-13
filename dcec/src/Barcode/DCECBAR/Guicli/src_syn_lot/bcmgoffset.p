{mfdeclre.i}
{bcdeclre.i  }
{bcwin13.i}
    {bctitle.i}

DEF VAR bc_offset AS INT FORMAT "->>,>>>,>>9" LABEL "偏移日期".
DEF VAR bc_min_lot AS LOGICAL LABEL '最小批次'.
DEFINE BUTTON bc_button LABEL "设置" SIZE 8 BY 1.20.

DEF FRAME bc
    bc_offset AT ROW 2 COL 2.5
    bc_min_lot AT ROW 3.5 COL 2.5
  /* bc_date1 AT ROW 9.6 COL 5.6*/
    bc_button AT ROW 5 COL 10
    
    WITH SIZE 30 BY 8 TITLE "偏移生效日期设置"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ENABLE bc_offset bc_min_lot bc_button WITH FRAME bc.
FIND FIRST b_ct_ctrl EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE b_ct_ctrl THEN do:
    bc_offset = INTEGER(b_ct_nrm) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN 
        ASSIGN b_ct_nrm = STRING(0)
               bc_offset = 0.
   bc_min_lot = LOGICAL(b_ct_up_mtd) NO-ERROR.
   
   IF ERROR-STATUS:ERROR OR bc_min_lot = ? THEN
        ASSIGN b_ct_up_mtd = STRING('yes')
               bc_min_lot = YES.
END.
  ELSE assign
      bc_offset = 0
      bc_min_lot = YES.
DISP bc_offset bc_min_lot WITH FRAME bc.
VIEW c-win.




ON VALUE-CHANGED OF bc_offset
DO:
 ASSIGN bc_offset.
END.
ON enter OF bc_offset
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    ASSIGN bc_offset.
   /* DISABLE bc_po_vend WITH FRAME bc.
    ENABLE bc_po_vend1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_min_lot.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.

ON VALUE-CHANGED OF bc_min_lot
DO:
 ASSIGN bc_min_lot.
END.
ON enter OF bc_min_lot
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    ASSIGN bc_min_lot.
   /* DISABLE bc_po_vend WITH FRAME bc.
    ENABLE bc_po_vend1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_button.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.





ON 'choose':U OF bc_button
DO:
   RUN main.
END.



ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PROCEDURE main:
    FIND FIRST b_ct_ctrl EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b_ct_ctrl THEN
       ASSIGN  b_ct_nrm = STRING(bc_offset)
               b_ct_up_mtd = STRING(bc_min_lot).
    ELSE
    DO:
        CREATE b_ct_ctrl.
      ASSIGN  b_ct_nrm = STRING(bc_offset)
             b_ct_up_mtd = STRING(bc_min_lot).
    END.
   END.
    

{bctrail.i}
