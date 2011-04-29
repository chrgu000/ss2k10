
define shared variable global_user_lang_dir like lng_mstr.lng_dir.
define shared variable global_userid like usr_userid.
define var  t_qt  like xxshd_pallet .


def var v_old_so_qty like sod_qty_ord .
def var v_old_pallet like xxshd_pallet .
def var v_tmp_pallet like xxshd_pallet .
{xxshdefine.i " "}      

{gplabel.i }

		FORM 
			tmp_flag	label " " format "x(1)"
			tmp_sele	label "S" format "x(1)" 
			tmp_so_nbr	Label "Order"
			tmp_so_line	LABEL "Ln"  
			tmp_sort	label "Sort"  
			tmp_so_part	label "Part"  
			tmp_so_qty	Label "Quantity"  
			tmp_so_price    Label "UnitPrice"
			tmp_carton	label "CTN Qty" format ">>>>9"  
			tmp_pallet	label "PLT Qty" format ">>>>9.<<"    
			tmp_blance_qty  label "Bla CTN Qty"format ">>>>9" 
			/*skip*/
			tmp_carton_no   label "St CTN No" 
			tmp_pallet_no   label "St PLT No"
			tmp_ser_no	label "SerialNo1" format "x(36)" 
			tmp_ser_no2	label "SerialNo2" format "x(36)" 
			tmp_yiyin_date  Label "Date Code"  format "x(36)"  
           		tmp_seat_part   label "SeatPart" 
			
			with frame w /*SIDE-LABELS*/
            scroll 
            10 down 
            no-validate
            attr-space
            TITLE ""
            WIDTH 80 . 

	   /* with frame w  scroll 1  down overlay no-validate
            no-attr-space TITLE "" width 80. */

 /*         setFrameLabels(frame w:handle). */
                            
	

            pause 0.
            view frame w.
            pause before-hide.  
            
