/* xxworp001.p - 工单成本比较报表                                           */
/*----rev history-----------------------------------------------------------*/
/* SS - 100811.1  By: Roger Xiao */ /*create*/
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "101011.1"}


{xxworp001var.i "new" }

define var v_index as char .




form
    SKIP(.2)
    wonbr               colon 18 label "工单编号"
    wonbr1              colon 53 label "至" 
    lot                 colon 18 label "工单ID"
    lot1                colon 53 label "至"
    part                colon 18 label "零件号"
    part1               colon 53 label "至"
    line                colon 18 label "产品线"
    line1               colon 53 label "至"
    rdate               colon 18 label "发放日期"
    rdate1              colon 53 label "至"
    cdate               colon 18 label "结算日期"
    cdate1              colon 53 label "至"
                        skip(1)
    v_all               colon 18 label "范围" 
                                 " (1-全部,2-仅已结,3-仅未结)"
        
skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1    = hi_char  then part1  = "" .
    if line1    = hi_char  then line1  = "" .
    if wonbr1   = hi_char  then wonbr1 = "" .
    if lot1     = hi_char  then lot1   = "" .
    if cdate    = low_date then cdate  = ? .
    if cdate1   = hi_date  then cdate1 = ? .
    if rdate    = low_date then rdate  = ? .
    if rdate1   = hi_date  then rdate1 = ? .
    
    update 
        wonbr
        wonbr1
        lot        
        lot1       
        part              
        part1      
        line       
        line1   
        rdate       
        rdate1      
        cdate       
        cdate1      
        v_all                      
          
    with frame a.


    if      wonbr > "" or  wonbr1 > "" then v_index = "nbr"   .
    else if lot   > "" or  lot1   > "" then v_index = "lot"   .
    else if part  > "" or  part1  > "" then v_index = "part"  .
    else if line  > "" or  line1  > "" then v_index = "prodline"  .


    if v_all < 1 or v_all > 3 then do:
        message "错误:范围值无效,请重新输入" .
        undo,retry.
    end.


    if part1    =  "" then part1  = hi_char .
    if line1    =  "" then line1  = hi_char .
    if wonbr1   =  "" then wonbr1 = hi_char .
    if lot1     =  "" then lot1   = hi_char .
    if cdate    =  ?  then cdate  = low_date.
    if cdate1   =  ?  then cdate1 = hi_date .
    if rdate    =  ?  then rdate  = low_date.
    if rdate1   =  ?  then rdate1 = hi_date .
    

    /* PRINTER SELECTION */
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

    if v_index = "part" then do:
        {gprun.i ""xxworp001a.p"" }
    end.
    else if v_index = "prodline" then do:
        {gprun.i ""xxworp001d.p"" }
    end.
    else if v_index = "lot" then do:
        {gprun.i ""xxworp001b.p"" }
    end.
    else do:
        {gprun.i ""xxworp001c.p"" }
    end.

end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}

