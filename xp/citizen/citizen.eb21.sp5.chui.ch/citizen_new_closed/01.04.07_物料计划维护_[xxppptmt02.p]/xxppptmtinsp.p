/* $CREATED BY: softspeed Roger Xiao         DATE: 2007/11/27  ECO: *xp001*  */

{mfdtitle.i}
define input parameter v_part like pt_part .
define input parameter v_site like ptp_site .
define input parameter v_insp_rqd like pt_insp_rqd .

define var v_loc like pt_loc .




if v_insp_rqd = yes then do:
	find first poc_ctrl where poc_domain = global_domain  no-lock no-error .
	if avail poc_ctrl then v_loc = poc_insp_loc .
	else do:
		find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error .
		v_loc = if avail pt_mstr then pt_loc else "" .
	end.
end.
else do:
	find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error .
	v_loc = if avail pt_mstr then pt_loc else "" .
end.

/*********************/

if v_site = "" then do:
	for each rqd_det 
			fields( rqd_domain  rqd_part rqd_open  rqd_insp_rqd rqd_loc )
			use-index rqd_part			
			where rqd_domain = global_domain 
			and rqd_part = v_part 
			and rqd_open exclusive-lock :
			assign rqd_insp_rqd = v_insp_rqd 
				   rqd_loc = v_loc .
	end.

	for each pod_det 
			fields (pod_domain  pod_site  pod_part  pod_stat  pod_insp_rqd pod_loc )
			use-index   pod_part 
	        where pod_domain = global_domain 
			and pod_part = v_part 
			and pod_stat = "" exclusive-lock :
			assign pod_insp_rqd = v_insp_rqd 
				   pod_loc = v_loc .
	end.
end. /*if v_site = "" */
else do:  /*if v_site <> "" */
	for each rqd_det 			
			fields( rqd_domain  rqd_part rqd_open  rqd_site  rqd_insp_rqd rqd_loc )
			use-index rqd_part
			where rqd_domain = global_domain 
			and rqd_part = v_part 
			and rqd_site = v_site
			and rqd_open exclusive-lock :
			assign rqd_insp_rqd = v_insp_rqd 
				   rqd_loc = v_loc .
	end.

	for each pod_det			  
			fields (pod_domain  pod_site  pod_part  pod_stat  pod_insp_rqd pod_loc )
			use-index   pod_part 
			where pod_domain = global_domain 			
			and pod_part = v_part
			and pod_site = v_site
			and pod_stat = "" exclusive-lock :
			assign pod_insp_rqd = v_insp_rqd 
				   pod_loc = v_loc .
	end.
end. /*if v_site <> "" */