/* xsboexp.p Export Data Ctrl Prg *Created By: Jack Huang 2004/11/18* */

/* DISPLAY TITLE */

{mfdtitle.i "AO+ "}

def var xlog_lnr# like xlog_lnr.
def var xlog_lnr#2 like xlog_lnr.
def var xlog_part# like xlog_part.
def var xlog_part#2 like xlog_part.
def var xlog_lot# like xlog_lot.
def var xlog_lot#2 like xlog_lot.
def var xlog_obj# like xlog_obj.
def var xlog_obj#2 like xlog_obj.
def var xlog_date# like xlog_date.
def var xlog_date#2 like xlog_date.
def var xlog_class# like xlog_class.
def var xlog_class#2 like xlog_class. 

form
   space(1)
   
   
   xlog_lnr#		label "生产线" colon 18
   xlog_lnr#2          label {t001.i} colon 52 skip
   
   xlog_part#		label "零件号" colon 18
   xlog_part#2          label {t001.i} colon 52 skip

   xlog_lot#		label "批号" colon 18
   xlog_lot#2          label {t001.i} colon 52 skip
   
   xlog_obj#          label "业务对象" colon 18
   xlog_obj#2         label {t001.i} colon 52 skip
   
   xlog_class#        label "信息类型" colon 18
   xlog_class#2       label {t001.i} colon 52 skip
   
   xlog_date#         label "日期"   colon 18
   xlog_date#2        label {t001.i} colon 52 skip     
   
with frame a side-labels width 80 attr-space.

repeat:
    if xlog_lnr#2 = hi_char  then xlog_lnr#2 = "".
   if xlog_part#2 = hi_char  then xlog_part#2 = "".
   if xlog_lot#2 = hi_char  then xlog_lot#2 = "".
   if xlog_obj#2 = hi_char then xlog_obj#2 = "".
   if xlog_class#2 = hi_char then xlog_class#2 = "".
   if xlog_date# = low_date then xlog_date# = ?.
   if xlog_date#2 = hi_date then xlog_date#2 = ?.
   disp
        xlog_lnr#		
        xlog_lnr#2    
        xlog_part#    
        xlog_part#2   
        xlog_lot#		
        xlog_lot#2    
        xlog_obj#    
        xlog_obj#2   
        xlog_class#  
        xlog_class#2         
        xlog_date#
        xlog_date#2     
with frame a.
   
   set
        xlog_lnr#		
        xlog_lnr#2    
        xlog_part#    
        xlog_part#2   
        
	xlog_lot#		
        xlog_lot#2    
        xlog_obj#    
        xlog_obj#2   
        xlog_class#  
        xlog_class#2 
        xlog_date#
        xlog_date#2     
with frame a.
   
   if xlog_date# = ? then xlog_date# = low_date.
   if xlog_date#2 = ? then xlog_date#2 = hi_date.
   
   if xlog_lot#2 = "" then xlog_lot#2 = hi_char.
   if xlog_lnr#2 = "" then xlog_lnr#2 = hi_char.
   if xlog_part#2 = "" then xlog_part#2 = hi_char.
   if xlog_obj#2 = "" then xlog_obj#2 = hi_char.
   if xlog_class#2 = "" then xlog_class#2 = hi_char.
   
   /* OUTPUT DESTINATION SELECTION */
   /* terminal */
   {gpselout.i &printType = "PAGE"
               &printWidth = 280
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

	
    for each xlog_det where 
         xlog_lnr   >= xlog_lnr#       and
         xlog_lnr   <= xlog_lnr#2      and
         xlog_part   >= xlog_part#       and
         xlog_part   <= xlog_part#2      and
         xlog_lot   >= xlog_lot#       and
         xlog_lot   <= xlog_lot#2      and
         xlog_obj  >= xlog_obj#      and
         xlog_obj  <= xlog_obj#2     and
         xlog_date >= xlog_date#     and 
         xlog_date  <= xlog_date#2   and
         
         xlog_class >=  xlog_class#  and
         xlog_class <= xlog_class#2  no-lock:   
	
        DISPLAY 
                xlog_lnr
		xlog_part
		xlog_lot                  
		xlog_obj  
		xlog_date 	
		xlog_class	
		xlog_desc 	
      with  width 280.
    end. /* end for each xlog_det */

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.