/* xxreceiver.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 07/14/01      BY: Kang Jian          */
/* V7   Developped:07/22/02  BY:Kang Jian **use prh__log01 to record if printed(instead of prh_print)** */
/* V9   Developped:02/14/03  BY:Kang Jian ** cmt_det choice and display** */
/*Revision: Eb2 + sp7       Last modified: 07/28/2005             By: Judy Liu   */

{mfdtitle.i "121002.1"}
def var nbr as char .
def var receiver as char.
def var pageno     as integer. /***页号***/.
def var duplicate  as char.    /***副本***/.
def var vendor     as char extent 6.
def var pdate      as date initial today.    /***打印日期***/.
def var revision   as char.    /***采购单版本***/.
def var vend_phone as char format "x(20)". /***供应商电话***/
def var rmks       as char format "x(80)". /***备注***/
def var i          as integer.
def var j          as integer.
def var k          as integer.
def var site1      like ptp_site label "地点" initial "DCEC-B".
def var site2      like ptp_site label "至" initial "DCEC-B".
DEF VAR userid1      LIKE tr_userid LABEL "用户".
DEF VAR userid2      LIKE tr_userid LABEL "至".
def var nbr_from   as char label "采购单".
def var nbr_to     as char label "至".
def var rcv_from   as char label "收货单".
def var rcv_to     as char label "至". 
def var sup_from   as char label "供应商".
def var sup_to     as char label "至".
def var date_from  as date label "收货日期".
def var date_to    as date label "至".
def var flag1      as logical label "只打印未打印过的收货单".
def var prhqty like prh_rcvd.

/*judy 05/07/28*/ DEFINE VARIABLE keeper AS CHAR.
/*judy 05/07/28*/ DEFINE VARIABLE keeper1 AS CHAR.
     
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
     "接收用户:" at 1 userid1 no-label at 9
     "订单备注:"  at 1 po_rmks   no-label at 11
     "说明文件:" at 1
     with no-box side-labels width 180 frame HEAD-b.    
  FORM    
      skip(1)
/*judy 05/07/28*/ /*     "零件号            零件名称               日期    实收数量   发票数量 序号 单位 到货期      事物号   "*/
/*judy 05/07/28*/    "零件号            零件名称               日期    实收数量   发票数量 序号 单位 到货期      事物号   保管员  " 
     skip "-----------------------------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame e1.     
 
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
   site1   colon 20
   site2   colon 40 skip
   date_from colon 20
   date_to colon 40 skip
/*judy 05/07/28*/    keeper COLON 20
/*judy 05/07/28*/   keeper1 COLON 40 LABEL {t001.i} SKIP 
    /*judy 05/07/28*/    userid1 COLON 20
/*judy 05/07/28*/   userid2 COLON 40 LABEL {t001.i} SKIP 
   flag1   colon 24 label "只打印未打印过的收货单"
/*judy 05/07/28*/ SKIP (.4)
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
   /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).
/*K0ZX*/ {wbrp01.i}
             
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
/*judy 05/07/28*/  IF keeper1 = hi_char THEN keeper1 = "".
   IF userid2 = hi_char THEN userid2 ="".
         
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
   {mfquoter.i date_from} 
   {mfquoter.i date_to} 
/*judy 05/07/28*/ {mfquoter.i keeper}
/*judy 05/07/28*/  {mfquoter.i keeper1}
/*judy 05/07/28*/ {mfquoter.i userid1}
/*judy 05/07/28*/  {mfquoter.i userid2}
     {mfquoter.i flag1} 
/*end receive query preference*/

/*start check the validity of query preference*/
   if nbr_to     = ""  then nbr_to = hi_char. 
   if rcv_to     = ""  then rcv_to = hi_char. 
   if sup_to     = ""  then sup_to = hi_char. 
   if date_from  = ?   then date_from = low_date. 
   if date_to    = ?   then date_to = hi_date.
/*judy 05/07/28*/   IF keeper1 = "" THEN keeper1 = hi_char.
IF userid2 ="" THEN userid2 = hi_char.
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
   for each prh_hist no-lock  where prh_domain = global_domain 
                               and (prh_nbr >= nbr_from) 
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
                               and (prh_rcp_type <> "R")  USE-INDEX prh_receiver
/*judy 05/07/28*//*  EACH IN_mstr WHERE in_domain = global_domain and IN_part = prh_part AND IN_site = prh_site 
/*judy 05/07/28*/     AND  in__qadc01 >= keeper AND in__qadc01 <= keeper1 NO-LOCK  */
                                        break by prh_receiver by prh_line :
