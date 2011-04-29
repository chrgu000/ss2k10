/* $Revision: 1.23 $   BY: Apple Tam          DATE: 02/27/06 ECO: *SS-MIN001* */

              /*  {mfdeclre.i}*/
 {xxrevar03.i}

define variable yn like mfc_logical initial yes.
	
define variable sel_old_value like ld_qty_oh.
define shared variable global_user_lang_dir like lng_mstr.lng_dir.
define shared variable global_userid like usr_userid.
define shared variable global_domain as character.
define shared variable ecom_domain as character.

define shared variable global_usrc_right_hdr_disp like usrc_right_hdr_disp no-undo.
define variable k as integer.
define variable m as integer.


		{gplabel.i}

		
		FORM 
			xxld_line       label "项次"       space(1)
			xxld_part   	label "零件号码" format "x(18)" space(1)
			xxld_desc		label "说明"     format "x(24)" space(1)
			xxld_qty    	label "数量"  space(1)
			xxld_um      	label "单位"  space(1)
			xxld_loc      	label "发料库位"  space(1)
				with frame w 
            scroll 1
            10 down 
           /* OVERLAY */
            no-validate
            attr-space
            TITLE ""
            WIDTH 80 .

		setFrameLabels(frame w:handle).


		for each xxld_tmp:
		    delete xxld_tmp.
		end.
                m = 1.
		for each xic_det where xic_det.xic_domain = global_domain and xic_nbr = rcvno and xic_flag = no no-lock:
		    create xxld_tmp.
		    assign
		          xxld_part = xic_part
				  xxld_qty  = xic_qty_from 
				  xxld_um   = xic_um
				  xxld_line2 = xic_line
				  xxld_line = string(xic_line)
				  xxld_loc  = xic_loc_from
				  xxld_site = xic_site_from
				  xxld_lot  = xic_lot_from
				  xxld_ref  = xic_ref_from. 
			find first ld_det where ld_det.ld_domain = global_domain 
					and ld_loc  = xic_loc_from 
					and ld_part = xic_part
					and ld_lot  = xic_lot_from
					and ld_ref  = xic_ref_from
					and ld_site = xic_site_from
			no-lock no-error.
			xxld_qty_oh 	=if available ld_det then ld_qty_oh else 0 . 

			find first pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = xic_part no-lock no-error.
			if available pt_mstr then do:
				xxld_desc = pt_desc1.
				xxld_desc1 = pt_desc1 + pt_desc2.
				xxld_desc2 = pt_desc2.
			end.

			if xic_line >= m then m = xic_line + 1.
		end. /* for each xic_det*/
		   if line2 > m then do:
			  repeat k = m to line2:
			       create xxld_tmp.
			       assign xxld_line = string(k)
			              xxld_line2 = k.
			  end.
	       end.

            pause 0.
            view frame w.
            pause before-hide.
            
            find first xxld_tmp no-error.
	    if not available xxld_tmp then leave.

            do:  
               {windo1u.i
               xxld_tmp 
               "
			   xxld_line
			   xxld_part   	
			   xxld_desc	
			   xxld_qty    	    	
			   xxld_um      		
			   "
               "xxld_line"
               "use-index xxld_part" 
               yes
			   " "
			   " "
               }
            

               if keyfunction(lastkey) = "RETURN" then do:
                  find xxld_tmp
                  where recid(xxld_tmp) = recidarray[frame-line(w)].
				  /*sel_old_value = xxld_part.*/
                  /*update statement*/
                  UPDATE  
                      xxld_part	 /*validate ( input xxld_qty <= sel_old_value, "Error: Invalid selection code. Please re-enter." )*/ 		      
		      .
		  find first pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = input xxld_part no-lock no-error.
		  if available pt_mstr then do:
		     xxld_desc = pt_desc1.
		     xxld_desc2 = pt_desc2.
		     if xxld_loc = "" then assign xxld_loc = pt_loc xxld_site  = site.
		     xxld_um   = pt_um.
			find first ld_det 
					where ld_det.ld_domain = global_domain 
					and ld_part = xxld_part
					and ld_site = site /*xp001*/
					and ld_loc  = xxld_loc no-lock no-error.
			if available ld_det then do:			
				assign	xxld_loc        = ld_loc
						xxld_lot        = ld_lot
						xxld_ref        = ld_ref
						xxld_site       = site
						xxld_qty_oh = 0. 
			end.
		  end.
		  else do:
		      message "错误：该零件号不存在, 请重新输入" view-as alert-box.
		      undo,retry.
		  end.
		  display xxld_desc xxld_loc xxld_um.
		  update xxld_qty xxld_loc .
          
		  if keyfunction(lastkey) = "GO" then do:
		     undo, retry.
		  end.					  

               end.
               else 
               if keyfunction(lastkey) = "GO" then do:
                  find xxld_tmp
                  where recid(xxld_tmp) = recidarray[frame-line(w)].
                          hide frame w no-pause.
				  leave.
               end.
               {windo1u1.i xxld_line}
            
            end.
	 clear frame w all no-pause.

