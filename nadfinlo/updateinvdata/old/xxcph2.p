/* cph_hist 中数量为
assign
         cph_tot_sale         = cph_tot_sale         + base_price
         cph_tot_cost         = cph_tot_cost         + tmp_cost
         cph_tot_qty          = cph_tot_qty          +
                                (sod_qty_inv * sod_um_conv)
         cph_qty[sa_bucket]   = cph_qty[sa_bucket]   +
                                (sod_qty_inv * sod_um_conv)
         cph_sales[sa_bucket] = cph_sales[sa_bucket] + base_price
         cph_cost[sa_bucket]  = cph_cost[sa_bucket]  + tmp_cost.
*/
/* idh 
  idh_qty_inv     = sod_qty_inv
   idh_price       = sod_price
    idh_std_cost    = sod_std_cost
 idh_um          = sod_um
      idh_um_conv     = sod_um_conv.
*/

/* 注意会计年度第一个月份是否为1 否则年，月划分需要重新计算，而且不好统计 */

define var v_cost like cph_tot_sale .
define var v_sale like cph_tot_sale .
define var v_qty like cph_tot_qty .
define var v_file as char format "x(30)" initial "/home/mfg/cph.txt"  .
define var v_effdate as date .
define var v_effdate1 as date .
define var v_month as int .
DEFINE VAR v_part LIKE pt_part .

define temp-table xx 
field	 xx_year   	like 	 cph_year   
field	 xx_cust   	like 	 cph_cust   
field	xx_ship   	like 	cph_ship   
field	xx_part   	like 	cph_part   
field	xx_type   	like 	cph_type   
field	xx_pl     	like 	cph_pl     
field	xx_site   	like 	cph_site   
field   xx_old_qty like cph_qty
field   xx_new_qty like cph_qty
/*
field   xx_old_sales like cph_sales
field   xx_new_sales like cph_sales
field   xx_old_cost like cph_cost
field   xx_new_cost like cph_cost
field   xx_old_tot_qty like cph_tot_qty
field   xx_new_tot_qty like cph_tot_qty
field   xx_old_tot_sale like cph_tot_sale
field   xx_new_tot_sale like cph_tot_sale
field   xx_old_tot_cost like cph_tot_cost
field   xx_new_tot_cost like cph_tot_cost
*/
.

update v_effdate label "生效日期" colon 20  v_effdate1 label "至" colon 45 skip
       v_part LABEL "零件" COLON 20 SKIP 
     v_file  label "输出文件"  colon 20 with frame a side-labels .

output to value(v_file) .
PUT UNFORMATTED "客户;销往;零件;类型;产品线;地点;发票;订单;项次;生效日期;发票日期;转换数量;数量;单位" SKIP .
for each  ar_mstr where ar_effdate >= v_effdate and ar_effdate <= v_effdate1 no-lock,
 each ih_hist use-index ih_inv_nbr where  ih_inv_nbr  = ar_nbr no-lock,
 each idh_hist where  idh_nbr = ih_nbr
   and idh_inv_nbr = ar_nbr
   AND ( idh_part = v_part OR v_part = "" ) no-lock 
   break by ih_cust by ih_ship
   by idh_prodline by idh_part
   by idh_type by idh_site  by year(ar_effdate) by month(ar_effdate)  :

	accumulate idh_qty_inv * idh_um_conv (total by month(ar_effdate)) .
  /*
    EXPORT DELIMITER ";" ih_cust ih_ship idh_part idh_type idh_prodline idh_site idh_inv_nbr idh_nbr idh_line  ar_effdate ih_inv_date idh_qty_inv * idh_um_conv idh_qty_inv  idh_um_conv .
*/
	if last-of(month(ar_effdate)) then do:
		find first cph_hist
			 where cph_year   = year(ar_effdate)
			 and   cph_cust   = ih_cust
			 and   cph_ship   = ih_ship
			 and   cph_part   = idh_part
			 and   cph_type   = idh_type
			 and   cph_pl     = idh_prodline
			 and   cph_site   = idh_site
			 no-lock
			 no-error. 
                if available cph_hist then do:
			 v_month = month(ar_effdate) .
                 
			 if  cph_qty[v_month] <> accumulate total by month(ar_effdate)  idh_qty_inv * idh_um_conv then do:
			   
		                 find first xx
				 where xx_year   = year(ar_effdate)
				 and   xx_cust   = ih_cust
				 and   xx_ship   = ih_ship
				 and   xx_part   = idh_part
				 and   xx_type   = idh_type
				 and   xx_pl     = idh_prodline
				 and   xx_site   = idh_site
				 no-lock
				 no-error. 
				if not available xx then do:
				create xx .
				assign
				  xx_year   = year(ar_effdate)
				  xx_cust   = ih_cust
				  xx_ship   = ih_ship
				  xx_part   = idh_part
				  xx_type   = idh_type
				  xx_pl     = idh_prodline
				  xx_site   = idh_site
				  .

				end .
				assign 
				 xx_old_qty[v_month]   =  cph_qty[v_month]
				 xx_new_qty[v_month] = accumulate total by month(ar_effdate)  idh_qty_inv * idh_um_conv
				
				/*
				 xx_old_sales[v_month]   =  cph_sales[v_month]
				 xx_new_sales[v_month] = ( accumulate total by month(ar_effdate)  idh_qty_inv * idh_um_conv ) * idh_price
                                 
				 xx_old_cost[v_month]   =  cph_cost[v_month]
				 xx_new_cost[v_month] = ( accumulate total by month(ar_effdate)  idh_qty_inv * idh_um_conv ) * idh_std_cost
				 */


				 
				 .

		     end . 

		end .
    	 
		
	end .
end .




put unformatted "year;cust;ship;part;type;pl;site;oldqty1;oldqty2;oldqty3;oldqty4;oldqty5;oldqty6;
oldqty7;oldqty8;oldqty9;oldqty10;oldqty11;oldqty12;newqty1;newqty2;newqty3;newqty4;newqty5;newqty6;
newqty7;newqty8;newqty9;newqty10;newqty11;newqty12" skip .
for each xx :
export delimiter ";"  xx .
end .
output close .





