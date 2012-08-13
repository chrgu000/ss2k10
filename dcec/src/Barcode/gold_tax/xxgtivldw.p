/*-------------------------------------------------------------------------------------------------------
  File:           yygtload.p
  Description:    ϵͳ���մ�GTS �з������ѿ����Ϸ�Ʊ(invwast.txt), Ȼ���Դ˸���MFG ��Ʊ
  Author:         Enping Yang
  Created:        2000-12-22
  Notes:     For Users
                  1. ��GTS,MFG��Ʊ���ձ���,״̬����־���Ϊ"������",��ʾ����ķ�Ʊ��MFG��û����Ӧ��MFG��Ʊ.
                  2. ����ķ�Ʊ��������һ���Լ��.
                  3. ����MFG�д��ڵķ�Ʊ, Ӧ������dump��GTS,Ȼ�����´�ӡ, �÷�Ʊ�ڷ�Ʊ���������л���ʾΪ"W" .
             For Team
                  1. ���ϵ�GTS��Ʊ��Ӧ��MFG��Ʊ,�����ֶλᱻ����:so__chr01 = "",so__chr02=����GTs��Ʊ��,so__chr03 = "W",so_inb_nbr = MFGnbr
----------------------------------------------------------------------------------------------------------*/
 {mfdtitle.i "e"}  
/* ***********************  Control Definitions  ********************** */
def temp-table tinv_mstr
    field tinv_nbr as character format "x(8)"
    field tinv_lines as integer format ">>>9"                 label "����"
    field tinv_date as character format "x(8)"                label "��Ʊ����"
    field tinv_mfg_nbr as character format "x(20)"            label " MFG��Ʊ"
    field tinv_amt as decimal format ">>,>>>,>>>,>>9.99"      label "�ܽ��"
    field tinv_vat_pct as decimal format "9.99"               label "˰��"
    field tinv_cust_name as character format "x(50)"          label "    �ͻ�"
    field tinv_cust_tax as character format "x(15)"           label "˰��"
    field tinv_cust_addr as character format "x(50)"          label "�ͻ���ַ"
    field tinv_cust_bank as character format "x(50)"          label "�ͻ�����"
    field tinv_addr as character format "x(50)"               label "��˾��ַ"
    field tinv_bank as character format "x(50)"               label "��˾����"
    field tinv_user as character format "x(8)"                label "    ��Ʊ"
    field tinv_demo as character format "x(70)"               label "    ��ע"
    field tinv_checker as character format "x(8)"             label "����"
    field tinv_receiver as character format "x(8)"            label "�տ�"
    field tinv_code as character format "x(10)"               label "��Ʊ����"
    field tinv_status as character format "x(6)" 
    field tinv_do as character format "x(12)" 
    index i_nbr is unique tinv_nbr .
&scoped-define tinvmstrlist tinv_nbr tinv_lines tinv_date tinv_mfg_nbr tinv_amt    ~
                            tinv_vat_pct tinv_cust_name tinv_cust_tax tinv_cust_addr tinv_cust_bank tinv_addr    ~
                            tinv_bank tinv_user tinv_demo tinv_checker tinv_receiver tinv_code
def temp-table tinvd_det
    field tinvd_nbr as character format "x(8)"
    field tinvd_desc as character format "x(30)"
    field tinvd_code as character format "x(16)"
    field tinvd_um as character format  "x(6)"
    field tinvd_qty as decimal format ">,>>>,>>>,>>>,>>>,>>9.99"
    field tinvd_amt as decimal format ">>,>>>,>>>,>>9.99"
    field tinvd_taxc as character format "x(5)"
    field tinvd_flag as character format "x(1)" .
&scoped-define tinvddetlist tinvd_desc tinvd_code tinvd_um tinvd_qty tinvd_amt tinvd_taxc tinvd_flag

DEFINE BUTTON btn_close LABEL "��  ��"  SIZE 9.5 BY 1.
DEFINE BUTTON btn_infile LABEL "..."  SIZE 4 BY 1.
DEFINE BUTTON btn_load  LABEL "�� ��"  SIZE 9.5 BY 1.
DEFINE BUTTON btn_readtext LABEL "�ı���ȡ" SIZE 9.5 BY 1.
DEFINE VARIABLE infilename AS CHARACTER FORMAT "X(256)":U VIEW-AS FILL-IN SIZE 54 BY 1 NO-UNDO.
DEFINE BUTTON btn_invdetail LABEL "��Ʊ��ϸ" SIZE 11 BY 1.
DEFINE QUERY q1 FOR tinv_mstr SCROLLING.
DEFINE BROWSE b1 QUERY q1 DISPLAY
      tinv_nbr  column-label "GTS ��Ʊ��":C  width 20
      tinv_mfg_nbr column-label "MFG ��Ʊ��":C width 20
      tinv_status column-label "��ע":C width 10
    WITH NO-ROW-MARKERS SIZE 54 BY 8.5  .
/* ************************  Frame Definitions  *********************** */
DEFINE FRAME M
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         SIZE 80 BY 20.

