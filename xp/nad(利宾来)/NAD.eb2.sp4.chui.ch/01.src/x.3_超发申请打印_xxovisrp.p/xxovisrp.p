/*xxovisrp01.p 超发申请单打印     */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110121.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

&SCOPED-DEFINE v_rptwidth 200
&SCOPED-DEFINE v_width    182

{mfdtitle.i "110121.1"}



define var v_nbr    like rqd_nbr no-undo.
define var v_nbr1   like rqd_nbr no-undo.
define var date     like rqm_req_date no-undo.
define var date1    like rqm_req_date no-undo.
define var v_user   like rqm_rqby_userid no-undo.
define var v_user1  like rqm_rqby_userid no-undo.
define var v_wonbr  like wo_nbr  no-undo.
define var v_wonbr1 like wo_nbr  no-undo.
define var v_wolot  like wo_lot  no-undo.
define var v_wolot1 like wo_lot  no-undo.
define var part     like pt_part no-undo.
define var part1    like pt_part no-undo.
define var stat     like xovd_status no-undo.
define var stat1    like xovd_status no-undo.
define var v_pct    as decimal format ">>>>9.99%"  no-undo .
define var v_pct1   as decimal format ">>>>9.99%"  no-undo init 99999. 
define var v_cmmt   as logical init yes no-undo.

define var i                  as integer . /*for gpcmtrp*/

define var v_wopart           like wo_part .
define var v_desc             as char format "x(48)" .
define var v_iss_times        as integer  .
define var v_qty_pct          as decimal format ">>>>9.99%" .
define var v_qty_open         like tr_qty_loc .
define var v_qty_ord          like tr_qty_loc .
define var v_qty_total        like tr_qty_loc .
define var v_blank            as char init "(      )".

form
    SKIP(.2)
    v_nbr        colon 15 label "申请单号"
    v_nbr1       colon 48 label "至"
    date         colon 15 label "申请日期"    
    date1        colon 48 label "至"          
    v_user       colon 15 label "申请人"     
    v_user1      colon 48 label "至"           
    v_wonbr      colon 15 label "工单编号"     
    v_wonbr1     colon 48 label "至"           
    v_wolot      colon 15 label "工单ID"     
    v_wolot1     colon 48 label "至"           
    part         colon 15 label "零件号"     
    part1        colon 48 label "至"           
    stat         colon 15 label "状态"     
    stat1        colon 48 label "至"           
    v_pct        colon 15 label "超发百分比"     
    v_pct1       colon 48 label "至"    
    skip(1)
    v_cmmt       colon 20 label "是否打印说明" 
                    
skip(1)             
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).


form 
    xovd_line       label "行"
    xovd_wonbr      label "工单"
    xovd_wolot      label "工单ID"
    xovd_part       label "物料"
    v_desc          label "说明"
    v_qty_open      label "短缺量"
    xovd_iss_qty    label "超发量" 
    xovd_iss_times  label "第几次"
    v_qty_total     label "累计超发量" 
    v_qty_pct       label "累计超发%"
    xovd_status     label "状态" 
    v_wopart        label "父零件"
    v_blank         label "实发数量"
with frame x down width {&v_rptwidth} .	


