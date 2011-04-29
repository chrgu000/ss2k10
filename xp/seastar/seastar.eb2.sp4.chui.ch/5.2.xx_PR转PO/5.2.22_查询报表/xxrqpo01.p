/* xxrqpo01.p                                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/18/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Definitions ********* */
define var vend  like po_vend.
define var vend1 like po_vend .
define var ord  like po_ord_date.
define var ord1 like po_ord_date .
define var nbr   like po_nbr label "采购单" .
define var nbr1  like po_nbr .
define var v_yn1  as logical label "采购单核准状态" initial yes format "Y )仅已核准/N )仅未核准".
define var v_yn2  as logical label "显示已审核项次" initial no format "Y )是 /N )否 ".
define var v_desc1 like pt_desc1 .
define var v_desc2 like pt_desc2 .
define var v_app as logical  .






define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.5)
    vend                     colon 18
	vend1                    colon 54   label  {t001.i} 
	ord                      colon 18
    ord1                     colon 54   label  {t001.i} 
    nbr                      colon 18
    nbr1                     colon 54   label  {t001.i} 
	skip(2)
	v_yn1                     colon 25
	v_yn2                     colon 25

skip(2) 
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if vend1 = hi_char       then vend1 = "".
	if ord1 = hi_date       then ord1 = ?.
	if ord  = low_date      then ord = ? .
	if nbr1  = hi_char       then nbr1 = "".

    if c-application-mode <> 'web' then  
        update vend vend1 ord ord1 nbr nbr1 v_yn1 v_yn2  with frame a.

	{wbrp06.i &command = update &fields = "vend vend1 ord ord1 nbr nbr1 v_yn1 v_yn2 "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:

        bcdparm = "".
        {mfquoter.i vend     }
        {mfquoter.i vend1    }
        {mfquoter.i ord     }
        {mfquoter.i ord1    }
        {mfquoter.i nbr     }
        {mfquoter.i nbr1    }
        {mfquoter.i v_yn1     }
		{mfquoter.i v_yn2     }

        if vend1 = "" then vend1 = hi_char.
        if ord = ?   then ord = low_date.
        if ord1 = ? then ord1 = hi_date.
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
		if v_yn1 = yes then do :
				if v_yn2 = no then do :
					for each po_mstr no-lock use-index po_vend  
									where po_vend >= vend and po_vend <= vend1 
									and po_ord_date >= ord and po_ord_date <= ord1 
									and po_nbr >= nbr and po_nbr <= nbr1 
									and po_stat = ""
									and po__chr01 = "A" 
									break by po_vend 
									with frame xx width 200:

											setframelabels(frame xx:handle) .
											disp po_vend po_nbr po_ord_Date  po_curr with frame xx.
					{mfrpexit.i}
					end. /*  for each */

				end.
				else do:
					for each po_mstr no-lock use-index po_vend  
									where po_vend >= vend and po_vend <= vend1 
									and po_ord_date >= ord and po_ord_date <= ord1 
									and po_nbr >= nbr and po_nbr <= nbr1 
									and po_stat = ""
									and po__chr01 = "A" 
									break by po_vend :
						for each pod_det no-lock use-index pod_nbrln 
								where pod_nbr = po_nbr 
								with frame xy width 300 
								break by pod_nbr by pod_line:
								setframelabels(frame xy:handle) .

								find first pt_mstr where pt_part = pod_part no-lock no-error .
								v_desc1 = if avail pt_mstr then pt_desc1 else "" .
								v_desc2 = if avail pt_mstr then pt_desc2 else "" .

								v_app = if pod__chr01 = "A" then yes else  no .


								disp po_vend 
									po_curr
									po_ord_date
									pod_nbr 
									pod_line 
									pod_part 
									v_desc1 
									v_desc2									
									pod_um 
									pod_qty_ord 
									pod_pur_cost 
									 
									
									v_app label "审核"
									pod__chr03 format "x(8)"  label "审核人" 
									pod__dte01 label "审核日期"
									pod__chr02 format "x(60)" label "备注" 
									with frame xy .

								{mfrpexit.i}
						end.
					end. /*  for each */
				end.							
		end. /*if v_yn1 = yes */
		else do: /*if v_yn1 = no*/
			for each po_mstr no-lock use-index po_vend  
							where po_vend >= vend and po_vend <= vend1 
							and po_ord_date >= ord and po_ord_date <= ord1 
							and po_nbr >= nbr and po_nbr <= nbr1 
							and po_stat = ""
							and po__chr01 = "",
				each pod_det no-lock use-index pod_nbrln 
							where pod_nbr = po_nbr 
							and pod_stat = "" 
							and ( pod__chr01 = "" or v_yn2 = yes )
				with frame xxx width 300
				break by pod__chr01 /*by pod__chr02 desc*/ by po_vend by pod_nbr by pod_line :
				
				setframelabels(frame xxx:handle) .

				find first pt_mstr where pt_part = pod_part no-lock no-error .
				v_desc1 = if avail pt_mstr then pt_desc1 else "" .
				v_desc2 = if avail pt_mstr then pt_desc2 else "" .

				v_app = if pod__chr01 = "A" then yes else  no .


				disp po_vend 
					po_curr
					po_ord_date
					pod_nbr 
					pod_line 
					pod_part 
					v_desc1 
					v_desc2		 
					pod_um 
					pod_qty_ord 
					pod_pur_cost 
					 
					
					v_app label "审核"
					pod__chr03 format "x(8)"  label "审核人" 
					pod__dte01 label "审核日期"
					pod__chr02 format "x(60)" label "备注" 
					with frame xxx .

			{mfrpexit.i}
			end. /*  for each */
		end. /*if v_yn1 = no */

	end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
