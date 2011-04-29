/* BY: Bill Jiang DATE: 10/03/06 ECO: 20061003.1 */
/* BY: Bill Jiang DATE: 11/20/07 ECO: 20071120.1 */

/* SS - 20071120.1 - B */
/*
1. ���������������������:
   dr_cr:0 - ��������,1 - �跽������,2 - ����������
*/
/* SS - 20071120.1 - E */

/* SS - 20061003.1 - B */
/*
1. ����ָ���Ĳ������ֽ��ֽ�ȼ���İ��������Ŀ�����˲ο���
2. ��һ�����˲ο���Ϊ��С�ļ��㵥λ
3. ���������³���:
	0311 - �����������Ϊ��Ӫ��ֽ�����
*/
/* SS - 20061003.1 - E */

/*V8-*/
{mfdeclre.i}

/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}

DEFINE INPUT PARAMETER ref LIKE gltr_ref.
DEFINE INPUT PARAMETER acc LIKE gltr_acc.
DEFINE INPUT PARAMETER sub LIKE gltr_sub.
DEFINE INPUT PARAMETER ctr LIKE gltr_ctr.
DEFINE VARIABLE can_find LIKE mfc_logical.
DEFINE VARIABLE sums1 LIKE glrd_sums.
/* SS - 20071120.1 - B */
DEFINE VARIABLE dr_cr LIKE glrd_user1.
/* SS - 20071120.1 - E */

FOR EACH gltr_hist EXCLUSIVE-LOCK
   WHERE 
   /* eB2.1 */ gltr_domain = GLOBAL_domain AND
   gltr_ref = ref 
   USE-INDEX gltr_ref 
   :

   FIND FIRST usrw_wkfl WHERE 
      /* eB2.1 */ usrw_domain = GLOBAL_domain AND
      usrw_key1 = "GLTR_HIST"
      AND usrw_key2 = gltr_ref + "." + STRING(gltr_rflag) + "." + STRING(gltr_line)
      EXCLUSIVE-LOCK
      NO-ERROR.
   IF NOT AVAILABLE usrw_wkfl THEN DO:
      CREATE usrw_wkfl.
      ASSIGN
         /* eB2.1 */ usrw_domain = GLOBAL_domain
         usrw_key1 = "GLTR_HIST"
         usrw_key2 = gltr_ref + "." + STRING(gltr_rflag) + "." + STRING(gltr_line)
         .
   END.
   ASSIGN
      usrw_datefld[1] = TODAY
      usrw_intfld[1] = TIME
      usrw_key5 = GLOBAL_userid
      usrw_key6 = execname
      .

   /* �����Ŀ */
   IF gltr_acc = acc AND gltr_sub = sub AND gltr_ctr = ctr THEN DO:
      ASSIGN
         gltr_user1 = "SKIP"
         usrw_key3 = "SKIP"
         usrw_charfld[1] = "C103"
         usrw_charfld[2] = "�����Ŀ"
         .
      NEXT.
   END.
   /* �����Ŀ */

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
   IF NOT AVAILABLE ac_mstr THEN DO:
      ASSIGN
         gltr_user1 = "SKIP"
         usrw_key3 = "SKIP"
         usrw_charfld[1] = "C103"
         /* TODO */
         usrw_charfld[2] = "�����Ŀ"
         .
      NEXT.
   END.
   /* �Է���Ŀ���ʲ���ծ���� */

   can_find = FALSE.
   {gprun.i ""xxglcfm1glrd.p"" "(
      INPUT '0311',
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
      ASSIGN
         gltr_user1 = "SUCCESS"
         usrw_key3 = "SUCCESS"
         usrw_intfld[2] = sums1
         usrw_intfld[4] = -1
         usrw_charfld[1] = acc
         usrw_charfld[2] = sub
         usrw_charfld[3] = ctr
         .
   END.
   ELSE DO:
      ASSIGN
         gltr_user1 = "ERROR"
         usrw_key3 = "ERROR"
         usrw_charfld[1] = "C004"
         usrw_charfld[2] = "û�ж��岻�����ֽ��ֽ�ȼ���İ�������Է���Ŀ�ĸ����д�"
         .
   END.
END. /* FOR EACH gltrhist EXCLUSIVE-LOCK */
