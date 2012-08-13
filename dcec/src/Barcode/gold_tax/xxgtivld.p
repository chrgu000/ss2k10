 {mfdtitle.i "e"}  
def temp-table tinv_mstr                                                         
    field x1 as char format "x(100)"   /*作废标志*/
    field x2 as char format "x(40)"  /*清单标志*/
    field x3 as char format "x(40)"   /*发票种类*/
    field x4 as char format "x(40)"     /*发票类别代码*/
    field tinv_nbr as character format "x(8)"
    field tinv_lines as integer format ">>>9"                 label "行数"
    field tinv_date as character format "x(8)"                label "开票日期"
     field x5 as integer format ">>>9"    /*税务月份*/
    field tinv_mfg_nbr as character format "x(20)"            label " MFG发票"
     field x6 as decimal format ">>,>>>,>>>,>>9.99"    /*不含税金额*/
    field tinv_amt as decimal format ">>,>>>,>>>,>>9.99"      label "总金额"
    field tinv_vat_pct as decimal format "9.99"               label "税率"
     field x7 as decimal format ">>,>>>,>>>,>>9.99"   /*税额*/
    field tinv_cust_name as character format "x(50)"          label "    客户"
    field tinv_cust_tax as character format "x(15)"           label "税号"
    field tinv_cust_addr as character format "x(50)"          label "客户地址"
    field tinv_cust_bank as character format "x(50)"          label "客户银行"
    field tinv_addr as character format "x(50)"               label "公司地址"
    field tinv_bank as character format "x(50)"               label "公司银行"
     field x8 as char format "x(50)"      /*地址电话*/
     field x9 as char format "x(50)"      /*银行帐号*/
    field tinv_demo as character format "x(70)"               label "    备注"
    field tinv_user as character format "x(8)"                label "    开票"
    field tinv_checker as character format "x(8)"             label "复核"
    field tinv_receiver as character format "x(8)"            label "收款"
    field tinv_code as character format "x(10)"               label "发票代码"
    field tinv_status as character format "x(4)" 
    field tinv_do as character format "x(12)" 
    
    
    field tin_flag as character format "x(1)"                    
    field tin_desc as character format "x(30)" 
    field tin_code as character format "x(16)" 
    field tin_um as character format  "x(6)"   
    field tin_qty as decimal format ">,>>>,>>>,>>>,>>>,>>9.99" 
    field tin_amt as decimal format ">>,>>>,>>>,>>9.99"
    field tin_xd1 as decimal format ">,>>>,>>>,>>>,>>>,>>9.99" 
    field tin_xd2 as decimal format ">,>>>,>>>,>>>,>>>,>>9.99" 
    field tin_xd3 as decimal format ">,>>>,>>>,>>>,>>>,>>9.99" 
    field tin_taxc as character format "x(5)" 
    field tin_xd4 as character format "x(8)" 
    
    index i_nbr is unique tinv_nbr .
&scoped-define tinvmstrlist x1 ^ x2 ^ x3 ^ x4 ^ tinv_nbr ^ tinv_lines ^ tinv_date ^ x5 ^ tinv_mfg_nbr ^ tinv_amt ^   ~
                            tinv_vat_pct ^ x7 ^ tinv_cust_name ^ tinv_cust_tax ^ tinv_cust_addr ^ tinv_cust_bank ^ tinv_addr ^   ~
                            tinv_bank ^ x8 ^ x9 ^ tinv_demo ^ tinv_user ^ tinv_checker    ~
                      tin_flag ^ tin_desc ^ tin_code ^ tin_um ^ tin_qty ^ tin_amt ^    ~
                      tin_xd1 ^ tin_xd2 ^ tin_xd3 ^ tin_taxc ^ tin_xd4        
def temp-table tinvd_det
   field tinvd_flag as character format "x(1)"                   
    field tinvd_desc as character format "x(30)" 
    field tinvd_code as character format "x(16)" 
    field tinvd_um as character format  "x(6)"   
    field tinvd_qty as decimal format ">,>>>,>>>,>>>,>>>,>>9.99" 
    field tinvd_amt as decimal format ">>,>>>,>>>,>>9.99"
    field xd1 as decimal format ">,>>>,>>>,>>>,>>>,>>9.99" 
   field xd2 as decimal format ">,>>>,>>>,>>>,>>>,>>9.99" 
   field xd3 as decimal format ">,>>>,>>>,>>>,>>>,>>9.99" 
    field tinvd_taxc as character format "x(5)" 
    field xd4 as character format "x(8)" 
    field tinvd_nbr as character format "x(8)".
&scoped-define tinvddetlist tinvd_flag ^ tinvd_desc ^ tinvd_code ^ tinvd_um ^ tinvd_qty ^ tinvd_amt ^    ~
                      xd1 ^ xd2 ^ xd3 ^ tinvd_taxc ^ xd4                               

