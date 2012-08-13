/* zzsorpreg2.i*/
/* create by longbo */

		find first code_mstr no-lock
		where code_fldname = "cm_region" and code_value = cm_region no-error.
		display
			cm_region @ itemcode
			if available code_mstr then code_cmmt else "" @ itemdesc
		with frame {1} stream-io.
		down with frame {1}.