DEFINE FRAME A
     infilename AT ROW 1 COL 1 LABEL "�����ļ���"
     btn_infile AT ROW 1 COL 65
     btn_readtext AT ROW 1 COL 70.5
     btn_load AT ROW 2.25 COL 70.5
     btn_close AT ROW 3.5 COL 70.5
     b1 AT ROW 3.25 COL 3
     "GTS��Ʊ��MFG��Ʊ����" VIEW-AS TEXT
          SIZE 12 BY 1 AT ROW 2.25 COL 26
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 11.
&Scoped-Define enablea infilename btn_infile btn_readtext btn_load btn_close b1 
&Scoped-Define displaya infilename btn_infile btn_readtext btn_load btn_close b1 
&Scoped-Define assignlista infilename 

DEFINE FRAME B
     btn_invdetail AT ROW 7.25 COL 69.5
     tinv_mfg_nbr AT ROW 1 COL 1 
     tinv_date AT ROW 1 COL 31 COLON-ALIGNED 
     tinv_amt AT ROW 1 COL 50 COLON-ALIGNED
     tinv_vat_pct AT ROW 1 COL 73 COLON-ALIGNED
     tinv_cust_name AT ROW 2.25 COL 1 
     tinv_cust_tax AT ROW 2.25 COL 54 COLON-ALIGNED 
     tinv_addr AT ROW 3.25 COL 1 
     tinv_bank AT ROW 4.25 COL 1 
     tinv_demo AT ROW 5.25 COL 1 
     tinv_code AT ROW 6.25 COL 1
     tinv_checker AT ROW 6.25 COL 34.5 COLON-ALIGNED
     tinv_user AT ROW 7.25 COL 1 
     tinv_receiver AT ROW 7.25 COL 34.5 COLON-ALIGNED
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 12
         SIZE 80 BY 9.
&scoped-define displistb tinv_mfg_nbr tinv_lines tinv_amt    ~
                            tinv_vat_pct tinv_cust_name tinv_cust_tax tinv_addr    ~
                            tinv_bank tinv_user tinv_demo tinv_checker tinv_receiver tinv_code btn_invdetail

assign frame a:frame = frame m:handle 
       frame b:frame = frame m:handle .

/* *************************  Create Window  ************************** */
define var dtlwin as widget-handle .
CREATE WINDOW dtlwin ASSIGN
         HIDDEN             = YES
         TITLE              = "GTS ��Ʊ��ϸ"
         HEIGHT             = 21.25
         WIDTH              = 101
         MAX-HEIGHT         = 40
         MAX-WIDTH          = 120
         VIRTUAL-HEIGHT     = 24
         VIRTUAL-WIDTH      = 85
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
define query q2 for tinvd_det scrolling .
define browse b2 query q2
     display tinvd_desc  column-label "�������":C
             tinvd_code  column-label "���":C
             tinvd_um    column-label "��λ":C
             tinvd_qty   column-label "����":C
             tinvd_amt   column-label "���":C
             tinvd_taxc  column-label "˰Ŀ":C
             tinvd_flag  column-label "��־λ":C
    WITH NO-ROW-MARKERS SIZE 84.5 BY 16  .
    
DEFINE BUTTON btn_leaveb2 LABEL "��   ��" SIZE 11 BY 1.
     
define frame c
   b2 at row 1 col 1 
   btn_leaveb2 at row 18 col 35 
  WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         centered 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 85 BY 23.
&scoped-define displistc b2 btn_leaveb2
&scoped-define enablelistc b2 btn_leaveb2

def var currwin as widget-handle .
def var nownbr like tinv_nbr . 
def var gtibefore as logic initial false .

on choose of btn_leaveb2 in frame c do:
   current-window = currwin .
   dtlwin:visible = false .
end .   

ON CHOOSE OF btn_close IN FRAME A /* ��  �� */
DO:
   leave .
END.

ON CHOOSE OF btn_infile IN FRAME A /* ... */
DO:
     SYSTEM-DIALOG GET-FILE inFileName
           FILTERS "�ı��ļ�(*.txt)" "*.txt"
                 INITIAL-DIR "c:\"
                         RETURN-TO-START-DIR
                              TITLE "GTS ��Ʊ�ļ�" 
                                 SAVE-AS
                                    USE-FILENAME
                                      DEFAULT-EXTENSION ".txt".
     display infilename with frame a .
END.

ON CHOOSE OF btn_invdetail IN FRAME B /* ��Ʊ��ϸ */
DO:
   assign frame a {&assignlista} .
   run viewdetail .
END.

ON CHOOSE OF btn_load IN FRAME A /* �� �� */
DO:
   assign frame a {&assignlista} .
   run todb .
END.

ON CHOOSE OF btn_readtext IN FRAME A /* �ı���ȡ */
DO:
   assign frame a {&assignlista} .
   run readtext .
END.

ON DEFAULT-ACTION OF b1 IN FRAME A
DO:
   assign frame a {&assignlista} .
   run viewhead(input tinv_mstr.tinv_nbr:screen-value in browse b1 ) .
