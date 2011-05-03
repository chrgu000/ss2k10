/* SS - 091028.1 By: Neil Gao */

	{mfdeclre.i}
	{gplabel.i}
	
	define input parameter abs_recid as recid.
	define variable par_shipfrom as character.
	define variable par_id       as character.
	
	find abs_mstr where recid(abs_mstr) = abs_recid exclusive-lock.
	assign
   par_shipfrom = abs_shipfrom
   par_id       = abs_id
   .
	
	delete abs_mstr.
	
	for each abs_mstr no-lock
  	 where abs_shipfrom = par_shipfrom
     and abs_par_id = par_id:
  	{gprun.i ""xxscrspodla.p"" "(input recid(abs_mstr))"}
	end.

  /* DELETE LOGISTICS ACCOUNTING LACD_DET DETAIL RECORDS */
	for each lacd_det
  	where lacd_det.lacd_internal_ref_type = "04"
      and lacd_det.lacd_internal_ref = substring(abs_id,2)
      and lacd_shipfrom = abs_shipfrom
      exclusive-lock:

    delete lacd_det.

  end. /* FOR EACH lacd_det */

	
	