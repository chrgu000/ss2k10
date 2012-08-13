
	 {mfdeclre.i}

	def  shared var y# as integer.
	def  shared  var m# as integer.
	def  shared  var nbr as char.

	define variable sw_reset like mfc_logical.
	def var del-yn as logic.


form
 	usrw_key2 format "x(18)" label "零件号"
 	usrw_key4 format "x(24)" label "零件描述"
	usrw_decfld[1] label "数量"
	with /*down*/ frame c width 80 /*overlay*/ title color normal "合同评审量" THREE-D /*GUI*/.         


			/* item maint.*/
			sw_reset = yes.   
			mainloop1:   
	        repeat:
	/*/*GUI*/ if global-beam-me-up then undo, leave.*/                  /*eyes*/
	
	/*FIND LAST BOM USE-INDEX BOMINDEX. ASSIGN BOM.OPTYPE = "DEL".*/
	/*F0PV*/    if not batchrun then do:
	
	               /* {1} = File-name (eg pt_mstr)                    */
	               /* {2} = Index to use (eg pt_part)                 */
	               /* {3} = Field to select records by (eg pt_part)   */
	               /* {4} = Field(s) to display from primary file     */
	               /* {5} = Field to highlight (eg pt_part)           */
	               /* {6} = Frame name                                */
	               /* {7} = Selection Criterion                       */
	               /* {8} = Message number for the status line        */
	/*G1DT*/       /* {9} = Exclusive lock needed (Y/N)            */
	
	               {zzmpscrad81.i
	                  usrw_wkfl
	                  usrw_index1              
	                  usrw_key2
	                  "usrw_key2 usrw_key4 usrw_decfld[1]"
					  usrw_key2
					  c
					  "usrw_key1 = nbr and usrw_key3 = ""ORDER-TEST-DET"""				
	                  8808
	                  yes
	               }
	
	/*F0PV*/    end.    /* if not batchrun then do */
	             
				if keyfunction(lastkey) = "end-error"
				or lastkey = keycode("F4")
				or keyfunction(lastkey) = "."
				or lastkey = keycode("CTRL-E") then do:
	            	leave.
	            end. /*if keyfunction*/
	             
	             
				if recno = ?
				and keyfunction(lastkey) <> "insert-mode"
				and keyfunction(lastkey) <> "go"
				and keyfunction(lastkey) <> "return"
				then leave.
				
				if yes /*keyfunction(lastkey) <> "end-error"*/
				then do on error undo, retry:
					do :
	/*/*GUI*/ if global-beam-me-up then undo, leave.*/               /*eyes*/
	
	/*GA32*/             if recno = ? then do:
	/*GA32*/                create usrw_wkfl.
	
	                        display usrw_key2 with frame c.
	
	/*GA32*/                prompt-for usrw_key2 with frame c.
							assign usrw_key2.

	                        display usrw_key2 with frame c.
	/*GA32*/                delete usrw_wkfl.
	
	/*GA32*/                find first usrw_wkfl where usrw_key1 = nbr and usrw_key3 = "ORDER-TEST-DET" 
							and	 usrw_key2 = input usrw_key2 no-lock no-error.
	/*GA32*/                if available usrw_wkfl then do:
	/*GA32*/                   recno = recid(usrw_wkfl).
	/*GA32*/                end.
	/*GA32*/                else do:
	/*GA32*/                   	create usrw_wkfl.
	/*GA32*/                   	assign usrw_key1  = nbr
									   usrw_key2		= input usrw_key2
									   usrw_key3		=  "ORDER-TEST-DET".
							end.
	 						find pt_mstr where pt_part = usrw_key2 no-lock no-error.
	  						if not available pt_mstr then do:
	  							message "零件不存在，请重新输入" view-as alert-box.
	  							next-prompt usrw_key2 with frame c.
	  							undo, retry.
	  						end.
	  						
	  						usrw_key4 = if available pt_mstr then pt_desc1 else "".
	                        display  usrw_key4 with frame c.  
	                           
	                        recno = recid(usrw_wkfl).
						end.
						
						find usrw_wkfl exclusive-lock where recid(usrw_wkfl) = recno.
						
						display usrw_key2 usrw_key4 usrw_decfld[1] with frame c.
	                    
						setc:
						do on error undo, retry:
	if global-beam-me-up then undo, leave.
							set usrw_decfld[1]
							with frame c editing:
	                     
			                    ststatus = stline[2].
			                    status input ststatus.
			                    readkey.
		                        /* DELETE */
		                        del-yn = no.
		                        if lastkey = keycode("F5")
		                        or lastkey = keycode("CTRL-D")
		                        then do:
		                           del-yn = yes.
		                           {mfmsg01.i 11 1 del-yn}
		                           if del-yn then do:
		                              /*delete tr.*/
		                              leave.                              
		                           end.
		                        end.
		                        else do:
		                           apply lastkey.
		                        end.                
		                    end. /* editing */
	
							if del-yn then do:          

								delete usrw_wkfl.     
								                   
								clear frame c.
								next mainloop1.
							end.
	
							
						end.					
						
					end. /*do transaction*/               
		
		    	end. /*if keyfunction(lastkey)*/
		        
			end. /*mailloop1,repeat*/            
			
			/* item maint. */
