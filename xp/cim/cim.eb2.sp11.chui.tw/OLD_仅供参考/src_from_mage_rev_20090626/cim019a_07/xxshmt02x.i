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

/*�˴���ƥ��T��-BEGIN*/


/*�˴���ƥ��T��-END*/

/*���DETAIL���-BEGIN*/
hide frame fcdz .
*/

hide frame finv .

{xxshmt03x.i}
/*���DETAIL���-END*/

/*
leave loop-cdzdata .
end.    /*repeat loop-cdzdata*/
*/
