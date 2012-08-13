{bcdeclre.i  }
    {bcwin03.i}
    {bctitle.i}
{mfdeclre.i}
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "至".

/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_site1 AS CHAR FORMAT "x(8)" LABEL "至".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_loc1 AS CHAR FORMAT "x(8)" LABEL "至".

DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEFINE BUTTON bc_button LABEL "清空" SIZE 8 BY 1.50.
DEF FRAME bc
     bc_site AT ROW 2 COL 4
    bc_site1 AT ROW 3.5 COL 5.5
   
    bc_loc AT ROW 5 COL 4
     bc_loc1 AT ROW 6.5 COL 5.5
   
  /* bc_pkqty AT ROW 10 COL 4*/
  

   bc_button AT ROW 8 COL 10

   
    WITH SIZE 30 BY 10 TITLE "条码盘点状态清空" SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.


ENABLE bc_site bc_site1 bc_loc bc_loc1 bc_button WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc_pick .*/
 
VIEW c-win.
/*ON CURSOR-DOWN OF bc_part
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
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part = bc_part:SCREEN-VALUE.
   /* {bcrun.i ""bcmgcheck.p"" "(input ""part"",
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
        ELSE DO: */
            DISABLE bc_part WITH FRAME bc.
            ENABLE bc_part1 WITH FRAME bc.
       /* END.*/
END.


ON CURSOR-DOWN OF bc_part1
DO:
    
       ASSIGN bc_part1.
       FIND FIRST pt_mstr NO-LOCK WHERE pt_part > bc_part1 NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part1 = pt_part.
           DISPLAY bc_part1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_part1
DO:
   
       ASSIGN bc_part1.
       FIND LAST pt_mstr NO-LOCK WHERE pt_part < bc_part1 NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part1 = pt_part.
           DISPLAY bc_part1 WITH FRAME bc.
       END.
   
END.

ON enter OF bc_part1
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part1 = bc_part1:SCREEN-VALUE.
   /* {bcrun.i ""bcmgcheck.p"" "(input ""part"",
        input """",
        input """", 
        input bc_part1, 
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
        ELSE DO: */
            DISABLE bc_part1 WITH FRAME bc.
           RUN main.
        /*END.*/
END.*/

ON CURSOR-DOWN OF bc_site
DO:
    
       ASSIGN bc_site.
       FIND FIRST si_mstr NO-LOCK WHERE si_site > bc_site NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site = si_site.
           DISPLAY bc_site WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_site
DO:
   
       ASSIGN bc_site.
       FIND LAST si_mstr NO-LOCK WHERE si_site < bc_site NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site = si_site.
           DISPLAY bc_site WITH FRAME bc.
       END.
   
END.
ON enter OF  bc_site
DO:
    ASSIGN bc_site.
     /*{bcrun.i ""bcmgcheck.p"" "(input ""site"" ,
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
           
           IF NOT success  THEN UNDO,RETRY.
           ELSE DO:*/
            /*   DISABLE bc_site WITH FRAME bc.
               ENABLE bc_site1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_site1.

          /* END.*/
END.
ON VALUE-CHANGED OF  bc_site
DO:
    ASSIGN bc_site.
END.
ON CURSOR-DOWN OF bc_site1
DO:
    
       ASSIGN bc_site1.
       FIND FIRST si_mstr NO-LOCK WHERE si_site > bc_site1 NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site1 = si_site.
           DISPLAY bc_site1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_site1
DO:
   
       ASSIGN bc_site1.
       FIND LAST si_mstr NO-LOCK WHERE si_site < bc_site1 NO-ERROR.
       IF AVAILABLE si_mstr THEN DO:
           ASSIGN bc_site1 = si_site.
           DISPLAY bc_site1 WITH FRAME bc.
       END.
   
END.
ON enter OF  bc_site1
DO:
    ASSIGN bc_site1.
     /*{bcrun.i ""bcmgcheck.p"" "(input ""site"" ,
        input bc_site1,
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
           
           IF NOT success  THEN UNDO,RETRY.
           ELSE DO:*/
               APPLY 'entry':u TO bc_loc.

          /* END.*/
END.

ON VALUE-CHANGED OF  bc_site1
DO:
    ASSIGN bc_site1.
