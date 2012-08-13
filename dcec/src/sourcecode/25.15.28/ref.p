/*xxsopkrp.p for 销售退货码单打印，writed by eyes,2001/10*/

         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}

define variable first_sw_call as logical initial true.
def var custname like ad_name.
def var cust like so_cust.
def var pknbr like tr_nbr format "x(10)" label "码单号".
def var yn as logic init YES.
def workfile pkdet    
                 field sel_id as char init "*"
                 field trnbr like tr_trnbr                      
                 field part like lad_part format "x(15)"
                 field desc1 like pt_desc1 format "x(10)"
                 field nbr like lad_nbr
                 field line like lad_line
                 field loc like lad_loc
                 field lot like lad_lot
                 field ref like lad_ref
                 field grade like ld_grade
                 field qtyiss like tr_qty_loc
                 field price like tr_price.
def var totqty like lad_qty_all.
def var amt like pt_price.
def var totamt like pt_price.
def var allqty like lad_qty_all.
def var allamt like pt_price.
def var ok_yn as logic.
def var loc like tr_loc.
def var pkdet_recno as recid format "->>>>>>9".
def var nbr like so_nbr.
def var effdate1 like tr_effdate.
def var effdate2 like tr_effdate.
def var pages as inte.
def var mdline as inte.

def var effdate_md like tr_effdate.
def var pknbr_yn as logic.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(1)  /*GUI*/
 cust  colon 22 label "客户编号"
 /*pknbr colon 44*/
 /*yn    colon 33*/
 nbr colon 22
 effdate1 colon 22 effdate2 colon 44 label {t001.i}
 effdate_md colon 22 label "码单日期"
 skip (1)
/*J0VG*/ with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

form
/* RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1*/
 SKIP(.1)  /*GUI*/
   pkdet.sel_id format "x(2)" label "选择"
   pkdet.part format "x(15)"  label "零件号"
   pkdet.desc1 format "x(10)" label "品号"
   pkdet.lot format "x(8)" label "批号"
   pkdet.ref   column-label "匹号"
   pkdet.qtyiss format "->>,>>9.9<" label "发运量"
   pkdet.nbr format "x(8)" column-label "订单号"
   pkdet.line label "项次" format "x(2)"
  skip(.6) 
   with frame c /*20 down scroll 1*/
         
         /*side-labels*/ width 80 title "码单选择" THREE-D /*GUI*/.
/*
DEFINE VARIABLE F-c-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:HIDDEN in frame c = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5.  /*GUI*/
*/         

repeat:
   effdate_md = today.
   pknbr = "".
   nbr = "".   
   if effdate1 = low_date then effdate1 = ?.
   if effdate2 = hi_date then effdate2 = ?.
   update cust /*pknbr*/ /*yn*/ nbr effdate1 effdate2 effdate_md with frame a.
   if effdate1 = ? then effdate1 = low_date.
   if effdate2 = ? then effdate2 = hi_date.
   
   find cm_mstr where cm_addr = cust no-lock no-error.
   if not available cm_mstr then do:
         {mfmsg.i 2786 3}
         undo,retry.
   end.
   
   if nbr <> "" then do:
      find so_mstr where so_nbr = nbr no-lock no-error.
      if not available so_mstr then do:
         {mfmsg.i 609 3}
         undo,retry.
      end.
      find so_mstr where so_nbr = nbr and so_cust = cust no-lock no-error.
      if not available so_mstr then do:
         {mfmsg.i 8283 3}
         undo,retry.
      end.
   end.
   
