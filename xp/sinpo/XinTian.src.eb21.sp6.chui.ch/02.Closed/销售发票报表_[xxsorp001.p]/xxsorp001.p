/* xxsorp001.p - 销售发票报表                                               */
/* REVISION: 100727.1      Created On: 20100727 ,  BY: Roger Xiao           */
/*----rev history-----------------------------------------------------------*/
/* SS - 100729.1 By: Kaine Zhang */


/* SS - 100729.1 - RNB
[100729.1]
获取金税系统的发票号码.
[100729.1]
SS - 100729.1 - RNE */

{mfdtitle.i "100729.1"}



define var date  as date .
define var date1 as date .
define var inv   like ih_inv_nbr.
define var inv1  like ih_inv_nbr.
define var nbr   like ih_nbr.
define var nbr1  like ih_nbr.
define var cust  like ih_cust.
define var cust1 like ih_cust.
define var bill  like so_bill.
define var bill1 like so_bill.
define var spsn  like sp_addr.
define var spsn1 like spsn.
define var part  like pt_part.
define var part1 like pt_part.

define var v_all as integer format "9" initial 1 .

define var v_custname  like ad_name .
define var v_billname  like ad_name .
define var v_billname2 like cm_sort .
define var v_compname  like cm_sort .
define var v_spsnname  like ad_name .
define var v_desc      as char format "x(48)".
define var v_um        like pt_um .
define var v_cmmt      as char format "x(80)".


define temp-table temp1 
    field t1_so   like so_nbr
    field t1_inv  like so_inv_nbr
    field t1_Jinv like so_inv_nbr /*xjinv_jinren_inv*/
    field t1_date like so_ship_date
    field t1_cust like so_cust
    field t1_bill like so_bill
    field t1_comp like so__chr01
    field t1_spsn like sp_addr
    field t1_curr like so_curr
    field t1_line like sod_line
    field t1_part like sod_part
    field t1_qty  like sod_qty_inv
    field t1_price like sod_price 
    field t1_amt   like tr_gl_amt 
    field t1_cmmt  like idh_cmtindx.

form
    SKIP(.2)
   date           colon 15 label "发票日期"
   date1          colon 49 label {t001.i} 
   nbr            colon 15
   nbr1           colon 49 label {t001.i} 
   inv            colon 15
   inv1           colon 49 label {t001.i} 
   cust           colon 15
   cust1          colon 49 label {t001.i} 
   bill           colon 15
   bill1          colon 49 label {t001.i} 
   part           colon 15
   part1          colon 49 label {t001.i} 
   spsn           colon 15
   spsn1          colon 49 label {t001.i}
   
   v_all          colon 30 label "1-已过账/2-未过账/3-All"

skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    for each temp1: delete temp1 . end.

    if nbr1     = hi_char  then nbr1  = "" .    
    if inv1     = hi_char  then inv1  = "" .    
    if cust1    = hi_char  then cust1 = "" .    
    if bill1    = hi_char  then bill1 = "" .    
    if spsn1    = hi_char  then spsn1 = "" .    
    if part1    = hi_char  then part1 = "" .    
    if date     = low_date then date  = ?  .
    if date1    = hi_date  then date1 = ?  .

    update 
        date       
        date1      
        nbr        
        nbr1       
        inv        
        inv1       
        cust       
        cust1   
        bill       
        bill1 
        part       
        part1      
        spsn        
        spsn1      
           
        v_all      
    with frame a.

    if v_all < 1 or v_all > 3 or v_all = ? then do:
        message "错误:选择范围仅限1,2,3 请重新输入".
        next-prompt v_all .
        undo,retry .
    end.

    if nbr1     = ""  then nbr1  = hi_char .    
    if inv1     = ""  then inv1  = hi_char .    
    if cust1    = ""  then cust1 = hi_char .    
    if bill1    = ""  then bill1 = hi_char .    
    if spsn1    = ""  then spsn1 = hi_char .    
    if part1    = ""  then part1 = hi_char .    
    if date     = ?   then date  = low_date.
    if date1    = ?   then date1 = hi_date .
    

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


if v_all = 2 or v_all = 3 then do:
    for each so_mstr
            where so_mstr.so_domain = global_domain
            and (so_nbr >=   nbr and so_nbr <= nbr1)
            and (so_to_inv = yes)
            and (so_ship_date >= date and so_ship_date <= date1)
            and (so_cust >= cust and so_cust <= cust1)
            and (so_bill >= bill and so_bill <= bill1)
            and (so_inv_nbr >= inv and so_inv_nbr <= inv1)
            and (so_slspsn[1] >= spsn) and (so_slspsn[1] <= spsn1) 
        no-lock,
        each sod_det 
            where sod_domain = global_domain 
            and sod_nbr = so_nbr 
            and sod_part >= part and sod_part <= part1 
            and sod_qty_inv <> 0 
        no-lock: 

        find first temp1 
            where t1_so   = so_nbr
            and   t1_line = sod_line 
            and   t1_part = sod_part 
        no-error .
        if not avail temp1 then do:
            create temp1 .
            assign t1_so    = so_nbr 
                   t1_inv   = so_inv_nbr 
                   t1_date  = so_ship_date
                   t1_cust  = so_cust
                   t1_bill  = so_bill
                   t1_comp  = so__chr01
                   t1_spsn  = so_slspsn[1]
                   t1_curr  = so_curr
                   t1_line  = sod_line  
                   t1_part  = sod_part
                   t1_qty   = sod_qty_inv 
                   t1_price = sod_price
                   t1_amt   = sod_price * sod_qty_inv
                   t1_cmmt  = sod_cmtindx
                   .
        end.

    end. /*for each so_mstr*/
