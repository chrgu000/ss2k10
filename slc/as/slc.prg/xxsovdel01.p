/* By: Neil Gao Date: 07/12/20 ECO: * ss 20071220 */

{mfdeclre.i}
{gplabel.i}

define var sonbr 	like so_nbr.
define var sonbr1 like so_nbr.
define var wolot 	like wo_lot.
define var wolot1 like wo_lot.
define var sovid  like xxsovd_id.
define var sovid1 like xxsovd_id.
define var ifdel as logical init no.
     		
form
   /*sonbr     colon 15
   sonbr1    colon 35 label "至"*/
   wolot     colon 15 
	 /*
   wolot1    colon 35 label "至"
   sovid     colon 15
   sovid1    colon 15 label "至"*/
   ifdel     colon 15 label "删除"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

	
/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
/*
   hide all no-pause .
	 view frame dtitle .
*/
	 ifdel = no .
   if sonbr1  = hi_char then sonbr1  = "".
   if wolot1  = hi_char then wolot1 = "".
   if sovid1  = hi_char then sovid1 = "".
   
   update 
   	/*sonbr sonbr1*/	/*---Remark by davild 20080303.1*/
   	wolot /*wolot1
		sovid sovid1*/	/*---Remark by davild 20080303.1*/
		ifdel
   with frame a.
/*SS 20081202 - B*/
/*
	 find first xxvind_det where xxvind_domain = global_domain and xxvind_wolot = wolot no-lock no-error.
	 if avail xxvind_det then do:
			message "此工单ID的机号已经被打印,不能删除!" view-as alert-box .
			next .
	 end.
*/
/*SS 20081202 - E*/
   if sonbr1 = "" then sonbr1 = hi_char.
	 if wolot1 = "" then wolot1 = hi_char.
	 if sovid1 = "" then sovid1 = hi_char.
	 
	 {mfselprt.i "printer" 132}
	 	   	
   	for each xxsovd_det where xxsovd_domain = global_domain 
   		/*and xxsovd_nbr >= sonbr and xxsovd_nbr <= sonbr1 
   		and xxsovd_wolot >= wolot and xxsovd_wolot <= wolot1*/	/*---Remark by davild 20080303.1*/
   		and xxsovd_wolot = wolot 
   		/*and xxsovd_id >= sovid and xxsovd_id <= sovid1*/ no-lock,
   		each pt_mstr where pt_domain = global_domain and pt_part = xxsovd_part no-lock:
    
    	disp	xxsovd_id xxsovd_nbr xxsovd_line xxsovd_wolot 
    				xxsovd_part pt_desc1 xxsovd_id1 with width 160.
 
  	end.
  	
		if ifdel then do:
			for each xxsovd_det where xxsovd_domain = global_domain 
   			/*and xxsovd_nbr >= sonbr and xxsovd_nbr <= sonbr1 */
   			and xxsovd_wolot = wolot /*and xxsovd_wolot <= wolot1
   			and xxsovd_id >= sovid and xxsovd_id <= sovid1*/ ,
   			each pt_mstr where pt_domain = global_domain and pt_part = xxsovd_part no-lock:
    		
				for each xxseq_mstr where xxseq_domain = global_domain 
   	 						
								and xxseq_wod_lot = xxsovd_wolot
								:
   						assign xxseq_mode_qty = 0.
        end.
				
				for each xxvind_det where xxvind_domain = global_domain and xxvind_wolot = wolot :
					delete xxvind_det.
				end.
				
				for each xxvin_mstr where xxvin_domain = global_domain and xxvin_wolot = wolot :
					delete xxvin_mstr.
				end.
				
				delete xxsovd_det.
				
  		end.
    end.

   {mfreset.i}
	 {mfgrptrm.i}
		
END.
