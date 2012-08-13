/*-------------------------------------------------------------------------------------------------------
  File:           yygtload.p
  Description:    系统接收从GTS 中反馈的已开作废发票(invwast.txt), 然后以此更新MFG 发票
  Author:         Enping Yang
  Created:        2000-12-22
  Notes:     For Users
                  1. 在GTS,MFG发票对照表中,状态拦标志如果为"不存在",表示导入的废票在MFG中没有相应的MFG发票.
                  2. 导入的废票不做其他一致性检查.
                  3. 对在MFG中存在的发票, 应该重新dump到GTS,然后重新打印, 该发票在发票导出程序中会显示为"W" .
             For Team
                  1. 报废的GTS发票相应的MFG发票,如下字段会被更新:so__chr01 = "",so__chr02=报废GTs发票号,so__chr03 = "W",so_inb_nbr = MFGnbr
----------------------------------------------------------------------------------------------------------*/
 {mfdtitle.i "e"}  
/* ***********************  Control Definitions  ********************** */
def temp-table tinv_mstr
    field tinv_nbr as character format "x(8)"
    field tinv_lines as integer format ">>>9"                 label "行数"
    field tinv_date as character format "x(8)"                label "开票日期"
    field tinv_mfg_nbr as character format "x(20)"            label " MFG发票"
    field tinv_amt as decimal format ">>,>>>,>>>,>>9.99"      label "总金额"
    field tinv_vat_pct as decimal format "9.99"               label "税率"
    field tinv_cust_name as character format "x(50)"          label "    客户"
    field tinv_cust_tax as character format "x(15)"           label "税号"
    field tinv_cust_addr as character format "x(50)"          label "客户地址"
    field tinv_cust_bank as character format "x(50)"          label "客户银行"
    field tinv_addr as character format "x(50)"               label "公司地址"
    field tinv_bank as character format "x(50)"               label "公司银行"
    field tinv_user as character format "x(8)"                label "    开票"
    field tinv_demo as character format "x(70)"               label "    备注"
    field tinv_checker as character format "x(8)"             label "复核"
    field tinv_receiver as character format "x(8)"            label "收款"
    field tinv_code as character format "x(10)"               label "发票代码"
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

DEFINE BUTTON btn_close LABEL "关  闭"  SIZE 9.5 BY 1.
DEFINE BUTTON btn_infile LABEL "..."  SIZE 4 BY 1.
DEFINE BUTTON btn_load  LABEL "导 入"  SIZE 9.5 BY 1.
DEFINE BUTTON btn_readtext LABEL "文本读取" SIZE 9.5 BY 1.
DEFINE VARIABLE infilename AS CHARACTER FORMAT "X(256)":U VIEW-AS FILL-IN SIZE 54 BY 1 NO-UNDO.
DEFINE BUTTON btn_invdetail LABEL "发票明细" SIZE 11 BY 1.
DEFINE QUERY q1 FOR tinv_mstr SCROLLING.
DEFINE BROWSE b1 QUERY q1 DISPLAY
      tinv_nbr  column-label "GTS 发票号":C  width 20
      tinv_mfg_nbr column-label "MFG 发票号":C width 20
      tinv_status column-label "备注":C width 10
    WITH NO-ROW-MARKERS SIZE 54 BY 8.5  .
/* ************************  Frame Definitions  *********************** */
DEFINE FRAME M
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         SIZE 80 BY 20.

DEFINE FRAME A
     infilename AT ROW 1 COL 1 LABEL "导入文件名"
     btn_infile AT ROW 1 COL 65
     btn_readtext AT ROW 1 COL 70.5
     btn_load AT ROW 2.25 COL 70.5
     btn_close AT ROW 3.5 COL 70.5
     b1 AT ROW 3.25 COL 3
     "GTS废票、MFG发票对照" VIEW-AS TEXT
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
         TITLE              = "GTS 发票明细"
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
     display tinvd_desc  column-label "零件名称":C
             tinvd_code  column-label "规格":C
             tinvd_um    column-label "单位":C
             tinvd_qty   column-label "数量":C
             tinvd_amt   column-label "金额":C
             tinvd_taxc  column-label "税目":C
             tinvd_flag  column-label "标志位":C
    WITH NO-ROW-MARKERS SIZE 84.5 BY 16  .
    
DEFINE BUTTON btn_leaveb2 LABEL "关   闭" SIZE 11 BY 1.
     
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

ON CHOOSE OF btn_close IN FRAME A /* 关  闭 */
DO:
   leave .
END.

ON CHOOSE OF btn_infile IN FRAME A /* ... */
DO:
     SYSTEM-DIALOG GET-FILE inFileName
           FILTERS "文本文件(*.txt)" "*.txt"
                 INITIAL-DIR "c:\"
                         RETURN-TO-START-DIR
                              TITLE "GTS 废票文件" 
                                 SAVE-AS
                                    USE-FILENAME
                                      DEFAULT-EXTENSION ".txt".
     display infilename with frame a .
END.

ON CHOOSE OF btn_invdetail IN FRAME B /* 发票明细 */
DO:
   assign frame a {&assignlista} .
   run viewdetail .
END.

ON CHOOSE OF btn_load IN FRAME A /* 导 入 */
DO:
   assign frame a {&assignlista} .
   run todb .
END.

ON CHOOSE OF btn_readtext IN FRAME A /* 文本读取 */
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
   assign current-window:title = "GTS 发票明细       发票号:  " + nownbr . 
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
         if not available(so_mstr) then tinv_status = "不存在" .
      end .
      else do:   
         find first ih_hist where ih_inv_nbr = tinv_mfg_nbr no-lock no-error .
         if not available(ih_hist) then tinv_status = "不存在" .
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
       更新相应的MFG发票字段
       ---------- */
   if gtibefore then do:
      for each tinv_mstr where tinv_status = "" no-lock on error undo,retry:
         for each so_mstr where so_inv_nbr = tinv_mfg_nbr :  
            assign so_inv_nbr = tinv_mfg_nbr
                   so__chr01 = ""
                   so__chr02 = tinv_nbr  
                   so__chr03 = "W" .
              if next-value(tr_sq01) = ? then do:
                 message "序号tr_sq01需要reset,不能建立事物记录!" view-as alert-box error .
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
                 message "序号tr_sq01需要reset,不能建立事物记录!" view-as alert-box error .
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
     message "控制文件不存在！" view-as alert-box error .
     leave .
  end .
  gtibefore = if co_user2 = "yes" then true else false .
  release co_ctrl .   
  frame b:visible = false . 
  wait-for choose of btn_close in frame a .
