/* ss - 091009.1 by: jack */
/*-Revision end--------------------------------------------------------------------------*/



/* DISPLAY TITLE */

{mfdtitle.i "091009.1"}

DEFINE VAR soorddate LIKE so_ord_date .
DEFINE VAR soorddate1 LIKE so_ord_date .
DEFINE VAR sonbr LIKE so_nbr .
DEFINE VAR sonbr1 LIKE so_nbr .
DEFINE VAR socust LIKE so_cust .
DEFINE VAR socust1 LIKE so_cust .
DEFINE VAR v_name LIKE ad_name .

form
   
   soorddate           colon 16  
   soorddate1         label {t001.i}  colon 45 

   socust           colon 16  
   socust1        label {t001.i}  colon 45  
  
   sonbr       colon 16  
   sonbr1    label {t001.i}  colon 45  
   
   
   
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   
    if socust1 = hi_char then socust1 = "" .
    if sonbr1   = hi_char   then sonbr1  = "".
    if soorddate  = low_date   then soorddate = ?.
    if soorddate1 = hi_date then soorddate1 = ? .
    
    
    
   

    UPDATE  soorddate soorddate1 socust socust1 sonbr sonbr1   with frame a.

    if socust1 = "" then socust1 = hi_char .
    if sonbr1 = ""   then  sonbr1  = hi_char .
    if soorddate = ?   then soorddate = low_date .
    if soorddate1 = ? then soorddate1 = hi_date .
    
    
    

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



PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
PUT UNFORMATTED "#def :end" SKIP.

export delimiter ";" "客户" "客户名称" "订单" "项次" "零件" "订单日期" "订购数量"  . 


     FOR EACH so_mstr WHERE (so_ord_date >= soorddate AND so_ord_date <= soorddate1) AND (so_cust >= socust AND so_cust <= socust1),
          EACH sod_det  NO-LOCK WHERE sod_nbr = so_nbr AND sod_list_pr = 0  BREAK BY sod_nbr BY sod_line :
    
       IF FIRST-OF(sod_nbr) THEN DO:
       
	  find first ad_mstr where ad_addr = so_cust no-lock no-error .
      IF AVAILABLE ad_mstr THEN
          v_name = ad_name .
      ELSE 
          v_name = "" .
       END.
           
	   export delimiter ";" so_cust v_name sod_nbr sod_line sod_part  so_ord_date sod_qty_ord .
	  
     {mfrpchk.i}
	  
	end .


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


    