def temp-table tt                                                    
    field tt_01 as char format "x(20)"
    field tt_02 as char format "x(20)"
    field tt_03 as char format "x(20)"                                 
    field tt_04 as char format "x(20)"
    field tt_05 as char format "x(20)". 

DEFINE BUTTON btn_close LABEL "关  闭"  SIZE 19 BY 1.
DEFINE BUTTON btn_dump  LABEL "导  出"  SIZE 9.5 BY 1.
DEFINE BUTTON btn_infile LABEL "查找文件"  SIZE 9 BY 1.
DEFINE BUTTON btn_load  LABEL "发票更新"  SIZE 19 BY 1.
DEFINE BUTTON btn_outfile  LABEL "..." SIZE 4 BY 1.
DEFINE BUTTON btn_readtext LABEL "发票校验" SIZE 19 BY 1.
DEFINE VARIABLE infilename AS CHARACTER FORMAT "X(256)":U VIEW-AS FILL-IN SIZE 38.5 BY 1 NO-UNDO.
DEFINE VARIABLE outfilename AS CHARACTER FORMAT "X(256)":U VIEW-AS FILL-IN SIZE 38.5 BY 1 NO-UNDO.
DEFINE VARIABLE nolist AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL SIZE 22.5 BY 15 NO-UNDO.
DEFINE VARIABLE oklist AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL SIZE 22.5 BY 15 NO-UNDO.
DEFINE VARIABLE incorrlist AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL SIZE 22.5 BY 15 NO-UNDO.
DEFINE BUTTON btn_invdetail LABEL "发票明细" SIZE 11 BY 1.
 DEFINE FRAME M
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         SIZE 80 BY 22.

DEFINE FRAME A
     infilename AT ROW 2 COL 20.5 NO-LABEL
     btn_infile AT ROW 2 COL 63
     btn_readtext AT ROW 3.5 COL 6
     btn_load AT ROW 3.5 COL 31
      btn_close AT ROW 3.5 COL 57       
     oklist AT ROW 5.75 COL 1.5 NO-LABEL
      nolist AT ROW 5.75 COL 28 NO-LABEL
     incorrlist AT ROW 5.75 COL 54.5 no-label
     "不一致的发票" VIEW-AS TEXT
          SIZE 21.5 BY 1 AT ROW 4.75 COL 60.5
     "GTS,MFG一致的发票" VIEW-AS TEXT
          SIZE 18 BY 1 AT ROW 4.75 COL 3
      "GTS输出文件名:" VIEW-AS TEXT
          SIZE 14 BY 1 AT ROW 2 COL 5.5
     "不存在的发票" VIEW-AS TEXT
          SIZE 20.5 BY 1 AT ROW 4.75 COL 34.5
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 22.
&Scoped-Define enablea infilename btn_infile btn_readtext btn_load /*outfilename btn_outfile btn_dump*/ btn_close oklist nolist incorrlist 
&Scoped-Define displaya infilename btn_infile btn_readtext btn_load /*outfilename btn_outfile btn_dump*/ btn_close oklist nolist incorrlist 
&Scoped-Define assignlista infilename  /*outfilename */

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
         AT COL 1 ROW 13.5
         SIZE 80 BY 7.5.
&scoped-define displistb tinv_mfg_nbr tinv_lines tinv_amt    ~
                            tinv_vat_pct tinv_cust_name tinv_cust_tax tinv_addr    ~
                            tinv_bank tinv_user tinv_demo tinv_checker tinv_receiver tinv_code btn_invdetail

assign frame a:frame = frame m:handle 
       frame b:frame = frame m:handle .

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
def var gtibefore as logic initial false .
     
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

on choose of btn_leaveb2 in frame c do:
   current-window = currwin .
   dtlwin:visible = false .
end .   
/*
ON CHOOSE OF btn_close IN FRAME A /* 关  闭 */
DO:
   leave .
END.
  */
ON CHOOSE OF btn_infile IN FRAME A /* ... */
DO:
     SYSTEM-DIALOG GET-FILE inFileName
           FILTERS "文本文件(*.txt)" "*.txt"
                 INITIAL-DIR "c:\"
                         RETURN-TO-START-DIR
                              TITLE "GTI 传出文件" 
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

ON DEFAULT-ACTION OF nolist IN FRAME A
DO:
   assign frame a {&assignlista} .
   run viewhead(input nolist:screen-value in frame a) .
END.

ON DEFAULT-ACTION OF incorrlist IN FRAME A
DO:
   assign frame a {&assignlista} .
   run viewhead(input incorrlist:screen-value in frame a) .
END.

