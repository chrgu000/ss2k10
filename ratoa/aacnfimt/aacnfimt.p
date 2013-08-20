/* GUI CONVERTED from xxcnfimt.p (converter v1.75) Thu Aug 31 03:46:21 2000 */
/* pppimt.p - PRICE LIST MAINTENCANCE                                       */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=Maintenance                                                */
/*N014*/ /*V8:RunMode=Character,Windows                                     */
/* REVISION: 8.5      LAST MODIFIED: 01/13/94   BY: afs *J042*              */
/* REVISION: 8.5      LAST MODIFIED: 02/10/96   BY: DAH *J0D4*              */
/* REVISION: 8.5      LAST MODIFIED: 03/04/96   BY: rxm *G1MD*              */
/* REVISION: 8.5      LAST MODIFIED: 05/03/96   BY: kxn *J0L7*              */
/* REVISION: 8.5      LAST MODIFIED: 05/28/96   BY: ruw *J0P1*              */
/* REVISION: 8.5      LAST MODIFIED: 06/20/96   BY: jpm *J0VJ*              */
/* REVISION: 8.5      LAST MODIFIED: 07/02/96   BY: *J0X8* Robert Wachowicz */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*              */
/* REVISION: 8.6      LAST MODIFIED: 08/27/97   BY: *J1ZT* Aruna Patil      */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0N1* Jean Miller      */
/* REVISION: 8.6      LAST MODIFIED: 12/11/97   BY: *J27Z* Aruna Patil      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *L020* Charles Yen      */
/* REVISION: 8.6E     LAST MODIFIED: 08/12/98   BY: *L05P* Brenda Milton    */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/98   BY: *J2X2* Ajit Deodhar     */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *J34F* Vijaya Pakala    */
/* REVISION: 9.0      LAST MODIFIED: 12/21/98   BY: *M03Z* Luke Pokic       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *L13D* Ashwini G.       */

         /* DISPLAY TITLE */
        
/* ********** Begin Translatable Strings Definitions ********* */


/* ********** End Translatable Strings Definitions ********* */

      
{mfdtitle.i "20120523 "}          

        
define            variable del-yn         like mfc_logical.
DEFINE VAR yn AS logi .
DEFINE VAR yn1 AS logi.
DEFINE BUFFER xxcnbuf FOR xxcn_mstr.              
DEFINE VAR xxd1 AS DATE no-undo.
DEFINE VAR xxd2 AS DATE no-undo.
DEFINE VAR xxs1 AS CHAR.
DEFINE VAR xxs2 LIKE pt_desc1.
DEFINE VAR xxs3 AS CHAR.
&SCOPED-DEFINE PP_FRAME_NAME A
define var site like ld_site.

FORM /*GUI*/ 
           
            xxcn_vend  LABEL "��Ӧ��" colon 20 
            xxs1 LABEL '���ʷ�ʽ' COLON 50
            xxcn_part  LABEL "�Ϻ�" colon 20
            xxs2 LABEL '���ϴ���' COLON 50
            xxcn_year  LABEL "��"  colon 20
            xxcn_month LABEL "��" colon  20
            xxcn_qty_fir_oh LABEL  "���³�ʼ�������" colon 20
           /* xxcn_qty_con_fir LABEL  "���³�ʼ����δ��������" colon 27
            xxcn_qty_rcv_fir LABEL  "���³�ʼ��������" colon 27*/
           /* xxcn_qty_inv_fir LABEL  "���³�ʼӦ����Ʊ����" colon 27*/
            xxcn_qty_con   LABEL "����Ӧ����" colon 20
            xxcn_dec5 LABEL '���������' COLON 20
            xxcn_dec6 LABEL '�����˻���' COLON 20
            xxcn_qty_rcv LABEL "����ʵ����"   colon 20
            xxcn_ch1 LABEL '�����ڼ�' COLON 50
          
        /*  xxcn_qty_inv   LABEL "����Ӧ����Ʊ��" colon 27*/
            xxcn_po_stat LABEL "���ʱ��"   COLON 20
          /*  XXCN_DEC3     LABEL " �ֹ����" colon 27 */
            xxcn_cost     LABEL "���µ���" COLON 20  
            xxcn_dec2      label "���½��" colon 20 
        /*    xxcn_amt_oh_fir LABEL "�ڳ������" COLON 27            */
       /*     xxcn_site   LABEL "�ص�" colon 27*/
            xxcn_ch2 LABEL '�۸�����' COLON 20
          SKIP(.4)  /*GUI*/
with frame a width 80 side-labels no-attr-space .

          CLEAR FRAME a .

