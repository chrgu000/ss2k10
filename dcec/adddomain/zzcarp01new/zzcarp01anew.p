/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/19/12  ECO: *SS-20120919.1*   */

	 {mfdeclre.i}

	def  shared var y# as integer.
	def  shared  var m# as integer.
	def  shared  var nbr as char.

	define variable sw_reset like mfc_logical.
	def var del-yn as logic.


form
 	yyusrw_key2 format "x(18)" label "零件号"
 	yyusrw_key4 format "x(24)" label "零件描述"
	yyusrw_decfld[1] label "数量"
/*huangjie*/ yyusrw_datefld[1]  label "日期"

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
	                  yyusrw_wkfl
	                  yyusrw_index1              
	                  yyusrw_key2
	                  "yyusrw_key2 yyusrw_key4 yyusrw_decfld[1] yyusrw_datefld[1]"
					  yyusrw_key2
					  c
					  "yyusrw_domain = global_domain and yyusrw_key1 = nbr and yyusrw_key3 = ""ORDER-TEST-DET"""				
	                  8808
	                  yes
                         yyusrw_datefld[1]
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
	/*GA32*/                create yyusrw_wkfl.
	                        yyusrw_domain = global_domain.
	                        display yyusrw_key2 yyusrw_datefld[1] with frame c.
	
	/*GA32*/                prompt-for yyusrw_key2 yyusrw_datefld[1] with frame c.
							 assign yyusrw_key2 yyusrw_datefld[1]. 

	                        display yyusrw_key2 yyusrw_datefld[1] with frame c.
	/*GA32*/                delete yyusrw_wkfl. 
	
                                
	/*GA32*/                find first yyusrw_wkfl where yyusrw_wkfl.yyusrw_domain = global_domain and yyusrw_key1 = nbr and yyusrw_key3 = "ORDER-TEST-DET" 
							and  yyusrw_key2 = input yyusrw_key2 
                                                        and  yyusrw_datefld[1]      = input yyusrw_datefld[1]  no-error.
                                   
                                   
	/*GA32*/                if available yyusrw_wkfl then do:
        /*GA32*/                   recno = recid(yyusrw_wkfl). 
                                   
	/*GA32*/                end.
	/*GA32*/                else do:
	/*GA32*/                   	create yyusrw_wkfl.
	/*GA32*/                   	assign yyusrw_domain = global_domain  yyusrw_key1  = nbr
									   yyusrw_key2		= input yyusrw_key2
                                                                           yyusrw_key3		= "ORDER-TEST-DET"
                                                                           yyusrw_datefld[1]      = input yyusrw_datefld[1].
							end.

                                    find pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = yyusrw_key2 no-lock no-error.
	  						if not available pt_mstr then do:
	  							message "零件不存在，请重新输入" view-as alert-box.
	  							next-prompt yyusrw_key2 with frame c.
	  							undo, retry.
	  						end.
	  						
	  						yyusrw_key4 = if available pt_mstr then pt_desc1 else "".
	                        display  yyusrw_key4 with frame c.  
	                           
	                          recno = recid(yyusrw_wkfl).
						end.
						
						find yyusrw_wkfl exclusive-lock where recid(yyusrw_wkfl) = recno.
						
						display yyusrw_key2 yyusrw_key4 yyusrw_decfld[1]  yyusrw_datefld[1] with frame c.
	                    
						setc:
						do on error undo, retry:
	if global-beam-me-up then undo, leave.

                                        	set yyusrw_decfld[1] 
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

								delete yyusrw_wkfl.     
								                   
								clear frame c.
								next mainloop1.
							end.
	
							
						end.					
						
					end. /*do transaction*/               
		
		    	end. /*if keyfunction(lastkey)*/
		        
			end. /*mailloop1,repeat*/            
			
			/* item maint. */
