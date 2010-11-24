/*By: Neil Gao 09/03/24 ECO: *SS 20090324* */

{mfdeclre.i}

define input parameter iptf1 like so_nbr.
define var xxrmks as char format "x(48)".
define var xxsonbr like so_nbr.

find first so_mstr where so_domain = global_domain and so_nbr = iptf1 no-error.
if not avail so_mstr then leave.
xxrmks = so__chr02.
xxsonbr = so__chr03.
form
	xxsonbr label "客户订单"
	xxrmks  label "图片位置"
with frame ff1 overlay side-labels centered row 18 width 66.

do on endkey undo,leave:
	update xxsonbr xxrmks with frame ff1.
	so__chr02 = xxrmks.
	so__chr03 = xxsonbr.
end.

hide frame ff1 no-pause.