IF NOT (keeper =  " " AND  keeper1 =  hi_char) THEN DO:
         /*   MESSAGE "AA" xxkeeper xxkeeper1.
            PAUSE.*/
             FIND FIRST in_mstr where in_domain = global_domain 
                    and in_site = prh_site and in_part = prh_part
            and in__qadc01 >= keeper and in__qadc01 <= keeper1 NO-LOCK NO-ERROR.
             IF NOT AVAIL IN_mstr  THEN NEXT.
  END.

     find first tr_hist where tr_domain = global_domain 
            and tr_part=prh_part and tr_nbr=prh_nbr and tr_line=prh_line 
            and tr_type="rct-po" and tr_lot=prh_receiver 
            AND tr_userid>= userid1 AND tr_userid<=userid2 no-lock no-error.
     if available tr_hist then do:
        find first po_mstr where po_domain = global_domain 
               and po_nbr=prh_nbr no-lock no-error.                             
        find first ad_mstr where ad_domain = global_domain 
               and ad_addr = prh_vend no-lock no-error.
        find first pod_det where pod_domain = global_domain 
               and pod_nbr = prh_nbr and pod_line = prh_line no-lock no-error.
        find first pt_mstr where pt_domain = global_domain 
               and pt_part = prh_part no-lock no-error.
        find first ptp_det where ptp_domain = global_domain 
               and ptp_part = prh_part /* and ptp_ins_rqd = no*/ 
               and ptp_site >=site1 and ptp_site <= site2 no-lock no-error.
        if available ptp_det and pod_type <>"S" and pod_type<>"M"  then DO:
           if  i = 1  then do:
             IF  prh__log01 = yes then 
                duplicate="**副本".
             ELSE
                duplicate = "原本".
             DISP WITH FRAME B.
/*judy 05/07/28*/ /*  find first in_mstr where in__domain = global_domain and 
																 in_part = prh_part no-lock no-error.*/
             disp duplicate ad_name pageno  pdate prh_receiver prh_rcp_date prh_vend prh_nbr revision 
                   vend_phone po_due_date prh_ps_nbr  
/*judy 05/07/28*/ /*  in__qadc01 @ pt_article*/
                  po_rmks at 1 with frame HEAD-b.                   
             find first po_mstr where po_domain = global_domain 
                    and po_nbr = prh_nbr no-lock no-error.
             if available po_mstr and po_cmtindx <> 0 then DO:
                   find first cmt_det where cmt_domain = global_domain 
                         and (cmt_indx = po_cmtindx ) no-lock no-error.
                   repeat:
                    if cmt_indx <> po_cmtindx then leave.                    
                    if available cmt_det and lookup("rc",cmt_print) > 0 then
                      do k = 1 to 15 :
                       if  cmt_cmmt[k] <> "" then do :
                          display  cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                          down 1.
                       end.
                      end.
                     find next cmt_det use-index cmt_ref NO-LOCK WHERE cmt_domain = global_domain no-error.                     
                    end.
                /* find cmt_det where cmt_domain = global_domain 
                    and cmt_indx = po_cmtindx no-lock no-error.
                 if available cmt_det and lookup("rc",cmt_print) > 0 then
                  do k = 1 to 15 :
                    if  cmt_cmmt[k] <> "" then do :
                       display cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                       down 1.
                    end.
                  end.*/
             end.
             disp with frame e1.
           end.
           i = i + 1.
          FIND FIRST  in_mstr where in_domain = global_domain 
                  and in_site = prh_site and in_part = prh_part NO-LOCK NO-ERROR.

           disp prh_part pt_desc2 format "x(20)" prh_rcp_date prh_rcvd format "->>>>>>>>9.999" 
               prh_ps_qty format "->>>>>>>>>9.999"  prh_line format ">>>>" prh_um format "x(2)" 
               pod_due_date tr_trnbr "  "
/*judy 05/07/28*/ in__qadc01 WHEN AVAIL IN_mstr   with no-box no-labels width 250 frame c1 down.

           if available pod_det and pod_cmtindx <>0 then do:
                   find first cmt_det where cmt_domain = global_domain 
                         and (cmt_indx = pod_cmtindx  ) no-lock no-error.
                   repeat:
                    if cmt_indx <> pod_cmtindx then leave.                    
                    if available cmt_det and lookup("rc",cmt_print) > 0 then
                      do k = 1 to 15 :
                       if  cmt_cmmt[k] <> "" then do :
                          display  cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                          down 1.
                       end.
                      end.
                     find next cmt_det use-index cmt_ref NO-LOCK WHERE cmt_domain = global_domain no-error.                     
                    end.

 /*              find cmt_det where cmt_domain = global_domain 
                  and cmt_indx = pod_cmtindx no-lock no-error.
                 if available cmt_det and lookup("rc",cmt_print) > 0 then
                 do k = 1 to 15 :
                    if  cmt_cmmt[k] <> "" then do :
                       display cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                       down 1.
                    end.
                 end.*/
           end.
           disp   "-----------------------------------------------------------------------------------------------------------"   at 1
           with width 250 no-box frame f.                                  
           j = 0.
           if line-counter >= (page-size - 4) or last-of(prh_receiver) then do:
                disp "采购员：               质检员：                保管员：              供应商："  
                     at 1  with width 250 no-box frame d.
                page.
                pageno = pageno + 1.
                i = 1.
                j = 1.
           end.
        end.
     end. /*end of tr_hist */
  end. /* end of each */
  if J = 0 then do:
     disp "采购员：               质检员：                保管员：              供应商："  
          at 1  with width 250 no-box frame dj.
     page.
     j = 1.
  end.
