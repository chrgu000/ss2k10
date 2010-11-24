/*By: Neil Gao 08/12/10 ECO: *SS 20081210* */

{mfdeclre.i}
{gplabel.i} 

define input parameter iptpart like pt_part.
define var xxcmmt1 as char format "x(76)".
define var xxcmmt2 like xxcmmt1.
define var xxcmmt3 like xxcmmt1.
define var xxcmmt4 like xxcmmt1.

form
	xxcmmt1 no-label
	xxcmmt2 no-label
	xxcmmt3 no-label
	xxcmmt4 no-label
with frame dpcmmt overlay side-labels row 16 width 80.

find first cd_det where cd_domain = global_domain and cd_ref = iptpart 
	and cd_lang = "ch" and cd_type = "SC" no-lock no-error.
if not avail cd_det then do:
	hide frame dpcmmt no-pause.
end.
else do:
	pause 0.
	disp 	cd_cmmt[1] @ xxcmmt1
				cd_cmmt[2] @ xxcmmt2
				cd_cmmt[3] @ xxcmmt3
				cd_cmmt[4] @ xxcmmt4
	with frame dpcmmt.
end.
