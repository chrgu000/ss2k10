/* $Revision: 1.23 $   BY: Apple Tam          DATE: 02/27/06 ECO: *SS-MIN001* */

      form
         header          
	 companyname        at 1 	 
	 "表号:" at 113 xdnisonbr  format "x(14)"               
	 xdnname                             at 50
	 "版本/修订:"  at 113 xdnisover format "x(4)"                  
         getTermLabelRtColon("DATE",6) format "x(6)" to 117
         today          skip
	 "领料单: "                          at 1
	 rcvno
	 "   "
         "工作中心: "                        
	 prodline
	 " " 
	 wcdesc
with frame phead1 page-top width 150 no-box no-attr-space.