/* disp   "----------------------------以下开始打印委托加工入库单(类型Pod_type="S")打印---------------------------------------------------" at 1 with width 250 no-box frame g2.*/
  form "DCP-03-17-00-02 F002" skip(1)
      "入库单"      at 33    
     "标注:委托加工件入库单据" at 1      
       with no-box side-labels width 180 frame wt2.    
    
  j = 1.    
  for each prh_hist no-lock  where prh_domain = global_domain 
                              and (prh_nbr >= nbr_from) 
                              and (prh_nbr <= nbr_to) 
                              and (prh_receiver >= rcv_from) 
                              and (prh_receiver <= rcv_to) 
                              and (prh_vend >= sup_from) 
                              and (prh_vend <= sup_to) 
                              and (prh_rcp_date >= date_from) 
                              and (prh_rcp_date <= date_to)
                              and (prh_rcp_type <> "R")
                              use-index prh_receiver  
      /*,
/*judy 05/07/28*/  EACH IN_mstr WHERE in_domain = global_domain 
                    and IN_part = prh_part AND IN_site = prh_site 
/*judy 05/07/28*/   AND in__qadc01 >= keeper AND in__qadc01 <= keeper1 NO-LOCK  */
                                        break by prh_receiver by prh_line:

      IF NOT (keeper =  " " AND  keeper1 =  hi_char) THEN DO:
               /*   MESSAGE "AA" xxkeeper xxkeeper1.
                  PAUSE.*/
                   FIND FIRST in_mstr where in_domain = global_domain 
                          and in_site = prh_site and in_part = prh_part
                    and in__qadc01 >= keeper and in__qadc01 <= keeper1 NO-LOCK NO-ERROR.
                   IF NOT AVAIL IN_mstr  THEN NEXT.
        END.

     find first tr_hist where tr_domain = global_domain 
            and tr_part=prh_part and tr_nbr=prh_nbr and tr_line=prh_line 
            and tr_type="rct-po" and tr_lot=prh_receiver AND tr_userid>= userid1 
            AND tr_userid<=userid2 no-lock no-error.
     if available tr_hist then do:                                        
           find first po_mstr where po_domain = global_domain 
                  and po_nbr=prh_nbr no-lock no-error.                            
           find first ad_mstr where ad_domain = global_domain 
                  and ad_addr = prh_vend no-lock no-error.
           find first pod_det where pod_domain = global_domain 
                  and pod_nbr = prh_nbr and pod_line = prh_line 
                  and pod_type="S" no-lock no-error.
           find first pt_mstr where pt_domain = global_domain 
                  and pt_part = prh_part no-lock no-error.           
           if (available pt_mstr)  and (available pod_det) then do:
              if  j = 1  then do:
                 if  prh__log01 = yes then               
                   duplicate="**副本".
                 else
                   duplicate = "原本" .
                 disp with frame wt2.               
                 disp duplicate  ad_name pageno pdate prh_receiver prh_rcp_date prh_vend prh_nbr revision
                   vend_phone po_due_date prh_ps_nbr 
                /*judy 05/07/28*/ /*  pt_article  */ po_rmks at 1 with frame head-b.
                 find first po_mstr where po_domain = global_domain 
                        and po_nbr = prh_nbr no-lock no-error.
                 if available po_mstr and po_cmtindx <> 0 then DO:
                  find first cmt_det where cmt_domain = global_domain 
                        and (cmt_indx = po_cmtindx  ) no-lock no-error.
                  repeat:
                    if cmt_indx <> po_cmtindx then leave.                    
                    if available cmt_det and lookup("rc",cmt_print) > 0 then
                      do k = 1 to 15 :
                       if  cmt_cmmt[k] <> "" then do :
                          display  cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                          down 1.
                       end.
                      end.
                     find next cmt_det use-index cmt_ref WHERE cmt_domain = GLOBAL_domain no-lock.                     
                    end.                
                 end.
                 disp with frame e1.
              end.
              j = j + 1.
              FIND FIRST  in_mstr where in_domain = global_domain 
                      and in_site = prh_site and in_part = prh_part NO-LOCK NO-ERROR.
              if available pt_mstr then 
                 disp prh_part pt_desc2 format "x(20)" prh_rcp_date prh_rcvd format "->>>>9.999" prh_ps_qty format "->>>>9.999"  
                        prh_line format ">>>>" prh_um format "x(2)" pod_due_date tr_trnbr  "  "
