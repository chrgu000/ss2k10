/*By: Neil Gao 08/10/05 ECO: *SS 20081005* */

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
define var inpqty like ld_qty_oh.
define var update-yn as logical.
define var tothours as decimal format "->>>>>>>9.9<".
define var totqty   as decimal.
define var tmprmks as char.
define var ii like xxseq_priority.

define variable new_priority   as   decimal no-undo.
	DEFINE VARIABLE vchr_filename_in AS CHARACTER.
	DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
	DEFINE VARIABLE vlog_fail_flag AS LOGICAL.

	vchr_filename_in = "./ssi" + mfguser.
	vchr_filename_out = "./sso" + mfguser.

define temp-table xuseq_mstr
	field xuseq_site like xxseq_site
	field xuseq_priority like xxseq_priority
	field xuseq_ii like xxseq_priority
  field xuseq_wod_lot like xxseq_wod_lot
  field xuseq_wod_qty like xxseq_qty_req
  field xuseq_sod_nbr like xxseq_sod_nbr
  field xuseq_sod_line like xxseq_sod_line   
  field xuseq_due_date like xxseq_due_date   
  field xuseq_line like xxseq_line       
  field xuseq_part like xxseq_part       
  field xuseq_qty_req like xxseq_qty_req
  field xuseq_qty_pick like xxseq_qty_req
  field xuseq_pick_rmks as char
  field xuseq_qty2 like xxseq_qty_req
  field xuseq_chgtype as char
  field xuseq_shift1 like xxseq_shift1
  field xuseq_status as char format "x(1)"
  index xuseq_ii
  xuseq_ii
  index xuseq_priority
  xuseq_priority.

define buffer s1 for xuseq_mstr.
define buffer s2 for xxseq_mstr.

form
		site			colon 12
   	sonbr    	colon 12  sonbr1  colon 45
   	date1 		colon 12  date2		colon 45
   	line     	colon 12   line1  colon 45
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


