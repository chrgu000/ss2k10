/*By: Neil Gao 08/09/16 ECO: *SS 20080916* */

{mfdtitle.i "2+ "}

define var sonbr like so_nbr init "D".
define var sonbr1 like so_nbr init "S".
define var cust like so_cust.
define var sopo like so_po.
define var sonbr2 as char format "x(40)".
define var yn as logical.

form
	skip(1)
	sonbr colon 25 label "成车订单"
	skip(1)
	sonbr1 colon 25 label "售后订单"
	skip(1)
	sonbr2 colon 25 label "关联订单"
	skip(1)
with frame a side-labels width 80 attr-space.

mainloop:
repeat:
	update sonbr with frame a.
	find first so_mstr where so_domain = global_domain and so_nbr = sonbr no-error.
	if not avail so_mstr then do:
		message "订单不存在".
		next.
	end.
	else do:
		cust = so_cust.
		
		if so_po = "" then so_po = so_nbr.
		else if so_po <> sonbr then do:
			message "订单已被" so_po "关联".
			next.
		end.
		sopo = so_po.		
		run xmpo (input sonbr, output sonbr2).
		disp sonbr2 with frame a.
	end.
	loop1:
	do on error undo,retry:
		update sonbr1 go-on (F5 CTRL-D) with frame a 
		editing:
			{mfnp05.i so_mstr so_po_nbr "so_domain = global_domain and
      so_po = sopo and so_po <> so_nbr " so_nbr sonbr1
       }
      if recno <> ? then disp so_nbr @ sonbr1 with frame a.
		end.
		
		find first so_mstr where so_domain = global_domain and so_nbr = sonbr1 no-error.
		if not avail so_mstr then do:
			message "订单不存在".
			undo,retry.
		end.
		if so_cust <> cust then do:
			message "客户不相同,不能关联".
			undo,retry.
		end.
		if so_po <> "" and so_po <> sopo then do:
			message "已经关联订单" so_po.
			undo,retry.
		end.
		
		if lastkey = keycode("CTRL-D") then do:
			yn = yes.
			message "请确认删除关联" update yn.
			if yn then 
			so_po = "".
		end.
		else do:			
			so_po = sopo.
		end.
		run xmpo (input sopo, output sonbr2).
		disp sonbr2 with frame a.
		
	end. /* loop1 */
	
end. /* mainloop */

procedure xmpo:
	define input parameter iptpo like so_po.
	define output parameter optnbr as char.
	optnbr = "".
	for each so_mstr where so_domain = global_domain and so_po = iptpo and iptpo <> so_nbr and so_cust = cust no-lock:
		if optnbr = "" then 
				optnbr = so_nbr.
		else optnbr = optnbr + "," + so_nbr.
	end.
end procedure.