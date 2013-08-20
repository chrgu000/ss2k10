/* lhcnrp31.p - consignment vend report                                 */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*create by tonylihu   2011-01-12                                        */
/*modify by hong zhang 2011-04-15                                      */

{mfdtitle.i "20121222.1 "}

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
define new shared variable tax_tr_type     like tx2d_tr_type no-undo
   initial '21'.
define variable site like tr_site.
define variable site1 like tr_site.
define variable vend like prh_vend.
define variable vend1 like prh_vend.
define variable part like prh_part.
define variable part1 like prh_part.
define variable cn_date like prh_rcp_date.
define variable cn_date1 like prh_rcp_date.
DEFINE VAR vm AS CHAR FORMAT "x(22)" .
DEFINE VAR UP_po AS logi .
define var  UP_firPO  as logi .
DEFINE VAR YN AS LOGI .
DEFINE VAR POLINE LIKE POD_LINE .
DEFINE VAR POSITE LIKE PO_SITE .
DEFINE VAR popss AS logi .
define var poqty like pod_qty_ord .
define var thism as logi .
/*�ź�� 2011-04-13*/
DEFINE VAR xxyy LIKE xxcn_year.
DEFINE VAR xxmm LIKE xxcn_month.
DEFINE VAR xxmm1 AS CHAR.
DEFINE VAR xxs1 AS CHAR FORMAT 'x(25)'.
DEFINE VAR xxs2 AS CHAR FORMAT 'x(6)'.
DEFINE VAR xxs3 AS CHAR.
DEFINE VAR xxs4 LIKE vd_sort.
DEFINE VAR xxs5 LIKE pt_desc1.
DEFINE VAR xxs6 LIKE ad_addr.
DEFINE VAR xxd1 AS DATE.
DEFINE VAR xxd2 AS DATE.
DEFINE VAR xxd3 AS DATE.
DEFINE VAR xxd4 AS DATE.
DEFINE BUFFER xxcnbuf FOR xxcn_mstr.
DEFINE VAR xxyn AS LOG.
/*�ź��  2011-04-13*/
def stream out1 .
define var ofile1 as char .
DEFINE VAR  in_fld AS CHAR .
DEFINE VAR  out_fld AS CHAR .
define var poid as inte .
define var ponbr like po_nbr .
define var cost1 as dec .
define var xxxcode1 as char format "x(8)" .
define variable xxmysum1 like tr_qty_chg.
define variable xxmysum2 like tr_qty_chg.
define variable xxmysum3 like tr_qty_chg.
define variable xxmysum4 like tr_qty_chg.
define variable xxmysum5 like tr_qty_chg.
define variable xxmysum6 like tr_qty_chg.
define variable mytitlename like dom_name.
find first dom_mstr no-lock where dom_domain = global_domain .
mytitlename = dom_name + "  ���ʱ�" .


define temp-table xxtempcn_mstr NO-UNDO  /*�ź�� ����ʱ�����ڼ�¼����ʾ������ 2011-04-13*/
 FIELD xxtempcn_vend   LIKE xxcn_vend
 FIELD xxtempcn_part   LIKE pt_part
 FIELD xxtempcn_qty1   LIKE tr_qty_chg INIT 0 /*�ڳ�*/
 FIELD xxtempcn_qty2   LIKE tr_qty_chg INIT 0 /*������*/
 FIELD xxtempcn_perd   AS CHAR                /*��������*/
 FIELD xxtempcn_qty3   LIKE tr_qty_chg INIT 0  /*�����*/
 FIELD xxtempcn_qty4   LIKE tr_qty_chg INIT 0 /*�˻���*/
 FIELD xxtempcn_qty5   LIKE tr_qty_chg INIT 0 /*��ĩ��*/
 FIELD xxtempcn_qty6   LIKE tr_qty_chg INIT 0 /*������*/
 FIELD xxtempcn_qty7   LIKE xxpc_amt[1] format "->>>>>,>>9.9999" INIT 0 /*����*/
 FIELD xxtempcn_qty8   LIKE tr_qty_chg INIT 0  /*���*/
 FIELD xxtempcn_ch3    AS CHAR  /*���ʷ�ʽ*/
 FIELD xxtempcn_ch4    AS LOG.  /*�۸�����,yes:��ʽ��  no:�ݹ��ۻ����޼�*/

