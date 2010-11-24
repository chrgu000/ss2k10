/*By: Neil Gao 08/05/19 ECO: *SS 20080519* */
/* SS - 090812.1 By: Randy Li */
/* SS - 091020.1 By: Neil Gao */
/* SS - 100301.1 By: Randy Li */

{mfdtitle.i "100301.1"}

/* SS - 100301.1 - B
define variable yr like glc_year.
define variable per like glc_per.
SS - 100301.1 - E */
define variable part like mrp_part.
define variable part2 like mrp_part.
/* SS - 100301.1 - B
define variable date as date .
define variable date2 as date.
SS - 100301.1 - E */
define variable effdate as date init today.
/* SS - 100301.1 - B
define variable xxdesc2 like pt_desc2.
define variable vend like po_vend.
define variable vend1 like po_vend.
define variable tmppct like vp_tp_pct.
SS - 100301.1 - E */
define variable tmpprice like pt_price.
/* SS - 100301.1 - B
define variable tmpprice1 like pt_price.
define variable tmpint   as int.
SS - 100301.1 - E */
define variable ifdr as logical.
/* SS - 100301.1 - B
DEFINE VARIABLE wpage     AS integer format ">>>" init 1.
DEFINE VARIABLE wct_desc  LIKE ct_desc NO-UNDO.
DEFINE VARIABLE i		AS	INTEGER.
DEFINE VARIABLE xxrmk as char format "x(4)" label "其他".
DEFINE VARIABLE xxi   as int label "序" format ">>>" .
define variable v_ok  as logical.
define variable adname like ad_name.
define variable xxqty1 like tr_qty_loc.
define variable xxqty2 like xxqty1.
define variable xxqty3 like xxqty1.
SS - 100301.1 - E */
/* SS - 090812.1 - B */
define buffer ptmstr for pt_mstr.
DEFINE VARIABLE fromset like cs_set.
DEFINE VARIABLE site like si_site.
DEFINE VARIABLE sumdesc as char .
DEFINE temp-TABLE tmp_cb 
	field tmp_part like pt_part 
	field tmp_price like pt_price
	.


/* SS - 090812.1 - E */
 
form
/* SS - 090812.1 - B
yr											colon 15 
per											colon 15
SS - 090812.1 - E */
/* SS - 090812.1 - B */
site						colon 15
fromset						colon 15
effdate						colon 15
/* SS - 090812.1 - E */
part						colon 15
part2 label {t001.i}		colon 45
ifdr						colon 15 label "是否导入"
skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
mainloop:
REPEAT ON ENDKEY UNDO, LEAVE:
	/* SS - 090812.1 - B */
	for each tmp_cb :
		delete tmp_cb .
	end.
	/* SS - 090812.1 - E */

	if part2 = hi_char then part2 = "".
	/* SS - 090812.1 - B
	if vend1 = hi_char then vend1 = "".
	SS - 090812.1 - E */
	IF c-application-mode <> 'web':u THEN
	
	/* SS - 090812.1 - B
	update yr per part part2 ifdr WITH FRAME a.
	SS - 090812.1 - E */

	/* SS - 090812.1 - B */
	update site fromset effdate part part2 ifdr with frame a.
	/* SS - 090812.1 - E */

	if part2 = "" then part2 = hi_char.
	
	 /* SS - 090812.1 - B */
	find first si_mstr where si_domain = global_domain and si_site = site no-lock no-error .
	if not avail si_mstr then do :
		message "地点不存在，请重新输入！" .
		next .
	end.
	find first cs_mstr where cs_domain = global_domain and cs_set = fromset no-lock no-error .
	if not avail cs_mstr then do :
		message "成本集不存在，请重新输入！" .
		next.
	end.
	 /* SS - 090812.1 - E */

	  /* SS - 090812.1 - B
	  find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
	  if not avail glc_cal then do:
		message "期间不存在".
		next.
	  end.
	  date 	= glc_start.
	  date2 = glc_end.  
	{mfselprt.i "printer" 650}
	SS - 090812.1 - E */
/* SS - 100301.1 - B	
	for each pt_mstr where pt_domain = global_domain and pt_part >= part and pt_part <= part2 no-lock:

		for each vp_mstr where vp_domain = global_domain and vp_part = pt_part and vp_vend <> "" and vp_tp_pct <> 0 no-lock
			break by vp_part:
SS - 100301.1 - E */

/* SS - 090812.1 - B
			find last xxpc_mstr where xxpc_domain = global_domain and xxpc_list = vp_vend and xxpc_part = vp_part and
			(xxpc_start = ? or xxpc_start <= today ) and xxpc_amt[1] <> 0 and
			(xxpc_expire = ? or xxpc_expire >= today )
			no-lock no-error.
SS - 090812.1 - E */

