/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/19/12  ECO: *SS-20120919.1*   */

{mfdtitle.i "120919.1"}

DEFINE VARIABLE v_site_to like ad_addr.
DEFINE VARIABLE v_req_date as DATE .
DEFINE VARIABLE v_trloc like pt_loc.
DEFINE VARIABLE v_path AS CHAR FORMAT "x(24)".
DEFINE VARIABLE v_site_from like ad_addr.
DEFINE VARIABLE v_end_date as DATE.
DEFINE VARIABLE v_max_line AS INT.
DEFINE VARIABLE v_sheet as char FORMAT "x(24)" .
DEFINE VARIABLE i AS INT.

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
    FIELD tmp_err as char                    /*���뱨��*/
     index tmp_index is primary tmp_req_nbr .
v_max_line = 0.
FOR EACH ds_det fields(ds_domain ds_req_nbr) no-lock BREAK BY ds_domain
      BY integer(ds_req_nbr):
     IF LAST-OF(ds_domain) THEN
       assign v_max_line = integer(ds_req_nbr) + 1 no-error.
end.
if v_max_line = 0 then do:
   assign v_max_line = 1.
end.

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/

 v_site_to    COLON 15 LABEL "�����"
 v_site_from  COLON 50 LABEL "���˵�"    SKIP
 v_req_date   COLON 15 LABEL " ������"
 v_end_date   COLON 50 LABEL "��ֹ��"    SKIP
 v_trloc      COLON 15 LABEL " ��;��λ"
 v_max_line   COLON 50 LABEL "�����"    SKIP
 v_path       COLON 15 LABEL " �ļ�����"
 v_sheet      COLON 50 LABEL "������"       SKIP(1)

   "ģ��ĸ�ʽΪ�������š�����š�����"  AT 20 SKIP

    SKIP(.4)  /*GUI*/
WITH FRAME a SIDE-LABELS WIDTH 80 ATTR-SPACE  THREE-D /*GUI*/.

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

     find first drp_ctrl where drp_ctrl.drp_domain = global_domain no-lock no-ERROR .
     if not available drp_ctrl then do:
         MESSAGE "����:��ά��DRP�����ļ�!" VIEW-AS ALERT-BOX ERROR.
         UNDO.
     end.
     /* else v_max_line = drp_req_nbr +  1. */
     display v_max_line with frame a.

     v_site_from = "DCEC-SV".
     v_req_date = today.
     v_end_date =  today + 1 .
     v_sheet = "sheet1" .
     v_path = "c:\inputDRP.xls".

      UPDATE  v_site_to    VALIDATE(can-find( first si_mstr where si_mstr.si_domain = global_domain and si_site = v_site_to) ,"�ص㲻����")
              v_site_from  VALIDATE(can-find( first si_mstr where si_mstr.si_domain = global_domain and si_site = v_site_from) ,"�ص㲻����")
              v_req_date   VALIDATE(v_req_date <> ? ,"������������")
              v_end_date   VALIDATE(v_end_date <> ? ,"�������ֹ��")
              v_trloc      VALIDATE(can-find( first loc_mstr where loc_mstr.loc_domain = global_domain and loc_loc = v_trloc) ,"��λ������")
              v_max_line   VALIDATE(v_max_line <> ""  ,"�������Ų���Ϊ��")
              v_path       VALIDATE(v_path <> "" ,"�������ļ�����")
              v_sheet      VALIDATE(v_sheet <> "" ,"�����빤����") with frame a.


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


      /*�����ݵ���ʱ��*/
       REPEAT:

          if TRIM(worksheet:cells(i ,2):text) = "" then LEAVE.
          CREATE  tmp_det.
          assign
             tmp_req_nbr  = v_max_line
             tmp_nbr      = TRIM(string(worksheet:cells(i ,1):text))
             tmp_part     =  TRIM(string(worksheet:cells(i ,2):text))
             tmp_qty_ord  =  DECIMAL(TRIM(worksheet:cells(i ,3):text))
             tmp_req_date =  v_req_date
             tmp_due_date =  v_end_date
             tmp_rec_site =  v_site_to
             tmp_shipsite =  v_site_from
             tmp_trloc    =  v_trloc
             tmp_xls_line =  i.
           if not can-find(FIRST pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = tmp_part )
         then do:
            tmp_err = "����Ų����ڣ�".
                  worksheet:cells(i ,8)  = "����Ų����ڣ�".
         end.

          v_max_line = v_max_line + 1.
          i = i + 1.
       end. /*REPEAT:*/



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
          MESSAGE "���������鿴upload.in.out �ļ���" VIEW-AS ALERT-BOX ERROR.
          UNDO, RETRY.
     end.


     find first drp_ctrl where drp_ctrl.drp_domain = global_domain  no-ERROR .
     if  available drp_ctrl then do:
        drp_req_nbr = v_max_line.
     end.


    MESSAGE "����ɹ�!" VIEW-AS ALERT-BOX .



    excelworkbook:saveas(v_path , , , , , , 1) .
    excelapp:VISIBLE = FALSE .
    excelworkbook:CLOSE(FALSE).
    excelapp:QUIT.
    RELEASE OBJECT excelapp.
    RELEASE OBJECT excelworkbook.
    RELEASE OBJECT worksheet.

 END. /*do transaction*/
END.

