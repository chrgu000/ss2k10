/* xxreceiver.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 07/14/01      BY: Kang Jian          */
/* V7   Developped:07/22/02  BY:Kang Jian **use prh__log01 to record if printed(instead of prh_print)** */
/* V9   Developped:02/14/03  BY:Kang Jian ** cmt_det choice and display** */
/*Revision: Eb2 + sp7       Last modified: 08/26/2005             By: Judy Liu   */

{mfdtitle.i}
def var nbr as char .
def var receiver as char.
def var pageno     as INTEGER LABEL "页码：  ". /***页号***/.
def var duplicate  as char.    /***副本***/.
def var bgy        as char. 
def var vendor     as char extent 6.
def var pdate      as date initial TODAY LABEL "打印日期： ".    /***打印日期***/.
def var revision   as char.    /***采购单版本***/.
def var vend_phone as char format "x(20)". /***供应商电话***/
def var rmks       as char format "x(80)". /***备注***/
def var i          as integer.
def var j          as integer.
def var k          as integer.
def var site1      like ptp_site label "地点" initial "DCEC-B".
def var site2      like ptp_site label "至" initial "DCEC-B".
def var nbr_from   as char label "采购单".
def var nbr_to     as char label "至".
def var rcv_from   as char label "收货单".
def var rcv_to     as char label "至".
def var sup_from   as char label "供应商".
def var sup_to     as char label "至".
def var keep1   as char label "保管员".
def var keep2     as char label "至".
def var date_from  as date label "收货日期".
def var date_to    as date label "至".
def var flag1      as logical label "只打印未打印过的收货单".
def var prhqty like prh_rcvd.


form     
     duplicate     no-labels        at 60
     "供应商名称:"  at 1  ad_name  no-labels at 13 
     "页号:" at 60 pageno no-labels at 66
     "打印日期:"   at 1 pdate  no-label at 11
     "收货单号:"   at 30 prh_receiver  no-label at 40
     "收货日期:"   at 60 prh_rcp_date  no-label  at 70
     "供应商:"   at 1 prh_vend no-label at 9
     "采购单:"     at 30 prh_nbr no-label at 38
     "采购单版本:" at 60 revision no-label at 72 
     "电话:"  at 1 vend_phone no-label at 7
     "订单到货期:" at 30  po_due_date no-labels at 42  
     "装箱单:" at 60 prh_ps_nbr  no-label at 68
     "保管员:" at 1 pt_article no-label at 9
     "订单备注:"  at 1 po_rmks   no-label at 11
     "说明文件:" at 1
     with no-box side-labels width 180 frame HEAD-b.    
  FORM    
      skip(1)
     "供应商名称                  ,收货单号  ,  收货日期  ,供应商代码    , 采购单      ,订单到货期  ,零件号            ,零件名称                ,实收数量        ,          发票数量,    序号, 单位   ,事物号     ,保管员        ,"
     with no-box side-labels width 250 frame e1.      
 
/*start format of query screen*/
&SCOPED-DEFINE PP_FRAME_NAME A
FORM      
   RECT-FRAME       AT ROW 1.4 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
   SKIP(.1)  
   nbr_from  colon 20
   nbr_to  colon 40 skip
   rcv_from  colon 20
   rcv_to  colon 40 skip
   sup_from  colon 20 
   sup_to  colon 40 skip
   keep1  colon 20 
   keep2  colon 40 skip
   site1   colon 20
   site2   colon 40 skip
   date_from colon 20
   date_to colon 40 skip
   flag1   colon 24 label "只打印未打印过的收货单"
with frame a side-labels width 80 attr-space NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
   F-a-title = " 选择条件 ".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
   FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.
&UNDEFINE PP_FRAME_NAME	  

{mfguirpa.i true  "printer" 132 }
/*end format of query screen*/

/*start query preference initialize*/
/*start procefuer p-enable-ui*/
procedure p-enable-ui:
   if nbr_to     = hi_char  then nbr_to = "". 
   if rcv_to     = hi_char  then rcv_to = "". 
   if sup_to     = hi_char  then sup_to = "".
   if date_from  = low_date then date_from = ?. 
   if date_to    = hi_date  then date_to = ?.
   if keep2      = hi_char  then keep2 = "". 
     
   run p-action-fields (input "display").
   run p-action-fields (input "enable").
