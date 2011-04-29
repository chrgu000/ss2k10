/* xxcg01.i  -- Consignment Invoice Print */
/* REVISION: eb SP5 create 06/07/04 BY: *EAS041A2* Apple Tam */

      form
         header         skip (1)  
          title1 at 1 
	  title2 at 1 
	  title3 at 1 
	  skip(2) 
	 "C O N S I G N M E N T   I N V O I C E"        at 25 
	 skip(1)
	 loc               at 31
	 loc_line          at 31
	 "--------------------------------------------------------------------------------"
	 "TERMS:"          at 1
	 term_desc         at 7
	 "DATE:"           at 33
	 etdate
	 "INVOICE NO:"     at 50
	 pinbr#
         "PAGE:"          at 72 
         string         (page-number - pages,">>9")format "x(3)"  at 77
	 "--------------------------------------------------------------------------------"
	 skip(1)
	 "SHIP To :"    to 50    
	 ship-to[1]        at 52
	 ship-to[2]        at 52   
	 ship-to[3]        at 52   
	 ship-to[4]        at 52   
	 ship-to[5]        at 52   
	 "ATTN    :"   to 50
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
