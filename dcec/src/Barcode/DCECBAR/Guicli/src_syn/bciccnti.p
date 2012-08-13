{bcdeclre.i  }
    {bcwin02.i}
    {bctitle.i}
  
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/

DEF VAR bc_lot AS CHAR FORMAT "x(8)" LABEL "批/序号".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".

DEFINE BUTTON bc_button LABEL "盘亏调整" SIZE 8 BY 1.50.
DEF VAR msite AS CHAR.
DEF FRAME bc
    
    bc_site AT ROW 1.5 COL 4
    bc_loc AT ROW 3 COL 4
    bc_id AT ROW 4.5 COL 4
    bc_part AT ROW 6 COL 2.5
   
   /* bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5*/
   bc_lot AT ROW 7.5 COL 1.6
    bc_qty AT ROW 9 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
   

   
  
    WITH SIZE 30 BY 12 TITLE "初盘扫描"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
VIEW c-win.

ENABLE bc_site   WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 /*DISP  
   bc_part
    bc_part_desc  
    bc_part_desc1  
   bc_lot 
    bc_qty 
   
  
    WITH FRAME bc .*/
VIEW c-win.

ON enter OF bc_site
DO:
         
         bc_site = bc_site:SCREEN-VALUE.
         APPLY 'entry':u TO bc_site.
         msite = bc_site.
         bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
         
        
             
          {bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
        input bc_site,
        input bc_loc, 
        input """", 
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
           
           IF NOT success  THEN do:
               ASSIGN bc_site = ''
                   bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
               UNDO,RETRY.
           END.
           ELSE DO:
         
      
      DISP bc_site bc_loc WITH FRAME bc.
     
    /* FIND FIRST b_cnt_wkfl WHERE b_cnt_id = 'first' AND b_cnt_status = 'c' NO-LOCK NO-ERROR.
               IF AVAILABLE b_cnt_wkfl THEN DO:*/
               
               FIND FIRST b_cnt_wkfl WHERE b_cnt_status <> 'c' AND  b_cnt_site = bc_site AND b_cnt_loc = bc_loc NO-LOCK NO-ERROR.
             IF NOT AVAILABLE b_cnt_wkfl THEN do:
                /* ENABLE bc_button WITH FRAME bc. */
               
                MESSAGE '没有该库未的盘点清单!' VIEW-AS ALERT-BOX.
                 ASSIGN bc_site = ''
                   bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
                UNDO,RETRY.
            END.
           ELSE DO:
            DISABLE bc_site WITH FRAME bc.
           /*  END.
              ELSE id = 'first'.*/
               DISABLE bc_loc WITH FRAME bc.
               ENABLE bc_id WITH FRAME bc.
               APPLY 'entry':u TO bc_id.
          END.     
       
   
  
     END.
END.

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
         {bcrun.i ""bcmgcheck.p"" "(input ""bdcnt"" ,
        input bc_site,
        input bc_loc, 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input """", 
        input """",
         input  ""cnt"" , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN DO:
        ASSIGN bc_id = ''.
        DISP bc_id WITH FRAME bc.
        UNDO,RETRY.
        END.
      ELSE DO:

              DISABLE bc_id WITH FRAME bc.
             
              
              IF AVAILABLE b_co_mstr THEN DO:
                  
                
                  bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 
                  bc_qty = b_co_qty_cur.
                
                  DISP bc_part bc_lot  /*bc_ref*/ bc_qty WITH FRAME bc.
                  RUN main.
                  
                  END.
                 
                      
      END.
  END.
 /* ON 'choose':U OF bc_button
  DO:
     RUN loss.
  END.*/
/*PROCEDURE loss:
    DEF VAR oktocomt AS LOGICAL.
    
FOR EACH b_cnt_wkfl WHERE b_cnt_id <> 'first' AND b_cnt_site = bc_site AND b_cnt_loc = bc_loc AND b_cnt_status = ''   :
   
    MESSAGE b_cnt_code ' 作盘亏调整吗?'
    VIEW-AS ALERT-BOX QUESTION
            BUTTON YES-NO-CANCEL
            UPDATE oktocomt.
        IF oktocomt THEN DO:
    
    FIND FIRST b_co_mstr WHERE b_co_code = b_cnt_code EXCLUSIVE-LOCK NO-ERROR.  
   ASSIGN b_cnt_status = 'i'.
            
        
     
      
       RELEASE b_cnt_wkfl.
          RELEASE b_co_mstr.
        END.
        IF oktocomt = ? THEN LEAVE.
         END.

    END.*/
PROCEDURE main:
   /*  IF id = ''THEN DO:
   
               FIND FIRST b_cnt_wkfl WHERE b_cnt_id <> 'first'  NO-LOCK NO-ERROR.
               IF AVAILABLE b_cnt_wkfl THEN DO:
           
                   FIND FIRST b_cnt_wkfl WHERE b_cnt_status = '' NO-LOCK NO-ERROR.
          IF AVAILABLE b_cnt_wkfl THEN
               id = b_cnt_id. 
            ELSE DO:
                MESSAGE '未结初盘清单不存在!' VIEW-AS ALERT-BOX.
                LEAVE.
            END.
               END.
               ELSE 
                  id= 'first'.
               
     END.*/
    

    FIND FIRST b_co_mstr WHERE b_co_code = bc_id  AND b_co_cntst = ''  EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b_co_mstr THEN DO:
    FIND FIRST b_cnt_wkfl WHERE  b_cnt_part = b_co_part AND b_cnt_site = bc_site AND b_cnt_loc = bc_loc AND b_cnt_lot = b_co_lot /*AND b_cnt_status = ''*/ EXCLUSIVE-LOCK NO-ERROR.

    
   
    
       IF AVAILABLE b_cnt_wkfl THEN DO:
   
           FIND FIRST b_ld_det WHERE b_ld_site = b_cnt_site AND b_ld_loc = b_cnt_loc AND b_ld_part = b_cnt_part AND b_ld_lot = b_cnt_lot  EXCLUSIVE-LOCK NO-ERROR.

           ASSIGN b_cnt_qty_cnt = IF b_cnt_lot = b_co_code THEN b_co_qty_cur
                                    ELSE (b_cnt_qty_cnt + b_co_qty_cur)
                b_cnt_qty_oh = IF AVAILABLE b_ld_det AND b_cnt_qty_oh <> b_ld_qty_oh THEN b_ld_qty_oh ELSE b_cnt_qty_oh
                b_co_cntst = 'i'
               .
                        
       END.
                  
       ELSE DO:
          /* FIND FIRST b_cnt_wkfl WHERE  b_cnt_part = b_co_part AND b_cnt_site = b_co_site AND b_cnt_loc = b_co_loc AND b_cnt_lot = b_co_lot EXCLUSIVE-LOCK NO-ERROR.
            IF AVAILABLE b_cnt_wkfl THEN MESSAGE b_co_part ' 该条码已作初盘或复盘！' VIEW-AS ALERT-BOX.
            ELSE DO:*/
          IF (b_co_status = 'rct' OR b_co_status = 'ALL') THEN
              FIND FIRST b_ld_det WHERE b_ld_site = bc_site AND b_ld_loc = bc_loc AND b_ld_part = b_co_part AND b_ld_lot = b_co_lot AND b_ld_qty_oh <> 0 EXCLUSIVE-LOCK NO-ERROR.

           CREATE b_cnt_wkfl.
           ASSIGN
            b_cnt_status = IF (b_co_status = 'rct' OR b_co_status = 'ALL') AND AVAILABLE b_ld_det THEN '' ELSE 'f'
            b_cnt_part = b_co_part
            b_cnt_lot = b_co_lot
            b_cnt_site = bc_site
            b_cnt_loc = bc_loc
               b_cnt_qty_oh = IF (b_co_status = 'rct' OR b_co_status = 'ALL') AND AVAILABLE b_ld_det THEN b_ld_qty_oh ELSE 0
               b_cnt_qty_cnt = b_co_qty_cur
            b_cnt_userid = g_user.
         ASSIGN  b_co_cntst = 'i'
               b_co_site = b_cnt_site
                b_co_loc = b_cnt_loc.
           /* END.*/
       END.
           /*CREATE b_cnt_wkfl.
            ASSIGN
            b_cnt_id = id
            b_cnt_code = b_co_code
            b_cnt_part = b_co_part
            b_cnt_lot = b_co_lot
            b_cnt_site = bc_site
            b_cnt_loc = bc_loc
          
           b_cnt_qty_cnt = b_co_qty_cur
            b_cnt_userid = g_user
            b_cnt_status = 'i'.*/
       END.
      
         
       RELEASE b_ld_det.
           
       RELEASE b_co_mstr.    
  RELEASE b_cnt_wkfl.
  ASSIGN 
      bc_id = ''
      bc_part = ''
      bc_lot = ''
      bc_qty = 0.
  DISP bc_id bc_part bc_lot bc_qty WITH FRAME bc.
ENABLE bc_id WITH FRAME bc.
APPLY 'entry':u TO bc_id.
    END.
{bctrail.i}