/*judy 05/07/28*/ in__qadc01  WHEN AVAIL IN_mstr  with no-box no-labels width 250 frame cw3 down.
              else
                 disp prh_part pt_desc2 format "x(20)" prh_rcp_date prh_rcvd format "->>>>9.999" prh_ps_qty format "->>>>9.999"  
                        prh_line format ">>>>" prh_um format "x(2)" pod_due_date  tr_trnbr "零件号不存在"  " "
/*judy 05/07/28*/ in__qadc01 WHEN AVAIL IN_mstr  with no-box no-labels width 250 frame cw4 down.
              if available pod_det  and pod_cmtindx <>0 then do:
                 find first cmt_det where cmt_domain = global_domain 
                        and cmt_indx = pod_cmtindx no-lock no-error.
                  repeat:
                    if cmt_indx <> pod_cmtindx then leave.                    
                    if available cmt_det and lookup("rv",cmt_print) > 0 then
                      do k = 1 to 15 :
                       if  cmt_cmmt[k] <> "" then do :
                          display  cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                          down 1.
                       end.
                      end.
                     find next cmt_det use-index cmt_ref NO-LOCK WHERE cmt_domain = global_domain NO-ERROR.                     
                    end.
              end.
              DISP  "-----------------------------------------------------------------------------------------------------------"  at 1
                 with width 250 no-box frame fw2.                                   
              if line-counter  >= (page-size - 4) or last-of(prh_receiver) then do:
                 disp "采购员：               质检员：                保管员：              供应商："   at 1
                 with width 250 no-box frame dw2.
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
  for each prh_hist no-lock  where prh_domain = global_domain 
                              and (prh_nbr >= nbr_from) 
                              and (prh_nbr <= nbr_to) 
                              and (prh_receiver >= rcv_from) 
                              and (prh_receiver <= rcv_to) 
                              and (prh_vend >= sup_from) 
                              and (prh_vend <= sup_to) 
                              and (prh_rcp_date >= date_from) 
                              and (prh_rcp_date <= date_to)
                              and (prh_rcp_type <> "R")
                              use-index prh_receiver /*  ,
/*judy 05/07/28*/  EACH IN_mstr WHERE in_domain = global_domain 
                    and IN_part = prh_part AND IN_site = prh_site 
/*judy 05/07/28*/     AND  in__qadc01 >= keeper AND in__qadc01 <= keeper1 NO-LOCK     */
                                        break by prh_receiver by prh_line:
