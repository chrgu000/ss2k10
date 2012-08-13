{mfdeclre.i}
{bcdeclre.i  }
{bcwin13.i}
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
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)" LABEL "�ų̵�".
DEFINE BUTTON bc_button LABEL "ȷ��" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF VAR bc_qty_label AS  DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
DEF VAR ismodi AS LOGICAL.
DEF VAR bc_po_vend AS CHAR FORMAT "x(8)" LABEL '��Ӧ��'.
DEF VAR bc_po_vend1 AS CHAR FORMAT "x(8)" LABEL "��".
DEF VAR bc_po_nbr1 AS CHAR FORMAT "x(8)" LABEL "��".
DEF VAR bc_part1 AS CHAR FORMAT 'x(8)' LABEL "��".
DEF VAR bc_rlse_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "������".
DEF VAR bc_date AS DATE LABEL '����'.
DEF VAR bc_date1 AS DATE LABEL '��'.
DEF TEMP-TABLE b_po_tmp
    FIELD b_sess LIKE g_sess
    FIELD b_due_date AS DATE
    FIELD b_part AS CHAR
    FIELD b_qty AS DECIMAL
    FIELD b_vend AS CHAR.
DEF VAR isok AS LOGICAL INITIAL NO.
DEF VAR bc_src AS CHAR FORMAT "x(6)" LABEL "����Դ".
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEF FRAME bc
    bc_src AT ROW 3 COL 2.5
  /* bc_date1 AT ROW 9.6 COL 5.6*/
    bc_button AT ROW 5 COL 10
    
    WITH SIZE 30 BY 8 TITLE "����������"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ENABLE bc_src bc_button WITH FRAME bc.
bc_src = 'excel'.
DISP bc_src WITH FRAME bc.
VIEW c-win.

ON CURSOR-DOWN OF bc_src
DO:
    
       ASSIGN bc_src.
       IF bc_src = 'excel' THEN bc_src = 'mes'.
             ELSE bc_src = 'excel'.
       
           DISPLAY bc_src WITH FRAME bc.
      
    
END.

ON CURSOR-UP OF bc_src
DO:
    
       ASSIGN bc_src.
       IF bc_src = 'excel' THEN bc_src = 'mes'.
             ELSE bc_src = 'excel'.
       
           DISPLAY bc_src WITH FRAME bc.
      
    
END.


ON VALUE-CHANGED OF bc_src
DO:
 bc_src = bc_src:SCREEN-VALUE.
