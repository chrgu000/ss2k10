/*yyldsoxls.p designed by Philips Li for so-loading by excel           03/31/08*/
{mfdtitle.i "e+"}

DEFINE VARIABLE sonbr LIKE so_nbr.
DEFINE VARIABLE cust LIKE so_cust.
DEFINE VARIABLE rmks LIKE so_rmks.
DEFINE VARIABLE sopo LIKE so_po.
DEFINE VARIABLE pricelist LIKE so_pr_list.
DEFINE VARIABLE site LIKE so_site.
DEFINE VARIABLE channel LIKE so_channel.
DEFINE VARIABLE promoter AS CHAR LABEL "Salesperson" FORMAT "x(8)".
DEFINE VARIABLE lineno LIKE sod_line.
DEFINE VARIABLE part LIKE sod_part.
DEFINE VARIABLE amount AS CHAR.
DEFINE VARIABLE um LIKE sod_um.
DEFINE VARIABLE price LIKE pt_price.
DEFINE VARIABLE src_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE lg_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE cim_file AS CHAR FORMAT "x(40)" INIT "c:\appeb2\mywrk\soloading.cim".
DEFINE VARIABLE sheetname AS CHAR FORMAT "x(18)".

DEF VAR startline AS INT LABEL "数据开始行" INIT 6.
DEF VAR conf-yn AS LOGICAL.
DEF VAR i AS INT.
DEF VAR j AS INT.
DEF VAR fid AS INT.
DEF VAR tid AS INT.
DEF VAR err AS INT.
DEF VAR ischeck1 AS CHAR.
DEF VAR ischeck2 AS CHAR.
DEF VAR ischeck3 AS CHAR.
DEF VAR ischeck4 AS CHAR.
DEF VAR ischeck5 AS CHAR.
DEF VAR ischeck6 AS CHAR.
DEF VAR ischeck7 AS CHAR.
DEF VAR ischeck8 AS CHAR.
DEF VAR ischeck9 AS CHAR.
DEF VAR ischeck10 AS CHAR.
DEF VAR ischeck11 AS CHAR.
DEF VAR ischeck12 AS CHAR.
DEF VAR endrowmark AS CHARACTER.
DEF VAR confirm AS LOG.
DEF VAR isvalid AS LOG.
DEF VAR isnewso AS LOG.

DEF STREAM cim.
DEF VAR start_flag AS CHAR format "x(80)" .


DEFINE VARIABLE excelapp AS COM-HANDLE.
DEFINE VARIABLE excelworkbook AS COM-HANDLE.
DEFINE VARIABLE worksheet AS COM-HANDLE.  

/*temp table for line data*/
DEFINE TEMP-TABLE soline_det
    FIELD soline_mfguser LIKE mfguser
    FIELD soline_index AS INT
    FIELD soline_line LIKE sod_line
    FIELD soline_part LIKE sod_part
    FIELD soline_qty LIKE sod_qty_ord
    FIELD soline_isnew AS LOGICAL.
 
 
FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /*tfq site colon 22 sidesc no-label skip(1) */
 src_file COLON 22 LABEL "导入文件"
 sheetname COLON 22 LABEL "sheet名"
 lg_file COLON 22 LABEL "日志文件"
 startline COLON 22  LABEL "数据开始行"  SKIP(1) 
   "** 模板格式不允许合并单元格，以空行结束，不允许改变列的位置**"       AT 5 SKIP
   "** 导入完毕之前请勿用excel打开导入文件**  "  AT 5 SKIP
          
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
     IF lg_file = "" THEN lg_file = "d:\soloading.lg".
    
     confirm = YES.
     isvalid = YES.

      UPDATE src_file sheetname lg_file startline VALIDATE(INPUT startline > 0 ,"行号小于等于零是不允许的")  with frame a.
       
       IF SEARCH(src_file) = ? THEN DO:
            MESSAGE "错误:导入文件不存在,请重新输入!" VIEW-AS ALERT-BOX ERROR.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.
       END.

       IF SUBSTRING(src_file , LENGTH(src_file) - 3) <> ".xls"  THEN 
       DO: 
       MESSAGE "错误:只有EXCEL文件才允许导入,请重新输入!" VIEW-AS ALERT-BOX ERROR.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.

       END.

       conf-yn = NO.
       MESSAGE "确认导入" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE conf-yn.
       IF conf-yn <> YES THEN UNDO,RETRY.

       
       /******************main loop********************/
       /******************input the external transfer list data into a stream**************/
       
       FOR EACH soline_det WHERE soline_mfguser = mfguser:
          DELETE soline_det.
       END.


       CREATE "Excel.Application" excelapp.
       excelworkbook = excelapp:workbooks:ADD(src_file).
       worksheet = excelapp:worksheets(sheetname).
       
       i = startline.

       /*so head information*/
       ASSIGN  sonbr =  worksheet:cells(i,1):TEXT 
                   cust = worksheet:cells(i,2):TEXT 
                   sopo = worksheet:cells(i,4):TEXT
                   rmks = worksheet:cells(i,5):TEXT 
                   pricelist = worksheet:cells(i,6):TEXT 
                   site = worksheet:cells(i,7):text
                   channel = worksheet:cells(i,8):TEXT 
                   promoter = worksheet:cells(i,9):TEXT.
       FIND FIRST ad_mstr WHERE ad_type = "customer" AND ad_addr = cust NO-LOCK NO-ERROR.
       IF NOT AVAIL ad_mstr THEN DO:
           worksheet:Range("Z" + STRING(i)):VALUE = "客户不存在！".
           isvalid = NO.
       END.
       IF channel <> "dfm" THEN DO:
           worksheet:Range("Z" + STRING(i)):VALUE = "通道必须为dfm！".
           isvalid = NO.
       END.

       IF sonbr = "" THEN DO:
           FIND FIRST soc_ctrl NO-LOCK NO-ERROR.
           sonbr = soc_so_pre + string(soc_so).
           isnewso = YES.
       END.
       ELSE DO:
           isnewso = NO.
       END.
                   


      REPEAT:    /*so input repeat*/
           ASSIGN  
                   lineno = INT (worksheet:cells(i,10):TEXT) 
                   part = worksheet:cells(i,11):TEXT  
                   amount = worksheet:cells(i,17):TEXT
                   ischeck1 = worksheet:cells(i,3):TEXT
                   ischeck2 = worksheet:cells(i,13):TEXT
                  /* ischeck3 = worksheet:cells(i,14):TEXT  */
                   ischeck4 = worksheet:cells(i,17):TEXT
                   ischeck5 = worksheet:cells(i,18):TEXT
                   ischeck6 = worksheet:cells(i,19):TEXT
                   ischeck7 = worksheet:cells(i,20):TEXT
                   ischeck8 = worksheet:cells(i,21):TEXT
                   ischeck9 = worksheet:cells(i,22):TEXT
                   ischeck10 = worksheet:cells(i,23):TEXT
                   ischeck11 = worksheet:cells(i,24):TEXT
                   ischeck12 = worksheet:cells(i,25):TEXT.
           IF ischeck1 = "" THEN confirm = NO.
           IF ischeck2 = "" THEN confirm = NO.
         /*  IF ischeck3 = "" THEN confirm = NO. */
           IF ischeck4 = "" THEN confirm = NO.
           IF ischeck5 = "" THEN confirm = NO.
           IF ischeck6 = "" THEN confirm = NO.
           IF ischeck7 = "" THEN confirm = NO.
           IF ischeck8 = "" THEN confirm = NO.
           IF ischeck9 = "" THEN confirm = NO.
           IF ischeck10 = "" THEN confirm = NO.
           IF ischeck11 = "" THEN confirm = NO.
           IF ischeck12 = "" THEN confirm = NO.

          
           IF amount = "" THEN DO:
               isvalid = NO.
               worksheet:Range("AB" + STRING(i)):VALUE = "实际需求量不能为空！".
           END.
           CREATE soline_det.
           ASSIGN
               soline_mfguser = mfguser
               soline_line = lineno
               soline_part = part
               soline_qty = int(amount)
               soline_index = i.
              
           FIND FIRST sod_det WHERE sod_line = lineno AND sod_nbr = sonbr NO-LOCK NO-ERROR.
           IF AVAIL sod_det THEN
               soline_isnew = NO.
           ELSE
               soline_isnew = YES.
           RELEASE soline_det.

          
           
           i = i + 1 .
           endrowmark = worksheet:cells(i,2):TEXT  .

             IF endrowmark = ""  THEN DO:
                
                LEAVE .
             END.                       
      END.  /*repeat*/
   

      /*comfirming if not checked*/
      IF confirm = NO THEN
         MESSAGE "文件可能还未进行检测,是否继续导入?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE conf-yn.
      IF conf-yn <> YES THEN UNDO,RETRY.
      
