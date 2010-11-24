/******************************************************************************/
/*name:装箱清单查询                                                           */
/*designed by Billy 2009-02-26                                                */
/******************************************************************************/

{mfdtitle.i "dd"}

define variable packno1 like xxvind_ZhuangXiang_NBR.
define variable packno2 like xxvind_ZhuangXiang_NBR.
define variable pkdate1 like xxabs_crt_date.
define variable pkdate2 like xxabs_crt_date.
define variable loaddate like xxabs_crt_date.
define variable pkno like xxabs_par_id.
define variable sodnbr like sod_nbr.
define variable sodline like sod_line.
define variable ptpart like pt_part.
define variable ptname like pt_desc1.
define variable loc like xxabs_loc.
define variable op like xxabs_op.
define variable subpkno like xxabs_pk_no.
define variable subno like xxabs_pk_qty.
define variable pkqty like xxabs_pk_per_qty.
define variable gwt like xxabs_gwt.
define variable nwt like xxabs_nwt.
define variable vol like xxabs_vol.

form
    loaddate       column-label "装箱日期"
		pkno           column-label "包装箱号"
		sodnbr         column-label "销售订单号"
		sodline        column-label "项次"
		ptpart         column-label "物料编号"
		ptname         column-label "物料名称"
		loc            column-label "库位"
		op             column-label "序号"
		subpkno        column-label "箱号"
	  subno          column-label "箱数"
	  pkqty          column-label "单箱数量"
	  gwt            column-label "毛重"
	  nwt            column-label "净重"
	  vol            column-label "体积"
with frame b width 300 down attr-space.

form
 packno1 COLON 15 label "包装箱号"
 packno2 COLON 49 label "至" skip
 pkdate1 colon 15 label "包装日期"
 pkdate2 colon 49 label "至" skip
WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.

repeat:
	if packno2 = hi_char then packno2 = "".
	if pkdate1 = low_date then pkdate1 = ?.
	if pkdate2 = hi_date then pkdate2 = ?.
  
	update
			packno1
			packno2
			pkdate1
			pkdate2
	with frame a.
			
			
	if packno2 = "" then packno2 = hi_char.
	if pkdate1 = ? then pkdate1 = low_date.
	if pkdate2 = ? then pkdate2 = hi_date.

	{mfselprt.i "printer" 132}
	
	for each xxabs_mstr use-index xxabs_par_id where xxabs_domain = global_domain
	                                             and xxabs_shipfrom = "12000"
	                                             and xxabs_par_id >= packno1 and xxabs_par_id <= packno2
	                                             and xxabs_crt_date >= pkdate1 and xxabs_crt_date <= pkdate2 no-lock,
	    each pt_mstr use-index pt_part where pt_domain = global_domain
	                                     and pt_part = xxabs_part no-lock
	    break by xxabs_par_id by xxabs_nbr:
	    	loaddate = xxabs_crt_date.
	    	pkno = xxabs_par_id.
	    	sodnbr = xxabs_nbr.
	    	sodline = xxabs_line.
	    	ptpart = xxabs_part.
	    	ptname = pt_desc1.
	    	loc = xxabs_loc.
	    	op = xxabs_op.
	    	subpkno = xxabs_pk_no.
	    	subno = xxabs_pk_qty.
	    	pkqty = xxabs_pk_per_qty.
	    	gwt = xxabs_gwt.
	    	nwt = xxabs_nwt.
	    	vol = xxabs_vol.
	    	disp
	    	      loaddate       column-label "装箱日期"
							pkno           column-label "包装箱号"
							sodnbr         column-label "销售订单号"
							sodline        column-label "项次"
							ptpart         column-label "物料编号"
							ptname         column-label "物料名称"
							loc            column-label "库位"
							op             column-label "序号"
							subpkno        column-label "箱号"
						  subno          column-label "箱数"
						  pkqty          column-label "单箱数量"
						  gwt            column-label "毛重"
						  nwt            column-label "净重"
						  vol            column-label "体积"
				with frame b.
				down with frame b.
				loaddate = ?.
				pkno = "".
				sodnbr = "".
				sodline = 0.
				ptpart = "".
				ptname = "".
				loc = "".
				op = "".
				subpkno = "".
				subno = 0.
				pkqty = 0.
				gwt = 0.
				nwt = 0.
				vol = 0.
   end.
	{mfreset.i}
	{mfgrptrm.i}
end. /*repeat*/
