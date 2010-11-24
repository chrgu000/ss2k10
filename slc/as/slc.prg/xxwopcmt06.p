/* By: Neil Gao Date: 07/10/18 ECO: *ss 20071018 */

{mfdeclre.i} /* SHARED VARIABLE INCLUDE */

define input parameter iptpriority  like xxseq_priority.
define input parameter iptpart   	like xxseq_part.
define input parameter iptsite  		like xxseq_site.
define input parameter iptline 			like xxseq_line.
define input parameter iptduedate		like xxseq_due_date.
define input parameter iptsodnbr 		like xxseq_sod_nbr.
define input parameter iptsodline		like xxseq_sod_line.
define input parameter iptqtyreq    like xxseq_qty_req.
define input parameter iptshift1		like xxseq_shift1.
define output parameter optrecid 		as recid init ?.
define var new_priority like xxseq_priority.

if iptpriority = 0 then do:
		new_priority = 0.
		find last xxseq_mstr use-index xxseq_priority where xxseq_domain = global_domain
			and xxseq_site = iptsite no-lock no-error.
		if avail xxseq_mstr then 
			new_priority = xxseq_priority.
		new_priority = new_priority + 1.
              
             if tmpqty <= 0 then next.
		create xxseq_mstr. xxseq_mstr.xxseq_domain = global_domain.
    assign  xxseq_priority = new_priority xxseq_site = iptsite xxseq_type = yes.
end.
else do:
		find first xxseq_mstr where xxseq_site = iptsite and xxseq_priority = iptpriority no-error.
end.    		
		assign	xxseq_part     = iptpart
            xxseq_line     = iptline
            xxseq_due_date = iptduedate
            xxseq_sod_nbr  = iptsodnbr
            xxseq_sod_line = iptsodline
    				xxseq_qty_req  = iptqtyreq
    				xxseq_shift1   = iptshift1.
    				
optrecid = recid(xxseq_mstr).
    				