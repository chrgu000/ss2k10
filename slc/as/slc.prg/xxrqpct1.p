/*By: Neil Gao 08/09/01 ECO: *SS 20080901* */
/*By: Neil Gao 09/03/23 ECO: *SS 20090323* */
/* SS - 090408.1 By: Neil Gao */
/* SS - 090511.1 By: Neil Gao */


/* DISPLAY TITLE */
{mfdtitle.i "090511.2"}

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
	part label "物料号"         colon 12 	pt_desc1 colon 40 no-label
	pt_um colon 12											 	pt_desc2 colon 40 no-label
	skip(1)
	xxpc_start label "开始日期" colon 12
	xxpcamt label "老价格"      colon 12
	xxpc_amt[1] label "新价格"  colon 12
	xxpc_user1 label "备注" format "x(40)" colon 12
with frame c side-labels width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

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
	
	find first vd_mstr where vd_domain = global_domain and vd_addr = vend no-lock no-error. 
  if not avail vd_mstr then do:
  	message "错误: 供应商不存在".
  	next.
  end.	
	
	if xxpcnbr <> "" then do:
		find first usrw_wkfl where usrw_domain = global_domain and usrw_key1 = "xxpcmstr" and usrw_key2 = xxpcnbr no-lock no-error.
		if not avail usrw_wkfl then do:
			create 	usrw_wkfl.
  		assign 	usrw_domain = global_domain
  						usrw_key1 = "xxpcmstr" 
  						usrw_key2 = xxpcnbr
  						usrw_key3 = global_userid
  						usrw_key4 = vend
  						usrw_datefld[1] = today.
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
 			message "错误: 申请号没有产生".
 			next.
 		end.
  end.
  disp xxpcnbr with frame a.
  		
  view frame c.
	
	scroll_loop:
  repeat:
  	
  	update part with frame c.
  	
  	find first pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error.
  	if not avail pt_mstr then do:
  		message "错误: 物料号不存在".
  		next.
  	end.
  	disp pt_um pt_desc1 pt_desc1 with frame c.
  	
  	xxpcamt = 0.
  	for last xxpcmstr where xxpcmstr.xxpc_domain = global_domain and xxpcmstr.xxpc_list = vend 
			and	xxpcmstr.xxpc_part = part and xxpcmstr.xxpc_curr = curr and	xxpcmstr.xxpc_nbr < xxpcnbr	no-lock:
			xxpcamt = xxpcmstr.xxpc_amt[1].
		end.
    disp xxpcamt with frame c.
  	
  	do on error undo,retry :
    
  		find first xxpc_mstr where xxpc_domain = global_domain and xxpc_part = part and xxpc_nbr = xxpcnbr
    		and xxpc_list = vend and xxpc_curr = curr no-error.
    	if not avail xxpc_mstr then do:
    		create xxpc_mstr.
      	assign xxpc_domain = global_domain
      			 xxpc_nbr = xxpcnbr
       			 xxpc_list = vend
      	 		 xxpc_curr = curr
       			 xxpc_part = part
       			 xxpc_amt_type = pctype 
       			 xxpc_um = pt_um
       			 xxpc_start = today.
       			 .
    	end.
    
    	update xxpc_start xxpc_amt[1] xxpc_user1 with frame c.
    	if xxpc_start = ? then do:
    		message "错误: 生效日期不能为空".
    		undo,retry.
    	end.
    	
    end.
     	
	end. /* scroll_loop */  
      
end. /* repeat with frame a: */

status input.
