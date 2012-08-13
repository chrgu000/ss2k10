{mfdeclre.i}
{bcdeclre.i  }
{bcwin00.i 18.5}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_part1 AS CHAR FORMAT "x(18)" LABEL "��".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "�������".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "��׼����".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "��/���".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "�������".
DEF VAR bc_nbr AS CHAR FORMAT 'x(18)' LABEL '������'.
DEF VAR bc_nbr1 AS CHAR FORMAT 'x(18)' LABEL '��'.
DEF VAR bc_job AS CHAR FORMAT 'x(8)' LABEL 'Ԥ���'.
DEF VAR bc_job1 AS CHAR FORMAT 'x(8)' LABEL '��'.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "�ο���".
DEFINE BUTTON bc_button LABEL "��ӡ" SIZE 8 BY 1.20.
DEFINE BUTTON bc_button2 LABEL "��ӡ" SIZE 8 BY 1.50.
DEFINE BUTTON bc_button3 LABEL "��������" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR LABEL "�ص�".
DEF VAR bc_site1 AS CHAR LABEL "��".
DEF VAR bc_loc AS CHAR LABEL "��λ".
DEF VAR bc_loc1 AS CHAR LABEL "��".
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEF VAR bc_date AS DATE LABEL "����".
DEF VAR bc_date1 AS DATE LABEL "��".
DEF VAR bc_type AS CHAR FORMAT 'x(8)' LABEL '����'.
DEF VAR mdesc AS CHAR FORMAT 'x(10)'.

DEF FRAME bc
   bc_type AT ROW 1.2 COL 4
    mdesc AT ROW 1.2 COL 15 NO-LABEL
    bc_nbr AT ROW 2.4 COL 2.5
    bc_nbr1 AT ROW 3.6 COL 5.5
    bc_job AT ROW 4.8 COL 2.5
    bc_job1 AT ROW 6 COL 5.5
    bc_date AT ROW 7.2 COL 4
    bc_date1 AT ROW 8.4 COL 5.5
    bc_site AT ROW 9.6 COL 4
   bc_site1 AT ROW 10.8 COL 5.5 
   /* bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5*/

   bc_loc AT ROW 12 COL 4
    bc_loc1 AT ROW 13.2 COL 5.5
  
    bc_part AT ROW 14.4 COL 2.5
    bc_part1 AT ROW 15.6 COL 5.5
   bc_button AT ROW 16.8 COL 10
    /*bc_button2 AT ROW 11 COL 16*/
    
    WITH SIZE 30 BY 18.5 TITLE "�ƻ�����ⱸ�ϵ���ӡ"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE /*bc_type*/ bc_nbr bc_nbr1 bc_job bc_job1 bc_date bc_date1 bc_site  bc_site1 bc_loc bc_loc1 bc_part bc_part1 bc_button /*bc_button2*/ WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
CURRENT-WINDOW = 'w'.
assign
    bc_type = 'i'
    mdesc = '�ƻ������'
    bc_date = TODAY
    bc_date1 = TODAY.
DISP bc_type mdesc bc_date bc_date1  WITH FRAME bc.
VIEW c-win.
ON 'LEAVE':u OF bc_type
DO:
    ASSIGN bc_type.
    IF bc_type <> 'i' AND bc_type <> 'r' THEN DO:
        MESSAGE '����ֻ��Ϊi����r!' VIEW-AS ALERT-BOX ERROR.
        bc_type = 'i'.
        DISP bc_type WITH FRAME bc.
        UNDO,RETRY.
    END.
END.
ON enter OF bc_type
DO:
  ASSIGN bc_type.
    IF bc_type <> 'i' AND bc_type <> 'r' THEN DO:
        MESSAGE '����ֻ��Ϊi����r!' VIEW-AS ALERT-BOX ERROR.
        bc_type = 'i'.
        DISP bc_type WITH FRAME bc.
        UNDO,RETRY.
    END.
    ELSE APPLY 'entry':u TO bc_nbr.
END.
ON CURSOR-DOWN OF bc_type
DO:
    ASSIGN bc_type.
    IF bc_type = '' OR bc_type = 'i' THEN do:
       ASSIGN bc_type = 'r'
        mdesc = '�ƻ������'.
            DISP bc_type mdesc WITH FRAME bc.
            LEAVE.
    END.
     IF bc_type = '' OR bc_type = 'r' THEN do:
       ASSIGN bc_type = 'i'
        mdesc = '�ƻ������'.
            DISP bc_type mdesc WITH FRAME bc.
            LEAVE.
    END.
