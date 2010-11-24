/*By: Neil Gao 08/12/10 ECO: *SS 20081210* */

{mfdeclre.i}
{gplabel.i} 

define input parameter iptbz  as char.
define input parameter iptnbr like so_nbr.
define input parameter iptyn as logical.
define input parameter iptrt as char.
define var xxentry as char.
define var i as int.
define buffer xxcffwmstr for xxcffw_mstr.


	for each xxcffw_mstr where xxcffw_key1 = "check" and xxcffw_key_nbr = iptnbr and xxcffw_nbr = iptbz :

  	assign 	xxcffw_check = true
    	     	xxcffw_ck_id = global_userid
   					xxcffw_ck_date = today.
  
   	create 	xxcffwh_hist.
    assign 	xxcffwh_key1 = xxcffw_key1
           	xxcffwh_key_nbr = xxcffw_key_nbr
       			xxcffwh_key_line = xxcffw_key_line
       			xxcffwh_nbr = xxcffw_nbr
       			xxcffwh_cf_nbr = xxcffw_cf_nbr
       			xxcffwh_ck_id = global_userid
       			xxcffwh_ck_date = today
       			xxcffwh_date = today.
	
		if iptyn then do:	
				xxentry = xxcffw_parent.
				for each xxcff_mstr where xxcff_key1 = "check" and xxcff_key_nbr = iptnbr and xxcff_nbr = iptbz 
					and xxcff_key_line = xxcffw_mstr.xxcffw_key_line:
					delete xxcff_mstr.
				end.
				do i = 1 to num-entries(xxentry) :
					find first xxcffwmstr where xxcffwmstr.xxcffw_key1 = "check" and xxcffwmstr.xxcffw_key_nbr = xxcffw_mstr.xxcffw_key_nbr 
						and xxcffwmstr.xxcffw_key_line = xxcffw_mstr.xxcffw_key_line                  
						and lookup(xxcffwmstr.xxcffw_parent,entry(i,xxentry)) > 0 and xxcffwmstr.xxcffw_check = no no-lock no-error.
					if avail xxcffwmstr then do:
						next.
					end.
					if entry(i,xxentry) <> "" then do:
						create 	xxcff_mstr .
						assign 	xxcff_key1 = "check"
										xxcff_nbr  = entry(i,xxentry)
										xxcff_key_nbr = xxcffw_mstr.xxcffw_key_nbr
										xxcff_key_line = xxcffw_mstr.xxcffw_key_line.
					end.
				end.
				if iptbz = "80" then do:
					find first sod_det where sod_domain = global_domain and sod_nbr =xxcffw_mstr.xxcffw_key_nbr
						and sod_line = xxcffw_mstr.xxcffw_key_line no-error.
					if avail sod_det then do:
						sod__log01 = yes.
						if sod_due_date < today then sod_due_date = today.
					end.
				end.
		end.
		else do:
			if iptrt = "0" then do:
				for each xxcff_mstr where xxcff_key1 = "check" and xxcff_key_nbr = xxcffw_mstr.xxcffw_key_nbr
					and xxcff_key_line = xxcffw_mstr.xxcffw_key_line :
						delete xxcff_mstr.
				end.
				for each so_mstr where so_domain = global_domain and so_nbr = iptnbr and so__log01 :
				  so__log01 = no.
				  for each sod_det where sod_domain = global_domain and sod_nbr = iptnbr no-lock:
						{gprun.i ""xxsosomtlbx01a.p"" "(input sod_nbr , input sod_line )"}
						if sod__chr03 = "" then do:
							for each xxcff_mstr where xxcff_key1 = "check" and xxcff_key_nbr = sod_nbr
								and xxcff_key_line = sod_line:
								xxcff_nbr = "20".
							end.
						end.
					end.
				end.
			end.
			else do:
				for each xxcff_mstr where xxcff_key1 = "check" and xxcff_key_nbr = iptnbr and xxcff_nbr = iptbz 
					and xxcff_key_line = xxcffw_mstr.xxcffw_key_line :
					xxcff_nbr = iptrt.
				end.
			end.
		end. /* else do: */
	end. /* for each xxcffw_mstr */