IF isvalid THEN DO:


      /*creating cim format*/
       OUTPUT STREAM cim TO VALUE(cim_file) NO-ECHO .
  
    /************************************************************/
         PUT STREAM cim UNFORMATTED  "@@BATCHLOAD yysosomt.p" SKIP. 
         IF isnewso THEN
              PUT STREAM cim UNFORMATTED "-" SKIP.
         ELSE
              PUT STREAM cim UNFORMATTED """" sonbr """" SKIP.
         PUT STREAM cim UNFORMATTED """" cust """" SKIP.
         PUT STREAM cim UNFORMATTED "-" SKIP.
         PUT STREAM cim UNFORMATTED "-" SKIP.
         IF isnewso THEN
             PUT STREAM cim UNFORMATTED "- " "- " "- " "- " "- " "- " "- " "- " "- " """" pricelist """" " "  """" site """" " dfm " "- " "- " "- " "- " "- " "- " "- " "- " "-" SKIP.
         ELSE 
             PUT STREAM cim UNFORMATTED "- " "- " "- " "- " "- " "- " """" sopo """" " " """" rmks """" " - " """" pricelist """" " "  """" site """" " dfm " "- " "- " "- " "- " "- " "- " "- " "- " "-" SKIP.
         PUT STREAM cim UNFORMATTED  "- " "- " "- " """" "Y" """"  " " """" "Y" """" SKIP.
         PUT STREAM cim UNFORMATTED promoter " - " "- " "- " "- " "- " "- " "- " "- " "- " "- " "- " "-" SKIP.
         FOR EACH soline_det WHERE soline_mfguser = mfguser NO-LOCK :
            PUT STREAM cim UNFORMATTED soline_line SKIP.
            IF soline_isnew THEN DO:
                PUT STREAM cim UNFORMATTED """" soline_part """" SKIP.
                PUT STREAM cim UNFORMATTED soline_qty " -" SKIP.
            END.
            IF NOT soline_isnew THEN DO:
                PUT STREAM cim UNFORMATTED soline_qty " -" SKIP.
            END.
         END.
         PUT STREAM cim UNFORMATTED "." SKIP.
         PUT STREAM cim UNFORMATTED "." SKIP.
         PUT STREAM cim UNFORMATTED "-" SKIP.
         PUT STREAM cim UNFORMATTED "-" SKIP.
         PUT STREAM cim UNFORMATTED "@@end" SKIP.
         

    /************************************************************/
    OUTPUT STREAM cim CLOSE .
    
     /*loading*/
    {gprun.i ""yymgbdld.p"" 
        "(input cim_file,
          output fid,
          output tid)"}


    {gprun.i ""yymgbdpro.p"" 
        "(input fid,
          input tid,
          input lg_file,
          OUTPUT err)"}

    OS-DELETE VALUE(cim_file).
  
    IF isnewso THEN DO:
        REPEAT j = startline TO i - 1:
            worksheet:Range("A" + STRING(j)):VALUE = sonbr.
        END.
    END.
    
    FOR EACH soline_det WHERE soline_mfguser = mfguser NO-LOCK:
        FIND FIRST sod_det WHERE sod_nbr = sonbr AND sod_line = soline_line NO-LOCK NO-ERROR.
        IF AVAIL sod_det THEN DO:
            worksheet:Range("Z" + STRING(soline_index)):VALUE = sod_price.
            worksheet:Range("AA" + STRING(soline_index)):VALUE = sod_price * soline_qty.
        END.
        FIND FIRST in_mstr WHERE in_part = soline_part AND in_site = "dcec-b" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:
               worksheet:Range("R" + STRING(soline_index)):VALUE = in_qty_oh. 
           END.
           ELSE DO:
               worksheet:Range("R" + STRING(soline_index)):VALUE = "库存信息不存在！". 
           END.

           FIND FIRST in_mstr WHERE in_part = soline_part AND in_site = "dcec-c" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:
               worksheet:Range("S" + STRING(soline_index)):VALUE = in_qty_oh. 
           END.
           ELSE DO:
               worksheet:Range("S" + STRING(soline_index)):VALUE = "库存信息不存在！". 
           END.

           FIND FIRST in_mstr WHERE in_part = soline_part AND in_site = "dcec-sv" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:
               worksheet:Range("T" + STRING(soline_index)):VALUE = in_qty_oh. 
           END.
           ELSE DO:
               worksheet:Range("T" + STRING(soline_index)):VALUE = "库存信息不存在！". 
           END.

           FIND FIRST in_mstr WHERE in_part = soline_part AND in_site = "CEBJ" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:
               worksheet:Range("W" + STRING(soline_index)):VALUE = in_qty_oh. 
           END.
           ELSE DO:
               worksheet:Range("W" + STRING(soline_index)):VALUE = "库存信息不存在！". 
           END.

           FIND FIRST in_mstr  WHERE in_part = soline_part
               AND in_site = "dcec-sv" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:      
              worksheet:Range("U" + STRING(soline_index)):VALUE = in_qty_ord. 
              worksheet:Range("V" + STRING(soline_index)):VALUE = in_qty_ord + in_qty_oh - in_qty_req. 
           END.
           ELSE DO:
              worksheet:Range("U" + STRING(soline_index)):VALUE = "库存信息不存在！". 
              worksheet:Range("V" + STRING(soline_index)):VALUE = "库存信息不存在！".
           END.

           FIND FIRST in_mstr  WHERE in_part = soline_part
               AND in_site = "CEBJ" NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:      
              worksheet:Range("X" + STRING(soline_index)):VALUE = in_qty_ord. 
              worksheet:Range("Y" + STRING(soline_index)):VALUE = in_qty_ord + in_qty_oh - in_qty_req. 
           END.
           ELSE DO:
              worksheet:Range("X" + STRING(soline_index)):VALUE = "库存信息不存在！". 
              worksheet:Range("Y" + STRING(soline_index)):VALUE = "库存信息不存在！".
           END.

    END.
    
    
    END. /*if the data is valid*/
    
    excelworkbook:saveas(src_file , , , , , , 1) . 
    excelapp:VISIBLE = FALSE .
    excelworkbook:CLOSE(FALSE).
    excelapp:QUIT.
    RELEASE OBJECT excelapp.
    RELEASE OBJECT excelworkbook.
    RELEASE OBJECT worksheet.
    IF NOT isvalid THEN
        MESSAGE "导入失败，文件内容不正确!" VIEW-AS ALERT-BOX .
    ELSE
        MESSAGE "导入成功!" VIEW-AS ALERT-BOX .   
 END. /*do transaction*/
END. 