end procedure. 
/*end procefuer p-enable-ui*/
/*end query preference initialize*/

/*start procedure of p-report-quote*/
/*start receive query preference*/
procedure p-report-quote:
   bcdparm = "".
   {mfquoter.i nbr_from} 
   {mfquoter.i nbr_to} 
   {mfquoter.i rcv_from} 
   {mfquoter.i rcv_to} 
   {mfquoter.i sup_from} 
   {mfquoter.i sup_to} 
   {mfquoter.i keep1} 
   {mfquoter.i keep2} 
   {mfquoter.i date_from} 
   {mfquoter.i date_to} 
   {mfquoter.i flag1} 
/*end receive query preference*/

/*start check the validity of query preference*/
   if nbr_to     = ""  then nbr_to = hi_char. 
   if rcv_to     = ""  then rcv_to = hi_char. 
   if sup_to     = ""  then sup_to = hi_char. 
   if date_from  = ?   then date_from = low_date. 
   if date_to    = ?   then date_to = hi_date.
   if keep2     = ""  then keep2 = hi_char. 
/*end check the validity of query preference*/
end procedure. 
/*end procedure of p-report-quote*/

/*end query  preference */

/*start procedure of p-report*/
/*start report out put*/
procedure p-report:
  {gpprtrpa.i  "window" 132}                               
/* disp   "----------------------------以下开始打印入库单---------------------------------------------------" at 1 with width 250 no-box frame g2.*/
form "DCP-03-17-00-02 F002" skip(1)
     "入库单 "      at 33 
     with no-box side-labels width 180 frame b.
   pageno = 1.
   i = 1.
   j = 1.
   for each prh_hist no-lock  where (prh_nbr >= nbr_from) 
                                        and (prh_nbr <= nbr_to) 
                                        and (prh_receiver >= rcv_from) 
                                        and (prh_receiver <= rcv_to) 
                                        and (prh_vend >= sup_from) 
                                        and (prh_vend <= sup_to) 
                                        and (prh_site >= site1)
                                        and (prh_site <= site2)
                                        and (prh_rcp_date >= date_from) 
                                        and (prh_rcp_date <= date_to)
                                        and (prh__log01 = no or not flag1) 
                                        and (prh_rcp_type <> "R")                                        
                                        USE-INDEX prh_receiver break by prh_receiver by prh_line:
     find first tr_hist where tr_part=prh_part and tr_nbr=prh_nbr and tr_line=prh_line and tr_type="rct-po" and tr_lot=prh_receiver no-lock no-error.
    
     if available tr_hist then do:
        find first po_mstr where po_nbr=prh_nbr no-lock no-error.                             
        find first ad_mstr where ad_addr = prh_vend no-lock no-error.
        find first pod_det where pod_nbr = prh_nbr and pod_line = prh_line no-lock no-error.
        find first pt_mstr where pt_part = prh_part no-lock no-error.
        find first ptp_det where ptp_part = prh_part and ptp_site >=site1 and ptp_site <= site2 no-lock no-error.
        if available ptp_det and pod_type <>"S" and pod_type<>"M"  then DO:
           if  i = 1  then do:
             IF  prh__log01 = yes then 
                duplicate="**副本".
             ELSE
                duplicate = "原本".
             DISP WITH FRAME B.
             find first in_mstr where in_part = prh_part AND IN_site = prh_site and in__qadc01 >= keep1 and in__qadc01 <= keep2  no-lock no-error.
             if not available in_mstr then do:
                next. 
             end.
             bgy = in__qadc01.
             bgy="".                 
             find first po_mstr where po_nbr = prh_nbr no-lock no-error.
             disp with frame e1.
           end.
           i = i + 1.
           disp ad_name format "x(30)" ", " prh_receiver format "x(8)" "," prh_rcp_date "," prh_vend "," prh_nbr "," po_due_date "," prh_part "," 
               pt_desc2  format "x(20)" ","  prh_rcvd format "->>>>>>>>9.99" ","  prh_ps_qty format "->>>>>>>>>9.99" ","  prh_line format ">>>>" "," prh_um format "x(2)" "," tr_trnbr "," in__qadc01 "," with no-box no-labels width 250.                                 
           j = 0.
           if line-counter >= (page-size - 4)  then do:
                /*disp  pageno at 100  pdate at 120  with SIDE-LABEL no-box width 250.*/
                page.
                pageno = pageno + 1.
                i = 1.
                j = 1. 
           end.
        end.
     end. 
  end. 
  if J = 0 then do:
     /*disp    pageno at 100  pdate at 120 with  SIDE-LABEL no-box width 250 .*/
     page.
     j = 1. 
  end.