ON DEFAULT-ACTION OF oklist IN FRAME A
DO:
   assign frame a {&assignlista} .
   run viewhead(input oklist:screen-value in frame a) .
END.
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
   def var fsame like tinv_status .
   def var nbr like tinv_nbr .
   for each tinv_mstr no-lock:
      delete tinv_mstr .
   end .
   for each tinvd_det no-lock:
      delete tinvd_det .
   end .
   input from value(infilename) .
   
   create tt.                                                      
   import delimiter "~~" tt_01 tt_02 tt_03.
   create tt.
   import delimiter "~~" tt_01 tt_02 tt_03 tt_04 tt_05.

   repeat :
   
      create tt.                                              
     import delimiter "~~" tt_01. 
   
      create tinv_mstr .
      import DELIMITER "~~" {&tinvmstrlist}.                                                
    
      if tinv_nbr = "" then do:
         delete tinv_mstr .
         leave .
      end .    
      
      create tinvd_det.
      tinvd_flag = tin_flag.
      tinvd_desc = tin_desc.
      tinvd_code = tin_code.
      tinvd_um = tin_um.
      tinvd_qty = tin_qty.
      tinvd_amt = tin_amt.
      tinvd_taxc = tin_taxc.
      tinvd_nbr = tinv_nbr.
      
      do i = 2 to tinv_lines by 1 :                                
         create tinvd_det .
         import  DELIMITER "~~" {&tinvddetlist} .
         tinvd_nbr = tinv_nbr . 
         release tinvd_det .
      end .    
      nbr = tinv_nbr .
      release tinv_mstr .
       if gtibefore then
         run gtsvsmfg(input nbr) .
      else run gtsvsmfg1(input nbr) .   
   end .
   input close .
   
   for each tinv_mstr where tinv_status = "" no-lock:
      oklist:add-last(tinv_nbr) in frame a .
   end .
   for each tinv_mstr where tinv_status = "no" no-lock :
      nolist:add-last(tinv_nbr) in frame a .
   end .
    for each tinv_mstr where tinv_status = "M" no-lock :
      incorrlist:add-last(tinv_nbr) in frame a .
   end .
   
end procedure .

procedure gtsvsmfg:
    define input parameter nbr like tinv_mfg_nbr .
   define buffer ad1 for ad_mstr . 
   define buffer ad2 for ad_mstr .
   define var vs as logic .
   def var tolamt like tinv_amt initial 0.
   find first tinv_mstr where tinv_nbr = nbr no-error .
    find first so_mstr where so_inv_nbr = tinv_mfg_nbr no-lock no-error .
   if not available(so_mstr) then do:
      tinv_status = "no" .
      leave .
   end .   
    find first ad1 where ad_addr = so_bill no-lock no-error .   /* 客户 */
   if not available(ad1) then do:
      tinv_status = "M" .
      leave .
   end .   


   IF tinv_mfg_nbr = "" THEN DO:
      tinv_status = "M".
      tinv_nbr = tinv_nbr + "是空白发票"  .
      LEAVE.
   END.

    
  
   tinv_status = "" .
end procedure .

procedure gtsvsmfg1:
    define input parameter nbr like tinv_mfg_nbr .
   define buffer ad1 for ad_mstr . 
   define buffer ad2 for ad_mstr .
   define var vs as logic .
   def var tolamt like tinv_amt initial 0.
   find first tinv_mstr where tinv_nbr = nbr no-error .
    find first ih_hist where ih_inv_nbr = tinv_mfg_nbr no-lock no-error .
   if not available(ih_hist) then do:
      tinv_status = "no" .
      leave .
   end .   
    find first ad1 where ad_addr = ih_bill no-lock no-error .   /* 客户 */
   if not available(ad1) then do:
      tinv_status = "M" .
      leave .
   end .   


   IF tinv_nbr = "" THEN DO:
       tinv_status = "no".
       tinv_nbr = "空白发票" .
   END.

 end procedure .

