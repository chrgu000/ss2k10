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
define var site1  like pod_site .
define var part  like pod_part  label "零件" .
define var part1 like pod_part .
define var v_qty_ord like pod_qty_ord .
define var v_um      like pt_um .
define var v_detail  as char label "建议动作" .
define var v_yn    as logical label "仅限未审核" initial no .
define var v_wk  as char .
define var v_date as date label "参考日期"  . 


site = global_site .
v_date = today .

define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
	v_date                   colon 18  
	site                     colon 18
	site1                    colon 54 label  {t001.i}
    nbr                      colon 18
    nbr1                     colon 54   label  {t001.i} 
	part                     colon 18
	part1                    colon 54   label  {t001.i} 
	/*v_yn                     colon 18*/

	skip(1)
	
skip(2) 
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
 setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = hi_char       then part1 = "".
	if nbr1  = hi_char       then nbr1 = "".
	if site1  = hi_char      then site1 = "".

    if c-application-mode <> 'web' then  
        update v_date site site1  nbr nbr1 part part1 with frame a.

	{wbrp06.i &command = update &fields = " v_date site site1 nbr nbr1 part part1 "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:

        bcdparm = "".
		{mfquoter.i v_date    }
		{mfquoter.i site    }
		{mfquoter.i site1    }
        {mfquoter.i nbr     }
        {mfquoter.i nbr1    }
        {mfquoter.i part     }
        {mfquoter.i part1    }

		if v_date = ?  then v_date = today .
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
		v_wk = "" .
		{gprun.i ""xxmpwks.p"" "(input v_date ,output v_wk)"}

		{mfphead.i}
		for each xchg_hist no-lock 
			where xch_domain = global_domain and xch_wk = v_wk 
			and xch_site >= site  and xch_site <= site1 
			and xch_nbr >= nbr and xch_nbr <= nbr1 
			and xch_part >= part and xch_part <= part1 		
			break by xch_site by xch_nbr by xch_part  by xch_line 
			with frame xxx width 200:

			if xch_detail = "X" then v_detail =  "取消" .
			else if  xch_detail = "C" then do:
				 v_detail = if xch_date_to > xch_date_from then "延后" else "提前".
			end.
			else v_detail =  "" .

			find first pt_mstr where pt_domain = global_domain and pt_part = xch_part no-lock no-error .
			v_um = if avail pt_mstr then pt_um else "" .

			disp xch_site 
				 xch_nbr 
				 xch_line 
				 xch_part 
				 v_um 
				 xch_date_to
				  
				 v_detail 
				 xch_date_from
				 xch_req_nbr 
				 xch_req_line 					 
				 xch_user02 label "审核人"
				 xch_date02 label "审核日期"
			with frame xxx .


			{mfrpexit.i}
		end. /*  for each */


	end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
