/* $CREATED BY: softspeed Roger Xiao         DATE: 2008/01/13  ECO: *xp002*  */
/*-Revision end---------------------------------------------------------------*/




/* DISPLAY TITLE */
{mfdtitle.i "1.0"}


define var nbr like po_nbr label "订单号".
define var nbr1 like po_nbr .
define var v_type as char label "单据类型" initial "PO".
define var v_line as integer .
define var v_yn as logical initial yes label "显示当前PO".




define  frame a.

form

    SKIP(1)

	nbr        	colon 18   
	nbr1	    colon 45 
	skip(1)
	/*v_type      colon 18 */
	v_yn        colon 18

	skip(1)
	

with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

	if nbr1 = hi_char       then nbr1 = "".


	 update 	
		nbr
		nbr1
		/*v_type */
		v_yn 
		with frame a.

	if nbr1 = ""      then nbr1 = hi_char.

    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
	mainloop: 
	do on error undo, return error on endkey undo, return error:                    

{mfphead.i}

	for each xrev_hist 
				where xrev_domain = global_domain 
				and  xrev_key1 = v_type
				and  xrev_key2 >= nbr and xrev_key2 <= nbr1
				no-lock break by xrev_key1 by xrev_key2 by xrev_date1 
				with frame x width 300 :
				v_line  = integer(xrev_key3) .
				disp 
					xrev_user1 label "修改人"
					xrev_date1 label "修改日期"
					string(xrev_time1,"hh:mm:ss") label "修改时间" 
					xrev_int01 label "订单版本"
					xrev_key2 label "订单号"
					xrev_chr01 label "供应商"
					xrev_chr02 label "交运地"
					xrev_dte04 label "到期日期"
					v_line     label "订单项次"					
					xrev_chr03 label "零件号" format "x(20)"
					xrev_chr04 label "零件版本"
					xrev_dec01 label "订购数量"
					xrev_dec02 label "订购价格"
					xrev_dte01 label "截止日期"
					xrev_dte02 label "需求日期"
					xrev_dte03 label "履约日期"

					xrev_release label "已发行"
					/*xrev_user2 label "发行人"
					xrev_date2 label "发行日期"
					string(xrev_time2,"hh:mm:ss") label "发行时间" */
				with frame x .
				
				if last-of(xrev_key2) and v_yn then do:

					find first po_mstr where po_domain = global_domain and po_nbr = xrev_key2 no-lock no-error.
					if avail po_mstr then do:
						
						down 1 with frame x.
						disp "PoNow" + string(po_rev,">>9")  @ xrev_int01 
							 po_nbr @ xrev_key2
							 po_vend @ xrev_chr01
							 po_ship @ xrev_chr02
							 po_due_date @ xrev_dte04
							 with frame x.
						for each pod_Det where pod_domain = global_domain and pod_nbr = po_nbr no-lock break by pod_nbr by pod_line :
							disp pod_line @ v_line 
								 pod_part @ xrev_chr03  format "x(20)"
								 pod_rev  @ xrev_chr04 
								 pod_qty_ord  @ xrev_dec01 
								 pod_pur_cost @ xrev_dec02 
								 pod_due_date @ xrev_dte01 
								 pod_need     @ xrev_dte02 
								 pod_per_date @ xrev_dte03 
								 
							with frame x.
							down 1 with frame x.
						end.
					end.
				end. /*if last-of(xrev_key2) */
	end. /*	for each xrev_hist */



	end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
