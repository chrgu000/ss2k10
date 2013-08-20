/* lhcnrp31.p - consignment vend report                                 */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*create by tonylihu   2011-01-12                                        */
/*modify by hong zhang 2011-04-15                                      */

{mfdtitle.i "1+ "}

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
 xxcn_qty_inv_fir COLUMN-LABEL "ǰ��    !δ������"
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
"������ͨ�������޹�˾--��ͨ�������ʱ�" at 50 
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

 ASSIGN xxd1= hi_date
        xxd2 = hi_date.

 FIND FIRST glc_cal NO-LOCK WHERE glc_year = xxyy AND glc_per = xxmm AND glc_domain = GLOBAL_domain NO-ERROR.

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
     
 FIND FIRST  qad_wkfl WHERE qad_key1 = 'Glcd_det' AND SUBSTRING(qad_key2 , 1 ,4) = string(xxyy) AND qad_domain = GLOBAL_domain AND  SUBSTRING(qad_key2 , 5 ,3) = xxmm1 AND SUBSTRING(qad_key2 , 8 ,4) = '1000' NO-LOCK NO-ERROR.
 IF NOT AVAIL qad_wkfl OR (AVAIL qad_wkfl AND qad_decfld[1] = 1) OR NOT AVAIL glc_cal THEN
 DO:
       
       MESSAGE '���ڼ�:' + STRING(xxyy) + STRING(xxmm) + 'Ӧ������ڼ��ѹر�,����'.
       {mfreset.i}
       {mfgrptrm.i}
       UNDO,RETRY.
 END. /*IF NOT AVAIL qad_wkfl OR (AVAIL qad_wkfl AND qad_decfld[4] = 1) THEN*/


 FOR EACH xxcn_mstr NO-LOCK WHERE xxcn_domain =  global_domain 
                       and   xxcn_vend >= vend AND xxcn_vend <= vend1 
                       AND xxcn_part >= part AND xxcn_part <= part1
                       AND xxcn_year = xxyy  AND xxcn_month = xxmm 
                      /* AND xxcn_po_stat <> "2"  /*ֻ��ȡĩ���ʲ���*/*/
                      AND xxcn_site >= site AND xxcn_site <= site1 use-index xxcn_vend_part :
    
  find FIRST xxpc_mstr USE-INDEX xxpc_list where xxpc_domain = GLOBAL_domain and trim(xxpc_list) =  trim(xxcn_vend) 
                           and  trim(xxpc_prod_line) = "yes" /*ֻ��Э���*/
                           and  xxpc_part = xxcn_part 
                           and  (xxpc_start <= xxd1 or xxpc_start = ? ) 
                           and  (xxpc_expire >= xxd2 or xxpc_expire = ?)
                            no-lock no-error .

  FIND FIRST vd_mstr NO-LOCK USE-INDEX vd_addr WHERE vd_addr = xxcn_mstr.xxcn_vend AND vd_domain = GLOBAL_domain AND ( trim(vd_type) = 'U' OR trim(vd_type) = 'I' )  NO-ERROR.  /*ֻ��ȡ�����/���ù��ʵĹ�Ӧ��*/
  IF NOT AVAIL vd_mstr THEN
      NEXT.
  
/*
 define temp-table xxtempcn_mstr NO-UNDO  /*�ź�� ����ʱ�����ڼ�¼����ʾ������ 2011-04-13*/
 FIELD xxtempcn_vend   LIKE xxcn_vend
 FIELD xxtempcn_part   LIKE pt_part
 FIELD xxtempcn_qty1   LIKE tr_qty_chg  /*�ڳ�*/
 FIELD xxtempcn_qty2   LIKE tr_qty_chg  /*������*/
 FIELD xxtempcn_perd   AS CHAR          /*��������*/
 FIELD xxtempcn_qty3   LIKE tr_qty_chg  /*�����*/
 FIELD xxtempcn_qty4   LIKE tr_qty_chg  /*�˻���*/
 FIELD xxtempcn_qty5   LIKE tr_qty_chg  /*��ĩ��*/
 FIELD xxtempcn_qty6   LIKE tr_qty_chg  /*������*/
 FIELD xxtempcn_qty7   LIKE tr_qty_chg  /*����*/
 FIELD xxtempcn_qty8   LIKE tr_qty_chg. /*���*/  
