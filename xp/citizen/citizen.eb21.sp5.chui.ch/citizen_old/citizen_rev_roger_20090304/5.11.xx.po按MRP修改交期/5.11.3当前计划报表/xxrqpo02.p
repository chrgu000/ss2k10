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
define var site1  like pod_site  .
define var part  like pod_part  label "零件" .
define var part1 like pod_part .
define var v_qty_ord like pod_qty_ord .
define var v_um      like pt_um .
define var v_detail  as char label "建议动作" .
define var v_yn    as logical label "仅限未审核" initial no .



site = global_site .

define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
	site                     colon 18
	site1                    colon 54   label  {t001.i} 
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
	if site1  = hi_char      then site1 = "".

    if c-application-mode <> 'web' then  
        update site site1 nbr nbr1 part part1 v_yn with frame a.

	{wbrp06.i &command = update &fields = "site site1 nbr nbr1 part part1 v_yn "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:

        bcdparm = "".
		{mfquoter.i site    }
		{mfquoter.i site1    }
        {mfquoter.i nbr     }
        {mfquoter.i nbr1    }
        {mfquoter.i part     }
        {mfquoter.i part1    }

		if site1 = "" then site1 = hi_char .
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
			where c_domain = global_domain 
			and c_site >= site and c_site <= site1
			and c_nbr >= nbr and c_nbr <= nbr1 
			and c_part >= part and c_part <= part1 
			and ( c_stat02 = no or v_yn = no )
			break by c_site by c_part by c_nbr  by c_line 
			with frame xxx width 200:

			find first pod_det where pod_domain = global_domain and pod_nbr = c_nbr and pod_line = c_line no-lock no-error .
			v_qty_ord = if avail pod_Det then pod_qty_ord else 0 .
			v_um = if avail pod_Det then pod_um else "" .
			if c_detail = "X" then v_detail =  "取消" .
			else if  c_detail = "C" then do:
				 v_detail = if c_date_to > c_date_from then "延后" else "提前".
			end.
			else v_detail =  "" .

			disp c_site 
			     c_part 
				 v_um      label "UM"
				 c_nbr 
				 c_line 
				 
				 v_detail
				 c_date_to
				 v_qty_ord label "订单数量" 
				 c_qty     label "未结数量"
				 c_date_from				 
				 c_req_nbr 
				 c_req_line 	
				 c_user02 label "审核人"
				 c_date02 label "审核日期"
				 c_stat02 label "审核状态"
			with frame xxx .

			/*if last-of(c_part) then down 1 with frame xxx .*/

			{mfrpexit.i}
		end. /*  for each */

	end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
