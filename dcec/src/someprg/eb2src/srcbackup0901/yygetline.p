/* zzgetline.p  - SUB PROCEDUCE, GET INV QTY FROM VPH_HIST   */
/* BY LB01        LONGBO              2004-6-11               */


	define input parameter nbr like lad_nbr.
	define input-output parameter line like lad_line no-undo.
	
	define variable lenline as integer.
	define variable i as integer.



    lenline = length(line).
	            
    do i = 1 to lenline:
    	if index("0123456789",substring(line,i,1)) = 0 then do:
    		line = "".
    		leave.
    	end.
    end.
	if line = "" then do :
		find last lad_det where lad_dataset = "itm_det"
		and lad_nbr = nbr use-index lad_det no-lock no-error.
		if available lad_det then
			line = substring(string(integer(lad_line) + 1001),2,3).
		else
			line = "001".        /*lb01*/
	end.
