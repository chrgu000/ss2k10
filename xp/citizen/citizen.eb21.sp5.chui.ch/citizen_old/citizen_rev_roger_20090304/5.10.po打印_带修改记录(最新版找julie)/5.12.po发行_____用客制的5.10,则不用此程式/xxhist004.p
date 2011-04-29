/* $CREATED BY: softspeed Roger Xiao         DATE: 2008/01/13  ECO: *xp002*  */
/*-Revision end---------------------------------------------------------------*/




/* DISPLAY TITLE */
{mfdtitle.i "1.0"}


define var nbr like po_nbr label "订单号".
define var nbr1 like po_nbr .
define var v_type as char label "单据类型" initial "PO".
define var v_line as integer .
define var v_hist as logical initial no .

define temp-table tt 
	field t_nbr like po_nbr .


define  frame a.

form

    SKIP(1)

	nbr        	colon 18   
	nbr1	    colon 45 
	skip(1)
	/*v_type      colon 18 */

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
		/*v_type*/
		with frame a.

	if nbr1 = ""      then nbr1 = hi_char.


	for each tt: delete tt . end .

	for each po_mstr 
				where po_domain = global_domain 
				and po_nbr >= nbr and po_nbr <= nbr1 
				exclusive-lock :

			if po__chr01 = "" then do:
				v_hist = no .
				{gprun.i ""xxhist001.p"" "(input ""PO"" ,input po_nbr ,input 3,output v_hist )"}
				if v_hist then do:
					po__chr01 = "R" .  /*改为发行版本*/
					po_print = yes .   /*改为未列印*/

					create tt . t_nbr = po_nbr .
				end.
				
			end.
	end. /*for each po_mstr*/



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
	printloop: 
	do on error undo, return error on endkey undo, return error:                    

	put "本次发行的订单明细如下:" skip skip(2) .
	for each tt break by t_nbr :
			for each po_mstr where po_domain = global_domain and po_nbr = t_nbr no-lock ,
				each pod_Det where pod_domain = global_domain and pod_nbr = po_nbr 
				no-lock break by pod_nbr by pod_line 
				with frame x width 300 :
				setFrameLabels(frame x:handle).

				disp po_nbr po_vend po_ship 
					po_ord_date po_due_date 
					pod_line  pod_part  pod_qty_ord  pod_pur_cost 
					pod_due_date  pod_need   po_rev po__chr01 
					with frame x .


			end.
	end. /*for each tt*/


	end. /* printloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
