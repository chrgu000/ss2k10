/* xxshad01.i  -- Shipping Advice Print */
/* REVISION: eb SP5 create 03/21/04 BY: *EAS037A* Apple Tam */

      form
         header         skip (3)  
	 "S H I P P I N G  A D V I C E"        at 28 
	 skip(1)
	 loc               at 33
	 loc_line          at 33
	 "SHIPPER     : EASTAR (HK) LTD."    at 2
         "S/A NO.:"        to 65
         nbr               at 67
	 skip(1)
	 "CONSIGNEE   :"   at 2
	 sold-to[1]        at 16
	 "DATE:"           to 65
	 etdate            at 67
	 sold-to[2]        at 16
	 sold-to[3]        at 16
         "PAGE:"           to 65
         string         (page-number - pages,">9")format "x(2)" at 67
	 sold-to[4]        at 16
	 sold-to[5]        at 16
	 skip(2)
	 "NOTIFY PARTY:"   at 2
	 ship-to[1]        at 16
	 ship-to[2]        at 16
	 ship-to[3]        at 16
	 ship-to[4]        at 16
	 ship-to[5]        at 16
	 consig            at 33
	 consig_line       at 33
	 skip(1)
	 "(THIS SHIPMENT CONTAINS NO SOLID WOOD PACKING MATERIALS)" at 12
	 skip(1)
      with frame phead2 page-top width 90.
