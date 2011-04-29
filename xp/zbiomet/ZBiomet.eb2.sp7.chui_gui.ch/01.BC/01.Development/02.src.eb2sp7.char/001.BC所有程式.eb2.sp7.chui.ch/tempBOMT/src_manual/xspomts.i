/*
xspomts.i 

1.called by xspor02.p 
2.记录已输入待执行收货的项次
3.各字段含义:
  usrw_key1          = V1105   = Sesstion ID	= mfguser + 送检单号	    
  usrw_key2          = V1205   = PO LINE		        
  usrw_charfld[1]    = V1300   = Item NO		        
  usrw_charfld[2]    = V1400   = Location		    
  usrw_charfld[3]    = V1600   = Rec Qty PO UM       
  usrw_charfld[4]    = V1410   = LOT Control		    
  usrw_charfld[5]    = V1302   = Subcontract WO ID	
  usrw_charfld[6]    = V1303   = Subcontract OP	    
  usrw_charfld[7]    = V1610   = Rec Qty INV UM      
  usrw_charfld[8]    = V1500   = lot      

*/
/* REVISION: 1.0         Last Modified: 2008/11/08   By: Roger             */
/*-Revision end------------------------------------------------------------*/


find first usrw_wkfl where usrw_key1 = V1105  and usrw_key2 = V1205 no-error .
if not available usrw_wkfl then do:
   create usrw_wkfl .
   assign  usrw_key1 = V1105
            usrw_key2 = V1205
            usrw_charfld[1] = V1300 
            usrw_charfld[2] = V1400
            usrw_charfld[3] = V1600
            usrw_charfld[4] = V1410
            usrw_charfld[5] = V1302
            usrw_charfld[6] = V1303
            usrw_charfld[7] = V1610
            usrw_charfld[8] = V1500.

end.
else do:
            usrw_charfld[1] = V1300 .
            usrw_charfld[2] = V1400.
            usrw_charfld[3] = V1600.
            usrw_charfld[4] = V1410.
            usrw_charfld[5] = V1302.
            usrw_charfld[6] = V1303.
            usrw_charfld[7] = V1610.
            usrw_charfld[8] = V1500.


end.