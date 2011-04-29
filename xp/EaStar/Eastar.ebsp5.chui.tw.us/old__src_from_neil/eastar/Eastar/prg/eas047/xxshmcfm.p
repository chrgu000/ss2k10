/* xxshmcfm.p -  Shipment Confirm */
/* REVISION: eb sp5 us  LAST MODIFIED: 05/10/04 BY: *EAS043* Leemy Lee  */
/* REVISION: eb sp5 us  LAST MODIFIED: 05/10/04 BY: *EAS043A1* Ricky Ho  */
/* REVISION: eb sp5 us  LAST MODIFIED: 09/24/04 BY: *EAS047A* Ricky Ho  */

	/* DISPLAY TITLE */
    {mfdtitle.i "eb sp5"}
    {xxsoisdef.i "NEW"}
    
    DEFINE VARIABLE vchr_InvoiceType AS CHARACTER FORMAT "x(1)" LABEL "Invoice Type" INIT "N".
    DEFINE VARIABLE vchr_ShipToName LIKE ad_name FORMAT "x(28)".    
    DEFINE VARIABLE fill_all LIKE mfc_logical LABEL "All" INITIAL NO.
    DEFINE VARIABLE vchr_CustFeedback AS CHARACTER FORMAT "x(30)" LABEL "Cust Feedback No".
	DEFINE VARIABLE vchr_shad_sq LIKE shad_sq.
	
    DEFINE VARIABLE vint_shad_ctn_line LIKE shad_ctn_line.
    DEFINE VARIABLE vdec_shad_open_qty LIKE shad_ext_qty.
    define variable yn like mfc_logical initial no.
	DEFINE VARIABLE vchr_status AS INTEGER.    
	DEFINE VARIABLE vchr_invoice AS CHARACTER.
    DEFINE VARIABLE vchr_loc like loc_loc LABEL "Location".

DEFINE new shared VARIABLE fm_site    like si_site .
DEFINE new shared VARIABLE fm_loc     like loc_loc .
define new shared variable fm_lotser like sr_lotser.
define new shared variable fm_lotref like ld_ref.  

/*EAS043A1 */ define variable vchr_shad_sanbr like shad_sanbr. 
/*EAS043A1 */ define variable vchr_shad_plt_nbr like shad_plt_nbr. 
/*EAS043A1*/ define new shared temp-table  xxsq_tmp
        field xxsq_sanbr    like shad_sanbr
        field xxsq_sq      /* like snh_sq_nbr*/ as integer format ">>9"
        field xxsq_ctn_line like shad_ctn_line
		field xxsq_plt_nbr  like snh_plt_nbr
		field xxsq_so_nbr like snh_so_order
        field xxsq_ponbr    like shad_ponbr
		field xxsq_shipto   like snh_shipto  
		field xxsq_part     like snh_part    
		field xxsq_open_qty like sod_qty_ord format "->,>>>,>>9.9<"
		field xxsq_part_um  like snh_part_um 
		field xxsq_ship_qty like sod_qty_ship format "->,>>>,>>9.9<"
		field xxsq_ext_qty  like sod_qty_ship format "->,>>>,>>9.9<"
		field xxsq_trf_qty  like sod_qty_ship format "->,>>>,>>9.9<"
        field xxsq_select   like mfc_logical
        field xxsq_shploc   like shad_shploc
        field xxsq_ctnnbr_fm like shad_ctnnbr_fm
        field xxsq_ctnnbr_to like shad_ctnnbr_to
        index xxsq_nbr IS PRIMARY UNIQUE xxsq_sanbr xxsq_sq xxsq_ctn_line ascending
		.

/*@@@@@@@@*/ define variable vdisp_zero_qty like mfc_logical init "no".            
	FORM 
		shah_sanbr        
		shah_method
		vchr_loc 
		vchr_InvoiceType
		SKIP
		shah_shipto
		vchr_ShipToName NO-LABEL
		shah_etdhk			LABEL "INV Date"
		fill_all 
		SKIP
		shah_cinbr		 	LABEL "Consignment Inv No"	FORMAT "x(8)"
		vchr_CustFeedback 
