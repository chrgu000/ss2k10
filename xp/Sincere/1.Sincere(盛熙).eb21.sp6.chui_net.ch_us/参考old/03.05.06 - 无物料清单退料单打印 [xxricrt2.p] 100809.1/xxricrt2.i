/* xxpptr01.i  -- ��ⵥ��ӡ */
/* ss - 100623.1 by: jack */
/*
      form
         header         
	  companyname        at 30	 
	 "���:"  at 66 xdnisonbr  format "x(14)"           
	  xdnname                         at 30
	 "�汾/�޶�:"  at 66 xdnisover   format "x(4)"             
         getTermLabelRtColon("DATE",6) format "x(6)" to 66
         today          skip
   /*  "�����ֿ�:"                  at 1
	 prodline
	 " "
	 proddesc
     */
	 "��������:"                at 30
	 rcvno       
          /* ss - 100623.1- b */
          "ԭ��:"    AT 53
          v_rsn
          "����:"   AT 74
          v_method
          /* ss - 100623.1 -e */
      with frame phead1 page-top width 95 no-box.
*/
/* ss - 100716.1 - e */
  form
         header       
      "BG-SC-09"       AT 1  
	  companyname        at 30	 
	    "����:" AT 66
         today          skip
	  xdnname                         at 33
         "ԭ��:"    AT 66
          v_rsn
      
       
   /*  "�����ֿ�:"                  at 1
	 prodline
	 " "
	 proddesc
     */
	 "����:"                at 1
	 rcvno       
          /* ss - 100623.1- b */
       
          "����:"   AT 66
          v_method
      /* ss - 100809.1 -b */
          "����/ID           �������      ����                          ����     ʵ��           ����/����         ��ע"  AT 1
             "-------------------------------------------------------------------------------------------------------------" AT 1 
       
      /* ss - 100809.1 -e */
          /* ss - 100623.1 -e */
      with frame phead1 page-top width  110 /* 95 */ no-box.

/* ss - 100716.1 - e */