END.
ON CURSOR-UP OF bc_type
DO:
    ASSIGN bc_type.
    IF bc_type = '' OR bc_type = 'i' THEN do:
       ASSIGN bc_type = 'r'
        mdesc = '�ƻ������'.
            DISP bc_type mdesc WITH FRAME bc.
            LEAVE.
    END.
     IF bc_type = '' OR bc_type = 'r' THEN do:
        ASSIGN bc_type = 'i'
        mdesc = '�ƻ������'.
            DISP bc_type mdesc WITH FRAME bc.
            LEAVE.
    END.
END.
ON CURSOR-DOWN OF  bc_nbr
DO:
    ASSIGN bc_nbr.
    FIND FIRST b_cnt_wkfl WHERE substr(b_cnt_site,10,20) > bc_nbr NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
        bc_nbr = substr(b_cnt_site,10,20).
        DISP bc_nbr WITH FRAME bc.
    END.
END.
ON CURSOR-UP OF  bc_nbr
DO:
    ASSIGN bc_nbr.
    FIND LAST b_cnt_wkfl WHERE substr(b_cnt_site,10,20) < bc_nbr NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
        bc_nbr = substr(b_cnt_site,10,20).
        DISP bc_nbr WITH FRAME bc.
    END.
END.
ON VALUE-CHANGED OF bc_nbr
DO:
   ASSIGN bc_nbr NO-ERROR.
END.
ON enter OF bc_nbr
DO:
   ASSIGN bc_nbr NO-ERROR.
   APPLY 'entry':u TO bc_nbr1.
END.
ON CURSOR-DOWN OF  bc_nbr1
DO:
    ASSIGN bc_nbr1.
    FIND FIRST b_cnt_wkfl WHERE substr(b_cnt_site,10,20) > bc_nbr1 NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
        bc_nbr1 = substr(b_cnt_site,10,20).
        DISP bc_nbr1 WITH FRAME bc.
    END.
END.
ON CURSOR-UP OF  bc_nbr1
DO:
    ASSIGN bc_nbr1.
    FIND LAST b_cnt_wkfl WHERE substr(b_cnt_site,10,20) < bc_nbr1 NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
        bc_nbr1 = substr(b_cnt_site,10,20).
        DISP bc_nbr1 WITH FRAME bc.
    END.
END.
ON VALUE-CHANGED OF bc_nbr1
DO:
   ASSIGN bc_nbr1 NO-ERROR.
END.
ON enter OF bc_nbr1
DO:
   ASSIGN bc_nbr1 NO-ERROR.
   APPLY 'entry':u TO bc_job.
END.
ON CURSOR-DOWN OF  bc_job
DO:
    ASSIGN bc_job.
    FIND FIRST b_cnt_wkfl WHERE substr(b_cnt_site,35,10) > bc_job NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
        bc_job = substr(b_cnt_site,35,10).
        DISP bc_job WITH FRAME bc.
    END.
END.
ON CURSOR-UP OF  bc_job
DO:
    ASSIGN bc_job.
    FIND LAST b_cnt_wkfl WHERE substr(b_cnt_site,35,10) < bc_job NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
        bc_job = substr(b_cnt_site,35,10).
        DISP bc_job WITH FRAME bc.
    END.
END.
ON VALUE-CHANGED OF bc_job
DO:
   ASSIGN bc_job NO-ERROR.
END.
ON enter OF bc_job
DO:
   ASSIGN bc_job NO-ERROR.
   APPLY 'entry':u TO bc_job1.
END.
ON VALUE-CHANGED OF bc_job1
DO:
   ASSIGN bc_job1 NO-ERROR.
END.
ON CURSOR-DOWN OF  bc_job1
DO:
    ASSIGN bc_job1.
    FIND FIRST b_cnt_wkfl WHERE substr(b_cnt_site,35,10) > bc_job1 NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
        bc_job1 = substr(b_cnt_site,35,10).
        DISP bc_job1 WITH FRAME bc.
    END.
END.
ON CURSOR-UP OF  bc_job1
DO:
    ASSIGN bc_job1.
    FIND LAST b_cnt_wkfl WHERE  substr(b_cnt_site,35,10) < bc_job1 NO-LOCK NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
        bc_job1 = substr(b_cnt_site,35,10).
        DISP bc_job1 WITH FRAME bc.
    END.
