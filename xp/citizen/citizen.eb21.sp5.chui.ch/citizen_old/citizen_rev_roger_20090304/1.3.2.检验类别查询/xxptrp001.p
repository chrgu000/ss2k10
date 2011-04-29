
/* DISPLAY TITLE */
{mfdtitle.i "1.0"}


define var part like pt_part .
define var part1 like pt_part .
define var vend like pt_vend .
define var vend1 like pt_vend .
define var prod_line like pt_prod_line .
define var prod_line1 like pt_prod_line .


define  frame a.

form

    SKIP(1)

	part        	colon 13   
	part1	colon 49 
	vend	colon 13 
	vend1	colon 49 
	prod_line	colon 13 
	prod_line1	colon 49 
	skip(1)
	

with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

	if part1 = hi_char       then part1 = "".
	if vend1 = hi_char       then vend1 = "".
	if prod_line1 = hi_char       then prod_line1 = "".

	 update 	
		part          
		part1
		vend
		vend1
		prod_line
		prod_line1 with frame a.

	if part1 = ""      then part1 = hi_char.
	if vend1 = ""       then vend1 = hi_char.
	if prod_line1 = ""       then prod_line1 = hi_char .


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



	for each pt_mstr  
			where pt_domain = global_domain 
			and pt_part >= part and pt_part <= part1
			and pt_vend >= vend and pt_vend <= vend1
			and pt_prod_line >= prod_line and pt_prod_line <= prod_line1 
	no-lock with frame x width 300 break by pt_part :
		disp pt_part label "零件号" 
		     pt_desc1 label "说明1" 
			 pt_Desc2 label "说明2" 
			 pt_vend label "供应商" 
			 pt_prod_line column-label "生产线" 
			 pt_loc label "库位"
			 pt__chr03 label "检验类别" format "x(8)"
			 pt__log01 label "需要检验" 
			 with frame x .
	end.



	end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
