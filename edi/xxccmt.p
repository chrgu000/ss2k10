/* SS - 20110627.1 By: Apple Tam */

/* DISPLAY TITLE */
{mfdtitle.i "110627.1"}

 define variable ctr           like cc_ctr  no-undo.
 define variable ctr1          like cc_ctr  no-undo.
 define variable domain         like ad_domain  extent 6 no-undo.
 define variable i as integer.

 define buffer b_cc_mstr for cc_mstr.

/* DISPLAY SELECTION FORM */
form
	ctr			colon 15
	ctr1           	colon 40 label {t001.i} skip(1)
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
	if ctr1 = hi_char then ctr1 = "".

   view frame a.
   display
      ctr		
      ctr1    
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
         ctr		
         ctr1    
	 domain[1]
         domain[2]
	 domain[3]
	 domain[4]
	 domain[5]
	 domain[6]
      with frame a
      editing:

         if frame-field = "ctr"
         then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i cc_mstr ctr  " cc_mstr.cc_domain = global_domain and
            cc_ctr "  ctr cc_ctr cc_ctr}
         end.
         else do:
            status input.
            readkey.
            apply lastkey.
         end.
      end. /* SET */

	if ctr1 = "" then ctr1 = hi_char.

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
 


    for each cc_mstr where cc_domain = global_domain 
                       and cc_ctr >= ctr
		       and cc_ctr <= ctr1
		       no-lock:
       i = 1.
       repeat i = 1 to 6:
          if domain[i] <> "" then do:
             find first dom_mstr  no-lock where dom_domain = domain[i] no-error.      
       	     if available dom_mstr then do:                                   
                buffer-copy cc_mstr                                                 
	      	except cc_domain oid_cc_mstr 
	      	to b_cc_mstr                                                    
	      	assign                           
	               b_cc_mstr.cc_domain     = domain[i]                      
		       .

             end. /*if available dom_mstr then do:*/

	  end. /*if domain[i] <> "" then do:*/
         end. /*repeat i = 1*/
      end. /*for each ro_det where*/

      message "分发完成!".
   end. /* SETA */

end.  /*repeat with frame a:*/

status input.