IF NOT (keeper =  " " AND  keeper1 =  hi_char) THEN DO:
         /*   MESSAGE "AA" xxkeeper xxkeeper1.
            PAUSE.*/
             FIND FIRST in_mstr where in_domain = global_domain 
                    and in_site = prh_site and in_part = prh_part
            and in__qadc01 >= keeper and in__qadc01 <= keeper1 NO-LOCK NO-ERROR.
             IF NOT AVAIL IN_mstr  THEN NEXT.
  END.

     find first tr_hist where tr_domain = global_domain 
            and tr_part=prh_part and tr_nbr=prh_nbr and tr_line=prh_line 
            and tr_type="rct-po" and tr_lot=prh_receiver AND tr_userid>= userid1 
            AND tr_userid<=userid2 no-lock no-error.
     if available tr_hist then do:
           find first po_mstr where po_domain = global_domain 
                  and po_nbr=prh_nbr no-lock no-error.                             
           find first ad_mstr where ad_domain = global_domain 
                  and ad_addr = prh_vend no-lock no-error.
           find first pod_det where pod_domain = global_domain 
           			  and pod_nbr = prh_nbr and pod_line = prh_line 
           			  and (pod_type="M" or pod_type="m") no-lock no-error.
           find first pt_mstr where pt_domain = global_domain 
           			  and pt_part = prh_part no-lock no-error.           
           if (available pt_mstr)  and (available pod_det) then do:
              if  j = 1  then do:
                  if prh__log01 = yes then
                     duplicate="**副本".
                  else 
                     duplicate = "原本".
                  disp with frame bw2.
                  disp duplicate ad_name pageno pdate prh_receiver prh_rcp_date prh_vend prh_nbr revision
                   vend_phone po_due_date prh_ps_nbr 
      /*judy 05/07/28*/ /*pt_article*/  po_rmks at 1 with frame head-b.
                  find first po_mstr where po_domain = global_domain 
                  			 and po_nbr = prh_nbr no-lock no-error.
                  if available po_mstr and po_cmtindx <> 0 then DO:
                  find first cmt_det where cmt_domain = global_domain 
                  			 and cmt_indx = po_cmtindx  no-lock no-error.
                  repeat:
                    if cmt_indx <> po_cmtindx then leave.                    
                    if available cmt_det and lookup("rc",cmt_print) > 0 then
                      do k = 1 to 15 :
                       if  cmt_cmmt[k] <> "" then do :
                          display  cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                          down 1.
                       end.
                      end.
                     find next cmt_det use-index cmt_ref NO-LOCK WHERE cmt_domain = global_domain no-error.                     
                    end.                  
            /*       find cmt_det where cmt_domain = global_domain 
                      and cmt_indx = po_cmtindx no-lock .
                     if available cmt_det and lookup("rc",cmt_print) > 0 then
                        do k = 1 to 15 :
                         if  cmt_cmmt[k] <> "" then do :
                           display cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                           down 1.
                          end.
                        end.*/
                  END.
                  disp with frame e1.
              end.
              j = j + 1.
            FIND FIRST in_mstr where in_domain = global_domain 
            			 and in_site = prh_site and in_part = prh_part 
            			 NO-LOCK NO-ERROR.
              if available pt_mstr then 
                 disp prh_part pt_desc2 format "x(20)" prh_rcp_date prh_rcvd format "->>>>9.999" prh_ps_qty format "->>>>9.999" 
                         prh_line format ">>>>" prh_um format "x(2)" pod_due_date tr_trnbr  " "
/*judy 05/07/28*/ in__qadc01   WHEN AVAIL IN_mstr  with no-box no-labels width 250 frame cm3 down.
              else
                 disp prh_part pt_desc2 format "x(20)" prh_rcp_date prh_rcvd format "->>>>9.999" prh_ps_qty format "->>>>9.999" 
                      prh_line format ">>>>" prh_um format "x(2)" pod_due_date tr_trnbr "零件号不存在"  
/*judy 05/07/28*/ in__qadc01 WHEN AVAIL IN_mstr  with no-box no-labels width 250 frame cm4 down.
              if available pod_det  and pod_cmtindx <>0 then do:
                  find first cmt_det where cmt_domain = global_domain 
                  			 and cmt_indx = pod_cmtindx no-lock no-error.
                  repeat:
                    if cmt_indx <> pod_cmtindx then leave.                    
                    if available cmt_det and lookup("rc",cmt_print) > 0 then
                      do k = 1 to 15 :
                       if  cmt_cmmt[k] <> "" then do :
                          display  cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                          down 1.
                       end.
                      end.
                     find next cmt_det use-index cmt_ref no-lock WHERE cmt_domain = global_domain no-error.                     
                    end.                  

   /*            find cmt_det where cmt_domain = global_domain 
   						    and cmt_indx = pod_cmtindx no-lock.
                 if available cmt_det and lookup("rc",cmt_print) > 0 then
              do k = 1 to 15 :
                    if  cmt_cmmt[k] <> "" then do :
                       display cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                       down 1.
                    end.
              end.*/
              end.
              disp  "-----------------------------------------------------------------------------------------------------------"  at 1
                 with width 250 no-box frame fm2.                                   
              if line-counter  >= (page-size - 4) or last-of(prh_receiver) then do:
                 disp "采购员：               质检员：                保管员：              供应商："   at 1
                 with width 250 no-box frame dm2.
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
   
   
  /* disp   "----------------------------以下开始打印检验通知单---------------------------------------------------" at 1 with width 250 no-box frame gw2.*/
  form "DCP-03-06-01-00 F001" skip(1)
     "送检通知单"      at 33    skip(1)   
     with no-box side-labels width 180 frame b2.       
  FORM    
      skip(1)
     "零件号            零件名称               日期    送检数量   发票数量 序号 单位 到期日      事物号"
     skip "-------------------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame e6.     
  j = 1.    
  for each prh_hist no-lock  where prh_domain = global_domain 
  													  and (prh_nbr >= nbr_from) 
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
                              use-index prh_receiver /*,
/*judy 05/07/28*/  EACH IN_mstr WHERE in_domain = global_domain 
									  and IN_part = prh_part AND IN_site = prh_site 
/*judy 05/07/28*/     AND  in__qadc01 >= keeper AND in__qadc01 <= keeper1 NO-LOCK */ 
                                        break by prh_receiver by prh_line:
IF NOT (keeper =  " " AND  keeper1 =  hi_char) THEN DO:
         /*   MESSAGE "AA" xxkeeper xxkeeper1.
            PAUSE.*/
             FIND FIRST in_mstr where in_domain = global_domain 
             				and in_site = prh_site and in_part = prh_part
            and in__qadc01 >= keeper and in__qadc01 <= keeper1 NO-LOCK NO-ERROR.
             IF NOT AVAIL IN_mstr  THEN NEXT.
  END.
     find first tr_hist where tr_domain = global_domain and tr_part=prh_part 
     			  and tr_nbr=prh_nbr and tr_line=prh_line and tr_type="rct-po" 
     			  and tr_lot=prh_receiver AND tr_userid>= userid1 
     			  AND tr_userid<=userid2 no-lock no-error.
     if available tr_hist then do:
           find first po_mstr where po_domain = global_domain 
           			  and po_nbr=prh_nbr no-lock no-error.                             
           find first ad_mstr where ad_domain = global_domain 
           				and ad_addr = prh_vend no-lock no-error.
           find first pod_det where pod_domain = global_domain 
           			  and pod_nbr = prh_nbr and pod_line = prh_line no-lock no-error.
           find first pt_mstr where pt_domain = global_domain 
           			  and pt_part = prh_part no-lock no-error.
  /*judy 05/07/28*/ /*  find first in_mstr where in_domain = global_domain 
  														 and in_part = prh_part no-lock no-error.*/
 
           find first ptp_det where ptp_domain = global_domain 
           				and ptp_part = prh_part and Ptp_site >= site1 
           				and ptp_site <= site2 no-lock no-error.
           
           if ((not(available pt_mstr)) or ((available ptp_det and ptp_INS_RQD = yes))) and pod_type <>"S" and pod_type<>"s" and pod_type <>"m" and pod_type<>"M" then do:
              if  j = 1  then do: 
                if prh__log01 = yes then 
                   duplicate="**副本".
                else   
                 duplicate = "原本" .
                disp with frame b2.
                disp duplicate ad_name pageno pdate  prh_receiver prh_rcp_date prh_vend prh_nbr revision
                   vend_phone po_due_date prh_ps_nbr 
                    /*judy 05/07/28*/ /* in__qadc01 @ pt_article*/
                     po_rmks at 1 with frame head-b.
                find first po_mstr where po_domain = global_domain 
                			 and po_nbr = prh_nbr no-lock no-error.
                if available po_mstr and po_cmtindx <> 0 then DO:
                  find first cmt_det where cmt_domain = global_domain 
                  			 and cmt_indx = po_cmtindx no-lock no-error.
                  repeat:
                    if cmt_indx <> po_cmtindx then leave.                    
                    if available cmt_det and lookup("rc",cmt_print) > 0 then
                      do k = 1 to 15 :
                       if  cmt_cmmt[k] <> "" then do :
                          display  cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                          down 1.
                       end.
                      end.
                     find next cmt_det use-index cmt_ref WHERE cmt_domain = global_domain no-lock.                     
                    end.                  
             /*   if available cmt_det and lookup("rc",cmt_print) > 0 then
                    do k = 1 to 15 :
                      if  cmt_cmmt[k] <> "" then do :
                         display cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                         down 1.
                      end.
                    end. */
                end.
                disp with frame e6.
              end.
              j = j + 1.
              FIND FIRST in_mstr where in_domain = global_domain 
              			 and in_site = prh_site and in_part = prh_part 
              			 	   NO-LOCK NO-ERROR.
              if available pt_mstr then 
                 disp prh_part pt_desc2 format "x(20)" prh_rcp_date prh_rcvd format "->>>>9.999" prh_ps_qty format "->>>>9.999"  
                        prh_line format ">>>>" prh_um format "x(2)" pod_due_date tr_trnbr " "
     /*judy 05/07/28*/ in__qadc01  WHEN AVAIL IN_mstr  with no-box no-labels width 250 frame c3 down.
              else
                 disp prh_part pt_desc2 format "x(20)" prh_rcp_date prh_rcvd format "->>>>9.999" prh_ps_qty format "->>>>9.999"  
                        prh_line format ">>>>" prh_um format "x(2)" pod_due_date tr_trnbr "零件号不存在"
   /*judy 05/07/28*/ in__qadc01 WHEN AVAIL IN_mstr  with no-box no-labels width 250 frame c4 down.
              if available pod_det  and pod_cmtindx <>0 then do:
                  find first cmt_det where cmt_domain = global_domain 
                  			 and cmt_indx = pod_cmtindx no-lock no-error.
                  repeat:
                    if cmt_indx <> pod_cmtindx then leave.                    
                    if available cmt_det and lookup("rc",cmt_print) > 0 then
                      do k = 1 to 15 :
                       if  cmt_cmmt[k] <> "" then do :
                          display  cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                          down 1.
                       end.
                      end.
                     find next cmt_det use-index cmt_ref NO-LOCK WHERE cmt_domain = global_domain no-error.                     
                    end.          
      /*           find cmt_det where cmt_domain = global_domain 
      							and cmt_indx = pod_cmtindx no-lock.
                 if available cmt_det and lookup("rc",cmt_print) > 0 then
              do k = 1 to 15 :
                    if  cmt_cmmt[k] <> "" then do :
                       display cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                       down 1.
                    end.
              end.*/
              end.
              disp  "-----------------------------------------------------------------------------------------------------------"   at 1
                 with width 250 no-box frame f2.                                   
              if line-counter  >= (page-size - 4) or last-of(prh_receiver) then do:
                 disp "采购员：               质检员：                保管员：              供应商："   at 1
                 with width 250 no-box frame d2.
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
/*judy 05/07/28*/   /*  "零件号            零件名称               日期    退货数量   发票数量 序号 单位 到期日      事物号 "*/     
 /*judy 05/07/28*/     "零件号            零件名称               日期    退货数量   发票数量 序号 单位 到期日      事物号 　保管员"     
     skip "-----------------------------------------------------------------------------------------------------------"  
     with no-box side-labels width 180 frame e5.     
      
  j = 1.    
  for each prh_hist no-lock  where prh_domain = global_domain 
  														and (prh_nbr >= nbr_from) 
                              and (prh_nbr <= nbr_to) 
                              and (prh_receiver >= rcv_from) 
                              and (prh_receiver <= rcv_to) 
                              and (prh_vend >= sup_from) 
                              and (prh_vend <= sup_to) 
                              and (prh_rcp_date >= date_from)
                              and (prh_rcp_date <= date_to)
                              and (prh_rcp_type = "R")
                              use-index prh_receiver /*,
/*judy 05/07/28*/  EACH IN_mstr WHERE in_domain = global_domain 
									  and IN_part = prh_part AND IN_site = prh_site 