END.
ON enter OF bc_job1
DO:
   ASSIGN bc_job1 NO-ERROR.
   APPLY 'entry':u TO bc_date.
END.
ON VALUE-CHANGED OF bc_date
DO:
   ASSIGN bc_date NO-ERROR.
   END.


   ON enter OF bc_date
   DO:
       ASSIGN bc_date NO-ERROR.
       APPLY 'entry':u TO bc_date1.
   END.
ON VALUE-CHANGED OF bc_date1
DO:
   ASSIGN bc_date1 NO-ERROR.
END.
ON enter OF bc_date1
   DO:
       ASSIGN bc_date1 NO-ERROR.
       APPLY 'entry':u TO bc_site.
   END.
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
ON VALUE-CHANGED OF bc_site
DO:
    bc_site = bc_site:SCREEN-VALUE.
END.
ON enter OF bc_site
DO:
    bc_site = bc_site:SCREEN-VALUE.
    /*{bcrun.i ""bcmgcheck.p"" "(input ""site"",
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
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO:*/
   /*  DISABLE bc_site WITH FRAME bc.*/
        APPLY 'entry':u TO bc_site1.
       /* END.*/
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
ON VALUE-CHANGED OF bc_site1
DO:
    bc_site1 = bc_site1:SCREEN-VALUE.
END.
ON enter OF bc_site1
DO:
    bc_site1 = bc_site1:SCREEN-VALUE.
   /* {bcrun.i ""bcmgcheck.p"" "(input ""site"",
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
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO:*/
 /*    DISABLE bc_site1 WITH FRAME bc.*/
      APPLY 'entry':u TO bc_loc.
        /*END.*/
END.
ON CURSOR-DOWN OF bc_loc
DO:
    
       ASSIGN bc_loc.
       FIND FIRST loc_mstr NO-LOCK WHERE /*loc_site = bc_site AND*/ loc_loc > bc_loc NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc = loc_loc.
           DISPLAY bc_loc WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_loc
DO:
   
       ASSIGN bc_loc.
       FIND LAST loc_mstr NO-LOCK WHERE /*loc_site = bc_site AND*/ loc_loc < bc_loc NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc = loc_loc.
           DISPLAY bc_loc WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_loc
DO:
    bc_loc = bc_loc:SCREEN-VALUE.
END.
ON enter OF bc_loc
DO:
    bc_loc = bc_loc:SCREEN-VALUE.
   /*{bcrun.i ""bcmgcheck.p"" "(input ""loc"",
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
       INPUT """",
       INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO: */
           
               
           /* DISABLE bc_loc WITH FRAME bc.*/
      APPLY 'entry':u TO bc_loc1.
                
       /* END.*/
END.
ON CURSOR-DOWN OF bc_loc1
DO:
    
       ASSIGN bc_loc1.
       FIND FIRST loc_mstr NO-LOCK WHERE /*loc_site = bc_site1 AND*/ loc_loc > bc_loc1 NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc1 = loc_loc.
           DISPLAY bc_loc1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_loc1
DO:
   
       ASSIGN bc_loc1.
       FIND LAST loc_mstr NO-LOCK WHERE /*loc_site = bc_site1 AND*/ loc_loc < bc_loc1 NO-ERROR.
       IF AVAILABLE loc_mstr THEN DO:
           ASSIGN bc_loc1 = loc_loc.
           DISPLAY bc_loc1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_loc1
DO:
    bc_loc1 = bc_loc1:SCREEN-VALUE.
END.
ON enter OF bc_loc1
DO:
    bc_loc1 = bc_loc1:SCREEN-VALUE.
    APPLY 'entry':u TO bc_part.
   /*{bcrun.i ""bcmgcheck.p"" "(input ""loc"",
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
       INPUT """",
       INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO:*/ 
           
               
          /*  DISABLE bc_loc1 WITH FRAME bc.*/
   /* APPLY 'entry':u TO bc_button.*/
     
        /*        
        END.*/
END.
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
     ASSIGN bc_part.
    APPLY 'entry':u TO bc_part1.
END.

    ON VALUE-CHANGED OF bc_part
    DO:
        ASSIGN bc_part.
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
     ASSIGN bc_part1.
    APPLY 'entry':u TO bc_button.
END.

    ON VALUE-CHANGED OF bc_part
    DO:
        ASSIGN bc_part.
    END.
ON 'choose':U OF bc_button
DO:
    RUN main.
END.

