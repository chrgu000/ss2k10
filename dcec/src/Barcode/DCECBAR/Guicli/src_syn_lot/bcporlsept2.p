{mfdeclre.i}
{bcdeclre.i  }
{bcwin08.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_part_desc AS CHAR FORMAT "x(20)" LABEL "�������".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(20)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "��׼����".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "��/���".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "�������".
DEF VAR bcprefix AS CHAR.

DEFINE BUTTON bc_button LABEL "��ӡ" SIZE 8 BY 1.20.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF VAR bc_qty_label AS  DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
DEF VAR ismodi AS LOGICAL.
DEF VAR bc_po_vend AS CHAR FORMAT "x(8)" LABEL '��Ӧ��'.
DEF VAR bc_po_vend1 AS CHAR FORMAT "x(8)" LABEL "��".

DEF VAR bc_part1 AS CHAR FORMAT 'x(18)' LABEL "��".
DEF VAR bc_rlse_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "������".
DEF VAR bc_date AS DATE LABEL '����'.
DEF VAR bc_date1 AS DATE LABEL '��'.
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEF VAR mcnt AS INT.
DEF VAR bc_poshp AS CHAR FORMAT 'x(20)' LABEL '���˵�'.
DEF VAR bc_poshp1 AS CHAR FORMAT 'x(20)' LABEL '��'.
DEF FRAME bc
    bc_date AT ROW 1.2 COL 4
   bc_date1 AT ROW 2.4 COL 5.6
    bc_po_vend AT ROW 3.6 COL 2.5
    bc_po_vend1  AT ROW 4.8 COL 5.6
    bc_poshp AT ROW 6 COL 2.5
   
    bc_poshp1  AT ROW 7.2 COL 5.6
   
   bc_part AT ROW 8.4 COL 2.5
   /* bc_poshp AT ROW 6.5 COL 2.5*/
    bc_part1 AT ROW 9.6 COL 5.6
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
  
   
     bc_button AT ROW 10.9 COL 10
    WITH SIZE 30 BY 12.5 TITLE "��������ӡ"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_date bc_date1 bc_po_vend bc_po_vend1 bc_poshp bc_poshp1 bc_part bc_part1  bc_button WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 bc_date = TODAY.
 bc_date1 = TODAY.
 DISP bc_date bc_date1 WITH FRAME bc.
VIEW c-win.

ON CURSOR-DOWN OF bc_po_vend
DO:
    
       ASSIGN bc_po_vend.
       FIND FIRST vd_mstr NO-LOCK WHERE vd_addr > bc_po_vend NO-ERROR.
       IF AVAILABLE vd_mstr THEN DO:
           ASSIGN bc_po_vend = vd_addr.
           DISPLAY bc_po_vend WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_po_vend
DO:
   
       ASSIGN bc_po_vend.
       FIND LAST vd_mstr NO-LOCK WHERE vd_addr < bc_po_vend NO-ERROR.
       IF AVAILABLE vd_mstr THEN DO:
           ASSIGN bc_po_vend = vd_addr.
           DISPLAY bc_po_vend WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_po_vend
DO:
 bc_po_vend = bc_po_vend:SCREEN-VALUE.
END.
ON enter OF bc_po_vend
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_po_vend = bc_po_vend:SCREEN-VALUE.
   /* DISABLE bc_po_vend WITH FRAME bc.
    ENABLE bc_po_vend1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_po_vend1.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.


ON CURSOR-DOWN OF bc_po_vend1
DO:
    
       ASSIGN bc_po_vend1.
       FIND FIRST vd_mstr NO-LOCK WHERE vd_addr > bc_po_vend1 NO-ERROR.
       IF AVAILABLE vd_mstr THEN DO:
           ASSIGN bc_po_vend1 = vd_addr.
           DISPLAY bc_po_vend1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_po_vend1
DO:
   
       ASSIGN bc_po_vend1.
       FIND LAST vd_mstr NO-LOCK WHERE vd_addr < bc_po_vend1 NO-ERROR.
       IF AVAILABLE vd_mstr THEN DO:
           ASSIGN bc_po_vend1 = vd_addr.
           DISPLAY bc_po_vend1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_po_vend1
DO:
 bc_po_vend1 = bc_po_vend1:SCREEN-VALUE.
END.
ON enter OF bc_po_vend1
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_po_vend1 = bc_po_vend1:SCREEN-VALUE.
  /*  DISABLE bc_po_vend1 WITH FRAME bc.
    ENABLE bc_poshp WITH FRAME bc.*/
    APPLY 'entry':u TO bc_poshp.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.
ON CURSOR-DOWN OF bc_poshp
DO:
    
       ASSIGN bc_poshp.
       FIND FIRST b_poshp_wkfl USE-INDEX b_poshp_sort NO-LOCK WHERE b_poshp_vend = bc_po_vend AND b_poshp_shipper > bc_poshp NO-ERROR.
       IF AVAILABLE b_poshp_wkfl THEN DO:
           ASSIGN bc_poshp = b_poshp_shipper.
           DISPLAY bc_poshp WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_poshp
DO:
   
       ASSIGN bc_poshp.
       FIND LAST b_poshp_wkfl USE-INDEX b_poshp_sort NO-LOCK WHERE b_poshp_vend = bc_po_vend AND b_poshp_shipper < bc_poshp NO-ERROR.
       IF AVAILABLE b_poshp_wkfl THEN DO:
           ASSIGN bc_poshp = b_poshp_shipper.
           DISPLAY bc_poshp WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_poshp
DO:
 bc_poshp = bc_poshp:SCREEN-VALUE.
END.
ON enter OF bc_poshp
DO:
    bc_poshp = bc_poshp:SCREEN-VALUE.
    /*{bcrun.i ""bcmgcheck.p"" "(input ""po"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_poshp, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
    IF  NOT success THEN do:
       
       UNDO,RETRY.

    END.
   ELSE DO: */
     /*  DISABLE bc_poshp WITH FRAME bc.
       ENABLE bc_poshp1 WITH FRAME bc.*/
    APPLY  'entry':u TO bc_poshp1.
 
  /* END.*/
END.



ON CURSOR-DOWN OF bc_poshp1
DO:
    
       ASSIGN bc_poshp1.
       FIND FIRST b_poshp_wkfl USE-INDEX b_poshp_sort NO-LOCK WHERE b_poshp_vend = bc_po_vend1 AND b_poshp_shipper > bc_poshp1 NO-ERROR.
       IF AVAILABLE b_poshp_wkfl THEN DO:
           ASSIGN bc_poshp1 = b_poshp_shipper.
           DISPLAY bc_poshp1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_poshp1
DO:
   
       ASSIGN bc_poshp1.
       FIND LAST b_poshp_wkfl USE-INDEX b_poshp_sort NO-LOCK WHERE b_poshp_vend = bc_po_vend1 AND b_poshp_shipper < bc_poshp1 NO-ERROR.
       IF AVAILABLE b_poshp_wkfl THEN DO:
           ASSIGN bc_poshp1 = b_poshp_shipper.
           DISPLAY bc_poshp1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_poshp1
DO:
 bc_poshp1 = bc_poshp1:SCREEN-VALUE.
END.
ON enter OF bc_poshp1
DO:
    bc_poshp1 = bc_poshp1:SCREEN-VALUE.
    /*{bcrun.i ""bcmgcheck.p"" "(input ""po"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_poshp, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
    IF  NOT success THEN do:
       
       UNDO,RETRY.

    END.
   ELSE DO: */
     /*  DISABLE bc_poshp WITH FRAME bc.
       ENABLE bc_poshp1 WITH FRAME bc.*/
    APPLY  'entry':u TO bc_part.
 
  /* END.*/
END.
/*ENABLE bc_part  WITH FRAME bc IN WINDOW c-win.*/
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 

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
ON VALUE-CHANGED OF bc_part
DO:
 bc_part = bc_part:SCREEN-VALUE.
END.
ON enter OF bc_part
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part = bc_part:SCREEN-VALUE.
  /*  DISABLE bc_part WITH FRAME bc.
    ENABLE bc_part1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_part1.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
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
ON VALUE-CHANGED OF bc_part1
DO:
 bc_part1 = bc_part1:SCREEN-VALUE.
END.
ON enter OF bc_part1
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part1 = bc_part1:SCREEN-VALUE.
    /*DISABLE bc_part1 WITH FRAME bc.*/
   
  /*  ENABLE bc_date WITH FRAME bc.*/
    APPLY 'entry':u TO bc_button.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.

ON VALUE-CHANGED OF bc_date
DO:
ASSIGN bc_date NO-ERROR.
END.
ON enter OF bc_date
DO:
    ASSIGN bc_date NO-ERROR.
       /* DISABLE bc_date WITH FRAME bc.
    ENABLE bc_date1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_date1.
END.
ON VALUE-CHANGED OF bc_date1
DO:
ASSIGN bc_date1 NO-ERROR.
END.
ON enter OF bc_date1
DO:
    ASSIGN bc_date1 NO-ERROR.
       /* DISABLE bc_date1 WITH FRAME bc.
    RUN main.*/
    APPLY 'entry':u TO bc_po_vend.
END.

ON 'choose':U OF bc_button
DO:
   RUN main.

END.
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PROCEDURE main:
      DEF VAR b_id LIKE b_co_code.
      DEF VAR m_fmt LIKE b_co_format.
     
      DEF VAR i AS INT.
      IF bc_po_vend1 = '' THEN bc_po_vend1 = hi_char.
      IF bc_poshp1 = '' THEN bc_poshp1 = hi_char.
      IF bc_part1 = '' THEN bc_part1 = hi_char.
      IF bc_date = ? THEN bc_date = low_date.
      IF bc_date1 = ? THEN bc_date1 = hi_date.
    create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = TRUE.
     
       chWorkbook = chExcelApplication:Workbooks:Add().
     
    mcnt = 1.
     
          FOR EACH b_poshp_wkfl USE-INDEX b_poshp_sort WHERE b_poshp_due_date >= bc_date AND b_poshp_due_date <= bc_date1 AND b_poshp_vend >= bc_po_vend AND b_poshp_vend <= bc_po_vend1 AND 
              b_poshp_shipper >= bc_poshp AND b_poshp_shipper <= bc_poshp1 AND
              b_poshp_part >= bc_part AND b_poshp_part <= bc_part1   
              NO-LOCK BREAK BY b_poshp_staff:
            
              IF FIRST-OF(b_poshp_staff) THEN DO:
           rowstart = 1.
            chWorkSheet = chExcelApplication:Sheets:Item(mcnt).
                 chExcelApplication:Sheets:Item(mcnt):SELECT().
       chExcelApplication:Sheets:Item(mcnt):NAME = "������-" + b_poshp_staff.
        chWorkSheet:Rows(rowstart):RowHeight = 25.
       chWorkSheet:Columns("A:g"):ColumnWidth = 15.
       chWorkSheet:Columns("e:e"):ColumnWidth = 35.
       chWorkSheet:Columns("f:f"):ColumnWidth = 35.

         chWorkSheet:Range("A1:g1"):Select().
 chExcelApplication:selection:Font:Name = "����".
     /*chWorkSheet:Range("a1:m1"):Select().*/
    chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
  chexcelApplication:Selection:Font:Size = 12.  
 chExcelApplication:selection:Font:bold = TRUE.
       chWorkSheet:Range("a1:a1"):VALUE = "����".
       chWorkSheet:Range("b1:b1"):VALUE = "�����".
       chWorkSheet:Range("c1:c1"):VALUE = "�������".
    
      chWorkSheet:Range("d1:d1"):VALUE = "����".
       chWorkSheet:Range("e1:e1"):VALUE = "����".
    chWorkSheet:Range("f1:f1"):VALUE = "��Ӧ��".
    chWorkSheet:Range("g1:g1"):VALUE = "���˵�".
    
      mcnt = mcnt + 1.
           END.

      rowstart = rowstart + 1.
      FIND FIRST pt_mstr WHERE pt_part = b_poshp_part NO-LOCK NO-ERROR.
      FIND FIRST ad_mstr WHERE ad_addr = b_poshp_vend NO-LOCK NO-ERROR.

chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "g" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
       chExcelApplication:selection:numberformat = '@'.
     crange = "a" + STRING(rowstart).  
     chWorkSheet:Range(crange):numberformat = 'dd/mm/yy'.
     chWorkSheet:Range(crange):VALUE = b_poshp_due_date.
     crange = "b" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = b_poshp_part.
     crange = "c" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = IF AVAILABLE pt_mstr THEN pt_desc1 + pt_desc2 ELSE ''.
     crange = "d" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE = b_poshp_code.
     crange = "e" + STRING(rowstart). 
     chWorkSheet:Range(crange):numberformat = '0'.
     chWorkSheet:Range(crange):VALUE = b_poshp_qty.
     crange = "f" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE =  IF AVAILABLE ad_mstr THEN (IF ad_name <> '' THEN ad_name ELSE ad_sort) ELSE b_poshp_vend.
     crange = "g" + STRING(rowstart).  
     chWorkSheet:Range(crange):VALUE =   b_poshp_shipper.
    

                      



           IF LAST-OF(b_poshp_staff) THEN DO:
         
                chWorkSheet:Range("A1:g" + string(Rowstart)):Select().
      chExcelApplication:selection:Borders(8):Weight = 4. 
     chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
        chExcelApplication:selection:Borders(10):Weight = 4.
        chWorkSheet:Range("A" + string(Rowstart) + ":g" + string(Rowstart)):Select().
        chExcelApplication:selection:Borders(4):Weight = 4.
       chWorkSheet:Range("A1:A" + STRING(rowstart)):Select().
 chExcelApplication:selection:Borders(1):Weight = 4. 
 RELEASE OBJECT chWorksheet.
           END.
          END.
              
              
              
              
       RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.   

               
              

     
     
   
     
     
   
        
        
       
      
      RELEASE b_poshp_wkfl.
     
               END.


{bctrail.i}