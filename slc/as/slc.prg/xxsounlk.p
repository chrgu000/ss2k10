/*By: Neil Gao 08/12/03 ECO: *SS 20081203* */

{mfdtitle.i "n1"}

define var sonbr like so_nbr.

form
	skip(1)
	sonbr colon 25 label "���۶���"
	skip(1)
with frame a SIDE-LABELS WIDTH 80 attr-space .
setFrameLabels(frame a:handle).
	
repeat:
	
	update sonbr with frame a.
	
	find first so_mstr where so_domain = global_domain and so_nbr = sonbr no-error.
	if not avail so_mstr then do:
		message "���۶���������".
		next.
	end.
	so__log01 = no.
	
	message "�޸ĳɹ�!".
	
end.
	
