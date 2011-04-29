/*
define var qty_need like pod_qty_ord label "本次需求".
define var qty_rst1 like pod_qty_ord label "前次多购".
define var qty_min  like pod_qty_ord label "最小订购".
define var qty_mpq  like pod_qty_ord label "订购倍数".
define var qty_ord  like pod_qty_ord label "本次开单".
define var qty_rst2 like pod_qty_ord label "本次多购".
update qty_need  qty_rst1 qty_min qty_mpq .
*/

define input parameter qty_need like pod_qty_ord .	 /*本次需求*/
define input parameter qty_rst1 like pod_qty_ord .	 /*前次多购*/
define input parameter qty_min  like pod_qty_ord .   /*最小订购*/
define input parameter qty_mpq  like pod_qty_ord .	 /*订购倍数*/
define output parameter qty_ord  like pod_qty_ord .	 /*本次开单*/
define output parameter qty_rst2 like pod_qty_ord .	 /*本次多购*/



define var i as integer .
define var qty_tmp like pod_qty_ord .



i = 0 .
qty_tmp = 0 .
qty_need = qty_need - qty_rst1 . /*本次净需求*/

if qty_need <= 0 then do :
		qty_ord = 0 .
		qty_rst2 = - qty_need .
end.
else do:
		if qty_mpq = 0 then do:
			qty_ord = qty_need .
			qty_rst2 = 0  .
		end.
		else do:
			if ( qty_need )  <= qty_mpq then do:
				i = 1 .
			end.
			else do :
				qty_tmp = ( qty_need ) mod qty_mpq .
				i = if qty_tmp > 0 then 
						 ((( qty_need ) - qty_tmp ) / qty_mpq + 1 )
					else ((( qty_need ) - qty_tmp ) / qty_mpq ) .			
			end.

			qty_ord = qty_mpq * i .
			qty_rst2 = qty_ord - qty_need   .
		end.
end.

/*下面的考虑最小订购量,上面的不考虑*/
/*
if qty_need <= 0 then do :
		qty_ord = 0 .
		qty_rst2 = - qty_need .
end.
else if qty_need <= qty_min then do :
		qty_ord  = qty_min .
		qty_rst2 =  qty_min - qty_need .
end.
else do:
		if qty_mpq = 0 then do:
			qty_ord = qty_need .
			qty_rst2 = 0  .
		end.
		else do:
			if ( qty_need - qty_min )  <= qty_mpq then do:
				i = 1 .
			end.
			else do :
				qty_tmp = ( qty_need - qty_min ) mod qty_mpq .
				i = if qty_tmp > 0 then 
						 ((( qty_need - qty_min ) - qty_tmp ) / qty_mpq + 1 )
					else ((( qty_need - qty_min ) - qty_tmp ) / qty_mpq ) .			
			end.

			qty_ord = qty_min + qty_mpq * i .
			qty_rst2 = qty_ord - qty_need   .
		end.
end.
*/

/*disp  qty_need  qty_rst1 qty_min qty_mpq qty_ord qty_rst2 with width 100 with frame x  .*/