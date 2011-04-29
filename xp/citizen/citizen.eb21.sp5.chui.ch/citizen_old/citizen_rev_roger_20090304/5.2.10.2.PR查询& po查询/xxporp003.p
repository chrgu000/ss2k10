/* $CREATED BY: softspeed Roger Xiao         DATE: 2008/01/13  ECO: *xp002*  */
/*-Revision end---------------------------------------------------------------*/




/* DISPLAY TITLE */
{mfdtitle.i "1.0"}


define var nbr like po_nbr label "¶©µ¥ºÅ".
define var nbr1 like po_nbr .







define  frame a.

form

    SKIP(1)

	nbr        	colon 18   
	nbr1	    colon 45 
	skip(1)


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


for each po_mstr 
        where po_domain = global_domain 
        and po_nbr >= nbr and po_nbr <= nbr1  no-lock,
    each pod_det 
        where pod_domain = global_domain 
        and pod_nbr  = po_nbr no-lock 
    break by pod_nbr by pod_line 
    with frame x width 250 :
    
    setFrameLabels(frame x:handle).
    disp    po_vend 
            po_curr 
            pod_nbr 
            pod_line 
            po_ord_date
            pod_due_date
            pod_part 
            pod_um 
            pod_qty_ord 
            pod_pur_cost 
            pod_so_job format "x(32)" 
         with frame x .

end.


	end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
