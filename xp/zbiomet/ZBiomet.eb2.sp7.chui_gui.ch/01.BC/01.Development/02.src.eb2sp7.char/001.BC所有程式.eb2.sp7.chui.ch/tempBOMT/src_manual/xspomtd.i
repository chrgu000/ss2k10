/*
xspomtd.i 
1. called by xspor02.p 
2.当执行完cimload时调用,删除收货的临时记录,
3.其他情况不调用,
*/

/* REVISION: 1.0         Last Modified: 2008/11/08   By: Roger             */
/*-Revision end------------------------------------------------------------*/

for each usrw_wkfl where usrw_key1 = V1105 :
  delete usrw_wkfl.
end.
  release usrw_wkfl.
