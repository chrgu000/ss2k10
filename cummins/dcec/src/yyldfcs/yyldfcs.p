/*yyldfc.p designed by Philips Li for forecast-loading by excel           03/31/08*/
/*Last Modified by Philips Li              eco:phi002               04/29/08  */
/*Last Modified by Philips Li              eco:phi003               05/06/08  */
{mfdtitle.i "120816.1"}

DEFINE VARIABLE src_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE lg_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE cim_file AS CHAR FORMAT "x(40)".
DEFINE VARIABLE j AS INT NO-UNDO.
DEFINE VARIABLE START LIKE ro_start EXTENT 52 NO-UNDO.
DEFINE VARIABLE colnum AS INT.
DEFINE VARIABLE part LIKE pt_part.
DEFINE VARIABLE site LIKE si_site.

DEF VAR startline AS INT LABEL "数据开始行" INIT 3.
DEF VAR conf-yn AS LOGICAL.
DEF VAR i AS INT.
DEF VAR k AS INT.
/*phi002*/ DEF VAR l AS INT.
/*phi002*/ DEF VAR m AS INT.
/*phi002*/ DEF VAR w AS INT.
/*phi002*/ DEF VAR msum AS INT.
/*phi002*/ DEF VAR wsum AS INT.
/*phi002*/ DEF VAR lwsum AS INT.
DEF VAR fid AS INT.
DEF VAR tid AS INT.
DEF VAR err AS INT.
DEF VAR endrowmark AS CHARACTER.
DEF VAR isvalid AS LOG.
DEF VAR isvalidline AS LOG.
DEF VAR year1 AS INT.
DEF VAR year2 AS INT.
DEF VAR year1end AS INT INIT 0.
DEF VAR year2end AS INT INIT 0.
DEF VAR istwoyears AS LOGICAL.
DEF VAR yea AS INT.

DEF STREAM cim.
DEF VAR start_flag AS CHAR format "x(80)" .

DEFINE VARIABLE excelapp AS COM-HANDLE.
DEFINE VARIABLE excelworkbook AS COM-HANDLE.
DEFINE VARIABLE worksheet AS COM-HANDLE.  

/*temp table for line data*/
DEFINE TEMP-TABLE yyfcs_mstr
    FIELD yyfcs_mfguser LIKE mfguser
    FIELD yyfcs_site LIKE si_site
    FIELD yyfcs_part LIKE pt_part
    FIELD yyfcs_fcst1 LIKE fcs_fcst_qty EXTENT 52
    FIELD yyfcs_fcst2 LIKE fcs_fcst_qty EXTENT 52.
