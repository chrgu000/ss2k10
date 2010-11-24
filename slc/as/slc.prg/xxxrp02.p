/*  ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100412.1 By: Kaine Zhang */
/* SS - 100720.1 By: Kaine Zhang */


/* SS - 100720.1 - RNB
[100720.1]
不含税金额 = 挂账金额 / (1 + 税率).
[100720.1]
SS - 100720.1 - RNE */

/* *ss_20100421* 挂账金额汇总表 */

{mfdtitle.i "100412.1"}

define variable iYear as integer format ">>>9" label "年份" no-undo.
define variable iMonth as integer format ">9" label "期间" no-undo.
define variable sVendorA as character label "供应商" no-undo.
define variable sVendorB as character label "至" no-undo.
define variable decAmount as decimal format "->>>>>>>9.9<<<" no-undo.
define variable iTaxRate as integer no-undo.


form
    iYear   colon 15
    iMonth  colon 15
    sVendorA    colon 15
    sVendorB    colon 45
with frame a side-labels width 80.
setframelabels(frame a:handle).
    
form
    xxgz_vend
    ad_name
    xxgz_sort
    xxgz_amt    label "挂账金额"
    decAmount   label "不含税金额"
with frame b down width 132.
setframelabels(frame b:handle).
    


{wbrp01.i}
repeat on endkey undo, leave:
    {xxxxrpinput.i}
	
    /* output destination selection */
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



    for each xxgz_mstr
        no-lock
        where xxgz_domain = global_domain
            and xxgz_year = iYear
            and xxgz_per = iMonth
            and xxgz_vend >= sVendorA
            and xxgz_vend <= sVendorB
        use-index xxgz_vend
        break
        by xxgz_vend
    :
        accumulate xxgz_amt (total by xxgz_vend).
        if last-of(xxgz_vend) then do with frame b:
            display
                xxgz_vend
                .
            find first ad_mstr no-lock
                where ad_domain = global_domain
                    and ad_addr = xxgz_vend
                no-error.
            if available(ad_mstr) then do:
                display ad_name.
            end.
            display
                xxgz_sort
                (accum total by xxgz_vend xxgz_amt) @ xxgz_amt
                .
            if available(ad_mstr) then do:
                iTaxRate = int(ad_taxc) no-error.
                if not(error-status:error) then
                    /* SS - 100720.1 - B
                    display (accum total by xxgz_vend xxgz_amt) * (1 + iTaxRate / 100) @ decAmount.
                    SS - 100720.1 - E */
                    /* SS - 100720.1 - B */
                    display (accum total by xxgz_vend xxgz_amt) / (1 + iTaxRate / 100) @ decAmount.
                    /* SS - 100720.1 - E */
            end.
            down.
        end.
    end.
    

    {mfreset.i}
	{mfgrptrm.i}
end.
{wbrp04.i &frame-spec = a}










