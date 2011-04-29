/*                                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */


define var desc1 like pt_desc1 label "说明".
define var desc2 like pt_desc2 label "说明" .


define var nbr like po_nbr label "加工单号" .
define var nbr1 like po_nbr .
define var part  like pt_part .
define var part1 like pt_part .
define var date  as date label "生效日期".
define var date1 as date .
define var nbra as char format "x(18)" label "自编单号" .
define var nbra1  as char format "x(18)"  .



define  frame a.
form
    SKIP(.2)

    nbr                        colon 18
    nbr1                       colon 54   label  {t001.i} 
    date                       colon 18
    date1                      colon 54   label  {t001.i} 
    nbra                       colon 18
    nbra1                      colon 54   label  {t001.i} 
    part                       colon 18
    part1                      colon 54   label  {t001.i}     
    skip(1)

    
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).


repeat:
	if nbr1 = hi_char        then nbr1 = "".
	if nbra1 = hi_char       then nbra1 = "".
	if part1 = hi_char       then part1 = "".
	if date1 = hi_date       then date1 = ? .
	if date  = low_date      then date = ? .


	update nbr nbr1  date  date1 nbra nbra1  part part1  with frame a.

	if date = ?        then date  = low_date .
	if date1 = ?       then date1 = hi_date.        
	if part1 = ""      then part1 = hi_char .
	if nbr1 = ""       then nbr1  = hi_char .
	if nbra1 = ""      then nbra1 = hi_char .

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

/*
        PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxkbrp003" SKIP.
	    PUT UNFORMATTED "#def :end" SKIP.
*/

/*export  delimiter ";"                  */
/*   disp   with frame s .               */
/*         {mfrpexit.i}                  */


		for each tr_hist 
			fields( tr_domain   tr_nbr   tr_lot   tr_trnbr 
					tr_effdate  tr_type  tr_rmks  tr_part 
					tr_um 
					tr_qty_loc tr_date tr_userid  )
			use-index tr_type 
			where tr_domain = global_domain 
			
			and tr_type = "iss-wo"
			and tr_effdate >= date and tr_effdate <= date1 
			and tr_nbr >= nbr and tr_nbr <= nbr1  	/*		*/  /*type + eff*/

			/*use-index tr_nbr_eff   
			where tr_domain = global_domain 
			and tr_nbr >= nbr and tr_nbr <= nbr1 
			and tr_effdate >= date and tr_effdate <= date1 
			and tr_type = "iss-wo" */ /*nbr + eff*/
			and tr_part >= part   and tr_part <= part1 
			and tr_rmks >= nbra   and tr_rmks <= nbra1 
			no-lock break by tr_nbr by tr_rmks 
			with frame x width 300 :

			disp 
			    tr_effdate label "生效日期"
				tr_nbr label "加工单号" 
				tr_lot label "加工ID"
				tr_rmks format "x(18)" label "自编单号"
				tr_part label "零件编号"
				tr_um   label "UM"
				tr_qty_loc  label "发料数量"
				/*  tr_type tr_trnbr tr_date tr_userid*/ 
			with frame x.
		end. /*for each tr_hist*/





        
    end. /* mainloop: */
    /* {mfrtrail.i}  REPORT TRAILER  */
    {mfreset.i}
end.  /* REPEAT */

