/* xxbmrp003.p - 加工单物料替代关系查询报表                                                           */
/*----rev history-------------------------------------------------------------------------------------*/
/* REVISION: 100907.1  Created On: 20100907   BY: Roger Xiao  ECO:*100907.1*   */



{mfdtitle.i "100907.1"}

define var part    like pt_part .
define var part1   like pt_part .
define var part2   like pt_part .
define var part3   like pt_part .
define var lot     like wo_lot  .
define var lot1    like wo_lot  .
define var wonbr   like wo_nbr  .
define var wonbr1  like wo_nbr  .

define var v_index as char .


form
    SKIP(.2)

wonbr     colon 15 label "工单编号"
wonbr1    colon 49 label "to"
lot       colon 15 label "工单ID"
lot1      colon 49 label "to"
part      colon 15 label "原物料"
part1     colon 49 label "to"
part2     colon 15 label "替代料"
part3     colon 49 label "to"





skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    if part1    = hi_char  then part1 = "" .    
    if part3    = hi_char  then part3 = "" .    
    if lot1     = hi_char  then lot1  = "" .    
    if wonbr1   = hi_char  then wonbr1  = "" .  
    
    update 
        wonbr    
        wonbr1   
        lot    
        lot1   
        part   
        part1  
        part2  
        part3  
    with frame a.

    if      wonbr <> "" or wonbr1 <> "" then v_index = "wonbr" .
    else if lot   <> "" or lot1   <> "" then v_index = "lot" .
    else if part  <> "" or part1  <> "" then v_index = "p1" .
    else if part2 <> "" or part3  <> "" then v_index = "p2" .

    if v_index = "" then v_index = "wonbr" .

    if part1   = ""  then part1    = hi_char .    
    if part3   = ""  then part3    = hi_char .    
    if lot1    = ""  then lot1     = hi_char .    
    if wonbr1  = ""  then wonbr1   = hi_char .       

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

if v_index = "wonbr" then do:
    {xxbmrp003.i 
        "x1" 
        "xsub_wonbr" 
        "xsub_wonbr >= wonbr and xsub_wonbr <= wonbr1" 
        "and  xsub_wolot >= lot and xsub_wolot <= lot1" 
        "and  xsub_part >= part and xsub_part <= part1" 
        "and  xsub_subpart >= part2 and xsub_subpart <= part3 "}
end.
if v_index = "lot" then do:
    {xxbmrp003.i 
        "x2" 
        "xsub_wolot" 
        "xsub_wolot >= lot and xsub_wolot <= lot1" 
        "and xsub_wonbr >= wonbr and xsub_wonbr <= wonbr1  "
        "and xsub_part >= part and xsub_part <= part1 "
        "and xsub_subpart >= part2 and xsub_subpart <= part3 "}
end.
if v_index = "p1" then do:
    {xxbmrp003.i 
        "x3" 
        "xsub_part" 
        "xsub_part >= part and xsub_part <= part1 "
        "and xsub_wonbr >= wonbr and xsub_wonbr <= wonbr1 "
        "and xsub_wolot >= lot and xsub_wolot <= lot1 "
        "and xsub_subpart >= part2 and xsub_subpart <= part3 "}
end.

if v_index = "p2" then do:
    {xxbmrp003.i 
        "x4" 
        "xsub_subpart" 
        "xsub_subpart >= part2 and xsub_subpart <= part3 "
        "and xsub_wonbr >= wonbr and xsub_wonbr <= wonbr1 "
        "and xsub_wolot >= lot and xsub_wolot <= lot1 "
        "and xsub_part >= part and xsub_part <= part1 "}
end.



end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
