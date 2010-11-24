/* By: Neil Gao Date: 20071221 ECO: *ss 20071221 * */

	{mfdtitle.i "b+ "}

define variable part like mrp_part.
define variable part2 like mrp_part.
define variable date1 as date.
define variable date2 as date.
define variable needdate  as date.
define variable needdate1 as date.
define variable loc like tr_loc.
define variable loc1 like tr_loc.
define variable buyer like pt_buyer.
define variable sonbr like so_nbr init "C".
define variable sonbr1 like so_nbr init "CZ".
define variable vend  like po_vend.
define variable expert as logical.
define variable tmpqty1 like pod_qty_ord.
define variable tmpqty2 like pod_qty_ord.

define buffer ptmstr for pt_mstr.

	 
form
	 sonbr 										colon 15 label "订单号"
	 sonbr1										colon 45 label "至"
	 date1										colon 15  label "发放日期"
	 date2										colon 45
	 needdate                 colon 15  label "需求日期"
	 needdate1                colon 45  label "至"
   part                     colon 15
   part2 label {t001.i}     colon 45 
   buyer                    colon 15
   skip(1)   
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


form
	req_so_job
	req_rel_date
	req_need
	vend
	vd_sort
	req_part
	pt_desc1
	cd_cmmt[1]
	/*vp_vend_part*/
	req_nbr
	req_qty
with frame c down width 300 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

buyer = global_userid.


	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:

   if sonbr1 = hi_char then sonbr1 = "".
   if part2 = hi_char then part2 = "".
   if date1 = low_date then date1 = ?.
   if date2 = hi_date  then date2 = ?.
   if needdate = low_date then needdate = ?.
   if needdate1 = hi_date  then needdate1 = ?.
   
		IF c-application-mode <> 'web':u THEN
	   update
	   	sonbr sonbr1
	   	date1 date2
	   	needdate needdate1
      part part2 
      buyer
			WITH FRAME a.
			
			if sonbr1 = "" then sonbr1 = hi_char.
		  if part2 = "" then part2 = hi_char.
		  if date1 = ? then  date1 = low_date.
		  if date2 = ? then date2 = hi_date.
			if needdate = ? then needdate = low_date.
			if needdate1 = ? then needdate1 = hi_date.
			
    {mfselprt.i "printer" 132}

		for each req_det where req_domain = global_domain and req_part >= part and req_part <= part2 
			and req_rel_date >= date1 and req_rel_date <= date2 
			and req_so_job >= sonbr and req_so_job <= sonbr1
			and req_need >= needdate and req_need <= needdate1
			no-lock,
			each pt_mstr where pt_domain = global_domain and pt_part = req_part
			and (pt_buyer = buyer or buyer = "" ) no-lock by req_so_job by req_part:
			
			vend = req_user1.
			find first vd_mstr where vd_domain = global_domain and vd_addr = vend no-lock no-error.
      find first vp_mstr where vp_domain = global_domain and vp_part = req_part and vp_vend = vend no-lock no-error.
      find first cd_det where cd_domain = global_domain and cd_ref = req_part and cd_lang = 'ch' 
      	and cd_type = "SC" no-lock no-error.
      
			disp vend
					 vd_sort  when ( avail vd_mstr ) format "x(20)"
					 req_part format "x(14)"
					 pt_desc1
					 cd_cmmt[1] when ( avail cd_det )
					 /*vp_vend_part when ( avail vp_mstr ) format "x(14)"*/
					 req_nbr
					 req_qty format "->>>>>>"
					 req_rel_date
					 req_need 
					 req_so_job
					 with frame c.
			down with frame c.
			/*
      if avail cd_det then do:
      	put "    " cd_cmmt[1]. 
				put skip.
			end.*/
		end.
		put " " skip.
		
		{mfreset.i}
		{mfgrptrm.i}
		

	END.

	{wbrp04.i &frame-spec = a}

    