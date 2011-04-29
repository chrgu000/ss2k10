/* xxwomt001.p - work order maintenance                                      */
/* copyright 1986-2005 qad inc., carpinteria, ca, usa.                        */
/* all rights reserved worldwide.  this is an unpublished work.               */
/* $revision: 1.32 $                                                          */
/*v8:convertmode=maintenance  */
/* $modified by: softspeed roger xiao         date: 2007/12/08  eco: *xp001*  */
/*-revision end---------------------------------------------------------------*/



/*-----------all define----------------------------------------------------------------*/

{mfdtitle.i "1"}

def var vchexcel     as com-handle no-undo.
def var vchworkbook  as com-handle no-undo.
def var vchworksheet as com-handle no-undo.

def var vrow as int no-undo.
def var verror as logical . /*行错误*/
define var v_error_all as logical . /*文件错误*/
define var v_file as char format "x(50)" label "文件名".
define var v_logfile  as char .
define var v_row  as integer initial 2 label "起始处理行".
define var v_month as integer label "月份" format "99".
define var v_site  as char label "地点" .
define var v_todo  as char label "处理" .
define var v_delete as logical initial no .
define var v_wo_type as char label "工单类型" .
define var v_status as char label "工单状态" .

define var v_items   as integer .
define var v_first   as char .
define var v_length  as integer .
define var v_line as integer label "excel行" .
define var v_nbr like wo_nbr .
define var v_lot like wo_lot .
define var v_part like wo_part .			
define var v_qty_ord like wo_qty_ord .
define var v_so_job  like wo_so_job .
define var v_ptstatus like isd_status .
define var v_lot_next	like wo_lot_next .

define temp-table temp 
	field tmp_nbr like wo_nbr 
	field tmp_lot like wo_lot .


define temp-table xwo_mstr 
	field xwo_line as integer label "excel行"
	field xwo_nbr  like wo_nbr 
	field xwo_lot  like wo_lot 
	field xwo_part like wo_part
	field xwo_lot_next	like wo_lot_next 
	field xwo_qty  like wo_qty_ord 
	field xwo_so_job like wo_so_job 
	field xwo_rel_date like wo_rel_date 
	field xwo_due_date like wo_due_date .

define new shared temp-table tt 
    field tt_j as integer 
    field tt_qty as decimal 
    Field tt_rel As Date 
    Field tt_due As Date.

define frame a .


/*-----------var initial----------------------------------------------------------------*/
find icc_ctrl where icc_domain = global_domain no-lock no-error.
v_site = if avail icc_ctrl then icc_site else "" .

v_wo_type = "" .
v_status = "f" .
v_month = month(today).
v_todo = "新增" .
v_file = "d:\test.xls".
v_logfile = "d:\woautoinput"
        + string(year(today),"9999") 
        + string(month(today),"99") 
        + string(day(today),"99") 
        + ".log" .



/*-----------form initial----------------------------------------------------------------*/
form
 rect-frame       at row 1.4 column 1.25
 rect-frame-label at row 1   column 3 no-label
	skip(.1)  /*gui*/

    skip(1)
	v_month colon 20 
	v_site  colon 20
    v_file  colon 20 
	v_row   colon 20
	v_todo  colon 20 view-as combo-box list-items "新增","修改" 
    skip(3)

	skip(.4)  /*gui*/
with frame a side-labels width 80 attr-space no-box three-d /*gui*/.

 define variable f-a-title as character.
 f-a-title = &if defined(gplabel_i)=0 &then
			   &if (defined(selection_criteria) = 0)
			   &then " selection criteria "
			   &else {&selection_criteria}
			   &endif 
			&else 
			   gettermlabel("selection_criteria", 25).
			&endif.
 rect-frame-label:screen-value in frame a = f-a-title.
 rect-frame-label:width-pixels in frame a =
	  font-table:get-text-width-pixels(
	  rect-frame-label:screen-value in frame a + " ", rect-frame-label:font).
 rect-frame:height-pixels in frame a =
	  frame a:height-pixels - rect-frame:y in frame a - 2.
 rect-frame:width-chars in frame a = frame a:width-chars - .5. /*gui*/


view frame a.

/*-----------mainloop-------------------------------------------------------------------*/

