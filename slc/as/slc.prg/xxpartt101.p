/* By: Neil Gao Date: 07/12/20 ECO: * ss 20071220 */
/* By: Neil Gao Date: 08/01/17 ECO: * ss 20080117 */

{mfdeclre.i}  
{gplabel.i} 

define var site like ld_site.
define var ifper as logical init yes.
define var ifvend as logical init no.
define var ifbuyer as logical init yes.
define var part  like pt_part.
define var part1 like pt_part.
define var xxproportion like vp_tp_pct.
define var tt_recid as recid.
define var first-recid as recid.
define variable sw_reset     like mfc_logical. 
define var update-yn as logical.

define temp-table xxvdd_det
  field xxvdd_part like vp_part
  field xxvdd_vend like vp_vend
  field xxvdd_vend_part like vp_vend_part format "x(16)"
  field xxvdd_name like ad_name format "x(16)"
  field xxvdd_proportion like vp_tp_pct
  field xxvdd_price like vp_q_price
  index xxvdd_part
  xxvdd_part
  xxvdd_vend.
       
define temp-table xxvd_mstr
  field xxvd_part like vp_part
  field xxvd_desc1 like pt_desc1
  field	xxvd_desc2 like pt_desc2
  field xxvd_proportion like vp_tp_pct
  index xxvd_part
  xxvd_part.	
     		
form
   part     colon 15  part1   colon 48
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	 pt_part 	label "零件号"
   pt_desc1 label "品名"
   pt_ord_pol
   pt_buyer
   pt_pm_code 
   pt_sfty_stk format ">>>>>>>>"
   pt_ord_min format ">>>>>>>>"
with frame b width 80 no-attr-space 5 down scroll 1.
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).


form
   xxvdd_vend label "供应商"
   xxvdd_part label "零件号"
   xxvdd_name label "供应商名称"
   xxvdd_vend_part label "供应商物料"
   xxvdd_proportion label "百分比"
   xxvdd_price format ">>>>9.9<<" label "临时价格"
with frame c down width 80 no-attr-space.   
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
	
/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
   
   if part1  = hi_char then part1  = "".
   
   update 
   	part  part1
		/*ifbuyer*/
   with frame a.
   
   if part1 = "" then part1 = hi_char.
	 hide frame a no-pause.
	 
   scroll_loop:
   repeat with frame b:
   	
    	{xuview.i
    	     &buffer = pt_mstr
    	     &scroll-field = pt_part
    	     &framename = "b"
    	     &framesize = 5
    	     &display1     = pt_part
    	     &display2     = pt_desc1
    	     &display4     = pt_ord_pol
    	     &display5 		 = pt_buyer
    	     &display6		 = pt_pm_code
    	     &display7		 = pt_sfty_stk
    	     &display8 		 = pt_ord_min
    	     &searchkey    =  "(pt_ord_pol = '' or (pt_buyer = '' and pt_pm_code = 'p' ) or pt_pm_code = '') and pt_domain = global_domain"
    	     &logical1     = false
    	     &first-recid  = first-recid
    	     &exitlabel = scroll_loop
    	     &exit-flag = true
    	     &record-id = tt_recid
    	     &cursordown = " 		
    	     									if avail pt_mstr then do:
    	     										find first cd_det where cd_domain = global_domain and cd_ref = pt_part 
                            	and cd_lang = 'ch' and cd_type = 'sc' no-lock no-error.
                            	if avail cd_det then message cd_cmmt[1].
                            end.
                              "
    	     &cursorup   = " 
    	     									if avail pt_mstr then do:
    	     										find first cd_det where cd_domain = global_domain and cd_ref = pt_part 
                            	and cd_lang = 'ch' and cd_type = 'sc' no-lock no-error.
                            	if avail cd_det then message cd_cmmt[1].
                            end.
                         "
    	     }
    
    	hide frame b no-pause.	
   		if avail pt_mstr then do:
   			global_part = pt_part.
   			{gprun.i ""xxptmt02.p""}
   		end.
   end. /* do with frame b */
   hide frame b no-pause.
   
end. /* repeat with frame a */

status input.