/*ON 'choose':U OF bc_button2
DO:
    RUN prt.
END.*/





ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
PROCEDURE prt:
     IF bc_site1 = '' THEN bc_site1 = hi_char.
   IF bc_loc1 = ''  THEN bc_loc1 = hi_char.
   IF bc_part1 = '' THEN bc_part1 = hi_char.
   IF bc_nbr1 = '' THEN bc_nbr1 = hi_char.
   IF bc_job1 = ''  THEN bc_job1 = hi_char.
   IF bc_date = ? THEN bc_date = low_date.
   IF bc_date1 = ? THEN bc_date = hi_date.
   DEF FRAME a
       b_ld_site COLUMN-LABEL "�ص�" AT 8
       b_ld_loc COLUMN-LABEL "��λ"
       b_ld_part  COLUMN-LABEL "�����"
       pt_desc1 COLUMN-LABEL "�������"
       b_ld_lot COLUMN-LABEL "��/���"
       b_ld_qty_oh COLUMN-LABEL "��ʼ�����"
       WITH WIDTH 150 DOWN STREAM-IO.
   FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.

   OUTPUT TO VALUE(b_usr_printer1).
    PUT SKIP(2).
    PUT SPACE(60).
    PUT '����ʼ���嵥' SKIP(1).
FOR EACH b_ld_det WHERE b_ld_site >= bc_site AND b_ld_site <= bc_site1 AND b_ld_loc >= bc_loc AND b_ld_loc <= bc_loc1 NO-LOCK:
     FIND FIRST pt_mstr WHERE pt_part = b_ld_part NO-LOCK NO-ERROR.
    
    DISP b_ld_site b_ld_loc b_ld_part pt_desc1 b_ld_lot b_ld_qty_oh WITH FRAME a.
        
            IF pt_desc2 <> '' THEN DO:
                DOWN 1.
                PUT SPACE(34).
                PUT UNFORMAT pt_desc2.

            END.
    END.
    OUTPUT CLOSE.
    
    END.
PROCEDURE main:
    DEF VAR blocid AS CHAR FORMAT "x(17)".
    DEF VAR mcnt AS INT.
    IF bc_site1 = '' THEN bc_site1 = hi_char.
   IF bc_loc1 = ''  THEN bc_loc1 = hi_char.
   IF bc_part1 = '' THEN bc_part1 = hi_char.
   IF bc_nbr1 = '' THEN bc_nbr1 = hi_char.
   IF bc_job1 = ''  THEN bc_job1 = hi_char.
   IF bc_date = ? THEN bc_date = low_date.
   IF bc_date1 = ? THEN bc_date = hi_date.
   create "Excel.Application" chExcelApplication.
      chExcelApplication:Visible = TRUE.
chWorkbook = chExcelApplication:Workbooks:Add().
     mcnt = 1.
 FOR EACH b_cnt_wkfl WHERE substr(b_cnt_site,1,1)  = bc_type AND SUBSTR(b_cnt_site,12,20) >= bc_nbr AND SUBSTR(b_cnt_site,12,20) <= bc_nbr1 
     AND SUBSTR(b_cnt_site,35,10) >= bc_job AND SUBSTR(b_cnt_site,35,10) <= bc_job1
      AND SUBSTR(b_cnt_site,50,8) >= bc_site AND SUBSTR(b_cnt_site,50,8) <= bc_site1 
     AND date(SUBSTR(b_cnt_site,60,10)) >= bc_date AND date(SUBSTR(b_cnt_site,60,10)) <= bc_date1
     AND b_cnt_loc >= bc_loc AND b_cnt_loc <= bc_loc1 
     AND b_cnt_part >= bc_part AND b_cnt_part <= bc_part1 NO-LOCK BREAK BY SUBSTR(b_cnt_site,2,9) :
  