end. /*if v_all = 2*/


if v_all = 1 or v_all = 3  then do:
    for each ih_hist
            where ih_domain = global_domain
            and (ih_inv_nbr >= inv and ih_inv_nbr <= inv1)
            and (ih_nbr >=   nbr   and ih_nbr <= nbr1)
            and (ih_inv_date >= date and ih_inv_date <= date1)
            and (ih_cust >= cust and ih_cust <= cust1)
            and (ih_bill >= bill and ih_bill <= bill1)
            and (ih_slspsn[1] >= spsn) and (ih_slspsn[1] <= spsn1) 
        no-lock,
        each idh_hist 
            where idh_domain = global_domain 
            and idh_inv_nbr = ih_inv_nbr 
            and idh_nbr = ih_nbr 
            and idh_part >= part and idh_part <= part1 
            and idh_qty_inv <> 0 
        no-lock: 

        find first temp1 
            where t1_so   = idh_nbr
            and   t1_line = idh_line 
            and   t1_part = idh_part 
        no-error .
        if not avail temp1 then do:
            /* SS - 100729.1 - B
            find first xjinv_mstr where xjinv_domain = global_domain and xjinv_jinren_inv = ih_inv_nbr no-lock no-error .
            SS - 100729.1 - E */
            /* SS - 100729.1 - B */
            find first xjinv_mstr where xjinv_domain = global_domain and xjinv_inv_nbr = ih_inv_nbr no-lock no-error .
            /* SS - 100729.1 - E */

            create temp1 .
            assign t1_so    = ih_nbr 
                   t1_inv   = ih_inv_nbr 
                   t1_Jinv  = if avail xjinv_mstr then xjinv_jinren_inv else "" 
                   t1_date  = ih_inv_date
                   t1_cust  = ih_cust
                   t1_bill  = ih_bill
                   t1_comp  = ih__chr01
                   t1_spsn  = ih_slspsn[1]
                   t1_curr  = ih_curr
                   t1_line  = idh_line  
                   t1_part  = idh_part
                   t1_qty   = idh_qty_inv 
                   t1_price = idh_price
                   t1_amt   = idh_price * idh_qty_inv
                   t1_cmmt  = idh_cmtindx
                   .
        end.

    end. /*for each so_mstr*/
end. /*if v_all = 1*/



put unformatted
    "ExcelFile;" 
    + "xxsorp001" 
    skip
    "SaveFile;"
    + "xxsorp001-" 
    + string(year(today),"9999") + string(month(today),"99") + string(day(today),"99")
    + replace(string(time, "HH:MM:SS"), ":", "") 
    skip
    "BeginRow;2"                
    skip.

put unformatted 
    "QAD发票号;金壬发票号;销售订单;发运/发票日期;客户代码;客户名称;票据开往;票据开往名称;票据开往全称;分公司;分公司名称;推销员;推销员名称;订单项;物料号;物料说明;计量单位;发运/发票数量;含税单价;含税金额;币别;备注" 
    skip.


for each temp1 break by t1_inv by t1_so by t1_line :
    find first ad_mstr where ad_domain = global_domain and ad_type = "customer" and ad_addr = t1_cust no-lock no-error.
    v_custname = if avail ad_mstr then trim(ad_name) else "" .
    
    find first ad_mstr where ad_domain = global_domain and ad_type = "customer" and ad_addr = t1_bill no-lock no-error.
    v_billname = if avail ad_mstr then trim(ad_name) else "" .

    find first cm_mstr where cm_domain = global_domain and cm_addr = t1_bill no-lock no-error.
    v_billname2 = if avail cm_mstr then trim(cm_sort) else "" .

    find first ad_mstr where ad_domain = global_domain and ad_type = "slsprsn" and ad_addr = t1_spsn no-lock no-error.
    v_spsnname = if avail ad_mstr then trim(ad_name) else "" .
    
    find first code_mstr where code_domain = global_domain and code_fldname = "" and code_value = t1_comp no-lock no-error.
    v_compname = if avail code_mstr then trim(code_cmmt) else "" .


    find first pt_mstr where pt_domain = global_domain and pt_part = t1_part no-lock no-error .
    v_desc = if avail pt_mstr then pt_desc1 + pt_desc2  else "" .
    v_um   = if avail pt_mstr then pt_um   else "" .
    find first code_mstr where code_domain = global_domain and code_fldname = "pt_um" and code_value = v_um no-lock no-error.
    v_um = if avail code_mstr then code_cmmt else "" .

    find first cmt_det where cmt_domain = global_domain and cmt_indx = t1_cmmt no-lock no-error.
    v_cmmt = if available cmt_det then cmt_cmmt[1] + cmt_cmmt[2] + cmt_cmmt[3] + cmt_cmmt[4] + cmt_cmmt[5] else  "" .
       


    export delimiter ";"
        "'" + t1_inv   
        "'" + t1_Jinv
        "'" + t1_so    
        string(year(t1_date),"9999") + "/" + string(month(t1_date),"99") + "/" + string(day(t1_date),"99")   
        t1_cust  
        v_custname
        t1_bill  
        v_billname
        v_billname2
        t1_comp
        v_compname 
        t1_spsn  
        v_spsnname
        t1_line  
        t1_part  
        v_desc
        v_um
        t1_qty   
        t1_price 
        t1_amt 
        t1_curr  
        v_cmmt
        .
 
end. /*for each temp1*/

end. /* mainloop: */
{mfreset.i}  
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