define temp-table mytempcn_mstr NO-UNDO  /*�ź�� ����ʱ�����ڼ�¼����ʾ������ 2011-04-13*/
 FIELD mytempcn_vend   LIKE xxcn_vend
 FIELD mytempcn_part   LIKE pt_part
 FIELD mytempcn_qty1   LIKE tr_qty_chg INIT 0 /*�ڳ�*/
 FIELD mytempcn_qty2   LIKE tr_qty_chg INIT 0 /*������*/
 FIELD mytempcn_perd   AS CHAR                /*��������*/
 FIELD mytempcn_qty3   LIKE tr_qty_chg INIT 0  /*�����*/
 FIELD mytempcn_qty4   LIKE tr_qty_chg INIT 0 /*�˻���*/
 FIELD mytempcn_qty5   LIKE tr_qty_chg INIT 0 /*��ĩ��*/
 FIELD mytempcn_qty6   LIKE tr_qty_chg INIT 0 /*������*/
 FIELD mytempcn_qty7   LIKE xxpc_amt[1] format "->>>>>,>>9.9999" INIT 0 /*����*/
 FIELD mytempcn_qty8   LIKE tr_qty_chg INIT 0  /*���*/
 FIELD mytempcn_ch3    AS CHAR  /*���ʷ�ʽ*/
 FIELD mytempcn_ch4    AS LOG.  /*�۸�����,yes:��ʽ��  no:�ݹ��ۻ����޼�*/

define var myfilett as char.
myfilett = "/test001.txt".

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
form
   site           colon 15
   site1          label {t001.i} colon 49
   vend           colon 15
   vend1          label {t001.i} colon 49
   part           colon 15
   part1          label {t001.i} colon 49
   xxyy LABEL '�ڼ���' COLON 15 /*�ź�� ���빩�û�ѡ����ڼ� 2011-04-13*/
   xxmm LABEL '�ڼ���' COLON 15

  /* thism  label "ֻ��ʾ���º���<>0��" colon 65 */
   skip(1)
  /* cn_date1      label "������(����3������,����ͱ�����3��1�ź������)"  colon 59*/
with frame a attr-space side-labels width 80.

setFrameLabels(frame a:handle).

convertmode = "REPORT".

view frame a.

FORM 
/* xxcn_vend  label "��Ӧ�̴���" 
 ad_name  LABEL "��Ӧ������" FORMAT 'x(12)'  */
/* vd_type  label '���ʷ�ʽ'  */
 xxcn_part label "���ϱ���" 
 pt_desc1 label "��������" 
/* pt_um label "��λ"  */
 xxcn_qty_fir_oh label  "�ڳ���"
/* xxcn_qty_con LABEL '������'*/
 xxcn_qty_inv_fir COLUMN-LABEL "ǰ��    !ĩ������"
 xxs2 LABEL '��������'
 xxcn_dec5 LABEL '�����'
 xxcn_dec6 COLUMN-LABEL '�˻���'
 xxcn_qty_inv LABEL '��ĩ��'
 xxcn_qty_rcv LABEL '������'
 xxcn_cost LABEL '����' 
 xxcn_dec3 LABEL '���'
 with frame C width 260 NO-BOX STREAM-IO down .  


FORM  header 
SKIP
mytitlename at 50 
SKIP(1)
'�����ʱ�������:��������;������Ӧ�̽�Ʊʱ���ز���;������Ӧ�̴��¹��˽��ز���' at 2  
'��������:' AT 90 xxs1 AT 100
SKIP (1)
 '��Ӧ�̱���:' AT 2 xxs6 AT 14
 '��Ӧ������:' AT 24 xxs4  AT 36
SKIP(1)
with PAGE-TOP  no-box width 180 frame t NO-ATTR-SPACE .

