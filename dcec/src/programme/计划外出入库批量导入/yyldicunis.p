/*yyldicunis.p designed by Philips Li for icis-loading by excel           01/04/08*/
{mfdtitle.i "e+"}

DEFINE VARIABLE src_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE lg_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE cim_file AS CHAR FORMAT "x(40)" INIT "c:\appeb2\mywrk\icisloading.cim".

DEF VAR startline AS INT LABEL "���ݿ�ʼ��" INIT 6.
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
DEFINE TEMP-TABLE yyicis_mstr
    FIELD yyicis_mfguser LIKE mfguser
    FIELD yyicis_part LIKE pt_part
    FIELD yyicis_qty LIKE ld_qty_all
    FIELD yyicis_um LIKE pt_um
    FIELD yyicis_site LIKE ld_site
    FIELD yyicis_loc LIKE ld_loc
    FIELD yyicis_job AS CHAR FORMAT "x(10)"
    FIELD yyicis_order AS CHAR FORMAT "x(18)"
    FIELD yyicis_addr AS CHAR FORMAT "x(40)"
    FIELD yyicis_rmk AS CHAR FORMAT "x(40)"
    FIELD yyicis_effdate AS DATE.
 
 
FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /*tfq site colon 22 sidesc no-label skip(1) */
 src_file COLON 22 LABEL "�����ļ�"
 lg_file COLON 22 LABEL "��־�ļ�"
 startline COLON 22  LABEL "���ݿ�ʼ��"  SKIP(1) 
   "** ģ���ʽ������ϲ���Ԫ���Կ��н�����������ı��е�λ�ã����ݱ������sheet1**"       AT 5 SKIP
   "** �������֮ǰ������excel�򿪵����ļ�**  "  AT 5 SKIP
          
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
  
   
     
     IF src_file = "" THEN src_file = "c:\icis.xls".
     IF lg_file = "" THEN lg_file = "d:\icisloading.lg".
     isvalid = YES.

     FOR EACH yyicis_mstr WHERE yyicis_mfguser = mfguser:
          DELETE yyicis_mstr.
     END.

      UPDATE src_file lg_file startline VALIDATE(INPUT startline > 0 ,"�к�С�ڵ������ǲ������")  with frame a.
       
       IF SEARCH(src_file) = ? THEN DO:
            MESSAGE "����:�����ļ�������,����������!" VIEW-AS ALERT-BOX ERROR.
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
       MESSAGE "ȷ�ϵ���" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE conf-yn.
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
          CREATE yyicis_mstr.
           ASSIGN 
               yyicis_mfguser = mfguser
               yyicis_part =  worksheet:cells(i,1):TEXT 
               yyicis_qty = DECIMAL(worksheet:cells(i,2):TEXT) 
               yyicis_site = worksheet:cells(i,3):TEXT
               yyicis_job = worksheet:cells(i,4):TEXT
               yyicis_order = worksheet:cells(i,5):TEXT 
               yyicis_rmk = worksheet:cells(i,6):TEXT 
               yyicis_effdate = DATE(worksheet:cells(i,7):TEXT) . 
          
        
           /*data checking*/

           /*part not exist in pt_mstr*/
           FIND FIRST pt_mstr WHERE pt_part = yyicis_part NO-LOCK NO-ERROR.
           IF NOT AVAIL pt_mstr THEN DO:
               worksheet:Range("H" + STRING(i)):VALUE = "����Ų���pt_mstr�У�".
               isvalid = NO.
               isvalidline = NO.
           END.

           /*site checking*/
           IF isvalidline THEN DO:        
               FIND FIRST si_mstr WHERE si_site = yyicis_site NO-LOCK NO-ERROR.
               IF NOT AVAIL si_mstr THEN DO:
                   worksheet:Range("H" + STRING(i)):VALUE = "�ص㲻���ڣ�".
                   isvalid = NO.
                   isvalidline = NO.
               END.
           END.


           FIND FIRST in_mstr WHERE in_site = yyicis_site AND in_part = yyicis_part NO-LOCK NO-ERROR.
           IF AVAIL in_mstr THEN DO:
               IF in_user1 = "" THEN
                   yyicis_loc = "temp".
               ELSE
                   yyicis_loc = in_user1.  
           END.
           /*location checking*/
           IF isvalidline THEN DO:  
               FIND FIRST loc_mstr WHERE loc_site = yyicis_site  AND loc_loc = yyicis_loc NO-LOCK NO-ERROR.
               IF NOT AVAIL loc_mstr THEN DO:
                   worksheet:Range("H" + STRING(i)):VALUE = "��λ�����ڣ�".
                   isvalid = NO.
                   isvalidline = NO.
               END.
           END.


           /*over issue checking*/
           IF isvalidline THEN DO:
              FIND FIRST ld_det NO-LOCK WHERE ld_site = yyicis_site
		             and ld_part = yyicis_part AND ld_loc = yyicis_loc no-error no-wait.
              IF AVAIL ld_det  THEN DO:
                  FIND FIRST is_mstr NO-LOCK WHERE IS_status = ld_status NO-ERROR no-wait.
                  IF AVAIL IS_mstr  THEN DO:
                     IF  is_overissue = no and yyicis_qty > ld_qty_oh THEN DO:
                         worksheet:Range("H" + STRING(i)):VALUE = "������������ţ�".
                          isvalidline = NO.
                          isvalid = NO.
                     END.
                  END.  /*if avail is_mstr*/
              END.  /*if avail ld_det*/
              ELSE 
                  worksheet:Range("H" + STRING(i)):VALUE = "������������ţ�".
           END.

            /*so_job checking*/
           IF isvalidline THEN DO:
               isvalidline = NO.
               FOR EACH code_mstr WHERE code_fldname = "so_job" NO-LOCK:
                   IF code_value = yyicis_job THEN DO:
                       isvalidline = YES.
                   END.
               END. 
               IF NOT isvalidline OR yyicis_job = "" THEN DO:
                   worksheet:Range("H" + STRING(i)):VALUE = "�ͻ���/����������ͨ�ô�����ά���Ҳ���Ϊ�գ���" .
               END.
           END.

            /*accounting period checking*/
           IF isvalidline THEN DO:
               FIND FIRST si_mstr WHERE si_site = yyicis_site NO-ERROR.
               {glcabmeg.i}  /* independent-module-close engine include */
               find first glc_cal no-lock where glc_start <= yyicis_effdate AND glc_end >= yyicis_effdate no-error.
               find glcd_det no-lock where glcd_year = glc_year AND glcd_per = glc_per AND glcd_entity = si_entity no-error.
               find en_mstr where en_entity = glcd_entity no-lock no-error.
               {glcabmsv.i
                  &service = FIND_MODULE_DETAIL
                  &fyear   = glc_year
                  &fper    = glc_per
                  &entity  = en_entity}         
               IF glcd_ic_clsd = YES THEN DO:
                   worksheet:Range("K" + STRING(i)):VALUE = "����ڼ��ѹرգ�".
                   isvalid = NO.
                   isvalidline = NO.
               END.
            END.




                RELEASE yyicis_mstr.
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
       FOR EACH yyicis_mstr WHERE yyicis_mfguser = mfguser NO-LOCK: 
         PUT STREAM cim UNFORMATTED  "@@BATCHLOAD yyicunis.p" SKIP. 
         PUT STREAM cim UNFORMATTED """" yyicis_part """" SKIP.
         PUT STREAM cim UNFORMATTED yyicis_qty " " "- " "- " """" yyicis_site """" " " """" yyicis_loc """" " - " "- " "- " """" yyicis_job """" SKIP.
         PUT STREAM cim UNFORMATTED """" yyicis_order """" " - " "- " """" yyicis_rmk """" " " yyicis_effdate " - " "- " "- " "-" SKIP.
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
        MESSAGE "��������ʧ�ܣ������д���!" VIEW-AS ALERT-BOX .
    ELSE
        MESSAGE "��������ɹ�!" VIEW-AS ALERT-BOX .   
 END. /*do transaction*/
END. 

