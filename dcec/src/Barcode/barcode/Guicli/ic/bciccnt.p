{bcdeclre.i }
    {bcwin02.i}
    {bctitle.i}
   
DEF VAR bc_id AS CHAR FORMAT "x(20)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty_oh AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "系统数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_qty_cnt AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "盘点数量".

DEF VAR bc_lot AS CHAR FORMAT "x(8)" LABEL "批/序号".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".
DEFINE BUTTON bc_button1 LABEL "盘点初始化" SIZE 10 BY 1.50.
DEFINE BUTTON bc_button2 LABEL "盘点报表" SIZE 8 BY 1.50.
DEF BUTTON bc_button3 LABEL "盘亏调整" SIZE 8 BY 1.5.
DEF VAR qty_oh LIKE b_ld_qty_oh.
DEF VAR b_site LIKE b_ld_site.
DEF VAR b_loc LIKE b_ld_loc.
DEF VAR oktocomt AS LOGICAL.
DEF FRAME bc
    bc_id AT ROW 1.5 COL 4
    bc_part AT ROW 2.7 COL 2.5
   
   
   bc_lot AT ROW 3.9 COL 1.6
    bc_ref AT ROW 5.1 COL 2.5
    bc_qty_oh AT ROW 6.3 COL 1
  /* bc_pkqty AT ROW 10 COL 4*/
   bc_qty_cnt AT ROW 7.5 COL 1
    bc_site AT ROW 8.7 COL 4
    bc_loc AT ROW 9.9 COL 4

   bc_button1 AT ROW 12 COL 2
 bc_button2 AT ROW 12 COL 12
    bc_button3 AT ROW 12 COL 20

    WITH SIZE 30 BY 14 TITLE "盘点扫描"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
DEF FRAME b_cnt_p

    b_cnt_code COLON 2 COLUMN-LABEL "条码"
    b_co_part  COLUMN-LABEL "条码"
    b_co_lot COLUMN-LABEL "批/序号"
    b_co_ser COLUMN-LABEL "序号"
    b_co_ref COLUMN-LABEL "参考号"
    b_cnt_qty_cnt COLUMN-LABEL "盘点数量"
    b_cnt_qty_oh COLUMN-LABEL "系统数量"
    b_cnt_site COLUMN-LABEL "地点"
    b_cnt_loc COLUMN-LABEL "库位"
    WITH  WIDTH 150  DOWN  STREAM-IO TITLE "盘盈" .

DEF FRAME b_cnt_l

    b_cnt_code COLON 2 COLUMN-LABEL "条码"
    b_co_part  COLUMN-LABEL "条码"
    b_co_lot COLUMN-LABEL "批/序号"
    b_co_ser COLUMN-LABEL "序号"
    b_co_ref COLUMN-LABEL "参考号"
    b_cnt_qty_cnt COLUMN-LABEL "盘点数量"
    b_cnt_qty_oh COLUMN-LABEL "系统数量"
    b_cnt_site COLUMN-LABEL "地点"
    b_cnt_loc COLUMN-LABEL "库位"
    WITH  WIDTH 150   DOWN   STREAM-IO TITLE "盘亏" .

/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
/* DISP  
   bc_part
    
   bc_lot 
    bc_qty 
   
  
    WITH FRAME bc .*/
VIEW c-win.
IF NOT CAN-FIND( FIRST b_cnt_wkfl NO-LOCK)  THEN
     ENABLE bc_button1 WITH FRAME bc.
    ELSE

        ENABLE bc_id bc_button2 bc_button3 WITH FRAME bc IN WINDOW c-win.
ON 'choose':u OF bc_button1
DO:
    MESSAGE "是否初始化？" SKIP(1)
        "继续?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.
 IF oktocomt THEN DO:
 
FOR EACH b_co_mstr NO-LOCK:
     FIND FIRST b_ld_det WHERE b_ld_code = b_co_code AND b_ld_qty_oh <> 0  NO-LOCK NO-ERROR.
    IF AVAILABLE b_ld_det THEN 
        ASSIGN qty_oh = b_ld_qty_oh
               b_site = b_ld_site
               b_loc = b_ld_loc.
        ELSE DO:
              qty_oh = 0.
            ASSIGN b_site = ''
              b_loc = ''.
                                  
              
              
       END.
    FIND b_cnt_wkfl WHERE b_cnt_code = b_co_code EXCLUSIVE-LOCK no-error.
    IF AVAILABLE b_cnt_wkfl THEN DO:
          b_cnt_site = b_site.
    b_cnt_loc = b_loc.
    b_cnt_qty_oh = qty_oh.
        b_cnt_scan = NO.
        END.
        ELSE DO: 
           
            CREATE b_cnt_wkfl.
    b_cnt_code = b_co_code.
    b_cnt_site = b_site.
    b_cnt_loc = b_loc.
    b_cnt_qty_oh = qty_oh.
   
    b_cnt_scan = NO.
        
    END.
