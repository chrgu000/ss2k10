/* By: Neil Gao Date: 07/10/16 ECO: 20071016 */
/* By: Neil Gao Date: 07/12/19 ECo: 20071219 */
/* By: Neil Gao Date: 08/02/29 ECO: 20080229 */
/*By: Neil Gao 08/03/23 ECO: *SS 20080323* */

{mfdeclre.i}
{gplabel.i} 

define input parameter iptsodnbr like sod_nbr.
define input parameter iptsodline like sod_line.
define input parameter iptsodpart like sod_part.
define input parameter iptdate as date.
define input-output parameter iptqty  like sod_qty_ord.
define new shared variable multiple as decimal init 1.
define variable sw_reset     like mfc_logical. 
define shared variable prline   like  rps_line.
define shared variable site         like  rps_site no-undo. 
define new shared variable begin_date   like seq_start init today. 
define variable seqpriority  like seq_priority no-undo.
define variable ptstatus     like pt_status.
define shared variable part         like seq_part. 
define new shared variable xxdate as date. 
define new shared variable qtyreq       like rps_qty_req. 
define new shared variable old_date     like seq_due_date. 
define new shared variable old_sequence like seq_priority.
define new shared variable lundo-input2 like mfc_logical no-undo. 
define new shared variable undo-input1 like mfc_logical no-undo.
define new shared variable del-yn like mfc_logical initial no.
define shared var line   like ln_line no-undo.
define shared var line1  like ln_line no-undo.
define shared var sonbr  like so_nbr  no-undo.
define shared var sonbr1 like so_nbr  no-undo.
define shared var ord		like so_ord_date no-undo.
define shared var ord1	like so_ord_date no-undo.
define shared var sodline like sod_line no-undo.
define var tmpsodnbr like sod_nbr.
define var tmpsodline like sod_line.
define var tmpline like lnd_line.
define var tmpdate as date.
define var tmpqty like xxseq_qty_req.
define var tmpqty1 like ld_qty_oh.
define var tmpresult as logical.
define var tmpdec02 as deci.
define var tmpuser1 as char.
define var tmpuser2 as char.
define buffer s1 for xxseq_mstr. 
define variable bad_sched_qty as  logical.
define new shared variable xxprio like seq_priority.
define var xxi as int.
define var xxprline as char.
define var tothours as decimal.
define var totqty   as decimal.
define var xxsel as int format ">".
define var xxsodnbrline as char.
define buffer ptmstr for pt_mstr.
define variable hours          as   decimal extent 4.
define variable cap            as   decimal extent 4.
define var ckeckrs as int.
define var duedate as date.
	DEFINE VARIABLE vchr_filename_in AS CHARACTER.
	DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
	DEFINE VARIABLE vlog_fail_flag AS LOGICAL.

	vchr_filename_in = "./ssi" + mfguser.
	vchr_filename_out = "./sso" + mfguser.

define shared temp-table xuln_det no-undo
	field xuln_sel as char format "x(3)"
	field xuln_line like ln_line
	field xuln_seq  like lnd_run_seq1
	field xuln_rate like lnd_rate
	field xuln_rate1 like lnd_rate
	index xuln_line 
	xuln_seq 
	xuln_line.

define shared temp-table tmtwo no-undo
	field tmtwo_f1 like xxseq_priority
	field tmtwo_f2 like xxseq_site.

form
   xxseq_priority   column-label "序号" format ">>>>>9"
   xxseq_sod_nbr    column-label "订单号"
   xxseq_sod_line   column-label "项"
   xxseq_due_date   column-label "生产日期"
   xxseq_line       column-label "生产线" format "x(6)"
   xxseq_part       column-label "物料号"
   xxseq_qty_req    column-label "数量"
   xxseq_shift1 	 	column-label "工时" format ">>9.9"
   xxseq_user2      column-label "类" format "x(1)"
   xxseq_user1			column-label "态" format "x(1)"
with frame d down no-attr-space width 80
title color normal (getFrameTitle("AVAILABLE_SEQUENCE_RECORDS",34)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).


