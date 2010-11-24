/*By: Neil Gao 08/09/01 ECO: *SS 20080901* */
/*By: Neil Gao 09/03/23 ECO: *SS 20090323* */
/* SS - 090408.1 By: Neil Gao */
/* SS - 090511.1 By: Neil Gao */

/* DISPLAY TITLE */
{mfdtitle.i "090605.1"}

define variable mc-error-number like msg_nbr no-undo.

define variable del-yn        like mfc_logical initial no.
define variable i             as integer.
define variable qty_label     as character format "x(7)" extent 3.
define variable amt_label     as character format "x(14)" extent 3.
define variable list_label    as character format "x(24)"
   .
define variable price         as character.
define variable discount      as character.
define variable markup        as character.
define variable ptable_label  as character format "x(23)".
define variable min_label     as character format "x(14)".
define variable max_label     as character format "x(14)".
define variable pcamttype     like xxpc_amt_type.
define variable old_db        like si_db.
define variable err_flag      as integer.
define variable base_curr1    like base_curr.
define variable base_curr2    like base_curr.
define variable glxcst_tl     like sct_cst_tot.
define var xxi as int format ">>>9".
define var ii as int.

define variable temp_max_price like xxpc_max_price extent 0 decimals 10
   no-undo.
define variable disp-price-discount-markup as character no-undo format "x(44)".
define variable disp-stock-um as character no-undo format "x(12)".
define variable disp-total-this-level-gl as character no-undo format "x(29)".
define variable disp-site-col as character no-undo format "x(10)".
define variable disp-total-gl-cost as character no-undo format "x(28)".
define variable msg-arg1 as character format "x(16)" no-undo.
define variable msg-arg2 as character format "x(16)" no-undo.

/* Variable added to perform delete during CIM. Record is deleted
 * Only when the value of this variable is set to "X" */
define variable batchdelete as   character format "x(1)" no-undo.
define variable l_yn        like mfc_logical             no-undo.

define var xxpcnbr like xxpc_nbr.
define var xxpcamt like xxpc_amt[1].
define buffer xxpcmstr for xxpc_mstr.
define var vend like po_vend.
define var curr like pc_curr init "RMB".
define var pctype like xxpc_amt_type init "L".
define var part like pt_part.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define var update-yn as logical.
define var sw_reset as logical. 
define var xxrmks as char format "x(60)".
define var xxrmks1 as char format "x(60)".
define var xxrmks2 as char format "x(60)".
define var xxrmks3 as char format "x(60)".
define var desc2 like pt_desc2.
define var stadesc1 as char format "x(80)".

define temp-table ttpc_mstr 
	field ttpc_part like pt_part
	field ttpc_um like pt_um
	field ttpc_start like xxpc_start
	field ttpc_amt1 like pt_price
	field ttpc_amt2 like ttpc_amt1
	field ttpc_rmks as char format "x(12)"
index ttpc_part 
			ttpc_part ttpc_start.

/* DISPLAY SELECTION FORM */
form
  xxpcnbr          colon 12 label "协议号"
  vend     			 	colon 12
  curr						colon 40
/*SS 20090323 - B*/
/*
  pctype					colon 60 label "类型"
  part						colon 12
*/
/*SS 20090323 - E*/
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	ttpc_part label "物料号"
	ttpc_um   label	"单位"
	ttpc_start label "开始日期"
	ttpc_amt2 label "老价格"
	ttpc_amt1 label "新价格"
	ttpc_rmks label "备注"
with frame c down width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
	xxi      label "序号"
 	ttpc_part label "物料代码" format "x(16)"
	pt_desc1 label "物料名称" format "x(20)"
	pt_desc2 label "规格状态" format "x(12)"
	pt_um     label "UM"
	xxpc_mstr.xxpc_amt[2]	label "原价(元)"
	xxpc_amt[1] label "现价(元)"
	xxrmks   label "备注" format "x(12)"
with frame e width 200 down no-attr-space.	

/* DISPLAY */
view frame a.