END.
ENABLE bc_id bc_button2 bc_button3 WITH FRAME bc.
MESSAGE '初始化完毕！' VIEW-AS ALERT-BOX INFORMATION.
 END.
END.

ON 'CHOOSE':u OF bc_button2
DO:
RUN iccntrpt.

END.


ON 'CHOOSE':u OF bc_button3
DO:
RUN iccntloss.
END.

ON enter OF bc_id
DO:
        bc_id = bc_id:SCREEN-VALUE.
         {bcrun.i ""bcmgcheck.p"" "(input ""bd"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input """", 
        input """",
         input  """" , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
      ELSE DO:
     
        FIND FIRST b_cnt_wkfl WHERE b_cnt_code = bc_id AND b_cnt_scan = YES NO-LOCK NO-ERROR.
        IF AVAILABLE b_cnt_wkfl THEN do:
          MESSAGE '该条码已盘过！' VIEW-AS ALERT-BOX ERROR.
            UNDO,RETRY.
            
            END.
          ELSE DO:
       
          
              DISABLE bc_id WITH FRAME bc.
              FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
              FIND FIRST b_loc_mstr WHERE b_loc_code = b_co_code NO-LOCK NO-ERROR.
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_ref = b_co_ref.
                  bc_qty_cnt = b_co_qty_cur.
              END.
                  
                     
                  FIND FIRST b_ld_det WHERE b_ld_code = bc_id AND b_ld_qty_oh <> 0 NO-LOCK NO-ERROR.
                    IF AVAILABLE b_ld_det THEN
                        ASSIGN bc_site = b_ld_site
                             bc_loc = b_ld_loc
                        bc_qty_oh = b_ld_qty_oh.
                    ELSE 
                        ASSIGN bc_site = ''
                                   bc_loc = ''
                        
                        bc_qty_oh = 0.
                  DISP bc_part bc_lot bc_ref bc_qty_cnt bc_loc bc_site bc_qty_oh WITH FRAME bc. 
                   /*ENABLE bc_qty_cnt WITH FRAME bc.*/
                 
                  IF bc_site = '' OR bc_loc = '' THEN  DO:
                      ENABLE bc_site  WITH FRAME bc.
                      APPLY 'ENTRY':U TO BC_SITE.
                  END.
                  ELSE RUN iccnt.

                      
                      
                      
                      
                      END.
                  
                  
      END.
     
                  
               

         
    END.
    ON enter of bc_qty_cnt 
    DO:
       IF bc_qty_cnt <> DECIMAL(bc_qty_cnt:SCREEN-VALUE) THEN
       
            bc_qty_cnt = DECIMAL(bc_qty_cnt:SCREEN-VALUE).
           
      
          
    IF bc_site = '' OR bc_loc = '' THEN   DO:
      ENABLE  bc_site  WITH FRAME bc.
        APPLY 'ENTRY':U TO BC_SITE.
    END.
                       ELSE RUN iccnt.
       
            
    END.

 ON enter of bc_site
    DO:
         bc_site = bc_site:SCREEN-VALUE.
        
       {bcrun.i ""bcmgcheck.p"" "(input ""bd_loc"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_site, 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
        IF NOT success THEN UNDO,RETRY.
        
        ELSE DO:
              FIND b_loc_mstr WHERE b_loc_code = bc_site NO-LOCK NO-ERROR.
              bc_site = b_loc_site.
              bc_loc = b_loc_loc.
           
       DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
       RUN iccnt.
            
    END.
 END.
/*ON enter of bc_loc
    DO:
        bc_loc = bc_loc:SCREEN-VALUE.
        
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
        output success)"}
        IF NOT success THEN UNDO,RETRY.
    ELSE DO:
       DISABLE bc_loc WITH FRAME bc.
       RUN iccnt.
        
        
            
    END.
END.*/
     ON WINDOW-CLOSE OF c-win /* <insert window title> */
   DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO c-win.
  RETURN NO-APPLY.

        END.
PROCEDURE iccnt:
  FIND b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
           b_co_qty_cur = bc_qty_cnt.
          b_co_status = 'recevied'.
 FIND FIRST b_cnt_wkfl WHERE b_cnt_code = bc_id AND b_cnt_scan = NO EXCLUSIVE-LOCK NO-ERROR.

                       IF AVAILABLE b_cnt_wkfl THEN do:
                     b_cnt_qty_cnt = bc_qty_cnt.
                     
                        b_cnt_scan = YES.

                   END.
                   ELSE DO:

                       CREATE b_cnt_wkfl.
                       b_cnt_code = bc_id.
                         b_cnt_qty_cnt = bc_qty_cnt.
                      b_cnt_qty_oh = bc_qty_oh.
                        b_cnt_scan = YES.
                        b_cnt_site = bc_site.
                        b_cnt_loc = bc_loc.
                       END.


                       IF b_cnt_qty_cnt > b_cnt_qty_oh THEN DO:
                          
                          
                               FIND FIRST b_ld_det WHERE b_ld_code = bc_id AND b_ld_site = bc_site AND b_ld_loc = bc_loc  EXCLUSIVE-LOCK NO-ERROR.
                               IF AVAILABLE b_ld_det THEN DO:
                              
                               b_ld_qty_oh = b_cnt_qty_cnt.
                                 
                               END.

                           ELSE DO:
                             
                              
                               CREATE b_ld_det .
                              
         b_ld_code = b_co_code.
         b_ld_loc = bc_loc.
         b_ld_site = bc_site.
         b_ld_part = b_co_part.
         b_ld_lot = b_co_lot.
         /*b_ld_ser = b_co_ser.*/
       /*  b_ld_ref = b_co_ref.*/
       
         b_ld_qty_oh = b_cnt_qty_cnt.


                           END.
                           b_cnt_site = bc_site.
                           b_cnt_loc = bc_loc.
                           b_cnt_qty_oh = b_ld_qty_oh.
                           b_cnt_status = 'p'.
                           
                           
                           END.
                           
                          
            
  {bctrcr.i
         &ord=""""
         &mline=?
         &b_code=b_co_code
         &b_part=b_co_part
         &b_lot=b_co_lot
         &b_ser=b_co_ser
         &b_qty_ord=?
         &b_qty_loc="b_cnt_qty_cnt - b_cnt_qty_oh"
         &b_qty_chg="b_cnt_qty_cnt - b_cnt_qty_oh"
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"bc_iccnt"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user}
                           
                 bc_exec = 'iccnt'.
          {bcusrhist.i}
               bc_exec = 'bciccnt.p'. 
              {bcrelease.i}
              ENABLE bc_id WITH FRAME bc.
                       END.

    PROCEDURE iccntrpt:
         
        OUTPUT TO notepad.txt.
        FOR EACH b_cnt_wkfl WHERE b_cnt_scan = YES AND b_cnt_status = 'p' NO-LOCK:
           FIND b_co_mstr WHERE b_co_code = b_cnt_code NO-LOCK NO-ERROR.
           DISP b_cnt_code b_co_part b_co_lot b_co_ser b_co_ref b_cnt_qty_cnt b_cnt_qty_oh b_cnt_site b_cnt_loc WITH FRAME b_cnt_p.

       END.
      FOR EACH b_cnt_wkfl WHERE b_cnt_scan = NO AND b_cnt_status = 'l' NO-LOCK:
           FIND b_co_mstr WHERE b_co_code = b_cnt_code NO-LOCK NO-ERROR.
           DISP b_cnt_code b_co_part b_co_lot b_co_ser b_co_ref b_cnt_qty_cnt b_cnt_qty_oh b_cnt_site b_cnt_loc WITH FRAME b_cnt_l.

      END.
       OUTPUT CLOSE.
        DOS SILENT VALUE('notepad notepad.txt').     
          bc_exec = 'iccntrpt'.
          {bcusrhist.i}
              bc_exec = 'bciccnt.p'.
        END.