/*SS 20081005 - E*/
/*
xxprline = "".
for each xuln_det where xuln_sel = "*" no-lock by xuln_rate:
	if xuln_Line = line or line  = "" then
	xxprline = xxprline + xuln_line + ",".
end.
find first pt_mstr where pt_domain = global_domain and pt_part = iptsodpart no-lock no-error.
if xxprline <> ""  and iptsodnbr <> "" then do:
	define var ckeckrs as int.
	run checksoqty (input iptsodnbr, input iptsodline,input iptsodpart,output ckeckrs ).
	if ckeckrs <> 0 then return.
	find first sod_det where sod_domain = global_domain and sod_nbr = iptsodnbr and sod_line = iptsodline
		no-lock no-error.
	{gprun.i ""xxwopcmt04.p"" "(input iptsodnbr,
														input iptsodline,
														input iptsodpart,
   													input iptdate,
   													input sod_due_date,
   													input yes,
   													input-output iptqty,
   													input xxprline)"
   													}
end.
if iptqty > 0 then return.
*/
/*SS 20081005 - E*/

xxsodnbrline = iptsodnbr.

   view frame d.
   sw_reset = yes.

   scrolloop:
   repeat with frame d:
			/*clear frame d no-pause.*/
      pause 0.
      do transaction:

         /* Variables use for rescrad.i                            */
         /* {1} = file-name, eg., pt_mstr                          */
         /* {2} = index to use, eg., pt_part                       */
         /* {3} = field to select records by, eg., pt_part         */
         /* {4} = fields to display from primary file, eg.,
                  "pt_part pt_desc1 pt_price"                      */
         /* {5} = field to hi-light, eg., pt_part                  */
         /* {6} = frame name                                       */
         /* {7} = Selection criteria should be "yes"
                  if no selection used                             */
         {xxrescrad.i xxseq_mstr "use-index xxseq_site" xxseq_priority
            "xxseq_priority xxseq_sod_nbr xxseq_sod_line xxseq_due_date xxseq_line xxseq_part xxseq_qty_req 
             xxseq_shift1 xxseq_user2 xxseq_user1"
            xxseq_priority d
            "xxseq_domain = global_domain and xxseq_site = site and
             (xxseq_line = line or  line = '') and 
             xxseq_due_date >= ord and xxseq_due_date <= ord1 and
             xxseq_sod_nbr >= sonbr and xxseq_sod_nbr <= sonbr1 
             and (xxsodnbrline = '' or lookup((xxseq_sod_nbr + string(xxseq_sod_line)),xxsodnbrline) > 0)
             and (xxseq_sod_line = sodline or sodline = 0) "
            " tothours = 0.
            	totqty   = 0.
            	for each s1 where s1.xxseq_domain = global_domain and s1.xxseq_site = xxseq_mstr.xxseq_site
							and s1.xxseq_line = xxseq_mstr.xxseq_line and s1.xxseq_due_date = xxseq_mstr.xxseq_due_date no-lock :
								tothours = tothours + s1.xxseq_shift1.
								totqty   = totqty  + s1.xxseq_qty_req.
							end.
							message '总工时:' tothours  '总数量:' totqty."
            " find first cd_det where cd_domain = global_domain and cd_ref = xxseq_part 
                            	and cd_lang = 'ch' no-lock no-error.
                            	if avail cd_det then do: message cd_cmmt[1].
                            	                          message cd_cmmt[2].
              end.  "
            " tothours = 0.
            	totqty   = 0.
            	for each s1 where s1.xxseq_domain = global_domain and s1.xxseq_site = xxseq_mstr.xxseq_site
							and s1.xxseq_line = xxseq_mstr.xxseq_line and s1.xxseq_due_date = xxseq_mstr.xxseq_due_date no-lock :
								tothours = tothours + s1.xxseq_shift1.
								totqty   = totqty  + s1.xxseq_qty_req.
							end.
							find first sod_det where sod_domain = global_domain and sod_nbr = xxseq_sod_nbr and sod_line = xxseq_sod_line no-lock no-error.
							if avail sod_det then duedate = sod_due_date.
							else duedate = ?.
							find first pt_mstr where pt_domain = global_domain and pt_part = substring(xxseq_part,1,4) no-lock no-error.
              if avail pt_mstr then message '工时:' tothours  '数量:' totqty 'ID:' xxseq_wod_lot '旧机型:' pt_desc1 '交货日期:' duedate .
							else message '工时:' tothours  '数量:' totqty 'ID:' xxseq_wod_lot '交货日期:' duedate ".
            "
            }
      end.
			      
      if keyfunction(lastkey) = "end-error" then leave.

      if keyfunction(lastkey) = "get"
      or lastkey = keycode("CTRL-D")
      or lastkey = keycode("F5") then
      do transaction:

         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn = yes then do:
         		
         		tmpqty = 0.
         		
						find first wo_mstr where wo_domain = global_domain and wo_lot = xxseq_wod_lot no-error.
         		if avail wo_mstr then do:
         			if wo_status = "F" then run delwo.
         			else do:
         				message "已下达,不能删除". pause.
         				next scrolloop.
         			end.
         		end.
         		