assign
   cn_date   = today - 30
   cn_date1  = today .

  site = "11000" .
  site1 = "11000" .
  UP_PO = NO .
repeat:

   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".
   if vend1 = hi_char then vend1 = "".
   if xxyy = 0 then xxyy = year(today).
   if xxmm = 0 then xxmm  = MONTH(TODAY).
   update
      site site1 vend vend1 part part1  xxyy xxmm 
   with frame a.
   /*�ź�� 2011-04-13*/
   IF  xxmm < 1 OR xxmm > 12   THEN
   DO:
       MESSAGE '������ڼ䷶Χ��ʽ��������.'.
       UNDO,RETRY.
   END.
       

   /*�ź�� 2011-04-13*/

   bcdparm = "".
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i vend}
   {mfquoter.i vend1}
   {mfquoter.i part}
   {mfquoter.i part1}
   {mfquoter.i xxyy}
   {mfquoter.i xxmm}
   
  
   if site1 = "" then site1 = hi_char.
   if part1 = "" then part1 = hi_char.
   if vend1 = "" then vend1 = hi_char.
   
 {mfselbpr.i "printer" 80}
 
 EMPTY TEMP-TABLE xxtempcn_mstr.
 EMPTY TEMP-TABLE mytempcn_mstr.

 ASSIGN xxd1= hi_date
        xxd2 = hi_date.

 FIND FIRST glc_cal NO-LOCK WHERE glc_domain = GLOBAL_domain and glc_year = xxyy AND glc_per = xxmm  NO-ERROR.

 IF AVAIL glc_cal  THEN
 DO:
     
     ASSIGN xxd1 = glc_start
            xxd2 = glc_end.
 END. /*IF AVAIL glc_cal  THEN*/
 /*���û���ڼ��Ƿ�ر�,ע����ͨ�ص�Ҫ��*/
 IF xxmm <= 9 THEN
     SET xxmm1 = '00'+ string(xxmm).
 IF xxmm > 9 THEN
     SET xxmm1 = '0' + STRING(xxmm).
     
 FIND FIRST  qad_wkfl WHERE qad_domain = GLOBAL_domain AND qad_key1 = 'Glcd_det' AND SUBSTRING(qad_key2 , 1 ,4) = string(xxyy) AND   SUBSTRING(qad_key2 , 5 ,3) = xxmm1 AND SUBSTRING(qad_key2 , 8 ,4) = '1000' NO-LOCK NO-ERROR.
 IF NOT AVAIL qad_wkfl OR (AVAIL qad_wkfl AND qad_decfld[1] = 1) OR NOT AVAIL glc_cal THEN
 DO:
       
       MESSAGE '���ڼ�:' + STRING(xxyy) + STRING(xxmm) + 'Ӧ������ڼ��ѹر�,����'.
       {mfreset.i}
       {mfgrptrm.i}
       UNDO,RETRY.
 END. /*IF NOT AVAIL qad_wkfl OR (AVAIL qad_wkfl AND qad_decfld[4] = 1) THEN*/
