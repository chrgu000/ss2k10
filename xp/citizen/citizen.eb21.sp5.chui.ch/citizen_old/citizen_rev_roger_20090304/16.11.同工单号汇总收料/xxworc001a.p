define shared variable global_user_lang_dir like lng_mstr.lng_dir.
define shared variable global_userid like usr_userid.
define shared variable global_domain as character.
define shared variable ecom_domain as character.

define shared variable global_usrc_right_hdr_disp like usrc_right_hdr_disp no-undo.


define  shared temp-table temp
	field t_line  as char format "X(4)"
	field t_nbr    like wo_nbr 
	field t_part   like wo_part 
	field t_lot    like wo_lot 	
	field t_qty_ord  like wo_qty_ord 
	field t_qty_comp like wo_qty_comp 
	field t_qty_rjct like wo_qty_rjct
	field t_uncomp   like wo_qty_comp
	index t_line IS PRIMARY 
	t_line ascending .

define  shared frame w .

{gplabel.i}

form 
t_line       label "项次"     space(1)
t_lot   	 label "工单id"   space(1)
t_qty_ord    label "总订购量"   space(1)
t_qty_comp 	 label "累计完成量"   space(1)
t_qty_rjct   label "累计次品量"   space(1)
t_uncomp 	 label "未结量"   


with frame w 
scroll 1 4 down  no-validate attr-space
title "" width 80 .
setframelabels(frame w:handle).



find first temp no-error.
if not available temp then leave.


do:  
	{windo1u.i
	temp 
	"   t_line
		t_lot   	
		t_qty_ord	
		t_qty_comp    	    	
		t_qty_rjct
		t_uncomp
	"
	"t_line"
	"use-index t_line" 
	yes
	" "
	" "
	}


	if keyfunction(lastkey) = "RETURN" then do:
	  find temp where recid(temp) = recidarray[frame-line(w)].     


		  if keyfunction(lastkey) = "GO" then do:
			 undo, retry.
		  end.					  

	end.
	else 
	if keyfunction(lastkey) = "GO" then do:
	  leave.
	end.
	{windo1u1.i t_line}

end.