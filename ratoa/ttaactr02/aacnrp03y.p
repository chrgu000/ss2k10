/* lhcnrp03.p - consignment vend report                                 */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*create by tonylihu   2011-01-12                                        */


{mfdtitle.i "20120523 "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE porcrp_p_6 "Unprinted Receivers Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_8 "Print Receipt Trailer"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_9 "List All Comments"
/* MaxLen: Comment: */
define new shared variable convertmode as character no-undo.
define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable oldcurr like po_curr.
/* CORRECT INITIAL TAX TYPE TO INDICATE RECEIPT (21) NOT RETURN (25)*/
DEFINE VAR cost# AS inte format "9" .
define variable site like tr_site.
define variable site1 like tr_site.
define variable vend like prh_vend.
define variable vend1 like prh_vend.
define variable part like prh_part.
define variable part1 like prh_part.
define variable cn_date like prh_rcp_date.
define variable cn_date1 like prh_rcp_date.
DEFINE VAR yn AS logi .
DEF VAR yy AS INTE format "9999" .
DEF VAR mm AS INTE  format "99" .
DEF VAR yy1 AS INTE .
DEF VAR mm1 AS INTE .
def var i as inte .
DEF VAR l AS INTE .
DEF VAR st1 AS CHAR FORMAT "x(20)" .
def var xxxcode1 as char format "x(8)" .

DEF VAR qty_oh3 LIKE tr_qty_chg .
DEF VAR sum1 LIKE tr_qty_chg .
DEF VAR con2  LIKE tr_qty_chg .
DEF VAR con3 LIKE tr_qty_chg .
DEF VAR sum5 LIKE tr_qty_chg  .
DEF VAR fir# LIKE tr_qty_chg .
DEF VAR firqtyoh  LIKE tr_qty_chg  .
DEF VAR firqtycon LIKE tr_qty_chg .
DEFINE VAR cost1 LIKE tr_qty_chg .

DEFINE VAR UP_QTY_OH_fir AS LOGI INIT YES .
DEFINE VAR UP_QTY_con AS LOGI INIT YES .
DEFINE VAR UP_QTY_rcv AS LOGI INIT NO .
DEFINE VAR UP_QTY_inv AS LOGI INIT NO .

def workfile vendp
field vendp_domain like tr_domain /********yhb add 2012-02-21*********/
field vendp_site like tr_site     /********yhb add 2012-02-21*********/
field vendp_vend like tr_serial
field vendp_part like tr_part
field vendp_qty_oh like tr_qty_chg
FIELD vendp_qty_fir LIKE tr_qty_chg
field vendp_qty_con like tr_qty_chg
FIELD vendp_qty_inv LIKE tr_qty_chg
FIELD vendp_qty_rcv LIKE tr_qty_chg
FIELD vendp_qty_re_ve LIKE tr_qty_chg 
field vendp_qty_re_scrp like tr_qty_chg 
field vendp_qty_con2 like tr_qty_chg
FIELD vendp_qty_inv2 LIKE tr_qty_chg
FIELD vendp_qty_rcv2 LIKE tr_qty_chg
FIELD vendp_qty_re_ve2 LIKE tr_qty_chg 
FIELD vendp_qty_potr  LIKE tr_qty_chg 
FIELD vendp_qty_potr2 LIKE tr_qty_chg 
field vendp_nub as inte 
FIELD vendp_amt_inv  LIKE tr_qty_chg 
FIELD vendp_amt_oh3  LIKE tr_qty_chg 
field vendp_lastqty_oh like tr_qty_chg
.

define buffer tmptrhist for tr_hist.


define temp-table xnbr 
field xnbr_vend like po_vend 
field xnbr_part like pt_part
field xnbr_nbr  like po_nbr .

def var s_qty_con like tr_qty_chg .
def var ii as inte .
def var s_qty_potr like tr_qty_chg .
def var s_nub as inte .
def var  s_qty_sum1 like tr_qty_chg .
def var  s_amt_sum1 like tr_qty_chg .
def var  s_amt_potr like tr_qty_chg . 
def var  s_qty_oh3  like tr_qty_chg .
def var  s_amt_con like tr_qty_chg .
def var dec2 like tr_qty_chg .

define var thism as logi .
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
form
   site           colon 15
   site1          label {t001.i} colon 49
   vend           colon 15
   vend1          label {t001.i} colon 49
   part           colon 15
   part1          label {t001.i} colon 49
/*
   cn_date      label "��������"  colon 15
   cn_date1       label {t001.i} colon 49
*/   
   yy          label "�������"  colon 15
   mm          label "�����·�"  colon 30
/*
   cost#        LABEL  "1..���� 2..��� 3..ȫ��" colon 30  
   thism  label "ֻ��ʾ���º���<>0��" colon 30
   skip(1)
   UP_qty_con  LABEL "���µ��º���,����,��Ʊ ����" COLON 64 
   UP_qty_oh_fir LABEL "��ת����������ʼ���������ڳ���������(ֹ����Ϊ�������һ��)" COLON 64
*/  
  
   SKIP(2) 
with frame a attr-space side-labels width 80. 

setFrameLabels(frame a:handle).

convertmode = "REPORT".

view frame a.

form
		xxcn_vend  column-label "��Ӧ�̴���"
		vd_sort column-label "��Ӧ������"
		xxcn_part  column-label "�Ϻ�"
		pt_desc1 COLUMN-LABEL "����" 
		st1 COLUMN-LABEL "״̬" 
		xxcn_qty_fir_oh COLUMN-LABEL "�ڳ�!�������" 
		xxcn_qty_con_fir COLUMN-LABEL  "�ڳ��Ѻ���!δ��������" 
		sum1  COLUMN-LABEL "�ڳ����+�ڳ�����δ��!    С��        "
		vendp_qty_potr COLUMN-LABEL "�����ͻ�����"  
		vendp_nub column-label "����"
		vendp_qty_con column-label "���º���"
		vendp_qty_re_scrp column-label "�����˻���"
		fir#  COLUMN-LABEL "ǰ�ں���δ����"
		con2  COLUMN-LABEL "����Ӧ����С��"  
		vendp_qty_inv COLUMN-LABEL "�ڼ俪Ʊ����" 
		qty_oh3 COLUMN-LABEL "��ĩ���"
		con3 COLUMN-LABEL "��ĩ�Ѻ���δ����" 
		sum5 COLUMN-LABEL "С��" 
with frame b width 320 no-box down. 

form
		xxcn_vend  column-label "��Ӧ�̴���"
		vd_sort column-label "��Ӧ������"
		xxcn_part  column-label "�Ϻ�"
		pt_desc1 COLUMN-LABEL "����" 
		st1 COLUMN-LABEL "״̬" 
		cost1 COLUMN-LABEL "����" 
		sum1  COLUMN-LABEL "�ڳ����+�ڳ�����δ��!    С������ "  
		con2  COLUMN-LABEL "�ڳ����+�ڳ�����δ��!    С�ƽ��  "  
		vendp_qty_potr COLUMN-LABEL "�����ͻ�����"  
		xxcn_dec4 format ">>>9" column-label "����"
		s_amt_potr column-label "�����ͻ����" 
		vendp_qty_con column-label "���º�������"
		dec2 column-label "���º��ý��"
		
		vendp_qty_inv COLUMN-LABEL "����ƾ֤������"
		vendp_amt_inv COLUMN-LABEL "����ƾ֤�Ľ��" 
		
		qty_oh3  COLUMN-LABEL "��ĩ��������"
		vendp_amt_oh3 COLUMN-LABEL "���" 
with frame c width 320 no-box down . 

assign
   cost# = 1 .
   site = "11000" .
   site1 = "11000" .
   UP_qty_oh_fir = YES .
   UP_qty_con  = YES .
   UP_qty_rcv = NO .
   UP_qty_inv = NO .
   thism = no .
   yy = year(today) .
   mm = month(today) .
{gprunp.i "aaproced" "p" "getglsite" "(output site)"}
{gprunp.i "aaproced" "p" "getglsite" "(output site1)"}  
mainloop :
repeat:
   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".
   if vend1 = hi_char then vend1 = "".
 
   if cn_date = low_date then cn_date = ? .
   if cn_date1 = hi_date then cn_date1 = ? .

    update
      site site1 vend vend1 part part1  yy mm
    with frame a. 

    find first glc_cal where glc_domain = global_domain and glc_year = yy and glc_per = mm no-lock no-error.
		if avail glc_cal then
			do:
				cn_date = glc_start.
				cn_date1 = glc_end.
			end.
		else
			do:
				message "������䲻����" view-as alert-box.
				undo,retry.
			end.   

    /* 
     if UP_qty_oh_fir  = yes and day(cn_date1) < 20 then 
       do : message "��תʱ������ >= 20 " .
       undo , retry .
       end.
  
     if mm > 12 or yy < 2011 then 
     do :
       message "�������<2011 �� �����·�>12 " .
       undo , retry .
     end.
     */
     
   bcdparm = "".
   {mfquoter.i site}
   {mfquoter.i site1} 
   {mfquoter.i vend}
   {mfquoter.i vend1}
   {mfquoter.i part}
   {mfquoter.i part1}
   {mfquoter.i cn_date}
   {mfquoter.i cn_date1}
   {mfquoter.i cost#} 
   {mfquoter.i thism} 
   {mfquoter.i UP_qty_con}
   {mfquoter.i UP_qty_oh_fir}
   
   if site1 = "" then site1 = hi_char.
   if part1 = "" then part1 = hi_char.
   if vend1 = "" then vend1 = hi_char.
   if cost# = ? or cost# > 3 or cost# = 0 then cost# = 1 .
   if cn_date = ? then cn_date = low_date.
   if cn_date1 = ? then cn_date1 = hi_date .
   if thism = ? then thism = no .
   IF UP_qty_oh_fir = ? THEN   UP_qty_oh_fir = NO .
   IF UP_qty_con = ? THEN UP_qty_con  = NO .
   
 {mfselbpr.i "printer" 80}
     
   FOR EACH vendp :
       DELETE vendp .
   END.
     
   for each xnbr :
       delete xnbr .
   end.
     
   for each tr_hist where tr_domain = global_domain
                    and   tr_site >= site  and tr_site <= site1
                    and   tr_part >= part  and tr_part <= part1
                    and   SUBSTRING(tr_serial,10,6) >= vend and SUBSTRING(tr_serial,10,6) <= vend1
                    and   tr_effdate >= cn_date  and  tr_effdate  <= cn_date1 
                    and   LENGTH(tr_serial) > 0 
                    use-index  tr_part_eff no-lock 
   break by substring(tr_serial,10) by tr_part:
      
      find first pt_mstr where pt_domain = global_domain and pt_Site = tr_site and pt_part = tr_part no-lock no-error.
      if trim(pt_pm_code) <> "p" then next .
      
      /*�ֽ����ͣ�������*/
      /*
      find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,10,6) no-lock no-error.
      if vd_type = "C" then next.
      */
      find first vendp where vendp_domain = tr_domain and vendp_site = tr_site and vendp_vend = substring(tr_serial,10,6) and vendp_part = tr_part no-error .
      if not avail vendp THEN 
      do:
       create vendp.
       vendp_vend = substring(tr_serial,10,6) .
       vendp_part = tr_part .
      end.
                         
    IF tr_type = "iss-unp"  AND (tr_program = "aahjrtmt.p" or tr_program = "aahjrtbkmt.p") and (tr_loc = "NC1" or tr_loc begins "P" or tr_loc begins "S") THEN  /*��Ʒ�˹�Ӧ��*/
                     assign vendp_qty_re_scrp = vendp_qty_re_scrp  - tr_qty_loc .
                            
    if tr_type = "iss-prv" and tr_program = "aaporvis.p" then  /*�ϸ�Ʒ�˹�Ӧ��*/
    								 assign vendp_qty_re_scrp = vendp_qty_re_scrp - tr_qty_loc.  
    								 
    if tr_type = "rct-tr"	 and tr_program = "aatrchmt.p" then   /*���������*/
    								 assign vendp_qty_potr = vendp_qty_potr + tr_qty_loc.  					 	 
    								 
    if last-of(tr_part) then
    	do:
		    for each ld_det use-index ld_part_loc where ld_domain = global_domain 
		                      and ld_site = site
		                      and ld_part = tr_part
		                      and (ld_loc begins "P" or ld_loc = "NC1" or ld_loc begins "S")
		                      and substring(ld_lot,10) = substring(tr_serial,10) no-lock
		    break by ld_part by substring(ld_lot,10):
		    	/*�ϼƵ�ǰ���*/
		    	vendp_lastqty_oh = vendp_lastqty_oh + ld_qty_oh.
		    end.							 
    								 
		    for each tmptrhist where tmptrhist.tr_domain = global_domain
		                               and tmptrhist.tr_site = site
								                   and tmptrhist.tr_effdate > cn_date1
								                   and tmptrhist.tr_part = tr_hist.tr_part
								                   and (tr_loc begins "P" or tr_loc = "NC1" or ld_loc begins "S")
								                   and substring(tmptrhist.tr_serial,10) = substring(tr_hist.tr_serial,10) no-lock
								break by tr_effdate descending by tr_trnbr descending:
							  	vendp_lastqty_oh = vendp_lastqty_oh - tr_qty_loc.
			  end. /*for each tr_hist*/	
			  
			  
			end. /*if last-of(tr_part)*/ 							 
    								 					                       
   end.  /*tr_hist*/
   /*�������û�з�������ҲҪ����������д��vendp*/
   for each xxcn_mstr where xxcn_domain = global_domain 
                        and xxcn_year = yy 
                        and xxcn_month = mm
                        and xxcn_vend >= vend and xxcn_vend <= vend1
                        and xxcn_part >= part and xxcn_part <= part1 no-lock:
          
           find first vendp where vendp_domain = xxcn_domain and vendp_vend = xxcn_vend and vendp_part = xxcn_part no-error .
			      if not avail vendp THEN 
			      do:
			        create vendp.
			        vendp_vend = xxcn_vend .
			        vendp_part = xxcn_part .
			        vendp_lastqty_oh = xxcn_qty_fir_oh.
			      end.     	
   end. /*for each xxcn_mstr*/                     	
    
	 
/*
   FOR EACH tr_hist WHERE  tr_domain = global_domain
                 and  tr_site >= site and tr_site <= site1
                 and  tr_part >= part  and tr_part <= part1
                 AND  tr_effdate >= cn_date AND tr_effdate <= cn_date1
                 and  SUBSTRING(tr_serial,10,6) >= vend and   SUBSTRING(tr_serial,10,6) <= vend1
                 AND  tr_type = "rct-tr" AND tr_program = "aatrchmt.p" 
                 AND  length(tr_serial) > 0   use-index  tr_type NO-LOCK :
                    

     FIND FIRST vendp WHERE  vendp_vend = SUBSTRING(tr_serial,10,6) AND vendp_part = tr_part NO-ERROR .
     if not avail vendp THEN 
     do:
      create vendp .
      vendp_vend = substring(tr_serial,10,6) .
      vendp_part = tr_part .
      vendp_qty_potr = tr_qty_loc .
    end.
    ELSE vendp_qty_potr = vendp_qty_potr + tr_qty_loc .
    
    find first xnbr where xnbr_vend  = SUBSTRING(tr_serial,10,6) and xnbr_part = tr_part
                      and xnbr_nbr = trim(tr_nbr) no-error .
    if not avail xnbr then 
    do:
      create xnbr .
      xnbr_vend  = SUBSTRING(tr_serial,10,6) .
      xnbr_part = tr_part .
      xnbr_nbr = trim(tr_nbr) .
    end. 
   END.
*/  
/* 
   FOR EACH tr_hist WHERE  tr_domain = global_domain
                    and  tr_site >= site and tr_site <= site1
                    and  tr_part >= part  and tr_part <= part1
                    AND tr_effdate >= cn_date  AND tr_effdate <= cn_date1
                    AND  tr_type = "rct-unp" AND tr_program = "xxicunrc.p" 
                    AND  substring(tr_serial,10,6) >= vend AND  substring(tr_serial,10,6) <= vend1
                    AND  length(tr_serial) > 0  use-index  tr_type  NO-LOCK :

     FIND FIRST vendp WHERE  vendp_vend = substring(tr_serial,10,6) AND vendp_part = tr_part NO-ERROR .
     if not avail vendp THEN 
     do:
      create vendp .
      vendp_vend = substring(tr_serial,10,6) .
      vendp_part = tr_part .
      vendp_qty_re_ve = - tr_qty_chg .
    end.
    ELSE vendp_qty_re_ve = vendp_qty_re_ve - tr_qty_chg .
  END.
  FOR EACH vendp :
       vendp_qty_potr = vendp_qty_potr - vendp_qty_re_ve .
  END.



  FOR EACH vendp :          
        FIND  FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain 
                               and xxcn_vend = vendp_vend AND xxcn_part = vendp_part 
                               AND xxcn_year = yy AND xxcn_month = mm AND xxcn_site = site
                                NO-ERROR .
     
        IF NOT AVAIL xxcn_mstr THEN
        DO:
         CREATE xxcn_mstr .
	         xxcn_domain = GLOBAL_domain .
	         xxcn_vend = vendp_vend .
	         xxcn_part = vendp_part .
	         xxcn_site = site .
	         xxcn_year = yy .
	         xxcn_month = mm .
         
         xxcn_po_stat = "" .
        END.
        i = 0 .
        for each xnbr where xnbr_vend = vendp_vend
                        and xnbr_part = vendp_part :
         i = i + 1 .
        end .
        vendp_nub = i .
  end.
*/ 

/* billy ȡ�������ӡ 
for each vendp where vendp_qty_con <> 0 and thism = yes and (cost# = 1 or cost# = 3)
                     break by vendp_vend  :
  if first-of(vendp_vend) then assign s_qty_con = 0 s_qty_potr = 0  s_nub = 0 ii = 0 .       
        
        FIND FIRST vd_mstr WHERE vd_domain = global_domain and vd_addr = vendp_vend NO-LOCK NO-ERROR .
        FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = vendp_part NO-LOCK NO-ERROR .
        FIND  FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain 
                               and xxcn_vend = vendp_vend AND xxcn_part = vendp_part 
                               AND xxcn_year = yy AND xxcn_month = mm AND xxcn_site = site
                                NO-ERROR .
     
    
        
        FIND FIRST cd_det WHERE cd_domain = global_domain and cd_ref = vendp_part AND cd_type = "SC" NO-LOCK NO-ERROR .
        IF avail  cd_det THEN
        DO: 
            l = INDEX(cd_cmmt[1],":") + 1 .
            st1 = trim(SUBSTRING(cd_cmmt[1],l,20)) .
        END. ELSE st1 = "" .
            
       sum1 =  xxcn_qty_fir_oh + xxcn_qty_con_fir .

       if avail vendp then qty_oh3 = xxcn_qty_fir_oh + vendp_qty_potr
                                      - vendp_qty_con + vendp_qty_re_scrp .   
                      else qty_oh3 = xxcn_qty_fir_oh .        
       if avail vendp then con2 = xxcn_qty_con_fir + vendp_qty_con .           
                      else con2 = xxcn_qty_con_fir .
       if avail vendp then   con3 = xxcn_qty_con_fir + vendp_qty_con  - vendp_qty_inv .  
                      else   con3 = xxcn_qty_con_fir .
       sum5 = qty_oh3 + con3 .
       fir# = xxcn_qty_con_fir .
       if avail vendp then  s_qty_con = s_qty_con + vendp_qty_con .

       if avail vendp then  s_qty_potr = s_qty_potr + vendp_qty_potr .
                     
       if avail vendp then  s_nub = s_nub + vendp_nub .
                      
          ii = ii + 1 .
      
      DISPLAY xxcn_vend 
              vd_sort WHEN (AVAIL vd_mstr) xxcn_part
              pt_desc1 WHEN (AVAIL pt_mstr)  
              st1
              xxcn_qty_fir_oh  
              xxcn_qty_con_fir
              sum1 
              vendp_nub 

              vendp_qty_potr 
              vendp_qty_con 
              vendp_qty_re_scrp 
              fir# 
              con2  
              vendp_qty_inv 
              qty_oh3 
              con3 
              sum5 
             WITH FRAME b .
    DOWN WITH FRAME b .

   if last-of(vendp_vend) then
   do :
      display "С��:" @ xxcn_part  II @ pt_desc1 
             s_qty_potr @ vendp_qty_potr s_qty_con @ vendp_qty_con 
               s_nub @ vendp_nub 
      with frame b .
      down with frame b .
   end .
 end. 

for each vendp where vendp_qty_con <> 0 and thism = yes and (cost# = 2 or cost# = 3) 
                    break by vendp_vend  :     
        
        FIND  FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain 
                               and xxcn_vend = vendp_vend AND xxcn_part = vendp_part 
                               AND xxcn_year = yy AND xxcn_month = mm AND xxcn_site = site
                                NO-ERROR .
 IF first-of(vendp_vend) then 
      assign s_qty_sum1 = 0
             s_amt_sum1 = 0
             s_qty_potr = 0
             s_amt_potr = 0 
             s_qty_con = 0
             s_amt_con = 0 
             s_qty_oh3 = 0
             s_nub = 0 .
 
   
     
      FIND FIRST vd_mstr WHERE vd_addr = vendp_vend NO-LOCK NO-ERROR .
      FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain and pt_part = xxcn_part NO-LOCK NO-ERROR .
      FIND FIRST cd_det WHERE cd_domain = global_domain and  cd_ref = xxcn_part AND cd_type = "sc" NO-LOCK NO-ERROR .
      IF avail  cd_det THEN
      DO: 
          l = INDEX(cd_cmmt[1],":") + 1 .
          st1 = trim(SUBSTRING(cd_cmmt[1],l,20)) .
      END. ELSE st1 = "" .

      find last pc_mstr where pc_domain = GLOBAL_domain and trim(pc_list) = "C" + trim(xxcn_vend) 
                           and pc_curr = "RMB" and (trim(pc_prod_line) = "" or pc_prod_line = ?)
                           and pc_part = xxcn_part and pc_um = pt_um  
                           and (pc_start <= today or pc_start = ? ) 
                           and (pc_expire >= today or pc_expire = ?)
                           and pc_amt_type = "p"  no-lock no-error .
      
      IF AVAIL pc_mstr  THEN assign cost1 = pc_amt[1] .
                        ELSE  cost1 = 0 .  
      dec2 = vendp_qty_con * cost1 .    
      sum1 = xxcn_qty_fir_oh + xxcn_qty_con_fir .
       
      con2 = xxcn_qty_con_fir + vendp_qty_con .
                     
      con3 = xxcn_qty_con_fir + vendp_qty_con  -  vendp_qty_inv .
                      
      qty_oh3 = xxcn_qty_fir_oh + vendp_qty_potr
                                      - vendp_qty_con + vendp_qty_re_scrp .
                      
      s_qty_sum1 = s_qty_sum1 + sum1 .
      s_amt_sum1 = s_amt_sum1 + (sum1 * cost1) .
      s_amt_potr = s_amt_potr + (vendp_qty_potr * cost1). 
                     
      s_qty_con = s_qty_con + vendp_qty_con .
      s_qty_potr = s_qty_potr + vendp_qty_potr .
      s_nub = s_nub + vendp_nub .
      s_qty_oh3 = s_qty_oh3 + qty_oh3 .
      if xxcn_dec3 <> 0 then s_amt_con = s_amt_con + xxcn_dec3 .
      else   s_amt_con = s_amt_con + dec2 .

  
      DISPLAY  xxcn_vend  vd_sort when (avail vd_mstr) xxcn_part  pt_desc1  st1 cost1  
                       sum1 sum1 * cost1 @ con2 
                       vendp_qty_potr 
                       vendp_nub  @ xxcn_dec4 
                       vendp_qty_potr * cost1  @ s_amt_potr 
                       vendp_qty_con  
                       vendp_qty_inv 
                       vendp_amt_inv 
                       qty_oh3   
                       qty_oh3  * cost1 @ vendp_amt_oh3 WITH FRAME c .
                if xxcn_dec3 <> 0 then display xxcn_dec3 @ dec2 with frame c .
                    else display dec2 with frame c .
               DOWN WITH FRAME c .

   if last-of(vendp_vend) then
   do:   display "С��:" @ xxcn_vend  
              s_qty_sum1 @ sum1 
              s_amt_sum1 @ con2
              s_qty_potr @ vendp_qty_potr 
              s_amt_potr @ s_amt_potr
              s_qty_con @ vendp_qty_con 
              s_amt_con @ dec2 
               s_nub @ xxcn_dec4 
              s_qty_oh3 @ qty_oh3 
              s_qty_oh3 * cost1 @ vendp_amt_oh3 
      with frame c .
      down with frame c .
   end.   
 end.

 for each xxcn_mstr where xxcn_domain =  GLOBAL_domain 
                      AND xxcn_year = yy AND xxcn_month = mm AND xxcn_site = site 
                      and xxcn_vend >= vend and xxcn_vend <= vend1 
                      and xxcn_part >= part and xxcn_part <= part1
                      and thism = no and (cost# = 1 or cost# = 3)
                      break by xxcn_vend  :

        if first-of(xxcn_vend) then assign s_qty_con = 0 s_qty_potr = 0  s_nub = 0 ii = 0 .       
        
        FIND FIRST vd_mstr WHERE cd_domain = global_domain and  vd_addr = xxcn_vend NO-LOCK NO-ERROR .
        FIND FIRST pt_mstr WHERE pt_domain = global_domain and  pt_part = xxcn_part NO-LOCK NO-ERROR .
        find first vendp where vendp_vend = xxcn_vend and vendp_part = xxcn_part no-lock no-error .
    
        xxcn_dec2 = xxcn_qty_con * xxcn_cost .  
        FIND FIRST cd_det WHERE cd_domain = global_domain and cd_ref = xxcn_part AND cd_type = "sc" NO-LOCK NO-ERROR .
        IF avail  cd_det THEN
        DO: 
            l = INDEX(cd_cmmt[1],":") + 1 .
            st1 = trim(SUBSTRING(cd_cmmt[1],l,20)) .
        END. ELSE st1 = "" .
            
       sum1 =  xxcn_qty_fir_oh + xxcn_qty_con_fir .

       if avail vendp then qty_oh3 = xxcn_qty_fir_oh + vendp_qty_potr
                                      - vendp_qty_con + vendp_qty_re_scrp .
                      else qty_oh3 = xxcn_qty_fir_oh .        
       if avail vendp then con2 = xxcn_qty_con_fir + vendp_qty_con .
                      else con2 = xxcn_qty_con_fir .
       if avail vendp then   con3 = xxcn_qty_con_fir + vendp_qty_con  - vendp_qty_inv .
                      else   con3 = xxcn_qty_con_fir .
       sum5 = qty_oh3 + con3 .
       fir# = xxcn_qty_con_fir .
       if avail vendp then  s_qty_con = s_qty_con + vendp_qty_con .
                      
       if avail vendp then  s_qty_potr = s_qty_potr + vendp_qty_potr .
                     
       if avail vendp then  s_nub = s_nub + vendp_nub .
                      
          ii = ii + 1 .

      DISPLAY xxcn_vend 
              vd_sort WHEN (AVAIL vd_mstr) xxcn_part
              pt_desc1 WHEN (AVAIL pt_mstr)  
              st1
              xxcn_qty_fir_oh  
              xxcn_qty_con_fir
              sum1 
              vendp_nub when (avail vendp) 

              vendp_qty_potr when (avail vendp) 
              vendp_qty_con when (avail vendp) 
              vendp_qty_re_scrp when (avail vendp) 
              fir# 
              con2  
              vendp_qty_inv when (avail vendp) 
              qty_oh3 
              con3 
              sum5 
             WITH FRAME b .
   DOWN WITH FRAME b .

   if last-of(xxcn_vend) then
   do :
      display "С��:" @ xxcn_part  II @ pt_desc1 
             s_qty_potr @ vendp_qty_potr s_qty_con @ vendp_qty_con 
               s_nub @ vendp_nub 
      with frame b .
      down with frame b .
   end .

  END.

  for each xxcn_mstr where xxcn_domain =  GLOBAL_domain 
                      AND xxcn_year = yy AND xxcn_month = mm AND xxcn_site = site 
                      and xxcn_vend >= vend and xxcn_vend <= vend1 
                      and xxcn_part >= part and xxcn_part <= part1
                      and thism = no and (cost# = 2 or cost# = 3)
                      break by xxcn_vend  :
    
      IF first-of(xxcn_vend) then 
      assign s_qty_sum1 = 0
             s_amt_sum1 = 0
             s_qty_potr = 0
             s_amt_potr = 0 
             s_qty_con = 0
             s_amt_con = 0 
             s_qty_oh3 = 0
             s_nub = 0 .
 
      find first vendp where vendp_vend = xxcn_vend and vendp_part = xxcn_part 
                no-error .
     
      FIND FIRST vd_mstr WHERE vd_domain = global_domain and  vd_addr = xxcn_vend NO-LOCK NO-ERROR .
      FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain and pt_part = xxcn_part NO-LOCK NO-ERROR .
      FIND FIRST cd_det WHERE cd_ref = xxcn_part AND cd_type = "pt" NO-LOCK NO-ERROR .
      IF avail  cd_det THEN
      DO: 
          l = INDEX(cd_cmmt[1],":") + 1 .
          st1 = trim(SUBSTRING(cd_cmmt[1],l,20)) .
      END. ELSE st1 = "" .

      find last pc_mstr where pc_domain = GLOBAL_domain and trim(pc_list) = "C" + trim(xxcn_vend) 
                           and pc_curr = "RMB" and (trim(pc_prod_line) = "" or pc_prod_line = ?)
                           and pc_part = xxcn_part and pc_um = pt_um  
                           and (pc_start <= today or pc_start = ? ) 
                           and (pc_expire >= today or pc_expire = ?)
                           and pc_amt_type = "p"  no-lock no-error .
      
      IF AVAIL pc_mstr  THEN assign cost1 = pc_amt[1] .
                        ELSE  cost1 = 0 .  
     
      if avail vendp then dec2 = vendp_qty_con * cost1 . else dec2 = 0 .   
      sum1 = xxcn_qty_fir_oh + xxcn_qty_con_fir .
       
      if avail vendp then  con2 = xxcn_qty_con_fir + vendp_qty_con .
                      else con2 = xxcn_qty_con_fir .
      if avail vendp then  con3 = xxcn_qty_con_fir + vendp_qty_con  -  vendp_qty_inv .
                      else con3 = xxcn_qty_con_fir .
 
      if avail vendp then qty_oh3 = xxcn_qty_fir_oh + vendp_qty_potr
                                      - vendp_qty_con + vendp_qty_re_scrp .
                      else qty_oh3 = xxcn_qty_fir_oh . 

      s_qty_sum1 = s_qty_sum1 + sum1 .
      s_amt_sum1 = s_amt_sum1 + (sum1 * cost1) .
      if avail vendp then   s_amt_potr = s_amt_potr + (vendp_qty_potr * cost1). 
                     
      if avail vendp then  s_qty_con = s_qty_con + vendp_qty_con .
      if avail vendp then  s_qty_potr = s_qty_potr + vendp_qty_potr .
      if avail vendp then  s_nub = s_nub + vendp_nub .
      s_qty_oh3 = s_qty_oh3 + qty_oh3 .
      if xxcn_dec3 <> 0 then s_amt_con = s_amt_con + xxcn_dec3 .
      else   s_amt_con = s_amt_con + dec2 .

  
      DISPLAY  xxcn_vend  vd_sort when (avail vd_mstr) xxcn_part  pt_desc1  st1 cost1  
                       sum1 sum1 * cost1 @ con2 
                       vendp_qty_potr when (avail vendp)
                       vendp_nub when (avail vendp) @ xxcn_dec4 
                       vendp_qty_potr * cost1 when (avail vendp) @ s_amt_potr 
                       vendp_qty_con  when (avail vendp) 
                       vendp_qty_inv when (avail vendp)
                       vendp_amt_inv when (avail vendp)
                       qty_oh3   
                       qty_oh3  * cost1 @ vendp_amt_oh3 WITH FRAME c .
                if xxcn_dec3 <> 0 then display xxcn_dec3 @ dec2 with frame c .
                    else display dec2 with frame c .
               DOWN WITH FRAME c .

   if last-of(xxcn_vend) then
   do:   display "С��:" @ xxcn_vend  
              s_qty_sum1 @ sum1 
              s_amt_sum1 @ con2
              s_qty_potr @ vendp_qty_potr 
              s_amt_potr @ s_amt_potr
              s_qty_con @ vendp_qty_con 
              s_amt_con @ dec2 
               s_nub @ xxcn_dec4 
              s_qty_oh3 @ qty_oh3 
              s_qty_oh3 * cost1 @ vendp_amt_oh3 
      with frame c .
      down with frame c .
   end.   
 END.

 


      {mfrpexit.i}  

      {mfreset.i}  
ȡ����ӡ*/       
/*

/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
*/
  yn = YES .
  if mm = 12 then assign mm1 = 1 
                         yy1 = yy + 1.
             else
                  assign yy1 = yy.            
  if mm < 12 then assign mm1 = mm + 1 .
  
 
     find first qad_wkfl where qad_domain =  global_domain 
                       and  qad_key1 = "xxcn_mstr" 
                       and  qad_key2 = "xxxcode" 
                       no-error .
     if not avail qad_wkfl then 
     do:
      create qad_wkfl .
      qad_domain = global_domain  .
      qad_key1 = "xxcn_mstr" .
      qad_key2 = "xxxcode"  .
      qad_key3 = "" .
     end . 
  /*  
  if year(today) >= 2011 and month(today) >= 5 and day(today) >= 20 and qad_key3 <> "A123890C" then 
  do: 
   xxxcode1 = "" .
   message "ע����" update xxxcode1 .
   qad_key3 = xxxcode1 .
   if xxxcode1 <> "A123890C" then do : message "�����!" .
                                  pause(3) .
                                  return .
                                end.
  end.
  */
  
  MESSAGE "��������ȷ��(y/n) " UPDATE yn .
  /*
  if thism = yes and yn = yes then do: message "����ֻѡ�����<>0������,����������ʱ" .
                         pause(3) .
                         return .
                      end.  
  */       
  IF yn AND  UP_qty_oh_fir = YES THEN 

    FOR EACH vendp :
        FIND  FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain 
                                and xxcn_vend = vendp_vend 
                                AND xxcn_part = vendp_part AND xxcn_year = yy 
                                AND xxcn_month = mm AND xxcn_site = site NO-ERROR .
        
        IF AVAIL xxcn_mstr  THEN ASSIGN firqtyoh = xxcn_qty_fir_oh firqtycon =  xxcn_qty_con_fir . 
        ELSE ASSIGN firqtyoh = 0 firqtycon =  0 .

        FIND  FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain 
                               and xxcn_vend = vendp_vend AND xxcn_part = vendp_part 
                               AND xxcn_year = yy1 AND xxcn_month = mm1 AND xxcn_site = site NO-ERROR .
     
        IF NOT AVAIL xxcn_mstr THEN 
        DO:
         CREATE xxcn_mstr .
         xxcn_domain = GLOBAL_domain . 
         xxcn_vend = vendp_vend . 
         xxcn_part = vendp_part . 
         xxcn_site = site .
         xxcn_year = yy1 .
         xxcn_month = mm1 .
         xxcn_po_stat = "" .
        END.       
        
        xxcn_qty_fir_oh = vendp_lastqty_oh .   /*�����ڳ� = ������ĩ*/
        /*xxcn_qty_con_fir = firqtycon + vendp_qty_con  - vendp_qty_inv .   ����*/
           
    END. 
      
 IF yn AND  UP_qty_con = YES THEN 
    FOR EACH vendp :
        FIND  FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain 
                               and xxcn_vend = vendp_vend AND xxcn_part = vendp_part
                              AND xxcn_year = yy AND xxcn_month = mm AND xxcn_site = site NO-ERROR .
     
        IF NOT AVAIL xxcn_mstr THEN
        DO:
         CREATE xxcn_mstr .
         xxcn_domain = GLOBAL_domain .
         xxcn_vend = vendp_vend .
         xxcn_part = vendp_part .
         xxcn_site = site .
         xxcn_year = yy .
         xxcn_month = mm .
         xxcn_po_stat = "" .
         xxcn_dec5 = vendp_qty_potr .      /*�����*/
         xxcn_qty_con = 0 + vendp_qty_potr - vendp_lastqty_oh - vendp_qty_re_scrp.    /*������ = �ڳ� + ������� - �����˻� - ���ڽ��*/
         xxcn_dec6 = vendp_qty_re_scrp.    /*�˻���*/
         xxcn_dec3 = vendp_lastqty_oh.     /*��ĩ��*/

        END.
        else assign xxcn_dec5 = vendp_qty_potr 
                    xxcn_qty_con = xxcn_qty_fir_oh + vendp_qty_potr - vendp_lastqty_oh - vendp_qty_re_scrp
                    xxcn_dec6 = vendp_qty_re_scrp
                    xxcn_dec3 = vendp_lastqty_oh
                    .
                    
       find first vd_mstr where vd_domain = global_domain and vd_addr =  vendp_vend no-lock no-error.
       if avail vd_mstr then
       	do:
       		if vd_type = "I" then
       			do:
       		 			xxcn_qty_rcv = vendp_qty_potr - vendp_qty_re_scrp.
       		 			xxcn_ch3 = "I".
       		  end.
       		if vd_type = "U" then
       		  do:
       		 			xxcn_qty_rcv = xxcn_qty_fir_oh + vendp_qty_potr - vendp_lastqty_oh - vendp_qty_re_scrp.
       		 			xxcn_ch3 = "U".
       		 	end.		
       		if vd_type = "X" then 
       		  do:
       		  	xxcn_qty_rcv = 0.
       		  	xxcn_ch3 = "X".
       		  end.
       		if vd_type = "C" then
       		  do:
       		 		xxcn_qty_rcv = 0.
       		 		xxcn_ch3 = "C".
       		 	end.
       	end.     
             
/*
        FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain and pt_part = xxcn_part NO-LOCK NO-ERROR .
        find last pc_mstr where pc_domain = GLOBAL_domain and trim(pc_list) = "C" + trim(xxcn_vend) 
                           and pc_curr = "RMB" and (trim(pc_prod_line) = "" or pc_prod_line = ?)
                           and pc_part = xxcn_part and pc_um = pt_um  
                           and (pc_start <= today or pc_start = ? ) 
                           and (pc_expire >= today or pc_expire = ?)
                           and pc_amt_type = "p"  no-lock no-error .
      
        IF AVAIL pc_mstr  THEN   xxcn_cost = pc_amt[1] .  
          xxcn_dec2 = xxcn_qty_con * xxcn_cost .    
*/              
    END. 
end.


