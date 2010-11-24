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
	xxi      		label "���"
 	xxpc_part 	label "���ϴ���" format "x(18)"
	pt_desc1 		label "��������" format "x(20)"
	pt_desc2 		label "���״̬" format "x(12)"
	pt_um     	label "UM"
	xxpc_amt[2]	label "ԭ��(Ԫ)"
	xxpc_amt[1] label "�ּ�(Ԫ)"
	xxpc_user1  label "��ע" format "x(20)"
with frame e width 200 down no-attr-space.	

xxi = 0.
iy  = 0.
for each xxpc_mstr where xxpc_domain = global_domain and xxpc_nbr >= iptf1 and xxpc_nbr <=iptf2
		and xxpc_list >= iptf3 and xxpc_list <= iptf4 no-lock,
	each ad_mstr where ad_domain = global_domain and ad_addr = xxpc_list no-lock,
	each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "xxpcmstr" and usrw_key2 = xxpc_nbr
	break by xxpc_nbr by xxpc_part:
	
	
	form header
		"����ܡ�"		at 8 skip
		"�۸�Э��" 		colon 50
		"�׷�: " 			colon 8 "¡�ι�ҵ���޹�˾"
	  "ǩ�����ڣ�" 	colon  80 usrw_datefld[1]
	  "���ұ�ţ�" 	colon  80 xxpc_list 
	  "�ҷ�: " 			colon 8 ad_name  
	  "  Э��ţ�" 	colon 80 xxpc_nbr
	  skip(1) 
	  "˫�������Ѻú��������ݻ�����ԭ�򣬴�����²�Ʒ���׼۸�Э�飺" at 17
	with frame h1 page-top no-label no-box width 160.
	view frame h1.

	if first-of(xxpc_nbr) then iy = PAGE-NUMBER - 1.
	
	find first pt_mstr where pt_domain = global_domain and pt_part = xxpc_part no-lock no-error.
	find first vp_mstr where vp_domain = global_domain and vp_part = xxpc_part and vp_vend = xxpc_list no-lock no-error.
	
	xxi = xxi + 1.
	disp 	xxi label "���"
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
  	put "       һ����Э�����漰�ļ۸��Ϊ��˰�۸񣬵�λ������ң�" skip.
  	put "       ����׼ʱ����Ҫ���ҷ����밴��ǩ���Ĳ�Ʒ���׺�ͬ�۸�Э�鱣֤�׷�������" skip.
  	put "       ��������Ҫ������׼���ҷ����ռ׷��ļ�������Ҫ�����գ�������ɵ���ʧ�������ҷ��е���" skip.
  	put "       �ġ������ص㡢��ʽ���ҷ��ͻ����׷�ָ���ⷿ��" skip.
  	put "       �塢����ͬ�����۸�����г������ʱ���е�����" skip.
  	put "       ��������ͬ��Ч�ڴ� " xxpc_mstr.xxpc_start  " ��ִ�У�" skip.
  	put "       �ߡ���Э�龭˫������ǩ�ֺ󣬲��ɼ׷��ܾ���ǩ�ֺ󷽿���Ч��" skip.
  	put "       �ˡ���Э��һʽ���ݣ�ԭͬ���Ʒ���׼۸�Э�����ϣ�" skip.
  	put "       �š���Э�鹲"  xxi  " ��Ʒ�֣�" skip.
  	put "       ʮ������Լ�����" skip.
		
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

	put "       �T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" skip.
	put "�׷�:  ¡�ι�ҵ���޹�˾(����)                              �ҷ�:" at 8 iptf2 skip(2).
	put "У��: " at 8 skip(2).
	put "��׼:                                                      ����: " at 8  skip.
	put "       �T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T" skip.

	put "       ������:".
	find first usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "xxpcmstr" 
	and usrw_key2 = iptf1 no-lock no-error.
	if avail usrw_wkfl then do:
		find first usr_mstr where usr_userid = usrw_key3 no-lock no-error.
	 	if avail usr_mstr then put usr_name.
	end.
  put	"�� " at 84 string(PAGE-NUMBER - iy ,">>9") format "x(3)" "   ҳ" skip.
end. /* procedure dispyw */