IF FIRST-OF(SUBSTR(b_cnt_site,2,9)) THEN DO:
rowstart = 1.
     
     chWorkSheet = chExcelApplication:Sheets:Item(mcnt).      
           chExcelApplication:Sheets:Item(mcnt):SELECT().
       chExcelApplication:Sheets:Item(mcnt):NAME = "�ƻ������ⱸ�ϵ�-" + SUBSTR(b_cnt_site,2,9).
        chWorkSheet:Rows(rowstart):RowHeight = 25.
       chWorkSheet:Columns("A:l"):ColumnWidth = 15.
       chWorkSheet:Columns("f:f"):ColumnWidth = 35.
       chWorkSheet:Columns("j:j"):ColumnWidth = 35.
        
         chWorkSheet:Range("A1:l1"):Select().
 chExcelApplication:selection:Font:Name = "����".
     /*chWorkSheet:Range("a1:m1"):Select().*/
    chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
  chexcelApplication:Selection:Font:Size = 12.  
 chExcelApplication:selection:Font:bold = TRUE.
  chWorkSheet:Range("a1:a1"):VALUE = "������".   
  chWorkSheet:Range("b1:b1"):VALUE = "Ԥ���".      
 chWorkSheet:Range("c1:c1"):VALUE = "�ص�".
       chWorkSheet:Range("d1:d1"):VALUE = "��λ".
       chWorkSheet:Range("e1:e1"):VALUE = "�����".
    
      chWorkSheet:Range("f1:f1"):VALUE = "�������".
     chWorkSheet:Range("g1:g1"):VALUE = "������".
     chWorkSheet:Range("h1:h1"):VALUE = "ʵ����".
    chWorkSheet:Range("i1:i1"):VALUE = "Ƿ����".
     
          chWorkSheet:Range("j1:j1"):VALUE = "����".
          chWorkSheet:Range("k1:k1"):VALUE = "����".
          chWorkSheet:Range("l1:l1"):VALUE = "��������".
    mcnt = mcnt + 1.
END.
      FIND FIRST b_co_mstr WHERE b_co_code = substr(b_cnt_lot,1,18) NO-LOCK NO-ERROR.
     FIND FIRST pt_mstr WHERE pt_part = b_cnt_part NO-LOCK NO-ERROR.
     

         

     rowstart = rowstart + 1.
chWorkSheet:Rows(rowstart):RowHeight = 15. 
                   crange = "a" + STRING(rowstart) + ":"  + "l" + STRING(rowstart).
                     chWorkSheet:Range(crange):Select().
      chexcelApplication:Selection:Font:Size = 10.  

     chExcelApplication:selection:HorizontalAlignment = 2.
     chExcelApplication:selection:VerticalAlignment = 2.
     chExcelApplication:selection:Font:Name = "ARIAL". 
     chExcelApplication:selection:numberformat = '@'.
     crange = "a" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE =  SUBSTR(b_cnt_site,12,20).
     crange = "b" + STRING(rowstart).  
      
     chWorkSheet:Range(crange):VALUE = SUBSTR(b_cnt_site,35,10).
     crange = "c" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = SUBSTR(b_cnt_site,50,8).
   crange = "d" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_cnt_loc.
   crange = "e" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_cnt_part.
   crange = "f" + STRING(rowstart).  
     
   chWorkSheet:Range(crange):VALUE = IF AVAILABLE pt_mstr THEN pt_desc1 + pt_desc2 ELSE ''.
   crange = "g" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
   chWorkSheet:Range(crange):VALUE = b_cnt_qty_oh.
   crange = "h" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
   chWorkSheet:Range(crange):VALUE = b_cnt_qty_cnt.
   crange = "i" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
   chWorkSheet:Range(crange):VALUE = b_cnt_qty_oh - b_cnt_qty_cnt.
   crange = "j" + STRING(rowstart). 
chWorkSheet:Range(crange):VALUE =  substr(b_cnt_lot,1,18) /*IF AVAILABLE ad_mstr THEN (IF ad_name <> '' THEN ad_name ELSE ad_sort) ELSE*/ .
  crange = "k" + STRING(rowstart). 
  chWorkSheet:Range(crange):VALUE = SUBSTR(b_cnt_lot,20).
   
   crange = "l" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
  chWorkSheet:Range(crange):VALUE = IF AVAILABLE b_co_mstr THEN b_co_qty_cur ELSE 0.

   
    IF LAST-OF(SUBSTR(b_cnt_site,2,9)) THEN DO:
        chWorkSheet:Range("A1:l" + string(Rowstart)):Select().
      chExcelApplication:selection:Borders(8):Weight = 4. 
     chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
        chExcelApplication:selection:Borders(10):Weight = 4.
        chWorkSheet:Range("A" + string(Rowstart) + ":l" + string(Rowstart)):Select().
        chExcelApplication:selection:Borders(4):Weight = 4.
       chWorkSheet:Range("A1:A" + STRING(rowstart)):Select().
 chExcelApplication:selection:Borders(1):Weight = 4. 
  RELEASE OBJECT chWorksheet.
    END.
    
     
 END.
     
     
   RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.   
     
     
     
     
  
    /*    
     ENABLE bc_site WITH FRAME bc.    */
               END.


{bctrail.i}