END.
ON CURSOR-DOWN OF bc_loc
DO:
    
       ASSIGN bc_loc.
       FIND FIRST loc_mstr NO-LOCK WHERE loc_site = bc_site AND loc_loc > bc_loc NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc = loc_loc.
           DISPLAY bc_loc WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_loc
DO:
   
       ASSIGN bc_loc.
       FIND LAST loc_mstr NO-LOCK WHERE loc_site = bc_site AND loc_loc < bc_loc NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc = loc_loc.
           DISPLAY bc_loc WITH FRAME bc.
       END.
   
END.
ON enter OF  bc_loc
DO:
    ASSIGN bc_loc.
     /*{bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
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
           
           IF NOT success  THEN UNDO,RETRY.
           ELSE DO:*/
              APPLY 'entry':u TO bc_loc1.

           /*END.*/
END.
ON VALUE-CHANGED OF  bc_loc
DO:
    ASSIGN bc_loc.
END.
ON CURSOR-DOWN OF bc_loc1
DO:
    
       ASSIGN bc_loc1.
       FIND FIRST loc_mstr NO-LOCK WHERE loc_site = bc_site1 AND loc_loc > bc_loc1 NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc1 = loc_loc.
           DISPLAY bc_loc1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_loc1
DO:
   
       ASSIGN bc_loc1.
       FIND LAST loc_mstr NO-LOCK WHERE loc_site = bc_site1 AND loc_loc < bc_loc1 NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc1 = loc_loc.
           DISPLAY bc_loc1 WITH FRAME bc.
       END.
   
END.
ON enter OF  bc_loc1
DO:
    ASSIGN bc_loc1.
    /* {bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
        input bc_site1,
        input bc_loc1, 
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
           
           IF NOT success  THEN UNDO,RETRY.
           ELSE DO:*/
              APPLY 'entry':u TO bc_button.

          /* END.*/
END.
ON VALUE-CHANGED OF  bc_loc
DO:
    ASSIGN bc_loc.
END.
ON 'choose':U OF bc_button
DO:
    RUN main.
END.
PROCEDURE main:
    DEF VAR oktocmt AS LOGICAL.
   /* DEF VAR ori_qty_oh_tot LIKE b_cnt_qty_oh.
    DEF VAR cnt_qty_tot LIKE b_cnt_qty_cnt.
    DEF VAR diff_qty LIKE cnt_qty_tot.
    DEF FRAME b_cnt_rpt 
       b_cnt_site COLUMN-LABEL '地点' AT 8
        b_cnt_loc COLUMN-LABEL '库位'
        b_cnt_part COLUMN-LABEL '零件号' 
        pt_desc1 COLUMN-LABEL '零件描述'
        b_cnt_lot COLUMN-LABEL '批/序号'
        ori_qty_oh_tot COLUMN-LABEL '原库存数量'
        cnt_qty_tot COLUMN-LABEL '初盘数量'
        diff_qty COLUMN-LABEL '初盘差异'
        WITH WIDTH 150 DOWN STREAM-IO .*/
    DEF VAR isst AS LOGICAL INITIAL YES.
    IF bc_part1 = '' THEN bc_part1 = hi_char.
    IF bc_site1 = ''  THEN bc_site1 = hi_char.
    IF bc_loc1 = '' THEN bc_loc1 = hi_char.
    MESSAGE '确定清除码？' VIEW-AS ALERT-BOX
            QUESTION BUTTON YES-NO 
            UPDATE oktocmt .
   IF oktocmt THEN DO:
   /* OUTPUT TO notepad.txt.
    PUT SKIP(2).
    PUT SPACE(60).
    PUT '盘点差异报表(I)' SKIP(1).*/

    FOR EACH b_co_mstr USE-INDEX b_co_st_loc EXCLUSIVE-LOCK WHERE b_co_site >= bc_site AND b_co_site <= bc_site1 AND b_co_loc >= bc_loc AND b_co_loc <= bc_loc1 AND b_co_status <> 'ia' AND b_co_cntst <> '' :
    ASSIGN
        b_co_cntst = ''.
    END.

   MESSAGE '条码盘点状态已置空！' VIEW-AS ALERT-BOX.   
   END.

    END.
{bctrail.i}
