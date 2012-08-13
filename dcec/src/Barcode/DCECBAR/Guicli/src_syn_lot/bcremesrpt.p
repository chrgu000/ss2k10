{mfdeclre.i}
{bcdeclre.i  }
{bcwin00.i 19.7}
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
DEF VAR bc_staff AS CHAR FORMAT "x(8)" LABEL "���Ա".
DEF VAR bc_staff1 AS CHAR FORMAT "x(8)" LABEL "��".
DEF VAR bc_vend AS CHAR FORMAT "x(8)" LABEL '��Ӧ��'.
DEF VAR bc_vend1 AS CHAR FORMAT "x(8)" LABEL '��'.
DEF VAR bc_nbr AS CHAR FORMAT 'x(20)' LABEL '�Ʋֵ�'.
DEF VAR bc_nbr1 AS CHAR FORMAT 'x(20)' LABEL '��'.
DEF FRAME bc
   bc_staff AT ROW 1.2 COL 2.5
    bc_staff1 AT ROW 2.4 COL 5.5
    bc_nbr AT ROW 3.6 COL 2.5
    bc_nbr1 AT ROW 4.8 COL 5.5
    bc_date AT ROW 6 COL 4
    bc_date1 AT ROW 7.2 COL 5.5
    bc_site AT ROW 8.4 COL 4
   bc_site1 AT ROW 9.6 COL 5.5 
   /* bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5*/

   bc_loc AT ROW 10.8 COL 4
    bc_loc1 AT ROW 12 COL 5.5
  
    bc_part AT ROW 13.2 COL 2.5
    bc_part1 AT ROW 14.4 COL 5.5
    bc_vend AT ROW 15.6 COL 2.5
    bc_vend1 AT ROW 16.8 COL 5.5
   bc_button AT ROW 18 COL 10
    /*bc_button2 AT ROW 11 COL 16*/
    
    WITH SIZE 30 BY 19.7 TITLE "MES���ϵ����ܱ���"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_staff bc_staff1 bc_nbr bc_nbr1 bc_date bc_date1 bc_site  bc_site1 bc_loc bc_loc1 bc_part bc_part1 bc_vend bc_vend1 bc_button /*bc_button2*/ WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 bc_date = TODAY.
 bc_date1 = TODAY.
 DISP bc_date bc_date1 WITH FRAME bc.
VIEW c-win.
ON CURSOR-DOWN OF bc_staff
DO:
    ASSIGN bc_staff.
    FIND FIRST b_mes_wkfl WHERE b_mes_staff > bc_staff NO-LOCK NO-ERROR.
    IF AVAILABLE b_mes_wkfl THEN DO:
        bc_staff = b_mes_staff.
        DISP bc_staff WITH FRAME bc.
    END.
END.
ON CURSOR-UP OF bc_staff
DO:
    ASSIGN bc_staff.
    FIND LAST b_mes_wkfl WHERE b_mes_staff < bc_staff NO-LOCK NO-ERROR.
    IF AVAILABLE b_mes_wkfl THEN DO:
        bc_staff = b_mes_staff.
        DISP bc_staff WITH FRAME bc.
    END.
END.
ON CURSOR-DOWN OF bc_staff1
DO:
    ASSIGN bc_staff1.
    FIND FIRST b_mes_wkfl WHERE b_mes_staff > bc_staff1 NO-LOCK NO-ERROR.
    IF AVAILABLE b_mes_wkfl THEN DO:
        bc_staff1 = b_mes_staff.
        DISP bc_staff1 WITH FRAME bc.
    END.
END.
ON CURSOR-UP OF bc_staff1
DO:
    ASSIGN bc_staff1.
    FIND LAST b_mes_wkfl WHERE b_mes_staff < bc_staff1 NO-LOCK NO-ERROR.
    IF AVAILABLE b_mes_wkfl THEN DO:
        bc_staff1 = b_mes_staff.
        DISP bc_staff1 WITH FRAME bc.
    END.
END.
ON CURSOR-DOWN OF bc_nbr
DO:
    ASSIGN bc_nbr.
    FIND FIRST b_mes_wkfl WHERE b_mes_id > bc_nbr NO-LOCK NO-ERROR.
    IF AVAILABLE b_mes_wkfl THEN DO:
        bc_nbr = b_mes_id.
        DISP bc_nbr WITH FRAME bc.
    END.
