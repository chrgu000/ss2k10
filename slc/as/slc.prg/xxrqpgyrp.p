/* SS - 090522.1 By: Neil Gao */

{mfdeclre.i}

define input parameter iptf1 like xxpc_nbr.
define input parameter iptf2 like xxpc_nbr.
define input parameter iptf3 like po_vend.
define input parameter iptf4 like po_vend.
define var xxi as int format ">>9".
define var xxj as int.
define var stadesc1 as char.
define var desc2 like pt_desc2.
define buffer xxpcmstr for xxpc_mstr.
define var ii as int.
define var iy as int.
define var xxc as char format "x(6)".

form
	xxc         no-label
	xxi      		label "序号"
 	xxpc_part 	label "物料代码" format "x(18)"
	pt_desc1 		label "物料名称" format "x(20)"
	pt_desc2 		label "规格状态" format "x(12)"
	pt_um     	label "UM"
	xxpc_amt[2]	label "原价(元)"
	xxpc_amt[1] label "现价(元)"
	xxpc_user1  label "备注" format "x(20)"
with frame e width 200 down no-attr-space.	

xxi = 0.
iy  = 0.
for each xxpc_mstr where xxpc_domain = global_domain and xxpc_nbr >= iptf1 and xxpc_nbr <=iptf2
		and xxpc_list >= iptf3 and xxpc_list <= iptf4 no-lock,
	each ad_mstr where ad_domain = global_domain and ad_addr = xxpc_list no-lock,
	each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "xxpcmstr" and usrw_key2 = xxpc_nbr
	break by xxpc_nbr by xxpc_part:
	
	
	form header
		"★绝密★"		at 8 skip
		"价格协议" 		colon 50
		"甲方: " 			colon 8 "隆鑫工业有限公司"
	  "签订日期：" 	colon  80 usrw_datefld[1]
	  "厂家编号：" 	colon  80 xxpc_list 
	  "乙方: " 			colon 8 ad_name  
	  "  协议号：" 	colon 80 xxpc_nbr
	  skip(1) 
	  "双方本着友好合作、互惠互利的原则，达成以下产品配套价格协议：" at 17
	with frame h1 page-top no-label no-box width 160.
	view frame h1.

	if first-of(xxpc_nbr) then iy = PAGE-NUMBER - 1.
	
	find first pt_mstr where pt_domain = global_domain and pt_part = xxpc_part no-lock no-error.
	find first vp_mstr where vp_domain = global_domain and vp_part = xxpc_part and vp_vend = xxpc_list no-lock no-error.
	
	xxi = xxi + 1.
	disp 	xxi label "序号"
				xxpc_part 
				pt_desc1
				pt_desc2
				pt_um 
				xxpc_amt[1]
				xxpc_user1
				with frame e no-attr-space.
	desc2 = pt_desc2.
	find first pt_mstr where pt_domain = global_domain and pt_part = substring(desc2,1,4) no-lock no-error.
	if avail pt_mstr then disp pt_desc1 @ pt_desc2 with frame e.
	
	find last xxpcmstr where xxpcmstr.xxpc_domain = global_domain and xxpcmstr.xxpc_part = xxpc_mstr.xxpc_part 
		and xxpcmstr.xxpc_list = xxpc_mstr.xxpc_list and xxpcmstr.xxpc_start < xxpc_mstr.xxpc_start no-lock no-error.
	if avail xxpcmstr then	disp xxpcmstr.xxpc_amt[1] @ xxpc_mstr.xxpc_amt[2] with frame e.
	else disp "" @ xxpc_mstr.xxpc_amt[2] with frame e.
	
	stadesc1 = "".
	find first cd_det where cd_domain = global_domain and cd_ref = xxpc_mstr.xxpc_part and cd_type = "SC" and cd_lang = "ch" no-lock no-error.
	if avail cd_det then do:
		repeat ii = 1 to 10:
			stadesc1 = stadesc1 + cd_cmmt[ii].
		end.
	end.
	put stadesc1 at 27 format "x(80)" skip .
	
	if line-counter + 12 >= page-size then do:
		run dispyw ( input xxpc_mstr.xxpc_nbr ,input ad_name).
		page.
	end.
	
	if last-of(xxpc_mstr.xxpc_nbr) then do:
		
		if line-counter + 22 >= page-size then do:
			 run dispyw ( input xxpc_mstr.xxpc_nbr,input ad_name).
			 page.
		end.
		put skip(1).
  	put "       一、本协议所涉及的价格均为含税价格，单位：人民币；" skip.
  	put "       二、准时供货要求：乙方必须按所签定的产品配套合同价格协议保证甲方供货；" skip.
  	put "       三、质量要求技术标准：乙方按照甲方的技术质量要求验收，否则造成的损失金额概由乙方承担；" skip.
  	put "       四、交货地点、方式：乙方送货到甲方指定库房；" skip.
  	put "       五、本合同所订价格根据市场情况随时进行调整；" skip.
  	put "       六、本合同有效期从 " xxpc_mstr.xxpc_start  " 起执行；" skip.
  	put "       七、本协议经双方代表签字后，并由甲方总经理签字后方可生效；" skip.
  	put "       八、本协议一式三份，原同类产品配套价格协议作废；" skip.
  	put "       九、本协议共"  xxi  " 个品种；" skip.
  	put "       十、其它约定事项：" skip.
		
		for each cd_det where cd_domain = global_domain and cd_ref = xxpc_mstr.xxpc_nbr and cd_type = "SC" 
			and cd_lang = "ch" no-lock:
			repeat xxj = 1 to 15:
				if cd_cmm[xxj] <> "" then put cd_cmmt[xxj] at 8 skip.
			end.
		end.		
		
		
		run dispyw ( input xxpc_mstr.xxpc_nbr,input ad_name).
		if not last( xxpc_mstr.xxpc_nbr ) then	page.
		xxi = 0.
		
	end.
end. /* for each xxpc_mstr */


procedure dispyw :
	define input parameter iptf1 like xxpc_nbr.
	define input parameter iptf2 like ad_name.
	repeat while line-counter + 10 < page-size:
		put skip(1).
	end.

	put "       ═════════════════════════════════════════════════════" skip.
	put "甲方:  隆鑫工业有限公司(盖章)                              乙方:" at 8 iptf2 skip(2).
	put "校核: " at 8 skip(2).
	put "批准:                                                      代表: " at 8  skip.
	put "       ═════════════════════════════════════════════════════" skip.

	put "       编制人:".
	find first usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "xxpcmstr" 
	and usrw_key2 = iptf1 no-lock no-error.
	if avail usrw_wkfl then do:
		find first usr_mstr where usr_userid = usrw_key3 no-lock no-error.
	 	if avail usr_mstr then put usr_name.
	end.
  put	"第 " at 84 string(PAGE-NUMBER - iy ,">>9") format "x(3)" "   页" skip.
end. /* procedure dispyw */
