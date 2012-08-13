{mfdeclre.i}
{bcdeclre.i }
{bcwin02.i}
     {bctitle.i}
   
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(20)" LABEL "零件描述".
DEF VAR bc_part_desc2 AS CHAR FORMAT "x(20)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "标准数量".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "拆分数量".
DEF TEMP-TABLE bcomstr LIKE b_co_mstr.
DEF VAR bc_pack AS CHAR FORMAT "x(8)" LABEL "包装号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF FRAME bc
    bc_id AT ROW 1.5 COL 4
    bc_part AT ROW 3 COL 2.5
   
    bc_part_desc1  AT ROW 4.5 COL 1
    bc_part_desc2  NO-LABEL AT ROW 5.5 COL 8.8

   bc_lot AT ROW 7 COL 1.6
    bc_pack AT ROW 8.5 COL 2.5
    bc_qty AT ROW 10 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
  /*  bc_qty_std AT ROW 9.5 COL 1*/
  

   
  
    WITH SIZE 30 BY 14 TITLE "条码重打"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_id  WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP  
   
   
  
    bc_qty 
  /* bc_qty_std*/
  
    WITH FRAME bc .
VIEW c-win.
ON CURSOR-DOWN OF bc_id
DO:
    
       ASSIGN bc_id.
       FIND FIRST b_co_mstr NO-LOCK WHERE b_co_code > bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_id
DO:
   
        ASSIGN bc_id.
       FIND LAST b_co_mstr NO-LOCK WHERE b_co_code < bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
   
END.
ON enter OF bc_id
DO:
      bc_id = bc_id:SCREEN-VALUE.
      APPLY 'entry':u TO bc_id.
     {bcrun.i ""bcmgcheck.p"" "(input ""bd"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         INPUT """", 
        input bc_id, 
        input """",
         input """", 
        input """",
         input """",
         INPUT """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
       ELSE DO:
           FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_pack = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  bc_qty_std = b_co_qty_std.
                  
                 /* FIND FIRST pt_mstr WHERE pt_part = bc_part NO-LOCK NO-ERROR.
       IF AVAILABLE pt_mstr THEN*/
           ASSIGN
            bc_part_desc1 = b_co_desc1
        bc_part_desc2 = b_co_desc2.
        DISP bc_part bc_lot bc_qty bc_pack bc_part_desc1 bc_part_desc2 WITH FRAME bc.
                  END.
           DISABLE bc_id WITH FRAME bc.
           RUN main.
       END.
END.
/*ON enter OF bc_part
DO:
    bc_part = bc_part:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""part"",
        input """",
        input bc_part, 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO: DISABLE bc_part WITH FRAME bc.
        ENABLE bc_lot WITH FRAME bc.
        END.
END.*/


/*
ON enter OF bc_lot
DO:
    bc_lot = bc_lot:SCREEN-VALUE.
   /* IF bc_lot = '' THEN DO:
        MESSAGE '批号不能为空!' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        ELSE DO:
       
      
         END.*/
     DISABLE bc_lot WITH FRAME bc.
        ENABLE bc_pack WITH FRAME bc.
END.

ON enter OF bc_pack
DO:
    bc_pack = bc_pack:SCREEN-VALUE.
    
       DISABLE bc_pack WITH FRAME bc.
        ENABLE bc_qty WITH FRAME bc.
       
END.

ON enter OF bc_qty
DO:
    bc_qty = DECIMAL(bc_qty:SCREEN-VALUE).
      
   IF bc_qty = ? OR bc_qty = 0 THEN DO:
        MESSAGE '数量不能为空或0' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        ELSE DO:
       
       DISABLE bc_qty WITH FRAME bc.
       /* ENABLE bc_qty_std WITH FRAME bc.*/
         END.
       
END.
/*ON enter OF bc_qty_std
DO:
    bc_qty_std = DECIMAL(bc_qty_std:SCREEN-VALUE).
      
   IF bc_qty_std = ? OR bc_qty_std = 0 THEN DO:
        MESSAGE '数量不能为空或0' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        ELSE DO:
        IF bc_qty_std >= bc_qty THEN DO:
        
       DISABLE bc_qty_std WITH FRAME bc.
        ENABLE bc_button WITH FRAME bc.
        END.
        ELSE DO:
MESSAGE '标准数量不得小于数当前/初始数量！' VIEW-AS ALERT-BOX error.
            
        UNDO,RETRY.   
        END.
         END.
       
END.*/

*/



ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PROCEDURE main:
      
              
 
  
/* OUTPUT TO VALUE(b_usr_printer).*/
  
 {bclabel.i ""zpl"" ""part"" "bc_id" "bc_part" 
     "bc_lot" "bc_pack" "bc_qty" }
     

     
     
     
    
     
     
   
       RELEASE b_co_mstr.         
     ENABLE bc_id WITH FRAME bc.  
     APPLY "entry":u TO bc_id.
               END.

{bctrail.i}
