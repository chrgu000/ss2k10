/* By: Neil Gao Date: 07/10/18 ECO: *ss 20071018 */

{mfdeclre.i} /* SHARED VARIABLE INCLUDE */


define input parameter iptrecid as recid no-undo.
define input parameter iptlot like wo_lot no-undo.
define input parameter iptnbr like wo_nbr no-undo. 
define output parameter optresult as char no-undo.

define var wosodnbr like wo_nbr.
DEFINE VARIABLE vchr_filename_in AS CHARACTER.
DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
DEFINE VARIABLE vlog_fail_flag AS LOGICAL.

vchr_filename_in = "./ssi" + mfguser.
vchr_filename_out = "./sso" + mfguser.

find first xxseq_mstr where recid(xxseq_mstr) = iptrecid no-error.
if not avail xxseq_mstr then return.

do :
    /*SS 20081005 - B*/
    /*
    wosodnbr = xxseq_sod_nbr + string(xxseq_sod_line,"999").
    */
    wosodnbr = iptnbr.
    /*SS 20081005 - E*/
    OUTPUT TO value(vchr_filename_in).
				
		PUT '~"' wosodnbr '~" ~"' iptlot '~"' SKIP.
		if iptlot = "" then do:
			PUT '~"' xxseq_part '~"	' '~"' substring(xxseq_user2,1,1) format "x(1)" '~"	' xxseq_site SKIP.
			PUT xxseq_qty_req " - " xxseq_due_date " "  xxseq_due_date 
					if xxseq_user2 = "" then  " F " else " R "
					xxseq_sod_nbr " " xxseq_line SKIP.
		end.
		else 
			PUT xxseq_qty_req " - " xxseq_due_date " " xxseq_due_date  " - "  "- " xxseq_line SKIP.
		put "." skip.
		put "-" skip.
		put "." skip.
				
		OUTPUT CLOSE.
									
		INPUT FROM VALUE(vchr_filename_in).	
		OUTPUT TO VALUE(vchr_filename_out).		
	 	
		batchrun = YES.  /* In order to	disable the "Pause" message */
		{gprun.i ""xxcimwomt.p""} 
		batchrun = NO.
		INPUT CLOSE.
		OUTPUT CLOSE.
		OS-DELETE VALUE("./ssi" + mfguser).
		OS-DELETE VALUE("./sso" + mfguser). 
		if iptlot = "" then do:
			find first wo_mstr where wo_domain = global_domain and wo_nbr = wosodnbr and wo_lot = global_addr no-error.
			if avail wo_mstr then assign xxseq_user1 = wo_status 
																 xxseq_wod_lot = wo_lot
																 wo__dec02 = xxseq_sod_line
																 wo__log01 = xxseq_type.
			else do: 
				optresult = "1".
				return.
			end.
		end.
		else do:
			find first wo_mstr where wo_domain = global_domain and wo_lot = xxseq_wod_lot and 
				wo_due_date = xxseq_due_date and wo_vend = xxseq_line	and wo_qty_ord = xxseq_qty_req no-lock no-error.
			if not avail wo_mstr then	do:
				optresult = "2".
				return.
			end.
		end.
		optresult = "0".
		
end.