END.
ON CURSOR-DOWN OF bc_nbr1
DO:
    ASSIGN bc_nbr1.
    FIND FIRST b_mes_wkfl WHERE b_mes_id > bc_nbr1 NO-LOCK NO-ERROR.
    IF AVAILABLE b_mes_wkfl THEN DO:
        bc_nbr1 = b_mes_id.
        DISP bc_nbr1 WITH FRAME bc.
    END.
END.
ON VALUE-CHANGED OF bc_staff
DO:
   ASSIGN bc_staff NO-ERROR.
END.
ON enter OF bc_staff
DO:
   ASSIGN bc_staff NO-ERROR.
   APPLY 'entry':u TO bc_staff1.
END.
ON VALUE-CHANGED OF bc_staff1
DO:
   ASSIGN bc_staff1 NO-ERROR.
END.
ON enter OF bc_staff1
DO:
   ASSIGN bc_staff1 NO-ERROR.
   APPLY 'entry':u TO bc_nbr.
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
ON VALUE-CHANGED OF bc_nbr1
DO:
   ASSIGN bc_nbr1 NO-ERROR.
END.
ON enter OF bc_nbr1
DO:
   ASSIGN bc_nbr1 NO-ERROR.
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
    APPLY 'entry':u TO bc_vend.
END.

 
    ON CURSOR-DOWN OF bc_vend
DO:
    ASSIGN bc_vend.
    FIND FIRST b_mes_wkfl WHERE b_mes_vend > bc_vend NO-LOCK NO-ERROR.
    IF AVAILABLE b_mes_wkfl THEN DO:
        bc_vend = b_mes_vend.
        DISP bc_vend WITH FRAME bc.
    END.
END.
 ON CURSOR-UP OF bc_vend
DO:
    ASSIGN bc_vend.
    FIND LAST b_mes_wkfl WHERE b_mes_vend < bc_vend NO-LOCK NO-ERROR.
    IF AVAILABLE b_mes_wkfl THEN DO:
        bc_vend = b_mes_vend.
        DISP bc_vend WITH FRAME bc.
    END.
END.
ON VALUE-CHANGED OF bc_vend
    DO:
        ASSIGN bc_vend.
    END.
    ON enter OF bc_vend
DO:
     ASSIGN bc_vend.
    APPLY 'entry':u TO bc_button.
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
    DEF VAR mqty_req AS DECIMAL.
    DEF VAR mqty_iss AS DECIMAL.
    IF bc_site1 = '' THEN bc_site1 = hi_char.
   IF bc_loc1 = ''  THEN bc_loc1 = hi_char.
   IF bc_part1 = '' THEN bc_part1 = hi_char.
   IF bc_staff1 = '' THEN bc_staff1 = hi_char.
   IF bc_nbr1 =  '' THEN bc_nbr1 = hi_char.
   IF bc_vend1 = '' THEN bc_vend1 = hi_char.
   IF bc_date = ? THEN bc_date = low_date.
   IF bc_date1 = ? THEN bc_date = hi_date.
   mqty_req = 0.
   mqty_iss = 0.
   mcnt = 1.
   create "Excel.Application" chExcelApplication.
      chExcelApplication:Visible = TRUE.
chWorkbook = chExcelApplication:Workbooks:Add().
chWorkSheet = chExcelApplication:Sheets:Item(mcnt).      
           chExcelApplication:Sheets:Item(mcnt):SELECT().
       chExcelApplication:Sheets:Item(mcnt):NAME = "MES���ܵ�" .
        chWorkSheet:Rows(1):RowHeight = 25.
       chWorkSheet:Columns("A:k"):ColumnWidth = 15.
       chWorkSheet:Columns("g:g"):ColumnWidth = 35.
        chWorkSheet:Columns("a:a"):ColumnWidth = 20.
        chWorkSheet:Columns("k:k"):ColumnWidth = 40.
      
        
         chWorkSheet:Range("A1:k1"):Select().
 chExcelApplication:selection:Font:Name = "����".
     /*chWorkSheet:Range("a1:m1"):Select().*/
    chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
  chexcelApplication:Selection:Font:Size = 12.  
 chExcelApplication:selection:Font:bold = TRUE.
