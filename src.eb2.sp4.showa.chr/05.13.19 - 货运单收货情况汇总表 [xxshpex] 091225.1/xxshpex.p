define var vend1 like vd_addr.
define var vend2 like vd_addr.
define var date1 like pod_due_date.
define var date2 like pod_due_date.

{mfdtitle.i "091225.1"}

form 
  vend1 label "供应商" colon 20 
  vend2 label "至" colon 49  skip
  date1 label "日期" colon 20
  date2 label "至" colon 49  skip
with frame a side-labels width 80 attr-space.

repeat :
  
  if vend2 = hi_char then vend2 = "".
	if date1 = low_date then date1 = ?.
	if date2 = hi_date then date2 = ?.

  
  update vend1 vend2 date1 date2 with frame a.

  
  if vend2 = "" then vend2 = hi_char.
  if date1 = ? then date1 = low_date.
  if date2 = ? then date2 = hi_date.
   
  /* OUTPUT DESTINATION SELECTION */
  {gpselout.i &printType = "printer"
              &printWidth = 132
              &pagedFlag = " "
              &stream = " "
              &appendToFile = " "
              &streamedOutputToTerminal = " "
              &withBatchOption = "no"
              &displayStatementType = 1
              &withCancelMessage = "yes"
              &pageBottomMargin = 6
              &withEmail = "yes"
              &withWinprint = "yes"
              &defineVariables = "yes"}
  /*
  {mfphead.i}
  */
 
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.
   
  {gprun.i ""xxshpexprise.p"" "(input vend1,
                                input vend2,
                                input date1,
                                input date2
                                )  
                                    "}
 
  {xxmfrtrail.i}
  
end.