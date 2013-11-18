/* SS - 091126.1 By: Bill Jiang */

/* SS - 091126.1 - RNB
[091126.1]

�������㹫ʽ:
1. [�ڳ�����] + [�ڼ���������] = [�ڼ����(����)����] + [��ĩ����]

[�ڳ�����]:
1. ����ο�<30.16.01.01.16 - ����Ʒ�ڳ��������� [xxpcwobc.p]>

[�ڼ����(����)����]:
1. ����ο�<30.16.01.04.01 - �ӹ������(����)���� [xxpcworc.p]>

ֻҪ������������֮һ,�ͻᴴ���ӹ�������:
1. ���ڼӹ�������(ISS-WO)�Ŀ������,����ο�:
1.1 <30.16.01.03.01 - �ӹ������ϴ��� [xxpcwoic.p]>
1.2 <30.16.01.03.18 - ������Ʒ�ӹ������ϴ��� [xxpcwoia.p]>
1.3 <30.16.01.07.02 - ������ӹ������ϴ��� [xxpcwoib.p]>
2. �����˹������Ĺ�������

[�ڼ���������]��[��ĩ����]:
1. �ڼ������������ڼ��´�����
2. ����ӹ����Ѿ�����,��: [��ĩ����]=0.
3. ������˳���жϼӹ����Ƿ��Ѿ�����:
3.1 �ӹ����ĵ�ǰ��ƽ���״̬Ϊ�ѽ�,�������ڲ�������ĩ
3.2 �ڲ�������ĩ�����ڷ�Χ��,����"WO-CLOSE"�������,��:
3.2.1 �����������Ʒ�ӹ���,�򰴼ӹ���ƥ��
3.2.2 �������־(ID)ƥ��
4. ����ӹ�����δ����,���������������������(���ӹ�������):
4.1 ���ۼƼӹ���,����׼�ӹ���(�ӹ�������Ϊ��)
4.2 �����ӹ���,�ӹ�������ΪR
4.3 �ۼƼӹ���(�ӹ������ͷǿ�,�Ҳ�ΪR)
5. ����Ǳ�׼�ӹ���:
5.1 ��������˹������Ĺ�������,���������ö���:
5.1.1 ����: 30.16.01.05.24 - �ӹ�����������ļ� [xxpcwopm.p]
5.1.2 �ֶ�: �ڼ������������㷽�� [SoftspeedPC_xxpcwo_qty_ord]
5.2 ���Ϊ"L",��: [�ڼ���������] = ���һ��������������֮��
5.2.1 ����Ǳ�ڵ�����:
5.2.1.1 ǰ����δ���
5.3 ���Ϊ"F"(ȱʡ),��: [�ڼ���������] = ��һ��������������֮��
5.3.1 ����Ǳ�ڵ�����:
5.3.1.1 �����з�Ʒ
5.4 ����: [�ڼ���������] = �ӹ����Ѷ�����
5.5 [�ڼ���������] = MAX([�ڼ���������] - [�ڳ�����],0)
5.6 ���[��ĩ����]Ϊ��,�����Ϊ0,ͬʱ����[�ڼ���������]
5.6.1 ֮����[��ĩ����]Ϊ��:
5.6.1.1 �ӹ������Ѷ��������
6. ����Ƿ����ӹ���:
6.1 [�ڼ�ӹ�����] = �ӹ������(�����������)����(ISS-WO)����
6.2 [�ڼ���������] = MAX([�ڼ���������] - [�ڳ�����],0)
6.3 ���[��ĩ����]Ϊ��,�����Ϊ0,ͬʱ����[�ڼ���������]
7. ������ۼƼӹ���:
7.1 ���[�ڼ����(����)����]<>0,��: [��ĩ����] = 0
7.2 ����: [��ĩ����] = 1

���ܵĴ���:
1. ��������ûά��
2. ���������ѽ�
3. ����δ��
4. �����ѽ�

���ܵľ���:
1. ��¼�Ѿ�����,�Ƿ����?

ע������:
1. ��������κ��쳣,���Ѿ�ִ�е����񽫱�����,��Ҫôȫ���ɹ�,Ҫôȫ��ʧ��



�������[allow_errors]:
1. ������������,�������´���ʱ����ֹ: 6245 - ��������#ID#δ������
2. ����������,�������¾���ʱ������: 6245 - ��������#ID#δ������
3. �������ִ����ԭ��: ͬһ���ӹ����Ⱥ������������������

[091126.1]

SS - 091126.1 - RNE */