/*@@@@@@@@*/         skip
/*@@@@@@@@*/ vdisp_zero_qty label "Display Zero Quantity"
	WITH frame a side-labels width 80.
	
	/* SET EXTERNAL LABELS */
	setFrameLabels(frame a:handle).

	/* Confirm LINE ITEM DISPLAY FORM */
	
    FORM 
		shad_sq
	  	shad_plt_nbr
	  	shad_ctn_line
	  	shad_so_nbr
	  	shad_part
	  	vdec_shad_open_qty 	format "->,>>>,>>9.9<"	LABEL "Open QTY"
	  	xxsq_ship_qty	format "->,>>>,>>9.9<"	LABEL "Confirm QTY"
	  	shad_shploc	  							LABEL "Location"
	WITH frame b 6 DOWN WIDTH 80.
	
	
        /* SET EXTERNAL LABELS */
	setFrameLabels(frame b:handle).

	FORM
		vchr_shad_sq
	  	
        vchr_shad_plt_nbr
	  	
        vint_shad_ctn_line
	  	shad_so_nbr
	  	SKIP
	  	shad_part
	  	vdec_shad_open_qty 	LABEL "QTY Open"
	  	xxsq_ship_qty	LABEL "Confirm"
	WITH FRAME c SIDE-LABELS WIDTH 80.
	
	/* SET EXTERNAL LABELS */
	setFrameLabels(frame c:handle).		
	
	FORM 
		
        shad_sq
	  	
        shad_ctn_line
	  	shad_plt_nbr	  	
	  	shad_so_nbr
	  	shad_part
	  	vdec_shad_open_qty 	format "->,>>>,>>9.9<"	LABEL "Open QTY"
	  	xxsq_ship_qty	format "->,>>>,>>9.9<"	LABEL "Confirm QTY"
	  	shad_shploc	  							LABEL "Location"
	WITH frame d DOWN WIDTH 80.
	
	
        /* SET EXTERNAL LABELS */
	setFrameLabels(frame d:handle).	
	
	Mainloop:
	REPEAT:
	    PROMPT-FOR
	    	shah_sanbr
	    WITH FRAME a EDITING:
			if frame-field = "shah_sanbr" then do:
	            {mfnp.i shah_hdr shah_sanbr shah_sanbr shah_sanbr shah_sanbr shah_sanbr}
	            if recno <> ? then do:
	      			display 
						shah_sanbr        
						shah_method
						shah_shipto
						shah_etdhk
 						shah_cinbr
                        shah_feedback @ vchr_Custfeedback
	      			WITH frame a.
	      			FIND FIRST ad_mstr WHERE ad_addr = shah_shipto NO-LOCK NO-ERROR.
	      			display 
						ad_name @ vchr_ShipToName 
	      			WITH frame a.
	            end.
	        end.
	        else do:
	            status input.
	            readkey.
	            apply lastkey.		        
	        end.
		END.  /*EAS043*  PROMPT-FOR */	
		
	    FIND FIRST shah_hdr USING shah_sanbr SHARE-LOCK NO-ERROR.
		IF NOT AVAIL shah_hdr THEN DO:	    
	    	MESSAGE "Invalid SA Number".
	    	UNDO mainloop,RETRY mainloop.
		END.

	      			display 
						shah_sanbr        
						shah_method
						shah_shipto
						shah_etdhk
 						shah_cinbr
                        shah_feedback @ vchr_Custfeedback
	      			WITH frame a.
	      			FIND FIRST ad_mstr WHERE ad_addr = shah_shipto NO-LOCK NO-ERROR.
	      			display 
						ad_name @ vchr_ShipToName 
	      			WITH frame a.

/*EAS043A1 */ vchr_shad_sanbr = shah_sanbr.
/*EAS043A1 */ vchr_CustFeedback = shah_feedback.
		Update_Header:
		DO ON ERROR UNDO,RETRY:	
			UPDATE	
				vchr_loc
				vchr_InvoiceType    	
				shah_etdhk
				fill_all     	
				vchr_CustFeedback
