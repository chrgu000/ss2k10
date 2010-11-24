define shared variable global_user_lang_dir like lng_mstr.lng_dir.
define shared variable global_userid like usr_userid.
define shared variable global_domain like usr_userid.
DEFINE VARIABLE update-yn as logi .
DEFINE VARIABLE tt_line like sod_Line .
DEFINE VARIABLE tt_sod_qty_ship like sod_qty_ship .
DEFINE VARIABLE oldtmp_ok_Iss like sod_qty_ship .

{xxautowois.i " "}

 
{gplabel.i }

form
   tmp_ii		column-label "S" format "x(1)"
   tmp_part		column-label "料号"
   tmp_loc		column-label "库位"
   tmp_lot		column-label "批号"
   /*tmp_ref		column-label "参考"*/
   tmp_qty_iss		column-label "已发量" 
   tmp_ok_iss		column-label "可退货"
    
with frame w scroll 
            6 down 
            no-validate
            no-attr-space
            TITLE ""
            WIDTH 80 
	    .
	    pause 0.
            view frame w.
            pause before-hide.  



	    {windo1u.i
               tmp_mstr
               " tmp_ii	
	         tmp_part
                 tmp_loc		
		 tmp_lot		
		 		
		 tmp_qty_iss		
		 tmp_ok_iss		 
		 	
        	 "
               "tmp_ii"
               "use-index tmpii" 
               yes
			   " "
			   " "
			    
               }

 	
		/*if keyfunction(lastkey) = "return" and recno <> ?
			then do transaction on error undo, retry:*/
		IF keyfunction(lastkey) = "RETURN" then do:
                  find tmp_mstr
                  where recid(tmp_mstr) = recidarray[frame-line(w)].
		  
		  /*if tmp_ii = "*" then assign tmp_ii = "" .
		  else
		  if tmp_ii = "" then assign tmp_ii = "*" .
		  disp tmp_ii with frame w .*/

		  oldtmp_ok_Iss = tmp_ok_Iss .
		  do on error undo,retry:
		    
		    update tmp_ok_iss with frame w .
		       if tmp_ok_iss > tmp_qty_iss or tmp_ok_Iss < 0 then do:
			message " 不能超过已发料数  " + string(tmp_qty_iss) .
			undo,retry .  
		       end.
		       
		  end.
		  if tmp_ok_iss > 0 then assign tmp_ii = "*" .
		  else assign tmp_ii = "" .
		  display tmp_ii with frame w .
		end.


		{windo1u1.i tmp_ii}

		clear frame w all no-pause.
		hide frame w  .
		
		for each tmp_mstr :
			tmp_ok_iss = - tmp_ok_iss.
		end.
		
		update-yn = no.
    message "是否确认退货" update update-yn.
    if update-yn = yes then do: 
		
			for each tmp_mstr where tmp_ii = "*" and tmp_ok_iss <> 0 no-lock:
							
							{xxddautowois.i
							 tmp_wolot
							 string(tmp_ok_iss)
							 tmp_site
							 tmp_loc
							 tmp_lot
							 tmp_ref
							 tmp_part
							 string(tmp_op)
							}

			end.
		end.
		else do:
			return.
		end.