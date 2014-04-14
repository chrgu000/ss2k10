updateloop:
do transaction:
	 update tt1_qty1 with frame c.
	 /** 最大退料数量=发料量-需求量 */
	 if tt1_qty1 > tt1_qty_req then do:
	 	 message '超过最大数量' + string(tt1_qty_req).
	 	 undo,retry.
	 end.
end.