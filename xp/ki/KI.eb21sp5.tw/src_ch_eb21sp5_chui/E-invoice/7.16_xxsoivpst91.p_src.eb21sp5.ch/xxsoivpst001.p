/* xxsoivpst001.p   每张发票的明细资料 create by roger 090707.1 */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090707.1 By: Roger Xiao */

/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i} 

define input parameter v_nbr  like sod_nbr .

{xxsoivpst91.i "shared"} 

define var vv_amt as decimal format "->>,>>>,>>9.99" .
define variable tax_date like so_tax_date.

form
    sod_nbr        label "销售订单"
    sod_line       label "项"
    sod_part       label "物料号"
    sod_um         label "UM"
    sod_qty_inv    label "发票数量"
    net_price      label "价格"
    vv_amt         label "金额"  
with frame b down width 80 
title  color normal "发票明细" .   /*发票明细*/

find first gl_ctrl where gl_domain = global_domain no-lock.
find first soc_ctrl where soc_domain = global_domain no-lock.

hide all no-pause .
clear frame b all no-pause .

for each so_mstr where so_domain = global_domain and so_nbr  = v_nbr ,
    each sod_det where sod_domain = global_domain and sod_nbr = so_nbr and sod_qty_inv <> 0 no-lock :
    
    vv_amt = 0 .
    net_price = sod_price.       
    tax_date = if so_tax_date <> ? then so_tax_date else so_ship_date.
    run get-price (input-output net_price , input sod_tax_in , input tax_date , input sod_taxc) .

    vv_amt =  net_price * sod_qty_inv.
            

    disp sod_nbr      
         sod_line     
         sod_part     
         sod_um       
         sod_qty_inv  
         net_price 
         vv_amt 
    with frame b .
    down 1 with frame b .

end. /*for each sod_det */
pause  .

clear frame b all no-pause .
hide frame b no-pause .




procedure get-price:
    define input-output parameter vv_price       like idh_price  .
    define input parameter vv_include_tax like idh_tax_in .
    define input parameter vv_tax_date    like ih_tax_date .
    define input parameter vv_tax_class   like idh_taxc  .

    find first gl_ctrl where gl_domain = global_domain no-lock no-error .
    if not avail gl_ctrl then do:
        vv_price = vv_price .
    end.
    else do:                       
        if (gl_can or gl_vat) and vv_include_tax then do:             
            find last vt_mstr 
                where vt_class =  vv_tax_class
                and vt_start <= vv_tax_date
                and vt_end   >= vv_tax_date
            no-lock no-error.
            if not available vt_mstr then
                find last vt_mstr where vt_class = vv_tax_class no-lock no-error.
            if available vt_mstr then do:
                vv_price  = vv_price  * 100 / (100 + vt_tax_pct).
            end.
        end.
    end.
end procedure . /*get-price:*/