END.

/* ************************ Prcedures *********************************** */
procedure viewhead:
   define input parameter isnbr like tinv_nbr .
   nownbr = isnbr .
   frame b:visible = true .
   find first tinv_mstr where tinv_nbr = isnbr no-lock no-error .
   if available(tinv_mstr) then do: 
     disp {&displistb} with frame b .
     disp substring(tinv_date,3,2) + "-" + substring(tinv_date,5,2) + "-" + substring(tinv_date,7,2) @ tinv_date with frame b .
     enable btn_invdetail with frame b .  
     view frame b .
   end .  
end procedure .

procedure viewdetail:
   currwin = current-window .
   current-window = dtlwin:handle .
   current-window:visible = true . 
   current-window:move-to-top() .
   assign current-window:title = "GTS ��Ʊ��ϸ       ��Ʊ��:  " + nownbr . 
   open query q2 for each tinvd_det where tinvd_nbr = nownbr no-lock .
   disp {&displistc} with frame c .
   enable {&enablelistc} with frame c .
   view frame c in window dtlwin .
end procedure .

procedure readtext :
   def var i as integer .
   def var nbr like tinv_nbr .
   for each tinv_mstr no-lock:
      delete tinv_mstr .
   end .
   for each tinvd_det no-lock:
      delete tinvd_det .
   end .
   input from value(infilename) .
   repeat :
      create tinv_mstr .
      import  DELIMITER "," {&tinvmstrlist} .
      if tinv_nbr = "" then do:
         delete tinv_mstr .
         leave .
      end .    
      do i = 1 to tinv_lines by 1 :
         create tinvd_det .
         import  DELIMITER "," {&tinvddetlist} .
         tinvd_nbr = tinv_nbr . 
         release tinvd_det .
      end .    
      if gtibefore then do:
         find first so_mstr where so_inv_nbr = tinv_mfg_nbr no-lock no-error .
         if not available(so_mstr) then tinv_status = "������" .
      end .
      else do:   
         find first ih_hist where ih_inv_nbr = tinv_mfg_nbr no-lock no-error .
         if not available(ih_hist) then tinv_status = "������" .
      end .      
   end .
   input close .
   find first tinv_mstr where tinv_nbr = "" no-error .
   if available(tinv_mstr) then delete tinv_mstr .
   open query q1 for each tinv_mstr no-lock .
   display b1 with frame a .           
end procedure .

procedure todb:
    /* --------
       ������Ӧ��MFG��Ʊ�ֶ�
       ---------- */
   if gtibefore then do:
      for each tinv_mstr where tinv_status = "" no-lock on error undo,retry:
         for each so_mstr where so_inv_nbr = tinv_mfg_nbr :  
            assign so_inv_nbr = tinv_mfg_nbr
                   so__chr01 = ""
                   so__chr02 = tinv_nbr  
                   so__chr03 = "W" .
              if next-value(tr_sq01) = ? then do:
                 message "���tr_sq01��Ҫreset,���ܽ��������¼!" view-as alert-box error .
              end .   
              create tr_hist .
              assign tr_trnbr = current-value(tr_sq01)
                   tr_userid = userid("qaddb") 
                   tr_addr = so_inv_nbr
                   tr_effdate = today
                   tr_nbr = so_nbr
                   tr_program = "xxgtivldw.p"
                   tr_rmks = "so"
                   tr_ship_id = "gti" 
                   tr_type = "GTI-WAST" .
         end .       
      end .
   end .
   else do:
      for each tinv_mstr where tinv_status = "" no-lock on error undo,retry:
         for each ih_hist where ih_inv_nbr = tinv_mfg_nbr :  
            assign ih_inv_nbr = tinv_mfg_nbr
                   ih__chr01 = ""
                   ih__chr02 = tinv_nbr  
                   ih__chr03 = "W" .
              if next-value(tr_sq01) = ? then do:
                 message "���tr_sq01��Ҫreset,���ܽ��������¼!" view-as alert-box error .
              end .   
              create tr_hist .
              assign tr_trnbr = current-value(tr_sq01)
                   tr_userid = userid("qaddb") 
                   tr_addr = ih_inv_nbr
                   tr_effdate = today
                   tr_nbr = ih_nbr
                   tr_program = "xxgtivldw.p"
                   tr_rmks = "ih"
                   tr_ship_id = "gti" 
                   tr_type = "GTI-WAST" .
         end .       
      end .
   end .   
end procedure .

/* ***************************  Main Block  *************************** */
  DISPLAY {&displaya} WITH FRAME A .
  ENABLE {&enablea}   WITH FRAME A .
  VIEW FRAME M .
  find first co_ctrl no-lock no-error .
  if not available(co_ctrl) then do:
     message "�����ļ������ڣ�" view-as alert-box error .
     leave .
  end .
  gtibefore = if co_user2 = "yes" then true else false .
  release co_ctrl .   
  frame b:visible = false . 
  wait-for choose of btn_close in frame a .