*/

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


  IF AVAIL xxpc_mstr THEN
  DO:
      ASSIGN xxtempcn_qty7 = xxpc_amt[1]
             xxtempcn_ch4 = YES. /*��ʽ��*/
  END.
      
  ELSE
  DO:
      ASSIGN xxtempcn_qty7 = 0
             xxtempcn_qty6 = xxcn_mstr.xxcn_qty_rcv 
             xxtempcn_ch4 = NO. /*�ݹ��ۻ����޼�*/
  END.
      
  ASSIGN xxtempcn_qty3 =  xxcn_mstr.xxcn_dec5   /*�����*/
         xxtempcn_qty2 = xxcn_mstr.xxcn_qty_con /*������*/
         xxtempcn_ch3 = vd_type.
   
/*  IF vd_type = 'U' THEN
  DO:
      ASSIGN xxtempcn_qty3 =  xxcn_mstr.xxcn_dec5  /*�����ù� xxcn_dec5������� xxcn_qty_con������� */
             xxtempcn_qty2 = xxcn_mstr.xxcn_qty_con. 
  END. /*IF vd_type = 'U' THEN ���ù�*/
  
  IF vd_type = 'I' THEN
  DO:
      ASSIGN xxtempcn_qty3 =  xxcn_mstr.xxcn_qty_con  /*������ xxcn_dec5�ź����� xxcn_qty_con�������*/
             xxtempcn_qty2 = xxcn_mstr.xxcn_dec5. 
  END. /*IF vd_type = 'I' THEN ����*/
*/
  
  ASSIGN xxtempcn_qty5 = xxcn_mstr.xxcn_dec3 /*xxtempcn_qty1 + xxtempcn_qty3 - xxtempcn_qty4 - xxtempcn_qty2 /*���=�ڳ�+���-�˻�-����*/*/
         xxtempcn_qty8 = xxtempcn_qty6 * xxtempcn_qty7. /*���= ���� * ������*/
      
  /*Ȼ��Ҫ����֮ǰ�·ݵ�ĩ���ʵ�����*/
  FOR EACH xxcnbuf NO-LOCK WHERE xxcnbuf.xxcn_domain = GLOBAL_domain AND xxcnbuf.xxcn_site = xxcn_mstr.xxcn_site 
                             AND xxcnbuf.xxcn_vend = xxcn_mstr.xxcn_vend AND xxcnbuf.xxcn_part = xxcn_mstr.xxcn_part
                             AND xxcnbuf.xxcn_po_stat = "" 
                             AND (xxcnbuf.xxcn_year < xxcn_mstr.xxcn_year OR ( xxcnbuf.xxcn_year = xxcn_mstr.xxcn_year AND xxcnbuf.xxcn_month < xxcn_mstr.xxcn_month)):
  
      ASSIGN xxd3= hi_date
             xxd4 = hi_date.
      FIND FIRST glc_cal NO-LOCK WHERE glc_year = xxcnbuf.xxcn_year AND glc_per = xxcnbuf.xxcn_month NO-ERROR.
      IF AVAIL glc_cal  THEN
      DO:
          ASSIGN xxd3 = glc_start
                 xxd4 = glc_end.
      END. /*IF AVAIL glc_cal  THEN*/

      find FIRST xxpc_mstr USE-INDEX xxpc_list where xxpc_domain = GLOBAL_domain and trim(xxpc_list) =  trim(xxcnbuf.xxcn_vend) 
                         and  trim(xxpc_prod_line) = "yes" /*ֻ��Э���*/
                         and xxpc_part = xxcnbuf.xxcn_part 
                         and (xxpc_start <= xxd3 or xxpc_start = ? ) 
                         and (xxpc_expire >= xxd4 or xxpc_expire = ?) no-lock no-error .
       
       CREATE xxtempcn_mstr.
       ASSIGN xxtempcn_vend = xxcnbuf.xxcn_vend
              xxtempcn_part = xxcnbuf.xxcn_part
              xxtempcn_perd = string(xxcnbuf.xxcn_year) + STRING(xxcnbuf.xxcn_month) /*��������*/
              xxtempcn_qty6 = xxcnbuf.xxcn_qty_rcv /*������*/
              xxtempcn_ch3 = vd_type. /*���ʷ�ʽ*/
       IF AVAIL xxpc_mstr THEN
       DO:
           ASSIGN xxtempcn_qty7 = xxpc_amt[1]
                  xxtempcn_qty8 = xxtempcn_qty6 * xxtempcn_qty7 /*���= ���� * ������*/
                  xxtempcn_ch4 = YES.                           /*��ʽ��*/
       END.
       ELSE
       DO:
           ASSIGN xxtempcn_qty7 = 0
                  xxtempcn_qty6 = xxcnbuf.xxcn_qty_rcv 
                  xxtempcn_qty8 = xxtempcn_qty6 * xxtempcn_qty7 /*���= ���� * ������*/
                  xxtempcn_ch4 = NO.                            /*�ݹ��ۻ����޼�*/
       END. /*IF AVAIL xxpc_mstr THEN*/

       IF vd_type = 'U' THEN /*���ù�*/
           SET xxtempcn_qty2 = xxcn_qty_con  .
       IF vd_type = 'I' THEN /*����*/
           SET xxtempcn_qty2 = xxcn_dec5 - xxcn_dec6 .



  END. /*FOR EACH xxcnbuf NO-LOCK WHERE */