/* disp   "----------------------------以下开始打印委托加工入库单(类型Pod_type="S")打印---------------------------------------------------" at 1 with width 250 no-box frame g2.*/
  form "DCP-03-17-00-02 F002" skip(1)
      "入库单"      at 33    
     "标注:委托加工件入库单据" at 1      
       with no-box side-labels width 180 frame wt2.    
    
  j = 1.    
  for each prh_hist no-lock  where (prh_nbr >= nbr_from) 
                                        and (prh_nbr <= nbr_to) 
                                        and (prh_receiver >= rcv_from) 
                                        and (prh_receiver <= rcv_to) 
                                        and (prh_vend >= sup_from) 
                                        and (prh_vend <= sup_to) 
                                        and (prh_rcp_date >= date_from) 
                                        and (prh_rcp_date <= date_to)
                                        and (prh_rcp_type <> "R")
                                        use-index prh_receiver  
                                        break by prh_receiver by prh_line:
     find first tr_hist where tr_part=prh_part and tr_nbr=prh_nbr and tr_line=prh_line and tr_type="rct-po" and tr_lot=prh_receiver no-lock no-error.
     if available tr_hist then do:                                        
           find first po_mstr where po_nbr=prh_nbr no-lock no-error.                            
           find first ad_mstr where ad_addr = prh_vend no-lock no-error.
           find first pod_det where pod_nbr = prh_nbr and pod_line = prh_line and pod_type="S" no-lock no-error.
           find first pt_mstr where pt_part = prh_part /*and pt_article >=keep1 and pt_article <=keep2*/ no-lock no-error.  
           find first in_mstr where in_part = prh_part AND in_site = prh_site and in__qadc01 >= keep1 and in__qadc01 <= keep2 no-lock no-error.
                if not available tr_hist then do:
                     next.
                     end.
           if (available pt_mstr)  and (available pod_det) then do:
              if  j = 1  then do:
                 if  prh__log01 = yes then               
                   duplicate="**副本".
                 else
                   duplicate = "原本" .
                 disp with frame wt2.               
                 find first po_mstr where po_nbr = prh_nbr no-lock no-error.
                 find first cmt_det where (cmt_indx = po_cmtindx  ) no-lock no-error.
                 disp with frame e1.
              end.
              j = j + 1.
              if available pt_mstr then 
                 disp ad_name format "x(30)" ", " prh_receiver format "x(8)" "," prh_rcp_date "," prh_vend "," prh_nbr "," po_due_date "," prh_part "," 
                     pt_desc2  format "x(20)" ","  prh_rcvd format "->>>>>>>>9.99" ","  prh_ps_qty format "->>>>>>>>>9.99" ","  prh_line format ">>>>" "," prh_um format "x(2)" "," tr_trnbr "," in__qadc01 "," with no-box no-labels width 250.
              else
                 disp ad_name format "x(30)" ", " prh_receiver format "x(8)" "," prh_rcp_date "," prh_vend "," prh_nbr "," po_due_date "," prh_part "," 
                     pt_desc2  format "x(20)" ","  prh_rcvd format "->>>>>>>>9.99" ","  prh_ps_qty format "->>>>>>>>>9.99" ","  prh_line format ">>>>" "," prh_um format "x(2)" "," tr_trnbr "零件号不存在," in__qadc01 "," with no-box no-labels width 250.  
              if line-counter  >= (page-size - 4)  then do:
                 /*disp "采购员：               质检员：                保管员：              供应商："   at 1
                 with width 250 no-box frame dw2.*/
                 page.
                 pageno = pageno + 1.
                 j = 1.
              end.
              if last-of(prh_receiver) then do:
                 pageno = 1.  
                 page.
              end.
           end.
      end. /* end of tr_hist */
  end. /*end of for each prh_hist...*/   
