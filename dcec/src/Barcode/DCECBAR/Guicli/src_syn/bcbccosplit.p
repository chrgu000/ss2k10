{mfdeclre.i}
{bcdeclre.i  }
{bcwin02.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/

DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "拆分数量".
DEF TEMP-TABLE bcomstr LIKE b_co_mstr.
DEF TEMP-TABLE bcoprt LIKE b_co_mstr.
DEF VAR bc_pack AS CHAR FORMAT "x(8)" LABEL "包装号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.

DEF FRAME bc
    bc_id AT ROW 2 COL 4
    bc_part AT ROW 3.5 COL 2.5
   
   /* bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5*/

   bc_lot AT ROW 5 COL 1.6
    bc_pack AT ROW 6.5 COL 2.5
    bc_qty AT ROW 8 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
   bc_split_qty AT ROW 9.5 COL 1.3

   
   
    WITH SIZE 30 BY 12 TITLE "条码拆分"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_id  WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 /*DISP  
   
   
   bc_lot 
    bc_qty 
   bc_split_qty
  
    WITH FRAME bc .*/
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
     

          FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
          
          {bcrun.i ""bcmgcheck.p"" "(input ""bd_exp"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"} 
          IF NOT success THEN UNDO,RETRY.
             ELSE
               do:
              DISABLE bc_id WITH FRAME bc.
              
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_pack = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot bc_pack bc_qty WITH FRAME bc.
                  END.
              ENABLE bc_split_qty WITH FRAME bc.
      END.
         
END.

ON enter OF bc_split_qty
DO:
    bc_split_qty = decimal(bc_split_qty:SCREEN-VALUE).
    IF bc_split_qty >= bc_qty OR bc_split_qty = 0 THEN DO:
        MESSAGE '拆分数量超过原数量或等于零！' VIEW-AS ALERT-BOX.
        UNDO,RETRY.
    END.
    ELSE do:
        DISABLE bc_split_qty WITH FRAME bc.
          RUN main.
    END.
END.




ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PROCEDURE main:
      DEF  VAR bcprefix AS CHAR.
      DEF VAR bcorist LIKE b_co_status.
      DEF VAR bc_qty_label AS INT.
DEF  VAR i AS INT.
DEF VAR isld AS LOGICAL.
      bc_qty_label = IF (bc_qty MOD bc_split_qty = 0) THEN (bc_qty / bc_split_qty) ELSE TRUNCATE(bc_qty / bc_split_qty,0) + 1.
 bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
 
 FIND FIRST b_co_mstr WHERE b_co_mstr.b_co_code = bc_id  EXCLUSIVE-LOCK NO-ERROR.
 bcorist = b_co_status.                  
 b_co_status = 'ia'.
              CREATE bcomstr.
              BUFFER-COPY 
                  b_co_mstr TO
                  bcomstr.
                
              
              DO i = 1 TO bc_qty_label:
              IF i MOD 1000 = 0 THEN do:
                  PAUSE 1.
                   MESSAGE '已生成1000张标签!' VIEW-AS ALERT-BOX.
                  bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
              END.
              CREATE b_co_mstr.
                   BUFFER-COPY
                       bcomstr 
                       EXCEPT bcomstr.b_co_code bcomstr.b_co_qty_cur  bcomstr.b_co_status bcomstr.b_co_btype bcomstr.b_co_userid
                       TO
                        b_co_mstr
                       
                   ASSIGN
                   b_co_mstr.b_co_code = bcprefix + STRING(i MOD 1000,'999')
                   b_co_mstr.b_co_qty_cur = IF i < bc_qty_label THEN bc_split_qty ELSE IF bc_qty MOD bc_split_qty = 0 THEN bc_split_qty ELSE bc_qty MOD bc_split_qty
                       b_co_mstr.b_co_status = bcorist
                       b_co_mstr.b_co_btype = 's'
                       b_co_mstr.b_co_userid = g_user.
                  CREATE bcoprt.
                  BUFFER-COPY
                      b_co_mstr TO bcoprt.
                 
                
                 
                 

               
                 
               
              END.
 
    FOR EACH bcoprt NO-LOCK:
    
 {bclabel.i ""zpl"" ""part"" "bcoprt.b_co_code" "bcoprt.b_co_part" 
     "bcoprt.b_co_lot" "bcoprt.b_co_ref" "bcoprt.b_co_qty_cur" "bcoprt.b_co_vend"}
     DELETE bcoprt.
    END.
    
     
    
     
     
     
    
      RELEASE b_co_mstr. 
     
     ENABLE bc_id WITH FRAME bc.    
     APPLY 'entry':u TO bc_id.
               END.

{bctrail.i}
