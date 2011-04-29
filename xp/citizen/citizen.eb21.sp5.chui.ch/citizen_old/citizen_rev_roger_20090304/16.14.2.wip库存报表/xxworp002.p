/* xxworp002.p  工单wip库存报表                                                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 2007/11/21  BY: Softspeed roger xiao  /*xp001*/ */
/*-Revision end------------------------------------------------------------          */



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}


/*begin defination ****************************************/
define var site  like po_site .
define var site1  like po_site .
/*define var wkctr   like wc_wkctr label "工作中心".
define var wkctr1  like wc_wkctr . */
define var nbr   like wo_nbr label "加工单" .
define var nbr1  like wo_nbr .
define var part  like wod_part .
define var part1  like wod_part .
define var comp  like wod_part .
define var comp1 like wod_part .
define var v_yn1 as logical format "Yes-汇总显示/No-按加工单" label "显示方式".

define var v_qty_oh like ld_qty_oh label "在制品库存" .
define var v_qty_iss like tr_qty_loc label "发料量" .
define var v_qty_per like wod_bom_qty label "单位用量" .
define var v_qty_comp like wo_qty_comp label "完成量" .

define temp-table xwod_det 
	field xwod_site     like wo_site     column-label "地点"
	/*field xwod_wkctr    like ro_wkctr    column-label "工作中心"
	field xwod_par      like wo_part     label "成品号" */
	field xwod_part     like wod_part    column-label "零件号"
	field xwod_qty_comp like wo_qty_comp column-label "完成量"
	field xwod_qty_iss  like wod_qty_iss column-label "发料量"
	field xwod_qty_oh   like ld_qty_oh   column-label "在制品库存".


define  frame a .
/*end defination ****************************************/

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)

    site                     colon 18   
	site1                    colon 49   label {t001.i}
/*	wkctr                    colon 18   
	wkctr1                   colon 49   label {t001.i}*/
	nbr                      colon 18   
	nbr1                     colon 49   label {t001.i}
	part                     colon 18
    part1                    colon 49   label {t001.i} 
    comp                     colon 18
    comp1                    colon 49   label {t001.i} 
	v_yn1                    colon 18 
    skip(1)
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).


{wbrp01.i}
repeat:
    if site1 = site       then site1 = "".
	if nbr1 = nbr         then nbr1  = "".
	if comp1 = comp       then comp1 = "".
	if part1  = part       then part1  = "".


    if c-application-mode <> 'web' then  
        update site site1  nbr nbr1  part part1   comp comp1 v_yn1
				with frame a.

	{wbrp06.i &command = update &fields = " site site1  nbr nbr1  part part1   comp comp1 v_yn1 "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:

         
    

        bcdparm = "".
        {mfquoter.i site       }
		{mfquoter.i site1       }
		{mfquoter.i nbr       }
		{mfquoter.i nbr1       }
		{mfquoter.i part       }
		{mfquoter.i part1        }
		{mfquoter.i comp       }
		{mfquoter.i comp1       }
		{mfquoter.i v_yn1       }

		if site1 = ""      then site1 = site .
		if nbr1 = ""       then nbr1  = nbr .
        if comp1 = ""      then comp1 = comp.
		if part1  = ""      then part1  = part.

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

{mfphead.i}  /*bi*/
for each wo_mstr where wo_domain = global_domain 
		and wo_site >= site and ( wo_site <= site1 or site1 = "" )
		and wo_nbr >= nbr  and (wo_nbr <= nbr1 or nbr1 = "" ) 
		and wo_part >= part and  (wo_part <= part1  or part1  = "" ) 
		and ( wo_status = "R" ) /**/ no-lock,
	each wod_det where wod_domain = global_domain 
		and wod_nbr = wo_nbr and wod_lot = wo_lot
		and wod_part >= comp and (wod_part <= comp1 or comp1 = "" ) 
		no-lock
		break by wo_site  by wo_nbr by wod_part 
		with frame x width 300 :

		if first-of(wod_part) then do:
			v_qty_oh   = 0 .
			v_qty_comp = 0 .
			v_qty_per  = 0 .
			v_qty_iss  = 0 .
			/*for each tr_hist where tr_domain = global_domain 
					and tr_type = "ISS-WO" 
					and tr_part = wod_part 
					and tr_nbr = wod_nbr no-lock :
					v_qty_iss = v_qty_iss + tr_qty_loc .				
			end. */ /*for each tr_hist*/
		end. /*if first-of(wod_part) then*/

		v_qty_per = v_qty_per + wod_bom_qty .
		v_qty_iss = v_qty_iss + wod_qty_iss .

		if last-of(wod_part) then do:
			v_qty_comp = wo_qty_comp * v_qty_per .
			v_qty_oh = v_qty_iss - v_qty_comp .
			
			if v_qty_oh = 0  then next .

			if v_yn1 = no then do:
				disp wo_site label "地点" 
					 wo_nbr label "加工单" 
					 wo_part label "成品号" 
					 wo_qty_ord label "已订购量" 
					 wo_qty_comp label "完成量"
					 wod_part label "零件号"
					 v_qty_per column-label "单耗" 
					 v_qty_comp v_qty_iss v_qty_oh  with frame x . 
			end.
			else do:
				find first xwod_det where xwod_site = wo_site 
									/*and xwod_wkctr  = ro_wkctr 
									and xwod_par    = wo_part*/ 
									and xwod_part   = wod_part 
				exclusive-lock no-error .
				if not avail xwod_Det then do :
					create  xwod_det .
					assign  xwod_site  = wo_site 
							/*xwod_wkctr = ro_wkctr
							xwod_par   = wo_part*/ 
							xwod_part  = wod_part 
							xwod_qty_comp  = v_qty_comp
							xwod_qty_iss   = v_qty_iss 
							xwod_qty_oh    = v_qty_oh .
				end.
				else do:
					assign  xwod_qty_comp  = v_qty_comp + xwod_qty_comp 
							xwod_qty_iss   = v_qty_iss + xwod_qty_iss 
							xwod_qty_oh    = v_qty_oh + xwod_qty_oh .	
				end.
			end.					
		end. /*if last-of(wod_part) then*/
      {mfrpexit.i} /*bi*/
end. /*for each wo_mstr */

if v_yn1 = yes then do:
	for each xwod_det where xwod_qty_oh <> 0 no-lock 
		break by xwod_site  by xwod_part 
		with frame xxx width 300 :
		disp xwod_site xwod_part xwod_qty_iss xwod_qty_comp xwod_qty_oh with frame xxx.
	end . /*for each xwod_det*/
end. /*if v_yn1 = yes then do:*/

end. /* mainloop: */
{mfrtrail.i} /* bi REPORT TRAILER {mfreset.i} */

end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
