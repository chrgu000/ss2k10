/* �ҳ���Щ��ͨ�ô���pt_promo�в����ڵ���������� */
for each pt_mstr where pt_promo <> "" :
find first code_mstr 
where code_fldname = 'pt_promo'
and code_value = pt_promo no-lock no-error.
if not avail code_mstr then do:
   disp pt_part pt_promo.
end.
end.

/* ������ά��������,Ȼ��ȥ����Щ�������������. */
output to value("/home/mfg/micho/pt_promo1.txt").
put unformatted "���ֺ�" ";" "˵��" skip.
for each pt_mstr where pt_promo <> "",
each code_mstr where code_fldname = 'pt_promo'
and code_value = pt_promo 
break by pt_promo :
if last-of(pt_promo) then do:
   export delimiter ";" pt_promo code_cmmt .	
end.
end.
output close .

output to value("/home/mfg/micho/pt_promo.txt").
put UNFORMATTED "����" ";" "���ֺ�" ";" "˵��" skip.
FOR EACH code_mstr where code_fldname = 'pt_promo':
export delimiter ";" code_user1 code_value code_cmmt.
end.
output close .


/* ���г�ʼ��,���ó���xxinpt01.p */
