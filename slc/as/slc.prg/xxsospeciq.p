/*add by axiang 2007-12-28 订单指定件查询*/

{mfdtitle.i "1+ "}

define variable sonbr like sod_nbr.
define variable sonbr1 like sod_nbr.
define variable part like sod_part.
define variable partg1 like sod_part.
define variable j as integer.
define variable xxtemp as character format "x(76)".

form 
	 sonbr colon 15
	 sonbr1 colon 45 skip
	 part colon 15
	 part1 colon 45 skip
with frame a side-labels width 80.

setFrameLabels(frame a:handle).

repeat:
	if sonbr1 = hi_char then sonbr1 = "".
	if part1 = hi_char then part1 = "".
	
	if c-application-mode <> 'web' then
      update
      		cust
      		cust1
      		part
      		part1
      with frame a.
        
      if (c-application-mode <> "WEB") or
         (c-application-mode = "WEB") then do:
        
            bcdparm = "".
            {mfquoter.i cust       }
            {mfquoter.i cust1      }
            {mfquoter.i part       }
            {mfquoter.i part1       }
            
            if cust1 = "" then cust1 = hi_char.
            if part1 = "" then part1 = hi_char.
      end.   
      
      {mfselbpr.i "printer" 132}
                       
       for each xxsob_det where xxsob_domain = global_domain
                            and xxsob_nbr = sonbr and xxsob_parent = part and xxsob_user1 <> "" no-lock,
           each so_mstr where so_domain = global_domain and so_nbr = sonbr no-lock,
           each pt_mstr where pt_domain = global_domain
                            and pt_part = xxsob_part no-lock,
           each vd_mstr where vd_domain = global_domain
                            and vd_addr = xxsob_user1 no-lock
           break by xxsob_parent:
           		if first-of(xxsob_parent) then 
           		do:
           			find first cd_det where cd_domain = global_domain and cd_ref = xxsob_parent no-lock no-error.
           			
           			do j = 1 to 15 :
           				if (avail cd_det and cd_cmmt[j] <> "") then 
           					xxtemp = xxtemp + cd_cmmt[j].
           			end.
 
           			put "销售订单号:" at 1 xxsob_nbr.
           			put "客户:" at 23 so_cust. 
           			put "成品编号:" at 40 xxsob_parent skip.
           			put "描述:" at 1 xxtemp skip.
           		end.
           		display
           			xxsob_part column-label "物料编号"
           			pt_desc1 column-label "物料名称"
           			xxsob_user1 column-label "供应商编号"
           			vd_sort column-label "供应商名称"
           		with width 200.
           		xxtemp = "".
       end. /*for each xxsob_det*/
   end.
   else
   if sonbr <> "" and part = "" then 
   do:
   		for each xxsob_det where xxsob_domain = global_domain
                            and xxsob_nbr = sonbr and xxsob_user1 <> "" no-lock,
           each so_mstr where so_domain = global_domain and so_nbr = sonbr no-lock,
           each pt_mstr where pt_domain = global_domain
                            and pt_part = xxsob_part no-lock,
           each vd_mstr where vd_domain = global_domain
                            and vd_addr = xxsob_user1 no-lock
           break by xxsob_parent:
           		if first-of(xxsob_parent) then 
           		do:
           			find first cd_det where cd_domain = global_domain and cd_ref = xxsob_parent no-lock no-error.
           			
           			do j = 1 to 15 :
           				if (avail cd_det and cd_cmmt[j] <> "") then 
           					xxtemp = xxtemp + cd_cmmt[j].
           			end.
 
           			put "销售订单号:" at 1 xxsob_nbr.
           			put "客户:" at 23 so_cust. 
           			put "成品编号:" at 40 xxsob_parent skip.
           			put "描述:" at 1 xxtemp skip.
           		end.
           		display
           			xxsob_part column-label "物料编号"
           			pt_desc1 column-label "物料名称"
           			xxsob_user1 column-label "供应商编号"
           			vd_sort column-label "供应商名称"
           		with width 200.
           		xxtemp = "".
       end. /*for each xxsob_det*/
   end.
  
       {mfreset.i}
       {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
end. /*repeat*/
{wbrp04.i &frame-spec = a}