/* SS - 100301.1 - B	
			find last xxpc_mstr where xxpc_domain = global_domain and xxpc_list = vp_vend and xxpc_part = vp_part and
SS - 100301.1 - E */

/* SS 091020.1 - B */
/* SS - 100301.1 - B
			xxpc_nbr <> "" and xxpc_approve_userid <> "" and
SS - 100301.1 - E */
/* SS 091020.1 - E */
/* SS - 100301.1 - B
			(xxpc_start = ? or xxpc_start <= effdate ) and xxpc_amt[1] <> 0 and
			(xxpc_expire = ? or xxpc_expire >= effdate )
			no-lock no-error.
			if avail xxpc_mstr then do:
SS - 100301.1 - E */
/* SS 091020.1 - B */
/*
				tmpprice = tmpprice + xxpc_amt[1] * vp_tp_pct / 100 .
				tmpprice1 = tmpprice1 + xxpc_amt[1].
				tmpint = tmpint + 1.
*/
	for each xxpc_mstr where xxpc_domain = global_domain
		and xxpc_nbr <>""
		and xxpc_approve_userid <> ""
		and xxpc_part >= part 
		and xxpc_part <= part2
		and (xxpc_start = ? or xxpc_start <= effdate )
		and (xxpc_expire = ? or xxpc_expire >= effdate) 
		and xxpc_amt[1] <> 0
		no-lock 
		break  by xxpc_list by xxpc_part by xxpc_start:
		find first ptmstr where ptmstr.pt_domain = global_domain and  ptmstr.pt_part = xxpc_part no-lock no-error.
			if not avail ptmstr then next .
			if last-of(xxpc_part) then do:
/* SS - 090812.1 - B */

				find first tmp_cb where tmp_part = xxpc_part no-error .
				if not avail tmp_cb then do :
					create tmp_cb .
					tmp_part = xxpc_part .
					tmp_price = xxpc_amt[1] .
				end.
				else do:
					if tmp_price < xxpc_amt[1] then tmp_price = xxpc_amt[1].
				end.
/* SS - 090812.1 - E */
			tmpprice = 0.
			end.

	end.

/* SS 091020.1 - E */
/*
			end.
			else do:
				tmppct = tmppct + vp_tp_pct.
			end.
			if last-of(vp_part) then do:
*/
/* SS 091020.1 - B */
/*
				if tmpint > 0 then tmpprice = tmpprice + tmpprice1 / tmpint * tmppct / 100.
				tmpprice = round(tmpprice,4).

				tmpprice = round(tmpprice1,4).
*/
/* SS 091020.1 - E */


/* SS - 100301.1 - B
				tmpprice1	= 0.
				tmpint 		= 0.
				tmppct		= 0.

			end.
		end.
SS - 100301.1 - E */

/* SS - 090812.1 - B */
	for each tmp_cb no-lock :
				if ifdr and tmp_price > 0  then do:
					&GLOBAL-DEFINE dputline1 "" .
					&GLOBAL-DEFINE dputline2 "" .
					&GLOBAL-DEFINE dputline3 "" .
					&GLOBAL-DEFINE dputline4 "" .
					&GLOBAL-DEFINE dputline5 "" .
					&GLOBAL-DEFINE dputline6 "" .
					{xxtcimmd.i 	&putline1 = "no"

						/* SS - 090812.1 - B */
						&putline2 = "tmp_part ' ' site"
						&putline3 = "fromset"
						/* SS - 090812.1 - E */
						&putline4 = "'物料 ' tmp_price"
						&putline5 = "'.'"
						&putline6 = "'.'"
						&execname = "ppcsbtld.p"
					   }
				end.
	end.
/* SS - 090812.1 - B	
				else if not ifdr then do:
					disp pt_part pt_desc1 pt_desc2 tmpprice label "成本" with width 120.
				end.
SS - 090812.1 - E */

	{mfselprt.i "printer" 650}
	for each tmp_cb no-lock :
		find first ptmstr where ptmstr.pt_domain = global_domain 
			and ptmstr.pt_part = tmp_part
			no-lock no-error
			.
		find first cd_det where cd_domain  = global_domain 
			and cd_ref = tmp_part
			and cd_type = "SC" 
			and cd_lang = "CH"
			no-lock no-error
			.
		if avail cd_det then sumdesc = trim(cd_cmmt[1]) + trim(cd_cmmt[2]) + trim(cd_cmmt[3]) .
		else sumdesc = "".
		display 
			tmp_part				column-label "物料编码"
			ptmstr.pt_desc1			column-label "物料名称"
			tmp_price				column-label "最高成本"
			sumdesc					column-label "物料描述" format "x(234)"
			with stream-io width 320 .
	end.
/* SS - 090812.1 - E */
	
	{mfreset.i}
	{mfgrptrm.i}


END.

{wbrp04.i &frame-spec = a}