/* xxrqpo02.p                                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/25/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var nbr   like po_nbr label "采购单" .
define var nbr1  like po_nbr .
define var site  like pod_site  label "地点".
define var part  like pod_part  label "零件" .
define var part1 like pod_part .
define var v_shipcode as char format "x(1)" label "周期" .  
define var v_lt like pt_pur_lead column-label "L/T" .
define var v_qty_open like pod_qty_ord  label "未结数量". 
define var v_qty_ord like pod_qty_ord  label "订单数量". 
define var v_ord_Date as date label "订单日期".
define var v_need  as date  label "需求日期". 
define var v_per_Date as date label "履约日期" .
define var v_vend    like po_vend label "供应商" .
define var v_cwin    like vp__chr01 label "C_Win" .
define var v_um      like pt_um .
define var v_detail  as char label "建议动作" .
define var v_yn    as logical label "仅限未审核" initial no .



site = "10000" .

define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
	site                     colon 18
	nbr                      colon 18
	nbr1                     colon 54   label  {t001.i} 
	part                     colon 18
	part1                    colon 54   label  {t001.i} 
	v_yn                     colon 18

	skip(1)
	
skip(2) 
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = hi_char       then part1 = "".
	if nbr1  = hi_char       then nbr1 = "".

    if c-application-mode <> 'web' then  
        update site nbr nbr1 part part1 v_yn with frame a.

	{wbrp06.i &command = update &fields = "site nbr nbr1 part part1 v_yn "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:

        bcdparm = "".
		{mfquoter.i site    }
        {mfquoter.i nbr     }
        {mfquoter.i nbr1    }
        {mfquoter.i part     }
        {mfquoter.i part1    }


        if part1 = "" then part1 = hi_char.
        if nbr1 = "" then nbr1 = hi_char .

	end.  /* if c-application-mode <> 'web' */

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
		for each xchg_det no-lock 
			where c_site = site 
			and c_nbr >= nbr and c_nbr <= nbr1 
			and c_part >= part and c_part <= part1 
			and ( c_stat01 = no or v_yn = no )
			break by c_site  by c_part by c_date_to by c_nbr by c_line 
			with frame xxx width 300:
			
			find first pt_mstr where pt_part = c_part no-lock no-error .
			v_shipcode = if avail pt_mstr then pt__chr02 else "" .
			v_lt = if avail pt_mstr then pt_pur_lead else 0 .

			find first po_mstr where po_nbr = c_nbr no-lock no-error .
			v_ord_date = if avail po_mstr then po_ord_date else ? .
			v_vend = if avail po_mstr then po_vend else "" .

			find first vp_mstr where vp_vend = v_vend and vp_part = c_part and vp_vend_part = "" no-lock no-error .
			v_cwin = if avail vp_mstr then vp__chr01 else "" .

			find first pod_det where pod_nbr = c_nbr and pod_line = c_line no-lock no-error .
			v_need = if avail pod_det then pod_need else ? .
			v_per_date = if avail pod_det then pod_per_date else ? .
			v_qty_ord = if avail pod_Det then pod_qty_ord else 0 .
			v_qty_open = if avail pod_Det then ( pod_qty_ord - pod_qty_rcvd ) else 0 .
			v_um = if avail pod_Det then pod_um else "" .



			v_detail = if (c_detail = "XX" or c_detail = "XR" or c_detail = "XN") then "取消" 
				   else if ( c_detail = "CN" or  c_detail = "CR" )  and c_date_to <> date(01,01,year(today) + 2 ) then "调整"
				   else if ( c_detail = "CN" or  c_detail = "CR" )  and c_date_to =  date(01,01,year(today) + 2 ) then "取-L"
				   else "" .

			disp     c_site 
				 c_part 
				 v_um      label "UM"
				 v_shipcode 
				 c_nbr 
				 c_line 
				 v_detail 
				  /*c_detail*/
				 c_date_to
				 c_qty_to 			 
				 
				 v_vend 
				 v_cwin
				 v_ord_date 
				 v_need
				 v_per_date
				 c_date_from
				 v_qty_ord 
				 v_qty_open
				 c_req_nbr 
				 c_req_line 	
				 c_user01
				 c_date01
				 c_stat01
				 c_user02
				 c_date02
				 c_stat02
			with frame xxx .

			if last-of(c_part) then down 1 with frame xxx .


			{mfrpexit.i}
		end. /*  for each */

	end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