PROCEDURE iccntloss:
    DEF VAR oktocomt AS LOGICAL.
FOR EACH b_cnt_wkfl WHERE b_cnt_scan = NO AND b_cnt_qty_cnt = 0 AND b_cnt_qty_oh <> 0 NO-LOCK:
           FIND b_co_mstr WHERE b_co_code = b_cnt_code EXCLUSIVE-LOCK NO-ERROR.
           MESSAGE b_cnt_code + ' 该条码作盘亏调整吗？' VIEW-AS ALERT-BOX 
               QUESTION
        BUTTON YES-NO-CANCEL
        UPDATE oktocomt.
 IF oktocomt THEN DO:
    FIND FIRST b_ld_det WHERE b_ld_code = b_cnt_code AND b_ld_site = b_cnt_site AND b_ld_loc = b_cnt_loc AND b_ld_qty_oh <> 0 EXCLUSIVE-LOCK NO-ERROR.
    b_ld_qty_oh = 0.
    b_cnt_status = 'l'.
{bctrcr.i
         &ord=""""
         &mline=?
         &b_code=b_co_code
         &b_part=b_co_part
         &b_lot=b_co_lot
         &b_ser=b_co_ser
         &b_qty_ord=?
         &b_qty_loc="(b_cnt_qty_oh - b_cnt_qty_cnt) * -1"
         &b_qty_chg="(b_cnt_qty_oh - b_cnt_qty_cnt) * -1"
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"bc_iccnt"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user}
 bc_exec = 'iccntloss'.
          {bcusrhist.i}
 bc_exec = 'bciccnt.p'.


 END.
  {bcrelease.i}
          IF OKTOCOMT = ? THEN LEAVE.
          
          END.


 END.

 {bctrail.i}