form
   xuseq_ii   column-label "序号" format ">>>>>9.9"
   xuseq_due_date   column-label "生产日期"
   xuseq_line       column-label "生产线"
   xuseq_part       column-label "物料号"
   xuseq_qty_req    column-label "数量"
   xuseq_qty_pick   column-label "成套库存"
   xuseq_pick_rmks  column-label "缺料情况"
   xuseq_status     column-label "R"
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
   
   if date1	 = low_date then date1  = ?.
   if date2  = hi_date  then date2 = ?.
   if line1  = hi_char then line1  = "".
   if sonbr1 = hi_char then sonbr1 = "".
   
   update 
   	site
   	sonbr sonbr1
   	date1	date2
   	line 	line1
   with frame a.
   
   global_site = site.
   
   if date1 = ? then date1 = low_date.
   if date2 = ? then date2 = hi_date.
   if line1 = "" then line1 = hi_char.
	 if sonbr1 = "" then sonbr1 = hi_char.
	 
   empty temp-table xuseq_mstr.
   
   i = 1.
   
   for each xxseq_mstr where xxseq_domain = global_domain 
    and xxseq_site = site and xxseq_user1 = "A"
    /*and xxseq__dec02 <> 0*/
    and xxseq_sod_nbr >= sonbr and xxseq_sod_nbr <= sonbr1
   	and xxseq_due_date >= date1 and xxseq_due_date <= date2
   	and xxseq_line >= line and xxseq_line <= line1 no-lock,
   	each wo_mstr where wo_domain = global_domain and wo_lot =  xxseq_wod_lot 
   		and substring(wo_nbr,length(wo_nbr),1) = "B" no-lock
   	by xxseq_due_date by xxseq_line by xxseq_shift4:
   		
   		create xuseq_mstr.
   		assign xuseq_ii       = i
   					 xuseq_site     = xxseq_site
   					 xuseq_priority = xxseq_priority
   					 xuseq_due_date = xxseq_due_date
   					 xuseq_line     = xxseq_line
   					 xuseq_part     = xxseq_part
   					 xuseq_qty_req  = xxseq_qty_req
   					 xuseq_wod_qty  = xxseq_qty_req
   					 xuseq_wod_lot  = xxseq_wod_lot
   					 xuseq_sod_nbr  = xxseq_sod_nbr
   					 xuseq_sod_line = xxseq_sod_line
   					 xuseq_shift1   = xxseq_shift1.
   	 if xxseq_user1 <> "F" then xuseq_status = xxseq_user1.
		 i = i + 1.
   end.
   
   find first xuseq_mstr no-lock no-error.
   if not avail xuseq_mstr then next mainloop.
      
   view frame d.
   pause 0.
   sw_reset = yes.
   scroll_loop:
   repeat with frame d:
	 	 
	   	/*pause 0.*/
      
      
      if sw_reset then do:
				
				{gprunp.i "xxprocedwo" "p" "initld"}
   			
   			for each xuseq_mstr by xuseq_ii :
   				{gprunp.i "xxprocedwo" "p" "createld" "(	input site,
   																									input xuseq_wod_lot,
   																									input xuseq_qty_req,
   																									input xuseq_wod_qty,
   																									input xuseq_ii,
   																									input xuseq_priority,	
   																									output tmppick,
   																									output tmprmks )"}
   				xuseq_qty_pick = tmppick.
   				xuseq_pick_rmks = tmprmks.
   			end.
      	
      end.
   
      do:
	
   			{xxrescrad.i xuseq_mstr "use-index xuseq_ii" xuseq_ii
            "xuseq_ii xuseq_due_date xuseq_line xuseq_part xuseq_qty_req xuseq_qty_pick xuseq_pick_rmks xuseq_status
             "
            xuseq_ii d
            "xuseq_site = site"
            " 
            ii = xuseq_ii.
            run ctrlz.
            "
            " 
            	find first cd_det where cd_domain = global_domain and cd_ref = xuseq_part 
                            	and cd_lang = 'ch' no-lock no-error.
                            	if avail cd_det then do: message cd_cmmt[1].
                            	                          message cd_cmmt[2].
              end.  "
            " 
            	tothours = 0.
            	totqty   = 0.
            	for each s2 where s2.xxseq_domain = global_domain and s2.xxseq_site = xuseq_mstr.xuseq_site
							and s2.xxseq_line = xuseq_mstr.xuseq_line and s2.xxseq_due_date = xuseq_mstr.xuseq_due_date no-lock :
								tothours = tothours + s2.xxseq_shift1.
								totqty   = totqty  + s2.xxseq_qty_req.
							end.
							tothours = round(tothours,2).
							find first pt_mstr where pt_domain = global_domain and pt_part = substring(xuseq_part,1,4) no-lock no-error.
              if avail pt_mstr then 
              	message '工时:' tothours  '数量:' totqty  '订单:' xuseq_sod_nbr xuseq_sod_line 'ID:' xuseq_wod_lot '旧机型:' pt_desc1.
							else message '工时:' tothours '数量:' totqty  '订单号:' xuseq_sod_nbr xuseq_sod_line 'ID' xuseq_wod_lot.
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
      then do:
      	if avail xuseq_mstr and xuseq_wod_lot <> "" and xuseq_status = "A" then do:
      		hide frame a no-pause.
      		hide frame d no-pause.
					{gprun.i ""xxwoworl01.p"" "(input '', input xuseq_wod_lot, input xuseq_priority )"}
					/*{gprun.i ""xxdywoworc.p"" "(input '', input xuseq_wod_lot)"}*/
					view frame a.
				end.
				next mainloop.
			end. /* if keyfunction */
			
			else if keyfunction(lastkey) = "insert-mode" then 
			do on error undo,retry:
				
				
        
			end.
			else if keyfunction(lastkey) = "go"
      then do:
				
        
        
      end.
			
   end. /* do with frame d */
   
   hide frame d no-pause.
   
end. /* repeat with frame a */

status input.

procedure ctrlz:
	{gprunp.i "xxprocedwo" "p" "displd" "(input site,
    																		input ii)"}  
end procedure.