{wbrp01.i}
repeat:

    if v_nbr1      = hi_char  then v_nbr1   = "" .    
    if v_user1     = hi_char  then v_user1  = "" .    
    if v_wonbr1    = hi_char  then v_wonbr1 = "" .    
    if v_wolot1    = hi_char  then v_wolot1 = "" .    
    if part1       = hi_char  then part1    = "" .    
    if stat1       = hi_char  then stat1    = "" .    
    if date        = low_date then date     = ?  .    
    if date1       = hi_date  then date1    = ?  .    
        update 
            v_nbr          
            v_nbr1      
            date      
            date1     
            v_user
            v_user1
            v_wonbr   
            v_wonbr1  
            v_wolot   
            v_wolot1  
            part      
            part1     
            stat      
            stat1    
            v_pct  
            v_pct1 
            v_cmmt
        with frame a.

    if v_pct1      = 0   then v_pct1   = 99999. 
    if v_nbr1      = ""  then v_nbr1   = hi_char .    
    if v_user1     = ""  then v_user1  = hi_char .    
    if v_wonbr1    = ""  then v_wonbr1 = hi_char .    
    if v_wolot1    = ""  then v_wolot1 = hi_char .    
    if part1       = ""  then part1    = hi_char .    
    if stat1       = ""  then stat1    = hi_char .                                                     
    if date        = ?   then date     = low_date.    
    if date1       = ?   then date1    = hi_date .    
    

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


    for each xovm_mstr 
            where xovm_nbr >= v_nbr and xovm_nbr  <= v_nbr1 
            and   xovm_mod_date >= date and xovm_mod_date <= date1
            and   xovm_mod_user >= v_user and xovm_mod_user <= v_user1
        no-lock,
        each xovd_det 
            where xovd_nbr   = xovm_nbr 
            and xovd_wonbr  >= v_wonbr and xovd_wonbr <= v_wonbr1
            and xovd_wolot  >= v_wolot and xovd_wolot <= v_wolot1 
            and xovd_part   >= part and xovd_part   <= part1 
            and xovd_status >= stat and xovd_status <= stat1
        no-lock
        break by xovd_nbr by xovd_line :


        find first pt_mstr where pt_part = xovd_part no-lock no-error.
        v_Desc = if avail pt_mstr then pt_desc1 + pt_desc2 else "" .
        
        find first wo_mstr where wo_lot = xovd_wolot no-lock no-error.
        v_wopart = if avail wo_mstr then wo_part else "" .

        v_qty_open = 0 .
        v_qty_ord  = 0 .
        for each wod_det where wod_lot = xovd_wolot and wod_part = xovd_part no-lock :
            v_qty_open = v_qty_open + max(0, wod_qty_req - wod_qty_iss ) .
            v_qty_ord  = v_qty_ord  + wod_qty_req .
        end.

        {gprun.i ""xxovisrpa.p"" "(input xovd_part, input xovd_nbr , input xovd_wolot , output v_iss_times , output v_qty_total )"}

        v_iss_times = v_iss_times + 1 .
        v_qty_total = v_qty_total + xovd_iss_qty .
        v_qty_pct = if v_qty_ord <> 0  then v_qty_total * 100 / v_qty_ord else 100.

        if not ( v_qty_pct >= v_pct and v_qty_pct <= v_pct1 ) then next . 
        form header 
            "申请单号:" colon 4  xovm_nbr 
            "申请日期:" colon 24 xovm_mod_date
            "地点:"     colon 45 xovm_site  
            skip
            fill("-",{&v_width}) format "x({&v_width})"
        with frame topx page-top side-labels width {&v_rptwidth}.
        view frame topx .


        disp 
            xovd_line   
            xovd_wonbr              
            xovd_wolot  
            xovd_part   
            v_desc      
            v_qty_open  
            xovd_iss_qty
            xovd_iss_times 
            v_qty_total 
            v_qty_pct   
            xovd_status 
            v_wopart     
            v_blank
        with frame x.
        down with frame x.

        if v_cmmt then do:
            {gpcmtprt.i &type="RP" &id=xovd_cmtidx &pos=52}
        end.



         if (page-size  - line-counter) < 4 
            or last-of(xovd_nbr) 
         then do:
             if (page-size  - line-counter) >= 4 then do:
                put skip(page-size  - line-counter - 5) .
             end.

             put unformatted fill("-",{&v_width}) skip.
             put "申请人:" xovm_mod_user  .
             put "审核:                                 批准:                   收件人:    " at 32 skip.
             page.
         end.

        {mfrpexit.i}
    end. /*for each xovm_mstr*/

end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}