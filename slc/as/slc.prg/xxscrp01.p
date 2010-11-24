/*By: Neil Gao 08/11/12 ECO: *SS 20081112* */

/* DISPLAY TITLE */
{mfdtitle.i "n+ "}

define variable part like mrp_part.
define variable part2 like mrp_part.
define variable ord like mrp_rel_date.
define variable ord1 like mrp_rel_date.
define variable sonbr like so_nbr.
define variable sonbr1 like so_nbr.
define variable dscomp as logical.

form   
   sonbr			colon 15
   sonbr1   label {t001.i}              colon 45
   part				 colon 15
   part2 label {t001.i}		colon 45
   ord			colon 15   label "下单日期"
   ord1 label {t001.i}	colon 45 
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	sod_nbr  column-label "销售订单"
	xxcffw_nbr      column-label "审批次序"
	xxcf_desc       column-label "审批说明"
	xxcffw_check    column-label "审批"
	xxcffw_ck_id    format "x(10)" column-label "审批人"
	xxcffw_ck_date  column-label "审批日期"
with frame c down width 200 attr-space.


{wbrp01.i}

repeat on error undo, retry:
   
   if sonbr1 = hi_char then sonbr1 = "".
   if part2 = hi_char then part2 = "".
   if ord = low_date then ord = ?.
   if ord1 = hi_date then ord1 = ?.
   
   update    
   sonbr sonbr1
	 part part2
	 ord
	 ord1
   with frame a.

	 if sonbr1 = "" then sonbr1 = hi_char.
	 if part2 = "" then part2 = hi_char.
	 if ord = ? then ord = low_date.
	 if ord1 = ? then ord1 = hi_date.

   /* SELECT PRINTER */
	{mfselprt.i "printer" 132}

   for each xxcffw_mstr where xxcffw_key1 = "check" 
   			and xxcffw_key_nbr >= sonbr and xxcffw_key_nbr <= sonbr1
   			no-lock ,
   		each sod_det where sod_domain = global_domain /*and sod_confirm = no*/
   			and sod_nbr = xxcffw_key_nbr and sod_line = xxcffw_key_line 
   			and sod_part >= part and sod_part <= part2 
   			no-lock,
   		each so_mstr where so_domain = global_domain
   			and so_nbr = xxcffw_key_nbr 
				and so__log01  /*是否提交*/
   			and so_ord_date >= ord and so_ord_date <= ord1 no-lock,
      each xxcf_mstr where xxcf_nbr = xxcffw_nbr no-lock 
      break by xxcffw_key_nbr by xxcffw_nbr:  
        
        /*
        each xxcff_mstr where xxcff_key1 = "check"  no-lock,*/
     	if first-of(xxcffw_nbr) then do:   
        disp sod_nbr  column-label "销售订单"
	     /*xxcffw_key_line column-label "项次"*/
	     xxcffw_nbr      column-label "审批次序"
	     xxcf_desc       column-label "审批说明"
	     xxcffw_check    column-label "审批"
	     
	     xxcffw_ck_id    format "x(10)" column-label "审批人"
	     xxcffw_ck_date  column-label "审批日期"
	     with frame c.
	     down with frame c.
	    end.
   end.
   
   for each sod_det where sod_domain = global_domain and sod_nbr begins "C" 
   			and sod_nbr >= sonbr and sod_nbr <= sonbr1
   		/*and sod_confirm = no*/ and sod_part >= part and sod_part <= part2 no-lock,
   		each so_mstr where so_domain = global_domain and so_nbr = sod_nbr            
				/*and so__log01*/  /*是否提交*/
   			and so_ord_date >= ord and so_ord_date <= ord1 no-lock
   		break by sod_nbr :
   		
   		if first-of(sod_nbr) then do:
   			disp 	sod_nbr 
   						"散件订单确认" @ xxcf_desc
   						sod_confirm @ xxcffw_check
   			with frame c.
   			down with frame c.
   		end.
   		
   end.
  	{mfreset.i}
		{mfgrptrm.i}

end.

{wbrp04.i &frame-spec = a}
