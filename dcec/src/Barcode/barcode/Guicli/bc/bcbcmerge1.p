{mfdeclre.i}
{bcdeclre.i NEW}
{bcwin02.i}
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

DEFINE QUERY bc_qry FOR bd_merge_list.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
          bd_merge_id  LABEL "条码"
 bd_merge_part LABEL "零件号"
 
 bd_merge_lotser LABEL "批/序号"
bd_merge_pack LABEL "包装号"
        bd_merge_qty LABEL "数量" FORMAT "->>,>>>,>>9.9" 
 
   
  
WITH NO-ROW-MARKERS SEPARATORS 4 DOWN WIDTH 29  TITLE "待合并清单".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF FRAME bc
    bc_id AT ROW 1.2 COL 4
    bc_brw AT ROW 3 COL 1
  /* bc_pkqty AT ROW 10 COL 4*/
   bc_merge_qty AT ROW 10.5 COL 1.3
  
   
    bc_button AT ROW 12 COL 10
    WITH SIZE 30 BY 14 TITLE "条码合并"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_id   WITH FRAME bc IN WINDOW c-win.
FOR EACH bd_merge_list:
    DELETE bd_merge_list.
END.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP bc_merge_qty WITH FRAME bc.
VIEW c-win.

ON enter OF bc_id
DO:
      bc_id = bc_id:SCREEN-VALUE.
        
        {bcrun.i ""bcmgcheck.p"" "(input ""bd"",
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
        IF NOT success THEN 
        UNDO,RETRY.
      ELSE DO:
      FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE b_co_mstr THEN DO:
                  CREATE bd_merge_list.
                  bd_merge_id = b_co_code.
                  bd_merge_part = b_co_part.
                 IF b_co_lot <> '' THEN  bd_merge_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bd_merge_lot = string(b_co_ser).
                 bd_merge_pack = b_co_ref.
                  bd_merge_qty = b_co_qty_cur.
                  
                  
              END.
          
         
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
                      bc_merge_qty_std = bc_merge_qty_std + b_co_qty_std.
                      OPEN QUERY BC_QRY FOR EACH Bd_merge_list.
                  DISP BC_MERGE_QTY WITH FRAME BC.    
                  mcnt = 0.
                  FOR EACH bd_merge_list NO-LOCK:
                      mcnt = mcnt + 1.
                  END.
                  IF mcnt > 1 THEN ENABLE bc_button WITH FRAME bc.
                          ELSE DISABLE bc_button WITH FRAME bc.
                  END.
              
      
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
        FOR FIRST bd_merge_list NO-LOCK BY bd_merge_id:
       bc_merge_destid = bd_merge_id.
    END.
   FIND FIRST b_co_mstr WHERE b_co_code = bc_merge_destid EXCLUSIVE-LOCK  NO-ERROR.
     b_co_qty_cur = bc_merge_qty.
     b_co_qty_std = bc_merge_qty_std.
    FOR EACH bd_merge_list WHERE bd_merge_id <> bc_merge_destid NO-LOCK:
        FIND FIRST b_co_mstr WHERE b_co_code = bd_merge_id EXCLUSIVE-LOCK NO-ERROR.
        IF AVAILABLE b_co_mstr THEN DELETE b_co_mstr.
        DELETE bd_merge_list.
    END.
   
                    {bcusrhist.i }
   MESSAGE '合并成功!' VIEW-AS ALERT-BOX INFORMATION.
     MESSAGE "是否打印？" SKIP(1)
        "继续?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.
 IF oktocomt THEN DO:
 
    
     
     FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.
    IF b_usr_prt_typ <> 'ipl' AND b_usr_prt_typ <> 'zpl' THEN DO:
    MESSAGE '本系统暂不支持除了ipl,zpl类型的条码打印机!' VIEW-AS ALERT-BOX ERROR.

        LEAVE.
        END.
 OUTPUT TO VALUE(b_usr_printer).
  
 {bclabel.i "b_usr_prt_typ" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" }
     

     
     
     MESSAGE '打印完毕！' VIEW-AS ALERT-BOX INFORMATION.
     
     
     
     
     END.
      RELEASE b_co_mstr.
     ENABLE bc_id WITH FRAME bc.
 END.
{bctrail.i}
