{bcdeclre.i  }
    {bcwin02.i}
    {bctitle.i}
  
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/

DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".

DEFINE BUTTON bc_button LABEL "盘亏调整" SIZE 8 BY 1.50.
DEF VAR msite AS CHAR.
DEF VAR bc_tag AS CHAR FORMAT "x(8)" LABEL '标签'.
DEF VAR mtype AS CHAR.
DEF VAR mqty AS DECIMAL.

DEF VAR mloc AS CHAR.
DEF VAR mpart AS CHAR.
DEF VAR mlot AS CHAR.
DEF FRAME bc
    
    bc_site AT ROW 1.5 COL 4
    bc_loc AT ROW 3 COL 4
    bc_tag AT ROW 4.5 COL 4
    bc_id AT ROW 6 COL 4
    bc_part AT ROW 7.5 COL 2.5
   
   /* bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5*/
   bc_lot AT ROW 9 COL 1.6
    bc_qty AT ROW 10.5 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
   

   
  
    WITH SIZE 30 BY 12 TITLE "静态初盘扫描"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
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
               
              
            DISABLE bc_site WITH FRAME bc.
           /*  END.
              ELSE id = 'first'.*/
               DISABLE bc_loc WITH FRAME bc.
               ENABLE bc_tag WITH FRAME bc.
              
       
   
  
     END.
END.

ON enter OF bc_tag
DO:
   ASSIGN bc_tag.
   FIND FIRST tag_mstr WHERE string(tag_nbr) = bc_tag AND NOT tag_post AND (IF tag_site <> '' OR tag_loc <> '' THEN tag_site = bc_site AND tag_loc = bc_loc ELSE YES) EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE tag_mstr THEN DO:
       MESSAGE '无效标签，或标签库位不匹配，或已更新！' VIEW-AS ALERT-BOX ERROR.
       UNDO,RETRY.
   END.
   ELSE DO:
       mqty = tag_cnt_qty.
       mpart = tag_part.
       msite = tag_site.
       mloc = tag_loc.
       mlot = tag_serial.
       mtype = tag_type.
      
       DISABLE bc_tag WITH FRAME bc.
       ENABLE bc_id WITH FRAME bc.
       APPLY 'entry':u TO bc_id.
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
         input  ""cnti_p"" , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN DO:
        ASSIGN bc_id = ''.
        DISP bc_id WITH FRAME bc.
        UNDO,RETRY.
        END.
      ELSE DO:
            IF (mpart <> ''  OR mlot <> '') 
                AND (mpart <> b_co_part  OR mlot <> b_co_lot) THEN DO:
                 MESSAGE '该盘点标签与条码信息不匹配！' VIEW-AS ALERT-BOX ERROR.
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
    
    DEF VAR mtime AS INT.
    {bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
        input bc_site,
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
         input """",
        output success)"}   
     IF NOT success THEN LEAVE.
    FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
   
 OUTPUT TO VALUE(g_sess). 

           put  "@@BATCHLOAD pitcmt1.P" skip.
           PUT UNFORMAT '"' bc_tag '"' SKIP .
            IF mtype = 'B' THEN DO: 
            
           PUT UNFORMAT '"' bc_site '"' SKIP.
             PUT UNFORMAT '"' bc_loc '"' SKIP.
            PUT UNFORMAT '"' b_co_part '" "' b_co_lot '"'  SKIP.
            END.
            PUT UNFORMAT STRING(IF msite = bc_site AND mloc = bc_loc AND mpart = b_co_part AND mlot = b_co_lot THEN (IF substr(b_co_cntst,1,2) <> 'ip' and substr(b_co_cntst,1,2) <> 'rp' THEN (mqty + b_co_qty_cur) ELSE mqty) ELSE b_co_qty_cur)   SKIP.
            PUT UNFORMAT '- "' g_user  '" ' TODAY   SKIP.
            PUT '.' SKIP.    
               PUT      "@@END" SKIP.
        
          OUTPUT CLOSE.
         
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
              OS-DELETE VALUE('out.txt').
             FIND FIRST tag_mstr WHERE string(tag_nbr) = bc_tag NO-LOCK NO-ERROR.     
             IF bc_site = tag_site AND bc_loc = tag_loc AND b_co_part = tag_part AND b_co_lot = tag_serial  THEN DO:

                  IF msite = tag_site AND mloc = tag_loc AND mpart = tag_part AND mlot = tag_serial  THEN DO:
                      IF tag_cnt_qty <> mqty + (IF  substr(b_co_cntst,1,2) <> 'ip' and substr(b_co_cntst,1,2) <> 'rp' THEN b_co_qty_cur ELSE 0) THEN   DO:  
                          MESSAGE  bc_site ' ' bc_loc ' ' b_co_part  b_co_lot ' 更新QAD失败！'  VIEW-AS ALERT-BOX ERROR.
                        LEAVE.
                      END.
                  END.
                  ELSE 
                      IF tag_cnt_qty <> b_co_qty_cur THEN  DO:  
                           MESSAGE  bc_site ' ' bc_loc ' ' b_co_part  b_co_lot ' 更新QAD失败！'  VIEW-AS ALERT-BOX ERROR.
                      
               LEAVE.
                  END.
                  END.
                  ELSE  MESSAGE  bc_site ' ' bc_loc ' ' b_co_part  b_co_lot ' 更新QAD失败！'  VIEW-AS ALERT-BOX ERROR.
      IF substr(b_co_cntst,1,2) <> 'ip' and SUBSTR(b_co_cntst,1,2) <> 'rp' THEN  b_co_cntst = 'ip' + STRING(bc_tag).
       IF b_co_status = 'ac' OR b_co_status = 'iss' OR b_co_status = 'issln' THEN 
               ASSIGN  b_co_site = bc_site
                       b_co_loc = bc_loc.   
      /* RELEASE ld_det.*/
           
       RELEASE b_co_mstr.    
    RELEASE tag_mstr.
  ASSIGN 
      bc_id = ''
      bc_tag = ''
      /*bc_part = ''
      bc_lot = ''
      bc_qty = 0*/.
  DISP bc_id bc_part bc_lot bc_qty bc_tag WITH FRAME bc.
ENABLE bc_tag WITH FRAME bc.
APPLY 'entry':u TO bc_tag.
    END.
{bctrail.i}
