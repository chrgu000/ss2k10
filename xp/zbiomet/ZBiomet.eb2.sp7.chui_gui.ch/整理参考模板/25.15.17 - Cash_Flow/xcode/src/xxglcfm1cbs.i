/* BY: Bill Jiang DATE: 09/29/06 ECO: 20060929.1 */
/* BY: Bill Jiang DATE: 11/20/07 ECO: 20071120.1 */

/* SS - 20071120.1 - B */
/*
1. ���������������������:
   dr_cr:0 - ��������,1 - �跽������,2 - ����������
*/
/* SS - 20071120.1 - E */

/* SS - 20060929.1 - B */
/*
1. ����˵��:
{1} - glrd_code:
   030101 - ��Ӫ��������ֽ�����
   030102 - ��Ӫ��������ֽ�����
{2} - usrw_intfld[4]
{3} - usrw_intfld[5]
2. �����ֽ��ֽ�ȼ���Է���Ŀ�Ĳ�Ӱ�쾻����ľ�Ӫ���ʲ���ծ�ļ��ٻ�����
3. ��һ�����˲ο���Ϊ��С�ļ��㵥λ
4. ���������³���:
	0311 - �����������Ϊ��Ӫ��ֽ�����
*/
/* SS - 20060929.1 - E */

can_find = FALSE.
{gprun.i ""xxglcfm1glrd.p"" "(
   INPUT {1},
   INPUT gltr_acc,
   INPUT gltr_sub,
   INPUT gltr_ctr,
   INPUT-OUTPUT can_find,
   INPUT-OUTPUT sums1
   /* SS - 20071120.1 - B */
   ,INPUT-OUTPUT dr_cr
   /* SS - 20071120.1 - E */
   )"}
IF can_find = TRUE 
   /* SS - 20071120.1 - B */
   AND (
   (((gltr_amt >= 0 AND gltr_correction = NO) OR (gltr_amt <= 0 AND gltr_correction = YES)) AND dr_cr = "1")
   OR
   (((gltr_amt <= 0 AND gltr_correction = NO) OR (gltr_amt >= 0 AND gltr_correction = YES)) AND dr_cr = "2")
   OR 
   (dr_cr <> "1" AND dr_cr <> "2")
   )
   /* SS - 20071120.1 - E */
   THEN DO:
   /* �Է���Ŀ���ʲ���ծ���� */
   FIND FIRST ac_mstr
      WHERE 
      /* eB2.1 */ ac_domain = GLOBAL_domain AND
      ac_code = gltr_acc 
      AND (ac_type = 'A' OR ac_type = 'L') 
      USE-INDEX ac_code 
      NO-LOCK 
      NO-ERROR
      .
   IF AVAILABLE ac_mstr THEN DO:
      /* ���ھ����� */
      can_find = FALSE.
      {gprun.i ""xxglcfm1glrd.p"" "(
         INPUT '0311',
         INPUT gltr_acc,
         INPUT gltr_sub,
         INPUT gltr_ctr,
         INPUT-OUTPUT can_find,
         INPUT-OUTPUT sums2
         /* SS - 20071120.1 - B */
         ,INPUT-OUTPUT dr_cr
         /* SS - 20071120.1 - E */
         )"}
      IF can_find = TRUE THEN DO:
         ASSIGN
            gltr_user1 = "SUCCESS"
            usrw_key3 = "SUCCESS"
            usrw_intfld[2] = sums1
            /* 0311 - �����������Ϊ��Ӫ��ֽ����� */
            usrw_intfld[3] = sums2
            usrw_intfld[4] = {2}
            usrw_intfld[5] = {3}
            usrw_charfld[1] = acc
            usrw_charfld[2] = sub
            usrw_charfld[3] = ctr
            .
      END. /* IF can_find = TRUE THEN DO: */
      ELSE DO:
         ASSIGN
            gltr_user1 = "ERROR"
            usrw_key3 = "ERROR"
            usrw_charfld[1] = "C001"
            usrw_charfld[2] = "û�е����ֽ��ֽ�ȼ���Է���Ŀ�Ĳ�Ӱ�쾻����ľ�Ӫ���ʲ���ծ�ļ��ٻ�����"
            .
      END.

      NEXT.
   END. /* IF AVAILABLE ac_mstr THEN DO: */
   /* �Է���Ŀ���ʲ���ծ���� */


   /* �Է���Ŀ�������� */
   FIND FIRST ac_mstr
      WHERE 
      /* eB2.1 */ ac_domain = GLOBAL_domain AND
      ac_code = gltr_acc 
      AND (ac_type = 'I' OR ac_type = 'E') 
      USE-INDEX ac_code 
      NO-LOCK 
      NO-ERROR
      .
   IF AVAILABLE ac_mstr THEN DO:
      ASSIGN
         gltr_user1 = "SUCCESS"
         usrw_key3 = "SUCCESS"
         usrw_intfld[2] = sums1
         usrw_intfld[4] = {2}
         usrw_charfld[1] = acc
         usrw_charfld[2] = sub
         usrw_charfld[3] = ctr
         .

      NEXT.
   END.
   /* �Է���Ŀ�������� */

   ASSIGN
      gltr_user1 = "ERROR"
      usrw_key3 = "ERROR"
      usrw_charfld[1] = "C002"
      usrw_charfld[2] = "�Է���Ŀ�쳣(����A,L,I,E�е��κ�һ��)"
      .

   NEXT.
END. /* IF can_find = TRUE THEN DO: */