{mfdtitle.i "091126.1"}

define variable entity like glcd_entity.
define variable yr like glc_year.
define variable per like glc_per.
DEFINE VARIABLE allow_errors LIKE mfc_logical INITIAL NO.
DEFINE VARIABLE msg AS CHARACTER FORMAT "x(58)" NO-UNDO.

DEFINE VARIABLE date1 AS DATE.
define variable efdate like tr_effdate.
define variable efdate1 like tr_date.
define variable l_yn        like mfc_logical             no-undo.
DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE qty_tot AS INTEGER.

DEFINE TEMP-TABLE tt1
   FIELD tt1_site LIKE xxpcwo_site
   FIELD tt1_part LIKE xxpcwo_part
   FIELD tt1_lot LIKE xxpcwo_lot
   FIELD tt1_qty_beg LIKE xxpcwo_qty_beg
   FIELD tt1_qty_comp LIKE xxpcwo_qty_comp
   FIELD tt1_qty_rjct LIKE xxpcwo_qty_rjct
   FIELD tt1_qty_ord LIKE xxpcwo_qty_ord
   FIELD tt1_qty_end LIKE xxpcwo_qty_end
   INDEX index1 tt1_site tt1_part tt1_lot
   .

DEFINE TEMP-TABLE tt2
   FIELD tt2_site LIKE xxpcwo_site
   FIELD tt2_part LIKE xxpcwo_part
   FIELD tt2_lot LIKE xxpcwo_lot
   FIELD tt2_qty_beg LIKE xxpcwo_qty_beg
   FIELD tt2_qty_comp LIKE xxpcwo_qty_comp
   FIELD tt2_qty_rjct LIKE xxpcwo_qty_rjct
   FIELD tt2_qty_ord LIKE xxpcwo_qty_ord
   FIELD tt2_qty_end LIKE xxpcwo_qty_end
   INDEX index1 tt2_site tt2_part tt2_lot
   .

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   entity colon 20    
   en_name NO-LABEL
   yr     colon 20    
   per     colon 20    
   SKIP (1)
   allow_errors COLON 20
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM
   msg COLON 20
with frame c side-labels width 80 NO-ATTR-SPACE.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

date1 = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1.
FIND FIRST glc_cal 
   WHERE glc_domain = GLOBAL_domain
   AND glc_start <= date1
   AND glc_end >= date1
   NO-LOCK NO-ERROR.
IF AVAILABLE glc_cal THEN DO:
   yr = glc_year.
   per = glc_per.
END.

entity = CURRENT_entity.      
FIND FIRST en_mstr 
   WHERE en_domain = GLOBAL_domain
   AND en_entity = entity
   NO-LOCK NO-ERROR.
IF AVAILABLE en_mstr THEN DO:
   DISPLAY
      en_name
      WITH FRAME a.
END.
ELSE DO:
   DISPLAY
      "" @ en_name
      WITH FRAME a.
END.

