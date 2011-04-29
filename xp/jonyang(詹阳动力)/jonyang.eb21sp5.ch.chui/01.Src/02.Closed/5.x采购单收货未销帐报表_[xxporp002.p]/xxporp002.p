/* xxporp002.p - 采购单已收货未销帐报表                                     */
/* REVISION: 100715.1      Created On: 20100715 ,  BY: Roger Xiao           */
/*----rev history-----------------------------------------------------------*/



{mfdtitle.i "100715.1"}

{xxporp002.i "new"}

define var date      as date .
define var date1     as date .
define var vend      like po_vend.
define var vend1     like po_vend.
define var part      like pt_part .
define var part1     like pt_part .
define var nbr       as char .
define var nbr1      as char .
define var buyer     as char .
define var buyer1    as char .

define var effdate    like prh_rcp_date format "99/99/99" no-undo.

define var vv_dt as integer extent 7.
vv_dt[1] = 30.
vv_dt[2] = 60.
vv_dt[3] = 90.
vv_dt[4] = 120.
vv_dt[5] = 150.
vv_dt[6] = 180.
vv_dt[7] = 360.

define var v_vdname  as char format "x(24)" .
define var v_desc1   as char format "x(24)" .
define var v_desc2   as char format "x(24)" .

define var v_index as char .

define temp-table temp2 
    field t2_vend  like po_vend 
    field t2_buyer like po_buyer
    field t2_nbr   like tr_nbr 
    field t2_line  like tr_line
    field t2_part  like tr_part 
    field t2_price like tr_price 
    field t2_qty   like tr_qty_loc
    field t2_amt   like tr_qty_loc extent 8
    field t2_amt_tot like tr_qty_loc
    field t2_prepaid like po_prepaid 
    .


form
    SKIP(.2)
    vend                colon 18 label "供应商"
    vend1               colon 53 label "至"
    nbr                 colon 18 label "采购单"
    nbr1                colon 53 label "至"
    date                colon 18 label "收货日期"
    date1               colon 53 label "至" 
    buyer                colon 18 label "物料号"
    buyer1               colon 53 label "至"
        
skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    for each temp1 : delete temp1 . end.
    for each temp2 : delete temp2 . end.

    effdate = today .

    if date     = low_date then date  = ? .
    if date1    = hi_date  then date1 = ? .
    if vend1    = hi_char  then vend1 = "" .
    if buyer1   = hi_char  then buyer1 = "" .
    if nbr1     = hi_char  then nbr1  = "" .
    
    update 
        vend     
        vend1    
        nbr  
        nbr1 
        date     
        date1    
        buyer     
        buyer1    
    with frame a.

    if      vend > ""  or vend1 > ""  then  v_index = "a" .
    else if nbr > ""   or nbr1  > ""  then  v_index = "b" .
    else if buyer > "" or buyer1 > "" then  v_index = "c" .


    if date     = ?  then date      =  low_date.
    if date1    = ?  then date1     =  hi_date .
    if vend1    = "" then vend1     =  hi_char .
    if buyer1   = "" then buyer1    =  hi_char .
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

    /*子程式按日期,取得收货未做凭证数,存放在temp1*/
if v_index = "a" then do: /*按prh_vend*/
    {gprun.i ""xxporp002a.p"" 
             "(input date ,
               input date1,
               input vend,
               input vend1,
               input nbr,
               input nbr1,
               input buyer,
               input buyer1
     )" }
end.
if v_index = "b" then do: /*按prh_nbr*/
    {gprun.i ""xxporp002b.p"" 
             "(input date ,
               input date1,
               input vend,
               input vend1,
               input nbr,
               input nbr1,
               input buyer,
               input buyer1
     )" }
end.
if v_index = "c" then do:  /*按prh_buyer*/
    {gprun.i ""xxporp002c.p"" 
             "(input date ,
               input date1,
               input vend,
               input vend1,
               input nbr,
               input nbr1,
               input buyer,
               input buyer1
     )" }
end.