/*@@@@@@@@*/    vdisp_zero_qty
		    WITH FRAME a.
	    
			IF vchr_loc = "" THEN
	        DO:
	        	{mfmsg.i 40 3}
	            NEXT-PROMPT vchr_loc WITH FRAME a.
		    	UNDO Update_Header,RETRY Update_Header.
	        END. 
	        
	        FIND FIRST loc_mstr WHERE loc_loc = vchr_loc NO-LOCK NO-ERROR.
	        IF NOT AVAILABLE loc_mstr THEN
	        DO:
	        	{mfmsg.i 709 3}
	            NEXT-PROMPT vchr_loc WITH FRAME a.
		    	UNDO Update_Header,RETRY Update_Header.
	        END.

			IF vchr_InvoiceType <> "N" AND vchr_InvoiceType <> "I" THEN
	        DO:
	        	MESSAGE "Error: Invalid Invoice Type. Please re-enter.".
	            NEXT-PROMPT vchr_InvoiceType WITH FRAME a.
		    	UNDO Update_Header,RETRY Update_Header.
	        END. 
		    
		    IF shah_consig = "C" THEN DO:
 
                IF shah_cinbr = "" THEN DO:
		        	MESSAGE "Consignment Invoice Not Yet Print, Confirm Not Allowed.".
		            NEXT-PROMPT vchr_loc WITH FRAME a.
			    	UNDO Update_Header,RETRY Update_Header.	    	
		    	END. 

		    	IF vchr_CustFeedback = "" THEN DO:
		        	MESSAGE "Cust Feedback No MUST be entered.".
		            NEXT-PROMPT vchr_loc WITH FRAME a.
			    	UNDO Update_Header,RETRY Update_Header.
		    	END.
			END.
            if vchr_CustFeedback <> "" then shah_feedback = vchr_CustFeedback.
			
		END.  /*EAS043*  Update_Header:	DO ON ERROR UNDO,RETRY:   */
	    
        FOR EACH xxsq_tmp:
        	delete xxsq_tmp.
        END.
	    Loop2:
	    DO ON ENDKEY UNDO,LEAVE:
/*EAS043A1 	    	IF fill_all = YES THEN DO:*/
			    FOR EACH shad_det WHERE shad_sanbr = shah_sanbr /*EAS043A1 AND (shad_ext_qty - shad_trf_qty) <> 0 */
	                AND shad_ctn_line <> 0 /*EAS043A1 AND shad_shploc = vchr_loc*/ :
	                
/*EAS043A1 */       vdec_shad_open_qty = 0.
/*EAS043A1                    IF shah_consig = "C" THEN DO:			    		 */
			    		FIND FIRST shloc_hist where shloc_sanbr = shah_sanbr and shloc_sq = shad_sq 
			    			and shloc_ctn_line = shad_ctn_line and shloc_site = "EAST"
			    			and shloc_loc = vchr_loc NO-LOCK NO-ERROR.
			    		IF AVAIL shloc_hist THEN DO:			    
/*EAS043A1 			    			shad_qty_inv = shloc_open_qty.*/
/*EAS043A1*/ 			    			vdec_shad_open_qty = shloc_open_qty.
			    		END.
/*EAS043A1			    	END.  /*EAS043*  IF shah_consig = "C" THEN DO: */ */
/*EAS043A1			    	ELSE DO: */
                        
/*EAS043A1*/            else if shad_shploc = vchr_loc then
/*EAS043A1 			    		shad_qty_inv = shad_ext_qty - shad_trf_qty.*/
/*EAS043A1*/ 			    		vdec_shad_open_qty = shad_ext_qty - shad_trf_qty - shad_qty_inv - shad_inv_qty.
/*EAS043A1			    	END.    */

                    
/*EAS043A1 add begin*/ 
/*@@@@@@@@                    IF vdec_shad_open_qty > 0 THEN*/
/*@@@@@@@@*/                    IF (not vdisp_zero_qty and vdec_shad_open_qty > 0) or (vdisp_zero_qty and vdec_shad_open_qty >= 0) THEN
                    DO:
                    find xxsq_tmp where xxsq_sanbr = shah_sanbr and xxsq_sq = shad_sq and xxsq_ctn_line = shad_ctn_line no-error.
                    if not available xxsq_tmp then 
                    create xxsq_tmp.
                    assign xxsq_sanbr = shah_sanbr
                           xxsq_sq = shad_sq
                           xxsq_ctn_line = shad_ctn_line
                           xxsq_shploc = vchr_loc
                           xxsq_open_qty = vdec_shad_open_qty
                           xxsq_ship_qty = if fill_all then vdec_shad_open_qty else 0
                           xxsq_part = shad_part
                           xxsq_so_nbr = shad_so_nbr
                           xxsq_plt_nbr = shad_plt_nbr
                           .
                    END.