/*judy 05/07/28*/     AND  in__qadc01 >= keeper AND in__qadc01 <= keeper1 NO-LOCK  */
                               break by prh_receiver by prh_line:
IF NOT (keeper =  " " AND  keeper1 =  hi_char) THEN DO:
         /*   MESSAGE "AA" xxkeeper xxkeeper1.
            PAUSE.*/
             FIND FIRST in_mstr where in_domain = global_domain 
             				and in_site = prh_site and in_part = prh_part
            and in__qadc01 >= keeper and in__qadc01 <= keeper1 NO-LOCK NO-ERROR.
             IF NOT AVAIL IN_mstr  THEN NEXT.
  END.

     find first tr_hist where tr_domain = global_domain 
     				and tr_part=prh_part and tr_nbr=prh_nbr and tr_line=prh_line
     			  and tr_type="iss-prv" and tr_lot=prh_receiver 
     			  AND tr_userid>= userid1 AND tr_userid<=userid2 no-lock no-error.
     if available tr_hist then do:
           find first po_mstr where po_domain = global_domain 
           		    and po_nbr=prh_nbr no-lock no-error.                             
           find first ad_mstr where ad_domain = global_domain 
           				and ad_addr = prh_vend no-lock no-error.
           find first pod_det where pod_domain = global_domain 
           				and pod_nbr = prh_nbr and pod_line = prh_line no-lock no-error.
           find first pt_mstr where pt_domain = global_domain 
           				and pt_part = prh_part no-lock no-error.
              if  j = 1  then do:
                 if prh__log01 = yes then 
                   duplicate="**副本".
                 else
                   duplicate = "原本" .
                 disp with frame b3.
                 disp duplicate ad_name pageno pdate prh_receiver prh_rcp_date prh_vend prh_nbr revision
                   vend_phone po_due_date prh_ps_nbr 
                     /*judy 05/07/28*/ /*pt_article*/  po_rmks at 1 with frame head-b.
                 find first po_mstr where po_domain = global_domain 
                 				and po_nbr = prh_nbr no-lock no-error.
                 if available po_mstr and po_cmtindx <> 0 then DO:
                    find first cmt_det where cmt_domain = global_domain 
                    			 and cmt_indx = po_cmtindx no-lock no-error.
                    repeat:
                      if cmt_indx <> po_cmtindx then leave.                    
                    if available cmt_det and lookup("rv",cmt_print) > 0 then
                      do k = 1 to 15 :
                       if  cmt_cmmt[k] <> "" then do :
                          display  cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                          down 1.
                       end.
                      end.
                     find next cmt_det use-index cmt_ref NO-LOCK WHERE cmt_domain = global_domain NO-ERROR.                     
                    end.
                 END.
                 disp with frame e5.
              end.
              j = j + 1.
              prhqty = 0 - prh_rcvd.
              FIND FIRST in_mstr where in_domain = global_domain 
              			 and in_site = prh_site and in_part = prh_part
              			     NO-LOCK NO-ERROR.
              if available pt_mstr then 
                 disp prh_part pt_desc2 format "x(20)" prh_rcp_date prhqty format "->>>>>9.999" prh_ps_qty format "->>>>9.999"  
                        prh_line format ">>>>" prh_um format "x(2)" pod_due_date tr_trnbr "  "
    /*judy 05/07/28*/ in__qadc01 WHEN AVAIL IN_mstr  with no-box no-labels width 250 frame c5 down.
              else
                 disp prh_part pt_desc2 format "x(20)" prh_rcp_date prhqty format "->>>>>9.999" prh_ps_qty format "->>>>9.999"  
                        prh_line format ">>>>" prh_um format "x(2)" pod_due_date tr_trnbr "零件号不存在" 
  /*judy 05/07/28*/ in__qadc01  WHEN AVAIL IN_mstr  with no-box no-labels width 250 frame c6 down.
              if available pod_det  and pod_cmtindx <>0 then do:
                 find first cmt_det where cmt_domain = global_domain 
                 			  and cmt_indx = pod_cmtindx no-lock no-error.
                 repeat:
                 if cmt_indx <> pod_cmtindx then leave.                 
                 if available cmt_det and lookup("rv",cmt_print) > 0 then
                   do k = 1 to 15 :
                    if  cmt_cmmt[k] <> "" then do :
                       display cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                       down 1.
                    end.
                   end.
                 find next cmt_det use-index cmt_ref NO-LOCK WHERE cmt_domain = global_domain NO-ERROR.                   
              end.
              end.
              disp   "-----------------------------------------------------------------------------------------------------------"  at 1
                 with width 250 no-box frame f3.                                   
              if line-counter  >= (page-size - 4) or last-of(prh_receiver) then do:
                 disp "采购员：               质检员：                保管员：              供应商："   at 1
                 with width 250 no-box frame d3.
                 page.
                 pageno = pageno + 1.
                 j = 1.
              end.
              if last-of(prh_receiver) then do:
                 pageno = 1.  
                 page.
              end.
     end. /*end of tr_hist */
  end. /*end of for each prh_hist...*/   
  



 

