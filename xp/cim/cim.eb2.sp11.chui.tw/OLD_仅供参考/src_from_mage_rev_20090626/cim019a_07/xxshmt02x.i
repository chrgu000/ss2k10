/*loop-cdzdata:
repeat:
update  
  xxshm_qitagang 
  xxshm_name_ch
    WITH FRAME fcdz editing:
	/*if frame-field = "xxshm_refno" then do:
		{mfnp.i po_mstr xxshm_refno po_nbr xxshm_refno po_nbr po_nbr}
		 if recno <> ? then do:
		    xxshm_refno = po_nbr.
		    display xxshm_refno with frame fcdz.
		 end.
	end.
	else */
	do:
		status input.
		readkey.
		apply lastkey.
	end.
end.

/*檢測資料正確性-BEGIN*/


/*檢測資料正確性-END*/

/*更改DETAIL資料-BEGIN*/
hide frame fcdz .
*/

hide frame finv .

{xxshmt03x.i}
/*更改DETAIL資料-END*/

/*
leave loop-cdzdata .
end.    /*repeat loop-cdzdata*/
*/