main-loop:
repeat with frame a:
	
	update
      xxpcnbr
      vend
      curr
      /*part
      pctype*/
  with frame a.

	if xxpcnbr <> "" then do:
		find first usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "xxpcmstr" and usrw_key2 = xxpcnbr no-lock no-error.
		if not avail usrw_wkfl then do:
			message "错误: 协议号不存在".
			next.
		end.
		else do:
			vend = usrw_key4.
			disp vend with frame a.
			if usrw_user1 <> "" then do:
				message "错误: 已经是正式价格协议不能修改".
				next.
			end.
		end.
	end.
	
	global_addr = vend.
	
	find first vd_mstr where vd_domain = global_domain and vd_addr = vend no-lock no-error. 
  if not avail vd_mstr then do:
  	message "供应商不存在".
  	next.
  end.
  
  if xxpcnbr = "" then do:
  	{gprun.i ""xxdysnct.p"" "(input 'xxpcmstr',
  														input substring(string(year(today)),3,2) + string(month(today),'99'),
  														input vend,
  														input '',
  														input 2,
  														input '',
  														output xxpcnbr
  														)"}
 		if xxpcnbr = "" then do:
 			message "申请号没有产生".
 			next.
 		end.
  end.
  disp xxpcnbr with frame a.
  
  empty temp-table ttpc_mstr.
  for each xxpc_mstr where xxpc_domain = global_domain and xxpc_nbr = xxpcnbr
  	and xxpc_list = vend and xxpc_curr = curr no-lock:
  	
  	create 	ttpc_mstr.
  	assign 	ttpc_part 	= xxpc_part
  					ttpc_start 	= xxpc_start
  					ttpc_um 		= xxpc_um
  					ttpc_amt1		= xxpc_amt[1]
  					ttpc_rmks		= xxpc_user1.
  	
  	for last xxpcmstr where xxpcmstr.xxpc_domain = global_domain and xxpcmstr.xxpc_list = xxpc_mstr.xxpc_list
			and	xxpcmstr.xxpc_part = xxpc_mstr.xxpc_part and xxpcmstr.xxpc_curr = xxpc_mstr.xxpc_curr
			and xxpcmstr.xxpc_start < xxpc_mstr.xxpc_start
			no-lock:
			ttpc_amt2 = xxpc_amt[1].
		end.	
  		
  end.
  
  tt_recid = ?.
  first-recid = ?.
	view frame c.
	sw_reset = yes.
	pause 0.
  scroll_loop:
  repeat with frame c:
   	
  	{xxrescrad.i ttpc_mstr "use-index ttpc_part" ttpc_part
            "ttpc_part ttpc_um ttpc_start ttpc_amt2 ttpc_amt1 ttpc_rmks
            "
            ttpc_part c
            "  "
            "  "
            " find first cd_det where cd_domain = global_domain and cd_ref = ttpc_part 
                            	and cd_lang = 'ch' no-lock no-error.
             	if avail cd_det then do:  
              	message cd_cmmt[1].
                message cd_cmmt[2].
              end.  "
            "   "
            }
  	
  	if keyfunction(lastkey) = "end-error" then do:
     	update-yn = no.
      {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
      if update-yn = yes then leave.
      else do:
      	sw_reset = yes.
      	next.
      end.
    end.
    
    /* DELETE */
    else if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
    	del-yn = yes.
     	{pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
      if del-yn = yes then do:
      	for each xxpc_mstr where xxpc_domain = global_domain and xxpc_part = ttpc_part and xxpc_nbr = xxpcnbr
      		and xxpc_list = vend and xxpc_curr = curr and xxpc_um = ttpc_um and xxpc_start = ttpc_start:
      		delete xxpc_mstr.      		
      	end.
      	delete ttpc_mstr.
      	clear frame c no-pause.
      	next.
      end.
    end. /* then do: */
  	else if keyfunction(lastkey) = "return" and recno <> ? then do:
    	find first xxpc_mstr where xxpc_domain = global_domain and xxpc_part = ttpc_part and xxpc_nbr = xxpcnbr
      		and xxpc_list = vend and xxpc_curr = curr and xxpc_um = ttpc_um and xxpc_start = ttpc_start no-error.
      if avail xxpc_mstr then do:
    		update ttpc_start ttpc_amt1 ttpc_rmks with frame c.
    		assign xxpc_start = ttpc_start
    					 xxpc_amt[1] = ttpc_amt1
    					 xxpc_user1 = ttpc_rmks.
  			/* STORE MODIFY DATE AND USERID */
   			xxpc_mod_date = today.
   			xxpc_userid = global_userid.
    	end.
		end. /* if keyfunction */
		if keyfunction(lastkey) = "insert-mode" or ( keyfunction(lastkey) = "return" and recno = ?) then 
		do on error undo,retry :
			prompt-for ttpc_part with frame c.
			find first pt_mstr where pt_domain = global_domain and pt_part = input frame c ttpc_part no-lock no-error.
			if not avail pt_mstr then do:
				message "物料编码不存在".
				undo,retry.
			end.
			else do:
				disp pt_um @ ttpc_um with frame c.
			end.
			disp today @ ttpc_start with frame c.
			prompt-for ttpc_start with frame c.
			if input frame c ttpc_start = ? then disp today @ ttpc_start with frame c.
			find first xxpc_mstr where xxpc_domain = global_domain and xxpc_part = input frame c ttpc_part and xxpc_nbr = xxpcnbr
      	and xxpc_list = vend and xxpc_curr = curr and xxpc_um = pt_um and xxpc_start = input frame c ttpc_start no-error.
      if avail xxpc_mstr then do:
      	message "记录已存在不能新增".
      	undo,retry.
      end.
      else do:
      	create ttpc_mstr.
      	assign ttpc_part = input frame c ttpc_part
      				 ttpc_um 	 = pt_um
      				 ttpc_start = input frame c ttpc_start.
      	create xxpc_mstr.
      	assign xxpc_domain = global_domain
      				 xxpc_nbr = xxpcnbr
         			 xxpc_list = vend
         			 xxpc_curr = curr
         			 xxpc_part = ttpc_part
         			 xxpc_start = ttpc_start
         			 xxpc_amt_type = pctype 
         			 xxpc_um = pt_um.
      end.

			disp 0 @ ttpc_amt2 with frame c.
			for last xxpcmstr where xxpcmstr.xxpc_domain = global_domain and xxpcmstr.xxpc_list = xxpc_mstr.xxpc_list and
					xxpcmstr.xxpc_part = xxpc_mstr.xxpc_part and xxpcmstr.xxpc_curr = xxpc_mstr.xxpc_curr and 
					xxpcmstr.xxpc_start < xxpc_mstr.xxpc_start
					no-lock:
					ttpc_amt2 = xxpcmstr.xxpc_amt[1].
					xxpc_mstr.xxpc_amt[2] = ttpc_amt2.
					disp xxpcmstr.xxpc_amt[1] @ ttpc_amt2 with frame c.
			end.
      
     	update ttpc_amt1 ttpc_rmks with frame c.
     	xxpc_amt[1] = ttpc_amt1.
      xxpc_user1  = ttpc_rmks.
      down 1 with frame c.
		end.
  	else if keyfunction(lastkey) = "go" then do:
  		{gprun.i ""xxgpcmmt.p"" "(input xxpcnbr,input 'CH',input 'SC')"}
		  leave scroll_loop.
		end.
		
	end. /* scroll_loop */

/* SS 090605.1 - B */
/*删除空记录*/
	find first xxpc_mstr where xxpc_domain = global_domain and xxpc_nbr = xxpcnbr no-error.
	if not avail xxpc_mstr then do:
		for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "xxpcmstr" and usrw_key2 = xxpcnbr :
      delete usrw_wkfl.
    end.
    xxpcnbr = "".
    next.
	end.
/* SS 090605.1 - E */  
  
  {mfselprt.i "printer" 100}
  
  {gprun.i ""xxrqpgyrp.p"" "(input xxpcnbr,input xxpcnbr,input vend ,input vend)"}
   	
  {mfreset.i}
	{mfgrptrm.i}


  
end. /* repeat with frame a: */

status input.
