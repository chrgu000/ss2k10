

FORM
    SKIP(1)
    b_ct_comp COLON 20 LABEL "��˾"
    SKIP(0.5)
    b_ct_nrm COLON 20 LABEL "����������ɷ�ʽ"
   
   /* SKIP(0.5)
    b_ct_prod_buffer COLON 20 LABEL "�߱߿�λ"  */
    WITH FRAME b_ctrl WIDTH 80  TITLE '�����ļ�' THREE-D SIDE-LABELS. 
REPEAT :
  FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
  DISP b_ct_comp b_ct_nrm /*b_ct_prod_buffer*/ WITH FRAME b_ctrl.
    PROMPT-FOR b_ct_comp b_ct_nrm  /*b_ct_prod_buffer*/ WITH FRAME b_ctrl.
   IF INPUT b_ct_nrm <> 'seq' AND INPUT b_ct_nrm <> 'ymd' THEN DO:
    MESSAGE '����������ɷ�ʽֻ��ΪSEQ��YMD����ģʽ��' VIEW-AS ALERT-BOX ERROR.
    UNDO,RETRY.   
    END.
    
   
    IF INPUT b_ct_comp = '' OR INPUT b_ct_nrm = '' /*OR   INPUT b_ct_prod_buffer = '' */ THEN DO:
      MESSAGE '��������ȫ����Ϊ�� ��' VIEW-AS ALERT-BOX ERROR.
      UNDO,RETRY.
   END.

   
   FIND FIRST b_ct_ctrl EXCLUSIVE-LOCK NO-ERROR.
   ASSIGN
       b_ct_nrm = INPUT b_ct_nrm
       b_ct_up_mtd = 'online'
   b_ct_comp = INPUT b_ct_comp
       /*b_ct_prod_buffer = INPUT b_ct_prod_buffer*/.
   
   
   
   
   
   END.
