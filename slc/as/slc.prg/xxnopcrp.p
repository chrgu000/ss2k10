/*By: Neil Gao 08/06/04 ECO: *SS 20080604* */
/*By: Neil Gao 08/06/22 ECO: *SS 20080622* */


	{mfdtitle.i "b+ "}

define variable part like mrp_part.
define variable part2 like mrp_part.
define variable date as date .
define variable date2 as date.
define variable pline like pt_prod_line.
define variable pline1 like pt_prod_Line.
define variable effdate as date init today.
define var vend like po_vend.
define var vend1 like po_vend.
define var ifdisp as logical.
define buffer ptmstr for pt_mstr.

	DEFINE VARIABLE wpage     AS integer format ">>>" init 1.
	DEFINE VARIABLE wct_desc  LIKE ct_desc NO-UNDO.
	DEFINE VARIABLE i		AS	INTEGER.
	DEFINE VARIABLE xxrmk as char format "x(4)" label "其他".
	DEFINE VARIABLE xxi   as int label "序" format ">>>" .
	define variable v_ok  as logical.
	define variable adname like ad_name.
	define variable xxqty1 like tr_qty_loc.
	define variable xxqty2 like tr_qty_loc.
	define variable xxdesc2 like pt_desc2.
	define variable xxcmmt as char.
	define variable xxii    as int.
form
	 vend                     colon 15
	 vend1  									colon 45
   part                     colon 15
   part2 label {t001.i}     colon 45 
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:

   if part2 = hi_char then part2 = "".
   if vend1 = hi_char then vend1 = "".

		IF c-application-mode <> 'web':u THEN
	   update
	   	vend vend1
      part part2
			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "vend vend1 part part2"
			&frm = "a"}

		  if part2 = "" then part2 = hi_char.
		  if vend1 = "" then vend1 = hi_char.

    {mfselprt.i "printer" 650}

		xxi   = 1.
		
		put ";;未签协议物料查询" skip.
		
		put "供应商;"	"物料号;"	"物料名称;"	"物料描述;"	"老机型;" "比例;" SKIP.
		
		for each pt_mstr where pt_domain = global_domain and pt_domain = global_domain 
			and pt_part >= part and pt_part <= part2 and pt_pm_code = "P" no-lock :
		
			xxcmmt = "".
			find first cd_det where cd_domain = global_domain and cd_ref = pt_part and cd_type = "SC" and cd_lang = "CH" no-lock no-error.
			if avail cd_det then do:
				repeat xxii = 1 to 15 :
					xxcmmt = xxcmmt + cd_cmmt[xxii].
				end.
				xxcmmt = replace(xxcmmt,";"," ").
			end.
			
			xxdesc2 = pt_desc2.
			find first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = substring(xxdesc2,1,4) no-lock no-error.
			ifdisp = no.
			for each vp_mstr where vp_domain = global_domain and vp_part = pt_mstr.pt_part
				and vp_vend >= vend and vp_vend <= vend1
				and vp_tp_pct > 0 and vp_vend <> "" no-lock:
			
				find last xxpc_mstr where xxpc_domain = global_domain and xxpc_part = vp_part and (xxpc_start <= today or xxpc_start = ?) 
    		and xxpc_list = vp_vend and (xxpc_expire >= today or xxpc_expire = ?) no-lock no-error.
				if avail xxpc_mstr then next.
				
				put unformat 	vp_vend ";"
											vp_part ";"
											pt_mstr.pt_desc1 ";"
											xxcmmt ";".
				if avail ptmstr then put ptmstr.pt_desc1.
				put ";".
				put vp_tp_pct ";" skip.
				ifdisp = yes.
			end.
			
			if not ifdisp and vend = "" then do:
				find last xxpc_mstr where xxpc_domain = global_domain and xxpc_part = pt_mstr.pt_part and (xxpc_start <= today or xxpc_start = ?) 
    			and (xxpc_expire >= today or xxpc_expire = ?) no-lock no-error.
				if not avail xxpc_mstr then do:
					put unformat ";" pt_mstr.pt_part ";" pt_mstr.pt_desc1 ";" xxcmmt ";".
					if avail ptmstr then put ptmstr.pt_desc1 ";" .
					put skip.
				end.
			end.
		end.
		
		{mfreset.i}
		{mfgrptrm.i}
		

	END.

	{wbrp04.i &frame-spec = a}

    