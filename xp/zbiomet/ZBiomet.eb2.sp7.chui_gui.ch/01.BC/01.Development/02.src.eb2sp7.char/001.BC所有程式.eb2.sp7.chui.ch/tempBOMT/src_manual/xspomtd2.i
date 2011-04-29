/*
xspomtd2.i 
1. called by xspor02.p 
2.当第一次登陆程式时,或变更采购送检单时,删除已经输入的待收货的临时记录,
3.其他情况不删除临时记录,
*/
/* REVISION: 1.0         Last Modified: 2008/11/08   By: Roger             */
/*-Revision end------------------------------------------------------------*/

for each usrw_wkfl where usrw_key1 begins mfguser  :
  if ( usrw_key1 <> v1105 ) or sectionid = 1 then  delete usrw_wkfl.
end.
  release usrw_wkfl.
