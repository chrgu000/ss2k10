/* xxporp001.p - 采购单历史价格表                                           */
/* REVISION: 100803.1      Created On: 20100803 ,  BY: Roger Xiao           */
/*----rev history-----------------------------------------------------------*/



{mfdtitle.i "100803.1"}


define var date      as date .
define var date1     as date .
define var vend      like po_vend.
define var vend1     like po_vend.
define var part      like pt_part .
define var part1     like pt_part .
define var nbr       as char .
define var nbr1      as char .
define var v_yn      as logical initial Yes .

define var v_desc1   as char format "x(24)" .
define var v_desc2   as char format "x(24)" .

define var v_qty_rct   like tr_qty_loc .
define var v_amt_rct   like tr_qty_loc .
define var v_qty_ord   like pod_qty_ord .
define var v_tmp_price like tr_price .

define temp-table temp1 
    field t1_part  like tr_part 
    field t1_vend  like po_vend 
    field t1_nbr   like tr_nbr 
    field t1_line  like tr_line
    field t1_lot   like tr_lot
    field t1_qty   like tr_qty_loc
    field t1_amt   like tr_qty_loc
    field t1_date  like tr_effdate
    field t1_price like tr_price 
    .


form
    SKIP(.2)
    part                colon 18 label "物料号"
    part1               colon 53 label "至"
    date                colon 18 label "收货日期"
    date1               colon 53 label "至" 
    nbr                 colon 18 label "采购单"
    nbr1                colon 53 label "至"
    vend                colon 18 label "供应商"
    vend1               colon 53 label "至"
    v_yn                colon 18 label "仅显示有差异的"
        
skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    for each temp1 : delete temp1 . end.

    if date     = low_date then date  = ? .
    if date1    = hi_date  then date1 = ? .
    if vend1    = hi_char  then vend1 = "" .
    if part1    = hi_char  then part1 = "" .
    if nbr1     = hi_char  then nbr1  = "" .
    
    update 
        part     
        part1    
        date     
        date1    
        nbr  
        nbr1 
        vend     
        vend1    
        v_yn
    with frame a.

    if date     = ?  then date      =  low_date.
    if date1    = ?  then date1     =  hi_date .
    if vend1    = "" then vend1     =  hi_char .
    if part1    = "" then part1     =  hi_char .
    if nbr1     = "" then nbr1      =  hi_char .
    

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


    for each tr_hist 
        use-index tr_part_eff
        where tr_domain = global_domain 
        and   tr_part    >= part and tr_part    <= part1 
        and   tr_effdate >= date and tr_effdate <= date1 
        and   tr_type = "RCT-PO"
        and   tr_nbr     >= nbr  and tr_nbr     <= nbr1 
        and   tr_addr    >= vend and tr_addr    <= vend1 
    no-lock :
        find first temp1
            where t1_part  = tr_part     
              and t1_nbr   = tr_nbr      
              and t1_line  = tr_line     
              and t1_lot   = tr_lot 
              and t1_date  = tr_effdate 
              and t1_price = tr_price
        no-error.
        if not avail temp1 then do:
            create temp1 .
            assign               
                   t1_part  = tr_part 
                   t1_nbr   = tr_nbr  
                   t1_line  = tr_line 
                   t1_lot   = tr_lot  
                   t1_date  = tr_effdate  
                   t1_price = tr_price    
                   t1_vend  = tr_addr     
                   .
        end.
        t1_qty   = t1_qty  + tr_qty_loc  .
        t1_amt   = t1_amt  + tr_qty_loc * tr_price .
    end. /*for each tr_hist*/

    for each temp1 
        break by t1_part by t1_price by t1_date by t1_lot by t1_line 
        with frame x with width 300:

        if first-of(t1_part) then do:
            v_qty_rct = 0 .
            v_amt_rct = 0 .
        end.

        v_qty_rct = v_qty_rct + t1_qty .
        v_amt_rct = v_amt_rct + t1_amt .

        
        find first pod_det where pod_domain = global_domain and pod_nbr = t1_nbr and pod_line = t1_line no-lock no-error.
        v_qty_ord = if avail pod_det then pod_qty_ord else 0.
        
        find first pt_mstr where pt_domain = global_domain and pt_part = t1_part no-lock no-error.
        v_desc1 = if avail pt_mstr then pt_desc1 else "" .

        find first ad_mstr where ad_domain = global_domain and ad_addr = t1_vend no-lock no-error.
        v_desc2 = if avail ad_mstr then ad_name else "" .

        if v_yn = no then do:
            disp 
                t1_part          column-label "零件号"
                v_desc1          column-label "零件名称"
                t1_vend          column-label "供应商"
                v_desc2          column-label "供应商名称"
                t1_lot           column-label "收货单号"
                t1_qty           column-label "收货数量"
                t1_date          column-label "收货日期"
                t1_amt           column-label "收货金额"
                t1_nbr           column-label "采购单号"
                t1_line          column-label "项次"
                v_qty_ord        column-label "订购量"
                t1_price         column-label "价格(RMB)"
            with frame x .
        end.
        else do:
            if first-of(t1_price) then do:
                disp 
                    t1_part          column-label "零件号"      
                    v_desc1          column-label "零件名称"    
                    t1_vend          column-label "供应商"      
                    v_desc2          column-label "供应商名称"  
                    t1_lot           column-label "收货单号"    
                    t1_qty           column-label "收货数量"    
                    t1_date          column-label "收货日期"    
                    t1_amt           column-label "收货金额"    
                    t1_nbr           column-label "采购单号"    
                    t1_line          column-label "项次"        
                    v_qty_ord        column-label "订购量"      
                    t1_price         column-label "价格(RMB)"        
                with frame x .
            end.
        end.
        
        if last-of(t1_part) then do:
            down 1 with frame x .
            disp 
                t1_part    
                "合计:    " @ v_desc1
                v_qty_rct   @ t1_qty 
                v_amt_rct   @ t1_amt 
            with frame x .
        end.

    end. /*for each temp1*/


end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}