/*SS 20090325 - B*/
/*         		
         		/* 删除相关需求 */
         		if xxseq__dec02 <> 0 then do:
         			for each s1 where s1.xxseq_domain = global_domain and S1.xxseq_site  = xxseq_mstr.xxseq_site 
         				and s1.xxseq_priority = xxseq_mstr.xxseq__dec02 :
         				find first wo_mstr where wo_domain = global_domain and wo_lot = S1.xxseq_wod_lot no-error.
         				if avail wo_mstr then do:
         					if wo_status = "F" then run delwo.
         					else do:
         						message "已下达,不能删除". pause.
         						next scrolloop.
         					end.
         				end.
         				delete S1.
         			end.
         		end.
*/
/*SS 20090325 - E*/         		
         		delete xxseq_mstr.
         		clear frame d no-pause.
         		
         end.            
 
         next scrolloop.
      end.
            
      if recno = ? and not keyfunction(lastkey) = "insert-mode"
         and keyfunction(lastkey) <> "return"
         then next.

      /* If you press return then in modify mode */
      if keyfunction(lastkey) = "return" and recno <> ?
      then do transaction on error undo, retry:

        find first wo_mstr where wo_domain = global_domain and wo_lot = xxseq_wod_lot no-error.
        if avail wo_mstr then do:
         	if wo_status <> "F" then do:
         		message "工单已经下达,不能修改". pause.
         		next scrolloop.
         	end.
        end.