/*EAS043A1 add end.*/ 
				END.	    /*EAS043*  FOR EACH shad_det  */
/*EAS043A1 			END.   /*EAS043*   IF fill_all = YES THEN DO: */*/
	    
		    Input_detal:
		    REPEAT:
		    	CLEAR FRAME b ALL NO-PAUSE.
		    	CLEAR FRAME c ALL NO-PAUSE.
		    	VIEW FRAME b. 
		    	VIEW FRAME c.	    	
		    
/*EAS043A1 
                FOR EACH shad_det WHERE shad_sanbr = shah_sanbr /*EAS043A1 AND (shad_ext_qty - shad_trf_qty) <> 0 */
			    	AND (shad_sq >= vchr_shad_sq AND shad_ctn_line >= vint_shad_ctn_line )
                    AND shad_ctn_line <> 0 /*EAS043A1 AND shad_shploc = vchr_loc*/
			    	BY shad_sq BY shad_line:
			    	
			    	vdec_shad_open_qty = 0.
/*EAS043A1			    	IF shah_consig = "C" THEN DO:			    		 */
			    		FIND FIRST shloc_hist where shloc_sanbr = shah_sanbr and shloc_sq = shad_sq 
			    			and shloc_ctn_line = shad_ctn_line and shloc_site = "EAST"
			    			and shloc_loc = vchr_loc NO-LOCK NO-ERROR.
			    		IF AVAIL shloc_hist THEN DO:			    
			    			vdec_shad_open_qty = shloc_open_qty.
			    		END.
/*EAS043A1			    	END.  /*EAS043*  IF shah_consig = "C" THEN DO: */ */
/*EAS043A1			    	ELSE DO: */
/*EAS043A1*/            else if shad_shploc = vchr_loc then
			    		vdec_shad_open_qty = shad_ext_qty - shad_trf_qty - shad_qty_inv - shad_inv_qty.
/*EAS043A1			    	END. */
/*EAS043A1*/        if vdec_shad_open_qty > 0 then do:
/*EAS043A1 add begin*/
                        find xxsq_tmp where xxsq_sanbr = shah_sanbr and xxsq_sq = shad_sq and xxsq_ctn_line = shad_ctn_line no-error.
                        if not available xxsq_tmp then do:
                            create xxsq_tmp.
                            assign xxsq_sanbr = shah_sanbr
                                   xxsq_sq = shad_sq
                                   xxsq_ctn_line = shad_ctn_line
                                   xxsq_shploc = vchr_loc
                                   xxsq_open_qty = vdec_shad_open_qty
                                   xxsq_ship_qty = 0
                                   xxsq_part = shad_part
                                   xxsq_so_nbr = shad_so_nbr
                                   xxsq_plt_nbr = shad_plt_nbr
                                   .
                        end.
    /*EAS043A1 add end.*/
*EAS043A1*/
                     FOR EACH xxsq_tmp:
                     	
                        DISPLAY
                            xxsq_sq @ shad_sq
					  	
                            xxsq_plt_nbr @ shad_plt_nbr
					  	
                            xxsq_ctn_line @ shad_ctn_line
                            xxsq_so_nbr @ shad_so_nbr
                            xxsq_part @ shad_part
                            xxsq_open_qty @ vdec_shad_open_qty 	
                            xxsq_ship_qty 	
                            xxsq_shploc @ shad_shploc	  		    		
                        WITH FRAME b.
                        IF FRAME-LINE(b) = FRAME-DOWN(b) THEN LEAVE.
                        DOWN 1 WITH FRAME b.
/*EAS043A1 /*EAS043A1 */       end.*/
                END.	/*EAS043*  FOR EACH shad_det */
				
				UPDATE
					vchr_shad_sq VALIDATE(INPUT vchr_shad_sq <> 0,"0 is not allowed")
				  	
                    vchr_shad_plt_nbr
                    vint_shad_ctn_line VALIDATE(INPUT vint_shad_ctn_line <> 0,"0 is not allowed")
				WITH FRAME c EDITING:
					if frame-field = "vchr_shad_sq" then do:
/*EAS043A1			            {mfnp05.i shad_det shad_sqline "shad_sanbr = shah_sanbr 
			            and shad_ctn_line <> 0 /*EAS043A1 AND shad_shploc = vchr_loc*/ AND shad_sq <> INPUT vchr_shad_sq"
                        shad_sq vchr_shad_sq}
                        *EAS043A1 "*/
/*EAS043A1 */          	{mfnp01.i xxsq_tmp vchr_shad_sq xxsq_sq vchr_shad_sanbr xxsq_sanbr xxsq_nbr }

			            if recno <> ? then do:
			            	assign vchr_shad_sq = xxsq_sq
                                   vchr_shad_plt_nbr = xxsq_plt_nbr
                                   vint_shad_ctn_line = xxsq_ctn_line.
			            	DISPLAY
			            		vchr_shad_sq
							  	vchr_shad_plt_nbr
							  	vint_shad_ctn_line
							  	xxsq_so_nbr @ shad_so_nbr
							  	xxsq_part @ shad_part
							  	xxsq_open_qty @ vdec_shad_open_qty 	
							  	xxsq_ship_qty 	
						    WITH FRAME c.					
			            end.
			        end.
					ELSE if frame-field = "vint_shad_ctn_line" then do:
						{mfnp05.i xxsq_tmp xxsq_nbr 
						"xxsq_sq = vchr_shad_sq"
						xxsq_ctn_line vint_shad_ctn_line}
						
						IF recno <> ? THEN DO:
/*EAS043A1 					    	IF shah_consig = "C" THEN DO:			    		
					    		FIND FIRST shloc_hist where shloc_sanbr = shah_sanbr and shloc_sq = shad_sq 
					    			and shloc_ctn_line = shad_ctn_line and shloc_site = "EAST"
					    			and shloc_loc = vchr_loc NO-LOCK NO-ERROR.
					    		IF AVAIL shloc_hist THEN DO:			    
					    			vdec_shad_open_qty = shloc_open_qty.
					    		END.
					    	END.  /*EAS043*  IF shah_consig = "C" THEN DO: */
					    	ELSE DO:
					    		vdec_shad_open_qty = shad_ext_qty - shad_trf_qty.
					    	END.						
					    	
			            	DISPLAY
			            		shad_sq @ vchr_shad_sq
							  	shad_plt_nbr
							  	shad_ctn_line @ vint_shad_ctn_line
							  	shad_so_nbr
							  	shad_part
							  	vdec_shad_open_qty 	
							  	xxsq_ship_qty	
						    WITH FRAME c.					
                            *EAS043A1*/
			            	assign vchr_shad_sq = xxsq_sq
                                   vchr_shad_plt_nbr = xxsq_plt_nbr
                                   vint_shad_ctn_line = xxsq_ctn_line.
			            	DISPLAY
			            		vchr_shad_sq
							  	vchr_shad_plt_nbr
							  	vint_shad_ctn_line
							  	xxsq_so_nbr @ shad_so_nbr
							  	xxsq_part @ shad_part
							  	xxsq_open_qty @ vdec_shad_open_qty 	
							  	xxsq_ship_qty	
						    WITH FRAME c.					

						END.
			        END.	        
			        else do:
			            status input.
			            readkey.
			            apply lastkey.		        
			        end.			
			    END.  /*EAS043*  UPDATE...WITH FRAME c EDITING: */
  
		        FIND FIRST xxsq_tmp WHERE xxsq_sanbr = shah_sanbr 
		        	AND xxsq_sq = INPUT vchr_shad_sq 
		        	AND xxsq_ctn_line = INPUT vint_shad_ctn_line 
                    and xxsq_plt_nbr = vchr_shad_plt_nbr EXCLUSIVE-LOCK NO-ERROR.
				
				IF NOT AVAIL xxsq_tmp THEN DO:
					MESSAGE "Invalid SQ selection. ".
					UNDO Input_detal,RETRY Input_detal.
				END.
				ELSE DO:
/*EAS043A1 			    	IF shah_consig = "C" THEN DO:			    		
			    		FIND FIRST shloc_hist where shloc_sanbr = shah_sanbr and shloc_sq = shad_sq 
			    			and shloc_ctn_line = shad_ctn_line and shloc_site = "EAST"
			    			and shloc_loc = vchr_loc NO-LOCK NO-ERROR.
			    		IF AVAIL shloc_hist THEN DO:			    
			    			vdec_shad_open_qty = shloc_open_qty.
			    		END.
			    	END.  /*EAS043*  IF shah_consig = "C" THEN DO: */
			    	ELSE DO:
			    		vdec_shad_open_qty = shad_ext_qty - shad_trf_qty.
			    	END.						
			    	
	            	DISPLAY
	            		shad_sq @ vchr_shad_sq
					  	shad_plt_nbr
					  	shad_ctn_line @ vint_shad_ctn_line
					  	shad_so_nbr
					  	shad_part
					  	vdec_shad_open_qty 	
					  	xxsq_ship_qty	
				    WITH FRAME c.	
                    *EAS043A1*/

			            	assign vchr_shad_sq = xxsq_sq
                                   vchr_shad_plt_nbr = xxsq_plt_nbr
                                   vint_shad_ctn_line = xxsq_ctn_line.
			            	DISPLAY
			            		vchr_shad_sq
							  	vchr_shad_plt_nbr
							  	vint_shad_ctn_line
							  	xxsq_so_nbr @ shad_so_nbr
							  	xxsq_part @ shad_part
							  	xxsq_open_qty @ vdec_shad_open_qty 	
							  	xxsq_ship_qty	
						    WITH FRAME c.					

				END.  /*EAS043*  IF NOT AVAIL shad_det ... ELSE DO: */
				
/*EAS043A1 				IF shad_shploc <> vchr_loc THEN DO:
					MESSAGE "Location doesn't match".
					UNDO Input_detal,RETRY Input_detal. 
				END.	 
*EAS043A1*/		        
		        Confirm_Qty:
		        DO ON ERROR UNDO,RETRY:
		        	update xxsq_ship_qty WITH FRAME c.

		        	
		    		IF xxsq_ship_qty > xxsq_open_qty THEN DO:
		    			MESSAGE "Error: Confirm QTY > Open QTY".
		    			NEXT-PROMPT xxsq_ship_qty WITH FRAME c.
		    			UNDO Confirm_Qty,RETRY Confirm_Qty.
		    		END.
/*EAS043A1 		    		
		    		FIND FIRST in_mstr WHERE in_part = shad_part 
		    			AND in_site = "east" NO-LOCK NO-ERROR.
		    		IF AVAIL in_mstr THEN DO:
			    		IF xxsq_ship_qty > in_qty_avail THEN DO:
			    			MESSAGE "Error: Confirm QTY > Balance QTY".
			    			NEXT-PROMPT xxsq_ship_qty WITH FRAME c.
			    			UNDO Confirm_Qty,RETRY Confirm_Qty.
			    		END.  
		    		END.
                    *EAS043A1*/

            assign fm_site = "EAST"
                   fm_loc = xxsq_shploc.

            find loc_mstr where loc_site = fm_site and loc_loc = fm_loc no-lock no-error.
            IF available loc_mstr THEN
            DO:
            	IF loc_type = "FG" then assign fm_lotser = "" fm_lotref = "".
                else assign fm_lotser = xxsq_sanbr fm_lotref = if available shah_hdr then string(shah_etdhk) else "".
            END.

            find ld_det where ld_part = xxsq_part and ld_site = fm_site and ld_loc = fm_loc and ld_lot = fm_lotser and ld_ref = fm_lotref no-lock no-error.
            IF not available ld_det THEN
            DO:
            	message "Error: Confirm QTY > Location balance, please re-enter".
