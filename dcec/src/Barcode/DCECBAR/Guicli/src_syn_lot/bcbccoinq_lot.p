{mfdeclre.i}
{bcdeclre.i  }
{bcwin00.i 15.5}
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
 b_co_part LABEL "零件号"
 
 b_co_lot LABEL "批/序号"
b_co_ref LABEL "包装号"
        b_co_qty_cur LABEL "数量" FORMAT "->>,>>>,>>9.9" 
        b_co_status LABEL '状态'
        b_co_btype LABEL '类型'
        b_co_site LABEL "地点"
        b_co_loc LABEL "库位"
        b_co_ord LABEL '订单'
        b_co_line LABEL '行'
        b_co_vend LABEL '供应商'
  
  
WITH NO-ROW-MARKERS SEPARATORS 5 DOWN WIDTH 29  SCROLLABLE TITLE "查询清单".

DEF FRAME bc
   
    bc_site AT ROW 1.2 COL 4
    bc_loc AT ROW 2.4 COL 4
    bc_part AT ROW 3.6 COL 2.5
    bc_lot AT ROW 4.8 COL 4 
    bc_brw AT ROW 6 COL 1
  /* bc_pkqty AT ROW 10 COL 4*/
   
  bc_button AT ROW 13.7 COL 10
   
    
    WITH SIZE 30 BY 15.5 TITLE "条码查询-批号"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CURRENT-WINDOW:NAME = 'w'.
ENABLE   bc_site /*bc_brw*//*bc_part bc_lot bc_brw */ WITH FRAME bc IN WINDOW c-win.

/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/

VIEW c-win.



ON enter OF bc_site
DO:
    DISABLE bc_brw bc_button WITH FRAME bc.
    bc_site = bc_site:SCREEN-VALUE.     
    IF bc_site <> '' THEN DO: 
              
      
          /* APPLY 'entry':u TO bc_site.*/
       IF INDEX(bc_site,'.') <> 0 THEN DO:
      
             msite = bc_site.
         bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
         END. 
        {bccntlock.i "bc_site" "bc_loc"}
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
         
      DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
     
     ENABLE bc_part WITH FRAME bc.
        
          END.     
         END.
         ELSE DO: DISABLE bc_site WITH FRAME bc.
        
     
     
     ENABLE bc_part WITH FRAME bc.
   END.
   END.


  /* ON 'LEAVE':u OF bc_site
   DO:
         bc_site = bc_site:SCREEN-VALUE.    
         IF bc_site <> '' THEN DO: 
                
          
             /* APPLY 'entry':u TO bc_site.*/
            msite = bc_site.
            bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
            bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).

           {bccntlock.i "bc_site" "bc_loc"}
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

       

             END.     
            END.

      END.*/
   ON CURSOR-DOWN OF bc_part
DO:
    
       ASSIGN bc_part.
       FIND FIRST pt_mstr NO-LOCK WHERE pt_part > bc_part NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part = pt_part.
           DISPLAY bc_part WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_part
DO:
   
       ASSIGN bc_part.
       FIND LAST pt_mstr NO-LOCK WHERE pt_part < bc_part NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part = pt_part.
           DISPLAY bc_part WITH FRAME bc.
       END.
   
END.
      ON enter OF bc_part
DO:
    
          bc_part = bc_part:SCREEN-VALUE.


   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
          IF bc_part <> '' THEN DO:
     
         
    
  
    {bcrun.i ""bcmgcheck.p"" "(input ""part"",
        input """",
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
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO: 
            DISABLE bc_part WITH FRAME bc.
            ENABLE bc_lot WITH FRAME bc.
        END.
          END.
          ELSE DO:
              DISABLE bc_part WITH FRAME bc.
            ENABLE bc_lot WITH FRAME bc.
          END.
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.

ON CURSOR-DOWN OF bc_lot
DO:
    
       ASSIGN bc_lot.
       FIND FIRST b_co_mstr USE-INDEX b_co_lot NO-LOCK WHERE /*b_co_part = bc_part AND*/  (IF bc_part <> '' THEN b_co_part = bc_part ELSE YES) AND b_co_lot > bc_lot AND (IF bc_site <> '' THEN b_co_site = bc_site ELSE YES) AND (IF bc_loc <> '' THEN b_co_loc = bc_loc ELSE YES) NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_lot = b_co_lot.
           DISPLAY bc_lot WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_lot
DO:
   
       ASSIGN bc_lot.
       FIND LAST b_co_mstr USE-INDEX b_co_lot NO-LOCK WHERE /*b_co_part = bc_part AND*/  (IF bc_part <> '' THEN b_co_part = bc_part ELSE YES) AND b_co_lot < bc_lot AND (IF bc_site <> '' THEN b_co_site = bc_site ELSE YES) AND (IF bc_loc <> '' THEN b_co_loc = bc_loc ELSE YES) NO-ERROR.
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
     DISABLE bc_lot WITH FRAME bc.
   RUN main.
   ENABLE bc_brw bc_button WITH FRAME bc.
     END.
END.
/*ON VALUE-CHANGED OF bc_lot
DO:
     ASSIGN bc_lot.
   
END.*/
  ON 'choose':U OF bc_button
  DO:
      RUN prt.
  END.
     
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

PROCEDURE prt:
    DEF VAR mdesc AS CHAR FORMAT "x(50)".
FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE (IF bc_part <> '' THEN b_co_part = bc_part ELSE YES) AND b_co_lot = bc_lot AND (IF bc_site <> '' THEN b_co_site = bc_site ELSE YES) AND (IF bc_loc <> '' THEN b_co_loc = bc_loc ELSE YES) AND  b_co_status <> 'ia' NO-LOCK:
mdesc = b_co_desc2 + b_co_desc1.
{bclabel.i ""zpl"" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" "b_co_vend" "mdesc" }
END.
    
    
END.


PROCEDURE main:
    
     
    
    OPEN QUERY bc_qry FOR EACH b_co_mstr USE-INDEX b_co_lot WHERE (IF bc_part <> '' THEN b_co_part = bc_part ELSE YES) AND b_co_lot = bc_lot AND (IF bc_site <> '' THEN b_co_site = bc_site ELSE YES) AND (IF bc_loc <> '' THEN b_co_loc = bc_loc ELSE YES)  NO-LOCK.
     ENABLE bc_site bc_button WITH FRAME bc.
     
 END.
{bctrail.i}