/* disp   "----------------------------以下开始打印M类型入库单打印---------------------------------------------------" at 1 with width 250 no-box frame g2.*/
  form "DCP-03-17-00-02 F002" skip(1)
     "入库单"  at 33  skip(1)
     "标注:M类型的入库单据" at 1      
       with no-box side-labels width 180 frame bM2.    
  j = 1.    
  for each prh_hist no-lock  where (prh_nbr >= nbr_from) 
                                        and (prh_nbr <= nbr_to) 
                                        and (prh_receiver >= rcv_from) 
                                        and (prh_receiver <= rcv_to) 
                                        and (prh_vend >= sup_from) 
                                        and (prh_vend <= sup_to) 
                                        and (prh_rcp_date >= date_from) 
                                        and (prh_rcp_date <= date_to)
                                        and (prh_rcp_type <> "R")
                                        use-index prh_receiver  
                                        break by prh_receiver by prh_line:
     find first tr_hist where tr_part=prh_part and tr_nbr=prh_nbr and tr_line=prh_line and tr_type="rct-po" and tr_lot=prh_receiver no-lock no-error.
     if available tr_hist then do:
           find first po_mstr where po_nbr=prh_nbr no-lock no-error.                             
           find first ad_mstr where ad_addr = prh_vend no-lock no-error.
           find first pod_det where pod_nbr = prh_nbr and pod_line = prh_line and (pod_type="M" or pod_type="m") no-lock no-error.
           find first pt_mstr where pt_part = prh_part no-lock no-error.           
           if (available pt_mstr)  and (available pod_det) then do:
              if  j = 1  then do:
                  if prh__log01 = yes then
                     duplicate="**副本".
                  else 
                     duplicate = "原本".
                  disp with frame bw2.
                  find first po_mstr where po_nbr = prh_nbr no-lock no-error.
                  if available po_mstr and po_cmtindx <> 0 then DO:
                  find first cmt_det where cmt_indx = po_cmtindx  no-lock no-error.
                  disp with frame e1.
              end.
              j = j + 1.
              if available pt_mstr then 
                 disp ad_name format "x(30)" ", " prh_receiver format "x(8)" "," prh_rcp_date "," prh_vend "," prh_nbr "," po_due_date "," prh_part "," 
                     pt_desc2  format "x(20)" ","  prh_rcvd format "->>>>>>>>9.99" ","  prh_ps_qty format "->>>>>>>>>9.99" ","  prh_line format ">>>>" "," prh_um format "x(2)" "," tr_trnbr "," in__qadc01 "," with no-box no-labels width 250.
              else
                 disp ad_name format "x(30)" ", " prh_receiver format "x(8)" "," prh_rcp_date "," prh_vend "," prh_nbr "," po_due_date "," prh_part "," 
                     pt_desc2  format "x(20)" ","  prh_rcvd format "->>>>>>>>9.99" ","  prh_ps_qty format "->>>>>>>>>9.99" ","  prh_line format ">>>>" "," prh_um format "x(2)" "," tr_trnbr "零件号不存在," in__qadc01 "," with no-box no-labels width 250.                                   
              if line-counter  >= (page-size - 4) or last-of(prh_receiver) then do:
                 /*disp "采购员：               质检员：                保管员：              供应商："   at 1
                 with width 250 no-box frame dm2.*/
                 page.
                 pageno = pageno + 1.
                 j = 1.
              end.
              if last-of(prh_receiver) then do:
                 pageno = 1.  
                 page.
              end.
           end.
           END.
     end. /* end of tr_hist */       
  end. /*end of for each prh_hist...*/   
   
   
  /* disp   "----------------------------以下开始打印检验通知单---------------------------------------------------" at 1 with width 250 no-box frame gw2.*/
  form "DCP-03-06-01-00 F001" skip(1)
     "送检通知单"      at 33    skip(1)   
     with no-box side-labels width 180 frame b2.       
  FORM    
      skip(1)
     "供应商名称                  ,收货单号  ,  收货日期  ,供应商代码    , 采购单      ,订单到货期  ,零件号            ,零件名称                ,送检数量         ,          发票数量,    序号, 单位   ,事物号     ,保管员        ,"
     with no-box side-labels width 250 frame e6.     
  j = 1.    
  for each prh_hist no-lock  where (prh_nbr >= nbr_from) 
                                        and (prh_nbr <= nbr_to) 
                                        and (prh_receiver >= rcv_from) 
                                        and (prh_receiver <= rcv_to) 
                                        and (prh_vend >= sup_from) 
                                        and (prh_vend <= sup_to) 
                                        and (prh_site >= site1)
                                        and (prh_site <= site2)
                                        and (prh_site <> "dcec-b")
                                        and (prh_site <> "dcec-c")
                                        and (prh_rcp_date >= date_from) 
                                        and (prh_rcp_date <= date_to)
                                        and (prh_rcp_type <> "R")
                                        use-index prh_receiver  
                                        break by prh_receiver by prh_line:
     find first tr_hist where tr_part=prh_part and tr_nbr=prh_nbr and tr_line=prh_line and tr_type="rct-po" and tr_lot=prh_receiver no-lock no-error.
     if available tr_hist then do:
           find first po_mstr where po_nbr=prh_nbr no-lock no-error.                             
           find first ad_mstr where ad_addr = prh_vend no-lock no-error.
           find first pod_det where pod_nbr = prh_nbr and pod_line = prh_line no-lock no-error.
           find first pt_mstr where pt_part = prh_part no-lock no-error.
           find first in_mstr where in_part = prh_part AND in_site = prh_site and in__qadc01 >= keep1 and in__qadc01 <= keep2 no-lock no-error.
                if not available tr_hist then do:
                     next.
                     end.
           find first ptp_det where ptp_part = prh_part and Ptp_site >= site1 and ptp_site <= site2 no-lock no-error.
           
           if ((not(available pt_mstr)) or ((available ptp_det and ptp_INS_RQD = yes))) and pod_type <>"S" and pod_type<>"s" and pod_type <>"m" and pod_type<>"M" then do:
              if  j = 1  then do: 
                if prh__log01 = yes then 
                   duplicate="**副本".
                else   
                 duplicate = "原本" .
                disp with frame b2.
                find first po_mstr where po_nbr = prh_nbr no-lock no-error.
                disp with frame e6.
              end.
              j = j + 1.
              if available pt_mstr then 
                 disp ad_name format "x(30)" ", " prh_receiver format "x(8)" "," prh_rcp_date "," prh_vend "," prh_nbr "," po_due_date "," prh_part "," 
                     pt_desc2  format "x(20)" ","  prh_rcvd format "->>>>>>>>9.99" ","  prh_ps_qty format "->>>>>>>>>9.99" ","  prh_line format ">>>>" "," prh_um format "x(2)" "," tr_trnbr "," in__qadc01 "," with no-box no-labels width 250.
              else
                 disp ad_name format "x(30)" ", " prh_receiver format "x(8)" "," prh_rcp_date "," prh_vend "," prh_nbr "," po_due_date "," prh_part "," 
                     pt_desc2  format "x(20)" ","  prh_rcvd format "->>>>>>>>9.99" ","  prh_ps_qty format "->>>>>>>>>9.99" ","  prh_line format ">>>>" "," prh_um format "x(2)" "," tr_trnbr "零件号不存在," in__qadc01 "," with no-box no-labels width 250.                                 
              if line-counter  >= (page-size - 4)  then do:
                 /*disp "采购员：               质检员：                保管员：              供应商："   at 1
                 with width 250 no-box frame d2.*/
                 page.
                 pageno = pageno + 1.
                 j = 1.
              end.
              if last-of(prh_receiver) then do:
                 pageno = 1.  
                 page.
              end.
           end.
     end. /* end of tr_hist */
  end. /*end of for each prh_hist...*/   
  /* disp   "----------------------------以下开始打印采购退货单---------------------------------------------------" at 1 with width 250 no-box frame g2.*/
  form "采购退货单 "      at 33  skip(1)
     duplicate     no-labels        at 60
     with no-box side-labels width 180 frame b3.    
  FORM    
      skip(1)
     "供应商名称                  ,收货单号  ,  收货日期  ,供应商代码    , 采购单      ,订单到货期  ,零件号            ,零件名称                ,退货数量        ,          发票数量,    序号, 单位   ,事物号     ,保管员        ,"  
     with no-box side-labels width 250 frame e5.     
      
  j = 1.    
  for each prh_hist no-lock  where (prh_nbr >= nbr_from) 
                                        and (prh_nbr <= nbr_to) 
                                        and (prh_receiver >= rcv_from) 
                                        and (prh_receiver <= rcv_to) 
                                        and (prh_vend >= sup_from) 
                                        and (prh_vend <= sup_to) 
                                        and (prh_rcp_date >= date_from)
                                        and (prh_rcp_date <= date_to)
                                        and (prh_rcp_type = "R")
                                        use-index prh_receiver  
                                        break by prh_receiver by prh_line:
     find first tr_hist where tr_part=prh_part and tr_nbr=prh_nbr and tr_line=prh_line and tr_type="iss-prv" and tr_lot=prh_receiver no-lock no-error.
     if available tr_hist then do:
           find first po_mstr where po_nbr=prh_nbr no-lock no-error.                             
           find first ad_mstr where ad_addr = prh_vend no-lock no-error.
           find first pod_det where pod_nbr = prh_nbr and pod_line = prh_line no-lock no-error.
           find first pt_mstr where pt_part = prh_part no-lock no-error.
              if  j = 1  then do:
                 if prh__log01 = yes then 
                   duplicate="**副本".
                 else
                   duplicate = "原本" .
                 disp with frame b3.
                 find first po_mstr where po_nbr = prh_nbr no-lock no-error.
                 disp with frame e5.
              end.
              j = j + 1.
              prhqty = 0 - prh_rcvd.
              if available pt_mstr then           
                 disp ad_name format "x(30)" ", " prh_receiver format "x(8)" "," prh_rcp_date "," prh_vend "," prh_nbr "," po_due_date "," prh_part "," 
                     pt_desc2  format "x(20)" ","   prhqty format "->>>>>>>>9.99" ","  prh_ps_qty format "->>>>>>>>>9.99" ","  prh_line format ">>>>" "," prh_um format "x(2)" "," tr_trnbr "," in__qadc01 "," with no-box no-labels width 250.
              ELSE
                 disp ad_name format "x(30)" ", " prh_receiver format "x(8)" "," prh_rcp_date "," prh_vend "," prh_nbr "," po_due_date "," prh_part "," 
                     pt_desc2  format "x(20)" ","   prhqty format "->>>>>>>>9.99" ","  prh_ps_qty format "->>>>>>>>>9.99" ","  prh_line format ">>>>" "," prh_um format "x(2)" "," tr_trnbr "零件号不存在," in__qadc01 "," with no-box no-labels width 250.                 
              if line-counter  >= (page-size - 4) then do:
                 /*disp "采购员：               质检员：                保管员：              供应商："   at 1
                 with width 250 no-box frame d3 .*/
                 page.
                 pageno = pageno + 1.
                 j = 1.
              end.
              if last-of(prh_receiver) then do:
                 pageno = 1.  
                 page.
              end.
     end. 
  end.    
  

 /* reset variable */
  {mfreset.i}
  {mfgrptrm.i} 

/*Report-to-Window*/

      for each prh_hist  where (prh_nbr >= nbr_from) 
                                        and (prh_nbr <= nbr_to) 
                                        and (prh_receiver >= rcv_from) 
                                        and (prh_receiver <= rcv_to) 
                                        and (prh_vend >= sup_from) 
                                        and (prh_vend <= sup_to) 
                                        and (prh_rcp_date >= date_from) 
                                        and (prh_rcp_date <= date_to)
                                        and (prh__log01 = no or not flag1) 
                                        USE-INDEX prh_receiver
                                        break by prh_receiver by prh_line:
          find first in_mstr where in_part = prh_part AND in_site = prh_site 
               and in__qadc01 >= keep1 and in__qadc01 <= keep2 no-lock no-error.
                if not available tr_hist then do:
                     next.
                     end.
                                        prh__log01 = yes.      
                                         
       end.        

end. /*end of the procedure*/
{mfguirpb.i &flds="nbr_from nbr_to rcv_from rcv_to sup_from sup_to keep1 keep2 site1 site2 date_from date_to flag1 "}




