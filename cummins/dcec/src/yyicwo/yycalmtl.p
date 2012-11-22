/*yycalmtl.p    Get material cost */
/*ss2012-8-15 升级*/
{mfdeclre.i}

def input parameter v_part like pt_part.
def input parameter v_site like pt_site.
def input parameter v_cost as deci format ">>>,>>>,>>9.99<<".
def input parameter v_qty as int.
def output parameter v_mtl_cost as deci format ">>>,>>>,>>9.99<<" init 0.
def output parameter v_lbr_cost as deci format ">>>,>>>,>>9.99<<" init 0.
def output parameter v_ovh_cost as deci format ">>>,>>>,>>9.99<<" init 0.

def var v_mtl like yywobmspt_elem_cost init 0.
def var v_lbr like yywobmspt_elem_cost init 0.
def var v_ovh like yywobmspt_elem_cost init 0.
def var v_costset as char.
def var v_costsite like pt_site.
find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error.
if not avail pt_mstr then do:
   v_mtl_cost = v_cost.
   return.
end.
/* 取标准成本 */
find first in_mstr where /*ss2012-8-15 b*/ in_mstr.in_domain = global_domain and /*ss2012-8-15 e*/ in_part = v_part and in_site = v_site 
					no-lock no-error.
v_costset = (if available in_mstr and in_gl_set <> "" then in_gl_set else "STANDARD").
v_costsite = (if available in_mstr and in_gl_set <> "" then in_gl_cost_site else v_site).		    
find first spt_det where /*ss2012-8-15 b*/ spt_det.spt_domain = global_domain and /*ss2012-8-15 e*/ spt_site = v_costsite
	and spt_part = v_part 
	and spt_sim = v_costset 
	and spt_element = "直接人工" no-lock no-error.
if avail spt_det then assign v_lbr = v_qty * (spt_cst_tl + spt_cst_ll).

find first spt_det where /*ss2012-8-15 b*/ spt_det.spt_domain = global_domain and /*ss2012-8-15 e*/ spt_site = v_costsite
	and spt_part = v_part 
	and spt_sim = v_costset 
	and spt_element = "制造费用" no-lock no-error.
if avail spt_det then assign v_ovh = v_qty * (spt_cst_tl + spt_cst_ll).

assign
   v_lbr_cost = v_lbr
   v_ovh_cost = v_ovh
   v_mtl_cost = v_cost - v_lbr - v_ovh.
