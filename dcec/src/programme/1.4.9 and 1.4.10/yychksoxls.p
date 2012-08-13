/*yychksoxls.p designed by Philips Li for so-loading checking           07/04/08*/
{mfdtitle.i "e+"}

DEFINE VARIABLE sonbr LIKE so_nbr.
DEFINE VARIABLE cust LIKE so_cust.
DEFINE VARIABLE pricelist LIKE so_pr_list.
DEFINE VARIABLE site LIKE so_site.
DEFINE VARIABLE channel LIKE so_channel.
DEFINE VARIABLE promoter AS CHAR LABEL "Salesperson" FORMAT "x(8)".
DEFINE VARIABLE lineno LIKE sod_line.
DEFINE VARIABLE part LIKE sod_part.
DEFINE VARIABLE amount LIKE sod_qty_ord.
DEFINE VARIABLE sopo LIKE so_po.
DEFINE VARIABLE rmks LIKE so_rmks.
DEFINE VARIABLE price LIKE pt_price.
DEFINE VARIABLE src_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE dtn_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE avail_calc AS INT.
DEFINE VARIABLE alloc LIKE in_qty_all.
DEFINE VARIABLE omin LIKE ptp_ord_min.
DEFINE VARIABLE sheetname AS CHAR FORMAT "x(18)".

DEF VAR startline AS INT LABEL "���ݿ�ʼ��" INIT 6.
DEF VAR max_lev AS INT FORMAT ">9" LABEL "������������" INIT 4.
DEF VAR conf-yn AS LOGICAL.
DEF VAR mprlist AS LOGICAL.
DEF VAR i AS INT.
DEF VAR j AS INT.
DEF VAR k AS INT.
DEF VAR isnewso AS LOGICAL.
DEF VAR endrowmark AS CHARACTER.

DEFINE VARIABLE excelapp AS COM-HANDLE.
DEFINE VARIABLE excelworkbook AS COM-HANDLE.
DEFINE VARIABLE worksheet AS COM-HANDLE.  

DEFINE VAR pts AS CHAR FORMAT "x(50)" no-undo.


FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /*tfq site colon 22 sidesc no-label skip(1) */
 src_file COLON 22 LABEL "����ļ�"
 sheetname COLON 22 LABEL "sheet��"
 startline COLON 22  LABEL "���ݿ�ʼ��"  
 max_lev  COLON 22   SKIP(1) 
   "** ģ���ʽ������ϲ���Ԫ���Կ��н�����������ı��е�λ��**"       AT 5 SKIP
   "** ������֮ǰ������excel���κ��ļ�����ȷ�ϼ���ѡ���滻�ļ�ѡ��ѡyesʹ������������ļ���**"     AT 5 SKIP
          
    SKIP(.4)  /*GUI*/
WITH FRAME a SIDE-LABELS WIDTH 80 ATTR-SPACE NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN IN FRAME a = YES.
 RECT-FRAME:HEIGHT-PIXELS IN FRAME a =
 FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y IN FRAME a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
 setFrameLabels(FRAME a:HANDLE) . 
    