procedure dumptext:
    define var i as integer .
   output to value(outfilename) .
   if gtibefore then do:
      for each tinv_mstr where tinv_status <> "" no-lock:
         for each so_mstr where so_inv_nbr = tinv_mfg_nbr :
            assign so__chr01 = ""
                   so_inv_nbr = tinv_mfg_nbr
                   so__chr02 = tinv_nbr
                   so__chr03 = "D" .
            if next-value(tr_sq01) = ? then do:
               message "序号tr_sq01需要reset,不能建立事物记录!" view-as alert-box error .
            end .   
              create tr_hist .
              assign tr_trnbr = current-value(tr_sq01)
                   tr_userid = userid("qaddb") 
                   tr_addr = so_inv_nbr
                   tr_effdate = today
                   tr_nbr = so_nbr
                   tr_program = "xxgtivld.p"
                   tr_rmks = "sod"
                   tr_ship_id = "gti" 
                   tr_type = "GTI-WAST" .

         end .          
         export tinv_nbr .       
      end .        
   end .
   else do:
      for each tinv_mstr where tinv_status <> "" no-lock:
         for each ih_hist where ih_inv_nbr = tinv_mfg_nbr :
            assign ih__chr01 = ""
                   ih_inv_nbr = tinv_mfg_nbr
                   ih__chr02 = tinv_nbr
                   ih__chr03 = "D" .
            if next-value(tr_sq01) = ? then do:
               message "序号tr_sq01需要reset,不能建立事物记录!" view-as alert-box error .
            end .   
                   
              create tr_hist .
              assign tr_trnbr = current-value(tr_sq01)
                   tr_userid = userid("qaddb") 
                   tr_addr = ih_inv_nbr
                   tr_effdate = today
                   tr_nbr = ih_nbr
                   tr_program = "xxgtivld.p"
                   tr_rmks = "idh"
                   tr_ship_id = "gti" 
                   tr_type = "GTI-WAST" .
         end .          
         export tinv_nbr .       
      end .        
   end .   
   output close .
end procedure .

procedure todb:
    if gtibefore then do:
      for each tinv_mstr where tinv_status = "" no-lock :
         for each so_mstr where so_inv_nbr = tinv_mfg_nbr :
            assign so_inv_nbr = tinv_nbr
                   so__chr01 = tinv_mfg_nbr 
                   so__chr02 = tinv_nbr  
                   so__chr03 = "" .
           for each sod_det where sod_nbr = so_nbr 
                                         and  sod_qty_inv <> 0 and sod_price <> 0 and sod_taxable no-lock ,
          each vt_mstr fields(vt_tax_pct) where vt_class = sod_taxc 
                                            and (vt_tax_pct = 6 or vt_tax_pct = 13 or vt_tax_pct = 17) no-lock :    
              if next-value(tr_sq01) = ? then do:
                 message "序号tr_sq01需要reset,不能建立事物记录!" view-as alert-box error .
              end .   
              create tr_hist .
              assign tr_trnbr = current-value(tr_sq01)
                   tr_userid = userid("qaddb") 
                   tr_addr = so_inv_nbr
                   tr_effdate = today
                   tr_line = sod_line
                   tr_nbr = sod_nbr
                   tr_part = sod_part
                   tr_qty_loc = sod_qty_inv
                   tr_site = sod_site
                   tr_loc = sod_loc
                   tr_program = "xxgtivld.p"
                   tr_rmks = "sod"
                   tr_ship_id = "gti" 
                   tr_type = "GTI-LOAD" .
            end .
         end .          
      end .
   end .
   else do:
      for each tinv_mstr where tinv_status = "" no-lock :
         for each ih_hist where ih_inv_nbr = tinv_mfg_nbr :
            assign ih_inv_nbr = tinv_nbr
                   ih__chr01 = tinv_mfg_nbr 
                   ih__chr02 = tinv_nbr  
                   ih__chr03 = "" .
            for each idh_hist where idh_nbr = ih_nbr 
                                         and  idh_taxable no-lock ,
            each vt_mstr fields(vt_tax_pct) where vt_class = idh_taxc 
                                         and (vt_tax_pct = 6 or vt_tax_pct = 13 or vt_tax_pct = 17) no-lock :    
              if next-value(tr_sq01) = ? then do:
                 message "序号tr_sq01需要reset,不能建立事物记录!" view-as alert-box error .
              end .   
              create tr_hist .
              assign tr_trnbr = current-value(tr_sq01)
                   tr_userid = userid("qaddb") 
                   tr_addr = ih_inv_nbr
                   tr_effdate = today
                   tr_line = idh_line
                   tr_nbr = idh_nbr
                   tr_part = idh_part
                   tr_qty_loc = idh_qty_inv
                   tr_site = idh_site
                   tr_loc = idh_loc
                   tr_program = "xxgtivld.p"
                   tr_rmks = "idh"
                   tr_ship_id = "gti" 
                   tr_type = "GTI-LOAD" .
            end .
         end .          
      end .
   end .      
end procedure .

   
  DISPLAY {&displaya} WITH FRAME A .
  ENABLE {&enablea}   WITH FRAME A .
  VIEW FRAME M .
  find first co_ctrl no-lock no-error .
  if not available(co_ctrl) then do:
     message "控制文件找不到！" view-as alert-box error .
     leave .
  end .   
  gtibefore = if co_user2 = "yes" then true else false .
  release co_ctrl .
  frame b:visible = false . 
  wait-for choose of btn_close in frame a .
    
