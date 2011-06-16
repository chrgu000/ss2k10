/* xxinpt01.p - ������ͨ�ô��뵼��                      */
/* Revision: eb2sp4	BY: Micho Yang         DATE: 08/05/08  ECO: *SS - 20080805.1* */

/* SS - 20080805.1 - B */
/* 
1. ��Ҫ���ڵ������۲��Ŷ�������������
2. ÿ�����µ���ʱ����ɾ��ϵͳ�Ѿ����ڵļ�¼��
   Ȼ���ٵ��뵽code_mstr 
   code_fldname = "xxdtbrp1.p"
   code_value = ��1������                                                                          
   code_cmmt = ��2������
   */
/* SS - 20080805.1 - E */

{mfdtitle.i "C+ "}

define variable file_name  as character format "x(40)" .
DEFINE VARIABLE UPDATE_yn AS LOGICAL INIT NO .

DEF TEMP-TABLE tt
   FIELD tt_cust LIKE CODE_user1 
   FIELD tt_value LIKE CODE_value 
   FIELD tt_cmmt LIKE CODE_cmmt
   
   .

form 
   skip(1)
   file_name colon 30 label "�����ļ���·��������"
   SKIP(2)
   UPDATE_yn COLON 30 LABEL "�Ƿ�ȷ�ϵ�������"
   skip(1)
with frame a side-label width 80 .

setFrameLabels(frame a:handle).
     
main:
repeat :

   update file_name UPDATE_yn with frame a.
   
   if search(file_name) = ? then do:
      message "�ļ�������" .
      next.
   end.   
   
   {mfselprt.i "printer" 120}
   
   input from value(file_name).
   
   REPEAT:
      CREATE tt .
      IMPORT DELIMITER "~011" tt .
   end.
   input close.
   
   IF UPDATE_yn = NO THEN DO:
      FOR EACH tt WITH FRAME b:
         DISP 
            tt_cust COLUMN-LABEL "����"
            tt_value COLUMN-LABEL "������"
            tt_cmmt COLUMN-LABEL "˵��"
            .
      END.
   END.
   ELSE DO:
      FOR EACH tt :
         FIND FIRST CODE_mstr WHERE CODE_fldname = "pt_promo"
            AND CODE_value = tt_value NO-LOCK NO-ERROR.
         IF NOT AVAIL CODE_mstr THEN DO:
            CREATE CODE_mstr.
            ASSIGN
               CODE_fldname = 'pt_promo'
               CODE_value = tt_value 
               CODE_cmmt = tt_cmmt
               CODE_user1 = tt_cust
               .
         END.
      END.

      PUT UNFORMATTED "�����ѳɹ�����" .
   END.
      
   {mfreset.i} 
   {mfgrptrm.i}
end.