/*Report-to-Window*/
/*  if dev <> "terminal" then do: */
      for each prh_hist  where prh_domain = global_domain 
      										and (prh_nbr >= nbr_from) 
                          and (prh_nbr <= nbr_to) 
                          and (prh_receiver >= rcv_from) 
                          and (prh_receiver <= rcv_to) 
                          and (prh_vend >= sup_from) 
                          and (prh_vend <= sup_to) 
                          and (prh_rcp_date >= date_from) 
                          and (prh_rcp_date <= date_to)
                          and (prh__log01 = no or not flag1) USE-INDEX prh_receiver /*,
/*judy 05/07/28*/  EACH IN_mstr WHERE in_domain = global_domain 
								    and IN_part = prh_part AND IN_site = prh_site 
/*judy 05/07/28*/     AND  in__qadc01 >= keeper AND in__qadc01 <= keeper1 NO-LOCK*/  
                                        break by prh_receiver by prh_line:
  IF NOT (keeper =  " " AND  keeper1 =  hi_char) THEN DO:
         /*   MESSAGE "AA" xxkeeper xxkeeper1.
            PAUSE.*/
             FIND FIRST in_mstr where in_domain = global_domain 
             			  and in_site = prh_site and in_part = prh_part
            and in__qadc01 >= keeper and in__qadc01 <= keeper1 NO-LOCK NO-ERROR.
             IF NOT AVAIL IN_mstr  THEN NEXT.
  END.
                                        prh__log01 = yes.      
                                         
       end.        
/*  end. */ /* end-if of dev */
       
  /* reset variable */
  {mfreset.i}
  {mfgrptrm.i}
end. /*end of the procedure*/
 /*K0ZX*/ {wbrp04.i &frame-spec = a} 
/*judy 05/07/28*/  /*{mfguirpb.i &flds="nbr_from nbr_to rcv_from rcv_to sup_from sup_to site1 site2 date_from date_to flag1 "}*/
/*judy 05/07/28*/  {mfguirpb.i &flds="nbr_from nbr_to rcv_from rcv_to sup_from sup_to site1 site2 date_from date_to keeper keeper1 userid1 userid2 flag1 "}


/*
Error 500: 已获取输出流
*/