/*SS 20080722 - B*/
        message "选择: 1) 修改 2) 拆分 3) 合并  选:" update xxsel.
        
        if xxsel >= 1 and xxsel <= 3 then .
        else do:
        	message "输入无效".
        	undo,retry.
        end.
        if xxsel = 1 then do on error undo,retry:
        	update xxseq_due_date xxseq_line xxseq_qty_req xxseq_user2 with frame d.
        	if xxseq_due_date = ? then do:
         		message "日期不能为空".
         		next-prompt xxseq_due_date.
            undo, retry.
         	end.
					find first pt_mstr where pt_domain = global_domain and pt_part = xxseq_part no-lock no-error.
					find last lnd_det where lnd_domain = global_domain and lnd_site = site and lnd_line = xxseq_line and lnd_start <= today
       			and lnd_part = pt_part no-lock no-error.
       		if not avail lnd_det then
					find last lnd_det where lnd_domain = global_domain and lnd_site = site and lnd_line = xxseq_line and lnd_start <= today
       			and lnd_part = pt_group no-lock no-error.
					if not avail lnd_det then do:
         			message "生产线不存在".
         			next-prompt xxseq_line.
            	undo, retry.
          end.
          
          run checksoqty (input xxseq_sod_nbr, input xxseq_sod_line,input xxseq_part,output ckeckrs ).
					if ckeckrs <> 0 then do:
						next-prompt xxseq_qty_req.
						undo,retry.
          end.
          
          if xxseq__dec02 = 0 then do:
          
						for each s1 where s1.xxseq_domain = global_domain and s1.xxseq_sod_nbr = xxseq_mstr.xxseq_sod_nbr
							and S1.xxseq_sod_line = xxseq_mstr.xxseq_sod_line and s1.xxseq_part <> xxseq_mstr.xxseq_part
							and S1.xxseq__dec02 = xxseq_mstr.xxseq_priority no-lock:
							
							if S1.xxseq_due_date < xxseq_mstr.xxseq_due_date then do:
								message "日期超过了" s1.xxseq_due_date .
								next-prompt xxseq_due_date.
								undo,retry.
							end.
						end.
					end.
          
          xxseq_shift1 = xxseq_qty_req / lnd_rate.
          find first tmtwo where tmtwo_f1 = xxseq_priority and tmtwo_f2 = xxseq_site no-lock no-error.
					if not avail tmtwo then do:
						create	 tmtwo.
						assign 	tmtwo_f1 = xxseq_priority
										tmtwo_f2 = xxseq_site.
					end.
					
        end.
        else if xxsel = 2 then do on error undo,retry:
        	prompt-for xxseq_due_date xxseq_line xxseq_qty_req with frame d.
        	if input xxseq_due_date = ? then do:
         		message "日期不能为空".
         		next-prompt xxseq_due_date.
            undo, retry.
         	end.
					find first pt_mstr where pt_domain = global_domain and pt_part = xxseq_part no-lock no-error.
					find last lnd_det where lnd_domain = global_domain and lnd_site = site and lnd_line = input xxseq_line and lnd_start <= today
       		and lnd_part = pt_part no-lock no-error.
       		if not avail lnd_det then
					find last lnd_det where lnd_domain = global_domain and lnd_site = site and lnd_line = input xxseq_line and lnd_start <= today
       		and lnd_part = pt_group no-lock no-error.
					if not avail lnd_det then do:
         		message "生产线不存在".
         		next-prompt xxseq_line.
            undo, retry.
          end.
          if input xxseq_qty_req >= xxseq_qty_req or input xxseq_qty_req <= 0 then do:
          	message "数量输入有误".
          	next-prompt xxseq_qty_req.
          	undo,retry.
          end.
          assign xxseq_qty_req = xxseq_qty_req - input xxseq_qty_req.
          xxseq_shift1 = xxseq_qty_req / lnd_rate.
          find first tmtwo where tmtwo_f1 = xxseq_priority and tmtwo_f2 = xxseq_site no-lock no-error.
					if not avail tmtwo then do:
						create	 tmtwo.
						assign 	tmtwo_f1 = xxseq_priority
										tmtwo_f2 = xxseq_site.
					end.
								
					/* 新增记录*/
					assign part = xxseq_part
                tmpsodnbr = xxseq_sod_nbr
                tmpsodline = xxseq_sod_line
                tmpline = input xxseq_line
                tmpdate = input xxseq_due_date
                tmpqty	= input xxseq_qty_req
                tmpuser1  = xxseq_user1
                tmpuser2  = xxseq_user2
                .
          disp xxseq_line xxseq_due_date xxseq_qty_req xxseq_shift1 with frame d.
          
					seqpriority = 0.
				 	find last xxseq_mstr use-index xxseq_priority where xxseq_domain = global_domain
						and xxseq_site = site no-lock no-error.
				 	if avail xxseq_mstr then 
						seqpriority = xxseq_priority.
				 	seqpriority = seqpriority + 1.
					
					create 	xxseq_mstr. xxseq_mstr.xxseq_domain = global_domain.
    			assign 	xxseq_priority = seqpriority
    							xxseq_part     = part
            			xxseq_site     = site
            			xxseq_line     = tmpline
            			xxseq_due_date = tmpdate
            			xxseq_sod_nbr  = tmpsodnbr
            			xxseq_sod_line = tmpsodline
         					xxseq_qty_req  = tmpqty
    							xxseq_shift1   = xxseq_qty_req / lnd_rate
    							xxseq_user1    = tmpuser1
    							xxseq_user2    = tmpuser2
    							.	
					
					find first tmtwo where tmtwo_f1 = xxseq_priority and tmtwo_f2 = xxseq_site no-lock no-error.
					if not avail tmtwo then do:
						create	tmtwo.
						assign 	tmtwo_f1 = xxseq_priority
										tmtwo_f2 = xxseq_site.
					end.
        end.
        else if xxsel = 3 then do on error undo,retry:
        	
        	prompt-for xxseq_priority with frame d.
        	
        	if input xxseq_priority = xxseq_priority then do:
        		message "序号不能相同".
        		undo,retry.
        	end.
        	tmpdec02 = 0.
        	tmpresult = no.
        	for first s1 where s1.xxseq_domain = global_domain and s1.xxseq_priority = input xxseq_mstr.xxseq_priority:
        		if s1.xxseq_sod_nbr <> xxseq_mstr.xxseq_sod_nbr 
        			or s1.xxseq_sod_line <> xxseq_mstr.xxseq_sod_line 
        				or s1.xxseq_part <> xxseq_mstr.xxseq_part 
        				or s1.xxseq_user1 <> xxseq_mstr.xxseq_user1
        				or s1.xxseq_user2 <> xxseq_mstr.xxseq_user2
        				then do:
        			message "合并序号不匹配".
        			undo,retry.
        		end.
        		find first wo_mstr where wo_domain = global_domain and wo_lot = s1.xxseq_wod_lot no-error.
        		if avail wo_mstr then do:
         			if wo_status <> "F" then do:
         				message "工单已经下达,不能修改".
         				undo,retry.
         			end.
       	 		end.
        	
        		find first pt_mstr where pt_domain = global_domain and pt_part = S1.xxseq_part no-lock no-error.
						find last lnd_det where lnd_domain = global_domain and lnd_site = site and lnd_line = s1.xxseq_line and lnd_start <= today
       				and lnd_part = pt_part no-lock no-error.
       			if not avail lnd_det then 
						find last lnd_det where lnd_domain = global_domain and lnd_site = site and lnd_line = s1.xxseq_line and lnd_start <= today
       				and lnd_part = pt_group no-lock no-error.
						if not avail lnd_det then do:
         			message "生产线不存在".
            	undo, retry.
          	end.
        	/* 合并数量 */
        		s1.xxseq_qty_req = s1.xxseq_qty_req + xxseq_mstr.xxseq_qty_req.
        		s1.xxseq_shift1 = s1.xxseq_qty_req / lnd_rate.
        		find first tmtwo where tmtwo_f1 = s1.xxseq_priority and tmtwo_f2 = s1.xxseq_site no-lock no-error.
						if not avail tmtwo then do:
							create	tmtwo.
							assign 	tmtwo_f1 = s1.xxseq_priority
										tmtwo_f2 = s1.xxseq_site.
						end.
        	
						if s1.xxseq__dec02 <> 0 then do:
							tmpdate = s1.xxseq_due_date - 1.
							tmpdec02 = s1.xxseq__dec02.
							tmpqty = s1.xxseq_qty_req.
						end.
						tmpresult = true.
											
					end. /* for first S1 */
				
					if tmpresult then do:	
						if tmpdec02 <> 0  then do:
							/* 修改相关需求*/
							for each s1 where s1.xxseq_domain = global_domain and s1.xxseq_priority = tmpdec02 :
   							{xxrecaldt.i "tmpdate" "site" "" no }
								S1.xxseq_qty_req = tmpqty.
								S1.xxseq_due_date = tmpdate.
								find first pt_mstr where pt_domain = global_domain and pt_part = S1.xxseq_part no-lock no-error.
								find last lnd_det where lnd_domain = global_domain and lnd_site = site and lnd_line = S1.xxseq_line and lnd_start <= today
       					and lnd_part = pt_part no-lock no-error.
       					if not avail lnd_det then
								find last lnd_det where lnd_domain = global_domain and lnd_site = site and lnd_line = S1.xxseq_line and lnd_start <= today
       					and lnd_part = pt_group no-lock no-error.
								S1.xxseq_shift1 = S1.xxseq_qty_req / lnd_rate.
								find first tmtwo where tmtwo_f1 = S1.xxseq_priority and tmtwo_f2 = S1.xxseq_site no-lock no-error.
								if not avail tmtwo then do:
									create 	tmtwo.
									assign 	tmtwo_f1 = S1.xxseq_priority
												tmtwo_f2 = S1.xxseq_site.
								end.
							end.
						end.
        	
         		find first wo_mstr where wo_domain = global_domain and wo_lot = xxseq_mstr.xxseq_wod_lot no-error.
         		if avail wo_mstr then do:
         			if wo_status = "F" then run delwo.
         			else do:
         				message "已下达,不能删除".
         				undo,retry.
         			end.
         		end.
         	
         		/* 删除相关需求 */
         		if xxseq_mstr.xxseq__dec02 <> 0 then do:
         			for each s1 where s1.xxseq_domain = global_domain and S1.xxseq_site  = xxseq_mstr.xxseq_site 
         				and s1.xxseq_priority = xxseq_mstr.xxseq__dec02 :
         				find first wo_mstr where wo_domain = global_domain and wo_lot = S1.xxseq_wod_lot no-error.
         				if avail wo_mstr then do:
         					if wo_status = "F" then run delwo.
         					else do:
         						message "已下达,不能删除".
         						undo,retry.
         					end.
         				end.
         				delete S1.
         			end.
         		end.
         		
         		delete xxseq_mstr.
         		clear frame d no-pause.
        	end.
        	else do:
        		undo,retry.
        	end.
       	end. /* else if xxsel = 3 */
