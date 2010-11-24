/******************************************************************************/
/*name:散件VIN查询                                                            */
/*designed by Billy 2009-06-03                                                */
/******************************************************************************/

{mfdtitle.i "billy"}

define variable packno1 like xxvind_ZhuangXiang_NBR.
define variable packno2 like xxvind_ZhuangXiang_NBR.
define variable sonbr1 like xxvind_nbr.
define variable sonbr2 like xxvind_nbr.
define variable soline1 like xxvind_line.
define variable soline2 like xxvind_line.
define variable freightno like xxvind_chr01 format "x(10)".
define variable packlistno like xxvind_ZhuangXiang_NBR.
define variable sono like xxvind_nbr.
define variable soline like xxvind_line.
define variable ptpart like xxvind_part.
define variable oldname like pt_desc1.
define variable packqty as int init 0.
define variable vin like xxvind_id.
define variable yn1 as logical.

form
	sono           column-label "散件订单号"
	ptpart         column-label "散件成品编码"
	oldname        column-label "老车型"
	vin            column-label "VIN号"
with frame b width 200 down attr-space.

form
 sonbr1  colon 18 label "散件订单号"
 sonbr2  colon 49 label "至" skip
WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.

repeat:
	if sonbr2 = hi_char then sonbr1 = "".
  
		update
			sonbr1
			sonbr2
		with frame a.
			
			if sonbr2 = "" then sonbr2 = hi_char.
			
	{mfselprt.i "printer" 132}
  for each so_mstr where so_domain = global_domain
                     and so_nbr >= sonbr1 and so_nbr <= sonbr2 no-lock,
      each xxsovd_det where xxsovd_domain = global_domain
                        and xxsovd_nbr = so_nbr no-lock
      break by xxsovd_nbr:
      sono = so_nbr.
      ptpart = so_rmks.
      {gprun.i ""xxaddoldname.p"" "(input ptpart,output oldname)"} 
      vin = xxsovd_id.
      disp
      		sono           column-label "散件订单号"
					ptpart         column-label "散件成品编码"
					oldname        column-label "老车型"
					vin            column-label "VIN号"
			with frame b width 200 down attr-space.
			down with frame b.
			sono = "".
			ptpart = "".
			vin = "".
  end.	


	{mfreset.i}
	{mfgrptrm.i}
end. /*repeat*/