/*             find first tmp no-error.     */
/*         if not available tmp then leave. */
/*                                                */
/*             do:       
*/
               
          {windo1u.i
               tmp
               "
                  tmp_flag
		  tmp_sele
                  tmp_so_nbr	
		  tmp_so_line	
		  tmp_sort	
		  tmp_so_part	
		  tmp_so_qty	
		  tmp_so_price   
		  tmp_carton	
		  tmp_pallet	
		  tmp_blance_qty 
		  tmp_carton_no  
		  tmp_pallet_no  
		  tmp_ser_no
		  tmp_ser_no2
		  tmp_yiyin_date 
		  tmp_seat_part  
        	   "
               "tmp_flag"
               "use-index idtmpsortnbrline" 
               yes
			   " "
			   " "
               }
            
	   /*  {mfnp.i tmp tmp_so_nbr tmp_so_nbr tmp_so_nbr tmp_so_nbr tmp_so_nbr}
	     if recno <> ? then do:
		
		    display tmp_flag tmp_sele tmp_so_nbr with frame w.
		    end. */
		    



               IF keyfunction(lastkey) = "RETURN" then do:
                  find tmp
                  where recid(tmp) = recidarray[frame-line(w)].

		  REPEAT with frame w :
			  UPDATE  
			      tmp_sele EDITING:                  
				   READKEY .
				   pause 0 before-hide.
				       if lastkey = 27 OR LASTKEY = 404 THEN do: 
					   READKEY.
				       END.
				       ELSE DO:				   
					    APPLY LASTKEY .
				       END.                   
			   END.
			   IF TMP_sele = "y" or tmp_sele = "" then leave.
			   else next .
		   END.
		   tmp_sele = caps(tmp_sele) .   disp tmp_sele with frame w .
		   
		   /*計算此項未結數量--BEGIN*/
			find first sod_det where sod_nbr = tmp_so_nbr and sod_line = tmp_so_line no-lock no-error.
			if avail sod_det then do:
				v_old_so_qty = sod_qty_ord .
				for each xxshd_det where xxshd_so_nbr = tmp_so_nbr and xxshd_so_line = tmp_so_line 
						and xxshd_inv_no <> invno 						
						no-lock:
					if not (xxshd_inv_no matches("*cs") ) then 
					assign v_old_so_qty = v_old_so_qty - xxshd_so_qty .
				end.
			end.
		   /*計算此項未結數量--END*/
			
			
		   REPEAT with frame w :			   
			  
			   UPDATE 
				tmp_sort
			      tmp_so_qty 
			      /*tmp_so_price*/    /*價格不能修改*/ 
			      /*tmp_carton*/		/*自動算出*/
			      /*tmp_pallet */
			      /* tmp_blance_qty */   /*當輸入TMP_PALLET後自動算出*/
			      EDITING:  				   
					   status input.
					   READKEY .
					   pause 0 before-hide.
					       if lastkey = 27 OR LASTKEY = 404 THEN do: 
						   READKEY.
					       END.
					       ELSE DO:		   
						    APPLY LASTKEY .
					       END.  
			   END.
			   if invcode <> "CS" then do:
			   
				   if tmp_so_qty > v_old_so_qty then do:
					message "Quantity can not more than " + string(v_old_so_qty) .
					next .
				   end.
				   else leave .
			   end.
			   else leave .    /*CS單就直接退出*/

		    END.
		   
				/*自動算出箱數及卡板數-BEGIN*/
				find first xxpt_mstr where xxpt_part = tmp_so_part no-lock no-error.
				if avail xxpt_mstr then do:
					ASSIGN tmp_seat_part = xxpt_custseat_part .
					
					

					if xxpt_ct_pcs > 0 then 
						assign tmp_carton = tmp_so_qty / xxpt_ct_pcs .
					else	assign tmp_carton = 0 .
					run getinteger(input-output tmp_carton) .

					 if tmp_carton = 0 then do:
					      if tmp_pallet=0 then 
					      	assign tmp_pallet = 0. 
					       
					  end.
					else do:
					     /*if tmp_pallet=0 then do:--by davild20060727*/
						if xxpt_pt_maxcheng = 0 or xxpt_pt_pcscheng = 0 or xxpt_ct_pcs = 0 then
							assign tmp_pallet = 0 .
						else do:	
						       assign t_qt = round( tmp_carton /  (xxpt_pt_maxcheng * xxpt_pt_pcscheng ) ,2) . 
						     
						       if tmp_dec[2]      = 1   /*第二次修改時Pallet不重新被算,但提示原始卡板數如1.67*/
							then do:								
								message  'System Pallet:' + string(t_qt,">>9.99") .
							end.
							else do:
								assign tmp_pallet = t_qt .
							end.
						end.
					    /* end.:--by davild20060727*/
					end.
				end.
				else do:
				   if tmp_pallet=0 then do:
					assign  tmp_carton = 0
				                tmp_pallet = 0 .
				    end.
				end.
				/*assign tmp_dec[1] = tmp_pallet .*/   /*保存原始卡板數量*/
				assign tmp_dec[1] = t_qt .    /*保存原始卡板數量--by ching 20060727*/
				
				assign v_old_pallet = tmp_dec[1] .
				disp tmp_carton tmp_pallet 0 @ tmp_blance_qty with frame w .
				disp tmp_seat_part with frame w .
				/*自動算出箱數及卡板數-END*/
			
			REPEAT with frame w :			   
			  
			   UPDATE 
				
			      tmp_pallet 
			      /* tmp_blance_qty */   /*當輸入TMP_PALLET後自動算出*/
			      EDITING:  				   
					   status input.
					   READKEY .
					   pause 0 before-hide.
					       if lastkey = 27 OR LASTKEY = 404 THEN do: 
						   READKEY.
					       END.
					       ELSE DO:		   
						    APPLY LASTKEY .
					       END.  
			   END.
                            

			



			   v_tmp_pallet = tmp_pallet .
			   run getinteger(input-output v_tmp_pallet) .
                                 /* qing add 08/02/06  start */
				   
				   /* disp  tmp_pallet tmp_dec[1] . */
				   

				    if tmp_pallet>int(t_qt + 0.5)   then do:
					message "Pallet Must be >= " + string(INT(t_qt - 0.5) ) + " AND <= " + string(int(t_qt + 0.5) ) + ',System Pallet:' + string(t_qt,">>9.99") .
					next .
				   end. 
				  
				   if tmp_pallet<int(t_qt - 0.5)  then do:
					message "Pallet Must be >= " + string(INT(t_qt - 0.5) ) + " AND <= " + string(int(t_qt + 0.5) ) + ',System Pallet:' + string(t_qt,">>9.99") .
					next .
				   end.   

			
				 /* qing add 08/02/06  end */
			   if v_tmp_pallet <> tmp_pallet then do:
				message "Input a integer " .
				next .
			   end.
			   else 
				leave .
                     
             

			 END.   


				 /*自動算出余數-BEGIN*/ 
				 
					find first xxpt_mstr where xxpt_part = tmp_so_part no-lock no-error.
					if avail xxpt_mstr then do:						
						if tmp_carton = 0 then
                                                    
							assign tmp_blance_qty = 0 .
						
						else do:
						   
							if tmp_pallet = 0 then 
								assign tmp_blance_qty = tmp_carton .   /*如果卡板為0則余數=卡通箱數*/
							if v_old_pallet <  tmp_pallet then do:
								assign tmp_blance_qty = 0 .
								/*message string(tmp_blance_qty) view-as alert-box .*/
							end.
							else if v_old_pallet >  tmp_pallet then 
								assign tmp_blance_qty = tmp_carton - (tmp_pallet * xxpt_pt_maxcheng * xxpt_pt_pcscheng)  .
						end.
					end.
					else do:
						assign tmp_blance_qty = 0 .					
					end.
					if tmp_blance_qty < 0 then tmp_blance_qty = 0.
					
					disp tmp_blance_qty @ tmp_blance_qty format "->>>9.99" with frame w .
					disp tmp_seat_part with frame w .

				 /*自動算出余數-END*/
			 /*update carton_no....*/ 
			
			 
			   UPDATE  			     
			      tmp_carton_no  
			      tmp_pallet_no  
			      tmp_ser_no	
			      tmp_ser_no2
			      tmp_yiyin_date 
			      /*tmp_seat_part */ 
			      EDITING:                  
				   
					   status input.
					   READKEY .
					   pause 0 before-hide.
					       if lastkey = 27 OR LASTKEY = 404 THEN do: 
						   READKEY.
					       END.
					       ELSE DO:		   
						    APPLY LASTKEY .
					       END.  
			   END.
			   disp tmp_seat_part with frame w .

               END.

               /*IF keyfunction(lastkey) = "GO" then do:
                  find tmp
                  where recid(tmp) = recidarray[frame-line(w)].
                  MESSAGE tmp_so_nbr VIEW-AS ALERT-BOX .
                  hide frame w no-pause.
                  LEAVE.
               end.*/
	       /*if lastkey = 27 then leave .*/
               {windo1u1.i tmp_flag}

			clear frame w all no-pause.





PROCEDURE getinteger:
    DEF INPUT-OUTPUT PARAM pro_integer AS DEC.
    DEF VAR ii AS INTE.
    DEF VAR tmpchar AS CHAR INIT "".
    DO ii = 1 TO LENGTH(STRING(pro_integer)):
        IF SUBSTR(STRING(pro_integer) ,ii,1) <> "." THEN DO:
            tmpchar = tmpchar + SUBSTR(STRING(pro_integer) ,ii,1) .
        END.
        ELSE LEAVE .
    END.
    IF pro_integer > DEC(tmpchar)  THEN
        ASSIGN pro_integer = DEC(tmpchar) + 1 .
    ELSE 
        ASSIGN pro_integer = DEC(tmpchar) .
END PROCEDURE .