chWorkSheet:Range("a1:a1"):VALUE = '���Ա'.
   chWorkSheet:Range("b1:b1"):VALUE = "�Ʋֵ�".  
  chWorkSheet:Range("c1:c1"):VALUE = "����".      
 chWorkSheet:Range("d1:d1"):VALUE = "�ص�".
       chWorkSheet:Range("e1:e1"):VALUE = "�߱߿�λ".
       chWorkSheet:Range("f1:f1"):VALUE = "�����".
    
      chWorkSheet:Range("g1:g1"):VALUE = "�������".
     chWorkSheet:Range("h1:h1"):VALUE = "������".
     chWorkSheet:Range("i1:i1"):VALUE = "ʵ����".
    chWorkSheet:Range("j1:j1"):VALUE = "Ƿ����".
    chWorkSheet:Range("k1:k1"):VALUE = "��Ӧ��".
     mcnt = 1.
     rowstart = 1.
 FOR EACH b_mes_wkfl WHERE b_mes_staff >= bc_staff AND b_mes_staff <= bc_staff1 AND b_mes_id >= bc_nbr AND b_mes_id <= bc_nbr1 AND b_mes_due_date >= bc_date AND b_mes_due_date <= bc_date1 AND b_mes_site >= bc_site AND b_mes_site <= bc_site1 AND b_mes_ln_loc >= bc_loc AND b_mes_ln_loc <= bc_loc1 AND b_mes_part >= bc_part AND b_mes_part <= bc_part1
     AND b_mes_vend >= bc_vend AND b_mes_vend <= bc_vend1 NO-LOCK BREAK BY b_mes_staff /*BY b_mes_id*/ /*BY b_mes_due_date*/  BY b_mes_site BY b_mes_ln_loc BY b_mes_part:


     
     
     

 mqty_req = mqty_req + b_mes_qty_req.
 mqty_iss = mqty_iss + b_mes_qty_iss.
   IF LAST-OF(b_mes_part) THEN DO:
  rowstart = rowstart + 1.
     FIND FIRST pt_mstr WHERE pt_part = b_mes_part NO-LOCK NO-ERROR.
     FIND FIRST ad_mstr WHERE ad_addr = b_mes_vend NO-LOCK NO-ERROR.
     
chWorkSheet:Rows(rowstart):RowHeight = 15. 
                   crange = "a" + STRING(rowstart) + ":"  + "k" + STRING(rowstart).
                     chWorkSheet:Range(crange):Select().
      chexcelApplication:Selection:Font:Size = 10.  

     chExcelApplication:selection:HorizontalAlignment = 2.
     chExcelApplication:selection:VerticalAlignment = 2.
     chExcelApplication:selection:Font:Name = "ARIAL". 
     chExcelApplication:selection:numberformat = '@'.
    crange = "a" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_mes_staff.
   crange = "b" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = /*b_mes_id*/ ''.

     crange = "c" + STRING(rowstart).  
     /* chWorkSheet:Range(crange):numberformat = 'dd/mm/yy'.*/
     chWorkSheet:Range(crange):VALUE = STRING(bc_date) + '-' + STRING(bc_date1).
     crange = "d" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_mes_site.
   crange = "e" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_mes_ln_loc.
   crange = "f" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = b_mes_part.
   crange = "g" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = IF AVAILABLE pt_mstr THEN pt_desc1 + pt_desc2 ELSE ''.
   crange = "h" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
   chWorkSheet:Range(crange):VALUE = mqty_req.
   crange = "i" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
   chWorkSheet:Range(crange):VALUE = mqty_iss.
   crange = "j" + STRING(rowstart). 
   chWorkSheet:Range(crange):numberformat = '0'.
   chWorkSheet:Range(crange):VALUE = mqty_req - mqty_iss.
   crange = "k" + STRING(rowstart).  
   chWorkSheet:Range(crange):VALUE = IF AVAILABLE ad_mstr THEN (IF ad_name <> '' THEN ad_name ELSE ad_sort) ELSE b_mes_vend.
   mqty_req = 0.
   mqty_iss = 0.
   
   END.
   
    
     
 END.
     chWorkSheet:Range("A1:k" + string(Rowstart)):Select().
      chExcelApplication:selection:Borders(8):Weight = 4. 
     chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
        chExcelApplication:selection:Borders(10):Weight = 4.
        chWorkSheet:Range("A" + string(Rowstart) + ":k" + string(Rowstart)):Select().
        chExcelApplication:selection:Borders(4):Weight = 4.
       chWorkSheet:Range("A1:A" + STRING(rowstart)):Select().
 chExcelApplication:selection:Borders(1):Weight = 4. 
  RELEASE OBJECT chWorksheet.
     
   RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.   
     
     
     
     
  
    /*    
     ENABLE bc_site WITH FRAME bc.    */
               END.


{bctrail.i}
