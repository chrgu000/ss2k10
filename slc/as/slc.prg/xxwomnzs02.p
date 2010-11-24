/*By: Neil Gao 08/09/01 ECO: *SS 20080901* */

{mfdeclre.i}  
{gplabel.i} 

define input parameter iptpart like pt_part.
define input parameter iptsite like ld_site.
define input parameter iptline like lnd_line.
define input parameter iptdate as date.
define input parameter iptsodnbr  like sod_nbr.
define input parameter iptsodline like sod_line.
define input parameter iptqty  like ld_qty_oh.
define input parameter iptgs   like xxseq_shift1.
define input parameter iptseq  like xxseq_priority.
define variable new_priority as decimal no-undo.
define var tmpresult as char.

new_priority = 0.
find last xxseq_mstr use-index xxseq_priority where xxseq_domain = global_domain
and xxseq_site = iptsite no-lock no-error.
if avail xxseq_mstr then 	new_priority = xxseq_priority.
new_priority = new_priority + 1.
create 	xxseq_mstr. xxseq_mstr.xxseq_domain = global_domain.
assign  xxseq_priority = new_priority
				xxseq_part     = iptpart
				xxseq_site     = iptsite
				xxseq_line     = iptline
				xxseq_due_date = iptdate
				xxseq_sod_nbr  = iptsodnbr
				xxseq_sod_line = iptsodline
				xxseq_qty_req  = iptqty
				xxseq_shift1   = iptgs
				xxseq_user1 	 = "F"
				xxseq__dec02   = iptseq
				.
				
{gprun.i ""xxwopcmt05.p"" "(input recid(xxseq_mstr),input '',input (xxseq_sod_nbr + string(xxseq_sod_line,'999') + 'B'),output tmpresult)"}.
if tmpresult > "0" then message "维护半成品工单失败" view-as alert-box.

