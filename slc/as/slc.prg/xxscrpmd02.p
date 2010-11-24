/*By: Neil Gao 08/12/12 ECO: *SS 20081212* */

{mfdeclre.i}
{gplabel.i} 

define input parameter iptnbr  like so_nbr.
define input parameter iptrmks like so_rmks.

find first so_mstr where so_domain = global_domain and so_nbr = iptnbr no-error.
if avail so_mstr then do:
	so_rmks = iptrmks.
end.