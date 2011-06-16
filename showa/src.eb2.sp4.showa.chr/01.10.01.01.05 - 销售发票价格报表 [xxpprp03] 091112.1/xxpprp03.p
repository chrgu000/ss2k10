/* ss - 091112.1 by: jack */
/*-Revision end--------------------------------------------------------------------------*/



/* DISPLAY TITLE */

{mfdtitle.i "091112.1"}


define var plist like xxpi_list .
define var plist1 like xxpi_list .
define var part like xxpi_part .
define var part1 like xxpi_part .
define var curr like xxpi_curr .
define var curr1 like xxpi_curr .
define var effective like xxpi_start .
define var effective1 like xxpi_start .
define var type1 as char format "x(1)" .
form

   plist           colon 16  
   plist1        label {t001.i}  colon 45  
   
   part       colon 16  
   part1    label {t001.i}  colon 45  
   
   curr           colon 16  
   curr1         label {t001.i}  colon 45  
   
   effective      colon 16  
   effective1    label {t001.i} colon 45 
 SKIP(1)
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   
    
   
    if plist1  = hi_char   then plist1 = "".
    if part1   = hi_char   then part1  = "".
    IF curr1 = hi_char THEN curr1 = "" .
    if effective = low_date then effective = ? .
    if effective1 = hi_date then effective1 = ? .
    
   

    UPDATE  plist plist1 part part1 curr curr1 effective  effective1  with frame a.

    
    if plist1 = ""   then plist1 = hi_char .
    if part1 = ""   then  part1  = hi_char .
    IF curr1 = "" THEN curr1 = hi_char .
    if  effective = ? then effective = low_date  .
    if  effective1 = ? then effective1 = hi_date  .
    

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

export delimiter ";" "价格单" "零件" "币别" "单位" "开始日期" "失效日期" "价格"   .

  for each xxpi_mstr no-lock  where ( xxpi_list >= plist and xxpi_list <= plist1 ) 
      and (xxpi_part >= part and xxpi_part <= part1) 
      and (xxpi_curr >= curr and xxpi_curr <= curr1)
      and (xxpi_start >= effective and xxpi_start <= effective1 ) :
      
 

	put unformatted xxpi_list ";" xxpi_part ";" xxpi_curr ";" xxpi_um ";" xxpi_start ";" xxpi_expire ";" xxpi_list_price FORMAT "->>>,>>>,>>9.99<<" skip.
	
      {mfrpchk.i}
      end .
 



end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


    
