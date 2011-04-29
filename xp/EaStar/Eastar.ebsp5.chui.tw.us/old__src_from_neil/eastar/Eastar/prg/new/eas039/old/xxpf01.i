/* xxpf01.i  -- Proforma Invoice Print */
/* REVISION: eb SP5 create 06/02/04 BY: *EAS039A4* Apple Tam */

      form
         header         skip (1)  
          title1 at 1 
	  title2 at 1 
	  title3 at 1 
	  skip(2) 
	 "P R O F O R M A   I N V O I C E"        at 25 
	 skip(1)
	 loc               at 31
	 loc_line          at 31
	 "--------------------------------------------------------------------------------"
/*	 term_desc         at 1*/
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
	 "SHIP To :"   at 42    
	 ship-to[1]        at 52
	 bill-to[2]        at 11	   ship-to[2]        at 52   
	 bill-to[3]        at 11	   ship-to[3]        at 52   
	 bill-to[4]        at 11	   ship-to[4]        at 52   
	 bill-to[5]        at 11	   ship-to[5]        at 52   
         "ATTN    :" at 1                  
	 bill-attn        at 11
	 "ATTN    :"   at 42
	 ship-attn     at 52
	 skip(1)
	 consig            at 31
	 consig_line       at 31
	 skip(1)
	 "(THIS SHIPMENT CONTAINS NO SOLID WOOD PACKING MATERIALS)" at 12
	 skip(1)
	 "PART NO"     at  14
	 "CUSTOMER PO  DESCRIPTION                     QTY U/M "  at 1
	 "U/PRICE(" at 54
	 curr1 at 62
	 ")" at 65
	 "AMOUNT(" at 68
	 curr2 at 75
	 ")"  at 78
	 "------------ ------------------ ---------------- --- ------------ ------------"  at 1	
      with frame phead1 page-top width 90.
