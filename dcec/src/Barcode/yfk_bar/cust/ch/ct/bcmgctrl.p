

FORM
    SKIP(1)
    b_ct_comp COLON 20 LABEL "公司"
    SKIP(0.5)
    b_ct_nrm COLON 20 LABEL "零件条码生成方式"
   
   /* SKIP(0.5)
    b_ct_prod_buffer COLON 20 LABEL "线边库位"  */
    WITH FRAME b_ctrl WIDTH 80  TITLE '控制文件' THREE-D SIDE-LABELS. 
REPEAT :
  FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
  DISP b_ct_comp b_ct_nrm /*b_ct_prod_buffer*/ WITH FRAME b_ctrl.
    PROMPT-FOR b_ct_comp b_ct_nrm  /*b_ct_prod_buffer*/ WITH FRAME b_ctrl.
   IF INPUT b_ct_nrm <> 'seq' AND INPUT b_ct_nrm <> 'ymd' THEN DO:
    MESSAGE '零件条码生成方式只能为SEQ，YMD两种模式！' VIEW-AS ALERT-BOX ERROR.
    UNDO,RETRY.   
    END.
    
   
    IF INPUT b_ct_comp = '' OR INPUT b_ct_nrm = '' /*OR   INPUT b_ct_prod_buffer = '' */ THEN DO:
      MESSAGE '上述参数全不能为空 ！' VIEW-AS ALERT-BOX ERROR.
      UNDO,RETRY.
   END.

   
   FIND FIRST b_ct_ctrl EXCLUSIVE-LOCK NO-ERROR.
   ASSIGN
       b_ct_nrm = INPUT b_ct_nrm
       b_ct_up_mtd = 'online'
   b_ct_comp = INPUT b_ct_comp
       /*b_ct_prod_buffer = INPUT b_ct_prod_buffer*/.
   
   
   
   
   
   END.
