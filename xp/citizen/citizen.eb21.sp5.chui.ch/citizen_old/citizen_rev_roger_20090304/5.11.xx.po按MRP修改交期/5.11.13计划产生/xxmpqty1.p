/*
define var qty_need like pod_qty_ord label "��������".
define var qty_rst1 like pod_qty_ord label "ǰ�ζ๺".
define var qty_min  like pod_qty_ord label "��С����".
define var qty_mpq  like pod_qty_ord label "��������".
define var qty_ord  like pod_qty_ord label "���ο���".
define var qty_rst2 like pod_qty_ord label "���ζ๺".
update qty_need  qty_rst1 qty_min qty_mpq .
*/

define input parameter qty_need like pod_qty_ord .	 /*��������*/
define input parameter qty_rst1 like pod_qty_ord .	 /*ǰ�ζ๺*/
define input parameter qty_min  like pod_qty_ord .   /*��С����*/
define input parameter qty_mpq  like pod_qty_ord .	 /*��������*/
define output parameter qty_ord  like pod_qty_ord .	 /*���ο���*/
define output parameter qty_rst2 like pod_qty_ord .	 /*���ζ๺*/



define var i as integer .
define var qty_tmp like pod_qty_ord .



i = 0 .
qty_tmp = 0 .
qty_need = qty_need - qty_rst1 . /*���ξ�����*/

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

/*����Ŀ�����С������,����Ĳ�����*/
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