/*   
   find first tr_hist where tr__chr01 = pknbr no-lock no-error.
   if not available tr_hist then do:
        message "无此码单号码,请重新输入!".
        undo,retry.
   end.
*/   
   mainloop: 
   do transaction on error undo , leave on endkey undo , leave:
       
       for each pkdet:
            delete pkdet.
       end.
       loc = cust + "k".
       for each tr_hist where 
           tr__chr01 = ""
           and (tr_nbr = nbr or nbr = "")
           and (tr_effdate >= effdate1 and tr_effdate <= effdate2)
           and ((tr_type matches "*tr" and tr_loc = loc)
                 or (tr_type = "iss-so" and tr_loc <> loc and tr_loc <> "temp"))
           no-lock:
           
           if tr_nbr <> "" then do:
                find first so_mstr where so_nbr = tr_nbr and so_cust = cust no-lock no-error.
                if not available so_mstr then next.
           end.     
           
           find pt_mstr where pt_part = tr_part no-lock no-error.
           create pkdet.
           assign pkdet.trnbr = tr_trnbr
                  pkdet.part = tr_part
                  pkdet.desc1 = pt_desc1
                  pkdet.nbr = tr_nbr 
                  pkdet.line = string(tr_line)
                  pkdet.loc = tr_loc
                  pkdet.lot = tr_serial
                  pkdet.ref = tr_ref
                  /*pkdet.qtyiss = tr_qty_loc*/
                  /*pkdet.price = tr__dec01 when tr_type matches "*tr" and tr_loc = cust + "k"
                  pkdet.price = tr_price when tr_type = "iss-so" and tr_loc <> cust + "k"*/.
        
           if tr_type matches "*tr" and tr_loc = cust + "k" then do:
                 pkdet.qtyiss = tr_qty_loc.
                 pkdet.price = tr__dec01.
           end.      
           else if tr_type = "iss-so" and tr_loc <> cust + "k" then do:
                 pkdet.qtyiss = - tr_qty_loc.
                 pkdet.price = tr_price.
           end.  
        end.
    
       hide frame a.       
       
       find first pkdet no-lock no-error.
       if not available pkdet then do:
            message "错误: 该客户无信息需要打印码单,请重新输入!".
            undo,leave.
       end.
       
       sw_block:
         do on endkey undo, leave:

         /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
               /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
               {swselect.i
                  &detfile      = pkdet
                  &scroll-field = pkdet.part
                  &framename    = "c"
                  &framesize    = 10
                  &sel_on       = ""*""
                  &sel_off      = """"
                  &display1     = pkdet.sel_id
                  &display2     = pkdet.part
                  &display3     = pkdet.desc1
                  &display4     = pkdet.lot
                  &display5     = pkdet.ref
                  &display6     = pkdet.qtyiss
                  &display7     = pkdet.nbr
                  &display8     = pkdet.line
                  &exitlabel    = sw_block
                  &exit-flag    = first_sw_call
                  &record-id    = pkdet_recno
                   }
           if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("CTRL-E") then do:
               undo sw_block, leave.
            end.        
       end.
       
       hide frame c.
       
    {mfselprt.i "printer" 90}  
     
     pknbr_yn = no.
     
     find ad_mstr where ad_addr = cust no-lock no-error.
       if available ad_mstr then custname = ad_name.
       find ad_mstr where ad_addr matches "*reports*" no-lock no-error.
      
      find first qad_wkfl where qad_key1 = "pknbr_ctrl" no-error.
             if not available qad_wkfl then do:
               create qad_wkfl.
               assign qad_key1 = "pknbr_ctrl"
                      qad_decfld[1] = 1
                      qad_datefld[1] = effdate_md.
             end.             
             def var mddate like tr_date.             
             if qad_datefld[1] <> effdate_md then do:
               for each md_det no-lock:                   
                      if date(substr(md_nbr,3,4) + substr(md_nbr,1,2)) = effdate_md then do:
                           pknbr_yn = yes.
                      end.
               end.       
               if not pknbr_yn then do:        
                  qad_decfld[1] = 1.
                  qad_datefld[1] = effdate_md.
               end.   
               for each md_det 
                   no-lock break by substr(md_nbr,1,6) by int(substr(md_nbr,7,length(md_nbr) - 6)):                   
                   if date(substr(md_nbr,3,4) + substr(md_nbr,1,2)) = effdate_md then do:                   
                      qad_decfld[1] = int(substr(md_nbr,7,length(md_nbr) - 6)) + 1.
                      qad_datefld[1] = effdate_md.
                   end.
                end.                 
             end.
             pknbr = substr(string(effdate_md),7,2) + substr(string(effdate_md),1,2) + substr(string(effdate_md),4,2) + string(qad_decfld[1]).
             qad_decfld[1] = qad_decfld[1] + 1.
              
      put 
      "泰 州 吉 泰 毛 纺 织 染 厂" to 51
       "产 品 发 货 码 单" to 45 skip(1)    
       "编号: QR.03/15.02/004-1998" AT 4      "页号:" + string(page-number - pages,">>9") to 80
       ad_name  AT 4 "码单号码:" AT 51 pknbr
       ad_line1 at 4 "货物发往:" AT 51 cm_addr
       "联系人:" AT 4 ad_attn  custname at 51
       "TEL:" AT 4 ad_phone "," "FAX:" ad_fax "打印日期:" at 51 effdate_md.
       down.
       
       pages = page-number - 1.
       
       def var total_qty like lad_qty_all.
       total_qty = 0.
        
        mdline = 1.

        find first usr_mstr where usr_userid = global_userid no-lock no-error.
 
        for each pkdet where pkdet.sel_id <> "" no-lock break by pkdet.nbr by inte(pkdet.line) by pkdet.part by pkdet.lot:
          
          if page-size - line-counter <= 6 then do:
                 put "     " at 4.
                 /*down 1.*/
                 put "发货人:" at 4 /*usr_name format "x(10)"*/ "中转人:" at 34 "收货人:" at 64.
                 put "      " at 4.
                 put "(第一联:仓库存查  第二联:供销科备查  第三联:收货单位留存  第四联:回执  第五联:备用联)" at 4.
                 page.

                 put 
                  
                  "泰 州 吉 泰 毛 纺 织 染 厂" to 51
                   "产 品 发 货 码 单" to 45 skip(1)
                 "编号: QR.03/15.02/004-1998" AT 4     "页号:" + string(page-number - pages,">>9") to 80
                 ad_name  AT 4 "码单号码:" AT 51 pknbr
                 ad_line1 at 4 "货物发往:" AT 51 cm_addr
                 "联系人:" AT 4 ad_attn  custname at 51
                 "TEL:" AT 4 ad_phone "," "FAX:" ad_fax "打印日期:" at 51 effdate_md.
                  
                  /*down.
                  disp pkdet.desc1 @ pkdet.desc1 pkdet.part @ pkdet.part pkdet.lot @ pkdet.lot.*/
          end.
              
          find pt_mstr where pkdet.part = pt_part no-lock no-error.
          disp pkdet.desc1 column-label "品名" format "x(18)" when first-of(pkdet.part) 
               pkdet.part column-label "产品编码" format "x(15)" when first-of(pkdet.part)
                         pkdet.lot column-label "批号" format "x(10)" when first-of(pkdet.lot) pkdet.ref column-label "匹号" /*pkdet.grade*/
                         pt_um pkdet.qtyiss column-label "数量"
                         pkdet.nbr format "x(8)" column-label "订单号" pkdet.line format "x(3)" column-label "项次"                          
                         with width 90 STREAM-IO.
              
              create md_det.
              assign md_nbr = pknbr
                     md_line = mdline
                     md_sonbr = pkdet.nbr
                     md_soline = inte(pkdet.line)
                     md_cust = cust
                     md_part = pkdet.part
                     md_qty_ord = pkdet.qtyiss
                     md_qty_ship = pkdet.qtyiss                           /*eyes,03/07/2002*/
                     md_soprice = pkdet.price
                     md_loc = pkdet.loc
                     md_lot = pkdet.lot
                     md_ref = pkdet.ref
                     md_grade = pkdet.grade
                     md_ord_date = today
                     md__chr01 = "prv".
               mdline = mdline + 1.
         
              total_qty = total_qty + pkdet.qtyiss.                
              if last-of(pkdet.lot) then do:
                  underline pkdet.lot pkdet.qtyiss.
                  disp pkdet.lot + "合计:" @ pkdet.lot total_qty @ pkdet.qtyiss.                  
                  down 1.1.
                  total_qty = 0.
              end.                          
              
              find tr_hist where pkdet.trnbr = tr_trnbr no-error.
              if available tr_hist then assign tr__chr01 = pknbr.
         end. 
         if page-size - line-counter > 5 then do:
            disp "                     " at 4.          
            down page-size - line-counter - 5.
            put "发货人:" at 4 /*usr_name format "x(10)"*/ "中转人:" at 34 "收货人:" at 64.
            put "                " at 4.
            put "(第一联:仓库存查  第二联:供销科备查  第三联:收货单位留存  第四联:回执  第五联:备用联)" at 4.
         end.         
    
    {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
    
         ok_yn = yes.
         {mfmsg01.i 12 1 ok_yn}
         if not ok_yn then undo mainloop,leave. 
    end. 
end.            
        

