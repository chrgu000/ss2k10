/* xxpptr01.i  -- 入库单列印 */
/* ss - 100623.1 by: jack */
/*
      form
         header         
	  companyname        at 30	 
	 "表号:"  at 66 xdnisonbr  format "x(14)"           
	  xdnname                         at 30
	 "版本/修订:"  at 66 xdnisover   format "x(4)"             
         getTermLabelRtColon("DATE",6) format "x(6)" to 66
         today          skip
   /*  "调出仓库:"                  at 1
	 prodline
	 " "
	 proddesc
     */
	 "调拨单号:"                at 30
	 rcvno       
          /* ss - 100623.1- b */
          "原因:"    AT 53
          v_rsn
          "方法:"   AT 74
          v_method
          /* ss - 100623.1 -e */
      with frame phead1 page-top width 95 no-box.
*/
/* ss - 100716.1 - e */
  form
         header       
      "BG-SC-09"       AT 1  
	  companyname        at 30	 
	    "日期:" AT 66
         today          skip
	  xdnname                         at 33
         "原因:"    AT 66
          v_rsn
      
       
   /*  "调出仓库:"                  at 1
	 prodline
	 " "
	 proddesc
     */
	 "单号:"                at 1
	 rcvno       
          /* ss - 100623.1- b */
       
          "方法:"   AT 66
          v_method
      /* ss - 100809.1 -b */
          "工单/ID           零件号码      描述                          数量     实退           批号/部门         备注"  AT 1
             "-------------------------------------------------------------------------------------------------------------" AT 1 
       
      /* ss - 100809.1 -e */
          /* ss - 100623.1 -e */
      with frame phead1 page-top width  110 /* 95 */ no-box.

/* ss - 100716.1 - e */