for each temp1 
    break by t1_nbr by t1_line by t1_date :

    find first temp2
        where t2_nbr  = t1_nbr 
        and   t2_line = t1_line 
    no-error .
    if not avail temp2 then do:
        create temp2 .
        assign t2_nbr  = t1_nbr 
               t2_line = t1_line
               t2_part = t1_part 
               t2_price = t1_price 
               .
        find first po_mstr where po_domain = global_domain and po_nbr = t1_nbr no-lock no-error.
        t2_vend  = if avail po_mstr then po_vend  else "" .
        t2_buyer = if avail po_mstr then po_buyer else "" .
        t2_prepaid = if avail po_mstr then po_prepaid else 0 .
    end.
    t2_qty     = t2_qty + t1_qty .
    t2_amt_tot = t2_amt_tot + t1_amt .
    
    if      effdate - t1_date <= vv_dt[1]  then assign t2_amt[1] = t2_amt[1] + t1_amt.
    else if effdate - t1_date <= vv_dt[2]  then assign t2_amt[2] = t2_amt[2] + t1_amt.
    else if effdate - t1_date <= vv_dt[3]  then assign t2_amt[3] = t2_amt[3] + t1_amt.
    else if effdate - t1_date <= vv_dt[4]  then assign t2_amt[4] = t2_amt[4] + t1_amt.
    else if effdate - t1_date <= vv_dt[5]  then assign t2_amt[5] = t2_amt[5] + t1_amt.
    else if effdate - t1_date <= vv_dt[6]  then assign t2_amt[6] = t2_amt[6] + t1_amt.
    else if effdate - t1_date <= vv_dt[7]  then assign t2_amt[7] = t2_amt[7] + t1_amt.
    else                                        assign t2_amt[8] = t2_amt[8] + t1_amt.

end. /*for each temp1*/


{mfphead.i}
for each temp2 
    where t2_amt_tot <> 0 
    break by t2_buyer by t2_vend by t2_nbr by t2_line 
    with frame x width 330:

    find first ad_mstr where ad_domain = global_domain and ad_addr = t2_vend no-lock no-error .
    v_vdname = if avail ad_mstr then ad_name else "" . 

    find first pt_mstr where pt_domain = global_domain and pt_part = t2_part no-lock no-error .
    v_desc1 = if avail pt_mstr then pt_desc1 else "" . 
    v_desc2 = if avail pt_mstr then pt_desc2 else "" . 

    disp 
        t2_buyer      column-label "采购员"
        t2_vend       column-label "供应商"
        v_vdname      column-label "供应商名称"
        t2_nbr        column-label "采购单"
        t2_line       column-label "项次"
        t2_part       column-label "零件号"
        v_desc1       column-label "说明1" 
        v_desc2       column-label "说明2" 
        t2_qty        column-label "未结数量" 
        t2_price      column-label "采购单价" 
        t2_amt[1]     column-label "金额30内" 
        t2_amt[2]     column-label "金额60内" 
        t2_amt[3]     column-label "金额90内" 
        t2_amt[4]     column-label "金额120内" 
        t2_amt[5]     column-label "金额150内" 
        t2_amt[6]     column-label "金额180内" 
        t2_amt[7]     column-label "金额360内" 
        t2_amt[8]     column-label "金额360外" 
        t2_amt_tot    column-label "合计金额"  
        t2_prepaid    column-label "预付账款"  
    with frame x .

    accumulate t2_amt[1]   (total).
    accumulate t2_amt[2]   (total).
    accumulate t2_amt[3]   (total).
    accumulate t2_amt[4]   (total).
    accumulate t2_amt[5]   (total).
    accumulate t2_amt[6]   (total).
    accumulate t2_amt[7]   (total).
    accumulate t2_amt[8]   (total).
    accumulate t2_amt_tot  (total).
    accumulate t2_qty      (total).
    
    if last(t2_buyer) then do:
            down 1 with frame x .
            disp 
                "合计: "               @ t2_vend 
                accum total t2_qty     @ t2_qty
                accum total t2_amt[1]  @ t2_amt[1]
                accum total t2_amt[2]  @ t2_amt[2]
                accum total t2_amt[3]  @ t2_amt[3]
                accum total t2_amt[4]  @ t2_amt[4]
                accum total t2_amt[5]  @ t2_amt[5]
                accum total t2_amt[6]  @ t2_amt[6]
                accum total t2_amt[7]  @ t2_amt[7]
                accum total t2_amt[8]  @ t2_amt[8]
                accum total t2_amt_tot @ t2_amt_tot
            with frame x.
    end.

end. /*for each temp2*/


end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}

