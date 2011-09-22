/* SS - 20110627.1 By: Apple Tam */

/* DISPLAY TITLE */
{mfdtitle.i "110627.1"}

 define variable code           like ad_addr  no-undo.
 define variable code1          like ad_addr  no-undo.
 define variable domain         like ad_domain  extent 6 no-undo.
 define variable i as integer.

 define buffer ptmstr1 for pt_mstr.
 define variable ptprodline         like pt_prod_line initial ""   no-undo.
 define variable ptadded        like pt_added no-undo.
 define variable ptstatus         like pt_status initial ""   no-undo.
 define variable ptparttype        like pt_part_type initial ""  no-undo.
 define variable ptgroup        like pt_group initial ""   no-undo.
 define new shared variable sitex            like in_site no-undo.
 define variable ptdsgngrp        like pt_dsgn_grp initial ""   no-undo.
define variable part          like pt_part label "Copy Item Number" no-undo.
define variable part1          like pt_part no-undo.

 define buffer b_pt_mstr for pt_mstr.

/* DISPLAY SELECTION FORM */
form
	part			colon 15 label "零件号码"
	part1           	colon 50 label {t001.i} 
	ptdsgngrp		colon 15 label "设计组"
	ptprodline		colon 50 label "产品类"
	ptadded  		colon 15 label "加入日期"
	ptstatus		colon 50 label "状态"
	ptparttype		colon 15 label "类型"
	ptgroup 		colon 50 label "组" skip(1)
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
	if part1 = hi_char then part1 = "".

   view frame a.
   display
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
         part				
         part1           
	 ptdsgngrp	
	 ptprodline	
	 ptadded  	
	 ptstatus	
	 ptparttype	
	 ptgroup 	
	 domain[1]
         domain[2]
	 domain[3]
	 domain[4]
	 domain[5]
	 domain[6]
      with frame a
      editing:

         if frame-field = "part"
         then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i pt_mstr part  " pt_mstr.pt_domain = global_domain and
            pt_part "  part pt_part pt_part}
         end.
         else do:
            status input.
            readkey.
            apply lastkey.
         end.
      end. /* SET */

	if part1 = "" then part1 = hi_char.

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
 


    for each pt_mstr where pt_domain = global_domain 
                       and pt_part >= part
		       and pt_part <= part1
                       and (pt_prod_line = ptprodline or ptprodline = "")  
     		       and (pt_added = ptadded or   ptadded = ?)           
     		       and (pt_status = ptstatus or ptstatus = "")         
     		       and (pt_part_type = ptparttype or ptparttype = "")  
     		       and (pt_dsgn_grp = ptdsgngrp or ptdsgngrp = "")     
     		       and (pt_group = ptgroup or ptgroup = "")          
		       no-lock:
       i = 1.
       repeat i = 1 to 6:
          if domain[i] <> "" then do:
             find first dom_mstr  no-lock where dom_domain = domain[i] no-error.      
       	     if available dom_mstr then do:                                   
                buffer-copy pt_mstr       
		except pt_abc_amt pt_abc_qty pt_domain oid_pt_mstr      
	      	       pt_added pt_last_eco pt_userid pt_mod_date pt_cur_date   
		       pt_taxc pt_taxable pt_std_date pt_joint_type pt_ecn_rev  
		       pt_ll_code                                        
		to b_pt_mstr                                                    
		assign                           
		       b_pt_mstr.pt_domain     = domain[i]                       
		       b_pt_mstr.pt_added      = today                          
		       b_pt_mstr.pt_last_eco   = ?                              
		       b_pt_mstr.pt_userid     = global_userid                  
		       b_pt_mstr.pt_mod_date   = today                          
		       b_pt_mstr.pt_cur_date   = today                          
		       b_pt_mstr.pt_std_date   = today                          
		       b_pt_mstr.pt_joint_type = ""                             
		       b_pt_mstr.pt_ecn_rev    = ""                             
		       b_pt_mstr.pt_ll_code    = 0  
		       .
             end. /*if available dom_mstr then do:*/

	  end. /*if domain[i] <> "" then do:*/
         end. /*repeat i = 1*/
      end. /*for each ad_mstr where*/

      message "分发完成!".
   end. /* SETA */

end.  /*repeat with frame a:*/

status input.
