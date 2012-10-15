/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/19/12  ECO: *SS-20120919.1*   */


{mfdtitle.i "120919.1"}




DEFINE VARIABLE v_site_to like ad_addr.
DEFINE VARIABLE v_req_date as DATE .
DEFINE VARIABLE v_trloc like pt_loc.
DEFINE VARIABLE v_path AS CHAR FORMAT "x(40)".
DEFINE VARIABLE v_site_from like ad_addr.
DEFINE VARIABLE v_end_date like DATE.
DEFINE VARIABLE v_max_line AS INT.
DEFINE VARIABLE v_sheet like INT.

define new shared  variable errstr as char no-undo .


DEF STREAM cim.
DEF VAR start_flag AS CHAR format "x(80)" .

DEFINE VARIABLE excelapp AS COM-HANDLE.
DEFINE VARIABLE excelworkbook AS COM-HANDLE.
DEFINE VARIABLE worksheet AS COM-HANDLE.  

/*temp table for line data*/
DEFINE new shared TEMP-TABLE tmp_det no-undo
    FIELD tmp_req_nbr LIKE drp_req_nbr   /*�����*/
    FIELD tmp_nbr LIKE dss_nbr
    FIELD tmp_part LIKE ds_part            /*�����*/
    FIELD tmp_qty_ord LIKE ds_qty_ord      /*����*/
    FIELD tmp_req_date LIKE dss_due_date  /*������*/
    FIELD tmp_due_date LIKE dss_due_date   /*��ֹ��*/
    FIELD tmp_rec_site LIKE dss_rec_site   /*�����*/
    FIELD tmp_shipsite LIKE dss_shipsite   /*���˵�*/
    FIELD tmp_trloc LIKE pt_loc           /*��;��λ*/
    FIELD tmp_xls_line LIKE drp_req_nbr   /*excel�к�*/  
    FIELD tmp_err char                    /*���뱨��*/  
     index tmp_index is primary tmp_req_nbr .

 
FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/

 v_site_to    COLON 12 LABEL "�����"
 v_site_from  COLON 60 LABEL "���˵�"    SKIP
 v_req_date   COLON 12 LABEL " ������"
 v_end_date   COLON 60 LABEL "��ֹ��"    SKIP
 v_trloc      COLON 12 LABEL " ��;��λ"
 v_max_line   COLON 60 LABEL "�����"    SKIP
 v_path       COLON 12 LABEL " �ļ�����"
 v_sheet      COLON 60 LABEL "������"       SKIP

   "ģ��ĸ�ʽΪ�������š�����š����� "  AT 10 SKIP
          
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

     isvalid = YES.
     istwoyears = NO.
     FOR EACH yyfcs_mstr WHERE yyfcs_mfguser = mfguser:
         DELETE yyfcs_mstr.
     END.

     FOR EACH yyhlp_mstr WHERE yyhlp_mfguser = mfguser:
         DELETE yyhlp_mstr.
     END.

      UPDATE  v_site_to    VALIDATE(INPUT v_site_to > "" ,"�����������")
	      v_site_from  VALIDATE(INPUT v_site_from > "" ,"�����뷢�˵�")
	      v_req_date   VALIDATE(INPUT v_site_to <> ? ,"������������")
	      v_end_date   VALIDATE(INPUT v_end_date <> ? ,"�������ֹ��")
	      v_trloc      VALIDATE(INPUT v_end_date > "" ,"��������;��λ")
	      v_max_line   VALIDATE(INPUT v_max_line > 1 ,"�к�С�ڵ���1�ǲ������")
      	      v_path       VALIDATE(INPUT v_end_date > "" ,"�������ļ�����")
      	      v_sheet     with frame a.
      
      
       IF SEARCH(v_path) = ? THEN DO:
            MESSAGE "����:�����ļ�������,����������!" VIEW-AS ALERT-BOX ERROR.
             NEXT-PROMPT v_path WITH FRAME a.
             UNDO, RETRY.
       END.

       IF SUBSTRING(v_path , LENGTH(v_path) - 3) <> ".xls"  THEN 
       DO: 
       MESSAGE "����:ֻ��EXCEL�ļ���������,����������!" VIEW-AS ALERT-BOX ERROR.
             NEXT-PROMPT v_path WITH FRAME a.
             UNDO, RETRY.
       END.



       FOR EACH tmp_det:
           DELETE tmp_det.
       END.
       CREATE "Excel.Application" excelapp.
       excelworkbook = excelapp:workbooks:ADD(v_path).
       worksheet = excelapp:worksheets(v_sheet).
       i = 2. 

       colnum = 0.

      /*�����ݵ���ʱ��*/
       REPEAT:

             MESSAGE "����ɹ�!" VIEW-AS ALERT-BOX .
          if TRIM(worksheet:cells(i ,2)) = "" then LEAVE.

          CREATE  tmp_det.
          assign 
	     tmp_req_nbr  = v_max_line + 1
             tmp_nbr      = TRIM(string(worksheet:cells(i ,1))) 
             tmp_part     =  TRIM(string(worksheet:cells(i ,2))) 
             tmp_qty_ord  =  DECIMAL(TRIM(worksheet:cells(i ,3))) 
             tmp_req_date =  dss_due_date
             tmp_due_date =  v_end_date 
             tmp_rec_site =  v_site_to 
             tmp_shipsite =  v_site_from 
             tmp_trloc    =  v_trloc 
             tmp_xls_line =  i. 

          v_max_line = v_max_line + 1.
          i = i + 1.
       end. /*REPEAT:*/
       
       for each tmp_det:
           if not can-find(FIRST pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = tmp_part )
	       then tmp_err = "����Ų����ڣ�".

       end. /*for each tmp_det*/


         /* ����޴��󣬵��룡*/
     errstr = "".
     if not can-find(first tmp_det where tmp_err <> "") then do:
            
        	{gprun.i ""yyinputdrp_load.p"" } 

     end. /*if not can-find() then do:*/
     else do:
          MESSAGE "���ݼ�������鿴�����ļ�!" VIEW-AS ALERT-BOX ERROR .
          UNDO, RETRY.
      end.

  
     if errstr <> "" then do:
          MESSAGE "���������鿴C:\upload.in.out �ļ���" VIEW-AS ALERT-BOX ERROR.
          UNDO, RETRY.
     end.

    
    MESSAGE "����ɹ�!" VIEW-AS ALERT-BOX .



    excelworkbook:saveas(src_file , , , , , , 1) . 
    excelapp:VISIBLE = FALSE .
    excelworkbook:CLOSE(FALSE).
    excelapp:QUIT.
    RELEASE OBJECT excelapp.
    RELEASE OBJECT excelworkbook.
    RELEASE OBJECT worksheet.
    
 END. /*do transaction*/
END. 

