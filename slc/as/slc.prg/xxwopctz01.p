/*By: Neil Gao 08/09/01 ECO: *SS 20080901* */

{mfdeclre.i}  
{gplabel.i} 

define new shared var site like pt_site.
define var stdate as date label "日期".
define var date1 as date.
define var date2 as date.
define var sonbr  like so_nbr.
define var sonbr1 like so_nbr.
define var ord		like so_ord_date.
define var ord1		like so_ord_date.
define var line   like ln_line.
define var line1  like ln_line.
/*SS 20080417 - B*/
define var sodline like sod_line.
/*SS 20080417 - E*/
define var xxdate1 as date.
define var i as int.
define new shared variable prline   like  rps_line.
define new shared variable line_rate      like lnd_rate.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define new shared variable part         like seq_part.
define new shared variable hours          as   decimal extent 4.
define new shared variable cap            as   decimal extent 4.
define variable sw_reset     like mfc_logical. 
define var tmpqty like ld_qty_oh.
define var tmppick like ld_qty_oh.
define var tmpqty1 as int. /* 缺料种类 */
define var tmpqty2 like ld_qty_oh. /* 缺料数量 */
define var tmpqty3 like ld_qty_oh.
define var inpqty like ld_qty_oh.
define var update-yn as logical.
define var tothours as decimal format ">>>>>>>9.9<" .
define var totqty   as decimal.
define var tmprmks as char.
define var ii like xxseq_priority.
define var onlyF as logical label "仅未下达" init yes.
define variable new_priority   as   decimal no-undo.
DEFINE VARIABLE vchr_filename_in AS CHARACTER.
DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
DEFINE VARIABLE vlog_fail_flag AS LOGICAL.
define var xxi as int.

define new shared workfile pkdet no-undo
   field pkpart like ps_comp
   field pkop as integer  format ">>>>>9"
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty
   field pkbombatch like bom_batch
   field pkltoff like ps_lt_off.

define temp-table xuseq_mstr
	field xuseq_priority like xxseq_priority
  field xuseq_sod_nbr like xxseq_sod_nbr
  field xuseq_sod_line like xxseq_sod_line   
  field xuseq_wod_lot like xxseq_wod_lot
  field xuseq_due_date like xxseq_due_date   
  field xuseq_line like xxseq_line       
  field xuseq_part like xxseq_part       
  field xuseq_qty_req like xxseq_qty_req
  field xuseq_shift1 like xxseq_shift1
  field xuseq_user1 as char format "x(1)"
  field xuseq_user2 as char format "x(1)"
  index xuseq_priority
  xuseq_priority.
  
	vchr_filename_in = "./ssi" + mfguser.
	vchr_filename_out = "./sso" + mfguser.

form
   site			colon 12
   sonbr    colon 12
   sodline  colon 12 label "项"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


form
   xuseq_priority   column-label "序号" format ">>>>>9"
   xuseq_sod_nbr    column-label "订单号"
   xuseq_sod_line   column-label "项"
   xuseq_due_date   column-label "生产日期"
   xuseq_line       column-label "生产线" format "x(6)"
   xuseq_part       column-label "物料号"
   xuseq_qty_req    column-label "总数量"
   xuseq_shift1 	 	column-label "工时" format ">>>9"
   xuseq_user2      column-label "WO" format "x(1)"
   xuseq_user1			column-label "态" format "x(1)"
with frame d down no-attr-space width 80
title color normal (getFrameTitle("AVAILABLE_SEQUENCE_RECORDS",34)).
/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).
	
/* DISPLAY */
view frame a.

stdate = today.
site = global_site.