/*temp table for month*/
DEFINE TEMP-TABLE yyhlp_mstr
    FIELD yyhlp_mfguser LIKE mfguser
    FIELD yyhlp_year AS INT
    FIELD yyhlp_month AS INT
    FIELD yyhlp_colno AS INT.

 
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
     IF src_file = "" THEN src_file = "c:\fcsld.xls".
     IF lg_file = "" THEN lg_file = "d:\fcsld.lg".
     isvalid = YES.
     istwoyears = NO.
     FOR EACH yyfcs_mstr WHERE yyfcs_mfguser = mfguser:
         DELETE yyfcs_mstr.
     END.

     FOR EACH yyhlp_mstr WHERE yyhlp_mfguser = mfguser:
         DELETE yyhlp_mstr.
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
       
     

       FOR EACH fcs_sum exclusive-lock where fcs_domain = global_domain:
           DELETE fcs_sum.
       END.
       CREATE "Excel.Application" excelapp.
       excelworkbook = excelapp:workbooks:ADD(src_file).
       worksheet = excelapp:worksheets("sheet1").
       i = startline. 

       colnum = 0.
       REPEAT:
           colnum = colnum + 1.
           IF (TRIM(worksheet:cells(i - 1,colnum):TEXT)) = "Total" THEN LEAVE.
           IF colnum = 25 THEN DO:
               MESSAGE "导入失败，找不到终止标记TOTAL,请检查起始行！  " VIEW-AS ALERT-BOX .
               UNDO mainloop, RETRY mainloop.
           END.
       END.
       
       year2end = colnum - 1.
       year1 = INT(SUBSTRING(TRIM(worksheet:cells(i - 1,3):TEXT),4,2)).
     
       year2 = INT(SUBSTRING(TRIM(worksheet:cells(i - 1,year2end):TEXT),4,2)).
       IF year1 = year2 THEN DO: 
           year1end = year2end.
           istwoyears = NO.
       END.
       ELSE DO:
           istwoyears = YES.
           REPEAT j = 3 TO year2end:
               IF INT(SUBSTRING(TRIM(worksheet:cells(i - 1,j):TEXT),4,2)) <> year1 THEN DO:
                   year1end = j - 1.
                   LEAVE.
               END.
           END.
       END.

       /*initialize yyhlp_mstr*/
       REPEAT j = 3 TO year1end:
           CREATE yyhlp_mstr.
           assign
               yyhlp_mfguser = mfguser
               yyhlp_colno = j
               yyhlp_year = INT(SUBSTRING(TRIM(worksheet:cells(i - 1,j):TEXT),4,2))
               yyhlp_month = INT(SUBSTRING(TRIM(worksheet:cells(i - 1,j):TEXT),1,2)).
           RELEASE yyhlp_mstr.
       END.

       IF istwoyears THEN DO:
           REPEAT j = year1end + 1 TO year2end:
           CREATE yyhlp_mstr.
               assign
               yyhlp_mfguser = mfguser
               yyhlp_colno = j
               yyhlp_year = INT(SUBSTRING(TRIM(worksheet:cells(i - 1,j):TEXT),4,2))
               yyhlp_month = INT(SUBSTRING(TRIM(worksheet:cells(i - 1,j):TEXT),1,2)).
           RELEASE yyhlp_mstr.
           END.
       END.


       REPEAT:    /*input repeat*/
          isvalidline = YES.
          site = TRIM(worksheet:cells(i,1):TEXT). 
          part = TRIM(worksheet:cells(i,2):TEXT).
          FIND FIRST yyfcs_mstr WHERE yyfcs_site = site
              AND yyfcs_part = part NO-LOCK NO-ERROR.
          IF NOT AVAIL yyfcs_mstr THEN DO:
       
              CREATE yyfcs_mstr.
          yyfcs_mfguser = mfguser.
          REPEAT j = 1 TO 52:
              yyfcs_fcst1[j] = 0.
              yyfcs_fcst2[j] = 0.
          END.
          ASSIGN 
              yyfcs_site = TRIM(worksheet:cells(i,1):TEXT) 
              yyfcs_part = TRIM(worksheet:cells(i,2):TEXT).
          END.
          


            /*data checking*/

           /*site checking*/                
          FIND FIRST si_mstr WHERE si_domain = global_domain 
          			 and si_site = yyfcs_site NO-LOCK NO-ERROR.
          IF NOT AVAIL si_mstr THEN DO:
              worksheet:Range(CHR(65 + colnum) + STRING(i)):VALUE = "地点不存在！". 
              isvalid = NO.
              isvalidline = NO.
          END.
           

           /*part not exist in pt_mstr*/
           IF isvalidline = YES THEN DO: 
               FIND FIRST pt_mstr WHERE pt_domain = global_domain 
               				and pt_part = yyfcs_part NO-LOCK NO-ERROR.
                  IF NOT AVAIL pt_mstr THEN DO:
                  worksheet:Range(CHR(65 + colnum) + STRING(i)):VALUE = "零件号不在pt_mstr中！". 
                  isvalid = NO.
                  isvalidline = NO.
                  END.
           END.
           

           /*part state checking*/
           IF isvalidline THEN DO:  
              FIND FIRST pt_mstr WHERE pt_domain = global_domain 
              			 and pt_part = yyfcs_part NO-LOCK NO-ERROR.
              IF AVAIL pt_mstr THEN DO:
                  FIND FIRST isd_det WHERE isd_domain = global_domain 
                  			 and isd_status MATCHES pt_status + "*" 
                                     AND isd_tr_type = "add-fc" NO-LOCK NO-ERROR.
                  IF AVAIL isd_det THEN DO:
                      worksheet:Range(CHR(65 + colnum) + STRING(i)):VALUE = "该零件状态不允许预进行测操作！". 
                      isvalid = NO.
                      isvalidline = NO.
                  END.
              END.
           END.

            

           IF isvalidline THEN DO:
          REPEAT j = 3 TO year1end:
              FIND FIRST yyhlp_mstr WHERE yyhlp_mfguser = mfguser AND yyhlp_colno = j NO-LOCK NO-ERROR.
              IF AVAIL yyhlp_mstr THEN DO:
                  yea = 2000 + yyhlp_year.
                  
       /* CALCULATE START DATE OF FORECAST YEAR */
              {fcsdate1.i yea start[1]}
               REPEAT k = 2 TO 52:
                  start[k] = start[k - 1] + 7.
                  IF MONTH(START[k]) = yyhlp_month THEN DO:
/*phi002*/                     REPEAT l = k TO 52:
/*phi002*/                     start[l] = start[l - 1] + 7.
/*phi002*/                     IF MONTH (START[l]) = yyhlp_month + 1 THEN
/*phi002*/                         LEAVE.
/*phi002*/                     END.
                      LEAVE.
                  END.
               END.
/*phi002*/               w = l - k.
               
               IF worksheet:cells(i,j):TEXT = "" THEN
                   ASSIGN 
                   yyfcs_fcst1[k] = 0.
               ELSE DO: 
/*phi002*/                 msum = 0.
/*phi002                   yyfcs_fcst1[k] = yyfcs_fcst1[k] + INT(TRIM(worksheet:cells(i,j):TEXT)). */
/*phi002*/                 REPEAT m = k TO k + w - 1:
/*phi002*/                     msum = msum + yyfcs_fcst1[m].
/*phi002*/                 END.
/*phi002*/                 msum = msum + INT(TRIM(worksheet:cells(i,j):TEXT)).
/*phi002*/                 wsum = INT(msum / w - 0.5).
/*phi002*/                 lwsum = msum - wsum * w + wsum.
/*phi003*/                 IF msum = 0 THEN DO:
/*phi003*/                    wsum = 0.
/*phi003*/                    lwsum = 0.
/*phi003*/                 END.
/*phi002*/                 REPEAT m = k TO k + w - 1:
/*phi002*/                     IF m = k + w - 1 THEN
/*phi002*/                          yyfcs_fcst1[m] = lwsum.
/*phi002*/                     ELSE
/*phi002*/                          yyfcs_fcst1[m] = wsum.
/*phi002*/                 END.
               END.
               IF yea <= YEAR(TODAY) THEN DO:
                   IF yyhlp_month <= MONTH(TODAY) THEN DO:
/*phi002*/                 REPEAT m = k TO k + w - 1:
                              yyfcs_fcst1[m] = 0.
/*phi002*/                 END.               
          
                   END.
               END.
              END.
          END.

          IF istwoyears THEN DO:
              REPEAT j = year1end + 1 TO year2end:
              FIND FIRST yyhlp_mstr WHERE yyhlp_mfguser = mfguser AND yyhlp_colno = j NO-LOCK NO-ERROR.
              IF AVAIL yyhlp_mstr THEN DO:
                  yea = 2000 + yyhlp_year.
       /* CALCULATE START DATE OF FORECAST YEAR */
              {fcsdate1.i yea start[1]}
               REPEAT k = 2 TO 52:
                  start[k] = start[k - 1] + 7.
                  IF MONTH(START[k]) = yyhlp_month THEN
                      LEAVE.
               END.
               IF worksheet:cells(i,j):TEXT = "" THEN
                   ASSIGN 
                   yyfcs_fcst2[k] = 0.
               ELSE DO: 
/*phi002                   yyfcs_fcst2[k] = yyfcs_fcst2[k] + INT(TRIM(worksheet:cells(i,j):TEXT)).*/
/*phi002*/                 msum = 0.           
/*phi002*/                 REPEAT m = k TO k + w - 1:
/*phi002*/                     msum = msum + yyfcs_fcst2[m].
/*phi002*/                 END.
/*phi002*/                 msum = msum + INT(TRIM(worksheet:cells(i,j):TEXT)).
/*phi002*/                 wsum = INT(msum / w - 0.5).
/*phi002*/                 lwsum = msum - wsum * w + wsum.
/*phi003*/                 IF msum = 0 THEN DO:
/*phi003*/                    wsum = 0.
/*phi003*/                    lwsum = 0.
/*phi003*/                 END.
/*phi002*/                 REPEAT m = k TO k + w - 1:
/*phi002*/                     IF m = k + w - 1 THEN
/*phi002*/                          yyfcs_fcst2[m] = lwsum.
/*phi002*/                     ELSE
/*phi002*/                          yyfcs_fcst2[m] = wsum.
/*phi002*/                 END.
               END.
               IF yea <= YEAR(TODAY) THEN DO:
                   IF yyhlp_month <= MONTH(TODAY) THEN
