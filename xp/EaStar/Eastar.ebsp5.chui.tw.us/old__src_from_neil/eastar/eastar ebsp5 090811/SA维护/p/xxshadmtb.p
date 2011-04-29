/* xxshadmtb.p  -- Shipping Advise Maintenance */
/* REVISION: eb SP5 create 04/21/04 BY: *EAS036A* Apple Tam */
    
/*    {mfdeclre.i}*/
/*{pxgblmgr.i}*/

define shared variable global_user_lang_dir as character.
         define shared variable global_user_lang as character.
         define shared variable batchrun like mfc_ctrl.mfc_logical.
define shared variable mfguser as character.
define shared variable config_changed like mfc_logical.
              
define shared variable global-beam-me-up like mfc_logical initial no no-undo.   
define variable yn2 like mfc_logical initial yes.
define variable yn3 like mfc_logical initial no.
define variable dele like mfc_logical initial no.

/*/*N0K6*/ {gplabel.i} /* EXTERNAL LABEL INCLUDE */

{mfdatev.i}
*/


define shared variable sanbr like shah_sanbr.
define shared variable pinbr like shah_pinbr.
define shared variable snnbr like sn_nbr no-undo.
define variable fm3 like shad_ctnnbr_fm.
define variable qty3 like shad_ext_qty.
		
define temp-table  xxsa_tmp
		field xxsa_snnbr      like shad_snnbr    
		field xxsa_plt_nbr    like shad_plt_nbr  
		field xxsa_shipto     like shad_shipto   
		field xxsa_ponbr      like shad_ponbr    
		field xxsa_part       like shad_part     
		field xxsa_ctnnbr_fm  like shad_ctnnbr_fm
		field xxsa_ctnnbr_to  like shad_ctnnbr_to
		field xxsa_ext_qty    like shad_ext_qty  
		field xxsa_sq         like shad_sq  
/*        index xxsa_sq IS PRIMARY UNIQUE xxsa_sq ascending*/
		.
form
   "Total"    at 1
   shah_ttl_plt     format ">>>9"    
   shah_ttl_ctn     format ">>>9"
   shah_ttl_qty     format ">>,>>9.9<"
   shah_ttl_gw      format ">>,>>>,>>9.9<"
   shah_ttl_cmb     format ">>,>>9.9<"
with frame aa no-box side-labels width 80 row 22.
/* SET EXTERNAL LABELS */
/*setFrameLabels(frame aa:handle).*/


FORM 
   xxsa_snnbr     label "SN"
   xxsa_plt_nbr    label "PLT"
   xxsa_shipto    label "Ship To"
   xxsa_ponbr     label "PO No."
   xxsa_part      label "Item No."
   xxsa_ctnnbr_fm     label "FM"
   xxsa_ctnnbr_to     label "TO"
   xxsa_ext_qty   label "To Ship QTY"
with frame dw scroll 1 12 down width 80 .
    

pause 0 .
view frame dw.
pause before-hide.
view frame aa.
 find first shah_hdr where shah_sanbr = sanbr no-error.
 if available shah_hdr then do:
     display
        shah_ttl_plt 
	shah_ttl_ctn 
	shah_ttl_qty 
	shah_ttl_gw  
	shah_ttl_cmb 
	with frame aa.
 end.
 for each xxsa_tmp:
     delete xxsa_tmp.
 end.
 fm3 = 0.
 qty3 = 0.
 for each shad_det where shad_sanbr = sanbr and shad_line > 0 break by shad_sq:
     if first-of(shad_sq) then fm3 = shad_ctnnbr_fm.
     qty3 = qty3 + shad_ext_qty.
     if last-of(shad_sq) then do:
     create xxsa_tmp.
     assign
         xxsa_snnbr      =  shad_snnbr     
	 xxsa_plt_nbr    =  shad_plt_nbr   
	 xxsa_shipto     =  shad_shipto    
	 xxsa_ponbr      =  shad_ponbr     
	 xxsa_part       =  shad_part      
	 xxsa_ctnnbr_fm  =  fm3 /*shad_ctnnbr_fm */
	 xxsa_ctnnbr_to  =  shad_ctnnbr_to 
	 xxsa_ext_qty    =  qty3 /*shad_ext_qty   */
	 xxsa_sq         =  shad_sq        
     .
     qty3 = 0.
     fm3 = 0.
     end.
 end.
            find first xxsa_tmp no-error.
	    if not available xxsa_tmp then leave.

/**********************************************************************/
mainloop3:
do:
   {xxwindo1u.i

               xxsa_tmp 

               "
		xxsa_snnbr    	   
		xxsa_plt_nbr  	   
		xxsa_shipto   	   
		xxsa_ponbr    	   
		xxsa_part     	   
		xxsa_ctnnbr_fm	   
		xxsa_ctnnbr_to	   
		xxsa_ext_qty  	   
			   "

               xxsa_snnbr

   " "

   yes
   }




   if keyfunction(lastkey) = "RETURN" then do trans
   with frame dw on error undo, leave on endkey undo, leave:
      find xxsa_tmp where recid(xxsa_tmp) = recidarray[frame-line(dw)].

	 do on error undo, retry:
         end. /* do on error undo, retry */

   end.
   else
   if keyfunction(lastkey) = "GO" then do trans:
        /*leave mainloop3.*/
	message "Information correct?" update yn2.
	if yn2 = yes then do:
	   leave.
	end.
   end.
/*   else
   if keyfunction(lastkey) = "ENDKEY" then do :
	   leave.
   end.
*/
   {xxwindo1u1.i xxsa_snnbr}
end.


hide frame dw no-pause.
hide frame aa no-pause.
pause before-hide.
