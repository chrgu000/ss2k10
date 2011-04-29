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

define var v_wonbr  like wo_nbr .
define var v_wonbr1 like wo_nbr .


define frame a .


/*-----------var initial----------------------------------------------------------------*/
find icc_ctrl where icc_domain = global_domain no-lock no-error.
v_site = if avail icc_ctrl then icc_site else "" .

v_wo_type = "" .
v_status = "f" .
v_month = month(today).
v_todo = "修改"  .
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
	"工单批量删除:" colon 15
	"限本月导入的,本地点的,工单号范围内的,所有F状态的工单."  colon 15
    skip(1)
	v_month colon 20 
	v_site  colon 20
    v_wonbr   colon 20 LABEL "工单号码起"
    v_wonbr1  colon 20 LABEL "工单号码止"
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
    update v_month v_site  v_wonbr  v_wonbr1 with frame a .
	assign v_month v_site  v_wonbr  v_wonbr1 .

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

if v_wonbr = "" or v_wonbr1 = "" then do:
	message "起止工单号不允许为空" view-as alert-box.
	undo,retry .
end.

		if v_todo = "修改" then  do : /**************************************删除的条件要不要part*/
			message "即将删除: 本月导入的,此地点,此工单号范围内的,所有F状态的工单.  " 	
			skip    "               是否继续?" 
			view-as alert-box question buttons yes-no
			update choice as logical .
			if choice then do:
				for each wo_mstr where wo_site = v_site 
								 and wo_ord_date >= date(v_month,01,year(today)) 
								 and ( wo_nbr >=  v_wonbr  and wo_nbr <=  v_wonbr1 )
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
			message "批量删除完成" .
		end. /*v_todo = "修改"*/


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