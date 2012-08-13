/*yyldicunrc.p designed by Philips Li for icrc-loading by excel           03/31/08*/
{mfdtitle.i "e+"}

DEFINE VARIABLE src_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE lg_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE cim_file AS CHAR FORMAT "x(40)" INIT "c:\appeb2\mywrk\icrcloading.cim".

DEF VAR startline AS INT LABEL "数据开始行" INIT 6.
DEF VAR conf-yn AS LOGICAL.
DEF VAR i AS INT.
DEF VAR fid AS INT.
DEF VAR tid AS INT.
DEF VAR err AS INT.
DEF VAR endrowmark AS CHARACTER.
DEF VAR isvalid AS LOG.
DEF VAR isvalidline AS LOG.

DEF STREAM cim.
DEF VAR start_flag AS CHAR format "x(80)" .

DEFINE VARIABLE excelapp AS COM-HANDLE.
DEFINE VARIABLE excelworkbook AS COM-HANDLE.
DEFINE VARIABLE worksheet AS COM-HANDLE.  

/*temp table for line data*/
DEFINE TEMP-TABLE yyicrc_mstr
    FIELD yyicrc_mfguser LIKE mfguser
    FIELD yyicrc_part LIKE pt_part
    FIELD yyicrc_qty LIKE ld_qty_all
    FIELD yyicrc_um LIKE pt_um
    FIELD yyicrc_site LIKE ld_site
    FIELD yyicrc_loc LIKE ld_loc
    FIELD yyicrc_job AS CHAR FORMAT "x(10)"
    FIELD yyicrc_order AS CHAR FORMAT "x(18)"
    FIELD yyicrc_addr AS CHAR FORMAT "x(40)"
    FIELD yyicrc_rmk AS CHAR FORMAT "x(40)"
    FIELD yyicrc_effdate AS DATE.
 
 
FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /*tfq site colon 22 sidesc no-label skip(1) */
 src_file COLON 22 LABEL "导入文件"
 lg_file COLON 22 LABEL "日志文件"
 startline COLON 22  LABEL "数据开始行"  SKIP(1) 
   "** 模板格式不允许合并单元格，以空行结束，不允许改变列的位置，数据必须放在sheet1**"       AT 5 SKIP
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
  
   
     
     IF src_file = "" THEN src_file = "c:\icrc.xls".
     IF lg_file = "" THEN lg_file = "d:\icrcloading.lg".
     isvalid = YES.

     FOR EACH yyicrc_mstr WHERE yyicrc_mfguser = mfguser:
          DELETE yyicrc_mstr.
     END.

      UPDATE src_file lg_file startline VALIDATE(INPUT startline > 0 ,"行号小于等于零是不允许的")  with frame a.
       
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
       
     


       CREATE "Excel.Application" excelapp.
       excelworkbook = excelapp:workbooks:ADD(src_file).
       worksheet = excelapp:worksheets("sheet1").
       worksheet:Columns("H"):ColumnWidth = 24.
       i = startline.                   


      REPEAT:    /*input repeat*/
          isvalidline = YES.
          CREATE yyicrc_mstr.
           ASSIGN 
               yyicrc_mfguser = mfguser
               yyicrc_part =  worksheet:cells(i,1):TEXT 
               yyicrc_qty = DECIMAL(worksheet:cells(i,2):TEXT) 
               yyicrc_site = worksheet:cells(i,3):TEXT
               yyicrc_job = worksheet:cells(i,4):TEXT
               yyicrc_order = worksheet:cells(i,5):TEXT 
               yyicrc_rmk = worksheet:cells(i,6):TEXT 
               yyicrc_effdate = DATE(worksheet:cells(i,7):TEXT) . 
     
          
        
           /*data checking*/

           /*part not exist in pt_mstr*/
           FIND FIRST pt_mstr WHERE pt_part = yyicrc_part NO-LOCK NO-ERROR.
           IF NOT AVAIL pt_mstr THEN DO:
               worksheet:Range("H" + STRING(i)):VALUE = "零件号不在pt_mstr中！".
               isvalid = NO.
               isvalidline = NO.
           END.

                 
           /*site checking*/
           IF isvalidline THEN DO:        
               FIND FIRST si_mstr WHERE si_site = yyicrc_site NO-LOCK NO-ERROR.
               IF NOT AVAIL si_mstr THEN DO:
                   worksheet:Range("H" + STRING(i)):VALUE = "地点不存在！".
                   isvalid = NO.
                   isvalidline = NO.
               END.
           END.


           FIND FIRST in_mstr WHERE in_site = yyicrc_site AND in_part = yyicrc_part NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:
               IF in_user1 = "" THEN
                   yyicrc_loc = "temp".
               ELSE
                   yyicrc_loc = in_user1.  
           END.
          
           /*location checking*/
           IF isvalidline THEN DO:  
               FIND FIRST loc_mstr WHERE loc_site = yyicrc_site  AND loc_loc = yyicrc_loc NO-LOCK NO-ERROR.
               IF NOT AVAIL loc_mstr THEN DO:
                   worksheet:Range("H" + STRING(i)):VALUE = "temp库位不存在！".
                   isvalid = NO.
                   isvalidline = NO.
               END.
           END.


           /*over issue checking*/
           IF isvalidline THEN DO:
              FIND FIRST ld_det NO-LOCK WHERE ld_site = yyicrc_site
		             and ld_part = yyicrc_part AND ld_loc = yyicrc_loc no-error no-wait.
              IF AVAIL ld_det  THEN DO:
                  FIND FIRST is_mstr NO-LOCK WHERE IS_status = ld_status NO-ERROR no-wait.
                  IF AVAIL IS_mstr  THEN DO:
                     IF  is_overissue = no and yyicrc_qty < 0 - ld_qty_oh THEN DO:
                         worksheet:Range("H" + STRING(i)):VALUE = "不允许过量发放！".
                          isvalidline = NO.
                          isvalid = NO.
                     END.
                  END.  /*if avail is_mstr*/
              END.  /*if avail ld_det*/
           END.

            /*so_job checking*/
           IF isvalidline THEN DO:
               isvalidline = NO.
               FOR EACH code_mstr WHERE code_fldname = "so_job" NO-LOCK:
                   IF code_value = yyicrc_job THEN DO:
                       isvalidline = YES.
                   END.
               END. 
               IF NOT isvalidline OR yyicrc_job = "" THEN DO:
                   worksheet:Range("H" + STRING(i)):VALUE = "客户单/工作必须在通用代码中维护且不能为空！！" .
               END.
           END.

            /*accounting period checking*/
           IF isvalidline THEN DO:
               FIND FIRST si_mstr WHERE si_site = yyicrc_site NO-ERROR.
               {glcabmeg.i}  /* independent-module-close engine include */
               find first glc_cal no-lock where glc_start <= yyicrc_effdate AND glc_end >= yyicrc_effdate no-error.
               find glcd_det no-lock where glcd_year = glc_year AND glcd_per = glc_per AND glcd_entity = si_entity no-error.
               find en_mstr where en_entity = glcd_entity no-lock no-error.
               {glcabmsv.i
                  &service = FIND_MODULE_DETAIL
                  &fyear   = glc_year
                  &fper    = glc_per
                  &entity  = en_entity}         
               IF glcd_ic_clsd = YES THEN DO:
                   worksheet:Range("H" + STRING(i)):VALUE = "会计期间已关闭！".
                   isvalid = NO.
                   isvalidline = NO.
               END.
            END.




                RELEASE yyicrc_mstr.
           i = i + 1 .
           endrowmark = worksheet:cells(i,1):TEXT  .

             IF endrowmark = ""  THEN DO:    
                LEAVE .
             END.                       
      END.  /*repeat*/
   
      
    
IF isvalid = YES THEN DO:
   
      /*creating cim format*/
       OUTPUT STREAM cim TO VALUE(cim_file) NO-ECHO .
  
    /************************************************************/
       FOR EACH yyicrc_mstr WHERE yyicrc_mfguser = mfguser NO-LOCK: 
         PUT STREAM cim UNFORMATTED  "@@BATCHLOAD yyicunrc.p" SKIP. 
         PUT STREAM cim UNFORMATTED """" yyicrc_part """" SKIP.
         PUT STREAM cim UNFORMATTED yyicrc_qty " " "- " "- " """" yyicrc_site """" " " """" yyicrc_loc """" " - " "- " "- " """" yyicrc_job """" SKIP.
         PUT STREAM cim UNFORMATTED """" yyicrc_order """" " - " "- " """" yyicrc_rmk """" " " yyicrc_effdate " - " "- " "- " "-" SKIP.
         PUT STREAM cim UNFORMATTED "-" SKIP.
         PUT STREAM cim UNFORMATTED "@@end" SKIP.
       END.  

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
    END. /*if the data is valid*/
    
    excelworkbook:saveas(src_file , , , , , , 1) . 
    excelapp:VISIBLE = FALSE .
    excelworkbook:CLOSE(FALSE).
    excelapp:QUIT.
    RELEASE OBJECT excelapp.
    RELEASE OBJECT excelworkbook.
    RELEASE OBJECT worksheet.
    IF NOT isvalid THEN
        MESSAGE "批量导入失败，数据有错误!" VIEW-AS ALERT-BOX .
    ELSE
        MESSAGE "批量导入成功!" VIEW-AS ALERT-BOX .   
 END. /*do transaction*/
END. 

