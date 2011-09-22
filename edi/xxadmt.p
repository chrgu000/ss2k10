/* SS - 20110627.1 By: Apple Tam */

/* DISPLAY TITLE */
{mfdtitle.i "110627.1"}

 define variable code           like ad_addr  no-undo.
 define variable code1          like ad_addr  no-undo.
 define variable domain         like ad_domain  extent 6 no-undo.
 define variable i as integer.

 define buffer b_ad_mstr for ad_mstr.
 define buffer b_ls_mstr for ls_mstr.
 define buffer b_cm_mstr for cm_mstr.

/* DISPLAY SELECTION FORM */
form
	code			colon 15
	code1           	colon 40 label {t001.i} skip(1)
	domain[1]		colon 15 label "分发域1"
	domain[2]		colon 40 label "域2"
	domain[3]		colon 60 label "域3" skip
	domain[4]		colon 15 label "域4"
	domain[5]		colon 40 label "域5"
	domain[6]		colon 60 label "域6"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
i = 1.
	if code1 = hi_char then code1 = "".

   view frame a.
   display
      code		
      code1    
      domain[1]
      domain[2]
      domain[3]
      domain[4]
      domain[5]
      domain[6]   
   with frame a.

   seta:
   do on error undo, retry with frame a:

      set
         code		
         code1    
	 domain[1]
         domain[2]
	 domain[3]
	 domain[4]
	 domain[5]
	 domain[6]
      with frame a
      editing:

         if frame-field = "code"
         then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i ad_mstr code  " ad_mstr.ad_domain = global_domain and
            ad_addr "  code ad_addr ad_addr}
         end.
         else do:
            status input.
            readkey.
            apply lastkey.
         end.
      end. /* SET */

	if code1 = "" then code1 = hi_char.

       if domain[1] <> "" then do:
          find first dom_mstr  no-lock where dom_domain = domain[1] no-error.      
       	  if not available dom_mstr then do:                                   
       	       message "目的域不存在, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[1].                                                 
       	       undo, retry.                                                         
       	  end.         
	  if domain[1] = global_domain then do:
       	       message "不能分发到当前域, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[1].                                                 
       	       undo, retry.                                                         
	  end.
       end.
       if domain[2] <> "" then do:
          find first dom_mstr  no-lock where dom_domain = domain[2] no-error.      
       	  if not available dom_mstr then do:                                   
       	       message "目的域不存在, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[2].                                                 
       	       undo, retry.                                                         
       	  end.                                                                 
	  if domain[2] = global_domain then do:
       	       message "不能分发到当前域, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[2].                                                 
       	       undo, retry.                                                         
	  end.
       end.
       if domain[3] <> "" then do:
          find first dom_mstr  no-lock where dom_domain = domain[3] no-error.      
       	  if not available dom_mstr then do:                                   
       	       message "目的域不存在, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[3].                                                 
       	       undo, retry.                                                         
       	  end.                                                                 
	  if domain[3] = global_domain then do:
       	       message "不能分发到当前域, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[3].                                                 
       	       undo, retry.                                                         
	  end.
       end.
       if domain[4] <> "" then do:
          find first dom_mstr  no-lock where dom_domain = domain[4] no-error.      
       	  if not available dom_mstr then do:                                   
       	       message "目的域不存在, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[4].                                                 
       	       undo, retry.                                                         
       	  end.                                                                 
	  if domain[4] = global_domain then do:
       	       message "不能分发到当前域, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[4].                                                 
       	       undo, retry.                                                         
	  end.
       end.
       if domain[5] <> "" then do:
          find first dom_mstr  no-lock where dom_domain = domain[5] no-error.      
       	  if not available dom_mstr then do:                                   
       	       message "目的域不存在, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[5].                                                 
       	       undo, retry.                                                         
       	  end.                                                                 
	  if domain[5] = global_domain then do:
       	       message "不能分发到当前域, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[5].                                                 
       	       undo, retry.                                                         
	  end.
       end.
       if domain[6] <> "" then do:
          find first dom_mstr  no-lock where dom_domain = domain[6] no-error.      
       	  if not available dom_mstr then do:                                   
       	       message "目的域不存在, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[6].                                                 
       	       undo, retry.                                                         
       	  end.                                                                 
	  if domain[6] = global_domain then do:
       	       message "不能分发到当前域, 请重新输入."  view-as alert-box.        
       	       next-prompt domain[6].                                                 
       	       undo, retry.                                                         
	  end.
       end.
       if domain[1] = "" and domain[2] = "" and domain[3] = "" and domain[4] = "" 
       and domain[5] = "" and domain[6] = "" then do:
       	       message "请输入分发域."  view-as alert-box.        
       	       next-prompt domain[1].                                                 
       	       undo, retry.                                                         
       end.
 


    for each ad_mstr where ad_domain = global_domain 
                       and ad_addr >= code
		       and ad_addr <= code1
		       no-lock:
       i = 1.
       repeat i = 1 to 6:
          if domain[i] <> "" then do:
             find first dom_mstr  no-lock where dom_domain = domain[i] no-error.      
       	     if available dom_mstr then do:                                   
                buffer-copy ad_mstr                                                 
	      	except ad_domain oid_ad_mstr  
		       ad_tax_type ad_taxc ad_taxable ad_tax_in ad_userid
		       ad_mod_date ad_date ad_tax_zone ad_tax_usage
	      	to b_ad_mstr                                                    
	      	assign                           
	               b_ad_mstr.ad_domain     = domain[i]                      
	      	       b_ad_mstr.ad_mod_date   = today                          
	      	       b_ad_mstr.ad_date       = today                              
	      	       b_ad_mstr.ad_userid     = global_userid      
		       .

		 find first cm_mstr where cm_domain = global_domain and cm_addr = ad_addr no-lock no-error.
		 if available cm_mstr then do:
		     buffer-copy cm_mstr                                       
		     except cm_domain oid_cm_mstr                              
		     to b_cm_mstr                                              
		     assign                                                    
		            b_cm_mstr.cm_domain     = domain[i]      
			    .
		 end.

		 find first ls_mstr where ls_domain = global_domain and ls_addr = ad_addr no-lock no-error.
		 if available ls_mstr then do:
		     buffer-copy ls_mstr                                       
		     except ls_domain oid_ls_mstr                              
		     to b_ls_mstr                                              
		     assign                                                    
		            b_ls_mstr.ls_domain     = domain[i]      
			    .
		 end.

             end. /*if available dom_mstr then do:*/

	  end. /*if domain[i] <> "" then do:*/
         end. /*repeat i = 1*/
      end. /*for each ad_mstr where*/

      message "分发完成!".
   end. /* SETA */

end.  /*repeat with frame a:*/

status input.