mainloop:
repeat:
   VIEW FRAME a.

   msg = "�ȴ�ִ��...".
   DISPLAY 
      msg
      WITH FRAME c.

   ststatus = stline[1].
   status input ststatus.
   
   update
      entity 
      yr 
      per
      allow_errors
      with frame a.

   status input "".
      
   FIND FIRST en_mstr 
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      NO-LOCK NO-ERROR.
   IF AVAILABLE en_mstr THEN DO:
      DISPLAY
         en_name
         WITH FRAME a.
   END.
   ELSE DO:
      DISPLAY
         "" @ en_name
         WITH FRAME a.
   END.

   {gprun.i ""xxpcprhcv.p"" "(
      INPUT entity,
      INPUT yr,
      INPUT per,
      INPUT-OUTPUT efdate,
      INPUT-OUTPUT efdate1
      )"}
   IF RETURN-VALUE = "no" THEN DO:
      UNDO mainloop.
   END.

   /* �Ѿ����� */
   FOR EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = entity
      ,EACH xxpcwo_mstr NO-LOCK
      WHERE xxpcwo_domain = GLOBAL_domain
      AND xxpcwo_site = si_site
      AND xxpcwo_year = yr
      AND xxpcwo_per = per
      :
      l_yn = YES.
      /* 301606 - ��¼�Ѿ�����.�Ƿ����? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         UNDO mainloop.
      end. /* IF NOT l_yn */

      LEAVE.
   END.

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

   DO TRANSACTION ON STOP UNDO:
      msg = "����ɾ����ϸ��ʱ��...".
      DISPLAY
         msg
         WITH FRAME c.
      FOR EACH tt1:
         DELETE tt1.
      END.

      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         :
         IF si_entity <> entity THEN DO:
            NEXT.
         END.

         msg = "����ɾ���ص�<" + si_site + ">�Ѿ����ڵļ�¼...".
         DISPLAY
            msg
            WITH FRAME c.
         FOR EACH xxpcwo_mstr EXCLUSIVE-LOCK
            WHERE xxpcwo_domain = GLOBAL_domain
            AND xxpcwo_site = si_site
            AND xxpcwo_year = yr
            AND xxpcwo_per = per
            :
            DELETE xxpcwo_mstr.
         END.

         msg = "���ڴ����ص�<" + si_site + ">���ڳ�����...".
         DISPLAY
            msg
            WITH FRAME c.
         i1 = 0.
         FOR EACH xxpcwob_mstr EXCLUSIVE-LOCK
            WHERE xxpcwob_domain = GLOBAL_domain
            AND xxpcwob_site = si_site
            AND xxpcwob_year = yr
            AND xxpcwob_per = per
            :
            IF xxpcwob_qty = 0 THEN DO:
               NEXT.
            END.

            i1 = i1 + 1.
            msg = "���ڴ����ص�<" + si_site + ">���ڳ�����[" + STRING(i1) + "]...".
            DISPLAY
               msg
               WITH FRAME c.
            CREATE tt1.
            ASSIGN
               tt1_site = xxpcwob_site
               tt1_part = xxpcwob_part
               tt1_lot = xxpcwob_lot
               tt1_qty_beg = xxpcwob_qty
               .
         END.

         msg = "���ڴ����ص�<" + si_site + ">�����ͱ�������...".
         DISPLAY
            msg
            WITH FRAME c.
         i1 = 0.
         FOR EACH xxpcwor_hist NO-LOCK
            WHERE xxpcwor_domain = GLOBAL_domain
            AND xxpcwor_site = si_site
            AND xxpcwor_year = yr
            AND xxpcwor_per = per
            :
            IF xxpcwor_type = "RCT-WO" THEN DO:
               i1 = i1 + 1.
               msg = "���ڴ����ص�<" + si_site + ">�����ͱ�������[" + STRING(i1) + "]...".
               DISPLAY
                  msg
                  WITH FRAME c.
               CREATE tt1.
               ASSIGN
                  tt1_site = xxpcwor_site
                  tt1_part = xxpcwor_part
                  tt1_lot = xxpcwor_lot
                  tt1_qty_comp = xxpcwor_qty
                  .
               NEXT.
            END.
            ELSE IF xxpcwor_type = "RJCT-WO" THEN DO:
               i1 = i1 + 1.
               msg = "���ڴ����ص�<" + si_site + ">�����ͱ�������[" + STRING(i1) + "]...".
               DISPLAY
                  msg
                  WITH FRAME c.
               CREATE tt1.
               ASSIGN
                  tt1_site = xxpcwor_site
                  tt1_part = xxpcwor_part
                  tt1_lot = xxpcwor_lot
                  tt1_qty_rjct = xxpcwor_qty
                  .
               NEXT.
            END.
         END.

         msg = "���ڴ����ص�<" + si_site + ">�����ϼ�¼...".
         DISPLAY
            msg
            WITH FRAME c.
         i1 = 0.
         FOR EACH xxpcwoi_hist NO-LOCK
            WHERE xxpcwoi_domain = GLOBAL_domain
            AND xxpcwoi_site = si_site
            AND xxpcwoi_year = yr
            AND xxpcwoi_per = per
            BREAK
            BY xxpcwoi_par
            BY xxpcwoi_lot
            :
            IF LAST-OF(xxpcwoi_lot) THEN DO:
               i1 = i1 + 1.
               msg = "���ڴ����ص�<" + si_site + ">�����ϼ�¼[" + STRING(i1) + "]...".
               DISPLAY
                  msg
                  WITH FRAME c.
               CREATE tt1.
               ASSIGN
                  tt1_site = xxpcwoi_site
                  tt1_part = xxpcwoi_par
                  tt1_lot = xxpcwoi_lot
                  .
            END.
         END.

         msg = "���ڴ����ص�<" + si_site + ">���˹�������¼...".
         DISPLAY
            msg
            WITH FRAME c.
         i1 = 0.
         FOR EACH op_hist NO-LOCK
            WHERE op_domain = GLOBAL_domain
            AND op_date >= efdate
            AND op_date <= efdate1
            AND op_site = si_site
            BREAK
            BY op_part
            BY op_wo_lot
            :
            IF LAST-OF(op_wo_lot) THEN DO:
               i1 = i1 + 1.
               msg = "���ڴ����ص�<" + si_site + ">���˹�������¼[" + STRING(i1) + "]...".
               DISPLAY
                  msg
                  WITH FRAME c.
               CREATE tt1.
               ASSIGN
                  tt1_site = op_site
                  tt1_part = op_part
                  tt1_lot = op_wo_lot
                  .
            END.
         END.
      END. /* FOR EACH si_mstr NO-LOCK */

      msg = "����ɾ��������ʱ��...".
      DISPLAY
         msg
         WITH FRAME c.
      FOR EACH tt2:
         DELETE tt2.
      END.

      msg = "���ڴ���������ʱ��...".
      DISPLAY
         msg
         WITH FRAME c.
      qty_tot = 0.
      FOR EACH tt1
         BREAK
         BY tt1_site
         BY tt1_part
         BY tt1_lot
         :
         ACCUMULATE tt1_qty_beg (TOTAL
                                 BY tt1_site
                                 BY tt1_part
                                 BY tt1_lot
                                 ).
         ACCUMULATE tt1_qty_comp (TOTAL
                                 BY tt1_site
                                 BY tt1_part
                                 BY tt1_lot
                                 ).
         ACCUMULATE tt1_qty_rjct (TOTAL
                                 BY tt1_site
                                 BY tt1_part
                                 BY tt1_lot
                                 ).
         IF LAST-OF(tt1_lot) THEN DO:
            qty_tot = qty_tot + 1.
            CREATE tt2.
            ASSIGN
               tt2_site = tt1_site
               tt2_part = tt1_part
               tt2_lot = tt1_lot
               tt2_qty_beg = (ACCUMULATE TOTAL BY tt1_lot tt1_qty_beg)
               tt2_qty_comp = (ACCUMULATE TOTAL BY tt1_lot tt1_qty_comp)
               tt2_qty_rjct = (ACCUMULATE TOTAL BY tt1_lot tt1_qty_rjct)
               .
         END.
      END.

      msg = "���ڼ����´�����ĩ����...".
      DISPLAY
         msg
         WITH FRAME c.
      i1 = 0.
      FOR EACH tt2:
         i1 = i1 + 1.
         msg = "���ڼ����´�����ĩ���� - ���ӹ����Ƿ����[" + STRING(i1) + "/" + STRING(qty_tot) + "]...".
         DISPLAY
            msg
            WITH FRAME c.
         FIND FIRST wo_mstr
            WHERE wo_domain = global_domain
            AND wo_lot = tt2_lot
            AND wo_part = tt2_part
            NO-LOCK NO-ERROR.
         IF NOT AVAILABLE wo_mstr THEN DO:
            IF allow_errors = NO THEN DO:
               /* Work Order # ID # not processed */
               {pxmsg.i &MSGNUM=6245 &ERRORLEVEL=3 &MSGARG1=tt2_lot}
               STOP.
            END.
            ELSE DO:
               NEXT.
            END.
         END.

         /* �Ѿ����� */
         IF wo_acct_close = YES AND wo_close_eff <= efdate1 THEN DO:
            ASSIGN
               tt2_qty_end = 0
               tt2_qty_ord = tt2_qty_comp + tt2_qty_rjct + tt2_qty_end - tt2_qty_beg
               .
            NEXT.
         END.

         msg = "���ڼ����´�����ĩ���� - ���ӹ����Ƿ����[" + STRING(i1) + "/" + STRING(qty_tot) + "]...".
         DISPLAY
            msg
            WITH FRAME c.
         /* �Ѿ����� */
         FIND FIRST tr_hist
            WHERE tr_domain = GLOBAL_domain
            AND tr_part = tt2_part
            AND tr_effdate <= efdate1
            AND tr_type = "WO-CLOSE"
            AND ((tr_lot = tt2_lot AND wo_joint_type = "") OR (tr_nbr = wo_nbr AND wo_joint_type <> ""))
            USE-INDEX tr_part_eff
            NO-LOCK NO-ERROR.
         IF AVAILABLE tr_hist THEN DO:
            msg = "���ڼ����´�����ĩ���� - �ѽ���ļӹ���[" + STRING(i1) + "]...".
            DISPLAY
               msg
               WITH FRAME c.
            ASSIGN
               tt2_qty_end = 0
               tt2_qty_ord = tt2_qty_comp + tt2_qty_rjct + tt2_qty_end - tt2_qty_beg
               .
            NEXT.
         END. /* IF AVAILABLE tr_hist THEN DO: */

         msg = "���ڼ����´�����ĩ���� - δ����ļӹ���[" + STRING(i1) + "/" + STRING(qty_tot) + "]...".
         DISPLAY
            msg
            WITH FRAME c.
         /* ��׼�ӹ��� */
         IF wo_type = "" THEN DO:
            l_yn = NO.
            for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedPC_xxpcwo_qty_ord"
            exclusive-lock: end.
            if not available mfc_ctrl then do:
               create mfc_ctrl.
               assign
                  mfc_domain = GLOBAL_domain
                  mfc_field   = "SoftspeedPC_xxpcwo_qty_ord"
                  mfc_type    = "C"
                  mfc_module  = mfc_field
                  mfc_seq     = 10
                  mfc_char = "F"
                  .
            end.
            IF mfc_char = "F" THEN DO:
               FOR EACH op_hist NO-LOCK
                  WHERE op_domain = GLOBAL_domain
                  AND op_wo_nbr = wo_nbr
                  AND op_wo_lot = wo_lot
                  AND op_date >= efdate
                  AND op_date <= efdate1
                  BREAK
                  BY op_wo_op
                  :
                  ACCUMULATE op_qty_comp (TOTAL
                                          BY op_wo_op
                                          ).
                  IF LAST-OF(op_wo_op) THEN DO:
                     ASSIGN
                        tt2_qty_ord = MAX(((ACCUMULATE TOTAL BY op_wo_op op_qty_comp) - tt2_qty_beg), 0)
                        tt2_qty_end = tt2_qty_beg + tt2_qty_ord - tt2_qty_comp - tt2_qty_rjct
                        .
                     IF tt2_qty_end < 0 THEN DO:
                        ASSIGN
                           tt2_qty_ord = tt2_qty_ord - tt2_qty_end
                           tt2_qty_end = tt2_qty_end - tt2_qty_end
                           .
                     END.

                     l_yn = YES.

                     LEAVE.
                  END.
               END. /* FOR EACH op_hist NO-LOCK */
            END. /* IF mfc_char = "L" THEN DO: */
            IF mfc_char = "L" THEN DO:
               FOR EACH op_hist NO-LOCK
                  WHERE op_domain = GLOBAL_domain
                  AND op_wo_nbr = wo_nbr
                  AND op_wo_lot = wo_lot
                  AND op_date >= efdate
                  AND op_date <= efdate1
                  BREAK
                  BY op_wo_op
                  :
                  ACCUMULATE op_qty_comp (TOTAL
                                          BY op_wo_op
                                          ).
                  IF LAST(op_wo_op) THEN DO:
                     ASSIGN
                        tt2_qty_ord = MAX(((ACCUMULATE TOTAL BY op_wo_op op_qty_comp) - tt2_qty_beg), 0)
                        tt2_qty_end = tt2_qty_beg + tt2_qty_ord - tt2_qty_comp - tt2_qty_rjct
                        .
                     IF tt2_qty_end < 0 THEN DO:
                        ASSIGN
                           tt2_qty_ord = tt2_qty_ord - tt2_qty_end
                           tt2_qty_end = tt2_qty_end - tt2_qty_end
                           .
                     END.

                     l_yn = YES.
                  END.
               END. /* FOR EACH op_hist NO-LOCK */
            END. /* IF mfc_char = "L" THEN DO: */
            IF l_yn = YES THEN DO:
               NEXT.
            END.

            ASSIGN
               tt2_qty_ord = MAX((wo_qty_ord - tt2_qty_beg), 0)
               tt2_qty_end = tt2_qty_beg + tt2_qty_ord - tt2_qty_comp - tt2_qty_rjct
               .
            IF tt2_qty_end < 0 THEN DO:
               ASSIGN
                  tt2_qty_ord = tt2_qty_ord - tt2_qty_end
                  tt2_qty_end = tt2_qty_end - tt2_qty_end
                  .
            END.

            NEXT.
         END. /* IF wo_type = "" THEN DO: */

         /* �����ӹ��� */
         ELSE IF wo_type = "R" THEN DO:
            FIND FIRST xxpcwoi_hist
               WHERE xxpcwoi_domain = GLOBAL_domain
               AND xxpcwoi_site = tt2_site
               AND xxpcwoi_year = yr
               AND xxpcwoi_per = per
               AND xxpcwoi_par = tt2_part
               AND xxpcwoi_lot = tt2_lot
               AND xxpcwoi_comp = tt2_part
               NO-LOCK NO-ERROR.
            IF AVAILABLE xxpcwoi_hist THEN DO:
               ASSIGN
                  tt2_qty_ord = MAX((- xxpcwoi_qty - tt2_qty_beg), 0)
                  tt2_qty_end = tt2_qty_beg + tt2_qty_ord - tt2_qty_comp - tt2_qty_rjct
                  .
               IF tt2_qty_end < 0 THEN DO:
                  ASSIGN
                     tt2_qty_ord = tt2_qty_ord - tt2_qty_end
                     tt2_qty_end = tt2_qty_end - tt2_qty_end
                     .
               END.
            END. /* IF AVAILABLE xxpcwoi_hist THEN DO: */
            ELSE DO:
               ASSIGN
                  tt2_qty_ord = MAX((0 - tt2_qty_beg), 0)
                  tt2_qty_end = tt2_qty_beg + tt2_qty_ord - tt2_qty_comp - tt2_qty_rjct
                  .
               IF tt2_qty_end < 0 THEN DO:
                  ASSIGN
                     tt2_qty_ord = tt2_qty_ord - tt2_qty_end
                     tt2_qty_end = tt2_qty_end - tt2_qty_end
                     .
               END.
            END. /* ELSE DO: */

            NEXT.
         END.

         /* �ۼƼӹ��� */
         ELSE DO:
            /* ֻҪ�������򱨷�,����ĩΪ0 */
            IF ((tt2_qty_comp <> 0) OR (tt2_qty_rjct <> 0)) THEN DO:
               ASSIGN
                  tt2_qty_end = 0
                  tt2_qty_ord = tt2_qty_comp + tt2_qty_rjct + tt2_qty_end - tt2_qty_beg
                  .
               NEXT.
            END.
            /* ������ĩΪ1 */
            ELSE DO:
               ASSIGN
                  tt2_qty_end = 1
                  tt2_qty_ord = tt2_qty_comp + tt2_qty_rjct + tt2_qty_end - tt2_qty_beg
                  .
               NEXT.
            END.
         END.
      END. /* FOR EACH tt2: */

      msg = "����д�������ʱ���¼...".
      DISPLAY
         msg
         WITH FRAME c.
      FOR EACH tt2:
         IF tt2_qty_beg = 0 
            AND tt2_qty_ord = 0
            AND tt2_qty_comp = 0
            AND tt2_qty_rjct = 0
            AND tt2_qty_end = 0
            THEN DO:
            NEXT.
         END.

         CREATE xxpcwo_mstr.
         ASSIGN
            xxpcwo_domain = global_domain
            xxpcwo_site = tt2_site
            xxpcwo_year = yr
            xxpcwo_per = per
            xxpcwo_part = tt2_part
            xxpcwo_lot = tt2_lot
            xxpcwo_qty_beg = tt2_qty_beg
            xxpcwo_qty_ord = tt2_qty_ord
            xxpcwo_qty_comp = tt2_qty_comp
            xxpcwo_qty_rjct = tt2_qty_rjct
            xxpcwo_qty_end = tt2_qty_end
            .
      END.
   END. /* DO TRANSACTION ON STOP UNDO: */
end.