/*                message xxsq_part + "|" + fm_site + "|" + fm_loc + "/" + fm_lotser + "/" + fm_lotref view-as alert-box.*/
                xxsq_ship_qty = 0.
                next-prompt xxsq_ship_qty with frame c.
                undo, retry.
            END.
            else IF ld_qty_oh < xxsq_ship_qty THEN
            DO:
            	message "Error: Transfer Qty > Location balance, please re-enter".
                xxsq_ship_qty = 0.
                next-prompt xxsq_ship_qty with frame c.
                undo, retry.
            END.


		    	END.  /*EAS043*  Confirm_Qty: */
			END.  /*Input_detal*/
		
			HIDE FRAME b NO-PAUSE.
			HIDE FRAME c NO-PAUSE.
			
			FOR EACH xcim_sod_det:
				DELETE xcim_sod_det.
			END.
			CLEAR FRAME d ALL NO-PAUSE.
		    FOR EACH xxsq_tmp WHERE xxsq_sanbr = shah_sanbr  
		    	AND xxsq_ship_qty <> 0 
		    	BY xxsq_sq BY xxsq_ctn_line:
		    	
    			vdec_shad_open_qty = xxsq_ship_qty.

			    	DISPLAY
						xxsq_sq @ shad_sq
                        xxsq_plt_nbr @ shad_plt_nbr
                        xxsq_ctn_line @ shad_ctn_line
					  	xxsq_so_nbr @ shad_so_nbr
					  	xxsq_part @ shad_part
					  	xxsq_open_qty @ vdec_shad_open_qty 	
					  	xxsq_ship_qty 
					  	xxsq_shploc @ shad_shploc	  		    		
			    	WITH FRAME d.
			    	DOWN 1 WITH FRAME d.
		    	
/*@@@@@@@@*/    find first sod_det where sod_nbr = xxsq_so_nbr AND sod_part = xxsq_part no-lock no-error.
/*@@@@@@@@*/    if not available sod_det then do:
/*@@@@@@@@*/        message "Error: Can not find SO: " + xxsq_so_nbr + " Item: " + xxsq_part + ",Please create SO manually.".
/*@@@@@@@@*/        pause.
/*@@@@@@@@*/        undo mainloop,leave.
/*@@@@@@@@*/    end.
                FOR EACH sod_det WHERE sod_nbr = xxsq_so_nbr AND sod_part = xxsq_part 
/*@@@@@@@@                    and vdec_shad_open_qty > 0*/
/*@@@@@@@@*/                    and vdec_shad_open_qty <> 0
		    		no-LOCK BY sod_due_date:
		    	
			    	
			    	CREATE xcim_sod_det.
			    	ASSIGN
						xcim_sod_nbr		 	=	xxsq_so_nbr
						xcim_sod_inv_date	 	=	TODAY
						xcim_sod_line		 	=	sod_line
						xcim_sod_qty_ship	 	=	min(sod_qty_ord - sod_qty_ship,vdec_shad_open_qty)
						xcim_sod_site		 	=	"EAST"		
						xcim_sod_loc		 	=	xxsq_shploc
						xcim_sod_lot		 	=	fm_lotser
						xcim_sod_ref		 	=	fm_lotref
						xcim_sod_rmks		 	=	""
						xcim_sod_inv_nbr	 	=	""
			    	.
                    vdec_shad_open_qty = vdec_shad_open_qty - xcim_sod_qty_ship.
                    if vdec_shad_open_qty <= 0 then leave.

/*EAS043A1 			    	LEAVE.  /* only issue the line with eailier due date */ *EAS043A1*/
			    END.  /*EAS043*  FOR EACH shad_det WHERE shad_sanbr = shah_sanbr */
			END.	/*EAS043*  FOR EACH shad_det */
            
			loop3:
			DO TRANSACTION ON ENDKEY UNDO,LEAVE:
/*@@@@@@@@                IF not can-find(first xxsq_tmp where xxsq_ship_qty > 0) THEN*/
/*@@@@@@@@*/                IF not can-find(first xxsq_tmp where xxsq_ship_qty <> 0) THEN
                DO:
                	undo mainloop,retry mainloop.
                END.
				yn = NO.
/*EAS043A1 *EAS043A1*/ message "Comfirm SA?" update yn.
				IF yn = NO THEN DO:
					UNDO loop2,RETRY loop2.
				END.
                
