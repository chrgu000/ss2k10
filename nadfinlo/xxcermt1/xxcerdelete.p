/* Creation: eB21SP3 Chui Last Modified: 20080421 By: Davild Xu *ss-20080421.1*/
/***
xxcermt4.i ����
ͬһ�����ͬһ��Ӧ�̣����ܴ���OK/QTY/ALLOC�������͵�CER��Ч�����ص��������
	 BEGIN  �ڱ���ʱ��һ����Ҫ����б������
	{gprun.i ""xxcecheckeffdate.p""
	"(input danju,
	  input xxcer_part,
	  input xxcer_vend,
	  input xxcer_dec_result,
	  input xxcer_effdate,
	  input xxcer_expire,
	  output checkEffdateError
	)"}
	if checkEffdateError then do:
		next-prompt xxcer_effdate with frame a42 .
		undo,retry .
	end.
****/
{mfdtitle.i "dd"}

pause 0 .
def input parameter pro_xxcer_nbr	like xxcer_nbr	 .
for each xxcer_mstr where xxcer_nbr = pro_xxcer_nbr :
	delete xxcer_mstr .
end.