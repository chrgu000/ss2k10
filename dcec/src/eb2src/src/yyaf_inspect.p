 /* Rev: eb2+sp7            Last MOD: 06/28/05      BY: Judy Liu           */

  {mfdtitle.i "B+"}
def var flag as char. 
def var nbr as char .
def var receiver as char.
def var nbr_from   as char label "�ɹ���".
def var nbr_to     as char label "��".
def var mov_from   as char label "�ƿⵥ".
def var mov_to     as char label "��".
def var rcv_from   as char label "���յ�".
def var rcv_to     as char label "��".
def var sup_from   as char label "��Ӧ��".
def var sup_to     as char label "��".
def var date_from  as date label "�ƿ�����".
def var date_to    as date label "��".
def var flag1      as logical label "ֻ��ӡδ��ӡ�����ջ���".
def var pageno     as integer. /***ҳ��***/.
def var duplicate  as char.    /***����***/.
def var vendor     as char extent 6.
def var pdate      as date.    /***��ӡ����***/.
def var revision   as char.    /***�ɹ����汾***/.
def var vend_phone as char format "x(20)". /***��Ӧ�̵绰***/
def var rmks       as char format "x(80)". /***��ע***/
def var i          as integer.
def var j          as integer.
/***$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$***/
def var nbr_from1   as char label "�ɹ���".
def var nbr_to1     as char label "��".
def var rcv_from1   as char label "�ջ���".
def var rcv_to1     as char label "��".
def var sup_from1   as char label "��Ӧ��".
def var sup_to1     as char label "��".
def var date_from1  as date label "�ƿ�����".
def var date_to1    as date label "��".
def var test as char.


FORM
SKIP(1)  rcv_from  colon 20 rcv_to  colon 40 LABEL {t001.i}  SKIP
        mov_from  colon 20 mov_to  colon 40  LABEL {t001.i}   SKIP
        date_from colon 20 date_to colon 40  LABEL {t001.i}   skip(1)
        with side-labels width 80 frame a THREE-D.
 /*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).


form "��ⵥ "      at 33  
     pageno        label "ҳ��:  "       at 42
     duplicate     no-labels        at 48
     prh_vend      label "��Ӧ��:  "     at 11
     prh_receiver  label "�ջ�����:  "   at 48
     ad_name       no-labels          at 11 
     prh_rcp_date  label "�ջ�����:  "   at 48 
     vendor[2]     no-labels          at 11 
     pdate         label "��ӡ����:  "   at 48 
     vendor[3]     no-labels          at 11 
     prh_nbr       label "�ɹ���:  "     at 48  
     vendor[4]     no-labels          at 11 
     revision      label "�ƿⵥ:  " at 48 
     vendor[5]     no-labels          at 11 
     vendor[6]     no-labels          at 11 skip(1)
     vend_phone    no-labels          at 11  
     prh_ship_date label "��������:  "   at 48 
     prh_ps_nbr    label "װ�䵥:  "     at 11  
     rmks          label "��ע:  "       at 11  skip(1)
     "��Ŀ��           ��Ŀ����             ��λ        ��Ʊ����         ʵ������    ��ע"
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
                  duplicate="**����".
                  disp pageno duplicate  prh_vend ad_name prh_receiver prh_rcp_date prh_nbr revision with frame b.
                                              end.
         if  i = 1  and tr__log01 = yes then   do:
                 duplicate = "ԭ��" .
                 disp pageno  duplicate prh_vend ad_name prh_receiver prh_rcp_date prh_nbr  revision with frame b.
                 end.
           i = i + 1.         
         find first pt_mstr where pt_part = tr_part  no-lock no-error.
           if available pt_mstr then disp tr_part pt_desc2 pt_um prh_ps_qty tr_qty_chg /*prh_rcvd */
              with no-box no-labels width 250 frame c down.
           /*if not available pt_mstr and pt_insp_rqd =no then display prh_part  prh_ps_qty prh_rcvd "����Ų�����"
              with no-box no-labels width 250 frame c down.    */
           disp  "---------------------------------------------------------------------------------------"   at 1
          with width 250 no-box frame f.
                                   
         if i >= 5 or last-of(tr_nbr) then do:
          if i / 3 = 1 then disp  skip(1) with no-box frame c1.
          disp /* "---------------------------------------------------------------------------------------"   at 1*/
"�ɹ�Ա��               �ʼ�Ա��                ����Ա��              ��Ӧ�̣�"   at 1
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

 
 
