updateloop:
do transaction:
	 update tt1_qty1 with frame c.
	 /** �����������=������-������ */
	 if tt1_qty1 > tt1_qty_req then do:
	 	 message '�����������' + string(tt1_qty_req).
	 	 undo,retry.
	 end.
	 if tt1_qty1 <= 0 then do:
	    message '�����������0'.
	 	  undo,retry.
	 end.
end.