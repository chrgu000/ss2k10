output to value("/home/mfg/micho/xxdtbrp1.txt") .
def var i as integer .
DEF VAR v_by AS CHAR.

DEF TEMP-TABLE tt
   FIELD tt_by AS CHAR
   FIELD tt_value LIKE CODE_value
   FIELD tt_cmmt LIKE CODE_cmmt
   . 

EMPTY TEMP-TABLE tt.
FOR EACH CODE_mstr WHERE CODE_fldname = "pt_promo" :

   CREATE tt .
   ASSIGN
      tt_by = code_user1
      tt_value = CODE_value
      tt_cmmt = CODE_cmmt
      .
END.

/* ��1��Ϊ��������Ϣ */
put unformatted "��ͷ" ";" "��ӡʱ��" ";" "ʱ��" ";" "��Ʊ����" ";"
"����" ";" "̨���ܼ�" ";" "�޸İ汾" ";" . 
for each tt BY tt_by BY tt_value :
   PUT UNFORMATTED tt_cmmt ";" .
end.
put unformatted "��Ʊ�ϼ�" ";" "QCȷ��" skip.

/* ��2��Ϊ������ */
put unformatted "�ͻ���̬�����" ";" "��ӡʱ��: 2008-08-06 10:12:49" ";"
"08:00" ";" "08-06 21:00" ";" "100" ";" "10" ";" "����һ" ";" .

i = 0.
for each tt BY tt_by BY tt_value :
i = i + 1 .
put unformatted i ";" .
end.
put unformatted "20" ";" "" skip.

/* ��3��Ϊ������ */
put unformatted "�ͻ���̬�����" ";" "��ӡʱ��: 2008-08-06 10:12:49" ";"
"08:00" ";" "08-06 21:00" ";" "100" ";" "10" ";" "������" ";" .

i = 0.
for each tt BY tt_by BY tt_value :
i = i + 1 .
put unformatted i ";" .
end.
put unformatted "20" ";" "" skip.


/* ��4��Ϊ������ */
put unformatted "�ͻ���̬�����" ";" "��ӡʱ��: 2008-08-06 10:12:49" ";"
"08:00" ";" "08-06 21:00" ";" "100" ";" "10" ";" "������" ";" .

i = 0.
for each tt BY tt_by BY tt_value :
i = i + 1 .
put unformatted i ";" .
end.
put unformatted "20" ";" "" skip.


output close .

