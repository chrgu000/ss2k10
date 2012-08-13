/*zzicmtrala.p	CREATE BY LONG BO 2004 JUN 21					*/
/*	ITEM TRANSFER ORDER MAINTENANCE		LINE MAINTENANCE		*/
/*	移库单备料维护	行维护										*/



	 {mfdeclre.i}

	define shared variable lad_recno as recid.
	def   shared var nbr like lad_nbr.
	define shared variable site_from like lad_site no-undo.
	define shared variable site_to   like lad_site no-undo.
	define shared variable loc_from  like lad_loc no-undo.
	define shared variable loc_to    like lad_loc no-undo.

	define variable sw_reset like mfc_logical.
	define variable desc1	like pt_desc1.
	define variable um		like pt_um.
	def var del-yn as logic.
	
	def var old_loc_from like loc_loc.
	def var old_qty		like lad_qty_all.
	def var old_lot		like ld_lot.
	def var old_ref 	like ld_ref.

form
 	lad_line format "x(3)" label "序"
 	lad_part 		colon 10 label "零件"
 	lad_qty_all		colon 30 label "分配数"
 	lad_loc			colon 40 label "调出库位"
 	lad_lot			colon 55 label "批序"
 	desc1			colon 10 no-label
 	um				colon 32 no-label
 	lad__qadc01		colon 40 label "调入库位"
 	lad_ref  		colon 55 label "参考号"
	with /*down*/ frame c width 80 /*overlay*/ title color normal "备料明细" THREE-D /*GUI*/.         
	 
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

               {zzmpscradx.i
                  lad_det
                  lad_det              
                  lad_line
                  "lad_line lad_part lad_qty_all lad_loc lad_lot desc1 um lad__qadc01 lad_ref"
				  lad_line
				  c
				  "lad_dataset = ""itm_det"" and lad_nbr = nbr"				
                  8808
                  yes
               }

/*F0PV*/    end.    /* if not batchrun then do */
             
			if keyfunction(lastkey) = "end-error"
			or lastkey = keycode("F4")
			or keyfunction(lastkey) = "."
			or lastkey = keycode("CTRL-E") then do:
            	leave.
            	
            /*   for each tr no-lock:
                   disp tr.
               end.
               ok_yn = no.
               {mfgmsg10.i 12 1 ok_yn}
            
               if not ok_yn then undo mainloop1,leave.
               else if ok_yn then leave.
               if ok_yn = ? then do:
                   sw_reset = yes.
                   undo mainloop1,retry.
               end.
            	*/
            end. /*if keyfunction*/
             
             
			if recno = ?
			and keyfunction(lastkey) <> "insert-mode"
			and keyfunction(lastkey) <> "go"
			and keyfunction(lastkey) <> "return"
			then leave.
			
			if yes /*keyfunction(lastkey) <> "end-error"*/
			then do on error undo, retry:
				do transaction:
/*/*GUI*/ if global-beam-me-up then undo, leave.*/               /*eyes*/

/*GA32*/             if recno = ? then do:
/*GA32*/                create lad_det.

	            		{gprun.i ""zzgetline.p"" "(nbr,
                          input-output lad_line)"}
		if global-beam-me-up then undo, leave.
                        display lad_line with frame c.

/*GA32*/                prompt-for lad_line with frame c.
						assign lad_line.
	            		{gprun.i ""zzgetline.p"" "(nbr,
                          input-output lad_line)"}
	if global-beam-me-up then undo, leave.
                        display lad_line with frame c.
/*GA32*/                delete lad_det.
/*GA32*/                find first lad_det where lad_dataset = "itm_det" and lad_nbr = nbr and lad_line = input lad_line no-lock no-error.
/*GA32*/                if available lad_det then do:
/*GA32*/                   recno = recid(lad_det).
/*GA32*/                end.
/*GA32*/                else do:
							prompt-for lad_part with frame c.                   /*eyes*/
							find pt_mstr where pt_part = input lad_part no-lock no-error.        /*eyes*/
							if not available pt_mstr then do:
							    {mfmsg.i 16 3}
							    undo,retry.
							end.                           