/*phi002*/                 REPEAT m = k TO k + w - 1:
                              yyfcs_fcst2[m] = 0.
/*phi002*/                 END.               
          
               END.
              END.
          END.
          END.
            END.
          

           
         IF NOT isvalidline THEN  DELETE yyfcs_mstr.
         ELSE
           RELEASE yyfcs_mstr.
           i = i + 1 .
           endrowmark = worksheet:cells(i,1):TEXT  .

             IF endrowmark = ""  THEN DO:    
                LEAVE .
             END.                       
      END.  /*repeat*/
   
    
    
/*IF isvalid = YES THEN DO:*/
       year1 = year1 + 2000.
       year2 = year2 + 2000.
      /*creating cim format*/
       assign cim_file = "fcscimload".
       OUTPUT STREAM cim TO VALUE(cim_file) NO-ECHO .
  
    /************************************************************/
       FOR EACH yyfcs_mstr WHERE yyfcs_mfguser = mfguser NO-LOCK: 
/*         PUT STREAM cim UNFORMATTED  "@@BATCHLOAD fcfsmt01.p" SKIP.   */
         PUT STREAM cim UNFORMATTED """" yyfcs_part """"  " " """" yyfcs_site """" " " year1 SKIP.

         REPEAT k = 1 TO 52:
             IF yyfcs_fcst1[k] = 0 THEN
                 PUT STREAM cim UNFORMATTED "0 ".
             ELSE
                 PUT STREAM cim UNFORMATTED  yyfcs_fcst1[k] " ".
         END.
         PUT STREAM cim UNFORMATTED SKIP.
/*         PUT STREAM cim UNFORMATTED "@@end" SKIP.                         */
         IF istwoyears THEN DO:
/*           PUT STREAM cim UNFORMATTED  "@@BATCHLOAD fcfsmt01.p" SKIP.     */
             PUT STREAM cim UNFORMATTED """" yyfcs_part """"  " " """" yyfcs_site """" " " year2 SKIP.

             REPEAT k = 1 TO 52:
                 IF yyfcs_fcst2[k] = 0 THEN
                     PUT STREAM cim UNFORMATTED  "0 ".
                 ELSE
                     PUT STREAM cim UNFORMATTED yyfcs_fcst2[k] " ".
                 
             END.
             PUT STREAM cim UNFORMATTED SKIP.
/*             PUT STREAM cim UNFORMATTED "@@end" SKIP.     */
         END.
       END.  

    /************************************************************/
    OUTPUT STREAM cim CLOSE .
    
 batchrun = yes.
 input from value(cim_file).
 output to value(cim_file + ".bpo") keep-messages.
 hide message no-pause.
 cimrunprogramloop:
 do on stop undo cimrunprogramloop,leave cimrunprogramloop:
    {gprun.i ""fcfsmt01.p""}
 end.
 hide message no-pause.
 output close.
 input close.
 batchrun = no.
 
    
/*   
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
    
    OS-DELETE VALUE(cim_file) no-error.
    os-DELETE VALUE(cim_file + ".bpo") no-error.
 */   
    MESSAGE "导入成功!" VIEW-AS ALERT-BOX .
   /* END. /*if the data is valid*/
    ELSE 
         MESSAGE "导入失败，数据有错误！" VIEW-AS ALERT-BOX .
          */
    excelworkbook:saveas(src_file , , , , , , 1) . 
    excelapp:VISIBLE = FALSE .
    excelworkbook:CLOSE(FALSE).
    excelapp:QUIT.
    RELEASE OBJECT excelapp.
    RELEASE OBJECT excelworkbook.
    RELEASE OBJECT worksheet.
    
 END. /*do transaction*/
END. 

