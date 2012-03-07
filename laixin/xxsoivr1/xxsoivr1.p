/* rev: eb21sp3 */
/* By: Neil Gao Date: 20070307 ECO: * ss 20070307.1 * */
/* By: Neil Gao Date: 20070620 ECO: * ss 20070620 * */
/* By: Neil Gao Date: 20070703 ECO: * ss 20070703 * */
/* By: Neil Gao Date: 20070709 ECO: * ss 20070709 * */

/* 20070620 - b
	显示格式位数不够
   20070620 - e */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{xxsoivrp.i "new"}
/* define */
define var cust    like so_cust.
define var cust1   like so_cust.
define var ship    like so_ship.
define var ship1   like so_ship.
define var nbr     like so_nbr.
define var nbr1    like so_nbr.
define var part    like pt_part.
define var part1   like pt_part.
define var inv     like ih_inv_nbr.
define var inv1    like ih_inv_nbr.
define var inv_date  like ih_inv_date.
define var inv_date1 like ih_inv_date.

/* ss 20070709 - b */
define variable cust_part like cp_cust_part.
/* ss 20070709 - e */

/* form */
form
  cust      colon 15
  cust1     colon 47
  inv       colon 15
  inv1      colon 47
  nbr       colon 15
  nbr1      colon 47
  part      colon 15
  part1     colon 47
  inv_date  colon 15
  inv_date1 colon 47
  skip(1)
 with frame a width 80 side-labels.

 /* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


repeat:

/* if var = hi then var = "" */

   if cust1 = hi_char then cust1 = "".
   if inv1  = hi_char then inv1  = "".
   if nbr1  = hi_char then nbr1  = "".
   if part1 = hi_char then part1 = "".
   if inv_date1 = hi_date then inv_date1 = ?.
   if inv_date  = low_date then inv_date = ?.
   
   if c-application-mode <> 'web' then
   update cust cust1 inv inv1 nbr nbr1 part part1 inv_date inv_date1
   with frame a.


   if (c-application-mode <> 'web') then 
   do:
   	
      /*if var = "" then var = hi_char. */
      if cust1 = "" then cust1 = hi_char.
      if inv1  = "" then inv1  = hi_char.
      if nbr1  = "" then nbr1  = hi_char.
      if part1 = "" then part1 = hi_char.
      if inv_date1 = ? then inv_date1 = hi_date.
      if inv_date  = ? then inv_date  = low_date.

   end.

   /* OUTPUT DESTINATION SELECTION */
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


   PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxsoivr1" SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   for each xxrqm_mstr where xxrqm_domain = global_domain and
       xxrqm_inv_nbr >= inv and xxrqm_inv_nbr <= inv1 and
       xxrqm_cust  >= cust  and xxrqm_cust <= cust1 and xxrqm_invoiced
       no-lock,
       each ih_hist where ih_domain = global_domain and 
       ih_inv_nbr = xxrqm_inv_nbr and 
       ih_cust >= xxrqm_cust and
       ih_nbr >= nbr  and ih_nbr     <= nbr1  and 
       ih_inv_date >= inv_date and inv_date <= inv_date1 
       no-lock , 
       each idh_hist where ih_domain = global_domain and 
       idh_nbr = ih_nbr and idh_inv_nbr = ih_inv_nbr and
       idh_part >= part and idh_part <= part1
       no-lock,      
       each pt_mstr where pt_domain = global_domain and 
       pt_part = idh_part 
       no-lock,
       each ad_mstr where ad_domain = global_domain and 
       ad_addr = ih_cust no-lock:

       find first si_mstr where si_domain = global_domain and si_site = ih_site  no-lock no-error.
       if avail si_mstr then 
       find first sct_det where sct_domain = global_domain and
          sct_site = ih_site and sct_part = idh_part and
          sct_sim = si_gl_set no-lock no-error.

    FOR EACH tta6soivrp0904:
        DELETE tta6soivrp0904.
    END.

    {gprun.i ""xxsoivrp09.p"" "(
       INPUT '',
       INPUT '',
       INPUT ?,
       INPUT ?,
       INPUT ?,
       INPUT ?,
       INPUT ih_inv_nbr,
       INPUT ih_inv_nbr,
       INPUT ih_nbr,
       INPUT ih_nbr,
       INPUT '',
       INPUT '',
       INPUT '' ,
       INPUT '' ,
       INPUT '' ,
       INPUT '' ,
       INPUT '' ,
       INPUT '' ,
       INPUT ''
    )"}
    

/*    FOR EACH tta6soivrp0904:
        disp tta6soivrp0904.
    END.
*/
/*  "申请号"	"发票号"	"发票日期"	"订单号"	"客户编号"	"客户名称"	"币种"	汇率	
    "品号"	品名	规格	"单位"	"单价"	"发票数量"	"销售成本"	
    "原币税前金额"	"原币税额"	"本币税前金额"	"本币税额"	"原币价税合计"	"本币价税合计" "so line"
    "客户参考号"
 */
    for first tta6soivrp0904 no-lock where tta6soivrp0904_inv_nbr = ih_inv_nbr and 
      tta6soivrp0904_nbr = ih_nbr and tta6soivrp0904_line = idh_line :
      if tta6soivrp0904_ext_price = 0 and tta6soivrp0904_ext_tax = 0 and
         tta6soivrp0904_ext_tax = 0 and idh_qty_inv = 0 then next. 
         

/* ss 20070709 - b */
      cust_part = "".
			for each cp_mstr no-lock where cp_domain = global_domain and cp_cust = ih_cust and
				 	cp_part = pt_part by cp_cust_eco:
			 		cust_part = cp_cust_part.
			end.
/* ss 20070709 - e */
        
      put UNFORMATTED xxrqm_nbr ";" ih_inv_nbr ";" ih_inv_date ";"
           ih_nbr ";"  ih_cust ";" ad_name ";" 
           ih_curr ";" ih_ex_rate2 / ih_ex_rate ";"
           idh_part ";"  pt_desc1 ";" cust_part ";" idh_um ";" idh_price ";" idh_qty_inv ";" .
      if avail sct_det then  put unformat sct_cst_tot * idh_qty_inv ";" .
      else put ";".
      if idh_tax_in then 
         put UNFORMATTED tta6soivrp0904_ext_price - tta6soivrp0904_ext_tax ";"
             tta6soivrp0904_ext_tax ";"
             tta6soivrp0904_base_price - tta6soivrp0904_base_tax ";"
             tta6soivrp0904_base_tax ";" 
             tta6soivrp0904_ext_price ";" 
             tta6soivrp0904_base_price.
      else put UNFORMATTED tta6soivrp0904_ext_price ";"
             tta6soivrp0904_ext_tax ";"
             tta6soivrp0904_base_price ";"
             tta6soivrp0904_base_tax ";"
             tta6soivrp0904_ext_price + tta6soivrp0904_ext_tax ";" 
             tta6soivrp0904_base_price + tta6soivrp0904_base_tax .

      put unformat ";"  idh_line  skip.
      
    end. /* for first */   	
   end.      

   {xxmfrtrail.i}

end. /* repeat */