mainloop:
repeat with frame a:
	for each temp:   delete temp . end.
	for each xwo_mstr:   delete xwo_mstr . end.
	for each tt: delete tt . end.

	clear frame a no-pause .
	disp v_month v_site v_file v_row v_todo with frame a .
    update v_month v_site v_file with frame a .
	assign v_month v_site v_file .

	if v_month > 12 or v_month < 1 then do:
		message "无效月份,请重新输入" .
		next-prompt v_month .
        undo,retry .
	end.

	find si_mstr where si_domain = global_domain and si_site = v_site no-lock no-error .
	if not avail si_mstr then do:
		message "无效地点" .
		next-prompt v_site .
        undo,retry .
	end.
	else do:
         {gprun.i ""gpsiver.p""
                  "(input v_site, input ?, output return_int)"}
         if return_int = 0 then do:

            {pxmsg.i &msgnum=725 &errorlevel=3}
            /* user does not have access to this site*/
			next-prompt v_site .
            undo , retry .
         end.
	end.

    /*如果没有输入后缀,或输入非excel文件,则自动添加*/
    if substring(v_file,length(v_file) - 3 , 4) <> ".xls" then do:
        v_file = v_file + ".xls" .
        disp v_file with frame a .
    end.

    if search(v_file) = ? then do:
        message "目标文件不存在." view-as alert-box .
		next-prompt v_file .
        undo,retry .
    end.
    else do: /*if search(v_file) <> ?*/
		do transaction:  /*transrow*/
			update v_row v_todo with frame a .
			if v_row < 2 then do :
				message "首行标题,最小行数:2" .
				next-prompt v_row with frame a.
				undo ,retry .
			end.

			if v_row > 65536 then do:
				message "最大行数:65536" .
				next-prompt v_row with frame a.
				undo ,retry .
			end.
		end. /*transrow*/


        /*creat log file */
        if search(v_logfile) = ? then do:
            output to value(v_logfile) .
                put "--------------------------------------------------------" skip .
                put "  this is created by work order auto input system .  " skip .
				put "  date : " ""string(year(today),"9999") + string(month(today),"99") + string(day(today),"99") skip .
                put "--------------------------------------------------------" skip .
				
            output close .
        end.
        output to value(v_logfile) append .

                put skip(2) .
                put "userid :" "" global_userid skip .
				put "month  :" "" string(year(today)) + "/" + string(v_month) skip .
				put "site   :" "" v_site  skip .

                put string(time,"hh:mm:ss")  "" "...begin:" skip .
                put string(time,"hh:mm:ss")  "" "input from file: "  v_file skip . 
				put string(time,"hh:mm:ss")  "" "start from line: "   left-trim(string(v_row))  skip .
        output close .

		/*message v_month v_site  v_file v_row v_todo view-as alert-box.*/

		if v_todo = "修改" then  do : /**************************************删除的条件要不要part*/
			message "即将删除所有本月,本地点,F状态的工单;再按照execl新增.   " 	
			skip    "               是否继续?" 
			view-as alert-box question buttons yes-no
			update choice as logical .
			if choice then do:
				for each wo_mstr where wo_site = v_site 
								 and wo_ord_date >= date(v_month,01,year(today)) 
								 and wo_status = "f" 
								 and wo_type = "" 
								 and wo_wip_tot = 0 
								 and wo_qty_comp = 0 no-lock:
					find first temp where tmp_nbr = wo_nbr and tmp_lot = wo_lot no-lock no-error .
					if not avail temp then do:
						create  temp .
						assign  tmp_nbr = wo_nbr 
								tmp_lot = wo_lot .
					end.
								 
				end. /*for each wo_mstr*/
				v_delete = yes  .
				for each temp :
					/*run d:\000workfiles\citizen200711\16.1\xxwowomt001.p 
					(input tmp_nbr,
					 input tmp_lot,
					 input v_wo_type ,
					 input v_site ,
					 input """" ,
					 input 0,
					 input today,
					 input today,
					 input v_status,
					 input """", 
					 input v_delete).	*/
					{gprun.i ""xxwowomt001.p""  
						"(input tmp_nbr,
						 input tmp_lot,
						 input v_wo_type ,
						 input v_site ,
						 input """" ,
						 input 0,
						 input today,
						 input today,
						 input v_status,
						 input """", 
						 input """", 
						 input v_delete)"}	
				end.

			end. /*if choice = yes*/
			else do: /*if choice = no*/
				undo mainloop,retry mainloop.
			end. /*if choice = no*/
			v_delete = no .
		end. /*v_todo = "修改"*/


        create "excel.application":u vchexcel.
        assign vchexcel:visible = no 
               vchworkbook      = vchexcel:workbooks:open(v_file)
               vchworksheet     = vchexcel:sheets:item(1)
               vrow = v_row - 1  /*vrow最小1,留首行做标题*/
			   v_error_all = no .
        output to value(v_logfile) append keep-messages .         
			getexcel-blk:
			repeat transaction:
				assign verror = false
					   vrow   = vrow + 1.

				/**  quit when : 当遇到首列= "end" 时退出**/
				if vchworksheet:range("a":u + string(vrow)):text = "end" then leave getexcel-blk.
				if vrow >= 65535 then leave getexcel-blk.

				if vchworksheet:range("a":u + string(vrow)):text = "" then next .
				if vchworksheet:range("a":u + string(vrow)):text = "1" then do:

					assign  v_line    = vrow 
							v_first   = "G"  /*第一个工单数量的列的列标*/
							v_length  = if vchworksheet:range("c":u + string(vrow)):value = ? then 1 
										else vchworksheet:range("c":u + string(vrow)):value
							v_nbr     = vchworksheet:range("b":u + string(vrow)):text 
							v_part    = vchworksheet:range("d":u + string(vrow)):text 
							v_so_job  = vchworksheet:range("e":u + string(vrow)):text 
							v_lot_next  = vchworksheet:range("f":u + string(vrow)):text 
							no-error . /**/
					put string(time,"hh:mm:ss") "" "line:  " left-trim(string(vrow)) ""  "正在读数据..." skip . 
                
					if error-status:error then do:
						assign verror = yes.
						output to value(v_logfile) append keep-messages .
							put string(time,"hh:mm:ss") "" "line:  " left-trim(string(vrow)) "" "error:" "" error-status:get-message(1) format "x(100)" skip .
							put string(time,"hh:mm:ss") "" "line:  " left-trim(string(vrow)) "" "...有错误发生,中止操作..." skip(1) skip .
						output close .   
						if verror = yes then v_error_all = verror . /*只要行有错,就 = yes */					
					end.


					find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error .
					if not available pt_mstr then do:
						put  string(time,"hh:mm:ss") "" "line:  " left-trim(string(vrow)) ""  "零件不存在" skip . 
						verror = yes .
					end.
					v_ptstatus = pt_status.
					substring(v_ptstatus,9,1) = "#".
					if can-find(isd_det where isd_det.isd_domain = global_domain 
										and isd_status = v_ptstatus
										and isd_tr_type = "add-wo")
					then do:
						put  string(time,"hh:mm:ss") "" "line:  " left-trim(string(vrow)) "" "零件状态代码的限定交易(358)"  skip .
						verror = yes .
					end .

					for each tt: delete tt . end.
					/*run d:\000workfiles\citizen200711\16.1\xxwomt001a.p 
					   (input v_file,
						input v_line ,
						input v_first,
						input v_month,
						input v_length) .  */
				{gprun.i ""xxwomt001a.p""  
					     "(input v_file,
						input v_line ,
						input v_first,
						input v_month,
						input v_length)"}	/*每行,按区间长度,计算工单的产生个数&qty&rel_date*/						

					if can-find(first tt no-lock) then do:
							find first xwo_mstr where xwo_nbr = v_nbr no-lock no-error.
							if avail xwo_mstr then do:
								put  string(time,"hh:mm:ss") "" "line:  " left-trim(string(vrow)) "" "工单号在ecxel中重复,重复行:" left-trim(string(xwo_line))  skip .
								verror = yes . /************************记入excel */
								
							end.
							else do : /*add_xwo*/
								find first wo_mstr where wo_domain = global_domain and wo_nbr = v_nbr no-lock no-error.
								if avail wo_mstr then do:
									put  string(time,"hh:mm:ss") "" "line:  " left-trim(string(vrow)) "" "工单号在系统中已存在:" wo_nbr  skip .
									verror = yes . /************************记入excel */
									
								end.
								else do: /*add_wo*/
									v_items = 0 .
									for each tt no-lock break by tt_rel :
										v_items = v_items + 1 .

										find first woc_ctrl  where woc_ctrl.woc_domain = global_domain no-error.
										if not avail woc_ctrl then do:
											put  string(time,"hh:mm:ss") "" "line:  " left-trim(string(vrow)) "" "工单模块未启用" skip.
										end.
										{mfnxtsq.i  "wo_mstr.wo_domain = global_domain and " wo_mstr wo_lot woc_sq01 v_lot}
										release woc_ctrl.

										create xwo_mstr .
										assign  xwo_line = v_line 
												xwo_nbr  = v_nbr 
												xwo_lot  = v_lot
												xwo_part = v_part 
												xwo_lot_next = v_lot_next
												xwo_so_job = v_so_job 
												xwo_qty = tt_qty
												xwo_rel_date = tt_rel
												xwo_due_date = tt_due .
									end. /*for each tt*/
								end. /*add_wo*/	
							end. /*add_xwo*/
				
					end. /*if can-find(first tt*/
					else do:
						put  string(time,"hh:mm:ss") "" "line:  " left-trim(string(vrow)) "" "工单数量为零"  skip .
						verror = yes . /************************记入excel */
					end.

					if verror = yes then ASSIGN vchworksheet:range("a":u + string(vrow)):VALUE = "***"  NO-ERROR .
				end. /*if vchworksheet:range("a":u + string(vrow)):text = "1"*/  
				
				if verror = yes then v_error_all = verror . /*只要行有错,就 = yes */
			end.  /**  end : getexcel-blk  **/
		output close .  
		
		vchexcel:displayalerts = false.
		vchWorkBook:Save.
        vchworkbook:close.
        release object vchworksheet.
        release object vchworkbook.

        vchexcel:quit.
        release object vchexcel.


		if verror = yes then v_error_all = verror . /*只要行有错,就 = yes */
        if v_error_all = yes then do:
            message "有错误发生,请参考日志文件:" v_logfile view-as alert-box . 
			undo mainloop ,retry .
        end.
		/*
		output to value(v_logfile) append keep-messages .
			for each xwo_mstr no-lock with frame b with stream-io width 200 :
			disp xwo_mstr with frame b.
			end.
        output close . */



		setloop: 
		do on error undo ,leave  :
				output to value(v_logfile) append keep-messages .
						v_delete = no .  
						for each xwo_mstr no-lock :
							/*run d:\000workfiles\citizen200711\16.1\xxwowomt001.p 
							(input xwo_nbr,
							 input xwo_lot,
							 input v_wo_type ,
							 input v_site ,
							 input xwo_part ,
							 input xwo_qty ,
							 input today,
							 input today,
							 input v_status,
							 input xwo_so_job, 
							 input xwo_lot_next,
							 input v_delete).	*/
					{gprun.i ""xxwowomt001.p""  
							 "(input xwo_nbr,
							 input xwo_lot,
							 input v_wo_type ,
							 input v_site ,
							 input xwo_part ,
							 input xwo_qty ,
							 input xwo_rel_date,
							 input xwo_due_date,
							 input v_status,
							 input xwo_so_job, 
							 input xwo_lot_next,
							 input v_delete)"}							 
						end.
				output close .
		end.  /*setloop:*/   /**/

        output to value(v_logfile) append keep-messages .
            put string(time,"hh:mm:ss")  "" "...end." skip .
        output close .       

    end. /*if search(v_file) <> ?*/

	for each temp:   delete temp . end.
	for each xwo_mstr:   delete xwo_mstr . end.
end. /*mainloop*/
status input.

/*
xxwowomt001.p :
      define input parameter v_nbr like wo_nbr .
      define input parameter v_lot like wo_lot .
      define input parameter v_wo_type like wo_type .
      define input parameter v_site    like wo_site .
      define input parameter v_part    like wo_part .
      define input parameter v_qty_ord like wo_qty_ord .
      define input parameter v_rel_date like wo_rel_date.
      define input parameter v_due_date like wo_due_date.
      define input parameter v_status  like wo_status .
      define input parameter v_so_job   like wo_so_job .
	  define input parameter v_lot_next   like wo_lot_next .
      define input parameter v_delete   like mfc_logical .		
*/