end.  /*for each xxcn_mstr*/
/*��Ҫ��֮ǰ�·���ĩ�������ݣ������û�ѡ��ĵ�ǰ�����ڼ��޹�������*/

 FOR EACH xxcn_mstr use-index xxcn_vend_part NO-LOCK WHERE xxcn_mstr.xxcn_domain =  global_domain 
                       and   xxcn_mstr.xxcn_vend >= vend AND xxcn_mstr.xxcn_vend <= vend1 
                       AND xxcn_mstr.xxcn_part >= part AND xxcn_mstr.xxcn_part <= part1
                       AND (xxcn_mstr.xxcn_year < xxyy OR ( xxcn_mstr.xxcn_year = xxyy AND xxcn_mstr.xxcn_month < xxmm))
                       AND xxcn_mstr.xxcn_po_stat <> "2"  /*ֻ��ȡĩ���ʲ���*/
                       AND xxcn_mstr.xxcn_qty_rcv <> 0
                       AND xxcn_mstr.xxcn_site >= site AND xxcn_mstr.xxcn_site <= site1 BREAK BY xxcn_mstr.xxcn_vend BY xxcn_mstr.xxcn_part :
     
     FIND FIRST vd_mstr NO-LOCK USE-INDEX vd_addr WHERE vd_addr = xxcn_mstr.xxcn_vend AND vd_domain = GLOBAL_domain AND ( trim(vd_type) = 'U' OR trim(vd_type) = 'I' )  NO-ERROR.  /*ֻ��ȡ�����/���ù��ʵĹ�Ӧ��*/
     IF NOT AVAIL vd_mstr THEN
         NEXT.

     FIND FIRST xxtempcn_mstr NO-LOCK WHERE xxtempcn_vend = xxcn_mstr.xxcn_vend AND xxtempcn_part = xxcn_mstr.xxcn_part AND xxtempcn_perd = STRING(xxyy) + STRING(xxmm) NO-ERROR.
     IF NOT AVAIL xxtempcn_mstr THEN
     DO:
        
         /*���۸������з�����ʽ��*/
         ASSIGN xxd3= hi_date
                xxd4 = hi_date.
         FIND FIRST glc_cal NO-LOCK WHERE glc_year = xxcn_mstr.xxcn_year AND glc_per = xxcn_mstr.xxcn_month NO-ERROR.
         IF AVAIL glc_cal  THEN
         DO:
             ASSIGN xxd3 = glc_start
                    xxd4 = glc_end.
         END. /*IF AVAIL glc_cal  THEN*/
         
         find FIRST xxpc_mstr USE-INDEX xxpc_list where xxpc_domain = GLOBAL_domain and trim(xxpc_list) =  trim(xxcn_mstr.xxcn_vend) 
                            and  trim(xxpc_prod_line) = "yes" /*ֻ��Э���*/
                            and xxpc_part = xxcn_mstr.xxcn_part 
                            and (xxpc_start <= xxd3 or xxpc_start = ? ) 
                            and (xxpc_expire >= xxd4 or xxpc_expire = ?)
                            no-lock no-error .

         IF AVAIL xxpc_mstr THEN
         DO:
             CREATE xxtempcn_mstr.
             ASSIGN xxtempcn_vend = xxcn_mstr.xxcn_vend
                    xxtempcn_part = xxcn_mstr.xxcn_part
                    xxtempcn_perd = string(xxcn_mstr.xxcn_year) + STRING(xxcn_mstr.xxcn_month) /*��������*/
                    xxtempcn_qty6 = xxcn_mstr.xxcn_qty_rcv        /*������*/
                    xxtempcn_qty7 = xxpc_amt[1]
                    xxtempcn_qty8 = xxtempcn_qty6 * xxtempcn_qty7 /*���= ���� * ������*/
                    xxtempcn_ch3 = vd_type                        /*���ʷ�ʽ*/
                    xxtempcn_ch4 = YES.                           /*��ʽ��*/
             IF vd_type = 'U' THEN                                /*���ù�*/
                 SET xxtempcn_qty2 = xxcn_mstr.xxcn_qty_con .
             IF vd_type = 'I' THEN                                /*����*/
                 SET xxtempcn_qty2 = xxcn_mstr.xxcn_dec5 - xxcn_mstr.xxcn_dec6 .

         END. /*IF AVAIL xxpc_mstr THEN*/
         ELSE
         DO: 
             CREATE xxtempcn_mstr.
             ASSIGN xxtempcn_vend = xxcn_mstr.xxcn_vend
                    xxtempcn_part = xxcn_mstr.xxcn_part
                    xxtempcn_perd = string(xxcn_mstr.xxcn_year) + STRING(xxcn_mstr.xxcn_month) /*��������*/
                    xxtempcn_qty6 = xxcn_mstr.xxcn_qty_rcv /*������*/
                    xxtempcn_qty7 = 0
                    xxtempcn_qty8 = xxtempcn_qty6 * xxtempcn_qty7 /*���= ���� * ������*/
                    xxtempcn_ch3 = vd_type /*���ʷ�ʽ*/
                    xxtempcn_ch4 = NO.     /*�ݹ��ۻ��޼�*/
             IF vd_type = 'U' THEN         /*���ù�*/
                 SET xxtempcn_qty2 = xxcn_mstr.xxcn_qty_con .
             IF vd_type = 'I' THEN         /*���ù�*/
                 SET xxtempcn_qty2 = xxcn_mstr.xxcn_dec5 - xxcn_mstr.xxcn_dec6 .

         END. /*else IF AVAIL xxpc_mstr THEN*/
         
         IF  LAST-OF ( xxcn_mstr.xxcn_part )  THEN
         DO:
             CREATE xxtempcn_mstr.
             ASSIGN xxtempcn_vend = xxcn_mstr.xxcn_vend
                    xxtempcn_part = xxcn_mstr.xxcn_part
                    xxtempcn_perd = string(xxyy) + STRING(xxmm) /*��������*/
                    xxtempcn_qty1 = 0
                    xxtempcn_qty4 = 0
                    xxtempcn_qty6 = 0
                    xxtempcn_ch3 = vd_type /*���ʷ�ʽ*/
                    xxtempcn_ch4 = NO.
             /*���۸������з�����ʽ��*/
             ASSIGN xxd3= hi_date
                    xxd4 = hi_date.
             FIND FIRST glc_cal NO-LOCK WHERE glc_year = xxcn_mstr.xxcn_year AND glc_per = xxcn_mstr.xxcn_month NO-ERROR.
             IF AVAIL glc_cal  THEN
             DO:
                  ASSIGN xxd3 = glc_start
                         xxd4 = glc_end.
             END. /*IF AVAIL glc_cal  THEN*/
             find FIRST xxpc_mstr USE-INDEX xxpc_list where xxpc_domain = GLOBAL_domain and trim(xxpc_list) =  trim(xxcn_mstr.xxcn_vend) 
                                       and  trim(xxpc_prod_line) = "yes" /*ֻ��Э���*/
                                       and xxpc_part = xxcn_mstr.xxcn_part 
                                       and (xxpc_start <= xxd3 or xxpc_start = ? ) 
                                       and (xxpc_expire >= xxd4 or xxpc_expire = ?)
                                       no-lock no-error .
             IF AVAIL xxpc_mstr THEN
                 ASSIGN xxtempcn_qty7 = xxpc_amt[1].
             ELSE
             DO:
                 ASSIGN xxtempcn_qty7 = 0
                        xxtempcn_qty6 = 0. /*������۲�Ϊ��ʽ����ô������ҲΪ0*/
             END.

             ASSIGN xxtempcn_qty3 =  0 
                    xxtempcn_qty2 = 0 /*������*/
                    xxtempcn_qty5 = 0 /*���=�ڳ�+���-�˻�-����*/
                    xxtempcn_qty8 = 0. /*���= ���� * ������*/       /*  IF vd_type = 'U' THEN
             DO:
                 ASSIGN xxtempcn_qty3 =  xxcn_mstr.xxcn_dec5 /*�����ù� xxcn_dec5������� xxcn_qty_con�������*/
                        xxtempcn_qty2 = xxcn_mstr.xxcn_qty_con. 
             END. /*IF vd_type = 'U' THEN ���ù�*/

             IF vd_type = 'I' THEN
             DO:
                 ASSIGN xxtempcn_qty3 =  xxcn_mstr.xxcn_qty_con /*������ xxcn_dec5�ź����� xxcn_qty_con�������*/
                        xxtempcn_qty2 = xxcn_mstr.xxcn_dec5. 
             END. /*IF vd_type = 'I' THEN ����*/*/



         END. /*IF NOT AVAIL xxtempcn_mstr   THEN*/
     END. /*IF NOT AVAIL xxtempcn_mstr THEN*/
 END. /*FOR EACH xxcn_mstr NO-LOCK WHERE xxcn_domain =  global_domain */


