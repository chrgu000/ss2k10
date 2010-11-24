/* By: Neil Gao Date: 07/12/20 ECO: * ss 20071220 */

{mfdtitle.i "1" }   

define var sodnbr 	like sod_nbr.
define var sodline 	like sod_line .
define var xxseqid  like xxsov_seqid.
define var fix1     as char format "x(18)".
define var fix2     as char format "x(18)".
define var fix3_int     as inte format ">>>>>>>>>>>9".
define var fix4_int    as inte format ">>>>>>>>>>9".
DEFINE VARIABLE i as inte .
form
   sodnbr     colon 15 label "订单"
   sodline    colon 15 label "项次" format ">>>"
   sod_part colon 35 no-label 
   skip(1)
   fix1       colon 15 label "客户机型(前缀)"
   sod__chr01 colon 15 label "VIN(机号)规则" nr_desc colon 35 no-label
   fix2       colon 15 label "后缀"
   fix3_int       colon 15 label "最大值99999999"
   fix4_int       colon 15 label "初始值(1---->)"   
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
	
/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
	/*display "" @ sod_part 
		"" @ nr_desc

		with frame a .
   */
   	update 
   		sodnbr 
   		sodline
   	with frame a.
   
   	find first sod_det where sod_domain = global_domain and sod_nbr = sodnbr and sod_line = sodline no-error.
   	if not avail sod_det then do:
   		message "订单项不存在".
   		next.
  	end.
	else do: display sod_part with frame a .
		if sod__chr01 = "tj01" then assign sod__chr01 = "tj001" .
	end.
  	
  	fix1 = "".
  	fix2 = "".
  	fix3_int = 0.
  	fix4_int = 0.

	if fix1 = "" then fix1 = caps(substring(sod_part,1,4)) .	/*---Add by davild 20080303.1*/
  	find first xxsov_mstr where xxsov_domain = global_domain and xxsov_nbr = sod_nbr and xxsov_line = sod_line
  			/*and xxsov_seqid = sod__chr01*/ no-error.
  	if avail xxsov_mstr then assign fix1 = xxsov_fix1 .
	if avail xxsov_mstr and xxsov_seqid = "tjtmp" then 
		do:	
			if trim(xxsov_fix3) = "" then assign xxsov_fix3 = "9999999,1" .
			assign
				fix2 = xxsov_fix2
				fix3_int = int(trim(entry(1,xxsov_fix3,",")))
				fix4_int = int(trim(entry(2,xxsov_fix3,",")))
				.	/*---Add by davild 20080421.1*/

		end.
  	/*else do:
  		find first xxbcbc_item where xxbcbc_lng = "ch" and xxbcbc_part = sod_part no-lock no-error.
			if avail xxbcbc_item then fix1 = xxbcbc_char01.
  	end.*/	/*---Remark by davild 20080303.1*/
	
  	xxseqid = sod__chr01.
  	disp fix1 sod__chr01 fix2 fix3_int fix4_int with frame a.
  	
  	find first xxsovd_det where xxsovd_domain = global_domain and xxsovd_nbr = sod_nbr and xxsovd_line = sod_line
  		and xxsovd_seqid = sod__chr01 no-lock no-error.
  	if avail xxsovd_det then do:
  		message "记录存在,请确认是否修改".
  		pause.
  	end.
  	
	sub:
	repeat:		/*---Add by davild 20080303.1*/
		find first nr_mstr where nr_domain = global_domain and nr_seqid = sod__chr01 no-lock no-error.
		if avail nr_Mstr then  display nr_desc with frame a .
		update fix1 sod__chr01 with frame a.
		/*if length(sod__chr01) <> 5 then do:
			message "VIN(机号)规则只能为5位" view-as alert-box .
			undo sub ,retry sub.
			next-prompt sod__chr01 .
		end.*/	/*---Remark by davild 20080421.1*/
		find first nr_mstr where nr_domain = global_domain and nr_seqid = sod__chr01 no-lock no-error.
	        if not avail nr_mstr then do:
			message sod__chr01 "号码范围不存在".
			undo sub ,retry sub.
			next-prompt sod__chr01 .
		end.
		else do: display nr_desc with frame a . 
			/*---Add Begin by davild 20080421.1*/
			repeat:
				if sod__chr01 <> "tjtmp" then leave .
				message "最大值(有几位输入几个9)" .
				update fix2 fix3_int fix4_int with frame a .
				if fix3_int = 0 or fix4_int = 0 then do :
					message "最大值(有几位输入几个9)和起始值不能为0." .
					next .
				end.
				if fix3_int < fix4_int then do:
					message "最大值(有几位输入几个9)不能小于起始值." .
					next .
				end.
				leave .
			end.
			/*---Add End   by davild 20080421.1*/
			leave . 
		end.
	end.	/*---Add by davild 20080303.1*/	
		find first xxsov_mstr where xxsov_domain = global_domain and xxsov_nbr = sod_nbr and xxsov_line = sod_line
				/*and xxsov_seqid = xxseqid*/	/*---Remark by davild 20080421.1*/
				no-error.
		/*if avail xxsov_mstr and xxseqid <> sod__chr01 then do:
				
			delete xxsov_mstr.
			release xxsov_mstr.
		end.*/	/*---Remark by davild 20080421.1*/
		if not avail xxsov_mstr then do:
				create xxsov_mstr.
				assign xxsov_domain = global_domain 
					 xxsov_nbr = sod_nbr
					 xxsov_line = sod_line
					 xxsov_part = sod_part
					 xxsov_seqid = sod__chr01
					 xxsov_seg_format = nr_seg_format
					 xxsov_userid = global_userid.
		end.
		xxsov_fix1 = caps(fix1) .
		xxsov_seqid = sod__chr01 .
		xxsov_seg_type = "" .
		if xxsov_seqid =  "tjtmp" then assign
			xxsov_fix2 = caps(fix2)
			xxsov_fix3 = string(fix3_int) + "," + string(fix4_int) .	/*---Add by davild 20080421.1*/
		else assign xxsov_fix2 = "" xxsov_fix3 = "" .
  	
end. /* repeat with frame a */

status input.


