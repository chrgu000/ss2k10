/* $Revision: 1.23 $   BY: Apple Tam          DATE: 02/27/06 ECO: *SS-MIN001* */

      form
         header          
	 companyname        at 1 	 
	 "���:" at 113 xdnisonbr  format "x(14)"               
	 xdnname                             at 50
	 "�汾/�޶�:"  at 113 xdnisover format "x(4)"                  
         getTermLabelRtColon("DATE",6) format "x(6)" to 117
         today          skip
	 "���ϵ�: "                          at 1
	 rcvno
	 "   "
         "��������: "                        
	 prodline
	 " " 
	 wcdesc
with frame phead1 page-top width 150 no-box no-attr-space.
