/*
xspomtd2.i 
1. called by xspor02.p 
2.����һ�ε�½��ʽʱ,�����ɹ��ͼ쵥ʱ,ɾ���Ѿ�����Ĵ��ջ�����ʱ��¼,
3.���������ɾ����ʱ��¼,
*/
/* REVISION: 1.0         Last Modified: 2008/11/08   By: Roger             */
/*-Revision end------------------------------------------------------------*/

for each usrw_wkfl where usrw_key1 begins mfguser  :
  if ( usrw_key1 <> v1105 ) or sectionid = 1 then  delete usrw_wkfl.
end.
  release usrw_wkfl.