/*
FORM 
 xxcn_vend  column-label "��Ӧ�̴���" 
 ad_name  column-label "��Ӧ������"  
 vd_type  column-label '���ʷ�ʽ' FORMAT 'x(10)' 
 xxcn_part column-label "���ϱ���" 
 pt_desc1 column-label "��������" 
 pt_um column-label "��λ"  
 xxcn_qty_fir_oh column-label  "�ڳ���"  
 xxcn_qty_inv_fir column-label "ǰ��ĩ������"
 xxs2 COLUMN-LABEL '��������'
 xxcn_dec5 COLUMN-LABEL '�����'
 xxcn_dec6 COLUMN-LABEL '�˻���'
 xxcn_qty_inv COLUMN-LABEL '��ĩ��'
 xxcn_qty_rcv COLUMN-LABEL '������'
 xxcn_cost COLUMN-LABEL '����'
 xxcn_dec3 COLUMN-LABEL '���'
 with frame C width 220 no-box down .  
*/

/*
FORM  header 
SKIP
"������ͨ�������޹�˾--��ͨ�������ʱ�" at 50 skip
'�����ʱ�������:��������;������Ӧ�̽�Ʊʱ���ز���;������Ӧ�̴��¹��˽��ز���' at 2  
'��������:' AT 90 xxs1 AT 110
SKIP 
with PAGE-TOP  no-box width 180 frame t NO-ATTR-SPACE .
*/
  /*
 define temp-table xxtempcn_mstr NO-UNDO  /*�ź�� ����ʱ�����ڼ�¼����ʾ������ 2011-04-13*/
 FIELD xxtempcn_vend   LIKE xxcn_vend
 FIELD xxtempcn_part   LIKE pt_part
 FIELD xxtempcn_qty1   LIKE tr_qty_chg /*�ڳ�*/
 FIELD xxtempcn_qty2   LIKE tr_qty_chg /*������*/
 FIELD xxtempcn_perd   AS CHAR  /*��������*/
 FIELD xxtempcn_qty3   LIKE tr_qty_chg  /*�����*/
 FIELD xxtempcn_qty4   LIKE tr_qty_chg  /*�˻���*/
 FIELD xxtempcn_qty5   LIKE tr_qty_chg  /*��ĩ��*/
 FIELD xxtempcn_qty6   LIKE tr_qty_chg  /*������*/
 FIELD xxtempcn_qty7   LIKE tr_qty_chg  /*����*/
 FIELD xxtempcn_qty8   LIKE tr_qty_chg.  /*���*/  
  */


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
                  

          
           FIND FIRST vd_mstr NO-LOCK USE-INDEX vd_addr WHERE vd_addr = xxtempcn_vend AND vd_domain = GLOBAL_domain NO-ERROR.
           IF vd_type = 'U' THEN
               SET xxs3 = '���ù�'.
           ELSE
               SET xxs3 = '����'.
           SET xxs4 = vd_sort.
           VIEW FRAME t.
      END. /* IF FIRST-OF (xxtempcn_vend) THEN*/