/*SS 20080722 - E*/
				
         ststatus = stline[2].
         status input ststatus.
				 
				 if avail xxseq_mstr then 
				 	sw_key = string(xxseq_mstr.xxseq_priority).
				 
				 sw_reset = yes.
				 next scrolloop.

      end. /* modify mode */

      if keyfunction(lastkey) = "insert-mode"
      or (keyfunction(lastkey) = "return" and recno = ?)
      then do transaction:

         /* PREVIOUS FIND LAST LOGIC WAS FAILING IN ORACLE ENVIRONMENTS */
         seqpriority = 0.
				 find last xxseq_mstr use-index xxseq_priority where xxseq_domain = global_domain
					and xxseq_site = site no-lock no-error.
				 if avail xxseq_mstr then 
					seqpriority = xxseq_priority.
				 seqpriority = seqpriority + 1.

         display seqpriority @ xxseq_priority.

         do on error undo, retry:

            prompt-for
               xxseq_priority validate (true,"") /* Validation makes status line */
            with frame d
            editing: /* active in scrolling window   */

               {mfnp06.i xxseq_mstr xxseq_priority
                  " xxseq_mstr.xxseq_domain = global_domain and xxseq_site  = site
                   and xxseq_line >= line and xxseq_line <= line1 "
                  xxseq_priority xxseq_priority
                  xxseq_priority xxseq_priority}

               if recno <> ? then do:
                  display
                     xxseq_priority
                     xxseq_sod_nbr
                     xxseq_sod_line
                     xxseq_due_date
                     xxseq_line
                     xxseq_part
                     xxseq_qty_req
                     xxseq_shift1
                     xxseq_user2
                     xxseq_user1
                  with frame d.
               end.

            end. /* editing */

            if input xxseq_priority = 0 then do:
               {pxmsg.i &MSGNUM=8531 &ERRORLEVEL=3}
               next-prompt xxseq_priority with frame d.
               undo, retry.
            end.
         end. /* do on error */

         do:

            find xxseq_mstr  where xxseq_mstr.xxseq_domain = global_domain
               and xxseq_site = site
               and xxseq_priority = input xxseq_priority no-error.

            if available xxseq_mstr then do:

               display
                     xxseq_priority
                     xxseq_sod_nbr
                     xxseq_sod_line
                     xxseq_due_date
                     xxseq_line
                     xxseq_part
                     xxseq_qty_req
                     xxseq_shift1
                     xxseq_user2
                     xxseq_user1
                  with frame d.
                  
               ststatus = stline[2].
               status input ststatus.

               next scrolloop.
               
            end.

            else do: /* new records */

               do on error undo, retry:

                 	prompt-for xxseq_part with frame d.
                 	iptsodpart = input xxseq_part.
                  
                  find first pt_mstr where pt_domain = global_domain and iptsodpart = pt_part no-lock no-error.
                  if not avail pt_mstr then do:
                  	message "物料号不存在".
                  	undo,retry.
                  end.
                  
                  {gprun.i ""xxwopcmt02.p"" "(input site,
   														input iptsodpart)"}
   														
								 	find first xuln_det where xuln_sel = "*" no-lock no-error.
								 	if not avail xuln_det then do:
								 		message "无生产线".
								 		undo,retry.
								 	end.
									
                  prompt-for
                  	xxseq_sod_nbr
                  	xxseq_sod_line
                  	xxseq_due_date
                  	xxseq_qty_req
									with frame d
                  editing:
                     if frame-field = "xxseq_part" then do:
                        /* FIND/PREVIOUS */
                        {mfnp05.i lnd_det lnd_line
                           " lnd_det.lnd_domain = global_domain and lnd_site  =
                            site and lnd_line >= line and lnd_line <= line1"
                           lnd_part "input xxseq_part"}
                        if recno <> ? then
                           display lnd_part @ xxseq_part with frame d.
                        recno = ?.
                     end. /* frame-field */
                     else do:
                        readkey.
                        apply lastkey.
                     end.
                  end. /* editing */

                  find pt_mstr  where pt_mstr.pt_domain = global_domain and
                   pt_part = input xxseq_part
                  no-lock no-error.

                  del-yn = no.

                  assign
                     part = input xxseq_part
                     old_date = input xxseq_due_date
                     old_sequence = input xxseq_priority
                     qtyreq = input xxseq_qty_req
                     iptsodnbr = input xxseq_sod_nbr
                     iptsodline = input xxseq_sod_line.
                     
									
									find first sod_det where sod_domain = global_domain
										and sod_nbr = iptsodnbr and sod_line = iptsodline no-lock no-error.
									if not avail sod_det then do:
										message "订单号项次不存在".
										undo,retry.
									end.
									else do:
										if sod_part <> part then do:
											find first ps_mstr where ps_domain = global_domain and ps_par = sod_part and 
											ps_comp = part no-lock no-error.
											if not avail ps_mstr then do:
												message "动力与机组不匹配".
												undo,retry.
											end.
										end.
									end.
									
									iptsodnbr = sod_nbr.
									
									tmpqty = 0.
        					for each s1 where s1.xxseq_domain = global_domain and s1.xxseq_part = part 
        							and s1.xxseq_sod_nbr = sod_nbr and s1.xxseq_sod_line = sod_line no-lock:
        							tmpqty = tmpqty + s1.xxseq_qty_req .
        					end.
        					tmpqty = tmpqty + qtyreq.
        					
        					find first sod_det where sod_domain = global_domain /*and sod_part = part*/ 
        						and sod_nbr = iptsodnbr and sod_line = iptsodline no-lock no-error.
        					if avail sod_det then do:
        						if tmpqty > sod_qty_ord then do:
        							message "排产数量:" tmpqty "大于订单数量:" sod_qty_ord "请重新输入".
        							next-prompt xxseq_qty_req.
        							undo,retry.
        						end.
        						else if tmpqty < sod_qty_ord then do:
        							message "排产数量:" tmpqty  "小于订单数量:" sod_qty_ord .
        							pause.
        						end.
        					end.
									
                  if old_date = ? then
                     old_date = today.

										 	find first pt_mstr where pt_domain = global_domain and pt_part = iptsodpart no-lock no-error.
											if avail pt_mstr then do:
												for first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = pt_mstr.pt_group no-lock:
													old_date = old_date - pt_mfg_lead.
												end.
											end.

                  {gprun.i ""xxwopcmt04.p"" "(input iptsodnbr,
														input iptsodline,
														input part,
   													input old_date,
   													input sod_due_date,
   													input yes,
   													input-output qtyreq,
   													input '')"
   													}
                  
               end. /* else do */

            end. /* do on error, undo retry */

         end. /* transaction */

      end. /* insert-mode */

      else
      if keyfunction(lastkey) = "go"
      then do:

         do transaction:
            

         end. /* DO TRANSACTION ... */
         next scrolloop.

      end.

   end. /* scrolloop */