/*
output to value(myfilett).
put 111 today time skip.
output close.
*/
FOR EACH xxcn_mstr NO-LOCK WHERE xxcn_domain =  global_domain 
                       and   xxcn_vend >= vend AND xxcn_vend <= vend1 
                       AND xxcn_part >= part AND xxcn_part <= part1
                       AND xxcn_year = xxyy  AND xxcn_month = xxmm 
                      /* AND xxcn_po_stat <> "2"  /*ֻ��ȡĩ���ʲ���*/*/
                      AND xxcn_site >= site AND xxcn_site <= site1 use-index xxcn_vend_part :

  FIND FIRST vd_mstr NO-LOCK WHERE vd_domain = GLOBAL_domain AND vd_addr = xxcn_mstr.xxcn_vend AND ( vd_type = 'U' OR vd_type = 'I' OR vd_type = 'C')  NO-ERROR.  /*ֻ��ȡ�����/���ù��ʵĹ�Ӧ��*/
  IF NOT AVAIL vd_mstr THEN
      NEXT.

  CREATE xxtempcn_mstr.
  ASSIGN xxtempcn_vend = xxcn_mstr.xxcn_vend
         xxtempcn_part = xxcn_mstr.xxcn_part
         xxtempcn_perd = string(xxcn_mstr.xxcn_year) + STRING(xxcn_mstr.xxcn_month) /*��������*/
         xxtempcn_qty1 = xxcn_mstr.xxcn_qty_fir_oh
         xxtempcn_qty4 = xxcn_mstr.xxcn_dec6
         xxtempcn_qty6 = xxcn_mstr.xxcn_qty_rcv.
  
  IF xxcn_mstr.xxcn_po_stat = ""  THEN 
      ASSIGN xxtempcn_qty6 = xxcn_mstr.xxcn_qty_rcv.
  ELSE
      ASSIGN xxtempcn_qty6 = 0.

  xxtempcn_qty7 = xxcn_mstr.xxcn_cost.
  ASSIGN xxtempcn_qty3 =  xxcn_mstr.xxcn_dec5   /*�����*/
         xxtempcn_qty2 = xxcn_mstr.xxcn_qty_con /*������*/
         xxtempcn_ch3 = xxcn_mstr.xxcn_ch3.

  ASSIGN xxtempcn_qty5 = xxcn_mstr.xxcn_dec3 /*xxtempcn_qty1 + xxtempcn_qty3 - xxtempcn_qty4 - xxtempcn_qty2 /*���=�ڳ�+���-�˻�-����*/*/
         xxtempcn_qty8 = xxtempcn_qty6 * xxtempcn_qty7. /*���= ���� * ������*/
end.  /*for each xxcn_mstr*/
/*
output to value(myfilett) append.
put 222 today time skip.
output close.
*/
/*Ȼ��Ҫ����֮ǰ�·ݵ�ĩ���ʵ�����*/
for each xxtempcn_mstr:
  /*
  output to value(myfilett) append.
  put 22211 xxtempcn_vend "," xxtempcn_part "," today time skip.
  output close.
  */
  FOR EACH xxcn_mstr NO-LOCK use-index xxcn_vpssym WHERE xxcn_domain = GLOBAL_domain 
                             AND xxcn_vend = xxtempcn_vend AND xxcn_part = xxtempcn_part
                             AND xxcn_po_stat = "" 
                             AND xxcn_site >= site AND xxcn_site <= site1
                             AND (xxcn_year < xxyy or (xxcn_year = xxyy AND xxcn_month < xxmm))
                             :
  

       CREATE mytempcn_mstr.
       ASSIGN mytempcn_vend = xxcn_vend
              mytempcn_part = xxcn_part
              mytempcn_perd = string(xxcn_year) + STRING(xxcn_month) /*��������*/
              mytempcn_qty6 = xxcn_qty_rcv /*������*/
              mytempcn_qty7 = xxcn_cost.
              mytempcn_qty8 = mytempcn_qty6 * mytempcn_qty7 . /*���= ���� * ������*/
              mytempcn_ch3  = xxcn_ch3. /*���ʷ�ʽ*/

       IF mytempcn_ch3 = 'U' THEN /*���ù�*/
           SET mytempcn_qty2 = xxcn_qty_con  .
       IF mytempcn_ch3 = 'I' THEN /*����*/
           SET mytempcn_qty2 = xxcn_dec5 - xxcn_dec6 .
       IF mytempcn_ch3 = 'C' THEN /*�ֽ��*/
           SET mytempcn_qty2 = xxcn_dec5 - xxcn_dec6 .
  END. /*FOR EACH xxcnbuf NO-LOCK WHERE */
end.                  
/*        
output to value(myfilett) append.
put 333 today time skip.
output close.
*/
for each mytempcn_mstr:
  create xxtempcn_mstr.     
  xxtempcn_vend = mytempcn_vend  .
  xxtempcn_part = mytempcn_part  .
  xxtempcn_qty1 = mytempcn_qty1  .
  xxtempcn_qty2 = mytempcn_qty2  .
  xxtempcn_perd = mytempcn_perd  .
  xxtempcn_qty3 = mytempcn_qty3  .
  xxtempcn_qty4 = mytempcn_qty4  .
  xxtempcn_qty5 = mytempcn_qty5  .
  xxtempcn_qty6 = mytempcn_qty6  .
  xxtempcn_qty7 = mytempcn_qty7  .
  xxtempcn_qty8 = mytempcn_qty8  .
  xxtempcn_ch3  = mytempcn_ch3   .
  xxtempcn_ch4  = mytempcn_ch4   . 