mainloop:
REPEAT:
   
 DO TRANSACTION ON ERROR UNDO, LEAVE:   
   
     
     IF src_file = "" THEN src_file = "e:\so.xls".
     IF sheetname = "" THEN sheetname = "sheet1".
     dtn_file = src_file.
    
      UPDATE src_file sheetname startline VALIDATE(INPUT startline > 0 ,"�к�С�ڵ������ǲ������") 
         max_lev VALIDATE(INPUT max_lev > 0 ,"������������С�ڵ������ǲ������")   with frame a.
       
       IF SEARCH(src_file) = ? THEN DO:
            MESSAGE "����:����ļ�������,����������!" VIEW-AS ALERT-BOX ERROR.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.
       END.

       IF SUBSTRING(src_file , LENGTH(src_file) - 3) <> ".xls"  THEN 
       DO: 
       MESSAGE "����:ֻ��EXCEL�ļ���������,����������!" VIEW-AS ALERT-BOX ERROR.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.

       END.

       conf-yn = NO.
       MESSAGE "ȷ�ϼ��" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE conf-yn.
       IF conf-yn <> YES THEN UNDO,RETRY.
       
       /******************main loop********************/
       /******************input the external transfer list data into a stream**************/
       
       CREATE "Excel.Application" excelapp.
       excelworkbook = excelapp:workbooks:ADD(src_file).
       worksheet = excelapp:worksheets(sheetname).
       worksheet:Columns("K"):ColumnWidth = 24.
       worksheet:Columns("L"):ColumnWidth = 18.
       worksheet:Columns("M"):ColumnWidth = 18.
       worksheet:Columns("N"):ColumnWidth = 18.
       worksheet:Columns("O"):ColumnWidth = 18.
       worksheet:Columns("P"):ColumnWidth = 18.
       worksheet:Columns("Q"):ColumnWidth = 24.
       i = startline.

       sonbr =  worksheet:cells(i,1):TEXT.
       IF sonbr = "" THEN DO:
           FIND FIRST soc_ctrl NO-LOCK NO-ERROR.
           IF AVAIL soc_ctrl THEN
               sonbr = soc_so_pre + STRING(soc_so).
           isnewso = YES.
       END.
       ELSE DO:
           FOR EACH sod_det WHERE sod_nbr = sonbr NO-LOCK:
               IF sod_qty_ship <> 0 THEN DO:
                   MESSAGE "�ö����ѱ�����!" VIEW-AS ALERT-BOX .
                   UNDO mainloop, RETRY.
               END.
           END.
       END.
       ASSIGN
              cust = worksheet:cells(i,2):TEXT 
              pricelist = worksheet:cells(i,6):TEXT 
              site = worksheet:cells(i,7):TEXT 
              channel = worksheet:cells(i,8):TEXT 
              promoter = worksheet:cells(i,9):TEXT
              rmks = worksheet:cells(i,5):TEXT
              sopo = worksheet:cells(i,4):TEXT .
             
      REPEAT:    /*so input repeat*/
           ASSIGN    
                   lineno = INT(worksheet:cells(i,10):TEXT) 
                   part = trim(worksheet:cells(i,11):TEXT)  
                   amount = INT(worksheet:cells(i,14):TEXT).

           IF isnewso = NO THEN DO:
                worksheet:Range("A" + STRING(i)):VALUE = sonbr.
           END.
            worksheet:Range("B" + STRING(i)):VALUE = cust.
            worksheet:Range("D" + STRING(i)):VALUE = sopo.
            worksheet:Range("E" + STRING(i)):VALUE = rmks.
            worksheet:Range("F" + STRING(i)):VALUE = pricelist.
            worksheet:Range("G" + STRING(i)):VALUE = site.
            worksheet:Range("H" + STRING(i)):VALUE = channel.
            worksheet:Range("I" + STRING(i)):VALUE = promoter.
           mprlist = NO.

           FIND FIRST ad_mstr WHERE ad_type = "customer" AND ad_addr = cust NO-LOCK NO-ERROR.
           IF AVAIL ad_mstr THEN DO:
               worksheet:Range("C" + STRING(i)):VALUE = ad_name .
           END.
           ELSE DO:
               worksheet:Range("C" + STRING(i)):VALUE = "�ÿͻ���ϵͳ�в����ڣ�" .
           END.

           FIND FIRST pt_mstr WHERE pt_part = part NO-LOCK NO-ERROR.
           IF AVAIL pt_mstr THEN DO:
                worksheet:Range("L" + STRING(i)):VALUE = pt_desc1 .
                worksheet:Range("M" + STRING(i)):VALUE = pt_desc2 .
           END.
           ELSE DO:
               worksheet:Range("L" + STRING(i)):VALUE = "���������pt_mstr�У�". 
               worksheet:Range("M" + STRING(i)):VALUE = "���������pt_mstr�У�". 
           END.

           FIND FIRST in_mstr WHERE in_part = part AND in_site = "dcec-b" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:
               worksheet:Range("R" + STRING(i)):VALUE = in_qty_oh. 
           END.
           ELSE DO:
               worksheet:Range("R" + STRING(i)):VALUE = "�����Ϣ�����ڣ�". 
           END.

           FIND FIRST in_mstr WHERE in_part = part AND in_site = "dcec-c" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:
               worksheet:Range("S" + STRING(i)):VALUE = in_qty_oh. 
           END.
           ELSE DO:
               worksheet:Range("S" + STRING(i)):VALUE = "�����Ϣ�����ڣ�". 
           END.

           FIND FIRST in_mstr WHERE in_part = part AND in_site = "dcec-sv" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:
               worksheet:Range("T" + STRING(i)):VALUE = in_qty_oh. 
           END.
           ELSE DO:
               worksheet:Range("T" + STRING(i)):VALUE = "�����Ϣ�����ڣ�". 
           END.

           FIND FIRST in_mstr WHERE in_part = part AND in_site = "CEBJ" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:
               worksheet:Range("W" + STRING(i)):VALUE = in_qty_oh. 
           END.
           ELSE DO:
               worksheet:Range("W" + STRING(i)):VALUE = "�����Ϣ�����ڣ�". 
           END.

           FIND FIRST in_mstr  WHERE in_part = part
               AND in_site = "dcec-sv" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:      
              worksheet:Range("U" + STRING(i)):VALUE = in_qty_ord. 
              worksheet:Range("V" + STRING(i)):VALUE = in_qty_ord + in_qty_oh - in_qty_req.
        
           END.
           ELSE DO:
              worksheet:Range("U" + STRING(i)):VALUE = "�����Ϣ�����ڣ�". 
              worksheet:Range("V" + STRING(i)):VALUE = "�����Ϣ�����ڣ�".
           END.

           FIND FIRST in_mstr  WHERE in_part = part
               AND in_site = "CEBJ" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:      
              worksheet:Range("X" + STRING(i)):VALUE = in_qty_ord.
              worksheet:Range("Y" + STRING(i)):VALUE = in_qty_ord + in_qty_oh - in_qty_req. 

           END.
           ELSE DO:
              worksheet:Range("X" + STRING(i)):VALUE = "�����Ϣ�����ڣ�". 
              worksheet:Range("Y" + STRING(i)):VALUE = "�����Ϣ�����ڣ�".
           END.
                
           FOR EACH pi_mstr NO-LOCK WHERE pi_list = pricelist 
               AND ((TODAY >= pi_start AND TODAY <= pi_expire) OR (pi_start = ? AND pi_expire = ?))
               AND pi_um = "ea"
               AND pi_curr = "RMB":
               IF pi_part_code BEGINS "qadall" AND pi_cs_code BEGINS "qadall" THEN
                   mprlist = YES.
               IF pi_part_code BEGINS "qadall" AND pi_cs_code = cust THEN
                   mprlist = YES.
               IF pi_part_code = part AND pi_cs_code BEGINS "qadall" THEN
                   mprlist = YES.
               IF pi_part_code = part AND pi_cs_code = cust THEN
                   mprlist = YES.
           END.
           
           IF mprlist = NO THEN DO:
               worksheet:Range("Z" + STRING(i)):VALUE = "�۸�δά�����۸�Ϊ�㣡"   .
           END.
          

           FIND FIRST ptp_det WHERE ptp_part = part AND ptp_site = site NO-LOCK NO-ERROR.
           IF AVAIL ptp_det THEN DO:
               omin = ptp_ord_min.
               IF omin = 0 OR omin = 44444 THEN  DO:             
                   IF omin = 0 THEN DO:
                       worksheet:Range("Q" + STRING(i)):VALUE = amount.
                   END.
                   IF omin = 44444 THEN DO:
                       worksheet:Range("Q" + STRING(i)):VALUE = "".
                       FIND FIRST pts_det WHERE pts_det.pts_par = "" 
                           AND pts_det.pts_part = part NO-LOCK NO-ERROR.
                       IF AVAIL pts_det THEN DO:
                           run process_pts (input part , 
                                INPUT max_lev ,
                                OUTPUT pts).
                           worksheet:Range("P" + STRING(i)):VALUE = pts .
                       END.
                       ELSE DO:
                           worksheet:Range("P" + STRING(i)):VALUE = "û��������".
                       END.
              
                   END.
                END.
           
               ELSE DO:
                   k = 1.
                   REPEAT:
                      IF (k * omin) >= amount THEN
                          LEAVE.
                      k = k + 1.
                   END.
                   worksheet:Range("Q" + STRING(i)):VALUE = k * omin.
               END.
               IF omin <> 44444 THEN
                    worksheet:Range("O" + STRING(i)):VALUE = omin.
           END.
           ELSE DO:
               FIND FIRST pt_mstr WHERE pt_part = part NO-LOCK NO-ERROR.
               IF AVAIL pt_mstr THEN DO:
                   omin = pt_ord_min.
               IF omin = 0 OR omin = 44444 THEN  DO:             
                   IF omin = 0 THEN DO:
                       worksheet:Range("Q" + STRING(i)):VALUE = amount.
                   END.
                   IF omin = 44444 THEN DO:
                       worksheet:Range("Q" + STRING(i)):VALUE = "".
                       FIND FIRST pts_det WHERE pts_det.pts_par = "" AND pts_det.pts_part = part NO-LOCK NO-ERROR.
                       IF AVAIL pts_det THEN DO:
                           run process_pts (input part , 
                                INPUT max_lev ,
                                OUTPUT pts).
                           worksheet:Range("P" + STRING(i)):VALUE = pts .
                       END.
                       ELSE DO:
                           worksheet:Range("P" + STRING(i)):VALUE = "û��������".
                       END.
              
                   END.
                END.
               ELSE DO:
                   k = 1.
                   REPEAT:
                      IF (k * omin) >= amount THEN
                          LEAVE.
                      k = k + 1.
                   END.
                   IF omin <> 44444 THEN
                        worksheet:Range("Q" + STRING(i)):VALUE = k * omin.
               END.
                   worksheet:Range("O" + STRING(i)):VALUE = omin.
               END.
               ELSE DO:               
                   worksheet:Range("P" + STRING(i)):VALUE = "�����Ϣ�����ڣ�".
               END.
               
         
           END.

                   i = i + 1 .
                   endrowmark = worksheet:cells(i,10):TEXT  .

             IF endrowmark = ""  THEN DO:
                excelworkbook:saveas(src_file , , , , , , 1) . 
                excelapp:VISIBLE = FALSE .
                excelworkbook:CLOSE(FALSE).
                excelapp:QUIT. 
                RELEASE OBJECT excelapp.
                RELEASE OBJECT excelworkbook.
                RELEASE OBJECT worksheet.
                LEAVE .
             END.
          
             
      END.  /*repeat*/
       
      MESSAGE "������!" VIEW-AS ALERT-BOX .
 END. /*do transaction*/
END. 

PROCEDURE process_pts :
   define input PARAMETER p LIKE pt_part no-undo.
   define input PARAMETER max_l LIKE max_lev no-undo.
   define OUTPUT parameter s AS CHAR FORMAT "x(50)" no-undo.
   DEFINE VAR ii AS INT no-undo.
   REPEAT ii = 1 TO max_l :
       FIND FIRST pts_det WHERE pts_det.pts_par = "" 
           AND pts_det.pts_part = p NO-LOCK NO-ERROR.
       IF AVAIL pts_det THEN DO:
           IF s = "" THEN
               s =  pts_sub_part .
           ELSE 
               s = s + "/" + pts_sub_part .
           p = pts_sub_part .
       END.
   END.
END.
