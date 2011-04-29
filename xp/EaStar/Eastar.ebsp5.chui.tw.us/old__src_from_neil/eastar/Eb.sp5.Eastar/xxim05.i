/* xxcg05.i  -- Consignment Invoice Print */
/* REVISION: eb SP5 create 06/07/04 BY: *EAS041A2* Apple Tam */

      form
         header         skip (1)  
	 "I N V O I C E"        at 35 
	 skip(1)
	 "--------------------------------------------------------------------------------"
/*	 "TERMS:"          at 1
	 term_desc         at 7*/
	 "DATE:"           at 33
	 etdate
	 "INVOICE NO:"     at 50
	 pinbr#
         "PAGE:"          at 72 
         string         (page-number - pages,">>9")format "x(3)"  at 77
	 "--------------------------------------------------------------------------------"
	 skip(1)
	 "BILL To :"   at 1                   
	 bill-to[1]        at 11
	 "SHIP To :"   to 50    
	 ship-to[1]        at 52
	 bill-to[2]        at 11	   ship-to[2]        at 52   
	 bill-to[3]        at 11	   ship-to[3]        at 52   
	 bill-to[4]        at 11	   ship-to[4]        at 52   
	 bill-to[5]        at 11	   ship-to[5]        at 52   
         "ATTN    :" at 1                  
	 bill-attn        at 11
	 "ATTN    :"   to 50
	 ship-attn     at 52
	 skip(2)
	 "PART NO"     at  14
/*	 "CUSTOMER PO  DESCRIPTION                     QTY U/M "  at 1
	 "U/PRICE(" at 54
	 curr1 at 62
	 ")" at 65
	 "AMOUNT(" at 68
	 curr2 at 75
	 ")"  at 78
	 "------------ ------------------ ---------------- --- ------------ ------------"  at 1	*/
	 "CUSTOMER PO  DESCRIPTION                      QTY U/M "  at 1
	 "U/PRICE(" at 55
	 curr1 at 63
	 ")" at 66
	 "AMOUNT(" at 69
	 curr2 at 77
	 ")"  at 80
	 "------------ ------------------ ----------------- --- ------------ -------------"  at 1	
      with frame phead2 page-top width 90.