/*				MESSAGE "Confirm to Print and Post Invoice? Yes/No" UPDATE yn.
				IF yn = NO THEN DO:
					UNDO loop2,RETRY loop2.
				END.
				
				FIND FIRST soc_ctrl EXCLUSIVE-LOCK NO-ERROR.
				vchr_invoice = SUBSTRING(STRING(YEAR(TODAY)),3,2) + STRING(soc_inv,"99999").
				soc_inv = soc_inv + 1.
				IF vchr_InvoiceType = "N" THEN DO:
					vchr_invoice = "3" + vchr_invoice.
				END.
				ELSE IF vchr_InvoiceType = "I" THEN DO:
					vchr_invoice = "4" + vchr_invoice.
				END.
                
				FOR EACH xcim_sod_det:
					xcim_sod_inv_nbr = vchr_invoice.
				END.

				IF vchr_InvoiceType = "N" THEN DO:
					MESSAGE "Normal Invoice Complete" VIEW-AS ALERT-BOX.
				END.
				ELSE IF vchr_InvoiceType = "I" THEN DO:
					MESSAGE "Immediate Invoice Complete" VIEW-AS ALERT-BOX.
				END.
				
				yn = NO.
				MESSAGE "All invoice print accepted? Yes/No" UPDATE yn.
				IF yn = NO THEN DO:
					UNDO loop3,RETRY loop3.
				END.				
*/				
				vchr_status = 0.				
				Loop4:
				DO TRANSACTION:
					MESSAGE "Confirm SA...".
					{gprun.i ""xxcisois.p"" "(output vchr_status)"}
					IF vchr_status = 1 THEN DO:
						MESSAGE "Item can not be issued." VIEW-AS ALERT-BOX.
						UNDO Loop4,LEAVE Loop4. 
					END.
/*EAS043A1 
					{gprun.i ""xxciivps.p"" "(output vchr_status)"}
					IF vchr_status = 1 THEN DO:
						MESSAGE "Invoice: " + vchr_invoice + " can not be posted." VIEW-AS ALERT-BOX.
						UNDO Loop4,LEAVE Loop4.  
					END.
*EAS043A1*/
/*EAS043A1 					
				    FOR EACH shad_det WHERE shad_sanbr = shah_sanbr AND shad_ctn_line <> 0 
				    	AND shad_shploc = vchr_loc AND shad_qty_inv <> 0:
				    	IF shah_consig = "C" THEN DO:			    		
				    		FIND FIRST shloc_hist where shloc_sanbr = shah_sanbr and shloc_sq = shad_sq 
				    			and shloc_ctn_line = shad_ctn_line and shloc_site = "EAST"
				    			and shloc_loc = vchr_loc EXCLUSIVE-LOCK NO-ERROR.
				    		IF AVAIL shloc_hist THEN DO:
				    			shloc_trf_qty = shloc_trf_qty + shad_qty_inv.
				    			shloc_open_qty = shloc_open_qty - shad_qty_inv.
				    		END.
				    	END.  /*EAS043*  IF shah_consig = "C" THEN DO: */					    	
				    	
						shad_trf_qty = shad_trf_qty + shad_qty_inv.
						shad_inv_qty = shad_inv_qty + shad_qty_inv.
						shad_qty_inv = 0.
					END.
*EAS043A1*/
/*@@@@@@@@                    FOR EACH xxsq_tmp where xxsq_ship_qty > 0:*/

/*@@@@@@@@*/                    FOR EACH xxsq_tmp where xxsq_ship_qty <> 0:
                    	FIND shad_det where shad_sanbr = xxsq_sanbr and shad_sq = xxsq_sq and shad_ctn_line = xxsq_ctn_line 
                    		NO-ERROR.
                        IF available shad_det THEN
                        DO:
                            shad_inv_qty = shad_inv_qty + xxsq_ship_qty.
/*EAS043A1                            IF shah_consig = "C" THEN DO:			    		 */
                                FIND FIRST shloc_hist where shloc_sanbr = shah_sanbr and shloc_sq = shad_sq 
                                    and shloc_ctn_line = shad_ctn_line and shloc_site = "EAST"
                                    and shloc_loc = xxsq_shploc EXCLUSIVE-LOCK NO-ERROR.
                                IF AVAIL shloc_hist THEN DO:
                                    shloc_trf_qty = shloc_trf_qty + xxsq_ship_qty.
                                    shloc_open_qty = shloc_open_qty - xxsq_ship_qty.
                                END.
/*EAS043A1                            end. */
                        end.
                    END.
/*EAS043A1 					MESSAGE "Invoice: " + vchr_invoice + " was posted." VIEW-AS ALERT-BOX.*/
/*EAS043A1*/ 					MESSAGE "SA confrimed." VIEW-AS ALERT-BOX.
					MESSAGE " ".
					MESSAGE " ".
				END. /* Loop4 */
			END. /* Loop3 */
		END. /* Loop2 */
        
	END.  /*Mainloop*/
    
    