END.
ON enter OF bc_src
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_src = bc_src:SCREEN-VALUE.
   /* DISABLE bc_po_vend WITH FRAME bc.
    ENABLE bc_po_vend1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_button.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
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
   DEF VAR mpart AS CHAR.
    DEF  VAR mvend AS CHAR.
    DEF VAR pre_ref AS CHAR.
    
    IF bc_src = 'excel' THEN DO:
FIND FIRST CODE_mstr WHERE CODE_fldname = 'excelpath' AND CODE_value <> '' NO-LOCK NO-ERROR.
  IF AVAILABLE code_mstr THEN DO:

    create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = FALSE.
     
       chWorkbook = chExcelApplication:Workbooks:OPEN(CODE_value).
       chWorkSheet = chExcelApplication:Sheets:Item(1).  
       chExcelApplication:Sheets:Item(1):SELECT().
       rowstart = 2.
       DO WHILE chworksheet:range('a' + string(rowstart)):VALUE <> ?:
           /*MESSAGE chworksheet:range('a' + string(rowstart)):VALUE VIEW-AS ALERT-BOX.*/
           CREATE b_po_tmp.
           b_sess = g_sess.
           crange = "a" + STRING(rowstart).  
               b_due_date = date(string(chWorkSheet:Range(crange):VALUE)) NO-ERROR.
               IF ERROR-STATUS:ERROR OR b_due_date = ? THEN DO:
                   MESSAGE chWorkSheet:Range(crange):VALUE ' ��Ч���ڸ�ʽ' VIEW-AS ALERT-BOX.
                  success = NO.
                   LEAVE.
                   END.
                    crange = "b" + STRING(rowstart).
                   mpart = string(chWorkSheet:Range(crange):VALUE).
                  /* mpart = SUBSTR(mpart,1,INDEX(mpart,'.') - 1).*/
             FIND FIRST pt_mstr WHERE pt_part = mpart  NO-LOCK NO-ERROR.
               IF NOT AVAILABLE pt_mstr THEN DO:
                   MESSAGE chWorkSheet:Range(crange):VALUE ' ��Ч���!' VIEW-AS ALERT-BOX.
                   success = NO.
                   LEAVE.
                   END.
                b_part = pt_part.
             crange = "c" + STRING(rowstart).  
               b_qty = DECIMAL(chWorkSheet:Range(crange):VALUE) NO-ERROR.
               IF ERROR-STATUS:ERROR  THEN DO:
                   MESSAGE chWorkSheet:Range(crange):VALUE ' ��Ч����!' VIEW-AS ALERT-BOX.
                   success = NO.
                   LEAVE.
                   END.
                    crange = "d" + STRING(rowstart).  
                   mvend = string(chWorkSheet:Range(crange):VALUE).
                /*  mvend = SUBSTR(mvend,1,INDEX(mvend,'.') - 1).*/
                  FIND FIRST vd_mstr WHERE vd_addr = mvend NO-LOCK NO-ERROR.
                  IF NOT AVAILABLE vd_mstr THEN DO:
                      MESSAGE chWorkSheet:Range(crange):VALUE ' ��Ч��Ӧ��!' VIEW-AS ALERT-BOX.
                      success = NO.
                      LEAVE.
                      END.
                      b_vend = vd_addr.
        rowstart = rowstart + 1.
       END.
       IF NOT success THEN LEAVE.
       
   RELEASE OBJECT chWorksheet.
     RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.  
  END.
   
     ELSE MESSAGE '����·��!' VIEW-AS ALERT-BOX.
    END.
     ELSE DO:


     END.

     FOR EACH b_po_tmp WHERE b_sess = g_sess NO-LOCK:
          
           
         
          FOR EACH b_co_mstr USE-INDEX b_co_sort6 WHERE b_co_ref <> '' AND b_co_shpmch = '' AND b_co_status = 'rct'  AND b_co_part = b_part AND b_co_vend = b_vend AND
              CAN-FIND(FIRST ABS_mstr WHERE substr(ABS_par_id,2,50) = b_co_ref AND abs_shipfrom = b_co_vend AND abs_order = b_co_ord AND abs_line = b_co_line AND ABS_item = b_co_part /*AND ABS_lot = b_co_lot*/ AND ABS_site = b_co_site AND ABS_loc = b_co_loc NO-LOCK)    EXCLUSIVE-LOCK :
              
              IF b_qty  = 0  AND b_co_ref <> pre_ref THEN LEAVE.  
              FIND FIRST IN_mstr WHERE in_site = b_co_site AND IN_part = b_co_part NO-LOCK NO-ERROR.
              CREATE b_poshp_wkfl.
                ASSIGN
                    b_poshp_part = b_co_part
                    b_poshp_due_date = b_due_date
                    b_poshp_qty = b_co_qty_cur
                    b_poshp_vend = b_vend
                    b_poshp_shipper = b_co_ref
                    b_poshp_code = b_co_code
                    b_poshp_staff = IF AVAILABLE in_mstr THEN IN__qadc01 ELSE ''.
                    IF b_qty > 0 THEN  b_qty = b_qty - b_co_qty_cur.
                     pre_ref = b_co_ref.
                     b_co_shpmch = 'm'.
           
           isok = YES.
       END.
     END.
     FOR EACH b_po_tmp WHERE b_sess = g_sess:
        DELETE b_po_tmp.
    END.
    IF isok THEN MESSAGE '�������������!' VIEW-AS ALERT-BOX.
 END.
    

{bctrail.i}
