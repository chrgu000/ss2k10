/* SS - 100622.1 By: Kaine Zhang */

/* 暂估材料处理报表 */

{mfdtitle.i "100622.1"}

define var yr like glc_year.
define var per like glc_per.
define var vend like po_vend.
define var part like pt_part.
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var tt_recid as recid.
define var first-recid as recid.
define var sw_reset like mfc_logical. 
define var update-yn as logical. 
define var site like in_site init "10000".
define var tnbr as char.

define temp-table tt1
    field tt1_f1 like po_vend
    field tt1_f2 like pt_part
    field tt1_f3 like pt_desc1
    field tt1_f4 like ld_qty_oh
    field tt1_f5 like pt_price
    field tt1_f6 like pt_price
    field tt1_f7 as char format "x(4)"
    field tt1_f8 as int
    field tt1_f9 as int
    .

form
    yr colon 25
    per colon 25
    part colon 25
with frame a width 80 side-labels attr-space.

setFramelabels(frame a:handle).


form
    tt1_f1 label "供应商"
    tt1_f2 label "物料号"
    tt1_f4 label "数量"
    tt1_f7 label "期间"
    tt1_f5 label "期间价格"
    tt1_f6 label "本期价格"
with frame b down width 80.
    
    
{wbrp01.i}
mainloop:
repeat with frame a:
    
    update yr per part with frame a.
    
    find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
    if not avail glc_cal then do:
        message "错误: 期间不存在".
        next.
    end.
    if glc_user1 <> "" then do:
        message "错误: 挂账已经关闭".
        next.
    end.
    
    find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per no-lock no-error.
    if not avail xxzgp_det then do:
        message "错误: 暂估价格没有处理".
        next.
    end.
    
    {gpselout.i
        &printtype = "printer"
        &printwidth = 132
        &pagedflag = " "
        &stream = " "
        &appendtofile = " "
        &streamedoutputtoterminal = " "
        &withbatchoption = "yes"
        &displaystatementtype = 1
        &withcancelmessAge = "yes"
        &pagebottommargin = 6
        &withemail = "yes"
        &withwinprint = "yes"
        &definevariables = "yes"
    }
    
    empty temp-table tt1.

    for each xxld_det where xxld_domain = global_domain and not ( xxld_year = yr and xxld_per   = per )
        and (xxld_part = part or part = "")
        and xxld_type = "暂估" and xxld_zg_qty <> 0 no-lock:
        
        find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per
      and xxzgp_vend = xxld_vend and xxzgp_part = xxld_part and xxzgp_type = "正常" no-error.
     if not avail xxzgp_det then next.
    
        create tt1.
        assign tt1_f1 = xxld_vend
                     tt1_f2 = xxld_part
                     tt1_f4 = xxld_zg_qty
                     tt1_f5 = xxld_tax_price
                     tt1_f6 = xxzgp_price
                     tt1_f7 = substring(string(xxld_year),3,2) + string(xxld_per,"99")
                     tt1_f8 = xxld_year
                     tt1_f9 = xxld_per
                     .
    end.
    
    for each tt1:
        display
            tt1_f1
            tt1_f2
            tt1_f4
            tt1_f7
            tt1_f5
            tt1_f6
        with frame b.
        down with frame b.
    end.
    
    {mfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}


