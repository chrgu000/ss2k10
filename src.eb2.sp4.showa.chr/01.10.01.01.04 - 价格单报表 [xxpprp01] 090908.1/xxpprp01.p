/* ss - 090908.1 by: jack */
/*-Revision end--------------------------------------------------------------------------*/



/* DISPLAY TITLE */

{mfdtitle.i "090908.1"}


define var plist like pi_list .
define var plist1 like pi_list .
define var part_code like pi_part_code .
define var part_code1 like pi_part_code .
define var curr like pi_curr .
define var curr1 like pi_curr .
define var effective like pi_start .
define var effective1 like pi_start .
define var type1 as char format "x(1)" .
form

   plist           colon 16  
   plist1        label {t001.i}  colon 45  
   
   part_code       colon 16  
   part_code1    label {t001.i}  colon 45  
   
   curr           colon 16  
   curr1         label {t001.i}  colon 45  
   
   effective      colon 16  
   effective1    label {t001.i} colon 45 
   type1          colon 16    " 1 计划价 2 结算价  空为全部 "  colon 20
   skip(1)        

skip(1)
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   
    
     type1 = "" .
    if plist1  = hi_char   then plist1 = "".
    if part_code1   = hi_char   then part_code1  = "".
    IF curr1 = hi_char THEN curr1 = "" .
    if effective = low_date then effective = ? .
    if effective1 = hi_date then effective1 = ? .
    
   

    UPDATE  plist plist1 part_code part_code1 curr curr1 effective  effective1 type1 with frame a.

    
    if plist1 = ""   then plist1 = hi_char .
    if part_code1 = ""   then  part_code1  = hi_char .
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

export delimiter ";" "价格单" "零件" "币别" "单位" "开始日期" "失效日期" "价格" "价格类型"  .

if type1 = "" then do:
  for each pi_mstr no-lock  where ( pi_list >= plist and pi_list <= plist1 ) and pi_cs_type = "9" and pi_part_type = "6"
      and (pi_part_code >= part_code and pi_part_code <= part_code1) 
      and (pi_curr >= curr and pi_curr <= curr1)
      and (pi_start >= effective and pi_start <= effective1 ) :
      
 

	put unformatted pi_list ";" pi_part_code ";" pi_curr ";" pi_um ";" pi_start ";" pi_expire ";" pi_list_price ";" pi__chr01 skip.
	
      {mfrpchk.i}
      end .
 end .
 else if type1 = "1" then do:  /* 计划价*/
    for each pi_mstr no-lock  where ( pi_list >= plist and pi_list <= plist1 ) and pi_cs_type = "9" and pi_part_type = "6"
      and (pi_part_code >= part_code and pi_part_code <= part_code1) 
      and (pi_curr >= curr and pi_curr <= curr1)
      and (pi_start >= effective and pi_start <= effective1 )
      and pi__chr01 = "计划价":
      
	put unformatted pi_list ";" pi_part_code ";" pi_curr ";" pi_um ";" pi_start ";"  pi_expire ";" pi_list_price ";" pi__chr01 skip .
	
      {mfrpchk.i}
      end .
  end .
 else if type1 = "2" then do:  /* 结算价 */
    for each pi_mstr no-lock  where ( pi_list >= plist and pi_list <= plist1 ) and pi_cs_type = "9" and pi_part_type = "6"
      and (pi_part_code >= part_code and pi_part_code <= part_code1) 
      and (pi_curr >= curr and pi_curr <= curr1)
      and (pi_start >= effective and pi_start <= effective1 )
      and pi__chr01 = "结算价":
      
	put unformatted pi_list ";" pi_part_code ";" pi_curr ";" pi_um ";" pi_start ";"  pi_expire ";" pi_list_price ";" pi__chr01 skip.
	
      {mfrpchk.i}
      end .
  end .



end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


    