end.
/*��Ҫ��֮ǰ�·���ĩ�������ݣ������û�ѡ��ĵ�ǰ�����ڼ��޹�������*/

 FOR EACH xxcn_mstr use-index xxcn_vend_part NO-LOCK WHERE xxcn_mstr.xxcn_domain =  global_domain 
                       and   xxcn_mstr.xxcn_vend >= vend AND xxcn_mstr.xxcn_vend <= vend1 
                       AND xxcn_mstr.xxcn_part >= part AND xxcn_mstr.xxcn_part <= part1
                       AND (xxcn_mstr.xxcn_year < xxyy OR ( xxcn_mstr.xxcn_year = xxyy AND xxcn_mstr.xxcn_month < xxmm))
                       AND xxcn_mstr.xxcn_po_stat <> "2"  /*ֻ��ȡĩ���ʲ���*/
                       AND xxcn_mstr.xxcn_qty_rcv <> 0
                      AND xxcn_mstr.xxcn_site >= site AND xxcn_mstr.xxcn_site <= site1 BREAK BY xxcn_mstr.xxcn_vend BY xxcn_mstr.xxcn_part :
     
     FIND FIRST vd_mstr NO-LOCK USE-INDEX vd_addr WHERE vd_domain = GLOBAL_domain and vd_addr = xxcn_mstr.xxcn_vend AND ( vd_type = 'U' OR vd_type = 'I' OR vd_type = 'C' )  NO-ERROR.  /*ֻ��ȡ�����/���ù��ʵĹ�Ӧ��*/
     IF NOT AVAIL vd_mstr THEN
         NEXT.

     FIND FIRST xxtempcn_mstr NO-LOCK WHERE xxtempcn_vend = xxcn_mstr.xxcn_vend AND xxtempcn_part = xxcn_mstr.xxcn_part AND xxtempcn_perd = STRING(xxyy) + STRING(xxmm) NO-ERROR.
     IF NOT AVAIL xxtempcn_mstr THEN DO:
         CREATE xxtempcn_mstr.
         ASSIGN xxtempcn_vend = xxcn_mstr.xxcn_vend
                xxtempcn_part = xxcn_mstr.xxcn_part
                xxtempcn_perd = string(xxcn_mstr.xxcn_year) + STRING(xxcn_mstr.xxcn_month) /*��������*/
                xxtempcn_qty6 = xxcn_mstr.xxcn_qty_rcv /*������*/
                xxtempcn_qty7 = xxcn_mstr.xxcn_cost
                xxtempcn_qty8 = xxtempcn_qty6 * xxtempcn_qty7 /*���= ���� * ������*/
                xxtempcn_ch3 = xxcn_mstr.xxcn_ch3. /*���ʷ�ʽ*/
                /*
                xxtempcn_ch4 = xxcn_mstr.xxcn_ch4.     /*�ݹ��ۻ��޼�*/
                */
         IF xxtempcn_ch3 = 'U' THEN         /*���ù�*/
             SET xxtempcn_qty2 = xxcn_mstr.xxcn_qty_con .
         IF xxtempcn_ch3 = 'I' THEN         /*����*/
             SET xxtempcn_qty2 = xxcn_mstr.xxcn_dec5 - xxcn_mstr.xxcn_dec6 .
         IF xxtempcn_ch3 = 'C' THEN         /*�ֽ��*/
             SET xxtempcn_qty2 = xxcn_mstr.xxcn_dec5 - xxcn_mstr.xxcn_dec6 . 
     END. /*IF NOT AVAIL xxtempcn_mstr THEN*/
 END. /*FOR EACH xxcn_mstr NO-LOCK WHERE xxcn_domain =  global_domain */

   SET xxs1 = STRING(xxd1) + '--' + STRING(xxd2).

   FOR EACH xxtempcn_mstr NO-LOCK BREAK BY xxtempcn_vend BY xxtempcn_part BY xxtempcn_perd DESC:

       ACCUMULATE xxtempcn_qty1 (TOTAL BY xxtempcn_vend).
       ACCUMULATE xxtempcn_qty3 (TOTAL BY xxtempcn_vend).
       ACCUMULATE xxtempcn_qty4 (TOTAL BY xxtempcn_vend).
       ACCUMULATE xxtempcn_qty5 (TOTAL BY xxtempcn_vend).
       ACCUMULATE xxtempcn_qty6 (TOTAL BY xxtempcn_vend).
       ACCUMULATE xxtempcn_qty8 (TOTAL BY xxtempcn_vend).
       IF FIRST-OF (xxtempcn_vend) THEN
       DO:
           ASSIGN xxs6 = xxtempcn_vend.
           FIND FIRST vd_mstr NO-LOCK USE-INDEX vd_addr WHERE vd_domain = GLOBAL_domain and vd_addr = xxtempcn_vend  NO-ERROR.
           IF xxtempcn_ch3 = 'U' THEN
               SET xxs3 = '���ù�'.
           ELSE if xxtempcn_ch3 = 'I' then 
               SET xxs3 = '����'.
           ELSE if xxtempcn_ch3 = 'C' then 
               SET xxs3 = '�ֽ��'.
           SET xxs4 = vd_sort.
           VIEW FRAME t.
      END. /* IF FIRST-OF (xxtempcn_vend) THEN*/

       if first-of(xxtempcn_vend) then do:
         xxmysum1 = 0.
         xxmysum2 = 0.
         xxmysum3 = 0.
         xxmysum4 = 0.
         xxmysum5 = 0.
         xxmysum6 = 0.         
       end.
         xxmysum1 = xxmysum1 + xxtempcn_qty1.
         xxmysum2 = xxmysum2 + xxtempcn_qty3.
         xxmysum3 = xxmysum3 + xxtempcn_qty4.
         xxmysum4 = xxmysum4 + xxtempcn_qty5.
         xxmysum5 = xxmysum5 + xxtempcn_qty6.
         xxmysum6 = xxmysum6 + xxtempcn_qty8.
       if first-of(xxtempcn_part) THEN
       DO:
            FIND FIRST pt_mstr NO-LOCK USE-INDEX pt_part WHERE  pt_domain = GLOBAL_domain and pt_part = xxtempcn_part NO-ERROR.
            SET xxs5 = pt_desc1.
       END.
          

 
       	    /*modify by billy 2011-05-23 ȥ��������Ϊ0�ģ�Ҳ����ǰ���޺��õĲ���*/
       	    if xxtempcn_qty1 <> 0 or xxtempcn_qty2 <> 0 or xxtempcn_qty3 <> 0 or xxtempcn_qty4 <> 0 or xxtempcn_qty5 <> 0 or xxtempcn_qty6 <> 0 then
       	    	do:  
       	    	 if xxtempcn_perd <> string(xxyy) + string(xxmm) then do:

		            DISP 
		              xxs5 @ pt_desc1 
		              xxtempcn_part @ xxcn_mstr.xxcn_part
		              xxtempcn_qty1 @ xxcn_mstr.xxcn_qty_fir_oh 
		              xxtempcn_qty2 @ xxcn_mstr.xxcn_qty_inv_fir 
		              xxtempcn_qty3 @ xxcn_mstr.xxcn_dec5
		              xxtempcn_qty4 @ xxcn_mstr.xxcn_dec6
		              xxtempcn_qty5 @ xxcn_mstr.xxcn_qty_inv
		              xxtempcn_perd @ xxs2 
		              xxtempcn_qty6 @ xxcn_mstr.xxcn_qty_rcv 
		              xxtempcn_qty7 @ xxcn_mstr.xxcn_cost 
		              xxtempcn_qty8 @ xxcn_mstr.xxcn_dec3 
		            WITH FRAME C.
		            DOWN WITH FRAME C.
		           end. 
		           if xxtempcn_perd = string(xxyy) + string(xxmm) then do:
		            DISP 
		              xxs5 @ pt_desc1 
		              xxtempcn_part @ xxcn_mstr.xxcn_part
		              xxtempcn_qty1 @ xxcn_mstr.xxcn_qty_fir_oh 
		               
		              xxtempcn_qty3 @ xxcn_mstr.xxcn_dec5
		              xxtempcn_qty4 @ xxcn_mstr.xxcn_dec6
		              xxtempcn_qty5 @ xxcn_mstr.xxcn_qty_inv
		              
		              xxtempcn_qty6 @ xxcn_mstr.xxcn_qty_rcv 
		              xxtempcn_qty7 @ xxcn_mstr.xxcn_cost 
		              xxtempcn_qty8 @ xxcn_mstr.xxcn_dec3 
		            WITH FRAME C.
		            DOWN WITH FRAME C.
		           end. 
		          end. /* if xxtempcn_qty1 <> 0 or xxtempcn_qty2 <> 0 or xxtempcn_qty3 <> 0 */
           
       IF LAST-OF( xxtempcn_vend ) THEN
       DO:
          DISP '   �ϼƣ�' @ xxcn_mstr.xxcn_part 
             xxmysum1  @ xxcn_mstr.xxcn_qty_fir_oh
             xxmysum2  @ xxcn_mstr.xxcn_dec5
             xxmysum3  @ xxcn_mstr.xxcn_dec6
             xxmysum4  @ xxcn_mstr.xxcn_qty_inv
             xxmysum5  @ xxcn_mstr.xxcn_qty_rcv
             xxmysum6  @ xxcn_mstr.xxcn_dec3 WITH FRAME C.
          DOWN WITH FRAME C.
          put skip.
          put "��Ӧ��ǩ��:".
          IF NOT LAST( xxtempcn_vend ) THEN
              PAGE.
       END. /*IF LAST-OF( xxtempcn_vend ) THEN*/

       IF   page-size - LINE-COUNTER < 5 THEN 
          PAGE.

   END. /*FOR EACH xxtempcn_mstr NO-LOCK:*/

  {mfreset.i}
  {mfgrptrm.i}

   SET xxyn = NO.
   MESSAGE '�Ƿ�ȷ���´�ù��ʵ�?' UPDATE xxyn.
   DO TRANS ON ERROR UNDO,RETRY:
   IF xxyn = YES THEN DO:
        FOR EACH xxtempcn_mstr NO-LOCK WHERE xxtempcn_qty6 <> 0 AND xxtempcn_qty7 <> 0: /*ֻ��д�ù���������Ϊ0,���м۸������*/
            FIND FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain AND xxcn_vend = xxtempcn_vend AND xxcn_part = xxtempcn_part 
                                   AND xxcn_year = int(SUBSTRING(xxtempcn_perd , 1 , 4)) AND xxcn_month = int(SUBSTRING(xxtempcn_perd , 5 , LENGTH(trim(STRING(xxtempcn_perd))) - 4 ))
                                   AND xxcn_po_stat = "" NO-ERROR.
            IF AVAIL xxcn_mstr THEN
            DO:
          	
                ASSIGN xxcn_po_stat = '2'
                       xxcn_ch1 = trim(string(xxyy)) +  trim(STRING(xxmm))
                       /*
                       xxcn_cost = xxtempcn_qty7
                       xxcn_ch3 = xxtempcn_ch3.  /*���ʷ�ʽ*/
                       */
                       xxcn_ch4 = string(xxyy).
                       xxcn_ch5 = string(xxmm,"99").
            END. /*IF AVAIL xxcn_mstr THEN*/
        END. /*FOR EACH xxtempcn_mstr NO-LOCK WHERE xxtempcn_qty6 <> 0:*/
   END. /*IF xxyn = YES THEN*/
   END. /*DO TRANS ON ERROR UNDO,RETRY:*/


END.



