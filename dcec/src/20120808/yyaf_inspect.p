 /* Rev: eb2+sp7            Last MOD: 06/28/05      BY: Judy Liu           */

  {mfdtitle.i "B+"}
def var flag as char. 
def var nbr as char .
def var receiver as char.
def var nbr_from   as char label "采购单".
def var nbr_to     as char label "至".
def var mov_from   as char label "移库单".
def var mov_to     as char label "至".
def var rcv_from   as char label "接收单".
def var rcv_to     as char label "至".
def var sup_from   as char label "供应商".
def var sup_to     as char label "至".
def var date_from  as date label "移库日期".
def var date_to    as date label "至".
def var flag1      as logical label "只打印未打印过的收货单".
def var pageno     as integer. /***页号***/.
def var duplicate  as char.    /***副本***/.
def var vendor     as char extent 6.
def var pdate      as date.    /***打印日期***/.
def var revision   as char.    /***采购单版本***/.
def var vend_phone as char format "x(20)". /***供应商电话***/
def var rmks       as char format "x(80)". /***备注***/
def var i          as integer.
def var j          as integer.
/***$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$***/
def var nbr_from1   as char label "采购单".
def var nbr_to1     as char label "至".
def var rcv_from1   as char label "收货单".
def var rcv_to1     as char label "至".
def var sup_from1   as char label "供应商".
def var sup_to1     as char label "至".
def var date_from1  as date label "移库日期".
def var date_to1    as date label "至".
def var test as char.


FORM
SKIP(1)  rcv_from  colon 20 rcv_to  colon 40 LABEL {t001.i}  SKIP
        mov_from  colon 20 mov_to  colon 40  LABEL {t001.i}   SKIP
        date_from colon 20 date_to colon 40  LABEL {t001.i}   skip(1)
        with side-labels width 80 frame a THREE-D.
 /*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).


form "入库单 "      at 33  
     pageno        label "页号:  "       at 42
     duplicate     no-labels        at 48
     prh_vend      label "供应商:  "     at 11
     prh_receiver  label "收货单号:  "   at 48
     ad_name       no-labels          at 11 
     prh_rcp_date  label "收货日期:  "   at 48 
     vendor[2]     no-labels          at 11 
     pdate         label "打印日期:  "   at 48 
     vendor[3]     no-labels          at 11 
     prh_nbr       label "采购单:  "     at 48  
     vendor[4]     no-labels          at 11 
     revision      label "移库单:  " at 48 
     vendor[5]     no-labels          at 11 
     vendor[6]     no-labels          at 11 skip(1)
     vend_phone    no-labels          at 11  
     prh_ship_date label "发货日期:  "   at 48 
     prh_ps_nbr    label "装箱单:  "     at 11  
     rmks          label "备注:  "       at 11  skip(1)
     "项目号           项目名称             单位        发票数量         实收数量    备注"
     skip "---------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame b.
     
 repeat:
 if nbr_to     = hi_char  then nbr_to = "". 
 if rcv_to     = hi_char  then rcv_to = "". 
 if sup_to     = hi_char  then sup_to = "".
 if mov_to     = hi_char   then mov_to ="".
 if date_from  = low_date then date_from = ?. 
 if date_to    = hi_date  then date_to = ?.


 update rcv_from  colon 20 rcv_to  colon 40
        mov_from  colon 20 mov_to  colon 40
        date_from colon 20 date_to colon 40 skip(1)
        with side-labels width 80 frame a.
 
 bcdparm = "". 
 {mfquoter.i nbr_from} 
 {mfquoter.i nbr_to} 
 {mfquoter.i rcv_from} 
 {mfquoter.i rcv_to} 
 {mfquoter.i sup_from} 
 {mfquoter.i sup_to} 
 {mfquoter.i date_from} 
 {mfquoter.i date_to} 
 {mfquoter.i flag1} 
 {mfquoter.i mov_from}
 {mfquoter.i mov_to}
                        
 if nbr_to     = ""  then nbr_to = hi_char.                        
 if rcv_to     = ""  then rcv_to = hi_char. 
 if sup_to     = ""  then sup_to = hi_char. 
 if mov_to     =""   then mov_to =hi_char.
 if date_from  = ?   then date_from = low_date. 
 if date_to    = ?   then date_to = hi_date.
            
 {mfselprt.i "page1000" 132}
 pageno = 1.
 i =1.
 for each tr_hist where  (tr_nbr >= rcv_from) and (tr_nbr <= rcv_to)
                          and (tr_rmks>= mov_from) and (tr_rmks <=mov_to)
                          and (tr_date >= date_from) and (tr_date <= date_to)
                          and (tr_type ="rct-tr") 
                          use-index tr_nbr_eff
                          break by tr_nbr:
    revision =tr_rmks. 
   /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
    find first prh_hist where prh_receiver =tr_nbr  no-lock no-error .
    /*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
    
   /************* ADDED BY YKE***********************/
   if available prh_hist then do:
   /*************END YKE ADD*************************/

   find first ad_mstr where ad_addr = prh_vend no-lock no-error.
           if  i = 1  and tr__log01 = no then  do:
                  duplicate="**副本".
                  disp pageno duplicate  prh_vend ad_name prh_receiver prh_rcp_date prh_nbr revision with frame b.
                                              end.
         if  i = 1  and tr__log01 = yes then   do:
                 duplicate = "原本" .
                 disp pageno  duplicate prh_vend ad_name prh_receiver prh_rcp_date prh_nbr  revision with frame b.
                 end.
           i = i + 1.         
         find first pt_mstr where pt_part = tr_part  no-lock no-error.
           if available pt_mstr then disp tr_part pt_desc2 pt_um prh_ps_qty tr_qty_chg /*prh_rcvd */
              with no-box no-labels width 250 frame c down.
           /*if not available pt_mstr and pt_insp_rqd =no then display prh_part  prh_ps_qty prh_rcvd "零件号不存在"
              with no-box no-labels width 250 frame c down.    */
           disp  "---------------------------------------------------------------------------------------"   at 1
          with width 250 no-box frame f.
                                   
         if i >= 5 or last-of(tr_nbr) then do:
          if i / 3 = 1 then disp  skip(1) with no-box frame c1.
          disp /* "---------------------------------------------------------------------------------------"   at 1*/
"采购员：               质检员：                保管员：              供应商："   at 1
              skip(4)                                                                         with width 250 no-box frame d.
          if line-count + 4 >=page-size then page.
          pageno = pageno + 1.
          i = 1.
         end.
                if last-of(tr_nbr) then pageno = 1. 
     
           /**********ADDED BY YKE ***********/
          END.
         /* ELSE DISP TR_NBR.*/
          /********END YKE ADD***************/

          
              
 end. /****end of for each prh_hist...****/   
 {mfreset.i}
 /*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
end.

 
 
