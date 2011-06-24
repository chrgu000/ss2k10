/*By: Neil Gao 08/05/13 ECO: *SS 20080513* */

{mfdtitle.i "1+ "}
{apconsdf.i} 

define variable nbr like po_nbr.
define variable nbr1 like po_nbr.
define variable vend like po_vend.
define variable vend1 like po_vend.
define variable part like pt_part.
define variable part1 like pt_part.
define variable ordate like prh_rcp_date.
define variable ordate1 like prh_rcp_date.
define variable duedate as date.
define variable duedate1 as date.
define variable buyer  like po_buyer.
define variable fclose as logical init yes.
define variable sonbr like so_nbr.
define variable i as int.

form
	 ordate       colon 15 label "订单日期"
	 ordate1      colon 49 label "至"
	 duedate      colon 15
	 duedate1     colon 49
   vend         colon 15
   vend1        colon 49 skip
   nbr          colon 15
   nbr1         colon 49 skip
   part         colon 15
   part1        colon 49 skip
   buyer        colon 15 label "配套员"
   fclose       colon 15 label "不显示关闭"
   skip(1)
with frame a side-labels width 80.

setFrameLabels(frame a:handle).

{wbrp01.i}

buyer = global_userid.

repeat:
	if part1 = hi_char then part1 = "".
	if nbr1 = hi_char then nbr1 = "".
	if vend1 = hi_char then vend1 = "".
	if duedate = low_date then duedate = ?.
	if duedate1 = hi_date then duedate1 = ?.
	if ordate  = low_date then ordate = ?.
	if ordate1 = hi_date  then ordate1 = ?.
	
	if c-application-mode <> 'web' then
	update
		ordate ordate1
		duedate duedate1
		vend vend1
		nbr  nbr1
		part part1
		buyer
		fclose
	with frame a.
	
      if part1 = "" then part1 = hi_char.
      if nbr1 = "" then nbr1 = hi_char.
      if vend1 = "" then vend1 = hi_char.
      if duedate = ? then duedate = low_date.
      if duedate1 = ? then duedate1 = hi_date.
      if ordate = ? then ordate = low_date.
      if ordate1 = ? then ordate1 = hi_date.

   /* OUTPUT DESTINATION SELECTION */
   {mfselprt.i "printer" 132}          
    
    for each po_mstr where po_nbr >= nbr and po_nbr <= nbr1 
        and po_vend >= vend and po_vend <= vend1 and (not fclose or po_stat = "")
        /*and (buyer = "" or po_buyer = buyer) */
    		and po_ord_date >= ordate and po_ord_date <= ordate1 no-lock,
    		each pod_det where pod_nbr = po_nbr and pod_part >= part and pod_part <= part1 
    		and pod_due_date >= duedate and pod_due_date <= duedate1
    		and (not fclose or pod_status = "") 
    		and (not fclose or pod_qty_ord > pod_qty_rcvd ) no-lock ,
    		each pt_mstr where pt_part = pod_part 
    			and (buyer = "" or pt_buyer = buyer) no-lock
    		by pod_due_date by po_vend
    		with frame c width 200:
    
        	setFrameLabels(frame c:handle).
        		
        	find first ad_mstr where ad_addr = po_vend no-lock no-error.        	
        	find first usr_mstr where usr_userid = pt_buyer no-lock no-error.
        	
        	find first oa_det where oa_nbr = pod_nbr and oa_line = string(pod_line)
        	 and oa_code = 1004 and oa_part = pod_part no-lock no-error.
        	
        	disp
        		po_ord_date
        		oa_to_date  when avail oa_det
        		pod_due_date
        		po_vend
        		ad_name when avail ad_mstr
        		pod_nbr
        		pod_line
        		pod_part
        		pt_desc1 
        		pt_um
        		pod_qty_ord
        		pod_qty_rcvd
        		/*usr_name when avail usr_mstr format "x(8)"*/
        	with frame c.
        	down with frame c.
        	
     end. /*for each po_mstr*/
     put skip(1).
   {mfreset.i}
		{mfgrptrm.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}           
 
end. /*repeat*/

{wbrp04.i &frame-spec = a}