/*G1ZV*/   					if can-find(first isd_det where                                            																																																						
/*G1ZV*/   					           isd_status = string(pt_status,"x(8)") + "#"                     																																																						
/*G1ZV*/   					           and (isd_tr_type = "iss-tr" or isd_tr_type = "rct-tr")) then do:																																																						
/*F089*/   					   {mfmsg02.i 358 3 pt_status}                                             																																																						
/*F089*/   					   undo, retry.                                                            																																																						
/*F089*/   					end.                                                                       																																																						
           					/*lb02--*/
           					find first in_mstr no-lock where in_site = site_from and in_part = input lad_part no-error.
           					/*--lb02*/                                                                 																																																						
/*GA32*/                   	create lad_det.
/*GA32*/                   	assign lad_dataset  = "itm_det"
								   lad_part		= input lad_part
								   lad_line		= input lad_line
								   lad_nbr		= nbr
								   lad_site 	= site_from
								   lad_ord_site = site_to
								   lad_loc		= if available in_mstr then in_user1 else loc_from /*loc_from lb02*/ 
								   lad__qadc01  = loc_to.
						end.

 						find pt_mstr where pt_part = lad_part no-lock.
  						desc1 = pt_desc2.   /*lb02*/
  						um = pt_um.                         
                        display  desc1 um with frame c.  
                           
                        recno = recid(lad_det).
					end.
					
					find lad_det exclusive-lock where recid(lad_det) = recno.
					find pt_mstr where pt_part = lad_part no-lock.
					desc1 = pt_desc2.
					um = pt_um.                         
					old_loc_from = lad_loc.
					old_qty		= lad_qty_all.
					old_lot		= lad_lot.
					old_ref		= lad_ref.
					
					display lad_line lad_part lad_qty_all lad_loc lad_lot desc1 um lad__qadc01 lad_ref with frame c.
                    
					setc:
					do on error undo, retry:
if global-beam-me-up then undo, leave.
						set lad_qty_all lad_loc lad__qadc01 lad_lot  lad_ref
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
							if old_qty <> 0 then do:             
								/*UPDATE IN_MSTR AND LD_DET*/
								find in_mstr where in_site = site_from and in_part = lad_part exclusive-lock no-error.
							    if not available in_mstr then do :
							    	{gprun.i ""csincr.p"" "(input lad_part, input site_from)"}
						 			if global-beam-me-up then undo, leave.
									find in_mstr where in_site = site_from and in_part = lad_part exclusive-lock no-error.
								end.
								in_qty_all = in_qty_all - old_qty.
								
								find si_mstr where si_site = site_from no-lock no-error.
								find loc_mstr where loc_site = site_from and loc_loc = old_loc_from no-lock no-error.
								find ld_det where ld_site = site_from and ld_loc = old_loc_from
								and ld_part = lad_part and ld_lot = old_lot and ld_ref = old_ref
								exclusive-lock no-error.
								
								if not available ld_det then do :
									create ld_det.
									assign ld_site = site_from
											ld_loc = old_loc_from
											ld_part = lad_part
											ld_lot = old_lot
											ld_ref = old_ref
		                     				ld_date  = today.
		                     	
				                    if available loc_mstr then do:
				                        ld_status = loc_status.
				                    end.
				                    else do:
			            	            if available si_mstr then ld_status = si_status.
			            	        end.
			            	    end.
								ld_qty_all = ld_qty_all - old_qty.
							end. /* old_qty<>0*/
		
							delete lad_det.     
							                   
							clear frame c.
							next mainloop1.
						end.

						
						/*LOC*/
						/*VALIDATE*/
						find loc_mstr where loc_site = site_from and loc_loc = lad_loc no-lock no-error.
						if not available loc_mstr then do:
							message "错误: 库位" + lad_loc + "在地点" + site_from + "不存在,请重新输入!".
							next-prompt lad_loc with frame c.
							undo,retry.
						end.
						/*VERIFY THE LOC, WHETHER THE LOCATION CAN DO TRANSACTION "ISS-TR"*/
						find si_mstr where si_site = site_from no-lock.
						find isd_det no-lock
						where isd_tr_type = "iss-tr"
						and isd_status =
						(if available loc_mstr and loc_status <> "" then loc_status
							else si_status) no-error.
						if available isd_det then do:
							{mfmsg02.i 373 3
							"if available loc_mstr then loc_status
							else si_status"
							}
							next-prompt lad_loc with frame c.
							undo, retry.   
						end.

						find loc_mstr where loc_site = site_to and loc_loc = lad__qadc01 no-lock no-error.
						if (not available loc_mstr) and (not si_auto_loc) then do:
							message "错误: 库位" + lad__qadc01 + "在地点" + site_to + "不存在,请重新输入!".
							next-prompt lad__qadc01 with frame c.
							undo,retry.
						end.
						
						if lad_loc = lad__qadc01 then do:
							message "错误：调入库位和调出库位相同，请重新输入。".
							next-prompt lad_loc with frame c.
							undo,retry.
						end.
						
					
						find si_mstr where si_site = site_to no-lock.
						find isd_det no-lock
						where isd_tr_type = "rct-tr"
						and isd_status =
						(if available loc_mstr and loc_status <> "" then loc_status
							else si_status) no-error.
						if available isd_det then do:
							{mfmsg02.i 373 3
							"if available loc_mstr then loc_status
							else si_status"
							}
							next-prompt lad__qadc01 with frame c.
							undo, retry.   
						end.
					
						/*LOT/SER REF*/
						find first ld_det where ld_site = site_from and ld_loc = lad_loc
						and ld_lot = lad_lot and ld_ref = lad_ref and ld_part = lad_part
						no-lock no-error.
						if not available ld_det then do :
							message "错误：该库位下，该批次零件不存在，请重新输入." view-as alert-box.
							next-prompt lad_lot with frame c.
							undo, retry.
						end.
	
						/*QTY*/
						/*UPDATE IN_MSTR & LD_DET*/
						if old_qty <> 0 then do:
							find in_mstr where in_site = site_from and in_part = lad_part exclusive-lock no-error.
						    if not available in_mstr then do :
						    	{gprun.i ""csincr.p"" "(input lad_part, input site_from)"}
					 			if global-beam-me-up then undo, leave.
								find in_mstr where in_site = site_from and in_part = lad_part exclusive-lock no-error.
							end.
							in_qty_all = in_qty_all + lad_qty_all - old_qty.
							
							/*if not available in_mstr */
							find si_mstr where si_site = site_from no-lock no-error.
							find loc_mstr where loc_site = site_from and loc_loc = old_loc_from no-lock no-error.
							find ld_det where ld_site = site_from and ld_loc = old_loc_from
							and ld_part = lad_part and ld_lot = old_lot and ld_ref = old_ref
							exclusive-lock no-error.
							if not available ld_det then do :
								create ld_det.
								assign ld_site = site_from
										ld_loc = old_loc_from
										ld_part = lad_part
										ld_lot = old_lot
										ld_ref = old_ref
		                 				ld_date  = today.
		                 	
			                    if available loc_mstr then do:
			                        ld_status = loc_status.
			                    end.
			                    else do:
		            	            if available si_mstr then ld_status = si_status.
		            	        end.
		            	    end.
							
							ld_qty_all = ld_qty_all - old_qty.
													
							find loc_mstr where loc_site = site_from and loc_loc = lad_loc no-lock no-error.
							find ld_det where ld_site = site_from and ld_loc = lad_loc
							and ld_part = lad_part and ld_lot = lad_lot and ld_ref = lad_ref
							exclusive-lock no-error.
							if not available ld_det then do :
								create ld_det.
								assign ld_site = site_from
										ld_loc = lad_loc
										ld_part = lad_part
										ld_lot = lad_lot
										ld_ref = lad_ref
		                 				ld_date  = today.
			                    if available loc_mstr then do:
			                        ld_status = loc_status.
			                    end.
			                    else do:
		            	            if available si_mstr then ld_status = si_status.
		            	        end.
		            	    end.
							
							ld_qty_all = ld_qty_all + lad_qty_all.
							
							if ld_qty_all > ld_qty_oh then do :
								message "错误：库存不足,请重新输入!".
								next-prompt lad_qty_all with frame c.
								undo,retry.
							end.
						end. /*if old_qty <> 0*/						
					end.					
					
				end. /*do transaction*/               
	
	    	end. /*if keyfunction(lastkey)*/
	        
		end. /*mailloop1,repeat*/            
	