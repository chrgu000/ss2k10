/* zzsorpreg.i*/
/* create by longbo */

		find first code_mstr no-lock
		where code_fldname = "cm_region" and code_value = cm_region no-error.
		display
			cm_region @ so_cust
			if available code_mstr then code_cmmt else "" @ cm_sort
			if available pt_mstr then pt_desc1 else "" @ idh_part
		with frame d stream-io.
		down with frame d.