/*SS 20080323 - B*/
procedure checksoqty:
	define input 	parameter sodnbr like sod_nbr.
	define input	parameter sodline like sod_line.
	define input	parameter sodpart like sod_part.
	define output parameter ckrs as int.
	tmpqty = 0.
	ckrs = 0.
  for each s1 where s1.xxseq_domain = global_domain and s1.xxseq_part = sodpart 
  	and s1.xxseq_sod_nbr = sodnbr and s1.xxseq_sod_line = sodline no-lock:
  		tmpqty = tmpqty + s1.xxseq_qty_req .
  end.
  find first sod_det where sod_domain = global_domain
   	and sod_nbr = sodnbr and sod_line = sodline no-lock no-error.
  if avail sod_det then do:
   	if tmpqty > sod_qty_ord then do:
   		message "排产数量" tmpqty "大于订单数量:" sod_qty_ord.
   		ckrs = 1.
  	end.
  	if tmpqty < sod_qty_ord then do:
   		message "排产数量" tmpqty "小于订单数量:" sod_qty_ord.
   		ckrs = 2.
  	end.
  end.
  else do:
  	message "销售订单未找到".
  	ckrs = 3.
  end.
end procedure.
/*SS 20080323 - E*/

{inmrp1.i}

PROCEDURE delwo:

   do transaction:

			for each wod_det exclusive-lock
          where wod_det.wod_domain = global_domain and  wod_lot =
                wo_mstr.wo_lot:

               {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}
               {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)}

               run inmrp (input wod_part, input wod_site).

               delete wod_det.
      end.

      {mfmrwdel.i "wo_mstr" wo_mstr.wo_part wo_mstr.wo_nbr
               wo_mstr.wo_lot """"}

      delete wo_mstr.

   end.

END PROCEDURE. /* delwo */
