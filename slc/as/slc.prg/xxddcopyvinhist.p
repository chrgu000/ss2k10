/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
 {mfdtitle.i "SS"}
/*����Ƿ�������
	checknumber = 0  ���߼�������
	checknumber = 1  ���߼�������
	checknumber = 2  ��װ��������
	checknumber = 3  ���(��Ʒ����Ʒ)��������
	checknumber = 4  �������(���Ʒ,����鶯��)��������
	*/
DEFINE input  parameter vin like xxsovd_id .		/*���ú��VIN����ǰ��һ��*/
DEFINE input  parameter wolot like wo_Lot .
DEFINE VARIABLE barcode_userid as char .
DEFINE VARIABLE v_today as date .
DEFINE VARIABLE v_time as inte .
DEFINE VARIABLE v_userid as char .
pause 0 .
{gprun.i ""xxddgetbarcodeuser.p"" 
	"(output barcode_userid)"} 
pause 0 .
find first xxvind_det where xxvind_domain = global_domain 
		and xxvind_id = vin and xxvind_wolot = wolot no-lock no-error.
if avail xxvind_det then do :
	.
end .
else do:
	
	for each xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = vin no-lock :
		find first xxvind_det where xxvind_domain = global_domain and xxvind_id = vin no-error.
		if avail xxvind_det then
		assign v_today = xxvind_print_vin_date
		       v_time  = xxvind_print_vin_time
		       v_userid = xxvind_print_Userid .
		else assign v_today = today
			    v_time  = time
			    v_userid = barcode_userid .
		find first wo_mstr where wo_domain = global_domain and wo_lot = xxsovd_wolot no-lock no-error.
		create  xxvind_det .
		assign 
			xxvind_domain	= global_domain
			xxvind_wonbr	= xxsovd_wonbr
			xxvind_wolot	= xxsovd_wolot
			xxvind_nbr	= xxsovd_nbr
			xxvind_line	= xxsovd_line
			xxvind_part	= xxsovd_part
			xxvind_prod_line = if avail wo_mstr then wo_vend else ""
			xxvind_id	= xxsovd_id
			xxvind_lot	= xxsovd_id1
			xxvind_print_vin_date	= v_today
			xxvind_print_vin_time	= v_time
			xxvind_print_Userid	= v_userid 

			.
		find first xxvin_mstr where xxvin_domain	= global_domain
					 and xxvin_wolot	= xxsovd_wolot
					 and xxvin_part	= xxsovd_part 
					 no-lock no-error.
		if not avail xxvin_mstr then do:
		create  xxvin_mstr .
		assign  
			xxvin_domain	= global_domain 
			xxvin_wonbr	= xxsovd_wonbr  
			xxvin_wolot	= xxsovd_wolot  
			xxvin_nbr	= xxsovd_nbr    
			xxvin_line	= xxsovd_line   
			xxvin_part	= xxsovd_part 
			xxvin_prod_line = if avail wo_mstr then wo_vend else ""
			
			. 
		end.
	end.
end.