mainloop:
repeat with frame a:
   
   if sonbr1 = hi_char  then sonbr1 = "".
   if date1	 = low_date then date1  = ?.
   if date2  = hi_date  then date2 = ?.
   if line1  = hi_char 	then line1  = "".
   
   update 
   	site
   	sonbr
   	sodline
   with frame a.
   
   global_site = site.
   
   if date1 = ? then date1 = low_date.
   if date2 = ? then date2 = hi_date.
   if line1 = "" then line1 = hi_char.
   if sonbr1 = "" then sonbr1 = hi_char.
   	
   	xxi = 0.
   	empty temp-table xuseq_mstr.
   	for each xxseq_mstr where xxseq_domain = global_domain and xxseq_site = site and xxseq_sod_nbr = sonbr
   		and (xxseq_sod_line = sodline or sodline = 0 ) no-lock:
   		
                create 	xuseq_mstr.
   		  				assign 	xuseq_priority = xxseq_priority
   											xuseq_sod_nbr  = xxseq_sod_nbr
   											xuseq_sod_line = xxseq_sod_line
   											xuseq_wod_lot  = xxseq_wod_lot
   											xuseq_due_date = xxseq_due_date
   											xuseq_qty_req  = xxseq_qty_req
   											xuseq_line     = xxseq_line
   											xuseq_part 		 = xxseq_part
             	          xuseq_shift1   = xxseq_shift1
             	          xuseq_user1    = xxseq_user1.
             	find first wo_mstr where wo_domain = global_domain and wo_lot = xxseq_wod_lot no-lock no-error.
             	if avail wo_mstr then xuseq_user2 = wo_status.
             	else xuseq_user2 = "P".
  	end.
  	
   find first xuseq_mstr no-lock no-error.
   if not avail xuseq_mstr then do:
   	 message "记录不存在".
   	 next.
   end.
   
   pause 0.
   sw_reset = yes.
   scroll_loop:
   repeat with frame d:
	 	 
	   	/*pause 0.*/
      
      if sw_reset then do:
   			      	
      end.
   
      do transaction:
	
   			{xxrescrad.i xuseq_mstr "use-index xuseq_priority" xuseq_priority
            "xuseq_priority xuseq_sod_nbr xuseq_sod_line xuseq_due_date xuseq_line xuseq_part xuseq_qty_req 
             xuseq_shift1 xuseq_user2 xuseq_user1
             "
            xuseq_priority d
            " true "
            "  "
            " find first cd_det where cd_domain = global_domain and cd_ref = xuseq_part 
                            	and cd_lang = 'ch' no-lock no-error.
             	if avail cd_det then do:  
              	message cd_cmmt[1].
                message cd_cmmt[2].
              end.  "
            " 
					find first pt_mstr where pt_domain = global_domain and pt_part = substring(xuseq_part,1,4) no-lock no-error.
              if avail pt_mstr then 
              	message '订单:' xuseq_sod_nbr xuseq_sod_line 'ID:' xuseq_wod_lot '机型:' pt_desc1.
							else message '订单号:' xuseq_sod_nbr xuseq_sod_line 'ID' xuseq_wod_lot.
            "
            }
      end.
      
      if keyfunction(lastkey) = "end-error" then do:
      	update-yn = no.
        {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
        if update-yn = yes then leave.
      end.

			/* If you press return then in modify mode */
      if keyfunction(lastkey) = "return" and recno <> ?
      then do transaction on error undo, retry:	      	
      	
				update xuseq_user1 with frame d.
				find first xxseq_mstr where xxseq_domain = global_domain and xxseq_priority = xuseq_priority no-error.
				if avail xxseq_mstr then do:
					find first wo_mstr where wo_domain = global_domain and wo_lot = xxseq_wod_lot no-lock no-error.
					if avail wo_mstr then do:
						if xuseq_user1 = "A" and wo_status = "F" then do:
							xxseq_user1 = "A".
						end.
						else if xuseq_user1 = wo_status then do:
							xxseq_user1 = wo_status.
						end.
						next mainloop.
					end.
					else do:
						if xuseq_user1 = "P" then do:
							xxseq_wod_lot = "".
							xxseq_user1 = "P".
							next mainloop.
						end.
					end.
        end.     	

			end. /* if keyfunction */
			
			else if keyfunction(lastkey) = "insert-mode" then 
			do on error undo,retry:
				
				
			end.
			else if keyfunction(lastkey) = "go"
      then do:
				/*
        update-yn = no.
        {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=update-yn}
        if update-yn = yes then do: 
         	
         	createwo:
         	do transaction:            
						define var tmpresult as char.
					end.
      		sw_reset = yes.
      		hide frame d no-pause.
      		next mainloop.
      	end. /* if update-yn = yes */
				*/
      end.
			
			next scroll_loop.
			
   end. /* do with frame d */
   
   hide frame d no-pause.
   
end. /* repeat with frame a */

status input.