/*
FORM 
 xxcn_vend  label "��Ӧ�̴���" 
 ad_name  LABEL "��Ӧ������"  
 vd_type  label '���ʷ�ʽ'  
 xxcn_part label "���ϱ���" 
 pt_desc1 label "��������" 
 pt_um label "��λ"  
 xxcn_qty_fir_oh label  "�ڳ���"
 xxcn_qty_con LABEL '������'
 xxcn_qty_inv_fir COLUMN-LABEL "ǰ��    !ĩ������"
 xxs2 LABEL '��������'
 xxcn_dec5 LABEL '�����'
 xxcn_dec6 LABEL '�˻���'
 xxcn_qty_inv LABEL '��ĩ��'
 xxcn_qty_rcv LABEL '������'
 xxcn_cost LABEL '����'
 xxcn_dec3 LABEL '���'
 with frame C width 260 NO-BOX STREAM-IO down .  


*/
       if first-of(xxtempcn_part) THEN
       DO:
            FIND FIRST pt_mstr NO-LOCK USE-INDEX pt_part WHERE pt_part = xxtempcn_part AND pt_domain = GLOBAL_domain NO-ERROR.
            SET xxs5 = pt_desc1.
       END.
          

      
       if first-of ( xxtempcn_part  ) then
       do:
         if xxtempcn_qty2 <> 0 or xxtempcn_qty3 <> 0 or xxtempcn_qty4 <> 0 or xxtempcn_qty5 <> 0 or xxtempcn_qty6 <> 0 then do:
             DISP /*xxtempcn_vend @ xxcn_mstr.xxcn_vend*/
                 /*xxs4 FORMAT 'x(12)' @ ad_name*/ 
                 /*xxs3 @ vd_type*/ 
                 xxs5 @ pt_desc1 
                 xxtempcn_part @ xxcn_mstr.xxcn_part
                /*pt_um @ pt_um*/ 
                xxtempcn_qty1 @ xxcn_mstr.xxcn_qty_fir_oh  
                xxtempcn_qty3 @ xxcn_mstr.xxcn_dec5  
                xxtempcn_qty4 @ xxcn_mstr.xxcn_dec6
                xxtempcn_qty5 @ xxcn_mstr.xxcn_qty_inv 
                /* xxtempcn_qty2 @ xxcn_mstr.xxcn_qty_con */ 
                xxtempcn_qty6 @ xxcn_mstr.xxcn_qty_rcv
                xxtempcn_qty7 @ xxcn_mstr.xxcn_cost 
                xxtempcn_qty8 @ xxcn_mstr.xxcn_dec3
                WITH FRAME C .
                DOWN WITH FRAME C. 
          end.           	
       end. /*if first-of ( xxtempcn_perd  )then*/
       ELSE
       DO: 
       	    /*modify by billy 2011-05-23 ȥ��������Ϊ0�ģ�Ҳ����ǰ���޺��õĲ���*/
       	    if xxtempcn_qty6 <> 0 then do:      /*wyane  close������Ϊ0��*/	  
       	      if xxtempcn_perd <> string(xxyy) + string(xxmm) then do:  	
		            DISP 
		                 xxs5 @ pt_desc1 
                     xxtempcn_part @ xxcn_mstr.xxcn_part
		                 xxtempcn_qty1 @ xxcn_mstr.xxcn_qty_fir_oh
		                 /*xxtempcn_qty2 @ xxcn_mstr.xxcn_qty_inv_fir */
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
		                 /*xxtempcn_qty2 @ xxcn_mstr.xxcn_qty_inv_fir */
		                  
		                 xxtempcn_qty6 @ xxcn_mstr.xxcn_qty_rcv 
		                 xxtempcn_qty7 @ xxcn_mstr.xxcn_cost 
		                 xxtempcn_qty8 @ xxcn_mstr.xxcn_dec3 
		                 WITH FRAME C.
		            DOWN WITH FRAME C.
		          end.  
		        end. 
       END. /*else IF FIRST-OF (xxtempcn_vend) THEN*/   
           
       IF LAST-OF( xxtempcn_vend ) THEN
       DO:
          DISP '   �ϼƣ�' @ xxcn_mstr.xxcn_part 
              (ACCUM SUB-TOTAL BY xxtempcn_vend xxtempcn_qty1) @ xxcn_mstr.xxcn_qty_fir_oh
              (ACCUM SUB-TOTAL BY xxtempcn_vend xxtempcn_qty3) @ xxcn_mstr.xxcn_dec5
              (ACCUM SUB-TOTAL BY xxtempcn_vend xxtempcn_qty4) @ xxcn_mstr.xxcn_dec6
              (ACCUM SUB-TOTAL BY xxtempcn_vend xxtempcn_qty5) @ xxcn_mstr.xxcn_qty_inv
              (ACCUM SUB-TOTAL BY xxtempcn_vend xxtempcn_qty6) @ xxcn_mstr.xxcn_qty_rcv
              (ACCUM SUB-TOTAL BY xxtempcn_vend xxtempcn_qty8) @ xxcn_mstr.xxcn_dec3 WITH FRAME C.
          DOWN WITH FRAME C.
          put skip.
          put "��Ӧ��ǩ��:".
          IF NOT LAST( xxtempcn_vend ) THEN
              PAGE.
       END. /*IF LAST-OF( xxtempcn_vend ) THEN*/

       IF   page-size - LINE-COUNTER < 5 THEN 
          PAGE.

   END. /*FOR EACH xxtempcn_mstr NO-LOCK:*/

  /*
 define temp-table xxtempcn_mstr NO-UNDO  /*�ź�� ����ʱ�����ڼ�¼����ʾ������ 2011-04-13*/
 FIELD xxtempcn_vend   LIKE xxcn_vend
 FIELD xxtempcn_part   LIKE pt_part
 FIELD xxtempcn_qty1   LIKE tr_qty_chg /*�ڳ�*/
 FIELD xxtempcn_qty2   LIKE tr_qty_chg /*������*/
 FIELD xxtempcn_perd   AS CHAR  /*��������*/
 FIELD xxtempcn_qty3   LIKE tr_qty_chg  /*�����*/
 FIELD xxtempcn_qty4   LIKE tr_qty_chg  /*�˻���*/
 FIELD xxtempcn_qty5   LIKE tr_qty_chg  /*��ĩ��*/
 FIELD xxtempcn_qty6   LIKE tr_qty_chg  /*������*/
 FIELD xxtempcn_qty7   LIKE tr_qty_chg  /*����*/
 FIELD xxtempcn_qty8   LIKE tr_qty_chg.  /*���*/  
  */
  {mfreset.i}
  {mfgrptrm.i}

   SET xxyn = NO.
   MESSAGE '�Ƿ�ȷ���´�ù��ʵ�?' UPDATE xxyn.
   DO TRANS ON ERROR UNDO,RETRY:
   IF xxyn = YES THEN
   DO:
        FOR EACH xxtempcn_mstr NO-LOCK WHERE xxtempcn_qty6 <> 0 AND xxtempcn_ch4 = YES: /*ֻ��д�ù���������Ϊ0,���м۸������*/
            FIND FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain AND xxcn_vend = xxtempcn_vend AND xxcn_part = xxtempcn_part 
                                   AND xxcn_year = int(SUBSTRING(xxtempcn_perd , 1 , 4)) AND xxcn_month = int(SUBSTRING(xxtempcn_perd , 5 , LENGTH(trim(STRING(xxtempcn_perd))) - 4 ))
                                   AND xxcn_po_stat = "" NO-ERROR.
            IF AVAIL xxcn_mstr THEN
            DO:
          	
                ASSIGN xxcn_po_stat = '2'
                       xxcn_ch1 = trim(string(xxyy)) +  trim(STRING(xxmm))
                       xxcn_cost = xxtempcn_qty7
                       xxcn_ch3 = xxtempcn_ch3.  /*���ʷ�ʽ*/
            END. /*IF AVAIL xxcn_mstr THEN*/
        END. /*FOR EACH xxtempcn_mstr NO-LOCK WHERE xxtempcn_qty6 <> 0:*/
   END. /*IF xxyn = YES THEN*/
   END. /*DO TRANS ON ERROR UNDO,RETRY:*/


END.


