/* SS - 090924.1 By: Neil Gao */

{mfdtitle.i "090924.1"}

define var entity like gltr_entity.
define var entity1 like gltr_entity.
define var ref    like gltr_ref.
define var ref1   like gltr_ref.
define var effdt  like gltr_eff_dt.
define var effdt1 like gltr_eff_dt.

form
	entity colon 15
	entity1 colon 48
	ref    colon 15
	ref1   colon 48
	effdt  colon 15
	effdt1 colon 48
with frame a side-labels width 80 attr-space.

setframelabels(frame a:handle).

entity = current_entity.
entity1 = current_entity.

Mainloop:
repeat:
	
	if entity1 = hi_char then entity1 = "".
	if ref1    = hi_char then ref1 = "".
	if effdt   = low_date then effdt = ?.
	if effdt1  = hi_date  then effdt1 = ?.
	
	update entity entity1 ref ref1 effdt effdt1 with frame a.
	
	if entity1 = "" then entity1 = hi_char.
	if ref1    = "" then ref1    = hi_char.
	if effdt   = ?  then effdt   = low_date.
	if effdt1  = ?  then effdt1  = hi_date.

	{mfselprt.i "printer" 132}
	
	for each gltr_hist use-index gltr_ent_dt where gltr_domain = global_domain 
		and gltr_entity >= entity and gltr_entity <= entity1 
		and gltr_ref >= ref and gltr_ref <= ref1 
		and gltr_eff_dt >= effdt and gltr_eff_dt <= effdt1 no-lock:
		find first sb_mstr where sb_domain = global_domain and sb_sub = gltr_sub no-lock no-error.
		
		disp 	gltr_ref 			column-label "总帐参考号"
					gltr_eff_dt   column-label "生效日期"
					gltr_desc 		column-label "摘要"
					gltr_amt when gltr_amt >= 0 	column-label "借方发生额"
					0  when gltr_amt < 0 @ gltr_amt
					( - gltr_amt )  when gltr_amt < 0		@	gltr_curramt			column-label "贷方发生额"
					0  when gltr_amt >= 0 @ gltr_curramt
					gltr_user 		column-label "用户标志"
					gltr_sub 			column-label "帐户"
					gltr_ctr 			column-label "成本中心"
					sb_desc	when avail sb_mstr	column-label "帐户名称"
		with stream-io width 200.
	end.
	
	{mfreset.i}
	{mfgrptrm.i}

end. /* mainloop */
