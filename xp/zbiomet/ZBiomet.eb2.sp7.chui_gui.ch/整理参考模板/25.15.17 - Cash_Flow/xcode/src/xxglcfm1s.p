/* BY: Bill Jiang DATE: 10/03/06 ECO: 20061003.1 */

/* SS - 20061003.1 - B */
/*
1. ����ָ���ļȲ������ֽ��ֽ�ȼ����Ҳ�����������Ŀ�����˲ο���
2. ��һ�����˲ο���Ϊ��С�ļ��㵥λ
*/
/* SS - 20061003.1 - E */

/*V8-*/
{mfdeclre.i}

/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}

DEFINE INPUT PARAMETER ref LIKE gltr_ref.

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

   ASSIGN
      gltr_user1 = "SKIP"
      usrw_key3 = "SKIP"
      usrw_charfld[1] = "C101"
      usrw_charfld[2] = "�Ȳ������ֽ��ֽ�ȼ����Ҳ�����������Ŀ"
      .
END. /* FOR EACH gltrhist EXCLUSIVE-LOCK */
