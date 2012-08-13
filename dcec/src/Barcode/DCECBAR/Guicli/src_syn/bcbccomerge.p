{mfdeclre.i}
{bcdeclre.i }
{bcwin01.i}
     {bctitle.i}
    
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_merge_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9".
DEF VAR bc_lot AS CHAR FORMAT "x(8)" LABEL "批/序号".
DEF VAR bc_merge_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "合并数量".
DEF VAR oktocomt AS LOGICAL.
DEF VAR mcnt AS INT.
DEF VAR bc_merge_destid LIKE bc_id.
DEF TEMP-TABLE bcomstr LIKE b_co_mstr.
DEFINE QUERY bc_qry FOR bd_merge_list.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
          bd_merge_id  LABEL "条码" FORMAT "x(18)"
 bd_merge_part LABEL "零件号"
 
 bd_merge_lotser LABEL "批/序号"
bd_merge_pack LABEL "包装号"
        bd_merge_qty LABEL "数量" FORMAT "->>,>>>,>>9.9" 
        bd_merge_site LABEL "地点"
        bd_merge_loc LABEL "库位"
  
  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  SCROLLABLE TITLE "待合并清单".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF FRAME bc
    bc_id AT ROW 1.2 COL 4
    bc_brw AT ROW 3 COL 1
  /* bc_pkqty AT ROW 10 COL 4*/
   bc_merge_qty AT ROW 10.5 COL 1.3
  
   
    bc_button AT ROW 12 COL 10
    WITH SIZE 30 BY 14 TITLE "条码合并"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_id   bc_brw WITH FRAME bc IN WINDOW c-win.
FOR EACH bd_merge_list WHERE bd_merge_sess = g_sess EXCLUSIVE-LOCK:
    DELETE bd_merge_list.
END.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_merge_qty WITH FRAME bc.
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
          
         FIND FIRST b_co_mstr WHERE b_co_code = bc_id   EXCLUSIVE-LOCK NO-ERROR.
         
          {bcrun.i ""bcmgcheck.p"" "(input ""bd_merge"",
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
             
              
                      BC_MERGE_QTY = BC_MERGE_QTY + b_co_qty_cur.
                      
                      OPEN QUERY BC_QRY FOR EACH Bd_merge_list WHERE bd_merge_sess = g_sess NO-LOCK BY bd_merge_id.
                  DISP BC_MERGE_QTY WITH FRAME BC.    
                  mcnt = 0.
                  FOR EACH bd_merge_list NO-LOCK WHERE bd_merge_sess = g_sess:
                      mcnt = mcnt + 1.
                  END.
                  IF mcnt > 1 THEN ENABLE bc_button WITH FRAME bc.
                          ELSE DISABLE bc_button WITH FRAME bc.
                  END.
              
      
END.

     

ON 'choose':u OF bc_button
DO:
    DISABLE bc_button WITH FRAME bc.
    RUN main.
END.
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.




PROCEDURE main:
    DEF VAR bcprefix AS CHAR.
    
    bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).

    FIND FIRST bd_merge_list WHERE bd_merge_sess = g_sess NO-LOCK NO-ERROR.
       bc_merge_destid = bd_merge_id.
     FIND FIRST b_co_mstr WHERE b_co_code = bc_merge_destid EXCLUSIVE-LOCK  NO-ERROR.
     CREATE bcomstr.
     BUFFER-COPY b_co_mstr TO bcomstr.
   FOR EACH bd_merge_list  WHERE bd_merge_sess = g_sess NO-LOCK:
        FIND FIRST b_co_mstr WHERE b_co_mstr.b_co_code = bd_merge_id EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b_co_mstr THEN 
            assign
           
            b_co_mstr.b_co_status = 'ia'
            b_co_mstr.b_co_userid = g_user.

         
    END.
     CREATE b_co_mstr.
                   BUFFER-COPY
                       bcomstr 
                       EXCEPT bcomstr.b_co_code bcomstr.b_co_qty_cur  bcomstr.b_co_btype bcomstr.b_co_userid
                       TO
                        b_co_mstr
                       
                   ASSIGN
                   b_co_mstr.b_co_code = bcprefix + '001'
                   b_co_mstr.b_co_qty_cur = bc_merge_qty
                       b_co_mstr.b_co_btype = 'm'
                       b_co_mstr.b_co_userid = g_user.
         
     
    
   

   
        
  /* MESSAGE '合并成功!' VIEW-AS ALERT-BOX INFORMATION.*/
     
 
    
     FOR EACH bd_merge_list WHERE bd_merge_sess = g_sess EXCLUSIVE-LOCK:
         DELETE bd_merge_list.
     END.
     
  OPEN QUERY bc_qry FOR EACH bd_merge_list  WHERE bd_merge_sess = g_sess NO-LOCK.
 {bclabel.i ""zpl"" ""part"" "b_co_mstr.b_co_code" "b_co_mstr.b_co_part" 
     "b_co_mstr.b_co_lot" "b_co_mstr.b_co_ref" "b_co_mstr.b_co_qty_cur" "b_co_mstr.b_co_vend"}
     

     
     
    
      RELEASE b_co_mstr.
 RELEASE b_ld_det.
     ENABLE bc_id WITH FRAME bc.
     APPLY 'entry':u TO bc_id.
 END.
{bctrail.i}
