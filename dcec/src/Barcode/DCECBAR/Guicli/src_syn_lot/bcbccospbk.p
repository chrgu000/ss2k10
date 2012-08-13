{mfdeclre.i}
{bcdeclre.i  }
{bcwin00.i 12}
     {bctitle.i}
    
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_merge_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批号".
DEF VAR bc_merge_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "合并数量".
DEF VAR oktocomt AS LOGICAL.
DEF VAR mcnt AS INT.
DEF VAR bc_merge_destid LIKE bc_id.
DEF VAR bc_site AS CHAR FORMAT 'x(18)' LABEL '地点'.
DEF VAR bc_loc AS CHAR FORMAT 'x(8)' LABEL '库位'.
DEF VAR msite AS CHAR.
 DEFINE BUTTON bc_button LABEL "打印" SIZE 8 BY 1.50.
DEFINE QUERY bc_qry FOR b_co_mstr.
    DEFINE BROWSE bc_brw  QUERY bc_qry
    DISPLAY
          b_co_code  LABEL "条码" FORMAT "x(18)"
        b_co_part  LABEL '零件号'
        b_co_site LABEL '地点'
        b_co_loc  LABEL '库位'

  
  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  SCROLLABLE TITLE "回滚清单".

DEF FRAME bc
   
    
    bc_lot AT ROW 1.2 COL 4 
   bc_brw AT ROW  2.4 COL 1.2
  /* bc_pkqty AT ROW 10 COL 4*/
   
 
   
    
    WITH SIZE 30 BY 12 TITLE "条码拆分回滚"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CURRENT-WINDOW:NAME = 'w'.
ENABLE   bc_lot bc_brw /*bc_brw*//*bc_part bc_lot bc_brw */ WITH FRAME bc IN WINDOW c-win.

/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/

VIEW c-win.





ON CURSOR-DOWN OF bc_lot
DO:
    
       ASSIGN bc_lot.
       FIND FIRST b_co_mstr USE-INDEX b_co_lot NO-LOCK WHERE /*b_co_part = bc_part AND*/   b_co_lot > bc_lot  NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_lot = b_co_lot.
           DISPLAY bc_lot WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_lot
DO:
   
       ASSIGN bc_lot.
       FIND LAST b_co_mstr USE-INDEX b_co_lot NO-LOCK WHERE /*b_co_part = bc_part AND*/  b_co_lot < bc_lot NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_lot = b_co_lot.
           DISPLAY bc_lot WITH FRAME bc.
       END.
END.
ON enter OF bc_lot
DO:
     ASSIGN bc_lot.
     IF bc_lot = '' THEN DO:
         MESSAGE '批号不能为空！' VIEW-AS ALERT-BOX ERROR.
         RETRY.
         END.
     ELSE DO:
    
   RUN main.
  
     END.
END.
/*ON VALUE-CHANGED OF bc_lot
DO:
     ASSIGN bc_lot.
   
END.*/

     
/*
ON 'choose':u OF bc_button
DO:
    DISABLE bc_button WITH FRAME bc.
    RUN main.
END.*/
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
ON 'mouse-select-dblclick':U OF bc_brw
DO:
    DEF VAR oktocmt AS LOGICAL.
    MESSAGE '确认回滚吗?' VIEW-AS ALERT-BOX QUESTION BUTTON YES-NO UPDATE oktocmt.
    IF oktocmt THEN RUN rollback.
END.

PROCEDURE rollback:
    DEF VAR bc_id AS CHAR.
    DEF VAR bc_part AS CHAR.
    DEF VAR bc_site AS CHAR.
    DEF VAR bc_loc AS CHAR.
   DEF VAR succ AS LOGICAL.
    DEF VAR pre_st AS CHAR.
    DEF  VAR isfirst AS LOGICAL.
    DEF VAR mqty AS DECIMAL.
    ASSIGN bc_id = b_co_mstr.b_co_code.
    FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.

      ASSIGN    bc_part = b_co_part
         bc_site = b_co_site
       bc_loc = b_co_loc
          
          bc_qty = b_co_qty_cur.
       pre_st = '' . 
   isfirst = YES.
   succ = YES.
    FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE b_co_part = bc_part AND b_co_lot = bc_lot AND b_co_site = bc_site AND b_co_loc = bc_loc AND b_co_status <> 'ia' AND   b_co_btype = 's' AND b_co_qty_cur < bc_qty  EXCLUSIVE-LOCK:
      IF isfirst THEN do:
          pre_st = b_co_status.
          isfirst = NO.
      END.
        ELSE DO:
            IF pre_st <> b_co_status THEN DO:
                MESSAGE '状态不一致,不符合回滚规则!' VIEW-AS ALERT-BOX ERROR.
                succ = NO.
                LEAVE.
            END.
            ELSE pre_st = b_co_status.
        END.
    END.
    IF NOT succ  THEN LEAVE.
    mqty = 0.
    FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE b_co_part = bc_part AND b_co_lot = bc_lot AND b_co_site = bc_site AND b_co_loc = bc_loc AND b_co_status <> 'ia' AND   b_co_btype = 's' AND b_co_qty_cur < bc_qty  EXCLUSIVE-LOCK:
        mqty = mqty + b_co_qty_cur.
        END.
        IF mqty <> bc_qty THEN DO:
            MESSAGE '数量不一致,不符合回滚规则!' VIEW-AS ALERT-BOX ERROR.
            LEAVE.
        END.
FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE b_co_part = bc_part AND b_co_lot = bc_lot AND b_co_site = bc_site AND b_co_loc = bc_loc AND b_co_status <> 'ia' AND   b_co_btype = 's' AND b_co_qty_cur < bc_qty  EXCLUSIVE-LOCK:
    assign
        b_co_status = 'ia'
       /* b_co_btype = 'sr'*/.

    END.
    FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK.
     ASSIGN
         b_co_status = pre_st.
        END.

PROCEDURE main:
    
     
    
    OPEN QUERY bc_qry FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE b_co_lot = bc_lot AND b_co_status = 'ia' AND (b_co_btype = '' OR b_co_btype = 'm') NO-LOCK.
    
     
 END.
{bctrail.i}