{gprunp.i "aaproced" "p" "getglsite" "(output site)"}          

         mainloop:
         REPEAT  WITH FRAME a  :
              /*  FIND FIRST xxcn_mstr WHERE xxcn_vend = INPUT xxcn_vend AND xxcn_part = INPUT xxcn_part AND xxcn_year = INPUT xxcn_year AND xxcn_month = INPUT xxcn_month NO-LOCK NO-ERROR.
                IF AVAIL xxcn_mstr THEN
                    MESSAGE 'find' VIEW-AS ALERT-BOX.*/
                PROMPT-FOR
                  xxcn_vend
                  xxcn_part
                  xxcn_year
                  xxcn_month 
                
             WITH FRAME a      editing:
                
                /* IF AVAIL xxcn_mstr THEN
                    MESSAGE '1' VIEW-AS ALERT-BOX.*/
                /* 
                IF AVAIL xxcn_mstr THEN
                    MESSAGE xxcn_vend VIEW-AS ALERT-BOX.
                 */
                if frame-field = "xxcn_vend" then do:  /* scroll full list */
                    
                    if keylabel(lastkey) = 'return' or keylabel(lastkey) = 'pf1' then do:
                        FIND FIRST vd_mstr USE-INDEX vd_addr WHERE vd_addr = INPUT xxcn_vend AND vd_domain = GLOBAL_domain NO-LOCK NO-ERROR .
                         IF NOT AVAIL vd_mstr THEN 
                         DO:
                              MESSAGE "��Ӧ�̲�����!" .
                              NEXT-PROMPT xxcn_vend .
                         END.
                     END.



                /*   {mfnp.i xxcn_mstr xxcn_site xxcn_site xxcn_site xxcn_site xxcn_vend_part} */
                     
                    /* {mfnp01.i xxcn_mstr xxcn_vend xxcn_vend
                               xxcn_part xxcn_part xxcn_vend_part }*/
                     
                         {mfnp.i xxcn_mstr xxcn_mstr.xxcn_vend  " xxcn_mstr.xxcn_domain = global_domain and xxcn_mstr.xxcn_vend
                         "  xxcn_mstr.xxcn_part xxcn_mstr.xxcn_part  xxcn_vend_part}


                           /*{mfnp.i pc_mstr pc_list  " pc_domain = global_domain and pc_list
                             "  pc_prod pc_prod pc_list}*/

                     /*  {mfnp.i xxcn_mstr INPUT xxcn_vend xxcn_vend xxcn_part xxcn_part xxcn_vend_part}  /*����1:���� ����3,2������{3}>input{2}��{3}<{2}  ����4,5������{5} >= input {4}��{5} <=input {4}  ����6:����*/*/
                       
                   if recno <> ?  then 
               /*�ź��,�߼�:���xxcn_po_stat = �գ���ô�۸�ȡ�۸�����ݣ���ֱ֮��ȡ�ñʼ�¼�еļ۸� 2011-04-12*/
                   DO:
                       
                       FIND FIRST vd_mstr NO-LOCK USE-INDEX vd_addr WHERE vd_addr = INPUT xxcn_vend AND vd_domain = GLOBAL_domain NO-ERROR.
                       IF AVAIL vd_mstr AND xxcn_po_stat = "" THEN
                       DO:
                           IF vd_type  = 'U' THEN
                               ASSIGN xxs1 = '���ù�'.
                           IF vd_type = 'I' THEN
                               ASSIGN xxs1 = '����'.
                           IF vd_type = 'C' THEN
                               ASSIGN xxs1 = '�ֽ��'.
                           IF vd_type = 'X' OR vd_type = '' THEN
                               ASSIGN xxs1 = 'ĩ��'.
                       END. /*IF AVAIL vd_mstr THEN*/

                       IF xxcn_po_stat = "2" THEN
                       DO:
                           ASSIGN xxs1 = "".
                           IF xxcn_ch3 = 'U' THEN
                               ASSIGN xxs1 = '���ù�'.
                           IF xxcn_ch3 = 'I' THEN
                               ASSIGN xxs1 = '����'.
                           IF xxcn_ch3 = 'C' THEN
                               ASSIGN xxs1 = '�ֽ��'.
                       END.

                       FIND FIRST pt_mstr NO-LOCK USE-INDEX pt_part WHERE pt_part = INPUT xxcn_part AND pt_domain = GLOBAL_domain NO-ERROR.
                       IF AVAIL pt_mstr THEN
                           ASSIGN xxs2 = pt_desc1.
                       IF xxcn_po_stat <> "" THEN
                               DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                              /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                               xxcn_po_stat  xxcn_cost * xxcn_qty_rcv @ xxcn_dec2 '��ʽ��' @ xxcn_ch2 xxcn_ch1  WITH FRAME a .
                          ELSE
                          DO:
                              ASSIGN xxd1 = hi_date
                                     xxd2 = hi_date.
                              FIND FIRST glc_cal NO-LOCK WHERE glc_year = xxcn_year AND glc_per = xxcn_month AND glc_domain = GLOBAL_domain NO-ERROR.
                              IF AVAIL glc_cal  THEN
                              DO:
                                  ASSIGN xxd1 = glc_start
                                         xxd2 = glc_end.
                              END. /*IF AVAIL glc_cal  THEN*/  
                                
                               FIND FIRST xxpc_mstr USE-INDEX xxpc_list NO-LOCK WHERE xxpc_domain = GLOBAL_domain AND xxpc_list = xxcn_vend AND xxpc_part = xxcn_part 
                                                     AND ( xxpc_start <= xxd1 OR xxpc_start = ? ) AND ( xxpc_expire >= xxd2 OR xxpc_expire = ?) NO-ERROR.
                               IF AVAIL xxpc_mstr THEN
                               DO:
                                       IF xxpc_prod_line = 'YES' THEN  /*��ʽ��*/
                                             DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh xxpc_amt[1] @ xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                                             xxcn_po_stat  xxpc_amt[1] * xxcn_qty_rcv @ xxcn_dec2  '��ʽ��' @ xxcn_ch2 xxcn_ch1 WITH FRAME a .
                                       IF xxpc_prod_line = 'NO' THEN  /*�ݹ���*/
                                             DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh xxpc_amt[1] @ xxcn_cost  xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                                     /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                                      xxcn_po_stat  xxpc_amt[1] * xxcn_qty_rcv @ xxcn_dec2  '�ݹ���' @ xxcn_ch2 xxcn_ch1 WITH FRAME a .
                               END. /*IF AVAIL xxpc_mstr THEN*/
                               ELSE
                               DO:
                                   DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh 0 @ xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                                    /*  xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                                      xxcn_po_stat  0 @ xxcn_dec2  '�޼�' @ xxcn_ch2 xxcn_ch1 WITH FRAME a .
                               END. /*IF AVAIL xxpc_mstr THEN*/
                        END. /*IF xxcn_po_stat <> "" THEN*/
                   END.  /*if recno <> ? then*/
                   /*�ź��,�߼�:���xxcn_po_stat = �գ���ô�۸�ȡ�۸�����ݣ���ֱ֮��ȡ�ñʼ�¼�еļ۸� 2011-04-12*/



                  
                 END.
                  else if frame-field = "xxcn_part" then do:
                     /* Item ACs */
                               {mfnp05.i xxcn_mstr xxcn_vend_part "xxcn_vend = input xxcn_vend"
                                xxcn_part "input xxcn_part"}  /*����1:���� ����2:���� ����3 :����1 ����4 �Ͳ���5:��������,������4>����5�����ǲ���4<����5*/
                     if recno <> ? then /*display 
                            xxcn_vend xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh xxcn_cost xxcn_qty_con xxcn_qty_rcv xxcn_qty_inv 
                             xxcn_qty_con_fir  xxcn_qty_rcv_fir
                              xxcn_qty_inv_fir xxcn_site xxcn_dec2 xxcn_dec3 xxcn_po_stat WITH FRAME a .*/
               /*�ź��,�߼�:���xxcn_po_stat = �գ���ô�۸�ȡ�۸�����ݣ���ֱ֮��ȡ�ñʼ�¼�еļ۸� 2011-04-12*/
                   DO:
                         FIND FIRST vd_mstr NO-LOCK USE-INDEX vd_addr WHERE vd_addr = xxcn_vend AND vd_domain = GLOBAL_domain NO-ERROR.
                         IF AVAIL vd_mstr AND xxcn_po_stat = "" THEN
                         DO:
                             IF vd_type  = 'U' THEN
                                 ASSIGN xxs1 = '���ù�'.
                             IF vd_type = 'I' THEN
                                 ASSIGN xxs1 = '����'.
                             IF vd_type = 'C' THEN
                                 ASSIGN xxs1 = '�ֽ��'.
                             IF vd_type = 'X' OR vd_type = '' THEN
                                 ASSIGN xxs1 = 'ĩ��'.
                         END. /*IF AVAIL vd_mstr THEN*/

                         IF xxcn_po_stat = "2" THEN
                         DO:
                             ASSIGN xxs1 = "".
                             IF xxcn_ch3 = 'U' THEN
                                 ASSIGN xxs1 = '���ù�'.
                             IF xxcn_ch3 = 'I' THEN
                                 ASSIGN xxs1 = '����'.
                             IF xxcn_ch3 = 'C' THEN
                                 ASSIGN xxs1 = '�ֽ��'.
                         END.

                         FIND FIRST pt_mstr NO-LOCK USE-INDEX pt_part WHERE pt_part = xxcn_part AND pt_domain = GLOBAL_domain NO-ERROR.
                         IF AVAIL pt_mstr THEN
                             ASSIGN xxs2 = pt_desc1.


                       IF xxcn_po_stat <> "" THEN
                               DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                              /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                               xxcn_po_stat  xxcn_cost * xxcn_qty_rcv @ xxcn_dec2 '��ʽ��' @ xxcn_ch2 xxcn_ch1  WITH FRAME a .
                          ELSE
                          DO:
                               FIND FIRST xxpc_mstr USE-INDEX xxpc_list NO-LOCK WHERE xxpc_domain = GLOBAL_domain AND xxpc_list = xxcn_vend AND xxpc_part = xxcn_part 
                                                     AND ( xxpc_start <= xxd1 OR xxpc_start = ? ) AND ( xxpc_expire >= xxd2 OR xxpc_expire = ?) NO-ERROR.
                               IF AVAIL xxpc_mstr THEN
                               DO:
                                       IF xxpc_prod_line = 'YES' THEN  /*��ʽ��*/
                                             DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh xxpc_amt[1] @ xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                                             xxcn_po_stat  xxpc_amt[1] * xxcn_qty_rcv @ xxcn_dec2  '��ʽ��' @ xxcn_ch2 xxcn_ch1 WITH FRAME a .
                               IF xxpc_prod_line = 'NO' THEN  /*�ݹ���*/
                                      DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh xxpc_amt[1] @ xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                                     /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                                      xxcn_po_stat  xxpc_amt[1] * xxcn_qty_rcv @ xxcn_dec2  '�ݹ���' @ xxcn_ch2 xxcn_ch1 WITH FRAME a .
                               END. /*IF AVAIL xxpc_mstr THEN*/
                               ELSE
                               DO:
                                      DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh 0 @ xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                                     /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                                      xxcn_po_stat 0 @ xxcn_dec2  '�޼�' @ xxcn_ch2 xxcn_ch1 WITH FRAME a .
                               END. /*IF AVAIL xxpc_mstr THEN*/
                        END. /*IF xxcn_po_stat <> "" THEN*/
                   END.  /*if recno <> ? then*/
                   /*�ź��,�߼�:���xxcn_po_stat = �գ���ô�۸�ȡ�۸�����ݣ���ֱ֮��ȡ�ñʼ�¼�еļ۸� 2011-04-12*/

                  end.
                  else do:
                     status input.
                     readkey.
                     apply lastkey.
                 
                  end.   
               end.  /* prompt-for pi_list... */
                 


               
               recno = recid(xxcn_mstr).

               
               FIND FIRST vd_mstr WHERE vd_addr = INPUT xxcn_vend AND vd_domain = GLOBAL_domain NO-LOCK NO-ERROR.
               IF NOT AVAIL vd_mstr THEN 
               DO:
                   MESSAGE "��Ӧ�̲�����!" .
                    UNDO,RETRY mainloop .
               END.

               FIND FIRST pt_mstr NO-LOCK USE-INDEX pt_part WHERE pt_part = INPUT xxcn_part AND pt_domain = GLOBAL_domain NO-ERROR.
               IF AVAIL pt_mstr THEN
                   ASSIGN xxs2 = pt_desc1.
               
               

               FIND FIRST pt_mstr WHERE pt_part = INPUT xxcn_part AND pt_domain = GLOBAL_domain NO-LOCK NO-ERROR .
               IF NOT AVAIL pt_mstr THEN 
               DO:
                   MESSAGE "����Ų�����!" .
                   UNDO,RETRY mainloop .
               END.
               /*
               IF INPUT xxcn_year < 2011 OR INPUT xxcn_month > 12 OR INPUT xxcn_month < 1 THEN
               DO:
                   MESSAGE "��,�·� ��Ч !" .
                     UNDO,RETRY mainloop .
               END.
               */
               
               FIND FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain
                              AND   xxcn_site      = site  /*��ʱ��ĳ���ͨʵ�ʵĵص�*/
                              and xxcn_vend   = INPUT xxcn_vend
                              and xxcn_part   = INPUT xxcn_part 
                              and xxcn_year =  INPUT xxcn_year
                              and xxcn_month      = input xxcn_month
                               no-error.

               IF AVAIL xxcn_mstr THEN
               DO:
                     IF AVAIL vd_mstr AND INPUT xxcn_po_stat = "" THEN
                       DO:
                           IF vd_type  = 'U' THEN
                               ASSIGN xxs1 = '���ù�'.
                           IF vd_type = 'I' THEN
                               ASSIGN xxs1 = '����'.
                           IF vd_type = 'C' THEN
                               ASSIGN xxs1 = '�ֽ��'.
                           IF vd_type = 'X' OR vd_type = '' THEN
                               ASSIGN xxs1 = 'ĩ��'.
                       END. /*IF AVAIL vd_mstr THEN*/

                       IF xxcn_po_stat = "2" THEN
                       DO:
                           ASSIGN xxs1 = "".
                           IF xxcn_ch3 = 'U' THEN
                               ASSIGN xxs1 = '���ù�'.
                           IF xxcn_ch3 = 'I' THEN
                               ASSIGN xxs1 = '����'.
                           IF xxcn_ch3 = 'I' THEN
                               ASSIGN xxs1 = '�ֽ��'.
                       END.   
               END.  /*IF AVAIL xxcn_mstr THEN*/
               
               ASSIGN yn = NO. 
                      
               if not available xxcn_mstr then do:
               DO:
                   MESSAGE "��������ȷ��(y/n) " UPDATE yn .
               END.
               
            
               IF yn THEN DO:
                  
                  create xxcn_mstr.
                  ASSIGN xxcn_domain = GLOBAL_domain
                         xxcn_site = site  /*��ʱ��ĳ���ͨʵ�ʵĵص�*/ 
                         xxcn_vend   = INPUT xxcn_vend
                         xxcn_part   = INPUT xxcn_part
                         xxcn_year  =  INPUT xxcn_year 
                         xxcn_month = INPUT xxcn_month 
                         xxcn_po_stat = "" .
                      
                  END .      
                  ELSE
                   UNDO ,RETRY mainloop .
               end.  /* if not avail pi_mstr */
               /*�ź��,�߼�:���xxcn_po_stat = �գ���ô�۸�ȡ�۸�����ݣ���ֱ֮��ȡ�ñʼ�¼�еļ۸� 2011-04-12*/

               IF xxcn_po_stat <> "" THEN
                  DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                          xxcn_po_stat  xxcn_cost * xxcn_qty_rcv @ xxcn_dec2 '��ʽ��' @ xxcn_ch2 xxcn_ch1  WITH FRAME a .
               ELSE
               DO:

 
                  FIND FIRST xxpc_mstr USE-INDEX xxpc_list NO-LOCK WHERE xxpc_domain = GLOBAL_domain AND xxpc_list =  xxcn_vend AND xxpc_part =  xxcn_part 
                                                 AND ( xxpc_start <= xxd1 OR xxpc_start = ? ) AND ( xxpc_expire >= xxd2 OR xxpc_expire = ?) NO-ERROR.
                               
                  IF AVAIL xxpc_mstr THEN
                  DO:
             	
                      IF xxpc_prod_line = 'YES' THEN  /*��ʽ��*/
                          DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh xxpc_amt[1] @ xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                                  xxcn_po_stat  xxpc_amt[1] * xxcn_qty_rcv @ xxcn_dec2  '��ʽ��' @ xxcn_ch2 xxcn_ch1 WITH FRAME a .
                      IF xxpc_prod_line = 'NO' THEN  /*�ݹ���*/


                          DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh xxpc_amt[1] @ xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                                  xxcn_po_stat  xxpc_amt[1] * xxcn_qty_rcv @ xxcn_dec2  '�ݹ���' @ xxcn_ch2 xxcn_ch1 WITH FRAME a .

                           
   
                  END. /*IF AVAIL xxpc_mstr THEN*/
                  ELSE
                  DO:
                          DISPLAY xxcn_vend xxs1 xxs2 xxcn_part xxcn_year xxcn_month xxcn_qty_fir_oh 0 @ xxcn_cost xxcn_qty_con xxcn_dec5 xxcn_dec6 xxcn_qty_rcv 
                                  xxcn_po_stat  0 @ xxcn_dec2  '�޼�' @ xxcn_ch2 xxcn_ch1 WITH FRAME a .
                  END. /*IF AVAIL xxpc_mstr THEN*/
               END. /*IF xxcn_po_stat <> "" THEN*/
                   /*�ź��,�߼�:���xxcn_po_stat = �գ���ô�۸�ȡ�۸�����ݣ���ֱ֮��ȡ�ñʼ�¼�еļ۸� 2011-04-12*/
              /*�ź��,������޸�ֻ�����û�ά�����¹�������,����������޸ı��¹��������ڳ����,���º����� 2011-4-12*/

              m1:
              DO ON ERROR UNDO m1 ,RETRY m1 :
              SET yn1 = NO.
              IF xxcn_po_stat = '' AND yn = NO THEN /*�޸�����*/
               UPDATE
                  /* xxcn_qty_fir_oh   /*�ڳ����*/*/
                  /* xxcn_qty_con_fir  /*���³�ʼ����δ������*/*/
                  /*   xxcn_qty_rcv_fir  /*���³�ʼ������*/*/
                 /*    xxcn_qty_inv_fir  /*���³�ʼӦ��Ʊ��*/*/
                 /*     xxcn_qty_con  /*���º�����*/*/
                     xxcn_qty_rcv  go-on(F5 CTRL-D)  /*���¹�����*/
                /*     xxcn_qty_inv   /*����Ӧ����Ʊ��*/*/
                /*     xxcn_po_stat   /*״̬*/*/
                /*     xxcn_dec3      /*�ֹ����*/*/
               /*     xxcn_cost  go-on(F5 CTRL-D)*/
                   WITH FRAME a .
              IF xxcn_po_stat = '' AND yn = YES THEN /*��������*/
               UPDATE
                   xxcn_qty_fir_oh   /*�ڳ����*/
                  /* xxcn_qty_con_fir  /*���³�ʼ����δ������*/*/
                  /*   xxcn_qty_rcv_fir  /*���³�ʼ������*/*/
                 /*    xxcn_qty_inv_fir  /*���³�ʼӦ��Ʊ��*/*/
                      xxcn_qty_con  /*���º�����*/
                    
                     xxcn_dec5
                     xxcn_dec6 
                      xxcn_qty_rcv go-on(F5 CTRL-D)   /*���¹�����*/
                /*     xxcn_qty_inv   /*����Ӧ����Ʊ��*/*/
                /*     xxcn_po_stat   /*״̬*/*/
                /*     xxcn_dec3      /*�ֹ����*/*/
               /*     xxcn_cost  go-on(F5 CTRL-D)*/
                   WITH FRAME a .
              
              IF trim(xxcn_po_stat) <> '' AND yn = NO THEN /*���ѹ��ʵ����������޸�,��ֻ�����޸�״̬*/
              DO:
              
                  SET yn1 = YES. /*�����Ƕ��Ѿ����ʵ����ݽ����޸�*/
                  UPDATE
                  /* xxcn_qty_fir_oh   /*�ڳ����*/*/
                  /* xxcn_qty_con_fir  /*���³�ʼ����δ������*/*/
                  /*   xxcn_qty_rcv_fir  /*���³�ʼ������*/*/
                 /*    xxcn_qty_inv_fir  /*���³�ʼӦ��Ʊ��*/*/
                /*      xxcn_qty_con  /*���º�����*/
                     xxcn_qty_rcv  go-on(F5 CTRL-D) /*���¹�����*/*/
                /*     xxcn_qty_inv   /*����Ӧ����Ʊ��*/*/
                     xxcn_po_stat   /*״̬*/
                /*     xxcn_dec3      /*�ֹ����*/*/
               /*     xxcn_cost  go-on(F5 CTRL-D)*/
                   WITH FRAME a .
              END. /*IF trim(xxcn_po_stat) <> '' AND yn = NO THEN /*���ѹ��ʵ����������޸�,��ֻ�����޸�״̬*/*/

              IF xxcn_po_stat = '' AND yn = NO AND yn1 = YES THEN /*���ѹ��ʵ����������޸�*/
              DO:
                   
                  ASSIGN xxcn_ch1 = ""  /*����ڼ�*/
                          xxcn_cost = 0  /*����*/
                          xxcn_ch3 = "". /*���ʷ�ʽ*/
              END. /*IF xxcn_po_stat <> '' AND yn = NO THEN /*���ѹ��ʵ����������޸�*/*/



              /*�ź��,ֻ�����û�ά�����¹����� 2011-4-12*/ 
              /*�ź��,������޸�ֻ�����û�ά�����¹�������,����������޸ı��¹��������ڳ����,���º����� 2011-4-12*/
               IF xxcn_qty_rcv <> 0 AND  xxcn_qty_rcv <> xxcn_qty_con  AND vd_type = 'U' THEN /*����Ǻ��ù���,�������ص��ں�������*/
               DO:
                    MESSAGE '����������Ϊ0�����ǵ��ڱ���Ӧ����'.
                    NEXT-PROMPT xxcn_qty_rcv WITH FRAME a.
                    UNDO ,RETRY .
               END. /*IF xxcn_qty_rcv <> 0 OR xxcn_qty_rcv <> xxcn_qty_con THEN*/
              /*�ź��,������޸�ֻ�����û�ά�����¹�������,����������޸ı��¹��������ڳ����,���º����� 2011-4-12*/
               IF xxcn_qty_rcv <> 0 AND  xxcn_qty_rcv <> xxcn_dec5 - xxcn_dec6 AND vd_type = 'I' THEN /*����������ʣ����������������-�˻���*/
               DO:
                    MESSAGE '����������Ϊ0�����ǵ����������ȥ�˻���'.
                    NEXT-PROMPT xxcn_qty_rcv WITH FRAME a.
                    undo,RETRY .
               END. /*IF xxcn_qty_rcv <> 0 OR xxcn_qty_rcv <> xxcn_qty_con THEN*/

               IF yn = YES THEN
               DO:
                    ASSIGN xxcn_dec3 = xxcn_qty_fir_oh + xxcn_dec5 - xxcn_dec6 - xxcn_qty_con. /*���=�ڳ�+���-�˻�-����*/
               END. /*IF yn = YES THEN ����*/

              END. /*m1 do:*/
             /*������¹���=0������=�������ļ�¼ͨ�� �ź�� 2011-04-12*/

            /* xxcn_amt_oh_fir =  xxcn_qty_fir_oh * xxcn_cost .
             xxcn_dec2 = xxcn_qty_con * xxcn_cost .           
              DISPLAY xxcn_amt_oh_fir xxcn_dec2 xxcn_dec3 WITH FRAME a .�ź�ע�� 2011-04-12 */
              if lastkey = keycode("F5")
                 or lastkey = keycode("CTRL-D") then do:
                   del-yn = NO.
                     {mfmsg01.i 11 1 del-yn}
                     if del-yn then 
                     DO:
                         FIND FIRST xxcnbuf NO-LOCK WHERE xxcnbuf.xxcn_vend = xxcn_mstr.xxcn_vend AND xxcnbuf.xxcn_part = xxcn_mstr.xxcn_part 
                                                      AND xxcnbuf.xxcn_site = xxcn_mstr.xxcn_site AND xxcnbuf.xxcn_domain = GLOBAL_domain 
                                                      AND ( xxcnbuf.xxcn_year > xxcn_mstr.xxcn_year 
                                                      OR ( xxcnbuf.xxcn_year = xxcn_mstr.xxcn_year AND xxcnbuf.xxcn_month > xxcn_mstr.xxcn_month) ) NO-ERROR.
                         IF  AVAIL xxcnbuf THEN
                         DO:
                             del-yn = NO.
                             MESSAGE '������'+ string(xxcn_mstr.xxcn_year) + string(xxcn_mstr.xxcn_month) + '�������һ�����ڣ��Ƿ����?' UPDATE del-yn.
                             IF del-yn = YES THEN
                                 DELETE xxcn_mstr.
                             ELSE
                                 RETRY.
                         END.
                         ELSE
                             DELETE xxcn_mstr .
                     END. /*if del-yn then �ź�� 2011-4-13 ���ü�¼�ǲ��Ǵ�������������,����ǲ�����ɾ�� */
                      
              FIND NEXT xxcn_mstr NO-ERROR .       
              IF AVAIL xxcn_mstr THEN /* display  xxcn_vend xxcn_part xxcn_year
                        xxcn_month xxcn_qty_fir_oh xxcn_cost xxcn_qty_con xxcn_qty_rcv xxcn_qty_inv 
                             xxcn_qty_con_fir  xxcn_qty_rcv_fir xxcn_qty_inv_fir xxcn_site 
                           xxcn_dec2 xxcn_dec3 xxcn_po_stat WITH FRAME a .*/

               /*�ź��,�߼�:���xxcn_po_stat = �գ���ô�۸�ȡ�۸�����ݣ���ֱ֮��ȡ�ñʼ�¼�еļ۸� 2011-04-12*/
                   DO:
                       IF xxcn_mstr.xxcn_po_stat <> "" THEN
                               DISPLAY xxcn_mstr.xxcn_vend xxs1 xxs2 xxcn_mstr.xxcn_part xxcn_mstr.xxcn_year xxcn_mstr.xxcn_month xxcn_mstr.xxcn_qty_fir_oh xxcn_mstr.xxcn_cost 
                                        xxcn_mstr.xxcn_qty_con xxcn_mstr.xxcn_dec5 xxcn_mstr.xxcn_dec6 xxcn_mstr.xxcn_qty_rcv 
                              /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                               xxcn_mstr.xxcn_po_stat  xxcn_mstr.xxcn_cost * xxcn_mstr.xxcn_qty_rcv @ xxcn_mstr.xxcn_dec2 '��ʽ��' @ xxcn_mstr.xxcn_ch2 xxcn_mstr.xxcn_ch1  WITH FRAME a .
                          ELSE
                          DO:
                               FIND FIRST xxpc_mstr USE-INDEX xxpc_list NO-LOCK WHERE xxpc_domain = GLOBAL_domain AND xxpc_list = xxcn_mstr.xxcn_vend AND xxpc_part = xxcn_mstr.xxcn_part 
                                                     AND ( xxpc_start <= xxd1 OR xxpc_start = ? ) AND ( xxpc_expire >= xxd2 OR xxpc_expire = ?) NO-ERROR.
                               IF AVAIL xxpc_mstr THEN
                               DO:
                                       IF xxpc_prod_line = 'YES' THEN  /*��ʽ��*/
                                             DISPLAY xxcn_mstr.xxcn_vend xxs1 xxs2 xxcn_mstr.xxcn_part xxcn_mstr.xxcn_year xxcn_mstr.xxcn_month xxcn_mstr.xxcn_qty_fir_oh xxpc_amt[1] @ xxcn_mstr.xxcn_cost xxcn_mstr.xxcn_qty_con xxcn_mstr.xxcn_dec5 xxcn_mstr.xxcn_dec6 xxcn_mstr.xxcn_qty_rcv 
                                             xxcn_mstr.xxcn_po_stat  xxpc_amt[1] * xxcn_mstr.xxcn_qty_rcv @ xxcn_mstr.xxcn_dec2  '��ʽ��' @ xxcn_mstr.xxcn_ch2 xxcn_mstr.xxcn_ch1 WITH FRAME a .
                               IF xxpc_prod_line = 'NO' THEN  /*�ݹ���*/
                                      DISPLAY xxcn_mstr.xxcn_vend xxs1 xxs2 xxcn_mstr.xxcn_part xxcn_mstr.xxcn_year xxcn_mstr.xxcn_month xxcn_mstr.xxcn_qty_fir_oh xxpc_amt[1] @ xxcn_mstr.xxcn_cost xxcn_mstr.xxcn_qty_con xxcn_mstr.xxcn_dec5 xxcn_mstr.xxcn_dec6 xxcn_mstr.xxcn_qty_rcv 
                                     /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                                      xxcn_mstr.xxcn_po_stat  xxpc_amt[1] * xxcn_mstr.xxcn_qty_rcv @ xxcn_mstr.xxcn_dec2  '�ݹ���' @ xxcn_mstr.xxcn_ch2 xxcn_mstr.xxcn_ch1 WITH FRAME a .
                               END. /*IF AVAIL xxpc_mstr THEN*/
                               ELSE
                               DO:
                                      DISPLAY xxcn_mstr.xxcn_vend xxs1 xxs2 xxcn_mstr.xxcn_part xxcn_mstr.xxcn_year xxcn_mstr.xxcn_month xxcn_mstr.xxcn_qty_fir_oh 0 @ xxcn_mstr.xxcn_cost xxcn_mstr.xxcn_qty_con xxcn_mstr.xxcn_dec5 xxcn_mstr.xxcn_dec6 xxcn_mstr.xxcn_qty_rcv 
                                     /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                                      xxcn_mstr.xxcn_po_stat  0 @ xxcn_mstr.xxcn_dec2  '�޼�' @ xxcn_mstr.xxcn_ch2 xxcn_mstr.xxcn_ch1 WITH FRAME a .
                               END. /*IF AVAIL xxpc_mstr THEN*/
                        END. /*IF xxcn_po_stat <> "" THEN*/
                   END.  /*if recno <> ? then*/
                   /*�ź��,�߼�:���xxcn_po_stat = �գ���ô�۸�ȡ�۸�����ݣ���ֱ֮��ȡ�ñʼ�¼�еļ۸� 2011-04-12*/
               ELSE       
               DO:
                   FIND FIRST xxcn_mstr NO-ERROR .
                   IF AVAIL xxcn_mstr THEN
                      /* display xxcn_vend xxcn_part xxcn_year
                               xxcn_month xxcn_qty_fir_oh xxcn_cost xxcn_qty_con xxcn_qty_rcv xxcn_qty_inv 
                               xxcn_qty_con_fir  xxcn_qty_rcv_fir xxcn_qty_inv_fir xxcn_site
                               xxcn_dec2 xxcn_dec3 xxcn_po_stat  WITH FRAME a . */

               /*�ź��,�߼�:���xxcn_po_stat = �գ���ô�۸�ȡ�۸�����ݣ���ֱ֮��ȡ�ñʼ�¼�еļ۸� 2011-04-12*/
                   DO:
                       IF xxcn_mstr.xxcn_po_stat <> "" THEN
                               DISPLAY xxcn_mstr.xxcn_vend xxs1 xxs2 xxcn_mstr.xxcn_part xxcn_mstr.xxcn_year xxcn_mstr.xxcn_month xxcn_mstr.xxcn_qty_fir_oh xxcn_mstr.xxcn_cost xxcn_mstr.xxcn_qty_con xxcn_mstr.xxcn_dec5 xxcn_mstr.xxcn_dec6 xxcn_mstr.xxcn_qty_rcv 
                              /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                               xxcn_mstr.xxcn_po_stat  xxcn_mstr.xxcn_cost * xxcn_mstr.xxcn_qty_rcv @ xxcn_mstr.xxcn_dec2 '��ʽ��' @ xxcn_mstr.xxcn_ch2 xxcn_mstr.xxcn_ch1  WITH FRAME a .
                          ELSE
                          DO:
                               FIND FIRST xxpc_mstr USE-INDEX xxpc_list NO-LOCK WHERE xxpc_domain = GLOBAL_domain AND xxpc_list = xxcn_mstr.xxcn_vend AND xxpc_part = xxcn_mstr.xxcn_part 
                                                     AND ( xxpc_start <= xxd1 OR xxpc_start = ? ) AND ( xxpc_expire >= xxd2 OR xxpc_expire = ?) NO-ERROR.
                               IF AVAIL xxpc_mstr THEN
                               DO:
                                       IF xxpc_prod_line = 'YES' THEN  /*��ʽ��*/
                                             DISPLAY xxcn_mstr.xxcn_vend xxs1 xxs2 xxcn_mstr.xxcn_part xxcn_mstr.xxcn_year xxcn_mstr.xxcn_month xxcn_mstr.xxcn_qty_fir_oh xxpc_amt[1] @ xxcn_mstr.xxcn_cost xxcn_mstr.xxcn_qty_con xxcn_mstr.xxcn_dec5 xxcn_mstr.xxcn_dec6 xxcn_mstr.xxcn_qty_rcv 
                                             xxcn_mstr.xxcn_po_stat  xxpc_amt[1] * xxcn_mstr.xxcn_qty_rcv @ xxcn_mstr.xxcn_dec2  '��ʽ��' @ xxcn_mstr.xxcn_ch2 xxcn_mstr.xxcn_ch1 WITH FRAME a .
                               IF xxpc_prod_line = 'NO' THEN  /*�ݹ���*/
                                      DISPLAY xxcn_mstr.xxcn_vend xxs1 xxs2 xxcn_mstr.xxcn_part xxcn_mstr.xxcn_year xxcn_mstr.xxcn_month xxcn_mstr.xxcn_qty_fir_oh xxpc_amt[1] @ xxcn_mstr.xxcn_cost xxcn_mstr.xxcn_qty_con xxcn_mstr.xxcn_dec5 xxcn_mstr.xxcn_dec6 xxcn_mstr.xxcn_qty_rcv 
                                     /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                                      xxcn_mstr.xxcn_po_stat  xxpc_amt[1] * xxcn_mstr.xxcn_qty_rcv @ xxcn_mstr.xxcn_dec2  '�ݹ���' @ xxcn_mstr.xxcn_ch2 xxcn_mstr.xxcn_ch1 WITH FRAME a .
                               END. /*IF AVAIL xxpc_mstr THEN*/
                               ELSE
                               DO:
                                      DISPLAY xxcn_mstr.xxcn_vend xxs1 xxs2 xxcn_mstr.xxcn_part xxcn_mstr.xxcn_year xxcn_mstr.xxcn_month xxcn_mstr.xxcn_qty_fir_oh 0 @ xxcn_mstr.xxcn_cost xxcn_mstr.xxcn_qty_con xxcn_mstr.xxcn_dec5 xxcn_mstr.xxcn_dec6 xxcn_mstr.xxcn_qty_rcv 
                                     /* xxcn_qty_con_fir xxcn_qty_rcv_fir*/
                                      xxcn_mstr.xxcn_po_stat  0 @ xxcn_mstr.xxcn_dec2  '�޼�' @ xxcn_mstr.xxcn_ch2 xxcn_mstr.xxcn_ch1 WITH FRAME a .
                               END. /*IF AVAIL xxpc_mstr THEN*/
                        END. /*IF xxcn_po_stat <> "" THEN*/
                   END.  /*if recno <> ? then*/
                   /*�ź��,�߼�:���xxcn_po_stat = �գ���ô�۸�ȡ�۸�����ݣ���ֱ֮��ȡ�ñʼ�¼�еļ۸� 2011-04-12*/
               
                   ELSE 
                     CLEAR FRAME a NO-PAUSE .
                 END.
              
               END.
               

/*J2X2*/     END. 



